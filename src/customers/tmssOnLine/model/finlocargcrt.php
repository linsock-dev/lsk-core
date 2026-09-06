<?php
final class finlocargcrt extends tmssAction {
  private $data = array();
  protected $co_reg;
	private $cv_fledir;
	private $co_client_wsaa;
	private $co_client;
	const FILE_ROOT = '../files';
	const PRIVATE_PASS = 'TemasisArgentina';
 
  function __construct ( &$lp_reg ) {
		ini_set('soap.wsdl_cache_enabled', '0');
    $this->co_reg = $lp_reg; 
		$this->cv_fledir = self::FILE_ROOT .chr(47). strtoupper($this->co_reg->sec->buscod) .chr(47). 'ARG' .chr(47);
		$this->errtyp = '';
		$this->errcod = 0;
		$this->errtxt = '';

		$this->token 	= '';
		$this->sign 	= '';
  }
	function __get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function getData(){ return $this->data; }
	function getsysdata( $lp_key ) { return ( isset($this->sysdata[$lp_key]) ? $this->sysdata[$lp_key] : '' ); }
	function __set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function setData( $lp_dat=array() ) { $this->data = $lp_dat; }	
	
	// callWSAA
	// realiza el login al WS de AFIP
	// parámetros:
	//   service. string con el nombre del servicio
	//   
	function callWSAA( $lp_service, $lp_url, $lp_url_wsdl, $lp_sign ) {
		
		$lv_file_wsdl = $this->cv_fledir.'AFIP_WSAA_'.$lp_service.'.wsdl';
		if( !file_exists($lv_file_wsdl) && $lp_url_wsdl!='' ) {
			
			try{
				$lv_wsdl = file_get_contents( $lp_url_wsdl );
			} catch(Exception $e){
				$this->errtxt = 'Error al obtener la definicion del servicio WSDL 2.['.$lp_url_wsdl.'] '.$e->getMessage();
				$this->errcod = $e->getCode();
				$this->errtyp = 'E';
				return false;
				// no se pudo obtener la definicion del servicio WSDL
			}
			if (!is_string($lv_wsdl) || !strlen($lv_wsdl)) {
				$this->errtxt = 'Error al obtener la definicion del servicio WSDL 3.['.$lp_url_wsdl.']';
				$this->errcod = -1;
				$this->errtyp = 'E';
				return false;
			}

			if( !file_put_contents($lv_file_wsdl, $lv_wsdl) ){
				$this->errtxt = 'No se pudo escribir el token de acceso AFIP en carpeta de archivos de empresa.['.$lp_url_wsdl.']';
				$this->errcod = -1;
				$this->errtyp = 'E';
				return false;
			}
		}
		
		if (!extension_loaded('soap')) {
			$this->errtxt = 'No se encuentra habilitada la extension SOAP.';
			$this->errcod = -1;
			$this->errtyp = 'E';
			return false;
		}

		// creo un cliente SOAP
		$this->co_client_wsaa = new SoapClient($lv_file_wsdl, array(
			//'proxy_host'     => PROXY_HOST,
			//'proxy_port'     => PROXY_PORT,
			'soap_version'   => SOAP_1_2,
			'location'       => $lp_url,
			'trace'          => 1,
			'exceptions'     => 0
		)); 
		
		// llamada a LOGIN AFIP
		$lo_ret = $this->co_client_wsaa->loginCms(array('in0'=>$lp_sign));
		
		// verifico falla en llamada a servicio
		if (is_soap_fault($lo_ret)) {
			if( $lo_ret->faultcode=='ns1:coe.alreadyAuthenticated' ) {
				return true;
			} else {
				$this->errtyp = 'E';
				$this->errcod = $lo_ret->faultcode;
				$this->errtxt = $lo_ret->faultstring;
				return false;
			}
		}
		
		// grabo el ticket para no hacer llamadas innecesarias
		file_put_contents( $this->cv_fledir.'AFIP_WSAA_'.$lp_service.'_TA.xml', $lo_ret->loginCmsReturn );

		// get token and sign
		$lv_xml = simplexml_load_string($lo_ret->loginCmsReturn);
		$this->token = (string)$lv_xml->credentials->token;
		$this->sign  = (string)$lv_xml->credentials->sign;
		
		return true;
	}
	
	// getAuthTicket
	// devuelve un string XML con los datos requeridos para solicitar un token de autorizacion a AFIP
	// el ticket será válido por 1 hora (60 minutos)
	// parámetros array:
	//  - service (requerido) nombre del servicio (ie. dummy)
	function getAuthTicket( $lp_service ) {
		$lv_srv = strtoupper($lp_service);
		if( file_exists( $this->cv_fledir.'AFIP_WSAA_'.$lv_srv.'_TA.xml' ) ) {
			$lo_tkt = new SimpleXMLElement( file_get_contents($this->cv_fledir.'AFIP_WSAA_'.$lv_srv.'_TA.xml') );
			$lv_tmeact	= new DateTime(date('c',date('U')));
			$lv_tmeexp	= new DateTime($lo_tkt->header->expirationTime);
			if ($lv_tmeact < $lv_tmeexp) { 
				$this->token = (string)$lo_tkt->credentials->token;
				$this->sign = (string)$lo_tkt->credentials->sign;
				return true; 
			} else {
				unlink( $this->cv_fledir.'AFIP_WSAA_'.$lv_srv.'_TA.xml' );
			}
		}
		return false;
	}
	
	// createAuthTicket
	// crea un nuevo XML para solicitar un token de autorizacion a AFIP
	// el ticket será válido por 1 hora (60 minutos)
	// parámetros array:
	//  - service (requerido) nombre del servicio (ie. dummy)
	//	- cuit (requerido) cuit de la empresa (ie. 30716290545)
	//	- env (opcional) flag que indica si el entorno es wsaahomo-desarrollo o wsaa-productivo (default)
	//	- cn (opcional) CN del certificado a usar (ie. temasis ws)
	function createAuthTicket( $lp_arr=array() ) {
		$lv_srv = (isset($lp_arr['service'])?$lp_arr['service']:'');
		if($lv_srv==''){ return false; }
		$lv_cuit = (isset($lp_arr['cuit'])?$lp_arr['cuit']:'');
		$lv_env = (isset($lp_arr['env'])?$lp_arr['env']:'wsaa');
		$lv_cn = (isset($lp_arr['cn'])?$lp_arr['cn']:'');
		
		$lo_xml = new SimpleXMLElement('<'.'?xml version="1.0" encoding="UTF-8"?'.'><loginTicketRequest version="1.0"></loginTicketRequest>');
		$lo_xml->addChild('header');
		if($lv_cuit!='' && $lv_cn!=''){
			$lo_xml->header->addChild('source', 'SERIALNUMBER=CUIT '.trim($lv_cuit).', CN='.$lv_cn );
		}
		$lo_xml->header->addChild('uniqueId',date('U'));
		$lo_xml->header->addChild('generationTime',date('c',date('U')-600));
		$lo_xml->header->addChild('expirationTime',date('c',date('U')+600));
		$lo_xml->addChild('service',$lv_srv);
		$lo_xml->asXML( $this->cv_fledir.'AFIP_WSAA_'.strtoupper($lv_srv).'_REQ_TA.xml' );
		return true;
	}
	
	// signAuthTicket
	// hace la firma PKCS#7 usando el XML como datos de entrada, CERT y #PRIVATEKEY para firmar.
	// Genera un archivo intermedio y finalmente recorta el #Encabezado MIME dejando el CMS final requerido por WSAA.
	// parámetro:
	//   srv. nombre del servicio (i.e. dummy)
	function signAuthTicket( $lp_srv ) {
		$lv_xml = realpath($this->cv_fledir.'AFIP_WSAA_'.$lp_srv.'_REQ_TA.xml');
		$lv_tmp = realpath($this->cv_fledir).chr(92).'AFIP_WSAA_'.$lp_srv.'.tmp';
		$lv_pem = 'file://'.realpath($this->cv_fledir.'AFIP_WSAA.pem');
		$lv_prv = 'file://'.realpath($this->cv_fledir.'AFIP_WSAA.prv');
		$lv_prvarr = array($lv_prv, self::PRIVATE_PASS);

		if(!file_exists($lv_xml)){
			$this->errtyp = 'E';
			$this->errcod = -1;
			$this->errtxt = 'signAuthTicket: ERROR file AFIP_WSAA_'.$lp_srv.'_REQ_TA.xml not exists.';
			return false;
		}
		
		if(!file_exists($lv_pem)){
			$this->errtyp = 'E';
			$this->errcod = -1;
			$this->errtxt = 'signAuthTicket: ERROR file AFIP_WSAA.pem not exists.';
			return false;
		}
		
		if(!file_exists($lv_prv)){
			$this->errtyp = 'E';
			$this->errcod = -1;
			$this->errtxt = 'signAuthTicket: ERROR file AFIP_WSAA.prv not exists.';
			return false;
		}
		
		$lv_stat = @openssl_pkcs7_sign($lv_xml, $lv_tmp, $lv_pem, $lv_prvarr, array(), !PKCS7_DETACHED);
		if (!$lv_stat) {
			$this->errtyp = 'E';
			$this->errcod = -1;
			$this->errtxt = 'signAuthTicket: ERROR generating PKCS#7 signature.';
			return false;
		}
		
		try{
			$lv_dat = fopen( $lv_tmp, 'r');
			$i = 0;
			$lv_ret = '';
			while (!feof($lv_dat)) { 
				$lv_buffer = fgets($lv_dat);
				if ( $i++ >= 4 ) {$lv_ret .= $lv_buffer;}
			}
			fclose($lv_dat);		
			unlink( $lv_tmp );
		} catch(Exception $e){
			$this->errtyp = 'E';
			$this->errcod = -1;
			$this->errtxt = 'signAuthTicket: ERROR recuperando firma digital.';
			return false;			
		}
		
		return $lv_ret;
	}
	
	// getAuthRequest
	// devuelve el contenido del archivo de solicitud de certificado AFIP - WSAA
	function getAuthRequest( ) {
		if( file_exists( $this->cv_fledir.'AFIP_WSAA.csr' ) ) {
			return file_get_contents( $this->cv_fledir.'AFIP_WSAA.csr' );
		} else {
			return '';
		}
	}
	
	// setAuthCertificate
	// genera una solicitud de certificado .PEM
	// parámetros:
	//    array:  Nombre Distinguido que se va a usar en el certificado
	// 						C=<lndcod>, O=<bustxt>, SERIALNUMBER=CUIT <taxcod>, CN=<buscod>.temasis.com.ar
	function setAuthRequest( $lp_dat=array() ) {
		
		$lv_cfg = array(
				//'config' => $opensslConfigPath,
				'digest_alg' => 'sha512', //'sha1'
				'private_key_bits' => 4096, //2048,
				'private_key_type' => OPENSSL_KEYTYPE_RSA,
		);
				
		// Generar una nueva pareja de clave privada (y pública)
		$lv_prvkey = openssl_pkey_new( $lv_cfg );
		if($lv_prvkey==false){
			return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>'.openssl_error_string().'</errtxt>';
		}
		
		// Generar una petición de firma de certificado
		$lv_csr = openssl_csr_new($lp_dat, $lv_prvkey);
		if($lv_csr==false){
			return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>'.openssl_error_string().'</errtxt>';
		}
		
		// genera la clave privada (.prv)
		openssl_pkey_export($lv_prvkey, $lv_prvkeyout, self::PRIVATE_PASS);
		if( file_exists( $this->cv_fledir.'AFIP_WSAA.prv' ) ) {
			rename( $this->cv_fledir.'AFIP_WSAA.prv', $this->cv_fledir.'AFIP_WSAA_20190423105400.prv' );
		}
		file_put_contents( $this->cv_fledir.'AFIP_WSAA.prv', $lv_prvkeyout );
		
		// genera la solicitud de certificado (.csr)
		openssl_csr_export($lv_csr, $lv_csrout);		
		if( file_exists( $this->cv_fledir.'AFIP_WSAA.csr' ) ) {
			rename( $this->cv_fledir.'AFIP_WSAA.csr', $this->cv_fledir.'AFIP_WSAA_20190423105400.csr' );
		}
		file_put_contents( $this->cv_fledir.'AFIP_WSAA.csr', $lv_csrout );
		
		return $lv_csrout;
	}	
	
	
	
	// getAuthCertificate
	// devuelve el contenido del certificado provisto por AFIP - WSAA
	function getAuthCertificate( ) {
		if( file_exists( $this->cv_fledir.'AFIP_WSAA.pem' ) ) {
			return file_get_contents( $this->cv_fledir.'AFIP_WSAA.pem' );
		} else {
			return '';
		}
	}
	
	// setAuthCertificate
	// grabar el archivo de certificado provisto por AFIP - WSAA
	// parámetros:
	//    string. string del certificado
	function setAuthCertificate( $lp_dat ) {
		if( file_exists( $this->cv_fledir.'AFIP_WSAA.pem' ) ) {
			rename( $this->cv_fledir.'AFIP_WSAA.pem', $this->cv_fledir.'AFIP_WSAA_20190423114800.pem' );
		}
		file_put_contents( $this->cv_fledir.'AFIP_WSAA.pem', $lp_dat );
	}


	function validateCert($lp_cuit){

		$lv_pem = 'file://'.realpath($this->cv_fledir.'AFIP_WSAA.pem');
		$lv_prv = 'file://'.realpath($this->cv_fledir.'AFIP_WSAA.prv');

		// Check if private key file exists
		if(!file_exists($lv_prv)){
			return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>Error: no existe el archivo de clave privada '.$lv_pem.'</errtxt>';
		}
		// Open private key file
		$pkey_file = fopen($lv_prv, "r");
		if($pkey_file === false){
			return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>Error: error abriendo el archivo de clave privada '.$lv_pem.'</errtxt>';
		};
		// Read private key file
		$pkey_cont = fread($pkey_file,filesize($lv_prv));
		if($pkey_cont === false){
			return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>Error: error leyendo el archivo de clave privada '.$lv_pem.'</errtxt>';
		};

		// Check if certificate file exists
		if(!file_exists($lv_pem)){
			return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>Error: no existe el archivo del certificado '.$lv_pem.'</errtxt>';
		}
		// Open certificate file
		$cert_file = fopen($lv_pem, "r");
		if($cert_file === false){
			return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>Error: error abriendo el archivo del certificado '.$lv_pem.'</errtxt>';
		}
		// Read certificate file
		$cert_cont = fread($cert_file,filesize($lv_pem));
		if($cert_cont === false){
			return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>Error: error leyendo el archivo del certificado '.$lv_pem.'</errtxt>';
		}

		// Validate if certificate and private key matches
		$cert_val = openssl_x509_check_private_key($cert_cont,array($pkey_cont,self::PRIVATE_PASS));
		if(!$cert_val){
			return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>Error: el certificado y clave privada no coinciden </errtxt>';
		}

		// Check if CUIT is ok 
		$cert_struct = openssl_x509_parse ($cert_cont);
		if($cert_struct['subject']['serialNumber'] != "CUIT ".$lp_cuit){
			return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>Error: el certificado y cuit no coinciden '.$cert_struct['subject']['serialNumber'].'</errtxt>';
		}

		return true;
	}
}
?>
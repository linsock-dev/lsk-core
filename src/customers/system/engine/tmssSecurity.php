<?php
//require_once('tmssSecurityAES.php');
require_once('tmssSecurityCustomers.php');

final class tmssSecurity {
	
  const SECRET_KEY = '0wwwt3m4s1sc0m4r';
  //const LOGIN_TIMEOUT = 600; //1800; // ( 30min * 60sec )  =======>>>>>> HACERLO PARAMETRO X EMPRESA
  private $data = array();
  private $co_reg;
	private $sub = array();
	private $per = array();
	private $co_init=false;
	private $co_timeout = array();
  
  // CONSTRUCTOR. obtiene valores iniciales del objeto $_SESSION
  function __construct( &$lp_reg ) {
    $this->co_reg = $lp_reg;
		$this->co_timeout = tmssSecurityCustomers::getTimeout();
  }
	
	// GET - SET metodos 
  function __get($lp_key) { return $this->get($lp_key); }
  function get($lp_key) { return $this->co_reg->session->get('tmss_'.$lp_key); }
  function __set($lp_key, $lp_dat) { $this->set($lp_key, $lp_dat); }
  function set($lp_key, $lp_val) { $this->co_reg->session->set('tmss_'.$lp_key, $lp_val); }
  	
	
  
  // INITIALIZE. obtiene todos los programas y operaciones que tienen habilitadas el usuario
  public function initialize( $lp_prm=array() ) {

		// OPERACIONES SUSCRIPTAS. obtengo las operaciones suscriptas de la empresa
		$lo_sysfncsub = $this->co_reg->load->model('sysfncsub');
		$lv_prm = array('cuscodext'=>$lp_prm['buscod']);
		$lo_rs = $lo_sysfncsub->getOperationsList(null,$lv_prm);
		$lo_sub = array();
		foreach($lo_rs as $lv_row){
			$lv_key = strtolower($lv_row['mdlcod'].'_'.$lv_row['prgcod'].'_'.$lv_row['oprcod']);
			if(!isset($lo_sub[$lv_key])){ $lo_sub[$lv_key]=1; }
		}

		// SUSCCRIPCIONES. obtengo lista de suscripciones del cliente
		$lv_prm = array('vewfldflt' =>'[~fltrow~]getdate()'.chr(9).'BT'.chr(9).'f.sysfncsubstrdte'.chr(9).'f.sysfncsubenddte'.chr(9).chr(9).
																	'[~fltrow~]c.cuscodext'.chr(9).'='.chr(9).chr(9).$lp_prm['buscod'].chr(9).chr(9).
																	'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																	);
		$lo_rs = $lo_sysfncsub->getList($lv_prm);
    
		$this->sub = array();
		foreach($lo_rs as $lv_row){
			if($lv_row['sysfnccodext']!='' && !isset($this->sub[$lv_row['sysfnccodext']]) ){
				$this->sub[ $lv_row['sysfnccodext'] ] = array('sysfnccod'=>$lv_row['sysfnccod'], 'sysfnccodext'=>$lv_row['sysfnccodext'], 'sysfnctxt'=>$lv_row['sysfnctxt'], 'sysfncmdlcod'=>$lv_row['sysfncmdlcod']);
			}
		}
		
		// PERMISOS. obtengo los permisos del usuario
		$lo_syssecper = $this->co_reg->load->model('syssecper');
		$lo_per_rs = $lo_syssecper->getUserPermissions(null,$lp_prm);

		// quito los permisos que no están suscriptos
		$this->per = [];
		foreach($lo_per_rs as $lv_rowper) {
			$lv_key = strtolower($lv_rowper['mdlcod'].'_'.$lv_rowper['prgcod'].'_'.$lv_rowper['oprcod']);
			if( isset($lo_sub[$lv_key]) && !isset($this->per[$lv_key]) ){ $this->per[$lv_key]=$lv_rowper; }
		}
		$this->co_init = true;
	}
	
	
	// HAS SUSCRIPTION. verifica si la empresa tiene una suscripción específica (codigo externo)
	public function hasSuscription( $lp_sysfnccodext ){
		// si no hay suscripciones las obtengo
		if ( $this->co_init==false ) { $this->initialize( array('usrcod'=>$this->usrcod, 'buscod'=>$this->buscod) ); }
		return isset($this->sub[$lp_sysfnccodext]);
	}
	
	
  // HAS PERMISSION. verifica si el usuario tiene permiso para una operacion
  public function hasPermission( $lp_mdlcod, $lp_prgcod, $lp_oprcod='**', $lp_objcod='' ) {
		// si no hay permisos los obtengo
		if ( $this->co_init==false ) { $this->initialize( array('usrcod'=>$this->usrcod, 'buscod'=>$this->buscod) );}
		// busco si el usuario tiene algun permiso para el programa y/u operación
		$lv_key = strtolower($lp_mdlcod.'_'.$lp_prgcod.'_'.$lp_oprcod);
		return isset($this->per[$lv_key]);
		/********************************************/
		/* FALTA: buscar por objeto de autorización */
		/********************************************/
  }
	
	
  /**
   * isLogged
	 * verifica si el usuario está logueado
   */       
  public function isLogged( $lp_only_check=false ) {
		// determino si los datos de sesión se destruyeron
		if ( $this->getToken()=='' ) {
			// obtengo los datos de sesión desde la URL (parámetro token)
			$lv_ret = $this->getUrlToken();
			if ( $lv_ret['errcod']!=0 ) { return false; }
		}
		// verifico si no se pudo obtener el token (desde la sesión o desde la URL)
    if ( $this->getToken()=='' ) {
      return false;
		// verifico si el tiempo de sesión caducó y limpio los datos de sesión actuales (se recuperan desde el popup de sesión expirada)
    } else if ( $this->timeout < time() ) {
      $this->usrcod=''; 
      $this->usrtxt='';
      $this->buscod=''; 
      $this->bustxt='';
      //$this->bseurl='';
      $this->bsecnx='';
      return false;
    } else {
			// extiendo el tiempo de sesión (porque hay actividad)
			if($lp_only_check==false){
				$this->timeout = time() + (isset($this->co_timeout[$this->buscod])?$this->co_timeout[$this->buscod]:$this->co_timeout['']);
				//$this->timeout = time() + self::LOGIN_TIMEOUT;
			}
      return true;
    }
  }
	
	
	/**
	 * getToken
	 * obtiene el token a partir de los datos de sesión actuales
	 * Arma una cadena codificada (token) que contiene información encriptada basica de la seguridad del sistema
	 * Este token se utiliza en la URL del sistema para desencriptar cuando la sesión del servidor se destruye
	 */
  public function getToken() {
		// verifico si todos los valores fueron establecidos para armar el token
    if ( $this->usrcod=='' || $this->usrtxt=='' ||
         $this->buscod=='' || $this->bustxt=='' ||
         $this->bseurl=='' || $this->bsecnx=='' ) {
      return '';
    } else {
			// armo el token
      $lv_key = $this->usrcod.'|'.$this->usrtxt.'|'.$this->buscod.'|'.$this->bustxt.'|'.$this->bseurl.'|'.$this->bsecnx;
			// encripto el token
      $lv_tkn = $this->encrypt ( $lv_key , self::SECRET_KEY );
      return $this->normalizeToken( 1, $lv_tkn );
    }
  }
	
	
	/**
	 * getUrlToken
	 * obtiene a partir de la URL todos los datos del token (desencriptados y en un array)
	 */
  public function getUrlToken() {
    // obtengo token desde la URL
    if ( !isset($this->co_reg->request->get['token']) ) {
			return array('errcod'=>-1, 'errtxt'=>'No se pudo obtener el token.');
    } else {
      $lv_tkn = $this->co_reg->request->get['token'];
      $lv_tkn = $this->normalizeToken( 2, $lv_tkn );
    }
    // desencripto token
    $lv_tkntxt = $this->decrypt( $lv_tkn , self::SECRET_KEY );
    // armo el array
    $lv_tknarr = explode( '|' , $lv_tkntxt );
    // verifico si el array está completo
    if ( count($lv_tknarr)!=6 ) {
			return array('errcod'=>-8, 'errtxt'=>'Token invalido ['.count($lv_tknarr).' / '.$lv_tkntxt.']');
    }
    // asigno los valores del array a elementos de array (de array posicional a array clave-valor)
		$lv_ret['errcod'] = 0;
		$lv_ret['errtxt'] = 0;		
    $lv_ret['usrcod'] = $lv_tknarr[0];
    $lv_ret['usrtxt'] = $lv_tknarr[1];
    $lv_ret['buscod'] = $lv_tknarr[2];
    $lv_ret['bustxt'] = $lv_tknarr[3];
    $lv_ret['bseurl'] = $lv_tknarr[4];
    $lv_ret['bsecnx'] = $lv_tknarr[5];
    // verifico si todos los componentes tienen valores
    if ( $lv_ret['usrcod']=='' || $lv_ret['usrtxt']=='' || $lv_ret['buscod']=='' || $lv_ret['bustxt']=='' || $lv_ret['bseurl']=='' || $lv_ret['bsecnx']=='' ) {
      return array('errcod'=>-9, 'errtxt'=>'Token invalido');
    }
    return $lv_ret;
  }
	
	
  /**
   * normalizeToken
	 * función para normalizar la cadena quitando o agregando caracteres especiales
	 * parametro: (1) token to url // (2) token from url
   */        
  private function normalizeToken( $lp_typ, $lp_tkn ) {
    if ( $lp_typ==1 ) {
      return str_replace( '+', '/43/', $lp_tkn );
    } else {
      return str_replace( '/43/', '+', $lp_tkn );
    }
  }
	
	
	/**
	 * encrypt
	 * función para encriptar una cadena
	 */
	function encrypt( $lp_data, $lp_password, $lp_salt='!kQm*fF3pXe1Kbm%9') {
		$lv_iv = hex2bin('e2d46b59e51f234874b95b0f97922c79'); // fixed random bytes
		$lv_encrypt = openssl_encrypt( $lp_data, 'AES-256-OFB', $lp_password, OPENSSL_ZERO_PADDING, $lv_iv );
		return $lv_encrypt;
	} 
	
	
	/**
	 * decrypt
	 * función para desencriptar una cadena
	 */
	function decrypt( $lp_data, $lp_password, $lp_salt='!kQm*fF3pXe1Kbm%9') {		
		$lv_iv = hex2bin('e2d46b59e51f234874b95b0f97922c79'); // fixed random bytes
		$lv_decrypted = openssl_decrypt( $lp_data, 'AES-256-OFB', $lp_password, OPENSSL_ZERO_PADDING, $lv_iv );
		return $lv_decrypted;
	}
	
	
	/**
	 * is_ssl
	 * verifica si la conexión es SSL
	 */
	public function is_ssl() {
    if ( isset($_SERVER['HTTPS']) ) {
        if ( 'on' == strtolower($_SERVER['HTTPS']) )
            return true;
        if ( '1' == $_SERVER['HTTPS'] )
            return true;
    } elseif ( isset($_SERVER['SERVER_PORT']) && ( '443' == $_SERVER['SERVER_PORT'] ) ) {
        return true;
    }
    return false;
	}
  
	//valida la url de la empesa si es valida 
  public function validateBusinessConnection() {
    // Parse URL para obtener los segmentos 
		$lv_url = parse_url($_SERVER['REQUEST_URI']);
    $lv_paths = array_slice(explode('/', strtolower($lv_url['path'])), 1);

    // VALIDA LA EMPRESA ESPECIFICADA EN LA URL
    // e.g., https://customers.gorse.ar/gorse.php/<business>
    $lv_minRootLevels = 2;
    if (count($lv_paths) < $lv_minRootLevels || empty($lv_paths[1])) {
        //showErrorMessage('Error al obtener empresa', 'No se especific&oacute; una empresa.');
      return false;
    }
    // GET detalles de conexion de la empresa 
    $lv_buscodcus = $lv_paths[1];
    $lv_busdat = $this->getBussinessConnection($lv_buscodcus);

    if ($lv_busdat === null) {
        //showErrorMessage('Error al validar empresa', 'No se encontraron datos de la empresa [' . htmlspecialchars($businessCustomerCode) . '].');
    		return false;
    }

    // Set security and language context based on business data
    $this->co_reg->sec->bsecnx = $lv_busdat['bsecnx'];
    $this->co_reg->sec->buscodcus = $lv_buscodcus;

    // Construct the base URL for the business
    $lv_busdat['bseurl'] = 'http' . (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 's' : '') . '://' . $_SERVER['SERVER_NAME'] . '/' . implode('/', array_slice($lv_paths, 0, 2));
    
    // Normalize server name for use in headers/local storage keys
    $lv_normalizeServerName = function($e) { return ucfirst($e); };
    $lv_normalizedServerName = implode('.', array_map($lv_normalizeServerName, explode('.', $_SERVER['SERVER_NAME'])));

    // Store business data and normalized server name in the registry for later use
    $this->co_reg->set('business_data', $lv_busdat);
    $this->co_reg->set('svnme', $lv_normalizedServerName);
    return true;
	}
  
  //obtiene los datos de la empresa segun el codigo de cliente 
  private function getBussinessConnection(string $lp_buscodcus){
    $lo_cfg=$this->get("config");
    if($lo_cfg!=null){
      $lv_cus_arr = $lo_cfg->get('customers');
      $lp_buscodcus = strtolower($lp_buscodcus);

      if (isset($lv_cus_arr[$lp_buscodcus])) {
          $lv_cusdat = $lv_cus_arr[$lp_buscodcus];
          // Ensure all required keys exist
          if (!empty($lv_cusdat['buscod']) && !empty($lv_cusdat['title']) &&
              isset($lv_cusdat['subtitle']) && !empty($lv_cusdat['picture']) &&
              !empty($lv_cusdat['connection']) && !empty($lv_cusdat['environmet']) ) {
            return [
                'buscod' => $lv_cusdat['buscod'],
                'buscodcus' => $lp_buscodcus,
                'title' => $lv_cusdat['title'],
                'subtitle' => $lv_cusdat['subtitle'],
                'picture' => $lv_cusdat['picture'],
                'bsecnx' => $lv_cusdat['connection'],
                'environmet' => $lv_cusdat['environmet']
            ];
        }
      }
      return null;
    }
  }
  
}

?>
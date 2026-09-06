<?php
final class admsgnController extends tmssController { 

	const CONTROLLER = 'admsgn';
	const MODEL = 'admsgn';
	const VIEW  = 'admsgn';
	const ID = 'sgncod';
  const OBJTYP ='ADM_SGN';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();

  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }


  //	main method
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
    
    // cargo el modelo que voy a utilizar
    $lo_mdlprm = $this->co_reg->load->model('sysappmdlprm');

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
			
			// LIST
      case '#': case '#08': case'#98': case '#03':
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');

				// FIRMA ACTUAL. obtener del registro de firmas la firma valida de la persona que esta ingresando en el sistema
				$lv_prm =array('vewfldflt'=>'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																		'[~fltrow~]s.sgnduedte'.chr(9).'ZZ'.chr(9).'>='.chr(9).'getdate()'.chr(9).chr(9).
																		'[~fltrow~]s.cteusr'.chr(9).'='.chr(9).chr(9). $this->co_reg->sec->usrcod .chr(9).chr(9));
				$lo_rs = $this->lo_mdl->getList( $lv_prm );

				// si la persona tiene firma
				if(count($lo_rs)>0){
					$this->lo_mdl->ctedte = $lo_rs[0]['ctedte'];
					$this->lo_mdl->cteusr = $lo_rs[0]['cteusr'];
					$this->lo_mdl->usrtxt = $lo_rs[0]['usrtxt'];
					$this->lo_mdl->sgnini = $lo_rs[0]['sgnini'];
					$this->lo_mdl->sgncod = $lo_rs[0]['sgncod'];
					$this->lo_mdl->sgnduedte = $lo_rs[0]['sgnduedte'];
					// cargo la clase de documento que corresponde a la firma
					$lo_docclsmdl->load(array('sysdocclscod'=>$lo_rs[0]['sysdocclscod']));
				} else {
					$this->lo_mdl->ctedte = new Datetime();
					$this->lo_mdl->sgnduedte = new Datetime();
				}

				$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			
      // SAVE
      case '#00':
				$lo_post = $this->co_reg->request->post;
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_grldatuplmdl=$this->co_reg->load->model('grldatupl');
        //var_dump($lo_grldatuplmdl->getData());
				$lv_dte = new Datetime();
				$lo_post['sgndte'] = $lv_dte->format('d/m/Y');

				// EMPRESA. obetngo datos de empresa
				$lo_admbusmdl=$this->co_reg->load->model('admbus');
				$lo_admbusmdl->load(array('buscod'=>$this->co_reg->sec->buscod), false );
        //var_dump($lo_admbusmdl->getData());
				// USUARIO. obtengo datos de usuario
				$lo_syssecusrmdl=$this->co_reg->load->model('syssecusr');
				$lo_syssecusrmdl->load(array('usrcod'=>$this->co_reg->sec->usrcod));
				
				// INICIALES. crea iniciales
				if($lo_post['sgnini']==''){
					$lv_sgnini = str_ireplace(',','',$lo_post['usrtxt']);
					$lv_sgnini = explode(' ',$lv_sgnini);
					foreach($lv_sgnini as $lv_key){ $lo_post['sgnini'].=substr($lv_key,0,1);}
				}
				
				// CERTIFICADO FIRMANTE. obtiene el certificado firmante
				$lv_prm=array('vewfldflt'=>'[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9).'ADM_BUS'.chr(9).chr(9).
																		'[~fltrow~]f.flesrccod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->buscod.chr(9).chr(9).
																		'[~fltrow~]f.fleduedte'.chr(9).'ZZ'.chr(9).'>='.chr(9).'getdate()'.chr(9).chr(9). //fecha de vencimiento
																		'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9). // Que esten activas
																		'[~fltrow~]ft.fletypcodext'.chr(9).'='.chr(9).chr(9).'SSL'.chr(9).chr(9).
																		'[~fltrow~]ft.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)); // Carga los datos de documentos principal activas
				$lo_rscacert=$lo_grldatuplmdl->getList($lv_prm);
        //return $this->co_reg->document->getJson($lo_rscacert);
        
        
				if(count($lo_rscacert)==0){
				//	return '<errcod>-1</errcod><errtxt>No se encontro un certificado firmante valido para la empresa.</errtxt>';
					$lv_cacuscrt = '';
				} else {
					$lv_cacuscrt = $lo_rscacert[0]['flecod'];
          //var_dump($lv_cacuscrt);
				//	$lv_cacert=$lo_grldatuplmdl->getFileContents($lo_rscacert[0]['flecod']);
				}

				// CERTIFICADO FIRMANTE CLAVE. obtiene la clave privada del certificado firmante
				$lv_prm=array('vewfldflt'=>'[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9).'ADM_BUS'.chr(9).chr(9).
																		//'[~fltrow~]f.flesrccod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->buscod.chr(9).chr(9).
																		'[~fltrow~]f.fleduedte'.chr(9).'ZZ'.chr(9).'>='.chr(9).'getdate()'.chr(9).chr(9).
																		'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																		'[~fltrow~]ft.fletypcodext'.chr(9).'='.chr(9).chr(9).'SSL_KEY'.chr(9).chr(9).
																		'[~fltrow~]ft.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
				$lo_rscacertkey=$lo_grldatuplmdl->getList($lv_prm);
        
				if(count($lo_rscacertkey)==0){
					//return '<errcod>-1</errcod><errtxt>No se encontro la clave del certificado firmante.</errtxt>';
					$lv_cacuspem = '';
				} else {
					$lv_cacuspem = $lo_rscacertkey[0]['flecod'];
				//	$lv_cacertkey=$lo_grldatuplmdl->getFileContents($lo_rscacertkey[0]['flecod']);
				}
				
				// CERTIFICADO FIRMANTE CONTRASEÑA. obtiene la contraseña de la clave privada
				$lv_cacuspwd = '@Temasis21';
				
				
				// GRABAR. graba el registro de firma
		    if ( $this->lo_mdl->save( $lo_post )==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				}
				
				// IMAGEN. sube la imagen de la firma
				$lo_ctr = $this->co_reg->load->controller('grldatupl');
				$this->co_reg->request->post['flesrctyp'] = 'ADM_SGN';
				$this->co_reg->request->post['flesrccod'] = $this->lo_mdl->sgncod;
				$lo_ctr->index('uploadImage');

				// RECARGAR FIRMA. vuelve a cargar los datos de la firma
				$this->lo_mdl->load( array(	'sgncod'=>$this->lo_mdl->sgncod	) );

				// CLASE DE DOCUMENTO. carga la clase de documento
				if($lo_docclsmdl->load(array('sysdocclscod'=>$this->lo_mdl->sysdocclscod))){
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}

				// CERTIFICADO. crea el certificado				
				// DN. completa información del nombre distinguido
				$lv_dn=array(					
					'commonName'=>$lo_syssecusrmdl->usrtxt
					
					,'uid'=>$lo_syssecusrmdl->usrcod
					,'title'=>$lo_post['sgnini']
					
					,'organizationalUnitName'=>$lo_admbusmdl->buscod
					,'organizationName'=>$lo_admbusmdl->bustxt
					,'countryName'=>$lo_admbusmdl->adr->lndcod
					,'emailAddress'=>$lo_syssecusrmdl->adr->adreml
				);
				// VENCIMIENTO. determina vencimiento del certificado
				$lv_dayqty = $this->co_reg->document->getTagValue($this->lo_mdl->sysdoccls->sysdocclsatr,'sgnduedayqty');
				
				// CLAVE PRIVADA. genrar una nueva pareja de clave privada (y pública)
				$lv_prvkey = openssl_pkey_new();
				
				// SOLICITUD DE FIRMA. genera una petición de firma de certificado
				$lv_csr = openssl_csr_new($lv_dn, $lv_prvkey);
				
        // FIRMA. firma la peticion con el certificado firmante
				$lv_dirca='../../../SSLFiles/'.strtoupper($lo_admbusmdl->buscod).'/';
				$lv_cacertkeyarr = array('file://'.realpath($lv_dirca.$lv_cacuspem.'.tmss'), $lv_cacuspwd);
				try{
					$lv_sscert = openssl_csr_sign($lv_csr, 'file://'.realpath($lv_dirca.$lv_cacuscrt.'.tmss'), $lv_cacertkeyarr, intval($lv_dayqty), array('digest_alg'=>'sha256') );
          //var_dump($lv_dirca);
				} catch(Exception $e){
					return '<errcod>-1</errcod><errtxt>Errror al crear certificado. '.$e->getMessage().'</errtxt>';
				}
				
				// EXPORTAR. exporta los archivos PEM (clave privada), CSR (solicitud de certificado) y CRT (certificado)
				$lv_dir='../../../SSLFiles/'.strtoupper($lo_admbusmdl->buscod).'/CRT/';
				if(!is_dir($lv_dir)){mkdir($lv_dir);}
				try{
					openssl_pkey_export_to_file($lv_prvkey, $lv_dir.'admsgn'.$this->lo_mdl->sgncod.'.key', $this->lo_mdl->sgnpwd );
					openssl_csr_export_to_file( $lv_csr, $lv_dir.'admsgn'.$this->lo_mdl->sgncod.'.csr' );
					openssl_x509_export_to_file($lv_sscert, $lv_dir.'admsgn'.$this->lo_mdl->sgncod.'.crt' );
					/*
					openssl_pkcs12_export_to_file($lv_sscert,
																				$lv_dir.'admsgn'.$this->lo_mdl->sgncod.'.crt',
																				$lv_dir.'admsgn'.$this->lo_mdl->sgncod.'.pem',
																				$this->lo_mdl->sgnpwd,
																				array('extracerts'=>$lv_cacertkeyarr,'friendlyname'=>'Temasis Argentina'));
					*/
				} catch(Exception $e) {
					return '<errcod>-1</errcod><errtxt>Errror al exportar certificado. '.$e->getMessage().'</errtxt>';
				}
				
				// VISTA. devuelve la vista de firmas
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;

case '#export':
// tomar crt y concatenarlo con el CRT de temasis => generando un archivo PEM
// tomar el archivo PEM y exportarlo como CRT
// openssl_x509_export_to_file

	$lv_dir='../../../SSLFiles/TEMASIS_HLT/CRT/';
	$lv_sgncod = $this->co_reg->request->post['sgncod'];
	$this->lo_mdl->load( array(	'sgncod'=>$lv_sgncod	) );
	$lv_pwd = $this->lo_mdl->sgnpwd;

	$lv_crt = file_get_contents($lv_dir.'admsgn'.$lv_sgncod.'.crt');
//	$lv_key = file_get_contents($lv_dir.'admsgn'.$lv_sgncod.'.key');
	$lv_cacrt = file_get_contents('../../../SSLFiles/TEMASIS_HLT/654.tmss');
//	$lv_crt.=$lv_cacrt;
//	var_dump($lv_crt);
	file_put_contents($lv_dir.'admsgn'.$lv_sgncod.'.crt2', $lv_cacrt.$lv_crt);
//	openssl_x509_export_to_file($lv_crt, $lv_dir.'admsgn'.$lv_sgncod.'.crt2');
/*
	$lv_cacrtarr = array('extracerts'=>'../../../SSLFiles/TEMASIS_HLT/CRT/477.tmss','friendly_name'=>'Temasis Argentina SRL');
	$lv_key = openssl_pkey_get_private($lv_pem,$lv_pwd);
	//var_dump(file_get_contents('../../../SSLFiles/TEMASIS_HLT/477.tmss'));
	var_dump(file_get_contents('../../../SSLFiles/TEMASIS_HLT/478.tmss'));
	openssl_x509_export_to_file($lv_sscert, $lv_dir.'admsgn'.$this->lo_mdl->sgncod.'.crt' );
	openssl_pkcs12_export_to_file($lv_crt,
																$lv_dir.'admsgn'.$lv_sgncod.'.p12',
																$lv_key,
																$lv_pwd,
																$lv_cacrtarr);
$lv_crt2 = file_get_contents($lv_dir.'admsgn'.$lv_sgncod.'.p12');
var_dump($lv_crt2);
*/
	break;


      // NEW
      case '#01':
				$lo_post = $this->co_reg->request->post;

				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        $lv_docclscod = (isset($lo_post['sysdocclscod'])?$lo_post['sysdocclscod']:'');
        if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).((isset($lp_prm['mdlcod']) && isset($lp_prm['prgcod']))?$lp_prm['mdlcod'].'_'.$lp_prm['prgcod']:self::OBJTYP).chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView('sysdocclslst',array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr));
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */

        // cargo parametros del modelo
        $lo_mdlprm->load( array('mdlcod'=>'ADM') );
				$lv_prmadmexp = $this->co_reg->document->getTagValue(($lo_mdlprm->mdlatrval001),'SIGNATERE_EXPIRATION_DAYS');
        //var_dump($lv_prmadmexp);
        if ($lv_prmadmexp=='') {
          $lv_prmadmexp = $this->co_reg->document->getTagValue(($this->lo_mdl->sysdoccls->sysdocclsatr),'sgnduedayqty');
				}
        //var_dump($lv_prmadmexp);
        $date = date("d-m-Y H:i");
        //Incrementando 180 dias
        $mod_date = strtotime($date."+ $lv_prmadmexp days");
        $lv_fecha = date("d-m-Y",$mod_date);
        $var1 = new DateTime();
        $var1->setTimestamp($mod_date);
        
				$this->lo_mdl->usrtxt = $lo_post['usrtxt'];
				$this->lo_mdl->ctedte = new Datetime();
				$this->lo_mdl->sgnduedte = $var1;
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;



			// DELETE
      case '#04':
				$lo_post = $this->co_reg->request->post;
        if ( $this->lo_mdl->delete( $lo_post ) ) {
					return '<errcod></errcod><errtxt></errtxt>';
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        break;



			// FIRMA
			// obtiene la vista de firma
			case'#sign':
				$lo_post = $this->co_reg->request->post;
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_sgndocmdl = $this->co_reg->load->model('admsgndoc');

				// obtener del registro de firmas la firma de la persona que esta ingresando en el sistema
				$lv_prm =array('vewfldflt'=>'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																		'[~fltrow~]s.sgnduedte'.chr(9).'ZZ'.chr(9).'>='.chr(9).'getdate()'.chr(9).chr(9).
																		'[~fltrow~]s.cteusr'.chr(9).'='.chr(9).chr(9). $this->co_reg->sec->usrcod .chr(9).chr(9));
				$lo_rs = $this->lo_mdl->getList( $lv_prm );
				if(count($lo_rs)>0){
					$this->lo_mdl->cteusr = $lo_rs[0]['cteusr'];
					$this->lo_mdl->usrtxt = $lo_rs[0]['usrtxt'];
					$this->lo_mdl->sgnini = $lo_rs[0]['sgnini'];
					$this->lo_mdl->sgncod = $lo_rs[0]['sgncod'];

					// cargo la clase de documento que corresponde a la firma
					$lo_docclsmdl->load(array('sysdocclscod'=>$lo_rs[0]['sysdocclscod']));
				}
				
				$lo_flelstarr=json_decode(html_entity_decode($lo_post['flelst']),true);
				foreach ($lo_flelstarr as $lv_key => $lv_value) {
					//revisa si ya se firmo el documento
					$lv_prm=array('vewfldflt'=>'[~fltrow~]sd.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																		 '[~fltrow~]sd.cteusr'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod .chr(9).chr(9).
																		 '[~fltrow~]sd.sgndocsrctyp'.chr(9).'='.chr(9).chr(9).$lv_value['sgndocsrctyp'].chr(9).chr(9).
																		 '[~fltrow~]sd.sgndocsrccod001'.chr(9).'='.chr(9).chr(9).$lv_value['sgndocsrccod001'].chr(9).chr(9).
																		 '[~fltrow~]sd.sgndocsrccod002'.chr(9).'='.chr(9).chr(9).$lv_value['sgndocsrccod002'].chr(9).chr(9) );
					$lo_rssgndoc=$lo_sgndocmdl->getList($lv_prm);
					if(count($lo_rssgndoc)>0){ unset($lo_flelstarr[$lv_key]); }
				}

				$this->lo_mdl->flelst=json_encode($lo_flelstarr);
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				return $this->getView('admsgndoc');
				break;
			
			
			
			// FIRMAR DOCUMENTO
			// firma un documento
			case'#sgndoc':
				$lo_post=$this->co_reg->request->post;
				$lo_ret=array('errtyp'=>'S','errcod'=>0,'errtxt'=>'','sgndocsrctyp'=>$lo_post['sgndocsrctyp'],'sgndocsrccod001'=>$lo_post['sgndocsrccod001'],'sgndocsrccod002'=>$lo_post['sgndocsrccod002']);

				// DATOS. se obtienen datos de la firma
				// ruta de la imagen de la firma / ruta del certificado de la firma de usr / nombre firmante / id firma / fecha-hora firma
				// cargo datos de la firma
				$this->lo_mdl->load( array('sgncod'=>$lo_post['sgncod']) );
				if($this->lo_mdl->sgnpwd!=$lo_post['sgnpwd']){
					$lo_ret['errtyp']='E';
					$lo_ret['errcod']='-1';
					$lo_ret['errtxt']='La clave ingresada no es v&aacute;lida.';
					return json_encode($this->co_reg->document->array_utf8_converter($lo_ret));
				}
				
				$lv_dte = new Datetime();
				// cargo datos de la imagen de la firma
				$lo_flemdl = $this->co_reg->load->model('grldatupl');
				$lv_prm=array('vewfldflt'=>'[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9).'ADM_SGN'.chr(9).chr(9).
																	 '[~fltrow~]f.flesrccod'.chr(9).'='.chr(9).chr(9). $this->lo_mdl->sgncod .chr(9).chr(9) );
				$lo_flers = $lo_flemdl->getList($lv_prm);
				$lv_flecod = (count($lo_flers)>0?$lo_flers[0]['flecod']:'');				
				// preparo datos para firmar el documento
				$lv_sgndat = array( 'usrtxt'=>$this->lo_mdl->usrtxt,
														'sgndte'=>$lv_dte,
														'sgncod'=>$this->lo_mdl->sgncod,
														'crtsgnfle'=>'../../../SSLFiles/'.strtoupper($this->co_reg->sec->buscod).'/CRT/admsgn'.$this->lo_mdl->sgncod.'.crt',
														'crtkeyfle'=>'../../../SSLFiles/'.strtoupper($this->co_reg->sec->buscod).'/CRT/admsgn'.$this->lo_mdl->sgncod.'.key',
														'crtpwdstr'=>$lo_post['sgnpwd'],
														'crtimgfle'=>($lv_flecod==''?'':'../../../SSLFiles/'.strtoupper($this->co_reg->sec->buscod).'/'.$lv_flecod.'.tmss') );
				
				// DOCUMENTO. Genera string
				// Llamo al controlador pasando como parámetros los datos del documento, posición y condición
				$lv_ctr='';
				$lv_act='';
				$lv_prm= array();
				$lv_prmarr = explode('&',html_entity_decode($lo_post['flesrcurl']));
				foreach($lv_prmarr as $lv_prmrow){
					$lv_key = explode('=',$lv_prmrow);
					if($lv_key[0]=='?prg'){ $lv_ctr=$lv_key[1]; }
					if($lv_key[0]=='act'){ $lv_act=$lv_key[1]; }
					if(substr($lv_key[0], 0, 4)=='prm_'){
						//Crea un indice segun el nombre de parametro que se reciba despues del prm_
						$lv_prmarr = explode('_', $lv_key[0]);
						$lv_prm[$lv_prmarr[1]] = $lv_key[1];
					}
				}
				if($lv_ctr=='' || $lv_act==''){
					$lo_ret['errtyp']='E';
					$lo_ret['errcod']='-1';
					$lo_ret['errtxt']='No se puede determinar el documento a firmar.';
					return json_encode($this->co_reg->document->array_utf8_converter($lo_ret));
				}
				$lo_frmctr = $this->co_reg->load->controller( $lv_ctr );
				$lv_prm['sgndat'] = $lv_sgndat; // datos para firmar el documento
				$lo_frmret = $lo_frmctr->index( $lv_act, $lv_prm );
				
				// ARCHIVO. grabado fisico del documento firmado
				$lo_datuplmdl=$this->co_reg->load->model('grldatupl');
				$lv_strarr = array();
				$lv_strarr['flecnt'] = $lo_frmret;
				$lv_strarr['flenme'] = $lo_post['flenme'].'.PDF';
				$lv_strarr['fletyp'] = 'APPLICATION/PDF';
				$lv_strarr['fleext'] = 'PDF';
				if( !$lo_datuplmdl->uploadString( $lv_strarr ) ){
					$lo_ret['errtyp']=$lo_datuplmdl->errtyp;
					$lo_ret['errcod']=$lo_datuplmdl->errcod;
					$lo_ret['errtxt']=$lo_datuplmdl->errtxt;
					return json_encode($this->co_reg->document->array_utf8_converter($lo_ret));
				}
						
				// REGISTRO. se registra documento firmado
				$lo_sgndocmdl=$this->co_reg->load->model('admsgndoc');
				$lo_post['flecod']= $lo_datuplmdl->flecod;
				$lo_post['fletxt']='';
				$lo_post['docsts']='A';
				if( !$lo_sgndocmdl->save( $lo_post ) ){
					$lo_ret['errtyp']=$lo_sgndocmdl->errtyp;
					$lo_ret['errcod']=$lo_sgndocmdl->errcod;
					$lo_ret['errtxt']=$lo_sgndocmdl->errtxt;
				}
				
				// RESPUESTA. devuelvo el status de registro y firma del documento
				return json_encode($this->co_reg->document->array_utf8_converter($lo_ret));
				break;
    }
  }
}
?>
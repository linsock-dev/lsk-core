<?php
	//header_remove(); 
	//header('Access-Control-Allow-Origin: *');
	//header('Access-Control-Allow-Headers: X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Request-Method');
	//header('Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE');
	//header('Allow: GET, POST, OPTIONS, PUT, DELETE');
	
	$method = $_SERVER['REQUEST_METHOD'];
	if($method == 'OPTIONS') { die(); }

  // Version
  define('VERSION', '2.0.0');
  define('DIR_APPLICATION', str_replace('\'', '/', realpath(dirname(__FILE__))) . '/');
  define('DIR_LOGS', str_replace('\'', '/', realpath(dirname(__FILE__))) . '/../system/logs/');
  define('DIR_CONFIG', str_replace('\'', '/', realpath(dirname(__FILE__))) . '/../system/config/');
  define ('__SITE_PATH', realpath(dirname(__FILE__) ));

  // Error Reporting - notify all PHP errors
  error_reporting(E_ALL);

  // Check Version
  if (version_compare(phpversion(), '8.1.0', '<') == true) { exit('PHP8.1+ Required'); }
	
  // ERRORES. controlador de errores de php
  set_error_handler(function($lp_errcod, $lp_errtxt, $lp_errfle, $lp_errflelne) {
  	global $lo_log, $lo_cfg, $lo_sec, $lo_doc, $lo_usr_mdl;
  	// error suppressed with @
  	if (error_reporting() === 0) {
  		return false;
  	}
  	switch ($lp_errcod) {
  		case E_NOTICE:	case E_USER_NOTICE:		$lv_errtyp = 'Info'; break;
  		case E_WARNING:	case E_USER_WARNING: 	$lv_errtyp = 'Advertencia'; break;
  		case E_ERROR:		case E_USER_ERROR: 		$lv_errtyp = 'Error'; break;
  		default: $lv_errtyp = 'Desconocido'; break;
  	}
		
		if($lo_usr_mdl->usrcod==''){ $lo_usr_mdl->load( array('usrcod'=>$lo_sec->usrcod) );	}
		if ($lo_cfg->get('error_display') || $lo_doc->getTagValue($lo_usr_mdl->usratr001,'debmod')=='1' ) {
  		echo '<b>' . $lv_errtyp . '</b>: ' . $lp_errtxt . ' in <b>' . $lp_errfle . '</b> on line <b>' . $lp_errflelne . '</b>';
		} else {
  		echo 'Se produjo un error al ejecutar la operación. Por favor, intente nuevamente o consulte con el administrador del sistema.';
		}
		
		if ($lo_cfg->get('error_log')) {
  		$lo_log->write($lo_sec->buscod.'.'.$lo_sec->usrcod.'.PHP ' . $lv_errtyp . ':  ' . $lp_errtxt . ' in ' . $lp_errfle . ' on line ' . $lp_errflelne);
  	}  
  	return true;
  });
	
	// EXCEPCIONES. controlador de excepciones
	set_exception_handler(function($exception){
		echo json_encode(array('errtyp'=>'E','errcod'=>-9999,'errtxt'=>'Uncaught exception: '.$exception->getMessage()) );
	});
	
	// AUTOLOAD. carga archivos de clases cuando estas se declaran
  spl_autoload_register(function($lp_clsnme) {
    if ( substr($lp_clsnme,0,4)=='tmss' ) {
      $lv_fle = __SITE_PATH . '/../system/engine/' . $lp_clsnme . '.php';
    } else {
      $lv_fle = __SITE_PATH . '/../tmssOnLine/controller/' . strtolower($lp_clsnme) . '.php';
    }
    if (file_exists($lv_fle) == false) {
      return false;
    }
    include($lv_fle);
  });
  
	
	// CLASES. se cargan las clases necesarias para la aplicacion
  
  // Registry
  $lo_reg = new tmssRegistry();  

  // Config
  $lo_cfg = new tmssConfig();
	$lo_cfg->load('tmssOnLine');
  $lo_reg->set('config', $lo_cfg);
  
	// Log
	$lo_log = new tmssLog( $lo_cfg->get('error_filename') );
	$lo_reg->set('log', $lo_log);
	
  // Loader
  $lo_loa = new tmssLoader( $lo_reg ); 
  $lo_reg->set('load', $lo_loa);
  
  // Session
  $lo_ses = new tmssSession();
	$lo_ses->startSession();
  $lo_reg->set('session', $lo_ses);
  
  // Request
  $lo_req = new tmssRequest();
  $lo_reg->set('request', $lo_req);
  
  // Response
  $lo_res = new tmssResponse();
  $lo_reg->set('response', $lo_res);
	$lo_reg->response->addHeader('Content-type: application/json');
  
  // Database
  $lo_db = new tmssDatabase( $lo_reg );
  $lo_reg->set('db', $lo_db);
  
  // Security
  $lo_sec = new tmssSecurity( $lo_reg );
  $lo_reg->set('sec', $lo_sec);
  
  // Url
  $lo_url = new tmssUrl();
  $lo_reg->set('url', $lo_url);
	
  // Document
  $lo_doc = new tmssDocument( $lo_reg );
  $lo_reg->set('document', $lo_doc);

  // Document - field input    
  $lo_inp = new tmssInput( $lo_reg );
  $lo_reg->set('input', $lo_inp );
	
  // User
  $lo_usr = $lo_reg->load->controller('syssecusr');
  $lo_reg->set('user', $lo_usr);
	$lo_usr_mdl = $lo_reg->load->model('syssecusr');
	
	// Language
  $lo_lng = new tmssLanguage( $lo_reg );
  $lo_lng->initialize();
  $lo_reg->set('language', $lo_lng);
	
	if( ( is_array($lo_reg->request->post) ? count($lo_reg->request->post) : 0 )==0 ){
		$lo_reg->request->post = json_decode(file_get_contents('php://input'), true);
	}
  $lv_src_post = $lo_reg->request->post;
	
	//OBTENER DATOS. obtiene datos principales de la llamada (método, URI y headers)
	$lv_method = $_SERVER['REQUEST_METHOD'];
	$lv_paths = $_SERVER['REQUEST_URI'];
	$lv_path = explode('/',str_ireplace( '\\' , '/' , strtolower($_SERVER['REQUEST_URI'])));
	$lv_hdr = getallheaders();
	$lv_usrcod = ($lv_hdr['User']??'');
	$lv_usrpwd = ($lv_hdr['Password']??'');
	$lv_prytkn = ($lv_hdr['Proyect-Token']??'');
	$lv_apptkn = ($lv_hdr['User-Token']??'');
		
	// CONFIGURACION. Establece todos los parámetros de conexión
	if( isset($lv_path[2]) ){
		$lo_rs = $lo_reg->config->get('customers');
		$lv_envcod = $lv_path[2];
		if(isset($lo_rs[$lv_envcod])){
			$lo_reg->request->post['bseurl']	= '/clientes/'.$lo_rs[$lv_envcod]['environmet'];
			$lo_reg->request->post['bsecnx'] 	= $lo_rs[$lv_envcod]['connection'];
			$lo_reg->request->post['buscod']	= $lo_rs[$lv_envcod]['buscod'];
      $lo_reg->request->post['apilog']  = ($lo_rs[$lv_envcod]['apilog']??'');
			$lo_reg->sec->bsecnx = $lo_rs[$lv_envcod]['connection'];
			$lv_ret = array('errtyp'=>'S','errcod'=>0,'errmsg'=>'');
		} else {
			$lv_ret = array('errtyp'=>'E','errcod'=>-1,'errmsg'=>'InvalidCompany','errvar'=>array('1'=>$lv_envcod));
			$lv_output = $lo_reg->document->getJson($lv_ret);
		}
	} else {
		$lv_ret = array('errtyp'=>'E','errcod'=>-2,'errmsg'=>'InvalidURL','errvar'=>array('1'=>strtolower($_SERVER['REQUEST_URI'])));
		$lv_output = $lo_reg->document->getJson($lv_ret);
	}
	
	// LOG. si se registra log de API, se graba en archivo la llamada
  if( $lo_reg->request->post['apilog']!='' ){
    $lv_log='REQUEST_METHOD:'.$_SERVER['REQUEST_METHOD'].PHP_EOL
            .'REQUEST_URI:'.$_SERVER['REQUEST_URI'].PHP_EOL
           	.'HEADERS:'. json_encode(getallheaders()).PHP_EOL
           	.'BODY:'.json_encode($lv_src_post);
    $lo_log->write($lo_sec->buscod.'.'.$lo_sec->usrcod.'.API.GORSE - REQUEST' . PHP_EOL . $lv_log . PHP_EOL );
  }

	// INICIALIZACION. se validan los datos enviados
	// si no se informo token, se inicializa
	if( $lv_apptkn=='' && $lv_ret['errtyp']=='S' ){
		
		$lv_case_sensitive = false;

		// busco id de case sensitive
		$lo_drttypmdl = $lo_reg->load->model('syssecdrttyp');
		$lo_rs = $lo_drttypmdl->getList();
		foreach($lo_rs as $lv_row){ if($lv_row['syssecdrttypcodext']=='PWDLGNCASESENSITIVE'){ $lv_case_sensitive_code=$lv_row['syssecdrttypcod']; break; }}

		// verifico si el usuario esta alcanzado por la directiva CASE SENSITIVE
		$lo_drtmdl = $lo_reg->load->model('syssecdrtgrpasg');
		$lo_rs = $lo_drtmdl->getUserDirectives();
		foreach($lo_rs as $lv_row){ if( $lv_row['syssecdrttypcod']==$lv_case_sensitive_code ){ $lv_case_sensitive=true; break; } }

		// valido credenciales
		$lv_usrpwdhsh = hash( 'sha256', ($lv_case_sensitive ? $lv_usrpwd : strtoupper($lv_usrpwd)) );
		$lv_ret = api_init( $lv_path, $lv_usrcod, $lv_usrpwdhsh, $lv_prytkn );
		$lv_output = $lo_reg->document->getJson($lv_ret);
		
	// si se informó token se valida
	} else if( $lv_apptkn!='' && $lv_ret['errtyp']=='S' ){
		if( count($lv_path)<4 ){
			$lv_ret = array('errtyp'=>'E','errcod'=>-3,'errmsg'=>'invalidURL','errvar'=>array('1'=>'Count='.count($lv_path)));
		} else {
			$lv_ret = api_checkAppToken( $lv_apptkn );
		}
		
		if( $lv_ret['errtyp']=='S' ){
			$lo_reg->sec->usrcod=$lv_ret['usrcod'];
			$lo_reg->sec->buscod=$lo_reg->request->post['buscod'];

			// cargo el controlador de proyecto y llamo a la función de validar y ejecutar API
			$lo_apppryctr = $lo_reg->load->controller('sysapppry');
			// recurso
			$lv_apires = ($lv_path[3]??'');
			// variante
			$lv_apivar = (isset($lv_path[4]) ? (stripos($lv_path[4],'?')===false ? '' : explode('?',$lv_path[4])[0]) : '' );
			// campos (filtro) o ID de documento
			$lv_apifld = ($lv_apivar=='' ? $lv_path[4] : explode('?',$lv_path[4])[1] );
			$lv_prm = array('resource'=>$lv_apires, 'method'=>$lv_method, 'variant'=>$lv_apivar, 'apifield'=>$lv_apifld, 'token'=>$lv_prytkn);
			$lv_output = $lo_apppryctr->execApi($lv_prm);
		} else {
			$lv_output = $lo_reg->document->getJson($lv_ret);
		}
		
	}
	
	// LOG. si se registra log de API, se graba en archivo la respuesta
	if( $lo_reg->request->post['apilog']!='' ){
		$lo_log->write($lo_sec->buscod.'.'.$lo_sec->usrcod.'.API.GORSE - RESPONSE' . PHP_EOL . 'OUTPUT: ' . $lv_output . PHP_EOL );
  }
    
	// Output
	$lo_res->setOutput( $lv_output );
	$lo_res->output();
	
	
	
	// API INIT. función que recibe los parametros y token para inciializar y devolver el token de uso 
	function api_init( $lp_path, $lp_usrcod, $lp_usrpwd, $lp_prytkn ){
		global $lo_reg;
		$lo_reg->request->post['usrcod'] = $lp_usrcod;
		$lo_reg->request->post['usrpwd'] = $lp_usrpwd;
		
		// VALIDACION. se validan datos minimos
		if( $lp_usrcod=='' || $lp_usrpwd=='' || $lp_prytkn=='' ){
			return array('errtyp'=>'E','errcod'=>-11,'errmsg'=>'InvalidHeaderData');
		}
		
		// LOGIN. se intenta realizar el login de usuario
		$lo_reg->sec->usrcod='';
		$lo_reg->sec->buscod='';
		$lv_lgnbuf = json_decode( $lo_reg->user->checkUserLogin('api'), true );
		if($lv_lgnbuf['errtyp']!='S'){
			return array('errtyp'=>'E','errcod'=>-12,'errmsg'=>'InvalidLogin', 'errvar'=>$lv_lgnbuf);
		}

		// PROYECTO. busca si existe un proyecto para el token indicado
		$lo_prymdl = $lo_reg->load->model('sysapppry');
		$lv_prm = array('vewfldflt' =>'[~fltrow~]p.sysappprytkn'.chr(9).'='.chr(9).chr(9).$lp_prytkn.chr(9).chr(9).
																	'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
										'vewmaxrec' =>'1'	);		
		$lo_rspry = $lo_prymdl->getList( $lv_prm );
		if( count($lo_rspry)==0 ){
			return array('errtyp'=>'E','errcod'=>-13,'errmsg'=>'InvalidProjectToken');
		}
		
		// TOKEN. crea y asigna un token de usuario
		$lo_tknmdl = $lo_reg->load->model('syssecusrtkn');
		$lv_prm = array('vewfldflt' =>'[~fltrow~]t.usrcod'.chr(9).'='.chr(9).chr(9).$lp_usrcod.chr(9).chr(9).
																	'[~fltrow~]t.acctknenddte'.chr(9).'ZZ'.chr(9).'>'.chr(9).'GETDATE()'.chr(9).chr(9),
																	'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
										'vewmaxrec' =>'1'	);		
		$lo_rstkn = $lo_tknmdl->getList( $lv_prm );
		if( count($lo_rstkn)>0 ){
			return array('errtyp'=>'S','errcod'=>-14,'errmsg'=>'','token'=>$lo_rstkn[0]['acctkn'],'expired'=>$lo_rstkn[0]['acctknenddte']);
		} else if( $lo_tknmdl->create( array('usrcod'=>$lp_usrcod) )==false ){
			return array('errtyp'=>'E','errcod'=>-15,'errmsg'=>'CannotCreateUserToken');
		} else {
			return array('errtyp'=>'S','errcod'=>0,'errmsg'=>'','token'=>$lo_tknmdl->acctkn,'expired'=>$lo_tknmdl->acctknenddte);
		}
	}
	
	
	
	// API CHECK APP TOKEN. en base a un token de aplicacion, se loguea al usuario
	function api_checkAppToken( $lp_apptkn ){
		global $lo_reg;
		$lv_now = new DateTime();
		
		// busco el token para la emprsea
		$lo_tknmdl = $lo_reg->load->model('syssecusrtkn');
		$lv_prm = array('vewfldflt' =>'[~fltrow~]t.acctkn'.chr(9).'='.chr(9).chr(9).$lp_apptkn.chr(9).chr(9).
																	'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
										'vewmaxrec' =>'1'	);		
		$lo_rstkn = $lo_tknmdl->getList( $lv_prm, array('secusrcod'=>'TEMASIS_WEB') );
		
		// si no existe, es un token inválido
		if( count($lo_rstkn)==0 ){
			return array('errtyp'=>'E','errcod'=>-21,'errmsg'=>'invalidUserToken');
		// si existe, verifico si esta vencido
		} else if( $lo_rstkn[0]['acctknenddte']<$lv_now ) {
			return array('errtyp'=>'E','errcod'=>-22,'errmsg'=>'expiredUserToken');
		// token válido, devolver usuario
		} else {
			return array('errtyp'=>'S','errcod'=>0,'errmsg'=>'','usrcod'=>$lo_rstkn[0]['usrcod'],'usrtxt'=>$lo_rstkn[0]['usrtxt']);
		}
	}
?>
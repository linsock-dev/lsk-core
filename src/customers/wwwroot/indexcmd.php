<?php
	// en caso de no llamarse por linea de comandos, 
	// se obtienen los parametros de URL y se convierten 
	// para simular la llamada de linea de comandos
	if(!isset($argv)){ 
		$argv = array();
		$i=1;
		$argv[0]='';
		foreach($_GET as $lv_key=>$lv_val){
			$argv[$i] = $lv_key.'='.$lv_val;
			$i++;
		}
		$argc = count($_GET);
	}

	$lv_cmd = ( (isset($argc)?$argc:1)>1 ? true : false );
	if ($lv_cmd==false) return;

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
  //$lo_cfg = new tmssConfig( $lo_reg );
  //$lo_reg->set('config', $lo_cfg);
  
  // Loader
  $lo_loa = new tmssLoader( $lo_reg );
  $lo_reg->set('load', $lo_loa);
  
  // Session
  $lo_ses = new tmssSession();
  //$lo_ses->startSession();
  $lo_reg->set('session', $lo_ses);
  
  // Request
  $lo_req = new tmssRequest();
  $lo_reg->set('request', $lo_req);
  
  // Response
  $lo_res = new tmssResponse();
  $lo_reg->set('response', $lo_res);
  
  // Database
  $lo_db = new tmssDatabase( $lo_reg );
  $lo_reg->set('db', $lo_db);
  
  // Security
  $lo_sec = new tmssSecurity( $lo_reg );
  //$lo_sec->initialize();
  $lo_reg->set('sec', $lo_sec);
  
  // Url
  //$lo_url = new Url(HTTP_SERVER, $config->get('config_secure') ? HTTPS_SERVER : HTTP_SERVER);
  $lo_url = new tmssUrl();
  $lo_reg->set('url', $lo_url);

  // language
  /**
   * // determine default language  
   * if ( isset( $lo_reg->session->get['tmssLanguage'] ) ) {
   *   $lv_lng = $lo_reg->session->get['tmssLanguage'];
   * } else if ( isset( $lo_reg->request->server['HTTP_ACCEPT_LANGUAGE'] ) ) {
   *   $lv_lng = explode(',',$lo_reg->request->server['HTTP_ACCEPT_LANGUAGE'])[0];  
   * } else {
   *   $lv_lng = $lo_reg->config->defaultLanguage; 
   * }
   */
  $lo_lng = new tmssLanguage( $lo_reg );
  $lo_lng->initialize();
  $lo_reg->set('language', $lo_lng);

  // Document
  $lo_doc = new tmssDocument( $lo_reg );
  $lo_reg->set('document', $lo_doc);

  // Document - field input    
  $lo_inp = new tmssInput( $lo_reg );
  $lo_reg->set('input', $lo_inp );
    
  // User
  $lo_usr = $lo_reg->load->controller('syssecusr');
  $lo_reg->set('user', $lo_usr);

	$lv_buffer = '';

	// obtengo parámetros de ejecución
	$lv_prm = array('prg','act','bsecnx','usrcod','usrtxt','buscod','bustxt','bseurl');
	$lv_data = array();
	for ($i=1; $i<count($argv); $i++ ) {
			$lv_key = explode('=',$argv[$i])[0];
			$lv_val = explode('=',$argv[$i])[1];
			foreach( $lv_prm as $lv_rowprm ) {
				if ( $lv_key==$lv_rowprm ) { $lv_data[ $lv_rowprm ] = $lv_val; }
			}
	}
	
	// obtengo parametros
	$lv_prm = array();
	for ($i=1; $i<count($argv); $i++ ) {
		if ( substr( strtolower($argv[$i]), 0, 4)=='prm_' ) {
			$lv_key = explode('=',$argv[$i])[0];
			$lv_val = explode('=',$argv[$i])[1];
			$lv_prm[ substr(strtolower($lv_key),4,strlen($lv_key)-4) ] = $lv_val;
		}
	}
	
	// fijo cadena de conexión
	$lo_reg->sec->usrcod 	= $lv_data['usrcod']??'';
	$lo_reg->sec->usrtxt 	= $lv_data['usrtxt']??'';
	$lo_reg->sec->buscod 	= $lv_data['buscod']??'';
	$lo_reg->sec->bsecnx 	= $lv_data['bsecnx']??'';
	$lo_reg->sec->bseurl 	= $lv_data['bseurl']??'';
	$lo_reg->sec->bustxt 	= $lv_data['bustxt']??'';
	$lo_reg->sec->timeout = time() + 1;
	
	// cargo controlador
	$lo_prg = $lo_reg->load->controller( $lv_data['prg'] );
	
	// ejecuto acción
	$lv_buffer = $lo_prg->index( $lv_data['act'] , $lv_prm );
	
  // Output
  $lo_res->setOutput( $lv_buffer ); 
  $lo_res->output();
?>
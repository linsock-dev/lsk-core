<?php
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
  		$lo_log->write($lo_sec->buscod.chr(9).$lo_sec->usrcod.chr(9).$lv_errtyp.chr(9).$lp_errtxt.chr(9).$lp_errfle.chr(9).$lp_errflelne);
  	}  
  	return true;
  });
	
	// EXCEPCIONES. controlador de excepciones
	set_exception_handler(function($exception){
		echo json_encode(array('errtyp'=>'E','errcod'=>-9999,'errtxt'=>'Uncaught exception: '.$exception->getMessage().' on '.str_ireplace('C:\\inetpub\\vhosts\\temasis.ar\\','',$exception->getFile()).' line '.$exception->getLine() ) );
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
	
	
	// PROCESO. se determina que mostrar en funcion del proceso ejecutado	
	
  // acceso a controller específico (login se valida en cada controlador)
  $lv_buffer = '';
  if (isset($lo_req->get['prg'])) {
	
    $lv_prm = array();
    foreach ( $lo_req->get as $lv_key => $lv_val ) {
      if ( substr( strtolower($lv_key), 0, 4)=='prm_' ) {
        $lv_prm[ substr(strtolower($lv_key),4,strlen($lv_key)-4) ] = $lv_val;
      }
    }
    $lo_prg = $lo_reg->load->controller( $lo_req->get['prg'] );
    $lv_buffer = $lo_prg->index( (isset($lo_req->get['act'])?$lo_req->get['act']:'') , $lv_prm );
		
	// pantalla x default
  } else {	
	
		// verifico si está logueado
    $lv_lgnbuf = $lo_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) {
			// intento obtener los datos del token de url
			if ( $lo_reg->sec->getToken()=='' ) {
				$lv_ret = $lo_reg->sec->getUrlToken();
				if ( $lv_ret['errcod']!=0 ) {
					//echo '<br><br><br><br><br><br>******ir a pantalla de login******';
					//$lv_lgnbuf = $lo_reg->user->isLogged();
				// asigno los datos de sesión para que pueda cargarse el menú
				} else {
					$lo_reg->sec->usrcod = $lv_ret['usrcod'];
					$lo_reg->sec->usrtxt = $lv_ret['usrtxt'];
					$lo_reg->sec->buscod = $lv_ret['buscod'];
					$lo_reg->sec->bustxt = $lv_ret['bustxt'];
					$lo_reg->sec->bsecnx = $lv_ret['bsecnx'];
				}
			}
			$lv_buffer = $lv_lgnbuf;
		}		

		// usuario logueado
		if ( $lv_lgnbuf=='' ) {
		
			// obtengo opciones de menú
			$lv_mnu = array();
			$lv_mnu = $lo_reg->document->getMenu();

			// obtengo empresas del usuario
			$lo_usrbus_mdl = $lo_reg->load->model('syssecusrbus');
			$lo_bus = $lo_usrbus_mdl->load( array('usrcod'=>$lo_reg->sec->usrcod) );
			
			$lv_strpge='';
			
			// busco página de inicio en los grupos asignados al usuario (tomo la primera)
			$lo_usrgrp_mdl = $lo_reg->load->model('syssecusrgrp');
			$lo_usrgrp_rs = $lo_usrgrp_mdl->load( array('usrcod'=>$lo_reg->sec->usrcod) );
			foreach($lo_usrgrp_rs as $lv_row){
				if ($lo_doc->getTagValue($lv_row['usrgrpatr001'],'strpge')!=''){
					$lv_strpge = $lo_doc->getTagValue($lv_row['usrgrpatr001'],'strpge');
					break;
				}
			}

			$lo_usr_mdl->load( array('usrcod'=>$lo_reg->sec->usrcod) );
			
			// si no tiene asignación por grupo, busco si tiene el usuario
			if ($lv_strpge==''){
				//$lo_usr_mdl = $lo_reg->load->model('syssecusr');
				//$lo_usr_mdl->load( array('usrcod'=>$lo_reg->sec->usrcod) );
				$lv_strpge = $lo_doc->getTagValue($lo_usr_mdl->usratr001,'strpge');
			}
				
			// cargo la página inicial
			if ( $lv_strpge!='' ) {
				$lv_strpge = html_entity_decode(strtolower($lv_strpge));
				$lv_redirect = '/*script*/tmssLink("index.php'.$lv_strpge.'", [{tab_title:"Inicio"}] );';
			} else {
				$lv_redirect = '/*script*/tmssLink("?prg=grlstr", [{tab_title:"Inicio"}] );';
			}
			
			// preparo parámetros
			$lv_prm = array('mnu' => $lv_mnu ,
											'lang'=> $lo_reg->language,
											'sec' => $lo_reg->sec,
											'doc' => $lo_reg->document,
											'plugins' => array( 'logon', 'message', 'chat', 'popup', 'recent', 'favorites' ),
											'data' => array('redirect' => $lv_redirect),
											'bus' => $lo_bus,
											'usr' => $lo_usr_mdl
											);
			
			// muestro pantalla
			$lv_buffer  = $lo_reg->load->view('sysdochdr',$lv_prm);
			$lv_buffer .= $lo_reg->load->view('sysdocmnu',$lv_prm);
			$lv_buffer .= $lo_reg->load->view('sysdoctab',$lv_prm);
			$lv_buffer .= $lo_reg->load->view('sysdocftr',$lv_prm);
		}
		
  }


	// SALIDA. se realiza la salida al navegador del cliente

  // if not headers defined, add default header
  if ( $lo_res->HeadersCount()==0 ) {
    //$lo_res->addHeader('Content-Type: text/html; charset=utf-8');
    $lo_res->addHeader('Content-Type: text/html; charset=iso-8859-1');
  } 
  $lo_res->setOutput( $lv_buffer ); 
  $lo_res->output();
?>
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
  		$lo_log->write($lo_sec->buscod.'.'.$lo_sec->usrcod.'.PHP ' . $lv_errtyp . ':  ' . $lp_errtxt . ' in ' . $lp_errfle . ' on line ' . $lp_errflelne);
  	}  
  	return true;
  });
	
	
	// EXCEPCIONES. controlador de excepciones
	set_exception_handler(function($exception){
		$lv_msg = 'Uncaught exception: '.$exception->getMessage();
		$lv_msg .= ' ['.$exception->getFile().':'.$exception->getLine().']';
		echo json_encode( array('errtyp'=>'E','errcod'=>-9999,'errtxt'=>$lv_msg) );
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
	$lo_cfg->load('tmssGorse');
  $lo_reg->set('config', $lo_cfg);
  
	// Log
	$lo_log = new tmssLog( $lo_cfg->get('error_filename') );
	$lo_reg->set('log', $lo_log);
  
  // Security
  $lo_sec = new tmssSecurity( $lo_reg );
  $lo_reg->set('sec', $lo_sec);
  
  if ( $lo_reg->sec->is_ssl() == false ) {
    exitWithJsonError('E', '-1', 'La conexión que intenta utilizar para acceder al sitio de gesti&oacute;n no es una conexi&oacute;n SSL v&aacute;lida.');
  }
	
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
  $lo_reg->set('language', $lo_lng);

	// variables globales de error
	$lo_err = array('errcod' => 0, 'errtxt' => '');

	// VALIDO EMPRESA --------------------------------------------------------
	$lv_uri = $_SERVER['REQUEST_URI']; 
	$lv_url = parse_url($lv_uri);
	$lv_paths = array_slice(explode('/', strtolower($lv_url['path'])), 1);

	// Recibí empresa?
	$lv_min_root_levels = 2;
  if(count($lv_paths) < $lv_min_root_levels){
    showErrorMessage('Error al obtener empresa', 'No se especific&oacute; una empresa.');
  }

	// obtener datos de empresa
	$lv_buscodcus = $lv_paths[1];
	$lv_bus = getBussinessConnection($lv_buscodcus);
  if($lv_bus == null){
    showErrorMessage('Error al validar empresa', 'No se encontraron datos de la empresa "'.$lv_buscodcus.'".');
  }
	$lo_reg->sec->bsecnx = $lv_bus['bsecnx'];
  $lo_reg->sec->buscodcus = $lv_buscodcus;
  $lo_lng->initialize();
	$lv_bus['bseurl'] = 'http'.($_SERVER['HTTPS']?'s':'').'://'.$_SERVER['SERVER_NAME'].'/'.implode('/', array_slice($lv_paths, 0, 2));
	$lv_normalize_server_name = function($e){ return ucfirst($e); };
  $lv_svnme = implode('.', array_map($lv_normalize_server_name, explode('.', $_SERVER['SERVER_NAME'])));


	// VALIDO USUARIO --------------------------------------------------------
	$lv_headers = getHeaderData($lv_bus['buscod']);

	if(execRequiresLogin()){
    if($lv_headers['token']){
      // validar token 
      $lo_tkn_mdl = $lo_reg->load->model('syssecusrtkn');
      
      if(!$lo_tkn_mdl->load(array('acctkn' => $lv_headers['token'], 'secusrcod' => $lv_headers['usrcod'], 'usrcod' => $lv_headers['usrcod']))){
        $lv_errcod = -1;
        $lv_errttl = 'Token inv&aacute;lido';
        $lv_errmsg = 'Vuelva a iniciar sesi&oacute;n.';
        
        // mostrar error
        if($lv_headers['from-menu']){
          $lv_exec = '/*script*/toastr.warning("'.$lv_errcod.': '.$lv_errttl.'. '.$lv_errmsg.'");'.
          'localStorage.removeItem("'.$lv_svnme.'.Usrtkn"); localStorage.removeItem("'.$lv_svnme.'.Usrcod");'.
          'tmssLogin(\'La sesión caducó. Por favor, ingrese la contraseña nuevamente.\');';
          exit($lv_exec);
        }else{
          exitWithJsonError('E', '-1', $lv_errttl.'. '.$lv_errmsg);
        }
      }
      
      if(isset($lo_reg->request->get['nxturl'])){
        unset($lo_reg->request->get['nxturl']);
      }

    }else{ 
      if(!$lv_headers['usrcod']){
        sendToLogin($lv_bus);
      }

      if(!$lv_headers['usrpwd']){
        if($lv_headers['from-menu']){
          $lv_errcod = -1;
          $lv_errttl = 'Expir&oacute; la sesi&oacuten';
          $lv_errmsg = 'Vuelva a iniciar sesi&oacute;n.';
          $lv_exec = '/*script*/toastr.warning("'.$lv_errcod.': '.$lv_errttl.'. '.$lv_errmsg.'");'.
          'localStorage.removeItem("'.$lv_svnme.'.Usrtkn"); localStorage.removeItem("'.$lv_svnme.'.Usrcod");'.
          'tmssLogin(\'La sesión caducó. Por favor, ingrese la contraseña nuevamente.\');';
          exit($lv_exec);
        }
        exit();
      }

      // validar login de usuario
      $lv_usrpwd = getPasswordByDirectives($lv_headers['usrcod'], $lv_headers['usrpwd'], $lv_headers['usrpwdupr']); 
      if(!login($lv_bus['bsecnx'], $lv_headers['usrcod'], $lv_usrpwd)){ 
        exitWithJsonError('E', $lo_err['errcod'], $lo_err['errtxt']);
      }
	
      $lo_reg->sec->usrcod = $lo_usr_mdl->usrcod;	

      // verificar si debe cambiar la contraseña
      if(mustChangePassword($lo_reg->sec->usrcod)){ 
        // crear token
        $lo_tknmdl = $lo_reg->load->model('syssecusrtkn');
        $lv_prm = array('usrcod' => $lo_reg->sec->usrcod, 'tknkey' => '<tkntyp>password_recovery</tkntyp>' );

        if ( $lo_tknmdl->create($lv_prm) == false) {
        	exitWithJsonError('E', '-1', 'Se produjo un error al obtener el token de usuario.', array('errvar'=>array('errcod'=>$lo_tknmdl->errcod,'errtxt'=>$lo_tknmdl->errtxt)));
        } else {
          $lv_usrtkn = $lo_tknmdl->acctkn;

          // muestro pantalla para cambiar la contraseña
          $lv_pwdchg = array('sec' => $lo_reg->sec,
                            'lang' => $lo_reg->language,
                            'data' => array('msgtxt' => $lo_err['pwdchgmsg'], 
                                            'recovery' => true,
                                            'usrcod' => $lo_reg->sec->usrcod,
                                            'bsecnx' => $lv_bus['bsecnx'],
                                            'bseurl' => $lv_bus['bseurl'],
                                            'lnktkn' => $lv_usrtkn,
                                            'environmet' => $lv_bus['environmet']
                                           )
                          );
          $lv_buffer = $lo_reg->load->view('sysdochdr2', $lv_pwdchg) .
                      $lo_reg->load->view('syssecusr_pwdchg' , $lv_pwdchg ) .
                      $lo_reg->load->view('sysdocftr2', $lv_pwdchg);
          echo $lv_buffer;
          exit();
        }
      }

      // guardar token
      $lv_token = $lo_usr_mdl->acctkn; 
      if($lv_headers['from-menu']){
        exitWithJsonError('S', 0, '', array('localStorage'=>array($lv_svnme.'.Usrtkn' => $lv_token,
                                                                  $lv_svnme.'.Usrcod' => $lo_reg->sec->usrcod)));
      }else{
        $lv_nxturl = $lo_reg->request->get['nxturl'];
        if(substr($lv_nxturl, -1) == "#"){
          $lv_nxturl = substr($lv_nxturl, 0, strlen($lv_nxturl)-1); 
        }
        $lv_redirect = '/*script*/localStorage.setItem("'.$lv_svnme.'.Usrtkn", "'.$lv_token.'"); '
          .'localStorage.setItem("'.$lv_svnme.'.Usrcod", "'.$lo_reg->sec->usrcod.'");'
          .'window.location.href = "'.$lv_nxturl.'";';
      	exit($lv_redirect);
			}
    }
    
    $lo_reg->sec->usrcod = $lv_headers['usrcod'];
    $lo_usr_mdl->load( array('usrcod'=>$lo_reg->sec->usrcod) );
    $lo_reg->sec->usrtxt = $lo_usr_mdl->usrtxt;
    $lo_reg->sec->buscod = $lv_bus['buscod'];
    $lo_reg->sec->bseurl = 'http'.($_SERVER['HTTPS']?'s':'').'://'.$_SERVER['SERVER_NAME'].$lv_url['path'];
    $lo_reg->sec->bsecnx = $lv_bus['bsecnx'];
  	$lo_lng->initialize();	// necesario que esté luego para que carguen bien las traducciones

    // Usuario con token válido => tiene permiso para acceder a la empresa?
    // obtengo la lista de empresas asignadas al usuario
    $lo_usrbus_mdl = $lo_reg->load->model('syssecusrbus');
    $lv_prm = array('vewmaxrec' =>'1',
                    'vewfldflt' =>'[~fltrow~]u.buscod'.chr(9).'='.chr(9).chr(9).$lv_bus['buscod'].chr(9).chr(9).
                                  '[~fltrow~]u.usrcod'.chr(9).'='.chr(9).chr(9).$lo_reg->sec->usrcod.chr(9).chr(9)
                    );
    $lo_usrbus_rs = $lo_usrbus_mdl->getList($lv_prm);

    if ( count($lo_usrbus_rs)==0 ) {
      exitWithJsonError('E', '-1', 
                        'El usuario <strong>'. $lo_reg->sec->usrcod .'</strong> no tiene permisos para acceder a la empresa '
                        .$lv_bus['buscodcus'].'.<br>Contáctese con el administrador del sistema.');
    }
    $lo_reg->sec->bustxt = $lo_usrbus_rs[0]['bustxt'];
    $lo_reg->sec->timeout = time() + 1800;

    // validar TyC
    $lv_usrtrmacp = $lo_usrbus_rs[0]['usrtrmacp'] ? $lo_usrbus_rs[0]['usrtrmacp'] : (isset($lo_reg->request->post['usrtrmacp']) ? $lo_reg->request->post['usrtrmacp'] : '') ;

    if($lv_usrtrmacp == ''){
      $lv_prm = array('sec' => $lo_reg->sec,
                      'lang' => $lo_reg->language,
                      'input' => $lo_reg->input,
                      'data' => array('buscod'=> $lv_bus['buscod'],
                                      'bustxt'=> $lo_reg->sec->bustxt, 
                                      'usrcod' => $lo_reg->sec->usrcod, 
                                      'bseurl' => $lv_bus['bseurl'], 
                                      'bsecnx' => $lv_bus['bsecnx'],
                                      'rest' => 'X')
                      );
      $lv_buffer = 	$lo_reg->load->view('sysdochdr2', $lv_prm) .
                    $lo_reg->load->view('syssecusr_trmacp', $lv_prm) .
                    $lo_reg->load->view('sysdocftr2', $lv_prm);

      exit($lv_buffer);
    }
  }
	
	// LLAMADO A CONTROLADOR --------------------------------------------------------

	// caso auténtico llamado a controlador: prg=...
	$lv_ctrprg = isset($lo_req->get['prg']) ? $lo_req->get['prg'] : '';
	$lv_actcod = isset($lo_reg->request->get['act']) ? $lo_reg->request->get['act'] : null;
	if($lv_ctrprg){
    setFilters(true);
    /*
    // transformar query params de filtro
    $lv_qryprm = getPrmFromQuery();
    $lv_pwd = 'temasistemas2024';
    $lo_reg->request->get['prm_pwd'] = $lv_pwd;
    if(isset($lv_qryprm['searchflt']) || isset($lv_qryprm['searchord'])){
      $lp_pass = hash( 'sha256', $lv_pwd );
      $lv_iv = substr( $lp_pass, 0, 16 ); 
      
      if(isset($lv_qryprm['searchflt'])){
        $lv_flt = openssl_decrypt( $lv_qryprm['searchflt'], 'AES-256-CBC', $lp_pass, 0, $lv_iv );
        unset($lo_reg->request->get['prm_searchflt']);
        $lo_reg->request->get['prm_vewfldflturi'] = $lv_flt;
      }
      if(isset($lv_qryprm['searchord'])){
        $lv_flt = openssl_decrypt( $lv_qryprm['searchord'], 'AES-256-CBC', $lp_pass, 0, $lv_iv );
        unset($lo_reg->request->get['prm_searchord']);
        $lo_reg->request->get['prm_vewfldord'] = $lv_flt;
      }
    }
    if(isset($lv_qryprm['searchmax'])){
      $lo_reg->request->get['prm_vewmaxrec'] = $lv_qryprm['searchmax'];
      unset($lo_reg->request->get['prm_searchmax']); 
    }*/
    exit(callController($lv_ctrprg, $lv_actcod, getPrmFromQuery()));
  }

	// caso recurso cargado por uri
	if(isset($lv_paths[2]) && $lv_paths[2]){ 
    $lv_restxt = $lv_paths[2];
  	$lo_apictr = $lo_reg->load->controller('sysappapi');
    
    // validar que exista la API y tenga configurado método LOAD
    $lv_possible_res = $lo_apictr->getResource($lv_restxt);
    if(isset($lv_possible_res['errtyp']) && $lv_possible_res['errtyp']=='E'){
      if($lv_possible_res['errcod'] == 404){
        exit(404);
      }else{
        showErrorMessage('Error al cargar recurso solicitado', 'Hubo un error al intentar cargar el recurso ["'.$lv_restxt.'"]: '.$lv_possible_res['errtxt']);
      }
    }
    
    // obtener controlador, tab title y demás parámetros para cargar el recurso
    $lv_resdat = $lv_possible_res;
    $lv_resdat['tab_title'] = html_entity_decode($lv_resdat['tab_title']);
    $lv_cllcmp = $lo_doc->getCallComponents(html_entity_decode(strtolower($lv_resdat['prgfrm'])));
    if($lv_cllcmp['prg'] === ''){
      showErrorMessage('Error al cargar recurso solicitado', 'No se encontr&oacute; el programa correspondiente al recurso ["'.$lv_restxt.'"].');
    }
    $lo_prg = $lo_reg->load->controller( $lv_cllcmp['prg'] );
    $lv_rescod = isset($lv_paths[3]) && $lv_paths[3] ? $lv_paths[3] : ''; 
    
    // obtener query params de la url
   	$lv_qryprmaux = explode('&', isset($lv_url['query'])?$lv_url['query']:'');
    
    // transformar query params de filtro
    if($lv_headers['from-menu']){ 
      setFilters(false);
      /*
      $lv_pwd = 'temasistemas2024';
      $lv_qryprm['pwd'] = $lv_pwd;
      if(isset($lv_qryprm['searchflt'])){
        $lp_pass = hash( 'sha256', $lv_pwd );
        $lv_iv = substr( $lp_pass, 0, 16 ); //var_dump(openssl_decrypt( ($lv_qryprm['searchflt']), 'AES-256-CBC', $lp_pass, 0, $lv_iv ));
        $lv_flt = openssl_decrypt( $lv_qryprm['searchflt'], 'AES-256-CBC', $lp_pass, 0, $lv_iv );
        unset($lv_qryprm['searchflt']); 
        $lv_qryprm['vewfldflturi'] = $lv_flt;

        if(isset($lv_qryprm['searchord'])){
          $lv_flt = openssl_decrypt( $lv_qryprm['searchord'], 'AES-256-CBC', $lp_pass, 0, $lv_iv );
          unset($lv_qryprm['searchord']);
          $lv_qryprm['vewfldord'] = $lv_flt;
        }
      }
      if(isset($lv_qryprm['searchmax'])){
        $lv_qryprm['vewmaxrec'] = $lv_qryprm['searchmax'];
        unset($lv_qryprm['searchmax']); 
      }
      */
    }else if(isset($lv_qryprm['searchflt'])){
      $lo_reg->request->get['searchflt'] = urlencode($lv_qryprm['searchflt']);
    }
    
    $lv_qryprm = $lo_reg->request->get;
    /*foreach($lv_qryprmaux as $lv_row) {
      if (trim($lv_row) == '') { continue; }
      $lv_prm = explode('=', $lv_row);
      $lv_qryprm[$lv_prm[0]] = isset($lv_prm[1])?$lv_prm[1]:'';
    } var_dump($lv_qryprm);*/
    if($lv_rescod){
    	$lv_qryprm[strtolower($lv_resdat['doccod'])] = $lv_rescod; 
    }
    
    // uno query params del programa con los query params de la url
    foreach($lv_cllcmp['prm'] as $lv_key=>$lv_val){
      $lv_qryprm[$lv_key] = $lv_val;
    }
    $lv_qryprm['vewcod'] = $lv_resdat['vewcod'];
    $lv_qryprm['mdlcod'] = $lv_resdat['mdlcod'];
    $lv_qryprm['prgcod'] = $lv_resdat['prgcod'];
    if($lv_rescod){
      $lv_qryprm[$lv_resdat['doccod']] = $lv_rescod;
    }
    unset($lv_qryprm['act']);
    
    // determinar actividad
    $lv_actcod = $lv_cllcmp['act'] ? $lv_cllcmp['act'] : null;
    if(!isset($lv_actcod) && method_exists($lo_prg, 'getAct')){
      // buscar en query params
      foreach($lv_qryprm as $lv_key=>$lv_val) {
        $lv_actcod = $lo_prg->getAct($lv_key);
        if(isset($lv_actcod)){
          break;
        }
      }
    }
    $lv_actcod = $lv_actcod ?? ($lv_rescod ? (isset($lv_qryprm['edit']) ? '02': '03') : (isset($lv_qryprm['new']) ? '01' : '08'));
    
    // armo string de query params para realizar llamado al controlador
    $lv_qryprmstr = '&act='.$lv_actcod; // agrego act
    foreach($lv_qryprm as $lv_key=>$lv_val) {
      $lv_qryprmstr.='&prm_'.$lv_key.'='.$lv_val;
    }
    
    // realizo llamado a controlador
    if($lv_headers['from-menu']){ 
      exit(callController($lv_cllcmp['prg'], $lv_actcod, $lv_qryprm));
    }else{
      $lv_redirect = '/*script*/'.
        'var lv_state = {prev_url: "", current_url: location.href, current_title: "'.$lv_resdat['tab_title'].'"};'.
        'history.pushState(lv_state, "", new URL(location.href));'.
				'tmssCallProcess("?prg='.$lv_cllcmp['prg'].$lv_qryprmstr.'", {}, function(data){'.
        ($lv_resdat['tab_title']?'$("#pageTab > .active > :first").text( "'.$lv_resdat['tab_title'].'" );'.
        '$("#pageTab > .active > :first").append( "<span class=\\\'fas fa-times tmss-tabs-main-close\\\' onClick=\\\'tmssTabFrmClsBtn(this);\\\'></span>" );':'').
        '$("#pageTabContent > .tab-pane.active > .tab-frame:last").html(data);});';
      loadAndRedirect($lv_redirect);
      
    	//$lv_redirect = '/*script*/'.
        //'var lv_state = {prev_url: "", current_url: location.href, current_title: "'.$lv_resdat['tab_title'].'"};'.
        //'history.pushState(lv_state, "", new URL(location.href));'.
				//'tmssLink("?prg='.$lv_cllcmp['prg'].$lv_qryprmstr.'", [{tab_title:"'.$lv_resdat['tab_title'].'"}] )'; ;
      //loadAndRedirect($lv_redirect);
    }
  }

	// caso página principal
	// cargo usuario
  $lo_usr_mdl->load( array('usrcod'=>$lo_reg->sec->usrcod) );
  $lv_strpge = getStartPage($lo_reg->sec->usrcod);

  // cargo la página inicial
  if($lv_headers['from-menu']){
    if ( $lv_strpge !='' ) {
      $lv_strpge = html_entity_decode(strtolower($lv_strpge));
      $lv_cllcmp = $lo_doc->getCallComponents($lv_strpge);
      exit(callController($lv_cllcmp['prg'], $lv_cllcmp['act'], $lv_cllcmp['prm']));
    }else{
      exit(callController('grlstr', '', array()));
    }
  }else{
    $lv_redirect = '/*script*/'.
        'var lv_state = {prev_url: "", current_url: location.href, current_title: "Inicio"};'.
        'history.pushState(lv_state, "", new URL(location.href));';
    if ( $lv_strpge !='' ) {
      $lv_strpge = html_entity_decode(strtolower($lv_strpge));
      $lv_redirect .= 'tmssLink("'.$lv_strpge.'", [{tab_title:"Inicio"}] );';
    } else {
      $lv_redirect .= 'tmssLink("?prg=grlstr", [{tab_title:"Inicio"}] );';
    }

    loadAndRedirect($lv_redirect);
  }

	
  
  // ***************************************************************************
  //
  // O T H E R S    M E T H O D S
  // 
  // ***************************************************************************
	
	/* 
  Devuelve: null si no existe la empresa o si no los siguientes datos:
		buscod 																					-> TEMASIS_LOG
    buscodcus: nombre de la empresa para el usuario -> dev_logistica
    title: nombre de la empresa 										-> Logística
    subtitle: subtítulo en login 										-> <b>Entorno de pruebas</b>
    picture: path del logo de la empresa 						-> https://temasis.com.ar/library/....
    bsecnx: id de conexión 													-> X0....
    environment: entorno														-> sysdev
  */
	function getBussinessConnection($lp_buscodcus){
    global $lo_cfg;
    $lv_customers = $lo_cfg->get('customers');
    $lv_buscodcus = strtolower($lp_buscodcus);
    $lv_bus = null;
    
    if(isset($lv_customers[$lp_buscodcus])){
      if($lv_customers[$lp_buscodcus]['buscod'] && $lv_customers[$lp_buscodcus]['title']
         && isset($lv_customers[$lp_buscodcus]['subtitle']) && $lv_customers[$lp_buscodcus]['picture']
         && $lv_customers[$lp_buscodcus]['connection'] && $lv_customers[$lp_buscodcus]['environmet']){
        
        $lv_bus = array('buscod' => $lv_customers[$lp_buscodcus]['buscod'],
                       'buscodcus' => $lv_buscodcus,
                       'title' => $lv_customers[$lp_buscodcus]['title'],
                       'subtitle' => $lv_customers[$lp_buscodcus]['subtitle'],
                       'picture' => $lv_customers[$lp_buscodcus]['picture'],
                       'bsecnx' => $lv_customers[$lp_buscodcus]['connection'],
                       'environmet' => $lv_customers[$lp_buscodcus]['environmet']);
      }
    }
    
    return $lv_bus;
  }

	function execRequiresLogin(){
    global $lo_req;
		$lv_execute_requires_login = true;
    if (isset($lo_req->get['prg']) && isset($lo_req->get['act'])){
      $lv_ctrprg = $lo_req->get['prg'];
      $lv_actcod = $lo_req->get['act'];
      
      if($lv_ctrprg == 'syssecusrpwd'){
        switch ($lv_actcod){
          case '11': case '12': case '14': case 'getPwdDirectives': 
            $lv_execute_requires_login = false;
        }
      }else if($lv_ctrprg == 'syssecusr'){
         switch ($lv_actcod){
          case '99':
             $lv_execute_requires_login = false;
         }
      }
    }
    
    return $lv_execute_requires_login;
  }

	function showErrorMessage($lp_title, $lp_description){
    echo '
    	<html>
      	<head>
          <meta http-equiv="Content-Type" content="text/html;">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <meta charset="UTF-8">
          <title>TEMASIS Argentina - Error 404 - No encontrado</title>
          <style type="text/css">
            body { font-family: helvetica, arial; }
            p { line-height: 1.6; }
          </style>
				</head>
        <body>
          <div style="text-align: center; margin-bottom: 10px;">
      			<img src="../../library/images/temasisargentina_280px.png" width="180" height="180">
          </div>
          <div style="text-align: center;">
            <div style="text-align: left; display: inline-block; width: 80%; background-color: #f1f1f1;">
          		<div style="padding: 0px 20px;">
          			<h1>'.$lp_title.'</h1>
                <p>'.$lp_description.'</p>
      				</div>
            </div>
          </div>
      	</body>
      </html>';
    exit();
  }
	
	function sendToLogin($lp_cnxprm){
    global $lo_reg;
    $lv_prm = array('lang'=> $lo_reg->language,
                  'sec' => $lo_reg->sec,
                  'doc' => $lo_reg->document,
                  'plugins' => array( 'logon', 'message', 'chat', 'popup', 'recent', 'favorites' ),
                  'data' => array('cnx' => $lp_cnxprm),
                  );
    $lv_buffer  = $lo_reg->load->view('sysdochdrlgn', $lv_prm)
      						.$lo_reg->load->view('sysdoclgn', $lv_prm)
      						.$lo_reg->load->view('sysdocftr2', $lv_prm);
    
    $lo_reg->response->setOutput( $lv_buffer ); 
    $lo_reg->response->output();
    exit();
  }

	// TODO probablemente ya no sea necesaria esta función
	function getHeaderData($lp_buscod){
    $lv_all_headers = getallheaders(); 
    $lv_headers = [];
    $lv_svnme = ucfirst($_SERVER['SERVER_NAME']);
    
    $lv_headers['token'] = isset($lv_all_headers[$lv_svnme.'.usrtkn']) ? ($lv_all_headers[$lv_svnme.'.usrtkn'] != "null" ? $lv_all_headers[$lv_svnme.'.usrtkn'] : '') : '';
    $lv_headers['from-menu'] = $lv_all_headers['Tmss-From-Menu'] ?? '';
    $lv_headers['usrcod'] = $lv_all_headers[$lv_svnme.'.usrcod'] ?? '';
    $lv_headers['usrpwd'] = $lv_all_headers['Tmss-Usrpwd'] ?? '';
    $lv_headers['usrpwdupr'] = isset($lv_all_headers['Tmss-Usrpwdupr']) ? ($lv_all_headers['Tmss-Usrpwdupr'] != "null" ? $lv_all_headers['Tmss-Usrpwdupr'] : $lv_headers['usrpwd']) : $lv_headers['usrpwd'];
    
    return $lv_headers;
  }

	function getPasswordByDirectives($lp_usrcod, $lp_pwd, $lp_pwdupr){
    global $lo_usr;
    $lv_usrpwd = '';
    
    if($lp_pwd == $lp_pwdupr){
      $lv_usrpwd = $lp_pwd;
    }else{
      $lo_drt = $lo_usr->getUserDirectives($lp_usrcod); 
      // valida case sensitive
      $lv_cs = false;
      if( count($lo_drt)>0 ){
       $lv_cs_drt = array_filter($lo_drt, function($elem){ return (strtolower($elem['syssecdrttypcodext'])=='pwdlgncasesensitive'); });
       $lv_cs = (($lv_cs_drt[0]['syssecdrttypdef']??'') == '1' ? true : false);
      }
      $lv_usrpwd = ($lv_cs ? $lp_pwd : $lp_pwdupr);
    }
    
    return $lv_usrpwd;
  }

	function login($lp_bsecnx, $lp_usrcod, $lp_pwd) {
    global $lo_reg, $lo_err, $lo_usr_mdl;
    if ( $lp_usrcod=='' || $lp_pwd=='' || $lp_bsecnx=='' ) {
			$lo_err['errcod'] = -9;
			$lo_err['errtxt'] = 'Uno o m&aacute;s par&aacute;metros previstos no se ha proporcionado';
      return false;
    } else {
      // check username and password in database
			$lv_prm = array( 'usrcod'=>$lp_usrcod, 'usrpwd'=>$lp_pwd );
			if ( $lo_usr_mdl->checkUserLogin($lv_prm)==false ) {
				$lo_err['errcod'] = $lo_usr_mdl->errcod;
				$lo_err['errtxt'] = $lo_usr_mdl->errtxt;
      	return false;
			}
    }
    
		return true;
  }

	function mustChangePassword($lp_usrcod){
    global $lo_err, $lo_usr_mdl;
    $lv_usrpwdchange = false;
    
    if(!passwordIsStillValid($lp_usrcod, $lo_usr_mdl->pwddays)){
      $lo_err['pwdchgmsg'] = $lo_err['errtxt'];
      $lv_usrpwdchange = true;
    }else if($lo_usr_mdl->usrpwdchg == '1'){
      $lo_err['pwdchgmsg'] = 'El administrador del sistema actualizó su contrase&ntilde;a. Por favor, ingrese una nueva contrase&ntilde;a.';
      $lv_usrpwdchange = true;
    }
    
    return $lv_usrpwdchange;
  }

	function passwordIsStillValid($lp_usrcod, $lp_pwddays){
    global $lo_usr, $lo_err;
    $lo_drt = $lo_usr->getUserDirectives($lp_usrcod); 
    
    foreach( $lo_drt as $lv_row ) {
      if (strtolower($lv_row['syssecdrttypcodext']) == 'lgnpwdvaliddays') {
        if(intval($lv_row['syssecdrttypdef']) < $lp_pwddays ){
          $lo_err['errcod'] = -1;
          $lo_err['errtxt'] = 'Su contrase&ntilde;a ha caducado. Ingrese una nueva contrase&ntilde;a.';
          return false;
        }
      }
    }
    
    return true;
  }
      
  function callController($lp_ctr, $lp_actcod, $lp_prm){
    global $lo_reg;
    
    $lo_prg = $lo_reg->load->controller( $lp_ctr );
    $lv_buffer = $lo_prg->index( $lp_actcod , $lp_prm );
    
    $lo_reg->response->setOutput( $lv_buffer ); 
    $lo_reg->response->output();
  }    

	function getPrmFromQuery(){
    global $lo_reg;
    $lv_prm = array();
    
    foreach ( $lo_reg->request->get as $lv_key => $lv_val ) {
      if ( substr( strtolower($lv_key), 0, 4)=='prm_' ) {
        $lv_prm[ substr(strtolower($lv_key),4,strlen($lv_key)-4) ] = $lv_val;
      }
    }
    
    return $lv_prm;
  }

	function getStartPage($lp_usrcod){
    global $lo_usr_mdl, $lo_reg;
    $lv_strpge='';

    // busco página de inicio en los grupos asignados al usuario (tomo la primera)
    $lo_usrgrp_mdl = $lo_reg->load->model('syssecusrgrp');
    $lo_usrgrp_rs = $lo_usrgrp_mdl->load( array('usrcod'=>$lp_usrcod) );
    foreach($lo_usrgrp_rs as $lv_row){
      if ($lo_reg->document->getTagValue($lv_row['usrgrpatr001'],'strpge')!=''){
        $lv_strpge = $lo_reg->document->getTagValue($lv_row['usrgrpatr001'],'strpge');
        break;
      }
    }

    // si no tiene asignación por grupo, busco si tiene el usuario
    if ($lv_strpge==''){
      $lv_strpge = $lo_reg->document->getTagValue($lo_usr_mdl->usratr001,'strpge');
    }

    return $lv_strpge;
  }

	function loadAndRedirect($lp_redirect){
    global $lo_usr_mdl, $lo_reg;
    // obtengo opciones de menú
    $lv_mnu = array();
    $lv_mnu = $lo_reg->document->getMenu();

    // obtengo empresas del usuario
    $lo_usrbus_mdl = $lo_reg->load->model('syssecusrbus');
    $lo_bus = $lo_usrbus_mdl->load( array('usrcod'=>$lo_reg->sec->usrcod) );

    // preparo parámetros
    $lv_prm = array('mnu' => $lv_mnu,
                    'lang'=> $lo_reg->language,
                    'sec' => $lo_reg->sec,
                    'doc' => $lo_reg->document,
                    'plugins' => array( 'logon', 'message', 'chat', 'popup', 'recent', 'favorites' ),
                    'data' => array('redirect' => $lp_redirect),
                    'bus' => $lo_bus,
                    'usr' => $lo_usr_mdl
                    );

    $lv_buffer  = $lo_reg->load->view('sysdochdr', $lv_prm);
    $lv_buffer .= $lo_reg->load->view('sysdocmnu', $lv_prm);
    $lv_buffer .= $lo_reg->load->view('sysdocftr', $lv_prm);

    // if not headers defined, add default header
    if ( $lo_reg->response->HeadersCount()==0 ) {
      $lo_reg->response->addHeader('Content-Type: text/html; charset=utf-8');
      //$lo_reg->response->addHeader('Content-Type: text/html; charset=iso-8859-1');
    } 

    // Output
    $lo_reg->response->setOutput( $lv_buffer ); 
    $lo_reg->response->output();
    exit();
  }

	function exitWithJsonError($lp_errcod, $lp_errtyp, $lp_errtxt, $lp_extra = array()){
    global $lo_reg;
    $lv_arr = array('errtyp'=>$lp_errcod,'errcod'=>$lp_errtyp,'errtxt'=>$lp_errtxt);
    exit( $lo_reg->document->getJson( array_merge($lv_arr, $lp_extra) ) );
  }

	// desencripta los filtros de la url si existen
	// $lp_uses_prm indica con true si las keys de los filtros empiezan con "prm_..."
	function setFilters($lp_uses_prm){
    global $lo_reg;
    $lv_keyprefix = $lp_uses_prm?'prm_':'';
    $lv_pwd = 'temasistemas2024';
    $lo_reg->request->get[$lv_keyprefix.'pwd'] = $lv_pwd;
    
    if(isset($lo_reg->request->get[$lv_keyprefix.'searchflt']) || isset($lo_reg->request->get[$lv_keyprefix.'searchord'])){
      $lp_pass = hash( 'sha256', $lv_pwd );
      $lv_iv = substr( $lp_pass, 0, 16 ); 
      
      if(isset($lo_reg->request->get[$lv_keyprefix.'searchflt'])){
        $lv_flt = openssl_decrypt( $lo_reg->request->get[$lv_keyprefix.'searchflt'], 'AES-256-CBC', $lp_pass, 0, $lv_iv );
        unset($lo_reg->request->get[$lv_keyprefix.'searchflt']);
        $lo_reg->request->get[$lv_keyprefix.'vewfldflturi'] = $lv_flt;
      }
      if(isset($lo_reg->request->get[$lv_keyprefix.'searchord'])){
        $lv_flt = openssl_decrypt( $lo_reg->request->get[$lv_keyprefix.'searchord'], 'AES-256-CBC', $lp_pass, 0, $lv_iv );
        unset($lo_reg->request->get[$lv_keyprefix.'searchord']);
        $lo_reg->request->get[$lv_keyprefix.'vewfldord'] = $lv_flt;
      }
    }
    if(isset($lo_reg->request->get[$lv_keyprefix.'searchmax'])){
      $lo_reg->request->get[$lv_keyprefix.'vewmaxrec'] = $lo_reg->request->get[$lv_keyprefix.'searchmax'];
      unset($lo_reg->request->get[$lv_keyprefix.'searchmax']); 
    }
  }
?>

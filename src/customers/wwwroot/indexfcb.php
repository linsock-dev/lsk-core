<?php
	if(!session_id()) { session_start(); }
	$lo_ses = $_SESSION;

	require_once __DIR__ . '/../library/plugins/phptools/php-graph/Facebook.5x/autoload.php'; // change path as needed
	
	$lv_fcb = new \Facebook\Facebook([
		'app_id' => '1243421782410174',
		'app_secret' => 'b6381e3eb4ec6b06cc1aaff73a99855c',
		'default_graph_version' => 'v5.0',
	]);

	// Use one of the helper classes to get a Facebook\Authentication\AccessToken entity.
	//   $helper = $fb->getRedirectLoginHelper();
	//   $helper = $fb->getJavaScriptHelper();
	//   $helper = $fb->getCanvasHelper();
	//   $helper = $fb->getPageTabHelper();

	try{
		//$lv_fcb_helper = $lv_fcb->getRedirectLoginHelper();
		$lv_fcb_helper = $lv_fcb->getJavaScriptHelper();
		$lv_fcb_accessToken = $lv_fcb_helper->getAccessToken();  
	} catch(Exception $e) {
		echo 'Se producjo un error al obtener el token de acceso.';
		//var_dump($e);
		//echo 'Error: '.$e->getMessage();
		exit;
	}
		
	try {
		// Get the \Facebook\GraphNodes\GraphUser object for the current user.
		// If you provided a 'default_access_token', the '{access-token}' is optional.
		$lv_fcb_response = $lv_fcb->get('/me?fields=id,name,email', $lv_fcb_accessToken);
	} catch(\Facebook\Exceptions\FacebookResponseException $e) {
		// When Graph returns an error
		echo 'Se produjo un error al obtener los datos del usuario';
		//echo 'Graph returned an error: ' . $e->getMessage();
		exit;
	} catch(\Facebook\Exceptions\FacebookSDKException $e) {
		// When validation fails or other local issues
		echo 'Se produjo un error en el SDK.';
		//echo 'Facebook SDK returned an error: ' . $e->getMessage();
		exit;
	}

	$me = $lv_fcb_response->getGraphUser();

	/*
	$postdata = http_build_query(
					array(
            'usrcod' => $me->getField('email'),
						'usrpwd' => hash('sha256','Facebook'),
            'bseurl' => 'https://temasis.com.ar/temasis-com-ar/sysdev/index2.php',
						'bsecnx' => 'X000080192',
						'login'  => '1',
						'lgnfcb' => '1'
          )
	);
	$opts = array('http' =>
			array(
					'method'  => 'POST',
					'header'  => 'Content-type: application/x-www-form-urlencoded',
					'content' => $postdata,
					'user_agent' => $_SERVER['HTTP_USER_AGENT'].''
			)
	);
	$context  = stream_context_create($opts);
	$result = file_get_contents('https://www.temasis.com.ar/sysdev/tmssOnLine/index.php?prg=syssecusr&act=98', false, $context);
	echo $result;
	*/
	
	$lv_bseurl = (isset($lo_ses['bseurl'])?$lo_ses['bseurl']:'https://temasis.com.ar/temasis-com-ar/sysdev/index2.php');
	$lv_bsecnx = (isset($lo_ses['bsecnx'])?$lo_ses['bsecnx']:'X000080192');
	$lv_lgnurl = (isset($lo_ses['lgnurl'])?$lo_ses['lgnurl']:'https://www.temasis.com.ar/sysdev/tmssOnLine/index.php?prg=syssecusr&act=98');
	
	// building array of variables
	$content = array(
            'usrcod' => $me->getField('email'),
						'usrpwd' => hash('sha256','Facebook'),
            'bseurl' => $lv_bseurl,
						'bsecnx' => $lv_bsecnx,
						'login'  => '1',
						'lgnfcb' => '1'
            );

	try {
		$ch = curl_init();
		
    // Check if initialization had gone wrong*    
    if ($ch === false) {
      throw new Exception('Se produjo un error al inicializar el redireccionamiento.');
    }
		
		curl_setopt($ch, CURLOPT_URL, $lv_lgnurl);
		curl_setopt($ch, CURLOPT_SSLCERT, __DIR__ . '\..\..\..\SSLFiles\Temasis\Cert\Temasis2019_pubCert.pem'); 
		curl_setopt($ch, CURLOPT_SSLKEY, __DIR__ . '\..\..\..\SSLFiles\Temasis\Cert\Temasis2019_privKey.pem');
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($ch, CURLOPT_SSLCERTTYPE,'PEM');
		curl_setopt($ch, CURLOPT_VERBOSE, true);
		curl_setopt($ch, CURLOPT_USERAGENT, $_SERVER['HTTP_USER_AGENT']);
		curl_setopt($ch, CURLOPT_HEADER, false);
		curl_setopt($ch, CURLOPT_POST, true);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $content);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, false); 
		curl_setopt($ch, CURLOPT_COOKIEFILE, 'cookiefile.txt');
		curl_setopt($ch, CURLOPT_COOKIEJAR, 'cookiefile.txt');
		
		$return = curl_exec($ch);
		
    // Check the return value of curl_exec(), too
    if ($return === false) {
      throw new Exception(curl_error($ch), curl_errno($ch));
    }
		
		curl_close($ch);
	} catch(Exception $e) {
		echo 'Se produjo un error en el redireccionamiento.';
    trigger_error(sprintf('Curl failed with error #%d: %s',$e->getCode(), $e->getMessage()),E_USER_ERROR);
		exit;
	}

	//echo $return;
?>

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

	// Toda llamada a gorse.task.php trae al menos prg y act en la query.
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
  set_error_handler(function ($lp_errcod, $lp_errtxt, $lp_errfle, $lp_errflelne) {
      global $lo_gorse;
      // error suppressed with @
      if (error_reporting() === 0) {
          return false;
      }
      switch ($lp_errcod) {
          case E_NOTICE:
          case E_USER_NOTICE:
              $lv_errtyp = 'Info';
              break;
          case E_WARNING:
          case E_USER_WARNING:
              $lv_errtyp = 'Advertencia';
              break;
          case E_ERROR:
          case E_USER_ERROR:
              $lv_errtyp = 'Error';
              break;
          default:
              $lv_errtyp = 'Desconocido';
              break;
      }

      return true;
  });

	// EXCEPCIONES. controlador de excepciones
	set_exception_handler(function($exception){
		$lv_msg = 'Uncaught exception: '.$exception->getMessage();
		$lv_msg .= ' ['.$exception->getFile().':'.$exception->getLine().']';
		echo json_encode( array('errtyp'=>'E','errcod'=>-9999,'errtxt'=>$lv_msg) );
	});
	
	//	************************************* I N S T A N C I A C I O N  D E  C L A S E S **************************************************************************************//

	// AUTOLOAD. carga archivos de clases cuando estas se declaran
  spl_autoload_register(function($lp_clsnme) {
    if ( substr($lp_clsnme,0,4)=='tmss' ) {
      $lv_fle = __SITE_PATH . '/../system/engine/' . $lp_clsnme . '.php';
    } else {
      $lv_fle = __SITE_PATH . '/../tmssOnLine/controller/' . strtolower($lp_clsnme) . '.php';
    }
var_dump('archivo '.$lp_clsnme);
    if (file_exists($lv_fle) == false) {
			var_dump(' no ');
      return false;
    } else {
			var_dump(' si ');

		}
    include($lv_fle);
  });
  
	
	// GORSE TASK. clase principal de GORSE TASK que gestiona todas las operaciones 
final class GorseTask
{
    protected $co_reg;
    protected $co_err;
    const GORSE_EXPIRATION_TIME = 3600; // 3600 seconds = 1 hour
    const GORSE_TASK_KEY = '7cOgUJCPSKCASL7XXJ5WxQ9qOuMR9UEcYDo0YrFe3bt63l3bmHuBUI3GjRDe2ez9';

  // CONSTRUCT. inicializa las clases principales de la aplicacion (Registry, Config, Log, Security, etc.)
  // @return void
    public function __construct() {
      	//content-Type
      	header('Content-Type: text/html; charset=iso-8859-1');
      
        // Registry. Clase para registrar otras clases
        $this->co_reg = new tmssRegistry();

        // Config. Clase para gestionar configuraciones de clientes
        $lo_cfg = new tmssConfig();
        $lo_cfg->load('tmssGorse');	// carga configuracion especifica de la aplicacion
        $this->co_reg->set('config', $lo_cfg);

        // Log. clase el registro de log de errores
        $lo_log = new tmssLog($lo_cfg->get('error_filename'));
        $this->co_reg->set('log', $lo_log);

        // Security. clase para gestionar la seguridad del sistema
        $lo_sec = new tmssSecurity($this->co_reg);
        $this->co_reg->set('sec', $lo_sec);
        // La validación SSL se hace en run(), porque necesita 'document', que se registra más abajo.

        // Security Java Web Token. gestiona tokens de seguridad
        $lo_secjwt = new tmssSecurityJWT();
        $this->co_reg->set('secjwt', $lo_secjwt);

        // Loader. clase para cargar vistas y controladores
        $lo_loa = new tmssLoader($this->co_reg);
        $this->co_reg->set('load', $lo_loa);

        // Session. clase para gestionar datos de sesion de usuario
        $lo_ses = new tmssSession();
        $lo_ses->startSession();
        $this->co_reg->set('session', $lo_ses);

        // Request. clase para gestionar request get, post y file
        $lo_req = new tmssRequest();
        $this->co_reg->set('request', $lo_req);

        // Response. clase para gestionar respuesta a cliente
        $lo_res = new tmssResponse();
        $this->co_reg->set('response', $lo_res);

        // Database. clase para gestionar accesos a base de datos
        $lo_db = new tmssDatabase($this->co_reg);
        $this->co_reg->set('db', $lo_db);

        // Url. clase para gestionar operaciones de url
        $lo_url = new tmssUrl();
        $this->co_reg->set('url', $lo_url);

        // Document. clase para tratamiento de documento
        $lo_doc = new tmssDocument($this->co_reg);
        $this->co_reg->set('document', $lo_doc);

        // Input. Clase para gestionar campos input en documentos
        $lo_inp = new tmssInput($this->co_reg);
        $this->co_reg->set('input', $lo_inp);

        // User. controlador de operaciones de usuario.
        $lo_usr = $this->co_reg->load->controller('syssecusr');
        $this->co_reg->set('user', $lo_usr);

        // Language. clase para idioma y traduccion
        $lo_lng = new tmssLanguage($this->co_reg);
        $this->co_reg->set('language', $lo_lng);

        // inicializo variable de error
        $this->co_err = array('errtyp' => '', 'errcod' => 0, 'errtxt' => '', 'errmsg' => '');
    }

  // RUN. punto de entrada. Elige el camino según haya o no un token en el header:
  //   - con token  -> ejecución de una tarea (sus datos van cifrados en el token).
  //   - sin token  -> operación auxiliar (los datos de conexión van en el header).
  // @return void
    public function run()
    {
      // Toda salida es un JSON que entienden node.php y grldattsk.js. Hay un único punto de salida.
      if ( $this->co_reg->sec->is_ssl() == false ) {
        $lv_res = $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'La conexión que intenta utilizar para acceder al sitio de gesti&oacute;n no es una conexi&oacute;n SSL v&aacute;lida.') );
      } else {
        $this->_initPost();
        $lv_headers = $this->_getHeaders();
        $lv_res = !empty($lv_headers['jwt']) ? $this->_runTask( $lv_headers['jwt'] ) : $this->_runAux( $lv_headers );
      }

      $this->co_reg->response->setOutput( $lv_res );
      $this->co_reg->response->output();
    }

  // INIT POST. interpreta el cuerpo del pedido (JSON o formulario) y lo deja en request->post.
  // @return void
  private function _initPost(){
    $lo_post = $this->co_reg->request->post;
    $lo_raw_post = file_get_contents('php://input');
    if(count($lo_post)==0 && !empty($lo_raw_post)) {
      // Si era un JSON
      $lo_post = json_decode($lo_raw_post, true);
      // Si era un formulario x-www-form-urlencoded, lo parseamos:
      if (empty($lo_post)) {
        parse_str($lo_raw_post, $lo_post);
      }
      $this->co_reg->request->post = $lo_post;
    }
  }

  // GET HEADERS. devuelve los headers con las claves en minúscula, para leerlos siempre igual
  // sin importar cómo los escriba el servidor.
  // @return array
  private function _getHeaders(){
    $lv_out = array();
    foreach ( (array) getallheaders() as $lv_key => $lv_val ) {
      $lv_out[ strtolower($lv_key) ] = $lv_val;
    }
    return $lv_out;
  }

  // RUN TASK. camino cifrado: decodifica el token de la tarea, resuelve la conexión a partir
  // del buscod y despacha la tarea al controlador correspondiente.
  // @param string $lp_jwt token recibido por header
  // @return void
  private function _runTask( $lp_jwt ){
    // 1. DECODIFICAR TOKEN
    $lv_jwt = $this->co_reg->secjwt::validateJwt( $lp_jwt, self::GORSE_TASK_KEY );
    if ( ($lv_jwt['errtyp'] ?? 'E') != 'S' ) {
      return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>401,'errtxt'=>'El token es invalido. '.($lv_jwt['errtxt'] ?? $lv_jwt['errmsg'] ?? '')) );
    }
    $lv_dat = $lv_jwt['data'];

    // 2. Vencimiento (se controla acá, no lo hace validateJwt).
    if ( !empty($lv_dat['exp']) && $lv_dat['exp'] < date('Y-m-d H:i:s') ) {
      return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>401,'errtxt'=>'El token esta vencido.') );
    }

    // 3. Resuelve la conexión a partir del buscod.
    $lv_busdat = $this->_resolveBusiness( $lv_dat['buscod'] ?? '' );
    if ( $lv_busdat === false ) {
      return $this->co_reg->document->getJson( $this->co_err );
    }

    // 4. Arma el contexto de seguridad. De 'customers' sólo se toma bsecnx (campo 'connection').
    // El resto se fija: usrcod/usrtxt del usuario de tareas, bustxt = buscod y bseurl con la
    // URL del sitio actual. bseurl no puede quedar vacío: el envío de mails lo necesita.
    $lv_buscod = $lv_busdat['buscod'] ?? ($lv_dat['buscod'] ?? '');
    $this->co_reg->sec->usrcod  = 'TEMASIS_TASK';
    $this->co_reg->sec->usrtxt  = 'TEMASIS';
    $this->co_reg->sec->buscod  = $lv_buscod;
    $this->co_reg->sec->bustxt  = $lv_buscod;
    $this->co_reg->sec->bsecnx  = $lv_busdat['connection'] ?? '';
    $this->co_reg->sec->bseurl  = 'https://' . ($_SERVER['HTTP_HOST'] ?? 'developers.gorse.ar');
    $this->co_reg->sec->timeout = time() + 1;

    // 4b. Valida el contexto de conexión. Si falta algún dato, la tarea fallaría más
    // adelante sin un mensaje claro, así que se reporta acá indicando cuál falta.
    $lv_ctxmis = array();
    if ( $lv_buscod=='' )                            { $lv_ctxmis[] = 'buscod'; }
    if ( ($this->co_reg->sec->bsecnx ?? '')=='' )    { $lv_ctxmis[] = 'bsecnx (cadena de conexion; campo "connection" del cliente)'; }
    if ( ($this->co_reg->sec->bseurl ?? '')=='' )    { $lv_ctxmis[] = 'bseurl'; }
    if ( ($this->co_reg->sec->usrcod ?? '')=='' )    { $lv_ctxmis[] = 'usrcod'; }
    if ( count($lv_ctxmis)>0 ) {
      return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-3,'errtxt'=>'Datos de conexion incompletos para buscod ['.$lv_buscod.']: faltan '.implode(', ', $lv_ctxmis).'.') );
    }

    // 5. Saca prg, act y los parámetros de la URL de la tarea.
    list( $lv_prg, $lv_act, $lv_urlprm ) = $this->_parseTaskUrl( $lv_dat['url'] ?? '' );
    if ( $lv_prg=='' || $lv_act=='' ) {
      return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>400,'errtxt'=>'URL de tarea sin prg o act.') );
    }

    // parámetros = los de la URL + los de tskatr.
    $lv_prm = $lv_urlprm;
    if ( isset($lv_dat['tskatr']) && is_array($lv_dat['tskatr']) ) {
      $lv_prm = array_merge( $lv_prm, $lv_dat['tskatr'] );
    }

    // 6. Despacha la tarea al controlador. El try/catch evita que una excepción deje
    // la respuesta vacía y termine reportándose como "no devolvió respuesta".
    $lo_ctr = $this->co_reg->load->controller( $lv_prg );
    try {
      $lv_out = $lo_ctr->index( $lv_act, $lv_prm );
    } catch ( \Throwable $e ) {
      return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>"Excepcion ejecutando $lv_prg#$lv_act: ".$e->getMessage().' ['.basename($e->getFile()).':'.$e->getLine().']','url'=>$lv_dat['url'] ?? '') );
    }

    // Si el controlador no devuelve nada, se reporta como error (no como éxito vacío).
    if ( $lv_out === null || $lv_out === '' || $lv_out === false ) {
      return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-2,'errtxt'=>"La accion $lv_prg#$lv_act no devolvio respuesta.",'url'=>$lv_dat['url'] ?? '') );
    }

    // Garantiza que la salida sea siempre un JSON con errtyp. Si el controlador devolvió
    // un texto que no es JSON, igual se conserva su mensaje.
    return $this->_normalizeOutput( $lv_out, $lv_prg, $lv_act );
  }

  // NORMALIZE OUTPUT. asegura que la respuesta sea siempre un JSON con errtyp.
  // Si ya lo es, se respeta; si es del tipo "cod: texto" se traduce (cod 0 => 'S', resto => 'E');
  // cualquier otro texto se envuelve sin perder su contenido.
  // @param mixed  $lp_out salida del controlador
  // @param string $lp_prg
  // @param string $lp_act
  // @return string JSON
  private function _normalizeOutput( $lp_out, $lp_prg, $lp_act ){
    // array/objeto: si ya trae errtyp lo serializo tal cual; si no, lo envuelvo como éxito.
    if ( !is_string($lp_out) ) {
      if ( is_array($lp_out) && isset($lp_out['errtyp']) ) {
        return $this->co_reg->document->getJson( $lp_out );
      }
      return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>"Accion $lp_prg#$lp_act ejecutada.",'data'=>$lp_out) );
    }

    $lv_trim = trim( $lp_out );

    // ya es JSON con errtyp -> pasa sin tocar
    $lv_dec = json_decode( $lv_trim, true );
    if ( is_array($lv_dec) && isset($lv_dec['errtyp']) ) {
      return $lp_out;
    }

    // formato "cod: texto" (ej. "0: Enviado", "-1: No se encontró el texto del mensaje.")
    if ( preg_match('/^(-?\d+)\s*:\s*(.*)$/s', $lv_trim, $lv_m) ) {
      $lv_cod = intval($lv_m[1]);
      $lv_txt = trim($lv_m[2]);
      $lv_typ = ($lv_cod===0) ? 'S' : 'E';
      if ( $lv_typ==='S' && $lv_txt==='' ) { $lv_txt = "Accion $lp_prg#$lp_act ejecutada correctamente."; }
      return $this->co_reg->document->getJson( array('errtyp'=>$lv_typ,'errcod'=>$lv_cod,'errtxt'=>$lv_txt) );
    }

    // cualquier otro texto: se envuelve conservando el contenido. errtyp 'S' porque el
    // controlador terminó y devolvió algo.
    return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>$lv_trim) );
  }

  // RUN AUX. camino sin cifrar para las operaciones auxiliares (getexecutionlist,
  // updatestatus, getnextexecution, senderrormail). Los datos de conexión vienen por
  // header y prg/act por el pedido.
  // @param array $lp_headers headers en minúscula
  // @return void
  private function _runAux( $lp_headers ){
    // 1. Arma el contexto de seguridad con los datos del header.
    $this->co_reg->sec->usrcod = $lp_headers['usrcod'] ?? '';
    $this->co_reg->sec->usrtxt = $lp_headers['usrtxt'] ?? '';
    $this->co_reg->sec->buscod = $lp_headers['buscod'] ?? '';
    $this->co_reg->sec->bustxt = $lp_headers['bustxt'] ?? '';
    $this->co_reg->sec->bsecnx = $lp_headers['bsecnx'] ?? '';
    $this->co_reg->sec->bseurl = $lp_headers['bseurl'] ?? '';
    $this->co_reg->sec->timeout = time() + 1;

    // 2. Toma prg y act de la query, o del cuerpo si no están.
    $lv_prg = strtolower( $_GET['prg'] ?? ($this->co_reg->request->post['prg'] ?? '') );
    $lv_act = strtolower( $_GET['act'] ?? ($this->co_reg->request->post['act'] ?? '') );
    if ( $lv_prg=='' || $lv_act=='' ) {
      return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>400,'errtxt'=>'Falta prg o act.') );
    }

    // 3. Despacha al controlador, que lee el cuerpo y devuelve su respuesta en JSON.
    $lo_ctr = $this->co_reg->load->controller( $lv_prg );
    return $lo_ctr->index( $lv_act, $this->co_reg->request->post );
  }

  // RESOLVE BUSINESS. obtiene los datos de conexión a partir del buscod.
  // validateBusinessConnection busca en 'customers' por BusCodCus, no por buscod, así que
  // primero hay que encontrar el BusCodCus cuyo campo buscod coincide y recién ahí resolver el resto.
  // @param string $lp_buscod código interno de empresa
  // @return array|false datos de conexión, o false (con $this->co_err) si falla
  private function _resolveBusiness( $lp_buscod ){
    // 1. Busca el BusCodCus cuyo campo buscod coincide.
    $lv_cus_arr = $this->co_reg->config->get('customers');
    $lv_buscodcus = null;
    if ( is_array($lv_cus_arr) ) {
      foreach ( $lv_cus_arr as $lv_key => $lv_row ) {
        if ( is_array($lv_row) && ($lv_row['buscod'] ?? '') == $lp_buscod ) { $lv_buscodcus = $lv_key; break; }
      }
    }
    if ( $lv_buscodcus === null ) {
      $this->co_err = array('errtyp'=>'E','errcod'=>404,'errtxt'=>'No se encontro empresa para el buscod ['.$lp_buscod.'].');
      return false;
    }

    // 2. Resuelve el resto de los datos con validateBusinessConnection.
    $lv_busdat = $this->co_reg->sec->validateBusinessConnection( $lv_buscodcus );
    if ( $lv_busdat === false ) {
      $this->co_err = $this->co_reg->sec->getErrors();
      return false;
    }
    $lv_busdat['buscodcus'] = $lv_buscodcus;
    return $lv_busdat;
  }

  // PARSE TASK URL. extrae prg, act y los parámetros de la URL de la tarea, descartando
  // las claves de conexión.
  // @param string $lp_url url de la tarea
  // @return array [ prg, act, params ]
  private function _parseTaskUrl( $lp_url ){
    $lv_prg=''; $lv_act=''; $lv_prm=array();
    $lv_qs = parse_url( $lp_url, PHP_URL_QUERY );
    if ( !empty($lv_qs) ) {
      parse_str( $lv_qs, $lv_q );
      $lv_reserved = array('prg','act','usrcod','usrtxt','buscod','bustxt','bsecnx','bseurl');
      foreach ( $lv_q as $lv_key => $lv_val ) {
        $lv_lk = strtolower($lv_key);
        // prg y act se pasan a minúscula, porque el switch del controlador distingue
        // mayúsculas y sus opciones están en minúscula.
        if ( $lv_lk=='prg' ) { $lv_prg = strtolower($lv_val); }
        else if ( $lv_lk=='act' ) { $lv_act = strtolower($lv_val); }
        else if ( !in_array($lv_lk, $lv_reserved, true) ) { $lv_prm[$lv_lk] = $lv_val; }
      }
    }
    return array( $lv_prg, $lv_act, $lv_prm );
  }

}


// Instancia y ejecuta GORSE TASK
$lo_gorse = new GorseTask();
$lo_gorse->run();
?>
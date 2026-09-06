<?php
final class grldattskController extends tmssController2 {

  // Mails de error. El remitente es fijo. El respaldo se usa sólo cuando el error no
  // tiene tskcod y no hay una tarea de la cual leer destinatarios.
  // Los destinatarios de cada tarea se guardan en tskatr bajo la clave 'errormail'.
  const MAIL_FROM     = 'noreply@temasis.ar';
  const MAIL_FALLBACK = 'fkorin@temasis.ar';

	function initialize(){
  	$this->CONTROLLER='grldattsk';$this->MODEL='grldattsk';$this->VIEW='grldattsk';$this->ID='tskcod';$this->OBJTYP='GRL_TSK';$this->enable_sysdoccls=false;
    $this->extraRet = array('objtyp'=>'GRL_TSK');
    $this->preventCopy=array('tskcod');
    // Security Java Web Token. gestiona tokens de seguridad
    $lo_secjwt = new tmssSecurityJWT();
    $this->co_reg->set('secjwt', $lo_secjwt);
  }

  // AFTER LOAD. recupera los últimos 10 logs de la tarea cargada para mostrar en la vista
  function afterLoad(){
    $lv_tskcod = $this->mdl->get('tskcod');
    if( $lv_tskcod=='' ){ return; }
    $lo_logmdl = $this->co_reg->load->model('sysapplog');
    $lv_prm = array(
      'vewfldflt' => '[~fltrow~]l.srcobjtyp'.chr(9).'='.chr(9).chr(9).'GRL_TSK'.chr(9).chr(9)
                   . '[~fltrow~]l.srcobjcod001'.chr(9).'='.chr(9).chr(9).$lv_tskcod.chr(9).chr(9),
      'vewfldord' => 'l.ctedte desc',
      'vewmaxrec' => 10
    );
    $this->mdl->log = $lo_logmdl->getList( $lv_prm, array('sys'=>0), null );
  }
  
  //  D A S H B O A R D
  function additionalFunctions($lp_act){
    switch( $lp_act ) {
      case "#dsh":
        $lo_ret =array();
        if(($this->post['typ']??'')!=''){
          $lv_prm = array('vewfldflt'=>	'');

          switch( $this->post['typ'] ){
            case 'active':	// ACTIVOS
              $lv_prm['vewfldflt'].='[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                  .'[~fltrow~]t.buscod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->buscod.chr(9).chr(9);
              $lv_prm['vewfldgrp']='t.buscod';
              $lv_prm['vewfldgrpcal']='count(*) as qty';
              break;
            case 'success':	// OK
              $lv_prm['vewfldflt'].='[~fltrow~]t.TskLstRunSts'.chr(9).'='.chr(9).chr(9).'S'.chr(9).chr(9)
                                  . '[~fltrow~]t.TskLstRunDte>=dateadd(day,-1,getdate())'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9);
              $lv_prm['vewfldgrp']='t.buscod';
              $lv_prm['vewfldgrpcal']='count(*) as qty';
              break;
            case 'errors':	// ERRORES
              $lv_prm['vewfldflt'].='[~fltrow~]t.TskLstRunSts'.chr(9).'<>'.chr(9).chr(9).'S'.chr(9).chr(9)
                                  . '[~fltrow~]t.TskLstRunDte>=dateadd(day,-1,getdate())'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9);
              $lv_prm['vewfldgrp']='t.buscod';
              $lv_prm['vewfldgrpcal']='count(*) as qty';
              break;
            /*case 'onetime':	// UNICA VEZ
              $lv_prm['vewfldflt'].='[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9);
              $lv_prm['vewfldgrp']='t.crmcnttyptxt';
              $lv_prm['vewfldgrpcal']='count(*) as qty';
              break;
            case 'priority':	// POR PRIORIDAD
              $lv_prm['vewfldflt'].='[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9);
              $lv_prm['vewfldgrp']='p.crmcntprttxt';
              $lv_prm['vewfldgrpcal']='count(*) as qty';
              break;
            case 'status':	// POR ESTADO
              $lv_prm['vewfldflt'].='[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9);
              $lv_prm['vewfldgrp']='s.crmcntststxt';
              $lv_prm['vewfldgrpcal']='count(*) as qty';
              break;
            case 'average_closed':	// TIEMPO MEDIO DE CIERRE
              $lv_prm['vewfldflt'].='[~fltrow~]s.crmcntstscls'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9)
                                  . '[~fltrow~]c.upddte>=dateadd(day,-30,getdate())'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9);
              $lv_prm['vewfldgrpcal']='avg( datediff( minute, c.ctedte, c.upddte ) ) as avgcls';
              break;*/
            case 'comments':	// COMENTARIOS
              $lv_prm['vewfldflt'].='[~fltrow~]c.upddte>=dateadd(day,-7,getdate())'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9);
              $lv_prm['vewfldord'] ='c.upddte desc';
              $lv_prm['vewmaxrec'] = 500;
              break;							
            case 'task_list':
              $lv_prm['vewfldflt'].='[~fltrow~]t.buscod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->buscod.chr(9).chr(9);
              $lv_prm['vewfldord'] ='t.ctedte desc';
              $lv_prm['vewmaxrec'] = 500;
              break;

          }
          $lo_rs = $this->mdl->getList($lv_prm, null, null, false);

          return $this->co_reg->document->getJson( $lo_rs );
        }
        
        return $this->co_reg->document->getView('grldattskdsh',array('data'=>$this->mdl,'actcod'=>$lp_act));
        break;


      // muestra dialogo de planificacion
      case "#sch":
        $lo_obj = new stdClass();
        $lo_obj->sysdoccls = '';
        $lo_obj->srcobjcod001 = '';
        $lo_obj->srcobjtyp = '';
        $lo_obj->tskcod=0;
        $lo_obj->tsktxt='';
        $lo_obj->cfg = json_decode(html_entity_decode(isset($this->post['cfg']) ? $this->post['cfg'] : array()), true);
        $lo_obj->prvdat = $this->post['tskfrqatr']??'';
        return $this->co_reg->document->getView( 'grldattsksch', array('data'=>$lo_obj, 'actcod'=>$this->post["actcod"] ));
				break;


      case "#getexecutionlist":
        // 1. Obtiene del SP las tareas pendientes (buscod, url, tskcod, tskatr).
        $lo_rs     = $this->mdl->getExecutionList();
        $lv_tsklst = json_decode( $lo_rs[0]['tsklst'] ?? '[]', true );
        if ( !is_array($lv_tsklst) ) { $lv_tsklst = array(); }

        // 2. Arma un token por tarea con todo su contenido cifrado. El tskcod además
        // viaja aparte para que Node pueda identificarla en logs, avisos y respuestas.
        $lv_tokens = array();
        foreach ( $lv_tsklst as $lv_tsk ) {
          // tskatr llega como texto JSON con pares clave-valor y se aplana a un objeto simple.
          $lv_atr = array();
          $lv_raw = json_decode( $lv_tsk['tskatr'] ?? '[]', true );
          if ( is_array($lv_raw) ) {
            foreach ( $lv_raw as $lv_pair ) {
              if ( is_array($lv_pair) ) { foreach ( $lv_pair as $lv_k=>$lv_v ) {
                // errormail son los destinatarios de los mails de error, no un parámetro de la tarea
                if ( strtolower($lv_k)=='errormail' ) { continue; }
                $lv_atr[ strtolower($lv_k) ] = $lv_v;
              } }
            }
          }

          $lv_payload = array(
            'buscod' => $lv_tsk['buscod'] ?? '',
            'tskcod' => $lv_tsk['tskcod'] ?? '',
            'url'    => $lv_tsk['url'] ?? '',
            'tskatr' => $lv_atr,
            'exp'    => date('Y-m-d H:i:s', time() + GorseTask::GORSE_EXPIRATION_TIME),
          );

          // generateJwt devuelve un array {errtyp, data}, no el token directo:
          // hay que sacar el token de ahí.
          $lv_gen = $this->co_reg->secjwt::generateJwt( $lv_payload, GorseTask::GORSE_TASK_KEY );
          $lv_token = is_array($lv_gen) ? ($lv_gen['data'] ?? $lv_gen['token'] ?? $lv_gen['jwt'] ?? '') : $lv_gen;
          
          $lv_tokens[] = array(
            'tskcod' => $lv_tsk['tskcod'] ?? '',
            'token'  => $lv_token,
          );
        }

        // 3. Devuelve a Node la lista de tokens.
        $lv_res = array( 'errtyp' => 'S', 'errmsg' => 'Tareas obtenidas correctamente', 'tsklst' => $lv_tokens, 'count' => count($lv_tokens) );

        return $this->co_reg->document->getJson( $lv_res );
				break;


      // #updatestatus: recibe una lista de tskcods y un docsts, y actualiza el estado
      // de todas esas tareas de una sola vez (Op 25). Lo llama node.php:
      //   - docsts 'R' al empezar a procesarlas.
      //   - docsts 'A' para volver a dejarlas disponibles si algo falla.
      case "#updatestatus":
        // 1. Toma los parámetros enviados por node.php.
        $lv_paylod = is_string($this->post) ? json_decode($this->post, true) : $this->post;
        $lv_tsklst = $lv_paylod['tsklst'] ?? [];
        $lv_docsts = $lv_paylod['docsts'] ?? '';

        // 2. VALIDACIONES
        if (!is_array($lv_tsklst) || empty($lv_tsklst)) {
          $lv_res = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'tsklst vacío o inválido');
          return $this->co_reg->document->getJson( $lv_res );
        }
        if (!in_array($lv_docsts, ['A','R'], true)) {
          $lv_res = array('errtyp'=>'E','errcod'=>-2,'errtxt'=>"docsts inválido (esperado 'A' o 'R')");
          return $this->co_reg->document->getJson( $lv_res );
        }

        // 3. Llama al modelo (Op 25), que actualiza todas las tareas de la lista de una vez.
        $lv_spdat = $this->mdl->updateTasksStatus(array( 'tsklst' => json_encode($lv_tsklst), 'docsts' => $lv_docsts ));

        // 4. Arma la respuesta según el resultado.
        if (($this->mdl->errtyp ?? 'S') === 'S' && intval($this->mdl->errcod ?? 0) === 0) {
          $lv_res = array( 'errtyp' => 'S', 'errcod' => 0, 'errtxt' => "Estado actualizado a '$lv_docsts' para ".count($lv_tsklst)." tarea(s)" );
        } else {
          $lv_res = array( 'errtyp' => 'E', 'errcod' => intval($this->mdl->errcod ?? -1), 'errtxt' => "Error actualizando estado a '$lv_docsts': ".($this->mdl->errtxt ?? '') );
        }

        return $this->co_reg->document->getJson( $lv_res );
        break;


    	// #getnextexecution: recibe el resultado de una tarea y calcula su próxima ejecución.
      case "#getnextexecution":
        // 1. Recibe el resultado de una tarea ya terminada, reportado por Node.js.
        $lv_paylod = is_string($this->post) ? json_decode($this->post, true) : $this->post;
        $lv_tskcod = $lv_paylod['tskcod'] ?? null;
        $lv_exeerrtyp = $lv_paylod['errtyp'] ?? null;                                  // resultado reportado por Node.js (S/E)
        $lv_exedat    = $lv_paylod['data'] ?? '';                                      // datos de la respuesta cuando salió bien
        $lv_exemsg    = $lv_paylod['message'] ?? '';                                   // mensaje cuando hubo error

        // resume lo que reportó Node.js sobre la ejecución
        $lv_exeinf = array(
          'errtyp' => $lv_exeerrtyp ?: 'E',
          'errcod' => ($lv_exeerrtyp === 'S' ? 0 : -1),
          'errtxt' => ($lv_exeerrtyp === 'S' ? "Tarea  ejecutada correctamente" : "Error ejecutando tarea : $lv_exemsg"),
          'data'   => $lv_exedat,
        );

        // resume el cálculo de la próxima ejecución y la liberación del estado ('R' -> 'A')
        $lv_nxtinf = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No procesado','data'=>0);
        if ($lv_tskcod) {
          try {
            // 2. Calcula la próxima fecha de ejecución (Op 17). El SP también libera la tarea
            // ('A') y deja registrado el resultado, por eso se le pasan los datos que reportó Node.js.
            $lv_spdat = $this->mdl->getNextExecution( array(
              "tskcod"       => $lv_tskcod,
              "tskexeerrtyp" => $lv_exeinf['errtyp'],
              "tskexeerrcod" => $lv_exeinf['errcod'],
              "tskexeerrmsg" => $lv_exeinf['errtxt'],
              // data que devolvió la tarea, guardado como texto.
              "tskexeres"    => is_string($lv_exeinf['data']) ? $lv_exeinf['data'] : ( ($lv_exeinf['data'] === null || $lv_exeinf['data'] === false) ? '' : json_encode($lv_exeinf['data'], JSON_UNESCAPED_UNICODE) ),
            ) );
            if (($this->mdl->errtyp ?? 'S') === 'S' && intval($this->mdl->errcod ?? 0) === 0) {
              $lv_nxtinf = array('errtyp'=>'S','errcod'=>0,'errtxt'=>"Próxima ejecución calculada y tarea $lv_tskcod liberada a estado 'A'",'data'=>$lv_spdat);
            } else {
              $lv_nxtinf = array('errtyp'=>($this->mdl->errtyp ?: 'E'),'errcod'=>intval($this->mdl->errcod ?? -1),'errtxt'=>"Error calculando próxima ejecución para tarea $lv_tskcod: ".($this->mdl->errtxt ?? ''),'data'=>$lv_spdat);
            }
          } catch (Exception $e) {
            $lv_nxtinf = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>"Error calculando próxima ejecución para tarea $lv_tskcod: ".$e->getMessage(),'data'=>0);
          }
        } else {
          $lv_nxtinf = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se recibió tskcod para el callback','data'=>0);
        }

        // resultado global: éxito sólo si la ejecución y el cálculo posterior salieron bien
        $lv_okexe = ($lv_exeinf['errtyp'] === 'S');
        $lv_oknxt = ($lv_nxtinf['errtyp'] === 'S');
        $lv_res = array(
          'errtyp' => ($lv_okexe && $lv_oknxt) ? 'S' : 'E',
          'errcod' => ($lv_okexe && $lv_oknxt) ? 0 : -1,
          'errtxt' => "Tarea $lv_tskcod - ejecución: ".$lv_exeinf['errtxt']." | próxima ejecución: ".$lv_nxtinf['errtxt'],
          'tskcod' => $lv_tskcod,
          'execution'     => $lv_exeinf,
          'nextexecution' => $lv_nxtinf,
        );

        // Si la tarea falló, se envía un mail para dejar registrado el error.
        if ( $lv_res['errtyp'] === 'E' ) {
          $this->sendErrorMail( "#getnextexecution (tarea $lv_tskcod)", $lv_res );
        }

        // El registro de cada tarea (resultado + cambio de estado) lo deja el SP en Op 17.
        return $this->co_reg->document->getJson( $lv_res );
        break;
    
      // #senderrormail: recibe la información de un error desde node.php o grldattsk.js
      // y envía el mail de aviso.
      case "#senderrormail":
        $lo_post = is_string($this->post) ? json_decode($this->post, true) : $this->post;
        $lv_tskctx = $lo_post['tskctx'] ?? 'Origen no especificado';
        $lv_tskdtl = $lo_post['tskdtl'] ?? $lo_post;

        $lv_res = $this->sendErrorMail( $lv_tskctx, $lv_tskdtl );

        return $this->co_reg->document->getJson( $lv_res );
        break;

      // #sendmailtest: tarea de prueba. Manda un mail fijo para verificar que el ciclo de ejecución llega hasta el final.
      case "#sendmailtest":
        $lo_eml = new tmssMail();
        $lv_emlprm = array(
          'to'       => array( array('address' => 'fkorin@temasis.ar') ),
          'from'     => array( array('address' => 'fkorin@temasis.ar', 'name' => 'Tareas Programadas') ),
          'subject'  => 'Test - Tareas Programadas',
          'bodyhtml' => '<p>Hola. Esto es una prueba de ejecución de una tarea programada.</p>'
        );

        if ( !$lo_eml->send( $lv_emlprm ) ) {
          return $this->co_reg->document->getJson( array( 'errtyp' => 'E', 'errcod' => -1, 'errtxt' => 'No se pudo enviar el mail de prueba: ' . $lo_eml->getError() ) );
        }

        return $this->co_reg->document->getJson( array( 'errtyp' => 'S', 'errcod' => 0, 'errtxt' => 'Mail de prueba enviado a fkorin@temasis.ar', 'data' => 'Mail de prueba enviado a fkorin@temasis.ar' ) );
        break;

      case "#executetask":
        // Ejecución manual de una tarea. Reproduce el ciclo del scheduler ('R' -> ejecuta -> 'A').
        // Reglas según el estado actual:
        //   - 'R': aborta, porque el scheduler ya la está ejecutando.
        //   - 'A': hace el ciclo completo.
        //   - cualquier otro (p.ej. 'I'): la ejecuta pero no cambia su estado.
        $lv_tskcod     = $this->post["tskcod"] ?? null;
        $lv_controller = $this->post["prg"] ?? '';
        $lv_action     = $this->post["act"] ?? '';
        $lv_prm        = $this->post["prm"] ? json_decode(html_entity_decode($this->post["prm"], ENT_QUOTES, 'UTF-8'), true) : '';

        // A las claves con prefijo 'prm_' se les quita el prefijo, para que el controlador
        // reciba los parámetros con el mismo nombre que en la ejecución programada.
        // Las demás claves quedan igual.
        if ( is_array($lv_prm) ) {
          $lv_prmnrm = array();
          foreach ( $lv_prm as $lv_key => $lv_val ) {
            if ( substr( strtolower($lv_key), 0, 4)=='prm_' ) {
              $lv_prmnrm[ substr(strtolower($lv_key),4,strlen($lv_key)-4) ] = $lv_val;
            } else {
              $lv_prmnrm[ $lv_key ] = $lv_val;
            }
          }
          $lv_prm = $lv_prmnrm;
        }

        // 1. Lee el estado actual (docsts) para validar y decidir si aplica el ciclo.
        $lv_origsts = null;
        if ($lv_tskcod) {
          $this->mdl->load( array('tskcod' => $lv_tskcod), false );
          $lv_origsts = $this->mdl->get('docsts');

          if ($lv_origsts === 'R') {
            return $this->co_reg->document->getJson( array( 'errtyp' => 'E', 'errcod' => -10, 'errtxt' => "La tarea $lv_tskcod ya está siendo ejecutada por el scheduler." ) );
          }
        }

        // 2. Marca 'R' sólo si la tarea está activa.
        $lv_uselifecycle = ($lv_origsts === 'A');
        if ($lv_uselifecycle) {
          $this->mdl->updateTasksStatus( array('tsklst' => json_encode([$lv_tskcod]), 'docsts' => 'R') );
        }

        // 3. Ejecuta la tarea. El try/catch asegura que el estado se libere y el log se escriba siempre.
        $lo_data = null; $lv_exeerrtyp = 'S'; $lv_exeerrcod = 0; $lv_exeerrmsg = '';
        try {
          if ( $lv_controller!='' && $lv_action!='' ) {
            $lo_ctr  = $this->co_reg->load->controller( $lv_controller );
            $lo_data = $lo_ctr->index( $lv_action , $lv_prm );
          } else {
            $lv_exeerrtyp = 'E'; $lv_exeerrcod = -3; $lv_exeerrmsg = "URL sin prg o act.";
          }
        } catch (Throwable $e) {
          $lv_exeerrtyp = 'E'; $lv_exeerrcod = -1; $lv_exeerrmsg = $e->getMessage();
        }

        // 3b. Revisa el resultado. Que no haya excepción no significa éxito: el controlador
        // puede no devolver nada o devolver un errtyp 'E'.
        if ($lv_exeerrtyp === 'S') {
          if ($lo_data === null || $lo_data === '' || $lo_data === false) {
            $lv_exeerrtyp = 'E'; $lv_exeerrcod = -2;
            $lv_exeerrmsg = "La acción $lv_controller#$lv_action no devolvió respuesta.";
          } else {
            $lv_chk = is_string($lo_data) ? json_decode($lo_data, true) : $lo_data;
            if (is_array($lv_chk) && isset($lv_chk['errtyp']) && $lv_chk['errtyp'] !== 'S') {
              $lv_exeerrtyp = $lv_chk['errtyp'];
              $lv_exeerrcod = intval($lv_chk['errcod'] ?? -1);
              $lv_exeerrmsg = $lv_chk['errtxt'] ?? ($lv_chk['errmsg'] ?? 'Error reportado por el controlador.');
            }
          }
        }

        // 4. Libera el estado a 'A' sólo si había entrado al ciclo.
        if ($lv_uselifecycle) {
          $this->mdl->updateTasksStatus( array('tsklst' => json_encode([$lv_tskcod]), 'docsts' => 'A') );
        }

        // 5. Arma el mensaje final indicando si hubo cambio de estado.
        if ($lv_exeerrtyp === 'S') {
          $lv_exeerrmsg = "Ejecución manual. Tarea ejecutada correctamente." . ($lv_uselifecycle ? " Estado actualizado a 'A'." : '');
        } else {
          $lv_exeerrmsg = "Ejecución manual. Error ejecutando tarea: $lv_exeerrmsg" . ($lv_uselifecycle ? " Estado restaurado a 'A'." : '');
        }

        // 6. Registra el log, con el mismo formato que el scheduler.
        if ($lv_tskcod) {
          $lo_logmdl = $this->co_reg->load->model('sysapplog');
          // rawres se guarda siempre como texto, tal cual lo devolvió la tarea.
          $lv_rawres = is_string($lo_data) ? $lo_data : ( ($lo_data === null || $lo_data === false) ? '' : json_encode($lo_data, JSON_UNESCAPED_UNICODE) );
          $lv_logdat = array(
            'srcobjtyp'    => 'GRL_TSK',
            'srcobjcod001' => $lv_tskcod,
            'applogtecinf' => json_encode( array('errtyp'=>$lv_exeerrtyp,'errcod'=>$lv_exeerrcod,'errmsg'=>$lv_exeerrmsg,'rawres'=>$lv_rawres), JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE ),
            'mdlcod'       => $lv_controller,
            'prgcod'       => $lv_action,
            'sys'          => 0,
            'docsts'       => 'A',
          );
          $lo_logmdl->save( $lv_logdat );
        }

        return $this->co_reg->document->getJson( array( 'errtyp' => $lv_exeerrtyp, 'errcod' => $lv_exeerrcod, 'errtxt' => $lv_exeerrmsg, 'data'   => $lo_data, ) );
      	break;


      /*
      Muestra el texto correspondiente a una frecuencia configurada
      Recibe la frecuencia en tags
      */
      case "#getfrqtxt":
        /* tipo (typ): O/D/W/M/Y
           cantidad (qty): [nro natural]
           dia de semana (wekday) DLMMJVS: 0000000 (se indica con un 1 el o los dias de semana)
           nro de dia (daynum): [nro que corrresponde al dia en la fecha]
           nro de semana (weknum): [nro que indica el orden de la semana (primera, segunda, etc.)]
           mes (mth): [nro del mes]
        */

        // recupero datos
        $lv_frq = html_entity_decode($this->post['frq']);
        $lv_typ = $this->co_reg->document->getTagValue( $lv_frq, 'frqtyp');
        $lv_typ = ($lv_typ==''?'U':$lv_typ); 
        $lv_qty = $this->co_reg->document->getTagValue( $lv_frq, 'frqqty');
        $lv_wekday = $this->co_reg->document->getTagValue( $lv_frq, 'wekday');
        $lv_daynum = $this->co_reg->document->getTagValue( $lv_frq, 'daynum');
        $lv_weknum = $this->co_reg->document->getTagValue( $lv_frq, 'weknum');
        $lv_mth = $this->co_reg->document->getTagValue( $lv_frq, 'mth');

        // definir esqueleto del texto y textos de variables
        $lv_frqtxt = '(El )[DAYNUM][WEKNUM]( )[WEKDAY]( de )[MTH]( de )(Cada) [QTY] [TYP]';
        $lv_wekday_arr = array('sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday');
        $lv_weknum_arr = array('firstV2', 'second', 'thirdV2', 'fourth', 'last');
        $lv_typ_arr = array('U'=> 'onetime', 'D'=> 'day', 'W'=> 'week','M'=> 'month', 'Y'=> 'year');

        // días de semana
        $lv_str = 0;
        $lv_wekdaytxt = '';
        while(strpos($lv_wekday, '1', $lv_str)!==false){
          $lv_str = strpos($lv_wekday, '1', $lv_str);
          $lv_wekdaytxt .= ($lv_wekdaytxt != '' ? ', ' : '').$this->co_reg->language->{$lv_wekday_arr[$lv_str]};
          $lv_str++;
        }
        if(strpos($lv_wekday, 'L', $lv_str)!==false){
          $lv_wekdaytxt .= $this->co_reg->language->day;
        }

        // corrige nro de semana
        $lv_weknum = $lv_weknum == 'L' ? 5 : $lv_weknum;

        // asigna los valores de las variables
        $lv_frqvar = array();
        $lv_frqvar['DAYNUM'] = $lv_daynum;
        $lv_frqvar['WEKNUM'] = $lv_weknum!='' ? $this->co_reg->language->{$lv_weknum_arr[$lv_weknum-1]} : '';
        $lv_frqvar['WEKDAY'] = $lv_wekdaytxt;
        $lv_frqvar['MTH'] = $lv_mth!='' ? $this->co_reg->language->{date('F', mktime(0,0,0,$lv_mth,1))} : '';
        $lv_frqvar['QTY'] = $lv_qty>1 ? $lv_qty : '';  
        $lv_frqvar['TYP'] = $this->co_reg->language->{$lv_typ_arr[$lv_typ].($lv_qty > 1 ? 'S' : '')};  

        // reemplazo variables
        foreach($lv_frqvar as $lv_key=>$lv_var){
          $lv_frqtxt = str_replace('['.$lv_key.']', $lv_var, $lv_frqtxt);
        }

        // pongo o quito los textos opcionales
        // array de condiciones: cuando se cumplen, se quitan los paréntesis de lo opcional
        $lv_frqopt = array($lv_frqvar['DAYNUM']!='',
                          $lv_frqvar['WEKNUM'] != '',
                          $lv_frqvar['MTH'] != '',
                          $lv_frqvar['DAYNUM']!='' || $lv_frqvar['WEKNUM'] != '' || $lv_frqvar['WEKDAY'] != '',
                          $lv_typ != 'U');
        foreach($lv_frqopt as $lv_row){
          if($lv_row){
            $lv_frqtxt = substr_replace($lv_frqtxt, '', strpos($lv_frqtxt, '('), 1);
            $lv_frqtxt = substr_replace($lv_frqtxt, '', strpos($lv_frqtxt, ')'), 1);
          }else{
            $lv_frqtxt = substr_replace($lv_frqtxt, '', strpos($lv_frqtxt, '('), strpos($lv_frqtxt, ')') - strpos($lv_frqtxt, '(') +1 );
          }
        }

        return $this->co_reg->document->getJson( array('frqtxt' => html_entity_decode(trim($lv_frqtxt))) );
      	break;
    }
  }
  
  /* tipo (typ): O/D/W/M/Y
			 cantidad (qty): [nro natural]
			 dia de semana (wekday) DLMMJVS: 0000000 (se indica con un 1 el o los dias de semana)
			 nro de dia (daynum): [nro que corrresponde al dia en la fecha]
			 nro de semana (weknum): [nro que indica el orden de la semana (primera, segunda, etc.)]
			 mes (mth): [nro del mes]
		*/
  function gettxt($lo_post){
		$lv_frq = html_entity_decode($lo_post['frq']);
		$lv_typ = $this->co_reg->document->getTagValue( $lv_frq, 'frqtyp');
		$lv_typ = ($lv_typ==''?'U':$lv_typ); 
		$lv_qty = $this->co_reg->document->getTagValue( $lv_frq, 'frqqty');
		$lv_wekday = $this->co_reg->document->getTagValue( $lv_frq, 'wekday');
		$lv_daynum = $this->co_reg->document->getTagValue( $lv_frq, 'daynum');
		$lv_weknum = $this->co_reg->document->getTagValue( $lv_frq, 'weknum');
		$lv_mth = $this->co_reg->document->getTagValue( $lv_frq, 'mth');
		
		// definir esqueleto del texto y textos de variables
		$lv_frqtxt = '(El )[DAYNUM][WEKNUM]( )[WEKDAY]( de )[MTH]( de )(Cada) [QTY] [TYP]';
		$lv_wekday_arr = array('DOM', 'LUN', 'MAR', 'MIE', 'JUE', 'VIE', 'SAB');
		$lv_weknum_arr = array('firstV2', 'second', 'thirdV2', 'fourth', 'last');
		$lv_typ_arr = array('U'=> 'onetime', 'D'=> 'day', 'W'=> 'week','M'=> 'month', 'Y'=> 'year');

		// días de semana
		$lv_str = 0;
		$lv_wekdaytxt = '';
		while(strpos($lv_wekday, '1', $lv_str)!==false){
			$lv_str = strpos($lv_wekday, '1', $lv_str);
			$lv_wekdaytxt .= ($lv_wekdaytxt != '' ? ', ' : '').$lv_wekday_arr[$lv_str];
			$lv_str++;
		}
		if(strpos($lv_wekday, 'L', $lv_str)!==false){
			$lv_wekdaytxt .= $this->co_reg->language->day;
		}
		
		// corrige nro de semana
		$lv_weknum = $lv_weknum == 'L' ? 5 : $lv_weknum;
	 
		// asigna los valores de las variables
		$lv_frqvar = array();
		$lv_frqvar['DAYNUM'] = $lv_daynum;
		$lv_frqvar['WEKNUM'] = $lv_weknum!='' ? $this->co_reg->language->{$lv_weknum_arr[$lv_weknum-1]} : '';
		$lv_frqvar['WEKDAY'] = $lv_wekdaytxt;
		$lv_frqvar['MTH'] = $lv_mth!='' ? $this->co_reg->language->{date('F', mktime(0,0,0,$lv_mth,1))} : '';
		$lv_frqvar['QTY'] = $lv_qty>1 ? $lv_qty : '';  
		$lv_frqvar['TYP'] = $this->co_reg->language->{$lv_typ_arr[$lv_typ].($lv_qty > 1 ? 'S' : '')};  
		
		// reemplazo variables
		foreach($lv_frqvar as $lv_key=>$lv_var){
			$lv_frqtxt = str_replace('['.$lv_key.']', $lv_var, $lv_frqtxt);
		}
		
		// pongo o quito los textos opcionales
		// array de condiciones: cuando se cumplen, se quitan los paréntesis de lo opcional
		$lv_frqopt = array($lv_frqvar['DAYNUM']!='',
											$lv_frqvar['WEKNUM'] != '',
											$lv_frqvar['MTH'] != '',
											$lv_frqvar['DAYNUM']!='' || $lv_frqvar['WEKNUM'] != '' || $lv_frqvar['WEKDAY'] != '',
											$lv_typ != 'U');
		foreach($lv_frqopt as $lv_row){
			if($lv_row){
				$lv_frqtxt = substr_replace($lv_frqtxt, '', strpos($lv_frqtxt, '('), 1);
				$lv_frqtxt = substr_replace($lv_frqtxt, '', strpos($lv_frqtxt, ')'), 1);
			}else{
				$lv_frqtxt = substr_replace($lv_frqtxt, '', strpos($lv_frqtxt, '('), strpos($lv_frqtxt, ')') - strpos($lv_frqtxt, '(') +1 );
			}
		}
		return (trim($lv_frqtxt));

		// return $this->co_reg->document->getJson( array('frqtxt' => html_entity_decode(trim($lv_frqtxt))) );
  }
  
		//agrega fecha y hora de inicio al cfg si no estan definidos 
	function loaddte(){
		if(!isset($lo_post['cfg']) || !isset($this->lo_mdl->cfg['strdte']) ){
			$lv_cfg=$this->lo_mdl->cfg;
			$lv_cfg['strdte']=date_format($this->lo_mdl->tskstrdte,'d/m/Y');
			$lv_cfg['strtme']=date_format($this->lo_mdl->tskstrdte,'H:i');
			$this->lo_mdl->cfg = $lv_cfg;  
		}
		if((!isset($lo_post['cfg']) || !isset($this->lo_mdl->cfg['enddte']) )&& $this->lo_mdl->tskenddte!='' && $this->lo_mdl->tskenddte!=null){
			$this->lo_mdl->cfg;
			$lv_cfg['enddte']=date_format($this->lo_mdl->tskenddte,'d/m/Y');
			$lv_cfg['endtme']=date_format($this->lo_mdl->tskenddte,'H:i');
			$this->lo_mdl->cfg = $lv_cfg;  
		}
  }

  // Arma y envía un mail de aviso con la información de un error.
  // Se usa internamente y también a través de la operación #senderrormail.
  // Nunca lanza excepción, para no tapar el error original.
  private function sendErrorMail( $lp_context, $lp_detail = array() ) {
    try {
      // Si el detalle viene como texto, se decodifica antes de interpretarlo como datos.
      if (is_string($lp_detail)) {
        $lv_decoded = html_entity_decode($lp_detail, ENT_QUOTES, 'UTF-8');
        $lv_detarr  = json_decode($lv_decoded, true);
        $lv_dettxt  = is_array($lv_detarr)
          ? json_encode($lv_detarr, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE)
          : $lv_decoded;
      } else {
        $lv_detarr = is_array($lp_detail) ? $lp_detail : array();
        $lv_dettxt = json_encode($lp_detail, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
      }

      $lv_tskcod = is_array($lv_detarr) ? ($lv_detarr['tskcod'] ?? '') : '';

      // Carga la tarea para obtener su descripción y sus destinatarios (tskatr->'errormail').
      // Sin destinatarios no se envía nada. Si no hay tskcod, se usa la casilla de respaldo.
      $lv_tsktxt = '';
      if ( $lv_tskcod !== '' && $lv_tskcod !== null ) {
        $lv_tskinf = $this->getTaskInfo( $lv_tskcod );
        $lv_tsktxt = $lv_tskinf['tsktxt'];
        $lv_emls   = $lv_tskinf['emls'];
      } else {
        $lv_emls = array( self::MAIL_FALLBACK );
      }

      if ( empty($lv_emls) ) {
        return array('errtyp' => 'S', 'errcod' => 0, 'errtxt' => 'Tarea sin destinatarios de error configurados; no se envía mail');
      }

      // Reemplaza las referencias "tarea <tskcod>" por la descripción de la tarea,
      // porque el tskcod no le dice nada al usuario.
      if ( $lv_tsktxt !== '' && $lv_tskcod !== '' && $lv_tskcod !== null ) {
        $lv_find = array( "(tarea $lv_tskcod)", "Tarea $lv_tskcod", "tarea $lv_tskcod" );
        $lv_repl = array( "($lv_tsktxt)",       "Tarea $lv_tsktxt", $lv_tsktxt );
        $lp_context = str_replace( $lv_find, $lv_repl, $lp_context );
        $lv_dettxt  = str_replace( $lv_find, $lv_repl, $lv_dettxt );
      }

      $lv_body  = '<p>Se detectó un error en el sistema de Tareas Programadas.</p>';
      $lv_body .= '<p><b>Origen:</b> ' . htmlspecialchars($lp_context) . '<br>';
      $lv_body .= '<b>Fecha:</b> ' . date('Y-m-d H:i:s');
      if ( $lv_tsktxt !== '' ) { $lv_body .= '<br><b>Tarea:</b> ' . htmlspecialchars($lv_tsktxt); }
      $lv_body .= '</p><p><b>Detalle:</b></p><pre>' . htmlspecialchars($lv_dettxt) . '</pre>';

      $lo_eml = new tmssMail();
      $lv_emlprm = array(
        'to'       => array_map( function($lv_e){ return array('address' => $lv_e); }, $lv_emls ),
        'from'     => array( array('address' => self::MAIL_FROM, 'name' => 'Tareas Programadas') ),
        'subject'  => 'Error en Tareas Programadas - ' . $lp_context,
        'bodyhtml' => $lv_body
      );

      if ( !$lo_eml->send( $lv_emlprm ) ) {
        return array('errtyp' => 'E', 'errcod' => -1, 'errtxt' => 'No se pudo enviar el mail: ' . $lo_eml->getError());
      }
      
    } catch (Throwable $e) {
      // un fallo al enviar el mail no debe propagarse: sólo se registra y se continúa.
      error_log('grldattsk::sendErrorMail falló: ' . $e->getMessage());
      return array('errtyp' => 'E', 'errcod' => -1, 'errtxt' => 'Excepción enviando mail: ' . $e->getMessage());
    }
  }

  // Carga la tarea una vez y devuelve:
  //   - tsktxt: descripción de la tarea, que se muestra en el mail en lugar del tskcod.
  //   - emls:   destinatarios tomados de tskatr->'errormail'. Vacío si no tiene ninguno.
  private function getTaskInfo( $lp_tskcod ) {
    $lv_ret = array('tsktxt' => '', 'emls' => array());
    try {
      $lo_mdl = $this->co_reg->load->model('grldattsk');
      $lo_mdl->load( array('tskcod' => $lp_tskcod), false );

      $lv_ret['tsktxt'] = trim((string)$lo_mdl->get('tsktxt'));

      // destinatarios desde tskatr -> 'errormail'
      $lv_raw = json_decode( $lo_mdl->get('tskatr') ?? '[]', true );
      $lv_str = '';
      if ( is_array($lv_raw) ) {
        foreach ( $lv_raw as $lv_pair ) {
          if ( is_array($lv_pair) ) { foreach ( $lv_pair as $lv_k=>$lv_v ) {
            if ( strtolower($lv_k)=='errormail' ) { $lv_str = (string)$lv_v; }
          } }
        }
      }
      foreach ( preg_split('/[;,\r\n]+/', $lv_str) as $lv_e ) {
        $lv_e = trim($lv_e);
        if ( $lv_e!=='' && filter_var($lv_e, FILTER_VALIDATE_EMAIL) ) { $lv_ret['emls'][] = $lv_e; }
      }
    } catch (Throwable $e) {
      error_log('grldattsk::getTaskInfo falló: ' . $e->getMessage());
    }
    return $lv_ret;
  }

}
  
?>
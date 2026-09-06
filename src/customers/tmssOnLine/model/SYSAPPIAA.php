<?php
final class sysappiaa extends tmssAction2 {
  const OBJTYP = 'SYS_IAA';
  function initialize(){ $this->ID = 'sysappiaacod'; }
  
  function getActivationsList( $lp_vewopt=array(), $lp_prm=array() ) {
    $lo_vew = $this->co_reg->load->model('grlvew');
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '28', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
			$this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    
		return $this->data;
	}
  
  // ejecuta el llamado a la IA. formatea los parametros en funcion de cada modelo y devuelve un resultado JSON
  // recibe: lp_key. clave registrada en la IA
  //         lp_prompt. texto que corresponde al prompt que el usuario quiere enviar
  //         lp_param. json con los parametros que se quieren agregar como parametros POST del llamado
  //				 lp_syspmt. texto que corresponde al prompt default del sistema
  public function execute( $lp_iaamdl, $lp_prompt, $lp_history='[]', $lp_prm='', $lp_syspmt='' ){
    set_time_limit(180);
    
    $lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'','data'=>'');
    
		// parámetros de memoria
    $lv_maxtrn = 1;              // 5 queries anteriores
    $lv_maxhst = $lv_maxtrn * 2;
    $lv_sumtrg = $lv_maxhst + 2;

		// decodifico historial
    $lp_history = json_decode(html_entity_decode($lp_history ?? '{}', ENT_QUOTES | ENT_HTML5, 'UTF-8'),true);

    if(!is_array($lp_history)){ $lp_history = []; }

    // limito historial
    $lp_history = array_slice($lp_history,-$lv_maxhst);
    
    // cargo modelo
    $lo_sysiaamdl = $this->co_reg->load->model('sysappiaamdl');
    if(!$lo_sysiaamdl->load([ 'sysappiaamdlcod'=>$lp_iaamdl->sysappiaamdlcod ])){ return $this->co_reg->document->getJson([ 'errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'No se pudo cargar modelo IA' ]); }
    
    // reemplazo variables
		$lo_curl = curl_init( trim(str_ireplace('@@KEY',$lp_iaamdl->sysappiaakey,$lo_sysiaamdl->sysappiaamdlurl) ) );
    $lv_tpl = json_decode( html_entity_decode($lo_sysiaamdl->sysappiaamdlatr ?? '{}', ENT_QUOTES | ENT_HTML5, 'UTF-8'), true );
    if (json_last_error() !== JSON_ERROR_NONE) { return [ 'errtyp'=>'E', 'errcod'=>-10, 'errtxt'=>'Invalid model template JSON', 'data'=>$lv_tpl ]; }
    
    // fuerzo siempre que el idioma default sea el español
  	$lv_lanset = 'Todas las respuestas deben estar completamente en español. Está prohibido responder en inglés, a menos que el usuario lo pida explícitamente. Esta regla tiene prioridad sobre cualquier otra instrucción de estilo.';

    // creo función recursiva de reemplazo de Placeholders
    function replacePlaceholders(&$lp_tpl, $lp_reparr) {
      if (is_array($lp_tpl)) {
        foreach ($lp_tpl as $key => &$value) { replacePlaceholders($value, $lp_reparr); }
    	} 
    	elseif (is_string($lp_tpl)) {
        foreach ($lp_reparr as $search => $replace) {
          if (stripos($lp_tpl, $search) !== false) { $lp_tpl = str_ireplace($search, $replace, $lp_tpl); }
        }
      }
    }
    
    // array con variables a reemplazar
    $lv_reparr = [ '@@KEY' => $lp_iaamdl->sysappiaakey ?? '', '@@MODEL' => strtolower($lo_sysiaamdl->sysappiaamdlver ?? ''), '@@SYSTEMPROMPT' => $lp_syspmt ];
		// reemplazo Placeholders
		replacePlaceholders($lv_tpl, $lv_reparr);
    
    // ajuste de system prompt para forzar la respuesta en español
    $lv_hassyspmt = false;
    if (isset($lv_tpl['pst']['messages']) && is_array($lv_tpl['pst']['messages'])) {
      foreach ($lv_tpl['pst']['messages'] as &$lv_msg) {
        if ( isset($lv_msg['role']) && strtolower($lv_msg['role']) === 'system') {
          // si ya hay system, le agrego la regla de idioma al inicio
          if (stripos($lv_msg['content'], $lv_lanset) === false) {
    				$lv_msg['content'] = $lv_lanset . "\n\n" . ($lv_msg['content'] ?? '');
					}          
          $lv_hassyspmt = true;
          break;
        }
      }
      // si NO había system, lo creo al inicio
      if (!$lv_hassyspmt) { array_unshift($lv_tpl['pst']['messages'], [ 'role' => 'system', 'content' => $lv_lanset ]); }
    }
    
    // agrego dinámicamente los prompts de usuario
    $lp_prompt = json_decode( html_entity_decode($lp_prompt ?? '{}', ENT_QUOTES | ENT_HTML5, 'UTF-8'), true );
		// aseguro que $lp_prompt sea siempre array
    if (!is_array($lp_prompt)) { $lp_prompt = [$lp_prompt]; }

    // aseguro estructura messages
    if (!isset($lv_tpl['pst']['messages']) || !is_array($lv_tpl['pst']['messages'])) { $lv_tpl['pst']['messages'] = []; }
    
    // agrego JSON de configuración}
    if($lp_prm != ''){
      $lv_tpl['pst']['messages'][] = [ 'role' => 'system', 'content' => "Editor configuration:\n".$lp_prm ];
    }
		
    // creo resumen dinámico del historial de la conversación
    function generateChatSummary($lp_iaamdl, $lp_history){
      if(!is_array($lp_history) || count($lp_history)==0){ return ''; }

      // armo texto de conversación
      $lv_cnv = "";
      foreach($lp_history as $lv_msg){
        if(!isset($lv_msg['role']) || !isset($lv_msg['content'])){ continue; }
        $lv_cnv .= strtoupper($lv_msg['role']).": ".$lv_msg['content']."\n";
      }

      // prompt de resumen
      $lv_prompt = [ [ "role"=>"system", "content"=>"Resume brevemente la conversación entre usuario y asistente. El resumen debe ser claro y corto, máximo 5 líneas." ], [ "role"=>"user", "content"=>$lv_cnv]];

      // payload simple para resumen
      $lv_payload = [ "model" => strtolower($lp_iaamdl->sysappiaamdlver ?? ''), "messages" => $lv_prompt, "temperature" => 0.2 ];
      $lo_curl = curl_init("https://api.openai.com/v1/chat/completions");
      curl_setopt_array($lo_curl,[ CURLOPT_POST=>true, CURLOPT_RETURNTRANSFER=>true, CURLOPT_HTTPHEADER=>[ 'Content-Type: application/json', 'Authorization: Bearer '.$lp_iaamdl->sysappiaakey ], CURLOPT_POSTFIELDS=>json_encode($lv_payload), CURLOPT_TIMEOUT=>30 ]);
      
      $lv_res = curl_exec($lo_curl);
      if(curl_errno($lo_curl)){ curl_close($lo_curl); return ''; }
      curl_close($lo_curl);

      $lv_resarr = json_decode($lv_res,true);

      if(!isset($lv_resarr['choices'][0]['message']['content'])){ return ''; }
      return trim($lv_resarr['choices'][0]['message']['content']);
    }
		
    // si hay más historial que el permitido, hago un resumen de lo anterior
    if(count($lp_history) > $lv_sumtrg){
      $lv_sum = $this->generateChatSummary($lp_iaamdl,$lp_history);
      if($lv_sum!=''){ $lv_tpl['pst']['messages'][] = [ 'role'=>'system', 'content'=>"Resumen de conversación previa:\n".$lv_sum ]; }
    }

  	// agrego el historial a la estructura de mensajes
    foreach($lp_history as $lv_msg){
      if(!isset($lv_msg['role']) || !isset($lv_msg['content'])){ continue; }
      $lv_tpl['pst']['messages'][]=[ 'role'=>$lv_msg['role'], 'content'=>mb_substr($lv_msg['content'],0,2000) ];
    }
    
    // agrego prompts del usuario dinámicamente
    foreach ($lp_prompt as $lv_pmt) {
      if ($lv_pmt !== '' && $lv_pmt !== null) {
        $lv_tpl['pst']['messages'][] = [ 'role' => 'user', 'content' => $lv_pmt ];
      }
    }
    
    // elimino nodos vacíos
    function removeEmptyNodes(&$lp_tpl) {
      if (is_array($lp_tpl)) {
        foreach ($lp_tpl as $key => &$value) {
          removeEmptyNodes($value);
          // Eliminar si: string vacío - null - array vacío
          if ( $value === '' || $value === null || (is_array($value) && empty($value)) ) { unset($lp_tpl[$key]); }
        }
        // reindexar arrays numéricos (ej: messages)
        if (array_keys($lp_tpl) === range(0, count($lp_tpl) - 1)) { $lp_tpl = array_values($lp_tpl); }
      }
    }
		// limpio el array
		removeEmptyNodes($lv_tpl);
		
		// H E A D E R S
    $lv_hdr = [];
    if(isset($lv_tpl['hdr']) && $lv_tpl['hdr']!=''){
      // separa por coma
      $lv_hdr = array_map('trim', explode(',', $lv_tpl['hdr']));
    }else{
      // fallback por defecto
      $lv_hdr = [ 'Content-Type: application/json', 'Authorization: Bearer '.$lp_iaamdl->sysappiaakey ];
    }

		// B O D Y
    if(isset($lv_tpl['pst']) && is_array($lv_tpl['pst'])){
      $lv_pstarr = $lv_tpl['pst'];
    }else{
      return [ 'errtyp'=>'E', 'errcod'=>-11, 'errtxt'=>'Template missing pst block', 'data'=>$lv_tpl ];
    }

		// parámetros Adicionales
    if($lp_prm!=''){
      $lv_prmarr = json_decode($lp_prm,true);
      if(json_last_error()===JSON_ERROR_NONE && is_array($lv_prmarr)){
        $lv_pstarr = array_merge($lv_pstarr, $lv_prmarr);
      }
    }
    
    // preparo llamada
    curl_setopt_array($lo_curl, [ CURLOPT_POST => true, CURLOPT_RETURNTRANSFER => true, CURLOPT_HTTPHEADER => $lv_hdr, CURLOPT_POSTFIELDS => json_encode($lv_pstarr), CURLOPT_TIMEOUT => 180, CURLOPT_CONNECTTIMEOUT => 40 ]);
		curl_setopt($lo_curl, CURLOPT_VERBOSE, true);  // Para debug
    
    if(isset($lv_pstarr['messages'])){
      if(!is_array($lv_pstarr['messages']) || count($lv_pstarr['messages'])==0){
      	return [ 'errtyp'=>'E', 'errcod'=>-30, 'errtxt'=>'Messages array empty', 'data'=>$lv_pstarr ];
      }
  	}
    
    // ejecuto llamada
		$lv_res = curl_exec($lo_curl);

    // verifico respuesta
		if (curl_errno($lo_curl)) {
    	$lv_ret = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Call error','data'=>curl_error($lo_curl).'***'.$lv_res);
		} else {
    	$lv_httpCode = curl_getinfo($lo_curl, CURLINFO_HTTP_CODE);
    	if ($lv_httpCode == 200) {
      	$lv_resarr = json_decode($lv_res, true);
        if (json_last_error() !== JSON_ERROR_NONE) {
    			$lv_ret = array('errtyp'=>'E','errcod'=>-2,'errtxt'=>'Unexpected json response. '.json_last_error_msg(),'data'=>$lv_res);
				} else {
          $lv_ret['data'] = $lv_resarr;
        }
    	} else {
	      $lv_ret = array('errtyp'=>'E','errcod'=>$lv_httpCode,'errtxt'=>'Http error','data'=>$lv_res);
  	  }
    }
    curl_close($lo_curl);
    
    // LOG. graba log de ejecución
    $lo_logmdl = $this->co_reg->load->model('sysapplog');
		$lv_log = [
                'srcobjtyp'=>'SYS_IAM', 'srcobjcod001'=>$lo_sysiaamdl->sysappiaamdlcod,
                'applogtecinf'=>'model:'.strtolower($lo_sysiaamdl->sysappiaamdltxt). ' / version:'.strtolower($lo_sysiaamdl->sysappiaamdlver). ' / prompt:'.$lp_prompt[0]. ' / param:'.$lp_prm,
                'mdlcod'=>'SYS', 'prgcod'=>'IAM', 'docsts'=>'A', 'applogerrtyp'=>$lv_ret['errtyp'], 'applogerrcod'=>$lv_ret['errcod'], 'applogerrtxt'=>$lv_ret['errtxt']
	  					];   
    $lo_logmdl->save( $lv_log );
    
    // devuelvo array con resultado + respuesta JSON
    return $lv_ret;
  }
	
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'sysappiaacod'),
                                      $this->co_reg->db->sqldat($lp_in,'sysappiaacodext'),
                                      $this->co_reg->db->sqldat($lp_in,'sysappiaatxt'),
                                     	$this->co_reg->db->sqldat($lp_in,'sysappiaamdlcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'sysappiaakey',false),
                                     	$this->co_reg->db->sqldat($lp_in,'sysappiaamap',false),
                                     	$this->co_reg->db->sqldat($lp_in,'sysappiaauac',false),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false)
																		);
		$this->sysdata['sqltxt'] = 'SYS_APP_IAA_DEF (?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
		return ($this->errcod==0?true:false);
	}	
}
?>
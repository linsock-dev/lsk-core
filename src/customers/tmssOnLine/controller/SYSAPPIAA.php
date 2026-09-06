<?php
final class sysappiaaController extends tmssController2 {
  function initialize(){ $this->MODEL='sysappiaa'; $this->VIEW='sysappiaa'; $this->ID='sysappiaacod'; }
  
  function additionalFunctions($lp_act){
    switch( $lp_act ){
      case '#getSingleScreen':
        return $this->co_reg->document->getView( 'sysappiaa_scrsng', array('data'=>array()) );
        break;
      
      // devuelve PopUp 
      case '#openaiassistant':
        // recupero listado de modelos para que el usuario elija
        $lo_iaamdl = $this->co_reg->load->model($this->MODEL);
        $lv_iaamdllst = $lo_iaamdl->getList();
        // junto los modelos en un mismo array dentro del array del listado
        $lv_data = [ 'mdllst' => $lv_iaamdllst ];
        // le asigno el id de sección del doc-viewer y el código externo de la activación al array de data
        $lv_data['docvwrsec'] = $this->post['docvwrsec']??'';
        $lv_data['sysappiaaactcodext'] = $this->post['sysappiaaactcodext']??'';
        
        return $this->co_reg->document->getView( 'sysappiaaask', array('data'=>$lv_data) );
        break;
      
      // ejecuta una operacion de IA (recibe PROMPT y SYSAPPIAACOD -id de aplicacion ia-)
      case '#execute':
        $lv_prompt = $this->post['prompt'] ?? '';
        $lv_sysappiaacod = $this->post['sysappiaacod'] ?? '';
        $lv_sysappiaaactcodext = $this->post['sysappiaaactcodext'] ?? '';
        $lv_history = $this->post['iaachthst'] ?? '';
        if($lv_prompt=='' || $lv_sysappiaacod=='' || $lv_sysappiaaactcodext==''){ return $this->co_reg->document->getJson([ 'errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'Id aplicacion, prompt y/o código de activación requeridos.' ]); }

  			// cargo modelo de IA
        $lo_iaamdl = $this->co_reg->load->model($this->MODEL);
        if(!$lo_iaamdl->load(['sysappiaacod'=>$lv_sysappiaacod])){ return $this->co_reg->document->getJson([ 'errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'No se pudo cargar el modelo de IA' ]); }

				// valido configuración básica
        if($lo_iaamdl->sysappiaamdlcod=='' || $lo_iaamdl->sysappiaakey==''){ return $this->co_reg->document->getJson([ 'errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'Falta configuración de modelo o clave' ]); }

				// obtengo la configuración de la activación (sistema + usuario => JSON;SYS-PROMPT + ATRIBUTOS)
        $lo_iaaact = $this->co_reg->load->model('sysappiaaact');
				
        $lo_iaaact->load([ 'sysappiaaactcodext' => $lv_sysappiaaactcodext ]);

        $lv_sysappiaaactprmppt = $lo_iaaact->sysappiaaactprmppt ?? '';
        $lv_sysappiaaactprmjsn = $lo_iaaact->sysappiaaactprmjsn ?? '{}';
        $lv_sysapiaaactatr  	 = $lo_iaaact->sysapiaaactatr    	?? '{}';

				// convierto los JSON de sistema y de usuario en arrays y los mergeo
        $lv_sysappiaaactprmjsn = json_decode( html_entity_decode($lv_sysappiaaactprmjsn ?? '{}', ENT_QUOTES | ENT_HTML5, 'UTF-8'),true ) ?? [];
        $lv_sysapiaaactatr = json_decode( html_entity_decode($lv_sysapiaaactatr ?? '{}', ENT_QUOTES | ENT_HTML5, 'UTF-8'),true ) ?? [];

        $lv_cfgarr = array_replace_recursive($lv_sysappiaaactprmjsn,$lv_sysapiaaactatr);

				// paso el array de configuración como parámetro y ejecuto
        $lv_prm = json_encode($lv_cfgarr);
				
        $lv_ret = $lo_iaamdl->execute( $lo_iaamdl, $lv_prompt, $lv_history, $lv_prm, $lv_sysappiaaactprmppt );

				// normalizo la respuesta
        $lv_data = json_encode($lv_ret['data'],true);
        $lv_ret['data'] = [ 'content' => $lv_ret['data']['choices'][0]['message']['content'] ?? '', 'raw' => $lv_data ];

        return $this->co_reg->document->getJson($lv_ret);

      break;
    }
  }

}
?>
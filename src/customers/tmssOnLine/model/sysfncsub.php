<?php
final class sysfncsub extends tmssAction2 {  
  function initialize(){ $this->ID = 'sysfncsubcod'; }
	
	function setFormData($lp_prm=array()){
		foreach($lp_prm as $lv_key=>$lv_val) {$this->co_reg->request->post[$lv_key]=$lv_val;}
	}
	
  // GET PROGRAMS LIST. obtiene la lista de suscripciones módulo/programa
  function getProgramsList( $lp_vewopt=array(), $lp_prm=array() ) {
    $lo_vew = $this->co_reg->load->model('grlvew');
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp('19',$lp_prm,$lo_out_data) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
  // GET OPERATIONS LIST. obtiene la lista de suscripciones módulo/programa/operación
  function getOperationsList( $lp_vewopt=array(), $lp_prm=array() ) {
    $lo_vew = $this->co_reg->load->model('grlvew');
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp('28',$lp_prm,$lo_out_data) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, 
																			$this->co_reg->db->sqldat($lp_in,'sysfncsubcod'), 
																			$this->co_reg->db->sqldat($lp_in,'sysfnccod'), 
																			$this->co_reg->db->sqldat($lp_in,'cuscod'), 
																			$this->co_reg->db->sqldat($lp_in,'cuscodext'), 
																			$this->co_reg->db->sqldte($lp_in,'sysfncsubstrdte'), 
																			$this->co_reg->db->sqldte($lp_in,'sysfncsubenddte'), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false)
																		);
		$this->sysdata['sqltxt'] = 'SYS_FNC_SUB_DEF (?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'], 0 );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|19|28')){return false;}
    
		return ($this->errcod==0?true:false);
	}	
}
?>
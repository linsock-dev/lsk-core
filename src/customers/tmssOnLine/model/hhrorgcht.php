<?php 
final class hhrorgcht extends tmssAction2 {
  function initialize(){ $this->ID = 'hhrorgchtcod'; }
	
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
    $lv_buscod = ($lp_in['altbuscod']??''!='')?$lp_in['altbuscod']:$this->co_reg->sec->buscod;
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $lv_buscod, 
																			$this->co_reg->db->sqldat($lp_in,'hhrorgchtcod'), 
																			$this->co_reg->db->sqldat($lp_in,'hhrorgchtcodext'), 
																			$this->co_reg->db->sqldat($lp_in,'hhrorgchttxt'), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocclscod')
																		);
		$this->sysdata['sqltxt'] = 'HHR_ORG_CHT_DEF (?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}    
    
    // E N T E G R A M A S 
    if( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ){
			/*$lo_orgwrkmdl = $this->co_reg->load->model('hhrorgchtwrk');                                             
			$lv_prm = array('vewfldflt' =>'[~fltrow~]o.hhrorgchtcod'.chr(9).'='.chr(9).chr(9).$this->data[$this->ID].chr(9).chr(9));
			$lp_out['hhrorghchtwrk'] = $lo_orgwrkmdl->getList($lv_prm); */$lp_out['hhrorghchtwrk'] = [];
    }
    
		return ($this->errcod==0?true:false);
	}
}
?>
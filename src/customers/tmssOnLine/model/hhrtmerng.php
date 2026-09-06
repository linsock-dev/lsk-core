<?php
final class hhrtmerng extends tmssAction2 {

	function initialize(){$this->ID = 'hhrtmerngcod';}
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'hhrtmerngcod'),
																			$this->co_reg->db->sqldat($lp_in,'hhrtmerngcodext'), 
																			$this->co_reg->db->sqldat($lp_in,'hhrtmerngtxt'), 
																			$this->co_reg->db->sqldat($lp_in,'hhrtmerngatr',false), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqlnum($lp_in,'hhrtmerngwekhrs', 1),
																			$this->co_reg->db->sqlnum($lp_in,'hhrtmerngfrq', 0)
																		);
		$this->sysdata['sqltxt'] = 'HHR_TME_RNG_DEF (?,?,?, ?,?,?,?,?,?, ?, ?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    
    if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}		
		
		return ($this->errcod==0?true:false);
	}
}
?>
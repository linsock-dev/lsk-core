<?php
final class educar extends tmssAction2 {
	function initialize(){ $this->ID = 'educarcod'; }

	// CALL SP - llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                     	$this->co_reg->db->sqldat($lp_in,'educarcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'educarcodext'),
                                     	$this->co_reg->db->sqldat($lp_in,'educartxt'),
                                     	$this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata, 'view_options', false)		
																		);
		$this->sysdata['sqltxt'] = 'EDU_CAR_DEF (?,?,?,?,?,?,?,?)';
   	$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		return $this->chkError($lp_action, $lo_rs, $lp_out, '08|18');
	}
}
?>
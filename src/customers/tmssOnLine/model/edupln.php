<?php
final class edupln extends tmssAction2 {
	function initialize(){$this->ID = 'eduplncod';}	
	
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                     	$this->co_reg->db->sqldat($lp_in,'eduplncod'),
                                     	$this->co_reg->db->sqldat($lp_in,'educurcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'educarcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'educoucod'),
                                     	$this->co_reg->db->sqldat($lp_in,'edusubcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'eduplncmt'),
                                     	$this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                     	$this->co_reg->db->sqldte($lp_in,'eduplndtestr'),
                                     	$this->co_reg->db->sqldte($lp_in,'eduplndteend'),
                                     	$this->co_reg->db->sqldat($lp_in,'sysdocclscod')                                 
																		);
		$this->sysdata['sqltxt'] = 'EDU_PLN_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']); 
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    return $this->chkError($lp_action, $lo_rs, $lp_out,'08|18');
	}	
}
?>
<?php
final class cnsprslqddoc extends tmssAction2 {
	function initialize(){ $this->ID = 'cnsprslqddoc'; }

	// CALL SP - llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                     	$this->co_reg->db->sqldat($lp_in,'cnsprslqddoccod'),
                                     	$this->co_reg->db->sqldat($lp_in,'cnsprslqdcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'refobjtyp'),
                                     	$this->co_reg->db->sqldat($lp_in,'refobjcod001'),
                                     	$this->co_reg->db->sqldat($lp_in,'refobjcod002'),
                                     	$this->co_reg->db->sqldat($lp_in,'cnsprslqddocqty'),
                                     	$this->co_reg->db->sqldat($lp_in,'matuntcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'cnsprslqddocprc'),
                                     	$this->co_reg->db->sqldat($lp_in,'cnsprslqddoctot'),
                                     	$this->co_reg->db->sqldat($lp_in,'cnsprslqddocatr001'),
                                     	$this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata, 'view_options', false)		
																		);
		$this->sysdata['sqltxt'] = 'CNS_PRS_LQD_DOC_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
   	$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		return $this->chkError($lp_action, $lo_rs, $lp_out, '08|18');
	}
}
?>
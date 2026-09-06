<?php
final class sysapplog extends tmssAction2 {
	function initialize(){ $this->ID = 'applogcod'; }

	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
    $lv_sys = ($lp_in['sys']??'1');
    $this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'applogcod'), 
																			$this->co_reg->db->sqldat($lp_in,'applogtxt',false), 
																			$this->co_reg->db->sqldat($lp_in,'srcobjtyp'), 
																			$this->co_reg->db->sqldat($lp_in,'srcobjcod001'), 
																			$this->co_reg->db->sqldat($lp_in,'srcobjcod002'), 
																			$this->co_reg->db->sqldat($lp_in,'applogtecinf',false), 
																			$this->co_reg->db->sqldat($lp_in,'mdlcod'), 
																			$this->co_reg->db->sqldat($lp_in,'prgcod'), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'applogerrtyp'),
																			$this->co_reg->db->sqldat($lp_in,'applogerrcod'),
																			$this->co_reg->db->sqldat($lp_in,'applogerrtxt')
																		);
		$this->sysdata['sqltxt'] = 'SYS_APP_LOG_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'], $lv_sys );

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08')){return false;}
    
		return ($this->errcod==0?true:false);
	}
}
?>
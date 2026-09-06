<?php
final class hltpatprsrls extends tmssAction2 {
	function initialize(){ $this->ID = 'patprsrlscod'; }
  
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
																			$this->co_reg->db->sqldat($lp_in,'patprsrlscod'),
																			$this->co_reg->db->sqldat($lp_in,'prsrlscod'),
																			$this->co_reg->db->sqldat($lp_in,'patcod'),
																			$this->co_reg->db->sqldat($lp_in,'prscod'),
																			$this->co_reg->db->sqldat($lp_in,'usrcod'), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'patprsrlsatr001',false)
																		);
		
    $this->sysdata['sqltxt'] = 'HLT_PAT_PRS_RLS_DEF (?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		
    if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}

		return ($this->errcod==0?true:false);
	}
}
?>
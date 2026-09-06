<?php
final class sysappiaaact extends tmssAction2 {
  const OBJTYP = 'SYS_IAA_ACT';
  function initialize(){ $this->ID = 'sysappiaaactcod'; }
	
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod,
                                     	//$this->co_reg->db->sqldat($lp_in,'sysappiaaactcod'),
																			$this->co_reg->db->sqldat($lp_in,'sysappiaacod'),
                                      $this->co_reg->db->sqldat($lp_in,'sysappiaaactcodext'),
                                      $this->co_reg->db->sqldat($lp_in,'sysappiaaacttxt'),
                                     	$this->co_reg->db->sqldat($lp_in,'sysappiaaactcmt'),
                                     	$this->co_reg->db->sqldat($lp_in,'sysappiaaactprmppt'),
                                     	$this->co_reg->db->sqldat($lp_in,'sysappiaaactprmjsn',false),
                                     	$this->co_reg->db->sqldat($lp_in,'sysappiaaactatr',false),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false)
																		);
		$this->sysdata['sqltxt'] = 'SYS_APP_IAA_ACT_DEF (?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'], '0' );

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
		return ($this->errcod==0?true:false);
	}	
}
?>
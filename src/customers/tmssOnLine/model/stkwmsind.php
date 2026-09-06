<?php
final class stkwmsind extends tmssAction2 {
  function initialize(){ $this->ID = 'wmsindcod'; }

  //  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
                                     	$this->co_reg->db->sqldat($lp_in,'wmsindcod'),
																			$this->co_reg->db->sqldat($lp_in,'wmsindcodext'),
                                      $this->co_reg->db->sqldat($lp_in,'wmsindtxt'),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata,'view_options',false)
                                    );
		$this->sysdata['sqltxt'] = 'STK_WMS_IND_DEF (?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    
    // Si hubo error del recordset finalizar ejecucion
    if(!$this->chkError($lp_action, $lo_rs, $lp_out, '08|18')) { return false; }
    return ($this->errcod==0?true:false);

	}
}
?>
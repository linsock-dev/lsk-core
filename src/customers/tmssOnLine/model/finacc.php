<?php
final class finacc extends tmssAction2 {
  const OBJTYP = 'FIN_ACC';  
  function initialize(){ $this->ID = 'finacccod'; }
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
    $this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                     	$this->co_reg->db->sqldat($lp_in,'finacccod'),
                                     	$this->co_reg->db->sqldat($lp_in,'finacccodext'),
                                     	$this->co_reg->db->sqldat($lp_in,'finacctxt'),
                                     	$this->co_reg->db->sqldat($lp_in,'finaccclscod'),
                                     	$this->co_reg->db->sqldat($lp_in,'curcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'finacctxtext'),
                                     	$this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($lp_in,'finaccatr'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options', false)
																		);
    $this->sysdata['sqltxt'] = 'FIN_ACC_DEF (?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		
		//Si hubo error del recordset finalizar ejecucion
		return $this->chkError($lp_action, $lo_rs, $lp_out,'08|18');
	}
}
?>
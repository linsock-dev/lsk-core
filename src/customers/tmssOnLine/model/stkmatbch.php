<?php
final class stkmatbch extends tmssAction2 {
  function initialize(){ $this->ID = 'matbchcod'; }

	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
																			$this->co_reg->db->sqldat($lp_in,'matbchcod'),
																			$this->co_reg->db->sqldat($lp_in,'matbchcodext',false),
																			$this->co_reg->db->sqldat($lp_in,'matcod'),
																			$this->co_reg->db->sqldte($lp_in,'matbchduedte'),
																			$this->co_reg->db->sqldte($lp_in,'matbchprddte'),
																			$this->co_reg->db->sqldat($lp_in,'supcod'),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
                                     	$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldat($lp_in,'matbchatr',false)
																		);
		$this->sysdata['sqltxt'] = 'STK_MAT_BCH_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
	
    //Si hubo error del recordset finalizar ejecucion
    return $this->chkError($lp_action, $lo_rs, $lp_out,'08|18');
	}
}
?>
<?php
final class sysobjcls extends tmssAction2 {
	const OBJTYP = 'SLS_OBC';
  function initialize(){ $this->ID = 'sysobjclscod'; }

	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod,
																		$this->co_reg->db->sqldat($lp_in,'sysobjclscod'),
                                    $this->co_reg->db->sqldat($lp_in,'sysobjclscodext'),
                                    $this->co_reg->db->sqldat($lp_in,'sysobjclstxt'),
                                    $this->co_reg->db->sqldat($lp_in,'sysobjclstyp'),
                                    $this->co_reg->db->sqldat($lp_in,'sysobjclspth'),
                                    $this->co_reg->db->sqldat($lp_in,'sysobjclsfleext'),
                                    $this->co_reg->db->sqldat($lp_in,'sysobjclssys'),
																		$this->co_reg->db->sqldat($lp_in,'docsts'),
																		$this->co_reg->db->sqldat($this->sysdata,'view_options',false)
																		);
		$this->sysdata['sqltxt'] = 'SYS_OBJ_CLS_DEF (?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] , 0);

		//Si hubo error del recordset finalizar ejecucion
		return $this->chkError($lp_action, $lo_rs, $lp_out,'08|18');
	}
}
?>
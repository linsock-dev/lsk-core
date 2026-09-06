<?php
final class logtrazon extends tmssAction2 {
	const OBJTYP = 'LOG_ZON';
  function initialize(){ $this->ID = 'trazoncod'; }

	//CALL SP. llamada a storedprocedure del modelo
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                     	$this->co_reg->db->sqldat($lp_in,'trazoncod'),
                                     	$this->co_reg->db->sqldat($lp_in,'trazoncodext'),
                                   		$this->co_reg->db->sqldat($lp_in,'trazontxt'),
                                     	$this->co_reg->db->sqldat($lp_in,'trazonatr'),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata, 'view_options', false)
																		);
		$this->sysdata['sqltxt'] = 'LOG_TRA_ZON_DEF (?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		// si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
		return ($this->errcod==0?true:false);
	}
}
?>
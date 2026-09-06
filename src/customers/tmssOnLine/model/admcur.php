<?php
final class admcur extends tmssAction2 {
	const OBJTYP = 'ADM_CUR';
  function initialize(){ $this->ID = 'curcodint'; }
	  
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
    $this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                      $this->co_reg->db->sqldat($lp_in,'curcodint'),
																			$this->co_reg->db->sqldat($lp_in,'curcod'),
                                      $this->co_reg->db->sqldat($lp_in,'curtxt'),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                      $this->co_reg->db->sqldat($lp_in,'cursgn'),
                                      $this->co_reg->db->sqldat($lp_in,'curdec'),
                                      $this->co_reg->db->sqldat($lp_in,'curtxtsht'),
                                      $this->co_reg->db->sqldat($lp_in,'curtxtmed')
																		);
		$this->sysdata['sqltxt'] = 'ADM_CUR_DEF (?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		// si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|23')){return false;}
		
    return ($this->errcod==0?true:false);
	}
}
?>
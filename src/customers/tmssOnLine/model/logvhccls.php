<?php
final class logvhccls extends tmssAction2 {
	const OBJTYP = 'LOG_VCC';
  function initialize(){ $this->ID = 'vhcclscod'; }

	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                      $this->co_reg->db->sqldat($lp_in,'vhcclscod'),
                                      $this->co_reg->db->sqldat($lp_in,'vhcclscodext'),
                                      $this->co_reg->db->sqldat($lp_in,'vhcclstxt'),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
																		);
		$this->sysdata['sqltxt'] = 'LOG_VHC_CLS_DEF (?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		// si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
    return ($this->errcod==0?true:false);
	}
}
?>
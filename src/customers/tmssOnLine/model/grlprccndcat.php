<?php
final class grlprccndcat extends tmssAction2 {
  const OBJTYP = 'GRL_PCC';  
  function initialize(){ $this->ID = 'prccndcatcod'; }
	
	//  CALL SP.  llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                     	$this->co_reg->db->sqldat($lp_in, 'prccndcatcod'),
                                     	$this->co_reg->db->sqldat($lp_in, 'prccndcatcodext'),
                                     	$this->co_reg->db->sqldat($lp_in, 'prccndcattxt'),
                                     	$this->co_reg->db->sqldat($lp_in, 'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata, 'view_options', false)
																		);
		$this->sysdata['sqltxt'] = 'GRL_PRC_CND_CAT_DEF (?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    
		//Si hubo error del recordset finalizar ejecucion
		return $this->chkError($lp_action, $lo_rs, $lp_out,'08|18');
	}	
}
?>
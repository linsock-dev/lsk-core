<?php
final class grldatfletyp extends tmssAction2 {
  const SRCTYP = 'GRL_FLE_TYP';                                                                                                                           
	function initialize(){ $this->ID = 'fletypcod'; }
  
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                       $this->co_reg->db->sqldat($lp_in,'fletypcod'),
                                       $this->co_reg->db->sqldat($lp_in,'fletypcodext'),
                                       $this->co_reg->db->sqldat($lp_in,'fletyptxt'),
                                       $this->co_reg->db->sqldat($lp_in,'fletypatr'),
                                       $this->co_reg->db->sqldat($lp_in,'docsts'),
                                    	 $this->co_reg->db->sqldat($lp_in,'autcod'),
                                       $this->co_reg->db->sqldat($this->sysdata,'view_options', false)
																		);
		$this->sysdata['sqltxt'] = 'GRL_DAT_FLE_TYP_DEF (?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    
    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
    
		return ($this->errcod==0?true:false);
	}
}
?>
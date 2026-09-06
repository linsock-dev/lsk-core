<?php
final class finlocargpos extends tmssAction2 {
  function initialize(){ $this->ID = 'argposcod'; }
	
	//  CALL SP: llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                     $this->co_reg->db->sqldat($lp_in,'argposcod'),
                                     $this->co_reg->db->sqldat($lp_in,'argposcodext'),
                                     $this->co_reg->db->sqldat($lp_in,'slsposcod'),
                                     $this->co_reg->db->sqldat($lp_in,'argpostyp'),
                                     $this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                     $this->co_reg->db->sqldat($lp_in,'argltrcod'),
                                     $this->co_reg->db->sqldat($lp_in,'docrngcod'),
                                     $this->co_reg->db->sqldat($lp_in,'argposatr'),
                                     $this->co_reg->db->sqldat($lp_in,'docsts'),
                                     $this->co_reg->db->sqldat($lp_in,'argposregcod'),
                                     $this->co_reg->db->sqldat($lp_in,'argpostxt'),
                                     $this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																		);
		$this->sysdata['sqltxt'] = 'FIN_LOC_ARG_POS_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		
    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}

    return ($this->errcod==0?true:false);
	}	
}
?>
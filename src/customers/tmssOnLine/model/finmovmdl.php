<?php 
final class finmovmdl extends tmssAction2 {
  function initialize(){ $this->ID = 'finmovmdlcod'; }
  	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'finmovmdlcod'), 
																			$this->co_reg->db->sqldat($lp_in,'finmovmdlcodext'), 
																			$this->co_reg->db->sqldat($lp_in,'finmovmdltxt'), 
																			$this->co_reg->db->sqldat($lp_in,'curcod'), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
                                     	$this->co_reg->db->sqldat($lp_in,'finmovmdlacc',false)
																		);
		$this->sysdata['sqltxt'] = 'FIN_MOV_MDL_DEF (?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		//Si hubo error del recordset finalizar ejecucion
		if( !$this->chkError($lp_action, $lo_rs, $lp_out,'08|18') ){ return false; }
    
  	// convierto atributos JSON en ARRAY
    if ( $lp_action=='03' || $lp_action=='13' ) {
      $lp_out['finmovmdlacc'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['finmovmdlacc']??'[]'), true ));
    }    

    return ($this->errcod==0?true:false);
	}	
}
?>
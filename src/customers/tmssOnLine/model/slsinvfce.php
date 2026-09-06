<?php
final class slsinvfce extends tmssAction2 {
  function initialize(){ $this->ID = 'slsinvcod'; }
  
  // ANULAR. anular objeto
  function remove( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		return $this->call_sp( '05', $this->data, $this->data );
  }

	// CONFIRM. confirma la factura electronica
  function confirm( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		$lo_out_data = array();
		return $this->call_sp( '09', $this->data, $this->data );
  }
	
	//  CALL SP.  llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																				$this->co_reg->db->sqldat($lp_in,'slsinvcod'), 
																				$this->co_reg->db->sqldat($lp_in,'slsposcod'), 
																				$this->co_reg->db->sqldat($lp_in,'slsinvfcecodext'), 
																				$this->co_reg->db->sqldat($lp_in,'slsinvfceautcodext'), 
																				$this->co_reg->db->sqldte($lp_in,'slsinvfceautduedte'), 
																				$this->co_reg->db->sqldat($lp_in,'slsinvfceautnum'), 
																				$this->co_reg->db->sqldat($lp_in,'slsinvfceatr',false), 
																				$this->co_reg->db->sqldat($lp_in,'docsts'),
																				$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																				$this->co_reg->db->sqldat($lp_in,'docrngcod')
																			);
		$this->sysdata['sqltxt'] = 'SLS_INV_FCE_DEF (?,?,?,?,?,?,?,?,?,?,?,?,null,null,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'05|09|08|18')){return false;}
    
		return ($this->errcod==0?true:false);
	}	
}
?>
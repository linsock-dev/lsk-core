<?php 
final class sysint extends tmssAction2 { 
	const OBJTYP = 'SYS_INT';
  function initialize(){ $this->ID = 'sysintcod'; }
	
  // SET RUN DATA. actualiza los datos de la ultima ejecución
  function setRunData( $lp_key=array() ) {
		$this->data = $lp_key;
		$lo_out_data = array();
		return $this->call_sp( '10', $this->data, $lo_out_data );
  }
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
    $this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'sysintcod'), 
                                      $this->co_reg->db->sqldat($lp_in,'sysintcodext'),
                                      $this->co_reg->db->sqldat($lp_in,'sysinttxt'),
																			$this->co_reg->db->sqldat($lp_in,'sysinturl',false),
                                      $this->co_reg->db->sqldat($lp_in,'sysinterrntf'),
                                      (isset($lp_in['sysintatr'])?html_entity_decode($lp_in['sysintatr']):''), 
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
                                      $this->co_reg->db->sqldat($lp_in,'errtyp'),
                                      $this->co_reg->db->sqldat($lp_in,'errcod'),
                                      $this->co_reg->db->sqldat($lp_in,'errtxt',false),
                                      $this->co_reg->db->sqldat($lp_in,'errlog',false),
                                      $this->co_reg->db->sqldat($lp_in,'errtch',false)
                                    );
		$this->sysdata['sqltxt'] = 'SYS_INT_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);		
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		// si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
    // convierto atributos JSON en ARRAY
    if ( $lp_action=='03' || $lp_action=='13' ) {
      $lp_out['sysintcnv'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['sysintcnv']??'[]'), true ));
		}
				
		return ($this->errcod==0?true:false);
	}
}
?>
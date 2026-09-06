<?php
final class finaccpln extends tmssAction2 {
  function initialize(){ $this->ID = 'finaccplncod'; }
	
  
  public function uploadCheck($lp_post){
		$lo_out_data = array();
    //Al tener declarado que dependiendo del authCheck el retorno es uno u otro.
		//sucede que hay call_sp que no tienen la actividad 18 como vuelta de de RS y al utilizar el chkError solo con 08 esto rompe el getList
		if ( $this->call_sp('28', $lp_post, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
			$this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
		return $this->data;
  }
  
  //obtiene todos los datos necesarios del reporte 
  public function getReport($lp_post){
		$lo_out_data = array();
		if ( $this->call_sp('29', $lp_post, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
			$this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
		return $this->data;
  }
  
  //obtiene los ultimos periodos contables disponibles
  public function getPerList(){
		$lo_out_data = array();
		if ( $this->call_sp('38', array(), $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
			$this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
		return $this->data;
  }
  
  //  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out) {
    $this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                     	$this->co_reg->db->sqldat($lp_in,'finaccplncod'),
                                     	$this->co_reg->db->sqldat($lp_in,'finaccplncodext'),
                                     	$this->co_reg->db->sqldat($lp_in,'finaccplntxt'),
                                     	$this->co_reg->db->sqldat($lp_in,'curcod'),	
                                     	$this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata,'view_options', false),
                                      $this->co_reg->db->sqldat($lp_in,'finaccplnacc', false),
                                      $this->co_reg->db->sqldat($lp_in,'finacccod', false),
                                      $this->co_reg->db->sqldat($lp_in,'fintaxexepercod', false)
													);
    $this->sysdata['sqltxt'] = 'FIN_ACC_PLN_DEF (?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
	  //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|28|29|38')){return false;}
		
		// CUENTAS. cargo cuentas del documento
		if( $lp_action=='03' or $lp_action=='13' ){
      $lp_out['acc'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['finaccplnacc']??'[]'), true ));      
		}
		
		return ($this->errcod==0?true:false);
	}	

}
?>
<?php
final class fintaxexe extends tmssAction2 {
	function initialize(){ $this->ID = 'fintaxexecod'; }
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
    $this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                     $this->co_reg->db->sqldat($lp_in,'fintaxexecod'),
                                     $this->co_reg->db->sqldat($lp_in,'fintaxexecodext'),
                                     $this->co_reg->db->sqldat($lp_in,'fintaxexetxt'),
                                     $this->co_reg->db->sqldte($lp_in,'fintaxexestrdte'),
                                     $this->co_reg->db->sqldte($lp_in,'fintaxexeenddte'),
                                     $this->co_reg->db->sqldat($lp_in,'docsts'),
                                     $this->co_reg->db->sqldat($this->sysdata,'view_options', false),
                                     $this->co_reg->db->sqldat($lp_in,'fintaxexeper', false)
																		);
    $this->sysdata['sqltxt'] = 'FIN_TAX_EXE_DEF (?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		
		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
        
    // convierto atributos JSON en ARRAY
    if ( $lp_action=='03' || $lp_action=='13' ) {
      $lv_fintaxexeper = (($lp_out['fintaxexeper']??'')==''?'[]':$lp_out['fintaxexeper']);
      $lp_out['fintaxexeper'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lv_fintaxexeper), true ));
    }        
    
		return ($this->errcod==0?true:false);
  }
}
?>
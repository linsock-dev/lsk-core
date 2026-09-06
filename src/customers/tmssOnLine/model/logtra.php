<?php
final class logtra extends tmssAction2 {
  const OBJTYP = 'LOG_TRA'; 
  
	function initialize(){ $this->ID = 'tracod'; }
  
  // SET DATES. fija las fechas de cabecera del transporte     
  function setDates( $lp_dat=array() ) {
    if(count($lp_dat)==0){ $lp_dat = $this->co_reg->request->post; } 
    $this->data = $lp_dat;
		$lo_out_data = array();
		if ( $this->call_sp( '25', $this->data, $lo_out_data ) ) {
			return true;
		} else {
			return false;
		}
  }
    
	// CALL SP. llamada a storedprocedure del modelo
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
    $this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
                                      $this->co_reg->db->sqldat($lp_in,'tracod'),
                                      $this->co_reg->db->sqldat($lp_in,'tracodext'),
                                      $this->co_reg->db->sqldte($lp_in,'tradte'),
                                      $this->co_reg->db->sqldat($lp_in,'traroucod'),
                                      $this->co_reg->db->sqldat($lp_in,'vhccod'),
                                      $this->co_reg->db->sqldat($lp_in,'drvcod'),
                                      $this->co_reg->db->sqldat($lp_in,'traatr'),
                                      $this->co_reg->db->sqldat($lp_in,'tracmt'),
                                      strtoupper(isset($lp_in['trastrdte'])?$this->co_reg->db->sqldatetime($lp_in['trastrdte']):''), 
																			strtoupper(isset($lp_in['traenddte'])?$this->co_reg->db->sqldatetime($lp_in['traenddte']):''),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                     	isset($lp_in['objtyp'])? $lp_in['objtyp'] : self::OBJTYP,
                                     	$this->co_reg->db->sqldat($lp_in, 'tradlv', false)
																		);
    $this->sysdata['sqltxt'] = 'LOG_TRA_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}    
 
    //D L V
      if (($lp_action == '03' || $lp_action == '13') && $this->errcod == 0) {
			$lp_out['dlv'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['dlv']??'[]'), true ));    
		}
		
		return ($this->errcod==0?true:false);
	}
}
?>
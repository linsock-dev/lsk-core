<?php
final class hltpatevl extends tmssAction2 { 
  function initialize(){ $this->ID = 'evlcod'; }
	 
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'evlcod'), 
																			$this->co_reg->db->sqldat($lp_in,'evlnum'), 
																			$this->co_reg->db->sqldat($lp_in,'patcod'),
																			$this->co_reg->db->sqldat($lp_in,'prscod'),
																			$this->co_reg->db->sqldat($lp_in,'spccod'),
																			$this->co_reg->db->sqldte($lp_in,'evldte'), 
																			$this->co_reg->db->sqldat($lp_in,'evlusr'), 
																			$this->co_reg->db->sqldat($lp_in,'evlevl',false),
																			$this->co_reg->db->sqldat($lp_in,'evlsub',false),
																			$this->co_reg->db->sqldat($lp_in,'evlobj',false),
																			$this->co_reg->db->sqldat($lp_in,'evlcmt',false),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldte($lp_in,'evldtestr'),
																			$this->co_reg->db->sqldte($lp_in,'evldteend'),
																			$this->co_reg->db->sqldat($lp_in,'plnid'),
																			$this->co_reg->db->sqldat($lp_in,'plndteid'),
																			$this->co_reg->db->sqldat($lp_in,'evlatr001',false),
																			$this->co_reg->db->sqldat($lp_in,'delcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldat($lp_in,'evlmat',false),
																			$this->co_reg->db->sqldat($lp_in,'evlspc',false)
																		);
		$this->sysdata['sqltxt'] = 'HLT_PAT_EVL_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
    
    // convierto atributos JSON en ARRAY
    if ( $lp_action=='03' || $lp_action=='13' ) {
      //$lp_out['evlatr'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['evlatr']??'[]'), true ));
      $lp_out['evlspc'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['evlspc']??'[]'), true ));
      $lp_out['evlmat'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['evlmat']??'[]'), true ));
		}
    
		return ($this->errcod==0?true:false);
	}	
}
?>
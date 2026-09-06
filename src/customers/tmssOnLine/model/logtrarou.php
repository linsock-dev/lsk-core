<?php
final class logtrarou extends tmssAction2 {
	const SRCTYP = 'LOG_ROU';
	
  function initialize(){$this->ID = 'traroucod';}
	// CREATE. crea un objeto
	function create() {
    parent::create();
		$this->data['trarouzon'] = array();
	}
	
	// CALL SP. llamada a storedprocedure del modelo
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                     	$this->co_reg->db->sqldat($lp_in,'traroucod'),
                                     	$this->co_reg->db->sqldat($lp_in,'traroucodext'),
                                   		$this->co_reg->db->sqldat($lp_in,'traroutxt'),
                                      $this->co_reg->db->sqldat($lp_in,'trarouatr'),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                     	$this->co_reg->db->sqldat($lp_in, 'trarouzon', false)
																		);
		$this->sysdata['sqltxt'] = 'LOG_TRA_ROU_DEF (?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		
    if(!$this->chkError($lp_action, $lo_rs, $lp_out, '08|18')){ return false;}
		
		// Z O N A S
    if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lp_out['trarouzon'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['trarouzon']??'[]'), true ));
		}
		
		return ($this->errcod==0?true:false);
	}
}
?>
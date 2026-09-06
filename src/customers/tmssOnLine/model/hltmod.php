<?php
final class hltmod extends tmssAction2 {
  function initialize(){ $this->ID = 'hltmodcod'; }
	
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'hltmodcod'), 
																			$this->co_reg->db->sqldat($lp_in,'hltmodcodext'), 
																			$this->co_reg->db->sqldat($lp_in,'hltmodtxt'), 
																			$this->co_reg->db->sqldat($lp_in,'cuscod'),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod')
																		);
		$this->sysdata['sqltxt'] = 'HLT_MOD_DEF (?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}

		//		C O N T E N I D O
		if ( $lp_action=='03' && $this->errcod==0 ) {
			$lo_plnmdl = $this->co_reg->load->model('hltmodpln');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]mp.hltmodcod'.chr(9).'='.chr(9).chr(9).$this->data[$this->ID].chr(9).chr(9));
			$lp_out['hltmodpln'] = $lo_plnmdl->getList( $lv_prm );
		}
    
		return ($this->errcod==0?true:false);
	}
}
?>
<?php
final class stkmanreq extends tmssAction2 {
  function initialize(){ $this->ID = 'stkmanreqcod'; }
	
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'stkmanreqcod'),
																			$this->co_reg->db->sqldat($lp_in,'stkmanreqcodext'), 
                                      $this->co_reg->db->sqldat($lp_in,'stkmanreqtxt'),
                                      $this->co_reg->db->sqldte($lp_in,'stkmanreqdte'), 
                                      $this->co_reg->db->sqldat($lp_in,'srcobjtyp'),
																			$this->co_reg->db->sqldat($lp_in,'srcobjcod'),
																			$this->co_reg->db->sqldat($lp_in,'srccntcod'),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocrejcod'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false)
																		);
		$this->sysdata['sqltxt'] = 'STK_MAN_REQ_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
  
    //		M A T E R I A L E S
		if ( ($lp_action=='03' || $lp_action=='13' ) && $this->errcod==0 ) {
			$lo_stkmanreqmat = $this->co_reg->load->model('stkmanreqmat');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]rm.stkmanreqcod'.chr(9).'='.chr(9).chr(9).$lp_in['stkmanreqcod'].chr(9).chr(9));
			$lp_out['stkmanreqmat'] = $lo_stkmanreqmat->getList( $lv_prm, null, null, false );
		}
        
		return ($this->errcod==0?true:false);
	}
}
?>
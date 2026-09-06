<?php
final class sysseclnk extends tmssAction2 {
	function initialize(){ $this->ID='sysseclnkcod';}

	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
    $this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'sysseclnkcod'), 
																			$this->co_reg->db->sqldat($lp_in,'objtyp'), 
																			$this->co_reg->db->sqldat($lp_in,'usrgrpcod'), 
																			$this->co_reg->db->sqldat($lp_in,'usrprmcod'), 
																			$this->co_reg->db->sqldat($lp_in,'sysseclnksrcfld'), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false)
																		);
    $this->sysdata['sqltxt'] = 'SYS_SEC_LNK_DEF (?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    $this->chkError($lp_action, $lo_rs, $lp_out, '08|18');
    
    //		T I P O  D E  O B J E T O
		if ( ($lp_action=='03' || $lp_action=='13' ) && $this->errcod==0 ) {
			$lo_sysobjmdl = $this->co_reg->load->model('sysobjtyp');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]o.objtypcod'.chr(9).'='.chr(9).chr(9).$lo_rs[0]['objtyp'].chr(9).chr(9));
			$lv_rs2= $lo_sysobjmdl->getList( $lv_prm );
      $lp_out['objtyptxt'] = $lv_rs2[0]['objtyptxt'];
		}
    // 		G R U P O  D E  U S U A R I O
    if ( ($lp_action=='03' || $lp_action=='13' ) && $this->errcod==0 ) {
			$lo_sysobjmdl = $this->co_reg->load->model('syssecgrp');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]usrgrpcod'.chr(9).'='.chr(9).chr(9).$lo_rs[0]['usrgrpcod'].chr(9).chr(9));
			$lv_rs2= $lo_sysobjmdl->getList( $lv_prm );
      $lp_out['usrgrptxt'] = $lv_rs2[0]['usrgrptxt'];
		}
		//		P A R A M E T R O  D E  U S U A R I O
    if ( ($lp_action=='03' || $lp_action=='13' ) && $this->errcod==0 ) {
      $lo_sysobjmdl = $this->co_reg->load->model('syssecusrprm');
      $lv_prm = array('vewfldflt' =>'[~fltrow~]secusrprmcod'.chr(9).'='.chr(9).chr(9).$lo_rs[0]['usrprmcod'].chr(9).chr(9));
      $lv_rs2= $lo_sysobjmdl->getDefinitions( $lv_prm );
      $lp_out['usrprmtxt'] = $lv_rs2[0]['secusrprmtxt'];
    }
		return ($this->errcod==0?true:false);	
	}
}
?>
<?php
final class hltagr extends tmssAction2 {
  //¿Esto se sigue usando?
	function initialize(){ $this->ID = 'hltagrcod'; }
  
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck = true) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$lp_dat['hltagratr'] = '<prs>'.$lp_dat['hltagratrprs'].'</prs>';
		return parent::save($lp_dat, $lp_authCheck);
  } 
  
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                     	$this->co_reg->db->sqldat($lp_in,'hltagrcod'), 
																			$this->co_reg->db->sqldat($lp_in,'hltagrcodext'), 
																			$this->co_reg->db->sqldat($lp_in,'hltagrtxt'),
                                     	$this->co_reg->db->sqldte($lp_in,'hltagrstrdte'),
                                     	$this->co_reg->db->sqldte($lp_in,'hltagrenddte'),
																			$this->co_reg->db->sqldat($lp_in,'hltagratr',false),	
                                     	$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
                                     	$this->co_reg->db->sqldat($lp_in,'sysdocclscod')
																		);
		$this->sysdata['sqltxt'] = 'HLT_AGR_DEF (?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		$this->chkError($lp_action, $lo_rs, $lp_out, '08|18');
		//		PRESTADORES. Se recuperan lista de prestadores por convenio
	 	if ( ($lp_action=='03' || $lp_action == '13') && $this->errcod==0 ) {
          $lo_agrprsmdl = $this->co_reg->load->model('hltagrprs');
          $lv_prm = array('vewfldflt' => '[~fltrow~]a.hltagrcod'.chr(9).'='.chr(9).chr(9).$this->data[$this->ID].chr(9).chr(9));
          $lo_rs = $lo_agrprsmdl->getList($lv_prm);
          $lp_out['hltagratrprs'] = $lo_rs;
      }
		
    return ($this->errcod==0?true:false);
	}
 
}
?>
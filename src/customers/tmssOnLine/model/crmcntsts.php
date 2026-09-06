<?php
final class crmcntsts extends tmssAction2 {
	function initialize(){ $this->ID = 'crmcntstscod';}

	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
    $this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                      $this->co_reg->db->sqldat($lp_in,'crmcntstscod'),
                                     	$this->co_reg->db->sqldat($lp_in,'crmcntstscodext'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntststxt'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntstscls'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntstspre'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntstspos'),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntstsatr',false),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntstsblc'),
                                      $this->co_reg->db->sqldat($lp_in,'crmcntstsblcexc', false),
																		);
    $this->sysdata['sqltxt'] = 'CRM_CNT_STS_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    
    if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}		

		return ($this->errcod==0?true:false);
	}
}
?>
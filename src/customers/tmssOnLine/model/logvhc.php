<?php
final class logvhc extends tmssAction2 {
	const OBJTYP = 'LOG_VHC';
  function initialize(){ $this->ID = 'vhccod'; }
	
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if(count($lp_dat)==0){ $lp_dat = $this->co_reg->request->post; }
    $lp_dat['vhcatr'] = html_entity_decode($lp_dat['logvhcatr']??'');
    return parent::save( $lp_dat, $lp_authCheck );
  } 
	
	// CALL SP. llamada a storedprocedure del modelo
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
    $this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
                                      $this->co_reg->db->sqldat($lp_in,'vhccod'),
                                      $this->co_reg->db->sqldat($lp_in,'vhccodext'),
                                      $this->co_reg->db->sqldat($lp_in,'vhctxt'),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                      $this->co_reg->db->sqldat($lp_in,'vhcclscod'),
                                      $this->co_reg->db->sqldat($lp_in,'vhcatr')
																		);
    $this->sysdata['sqltxt'] = 'LOG_VHC_DEF (?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		// si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
    return ($this->errcod==0?true:false);
	}
}
?>
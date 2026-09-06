<?php
final class slsprc extends tmssAction2 {
  const OBJTYP = 'SLS_PRC';
  function initialize(){ $this->ID = 'slsprclstcod'; }
	
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$lp_dat['slsprclstatr'] = '<slsprclsttyp>'.($lp_dat['slsprclsttyp']??'').'</slsprclsttyp>';
    return parent::save( $lp_dat, $lp_authCheck);    
  }  
	
  // DELETE. borra objeto
  function delete( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
    
    // UserExit BeforeDelete ----------------------------------------------------
    $lo_prvmdl = $this->co_reg->load->model('slsprc');
    $lo_prvmdl->load( array('slsprclstcod' => $this->data['slsprclstcod']) );
		$lo_clsmdl = $this->co_reg->load->model('sysdoccls');
		$lo_clsmdl->load(array('sysdocclscod'=>$this->data['sysdocclscod']), false);
    $lv_uexit = $this->co_reg->document->getTagValue($lo_clsmdl->sysdocclsatr,'uexit_beforedelete');
		$lv_prm = array('action'=>'DELETE','data'=>&$this->data, 'prv_data' => $lo_prvmdl);
    if ( $this->co_reg->document->callUserExit(strtolower($lv_uexit), $lv_prm) ) {
      $lv_ret = $this->co_reg->document->retUserExit;
      if (isset($lv_ret['errtyp']) && $lv_ret['errtyp']!='S') { 
        $this->errtyp = $lv_ret['errtyp'];
        $this->errcod = $lv_ret['errcod'];
        $this->errtxt = $lv_ret['errtxt'];
        return false; 
      }
    }
    // -----------------------------------------------------------------------
    
		parent::delete( $lp_dat,$lp_authCheck);
  }
	
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'slsprclstcod'), 
																			$this->co_reg->db->sqldat($lp_in,'slsprclstcodext'), 
																			$this->co_reg->db->sqldat($lp_in,'slsprclsttxt'), 
																			$this->co_reg->db->sqldat($lp_in,'curcod'), 
																			$this->co_reg->db->sqldat($lp_in,'slsprclstvercod'),
																			$this->co_reg->db->sqldte($lp_in,'slsprclststrdte'),
																			$this->co_reg->db->sqldte($lp_in,'slsprclstenddte'),
																			$this->co_reg->db->sqldat($lp_in,'slsprclstatr',false),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod')
																		);
		$this->sysdata['sqltxt'] = 'SLS_PRC_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
    
    return ($this->errcod==0?true:false);
	}	
}
?>
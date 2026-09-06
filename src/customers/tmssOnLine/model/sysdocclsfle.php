<?php
final class sysdocclsfle extends tmssAction2 {  
  function initialize(){ $this->ID = 'sysdocclsflecod'; }
  
  function save( $lp_dat=array(), $lp_authCheck=true ) {
		if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$this->data = $lp_dat;
		$lv_act = ( (isset($lp_dat[$this->ID]) && !empty($lp_dat[$this->ID])) ? ($lp_authCheck?'02':'12') : ($lp_authCheck?'01':'11') );
		$lo_out_data = array(); 
				
		// GRABADO. Llamo al grabado y chequeo error
		if(!$this->call_sp( $lv_act, $this->data, $lo_out_data ) ){return false;}
     
    return true;
	}

	//  CALL SP llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
                                     	$this->co_reg->db->sqldat($lp_in,'sysdocfle',false)
																		);
		$this->sysdata['sqltxt'] = 'SYS_DOC_CLS_FLE_DEF (?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		
    // si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
    
		return ($this->errcod==0?true:false);
	}
}
?>
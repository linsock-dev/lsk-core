<?php
final class stkmatlst extends tmssAction2 {
  const OBJTYP = 'STK_MAT_LST';
  function initialize(){ $this->ID = 'matlstcod'; }
  
  // CREATE. inicializa el objeto
  function create() {
    parent::create();
		$this->data['stkmatlstmat'] = array();
	}
  
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'matlstcod'), 
																			$this->co_reg->db->sqldat($lp_in,'matlstcodext',false), 
                                     	$this->co_reg->db->sqldat($lp_in,'matlsttxt',false), 
																			$this->co_reg->db->sqldat($lp_in,'matcod'), 
																			$this->co_reg->db->sqlnum($lp_in,'matqty'), 
																			$this->co_reg->db->sqldat($lp_in,'matuntcod'),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
                                      $this->co_reg->db->sqldat($lp_in,'stkmatlstmat', false)
																		);
		$this->sysdata['sqltxt'] = 'STK_MAT_LST_DEF (?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    
    //Si hubo error del recordset finalizar ejecucion
    if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
    
		//		M A T E R I A L E S
		if ( $lp_action=='03' || $lp_action=='13' ) {
			$lp_out['stkmatlstmat'] = json_decode( utf8_encode($lp_out['stkmatlstmat']??'[]'), true );
    }
		
		return ($this->errcod==0?true:false);
	}	
}
?>
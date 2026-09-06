<?php
final class slssvclqd extends tmssAction2 {
  function initialize(){ $this->ID = 'slssvclqdcod'; }
  
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }		
		$lp_dat['slssvclqdatr001']= '<strdte>'.($lp_dat['slssvclqdstrdte']??'').'</strdte>'.
																'<enddte>'.($lp_dat['slssvclqdenddte']??'').'</enddte>';
		return parent::save( $lp_dat, $lp_authCheck );
  }  
	
  // UPDATETOTAL. actualiza el total de cabecera del documento basado en los documentos asignados
  function updateTotal( $lp_dat=array() ) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( '05', $this->data, $this->data );
  }
	
  // ACCOUNTING. contabiliza el documento
  function accounting( $lp_dat=array(), $lp_authCheck=true ) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( ($lp_authCheck?'09':'19'), $this->data, $this->data );
  }	
		
	//  CALL SP.  llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
															$this->co_reg->db->sqldat($lp_in,'slssvclqdcod'), 
															$this->co_reg->db->sqldat($lp_in,'slssvclqdtxt'), 
															$this->co_reg->db->sqldte($lp_in,'slssvclqddte'), 
															$this->co_reg->db->sqldte($lp_in,'slssvclqdstrdte'), 
															$this->co_reg->db->sqldte($lp_in,'slssvclqdenddte'), 
															$this->co_reg->db->sqldat($lp_in,'cuscod'),
															//$this->co_reg->db->sqldat($lp_in['opnsrvids'])?$lp_in['opnsrvids']:''),
															//$this->co_reg->db->sqldat($lp_in['opnexpids'])?$lp_in['opnexpids']:''),
															$this->co_reg->db->sqldat($lp_in,'docsts'),
															$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
															$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
															$this->co_reg->db->sqldat($lp_in,'slssvclqdatr001',false),
															$this->co_reg->db->sqldat($lp_in,'sysdocreccod')
														);
		$this->sysdata['sqltxt'] = 'SLS_SVC_LQD_DEF (?,?,?,?,?,?,?,?,?,null,null,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}

    return ($this->errcod==0?true:false);
	}
}
?>
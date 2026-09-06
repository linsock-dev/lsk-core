<?php
final class hltprslqd extends tmssAction2 {
  function initialize(){ $this->ID = 'hltprslqdcod'; }
  
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $lp_dat['hltprslqdatr001']= '<strdte>'.$lp_dat['hltprslqdstrdte'].'</strdte>'.
																'<enddte>'.$lp_dat['hltprslqdenddte'].'</enddte>';
    return parent::save( $lp_dat, $lp_authCheck );
  }  
	
	// GET OPEN SERVICES. obtiene la lista de gastos no liquidados
  function getOpenServices( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if($lo_vew==null) {$lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '23', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
  // GET OPEN EXPENSES. obtiene la lista de gastos no liquidados
  function getOpenExpenses( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '24', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
	// GET SERVICES. obtiene la lista de servicios liquidados
  function getServices( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '33', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
  // GET EXPENSES. obtiene la lista de gastos liquidados
  function getExpenses( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '34', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
	//  CALL SP.  llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
															$this->co_reg->db->sqldat($lp_in,'hltprslqdcod'), 
															$this->co_reg->db->sqldat($lp_in,'hltprslqdtxt'), 
															$this->co_reg->db->sqldte($lp_in,'hltprslqddte'), 
															$this->co_reg->db->sqldte($lp_in,'hltprslqdstrdte'), 
															$this->co_reg->db->sqldte($lp_in,'hltprslqdenddte'), 
															$this->co_reg->db->sqldat($lp_in,'prscod'),
															$this->co_reg->db->sqldat($lp_in,'hltprslqdids001'),
															$this->co_reg->db->sqldat($lp_in,'hltprslqdids002'),
															$this->co_reg->db->sqldat($lp_in,'docsts'),
															$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
															$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
															$this->co_reg->db->sqldat($lp_in,'hltprslqdatr001'),
															$this->co_reg->db->sqldat($lp_in,'cuscod')
														);
		$this->sysdata['sqltxt'] = 'HLT_PRS_LQD_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,null,null,null,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|23|24|33|34')){return false;}
    
		return ($this->errcod==0?true:false);
	}	
}
?>
<?php
final class edutchlqd extends tmssAction2 {
  function initialize(){ $this->ID = 'edutchlqdcod'; }
	
  // ACCOUNTING. contabiliza el documento
  function accounting( $lp_dat=array(), $lp_authCheck=true ) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( ($lp_authCheck?'09':'19'), $this->data, $lo_out_data );
  }
	
	// GET OPEN SERVICES. obtiene la lista de gastos no liquidados
  function getOpenServices( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if($lo_vew==null) {$lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '33', $lp_prm, $lo_out_data ) ) {
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
		if ( $this->call_sp( '34', $lp_prm, $lo_out_data ) ) {
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
		if ( $this->call_sp( '43', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
  // GET EXPENSES. obtiene la lista de gastos liquidados
  function getExpenses( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '44', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
	// CALL SP. llamada a storedprocedure del modelo
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                     $this->co_reg->db->sqldat($lp_in,'edutchlqdcod'),
                                     $this->co_reg->db->sqldat($lp_in,'edutchlqdtxt'),
                                     $this->co_reg->db->sqldte($lp_in,'edutchlqddte'),
                                     $this->co_reg->db->sqldte($lp_in,'edutchlqdstrdte'),
                                     $this->co_reg->db->sqldte($lp_in,'edutchlqdenddte'),
                                     $this->co_reg->db->sqldat($lp_in,'tchcod'),
                                     $this->co_reg->db->sqldat($lp_in,'edutchlqdids001'),
                                     $this->co_reg->db->sqldat($lp_in,'edutchlqdids002'),
                                     $this->co_reg->db->sqldat($lp_in,'docsts'),
                                     $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                     $this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                     $this->co_reg->db->sqldat($lp_in,'edutchlqdatr001')
														);
		$this->sysdata['sqltxt'] = 'EDU_TCH_LQD_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
	
    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|33|34|43|44')){return false;}

    return ($this->errcod==0?true:false);
	}
}
?>
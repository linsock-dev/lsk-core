<?php
final class edulqd extends tmssAction2 {
  function initialize(){ $this->ID = 'edulqdcod'; }

	// ACCOUNTING. contabiliza el documento
  function accounting( $lp_dat=array() , $lp_authCheck=true) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( ($lp_authCheck?'09':'19'), $this->data, $lo_out_data );
  }
	
  // UPDATETOTAL. actualiza el total de cabecera del documento basado en los documentos asignados
  function updateTotal( $lp_dat=array() ) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( '05', $this->data, $lo_out_data );
  }
	
	// GET OPEN SERVICES. obtiene la lista de gastos no liquidados
  function getOpenServices( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if($lo_vew==null) {$lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '53', $lp_prm, $lo_out_data ) ) {
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
		if ( $this->call_sp( '54', $lp_prm, $lo_out_data ) ) {
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
  function getExpenses( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
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
		
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                      $this->co_reg->db->sqldat($lp_in,'edulqdcod'),
                                      $this->co_reg->db->sqldat($lp_in,'edulqdtxt'),
                                      $this->co_reg->db->sqldte($lp_in,'edulqddte'),
                                      $this->co_reg->db->sqldte($lp_in,'edulqdstrdte'),
                                     	$this->co_reg->db->sqldte($lp_in,'edulqdenddte'),
                                      $this->co_reg->db->sqldat($lp_in,'cuscod'),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                      $this->co_reg->db->sqldat($lp_in,'edulqdatr001'),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocreccod')
														);
		$this->sysdata['sqltxt'] = 'EDU_LQD_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    
    $this->chkError($lp_action, $lo_rs, $lp_out, '08|18|53|54|43|44');
		return ($this->errcod==0?true:false);
  }
}
?>
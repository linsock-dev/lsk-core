<?php
final class hltplndte extends tmssAction2 {
  
	function initialize(){ $this->ID = 'plndteid'; }
  function save( $lp_dat=array(), $lp_authcheck=true) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $lv_act = '02';
    
    // - recargo los ultimos tags definidos dentro del modelo 
    // - se mantienen los datos de los tags independientemente de donde se instancie el modelo 
    // - los datos se mantienen en lv_plndteatrcur
    $lv_plndteatrcur = '';
    $this->load( array($this->ID => $lp_dat[$this->ID], 'plnid' => $lp_dat['plnid']) );
    $lv_plndteatrcur = (isset($this->data['plndteatr'])) ? $this->data['plndteatr'] : '';
    
    $this->data = $lp_dat;
    $this->data['plndteatr'] = '<usricn>'.( isset($this->data['hltplndteatrusricn']) ? $this->data['hltplndteatrusricn'] : $this->co_reg->document->getTagValue($lv_plndteatrcur, 'usricn') ).'</usricn>'.
															 '<dayful>'.( isset($this->data['hltplndteatrdayful']) ? ($this->data['hltplndteatrdayful']=='on' || $this->data['hltplndteatrdayful']=='1' ? 'X' : '') : $this->co_reg->document->getTagValue($lv_plndteatrcur, 'dayful') ).'</dayful>'.
      												 '<plntrnrec>'.( isset($this->data['hltplndteatrplntrnrec']) ? $this->data['hltplndteatrplntrnrec'] : $this->co_reg->document->getTagValue($lv_plndteatrcur, 'plntrnrec') ).'</plntrnrec>'.
      												 '<plntrncal>'.( isset($this->data['hltplndteatrplntrncal']) ? $this->data['hltplndteatrplntrncal'] : $this->co_reg->document->getTagValue($lv_plndteatrcur, 'plntrncal') ).'</plntrncal>'.
      												 '<plntrnatn>'.( isset($this->data['hltplndteatrplntrnatn']) ? $this->data['hltplndteatrplntrnatn'] : $this->co_reg->document->getTagValue($lv_plndteatrcur, 'plntrnatn') ).'</plntrnatn>';
		$lo_out_data = array();
		return $this->call_sp( $lv_act, $this->data, $lo_out_data );
  }
  // CONFIRM. confirma/notifica planificación
  function confirm( $lp_key ) {
		$this->data['plnid'] = $lp_key['plnid'];
		$this->data['plndteid'] = $lp_key['plndteid'];
		$this->data['plncnfdte'] = ($lp_key['plncnfdte']??'');	// fecha confirmación
		$this->data['prsntfdte'] = ($lp_key['prsntfdte']??'');	// fecha notificación prstador
		$this->data['patntfdte'] = ($lp_key['patntfdte']??'');	// fecha notificación paciente
		$lo_out_data = array();
		return $this->call_sp( '07', $this->data, $this->data );
  }
	
	//  CALL SP.  llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
                                     $this->co_reg->db->sqldat($lp_in, 'plnid'),
                                     $this->co_reg->db->sqldat($lp_in, 'plndteid'),
                                     $this->co_reg->db->sqldte($lp_in, 'plndte'),
                                     $this->co_reg->db->sqldte($lp_in, 'plndteto'),
                                     $this->co_reg->db->sqldte($lp_in, 'plninbdte', 'datetime'),
                                     $this->co_reg->db->sqldte($lp_in, 'plnoutdte', 'datetime'),
                                     $this->co_reg->db->sqldat($lp_in, 'plnqty'),
                                     $this->co_reg->db->sqldat($lp_in, 'plncmt'),
                                     $this->co_reg->db->sqldat($lp_in, 'docsts'),
                                     $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                     $this->co_reg->db->sqldat($lp_in, 'grpserid'),
                                     $this->co_reg->db->sqldte($lp_in, 'plncnfdte', 'datetime'),
                                     $this->co_reg->db->sqldte($lp_in, 'prsntfdte', 'datetime'),
                                     $this->co_reg->db->sqldte($lp_in, 'patntfdte', 'datetime'),
                                     $this->co_reg->db->sqldat($lp_in, 'plndteatr', false)
																		);
    
		$this->sysdata['sqltxt'] = 'HLT_PLN_DTE_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}

		return ($this->errcod==0?true:false);
	}
}
?>
<?php
final class hltprslqdaut extends tmssAction2 {
  function initialize(){ $this->ID = 'hltprslqdgrpcod'; }
  
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['bnk'] = $this->co_reg->load->model('grldatbnk');
	}
	
	// GET OPEN LIQUIDATION. obtiene la lista de liquidaciones del período por prestador 
  function getOpenLiquidations( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if($lo_vew==null) {$lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '10', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
	// GET LIQUIDATION. obtiene la lista de liquidaciones del grupo
  function getLiquidations( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '21', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
	//  CALL SP.  llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
															$this->co_reg->db->sqldat($lp_in,'hltprslqdgrpcod'),
															$this->co_reg->db->sqldat($lp_in,'hltprslqdgrptxt'),
															$this->co_reg->db->sqldte($lp_in,'hltprslqdgrpdte'),
															$this->co_reg->db->sqldte($lp_in,'hltprslqdgrpstrdte'),
															$this->co_reg->db->sqldte($lp_in,'hltprslqdgrpenddte'),
															$this->co_reg->db->sqldat($lp_in,'paymthcod'),
															$this->co_reg->db->sqldat($lp_in,'docsts'),
															$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                              $this->co_reg->db->sqldat($lp_in,'sysdocclscodprs'),
															$this->co_reg->db->sqldat($lp_in,'hltprslqdids'),
															$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
															$this->co_reg->db->sqldat($lp_in,'cuscod')
														);
		$this->sysdata['sqltxt'] = 'HLT_PRS_LQD_AUT_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|10|21')){return false;}

    return ($this->errcod==0?true:false);
	}	
}
?>
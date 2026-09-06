<?php
final class hltpatcrepln extends tmssAction2 {
  function initialize(){ $this->ID = 'patcreplncod'; }
    
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['patcreplnmat'] = array();
	}
	
  // GET PATIENT LIST. devuelve recordset de objetos (pacientes)
  function getPatientsList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '08', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
  // GET HISTORY. lista el historial de plan de cuidados del paciente
  function getHistory( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		
		$lp_vewopt['vewfldflt'] = ($lp_vewopt['vewfldflt']??'');
		$lp_vewopt['vewfldflt'].= '[~fltrow~]p.patcod'.chr(9).'='.chr(9).chr(9).$lp_prm['patcod'].chr(9).chr(9);
		
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '08', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
	}
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'patcreplncod'), 
																			$this->co_reg->db->sqldat($lp_in,'patcod'), 
																			$this->co_reg->db->sqldte($lp_in,'patcreplnstrdte'), 
																			$this->co_reg->db->sqldte($lp_in,'patcreplnenddte'), 
																			$this->co_reg->db->sqldat($lp_in,'patcreplnaut',false), 
																			$this->co_reg->db->sqldat($lp_in,'patcreplncmt',false), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																		);
		$this->sysdata['sqltxt'] = 'HLT_PAT_CRE_PLN_DEF (?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
    
		// PLAN DE CUIDADOS - MATERIALES
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_creplnmatmdl = $this->co_reg->load->model('hltpatcreplnmat');
			$lo_creplnmat_rs = array();
			$lv_prm = array('vewfldflt' =>'[~fltrow~]p.patcreplncod'.chr(9).'='.chr(9).chr(9).$this->data[$this->ID].chr(9).chr(9));
			$lp_out['patcreplnmat'] = $lo_creplnmatmdl->getList($lv_prm);
		}
		
		return ($this->errcod==0?true:false);
	}
}
?>
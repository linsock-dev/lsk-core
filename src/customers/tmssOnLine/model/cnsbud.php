<?php
final class cnsbud extends tmssAction2 {
  function initialize() { $this->ID = 'budcod'; }
	
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
    $this->data['budtsk'] = array();
  }
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
																			$this->co_reg->db->sqldat($lp_in,'budcod'),
																			$this->co_reg->db->sqldat($lp_in,'budtxt'),
																			$this->co_reg->db->sqldat($lp_in,'stecod'),
																			$this->co_reg->db->sqldat($lp_in,'budver'),
																			$this->co_reg->db->sqldat($lp_in,'budtyp'),
																			$this->co_reg->db->sqldte($lp_in,'buddte'),
																			$this->co_reg->db->sqldat($lp_in,'budcmt',false),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'buddat',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod')
																		);
		$this->sysdata['sqltxt'] = 'CNS_BUD_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
		//		M A T
		if ( $lp_action=='03' || $lp_action=='13' && $this->errcod==0 ) {
			$lo_matmdl = $this->co_reg->load->model('cnsbudmat');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]bm.budcod'.chr(9).'='.chr(9).chr(9).$lp_in[$this->ID].chr(9).chr(9),
											'vewfldord' =>'bm.budmatrow');
			$lp_out['budtsk'] = $lo_matmdl->getList( $lv_prm );
		}
		
		return ($this->errcod==0?true:false);
	}		
}
?>
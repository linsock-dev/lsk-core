<?php
final class edumod extends tmssAction2 {
  function initialize(){ $this->ID = 'edumodcod'; }

	function getData(){ 
  	$lv_ret = array();
		foreach($this->data as $lv_key=>$lv_val) {
			if ( is_a($lv_val, 'DateTime') ) {
				$lv_ret[$lv_key] = $lv_val->format('d/m/Y');
			} else {
				$lv_ret[$lv_key] = $lv_val;
			}
		}
		return $lv_ret;
  }
	
	// CREATE - inicializa el objeto
	function create() {
		parent::create();
		$this->data['edumodpln'] = array();
	}

	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'edumodcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'edumodcodext'),
                                     	$this->co_reg->db->sqldat($lp_in,'edumodtxt'),
                                     	$this->co_reg->db->sqldat($lp_in,'cuscod'),
                                     	$this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                     	$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                     	$this->co_reg->db->sqldat($lp_in,'edumodatr')
																		);
		$this->sysdata['sqltxt'] = 'EDU_MOD_DEF (?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		$this->chkError($lp_action, $lo_rs, $lp_out, '08|18');
		//		C O N T E N I D O
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_plnmdl = $this->co_reg->load->model('edumodpln');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]p.edumodcod'.chr(9).'='.chr(9).chr(9).$lp_in['edumodcod'].chr(9).chr(9));
			$lp_out['edumodpln'] = $lo_plnmdl->getList( $lv_prm ); 
		}
		return ($this->errcod==0?true:false);
	}	
}
?>
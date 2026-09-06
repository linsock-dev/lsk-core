<?php 
final class buyexptyp extends tmssAction2 {
	const OBJTYP = 'BUY_EXT';
  function initialize(){ $this->ID = 'buyexptypcod'; }
	
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['acc'] = $this->co_reg->load->model('grldatacc');
	}
	
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'buyexptypcod'),
                                      $this->co_reg->db->sqldat($lp_in,'buyexptypcodext'),
                                      $this->co_reg->db->sqldat($lp_in,'buyexptyptxt'),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                      $this->co_reg->db->sqldat($lp_in,'finacccod')
																		);
		$this->sysdata['sqltxt'] = 'BUY_EXP_TYP_DEF (?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		// si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
		//	A C C
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03' || $lp_action=='11' || $lp_action=='12' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_accmdl = $this->co_reg->load->model('grldatacc');
			$lp_in['accsrctyp'] = $this->OBJTYP;
			$lp_in['accsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_accmdl->load( $lp_in );
				$lp_out['acc'] = $lo_accmdl;
			} else if( $lo_accmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_accmdl->errcod;
				$this->errtxt = $lo_accmdl->errtxt;
			}
		}
		
		return ($this->errcod==0?true:false);
	}	
}
?>
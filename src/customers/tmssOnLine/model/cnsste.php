<?php
final class cnsste extends tmssAction2 {
	const OBJTYP = 'CNS_STE';
	function initialize(){ $this->ID = 'stecod'; }
		
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['adr'] = $this->co_reg->load->model('grldatadr');
	}	 
	
	//  CALL SP.  llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'stecod'), 
																			$this->co_reg->db->sqldat($lp_in,'stecodext'), 
																			$this->co_reg->db->sqldat($lp_in,'stetxt'), 
																			$this->co_reg->db->sqldat($lp_in,'cuscod'),
																			$this->co_reg->db->sqldat($lp_in,'stecmt',false),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldat($lp_in,'cnssteatratr',false)
																		);
		$this->sysdata['sqltxt'] = 'CNS_STE_DEF (?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}

		//		A D R
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03' || $lp_action=='11' || $lp_action=='12' || $lp_action=='13' ) && $this->errcod==0 ) {
			$this->lo_adrmdl = $this->co_reg->load->model('grldatadr');
			$lp_in['adrsrctyp'] = self::OBJTYP;
			$lp_in['adrsrccod'] = $this->data[$this->ID];
			$lp_in['adrnme001'] = ($lp_in['stetxt']??'');
			if ($lp_action=='03' || $lp_action=='13') {
				$this->lo_adrmdl->load( $lp_in );
				$lp_out['adr'] = $this->lo_adrmdl;
			} else if ( $this->lo_adrmdl->save( $lp_in )==false ) {
				$this->errcod = $this->lo_adrmdl->errcod;
				$this->errtxt = $this->lo_adrmdl->errtxt;
			}
		}
		
		return ($this->errcod==0?true:false);
	}	
}
?>
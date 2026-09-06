<?php
final class stkstrloc extends tmssAction2 {
	const OBJTYP = 'STK_STL';
  function initialize(){ $this->ID = 'strloccod'; }
		
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['adr'] = $this->co_reg->load->model('grldatadr');
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $lp_dat['adrnme001'] = ($lp_dat['strloctxt']??'');
    return parent::save( $lp_dat, $lp_authCheck );
  }  
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'strloccod'), 
																			$this->co_reg->db->sqldat($lp_in,'strloccodext'), 
																			$this->co_reg->db->sqldat($lp_in,'strloctxt'), 
																			$this->co_reg->db->sqldat($lp_in,'strloccmt'), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod')
																		);
		$this->sysdata['sqltxt'] = 'STK_STR_LOC_DEF (?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
		//		A D R
		if ( ($lp_action=='01' || $lp_action=='11' || $lp_action=='02' || $lp_action=='12' || $lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_adrmdl = $this->co_reg->load->model('grldatadr');
			$lp_in['adrsrctyp'] = self::OBJTYP;
			$lp_in['adrsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_adrmdl->load( $lp_in );
				$lp_out['adr'] = $lo_adrmdl;
			} else if ( $lo_adrmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_adrmdl->errcod;
				$this->errtxt = $lo_adrmdl->errtxt;
			} else {
				$lp_out['adrnum']=$lo_adrmdl->adrnum;
			}
		}
		
		return ($this->errcod==0?true:false);		
	}	
}
?>
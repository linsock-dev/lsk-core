<?php
final class logdrv extends tmssAction2 {
  const OBJTYP = 'LOG_DRV';
  function initialize(){ $this->ID = 'drvcod'; }
	
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['adr'] = $this->co_reg->load->model('grldatadr');
		$this->data['tax'] = $this->co_reg->load->model('grldattax');
		$this->data['bnk'] = $this->co_reg->load->model('grldatbnk');
		$this->data['acc'] = $this->co_reg->load->model('grldatacc');
		$this->data['per'] = $this->co_reg->load->model('grldatper');
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if(count($lp_dat)==0){ $lp_dat = $this->co_reg->request->post; }
		$lp_dat['adrnme001'] = ($lp_dat['drvtxt']??'');
    return parent::save( $lp_dat, $lp_authCheck );
  }
	
	// CALL SP. llamada a storedprocedure del modelo
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                    $this->co_reg->db->sqldat($lp_in,'drvcod'),
																		$this->co_reg->db->sqldat($lp_in,'drvcodext'),
                                    $this->co_reg->db->sqldat($lp_in,'drvtxt'),
                                    $this->co_reg->db->sqldte($lp_in,'drvinbdte'), 
                                    $this->co_reg->db->sqldte($lp_in,'drvoutdte'),
                                    $this->co_reg->db->sqldat($lp_in,'drvoutcmt'),
                                    $this->co_reg->db->sqldte($lp_in,'drvbrndte'),
                                    $this->co_reg->db->sqldat($lp_in,'drvniknme'),
                                    $this->co_reg->db->sqldat($lp_in,'drvnat'),
																		$this->co_reg->db->sqldat($lp_in,'drvcmt'),
																		$this->co_reg->db->sqldat($lp_in,'docsts'),
																		$this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                    $this->co_reg->db->sqldat($lp_in,'sysdocclscod')
																	);
		$this->sysdata['sqltxt'] = 'LOG_DRV_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
   
    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
    
		// DIRECCION - ADR
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03' || $lp_action=='11' || $lp_action=='12' || $lp_action=='13' ) && $this->errcod==0 ) {
			$lo_adrmdl = $this->co_reg->load->model('grldatadr');
			$lp_in['adrsrctyp'] = self::OBJTYP;
			$lp_in['adrsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03'  || $lp_action=='13') {
				$lo_adrmdl->load( $lp_in );
				$lp_out['adr'] = $lo_adrmdl;
			} else if ( $lo_adrmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_adrmdl->errcod;
				$this->errtxt = $lo_adrmdl->errtxt;
			}
		}

		// IMPUESTOS - TAX
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03' || $lp_action=='11' || $lp_action=='12' || $lp_action=='13' ) && $this->errcod==0 ) {
			$lo_taxmdl = $this->co_reg->load->model('grldattax');
			$lp_in['taxsrctyp'] = self::OBJTYP;
			$lp_in['taxsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_taxmdl->load( $lp_in );
				$lp_out['tax'] = $lo_taxmdl;
			} else if( $lo_taxmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_taxmdl->errcod;
				$this->errtxt = $lo_taxmdl->errtxt;
			}
		}
		
		// BANCO - BNK
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03' || $lp_action=='11' || $lp_action=='12' || $lp_action=='13' ) && $this->errcod==0 ) {
			$lo_bnkmdl = $this->co_reg->load->model('grldatbnk');
			$lp_in['bnksrctyp'] = self::OBJTYP;
			$lp_in['bnksrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_bnkmdl->load( $lp_in );
				$lp_out['bnk'] = $lo_bnkmdl;
			} else if( $lo_bnkmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_bnkmdl->errcod;
				$this->errtxt = $lo_bnkmdl->errtxt;
			}
		}
		
		// CUENTAS - ACC
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03' || $lp_action=='11' || $lp_action=='12' || $lp_action=='13' ) && $this->errcod==0 ) {
			$lo_accmdl = $this->co_reg->load->model('grldatacc');
			$lp_in['accsrctyp'] = self::OBJTYP;
			$lp_in['accsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_accmdl->load( $lp_in );
				$lp_out['acc'] = $this->lo_accmdl;
			} else if( $lo_accmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_accmdl->errcod;
				$this->errtxt = $lo_accmdl->errtxt;
			}
		}
    
    // DATOS PERSONALES - PER
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03' || $lp_action=='11' || $lp_action=='12' || $lp_action=='13' ) && $this->errcod==0 ) {
			$lo_permdl = $this->co_reg->load->model('grldatper');
			$lp_in['persrctyp'] = self::OBJTYP;
			$lp_in['persrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_permdl->load( $lp_in );
				$lp_out['per'] = $lo_permdl;
			} else if( $lo_permdl->save( $lp_in )==false ) {
				$this->errcod = $lo_permdl->errcod;
				$this->errtxt = $lo_permdl->errtxt;
			}
		}
		
		return ($this->errcod==0?true:false);
	}	
}
?>
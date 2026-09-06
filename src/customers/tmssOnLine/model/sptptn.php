<?php
final class sptptn extends tmssAction2 { 
  const OBJTYP = 'SPT_PTN';
	function initialize(){ $this->ID = 'ptncod'; }
	
	// CREATE. inicializa el objeto
	function create() {
		parent::create();
    $this->data['sptptnact'] = array();
    $this->data['sptptntrf'] = array();
		$this->data['adr'] = $this->co_reg->load->model('grldatadr');
		$this->data['tax'] = $this->co_reg->load->model('grldattax');
		$this->data['bnk'] = $this->co_reg->load->model('grldatbnk');
		$this->data['per'] = $this->co_reg->load->model('grldatper');
	}
  
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $lp_dat['adrnme001'] = ($lp_dat['ptntxt']??'');
    return parent::save($lp_dat, $lp_authCheck);
  }
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
                                    $this->co_reg->db->sqldat($lp_in,'ptncod'),
                                    $this->co_reg->db->sqldat($lp_in,'ptncodext'),
                                    $this->co_reg->db->sqldat($lp_in,'ptntxt'),
                                    $this->co_reg->db->sqldte($lp_in,'ptninbdte'),
                                    $this->co_reg->db->sqldat($lp_in,'ptncatcod'),
                                    $this->co_reg->db->sqldat($lp_in,'ptncrdsts'),
                                    $this->co_reg->db->sqldte($lp_in,'ptncrddte'),
                                    $this->co_reg->db->sqldat($lp_in,'ptncmt'),
                                    $this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                    $this->co_reg->db->sqldat($lp_in,'docsts'),
                                    $this->co_reg->db->sqldat($this->sysdata,'view_options', false)      
																	);
		$this->sysdata['sqltxt'] = 'SPT_PTN_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}

		//		A C T
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_ptnact = $this->co_reg->load->model('sptptnact');		
			$lv_prm = array('vewfldflt' =>'[~fltrow~]d.ptncod'.chr(9).'='.chr(9).chr(9).$this->data[$this->ID].chr(9).chr(9));
			$lp_out['sptptnact'] = $lo_ptnact->getList($lv_prm);
		}
    
    if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_ptntrf = $this->co_reg->load->model('sptptntrf');		
			$lv_prm = array('vewfldflt' =>'[~fltrow~]ptncod'.chr(9).'='.chr(9).chr(9).$this->data[$this->ID].chr(9).chr(9));
			$lp_out['sptptntrf'] = $lo_ptntrf->getList($lv_prm);
		}

		//    A D R
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03' || $lp_action=='11' || $lp_action=='12' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_adrmdl = $this->co_reg->load->model('grldatadr');
			$lp_in['adrsrctyp'] = self::OBJTYP;
			$lp_in['adrsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_adrmdl->load( $lp_in );
				$lp_out['adr'] = $lo_adrmdl;
			} else if ( $lo_adrmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_adrmdl->errcod;
				$this->errtxt = $lo_adrmdl->errtxt;
			}
		}

		//    T A X
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03' || $lp_action=='11' || $lp_action=='12' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_taxmdl = $this->co_reg->load->model('grldattax');
			$lp_in['taxsrctyp'] = self::OBJTYP;
			$lp_in['taxsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03'|| $lp_action=='13') {
				$lo_taxmdl->load( $lp_in );
				$lp_out['tax'] = $lo_taxmdl;
			} else if( $lo_taxmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_taxmdl->errcod;
				$this->errtxt = $lo_taxmdl->errtxt;
			}
		}
    
		//    B N K
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03' || $lp_action=='11' || $lp_action=='12' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_bnkmdl = $this->co_reg->load->model('grldatbnk');
			$lp_in['bnksrctyp'] = self::OBJTYP;
			$lp_in['bnksrccod'] = $this->data[$this->ID];
			if ($lp_action=='03'|| $lp_action=='13') {
				$lo_bnkmdl->load( $lp_in );
				$lp_out['bnk'] = $lo_bnkmdl;
			} else if( $lo_bnkmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_bnkmdl->errcod;
				$this->errtxt = $lo_bnkmdl->errtxt;
			}
		}

		//    P E R
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03' || $lp_action=='11' || $lp_action=='12' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_permdl = $this->co_reg->load->model('grldatper');
			$lp_in['persrctyp'] = self::OBJTYP;
			$lp_in['persrccod'] = $this->data[$this->ID];
			if ($lp_action=='03'|| $lp_action=='13') {
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
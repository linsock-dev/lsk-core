<?php
final class hhremp extends tmssAction2 {
  const OBJTYP = 'HHR_EMP';
  function initialize(){ $this->ID = 'hhrempcod'; }
	
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['adr'] = $this->co_reg->load->model('grldatadr');
		$this->data['tax'] = $this->co_reg->load->model('grldattax');
		$this->data['bnk'] = $this->co_reg->load->model('grldatbnk');
		$this->data['per'] = $this->co_reg->load->model('grldatper');
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck = true ) {
    if(count($lp_dat)==0){ $lp_dat = $this->co_reg->request->post; }
		$lp_dat['adrnme001'] = $lp_dat['hhremptxt'];
   	return parent::save($lp_dat, $lp_authCheck);
  }
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																		$this->co_reg->db->sqldat($lp_in,'hhrempcod'), 
																		$this->co_reg->db->sqldat($lp_in,'hhrempcnthrs'), 
																		$this->co_reg->db->sqldat($lp_in,'hhrempcmt'), 
																		$this->co_reg->db->sqldat($lp_in,'docsts'), 
																		$this->co_reg->db->sqldat($lp_in,'hhrempcodext'), 
																		$this->co_reg->db->sqldat($lp_in,'lndtwngrpcod'), 
																		$this->co_reg->db->sqldat($lp_in,'hhremptxt'), 
																		$this->co_reg->db->sqldte($lp_in,'hhrempdte'), 
																		$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																		$this->co_reg->db->sqldat($lp_in,'hhrempniknme'), 
																		$this->co_reg->db->sqldte($lp_in,'hhrempinbdte'), 
																		$this->co_reg->db->sqldte($lp_in,'hhrempoutdte'), 
																		$this->co_reg->db->sqldat($lp_in,'hhrempoutcmt'), 
																		$this->co_reg->db->sqldat($lp_in,'hhrempnat'), 
																		$this->co_reg->db->sqldte($lp_in,'hhrempbrndte'), 
																		$this->co_reg->db->sqldat($lp_in,'hhrempttl'), 
																		$this->co_reg->db->sqldat($lp_in,'hhrempothstd'), 
																		$this->co_reg->db->sqldat($lp_in,'hhrempjobhst'), 
																		$this->co_reg->db->sqldat($lp_in,'sysdocclscod')
																	);
		$this->sysdata['sqltxt'] = 'HHR_EMP_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
    //Un array para chequear las distintas actividades que necesitan de otros modelos
    $lv_actarr = array('01', '11', '02', '12', '03', '13');
    $lv_fndval = in_array($lp_action,$lv_actarr);
    
		//    A D R
		if ( $lv_fndval && $this->errcod==0 ) {
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
		if ($lv_fndval && $this->errcod==0 ) {
			$lo_taxmdl = $this->co_reg->load->model('grldattax');
			$lp_in['taxsrctyp'] = self::OBJTYP;
			$lp_in['taxsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_taxmdl->load( $lp_in);
        $lp_out['tax'] = $lo_taxmdl;
			} else if( $lo_taxmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_taxmdl->errcod;
				$this->errtxt = $lo_taxmdl->errtxt;
			}
		}
    
		//    B N K
		if ( $lv_fndval && $this->errcod==0 ) {
			$lo_bnkmdl = $this->co_reg->load->model('grldatbnk');
			$lp_in['bnksrctyp'] = self::OBJTYP;
			$lp_in['bnksrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_bnkmdl->load( $lp_in);
				$lp_out['bnk'] = $lo_bnkmdl;
			} else if( $lo_bnkmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_bnkmdl->errcod;
				$this->errtxt = $lo_bnkmdl->errtxt;
			}
		}
		
		//    P E R
		if ( $lv_fndval && $this->errcod==0 ) {
			$lo_permdl = $this->co_reg->load->model('grldatper');
			$lp_in['persrctyp'] = self::OBJTYP;
			$lp_in['persrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13' ) {
				$lo_permdl->load( $lp_in);
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
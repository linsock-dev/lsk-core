<?php
final class slsgrp extends tmssAction2 {
	const OBJTYP = 'SLS_GRP';
  function initialize(){ $this->ID = 'slsgrpcod'; }
	
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['adr'] = $this->co_reg->load->model('grldatadr');
		$this->data['tax'] = $this->co_reg->load->model('grldattax');
		$this->data['bnk'] = $this->co_reg->load->model('grldatbnk');
		$this->data['acc'] = $this->co_reg->load->model('grldatacc');
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true  ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$lp_dat['adrnme001'] = ($lp_dat['slsgrptxt']??'');
    return parent::save( $lp_dat, $lp_authCheck );
  }  
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
																			$this->co_reg->db->sqldat($lp_in,'slsgrpcod'),
																			$this->co_reg->db->sqldat($lp_in,'slsgrpcodext'),
																			$this->co_reg->db->sqldat($lp_in,'slsgrptxt'), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod')
																		);
		$this->sysdata['sqltxt'] = 'SLS_GRP_DEF (?,?,?,?,?,?,?,?,?)';
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
				$lp_out['adr']=$lo_adrmdl->adrnum;
			}
		}
		
		//		T A X
		if ( ($lp_action=='01' || $lp_action=='11' || $lp_action=='02' || $lp_action=='12' || $lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_taxmdl = $this->co_reg->load->model('grldattax');
			$lp_in['taxsrctyp'] = self::OBJTYP;
			$lp_in['taxsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_taxmdl->load( $lp_in );
				$lp_out['tax'] = $lo_taxmdl;
			} else if( $lo_taxmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_taxmdl->errcod;
				$this->errtxt = $lo_taxmdl->errtxt;
			} else {
				$lp_out['tax']=$lo_taxmdl;
			}
		}
		
		//		B N K
		if ( ($lp_action=='01' || $lp_action=='11' || $lp_action=='02' || $lp_action=='12' || $lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_bnkmdl = $this->co_reg->load->model('grldatbnk');
			$lp_in['bnksrctyp'] = self::OBJTYP;
			$lp_in['bnksrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_bnkmdl->load( $lp_in );
				$lp_out['bnk'] = $lo_bnkmdl;
			} else if( $lo_bnkmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_bnkmdl->errcod;
				$this->errtxt = $lo_bnkmdl->errtxt;
			} else {
				$lp_out['bnk']=$lo_bnkmdl;
			}
		}
		
		//		A C C
		if ( ($lp_action=='01' || $lp_action=='11' || $lp_action=='02' || $lp_action=='12' || $lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_accmdl = $this->co_reg->load->model('grldatacc');
			$lp_in['accsrctyp'] = self::OBJTYP;
			$lp_in['accsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_accmdl->load( $lp_in );
				$lp_out['acc'] = $lo_accmdl;
			} else if( $lo_accmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_accmdl->errcod;
				$this->errtxt = $lo_accmdl->errtxt;
			} else {
				$lp_out['acc']=$lo_accmdl;
			}
		}
		
		return ($this->errcod==0?true:false);
	}
}
?>
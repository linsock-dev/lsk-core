<?php
final class slscus extends tmssAction2 {
	const OBJTYP = 'SLS_CUS';
  function initialize(){ $this->ID = 'cuscod'; }
	
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['adr'] = $this->co_reg->load->model('grldatadr');
		$this->data['tax'] = $this->co_reg->load->model('grldattax');
		$this->data['bnk'] = $this->co_reg->load->model('grldatbnk');
		$this->data['acc'] = $this->co_reg->load->model('grldatacc');
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$lp_dat['adrnme001'] = ($lp_dat['custxt']??'');
    return parent::save( $lp_dat, $lp_authCheck );
  }
	
  
  // GET LIST CENTRAL. devuelve recordset de objetos
  function getListCentral( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
    $lp_vewopt['vewfldflt'] = ($lp_vewopt['vewfldflt']??'');
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
    $lp_prm['rptsrcsys'] = 0; 
		if ( $this->call_sp( '08', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
  // CHANGE CLASS. modifica la clase de documento del objeto
  function changeClass( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$this->data = $lp_dat;
		$lo_out_data = array();
		return $this->call_sp( '32', $this->data, $this->data );
  }
  
	//  CALL SP.  llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$lv_rptsrcsys = ($lp_in['rptsrcsys']??'1');
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'cuscod'), 
																			$this->co_reg->db->sqldat($lp_in,'custxt'), 
																			$this->co_reg->db->sqldat($lp_in,'cuscmt'), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'cuscodext'), 
																			$this->co_reg->db->sqldat($lp_in,'slsprclstcod'), 
																			$this->co_reg->db->sqldat($lp_in,'slsgrpcod'), 
																			$this->co_reg->db->sqldat($lp_in,'paytrmcod'),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod')
																		);
		$this->sysdata['sqltxt'] = 'SLS_CUS_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'], $lv_rptsrcsys );

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
			}
		}
		
		return ($this->errcod==0?true:false);		
	}
}
?>
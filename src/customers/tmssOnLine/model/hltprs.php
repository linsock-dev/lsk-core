<?php 
final class hltprs extends tmssAction2 {
  const SRCTYP = 'HLT_PRS';
  
  function initialize(){ $this->ID = 'prscod'; }
  
	// CREATE. inicializa el objeto
	function create() {
		parent::create();
		$this->data['prsspc'] = array();
		$this->data['adr'] = $this->co_reg->load->model('grldatadr');
		$this->data['tax'] = $this->co_reg->load->model('grldattax');
		$this->data['bnk'] = $this->co_reg->load->model('grldatbnk');
    $this->data['per'] = $this->co_reg->load->model('grldatper');
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    
    $lp_dat['prsprn'] = ( isset($lp_dat['prsprn']) ? ( $lp_dat['prsprn'] == 'on' || $lp_dat['prsprn'] == '1' ? '1' : '0' ) : '0' );
    $lp_dat['prstxt'] = ($lp_dat['adrlstnme']??'') .
														(isset($lp_dat['adrlstnme']) && isset($lp_dat['adrfrtnme']) ? ', ':'') . 
														($lp_dat['adrfrtnme']??'');
		$lp_dat['adrnme001'] = $lp_dat['prstxt'];
    
    return parent::save($lp_dat, $lp_authCheck);
  }
  
	 // CHANGE CLASS. modifica la clase de documento del objeto
  function changeClass( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$this->data = $lp_dat;
		$lo_out_data = array();
		return $this->call_sp( '32', $this->data, $this->data );
  }
  
	
  // DELETE. borra objeto
  function delete( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $lp_dat['prsprn'] = ( isset($lp_dat['prsprn']) ? ( $lp_dat['prsprn'] == 'on' || $lp_dat['prsprn'] == '1' ? '1' : '0' ) : '0' );
    return parent::delete($lp_dat, $lp_authCheck);
  }
  
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {		
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																		$this->co_reg->db->sqldat($lp_in,'prscod'), 
																		$this->co_reg->db->sqldat($lp_in,'prscnthrs'), 
																		$this->co_reg->db->sqldat($lp_in,'prscmt',false), 
																		$this->co_reg->db->sqldat($lp_in,'docsts'), 
																		$this->co_reg->db->sqldat($lp_in,'agrcod'), 
																		$this->co_reg->db->sqldat($lp_in,'prscodext'), 
																		$this->co_reg->db->sqldat($lp_in,'lndtwngrpcod'), 
																		$this->co_reg->db->sqldat($lp_in,'prsprn'), 
																		$this->co_reg->db->sqldat($lp_in,'prstxt'), 
																		$this->co_reg->db->sqldte($lp_in,'prsdte'), 
																		$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																		$this->co_reg->db->sqldat($lp_in,'prsniknme',false), 
																		$this->co_reg->db->sqldte($lp_in,'prsinbdte'), 
																		$this->co_reg->db->sqldte($lp_in,'prsoutdte'), 
																		$this->co_reg->db->sqldat($lp_in,'prsoutcmt',false), 
																		$this->co_reg->db->sqldat($lp_in,'prsnat',false), 
																		$this->co_reg->db->sqldte($lp_in,'prsbrndte'), 
																		$this->co_reg->db->sqldat($lp_in,'prsdoctyp'), 
																		$this->co_reg->db->sqldat($lp_in,'prsdocnum'), 
																		$this->co_reg->db->sqldat($lp_in,'prsttl',false), 
																		$this->co_reg->db->sqldat($lp_in,'prsothstd',false), 
																		$this->co_reg->db->sqldat($lp_in,'prsjobhst',false), 
																		$this->co_reg->db->sqldat($lp_in,'prccndcod'),
																		$this->co_reg->db->sqldat($lp_in,'sysdocclscod')
																	);
		$this->sysdata['sqltxt'] = 'HLT_PRS_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    
    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
		//		S P C
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_prsspc = $this->co_reg->load->model('hltprsspc');		
			$lo_prsspc_rs = array();
			$lv_prm = array('vewfldflt' =>'[~fltrow~]p.prscod'.chr(9).'='.chr(9).chr(9).$this->data[$this->ID].chr(9).chr(9));
			$lp_out['prsspc'] = $lo_prsspc->getList($lv_prm);
		}
    
    //		C A T
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_prscat = $this->co_reg->load->model('hltprscat');	
			$lv_key = array( 'prscod' => $this->data[$this->ID] );
			$lp_out['prscat'] = $lo_prscat->load($lv_key);
		}
		
		//    A D R
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_adrmdl = $this->co_reg->load->model('grldatadr');
			$lp_in['adrsrctyp'] = self::SRCTYP;
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
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_taxmdl = $this->co_reg->load->model('grldattax');
			$lp_in['taxsrctyp'] = self::SRCTYP;
			$lp_in['taxsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_taxmdl->load( $lp_in );
				$lp_out['tax'] = $lo_taxmdl;
			} else if( $lo_taxmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_taxmdl->errcod;
				$this->errtxt = $lo_taxmdl->errtxt;
			}
		}
    
		//    B N K
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_bnkmdl = $this->co_reg->load->model('grldatbnk');
			$lp_in['bnksrctyp'] = self::SRCTYP;
			$lp_in['bnksrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_bnkmdl->load( $lp_in );
				$lp_out['bnk'] = $lo_bnkmdl;
			} else if( $lo_bnkmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_bnkmdl->errcod;
				$this->errtxt = $lo_bnkmdl->errtxt;
			}
		}
		
		//		H O R A R I O S
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_tmemdl = $this->co_reg->load->model('hltspctme');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]t.delcod'.chr(9).'<>'.chr(9).chr(9).'0'.chr(9).chr(9).
																		'[~fltrow~]t.prscod'.chr(9).'='.chr(9).chr(9).$lp_in['prscod'].chr(9).chr(9).
																		'[~fltrow~]t.spccod'.chr(9).'<>'.chr(9).chr(9).'0'.chr(9).chr(9),
											'vewfldord' => 't.tmeday'
										);
			$lp_out['hltspctme'] = $lo_tmemdl->getList( $lv_prm );
		}
    
    //    P E R
		if ( ($lp_action=='01' || $lp_action=='02' || $lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$this->lo_grlper = $this->co_reg->load->model('grldatper');
			$lp_in['persrctyp'] = self::SRCTYP;
			$lp_in['persrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$this->lo_grlper->load( $lp_in );
				$lp_out['per'] = $this->lo_grlper;
			} else if( $this->lo_grlper->save( $lp_in )==false ) {
				$this->errcod = $this->lo_grlper->errcod;
				$this->errtxt = $this->lo_grlper->errtxt;
			}
		}	
		
		return ($this->errcod==0?true:false);
	}
}
?>
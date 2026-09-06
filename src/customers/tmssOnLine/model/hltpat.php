<?php
final class hltpat extends tmssAction2 {
  const OBJTYP = 'HLT_PAT';  
  function initialize(){ $this->ID = 'patcod'; }
	
	// CREATE. inicializa el objeto
	function create() {
		parent::create();
		$this->data['adr'] = $this->co_reg->load->model('grldatadr');
		$this->data['tax'] = $this->co_reg->load->model('grldattax');
		$this->data['bnk'] = $this->co_reg->load->model('grldatbnk');
		$this->data['per'] = $this->co_reg->load->model('grldatper');
		$this->data['prsrls'] = $this->co_reg->load->model('hltpatprsrls');
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
		if(count($lp_dat)==0){ $lp_dat = $this->co_reg->request->post; }
		$lp_dat['pattxt'] = ($lp_dat['adrlstnme']??'') .
												(($lp_dat['adrlstnme']??'')!='' && ($lp_dat['adrfrtnme']??'')!='' ? ', ':'') . 
												($lp_dat['adrfrtnme']??'');	
		$lp_dat['adrnme001'] = $lp_dat['pattxt'];					
		return parent::save($lp_dat, $lp_authCheck);
  }
	
  // CHANGE CLASS. modifica la clase de documento del objeto
  function changeClass( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$this->data = $lp_dat;
		$lo_out_data = array();
		return $this->call_sp( '32', $this->data, $this->data );
  }
	
  //  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'patcod'), 
																			$this->co_reg->db->sqldat($lp_in,'pattxt'), 
																			$this->co_reg->db->sqldat($lp_in,'patcodext'),
																			$this->co_reg->db->sqldat($lp_in,'cuscod'),
																			$this->co_reg->db->sqldte($lp_in,'patbrndte'),
																			$this->co_reg->db->sqldte($lp_in,'patinbdte'),
																			$this->co_reg->db->sqldte($lp_in,'patoutdte'),
																			$this->co_reg->db->sqldat($lp_in,'cushsp'), 
																			$this->co_reg->db->sqldat($lp_in,'cusdocder'), 
																			$this->co_reg->db->sqldat($lp_in,'patdiacod'), 
																			$this->co_reg->db->sqldat($lp_in,'patcpx'), 
																			$this->co_reg->db->sqldat($lp_in,'pataflnum'), 
																			$this->co_reg->db->sqldat($lp_in,'pataflpln'), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldte($lp_in,'evldte'), 
																			$this->co_reg->db->sqldat($lp_in,'evlplc'), 
																			$this->co_reg->db->sqldat($lp_in,'evldia'), 
																			$this->co_reg->db->sqldat($lp_in,'EvlIntDayHme'), 
																			$this->co_reg->db->sqldte($lp_in,'EvlIntEstDte'), 
																			$this->co_reg->db->sqldat($lp_in,'evldoc'), 
																			$this->co_reg->db->sqldat($lp_in,'evldoc001'), 
																			$this->co_reg->db->sqldat($lp_in,'evldoc002'), 
																			$this->co_reg->db->sqldat($lp_in,'patcmt'), 
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'patsex'), 
																			$this->co_reg->db->sqldat($lp_in,'hltdisclscod'), 
																			$this->co_reg->db->sqldat($lp_in,'hltdisclscodext'), 
																			$this->co_reg->db->sqldat($lp_in,'patatrval002',false),
																			$this->co_reg->db->sqldte($lp_in,'patreqdte'),
																			$this->co_reg->db->sqldte($lp_in,'patevldte'),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldat($lp_in,'patcrocod'),
																			$this->co_reg->db->sqldat($lp_in,'patpro'),
                                      $this->co_reg->db->sqlnum($lp_in,'patwgt',3),
                                      $this->co_reg->db->sqlnum($lp_in,'pathgh',3),
                                      $this->co_reg->db->sqldat($lp_in,'hltpatclscod'),
                                      $this->co_reg->db->sqldat($lp_in,'prsrls')
																		);
		$this->sysdata['sqltxt'] = 'HLT_PAT_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
    
		//		A D R
		if ( ($lp_action=='01' || $lp_action=='11' || $lp_action=='02' || $lp_action=='12'  || $lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_grladr = $this->co_reg->load->model('grldatadr');
			$lp_in['adrsrctyp'] = self::OBJTYP;
			$lp_in['adrsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_grladr->load( $lp_in );
				$lp_out['adr'] = $lo_grladr;
			} else if ( $lo_grladr->save( $lp_in )==false ) {
				$this->errcod = $lo_grladr->errcod;
				$this->errtxt = $lo_grladr->errtxt;
			} else {
				$lp_out['adrnum']=$lo_grladr->adrnum;
			}
		}
		
		//		T A X
		if ( ($lp_action=='01' || $lp_action=='11' || $lp_action=='02' || $lp_action=='12'  || $lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_grltax = $this->co_reg->load->model('grldattax');
			$lp_in['taxsrctyp'] = self::OBJTYP;
			$lp_in['taxsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_grltax->load( $lp_in );
				$lp_out['tax'] = $lo_grltax;
			} else if( $lo_grltax->save( $lp_in )==false ) {
				$this->errcod = $lo_grltax->errcod;
				$this->errtxt = $lo_grltax->errtxt;
			} else {
				$lp_out['taxnum']=$lo_grltax->taxnum;
			}
		}
		
		//		B N K 
		if ( ($lp_action=='01' || $lp_action=='11' || $lp_action=='02' || $lp_action=='12'  || $lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_grlbnk = $this->co_reg->load->model('grldatbnk');
			$lp_in['bnksrctyp'] = self::OBJTYP;
			$lp_in['bnksrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_grlbnk->load( $lp_in );
				$lp_out['bnk'] = $lo_grlbnk;
			} else if( $lo_grlbnk->save( $lp_in )==false ) {
				$this->errcod = $lo_grlbnk->errcod;
				$this->errtxt = $lo_grlbnk->errtxt;
			} else {
				$lp_out['bnknum']=$lo_grlbnk->bnknum;
			}
		}

		//		R L S Modificar para que se recupere por JSON
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
      $lp_out['prsrls'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['prsrls']??'[]'), true ));
		}
		
		//    P E R
		if ( ($lp_action=='01' || $lp_action=='11' || $lp_action=='02' || $lp_action=='12'  || $lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_grlper = $this->co_reg->load->model('grldatper');
			$lp_in['persrctyp'] = self::OBJTYP;
			$lp_in['persrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13') {
				$lo_grlper->load( $lp_in );
				$lp_out['per'] = $lo_grlper;
			} else if( $lo_grlper->save( $lp_in )==false ) {
				$this->errcod = $lo_grlper->errcod;
				$this->errtxt = $lo_grlper->errtxt;
			} else {
				$lp_out['pernum']=$lo_grlper->pernum;
			}
		}		
		
		return ($this->errcod==0?true:false);
	}
}
?>
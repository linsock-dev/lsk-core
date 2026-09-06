<?php
final class edustu extends tmssAction2 {
	const OBJTYP = 'EDU_STU';
  function initialize(){ $this->ID = 'stucod'; }
	
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['adr'] = $this->co_reg->load->model('grldatadr');
		$this->data['tax'] = $this->co_reg->load->model('grldattax');
		$this->data['bnk'] = $this->co_reg->load->model('grldatbnk');
		$this->data['per'] = $this->co_reg->load->model('grldatper');
	}

  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$lp_dat['stutxt'] = ($lp_dat['adrlstnme']??'') .
												(isset($lp_dat['adrlstnme']) && isset($lp_dat['adrfrtnme']) ? ', ':'') . 
												($lp_dat['adrfrtnme']??'');
		$lp_dat['adrnme001'] = $lp_dat['stutxt'];																

		// ESTADOS -----------------------------------------------------------------------
		if ( isset($lp_dat['sysdocclscod']) ) {
			$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
			$lo_docclsmdl->load(array('sysdocclscod'=>$lp_dat['sysdocclscod']), false);
			$lv_autostatus = (strtoupper($this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr,'auto_status'))=='X'?true:false);
			if ( $lv_autostatus ) {
				$lv_docsts = ((isset($lp_dat['docsts'])?$lp_dat['docsts']:'')=='I'?'I':
											((isset($lp_dat['stuoutdte'])?$lp_dat['stuoutdte']:'')!=''?'I':
											((isset($lp_dat['stuinbdte'])?$lp_dat['stuinbdte']:'')!=''?'A':
											((isset($lp_dat['stuevldte'])?$lp_dat['stuevldte']:'')!=''?'E':'N'))));
			} else {
				$lv_docsts = $lp_dat['docsts'];
			}
			$lp_dat['docsts'] = $lv_docsts;
		}
		
		return parent::save( $lp_dat, $lp_authCheck );
  }
  
  // CALL SP. llamada a storedprocedure del modelo
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                     	$this->co_reg->db->sqldat($lp_in,'stucod'),
                                    	$this->co_reg->db->sqldat($lp_in,'stutxt'),
                                    	$this->co_reg->db->sqldat($lp_in,'stucodext'),
                                    	$this->co_reg->db->sqldat($lp_in,'cuscod'),
                                    	$this->co_reg->db->sqldte($lp_in,'stubrndte'),
                                    	$this->co_reg->db->sqldte($lp_in,'stuinbdte'),
                                    	$this->co_reg->db->sqldte($lp_in,'stuoutdte'),
                                    	$this->co_reg->db->sqldte($lp_in,'stureqdte'),
                                   	  $this->co_reg->db->sqldte($lp_in,'stuevldte'),
                                     	$this->co_reg->db->sqldat($lp_in,'stusex'),
                                     	$this->co_reg->db->sqldat($lp_in,'stuatrval001'),
                                     	$this->co_reg->db->sqldat($lp_in,'stuatrval002'),
                                     	$this->co_reg->db->sqldat($lp_in,'stucmt'),
                                     	$this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                      $this->co_reg->db->sqldat($lp_in,'stumedcovcod'),
                                      $this->co_reg->db->sqldat($lp_in,'stumedcovnum'),
                                      $this->co_reg->db->sqldat($lp_in,'stumedcovpln')	
																		);
		$this->sysdata['sqltxt'] = 'EDU_STU_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
    
    //Verifica las actividades
    $lv_fndval = in_array($lp_action,['01', '11', '02', '12', '03', '13']);
    
		//		A D R
		if ( $lv_fndval && $this->errcod==0 ) {
			$lo_grladr = $this->co_reg->load->model('grldatadr');
			$lp_in['adrsrctyp'] = self::OBJTYP;
			$lp_in['adrsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13' ) {
				$lo_grladr->load( $lp_in );
				$lp_out['adr'] = $lo_grladr;
			} else if ( $lo_grladr->save( $lp_in )==false ) {
        $this->errtyp = 'E';
				$this->errcod = $lo_grladr->errcod;
				$this->errtxt = $lo_grladr->errtxt;
			} else {
				$lp_out['adrnum']=$lo_grladr->adrnum;
			}
		}

		//		T A X
		if ( $lv_fndval && $this->errcod==0 ) {
			$lo_grltax = $this->co_reg->load->model('grldattax');
			$lp_in['taxsrctyp'] = self::OBJTYP;				
			$lp_in['taxsrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13' ) {
				$lo_grltax->load( $lp_in );
				$lp_out['tax'] = $lo_grltax;
			} else if( $lo_grltax->save( $lp_in )==false ) {
        $this->errtyp = 'E';
				$this->errcod = $lo_grltax->errcod;
				$this->errtxt = $lo_grltax->errtxt;
			} else {
				$lp_out['taxnum']=$lo_grltax->taxnum;
			}
		}
		
		//		B N K
		if ( $lv_fndval && $this->errcod==0 ) {
			$lo_grlbnk = $this->co_reg->load->model('grldatbnk');
			$lp_in['bnksrctyp'] = self::OBJTYP;
			$lp_in['bnksrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13' ) {
				$lo_grlbnk->load( $lp_in );
				$lp_out['bnk'] = $lo_grlbnk;
			} else if( $lo_grlbnk->save( $lp_in )==false ) {
        $this->errtyp = 'E';
				$this->errcod = $lo_grlbnk->errcod;
				$this->errtxt = $lo_grlbnk->errtxt;
			} else {
				$lp_out['bnknum']=$lo_grlbnk->bnknum;
			}
		}
		
		//    P E R
		if ( $lv_fndval && $this->errcod==0 ) {
			$lo_grlper = $this->co_reg->load->model('grldatper');
			$lp_in['persrctyp'] = self::OBJTYP;
			$lp_in['persrccod'] = $this->data[$this->ID];
			if ($lp_action=='03' || $lp_action=='13' ) {
				$lo_grlper->load( $lp_in );
				$lp_out['per'] = $lo_grlper;
			} else if( $lo_grlper->save( $lp_in )==false ) {
        $this->errtyp = 'E';
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
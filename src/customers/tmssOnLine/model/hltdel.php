<?php
final class hltdel extends tmssAction2 {
	const OBJTYP = 'HLT_DEL';
  function initialize(){ $this->ID = 'delcod'; }

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
		$lp_dat['adrnme001'] = (isset($lp_dat['deltxt'])?$lp_dat['deltxt']:'');
		return parent::save($lp_dat, $lp_authCheck);
  }
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'delcod'), 
																			$this->co_reg->db->sqldat($lp_in,'delcodext'), 
																			$this->co_reg->db->sqldat($lp_in,'deltxt'), 
																			$this->co_reg->db->sqldat($lp_in,'delcnthrs',false), 
																			$this->co_reg->db->sqldat($lp_in,'deltypcod'),
																			$this->co_reg->db->sqldat($lp_in,'delcmt',false),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod')
																		);
		$this->sysdata['sqltxt'] = 'HLT_DEL_DEF (?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		$this->chkError($lp_action, $lo_rs, $lp_out, '08|18');
   	//Un array para chequear las distintas actividades que necesitan de otros modelos
    $lv_actarr = array('01', '11', '02', '12', '03', '13');
    $lv_fndval = in_array($lp_action,$lv_actarr);
    
		//		A D R
		if ( $lv_fndval && $this->errcod==0 ) {
			$lo_adrmdl = $this->co_reg->load->model('grldatadr');
			$lp_in['adrsrctyp'] = self::OBJTYP;
			$lp_in['adrsrccod'] = $this->data[$this->ID ];
			if($lp_action=='03' || $lp_action == '13') {
				$lo_adrmdl->load( $lp_in );
				$lp_out['adr'] = $lo_adrmdl;
			} else if ( $lo_adrmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_adrmdl->errcod;
				$this->errtxt = $lo_adrmdl->errtxt;
			}
		}

		//		T A X
		if ( $lv_fndval && $this->errcod==0 ) {
			$lo_taxmdl = $this->co_reg->load->model('grldattax');
			$lp_in['taxsrctyp'] = self::OBJTYP;
			$lp_in['taxsrccod'] = $this->data[$this->ID ];
			if ($lp_action=='03' || $lp_action == '13') {
				$lo_taxmdl->load( $lp_in );
				$lp_out['tax'] = $lo_taxmdl;
			} else if( $lo_taxmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_taxmdl->errcod;
				$this->errtxt = $lo_taxmdl->errtxt;
			}
		}
		
		//		B N K
		if ( $lv_fndval && $this->errcod==0 ) {
			$lo_bnkmdl = $this->co_reg->load->model('grldatbnk');
			$lp_in['bnksrctyp'] = self::OBJTYP;
			$lp_in['bnksrccod'] = $this->data[$this->ID ];
			if ($lp_action=='03' || $lp_action == '13') {
				$lo_bnkmdl->load( $lp_in );
				$lp_out['bnk'] = $lo_bnkmdl;
			} else if( $lo_bnkmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_bnkmdl->errcod;
				$this->errtxt = $lo_bnkmdl->errtxt;
			}
		}
		
		//		A C C
		if ( $lv_fndval && $this->errcod==0 ) {
			$lo_accmdl = $this->co_reg->load->model('grldatacc');
			$lp_in['accsrctyp'] = self::OBJTYP;
			$lp_in['accsrccod'] = $this->data[$this->ID ];
			if ($lp_action=='03' || $lp_action == '13') {
				$lo_accmdl->load( $lp_in );
				$lp_out['acc'] = $lo_accmdl;
			} else if( $lo_accmdl->save( $lp_in )==false ) {
				$this->errcod = $lo_accmdl->errcod;
				$this->errtxt = $lo_accmdl->errtxt;
			}
		}

		//		H O R A R I O S
		if ( ($lp_action=='03' || $lp_action == '13') && $this->errcod==0 ) {
			$lo_tmemdl = $this->co_reg->load->model('hltspctme');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]t.delcod'.chr(9).'='.chr(9).chr(9).$lp_in['delcod'].chr(9).chr(9).
																		'[~fltrow~]t.prscod'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																		'[~fltrow~]t.spccod'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9),
											'vewfldord' => 't.tmeday'
										);
			$lp_out['hltspctme'] = $lo_tmemdl->getList( $lv_prm );
		}
		
		return ($this->errcod==0?true:false);		
	}	
}
?>
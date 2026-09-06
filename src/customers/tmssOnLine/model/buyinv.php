<?php
final class buyinv extends tmssAction2 {
  const SRCTYP = 'BUY_INV';                                                                                                                           
	function initialize(){ $this->ID = 'buyinvcod'; }
		
	// CREATE. inicializa el objeto
	function create( $lp_data=array() ) {
    parent::create();
		$this->data['buyinvmat'] = array();
    $this->data['buyinvprc'] = array();
		if(count($lp_data)>0){
			foreach($lp_data as $lv_key=>$lv_val){
				if($lv_key!='buyinvmat'){
					$this->data[$lv_key] = $lv_val;
				} else {
					$this->data['buyinvmat'] = array();
					$lv_val = html_entity_decode($lv_val);
					$lv_matarr = json_decode($lv_val,true);
          if(is_arraY($lv_matarr)){
						foreach( $lv_matarr as $lv_row ) {
							$this->data['buyinvmat'][] = $lv_row;
						}
          }
				}
			}
		}
	}
	
	
  // ACCOUNTING. contabiliza el documento
  function accounting( $lo_dat=array(), $lp_authCheck=true ) {
    if( count($lo_dat)==0 ) { $lo_dat = $this->co_reg->request->post; }
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( ($lp_authCheck?'09':'19'), $this->data, $lo_out_data );
  }
	  
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'buyinvcod'),
                                      $this->co_reg->db->sqldat($lp_in,'buyinvcodext'),
                                      $this->co_reg->db->sqldat($lp_in,'buyinvtxt'),
                                      $this->co_reg->db->sqldte($lp_in,'buyinvdte'), 
                                      $this->co_reg->db->sqldat($lp_in,'srcobjtyp'), 
																			$this->co_reg->db->sqldat($lp_in,'srcobjcod'),
                                      $this->co_reg->db->sqlnum($lp_in,'buyinvtot'),
                                      $this->co_reg->db->sqldat($lp_in,'curcod'),
                                      $this->co_reg->db->sqlnum($lp_in,'curexcrte',5),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                      $this->co_reg->db->sqldte($lp_in,'buyinvstrdte'), 
																			$this->co_reg->db->sqldte($lp_in,'buyinvenddte'),
                                      $this->co_reg->db->sqldte($lp_in,'buyinvaccdte'),
																			// lista de precio?
                                      $this->co_reg->db->sqldat($lp_in,'sysdocrejcod'),
                                      $this->co_reg->db->sqldat($lp_in,'paytrmcod')
																		);
		$this->sysdata['sqltxt'] = 'BUY_INV_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,null,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}		
    
		//		M A T E R I A L E S
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_buyinvmat = $this->co_reg->load->model('buyinvmat');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]im.buyinvcod'.chr(9).'='.chr(9).chr(9).$lp_in[$this->ID].chr(9).chr(9));
			$lp_out['buyinvmat'] = $lo_buyinvmat->getList( $lv_prm );
		}
		
		//		P R E C I O S
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_buyinvprc = $this->co_reg->load->model('grldatprc');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]p.srcobjtyp'.chr(9).'='.chr(9).chr(9).self::SRCTYP.chr(9).chr(9).
																		'[~fltrow~]p.srcobjcod001'.chr(9).'='.chr(9).chr(9).$lp_in[$this->ID].chr(9).chr(9),
											'vewfldord' =>'p.srcobjcod002, p.prcschcndrow ' );
			$lp_out['buyinvprc'] = $lo_buyinvprc->getList( $lv_prm );
		}
		
		return ($this->errcod==0?true:false);
	}
}
?>
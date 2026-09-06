<?php
final class slsord extends tmssAction2 {
  function initialize(){ $this->ID = 'slsordcod'; }	
	
	// CREATE. inicializa el objeto
	function create( $lp_data=array() ) {
    parent:: create();
    $this->data['slsordmat'] = array();
		if(count($lp_data)>0){
			foreach($lp_data as $lv_key=>$lv_val){
				if($lv_key!='slsordmat'){
					$this->data[$lv_key] = $lv_val;
				} else {
					$this->data['slsordmat'] = array();
					$lv_val = html_entity_decode($lv_val);
					$lv_matarr = json_decode($lv_val,true);
					if($lv_matarr != null && count($lv_matarr)>0){
						foreach( $lv_matarr as $lv_row ) {
							$this->data['slsordmat'][] = $lv_row;
						}
					}
				}
			}
		}
	}
  
  // ACCOUNTING. contabiliza el documento
  function accounting( $lp_dat=array(), $lp_authCheck=true ) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( ($lp_authCheck?'09':'19'), $this->data, $this->data );
  }
		
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
                                     	$this->co_reg->db->sqldat($lp_in, 'slsordcod'),
																			$this->co_reg->db->sqldat($lp_in, 'slsordcodext'),
																			$this->co_reg->db->sqldat($lp_in, 'slsordtxt'),
																			$this->co_reg->db->sqldte($lp_in, 'slsorddte'),
																			$this->co_reg->db->sqldat($lp_in, 'dstobjtyp'),
																			$this->co_reg->db->sqldat($lp_in, 'dstobjcod'),
																			$this->co_reg->db->sqldat($lp_in, 'dstcntcod'),
																			$this->co_reg->db->sqlnum($lp_in, 'slsordtot'), 
																			$this->co_reg->db->sqldat($lp_in, 'curcod'),
																			$this->co_reg->db->sqlnum($lp_in, 'curexcrte', 5),
																			$this->co_reg->db->sqldat($lp_in, 'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
																			$this->co_reg->db->sqldat($lp_in, 'sysdocclscod'),
																			$this->co_reg->db->sqldte($lp_in, 'slsordstrdte'),
																			$this->co_reg->db->sqldte($lp_in, 'slsordenddte'),
																			$this->co_reg->db->sqldat($lp_in, 'slsprclstcod'),
																			$this->co_reg->db->sqldat($lp_in, 'sysdocrejcod'),
																			$this->co_reg->db->sqldat($lp_in, 'paytrmcod'),
																			$this->co_reg->db->sqldat($lp_in, 'slsordmat', false),
                                     	$this->co_reg->db->sqldat($lp_in, 'stkmovprtcod'),
																			$this->co_reg->db->sqldat($lp_in, 'slsordprc', false)
																		);
		$this->sysdata['sqltxt'] = 'SLS_ORD_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
		//		M A T E R I A L E S
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_slsordmat = $this->co_reg->load->model('slsordmat');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]om.slsordcod'.chr(9).'='.chr(9).chr(9).$lp_in['slsordcod'].chr(9).chr(9));
			$lp_out['slsordmat'] = $lo_slsordmat->getList( $lv_prm );
		}
    
    //		P R E C I O S
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_slsordprc = $this->co_reg->load->model('grldatprc');
      // recupero los precios del documento de tipo sls_ord o sls_qta del modelo de la tabla de precios generales
			$lv_prm = array('vewfldflt' =>'[~fltrow~]p.srcobjtyp'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),['SLS_ORD', 'SLS_QTA']).chr(9).chr(9).
																		'[~fltrow~]p.srcobjcod001'.chr(9).'='.chr(9).chr(9).$lp_in['slsordcod'].chr(9).chr(9),
											'vewfldord' =>'p.srcobjcod002, p.prcschcndrow ' );
			$lp_out['slsordprc'] = $lo_slsordprc->getList( $lv_prm );
		}
		
		return ($this->errcod==0?true:false);
	}
}
?>
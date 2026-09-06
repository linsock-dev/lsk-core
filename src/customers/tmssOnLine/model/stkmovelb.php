<?php
final class stkmovelb extends tmssAction2 {
  function initialize(){ $this->ID = 'stkmovelbcod'; }
	
	// CREATE. inicializa el objeto
	function create($lp_data=array()) {
    parent::create();
		$this->data['stkmovelbmat'] = array();		
		if(count($lp_data)>0){
			foreach($lp_data as $lv_key=>$lv_val){
				if($lv_key!='stkmovelbmat'){
					$this->data[$lv_key] = $lv_val;
				} else {
					$this->data['stkmovelbmat'] = array();
					$lv_val = html_entity_decode($lv_val);
					$lv_matarr = json_decode($lv_val,true);
					foreach( $lv_matarr as $lv_row ) {
						$this->data['stkmovelbmat'][] = $lv_row;
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
		return $this->call_sp( ($lp_authCheck?'09':'19'), $this->data, $this->data );
  }
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'stkmovelbcod'), 
																			$this->co_reg->db->sqldat($lp_in,'stkmovelbcodext'), 
																			$this->co_reg->db->sqldte($lp_in,'stkmovelbdte'), 
																			$this->co_reg->db->sqldat($lp_in,'strloccod'), 
																			$this->co_reg->db->sqldat($lp_in,'matlstcod'),
																			$this->co_reg->db->sqldat($lp_in,'matcod'), 
																			$this->co_reg->db->sqlnum($lp_in,'matqty'), 
																			$this->co_reg->db->sqldat($lp_in,'matuntcod'), 
																			$this->co_reg->db->sqldat($lp_in,'matbchcod'), 
																			$this->co_reg->db->sqldat($lp_in,'matbchcodext',false), 
                                     	$this->co_reg->db->sqldte($lp_in,'matbchduedte'), 
																			$this->co_reg->db->sqldat($lp_in,'matsercodextlst',false), 
																			$this->co_reg->db->sqldat($lp_in,'stkmovelbatr',false),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldat($lp_in,'stkmovdoccod')
																		);
		$this->sysdata['sqltxt'] = 'STK_MOV_ELB_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    $this->errmat = $lo_rs[0]['errmat']??'';
    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		//		M A T E R I A L E S
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_matmdl = $this->co_reg->load->model('stkmovelbmat');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]d.stkmovelbcod'.chr(9).'='.chr(9).chr(9).$lp_in['stkmovelbcod'].chr(9).chr(9),
                    	'vewfldord' =>'dm.matcod' );
			$lp_out['stkmovelbmat'] = $lo_matmdl->getList( $lv_prm );
		}
		
		return ($this->errcod==0?true:false);
	}
}
?>
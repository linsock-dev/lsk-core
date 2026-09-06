<?php
final class stkmanord extends tmssAction2 {
  function initialize(){ $this->ID = 'stkmanordcod'; }
	
	// CREATE. inicializa el objeto
	function create( $lp_data=array() ) {
    parent::create();

    $this->data['stkmanordmat'] = array();
		if(count($lp_data)>0){
			foreach($lp_data as $lv_key=>$lv_val){
				if($lv_key!='stkmanordmat'){
					$this->data[$lv_key] = $lv_val;
				} else {
					$this->data['stkmanordmat'] = array();
					$lv_val = html_entity_decode($lv_val);
					$lv_matarr = json_decode($lv_val,true);
					if($lv_matarr != null && count($lv_matarr)>0){
						foreach( $lv_matarr as $lv_row ) {
							$this->data['stkmanordmat'][] = $lv_row;
						}
					}
				}
			}
		}
	}
	
	
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'stkmanordcod'),
																			$this->co_reg->db->sqldat($lp_in,'stkmanordcodext'), 
                                      $this->co_reg->db->sqldat($lp_in,'stkmanordtxt'),
                                      $this->co_reg->db->sqldte($lp_in,'stkmanorddte'),
                                      $this->co_reg->db->sqldat($lp_in,'stkmanordatr', false),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocrejcod'),
                                      $this->co_reg->db->sqldat($lp_in,'rspobjcod'),
                                      $this->co_reg->db->sqldat($lp_in,'srcobjtxt'),
                                      $this->co_reg->db->sqldat($lp_in,'rspobjtyp'), 
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false)
																		);
		$this->sysdata['sqltxt'] = 'STK_MAN_ORD_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
	
		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
    
    //		M A T E R I A L E S
		if ( ($lp_action=='03' || $lp_action=='13' ) && $this->errcod==0 ) {
			$lo_stkmanordmat = $this->co_reg->load->model('stkmanordmat');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]r.stkmanordcod'.chr(9).'='.chr(9).chr(9).$lp_in['stkmanordcod'].chr(9).chr(9));
			$lp_out['stkmanordmat'] = $lo_stkmanordmat->getList( $lv_prm, null, null, false );
		}
    
		return ($this->errcod==0?true:false);
	}
}
?>
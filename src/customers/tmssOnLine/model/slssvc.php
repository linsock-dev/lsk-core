<?php
final class slssvc extends tmssAction2 {
  const OBJTYP = 'SLS_SVC';
  function initialize(){ $this->ID = 'slssvccod'; }
		
	// CREATE. inicializa el objeto
	function create( $lp_data=array() ) {
    parent::create();
		$this->data['slssvcmat'] = array();
		if(count($lp_data)>0){
			foreach($lp_data as $lv_key=>$lv_val){
				if($lv_key!='slssvcmat'){
					$this->data[$lv_key] = $lv_val;
				} else {
					$lv_val = html_entity_decode($lv_val);
          $lv_matarr = json_decode($lv_val,true);
					if($lv_matarr != null && count($lv_matarr)>0 ){
            foreach( $lv_matarr as $lv_row ) {
              $this->data['slssvcmat'][] = $lv_row;
            }
          } 
				}
			}
		}
	}
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'slssvccod'),
																			$this->co_reg->db->sqldat($lp_in,'slssvccodext'), 
																			$this->co_reg->db->sqldat($lp_in,'slssvctxt'), 
																			$this->co_reg->db->sqldte($lp_in,'slssvcdte'), 
																			$this->co_reg->db->sqldat($lp_in,'dstobjtyp'), 
																			$this->co_reg->db->sqldat($lp_in,'dstobjcod'), 
																			$this->co_reg->db->sqlnum($lp_in,'slssvctot'), 
																			$this->co_reg->db->sqldat($lp_in,'curcod'), 
																			$this->co_reg->db->sqlnum($lp_in,'curexcrte',5), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldte($lp_in,'slssvcstrdte'), 
																			$this->co_reg->db->sqldte($lp_in,'slssvcenddte'),
																			$this->co_reg->db->sqldat($lp_in,'slsprclstcod'),
																			$this->co_reg->db->sqldat($lp_in,'slssvcatr',false)
																		);
		$this->sysdata['sqltxt'] = 'SLS_SVC_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);   
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] ); 

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
		//		M A T E R I A L E S
		if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lo_slssvcmat = $this->co_reg->load->model('slssvcmat');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]om.slssvccod'.chr(9).'='.chr(9).chr(9).$lp_in['slssvccod'].chr(9).chr(9));
			$lp_out['slssvcmat'] = $lo_slssvcmat->getList( $lv_prm );
		}
		
		return ($this->errcod==0?true:false);
	}
}
?>
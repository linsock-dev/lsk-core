<?php
final class buyord extends tmssAction2 {
  const OBJTYP = 'BUY_ORD';                                                                                                                           
  function initialize(){ $this->ID = 'buyordcod'; }
	
	// CREATE. inicializa el objeto
	function create( $lp_data=array() ) {
		$this->data = array();
		$this->sysdata = array();
		$this->data['buyordmat'] = array();
		if(count($lp_data)>0){
			foreach($lp_data as $lv_key=>$lv_val){
				if($lv_key!='buyordmat'){
					$this->data[$lv_key] = $lv_val;
				} else {
					$this->data['buyordmat'] = array();
					$lv_val = html_entity_decode($lv_val);
					$lv_matarr = json_decode($lv_val,true);
          if(is_array($lv_matarr)){
						foreach( $lv_matarr as $lv_row ) {
              $lv_row['mattxt'] = utf8_decode(html_entity_decode($lv_row['mattxt']));
							$this->data['buyordmat'][] = $lv_row;
						}
          }
				}
			}
		}
	}
	
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'buyordcod'),	
                                     	$this->co_reg->db->sqldat($lp_in,'buyordcodext'),
                                     	$this->co_reg->db->sqldat($lp_in,'buyordtxt'),
																			$this->co_reg->db->sqldte($lp_in,'buyorddte'),
																			$this->co_reg->db->sqldat($lp_in,'srcobjtyp'), 
																			$this->co_reg->db->sqldat($lp_in,'srcobjcod'),
                                     	$this->co_reg->db->sqlnum($lp_in,'buyordtot'), 
																			$this->co_reg->db->sqldat($lp_in,'curcod'), 
                                     	$this->co_reg->db->sqlnum($lp_in,'curexcrte',5), 
                                     	$this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata,'view_options', false),
                                     	$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldte($lp_in,'buyordstrdte'), 
																			$this->co_reg->db->sqldte($lp_in,'buyordenddte'),
                                     	$this->co_reg->db->sqldat($lp_in,'sysdocrejcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'paytrmcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'finceccod'),
                                     	self::OBJTYP
																		);
		$this->sysdata['sqltxt'] = 'BUY_ORD_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}		

		//		M A T E R I A L E S
		if ( ($lp_action=='03' || $lp_action=='13' ) && $this->errcod==0 ) {
			$lo_buyordmat = $this->co_reg->load->model('buyordmat');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]om.buyordcod'.chr(9).'='.chr(9).chr(9).$lp_in[$this->ID].chr(9).chr(9));
			$lp_out['buyordmat'] = $lo_buyordmat->getList( $lv_prm, null, null, false );
		}
		
		return ($this->errcod==0?true:false);
	}
}
?>
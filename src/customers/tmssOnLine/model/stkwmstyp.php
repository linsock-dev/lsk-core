<?php
final class stkwmstyp extends tmssAction2 {
  function initialize(){ $this->ID = 'wmstypcod'; }
	
  	// CREATE. crea un objeto
	function create() {
    parent::create();
		$this->data['stkwmsare'] = array();
	}
	
  //  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
                                     	$this->co_reg->db->sqldat($lp_in,'wmstypcod'),
																			$this->co_reg->db->sqldat($lp_in,'wmstypcodext'),
                                      $this->co_reg->db->sqldat($lp_in,'wmstyptxt'),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
                                      $this->co_reg->db->sqldat($lp_in,'strloccod')
                                    );
		$this->sysdata['sqltxt'] = 'STK_WMS_TYP_DEF (?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    // Si hubo error del recordset finalizar ejecucion
    if(!$this->chkError($lp_action, $lo_rs, $lp_out, '08|18')) { return false; }
    
    if ( ($lp_action=='03' || $lp_action=='13') && $this->errcod==0 ) {
			$lp_out['stkwmsare'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['stkwmsare']??'[]'), true ));   
		}
    
    return ($this->errcod==0?true:false);
	}	
}
?>
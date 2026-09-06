<?php
final class cnslqd extends tmssAction2 {  
  function initialize(){ $this->ID = 'cnslqdcod'; }
  
  // GET OPEN SERVICES. obtiene la lista de prestaciones no liquidados
  function getOpenServices( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if($lo_vew==null) {$lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '23', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
	// GET SERVICES. obtiene la lista de servicios liquidados
  function getServices( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if ($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '33', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
  
 	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
    $this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                    $this->co_reg->db->sqldat($lp_in,'cnslqdcod'),
                                    $this->co_reg->db->sqldat($lp_in,'cnslqdcodext'),
                                    $this->co_reg->db->sqldat($lp_in,'cnslqdtxt'),
                                    $this->co_reg->db->sqldte($lp_in,'cnslqdstrdte'),
                                    $this->co_reg->db->sqldte($lp_in,'cnslqdenddte'),
                                    $this->co_reg->db->sqldat($lp_in,'cuscod'),
                                    $this->co_reg->db->sqldat($lp_in,'cnslqdatr'),                                    
                                    $this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                    $this->co_reg->db->sqldat($lp_in,'docsts'),
                                    $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                    $this->co_reg->db->sqldat($lp_in,'cnslqddoc',false)
                          );
    $this->sysdata['sqltxt'] = 'CNS_LQD_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		
    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|23|33')){return false;}
    
    if ( $lp_action=='03' || $lp_action=='13' ) {
    	$lp_out['cnslqddoc'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['cnslqddoc']??'[]'), true ));    
    }
    
    return ($this->errcod==0?true:false);
	}
}
?>
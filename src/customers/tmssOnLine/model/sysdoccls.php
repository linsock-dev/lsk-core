<?php
final class sysdoccls extends tmssAction2 {
  function initialize(){ $this->ID = 'sysdocclscod'; }
	
  // GET LIST EXTENDED. get list of objects
  function getListExt( $lp_vewopt=array(), $lp_prm=array() ) {
    $lo_vew = $this->co_reg->load->model('grlvew');
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '09', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscodext'),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclstxt'),
																			$this->co_reg->db->sqldat($lp_in,'objtyp'),
																			$this->co_reg->db->sqldat($lp_in,'docrngcodint'),
																			$this->co_reg->db->sqldat($lp_in,'docrngcodext'),
																			$this->co_reg->db->sqldat($lp_in,'autcod'),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclsatr',false),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclsatrusr',false)
																		);
		$this->sysdata['sqltxt'] = 'SYS_DOC_CLS_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|09')){return false;}

    // convierto atributos JSON en ARRAY
    if ( $lp_action=='03' || $lp_action=='13' ) {
      $lp_out['sysdocclscnt'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['sysdocclscnt']??'[]'), true ));
      $lp_out['sysdocclsfle'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['sysdocclsfle']??'[]'), true ));
      $lp_out['sysdocclsfrm'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['sysdocclsfrm']??'[]'), true ));
      $lp_out['sysdocclsmsg'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['sysdocclsmsg']??'[]'), true ));
      $lp_out['sysdocclsrej'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['sysdocclsrej']??'[]'), true ));
      $lp_out['sysdocclsrsn'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['sysdocclsrsn']??'[]'), true ));
      $lp_out['sysdocclssts'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['sysdocclssts']??'[]'), true ));
      $lp_out['sysdocclstyptxt'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['sysdocclstyptxt']??'[]'), true ));        
      $lp_out['sysdocclswrk'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['sysdocclswrk']??'[]'), true ));     
		}
    
		return ($this->errcod==0?true:false);
	}
}
?>
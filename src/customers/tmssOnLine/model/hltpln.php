<?php
final class hltpln extends tmssAction2 {
	function initialize(){ $this->ID = 'plnid'; }
  
  // borra una fecha de la serie
	function deleteEvent( $lp_dat=array(), $lp_authCheck=true) {
		if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$this->data = $lp_dat;
		return $this->call_sp( '24', $this->data, $this->data );
  }
  
  // QUITAR DE LA SERIE. quita una fecha de la serie
  function removeFromSerie( $lp_dat=array() ){
		if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$this->data = $lp_dat;
		return $this->call_sp( '05', $this->data, $this->data );    
  }
  
	//  CALL SP.  llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
    $this->sysdata['erralt'] = $this->errtxt; 
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
                                     $this->co_reg->db->sqldat($lp_in, 'plnid'),
                                     $this->co_reg->db->sqldat($lp_in, 'plndteid'),
                                     $this->co_reg->db->sqldat($lp_in, 'cuscod'),
                                     $this->co_reg->db->sqldat($lp_in, 'patcod'),
                                     $this->co_reg->db->sqldat($lp_in, 'prscod'),
                                     $this->co_reg->db->sqldat($lp_in, 'spccod'),
                                     $this->co_reg->db->sqldte($lp_in, 'plndte'),
                                     $this->co_reg->db->sqldte($lp_in, 'plndteto'),
                                     $this->co_reg->db->sqldat($lp_in, 'plninbdte'),
                                     $this->co_reg->db->sqldat($lp_in, 'plnoutdte'),
                                     $this->co_reg->db->sqldat($lp_in, 'serid'),
                                     $this->co_reg->db->sqldat($lp_in, 'sercfg'),
                                     $this->co_reg->db->sqldat($lp_in, 'plndteatr'),
                                     $this->co_reg->db->sqldat($lp_in, 'plnqty'),
                                     $this->co_reg->db->sqldat($lp_in, 'plncmt'),
                                     $this->co_reg->db->sqldat($lp_in, 'docsts'),
                                     $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                     $this->co_reg->db->sqldat($lp_in, 'grpserid'),
                                     $this->co_reg->db->sqldte($lp_in, 'plncnfdte'),
                                     $this->co_reg->db->sqldat($lp_in, 'plnqtystk'),
                                     $this->co_reg->db->sqldat($lp_in, 'delcod'),
                                     $this->co_reg->db->sqldat($lp_in, 'sysdocclscod'),
                                     $this->co_reg->db->sqldat($lp_in, 'mdlcod'),
                                     $this->co_reg->db->sqldat($lp_in, 'prgcod'),
                                     $this->co_reg->db->sqldat($lp_in, 'buyexpdoc', false),
                                     $this->co_reg->db->sqldat($lp_in, 'plnstd', false)
																		);
		$this->sysdata['sqltxt'] = 'HLT_PLN_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
   	$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    //Carga de planificacion luego de grabar por primera vez
    if($lp_action=='01'){$this->data['plndteid'] = $lo_rs[0]['plndteid'];}
		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}

    // convierto atributos JSON en ARRAY
    if ( $lp_action=='03' || $lp_action=='13' ) {
      //$lp_out['plndtejsn'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['plndtejsn']??'[]'), true ));
      $lp_out['plnstd'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['plnstdjsn']??'[]'), true ));
      $lp_out['buyexp'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['buyexpjsn']??'[]'), true ));
    }    
    		
    return ($this->errcod==0?true:false);
	}
}
?>
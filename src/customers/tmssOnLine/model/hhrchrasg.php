<?php
final class hhrchrasg extends tmssAction2 {
  function initialize(){ $this->ID = 'hhrchrasgcod'; }

  // GET CLASS ATR. devuelve recordset con los atributos de todos los cargos según la clase 
  function getClassAtr( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
		$lo_out_data = array();
		if ( $this->call_sp( '17', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
																			$this->co_reg->db->sqldat($lp_in,'hhrchrasgcod'),
																			$this->co_reg->db->sqldat($lp_in,'hhrchrasgcodext'),
																			$this->co_reg->db->sqldat($lp_in,'srcobjtyp'),
																			$this->co_reg->db->sqldat($lp_in,'srcobjcod'),
																			$this->co_reg->db->sqldat($lp_in,'hhrchrtypcod'),
																			$this->co_reg->db->sqldte($lp_in,'hhrchrasgdtestr'),
																			$this->co_reg->db->sqldte($lp_in,'hhrchrasgdteend'),
																			$this->co_reg->db->sqldat($lp_in,'hhrchrasgatr',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'hhragrcod'),
																			$this->co_reg->db->sqldat($lp_in,'hhrlabunicod'),
																			$this->co_reg->db->sqlnum($lp_in,'hhrchrasgslr'),
																			$this->co_reg->db->sqldat($lp_in,'curcod'),
																			$this->co_reg->db->sqldat($lp_in,'hhroutrsncod'),
                                     	$this->co_reg->db->sqldat($lp_in,'hstatr',false),
																		);
		$this->sysdata['sqltxt'] = 'HHR_CHR_ASG_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|17')){return false;}
    
    // convierto atributos JSON en ARRAY
    if ( $lp_action=='03' || $lp_action=='13' ) {
      $lp_out['hstatr'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['hstatr']??'[]'), true ));
    }
    
    return ($this->errcod==0?true:false);
	}
}
?>
<?php
final class admhld extends tmssAction2 {
	const OBJTYP = 'ADM_HLD';
  function initialize(){ $this->ID = 'hldcod'; }
	
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['hldmov'] = array();
	}
	
  // GET MONTHLY LIST. obtiene los feriados del mes (parámetros hldday)
  function getMonthlyList( $lp_dat ) {
		$this->data = $lp_dat;
		$lo_out_data = array();
		if ( $this->call_sp( '23', $this->data, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }	
	
	// CALL SP. llamada a base de datos 
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'hldcod'),
                                      $this->co_reg->db->sqldat($lp_in,'hldday'),
                                      $this->co_reg->db->sqldat($lp_in,'hldtxt'),
                                      $this->co_reg->db->sqldat($lp_in,'lndcod'),
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                     	$this->co_reg->db->sqldat($lp_in,'hldmov', false)
                                    );
		$this->sysdata['sqltxt'] = 'ADM_HLD_DEF (?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    
		// si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|23')){return false;}
		
    // FECHAS. convierto atributos JSON en ARRAY
		if ($lp_action=='03' || $lp_action=='13') {
			$lp_out['hldmov'] = json_decode( utf8_encode($lp_out['hldmov']??'[]'), true );
		}
		
		return ($this->errcod==0?true:false);
	}
}
?>
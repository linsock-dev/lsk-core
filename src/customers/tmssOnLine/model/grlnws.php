<?php
final class grlnws extends tmssAction2 {
  function initialize(){ $this->ID = 'nwscod'; }
		
	//  CALL SP. Llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'nwscod'), 
																			$this->co_reg->db->sqldat($lp_in,'nwstxt',false), 
																			$this->co_reg->db->sqldte($lp_in,'nwsdte'),
																			$this->co_reg->db->sqldat($lp_in,'lngcod'),
																			$this->co_reg->db->sqldat($lp_in,'txttypcod'),
																			$this->co_reg->db->sqldat($lp_in,'nwsmsg',false), 
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options', false),
                                     	$this->co_reg->db->sqldat($lp_in,'sysdocclscod')
																		);
		$this->sysdata['sqltxt'] = 'GRL_NWS_DEF (?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);

		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
    
    //Recupera los cuerpos del texto
    if ( $lp_action=='03' && $this->errcod==0 ) {
      $lo_grldattxt = $this->co_reg->load->model('grldattxt');
      $lv_prm=array('vewfldflt'=>'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).$lp_in[$this->ID].chr(9).chr(9)
                                .'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'GRL_NWS'.chr(9).chr(9) );
			$lp_out['grlnwsbdy'] = $lo_grldattxt->getList( $lv_prm );
		}
		
		return ($this->errcod==0?true:false);
	}	
}
?>
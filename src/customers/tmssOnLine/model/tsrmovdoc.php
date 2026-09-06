<?php
final class tsrmovdoc extends tmssAction2 {
  function initialize(){ $this->ID = 'tsrmovdoccod'; }
		
	// CREATE. inicializa el objeto
	function create() {
		parent::create();
		$this->data['tsrmovdoccmp'] = array();
		$this->data['tsrmovdocval'] = array();
	}	

  // ACCOUNTING. contabiliza el documento
  function accounting( $lp_dat=array() , $lp_authCheck=true ) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( ($lp_authCheck?'09':'19'), $this->data, $lo_out_data );
  }
	
	//  CALL SP.  llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'tsrmovdoccod'), 
																			$this->co_reg->db->sqldat($lp_in,'tsrmovdoccodext'), 
																			$this->co_reg->db->sqldat($lp_in,'tsrmovdoctxt'), 
																			$this->co_reg->db->sqldte($lp_in,'tsrmovdocdte'), 
																			$this->co_reg->db->sqldat($lp_in,'srcobjtyp'), 
																			$this->co_reg->db->sqldat($lp_in,'srcobjcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'cshcod'),
																			$this->co_reg->db->sqlnum($lp_in,'tsrmovdoctot'), 
																			$this->co_reg->db->sqldat($lp_in,'curcod'), 
																			$this->co_reg->db->sqlnum($lp_in,'curexcrte',5), 
                                     	$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
																			$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
																			$this->co_reg->db->sqldat($lp_in,'sysdoctrecod'),
																			$this->co_reg->db->sqldat($lp_in,'tsrmovtypcod'),
																			$this->co_reg->db->sqldat($lp_in,'bnkacccod'),
																			$this->co_reg->db->sqldat($lp_in,'tsrmovdoccmp',false),
																			$this->co_reg->db->sqldat($lp_in,'tsrmpvdocval',false)
																		);
		$this->sysdata['sqltxt'] = 'TSR_MOV_DOC_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		
    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18')){return false;}
		
    // convierto atributos JSON en ARRAY
    if ( $lp_action=='03' || $lp_action=='13' ) {
      $lp_out['tsrmovdoccmp'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['tsrmovdoccmp']??'[]'), true ));
      $lp_out['tsrmovdocval'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['tsrmovdocval']??'[]'), true ));
		}
    		
		return ($this->errcod==0?true:false);
	}	
}
?>
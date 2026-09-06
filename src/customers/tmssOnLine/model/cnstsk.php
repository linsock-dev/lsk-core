<?php
final class cnstsk extends tmssAction2 {
  function initialize(){ $this->ID = 'cnstskcod'; }
	 // CREATE. inicializa el objeto   
  function create() { 
    parent::create();
    $this->data['cnstskrsk']    = array();
    $this->data['cnstskctr']    = array();
    $this->data['cnstskrskctr'] = array();

  }
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$lp_dat['cnstskatr'] = '<resnme>'.($lp_dat['cnstskatrresnme']??'').'</resnme>';
		return parent::save( $lp_dat, $lp_authCheck );
  }  
	
  // GET COMPONENTS. devuelve los
	function getComponents( $lp_key=array() ){
  	$lo_out_data = array();
    if( $this->call_sp( '28', $lp_key, $lo_out_data )){
      $this->data = $lo_out_data;
    } else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
  
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) { 
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'cnstskcod'), 
                                     	$this->co_reg->db->sqldat($lp_in,'cnstskcodext'), 
																			$this->co_reg->db->sqldat($lp_in,'cnstsktxt',false), 
                                     	$this->co_reg->db->sqlnum($lp_in,'matqty'),
                                     	$this->co_reg->db->sqldat($lp_in,'matuntcod'),
																			$this->co_reg->db->sqldat($lp_in,'docsts'),
																			$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
                                     	$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                     	$this->co_reg->db->sqldat($lp_in,'cnstskclscod'),
                                     	$this->co_reg->db->sqldat($lp_in,'cnstskatr',false),
                                      $this->co_reg->db->sqldat($lp_in,'rspobjtyp'),
                                      $this->co_reg->db->sqldat($lp_in,'rspobjcod'),
                                      $this->co_reg->db->sqldat($lp_in,'cnstskrskctr',false)
																		);
		$this->sysdata['sqltxt'] = 'CNS_TSK_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		
		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|28')){return false;}

    //		C O M P O N E N T E S
		if ( ($lp_action=='03' || $lp_action == '13') && $this->errcod==0 ) {
			$lo_cnstskmat = $this->co_reg->load->model('cnstskmat');
      $lv_prm = array('vewfldflt' => '[~fltrow~]tm.cnstskcod'.chr(9).'='.chr(9).chr(9).$lp_in['cnstskcod'].chr(9).chr(9));
			$lp_out['cnstskmat'] = $lo_cnstskmat->getList($lv_prm);
      
      $lp_out['cnstskrsk'] = $lp_out['cnstskrsk'] ?? '[]';
      $lp_out['cnstskctr'] = $lp_out['cnstskctr'] ?? '[]';
      // Riesgos y controles asociados     
      $lp_out['cnstskrsk'] = json_decode(utf8_encode($lp_out['cnstskrsk'] ?? '[]'), true) ?? [];
      $lp_out['cnstskctr'] = json_decode(utf8_encode($lp_out['cnstskctr'] ?? '[]'), true) ?? [];
    
    }
    
		return ($this->errcod==0?true:false);
	}
}
?>
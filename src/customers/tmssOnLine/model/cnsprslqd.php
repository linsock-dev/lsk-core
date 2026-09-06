<?php
final class cnsprslqd extends tmssAction2 {
  function initialize(){ $this->ID = 'cnsprslqdcod'; }
  
	// ACCOUNTING. contabiliza el documento
  function accounting( $lp_dat=array() , $lp_authCheck=true) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( ($lp_authCheck?'09':'19'), $this->data, $lo_out_data );
  }
	
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
                                    $this->co_reg->db->sqldat($lp_in,'cnsprslqdcod'),
                                    $this->co_reg->db->sqldat($lp_in,'srcobjtyp'),
                                    $this->co_reg->db->sqldat($lp_in,'srcobjcod001'),
                                    $this->co_reg->db->sqldat($lp_in,'srcobjtxt'),
                                    $this->co_reg->db->sqldte($lp_in,'cnsprslqddte'),
                                    $this->co_reg->db->sqldat($lp_in,'cnsprslqdtxt'),
                                    $this->co_reg->db->sqldte($lp_in,'cnsprslqdstrdte'),
                                    $this->co_reg->db->sqldte($lp_in,'cnsprslqdenddte'),
                                    $this->co_reg->db->sqldat($lp_in,'cnsprslqdtot'),
                                    $this->co_reg->db->sqldat($lp_in,'docsts'),
                                    $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                    $this->co_reg->db->sqldat($lp_in,'cnsprslqdatr001'),                                    
                                    $this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                    $this->co_reg->db->sqldat($lp_in,'cnsprslqdopnsrvids',false)
                          );
    $this->sysdata['sqltxt'] = 'CNS_PRS_LQD_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		//var_dump($this->sysdata['sqlstm']);
    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|23|33')){return false;}

    //	PRESTACIONES LIQUIDADAS
    if ( $lp_action == '03' || $lp_action == '13' ) {
      // obtengo gastos liquidados
      $lv_prm = array( 'cnsprslqdcod'=>$this->data['cnsprslqdcod'] );
      $lv_lqdmdl = $this->co_reg->load->model( 'cnsprslqd' );
      $lo_srv = $lv_lqdmdl->getServices( array(), $lv_prm );
      $this->data['srv'] = $lo_srv;
    }

    return ($this->errcod==0?true:false);
	}
}
?>
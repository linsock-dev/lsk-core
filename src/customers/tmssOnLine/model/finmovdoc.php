<?php
final class finmovdoc extends tmssAction2 {
  function initialize(){ $this->ID = 'finmovdoccod'; }
		
	// CREATE. inicializa el objeto
	function create( $lp_data=array() ) {
		parent::create();
		$this->data['finmovdocacc'] = array();
	}	
	
  // ACCOUNTING. contabiliza el documento
  function accounting( $lo_dat=array(), $lp_authCheck=true ) {
    if( count($lo_dat)==0 ) { $lo_dat = $this->co_reg->request->post; }
		$this->data = $lo_dat;
		
    // modelos para userexit
    $lv_finmovdoccod = $this->data['finmovdoccod'];
    $lo_mdl_prv = $this->co_reg->load->model('finmovdoc');
    if ( $lv_finmovdoccod!='' ) { $lo_mdl_prv->load( array('finmovdoccod'=>$lv_finmovdoccod) ); }
    $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
    $lo_docclsmdl->load(array('sysdocclscod'=>$this->data['sysdocclscod']), false);
    
    // UserExit BeforeSave Accounting ----------------------------------------------------
    $lv_uexit = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr , 'uexit_beforeacc');
    $lv_prm = array('action'=>'ACCOUNTING',
                    'data'=>&$this->data,
                   	'mdlprv'=>$lo_mdl_prv);
    if ( $this->co_reg->document->callUserExit($lv_uexit, $lv_prm) ) {
      $lv_usrret = $this->co_reg->document->retUserExit;
      if (isset($lv_usrret['errtyp']) && $lv_usrret['errtyp']!='S') { 
        $this->errtyp = $lv_usrret['errtyp'];
        $this->errcod = $lv_usrret['errcod'];
        $this->errtxt = $lv_usrret['errtxt'];     
        return false;
      }
    }
    // -----------------------------------------------------------------------
		
		// CONTABILIZACION
		$lo_out_data = array();
		if( !$this->call_sp( ($lp_authCheck?'09':'19'), $this->data, $this->data ) ){
			return false;
		}
		
    // UserExit AfterSave Accounting ----------------------------------------------------
    $lv_uexit = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr , 'uexit_afteracc');
    $lv_prm = array('action'=>'ACCOUNTING',
                    'data'=>$this->data,
                   	'mdlprv'=>$lo_mdl_prv);
    if( $this->co_reg->document->callUserExit($lv_uexit, $lv_prm) ) {
      $lv_usrret = $this->co_reg->document->retUserExit;
      if(isset($lv_usrret['errtyp']) && $lv_usrret['errtyp']!='S') { 
        $this->errtyp = $lv_usrret['errtyp'];
        $this->errcod = $lv_usrret['errcod'];
        $this->errtxt = $lv_usrret['errtxt'];
      }
    }
    // -----------------------------------------------------------------------
		
		return true;
  }
	
	//  CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod,
                                     	$this->co_reg->db->sqldat($lp_in,'finmovdoccod'),
                                     	$this->co_reg->db->sqldat($lp_in,'finmovdoccodext'),
                                     	$this->co_reg->db->sqldat($lp_in,'finmovdoctxt'),
                                     	$this->co_reg->db->sqldte($lp_in,'finmovdocdte'),
                                     	$this->co_reg->db->sqldte($lp_in,'finmovdocaccdte'),
                                     	$this->co_reg->db->sqldat($lp_in,'accobjtyp'),
                                     	$this->co_reg->db->sqldat($lp_in,'accobjcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'srcobjtyp'),
                                     	$this->co_reg->db->sqldat($lp_in,'srcobjcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                     	$this->co_reg->db->sqldat($lp_in,'curcod'),
                                     	$this->co_reg->db->sqlnum($lp_in,'curexcrte',3),
                                     	$this->co_reg->db->sqldat($lp_in,'docsts'),
                                     	$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
                                     	$this->co_reg->db->sqldat($lp_in,'finmovdocacc'),
																		);
		$this->sysdata['sqltxt'] = 'FIN_MOV_DOC_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
	
    //Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|33')){return false;}    
		
		// CUENTAS. cargo cuentas del documento
		if( ($lp_action=='03' or $lp_action=='13') && $this->errtyp!='E'){
			$this->call_sp( '33', $lp_in, $this->data['finmovdocacc'] );
		}
		
		return ($this->errcod==0?true:false);
	}	
}
?>
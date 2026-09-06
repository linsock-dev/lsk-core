<?php   
final class buyexp extends tmssAction2 { 
	function initialize(){ $this->ID = 'buyexpcod'; }
	
	// CREATE. inicializa el objeto
	function create() {
    parent::create();
		$this->data['buyexpdoc'] = array();
		$this->data['buyexpdocimp'] = array();
	}
  
  // ACCOUNTING CANCEL. contabiliza el documento
  function accountingCancel( $lp_dat=array(), $lp_authCheck=true ) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
		
    // modelos para userexit
    $lv_buyexpcod = $this->data['buyexpcod'];
    $lo_mdl_prv = $this->co_reg->load->model('buyexp');
    if ( $lv_buyexpcod!='' ) { $lo_mdl_prv->load( array('buyexpcod'=>$lv_buyexpcod) ); }
    $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
    $lo_docclsmdl->load(array('sysdocclscod'=>$lo_mdl_prv->sysdocclscod), false);
    
    // UserExit BeforeSave Accounting Cancel ----------------------------------
    $lv_uexit = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr , 'uexit_beforeaccdel');
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
    // ----------------------------------------------------------------------
		
		$lo_out_data = array();
		if( !$this->call_sp( ($lp_authCheck?'29':'39'), $this->data, $lo_out_data ) ){
			return false;
		}

    // UserExit AfterSave Accounting Cancel -----------------------------------------
    $lv_uexit = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr , 'uexit_afteraccdel');
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
  //Recupero detalle de gasto
 	function getListDoc( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null) {
		if($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '28', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
			$this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
		return $this->data;
	}
	//Recupero imputaciones del gasto
  function getListImp( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null) {
		if($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '38', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
			$this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
		return $this->data;
	}
	// CALL SP. llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
																			$this->co_reg->db->sqldat($lp_in,'buyexpcod'),
																			$this->co_reg->db->sqldat($lp_in,'buyexpcodext'),
                                      $this->co_reg->db->sqldat($lp_in,'buyexptxt'),
                                      $this->co_reg->db->sqldte($lp_in,'buyexpdte'), 
                                      $this->co_reg->db->sqldat($lp_in,'srcobjtyp'), 
																			$this->co_reg->db->sqldat($lp_in,'srcobjcod'), 
                                      $this->co_reg->db->sqldat($lp_in,'docsts'),
                                      $this->co_reg->db->sqldat($this->sysdata, 'view_options', false),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
                                     	$this->co_reg->db->sqlnum($lp_in,'buyexptot',0), 
                                      $this->co_reg->db->sqldat($lp_in,'curcod'),
                                      $this->co_reg->db->sqldat($lp_in,'sysdocrejcod'),
                                     	$this->co_reg->db->sqldat($lp_in,'buyexpatr'),
                                     	$this->co_reg->db->sqldat($lp_in,'buyexpdoc',false),
                                     	$this->co_reg->db->sqldat($lp_in,'buyexpdocimp',false)
																		);
    
		$this->sysdata['sqltxt'] = 'BUY_EXP_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,null,null,null,?,?)';
		$this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);

    $lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
    
		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|28|38')){return false;}
    
    // convierto atributos JSON en ARRAY
    if ( $lp_action=='03' || $lp_action=='13' ) {
      $lp_out['buyexpdoc'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['buyexpdoc']??'[]'), true ));
      $lp_out['buyexpdocimp'] = array_map(function($i){return array_change_key_case($i);}, json_decode( utf8_encode($lp_out['buyexpdocimp']??'[]'), true ));
    }    
    
		return ($this->errcod==0?true:false);
	}
}
?>
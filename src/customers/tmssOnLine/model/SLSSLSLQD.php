<?php
final class slsslslqd extends tmssAction2 {
  function initialize(){ $this->ID = 'slsslslqdcod'; }
	// obtiene insumos abiertos desde la SP
  function getOpenServices($lp_vewopt=array(), $lp_prm=array(), $lo_vew=null) {
    if($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
    $this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
    
    $lo_out_data = array();
		// llamada a SP para obtener insumos 
    if ( $this->call_sp('38', $lp_prm, $lo_out_data) ) {
      $this->data = $lo_out_data;
    } else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
    }
    return $this->data;
  }

  // CREATE. inicializa el objeto
  function create() {
    parent::create();
		$this->data['slsslslqddoc'] = array();
	}
  // SAVE. graba el objeto
  function save( $lp_dat=array(), $lp_authCheck=true ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }		
		$lp_dat['slsslslqdatr001']= '<strdte>'.($lp_dat['slsslslqdstrdte']??'').'</strdte>'.
																'<enddte>'.($lp_dat['slsslslqdenddte']??'').'</enddte>';
		return parent::save( $lp_dat, $lp_authCheck );
  }  
	
  // UPDATETOTAL. actualiza el total de cabecera del documento basado en los documentos asignados
  function updateTotal( $lp_dat=array() ) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( '05', $this->data, $this->data );
  }
	
  // ACCOUNTING. contabiliza el documento
  function accounting( $lp_dat=array(), $lp_authCheck=true ) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
		$lo_out_data = array();
		return $this->call_sp( ($lp_authCheck?'09':'19'), $this->data, $lo_out_data );
  }	
	// obtiene detalle guardado del documento
  function getDetailById($slsslslqdcod){
      $out = [];
      $this->call_sp('03',['slsslslqdcod' => $slsslslqdcod], $out);
    	// el detalle viene en JSON desde SP
      if (!empty($out['slsslslqddoc'])) {
        return json_decode($out['slsslslqddoc'], true);
      }
      return [];
    }
	//  CALL SP.  llamada a base de datos
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
    	
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
															$this->co_reg->db->sqldat($lp_in,'slsslslqdcod'), 
															$this->co_reg->db->sqldat($lp_in,'slsslslqdtxt'), 
															$this->co_reg->db->sqldte($lp_in,'slsslslqddte'), 
															$this->co_reg->db->sqldte($lp_in,'slsslslqdstrdte'), 
															$this->co_reg->db->sqldte($lp_in,'slsslslqdenddte'), 
															$this->co_reg->db->sqldat($lp_in,'cuscod'),				
															$this->co_reg->db->sqldat($lp_in,'docsts'),                              
															$this->co_reg->db->sqldat($lp_in,'slsslslqddoc'),
															$this->co_reg->db->sqldat($this->sysdata,'view_options',false),
															$this->co_reg->db->sqldat($lp_in,'sysdocclscod'),
															$this->co_reg->db->sqldat($lp_in,'slsslslqdatr001',false),
															$this->co_reg->db->sqldat($lp_in,'sysdocrejcod'),
                              $this->co_reg->db->sqldat($lp_in,'refdoccls')         
														);

		$this->sysdata['sqltxt'] = 'SLS_SLS_LQD_DEF (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );

    
		//Si hubo error del recordset finalizar ejecucion
		if(!$this->chkError($lp_action, $lo_rs, $lp_out,'08|18|38')){return false;}
    return ($this->errcod==0?true:false);
	}
}
?>
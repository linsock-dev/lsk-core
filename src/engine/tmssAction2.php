<?php
abstract class tmssAction2 {
	protected $co_reg;
	protected $data = array();
	protected $sysdata = array();
	protected $ID;
	protected $ID2;
	
	function __construct( &$lp_reg ) { 
		$this->co_reg = $lp_reg;
		$this->errcod = 0;
		$this->errtyp = 'S';
		$this->errtxt = '';
    $this->errmsg = '';
    $this->errvar = '';
    $this->errtch = '';
		$this->errjva = '';
		$this->initialize();
	}
	 
	function __get( $lp_key ) { return $this->data[$lp_key] ?? '' ; }
	function get( $lp_key ) { return $this->data[$lp_key] ?? '' ; }
	function getData(){ return $this->data; }
	function getsysdata( $lp_key ) { return  $this->sysdata[$lp_key]??'' ; }
	function __set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function setData( $lp_dat=array() ) { $this->data = $lp_dat; }	
  
  // Este initialize es la nueva forma de guardar el dato de SELF::ID simplemente en el modelo nuevo hay que agregar una funcion de este estilo:
	//  function initialize(){ $this->ID = 'hhrliccod'; } y cambiar los lugares donde se utilize self::ID por $this->ID
	function initialize(){ $this->ID=''; $this->ID2=''; }
	
  
  
	// CREATE - inicializa array de clase
	function create() {
		$this->data = array();
		$this->sysdata = array();
	}	
	
  
  
	// SAVE - graba el objeto
	/* Si es posible hacer dentro del save hijo parent::save($lp_dat,$lp_authCheck)
	 con lp_dat actualizado con los datos necesarios */
	function save( $lp_dat=array(), $lp_authCheck=true ) {
		if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$this->data = $lp_dat;
		$lv_act = ( (isset($lp_dat[$this->ID]) && !empty($lp_dat[$this->ID])) ? ($lp_authCheck?'02':'12') : ($lp_authCheck?'01':'11') );
		$lo_out_data = array(); 
		$lv_uexitbef = '';
		$lv_uexitaft = '';
		$lv_workflows = array();
		$lv_objtyp = '';
    $lv_docfld = array();
		
		// USEREXIT (Before y After) - WORKFLOWS
    if(($this->data['sysdocclscod']??'')!='' && $this->ID != 'sysdocclscod'){
      // Obtiene el modelo de la clase de documento
      $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
      $lo_docclsmdl->load( array('sysdocclscod'=>$this->data['sysdocclscod']) );
			
			// WORKFLOWS. obtiene workflows de la clase
			$lv_workflows = $lo_docclsmdl->sysdocclswrk;
			$lv_objtyp = $lo_docclsmdl->objtyp;
		
      // USEREXIT. Obtiene el tagValue de before y after(el de la vista)
      // Si existe alguno de los tag y no es vacio, cargo el modelo previo al save para posteriormente usarlo en uexit
      $lv_uexitbef = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr , 'uexit_beforesave');
      $lv_uexitaft = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr , 'uexit_aftersave');
      
      // obtengo campos de la clase de documento y los convierto en array
      $lv_fields_jsn = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr , 'sysdocclsfld');
      if( $lv_fields_jsn != '' ){ $lv_docfld = json_decode( $lv_fields_jsn , true ); }      
      
			$lv_dataID = ($this->data[$this->ID]??'');
      if( $lv_uexitbef != '' || $lv_uexitaft != '' || count($lv_docfld)>0 ){
        $lo_mdl_prv = $this->co_reg->load->model(get_class($this)); //Modelo base
        if ( $lv_dataID!='' ) { $lo_mdl_prv->load(array($this->ID=>$lv_dataID) ); } //Si no esta vacio el data cargo el modelo correspondiente
      }      
    }
		
		/*Si existe alguno de los tags entonces hace los userexit.
		En el caso del before si hay algun problema lo controlo 
		mediante el if del store procedure con el codigo de error*/
  
		// USEREXIT BEFORE SAVE. Llamo al userexit beforesave y chequeo error
		if($lv_uexitbef != ''){if(!$this->userExit($lv_act, $lo_mdl_prv,$lv_uexitbef)){ return false;} }
		
		// GRABADO. Llamo al grabado y chequeo error
		if(!$this->call_sp( $lv_act, $this->data, $lo_out_data ) ){return false;}
		
		// USEREXIT AFTER SAVE. Llamo al userexit aftersave
		if($lv_uexitaft != ''){$this->userExit($lv_act, $lo_mdl_prv,$lv_uexitaft);}

		// WORKFLOW. se ejecuta validacion/inicialización de workflows
		if( count($lv_workflows)>0 ){
			$lo_wrkmdl = $this->co_reg->load->model('grldatwrk');
			foreach($lv_workflows as $lv_rowwrk){
				$lv_prm = array('srcobjtyp'=>$lv_objtyp,
												'srcobjcod001'=>$this->data[$this->ID],
												'srcobjcod002'=>($this->data[$this->ID2]??''),
												'sysdocclscod'=>$this->data['sysdocclscod'],
												'wrkflwcod'=>$lv_rowwrk['wrkflwcod'],
                        'relsts'=> 'S',
                        'docsts'=>'A',                        
												'data'=>$this->data);
				$lo_wrkmdl->trigger( $lv_act,$lv_prm );
			}
    }
     
    // CONTROL DE CAMBIOS. 
    if(($this->data['sysdocclscod']??'')!='' && count($lv_docfld)>0){
  		$lv_chgtxt = '';
      // verifico si hay algun campo marcado con con control de cambios
      foreach( $lv_docfld as $lv_rowfld){
        if( $lv_rowfld['fldchglog']??''!='' ){
          $lv_fldcod = $lv_rowfld['fldcod']??'';
          $lv_newval = ($lv_fldcod!=''?utf8_decode($this->data[$lv_fldcod]??''):'');
          $lv_oldval = ($lv_fldcod!=''?($lo_mdl_prv->data[$lv_fldcod]??''):'');
          if( strtolower($lv_oldval)!=strtolower($lv_newval) ){ $lv_chgtxt .= '<atr><nme>'.$lv_fldcod.'</nme><old>'.$lv_oldval.'</old><new>'.$lv_newval.'</new></atr>'; }
        }
      }
      // Grabado log de cambios
      if( $lv_chgtxt!='' ){
        $lo_docchgmdl = $this->co_reg->load->model('sysdocchg');
        $lv_prm = array('chgdocsrctyp'=>$lv_objtyp, 'chgdocsrccod'=>$this->data[$this->ID], 'chgdocatr'=>$lv_chgtxt, 'docsts'=>'A');
        $lo_docchgmdl->save( $lv_prm );
      }
    }
		
    return true;
	}
	
  
  
	// LOAD - carga el objeto
	function load( $lp_key=array(), $lp_authCheck=true ) {
		return $this->call_sp(($lp_authCheck?'03':'13') , $lp_key, $this->data );
	}
	
  
  
	// DELETE - borra objeto
	function delete( $lp_dat=array(), $lp_authCheck=true) {
		if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
		$this->data = $lp_dat;
		return $this->call_sp( ($lp_authCheck?'04':'14'), $this->data, $this->data );
    //Talvez habria que agregar luego el caso en el que cuando se borra algo tambien se borren alguno de sus documentos asociados.
		//Hablese de Workflows, Formularios,etc...
	}
	
	// GET LIST. devuelve un recordset
  // El autcheck hace referencia a si es necesearia una autorizacion por parte del que hace el llamado
  //(false si es sistema interno, true si necesitan las autorizaciones), hay storedProcedures que no tienen el cod 18 incluido, por si sucede algun error.
	function getList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null, $lp_authCheck=true ) {
		if($lo_vew==null) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
    //Al tener declarado que dependiendo del authCheck el retorno es uno u otro.
		//sucede que hay call_sp que no tienen la actividad 18 como vuelta de de RS y al utilizar el chkError solo con 08 esto rompe el getList
		if ( $this->call_sp( ($lp_authCheck?'08':'18'), $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
			$this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
		return $this->data;
	}
	
  
  
  // ACCOUNTING. contabiliza el documento
  function accounting( $lp_dat=array(), $lp_authCheck=true ) {
    $lo_dat = (count($lp_dat)>0?$lp_dat:$this->co_reg->request->post);
		$this->data = $lo_dat;
    $lv_dataID = ($this->data[$this->ID]??'');   
    $lv_act = $lp_authCheck?'09':'19';
    $lo_mdl_prv = $this->co_reg->load->model(get_class($this)); //Modelo base
    if ( $lv_dataID!='' ) { $lo_mdl_prv->load(array($this->ID=>$lv_dataID) ); } //Si no esta vacio el data cargo el modelo correspondiente
   
    // USEREXIT (Before y After)
    if(($lo_mdl_prv->sysdocclscod??'')!=''){
      // Obtiene el modelo de la clase de documento
      $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
      $lo_docclsmdl->load( array('sysdocclscod'=>$lo_mdl_prv->sysdocclscod) );

      // USEREXIT. Obtiene el tagValue de before y after(el de la vista)
      // Si existe alguno de los tag y no es vacio, cargo el modelo previo al save para posteriormente usarlo en uexit
      $lv_uexitbef = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr , 'uexit_beforeacc');
      $lv_uexitaft = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr , 'uexit_afteracc');

    }
    
		// USEREXIT BEFORE ACCOUNTING. Llamo al userexit beforeaccounting y chequeo error
		if($lv_uexitbef != ''){if(!$this->userExit($lv_act, $lo_mdl_prv,$lv_uexitbef)){ return false;} }
		
		// CONTABILIZACION. Llamo al grabado y chequeo error		
		if(!$this->call_sp($lv_act, $this->data, $lo_out_data ) ){ return false; }
    
		// USEREXIT AFTER ACCOUNTING. Llamo al userexit afteraccounting
		if($lv_uexitaft != ''){$this->userExit($lv_act, $lo_mdl_prv,$lv_uexitaft);}
    
		return true;
  }
  
  
  
	// CALL_SP. ejecuta un Store procedure.
  //Esta funcion existe para luego hacerle un overload dentro de cada modelo con su forma de store procedure determinada.
  //Es necesario que en el modelo el CALL_SP sea PROTECTED y no PRIVATE como actualmente todos los modelos son.
	protected function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp='E';
		$this->errcod=-1;
		$this->errtxt='Metodo de clase no declarado.';
		return false;
	}
	
	// CHKERROR. valida la ejecución de un SP
	// lp_action: operacion ejecutada
	// lp_rs: recorset a verificar
	// lp_out: array de salida
	// lp_actrs: operaciones action que devuelven recordset
  // Ejemplo :
  // $this->chkError($lp_action, $lo_rs, $lp_out, '08|18|13|14|23|24|33'); en las comillas simples van todas las acciones que devuelvan recordset
  protected function chkError($lp_action, $lp_rs, &$lp_out, $lp_actrs){	
    $this->errcod = 0;
		// si es un recordset, lo devuelve (segun la operacion)
		if(strpos($lp_actrs, $lp_action) !== false){
			$lp_out = $lp_rs;
		// para los registros individuales:
		}else {			
			$this->errcod = intval($lp_rs[0]['errcod']??0);
			$this->errtyp = (($lp_rs[0]['errtyp']??'')!='' ? $lp_rs[0]['errtyp'] : ($this->errcod!=0?'E':'S'));
			$this->errtxt = $lp_rs[0]['errtxt']??'';
			$this->errmsg = $lp_rs[0]['errmsg']??'';
			$this->errvar = $lp_rs[0]['errvar']??'';
			$this->errtch = $lp_rs[0]['errtch']??'';
			if( $this->errmsg!='' ){
				$this->errtxt = $this->co_reg->language->message( $this->errmsg, explode(chr(9),$this->errvar) );
			}
      if ( $lp_rs && count($lp_rs)>0 ) {
				if( $this->errtyp!='E' ){
          $lp_out = $lp_rs[0];
          $this->data[$this->ID] = ($lp_out[$this->ID]??array_values($lp_out)[0]);
          $this->errcod = intval($lp_rs[0]['errcod']??0);
        }
			}else{
        $this->errtyp = 'E';
        $this->errcod = -9999;
        $this->errtxt = $this->co_reg->language->message('UnexpectedError', $this->sysdata['sqlstm'] );				
      }
		}
		
		return ($this->errcod==0?true:false);
	}
  
	

	// userExit Llama y valida la ejecucion de un callUserExit
	// lp_act => Accion ejecutada
	// lp_mdl_prv => Modelo previo guardado
	// lp_uexit => tagValue del before o after
	private function userExit($lp_act,$lp_mdl_prv,$lp_uexit){
			$lv_prm = array('action'=>($lp_act=='01' || $lp_act=='11'?'NEW':($lp_act=='09' || $lp_act=='19'?'ACCOUNTING':'UPDATE')),
											'data'=>&$this->data,
											'mdlprv'=>$lp_mdl_prv);
			if ( $this->co_reg->document->callUserExit($lp_uexit, $lv_prm) ) {
					$lv_usrret = $this->co_reg->document->retUserExit;
					if( isset($lv_usrret['errtyp']) && ($lv_usrret['errtyp']??'')!='S') { 
							$this->errtyp = ($lv_usrret['errtyp']??'E');
							$this->errcod = ($lv_usrret['errcod']??0);
							$this->errtxt = ($lv_usrret['errtxt']??'');
							$this->errjva = ($lv_usrret['errjva']??'');
              $this->errmsg = ($lv_usrret['errmsg']??'');
              $this->errvar = ($lv_usrret['errvar']??'');
              $this->errtch = ($lv_usrret['errtch']??'');
							return false;
					}
			}
		return true;
	}
}
?>
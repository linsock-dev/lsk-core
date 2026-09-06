<?php
final class grldatwrk extends tmssAction {
  protected $co_reg;
  private $data = array();
	private $sysdata = array();
	const ID = 'wrkflwdatcod';
	
  function __construct( &$lp_reg ) { $this->co_reg = $lp_reg; }
	function __get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function get( $lp_key ) { return ( isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' ); }
	function getData(){ return $this->data; }
	function getsysdata( $lp_key ) { return ( isset($this->sysdata[$lp_key]) ? $this->sysdata[$lp_key] : '' ); }
	function __set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }
	function setData( $lp_dat=array() ) { $this->data = $lp_dat; }	
	
	// CREATE. inicializa el objeto
	function create() {
		$this->data = array();
		$this->sysdata = array();
	}
	
  // SAVE. graba el objeto
  function save( $lp_dat=array() ) {
    if ( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
    $lv_act = ( isset($lp_dat[self::ID]) && !empty($lp_dat[self::ID]) ? '02' : '01' );
		$lo_out_data = array();
		return $this->call_sp( $lv_act, $this->data, $lo_out_data );
  }
  
  // LOAD. carga el objeto
  function load( $lp_key=array() ) {
		return $this->call_sp( '03', $lp_key, $this->data );
  }
  
  // DELETE. borra objeto
  function delete( $lp_dat=array() ) {
    if( count($lp_dat)==0 ) { $lp_dat = $this->co_reg->request->post; }
    $this->data = $lp_dat;
		return $this->call_sp( '04', $this->data, $this->data );
  }
	
  // GET LIST. devuelve recordset de objetos
  function getList( $lp_vewopt=array(), $lp_prm=array(), $lo_vew=null ) {
    if( $lo_vew==null ) { $lo_vew = $this->co_reg->load->model('grlvew'); }
		$this->sysdata['view_options'] = $lo_vew->parseViewOptions($lp_vewopt);
		$lo_out_data = array();
		if ( $this->call_sp( '08', $lp_prm, $lo_out_data ) ) {
			$this->data = $lo_out_data;
		} else {
      $this->sysdata['sqlerr'] = $this->co_reg->db->getLastErrorMessage();
		}
    return $this->data;
  }
	
	
	// TRIGGER. determina si un workflow es aplicable y verifica condiciones y acciones
	public function trigger( $lp_action, $lp_prm ){ //Habria que no crear los pasos si es que el workflow no cumple condiciones de inicio, no es un error perse pero a tener en cuenta.
	
		// cargo definicion de workflow
		$lo_syswrkmdl = $this->co_reg->load->model('sysdocwrk');
		if( $lo_syswrkmdl->load( array('wrkflwcod'=>$lp_prm['wrkflwcod']) )==false ){
			$this->errtyp=$lo_syswrkmdl->errtyp;
			$this->errcod=$lo_syswrkmdl->errcod;
			$this->errtxt=$lo_syswrkmdl->errtxt;
			return false;
		}
		
		// busco si existe algun workflow para el documento
		$lo_datwrkmdl = $this->co_reg->load->model('grldatwrk');
		$lo_datwrkstpmdl = $this->co_reg->load->model('grldatwrkstp');
    $lv_verval = array('errtyp'=>'S');
    $lv_fndwrkflw = false;
		if($lo_datwrkmdl->load( $lp_prm ) ){
			if($lp_action == '001'){
        // *****************************************
        // FALTA: hay un workflow, se debe hacer algo???
        // - es una modificacion?. afecta en algo a lo ya ejecutado / aprobado?
        // - si cambiaron las condiciones que se hace con los pasos ya ejecutados / aprobados?
        // *****************************************
      }
      $lv_fndwrkflw=true;
		} else if($lo_syswrkmdl->docsts=='A'){	
      // no hay workflow para el documento, se ejecuta verificación de condicion
      // si es correcta, se crea workflow
			$lv_typ = $this->co_reg->document->getTagValue( $lo_syswrkmdl->wrkflwcnd , 'typ' );
			$lv_val = $this->co_reg->document->getTagValue( $lo_syswrkmdl->wrkflwcnd , 'val' );
      $lv_verval = $this->verifyCondition( $lv_typ, $lv_val, $lp_prm['data']);
			if( $lv_verval['errtyp'] == 'S' ){
				if( $lo_datwrkmdl->save( $lp_prm )==false ){
					// *****************************************
					// que efecto produce si no se graba el workflow????
					// *****************************************
					$this->errtyp = $lo_datwrkmdl->errtyp;
					$this->errcod = $lo_datwrkmdl->errcod;
					$this->errtxt = $lo_datwrkmdl->errtxt;
					return false;
				}
				// INICIO. ejecutar acciones de inicio del workflow
				$lv_wrkobj = array('typ'=>'workflow', 'sts'=>$lo_datwrkstpmdl->relsts, 'code'=>$lp_prm['wrkflwcod'], 'datcode'=>$lo_datwrkmdl->wrkflwdatcod);
				if( is_array($lo_syswrkmdl->sysdocwrkact??array()) ){
         	foreach($lo_syswrkmdl->sysdocwrkact as $lv_row){
            if( intval($lv_row['wrkflwstpcod'])==0 && $lv_row['wrkflwactevt']=='STR' ){
							$lv_act = array('typ'=>$lv_row['wrkflwacttyp'], 'val'=>$lv_row['wrkflwactval']);
							$lv_rtaact = $this->executeAction($lv_act, $lv_wrkobj, ($lp_prm??array()) , $lo_datwrkmdl->wrkflwdatcod);
							/*
							if($lv_rtaact['errtyp']!='S'){
								$lo_logmdl = $this->co_reg->load->model('sysapplog');
								$lo_logmdl->save( array('srcobjtyp'=>'GRL_WRK','srcobjcod001'=>'1','docsts'=>$lv_rtact['errtyp'],'applogtxt'=>$lv_rtaact['errtxt']) );
							}
							*/
							// *****************************************
							// faltaria informar al usuario que se produjo un error
							// *****************************************
						}
					}
        }
      }	
    }
    
		// PASOS. Valida condiciones y acciones
    $lo_wrkstp = $lo_syswrkmdl->sysdocwrkstp;
    if(isset($lo_wrkstp) && is_array($lo_wrkstp) && $lv_verval['errtyp']=='S' && !$lv_fndwrkflw){
      foreach($lo_wrkstp as $lv_rowstp){
        //Valida condicion de inicio
        $lv_typ = $this->co_reg->document->getTagValue( $lv_rowstp['wrkflwstpcnd'], 'typ' );
        $lv_val = $this->co_reg->document->getTagValue(	$lv_rowstp['wrkflwstpcnd'], 'val' );
        $lv_verval = $this->verifyCondition( $lv_typ, $lv_val, $lp_prm['data']);
        //Si la condicion de inicio se cumple prosigue con el añadido del paso.
        if( $lv_verval['errtyp'] == 'S' ){
          $lv_prmstp = array('wrkflwstpdatcod'=>($lp_prm['wrkflwstpdatcod']??''),
															'wrkflwdatcod'=>$lo_datwrkmdl->wrkflwdatcod,
															'wrkflwstpcod'=>$lv_rowstp['wrkflwstpcod'],
															'docsts'=>'A',
															'relsts'=>($lp_prm['stprelsts']??'S'));
          if( $lo_datwrkstpmdl->save( $lv_prmstp )==false ){
            // *****************************************
            // que efecto produce si no se graba el paso del workflow????
            // *****************************************
            $this->errtyp = $lo_datwrkstpmdl->errtyp;
            $this->errcod = $lo_datwrkstpmdl->errcod;
            $this->errtxt = $lo_datwrkstpmdl->errtxt;
            return false;
          } else {
						$lo_datwrkstpmdl->load( array('wrkflwstpdatcod'=>$lo_datwrkstpmdl->wrkflwstpdatcod) );
					}
          // PASOS. INICIO. ejecutar acciones de inicio del paso
					$lv_wrkobj = array('typ'=>'step', 'sts'=>$lo_datwrkstpmdl->relsts, 'code'=>$lp_prm['wrkflwcod'], 'datcode'=>$lo_datwrkstpmdl->wrkflwstpdatcod);
          if( is_array($lo_syswrkmdl->sysdocwrkact??array()) ){
            foreach($lo_syswrkmdl->sysdocwrkact as $lv_rowact){
							if( intval($lv_rowact['wrkflwstpcod'])==intval($lv_rowstp['wrkflwstpcod']) && $lv_rowact['wrkflwactevt']=='STR' ){
								$lv_act = array('typ'=>$lv_rowact['wrkflwacttyp'], 'val'=>$lv_rowact['wrkflwactval']);
								$lv_rtaact = $this->executeAction($lv_act, $lv_wrkobj, ($lp_prm??array()), $lo_datwrkstpmdl->wrkflwdatcod);
								// *****************************************
								// que efecto produce si no se puede ejecutar la accion de inicio????
								// *****************************************
							}
            }
          }
					
        }    
      }
    }
		
  }
	
  
  
  //RELEASESTEP. Funcion que se encarga de ejecutar acciones de liberacion y rechazo de pasos y workflows.
	public function releaseStep($lp_prm){
  	//Cargo el modelo del paso
		$lo_datwrkstpmdl = $this->co_reg->load->model('grldatwrkstp');
    //Cargo el paso para revisar si existe
    if($lo_datwrkstpmdl->load(array('wrkflwstpdatcod'=>$lp_prm['wrkflwstpdatcod']))==false){
       $this->errtyp = $lo_datwrkstpmdl->errtyp;
       $this->errcod = $lo_datwrkstpmdl->errcod;
       $this->errtxt = $lo_datwrkstpmdl->errtxt;
       return false;
    }
    //Cambio el estado del paso dependiendo de lo elegido.
   	$lv_prmstp = array('wrkflwstpdatcod'=>($lp_prm['wrkflwstpdatcod']??''),'wrkflwdatcod'=>$lp_prm['wrkflwdatcod'],'wrkflwstpcod'=>$lp_prm['wrkflwstpcod'],'docsts'=>'A','relsts'=>$lp_prm["stprelsts"]);
    if($lo_datwrkstpmdl->save($lv_prmstp) == false){
     //Si el paso no se cargo muestro un error:
      $this->errtyp = $lo_datwrkstpmdl->errtyp;
      $this->errcod = $lo_datwrkstpmdl->errcod;
      $this->errtxt = $lo_datwrkstpmdl->errtxt;
      return false;
    }

    //Si el paso se cargo correctamente entonces paso a realizar las acciones correspondientes.
    $lo_wrkactmdl = $this->co_reg->load->model('sysdocwrkact');
    
    //Si el estado del paso es aprobado ejecuto accion de liberacion(REL) y si se rechazo accion de rechazo(REJ)
    $lv_relsts = (($lo_datwrkstpmdl->relsts == 'A')?'REL':'REJ'); 

    //Busco actividades relacionadas a la accion realizada.
    $lv_prmact = array('vewfldflt' =>'[~fltrow~]a.wrkflwcod'.chr(9).'='.chr(9).chr(9).$lp_prm['wrkflwcod'].chr(9).chr(9).
                                  '[~fltrow~]a.wrkflwstpcod'.chr(9).'='.chr(9).chr(9).($lo_datwrkstpmdl->wrkflwstpcod).chr(9).chr(9).
                    							'[~fltrow~]a.wrkflwactevt'.chr(9).'='.chr(9).chr(9).$lv_relsts.chr(9).chr(9)
                    );
    $lo_rs = $lo_wrkactmdl->getList($lv_prmact);
    //Por cada actividad asociada ejecuto su accion correspondiente.
    $lv_wrkobj = array('typ'=>'step', 'sts'=>$lo_datwrkstpmdl->relsts, 'code'=>$lp_prm['wrkflwstpcod'], 'datcode'=>$lo_datwrkstpmdl->wrkflwstpdatcod);
    foreach($lo_rs as $lv_rowact){
      $lv_act = array('typ'=>$lv_rowact['wrkflwacttyp'], 'val'=>$lv_rowact['wrkflwactval']);
      $lv_rtaact = $this->executeAction($lv_act, $lv_wrkobj, $lp_prm['data'], $lo_datwrkstpmdl->wrkflwdatcod);
      // *****************************************
      // que efecto produce si no se puede ejecutar la accion de inicio????
      // *****************************************
    }
    
		//LIBERAR-RECHAZAR WORKFLOW. Libera o rechazo el workflow dependiendo del estado en el que se encuentra luego de las acciones del paso.
    
    //Cargo el modelo del workflow
  	$this->load(array('wrkflwdatcod'=>$lp_prm['wrkflwdatcod']));
    //Si hubo un cambio en el estado de liberacion del workflow reviso que ocurrio y ejecuto sus actividades correspondiente
    if($this->relsts != 'S'){
      $lv_relsts = (($this->relsts == 'A')?'REL':'REJ'); 

      //Busco actividades relacionadas a la accion realizada.
      $lv_prmact = array('vewfldflt' =>'[~fltrow~]a.wrkflwcod'.chr(9).'='.chr(9).chr(9).$lp_prm['wrkflwcod'].chr(9).chr(9).
                                  '[~fltrow~]a.wrkflwstpcod'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
                    							'[~fltrow~]a.wrkflwactevt'.chr(9).'='.chr(9).chr(9).$lv_relsts.chr(9).chr(9)
                    );
    	$lo_rs = $lo_wrkactmdl->getList($lv_prmact);

      //Por cada actividad asociada ejecuto su accion correspondiente.
      $lv_wrkobj = array('typ'=>'workflow', 'sts'=>$lo_datwrkstpmdl->relsts, 'code'=>$lp_prm['wrkflwcod'], 'datcode'=>$lo_datwrkstpmdl->wrkflwdatcod);
      foreach($lo_rs as $lv_rowact){
        $lv_act = array('typ'=>$lv_rowact['wrkflwacttyp'], 'val'=>$lv_rowact['wrkflwactval']);
        $lv_rtaact = $this->executeAction($lv_act, $lv_wrkobj, $lp_prm['data'], $lo_datwrkstpmdl->wrkflwdatcod);

        // *****************************************
        // que efecto produce si no se puede ejecutar la accion de inicio????
        // *****************************************
      }
    }
   return true;
  }
	
	//  CALL SP. llamada a base de datos
	private function call_sp( $lp_action, $lp_in, &$lp_out ) {
		$this->errtyp = 'S';
		$this->errcod = 0;
		$this->errtxt = '';
		$this->sysdata['sqlprm'] = array( $lp_action, $this->co_reg->sec->usrcod, $this->co_reg->sec->buscod, 
                                     $this->co_reg->db->sqldat($lp_in,'wrkflwdatcod'),
                                     $this->co_reg->db->sqldat($lp_in,'wrkflwcod'),
                                     $this->co_reg->db->sqldat($lp_in,'srcobjtyp'),
                                     $this->co_reg->db->sqldat($lp_in,'srcobjcod001'),
                                     $this->co_reg->db->sqldat($lp_in,'srcobjcod002'),
                                     $this->co_reg->db->sqldat($lp_in,'relsts'),
                                     $this->co_reg->db->sqldat($lp_in,'docsts'),
                                     $this->co_reg->db->sqldat($this->sysdata, 'view_options', false)
																		);
		$this->sysdata['sqltxt'] = 'GRL_DAT_WRK_DEF (?,?,?,?,?,?,?,?,?,?,?)';
    $this->sysdata['sqlstm'] = $this->co_reg->db->getSqlStatement($this->sysdata['sqltxt'],$this->sysdata['sqlprm']);
		$lo_rs = $this->co_reg->db->sqlstoredprocedure( $this->sysdata['sqltxt'] , $this->sysdata['sqlprm'] );
		
    // validacion [errcod,errtyp,errmsg-errvar(chr9),errtxt]
    $this->errcod = (intval($lo_rs[0]['errcod']??0));
    $this->errtyp = ($lo_rs[0]['errtyp']??($this->errcod<0?'E':'S'));
    $this->errtxt = (isset($lo_rs[0]['errmsg'])?$this->co_reg->language->message( $lo_rs[0]['errmsg'], explode(chr(9),($lo_rs[0]['errvar']??'')) ) : ($lo_rs[0]['errtxt']??'') );
	
    // devuelve recordset (segun la operacion)
    if ( $lp_action=='08' ) {
      if($this->errtyp!='E'){
				$lp_out = $lo_rs;
      }else{
        $lp_out=array('errtyp'=>$this->errtyp, 'errcod'=>$this->errcod, 'errtxt'=>$this->errtxt);
      }
			
		// devuelve ID (registro individual)
		} else {
      if ( $lo_rs && count($lo_rs)>0 ) {
        if( $this->errtyp!='E' ){
					$lp_out = $lo_rs[0];
					$this->data[self::ID] = ($lp_out[self::ID]??array_values($lp_out)[0]);
        }
				$this->errcod = intval($this->errcod);
			} else {
				$this->errtyp = 'E';
				$this->errcod = -9999;
				$this->errtxt = $this->co_reg->language->message('UnexpectedError', $this->sysdata['sqlstm'] );
			}
		}
		
    //  GRLDATWRKSTP. carga los pasos del workflow
    if($lp_action=='03' && $this->errcod==0){
      $lo_grldatwrkstpdmdl = $this->co_reg->load->model('grldatwrkstp');
      $lv_prm = array('vewfldflt' =>'[~fltrow~]ws.wrkflwdatcod'.chr(9).'='.chr(9).chr(9).$this->data[self::ID].chr(9).chr(9));
      $lp_out['grldatwrkstp'] = $lo_grldatwrkstpdmdl->getList( $lv_prm );
    }
		
		return ($this->errcod==0?true:false);
	}
	
	
	
	
  // VERIFY CONDITION. evalua la condicion de inicio del workflow o de un paso
  private function verifyCondition($lp_cndtyp, $lp_cndval, $lp_docdata=array()){
    $lv_rta = array('errtyp'=>'S', 'errcod'=>0, 'errtxt'=>'');
		
    // valida según el tipo de condición
		if($lp_cndval!=''){
			switch($lp_cndtyp){
				
				// CONDICION del CLIENTE
				case 'ZCU':
					$lv_data = getCallComponents( html_entity_decode($lp_cndval) );
					if( $lv_data['prg']!='' && $lv_data['prg']!='' ){
						$lo_zcucnt = $this->co_reg->load->controller( $lv_data['prg'] );
						return $lo_zcucnt->index( $lv_data['act'], $lv_data['prm'] );
					} else {
						$this->errtyp='E'; $this->errcod=-1; $this->errtxt='InvalidCondition';
						return false;
					}
					break;

				// FORMULA
				case 'FOR':
					$lo_forcnt = $this->co_reg->load->controller('grlprccndfor');
          // prepara los datos para la evaluar la fórmula, el lp_docdata es un array no un string o un json.
          //Obtengo los valores que debo de buscar que necesito para la condicion dentro de los datos enviados.
          preg_match_all("/\[(.*?)\]/", $lp_cndval, $lv_tmparr);
          $lv_data = array();
          $lv_cndvalarr = $lv_tmparr[1];
					foreach($lv_cndvalarr as $lv_val){
            $lv_val = strtolower($lv_val);
            if(isset($lp_docdata[$lv_val])){
           		$lv_data[$lv_val] = (is_string($lp_docdata[$lv_val])?strtoupper($lp_docdata[$lv_val]):$lp_docdata[$lv_val]);  //strtoupper
            }          	 
          }
         
				/*	if($lv_data==NULL){
						$lv_data=array();
					} else{
						$lv_inf = array();
						foreach($lv_data as $lv_val){
							$lv_inf[$lv_val['name']] = $lv_val['value'];
						}
						$lv_data = $lv_inf;
					}*/
					
					// evalua la formula
					try {
            $lv_forval = $lo_forcnt->evalFormula( $lp_cndval , $lv_data );
						$lv_rta['errtyp'] = ( $lv_forval ? 'S': 'W');
					} catch(Exception $e){
						$lv_rta['errtxt'] = $e->getMessage();
					}
					
					if($lv_rta['errtxt'] != ''){
						$lv_rta['errtyp'] = 'E';
						$lv_rta['errcod'] = -1;
					}
					break;
			}
    }
    return $lv_rta;
  }
	
	// EXECUTE ACTION. ejecuta una accion del workflow o paso (de liberacion o rechazo)
  private function executeAction($lp_act, $lp_wrkobj, $lp_docdata, $lp_wrkdatcod){
    $lv_rta = array('errtyp' => 'S', 'errcod' => 0, 'errtxt' => '');
    $lv_usrto_arr = array();
    
    switch($lp_act['typ']){
			
			// notifica a solicitante 
      case 'NTF_SOL':
				$lv_usrto_arr[]=$this->cteusr;
				break;
        
			// notifica a aprobadores previos 
      case 'NTF_APR':
				foreach($this->grldatwrkstp as $lv_rowstp){
					$lv_usrto_arr[]=$lv_rowstp['relusr'];
				}
				break;
        
			// notifica a todos los usuarios 
      case 'NTF_ALL':
        $lv_usrto_arr[] = $this->cteusr;
				foreach( $this->grldatwrkstp as $lv_rowstp ){
					$lv_usrto_arr[] = $lv_rowstp['relusr'];
				}
        break;
       
			// notifica a usuarios especificos (x ej "[users=ROCHOA;ROCHOA2]" )
      case 'NTF_USR':
        preg_match('/\[users=([^\]]+)\]/', $lp_act['val'], $matches);

        // Paso 2: Verificar si se encontró el grupo 'users' y dividir los usuarios en un array
        $lv_usrto_arr = [];
        if (!empty($matches[1])) {
          $lv_usrto_arr = explode(';', $matches[1]);
        }
				break;
			
			
			// ****************************************************************
			// ****************************************************************
			// REVISAR ESTO
			// ****************************************************************
			// ****************************************************************
			// ****************************************************************
      case 'DOC_UPD':
        // armar array de valores a actualizar
        $lv_chgval_arr = explode(';', $lp_act['val']);
        if(count($lv_chgval_arr) > 0){ 
          $lv_datsve = array();
          foreach($lv_chgval_arr as $lv_row){
            $lv_row = trim($lv_row);
          	$lv_key = substr($lv_row, 0, strpos($lv_row, '='));
          	$lv_val = substr($lv_row, strpos($lv_row, '=') + 1, strlen($lv_row));
            $lv_datsve[$lv_key] = $lv_val;
          }
          
          
          // obtener modelo para actualizar el documento
          $lo_objtypmdl = $this->co_reg->load->model('sysobjtyp');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]o.objtypcod'.chr(9).'='.chr(9).chr(9).$lp_docdata['srcobjtyp'].chr(9).chr(9).
                                        '[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                          'vewmaxrec'=>'1');
          $lo_rs = $lo_objtypmdl->getList($lv_prm);

         	if( count($lo_rs)!=0 ) {
            $lv_mdl = str_replace('_', '', $lo_rs[0]['objtyptbl']);
            $lo_docmdl = $this->co_reg->load->model($lv_mdl);
            // grabar
          	$lo_docmdl->load(array($lo_rs[0]['objtypkey']=>$lp_docdata['srcobjcod001']));
            $lo_mdldata = $lo_docmdl->getData();

            $lv_datsve = array_merge($lo_mdldata, $lv_datsve);
   					
            foreach($lv_datsve as $lv_key=>$lv_row){
              if($lv_key!='ctedte' && $lv_key!='upddte' && $lv_key!='deldte' ){
                if(is_a($lv_row,'DateTime')){
										$lv_datsve[$lv_key]= $lv_row->format('d/m/Y');
                }
             	}
            }                
            if($lo_docmdl->save($lv_datsve) == false){
              $lv_rta = array('errtyp'=>$lo_docmdl->errtyp, 'errcod'=>$lo_docmdl->errcod,'errtxt'=>$lo_docmdl->errtxt);
            }
          }
        }
        break;
			// ****************************************************************
			// ****************************************************************
			// ****************************************************************
      
			
      case 'ZCU':
				$lv_data = $this->co_reg->document->getCallComponents( html_entity_decode($lp_act['val']??'') );
				if( $lv_data['prg']!='' ){
					$lo_zcucnt = $this->co_reg->load->controller( $lv_data['prg'] );
					$lv_rta = $lo_zcucnt->index( $lv_data['act'], $lv_data['prm'] );
				} else {
					$lv_rta['errtyp']='E'; $lv_rta['errcod']=-1; $lv_rta['errtxt']='InvalidCondition';
				}
        break;
        
			// aprobar/rechazar workflow
      case 'DOC_APR': case 'DOC_REJ':
				$lo_datwrkmdl = $this->co_reg->load->model('grldatwrk');
        $lv_datsve =array('wrkflwdatcod' => $lp_wrkdatcod,
													'relsts' => (stripos($lp_act['typ'],'APR') !== false ? 'A': 'R'),
                          'docsts' => 'A');
        if( $this->save($lv_datsve) ){
          $lv_rta = array('errtyp'=>$lo_datwrkmdl->errtyp, 'errcod'=>$lo_datwrkmdl->errcod,'errtxt'=>$lo_datwrkmdl->errtxt);
        }
        break;
    }
		
    // notificar
    if(strpos($lp_act['typ'],'NTF')!==false && $lv_rta['errtyp']!=='E'){
			// preparar datos para enviar mail
			$lv_emlprm = array('to' => array(),
												 'from' => array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Temasis') ),
												 'subject' => '',//$lv_sbjgval
												 'bodyhtml' => '');//$lv_usrmsg);
      
			// USUARIOS. buscar email de los usuarios a notificar
      $lo_usrmdl = $this->co_reg->load->model('syssecusr');
      $lv_prm = array('vewfldflt' =>'[~fltrow~]u.usrcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lv_usrto_arr).chr(9).chr(9).
                                    '[~fltrow~]u.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
      $lo_rsusr = $lo_usrmdl->getList( $lv_prm );
     
			foreach($lo_rsusr as $lv_row){
				$lv_emlprm['to'][] = array('address'=>$lv_row['adreml']);
			}
      if(count($lv_emlprm['to'])==0){
				$lv_rta = array('errtyp'=>'W', 'errcod'=>0,'errtxt'=>'Sin usuarios a notificar.');
				return $lv_rta;
			}
			
      // SUBJECT. obtener subject desde los parametros
			$lv_sbjgval = str_ireplace('[subject=','',$lp_act['val']);
			$lv_sbjgpos = strpos($lp_act['val'], '[subject=') + 9;
			if(strpos($lp_act['val'], '[subject=') !== false){
				$lv_sbjgval = substr($lp_act['val'], $lv_sbjgpos, strpos($lp_act['val'], ']', $lv_sbjgpos) - $lv_sbjgpos);
			}
        
			// obtener texto del mensaje
			$lv_txtmsgpos = strpos($lp_act['val'], '[text=') + 6;
			$lv_txtval = '';
			if(strpos($lp_act['val'], '[text=') !== false){
				$lv_txtval = substr($lp_act['val'], $lv_txtmsgpos, strpos($lp_act['val'], ']', $lv_txtmsgpos) - $lv_txtmsgpos);
			}
        
			$lo_txtmdl = $this->co_reg->load->model('grldattxt');
			$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).$lv_txtval.chr(9).chr(9).
																		'[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9),
											'vewmaxrec'=>'1');
			$lo_rs = $lo_txtmdl->getList($lv_prm);
			if( count($lo_rs)==0 || $lv_txtval === '') {
				$lv_usrmsg = $this->co_reg->language->message('TextNotFound', ' ');
			} else {
				$lv_usrmsg = $lo_rs[0]['txttxt'];
			
        // REEMPLAZO DE VARIABLES EN FORMULARIO ---------------------------------------------
        $lv_stsname = array('S'=>'started', 'A'=>'approved', 'R'=>'rejected', 'I'=>'inactive');
        $lv_replace = array('{{action.value}}','{{action.name}}','{{action.user}}','{{action.date}}',
                            '{{form.code001}}','{{form.code002}}','{{form.createuser}}','{{form.createdate}}',
                            '{{step.code}}','{{step.name}}',
                            '{{wrkflw.name}}','{{wrkflw.code}}');
        foreach( $lv_replace as $lv_keyrpl ){
          $lv_val = '';
          if( stripos($lv_usrmsg,$lv_keyrpl)!=false ){
            switch( $lv_keyrpl ){
              case '{{action.value}}':
                $lv_val = ($lp_act['val']??'');
                break;
              case '{{action.name}}':
                $lv_val = strtolower($this->co_reg->language->message($lv_stsname[$lp_wrkobj['sts']], ' '));
                break;
              case '{{action.user}}': case '{{action.date}}':
                if($lp_wrkobj['typ'] == 'step'){
                  $lv_datmdl = $this->co_reg->load->model('grldatwrkstp');
                  $lv_datmdl->load(array('wrkflwstpdatcod' => $lp_wrkobj['datcode']));
                }else{
                  $lv_datmdl = $this->co_reg->load->model('grldatwrk');
                  $lv_datmdl->load(array('wrkflwdatcod' => $lp_wrkobj['datcode']));
                }
                if( $lv_keyrpl=='{{action.user}}' ){ $lv_val = $lv_datmdl->relusr; }
                if( $lv_keyrpl=='{{action.date}}' ){
                  if( $lv_datmdl->reldte instanceof DateTime ){
                    $lv_val = $lv_datmdl->reldte->format('d/m/Y');
                  } else {
                    $lv_val = date_create_from_format('d/m/Y', $lv_datmdl->reldte);
                  }
                }
                break;
              case '{{form.code001}}':
                $lv_val = ($lp_docdata['srcobjcod001']??'');
                break;
              case '{{form.code002}}':
                $lv_val = ($lp_docdata['srcobjcod002']??'');
                break;
              case '{{form.createuser}}':
                $lv_val = ($lp_docdata['cteusr']??'');
                break;
              case '{{form.createdate}}':
                $lv_val = ($lp_docdata['ctedte']??'');
                if (is_a($lv_val, 'DateTime')){ $lv_val = $lv_val->format('d/m/Y'); }
                break;
              case '{{step.code}}':
                $lv_val = (($lp_wrkobj['typ']??'')=='step'?($lp_wrkobj['code']??''):'');
                break;
              case '{{step.name}}':
                $lo_stpmdl = $this->co_reg->load->model('sysdocwrkstp');
                $lo_stpmdl->load(array('wrkflwstpcod' => $lp_wrkobj['code']));
                $lv_val = $lo_stpmdl->get('wrkflwstptxt');
                break;
              case '{{wrkflw.name}}':
                $lo_datwrkmdl = $this->co_reg->load->model('grldatwrk');
                $lo_wrkmdl = $this->co_reg->load->model('sysdocwrk');
                $lo_datwrkmdl->load(array('wrkflwdatcod' => $lp_wrkdatcod));
                $lo_wrkmdl->load(array('wrkflwcod' => $lo_datwrkmdl->get('wrkflwcod')));
                $lv_val = $lo_wrkmdl->get('wrkflwtxt');
                break;
              case '{{wrkflw.code}}':
                $lo_datwrkmdl = $this->co_reg->load->model('grldatwrk');
                $lo_datwrkmdl->load(array('wrkflwdatcod' => $lp_wrkdatcod));
                $lv_val = $lo_datwrkmdl->get('wrkflwcod');
                break;
            }
            $lv_usrmsg = str_ireplace( $lv_keyrpl, $lv_val, $lv_usrmsg);
          }
        }
			}
			
/*
					case 'form.url':
						// obtener nombre del recurso para cargar documento
						$lo_apimdl = $this->co_reg->load->model('sysappapi');
						$lv_prm = array('vewfldflt' =>'[~fltrow~]a.sysappapiurl'.chr(9).'='.chr(9).chr(9).$lp_docdata['srcobjtyp'].chr(9).chr(9).
																					'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
														'vewmaxrec'=>'1');
						$lo_rs = $lo_apimdl->getList($lv_prm);
						if(count($lo_rs)!=0){
							$lv_apicodext = $lo_rs[0]['sysappapicodext'];

							// obtener empresa
							$lo_cfg = new tmssConfig();
							$lo_cfg->load('tmssOnLine');
							$lo_rs = $lo_cfg->get('customers');
							foreach($lo_rs as $lv_key=>$lv_row){
								if($lv_row['buscod'] == $this->co_reg->sec->buscod){
									$lv_buskey = $lv_key;
									break;
								} 
							}
							$lv_val = 'https://customers.gorse.ar/'.$lv_buskey.'/'.$lv_apicodext.'/'.($lp_docdata['srcobjcod001']??'');
						}else{
							$lv_val = '';
						}
						break;
*/
				// FIN DE REEMPLAZO ------------------------------------------------------------------------------
				
/*
				// reemplazar parámetros
				$lv_offset = 0;
				while(strpos($lv_usrmsg, '[', $lv_offset) !== false){
					// buscar catálogo
					// aa [action.name]
					$lv_bracketpos = strpos($lv_usrmsg, '[', $lv_offset) + 1;
					$lv_cat = substr($lv_usrmsg, $lv_bracketpos, strpos($lv_usrmsg, '.', $lv_bracketpos) - $lv_bracketpos);
            
					if(in_array($lv_cat, array_keys($lv_msgprm))){
						// buscar campo
						$lv_fld = substr($lv_usrmsg, $lv_bracketpos + strlen($lv_cat) + 1, strpos($lv_usrmsg , ']', $lv_bracketpos) - ($lv_bracketpos + strlen($lv_cat) + 1));
						if(in_array($lv_fld, $lv_msgprm[$lv_cat])){
							// determinar valor
							$lv_val = '';
							
							switch($lv_cat.'.'.$lv_fld){
								/ *
								case 'action.name':
									$lv_stsname = array('S'=>'started', 'A'=>'approved', 'R'=>'rejected', 'I'=>'inactive');
									$lv_val = strtolower($this->co_reg->language->message($lv_stsname[$lp_wrkobj['sts']], ' '));
									break;

								case 'action.value':
									$lv_val = $lp_act['val']??'';
									break;
								* /
								case 'action.user': case 'action.date':
									if($lp_wrkobj['typ'] == 'step'){
										$lv_datmdl = $this->co_reg->load->model('grldatwrkstp');
										$lv_datmdl->load(array('wrkflwstpdatcod' => $lp_wrkobj['datcode']));
									}else{
										$lv_datmdl = $this->co_reg->load->model('grldatwrk');
										$lv_datmdl->load(array('wrkflwdatcod' => $lp_wrkobj['datcode']));
									}
									$lv_val = $lv_datmdl->get($lv_fld == 'user' ? 'relusr' : 'reldte');
									if($lv_fld == 'date'){
										$lv_val = (is_array($lv_val)?date('d/m/Y', strtotime($lv_val['date'])):$lv_val->format('d/m/Y'));
									}
									break;
								/*
								case 'form.code001':
									$lv_val = $lp_docdata['srcobjcod001']??'';
									break;

								case 'form.code002':
									$lv_val = $lp_docdata['srcobjcod002']??'';
									break;

								case 'form.createuser':
									$lv_val = $lp_docdata['cteusr']??'';
									break;

								case 'form.createdate':
									$lv_val = $lp_docdata['ctedte']??'';
									break;
								* /
								case 'form.url':
									// obtener nombre del recurso para cargar documento
									$lo_apimdl = $this->co_reg->load->model('sysappapi');
									$lv_prm = array('vewfldflt' =>'[~fltrow~]a.sysappapiurl'.chr(9).'='.chr(9).chr(9).$lp_docdata['srcobjtyp'].chr(9).chr(9).
																								'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
																	'vewmaxrec'=>'1');
									$lo_rs = $lo_apimdl->getList($lv_prm);
									if(count($lo_rs)!=0){
										$lv_apicodext = $lo_rs[0]['sysappapicodext'];

										// obtener empresa
										$lo_cfg = new tmssConfig();
										$lo_cfg->load('tmssOnLine');
										$lo_rs = $lo_cfg->get('customers');
										foreach($lo_rs as $lv_key=>$lv_row){
											if($lv_row['buscod'] == $this->co_reg->sec->buscod){
												$lv_buskey = $lv_key;
												break;
											} 
										}
										$lv_val = 'https://customers.gorse.ar/'.$lv_buskey.'/'.$lv_apicodext.'/'.($lp_docdata['srcobjcod001']??'');
									}else{
										$lv_val = '';
									}
									break;

								case 'step.name':
									if($lp_wrkobj['typ'] == $lv_cat){
										$lo_stpmdl = $this->co_reg->load->model('sysdocwrkstp');
										$lo_stpmdl->load(array('wrkflwstpcod' => $lp_wrkobj['code']));
										$lv_val = $lo_stpmdl->get('wrkflwstptxt');
									}else{
										$lv_val = '';
									}
									break;
								/*
								case 'step.code':
									$lv_val = ($lp_wrkobj['typ'] == $lv_cat ? $lp_wrkobj['code'] : '');
									break;
								* /
								case 'wrkflw.name':
									$lo_datwrkmdl = $this->co_reg->load->model('grldatwrk');
									$lo_wrkmdl = $this->co_reg->load->model('sysdocwrk');
									$lo_datwrkmdl->load(array('wrkflwdatcod' => $lp_wrkdatcod));
									$lo_wrkmdl->load(array('wrkflwcod' => $lo_datwrkmdl->get('wrkflwcod')));
									$lv_val = $lo_wrkmdl->get('wrkflwtxt');
									break;

								case 'wrkflw.code':
									$lo_datwrkmdl = $this->co_reg->load->model('grldatwrk');
									$lo_datwrkmdl->load(array('wrkflwdatcod' => $lp_wrkdatcod));
									$lv_val = $lo_datwrkmdl->get('wrkflwcod');
									break;
                }

							// reemplazar valor en el mensaje
							$lv_usrmsg = str_replace('['.$lv_cat.'.'.$lv_fld.']', $lv_val, $lv_usrmsg);
            }

            $lv_offset = $lv_bracketpos;
          }

          $lv_usrmsg = html_entity_decode($lv_usrmsg);
        }
      }
			*/
			
			
			// preparar datos para enviar mail
			$lv_emlprm['subject'] = $lv_sbjgval;
			$lv_emlprm['bodyhtml'] = $lv_usrmsg;
			// enviar mail
			$lo_eml = new tmssMail();
			if ( !$lo_eml->send( $lv_emlprm ) ) {
				$lv_rta['errtyp'] = 'E';
				$lv_rta['errcod'] = -1;
				$lv_rta['errtxt'] = 'Error al enviar mail: '.($lo_eml->getError());
			}      
    }
    
    return $lv_rta;
  }
}
?>
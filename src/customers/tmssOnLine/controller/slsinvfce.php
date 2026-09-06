<?php
final class slsinvfceController extends tmssController {
	const MODEL = 'slsinvfce';
	const VIEW  = 'slsinvfce';
	const ID = 'slsinvcod';
	protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }	
	
  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {

    // control de sesion
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		
		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
		
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
			
			// VISTA
      case '#':
				return $this->co_reg->document->getView(self::VIEW,array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
				break;
			
			
			// LOG
			case '#showLog':
				$lo_post = $this->co_reg->request->post;
				
				$lo_applogmdl = $this->co_reg->load->model('sysapplog');
        
        // Determinar si se deben filtrar solo errores
    		$lv_err = isset($lo_post['err']) && $lo_post['err'] == '1';
        
				$lv_prm = array('vewmaxrec' =>'100',
												'vewfldflt' =>'[~fltrow~]l.srcobjtyp'.chr(9).'='.chr(9).chr(9).'SLS_FCE'.chr(9).chr(9).
																			'[~fltrow~]l.srcobjcod001'.chr(9).'='.chr(9).chr(9).$lo_post['slsinvcod'].chr(9).chr(9).
																			'[~fltrow~]l.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' =>'l.ctedte desc'
											);

				$lo_rs = $lo_applogmdl->getList( $lv_prm );
        
        if ($lv_err && !empty($lo_rs)) {
          $lv_log = $lo_rs[0];
          $lv_applogtxt = json_decode($lv_log['applogtxt'], true);
          $lv_arrerr = [];

          foreach ($lv_applogtxt as $lv_applogerr) {
            if (isset($lv_applogerr['errtyp']) && $lv_applogerr['errtyp'] === 'E') {
              $lv_arrerr[] = $lv_applogerr;
            }
          }
          $lv_log['applogtxt'] = json_encode($lv_arrerr);
          $lo_rs = [$lv_log];
        }
        
				$this->lo_mdl->fcelog = $lo_rs;

        return $this->co_reg->document->getView('slsinvfcelog',array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
				break;
			
			
			// LISTAR
      case '#08':
				$lo_post = $this->co_reg->request->post;
				
				$lv_maxrec = (isset($lo_post['vewmaxrec'])?$lo_post['vewmaxrec']:'');
				$lv_fldflt = (isset($lo_post['vewfldflt'])?$lo_post['vewfldflt']:'');
				$lv_prm = array('vewfldflt' =>$lv_fldflt, 'vewmaxrec'=>$lv_maxrec);
				$lo_rs = $this->lo_mdl->getList( $lv_prm );
				
				$lv_retjsn = json_encode( $this->co_reg->document->array_utf8_converter($lo_rs) );
				if ( json_last_error() == JSON_ERROR_NONE ) {
					$this->co_reg->response->addHeader('Content-type: application/json');
					return $lv_retjsn;
				} else {
					$lv_err = 'Error ['.json_last_error().']-['.json_last_error_msg().'] en conversión json: ' . implode( ' ***** ' , $lo_data );
          return $this->co_reg->document->getJson( array('errcod'=>-1,'errtxt'=>$lv_err) );
				}
				break;
			
			
			// BORRAR
			// Borra una FE y vuelve a incializar la factura
			// solo si no está previamente autorizada
			case '#04':
				$lo_post = $this->co_reg->request->post;

				// Get array of slsinvcod from POST
				$lv_slsinvcod_arr = isset($lo_post['slsinvcod'])?json_decode(html_entity_decode($lo_post['slsinvcod'])):'';
				if(!is_array($lv_slsinvcod_arr)){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>999,'errtxt'=>'Facturas invalidas') );
				}

				// Load model
				$lo_mdlslsinv = $this->co_reg->load->model('slsinv');

				// Process each invoice
				$this->errtxt	= '';
				$lv_err	= false;
				foreach($lv_slsinvcod_arr as $lv_slsinvcod){

					// Get slsinvfce
					if($this->lo_mdl->load(array('slsinvcod' => $lv_slsinvcod )) == false){
						$this->errtxt .= 'ID '.$lv_slsinvcod.': '.$this->lo_mdl->errtxt.'<br>';
						$lv_err	= true;
						continue;
       		} 

					// The electronic invoice can not be deleted if the state is "A" or "O"
					if($this->lo_mdl->docsts == "A" || $this->lo_mdl->docsts == "O"){
						$this->errtxt .= 'ID '.$lv_slsinvcod.': No se puede borrar porque tiene estado '.$this->lo_mdl->docsts.'<br>';
						$lv_err	= true;
						continue;
					}

					// Delete invoicefe (the SP also update slsinv->docsts to "A" activo)
					if( ! ($this->lo_mdl->delete(array('slsinvcod' => $lv_slsinvcod)) )){
						$this->errtxt .= 'ID '.$lv_slsinvcod.': '.$this->lo_mdl->errtxt.'<br>';
						continue;
					}

					$this->errtxt .= 'ID '.$lv_slsinvcod.': borrado<br>';
				}

				// Send result to browser
				$lv_errcod = ($lv_err==''? '' : '999' );
				$lv_errtyp = ($lv_err==''? '' : 'E' );
        return $this->co_reg->document->getJson( array('errtyp'=>$lv_errtyp,'errcod'=>$lv_errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				break;
			
        
      // ANULAR FACTURA
      case '#05':
        $lo_post = $this->co_reg->request->post;

        // Obtener array de slsinvcod desde el POST
        $lv_slsinvcod_arr = isset($lo_post['slsinvcod'])?json_decode(html_entity_decode($lo_post['slsinvcod'])):'';
        if (!is_array($lv_slsinvcod_arr)) {
          return json_encode(array('errtyp' => 'E', 'errcod' => 999, 'errtxt' => 'Facturas inválidas'));
        }

        // Cargar el modelo
        $lo_mdlslsinv = $this->co_reg->load->model('slsinv');

        // Inicializar variables de error
        $this->errtxt = '';
        $lv_err = false;

        // Procesar cada factura
        foreach ($lv_slsinvcod_arr as $lv_slsinvcod) {
          // Obtener los datos de la factura
          if($this->lo_mdl->load(array('slsinvcod' => $lv_slsinvcod )) == false){
						$this->errtxt .= 'ID '.$lv_slsinvcod.': '.$this->lo_mdl->errtxt.'<br>';
						$lv_err	= true;
						continue;
       		}

          // La factura no puede ser actualizada si tiene estado "A" o "O"
          if($this->lo_mdl->docsts == "A" || $this->lo_mdl->docsts == "O"){
						$this->errtxt .= 'ID '.$lv_slsinvcod.': No se puede sacar porque tiene estado '.$this->lo_mdl->docsts.'<br>';
						$lv_err	= true;
						continue;
					}
          
          if( ! ($this->lo_mdl->remove(array('slsinvcod' => $lv_slsinvcod)) )){
						$this->errtxt .= 'ID '.$lv_slsinvcod.': '.$this->lo_mdl->errtxt.'<br>';
						continue;
					}

					$this->errtxt .= 'ID '.$lv_slsinvcod.': Factura anulada<br>';
        }

        // Retornar el resultado al navegador
        $lv_errcod = ($lv_err == '' ? '' : '999');
        $lv_errtyp = ($lv_err == '' ? '' : 'E');
        return $this->co_reg->document->getJson( array('errtyp'=>$lv_errtyp,'errcod'=>$lv_errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			case '#showSlsInvFce':
				$lo_post = $this->co_reg->request->post;
				
				// obtengo array de facturas a procesar
				$lv_slsinv_rs = (isset($lo_post['slsinvcod'])?json_decode(html_entity_decode($lo_post['slsinvcod'])):array());
				if(!is_array($lv_slsinv_rs )){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indicaron Facturas a procesar.') );
				}
				
        $this->lo_mdl->showlog = (isset($lo_post['showlog']) && $lo_post['showlog'] == 0) ? 0 : 1;
        
				$this->lo_mdl->slsinvlst = $lv_slsinv_rs;
        return $this->co_reg->document->getView( 'slsinvfcerun', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        
				break;
				
				
			// ----------------------------------------------------------------------
			// procSlsInvFce
			// procesa las facturas electrónicas seleccionadas
			// ----------------------------------------------------------------------
			case '#procSlsInvFce':
				$lo_post = $this->co_reg->request->post;
				$lo_slsret = array();
				$lo_slsinv = array();
				
				// localizacion ARGENTINA ---------------------------------------------
				$lo_ctrwssmdl = $this->co_reg->load->controller( 'finlocargwss' );
				$lo_ctrwssmdl->procSlsInvFce( array($lo_post['slsinvcod']) );
				$lv_ret = array('errtyp'=>$lo_ctrwssmdl->errtyp,'errcod'=>$lo_ctrwssmdl->errcod,'errtxt'=>$lo_ctrwssmdl->errtxt,'slsinvcod'=>$lo_post['slsinvcod'],'slsinvlog'=>$lo_ctrwssmdl->fcelog);
				
				// RETURN.
				$lv_retjsn = json_encode( $this->co_reg->document->array_utf8_converter($lv_ret) );
				if ( json_last_error() === JSON_ERROR_NONE ) {
					$this->co_reg->response->addHeader('Content-type: application/json');
          return json_encode(array('data'=>json_decode($lv_retjsn, true)));
				} else {
          $lv_err = 'Error ['.json_last_error().']-['.json_last_error_msg().'] en conversión json: ' . implode( ' ***** ' , $lo_data );
          return $this->co_reg->document->getJson( array('errcod'=>-1,'errtxt'=>$lv_err) );
				}
				break;
			
			
			// AFIP consultAfip ==> CAMBIAR NOMBRE DE METODO (debe ser generico y no de afip)
			case '#consultAfip':
				$lo_post = $this->co_reg->request->post;

				// Method to send to WS
				$lv_method = (isset($lo_post['method'])?$lo_post['method']:'');
				if($lv_method == '') {
        	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Metodo invalido.') );
        }

				// recupero datos de empresa
				$lo_busmdl =  $this->co_reg->load->model('admbus');
				if($lo_busmdl->load(array('buscod' => $this->co_reg->sec->buscod ), false) == false){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-2,'errtxt'=>$lo_busmdl->errtxt) );
 				} 
				
				// datos a enviar a WS
				$lo_ws_dat = new stdClass();
				$lo_ws_dat->Auth =  new stdClass();
				$lo_ws_dat->Auth->Cuit = $lo_busmdl->tax->taxcod;
				
				// obtengo credenciales de acceso
				$lo_wssctr = $this->co_reg->load->controller('finlocargwss');
				if( $lo_wssctr->WSAAgetTa( array('service'=>'wsfe','cuit'=>$lo_busmdl->tax->taxcod) )==false ) { // VER SI CORRESPONDE A CADA CASO (depende de cada RG quizas cambia el id de servicio)
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_wssctr->errtyp,'errcod'=>$lo_wssctr->errcod,'errtxt'=>$lo_wssctr->errtxt) );
				} else {
					$lo_ws_dat->Auth->Token	= $lo_wssctr->token;
					$lo_ws_dat->Auth->Sign 	= $lo_wssctr->sign;
				}
				
				switch($lv_method){
					case 'FECompConsultar':
						$lo_ws_dat->FeCompConsReq  =  new stdClass();
						$lo_ws_dat->FeCompConsReq->PtoVta		= isset($lo_post['ptoVta'])?$lo_post['ptoVta']:'';
						$lo_ws_dat->FeCompConsReq->CbteTipo	= isset($lo_post['cbteTipo'])?$lo_post['cbteTipo']:'';
						$lo_ws_dat->FeCompConsReq->CbteNro	= isset($lo_post['cbteNro'])?$lo_post['cbteNro']:'';
						break;
					case 'FECompUltimoAutorizado':
						$lo_ws_dat->PtoVta		= isset($lo_post['ptoVta'])?$lo_post['ptoVta']:'';
						$lo_ws_dat->CbteTipo	= isset($lo_post['cbteTipo'])?$lo_post['cbteTipo']:'';
						break;
					case 'FEParamGetCotizacion':
						$lo_ws_dat->MonId		= isset($lo_post['monId'])?$lo_post['monId']:'';
						break;
				}
				
				// Call AFIP WS
				// depende de la RG de cada combinacion POS/LTR/DOC CLS
				$lo_dat = json_decode(json_encode($lo_ws_dat),true);
				if( $lo_wssctr->loadUrlWSN('AFIP_WSFE_4291')==false ){
					$lo_data = array('No se encontro la definicion de la interfaz. [AFIP_WSFE_4291]');
				} else {
					$lo_data = $lo_wssctr->callWS( $lv_method, $lo_dat );
				}
				
				// procesa respuesta WS
				$lv_retjsn = json_encode( $this->co_reg->document->array_utf8_converter($lo_data) );
				if ( json_last_error() == JSON_ERROR_NONE ) {
					$this->co_reg->response->addHeader('Content-type: application/json');
					return $lv_retjsn;
				} else {
					$lv_err = 'Error ['.json_last_error().']-['.json_last_error_msg().'] en conversión json: ' . implode( ' ***** ' , $lo_data );
          return $this->co_reg->document->getJson( array('errcod'=>-1,'errtxt'=>$lv_err) );
				}
				break;
		}
	}
}
?>
<?php
require_once('../library/plugins/nusoap/lib/nusoap.php');

final class hltargtrzController extends tmssController {
  
  protected $co_reg;
  private $data = array();
	private $soapClient;
  
   
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
	
	
  /**
   * main method
   */     
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are for logged users
    // check user session
    $this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

    // acciones
    switch( $lp_act ) {
			
      // list
      case 'getTransaccionesNoConfirmadas':
      
				$dConexion = array();
				
        // obtengo configuración de interfaz
        $lo_sysint = $this->co_reg->load->model('sysint');
				$lv_prm = array('vewfldflt'=>'i.sysintcodext'.chr(9).'='.chr(9).chr(9).'HLTARGTRZ_MEDGETNOC'.chr(9).chr(9));
				$lo_rs = $lo_sysint->getList( $lv_prm );
				
				if(count($lo_rs)>0) {
					$lo_sysint->load( array('sysintcod'=>$lo_rs[0]['sysintcod']) );
					$dConexion['HLT_ARG_TRZ_URL'] = $this->co_reg->document->getTagValue( $lo_sysint->sysintatr,'trzurl');
					$dConexion['HLT_ARG_TRZ_USR'] = $this->co_reg->document->getTagValue( $lo_sysint->sysintatr,'trzusr');
					$dConexion['HLT_ARG_TRZ_PWD'] = $this->co_reg->document->getTagValue( $lo_sysint->sysintatr,'trzpwd');
					$dConexion['HLT_ARG_TRZ_GLN'] = $this->co_reg->document->getTagValue( $lo_sysint->sysintatr,'trzgln');
				}
				
        // ejecutamos la actualizacion
        $cantTransccionesActualizadas = $this->getTransaccionesNoConfirmadas($dConexion);       
				
        // Registrar los datos de la última ejecución (sysintlstrunsts (E=Error, I=OK, W=Warning) y sysintlstrunlog)
        $lp_key = array('sysintcod'=>$lo_sysint->sysintcod,
												'sysintlstrunsts'=>(count($this->data['err'])>0?'E':'I'),
												'sysintlstrunlog'=>'Total transacciones actualizadas ['.$cantTransccionesActualizadas.']'
											); 
        if( $lo_sysint->setRunData($lp_key) == false ) {
					/*
					$this->data['err'] = array('errcod'=>-1005,'errtxt'=>'Error al ejecutar setRunData.');
					$lv_dat = array('mdlcod'=>'ZCU', 'prgcod'=>'**', 'applogtxt'=> 'Se produjo al menos un error al ejecutar sendPacientesToMSDynamics.', 'applogtecinf'=> implode(' | ',$this->data['err']), 'docsts'=>'E');
					$lo_logmdl->save( $lv_dat );  
					echo '<errcod>'.$this->data['err']['errcod'].'</errcod><errtxt>'.$this->data['err']['errtxt'].'</errtxt>';
					return false;
					*/
        }
				
        // Log
        $lo_logmdl = $this->co_reg->load->model('sysapplog'); // Cargamos el modulo que que gestiona los Log
        if( count($this->data['err'])>0 ) {
          $lv_dat = array( 
            'mdlcod'=>'HLT'  // Identificamos el modulo de donde proviene el Log
            ,'prgcod'=>'hltargtrz' // identificamos el programa/controlador de donde viene el Log
            ,'applogtxt'=> 'Se produjo al menos un error al ejecutar la interfaz.' // Texto para identificar la operacion de error o proceso/acción
            ,'applogtecinf'=> implode('-',$this->data['err'])  // codigo que identifica la operacion o el error, no es obligatorio
            ,'docsts'=>'E'  // E para indicar que es un error y A para indicar que es una accion
          );
          $lo_logmdl->save( $lv_dat );          
					echo '<errcod>-1</errcod><errtxt>Se produjo al menos un error al ejecutar la interfaz. '.implode('-',$this->data['err']).'</errtxt>';
				
		    } else {
          $lv_dat = array( 
            'mdlcod'=>'HLT'  // Identificamos el modulo de donde proviene el Log
            ,'prgcod'=>'hltargtrz' // identificamos el programa/controlador de donde viene el Log
            ,'applogtxt'=> 'actualizarTransaccionesNoConfirmadas se ejecuto correctamente. Total transacciones actualizadas '.$cantTransccionesActualizadas.'.' // Texto para identificar la operacion de error o proceso/acción
            ,'applogtecinf'=> ''  // codigo que identifica la operacion o el error, no es obligatorio
            ,'docsts'=>'A'  // E para indicar que es un error y A para indicar que es una accion
          );
          $lo_logmdl->save( $lv_dat );
					echo '<errcod>0</errcod><errtxt>getTransaccionesNoConfirmadas se ejecuto correctamente. Total transacciones actualizadas ['.$cantTransccionesActualizadas.'].</errtxt>';
		    }
				
      break;
    }
    


  }
	
	
  /**
   * Actualiza Transacciones No Confirmadas 
     * Obtiene Transacciones No Confirmadas
     * Actualizamos tabla HLT_ARG_TRZ_AMT en BD
   */     
  private function getTransaccionesNoConfirmadas( $dConexionSOAP ) {

		$lo_trzmdl = $this->co_reg->load->model('hltargtrz');
		
    $this->data['err'] = array();
    $cantTransccionesActualizadas = 0;

    $soap_consulta_Header= '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
															<wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
																<wsse:Username>testwservice</wsse:Username> 
																<wsse:Password>testwservicepsw</wsse:Password> 
															</wsse:UsernameToken> 
														</wsse:Security>';
    
    // create new soap client
    try {  	
      $this->soapClient = new nusoap_client( $dConexionSOAP['HLT_ARG_TRZ_URL'] , false );
    } catch(SoapFault $lv_err) {
      $this->data['err'][] = array('errcod'=>-1001, 'errtxt'=>'Error al realizar la conexion Soap en getTransaccionesNoConfirmadas()');
      return false;
    }

		// Set timeouts, nusoap default is 30
		$this->soapClient->timeout = 0;
		$this->soapClient->response_timeout = 240;
		
		$lv_pgeqty = 100;
		$lv_pgenum = 1;
		$lp_arr=array('arg0' => $dConexionSOAP['HLT_ARG_TRZ_USR'],
									'arg1' => $dConexionSOAP['HLT_ARG_TRZ_PWD'],
									'arg5' => $dConexionSOAP['HLT_ARG_TRZ_GLN'],
									);
		while($lv_pgenum!=0) {
			$lp_arr['arg19'] = $lv_pgenum;
			$lp_arr['arg20'] = $lv_pgeqty;			
			$this->soapClient->setHeaders($soap_consulta_Header);
			$aResult = $this->soapClient->call('getTransaccionesNoConfirmadas', $this->prepareArgs($lp_arr), '' );
			if ($this->soapClient->fault) { // Error 
					$this->data['err'][] = array('errcod'=>-1002,'errtxt'=>'Error al realizar la consulta Soap en getTransaccionesNoConfirmadas()');
					return false;
			}
			
			// Detectar si se devuelve error en la consulta Soap - $result['hay_error'] (Boolean)   $result['errores'] (['_c_error'](Long)['_d_error'](text))
			if( $aResult && isset($aResult['hay_error']) ) { // Error 
					$this->data['err'][] = array('errcod'=>-1003,'errtxt'=>'Error devuelto en consulta Soap. Codigo Error: '.$aResult['errores']['_c_error'].' - '.$aResult['errores']['_d_error']);
					return false;
			}
			
			if( $aResult && isset($aResult['list']) && is_array($aResult['list']) ) {
				foreach( $aResult['list'] as $lv_row ) {
					// preparo array de datos a grabar
					$lo_dat = array();
					$lo_dat['id_transaccion'] = 				$lv_row['_id_transaccion'];
					$lo_dat['id_transaccion_global'] = 	$lv_row['_id_transaccion_global'];
					$lo_dat['gln_origen'] = 						$lv_row['_gln_origen'];
					$lo_dat['gln_destino'] = 						$lv_row['_gln_destino'];
					$lo_dat['gtin'] = 									$lv_row['_gtin'];
					$lo_dat['lote'] = 									$lv_row['_lote'];
					$lo_dat['numero_serial'] = 					$lv_row['_numero_serial'];
					$lo_dat['id_evento'] = 							$lv_row['_id_evento'];
					$lo_dat['n_remito'] = 							$lv_row['_n_remito'];
					$lo_dat['TrzTypCod'] = 							'M';
					$lo_dat['docsts'] = 								'A';
					
					// grabo el registro
					if ( $lo_trzmdl->save( $lo_dat ) ) {
						$cantTransccionesActualizadas++;
					} else {
						$this->data['err'][] = array('errcod'=>-1005,'errtxt'=>'Error al grabar id_transacción='.$lo_dat['id_transaccion']);
					}
				}

				//$lv_pgenum = ($lv_pgeqty==count($aResult['list'])?$lv_pgenum+1:0);
				//$lv_pgenum = (count($aResult['list'])==0?0:$lv_pgenum+1);
				$lv_pgenum = (intval($aResult['cantPaginas'])>=$lv_pgenum?0:$lv_pgenum+1);
      } else { 
				$lv_pgenum = 0; 
			}
    }
    return $cantTransccionesActualizadas;
  }
  

  private function prepareArgs( $lp_arr = array(), $lp_ns1='' ) {
    $lv_buffer = '';
    foreach($lp_arr as $lv_key=>$lv_val) {
      $lv_buffer.= '<'.$lv_key.'>'.$lv_val.'</'.$lv_key.'>';
    }
    return $lv_buffer;
  }
	
}
?>
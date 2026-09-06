<?php 
require_once('library/plugins/nusoap/lib/nusoap.php');

final class hltargtrztrx extends tmssAction {

  private $co_reg;
  private $data = array();

	//ENTRENAMIENTO
	//private $cv_wsdl = 'https://servicios.pami.org.ar/trazamed.WebService?wsdl';
	//private $cv_xmlsec =  'hltargtrztrxsec.xml';	

	//PRODUCCION
	private $cv_wsdl = 'https://trazabilidad.pami.org.ar:9050/trazamed.WebService?wsdl';
	private $cv_xmlsec =  'hltargtrztrxsec.xml';

  private $cv_usrcod = '9992560700005';
  private $cv_usrpwd = 'Teaminfusion2014';  
  private $co_soapClient;



  function __construct( $lp_reg ) { 
    set_time_limit(0);
    $this->co_reg = $lp_reg;

    // create new soap client
    try {  	
   	  //$this->co_soapClient = new soapclient( $this->cv_wsdl );
      $this->co_soapClient = new nusoap_client( $this->cv_wsdl , false );
    } catch(SoapFault $lv_err) {
      echo 'Sorry, webservice returned the following ERROR: '.$lv_err->faultcode.'-'.$lv_err->faultstring.'.';
  	}

    // get & assign security header 
    try {  	
      $lv_hdrsec = file_get_contents(__SITE_PATH.'/model/'.$this->cv_xmlsec);
   	  $this->co_soapClient->setHeaders( $lv_hdrsec );
    } catch(SoapFault $lv_err) {
      echo 'Sorry, webservice returned the following ERROR: '.$lv_err->faultcode.'-'.$lv_err->faultstring.'.';
  		//var_dump($this->co_soapClient);			
   	}
    
  }
  
  function __destruct() {
    // Kill the link to Soap 
    unset($this->co_soapClient); 
  }

  function __get( $lp_key ) {
    return (isset($this->data[$lp_key])?$this->data[$lp_key]:'');
  }
  
  function __set( $lp_key, $lp_val ) {
    $this->data[$lp_key] = $lp_val;
  }

  public function index( $lp_act , $lp_prm = array() ) {
    switch( $lp_act ) {
      case '08':
        break;
      case '18':
        $this->getTransaccionesNoConfirmadas();
        break;
      case '19':
        $this->getTransaccionesWS();
        break;
    }
  }
  
  private function prepareArgs( $lp_ns1, $lp_arr = array() ) {
    $lv_buffer = '';
		$lv_buffer.= '<ns1:'.$lp_ns1.' xmlns:ns1="http://tempuri.org">';
		//$lv_buffer ='<arg0>'.$lp_usrcod.'</arg0><arg1>'.$lp_usrpwd.'</arg1>';
		//$lv_buffer ='<arg0>';
		foreach($lp_arr as $lv_key=>$lv_val) {
			$lv_buffer.= '<'.$lv_key.'>'.$lv_val.'</'.$lv_key.'>';
		}
		//$lv_buffer.='</arg0>';
		//$lv_buffer.='<arg1>'.$lp_usrcod.'</arg1><arg2>'.$lp_usrpwd.'</arg2>';
    $lv_buffer.='</ns1:'.$lp_ns1.'>';
    return $lv_buffer;
  }

  
  private function checkResponse( $lp_ret ){
    $lv_trxid = '';
    $lv_trxsts = '';  
    $lv_errlst = array();

    if ( is_array($lp_ret) ) {
      if(array_key_exists('return', $lp_ret)){
        $lv_trxsts = $lp_ret['return']['resultado'];
        $lv_trxid = '';
        if(array_key_exists('codigoTransaccion', $lp_ret['return'])){
          $lv_trxid = $lp_ret['return']['codigoTransaccion'];
        } else {
          //Si es una confirmacion de la recepcion
          if(array_key_exists('id_transac_asociada', $lp_ret['return'])){                
            $lv_trxid = $lp_ret['return']['id_transac_asociada'];
          }
        }
        if(array_key_exists('errores', $lp_ret['return'])){
          $lv_err = $lp_ret['return']['errores'];             
          foreach ($lv_err as $lv_key => $lv_val){
             if(is_array($lv_val)){
                  $lv_errlst[] = array( 'errcod' => $lv_val['_c_error'], 'errtxt' => $lv_val['_d_error'] );
             } else {
                  $lv_errlst[] = array( 'errcod' => '', 'errtxt' => $lv_val );                        
             }
          }
        }
      }
    }
    $lv_ret = array( 'trxid' => $lv_trxid, 'trxsts' => $lv_trxsts, 'errlst' => $lv_errlst );
    return $lv_ret;
  }

    
  /**
   * Trae un listado de las transacciones donde el agente es el destino y no están
   * confirmadas por el agente receptor.
   * El usuario (laboratorio/droguería/operador logístico/farmacia) mediante esta
   * capacidad, puede ver todas las transacciones donde él es el destino, y no están
   * confirmadas. Mediante este listado se obtienen los números de transacción individual (a
   * nivel medicamento seriado) para poder invocar la capacidad de confirmar o alertar
   * transacción.   
   */
  public function getTransaccionesNoConfirmadas() {

    if (!$this->co_soapClient) {
      die('no connection to ws.');
      return false;
    }

    // assign webservice inbound parameters
    $lo_arr = array(
      
    );
          
    // Call RemoteFunction () 
    //$info = $this->co_soapClient->__call('getTransaccionesNoConfirmadas', $this->prepareArgs($lo_arr, $this->cv_usrcod, $this->cv_usrpwd) , '' ); 
    $lo_ret = $this->co_soapClient->call('getTransaccionesNoConfirmadas', $this->prepareArgs($lo_arr, $this->cv_usrcod, $this->cv_usrpwd) ); 

    // check error
		$lv_err = '';
		if($this->co_soapClient->fault) {		
      echo 'Sorry, webservice returned the following ERROR: '.$lv_err->faultcode.'-'.$lv_err->faultstring.'.';
      echo $this->co_soapClient->getError(); 
		  //$lv_err = $this->co_soapClient->getError();
      //return false;
		}

		//echo '<h2>Request</h2><pre>' . htmlspecialchars($this->co_soapClient->request, ENT_QUOTES) . '</pre>';
		//echo '<h2>Response</h2><pre>' . htmlspecialchars($this->co_soapClient->response, ENT_QUOTES) . '</pre>';
		//echo '<h2>Debug</h2><pre>' . htmlspecialchars($this->co_soapClient->debug_str, ENT_QUOTES) . '</pre>';
        
echo '<h1>Respuesta - print_r</h1>';
    print_r( $lo_ret );
echo '<h1>Respuesta - var_dump</h1>';
    var_dump( $lo_ret );
echo '<h1>Respuesta - echo</h1>';
    echo $lo_ret;
        
    return $lo_ret;
    
  }    
  
  
  /**  
   * Obtiene los movimientos realizados por determinado agente y permite todo tipo de filtros
   * de búsqueda. Con esta capacidad es posible obtener las transacciones registradas en el
   * SNT con su correspondiente identificación y datos. Símil a la pantalla de la web de Consulta
   * de movimientos.
   */
  public function getTransaccionesWS() {

    if (!$this->co_soapClient) {
      die('no connection to ws.');
      return false;
    }

    // assign webservice inbound parameters
    $lo_arr = array(
      'arg0' => $this->cv_usrcod
      ,'arg1' => $this->cv_usrpwd
      ,'arg4' => $this->cv_usrcod
    );
/*
      'arg0' => $this->cv_usrcod
      ,'arg1' => $this->cv_usrpwd
      ,'arg2' => -1
      ,'arg3' => ''
      ,'arg4' => $this->cv_usrcod
      ,'arg5' => ''
      ,'arg6' => -1
      ,'arg7' => ''
      ,'arg8' => ''
      ,'arg9' => ''
      ,'arg10' => ''
      ,'arg11' => ''
      ,'arg12' => ''
      ,'arg13' => ''
      ,'arg14' => ''
      ,'arg15' => -1
      ,'arg16' => -1
*/
      //'gln_destino' => $this->cv_usrcod
    $lo_prm = $this->prepareArgs('getTransaccionesWS', $lo_arr, $this->cv_usrcod, $this->cv_usrpwd);
          
    // Call RemoteFunction () 
    //$info = $this->co_soapClient->__call('getTransaccionesNoConfirmadas', $this->prepareArgs($lo_arr, $this->cv_usrcod, $this->cv_usrpwd) , '' ); 
    $lo_ret = $this->co_soapClient->call('getTransaccionesWS', $lo_prm, '' ); 

    // check error
		$lv_err = '';
		if($this->co_soapClient->fault) {		
      echo 'Sorry, webservice returned the following ERROR: '.$lv_err->faultcode.'-'.$lv_err->faultstring.'.';
      echo $this->co_soapClient->getError(); 
		  //$lv_err = $this->co_soapClient->getError();
      //return false;
		}


echo '<h1> datos </h1>';
    print_r( $this->checkResponse( $lo_ret ) );

		echo '<h2>Request</h2><pre>' . htmlspecialchars($this->co_soapClient->request, ENT_QUOTES) . '</pre>';
		echo '<h2>Response</h2><pre>' . htmlspecialchars($this->co_soapClient->response, ENT_QUOTES) . '</pre>';
		echo '<h2>Debug</h2><pre>' . htmlspecialchars($this->co_soapClient->debug_str, ENT_QUOTES) . '</pre>';
        
         
    return $lo_ret;
    
  }    

} 
    
?>
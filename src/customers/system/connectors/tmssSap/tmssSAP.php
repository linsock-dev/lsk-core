<?PHP

	#Define Authentication 
	$SOAP_AUTH = array( 'login'    => 'pnoval',
											'password' => 'Test02');

	// $lp_url = "http://host:port/XISOAPAdapter/MessageServlet?channel=party:service:channel";
	$lp_url_srv = "http://srv-qas-pi01:50000/XISOAPAdapter/MessageServlet?channel=:BS_UAQ800:CC_XI_RCV_CreaProducto";

	#Specify WSDL
	$lv_url_wsdl = "http://srv-qas-pi01.iae.austral:50000/dir/wsdl?p=sa/fa065886ec733ec28b34645298a7ccb7";
	//$lv_url_wsdl = "http://srv-qas-pi01.iae.austral:50000/dir/wsdl?ot=sa&senderParty=&senderService=TPBS_BPM_Q&receiverParty=&receiverService=BS_UAQ800&interface=SI_IA_CreaProductoSAP&interfaceNamespace=urn:bpm:consultaws:altaproductos";

	#Create Client Object, download and parse WSDL
	$lo_sap = new SoapClient($lv_url_wsdl,$SOAP_AUTH);

	//$lo_sap = new tmssSAP_soap();
	//$lo_sap->SAPConnect( $lv_url_wsdl, array("trace" => 1, "exception" => 0) );

	/*$lo_sap->SAPCall( "creapriducto",
										array( 
												"DeleteMarketplaceAd" => array( 
														"accountID"       => $accountId, 
														"marketplaceAdID" => "9938745"        // The ads ID 
													) 
												),
										$lo_sap->SAPHeader()
									);

    #Create Client Object, download and parse WSDL
    $client = new SoapClient($WSDL,$SOAP_AUTH);
*/    
    #Setup input parameters (SAP Likes to Capitalise the parameter names)
//"rowMateriales"
    $params = array(	"MP_Producto_BPM" => array(
												"idProducto" => "",
												"linea" => "",
												"tipo" => "",
												"celula" => "",
												"nombreSAP" => "",
												"nombreCom" => "",
												"nombreIng" => "",
												"inicio" => "",
												"fin" => "",
												"bloqProd" => ""
											)
										);

    #Call Operation (Function). Catch and display any errors
    try {
       $result = $lo_sap->SI_OA_CreaProductoBMP($params);
    } catch (SoapFault $exception) {
        print "***Caught Exception***\n";
        print_r($exception);
        print "***END Exception***\n";
        die();
    }
    
    #Out the results
    print_r($result);


class tmssSAP_soap {

	//constant $URL_WSDL = "http://<hostname>:<port>/sap/bc/srt/rfc/sap/<service name>?WSDL";
	//constant $URL_WSDL = "http://srv-qas-pi01:50000/sap/bc/srt/rfc/sap/?WSDL";
		
	//private $devKey        = ""; 
	//private $password    = ""; 
	//private $accountId    = ""; 
	private $go_cnx;
	private $data = array();
	//private $go_hdr;
	
	
	
	public function SAPConnect( $lp_url_wsdl, $lp_opt=array() ) {
		$this->data["wsdl"] = $lp_url_wsdl;
		// Create the SoapClient instance 
		$this->go_cnx = new SoapClient($lp_url_wsdl, array("trace" => 1, "exception" => 0));
	}

	public function setHeader( $lp_hdr, $lp_aut ) {
		$this->go_hdr = new SoapHeader("http://www.example.com/webservices/", "APICredentials", $lp_aut, false);
	}
	
	public function SAPCall( $lp_srvnme, $lp_data=array(), $lp_soap_header ) {
		// Call wsdl function 
		$result = $this->go_cnx->__soapCall( $lp_srvnme , $lp_data, NULL, $lp_soap_header
		); 

		// Echo the result 
		echo "<pre>".print_r($result, true)."</pre>"; 
		if($result->DeleteMarketplaceAdResult->Status == "Success") { 
			echo "Item deleted!"; 
		} 
	}

}

?>
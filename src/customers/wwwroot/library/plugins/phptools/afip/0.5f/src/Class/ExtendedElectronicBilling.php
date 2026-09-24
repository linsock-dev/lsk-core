<?php
/**
 * SDK for AFIP Electronic Billing with items (wsmtxca)
 *
 * @link http://www.afip.gob.ar/fe/documentos/WebServiceMTXCAv08.pdf WS Specification
 *
 * @author      Ivan Muñoz
 * @package Afip
 * @version 0.1
 **/
class ExtendedElectronicBilling extends AfipWebService {

    var $soap_version = SOAP_1_2;
    var $WSDL         = 'wsmtxca-production.wsdl';
    var $URL          = 'https://serviciosjava.afip.gob.ar/wsmtxca/services/MTXCAService';
    var $WSDL_TEST    = 'wsmtxca.wsdl';
    var $URL_TEST     = 'https://fwshomo.afip.gov.ar/wsmtxca/services/MTXCAService';

    /**
     * Asks to AFIP Servers for aliquot availables {@see WS
     * Specification item 2.4.16}
     *
     * @since 0.?
     *
     * @return array All aliquot availables
     **/
    public function GetAliquotTypes()
    {
        return $this->ExecuteRequest('ConsultarAlicuotasIVA')->arrayAlicuotasIVA->codigoDescripcion;
    }

    /**
     * Asks to AFIP Servers for aliquot conditions {@see WS
     * Specification item 2.4.17}
     *
     * @since 0.?
     *
     * @return array All aliquot conditions availables
     **/
    public function GetAliquotConditions()
    {
        return $this->ExecuteRequest('ConsultarCondicionesIVA')->arrayCondicionesIVA->codigoDescripcion;
    }

    /**
     * Asks to AFIP Servers for currencies availables {@see WS
     * Specification item 2.4.18}
     *
     * @since 0.?
     *
     * @return array All currencies availables
     **/
    public function GetCurrenciesTypes()
    {
        return $this->ExecuteRequest('consultarMonedas')->arrayMonedas->codigoDescripcion;
    }

    /**
     * Asks to AFIP Servers for currency exchange rate {@see WS
     * Specification item 2.4.19}
     *
     * @since 0.7
     *
     * @return string|Object String representation of currency exchange rate, or full response object on error
     **/
    public function GetCurrencyExchangeRate($currencyCode)
    {
        $response = $this->ExecuteRequest(
            'consultarCotizacionMoneda',
            ['codigoMoneda' => $currencyCode]
        );

        return property_exists($response, 'cotizacionMoneda') ? $response->cotizacionMoneda : $response;
    }

    /**
     * Asks to AFIP Servers for points of sale availables {@see WS
     * Specification item 2.4.21}
     *
     * @since 0.?
     *
     * @return array All points of sale availables
     **/
    public function GetPointsOfSale()
    {
        return $this->ExecuteRequest('consultarPuntosVenta')->arrayPuntosVenta;
    }

    /**
     * Asks to AFIP Servers for voucher types availables {@see WS
     * Specification item 2.4.14}
     *
     * @since 0.?
     *
     * @return array All voucher types availables
     **/
    public function GetVoucherTypes()
    {
        return $this->ExecuteRequest('consultarTiposComprobante')->arrayTiposComprobante->codigoDescripcion;
    }

    /**
     * Asks to AFIP Servers for additional types availables {@see WS
     * Specification item 2.4.25}
     *
     * @since 0.?
     *
     * @return array All additional types availables
     **/
    public function GetAdditionalTypes()
    {
        return $this->ExecuteRequest('consultarTiposDatosAdicionales')->arrayTiposDatosAdicionales->codigoDescripcion;
    }

    /**
     * Asks to AFIP Servers for document types availables {@see WS
     * Specification item 2.4.15}
     *
     * @since 0.?
     *
     * @return array All document types availables
     **/
    public function GetDocumentTypes()
    {
        return $this->ExecuteRequest('consultarTiposDocumento')->arrayTiposDocumento->codigoDescripcion;
    }

    /**
     * Asks to AFIP Servers for tax types availables {@see WS
     * Specification item 2.4.24}
     *
     * @since 0.?
     *
     * @return array All tax types availables
     **/
    public function GetTaxTypes()
    {
        return $this->ExecuteRequest('consultarTiposTributo')->arrayTiposTributo->codigoDescripcion;
    }

    /**
     * Asks to AFIP Servers for measurements units availables {@see WS
     * Specification item 2.4.24.1}
     *
     * @since 0.?
     *
     * @return array All measurements units availables
     **/
    public function GetMeasurementUnits()
    {
        return $this->ExecuteRequest('consultarUnidadesMedida')->arrayUnidadesMedida->codigoDescripcion;
    }

    /**
     * Get complete voucher information
     *
     * Asks to AFIP servers for complete information of voucher {@see WS
     * Specification item 2.4.13}
     *
     * @since 0.?
     *
     * @param int $number       Number of voucher to get information
     * @param int $sales_point  Sales point of voucher to get information
     * @param int $type         Type of voucher to get information
     *
     * @return array|null returns array with complete voucher information
     *  {@see WS Specification item 2.4.13} or null if there not exists
     **/
    public function GetVoucherInfo($number, $sales_point, $type)
    {
        $req = [
            'consultaComprobanteRequest' => [
                'numeroComprobante' => $number,
                'numeroPuntoVenta' => $sales_point,
                'codigoTipoComprobante' => $type
            ]
        ];

        return $this->ExecuteRequest('consultarComprobante', $req);
    }

    /**
     * Get CAE Points of sale
     *
     * Asks to AFIP servers for CAE points of sale {@see WS
     * Specification item 2.4.22}
     *
     * @since 0.?
     *
     * @return array|null returns array of CAE points of sale
     *  {@see WS Specification item 2.4.22}
     **/
    public function GetCAEPointsOfSale()
    {
        return $this->ExecuteRequest('consultarPuntosVentaCAE')->arrayPuntosVenta;
    }

    /**
     * Authorize voucher
     *
     * Asks to AFIP servers to authorize a voucher {@see WS
     * Specification item 2.4.2}
     *
     * @since 0.?
     *
     * @param array $voucher data of voucher to authorize
     *
     * @return array|null returns array with complete voucher information
     *  {@see WS Specification item 2.4.2}
     **/
    public function AuthorizeVoucher($voucher)
    {
        $defaultData = [
            'codigoTipoComprobante'      => 1, // Default: 1 -> Factura A
            'numeroPuntoVenta'           => 1, // Default: 1
            // 'numeroComprobante'          => 1, // > 0
            //                                 // El número de comprobante informado debe ser mayor en 1 al último informado para igual punto de venta y tipo de comprobante
            'fechaEmision'               => date('Y-m-d'), // Default: HOY
            // 'codigoTipoAutorizacion'     => 'A', // El Tipo de Código de Autorización no debe informarse: será otorgado por este Organismo - A|E
            // 'codigoAutorizacion'         => 0, // El Código de Autorización no debe informarse: será otorgado por este Organismo
            // 'fechaVencimiento'           => date('Y-m-d'), // La Fecha de Vencimiento del Código de Autorización no debe informarse: será otorgada por este Organismo
            'codigoTipoDocumento'        => 80, // Default: 80 (CUIT) - Para los Tipos de Comprobante A (1, 2 o 3) el Tipo de Documento del Receptor debe ser 80 (CUIT)
            // 'numeroDocumento'            => 0, // Para los Tipos de Comprobante A (1, 2 o 3) el Receptor informado debe estar activo como Responsable Inscripto en IVA
            'importeGravado'             => 0, // El Importe Gravado debe ser igual (dentro del margen de error permitido) a la sumatoria de importes de los ítems menos la sumatoria de los importes IVA de los ítems, con excepción de ítems exentos y no gravados.
            // 'importeNoGravado'             => 0, //
            'importeExento'              => 0, // Debe informar el Importe No Gravado ya que existen Ítems No Gravados
            'importeSubtotal'            => 0, // El Importe Subtotal debe coincidir (dentro del margen de error permitido) con la sumatoria del Importe No Gravado, Importe Gravado e Importe Exento.
            // 'importeOtrosTributos'       => 0, // Si informa el Importe de Otros Tributos debe informar el detalle de los mismos (y viceversa)
            'importeTotal'               => 0, // El Importe Total debe ser igual a la sumatoria de Importes de Items y el Importe de Otros Tributos.
            'codigoMoneda'               => 'PES', // Default: PES (Peso argentino)
            'cotizacionMoneda'           => 1, // Default: 1 (El peso siempre cotiza 1) - > 0
            // 'observaciones'              => '', // Default: sin observaciones
            'codigoConcepto'             => 1, // Default: 1 (Productos) - El Código de Concepto debe ser igual a alguno de los siguientes valores: 1 - Productos, 2 - Servicios o 3 - Productos y Servicios
            // 'fechaServicioDesde'         => date('Y-m-d'), // La Fecha de Servicio Desde no debe informarse dado que se indicó Concepto Productos
            // 'fechaServicioHasta'         => date('Y-m-d'), // La Fecha de Servicio Hasta no debe informarse dado que se indicó Concepto Productos
            // 'fechaVencimientoPago'       => date('Y-m-d'), // La Fecha de Vencimiento de Pago no debe informarse dado que se indicó Concepto Productos
            // 'fechaHoraGen'               => date('Y-m-d\TH:i:s'), // El campo Fecha/Hora de Generación solo debe informarse para comprobantes CAEA por contingencia - Formato AAAA-MM-DDTHH:MM:SS
            // 'arrayComprobantesAsociados' => [], // Si se incluye el grupo de comprobantes asociados, debe incluirse dentro de éste al menos un comprobante asociado
            // 'arrayOtrosTributos'         => [], // Si se incluye el grupo de otros tributos, debe incluirse dentro de éste al menos un tributo
            //                                     // Si informa el Importe de Otros Tributos debe informar el detalle de los mismos (y viceversa)

            // 'arrayItems'                 => [], // Obligatorio
            //                                     // Ítem 1: El campo Unidades de Referencia es obligatorio dado que el ítem no es una seña o descuento
            //                                     // Ítem 1: Si informa un ítem no gravado, exento o IVA 0%, el Importe IVA debe ser 0 (cero)
            //                                     // Ítem 1: El Importe IVA debe ser igual a (Precio Unitario * Cantidad - Importe Bonificación) * Alícuota de IVA correspondiente. Se indicó: 21.00 - Se esperaba: 0.00
            //                                     // Ítem 1: El Importe del Ítem debe ser igual a (Precio Unitario sin IVA * Cantidad - Importe Bonificación) * (1 + Alícuota de IVA correspondiente).

            // 'arraySubtotalesIVA'         => [], // Si se incluye el grupo de subtotales IVA, debe incluirse dentro de éste al menos un subtotal IVA
            //                                     // El array de Subtotales IVA debe informarse dado que se incluyeron ítems gravados con IVA > 0%
            //                                     // Subtotal IVA 1: Código de Alícuota IVA inválido. Valores permitidos: 4, 5 o 6
            //                                     // Se indicó al menos un ítem gravado al 21% (código 5) y no se incluyó la correspondiente entrada en la lista de Subtotales IVA

            // 'arrayDatosAdicionales'      => [], // Si se incluye el grupo de datos adicionales, debe incluirse dentro de éste al menos un dato adicional

            // 'arrayCompradores'           => [] // Si se incluye el grupo de compradores, debe incluirse dentro de éste al menos un comprador
        ];

        $voucherData = array_merge($defaultData, $voucher);
        $req = [
            'comprobanteCAERequest' => $voucherData
        ];

        $result = $this->ExecuteRequest('autorizarComprobante', $req);

        return $result; // TODO ->comprobanteResponse
    }

    /**
     * Authorize IVA adjustement
     *
     * Asks to AFIP servers to authorize IVA adjustement {@see WS
     * Specification item 2.4.3}
     *
     * @since 0.?
     *
     * @param int $number               Number of voucher to get information
     * @param int $sales_point  Sales point of voucher to get information
     * @param int $type                         Type of voucher to get information
     *
     * @return array|null returns array with complete authorization information
     *  {@see WS Specification item 2.4.3}
     **/
    public function AuthorizeIVAAdjustement($adjustement)
    {
        $defaultData = [
            'codigoTipoComprobante'      => 2, // Default: 1 (Nota de Débito A)
            'numeroPuntoVenta'           => 1,
            // 'numeroComprobante'          => 1, // > 0
            'fechaEmision'               => date('Y-m-d'), // Default: HOY
            // 'codigoTipoAutorizacion'     => 'A', // El Tipo de Código de Autorización no debe informarse: será otorgado por este Organismo - A|E
            // 'codigoAutorizacion'         => 0, // El Código de Autorización no debe informarse: será otorgado por este Organismo
            // 'fechaVencimiento'           => date('Y-m-d'), // La Fecha de Vencimiento del Código de Autorización no debe informarse: será otorgada por este Organismo
            'codigoTipoDocumento'        => 80, // Default: 80 (CUIT) - Para los Tipos de Comprobante A (1, 2 o 3) el Tipo de Documento del Receptor debe ser 80 (CUIT)
            // 'numeroDocumento'            => 0, // Para los Tipos de Comprobante A (1, 2 o 3) el Receptor informado debe estar activo como Responsable Inscripto en IVA
            'importeGravado'             => 0, // El Importe Gravado debe ser igual (dentro del margen de error permitido) a la sumatoria de importes de los ítems menos la sumatoria de los importes IVA de los ítems, con excepción de ítems exentos y no gravados.
            // 'importeNoGravado'             => 0, //
            'importeExento'              => 0, // Debe informar el Importe No Gravado ya que existen Ítems No Gravados
            'importeSubtotal'            => 0, // El Importe Subtotal debe coincidir (dentro del margen de error permitido) con la sumatoria del Importe No Gravado, Importe Gravado e Importe Exento.
            // 'importeOtrosTributos'       => 0, // Si informa el Importe de Otros Tributos debe informar el detalle de los mismos (y viceversa)
            'importeTotal'               => 0, // El Importe Total debe ser igual a la sumatoria de Importes de Items y el Importe de Otros Tributos.
            'codigoMoneda'               => 'PES', // Default: PES (Peso argentino)
            'cotizacionMoneda'           => 1, // Default: 1 (El peso siempre cotiza 1 ) - > 0
            // 'observaciones'              => '',
            'codigoConcepto'             => 1, // Default: 1 (Productos) El Código de Concepto debe ser igual a alguno de los siguientes valores: 1 - Productos, 2 - Servicios o 3 - Productos y Servicios
            // 'fechaServicioDesde'         => date('Y-m-d'), // La Fecha de Servicio Desde no debe informarse dado que se indicó Concepto Productos
            // 'fechaServicioHasta'         => date('Y-m-d'), // La Fecha de Servicio Hasta no debe informarse dado que se indicó Concepto Productos
            // 'fechaVencimientoPago'       => date('Y-m-d'), // La Fecha de Vencimiento de Pago no debe informarse dado que se indicó Concepto Productos
            // 'fechaHoraGen'               => date('Y-m-d\TH:i:s'), // El campo Fecha/Hora de Generación solo debe informarse para comprobantes CAEA por contingencia - Formato AAAA-MM-DDTHH:MM:SS
            // 'arrayComprobantesAsociados' => [], // Si se incluye el grupo de comprobantes asociados, debe incluirse dentro de éste al menos un comprobante asociado
            // 'arrayOtrosTributos'         => [], // Si se incluye el grupo de otros tributos, debe incluirse dentro de éste al menos un tributo
            //                                     // Si informa el Importe de Otros Tributos debe informar el detalle de los mismos (y viceversa)

            // 'arrayItems'                 => [], // Obligatorio
            //                                     // Ítem 1: El campo Unidades de Referencia es obligatorio dado que el ítem no es una seña o descuento
            //                                     // Ítem 1: Si informa un ítem no gravado, exento o IVA 0%, el Importe IVA debe ser 0 (cero)
            //                                     // Ítem 1: El Importe IVA debe ser igual a (Precio Unitario * Cantidad - Importe Bonificación) * Alícuota de IVA correspondiente. Se indicó: 21.00 - Se esperaba: 0.00
            //                                     // Ítem 1: El Importe del Ítem debe ser igual a (Precio Unitario sin IVA * Cantidad - Importe Bonificación) * (1 + Alícuota de IVA correspondiente).

            // 'arraySubtotalesIVA'         => [], // Si se incluye el grupo de subtotales IVA, debe incluirse dentro de éste al menos un subtotal IVA
            //                                     // El array de Subtotales IVA debe informarse dado que se incluyeron ítems gravados con IVA > 0%
            //                                     // Subtotal IVA 1: Código de Alícuota IVA inválido. Valores permitidos: 4, 5 o 6
            //                                     // Se indicó al menos un ítem gravado al 21% (código 5) y no se incluyó la correspondiente entrada en la lista de Subtotales IVA

            // 'arrayDatosAdicionales'      => [], // Si se incluye el grupo de datos adicionales, debe incluirse dentro de éste al menos un dato adicional

            // 'arrayCompradores'           => [] // Si se incluye el grupo de compradores, debe incluirse dentro de éste al menos un comprador
        ];

        $adjustementData = array_merge($defaultData, $adjustement);
        $req = [
            'comprobanteCAERequest' => $adjustementData
        ];

        $result = $this->ExecuteRequest('autorizarAjusteIVA', $req);

        return $result; // TODO ->comprobanteResponse
    }

    /**
     * Get CAEA Points of sale
     *
     * Asks to AFIP servers for CAEA points of sale {@see WS
     * Specification item 2.4.23}
     *
     * @since 0.?
     *
     * @return array|null returns array with CAEA points of sale
     *  {@see WS Specification item 2.4.23}
     **/
    public function GetCAEAPointsOfSale()
    {
        return $this->ExecuteRequest('consultarPuntosVentaCAEA')->arrayPuntosVenta;
    }

    /**
     * Get uninformed points of sale
     *
     * Asks to AFIP servers for uninformed points of sale {@see WS
     * Specification item 2.4.9}
     *
     * @since 0.?
     *
     * @return array|null returns array with uninformed points of sale
     *  {@see WS Specification item 2.4.9}
     **/
    public function GetCAEAUninformedPointsOfSale($caea)
    {
        return $this->ExecuteRequest('consultarPtosVtaCAEANoInformados', ['CAEA' => $caea]); // TODO ->arrayPuntosVenta;
    }

    /**
     * Get last voucher
     *
     * Asks to AFIP servers for last voucher {@see WS
     * Specification item 2.4.12}
     *
     * @since 0.?
     *
     * @param int $type         Type of voucher to get information
     * @param int $sales_point  Sales point of voucher to get information
     *
     * @return array|null returns array with complete voucher information
     *  {@see WS Specification item 2.4.12}
     **/
    public function GetLastVoucher($type, $sales_point)
    {
        $req = array(
            'consultaUltimoComprobanteAutorizadoRequest' => array(
                'codigoTipoComprobante' => $type,
                'numeroPuntoVenta' => $sales_point
            )
        );
        return $this->ExecuteRequest('consultarUltimoComprobanteAutorizado', $req);
    }

    /**
     * Create CAEA
     *
     * Asks to AFIP servers to create CAEA {@see WS
     * Specification item 2.4.4}
     *
     * @since 0.?
     *
     * @param int $period ...
     * @param int $order  ...
     *
     * @return array|null returns array with created CAEA information
     *  {@see WS Specification item 2.4.4}
     **/
    public function CreateCAEA($period, $order)
    {
        $req = [
            'solicitudCAEA' => [
                'periodo' => $period,
                'orden' => $order
            ]
        ];
        return $this->ExecuteRequest('solicitarCAEA', $req);
    }

    /**
     * Get complete CAEA information
     *
     * Asks to AFIP servers for complete information of CAEA {@see WS
     * Specification item 2.4.10}
     *
     * @since 0.?
     *
     * @param int $caea Number of caea to get information
     *
     * @return array|null returns array with complete information of CAEA
     *  {@see WS Specification item 2.4.10}
     **/
    public function GetCAEA($caea)
    {
        return $this->ExecuteRequest('consultarCAEA', ['CAEA' => $caea]); // TODO ->CAEAResponse
    }

    /**
     * Get CAEA between dates
     *
     * Asks to AFIP servers for CAEA between dates {@see WS
     * Specification item 2.4.11}
     *
     * @since 0.?
     *
     * @param string $from String representing the start date, in format YYYY-MM-DD
     * @param string $to   String representing the end date, in format YYYY-MM-DD
     *
     * @return array|null returns array with complete voucher information
     *  {@see WS Specification item 2.4.11}
     **/
    public function GetCAEABetweenDates($from, $to)
    {
        return $this->ExecuteRequest('consultarCAEAEntreFechas', ['fechaDesde' => $from, 'fechaHasta' => $to]); // TODO ->arrayCAEAResponse
    }

    /**
     * TODO corregir, NO FUNCIONA!!!
     *
     * Inform CAEA as unused
     *
     * Inform to AFIP servers an unused CAEA {@see WS
     * Specification item 2.4.7}
     *
     * @since 0.?
     *
     * @param int $caea CAEA number to inform as unused
     *
     * @return array|null returns array with ??????
     *  {@see WS Specification item 2.4.7}
     **/
    public function InformUnusedCAEA($caea)
    {
        try {
            $result = $this->ExecuteRequest('InformarCAEANoUtilizado', ['CAEA' => $caea]);
        } catch (Exception $e) {
            echo $e->getCode();
            echo $e->getMessage();

            echo "<br><br><br><br><br><br><br><br>";
            echo '<pre>';
            echo htmlentities($this->soap_client->__getLastRequest());
            echo htmlentities($this->soap_client->__getLastResponse());
            echo '</pre>';
            die;
        }

        return $result;
    }

    /**
     * Asks to web service for servers status {@see WS
     * Specification item 2.4.26}
     *
     * @since 0.?
     *
     * @return object { AppServer => Web Service status,
     * DbServer => Database status, AuthServer => Autentication
     * server status}
     **/
    public function GetServerStatus()
    {
        return $this->ExecuteRequest('dummy');
    }

    /**
     * Sends request to AFIP servers
     *
     * @since 0.?
     *
     * @param string $operation SOAP operation to do
     * @param array $params Parameters to send
     *
     * @return mixed Operation results
     **/
    public function ExecuteRequest($operation, $params = array())
    {
        $params = array_replace($this->GetWSInitialRequest($operation), $params);

        $results = parent::ExecuteRequest($operation, $params);

        $this->_CheckErrors($operation, $results);

        return $results;
    }

    /**
     * Make default request parameters for most of the operations
     *
     * @since 0.7
     *
     * @param string $operation SOAP Operation to do
     *
     * @return array Request parameters
     **/
    private function GetWSInitialRequest($operation)
    {
        if ($operation == 'dummy') {
            return [];
        }

        $ta = $this->afip->GetServiceTA('wsmtxca');

        return [
            'authRequest' => [
                'token' => $ta->token,
                'sign'  => $ta->sign,
                'cuitRepresentada'  => $this->afip->CUIT
            ]
        ];
    }

    /**
     * Check if occurs an error on Web Service request
     *
     * @since 0.7
     *
     * @param string $operation SOAP operation to check
     * @param mixed $results AFIP response
     *
     * @throws Exception if exists an error in response
     *
     * @return void
     **/
    private function _CheckErrors($operation, $results)
    {
        $res = $results;

        if ($operation == 'FECAESolicitar') {
            if (isset($res->FeDetResp->FECAEDetResponse->Observaciones) && $res->FeDetResp->FECAEDetResponse->Resultado != 'A') {
                $res->Errors = new StdClass();
                $res->Errors->Err = $res->FeDetResp->FECAEDetResponse->Observaciones->Obs;
            }
        }

        if (isset($res->Errors)) {
            $err = is_array($res->Errors->Err) ? $res->Errors->Err[0] : $res->Errors->Err;
            throw new Exception('('.$err->Code.') '.$err->Msg, $err->Code);
        }
    }
}

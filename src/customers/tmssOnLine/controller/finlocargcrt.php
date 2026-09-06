<?php
final class finlocargcrtController extends tmssController {
  
	const MODEL = 'finlocargcrt';						// **************************
	const VIEW  = 'finlocargcrt';						// **************************
	const ID = '';													// **************************
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  const FILE_ROOT = '../files';
	
  
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
  
  
  /**
   * main method
   */     
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
			
			
			case '#':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->buscod = $this->co_reg->sec->buscod; //$lo_post['buscod'];
				return $this->getView();
				break;
			
			
			
			// AFIP - WSAA - obtener solicitud de certificado
			case '#AfipReqGet':
				$lo_post = $this->co_reg->request->post;
				if( (isset($lp_prm['dwn'])?$lp_prm['dwn']:'')=='1' ) {
					$this->co_reg->response->addHeader('Content-Disposition: attachment; filename=SolicitudCertificadoAFIP.csr');
					$this->co_reg->response->addHeader('Content-Type: text/plain');
				}
				return $this->lo_mdl->getAuthRequest();
				break;
			
			
			
			// AFIP - generar colicitud de certificado (CSR - PKCS#10)
      case '#AfipReqSet':
				$lo_post = $this->co_reg->request->post;				
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod),false );
				if( $lo_busmdl->tax->taxdoctyp!='80' ) {
					return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>El tipo de impuesto debe ser 80 - CUIT.</errtxt>';
				} else if( $lo_busmdl->tax->taxcod=='' ) {
					return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>Debe indicar el número de CUIT.</errtxt>';
				}

				return $this->lo_mdl->setAuthRequest(array('C' => $lo_busmdl->adr->lndcod,	
																							'O' => utf8_encode($lo_busmdl->bustxt),
																							'CN' => strtolower($lo_busmdl->buscod).'.temasis.com.ar', 
																							'serialNumber' => 'CUIT '.$lo_busmdl->tax->taxcod)  );
				break;
			
			
			
			// AFIP - obtiene un certificado almacenado por AFIP
			case '#AfipCrtGet':
				$lo_post = $this->co_reg->request->post;				
				return $this->lo_mdl->getAuthCertificate();
				break;
			
			
			
			// AFIP - carga un certificado provisto por AFIP
			case '#AfipCrtSet':
				$lo_post = $this->co_reg->request->post;
				return $this->lo_mdl->setAuthCertificate( $lo_post['crt'] );
				break;
			
			
			
			/*
			
			// ----------------------------------------------------------------------
			//
			//  R E P O R T E S (SACAR DE ESTE CONTROLADOR)
			//
			// ----------------------------------------------------------------------
			// SACAR DE ESTE CONTROLADOR
			//
			//  I V A    C O M P R A S
			//
      case '#ivaCompras':
			
				// obtengo documentos de compra
				$lo_buymdl = $this->co_reg->load->model('buyinv');
				$lv_prm = array('vewfldflt' => '[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'C'.chr(9).chr(9),
												'vewfldord' => 'o.buyinvdte, o.buyinvcod'
												);
				$lo_rsbuy = $lo_buymdl->getList( $lv_prm);

				// obtengo precios
				$lo_prcmdl = $this->co_reg->load->model('grldatprc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.srcobjtyp'.chr(9).'='.chr(9).chr(9).'BUY_INV'.chr(9).chr(9).
																			(1==2?'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'C'.chr(9).chr(9):''),
												'vewfldord' => 'p.srcobjcod001'
												);
				$lo_rsprc = $lo_prcmdl->getList($lv_prm);
				
				// proceso reporte
				$lo_rsout = array();
				for($i=0; $i<count($lo_rsbuy); $i++) {
					$lo_rsout[] = array('BUYINVDTECNV'=>$lo_rsbuy[$i]['buyinvdtecnv'],
															'SRCOBJTXT'=>$lo_rsbuy[$i]['srcobjtxt'],
															'TAXCOD'=>$lo_rsbuy[$i]['taxcod'],
															'BUYINVDOCTYP'=>'FAC',
															'BUYINVDOCLTR'=>'A',
															'BUYINVCODEXT'=>$lo_rsbuy[$i]['buyinvcodext']);
					foreach($lo_rsprc as $lv_row) {
						if($lv_row['srcobjcod001']==$lo_rsbuy[$i]['buyinvcod']) {
							$lo_rsout[$i]['PRC'.$lv_row['prccndcodext']] = $lv_row['prccndtot'];
						}
					}
				}
				
				return $lo_rsout;
        break;
				*/
    }

  }
	
	private function getView() {
		$lv_prm = array('lang'  => $this->co_reg->language,
										'input' => $this->co_reg->input,
										'sec' => $this->co_reg->sec,
										'doc' => $this->co_reg->document,
										'data' => $this->lo_mdl,
										'actcod' => $this->data['actcod']
										);
		$lv_ret = $this->co_reg->load->view( self::VIEW, $lv_prm );
		return $lv_ret;
	}
}
?>

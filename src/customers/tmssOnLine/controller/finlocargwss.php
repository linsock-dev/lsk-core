<?php
final class finlocargwssController extends tmssController {  
	const MODEL = 'finlocargcrt';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
	private $fcelog = array();
  const FILE_ROOT = '../files';
	
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
	function __get( $lp_key ) { return ($lp_key=='fcelog' ? $this->fcelog : (isset($this->data[$lp_key]) ? $this->data[$lp_key] : '' )); }
	function __set( $lp_key, $lp_val ) { $this->data[$lp_key] = $lp_val; }	
	private function addLog( $lp_data ) { $this->data['log'][] = $lp_data; }
	
	
  // INDEX. metodo principal de la clase
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
			
			
			// ----------------------------------------------------------------------
			//
			//   C O N S T A N C I A    D E    I N S C R I P C I O N ==> CAMBIAR
			//   AFIP - obtiene la constancia de inscripción de una CUIT
			//
			// ----------------------------------------------------------------------
			// tmssCallProcess("?prg=finlocargwss&act=AfipCnsIns",[{"idPersona"=>"20264879044"}],function(data){});
			case '#AfipCnsIns':
				$lo_post = $this->co_reg->request->post;
				
				$lv_frmchk = (isset($lp_prm['frmchk'])?$lp_prm['frmchk']:'');
				$lv_itznme = 'AFIP_CNS_INS';
				$lv_mthnme = 'getPersona_v2';
				$lv_srvnme = 'ws_sr_constancia_inscripcion';
				$this->fcelog = array();
				$lo_data = array();
				$lo_data['errtyp'] = 'S';

				// cargo datos de empresa actual
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
				$lv_cfg = array('service'=>$lv_srvnme,'cuit'=>$lo_busmdl->tax->taxcod);
				
				// valido info
				if( (isset($lo_post['idPersona'])?$lo_post['idPersona']:'')=='' && $lv_frmchk=='' ) {
					$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'AfipCnsIns. No se Indicó [idPersona] a consultar.');
					$lo_data['log'] = $this->fcelog;
					$lo_data['errtyp'] = 'E';
					$lo_data['errcod'] = -1;
					$lo_data['errtxt'] = 'No se Indicó [idPersona] a consultar.';

				// cargo url servicio y wsdl de login AFIP WSAA
				} else if($this->loadUrlWSAA()==false){
					$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'AfipCnsIns. Error al cargar URL de servicio WSAA.');
					$lo_data['log'] = $this->fcelog;
					$lo_data['errtyp'] = 'E';
					$lo_data['errcod'] = -1;
					$lo_data['errtxt'] = 'Error al cargar URL de servicio WSAA.';

				// INTERFAZ. cargo el id interno de interfaz
				} else if($this->loadUrlWSN( $lv_itznme )==false) {
					$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'AfipCnsIns. Error al obtener definicion de interfaz ['.$lv_itznme.'].');
					$lo_data['log'] = $this->fcelog;
					$lo_data['errtyp'] = 'E';
					$lo_data['errcod'] = -1;
					$lo_data['errtxt'] = 'Error al obtener definicion de interfaz ['.$lv_itznme.'].';

				// para verificar si la interfaz esta activa solo se necesita hasta este punto
				} else if($lv_frmchk!=''){
					$lo_data['errtyp'] = 'S';
					$lo_data['errcod'] = 0;
					$lo_data['errtxt'] = '';
					return $this->co_reg->document->getJson( $lo_data );
					
				// login afip
				} else if($this->WSAAgetTa( $lv_cfg )==false){
					$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'AfipCnsIns. No se pudo obtener el ticket de acceso de AFIP.');
					$lo_data['log'] = $this->fcelog;
					$lo_data['errtyp'] = 'E';
					$lo_data['errcod'] = -1;
					$lo_data['errtxt'] = 'No se pudo obtener el ticket de acceso de AFIP.';
				
				} else if($lv_frmchk=='') {
					
					// DATOS. preparo datos para autorizar
					$lv_dat = new stdClass();
					$lv_dat->token	= $this->token;
					$lv_dat->sign 	= $this->sign;
					$lv_dat->cuitRepresentada = $lo_busmdl->tax->taxcod;
					$lv_dat->idPersona = $lo_post['idPersona'];
	
					// EJECUCION. llamada a WS AFIP
					$lo_dat_arr = json_decode(json_encode($lv_dat),true);
					$lv_ret = $this->callWS( $lv_mthnme , $lo_dat_arr );
					if( $lv_ret==false ){
						$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'AfipCnsIns. Se produjo un error al ejecutar la interfaz.');
						$lo_data['errtyp'] = 'E';
						$lo_data['errcod'] = -1;
						$lo_data['errtxt'] = $this->errtxt;
					} else {
						// RESPUESTA. procesar respuesta
						try{
							$lo_data = (array)$lv_ret;
							$lo_data['errtyp'] = 'S';
							$lo_data['errcod'] = 0;
						} catch(Exception $e) {
							$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'AfipCnsIns. Se produjo un error al obtener el resultado de la interfaz: '.$e->getMessage().'.');
							$lo_data['errtyp'] = 'E';
							$lo_data['errcod'] = -1;
							$lo_data['errtxt'] = 'Se produjo un error al obtener el resultado de la interfaz: '.$e->getMessage().'.';
						}
					}
					// devuelvo log
					$lo_data['log'] = $this->fcelog;
					
					// cargo definición del objeto
					$lo_objmdl = $this->co_reg->load->model('sysobjtyp');
					$lo_objmdl->load( array('objtypcod'=>$lo_post['objtypcod']) );
					$lo_data['objtypkeytxt'] = $lo_objmdl->objtypkeytxt;
					
					// devuelvo conversiones de interfaz
					$lo_data['sysintcnv'] = $this->sysint->sysintcnv;
				}
				
        return $this->co_reg->document->getJson( $lo_data );
				break;
			
		}
  }
	
	
	
	// --------------------------------------------------------------------------
	//
	// procSlsInvFce
	// procesa las facturas electrónicas para obtener el CAE y devuelve array con log de errores
	//
	// --------------------------------------------------------------------------
	public function procSlsInvFce( $lp_dat=array() ){
		
		$lo_invmdl = $this->co_reg->load->model('slsinv');
		$lo_busmdl = $this->co_reg->load->model('admbus');
		$lo_cusmdl = $this->co_reg->load->model('slscus');
		$lo_ltrmdl = $this->co_reg->load->model('finlocargltr');
		$lo_posmdl = $this->co_reg->load->model('finlocargpos');
		$lo_rngmdl = $this->co_reg->load->model('grldatdocrng');
		$lo_fcemdl = $this->co_reg->load->model('slsinvfce');
		$lo_cntmdl = $this->co_reg->load->model('grldatcnt');
		$lv_count = 0;
		$this->errtyp = '';
		$this->errcod = 0;
		$this->errtxt	= '';
		
		// EMPRESA. cargo datos de empresa
		if($lo_busmdl->load(array('buscod' => $this->co_reg->sec->buscod ))==false){
			$this->errtyp = 'E';
			$this->errcod = -1;
			$this->errtxt = 'procSlsInvFce. No se pudo obtener info de la empresa actual. '.$lo_busmdl->errtxt;
			return false;
 		} 
		
		// ******************************************************************************
		// DEBERIA OBTENER NUEVAMENTE LAS FACTURAS SELECCIONADAS
		// ORDENADAS POR TIPO/PUNTO/LETRA y FECHA ASCENDENTE
		// ******************************************************************************
		
		// PROCESO. procesa cada factura
		foreach($lp_dat as $lv_slsinvcod){
			$this->fcelog = array();
			
			// FACTURA. cargo datos de factura
			if($lo_invmdl->load(array('slsinvcod'=>$lv_slsinvcod), false)==false){
				$this->fcelog[] = array('errtyp'=>$lo_invmdl->errtyp,'errcod'=>$lo_invmdl->errcod,'errtxt'=>'procSlsInvFce. Se produjo un error al cargar los datos de la factura.'.$lo_invmdl->errtxt);
				$this->procSlsInvFceSveLog($lv_slsinvcod);
				continue;
			} else {
				$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce. Datos de factura ['.$lv_slsinvcod.'] cargados.');
			}
			
			// CLIENTE. cargo datos de cliente
			if($lo_invmdl->dstobjtyp!='SLS_CUS'){
				$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'procSlsInvFce. Tipo de objeto ['.$lo_invmdl->dstobjtyp.'] en factura no activado en interfaz.');
				$this->procSlsInvFceSveLog($lv_slsinvcod);
				continue;
			} else if($lo_cusmdl->load(array('cuscod'=>$lo_invmdl->dstobjcod), false) == false){
				$this->fcelog[] = array('errtyp'=>$lo_cusmdl->errtyp,'errcod'=>$lo_cusmdl->errcod,'errtxt'=>'procSlsInvFce. Error al cargar datos de cliente ['.$lo_invmdl->dstobjcod.'].'.$lo_cusmdl->errtxt);
				$this->procSlsInvFceSveLog($lv_slsinvcod);
				continue;
			} else {
				$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce. Datos de cliente ['.$lo_invmdl->dstobjcod.'] cargados.');
			}
			
			// DESTINATARIO DE FACTURA. determino si tiene destinatario de factura
			$lv_taxcatcod = '';
			$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce. Determinando destinatario de factura para cliente ['.$lo_invmdl->dstobjcod.'].');
			$lv_prm = array('vewmaxrec' =>'1',
										'vewfldflt' =>'[~fltrow~]c.CntSrcTyp'.chr(9).'='.chr(9).chr(9).$lo_invmdl->dstobjtyp .chr(9).chr(9).
																	'[~fltrow~]c.cntsrccod'.chr(9).'='.chr(9).chr(9).$lo_invmdl->dstobjcod .chr(9).chr(9).
																	'[~fltrow~]dbo.GetTagValue(^INVADR^,ct.sysdocclsatr)'.chr(9).'='.chr(9).chr(9).'X'.chr(9).chr(9).
																	'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																	'[~fltrow~]ct.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
									);
			$lo_rs = $lo_cntmdl->getList( $lv_prm,null,null,false );
			if(count($lo_rs)>0){
				$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce. Destinatario de factura determinado Contacto ['.$lo_rs[0]['cntcod'].'].');
				if($lo_rs[0]['cntdsttyp']=='SLS_CUS') {
					$lo_cusmdl->load( array('cuscod'=>$lo_rs[0]['cntdstcod']), false );
					$lo_dstfac = $lo_cusmdl;
					$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce. Contacto con referencia a Cliente ['.$lo_rs[0]['cntdstcod'].'] cargado.');
				} else {
					$lo_cntmdl->load( array('cntcod'=>$lo_rs[0]['cntcod']),false );
					$lo_dstfac = $lo_cntmdl;
					$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce. Contacto cargado ['.$lo_rs[0]['cntcod'].'].');
				}
			} else {
				$lo_dstfac = $lo_cusmdl;
				$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce. Destinatario de Factura Cliente ['.$lo_invmdl->dstobjcod.'].');
			}
			
			// LETRA. redetermino letra de documento
			$lv_prm = array('vewmaxrec' =>'1',
										'vewfldflt' =>'[~fltrow~]ts.taxcatcod'.chr(9).'='.chr(9).chr(9).$lo_busmdl->tax->taxcatcod .chr(9).chr(9).
																	'[~fltrow~]td.taxcatcod'.chr(9).'='.chr(9).chr(9).$lo_dstfac->tax->taxcatcod .chr(9).chr(9).
																	'[~fltrow~]l.argltroprtyp'.chr(9).'='.chr(9).chr(9).'L'.chr(9).chr(9).
																	'[~fltrow~]l.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
									);
			$lo_rs = $lo_ltrmdl->getListSingle( $lv_prm );
			if(count($lo_rs)>0){
				$lo_invmdl->slsinvcodext = ($lo_rs[0]['argltrcodext']??'');
				$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce. Letra determinada ['.$lo_busmdl->tax->taxcatcod.'/'.$lo_dstfac->tax->taxcatcod.'/L/A => '.$lo_invmdl->slsinvcodext.'].');
			} else {
				$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'procSlsInvFce. No se pudo determinar letra para combinacion ['.$lo_busmdl->tax->taxcatcod.'/'.$lo_dstfac->tax->taxcatcod.'/L/A].');
				$this->procSlsInvFceSveLog($lv_slsinvcod);
				continue;
			}
			
			// PUNTO DE VENTA. obtengo datos de config de punto de venta
			$lv_prm = array('vewmaxrec' =>'1',
											'vewfldflt' =>'[~fltrow~]p.slsposcod'.chr(9).'='.chr(9).chr(9).$lo_invmdl->slsposcod .chr(9).chr(9).
																		'[~fltrow~]p.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_invmdl->sysdocclscod .chr(9).chr(9).
																		'[~fltrow~]p.argltrcodext'.chr(9).'='.chr(9).chr(9).$lo_invmdl->slsinvcodext .chr(9).chr(9).
																		'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
											);
			$lo_pos_rs = $lo_posmdl->getList( $lv_prm, null, null, false );
			if(count($lo_pos_rs)>0){
				$lo_posmdl->argposcodext = $lo_pos_rs[0]['argposcodext']; //tipo de comprobante
				$lo_posmdl->slsposcodext = $lo_pos_rs[0]['slsposcodext']; //punto de venta externo
				$lo_posmdl->argltrcodext = $lo_pos_rs[0]['slsposcod']; // letra
				$lo_invmdl->docrngcod = $lo_pos_rs[0]['docrngcod'];
				$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce. Tipo de comprobante AFIP ['.$lo_posmdl->argposcodext.'] determinado.');
				$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce. Rango de numeracion ['.$lo_invmdl->docrngcod.'] para localizacion ['.$lo_pos_rs[0]['argposcod'].'] recuperado.');
			} else {
				$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'procSlsInvFce. No se pudo determinar localizacion para Punto de Venta para combinacion ['.$lo_invmdl->slsposcod.'/'.$lo_invmdl->sysdocclscod.'/'.$lo_invmdl->slsinvcodext.'/A].');
				$this->procSlsInvFceSveLog($lv_slsinvcod);
				continue;
			}
			
			// ESTADO. verifico si la factura puede ser procesada (tpo doc afip/pto vta/letra)
			// si existe una FC con estado E (en proceso) -> no se continúa con ese tipo/pto vta
			// si existe una FC con estado R (rechazada) -> no se continua con ese tipo/pto vta
			$lv_prm = array('vewmaxrec' =>'1',
											'vewfldflt' =>'[~fltrow~]dbo.getTagValue(^argposcodext^, fe.slsinvfceatr)'.chr(9).'='.chr(9).chr(9).$lo_posmdl->argposcodext .chr(9).chr(9).
																		'[~fltrow~]dbo.getTagValue(^slsposcodext^, fe.slsinvfceatr)'.chr(9).'='.chr(9).chr(9).$lo_posmdl->slsposcodext .chr(9).chr(9).
																		'[~fltrow~]dbo.getTagValue(^argltrcodext^, fe.slsinvfceatr)'.chr(9).'='.chr(9).chr(9).$lo_posmdl->argltrcodext .chr(9).chr(9).
																		'[~fltrow~]fe.slsinvcod'.chr(9).'<>'.chr(9).chr(9).$lv_slsinvcod.chr(9).chr(9).
																		'[~fltrow~]fe.docsts'.chr(9).'IN'.chr(9).chr(9).'E'.chr(10).'R'.chr(9).chr(9)
											);
			$lo_rs = $lo_fcemdl->getList( $lv_prm );
			if(count($lo_rs)>0){
				$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'procSlsInvFce. No se puede procesar. La factura ['.$lo_rs[0]['slsinvcod'].'] esta '.($lo_rs[0]['docsts']=='E'?' en proceso ':' rechazada ').'.');
				$this->procSlsInvFceSveLog($lv_slsinvcod);
				continue;
			} else {
				$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce. No existen facturas pendientes de proceso');
				$lo_fcemdl->load( array('slsinvcod'=>$lv_slsinvcod) );
			}
			
			// NUMERO. obtengo proximo numero oficial de factura a emitir
			if($lo_rngmdl->load(array('docrngcod'=>$lo_invmdl->docrngcod))==false){
				$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'procSlsInvFce. No se pudo obtener el rango de numeracion ['.$lo_invmdl->docrngcod.'].');
				$this->procSlsInvFceSveLog($lv_slsinvcod);
				continue;
			} else if($lo_rngmdl->docrngcurnum >= $lo_rngmdl->docrngendnum){
				$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'procSlsInvFce. Rango de numeracion ['.$lo_invmdl->docrngcod.'] agotado.');
				$this->procSlsInvFceSveLog($lv_slsinvcod);
				continue;
			} else {
				$lv_docnum = $lo_rngmdl->docrngcurnum+1;
				$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce. Proximo numero a emitir ['.$lv_docnum.'].');
			}
			
			// PROCESAR. determino que RG se implementa para esta factura
			if( $lo_pos_rs[0]['argposregcod']=='4291' ) {
				$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce. Se procesa factura en RG4291.');
				$lv_proc = $this->procSlsInvFce_RG4291( array('inv'=>$lo_invmdl, 'bus'=>$lo_busmdl, 'cus'=>$lo_dstfac, 'rng'=>$lo_rngmdl, 'fce'=>$lo_fcemdl, 'docnum'=>$lv_docnum,	'posrs'=>$lo_pos_rs, 'pos'=>$lo_posmdl ));
				if($lv_proc){ $lv_count++; }
			} else { // 2905 o 2758
				$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'RG no implementada ['.$lo_pos_rs[0]['argposregcod'].'].');
			}
			
			// LOG. grabo log final de documento
			$this->procSlsInvFceSveLog($lv_slsinvcod);
		}
		
		if($lv_count==count($lp_dat)){
			$this->errtyp = 'S';
			$this->errcod = 0;
			$this->errtxt = 'Todas las facturas fueron procesadas correctamente';
			return true;
		} else {
			$this->errtyp = 'E';
			$this->errcod = -1;
			$this->errtxt = 'Al menos una factura no pudo ser procesada. Revise el log de errores.';
			return false;
		}
		
	}
	
	
	
	// --------------------------------------------------------------------------
	//
	// FACTURA ELECTRONICA - RG 4291
	// prepara y procesa en AFIP facturas electronicas de RG4291
	// INTERFAZ (cod.ext): AFIP_WSFE_4291
	//
	// --------------------------------------------------------------------------
	private function procSlsInvFce_RG4291( $lp_dat ){
		
		//$lo_itzcnvmdl = $this->co_reg->load->model('sysintcnv');
		$lo_paytrmmdl = $this->co_reg->load->model('finpaytrm');
		$lo_paytrmctr = $this->co_reg->load->controller('finpaytrm');		
		$lv_itznme = 'AFIP_WSFE_4291';
		$lv_ltr = $lp_dat['inv']->slsinvcodext;

		// INTERFAZ. cargo el id interno de interfaz
		if($this->loadUrlWSN( $lv_itznme )==false) {
			$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'procSlsInvFce_RG4291. Error al obtener definicion de interfaz ['.$lv_itznme.'].');
			return false;
		} else {
			$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce_RG4291. Definicion de interfaz obtenida correctamente ['.$lv_itznme.'].');
		}
		
		
		// MONEDA. obtengo conversion de moneda para interfaz
		$lv_MonId = '';
		foreach($this->sysint->sysintcnv as $lv_row){
			if(trim(strtolower($lv_row['sysintcnvkey']))=='curcod' && trim(strtolower($lv_row['sysintcnvinb001']))==trim(strtolower($lp_dat['inv']->curcod)) && trim(strtolower($lv_row['docsts']))=='a'){
				$lv_MonId = $lv_row['sysintcnvout001'];
				break;
			}
		}
		if($lv_MonId!=''){
			$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce_RG4291. Conversion de moneda ['.$lp_dat['inv']->curcod.'] para interfaz ['.$this->sysint->sysintcod.'] encontrada ['.$lv_MonId.'].');
		} else {
			$this->fcelog[] = array('errtyp'=>'W','errcod'=>0,'errtxt'=>'procSlsInvFce_RG4291. No se encontro conversion de moneda ['.$lp_dat['inv']->curcod.'] para interfaz ['.$this->sysint->sysintcod.'].');
		}
		
		
		// VENCIMIENTO. determino fecha de vencimiento
		$lv_FchVtoPago = '';
		if( $lo_paytrmmdl->load( array('paytrmcod'=>$lp_dat['inv']->paytrmcod), false )==false ){
			$this->fcelog[] = array('errtyp'=>'E','errcod'=>$lo_paytrmmdl->errcod,'errtxt'=>'procSlsInvFce_RG4291. Error al obtener condición de pago ['.$lp_dat['inv']->paytrmcod.']. '.$lo_paytrmmdl->errtxt);
			return false;
		} else {
			// fecha de vencimiento manual - se obtiene de la factura
			if( $lo_paytrmmdl->paytrmman=='1' ){
				$lv_FchVtoPago = $lp_dat['inv']->slsinvduedte->format('Ymd');
				$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce_RG4291. Condicion de pago manual. Se utiliza la del documento ['.$lp_dat['inv']->slsinvduedte.'].');
			// fecha de vencimiento automatica - se determina	
			} else {
				$lo_keep = $this->co_reg->request->post;
				$this->co_reg->request->post =array('paytrmcod'=>$lp_dat['inv']->paytrmcod,
																						'docdte'=>$lp_dat['inv']->slsinvdte->format('d/m/Y'), 
																						'ctedte'=>$lp_dat['inv']->ctedte->format('d/m/Y'),
																						'docaccdte'=>$lp_dat['inv']->slsinvaccdte->format('d/m/Y'));
				$lv_json = $lo_paytrmctr->index( 'getDueDate' );
				$this->co_reg->request->post = $lo_keep;
				$lo_rs = json_decode($lv_json);
				if(count($lo_rs->paytrmduedte) > 0 ){
					$lv_FchVtoPago = date_create_from_format('d/m/Y',$lo_rs->paytrmduedte[0]->paytrmduedte)->format('Ymd');
					$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce_RG4291. Condicion de pago automatica. Se calculo primer fecha de vencimiento ['.$lv_FchVtoPago.'].');
				} else {
					$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'procSlsInvFce_RG4291. Condicion de pago automatica. No se pudo determinar la fecha de vencimiento para condicion ['.$lp_dat['inv']->paytrmcod.'] y con fechas [docdte='.$lp_dat['inv']->slsinvdte->format('d/m/Y').'/ctedte='.$lp_dat['inv']->ctedte->format('d/m/Y').'/docaccdte='.$lp_dat['inv']->slsinvaccdte->format('d/m/Y').'].');
					return false;
				}
			}
		}
		
		
		// CONDICIONES. determino condiciones de precios
		$lv_ImpTotConc 	= 0;
		$lo_Tributos 		= [];
		$lo_Iva			 		= [];
		foreach( $lp_dat['inv']->slsinvprc as $lo_slsinvprc){
			
			// PRECIO
			if($lo_slsinvprc['fintaxtypcat']=='' && $lo_slsinvprc['prccndcodext']=='NNG' && $lo_slsinvprc['srcobjcod002']!=''){
				$lv_ImpTotConc += $lo_slsinvprc['prccndtot'];
			
			// TRIBUTO
			} else if( ($lo_slsinvprc['fintaxtypcat']=='IIB' || $lo_slsinvprc['fintaxtypcat']=='IMU' || $lo_slsinvprc['fintaxtypcat']=='IPR') && $lo_slsinvprc['srcobjcod002']!=''){
				$lv_Id = '';
				//foreach($lo_itz_rs as $lv_itz_row){
				foreach($this->sysint->sysintcnv as $lv_itz_row){
					if( $lv_itz_row['sysintcnvkey']=='FINTAXTYPCAT' && $lv_itz_row['docsts']=='A' && trim(strtoupper($lv_itz_row['sysintcnvinb001']))==trim(strtoupper($lo_slsinvprc['fintaxtypcat'])) ) {
						$lv_Id = $lv_itz_row['sysintcnvout001'];
						break;
					}
				}
				if(!array_key_exists($lo_slsinvprc['prccndcodext'],$lo_Tributos) ){
					$lo_Tributos[$lo_slsinvprc['prccndcodext']] = new stdClass();
					$lo_Tributos[$lo_slsinvprc['prccndcodext']]->Id 			= $lv_Id;
					$lo_Tributos[$lo_slsinvprc['prccndcodext']]->Desc 		= $lo_slsinvprc['prccndtxt'];
					$lo_Tributos[$lo_slsinvprc['prccndcodext']]->BaseImp 	= 0;
					$lo_Tributos[$lo_slsinvprc['prccndcodext']]->Alic 		= 0;
					$lo_Tributos[$lo_slsinvprc['prccndcodext']]->Importe 	= 0;
				}
				$lo_Tributos[$lo_slsinvprc['prccndcodext']]->BaseImp 	+= round($lo_slsinvprc['prccndqty'],2);
				$lo_Tributos[$lo_slsinvprc['prccndcodext']]->Alic 		= round($lo_slsinvprc['prccndval'],2);
				$lo_Tributos[$lo_slsinvprc['prccndcodext']]->Importe 	+= round($lo_slsinvprc['prccndtot'],2);
			
			// IVA
			} else if($lo_slsinvprc['fintaxtypcat']=='IVA' && $lo_slsinvprc['srcobjcod002']!='' ){ //&& $lp_dat['cus']->tax->taxcatcod!='04' ){
				$lv_Id = '';
				foreach($this->sysint->sysintcnv as $lv_itz_row){
					if( $lv_itz_row['sysintcnvkey']=='FINTAXTYPCAT' && $lv_itz_row['docsts']=='A' &&
							trim(strtoupper($lv_itz_row['sysintcnvinb001']))==trim(strtoupper($lo_slsinvprc['fintaxtypcat'])) &&
							trim(strtoupper($lv_itz_row['sysintcnvinb002']))==trim(strtoupper($lo_slsinvprc['prccndqty'])) ) {
						$lv_Id = $lv_itz_row['sysintcnvout001'];
						break;
					}
				}
				if(!array_key_exists($lo_slsinvprc['prccndcodext'],$lo_Iva) ){
					$lo_Iva[$lo_slsinvprc['prccndcodext']] = new stdClass();
					$lo_Iva[$lo_slsinvprc['prccndcodext']]->Id 			= $lv_Id;
					$lo_Iva[$lo_slsinvprc['prccndcodext']]->BaseImp = 0;
					$lo_Iva[$lo_slsinvprc['prccndcodext']]->Importe = 0;
				}
				$lo_Iva[$lo_slsinvprc['prccndcodext']]->BaseImp += round($lo_slsinvprc['prccndval'],2);
				$lo_Iva[$lo_slsinvprc['prccndcodext']]->Importe += round($lo_slsinvprc['prccndtot'],2);
			}
		}
		
		$lp_dat['inv']->slsinvtotamt = ($lp_dat['inv']->slsinvtotamt==''?0:$lp_dat['inv']->slsinvtotamt);
		$lp_dat['inv']->slsinvtaxamt = ($lp_dat['inv']->slsinvtaxamt==''?0:$lp_dat['inv']->slsinvtaxamt);
		$lp_dat['inv']->slsinvvatamt = ($lp_dat['inv']->slsinvvatamt==''?0:$lp_dat['inv']->slsinvvatamt);
		// IVA EXENTO
		/*
		if( $lp_dat['cus']->tax->taxcatcod=='04' ) {
			$lp_dat['inv']->slsinvnetamt = 0;
			$lp_dat['inv']->slsinvnngamt = $lv_ImpTotConc;
			$lp_dat['inv']->slsinvextamt = $lp_dat['inv']->slsinvtotamt - $lv_ImpTotConc;
		// otros
		} else {
		*/
			$lp_dat['inv']->slsinvnetamt = $lp_dat['inv']->slsinvtotamt - $lp_dat['inv']->slsinvtaxamt - $lp_dat['inv']->slsinvvatamt - $lv_ImpTotConc;
			$lp_dat['inv']->slsinvnngamt = $lv_ImpTotConc;
			$lp_dat['inv']->slsinvextamt = 0;
		//}
		
		
		// REFERENCIA (para NOTAS DE CREDITO y NOTAS DE DEBITO se debe informar el comprobante de referencia)
		$lo_cbtesasoc = [];
		if( stripos( '02|03|07|08|12|13|52|53|202|203|207|208|212|213', $lp_dat['pos']->argposcodext)!==false ){
			$lo_posmdl = $this->co_reg->load->model('finlocargpos');
			foreach( $lp_dat['inv']->slsinvmat as $lo_slsinvmat){
				$lv_key = $lo_slsinvmat['docreftyp'].'_'.$lo_slsinvmat['docrefcod'];
				if( !isset($lo_cbtesasoc[$lv_key]) ){
					if( $lo_slsinvmat['docreftyp']=='SLS_INV' || $lo_slsinvmat['docreftyp']=='SLS_CRE' ) {
						$lo_refmdl = $this->co_reg->load->model('slsinv');
						if( $lo_refmdl->load( array('slsinvcod'=>$lo_slsinvmat['docrefcod']), false )!=false ){
							$lv_prm = array('vewmaxrec' =>'1',
															'vewfldflt' =>'[~fltrow~]p.slsposcod'.chr(9).'='.chr(9).chr(9).$lo_refmdl->slsposcod .chr(9).chr(9).
																						'[~fltrow~]p.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_refmdl->sysdocclscod .chr(9).chr(9).
																						'[~fltrow~]p.argltrcodext'.chr(9).'='.chr(9).chr(9).substr($lo_refmdl->slsinvcodext,5,1) .chr(9).chr(9).
																						'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
															);
							$lo_posrs = $lo_posmdl->getList( $lv_prm, null, null, false );
							if(count($lo_posrs)>0){
								$lo_cbtesasoc[$lv_key] = array('Tipo'=>$lo_posrs[0]['argposcodext'],'PtoVta'=>$lo_posrs[0]['slsposcodext'],'Nro'=>substr($lo_refmdl->slsinvcodext,-8) ); //'Cuit'=>,'CbteFch'=>
							}
						}
					}
				}
			}
		}
		
		// OPCIONALES (para FCE se informa CBU del emisor y/o ALIAS CBU)
		$lo_Opcionales = [];
		$lv_fceatrtag = '';
		if($lp_dat['pos']->argposcodext=='201'){
			if($lp_dat['bus']->bnk->bnkacccbu!=''){
				$lo_Opcionales[$lp_dat['bus']->buscod.'CBU'] = new stdClass();
				$lo_Opcionales[$lp_dat['bus']->buscod.'CBU']->Id		 = '2101';
				$lo_Opcionales[$lp_dat['bus']->buscod.'CBU']->Valor = $lp_dat['bus']->bnk->bnkacccbu;
				$lv_fceatrtag .= '<'.$lp_dat['bus']->buscod.'CBU>'.$lp_dat['bus']->bnk->bnkacccbu.'</'.$lp_dat['bus']->buscod.'CBU>';
			}
			if($lp_dat['bus']->bnk->bnkacccbuals!=''){
				$lo_Opcionales[$lp_dat['bus']->buscod.'CBUALS'] = new stdClass();
				$lo_Opcionales[$lp_dat['bus']->buscod.'CBUALS']->Id		 = '2102';
				$lo_Opcionales[$lp_dat['bus']->buscod.'CBUALS']->Valor = $lp_dat['bus']->bnk->bnkacccbuals;
				$lv_fceatrtag .= '<'.$lp_dat['bus']->buscod.'CBUALS>'.$lp_dat['bus']->bnk->bnkacccbuals.'</'.$lp_dat['bus']->buscod.'CBUALS>';
			}

			// -- inicio RG4540/2019
			// Debido a la implementación de las disposiciones de la Resolución General 4540/2019, 
			// a partir del 1ero de Abril de 2021 si el tipo de comprobante que está autorizando es Factura del 
			// tipo MiPyMEs (201, 206, 211), es obligatorio informar si el comprobante se transfiere a 
			// SCA (TRANSFERENCIA AL SISTEMA DE CIRCULACION ABIERTA) o ADC (AGENTE DE DEPOSITO COLECTIVO).
			$lo_Opcionales[$lp_dat['bus']->buscod.'SCAADC'] = new stdClass();
			$lo_Opcionales[$lp_dat['bus']->buscod.'SCAADC']->Id		 = '27';
			$lo_Opcionales[$lp_dat['bus']->buscod.'SCAADC']->Valor = 'SCA';
			// -- fin RG4540/2019
			
		}
		
		
		// ********************* FALTA AGREGAR CAMPOS A FACTURA ****************+
		// For now, use only Concepto=1 ************* DETERMINAR SEGUN TIPO DE MATERIAL (si gestiona stocks o no)
		$lv_concepto = 3;
		// Inform FchServDesde and FchServHasta only for Concepto=1
		if($lv_concepto!=2 && $lv_concepto!=3){
			$lv_FchServDesde = '';
			$lv_FchServHasta = '';
		} else {
			
			$lv_dte = $lp_dat['inv']->slsinvstrdte;
			if($lv_dte==''){ $lv_dte = $lp_dat['inv']->slsinvdte; }
			$lv_FchServDesde = $lv_dte->format('Ymd');
			
			$lv_dte = $lp_dat['inv']->slsinvenddte;
			if($lv_dte==''){ $lv_dte = $lp_dat['inv']->slsinvdte; }
			$lv_FchServHasta = $lv_dte->format('Ymd');
			
		}
		// ********************* FALTA AGREGAR CAMPOS A FACTURA ****************+
		
		// DATOS. preparo datos para autorizar
		$lv_fce = new stdClass();
		
		// login afip
		$lv_cfg = array('service'=>'wsfe','cuit'=>$lp_dat['bus']->tax->taxcod);
		if($this->WSAAgetTa( $lv_cfg )==false){
			$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'procSlsInvFce_RG4291. No se pudo obtener el ticket de acceso de AFIP.');
			return false;
		}
		
		$lv_fce->Auth = new stdClass();
		$lv_fce->Auth->Token	= $this->token;
		$lv_fce->Auth->Sign 	= $this->sign;
		$lv_fce->Auth->Cuit 	= $lp_dat['bus']->tax->taxcod;

		$lv_fce->FeCAEReq =  new stdClass();
		$lv_fce->FeCAEReq->FeCabReq =  new stdClass();
		$lv_fce->FeCAEReq->FeCabReq->CantReg 	= 1;
		$lv_fce->FeCAEReq->FeCabReq->PtoVta		= $lp_dat['inv']->slsposcodext;
		$lv_fce->FeCAEReq->FeCabReq->CbteTipo = $lp_dat['pos']->argposcodext;
		
		$lv_fce->FeCAEReq->FeDetReq =  new stdClass();
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest = new stdClass();
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->Concepto 	= $lv_concepto;
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->DocTipo 	= $lp_dat['cus']->tax->taxdoctyp;
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->DocNro 		= $lp_dat['cus']->tax->taxcod;
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->CbteDesde = $lp_dat['docnum'];
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->CbteHasta = $lp_dat['docnum'];
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->CbteFch 	= $lp_dat['inv']->slsinvdte->format('Ymd');
				
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->ImpTotal 	= round( $lp_dat['inv']->slsinvtotamt , 2); // Total del comprobante (incluye impuestos)
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->ImpTotConc= round( $lp_dat['inv']->slsinvnngamt , 2); // Neto no gravado (no aplica a sujetos exentos)
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->ImpNeto 	= round( $lp_dat['inv']->slsinvnetamt , 2); // Neto gravado
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->ImpOpEx 	= round( $lp_dat['inv']->slsinvextamt , 2); // Operaciones exentas
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->ImpTrib 	= round( $lp_dat['inv']->slsinvtaxamt , 2);	// Impuestos
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->ImpIVA 		= round( $lp_dat['inv']->slsinvvatamt , 2);	// IVA
		
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->FchServDesde= $lv_FchServDesde;
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->FchServHasta= $lv_FchServHasta;
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->FchVtoPago	= $lv_FchVtoPago;
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->MonId		 		= $lv_MonId;
		$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->MonCotiz 		= ($lv_MonId=='PES' ? 1 : $lp_dat['inv']->curexcrte);
		
		if(!empty( $lo_cbtesasoc )){
			$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->CbtesAsoc = new stdClass();
			foreach( $lo_cbtesasoc as $lo_cbteasoc ){
				$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->CbtesAsoc->CbteAsoc[] = $lo_cbteasoc;
			}
		}
		if(!empty( $lo_Tributos )){
			$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->Tributos	= new stdClass();
			foreach($lo_Tributos as $lo_Tributo){
				$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->Tributos->Tributo->Tributos[] = $lo_Tributo;
			}
		}
		if(!empty( $lo_Iva )){
			$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->Iva	= new stdClass();
			foreach($lo_Iva as $lo_AlicIva){
				$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->Iva->AlicIva[] = $lo_AlicIva;
			}
		}
		if(!empty( $lo_Opcionales )){
			$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->Opcionales	= new stdClass();
			foreach($lo_Opcionales as $lo_Opcional){
				$lv_fce->FeCAEReq->FeDetReq->FECAEDetRequest->Opcionales->Opcional[] = $lo_Opcional;
			}
		}
		
		// LOG. graba log de solicitud (cod002=1)
		$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce_RG4291. Se procesa solicitud de autorizacion. ', 'errtxt002'=>json_decode(json_encode($lv_fce)) );
		//$this->procSlsInvFceSveLog( $lp_dat['inv']->slsinvcod );		
		
		// EJECUCION. llamada a WS AFIP
		$lo_dat_arr = json_decode(json_encode($lv_fce),true);
		$lv_ret = $this->callWS( 'FECAESolicitar' , $lo_dat_arr );
		
		// LOG. graba log de respuesta (cod002=2)
		$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce_RG4291. Se recibe respuesta AFIP.','errtxt002'=>json_decode(json_encode($lv_ret)) );
		//$this->procSlsInvFceSveLog( $lp_dat['inv']->slsinvcod );		
		
		// RESPUESTA. procesar respuesta
		try{
			if( isset($lv_ret->FECAESolicitarResult->FeDetResp) ){
				$lo_res = 			$lv_ret->FECAESolicitarResult->FeDetResp->FECAEDetResponse;
				$lv_cae = 			$lo_res->CAE;
				
				$lv_cae_vto = 	'';
				$lv_cae_vto_tmp = datetime::createfromformat('Ymd',$lo_res->CAEFchVto);
				if( $lv_cae_vto_tmp instanceOf DateTime ){
					$lv_cae_vto = $lv_cae_vto_tmp->format('d/m/Y');
				}
				
				$this->errtyp = $lo_res->Resultado;
				if(isset($lo_res->Observaciones)){
					$this->errcod = -1;
					$lo_obs = $lo_res->Observaciones->Obs;
          $lo_obs = is_array($lo_obs) ? $lo_obs : [$lo_obs];
					foreach($lo_obs as $lv_obs){
						$this->errtxt .= ($this->errtxt!=''?'<br>':'').$lv_obs->Code.': '.utf8_decode(str_ireplace('°',' ',$lv_obs->Msg));
					}
				}
			} else { 
				$this->errtyp = 'R';
			}
			if(isset($lv_ret->FECAESolicitarResult->Errors)){
				$this->errcod = -1;
				$lo_err = (array)$lv_ret->FECAESolicitarResult->Errors;
				foreach($lo_err as $lv_err){
					$this->errtxt .= ($this->errtxt!=''?'<br>':'').$lv_err->Code.': '.utf8_decode(str_ireplace('°',' ',$lv_err->Msg));
				}
			}
			
			if($this->errtyp=='A' || $this->errtyp=='O'){
				$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce_RG4291. Se procesa respuesta de AFIP. CAE:'.$lv_cae.' / Vto.'.$lv_cae_vto);
			} else {
				$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'procSlsInvFce_RG4291. Se procesa respuesta de AFIP. <br>'.$this->errtxt);
			}
		} catch(Exception $e) {
			$this->errtyp = 'E';
			$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'procSlsInvFce_RG4291. Se produjo un error al obtener el resultado de la autorización: '.$e->getMessage());
		}
		
		// FACTURA ELECTRONICA. graba datos de respuesta
		$lv_docnum = ( $this->errtyp=='A' || $this->errtyp=='O' ? sprintf('%05d',$lp_dat['inv']->slsposcodext) . $lv_ltr . sprintf('%08d', $lp_dat['docnum']) : '' );
		$lv_dat = array('slsinvcod'=>$lp_dat['inv']->slsinvcod, 
										'slsinvfcecodext'=>$lv_docnum,
										'slsinvfceautcodext'=>$lv_cae,
										'slsinvfceautduedte'=>$lv_cae_vto,
										'docrngcod'=>$lp_dat['rng']->docrngcod,
										'slsinvfceatr'=>$lp_dat['fce']->slsinvfceatr . $lv_fceatrtag,
										'docsts'=>$this->errtyp);			
		if( $lp_dat['fce']->confirm( $lv_dat )==false ){
			$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'procSlsInvFce_RG4291. No se pudo grabar la respuesta en el documento de Factura Electronica. '.$lp_dat['fce']->errcod.': '.$lp_dat['fce']->errtxt);
		} else {
			$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'procSlsInvFce_RG4291. Registro de factura electronica actualizado.');
		}

		if($this->errtyp!='A' && $this->errtyp!='O'){ 
			return false; 
		} else {
			return true;
		}
		
	}
	
	
	// --------------------------------------------------------------------------
	//
	//	procSlsInvFce
	//  graba el log de proceso de una factura electrónica
	//    int. id de factura
	//		int. tipo de log (0-log, 1-request, 2-response)
	//
	// --------------------------------------------------------------------------
	private function procSlsInvFceSveLog( $lp_slsinvcod ) {
		$lo_logmdl = $this->co_reg->load->model('sysapplog');
		//$lv_log = json_encode($this->fcelog,true);
		$lv_log = $this->co_reg->document->getJson( $this->fcelog );
		$lv_dat = array('srcobjtyp'=>'SLS_FCE','srcobjcod001'=>$lp_slsinvcod,'applogtxt'=>$lv_log,'docsts'=>'A');
		$lo_logmdl->save( $lv_dat );
		$this->fcelog = array();
	}
	
	
	
	// --------------------------------------------------------------------------
	//  WSAAgetTa
	//  obtiene y/o genera el ticket de acceso para servicios de AFIP
	// --------------------------------------------------------------------------
	public function WSAAgetTa($lp_arr){
		
		$lo_mdl = $this->co_reg->load->model('finlocargcrt');
		$lv_srv = (isset($lp_arr['service'])?$lp_arr['service']:'');
		$lv_cuit = (isset($lp_arr['cuit'])?$lp_arr['cuit']:'');
		if($lv_srv==''){
			$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'WSAAgetTa. No se pudo obtener el nombre del servicio.');
			return false; 
		}
		
		$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'WSAAgetTa. Obteniendo ticket de acceso.');
		
		// obtengo el ticket actual
		$lv_ret = $lo_mdl->getAuthTicket( $lv_srv );
		if($lv_ret === false){			

			$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'WSAAgetTa. Ticket de acceso no creado o caducado. Creando nuevo ticket.');
			
			// cargo url servicio y wsdl de login AFIP WSAA
			if($this->loadUrlWSAA()==false){
				$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'WSAAgetTa. Error al cargar URL de servicio WSAA.');
				return false;
			}
			
			// creo ticket de solicitud de acceso
			$lp_dat = array('service'=>$lv_srv, 'cuit'=>$lv_cuit, 'cn'=>$this->wsaa_crt_cn, 'env'=>$this->wsaa_url_env);
			$lv_ret = $lo_mdl->createAuthTicket( $lp_dat );
			if($lv_ret==false) {
				$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'WSAAgetTa. Error creacion de archivo REQ TA. '.$lo_mdl->errtxt);
				return false;
			}
			
			// ticket invalido, firmo nuevo ticket
			$lv_tkt = $lo_mdl->signAuthTicket($lv_srv);
			if($lv_tkt==false) {
				$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'WSAAgetTa. Error firmando TA. '.$lo_mdl->errtxt);
				return false;
			}
			
			// solicito nuevo ticket a AFIP
			$lv_tkt_afp = $lo_mdl->callWSAA( $lv_srv, $this->wsaa_url_srv, $this->wsaa_url_wsdl, $lv_tkt );
			if($lv_tkt_afp==false) {
				$this->fcelog[] = array('errtyp'=>'E','errcod'=>$lo_mdl->errcod,'errtxt'=>'WSAAgetTa. Error solicitando ticket a AFIP. '.$lo_mdl->errtxt);
				return false;
			} else {
				$this->token = $lo_mdl->token;
				$this->sign = $lo_mdl->sign;
				$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'WSAAgetTa. Token proporcionado por AFIP.');
			}
		
		// ticket existente y valido
		} else {
			$this->token = $lo_mdl->token;
			$this->sign = $lo_mdl->sign;
			$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'WSAAgetTa. Token existente. Se reutiliza.');
		}
		
		return true;
	}
	
	
	
	
	
	// --------------------------------------------------------------------------
	//
	//
	//  P R I V A T E    F U N C T I O N S
	//
	//
	// --------------------------------------------------------------------------
	
	
	
	
	// --------------------------------------------------------------------------
	//  loadUrlWSAA
	// carga las URL del servicio y del WSDL del servicio de login WSAA de AFIP
	// --------------------------------------------------------------------------
	private function loadUrlWSAA(){
		$lo_intmdl = $this->co_reg->load->model('sysint');
		$lv_prm = array('vewfldflt'=>'[~fltrow~]sysintcodext'.chr(9).'='.chr(9).chr(9).'AFIP_WSAA'.chr(9).chr(9));
		$lo_rs = $lo_intmdl->getList( $lv_prm );
		if( count($lo_rs)==0 ) {
			$this->errtyp = 'E';
			$this->errcod = -1;
			$this->errtxt = 'loadUrlWSAA. No se pudo obtener la definicion de la interfaz [AFIP_WSAA].';
			return false;
		}
		$this->wsaa_url_wsdl = $this->co_reg->document->getTagValue( $lo_rs[0]['sysintatr'], 'url_wsdl');
		$this->wsaa_url_srv = $this->co_reg->document->getTagValue( $lo_rs[0]['sysintatr'], 'url_srv');
		$this->wsaa_url_env = $this->co_reg->document->getTagValue( $lo_rs[0]['sysintatr'], 'url_env');
		$this->wsaa_crt_cn = $this->co_reg->document->getTagValue( $lo_rs[0]['sysintatr'], 'crt_cn');
		if(trim($this->wsaa_url_wsdl)=='' || trim($this->wsaa_url_srv)=='') {
			$this->errtyp = 'E';
			$this->errcod = -1;
			$this->errtxt = 'loadUrlWSAA. La definicion de la interfaz [AFIP_WSAA] debe contener URL_SRV y URL_WSDL.';
		} else {
			return true;
		}
	}
	
	
	
	// --------------------------------------------------------------------------
	//  loadUrlWSN
	// carga las URL del servicio y del WSDL del servicio a invocar
	// --------------------------------------------------------------------------
	public function loadUrlWSN($lp_itz_name){
		$this->sysint = $this->co_reg->load->model('sysint');
		$lv_prm = array('vewfldflt'=>'[~fltrow~]sysintcodext'.chr(9).'='.chr(9).chr(9).$lp_itz_name.chr(9).chr(9));
		$lo_rs = $this->sysint->getList( $lv_prm );
		if( count($lo_rs)==0 ) {
			$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'loadUrlWSN. No se pudo obtener la definicion de la interfaz ['.$lp_itz_name.'].');
			return false;
		} else {
			$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'loadUrlWSN. Definicion de interfaz ['.$lp_itz_name.'] encontrada.');
		}
		
		$this->sysint->load( array('sysintcod'=>$lo_rs[0]['sysintcod']) );
		$this->url_wsdl = $this->co_reg->document->getTagValue( $this->sysint->sysintatr, 'url_wsdl');
		$this->url_srv = $this->co_reg->document->getTagValue( $this->sysint->sysintatr, 'url_srv');
		$this->soap_ver = $this->co_reg->document->getTagValue( $this->sysint->sysintatr, 'soap_ver');
		if( trim($this->url_wsdl)=='' || trim($this->url_srv)=='' ) {
			$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'loadUrlWSN. La definicion de la interfaz ['.$lp_itz_name.'] debe contener URL_SRV, URL_WSDL.');
			return false;
		} else {
			$this->fcelog[] = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'loadUrlWSN. Definicion de interfaz ['.$lp_itz_name.'] completa URL_SRV - URL_WSDL.');
			return true;
		}
	}
	
	
	
	// --------------------------------------------------------------------------
	//  callWS
	//  realiza una llamada SOAP a servicios de AFIP
	// --------------------------------------------------------------------------
	public function callWS($lp_srvmth, $lp_dat){
		
		$this->srv_data = json_decode(json_encode($lp_dat), true);
		
		switch($this->soap_ver){
			case '1.1': $lv_soap_ver = SOAP_1_1; break;
			default: $lv_soap_ver = SOAP_1_2; break;
		}
		
		// Create soap client
		try {
			$this->client = new SoapClient($this->url_wsdl, 
																			array('soap_version' => $lv_soap_ver,
            															  'location'     => $this->url_srv,
          															    'exceptions'   => 1,
																						'trace'        => 1
																		)); 
		} catch(Exception $e) {
			$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'callWS. No se pudo acceder al servicio: '.$e->getMessage() );
			$this->errtyp = 'E';
			$this->errcod = -1;
			$this->errtxt = 'callWS. No se pudo acceder al servicio: '.$e->getMessage();
			return false;
    } 
		
		// Call WSN
		try {
			$lv_results = $this->client->$lp_srvmth($this->srv_data);
		}	catch(Exception $e) {
			$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'callWS. Se produjo un error al invocar el metodo ['.$lp_srvmth.']: '.$e->getMessage() );
			$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'callWS. lastResponse: <br>'.$this->client->__getLastResponse() );
			$this->errtyp = 'E';
			$this->errcod = -2;
			$this->errtxt = 'callWS. Se produjo un error al invocar el metodo ['.$lp_srvmth.']: '.$e->getMessage();
			return false;
		}
		
		// Check soap error
		if (is_soap_fault($lv_results)) {
			$this->fcelog[] = array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'callWS. Se produjo un error el la respuesta de la llamada al metodo ['.$lp_method.']: '.$lv_results->faultcode.': '.$lv_results->faultstring );
			$this->errtyp = 'E';
			$this->errcod = -3;
			$this->errtxt = 'callWS. Se produjo un error el la respuesta de la llamada al metodo ['.$lp_method.']: '.$lv_results->faultcode.': '.$lv_results->faultstring;
			return false;
    }
		
		return $lv_results; //$this->client->__getLastResponse();
	}
	
}
?>
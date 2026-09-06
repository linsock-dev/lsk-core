<?php
final class gasplnController extends tmssController {
	const CONTROLLER = 'gaspln';
	const MODEL = 'slsord';
	const VIEW  = 'gaspln';
	const ID = 'gasplncod';
	const OBJTYP = 'GAS_PLN';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
      
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
    
  
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

			// LIST
      case '#': case '#08':
				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).self::OBJTYP.chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						$lv_prm = array('lang'  => $this->co_reg->language,
														'input' => $this->co_reg->input,
														'sec' 	=> $this->co_reg->sec,
														'url'=>'index.php?prg='.self::CONTROLLER.'&act=01',
														'doccls'=>$lv_docclsarr
														);
						$lv_ret = $this->co_reg->load->view( 'sysdocclslst', $lv_prm );		
						return $lv_ret;
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */

				// SALONES. obtengo lista de salones activos
				$lo_slnmdl = $this->co_reg->load->model('gassln');
				$lv_prm = array('vewmaxrec' =>'100',
												'vewfldflt' =>'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' =>'(case s.slntyp when ^S^ then 1 when ^K^ then 2 else 3 end), s.slntxt'
												);
				$lo_rs = $lo_slnmdl->getList( $lv_prm );
				$this->lo_mdl->sln = $lo_rs;
				
				// CLASIFICACION. obtengo clasificaciones de materiales
				$lo_matclsmdl = $this->co_reg->load->model('stkmatcls');
				$lv_prm = array('vewmaxrec' =>'100',
												'vewfldflt' =>'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' =>'dbo.getTagValue(c.matclsatr,^c.matclsord^)'
												);
				$lo_rs = $lo_matclsmdl->getList( $lv_prm );
				$this->lo_mdl->stkmatcls = $lo_rs;
			
				return $this->co_reg->document->getview( self::VIEW, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']));
        break;
			
			
			
			// GET TABLES. devuelve las mesas de un salon
			case '#getTables':
				$lo_post = $this->co_reg->request->post;
				$lo_tblmdl = $this->co_reg->load->model('gasslntbl');				
				$lv_prm = array('vewmaxrec' =>'100',
												'vewfldflt' =>'[~fltrow~]t.slncod'.chr(9).'='.chr(9).chr(9).$lo_post['slncod'].chr(9).chr(9).
																			'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' =>'t.slntblcodext'
												);
				$lo_rs = $lo_tblmdl->getList( $lv_prm );
				return $this->co_reg->document->getjson( $lo_rs );
				break;
			
			
			
			// GET SALES ORDERS. obtengo lista de mesas y pedidos abiertos
			case '#getSalesOrders':
				$lo_post = $this->co_reg->request->post;
				
				$lv_slncod = (isset($lo_post['slncod'])?$lo_post['slncod']:'0');
				$lv_strdte = new DateTime();
				$lv_strdte->modify('-1 day');
				$lv_enddte = new DateTime();
				
				// obtengo lista de pedidos abiertos
				$lo_slsordmdl = $this->co_reg->load->model('slsord');
				$lv_prm = array('vewmaxrec' =>'100',
												'vewfldflt' =>'[~fltrow~]o.slsordcodext'.chr(9).''.chr(9).$lv_slncod.'_'.chr(9).chr(9).chr(9).
																			'[~fltrow~]o.docsts'.chr(9).'<>'.chr(9).chr(9).'R'.chr(9).chr(9).
																			'[~fltrow~]o.slsorddte'.chr(9).'BT'.chr(9).chr(9).date_format($lv_strdte,'Y-m-d').chr(9).date_format($lv_enddte,'Y-m-d').chr(9),
												'vewfldord' =>'o.slsordcodext'
												);
				$lo_rs = $lo_slsordmdl->getList( $lv_prm, null, null, false );
				
				// devuelvo datos
				return $this->co_reg->document->getjson( $lo_rs );
				break;
			
			
			
			// SHOW TABLE. devuelve el detalle de una mesa
			case '#showTable':
				$lo_post = $this->co_reg->request->post;
				
				$lo_ordmdl = $this->co_reg->load->model('slsord');
				$lo_data = array();
				$lv_slsordcod = (isset($lo_post['slsordcod'])?$lo_post['slsordcod']:0);
				if( $lv_slsordcod==0 ){
					
					// obtengo clase de documento actual (GAS_PLN)
					$lo_doccls = $this->co_reg->load->model('sysdoccls');
					$lo_doccls->load( array('sysdocclscod'=>$lo_post['sysdocclscod']) );					
					$lv_slsord_sysdocclscod = $this->co_reg->document->getTagValue($lo_doccls->sysdocclsatr, 'sysdocclscod');
				
					// obtengo pedido abierto para mesa
					$lv_prm = array('vewmaxrec' =>'1',
													'vewfldflt' =>'[~fltrow~]o.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lv_slsord_sysdocclscod.chr(9).chr(9).
																				'[~fltrow~]o.slsordcodext'.chr(9).'='.chr(9).chr(9).$lo_post['slncod'].'_'.$lo_post['slntblcod'].chr(9).chr(9).
																				'[~fltrow~]o.docsts'.chr(9).'<>'.chr(9).chr(9).'R'.chr(9).chr(9),
													'vewfldord' =>'o.ctedte desc'
													);
					$lo_rs = $lo_ordmdl->getList( $lv_prm, null, null, false );
          
					// si no hay pedido abierto, se debe abrir la mesa
					if(count($lo_rs)==0){
						$lo_data = array('slsordcod'=>0);
						$lv_slsordcod = 0;
					// si hay pedido abierto, muestro el detalle
					} else {
						$lv_slsordcod = $lo_rs[0]['slsordcod'];
					}
				}
					
				// obtengo detalle de pedido
				if( $lv_slsordcod!=0 ) {
					$lo_ordmdl->load( array('slsordcod'=>$lv_slsordcod), false );
					$lo_data = $lo_ordmdl->getData();
					// obtengo motivos de rechazo habilitados para el pedido
					$lo_orddoccls = $this->co_reg->load->model('sysdoccls');
					$lo_orddoccls->load( array('sysdocclscod'=>$lo_ordmdl->sysdocclscod) );
					$lo_data['sysdocclsrej'] = $lo_orddoccls->sysdocclsrej;
				}
				
				// devuelvo datos
				return $this->co_reg->document->getjson( $lo_data );
				break;
			
			
			
			// GET MATERIAL LIST. devuelve la lista de productos para una clasificacion
			case '#getMaterialList':
				$lo_post = $this->co_reg->request->post;
				
				// obtengo precios de materiales de una clasificacion
				$lo_prcmdl = $this->co_reg->load->model('slsprclst');
				$lv_slsprclstcod = (isset($lo_post['slsprclstcod'])?$lo_post['slsprclstcod']:'');
				$lv_slsprclstdte = (isset($lo_post['slsprclstdte'])?$this->co_reg->db->sqldate($lo_post['slsprclstdte']):date_format(new DateTime(),'Ymd').'000000');
				$lv_slsprcsrctyp = 'STK_MAT';
				$lv_matclscod = (isset($lo_post['matclscod'])?$lo_post['matclscod']:'');
				$lv_matcod = (isset($lo_post['matcod'])?$lo_post['matcod']:'');
				$lv_mattxt = (isset($lo_post['mattxt'])?$lo_post['mattxt']:'');
				$lv_prm = array('vewmaxrec'=>'100',
												'vewfldflt'=>	'[~fltrow~]p.slsprclstcod'.chr(9).'='.chr(9).chr(9).$lv_slsprclstcod.chr(9).chr(9).
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]st1.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]^'.substr($lv_slsprclstdte,0,4).'-'.substr($lv_slsprclstdte,4,2).'-'.substr($lv_slsprclstdte,6,2).'^'.chr(9).'ZZ'.chr(9).' BETWEEN pv.slsprclststrdte AND pv.slsprclstenddte'.chr(9).chr(9).chr(9).
																			'[~fltrow~]pv.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]pl.slsprcsrctyp'.chr(9).'='.chr(9).chr(9).$lv_slsprcsrctyp.chr(9).chr(9).
																			'[~fltrow~]pl.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]isnull(st1.matcod,^0^)'.chr(9).'<>'.chr(9).chr(9).'0'.chr(9).chr(9).
																			($lv_matclscod!=''?'[~fltrow~]st1.matclscod'.chr(9).'='.chr(9).chr(9).$lv_matclscod.chr(9).chr(9):'').
																			($lv_mattxt!=''?'[~fltrow~]st1.mattxt'.chr(9).''.chr(9).$lv_mattxt.chr(9).chr(9).chr(9):'').
																			($lv_matcod!=''?'[~fltrow~]pl.slsprcsrccod'.chr(9).'='.chr(9).chr(9).$lv_matcod.chr(9).chr(9):''),
												'vewfldord'=> 'st1.mattxt'
												);
				$lo_rs = $lo_prcmdl->getList($lv_prm);
				$lo_data = $lo_rs;
				
				// devuelvo datos
				return $this->co_reg->document->getjson( $lo_data );
				break;
			
			
			
			// ADD MATERIAL. agrega un material al pedido
			case '#addMaterial':
				$lo_post = $this->co_reg->request->post;
				$lo_ordmatmdl = $this->co_reg->load->model('slsordmat');
				$lv_buffer = html_entity_decode( $lo_post['data'] );
				$lv_buffer_arr = json_decode($lv_buffer,true);
				$lv_ret = '';
				foreach( $lv_buffer_arr as $lv_row ) {				
					$lv_row['docsts'] = 'A';
					if( $lo_ordmatmdl->save($lv_row)==false ) {
						$lv_ret .= '<errtyp>E</errtyp><errcod>'.$lo_ordmatmdl->errcod.'</errcod><errtxt>'.$lo_ordmatmdl->errtxt.'</errtxt>';
					}
				}
				if($lv_ret==''){ $lv_ret='<errtyp>S</errtyp><errcod>0</errcod><errtxt></errtxt>'; }
				return $lv_ret;
				break;
			
			
			
			// UPD MATERIAL. actualiza los datos de un material del pedido
			case '#updMaterial':
				$lo_post = $this->co_reg->request->post;
				$lo_ordmatmdl = $this->co_reg->load->model('slsordmat');
				if( $lo_ordmatmdl->load(array('slsordcod'=>$lo_post['slsordcod'],'slsordmatcod'=>$lo_post['slsordmatcod'])) ){
					$lv_row = $lo_ordmatmdl->getData();
					$lv_row['slsordmatcmt'] = $lo_post['slsordmatcmt'];
					$lv_row['sysdocrejcod'] = $lo_post['sysdocrejcod'];
					if( $lo_ordmatmdl->save($lv_row) ) {
						return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
					} else {
						return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_ordmatmdl->errcod,'errtxt'=>$lo_ordmatmdl->errtxt) );
					}
				} else {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_ordmatmdl->errcod,'errtxt'=>$lo_ordmatmdl->errtxt) );
				}				
				break;
			
			
			
			// ADD ORDER. crea un nuevo pedido para la mesa actual
			// antes se verifica que no exista otro pedido abierto para la misma salon/mesa
			case '#addOrder':
				$lo_post = $this->co_reg->request->post;
				
				// cargodatos del salon
				$lo_slnmdl = $this->co_reg->load->model('gassln');
				$lo_slnmdl->load( array('slncod'=>$lo_post['slncod']) );
				
				// obtengo clase de docuemnto actual
				$lo_doccls = $this->co_reg->load->model('sysdoccls');
				$lo_doccls->load( array('sysdocclscod'=>$lo_post['sysdocclscod']) );				
				$lv_slsord_sysdocclscod = $this->co_reg->document->getTagValue($lo_doccls->sysdocclsatr, 'sysdocclscod');
				$lv_slsord_cuscod = $this->co_reg->document->getTagValue($lo_doccls->sysdocclsatr, 'cuscod');
				
				// verifico que no exista un pedido abierto para esa mesa
				$lo_ordmdl = $this->co_reg->load->model('slsord');
				$lv_prm = array('vewmaxrec' =>'1',
												'vewfldflt' =>'[~fltrow~]o.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_slnmdl->sysdocclscod_ord.chr(9).chr(9).
																			'[~fltrow~]o.slsordcodext'.chr(9).'='.chr(9).chr(9).$lo_slnmdl->slncod.'_'.$lo_post['slntblcod'].chr(9).chr(9).
																			'[~fltrow~]o.docsts'.chr(9).'<>'.chr(9).chr(9).'R'.chr(9).chr(9),
												'vewfldord' =>'o.ctedte desc'
												);
				$lo_rs = $lo_ordmdl->getList( $lv_prm, null, null, false );
				if( count($lo_rs)==0 ) {
					
					// cargo datos del cliente
					$lo_cusmdl = $this->co_reg->load->model('slscus');
					$lo_cusmdl->load( array('cuscod'=>$lv_slsord_cuscod), false );
					
					// creo pedido
					$lo_ordmdl = $this->co_reg->load->model('slsord');
					$lv_dte = new DateTime();
					$lv_row = array('sysdocclscod'=>$lo_slnmdl->sysdocclscod_ord,
													'slsorddte'=>date_format($lv_dte, 'd/m/Y'),
													'slsordcodext'=>$lo_slnmdl->slncod.'_'.$lo_post['slntblcod'],
													'dstobjtyp'=>'SLS_CUS',
													'dstobjcod'=>$lo_slnmdl->cuscod,
													'curcod'=>'ARS',
													'curexcrte'=>1,
													'docsts'=>'A',
													'slsprclstcod'=>$lo_slnmdl->slsprclstcod);
					if( $lo_ordmdl->save($lv_row, false) ) {
						
						// agrego material (cubiertos, servicio de mesa, etc)
						if($lo_post['slntyp']=='S'){
							$lo_ordmatmdl = $this->co_reg->load->model('slsordmat');
							$lv_rowmat = array('slsordcod'=>$lo_ordmdl->slsordcod,
																'matcod'=>'98',
																'mattxt'=>'SERVICIO DE MESA',
																'matqty'=>$lo_post['slsordsrv'],
																'matuntcod'=>'UN',
																'matprc'=>'0',
																'mattot'=>'0',
																'curcod'=>'ARS',
																'docsts'=>'A',
																);
							if( $lo_ordmatmdl->save($lv_rowmat)==false ){ // mensaje REVISE LOS PRODUCTOS, NO SE PUDO AGREGAR AL MENOS UNO
								var_dump( 'REVISE LOS PRODUCTOS, NO SE PUDO AGREGAR AL MENOS UNO' );
							}
						}
						
						return '<errtyp>S</errtyp><errcod>0</errcod><errtxt></errtxt><slsordcod>'.$lo_ordmdl->slsordcod.'</slsordcod>';
					} else { // mensaje SE PRODUJO UN ERROR AL CREAR PEDIDO PARA LA MESA
						return '<errtyp>E</errtyp><errcod>'.$lo_ordmdl->errcod.'</errcod><errtxt>'.$lo_ordmdl->errtxt.'</errtxt>';
					}
				} else { // mensaje YA EXISTE OTRO PEDIDO PARA LA MESA
					return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>Ya existe otro pedido para la misma mesa.</errtxt>';
				}
				break;
			
			
			
			// DEL ORDER. borrar un pedido
			case '#delOrder':
				$lo_post = $this->co_reg->request->post;				
				$lo_ordmdl = $this->co_reg->load->model('slsord');
				if( $lo_ordmdl->delete($lo_post, false) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
				} else {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_ordmdl->errcod,'errtxt'=>$lo_ordmdl->errtxt) );
				}
				break;
			
      
			
			// GET PAYMENT METHODS. obtiene métodos de pago
			case '#getPayMth':
        $lo_paymthmdl = $this->co_reg->load->model('tsrpaymth');
        $lo_rs = $lo_paymthmdl->getList();
        return $this->co_reg->document->getJson( array('data'=>$lo_rs,'actcod'=>$this->data['actcod']) );
				break;
      
			
			
			// PAY ORDER. cobrar un pedido
			case '#payOrder':
				$lo_post = $this->co_reg->request->post;				
				$lo_ordmdl = $this->co_reg->load->model('slsord');
				if( $lo_ordmdl->load( array('slsordcod'=>$lo_post['slsordcod']), false ) ) {;
					$lv_dat = $lo_ordmdl->getData();
					$lv_dat['slsorddte'] = date_format($lv_dat['slsorddte'],'d/m/Y');
					$lv_dat['slsordtot'] = $lv_dat['slsordtotamt'];
					$lv_dat['docsts'] = ($lv_dat['docsts']=='A'?'':$lv_dat['docsts']).'P';
					if( $lo_ordmdl->save($lv_dat, false) ) {
						return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
					} else {
						return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_ordmdl->errcod,'errtxt'=>$lo_ordmdl->errtxt) );
					}
				} else {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_ordmdl->errcod,'errtxt'=>$lo_ordmdl->errtxt) );
				}
				break;
			
			
			
			// CTE ORDER. envia un pedido a cuenta corriente
			case '#cteOrder':
				$lo_post = $this->co_reg->request->post;				
				$lo_ordmdl = $this->co_reg->load->model('slsord');
				if( $lo_ordmdl->load(array('slsordcod'=>$lo_post['slsordcod']), false) ){;
					$lv_dat = $lo_ordmdl->getData();
					$lv_dat['slsorddte'] = date_format($lv_dat['slsorddte'],'d/m/Y');
					$lv_dat['slsordtot'] = $lv_dat['slsordtotamt'];
					$lv_dat['docsts'] = ($lv_dat['docsts']=='A'?'':$lv_dat['docsts']).'C';
					if( $lo_ordmdl->save($lv_dat, false) ) {
						return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
					} else {
						return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_ordmdl->errcod,'errtxt'=>$lo_ordmdl->errtxt) );
					}
				} else {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_ordmdl->errcod,'errtxt'=>$lo_ordmdl->errtxt) );
				}
				break;
			
			
			
			// INVOICE ORDER. facturar un pedido
			case '#invOrder':
				$lo_post = $this->co_reg->request->post;				
				$lo_ordmdl = $this->co_reg->load->model('slsord');
				if( $lo_ordmdl->load(array('slsordcod'=>$lo_post['slsordcod']), false) ){
					$lv_dat = $lo_ordmdl->getData();
					$lv_dat['slsorddte'] = date_format($lv_dat['slsorddte'],'d/m/Y');
					$lv_dat['slsordtot'] = $lv_dat['slsordtotamt'];
					$lv_dat['docsts'] = ($lv_dat['docsts']=='A'?'':$lv_dat['docsts']).'I';
					if( $lo_ordmdl->save($lv_dat, false) ) {
						return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
					} else {
						return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_ordmdl->errcod,'errtxt'=>$lo_ordmdl->errtxt) );
					}
				} else {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_ordmdl->errcod,'errtxt'=>$lo_ordmdl->errtxt) );
				}
				break;
			
			
			
			// CREDIT ORDER. emitir nota de credito
			case '#creOrder':
				$lo_post = $this->co_reg->request->post;				
				$lo_ordmdl = $this->co_reg->load->model('slsord');
				if( $lo_ordmdl->load(array('slsordcod'=>$lo_post['slsordcod']), false) ){
					$lv_dat = $lo_ordmdl->getData();
					$lv_dat['slsorddte'] = date_format($lv_dat['slsorddte'],'d/m/Y');
					$lv_dat['slsordtot'] = $lv_dat['slsordtotamt'];
					$lv_dat['docsts'] = ($lv_dat['docsts']=='I'?'A':str_ireplace('I','',$lv_dat['docsts']));
					if( $lo_ordmdl->save($lv_dat, false) ) {
						return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
					} else {
						return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_ordmdl->errcod,'errtxt'=>$lo_ordmdl->errtxt) );
					}
				} else {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_ordmdl->errcod,'errtxt'=>$lo_ordmdl->errtxt) );
				}
				break;
			
			
			
			// RELEASE ORDER. libera una mesa
			case '#relOrder':
				$lo_post = $this->co_reg->request->post;				
				
				// cargo configuración del salon
				$lo_slnmdl = $this->co_reg->load->model('gassln');
				$lo_slnmdl->load( array('slncod'=>$lo_post['slncod']) );
				
				$lo_ordmdl = $this->co_reg->load->model('slsord');
				if( $lo_ordmdl->load(array('slsordcod'=>$lo_post['slsordcod']), false) ){
					$lv_dat = $lo_ordmdl->getData();
					$lv_dat['slsorddte'] = date_format($lv_dat['slsorddte'],'d/m/Y');
					$lv_dat['slsordtot'] = $lv_dat['slsordtotamt'];
					$lv_dat['docsts'] = 'R';
					if( $lo_ordmdl->save($lv_dat, false) ) {
						
						// STOCK. crea movimiento de salida de stock
						if( $lo_slnmdl->strloccod!='' && $lo_slnmdl->sysdocclscod_stk!='' ){
							$lo_stkmdl = $this->co_reg->load->model('stkmovdoc');
							$lo_stkmatmdl = $this->co_reg->load->model('stkmovdocmat');
							$lv_stkarr = array('stkmovdocdte'=>$lo_ordmdl->slsorddte,
																	'srcobjtyp'=>'STK_STL','srcobjcod'=>$lo_slnmdl->strloccod,
																	'dstobjtyp'=>'SLS_CUS','dstobjcod'=>$lo_slnmdl->cuscod,
																	'sysdocclscod'=>$lo_slnmdl->sysdocclscod_stk,
																	'docsts'=>'A');
							if( $lo_stkmdl->save( $lv_stkarr, false ) ){
								foreach($lo_ordmdl->slsordmat as $lv_row){
									$lv_stkmatarr = array('stkmovdoccod'=>$lo_stkmdl->stkmovdoccod,
																				'matcod'=>$lv_row['matcod'],'mattxt'=>$lv_row['mattxt'],
																				'matqty'=>$lv_row['matqty'],'matuntcod'=>$lv_row['matuntcod'],
																				'docsts'=>'A',
																				'docreftyp'=>'SLS_ORD',
																				'docrefcod'=>$lv_row['slsordcod'],
																				'docrefposcod'=>$lv_row['slsordmatcod']);
									if( !$lo_stkmatmdl->save( $lv_stkmatarr ) ){
										//return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_stkmatmdl->errcod,'errtxt'=>$lo_stkmatmdl->errtxt) );
									}
								}
								// CONTABILIZACION. contabiliza el movimiento de salida
								if( $lo_stkmdl->accounting( array('stkmovdoccod'=>$lo_stkmdl->stkmovdoccod), false ) ){
									return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
								} else {
									return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_stkmdl->errcod,'errtxt'=>$lo_stkmdl->errtxt) );
								}
							}
						} else {
							return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
						}
						
					} else {
						return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_ordmdl->errcod,'errtxt'=>$lo_ordmdl->errtxt) );
					}
				} else {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_ordmdl->errcod,'errtxt'=>$lo_ordmdl->errtxt) );
				}
				break;
    }
  }
}
?>
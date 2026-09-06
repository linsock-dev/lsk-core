<?php
final class grldocflwController extends tmssController {
	const CONTROLLER = 'grldocflw';
	const MODEL = 'grldocflw';
	const VIEW  = 'grldocflw';
	const ID = 'grldocflwcod';
	const OBJTYP ='GRL_FLW';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
  
  
  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {


			// STATUS - BUTTON. muestra el boton de estado
			case '#statusBtn':
				$lo_post = $this->co_reg->request->post;
				return $this->co_reg->document->getView( 'grldocflwstsbtn', array('data'=>array('srcobjtyp'=>$lp_prm['srcobjtyp'],'srcobjcod'=>$lp_prm['srcobjcod'],'lv_sec'=>$lp_prm['lv_sec']) ));
				break;			
			
			
			// STATUS - DETALLE. devuelve la vista de estados del documento
      case '#statuslst':
				$lo_post = $this->co_reg->request->post;
			
				$lo_rshdr = array();
				$lo_rspos = array();
				
				// cargo info del DOCUMENTO
				switch( strtoupper($lo_post['srcobjtyp']) ) {
					case 'SLS_ORD': case 'SLS_QTA':
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo');					
						$lo_docmdl = $this->co_reg->load->model('slsord');
						if( $lo_docmdl->load( array('slsordcod'=>$lo_post['srcobjcod']), false ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_post['srcobjtyp'],
																'srcobjcod'=>$lo_post['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
							foreach($lo_docmdl->slsordmat as $lv_row) {
								$lo_rspos[]=array('srcposcod'=>$lv_row['slsordmatcod'],
																	'matcod'=>$lv_row['matcod'],
																	'mattxt'=>$lv_row['mattxt'],
																	'matqty'=>number_format($lv_row['matqty'],2),
																	'sysdoctrecod'=>$lv_row['sysdoctrecod'],
																	'sysdoctretxt'=>$lv_row['sysdoctretxt'],
																	'sysdocrejcod'=>$lv_row['sysdocrejcod'],
																	'sysdocrejtxt'=>$lv_row['sysdocrejtxt']);
							}
						}
						break;
					case 'SLS_INV': case 'SLS_DEB': case 'SLS_CRE': 
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo','C'=>'Contabilizado');					
						$lo_docmdl = $this->co_reg->load->model('slsinv');
						if( $lo_docmdl->load( array('slsinvcod'=>$lo_post['srcobjcod']), false ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_post['srcobjtyp'],
																'srcobjcod'=>$lo_post['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
							foreach($lo_docmdl->slsinvmat as $lv_row) {
								$lo_rspos[]=array('srcposcod'=>$lv_row['slsinvmatcod'],
																	'matcod'=>$lv_row['matcod'],
																	'mattxt'=>$lv_row['mattxt'],
																	'matqty'=>number_format($lv_row['matqty'],2),
																	'sysdoctrecod'=>$lv_row['sysdoctrecod'],
																	'sysdoctretxt'=>$lv_row['sysdoctretxt'],
																	'sysdocrejcod'=>$lv_row['sysdocrejcod'],
																	'sysdocrejtxt'=>$lv_row['sysdocrejtxt']);
							}
						}
						break;
					case 'STK_SIN': case 'STK_SOU': case 'STK_INV':
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo','C'=>'Contabilizado');					
						$lo_docmdl = $this->co_reg->load->model('stkmovdoc');
						if( $lo_docmdl->load( array('stkmovdoccod'=>$lo_post['srcobjcod']), false ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_post['srcobjtyp'],
																'srcobjcod'=>$lo_post['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
							foreach($lo_docmdl->stkmovdocmat as $lv_row) {
								$lo_rspos[]=array('srcposcod'=>$lv_row['stkmovdocmatcod'],
																	'matcod'=>$lv_row['matcod'],
																	'mattxt'=>$lv_row['mattxt'],
																	'matqty'=>number_format($lv_row['matqty'],2),
																	'sysdoctrecod'=>$lv_row['sysdoctrecod'],
																	'sysdoctretxt'=>$lv_row['sysdoctretxt'],
																	'sysdocrejcod'=>$lv_row['sysdocrejcod'],
																	'sysdocrejtxt'=>$lv_row['sysdocrejtxt']);
							}
						}
						break;
					case 'BUY_ORD': case 'BUY_REQ':
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo');					
						$lo_docmdl = $this->co_reg->load->model('buyord');
						if( $lo_docmdl->load( array('buyordcod'=>$lo_post['srcobjcod']), false ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_post['srcobjtyp'],
																'srcobjcod'=>$lo_post['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
							foreach($lo_docmdl->buyordmat as $lv_row) {
								$lo_rspos[]=array('srcposcod'=>$lv_row['buyordmatcod'],
																	'matcod'=>$lv_row['matcod'],
																	'mattxt'=>$lv_row['mattxt'],
																	'matqty'=>number_format($lv_row['matqty'],2),
																	'sysdoctrecod'=>$lv_row['sysdoctrecod'],
																	'sysdoctretxt'=>$lv_row['sysdoctretxt'],
																	'sysdocrejcod'=>$lv_row['sysdocrejcod'],
																	'sysdocrejtxt'=>$lv_row['sysdocrejtxt']);
							}
						}
						break;
					case 'BUY_INV': case 'BUY_DEB': case 'BUY_CRE':
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo','C'=>'Contabilizado');					
						$lo_docmdl = $this->co_reg->load->model('buyinv');
						if( $lo_docmdl->load( array('buyinvcod'=>$lo_post['srcobjcod']), false ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_post['srcobjtyp'],
																'srcobjcod'=>$lo_post['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
							foreach($lo_docmdl->buyinvmat as $lv_row) {
								$lo_rspos[]=array('srcposcod'=>$lv_row['buyinvmatcod'],
																	'matcod'=>$lv_row['matcod'],
																	'mattxt'=>$lv_row['mattxt'],
																	'matqty'=>number_format($lv_row['matqty'],2),
																	'sysdoctrecod'=>$lv_row['sysdoctrecod'],
																	'sysdoctretxt'=>$lv_row['sysdoctretxt'],
																	'sysdocrejcod'=>$lv_row['sysdocrejcod'],
																	'sysdocrejtxt'=>$lv_row['sysdocrejtxt']);
							}
						}
						break;
					case 'EDU_LQC':
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo','C'=>'Contabilizado');					
						$lo_docmdl = $this->co_reg->load->model('edulqd');
						if( $lo_docmdl->load( array('edulqdcod'=>$lo_post['srcobjcod']), false ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_post['srcobjtyp'],
																'srcobjcod'=>$lo_post['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
						}
						break;
            case 'EDU_LQM':
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo','C'=>'Contabilizado');					
						$lo_docmdl = $this->co_reg->load->model('edutchlqd');
						if( $lo_docmdl->load( array('edutchlqdcod'=>$lo_post['srcobjcod']) ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_post['srcobjtyp'],
																'srcobjcod'=>$lo_post['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
						}
						break;
					case 'SLS_SVL':
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo','C'=>'Contabilizado');					
						$lo_docmdl = $this->co_reg->load->model('slssvclqd');
						if( $lo_docmdl->load( array('slssvclqdcod'=>$lo_post['srcobjcod']), false ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_post['srcobjtyp'],
																'srcobjcod'=>$lo_post['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
						}
						break;
					case 'STK_MCS':
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo');					
						$lo_docmdl = $this->co_reg->load->model('stkmanreq');
						if( $lo_docmdl->load( array('stkmanreqcod'=>$lo_post['srcobjcod']), false ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_post['srcobjtyp'],
																'srcobjcod'=>$lo_post['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
              
							foreach($lo_docmdl->stkmanreqmat as $lv_row) {
								$lo_rspos[]=array('srcposcod'=>$lv_row['stkmanreqmatcod'],
																	'matcod'=>$lv_row['matcod'],
																	'mattxt'=>$lv_row['mattxt'],
																	'matqty'=>1,
																	'sysdoctrecod'=>$lv_row['sysdoctrecod'],
																	'sysdoctretxt'=>$lv_row['sysdoctretxt'],
																	'sysdocrejcod'=>$lv_row['sysdocrejcod'],
																	'sysdocrejtxt'=>$lv_row['sysdocrejtxt']);
							}
						}
						break;
            
					case 'STK_MCO':
						$lv_docsts = array('A'=>'Activo','I'=>'Inactivo');					
						$lo_docmdl = $this->co_reg->load->model('stkmanord');
						if( $lo_docmdl->load( array('stkmanordcod'=>$lo_post['srcobjcod']), false ) ) {
							$lo_rshdr = array('srcobjtyp'=>$lo_post['srcobjtyp'],
																'srcobjcod'=>$lo_post['srcobjcod'],
																'docsts'=>$lo_docmdl->docsts,
																'docststxt'=>$lv_docsts[$lo_docmdl->docsts],
																'sysdoctrecod'=>$lo_docmdl->sysdoctrecod,
																'sysdoctretxt'=>$lo_docmdl->sysdoctretxt,
																'sysdocrejcod'=>$lo_docmdl->sysdocrejcod,
																'sysdocrejtxt'=>$lo_docmdl->sysdocrejtxt);
              
							foreach($lo_docmdl->stkmanordmat as $lv_row) {
								$lo_rspos[]=array('srcposcod'=>$lv_row['stkmanordmatcod'],
																	'matcod'=>$lv_row['matcod'],
																	'mattxt'=>$lv_row['mattxt'],
																	'matqty'=>1,
																	'sysdoctrecod'=>$lv_row['sysdoctrecod'],
																	'sysdoctretxt'=>$lv_row['sysdoctretxt'],
																	'sysdocrejcod'=>$lv_row['sysdocrejcod'],
																	'sysdocrejtxt'=>$lv_row['sysdocrejtxt']);
							}
						}
						break;
				}
				
        $lo_flw = $this->co_reg->load->model('grldocflw');
				$lv_prm =array('srcobjtyp'=>$lo_post['srcobjtyp'], 'srcobjcod'=>$lo_post['srcobjcod']);
        
        $lo_treflw = $lo_flw->getDocumentTree( $lv_prm );
        
        // cargo el documento referenciado y los documentos de ORIGEN y DESTINO en una misma estructura de árbol.
        $lo_rshdr['treflw'] = $lo_treflw;
				$lv_prm =array('vewfldflt'=>'[~fltrow~]fp.refobjtyp'.chr(9).'='.chr(9).chr(9). strtoupper($lo_post['srcobjtyp']) .chr(9).chr(9).
																		'[~fltrow~]fp.refobjcod'.chr(9).'='.chr(9).chr(9). $lo_post['srcobjcod'] .chr(9).chr(9)
																		);
																		
				$lo_srcflw = $lo_flw->getList( $lv_prm );
				$lo_rshdr['srcflw'] = $lo_srcflw;
				
				// cargo los documentos de DESTINO
				$lv_prm =array('vewfldflt'=>'[~fltrow~]fp.srcobjtyp'.chr(9).'='.chr(9).chr(9). strtoupper($lo_post['srcobjtyp']) .chr(9).chr(9).
																		'[~fltrow~]fp.srcobjcod'.chr(9).'='.chr(9).chr(9). $lo_post['srcobjcod'] .chr(9).chr(9)
																		);
				$lo_dstflw = $lo_flw->getList( $lv_prm );
				$lo_rshdr['dstflw'] = $lo_dstflw;

				// cargo los objetos del sistema
				$lo_objtyp = $this->co_reg->load->model('sysobjtyp');
				$lo_objrs = $lo_objtyp->getList( array() );
				$lo_rshdr['objtyp'] = $lo_objrs;
				
				// devuelvo la VISTA
				return $this->co_reg->document->getView( 'grldocflwstslst', array('data'=>$this->lo_mdl,'dathdr'=>$lo_rshdr,'datpos'=>$lo_rspos,'actcod'=>$this->data['actcod']) );
				break;
			
			
			// STATUS - DOCUMENTO
			case '#showdocument':
				$lo_post = $this->co_reg->request->post;
				$lv_mdlcod = explode('_',$lo_post['srcobjtyp'])[0];
				$lv_prgcod = explode('_',$lo_post['srcobjtyp'])[1];
				$lv_oprcod = '03';
				
				// cargo la definición del objeto
				$lo_objtyp = $this->co_reg->load->model('sysobjtyp');
				$lo_objtyp->load( array('objtypcod'=>$lo_post['srcobjtyp']) );
				
				// cargo controlador y devuelvo vista
				$lo_srcctr = $this->co_reg->load->controller( $lo_objtyp->objtypctr );
				$lp_prm[ $lo_objtyp->objtypkey ] = $lo_post['srcobjcod'];
				$lp_prm[ 'mdlcod' ] = $lv_mdlcod;
				$lp_prm[ 'prgcod' ] = $lv_prgcod;
				return $lo_srcctr->index( $lv_oprcod, $lp_prm );
				break;
			
			
			// NEXT. devuelve el boton "Documento Siguiente"
			case '#nextBtn':
				$lo_post = $this->co_reg->request->post;
				$lv_sysdocclscod = ($lp_prm['sysdocclscod']??'');
				
				if( $lv_sysdocclscod!='') {
					// 1-obtener el ID de la clase de documento actual
					// 2-cargar el detalle de la clase de documento (para obtener el objeto)
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load( array('sysdocclscod'=>$lv_sysdocclscod) );
					
					// 3-recuperar todas las clases de documento con el mismo objeto que tengan como referencia a la clase de documento actual (atributo "refdoccls")
					$lv_prm = array('vewfldflt' =>'[~fltrow~]^;^+dbo.GetTagValue(^refdoccls^,d.sysdocclsatr)+^;^'.chr(9).''.chr(9).';'.$lo_docclsmdl->sysdocclscod.';'.chr(9).chr(9).chr(9).
																			'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																			);
					$lo_rsref = $lo_docclsmdl->getList( $lv_prm );
				} else {
					$lo_rsref = array();
				}
				
				return $this->co_reg->document->getJson( $lo_rsref );
				break;
			
			
			// NEXT. devuelve la vista para creación de documento siguiente
			case '#nextLst':
				$lo_post = $this->co_reg->request->post;
				$lo_rs = $lo_post;
				
				// 1-obtener el ID de la clase de documento actual
				// 2-cargar el detalle de la clase de documento (para obtener el objeto)
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$lo_post['sysdocclscod']) );
				
				// obtengo posiciones del documento actual
				$lo_rspos = array();
				switch( strtoupper(trim($lo_post['srcobjtyp'])) ){
					case 'SLS_ORD': case 'SLS_QTA':
						$lo_slsordmdl = $this->co_reg->load->model('slsordmat');
						$lv_prm = array('vewfldflt'=>'[~fltrow~]o.slsordcod'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod'].chr(9).chr(9).
																				'[~fltrow~]isnull(o.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]isnull(om.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]om.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9),
														'vewfldord'=>'o.slsordcod, om.slsordmatcod' );
						$lo_rspos = $lo_slsordmdl->getList( $lv_prm );
						for($i=0;$i<count($lo_rspos);$i++){
							$lo_rspos[$i]['doccod'] = $lo_rspos[$i]['slsordcod'];
							$lo_rspos[$i]['docposcod'] = $lo_rspos[$i]['slsordmatcod'];
							$lo_rspos[$i]['matqty'] = ($lo_rspos[$i]['refposqty']==null?$lo_rspos[$i]['matqty']:$lo_rspos[$i]['refposqty']);
							$lo_rspos[$i]['matbchcodext'] = '';
							$lo_rspos[$i]['matsercodext'] = '';
						}
						break;
					case 'BUY_ORD': case 'BUY_REQ':
						$lo_buyordmdl = $this->co_reg->load->model('buyordmat');
						$lv_prm = array('vewfldflt'=>'[~fltrow~]o.buyordcod'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod'].chr(9).chr(9).
																				'[~fltrow~]isnull(o.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]isnull(om.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]om.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9),
														'vewfldord'=>'o.buyordcod, om.buyordmatcod' );
						$lo_rspos = $lo_buyordmdl->getList( $lv_prm );
						for($i=0;$i<count($lo_rspos);$i++){
							$lo_rspos[$i]['doccod'] = $lo_rspos[$i]['buyordcod'];
							$lo_rspos[$i]['docposcod'] = $lo_rspos[$i]['buyordmatcod'];
							$lo_rspos[$i]['matqty'] = ($lo_rspos[$i]['refposqty']==null?$lo_rspos[$i]['matqty']:$lo_rspos[$i]['refposqty']);
							$lo_rspos[$i]['matbchcodext'] = '';
							$lo_rspos[$i]['matsercodext'] = '';
						}
						break;
					case 'STK_SIN': case 'STK_SOU':
						$lo_stkmovmdl = $this->co_reg->load->model('stkmovdocmat');
						$lv_prm = array('vewfldflt'=>'[~fltrow~]d.stkmovdoccod'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod'].chr(9).chr(9).
																				'[~fltrow~]isnull(d.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]isnull(dm.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]dm.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9),
														'vewfldord'=>'d.stkmovdoccod, dm.stkmovdocmatcod' );
						$lo_rspos = $lo_stkmovmdl->getList( $lv_prm );
						for($i=0;$i<count($lo_rspos);$i++){
							$lo_rspos[$i]['doccod'] = $lo_rspos[$i]['stkmovdoccod'];
							$lo_rspos[$i]['docposcod'] = $lo_rspos[$i]['stkmovdocmatcod'];
							$lo_rspos[$i]['matqty'] = ($lo_rspos[$i]['refposqty']==null?$lo_rspos[$i]['matqty']:$lo_rspos[$i]['refposqty']);
							$lo_rspos[$i]['matbchcodext'] = '';
							$lo_rspos[$i]['matsercodext'] = '';
						}
						break;
          case 'SLS_INV': case 'SLS_CRE': case 'SLS_DEB':
						$lo_slsinvmdl = $this->co_reg->load->model('slsinvmat');
						$lv_prm = array('vewfldflt'=>'[~fltrow~]o.slsinvcod'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod'].chr(9).chr(9).
																				'[~fltrow~]isnull(o.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]isnull(om.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]om.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9),
														'vewfldord'=>'o.slsinvcod, om.slsinvmatcod' );
						$lo_rspos = $lo_slsinvmdl->getList( $lv_prm );
						for($i=0;$i<count($lo_rspos);$i++){
							$lo_rspos[$i]['doccod'] = $lo_rspos[$i]['slsinvcod'];
							$lo_rspos[$i]['docposcod'] = $lo_rspos[$i]['slsinvmatcod'];
							$lo_rspos[$i]['matqty'] = ($lo_rspos[$i]['refposqty']==null?$lo_rspos[$i]['matqty']:$lo_rspos[$i]['refposqty']);
							$lo_rspos[$i]['matbchcodext'] = '';
							$lo_rspos[$i]['matsercodext'] = '';
						}
						break;
          case 'STK_MCS':
						$lo_manreqmdl = $this->co_reg->load->model('stkmanreqmat');
						$lv_prm = array('vewfldflt'=>'[~fltrow~]rm.stkmanreqcod'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod'].chr(9).chr(9).
																				'[~fltrow~]isnull(r.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				//'[~fltrow~]isnull(rm.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]rm.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9),
														'vewfldord'=>'r.stkmanreqcod, rm.stkmanreqmatcod' );
						$lo_rspos = $lo_manreqmdl->getList( $lv_prm );
						for($i=0;$i<count($lo_rspos);$i++){
							$lo_rspos[$i]['doccod'] = $lo_rspos[$i]['stkmanreqcod'];
							$lo_rspos[$i]['docposcod'] = $lo_rspos[$i]['stkmanreqmatcod'];
							$lo_rspos[$i]['matqty'] = ($lo_rspos[$i]['refposqty']==null?1:$lo_rspos[$i]['refposqty']);
							$lo_rspos[$i]['matbchcodext'] = '';
							$lo_rspos[$i]['matsercodext'] = $lo_rspos[$i]['matsercodext'];
						}
						break;
          case 'STK_MCO':
						$lo_manordmdl = $this->co_reg->load->model('stkmanordmat');
						$lv_prm = array('vewfldflt'=>'[~fltrow~]r.stkmanordcod'.chr(9).'='.chr(9).chr(9).$lo_post['srcobjcod'].chr(9).chr(9).
																				'[~fltrow~]isnull(ord.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]r.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9),
														'vewfldord'=>'r.stkmanordcod, r.stkmanordmatcod' );
						$lo_rspos = $lo_manordmdl->getList( $lv_prm );
						for($i=0;$i<count($lo_rspos);$i++){
							$lo_rspos[$i]['doccod'] = $lo_rspos[$i]['stkmanordcod'];
							$lo_rspos[$i]['docposcod'] = $lo_rspos[$i]['stkmanordmatcod'];
							$lo_rspos[$i]['matqty'] = ($lo_rspos[$i]['refposqty']==null?1:$lo_rspos[$i]['refposqty']);
							$lo_rspos[$i]['matbchcodext'] = '';
							$lo_rspos[$i]['matsercodext'] = $lo_rspos[$i]['matsercodext'];
						}
						break;
				}
				
				// 3-recuperar todas las clases de documento con el mismo objeto que tengan como referencia a la clase de documento actual (atributo "refdoccls")
				$lv_prm = array('vewfldflt' =>'[~fltrow~]^;^+dbo.GetTagValue(^refdoccls^,d.sysdocclsatr)+^;^'.chr(9).''.chr(9).';'.$lo_docclsmdl->sysdocclscod.';'.chr(9).chr(9).chr(9).
																		'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																		);
				$lo_rsref = $lo_docclsmdl->getList( $lv_prm );

				// si no se encontraron clases de documento, muestro mensaje de error
				if(count($lo_rsref)==0){
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se encontraron clases de documento referenciadas') );
					
				// 4-si hay una sola clase de documento, la utilizo
				// 5-sino, preguntar cual utilizar
				} else {
					// 6-preguntar si se referencian todas las posiciones (mostrar todas las posiciones y cantidades, copiando a una nueva col las cantidades a referenciar)
					return $this->co_reg->document->getView( 'grldocflwposnxtLst', array('data'=>$lo_rs,'docpos'=>$lo_rspos,'doccls'=>$lo_rsref) );
					return $lv_ret;
				}
				break;
			
			
			// NEXT DOCUMENT. ejecuta la opción de proximo documento
			case '#nextDoc':
				$lo_post = $this->co_reg->request->post;
				$lo_srcarr = array();
				$lo_ret = array();
				$lo_post['matrow'] = html_entity_decode($lo_post['matrow']);
    
        // array de materiales que se quieren referenciar al documento nuevo
				$lv_matarr = json_decode($lo_post['matrow'],true);
				
				// 1. CARGO DOCUMENTO. cargo el documento referenciado
				switch( strtoupper(trim($lo_post['srcobjtyp'])) ){
					// COTIZACION - PEDIDO
					case 'SLS_ORD': case 'SLS_QTA':
						$lo_srcmdl = $this->co_reg->load->model('slsord');
						$lo_srcmdl->load( array('slsordcod'=>$lo_post['srcobjcod']), false );
						$lo_srcarr = $lo_srcmdl->getData();
						$lo_srcarr['doctxt'] = $lo_srcmdl->slsordtxt;
						$lo_srcarr['docmat'] = $lo_srcmdl->slsordmat;
						unset($lo_srcarr['slsordcod']);
						unset($lo_srcarr['slsordmat']);  
						for($i=count($lo_srcarr['docmat'])-1;$i>=0;$i--){
							foreach($lv_matarr as $lv_rowsel) {
								$lv_found = false;
								if(strval(explode(';',$lv_rowsel)[0])==$lo_srcarr['docmat'][$i]['slsordmatcod']){									
									$lo_srcarr['docmat'][$i]['matqty']=strval(explode(';',$lv_rowsel)[1]);
									$lo_srcarr['docmat'][$i]['docreftyp']=strtoupper(trim($lo_post['srcobjtyp']));
									$lo_srcarr['docmat'][$i]['docrefcod']=$lo_post['srcobjcod'];
									$lo_srcarr['docmat'][$i]['docrefposcod']=$lo_srcarr['docmat'][$i]['slsordmatcod'];
									$lo_srcarr['docmat'][$i]['slsordmatcod']='';
									$lo_srcarr['docmat'][$i]['sysdoctrecod']='';
									$lo_srcarr['docmat'][$i]['sysdocrejcod']='';
									$lv_found = true;
									break;
								}
							}			
							if($lv_found==false){ unset($lo_srcarr['docmat'][$i]); }
						}
						break;
					
					// FACTURA - NOTA DE CREDITO - NOTA DE DEBITO
					case 'SLS_INV': case 'SLS_CRE': case 'SLS_DEB':
						$lo_srcmdl = $this->co_reg->load->model('slsinv');
						$lo_srcmdl->load( array('slsinvcod'=>$lo_post['srcobjcod']), false );
						$lo_srcarr = $lo_srcmdl->getData();
						$lo_srcarr['doctxt'] = $lo_srcmdl->slsinvtxt;
						$lo_srcarr['docmat'] = $lo_srcmdl->slsinvmat;
						unset($lo_srcarr['slsinvcod']);
						unset($lo_srcarr['slsinvmat']);
						for($i=count($lo_srcarr['docmat'])-1;$i>=0;$i--){
							foreach($lv_matarr as $lv_rowsel) {
								$lv_found = false;
								if(strval(explode(';',$lv_rowsel)[0])==$lo_srcarr['docmat'][$i]['slsinvmatcod']){									
									$lo_srcarr['docmat'][$i]['matqty']=strval(explode(';',$lv_rowsel)[1]);
									$lo_srcarr['docmat'][$i]['docreftyp']=strtoupper(trim($lo_post['srcobjtyp']));
									$lo_srcarr['docmat'][$i]['docrefcod']=$lo_post['srcobjcod'];
									$lo_srcarr['docmat'][$i]['docrefposcod']=$lo_srcarr['docmat'][$i]['slsinvmatcod'];
									$lo_srcarr['docmat'][$i]['slsinvmatcod']='';
									$lo_srcarr['docmat'][$i]['sysdoctrecod']='';
									$lo_srcarr['docmat'][$i]['sysdocrejcod']='';
									$lv_found = true;
									break;
								}
							}			
							if($lv_found==false){ unset($lo_srcarr['docmat'][$i]); }
						}
						break;
					
					// REQUISITION - PEDIDO
					case 'BUY_ORD': case 'BUY_REQ':
						$lo_srcmdl = $this->co_reg->load->model('buyord');
						$lo_srcmdl->load( array('buyordcod'=>$lo_post['srcobjcod']), false );
						$lo_srcarr = $lo_srcmdl->getData();
						$lo_srcarr['doctxt'] = $lo_srcmdl->buyordtxt;
						$lo_srcarr['docmat'] = $lo_srcmdl->buyordmat;
						unset($lo_srcarr['buyordcod']);
						unset($lo_srcarr['buyordmat']);
						for($i=count($lo_srcarr['docmat'])-1;$i>=0;$i--){
							foreach($lv_matarr as $lv_rowsel) {
								$lv_found = false;
								if(strval(explode(';',$lv_rowsel)[0])==$lo_srcarr['docmat'][$i]['buyordmatcod']){									
									$lo_srcarr['docmat'][$i]['matqty']=strval(explode(';',$lv_rowsel)[1]);
									$lo_srcarr['docmat'][$i]['docreftyp']=strtoupper(trim($lo_post['srcobjtyp']));
									$lo_srcarr['docmat'][$i]['docrefcod']=$lo_post['srcobjcod'];
									$lo_srcarr['docmat'][$i]['docrefposcod']=$lo_srcarr['docmat'][$i]['buyordmatcod'];
									$lo_srcarr['docmat'][$i]['buyordmatcod']='';
									$lo_srcarr['docmat'][$i]['sysdoctrecod']='';
									$lo_srcarr['docmat'][$i]['sysdocrejcod']='';
									$lv_found = true;
									break;
								}
							}			
							if($lv_found==false){ unset($lo_srcarr['docmat'][$i]); }
						}
						break;
					
					// FACTURA - NOTA DE CREDITO - NOTA DE DEBITO
					case 'BUY_INV': case 'BUY_CRE': case 'BUY_DEB':
						$lo_srcmdl = $this->co_reg->load->model('buyinv');
						$lo_srcmdl->load( array('buyinvcod'=>$lo_post['srcobjcod']), false );
						$lo_srcarr = $lo_srcmdl->getData();
						$lo_srcarr['doctxt'] = $lo_srcmdl->buyinvtxt;
						$lo_srcarr['docmat'] = $lo_srcmdl->buyinvmat;
						unset($lo_srcarr['buyinvcod']);
						unset($lo_srcarr['buyinvmat']);
						for($i=count($lo_srcarr['docmat'])-1;$i>=0;$i--){
							foreach($lv_matarr as $lv_rowsel) {
								$lv_found = false;
								if(strval(explode(';',$lv_rowsel)[0])==$lo_srcarr['docmat'][$i]['buyinvmatcod']){									
									$lo_srcarr['docmat'][$i]['matqty']=strval(explode(';',$lv_rowsel)[1]);
									$lo_srcarr['docmat'][$i]['docreftyp']=strtoupper(trim($lo_post['srcobjtyp']));
									$lo_srcarr['docmat'][$i]['docrefcod']=$lo_post['srcobjcod'];
									$lo_srcarr['docmat'][$i]['docrefposcod']=$lo_srcarr['docmat'][$i]['buyinvmatcod'];
									$lo_srcarr['docmat'][$i]['buyinvmatcod']='';
									$lo_srcarr['docmat'][$i]['sysdoctrecod']='';
									$lo_srcarr['docmat'][$i]['sysdocrejcod']='';
									$lv_found = true;
									break;
								}
							}			
							if($lv_found==false){ unset($lo_srcarr['docmat'][$i]); }
						}
						break;
					
					// ENTRADAS - SALIDAS
					case 'STK_SIN': case 'STK_SOU':
						$lv_refarr = array();
						$lo_srcmdl = $this->co_reg->load->model('stkmovdoc');
						$lo_srcmdl->load( array('stkmovdoccod'=>$lo_post['srcobjcod']), false );
						$lo_srcarr = $lo_srcmdl->getData();
						$lo_srcarr['doctxt'] = $lo_srcmdl->stkmovdoctxt;
						$lo_srcarr['docmat'] = $lo_srcmdl->stkmovdocmat;
						
						// armo lista de documentos referenciados
						foreach($lo_srcmdl->stkmovdocmat as $lv_row){
							if($lv_row['docreftyp']!=''){
								if(!isset($lv_refarr[$lv_row['docreftyp']])){ $lv_refarr[$lv_row['docreftyp']]=''; }
								if(stripos( $lv_row['docrefcod'], $lv_refarr[$lv_row['docreftyp']] )===false){
									$lv_refarr[$lv_row['docreftyp']] .= ($lv_refarr[$lv_row['docreftyp']]==''?'':chr(10)) . $lv_row['docrefcod'];
								}
							}
						}
						// cargo precios de referencia de pedido de compra
						if(isset($lv_refarr['BUY_ORD'])){
							$lo_refmdl = $this->co_reg->load->model('buyordmat');
							$lv_prm = array();
							$lo_rs = $lo_refmdl->getList( $lv_prm );
							foreach($lo_srcarr['docmat'] as &$lv_srcrow){
								$lv_srcrow['buyinvmatatr'] = '';
								foreach($lo_rs as $lv_row){
									if($lv_srcrow['docreftyp']=='BUY_ORD' && $lv_srcrow['docrefcod']==$lv_row['buyordcod'] && $lv_srcrow['docrefposcod']==$lv_row['buyordmatcod']){
										$lv_srcrow['matprc'] =  $lv_row['matprc'];
										break;
									}
								}
							}
							unset($lv_srcrow);
						}

						unset($lo_srcarr['stkmovdoccod']);
						unset($lo_srcarr['stkmovdocmat']);

						for($i=count($lo_srcarr['docmat'])-1;$i>=0;$i--){
							foreach($lv_matarr as $lv_rowsel) {
								$lv_found = false;
								if(strval(explode(';',$lv_rowsel)[0])==$lo_srcarr['docmat'][$i]['stkmovdocmatcod']){									
									$lo_srcarr['docmat'][$i]['matqty']=strval(explode(';',$lv_rowsel)[1]);
									$lo_srcarr['docmat'][$i]['docreftyp']=strtoupper(trim($lo_post['srcobjtyp']));
									$lo_srcarr['docmat'][$i]['docrefcod']=$lo_post['srcobjcod'];
									$lo_srcarr['docmat'][$i]['docrefposcod']=$lo_srcarr['docmat'][$i]['stkmovdocmatcod'];
									$lo_srcarr['docmat'][$i]['stkmovdoccod']='';
									$lo_srcarr['docmat'][$i]['sysdoctrecod']='';
									$lo_srcarr['docmat'][$i]['sysdocrejcod']='';
									$lv_found = true;
									break;
								}
							}			
							if($lv_found==false){ unset($lo_srcarr['docmat'][$i]); }
						}
						break;
						
						
					// MANTENIMIENTO. CORRECTIVO
					case 'STK_MCS': 
						$lo_srcmdl = $this->co_reg->load->model('stkmanreq');
						$lo_srcmdl->load( array('stkmanreqcod'=>$lo_post['srcobjcod']), false );
						$lo_srcarr = $lo_srcmdl->getData();
						$lo_srcarr['doctxt'] = $lo_srcmdl->stkmanreqtxt;
						$lo_srcarr['docmat'] = $lo_srcmdl->stkmanreqmat;
						unset($lo_srcarr['stkmanreqcod']);
						unset($lo_srcarr['stkmanreqmat']);
						for($i=count($lo_srcarr['docmat'])-1;$i>=0;$i--){
							foreach($lv_matarr as $lv_rowsel) {
								$lv_found = false;
								if(strval(explode(';',$lv_rowsel)[0])==$lo_srcarr['docmat'][$i]['stkmanreqmatcod']){
									$lo_srcarr['docmat'][$i]['matqty']=strval(explode(';',$lv_rowsel)[1]);
									$lo_srcarr['docmat'][$i]['docreftyp']=strtoupper(trim($lo_post['srcobjtyp']));
									$lo_srcarr['docmat'][$i]['docrefcod']=$lo_post['srcobjcod'];
									$lo_srcarr['docmat'][$i]['docrefposcod']=$lo_srcarr['docmat'][$i]['stkmanreqmatcod'];
									$lo_srcarr['docmat'][$i]['stkmanordmatcod']='';
									$lo_srcarr['docmat'][$i]['stkmanordmatatr']=$lo_srcarr['docmat'][$i]['stkmanreqmatatr'];
									$lo_srcarr['docmat'][$i]['sysdoctrecod']='';
									$lo_srcarr['docmat'][$i]['sysdocrejcod']='';
									$lv_found = true;
									break;
								}
							}			
							if($lv_found==false){ unset($lo_srcarr['docmat'][$i]); }
						}
						break;
						
						
					// MANTENIMIENTO. ORDEN DE TRABAJO
					case 'STK_MCO': 
						$lo_srcmdl = $this->co_reg->load->model('stkmanord');
						$lo_srcmdl->load( array('stkmanordcod'=>$lo_post['srcobjcod']), false );
						$lo_srcarr = $lo_srcmdl->getData();
						$lo_srcarr['doctxt'] = $lo_srcmdl->stkmanordtxt;
						$lo_srcarr['docmat'] = $lo_srcmdl->stkmanordmat;
						unset($lo_srcarr['stkmanreqcod']);
						unset($lo_srcarr['stkmanreqmat']);
						for($i=count($lo_srcarr['docmat'])-1;$i>=0;$i--){
							foreach($lv_matarr as $lv_rowsel) {
								$lv_found = false;
								if(strval(explode(';',$lv_rowsel)[0])==$lo_srcarr['docmat'][$i]['stkmanordmatcod']){
									$lo_srcarr['docmat'][$i]['stkmanordtxt']=$lo_srcarr['doctxt'];
									$lo_srcarr['docmat'][$i]['matqty']=strval(explode(';',$lv_rowsel)[1]);
									$lo_srcarr['docmat'][$i]['docreftyp']=strtoupper(trim($lo_post['srcobjtyp']));
									$lo_srcarr['docmat'][$i]['docrefcod']=$lo_post['srcobjcod'];
									$lo_srcarr['docmat'][$i]['docrefposcod']=$lo_srcarr['docmat'][$i]['stkmanordmatcod'];
									$lo_srcarr['docmat'][$i]['stkmanactmatcod']='';
									$lo_srcarr['docmat'][$i]['stkmanactmatatr']=$lo_srcarr['docmat'][$i]['stkmanordmatatr'];
									$lo_srcarr['docmat'][$i]['sysdoctrecod']='';
									$lo_srcarr['docmat'][$i]['sysdocrejcod']='';
									$lv_found = true;
									break;
								}
							}			
							if($lv_found==false){ unset($lo_srcarr['docmat'][$i]); }
						}
						break;
				}
				
				// 2. INICIALIZO CAMPOS. borro campos que no deben copiarse
        $lo_srcarr['srcsysdocclscod'] = $lo_srcarr['sysdocclscod'];
				$lo_srcarr['sysdocclscod'] = $lo_post['sysdocclscod'];
				unset($lo_srcarr['ctedte']);
				unset($lo_srcarr['cteusr']);
				unset($lo_srcarr['upddte']);
				unset($lo_srcarr['updusr']);
				unset($lo_srcarr['sysdoctrecod']);
				unset($lo_srcarr['sysdocrejcod']);
				foreach($lo_srcarr as &$lv_row){
					if(is_a($lv_row,'DateTime')){
						$lv_row = $lv_row->format('d/m/Y');
					} else if($lv_row==null){
						$lv_row='';
					}
				}
				unset($lv_row);
				
				// 3. ARMO NUEVO DOCUMENTO. preparo datos para nuevo documento
				$lo_post['objtyp'] = strtoupper(trim($lo_post['objtyp']));
				$lv_mdlcod = explode('_',$lo_post['objtyp'])[0];
				$lv_prgcod = explode('_',$lo_post['objtyp'])[1];
				switch( $lo_post['objtyp'] ) {
					// REQUISICION - PEDIDO
					case 'BUY_ORD': case 'BUY_REQ':
						$lo_ret = $lo_srcarr;
						$lo_ret['url'] = '?prg=buyord&act=01&prm_mdlcod='.$lv_mdlcod.'&prm_prgcod='.$lv_prgcod;
						$lo_ret['mdlcod'] = $lv_mdlcod;
						$lo_ret['prgcod'] = $lv_prgcod;
						$lo_ret['buyordtxt'] = $lo_srcarr['doctxt'];
						$lo_ret['buyordmat'] = $lo_srcarr['docmat'];
						unset($lo_ret['docmat']);
						break;
					
					// FACTURA - NOTA DE CREDITO - NOTA DE DEBITO
					case 'BUY_INV': case 'BUY_CRE': case 'BUY_DEB':
						$lo_ret = $lo_srcarr;
						$lo_ret['url'] = '?prg=buyinv&act=01&prm_mdlcod='.$lv_mdlcod.'&prm_prgcod='.$lv_prgcod;
						$lo_ret['mdlcod'] = $lv_mdlcod;
						$lo_ret['prgcod'] = $lv_prgcod;
						$lo_ret['buyinvtxt'] = $lo_srcarr['doctxt'];
						$lo_ret['buyinvmat'] = $lo_srcarr['docmat'];
						unset($lo_ret['docmat']);
						break;
					
					// COTIZACION - PEDIDO
					case 'SLS_ORD': case 'SLS_QTA':
						$lo_ret = $lo_srcarr;
						$lo_ret['url'] = '?prg=slsord&act=01&prm_mdlcod='.$lv_mdlcod.'&prm_prgcod='.$lv_prgcod;
						$lo_ret['mdlcod'] = $lv_mdlcod;						
						$lo_ret['prgcod'] = $lv_prgcod;
						$lo_ret['slsordtxt'] = $lo_srcarr['doctxt'];
						$lo_ret['slsordmat'] = $lo_srcarr['docmat'];
						unset($lo_ret['docmat']);
						break;
					
					// ENTRADAS - SALIDAS
					case 'STK_SIN': case 'STK_SOU':
						// documento de anulacion. si es un documento de anulación se intercambian los datos de origen y destino
						$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
						$lo_docclsmdl->load( array('sysdocclscod'=>$lo_srcarr['sysdocclscod']) );
						$lv_docrev = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr,'docrev');
						if($lv_docrev!=''){
							$lv_srcobjtyp = $lo_srcarr['srcobjtyp'];
							$lv_srcobjcod = $lo_srcarr['srcobjcod'];
							$lv_srcobjtxt = $lo_srcarr['srcobjtxt'];
							$lv_srccntcod = $lo_srcarr['srccntcod'];
							$lv_srccnttxt = $lo_srcarr['srccnttxt'];
							$lo_srcarr['srcobjtyp'] = $lo_srcarr['dstobjtyp'];
							$lo_srcarr['srcobjcod'] = $lo_srcarr['dstobjcod'];
							$lo_srcarr['srcobjtxt'] = $lo_srcarr['dstobjtxt'];
							$lo_srcarr['srccntcod'] = $lo_srcarr['dstcntcod'];
							$lo_srcarr['srccnttxt'] = $lo_srcarr['dstcnttxt'];
							$lo_srcarr['dstobjtyp'] = $lv_srcobjtyp;
							$lo_srcarr['dstobjcod'] = $lv_srcobjcod;
							$lo_srcarr['dstobjtxt'] = $lv_srcobjtxt;
							$lo_srcarr['dstcntcod'] = $lv_srccntcod;
							$lo_srcarr['dstcnttxt'] = $lv_srccnttxt;
						}
					
						$lo_ret = $lo_srcarr;
						$lo_ret['url'] = '?prg=stkmovdoc&act=01&prm_mdlcod='.$lv_mdlcod.'&prm_prgcod='.$lv_prgcod;
						$lo_ret['mdlcod'] = $lv_mdlcod;
						$lo_ret['prgcod'] = $lv_prgcod;
						$lo_ret['stkmovdoccmt'] = $lo_srcarr['doctxt'];
						$lo_ret['stkmovdocmat'] = $lo_srcarr['docmat'];
						unset($lo_ret['docmat']);
						break;
					
					// FACTURA - NOTA DE CRETIDO - NOTA DE DEBITO
					case 'SLS_INV': case 'SLS_CRE': case 'SLS_DEB':
						$lo_ret = $lo_srcarr;
						$lo_ret['url'] = '?prg=slsinv&act=01&prm_mdlcod='.$lv_mdlcod.'&prm_prgcod='.$lv_prgcod;
						$lo_ret['mdlcod'] = $lv_mdlcod;
						$lo_ret['prgcod'] = $lv_prgcod;
						$lo_ret['slsinvtxt'] = $lo_srcarr['doctxt'];
						$lo_ret['slsinvmat'] = $lo_srcarr['docmat'];
						unset($lo_ret['docmat']);
						break;

					// MANTENIMIENTO. ORDEN DE TRABAJO
					case 'STK_MCO': 
						$lo_ret = $lo_srcarr;
						$lo_ret['url'] = '?prg=stkmanord&act=01&prm_mdlcod='.$lv_mdlcod.'&prm_prgcod='.$lv_prgcod;
						$lo_ret['mdlcod'] = $lv_mdlcod;
						$lo_ret['prgcod'] = $lv_prgcod;
						$lo_ret['stkmanordtxt'] = $lo_srcarr['doctxt'];
						$lo_ret['stkmanordmat'] = $lo_srcarr['docmat'];
						$lo_ret['srcobjtxt'] = '';
						$lo_ret['srcobjcod'] = '';
						unset($lo_ret['docmat']);
						break;

					// MANTENIMIENTO. ACTIVIDAD
					case 'STK_MCA': 
						$lo_ret = $lo_srcarr;
						$lo_ret['url'] = '?prg=stkmanact&act=01&prm_mdlcod='.$lv_mdlcod.'&prm_prgcod='.$lv_prgcod;
						$lo_ret['mdlcod'] = $lv_mdlcod;
						$lo_ret['prgcod'] = $lv_prgcod;
						$lo_ret['stkmanacttxt'] = $lo_srcarr['doctxt'];
						$lo_ret['stkmanactmat'] = $lo_srcarr['docmat'];
						unset($lo_ret['docmat']);
						break;
				}
				
				return $this->co_reg->document->getJson( $lo_ret );
				break;				
			
			
			// NEW
			case '#01':
				$lo_data = array();
				
				// obtengo la clase de documento actual
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$this->co_reg->request->post['sysdocclscod']) );

				// obtengo todas las clases de documento posibles de referenciar
				$lo_docclsmdl2 = $this->co_reg->load->model('sysdoccls');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]d.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).str_ireplace(';',chr(10),$this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr,'refdoccls')).chr(9).chr(9).
																		'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																		);
				$lo_rsref = $lo_docclsmdl2->getList($lv_prm);
				$lv_docclsarr = array();
				foreach( $lo_rsref as $lv_row ) {
						$lv_docclsarr[ $lv_row['sysdocclscod'] ] = $lv_row['sysdocclstxt'];
				}
				
				$lo_data['docrev']    = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr,'docrev');
				$lo_data['sysdocclstxt'] = $lo_docclsmdl->sysdocclstxt;
				$lo_data['fndobjtyp'] = $this->co_reg->request->post['fndobjtyp'];
				$lo_data['fndobjcod'] = $this->co_reg->request->post['fndobjcod'];
				$lo_data['fndobjtxt'] = $this->co_reg->request->post['fndobjtxt'];
				$lo_data['fndcntcod'] = (isset($this->co_reg->request->post['fndcntcod'])?$this->co_reg->request->post['fndcntcod']:'');
				$lo_data['fndcnttxt'] = (isset($this->co_reg->request->post['fndcnttxt'])?$this->co_reg->request->post['fndcnttxt']:'');
				$lo_data['refarr'] = (isset($this->co_reg->request->post['refarr'])?$this->co_reg->request->post['refarr']:'');
				
				// devuelvo la vista
				return $this->co_reg->document->getView( 'grldocflwposref', array('data'=>$lo_data,'doccls'=>$lv_docclsarr) );
				break;
			
			
			// OBTENER REFERENCIAS
			case '#07':
				ini_set('memory_limit', '2048M');
				
				// obtengo parámetros de búsqueda
				$lo_post = $this->co_reg->request->post;
				$lo_post['docrev'] = strtoupper($lo_post['docrev']);
				
				// obtengo info de la clase de documento a buscar
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load( array('sysdocclscod'=>$lo_post['sysdocclscod']) );				
				$lv_objtyp = $lo_docclsmdl->objtyp;

				$lv_strdte = $this->co_reg->db->sqldate($lo_post['docfndstrdte']);
				$lv_strdte = substr($lv_strdte,0,4).'-'.substr($lv_strdte,4,2).'-'.substr($lv_strdte,6,2);
				$lv_enddte = $this->co_reg->db->sqldate($lo_post['docfndenddte']);
				$lv_enddte = substr($lv_enddte,0,4).'-'.substr($lv_enddte,4,2).'-'.substr($lv_enddte,6,2);
				
				if ($lo_post['refarr']=='') {
          $lo_refarr = array();
				} else {
					$lo_refarr = json_decode(html_entity_decode($lo_post['refarr']),true);
				}
				
				switch( $lv_objtyp ) {
					
					// MOVIMIENTOS DE STOCK
					case 'STK_SIN': case 'STK_SOU': case 'STK_SIV':
            $lv_srcobjtypfnd = strtoupper(($this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr,'srcobjtyp')) == (isset($lo_post['fndobjtyp'])?strtoupper($lo_post['fndobjtyp']):''));
            
						// obtengo los datos de posición
						$lo_datmdl = $this->co_reg->load->model('stkmovdocmat');
						$lv_prm = array('vewfldflt'=>'[~fltrow~]d.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocclscod'].chr(9).chr(9).
																				($lo_post['docfndcod']!=''?'[~fltrow~]d.stkmovdoccod'.chr(9).'='.chr(9).chr(9).$lo_post['docfndcod'].chr(9).chr(9):'').
																				($lo_post['docfndcodext']!=''?'[~fltrow~]d.stkmovdoccodext'.chr(9).'='.chr(9).chr(9).$lo_post['docfndcodext'].chr(9).chr(9):'').
																				'[~fltrow~]d.stkmovdocdte'.chr(9).'BT'.chr(9).chr(9).$lv_strdte.chr(9).$lv_enddte.chr(9).
																				($lo_post['fndobjtyp']!=''?'[~fltrow~]'.($lv_srcobjtypfnd?'d.srcobjtyp':'d.dstobjtyp').chr(9).'='.chr(9).chr(9).$lo_post['fndobjtyp'].chr(9).chr(9):'').
																				($lo_post['fndobjcod']!=''?'[~fltrow~]'.($lv_srcobjtypfnd?'d.srcobjcod':'d.dstobjcod').chr(9).'='.chr(9).chr(9).$lo_post['fndobjcod'].chr(9).chr(9):'').
																				'[~fltrow~]'.($lv_srcobjtypfnd?'d.srccntcod':'d.dstcntcod').chr(9).'='.chr(9).chr(9).($lo_post['fndcntcod']!=''?$lo_post['fndcntcod']:'0').chr(9).chr(9).
																				'[~fltrow~]isnull(d.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]isnull(dm.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'C'.chr(9).chr(9),
														'vewfldord'=>'dm.stkmovdoccod, dm.stkmovdocmatcod'
														);
						$lo_rs = $lo_datmdl->getList( $lv_prm );

						/* ************************************************************* */
						$lv_docrefstr = '';
						/* obtengo precios de documento de referencia VENTAS-PEDIDOS */
						for($i=0; $i<count($lo_rs); $i++) {
							if($lo_rs[$i]['docreftyp']=='SLS_ORD'){
								$lv_docrefstr .= ($lv_docrefstr==''?'':';').$lo_rs[$i]['docrefcod'];
							}
						}
						// obtengo los datos de posición referenciados
						if($lv_docrefstr!='') {
							$lo_sommdl = $this->co_reg->load->model('slsordmat');
							$lv_prm = array('vewfldflt'=>'[~fltrow~]om.slsordcod'.chr(9).'IN'.chr(9).chr(9).str_ireplace(';',chr(10),$lv_docrefstr).chr(9).chr(9),
															'vewfldord'=>'om.slsordcod, om.slsordmatcod'
															);
							$lo_rsref = $lo_sommdl->getList( $lv_prm );
						}
						/* actualizo precio de referencia */
						for($i=0; $i<count($lo_rs); $i++) {
							if($lv_docrefstr!='') {
								for($x=0; $x<count($lo_rsref); $x++) {
									if($lo_rs[$i]['docreftyp']=='SLS_ORD' && $lo_rs[$i]['docrefcod']==$lo_rsref[$x]['slsordcod'] && $lo_rs[$i]['docrefposcod']==$lo_rsref[$x]['slsordmatcod']){
										$lo_rs[$i]['docrefmatprc']=$lo_rsref[$x]['matprc'];
										break;
									}
								}
								if(!isset($lo_rs[$i]['docrefmatprc'])){ $lo_rs[$i]['docrefmatprc'] = 0;}
							} else {
								$lo_rs[$i]['docrefmatprc'] = 0;
							}
						}
						/* ************************************************************* */
						
						// para cada posición del documento resto las referencias existentes
						$lo_ret = array();
            for($i=0; $i<count($lo_rs); $i++) {
              $lo_rs[$i]['matqtyrst'] = ($lo_rs[$i]['refposqty']==null?$lo_rs[$i]['matqty']:$lo_rs[$i]['refposqty']);
							
							// si existe en el documento actual 
							// (documento en el que se hizo ya una referencia pero que todavía no se grabó)
							// descuento esas cantidades
							foreach( $lo_refarr as $lv_rowref ) {
                if ( $lv_rowref['srcobjtyp']=$lv_objtyp && $lo_rs[$i]['stkmovdoccod']==$lv_rowref['srcobjcod'] && $lo_rs[$i]['stkmovdocmatcod']==$lv_rowref['srcposcod'] ) {
									$lo_rs[$i]['matqtyrst'] -= $lv_rowref['refposqty'];
								}
                
							}
							// solo se puede referenciar a la posición si existen saldos pendientes
              if ($lo_rs[$i]['matqtyrst']>0) {
								$lo_ret[] = array('doctyp'=>$lv_objtyp,
																	'doccod'=>$lo_rs[$i]['stkmovdoccod'],
																	'docdte'=>$lo_rs[$i]['stkmovdocdtecnv'],
																	'doccodext'=>$lo_rs[$i]['stkmovdoccodext'],
																	'docatr'=>'', 
																	'docposcod'=>$lo_rs[$i]['stkmovdocmatcod'],
																	'docposcodext'=>$lo_rs[$i]['matcodext'],
																	'docpostxt'=>$lo_rs[$i]['mattxt'],
																	'docposqty'=>round($lo_rs[$i]['matqtyrst'],2), 
																	'docposuntcod'=>$lo_rs[$i]['matuntcod'],
																	'docposatr'=>array(
																		'matcod'=>$lo_rs[$i]['matcod'],
																		'matcodext'=>$lo_rs[$i]['matcodext'],
																		'mattxt'=>$lo_rs[$i]['mattxt'],
																		'matuntcod'=>$lo_rs[$i]['matuntcod'],
																		'matusebch'=>$lo_rs[$i]['matusebch'],
																		'matbchcod'=>$lo_rs[$i]['matbchcod'],
																		'matbchcodext'=>$lo_rs[$i]['matbchcodext'],
																		'matbchduedte'=>$lo_rs[$i]['matbchduedte'],
																		'matuseser'=>$lo_rs[$i]['matuseser'],
																		'matsercod'=>$lo_rs[$i]['matsercod'],
																		'matsercodext'=>$lo_rs[$i]['matsercodext'],
																		'matprc'=>round(($lo_rs[$i]['docrefmatprc'] == 0 ? $lo_rs[$i]['matcst'] : $lo_rs[$i]['docrefmatprc']),2)
																		),
																	'docposatrtxt'=>($lo_rs[$i]['matbchcodext']!=''?'Lote: '.$lo_rs[$i]['matbchcodext'].' - Vto: '.date_format($lo_rs[$i]['matbchduedte'],'d/m/Y'):'').($lo_rs[$i]['matsercodext']!=''?' Serie: '.$lo_rs[$i]['matsercodext']:'')
																	);
							}
						}
						break;
						
					case 'BUY_ORD': case 'BUY_REQ':
						// obtengo los datos de posición
						$lo_datmdl = $this->co_reg->load->model('buyordmat');
						$lv_prm = array('vewfldflt'=>'[~fltrow~]o.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocclscod'].chr(9).chr(9).
																				($lo_post['docfndcod']!=''?'[~fltrow~]om.buyordcod'.chr(9).'='.chr(9).chr(9).$lo_post['docfndcod'].chr(9).chr(9):'').
																				($lo_post['docfndcodext']!=''?'[~fltrow~]o.buyordcodext'.chr(9).'='.chr(9).chr(9).$lo_post['docfndcodext'].chr(9).chr(9):'').
																				'[~fltrow~]o.buyorddte'.chr(9).'BT'.chr(9).chr(9).$lv_strdte.chr(9).$lv_enddte.chr(9).
																				($lo_post['fndobjtyp']!='' && $lv_objtyp!='BUY_REQ'?'[~fltrow~]o.srcobjtyp'.chr(9).'='.chr(9).chr(9).$lo_post['fndobjtyp'].chr(9).chr(9):'').
																				($lo_post['fndobjcod']!='' && $lv_objtyp!='BUY_REQ'?'[~fltrow~]o.srcobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['fndobjcod'].chr(9).chr(9):'').
																				'[~fltrow~]isnull(o.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]isnull(om.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]o.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9),
														'vewfldord'=>'om.buyordcod, om.buyordmatcod'
														);
						$lo_rs = $lo_datmdl->getList( $lv_prm );
						
						// para cada posición del documento resto las referencias existentes
						$lo_ret = array();
						for($i=0; $i<count($lo_rs); $i++) {
							$lo_rs[$i]['matqtyrst'] = ($lo_rs[$i]['refposqty']==null?$lo_rs[$i]['matqty']:$lo_rs[$i]['refposqty']);
							
							// si existe en el documento actual 
							// (documento en el que se hizo ya una referencia pero que todavía no se grabó)
							// descuento esas cantidades
							foreach( $lo_refarr as $lv_rowref ) {
								if ( $lv_rowref['srcobjtyp']=$lv_objtyp && $lo_rs[$i]['buyordcod']==$lv_rowref['srcobjcod'] && $lo_rs[$i]['buyordmatcod']==$lv_rowref['srcposcod'] ) {
									$lo_rs[$i]['matqtyrst'] -= $lv_rowref['refposqty'];
								}
							}
							
							// solo se puede referenciar a la posición si existen saldos pendientes
							if ($lo_rs[$i]['matqtyrst']>0) {
								$lo_ret[] = array('doctyp'=>$lv_objtyp,
																	'doccod'=>$lo_rs[$i]['buyordcod'],
																	'docdte'=>date_format($lo_rs[$i]['buyorddte'],'d/m/Y'),
																	'doccodext'=>$lo_rs[$i]['buyordcodext'],
																	'docatr'=>'',
																	'docposcod'=>$lo_rs[$i]['buyordmatcod'],
																	'docposcodext'=>$lo_rs[$i]['matcodext'],
																	'docpostxt'=>$lo_rs[$i]['mattxt'],
																	'docposqty'=>round($lo_rs[$i]['matqtyrst'],2), 
																	'docposuntcod'=>$lo_rs[$i]['matuntcod'],
																	'docposatr'=>array(
																		'matcod'=>$lo_rs[$i]['matcod'],
																		'matcodext'=>$lo_rs[$i]['matcodext'],
																		'mattxt'=>$lo_rs[$i]['mattxt'],
																		'matuntcod'=>$lo_rs[$i]['matuntcod'],
																		'matusebch'=>$lo_rs[$i]['matusebch'],
																		'matbchcod'=>'',
																		'matbchcodext'=>'',
																		'matbchduedte'=>'',
																		'matuseser'=>$lo_rs[$i]['matuseser'],
																		'matsercod'=>'',
																		'matsercodext'=>'',
                                    'matprc'=>round($lo_rs[$i]['matprc'],2)
																		),
																	'docposatrtxt'=>$this->co_reg->document->getTagValue($lo_rs[$i]['buyordmatatr'], 'buyordmatslstxt')
																	);
							}
						}						
						break;
						
					case 'BUY_INV': case 'BUY_CRE': case 'BUY_DEB':
						break;
					
					
					//  VENTAS:   Ofertas/Cotizaciones - PEDIDOS
					case 'SLS_QTA': case 'SLS_ORD':
						// obtengo los datos de posición
						$lo_datmdl = $this->co_reg->load->model('slsordmat');
						$lv_prm = array('vewfldflt'=>'[~fltrow~]o.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocclscod'].chr(9).chr(9).
																				($lo_post['docfndcod']!=''?'[~fltrow~]o.slsordcod'.chr(9).'='.chr(9).chr(9).$lo_post['docfndcod'].chr(9).chr(9):'').
																				($lo_post['docfndcodext']!=''?'[~fltrow~]o.slsordcodext'.chr(9).'='.chr(9).chr(9).$lo_post['docfndcodext'].chr(9).chr(9):'').
																				'[~fltrow~]o.slsorddte'.chr(9).'BT'.chr(9).chr(9).$lv_strdte.chr(9).$lv_enddte.chr(9).
																				($lo_post['fndobjtyp']!=''?'[~fltrow~]o.dstobjtyp'.chr(9).'='.chr(9).chr(9).$lo_post['fndobjtyp'].chr(9).chr(9):'').
																				($lo_post['fndobjcod']!=''?'[~fltrow~]o.dstobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['fndobjcod'].chr(9).chr(9):'').
																				'[~fltrow~]o.dstcntcod'.chr(9).'='.chr(9).chr(9).($lo_post['fndcntcod']!=''?$lo_post['fndcntcod']:'0').chr(9).chr(9).
																				'[~fltrow~]isnull(o.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]isnull(om.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]o.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9),
														'vewfldord'=>'om.slsordcod, om.slsordmatcod'
														);
						$lo_rs = $lo_datmdl->getList( $lv_prm );
						
						// para cada posición del documento resto las referencias existentes
						$lo_ret = array();
						for($i=0; $i<count($lo_rs); $i++) {
							$lo_rs[$i]['matqtyrst'] = ($lo_rs[$i]['refposqty']==null?$lo_rs[$i]['matqty']:$lo_rs[$i]['refposqty']);
							
							// si existe en el documento actual 
							// (documento en el que se hizo ya una referencia pero que todavía no se grabó)
							// descuento esas cantidades
							foreach( $lo_refarr as $lv_rowref ) {
								if ( $lv_rowref['srcobjtyp']=$lv_objtyp && $lo_rs[$i]['slsordcod']==$lv_rowref['srcobjcod'] && $lo_rs[$i]['slsordmatcod']==$lv_rowref['srcposcod'] ) {
									$lo_rs[$i]['matqtyrst'] -= $lv_rowref['refposqty'];
								}
							}
							
							// solo se puede referenciar a la posición si existen saldos pendientes
							if ($lo_rs[$i]['matqtyrst']>0) {
								$lo_ret[] = array('doctyp'=>$lv_objtyp,
																	'doccod'=>$lo_rs[$i]['slsordcod'],
																	'docdte'=>$lo_rs[$i]['slsorddtecnv'],
																	'doccodext'=>$lo_rs[$i]['slsordcodext'],
																	'docatr'=>'', 
																	'docposcod'=>$lo_rs[$i]['slsordmatcod'],
																	'docposcodext'=>$lo_rs[$i]['matcodext'],
																	'docpostxt'=>$lo_rs[$i]['mattxt'],
																	'docposqty'=>round($lo_rs[$i]['matqtyrst'],2),
																	'docposuntcod'=>$lo_rs[$i]['matuntcod'],
																	'docposatr'=>array(
																		'matcod'=>$lo_rs[$i]['matcod'],
																		'matcodext'=>$lo_rs[$i]['matcodext'],
																		'mattxt'=>$lo_rs[$i]['mattxt'],
																		'matuntcod'=>$lo_rs[$i]['matuntcod'],
																		'matusebch'=>$lo_rs[$i]['matusebch'],
																		'matuseser'=>$lo_rs[$i]['matuseser'],
																		'matprc'=>$lo_rs[$i]['matprc']
																		),
																	'docposatrtxt'=>$this->co_reg->document->getTagValue($lo_rs[$i]['slsordmatatr'], 'slsordmatslstxt')
																	);
							}
						}						
						break;
					
					
					
					case 'SLS_INV': case 'SLS_CRE': case 'SLS_DEB':
						// obtengo los datos de posición
						$lo_datmdl = $this->co_reg->load->model('slsinvmat');
						$lv_prm = array('vewfldflt'=>'[~fltrow~]o.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocclscod'].chr(9).chr(9).
																				($lo_post['docfndcod']!=''?'[~fltrow~]o.slsinvcod'.chr(9).'='.chr(9).chr(9).$lo_post['docfndcod'].chr(9).chr(9):'').
																				($lo_post['docfndcodext']!=''?'[~fltrow~]o.slsinvcodext'.chr(9).'='.chr(9).chr(9).$lo_post['docfndcodext'].chr(9).chr(9):'').
																				'[~fltrow~]o.slsinvdte'.chr(9).'BT'.chr(9).chr(9).$lv_strdte.chr(9).$lv_enddte.chr(9).
																				($lo_post['fndobjtyp']!=''?'[~fltrow~]o.dstobjtyp'.chr(9).'='.chr(9).chr(9).$lo_post['fndobjtyp'].chr(9).chr(9):'').
																				($lo_post['fndobjcod']!=''?'[~fltrow~]o.dstobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['fndobjcod'].chr(9).chr(9):'').
																				'[~fltrow~]isnull(o.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]isnull(om.sysdocrejcod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																				'[~fltrow~]o.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9),
														'vewfldord'=>'om.slsinvcod, om.slsinvmatcod'
														);
						$lo_rs = $lo_datmdl->getList( $lv_prm );
						
						// para cada posición del documento resto las referencias existentes
						$lo_ret = array();
						for($i=0; $i<count($lo_rs); $i++) {
							$lo_rs[$i]['matqtyrst'] = ($lo_rs[$i]['refposqty']==null?$lo_rs[$i]['matqty']:$lo_rs[$i]['refposqty']);
							
							// si existe en el documento actual 
							// (documento en el que se hizo ya una referencia pero que todavía no se grabó)
							// descuento esas cantidades
							foreach( $lo_refarr as $lv_rowref ) {
								if ( $lv_rowref['srcobjtyp']=$lv_objtyp && $lo_rs[$i]['slsinvcod']==$lv_rowref['srcobjcod'] && $lo_rs[$i]['slsinvmatcod']==$lv_rowref['srcposcod'] ) {
									$lo_rs[$i]['matqtyrst'] -= $lv_rowref['refposqty'];
								}
							}
							
							// solo se puede referenciar a la posición si existen saldos pendientes
							if ($lo_rs[$i]['matqtyrst']>0) {
								$lo_ret[] = array('doctyp'=>$lv_objtyp,
																	'doccod'=>$lo_rs[$i]['slsinvcod'],
																	'docdte'=>$lo_rs[$i]['slsinvdtecnv'],
																	'doccodext'=>$lo_rs[$i]['slsinvcodext'],
																	'docatr'=>'', 
																	'docposcod'=>$lo_rs[$i]['slsinvmatcod'],
																	'docposcodext'=>$lo_rs[$i]['matcodext'],
																	'docpostxt'=>$lo_rs[$i]['mattxt'],
																	'docposqty'=>round($lo_rs[$i]['matqtyrst'],2),
																	'docposuntcod'=>$lo_rs[$i]['matuntcod'],
																	'docposatr'=>array(
																		'matcod'=>$lo_rs[$i]['matcod'],
																		'matcodext'=>$lo_rs[$i]['matcodext'],
																		'mattxt'=>$lo_rs[$i]['mattxt'],
																		'matuntcod'=>$lo_rs[$i]['matuntcod'],
																		'matusebch'=>$lo_rs[$i]['matusebch'],
																		'matuseser'=>$lo_rs[$i]['matuseser'],
																		'matprc'=>$lo_rs[$i]['matprc']
																		),
																	'docposatrtxt'=>$this->co_reg->document->getTagValue($lo_rs[$i]['slsinvmatatr'], 'slsinvmatslstxt')
																	);
							}
						}						
						break;
					
					
					
					// EDUCACION - LIQUIDACION - CLIENTES
					case 'EDU_LQC':
						// obtengo los datos de las liquidaciones
						$lo_datmdl = $this->co_reg->load->model('edulqd');
						$lv_prm = array('vewfldflt'=>'[~fltrow~]l.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocclscod'].chr(9).chr(9).
																				($lo_post['docfndcod']!=''?'[~fltrow~]l.edulqdcod'.chr(9).'='.chr(9).chr(9).$lo_post['docfndcod'].chr(9).chr(9):'').						
																				'[~fltrow~]l.edulqddte'.chr(9).'BT'.chr(9).chr(9).$lv_strdte.chr(9).$lv_enddte.chr(9).
																				($lo_post['fndobjtyp']=='SLS_CUS'?'[~fltrow~]l.cuscod'.chr(9).'='.chr(9).chr(9).$lo_post['fndobjcod'].chr(9).chr(9):'').
																				($lo_post['fndobjtyp']!='SLS_CUS'?'[~fltrow~]1'.chr(9).'='.chr(9).chr(9).'2'.chr(9).chr(9):'').
																				'[~fltrow~]l.docsts'.chr(9).'='.chr(9).chr(9).'C'.chr(9).chr(9),
														'vewfldord'=>'l.edulqdcod'
														);
						$lo_rs = $lo_datmdl->getList( $lv_prm, null, null, false );
						
						$lo_matmdl = $this->co_reg->load->model('stkmat');
						$lo_matmdl->load( array('matcod'=>$this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr,'edulqdstkmat')), false );

						// para cada posición del documento resto las referencias existentes
						$lo_ret = array();
						for($i=0; $i<count($lo_rs); $i++) {
							$lo_rs[$i]['matqtyrst'] = (!isset($lo_rs[$i]['refposqty'])?1:$lo_rs[$i]['refposqty']);
							
							// si existe en el documento actual 
							// (documento en el que se hizo ya una referencia pero que todavía no se grabó)
							// descuento esas cantidades
							foreach( $lo_refarr as $lv_rowref ) {
								if ( $lv_rowref['dstobjtyp']=$lv_objtyp && $lo_rs[$i]['edulqdcod']==$lv_rowref['dstobjcod'] ) {
									$lo_rs[$i]['matqtyrst'] -= $lv_rowref['refposqty'];
								}
							}
							
							// solo se puede referenciar a la posición si existen saldos pendientes
							if ($lo_rs[$i]['matqtyrst']>0) {
								$lo_ret[] = array('doctyp'=>$lv_objtyp,
																	'doccod'=>$lo_rs[$i]['edulqdcod'],
																	'docdte'=>$lo_rs[$i]['edulqddtecnv'],
																	'doccodext'=>'',
																	'docatr'=>'', 
																	'docposcod'=>$lo_matmdl->matcod,
																	'docposcodext'=>$lo_matmdl->matcodext,
																	'docpostxt'=>$lo_rs[$i]['edulqdtxt'],
																	'docposqty'=>round($lo_rs[$i]['matqtyrst'],2),
																	'docposuntcod'=>$lo_matmdl->matuntcod,
																	'docposatr'=>array(
																		'matcod'=>$lo_matmdl->matcod,
																		'matcodext'=>$lo_matmdl->matcodext,
																		'mattxt'=>$lo_matmdl->mattxt,
																		'matuntcod'=>$lo_matmdl->matuntcod,
																		'matusebch'=>$lo_matmdl->matusebch,
																		'matuseser'=>$lo_matmdl->matuseser,
																		'matprc'=>$lo_rs[$i]['edulqdtot']
																		),
																	'docposatrtxt'=>''
																	);
							}
						}
						break;

					// VENTAS - SERVICIOS - LIQUIDACION
					case 'SLS_SVL':
						// obtengo los datos de las liquidaciones
						$lo_datmdl = $this->co_reg->load->model('slssvclqd');
						$lv_prm = array('vewfldflt'=>'[~fltrow~]l.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocclscod'].chr(9).chr(9).
																				($lo_post['docfndcod']!=''?'[~fltrow~]l.slssvclqdcod'.chr(9).'='.chr(9).chr(9).$lo_post['docfndcod'].chr(9).chr(9):'').					
																				'[~fltrow~]l.slssvclqddte'.chr(9).'BT'.chr(9).chr(9).$lv_strdte.chr(9).$lv_enddte.chr(9).
																				($lo_post['fndobjtyp']=='SLS_CUS'?'[~fltrow~]l.cuscod'.chr(9).'='.chr(9).chr(9).$lo_post['fndobjcod'].chr(9).chr(9):'').
																				($lo_post['fndobjtyp']!='SLS_CUS'?'[~fltrow~]1'.chr(9).'='.chr(9).chr(9).'2'.chr(9).chr(9):'').
																				'[~fltrow~]l.docsts'.chr(9).'='.chr(9).chr(9).'C'.chr(9).chr(9),
														'vewfldord'=>'l.slssvclqdcod'
														);
						$lo_rs = $lo_datmdl->getList( $lv_prm, null, null, false );
						
						$lo_matmdl = $this->co_reg->load->model('stkmat');
						$lo_matmdl->load( array('matcod'=>$this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr,'slssvclqdstkmat')), false );

						// para cada posición del documento resto las referencias existentes
						$lo_ret = array();
						for($i=0; $i<count($lo_rs); $i++) {
							$lo_rs[$i]['matqtyrst'] = (!isset($lo_rs[$i]['refposqty'])?1:$lo_rs[$i]['refposqty']);
							
							// si existe en el documento actual 
							// (documento en el que se hizo ya una referencia pero que todavía no se grabó)
							// descuento esas cantidades
							foreach( $lo_refarr as $lv_rowref ) {
								if ( $lv_rowref['dstobjtyp']=$lv_objtyp && $lo_rs[$i]['edulqdcod']==$lv_rowref['dstobjcod'] ) {
									$lo_rs[$i]['matqtyrst'] -= $lv_rowref['refposqty'];
								}
							}
							
							// solo se puede referenciar a la posición si existen saldos pendientes
							if ($lo_rs[$i]['matqtyrst']>0) {
								$lo_ret[] = array('doctyp'=>$lv_objtyp,
																	'doccod'=>$lo_rs[$i]['slssvclqdcod'],
																	'docdte'=>$lo_rs[$i]['slssvclqddtecnv'],
																	'doccodext'=>'',
																	'docatr'=>'', 
																	'docposcod'=>$lo_matmdl->matcod,
																	'docposcodext'=>$lo_matmdl->matcodext,
																	'docpostxt'=>$lo_rs[$i]['slssvclqdtxt'],
																	'docposqty'=>round($lo_rs[$i]['matqtyrst'],2), 
																	'docposuntcod'=>$lo_matmdl->matuntcod,
																	'docposatr'=>array(
																		'matcod'=>$lo_matmdl->matcod,
																		'matcodext'=>$lo_matmdl->matcodext,
																		'mattxt'=>$lo_matmdl->mattxt,
																		'matuntcod'=>$lo_matmdl->matuntcod,
																		'matusebch'=>$lo_matmdl->matusebch,
																		'matuseser'=>$lo_matmdl->matuseser,
																		'matprc'=>$lo_rs[$i]['slssvclqdtot']
																		),
																	'docposatrtxt'=>''
																	);
							}
						}						
						break;
				}
				
				return $this->co_reg->document->getJson( $lo_ret );
				break;				
    }
  }
}
?>
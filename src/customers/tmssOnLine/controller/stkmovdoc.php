<?php  
final class stkmovdocController extends tmssController {
	const CONTROLLER = 'stkmovdoc';
	const MODEL = 'stkmovdoc';
	const VIEW  = 'stkmovdoc';
	const ID = 'stkmovdoccod';
	const OBJTYP ='STK_MOV';
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
    $lo_mdlprm = $this->co_reg->load->model('sysappmdlprm');
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// LIST. lista los documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
				if(!isset($lp_prm['vewfldflt'])){$lp_prm['vewfldflt']='';}
				if(isset($lp_prm['objtyp'])) { $lp_prm['vewfldflt'] .= '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).$lp_prm['objtyp'].chr(9).chr(9); }
				if(isset($lp_prm['stkmovdoclck'])){ $lp_prm['vewfldflt'] .= '[~fltrow~]d.stkmovdoclck'.chr(9).'='.chr(9).chr(9).$lp_prm['stkmovdoclck'].chr(9).chr(9); }
        return $lo_vew->index( '00', $lp_prm );
        break;
			
      // SAVE. graba un documento
      case '#00':
				$lv_objtyp = $lp_prm['mdlcod'] . '_' . $lp_prm['prgcod'];
				$lo_post = $this->co_reg->request->post;
				
        // serializo datos de cabecera y materiales
        $lo_postcnv = $this->serializeDocData( $lo_post );
				// grabo documento
        if ( $this->lo_mdl->save( $lo_postcnv ) ) {
					$lo_post['stkmovdoccod'] = $this->lo_mdl->stkmovdoccod;
					$lo_docref = array();

					// grabo materiales del documento
					$lo_movdoc = $this->co_reg->load->model('stkmovdocmat');
					$lv_buffer = $lo_post['stkmovdocmat'];
					if ($lv_buffer!='') {
						$i=0;
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_movdoc_arr = json_decode($lv_buffer,true);
						foreach( $lv_movdoc_arr as $lv_row ) {
							$lv_row['stkmovdoccod'] = $this->lo_mdl->stkmovdoccod;
							$lv_row['docsts'] = 'A';
							$lv_errmat = json_encode(['matcod' => $lv_row['matcod']]);
							if ( isset($lv_row['deleted']) ) {
								if ($lo_movdoc->delete( $lv_row )==false) {
				          return $this->co_reg->document->getJson( array('errtyp'=>$lo_movdoc->errtyp,'errcod'=>$lo_movdoc->errcod,'errtxt'=>$lo_movdoc->errtxt,'row'=>$i,'errmat'=>$lv_errmat) );
								}
							} else if ($lo_movdoc->save( $lv_row )==false) {
                var_dump($lo_movdoc->getsysdata("sqlstm"));
			          return $this->co_reg->document->getJson( array('errtyp'=>$lo_movdoc->errtyp,'errcod'=>$lo_movdoc->errcod,'errtxt'=>$lo_movdoc->errtxt,'row'=>$i,'errmat'=>$lv_errmat) );
              }

							// recopilo los documentos relacionados
							if( (isset($lv_row['docreftyp'])?$lv_row['docreftyp']:'')!='' ) {
								if (!isset($lo_docref[$lv_row['docreftyp']])) { $lo_docref[$lv_row['docreftyp']] = ''; }
								if(stripos($lo_docref[$lv_row['docreftyp']].';',';'.$lv_row['docrefcod'].';')==false ) {
									$lo_docref[$lv_row['docreftyp']] .= ($lo_docref[$lv_row['docreftyp']]==''?'':';').$lv_row['docrefcod'];
								}
							}
							$i++;
						}
					}

					// cargo documento
					$this->lo_mdl->load( array(	'stkmovdoccod'=>$this->lo_mdl->stkmovdoccod	) );

					// cargo clase de documento
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}

					// asigno par�metros adicionales
					$this->lo_mdl->mdlcod = $lp_prm['mdlcod'];
					$this->lo_mdl->prgcod = $lp_prm['prgcod'];
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt, 'errmat'=>$this->lo_mdl->errmat) );
        }
        break;



      // NEW
      case '#01':
				$lo_post = $this->co_reg->request->post;
				$lv_objtyp = (isset($lp_prm['mdlcod'])?$lp_prm['mdlcod']:$lo_post['mdlcod']) . '_' . (isset($lp_prm['prgcod'])?$lp_prm['prgcod']:$lo_post['prgcod']);
				$this->lo_mdl->create( $lo_post );

				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indic�
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).((isset($lp_prm['mdlcod']) && isset($lp_prm['prgcod']))?$lp_prm['mdlcod'].'_'.$lp_prm['prgcod']:self::OBJTYP).chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
            return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01&prm_mdlcod='.$lp_prm['mdlcod'].'&prm_prgcod='.$lp_prm['prgcod'],'doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */

				// asigno par�metros adicionales
				$this->lo_mdl->mdlcod = (isset($lp_prm['mdlcod'])?$lp_prm['mdlcod']:$lo_post['mdlcod']);
				$this->lo_mdl->prgcod = (isset($lp_prm['prgcod'])?$lp_prm['prgcod']:$lo_post['prgcod']);
        
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
				break;



      // CHANGE - DISPLAY - COPY
      case '#02': case '#03': case '#001':
				$lv_objtyp = $lp_prm['mdlcod'] . '_' . $lp_prm['prgcod'];
				$lv_key = array();
				// get param (KEY)
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID]) );
				// load object
				if ( !isset($lv_key[self::ID]) ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );          
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->stkmovdoccod = '';
					$this->lo_mdl->docsts = 'A';
					$lo_rs = $this->lo_mdl->stkmovdocmat;
					$lo_new_rs = array();
					for($i=0; $i<count($lo_rs); $i++) {
						if ( ($lo_rs[$i]['docreftyp']??'') == '' ) {
							$lo_rs[$i]['stkmovdocmatcod']='';
							$lo_rs[$i]['docreftyp']='';
							$lo_rs[$i]['docrefcod']='';
							$lo_rs[$i]['docrefposcod']='';
							$lo_rs[$i]['refposqty']='';
							$lo_new_rs[] = $lo_rs[$i];
						}
					}
					$this->lo_mdl->stkmovdocmat = $lo_new_rs;
					$this->lo_mdl->sysdoctrecod = '';
					$this->lo_mdl->ctedte = '';
					$this->lo_mdl->cteusr = '';
					$this->lo_mdl->upddte = '';
					$this->lo_mdl->updusr = '';
				}

				// cargo clase de documento
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				}

				// asigno par�metros adicionales
				$this->lo_mdl->mdlcod=$lp_prm['mdlcod'];
				$this->lo_mdl->prgcod=$lp_prm['prgcod'];
        
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );        
        break;
			
			
			// DELETE. borra un documento de movimiento de stock.
      case '#04':
        $this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// ACCOUNTING. contabiliza un movimiento de stock.
      case '#09':
				$lo_post = $this->co_reg->request->post;
				$this->lo_mdl->accounting( $lo_post );
	 			return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt,'errmat'=>$this->lo_mdl->errmat,'dochdr'=>$lo_post,'docpos'=>array()) );
        break;
			
			
      // MOV POPUP. muestra un documento en una ventana resumida/popup
      case '#23':
				$lv_key = array();
				// get param (KEY)
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $this->co_reg->request->post[self::ID]) );
				// load object
				if ( !isset($lv_key[self::ID]) ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				}
        return $this->co_reg->document->getView( 'stkmovdocpop', array('data' => $this->lo_mdl,'objtyp' => self::OBJTYP,'actcod' => $this->data['actcod']) );
        break;
			
			
			// SHOW CALENDAR. muestra un calendario de movimientos
			case '#28':
        return $this->co_reg->document->getView( 'stkmovcal', array('data'=>$this->lo_mdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
				break;


			// GET CALENDAR INFO. devuelve los eventos de un calendario de movimientos de stock
			case '#29':
				$lv_strdte = $this->co_reg->request->post['start'];
				$lv_enddte = $this->co_reg->request->post['end'];
				$lv_srcobjtyp = $this->co_reg->request->post['srcobjtyp'];
				$lv_srcobjcod = $this->co_reg->request->post['srcobjcod'];
				$lv_srcobjtxt = $this->co_reg->request->post['srcobjtxt'];
				$lv_dstobjtyp = $this->co_reg->request->post['dstobjtyp'];
				$lv_dstobjcod = $this->co_reg->request->post['dstobjcod'];
				$lv_dstobjtxt = $this->co_reg->request->post['dstobjtxt'];
				$lv_prm = array('vewfldflt' =>'[~fltrow~]d.stkmovdocdte'.chr(9).'BT'.chr(9).chr(9).$lv_strdte.chr(9).$lv_enddte.chr(9).
																			($lv_srcobjtyp!=''?'[~fltrow~]d.srcobjtyp'.chr(9).'='.chr(9).chr(9).$lv_srcobjtyp.chr(9).chr(9):'').
																			($lv_srcobjcod!=''?'[~fltrow~]d.srcobjcod'.chr(9).'='.chr(9).chr(9).$lv_srcobjcod.chr(9).chr(9):'').
																			($lv_srcobjtxt!=''?'[~fltrow~]srcobjtxt'.chr(9).''.chr(9).$lv_srcobjtxt.chr(9).chr(9).chr(9):'').
																			($lv_dstobjtyp!=''?'[~fltrow~]d.dstobjtyp'.chr(9).'='.chr(9).chr(9).$lv_dstobjtyp.chr(9).chr(9):'').
																			($lv_dstobjcod!=''?'[~fltrow~]d.dstobjcod'.chr(9).'='.chr(9).chr(9).$lv_dstobjcod.chr(9).chr(9):'').
																			($lv_dstobjtxt!=''?'[~fltrow~]dstobjtxt'.chr(9).''.chr(9).$lv_dstobjtxt.chr(9).chr(9).chr(9):'')
																			);
				$lo_rs = $this->lo_mdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
				$lo_data = array();
				foreach( $lo_rs as $lv_row ) {
					$lo_data[] = array('start'=>date_format($lv_row['stkmovdocdte'],'Y-m-d'), 'title'=>$lv_row['sysdocclstxt'].' - '.$lv_row['stkmovdoccod'], 'link'=>'?prg=stkmovdoc&act=23&prm_stkmovdoccod='.$lv_row['stkmovdoccod'], 'id'=>$lv_row['stkmovdoccod']);
				}
				return $this->co_reg->document->getJson( $lo_data );
				break;



			// SHOW ROUTE (2 POINTS)
			// devuelve la ruta entre dos puntos de un movimiento (origen y destino)
			case '#33':
				$lv_srcadrsrctyp = (isset($this->co_reg->request->post['srcadrsrctyp'])?$this->co_reg->request->post['srcadrsrctyp']:'');
				$lv_srcadrsrccod = (isset($this->co_reg->request->post['srcadrsrccod'])?$this->co_reg->request->post['srcadrsrccod']:'');
				$lv_dstadrsrctyp = (isset($this->co_reg->request->post['dstadrsrctyp'])?$this->co_reg->request->post['dstadrsrctyp']:'');
				$lv_dstadrsrccod = (isset($this->co_reg->request->post['dstadrsrccod'])?$this->co_reg->request->post['dstadrsrccod']:'');
				if ($lv_srcadrsrctyp=='' || $lv_srcadrsrccod=='' || $lv_dstadrsrctyp=='' || $lv_dstadrsrccod=='' ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se puede mostrar la ruta sin seleccionar origen y destino.') );
        }

				// ORIGEN
				$lo_adrmdl = $this->co_reg->load->model('grldatadr');
				if ( $lo_adrmdl->load( array('adrsrctyp'=>$lv_srcadrsrctyp,'adrsrccod'=>$lv_srcadrsrccod) )==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-11,'errtxt'=>'No se pudo cargar la direccion de origen.') );
				} else if ( $lo_adrmdl->adrmapgeo=='' ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-12,'errtxt'=>'La direccion de origen no esta geolocalizada.') );
				} else {
					$lv_srcadrmapgeo = $lo_adrmdl->adrmapgeo;
				}

				// DESTINO
				if ( $lo_adrmdl->load( array('adrsrctyp'=>$lv_dstadrsrctyp,'adrsrccod'=>$lv_dstadrsrccod) )==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-21,'errtxt'=>'No se pudo cargar la direccion de destino.') );
				} else if ( $lo_adrmdl->adrmapgeo=='' ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-22,'errtxt'=>'La direccion de destino no esta geolocalizada.') );
				} else {
					$lv_dstadrmapgeo = $lo_adrmdl->adrmapgeo;
				}

        return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'','mapurl'=>'https://www.google.com.ar/maps/dir/?api=1&origin='.$lv_srcadrmapgeo.'&destination='.$lv_dstadrmapgeo.'&travelmode=driving') );
				break;
			
			
			// CONFIRMAR. confirma la recepción o no de un documento
			case '#47':
				$lo_post = $this->co_reg->request->post;
				$lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'','hdr'=>array(),'pos'=>array());
				// confirma recepción/entrega
        if ( $this->lo_mdl->confirm( $lo_post )==false ) {
          $lv_ret['errtyp'] = 'E';
					$lv_ret['errcod'] = $this->lo_mdl->errcod;
					$lv_ret['errtxt'] = $this->lo_mdl->errtxt;
        }
				// envio respuesta
        return $this->co_reg->document->getJson( $lv_ret );
				break;


			// VER CONFIRMACION. devuelve la vista de confirmación.
			case '#48':
				// obtengo lista de documentos relevantes para confirmaci�n
				$lv_docmdl = $this->co_reg->load->model('sysdoccls');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_rs = $lv_docmdl->getList( $lv_prm );
				// devuelve vista
				return $this->co_reg->document->getView( 'stkmovdoccnf', array('data'=>$this->lo_mdl,'doclst'=>$lo_rs,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
				break;
			
			
			// BUSCAR CONFIRMACION. devuelve la lista de documentos con sus estados de confirmación
			case '#49':
				$lo_dat = $this->co_reg->request->post;
				$lv_prm = array('vewfldflt' =>'[~fltrow~]d.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_dat['fnddoccls'].chr(9).chr(9).
																			($lo_dat['fnddoccod']!=''?'[~fltrow~]d.stkmovdoccod'.chr(9).'='.chr(9).chr(9).$lo_dat['fnddoccod'].chr(9).chr(9):'').
                        							($lo_dat['fndcodext']!=''?'[~fltrow~]d.stkmovdoccodext'.chr(9).'='.chr(9).chr(9).$lo_dat['fndcodext'].chr(9).chr(9):'').
																			'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'C'.chr(9).chr(9).
																			($lo_dat['fnddoccnf']=='0'?'[~fltrow~]isnull(d.stkmovdoccnf,^X^)'.chr(9).'='.chr(9).chr(9).'X'.chr(9).chr(9):'').
																			($lo_dat['fnddoccnf']=='1'?'[~fltrow~]isnull(d.stkmovdoccnf,^X^)'.chr(9).'<>'.chr(9).chr(9).'X'.chr(9).chr(9):''),
												'vewmaxrec' => (isset($lo_dat['fnddocmax'])?$lo_dat['fnddocmax']:'100')
											);
				$lo_rs = $this->lo_mdl->getList( $lv_prm, null, null, false );
				// preparo el array de salida
				$lo_data = array();
				foreach($lo_rs as $lv_row) {
					$lo_data[] = array('stkmovdoccod'=>$lv_row['stkmovdoccod'], 'fndcodext'=>$lv_row['stkmovdoccodext'], 'stkmovdoccnf'=>$lv_row['stkmovdoccnf'],'stkmovdocdtecnv'=>$lv_row['stkmovdocdtecnv']);
				}
				// envio respuesta.
        return $this->co_reg->document->getJson( $lo_data );
				break;


			// CODIGOS DE BARRA. muestra la vista para picking con codigo de barras
			case '#barcod':
				$lo_post = $this->co_reg->request->post;
				$lo_docmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docmdl->load( array('sysdocclscod'=>$lo_post['sysdocclscod']) );
				$lv_matbuf = html_entity_decode($lo_post['matarr']);
				$lv_matarr = json_decode($lv_matbuf,true);
				return $this->co_reg->document->getView( 'stkmovdocbar', array('matlst'=>$lv_matarr,'doccls'=>$lo_docmdl,'objtyp'=>self::OBJTYP,'actcod'=>$this->data['actcod']) );
				break;
      
			
			
			// IMPRIMIR. Remito/vale de salida-entrada
      case '#delivery_note':
				$lo_post = $this->co_reg->request->post;
				
				// valido id de movimiento
				$lv_stkmovdoccod = ($lo_post['stkmovdoccod']??$lp_prm['stkmovdoccod']??'');
				if($lv_stkmovdoccod==''){
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Debe indicar el número de movimiento.') );
				}

				// MOVIMIENTO. cargo datos de movimiento
				$lo_stkdocmdl = $this->co_reg->load->model('stkmovdoc');
				if( $lo_stkdocmdl->load( array('stkmovdoccod'=>$lv_stkmovdoccod), false )==false ){
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'ID de movimiento ['.$lv_stkmovdoccod.'] inválido.') );
				}
				
				// CLASE DE DOCUMENTO. cargo datos de clase de documento
				$lo_docmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docmdl->load( array('sysdocclscod'=>$lo_stkdocmdl->sysdocclscod) );
        $lo_stkdocmdl->sysdoccls=$lo_docmdl;
				
				// ORIGEN/DESTINO. cargo direccion de retiro/entrega
        if($lo_stkdocmdl->sysdoccls->objtyp=='STK_SOU'){
          $lo_adrmdl = $this->co_reg->load->model('grldatadr');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]a.adrsrctyp '.chr(9).'='.chr(9).chr(9).$lo_stkdocmdl->dstobjtyp.chr(9).chr(9).
                                        '[~fltrow~]a.adrsrccod '.chr(9).'='.chr(9).chr(9).$lo_stkdocmdl->dstobjcod.chr(9).chr(9),
                          'vewmaxrec'=>'1');

        } else {
          $lo_adrmdl = $this->co_reg->load->model('grldatadr');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]a.adrsrctyp '.chr(9).'='.chr(9).chr(9).$lo_stkdocmdl->srcobjtyp.chr(9).chr(9).
                                        '[~fltrow~]a.adrsrccod '.chr(9).'='.chr(9).chr(9).$lo_stkdocmdl->srcobjcod.chr(9).chr(9),
                          'vewmaxrec'=>'1');
        }
        $lo_rs = $lo_adrmdl->getList($lv_prm);
        $lo_stkdocmdl->adr = $lo_rs[0]??null;        
				
				// CONTACTO. cargo datos de contacto
        $lv_cntcod=$lo_stkdocmdl->sysdoccls->objtyp=='STK_SOU'?$lo_stkdocmdl->dstcntcod:$lo_stkdocmdl->srccntcod;
				$lo_datcntmdl = $this->co_reg->load->model('grldatcnt');
				if( $lv_cntcod!='' ){	$lo_datcntmdl->load( array('cntcod'=>$lv_cntcod), false ); }
				$lo_stkdocmdl->cnt=$lo_datcntmdl;
				
        // EMPRESA. cargo datos de la empresa
        $lo_busmdl = $this->co_reg->load->model('admbus');
        $lo_busmdl->load(array('buscod'=>$this->co_reg->sec->buscod),false);
        
				// LOGO. cargo imagen de la empresa
        $lo_grldatuplmdl = $this->co_reg->load->model('grldatupl');
				$lo_grldatuplmdl->getMainPhoto(array('flesrctyp'=>'ADM_BUS','flesrccod'=>$this->co_reg->sec->buscod) );
        $lo_data = $lo_grldatuplmdl->getData();
        if( count($lo_data)>0){
          $lo_grldatuplmdl->load( array('flecod'=>$lo_data[0]['flecod']) );
        } else {
          $lo_grldatuplmdl->create();
        }
        $lo_data = $lo_grldatuplmdl->getData();
        $lo_grldatuplmdl->flecnt = '';
        $lo_grldatuplmdl->fleimg = false;
        if($lo_grldatuplmdl->flecod!=''){
          //Get file content
          $lo_img = $lo_grldatuplmdl->getFileContents( array('flecod'=>$lo_grldatuplmdl->flecod) );
          // Check if file is a valid image
          // Call imagecreatefromstring function wiht '@' operator to disable E_WARNING if the data is not in a recognized format
          if (@imagecreatefromstring($lo_img) !== false) {
            // Image is valid -> return it as base64 encoded string
            $lo_data['flecnt'] = base64_encode($lo_img);
            $lo_data['fleimg'] = true;
          }	
				}
				$lo_stkdocmdl->img=$this->co_reg->document->getJson( $lo_data );
        
        $lv_buffer = 	$this->co_reg->document->getView( 'stkmovdocprn_dlvnte', array('data'=>$lo_stkdocmdl,'bus'=>$lo_busmdl) );
        $this->co_reg->response->addHeader('Content-type:application/pdf'); 
        return $lv_buffer;
				break;
			
			
			
			// IMPRIMIR. Lista de Picking
			case '#picking_list':
				$lo_post = $this->co_reg->request->post;
				
				// valido id de movimiento
				$lv_stkmovdoccod = ($lo_post['stkmovdoccod']??$lp_prm['stkmovdoccod']??'');
				if($lv_stkmovdoccod==''){
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Debe inidcar el número de movimiento.') );
				}

				// cargo datos de movimiento
				$lo_stkdocmdl = $this->co_reg->load->model('stkmovdoc');
				if( $lo_stkdocmdl->load( array('stkmovdoccod'=>$lv_stkmovdoccod), false )==false ){
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'ID de movimiento ['.$lv_stkmovdoccod.'] inválido.') );
				}
				
				// cargo datos de contacto
				$lo_datcntmdl = $this->co_reg->load->model('grldatcnt');
				if( $lo_stkdocmdl->dstcntcod!='' ){
					$lo_datcntmdl->load( array('cntcod'=>$lo_stkdocmdl->dstcntcod), false );
				}
				$lo_stkdocmdl->dstcnt=$lo_datcntmdl;
				
				// Obtengo direccion de entrega
				$lo_adrmdl = $this->co_reg->load->model('grldatadr');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]a.adrsrctyp '.chr(9).'='.chr(9).chr(9).$lo_stkdocmdl->dstobjtyp.chr(9).chr(9).
																			'[~fltrow~]a.adrsrccod '.chr(9).'='.chr(9).chr(9).$lo_stkdocmdl->dstobjcod.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_adrmdl->getList($lv_prm);
				$lo_stkdocmdl->dstadr = $lo_rs[0];

        $lv_buffer = 	$this->co_reg->document->getView( 'stkmovdocprn_pcklst', array('data'=>$lo_stkdocmdl) );
        $this->co_reg->response->addHeader('Content-type:application/pdf'); 
        return $lv_buffer;
				break;
			
			
      // REPORTE. Materiales que reservan stock
      case '#stkblwresrpt':

        // preparo parametros de usuario
        $lv_prmarr = array('mdlcod'=>'STK', 'mdlatrval001'=>'ENABLE_MATERIAL_RESERVATION');
        $lo_prm_rs = $lo_mdlprm->getParameter( $lv_prmarr );
				
        // armo mi sentencia 
        $lv_prm_rs_str = '';
        foreach($lo_prm_rs as $lv_key => $lv_val){
          $lo_prm_rs_arr = explode('_', $lv_val['prmval']);
        	$lv_srcobjtyp = $lo_prm_rs_arr[0].'_'.$lo_prm_rs_arr[1];
        	$lv_srcobjcod = $lo_prm_rs_arr[2];
          $lv_prm_rs_str .= ( $lv_prm_rs_str != '' ? ' or ' : '').' (d.srcobjtyp = ^'.$lv_srcobjtyp.'^ and d.srcobjcod = '.$lv_srcobjcod.') ';
        }

        $lo_stkmat_mdl = $this->co_reg->load->model('stkmovdocmat');
        $lv_prm = array( 'vewfldflt' => '[~fltrow~]'.chr(9).'ZZ'.chr(9).$lv_prm_rs_str.chr(9).chr(9).chr(9).
                        								(isset($lp_prm['vewprm']['vewfldflt']) ? $lp_prm['vewprm']['vewfldflt'] : ''),
                       	 'vewfldord' => (isset($lp_prm['vewprm']['vewfldord']) ? $lp_prm['vewprm']['vewfldord'] : '')
                       );

				$lo_rs = $lo_stkmat_mdl->getList( $lv_prm );
        
        return $lo_rs;
          
        break;
        
        
      // VERIFICACION DE DISPONIBILIDAD. verifico stock disponible para documento
      case '#availabilityCheck':
     		$lo_post = $this->co_reg->request->post;
        // serializo datos de cabecera y materiales
        $lo_data = $this->serializeDocData( $lo_post );
				// obtengo datos de la verificación de disponibilidad
        $lo_rs = $this->lo_mdl->availabilityCheck( $lo_data );
				// muestro vista con detalle de control
      	return $this->co_reg->document->getView( 'stkmovdocstkchk', array('matlst'=>$lo_rs,'data'=>$lo_post,'actcod'=>$this->data['actcod']) );
        break;
    }
  }
	
  
  // SERIALIZACION. Serializo parametros para control de disponibilidad y grabado de documento
  private function serializeDocData( $lp_data = array() ) {
    // Preparo info de lista de materiales y documento de cabecera
    $lv_movdocmat_str = '';
    if ( (isset($lp_data['stkmovdocmat'])?$lp_data['stkmovdocmat']:'')!='' ) {
      $lv_buffer = $lp_data['stkmovdocmat'];
      $lv_buffer = html_entity_decode($lv_buffer);
      $lv_movdocmat_arr = json_decode($lv_buffer,true);

      foreach($lv_movdocmat_arr as $lv_row){
        if( !isset($lv_row['deleted'])  && !empty($lv_row['matcod'])  ){
          $lv_movdocmat_str .= ( $lv_row != '' ? chr(9) : '').'<matcod>'.$lv_row['matcod'].'</matcod>'.
                                                              '<matqty>'.$lv_row['matqty'].'</matqty>'.
                                                              '<matuntcod>'.$lv_row['matuntcod'].'</matuntcod>'.
                                                              '<matbchcod>'.(isset($lv_row['matbchcod'])?$lv_row['matbchcod']:0).'</matbchcod>'.
            																									'<matbchcodext>'.(isset($lv_row['matbchcodext'])?$lv_row['matbchcodext']:'').'</matbchcodext>'.
                                                              '<matsercod>'.(isset($lv_row['matsercod'])?$lv_row['matsercod']:0).'</matsercod>'.
            																									'<matsercodext>'.(isset($lv_row['matsercodext'])?$lv_row['matsercodext']:'').'</matsercodext>';  
        } 
      }         
    	$lp_data['stkmovdocmat'] = $lv_movdocmat_str;
    }
    
    // informacion de movimiento
    $lp_data['stkmovdoc'] = '<sysdocclscod>'.$lp_data['sysdocclscod'].'</sysdocclscod>'.
                            '<srcobjtyp>'.(isset($lp_data['srcobjtyp'])?$lp_data['srcobjtyp']:'').'</srcobjtyp>'.
                            '<srcobjcod>'.(isset($lp_data['srcobjcod'])?$lp_data['srcobjcod']:'').'</srcobjcod>'.
                            '<srccntcod>'.(isset($lp_data['srccntcod'])?$lp_data['srccntcod']:'').'</srccntcod>';   
    
    return $lp_data;
  }
}
?>
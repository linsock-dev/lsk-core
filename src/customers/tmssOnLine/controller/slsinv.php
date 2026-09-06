<?php
final class slsinvController extends tmssController {
	const CONTROLLER = 'slsinv';
	const MODEL = 'slsinv';
	const VIEW  = 'slsinv';
	const ID = 'slsinvcod';
	const OBJTYP ='SLS_INV';
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
		$lo_grltxtmdl = $this->co_reg->load->model('grldattxt');
		$lo_grltxttypmdl = $this->co_reg->load->model('grldattxttyp');
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
			
			// LIST. devuelve grilla con lista de documentos
      case '#': case '#08':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        $lp_prm['model'] = self::MODEL;
				$lv_mdlcod = (isset($lo_post['mdlcod'])?$lo_post['mdlcod']:(isset($lp_prm['mdlcod'])?$lp_prm['mdlcod']:''));
				$lv_prgcod = (isset($lo_post['prgcod'])?$lo_post['prgcod']:(isset($lp_prm['prgcod'])?$lp_prm['prgcod']:''));
				$lv_objtyp = $lv_mdlcod.'_'.$lv_prgcod;
				if(!isset($lp_prm['vewfldflt'])){$lp_prm['vewfldflt']='';}
				$lp_prm['vewfldflt'] .= '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).$lv_objtyp.chr(9).chr(9);
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
      // SAVE. graba el documento
      case '#00':
				$lo_post = $this->co_reg->request->post;		
    		$lo_post['curcod']=(isset($lo_post['curcod']) && $lo_post['curcod']!=''? $lo_post['curcod']:$lo_post['curcoddef']);
				$lv_mdlcod = (isset($lo_post['mdlcod'])?$lo_post['mdlcod']:(isset($lp_prm['mdlcod'])?$lp_prm['mdlcod']:''));
				$lv_prgcod = (isset($lo_post['prgcod'])?$lo_post['prgcod']:(isset($lp_prm['prgcod'])?$lp_prm['prgcod']:''));
				$lv_objtyp = $lv_mdlcod.'_'.$lv_prgcod;
				$lo_matdoc = $this->co_reg->load->model('slsinvmat');
				$lo_prcmdl = $this->co_reg->load->model('grldatprc');

				// DOCUMENTO. grabo documento
        if ( $this->lo_mdl->save( $lo_post ) ) {
          
					// cargo documento
					// $this->lo_mdl->load( array(	'slsinvcod'=>$this->lo_mdl->slsinvcod	) );
          
					$lo_post['slsinvcod'] = $this->lo_mdl->slsinvcod;
					$lo_docref = array();
					
					// POSICIONES. grabo posiciones (materiales)
					$lv_buffer = $lo_post['slsinvmat'];
					if ($lv_buffer!='') {
						$i=0;
						$lv_slsdoc_arr = json_decode(html_entity_decode($lv_buffer),true);
						foreach( $lv_slsdoc_arr as $lv_row ) {
							$lv_row['slsinvcod'] = $this->lo_mdl->slsinvcod;
							$lv_row['slsinvmatatr'] = '<slsinvmatslstxt>'.(isset($lv_row['slsinvmatslstxt'])?utf8_decode($lv_row['slsinvmatslstxt']):'').'</slsinvmatslstxt>';
							$lv_row['curcod'] = $lo_post['curcod'];
							$lv_row['docsts'] = 'A';
							if ( isset($lv_row['deleted']) ) {
								if ($lo_matdoc->delete( $lv_row )==false) {
									return $this->co_reg->document->getJson( array('errtyp'=>$lo_matdoc->errtyp,'errcod'=>$lo_matdoc->errcod,'errtxt'=>$lo_matdoc->errtxt,'row'=>$i) );
								}
							} else if ($lo_matdoc->save( $lv_row )==false) {
								return $this->co_reg->document->getJson( array('errtyp'=>$lo_matdoc->errtyp,'errcod'=>$lo_matdoc->errcod,'errtxt'=>$lo_matdoc->errtxt,'row'=>$i) );
							} else {
								
								// PRECIOS. grabo precios de posiciones
								$lv_buffer = (isset($lv_row['slsinvmatprc']) ? $lv_row['slsinvmatprc'] : '');
								if ($lv_buffer!='') {
									$lv_slsprc_arr = json_decode(html_entity_decode($lv_buffer),true);
									foreach( $lv_slsprc_arr as $lv_row2 ) {
										$lv_row2['srcobjtyp'] = $lv_objtyp;
										$lv_row2['srcobjcod001'] = $this->lo_mdl->slsinvcod;
										$lv_row2['srcobjcod002'] = $lo_matdoc->slsinvmatcod;
										$lv_row2['prcschcod'] = ($lo_post['prcschcod']??'');
                    $lv_row2['prccndacccod'] = ($lv_row2['finacccod']??'');
										$lv_row2['docsts'] = 'A';
										if ($lo_prcmdl->save( $lv_row2 )==false) {
											return $this->co_reg->document->getJson( array('errtyp'=>$lo_prcmdl->errtyp,'errcod'=>$lo_prcmdl->errcod,'errtxt'=>$lo_prcmdl->errtxt,'row'=>$i) );
										}
									}
								}
							}

              $lo_docmdl = $this->co_reg->load->model('slsinv');
							
							// recopilo los documentos relacionados
							if( $lv_row['docreftyp']!='' ) {
								if (!isset($lo_docref[$lv_row['docreftyp']])) { $lo_docref[$lv_row['docreftyp']] = ''; }
								if(stripos($lo_docref[$lv_row['docreftyp']].';',';'.$lv_row['docrefcod'].';')==false ) {
									$lo_docref[$lv_row['docreftyp']] .= ($lo_docref[$lv_row['docreftyp']]==''?'':';').$lv_row['docrefcod'];
								}
							}
							
							$i++;
						}
					}
					
					// actualizo totales del documento
          // si es un documento interno no se actualiza el total
          if (isset($lo_post['prcschcod']) && $lo_post['prcschcod'] != ''){
          	$lo_docmdl->updatePrices( array('slsinvcod'=>$this->lo_mdl->slsinvcod) ); 
          }
          
					// cargo documento
					$this->lo_mdl->load( array(	'slsinvcod'=>$this->lo_mdl->slsinvcod	) );
          
					// cargo clase de documento
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}

					// cargo datos de empresa
					$lo_busmdl = $this->co_reg->load->model('admbus');
					$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
					$this->lo_mdl->curcod = $lo_busmdl->curcod;	// moneda
          
					$this->lo_mdl->bus = $lo_busmdl;
				
					// LOCALIZACION - ARGENTINA -----------------------------------------------------
					if($lo_busmdl->adr->lndcod=='AR') {
						// cargo datos de puntos de venta
						$lo_posmdl = $this->co_reg->load->model('finlocargpos');
						$lv_prm = array('vewfldflt' =>'[~fltrow~]p.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_docclsmdl->sysdocclscod.chr(9).chr(9).
																					'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																					'[~fltrow~]sp.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
													);
						$lo_posrs = $lo_posmdl->getList( $lv_prm, null, null, false);
						$this->lo_mdl->slspos = $lo_posrs;
					} else {
						$this->lo_mdl->slspos = array();
					}
					// ------------------------------------------------------------------------------
					
					// asigno parámetros adicionales
					$this->lo_mdl->mdlcod = $lv_mdlcod;
					$this->lo_mdl->prgcod = $lv_prgcod;
					return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>$lv_objtyp,'actcod'=>$this->data['actcod']) );
        } else {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        } 
        break;			
			
			
      // NEW. devuelve vista en modo creación
      case '#01':
				$lo_post = $this->co_reg->request->post;
				$lv_mdlcod = (isset($lo_post['mdlcod'])?$lo_post['mdlcod']:(isset($lp_prm['mdlcod'])?$lp_prm['mdlcod']:''));
				$lv_prgcod = (isset($lo_post['prgcod'])?$lo_post['prgcod']:(isset($lp_prm['prgcod'])?$lp_prm['prgcod']:''));
				$lv_objtyp = $lv_mdlcod . '_' . $lv_prgcod;
        if ( ($lo_post['tmss_actcod'] ?? '') == '01' ){
          unset($lo_post);
          $lo_post['sysdocclscod'] = $this->co_reg->request->post['sysdocclscod'] ?? '';
        }
				$lo_post['objtyp'] = $lv_objtyp;
        $lo_post['slsinvcod'] = '';
        
        $this->lo_mdl->create( $lo_post );
				/* ------------------------------------------------ */
				/* obtengo clase de documento 											*/
				/* ------------------------------------------------ */
				$lv_docclscod = (isset($lo_post['sysdocclscod'])?$lo_post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9). $lv_objtyp .chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01&prm_mdlcod='.$lv_mdlcod.'&prm_prgcod='.$lv_prgcod,'doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */
				// cargo precios (array vacio)
				$this->lo_mdl->slsinvprc = array();
				
				// cargo datos de empresa
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
				$this->lo_mdl->curcod = $lo_busmdl->curcod;	// moneda
				$this->lo_mdl->bus = $lo_busmdl;
				
				// LOCALIZACION - ARGENTINA -----------------------------------------------------
				if($lo_busmdl->adr->lndcod=='AR') {
					// cargo datos de puntos de venta
					$lo_posmdl = $this->co_reg->load->model('finlocargpos');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_docclsmdl->sysdocclscod.chr(9).chr(9).
																				'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																				'[~fltrow~]sp.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
					$lo_posrs = $lo_posmdl->getList( $lv_prm, null, null, false );
					$this->lo_mdl->slspos = $lo_posrs;
				} else {
					$this->lo_mdl->slspos = array();
				}
				// ------------------------------------------------------------------------------
				
				// asigno parámetros adicionales
				$this->lo_mdl->mdlcod = $lv_mdlcod;
				$this->lo_mdl->prgcod = $lv_prgcod;
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>$lv_objtyp,'actcod'=>$this->data['actcod']) );
				break;
			
			
      // CHANGE - DISPLAY - COPY. devuelve el formulario en modo modificacion o visualizacion
      case '#02': case '#03': case '#001':
				$lo_post = $this->co_reg->request->post;
				$lv_mdlcod = (isset($lo_post['mdlcod'])?$lo_post['mdlcod']:(isset($lp_prm['mdlcod'])?$lp_prm['mdlcod']:''));
				$lv_prgcod = (isset($lo_post['prgcod'])?$lo_post['prgcod']:(isset($lp_prm['prgcod'])?$lp_prm['prgcod']:''));
				$lv_objtyp = $lv_mdlcod.'_'.$lv_prgcod;
				$lv_key = array();
				
				// get param (KEY)																										
				$lv_key = array( self::ID=>(isset($lp_prm[self::ID]) ? $lp_prm[self::ID] : $lo_post[self::ID]) );

				// load object
				if ( !isset($lv_key[self::ID]) ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No se indico parametro ['.self::ID.'].') );
				} else if ( $this->lo_mdl->load($lv_key)==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else if ( $lp_act == '#001' ) {
					$this->lo_mdl->slsinvcod = '';
					$this->lo_mdl->docsts = 'A';
					$lv_dat = $this->lo_mdl->slsinvmat; 
					for($i=0; $i<count($lv_dat); $i++){ 
            // se mantiene el código para saber qué esquema de precios asignarle. Luego, desde la vista, se elimina
						$lv_dat[$i]['docreftyp']=''; 
						$lv_dat[$i]['docrefcod']=''; 
						$lv_dat[$i]['docrefposcod']=''; 
						$lv_dat[$i]['refposqty']=''; 
					} 
					$this->lo_mdl->slsinvmat = $lv_dat;
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
				
				// cargo datos de empresa
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
				$this->lo_mdl->curcod = $lo_busmdl->curcod;	// moneda
				$this->lo_mdl->bus = $lo_busmdl;
				
				// LOCALIZACION - ARGENTINA -----------------------------------------------------
				if($lo_busmdl->adr->lndcod=='AR') {
					// cargo datos de puntos de venta
					$lo_posmdl = $this->co_reg->load->model('finlocargpos');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_docclsmdl->sysdocclscod.chr(9).chr(9).
																				'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																				'[~fltrow~]sp.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
					$lo_posrs = $lo_posmdl->getList( $lv_prm, null, null, false );
					$this->lo_mdl->slspos = $lo_posrs;
				} else {
					$this->lo_mdl->slspos = array();
				}
				// ------------------------------------------------------------------------------
				
				// asigno parámetros adicionales
				$this->lo_mdl->mdlcod=$lv_mdlcod;
				$this->lo_mdl->prgcod=$lv_prgcod;
				return $this->co_reg->document->getView( self::VIEW, array('data'=>$this->lo_mdl,'objtyp'=>$lv_objtyp,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// DELETE. borra el documento
      case '#04':
        $this->lo_mdl->delete();
				return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
			
			
			// ACCOUNTING. contabiliza el documento
      case '#09':
				$lo_post = $this->co_reg->request->post;
				$lv_slsinvcod = $lo_post['slsinvcod'];
				$lo_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'','slsinvcod'=>$lv_slsinvcod);
        if ( $this->lo_mdl->accounting( $lo_post ) ) {          

					// cargo documento
					$this->lo_mdl->load( array('slsinvcod'=>$lv_slsinvcod), false );

					// cargo clase de documento
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) ) ) {
						$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					}

					// cargo datos de empresa
					$lo_busmdl = $this->co_reg->load->model('admbus');
					$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
					$this->lo_mdl->bus = $lo_busmdl;
					$lo_ret['lndcod'] = $lo_busmdl->adr->lndcod;
					
					// LOCALIZACION - ARGENTINA -----------------------------------------------------
					if($lo_busmdl->adr->lndcod=='AR') {
						// cargo datos de punto de venta
						$lo_posmdl = $this->co_reg->load->model('finlocargpos');
						$lv_prm = array('vewfldflt' =>'[~fltrow~]p.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_docclsmdl->sysdocclscod.chr(9).chr(9).
																					'[~fltrow~]p.slsposcod'.chr(9).'='.chr(9).chr(9).$this->lo_mdl->slsposcod .chr(9).chr(9).
																					'[~fltrow~]p.argltrcodext'.chr(9).'='.chr(9).chr(9).$this->lo_mdl->slsinvcodext .chr(9).chr(9).
																					'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																					'[~fltrow~]sp.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
													);
						$lo_posrs = $lo_posmdl->getList( $lv_prm, null, null, false );
						$lo_ret['slspos'] = $lo_posrs;
					}
					// ------------------------------------------------------------------------------
					return $this->co_reg->document->getJson( $lo_ret );
        } else {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        }
        break;			
			
			
			// DESTINATARIO DE FACTURA. determino si tiene destinatario de factura
			case '#getDestinationTax':
				$lo_post = $this->co_reg->request->post;
				
				if( strtoupper($lo_post['dstobjtyp'])=='SLS_CUS'){
					$lo_cusmdl = $this->co_reg->load->model('slscus');
					$lo_cusmdl->load(array('cuscod'=>$lo_post['dstobjcod']), false);
				} else {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Objeto ['.$lo_post['dstobjtyp'].'] no implementado.') );
				}
				
				$lo_cntmdl = $this->co_reg->load->model('grldatcnt');
				$lv_prm = array('vewmaxrec' =>'1',
											'vewfldflt' =>'[~fltrow~]c.CntSrcTyp'.chr(9).'='.chr(9).chr(9).$lo_post['dstobjtyp'] .chr(9).chr(9).
																		'[~fltrow~]c.cntsrccod'.chr(9).'='.chr(9).chr(9).$lo_post['dstobjcod'] .chr(9).chr(9).
																		'[~fltrow~]dbo.GetTagValue(^INVADR^,ct.SysDocClsAtr)'.chr(9).'='.chr(9).chr(9).'X'.chr(9).chr(9).
																		'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																		'[~fltrow~]ct.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
										);
				$lo_rs = $lo_cntmdl->getList( $lv_prm, null, null, false);
				if(count($lo_rs)>0){
					if($lo_rs[0]['cntdsttyp']=='SLS_CUS') {
						$lo_cusmdl->load( array('cuscod'=>$lo_rs[0]['cntdstcod']), false );
						$lo_dstfac = $lo_cusmdl;
					} else {
						$lo_cntmdl->load( array('cntcod'=>$lo_rs[0]['cntcod']), false );
						$lo_dstfac = $lo_cntmdl;
					}
				} else {
					$lo_dstfac = $lo_cusmdl;
				}

				$lo_ret = array('taxcatcod'=>$lo_dstfac->tax->taxcatcod, 'taxcattxt'=>$lo_dstfac->tax->taxcattxt);
				return $this->co_reg->document->getJson( $lo_ret );
				break;
			
			
			// ----------------------------------------------------------------------
			// SHOW DETAIL
			// muestra en pantalla el detalle de una posicion de la factura
			// 	input:
			//		- dochdr (array): datos de cabecera del documento
			//		- docpos (array): datos de posicion del documento
			//		- docposinx (int): nro de posicion
			//		- dochdrprc (array): esquema de precios de cabecera
			//		- docposprc (array): esquemas de precio de todas las posiciones
			//	output:
			//		- (string): vista "slsinvpos"
			// ----------------------------------------------------------------------
      case '#13':
				$lo_post = $this->co_reg->request->post;

				// normalizo los datos recibidos
				$this->lo_mdl->dochdr = (isset($lo_post['dochdr'])?$lo_post['dochdr']:'{}');
				$this->lo_mdl->docpos = (isset($lo_post['docpos'])?$lo_post['docpos']:'{}');
				$this->lo_mdl->docprc = (isset($lo_post['docprc'])?$lo_post['docprc']:'[]');
				$this->lo_mdl->readonly = (isset($lo_post['readonly'])?$lo_post['readonly']:'false');
				
				// obtengo el id de clase de documento
				$lv_dochdr_arr = JSON_decode(html_entity_decode($this->lo_mdl->dochdr),true);
				$lv_docpos_arr = JSON_decode(html_entity_decode($this->lo_mdl->docpos),true);
				$this->lo_mdl->slsinvcod = (isset($lv_dochdr_arr['slsinvcod'])?$lv_dochdr_arr['slsinvcod']:'');
				$this->lo_mdl->slsinvmatcod = (isset($lv_docpos_arr['slsinvmatcod'])?$lv_docpos_arr['slsinvmatcod']:'');
				$this->lo_mdl->slsinvmatslstxt = (isset($lv_docpos_arr['slsinvmatslstxt'])?$lv_docpos_arr['slsinvmatslstxt']:'');
				$this->lo_mdl->sysdocrejcod = (isset($lv_docpos_arr['sysdocrejcod'])?$lv_docpos_arr['sysdocrejcod']:'');
				
				// recupero datos de la clase de documento
				if(!isset($lv_dochdr_arr['sysdocclscod'])){
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Formato de comunicacion invalido. No se declaro [sysdocclscod] en cabecera.') );
				} else {
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					$lo_docclsmdl->load( array('sysdocclscod'=>$lv_dochdr_arr['sysdocclscod']) );
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
					$lv_objtyp = $lo_docclsmdl->objtyp;
				}
				
				// devuelvo la vista
				return $this->co_reg->document->getView( 'slsinvpos', array('data'=>$this->lo_mdl,'objtyp'=>$lv_objtyp,'actcod'=>$this->data['actcod']) );
				break;
			
			
			// CALC
			// calcula el esquema de precios para una posición específica del documento
			// 		input:
			//  		- doc (array): datos de la cabecera del documento
			//  		- docpos (array): datos de la posicion
			//  		- docprc (array): precios de la posicion
			//			- readonly: (string): true-solo lectura / false-editable
			//		output:
			//			- docprc (array): array de precios de posición actualizado
			case '#calc':
				$lo_post = $this->co_reg->request->post;
				$lo_prcctr = $this->co_reg->load->controller('grldatprc');
				$lv_out = array();
				
				// INICIALIZO. obtengo e inicializo las variables
				$lv_dat = array();
				$lv_dat['dochdr'] = json_decode(html_entity_decode((isset($lo_post['dochdr'])?$lo_post['dochdr']:'[]')),true);
				$lv_dat['docpos'] = json_decode(html_entity_decode((isset($lo_post['docpos'])?$lo_post['docpos']:'[]')),true);
				$lv_dat['docprc'] = json_decode(html_entity_decode((isset($lo_post['docprc'])?$lo_post['docprc']:'[]')),true);
				
				// PRECIOS
        if($lv_dat['docprc'] != null){
        	if(count($lv_dat['docprc'])==0 && count($lv_dat['docpos'])!=0){
            // obtengo clase de documento
            $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
            $lo_docclsmdl->load( array('sysdocclscod'=>$lv_dat['dochdr']['sysdocclscod']) );

            // obtengo esquema de precios
            $lo_prcschmdl = $this->co_reg->load->model('grlprcsch');
            $lo_prcschmdl->load( array('prcschcod'=>$this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr,'prcschcod')) );

            // actualizo condicion de precio
            $lv_prc = array();
            $lv_prccndcod = $this->co_reg->document->getTagValue($lo_docclsmdl->sysdocclsatr,'prccndcod');
            foreach($lo_prcschmdl->prcschcnd as $lv_row){
              if ( $lv_row['prccndcod']==$lv_prccndcod ) {
                $lv_row['prccndqty'] = (isset($lv_dat['docpos']['matqty'])?$lv_dat['docpos']['matqty']:0);
                $lv_row['prccnduntcod'] = (isset($lv_dat['docpos']['matuntcod'])?$lv_dat['docpos']['matuntcod']:'');
                $lv_row['prccndval'] = (isset($lv_dat['docpos']['matprc'])?$lv_dat['docpos']['matprc']:0);
                $lv_row['prccndcurcod'] = (isset($lv_dat['dochdr']['curcod'])?$lv_dat['dochdr']['curcod']:'');
                $lv_row['prcchgman'] = '';
                $lv_prc[] = $lv_row;
              }
            }
            $lv_dat['docprc'] = json_encode( $this->co_reg->document->array_utf8_converter($lv_prc) );
          } 
        }
				
				// ORIGEN. recupero datos impositivos de origen
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );
				$lv_dat['docpos']['srcobj'] = array('taxcatcod'=>$lo_busmdl->tax->taxcatcod);
        
        $lv_dat['docpos']['slsinv'] = $lv_dat['dochdr'];
				$lv_dat['docpos']['slsinv']['buscod'] = $this->co_reg->sec->buscod;		
				
				// DESTINO. recupero datos impositivos de destino
				$lv_dat['docpos']['dstobj'] = array('taxcatcod'=>$lv_dat['dochdr']['taxcatcod']);
				
				// MATERIAL. recupero datos impositivos de material
				$lo_matmdl = $this->co_reg->load->model('stkmat');
				if(isset($lv_dat['docpos']['matcod'])){
					$lo_matmdl->load( array('matcod'=>$lv_dat['docpos']['matcod']), false );
					foreach($lo_matmdl->mattax as $lv_row){
						if($lv_row['fintaxtypcat']=='IVA'){ $lv_dat['docpos']['stkmat'] = array('fintaxindcodext'=>$lv_row['fintaxindcodext']); break; }
					}
          $lv_out = $lo_prcctr->calculate($lv_dat);
        }
				
				// RETURN. devuelvo esquema actualizado
				return $this->co_reg->document->getJson( $lv_out );
				break;
    }
  }
}
?>
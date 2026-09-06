<?php
final class zcuau1_hptController extends tmssController {
  const CONTROLLER  = 'zcuau1_hpt';
	const MODEL = 'hltspc';
	const VIEW  = 'zcuau1_hpt';	
	const ID = '';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
   
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
    
  
  // index     
  public function index( $lp_act , $lp_prm = array() ) {

		ini_set('memory_limit', '2048M');
	
    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
		
			// LIST - DASHBOARD
      case '#': case '#08': case '#28':
				$lo_post = $this->co_reg->request->post;
				
				// obtengo ID de ESPECIALIDAD
				$lo_hltspcmdl = $this->co_reg->load->model('hltspc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]spccodext'.chr(9).'='.chr(9).chr(9).'HPT'.chr(9).chr(9).
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rsspc = $lo_hltspcmdl->getList( $lv_prm );
				$this->lo_mdl->spccod = $lo_rsspc[0]['spccod'];
				
				// -- obtengo el ID de DEFINICION del PARAMETRO PRSCOD
				$lo_usrprmmdl = $this->co_reg->load->model('syssecusrprm');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]secusrprmreffld'.chr(9).'='.chr(9).chr(9).'prscod'.chr(9).chr(9), 'vewmaxrec'=>'1');
				$lo_usrprmdef_rs = $lo_usrprmmdl->getDefinitions($lv_prm);
				if ( count($lo_usrprmdef_rs)==0 ) { echo 'No se pudo obtener la definición de parámetros.'; }
				
				// -- obtengo el ID del PRESTADOR desde los parámetros del usuario basado en el ID de definicion del campo PRSCOD
				$lv_prscod = '';
				$lo_hltprsmdl = $this->co_reg->load->model('hltprs');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.prmcod'.chr(9).'='.chr(9).chr(9).$lo_usrprmdef_rs[0]['secusrprmcod'].chr(9).chr(9).
																			'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9)
																			, 'vewmaxrec'=>'1');
				$lo_usrprmprs_rs = $lo_usrprmmdl->getList($lv_prm);
				if ( count($lo_usrprmprs_rs)==0 ) { 
					//echo 'El usuario no tiene asignado el ID de prestador ['.$lo_usrprmdef_rs[0]['secusrprmcod'].'] en los parámetros.';
				} else {
					$this->lo_mdl->prscod = $lo_usrprmprs_rs[0]['prmval'];
					$lv_prm = array('prscod'=>$this->lo_mdl->prscod);
					if ( $lo_hltprsmdl->load( $lv_prm )==false ) { echo 'No se encontró el ID de prestador ['.$this->lo_mdl->prscod.']'; }
					$this->lo_mdl->prscod = $lo_hltprsmdl->prscod;
				}

				if( $lp_act!='#28' ) {
					// muestro la vista
					return 	$this->co_reg->document->getView('zcuau1_hptdsh', array('data'=> $this->lo_mdl, 'actcod'=> $this->data['actcod']));	
				} else {
					
					$lv_fltarr = array();
					if( (isset($lo_post['vewfldflt'])?$lo_post['vewfldflt']:'')!='' ) {
						$lv_flt = explode('[~fltrow~]',$lo_post['vewfldflt']);
						foreach($lv_flt as $lv_row){
							if(stripos($lv_row,'patcod')!==false){ $lv_fltarr['patcod'] = '[~fltrow~]'.$lv_row; }
							if(stripos($lv_row,'pattxt')!==false){ $lv_fltarr['pattxt'] = '[~fltrow~]'.$lv_row; }
							if(stripos($lv_row,'prstxt')!==false){ $lv_fltarr['prstxt'] = '[~fltrow~]'.$lv_row; }
							if(stripos($lv_row,'maxupddte')!==false){ $lv_fltarr['maxupddte'] = '[~fltrow~]'.$lv_row; }
						}
					}
					
					/* obtengo la lista de pacientes según la asignación de roles */
					$lo_patprsrlsmdl = $this->co_reg->load->model('hltpatprsrls');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]a.docsts'.chr(9).'<>'.chr(9).chr(9).'I' .chr(9).chr(9).
																				($this->lo_mdl->prscod!=''?'[~fltrow~]p.prscod'.chr(9).'='.chr(9).chr(9).$this->lo_mdl->prscod .chr(9).chr(9):'').
																				(isset($lv_fltarr['patcod'])?$lv_fltarr['patcod']:'').
																				(isset($lv_fltarr['pattxt'])?$lv_fltarr['pattxt']:'').
																				(isset($lv_fltarr['prstxt'])?$lv_fltarr['prstxt']:'')
													);
					if( stripos((isset($lo_post['vewfldord'])?$lo_post['vewfldord']:''),'patcod')!==false || stripos((isset($lo_post['vewfldord'])?$lo_post['vewfldord']:''),'pattxt')!==false ) {
						$lv_prm['vewfldord'] = $lo_post['vewfldord'];
					}
					$lo_rsrls = $lo_patprsrlsmdl->getList( $lv_prm );
					
					// obtengo lista de evoluciones para el prestador/especialidad
					$lo_patevlmdl = $this->co_reg->load->model('hltpatevl');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evlnum'.chr(9).'='.chr(9).chr(9).'99999'.chr(9).chr(9).
																				'[~fltrow~]e.spccod'.chr(9).'='.chr(9).chr(9).$this->lo_mdl->spccod .chr(9).chr(9).
																				($this->lo_mdl->prscod!=''?'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$this->lo_mdl->prscod .chr(9).chr(9):'').
																				(isset($lv_fltarr['maxupddte'])?$lv_fltarr['maxupddte']:'')
													);
					if( stripos((isset($lo_post['vewfldord'])?$lo_post['vewfldord']:''),'maxupddte')!==false ) {
						$lv_prm['vewfldord'] = str_ireplace('maxupddte','ISNULL(e.upddte,e.ctedte)',$lo_post['vewfldord']);
					}
					$lo_rsevl = $lo_patevlmdl->getList( $lv_prm, null, null, false );
				
					// armo filtro (string), cuento pacientes, cuento prestadores y agrupo prestadores sumando pacientes con ult actualizacion
					$lv_patflt = array();
					$lv_fltbuf = '';
					$lv_prsqty = 0;
					$lv_patqty = 0;
					$lo_patprsrs = array();
					for($i=count($lo_rsrls)-1; $i>=0; $i--) {
						$lv_row = array();
						foreach( $lo_rsevl as $lv_rowevl ) {
							if($lo_rsrls[$i]['patcod']==$lv_rowevl['patcod']){ $lv_row=$lv_rowevl; break; } 
						}
						if(count($lv_row)>0){
							$lv_patflt[] = $lv_row['patcod'];
							$lv_patqty++;
							$lv_maxdte = (isset($lv_row['upddte'])?$lv_row['upddte']:$lv_row['ctedte']);
							if( isset($lo_patprsrs[$lv_row['prscod']]) ) {
								$lo_patprsrs[$lv_row['prscod']]['qty']++;
								if( $lo_patprsrs[$lv_row['prscod']]['maxupddte']<$lv_maxdte ){ $lo_patprsrs[$lv_row['prscod']]['maxupddte'] = $lv_maxdte; }
							} else {
								$lo_patprsrs[$lv_row['prscod']] = array('spccod'=>$lv_row['spccod'],'prscod'=>$lv_row['prscod'],'prstxt'=>$lv_row['prstxt'],'qty'=>1,'maxupddte'=>$lv_maxdte);
								$lv_prsqty++;
							}
						} else {
							// si bien el paciente esta asociado al prestador, se quita del listado debido a que:
							// -- el prestador no lo trata por la especialidad HCC
							// -- no tiene evolución para la especialidad
							unset($lo_rsrls[$i]);
						}
					}				
					$lo_ret = array('patlst'=>$lo_rsrls, 'prslst'=>$lo_patprsrs);					
					$lv_retjsn = json_encode( array('data'=>$this->co_reg->document->array_utf8_converter($lo_ret)));
					if ( json_last_error() == JSON_ERROR_NONE ) {
						$this->co_reg->response->addHeader('Content-type: application/json');
						return $lv_retjsn;
					} else {
						return 'Error ['.json_last_error().']-['.json_last_error_msg().'] en conversión json: ' . implode( ' ***** ' , $lo_rsstuevl );
					}
				}
        break;
			
			
			
			// G R A B A R
			case '#00':
				$lo_post = $this->co_reg->request->post;
        
				// grabo datos de paciente
				$lo_pat = $this->co_reg->load->model('hltpat');
				if ( $lo_pat->save()==false ) {
          return $this->co_reg->document->getJson( array('errcod'=>$lo_pat->errcod, 'errtxt'=>$lo_pat->errtxt) );
				} else {
					$lo_post['patcod'] = $lo_pat->patcod;
				}

				// grabo relación paciente-prestador-rol
				$lo_spc = $this->co_reg->load->model('hltspc');
				$lv_prscod = $lo_post['prscod'];
				$lv_spccod = $lo_post['spccod'];
				if ( $lo_spc->load(array('spccod'=>$lv_spccod))==false ) {
          return $this->co_reg->document->getJson( array('errcod'=>$lo_spc->errcod, 'errtxt'=>$lo_spc->errtxt) );				
				} else {
					$lv_prsrlscod = $this->co_reg->document->getTagValue( html_entity_decode(strtolower($lo_spc->spcatrval001)), 'hltprsrlscod');
					if ( $lv_prsrlscod!='' ) {
						// si lo tiene, agrego relación paciente-prestador-rol
						$lo_patprsrls = $this->co_reg->load->model('hltpatprsrls');
						$lo_patprsrls->setFormData( array('patcod'=>$lo_pat->patcod,'prscod'=>$lv_prscod,'prsrlscod'=>$lv_prsrlscod) );
						if ( $lo_patprsrls->save()==false ) {
              return $this->co_reg->document->getJson( array('errcod'=>$lo_spc->errcod, 'errtxt'=>$lo_spc->errtxt) );												
						}
					}
				}
				
				// grabo una evolución (cabecera)
				$lo_patevl = $this->co_reg->load->model('hltpatevl');
				$lo_post['evldte'] = ($lo_post['evldte']!=''?$lo_post['evldte']:date('d/m/Y'));
				//$lo_post['sysdocclscod'] = $lo_post['evlsysdocclscod'];
        if ( $lo_patevl->save($lo_post, false)===false ) {
          return $this->co_reg->document->getJson( array('errcod'=>$lo_patevl->errcod, 'errtxt'=>$lo_patevl->errtxt) );		
				} else {
					$lo_post['evlcod'] = $lo_patevl->evlcod;
				}
				
				// graba evolución-especialiad (relacionado al registro de cabecera grabado anteriormente)
				$lo_patevlspc = $this->co_reg->load->model('hltpatevlspc');
				//$lo_rs = array();
				$this->setEvlSpcDat($lo_post);
				//$lo_rs = $lo_post;
				if ( $lo_patevlspc->save($lo_post)==false ) {
          return $this->co_reg->document->getJson( array('errcod'=>$lo_patevlspc->errcod, 'errtxt'=>$lo_patevlspc->errtxt) );		
				} else {
					$lo_post['evlspccod'] = $lo_patevlspc->evlspccod;
				}
				
				// grabo seguimiento (patevl - independientes de la evolución de cabecera grabado anteriormente)
				// 0-seguimiento, 1-basal, 2-sem4, 3-fin tto, 4-sem12
				for( $i=0; $i<5; $i++) {
					$lo_rs = array();
					$lo_patevl->create();
					$this->setEvlCompLabDat( $i );
					$lo_rs = $lo_post;
					$lo_rs['evlcod'] = $lo_rs['evlcod'.$i];
					if ($i>0 || ($i==0 && $lo_post['frmevlcomdte0']!='' )) {
						if($i==0) { $lo_rs['evldte']=$lo_post['frmevlcomdte0']; }
						if ( $lo_patevl->save($lo_rs, false)==false ) {
              return $this->co_reg->document->getJson( array('errcod'=>$lo_patevl->errcod, 'errtxt'=>$lo_patevl->errtxt) );		
						} else {
							// se grabó la evolución
						}
					}
				}
				
				// muestro la vista
				return $this->getView( $lo_pat->patcod ); // $this->co_reg->request->post['patcod'];
				break;
				
			
			
			// C R E A R
			case '#01':

				/* ------------------------------------------------ */
				/* obtengo clase de documento (paciente)						*/
				/* ------------------------------------------------ */
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).'HLT_PAT'.chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01', 'doccls'=>$lv_docclsarr) );	
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */

				// obtengo datos del prestador
				$lo_usrprmmdl = $this->co_reg->load->model('syssecusrprm');
				$lo_hltprsmdl = $this->co_reg->load->model('hltprs');
				
				// -- obtengo el ID de definición del parámetro PRSCOD
				$lv_prm = array('vewfldflt' =>'[~fltrow~]secusrprmreffld'.chr(9).'='.chr(9).chr(9).'prscod'.chr(9).chr(9), 'vewmaxrec'=>'1');
				$lo_usrprmdef_rs = $lo_usrprmmdl->getDefinitions($lv_prm);
				if ( count($lo_usrprmdef_rs)==0 ) { echo 'No se pudo obtener la definición de parámetros.'; }
				
				// -- obtengo el ID del prestador desde los parámetros del usuario basado en el ID de definicion del campo PRSCOD
				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.prmcod'.chr(9).'='.chr(9).chr(9).$lo_usrprmdef_rs[0]['secusrprmcod'].chr(9).chr(9).
																			'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9)
																			, 'vewmaxrec'=>'1');
				$lo_usrprmprs_rs = $lo_usrprmmdl->getList($lv_prm);
				if ( count($lo_usrprmprs_rs)==0 ) { 
					//echo 'El usuario no tiene asignado el ID de prestador ['.$lo_usrprmdef_rs[0]['secusrprmcod'].'] en los parámetros.';
				} else {
					// -- obtengo datos maestros del prestador
					$lv_prm = array( 'prscod'=>$lo_usrprmprs_rs[0]['prmval']);
					if ( $lo_hltprsmdl->load( $lv_prm )==false ) { echo 'No se encontró el ID de prestador ['.$lo_usrprmprs_rs[0]['prmval'].'].'; }
					$this->lo_mdl->prscod = $lo_hltprsmdl->prscod;
				}

				// obtengo ID de ESPECIALIDAD
				$lo_hltspcmdl = $this->co_reg->load->model('hltspc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]spccodext'.chr(9).'='.chr(9).chr(9).'HPT'.chr(9).chr(9).
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rsspc = $lo_hltspcmdl->getList( $lv_prm );
				$this->lo_mdl->spccod = $lo_rsspc[0]['spccod'];
				
				// obtengo primer cliente
				$lo_slscusmdl = $this->co_reg->load->model('slscus');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9), 'vewmaxrec'=>'1');
				$lo_slscusmdl_rs = $lo_slscusmdl->getList( $lv_prm, null, null, false );
				if (count($lo_slscusmdl_rs)==0) {
					echo 'No se pudieron cargar los datos de clientes.';
				} else {
					$this->lo_mdl->cuscod = $lo_slscusmdl_rs[0]['cuscod'];
				}

				return $this->getView( ); // $this->co_reg->request->post['patcod'];
				break;
			
			
			
			// M O D I F I C A R   -   V E R
      case '#02': case '#03':
				$lo_post = $this->co_reg->request->post;
				
				$lv_patcod = ( isset($lo_post['patcod']) ? $lo_post['patcod'] : $lp_prm['patcod'] );
				return $this->getView( $lv_patcod );
        break;
			
			
			
			// LISTAR PACIENTES
      case '#09':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
			
			// LISTA de PACIENTES de PRESTADOR / ESPECIALIDAD
      case '#18':
			
				// obtengo evoluciones de prestador/especialidad
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evlnum'.chr(9).'='.chr(9).chr(9).'99999'.chr(9).chr(9).
																			'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$this->co_reg->request->post['prscod'] .chr(9).chr(9).
																			'[~fltrow~]e.spccod'.chr(9).'='.chr(9).chr(9).$this->co_reg->request->post['spccod'] .chr(9).chr(9) );
				$lo_evlrs = $lo_evlmdl->getList( $lv_prm, null, null, false );
			
				// determino fecha ultima actualización
				for($i=0; $i<count($lo_evlrs); $i++) {
					$lo_evlrs[$i]['maxupddte'] = (isset($lo_evlrs[$i]['upddte'])?$lo_evlrs[$i]['upddte']:$lo_evlrs[$i]['ctedte']);
				}
				
				// muestro vista
				return $this->co_reg->document->getView('zcuau1_patprsrls', array( 'data' => $lo_evlrs,	'actcod' => $this->data['actcod'] ) );
				break;
			
			
			
			// LISTA de EVOLUCIONES PARA PACIENTE
      case '#patevl':
				$lo_patevl = $this->co_reg->load->model('hltpatevl');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9). $this->co_reg->request->post['patcod'] .chr(9).chr(9).
																			'[~fltrow~]e.evlnum'.chr(9).'<>'.chr(9).chr(9). '99999' .chr(9).chr(9).
																			'[~fltrow~]e.evlnum'.chr(9).'>='.chr(9).chr(9). '5' .chr(9).chr(9).
																			'[~fltrow~]e.docsts'.chr(9).'<>'.chr(9).chr(9). 'I' .chr(9).chr(9), 
												'vewfldord'=>'e.evlcod' );
				$lo_patevl_rs = $lo_patevl->getList( $lv_prm, null, null, false );
				$lv_retjsn = json_encode( $this->co_reg->document->array_utf8_converter($lo_patevl_rs) );
				if ( json_last_error() == JSON_ERROR_NONE ) {
					$this->co_reg->response->addHeader('Content-type: application/json');
					return $lv_retjsn;
				} else {
					return 'Error ['.json_last_error().']-['.json_last_error_msg().'] en conversión json: ' . implode( ' ***** ' , $lo_patevl_rs );
				}				
				break;
			
			
			
			// LISTA de EVOLUCIONES PARA PACIENTE
      case '#patevldet':
				$lo_patevl = $this->co_reg->load->model('hltpatevl');
				$lo_patevl->load( array('evlcod'=>$this->co_reg->request->post['evlcod']), false );
				$lo_patevl_rs = array( array('evlcod'=>$lo_patevl->evlcod, 'evlevl'=>$lo_patevl->evlevl.$lo_patevl->evlobj) );
				$lv_retjsn = json_encode( $this->co_reg->document->array_utf8_converter($lo_patevl_rs) );
				if ( json_last_error() == JSON_ERROR_NONE ) {
					$this->co_reg->response->addHeader('Content-type: application/json');
					return $lv_retjsn;
				} else {
					return 'Error ['.json_last_error().']-['.json_last_error_msg().'] en conversión json: ' . implode( ' ***** ' , $lo_patevl_rs );
				}				
				break;
				
			
			// LISTA de EVOLUCIONES PARA PACIENTE
      case '#19':
				$lo_patevlspc = $this->co_reg->load->model('hltpatevlspc');
			
				// obtengo evolución-especialidad
				$lv_prm = array('vewfldflt' =>'[~fltrow~]es.evlcod'.chr(9).'='.chr(9).chr(9). $this->co_reg->request->post['evlcod'] .chr(9).chr(9).
																			'[~fltrow~]es.docsts'.chr(9).'<>'.chr(9).chr(9). 'I' .chr(9).chr(9), 
												'vewfldord'=>'es.evlcod, es.evlspccod' );
				$lo_patevlspc_rs = $lo_patevlspc->getList( $lv_prm );
				
				// muestro vista 
				return	$this->co_reg->load->view('zcuau1_patevl', array(	'data' => $lo_patevlspc_rs, 'actcod' => $this->data['actcod']) );
				break;
			
			
			
			// *************************************************************
			//
			// R E P O R T E    G E N E R A L
			//
			// *************************************************************
			case '#r1':

				// cargo modelos
				$lo_adr 			= $this->co_reg->load->model('grldatadr');
				$lo_pat 			= $this->co_reg->load->model('hltpat');
				$lo_patevl 		= $this->co_reg->load->model('hltpatevl');
				$lo_patevlspc = $this->co_reg->load->model('hltpatevlspc');
				$lo_patevlmat = $this->co_reg->load->model('hltpatevlmat');

				// obtengo ID de ESPECIALIDAD
				$lo_hltspcmdl = $this->co_reg->load->model('hltspc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]spccodext'.chr(9).'='.chr(9).chr(9).'HPT'.chr(9).chr(9).
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rsspc = $lo_hltspcmdl->getList( $lv_prm );
				$this->lo_mdl->spccod = $lo_rsspc[0]['spccod'];
				
				// obtengo pacientes
				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.docsts'.chr(9).'<>'.chr(9).chr(9). 'I' .chr(9).chr(9),
												'vewfldord'=>'p.patcod');
				$lo_pat_rs = $lo_pat->getList( $lv_prm );

				// obtengo direcciones
				$lv_prm = array('vewfldflt' =>'[~fltrow~]a.adrsrctyp'.chr(9).'='.chr(9).chr(9). 'HLT_PAT' .chr(9).chr(9),
												'vewfldord'=>'a.adrsrccod');
				$lo_patadr_rs = $lo_adr->getList( $lv_prm );

				// obtengo las evoluciones
				$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evlnum'.chr(9).'='.chr(9).chr(9). '99999' .chr(9).chr(9).
																			'[~fltrow~]e.spccod'.chr(9).'='.chr(9).chr(9). $this->lo_mdl->spccod .chr(9).chr(9),
												'vewfldord'=>'e.patcod');
				$lo_patevl_rs = $lo_patevl->getList( $lv_prm, null, null, false );
				
				// obtengo evolución-especialidad
				$lv_prm = array('vewfldflt' =>'[~fltrow~]es.docsts'.chr(9).'<>'.chr(9).chr(9). 'I' .chr(9).chr(9).
																			'[~fltrow~]es.spccod'.chr(9).'='.chr(9).chr(9). $this->lo_mdl->spccod .chr(9).chr(9),
												'vewfldord'=>'es.evlcod, es.evlspccod' );
				$lo_patevlspc_rs = $lo_patevlspc->getList( $lv_prm );

				// obtengo las evoluciones - períodos
				$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evlnum'.chr(9).'BT'.chr(9).chr(9).'0'.chr(9).'4'.chr(9).
																			'[~fltrow~]e.spccod'.chr(9).'='.chr(9).chr(9). $this->lo_mdl->spccod .chr(9).chr(9),
												'vewfldord'=>'e.patcod');
				$lo_patevlper_rs = $lo_patevl->getList( $lv_prm, null, null, false );

				// obtengo evolucion - ultimo seguimiento
				$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evlnum'.chr(9).'ZZ'.chr(9).'=(select top 1 z.evlnum from hlt_pat_evl z where z.buscod=e.buscod and z.patcod=e.patcod and z.evlnum between 5 and 99998 order by z.evldte desc)'.chr(9).chr(9).chr(9).
																			'[~fltrow~]e.spccod'.chr(9).'='.chr(9).chr(9). $this->lo_mdl->spccod .chr(9).chr(9),
												'vewfldord'=>'e.patcod');
				$lo_patevlperlst_rs = $lo_patevl->getList( $lv_prm, null, null, false );
				
				$lv_cols = array();
			//paciente
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatincprohcc','nme'=>'Inc.En Protocolo');
			//_datos demograficos
				$lv_cols[] = array('mdl'=>'evl','fld'=>'prscod','nme'=>'ID Prestador');
				$lv_cols[] = array('mdl'=>'evl','fld'=>'prstxt','nme'=>'Prestador');
				$lv_cols[] = array('mdl'=>'evl','fld'=>'spccod','nme'=>'ID Especialidad');
				$lv_cols[] = array('mdl'=>'evl','fld'=>'spctxt','nme'=>'Especialidad');
				
				$lv_cols[] = array('mdl'=>'pat','fld'=>'patcod','nme'=>'ID Paciente');
				$lv_cols[] = array('mdl'=>'patadr','fld'=>'adrlstnme','nme'=>'Apellido');
				$lv_cols[] = array('mdl'=>'patadr','fld'=>'adrfrtnme','nme'=>'Nombre');
				$lv_cols[] = array('mdl'=>'pat','fld'=>'patbrndte','nme'=>'F.nacimiento');
				$lv_cols[] = array('mdl'=>'pat','fld'=>'patsex','nme'=>'Sexo', 'typ'=>'patsex');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'patwgt','nme'=>'Peso.kg', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'pathgh','nme'=>'Talla.cm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'patadr','fld'=>'adrcty','nme'=>'Ciudad');
				$lv_cols[] = array('mdl'=>'patadr','fld'=>'lndcod','nme'=>'Pa&iacute;s');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'patmedcov','nme'=>'Cob.Medica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemant001','nme'=>'Antecedentes Ninguno', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemant002','nme'=>'Antecedentes Hipertensi&oacute;n', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemant003','nme'=>'Antecedentes Diabetes Mellitus', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemant004','nme'=>'Antecedentes Enf.Coronaria', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemant005','nme'=>'Antecedentes Epoc', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemant006','nme'=>'Antecedentes Dialisis', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemant007','nme'=>'Antecedentes Enf.Renal men 30', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemant008','nme'=>'Antecedentes Enf.Renal may 30', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemant009','nme'=>'Antecedentes Convulsiones', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemant010','nme'=>'Antecedentes Enf.Vascular', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemtra001','nme'=>'Tplt.Org.Solido Ninguno', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemtra002','nme'=>'Tplt.Org.Solido Hep&aacute;tico', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemtra003','nme'=>'Tplt.Org.Solido Renal', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemtra004','nme'=>'Tplt.Org.Solido Card.Pulmonar', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemcoi001','nme'=>'Coinfecci&oacute;n', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemcoi002','nme'=>'Coinfecci&oacute;n HIV', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemcoihivrec','nme'=>'Coinfecci&oacute;n HIV Ult.Recuento', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemcoihivcar','nme'=>'Coinfecci&oacute;n HIV Ult.Carga', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemcoihivdte','nme'=>'Coinfecci&oacute;n HIV Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemcoi003','nme'=>'Coinfecci&oacute;n HBV', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemcoihbvcar','nme'=>'Coinfecci&oacute;n HBV Ult.Carga', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemcoihbvdte','nme'=>'Coinfecci&oacute;n HBV Fecha');
			//patología
			// _hepatitis C
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohepyth','nme'=>'A&ntilde;o Diagnositco HCV');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohepagu','nme'=>'Hepatitis Aguda');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohepgen','nme'=>'Genotipo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohepvia','nme'=>'Via Infecci&oacute;n');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohepviaotr','nme'=>'V&iacute;a Infecci&oacute;n Otros');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohepviayth','nme'=>'A&ntilde;o Infecci&oacute;n');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptra','nme'=>'Trat.Previo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptrachk01','nme'=>'Trat.Previo - IFN RBV', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptrayth01','nme'=>'Trat.Previo - IFN RBV - A&ntilde;o');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptrachk02','nme'=>'Trat.Previo - PEGIFN RBV', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptrayth02','nme'=>'Trat.Previo - PEGIFN RBV - A&ntilde;o');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptrachk03','nme'=>'Trat.Previo - Boceprevir PEGIFN RBV', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptrayth03','nme'=>'Trat.Previo - Boceprevir PEGIFN RBV - A&ntilde;o');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptrachk04','nme'=>'Trat.Previo - Telaprevir PEGIFN RBV', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptrayth04','nme'=>'Trat.Previo - Telaprevir PEGIFN RBV - A&ntilde;o');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptrachk05','nme'=>'Trat.Previo - Falla AAD', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptrayth05','nme'=>'Trat.Previo - Falla AAD - A&ntilde;o');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptraant001','nme'=>'Trat.Previo - Falla AAD - Sofosbuvir – SOVALDI', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptraant002','nme'=>'Trat.Previo - Falla AAD - Sofosbuvir – PROBIRASE u otro gen&eacute;rico', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptraant003','nme'=>'Trat.Previo - Falla AAD - Sofosbuvir + Ledipasvir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptraant004','nme'=>'Trat.Previo - Falla AAD - Sofosbuvir + Velpatasvir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptraant005','nme'=>'Trat.Previo - Falla AAD - Daclatasvir - DAKLINZA', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptraant006','nme'=>'Trat.Previo - Falla AAD - Daclatasvir - GENERICO', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptraant007','nme'=>'Trat.Previo - Falla AAD - Asunaprevir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptraant008','nme'=>'Trat.Previo - Falla AAD - Simeprevir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptraant009','nme'=>'Trat.Previo - Falla AAD - Paritaprevir/r + Ombitasvir + Dasabuvir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptraant010','nme'=>'Trat.Previo - Falla AAD - Paritaprevir/r + Ombitasvir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptraant011','nme'=>'Trat.Previo - Falla AAD - Grazoprevir/Elbasvir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptraant012','nme'=>'Trat.Previo - Falla AAD - Glecaprevir + Pibrentasvir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoheptraant013','nme'=>'Trat.Previo - Falla AAD - SOF/VEL/VOX', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohepman','nme'=>'Manifest.Hepaticas');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohepman001','nme'=>'Manifest.Hepaticas - Crioglobulinemia', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohepman002','nme'=>'Manifest.Hepaticas - Glomerulopat&iacute;a', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohepman003','nme'=>'Manifest.Hepaticas - Linfoma no Hodgkin', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohepman004','nme'=>'Manifest.Hepaticas - Porfiria cut&aacute;nea tarda', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohepman005','nme'=>'Manifest.Hepaticas - Liquen plano', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohepman006','nme'=>'Manifest.Hepaticas - Otras', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohepman006otr','nme'=>'Manifest.Hepaticas - Otras - Indique');
			// estadío
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoestbiogrd','nme'=>'Estadio - Grado Fibrosis');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoestbioyth','nme'=>'Estadio - A&ntilde;o');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoestbio','nme'=>'Biopsia Hepatica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoestmet','nme'=>'Met.Fisicos No Invasivos');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoestmetmet','nme'=>'Met.Fisicos No Invasivos - M&eacute;todo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoestmetval','nme'=>'Met.Fisicos No Invasivos - Valor kPa', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoestser','nme'=>'Met.Serologicos');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoestserfib','nme'=>'Met.Serologicos - Fibrotest', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoestserapr','nme'=>'Met.Serologicos - APRI', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptoestcrr','nme'=>'Diag.Cl&iacute;nico Cirrosis');
			// Complicaciones Hepáticas Previas al Inicio de AAD
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhep','nme'=>'Complic.Hepaticas');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomlst','nme'=>'En lista de Trasplante');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomant','nme'=>'Antecedentes Ascitis');
				//$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomantevt','nme'=>'Antecedentes Ascitis Indique');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomenc','nme'=>'Antecedentes Encefalopat&iacute;a');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomvar','nme'=>'Antecedentes v&aacute;rices esof&aacute;gicas');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhem','nme'=>'Antecedentes Hemorragia variceal');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomanthpt','nme'=>'Antecedentes Hepatocarcinoma');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhptdtehcc','nme'=>'Fecha Diagnostico HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhptecg','nme'=>'ECOG al diagnostico HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhptnronod','nme'=>'Nro Nodulos HCC', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhptnoddmt','nme'=>'Diam.Nodulo Mayor HCC', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhptlocext001','nme'=>'Loc.extrahep&aacute;tica - No', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhptlocext002','nme'=>'Loc.extrahep&aacute;tica - Invasi&oacute;n Vascular', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhptlocext003','nme'=>'Loc.extrahep&aacute;tica - Ganglionar', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhptlocext004','nme'=>'Loc.extrahep&aacute;tica - Pulmonar', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhptlocext005','nme'=>'Loc.extrahep&aacute;tica - Osea', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhptlocext006','nme'=>'Loc.extrahep&aacute;tica - Otra', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhpttrachk001','nme'=>'1er Trat Realiz HCC - Ablaci&oacute;n por Radiofrecuencia', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhpttrachk002','nme'=>'1er Trat Realiz HCC - Ablaci&oacute;n percut&aacute;nea/quir&uacute;rgico', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhpttrachk003','nme'=>'1er Trat Realiz HCC - Resecci&oacute;n Quir&uacute;rgica', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhpttrachk004','nme'=>'1er Trat Realiz HCC - Evaluado para trasplante / Trasplantado Hep&aacute;tico', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhpttrachk005','nme'=>'1er Trat Realiz HCC - Quimioembolizaci&oacute;n transarterial con Doxorrubicina/Lipiodol convencional', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhpttrachk006','nme'=>'1er Trat Realiz HCC - Quimioembolizaci&oacute;n transarterial con micropart&iacute;culas – DC BEADS', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhpttrachk007','nme'=>'1er Trat Realiz HCC - Radioembolizaci&oacute;n transarterial', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhpttrachk008','nme'=>'1er Trat Realiz HCC - Quimioterapia sist&eacute;mica', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhpttrachk009','nme'=>'1er Trat Realiz HCC - Sorafenib', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhpttrachk010','nme'=>'1er Trat Realiz HCC - Soporte paliativo', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocomhpttrachk011','nme'=>'1er Trat Realiz HCC - Ingreso en protocolo Clínico de Investigaci&oacute;n', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptocompatcur','nme'=>'Paciente Curado');
			// Tratamiento
			// Medicación Actual anti HCV
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedact','nme'=>'Inicio Ttmiento HCV');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedstrdte','nme'=>'Fecha Inicio');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedenddte','nme'=>'Fecha Fin');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedchlpts','nme'=>'Child-Pugh Score pretratamiento - Puntaje', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedchltyp','nme'=>'Child-Pugh Score pretratamiento - Tipo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedchlcrr','nme'=>'Child-Pugh Score pretratamiento - Paciente Cirrotico');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedmldpts','nme'=>'MELD pretratamiento - Puntaje', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedrib','nme'=>'Ribavirina');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedribdss','nme'=>'Ribavirina - Dosis.mg', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedactaad001','nme'=>'Antivirales Acci&oacute;n directa - Ninguno', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedactaad002','nme'=>'Antivirales Acci&oacute;n directa - Sofosbuvir – SOVALDI', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedactaad003','nme'=>'Antivirales Acci&oacute;n directa - Sofosbuvir – PROBIRASE u otro gen&eacute;rico', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedactaad013','nme'=>'Antivirales Acci&oacute;n directa - Sofosbuvir + Ledipasvir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedactaad014','nme'=>'Antivirales Acci&oacute;n directa - Sofosbuvir + Velpatasvir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedactaad005','nme'=>'Antivirales Acci&oacute;n directa - Daclatasvir - DAKLINZA', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedactaad016','nme'=>'Antivirales Acci&oacute;n directa - Daclatasvir - GENERICO', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedactaad007','nme'=>'Antivirales Acci&oacute;n directa - Asunaprevir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedactaad008','nme'=>'Antivirales Acci&oacute;n directa - Simeprevir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedactaad009','nme'=>'Antivirales Acci&oacute;n directa - Paritaprevir/r + Ombitasvir + Dasabuvir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedactaad010','nme'=>'Antivirales Acci&oacute;n directa - Paritaprevir/r + Ombitasvir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedactaad011','nme'=>'Antivirales Acci&oacute;n directa - Grazoprevir/Elbasvir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedactaad012','nme'=>'Antivirales Acci&oacute;n directa - Glecaprevir + Pibrentasvir', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedactaad013','nme'=>'Antivirales Acci&oacute;n directa - SOF/VEL/VOX', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtramedhcv','nme'=>'HCV RNA basal UI.ml', 'typ'=>'number');
			// Eventos Adversos
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt','nme'=>'Presento EEAA');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt001','nme'=>'EEAA - Depresi&oacute;n', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt002','nme'=>'EEAA - Insomnio', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt003','nme'=>'EEAA - Irritabilidad', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt004','nme'=>'EEAA - Fiebre Mayr 38', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt005','nme'=>'EEAA - Artralgias/Mialgias', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt006','nme'=>'EEAA - Astenia', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt007','nme'=>'EEAA - disminuir dosis Ribavirina', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt008','nme'=>'EEAA - Cefalea', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt009','nme'=>'EEAA - Diarrea', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt010','nme'=>'EEAA - N&aacute;useas/V&oacute;mitos', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt011','nme'=>'EEAA - Aumento Bilirrubina', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt012','nme'=>'EEAA - Rash', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt013','nme'=>'EEAA - Prurito', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt014','nme'=>'EEAA - Deterioro funci&oacute;n renal', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraevt014sev','nme'=>'EEAA - Deterioro funci&oacute;n renal - Severidad');
			// evolucion
			// Respuesta al tratamiento
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmevlrestra','nme'=>'Respuesta al Tratamiento');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmevlrestrasusdef','nme'=>'Suspencion Definitiva');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmevlrestrasustra','nme'=>'Suspencion Transitoria');
			// laboratorio
				$lv_cols[] = array('mdl'=>'evlper1','fld'=>'frmevllabbil','nme'=>'Lab Basal Bilirrubina Total', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper1','fld'=>'frmevllabalb','nme'=>'Lab Basal Albumina', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper1','fld'=>'frmevllabrin','nme'=>'Lab Basal RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper1','fld'=>'frmevllabqck','nme'=>'Lab Basal Quick', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper1','fld'=>'frmevllabhem','nme'=>'Lab Basal Hemoglobina', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper1','fld'=>'frmevllableu','nme'=>'Lab Basal Leucocitos', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper1','fld'=>'frmevllabpla','nme'=>'Lab Basal Plaquetas', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper1','fld'=>'frmevllabcre','nme'=>'Lab Basal Creatinina', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper1','fld'=>'frmevllabckd','nme'=>'Lab Basal CKD-EPI');
				$lv_cols[] = array('mdl'=>'evlper1','fld'=>'frmevllabafp','nme'=>'Lab Basal AFP', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper1','fld'=>'frmevllabhcv','nme'=>'Lab Basal HCV RNA', 'typ'=>'number');
			
				$lv_cols[] = array('mdl'=>'evlper2','fld'=>'frmevllabbil','nme'=>'Lab Sem4 Bilirrubina Total', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper2','fld'=>'frmevllabalb','nme'=>'Lab Sem4 Albumina', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper2','fld'=>'frmevllabrin','nme'=>'Lab Sem4 RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper2','fld'=>'frmevllabqck','nme'=>'Lab Sem4 Quick', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper2','fld'=>'frmevllabhem','nme'=>'Lab Sem4 Hemoglobina', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper2','fld'=>'frmevllableu','nme'=>'Lab Sem4 Leucocitos', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper2','fld'=>'frmevllabpla','nme'=>'Lab Sem4 Plaquetas', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper2','fld'=>'frmevllabcre','nme'=>'Lab Sem4 Creatinina', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper2','fld'=>'frmevllabafp','nme'=>'Lab Sem4 AFP', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper2','fld'=>'frmevllabhcv','nme'=>'Lab Sem4 HCV RNA', 'typ'=>'number');
			
				$lv_cols[] = array('mdl'=>'evlper3','fld'=>'frmevllabbil','nme'=>'Lab FinTto Bilirrubina Total', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper3','fld'=>'frmevllabalb','nme'=>'Lab FinTto Albumina', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper3','fld'=>'frmevllabrin','nme'=>'Lab FinTto RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper3','fld'=>'frmevllabqck','nme'=>'Lab FinTto Quick', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper3','fld'=>'frmevllabhem','nme'=>'Lab FinTto Hemoglobina', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper3','fld'=>'frmevllableu','nme'=>'Lab FinTto Leucocitos', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper3','fld'=>'frmevllabpla','nme'=>'Lab FinTto Plaquetas', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper3','fld'=>'frmevllabcre','nme'=>'Lab FinTto Creatinina', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper3','fld'=>'frmevllabafp','nme'=>'Lab FinTto AFP', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper3','fld'=>'frmevllabhcv','nme'=>'Lab FinTto HCV RNA', 'typ'=>'number');
			
				$lv_cols[] = array('mdl'=>'evlper4','fld'=>'frmevllabbil','nme'=>'Lab Sem12 Bilirrubina Total', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper4','fld'=>'frmevllabalb','nme'=>'Lab Sem12 Albumina', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper4','fld'=>'frmevllabrin','nme'=>'Lab Sem12 RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper4','fld'=>'frmevllabqck','nme'=>'Lab Sem12 Quick', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper4','fld'=>'frmevllabhem','nme'=>'Lab Sem12 Hemoglobina', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper4','fld'=>'frmevllableu','nme'=>'Lab Sem12 Leucocitos', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper4','fld'=>'frmevllabpla','nme'=>'Lab Sem12 Plaquetas', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper4','fld'=>'frmevllabcre','nme'=>'Lab Sem12 Creatinina', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper4','fld'=>'frmevllabckd','nme'=>'Lab Sem12 CKD-EPI');
				$lv_cols[] = array('mdl'=>'evlper4','fld'=>'frmevllabafp','nme'=>'Lab Sem12 AFP', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper4','fld'=>'frmevllabhcv','nme'=>'Lab Sem12 HCV RNA', 'typ'=>'number');
				
			// ULTIMO SEGUIMIENTO
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomdte','nme'=>'Fec.Ult.Seguimiento');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcommue','nme'=>'Muerte');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcommuedte','nme'=>'Muerte Fecha');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomtra','nme'=>'Traspl.Hepat.');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomtradte','nme'=>'Traspl.Hepat. Fecha');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomhpt','nme'=>'HCC');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptdtehcc','nme'=>'HCC Fecha Diagnostico');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptscr','nme'=>'HCC Eco.de Screening');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptecg','nme'=>'HCC ECOG');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptdiatom','nme'=>'HCC Diag - Tomografía axial computada', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptdiares','nme'=>'HCC Diag - RMN', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptdiabio','nme'=>'HCC Diag - Biopsia Hep&aacute;tica', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptnod','nme'=>'HCC Nro Nodulos', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptnoddmt','nme'=>'HCC Diam nodulo mayor', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptnodsum','nme'=>'HCC Sum diametro nodulos', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptlstout','nme'=>'HCC Salio lista Tplt Hep');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptloc','nme'=>'HCC Loc hep&aacute;tica');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptlocext001','nme'=>'HCC Loc extrahep&aacute;tica - No', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptlocext002','nme'=>'HCC Loc extrahep&aacute;tica - Invasi&oacute;n Vascular', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptlocext003','nme'=>'HCC Loc extrahep&aacute;tica - Ganglionar', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptlocext004','nme'=>'HCC Loc extrahep&aacute;tica - Pulmonar', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptlocext005','nme'=>'HCC Loc extrahep&aacute;tica - Osea', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhptlocext006','nme'=>'HCC Loc extrahep&aacute;tica - Otra', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhpttrachk001','nme'=>'HCC - Primer Trat p HCC - Ablaci&oacute;n por Radiofrecuencia', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhpttrachk002','nme'=>'HCC - Primer Trat p HCC - Ablaci&oacute;n percut&aacute;nea_quir&uacute;rgico', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhpttrachk003','nme'=>'HCC - Primer Trat p HCC - Resecci&oacute;n Quir&uacute;rgica', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhpttrachk004','nme'=>'HCC - Primer Trat p HCC - Evaluado para trasplante_Trasplantado Hep&aacute;tico', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhpttrachk005','nme'=>'HCC - Primer Trat p HCC - Quimioembolizaci&oacute;n transarterial con Doxorrubicina_Lipiodol convencional', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhpttrachk006','nme'=>'HCC - Primer Trat p HCC - Quimioembolizaci&oacute;n transarterial con micropartículas – DC BEADS', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhpttrachk007','nme'=>'HCC - Primer Trat p HCC - Radioembolizaci&oacute;n transarterial', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhpttrachk008','nme'=>'HCC - Primer Trat p HCC - Quimioterapia sist&eacute;mica', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhpttrachk009','nme'=>'HCC - Primer Trat p HCC - Sorafenib', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhpttrachk010','nme'=>'HCC - Primer Trat p HCC - Soporte paliativo', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhpttrachk011','nme'=>'HCC - Primer Trat p HCC - Ingreso en protocolo Cl&iacute;nico de Investigaci&oacute;n', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcom','nme'=>'Presenta Comp. Hep&aacute;ticas');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomasc','nme'=>'Comp.Hep - Ascitis');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcompbe','nme'=>'Comp.Hep - PBE');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomenc','nme'=>'Comp.Hep - Encelopat&iacute;a');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomsan','nme'=>'Comp.Hep - Sang.Viceral');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomlstout','nme'=>'Comp.Hep - Salio Lista Trasplante');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomcex','nme'=>'Comp.Hep - Complicaciones extrahep&aacute;icas');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomcexdia','nme'=>'Comp.Hep - Comp.Extra - Fecha Diabetes');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomcexcor','nme'=>'Comp.Hep - Comp.Extra - Fecha Enf.Coronaria');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomcexcer','nme'=>'Comp.Hep - Comp.Extra - Fecha Enf.Cerebrovascular');				
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlhpttrachk011','nme'=>'HCC - Primer Trat p HCC - Ingreso en protocolo Cl&iacute;nico de Investigaci&oacute;n');
			// ULT SEG - Evolución de complicaciones hepáticas hasta la semana 12 post-tratamiento
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcom','nme'=>'Comp Hep Ult Seg');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomasc','nme'=>'Comp Hep Ult Seg - Ascitis');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcompbe','nme'=>'Comp Hep Ult Seg - PBE');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomenc','nme'=>'Comp Hep Ult Seg - Encefalopat&iacute;a');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomsan','nme'=>'Comp Hep Ult Seg - Sangrado variceal');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomtra','nme'=>'Comp Hep Ult Seg - Trasplante hep&aacute;tico');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomlstout','nme'=>'Comp Hep Ult Seg - Salio Lsta Tplnte', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomhpt','nme'=>'Comp Hep Ult Seg - HCC');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomhptdte','nme'=>'Comp Hep Ult Seg - HCC Fecha');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomcex','nme'=>'Comp Hep Ult Seg - Comp extrahep&aacute;ticas');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomcexdia','nme'=>'Comp Hep Ult Seg - Comp extrahep&aacute;ticas - Diabetes');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomcexcor','nme'=>'Comp Hep Ult Seg - Comp extrahep&aacute;ticas - Enf Coronaria');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevlcomcexcer','nme'=>'Comp Hep Ult Seg - Comp extrahep&aacute;ticas - Enf Cerebrovascular');
			// ULT SEG - laboratorio
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevllabbil','nme'=>'Lab Ult Seg - Bilirrubina Total', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevllabalb','nme'=>'Lab Ult Seg - Albumina', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevllabrin','nme'=>'Lab Ult Seg - RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevllabqck','nme'=>'Lab Ult Seg - Quick');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevllabhem','nme'=>'Lab Ult Seg - Hemoglobina', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevllableu','nme'=>'Lab Ult Seg - Leucocitos', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevllabpla','nme'=>'Lab Ult Seg - Plaquetas', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevllabcre','nme'=>'Lab Ult Seg - Creatinina', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevllabafp','nme'=>'Lab Ult Seg - AFP', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlper9','fld'=>'frmevllabhcv','nme'=>'Lab Ult Seg - HCV RNA', 'typ'=>'number');
				
				$lv_cols[] = array('mdl'=>'pat','fld'=>'age','nme'=>'Edad');
			
        
				$i = 0;
				$lv_dat = array();
				foreach( $lo_pat_rs as $lv_rowpat ) {
					$lv_dat[$i]['pat'] = '';
					$lv_dat[$i]['patadr'] = '';
					$lv_dat[$i]['evlspc'] = '';
					// datos paciente
					foreach($lv_rowpat as $lv_key=>$lv_val){                  
						$lv_dat[$i]['pat'] .= '<'.$lv_key.'>'.(is_a($lv_val,'DateTime')?$lv_val->format('d/m/Y'):$lv_val).'</'.$lv_key.'>';
          }
					
					// datos paciente - edad
					$lv_age = 0;
					$lv_brndtestr = $this->co_reg->document->getTagValue($lv_dat[$i]['pat'],'patbrndte');
					if($lv_brndtestr!='') {
						$lv_tz  = new DateTimeZone('America/Argentina/Buenos_Aires');
						$lv_age = DateTime::createFromFormat('d/m/Y', $lv_brndtestr, $lv_tz)
								 ->diff(new DateTime('now', $lv_tz))
								 ->y;
					}
					$lv_dat[$i]['pat'] .= '<age>'.$lv_age.'</age>';
					
					// direccion
					foreach( $lo_patadr_rs as $lv_rowpatadr ) {
						if ( $lv_rowpatadr['adrsrccod']==$lv_rowpat['patcod'] ) {
							foreach($lv_rowpatadr as $lv_key=>$lv_val){	
								$lv_dat[$i]['patadr'] .= '<'.$lv_key.'>'.(is_a($lv_val,'DateTime')?$lv_val->format('d/m/Y'):$lv_val).'</'.$lv_key.'>';
							}
							break;
						}
					}
          
					// evoluciones
					foreach( $lo_patevl_rs as $lv_rowevl ) {
						if ( $lv_rowevl['patcod']==$lv_rowpat['patcod'] ) {
							$lv_dat[$i]['evl'] = '<prscod>'.$lv_rowevl['prscod'].'</prscod><prstxt>'.$lv_rowevl['prstxt'].'</prstxt><spccod>'.$lv_rowevl['spccod'].'</spccod><spctxt>'.$lv_rowevl['spctxt'].'</spctxt>'.$lv_rowevl['evlevl'].$lv_rowevl['evlobj'];
							// evolución - especialidad
							foreach( $lo_patevlspc_rs as $lv_rowevlspc ) {
								if ( $lv_rowevlspc['evlcod']==$lv_rowevl['evlcod'] ) {
									$lv_dat[$i]['evlspc'] = $lv_rowevlspc['evlatrval001'].$lv_rowevlspc['evlatrval002'].$lv_rowevlspc['evlatrval003'].$lv_rowevlspc['evlatrval004'].$lv_rowevlspc['evlatrval005'].$lv_rowevlspc['evlatrval006'].$lv_rowevlspc['evlatrval007'].$lv_rowevlspc['evlatrval008'].$lv_rowevlspc['evlatrval009'];
									break;
								}
							}
						}
					}
					// evoluciones - periodo
					$lv_dat[$i]['evlper'] = array();
					// evoluciones
					foreach( $lo_patevlper_rs as $lv_rowevl ) {
						if ( $lv_rowevl['patcod']==$lv_rowpat['patcod'] ) {
							$lv_dat[$i]['evlper'][$lv_rowevl['evlnum']] = array( $lv_rowevl['evlevl'].$lv_rowevl['evlobj'] );
						}
					}					
					// evoluciones - ultimo seguimiento
					foreach( $lo_patevlperlst_rs as $lv_rowevl ) {
						if ( $lv_rowevl['patcod']==$lv_rowpat['patcod'] ) {
							$lv_dat[$i]['evlper']['9'] = array( $lv_rowevl['evlevl'].$lv_rowevl['evlobj'] );
							break;
						}
					}
					$i++;
				}
				
				// muestro datos
				$lv_buffer = '<table style="border: #000000 1px solid;"><thead><tr style="background-color: #f1f1f1; border: #000000 1px solid;">';
				foreach($lv_cols as $lv_row) { $lv_buffer .= '<th>'.$lv_row['nme'].'</th>'; }
				$lv_buffer .= '</tr></thead><tbody>';
				foreach( $lv_dat as $lv_rowdat ) {
					if(isset($lv_rowdat['evl'])){
						$lv_buffer .= '<tr>';
            
						foreach( $lv_cols as $lv_row ) {
              
							// general
							if(substr($lv_row['mdl'],0,6)!='evlper'){

                // cambio formato segun tipo de campo
								$lv_value = $this->checkTyp( $lv_row, $this->co_reg->document->getTagValue($lv_rowdat[$lv_row['mdl']],$lv_row['fld']) );
                
								$lv_buffer .= '<td>'.( isset($lv_rowdat[$lv_row['mdl']]) ? $lv_value : '') .'</td>';
							// laboratorio
							} else {
								$i = substr($lv_row['mdl'],-1);
								if ( isset($lv_rowdat['evlper'][$i]) ) {
									if( ($i==1 || $i==4) && $lv_row['fld']=='frmevllabckd' ) {
										$lv_age = 0;
										$lv_brndtestr = $this->co_reg->document->getTagValue($lv_rowdat['pat'],'patbrndte');
										if($lv_brndtestr!='') {
											$lv_tz  = new DateTimeZone('America/Argentina/Buenos_Aires');
											$lv_age = DateTime::createFromFormat('d/m/Y', $lv_brndtestr, $lv_tz)
													 ->diff(new DateTime('now', $lv_tz))
													 ->y;											
										}
										$lv_sex = strtoupper( $this->co_reg->document->getTagValue($lv_rowdat['pat'],'patsex') );
										$lv_crea = $this->co_reg->document->getTagValue( $lv_rowdat['evlper'][$i][0], 'frmevllabcre');
										$lv_crea_conv = floatval($lv_crea) * 88.42;
										$lv_val = 0;
										if ( $lv_sex!='' && $lv_age!=0 && $lv_crea_conv!=0 ) {
											$lv_val = $lv_val + 141;
											$lv_val = $lv_val * pow( min(array($lv_crea_conv/($lv_sex=='M'?80:62), 1)) , ($lv_sex=='M'?-0.411:-0.329) );
											$lv_val = $lv_val * pow( max(array($lv_crea_conv/($lv_sex=='M'?80:62), 1)) , -1.209 );
											$lv_val = $lv_val * pow( 0.993 , $lv_age );
											$lv_val = $lv_val * ( $lv_sex=='M'? 1 : 1.018 );
											$lv_val = $lv_val * ( $lv_sex=='M'? 1 : 1.159 );
										}
										$lv_buffer .= '<td>'.number_format($lv_val,2).'</td>';
									} else {
                    // cambio formato segun tipo de campo
										$lv_value = $this->checkTyp( $lv_row, $this->co_reg->document->getTagValue($lv_rowdat['evlper'][$i][0],$lv_row['fld']) );
                    
										$lv_buffer .= '<td>'.$lv_value.'</td>';
									}
								} else {
									$lv_buffer .= '<td></td>';
								}
							}
						}
						
						$lv_buffer .= '</tr>';
					}
				}
				$lv_buffer .= '</tbody></table>';				
				$lv_flenme = 'download_grl';
				$this->co_reg->response->addHeader('Content-Disposition: attachment; filename='.$lv_flenme.'.xls');
				$this->co_reg->response->addHeader('Content-Type: application/vnd.ms-excel');	
				return $lv_buffer;
				break;
			
		}
  }
	
  // Recibe fila y valor, si tiene definido un tipo, segun el tipo que tenga definido utilizara ciertas reglas gramaticales
	private function checkTyp($lp_row, $lp_value) {
    if( isset($lp_row['typ']) ){
      switch( $lp_row['typ'] ){
        case 'number':
          $lp_value = number_format(floatval($lp_value), 2, '.', '');
          break;
        case 'checkbox':
          $lp_value = ($lp_value == 'ON' || strtoupper($lp_value) == 'SI') ? '1' : '0';  
          break;
        case 'patsex':
          $lp_value = ($lp_value == 'M') ? '1' : ( ($lp_value == 'F') ? '0' : '' );
          break;
      } 
    }
    return $lp_value;
  }
	
	// carga todos los valores del formulario
	private function getView( $lp_patcod=null ) {
		
		// cargo modelos
		$lo_pat 			= $this->co_reg->load->model('hltpat');
		$lo_patevl 		= $this->co_reg->load->model('hltpatevl');
		$lo_patevlspc = $this->co_reg->load->model('hltpatevlspc');
		$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
		
		$lo_patevlmat_rs = array();
		$lo_patplnevl_rs = array();
		$lo_patplnevl_rs2 = array();
		
		// cargo datos del paciente
		if ( $lp_patcod!=null ) {
			$lv_patcod = $lp_patcod;
			if ( $lo_pat->load( array('patcod'=>$lv_patcod) )==false ) {
        return $this->co_reg->document->getJson( array('errcod'=>$lo_pat->errcod, 'errtxt'=>$lo_pat->errtxt, 'errsrc'=>'zcuau1.129') );
			} else {
				$this->lo_mdl->sysdocclscod = $lo_pat->sysdocclscod;
				$this->lo_mdl->patcod = $lo_pat->patcod;
				$this->lo_mdl->cuscod = $lo_pat->cuscod;
			}

			// obtengo toda la info de la clase de documento
			if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_pat->sysdocclscod) ) ) {
				$this->lo_mdl->sysdoccls = $lo_docclsmdl;
			}
			
			// cargo las evoluciones del paciente
			$lv_prm = array('vewfldflt' =>'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9). $lv_patcod .chr(9).chr(9)
																		, 'vewfldord'=>'e.evlcod', 'vewmaxrec'=>'9999' );
			$lo_patevl_rs = $lo_patevl->getList( $lv_prm, null, null, false );
			foreach( $lo_patevl_rs as $lv_row ) {
				if ( $lv_row['evlnum']=='99999' ) {
					// cargo datos de evolución
					if ( $lo_patevl->load( array('evlcod'=>$lv_row['evlcod']), false )==false ) {
            return $this->co_reg->document->getJson( array('errcod'=>$lo_patevl->errcod, 'errtxt'=>$lo_patevl->errtxt, 'errsrc'=>'zcuau1.138') );
					} else {
						$this->lo_mdl->evlcod = $lo_patevl->evlcod;
            $this->lo_mdl->evlsysdocclscod = $lo_patevl->sysdocclscod;
						$this->lo_mdl->spccod = $lo_patevl->spccod;
						$this->lo_mdl->prscod = $lo_patevl->prscod;
					}

					// cargo datos de evolución-especialidad
					if ( $lo_patevlspc->load( array('evlspccod'=>$lo_patevl->evlspc[0]['evlspccod']) )==false ) {
            return $this->co_reg->document->getJson( array('errcod'=>$lo_patevl->errcod, 'errtxt'=>$lo_patevl->errtxt, 'errsrc'=>'zcuau1.149') );
					} else {
						$this->lo_mdl->evlspccod = $lo_patevlspc->evlspccod;
						$this->getEvlSpcDat( $lo_patevlspc );
					}
				// me quedo solo con las evoluciones del 1 al 4 y con la de mayor fecha
				} else {
					$this->getEvlCompLabDat( $lv_row );
					if(intval($lv_row['evlnum'])>=1 && intval($lv_row['evlnum'])<=4) {
						$lo_patplnevl_rs2[intval($lv_row['evlnum'])] = $lv_row;
					} else if( !isset($lo_patplnevl_rs2[0]['evldte']) ) {
						$lo_patplnevl_rs2[0] = $lv_row;
					} else if( $lo_patplnevl_rs2[0]['evldte']<$lv_row['evldte'] ) {
						$lo_patplnevl_rs2[0] = $lv_row;
					}
				}
			}
			
		} else {
			$lo_pat->create();
		}
		
		// muestro vista
		$lv_prm = array(
										'data' => $this->lo_mdl,
										'pat'  => $lo_pat,
										'patevl' => $lo_patevl,
										'patevlspc' => $lo_patevlspc,
										'patpln' => $lo_patplnevl_rs2,
										'actcod' => $this->data['actcod'],
										);
		return $this->co_reg->document->getview('zcuau1_hpt', $lv_prm);
	}
	
	
	
	// getFieldsArrayCompLab. Array de campos que se graban en tags (evlevl y evlobj)
	 
	 private function getFieldsArrayCompLab() {
		$lv_fldarr = array();
		// complicaciones hepaticas (21x8)
		$lv_fldarr[1] = array('frmevlcom','frmevlcomdte','frmevlcomasc','frmevlcompbe','frmevlcomenc','frmevlcomsan','frmevlcomtra','frmevlcomtradte','frmevlcomlstout','frmevlcomlst','frmevlcomhpt','frmevlcomhptdte','frmevlcomchlpts','frmevlcomchltyp','frmevlcomchlcrs','frmevlcommldpts','frmevlcomcex','frmevlcomcexdia','frmevlcomcexcor','frmevlcomcexcer','frmevlcommue','frmevlcommuedte','frmevlhptdtehcc','frmevlhptscr','frmevlhptecg','frmevlhptdiatom','frmevlhptdiares','frmevlhptdiabio','frmevlhptnod','frmevlhptnoddmt','frmevlhptnodsum','frmevlhptlstout','frmevlhptloc','frmevlhptlocext001', 'frmevlhptlocext002', 'frmevlhptlocext003', 'frmevlhptlocext004','frmevlhptlocext005','frmevlhptlocext006', 'frmevlhpttrachk001',	'frmevlhpttrachk002','frmevlhpttrachk003','frmevlhpttrachk004', 'frmevlhpttrachk005',	'frmevlhpttrachk006','frmevlhpttrachk007','frmevlhpttrachk008', 'frmevlhpttrachk009',	'frmevlhpttrachk010','frmevlhpttrachk011');
		// laboratorio (16x9)
		$lv_fldarr[2] = array('frmevllabbil','frmevllabtgo','frmevllabtgp','frmevllabfal','frmevllabalb','frmevllabglu','frmevllabcol','frmevllabrin','frmevllabqck','frmevllabhem','frmevllableu','frmevllabpla','frmevllabcre','frmevllabkkk','frmevllabafp','frmevllabhcv');
		//312
		return $lv_fldarr;
	}
	
	// setEvlCompLabDat (complicaciones hepaticas / laboratorio). 
  // Convierte campos del formulario (post) en atributos (tags) de campos evlevl y evlobj para grabar la evolución
	// seguimiento, basal, sem4, fin tto, sem 12
	private function setEvlCompLabDat( $lp_inx ) {		
		$lv_fldarr = $this->getFieldsArrayCompLab();
		$this->co_reg->request->post['evlcod'] = (isset($this->co_reg->request->post['plnevlcod'.$lp_inx])?$this->co_reg->request->post['plnevlcod'.$lp_inx]:'');
		// complicaciones hepaticas
		$lv_buffer = '';
		foreach( $lv_fldarr[1] as $lv_fld ){ 
			$lv_buffer .= '<'.$lv_fld.'>'. (isset($this->co_reg->request->post[$lv_fld.$lp_inx])?$this->co_reg->request->post[$lv_fld.$lp_inx]:'') . '</'.$lv_fld.'>'; 
		}
		$this->co_reg->request->post['evlevl']=$lv_buffer;
		// laboratorio
		$lv_buffer = '';
		foreach( $lv_fldarr[2] as $lv_fld ){ 
			$lv_buffer .= '<'.$lv_fld.'>'. (isset($this->co_reg->request->post[$lv_fld.$lp_inx])?$this->co_reg->request->post[$lv_fld.$lp_inx]:'') . '</'.$lv_fld.'>'; 
		}
		$this->co_reg->request->post['evlobj']=$lv_buffer;
	}
	
	// getEvlCompLabDat (complicaciones hepaticas / laboratorio)
  // convierte datos de la evolución (tags) de los campos evlevl y evlobj en datos que se puedan recuperar del modelo
	private function getEvlCompLabDat( &$lp_patevlpln ) {
		$lv_fldarr = $this->getFieldsArrayCompLab();
		//for( $i=0; $i<count($lp_patevlpln); $i++) {
			// complicaciones hepaticas
			$lv_dat = $lp_patevlpln['evlevl'];
			foreach( $lv_fldarr[1] as $lv_row ) {
				$lp_patevlpln[$lv_row] = $this->co_reg->document->getTagValue( $lv_dat, $lv_row );
			}
			// laboratorio
			$lv_dat = $lp_patevlpln['evlobj'];
			foreach( $lv_fldarr[2] as $lv_row ) {
				$lp_patevlpln[$lv_row] = $this->co_reg->document->getTagValue( $lv_dat, $lv_row );
			}
		//}
	}
	
	
	
	// getFieldsArray. Devuelve un array con los nombres de los campos
	private function getFieldsArray() {
		$lv_fldarr = array();
		// Pacientes - Datos demográficos (26)
		$lv_fldarr[1] = array('patwgt','pathgh','patmedcov','frmpatdemant001','frmpatdemant002','frmpatdemant003','frmpatdemant004','frmpatdemant005','frmpatdemant006','frmpatdemant007','frmpatdemant008','frmpatdemant009','frmpatdemant010','frmpatdemtra001','frmpatdemtra002','frmpatdemtra003','frmpatdemtra004','frmpatdemcoi001','frmpatdemcoi002','frmpatdemcoi003','frmpatdemcoihivrec','frmpatdemcoihivcar','frmpatdemcoihivdte','frmpatdemcoihbvcar','frmpatdemcoihbvdte','frmpatincprohcc');
		// Patología - Hepatitis C (40)
		$lv_fldarr[2] = array('frmptohepyth','frmptohepagu','frmptohepgen','frmptohepvia','frmptohepviaotr','frmptohepviayth','frmptoheptra','frmptoheptrachk01','frmptoheptrachk02','frmptoheptrachk03','frmptoheptrachk04','frmptoheptrachk05','frmptoheptrayth01','frmptoheptrayth02','frmptoheptrayth03','frmptoheptrayth04','frmptoheptrayth05','frmptoheptranul01','frmptoheptranul02','frmptoheptranul03','frmptoheptranul04','frmptoheptranul05','frmptoheptraint01','frmptoheptraint02','frmptoheptraint03','frmptoheptraint04','frmptoheptraint05','frmptoheptrarel01','frmptoheptrarel02','frmptoheptrarel03','frmptoheptrarel04','frmptoheptrarel05','frmptohepman','frmptohepman001','frmptohepman002','frmptohepman003','frmptohepman004','frmptohepman005','frmptohepman006','frmptohepman006otr','frmptoheptraant001','frmptoheptraant002','frmptoheptraant003','frmptoheptraant004','frmptoheptraant005','frmptoheptraant006','frmptoheptraant007','frmptoheptraant008','frmptoheptraant009','frmptoheptraant010','frmptoheptraant011','frmptoheptraant012','frmptoheptraant013');
		// Patología - Estadío (15)
		$lv_fldarr[3] = array( 'frmptoestbio','frmptoestbioyth','frmptoestbiogrd','frmptoestbioact','frmptoestmet','frmptoestmetmet','frmptoestmetyth','frmptoestmetgrd','frmptoestmetval','frmptoestser','frmptoestserfib','frmptoestseryth','frmptoestsergrd','frmptoestserapr','frmptoestcrr' );
		// Patología - Complicaciones Hepáticas Previas al Inicio de AAD (25)
		$lv_fldarr[4] = array( 'frmptocomhep','frmptocomlst','frmptocomant','frmptocomantevt','frmptocomenc','frmptocomvar','frmptocomhem','frmptocomanthpt','frmptocomhptdtehcc','frmptocomhptecg','frmptocomhptnronod','frmptocomhptnoddmt','frmptocomhptlocext001','frmptocomhptlocext002','frmptocomhptlocext003','frmptocomhptlocext004','frmptocomhptlocext005','frmptocomhptlocext006','frmptocomhpttrachk001','frmptocomhpttrachk002','frmptocomhpttrachk003','frmptocomhpttrachk004','frmptocomhpttrachk005','frmptocomhpttrachk006','frmptocomhpttrachk007','frmptocomhpttrachk008','frmptocomhpttrachk009','frmptocomhpttrachk010','frmptocomhpttrachk011','frmptocompatcur' );
		// Tratamiento - Medicación Actual anti HCV (25)
		$lv_fldarr[5] = array( 'frmtramedact','frmtramedstrdte','frmtramedenddte','frmtramedchlpts','frmtramedchltyp','frmtramedchlcrr','frmtramedmldpts','frmtramedrib','frmtramedribdss','frmtramedactaad001','frmtramedactaad002','frmtramedactaad003','frmtramedactaad004','frmtramedactaad005','frmtramedactaad006','frmtramedactaad007','frmtramedactaad008','frmtramedactaad009','frmtramedactaad010','frmtramedactaad011','frmtramedactaad012','frmtramedactaad013','frmtramedactaad013','frmtramedactaad014','frmtramedactaad016','frmtramedhcv' );
		// Tratamiento - Eventos Adversos (16) + medicacion concomitante (1)
		$lv_fldarr[6] = array( 'frmtraevt','frmtraevt001','frmtraevt002','frmtraevt003','frmtraevt004','frmtraevt005','frmtraevt006','frmtraevt007','frmtraevt008','frmtraevt009','frmtraevt010','frmtraevt011','frmtraevt012','frmtraevt013','frmtraevt014','frmtraevt014sev', 'frmtramedcon' );
		// Evolución - Respuesta al tratamiento (5)
		$lv_fldarr[7] = array( 'frmevlrestra', 'frmevlrestrasusdef','frmevlrestrasustra','frmevlreslstout','frmevlreslstoutdte' );
		//163
		return $lv_fldarr;
	}	
	
	// setEvlSpcDat. Convierte el formulario (post) en atributos (tags) de campos (evlatrval00?) para grabar en una evolución-especialidad
	private function setEvlSpcDat( &$lo_post ) {
		$lv_fldarr = $this->getFieldsArray();
		for( $i=1; $i<=7; $i++ ) {
			$lv_buffer = '';
			foreach( $lv_fldarr[$i] as $lv_fld ){ $lv_buffer .= '<'.$lv_fld.'>'.(isset($lo_post[$lv_fld])?$lo_post[$lv_fld]:'').'</'.$lv_fld.'>'; }
			switch( $i ) {
				case 1: $lo_post['evlatrval001']=$lv_buffer; break;
				case 2: $lo_post['evlatrval002']=$lv_buffer; break;
				case 3: $lo_post['evlatrval003']=$lv_buffer; break;
				case 4: $lo_post['evlatrval004']=$lv_buffer; break;
				case 5: $lo_post['evlatrval005']=$lv_buffer; break;
				case 6: $lo_post['evlatrval006']=$lv_buffer; break;
				case 7: $lo_post['evlatrval007']=$lv_buffer; break;
			}
		}
	}
	
	// getEvlSpcDat. Convierte datos de la evolución (tags) en un array de datos del modelo
	private function getEvlSpcDat( &$lp_patevlspc ) {
		$lv_fldarr = $this->getFieldsArray();
		for( $i=1; $i<=7; $i++ ) {
			$lv_dat = '';
			switch( $i ) {
				case 1: $lv_dat=$lp_patevlspc->evlatrval001; break;
				case 2: $lv_dat=$lp_patevlspc->evlatrval002; break;
				case 3: $lv_dat=$lp_patevlspc->evlatrval003; break;
				case 4: $lv_dat=$lp_patevlspc->evlatrval004; break;
				case 5: $lv_dat=$lp_patevlspc->evlatrval005; break;
				case 6: $lv_dat=$lp_patevlspc->evlatrval006; break;
				case 7: $lv_dat=$lp_patevlspc->evlatrval007; break;
				//case 8: $lv_dat=$lp_patevlspc->evlatrval008; break;
				//case 9: $lv_dat=$lp_patevlspc->evlatrval009; break;
			}
			foreach( $lv_fldarr[$i] as $lv_fld ){ $lp_patevlspc->set( $lv_fld, $this->co_reg->document->getTagValue( $lv_dat , $lv_fld ) ); }
		}
	}
	
}
?>
<?php
final class zcuau1_nashController extends tmssController {
  const CONTROLLER  = 'zcuau1_nash';
	const MODEL = 'hltspc';
	const VIEW  = 'zcuau1_nash';
	const ID = '';								
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
   
  function __construct(&$lp_reg) {
    $this->co_reg = $lp_reg;
  }
    
  
  // main method
     
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
				$lv_prm = array('vewfldflt' =>'[~fltrow~]spccodext'.chr(9).'='.chr(9).chr(9).'NASH'.chr(9).chr(9).
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
					return $this->co_reg->document->getView('zcuau1_nashdsh', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				
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
				
				// graba datos de paciente
				$lo_pat = $this->co_reg->load->model('hltpat');
				if ( $lo_pat->save( $lo_post )==false ) {
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
				//$lo_post['sysdocclscod'] = $this->co_reg->request->post['evlsysdocclscod'];
				if ( $lo_patevl->save( $lo_post, false )===false ) {
          return $this->co_reg->document->getJson( array('errcod'=>$lo_patevl->errcod, 'errtxt'=>$lo_patevl->errtxt) );
				} else {
					$lo_post['evlcod'] = $lo_patevl->evlcod;
				}
				
				// graba evolución-especialiad (relacionado al registro de cabecera grabado anteriormente)
				$lo_patevlspc = $this->co_reg->load->model('hltpatevlspc');
				$this->setEvlSpcDat( $lo_post );
				if ( $lo_patevlspc->save( $lo_post )==false ) {
          return $this->co_reg->document->getJson( array('errcod'=>$lo_patevlspc->errcod, 'errtxt'=>$lo_patevlspc->errtxt) );
				} else {
					$lo_post['evlspccod'] = $lo_patevlspc->evlspccod;
				}
				
				// grabo todos los datos del seguimiento
				foreach($lo_post as $lv_key=>$lv_val) {
					if(count(explode('_',$lv_key))>1 && explode('_',$lv_key)[0]=='evlcod'){
						$lv_dte = explode('_',$lv_key)[1];
						$lo_dat = array('evlcod'=>$lv_val,'patcod'=>$lo_post['patcod'],'prscod'=>$lo_post['prscod'],'spccod'=>$lo_post['spccod'],'evldte'=>$lo_post['evldte_'.$lv_dte],'docsts'=>'A');
						$this->setEvlDat( $lo_dat, $lv_dte );
						if ( $lo_patevl->save( $lo_dat, false )===false ) {
              return $this->co_reg->document->getJson( array('errcod'=>$lo_patevl->errcod, 'errtxt'=>$lo_patevl->errtxt) );
						}
					}
				}
				
				// creo un nuevo seguimiento si se indicó fecha
				if( (isset($lo_post['flwdte'])?$lo_post['flwdte']:'')!='' ) {
					$lo_dat = array('evlcod'=>'','patcod'=>$lo_post['patcod'],'prscod'=>$lo_post['prscod'],'spccod'=>$lo_post['spccod'],'evldte'=>$lo_post['flwdte'],'docsts'=>'A');
					if ( $lo_patevl->save( $lo_dat, false )===false ) {
            return $this->co_reg->document->getJson( array('errcod'=>$lo_patevl->errcod, 'errtxt'=>$lo_patevl->errtxt) );
					}
				}
				
				// muestro la vista
				return $this->getView( $lo_pat->patcod );
				break;
				
			
			
			// C R E A R
			case '#01':
				$lo_post = $this->co_reg->request->post;
				
				/* ------------------------------------------------ */
				/* obtengo clase de documento (paciente)						*/
				/* ------------------------------------------------ */
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_docclscod = (isset($lo_post['sysdocclscod'])?$lo_post['sysdocclscod']:'');
				if ( $lv_docclscod=='' ) {															// si no se indicó
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).'HLT_PAT'.chr(9).chr(9).chr(9).
																				'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
																				);
					$lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
					if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
						$lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
					} else {
						$lv_prm = array(
														'url'=>'index.php?prg='.self::CONTROLLER.'&act=01',
														'doccls'=>$lv_docclsarr
														);
						return $this->co_reg->document->getView( 'sysdocclslst', $lv_prm );		
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
				$lv_prm = array('vewfldflt' =>'[~fltrow~]spccodext'.chr(9).'='.chr(9).chr(9).'NASH'.chr(9).chr(9).
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rsspc = $lo_hltspcmdl->getList( $lv_prm );
				$this->lo_mdl->spccod = $lo_rsspc[0]['spccod'];
				
				// obtengo primer cliente
				$lo_slscusmdl = $this->co_reg->load->model('slscus');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9), 'vewmaxrec'=>'1');
				$lo_slscusmdl_rs = $lo_slscusmdl->getList( $lv_prm, null, null false );
				if (count($lo_slscusmdl_rs)==0) {
					echo 'No se pudieron cargar los datos de clientes.';
				} else {
					$this->lo_mdl->cuscod = $lo_slscusmdl_rs[0]['cuscod'];
				}

				return $this->getView( );
				break;
			
			
			
			// M O D I F I C A R   -   V E R
      case '#02': case '#03':
				$lo_post = $this->co_reg->request->post;
				$lv_patcod = ( isset($lo_post['patcod']) ? $lo_post['patcod'] : $lp_prm['patcod'] );
				return $this->getView( $lv_patcod );
        break;
			

			
			// LISTAR PACIENTES (DASHBOARD - GRILLA PACIENTES)
      case '#09':
        $lo_vew = $this->co_reg->load->controller('grlvew');
        return $lo_vew->index( '00', $lp_prm );
        break;
			
			
			
			// LISTA de PACIENTES de PRESTADOR / ESPECIALIDAD
      case '#18':
				$lo_post = $this->co_reg->request->post;
				
				// obtengo evoluciones de prestador/especialidad
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evlnum'.chr(9).'='.chr(9).chr(9).'99999'.chr(9).chr(9).
																			'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$lo_post['prscod'] .chr(9).chr(9).
																			'[~fltrow~]e.spccod'.chr(9).'='.chr(9).chr(9).$lo_post['spccod'] .chr(9).chr(9) );
				$lo_evlrs = $lo_evlmdl->getList( $lv_prm, null, null, false );
			
				// determino fecha ultima actualización
				for($i=0; $i<count($lo_evlrs); $i++) {
					$lo_evlrs[$i]['maxupddte'] = (isset($lo_evlrs[$i]['upddte'])?$lo_evlrs[$i]['upddte']:$lo_evlrs[$i]['ctedte']);
				}
				
				// muestro vista
				return	$this->co_reg->document->getView('zcuau1_patprsrls', array('data' => $lo_evlrs, 'actcod' => $this->data['actcod']) );
				break;
			
			
			
			// Verifica si la nueva fecha de seguimiento está duplicada
			case '#chkDate':
				$lo_post = $this->co_reg->request->post;
				if( (isset($lo_post['flwdte'])?$lo_post['flwdte']:'')=='' ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E', 'errcod'=>'-1', 'errtxt'=>'Debe indicar una Fecha de Seguimiento.') );
				}				
				$lo_patevl = $this->co_reg->load->model('hltpatevl');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9). $lo_post['patcod'] .chr(9).chr(9).
																			'[~fltrow~]convert(varchar,e.evldte,103)'.chr(9).'='.chr(9).chr(9). $lo_post['flwdte'] .chr(9).chr(9)
																			, 'vewmaxrec'=>'1' );
				$lo_patevl_rs = $lo_patevl->getList( $lv_prm, null, null, false );
				if( count($lo_patevl_rs)>0 ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E', 'errcod'=>'-1', 'errtxt'=>'Fecha de seguimiento existente.') );
				} else {
          return $this->co_reg->document->getJson( array('errtxt'=>'Fecha valida.') );
				}
				break;

		}
  }
	
	
	
	/**
		* carga todos los valores del formulario
		*/
	private function getView( $lp_patcod=null ) {
		
		// cargo modelos
		$lo_pat 			= $this->co_reg->load->model('hltpat');
		$lo_patevl 		= $this->co_reg->load->model('hltpatevl');
		$lo_patevlspc = $this->co_reg->load->model('hltpatevlspc');
		$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
		
		$lo_patevlmat_rs = array();
		$lo_patplnevl_rs = array();
		$lo_patplnevl_rs2 = array();
		$lo_patevlarr = array();
		
		// cargo datos del paciente
		if ( $lp_patcod!=null ) {
			$lv_patcod = $lp_patcod;
			if ( $lo_pat->load( array('patcod'=>$lv_patcod) )==false ) {
        return $this->co_reg->document->getJson( array('errcod'=>$lo_pat->errcod, 'errtxt'=>$lo_pat->errtxt) );
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
																		, 'vewfldord'=>'e.evldte', 'vewmaxrec'=>'9999' );
			$lo_patevl_rs = $lo_patevl->getList( $lv_prm, null, null, false );
			foreach( $lo_patevl_rs as $lv_row ) {
				if ( $lv_row['evlnum']=='99999' ) {
					// cargo datos de evolución
					if ( $lo_patevl->load( array('evlcod'=>$lv_row['evlcod']), false )==false ) {
            return $this->co_reg->document->getJson( array('errcod'=>$lo_patevl->errcod, 'errtxt'=>$lo_patevl->errtxt) );
					} else {
						$this->lo_mdl->evlcod = $lo_patevl->evlcod;
            $this->lo_mdl->evlsysdocclscod = $lo_patevl->sysdocclscod;
						$this->lo_mdl->spccod = $lo_patevl->spccod;
						$this->lo_mdl->prscod = $lo_patevl->prscod;
					}

					// cargo datos de evolución-especialidad
					if ( $lo_patevlspc->load( array('evlspccod'=>$lo_patevl->evlspc[0]['evlspccod']) )==false ) {
            return $this->co_reg->document->getJson( array('errcod'=>$lo_patevlspc->errcod, 'errtxt'=>$lo_patevlspc->errtxt, 'errsrc'=>'zcuau1.149') );
					} else {
						$this->lo_mdl->evlspccod = $lo_patevlspc->evlspccod;
						$this->getEvlSpcDat( $lo_patevlspc );
					}

				} else {
					$lo_patevlarr[] = $lv_row;
				}
			}
					
		} else {
			$lo_pat->create();
		}
		
		$this->lo_mdl->patevl = $lo_patevlarr;
		$lv_prm = array(
										'data' => $this->lo_mdl,
										'pat'  => $lo_pat,
										'patevl' => $lo_patevl,
										'patevlspc' => $lo_patevlspc,
										'patpln' => $lo_patplnevl_rs2,
										'actcod' => $this->data['actcod'],
										);
		return 	$this->co_reg->document->getView('zcuau1_nash', $lv_prm);;
	}
	
	
	
	private function getFieldsArray() {
		$lv_fldarr = array();		
		$lv_fldarr[1] = array('frmpatmed','frmpatyth','frmpatgen','patbaswgt','patbashgh','patbasimc','frmbasingeto','frmbasanieto','frmbastabyth','frmbasactfis');
		$lv_fldarr[2] = array('frmbasprmhip','frmbasprmdia','frmbasprmtri','frmbasprmhdl','frmbasprmecv','frmbasprmerc','frmbasprmhpt','frmbasprmvit','frmbasprmcli','frmbasprmado','frmbasprmadodrg001','frmbasprmadodrg002','frmbasprmadodrg003','frmbasprmadodrg004','frmbasprmadodrg005','frmbasprmadodrg006','frmbasprmtin','frmbasprmtes','frmbasprmtah','frmbasbiodte','frmbasbiohem','frmbasbiohgl','frmbasbioleu','frmbasbioplq','frmbasbiofer','frmbasbiopst','frmbasbioclt','frmbasbioldl','frmbasbiohdl','frmbasbiotri','frmbasbioglu','frmbasbioins','frmbasbiohma','frmbasbiohb1','frmbasbiobil','frmbasbioast','frmbasbioastmax','frmbasbioalt','frmbasbioggt','frmbasbioptt','frmbasbioalb','frmbasbiogam','frmbasbiofan','frmbasbiotpb','frmbasbiorin','frmbasbioure','frmbasbiocre','frmbasbiomdr','frmbasscrfra','frmbasscrast','frmbasscrapr','frmbasscrfib','frmbasscrnaf','frmbasscrbrd','frmbasecodte','frmbasecoeco','frmbaseladte','frmbaselamtd','frmbaselaela','frmbaselaefi','frmbaselafib','frmbaselafie','frmbashisest','frmbashisbal','frmbashisifl','frmbashisifp','frmbashisdte','frmbashisfib', 'frmbasdiadiagdte', 'frmbasdiaretdia', 'frmbasdiamcb', 'frmbasdianeuprf', 'frmbasprmtesdte', 'frmbasprmtahdte', 'frmbasprmvitdte', 'frmbasbioacdurc', 'frmbasbiopcr', 'frmbasprmtindte' );
		$lv_fldarr[3] = array('patsegwgt','patseghgh','patsegimc','frmsegbiohem','frmsegbiohgl','frmsegbioleu','frmsegbioplq','frmsegbiofer','frmsegbiopst','frmsegbioclt','frmsegbioldl','frmsegbiohdl','frmsegbiotri','frmsegbioglu','frmsegbioins','frmsegbiohma','frmsegbiohb1','frmsegbiobil','frmsegbioast','frmsegbioastmax','frmsegbioalt','frmsegbiofal','frmsegbioggt','frmsegbioptt','frmsegbioalb','frmsegbiotpb','frmsegbiorin','frmsegbioure','frmsegbiocre','frmsegscrfra','frmsegscrast','frmsegscrapr','frmsegscrfib','frmsegscrnaf','frmsegscrbrd','frmsegevtdbt','frmsegevtdbtdte','frmsegevthta','frmsegevthtadte','frmsegevtecv','frmsegevtecvdte','frmsegevtbar','frmsegevtbardte','frmsegevtcir','frmsegevtcirdte','frmsegevtcid','frmsegevtciddte','frmsegevttpd001','frmsegevttpd002','frmsegevttpd003','frmsegevttpd004','frmsegevttph','frmsegevttphdte','frmsegevtobt','frmsegevtobtdte','frmsegevtobc','frmsegevtobcotr');
		$lv_fldarr[4] = array('frmsegecodte','frmsegecoeco','frmsegeladte','frmsegelafie','frmsegelamtd','frmsegelaela','frmsegelaefi','frmsegelafib');
		$lv_fldarr[5] = array();
		$lv_fldarr[6] = array();
		$lv_fldarr[7] = array();
		$lv_fldarr[8] = array();
		$lv_fldarr[9] = array();
		return $lv_fldarr;
	}	
	
	private function setEvlSpcDat( &$lo_post ) {
		$lv_fldarr = $this->getFieldsArray();
		for( $i=1; $i<=9; $i++ ) {
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
				case 8: $lo_post['evlatrval008']=$lv_buffer; break;
				case 9: $lo_post['evlatrval009']=$lv_buffer; break;
			}
		}
	}
	
	private function getEvlSpcDat( &$lp_patevlspc ) {
		$lv_fldarr = $this->getFieldsArray();
		for( $i=1; $i<=9; $i++ ) {
			$lv_dat = '';
			switch( $i ) {
				case 1: $lv_dat=$lp_patevlspc->evlatrval001; break;
				case 2: $lv_dat=$lp_patevlspc->evlatrval002; break;
				case 3: $lv_dat=$lp_patevlspc->evlatrval003; break;
				case 4: $lv_dat=$lp_patevlspc->evlatrval004; break;
				case 5: $lv_dat=$lp_patevlspc->evlatrval005; break;
				case 6: $lv_dat=$lp_patevlspc->evlatrval006; break;
				case 7: $lv_dat=$lp_patevlspc->evlatrval007; break;
				case 8: $lv_dat=$lp_patevlspc->evlatrval008; break;
				case 9: $lv_dat=$lp_patevlspc->evlatrval009; break;
			}
			foreach( $lv_fldarr[$i] as $lv_fld ){ $lp_patevlspc->set( $lv_fld, $this->co_reg->document->getTagValue( $lv_dat , $lv_fld ) ); }
		}
	}






	
	private function getFieldsEvlArray() {
		$lv_fldarr = array();		
		$lv_fldarr[1] = array('patsegwgt','patseghgh','patsegimc','frmpatyth','frmsegscrast','frmsegscrapr','frmsegscrfib','frmsegscrnaf','frmsegscrbrd');
		$lv_fldarr[2] = array('frmsegbiohem','frmsegbiohgl','frmsegbioplq','frmsegbiofer','frmsegbiopst','frmsegbioclt','frmsegbioldl','frmsegbiohdl','frmsegbiotri','frmsegbioglu','frmsegbioins','frmsegbiohma','frmsegbiohb1','frmsegbiobil','frmsegbioast','frmsegbioalt','frmsegbiofas','frmsegbioggt','frmsegbioptt','frmsegbioalb','frmsegbiotpb','frmsegbiorin','frmsegbioure','frmsegbiocre', 'frmsegbioacdurc', 'frmsegbiopcr');
		$lv_fldarr[3] = array();
		$lv_fldarr[4] = array();
		$lv_fldarr[5] = array();
		$lv_fldarr[6] = array();
		$lv_fldarr[7] = array();
		$lv_fldarr[8] = array();
		$lv_fldarr[9] = array();
		return $lv_fldarr;
	}
	
	private function setEvlDat( &$lp_dat, $lp_dte='' ) {
		$lo_post = $this->co_reg->request->post;
		$lv_fldarr = $this->getFieldsEvlArray();
		for( $i=1; $i<=9; $i++ ) {
			$lv_buffer = '';
			foreach( $lv_fldarr[$i] as $lv_fld ){ $lv_buffer .= '<'.$lv_fld.'>'.(isset($lo_post[$lv_fld.($lp_dte!=''?'_'.$lp_dte:'')])?$lo_post[$lv_fld.($lp_dte!=''?'_'.$lp_dte:'')]:'').'</'.$lv_fld.'>'; }
			switch( $i ) {
				case 1: $lp_dat['evlevl']=$lv_buffer; break;
				case 2: $lp_dat['evlobj']=$lv_buffer; break;
			}
		}
	}
	
	private function getEvlDat( &$lp_patevl ) {
		$lv_fldarr = $this->getFieldsEvlArray();
		for( $i=1; $i<=9; $i++ ) {
			$lv_dat = '';
			switch( $i ) {
				case 1: $lv_dat=$lp_patevl->evlevl; break;
				case 2: $lv_dat=$lp_patevl->evlobj; break;
			}
			foreach( $lv_fldarr[$i] as $lv_fld ){ $lp_patevl->set( $lv_fld, $this->co_reg->document->getTagValue( $lv_dat , $lv_fld ) ); }
		}
	}

}
?>
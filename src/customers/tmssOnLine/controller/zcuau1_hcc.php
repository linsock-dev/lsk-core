<?php
final class zcuau1_hccController extends tmssController {
	const CONTROLLER  = 'zcuau1_hcc';
	const MODEL = 'hltspc';
	const VIEW  = 'zcuau1_hcc';
	const ID = '';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
   
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
  
	
  // INDEX. metodo principal de la clase
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
				$lv_prm = array('vewfldflt' =>'[~fltrow~]spccodext'.chr(9).'='.chr(9).chr(9).'HCC'.chr(9).chr(9).
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
					return $this->co_reg->document->getView( 'zcuau1_hccdsh', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
					
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
					
					return $this->co_reg->document->getJson( array('data'=>array('patlst'=>$lo_rsrls, 'prslst'=>$lo_patprsrs)) );
				}
        break;
			
			
			
			// G R A B A R
			case '#00':
				$lo_post = $this->co_reg->request->post;
        
				// graba datos de paciente
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
				
				// muestro la vista
				return $this->getView( $lo_pat->patcod );
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
						return $this->co_reg->document->getView('sysdocclslst',array('url'=>'?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
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
				$lv_prm = array('vewfldflt' =>'[~fltrow~]spccodext'.chr(9).'='.chr(9).chr(9).'HCC'.chr(9).chr(9).
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rsspc = $lo_hltspcmdl->getList( $lv_prm );
				$this->lo_mdl->spccod = $lo_rsspc[0]['spccod'];
				
				// obtengo primer cliente
				$lo_slscusmdl = $this->co_reg->load->model('slscus');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9), 'vewmaxrec'=>'1');
				$lo_slscusmdl_rs = $lo_slscusmdl->getList( $lv_prm );
				if (count($lo_slscusmdl_rs)==0) {
					echo 'No se pudieron cargar los datos de clientes.';
				} else {
					$this->lo_mdl->cuscod = $lo_slscusmdl_rs[0]['cuscod'];
				}

				return $this->getView( ); // $this->co_reg->request->post['patcod'];
				break;
			
			
			
			// M O D I F I C A R   -   V E R
      case '#02': case '#03':
				return $this->getView( $lp_prm['patcod'] ); // $this->co_reg->request->post['patcod'];
        break;
			

			
			// LISTAR PACIENTES (DASHBOARD - GRILLA PACIENTES)
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
				
				return $this->co_reg->document->getView( 'zcuau1_patprsrls', array('data'=>$lo_evlrs,'actcod'=>$this->data['actcod']) );
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
				$lv_prm = array('vewfldflt' =>'[~fltrow~]spccodext'.chr(9).'='.chr(9).chr(9).'HCC'.chr(9).chr(9).
																			'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
				$lo_rsspc = $lo_hltspcmdl->getList( $lv_prm );
				$this->lo_mdl->spccod = $lo_rsspc[0]['spccod'];
				
				// obtengo pacientes
				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.docsts'.chr(9).'<>'.chr(9).chr(9). 'I' .chr(9).chr(9),
												'vewfldord'=>'p.patcod');
				$lo_pat_rs = $lo_pat->getList( $lv_prm );
				// armo un array con el id de paciente como clave
				$lv_rowpat = array();
				foreach($lo_pat_rs as $lv_row){	$lv_rowpat[ $lv_row['patcod'] ] = $lv_row; }

				// obtengo direcciones
				$lv_prm = array('vewfldflt' =>'[~fltrow~]a.adrsrctyp'.chr(9).'='.chr(9).chr(9). 'HLT_PAT' .chr(9).chr(9),
												'vewfldord'=>'a.adrsrccod');
				$lo_patadr_rs = $lo_adr->getList( $lv_prm );
				// armo un array con el id de paciente como clave
				$lv_rowpatadr = array();
				foreach($lo_patadr_rs as $lv_row){	$lv_rowpatadr[ $lv_row['adrsrccod'] ] = $lv_row; }

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


				$lv_cols = array();

				// paciente
				// Datos demogr&aacute;ficos
				$lv_cols[] = array('mdl'=>'pat','fld'=>'patcod','nme'=>'Paciente - Datos demogr&aacute;ficos - ID Paciente');
				$lv_cols[] = array('mdl'=>'patadr','fld'=>'adrlstnme','nme'=>'Paciente - Datos demogr&aacute;ficos - Iniciales');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'patage','nme'=>'Paciente - Datos demogr&aacute;ficos - Edad');
				$lv_cols[] = array('mdl'=>'pat','fld'=>'patsex','nme'=>'Paciente - Datos demogr&aacute;ficos - Sexo', 'typ'=>'patsex');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'patwgt','nme'=>'Paciente - Datos demogr&aacute;ficos - Peso.kg');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'pathgh','nme'=>'Paciente - Datos demogr&aacute;ficos - Talla.cm');
				$lv_cols[] = array('mdl'=>'patadr','fld'=>'adrcty','nme'=>'Paciente - Datos demogr&aacute;ficos - Ciudad');
				$lv_cols[] = array('mdl'=>'patadr','fld'=>'lndcod','nme'=>'Paciente - Datos demogr&aacute;ficos - Pa&iacute;s');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemviv','nme'=>'Paciente - Datos demogr&aacute;ficos - Situaci&oacute;n del Paciente');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemvivdte','nme'=>'Paciente - Datos demogr&aacute;ficos - Fecha fallecimiento');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemvivmtv','nme'=>'Paciente - Datos demogr&aacute;ficos - Causa de muerte');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmpatdemlstflwdte','nme'=>'Paciente - Datos demogr&aacute;ficos - Fec Ultimo Follow Up');

				// Patolog&iacute;a
				// Datos al Diagn&oacute;stico de Hepatocarcinoma
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccdte','nme'=>'Patolog&iacute;a - Datos al Diagn&oacute;stico de Hepatocarcinoma - Fecha Diagn&oacute;stico HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccecg','nme'=>'Patolog&iacute;a - Datos al Diagn&oacute;stico de Hepatocarcinoma - Performance Status ECOG Al diagnostico');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccenf','nme'=>'Patolog&iacute;a - Datos al Diagn&oacute;stico de Hepatocarcinoma - Enfermedad Hep&aacute;tica al diagn&oacute;stico del HCC - Hallazgo histol&oacute;gico o valoraci&oacute;n de fibrosis por m&eacute;todos no invasivos');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccmthval','nme'=>'Patolog&iacute;a - Datos al Diagn&oacute;stico de Hepatocarcinoma - M&eacute;todo de Valoraci&oacute;n Fibrosis');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcclabbil','nme'=>'Patolog&iacute;a - Datos al Diagn&oacute;stico de Hepatocarcinoma - Laboratorio - Bilirrubina Total (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcclabrin','nme'=>'Patolog&iacute;a - Datos al Diagn&oacute;stico de Hepatocarcinoma - Laboratorio - RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcclabalb','nme'=>'Patolog&iacute;a - Datos al Diagn&oacute;stico de Hepatocarcinoma - Laboratorio - Alb&uacute;mina (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcclabepr','nme'=>'Patolog&iacute;a - Datos al Diagn&oacute;stico de Hepatocarcinoma - Laboratorio - Encefalopatia Portosistemica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcclabasc','nme'=>'Patolog&iacute;a - Datos al Diagn&oacute;stico de Hepatocarcinoma - Laboratorio - ASCITIS');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcclabrec','nme'=>'Patolog&iacute;a - Datos al Diagn&oacute;stico de Hepatocarcinoma - Laboratorio - Recuento de Plaquetas (en mm3)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcclabafp','nme'=>'Patolog&iacute;a - Datos al Diagn&oacute;stico de Hepatocarcinoma - Laboratorio - AFP al diagnostico Alfa-fetoproteina (AFP) en ng/ml', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccenddig','nme'=>'Patolog&iacute;a - Datos al Diagn&oacute;stico de Hepatocarcinoma - Endoscop&iacute;a Digestiva alta al diagn&oacute;stico');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcccom','nme'=>'Patolog&iacute;a - Datos al Diagn&oacute;stico de Hepatocarcinoma - Comorbilidades');

				// Etiolog&iacute;a
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcceticrr','nme'=>'Patolog&iacute;a - Etiolog&iacute;a - Etiologia de la Cirrosis');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccgenhcv','nme'=>'Patolog&iacute;a - Etiolog&iacute;a - Hepatitis C - Genotipo de HCV - En caso de HCV + Especificar Genotipo subtipo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcchptbbb','nme'=>'Patolog&iacute;a - Etiolog&iacute;a - Hepatitis B - Hepatitis B al momento del diagn&oacute;stico');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcchptbbbtra','nme'=>'Patolog&iacute;a - Etiolog&iacute;a - Hepatitis B - Hepatitis B Tratamiento');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcchptbbbcar','nme'=>'Patolog&iacute;a - Etiolog&iacute;a - Hepatitis B - Carga viral HBV');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcceticrrotr','nme'=>'Patolog&iacute;a - Etiolog&iacute;a - Otro - Indique');

				// Screening y Diagn&oacute;stico HCC
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccscreco001','nme'=>'Patolog&iacute;a - Screening y Diagn&oacute;stico HCC - Estaba Bajo Screening con Ecograf&iacute;a?');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccscrecoult','nme'=>'Patolog&iacute;a - Screening y Diagn&oacute;stico HCC - &uacute;ltima Ecograf&iacute;a de Screening');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccscreconro','nme'=>'Patolog&iacute;a - Screening y Diagn&oacute;stico HCC - N&uacute;mero de Nodulos en Ecografia', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccscrecotam','nme'=>'Patolog&iacute;a - Screening y Diagn&oacute;stico HCC - Tama&ntilde;o de Nodulo MAYOR en ecograf&iacute;a - Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccdiamth001','nme'=>'Patolog&iacute;a - Screening y Diagn&oacute;stico HCC - Se realiz&oacute; el Diagn&oacute;stico de HCC en este paciente mediante - TAC din&aacute;mica', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccdiamth002','nme'=>'Patolog&iacute;a - Screening y Diagn&oacute;stico HCC - Se realiz&oacute; el Diagn&oacute;stico de HCC en este paciente mediante - RMN din&aacute;mica', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccdiamth003','nme'=>'Patolog&iacute;a - Screening y Diagn&oacute;stico HCC - Se realiz&oacute; el Diagn&oacute;stico de HCC en este paciente mediante - Biopsia', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcctacnum','nme'=>'Patolog&iacute;a - Screening y Diagn&oacute;stico HCC - N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcctactam','nme'=>'Patolog&iacute;a - Screening y Diagn&oacute;stico HCC - Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN - Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohcctacsum','nme'=>'Patolog&iacute;a - Screening y Diagn&oacute;stico HCC - Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN - Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccinvtummac','nme'=>'Patolog&iacute;a - Screening y Diagn&oacute;stico HCC - Invasi&oacute;n tumoral macrovascular - Diagnostico por imagenes');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccenfext','nme'=>'Patolog&iacute;a - Screening y Diagn&oacute;stico HCC - Enfermedad Extrahep&aacute;tica HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptohccotrlocmet','nme'=>'Patolog&iacute;a - Screening y Diagn&oacute;stico HCC - Cual otra localizaci&oacute;n metast&aacute;sica?');

				// Estad&iacute;o BCLC
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmptobcl','nme'=>'Patolog&iacute;a - Estad&iacute;o BCLC al diagn&oacute;stico - acorde a juicio cl&iacute;nico subjetivo');
				
				// Tratamientos del HCC
				// Tratamientos Realizados en este paciente

				// Ablación
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraabl','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - Ablaci&oacute;n Percut&aacute;nea');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraablbcl','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - Estad&iacute;o BCLC previo al tratamiento - acorde a juicio cl&iacute;nico subjetivo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraablnumnod','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraablhccdif','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - HCC difuso');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraabltamnod','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN - Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraablsumnod','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN - Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraablinvtum','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - Invasi&oacute;n tumoral macrovascular - Diagnostico por imagenes');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraablenfext','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - Enfermedad Extrahep&aacute;tica HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraablenfextotr','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - Cual otra localizaci&oacute;n metast&aacute;sica?');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraablecg','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - Performance Status ECOG');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraabllabbil','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - Laboratorio - Bilirrubina Total (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraabllabrin','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - Laboratorio - RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraabllabalb','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - Laboratorio - Alb&uacute;mina (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraabllabenc','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - Laboratorio - Encefalopatia Portosistemica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraabllabasc','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - Laboratorio - ASCITIS');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraabllabrec','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - Laboratorio - Recuento de Plaquetas (en mm3)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraabllabafp','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - Laboratorio - AFP al diagnostico - Alfa-fetoproteina (AFP) en ng/ml', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraablnum','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - N&uacute;mero de Ablaciones percut&aacute;neas en este paciente', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'pattraablses001dte','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - 1er Sesi&oacute;n - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'pattraablses001evl','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - 1er Sesi&oacute;n - Evaluaci&oacute;n Radiol&oacute;gica o Respuesta Post Ablaci&oacute;n - Evaluada por Im&aacute;genes, RECIST 1.1');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'pattraablses001evldte','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - 1er Sesi&oacute;n - Fecha de Evaluaci&oacute;n Radiol&oacute;gica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'pattraablses002dte','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - 2da Sesi&oacute;n - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'pattraablses002evl','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - 2da Sesi&oacute;n - Evaluaci&oacute;n Radiol&oacute;gica o Respuesta Post Ablaci&oacute;n - Evaluada por Im&aacute;genes, RECIST 1.1');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'pattraablses002evldte','nme'=>'Tratamientos - Realizados - Ablaci&oacute;n - 2da Sesi&oacute;n - Fecha de Evaluaci&oacute;n Radiol&oacute;gica');

				// Resección
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresqui001','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Resecci&oacute;n Quir&uacute;rgica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquibcl','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Estad&iacute;o BCLC previo al tratamiento - acorde a juicio cl&iacute;nico subjetivo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquinumnod','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquihccdif','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - HCC difuso');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquitamnod','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN - Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquisumnod','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN - Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquiinvtum','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Invasi&oacute;n tumoral macrovascular - Diagnostico por imagenes');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquienfext','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Enfermedad Extrahep&aacute;tica HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquienfextotr','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Cual otra localizaci&oacute;n metast&aacute;sica?');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquiecg','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Performance Status ECOG');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquilabbil','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Laboratorio - Bilirrubina Total (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquilabrin','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Laboratorio - RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquilabalb','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Laboratorio - Alb&uacute;mina (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquilabenc','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Laboratorio - Encefalopatia Portosistemica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquilabasc','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Laboratorio - ASCITIS');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquilabrec','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Laboratorio - Recuento de Plaquetas (en mm3)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquilabafp','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Laboratorio - AFP al diagnostico - Alfa-fetoproteina (AFP) en ng/ml', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquinum','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - N&uacute;mero de resecciones quir&uacute;rgicas realizadas en este paciente', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquityp','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Tipo de Resecci&oacute;n Quir&uacute;rgica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquidte','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Fecha de Cirug&iacute;a');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquievl','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Evaluaci&oacute;n Radiol&oacute;gica o Respuesta Post Resecci&oacute;n<br><small>Evaluada por Im&aacute;genes, RECIST 1.1');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraresquievldte','nme'=>'Tratamientos - Realizados - Resecci&oacute;n - Fecha de Evaluaci&oacute;n Radiol&oacute;gica');

				// Translaplte Hepatico
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratsphep','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Evaluaci&oacute;n y/o Trasplante Hep&aacute;tico');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratsphepevl','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Evaluaci&oacute;n Trasplante Hep&aacute;tico');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratsphepevldte','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratspheptyp','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Trasplante Hep&aacute;tico');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratsphepbcl','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Estad&iacute;o BCLC previo al tratamiento acorde a juicio cl&iacute;nico subjetivo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratsphepnumnod','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratsphephccdif','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - HCC difuso');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratspheptamnod','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratsphepsumnod','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratsphepinvtum','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratsphepenfext','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Enfermedad Extrahep&aacute;tica HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratsphepenfextotr','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Cual otra localizaci&oacute;n metast&aacute;sica?');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratsphepecg','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Performance Status ECOG');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratspheplabbil','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Laboratorio - Bilirrubina Total (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratspheplabrin','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Laboratorio - RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratspheplabalb','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Laboratorio - Alb&uacute;mina (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratspheplabenc','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Laboratorio - Encefalopatia Portosistemica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratspheplabasc','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Laboratorio - ASCITIS');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratspheplabrec','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Laboratorio - Recuento de Plaquetas (en mm3)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratspheplabafp','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Laboratorio - AFP al diagnostico - Alfa-fetoproteina (AFP) en ng/ml', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtratspheptypdte','nme'=>'Tratamientos - Realizados - Traslplante Hep&aacute;tico - Fecha');

				// Quimioembolizacion
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraqui','nme'=>'Tratamientos - Realizados - Quimioembolizacion');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquibcl','nme'=>'Tratamientos - Realizados - Quimioembolizacion - Estad&iacute;o BCLC previo al tratamiento acorde a juicio cl&iacute;nico subjetivo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquinumnod','nme'=>'Tratamientos - Realizados - Quimioembolizacion - N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquihccdif','nme'=>'Tratamientos - Realizados - Quimioembolizacion - HCC difuso');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquitamnod','nme'=>'Tratamientos - Realizados - Quimioembolizacion - Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquisumnod','nme'=>'Tratamientos - Realizados - Quimioembolizacion - Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquiinvtum','nme'=>'Tratamientos - Realizados - Quimioembolizacion - Invasi&oacute;n tumoral macrovascular Diagnostico por imagenes');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquienfext','nme'=>'Tratamientos - Realizados - Quimioembolizacion - Enfermedad Extrahep&aacute;tica HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquienfextotr','nme'=>'Tratamientos - Realizados - Quimioembolizacion - Cual otra localizaci&oacute;n metast&aacute;sica?');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquiecg','nme'=>'Tratamientos - Realizados - Quimioembolizacion - Performance Status ECOG');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquilabbil','nme'=>'Tratamientos - Realizados - Quimioembolizacion - Laboratorio - Bilirrubina Total (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquilabrin','nme'=>'Tratamientos - Realizados - Quimioembolizacion - Laboratorio - RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquilabalb','nme'=>'Tratamientos - Realizados - Quimioembolizacion - Laboratorio - Alb&uacute;mina (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquilabenc','nme'=>'Tratamientos - Realizados - Quimioembolizacion - Laboratorio - Encefalopatia Portosistemica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquilabasc','nme'=>'Tratamientos - Realizados - Quimioembolizacion - Laboratorio - ASCITIS');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquilabrec','nme'=>'Tratamientos - Realizados - Quimioembolizacion - Laboratorio - Recuento de Plaquetas (en mm3)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquilabafp','nme'=>'Tratamientos - Realizados - Quimioembolizacion - Laboratorio - AFP al diagnostico - Alfa-fetoproteina (AFP) en ng/ml', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquitra','nme'=>'Tratamientos - Realizados - Quimioembolizacion - Quimioembolizacion transarterial');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraquitranum','nme'=>'Tratamientos - Realizados - Quimioembolizacion - N&uacute;mero de Quimioembolizaciones realizadas', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraprc001dte','nme'=>'Tratamientos - Realizados - Quimioembolizacion - TACE 1 - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraprc001evlrad','nme'=>'Tratamientos - Realizados - Quimioembolizacion - TACE 1 - Evaluaci&oacute;n Radiol&oacute;gica o Respuesta Post Quimioembolizaci&oacute;n - Evaluada por Im&aacute;genes, RECIST 1.1');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraprc001evlraddte','nme'=>'Tratamientos - Realizados - Quimioembolizacion - TACE 1 - Fecha de Evaluaci&oacute;n Radiol&oacute;gica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraprc002dte','nme'=>'Tratamientos - Realizados - Quimioembolizacion - &Uacute;ltimo TACE - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraprc002evlrad','nme'=>'Tratamientos - Realizados - Quimioembolizacion - &Uacute;ltimo TACE - Evaluaci&oacute;n Radiol&oacute;gica o Respuesta Post Quimioembolizaci&oacute;n - Evaluada por Im&aacute;genes, RECIST 1.1');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraprc002evlraddte','nme'=>'Tratamientos - Realizados - Quimioembolizacion - &Uacute;ltimo TACE - Fecha de Evaluaci&oacute;n Radiol&oacute;gica');

				// Radioembolización Ytrio
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradytr','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradytrbcl','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Estad&iacute;o BCLC previo al tratamiento acorde a juicio cl&iacute;nico subjetivo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradnumnod','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradhccdif','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - HCC difuso');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradtamnod','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradsumnod','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradinvtum','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Invasi&oacute;n tumoral macrovascular Diagnostico por imagenes');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradenfext','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Enfermedad Extrahep&aacute;tica HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradenfextotr','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Cual otra localizaci&oacute;n metast&aacute;sica?');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradecg','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Performance Status ECOG');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradlabbil','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Laboratorio - Bilirrubina Total (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradlabrin','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Laboratorio - RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradlabalb','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Laboratorio - Alb&uacute;mina (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradlabenc','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Laboratorio - Encefalopatia Portosistemica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradlabasc','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Laboratorio - ASCITIS');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradlabrec','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Laboratorio - Recuento de Plaquetas (en mm3)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradlabafp','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Laboratorio - AFP al diagnostico - Alfa-fetoproteina (AFP) en ng/ml', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradytrdte','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradytrrsp','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Respuesta Post Radioembolizaci&oacute;n - Evaluada por Im&aacute;genes, RECIST 1.1');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraradytrdteevl','nme'=>'Tratamientos - Realizados - Radioembolizaci&oacute;n Ytrio - Fecha de Evaluaci&oacute;n Radiol&oacute;gica post Radioembolizaci&oacute;n');

				// Sorafenib
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasor','nme'=>'Tratamientos - Realizados - Sorafenib');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorbcl','nme'=>'Tratamientos - Realizados - Sorafenib - Estad&iacute;o BCLC previo al tratamiento - acorde a juicio cl&iacute;nico subjetivo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasornumnod','nme'=>'Tratamientos - Realizados - Sorafenib - N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorhccdif','nme'=>'Tratamientos - Realizados - Sorafenib - HCC difuso');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasortamnod','nme'=>'Tratamientos - Realizados - Sorafenib - Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorsumnod','nme'=>'Tratamientos - Realizados - Sorafenib - Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorinvtum','nme'=>'Tratamientos - Realizados - Sorafenib - Invasi&oacute;n tumoral macrovascular Diagnostico por imagenes');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorenfext','nme'=>'Tratamientos - Realizados - Sorafenib - Enfermedad Extrahep&aacute;tica HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorenfextotr','nme'=>'Tratamientos - Realizados - Sorafenib - Cual otra localizaci&oacute;n metast&aacute;sica?');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorecg','nme'=>'Tratamientos - Realizados - Sorafenib - Performance Status ECOG');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorlabbil','nme'=>'Tratamientos - Realizados - Sorafenib - Laboratorio - Bilirrubina Total (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorlabrin','nme'=>'Tratamientos - Realizados - Sorafenib - Laboratorio - RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorlabalb','nme'=>'Tratamientos - Realizados - Sorafenib - Laboratorio - Alb&uacute;mina (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorlabenc','nme'=>'Tratamientos - Realizados - Sorafenib - Laboratorio - Encefalopatia Portosistemica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorlabasc','nme'=>'Tratamientos - Realizados - Sorafenib - Laboratorio - ASCITIS');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorlabrec','nme'=>'Tratamientos - Realizados - Sorafenib - Laboratorio - Recuento de Plaquetas (en mm3)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorlabafp','nme'=>'Tratamientos - Realizados - Sorafenib - Laboratorio - AFP al diagnostico - Alfa-fetoproteina (AFP) en ng/ml', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasordte','nme'=>'Tratamientos - Realizados - Sorafenib - Fecha Inicio');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasordssini','nme'=>'Tratamientos - Realizados - Sorafenib - Dosis de Inicio en mg', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasordssmax','nme'=>'Tratamientos - Realizados - Sorafenib - Dosis M&aacute;xima en mg', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorreddss','nme'=>'Tratamientos - Realizados - Sorafenib - Reducci&oacute;n de Dosis en mg');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorreddssdte','nme'=>'Tratamientos - Realizados - Sorafenib - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorreddssmtv','nme'=>'Tratamientos - Realizados - Sorafenib - Motivo de Reducci&oacute;n de Dosis en mg');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoreftadvsev','nme'=>'Tratamientos - Realizados - Sorafenib - Severidad efectos adversos acorde NCTA 4.0');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoreftadv001','nme'=>'Tratamientos - Realizados - Sorafenib - Efectos adversos - Fatiga', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoreftadv002','nme'=>'Tratamientos - Realizados - Sorafenib - Efectos adversos - Diarrea', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoreftadv003','nme'=>'Tratamientos - Realizados - Sorafenib - Efectos adversos - Rash', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoreftadv004','nme'=>'Tratamientos - Realizados - Sorafenib - Efectos adversos - Sindrome de Mano-Pie', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoreftadv005','nme'=>'Tratamientos - Realizados - Sorafenib - Efectos adversos - Hipertension Arterial', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoreftadv006','nme'=>'Tratamientos - Realizados - Sorafenib - Efectos adversos - Sangrado', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoreftadv007','nme'=>'Tratamientos - Realizados - Sorafenib - Efectos adversos - Evento Cardiovascular', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoreftadv008','nme'=>'Tratamientos - Realizados - Sorafenib - Efectos adversos - Dato no disponible', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoreftadv009','nme'=>'Tratamientos - Realizados - Sorafenib - Efectos adversos - Otro', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoreftadvotr','nme'=>'Tratamientos - Realizados - Sorafenib - Efectos adversos - Otro Indique');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorcncdte','nme'=>'Tratamientos - Realizados - Sorafenib - Fecha de Discontinuaci&oacute;n permanente');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorcncmtv001','nme'=>'Tratamientos - Realizados - Sorafenib - Motivo de Discontinuaci&oacute;n permanente - Intolerancia', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorcncmtv002','nme'=>'Tratamientos - Realizados - Sorafenib - Motivo de Discontinuaci&oacute;n permanente - Progresion de la Enfermedad Hepatica (>= 2 puntos de score de Child Pugh)', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorcncmtv003','nme'=>'Tratamientos - Realizados - Sorafenib - Motivo de Discontinuaci&oacute;n permanente - Progresion de Enfermedad Tumoral', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorcncmtv003typ','nme'=>'Tratamientos - Realizados - Sorafenib - Motivo de Discontinuaci&oacute;n permanente - Indique');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorcncmtv004','nme'=>'Tratamientos - Realizados - Sorafenib - Motivo de Discontinuaci&oacute;n permanente - Progresion Sintomatica (ECOG=4)', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorcncmtv005','nme'=>'Tratamientos - Realizados - Sorafenib - Motivo de Discontinuaci&oacute;n permanente - Otro', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasorcncmtvotr','nme'=>'Tratamientos - Realizados - Sorafenib - Motivo de Discontinuaci&oacute;n permanente - Otro - Indique');
				
				// Lenvatinib
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralen','nme'=>'Tratamientos - Realizados - Lenvatinib');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralenbcl','nme'=>'Tratamientos - Realizados - Lenvatinib - Estad&iacute;o BCLC previo al tratamiento acorde a juicio cl&iacute;nico subjetivo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralennumnod','nme'=>'Tratamientos - Realizados - Lenvatinib - N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralenhccdif','nme'=>'Tratamientos - Realizados - Lenvatinib - HCC difuso');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralentamnod','nme'=>'Tratamientos - Realizados - Lenvatinib - Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralensumnod','nme'=>'Tratamientos - Realizados - Lenvatinib - Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraleninvtum','nme'=>'Tratamientos - Realizados - Lenvatinib - Invasi&oacute;n tumoral macrovascular Diagnostico por imagenes');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralenenfext','nme'=>'Tratamientos - Realizados - Lenvatinib - Enfermedad Extrahep&aacute;tica HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralenenfextotr','nme'=>'Tratamientos - Realizados - Lenvatinib - Cual otra localizaci&oacute;n metast&aacute;sica?');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralenecg','nme'=>'Tratamientos - Realizados - Lenvatinib - Performance Status ECOG');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralenlabbil','nme'=>'Tratamientos - Realizados - Lenvatinib - Laboratorio - Bilirrubina Total (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralenlabrin','nme'=>'Tratamientos - Realizados - Lenvatinib - Laboratorio - RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralenlabalb','nme'=>'Tratamientos - Realizados - Lenvatinib - Laboratorio - Alb&uacute;mina (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralenlabenc','nme'=>'Tratamientos - Realizados - Lenvatinib - Laboratorio - Encefalopatia Portosistemica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralenlabasc','nme'=>'Tratamientos - Realizados - Lenvatinib - Laboratorio - ASCITIS');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralenlabrec','nme'=>'Tratamientos - Realizados - Lenvatinib - Laboratorio - Recuento de Plaquetas (en mm3)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralenlabafp','nme'=>'Tratamientos - Realizados - Lenvatinib - Laboratorio - AFP al diagnostico - Alfa-fetoproteina (AFP) en ng/ml', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralendte','nme'=>'Tratamientos - Realizados - Lenvatinib - Fecha Inicio');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralendssini','nme'=>'Tratamientos - Realizados - Lenvatinib - Dosis de Inicio en mg', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralendssmax','nme'=>'Tratamientos - Realizados - Lenvatinib - Dosis M&aacute;xima en mg', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralenreddss','nme'=>'Tratamientos - Realizados - Lenvatinib - Reducci&oacute;n de Dosis en mg');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralenreddssdte','nme'=>'Tratamientos - Realizados - Lenvatinib - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralenreddssmtv','nme'=>'Tratamientos - Realizados - Lenvatinib - Motivo de Reducci&oacute;n de Dosis en mg');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraleneftadvsev','nme'=>'Tratamientos - Realizados - Lenvatinib - Severidad efectos adversos acorde NCTA 4.0');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraleneftadv001','nme'=>'Tratamientos - Realizados - Lenvatinib - Efectos adversos - Fatiga', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraleneftadv002','nme'=>'Tratamientos - Realizados - Lenvatinib - Efectos adversos - Diarrea', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraleneftadv003','nme'=>'Tratamientos - Realizados - Lenvatinib - Efectos adversos - Rash', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraleneftadv004','nme'=>'Tratamientos - Realizados - Lenvatinib - Efectos adversos - Sindrome de Mano-Pie', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraleneftadv005','nme'=>'Tratamientos - Realizados - Lenvatinib - Efectos adversos - Hipertension Arterial', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraleneftadv006','nme'=>'Tratamientos - Realizados - Lenvatinib - Efectos adversos - Sangrado', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraleneftadv007','nme'=>'Tratamientos - Realizados - Lenvatinib - Efectos adversos - Evento Cardiovascular', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraleneftadv008','nme'=>'Tratamientos - Realizados - Lenvatinib - Efectos adversos - Hipotiroidismo', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraleneftadv009','nme'=>'Tratamientos - Realizados - Lenvatinib - Efectos adversos - Otro', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraleneftadvotr','nme'=>'Tratamientos - Realizados - Lenvatinib - Efectos adversos - Otro - Indique');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralencncdte','nme'=>'Tratamientos - Realizados - Lenvatinib - Fecha de Discontinuaci&oacute;n permanente');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralencncmtv001','nme'=>'Tratamientos - Realizados - Lenvatinib - Motivo de Discontinuaci&oacute;n permanente - Intolerancia', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralencncmtv002','nme'=>'Tratamientos - Realizados - Lenvatinib - Motivo de Discontinuaci&oacute;n permanente - Progresion de la Enfermedad Hepatica (>= 2 puntos de score de Child Pugh)', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralencncmtv003','nme'=>'Tratamientos - Realizados - Lenvatinib - Motivo de Discontinuaci&oacute;n permanente - Progresion de Enfermedad Tumoral', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralencncmtv003typ','nme'=>'Tratamientos - Realizados - Lenvatinib - Motivo de Discontinuaci&oacute;n permanente - Progresion de Enfermedad Tumoral - Indique');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralencncmtv004','nme'=>'Tratamientos - Realizados - Lenvatinib - Motivo de Discontinuaci&oacute;n permanente - Progresion Sintomatica (ECOG=4)', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralencncmtv005','nme'=>'Tratamientos - Realizados - Lenvatinib - Motivo de Discontinuaci&oacute;n permanente - Otro', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtralencncmtvotr','nme'=>'Tratamientos - Realizados - Lenvatinib - Motivo de Discontinuaci&oacute;n permanente - Otro - Indique');

				// Atezolizumab + Bevacizumab
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraate','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatebcl','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Estad&iacute;o BCLC previo al tratamiento acorde a juicio cl&iacute;nico subjetivo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatenumnod','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatehccdif','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - HCC difuso');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatetamnod','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatesumnod','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateinvtum','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Invasi&oacute;n tumoral macrovascular Diagnostico por imagenes');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateenfext','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Enfermedad Extrahep&aacute;tica HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateenfextotr','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Cual otra localizaci&oacute;n metast&aacute;sica?');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateecg','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Performance Status ECOG');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatelabbil','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Laboratorio - Bilirrubina Total (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatelabrin','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Laboratorio - RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatelabalb','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Laboratorio - Alb&uacute;mina (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatelabenc','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Laboratorio - Encefalopatia Portosistemica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatelabasc','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Laboratorio - ASCITIS');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatelabrec','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Laboratorio - Recuento de Plaquetas (en mm3)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatelabafp','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Laboratorio - AFP al diagnostico - Alfa-fetoproteina (AFP) en ng/ml', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatedte','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Fecha Inicio Atezo + Beva');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatedssiniate','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - N&uacute;mero de ciclos Atezolizumab', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatedssinibev','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - N&uacute;mero de ciclos Bevacizumab', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatereddss','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Reducci&oacute;n de n&uacute;mero de ciclos de Atezo + Beva');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatereddssdte','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatereddssmtv','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Motivo de Reducci&oacute;n de n&uacute;mero de ciclos de Atezo + Beva');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateeftadvsev','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Severidad efectos adversos acorde NCTA 4.0');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateeftadv001','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Efectos adversos a Atezo + Beva - Fatiga', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateeftadv002','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Efectos adversos a Atezo + Beva - Diarrea', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateeftadv003','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Efectos adversos a Atezo + Beva - Rash', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateeftadv004','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Efectos adversos a Atezo + Beva - Sindrome de Mano-Pie', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateeftadv005','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Efectos adversos a Atezo + Beva - Hipertension Arterial', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateeftadv006','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Efectos adversos a Atezo + Beva - Sangrado', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateeftadv007','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Efectos adversos a Atezo + Beva - Evento Cardiovascular', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateeftadv008','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Efectos adversos a Atezo + Beva - Dato no disponible', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateeftadv009','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Efectos adversos a Atezo + Beva - Otro', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateeftadvotr','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Efectos adversos a Atezo + Beva - Otro Indique');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiraeftadv001','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - irAEs eventos adversos inmunomediados - Hepatitis', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiraeftadv002','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - irAEs eventos adversos inmunomediados - Aumento de bilirrubina', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiraeftadv003','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - irAEs eventos adversos inmunomediados - Hipo/hipertiroidismo', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiraeftadv004','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - irAEs eventos adversos inmunomediados - Hipofisitis', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiraeftadv005','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - irAEs eventos adversos inmunomediados - Adrenalitis', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiraeftadv006','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - irAEs eventos adversos inmunomediados - DBT', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiraeftadv007','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - irAEs eventos adversos inmunomediados - Neumonitis', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiraeftadv008','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - irAEs eventos adversos inmunomediados - Diarrea o colitis', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiraeftadv009','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - irAEs eventos adversos inmunomediados - Nefritis', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiraeftadv010','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - irAEs eventos adversos inmunomediados - Miositis', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiraeftadv011','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - irAEs eventos adversos inmunomediados - Miocarditis', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiraeftadv012','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - irAEs eventos adversos inmunomediados - SNC o perif&eacute;rico', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiradte','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Fecha del Primer irAE');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiratra','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Tratamiento del irAE');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateirares','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Resolución del irAE');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiraresdte','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Fecha de resoluci&oacute;n irAE');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateirapos','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Rechallenge de post irAE');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateiraposdte','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Fecha reinicio');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateirarec','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Recidiva de irAE post re-inicio');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraateirarecdte','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Fecha de recidiva');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatecncdte','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Fecha de Discontinuaci&oacute;n permanente de Atezo + Beva');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatecncmtv001','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Motivo de Discontinuaci&oacute;n permanente de Atezo + Beva - Intolerancia o Efecto Adverso Moderado-Severo', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatecncmtv002','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Motivo de Discontinuaci&oacute;n permanente de Atezo + Beva - Progresion de la Enfermedad Hepatica (>= 2 puntos de score de Child Pugh)', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatecncmtv003','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Motivo de Discontinuaci&oacute;n permanente de Atezo + Beva - Progresion de Enfermedad Tumoral', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatecncmtv003typ','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Motivo de Discontinuaci&oacute;n permanente de Atezo + Beva - Progresion de Enfermedad Tumoral Indique');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatecncmtv004','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Motivo de Discontinuaci&oacute;n permanente de Atezo + Beva - Progresion Sintomatica (ECOG=4)', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatecncmtv005','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Motivo de Discontinuaci&oacute;n permanente de Atezo + Beva - Otro', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraatecncmtvotr','nme'=>'Tratamientos - Realizados - Atezolizumab Bevacizumab - Motivo de Discontinuaci&oacute;n permanente de Atezo + Beva - Otro Indique');

				// Otros Tratamientos
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtra','nme'=>'Tratamientos - Realizados - Otros Tratamientos');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtratyp','nme'=>'Tratamientos - Realizados - Otros Tratamientos Indique');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtradte','nme'=>'Tratamientos - Realizados - Otros Tratamientos - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtrabcl','nme'=>'Tratamientos - Realizados - Otros Tratamientos - Estad&iacute;o BCLC previo al tratamiento acorde a juicio cl&iacute;nico subjetivo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtranumnod','nme'=>'Tratamientos - Realizados - Otros Tratamientos - N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtrahccdif','nme'=>'Tratamientos - Realizados - Otros Tratamientos - HCC difuso');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtratamnod','nme'=>'Tratamientos - Realizados - Otros Tratamientos - Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtrasumnod','nme'=>'Tratamientos - Realizados - Otros Tratamientos - Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtrainvtum','nme'=>'Tratamientos - Realizados - Otros Tratamientos - Invasi&oacute;n tumoral macrovascular Diagnostico por imagenes');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtraenfext','nme'=>'Tratamientos - Realizados - Otros Tratamientos - Enfermedad Extrahep&aacute;tica HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtraenfextotr','nme'=>'Tratamientos - Realizados - Otros Tratamientos - Cual otra localizaci&oacute;n metast&aacute;sica?');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtraecg','nme'=>'Tratamientos - Realizados - Otros Tratamientos - Performance Status ECOG');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtralabbil','nme'=>'Tratamientos - Realizados - Otros Tratamientos - Laboratorio - Bilirrubina Total (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtralabrin','nme'=>'Tratamientos - Realizados - Otros Tratamientos - Laboratorio - RIN', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtralabalb','nme'=>'Tratamientos - Realizados - Otros Tratamientos - Laboratorio - Alb&uacute;mina (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtralabenc','nme'=>'Tratamientos - Realizados - Otros Tratamientos - Laboratorio - Encefalopatia Portosistemica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtralabasc','nme'=>'Tratamientos - Realizados - Otros Tratamientos - Laboratorio - ASCITIS');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtralabrec','nme'=>'Tratamientos - Realizados - Otros Tratamientos - Laboratorio - Recuento de Plaquetas (en mm3)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraotrtralabafp','nme'=>'Tratamientos - Realizados - Otros Tratamientos - Laboratorio - AFP al diagnostico - Alfa-fetoproteina (AFP) en ng/ml', 'typ'=>'number');

				// Soporte Paliativo
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppal','nme'=>'Tratamientos - Realizados - Soporte Paliativo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppaldte','nme'=>'Tratamientos - Realizados - Soporte Paliativo - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppalbcl','nme'=>'Tratamientos - Realizados - Soporte Paliativo - Estad&iacute;o BCLC previo al tratamiento acorde a juicio cl&iacute;nico subjetivo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppalnumnod','nme'=>'Tratamientos - Realizados - Soporte Paliativo - N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppalhccdif','nme'=>'Tratamientos - Realizados - Soporte Paliativo - HCC difuso');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppaltamnod','nme'=>'Tratamientos - Realizados - Soporte Paliativo - Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppalsumnod','nme'=>'Tratamientos - Realizados - Soporte Paliativo - Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppalinvtum','nme'=>'Tratamientos - Realizados - Soporte Paliativo - Invasi&oacute;n tumoral macrovascular Diagnostico por imagenes');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppalenfext','nme'=>'Tratamientos - Realizados - Soporte Paliativo - Enfermedad Extrahep&aacute;tica HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppalenfextotr','nme'=>'Tratamientos - Realizados - Soporte Paliativo - Cual otra localizaci&oacute;n metast&aacute;sica?');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppalecg','nme'=>'Tratamientos - Realizados - Soporte Paliativo - Performance Status ECOG');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppallabbil','nme'=>'Tratamientos - Realizados - Soporte Paliativo - Laboratorio - Bilirrubina Total (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppallabrin','nme'=>'Tratamientos - Realizados - Soporte Paliativo - Laboratorio - RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppallabalb','nme'=>'Tratamientos - Realizados - Soporte Paliativo - Laboratorio - Alb&uacute;mina (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppallabenc','nme'=>'Tratamientos - Realizados - Soporte Paliativo - Laboratorio - Encefalopatia Portosistemica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppallabasc','nme'=>'Tratamientos - Realizados - Soporte Paliativo - Laboratorio - ASCITIS');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppallabrec','nme'=>'Tratamientos - Realizados - Soporte Paliativo - Laboratorio - Recuento de Plaquetas (en mm3)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrasoppallabafp','nme'=>'Tratamientos - Realizados - Soporte Paliativo - Laboratorio - AFP al diagnostico - Alfa-fetoproteina (AFP) en ng/ml', 'typ'=>'number');

				// Sist&eacute;mico de Segunda L&iacute;nea
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2da','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2dadte','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Fecha');

				// Cabozantinib
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracab','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabbcl','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Estad&iacute;o BCLC previo al tratamiento acorde a juicio cl&iacute;nico subjetivo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabnumnod','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabhccdif','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - HCC difuso');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabtamnod','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabsumnod','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabinvtum','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Invasi&oacute;n tumoral macrovascular Diagnostico por imagenes');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabenfext','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Enfermedad Extrahep&aacute;tica HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabenfextotr','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Cual otra localizaci&oacute;n metast&aacute;sica?');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabecg','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Performance Status ECOG');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracablabbil','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Laboratorio - Bilirrubina Total (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracablabrin','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Laboratorio - RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracablabalb','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Laboratorio - Alb&uacute;mina (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracablabenc','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Laboratorio - Encefalopatia Portosistemica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracablabasc','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Laboratorio - ASCITIS');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracablabrec','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Laboratorio - Recuento de Plaquetas (en mm3)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracablabafp','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Laboratorio - AFP al diagnostico - Alfa-fetoproteina (AFP) en ng/ml', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabdte','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Fecha Inicio');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabnomcom','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Nombre Comercial');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabdssini','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Dosis de Inicio en mg', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabdssmax','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Dosis M&aacute;xima en mg', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabreddss','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Reducci&oacute;n de Dosis en mg');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabreddssdte','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabreddssmtv','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Motivo de Reducci&oacute;n de Dosis en mg');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabeftadvsev','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Severidad efectos adversos acorde NCTA 4.0');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabeftadv001','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Efectos adversos - Fatiga', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabeftadv002','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Efectos adversos - Diarrea', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabeftadv003','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Efectos adversos - Rash', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabeftadv004','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Efectos adversos - Sindrome de Mano-Pie', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabeftadv005','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Efectos adversos - Hipertension Arterial', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabeftadv006','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Efectos adversos - Sangrado', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabeftadv007','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Efectos adversos - Evento Cardiovascular', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabeftadv008','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Efectos adversos - Proteinuria', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabeftadv009','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Efectos adversos - Prolongacion del QTc', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabeftadv010','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Efectos adversos - Hematologico', 'typ'=>'checkbox');				
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabeftadv011','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Efectos adversos - Dato no disponible', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabeftadv012','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Efectos adversos - Otro', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabeftadvotr','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Efectos adversos - Otro Indique');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabcncdte','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Fecha de Discontinuaci&oacute;n permanente');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabcncmtv001','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Motivo de Discontinuaci&oacute;n permanente - Intolerancia o Efecto Adverso Moderado-Severo', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabcncmtv002','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Motivo de Discontinuaci&oacute;n permanente - Progresion de la Enfermedad Hepatica (>= 2 puntos de score de Child Pugh)', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabcncmtv003','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Motivo de Discontinuaci&oacute;n permanente - Progresion de Enfermedad Tumoral', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabcncmtv003typ','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Motivo de Discontinuaci&oacute;n permanente - Progresion de Enfermedad Tumoral Indique');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabcncmtv004','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Motivo de Discontinuaci&oacute;n permanente - Progresion Sintomatica (ECOG=4)', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabcncmtv005','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Motivo de Discontinuaci&oacute;n permanente - Otro', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtracabcncmtvotr','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Cabozantinib - Motivo de Discontinuaci&oacute;n permanente - Otro Indique');

				// Regorafenib
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrareg','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregbcl','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Estad&iacute;o BCLC previo al tratamiento acorde a juicio cl&iacute;nico subjetivo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregnumnod','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrareghccdif','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - HCC difuso');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregtamnod','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregsumnod','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrareginvtum','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Invasi&oacute;n tumoral macrovascular Diagnostico por imagenes');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregenfext','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Enfermedad Extrahep&aacute;tica HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregenfextotr','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Cual otra localizaci&oacute;n metast&aacute;sica?');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregecg','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Performance Status ECOG');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrareglabbil','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Laboratorio - Bilirrubina Total (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrareglabrin','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Laboratorio - RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrareglabalb','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Laboratorio - Alb&uacute;mina (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrareglabenc','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Laboratorio - Encefalopatia Portosistemica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrareglabasc','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Laboratorio - ASCITIS');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrareglabrec','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Laboratorio - Recuento de Plaquetas (en mm3)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrareglabafp','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Laboratorio - AFP al diagnostico - Alfa-fetoproteina (AFP) en ng/ml', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregdte','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Fecha Inicio');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregdssini','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Dosis de Inicio en mg', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregdssmax','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Dosis M&aacute;xima en mg', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregreddss','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Reducci&oacute;n de Dosis en mg');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregreddssdte','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregreddssmtv','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Motivo de Reducci&oacute;n de Dosis en mg');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregeftadvsev','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Severidad efectos adversos acorde NCTA 4.0');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregeftadv001','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Efectos adversos - Fatiga', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregeftadv002','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Efectos adversos - Diarrea', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregeftadv003','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Efectos adversos - Rash', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregeftadv004','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Efectos adversos - Sindrome de Mano-Pie', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregeftadv005','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Efectos adversos - Hipertension Arterial', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregeftadv006','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Efectos adversos - Sangrado', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregeftadv007','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Efectos adversos - Evento Cardiovascular', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregeftadv008','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Efectos adversos - Dato no disponible', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregeftadv009','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Efectos adversos - Otro', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregeftadvotr','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Efectos adversos - Otro Indique');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregcncdte','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Fecha de Discontinuaci&oacute;n permanente');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregcncmtv001','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Motivo de Discontinuaci&oacute;n permanente - Intolerancia o Efecto Adverso Moderado-Severo', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregcncmtv002','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Motivo de Discontinuaci&oacute;n permanente - Progresion de la Enfermedad Hepatica (>= 2 puntos de score de Child Pugh)', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregcncmtv003','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Motivo de Discontinuaci&oacute;n permanente - Progresion de Enfermedad Tumoral', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregcncmtv003typ','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Motivo de Discontinuaci&oacute;n permanente - Progresion de Enfermedad Tumoral Indique');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregcncmtv004','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Motivo de Discontinuaci&oacute;n permanente - Progresion Sintomatica (ECOG=4)', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregcncmtv005','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Motivo de Discontinuaci&oacute;n permanente - Otro', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtraregcncmtvotr','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Regorafenib - Motivo de Discontinuaci&oacute;n permanente - Otro Indique');

				// Inmunoterapia
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainm','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmtra','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Tratamiento');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmdte','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmbcl','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Estad&iacute;o BCLC previo al tratamiento acorde a juicio cl&iacute;nico subjetivo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmnumnod','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmhccdif','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - HCC difuso');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmtamnod','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmsumnod','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainminvtum','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Invasi&oacute;n tumoral macrovascular Diagnostico por imagenes');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmenfext','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Enfermedad Extrahep&aacute;tica HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmenfextotr','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Cual otra localizaci&oacute;n metast&aacute;sica?');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmecg','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Performance Status ECOG');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmlabbil','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Laboratorio - Bilirrubina Total (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmlabrin','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Laboratorio - RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmlabalb','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Laboratorio - Alb&uacute;mina (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmlabenc','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Laboratorio - Encefalopatia Portosistemica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmlabasc','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Laboratorio - ASCITIS');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmlabrec','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Laboratorio - Recuento de Plaquetas (en mm3)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmlabafp','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Laboratorio - AFP al diagnostico - Alfa-fetoproteina (AFP) en ng/ml', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainminidte','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Fecha Inicio');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmdssini','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - N&uacute;mero de ciclos de Inicio', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmdssmax','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - N&uacute;mero de ciclos M&aacute;xima', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmreddss','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Reducci&oacute;n de n&uacute;mero de ciclos');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmreddssdte','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmreddssmtv','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Motivo de Reducci&oacute;n de n&uacute;mero de ciclos');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmeftadvsev','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Severidad efectos adversos acorde NCTA 4.0');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmeftadv001','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Efectos adversos - Fatiga', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmeftadv002','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Efectos adversos - Colitis autoinmune', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmeftadv003','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Efectos adversos - Dermatitis autoinmune', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmeftadv004','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Efectos adversos - Hepatitis autoinmune', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmeftadv005','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Efectos adversos - Tiroiditis autoinmune', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmeftadv006','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Efectos adversos - Adrenalitis autoinmune', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmeftadv007','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Efectos adversos - Hipofisitis autoinmune', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmeftadv008','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Efectos adversos - Nuemonitis autoinmune', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmeftadv009','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Efectos adversos - Cardiopatia inmunologica', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmeftadvcor','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Requerimiento de corticoides', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmcncdte','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Fecha de Discontinuaci&oacute;n permanente');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmcncmtv001','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Motivo de Discontinuaci&oacute;n permanente - Intolerancia o Efecto Adverso Moderado-Severo', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmcncmtv002','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Motivo de Discontinuaci&oacute;n permanente - Progresion de la Enfermedad Hepatica (>= 2 puntos de score de Child Pugh)', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmcncmtv003','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Motivo de Discontinuaci&oacute;n permanente - Progresion de Enfermedad Tumoral', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmcncmtv003typ','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Motivo de Discontinuaci&oacute;n permanente - Progresion de Enfermedad Tumoral Indique');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmcncmtv004','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Motivo de Discontinuaci&oacute;n permanente - Progresion Sintomatica (ECOG=4)', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmcncmtv005','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Motivo de Discontinuaci&oacute;n permanente - Otro', 'typ'=>'checkbox');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrainmcncmtvotr','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Inmunoterapia - Motivo de Discontinuaci&oacute;n permanente - Otro Indique');

				// Otro
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotr','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrmtv','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Indique');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrdte','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Fecha');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrbcl','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Estad&iacute;o BCLC previo al tratamiento acorde a juicio cl&iacute;nico subjetivo');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrnumnod','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrhccdif','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - HCC difuso');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrtamnod','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrsumnod','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN Indicar en mm', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrinvtum','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Invasi&oacute;n tumoral macrovascular Diagnostico por imagenes');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrenfext','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Enfermedad Extrahep&aacute;tica HCC');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrenfextotr','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Cual otra localizaci&oacute;n metast&aacute;sica?');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrecg','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Performance Status ECOG');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrlabbil','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Laboratorio - Bilirrubina Total (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrlabrin','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Laboratorio - RIN', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrlabalb','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Laboratorio - Alb&uacute;mina (mg/dL)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrlabenc','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Laboratorio - Encefalopatia Portosistemica');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrlabasc','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Laboratorio - ASCITIS');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrlabrec','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Laboratorio - Recuento de Plaquetas (en mm3)', 'typ'=>'number');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtra2daotrlabafp','nme'=>'Tratamientos - Sist&eacute;mico de Segunda L&iacute;nea - Otro - Laboratorio - AFP al diagnostico - Alfa-fetoproteina (AFP) en ng/ml', 'typ'=>'number');

				// Recurrencia HCC
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrarechep','nme'=>'Tratamientos - Recurrencia HCC - Recurrencia de Hepatocarcinoma Luego de Ablaci&oacute;n por Radiofrecuencia y/o Reseccion Quirurgica Unicamente completar si fue con intencion curativa');
				$lv_cols[] = array('mdl'=>'evlspc','fld'=>'frmtrarechepdte','nme'=>'Tratamientos - Recurrencia HCC - Fecha');

				
				// para cada evolucion encontrada
				$lv_buffer_body = '';
				foreach($lo_patevlspc_rs as $lv_rowevlspc){
					$lv_evlspcdat = $lv_rowevlspc['evlatrval001'].$lv_rowevlspc['evlatrval002'].$lv_rowevlspc['evlatrval003'].$lv_rowevlspc['evlatrval004'].$lv_rowevlspc['evlatrval005'].$lv_rowevlspc['evlatrval006'].$lv_rowevlspc['evlatrval007'].$lv_rowevlspc['evlatrval008'].$lv_rowevlspc['evlatrval009'];
					$lv_buffer_row = '';
					
					// recorro todas las columnas a mostrar
					foreach($lv_cols as $lv_rowcol) {
						$lv_val = '';
						// datos de pacientes
						if($lv_rowcol['mdl']=='pat'){
							if(isset( $lv_rowpat[ $lv_rowevlspc['patcod'] ][ $lv_rowcol['fld'] ])){
								$lv_val = $lv_rowpat[ $lv_rowevlspc['patcod'] ][ $lv_rowcol['fld'] ];
							}
						// datos de direccion
						} else if($lv_rowcol['mdl']=='patadr'){
							if(isset( $lv_rowpatadr[ $lv_rowevlspc['patcod'] ][ $lv_rowcol['fld'] ])){
								$lv_val = $lv_rowpatadr[ $lv_rowevlspc['patcod'] ][ $lv_rowcol['fld'] ];
							}
						// datos de evolucion especialidad
						} else if($lv_rowcol['mdl']=='evlspc'){
							$lv_val = $this->co_reg->document->getTagValue( $lv_evlspcdat, $lv_rowcol['fld'] );
						}
      
           	// cambio formato segun tipo de campo
            $lv_val = $this->checkTyp( $lv_rowcol, $lv_val);
						$lv_buffer_row .= '<td>'.$lv_val.'</td>';
					}
					
					$lv_buffer_body .= '<tr>'.$lv_buffer_row.'</tr>';
				}
				
				// muestro datos
				$lv_buffer = '<table style="border: #000000 1px solid;"><thead><tr style="background-color: #f1f1f1; border: #000000 1px solid;">';
				foreach($lv_cols as $lv_row) { $lv_buffer .= '<th>'.$lv_row['nme'].'</th>'; }
				$lv_buffer .= '</tr></thead><tbody>';
				$lv_buffer .= $lv_buffer_body;
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
            return $this->co_reg->document->getJson( array('errcod'=>$lo_patevlspc->errcod, 'errtxt'=>$lo_patevlspc->errtxt, 'errsrc'=>'zcuau1.149') );
					} else {
						$this->lo_mdl->evlspccod = $lo_patevlspc->evlspccod;
						$this->getEvlSpcDat( $lo_patevlspc );
					}

				}
			}
					
		} else {
			$lo_pat->create();
		}
		
		return $this->co_reg->document->getView( 'zcuau1_hcc', array('data'=>$this->lo_mdl,'pat'=>$lo_pat,'patevl'=>$lo_patevl,'patevlspc'=>$lo_patevlspc,'patpln'=>$lo_patplnevl_rs2,'actcod'=>$this->data['actcod']) );
	}
	
	
	// getFieldsArray. Devuelve un array con los nombres de los campos
	private function getFieldsArray() {
		$lv_fldarr = array();
		$lv_fldarr[1] = array('patage','patwgt','pathgh','frmpatdemviv','frmpatdemvivdte','frmpatdemvivmtv','frmpatdemlstflwdte','frmptohccdte','frmptohccecg','frmptohccenf','frmptohccmthval','frmptohcclabbil','frmptohcclabrin','frmptohcclabalb','frmptohcclabepr','frmptohcclabasc','frmptohcclabrec','frmptohcclabafp','frmptohccenddig','frmptohcccom','frmptohcceticrr','frmptohcceticrrotr','frmptohcchptbbb','frmptohcchptbbbtra','frmptohcchptbbbcar','frmptohccgenhcv');
		$lv_fldarr[2] = array('frmptohccscreco001','frmptohccscrecoult','frmptohccscreconro','frmptohccscrecotam','frmptohccdiamth001','frmptohccdiamth002','frmptohccdiamth003','frmptohcctacnum','frmptohcctactam','frmptohcctacsum','frmptohccinvtummac','frmptohccenfext','frmptohccotrlocmet','frmtraabl','frmtraablbcl','frmtraablnumnod','frmtraablhccdif','frmtraabltamnod','frmtraablsumnod','frmtraablinvtum','frmtraablenfext','frmtraablenfextotr','frmtraablecg','frmtraabllabbil','frmtraabllabrin','frmtraabllabalb','frmtraabllabenc','frmtraabllabasc','frmtraabllabrec','frmtraabllabafp','frmtraablnum','pattraablses001dte','pattraablses001evl','pattraablses001evldte','pattraablses002dte','pattraablses002evl','pattraablses002evldte','frmptobcl');
		$lv_fldarr[3] = array('frmtraresqui001','frmtraresquibcl','frmtraresquinumnod','frmtraresquihccdif','frmtraresquitamnod','frmtraresquisumnod','frmtraresquiinvtum','frmtraresquienfext','frmtraresquienfextotr','frmtraresquiecg','frmtraresquilabbil','frmtraresquilabrin','frmtraresquilabalb','frmtraresquilabenc','frmtraresquilabasc','frmtraresquilabrec','frmtraresquilabafp','frmtraresquinum','frmtraresquityp','frmtraresquidte','frmtraresquievl','frmtraresquievldte','frmtratsphep','frmtratsphepevl','frmtratsphepevldte','frmtratspheptyp','frmtratspheptypdte','frmtraqui','frmtraquibcl','frmtraquinumnod','frmtraquihccdif','frmtraquitamnod','frmtraquisumnod','frmtraquiinvtum','frmtraquienfext','frmtraquienfextotr','frmtraquiecg','frmtraquilabbil','frmtraquilabrin','frmtraquilabalb','frmtraquilabenc','frmtraquilabasc','frmtraquilabrec','frmtraquilabafp','frmtraquitra','frmtraquitranum','frmtraprc001dte','frmtraprc001evlrad','frmtraprc001evlraddte','frmtraprc002dte','frmtraprc002evlrad','frmtraprc002evlraddte');
		$lv_fldarr[4] = array('frmtratsphepbcl','frmtratsphepnumnod','frmtratsphephccdif','frmtratspheptamnod','frmtratsphepsumnod','frmtratsphepinvtum','frmtratsphepenfext','frmtratsphepenfextotr','frmtratsphepecg','frmtratspheplabbil','frmtratspheplabrin','frmtratspheplabalb','frmtratspheplabenc','frmtratspheplabasc','frmtratspheplabrec','frmtratspheplabafp','frmtraradytr','frmtraradytrbcl','frmtraradnumnod','frmtraradhccdif','frmtraradtamnod','frmtraradsumnod','frmtraradinvtum','frmtraradenfext','frmtraradenfextotr','frmtraradecg','frmtraradlabbil','frmtraradlabrin','frmtraradlabalb','frmtraradlabenc','frmtraradlabasc','frmtraradlabrec','frmtraradlabafp','frmtraradytrdte','frmtraradytrrsp','frmtraradytrdteevl');
		$lv_fldarr[5] = array('frmtrasor','frmtrasorbcl','frmtrasornumnod','frmtrasorhccdif','frmtrasortamnod','frmtrasorsumnod','frmtrasorinvtum','frmtrasorenfext','frmtrasorenfextotr','frmtrasorecg','frmtrasorlabbil','frmtrasorlabrin','frmtrasorlabalb','frmtrasorlabenc','frmtrasorlabasc','frmtrasorlabrec','frmtrasorlabafp','frmtrasordte','frmtrasordssini','frmtrasordssmax','frmtrasorreddss','frmtrasorreddssdte','frmtrasorreddssmtv','frmtrasoreftadvsev','frmtrasoreftadv001','frmtrasoreftadv002','frmtrasoreftadv003','frmtrasoreftadv004','frmtrasoreftadv005','frmtrasoreftadv006','frmtrasoreftadv007','frmtrasoreftadv008','frmtrasoreftadv009','frmtrasoreftadvotr','frmtrasorcncdte','frmtrasorcncmtv001','frmtrasorcncmtv002','frmtrasorcncmtv003','frmtrasorcncmtv003typ','frmtrasorcncmtv004','frmtrasorcncmtv005','frmtrasorcncmtvotr', 'frmtraate','frmtraatebcl','frmtraatenumnod','frmtraatehccdif','frmtraatetamnod','frmtraatesumnod','frmtraateinvtum','frmtraateenfext','frmtraateenfextotr','frmtraateecg','frmtraatelabbil','frmtraatelabrin','frmtraatelabalb','frmtraatelabenc','frmtraatelabasc','frmtraatelabrec','frmtraatelabafp','frmtraatedte','frmtraatedssini','frmtraatedssiniate','frmtraatedssinibev','frmtraatedssmax','frmtraatereddss','frmtraatereddssdte','frmtraatereddssmtv','frmtraateeftadvsev','frmtraateeftadv001','frmtraateeftadv002','frmtraateeftadv003','frmtraateeftadv004','frmtraateeftadv005','frmtraateeftadv006','frmtraateeftadv007','frmtraateeftadv008','frmtraateeftadv009','frmtraateeftadvotr','frmtraatecncdte','frmtraatecncmtv001','frmtraatecncmtv002','frmtraatecncmtv003','frmtraatecncmtv003typ','frmtraatecncmtv004','frmtraatecncmtv005','frmtraatecncmtvotr', 'frmtraateiraeftadv001','frmtraateiraeftadv002','frmtraateiraeftadv003','frmtraateiraeftadv004','frmtraateiraeftadv005','frmtraateiraeftadv006','frmtraateiraeftadv007','frmtraateiraeftadv008','frmtraateiraeftadv009','frmtraateiraeftadv010','frmtraateiraeftadv011','frmtraateiraeftadv012','frmtraateiradte','frmtraateiratra','frmtraateirares','frmtraateiraresdte','frmtraateirapos','frmtraateiraposdte','frmtraateirarec','frmtraateirarecdte');
		$lv_fldarr[6] = array('frmtraotrtra','frmtraotrtratyp','frmtraotrtratyp','frmtraotrtradte','frmtraotrtrabcl','frmtraotrtranumnod','frmtraotrtrahccdif','frmtraotrtratamnod','frmtraotrtrasumnod','frmtraotrtrainvtum','frmtraotrtraenfext','frmtraotrtraenfextotr','frmtraotrtraecg','frmtraotrtralabbil','frmtraotrtralabrin','frmtraotrtralabalb','frmtraotrtralabenc','frmtraotrtralabasc','frmtraotrtralabrec','frmtraotrtralabafp','frmtrasoppal','frmtrasoppaldte','frmtrasoppalbcl','frmtrasoppalnumnod','frmtrasoppalhccdif','frmtrasoppaltamnod','frmtrasoppalsumnod','frmtrasoppalinvtum','frmtrasoppalenfext','frmtrasoppalenfextotr','frmtrasoppalecg','frmtrasoppallabbil','frmtrasoppallabrin','frmtrasoppallabalb','frmtrasoppallabenc','frmtrasoppallabasc','frmtrasoppallabrec','frmtrasoppallabafp','frmtraqsttra001','frmtraqsttra001nos001','frmtraqsttra001nos002','frmtraqsttra001nos003','frmtraqsttra001nos004','frmtraqsttra001nos005','frmtraqsttra001nos006','frmtraqsttra001nos007','frmtraqsttra001nos008','frmtraqsttra001nos009','frmtraqsttra001nos010');
		$lv_fldarr[7] = array('frmtracab','frmtracabbcl','frmtracabnumnod','frmtracabhccdif','frmtracabtamnod','frmtracabsumnod','frmtracabinvtum','frmtracabenfext','frmtracabenfextotr','frmtracabecg','frmtracablabbil','frmtracablabrin','frmtracablabalb','frmtracablabenc','frmtracablabasc','frmtracablabrec','frmtracablabafp','frmtracabdte','frmtracabnomcom','frmtracabdssini','frmtracabdssmax','frmtracabreddss','frmtracabreddssdte','frmtracabreddssmtv','frmtracabeftadvsev','frmtracabeftadv001','frmtracabeftadv002','frmtracabeftadv003','frmtracabeftadv004','frmtracabeftadv005','frmtracabeftadv006','frmtracabeftadv007','frmtracabeftadv008','frmtracabeftadv009','frmtracabeftadv010','frmtracabeftadv011','frmtracabeftadv012','frmtracabeftadvotr','frmtracabcncdte','frmtracabcncmtv001','frmtracabcncmtv002','frmtracabcncmtv003','frmtracabcncmtv003typ','frmtracabcncmtv004','frmtracabcncmtv005','frmtracabcncmtvotr','frmtrareg','frmtraregbcl','frmtraregnumnod','frmtrareghccdif','frmtraregtamnod','frmtraregsumnod','frmtrareginvtum','frmtraregenfext','frmtraregenfextotr','frmtraregecg','frmtrareglabbil','frmtrareglabrin','frmtrareglabalb','frmtrareglabenc','frmtrareglabasc','frmtrareglabrec','frmtrareglabafp','frmtraregdte','frmtraregdssini','frmtraregdssmax','frmtraregreddss','frmtraregreddssdte','frmtraregreddssmtv','frmtraregeftadvsev','frmtraregeftadv001','frmtraregeftadv002','frmtraregeftadv003','frmtraregeftadv004','frmtraregeftadv005','frmtraregeftadv006','frmtraregeftadv007','frmtraregeftadv008','frmtraregeftadv009','frmtraregeftadvotr','frmtraregcncdte','frmtraregcncmtv001','frmtraregcncmtv002','frmtraregcncmtv003','frmtraregcncmtv003typ','frmtraregcncmtv004','frmtraregcncmtv005','frmtraregcncmtvotr');
		$lv_fldarr[8] = array('frmtrainm','frmtrainmtra','frmtrainmdte','frmtrainmbcl','frmtrainmnumnod','frmtrainmhccdif','frmtrainmtamnod','frmtrainmsumnod','frmtrainminvtum','frmtrainmenfext','frmtrainmenfextotr','frmtrainmecg','frmtrainmlabbil','frmtrainmlabrin','frmtrainmlabalb','frmtrainmlabenc','frmtrainmlabasc','frmtrainmlabrec','frmtrainmlabafp','frmtrainminidte','frmtrainmdssini','frmtrainmdssmax','frmtrainmreddss','frmtrainmreddssdte','frmtrainmreddssmtv','frmtrainmeftadvsev','frmtrainmeftadv001','frmtrainmeftadv002','frmtrainmeftadv003','frmtrainmeftadv004','frmtrainmeftadv005','frmtrainmeftadv006','frmtrainmeftadv007','frmtrainmeftadv008','frmtrainmeftadv009','frmtrainmeftadvcor','frmtrainmcncdte','frmtrainmcncmtv001','frmtrainmcncmtv002','frmtrainmcncmtv003','frmtrainmcncmtv003typ','frmtrainmcncmtv004','frmtrainmcncmtv005','frmtrainmcncmtvotr');
		$lv_fldarr[9] = array('frmtra2da','frmtra2daotrbcl','frmtra2daotrnumnod','frmtra2daotrhccdif','frmtra2daotrtamnod','frmtra2daotrsumnod','frmtra2daotrinvtum','frmtra2daotrenfext','frmtra2daotrenfextotr','frmtra2daotrecg','frmtra2daotrlabbil','frmtra2daotrlabrin','frmtra2daotrlabalb','frmtra2daotrlabenc','frmtra2daotrlabasc','frmtra2daotrlabrec','frmtra2daotrlabafp','frmtra2dadte','frmtra2daotr','frmtra2daotrmtv','frmtra2daotrdte','frmtrarechep','frmtrarechepdte','frmtralen','frmtralenbcl','frmtralennumnod','frmtralenhccdif','frmtralentamnod','frmtralensumnod','frmtraleninvtum','frmtralenenfext','frmtralenenfextotr','frmtralenecg','frmtralenlabbil','frmtralenlabrin','frmtralenlabalb','frmtralenlabenc','frmtralenlabasc','frmtralenlabrec','frmtralenlabafp','frmtralendte','frmtralendssini','frmtralendssmax','frmtralenreddss','frmtralenreddssdte','frmtralenreddssmtv','frmtraleneftadvsev','frmtraleneftadv001','frmtraleneftadv002','frmtraleneftadv003','frmtraleneftadv004','frmtraleneftadv005','frmtraleneftadv006','frmtraleneftadv007','frmtraleneftadv008','frmtraleneftadv009','frmtraleneftadvotr','frmtralencncdte','frmtralencncmtv001','frmtralencncmtv002','frmtralencncmtv003','frmtralencncmtv003typ','frmtralencncmtv004','frmtralencncmtv005','frmtralencncmtvotr');
		return $lv_fldarr;
	}	
	
	// setEvlSpcDat. Convierte el formulario (post) en atributos (tags) de campos (evlatrval00?) para grabar en una evolución-especialidad
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
	
	// getEvlSpcDat. Convierte datos de la evolución (tags) en un array de datos del modelo
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

}
?>
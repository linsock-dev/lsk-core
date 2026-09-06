<?php
final class eduplnController extends tmssController {
	const MODEL = 'edupln';	
	const VIEW  = 'eduplnedt';						
	const ID = 'eduplncod';			
	const OBJTYP = 'EDU_PLN';
  protected $co_reg;
	private $lo_mdl;
	private $lo_dtemdl;
  private $data = array();
  
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
  
  
  // INDEX. Metodo principal de la clase  
  public function index( $lp_act , $lp_prm = array() ) {
		
    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		
		// load model
		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		$this->data['actcod'] = $lp_act;
		
		// cargo los modelos que voy a utilizar
		$lo_dtemdl = $this->co_reg->load->model('eduplndte');
		$lo_premdl = $this->co_reg->load->model('eduplnpre');
		$lo_insmdl = $this->co_reg->load->model('eduplnins');
		$lo_mdlvew = $this->co_reg->load->model('grlvew');
		$lo_mdlprm = $this->co_reg->load->model('sysappmdlprm');
		$this->lo_dtemdl = $this->co_reg->load->model('eduplndte');
		
	
		$lo_dat = $this->co_reg->request->post;
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
			
			//   C A L E N D A R I O
      case '#': case '#08':
        
        // PREFERENCIAS. se recuperan las preferencias de usuario
        $lo_usrprfmdl = $this->co_reg->load->model('syssecusrprf');
        $lv_usrpin = '';
        $lv_prm=array('vewfldflt'=>	'[~fltrow~]usrcod'.chr(9).'='.chr(9).chr(9). $this->co_reg->sec->usrcod .chr(9).chr(9)
                                    .'[~fltrow~]usrprfgrp'.chr(9).'='.chr(9).chr(9). 'EDU_PLN' .chr(9).chr(9)
                                    .'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9)
                      );
        $lo_usrprfarr = $lo_usrprfmdl->getList( $lv_prm );
        foreach($lo_usrprfarr as $lv_row){
          if($lv_row['usrprfkey']=='USRPIN'){ $lv_usrpin = trim($lv_row['usrprfval']); }
        }
        $this->lo_mdl->cfg=array('usrpin'=>$lv_usrpin);
        
        return $this->co_reg->document->getView( 'eduplncal', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			// C A L E N D A R I O    -    LISTA DE PRE-INSCRIPCIONES
			case '#calpre':
				// cargo pre-inscripciones
				$lv_prm = array('vewfldflt' =>'[~fltrow~]isnull(p.eduplninscod,0)'.chr(9).'='.chr(9).chr(9).'0'.chr(9).chr(9).
																			'[~fltrow~]isnull(p.stucod,0)'.chr(9).'<>'.chr(9).chr(9).'0'.chr(9).chr(9).
																			'[~fltrow~]isnull(p.edusubcod,0)'.chr(9).'<>'.chr(9).chr(9).'0'.chr(9).chr(9).
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
												'vewfldord' => 'p.eduplnpredte DESC, cast(dbo.getTagValue(^subord^,s.edusubatr) as int)',
												'vewmaxrec' => '9999');
				$lo_rs = $lo_premdl->getlist( $lv_prm, array(), null, false );
				return $this->co_reg->document->getJson( $lo_rs );
				break;			
			
			
			
			// *************************************************
			//
			//   F O R M U L A R I O
			//
			// *************************************************
			//   G R A B A R
      case '#00':

				$lo_dat = $this->co_reg->request->post;
				if($lo_dat['eduplndteend']==''){$lo_dat['eduplndteend']=$lo_dat['eduplndtestr'];}
				
				$lv_plndtecod = $this->co_reg->request->post['eduplndtecod'];
				$lv_plncod = $this->co_reg->request->post['eduplncod'];
				$lo_plnmdl_prv = $this->co_reg->load->model('eduplndte');
				if ( $lv_plndtecod!='' ) { $lo_plnmdl_prv->load( array('eduplncod'=>$lv_plncod,'eduplndtecod'=>$lv_plndtecod) ); }
				
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load(array('sysdocclscod'=>$this->co_reg->request->post['sysdocclscod']));
        
				// grabo documento de cabecera
        if ( $this->lo_mdl->save( $lo_dat ) ) {
					$lo_dat['eduplncod'] = $this->lo_mdl->eduplncod;
					$lo_dat['eduplninbdte'] = $lo_dat['eduplndte'].' '.$lo_dat['eduplninbdte'].':00'; // Inicio con su hora de inicio "14/07/2023 17:00:00"
					$lo_dat['eduplnoutdte'] = $lo_dat['eduplndte'].' '.$lo_dat['eduplnoutdte'].':00'; // Fin "14/07/2023 19:00:00"
					// grabo fecha de planificación
					if ( $lo_dtemdl->save( $lo_dat ) ) {
						$lv_buffer = $lo_dat['eduplnins'];
						if ($lv_buffer!='') {
							$i=0;
							$lv_buffer = html_entity_decode($lv_buffer);
							$lv_stuarr = json_decode($lv_buffer,true);
							foreach( $lv_stuarr as $lv_row ) {
								$lv_row['eduplncod'] = $this->lo_mdl->eduplncod;
								$lv_row['eduplndtecod'] = $lo_dtemdl->eduplndtecod;
								$lv_row['docsts'] = 'A';
								if ( isset($lv_row['deleted']) ) {
									if ($lo_insmdl->delete( $lv_row, false )==false) {
                    return $this->co_reg->document->getJson( array('errtyp'=>$lo_insmdl->errtyp,'errcod'=>$lo_insmdl->errcod,'errtxt'=>$lo_insmdl->errtxt.'<row>'.$i.'</row>') );
									}
								} else if ($lo_insmdl->save( $lv_row, false )==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>$lo_insmdl->errtyp,'errcod'=>$lo_insmdl->errcod,'errtxt'=>$lo_insmdl->errtxt.'<row>'.$i.'</row>') );
								}
								$i++;
							}
						}
					} else {
						return $this->co_reg->document->getJson( array('errtyp'=>$lo_dtemdl->errtyp,'errcod'=>$lo_dtemdl->errcod,'errtxt'=>$lo_dtemdl->errtxt) );
					}
				} else {
					return $this->co_reg->document->getJson( array('errtyp'=>$lo_dtemdl->errtyp,'errcod'=>$lo_dtemdl->errcod,'errtxt'=>$lo_dtemdl->errtxt) );
				}
      
				// cargo nuevamente los datos de planificación
				$this->lo_dtemdl->load( array( 'eduplncod'=>$this->lo_mdl->eduplncod, 'eduplndtecod'=>$lo_dtemdl->eduplndtecod ));
				$this->lo_dtemdl->sysdoccls = $lo_docclsmdl;
				
				// cargo la lista de inscriptos
				$lv_prm = array('vewfldflt' =>'[~fltrow~]i.eduplncod'.chr(9).'='.chr(9).chr(9).$this->lo_dtemdl->eduplncod.chr(9).chr(9) );
				$lo_insrs = $lo_insmdl->getList($lv_prm, array(), null, false);
				$this->lo_dtemdl->eduplnins = $lo_insrs;
				
				$this->data['actcod'] = '02';
				
				// devuelvo la vista
        return $this->co_reg->document->getView( 'eduplnedt', array('data'=>$this->lo_dtemdl,'actcod'=>$this->data['actcod']) );
        break;
		
			
      //   C R E A R
      case '#01':
				$lo_pst = $this->co_reg->request->post;
				
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
            return $this->co_reg->document->getView( 'sysdocclslst', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod'], 'url'=>'?prg='.self::CONTROLLER.'&act=01', 'doccls'=>$lv_docclsarr) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdoccls = $lo_docclsmdl;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */
				
				$lv_strdte = (isset($lo_pst['strdte'])?$lo_pst['strdte']:'');
				$lv_enddte = (isset($lo_pst['enddte'])?$lo_pst['enddte']:'');
				$this->lo_mdl->eduplndtestr = substr($lv_strdte,6,2).'/'.substr($lv_strdte,4,2).'/'.substr($lv_strdte,0,4);
				$this->lo_mdl->eduplndteend = substr($lv_enddte,6,2).'/'.substr($lv_enddte,4,2).'/'.substr($lv_enddte,0,4);
				$this->lo_mdl->eduplndte = substr($lv_strdte,6,2).'/'.substr($lv_strdte,4,2).'/'.substr($lv_strdte,0,4);
				$this->lo_mdl->eduplninbdte = substr($lv_strdte,8,2).':'.substr($lv_strdte,10,2);
				$this->lo_mdl->eduplnoutdte = substr($lv_enddte,8,2).':'.substr($lv_enddte,10,2);
				$this->lo_mdl->educurcod = (isset($lo_pst['educurcod'])?$lo_pst['educurcod']:'');
				$this->lo_mdl->educurtxt = (isset($lo_pst['educurtxt'])?$lo_pst['educurtxt']:'');
				$this->lo_mdl->educarcod = (isset($lo_pst['educarcod'])?$lo_pst['educarcod']:'');
				$this->lo_mdl->educartxt = (isset($lo_pst['educartxt'])?$lo_pst['educartxt']:'');
				$this->lo_mdl->educoucod = (isset($lo_pst['educoucod'])?$lo_pst['educoucod']:'');
				$this->lo_mdl->educoutxt = (isset($lo_pst['educoutxt'])?$lo_pst['educoutxt']:'');
				$this->lo_mdl->edusubcod = (isset($lo_pst['edusubcod'])?$lo_pst['edusubcod']:'');
				$this->lo_mdl->edusubtxt = (isset($lo_pst['edusubtxt'])?$lo_pst['edusubtxt']:'');				// Materias
				$this->lo_mdl->eduplnins = array();
				$lv_buffer = (isset($lo_pst['stuarr'])?$lo_pst['stuarr']:'');
				if($lv_buffer!=''){
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_stuarr = json_decode($lv_buffer,true);
					$this->lo_mdl->eduplnins = $lv_stuarr;
				}
				
			  return $this->co_reg->document->getView(self::VIEW, array('data'=>$this->lo_mdl, 'actcod'=>$this->data['actcod']));
				break;
			
			//   V E R
			case '#02': case '#03': case '#001':
				$lo_pst = $this->co_reg->request->post;
				$lv_key = array();
				$lv_key['eduplncod'] = (isset($lo_pst['eduplncod'])?$lo_pst['eduplncod']:'');
				$lv_key['eduplndtecod'] = (isset($lo_pst['eduplndtecod'])?$lo_pst['eduplndtecod']:'');
				
				if ($lv_key['eduplncod']=='' || $lv_key['eduplndtecod']=='') {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_dtemdl->errtyp,'errcod'=>$this->lo_dtemdl->errcod,'errtxt'=>'No se indico parametro al menos un parámetro [EduPlnCod='.$lv_key['eduplncod'].'/EduPlnDteCod='.$lv_key['eduplndtecod'].']') );				
				} else if ($this->lo_dtemdl->load($lv_key)==false) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_dtemdl->errtyp,'errcod'=>$this->lo_dtemdl->errcod,'errtxt'=>$this->lo_dtemdl->errtxt) );					
				} else if ($lp_act=='#001') {
					$this->lo_dtemdl->eduplncod = '';																		
					$this->lo_dtemdl->eduplndtecod = '';
					$this->lo_dtemdl->ctedte = '';
					$this->lo_dtemdl->cteusr = '';
					$this->lo_dtemdl->upddte = '';
					$this->lo_dtemdl->updusr = '';
				}
				
				// cargo la clase de documento
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lo_docclsmdl->load(array('sysdocclscod'=>$this->lo_dtemdl->sysdocclscod));
				$this->lo_dtemdl->sysdoccls = $lo_docclsmdl;
			
				// devuelvo la vista
        return $this->co_reg->document->getView( 'eduplnedt', array('data'=>$this->lo_dtemdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			//   B O R R A R
      case '#04':
				$this->lo_mdl->delete();
        return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
        break;
				
			
			//   C O N F I R M A R
      case '#07':
				$this->co_reg->request->post['plninbdte'] = '00000000000000';
				$this->co_reg->request->post['plnoutdte'] = '00000000000000';
				$this->lo_dtemdl->popup = (isset($lp_prm['popup'])?$lp_prm['popup']:'');
        if ( $this->lo_dtemdl->confirm(array('plnid'=>$lv_plnid,'plndteid'=>$lv_plndteid,'plncnfdte'=>$this->co_reg->request->post['plncnfdte']))==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_dtemdl->errtyp,'errcod'=>$this->lo_dtemdl->errcod,'errtxt'=>$this->lo_dtemdl->errtxt) );
				} else if ( $this->lo_dtemdl->load(array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid))==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_dtemdl->errtyp,'errcod'=>$this->lo_dtemdl->errcod,'errtxt'=>'Error al cargar la planificación (header).'.$this->lo_dtemdl->errtxt) ); 
				} else {
					$lo_mdlprm->load( array('mdlcod'=>'HLT') );
					$this->lo_dtemdl->ctrdte = array();
					$this->lo_dtemdl->plnvew = $lv_plnvew;
          return $this->co_reg->document->getView( 'hltplnedt', array('data'=>$this->lo_dtemdl,'actcod'=>'02', 'mdlprm'=> $lo_mdlprm) );
				}
        break;
			
			
			
			//   R E C H A Z A R
      case '#09':

				// cargo los datos de planificación
				if ( $this->lo_mdl->load(array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid))==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>'No se pudo cargar la planificación ['.$lv_plnid.'/'.$lv_plndteid.']') );
				}
			
				// obteng correo del usuario
				$lo_usr = $this->co_reg->load->model('syssecusr');
				if ( $lo_usr->load(array('usrcod'=>$this->lo_mdl->cteusr))==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_usr->errtyp,'errcod'=>$lo_usr->errcod,'errtxt'=>'No se puede notificar al usuario ['.$this->lo_mdl->cteusr.']') );
				}
				
				// obtengo template de nofificacion
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
        if( $lo_txtmdl->load(array('txtcodext' => 'GRLSTDTXT', 'txtsys' => 0), false) ){
          $lv_usrmsghtm = $lo_txtmdl->txttxt;
				} else {
					$lv_usrmsghtm = 'Se ha rechazado una planificación.';
				}
				
				// envío notificación a quien creó la planificación
				$lv_usrmsghtm = str_ireplace('[%1]',$this->co_reg->sec->bustxt,$lv_usrmsghtm);
				$lv_usrmsghtm = str_ireplace('[%2]','Planificación',$lv_usrmsghtm);
				$lv_usrmsghtm = str_ireplace('[%3]','Planificación Rechazada',$lv_usrmsghtm);
				$lv_usrmsghtm = str_ireplace('[%4]','La planificación del día <strong>'.$this->lo_mdl->plndte.'</strong> ha sido rechazada.<br>Se indicó el siguiente motivo o fecha probable de replanificación:<br><strong>'.($this->co_reg->request->post['rejtxt']==''?'(vacio)':$this->co_reg->request->post['rejtxt']).'</strong>',$lv_usrmsghtm);
				$lo_eml = new tmssMail();
				$lv_prm = array('from'		=> array(array('address'=>'noreply@temasis.com.ar','name'=>$this->co_reg->sec->bustxt)),
												'to'			=> array(array('address'=>$lo_usr->adreml,'name'=>$lo_usr->usrtxt)),
												'subject'	=> $this->co_reg->sec->bustxt . ' - ' . $this->co_reg->language->planning,
												'bodyhtml'=> $lv_usrmsghtm,
												);
				$lo_eml->send($lv_prm);
        return $this->co_reg->document->getJson( array('errtyp'=>$lo_usr->errtyp,'errcod'=>$lo_usr->errcod,'errtxt'=>$lo_eml->getError()) );
          
        break;
			
			
			
			// *************************************************
			//
			//   C A L E N D A R I O
			//
			// *************************************************
        
        
			
			
      // Modificar preferencia de usuario de sidebar pineada
      case '#sveprfcal':
        $lo_post = $this->co_reg->request->post;
        
        $lo_usrprfmdl = $this->co_reg->load->model('syssecusrprf');
        $lv_dat = array('usrcod'=>$this->co_reg->sec->usrcod, 'usrprfgrp'=>'EDU_PLN','usrprfkey'=>'USRPIN','usrprfval'=>$lo_post['usrpin'],'docsts'=>'A');
        $lo_usrprfmdl->save( $lv_dat );
        break;
			
      // MODIFICAR planificación	( fecha inicio / hora inicio / hora fin )
      case '#12':
				$lo_post = $this->co_reg->request->post;
     
				$lv_key = array();
				$lv_key['eduplncod'] = (isset($lo_post['eduplncod'])?$lo_post['eduplncod']:'');
				$lv_key['eduplndtecod'] = (isset($lo_post['eduplndtecod'])?$lo_post['eduplndtecod']:'');
				
				if ( $lv_key['eduplncod']=='' || $lv_key['eduplndtecod']=='' ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_dtemdl->errtyp,'errcod'=>$this->lo_dtemdl->errcod,'errtxt'=>'No se indico parametro al menos un parámetro [EduPlnCod='.$lv_key['eduplncod'].'/EduPlnDteCod='.$lv_key['eduplndtecod'].']') );
					
				} else if ( $this->lo_dtemdl->load($lv_key)==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_dtemdl->errtyp,'errcod'=>$this->lo_dtemdl->errcod,'errtxt'=>$this->lo_dtemdl->errtxt) );
					
				} else {
					// modifico los datos que se actualizaron en el calendario
					// yyyymmddHHnn => dd/mm/yyyy HH:nn:ss
					$lv_dtearr = str_split($lo_post['eduplndtestr'],2);
					$lv_dtestr = $lv_dtearr[3].'/'.$lv_dtearr[2].'/'.$lv_dtearr[0].$lv_dtearr[1];
					$lv_dtetmestr = $lv_dtearr[3].'/'.$lv_dtearr[2].'/'.$lv_dtearr[0].$lv_dtearr[1].' '.$lv_dtearr[4].':'.$lv_dtearr[5].':00';
					$lv_dtearr = str_split($lo_post['eduplndteend'],2);
					$lv_dtetmeend = $lv_dtearr[3].'/'.$lv_dtearr[2].'/'.$lv_dtearr[0].$lv_dtearr[1].' '.$lv_dtearr[4].':'.$lv_dtearr[5].':00';
					$lo_data = $this->lo_dtemdl->getData();
					$lo_data['eduplndte'] = $lv_dtestr;
					$lo_data['eduplninbdte'] = $lv_dtetmestr;
					$lo_data['eduplnoutdte'] = $lv_dtetmeend;
					
          $this->lo_dtemdl->save( $lo_data );
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_dtemdl->errtyp,'errcod'=>$this->lo_dtemdl->errcod,'errtxt'=>$this->lo_dtemdl->errtxt) );
	
				}
				break;
			
			// VER planificación (calendario)
			case '#13':	
				$this->lo_mdl->calvew = (isset($this->co_reg->request->post['calvew'])?$this->co_reg->request->post['calvew']:'');
				$this->lo_mdl->caldte = (isset($this->co_reg->request->post['caldte'])?$this->co_reg->request->post['caldte']:'');
        return $this->co_reg->document->getView( 'hltplncal', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				break;
			
			// LISTAR planificación (calendario)
      case '#18':
				$lo_post = $this->co_reg->request->post;
				if(isset($lo_post['start'])){
					$lv_calstr= date('Y-m-d', strtotime($lo_post['start']));
				} else {
					$lv_calstr = date('Y-m-d', strtotime('first day of this month',time()));
				}
				if(isset($lo_post['end'])){
					$lv_calend= date('Y-m-d', strtotime($lo_post['end']));
				} else {
					$lv_calstr = date('Y-m-d', strtotime('last day of this month',time()));
				}
				
				// si tiene filtro de alumno, obtengo todas las inscripciones del período
				$lo_insdtearr = array();
				$lo_stuflt = false;
				if( isset($lo_post['vewfldflt']) ) {
					$lo_fltarr = explode('[~fltrow~]',$lo_post['vewfldflt']);
					foreach($lo_fltarr as $lo_fltarr_row){
						$lv_row = explode(chr(9),$lo_fltarr_row);
						if( $lv_row[0]=='[stutxt]' ) {
							$lo_stuflt = true;
							// recupero inscripciones del alumno en el periodo (calendario)
							$lo_insmdl = $this->co_reg->load->model('eduplnins'); 
							$lv_prm = array('vewfldflt' =>'[~fltrow~]pd.eduplndte' .chr(9).'BT'.chr(9).chr(9).$lv_calstr.chr(9).$lv_calend.chr(9).
																						'[~fltrow~]s.stutxt'.chr(9).$lv_row[1].chr(9).$lv_row[2].chr(9).$lv_row[3].chr(9).$lv_row[4].chr(9),
															);
							$lo_ins_rs = $lo_insmdl->getList($lv_prm,array(),$lo_mdlvew,false); 
							// obtengo ID de planificación
							foreach($lo_ins_rs as $lv_row){ $lo_insdtearr[] = $lv_row['eduplndtecod']; }
							// quito el filtro stutxt
							$lv_vewflt = '';
							$lo_fltbuf = explode('[~fltrow~]',$lo_post['vewfldflt']);
							foreach($lo_fltbuf as $lo_fltbuf_row){
								$lv_bufrow = explode(chr(9),$lo_fltbuf_row);
								if( $lv_bufrow[0]!='[stutxt]' ) {	$lv_vewflt .= '[~fltrow~]'.$lo_fltbuf_row; }
							}
							$lo_post['vewfldflt'] = $lv_vewflt;
						}
					}
				}
				
				//Planificacion mes actual				
				//$lo_mdlvew->setUserRestrictions( '', array( array('vewfld'=>'s.stucod'),array('vewfld'=>'t.tchcod') ) );
				$lv_prm = array('vewfldflt' =>'[~fltrow~]pd.eduplndte'	.chr(9).'BT'.chr(9).chr(9).$lv_calstr.chr(9).$lv_calend.chr(9).
																			(isset($lo_post['vewfldflt'])?($lo_post['vewfldflt']!=''?$lo_post['vewfldflt']:''):'').
																			($lo_stuflt==true?
																				(count($lo_insdtearr)>0?
																					'[~fltrow~]pd.eduplndtecod'.chr(9).'IN'.chr(9).chr(9).implode($lo_insdtearr,chr(10)).chr(9).chr(9):
																					'[~fltrow~]1'.chr(9).'='.chr(9).'2'.chr(9).chr(9).chr(9)
																					):''),
												'vewfldord' => ' pd.eduplndte, pd.eduplninbdte, pd.eduplnoutdte ');
				$lo_rs = $this->lo_dtemdl->getList($lv_prm,array(),$lo_mdlvew);
				// cargo parámetros del módulo
				$lo_mdlprm->load( array('mdlcod'=>'EDU') );
				$lv_clr_aus = $this->co_reg->document->getTagValue(strtolower($lo_mdlprm->mdlatrval001),'EDU_PLN_CLR_AUS');
				$lv_clr_evl = $this->co_reg->document->getTagValue(strtolower($lo_mdlprm->mdlatrval001),'EDU_PLN_CLR_EVL');
				$lv_clr_pnd = $this->co_reg->document->getTagValue(strtolower($lo_mdlprm->mdlatrval001),'EDU_PLN_CLR_PND');
				$lv_cal_txt = $this->co_reg->document->getTagValue(strtolower($lo_mdlprm->mdlatrval001),'EDU_PLN_CAL_TXT');
				$lo_data = array();				
				$lv_qtyrs=count($lo_rs);
				for($lv_i=0; $lv_i<$lv_qtyrs; ++$lv_i) {
          if($lo_rs[$lv_i]['stutxt']==null){$lv_cal_txt=$lo_rs[$lv_i]['edusubtxt'];}else{$lv_cal_txt=$lo_rs[$lv_i]['stutxt'];}
					$lv_data = array();
					$lv_dtestr = $lo_rs[$lv_i]['eduplninbdte'];
					$lv_dteend = $lo_rs[$lv_i]['eduplnoutdte']; 
					$lv_data['title'] = $lv_cal_txt; 
					$lv_data['color'] = '';
					if ( $lo_rs[$lv_i]['edustuevl']!=0 ) {
						if ( $lv_clr_evl!='' ) { $lv_data['color'] = $lv_clr_evl; }
						$lv_data['editable'] = false;
					} else if ( $lo_rs[$lv_i]['edustuass']!=0 ) {
						if ( $lv_clr_aus!='' ) { $lv_data['color'] = $lv_clr_aus; }
						$lv_data['editable'] = false;
					} else {
						if ( $lv_clr_pnd!='' ) { $lv_data['color'] = $lv_clr_pnd; }
						$lv_data['editable'] = true;
					}
					if($lv_data['color']==''){ $lv_data['color']='#FFFFFF'; }
					$lv_data['textColor']  = $this->color_inverse( $lv_data['color'] );
					$lv_data['eduplncod'] = $lo_rs[$lv_i]['eduplncod'];
					$lv_data['eduplndtecod'] = $lo_rs[$lv_i]['eduplndtecod'];					
					$lv_data['start'] = $lv_dtestr->format('Y-m-d\TH:i:s');
					$lv_data['end'] = $lv_dteend->format('Y-m-d\TH:i:s'); 
					if ($lv_dtestr->format('H:i')=='00:00' && $lv_dteend->format('H:i')=='00:00') { $lv_data['allDay']=true; }
					$lo_data[] = $lv_data;
				}
        return $this->co_reg->document->getJson( $lo_data );
        break;

				
			// NOTIFICAR PROFESOR/ALUMNO
			case '#27':	
				$lv_to = array();
				$lv_ntfurl = $this->co_reg->request->post['ntfurl'];
				$lv_ntfurl = str_ireplace('[','<',$lv_ntfurl);
				$lv_ntfurl = str_ireplace(']','>',$lv_ntfurl);
				$lv_ntftyp = $this->co_reg->request->post['ntftyp'];
				$lo_ntfmdl = $this->co_reg->load->controller( $this->co_reg->document->getTagValue($lv_ntfurl,'controller') );
				$lo_ntfmdl->index( $this->co_reg->document->getTagValue($lv_ntfurl,'action'), array('mailto'=>$this->co_reg->document->getTagValue($lv_ntfurl,'mailto')) );
				break;

    }
  }
	
	
	private function sendPlanningCalendar( $lp_prm=array() ) {
		$this->errcod = 0;
		$this->errtxt = '';
		$lv_usrmsghtm = '';
		$lv_usrmsgtxt = '';
		$lv_usrmsgmsg = '';

		$lo_txtmdl = $this->co_reg->load->model('grldattxt');
		
		// NOTIFICACION A PRESTADOR - TEXTOS
		if ( $lp_prm['ntftyp']=='TCH' ) {
		
      if( $lo_txtmdl->load(array('txtcodext' => 'EDUPLNCALEVTHTMTCH'), false) ){
        $lv_usrmsghtm = $lo_txtmdl->txttxt;
      } else {
        $lv_usrmsghtm = 'Se ha rechazado una planificación.';
      }
		}
		
		// actualizo las variables del mensaje HTML
		$lv_usrmsghtm = str_ireplace('[%1]',$this->co_reg->sec->bustxt,$lv_usrmsghtm);
		$lv_usrmsghtm = str_ireplace('[%2]','Planificación de prestación',$lv_usrmsghtm);
		$lv_usrmsghtm = str_ireplace('[%3]',$this->co_reg->request->post['plndte'],$lv_usrmsghtm);
		$lv_usrmsghtm = str_ireplace('[%4]',$this->co_reg->request->post['plninbdte'].' - '.$this->co_reg->request->post['plnoutdte'],$lv_usrmsghtm);
		$lv_usrmsghtm = str_ireplace('[%9]',$this->co_reg->sec->bseurl,$lv_usrmsghtm);
		// actualizo las variables del mensaje TXT
		$lv_usrmsgtxt = str_ireplace('[%1]',$this->co_reg->sec->bustxt,$lv_usrmsgtxt);
		$lv_usrmsgtxt = str_ireplace('[%2]','Planificación',$lv_usrmsgtxt);
		$lv_usrmsgtxt = str_ireplace('[%3]',$this->co_reg->request->post['plndte'],$lv_usrmsgtxt);
		$lv_usrmsgtxt = str_ireplace('[%4]',$this->co_reg->request->post['plninbdte'].' - '.$this->co_reg->request->post['plnoutdte'],$lv_usrmsgtxt);
		$lv_usrmsgtxt = str_ireplace('[%9]',$this->co_reg->sec->bseurl,$lv_usrmsgtxt);
		
		// envio el calendario
		$lo_eml = new tmssMail();
		$lv_inbtme=DateTime::createFromFormat('d/m/Y H:i', $this->co_reg->request->post['plndte'].' '.$this->co_reg->request->post['plninbdte']);
		$lv_outtme=DateTime::createFromFormat('d/m/Y H:i', $this->co_reg->request->post['plndte'].' '.$this->co_reg->request->post['plnoutdte']);
		$lv_prm = array('name'=> $this->co_reg->sec->bustxt, 
										'emlttl' => $this->co_reg->sec->bustxt . ' - ' . $this->co_reg->language->planning,
										'emlbdyhtm' => $lv_usrmsghtm,
										'emlbdytxt' => $lv_usrmsgtxt,
										'emlto'			=> $lp_prm['to'],
										'calevtttl' => $this->co_reg->language->planning,
										'calevttxt' => $lv_usrmsgmsg,
										'calevtorg'	=> $this->co_reg->sec->bustxt,
										'calevtloc'	=> 'Consulte sistema de gestión on-line',
										'calevturl' => 'https://temasis.com.ar/gestion',
										'calevtstr' => $lv_inbtme,
										'calevtend' => $lv_outtme
										);
		if ( $lo_eml->sendCalendarEvent($lv_prm) ) {
			return true;
		} else {
			$this->errcod = -1;
			$this->errtxt = $lo_eml->getError();
			return false;
		}
	}

	function color_inverse($color){
    $color = str_replace('#', '', $color);
		$lv_r = hexdec(substr($color,0,2));
		$lv_g = hexdec(substr($color,2,2));
		$lv_b = hexdec(substr($color,4,2));
		$lv_color2 = '#'.($lv_r<200?'FF':'00').($lv_g<200?'FF':'00').($lv_b<200?'FF':'00');
		return $lv_color2;
	}	
}
?>
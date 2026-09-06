<?php
final class hltplntrnController extends tmssController {
	const MODEL = 'hltpln';
	const VIEW  = 'hltplntrn';
	const ID = 'plnid';
	const OBJTYP ='HLT_PLN';
	const CONTROLLER = 'hltplntrn';
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
		$this->data['actcod'] = $lp_act;
		
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {			
			
			// LISTAR. devuelve la vista principal de turnos
      case '#': case '#08': case '#18': case '#21':
				$lo_post = $this->co_reg->request->post;
				$lv_delcod = (isset($lo_post['delcod'])?$lo_post['delcod']:'');
				$lv_spccod = (isset($lo_post['spccod'])?$lo_post['spccod']:'');
				$lv_prscod = (isset($lo_post['prscod'])?$lo_post['prscod']:'');
				$lv_patcod = (isset($lo_post['patcod'])?$lo_post['patcod']:'');
				$lv_seldte = (isset($lo_post['seldte'])?$lo_post['seldte']:'');
				$lv_deltxt = '';
				$lv_spctxt = '';
				$lo_hldmdl = $this->co_reg->load->model('admhldmov');
				$lo_plnmdl = $this->co_reg->load->model('hltplndte');
        $lo_delmdl = $this->co_reg->load->model('hltdel');
        // obtengo datos centro de atención
				if( $lv_delcod=='' ) {
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													'vewfldord' => 'd.deltxt'
												);
					$lo_delrs = $lo_delmdl->getList( $lv_prm, null, null, false );
					if( count($lo_delrs)==1 ) {	$lv_delcod = $lo_delrs[0]['delcod']; $lv_deltxt = $lo_delrs[0]['deltxt'];}
				}
        if($lv_spccod=='' && $lv_prscod!='') {
						$lv_prm = array('vewfldflt' =>'[~fltrow~]ps.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9).
																					'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
														'vewfldord' => 's.spctxt' );
						$lo_spcrs = $lo_prsspcmdl->getList( $lv_prm );
            if( count($lo_spcrs)==1 ) {	$lv_spccod = $lo_spcrs[0]['spccod']; $lv_spctxt = $lo_spcrs[0]['spctxt'];}
        }
				// obteng rango de fechas
				$lv_curdte = ( isset($lo_post['curdte'])?$lo_post['curdte']:date('d/m/Y') );
				
				// obtengo feriados
				$lv_strdte = date_create_from_format( 'd/m/Y', $lv_curdte );
				$lv_strdte->modify('first day of this month');
				$lv_enddte = date_create_from_format( 'd/m/Y', $lv_curdte );
				$lv_enddte->modify('last day of this month');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]hm.hldmovday'.chr(9).'BT'.chr(9).chr(9).$lv_strdte->format('Y-m-d').chr(9).$lv_enddte->format('Y-m-d').chr(9).
																			'[~fltrow~]h.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9), 
												'vewfldord' =>'hm.hldmovday');
				$lo_hldrs = $lo_hldmdl->getlist( $lv_prm );	
				 
				// obtengo turnos del período
				$lo_plnrs = array();
				if($lv_seldte=='') {			
					if( (isset($lo_post['strdte'])?$lo_post['strdte']:'')!='' && (isset($lo_post['enddte'])?$lo_post['enddte']:'')!='' ) {
						$lv_strdte = date_create_from_format('d/m/Y',$lo_post['strdte']);
						$lv_enddte = date_create_from_format('d/m/Y',$lo_post['enddte']);
          
						$lv_prm = array('vewfldflt' =>($lv_delcod!=''?'[~fltrow~]pl.delcod'.chr(9).'='.chr(9).chr(9).$lv_delcod.chr(9).chr(9):'').
																					($lv_spccod!=''?'[~fltrow~]pl.spccod'.chr(9).'='.chr(9).chr(9).$lv_spccod.chr(9).chr(9):'').
																					($lv_prscod!=''?'[~fltrow~]pl.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																					($lv_patcod!=''?'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):'').
																					'[~fltrow~]pl.plndte'.chr(9).'<='.chr(9).chr(9).date_format($lv_enddte,'Y-m-d').chr(9).chr(9).
                                        	'[~fltrow~]pl.plndteto'.chr(9).'>='.chr(9).chr(9).date_format($lv_strdte,'Y-m-d').chr(9).chr(9),
														'vewfldord' => 'pld.plndte',
                            'vewfldgrp' => 'pld.plndte',
                            'vewfldgrpcal' => 'count(*) as plnqty'
													); 
						$lo_plnrs = $lo_plnmdl->getList( $lv_prm,array('prgcod'=>'PLT','mdlcod'=>'HLT') );    
					}
				
				// obtengo turnos del día
				} else {
					$lv_prm = array('vewfldflt' =>($lv_delcod!=''?'[~fltrow~]pl.delcod'.chr(9).'='.chr(9).chr(9).$lv_delcod.chr(9).chr(9):'').
																				($lv_spccod!=''?'[~fltrow~]pl.spccod'.chr(9).'='.chr(9).chr(9).$lv_spccod.chr(9).chr(9):'').
																				($lv_prscod!=''?'[~fltrow~]pl.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):'').
                          							'[~fltrow~]pl.plndte'.chr(9).'='.chr(9).chr(9). date_format(date_create_from_format('d/m/Y',$lv_seldte),'Y-m-d').chr(9).chr(9),
													'vewfldord' => 'pl.plndte'
												);
					$lo_plnrs = $lo_plnmdl->getList( $lv_prm,array('prgcod'=>'PLT','mdlcod'=>'HLT') );
				}
				if( $lp_act=='#18' || $lp_act=='#21' ) {
					$lo_data = array();
          $lo_spcmdl = $this->co_reg->load->model('hltspc');
          $lo_prsmdl = $this->co_reg->load->model('hltprs');
          $lo_prsspcmdl = $this->co_reg->load->model('hltprsspc');
          //obtengo datos centro de atención
          if( $lv_delcod!='' ) {
            if ( $lo_delmdl->load( array('delcod'=>$lv_delcod),false ) == false ){
            	return $this->co_reg->document->getJson( array('errtyp'=>$lo_delmdl->errtyp,'errcod'=>$lo_delmdl->errcod,'errtxt'=>$lo_delmdl->errtxt) );      
          	}
          }
          // obtengo datos prestador
        	if( $lv_prscod!='' ) { 
            if ( $lo_prsmdl->load( array('prscod'=>$lv_prscod), false ) == false ){
              return $this->co_reg->document->getJson( array('errtyp'=>$lo_prsmdl->errtyp,'errcod'=>$lo_prsmdl->errcod,'errtxt'=>$lo_prsmdl->errtxt) );      
            }
          }
          // obtengo datos especialidad
         	if( $lv_spccod!='' ) {
          	if ( $lo_spcmdl->load( array('spccod'=>$lv_spccod) ) == false ){
						 return $this->co_reg->document->getJson( array('errtyp'=>$lo_spcmdl->errtyp,'errcod'=>$lo_spcmdl->errcod,'errtxt'=>$lo_spcmdl->errtxt) );      
           	}
         	}
          $lo_data['deltme'] = is_array($lo_delmdl->hltspctme)? $lo_delmdl->hltspctme:array();
          $lo_data['spctme'] =  is_array($lo_spcmdl->hltspctme)? $lo_spcmdl->hltspctme:array();
          $lo_data['prstme'] = is_array($lo_prsmdl->hltspctme)?$lo_prsmdl->hltspctme:array();
          $lo_data['hld'] = $lo_hldrs;
          $lo_data['pln'] = $lo_plnrs;					
          
          return $this->co_reg->document->getJson ( $lo_data );
				} else {
					$this->lo_mdl->delcod = $lv_delcod;
					$this->lo_mdl->spccod = $lv_spccod;
					$this->lo_mdl->prscod = $lv_prscod;
					$this->lo_mdl->patcod = $lv_patcod;
          $this->lo_mdl->spctxt = $lv_spctxt;
          $this->lo_mdl->deltxt = $lv_deltxt;
					$this->lo_mdl->pln = $lo_plnrs;
					$this->lo_mdl->hld = $lo_hldrs;
					$this->lo_mdl->curdte = $lv_curdte;
          return $this->co_reg->document->getView('hltplntrn',array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
				}
        break;			
			
			//   CREAR.  
      case '#01':
				$lo_post = $this->co_reg->request->post;
        $lo_prm = $this->co_reg->request->get;
				$lo_post['plndte'] = (isset($lo_post['plndte'])?$lo_post['plndte']: (isset($lo_prm['plndte']) ? $lo_prm['plndte'] : '') );
				$lo_post['plnoutdte'] = (isset($lo_post['plnoutdte'])?$lo_post['plnoutdte']: (isset($lo_prm['plnoutdte']) ? $lo_prm['plnoutdte'] : '') );
				$lo_post['plninbdte'] = (isset($lo_post['plninbdte'])?$lo_post['plninbdte']: (isset($lo_prm['plninbdte']) ? $lo_prm['plninbdte'] : '') );
				$lo_post['delcod'] = (isset($lo_post['delcod'])?$lo_post['delcod']: (isset($lo_prm['delcod']) ? $lo_prm['delcod'] : '') );
				$lo_post['spccod'] = (isset($lo_post['spccod'])?$lo_post['spccod']: (isset($lo_prm['spccod']) ? $lo_prm['spccod'] : '') );
				$lo_post['prscod'] = (isset($lo_post['prscod'])?$lo_post['prscod']: (isset($lo_prm['prscod']) ? $lo_prm['prscod'] : '') );
				$lo_post['patcod'] = (isset($lo_post['patcod'])?$lo_post['patcod']: (isset($lo_prm['patcod']) ? $lo_prm['patcod'] : '') );
				$lo_post['dayful'] = (isset($lo_post['dayful'])?$lo_post['dayful']: (isset($lo_prm['dayful']) ? $lo_prm['dayful'] : '') );
				
				$this->lo_mdl->create();
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
            return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'?prg='.self::CONTROLLER.'&act=01&plndte='.$lo_post['plndte'].'&plnoutdte='.$lo_post['plnoutdte'].'&plninbdte='.$lo_post['plninbdte'].'&delcod='.$lo_post['delcod'].'&spccod='.$lo_post['spccod'].'&prscod='.$lo_post['prscod'].'&patcod='.$lo_post['patcod'].'&dayful='.$lo_post['dayful'],'doccls'=>$lv_docclsarr ) );
					}
				}
				if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
					$this->lo_mdl->sysdocclscod = $lo_docclsmdl->sysdocclscod;
				} else {
					echo 'No se pudieron cargar los datos de la clase de documento.';
				}
				/* ------------------------------------------------ */
				
				// obteng fecha y horario
				$this->lo_mdl->plndte = date_create_from_format('d/m/Y', $lo_post['plndte']);
				$this->lo_mdl->plninbdte = date_create_from_format('d/m/Y H:i:s', $lo_post['plndte'].' '.$lo_post['plninbdte'].':00' );
				$this->lo_mdl->plnoutdte = date_create_from_format('d/m/Y H:i:s', $lo_post['plndte'].' '.$lo_post['plnoutdte'].':00' );
				$this->lo_mdl->popup = (isset($lo_post['popup'])?$lo_post['popup']:'');
				$this->lo_mdl->dayful = (isset($lo_post['dayful'])?$lo_post['dayful']:'');
				$this->lo_mdl->delcod = (isset($lo_post['delcod'])?$lo_post['delcod']:'');
				$this->lo_mdl->spccod = (isset($lo_post['spccod'])?$lo_post['spccod']:'');
				$this->lo_mdl->prscod = (isset($lo_post['prscod'])?$lo_post['prscod']:'');
				$this->lo_mdl->patcod = (isset($lo_post['patcod'])?$lo_post['patcod']:'');
				
				return $this->getView('hltplntrnedt');				
        break;
			
			
			// G R A B A R. graba el documento
			case '#00':
				$lo_post = $this->co_reg->request->post;
				// grabo cabecera de turno
				$lo_post['serid'] = '<frqtyp>U</frqtyp>';
        
        //Grabo sobreturno
				$lo_plnmdl = $this->co_reg->load->model('hltplndte');
				$lo_plnmdl->load( array('plnid'=>$lo_post['plnid'], 'plndteid'=>$lo_post['plndteid']) );
        $lv_plndteatrcur = $lo_plnmdl->plndteatr;
        $lv_dayful =  $this->co_reg->document->getTagValue($lv_plndteatrcur, 'hltplndteatrdayful');
        if($lv_dayful != $lo_post['hltplndteatrdayful']){
           $lo_post['plndteatr'] = (($lv=$this->co_reg->document->getTagValue($lv_plndteatrcur,'usricn')) ? '<usricn>'.$lv.'</usricn>' : '').
                                   '<dayful>'.( isset($lo_post['hltplndteatrdayful']) ? ($lo_post['hltplndteatrdayful']=='on' || $lo_post['hltplndteatrdayful']=='1' ? 'X' : '') : $this->co_reg->document->getTagValue($lv_plndteatrcur, 'dayful') ).'</dayful>'.
                                   ( ($lv=$this->co_reg->document->getTagValue($lv_plndteatrcur,'plntrnrec')) ? '<plntrnrec>'.$lv.'</plntrnrec>' : '' ).
                                   ( ($lv=$this->co_reg->document->getTagValue($lv_plndteatrcur,'plntrncal')) ? '<plntrncal>'.$lv.'</plntrncal>' : '' ).
                                   ( ($lv=$this->co_reg->document->getTagValue($lv_plndteatrcur,'plntrnatn')) ? '<plntrnatn>'.$lv.'</plntrnatn>' : '' );
        }
				if ( $this->lo_mdl->save( $lo_post )==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				} else {
					$lo_post['plnid'] = $this->lo_mdl->plnid;
          $lo_post['plndteid'] = $this->lo_mdl->plndteid;
				}
				// cargo planificación
				$lo_plnmdl = $this->co_reg->load->model('hltplndte');
				$lo_plnmdl->load( array('plnid'=>$lo_post['plnid'], 'plndteid'=>$lo_post['plndteid']) );
				$lo_plnmdl->popup = ($lo_post['popup']??'');
				$this->lo_mdl = $lo_plnmdl;
				
				$this->data['actcod'] = '02';
				return $this->getView('hltplntrnedt');
				break;
			
			
			//   M O D I F I C A R. devuelve la vista de turno en modo modificación
			case '#02':  case '#03':
				$lo_post = $this->co_reg->request->post;
				
				// cargo datos de planificación
				$lo_plnmdl = $this->co_reg->load->model('hltplndte');
				$lo_plnmdl->load( array('plnid'=>$lo_post['plnid'], 'plndteid'=>$lo_post['plndteid']) );
				$lo_plnmdl->popup = ($lo_post['popup']??'');
				$this->lo_mdl = $lo_plnmdl;
				
				$this->data['actcod'] = '02';
				return $this->getView( 'hltplntrnedt' );
				break;			
			
			
			//   B O R R A R. borra el documento
			case '#04':
				$lo_post = $this->co_reg->request->post;
				$lo_plnmdl = $this->co_reg->load->model('hltpln');
				$lo_plnmdl->delete( array('plnid'=>$lo_post['plnid']) );
        return $this->co_reg->document->getJson( array('errtyp'=>$lo_plnmdl->errtyp,'errcod'=>$lo_plnmdl->errcod,'errtxt'=>$lo_plnmdl->errtxt) );
				break;
			
			
			//   R E C E P C I O N A R. actualiza recepcion y devuelve vista del turno
			case '#11':
				$lo_post = $this->co_reg->request->post;
				// cargo la planificación
				$lo_plndtemdl = $this->co_reg->load->model('hltplndte');
				if( $lo_plndtemdl->load( array('plnid'=>$lo_post['plnid'],'plndteid'=>$lo_post['plndteid']) )==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$lo_plndtemdl->errtyp,'errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
				}
				
				// actualizo hora de recepción
				$lo_dat = $lo_plndtemdl->getData();
				$lo_dat['plndte'] = date_format($lo_plndtemdl->plndte,'d/m/Y');
				$lo_dat['plninbdte'] = date_format($lo_plndtemdl->plninbdte,'H:i');
				$lo_dat['plnoutdte'] = date_format($lo_plndtemdl->plnoutdte,'H:i');
        
				$lo_dat['plndteatr'] =($lo_plndtemdl->plndteatr). '<plntrnrec>'.date('H:i').'</plntrnrec>';
				if( $this->lo_mdl->save( $lo_dat )==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				}
				
				// cargo planificacion
				$lo_plndtemdl->load( array('plnid'=>$lo_post['plnid'],'plndteid'=>$lo_post['plndteid']) );
				$this->lo_mdl = $lo_plndtemdl;
				
				$this->data['actcod'] = '02';
				return $this->getView( 'hltplntrnedt' );				
				break;
			
			
			//   L L A M A R. actualiza llamado y devuelve vista del turno
			case '#12':
				$lo_post = $this->co_reg->request->post;
				
				// cargo la planificación
				$lo_plndtemdl = $this->co_reg->load->model('hltplndte');
				if( $lo_plndtemdl->load( array('plnid'=>$lo_post['plnid'],'plndteid'=>$lo_post['plndteid']) )==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$lo_plndtemdl->errtyp,'errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
				}
				
				// actualizo hora de recepción
				$lo_dat = $lo_plndtemdl->getData();
				$lo_dat['plndte'] = date_format($lo_plndtemdl->plndte,'d/m/Y');
				$lo_dat['plninbdte'] = date_format($lo_plndtemdl->plninbdte,'H:i');
				$lo_dat['plnoutdte'] = date_format($lo_plndtemdl->plnoutdte,'H:i');
        
        $lo_dat['plndteatr'] =($lo_plndtemdl->plndteatr).'<plntrncal>'.date('H:i').'</plntrncal>';
				if( $this->lo_mdl->save( $lo_dat )==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				}
				
				// cargo planificacion
				$lo_plndtemdl->load( array('plnid'=>$lo_post['plnid'],'plndteid'=>$lo_post['plndteid']) );
				$this->lo_mdl = $lo_plndtemdl;

				$this->data['actcod'] = '02';
				return $this->getView( 'hltplntrnedt' );				
				break;
			
			
			//   A T E N D E R. actualiza atención y devuelve vista del turno
			case '#15':
				$lo_post = $this->co_reg->request->post;
				
				// cargo la planificación
				$lo_plndtemdl = $this->co_reg->load->model('hltplndte');
				if( $lo_plndtemdl->load( array('plnid'=>$lo_post['plnid'],'plndteid'=>$lo_post['plndteid']) )==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$lo_plndtemdl->errtyp,'errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
				}
				
				// actualizo hora de recepción
				$lo_dat = $lo_plndtemdl->getData();
				$lo_dat['plndte'] = date_format($lo_plndtemdl->plndte,'d/m/Y');
				$lo_dat['plninbdte'] = date_format($lo_plndtemdl->plninbdte,'H:i');
				$lo_dat['plnoutdte'] = date_format($lo_plndtemdl->plnoutdte,'H:i');

        $lo_dat['plndteatr'] =($lo_plndtemdl->plndteatr).  '<plntrnatn>'.date('H:i').'</plntrnatn>';
				if( $this->lo_mdl->save( $lo_dat )==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				}
				
				// cargo planificacion
				$lo_plndtemdl->load( array('plnid'=>$lo_post['plnid'],'plndteid'=>$lo_post['plndteid']) );
				$this->lo_mdl = $lo_plndtemdl;
				
				$this->data['actcod'] = '02';
				return $this->getView( 'hltplntrnedt' );				
				break;
			
			
			//  S A L A    D E    E S P E R A. devuelve vista de sala de espera
      case '#23':
				$lo_post = $this->co_reg->request->post;
				$lo_post['delcod'] = ($lo_post['delcod']??'');
				$lo_post['spccod'] = ($lo_post['spccod']??'');
				$lo_post['prscod'] = ($lo_post['prscod']??'');
				$lo_post['patcod'] = ($lo_post['patcod']??'');
				
				// obteng rango de fechas
				$lv_curdte = ($lo_post['curdte']??date('d/m/Y'));
				
				// obtengo feriados
				$lo_hldmdl = $this->co_reg->load->model('admhld');
				$lo_hldrs = $lo_hldmdl->getMonthlyList( array('hldday'=>$lv_curdte) );
				
				// obtengo datos centro de atención
				$lo_delmdl = $this->co_reg->load->model('hltdel');
				$lv_delcod = $lo_post['delcod'];
				if( $lv_delcod=='' ) {
					$lv_prm = array('vewfldflt' =>'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													'vewfldord' => 'd.deltxt' );
					$lo_delrs = $lo_delmdl->getList( $lv_prm, null, null, false );
					if( count($lo_delrs)==1 ) {	$lv_delcod = $lo_delrs[0]['delcod']; }
				} else {
					$lv_delcod = $lo_post['delcod'];
				}
				if( $lv_delcod!='' ) { $lo_delmdl->load( array('delcod'=>$lv_delcod),false ); }

				// obtengo datos prestador
				$lo_prsmdl = $this->co_reg->load->model('hltprs');
				$lv_prscod = $lo_post['prscod'];
				if($lv_prscod=='' ) { 
					$lv_prm = array('vewfldflt' =>'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													'vewfldord' => 'p.prstxt' );
					$lo_prsrs = $lo_prsmdl->getList( $lv_prm, null, null, false);
					if( count($lo_prsrs)==1 ) {	$lv_prscod = $lo_prsrs[0]['prscod']; }
				}
				if( $lv_prscod!='' ) { $lo_prsmdl->load( array('prscod'=>$lv_prscod) ); }
				
				// obtengo datos especialidad
				$lo_spcmdl = $this->co_reg->load->model('hltspc');
				$lv_spccod = $lo_post['spccod'];
				if($lv_spccod=='' ) { 
					if($lv_prscod!='') {
						$lo_prsspcmdl = $this->co_reg->load->model('hltprsspc');
						$lv_prm = array('vewfldflt' =>'[~fltrow~]ps.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9).
																					'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
														'vewfldord' => 's.spctxt' );
						$lo_spcrs = $lo_prsspcmdl->getList( $lv_prm );
					} else {
						$lv_prm = array('vewfldflt' =>'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
														'vewfldord' => 's.spctxt' );
						$lo_spcrs = $lo_spcmdl->getList( $lv_prm );
					}
					if( count($lo_spcrs)==1 ) {	$lv_spccod = $lo_spcrs[0]['spccod']; }
				}
				if( $lv_spccod!='' ) { $lo_spcmdl->load( array('spccod'=>$lv_spccod) ); }

				// obtengo datos paciente
				$lo_patmdl = $this->co_reg->load->model('hltpat');
				if($lo_post['patcod']!='' ) { $lo_patmdl->load( array('patcod'=>$lo_post['patcod']) ); }
				
				// obtengo turnos
				$lo_plnmdl = $this->co_reg->load->model('hltpln');
				$lo_plnrs = array();
				if( (isset($lo_post['strdte'])?$lo_post['strdte']:'')!='' && (isset($lo_post['enddte'])?$lo_post['enddte']:'')!='' ) {
					$lv_strdte = date_create_from_format('d/m/Y',$lo_post['strdte']);
					$lv_enddte = date_create_from_format('d/m/Y',$lo_post['enddte']);
					$lv_prm = array('vewfldflt' =>($lo_delmdl->delcod!=''?'[~fltrow~]l.delcod'.chr(9).'='.chr(9).chr(9).$lo_delmdl->delcod .chr(9).chr(9):'').
																				($lo_spcmdl->spccod!=''?'[~fltrow~]l.spccod'.chr(9).'='.chr(9).chr(9).$lo_spcmdl->spccod .chr(9).chr(9):'').
																				($lo_prsmdl->prscod!=''?'[~fltrow~]l.prscod'.chr(9).'='.chr(9).chr(9).$lo_prsmdl->prscod .chr(9).chr(9):'').
																				($lo_patmdl->patcod!=''?'[~fltrow~]l.patcod'.chr(9).'='.chr(9).chr(9).$lo_patmdl->patcod .chr(9).chr(9):'').
																				'[~fltrow~]l.plndte'.chr(9).'BT'.chr(9).chr(9). date_format($lv_strdte,'Y-m-d').chr(9).date_format($lv_enddte,'Y-m-d').chr(9),
													'vewfldord' => 'l.plndte'
												);
					$lo_plnrs = $lo_plnmdl->getList( $lv_prm, array('prgcod'=>'LBY','mdlcod'=>'HLT'));
				}
				
				$this->lo_mdl->del = $lo_delmdl;
				$this->lo_mdl->spc = $lo_spcmdl;
				$this->lo_mdl->prs = $lo_prsmdl;
				$this->lo_mdl->pat = $lo_patmdl;
				$this->lo_mdl->pln = $lo_plnrs;
				$this->lo_mdl->hld = $lo_hldrs;
				$this->lo_mdl->curdte = $lv_curdte;
        return $this->co_reg->document->getView( 'hltplntrnlby', array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
        break;
			
			
			//   I M P R E S I O N   -   T U R N O. devuelve la impresion (estandard) de un turno
			case '#33':
				$lo_post = $this->co_reg->request->post;
				$lo_plnmdl = $this->co_reg->load->model('hltpln');
				$lo_post = $lp_prm;

				// cargo la planificación
				$this->lo_mdl = $this->co_reg->load->model('hltplndte');
				if( $this->lo_mdl->load( array('plnid'=>$lo_post['plnid'],'plndteid'=>$lo_post['plndteid']) )==false ) {
					return $this->co_reg->document->getJson( array('errtyp'=>$this->lo_mdl->errtyp,'errcod'=>$this->lo_mdl->errcod,'errtxt'=>$this->lo_mdl->errtxt) );
				}
				
        if ( $this->lo_mdl->evlcod!='' || date_format($this->lo_mdl->plninbdte,'YmdHi')<date('YmdHi') ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Turno ya concluido o vencido. No se permite impresion.') );
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
        }
				
				$lv_buffer = 	$this->getView('hltplntrnprn');
				$this->co_reg->response->addHeader('Content-type:application/pdf');
				return $lv_buffer;
				break;

    }
  }
	
	function getView( $lp_vew ) {
		
		// cargo clase de documento
		$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
		$lo_docclsmdl->load( array('sysdocclscod'=>$this->lo_mdl->sysdocclscod) );
		$this->lo_mdl->sysdoccls = $lo_docclsmdl;

		// obtengo datos centro de atención
		$lo_delmdl = $this->co_reg->load->model('hltdel');
		if( $this->lo_mdl->delcod!='' ) { $lo_delmdl->load( array('delcod'=>$this->lo_mdl->delcod),false ); }
		$this->lo_mdl->del = $lo_delmdl;
		
		// obtengo datos especialidad
		$lo_spcmdl = $this->co_reg->load->model('hltspc');
		if( $this->lo_mdl->spccod!='' ) { $lo_spcmdl->load( array('spccod'=>$this->lo_mdl->spccod) ); }
		$this->lo_mdl->spc = $lo_spcmdl;

		// obtengo datos prestador
		$lo_prsmdl = $this->co_reg->load->model('hltprs');
		if( $this->lo_mdl->prscod!='' ) { $lo_prsmdl->load( array('prscod'=>$this->lo_mdl->prscod) ); }
		$this->lo_mdl->prs = $lo_prsmdl;

		// obtengo datos paciente
		$lo_patmdl = $this->co_reg->load->model('hltpat');
		$lo_patmdl->create();
		if( $this->lo_mdl->patcod!='' ) { $lo_patmdl->load( array('patcod'=>$this->lo_mdl->patcod) ); }
		$this->lo_mdl->pat = $lo_patmdl;

		// preparo parámetros de vista
    return $this->co_reg->document->getView( $lp_vew, array('data'=>$this->lo_mdl,'actcod'=>$this->data['actcod']) );
	}
}
?>
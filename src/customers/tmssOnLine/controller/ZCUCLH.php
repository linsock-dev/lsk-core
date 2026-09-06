<?php 
final class zcuclhController extends tmssController {
  protected $co_reg;
  private $data = array();

  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
  // INDEX. metodo principal de la clase     
  public function index( $lp_act , $lp_prm = array() ) {
    // all methods of this class are available for logged users check user session
		$this->co_reg->request->post['ajax']='1';
    $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
    if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		$this->data['actcod'] = $lp_act;
    
		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {
      // ?PRG=ZCUTP1&ACT=EVLINF
      case '#zcuclh_frmact01':{
      	/*Instanciamos los modelos*/
				$lo_plndtemdl = $this->co_reg->load->model('hltplndte');	
				$lo_plndtemdl2 = $this->co_reg->load->model('hltplndte');	 
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');	
				$lo_vew = $this->co_reg->load->model('grlvew');
				
				/*Obtenemos los parametros post*/
				$lv_evlcod = $this->co_reg->request->post['evlcod']??'';
				$lv_plnid = $this->co_reg->request->post['plnid']??'';
				$lv_plndteid = $this->co_reg->request->post['plndteid']??'';
				$lv_hhcc =$this->co_reg->request->post['hhcc']??'';
        
        // ------------------------------------------------ 
        // Buscar datos sugerencia de material 
        // 1. Busco el parametro para obtener los campos obligatorios segun  especialidad 
        $lp_prm['spccod']=$lp_prm['spccod']??'1';
        $lv_spccod = (isset($this->co_reg->request->post['spccod'])?$this->co_reg->request->post['spccod']:$lp_prm['spccod']);
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        $lv_fldrec=[];
        if($lo_prmmdl->load(array('mdlcod'=>'HLTSPCFRMREQ'))){
          $lv_fldrec=explode(';',$this->co_reg->document->getTagValue(strtolower($lo_prmmdl->mdlatrval001), $lv_spccod));
        }
        // cargo la evolución
        $lo_plndtemdl->load( array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid) );
        $PatChgDte = '';
				// CREAR EVOLUCION
				if ( $lv_evlcod=='' ) {
					$lv_plndte = $lo_plndtemdl->plndte;
					$lv_evlcod = $lo_plndtemdl->evlcod;
					$lv_prscod = $lo_plndtemdl->prscod; 
					$lv_patcod = $lo_plndtemdl->patcod; 
					
					$lv_dteto  = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dtefrm = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dteto->modify('last day of previous month');
					$lv_dtefrm->modify('first day of previous month');
					$lv_patflt= '';
					
					// obtenemos evoluciones realizadas del mes anterior
					$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evldte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'e.evldte');
					$lo_evl_rs = $lo_evlmdl->getList($lv_prm, null, null, false);
					
					// Generamos la lista de planificaciones ya evolucionadas
					foreach( $lo_evl_rs as $lv_row ) {
					 $lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['plndteid']; 
					}
					// obtenemos planificaciones del mes anterior que no están evolucionadas 
					$lv_prm = array('vewfldflt' =>'[~fltrow~]pld.plndteid'.chr(9).'NI'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																			'[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]pl.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'pld.plndteid');
					$lo_pln_rs = $lo_plndtemdl2->getList($lv_prm);  
          
          /* ------------------------------------------------ */
          /* obtengo clase de documento 											*/
          /* ------------------------------------------------ */
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
          if ( $lv_docclscod=='' ) {															// si no se indicó
            $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).'HLT_EVL'.chr(9).chr(9).chr(9).
                                          '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                          );
            $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
            if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
              $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
            } else {
              return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
            }
          }
          if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
            $lo_plndtemdl->sysdoccls = $lo_docclsmdl;
          } else {
            echo 'No se pudieron cargar los datos de la clase de documento.';
          }
          
          /* ------------------------------------------------ */         
          /* Buscar datos sugerencia de material */
          /* 1. Busco el parametro para obtener el codigo de material segun la especialidad */
           $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
          if(!$lo_prmmdl->load(array('mdlcod'=>'PTMAT'))){
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt));
          }
          
          /* 2. Busco los datos del paciente para obtener la clas. de enfermedad */
          $lo_patmdl = $this->co_reg->load->model('hltpat');	
          if(!$lo_patmdl->load(array('patcod'=>$lo_plndtemdl->patcod),false)){
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_patmdl->errcod,'errtxt'=>$lo_patmdl->errtxt) );
          }
          
          /*3. Busco el material */
          $lv_matcod = $this->co_reg->document->getTagValue($lo_prmmdl->mdlatrval001, $lo_patmdl->hltdisclscod);
          $lo_plndtemdl->mattxt = '';
          $lo_plndtemdl->matcod = '';
          $lo_matmdl = $this->co_reg->load->model('stkmat');	
          if($lv_matcod !=''){
            if(!$lo_matmdl->load(array('matcod'=>$lv_matcod),false)){
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_matmdl->errcod,'errtxt'=>$lo_matmdl->errtxt) );
            }
          }
          $lo_plndtemdl->matcod = $lo_matmdl->matcod;
          $lo_plndtemdl->mattxt = $lo_matmdl->mattxt;
          $lo_plndtemdl->matuntcod = $lo_matmdl->matuntcod;
          
					// preparo datos de vista
					$lo_plndtemdl->evlatr = array();
					$lo_plndtemdl->evlspc = array();
					$lo_plndtemdl->evlmat = array();
					$lo_plndtemdl->evldte = $lo_plndtemdl->plndte;
					$lo_plndtemdl->docsts = 'P';
          // buscar ultimo peso
          
          $lo_docchgmdl = $this->co_reg->load->model('sysdocchg');
          $lv_prmchg= array('chgdocsrctyp'=>'HLT_PAT','chgdocsrccod'=>$lo_patmdl->patcod);
          $rsChg=$lo_docchgmdl->getDetail( $lv_prmchg );
          
					$lv_prm = array('data' =>	$lo_plndtemdl,	// datos de planificación
													'actcod' => $this->data['actcod'],
													'rsplndte'=>$lo_pln_rs	// fechas no evolucionadas de mes anterior
													);

        // VER EVOLUCION
				} else {
					
					// cargo datos generales de la evolucion
					$lo_evlmdl->load( array('evlcod'=>$lv_evlcod),false );
          // obtengo toda la info de la clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_evlmdl->sysdocclscod) ) ) {
						$lo_evlmdl->sysdoccls = $lo_docclsmdl;
					}
          $lo_plndtemdl->matuntcod = '';
					// preparo datos de vista
					$lv_prm = array('doc' => $this->co_reg->document,'data' => $lo_evlmdl,
													'actcod' => $this->data['actcod'],
													'rsplndte'=>array(),
													);
				}
				
				// * REGRESO LA VISTA *
        
        //Buscar motivos de no infucion dependiendo de el financiador de la planificacion
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'EVLCNCMTVLST'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt) );
        }

        $lv_evlcncmtvlst = $this->co_reg->document->gettagvalue($lo_prmmdl->mdlatrval001,'CUS_'.$lo_plndtemdl->cuscod);	// MAILS
        if($lv_evlcncmtvlst==''){
          $lv_evlcncmtvlst = $this->co_reg->document->gettagvalue($lo_prmmdl->mdlatrval001,'ALL');	// MAILS
        }
        $lv_evlcncmtvrows = explode(";", $lv_evlcncmtvlst);
        $lv_mtvarr=array();
        foreach($lv_evlcncmtvrows as $lv_rowmtv){
          $lv_cncmtvrow = explode(",", $lv_rowmtv);
          $lv_mtvarr[$lv_cncmtvrow[0]]=$lv_cncmtvrow[1];
        }
        $lv_prm['data']->evlcncmtvlst = $lv_mtvarr;
				$lv_prm['data']->hhcc=$lv_hhcc;
        $lv_prm['data']->fldrec=$lv_fldrec;
        $lv_prm['data']->patchgdte='';//$PatChgDte;
				$lv_buffer = 	$this->co_reg->document->getView( 'zcuclh_spcfrm001', $lv_prm); 
				return $lv_buffer;
        break;
      }
      case '#zcuclh_frmact01_00':{
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');		
				$lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
				$lo_evlspcmdl = $this->co_reg->load->model('hltpatevlspc');
				$lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte'); 

				$lv_buf_arr = $this->co_reg->request->post;
				$lv_evldte = $this->co_reg->db->sqldate($lv_buf_arr['evldte']); 
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_evldte =(isset($this->co_reg->request->post['evldte'])?$this->co_reg->request->post['evldte']:$lp_prm['evldte']);
				
				$datemax = new DateTime("now");
				$datemax= $datemax->add(new DateInterval('P5D'));
				$lv_dte = new DateTime($this->co_reg->db->sqldate($lv_evldte));
				if ($lv_dte > $datemax){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'No es posible infundir la fecha seleccionada') );
				}
        // GRABAR PESO DEL PACIENTE
        $lo_patdl = $this->co_reg->load->model('hltpat');
        $lo_patdl->load(array('patcod'=>$lv_buf_arr['patcod']),false);
        // grabo el cotrol de cambio del peso
        $lv_chgtxt = '';
        $lv_newval = $lv_buf_arr['patwgt'];
        $lv_oldval = $lo_patdl->patwgt;
        $lv_chgtxt .= '<atr><nme>patwgt</nme><old>'.$lv_oldval.'</old><new>'.$lv_newval.'</new></atr>';
        $lo_docchgmdl = $this->co_reg->load->model('sysdocchg');
        $lv_prm = array('chgdocsrctyp'=>'HLT_PAT', 'chgdocsrccod'=>$lo_patdl->patcod, 'chgdocatr'=>$lv_chgtxt, 'docsts'=>'A');
        $lo_docchgmdl->save( $lv_prm );

        
				$lv_evlinfprc=isset($this->co_reg->request->post['evlinfprc'])?$this->co_reg->request->post['evlinfprc']:'';
        
				$lv_docsts = ( $lv_evlinfprc=='1'?'A':'P' );
        
				$lv_buf_arr['docsts'] = $lv_docsts;
        $lv_buf_arr['evlinfprc']= $lv_evlinfprc;
				$lv_buf_arr['evlcmt']=$lv_buf_arr['evlcmt'] ;
				$lv_buf_arr['evlsub']=$lv_buf_arr['evlcnccmt'];
				$lv_buf_arr['evlevl']= $lv_buf_arr['evlevl'];
        $lv_buf_arr['fvrpt']=isset($lv_buf_arr['fvrpt'])?$lv_buf_arr['fvrpt']:'off';
        $lv_fvrpttxt = ( ($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1')?'SI':'NO' );
        $lv_buf_arr['evlatr001']='<row>';
				$lv_buf_arr['evlatr001'].= '<dte>'.$lv_evldte.'</dte>';
        $lv_buf_arr['evlatr001'].= '<evlcncmtv>'.$lv_buf_arr['evlcncmtv'].'</evlcncmtv>';
        $lv_buf_arr['evlatr001'].= '<evlcnccmt>'.$this->co_reg->db->sqldata($lv_buf_arr['evlcnccmt']).'</evlcnccmt>';
        $lv_buf_arr['evlatr001'].= '<evlinfprc>'.$this->co_reg->db->sqldata($lv_buf_arr['evlinfprc']).'</evlinfprc>';
        /* GEO */
        if(isset($lv_buf_arr['evllat'])){
          $lv_buf_arr['evlatr001'].= '<evllat>'.$this->co_reg->db->sqldata($lv_buf_arr['evllat']).'</evllat>';
          $lv_buf_arr['evlatr001'].= '<evllon>'.$this->co_reg->db->sqldata($lv_buf_arr['evllon']).'</evllon>';
        }
        $lv_buf_arr['evlatr001'].= '<fvrpt>'.$lv_buf_arr['fvrpt'].'</fvrpt>';
        $lv_buf_arr['evlatr001'].= '<fvrpttxt>'.$lv_fvrpttxt.'</fvrpttxt>';
        $lv_buf_arr['evlatr001'].= '<patwgt>'.$lv_buf_arr['patwgt'].'</patwgt>';
        $lv_buf_arr['evlatr001'].= '<matdos>'.$lv_buf_arr['matdos'].'</matdos>';
        $lv_buf_arr['evlatr001'].= '<matuntcod>'.$lv_buf_arr['matuntcod'].'</matuntcod>';
        $lv_buf_arr['evlatr001'].='</row>';
				$lv_buf_arr['evlobj']=$lv_buf_arr['evlinfprc']=='1'?'REALIZADO '.$lv_evldte :'NO REALIZADO' . chr(13) . $lv_buf_arr['evlcncmtv'] . chr(13) . $lv_buf_arr['evlcnccmt'];
				//Obtengo el peso en los atributos
        $lv_patwgt='';
        $lv_buffer = isset($this->co_reg->request->post['evlatr'])?$this->co_reg->request->post['evlatr']:'';
        if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_atr_arr = json_decode($lv_buffer,true);
            foreach( $lv_atr_arr as $lv_row ) {
               $lv_patwgt=($lv_patwgt==''?$lv_row['p']:$lv_patwgt);
            }
            $lv_buf_arr['evlatr001'].='<patwgt>'.$lv_patwgt.'</patwgt>';
        }
				// EVOLUCION - grabo los datos de cabecera
				if ( $lo_evlmdl->save( $lv_buf_arr, false )==false ) {
          //echo $lo_evlmdl->getsysdata('sqlstm');
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
				}
        
				// EVOLUCION - INFUSION
				if ( $lv_docsts=='A' ) {

					// ARCHIVO. obtengo tipo de archivo por codigo externo
					$lo_upltypmdl = $this->co_reg->load->model('grldatfletyp');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]ft.fletypcodext'.chr(9).'='.chr(9).chr(9).'HLTEVL'.chr(9).chr(9).
                          							//'[~fltrow~]ft.objtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
                                        '[~fltrow~]ft.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                          'vewmaxrec'=>'1');
					$lo_rs = $lo_upltypmdl->getList( $lv_prm );
					if(count($lo_rs)>0){	// si encontro tipo de archivo de evoluciones, se suben los archivos adjuntos
						$lo_uplmdl = $this->co_reg->load->model('grldatupl');
						$this->co_reg->request->post['flesrctyp']='HLT_EVL';
						$this->co_reg->request->post['fletypcod']=$lo_rs[0]['fletypcod'];
						$this->co_reg->request->post['flesrccod']=$lo_evlmdl->evlcod;
						$lo_uplmdl->uploadFile($this->co_reg->request->post);        
					}
          
					// EVOLUCION MATERIALES - grabo datos de materiales
					$lv_buffer = $this->co_reg->request->post['evlmat'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_mat_arr = json_decode($lv_buffer,true);
						foreach( $lv_mat_arr as $lv_row ) {
							$lv_arr = $lv_row;
							$lv_arr['evlcod'] = $lo_evlmdl->evlcod;
							$lv_arr['matatrval001'] = '<strtme>'.$lv_row['atrstrtme'].'</strtme><endtme>'.$lv_row['atrendtme'].'</endtme><advrea>'.$lv_row['atradvrea'].'</advrea>';
							$lv_arr['docsts'] = 'A';
							if ( isset($lv_row['deleted']) ) {
								if ($lo_evlmatmdl->delete()==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
								}
							} else if ($lo_evlmatmdl->save( $lv_arr )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
							}
						}
					}
				}        
        $lv_errcod = '';
        $lv_errtxt = '';
        if($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1'){
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          $lo_plndtearr['hltplndteatrusricn']='fa-solid fa-message-medical';
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          // obtengo texto del mensaje
          $lo_txtmdl = $this->co_reg->load->model('grldattxt');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'HLTEVLGRL'.chr(9).chr(9).
                                        '[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
                                        '[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
                                        '[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
                          'vewmaxrec'=>'1');
          $lo_rs = $lo_txtmdl->getList($lv_prm);
          if( count($lo_rs)!=0 ) {
            $lv_usrmsg = $lo_rs[0]['txttxt'];
          } else {
            $lv_usrmsg = '';
            $lv_errcod = '-1';
            $lv_errtxt = 'No se encontró el texto del mensaje.';
          } 
          $ctlZcuTin = $this->co_reg->load->controller('zcutp1_tin');
          $lvDataFarma=$lv_buf_arr;
          $lvDataFarma['patcod']=$lo_patdl->patcod;
          $lvDataFarma['pattxt']=$lo_patdl->pattxt;
          $lvDataFarma['cuscod']=$lo_patdl->cuscod??'error';
          $lvDataFarma['custxt']=$lo_patdl->custxt??'error';
          $lvDataFarma['evlcod']=$lo_evlmdl->evlcod;
          $lvDataFarma['evlcmt']=$lv_evlinfprc=='1'?$lo_evlmdl->evlevl:$lo_evlmdl->evlsub;
          $this->sendMailFarma($lvDataFarma);
        }
				return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt) );
				break;
      }
      case '#zcuclh_frmact01_04':{
        $lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte');
        $lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
        $lv_ret = array('errtyp'=>'','errcod'=>'0','errtxt'=>'') ;
        

				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);

				/* determino si se encuentra en alguna liquidación */
				$lo_prslqddocmdl = $this->co_reg->load->model('hltprslqddoc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
																			'[~fltrow~]ld.refobjcod001'.chr(9).'='.chr(9).chr(9).$lv_evlcod.chr(9).chr(9) );
				$lo_rssrv = $lo_prslqddocmdl->getList( $lv_prm );
				if ( count($lo_rssrv)>0 ) {
          $lv_ret=   array('errtyp'=>'E','errcod'=>'-4','errtxt'=>'No se puede borrar la evolucion. Esta incluida en la liquidacion ['.$lo_rssrv[0]['hltprslqdcod'].']');
				} else {
          
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          $lo_plndtearr['hltplndteatrusricn']='';
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
          $lo_evlmdl->delete( array('evlcod'=>$lv_evlcod), false);
       		$lv_ret=   array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt);
					
				}        
				return $this->co_reg->document->getJson($lv_ret);
				break;
      }
      // ?PRG=ZCUTP1_TIN&ACT=EVLEST
      case '#zcuclh_frmact02':{
        /*Instanciamos los modelos*/
				$lo_plndtemdl = $this->co_reg->load->model('hltplndte');	
				$lo_plndtemdl2 = $this->co_reg->load->model('hltplndte');	 
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');	
				$lo_vew = $this->co_reg->load->model('grlvew');
				
				/*Obtenemos los parametros post*/
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:'');
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_hhcc =(isset($this->co_reg->request->post['hhcc'])?$this->co_reg->request->post['hhcc']:'');
				
				// CREAR EVOLUCION
        $lv_patcod ='';
        // cargo la evolución
        $lo_plndtemdl->load( array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid) );
        $lv_plndte = $lo_plndtemdl->plndte;
        $lv_evlcod = $lo_plndtemdl->evlcod;
        $lv_prscod = $lo_plndtemdl->prscod; 
        $lv_patcod = $lo_plndtemdl->patcod; 
				if ( $lv_evlcod=='' ) {
          $lv_fldrec='';      
					$lv_dteto  = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dtefrm = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dteto->modify('last day of previous month');
					$lv_dtefrm->modify('first day of previous month');
					$lv_patflt= '';
					
					// obtenemos evoluciones realizadas del mes anterior
					$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evldte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'e.evldte');
					$lo_evl_rs = $lo_evlmdl->getList($lv_prm, null, null, false);
					
					// Generamos la lista de planificaciones ya evolucionadas
					foreach( $lo_evl_rs as $lv_row ) {
					 $lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['plndteid']; 
					}
					// obtenemos planificaciones del mes anterior que no están evolucionadas 
					$lv_prm = array('vewfldflt' =>'[~fltrow~]pld.plndteid'.chr(9).'NI'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																			'[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]pl.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'pld.plndteid');
					$lo_pln_rs = $lo_plndtemdl2->getList($lv_prm, null, null, false);
          
          /* ------------------------------------------------ */
          /* obtengo clase de documento 											*/
          /* ------------------------------------------------ */
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
          if ( $lv_docclscod=='' ) {															// si no se indicó
            $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).'HLT_EVL'.chr(9).chr(9).chr(9).
                                          '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                          );
            $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
            if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
              $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
            } else {
              return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
            }
          }
          if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) { // obtengo toda la info de la clase de documento
            $lo_plndtemdl->sysdoccls = $lo_docclsmdl;
          } else {
            echo 'No se pudieron cargar los datos de la clase de documento.';
          }
          /* ------------------------------------------------ */         
          /* Buscar datos sugerencia de material */
          /* 1. Busco el parametro para obtener el codigo de material segun la especialidad */
           $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
          if(!$lo_prmmdl->load(array('mdlcod'=>'PTMAT'))){
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt) );
          }
          
          /* 2. Busco los datos del paciente para obtener la clas. de enfermedad */
          $lo_patmdl = $this->co_reg->load->model('hltpat');	
          if(!$lo_patmdl->load(array('patcod'=>$lo_plndtemdl->patcod), false)){
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_patmdl->errcod,'errtxt'=>$lo_patmdl->errtxt) );
          }
          
          /*3. Busco el material */
          $lv_matcod = $this->co_reg->document->getTagValue($lo_prmmdl->mdlatrval001, $lo_patmdl->hltdisclscod);
          $lo_plndtemdl->mattxt = '';
          $lo_plndtemdl->matcod = '';
          $lo_matmdl = $this->co_reg->load->model('stkmat');	
          if($lv_matcod !=''){
            if(!$lo_matmdl->load(array('matcod'=>$lv_matcod), false)){
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_matmdl->errcod,'errtxt'=>$lo_matmdl->errtxt) );
            }
          }
          $lo_plndtemdl->matcod = $lo_matmdl->matcod;
          $lo_plndtemdl->mattxt = $lo_matmdl->mattxt;                
          
					// preparo datos de vista
					$lo_plndtemdl->evlatr = array();
					$lo_plndtemdl->evlspc = array();
					$lo_plndtemdl->evlmat = array();
					$lo_plndtemdl->evldte = $lo_plndtemdl->plndte;
					$lo_plndtemdl->docsts = 'P';
					//$lo_plndtemdl->hhcc=$lv_hhcc;
					
					$lv_prm = array('data' =>	$lo_plndtemdl,	// datos de planificación
													'actcod' => $this->data['actcod'],
													'rsplndte'=>$lo_pln_rs	// fechas no evolucionadas de mes anterior
													);
				
				// VER EVOLUCION
				} else {
					
					// cargo datos generales de la evolucion
					$lo_evlmdl->load( array('evlcod'=>$lv_evlcod), false );   
          // obtengo toda la info de la clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_evlmdl->sysdocclscod) ) ) {
						$lo_evlmdl->sysdoccls = $lo_docclsmdl;
					}

					// preparo datos de vista
					$lv_prm = array('doc' => $this->co_reg->document,
                          'data' => $lo_evlmdl,
													'actcod' => $this->data['actcod'],
													'rsplndte'=>array(),
													);
				}
				
        $lo_patprsrlsmdl = $this->co_reg->load->model('hltpatprsrls');
        $prmPatRsl = array('vewfldflt' =>'[~fltrow~]p.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9).
                           							 '[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).'MEC'.chr(9).chr(9).
                                      	 '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
        $lo_rs = $lo_patprsrlsmdl->getList($prmPatRsl);
        $lv_prm['data']->patprsrlscod='';
        $lv_prm['data']->patprsrlstxt='';
        if(count($lo_rs)>0){
          $lv_prm['data']->patprsrlscod;$lo_rs[0]['prscod'];
        	$lv_prm['data']->patprsrlstxt=$lo_rs[0]['prstxt'];
        }        
        
				// regreso la vista 
				$lv_prm['data']->hhcc=$lv_hhcc;
				$lv_buffer = 	$this->co_reg->document->getView( 'zcuclh_spcfrm002', $lv_prm);
				return $lv_buffer;
        break;
      }
      case '#zcuclh_frmact02_00':{
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');		
				$lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
				$lo_evlspcmdl = $this->co_reg->load->model('hltpatevlspc');
				$lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte'); 

				$lv_buf_arr = $this->co_reg->request->post;
				$lv_evldte = $this->co_reg->db->sqldate($lv_buf_arr['evldte']); 
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_evldte =(isset($this->co_reg->request->post['evldte'])?$this->co_reg->request->post['evldte']:$lp_prm['evldte']);
				
				$datemax = new DateTime("now");
				$datemax= $datemax->add(new DateInterval('P5D'));
				$lv_dte = new DateTime($this->co_reg->db->sqldate($lv_evldte));
				if ($lv_dte > $datemax){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'No es posible infundir la fecha seleccionada') );
				}
				$lv_evlinfprc=isset($this->co_reg->request->post['evlinfprc'])?$this->co_reg->request->post['evlinfprc']:'';
        
				$lv_docsts = ( $lv_evlinfprc=='1'?'A':'P' );
        
				$lv_buf_arr['docsts'] = $lv_docsts;
        $lv_buf_arr['evlinfprc']= $lv_evlinfprc;
				$lv_buf_arr['evlcmt']=$lv_buf_arr['evlcmt'] ;
				$lv_buf_arr['evlsub']=$lv_buf_arr['evlcnccmt'];
				$lv_buf_arr['evlevl']= $lv_buf_arr['evlevl'];
        $lv_buf_arr['fvrpt']=isset($lv_buf_arr['fvrpt'])?$lv_buf_arr['fvrpt']:'off';
        $lv_fvrpttxt = ( ($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1')?'SI':'NO' );
        $lv_buf_arr['evlatr001']='<row>';
				$lv_buf_arr['evlatr001'].= '<dte>'.$lv_evldte.'</dte>';
        $lv_buf_arr['evlatr001'].= '<evlcncmtv>'.$lv_buf_arr['evlcncmtv'].'</evlcncmtv>';
        $lv_buf_arr['evlatr001'].= '<evlcnccmt>'.$this->co_reg->db->sqldata($lv_buf_arr['evlcnccmt']).'</evlcnccmt>';
        $lv_buf_arr['evlatr001'].= '<evlinfprc>'.$this->co_reg->db->sqldata($lv_buf_arr['evlinfprc']).'</evlinfprc>';
        /* GEO */
        if(isset($lv_buf_arr['evllat'])){
          $lv_buf_arr['evlatr001'].= '<evllat>'.$this->co_reg->db->sqldata($lv_buf_arr['evllat']).'</evllat>';
          $lv_buf_arr['evlatr001'].= '<evllon>'.$this->co_reg->db->sqldata($lv_buf_arr['evllon']).'</evllon>';
        }
        
        $lv_buf_arr['evlatr001'].= '<fvrpt>'.$lv_buf_arr['fvrpt'].'</fvrpt>';
        $lv_buf_arr['evlatr001'].= '<fvrpttxt>'.$lv_fvrpttxt.'</fvrpttxt>';
        
        $lv_buf_arr['evlatr001'].= '<reqcc>'.$lv_buf_arr['reqcc'].'</reqcc>';
        $lv_buf_arr['evlatr001'].= '<dtesrv>'.$lv_buf_arr['dtesrv'].'</dtesrv>';
        $lv_buf_arr['evlatr001'].= '<mevlmd>'.$lv_buf_arr['mevlmd'].'</mevlmd>';
        //$lv_buf_arr['evlatr001'].= '<evlmd>'.$lv_buf_arr['evlmd'].'</evlmd>';
        $lv_buf_arr['evlatr001'].= '<ath>'.$lv_buf_arr['ath'].'</ath>'; 
        $lv_buf_arr['evlatr001'].= '<patprsrlscod>'.$lv_buf_arr['patprsrlscod'].'</patprsrlscod>'; 
        $lv_buf_arr['evlatr001'].= '<patprsrlstxt>'.$lv_buf_arr['patprsrlstxt'].'</patprsrlstxt>'; 
        $lv_buf_arr['evlatr001'].='</row>';
				$lv_buf_arr['evlobj']=$lv_buf_arr['evlinfprc']=='1'?'REALIZADO '.$lv_evldte :'NO REALIZADO' . chr(13) . $lv_buf_arr['evlcncmtv'] . chr(13) . $lv_buf_arr['evlcnccmt'];

				// EVOLUCION - grabo los datos de cabecera

				if ( $lo_evlmdl->save( $lv_buf_arr, false )==false ) {
          //echo $lo_evlmdl->getsysdata('sqlstm');
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
				}      				
				// EVOLUCION - INFUSION
				if ( $lv_docsts=='A' ) {

					// ARCHIVO. obtengo tipo de archivo por codigo externo
					$lo_upltypmdl = $this->co_reg->load->model('grldatfletyp');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]ft.fletypcodext'.chr(9).'='.chr(9).chr(9).'HLTEVL'.chr(9).chr(9).
                          							//'[~fltrow~]ft.objtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
                                        '[~fltrow~]ft.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                          'vewmaxrec'=>'1');
					$lo_rs = $lo_upltypmdl->getList( $lv_prm );
					if(count($lo_rs)>0){	// si encontro tipo de archivo de evoluciones, se suben los archivos adjuntos
						$lo_uplmdl = $this->co_reg->load->model('grldatupl');
						$this->co_reg->request->post['flesrctyp']='HLT_EVL';
						$this->co_reg->request->post['fletypcod']=$lo_rs[0]['fletypcod'];
						$this->co_reg->request->post['flesrccod']=$lo_evlmdl->evlcod;
						$lo_uplmdl->uploadFile($this->co_reg->request->post);        
					}
          
				}        
        $lv_errcod = '';
        $lv_errtxt = '';
        if($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1'){
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          $lo_plndtearr['hltplndteatrusricn']='fa-solid fa-message-medical';
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          /* DATOS DEL PACINTE */
          $lo_patdl = $this->co_reg->load->model('hltpat');
          $lo_patdl->load(array('patcod'=>$lv_buf_arr['patcod']),false);
          $lvDataFarma=$lv_buf_arr;
          $lvDataFarma['patcod']=$lo_patdl->patcod;
          $lvDataFarma['pattxt']=$lo_patdl->pattxt;
          $lvDataFarma['cuscod']=$lo_patdl->cuscod??'error';
          $lvDataFarma['custxt']=$lo_patdl->custxt??'error';
          $lvDataFarma['evlcod']=$lo_evlmdl->evlcod;
          $lvDataFarma['evlcmt']=$lv_evlinfprc=='1'?$lo_evlmdl->evlevl:$lo_evlmdl->evlsub ;
          
          $this->sendMailFarma($lvDataFarma);
        }
				return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt) );
				break;
      }
      case '#zcuclh_frmact02_04':{
        $lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte');
        $lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
        $lv_ret = array('errtyp'=>'','errcod'=>'0','errtxt'=>'') ;

				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);

				/* determino si se encuentra en alguna liquidación */
				$lo_prslqddocmdl = $this->co_reg->load->model('hltprslqddoc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
																			'[~fltrow~]ld.refobjcod001'.chr(9).'='.chr(9).chr(9).$lv_evlcod.chr(9).chr(9) );
				$lo_rssrv = $lo_prslqddocmdl->getList( $lv_prm );
				if ( count($lo_rssrv)>0 ) {
          $lv_ret=   array('errtyp'=>'E','errcod'=>'-4','errtxt'=>'No se puede borrar la evolucion. Esta incluida en la liquidacion ['.$lo_rssrv[0]['hltprslqdcod'].']');
				} else {
          
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          $lo_plndtearr['hltplndteatrusricn']='';
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
			
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
          $lo_evlmdl->delete( array('evlcod'=>$lv_evlcod), false);
       		$lv_ret=   array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt);
					
				}        
				return $this->co_reg->document->getJson($lv_ret);
				break;
      }
      // ?PRG=ZCUTP1_TIN&ACT=HLTPATEVLXO
      case '#zcuclh_frmact03':{
        //Instanciamos los modelos
				$lo_plndtemdl = $this->co_reg->load->model('hltplndte');	
				$lo_plndtemdl2 = $this->co_reg->load->model('hltplndte');	 
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');	
				$lo_vew = $this->co_reg->load->model('grlvew');
				
				//Obtenemos los parametros post
				$lv_evlcod = $this->co_reg->request->post['evlcod']??'';
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_hhcc =(isset($this->co_reg->request->post['hhcc'])?$this->co_reg->request->post['hhcc']:'');

        // Buscar datos sugerencia de material 
        // 1. Busco el parametro para obtener los campos obligatorios seguespecialidad 
        $lv_spccod = (isset($this->co_reg->request->post['spccod'])?$this->co_reg->request->post['spccod']:($lp_prm['spccod']??''));
        
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        $lv_fldrec=[];
        if($lo_prmmdl->load(array('mdlcod'=>'HLTSPCFRMREQ'))){
          $lv_fldrec=explode(';',$this->co_reg->document->getTagValue(strtolower($lo_prmmdl->mdlatrval001), $lv_spccod));
        }      
					// cargo la evolución
					$lo_plndtemdl->load( array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid) );
        				
				// CREAR EVOLUCION
				if ( $lv_evlcod=='' ) {
					
					$lv_plndte = $lo_plndtemdl->plndte;
					$lv_evlcod = $lo_plndtemdl->evlcod;
					$lv_prscod = $lo_plndtemdl->prscod; 
					$lv_patcod = $lo_plndtemdl->patcod; 
					
					$lv_dteto  = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dtefrm = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dteto->modify('last day of previous month');
					$lv_dtefrm->modify('first day of previous month');
					$lv_patflt= '';
					
					// obtenemos evoluciones realizadas del mes anterior
					$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evldte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'e.evldte');
					$lo_evl_rs = $lo_evlmdl->getList($lv_prm, null, null, false);
					
					// Generamos la lista de planificaciones ya evolucionadas
					foreach( $lo_evl_rs as $lv_row ) {
					 $lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['plndteid']; 
					}
					// obtenemos planificaciones del mes anterior que no están evolucionadas 
					$lv_prm = array('vewfldflt' =>'[~fltrow~]pld.plndteid'.chr(9).'NI'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																			'[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]pl.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'pld.plndteid');
					$lo_pln_rs = $lo_plndtemdl2->getList($lv_prm, null, null, false);  
          
          // obtengo clase de documento
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
          if ( $lv_docclscod=='' ) {															// si no se indicó
            $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).'HLT_EVL'.chr(9).chr(9).chr(9).
                                          '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                          );
            $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
            if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
              $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
            } else {
              return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
            }
          }
          if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
            $lo_plndtemdl->sysdoccls = $lo_docclsmdl;
          } else {
            echo 'No se pudieron cargar los datos de la clase de documento.';
          }
          
          // Buscar datos sugerencia de material 
          // 1. Busco el parametro para obtener el codigo de material segun la especialidad 
           $lo_prmmatmdl = $this->co_reg->load->model('sysappmdlprm');	
          if(!$lo_prmmatmdl->load(array('mdlcod'=>'PTMAT'))){
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmatmdl->errcod,'errtxt'=>$lo_prmmatmdl->errtxt));
          }
          
          // 2. Busco los datos del paciente para obtener la clas. de enfermedad 
          $lo_patmdl = $this->co_reg->load->model('hltpat');	
          if(!$lo_patmdl->load(array('patcod'=>$lo_plndtemdl->patcod),false)){
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_patmdl->errcod,'errtxt'=>$lo_patmdl->errtxt) );
          }
          
          //3. Busco el material
          $lv_matcod = $this->co_reg->document->getTagValue($lo_prmmatmdl->mdlatrval001, $lo_patmdl->hltdisclscod);
          $lo_plndtemdl->mattxt = '';
          $lo_plndtemdl->matcod = '';
          $lo_matmdl = $this->co_reg->load->model('stkmat');	
          if($lv_matcod !=''){
            if(!$lo_matmdl->load(array('matcod'=>$lv_matcod),false)){
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_matmdl->errcod,'errtxt'=>$lo_matmdl->errtxt) );
            }
          }
          $lo_plndtemdl->matcod = $lo_matmdl->matcod;
          $lo_plndtemdl->mattxt = $lo_matmdl->mattxt;
          $lo_plndtemdl->matuntcod = $lo_matmdl->matuntcod;
          
					// preparo datos de vista
					$lo_plndtemdl->evlatr = array();
					$lo_plndtemdl->evlspc = array();
					$lo_plndtemdl->evlmat = array();
					$lo_plndtemdl->evldte = $lo_plndtemdl->plndte;
					$lo_plndtemdl->docsts = 'P';
					$lv_prm = array('data' =>	$lo_plndtemdl,	// datos de planificación
													'actcod' => $this->data['actcod'],
													'rsplndte'=>$lo_pln_rs	// fechas no evolucionadas de mes anterior
													);
				// VER EVOLUCION
				} else {
					// cargo datos generales de la evolucion
					$lo_evlmdl->load( array('evlcod'=>$lv_evlcod), false );   
          // obtengo toda la info de la clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_evlmdl->sysdocclscod) ) ) {
						$lo_evlmdl->sysdoccls = $lo_docclsmdl;
					}
          $lo_plndtemdl->matuntcod = '';

					// preparo datos de vista
					$lv_prm = array('doc' => $this->co_reg->document,'data' => $lo_evlmdl,
													'actcod' => $this->data['actcod'],
													'rsplndte'=>array(),
													);
				}
        
        //Buscar motivos de no infucion dependiendo de el financiador de la planificacion
        $lo_prmmdlmtv = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdlmtv->load(array('mdlcod'=>'EVLCNCMTVLST'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdlmtv->errcod,'errtxt'=>$lo_prmmdlmtv->errtxt) );
        }
        $lv_mtvarr=$this->getServiceNonExecutionReasons(array('mdlcod'=>'EVLCNCMTVLST','prmmdl'=>$lo_prmmdlmtv));
        $lv_prm['data']->evlcncmtvlst = array_key_exists($lo_plndtemdl->cuscod,$lv_mtvarr)?$lv_mtvarr[$lo_plndtemdl->cuscod]:$lv_mtvarr['ALL'];
        $lv_prm['data']->evlcncmtvlst2=$this->getServiceNonExecutionReasons(array('mdlcod'=>'EVLCNCMTVLST','prmmdl'=>$lo_prmmdlmtv,'prmkey'=>'EVLCNCMTVLST2'));
				$lv_prm['data']->hhcc=$lv_hhcc;
        $lv_prm['data']->fldrec=$lv_fldrec;
        
        
        //Buscamos los textos          
				$lv_txttypcod = $this->co_reg->document->gettagvalue($lo_prmmdlmtv->mdlatrval001,'txttypcod');
        $lo_grldattxtmdl = $this->co_reg->load->model('grldattxt');
        $lv_prmtxt = array('vewfldflt' =>'[~fltrow~]t.txtsrctyp '.chr(9).'='.chr(9).chr(9).'hlt_pln'.chr(9).chr(9).
                                         '[~fltrow~]t.txttypcod '.chr(9).'='.chr(9).chr(9).$lv_txttypcod.chr(9).chr(9).
                             						 '[~fltrow~]t.txtsrccod '.chr(9).'='.chr(9).chr(9).$lv_plnid.chr(9).chr(9));
        $lv_rstxt=$lo_grldattxtmdl->getList( $lv_prmtxt);
        $lv_prm['data']->txttxt='';
        if(count($lv_rstxt)>0){
					$lv_prm['data']->matdos=strip_tags($lv_rstxt[0]['txttxt']); 
        }
        // devuelvo vista
				return $this->co_reg->document->getView( 'zcuclh_spcfrm003', $lv_prm); 
				break;
      }
      case '#zcuclh_frmact03_00':{
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');		
				$lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
				$lo_evlspcmdl = $this->co_reg->load->model('hltpatevlspc');
				$lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte'); 

				$lv_buf_arr = $this->co_reg->request->post;
				$lv_evldte = $this->co_reg->db->sqldate($lv_buf_arr['evldte']); 
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_evldte =(isset($this->co_reg->request->post['evldte'])?$this->co_reg->request->post['evldte']:$lp_prm['evldte']);
        
        
        /* DATOS DEL PACINTE */
        $lo_patdl = $this->co_reg->load->model('hltpat');
        $lo_patdl->load(array('patcod'=>$lv_buf_arr['patcod']),false);
        // grabo el cotrol de cambio del peso
        $lv_chgtxt = '';
        $lv_oldval = $lo_patdl->patwgt;
        $lv_newval = $lv_buf_arr['patwgt'];
        $lv_chgtxt .= '<atr><nme>patwgt</nme><old>'.$lv_oldval.'</old><new>'.$lv_newval.'</new></atr>';
        $lo_docchgmdl = $this->co_reg->load->model('sysdocchg');
        $lv_prm = array('chgdocsrctyp'=>'HLT_PAT', 'chgdocsrccod'=>$lo_patdl->patcod, 'chgdocatr'=>$lv_chgtxt, 'docsts'=>'A');
        $lo_docchgmdl->save( $lv_prm );
        
        
				
				$datemax = new DateTime("now");
				$datemax= $datemax->add(new DateInterval('P5D'));
				$lv_dte = new DateTime($this->co_reg->db->sqldate($lv_evldte));
				if ($lv_dte > $datemax){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'No es posible infundir la fecha seleccionada') );
				}
				$lv_evlinfprc=isset($this->co_reg->request->post['evlinfprc'])?$this->co_reg->request->post['evlinfprc']:'';
        
				$lv_docsts = ( $lv_evlinfprc=='1'?'A':'P' );
        
				$lv_buf_arr['docsts'] = $lv_docsts;
        $lv_buf_arr['evlinfprc']= $lv_evlinfprc;
				$lv_buf_arr['evlcmt']=$lv_buf_arr['evlcmt'] ;
				$lv_buf_arr['evlsub']=$lv_buf_arr['evlcnccmt'];
				$lv_buf_arr['evlevl']= $lv_buf_arr['evlevl'];
        $lv_buf_arr['fvrpt']=isset($lv_buf_arr['fvrpt'])?$lv_buf_arr['fvrpt']:'off';
        $lv_fvrpttxt = ( ($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1')?'SI':'NO' );
        $lv_buf_arr['evlatr001']='<row>';
				$lv_buf_arr['evlatr001'].= '<dte>'.$lv_evldte.'</dte>';
        $lv_buf_arr['evlatr001'].= '<evlcncmtv>'.$lv_buf_arr['evlcncmtv'].'</evlcncmtv>';
        $lv_buf_arr['evlatr001'].= '<evlcnccmt>'.$this->co_reg->db->sqldata($lv_buf_arr['evlcnccmt']).'</evlcnccmt>';
        $lv_buf_arr['evlatr001'].= '<evlinfprc>'.$this->co_reg->db->sqldata($lv_buf_arr['evlinfprc']).'</evlinfprc>';
        /* GEO */
        if(isset($lv_buf_arr['evllat'])){
          $lv_buf_arr['evlatr001'].= '<evllat>'.$this->co_reg->db->sqldata($lv_buf_arr['evllat']).'</evllat>';
          $lv_buf_arr['evlatr001'].= '<evllon>'.$this->co_reg->db->sqldata($lv_buf_arr['evllon']).'</evllon>';
        }
        $lv_buf_arr['evlatr001'].= '<fvrpt>'.$lv_buf_arr['fvrpt'].'</fvrpt>';
        $lv_buf_arr['evlatr001'].= '<fvrpttxt>'.$lv_fvrpttxt.'</fvrpttxt>';
        $lv_buf_arr['evlatr001'].= '<patwgt>'.$lv_buf_arr['patwgt'].'</patwgt>';
        $lv_buf_arr['evlatr001'].= '<infprg>'.$lv_buf_arr['infprg'].'</infprg>';
        $lv_buf_arr['evlatr001'].= '<infexe>'.$lv_buf_arr['infexe'].'</infexe>';
        $lv_buf_arr['evlatr001'].= '<evlcncmtv2>'.$lv_buf_arr['evlcncmtv2'].'</evlcncmtv2>';
        $lv_buf_arr['evlatr001'].= '<matdos>'.$lv_buf_arr['matdos'].'</matdos>';
        $lv_buf_arr['evlatr001'].='</row>';
				$lv_buf_arr['evlobj']=$lv_buf_arr['evlinfprc']=='1'?'REALIZADO '.$lv_evldte :'NO REALIZADO' . chr(13) . $lv_buf_arr['evlcncmtv'] . chr(13) . $lv_buf_arr['evlcnccmt'];
				
        //Obtengo el peso en los atributos
        $lv_patwgt='';
        $lv_buffer = isset($this->co_reg->request->post['evlatr'])?$this->co_reg->request->post['evlatr']:'';
        if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_atr_arr = json_decode($lv_buffer,true);
            foreach( $lv_atr_arr as $lv_row ) {
               $lv_patwgt=($lv_patwgt==''?$lv_row['p']:$lv_patwgt);
            }
            $lv_buf_arr['evlatr001'].='<patwgt>'.$lv_patwgt.'</patwgt>';
        }
				// EVOLUCION - grabo los datos de cabecera

				if ( $lo_evlmdl->save( $lv_buf_arr, false )==false ) {
          //echo $lo_evlmdl->getsysdata('sqlstm');
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
				}      				
				// EVOLUCION - INFUSION
				if ( $lv_docsts=='A' ) {

					// ARCHIVO. obtengo tipo de archivo por codigo externo
					$lo_upltypmdl = $this->co_reg->load->model('grldatfletyp');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]ft.fletypcodext'.chr(9).'='.chr(9).chr(9).'HLTEVL'.chr(9).chr(9).
                          							//'[~fltrow~]ft.objtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
                                        '[~fltrow~]ft.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                          'vewmaxrec'=>'1');
					$lo_rs = $lo_upltypmdl->getList( $lv_prm );
					if(count($lo_rs)>0){	// si encontro tipo de archivo de evoluciones, se suben los archivos adjuntos
						$lo_uplmdl = $this->co_reg->load->model('grldatupl');
						$this->co_reg->request->post['flesrctyp']='HLT_EVL';
						$this->co_reg->request->post['fletypcod']=$lo_rs[0]['fletypcod'];
						$this->co_reg->request->post['flesrccod']=$lo_evlmdl->evlcod;
						$lo_uplmdl->uploadFile($this->co_reg->request->post);        
					}
          
					// EVOLUCION MATERIALES - grabo datos de materiales
					$lv_buffer = $this->co_reg->request->post['evlmat'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_mat_arr = json_decode($lv_buffer,true);
						foreach( $lv_mat_arr as $lv_row ) {
							$lv_arr = $lv_row;
							$lv_arr['evlcod'] = $lo_evlmdl->evlcod;
							$lv_arr['matatrval001'] = '<strtme>'.$lv_row['atrstrtme'].'</strtme><endtme>'.$lv_row['atrendtme'].'</endtme><advrea>'.$lv_row['atradvrea'].'</advrea>';
							$lv_arr['docsts'] = 'A';
							if ( isset($lv_row['deleted']) ) {
								if ($lo_evlmatmdl->delete()==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
								}
							} else if ($lo_evlmatmdl->save( $lv_arr )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
							}
						}
					}
				}        
        $lv_errcod = '';
        $lv_errtxt = '';
        if($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1'){
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          $lo_plndtearr['hltplndteatrusricn']='fa-solid fa-message-medical';
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lvDataFarma=$lv_buf_arr;
          $lvDataFarma['patcod']=$lo_patdl->patcod;
          $lvDataFarma['pattxt']=$lo_patdl->pattxt;
          $lvDataFarma['cuscod']=$lo_patdl->cuscod??'error';
          $lvDataFarma['custxt']=$lo_patdl->custxt??'error';
          $lvDataFarma['evlcod']=$lo_evlmdl->evlcod;//$lo_patdl->custxt??'error';
          $lvDataFarma['evlcmt']=$lv_evlinfprc=='1'?$lo_evlmdl->evlevl:$lo_evlmdl->evlsub ;
          
          $this->sendMailFarma($lvDataFarma);
        }
				return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt) );
				break;
      }
      case '#zcuclh_frmact03_04':{
        $lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);

				/* determino si se encuentra en alguna liquidación */
				$lo_prslqddocmdl = $this->co_reg->load->model('hltprslqddoc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
																			'[~fltrow~]ld.refobjcod001'.chr(9).'='.chr(9).chr(9).$lv_evlcod.chr(9).chr(9) );
				$lo_rssrv = $lo_prslqddocmdl->getList( $lv_prm );
				if ( count($lo_rssrv)>0 ) {
					$lv_ret = array('errtyp'=>"E", 'errcod'=>-4, 'errtxt'=>'No se puede borrar la evolucion. Esta incluida en la liquidacion ['.$lo_rssrv[0]['hltprslqdcod'].']');
				} else {
			
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
					if ( $lo_evlmdl->delete( array('evlcod'=>$lv_evlcod), false )==false ) {
						$lv_ret = array('errtyp'=>"E", 'errcod'=>$lo_evlmdl->errcod, 'errtxt'=>$lo_evlmdl->errtxt );
					} else {
            // GRABO EL ICONO EN LA PLANIFICACION
            // OBTEGO LA PLANIFICACION
            $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
            $lo_plndtearr= array();
            $lo_plndtearr['plndteid']=$this->co_reg->request->post['plndteid'];
            $lo_plndtearr['plnid']=$this->co_reg->request->post['plnid'];;
            if (!$lo_plndtemdl->load($lo_plndtearr)) {
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
            }
            $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
            $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
            $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
            $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
            $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
            $lo_plndtearr['serid']=$lo_plndtemdl->serid;
            $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
            $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
            $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
            $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
            $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
            $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
            $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
            $lo_plndtearr['hltplndteatrusricn']='';
            if (!$lo_plndtemdl->save($lo_plndtearr)) {
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
            }
						$lv_ret = array('errtyp'=>"S", 'errcod'=>0, 'errtxt'=>'');
					}
				}
        return $this->co_reg->document->getJson($lv_ret);
				//return $lv_ret;
        break;
      }
      // ?PRG=ZCUTP1&ACT=evlcoa
      case '#zcuclh_frmact04':{
        /*Instanciamos los modelos*/
				$lo_plndtemdl = $this->co_reg->load->model('hltplndte');	
				$lo_plndtemdl2 = $this->co_reg->load->model('hltplndte');	 
				$lo_patmdl = $this->co_reg->load->model('hltpat');
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
				$lo_vew = $this->co_reg->load->model('grlvew');
				
				/*Obtenemos los parametros post*/
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:'');
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
        
        //Busco los materiales
        $lo_matmdl = $this->co_reg->load->model('stkmat');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													'vewfldord' => 'm.mattxt');
        
        $lo_mat_rs=$lo_matmdl->getList($lv_prm, null, null, false);
        
        $lo_plndtemdl->load( array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid) );
        
				// CREAR EVOLUCION
				if ( $lv_evlcod=='' ) {
					
					// cargo la evolución
					$lv_plndte = $lo_plndtemdl->plndte;
					$lv_evlcod = $lo_plndtemdl->evlcod;
					$lv_prscod = $lo_plndtemdl->prscod; 
					$lv_patcod = $lo_plndtemdl->patcod; 
					
					$lv_dteto  = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dtefrm = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dteto->modify('last day of previous month');
					$lv_dtefrm->modify('first day of previous month');
					$lv_patflt= '';
					
					// obtenemos evoluciones realizadas del mes anterior
					$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evldte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'e.evldte');
					$lo_evl_rs = $lo_evlmdl->getList($lv_prm, null, null, false);
					
					// Generamos la lista de planificaciones ya evolucionadas
					foreach( $lo_evl_rs as $lv_row ) {
					 $lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['plndteid']; 
					}
					// obtenemos planificaciones del mes anterior que no están evolucionadas 
					$lv_prm = array('vewfldflt' =>'[~fltrow~]pld.plndteid'.chr(9).'NI'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																			'[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]pl.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'pld.plndteid');
					$lo_pln_rs = $lo_plndtemdl2->getList($lv_prm, null, null, false);  
					
          /* ------------------------------------------------ */
          /* obtengo paciente           											*/
          /* ------------------------------------------------ */
          $lo_patmdl->load(array('patcod'=>$lv_patcod),false);
            
          /* ------------------------------------------------ */
          /* obtengo clase de documento 											*/
          /* ------------------------------------------------ */
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
          if ( $lv_docclscod=='' ) {															// si no se indicó
            $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).'HLT_EVL'.chr(9).chr(9).chr(9).
                                          '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                          );
            $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
            if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
              $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
            } else {
              return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
            }
          }
          if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
            $lo_plndtemdl->sysdoccls = $lo_docclsmdl;
          } else {
            echo 'No se pudieron cargar los datos de la clase de documento.';
          }
          /* ------------------------------------------------ */
          
					// preparo datos de vista
					$lo_plndtemdl->evlatr = array();
					$lo_plndtemdl->evlspc = array();
					$lo_plndtemdl->evlmat = array();
					$lo_plndtemdl->evldte = $lo_plndtemdl->plndte;
          $lo_plndtemdl->cuscod = $lo_patmdl->custxt;
					$lo_plndtemdl->docsts = 'P';
					
					$lv_prm = array('lang'  => $this->co_reg->language,
													'input' => $this->co_reg->input,
													'sec' => $this->co_reg->sec,
													'doc' => $this->co_reg->document,
													'data' =>	$lo_plndtemdl,	// datos de planificación
													'actcod' => $this->data['actcod'],
                          'matlst'=>$lo_mat_rs,
													'rsplndte'=>$lo_pln_rs	// fechas no evolucionadas de mes anterior
													);
				
				// VER EVOLUCION
				} else {
					
					// cargo datos generales de la evolucion
					$lo_evlmdl->load( array('evlcod'=>$lv_evlcod),false );
					// obtengo toda la info de la clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_evlmdl->sysdocclscod) ) ) {
						$lo_evlmdl->sysdoccls = $lo_docclsmdl;
					}
          
					// preparo datos de vista
					$lv_prm = array('lang'  => $this->co_reg->language,
													'input' => $this->co_reg->input,
													'sec' => $this->co_reg->sec,
													'doc' => $this->co_reg->document,
													'data' => $lo_evlmdl,
													'actcod' => $this->data['actcod'],
                          'matlst'=>$lo_mat_rs,
													'rsplndte'=>array()
													);
				}
				
				// regreso la vista
        
        //Buscar motivos de no infucion dependiendo de el financiador de la planificacion
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'EVLCNCMTVLST'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt) );
        }

        $lv_evlcncmtvlst = $this->co_reg->document->gettagvalue($lo_prmmdl->mdlatrval001,'CUS_'.$lo_plndtemdl->cuscod);	// MAILS
        if($lv_evlcncmtvlst==''){
          $lv_evlcncmtvlst = $this->co_reg->document->gettagvalue($lo_prmmdl->mdlatrval001,'ALL');	// MAILS
        }
        $lv_evlcncmtvrows = explode(";", $lv_evlcncmtvlst);
        $lv_mtvarr=array();
        foreach($lv_evlcncmtvrows as $lv_rowmtv){
          $lv_cncmtvrow = explode(",", $lv_rowmtv);
          $lv_mtvarr[$lv_cncmtvrow[0]]=$lv_cncmtvrow[1];
        }
        $lv_prm['data']->evlcncmtvlst = $lv_mtvarr;
        
        // 1. Busco el parametro para obtener los campos obligatorios segun especialidad 
        $lp_prm['spccod']=$lp_prm['spccod']??'1';
        $lv_spccod = (isset($this->co_reg->request->post['spccod'])?$this->co_reg->request->post['spccod']:$lp_prm['spccod']);
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        $lv_fldrec=[];
        if($lo_prmmdl->load(array('mdlcod'=>'HLTSPCFRMREQ'))){
          $lo_prmmdl->mdlatrval001=str_replace(',',';',$lo_prmmdl->mdlatrval001);
          $lv_fldrec=explode(';',$this->co_reg->document->getTagValue(strtolower($lo_prmmdl->mdlatrval001), $lv_spccod));
        }     
        $lv_prm['data']->fldrec=$lv_fldrec;
        $lv_hhcc =(isset($this->co_reg->request->post['hhcc'])?$this->co_reg->request->post['hhcc']:'');
				$lv_prm['data']->hhcc=$lv_hhcc;
				$lv_buffer = 	$this->co_reg->load->view('zcuclh_spcfrm004', $lv_prm);
				return $lv_buffer;
        break;
       
      }
      case '#zcuclh_frmact04_00':{
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');		
				$lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
				$lo_evlspcmdl = $this->co_reg->load->model('hltpatevlspc');
				$lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte'); 

				$lv_buf_arr = $this->co_reg->request->post;
				$lv_evldte = $this->co_reg->db->sqldate($lv_buf_arr['evldte']); 
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_evldte =(isset($this->co_reg->request->post['evldte'])?$this->co_reg->request->post['evldte']:$lp_prm['evldte']);
				$datemax = new DateTime("now");
				$datemax= $datemax->add(new DateInterval('P5D'));
				$lv_dte = new DateTime($this->co_reg->db->sqldate($lv_evldte));
				if ($lv_dte > $datemax){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'No es posible infundir la fecha seleccionada') );
				}
				$lv_evlinfprc=isset($this->co_reg->request->post['evlinfprc'])?$this->co_reg->request->post['evlinfprc']:'';
        
				$lv_docsts = ( $lv_evlinfprc=='1'?'A':'P' );
        
				$lv_buf_arr['docsts'] = $lv_docsts;
        $lv_buf_arr['evlinfprc']= $lv_evlinfprc;
				$lv_buf_arr['evlcmt']=$lv_buf_arr['evlcmt'] ;
				$lv_buf_arr['evlsub']=$lv_buf_arr['evlcnccmt'];
				$lv_buf_arr['evlevl']= $lv_buf_arr['evlevl'];
        $lv_buf_arr['fvrpt']=isset($lv_buf_arr['fvrpt'])?$lv_buf_arr['fvrpt']:'off';
        $lv_fvrpttxt = ( ($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1')?'SI':'NO' );
        $lv_buf_arr['evlatr001']='<row>';
				$lv_buf_arr['evlatr001'].= '<dte>'.$lv_evldte.'</dte>';
        $lv_buf_arr['evlatr001'] .= '<evlcmt>'.$this->co_reg->db->sqldata($lv_buf_arr['evlcmt']).'</evlcmt>';
        $lv_buf_arr['evlatr001'] .= '<evlmtt>'.utf8_encode($lv_buf_arr['evlmtt']).'</evlmtt>';
        $lv_buf_arr['evlatr001'] .= '<evllug>'.utf8_encode($lv_buf_arr['evllug']).'</evllug>';
        $lv_buf_arr['evlatr001'] .= '<evlpa1>'.utf8_encode($lv_buf_arr['evlpa1']).'</evlpa1>';
        $lv_buf_arr['evlatr001'] .= '<evlpa2>'.utf8_encode($lv_buf_arr['evlpa2']).'</evlpa2>';
        $lv_buf_arr['evlatr001'] .= '<aplenf>'.utf8_encode($lv_buf_arr['aplenf']).'</aplenf>';
        $lv_buf_arr['evlatr001'].= '<fvrpt>'.$lv_buf_arr['fvrpt'].'</fvrpt>';
        $lv_buf_arr['evlatr001'].= '<patwgt>'.$lv_buf_arr['patwgt'].'</patwgt>';
        $lv_buf_arr['evlatr001'].= '<fvrpttxt>'.$lv_fvrpttxt.'</fvrpttxt>';
        
        /* GEO */
        if(isset($lv_buf_arr['evllat'])){
          $lv_buf_arr['evlatr001'].= '<evllat>'.$this->co_reg->db->sqldata($lv_buf_arr['evllat']).'</evllat>';
          $lv_buf_arr['evlatr001'].= '<evllon>'.$this->co_reg->db->sqldata($lv_buf_arr['evllon']).'</evllon>';
        }
        
        $lv_buf_arr['evlatr001'].= '<fvrpt>'.$lv_buf_arr['fvrpt'].'</fvrpt>';
        $lv_buf_arr['evlatr001'].= '<fvrpttxt>'.$lv_fvrpttxt.'</fvrpttxt>';
        $lv_buf_arr['evlatr001'].='</row>';
				$lv_buf_arr['evlobj']=$lv_buf_arr['evlinfprc']=='1'?'REALIZADO '.$lv_evldte :'NO REALIZADO' . chr(13) . $lv_buf_arr['evlcncmtv'] . chr(13) . $lv_buf_arr['evlcnccmt'];
				
        //Obtengo el peso en los atributos
        $lv_patwgt='';
        $lv_buffer = isset($this->co_reg->request->post['evlatr'])?$this->co_reg->request->post['evlatr']:'';
        if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_atr_arr = json_decode($lv_buffer,true);
            foreach( $lv_atr_arr as $lv_row ) {
               $lv_patwgt=($lv_patwgt==''?$lv_row['p']:$lv_patwgt);
            }
            $lv_buf_arr['evlatr001'].='<patwgt>'.$lv_patwgt.'</patwgt>';
        }
        /* DATOS DEL PACINTE */
        $lo_patdl = $this->co_reg->load->model('hltpat');
        $lo_patdl->load(array('patcod'=>$lv_buf_arr['patcod']),false);
        
        // grabo el cotrol de cambio del peso
        $lv_chgtxt = '';
        $lv_newval = $lv_buf_arr['patwgt'];
        $lv_oldval = $lo_patdl->patwgt;
        $lv_chgtxt .= '<atr><nme>patwgt</nme><old>'.$lv_oldval.'</old><new>'.$lv_newval.'</new></atr>';
        $lo_docchgmdl = $this->co_reg->load->model('sysdocchg');
        $lv_prm = array('chgdocsrctyp'=>'HLT_PAT', 'chgdocsrccod'=>$lo_patdl->patcod, 'chgdocatr'=>$lv_chgtxt, 'docsts'=>'A');
        $lo_docchgmdl->save( $lv_prm );
        
        
				// EVOLUCION - grabo los datos de cabecera

				if ( $lo_evlmdl->save( $lv_buf_arr, false )==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
				}      				
				// EVOLUCION - INFUSION
				if ( $lv_docsts=='A' ) {

					// ARCHIVO. obtengo tipo de archivo por codigo externo
					$lo_upltypmdl = $this->co_reg->load->model('grldatfletyp');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]ft.fletypcodext'.chr(9).'='.chr(9).chr(9).'HLTEVL'.chr(9).chr(9).
                          							//'[~fltrow~]ft.objtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
                                        '[~fltrow~]ft.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                          'vewmaxrec'=>'1');
					$lo_rs = $lo_upltypmdl->getList( $lv_prm );
					if(count($lo_rs)>0){	// si encontro tipo de archivo de evoluciones, se suben los archivos adjuntos
						$lo_uplmdl = $this->co_reg->load->model('grldatupl');
						$this->co_reg->request->post['flesrctyp']='HLT_EVL';
						$this->co_reg->request->post['fletypcod']=$lo_rs[0]['fletypcod'];
						$this->co_reg->request->post['flesrccod']=$lo_evlmdl->evlcod;
						$lo_uplmdl->uploadFile($this->co_reg->request->post);        
					}
          
          // EVOLUCION MATERIALES - grabo datos de materiales
					$lv_buffer = $this->co_reg->request->post['evlmat'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_mat_arr = json_decode($lv_buffer,true);
						foreach( $lv_mat_arr as $lv_row ) {
							$lv_arr = $lv_row;
							$lv_arr['evlcod'] = $lo_evlmdl->evlcod;
							$lv_arr['matatrval001'] = '<strtme>'.$lv_row['atrstrtme'].'</strtme><endtme>'.$lv_row['atrendtme'].'</endtme><advrea>'.$lv_row['atradvrea'].'</advrea>';
							$lv_arr['docsts'] = 'A';
							if ( isset($lv_row['deleted']) ) {
								if ($lo_evlmatmdl->delete()==false) {
                  return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
								}
							} else if ($lo_evlmatmdl->save( $lv_arr )==false) {
                return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
							}
						}
					}
				}        
        $lv_errcod = '';
        $lv_errtxt = '';
        if($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1'){
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          $lo_plndtearr['hltplndteatrusricn']='fa-solid fa-message-medical';;     
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $ctlZcuTin = $this->co_reg->load->controller('zcutp1_tin');
          $lvDataFarma=$lv_buf_arr;
          $lvDataFarma['patcod']=$lo_patdl->patcod;
          $lvDataFarma['pattxt']=$lo_patdl->pattxt;
          $lvDataFarma['cuscod']=$lo_patdl->cuscod??'error';
          $lvDataFarma['custxt']=$lo_patdl->custxt??'error';
          $lvDataFarma['evlcod']=$lo_evlmdl->evlcod;
          $lvDataFarma['evlcmt']=$lv_evlinfprc=='1'?$lo_evlmdl->evlevl:$lo_evlmdl->evlsub ;
          $ctlZcuTin->sendMailFarma($lvDataFarma);
        }
				return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt) );
				break;
      }
      case '#zcuclh_frmact04_04':{
        $lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>''); 
        $lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte');
        
        $lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);

				/* determino si se encuentra en alguna liquidación */
				$lo_prslqddocmdl = $this->co_reg->load->model('hltprslqddoc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
																			'[~fltrow~]ld.refobjcod001'.chr(9).'='.chr(9).chr(9).$lv_evlcod.chr(9).chr(9) );
				$lo_rssrv = $lo_prslqddocmdl->getList( $lv_prm );
				if ( count($lo_rssrv)>0 ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-4,'errtxt'=>'No se puede borrar la evolucion. Esta incluida en la liquidacion ['.$lo_rssrv[0]['hltprslqdcod'].']') );
				} else {
			
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
					if ( !$lo_evlmdl->delete( array('evlcod'=>$lv_evlcod), false ) ) {
            
            //return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->getsysdata('sqlstm')) );
						return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
					}
          /* GRABO EL ICONO EN LA PLANIFICACION*/
          /* OBTEGO LA PLANIFICACION */
          $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
          $lo_plndtearr= array();
          $lo_plndtearr['plndteid']=$lv_plndteid;
          $lo_plndtearr['plnid']=$lv_plnid;
          if (!$lo_plndtemdl->load($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>'02') );
            //return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }
          $lo_plndtearr['cuscod']=$lo_plndtemdl->cuscod;
          $lo_plndtearr['patcod']=$lo_plndtemdl->patcod;
          $lo_plndtearr['prscod']=$lo_plndtemdl->prscod;
          $lo_plndtearr['spccod']=$lo_plndtemdl->spccod;
          $lo_plndtearr['plndte']=$lo_plndtemdl->plndte->format('Ymd');
          $lo_plndtearr['serid']=$lo_plndtemdl->serid;
          $lo_plndtearr['plntrn']=$lo_plndtemdl->plntrn;
          $lo_plndtearr['plnqty']=$lo_plndtemdl->plnqty;
          $lo_plndtearr['plncmt']=$lo_plndtemdl->plncmt;
          $lo_plndtearr['docsts']=$lo_plndtemdl->docsts;
          $lo_plndtearr['grpserid']=$lo_plndtemdl->grpserid;
          $lo_plndtearr['plnqtystk']=$lo_plndtemdl->plnqtystk;
          $lo_plndtearr['plndteatr']=$lo_plndtemdl->plndteatr;
          $lo_plndtearr['hltplndteatrusricn']='';
          if (!$lo_plndtemdl->save($lo_plndtearr)) {
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>'03') );
          }					
				}
        return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
				break;
      }
      // ?PRG=ZCUTP1&ACT=evlgetsmp
      case '#zcuclh_frmact05':{
        /*Instanciamos los modelos*/
				$lo_plndtemdl = $this->co_reg->load->model('hltplndte');	
				$lo_plndtemdl2 = $this->co_reg->load->model('hltplndte');	 
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');	
				$lo_vew = $this->co_reg->load->model('grlvew');
				
				/*Obtenemos los parametros post*/
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:'');
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				
        // cargo la evolución
				$lo_plndtemdl->load( array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid) );
				// CREAR EVOLUCION
				if ( $lv_evlcod=='' ) {
					
					// cargo la evolución
					$lv_plndte = $lo_plndtemdl->plndte;
					$lv_evlcod = $lo_plndtemdl->evlcod;
					$lv_prscod = $lo_plndtemdl->prscod; 
					$lv_patcod = $lo_plndtemdl->patcod; 
          
					$lv_dteto  = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dtefrm = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dteto->modify('last day of previous month');
					$lv_dtefrm->modify('first day of previous month');
					$lv_patflt= '';
					
					// obtenemos evoluciones realizadas del mes anterior
					$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evldte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'e.evldte');
					$lo_evl_rs = $lo_evlmdl->getList($lv_prm, null, null, false);
					
					// Generamos la lista de planificaciones ya evolucionadas
					foreach( $lo_evl_rs as $lv_row ) {
					 $lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['plndteid']; 
					}
					// obtenemos planificaciones del mes anterior que no están evolucionadas 
					$lv_prm = array('vewfldflt' =>'[~fltrow~]pld.plndteid'.chr(9).'NI'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																			'[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]pl.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'pld.plndteid');
					$lo_pln_rs = $lo_plndtemdl2->getList($lv_prm, null, null, false);  
										
					// preparo datos de vista
					$lo_plndtemdl->evlatr = array();
					$lo_plndtemdl->evlspc = array();
					$lo_plndtemdl->evlmat = array();
					$lo_plndtemdl->evldte = $lo_plndtemdl->plndte;
					$lo_plndtemdl->docsts = 'P';
					
					$lv_prm = array('lang'  => $this->co_reg->language,
													'input' => $this->co_reg->input,
													'sec' => $this->co_reg->sec,
													'doc' => $this->co_reg->document,
													'data' =>	$lo_plndtemdl,	// datos de planificación
													'actcod' => $this->data['actcod'],
													'rsplndte'=>$lo_pln_rs	// fechas no evolucionadas de mes anterior
													);
				
				// VER EVOLUCION
				} else {
					
					// cargo datos generales de la evolucion 
					$lo_evlmdl->load( array('evlcod'=>$lv_evlcod),false );	

					// preparo datos de vista
					$lv_prm = array('lang'  => $this->co_reg->language,
													'input' => $this->co_reg->input,
													'sec' => $this->co_reg->sec,
													'doc' => $this->co_reg->document,
													'data' => $lo_evlmdl,
													'actcod' => $this->data['actcod'],
													'rsplndte'=>array()
													);
				}
				
				// regreso la vista
        
        //Buscar motivos de no infucion dependiendo de el financiador de la planificacion
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'EVLCNCMTVLST'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt) );
        }

        $lv_evlcncmtvlst = $this->co_reg->document->gettagvalue($lo_prmmdl->mdlatrval001,'CUS_'.$lo_plndtemdl->cuscod);	// MAILS
        if($lv_evlcncmtvlst==''){
          $lv_evlcncmtvlst = $this->co_reg->document->gettagvalue($lo_prmmdl->mdlatrval001,'ALL');	// MAILS
        }
        $lv_evlcncmtvrows = explode(";", $lv_evlcncmtvlst);
        $lv_mtvarr=array();
        foreach($lv_evlcncmtvrows as $lv_rowmtv){
          $lv_cncmtvrow = explode(",", $lv_rowmtv);
          $lv_mtvarr[$lv_cncmtvrow[0]]=$lv_cncmtvrow[1];
        }
        $lv_prm['data']->evlcncmtvlst = $lv_mtvarr;
        
				$lv_hhcc =(isset($this->co_reg->request->post['hhcc'])?$this->co_reg->request->post['hhcc']:'');
				$lv_prm['data']->hhcc=$lv_hhcc;
				$lv_buffer = 	$this->co_reg->load->view('zcuclh_spcfrm005', $lv_prm);
				return $lv_buffer;
        break;
      }
      case '#zcuclh_frmact05_00':{
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');		
				$lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
				$lo_evlspcmdl = $this->co_reg->load->model('hltpatevlspc');
				$lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte'); 

				$lv_buf_arr = $this->co_reg->request->post;
				$lv_evldte = $this->co_reg->db->sqldate($lv_buf_arr['evldte']); 
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
        $lp_prm['evldte']=$lp_prm['evldte']??$lv_buf_arr['evlgedte'];
				$lv_evldte =$this->co_reg->request->post['evldte']??($lp_prm['evldte']??'');
				
				$datemax = new DateTime("now");
				$datemax= $datemax->add(new DateInterval('P5D'));
				$lv_dte = new DateTime($this->co_reg->db->sqldate($lv_evldte));
				if ($lv_dte > $datemax){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No es posible infundir la fecha seleccionada') );
				}

				$lv_docsts = ( $this->co_reg->request->post['evlgetsmpprc']=='1'?'A':'P' );
				$lv_buf_arr['docsts'] = $lv_docsts;	
				$lv_buf_arr['evlcmt']=$lv_buf_arr['evlcmt'] ;
				$lv_buf_arr['evlevl']= $lv_buf_arr['evlevl'];
				$lv_buf_arr['evlsub']=$lv_buf_arr['evlmtv'];
				$lv_buf_arr['evlatr001'] = '<row>';
				$lv_buf_arr['evlatr001'] .='<dte>'.$lv_evldte.'</dte>';
				$lv_buf_arr['evlatr001'] .='<evlmtv>'.$lv_buf_arr['evlmtv'].'</evlmtv>';
				$lv_buf_arr['evlatr001'] .='<evlgethhs>'.$this->co_reg->db->sqldata($lv_buf_arr['evlgethhs']).'</evlgethhs>';
				$lv_buf_arr['evlatr001'] .='<evlgedte>'.$lv_buf_arr['evlgedte'].'</evlgedte><evlgetsmp>'.$this->co_reg->db->sqldata($lv_buf_arr['evlgetsmp']).'</evlgetsmp>';
				$lv_buf_arr['evlatr001'] .= '</row>';

				$lv_buf_arr['evlobj']=$lv_buf_arr['evlgetsmpprc']=='1'?'REALIZADO '.$lv_evldte:'NO REALIZADO' . chr(13) . $lv_buf_arr['evlmtv'];
        /* ------------------------------------------------ */
        /* obtengo clase de documento 											*/
        /* ------------------------------------------------ */
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        $lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
        if ( $lv_docclscod=='' ) {															// si no se indicó
          $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).'HLT_EVL'.chr(9).chr(9).chr(9).
                                        '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                        );
          $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );													// obtengo las clases de documentos definidas para este objeto
          if ( count($lv_docclsarr)==1 ) {																						// si hay solo una la tomo como default
            $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
            if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
              $lv_buf_arr['sysdocclscod'] = $lo_docclsmdl->sysdocclscod;
            } else {
            	return  'No se pudieron cargar los datos de la clase de documento.';
          	}
          } else {
            return  'No se pudieron cargar los datos de la clase de documento.';
          }
        }
				
        //Obtengo el peso en los atributos
        $lv_patwgt='';
        $lv_buffer =  (isset($this->co_reg->request->post['evlatr'])?$this->co_reg->request->post['evlatr']:(isset($lp_prm['evlatr'])?$lp_prm['evlatr']:''));
        //$this->co_reg->request->post['evlatr'];
        if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_atr_arr = json_decode($lv_buffer,true);
            foreach( $lv_atr_arr as $lv_row ) {
               $lv_patwgt=($lv_patwgt==''?$lv_row['p']:$lv_patwgt);
            }
            $lv_buf_arr['evlatr001'].='<patwgt>'.$lv_patwgt.'</patwgt>';
        }
        
				// EVOLUCION - grabo los datos de cabecera
				if ( $lo_evlmdl->save( $lv_buf_arr, false )==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lv_evlmdl->errtxt) );
				}
        return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
				break;
      }
      case '#zcuclh_frmact05_04':{
        $lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);

				/* determino si se encuentra en alguna liquidación */
				$lo_prslqddocmdl = $this->co_reg->load->model('hltprslqddoc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
																			'[~fltrow~]ld.refobjcod001'.chr(9).'='.chr(9).chr(9).$lv_evlcod.chr(9).chr(9) );
				$lo_rssrv = $lo_prslqddocmdl->getList( $lv_prm );
				if ( count($lo_rssrv)>0 ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-4,'errtxt'=>'No se puede borrar la evolucion. Esta incluida en la liquidacion ['.$lo_rssrv[0]['hltprslqdcod'].']') );
				}
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
        $lo_evlmdl->delete( array('evlcod'=>$lv_evlcod), false );
        return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
				break;
      }
      // ?PRG=ZCUTP1&ACT=evlmth
      case '#zcuclh_frmact06':{
        /*Instanciamos los modelos*/
				$lo_plndtemdl = $this->co_reg->load->model('hltplndte');	
				$lo_plndtemdl2 = $this->co_reg->load->model('hltplndte');	 
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');	
				$lo_vew = $this->co_reg->load->model('grlvew');
				
				/*Obtenemos los parametros post*/
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:'');
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				
				// CREAR EVOLUCION
				if ( $lv_evlcod=='' ) {
					
					// cargo la evolución
					$lo_plndtemdl->load( array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid) );
					$lv_plndte = $lo_plndtemdl->plndte;
					$lv_evlcod = $lo_plndtemdl->evlcod;
					$lv_prscod = $lo_plndtemdl->prscod; 
					$lv_patcod = $lo_plndtemdl->patcod; 
					
					$lv_dteto  = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dtefrm = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
					$lv_dteto->modify('last day of previous month');
					$lv_dtefrm->modify('first day of previous month');
					$lv_patflt= '';
					
					// obtenemos evoluciones realizadas del mes anterior
					$lv_prm = array('vewfldflt' =>'[~fltrow~]e.evldte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'e.evldte');
					$lo_evl_rs = $lo_evlmdl->getList($lv_prm, null, null, false);
					
					// Generamos la lista de planificaciones ya evolucionadas
					foreach( $lo_evl_rs as $lv_row ) {
					 $lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['plndteid']; 
					}
					// obtenemos planificaciones del mes anterior que no están evolucionadas 
					$lv_prm = array('vewfldflt' =>'[~fltrow~]pld.plndteid'.chr(9).'NI'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
																			'[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
																				($lv_prscod!=''?'[~fltrow~]pl.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
																				($lv_patcod!=''?'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
													'vewfldord' => 'pld.plndteid');
					$lo_pln_rs = $lo_plndtemdl2->getList($lv_prm, null, null, false);  
						
          /* ------------------------------------------------ */
          /* obtengo clase de documento 											*/
          /* ------------------------------------------------ */
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
          if ( $lv_docclscod=='' ) {															// si no se indicó
            $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).'HLT_EVL'.chr(9).chr(9).chr(9).
                                          '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                          );
            $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
            if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
              $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
            } else {
              return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
            }
          }
          if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
            $lo_plndtemdl->sysdoccls = $lo_docclsmdl;
          } else {
            echo 'No se pudieron cargar los datos de la clase de documento.';
          }
          /* ------------------------------------------------ */
          
					// preparo datos de vista
					$lo_plndtemdl->evlatr = array();
					$lo_plndtemdl->evlspc = array();
					$lo_plndtemdl->evlmat = array();
					$lo_plndtemdl->evldte = $lo_plndtemdl->plndte;
					$lo_plndtemdl->docsts = 'P';
					
					$lv_prm = array('lang'  => $this->co_reg->language,
													'input' => $this->co_reg->input,
													'sec' => $this->co_reg->sec,
													'doc' => $this->co_reg->document,
													'data' =>	$lo_plndtemdl,	// datos de planificación
													'actcod' => $this->data['actcod'],
													'rsplndte'=>$lo_pln_rs	// fechas no evolucionadas de mes anterior
													);
				
				// VER EVOLUCION
				} else {
					
					// cargo datos generales de la evolucion
					$lo_evlmdl->load( array('evlcod'=>$lv_evlcod),false );
          // obtengo toda la info de la clase de documento
					$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
					if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_evlmdl->sysdocclscod) ) ) {
						$lo_evlmdl->sysdoccls = $lo_docclsmdl;
					}
          
					$lo_evlmdl->evlhhs = $this->co_reg->document->getTagValue($lo_evlmdl->evlobj, 'evlhhs');
					$lo_evlmdl->evltg1 = $this->co_reg->document->getTagValue($lo_evlmdl->evlobj, 'evltg1');
					$lo_evlmdl->evltg2 = $this->co_reg->document->getTagValue($lo_evlmdl->evlobj, 'evltg2');
					$lo_evlmdl->evltg3 = $this->co_reg->document->getTagValue($lo_evlmdl->evlobj, 'evltg3');
					$lo_evlmdl->evltg4 = $this->co_reg->document->getTagValue($lo_evlmdl->evlobj, 'evltg4');
					$lo_evlmdl->evltg5 = $this->co_reg->document->getTagValue($lo_evlmdl->evlobj, 'evltg5');
					$lo_evlmdl->evltg6 = $this->co_reg->document->getTagValue($lo_evlmdl->evlobj, 'evltg6');
					$lo_evlmdl->evltg7 = $this->co_reg->document->getTagValue($lo_evlmdl->evlobj, 'evltg7');
					$lo_evlmdl->evltg8 = $this->co_reg->document->getTagValue($lo_evlmdl->evlobj, 'evltg8');
					$lo_evlmdl->evltg9 = $this->co_reg->document->getTagValue($lo_evlmdl->evlobj, 'evltg9');
				

					// preparo datos de vista
					$lv_prm = array('lang'  => $this->co_reg->language,
													'input' => $this->co_reg->input,
													'sec' => $this->co_reg->sec,
													'doc' => $this->co_reg->document,
													'data' => $lo_evlmdl,
													'actcod' => $this->data['actcod'],
													'rsplndte'=>array()
													);
				}
				
				// regreso la vista
				$lv_hhcc =(isset($this->co_reg->request->post['hhcc'])?$this->co_reg->request->post['hhcc']:'');
				$lv_prm['data']->hhcc=$lv_hhcc;
				$lv_buffer = 	$this->co_reg->load->view('zcuclh_spcfrm006', $lv_prm);
				return $lv_buffer;
        break;
      }
      case '#zcuclh_frmact06_00':{
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');		
				$lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
				$lo_evlspcmdl = $this->co_reg->load->model('hltpatevlspc');
				$lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
				$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte'); 

				$lv_buf_arr = $this->co_reg->request->post;
				$lv_evldte = $this->co_reg->db->sqldate($lv_buf_arr['evldte']); 
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_evldte =(isset($this->co_reg->request->post['evldte'])?$this->co_reg->request->post['evldte']:$lp_prm['evldte']);
				
				$datemax = new DateTime("now");
				$datemax= $datemax->add(new DateInterval('P5D'));
				$lv_dte = new DateTime($this->co_reg->db->sqldate($lv_evldte));
				if ($lv_dte > $datemax){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No es posible infundir la fecha seleccionada') );
				}
				
				$lv_docsts = ( $this->co_reg->request->post['evlmthprc']=='1'?'A':'P' );
				$lv_buf_arr['docsts'] = $lv_docsts;				
				$lv_buf_arr['evltg1'] = isset($lv_buf_arr['evltg1'])?$lv_buf_arr['evltg1']:'OFF';
				$lv_buf_arr['evltg2'] = isset($lv_buf_arr['evltg2'])?$lv_buf_arr['evltg2']:'OFF';
				$lv_buf_arr['evltg3'] = isset($lv_buf_arr['evltg3'])?$lv_buf_arr['evltg3']:'OFF';
        $lv_buf_arr['evltg4'] = isset($lv_buf_arr['evltg4'])?$lv_buf_arr['evltg4']:'OFF';
				$lv_buf_arr['evltg5'] = isset($lv_buf_arr['evltg5'])?$lv_buf_arr['evltg5']:'OFF';
				$lv_buf_arr['evltg6'] = isset($lv_buf_arr['evltg6'])?$lv_buf_arr['evltg6']:'OFF';
				$lv_buf_arr['evltg7'] = isset($lv_buf_arr['evltg7'])?$lv_buf_arr['evltg7']:'OFF';
				$lv_buf_arr['evltg8'] = isset($lv_buf_arr['evltg8'])?$lv_buf_arr['evltg8']:'OFF';
				$lv_buf_arr['evltg9'] = isset($lv_buf_arr['evltg9'])?$lv_buf_arr['evltg9']:'OFF';
				$lv_buf_arr['evlcmt']=$lv_buf_arr['evlcmt'] ;
				$lv_buf_arr['evlevl']= $lv_buf_arr['evlevl'];
				$lv_buf_arr['evlsub']=$lv_buf_arr['evlmtv'];
				$lv_buf_arr['evlatr001'] = '<row>';
				$lv_buf_arr['evlatr001'] .='<dte>'.$lv_evldte.'</dte>';
				$lv_buf_arr['evlatr001'] .='<evlmtv>'.$lv_buf_arr['evlmtv'].'</evlmtv><evlcmt>'.$this->co_reg->db->sqldata($lv_buf_arr['evlcmt']).'</evlcmt>';
				$lv_buf_arr['evlatr001'] .='<evlhhs>'.$lv_buf_arr['evlhhs'].'</evlhhs><evltg1>'.$lv_buf_arr['evltg1'].'</evltg1><evltg2>'.$lv_buf_arr['evltg2'].'</evltg2><evltg3>'.$lv_buf_arr['evltg3'].'</evltg3><evltg4>'.$lv_buf_arr['evltg4'].'</evltg4><evltg5>'.$lv_buf_arr['evltg5'].'</evltg5><evltg6>'.$lv_buf_arr['evltg6'].'</evltg6><evltg7>'.$lv_buf_arr['evltg7'].'</evltg7><evltg8>'.$lv_buf_arr['evltg8'].'</evltg8><evltg9>'.$lv_buf_arr['evltg9'].'</evltg9><evlmthprc>'.$lv_buf_arr['evlmthprc'].'</evlmthprc>';
				$lv_buf_arr['evlatr001'] .= '</row>';
				$lv_buf_arr['evlobj']=$lv_buf_arr['evlmthprc']=='1'?'REALIZADO '.$lv_evldte:'NO REALIZADO' . chr(13) . $lv_buf_arr['evlmtv'];
        
        //Obtengo el peso en los atributos
        $lv_patwgt='';
        $lv_buffer = $this->co_reg->request->post['evlatr'];
        if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_atr_arr = json_decode($lv_buffer,true);
            foreach( $lv_atr_arr as $lv_row ) {
               $lv_patwgt=($lv_patwgt==''?$lv_row['p']:$lv_patwgt);
            }
            $lv_buf_arr['evlatr001'].='<patwgt>'.$lv_patwgt.'</patwgt>';
        }
				
				// EVOLUCION - grabo los datos de cabecera
				if ( $lo_evlmdl->save( $lv_buf_arr, false )==false ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
				}
				
				// EVOLUCION - MONITOREO TELEFONICO
				if ( $lv_docsts=='A' ) {
					// CONTROL DE PRESTACION

				}
        return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
				break;
      }
      case '#zcuclh_frmact06_04':{
        $lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);

				/* determino si se encuentra en alguna liquidación */
				$lo_prslqddocmdl = $this->co_reg->load->model('hltprslqddoc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
																			'[~fltrow~]ld.refobjcod001'.chr(9).'='.chr(9).chr(9).$lv_evlcod.chr(9).chr(9) );
				$lo_rssrv = $lo_prslqddocmdl->getList( $lv_prm );
				if ( count($lo_rssrv)>0 ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-4,'errtxt'=>'No se puede borrar la evolucion. Esta incluida en la liquidacion ['.$lo_rssrv[0]['hltprslqdcod'].']') );
				} else {
			
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
					if ( $lo_evlmdl->delete( array('evlcod'=>$lv_evlcod), false ) ) {
 	        	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
					}
					
				}
        return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
				break;
      }
      case '#grlrpt':{
        $mdl = $this->co_reg->load->model($lp_prm['model']);
				$lv_prm=array();

				$lv_vewfldflt = (isset($this->co_reg->request->post['vewfldflt'])?$this->co_reg->request->post['vewfldflt']:'');
				$lv_vewmaxrec = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewmaxrec']:'');
        $lv_vewfldord = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewfldord']:'');

				$lv_prm = array('vewfldflt' => $lv_vewfldflt,
                        'vewfldord' => $lv_vewfldord,
												'vewmaxrec' => $lv_vewmaxrec);
				$v_memlmt=isset($lp_prm['memlmt'])?$lp_prm['memlmt']:'2048';
        $lv_lmtmem= ini_get('memory_limit');
				ini_set('memory_limit', $v_memlmt.'M');
				$lo_rsprscat = $mdl->getList($lv_prm);
        ini_set('memory_limit', $lv_lmtmem);
				return $lo_rsprscat ;
        
      }
      case '#evlrpt':{
        $lo_mdlusrprm = $this->co_reg->load->model('syssecusrprm');
				$lo_post = $this->co_reg->request->post;
				$lv_patflt= '';
				$lv_usrprmflt= '';
        $lv_sqlstm = array();
        $v_memlmt=isset($lp_prm['memlmt'])?$lp_prm['memlmt']:'2048';
        $lv_lmtmem= ini_get('memory_limit');
				ini_set('memory_limit', $v_memlmt.'M');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9).
																			'[~fltrow~]p.PrmCod'.chr(9).'='.chr(9).chr(9).'4'.chr(9).chr(9) );
				$lo_rsprm = $lo_mdlusrprm->getList($lv_prm);
        $lv_sqlstm[]= $lo_mdlusrprm->getsysdata('sqlstm');
				foreach( $lo_rsprm as $lv_row ) {
          $lv_usrprmflt .= ($lv_usrprmflt==''?'':chr(10)).$lv_row['prmval']; 
        }

				/* EVOLUCIONES */
				$lo_mdlevl = $this->co_reg->load->model('hltpatevl');
				
        /* Filtros */					
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'EVLCNCMTVLST'))){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt) );
        }
        $lo_prmmdl->mdlatrval001=str_replace("*", "all", $lo_prmmdl->mdlatrval001);
        $lv_atrusr = <<<XML
<?xml version='1.0'?> 
<document>
.htmlentities($lo_prmmdl->mdlatrval001).
</document>
XML;
        $lv_dat = simplexml_load_string($lv_atrusr);
        $lv_evlcncmtv = [];
				foreach($lv_dat as $lv_key=>$lv_val){
          $lv_key= str_replace("CUS_", "", $lv_key);
         	$lv_cncmtvrow = explode(";", $lv_val);
          $lv_evlcncmtv[$lv_key]=[];
          foreach($lv_cncmtvrow as $lv_rowmtv){
            $lv_a = explode(",", $lv_rowmtv);
            $lv_evlcncmtv[$lv_key][$lv_a[0]]=$lv_a[1];
          }
				}
				$lv_maxrec = false;
				$lv_fltevlne=false;
				$lv_fltevlee=false;
	    	
	    	$lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );			
				for($i=count($lv_fltarrevl)-1; $i>0; $i--){
					if(stripos(';evlcod;evldtecnv;evldte;patcod;pattxt;prscod;prstxt;spctxt;docsts;evlcncmtv;cteusr;custxt;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
						$lv_maxrec = true;
						unset($lv_fltarrevl[$i]);
					}else{
            $lv_fltarrevl[$i] = str_replace('evlcod','e.evlcod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('patcod','e.patcod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('evldte','e.evldte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('pattxt','e.pattxt',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('prscod','e.prscod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('prstxt','e.prstxt',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('spctxt','e.spctxt',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('docsts','e.docsts',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('cteusr','e.cteusr',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('custxt','c.custxt',$lv_fltarrevl[$i]);
						$lv_flt=explode(chr(9),$lv_fltarrevl[$i]);
						if ($lv_flt[1]=='EE'){
							unset($lv_fltarrevl[$i]);
							$lv_fltevlee=true;
						}elseif ($lv_flt[1]=='NE') {
							$lv_fltevlne=true;
							unset($lv_fltarrevl[$i]);
						}else{
							if ($lv_flt[0]=='evlcncmtv') {
								$lv_flt[0]= 'dbo.GetTagValue(^evlcncmtv^,EVLATR001)';
								$lv_fltin=array();
                foreach ($lv_evlcncmtv as $rowMtvCus) {
                  foreach ($rowMtvCus as $key => $value) {
                    if(strpos(strtoupper($value), strtoupper($lv_flt[2]))!==false){
                      $lv_fltin[]=$key;
                    }
                  }
                }
								$lv_flt[1]='IN';
								$lv_flt[2]='';
								$lv_flt[3]=implode(chr(10),$lv_fltin);
								$lv_fltarrevl[$i]=implode(chr(9),$lv_flt);
							}
						}
					}
				}
				$lv_prmflt = array('vewfldflt' =>(count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):'').
																				 (count($lo_rsprm)>0?('[~fltrow~]c.cuscod'.chr(9).'IN'.chr(9).chr(9).$lv_usrprmflt.chr(9).chr(9)):''),
													'vewfldord' => 'e.evldte desc'
												);
				if($lv_maxrec==false){
					$lv_prmflt['vewmaxrec']=$lo_post['vewmaxrec'];
				}
				if(isset($lp_prm['evlnotpln'])){ 
        	$lv_prmflt['vewfldflt'].='[~fltrow~]isnull(e.plnid,0)'.chr(9).'<>'.chr(9).chr(9).'0'.chr(9).chr(9); 
        }
        
				$lo_rsevl = $lo_mdlevl->getList( $lv_prmflt, null, null, false); 
        $lv_sqlstm[]= $lo_mdlevl->getsysdata('sqlstm');
				$lv_patcodlst=array();
        $lv_evllst=array();
				foreach($lo_rsevl as $lv_row) {
          if(!in_array($lv_row['evlcod'],$lv_evllst)){
						array_push($lv_evllst,$lv_row['evlcod']) ;
					}
					if(!in_array($lv_row['patcod'],$lv_patcodlst)){
						array_push($lv_patcodlst,$lv_row['patcod']) ;
						$lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['patcod'];
					}
				}
        
        /* MATERIALES */
        $lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
        $lv_evlflt= implode(chr(10),$lv_evllst);
        $lv_prm = array('vewfldflt' =>'[~fltrow~]e.evlcod'.chr(9).'IN'.chr(9).chr(9).$lv_evlflt.chr(9).chr(9),
													'vewfldord' => 'e.evlcod');
        
				$lo_rsevlmat = $lo_evlmatmdl->getList($lv_prm);
        $lv_sqlstm[]= $lo_evlmatmdl->getsysdata('sqlstm');    

        $lo_evlmatlst=array();
        foreach($lo_rsevlmat as $lv_rowmat){
          $lv_keymat=$lv_rowmat['evlcod'];
          if (!array_key_exists($lv_keymat, $lo_evlmatlst)) {
						$lo_evlmatlst[$lv_keymat]=array('matbchcodext'=>'','matbchduedte'=>'','mattxt'=>'','matqty'=>'');
					}
          $lo_evlmatlst[$lv_keymat]['mattxt'] .= ($lo_evlmatlst[$lv_keymat]['mattxt']==''?'':' | ').$lv_rowmat['mattxt']; 
          $lo_evlmatlst[$lv_keymat]['matbchcodext'] .= ($lo_evlmatlst[$lv_keymat]['matbchcodext']==''?'':' | ').$lv_rowmat['matbchcodext']; 
          if ($lv_rowmat['matbchduedte'] instanceof DateTime) {
            $lv_rowmat['matbchduedte'] = $lv_rowmat['matbchduedte']->format('d-m-Y');
          }
          $lo_evlmatlst[$lv_keymat]['matbchduedte'] .= ($lo_evlmatlst[$lv_keymat]['matbchduedte']==''?'':' | ').$lv_rowmat['matbchduedte']; 
          $lv_rowmat['matqty']=number_format($lv_rowmat['matqty'], 2, '.', '');
          $lv_rowmat['matqty'] = (isset(explode(".",$lv_rowmat['matqty'])[1]) && str_replace('0','',explode(".",$lv_rowmat['matqty'])[1])!='')?$lv_rowmat['matqty']:explode(".",$lv_rowmat['matqty'])[0];
          $lo_evlmatlst[$lv_keymat]['matqty'] .=  ($lo_evlmatlst[$lv_keymat]['matqty']==''?'':' | ').$lv_rowmat['matqty'];
        }
				/* PACIENTES */
        $lo_mdlpat = $this->co_reg->load->model('hltpat');
				/* Filtros*/
				$lv_fltarrpat = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
        $lv_fltpat=false;
				for($i=count($lv_fltarrpat)-1; $i>0; $i--){
					if(stripos(';lndregtxt;hltdisclstxt;adrtwntxt;custxt;',';'.explode(chr(9),$lv_fltarrpat[$i])[0].';')===false){
						unset($lv_fltarrpat[$i]);
					}else{
						$lv_fltpat=true;
            $lv_fltarrpat[$i] = str_replace('lndregtxt','lr.lndregtxt',$lv_fltarrpat[$i]);
            //$lv_fltarrpat[$i] = str_replace('hltdisclstxt','pdc.hltdisclstxt',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('hltdisclstxt','pdc.hltdisclstxt',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('adrtwntxt','a.adrtwn',$lv_fltarrpat[$i]);
            
            $lv_fltarrpat[$i] = str_replace('custxt','c.custxt',$lv_fltarrpat[$i]);
          }
				}
        $lv_prm = array('vewfldflt' =>(count($lv_fltarrpat)>0?implode('[~fltrow~]',$lv_fltarrpat):''),
												'vewfldord' => 'p.PatCod');
				$lo_rspat = $lo_mdlpat->getList($lv_prm, null, null, false);
        $lv_sqlstm[]= $lo_mdlpat->getsysdata('sqlstm');
        
        //DATOS PERSONALES
        
        $lo_permdl = $this->co_reg->load->model('grldatper');
				//Filtro
				$lv_fltarrdatper = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        $lv_fltnedder=false;
				for($i=count($lv_fltarrdatper)-1; $i>0; $i--){
					if(stripos(';persex;',';'.explode(chr(9),$lv_fltarrdatper[$i])[0].';')===false){
						unset($lv_fltarrdatper[$i]);
					}else{
            $lv_fltnedder=true;
						$lv_flt=explode(chr(9),$lv_fltarrdatper[$i]);
						if($lv_flt[0]=='rlstxt'){
							$lv_flt[0]= 'dbo.GetTagValue(^patprsrlstxt^,patprsrlsatr001)';
							$lv_fltarrdatper[$i]=implode(chr(9),$lv_flt);
						}
					}
				}

				$lv_prm = array('vewfldflt' =>'[~fltrow~]persrctyp'.chr(9).'='.chr(9).chr(9).'HLT_PAT'.chr(9).chr(9).
																			(count($lv_fltarrdatper)>0?implode('[~fltrow~]',$lv_fltarrdatper):''),
													'vewfldord' => 'p.PatCod,PatPrsRlsCod');
        
				//RELACION MED. DERIVADOR 
        $lo_mdlrls = $this->co_reg->load->model('hltpatprsrls');
				//Filtro 
				$lv_fltarrmedder = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        $lv_fltnedder=false;
				for($i=count($lv_fltarrmedder)-1; $i>0; $i--){
					if(stripos(';rlstxt;',';'.explode(chr(9),$lv_fltarrmedder[$i])[0].';')===false){
						unset($lv_fltarrmedder[$i]);
					}else{
            $lv_fltnedder=true;
						$lv_flt=explode(chr(9),$lv_fltarrmedder[$i]);
						if($lv_flt[0]=='rlstxt'){
							$lv_flt[0]= 'dbo.GetTagValue(^patprsrlstxt^,patprsrlsatr001)';
							$lv_fltarrmedder[$i]=implode(chr(9),$lv_flt);
						}
					}
				}

				$lv_prm = array('vewfldflt' =>'[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).'MEC'.chr(9).chr(9).
																			(count($lv_fltarrmedder)>0?implode('[~fltrow~]',$lv_fltarrmedder):''),
													'vewfldord' => 'p.PatCod,PatPrsRlsCod');
				$lo_rls_rs = $lo_mdlrls->getList($lv_prm);
        $lv_sqlstm[]= $lo_mdlrls->getsysdata('sqlstm');

				//RELACION COORDINADOR
				//Filtro
				$lv_fltarrcoo = explode('[~fltrow~]',$lo_post['vewfldflt'] );		
        $lv_fltcoo=false;
				for($i=count($lv_fltarrcoo)-1; $i>0; $i--){
					if(stripos(';rlstxtcoo;',';'.explode(chr(9),$lv_fltarrcoo[$i])[0].';')===false){
						unset($lv_fltarrcoo[$i]);
					}else{
            $lv_fltcoo=true;
						$lv_flt=explode(chr(9),$lv_fltarrcoo[$i]);
						if($lv_flt[0]=='rlstxtcoo'){
							$lv_flt[0]= 'dbo.GetTagValue(^patprsrlstxt^,patprsrlsatr001)';
							$lv_fltarrcoo[$i]=implode(chr(9),$lv_flt);
						}
					}
				}
				$lv_prm = array('vewfldflt' =>'[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).'COORD'.chr(9).chr(9).
																			(count($lv_fltarrcoo)>0?implode('[~fltrow~]',$lv_fltarrcoo):''),
													'vewfldord' => 'p.PatCod,PatPrsRlsCod');
				$lo_rlscoo_rs = $lo_mdlrls->getList($lv_prm);
        $lv_sqlstm[]= $lo_mdlrls->getsysdata('sqlstm');
				$lo_ret= array();
				/*Evoluciones*/
				for ($i = 0; $i < count($lo_rsevl); $i++) {
          $lv_evlcod=$lo_rsevl[$i]['evlcod'];
					$lv_rtn=array('evlcod'=>$lo_rsevl[$i]['evlcod'],
												'evldte'=>new DateTime($lo_rsevl[$i]['evldte']->format('Y-m-d')) ,
												'patcod'=>'',
                        'patcodext'=>'',
												'pattxt'=>$lo_rsevl[$i]['pattxt'],
												'lndregtxt'=>'',
												'hltdisclstxt'=>'',
												'prscod'=>$lo_rsevl[$i]['prscod'],
                        'prscodext'=>'',
												'prstxt'=>$lo_rsevl[$i]['prstxt'],
												'spctxt'=>$lo_rsevl[$i]['spctxt'],
												'rlstxt'=>'',
												'rlstxtcoo'=>'',
												'docsts'=>$lo_rsevl[$i]['docsts']=='A'?'SI':'NO',
												'evlcncmtvtxt'=>'',
                        'evlcncmtv'=>'',
                        'custxt'=>'',
												'mattxt'=>isset($lo_evlmatlst[$lv_evlcod]['mattxt'])?$lo_evlmatlst[$lv_evlcod]['mattxt']:'',
                        'matbchcodext'=>isset($lo_evlmatlst[$lv_evlcod]['matbchcodext'])?$lo_evlmatlst[$lv_evlcod]['matbchcodext']:'',
                        'matbchduedte'=>isset($lo_evlmatlst[$lv_evlcod]['matbchduedte'])?$lo_evlmatlst[$lv_evlcod]['matbchduedte']:'',
                        'matqty'=>isset($lo_evlmatlst[$lv_evlcod]['matqty'])?$lo_evlmatlst[$lv_evlcod]['matqty']:'',
                        'adrtwntxt'=>'',
                        'adrctytxt'=>'',
                        'matdos'=>'',
                        'patsex'=>'',
                        'patwgt'=>'', 
                        'patage'=>'',
                        'evlctedte'=>$lo_rsevl[$i]['ctedte'],
                        'evlcteusr'=>$lo_rsevl[$i]['cteusr'],
                        'hhrmedcovtxt'=>'',
                        'apinroref'=>$this->co_reg->document->gettagvalue($lo_rsevl[$i]['evlatr001'],'apinroref'),
												'cteusr'=>$lo_rsevl[$i]['cteusr'],
												'evlevl'=>$lo_rsevl[$i]['evlevl']
											);
					$lv_fndpat = false;
					$lv_fndrelcoo = false;
					$lv_fndrlsder = false;
          $lv_cuscod = $lo_rsevl[$i]['cuscod'];
          if($lv_rtn['docsts']=='NO'){
            $lv_evlcncmtvcod = $this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lo_rsevl[$i]['evlatr001'], 'row'),'evlcncmtv');
            if($lv_evlcncmtvcod!=''){
              $lv_rtn['evlcncmtv']=isset($lv_evlcncmtv[$lv_cuscod][$lv_evlcncmtvcod])?$lv_evlcncmtv[$lv_cuscod][$lv_evlcncmtvcod]:(isset($lv_evlcncmtv['ALL'][$lv_evlcncmtvcod])?$lv_evlcncmtv['ALL'][$lv_evlcncmtvcod]:'ERROR: CODIGO '.$lv_evlcncmtvcod);
            }
          }
					$lv_rtn['patwgt']=$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lo_rsevl[$i]['evlatr001'], 'row'),'patwgt');
          $lv_rtn['matdos']=$this->co_reg->document->getTagValue($this->co_reg->document->getTagValue($lo_rsevl[$i]['evlatr001'], 'row'),'matdos');
          
					// Paciente
					foreach($lo_rspat as $lv_rowpat) {
						if($lo_rsevl[$i]['patcod']==$lv_rowpat['patcod']){
							$lv_rtn['hltdisclstxt']=$lv_rowpat['hltdisclstxt'];
							$lv_rtn['lndregtxt']=$lv_rowpat['lndregtxt'];
              $lv_rtn['patcod']=$lv_rowpat['patcod'];
              $lv_rtn['patcodext']=$lv_rowpat['patcodext'];
              $lv_rtn['custxt']=$lv_rowpat['custxt'];
							$lv_rtn['patpro']=$lv_rowpat['patpro'];//PatBrnDte							
              $lv_rtn['patsex']=$lv_rowpat['persex'];
              $lv_rtn['adrtwntxt']=$lv_rowpat['adrtwn'];
              $lv_rtn['adrctytxt']=$lv_rowpat['adrcty'];
              $lv_rtn['hhrmedcovtxt']=$lv_rowpat['hhrmedcovtxt'];
              
              if(!isset($lv_rowpat['perbrndte'])){
              	$lv_rtn['patage']='';
              }else{
                $fecha_nacimiento = $lv_rowpat['perbrndte']->format('d-m-Y');
                $dia_actual = date('Y-m-d');
                $lv_age = date_diff(date_create($fecha_nacimiento), date_create($dia_actual));
                $lv_agestr = ($lv_age->y>0?$lv_age->y.' '.$this->co_reg->language->years:'').($lv_age->y<5 && $lv_age->m>0?' '.$lv_age->m.' '.$this->co_reg->language->months:'').($lv_age->y<1?' '.$lv_age->d.' '.$this->co_reg->language->days:'');
                $lv_rtn['patage']=$lv_agestr;
              }
							$lv_fndpat = true;
							break;
						}
					}
          /* Med. Cabecera */
					foreach($lo_rls_rs as $lv_rowmed) {
						if($lo_rsevl[$i]['patcod']==$lv_rowmed['patcod']){
              $lv_cabprs=$lv_rowmed['prstxt'];
							$lv_cabtxt=$this->co_reg->document->getTagValue($lv_rowmed['patprsrlsatr001'] , 'patprsrlstxt');
							$lv_rtn['rlstxt']=$lv_cabprs==''?$lv_cabtxt:$lv_cabprs;
							$lv_fndrlsder = true;
							break;
						}
					}
					// Coordinador 
					foreach($lo_rlscoo_rs as $lv_rowcoo) {
						if($lo_rsevl[$i]['patcod']==$lv_rowcoo['patcod']){
              $lv_cooprs=$lv_rowcoo['prstxt'];
							$lv_cootxt=$this->co_reg->document->getTagValue($lv_rowcoo['patprsrlsatr001'] , 'patprsrlstxt');
              $lv_rtn['rlstxtcoo']=$lv_cooprs==''?$lv_cootxt:$lv_cooprs;
							$lv_fndrelcoo = true;
							break;
						}
					}
          if($lv_rtn['rlstxt']=='' && $lv_fltnedder==true ) { continue;}
          if($lv_rtn['rlstxtcoo']=='' && $lv_fltcoo==true ) { continue;}
          
          // FILTRO EVOLUCIONES SIN PACIENTES
          if($lv_rtn['patcod'] =='' && $lv_fltpat == true){continue;}

					// Filtro motivo no infusion vacio
					if($lv_rtn['evlcncmtv']!='' && $lv_fltevlee==true ) { continue;}

					// Filtro motivo no infusion no vacio
					if($lv_rtn['evlcncmtv']=='' && $lv_fltevlne==true) { continue;}
					$lo_ret[]=$lv_rtn;
				}
        $lo_ret[0]['sqlstm']=$lv_sqlstm;
        
        //var_dump($lv_sqlstm);
        ini_set('memory_limit', $lv_lmtmem);
        $lo_ret[0]['sqlstm']=$lv_sqlstm;
				return $lo_ret;
				break;
        
      }
    }// fin case
  } // fin index
  private function evlvew($lp_prm=array()){
  	/*Instanciamos los modelos*/
    $lo_plndtemdl = $this->co_reg->load->model('hltplndte');	
    $lo_plndtemdl2 = $this->co_reg->load->model('hltplndte');	 
    $lo_evlmdl = $this->co_reg->load->model('hltpatevl');	
    $lo_vew = $this->co_reg->load->model('grlvew');

    $lv_evlcod = $lp_prm['evlcod'];
    $lv_plnid = $lp_prm['plnid'];
    $lv_plndteid = $lp_prm['plndteid'];
				
    // CREAR EVOLUCION
    if ( $lv_evlcod=='' ) {

      // cargo la evolución
      $lo_plndtemdl->load( array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid) );
      $lv_plndte = $lo_plndtemdl->plndte;
      $lv_evlcod = $lo_plndtemdl->evlcod;
      $lv_prscod = $lo_plndtemdl->prscod; 
      $lv_patcod = $lo_plndtemdl->patcod; 


      $lv_dteto  = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
      $lv_dtefrm = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
      $lv_dteto->modify('last day of previous month');
      $lv_dtefrm->modify('first day of previous month');
      $lv_patflt= '';

      // obtenemos evoluciones realizadas del mes anterior
      $lv_prm = array('vewfldflt' =>'[~fltrow~]e.evldte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
                                    ($lv_prscod!=''?'[~fltrow~]e.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
                                    ($lv_patcod!=''?'[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
                      'vewfldord' => 'e.evldte');
      $lo_evl_rs = $lo_evlmdl->getList($lv_prm, null, null, false);

      // Generamos la lista de planificaciones ya evolucionadas
      foreach( $lo_evl_rs as $lv_row ) {
       $lv_patflt .= ($lv_patflt==''?'':chr(10)).$lv_row['plndteid']; 
      }
      // obtenemos planificaciones del mes anterior que no están evolucionadas 
      $lv_prm = array('vewfldflt' =>'[~fltrow~]pld.plndteid'.chr(9).'NI'.chr(9).chr(9).$lv_patflt.chr(9).chr(9).
                                  '[~fltrow~]pld.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9).
                                    ($lv_prscod!=''?'[~fltrow~]pl.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9):'').
                                    ($lv_patcod!=''?'[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9):''),
                      'vewfldord' => 'pld.plndteid');
      $lo_pln_rs = $lo_plndtemdl2->getList($lv_prm, null, null, false);  

      /* ------------------------------------------------ */
      /* obtengo clase de documento 											*/
      /* ------------------------------------------------ */
      $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
      $lv_docclscod = (isset($this->co_reg->request->post['sysdocclscod'])?$this->co_reg->request->post['sysdocclscod']:'');
      if ( $lv_docclscod=='' ) {															// si no se indicó
        $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).''.chr(9).'HLT_EVL'.chr(9).chr(9).chr(9).
                                      '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                      );
        $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
        if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
          $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
        } else {
          return $this->co_reg->document->getView( 'sysdocclslst', array('url'=>'index.php?prg='.self::CONTROLLER.'&act=01','doccls'=>$lv_docclsarr) );
        }
      }
      if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) ) ) {			// obtengo toda la info de la clase de documento
        $lo_plndtemdl->sysdoccls = $lo_docclsmdl;
      } else {
        echo 'No se pudieron cargar los datos de la clase de documento.';
      }
      /* ------------------------------------------------ */          

      // preparo datos de vista
      $lo_plndtemdl->evlatr = array();
      $lo_plndtemdl->evlspc = array();
      $lo_plndtemdl->evlmat = array();
      $lo_plndtemdl->evldte = $lo_plndtemdl->plndte;
      $lo_plndtemdl->docsts = 'P';

      $lv_prm = array('lang'  => $this->co_reg->language,
                      'input' => $this->co_reg->input,
                      'sec' => $this->co_reg->sec,
                      'doc' => $this->co_reg->document,
                      'data' =>	$lo_plndtemdl,	// datos de planificación
                      'actcod' => $this->data['actcod'],
                      'rsplndte'=>$lo_pln_rs	// fechas no evolucionadas de mes anterior
                      );

    // VER EVOLUCION
    } else {

      // cargo datos generales de la evolucion
      $lo_evlmdl->load( array('evlcod'=>$lv_evlcod),false );
      // obtengo toda la info de la clase de documento
      $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
      if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_evlmdl->sysdocclscod) ) ) {
        $lo_evlmdl->sysdoccls = $lo_docclsmdl;
      }

      // preparo datos de vista
      $lv_prm = array('lang'  => $this->co_reg->language,
                      'input' => $this->co_reg->input,
                      'sec' => $this->co_reg->sec,
                      'doc' => $this->co_reg->document,
                      'data' => $lo_evlmdl,
                      'actcod' => $this->data['actcod'],
                      'rsplndte'=>array()
                      );
    }

    // regreso la vista
    $lv_hhcc =(isset($lp_prm['hhcc'])?$lp_prm['hhcc']:'');
    $lv_prm['data']->hhcc=$lv_hhcc;
    $lv_buffer = 	$this->co_reg->load->view($lp_prm['vewcod'], $lv_prm);
    return $lv_buffer;
  }
  private function evlsve($lp_prm,$lp_post){
  	$lo_evlmdl = $this->co_reg->load->model('hltpatevl');		
		$lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
		$lo_evlspcmdl = $this->co_reg->load->model('hltpatevlspc');
		$lv_ctrmdl = $this->co_reg->load->model('hltplnctr');
		$lv_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte'); 

		$lv_plnid = $lp_prm['plnid'];
		$lv_plndteid = $lp_prm['plndteid'];

		$lv_buf_arr = $lp_post;
    $lv_buf_arr['evlcncmtv']=$lv_buf_arr['evlcncmtv']??'';
		$lv_evldte = $lp_prm['evldte']; 
		
		$datemax = new DateTime("now");
		$datemax= $datemax->add(new DateInterval('P5D'));
		$lv_dte = new DateTime($this->co_reg->db->sqldate($lv_evldte));
		if ($lv_dte > $datemax){
      return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'No es posible infundir la fecha seleccionada') );
		}
		
		$lv_docsts = ( $this->co_reg->request->post['evlinfprc']=='1'?'A':'P' );
		$lv_buf_arr['docsts'] = $lv_docsts;
		$lv_buf_arr['evlcmt']=$lv_buf_arr['evlcmt'] ;
		$lv_buf_arr['evlsub']=$lv_buf_arr['evlcnccmt'];
		$lv_buf_arr['evlevl']= $lv_buf_arr['evlevl'];
    $lv_buf_arr['fvrpt']=isset($lv_buf_arr['fvrpt'])?$lv_buf_arr['fvrpt']:'off';
		$lv_buf_arr['evlatr001'] = '<row>';
		$lv_buf_arr['evlatr001'].= '<dte>'.$lv_evldte.'</dte><evlcncmtv>'.$lv_buf_arr['evlcncmtv'].'</evlcncmtv><evlcnccmt>'.$this->co_reg->db->sqldata($lv_buf_arr['evlcnccmt']).'</evlcnccmt><evlinfprc>'.$this->co_reg->db->sqldata($lv_buf_arr['evlinfprc']).'</evlinfprc>';
    $lv_buf_arr['evlatr001'].= '<fvrpt>'.$lv_buf_arr['fvrpt'].'</fvrpt>';
    $lv_fvrpttxt = ( $lv_buf_arr['fvrpt']=='no'?'SI':'NO' );
    $lv_buf_arr['evlatr001'].= '<fvrpttxt>'.$lv_fvrpttxt.'</fvrpttxt>';
    $lv_buf_arr['evlatr001'].= '</row>';    
		$lv_buf_arr['evlobj']=$lv_buf_arr['evlinfprc']=='1'?'REALIZADO '.$lv_evldte:'NO REALIZADO' . chr(13) . $lv_buf_arr['evlcnccmt'];
    
    //Obtengo el peso en los atributos
    $lv_patwgt='';
    $lv_buffer = $this->co_reg->request->post['evlatr'];
    if ($lv_buffer!='') {
        $lv_buffer = html_entity_decode($lv_buffer);
        $lv_atr_arr = json_decode($lv_buffer,true);
        foreach( $lv_atr_arr as $lv_row ) {
           $lv_patwgt=($lv_patwgt==''?$lv_row['p']:$lv_patwgt);
        }
        $lv_buf_arr['evlatr001'].='<patwgt>'.$lv_patwgt.'</patwgt>';
      // EVOLUCION - grabo los datos de cabecera
      if ( $lo_evlmdl->save( $lv_buf_arr, false )==false ) {
 	     	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
      }
      // EVOLUCION - INFUSION
      if ( $lv_docsts=='A' ) {
        // EVOLUCION ATRIBUTOS - grabo datos de atributos
        $lv_buffer = 	$lv_buf_arr['evlatr'];
        if ($lv_buffer!='') {
          $lv_buffer = html_entity_decode($lv_buffer);
          $lv_atr_arr = json_decode($lv_buffer,true);
          foreach( $lv_atr_arr as $lv_row ) {
            $lv_arr = $lv_row;
            $lv_arr['evlcod'] = $lo_evlmdl->evlcod;
            $lv_arr['spccod'] = $lo_evlmdl->spccod;
            $lv_arr['evlatrval001']= isset($lv_row['ml'])? '<ml>'.$lv_row['ml'].'</ml>':'';
            $lv_arr['evlatrval001'].= isset($lv_row['p'])? '<p>'.$lv_row['p'].'</p>':'';
            $lv_arr['evlatrval001'].= isset($lv_row['t'])? '<t>'.$lv_row['t'].'</t>':'';
            $lv_arr['evlatrval001'].= isset($lv_row['fc'])? '<fc>'.$lv_row['fc'].'</fc>':'';
            $lv_arr['evlatrval001'].= isset($lv_row['fr'])? '<fr>'.$lv_row['fr'].'</fr>':'';
            $lv_arr['evlatrval001'].= isset($lv_row['ta'])? '<ta>'.$lv_row['ta'].'</ta>':'';
            $lv_arr['docsts'] = 'A';
            if ( isset($lv_row['deleted']) ) {
              if ($lo_evlspcmdl->delete()==false) {
				 	     	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlspcmdl->errcod,'errtxt'=>$lo_evlspcmdl->errtxt) );
              }
            } else if ($lo_evlspcmdl->save( $lv_arr )==false) {
			 	     	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlspcmdl->errcod,'errtxt'=>$lo_evlspcmdl->errtxt) );
            }
          }
        }

        // EVOLUCION MATERIALES - grabo datos de materiales
        $lv_buffer = 	$lv_buf_arr['evlmat'];
        if ($lv_buffer!='') {
          $lv_buffer = html_entity_decode($lv_buffer);
          $lv_mat_arr = json_decode($lv_buffer,true);
          foreach( $lv_mat_arr as $lv_row ) {
            $lv_arr = $lv_row;
            $lv_arr['evlcod'] = $lo_evlmdl->evlcod;
            $lv_arr['matatrval001']= isset($lv_row['atrstrtme'])? '<strtme>'.$lv_row['atrstrtme'].'</strtme>':'';
            $lv_arr['matatrval001'].= isset($lv_row['atrendtme'])? '<endtme>'.$lv_row['atrendtme'].'</endtme>':'';
            $lv_arr['matatrval001'].= isset($lv_row['atradvrea'])? '<advrea>'.$lv_row['atradvrea'].'</advrea>':'';
            $lv_arr['docsts'] = 'A';
            if ( isset($lv_row['deleted']) ) {
              if ($lo_evlmatmdl->delete()==false) {
 					     	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
              }
            } else if ($lo_evlmatmdl->save( $lv_arr )==false) {
 				     	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
            }
          }
        }
      }
      $lv_errcod = '';
      $lv_errtxt = '';
      if($lv_buf_arr['fvrpt']=='on'){
        /*DATOS DEL PACINTE */
        $lo_patdl = $this->co_reg->load->model('hltpat');
        $lo_patdl->load(array('patcod'=>$lv_buf_arr['patcod']),false);

        // obtengo texto del mensaje
        $lo_txtmdl = $this->co_reg->load->model('grldattxt');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'HLTEVLGRL'.chr(9).chr(9).
                                      '[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
                                      '[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
                                      '[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
                        'vewmaxrec'=>'1');
        $lo_rs = $lo_txtmdl->getList($lv_prm);
        unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlstm']);
        if( count($lo_rs)!=0 ) {
          $lv_usrmsg = $lo_rs[0]['txttxt'];
        } else {
          $lv_usrmsg = '';
          $lv_errcod = '-1';
          $lv_errtxt = 'No se encontró el texto del mensaje.';
        } 
        // determino destinatarios
        $lv_issisdev = stripos($_SERVER['REQUEST_URI'],'/sysdev/');
        if($lv_issisdev !== false){
          $lv_mailto[] = array('address'=>'grusso@teaminfusion.com');
          $lv_mailto[] = array('address'=>'cdominguez@teaminfusion.com');

        }else{
          if($this->co_reg->sec->buscod=='TINFUSIONCL'){
            $lv_mailto[] = array('address'=>'coordinacion@teaminfusion.cl');  
          }else{
            $lv_mailto[] = array('address'=>'coordinacion@teaminfusion.com');
          }
        }
        // envío mail
        if ( $lv_usrmsg!='' && count($lv_mailto)>0) {
          $lo_eml = new tmssMail();
          $lv_emlprm= array();
          $lv_emlprm['to'] = $lv_mailto;
          $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'LSDM') );
          $lv_emlprm['subject'] = 'Evolucion para reporte a FV';
          $lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
          $lv_usrmsg = str_replace( '[%2]', 'Evoluci&oacute;n para reportar a farmacovigilancia' , $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Paciente : ( #'. $lv_buf_arr['patcod'] . ' ) <strong>'.   utf8_decode($lo_patdl->pattxt). '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Financiador : <strong>'.   utf8_decode($lo_patdl->custxt). '</strong><br/>[%3]', $lv_usrmsg);			  
          $lv_usrmsg = str_replace( '[%3]', 'Fecha de evolucion: ( #'. $lo_evlmdl->evlcod . ' ) <strong>'. $lv_buf_arr['evldte']. '</strong><br/>[%3]', $lv_usrmsg);
          $lv_usrmsg = str_replace( '[%3]', 'Prestador : ( #'. $lv_buf_arr['prscod'] . ' ) <strong>'.   utf8_decode($lv_buf_arr['prstxt']). '</strong><br/>[%3]', $lv_usrmsg);
          $lv_usrmsg = str_replace( '[%3]', 'Especialidad : ( #'. $lv_buf_arr['spccod'] . ' ) <strong>'.   utf8_decode($lv_buf_arr['spctxt']) .'</strong>', $lv_usrmsg);
          $lv_emlprm['bodyhtml'] = $lv_usrmsg;
          if ( $lo_eml->send( $lv_emlprm ) ) {
            $lv_errcod = '0';
            $lv_errtxt = 'Enviado';
          } else {
            $lv_errcod = '-1';
            $lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
		 	     	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt) );
          }
        }
      } 
    	return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
    }
  }
  private function evldel($lp_prm=array() ){
    $lv_evlcod = $lp_prm['evlcod'];
		/* determino si se encuentra en alguna liquidación */
		$lo_prslqddocmdl = $this->co_reg->load->model('hltprslqddoc');
		$lv_prm = array('vewfldflt' =>'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
																	'[~fltrow~]ld.refobjcod001'.chr(9).'='.chr(9).chr(9).$lv_evlcod.chr(9).chr(9) );
		$lo_rssrv = $lo_prslqddocmdl->getList( $lv_prm );
		if ( count($lo_rssrv)>0 ) {
 			return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-4,'errtxt'=>'No se puede borrar la evolucion. Esta incluida en la liquidacion ['.$lo_rssrv[0]['hltprslqdcod'].']') );
		} else {
			$lo_evlmdl = $this->co_reg->load->model('hltpatevl');    	
			if ( $lo_evlmdl->delete( array('evlcod'=>$lv_evlcod), false ) ) {
        return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
			}
		}
 	  return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
  }
  
  //Decripcion:Trae los motivos de no ejecucion de un estudio,infucion, etc
  //Parametros
  // prmmdl: Modelo del parametro de empresa en dode se buscara la informacion
  // mdlcod: Codigo del parametro de empresa en el que se buscara la informacion, esta parametro se usa para instanciar el modulo en caso de no especificarlo en prmmdl
  // prmkey: Clave del parametro que se decea buscar si no se especifica se retornan los que enpuezan con el string CUS_
  private function getServiceNonExecutionReasons($lp_prm=array()){
    $lp_prm['prmkey']=strtoupper($lp_prm['prmkey']??'');
    //var_dump($lp_prm['prmkey']);
    if(!isset($lp_prm['prmmdl'])){
      $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
      if(!$lo_prmmdl->load(array('mdlcod'=>$lp_prm['mdlcod']))){
        return array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt);
      }
    }else{
      $lo_prmmdl=$lp_prm['prmmdl'];
    }
    
    $lo_prmmdl->mdlatrval001=str_replace("*", "all", $lo_prmmdl->mdlatrval001);
    $lv_atrusr = <<<XML
<?xml version='1.0'?> 
<document>
.htmlentities($lo_prmmdl->mdlatrval001).
</document>
XML;
    $lv_dat = simplexml_load_string($lv_atrusr);
    $lv_evlcncmtv = [];
    foreach($lv_dat as $lv_key=>$lv_val){
      if( $lp_prm['prmkey']!='' && strtoupper($lv_key) !=strtoupper($lp_prm['prmkey']) ){ continue; }
      if($lp_prm['prmkey']=='' && !str_contains($lv_key,'CUS_') && strtoupper($lv_key) !='ALL'){ continue; }
      $lv_key= str_replace("CUS_", "", $lv_key);
      $lv_cncmtvrow = explode(";", $lv_val);
      $lv_evlcncmtv[$lv_key]=[];
      
      foreach($lv_cncmtvrow as $lv_rowmtv){
        $lv_a = explode(",", $lv_rowmtv);
        if(count($lv_a)==1){
          $lv_evlcncmtv[$lv_key]=$lv_rowmtv;
        }else{
        	$lv_evlcncmtv[$lv_key][$lv_a[0]]=$lv_a[1];
        }
      }
    }
    return $lp_prm['prmkey']!=''?$lv_evlcncmtv[$lp_prm['prmkey']]:$lv_evlcncmtv;
  }
  public function sendMailFarma($lpData){
    $lpData['evlcod']=$lpData['evlcod']??'ERR'; 
    $lpData['cuscod']=$lpData['cuscod']??'';
    $lpData['patcod']=$lpData['patcod']??'';
    $lpData['pattxt']=$lpData['pattxt']??'';
    $lpData['spccod']=$lpData['spccod']??'';
    $lpData['spctxt']=$lpData['spctxt']??'';
    $lpData['evlcmt']=$lpData['evlcmt']??'';
    // Busco el Texto del mensage
    $lo_txtmdl = $this->co_reg->load->model('grldattxt');
    $lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'HLTEVLGRL'.chr(9).chr(9).
                                  '[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
                                  '[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
                                  '[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
                    'vewmaxrec'=>'1');
    $lo_rs = $lo_txtmdl->getList($lv_prm);
    if( count($lo_rs)!=0 ) {
      $lv_usrmsg = $lo_rs[0]['txttxt'];
    } else {
      $lv_usrmsg = '';
      $lv_errcod = '-1';
      $lv_errtxt = 'No se encontró el texto del mensaje.';
    } 
    
    // determino destinatarios
    $lo_appprmmdl = $this->co_reg->load->model('sysappmdlprm');
    if ( $lo_appprmmdl->load(array('mdlcod'=>'CNFEMLFMV')) == false ) {
      $lv_buffer = '-100: NO EXISTE PARAMETRO DE EMPRESA CON EL CODIGO "CNFEMLFMV"';
      return $lv_buffer;
    }

    $lv_sndeml = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,$lpData['cuscod']);	// MAILS
    if($lv_sndeml==''){
      $lv_sndeml = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'*');	// MAILS
    }
    $lv_mailtoarr = explode(';',$lv_sndeml);
    foreach( $lv_mailtoarr as $lv_val) {
      $lv_mailto[] = array('address'=>$lv_val);
    }
    // envío mail
    if ( $lv_usrmsg!='') {
      $lo_eml = new tmssMail();
      $lv_emlprm= array();
      $lv_emlprm['to'] = $lv_mailto;
      $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'LSDM') );
      $lv_emlprm['subject'] = 'Evolucion para reporte a FV';
      $lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
      $lv_usrmsg = str_replace( '[%2]', 'Evoluci&oacute;n para reportar a farmacovigilancia' , $lv_usrmsg);
      $lv_usrmsg = str_replace( '[%3]', 'Paciente : ( #'. $lpData['patcod'] . ' ) <strong>'.   utf8_decode($lpData['pattxt']). '</strong><br/>[%3]', $lv_usrmsg);
      $lv_usrmsg = str_replace( '[%3]', 'Financiador : ( #'. $lpData['cuscod'] . ' ) <strong>'.   utf8_decode($lpData['custxt']). '</strong><br/>[%3]', $lv_usrmsg);			  
      $lv_usrmsg = str_replace( '[%3]', 'Fecha de evolucion: ( #'. $lpData['evlcod'] . ' ) <strong>'. $lpData['evldte']. '</strong><br/>[%3]', $lv_usrmsg);
      $lv_usrmsg = str_replace( '[%3]', 'Prestador : ( #'. $lpData['prscod'] . ' ) <strong>'.   utf8_decode($lpData['prstxt']). '</strong><br/>[%3]', $lv_usrmsg);
      $lv_usrmsg = str_replace( '[%3]', 'Especialidad : ( #'. $lpData['spccod'] . ' ) <strong>'.   utf8_decode($lpData['spctxt']) .'</strong><br/>[%3]', $lv_usrmsg);
      $lv_usrmsg = str_replace( '[%3]', 'Comentarios:<br/>'.utf8_decode($lpData['evlcmt']).'<br/>', $lv_usrmsg);
      $lv_emlprm['bodyhtml'] = $lv_usrmsg;
      if ( $lo_eml->send( $lv_emlprm ) ) {
        $lv_errcod = '';
        $lv_errtxt = '';
      } else {
        $lv_errcod = '-1';
        $lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
        return array('errtyp'=>'E','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt);
      }
    }    
  }
}// Fin Clase
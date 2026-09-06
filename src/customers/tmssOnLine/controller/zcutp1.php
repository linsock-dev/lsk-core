<?php 
final class zcutp1Controller extends tmssController {  
	//const MODEL = 'zcutp1';
	const VIEW  = 'zcutp1'; 
	const ID = '';
  protected $co_reg; 
	private $lo_mdl;  
  private $data = array();
    
  function __construct(&$lp_reg) {   
    $this->co_reg = $lp_reg;
  }
  
  // MAIN METHOD
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session    
		$this->co_reg->request->post['ajax']='1';
		$lv_lgnbuf = $this->co_reg->user->checkUserLogin();
		if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		$this->data['actcod'] = $lp_act;
		
		$lp_act = '#' . $lp_act; 
    switch( $lp_act ) {
			// D A S H B O A R D
      case '#': case '#08': case '#02':
				$lo_data = array();
				$lo_post = $this->co_reg->request->post;
        
				// regreso la vista
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' => $this->co_reg->sec,
												'data' => $lo_data,
												'actcod' => $this->data['actcod']
												//,model' => self::MODEL
												);
				$lv_buffer = 	$this->co_reg->load->view('zcutp1', $lv_prm);
				return $lv_buffer;
        break;
				
				
				
        case "#filterdsh1":
        	// regreso la vista
					$lv_prm = array('lang'  => $this->co_reg->language,
													'input' => $this->co_reg->input,
													'sec' => $this->co_reg->sec,
													'data' => array('hltdisclscod'=>'','hltdisclstxt'=>'','patpro'=>'')
												//,model' => self::MODEL
													);
					$lv_buffer = 	$this->co_reg->load->view('filterdsh1', $lv_prm);
					return $lv_buffer;
        	break;
			
			
      case "#prscatrpt":
        
        $lo_hltprscat = $this->co_reg->load->model('hltprscat');
				$lv_prm=array();

				$lv_vewfldflt = (isset($this->co_reg->request->post['vewfldflt'])?$this->co_reg->request->post['vewfldflt']:'');
				$lv_vewmaxrec = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewmaxrec']:'');
        $lv_vewfldord = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewfldord']:'');

				$lv_prm = array('vewfldflt' => $lv_vewfldflt,
                        'vewfldord' => $lv_vewfldord,
												'vewmaxrec' => $lv_vewmaxrec);

				$lv_lmtmem= ini_get('memory_limit');
				ini_set('memory_limit', '2048M');
        
				$lo_rsprscat = $lo_hltprscat->getList($lv_prm);
        
        $lv_ret = array();
        foreach($lo_rsprscat as $lv_row){$lv_ret[]=$lv_row;}
        ini_set('memory_limit', $lv_lmtmem);
        
				return $lv_ret ;
        break;
			
			// ---------------------------------------------------------------------
			// ---------------------------------------------------------------------
			//
			//	E V O L U C I O N E S
			//
			// --------------------------------------------------------------------- 
			// ---------------------------------------------------------------------

			//   EVOLUCION - CREAR/VER
			case '#evlinf':
			
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
        
        // ------------------------------------------------ 
        // Buscar datos sugerencia de material 
        // 1. Busco el parametro para obtener los campos obligatorios seguespecialidad 
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
          /*
          $lv_prmchg = array('vewfldflt' =>'[~fltrow~]dca.chgdocatrnme'.chr(9).'='.chr(9).chr(9).'patwgt'.chr(9).chr(9).
                                          '[~fltrow~]dc.chgdocsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_PAT'.chr(9).chr(9).
                                          '[~fltrow~]dc.chgdocsrccod'.chr(9).'='.chr(9).chr(9). $lo_patmdl->patcod .chr(9).chr(9).
                                          '[~fltrow~]dc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                          );
          $rsChg=$lo_docchgmdl->getVariousDetails( $lv_prmchg );
          $PatChgDte = $lo_docchgmdl->getsysdata('sqlstm');
          
          
          
          
          
          $prmChg = array('vewfldflt' =>'[~fltrow~]dc.chgdocsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_PAT'.chr(9).chr(9).
                           							 '[~fltrow~]chgdocsrccod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lstPat) .chr(9).chr(9).
                           							 '[~fltrow~]dca.chgdocatrnme'.chr(9).'='.chr(9).chr(9).'patwgt'.chr(9).chr(9),
                        'vewfldord' => 'chgdocsrccod desc',
                        'vewfldgrp' => 'chgdocsrccod',
                        'vewfldgrpcal' => 'max(chgdocatrcod) as chgdocatrcod'
													 );
        $rsChg=$mdlChg->getVariousDetails($prmChg, null, null, false);
        $lv_sqlstm[]=$mdlChg->getSysData('sqlstm');
          */
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
				$lv_buffer = 	$this->co_reg->document->getView( 'zcutp2', $lv_prm); 
				return $lv_buffer;
        break;
			
			//   EVOLUCION - GRABAR
			case '#evlinf00':

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
          /*
          // determino destinatarios
          $lo_appprmmdl = $this->co_reg->load->model('sysappmdlprm');
          if ( $lo_appprmmdl->load(array('mdlcod'=>'CNFEMLFMV')) == false ) {
            $lv_buffer = '-100: NO EXISTE PARAMENTOR DE EMPRESA CON EL CODIGO "CNFEMLFMV"';
            return $lv_buffer;
            break;
          }
          
          $lv_sndeml = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,$lo_patdl->cuscod);	// MAILS
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
            $lv_usrmsg = str_replace( '[%3]', 'Paciente : ( #'. $lv_buf_arr['patcod'] . ' ) <strong>'.   utf8_decode($lo_patdl->pattxt). '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Financiador : <strong>'.   utf8_decode($lo_patdl->custxt). '</strong><br/>[%3]', $lv_usrmsg);			  
            $lv_usrmsg = str_replace( '[%3]', 'Fecha de evolucion: ( #'. $lo_evlmdl->evlcod . ' ) <strong>'. $lv_buf_arr['evldte']. '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Prestador : ( #'. $lv_buf_arr['prscod'] . ' ) <strong>'.   utf8_decode($lv_buf_arr['prstxt']). '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Especialidad : ( #'. $lv_buf_arr['spccod'] . ' ) <strong>'.   utf8_decode($lv_buf_arr['spctxt']) .'</strong>', $lv_usrmsg);
            $lv_emlprm['bodyhtml'] = $lv_usrmsg;
            if ( $lo_eml->send( $lv_emlprm ) ) {
              $lv_errcod = '';
              $lv_errtxt = '';
            } else {
              $lv_errcod = '-1';
              $lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt) );
            }
          }
          */
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
			
			//   EVOLUCION - BORRAR
			case '#evlinf04':
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
			
			//   EVOLUCION - HEMOFILIA - VER
			case '#evlhem':

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
                          //,'model' => self::MODEL
													);
				}
				
				// regreso la vista
				$lv_hhcc =(isset($this->co_reg->request->post['hhcc'])?$this->co_reg->request->post['hhcc']:'');
				$lv_prm['data']->hhcc=$lv_hhcc;
				$lv_buffer = 	$this->co_reg->load->view('zcutp3', $lv_prm);
				return $lv_buffer;
        break;
			
			//   EVOLUCION - HEMOFILIA - GRABAR  
			case '#evlhem00':
				
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
				
				$lv_docsts = ( $this->co_reg->request->post['evlinfprc']=='1'?'A':'P' );
				$lv_buf_arr['docsts'] = $lv_docsts;
				
				$lv_buf_arr['evlcmt']=$lv_buf_arr['evlcmt'] ;
				$lv_buf_arr['evlsub']=$lv_buf_arr['evlcnccmt'];
				$lv_buf_arr['evlevl']= $lv_buf_arr['evlevl'];
         $lv_buf_arr['fvrpt']=isset($lv_buf_arr['fvrpt'])?$lv_buf_arr['fvrpt']:'off';
				$lv_buf_arr['evlatr001'] ='<row><dte>'.$lv_evldte.'</dte><evlcncmtv>'.$lv_buf_arr['evlcncmtv'].'</evlcncmtv><evlcnccmt>'.$this->co_reg->db->sqldata($lv_buf_arr['evlcnccmt']).'</evlcnccmt>';
				$lv_buf_arr['evlatr001'] .= '<evlinfprc>'.$lv_buf_arr['evlinfprc'].'</evlinfprc>';
        $lv_buf_arr['evlatr001'].= '<fvrpt>'.$lv_buf_arr['fvrpt'].'</fvrpt>';
        $lv_fvrpttxt = ( $lv_buf_arr['fvrpt']=='on'?'SI':'NO' );
        $lv_buf_arr['evlatr001'].= '<fvrpttxt>'.$lv_fvrpttxt.'</fvrpttxt>';
				$lv_buf_arr['evlatr001'] .= '</row>';
				$lv_buf_arr['evlobj']=$lv_buf_arr['evlinfprc']=='1'?'REALIZADO '.$lv_evldte:'NO REALIZADO' . chr(13)  . $lv_buf_arr['evlcnccmt'];
        
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
				
				// EVOLUCION - INFUSION
				if ( $lv_docsts=='A' ) {
					
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
            }           ;
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
				break;
			
			//   EVOLUCION - HEMOFILIA - BORRAR
			case '#evlhem04':
				$lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);

				/* determino si se encuentra en alguna liquidación */
				$lo_prslqddocmdl = $this->co_reg->load->model('hltprslqddoc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
																			'[~fltrow~]ld.refobjcod001'.chr(9).'='.chr(9).chr(9).$lv_evlcod.chr(9).chr(9) );
				$lo_rssrv = $lo_prslqddocmdl->getList( $lv_prm );
				if ( count($lo_rssrv)>0 ) {
          $lv_ret = array('errtyp'=>'E','errcod'=>-4,'errtxt'=>'No se puede borrar la evolucion. Esta incluida en la liquidacion ['.$lo_rssrv[0]['hltprslqdcod'].']');
				} else {
			
					$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
					if ( $lo_evlmdl->delete( array('evlcod'=>$lv_evlcod), false ) ) {
            $lv_ret = array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt);
					} else {
            $lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
					}
				}
        return $this->co_reg->document->getJson( $lv_ret );
				break;

			// ---------------------------------------------------------------------
			//	ESCLEROSIS
			// ---------------------------------------------------------------------

			//   EVOLUCION - ESCLEROSIS - VER
			case '#evlesc':

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
				$lv_buffer = 	$this->co_reg->load->view('zcutp1_tinevlesc', $lv_prm);
				return $lv_buffer;
        break;
			
			//   EVOLUCION - ESCLEROSIS - GRABAR  
			case '#evlesc00':
				
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
				
				$lv_docsts = ( $this->co_reg->request->post['evlesctra']=='1'?'A':'P' );
				$lv_buf_arr['docsts'] = $lv_docsts;
        $lv_buf_arr['fvrpt']=isset($lv_buf_arr['fvrpt'])?$lv_buf_arr['fvrpt']:'off';
				$lv_buf_arr['evlcmt']=$lv_buf_arr['evlcmt'] ;
				$lv_buf_arr['evlsub']=$lv_buf_arr['evlcnccmt'];
        $lv_buf_arr['evlevl']= $lv_buf_arr['evlevl'];
				$lv_buf_arr['evlatr001']='<row>';
        $lv_buf_arr['evlatr001'].='<dte>'.$lv_evldte.'</dte><evlcnccmt>'.$this->co_reg->db->sqldata($lv_buf_arr['evlcnccmt']).'</evlcnccmt><evlescapl>'.$this->co_reg->db->sqldata($lv_buf_arr['evlescapl']).'</evlescapl><evlesctra>'.$this->co_reg->db->sqldata($lv_buf_arr['evlesctra']).'</evlesctra>';
        $lv_buf_arr['evlatr001'].= '<fvrpt>'.$lv_buf_arr['fvrpt'].'</fvrpt>';
        $lv_fvrpttxt = ( $lv_buf_arr['fvrpt']=='on'?'SI':'NO' );
        $lv_buf_arr['evlatr001'].= '<fvrpttxt>'.$lv_fvrpttxt.'</fvrpttxt>';
				$lv_buf_arr['evlatr001'] .= '</row>';
				
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
				
				// EVOLUCION - INFUSION
				if ( $lv_docsts=='A' ) {
					
					// EVOLUCION MATERIALES - grabo datos de materiales
					$lv_buffer = $this->co_reg->request->post['evlmat'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_mat_arr = json_decode($lv_buffer,true);
						foreach( $lv_mat_arr as $lv_row ) {
							$lv_arr = $lv_row;
							$lv_arr['evlcod'] = $lo_evlmdl->evlcod;
							$lv_arr['matatrval001'] = '<strtme>'.$lv_row['atrstrtme'].'</strtme><advrea>'.$lv_row['atradvrea'].'</advrea>';
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
          /*
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
          if ( $lv_usrmsg!='') {
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
          */
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
        return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
				break;
			
			//   EVOLUCION - ESCLEROSIS - BORRAR
			case '#evlesc04':
				$lv_ret = array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
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
            $lv_ret = array('errtyp'=>'E','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt);
					}
				}
				return $lv_ret; 
				break;

			
			// ---------------------------------------------------------------------
			//	RAQUITISMO
			// ---------------------------------------------------------------------


			//   EVOLUCION -RAQUITISMO - CREAR/VER
			case '#evlraq':
			
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
				$lv_hhcc =(isset($this->co_reg->request->post['hhcc'])?$this->co_reg->request->post['hhcc']:'');
				$lv_prm['data']->hhcc=$lv_hhcc;
				$lv_buffer = 	$this->co_reg->load->view('zcutp1_tinevlraq', $lv_prm);
				return $lv_buffer;
        break;
			
			//   EVOLUCION -RAQUITISMO - GRABAR
			case '#evlraq00':
				
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
				
				$lv_docsts = ( $this->co_reg->request->post['evlraqprc']=='1'?'A':'P' );
				$lv_buf_arr['docsts'] = $lv_docsts;
				$lv_buf_arr['evlcmt']=$lv_buf_arr['evlcmt'] ;
				$lv_buf_arr['evlevl']=$lv_buf_arr['evlevl'];
				$lv_buf_arr['evlsub']=$lv_buf_arr['evlcnccmt'];
        $lv_buf_arr['fvrpt']=isset($lv_buf_arr['fvrpt'])?$lv_buf_arr['fvrpt']:'off';
				$lv_buf_arr['evlatr001']='<row><dte>'.$lv_evldte.'</dte><evlcncmtv>'.$lv_buf_arr['evlcncmtv'].'</evlcncmtv><evlcnccmt>'.$this->co_reg->db->sqldata($lv_buf_arr['evlcnccmt']).'</evlcnccmt>';
				$lv_buf_arr['evlatr001'] .= '<evlraqprc>'.$lv_buf_arr['evlraqprc'].'</evlraqprc>';
        $lv_buf_arr['evlatr001'].= '<fvrpt>'.$lv_buf_arr['fvrpt'].'</fvrpt>';
        $lv_fvrpttxt = ( $lv_buf_arr['fvrpt']=='on'?'SI':'NO' );
        $lv_buf_arr['evlatr001'].= '<fvrpttxt>'.$lv_fvrpttxt.'</fvrpttxt>';
				$lv_buf_arr['evlatr001'] .= '</row>';
				$lv_buf_arr['evlobj']=$lv_buf_arr['evlraqprc']=='1'?'REALIZADO '.$lv_evldte:'NO REALIZADO' . chr(13)  . $lv_buf_arr['evlcncmtv'];
				
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
				
				// EVOLUCION - INFUSION
				if ( $lv_docsts=='A' ) {
					
					// EVOLUCION ATRIBUTOS - grabo datos de atributos
					$lv_buffer = $this->co_reg->request->post['evlatr'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_atr_arr = json_decode($lv_buffer,true);
						foreach( $lv_atr_arr as $lv_row ) {
							$lv_arr = $lv_row;
							$lv_arr['evlcod'] = $lo_evlmdl->evlcod;
							$lv_arr['spccod'] = $lo_evlmdl->spccod;
							$lv_arr['evlatrval001'] = '<p>'.$lv_row['p'].'</p><t>'.$lv_row['t'].'</t><fc>'.$lv_row['fc'].'</fc><fr>'.$lv_row['fr'].'</fr><ta>'.$lv_row['ta'].'</ta>';
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
					$lv_buffer = $this->co_reg->request->post['evlmat'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_mat_arr = json_decode($lv_buffer,true);
						foreach( $lv_mat_arr as $lv_row ) {
							$lv_arr = $lv_row;
							$lv_arr['evlcod'] = $lo_evlmdl->evlcod;
							$lv_arr['matatrval001'] = '<strtme>'.$lv_row['atrstrtme'].'</strtme><advrea>'.$lv_row['atradvrea'].'</advrea>';
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
          if ( $lv_usrmsg!='') {
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
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lv_errco,'errtxt'=>$lv_errtxt) );
            }
          }
        }
        return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
				break;
			
			//   EVOLUCION -RAQUITISMO - BORRAR
			case '#evlraq04':

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

			// IMPRESION - EVOLUCION
			case '#evlraqprn':
			
				// obtengo el numero de evolucion 
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);
				
				// cargo los modelos
				$lo_patevlmdl = $this->co_reg->load->model('hltpatevl');
				$lo_patmdl = $this->co_reg->load->model('hltpat');
				$lo_prsmdl = $this->co_reg->load->model('hltprs');
				
				// obtengo la evolucion
				$lo_rssrv = $lo_patevlmdl->load( array('evlcod'=>$lv_evlcod),false );
				
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' => $this->co_reg->sec,
												'doc' => $this->co_reg->document,
												'data' => $lo_patevlmdl,
												'actcod' => $this->data['actcod']
												);
				$lv_buffer = 	$this->co_reg->load->view('zcutp1_hltpatevlraqpnt', $lv_prm);
				$this->co_reg->response->addHeader('Content-type:application/pdf'); 
				return $lv_buffer;
				break;
			
			
			// ---------------------------------------------------------------------
			//	COAGUCHEK
			// ---------------------------------------------------------------------

			//   EVOLUCION -COAGUCHEK - CREAR/VER
			case '#evlcoa':
			
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
				$lv_buffer = 	$this->co_reg->load->view('zcutp1_tinevlcoa', $lv_prm);
				return $lv_buffer;
        break;
			
			//   EVOLUCION -COAGUCHEK - GRABAR
			case '#evlcoa00':
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
          /*
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
          */
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
          
          
          /* DATOS DEL PACINTE */
          //$lo_patdl = $this->co_reg->load->model('hltpat');
          //$lo_patdl->load(array('patcod'=>$lv_buf_arr['patcod']),false);
          /*
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
          
          // determino destinatarios
          // Buscar el parametro de empresa CNFEMLFMV os mails segun el cliente
          // determino destinatarios
          $lo_appprmmdl = $this->co_reg->load->model('sysappmdlprm');
          if ( $lo_appprmmdl->load(array('mdlcod'=>'CNFEMLFMV')) == false ) {
            $lv_buffer = '-100: NO EXISTE PARAMETRO DE EMPRESA CON EL CODIGO "CNFEMLFMV"';
            return $lv_buffer;
            break;
          }
          
          $lv_sndeml = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,$lo_patdl->cuscod);	// MAILS
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
            
            
            
            $lv_usrmsg = str_replace( '[%3]', 'Paciente : ( #'. $lv_buf_arr['patcod'] . ' ) <strong>'.   utf8_decode($lo_patdl->pattxt). '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Financiador : <strong>'.   utf8_decode($lo_patdl->custxt). '</strong><br/>[%3]', $lv_usrmsg);			  
            $lv_usrmsg = str_replace( '[%3]', 'Fecha de evolucion: ( #'. $lo_evlmdl->evlcod . ' ) <strong>'. $lv_buf_arr['evldte']. '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Prestador : ( #'. $lv_buf_arr['prscod'] . ' ) <strong>'.   utf8_decode($lv_buf_arr['prstxt']). '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace( '[%3]', 'Especialidad : ( #'. $lv_buf_arr['spccod'] . ' ) <strong>'.   utf8_decode($lv_buf_arr['spctxt']) .'</strong>', $lv_usrmsg);
            
            $lv_emlprm['bodyhtml'] = $lv_usrmsg;
            if ( $lo_eml->send( $lv_emlprm ) ) {
              $lv_errcod = '';
              $lv_errtxt = '';
            } else {
              $lv_errcod = '-1';
              $lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt) );
            }
          }
          */
        }
        
				return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>$lv_errcod,'errtxt'=>$lv_errtxt) );
				break;
			
			//   EVOLUCION -COAGUCHEK - BORRAR
			case '#evlcoa04':
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
            //return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_plndtemdl->errcod,'errtxt'=>$lo_plndtemdl->errtxt) );
          }					
				}
        return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
				break;
			
    	//  I M P R E S I O N   -    E V O L U C I O N
			case '#hltpatevlcoaprn':

				// obtengo el numero de evolucion 
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);
				
				// cargo los modelos
				$lo_patevlmdl = $this->co_reg->load->model('hltpatevl');
				$lo_patmdl = $this->co_reg->load->model('hltpat');
				$lo_prsmdl = $this->co_reg->load->model('hltprs');
				
				// obtengo la evolucion
				$lo_rssrv = $lo_patevlmdl->load( array('evlcod'=>$lv_evlcod),false );
				
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' => $this->co_reg->sec,
												'doc' => $this->co_reg->document,
												'data' => $lo_patevlmdl,
												'actcod' => $this->data['actcod']
												);
				$lv_buffer = $this->co_reg->load->view('zcutp1_tinhltpatevlcoapnt', $lv_prm);
				$this->co_reg->response->addHeader('Content-type:application/pdf');
				return $lv_buffer;
				break;
			
			// ---------------------------------------------------------------------
			//	MONITOREO TELEFONICO
			// ---------------------------------------------------------------------

			//   EVOLUCION - MONITOREO TELEFONICO - CREAR/VER
			case '#evlmth':
			
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
				$lv_buffer = 	$this->co_reg->load->view('zcutp1_tinevlmth', $lv_prm);
				return $lv_buffer;
        break;
			
			//   EVOLUCION - MONITOREO TELEFONICO - GRABAR
			case '#evlmth00':
				
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
			
			//   EVOLUCION - MONITOREO TELEFONICO - BORRAR
			case '#evlmth04':

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
      
			// IMPRESION - EVOLUCION
			case '#evlmthprn':
			
				// obtengo el numero de evolucion 
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);
				
				// cargo los modelos
				$lo_patevlmdl = $this->co_reg->load->model('hltpatevl');
				$lo_patmdl = $this->co_reg->load->model('hltpat');
				$lo_prsmdl = $this->co_reg->load->model('hltprs');
				
				// obtengo la evolucion
				$lo_rssrv = $lo_patevlmdl->load( array('evlcod'=>$lv_evlcod),false );
				
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' => $this->co_reg->sec,
												'doc' => $this->co_reg->document,
												'data' => $lo_patevlmdl,
												'actcod' => $this->data['actcod']
												);
				$lv_buffer = 	$this->co_reg->load->view('zcutp1_hltpatevlmthpnt', $lv_prm);
				$this->co_reg->response->addHeader('Content-type:application/pdf'); 
				return $lv_buffer;
				break;		
      
			// ---------------------------------------------------------------------
			//	KINESIOLOGÍA
			// ---------------------------------------------------------------------
      // 	EVOLUCION - KINESIOLOGÍA Y SOEP
      case '#Zevlsoekin': 
				$lo_post = $this->co_reg->request->post;
				$lv_evlcod = ($lo_post['evlcod']??'');
        $lv_patcod = ($lo_post['patcod']??'');
        $lv_spccod = ($lo_post['spccod']??''); // no se usa
				$lv_plnid = ($lo_post['plnid']??$lp_prm['plnid']);
        $lv_plndteid = ($lo_post['plndteid']??$lp_prm['plndteid']);
        $lv_docclscod = ($lo_post['sysdocclscod']??'');
        $lv_hhcc =($lo_post['hhcc']??''); // 'X' para indicar que se abre el formulario desde Historia Clínica
        $lv_evlfrm = ($lp_prm['evlfrm']??'');
        
				// instancio modelos
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
        $lo_patmdl = $this->co_reg->load->model('hltpat');
        $lo_plnmdl = $this->co_reg->load->model('hltpln');
        $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        
        // cargo planificación
        $lo_plnmdl->load(array('plnid'=>$lv_plnid),false);
        $lo_plndtemdl->load(array('plnid'=>$lv_plnid,'plndteid'=>$lv_plndteid));	
        $lo_plnmdl->plndte=$lo_plndtemdl;
        
        $lo_plnmdl->evlcod = $lv_evlcod;
        $lo_plnmdl->plndteid = $lv_plndteid;
        
        /*Obtengo los parametros de empresa*/
        $lo_plnmdl->frmdteva='';        
        // cuando no se encuentra parametro para la especialidad no se permite desplazar las fechas
        $lv_now = date('d/m/Y'); //obtiene la fecha actual en formato dd/mm/yyyy
        $lv_dtestr=365;
        $lv_dteend=365;
        $lo_appprmmdl = $this->co_reg->load->model('sysappmdlprm');
        if ( $lo_appprmmdl->load(array('mdlcod'=>'HLT'))) {
          $lv_spcdte = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'_'.$lv_spccod);// ID Especialidad
          $lv_txterrtst = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'TXT_ERR_TST');// 
          $lv_txterrfrm = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'TXT_ERR_FRM');// 
          if($lv_spcdte!=''){
            $lv_dtestr=explode(',',$lv_spcdte)[0];
            $lv_dteend=explode(',',$lv_spcdte)[1];
          }
        }
				$lv_strdte = new DateTime(date('Y-m-d'));
				$lv_strdte->modify('-'.$lv_dtestr.' day');
				$lv_enddte = new DateTime(date('Y-m-d'));
				$lv_enddte->modify('+'.$lv_dteend.' day');
        $lo_plnmdl->frmdtestr = $lv_strdte;
        $lo_plnmdl->frmdteend = $lv_enddte;
        $lo_plnmdl->txterrtst = $lv_txterrtst;
        $lo_plnmdl->txterrfrm = $lv_txterrfrm;
        
        
        // cargo el paciente
        $lv_patcod=($lv_patcod!=''?$lv_patcod:$lo_evlmdl->patcod);
        $lo_patmdl->load(array('patcod'=>$lv_patcod),false);
        $matplncmt='ssss';
        /* Buscar las interfaz */
        $lo_intmdl = $this->co_reg->load->model('sysint');	        
        $lv_prmint = array('vewfldflt' =>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'EVLTOOSDE'.chr(9).chr(9),
                           'vewmaxrec' =>'1'
                        );
        $lv_rsInt=$lo_intmdl->getList($lv_prmint); 
        if(count($lv_rsInt)>0){
          $lo_intmdl->load(array('sysintcod'=>$lv_rsInt[0]['sysintcod']));
          $cnvLst = array_column($lo_intmdl->sysintcnv,'sysintcnvout001','sysintcnvkey');
          if(isset($cnvLst['SPC_'.$lv_spccod])){
            $matCod = $cnvLst['SPC_'.$lv_spccod];
            $lo_creplnmatmdl = $this->co_reg->load->model('hltpatcreplnmat');
            $lo_creplnmat_rs = array();
            $lv_prm = array('vewfldflt' =>'[~fltrow~]p.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9).
                                          '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                          //'[~fltrow~]getdate() between  p.patcreplnstrdte and p.patcreplnenddte'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9).
                                          '[~fltrow~]m.matcod'.chr(9).'='.chr(9).chr(9).$matCod.chr(9).chr(9).
                                          '[~fltrow~]mc.matclscodext'.chr(9).'='.chr(9).chr(9).'CERH'.chr(9).chr(9));
            $lp_crepln = $lo_creplnmatmdl->getList($lv_prm);
            if(count($lp_crepln)>0){
             $matplncmt= $lp_crepln[0]['matcmt'];
            }
          }
        }

        // si se informo, cargo evolución
        if($lv_evlcod){
        	$lo_evlmdl->load(array('evlcod'=>$lv_evlcod),false);
       	 	$lo_plnmdl->evl = $lo_evlmdl;
					/*
          //Cargo el paciente por evolucion
          $lv_patcod=($lv_patcod!=''?$lv_patcod:$lo_evlmdl->patcod);
          $lo_patmdl->load(array('patcod'=>$lv_patcod),false);
          */
          $lo_plnmdl->pat = $lo_patmdl;
          $lo_plnmdl->pat->matplncmt=$matplncmt;//'420170';
          
         
          
          if($lo_docclsmdl->load(array('sysdocclscod'=>$lo_evlmdl->sysdocclscod))){
       	 		$lo_plnmdl->sysdoccls = $lo_docclsmdl;
          }
          if($lo_evlmdl->evldte<$lo_plnmdl->frmdtestr||$lo_evlmdl->evldte>$lo_plnmdl->frmdteend){
            $lo_plnmdl->frmdteva='X';
          }
          $lo_plnmdl->ctedte=$lo_evlmdl->ctedte;
          $lo_plnmdl->cteusr=$lo_evlmdl->cteusr;
          $lo_plnmdl->upddte=$lo_evlmdl->upddte;
          $lo_plnmdl->updusr=$lo_evlmdl->updusr;
          $lo_plnmdl->prscod = $lo_plnmdl->prscod!=''?$lo_plnmdl->prscod:$lo_evlmdl->prscod;
          $lo_plnmdl->spccod = $lo_plnmdl->spccod!=''?$lo_plnmdl->spccod:$lo_evlmdl->spccod;
				
				// si no se indico evolucion, cargo paciente y determino/selecciono clase de doc de evolucion
        } else {
          /*
          // Cargo el paciente por planificacion
          $lv_patcod=($lo_evlmdl!=''?$lv_patcod:$lo_plnmdl->patcod);
          $lo_patmdl->load(array('patcod'=>$lv_patcod),false);
          */
          $lo_plnmdl->pat = $lo_patmdl;
          $lo_plnmdl->pat->matplncmt=$matplncmt;//'420170';
          
          /* ------------------------------------------------ */
          /* obtengo clase de documento 											*/
          /* ------------------------------------------------ */
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
            $lo_plnmdl->sysdoccls = $lo_docclsmdl;
          } else {
            echo 'No se pudieron cargar los datos de la clase de documento.';
          }
          
          $lo_plndtemdl->plndte=$lo_plndtemdl->plndte==''?$lv_now:$lo_plndtemdl->plndte;
          if($lo_plndtemdl->plndte < $lo_plnmdl->frmdtestr || $lo_plndtemdl->plndte > $lo_plnmdl->frmdteend){
            $lo_plnmdl->frmdteva='X';
          }
        }
        $lo_plnmdl->nevl=($lo_post['nevl']??'');
        
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
        $lv_mtvarr['']='';
        foreach($lv_evlcncmtvrows as $lv_rowmtv){
          $lv_cncmtvrow = explode(",", $lv_rowmtv);
          $lv_mtvarr[$lv_cncmtvrow[0]]=$lv_cncmtvrow[1];
        }
        
        $lo_plnmdl->evlcncmtvlst= $lv_mtvarr;
        // Busco los roles del usuario para saber si tiene el de osde 
      	$mdlUsrGrp = $this->co_reg->load->model('syssecusrgrp');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]u.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9));
        $rsUsrGrp = $mdlUsrGrp->getList($lv_prm);
        $lo_plnmdl->usrgrplst = array_column($rsUsrGrp,'usrgrpcod');
        return $this->co_reg->document->getView( 'zcutp1_tpeevlsoekin', array('data'=>$lo_plnmdl,'actcod'=>$this->data['actcod'], 'evlfrm'=>$lv_evlfrm, 'hhcc'=>$lv_hhcc) );
        break;
      
			
      case '#Zevlsoekin01':
        $lo_post = $this->co_reg->request->post;
				
        $lv_evlcod = ($lo_post['evlcod']??'');
        $lv_patcod = ($lo_post['patcod']??'');
        $lv_spccod = ($lo_post['spccod']??'');
        $lv_prscod = ($lo_post['prscod']??'');
        
				$lv_plnid = ($lo_post['plnid']??$lp_prm['plnid']);
        $lv_plndteid = ($lo_post['plndteid']??$lp_prm['plndteid']);
        $lv_docclscod = ($lo_post['sysdocclscod']??'');
        $lv_hhcc =($lo_post['hhcc']??''); // 'X' para indicar que se abre el formulario desde Historia Clínica
        $lv_evlfrm = ($lp_prm['evlfrm']??'');
        
				// instancio modelos
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
        $lo_patmdl = $this->co_reg->load->model('hltpat');
        $lo_plnmdl = $this->co_reg->load->model('hltpln');
        $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        
        // cargo planificación
        $lo_plnmdl->load(array('plnid'=>$lv_plnid),false);
        $lo_plndtemdl->load(array('plnid'=>$lv_plnid,'plndteid'=>$lv_plndteid));	
        
        $lo_plnmdl->evlcod = $lv_evlcod;
        $lo_plnmdl->plndteid = $lv_plndteid;
        
        /*Obtengo los parametros de empresa*/
        $lo_plnmdl->frmdteva='';
        
        // DAFOULT->cuando no se encuentra parametro para la especialidad no se permite desplazar las fechas
        $lv_now = date('d/m/Y'); //obtiene la fecha actual en formato dd/mm/yyyy
        $lv_dtestr=365;
        $lv_dteend=365;
        $lo_appprmmdl = $this->co_reg->load->model('sysappmdlprm');
        if ( $lo_appprmmdl->load(array('mdlcod'=>'HLT'))) {
          $lv_spcdte = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'_'.$lv_spccod);// ID Especialidad
          $lv_txterrtst = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'TXT_ERR_TST');// 
          $lv_txterrfrm = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'TXT_ERR_FRM');// 
          if($lv_spcdte!=''){
            $lv_dtestr=explode(',',$lv_spcdte)[0];
            $lv_dteend=explode(',',$lv_spcdte)[1];
          }
        }    
				$lv_strdte = new DateTime(date('Y-m-d'));
				$lv_strdte->modify('-'.$lv_dtestr.' day');
				$lv_enddte = new DateTime(date('Y-m-d'));
				$lv_enddte->modify('+'.$lv_dteend.' day');
        $lo_plnmdl->frmdtestr = $lv_strdte;
        $lo_plnmdl->frmdteend = $lv_enddte;
        $lo_plnmdl->txterrtst = $lv_txterrtst;
        $lo_plnmdl->txterrfrm = $lv_txterrfrm;
        
        $lo_evlmdl->load(array('evlcod'=>$lv_evlcod),false);
        $lo_plnmdl->evl = $lo_evlmdl;
				
        // Cargo el paciente por evolucion
        $lv_patcod=$lv_patcod!=''?$lv_patcod:$lo_evlmdl->patcod;
        $lo_patmdl->load(array('patcod'=>$lv_patcod),false);
        $lo_plnmdl->pat = $lo_patmdl;
           
        if($lo_docclsmdl->load(array('sysdocclscod'=>$lo_evlmdl->sysdocclscod))){
          $lo_plnmdl->sysdoccls = $lo_docclsmdl;
        }
        if($lo_evlmdl->evldte<$lo_plnmdl->frmdtestr||$lo_evlmdl->evldte>$lo_plnmdl->frmdteend){
          $lo_plnmdl->frmdteva='X';
        }

        $lo_plnmdl->ctedte=$lo_evlmdl->ctedte;
        $lo_plnmdl->cteusr=$lo_evlmdl->cteusr;
        $lo_plnmdl->upddte=$lo_evlmdl->upddte;
        $lo_plnmdl->updusr=$lo_evlmdl->updusr;
        $lv_prscod = ($lo_post['prscod']??'');
        $lo_plnmdl->prscod = $lo_plnmdl->prscod!=''?$lo_plnmdl->prscod:$lo_evlmdl->prscod;
        $lo_plnmdl->spccod = $lo_plnmdl->spccod!=''?$lo_plnmdl->spccod:$lo_evlmdl->spccod;
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
        $lo_plnmdl->evlcncmtvlst= $lv_mtvarr;
        // Busco los roles del usuario para saber si tiene el de osde 
      	$mdlUsrGrp = $this->co_reg->load->model('syssecusrgrp');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]u.usrcod'.chr(9).'='.chr(9).chr(9).$this->co_reg->sec->usrcod.chr(9).chr(9));
        $rsUsrGrp = $mdlUsrGrp->getList($lv_prm);
        $lo_plnmdl->usrgrplst = array_column($rsUsrGrp,'usrgrpcod');
        
        return $this->co_reg->document->getView( 'zcutp1_tpeevlsoekin', array('data'=>$lo_plnmdl,'actcod'=>$this->data['actcod'], 'evlfrm'=>$lv_evlfrm, 'hhcc'=>$lv_hhcc) );
        break;
			
      case '#Zevlsoekin00':
				$lo_post = $this->co_reg->request->post;
        /*
        $lo_patmdl = $this->co_reg->load->model('hltpat');
        if(!$lo_patmdl->load(array('patcod'=>$lo_post['patcod']),false)){
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_patmdl->errtyp,'errcod'=>$lo_patmdl->errcod,'errtxt'=>$lo_patmdl->errtxt) ); 
        }
        */
        $lo_post['evlevl']=isset($lo_post['evlevl'])?(substr($lo_post['evlevl'], 0, 3000)):'';
        $lo_post['docsts']='A';
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
        $lo_post['evlatr001']=$lo_post['evlatr001']??'';
        $lv_ret =[];
        if(1==1){
        	$lv_evlinfprc=isset($this->co_reg->request->post['evlinfprc'])?$this->co_reg->request->post['evlinfprc']:'0';
        	$lv_evlcncmtv=isset($this->co_reg->request->post['evlcncmtv'])?$this->co_reg->request->post['evlcncmtv']:'';
        //return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>30,'errtxt'=>$lv_evlinfprc) );
        	$lo_post['evlinfprc']= $lv_evlinfprc;
					$lv_docsts = ( $lv_evlinfprc=='1'?'A':'P' );
					$lo_post['docsts'] = $lv_docsts;
          $lo_post['evlatr001'].='<evlinfprc>'.$this->co_reg->db->sqldata($lv_evlinfprc).'</evlinfprc>';
          $lo_post['evlatr001'].= '<evlcncmtv>'.$lv_evlcncmtv.'</evlcncmtv>';
          /* Buscar las interfaz */
          $lo_intmdl = $this->co_reg->load->model('sysint');	        
          $lv_prmint = array('vewfldflt' =>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'EVLTOOSDE'.chr(9).chr(9),
                             'vewmaxrec' =>'1'
                          );
          $lv_rsInt=$lo_intmdl->getList($lv_prmint); 
          if(count($lv_rsInt)>0){
            if(!$lo_intmdl->load(array('sysintcod'=>$lv_rsInt[0]['sysintcod']))){
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_intmdl->errcod,'errtxt'=>$lo_intmdl->errtxt) );
            }

            $lv_intval=[];
            $lv_intval['apiurl']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'apiurl');
            $lv_intval['cuscodlst']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'cuscodlst');
            $lv_intval['spccodlst']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'spccodlst');
            $lv_intval['emlerrcodlst']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'emlerrcodlst');
            $lv_intval['notsveerrcodlst']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'notsveerrcodlst');
            $lv_intval['activeLog']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'activate_audit_log');
            $lv_intval['emllstesp']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'spcemllst_'.$lo_post['spccod']);
            $lv_intval['emllstspcall']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'spcemllst_*');
            
            $lv_intval['cuscod']= $lo_post['cuscod'];//$lo_patmdl->cuscod;
            $lv_intval['spccnv']=[];
            foreach($lo_intmdl->sysintcnv as $lo_rowcnv){
              $lv_intval['spccnv'][$lo_rowcnv['sysintcnvkey']]=$lo_rowcnv['sysintcnvout001'];
            }
          }
          
          // Es paciente osde?
          //$lo_post['cuscod']= $lo_patmdl->cuscod;
          $lv_bolspccod=true;
          if(stripos($lv_intval['spccodlst'], ';'.$lo_post['spccod'].";")===false){
						$lv_bolspccod=false;
					}
          $lv_bolcuscod=true;
          if(stripos($lv_intval['cuscodlst'], ';'.$lo_post['cuscod'].";")===false){
						$lv_bolcuscod=false;
					}
          
          if($lv_bolspccod && $lv_bolcuscod && $lv_docsts=='A'){
            $lo_post['evllon']=$lo_post['evllon']??'';
            $lo_post['evllat']=$lo_post['evllat']??'';
            if($lo_post['evllon'] ==''|| $lo_post['evllat']==''){
            	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'01','errtxt'=>'No se puede realizar la EVOLUCION. Active la GEOLOCALIZACION') ); 
            }
            $lo_datpermdl = $this->co_reg->load->model('grldatper');
            if(!$lo_datpermdl->load(array('persrctyp'=>'HLT_PAT','persrccod'=>$lo_post['patcod']))){
              $lo_datpermdl->hhrmedcovaflnum ='';
            }
            $lv_dte = date("Y-m-d H:i:s");
            $lv_curdte = new DateTime($lv_dte);
            $lv_evldte = $fechaDateTime = DateTime::createFromFormat('d/m/Y', $lo_post['evldte']);
            $lv_prm=[];
            $lv_prm['apiurl']=$lv_intval['apiurl'];
            $lv_prm['dte']=$lv_evldte->format('Ymd');//'20231121';
            $lv_prm['evldte']=$lv_evldte->format('Ymd');//'20231121';
            $lv_prm['hur']='1556';
            $lv_prm['gpslon']=$lo_post['evllon'];
            $lv_prm['gpslat']=$lo_post['evllat'];
            $lv_prm['prescod']=$lo_post['matplncmt'];
            $lv_prm['aficod']=$lo_datpermdl->hhrmedcovaflnum;//'60671956201';//$lo_patmdl->hhrmedcovaflnum??'60671956201';
            $lv_prm['seccod']=$lo_post['seccod']??'218';
            $lv_ret=[];
            $lv_data = array('now'=>$lv_curdte->format('d/m/Y'),'evldte'=>$lv_evldte->format('d/m/Y'));
            
            if($lv_curdte->format('Ymd')==$lv_evldte->format('Ymd')){
              $lv_ret = $this->senOsdeEvl($lv_prm);  
            }else{
              $lv_ret = $this->ZsenOsdeEvlDif($lv_prm);
          	}
            $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
            if(!$lo_plndtemdl->load(array('plnid'=>$lo_post['plnid'],'plndteid'=>$lo_post['plndteid']))){
              $lo_plndtemdl->prstxt='No encontrado';
              $lo_plndtemdl->pattxt='No encontrado';               
            }
            if(strtoupper($lv_intval['activeLog'])=='X'){
              $lo_applogmdl = $this->co_reg->load->model('sysapplog');
              $lv_errlog=[];
              $lv_errlog['srcobjtyp']='SYS_INT';
              $lv_errlog['srcobjcod001']=$lo_intmdl->sysintcod;
              $lv_errlog['srcobjcod002']='';
              $lv_errlog['applogtxt']='';
              $lv_errlog['applogtecinf']='';
              $lv_errlog['mdlcod']='zcutp1';
              $lv_errlog['prgcod']='evlsoekin00';
              $lv_errlog['docsts']='A';
              $lv_errlog['applogerrtyp']=$lv_ret['errtyp'];
              $lv_errlog['applogerrcod']=trim($lv_ret['data']['rtaadic']);
              $lv_errlog['applogerrtxt']='<code>';
              $lv_errlog['applogerrtxt'].='<strong>Paciente:</strong> ('  . $lo_post['patcod'].')'. $lo_plndtemdl->pattxt.'<br>';
              $lv_errlog['applogerrtxt'].='<strong>Afil. Num.:</strong> ' . $lv_prm['aficod'].'<br>';
              $lv_errlog['applogerrtxt'].='<strong>Prestador:</strong> (' . $lo_post['prscod'].') '. $lo_plndtemdl->prstxt.'<br>';
              $lv_errlog['applogerrtxt'].='<strong>Cod. Seg.:</strong> (' . $lv_prm['seccod'].')';
              $lv_errlog['applogerrtxt'].='<strong>Cod. Pres.:</strong> [' . $lv_prm['prescod'].']<br>';
              $lv_errlog['applogerrtxt'].='<strong>Fecha de planificacion:</strong> '.$lv_evldte->format('d/m/Y').'<br>';
              $lv_errlog['applogerrtxt'].='<strong>apinroref= </strong>'.trim($lv_ret['data']['nroref']).'<br>';
              $lv_errlog['applogerrtxt'].='<strong>msjdisp= </strong>'.trim($lv_ret['errtxt']).'<br>';
              $lv_errlog['applogerrtxt'].='</code>';
              $lv_errlog['applogtxt']='applogtxt';
              $lo_applogmdl->save($lv_errlog);
            }
            if($lv_ret['errtyp']=='S'){
              $lo_post['evlatr001'] .= "<apisendok>1</apisendok><apinroref>".trim($lv_ret['data']['nroref'])."</apinroref><msjdisp>".trim($lv_ret['errtxt'])."</msjdisp><rtaadic>".trim($lv_ret['data']['rtaadic'])."</rtaadic><prescod>" . $lv_prm['prescod']."</prescod>";
            }else{ 
              $lo_post['evlatr001'] .= "<apisendok>0</apisendok><apinroref>".$lv_ret['errtyp']."-".$lv_ret['errcod']."</apinroref><msjdisp>".trim($lv_ret['errtxt'])."</msjdisp><rtaadic>".trim($lv_ret['data']['rtaadic'])."</rtaadic><prescod>" . $lv_prm['prescod']."</prescod>";
              $lv_sendeml = true;
              if(stripos($lv_intval['emlerrcodlst'], ';'.trim($lv_ret['data']['rtaadic']).";")===false){
                $lv_sendeml=false;
              }
              $lv_intsveevl=true;
              if(stripos($lv_intval['notsveerrcodlst'], ';'.trim($lv_ret['data']['rtaadic']).";")===false){
                $lv_intsveevl=false;
              }              
              if($lv_sendeml){ //Se envia mail informando error?
                
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
                  $lv_usrmsg='[%1]<br>[%2]';
                } 
                
                $lv_mailto=[];
                if($lv_intval['emllstesp'] ==''){
                  $lv_intval['emllstesp']=$lv_intval['emllstspcall'];
                }
                $lv_mailtoarr = explode(';',$lv_intval['emllstesp']);
                foreach( $lv_mailtoarr as $lv_val) {
                  $lv_mailto[] = array('address'=>$lv_val);
                }
                
                // envío mail
                if ( $lv_usrmsg!='') {
                  $lo_eml = new tmssMail();
                  $lv_emlprm= array();
                  $lv_emlprm['to'] = $lv_mailto;
                  $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) );
                  $lv_emlprm['subject'] = 'Error al informar la evolucion a OSDE';
                  $lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
                  $lv_usrmsg = str_replace( '[%2]', 'Error al grabar la evolucion', $lv_usrmsg );
                  $lv_tblEml='<table>';
                  $lv_tblEml.='<tr><td>C&oacute;digo</td><td>'.trim($lv_ret['data']['rtaadic']).'</td></tr>';
                  $lv_tblEml.='<tr><td>Error</td><td>'.$lv_ret['errtxt'].'</td></tr>';
                  $lv_tblEml.='<tr><td>Paciente:</td><td>('. $lo_post['patcod'].')</strong> '. $lo_plndtemdl->pattxt.'</td></tr>';
                  $lv_tblEml.='<tr><td>Prestador</td><td>(' . $lo_post['prscod'].')</strong> '. $lo_plndtemdl->prstxt.'</td></tr>';
                  $lv_tblEml.='<tr><td>Fecha de planificacion</td><td>' . $lo_plndtemdl->plndte->format('d/m/Y') . '</td></tr>';
                  $lv_tblEml.='<tr><td>Especialidad</td><td>'.$lo_plndtemdl->spctxt.'</td></tr>';
                  $lv_tblEml.='</table>';
                  $lv_usrmsg = str_replace( '[%3]', $lv_tblEml, $lv_usrmsg );
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
              
              if($lv_intsveevl){//Se detiene la ejecucion?
                return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>trim($lv_ret['data']['rtaadic']),'errtxt'=>trim($lv_ret['errtxt'])) );
              }
            }
          }
        }//1==1
        $lo_post['evlatr001']='<row>'.$lo_post['evlatr001'].'</row>';
        if(!$lo_evlmdl->save($lo_post, false)){
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_evlmdl->errtyp,'errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) ); 
        }
        
        $this->co_reg->request->post['evlcod'] = $lo_evlmdl->evlcod;          
        return $this->index('evlsoekin01', $lp_prm);
        break;
      
      case '#Zevlsoekin04':
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
				$lo_post = $this->co_reg->request->post;
        // Es paciente osde?
        $lv_ret =[];
        if(1==2){
          $lo_evlmdl->load($lo_post,false);
          $lv_dte = date("Y-m-d H:i:s");
					$lv_curdte = new DateTime($lv_dte);
          $lv_evldte = $fechaDateTime = DateTime::createFromFormat('d/m/Y', $lo_post['evldte']);
          $lv_prm=[];
          $lv_prm['evldte']=$lv_evldte->format('Ymd');//'20231121';
          $lv_prm['dte']=$lv_evldte->format('Ymd');//'20231121';
          $lv_prm['hur']='1556';
          $lv_prm['apinroref']=$this->co_reg->document->gettagvalue($lo_evlmdl->evlatr001,'apinroref');
          $lv_prm['aficod']='60671956201';
          $lv_prm['seccod']=isset($lo_post['seccod'])?$lo_post['seccod']:'218';
          $lo_post['evlatr001'] = $lo_evlmdl->evlatr001;
          $lo_post['docsts'] = $lo_evlmdl->docsts;
          
          $lv_ret = $this->ZDelOsdeEvl($lv_prm);
           if($lv_ret['errtyp']=='S'){
            $lo_post['evlatr001'] .= "<apinrodel>".trim($lv_ret['data']['nroref'])."</apinrodel>";
          }else{
            $lo_post['evlatr001'] .= "<apinrodel>".$lv_ret['errtyp']."-".$lv_ret['errcod']."</apinrodel>";          
          }
          $lo_evlmdl->save($lo_post, false);
        }
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
        $lo_evlmdl->delete($lo_post, false);
        return $this->co_reg->document->getJson( array('errtyp'=>$lo_evlmdl->errtyp,'errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );        
        break;
        
        
			// ---------------------------------------------------------------------
			//	INFUSION ONCO
			// ---------------------------------------------------------------------

			//   EVOLUCION -INFUSIÓN ONCO - CREAR/VER
			case '#evlonc':
				/*Obtenemos los parametros post*/
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:'');
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_hhcc = (isset($this->co_reg->request->post['hhcc'])?$this->co_reg->request->post['hhcc']:'');
				$lv_prm= array('evlcod'=>$lv_evlcod,'plnid'=>$lv_plnid,'plndteid'=>$lv_plndteid,'vewcod'=>'zcutp1_tinevlonc','hhcc'=>$lv_hhcc);
				return $this->evlvew($lv_prm);
				break;

			//   EVOLUCION - GRABAR
			case '#evlonc00':
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:'');
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_evldte =(isset($this->co_reg->request->post['evldte'])?$this->co_reg->request->post['evldte']:$lp_prm['evldte']);
				$lv_prm= array('evlcod'=>$lv_evlcod,'plnid'=>$lv_plnid,'plndteid'=>$lv_plndteid,'evldte'=>$lv_evldte);
				return $this->evlsve($lv_prm,$this->co_reg->request->post);
				break;
        
			//   EVOLUCION - GRABAR
			case '#evlonc04':
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);
        $lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_prm= array('evlcod'=>$lv_evlcod,'plnid'=>$lv_plnid,'plndteid'=>$lv_plndteid);
				return $this->evldel($lv_prm);
				break;
			//   EVOLUCION -APLICACION ONCO - CREAR/VER
			case '#evlapponc':
				/*Obtenemos los parametros post*/
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:'');
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_hhcc = (isset($this->co_reg->request->post['hhcc'])?$this->co_reg->request->post['hhcc']:'');
				$lv_prm= array('evlcod'=>$lv_evlcod,'plnid'=>$lv_plnid,'plndteid'=>$lv_plndteid,'vewcod'=>'zcutp1_tinevlapponc','hhcc'=>$lv_hhcc);
        // cargo la evolución
        $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
				$lo_plndtemdl->load( array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid) );
        
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
        $lv_prm['evlcncmtvlst']= $lv_mtvarr;
        
				return $this->evlvew($lv_prm);
				break;
      
			//   APLICACION ONCO - GRABAR
			case '#evlapponc00':
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:'');
				$lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_evldte =(isset($this->co_reg->request->post['evldte'])?$this->co_reg->request->post['evldte']:$lp_prm['evldte']);
				$lv_prm= array('evlcod'=>$lv_evlcod,'plnid'=>$lv_plnid,'plndteid'=>$lv_plndteid,'evldte'=>$lv_evldte);
				return $this->evlsve($lv_prm,$this->co_reg->request->post);
				break;
        
			//   APLICACION ONCO - GRABAR
			case '#evlapponc04':
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);
        $lv_plnid = (isset($this->co_reg->request->post['plnid'])?$this->co_reg->request->post['plnid']:$lp_prm['plnid']);
				$lv_plndteid = (isset($this->co_reg->request->post['plndteid'])?$this->co_reg->request->post['plndteid']:$lp_prm['plndteid']);
				$lv_prm= array('evlcod'=>$lv_evlcod,'plnid'=>$lv_plnid,'plndteid'=>$lv_plndteid);
				return $this->evldel($lv_prm);
				break;
        
			//   EVOLUCION -TOMA DE MUESTRAS - CREAR/VER
			case '#evlgetsmp':
			
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
				$lv_buffer = 	$this->co_reg->load->view('zcutp1_tinevlgetsmp', $lv_prm);
				return $lv_buffer;
        break;
				
			//   TOMA DE MUESTRAS - GRABAR
			case '#evlgetsmp00':
				
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
				$lv_evldte =$this->co_reg->request->post['evldte']??($lp_prm['evldte']??'');//(isset($this->co_reg->request->post['evldte'])?$this->co_reg->request->post['evldte']:$lp_prm['evldte']);
				
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
          $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
          if ( count($lv_docclsarr)==1 ) {											// si hay solo una la tomo como default
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

				break;
			//   TOMA DE MUESTRAS - GRABAR
			case '#evlgetsmp04':

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
        //if ( $lo_evlmdl->delete( array('evlcod'=>$lv_evlcod), false ) ) {
        //  return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );
        //}
        return $this->co_reg->document->getJson( array('errtyp'=>'S','errcod'=>0,'errtxt'=>'') );
				break;
						
			// ---------------------------------------------------------------------
			// ---------------------------------------------------------------------
			//
			//	I M P R E S I O N E S
			//
			// ---------------------------------------------------------------------
			// ---------------------------------------------------------------------
			
			
			
			// IMPRESION - LIQUIDACION - PRESTADOR
			case '#hltprslqdprn':
        $lo_post = $this->co_reg->request->post;
        $lv_hltprslqdcod = '';
				$lo_lqdautmdl = $this->co_reg->load->model('hltprslqdaut');
				$lo_lqdmdl = $this->co_reg->load->model('hltprslqd');
				$lo_lqddocmdl = $this->co_reg->load->model('hltprslqddoc');
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
				$lo_prsmdl = $this->co_reg->load->model('hltprs');
        $lo_lnsmdl = $this->co_reg->load->model('hltprslns');
        
        // obtengo id(s) 
        if($lo_post['srcobjtyp']=='HLT_LQA'){
          $lv_hltprslqdcod = str_replace('|', chr(10), json_decode(html_entity_decode($lo_post['msgdat']), true)['hltprslqdcod']);
        }else{
          $lv_hltprslqdcod = $lo_post['srcobjcod'];
        }
        
        // obtengo docsts
        if($lo_post['srcobjtyp']=='HLT_LQA'){
          $lo_lqdautmdl->load(array('hltprslqdgrpcod'=>$lo_post['srcobjcod']), false);
          $lv_docsts = $lo_lqdautmdl->docsts;
        }else{
          $lo_lqdmdl->load(array('hltprslqdcod'=>$lo_post['srcobjcod']));
          $lv_docsts = $lo_lqdmdl->docsts;
        }

        // validaciones
        if ( $lv_docsts!='C' ) {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'Debe contabilizar el documento primero.') );
        } else if(!$lv_hltprslqdcod){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-2','errtxt'=>'Seleccione liquidaciones para imprimir.') );
        }
        
        // cargo liquidaciones individuales
       	$lv_prm = array('vewfldflt' => '[~fltrow~]l.hltprslqdcod'.chr(9).'IN'.chr(9).chr(9).$lv_hltprslqdcod.chr(9).chr(9),
                       'vewfldord' => 'l.hltprslqdcod');
        $lv_lqd_arr = $lo_lqdmdl->getList($lv_prm, null, null, false);
        
        // cargo posiciones de liquidaciones
       	$lv_prm = array('vewfldflt' => '[~fltrow~]ld.hltprslqdcod'.chr(9).'IN'.chr(9).chr(9).$lv_hltprslqdcod.chr(9).chr(9),
                       'vewfldord' => 'ld.hltprslqdcod, ld.hltprslqddoccodext');
        $lv_lqddoc_arr = $lo_lqddocmdl->getList($lv_prm);
                
        // cargo evoluciones
        $lv_evlcod = '';
        $lv_buycod = '';
        foreach($lv_lqddoc_arr as $lv_row){
          if($lv_row['refobjtyp'] == 'HLT_EVL'){
          	$lv_evlcod .= $lv_row['refobjcod001'].chr(10);
          }else if($lv_row['refobjtyp'] == 'BUY_EXP'){
            $lv_buycod .= $lv_row['refobjcod001'].chr(10);;
          }
          // todo: buscar novedades
        }
       	$lv_prm = array('vewfldflt' => '[~fltrow~]e.evlcod'.chr(9).'IN'.chr(9).chr(9).$lv_evlcod.chr(9).chr(9));
        $lv_evl_arr = $lo_evlmdl->getList($lv_prm, null, null, false);
        
        // cargo prestadores
        $lv_prscod = '';
        foreach($lv_lqd_arr as $lv_row){
          $lv_prscod .= $lv_row['prscod'].chr(10);
        }
       	$lv_prm = array('vewfldflt' => '[~fltrow~]p.prscod'.chr(9).'IN'.chr(9).chr(9).$lv_prscod.chr(9).chr(9));
        $lv_prs_arr = $lo_prsmdl->getList($lv_prm, null, null, false);
        
        //Cargo las novedades liquidadas
        $lv_prm = array('vewfldflt' => '[~fltrow~]d.hltprslqdcod'.chr(9).'IN'.chr(9).chr(9).$lv_hltprslqdcod.chr(9).chr(9),
                       'vewfldord' => 'd.hltprslqdcod');
        $lv_lns_arr = $lo_lnsmdl->getListQuota($lv_prm);
        $lv_lnsqtalst =[];
        foreach($lv_lns_arr as $row_lns){
          $lv_lnsqtalst[$row_lns['buyexpdoccod']]=$row_lns['hltlnsqta'];          
        }
        
        // agrega a cada liquidación los datos de posiciones y prestador
        $j=0;
        foreach($lv_lqd_arr as &$lv_lqd){
          $lv_lqd['lqddoc'] = array();
          $lv_hltprslqdcod = $lv_lqd['hltprslqdcod'];
          while($j < count($lv_lqddoc_arr) && $lv_hltprslqdcod == $lv_lqddoc_arr[$j]['hltprslqdcod']){
            
            // junta la posición de liquidación con la evolución
            if($lv_lqddoc_arr[$j]['refobjtyp'] == 'HLT_EVL'){
              foreach($lv_evl_arr as $lv_evl){
                if($lv_evl['evlcod'] == $lv_lqddoc_arr[$j]['refobjcod001']){
                  $lv_lqddoc_arr[$j] = array_merge($lv_lqddoc_arr[$j], $lv_evl);
                  break;
                }
              }
            }
            
            // añade la posición a la liquidación
            if($lv_lqd['hltprslqdcod'] == $lv_lqddoc_arr[$j]['hltprslqdcod']){
              $lv_lqddoc_arr[$j]['hltlnsqta']=$lv_lnsqtalst[$lv_lqddoc_arr[$j]['refobjcod002']]??'';
              array_push($lv_lqd['lqddoc'], $lv_lqddoc_arr[$j]);
            }
            
            $j++;
          }
          
          // añade prestador
          foreach($lv_prs_arr as $lv_prs){
            if($lv_prs['prscod'] == $lv_lqd['prscod']){
              $lv_lqd['prs'] = $lv_prs;
              break;
            }
          }
        }
        unset($lv_lqd);
        
        $lv_buffer = $this->co_reg->document->getView( 'zcutp1_hltprslqdfrm001', array('data'=>$lv_lqd_arr, 'actcod'=>$this->data['actcod']) );
				$this->co_reg->response->addHeader('Content-type:application/pdf');
        return $lv_buffer;
				break;
      
			// IMPRESION - EVOLUCION
			case '#hltpatevlprn':
			
				// obtengo el numero de evolucion 
				$lv_evlcod = (isset($this->co_reg->request->post['evlcod'])?$this->co_reg->request->post['evlcod']:$lp_prm['evlcod']);
				
				// cargo los modelos
				$lo_patevlmdl = $this->co_reg->load->model('hltpatevl');
				$lo_patmdl = $this->co_reg->load->model('hltpat');
				$lo_prsmdl = $this->co_reg->load->model('hltprs');
				$lo_plndtemdl = $this->co_reg->load->model('hltplndte');
				// obtengo la evolucion
				$lo_rssrv = $lo_patevlmdl->load( array('evlcod'=>$lv_evlcod),false );

        // Datos complementarios de la ficha de evolucion.
        if(($lo_patevlmdl->patcod??'')!=''){
          $lo_patmdl->load(array('patcod'=>$lo_patevlmdl->patcod), false);
        }
        if(($lo_patevlmdl->prscod??'')!=''){
          $lo_prsmdl->load(array('prscod'=>$lo_patevlmdl->prscod), false);
        }

        $lv_financiadortxt = '';
        $lv_evlcncmtvlst = array();
        $lv_cuscod = '';
        if(($lo_patevlmdl->plnid??'')!='' && ($lo_patevlmdl->plndteid??'')!=''){
          if($lo_plndtemdl->load(array('plnid'=>$lo_patevlmdl->plnid, 'plndteid'=>$lo_patevlmdl->plndteid))){
            $lv_cuscod = $lo_plndtemdl->cuscod??'';
            if(($lo_plndtemdl->custxt??'')!=''){
              $lv_financiadortxt = $lo_plndtemdl->custxt;
            }elseif($lv_cuscod!=''){
              $lo_cusmdl = $this->co_reg->load->model('slscus');
              if($lo_cusmdl->load(array('cuscod'=>$lv_cuscod), false)){
                $lv_financiadortxt = $lo_cusmdl->custxt??'';
              }
            }
          }
        }

        // Traduce motivos actuales e historicos. Se normalizan espacios y
        // mayusculas y se usa ALL como respaldo del listado del financiador.
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');
        if($lo_prmmdl->load(array('mdlcod'=>'EVLCNCMTVLST'))){
          $lv_evlcncmtvtxtlst = array();
          if($lv_cuscod!=''){
            $lv_evlcncmtvtxt = $this->co_reg->document->getTagValue($lo_prmmdl->mdlatrval001, 'CUS_'.$lv_cuscod);
            if($lv_evlcncmtvtxt!=''){
              $lv_evlcncmtvtxtlst[] = $lv_evlcncmtvtxt;
            }
          }
          $lv_evlcncmtvalltxt = $this->co_reg->document->getTagValue($lo_prmmdl->mdlatrval001, 'ALL');
          if($lv_evlcncmtvalltxt!=''){
            $lv_evlcncmtvtxtlst[] = $lv_evlcncmtvalltxt;
          }
          foreach($lv_evlcncmtvtxtlst as $lv_evlcncmtvtxt){
            foreach(explode(';', $lv_evlcncmtvtxt) as $lv_evlcncmtvrow){
              $lv_evlcncmtvdat = explode(',', $lv_evlcncmtvrow, 2);
              $lv_evlcncmtvcod = strtoupper(trim($lv_evlcncmtvdat[0]??''));
              if($lv_evlcncmtvcod!='' && !isset($lv_evlcncmtvlst[$lv_evlcncmtvcod])){
                $lv_evlcncmtvlst[$lv_evlcncmtvcod] = trim($lv_evlcncmtvdat[1]??$lv_evlcncmtvcod);
              }
            }
          }
        }
        
        /* archivos */  
        $lo_flemdl = $this->co_reg->load->model('grldatupl');
        $lv_prm = array('vewfldflt'=>'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																		 '[~fltrow~]ft.fletypcodext'.chr(9).'='.chr(9).chr(9).'HLTEVL'.chr(9).chr(9).
                        						 '[~fltrow~]f.flesrccod'.chr(9).'='.chr(9).chr(9).$lv_evlcod.chr(9).chr(9),
												'vewfldord'=>'f.flesrctyp, f.flesrccod, f.fleduedte DESC'
												);
				$lo_flers = $lo_flemdl->getList( $lv_prm );
        $lv_flelst = array();
        foreach($lo_flers as $lo_rowfle){
        	$lv_flelst[$lo_rowfle['flecod']]['fledata'] =array('flenme'=>$lo_rowfle['flenme'],'fletyp'=>$lo_rowfle['fletyp']);

          $lv_fleloc = '../files' . chr(47) . strtoupper($this->co_reg->sec->buscod);
          $lv_flebas = realpath($lv_fleloc);
          $lv_flelocful = ($lv_flebas===false?'':$lv_flebas . DIRECTORY_SEPARATOR . $lo_rowfle['flecod']. '.tmss');
          $lv_flelst[$lo_rowfle['flecod']]['flepth'] =$lv_flelocful;
        }
				
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' => $this->co_reg->sec,
												'doc' => $this->co_reg->document,
												'data' => $lo_patevlmdl,
                        'pat' => $lo_patmdl,
                        'prs' => $lo_prsmdl,
                        'financiadortxt' => $lv_financiadortxt,
                        'evlcncmtvlst' => $lv_evlcncmtvlst,
                        'fleslt' => $lv_flelst,
												'actcod' => $this->data['actcod']
												);
				$lv_buffer = 	$this->co_reg->load->view('zcutp1_hltpatevlpnt', $lv_prm);
				$this->co_reg->response->addHeader('Content-type:application/pdf'); 
				return $lv_buffer;
				break;
			
			// IMPRESION - REMITO
			case '#stkmovdocpnt':
				
				// obtengo datos del documento
				$lo_stkdocmdl = $this->co_reg->load->model('stkmovdoc');
				$lv_stkmovdoccod = (isset($this->co_reg->request->post['stkmovdoccod'])?$this->co_reg->request->post['stomovdoccod']:$lp_prm['stkmovdoccod']);
        $lo_stkdocmdl->load( array('stkmovdoccod'=>$lv_stkmovdoccod),false );
				
        // Obtengo los datos del contacto
        $lo_datcntmdl = $this->co_reg->load->model('grldatcnt');
				$lo_datcntmdl->load( array('cntcod'=>$lo_stkdocmdl->dstcntcod),false );
        $lo_stkdocmdl->dstcnt=$lo_datcntmdl;
        
        // Obtengo los datos del cliente
        $lo_cusmdl = $this->co_reg->load->model('slscus');
        $lo_cusmdl->load( array('cuscod'=>$lo_stkdocmdl->dstobjcod),false );
        $lo_stkdocmdl->dstcus=$lo_cusmdl;  
        
        // Obtengo la zona adrzon
        $lo_zonmdl = $this->co_reg->load->model('grldatzon');
        
        // Obtengo la direccion
        $lo_adrmdl = $this->co_reg->load->model('grldatadr');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]a.adrsrctyp '.chr(9).'='.chr(9).chr(9).$lo_stkdocmdl->dstobjtyp.chr(9).chr(9).
																			'[~fltrow~]a.adrsrccod '.chr(9).'='.chr(9).chr(9).$lo_stkdocmdl->dstobjcod.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_adrmdl->getList($lv_prm);
        if(count($lo_rs)>0){
          $lo_stkdocmdl->dstobjadrstr=$lo_rs[0]['adrstr'];
          $lo_stkdocmdl->dstobjadrstrnum=$lo_rs[0]['adrstrnum'];
          $lo_stkdocmdl->dstobjadrstrflr=$lo_rs[0]['adrstrflr'];
          $lo_stkdocmdl->dstobjadrstrunt=$lo_rs[0]['adrstrunt'];
          $lo_stkdocmdl->dstobjadrstrbld=$lo_rs[0]['adrstrbld'];
          $lo_stkdocmdl->dstobjlndregtxt=$lo_rs[0]['lndregtxt'];
          $lo_stkdocmdl->dstobjadrtwntxt=$lo_rs[0]['adrtwntxt'];
        }
        
        if ( $lo_stkdocmdl->docsts!='C' ) {
          return $this->co_reg->document->getJson ( array ('errtyp'=>'E', 'errcod'=>-11,'errtxt'=>'Debe contabilizar el documento para imprimir el Remito.'));
        } 
        $lv_prm = array('lang'  => $this->co_reg->language,
                        'input' => $this->co_reg->input,
                        'sec' => $this->co_reg->sec,
                        'doc' => $this->co_reg->document,
                        'data' => $lo_stkdocmdl,
                        'actcod' => $this->data['actcod']
                        );
        $lv_vewcod = isset($lp_prm['vewcus'])?$lp_prm['vewcus']:'zcutp1_stkmovdocpnt';
        $lv_buffer = 	$this->co_reg->load->view($lv_vewcod , $lv_prm);
        $this->co_reg->response->addHeader('Content-type:application/pdf'); 
        return $lv_buffer;
				break;	  
      
			// IMPRESION - HOJA DE PICKING
			case '#stkmovdocpck':
				// obtengo datos del documento
				$lo_stkdocmdl = $this->co_reg->load->model('stkmovdoc');
				$lo_matstk = $this->co_reg->load->model('stkmatstk');
				$lv_stkmovdoccod = (isset($this->co_reg->request->post['stkmovdoccod'])?$this->co_reg->request->post['stomovdoccod']:$lp_prm['stkmovdoccod']);
				$lo_stkdocmdl->load( array('stkmovdoccod'=>$lv_stkmovdoccod),false );
        $lo_matlst= array();
        
        $lv_data_sqlstm='';
        foreach ($lo_stkdocmdl->stkmovdocmat as $lv_row) {
          $lv_rejcod =$lv_row['sysdocrejcod']==''?'0':$lv_row['sysdocrejcod'];
          $lv_data_sqlstm.=$lv_row['matcod'].','.$lv_row['matusebch'].','.$lv_row['matbchcodext'].','.$lv_rejcod .'-' ;
          /* Material sujeto a lote o serie*/
          if((($lv_row['matusebch']=='1'&&$lv_row['matbchcodext']=='')||($lv_row['matuseser']=='1'&&$lv_row['matsercodext']=='')) && $lv_rejcod=='0'){
            if(!in_array( $lv_row['matcod'],$lo_matlst)){
              $lo_matlst[]=$lv_row['matcod'];	
            }
          }
        }

        $lv_prm = array('vewfldflt' =>'[~fltrow~]m.matcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lo_matlst).chr(9).chr(9),
                                     'vewfldord' => 'm.matcod');
        $lo_rsstk=$lo_matstk->getlist($lv_prm, null, null, false);

        if(count($lo_rsstk)>=1){
          return $this->co_reg->document->getJson(array('errtyp'=>'E', 'errcod'=>'-11','errtxt'=>'Debe realizar la determinacion de lotes, Nro de serie o en su defecto rechazarlo.'));
        }
        $lv_prm = array('lang'  => $this->co_reg->language,
                      'input' => $this->co_reg->input,
                      'sec' => $this->co_reg->sec,
                      'doc' => $this->co_reg->document,
                      'data' => $lo_stkdocmdl,
                      'datastk' => $lo_rsstk,
                      'actcod' => $this->data['actcod']
                      );
        $lv_buffer = 	$this->co_reg->load->view('zcutp1_stkmovdocpck', $lv_prm);
        $this->co_reg->response->addHeader('Content-type:application/pdf'); 
        return $lv_buffer;
				break;
 
			//    R E P O R T E    -    TMG 01    -    D A T O S 
      case '#tmgrpt01rpt':
        $lo_post = $this->co_reg->request->post;
	    	$lo_buyexpdoc = $this->co_reg->load->model('buyexp');
	    	$lo_buyexp = $this->co_reg->load->model('buyexp');
	    	$lo_ret=array();
        $lv_sqlstm=array();
 
	    	/*1- POSICIONES */
	    	/*1.1 FILTROS*/
				$lv_fltarrdoc = explode('[~fltrow~]',$lo_post['vewfldflt'] );
				for($i=count($lv_fltarrdoc)-1; $i>0; $i--){
					if(stripos('buyexpcod;impobjtxt;buyexpdocdte;buyexptyptxt;buyexpdoctot;',';'.explode(chr(9),$lv_fltarrdoc[$i])[0].';')===false){
						unset($lv_fltarrdoc[$i]);
					}else{
            $lv_fltarrdoc[$i] = str_replace('buyexpdoc','ed.buyexpdoc',$lv_fltarrdoc[$i]);
            $lv_fltarrdoc[$i] = str_replace('buyexptyptxt','et.buyexptyptxt',$lv_fltarrdoc[$i]);
            $lv_fltarrdoc[$i] = str_replace('buyexpdoctot','ed.buyexpdoctot',$lv_fltarrdoc[$i]);
            $lv_fltarrdoc[$i] = str_replace('buyexpcod','ed.buyexpcod',$lv_fltarrdoc[$i]);
          }
				}
				$lv_prmflt = array('vewfldflt' =>'[~fltrow~]ed.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9).
																			   (count($lv_fltarrdoc)>0?implode('[~fltrow~]',$lv_fltarrdoc):''),
													'vewfldord' => 'ed.buyexpcod desc,ed.buyexpdocdte desc',
													'vewmaxrec'=>$lo_post['vewmaxrec'],
													);


	    	$lo_rs_expdoc=$lo_buyexpdoc->getListDoc($lv_prmflt );
        $lv_sqlstm[]=$lo_buyexpdoc->getsysdata('sqlstm');
        
        
	    	/*2- CABECERA */
	    	/*2.1 FILTROS*/

	    	$lv_cntfltexp = false;
				$lv_fltarrexp = explode('[~fltrow~]',$lo_post['vewfldflt'] );
				for($i=count($lv_fltarrexp)-1; $i>0; $i--){
					if(stripos(';buyexpcod;buyexpdte;buyexptxt;srcobjtxt;',';'.explode(chr(9),$lv_fltarrexp[$i])[0].';')===false){
						unset($lv_fltarrexp[$i]);
					}else{
				 		$lv_cntfltexp = true; 
            $lv_fltarrexp[$i] = str_replace('buyexpcod','e.buyexpcod',$lv_fltarrexp[$i]);
            $lv_fltarrexp[$i] = str_replace('buyexpdte','e.buyexpdte',$lv_fltarrexp[$i]);
            $lv_fltarrexp[$i] = str_replace('buyexptxt','e.buyexptxt',$lv_fltarrexp[$i]);

				 	}
				}

				$lv_prmflt = array('vewfldflt' =>'[~fltrow~]e.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9).
																			   (count($lv_fltarrexp)>0?implode('[~fltrow~]',$lv_fltarrexp):''),
																				 'vewfldord' => 'e.buyexpcod desc,e.buyexpdte desc');


	    	$lo_rs_exp=$lo_buyexp->getList($lv_prmflt, null, null, false);
        $lv_sqlstm[]=$lo_buyexp->getsysdata('sqlstm');
        /*LIQUIDACION*/
        $lo_lqddocmdl = $this->co_reg->load->model('hltprslqddoc');
        
        $lo_buydoclst= array();
        foreach ($lo_rs_expdoc as $lv_row) {
          if(!in_array( $lv_row['buyexpdoccod'],$lo_buydoclst)){
            $lo_buydoclst[]=$lv_row['buyexpdoccod'];	
          }

        }

        $lv_prmlqd = array('vewfldflt' =>'[~fltrow~]ld.refobjcod002'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lo_buydoclst).chr(9).chr(9).
                           								'[~fltrow~]ld.refobjtyp'.chr(9).'='.chr(9).chr(9).'BUY_EXP'.chr(9).chr(9),
                                     'vewfldord' => 'ld.refobjcod001');
        $lors_lqddocmdl= $lo_lqddocmdl->getList($lv_prmlqd);        
	    	
	    	/* POSICIONES DE GASTOS */
	    	foreach ($lo_rs_expdoc as $lv_row_doc) {
	    		$lo_doc = array();
	    		$lo_doc['buyexpdoccod']=$lv_row_doc['buyexpdoccod'];
	    		$lo_doc['buyexpdocdte']=$lv_row_doc['buyexpdocdte']->format('d/m/Y');
	    		$lo_doc['buyexptyptxt']=$lv_row_doc['buyexptyptxt'];
	    		$lo_doc['buyexpdoctot']=$lv_row_doc['buyexpdoctot'];
	    		$lo_doc['impobjtxt']=$lv_row_doc['impobjtxt'];
          $lo_doc['buyexpdocnum']='';
	    		/*CABECERA DE GASTO*/ 
	    		$lv_foundexp = false;
	    		foreach ($lo_rs_exp as $lv_row_exp) {
	    			if($lv_row_doc['buyexpcod']==$lv_row_exp['buyexpcod']){
	    				$lo_doc['buyexpcod']=$lv_row_exp['buyexpcod'];
	    				$lo_doc['buyexptxt']=$lv_row_exp['buyexptxt'];
	    				$lo_doc['buyexpdte']=$lv_row_exp['buyexpdte']->format('d/m/Y');
	    				$lo_doc['sysdocclstxt']=$lv_row_exp['sysdocclstxt'];
	    				$lo_doc['srcobjtyp']=$lv_row_exp['srcobjtyp'];
	    				$lo_doc['objtyptxt']=$lv_row_exp['objtyptxt'];
	    				$lo_doc['srcobjcod']=$lv_row_exp['srcobjcod'];
	    				$lo_doc['srcobjtxt']=$lv_row_exp['srcobjtxt'];
	    				$lv_foundexp = true;
	    			}
	    		}
          
          foreach ($lors_lqddocmdl as $lv_row_lqd) {
	    			if($lv_row_doc['buyexpdoccod']==$lv_row_lqd['refobjcod002']){
              $lo_doc['buyexpdocnum']=$lv_row_lqd['hltprslqdcod'];
	    			}
	    		}
          
          if($lo_doc['buyexpdocnum']==''){ continue; }
	    		if($lv_cntfltexp==true && $lv_foundexp==false) {  continue; }

	    		$lo_ret[]= $lo_doc;
	    	}
        return $lo_ret; 
	    	break;
      
			//    R E P O R T E    -    TMG  01
			case '#tmgrpt01':
				$lv_prm = array('lang' 	=> $this->co_reg->language,
													'input' => $this->co_reg->input,
													'sec' 	=> $this->co_reg->sec,
													'load'  => $this->co_reg->load,
													'data' => array(),
													'actcod'=> $this->data['actcod']
													//,'model' => self::MODEL
													);
					$lv_buffer = 	$this->co_reg->load->view('zcutp1_tmgrpt01', $lv_prm);
					return $lv_buffer;
	    	break;
      
	    //    R E P O R T E    -    TMG 01    -    D A T O S 
	    case '#tmgrpt01dat':
	    	$lo_post = $this->co_reg->request->post;
	    	$lo_buyexpdoc = $this->co_reg->load->model('buyexp');
	    	$lo_buyexp = $this->co_reg->load->model('buyexp');
	    	$lo_ret=array();

	    	/*1- POSICIONES */
	    	/*1.1 FILTROS*/
				$lv_fltarrdoc = explode('[~fltrow~]',$lo_post['vewfldflt'] );
				for($i=count($lv_fltarrdoc)-1; $i>0; $i--){
					if(stripos(';ed.buyexpdoc;impobjtxt;ed.buyexpdocdte;et.buyexptyptxt;ed.buyexpdoctot;',';'.explode(chr(9),$lv_fltarrdoc[$i])[0].';')===false){
						unset($lv_fltarrdoc[$i]);
					}
				}
				$lv_prmflt = array('vewfldflt' =>'[~fltrow~]ed.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9).
																			   (count($lv_fltarrdoc)>0?implode('[~fltrow~]',$lv_fltarrdoc):''),
													'vewfldord' => 'ed.buyexpcod desc,ed.buyexpdocdte desc',
													'vewmaxrec'=>$lo_post['vewmaxrec'],
													);


	    	$lo_rs_expdoc=$lo_buyexpdoc->getListDoc($lv_prmflt ); 

	    	/*2- CABECERA */
	    	/*2.1 FILTROS*/

	    	$lv_cntfltexp = false;
				$lv_fltarrexp = explode('[~fltrow~]',$lo_post['vewfldflt'] );
				for($i=count($lv_fltarrexp)-1; $i>0; $i--){
					if(stripos(';e.buyexpcod;e.buyexpdte;e.buyexptxt;srcobjtxt;',';'.explode(chr(9),$lv_fltarrexp[$i])[0].';')===false){
						unset($lv_fltarrexp[$i]);
					}else{
				 		$lv_cntfltexp = true; 

				 	}
				}

				$lv_prmflt = array('vewfldflt' =>'[~fltrow~]e.docsts'.chr(9).'<>'.chr(9).chr(9).'I'.chr(9).chr(9).
																			   (count($lv_fltarrexp)>0?implode('[~fltrow~]',$lv_fltarrexp):''),
																				 'vewfldord' => 'e.buyexpcod desc,e.buyexpdte desc');


	    	$lo_rs_exp=$lo_buyexp->getList($lv_prmflt, null, null, false);
	    	
	    	/* POSICIONES DE GASTOS */
	    	foreach ($lo_rs_expdoc as $lv_row_doc) {
	    		$lo_doc = array();
	    		$lo_doc['buyexpdoccod']=$lv_row_doc['buyexpdoccod'];
	    		$lo_doc['buyexpdocdte']=$lv_row_doc['buyexpdocdte']->format('d/m/Y');
	    		$lo_doc['buyexptyptxt']=$lv_row_doc['buyexptyptxt'];
	    		$lo_doc['buyexpdoctot']=$lv_row_doc['buyexpdoctot'];
	    		$lo_doc['impobjtxt']=$lv_row_doc['impobjtxt'];
	    		/*CABECERA DE GASTO*/
	    		$lv_foundexp = false;
	    		foreach ($lo_rs_exp as $lv_row_exp) {
	    			if($lv_row_doc['buyexpcod']==$lv_row_exp['buyexpcod']){
	    				$lo_doc['buyexpcod']=$lv_row_exp['buyexpcod'];
	    				$lo_doc['buyexptxt']=$lv_row_exp['buyexptxt'];
	    				$lo_doc['buyexpdte']=$lv_row_exp['buyexpdte']->format('d/m/Y');
	    				$lo_doc['sysdocclstxt']=$lv_row_exp['sysdocclstxt'];
	    				$lo_doc['srcobjtyp']=$lv_row_exp['srcobjtyp'];
	    				$lo_doc['objtyptxt']=$lv_row_exp['objtyptxt'];
	    				$lo_doc['srcobjcod']=$lv_row_exp['srcobjcod'];
	    				$lo_doc['srcobjtxt']=$lv_row_exp['srcobjtxt'];
	    				$lv_foundexp = true;
	    			}
	    		}

	    		if($lv_cntfltexp==true && $lv_foundexp==false) { 
						continue;
					}

	    		$lo_ret[]= $lo_doc;
	    	} 

        return $this->co_reg->document->getJson( array('datalst'=>$lo_ret) );
	    	break;
        
      case '#lqdtotxtsantot':
        $lv_flenme = 'BSPAGOS_'.date("YmdHis"); 
        $lv_lqdlstjsn = (isset($this->co_reg->request->post['lqdlst'])?$this->co_reg->request->post['lqdlst']:$lp_prm['lqdlst']);
        
        $lv_lqdlstjsn= html_entity_decode($lv_lqdlstjsn);
				$lv_lqdlst = json_decode($lv_lqdlstjsn,true);
        if(count($lv_lqdlst)<=0){
	        return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'NO EXISTEN LIQUIDACIONES SELECCIONAS') );
        }
        
        /* Buscamos las liquidaciones */
        $lo_prslqdmdl = $this->co_reg->load->model('hltprslqd');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]l.hltprslqdcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lv_lqdlst).chr(9).chr(9).
                                      '[~fltrow~]l.docsts'.chr(9).'='.chr(9).chr(9).'C'.chr(9).chr(9) );
        $lo_rslqd = $lo_prslqdmdl->getList( $lv_prm, null, null, false );
        
        $lv_buffer='';
        $lv_buffer='<TABLE style="border: #000000 1px solid;">';
        $lv_buffer.='<tr><td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">ID</td>';
        $lv_buffer.='<td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">Fecha</td>';
        $lv_buffer.='<td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">Descripcion</td>';
        $lv_buffer.='<td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">Prestador</td>';
        $lv_buffer.='<td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">Total</td></tr>';
        
        foreach( $lo_rslqd as $lv_row ) {
          $lv_buffer.='<tr>';
          $lv_buffer.='<td>'.$lv_row['hltprslqdcod'].'</td>';
          $lv_buffer.='<td>'.$lv_row['hltprslqddtecnv'].'</td>';
          $lv_buffer.='<td>'.$lv_row['hltprslqdtxt'].'</td>';
          $lv_buffer.='<td>'.$lv_row['prstxt'].'</td>';
          $lv_buffer.='<td>'.$lv_row['hltprslqdtot'].'</td>';
          $lv_buffer.='</tr>';
        
        }
        $lv_buffer.='</table>';
        
        $this->co_reg->response->addHeader('Content-Disposition: attachment; filename='.$lv_flenme.'.xls');
				$this->co_reg->response->addHeader('Content-Type: text/plain');
        return $lv_buffer ;
        break;
        
      //TXT SANTANDER
	    case '#lqdtotxtsan':
        //https://temasis.com.ar/sysdev/tmssOnLine/index.php?prg=zcutp1&act=lqdtotxtsan
        $lo_acvlst = array('01'=>array('paytercod'=>'50','bnktxt'=>'BANCO SANTANDER RIO S.A.'),
                        	 '02'=>array('paytercod'=>'57','bnktxt'=>''));

        /*OBTENGO LAS LIQUIDACIONES EN JSON Y LAS CONVIERTO A ARRAY */
        $lv_lqdlstjsn = (isset($this->co_reg->request->post['lqdlst'])?$this->co_reg->request->post['lqdlst']:$lp_prm['lqdlst']);
        $lv_acccod = (isset($this->co_reg->request->post['acccod'])?$this->co_reg->request->post['acccod']:$lp_prm['acccod']);

        $lv_flenme = 'BSPAGOS_'.$lv_acccod.'_'.date("YmdHis"); 
        
        $lv_lqdlstjsn= html_entity_decode($lv_lqdlstjsn);
				$lv_lqdlst = json_decode($lv_lqdlstjsn,true);
        
        $lv_header='<h01><h02><h03><h04><h05><h06><h07><h08><h09>';
        $lv_det='<d01><d02><d03><d04><d05><d06><d07><d08><d09><d10><d11><d12><d13><d14><d15><d16><d17><d18><d19><d20><d21><d22><d23><d24><d25><d26><d27><d28><d29><d30><d31><d32><d33><d34><d35><d36><d37><d38><d39><d40><d41><d42><d43><d44><d45><d46>';
        $lv_trailer='<t01><t02><t03><t04><t05>';
        
        // Buscamos el rango de numeracion
          $lo_rngmdl = $this->co_reg->load->model('grldatdocrng');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]docrngcodext'.chr(9).''.chr(9).'SECSAN'.chr(9).chr(9).chr(9).
                                        '[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                        );
          $lv_rngarr = $lo_rngmdl->getList( $lv_prm );
          $lv_sqlstmlst[]=$lo_rngmdl->getsysdata('sqlstm');
          if ( count($lv_rngarr)==1 ) {											
            $lv_docrngcod = $lv_rngarr[0]['docrngcod'];
          } else {
            return 'ERROR';
          }
          $lo_docrngarr=array();
          if ( $lo_rngmdl->load( array('docrngcod'=>$lv_docrngcod) ) ) {
            $lo_docrngarr['docrngcod']=$lo_rngmdl->docrngcod;
            $lo_docrngarr['docrngcodext']=$lo_rngmdl->docrngcodext;
            $lo_docrngarr['docrngtxt']=$lo_rngmdl->docrngtxt;
            $lo_docrngarr['objtypcod']=$lo_rngmdl->objtypcod;
            $lo_docrngarr['docrngstrnum']=$lo_rngmdl->docrngstrnum;
            $lo_docrngarr['docrngendnum']=$lo_rngmdl->docrngendnum ;
            $lo_docrngarr['docrngcurnum']=$lo_rngmdl->docrngcurnum+ 1;
            $lo_docrngarr['docrngatr']=$lo_rngmdl->docrngatr;
            $lo_docrngarr['docsts']=$lo_rngmdl->docsts;
            $lo_rngmdl->save($lo_docrngarr);
            $lo_docrngarr['docrngcurnum']=$lo_rngmdl->docrngcurnum;
          } else {
            return 'No se pudieron cargar los datos de la clase de documento.';
          }
        
        /* Buscamos las liquidaciones */
        $lo_prslqdmdl = $this->co_reg->load->model('hltprslqd');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]l.hltprslqdcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lv_lqdlst).chr(9).chr(9).
                                      '[~fltrow~]l.docsts'.chr(9).'='.chr(9).chr(9).'C'.chr(9).chr(9) );
        $lo_rslqd = $lo_prslqdmdl->getList( $lv_prm, null, null, false );
        
        $lv_prslst=array();
        foreach($lo_rslqd as $lo_rowlqd){
        	if(!in_array( $lo_rowlqd['prscod'],$lv_prslst)){
            $lv_prslst[]=$lo_rowlqd['prscod'];	
          }
        }
        
        /* Buscamos impuestos */
        $lo_taxmdl = $this->co_reg->load->model('grldattax');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]t.taxsrccod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lv_prslst).chr(9).chr(9).
                                      '[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
          														'[~fltrow~]t.taxsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_PRS'.chr(9).chr(9) );
        $lo_rstax = $lo_taxmdl->getList( $lv_prm );
        $lv_taxlst=array();
        foreach($lo_rstax as $lo_rowtax){
          $lv_taxlst[$lo_rowtax['taxsrccod']]['taxdocnum']=$lo_rowtax['taxdocnum'];
        }
        
        /* Buscamos bancos */
        $lo_bnkmdl = $this->co_reg->load->model('grldatbnk');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]b.bnksrccod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lv_prslst).chr(9).chr(9).
                                      //'[~fltrow~]b.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
          														'[~fltrow~]b.bnksrctyp'.chr(9).'='.chr(9).chr(9).'HLT_PRS'.chr(9).chr(9) );
        $lo_rsbnk = $lo_bnkmdl->getList( $lv_prm );
        $lv_sqlstmlst[]=$lo_bnkmdl->getsysdata('sqlstm');
        $lv_bnklst=array();
        foreach($lo_rsbnk as $lo_rowbnk){
          $lv_bnklst[$lo_rowbnk['bnksrccod']]['bnkacccbu']=$lo_rowbnk['bnkacccbu'];
          $lv_bnklst[$lo_rowbnk['bnksrccod']]['paymthtxt']=$lo_rowbnk['paymthtxt'];
          $lv_bnklst[$lo_rowbnk['bnksrccod']]['bnktxt']=$lo_rowbnk['bnktxt'];
        }
        $lo_rs_lqdlst=array();

        // Dividimos las liquidaciones por banco
        foreach ($lo_rslqd as $lo_rowlqd) {
        	$lv_prsbnktxt= $lv_bnklst[$lo_rowlqd['prscod']]['bnktxt'];
        	$lv_prsbnktxt= ($lv_acccod=='02'&&$lv_prsbnktxt!='BANCO SANTANDER RIO S.A.')?'':$lv_prsbnktxt;
					$lv_paytercod=$lo_acvlst[$lv_acccod]['paytercod'];
        	if($lv_prsbnktxt==$lo_acvlst[$lv_acccod]['bnktxt']){
            $lo_rs_lqdlst[]=$lo_rowlqd;
        	}
        }
        
        $lv_agmt='02';
        $lv_agmt=$lv_acccod;
        
        $lo_hederlst=array('h01'=>'H',
                           'h2.1'=>str_pad('33714702659', 11  , ' ', STR_PAD_LEFT),
                           'h2.2'=>'0',
                           'h2.3'=>'010',
                           'h2.4'=>$lv_agmt,//'02',
                           'h03'=>'007',
                           'h04'=>str_pad($lo_docrngarr['docrngcurnum'], 5  , '0', STR_PAD_LEFT),
                           'h05'=>str_pad('' , 5  , '0', STR_PAD_LEFT),
                           'h06'=>str_pad('' , 2  , ' ', STR_PAD_LEFT),
                           'h07'=>str_pad('' , 5  , ' ', STR_PAD_LEFT),
                           'h08'=>'S',
                           'h09'=>str_pad('' , 611, ' ', STR_PAD_LEFT)
                           );     
        $lo_hederlst['h02']=$lo_hederlst['h2.1'].$lo_hederlst['h2.2'].$lo_hederlst['h2.3'].$lo_hederlst['h2.4'];
        
        $lv_header=str_replace("<h01>", $lo_hederlst['h01'], $lv_header);		$lv_header=str_replace("<h02>", $lo_hederlst['h02'], $lv_header);
        $lv_header=str_replace("<h03>", $lo_hederlst['h03'], $lv_header);		$lv_header=str_replace("<h04>", $lo_hederlst['h04'], $lv_header);
        $lv_header=str_replace("<h05>", $lo_hederlst['h05'], $lv_header);		$lv_header=str_replace("<h06>", $lo_hederlst['h06'], $lv_header);
        $lv_header=str_replace("<h07>", $lo_hederlst['h07'], $lv_header);		$lv_header=str_replace("<h08>", $lo_hederlst['h08'], $lv_header);
        $lv_header=str_replace("<h09>", $lo_hederlst['h09'], $lv_header);        
        $lv_buffer='';
        $lv_buffer.= $lv_header.chr(13).chr(10);
        
        $lv_cbu='';
        $lv_dte = new DateTime();
        $lv_dtetxt=$lv_dte->format('Ymd');//20212101
        
        
        $lv_tot=0;
        //foreach( $lo_rslqd as $lv_row ) {
        foreach( $lo_rs_lqdlst as $lv_row ) {
          $lv_detaux= $lv_det;
          //$lv_cbu='0270020520003558770010';
          $lv_cbu=$lv_bnklst[$lv_row['prscod']]['bnkacccbu'];
          $lv_cbusan='0'.substr($lv_cbu,0,8).'000'.substr($lv_cbu,8,14);
          
          //$lv_cuit='20256540313';
          $lv_cuit=$lv_taxlst[$lv_row['prscod']]['taxdocnum'];
          $lv_cuitsan=$lv_cuit;
          
          $lv_lqdtot='';
          $lv_lqdtot = bcdiv($lv_row['hltprslqdtot'], '1', 2);
          $lv_lqdtot =$result = str_replace(array( ",", "."), '', $lv_lqdtot); 
          $lo_det = array('d01'=>'D',															 													// 1
                          'd02'=>str_pad('', 1, ' ', STR_PAD_LEFT),													// 1
                          'd03'=>'0',															 													// 1
                          'd04'=>str_pad(substr($lv_row['prscod'],0,15), 15, ' ', STR_PAD_RIGHT),				// 15
                          'd05'=>'OP',																											// 2
                          'd06'=>str_pad($lv_row['hltprslqdcod'], 15, ' ', STR_PAD_RIGHT),	// 15
                          'd07'=>str_pad('', 4, '0', STR_PAD_LEFT),													// 4
                          'd08'=>str_pad(substr($lv_row['prstxt'], 0, 30), 30, ' ', STR_PAD_RIGHT),				// 30
                          'd09'=>str_pad('', 30, ' ', STR_PAD_LEFT),												// 30
                          'd10'=>str_pad('', 20, ' ', STR_PAD_RIGHT),												// 20
                          'd11'=>str_pad('',1, ' ', STR_PAD_LEFT),													// 1
                          'd12'=>str_pad('01000', 5, ' ', STR_PAD_LEFT),										// 5
                          'd13'=>str_pad('',3, ' ', STR_PAD_LEFT),													// 3
                          'd14'=>str_pad('', 1, ' ', STR_PAD_LEFT),													// 1
                          'd15'=>str_pad('', 83, '0', STR_PAD_LEFT),												// 83
                          'd16'=>str_pad('',11, ' ', STR_PAD_LEFT),													// 11
                          'd17'=>$lv_cuitsan,//CUIT																				// 11
                          'd18'=>str_pad('', 45, ' ', STR_PAD_LEFT),												// 45
                          'd19'=>str_pad('', 18, ' ', STR_PAD_LEFT),												// 18
                          'd20'=>str_pad('', 15, ' ', STR_PAD_LEFT),												// 15
                          'd21'=>str_pad('', 15, ' ', STR_PAD_LEFT),												// 15
                          'd22'=>str_pad('', 60, ' ', STR_PAD_LEFT),												// 60
                          'd23'=>'001',//??																									// 3
                          'd24'=>'001',//??																									// 3
                          'd25'=>str_pad('', 3, ' ', STR_PAD_LEFT),                           // 3
                          'd26'=>'N',//??																										// 1
                          'd27'=>'0054',																										// 4
                          //'d28'=>str_pad('0'.substr($lv_cbu,0,8).'000'.substr($lv_cbu,9,14), 26, '0', STR_PAD_RIGHT	),// 26
                          'd28'=>$lv_cbusan,																								// 26
                          'd29'=>$lv_dtetxt,																								// 8 str_pad('', 60, ' ', STR_PAD_LEFT),
                          'd30'=>$lv_dtetxt,																								// 8
                          'd31'=>str_pad($lv_lqdtot, 15, '0', STR_PAD_LEFT),								// 15 //Importe
                          'd32'=>$lv_paytercod,//'57',//?																		// 2
                          'd33'=>str_pad('', 3, ' ', STR_PAD_LEFT),										      // 3
                          'd34'=>str_pad('', 11, '0', STR_PAD_LEFT),												// 11
                          'd35'=>str_pad('', 3, ' ', STR_PAD_LEFT),													// 3
                          'd36'=>str_pad('', 11, '0', STR_PAD_LEFT),												// 11
                          'd37'=>str_pad('', 3, ' ', STR_PAD_LEFT),													// 3
                          'd38'=>str_pad('', 11, '0', STR_PAD_LEFT),												// 11
                          'd39'=>'003',																											// 3
                          'd40'=>str_pad($lv_row['hltprslqdcod'], 19, ' ', STR_PAD_LEFT),		// 19
                          'd41'=>str_pad('0', 1, '0', STR_PAD_LEFT),												// 1
                          'd42'=>str_pad('0', 3, '0', STR_PAD_LEFT),												// 3
                          'd43'=>str_pad('0', 2, '0', STR_PAD_LEFT),												// 2
                          'd44'=>str_pad('', 1, ' ', STR_PAD_LEFT),													// 1
                          'd45'=>str_pad('', 60, ' ', STR_PAD_LEFT),		// 60
                          'd46'=>str_pad('', 59, ' ', STR_PAD_LEFT)													// 59
                          );
          
          $lv_detaux=str_replace("<d01>", $lo_det['d01'], $lv_detaux);	$lv_detaux=str_replace("<d02>", $lo_det['d02'], $lv_detaux);	
          $lv_detaux=str_replace("<d03>", $lo_det['d03'], $lv_detaux);	$lv_detaux=str_replace("<d04>", $lo_det['d04'], $lv_detaux);	
          $lv_detaux=str_replace("<d05>", $lo_det['d05'], $lv_detaux);	$lv_detaux=str_replace("<d06>", $lo_det['d06'], $lv_detaux);	
          $lv_detaux=str_replace("<d07>", $lo_det['d07'], $lv_detaux);	$lv_detaux=str_replace("<d08>", $lo_det['d08'], $lv_detaux);
          $lv_detaux=str_replace("<d09>", $lo_det['d09'], $lv_detaux);	$lv_detaux=str_replace("<d10>", $lo_det['d10'], $lv_detaux);	
          $lv_detaux=str_replace("<d11>", $lo_det['d11'], $lv_detaux);	$lv_detaux=str_replace("<d12>", $lo_det['d12'], $lv_detaux);	
          $lv_detaux=str_replace("<d13>", $lo_det['d13'], $lv_detaux);	$lv_detaux=str_replace("<d14>", $lo_det['d14'], $lv_detaux);	
          $lv_detaux=str_replace("<d15>", $lo_det['d15'], $lv_detaux);	$lv_detaux=str_replace("<d16>", $lo_det['d16'], $lv_detaux);	
          $lv_detaux=str_replace("<d17>", $lo_det['d17'], $lv_detaux);	$lv_detaux=str_replace("<d18>", $lo_det['d18'], $lv_detaux);
          $lv_detaux=str_replace("<d19>", $lo_det['d19'], $lv_detaux);	$lv_detaux=str_replace("<d20>", $lo_det['d20'], $lv_detaux);	
          $lv_detaux=str_replace("<d21>", $lo_det['d21'], $lv_detaux);	$lv_detaux=str_replace("<d22>", $lo_det['d22'], $lv_detaux);	
          $lv_detaux=str_replace("<d23>", $lo_det['d23'], $lv_detaux);	$lv_detaux=str_replace("<d24>", $lo_det['d24'], $lv_detaux);	
          $lv_detaux=str_replace("<d25>", $lo_det['d25'], $lv_detaux);	$lv_detaux=str_replace("<d26>", $lo_det['d26'], $lv_detaux);	
          $lv_detaux=str_replace("<d27>", $lo_det['d27'], $lv_detaux);	$lv_detaux=str_replace("<d28>", $lo_det['d28'], $lv_detaux);
          $lv_detaux=str_replace("<d29>", $lo_det['d29'], $lv_detaux);	$lv_detaux=str_replace("<d30>", $lo_det['d30'], $lv_detaux);	
          $lv_detaux=str_replace("<d31>", $lo_det['d31'], $lv_detaux);	$lv_detaux=str_replace("<d32>", $lo_det['d32'], $lv_detaux);	
          $lv_detaux=str_replace("<d33>", $lo_det['d33'], $lv_detaux);	$lv_detaux=str_replace("<d34>", $lo_det['d34'], $lv_detaux);	
          $lv_detaux=str_replace("<d35>", $lo_det['d35'], $lv_detaux);	$lv_detaux=str_replace("<d36>", $lo_det['d36'], $lv_detaux);	
          $lv_detaux=str_replace("<d37>", $lo_det['d37'], $lv_detaux);	$lv_detaux=str_replace("<d38>", $lo_det['d38'], $lv_detaux);
          $lv_detaux=str_replace("<d39>", $lo_det['d39'], $lv_detaux);	$lv_detaux=str_replace("<d40>", $lo_det['d40'], $lv_detaux);	
          $lv_detaux=str_replace("<d41>", $lo_det['d41'], $lv_detaux);	$lv_detaux=str_replace("<d42>", $lo_det['d42'], $lv_detaux);	
          $lv_detaux=str_replace("<d43>", $lo_det['d43'], $lv_detaux);	$lv_detaux=str_replace("<d44>", $lo_det['d44'], $lv_detaux);		
          $lv_detaux=str_replace("<d45>", $lo_det['d45'], $lv_detaux);	$lv_detaux=str_replace("<d46>", $lo_det['d46'], $lv_detaux);	

          $lv_buffer.= $lv_detaux.chr(13).chr(10);
          $lv_tot+=$lv_row['hltprslqdtot'];
        }
        $lv_totstr='';
        $lv_totstr = bcdiv($lv_tot, '1', 2);
        $lv_totstr =$result = str_replace(array( ",", "."), '', $lv_totstr); 
        $lo_trailer = array('t01'=>'T',
                            't02'=>str_pad('', 15, '0', STR_PAD_LEFT),
                            't03'=>str_pad($lv_totstr, 15, '0', STR_PAD_LEFT),
                            't04'=>str_pad(count($lo_rs_lqdlst), 7, '0', STR_PAD_LEFT),
                            't05'=>str_pad('', 612, ' ', STR_PAD_LEFT)
                           );
        $lv_traaux= $lv_trailer;
        $lv_traaux=str_replace("<t01>", $lo_trailer['t01'], $lv_traaux);	
        $lv_traaux=str_replace("<t02>", $lo_trailer['t02'], $lv_traaux);	
        $lv_traaux=str_replace("<t03>", $lo_trailer['t03'], $lv_traaux);	
        $lv_traaux=str_replace("<t04>", $lo_trailer['t04'], $lv_traaux);
        $lv_traaux=str_replace("<t05>", $lo_trailer['t05'], $lv_traaux);
        $lv_buffer .= $lv_traaux.chr(13).chr(10);
        $this->co_reg->response->addHeader('Content-Disposition: attachment; filename='.$lv_flenme.'.txt');
				$this->co_reg->response->addHeader('Content-Type: text/plain');
        return $lv_buffer ;
        break;
				
			
      //Imprecion de evoluciones desde el reporte
	    case '#tpeevlpntbchrpt':     
        $lo_post = $this->co_reg->request->post;
        
        /*Obtengo los parametros de empresa*/
        $lo_appprmmdl = $this->co_reg->load->model('sysappmdlprm');
        if ( $lo_appprmmdl->load(array('mdlcod'=>'TPEVLPRNBL')) == false ) {
          $lv_buffer = '-100: NO EXISTE PARAMENTOR DE EMPRESA CON EL CODIGO "TPEVLPRNBL"';
					return $lv_buffer;
          break;
        }
        $lv_dtestr = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'dtestr');							// Fecha desde $lo_dtestr = date("Y-m-d", strtotime($lv_dtestr));
       	$lv_dteend = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'dteend'); 							// Fecha hasta $lo_dteend = date("Y-m-d", strtotime($lv_dtestr));
        
        $lv_fltarr=[];
        $lv_fltarrdoc = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        $lo_dteper=array('dtestr'=>DateTime::createFromFormat('Y-m-d', $lv_dtestr)
                        ,'dteend'=>DateTime::createFromFormat('Y-m-d', $lv_dteend));
                         
				for($i=count($lv_fltarrdoc)-1; $i>0; $i--){
					if(stripos(';evldte;',';'.explode(chr(9),$lv_fltarrdoc[$i])[0].';')===false){
						unset($lv_fltarrdoc[$i]);
					}else{
            $lv_fltsegaux = explode(chr(9),$lv_fltarrdoc[$i]);
            if ($lv_fltsegaux[1]=='BT'){
              $lo_dteper=array('dtestr'=>DateTime::createFromFormat('Y-m-d', $lv_fltsegaux[3])
                              ,'dteend'=>DateTime::createFromFormat('Y-m-d', $lv_fltsegaux[4]));     
              
            }
          }
				}
        
        /* Buscamos los Especialidades */
        $lo_spcmdl = $this->co_reg->load->model('hltspc');
        $lv_prmspc = array('vewfldflt' =>'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                           'vewfldord' => 'spccod'
													 );
        $lv_rsspc=$lo_spcmdl->getList($lv_prmspc);
        $lo_spclst=[];
        foreach($lv_rsspc as $lo_rowspc){
          $lv_pos = strpos(strtoupper($lo_rowspc['spcfrm']), 'PRM_EVLFRM');
          if ($lv_pos !== false) {
            $lv_evlfrm = substr($lo_rowspc['spcfrm'], $lv_pos+11);
          } else {
          	$lv_evlfrm ='';
          }
          
          $lo_spclst[$lo_rowspc['spccod']]=$lv_evlfrm;
        }   
        $lv_sqlstm[]=$lo_spcmdl->getSysData('sqlstm');
        
        /* Buscamos los pacientes */ 
        /* Filtro de pacientes */
        $lv_fltarrpat = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        for($i=count($lv_fltarrpat)-1; $i>0; $i--){
          if(stripos(';patcod;patcodext;pattxt;cuscod;custxt;',';'.explode(chr(9),$lv_fltarrpat[$i])[0].';')===false){
            unset($lv_fltarrpat[$i]);
          }else{ 
            $lv_fltarrpat[$i] = str_replace('patcod'   ,'p.patcod',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('patcodext','p.patcodext',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('pattxt'	 ,'p.pattxt',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('cuscod' ,'p.cuscod',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('custxt' ,'c.custxt',$lv_fltarrpat[$i]);
          }
        }
        
        $lo_patmdl = $this->co_reg->load->model('hltpat');
        $lv_prmpat = array('vewfldflt' =>'[~fltrow~]1'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9).
                           							 (count($lv_fltarrpat)>0?implode('[~fltrow~]',$lv_fltarrpat):''),
                           'vewfldord' => 'p.patcod'
													 );
        
        $lv_rspat=$lo_patmdl->getList($lv_prmpat, null, null, false);
        $lv_sqlstm[]=$lo_patmdl->getSysData('sqlstm');
        
        // Buscamos los Matriculas
        $lo_matmdl = $this->co_reg->load->model('hltprsspc');
        $lv_prmmat = array('vewfldflt' =>'[~fltrow~]ps.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                           'vewfldord' => 'p.prscod'
													 );
        
        $lv_rsmat=$lo_matmdl->getList($lv_prmmat, null, null, false);
        $lv_sqlstm[]=$lo_matmdl->getSysData('sqlstm');
        $lo_matlst=[];
        foreach($lv_rsmat as $lo_matrow){
          $lo_matlst[$lo_matrow['prscod'].'-'.$lo_matrow['spccod']]=$lo_matrow['prsspcatr'];
        }    
        
        // Buscamos las Evoluciones
        // Filtros de evoluciones
        $lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        for($i=count($lv_fltarrevl)-1; $i>0; $i--){
          if(explode(chr(9),$lv_fltarrevl[$i])[0]=='evldte'){
            $lv_fltarrevl[]=str_replace('evldte','pl.plndte',$lv_fltarrevl[$i]);
          }
          if(stripos(';c.custxt;c.cuscod;e.pattxt;e.patcod;e.evldtecnv;evlcod;prscod;prstxt;spccod;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
            unset($lv_fltarrevl[$i]);
          }else{
            
            //$lv_fltarrevl[$i] = str_replace('e.pattxt','p.pattxt',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('e.evldtecnv','e.evldte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('evlcod','e.evlcod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('prscod','e.prscod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('prstxt','e.prstxt',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('spccod','e.spccod',$lv_fltarrevl[$i]);            
          } 
        }
        
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
        $lv_prmevl = array('vewfldflt' =>'[~fltrow~]e.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                           							 '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                           							 '[~fltrow~]E.PLNDTEID IN (SELECT PLNDTEID FROM HLT_PLN_CTR_DTE cd  WHERE cd.DELDTE IS NULL and cd.docsts in (^A^,^C^)) '.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9).
                           							 (count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
													 'vewfldord' => 'e.patcod,e.spctxt,pl.plndte asc');
        $lv_rsevl=$lo_evlmdl->getList($lv_prmevl, null, null, false);
        $lv_evlpatlst=[];
        foreach($lv_rsevl as $lo_rowevl){
          $lv_patkey = $lo_rowevl['patcod'];
          if (!array_key_exists($lv_patkey,$lv_evlpatlst)) {
              $lv_evlpatlst[$lv_patkey]=[];
          }
          $lv_evlpatlst[$lv_patkey][]=$lo_rowevl;
        }
        $lv_sqlstm[]=$lo_evlmdl->getSysData('sqlstm');

        /* Obtengo las fechas */
        $lv_fltarrdte = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        function filtro($lp_val) {
          $lv_ret =true;
          if(stripos(';e.evldtecnv;',';'.explode(chr(9),$lp_val)[0].';')===false){
            $lv_ret =false;
          }
        	return $lv_ret;
        }
        $lv_fltdte = array_filter($lv_fltarrdte, 'filtro');
        
        // Preparo el pdf
				$lo_fle = $this->co_reg->load->model('grldatupl');
				$nombre_fichero_tmp = $lo_fle->createTempFile('evoluciones.tmp');
        $lo_zip = new ZipArchive();
        $lo_zip->open($nombre_fichero_tmp, ZipArchive::OVERWRITE);
        
        foreach($lv_rspat as $rowpat){
          $lv_patkey = $rowpat['patcod'];
          if(isset($lv_evlpatlst[$lv_patkey]) && count($lv_evlpatlst[$lv_patkey])>0){
            $lv_prm = array('lang'  => $this->co_reg->language,
                            'doc' => $this->co_reg->document,                          
                            'spclst'=>$lo_spclst,
                            'matlst'=>$lo_matlst,
                            'data'=>$rowpat,
                            'dteper'=>$lo_dteper,
                            'patevllst'=>$lv_evlpatlst[$lv_patkey]
                            );   
            $lv_buffer = 	$this->co_reg->load->view('zcutp1_tpeevlpnt', $lv_prm);
            // Agrego el pdf al archivo comprimido
            $lo_zip->addFromString($rowpat['pattxt'].'('.$rowpat['patcod'].').pdf', $lv_buffer);
          } 
        }
        // Cerrar y enviar zip
        $lo_zip->close();        
        header('Content-Type: application/zip');
        header('Content-Disposition: attachment; filename="'.'Evoluciones_'.date("YmdHis").'.zip"');
        readfile($nombre_fichero_tmp);
        break;
      
			
      //Imprecion de evoluciones desde cliente
	    case '#Ztpeevlpntbch':
        // Ejemplo: prg:zcueml Act:hhrlqdrecgrppnt
				// 
        //https://temasis.com.ar/sysdev/tmssOnLine/index.php?prg=zcutp1&act=tpeevlpntbch
        $lv_sqlstm=[];
        $lv_buffer='';
        
        /*Obtengo los parametros de empresa*/
        $lo_appprmmdl = $this->co_reg->load->model('sysappmdlprm');
        if ( $lo_appprmmdl->load(array('mdlcod'=>'TPEVLPRNBL')) == false ) {
          $lv_buffer = '-100: NO EXISTE PARAMENTOR DE EMPRESA CON EL CODIGO "TPEVLPRNBL"';
					return $lv_buffer;
          break;
        }
        $lv_dtestr = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'dtestr');							// Fecha desde $lo_dtestr = date("Y-m-d", strtotime($lv_dtestr));
       	$lv_dteend = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'dteend'); 							// Fecha hasta $lo_dteend = date("Y-m-d", strtotime($lv_dtestr));
        
        if($lv_dtestr =='' || $lv_dteend ==''){
          $lv_dtestr = (new DateTime('first day of last month'))->format('Y-m-d');
       		$lv_dteend = (new DateTime('last day of last month'))->format('Y-m-d'); 	
        }
        
        $lo_dteper=array('dtestr'=>DateTime::createFromFormat('Y-m-d', $lv_dtestr)
                        ,'dteend'=>DateTime::createFromFormat('Y-m-d', $lv_dteend)
                        );
        
        /* Buscamos los pacientes */
        $lo_spcmdl = $this->co_reg->load->model('hltspc');
        $lv_prmspc = array('vewfldflt' =>'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                           'vewfldord' => 'spccod'
													 );
        $lv_rsspc=$lo_spcmdl->getList($lv_prmspc);
        $lo_spclst=[];
        foreach($lv_rsspc as $lo_rowspc){
          $lv_pos = strpos(strtoupper($lo_rowspc['spcfrm']), 'PRM_EVLFRM');
          if ($lv_pos !== false) {
            $lv_evlfrm = substr($lo_rowspc['spcfrm'], $lv_pos+11);
          } else {
          	$lv_evlfrm ='';
          }
          
          $lo_spclst[$lo_rowspc['spccod']]=$lv_evlfrm;
        }
        $lv_sqlstm[]=$lo_spcmdl->getSysData('sqlstm');
        
        /* Buscamos los pacientes */
        $lo_patmdl = $this->co_reg->load->model('hltpat');
        $lv_prmpat = array('vewfldflt' =>'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                           							 '[~fltrow~]p.cuscod'.chr(9).'='.chr(9).chr(9).$lp_prm['cuscod'].chr(9).chr(9),
                           'vewfldord' => 'p.patcod'
													 );
        $lv_rspat=$lo_patmdl->getList($lv_prmpat, null, null, false);
        $lv_sqlstm[]=$lo_patmdl->getSysData('sqlstm');
        
        /* Buscamos los Matriculas */
        $lo_matmdl = $this->co_reg->load->model('hltprsspc');
        $lv_prmmat = array('vewfldflt' =>'[~fltrow~]ps.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                           'vewfldord' => 'p.prscod'
													 );        
        $lv_rsmat=$lo_matmdl->getList($lv_prmmat, null, null, false);
        $lv_sqlstm[]=$lo_matmdl->getSysData('sqlstm');
        
        $lo_matlst=[];
        foreach($lv_rsmat as $lo_matrow){
          $lo_matlst[$lo_matrow['prscod'].'-'.$lo_matrow['spccod']]=$lo_matrow['prsspcatr'];
        }    
        
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
        $lv_prmevl = array('vewfldflt' =>'[~fltrow~]e.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                           							 '[~fltrow~]p.cuscod'.chr(9).'='.chr(9).chr(9).$lp_prm['cuscod'].chr(9).chr(9).
                           							 '[~fltrow~]pl.plndte'.chr(9).'BT'.chr(9).chr(9).$lv_dtestr.chr(9).$lv_dteend.chr(9),
													 'vewfldord' => 'e.patcod,e.spctxt,pl.plndte asc');
        $lv_rsevl=$lo_evlmdl->getList($lv_prmevl, null, null, false);
        
        $lv_sqlstm[]=$lo_evlmdl->getSysData('sqlstm');
        
        // Preparo el pdf
				$lo_fle = $this->co_reg->load->model('grldatupl');
				$nombre_fichero_tmp = $lo_fle->createTempFile('evoluciones.tmp');
        $lo_zip = new ZipArchive();
        $lo_zip->open($nombre_fichero_tmp, ZipArchive::OVERWRITE);
        
        foreach($lv_rspat as $rowpat){
          $lv_prm = array('lang'  => $this->co_reg->language,
                          'doc' => $this->co_reg->document,                          
                          'spclst'=>$lo_spclst,
                          'matlst'=>$lo_matlst,
                          'data'=>$rowpat,
                          'dteper'=>$lo_dteper,
                          'patevllst'=>$lv_rsevl
                          );   
          $lv_buffer = 	$this->co_reg->load->view('zcutp1_tpeevlpnt', $lv_prm);
          // Agrego el pdf al archivo comprimido
          $lo_zip->addFromString(($rowpat['pattxt']??'nn').'('.($rowpat['patcod']??'9999').').pdf', $lv_buffer);
          
        }
        // Cerrar y enviar zip
        $lo_zip->close();
        header('Content-Type: application/zip');
        header('Content-Disposition: attachment; filename="Evoluciones.zip"');
        readfile($nombre_fichero_tmp);
        break;
			
      //  R E P O R T E S   D E   L I Q U I D A C I O N E S   D E T A L L A D O
      case '#tpelqdrpt':
        $lo_post = $this->co_reg->request->post;
        $lo_hltlqd = $this->co_reg->load->model('hltprslqd');
        $lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );

        $lv_vewfldord = (isset($lo_post['vewfldord'])&&$lo_post['vewfldord']!='')?$lo_post['vewfldord']:'h.hltlqdcod desc';
        for($i=count($lv_fltarrevl)-1; $i>0; $i--){
          if(stripos(';hltlqdcod;patcodext;evldte;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
            unset($lv_fltarrevl[$i]);
          }else{
            $lv_fltarrevl[$i] = str_replace('hltlqdcod','h.hltlqdcod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('patcodext','a.patcodext',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('evldte','e.evldte',$lv_fltarrevl[$i]);
          }
        }

        $lv_prm = array('vewfldflt' =>'[~fltrow~]h.docsts'.chr(9).'IN'.chr(9).chr(9).'A'.chr(10).'C'.chr(9).chr(9).
                        (count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
                        'vewmaxrec'=>$lo_post['vewmaxrec'],
                        'vewfldord' => $lv_vewfldord
                       );
        $lo_rsevl = $lo_hltlqd->getList($lv_prm, null, null, false);
        foreach ($lo_rsevl as &$lv_row) {
          if ($lv_row['evldte'] != null) {
            $lv_row['evldte']=$lv_row['evldte']->format('d/m/Y');
          } 
          $lv_row['adrzon'] = ($lv_row['adrzoncod']!=0?$lv_row['adrzontxt']:$lv_row['adrzon']);
        }
        unset($lv_row);
        return $lo_rsevl;
        break;
			
			
      //   EVOLUCION - ESCLEROSIS - BORRAR
			case '#lqdbbvatxt':
        $lo_mdllqd = $this->co_reg->load->model('hltprslqd');
				$lo_post = $this->co_reg->request->post;
        $lv_data_sqlstm = array();
        $lv_lmtmem= ini_get('memory_limit');
        ini_set('memory_limit', '2048M'); 
        
        $lv_regqui= array('00'=>'01','01'=>'02',
                          '02'=>'03','03'=>'04',
                          '04'=>'05','05'=>'08',
                          '06'=>'10','07'=>'13',
                          '08'=>'12','09'=>'17',
                          '10'=>'18','11'=>'19',
                          '12'=>'21','13'=>'22',
                          '14'=>'23','16'=>'06',
                          '17'=>'07','18'=>'09',
                          '19'=>'14','20'=>'15',
                          '21'=>'11','22'=>'16',
                          '23'=>'20','24'=>'40');

        
        $lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        $lv_vewfldord = (isset($lo_post['vewfldord'])&&$lo_post['vewfldord']!='')?$lo_post['vewfldord']:'hltprslqddtecnv desc';
        $lv_vewfldord =str_replace('hltprslqddtecnv','l.hltprslqddte',$lv_vewfldord);
				for($i=count($lv_fltarrevl)-1; $i>0; $i--){
					if(stripos(';hltprslqdgrpcod;hltprslqdtxt;prscod;prstxt;hltprslqdcod;hltprslqddtecnv;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
						unset($lv_fltarrevl[$i]);
					}else{
            $lv_fltarrevl[$i] = str_replace('hltprslqddtecnv','l.hltprslqddte',$lv_fltarrevl[$i]);
          }
				}
        
				$lv_prmflt = array('vewfldflt' =>'[~fltrow~]l.docsts'.chr(9).'IN'.chr(9).chr(9).'A'.chr(10).'C'.chr(9).chr(9).
																			   (count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
													'vewmaxrec'=>$lo_post['vewmaxrec'],
                          'vewfldord' => $lv_vewfldord
												);
        $lo_rslqd = $lo_mdllqd->getList( $lv_prmflt, null, null, false);
        $lv_data_sqlstm[] = $lo_mdllqd->getsysdata('sqlstm');
        
        // IMPUESTOS
				// Filtros
				$lo_taxmdl = $this->co_reg->load->model('grldattax');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9). 'A'.chr(9).chr(9).
																			'[~fltrow~]t.taxsrctyp'.chr(9).'='.chr(9).chr(9). 'HLT_PRS'.chr(9).chr(9));
				$lo_rstax = $lo_taxmdl->getList($lv_prm);
				$lv_data_sqlstm[]= $lo_taxmdl->getsysdata('sqlstm');
        $lo_taxLst=array();
        foreach($lo_rstax as $lv_rowtax){
          $lo_taxLst[$lv_rowtax['taxsrccod']]=$lv_rowtax;
        }
        
        // DIRECCIONES
				// Filtros
				$lo_adrmdl = $this->co_reg->load->model('grldatadr');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9). 'A'.chr(9).chr(9).
																			'[~fltrow~]a.adrsrctyp'.chr(9).'='.chr(9).chr(9). 'HLT_PRS'.chr(9).chr(9));
				$lo_rsdir = $lo_adrmdl->getList($lv_prm);
				$lv_data_sqlstm[]= $lo_adrmdl->getsysdata('sqlstm');
        $lo_adrLst=array();
        foreach($lo_rsdir as $lv_rowadr){
          $lo_adrLst[$lv_rowadr['adrsrccod']]=$lv_rowadr;
        }
        
        // BANCO
				// Filtros
				$lo_mdlbnk = $this->co_reg->load->model('grldatbnk');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]b.docsts'.chr(9).'='.chr(9).chr(9). 'A'.chr(9).chr(9).
																			'[~fltrow~]b.bnksrctyp'.chr(9).'='.chr(9).chr(9). 'HLT_PRS'.chr(9).chr(9));
				$lo_rsbnk = $lo_mdlbnk->getList($lv_prm);
				$lv_data_sqlstm[]= $lo_mdlbnk->getsysdata('sqlstm');
        $lo_bnkLst=array();
        //print_r($lv_data_sqlstm);die;
        
        $lv_01='0306010CUIT00306992278930000000<IMPL>AB000<DTE><DTE><DTE>00170347670103014877<QTYROW20>            <FLENME><DTEEMI>00170347602700000134                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          ';
        $lv_20='0306020CUIT0030699227893<SEC><PRSCOD><OP><IMP>                                            0000000000000                                            <FLENME>           0000000000000                                        CUI<CUIT>0466<DTE><DTEPAY>  0000000000000000                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        ';
        $lv_90='0306090CUIT0030699227893<SEC><FLENME><PRSCOD>1CUI<CUIT><PRSTXT>   000000000000000<CBU>           <DIR>                                           <STECOD>080administracion@teampediatrico.com.ar                                                                                                                                                                          00000000                            00000000                            00000000                                                                                                    <OP>                                                                                                                                                                                                                         ';
        $lv_95='0306095CUIT0030699227893<SECARM><IMPTOT><QTY20><QTY2>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ';
        
        foreach($lo_rsbnk as $lv_rowbnk){
          $lo_bnkLst[$lv_rowbnk['bnksrccod']]=$lv_rowbnk;
        }
        $lv_count= 0;
        $lv_buflqdtxt='';
        $lo_row10cnf= array('impl'			=>array('val'=>floatval(0)				,'len'=>13,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                            'dte'				=>array('val'=>date("Ymd")				,'len'=>8,'padtyp'=>STR_PAD_LEFT,'padstr'=>' '),
                            //'qty'				=>array('val'=>count($lo_rslqd)*2	,'len'=>7,'padtyp'=>STR_PAD_LEFT,'padstr'=>' '),
                            'qtyrow20'	=>array('val'=>count($lo_rslqd)		,'len'=>7,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                            'flenme'		=>array('val'=>date("YmdHi")			,'len'=>12,'padtyp'=>STR_PAD_LEFT,'padstr'=>' '),
                            'dteemi'		=>array('val'=>date("Ymd")			,'len'=>8,'padtyp'=>STR_PAD_LEFT,'padstr'=>' ')
                           );
        
        $lo_row95cnf= array('secarm'			=>array('val'=>$lv_count					,'len'=>6,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                            'imptot'			=>array('val'=>floatval(0)				,'len'=>13,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                            'imptot'			=>array('val'=>floatval(0)				,'len'=>13,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                            'qty20'				=>array('val'=>count($lo_rslqd)		,'len'=>7,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                            'qty2'				=>array('val'=>0	,'len'=>10,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0')
                           );
        
        $lv_errlst='';
        $lv_exceltxt='<table style="border: #000000 1px solid;">';
        $lv_exceltxt.='<tr>';
        $lv_exceltxt.='<td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">'.'Codigo de prestador'.'</td><td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">'.'Nombre'.'</td><td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">'.'Total'.'</td>';
        $lv_exceltxt.='</tr>';
        $lo_prslst=[];
        foreach($lo_rslqd as $lv_row){
          $lv_errqty=0;
          $lv_count++;          
          $lv_row['hltprslqdtot']=number_format($lv_row['hltprslqdtot'], 2, ',', '');
          $lv_buf['taxcod001']='';
          if(isset($lo_taxLst[$lv_row['prscod']])){
            $lv_buf['taxcod001']=$lo_taxLst[$lv_row['prscod']]['taxdocnum'];
          }          
          
          $lv_buf['dircod001']='';
          if(isset($lo_dirLst[$lv_row['prscod']])){
            $lv_buf['dircod001']=$lo_dirLst[$lv_row['prscod']];
          }     
          
          $lv_buf['bnkcod001']='';
          if(isset($lo_bnkLst[$lv_row['prscod']])){
            $lv_buf['bnkcod001']=$lo_bnkLst[$lv_row['prscod']];
          }     
          if(!isset($lo_taxLst[$lv_row['prscod']])){
            $lv_errlst.='En la liquidacion #'.$lv_row['hltprslqdcod'].' al prestador #'.$lv_row['prscod'].' '.$lv_row['prstxt'].' le faltan datos de Impuestos' .chr(13);
            $lv_errqty++;
          }
          if(strlen(str_replace('-','',$lo_taxLst[$lv_row['prscod']]['taxcod']))!=11){
            $lv_errlst.='En la liquidacion #'.$lv_row['hltprslqdcod'].' el prestador #'.$lv_row['prscod'].' '.$lv_row['prstxt'].' tiene un cuit erroneo<'.strlen(str_replace('-','',$lo_taxLst[$lv_row['prscod']]['taxcod'])).'>' .chr(13);
            $lv_errqty++;            
          }
          if(!isset($lo_bnkLst[$lv_row['prscod']])){
            $lv_errlst.='En la liquidacion #'.$lv_row['hltprslqdcod'].' al prestador #'.$lv_row['prscod'].' '.$lv_row['prstxt'].' le faltan datos de Banco' .chr(13);
            $lv_errqty++;
          }
          
          if(!isset($lo_adrLst[$lv_row['prscod']])){
            $lv_errlst.='En la liquidacion #'.$lv_row['hltprslqdcod'].' al prestador #'.$lv_row['prscod'].' '.$lv_row['prstxt'].' le faltan datos de Direccion' .chr(13);
            $lv_errqty++;
          }
          if(!isset($lo_adrLst[$lv_row['prscod']]['lndregcod']) || !isset($lv_regqui[$lo_adrLst[$lv_row['prscod']]['lndregcod']]) ){
            $lv_errlst.='En la liquidacion #'.$lv_row['hltprslqdcod'].' el prestador #'.$lv_row['prscod'].' '.$lv_row['prstxt'].' no posee provincia' .chr(13);
            $lv_errqty++;
          }
          if($lv_errqty>0){
            continue;
          }
          
          $lo_row20cnf= array('sec'		=>array('val'=>$lv_count																	,'len'=>6,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                              'prscod'=>array('val'=>$lv_row['prscod']													,'len'=>15,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                              'op'		=>array('val'=>$lv_row['hltprslqdcod']										,'len'=>8,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                              'imp'		=>array('val'=>''																					,'len'=>13,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                              'flenme'=>array('val'=>$lo_row10cnf['flenme']['val']							,'len'=>15,'padtyp'=>STR_PAD_LEFT,'padstr'=>' '),
                              'cuit'	=>array('val'=>str_replace('-','',$lo_taxLst[$lv_row['prscod']]['taxcod'])	,'len'=>11,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                              'dte'		=>array('val'=>'00000000'																,'len'=>8,'padtyp'=>STR_PAD_LEFT,'padstr'=>' '),
                              'dtepay'=>array('val'=>'00000000'																,'len'=>8,'padtyp'=>STR_PAD_LEFT,'padstr'=>' ')
                             );
          $lv_count++;
          $lo_row90cnf= array('sec'		=>array('val'=>$lv_count																	 										,'len'=>6,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                              'flenme'=>array('val'=>$lo_row10cnf['flenme']['val']							 										,'len'=>15,'padtyp'=>STR_PAD_LEFT,'padstr'=>' '),
                              'prscod'=>array('val'=>$lv_row['prscod']													 										,'len'=>15,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                              'cuit'	=>array('val'=>str_replace('-','',$lo_taxLst[$lv_row['prscod']]['taxcod'])		 ,'len'=>11,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                              'prstxt'=>array('val'=>$lv_row['prstxt']													 										,'len'=>40,'padtyp'=>STR_PAD_RIGHT,'padstr'=>' '),
                              'cbu'		=>array('val'=>$lo_bnkLst[$lv_row['prscod']]['bnkacccbu']	 										,'len'=>22,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                              'dir'		=>array('val'=>$lo_adrLst[$lv_row['prscod']]['adrstr']		 										,'len'=>24,'padtyp'=>STR_PAD_RIGHT,'padstr'=>' '),
                              'op'		=>array('val'=>$lv_row['hltprslqdcod']										 										,'len'=>8,'padtyp'=>STR_PAD_LEFT,'padstr'=>'0'),
                              'stecod'=>array('val'=> $lv_regqui[$lo_adrLst[$lv_row['prscod']]['lndregcod']] 			,'len'=>2,'padtyp'=>STR_PAD_LEFT,'padstr'=>' ')
                             );
          $lv_totstr = str_replace(',','.',$lv_row['hltprslqdtot']);
          $lo_row20cnf['imp']['val'] = floatval($lv_totstr)*100;
          
          if(!isset($lo_prslst[$lv_row['prscod']])){
            $lo_prslst[$lv_row['prscod']]['prscod']=$lv_row['prscod'];
            $lo_prslst[$lv_row['prscod']]['prstxt']=$lv_row['prstxt'];
            $lo_prslst[$lv_row['prscod']]['lqdtot']=0;
          }
          $lo_prslst[$lv_row['prscod']]['lqdtot']+=$lv_totstr;
           $lo_row10cnf['impl']['val']+=$lo_row20cnf['imp']['val'];
          $lo_row95cnf['imptot']['val']=$lo_row10cnf['impl']['val'];
          $lv_20aux=$lv_20;
          foreach( $lo_row20cnf as $row_key => $row_val){
            $lv_tag='<'.strtoupper($row_key).'>';
            $row_val['val']= substr($row_val['val'],0,$row_val['len']);
            $lv_val=str_pad($row_val['val'], $row_val['len'], $row_val['padstr'], $row_val['padtyp']);
            $lv_20aux=str_replace( $lv_tag,$lv_val, $lv_20aux);
          }
          $lv_90aux=$lv_90;
          foreach( $lo_row90cnf as $row_key => $row_val){
            $lv_tag='<'.strtoupper($row_key).'>';
            $row_val['val']= substr($row_val['val'],0,$row_val['len']);
            $lv_val=str_pad($row_val['val'], $row_val['len'], $row_val['padstr'], $row_val['padtyp']);
            
            $lv_90aux=str_replace( $lv_tag,$lv_val, $lv_90aux);
          }
          
          $lv_buflqdtxt.= chr(13);
          $lv_buflqdtxt.=$lv_20aux;
          $lv_buflqdtxt.= chr(13);
          $lv_buflqdtxt.=$lv_90aux; 
        }

        $lv_lqdtod=0;
        foreach( $lo_prslst as $lo_prsrow){
          $lv_exceltxt.='<tr>';
          $lv_exceltxt.='<td>'.$lo_prsrow['prscod'].'</td>';
          $lv_exceltxt.='<td>'.$lo_prsrow['prstxt'].'</td>';
          $lv_exceltxt.='<td>'.str_replace(',','.',$lo_prsrow['lqdtot']).'</td>';
          $lv_exceltxt.='</tr>';
          $lv_lqdtod+=$lo_prsrow['lqdtot'];
          
        }
         $lv_exceltxt.='<tr>';
          $lv_exceltxt.='<td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">Total</td>';
          $lv_exceltxt.='<td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;"></td>';
          $lv_exceltxt.='<td style="background-color: #4472C4; color: #FFFFFF; font-weight: bold;">'.str_replace(',','.',$lv_lqdtod).'</td>';
          $lv_exceltxt.='</tr>';
        $lv_exceltxt.='</table>';
        ini_set('memory_limit', $lv_lmtmem);
        $lv_buftxt ='';
        foreach( $lo_row10cnf as $row_key => $row_val){
          $lv_tag='<'.strtoupper($row_key).'>';
          if($row_key=='impl'){
            $row_val['val']=str_replace( '.','', $row_val['val']);
            
          }
          $lv_val=str_pad($row_val['val'], $row_val['len'], $row_val['padstr'], $row_val['padtyp']);
          $lv_01=str_replace( $lv_tag,$lv_val, $lv_01);
        }
        $lv_count++;
        $lo_row95cnf['secarm']['val']=$lv_count;
        
         $lo_row95cnf['qty2']['val']=$lv_count + 1;
        foreach( $lo_row95cnf as $row_key => $row_val){
          $lv_tag='<'.strtoupper($row_key).'>';
          if($row_key=='imptot'){
            $row_val['val']=str_replace( '.','', $row_val['val']);
          }
          $lv_val=str_pad($row_val['val'], $row_val['len'], $row_val['padstr'], $row_val['padtyp']);
          $lv_95=str_replace( $lv_tag,$lv_val, $lv_95);
        }
        
        $lv_buftxt=$lv_01;
        $lv_buftxt.=$lv_buflqdtxt;
        $lv_buftxt.= chr(13);
        $lv_buftxt.=$lv_95;
  
        $lv_bufsql =implode(chr(13), $lv_data_sqlstm);

        // Preparo el pdf
				$lo_fle = $this->co_reg->load->model('grldatupl');
				$nombre_fichero_tmp = $lo_fle->createTempFile('evoluciones.tmp');
        $lo_zip = new ZipArchive();
        $lo_zip->open($nombre_fichero_tmp, ZipArchive::OVERWRITE);
        
        // Agrego el pdf al archivo comprimido
        $lo_zip->addFromString($lo_row10cnf['flenme']['val'].'.txt', $lv_buftxt);
        $lo_zip->addFromString($lo_row10cnf['flenme']['val'].'.xls', $lv_exceltxt);
        $lo_zip->addFromString('Err.txt', $lv_errlst);
        $lo_zip->addFromString('consultas.sql', $lv_bufsql);
        // Cerrar y enviar zip
        $lo_zip->close();
        header('Content-Type: application/zip');
        header('Content-Disposition: attachment; filename="'. $lo_row10cnf['flenme']['val'] .'.zip"');
        readfile($nombre_fichero_tmp);
				break;
      
      //   EVOLUCION - ESCLEROSIS - BORRAR
			case '#patchkosde':
        $lv_ret=array( 'errtyp'=>'S', 'errcod'=>0, 'errtxt'=> '');
        
        /* Buscar las interfaz */
        $lo_intmdl = $this->co_reg->load->model('sysint');	        
        $lv_prmint = array('vewfldflt' =>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'EVLTOOSDE'.chr(9).chr(9),
                           'vewmaxrec' =>'1'
                        );
        $lv_rsInt=$lo_intmdl->getList($lv_prmint); 
        if(count($lv_rsInt)>0){
          if(!$lo_intmdl->load(array('sysintcod'=>$lv_rsInt[0]['sysintcod']))){
            return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_intmdl->errcod,'errtxt'=>$lo_intmdl->errtxt) );
          }
          
          $lv_intval=[];
          $lv_intval['cuscodlst']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'cuscodlst');
          $lv_intval['apiurl']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'apiurl');
          $lv_intval['cuscod']= $lp_prm['data']['cuscod'];
          // Es paciente osde?
          $lv_bolcuscod=true;
          $lv_bolcuscod =str_contains($lv_intval['cuscodlst'], (';'.$lp_prm['data']['cuscod'].';'));
          if($lv_bolcuscod){
            $lv_prm = [];
            $lv_prm['dte']='05052024';//$lv_evldte->format('Ymd');
          	$lv_prm['apiurl']=$lv_intval['apiurl'];
            $lv_prm['hur']='1556';
            $lv_prm['seccod']=$lp_prm['data']['seccod']??'000';//Fijo:000
            $lv_prm['aficod']=$lp_prm['data']['hhrmedcovaflnum'];// Prueba: 60671956201
            $retApi=$this->getOsdePatDat($lv_prm); 
            $lv_ret=array( 'errtyp'=> $retApi['errtyp'], 'errcod'=> $retApi['errcod'], 'errtxt'=>  $retApi['errtxt']);
          }else{
            $lv_ret=array( 'errtyp'=>'S', 'errcod'=>0, 'errtxt'=>'');
          }
        }else{
          $lv_ret=array( 'errtyp'=>'S', 'errcod'=>0, 'errtxt'=> '');
        }        
        return $lv_ret;
        break;
      
      case '#tstosde':{
        
        $wsdl='https://wsconectado.activiaweb.com.ar/WSActiviaC.asmx?WSDL';
        //$wsdl='https://homologaciones.activiaweb.com.ar/WSActiviaC.asmx?WSDL';
    		//$client=new SoapClient($wsdl); 
        $param=array('pos'=>'0000','filecontent'=>'Hola');
        try{
      		$result = $client->HelloWorld($param);
        } catch (Exception $e) {
          $lv_ret['errcod']='-1';
          $lv_ret['errtxt']='Excepción capturada: <br><code>'.  $e->getMessage().'</code>';
          $lv_ret['errtxt']='E';
          return $lv_ret;
        }
        break; 
      }
      
      // R E P O R T E S   D E   L I Q U I D A C I O N E S   A S A N T E
      case '#tpelqdrptasa':
				$lo_post = $this->co_reg->request->post;
        $lv_data_sqlstm = array();
        $lv_dismatequi=array();
				$lv_maxrec = false;
				$lv_fltevlne=false;
				$lv_fltevlee=false;
        $lv_lmtmem= ini_get('memory_limit');
        ini_set('memory_limit', '2048M'); 

	    	/* RUSSO-> CONSULTA CABECERA DE LIQUIDACION */
        // este modelo se carga para recuperar descripción y los IDs de liquidación.
        $lo_mdllqd = $this->co_reg->load->model('hltprslqd');
				$lv_prmflt = array();
				if($lv_maxrec==false){ 
					$lv_prmflt['vewmaxrec']=$lo_post['vewmaxrec'];
				}
        //LIQUIDACIONES
        $lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]l.docsts'.chr(9).'='.chr(9).chr(9).'C'.chr(9).chr(9).
																			   (count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
													 							'vewmaxrec'=>$lo_post['vewmaxrec'],
                           							'vewfldord' => 'l.hltprslqddte desc'
												  							);
        //var_dump($lv_prmflt);
        $lo_rslqd = $lo_mdllqd->getList($lv_prmflt, null, null, false);
        $lv_data_sqlstm[] = $lo_mdllqd->getsysdata('sqlstm');
        //var_dump($lo_rslqd);
        // Obtengo los id de liquidacion
        $lo_lqdcodlst=array_column($lo_rslqd, 'hltprslqdcod','hltprslqdcod');
        $lo_prscodlst=array_column($lo_rslqd, 'prscod','prscod');
        //var_dump($lo_lqdcodlst);
        //POSICIONES DE LAS LIQUIDACIONES
        $lo_lqdcodmdl = $this->co_reg->load->model('hltprslqddoc');
        //Ejemplo de agrupamiento
        // La idea es realizar el agripamiento para traer directamente los datos de:
        // 		Subtotal Factura G,Subtotal Horas G, Hon. Debe G,Hon. Haber G y Total
        $lv_prm= array('vewfldflt' =>'[~fltrow~]ld.docsts'.chr(9).'='.chr(9).chr(9).'C'.chr(9).chr(9).
																		 '[~fltrow~]ld.hltprslqdcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lo_lqdcodlst).chr(9).chr(9),
                        'vewfldgrp' => 'ld.hltprslqdcod',
                        'vewfldgrpcal' => 'sum((CASE when convert(decimal (20,2), ld.hltprslqddoctot) >=0 then convert(decimal (20,2), ld.hltprslqddoctot)  else 0 end ) )as subfacg,'.
                                          'sum(case when ld.refobjtyp=^HLT_PCR^ then (CASE when convert(decimal (20,2), ld.hltprslqddoctot) >=0 then convert(decimal (20,2), ld.hltprslqddoctot)  else 0 end ) else 0 end ) as subhrsg,'.
                                          'sum(case when ld.refobjtyp=^BUY_EXP^ then (CASE when convert(decimal (20,2), ld.hltprslqddoctot) >=0 then convert(decimal (20,2), ld.hltprslqddoctot)  else 0 end ) else 0 end ) as subdebg,'.
                                          '(sum(case when ld.refobjtyp=^BUY_EXP^ then (CASE when convert(decimal (20,2), ld.hltprslqddoctot) <0 then convert(decimal (20,2), ld.hltprslqddoctot)  else 0 end ) else 0 end ) * -1) as subhabg,'.
                       										'sum(convert(decimal (20,2), ld.hltprslqddoctot)) AS tot'
                       );
				$lo_rslqddoc = $lo_lqdcodmdl->getList($lv_prm);
        $lv_data_sqlstm[] = $lo_lqdcodmdl->getsysdata('sqlstm');
        $lo_rslqddoc[0]['sqlstm']=$lv_data_sqlstm;
        $lo_lqddoctot =[];
        foreach($lo_rslqd as $lv_row){
          // busco la posición correspondiente al ID de cabecera 
          $lv_doccol = array_search($lv_row['hltprslqdcod'], array_column($lo_rslqddoc, 'hltprslqdcod'));
          if ( $lv_doccol ){
          	$lo_lqddoctot[$lv_row['hltprslqdcod']]['subfacg']=$lo_rslqddoc[$lv_doccol]['subfacg']??0;
            $lo_lqddoctot[$lv_row['hltprslqdcod']]['subhrsg']=$lo_rslqddoc[$lv_doccol]['subhrsg']??0;
            $lo_lqddoctot[$lv_row['hltprslqdcod']]['subdebg']=$lo_rslqddoc[$lv_doccol]['subdebg']??0;
            $lo_lqddoctot[$lv_row['hltprslqdcod']]['subhabg']=isset($lo_rslqddoc[$lv_doccol]['subhabg'])?$lo_rslqddoc[$lv_doccol]['subhabg'] * -1:0;
            $lo_lqddoctot[$lv_row['hltprslqdcod']]['tot']=$lo_rslqddoc[$lv_doccol]['tot']??0;
          }
        }

				$lo_taxmdl = $this->co_reg->load->model('grldattax');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9). 'A'.chr(9).chr(9).
																			'[~fltrow~]taxsrctyp'.chr(9).'='.chr(9).chr(9). 'HLT_PRS'.chr(9).chr(9).
                       								'[~fltrow~]taxsrccod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lo_prscodlst).chr(9).chr(9)
                       );
				$lo_rstax = $lo_taxmdl->getList($lv_prm);
				$lv_data_sqlstm[]= $lo_taxmdl->getsysdata('sqlstm');
        $lo_taxlst=array();
        foreach($lo_rstax as $lv_rowtax){
          $lo_taxlst[$lv_rowtax['taxsrccod']]=$lv_rowtax;
        }  

 
        $lv_ret=array();
        $lo_lqdlst=[];
        foreach($lo_rslqd as $lv_row){
          $lv_row['hltprslqdtot']=$lv_row['hltprslqdtot']??'0';
          $lv_row['hltprslqdtot']=number_format($lv_row['hltprslqdtot'], 2, ',', '');
          // PENDIENTE
          if(isset($lo_taxlst[$lv_row['prscod']])){
            $lv_buf=isset($lv_row['prscod'])?$lo_taxlst[$lv_row['prscod']]:"";
          }
          $lv_buf['paymthtxt']=$lv_row['paymthtxt'];          
          /*$lv_buf['subfacg']=0;
          $lv_buf['subhrsg']=0;
          $lv_buf['subdebg']=0;
          $lv_buf['subhabg']=0;
          $lv_buf['tot']=0;*/
          if(isset($lo_lqddoctot[$lv_row['hltprslqdcod']])){
            $lv_buf['subfacg']=$lo_lqddoctot[$lv_row['hltprslqdcod']]['subfacg']??0;
            $lv_buf['subhrsg']=$lo_lqddoctot[$lv_row['hltprslqdcod']]['subhrsg']??0;
            $lv_buf['subdebg']=$lo_lqddoctot[$lv_row['hltprslqdcod']]['subdebg']??0;
            $lv_buf['subhabg']=$lo_lqddoctot[$lv_row['hltprslqdcod']]['subhabg']??0;
            $lv_buf['tot']=$lo_lqddoctot[$lv_row['hltprslqdcod']]['tot']??0;
          }
          $lv_ret[]=array_merge($lv_row,$lv_buf);
          $lo_lqdlst[] = $lv_row['hltprslqdcod'];
        }
        $lv_ret[0]['sqlsmt']=$lv_data_sqlstm;
        ini_set('memory_limit', $lv_lmtmem);
        return $lv_ret; 
      	break;
			

      case "#valphnsapi":
        $ret=[];
        $ret['errtyp']='S';
        $ret['errcod']='0';
        if(($lp_prm['data']['nofrmchk']??'')==''){
          $tmp_dialog=''.
          'BootstrapDialog.show({'.
            'title: "Alerta insumo valor 0", '.
            'message: "<strong>Atencion!!!</strong></br>Usted está por dar de alta un paciente con telefonos erroneos",'.
            'type: BootstrapDialog.TYPE_WARNING ,'.
            'size: BootstrapDialog.SIZE_NORMAL,'.
            'buttons: [{ label: "NO", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } }, '.
                      '{ label: "SI", cssClass: "btn-primary",	action: function(dialogItself){ $('.chr(39).'#'.$lp_prm['data']['lv_sec'].'_frm'.chr(39).').append('.chr(39).'<input type="hidden" name="nofrmchk" value="X">'.chr(39).'); '.$lp_prm['data']['lv_sec'].'_fnc({action: "00"}); dialogItself.close(); }}]'.
          '});';

          $ret= array( 'errtyp'=>'E',
                     'errcod'=>'-125',
                     'errtxt'=>'Atencion!!!',
                     'errjva'=>$tmp_dialog
                    );

        }
        return $ret;
        break;
      case "#Zevlinfosd":
        $ret= $this->ZsendOsde($this->co_reg->request->post);
        return $this->co_reg->document->getJson($ret);
        break;
      case "#evrptosd":
        $sqlsmt=[];
        $lo_post=$this->co_reg->request->post;
        $mdlEvl = $this->co_reg->load->model('hltpatevl');
        $lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        $lv_vewfldord = (isset($lo_post['vewfldord'])&&$lo_post['vewfldord']!='')?$lo_post['vewfldord']:'e.evlcod desc';
        for($i=count($lv_fltarrevl)-1; $i>0; $i--){
          if(stripos(';evlcod;evldte;apisendok;apinroref;pattxt;prescod;rtaadic;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
            unset($lv_fltarrevl[$i]);
          }else{
            $lv_fltarrevl[$i] = str_replace('evlcod','e.evlcod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('evldte','e.evldte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('apisendok','dbo.gettagvalue(^apisendok^,dbo.gettagvalue(^row^,evlatr001))',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('apinroref','dbo.gettagvalue(^apinroref^,dbo.gettagvalue(^row^,evlatr001))',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('prescod','dbo.gettagvalue(^prescod^,dbo.gettagvalue(^row^,evlatr001))',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('rtaadic','dbo.gettagvalue(^rtaadic^,dbo.gettagvalue(^row^,evlatr001))',$lv_fltarrevl[$i]);
          }
        }

        $lv_prm = array('vewfldflt' =>'[~fltrow~]e.docsts'.chr(9).'IN'.chr(9).chr(9).'A'.chr(9).chr(9).
                        							'[~fltrow~]dbo.gettagvalue(^apisendok^,dbo.gettagvalue(^row^,evlatr001)) '.chr(9).'<>'.chr(9).chr(9).''.chr(9).chr(9).
                        							'[~fltrow~]dbo.gettagvalue(^apinroref^,dbo.gettagvalue(^row^,evlatr001)) '.chr(9).'<>'.chr(9).chr(9).'E-08'.chr(9).chr(9).
                        (count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
                        'vewmaxrec'=>$lo_post['vewmaxrec'],
                        'vewfldord' => $lv_vewfldord
                       );
        $lo_rsevl = $mdlEvl->getList($lv_prm, null, null, false);
        $sqlsmt[]=$mdlEvl->getsysdata('sqlstm');
        
        $patlst= array_column($lo_rsevl,'patcod','patcod');
        $mdlPat = $this->co_reg->load->model('hltpat');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]patcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $patlst).chr(9).chr(9));
				$rsPat = $mdlPat->getList($lv_prm, null,null,true);
        $sqlsmt[]=$mdlPat->getsysdata('sqlstm');
        $patDat=[];
        foreach($rsPat as $rowPat){
          $ketPat=$rowPat['patcod'];
          $patDat[$ketPat]=$rowPat;          
        }
        
        $ret=[];
        foreach($lo_rsevl as $rowevl){
          $new= $rowevl;
          $attr=$this->co_reg->document->getTagValue($rowevl['evlatr001'] , 'row');
          $new['apinroref']=$this->co_reg->document->getTagValue($attr, 'apinroref');
          $new['msjdisp']=$this->co_reg->document->getTagValue($attr, 'msjdisp');
          $new['apisendok']=($this->co_reg->document->getTagValue($attr, 'apisendok')=='1'?'S':'E');
          $new['prescod']=$this->co_reg->document->getTagValue($attr, 'prescod');
          $new['rtaadic']=$this->co_reg->document->getTagValue($attr, 'rtaadic');
          //$ret[]=$new;
          $ret[]=$new+$patDat[$new['patcod']];
          //$ret[]=array_merge($new, $patDat[$new['patcod']]);
        }
         $ret[0]['Z_sqlsmt']=$sqlsmt;
        return  $ret;
        break;
        //REPORTE. Medicos Tratantes
        case "#rptpatmed":
        $lv_vewfldflt = (isset($this->co_reg->request->post['vewfldflt'])?$this->co_reg->request->post['vewfldflt']:'');
				$lv_vewmaxrec = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewmaxrec']:'');
        $lv_vewfldord = (isset($this->co_reg->request->post['vewfldord'])?$this->co_reg->request->post['vewfldord']:'');
        
        //Filtros de PACIENTE
        $lv_fltarr = explode('[~fltrow~]',$lv_vewfldflt );
				for($i=count($lv_fltarr)-1; $i>0; $i--){
				 if(stripos(';patcodext;patcod;pattxt;hltdisclstxt;custxt;lndregtxt;',';'.explode(chr(9),$lv_fltarr[$i])[0].';')===false){
				 	unset($lv_fltarr[$i]);
				 }else{
           $lv_fltarr[$i] = str_replace('patcodext','p.patcodext',$lv_fltarr[$i]); //Codigo Externo  Paciente
           $lv_fltarr[$i] = str_replace('patcod'.chr(9),'p.patcod'.chr(9),$lv_fltarr[$i]); //Codigo Paciente
           $lv_fltarr[$i] = str_replace('pattxt','p.pattxt',$lv_fltarr[$i]); //Nombre Paciente
 					 $lv_fltarr[$i] = str_replace('hltdisclstxt','pdc.hltdisclstxt',$lv_fltarr[$i]); //Enfermedad
           $lv_fltarr[$i] = str_replace('custxt','c.custxt',$lv_fltarr[$i]); //Financiador
           $lv_fltarr[$i] = str_replace('lndregtxt','lr.lndregtxt',$lv_fltarr[$i]); //Provincia
         }
				}
        $lo_patmdl = $this->co_reg->load->model('hltpat');
     		$lv_patprm = array('vewfldflt' =>'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                          							 (count($lv_fltarr)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltarr):''),
                          'vewfldord' => ($lv_vewfldord==''?'p.patcod + 0 ':$lv_vewfldord),
                          'vewmaxrec'=>$lv_vewmaxrec
                          );
        $lo_rspat = $lo_patmdl->getlist($lv_patprm, null, null, false);
        $lo_stmarr[] = $lo_patmdl->getsysdata('sqlstm');
        $lv_patlst = array();
        foreach( $lo_rspat as $lo_row) {
              $lv_patlst[] = $lo_row['patcod'];
        }
        
        //PREPARAMOS LOS FILTROS DE LOS ROLES
        $lv_fltpatarr = explode('[~fltrow~]',$lv_vewfldflt );
        $lv_fltpat = false;
        for($i=count($lv_fltpatarr)-1; $i>0; $i--){
				 if(stripos(';prsrlstxt;prstxt;',';'.explode(chr(9),$lv_fltpatarr[$i])[0].';')===false){
				 	unset($lv_fltpatarr[$i]);
				 }else{
           $lv_fltpatarr[$i] = str_replace('prsrlstxt','r.prsrlstxt',$lv_fltpatarr[$i]); //Nombre rol
           $lv_fltpatarr[$i] = str_replace('prstxt','pr.prstxt',$lv_fltpatarr[$i]); //Nombre prestador
           $lv_fltpat = true;
         }
				}
   			$lo_patprsmdl = $this->co_reg->load->model('hltpatprsrls');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lv_patlst) .chr(9).chr(9).
                        							'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                      ((($lp_prm['prm_prsrlscodext']??'')!='')?'[~fltrow~]r.prsrlscodext'.chr(9).'='.chr(9).chr(9).$lp_prm['prm_prsrlscodext'].chr(9).chr(9):'').
                        							(count($lv_fltpatarr)>0?implode('[~fltrow~]',$lv_fltpatarr):''),
                        'vewfldord' => ($lv_vewfldord==''?'p.patcod + 0 ':$lv_vewfldord),
                        'vewmaxrec'=>$lv_vewmaxrec
                          );
        $lo_rsrls = $lo_patprsmdl->getList($lv_prm, null, null, false);
        $lo_stmarr[] = $lo_patprsmdl->getsysdata('sqlstm');

       	$lv_hltpatlst=array();
        $lo_ret=array();
        
        $lv_hltpatlst = [];
       $lv_hltrlslst = [];
       foreach ($lo_rsrls as $lv_rls) {
            $lv_hltrlslst[$lv_rls['patcod']][] = $lv_rls;
        }
        foreach ($lo_rspat as $lv_pat) {
            $lv_patcod = $lv_pat['patcod'];
            if (isset($lv_hltrlslst[$lv_patcod])) {
              foreach ($lv_hltrlslst[$lv_patcod] as $lv_rls) {
                  $lv_row = $lv_rls; // base: datos del rol
                  $lv_row['patcodext']    = $lv_pat['patcodext'];
                  $lv_row['pattxt']       = $lv_pat['pattxt'];
                  $lv_row['docsts']       = $lv_pat['docsts'];
                  $lv_row['hltdisclstxt'] = $lv_pat['hltdisclstxt'];
                  $lv_row['custxt']       = $lv_pat['custxt'];
                  $lv_row['lndregtxt']    = $lv_pat['lndregtxt'];
                  $lo_ret[] = $lv_row;
              }
            } elseif (empty($lp_prm['prm_prsrlscodext'])) {
              $lv_row = $lv_pat;
              $lv_row['prstxt'] = ''; 
              $lo_ret[] = $lv_row;
            }
        }
				$lo_ret[0]['sqlstm']=$lo_stmarr;
        return $lo_ret;
				break;
		}	
  }
  public function ZsendOsde($lp_prm){
    $lo_post=$lp_prm;
  	$ret=[];
		$ret['errtyp']='S';
    $ret['errcod']='';
    $ret['errtxt']=$lo_post['evlcod'];
    
    $lo_evlmdl= $this->co_reg->load->model('hltpatevl');
    
    $lo_evlmdl->load( array('evlcod'=>$lo_post['evlcod']),false );
    $lo_post= $lo_evlmdl->getdata();
    $evlAtr= $this->co_reg->document->getTagValue(strtolower($lo_post['evlatr001']), 'row');
    
   	$lo_post['evlatr001']='';
    $lo_post['evlatr001'].= '<pathgh>'.$this->co_reg->document->getTagValue( $evlAtr, 'pathgh').'</pathgh>';
    $lo_post['evlatr001'].= '<patwgt>'.$this->co_reg->document->getTagValue( $evlAtr, 'patwgt').'</patwgt>';
    $lo_post['evlatr001'].= '<evlcnccmt>'.$this->co_reg->document->getTagValue( $evlAtr, 'evlcnccmt').'</evlcnccmt>';
    $lo_post['evlatr001'].= '<tas>'.$this->co_reg->document->getTagValue( $evlAtr, 'tas').'</tas>';
    $lo_post['evlatr001'].= '<tad>'.$this->co_reg->document->getTagValue( $evlAtr, 'tad').'</tad>';
    $lo_post['evlatr001'].= '<fc>'.$this->co_reg->document->getTagValue( $evlAtr, 'fc').'</fc>';
    $lo_post['evlatr001'].= '<fr>'.$this->co_reg->document->getTagValue( $evlAtr, 'fr').'</fr>';
    $lo_post['evlatr001'].= '<tmp>'.$this->co_reg->document->getTagValue( $evlAtr, 'tmp').'</tmp>';
    $lo_post['evlatr001'].= '<spo2>'.$this->co_reg->document->getTagValue( $evlAtr, 'spo2').'</spo2>';
    $lo_post['evlatr001'].= '<glu>'.$this->co_reg->document->getTagValue( $evlAtr, 'glu').'</glu>';
    $lo_post['evlatr001'].= '<evllat>'.$this->co_reg->document->getTagValue( $evlAtr, 'evllat').'</evllat>';
    $lo_post['evlatr001'].= '<evllon>'.$this->co_reg->document->getTagValue( $evlAtr, 'evllon').'</evllon>';
    $lo_post['evlatr001'].= '<evlinfprc>'.$this->co_reg->document->getTagValue( $evlAtr, 'evlinfprc').'</evlinfprc>';
    $lo_post['evlatr001'].= '<evlcncmtv>'.$this->co_reg->document->getTagValue( $evlAtr, 'row').'</evlcncmtv>';
    /* Buscar las interfaz */
    $lo_intmdl = $this->co_reg->load->model('sysint');	        
    $lv_prmint = array('vewfldflt' =>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'EVLTOOSDE'.chr(9).chr(9),
                       'vewmaxrec' =>'1'
                    );
    $lv_rsInt=$lo_intmdl->getList($lv_prmint); 
    if(count($lv_rsInt)>0){
      if(!$lo_intmdl->load(array('sysintcod'=>$lv_rsInt[0]['sysintcod']))){
        return array('errtyp'=>'E','errcod'=>$lo_intmdl->errcod,'errtxt'=>$lo_intmdl->errtxt);
      }
      $lv_intval=[];
      $lv_intval['apiurl']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'apiurl');
      $lv_intval['cuscodlst']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'cuscodlst');
      $lv_intval['spccodlst']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'spccodlst');
      $lv_intval['emlerrcodlst']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'emlerrcodlst');
      $lv_intval['notsveerrcodlst']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'notsveerrcodlst');
      $lv_intval['activeLog']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'activate_audit_log');
      $lv_intval['emllstesp']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'spcemllst_'.$lo_post['spccod']);
      $lv_intval['emllstspcall']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'spcemllst_*');
      $lv_intval['cuscod']= $lo_post['cuscod'];
      $lv_intval['spccnv']=[];
      foreach($lo_intmdl->sysintcnv as $lo_rowcnv){
        $lv_intval['spccnv'][$lo_rowcnv['sysintcnvkey']]=$lo_rowcnv['sysintcnvout001'];
      }
    }
    $lv_bolspccod=true;
    if(stripos($lv_intval['spccodlst'], ';'.$lo_post['spccod'].";")===false){
      $lv_bolspccod=false;
    }
    $lv_bolcuscod=true;
    if(stripos($lv_intval['cuscodlst'], ';'.$lo_post['cuscod'].";")===false){
      $lv_bolcuscod=false;
    }

    if($lv_bolspccod && $lv_bolcuscod){
      $lo_datpermdl = $this->co_reg->load->model('grldatper');
      if(!$lo_datpermdl->load(array('persrctyp'=>'HLT_PAT','persrccod'=>$lo_post['patcod']))){
        $lo_datpermdl->hhrmedcovaflnum ='';
      }
      $lv_dte = date("Y-m-d H:i:s");
      $lv_curdte = new DateTime($lv_dte);
      
      $evlDteStr = trim($lo_post['evldte']->format('d/m/Y'));
      $lo_post['evldte']=$evlDteStr;
      $lv_evldte = DateTime::createFromFormat('d/m/Y', $lo_post['evldte']);
      
      $lv_prm=[];
      $lv_prm['apiurl']=$lv_intval['apiurl'];
      $lv_prm['dte']=$lv_evldte->format('Ymd');//'20231121';
      $lv_prm['evldte']=$lv_evldte->format('Ymd');//'20231121';
      $lv_prm['hur']='1556';
      $lv_prm['gpslon']=$this->co_reg->document->getTagValue(strtolower($lo_post['evlatr001']), 'evllon');//$lo_post['evllon'];
      $lv_prm['gpslat']=$this->co_reg->document->getTagValue(strtolower($lo_post['evlatr001']), 'evllat');//$lo_post['evllat'];
      $lv_prm['prescod']=$lp_prm['matplncmt']??'';//;
      $lv_prm['aficod']=$lo_datpermdl->hhrmedcovaflnum;//'60671956201';//$lo_patmdl->hhrmedcovaflnum??'60671956201';
      $lv_prm['seccod']=$lo_post['seccod']??'218';
      $lv_ret=[];
      $lv_data = array('now'=>$lv_curdte->format('d/m/Y'),'evldte'=>$lv_evldte->format('d/m/Y'));

      $lv_ret = $this->ZsenOsdeEvlDif($lv_prm);
      $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
      if(!$lo_plndtemdl->load(array('plnid'=>$lo_post['plnid'],'plndteid'=>$lo_post['plndteid']))){
        $lo_plndtemdl->prstxt='No encontrado';
        $lo_plndtemdl->pattxt='No encontrado';               
      }
      if(strtoupper($lv_intval['activeLog'])=='X'){
        $lo_applogmdl = $this->co_reg->load->model('sysapplog');
        $lv_errlog=[];
        $lv_errlog['srcobjtyp']='SYS_INT';
        $lv_errlog['srcobjcod001']=$lo_intmdl->sysintcod;
        $lv_errlog['srcobjcod002']='';
        $lv_errlog['applogtxt']='';
        $lv_errlog['applogtecinf']='';
        $lv_errlog['mdlcod']='zcutp1';
        $lv_errlog['prgcod']='evlsoekin00';
        $lv_errlog['docsts']='A';
        $lv_errlog['applogerrtyp']=$lv_ret['errtyp'];
        $lv_errlog['applogerrcod']=trim($lv_ret['data']['rtaadic']);
        $lv_errlog['applogerrtxt']='<code>';
        $lv_errlog['applogerrtxt'].='<strong>Paciente:</strong> ('  . $lo_post['patcod'].')'. $lo_plndtemdl->pattxt.'<br>';
        $lv_errlog['applogerrtxt'].='<strong>Afil. Num.:</strong> ' . $lv_prm['aficod'].'<br>';
        $lv_errlog['applogerrtxt'].='<strong>Prestador:</strong> (' . $lo_post['prscod'].') '. $lo_plndtemdl->prstxt.'<br>';
        $lv_errlog['applogerrtxt'].='<strong>Cod. Seg.:</strong> (' . $lv_prm['seccod'].')';
        $lv_errlog['applogerrtxt'].='<strong>Cod. Pres.:</strong> [' . $lv_prm['prescod'].']<br>';
        $lv_errlog['applogerrtxt'].='<strong>Fecha de planificacion:</strong> '.$lv_evldte->format('d/m/Y').'<br>';
        $lv_errlog['applogerrtxt'].='<strong>apinroref= </strong>'.trim($lv_ret['data']['nroref']).'<br>';
        $lv_errlog['applogerrtxt'].='<strong>msjdisp= </strong>'.trim($lv_ret['errtxt']).'<br>';
        $lv_errlog['applogerrtxt'].='</code>';
        $lv_errlog['applogtxt']='applogtxt';
        $lo_applogmdl->save($lv_errlog);
      }
      if($lv_ret['errtyp']=='S'){
        $lo_post['evlatr001'] .= "<apisendok>1</apisendok><apinroref>".trim($lv_ret['data']['nroref'])."</apinroref><msjdisp>".trim($lv_ret['errtxt'])."</msjdisp><rtaadic>".trim($lv_ret['data']['rtaadic'])."</rtaadic><prescod>" . $lv_prm['prescod']."</prescod>";
      }else{
        $lo_post['evlatr001'] .= "<apisendok>0</apisendok><apinroref>".$lv_ret['errtyp']."-".$lv_ret['errcod']."</apinroref><msjdisp>".trim($lv_ret['errtxt'])."</msjdisp><rtaadic>".trim($lv_ret['data']['rtaadic'])."</rtaadic><prescod>" . $lv_prm['prescod']."</prescod>";
      }
      $lo_post['evlatr001']='<row>'.$lo_post['evlatr001'].'</row>';
      if(!$lo_evlmdl->save($lo_post, false)){
        return array('errtyp'=>$lo_evlmdl->errtyp,'errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt); 
      }
      return $ret ;
    }
  }
  // Valida teléfonos argentinos (fijos, móviles, no geográficos o sociales)
  // Si es válido, devuelve un array con el número parseado.
  function tel_argentino( $tel ) {
      $re = '/^(?:((?P<p1>(?:\( ?)?+)(?:\+|00)?(54)(?<p2>(?: ?\))?+)(?P<sep>(?:[-.]| (?:[-.] )?)?+)(?:(?&p1)(9)(?&p2)(?&sep))?|(?&p1)(0)(?&p2)(?&sep))?+(?&p1)(11|([23]\d{2}(\d)??|(?(-10)(?(-5)(?!)|[68]\d{2})|(?!))))(?&p2)(?&sep)(?(-5)|(?&p1)(15)(?&p2)(?&sep))?(?:([3-6])(?&sep)|([12789]))(\d(?(-5)|\d(?(-6)|\d)))(?&sep)(\d{4})|(1\d{2}|911))$/D';
      if (preg_match($re,$tel,$match)) {
          list(
              ,$internacional_completo,,$internacional,,,$internacional_celu,$prefijo_acceso,$area,,,
              $prefijo_celu,$local_1a,$local_1b,$local_1c,$local_2,$numero_social
          ) = array_pad($match,20,'');

          $local_1 = $local_1a . $local_1b . $local_1c;
          $local = $local_1 . $local_2;
          $es_fijo = !($internacional_celu || $prefijo_celu);
          $numero = $area.$local.$numero_social;
          $completo = $internacional.$internacional_celu.$area.$prefijo_celu.$local.$numero_social;
          return compact(
                     'numero','completo','internacional','internacional_celu','area',
                     'prefijo_celu','local','local_1','local_2','numero_social','es_fijo'
                 );
      }
      return false;	
  }
  
  public function callApiPhone($lpApUrl='',$lpPhoneNumber='',$lpMdlInt=null){
    $lvRet=array('errcod'=>'0','errtyp'=>'S','errtxt'=>'','retdat'=>array('apiurl'=>$lpApUrl. $lpPhoneNumber,'phnnum'=>'','phnint'=>'','phnloc'=>'','phntyp'=>''));
    if($lpApUrl==''){
      $lvRet['errcod']='001';
      $lvRet['errtxt']='Falta API Key';
      //return $lvRet;
    }
    if($lvRet['errtyp']!='E' &&$lpPhoneNumber==''){
      $lvRet['errcod']='002';
      $lvRet['errtxt']='Falta numero de telefono';
      //return $lvRet;
    }
    
    if($lvRet['errtyp']!='E'){
      $curl = curl_init();
      curl_setopt_array($curl, array(
        CURLOPT_URL =>  $lpApUrl. $lpPhoneNumber,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 0,
        CURLOPT_SSL_VERIFYHOST=>0,
        CURLOPT_SSL_VERIFYPEER=>0,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'GET',
      ));

      if( ! $lo_rs = curl_exec($curl)){
        trigger_error(curl_error($curl));
      }

      $statusCode = curl_getinfo($curl, CURLINFO_HTTP_CODE);
      if ($statusCode != 200){
        $lvRet['errtyp']='E';
        $lvRet['errcod']=$statusCode;
        $lvRet['errtxt']='';
        //return $lvRet;
      } 
    }
    
    if($lvRet['errtyp']!='E'){
    	$apiRet=json_decode($lo_rs,true);
      //print_r($apiRet); echo '</br></br>';
      $lvRet['cmpdata']=$apiRet;
      /*
      if(isset($apiRet['success']) && $apiRet['success']==false){
        $lvRet['errtyp']='E';
        $lvRet['errcod']=$apiRet['error']['code'];
        $lvRet['errtxt']=$apiRet['error']['type'];
        $apiRet['apiurl']=$lpApUrl. $lpPhoneNumber;
        $lvRet['retdat']=$apiRet;
        //return $lvRet;
      }
      */
    }
    
    if($lvRet['errtyp']!='E'){
      //print_r($apiRet);
      $lvRet['errtyp']='S';
      $lvRet['errcod']='0';
      $lvRet['errtxt']='';
      $lvRet['retdat']=array('apiurl'=>$lpApUrl. $lpPhoneNumber,
                             'phnnum'=>$apiRet['e164Format']??'',
                             'isvalid'=>$apiRet['isValid']??false,
                             'phnint'=>$apiRet['internationalFormat']??'',
                             'phnloc'=>$apiRet['nationalFormat']??'',
                             'phntyp'=>$apiRet['lineType']??''
                            );
      
    }
    return $lvRet;
  }
  
  private function ctectr($lp_prm=array() ){
    $lo_ctrmdl = $this->co_reg->load->model('hltplnctr');
    $lo_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte'); 
    $lv_ret = array('errcod'=>'0','errtxt'=>'','errtyp'=>'','errdata'=>'');
     // Cargamos el control de prestacion
    $lv_key['plnid'] = $lp_prm['plnid'];
    $lv_key['plndteid'] = $lp_prm['plndteid'];
    $lo_ctrdte_rs = $lo_ctrdtemdl->load($lv_key);
    if(count($lo_ctrdte_rs)>0){
      $lv_ret['errcod']='';
      $lv_ret['errtxt']='';
      $lv_ret['errtyp']='';
    	 return $lv_ret;
    }
    
    //CONTROL DE PRESTACION
    $lo_plnctrprm=array();
    $lo_plnctrprm['plnyth'] =substr($lp_prm['evldte'],6,4);
    $lo_plnctrprm['plnmth']= substr($lp_prm['evldte'],3,2);
    $lo_plnctrprm['spccod'] = $lp_prm['spccod'];
    $lo_plnctrprm['patcod'] = $lp_prm['patcod'];
    $lo_plnctrprm['prscod'] = $lp_prm['prscod'];
    $lo_plnctrprm['docsts'] = 'A'; 
    // CONTROL DE PRESTACION - cabecera
    if($lo_ctrmdl->save($lo_plnctrprm)==false){
      $lv_ret['errcod']=$lo_ctrmdl->errcod;
      $lv_ret['errtxt']=$lo_ctrmdl->errtxt;
      $lv_ret['errtyp']=$lo_ctrmdl->errtyp;
      return $lv_ret;
    }else{
      $lv_plndteprm = array();
      $lv_plndteprm['hltplnctrcod'] = $lo_ctrmdl->hltplnctrcod;
      $lv_plndteprm['plnid'] = $lp_prm['plnid'];
      $lv_plndteprm['plndteid'] = $lp_prm['plndteid'];
      $lv_plndteprm['hltplnctrdte'] = $lp_prm['evldte'];
      $lv_plndteprm['hltplnctrinbdte'] = '00:00';
      $lv_plndteprm['hltplnctroutdte'] = '00:00';
      $lv_plndteprm['hltplnctrqty'] = '1';
      $lv_plndteprm['hltplnctrtme'] = '24:00';
      $lv_plndteprm['spccod'] = $lp_prm['spccod'];
      $lv_plndteprm['prscod'] = $lp_prm['prscod'];
      $lv_plndteprm['hltplnctrcmt'] = 'Evolucion';
      $lv_plndteprm['docsts'] = 'A';
      // CONTROL DE PRESTACION - fechas
      if($lo_ctrdtemdl->save($lv_plndteprm)==false){
        $lv_ret['errcod']=$lo_plnctrdtemdl->errcod;
        $lv_ret['errtxt']=$lo_plnctrdtemdl->errtxt;
        $lv_ret['errtyp']=$lo_plnctrdtemdl->errtyp;
        return $lv_ret;
      }
    }
    
    return $lv_ret;    
  }
  
	private function delctr($lp_prm=array() ){
  	$lv_plnmdl = $this->co_reg->load->model('hltpln');
    $lo_plndtemdl = $this->co_reg->load->model('hltplndte');	
    $lo_ctrdtemdl = $this->co_reg->load->model('hltplnctrdte');
    $lv_ret = array('errcod'=>'0','errtxt'=>'','errtyp'=>'','errdata'=>'');
    $lv_key = array();
    $lv_key['plnid'] = $lp_prm['plnid'];
    $lv_key['plndteid'] = $lp_prm['plndteid'];
    // Cargamos el control de prestacion
    $lo_ctrdte_rs = $lo_ctrdtemdl->load($lv_key);  
    if(count($lo_ctrdte_rs)>0){
      //  BORRAMOS EL CONTROL
      $lv_key['hltplnctrcod'] = $lo_ctrdte_rs[0]['hltplnctrcod'];
      $lv_key['hltplnctrdtecod'] =$lo_ctrdte_rs[0]['hltplnctrdtecod'];
      $lo_ctrdtemdl->delete($lv_key);
    }       
    return $lv_ret;
  }
  
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
        if ( $lv_usrmsg!='') {
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
  
    public function senOsdeEvl($lp_prm = array() ) {
    $lv_ret= array('errcod'=>-1,'errtxt'=>'E','errtyp'=>'S','data'=>array());
    //https://www.php.net/manual/es/class.soapclient.php
    
    $wsdl=$lp_prm['apiurl']??"https://homologaciones.activiaweb.com.ar/WSActiviaC.asmx/ExecuteFileTransactionSL?pos=0000&fileContent=";
    
    $lv_xmlosd='';
    //$lv_xmlosd.='<xml version="1.0" encoding="ISO-8859-1" standalone="yes">';
    $lv_xmlosd.='<Mensaje>';
      $lv_xmlosd.='<EncabezadoMensaje>';
        $lv_xmlosd.='<VersionMsj>ACT20</VersionMsj>';
        $lv_xmlosd.='<TipoMsj>OL</TipoMsj>';
        $lv_xmlosd.='<TipoTransaccion>02A</TipoTransaccion>';
        $lv_xmlosd.='<IdMsj></IdMsj>';
        $lv_xmlosd.='<InicioTrx>';
          $lv_xmlosd.='<FechaTrx>'.$lp_prm['dte'].'</FechaTrx>';//
          $lv_xmlosd.='<HoraTrx>'.$lp_prm['hur'].'</HoraTrx>';
        $lv_xmlosd.='</InicioTrx>';
        $lv_xmlosd.='<Terminal>';
    			$lv_xmlosd.='<TipoTerminal>Movil</TipoTerminal>';
          $lv_xmlosd.='<NumeroTerminal>60002220</NumeroTerminal>';
          $lv_xmlosd.='<LongitudGPS>'.$lp_prm['gpslon'].'</LongitudGPS>';
          $lv_xmlosd.='<LatitudGPS>'.$lp_prm['gpslat'].'</LatitudGPS>  ';
        $lv_xmlosd.='</Terminal>';
        $lv_xmlosd.='<Software>';
          $lv_xmlosd.='<CodigoSoft>285</CodigoSoft>';
          $lv_xmlosd.='<NombreSoftware>Temasis</NombreSoftware>';
        $lv_xmlosd.='</Software>';
        $lv_xmlosd.='<Financiador>';
          $lv_xmlosd.='<CodigoFinanciador>OSDE</CodigoFinanciador>';
        $lv_xmlosd.='</Financiador>';
        $lv_xmlosd.='<Prestador>';
          $lv_xmlosd.='<CuitPrestador>30699227893</CuitPrestador>';
          $lv_xmlosd.='<RazonSocial>TEAM PEDIATRICO SRL</RazonSocial>';
        $lv_xmlosd.='</Prestador>';
      $lv_xmlosd.='</EncabezadoMensaje>';
      $lv_xmlosd.='<EncabezadoAtencion>';
        $lv_xmlosd.='<Credencial>';
          $lv_xmlosd.='<NumeroCredencial>'.$lp_prm['aficod'].'</NumeroCredencial>';
          $lv_xmlosd.='<VersionCredencial>00</VersionCredencial>';
          $lv_xmlosd.='<ModoIngreso>M</ModoIngreso>';
          $lv_xmlosd.='<CodigoSeguridad>'.$lp_prm['seccod'].'</CodigoSeguridad>';
        $lv_xmlosd.='</Credencial>';
      $lv_xmlosd.='</EncabezadoAtencion>';
      $lv_xmlosd.='<DetalleProcedimientos>'; 
        $lv_xmlosd.='<CodPrestacion>'.$lp_prm['prescod'].'</CodPrestacion>';//420170->OK
        $lv_xmlosd.='<TipoPrestacion>4</TipoPrestacion>';
        $lv_xmlosd.='<CantidadSolicitada>1</CantidadSolicitada>';
      $lv_xmlosd.='</DetalleProcedimientos>';
    $lv_xmlosd.='</Mensaje>';
    $lv_ret['data']['datreq']=$lv_xmlosd;
    $lv_xmlosd = str_replace('/','%2F',$lv_xmlosd );
    $lv_xmlosd = str_replace('<','%3C',$lv_xmlosd );
    $lv_xmlosd = str_replace('>','%3E',$lv_xmlosd );
    $lv_xmlosd = str_replace(' ','%20',$lv_xmlosd );
    $lv_ret['data']['wsdl'] = $wsdl.$lv_xmlosd;
    $curl = curl_init();
    	curl_setopt_array($curl, array(
      CURLOPT_URL => $lv_ret['data']['wsdl'],
      CURLOPT_RETURNTRANSFER => true,
      CURLOPT_ENCODING => '',
      CURLOPT_MAXREDIRS => 10,
      CURLOPT_TIMEOUT => 0,
      CURLOPT_FOLLOWLOCATION => true,
      CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
      CURLOPT_SSL_VERIFYPEER=>0,
			CURLOPT_SSL_VERIFYPEER=>0,
      CURLOPT_CUSTOMREQUEST => 'GET',
    ));

    $response = curl_exec($curl);
    curl_close($curl);
        
    // ejecuto llamada
    /*
		if( !$lo_rs=curl_exec($curl)){
      $lv_ret['data']['curl_error']=curl_error($curl);
      return array('errcod'=>-1,'errtxt'=>'','errtyp'=>'E','data'=>$lv_ret['data']);
    }
    */
		// verifico respuesta de llamada
    $lv_stscod = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    if ($lv_stscod == 200) {
			$lv_ret['data']['datres']=new SimpleXMLElement($response);
      $result= new SimpleXMLElement($lv_ret['data']['datres']);
    }else{
      $lv_ret['data']['cur_info']=curl_getinfo($curl);
    }
    
    if($lv_ret['data']['datres']=='error'){
	  	return array('errcod'=>-1,'errtxt'=>'','errtyp'=>'E','data'=>$lv_ret['data']);
    }
    $encabezadoMensaje = $result->EncabezadoMensaje;
    $rta=get_object_vars($result->EncabezadoMensaje->Rta);
    $lv_ret['errcod']=$rta['CodRtaGeneral'];
    $lv_ret['errtxt']=$rta['MensajeDisplay'];
    $lv_ret['errtyp']=$lv_ret['errcod']=='00'?'S':'E';
    $lv_ret['data']['nroref'] ='';
    
    if(property_exists($encabezadoMensaje, 'RtaAdicional')){
    	$rtaAdicional=get_object_vars($encabezadoMensaje->RtaAdicional);
  		$lv_ret['data']['rtaadic']=trim($rtaAdicional['CodigoRtaAdicional']);
    }else{
    	$lv_ret['data']['rtaadic']='EE';
    }
    if($lv_ret['errtyp']=='S'){
    	$lv_ret['data']['nroref']=trim(get_object_vars($encabezadoMensaje->NroReferencia)[0]);
    }
    return $lv_ret;
  }
  
  public function ZDelOsdeEvl($lp_prm = array() ) {
    $lv_ret= array('errcod'=>-1,'errtxt'=>'E','errtyp'=>'S','data'=>array());
    $wsdl=$lp_prm['apiurl']??"https://homologaciones.activiaweb.com.ar";
    //$client=new SoapClient($wsdl);
    $lv_xmlosd='';
    $lv_xmlosd.='<Mensaje>';
      $lv_xmlosd.='<EncabezadoMensaje>';
        $lv_xmlosd.='<VersionMsj>ACT20</VersionMsj>';
        $lv_xmlosd.='<NroReferenciaCancel>'.$lp_prm['apinroref'].'</NroReferenciaCancel>';
        $lv_xmlosd.='<TipoMsj>OL</TipoMsj>';
        $lv_xmlosd.='<TipoTransaccion>04A</TipoTransaccion>';
        $lv_xmlosd.='<IdMsj/>';
        $lv_xmlosd.='<InicioTrx>';
          $lv_xmlosd.='<FechaTrx>'.$lp_prm['dte'].'</FechaTrx>';
          $lv_xmlosd.='<HoraTrx>'.$lp_prm['hur'].'</HoraTrx>';
        $lv_xmlosd.='</InicioTrx>';
        $lv_xmlosd.='<Terminal>';
          $lv_xmlosd.='<TipoTerminal>Movil</TipoTerminal>';
          $lv_xmlosd.='<NumeroTerminal>60002220</NumeroTerminal>';
        $lv_xmlosd.='</Terminal>';
        $lv_xmlosd.='<Validador/>';
        $lv_xmlosd.='<Financiador>';
        	$lv_xmlosd.='<CodigoFinanciador>OSDE</CodigoFinanciador>';
        $lv_xmlosd.='</Financiador>';
        $lv_xmlosd.='<Prestador>';
          $lv_xmlosd.='<CuitPrestador>30699227893</CuitPrestador>';
        $lv_xmlosd.='</Prestador>';
      $lv_xmlosd.='</EncabezadoMensaje>';
      $lv_xmlosd.='<EncabezadoAtencion>';
        $lv_xmlosd.='<Atencion>';
       	$lv_xmlosd.='<FechaAtencion>'.$lp_prm['evldte'].'</FechaAtencion>';
        $lv_xmlosd.='</Atencion>';
      $lv_xmlosd.='</EncabezadoAtencion>';
    $lv_xmlosd.='</Mensaje>';

    $lv_ret['data']['datreq']=$lv_xmlosd;
    $lv_xmlosd = str_replace('/','%2F',$lv_xmlosd );
    $lv_xmlosd = str_replace('<','%3C',$lv_xmlosd );
    $lv_xmlosd = str_replace('>','%3E',$lv_xmlosd );
    $lv_xmlosd = str_replace(' ','%20',$lv_xmlosd );
    $lv_ret['data']['wsdl'] = $wsdl.$lv_xmlosd;
    $curl = curl_init();
    	curl_setopt_array($curl, array(
      CURLOPT_URL => $lv_ret['data']['wsdl'],
      CURLOPT_RETURNTRANSFER => true,
      CURLOPT_ENCODING => '',
      CURLOPT_MAXREDIRS => 10,
      CURLOPT_TIMEOUT => 0,
      CURLOPT_FOLLOWLOCATION => true,
      CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
      CURLOPT_SSL_VERIFYPEER=>0,
			CURLOPT_SSL_VERIFYPEER=>0,
      CURLOPT_CUSTOMREQUEST => 'GET',
    ));

    $response = curl_exec($curl);
    curl_close($curl);
        
    // ejecuto llamada
    /*
		if( !$lo_rs=curl_exec($curl)){
      $lv_ret['data']['curl_error']=curl_error($curl);
      return array('errcod'=>-1,'errtxt'=>'','errtyp'=>'E','data'=>$lv_ret['data']);
    }
    */
		// verifico respuesta de llamada
    $lv_stscod = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    if ($lv_stscod == 200) {
			$lv_ret['data']['datres']=new SimpleXMLElement($response);
      $result= new SimpleXMLElement($lv_ret['data']['datres']);
    }else{
      $lv_ret['data']['cur_info']=curl_getinfo($curl);
    }
    
    if($lv_ret['data']['datres']=='error'){
	  	return array('errcod'=>-1,'errtxt'=>'','errtyp'=>'E','data'=>$lv_ret['data']);
    }
    $encabezadoMensaje = $result->EncabezadoMensaje;
    $rta=get_object_vars($result->EncabezadoMensaje->Rta);
    $lv_ret['errcod']=$rta['CodRtaGeneral'];
    $lv_ret['errtxt']=$rta['MensajeDisplay'];
    $lv_ret['errtyp']=$lv_ret['errcod']=='00'?'S':'E';
    $lv_ret['data']['nroref'] ='';
    
    if(property_exists($encabezadoMensaje, 'RtaAdicional')){
    	$rtaAdicional=get_object_vars($encabezadoMensaje->RtaAdicional);
  		$lv_ret['data']['rtaadic']=trim($rtaAdicional['CodigoRtaAdicional']);
    }else{
    	$lv_ret['data']['rtaadic']='EE';
    }
    if($lv_ret['errtyp']=='S'){
    	$lv_ret['data']['nroref']=trim(get_object_vars($encabezadoMensaje->NroReferencia)[0]);
    }
    return $lv_ret;   
  }
  
  public function ZsenOsdeEvlDif($lp_prm = array() ) {
    $lv_ret= array('errcod'=>-1,'errtxt'=>'E','errtyp'=>'S','data'=>array());
    //https://www.php.net/manual/es/class.soapclient.php
    $wsdl=$lp_prm['apiurl']??"https://homologaciones.activiaweb.com.ar/WSActiviaC.asmx/ExecuteFileTransactionSL?pos=0000&fileContent=";
    //$client=new SoapClient($wsdl);
    $lv_xmlosd='';
   	$lv_xmlosd.='<Mensaje>';
      $lv_xmlosd.='<EncabezadoMensaje>';
        $lv_xmlosd.='<VersionMsj>ACT20</VersionMsj>';
        $lv_xmlosd.='<TipoMsj>OL</TipoMsj>';
        $lv_xmlosd.='<TipoTransaccion>02D</TipoTransaccion>';
        $lv_xmlosd.='<InicioTrx>';
          $lv_xmlosd.='<FechaTrx>'.$lp_prm['dte'].'</FechaTrx>';
          $lv_xmlosd.='<HoraTrx>'.$lp_prm['hur'].'</HoraTrx>';
        $lv_xmlosd.='</InicioTrx>';
        $lv_xmlosd.='<Terminal>';
          $lv_xmlosd.='<TipoTerminal>Movil</TipoTerminal>';
          $lv_xmlosd.='<NumeroTerminal>60002220</NumeroTerminal>';
        $lv_xmlosd.='</Terminal>';
        $lv_xmlosd.='<Software>';
          $lv_xmlosd.='<CodigoSoft>285</CodigoSoft>';
          $lv_xmlosd.='<NombreSoftware>Temasis</NombreSoftware>';
        $lv_xmlosd.='</Software>';
        $lv_xmlosd.='<Financiador>';
        	$lv_xmlosd.='<CodigoFinanciador>OSDE</CodigoFinanciador>';
        $lv_xmlosd.='</Financiador>';
        $lv_xmlosd.='<Prestador>';
          $lv_xmlosd.='<CuitPrestador>30699227893</CuitPrestador>';
          $lv_xmlosd.='<RazonSocial>TEAM PEDIATRICO SRL</RazonSocial>';
        $lv_xmlosd.='</Prestador>';
      $lv_xmlosd.='</EncabezadoMensaje>';
      $lv_xmlosd.='<EncabezadoAtencion>';
        $lv_xmlosd.='<Credencial>';
          $lv_xmlosd.='<NumeroCredencial>'.$lp_prm['aficod'].'</NumeroCredencial>';
          $lv_xmlosd.='<VersionCredencial>00</VersionCredencial>';
          $lv_xmlosd.='<ModoIngreso>M</ModoIngreso>';
        $lv_xmlosd.='</Credencial>';
        $lv_xmlosd.='<Atencion>';
          $lv_xmlosd.='<FechaAtencion>'.$lp_prm['evldte'].'</FechaAtencion>';
        $lv_xmlosd.='</Atencion>';
      $lv_xmlosd.='</EncabezadoAtencion>';
      $lv_xmlosd.='<DetalleProcedimientos>';
        $lv_xmlosd.='<CodPrestacion>'.$lp_prm['prescod'].'</CodPrestacion>';//420170->OK
        $lv_xmlosd.='<TipoPrestacion>4</TipoPrestacion>';
        $lv_xmlosd.='<CantidadSolicitada>1</CantidadSolicitada>';
      $lv_xmlosd.='</DetalleProcedimientos>';
    $lv_xmlosd.='</Mensaje>';
    $lv_ret['data']['datreq']=$lv_xmlosd;
    
    $lv_xmlosd = str_replace('/','%2F',$lv_xmlosd );
    $lv_xmlosd = str_replace('<','%3C',$lv_xmlosd );
    $lv_xmlosd = str_replace('>','%3E',$lv_xmlosd );
    $lv_xmlosd = str_replace(' ','%20',$lv_xmlosd );
    $lv_ret['data']['wsdl'] = $wsdl.$lv_xmlosd;
    $curl = curl_init();
    	curl_setopt_array($curl, array(
      CURLOPT_URL => $lv_ret['data']['wsdl'],
      CURLOPT_RETURNTRANSFER => true,
      CURLOPT_ENCODING => '',
      CURLOPT_MAXREDIRS => 10,
      CURLOPT_TIMEOUT => 0,
      CURLOPT_FOLLOWLOCATION => true,
      CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
      CURLOPT_SSL_VERIFYPEER=>0,
			CURLOPT_SSL_VERIFYPEER=>0,
      CURLOPT_CUSTOMREQUEST => 'GET',
    ));

    $response = curl_exec($curl);
    curl_close($curl);
        
    // ejecuto llamada
    /*
		if( !$lo_rs=curl_exec($curl)){
      $lv_ret['data']['curl_error']=curl_error($curl);
      return array('errcod'=>-1,'errtxt'=>'','errtyp'=>'E','data'=>$lv_ret['data']);
    }
    */
		// verifico respuesta de llamada
    $lv_stscod = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    if ($lv_stscod == 200) {
			$lv_ret['data']['datres']=new SimpleXMLElement($response);
      $result= new SimpleXMLElement($lv_ret['data']['datres']);
    }else{
      $lv_ret['data']['cur_info']=curl_getinfo($curl);
    }
    
    if($lv_ret['data']['datres']=='error'){
	  	return array('errcod'=>-1,'errtxt'=>'','errtyp'=>'E','data'=>$lv_ret['data']);
    }
    $encabezadoMensaje = $result->EncabezadoMensaje;
    $rta=get_object_vars($result->EncabezadoMensaje->Rta);
    $lv_ret['errcod']=$rta['CodRtaGeneral'];
    $lv_ret['errtxt']=$rta['MensajeDisplay'];
    $lv_ret['errtyp']=$lv_ret['errcod']=='00'?'S':'E';
    $lv_ret['data']['nroref'] ='';
    
    if(property_exists($encabezadoMensaje, 'RtaAdicional')){
    	$rtaAdicional=get_object_vars($encabezadoMensaje->RtaAdicional);
  		$lv_ret['data']['rtaadic']=trim($rtaAdicional['CodigoRtaAdicional']);
    }else{
    	$lv_ret['data']['rtaadic']='EE';
    }
    if($lv_ret['errtyp']=='S'){
    	$lv_ret['data']['nroref']=trim(get_object_vars($encabezadoMensaje->NroReferencia)[0]);
    }
    return $lv_ret; 
  }
  
  public function getOsdePatDat($lp_prm = array() ) {
    $lv_ret= array('errcod'=>-1,'errtxt'=>'E','errtyp'=>'S','data'=>array());
    $wsdl=$lp_prm['apiurl']??'https://homologaciones.activiaweb.com.ar/WSActiviaC.asmx/ExecuteFileTransactionSL?pos=0000&fileContent=';
    //$wsdl='https://wsconectado.activiaweb.com.ar/WSActiviaC.asmx/ExecuteFileTransactionSL?pos=0000&fileContent=';
    //$wsdl='https://wsconectado.activiaweb.com.ar/WSActiviaC.asmx?WSDL';
    
    //$client=new SoapClient($wsdl,array('soap_version'=>SOAP_1_2,'trace'=>true));
    $lv_TipoTransaccion='01A';
    $lv_xmlosd='';
    $lv_xmlosd.='<Mensaje>';
      $lv_xmlosd.='<EncabezadoMensaje>';
        $lv_xmlosd.='<VersionMsj>ACT20</VersionMsj>';//%3C VersionMsj %3E ACT20 %3C%2F VersionMsj %3E
        $lv_xmlosd.='<TipoMsj>OL</TipoMsj>';
        $lv_xmlosd.='<TipoTransaccion>01A</TipoTransaccion>';
        $lv_xmlosd.='<IdMsj/>';
        $lv_xmlosd.='<InicioTrx>';
          $lv_xmlosd.='<FechaTrx>'.$lp_prm['dte'].'</FechaTrx>';
          $lv_xmlosd.='<HoraTrx>'.$lp_prm['hur'].'</HoraTrx>';
        $lv_xmlosd.='</InicioTrx>'; 
        $lv_xmlosd.='<Terminal>';
          $lv_xmlosd.='<TipoTerminal>Movil</TipoTerminal>';
          $lv_xmlosd.='<NumeroTerminal>60002220</NumeroTerminal>';
        $lv_xmlosd.='</Terminal>';
        $lv_xmlosd.='<Software>';
          $lv_xmlosd.='<CodigoSoft>410</CodigoSoft>';
          $lv_xmlosd.='<NombreSoftware>Temasis</NombreSoftware>';
        $lv_xmlosd.='</Software>';
        $lv_xmlosd.='<Financiador>';
          $lv_xmlosd.='<CodigoFinanciador>OSDE</CodigoFinanciador>';	
        $lv_xmlosd.='</Financiador>';
        $lv_xmlosd.='<Prestador>';
          $lv_xmlosd.='<CuitPrestador>30699227893</CuitPrestador>';
          $lv_xmlosd.='<RazonSocial>TEAM PEDIATRICO SRL</RazonSocial>';
        $lv_xmlosd.='</Prestador>';
      $lv_xmlosd.='</EncabezadoMensaje>';
      $lv_xmlosd.='<EncabezadoAtencion>';
        $lv_xmlosd.='<Credencial>';
          $lv_xmlosd.='<NumeroCredencial>'.$lp_prm['aficod'].'</NumeroCredencial>';
          $lv_xmlosd.='<ModoIngreso>M</ModoIngreso>';
          //$lv_xmlosd.='<CodigoSeguridad>'.$lp_prm['seccod'].'</CodigoSeguridad>';
    			$lv_xmlosd.='<CodigoSeguridad></CodigoSeguridad>';
        $lv_xmlosd.='</Credencial>';
      $lv_xmlosd.='</EncabezadoAtencion>';
    $lv_xmlosd.='</Mensaje>';
    $lv_ret['data']['datreq']=$lv_xmlosd;
    $lv_xmlosd = str_replace('/','%2F',$lv_xmlosd );
    $lv_xmlosd = str_replace('<','%3C',$lv_xmlosd );
    $lv_xmlosd = str_replace('>','%3E',$lv_xmlosd );//htmlspecialchars($str);
    $lv_xmlosd = str_replace(' ','%20',$lv_xmlosd );
    
    //$lv_ret['data']['wsdl']= 'https://wsconectado.activiaweb.com.ar/WSActiviaC.asmx/ExecuteFileTransactionSL?pos=0000&fileContent=%3CMensaje%3E%3CEncabezadoMensaje%3E%3CVersionMsj%3EACT20%3C%2FVersionMsj%3E%3CTipoMsj%3EOL%3C%2FTipoMsj%3E%3CTipoTransaccion%3E01A%3C%2FTipoTransaccion%3E%3CIdMsj%2F%3E%3CInicioTrx%3E%3CFechaTrx%3E05052024%3C%2FFechaTrx%3E%3CHoraTrx%3E1556%3C%2FHoraTrx%3E%3C%2FInicioTrx%3E%3CTerminal%3E%3CTipoTerminal%3EMovil%3C%2FTipoTerminal%3E%3CNumeroTerminal%3E60002220%3C%2FNumeroTerminal%3E%3C%2FTerminal%3E%3CSoftware%3E%3CCodigoSoft%3E410%3C%2FCodigoSoft%3E%3CNombreSoftware%3ETemasis%3C%2FNombreSoftware%3E%3C%2FSoftware%3E%3CFinanciador%3E%3CCodigoFinanciador%3EOSDE%3C%2FCodigoFinanciador%3E%3C%2FFinanciador%3E%3CPrestador%3E%3CCuitPrestador%3E30699227893%3C%2FCuitPrestador%3E%3CRazonSocial%3ETEAM%20PEDIATRICO%20SRL%3C%2FRazonSocial%3E%3C%2FPrestador%3E%3C%2FEncabezadoMensaje%3E%3CEncabezadoAtencion%3E%3CCredencial%3E%3CNumeroCredencial%3E60671956201%3C%2FNumeroCredencial%3E%3CModoIngreso%3EM%3C%2FModoIngreso%3E%3CCodigoSeguridad%3E218%3C%2FCodigoSeguridad%3E%3C%2FCredencial%3E%3C%2FEncabezadoAtencion%3E%3C%2FMensaje%3E';
  	//$lv_ret['data']['wsdl'] ='https://wsconectado.activiaweb.com.ar/WSActiviaC.asmx/ExecuteFileTransactionSL?pos=0000&fileContent='.$lv_xmlosd;
    $lv_ret['data']['wsdl'] = $wsdl.$lv_xmlosd;
    $curl = curl_init();
    	curl_setopt_array($curl, array(
      CURLOPT_URL => $lv_ret['data']['wsdl'],
      CURLOPT_RETURNTRANSFER => true,
      CURLOPT_ENCODING => '',
      CURLOPT_MAXREDIRS => 10,
      CURLOPT_TIMEOUT => 0,
      CURLOPT_FOLLOWLOCATION => true,
      CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
      CURLOPT_SSL_VERIFYPEER=>0,
			CURLOPT_SSL_VERIFYPEER=>0,
      CURLOPT_CUSTOMREQUEST => 'GET',
    ));

    $response = curl_exec($curl);
    curl_close($curl);
        
    // ejecuto llamada
    /*
		if( !$lo_rs=curl_exec($curl)){
      $lv_ret['data']['curl_error']=curl_error($curl);
      return array('errcod'=>-1,'errtxt'=>'','errtyp'=>'E','data'=>$lv_ret['data']);
    }
    */
		// verifico respuesta de llamada
    $lv_stscod = curl_getinfo($curl, CURLINFO_HTTP_CODE);
    if ($lv_stscod == 200) {
			$lv_ret['data']['datres']=new SimpleXMLElement($response);
      $result= new SimpleXMLElement($lv_ret['data']['datres']);
    }else{
      $lv_ret['data']['cur_info']=curl_getinfo($curl);
    }
    
    if($lv_ret['data']['datres']=='error'){
	  	return array('errcod'=>-1,'errtxt'=>'','errtyp'=>'E','data'=>$lv_ret['data']);
    }
    $encabezadoMensaje = $result->EncabezadoMensaje;
    $rta=get_object_vars($result->EncabezadoMensaje->Rta);
    $lv_ret['errcod']=$rta['CodRtaGeneral'];
    $lv_ret['errtxt']=$rta['MensajeDisplay'];
    $lv_ret['errtyp']=$lv_ret['errcod']=='00'?'S':'E';
    $lv_ret['data']['nroref'] ='';
    
    if(property_exists($encabezadoMensaje, 'RtaAdicional')){
    	$rtaAdicional=get_object_vars($encabezadoMensaje->RtaAdicional);
  		$lv_ret['data']['rtaadic']=trim($rtaAdicional['CodigoRtaAdicional']);
    }else{
    	$lv_ret['data']['rtaadic']='EE';
    }
    if($lv_ret['errtyp']=='S'){
    	$lv_ret['data']['nroref']=trim(get_object_vars($encabezadoMensaje->NroReferencia)[0]);
    }
    return $lv_ret; 
  }
}
?>

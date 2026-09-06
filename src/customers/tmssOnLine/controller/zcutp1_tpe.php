<?php
final class zcutp1_tpeController extends tmssController { 
	const MODEL = 'zcutp1';
	const VIEW  = 'zcutp1_tpe';
	const ID = '';
  protected $co_reg;
	private $lo_mdl; 
  private $data = array();
 
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; }
 

  /**
   * main method
   */
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session
		if ( $lp_act!='C1' && $lp_act!='C2' ) {
			$this->co_reg->request->post['ajax']='1';
			$lv_lgnbuf = $this->co_reg->user->checkUserLogin();
			if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		}

		// load model
//		$this->lo_mdl = $this->co_reg->load->model( self::MODEL );
		
		$this->data['actcod'] = $lp_act;
		$lo_mdlmovdocmat = $this->co_reg->load->model( 'stkmovdocmat' );

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {			
			
			
			
			
			// ---------------------------------------------------------------------
			//
			//	I M P R E S I O N E S
			//
			// ---------------------------------------------------------------------			
			
			//    P R E S U P U E S T O
			case '#slsordqtapnt':

				// obtengo datos del documento
				$lo_slsordmdl = $this->co_reg->load->model('slsord');
				$lv_slsordcod = (isset($this->co_reg->request->post['slsordcod'])?$this->co_reg->request->post['slsordcod']:$lp_prm['slsordcod']);
				$lo_slsordmdl->load( array('slsordcod'=>$lv_slsordcod) );

				// obtengo nombre de la persona que creó el documento
				$lo_usrmdl = $this->co_reg->load->model('syssecusr');
				$lo_usrmdl->load( array('usrcod'=>$lo_slsordmdl->cteusr) );
				$lo_slsordmdl->cteusrtxt = $lo_usrmdl->usrtxt;

				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' => $this->co_reg->sec,
												'doc' => $this->co_reg->document,
												'data' => $lo_slsordmdl,
												'actcod' => $this->data['actcod'],
												'model' => self::MODEL
												);
				$lv_buffer = 	$this->co_reg->load->view('zcutp1_tpeslsordqtapnt', $lv_prm);
				$this->co_reg->response->addHeader('Content-type:application/pdf');
				return $lv_buffer;
				break;
			
			
			
      case '#hltpatcreplnpdf':
				$lo_post = $this->co_reg->request->post;
        $lo_hltpatcreplnmdl = $this->co_reg->load->model('hltpatcrepln');
        $lo_hltpatmdl = $this->co_reg->load->model( 'hltpat' );
				$lo_txtmdl = $this->co_reg->load->model( 'grldattxt' );
        $lo_hstmdl = $this->co_reg->load->model( 'hltpathst' );
        $lo_busmdl = $this->co_reg->load->model('admbus');

        $lv_patcreplncod = ($lo_post['patcreplncod']??$lp_prm['patcreplncod']??0);
        
				// carga plan de cuidados
        $lo_hltpatcreplnmdl->load( array('patcreplncod'=>$lv_patcreplncod), false );
        $lv_patcod= $lo_hltpatcreplnmdl->patcod;
        
				// cargo datos de paciente
				$lo_hltpatmdl->load( array('patcod'=>$lv_patcod), false );
				$lo_hltpatcreplnmdl->htlpat = $lo_hltpatmdl;
        
				// cargo textos de plan de cuidados
        $lv_prm = array('vewfldflt' =>'[~fltrow~]txtsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_PLA'.chr(9).chr(9).
																			'[~fltrow~]txtsrccod'.chr(9).'='.chr(9).chr(9).$lv_patcreplncod.chr(9).chr(9));
        $lv_txtdat = $lo_txtmdl->getList($lv_prm);
        $lo_hltpatcreplnmdl->txtdat = $lv_txtdat;
					
				// cargo datos de historia clínica
				$lv_prm = array('vewfldflt' =>'[~fltrow~]h.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9),
												'vewfldord' => 'h.ctedte desc',
												'vewmaxrec' =>'100'
												);
				$lo_hstrs = $lo_hstmdl->getDetail( $lv_prm );
        
        // recorro evoluciones hasta encontrar el peso y altura más reciente del paciente	
        $lv_patwgt = "";
        foreach($lo_hstrs as $lv_row){
          $lv_atr = html_entity_decode($lv_row['evlatr001']);
          if($this->co_reg->document->getTagValue($lv_atr,'patwgt') != "" && $lv_patwgt == null){
            $lv_patwgt = $this->co_reg->document->getTagValue($lv_atr,'patwgt');
          }
          if($lv_patwgt != null){
            break;
          }
        }
        $lo_hltpatcreplnmdl->patwgt = $lv_patwgt;
        
        // cargo datos de empresa
        $lo_busmdl->load(array('buscod'=>$this->co_reg->sec->buscod),false);
        
				// genero PDF
        $lv_buffer = 	$this->co_reg->document->getview('ZCUTP1_HLTPATCREPLNPDF', array('data'=>$lo_hltpatcreplnmdl,'bus' => $lo_busmdl) );
        $this->co_reg->response->addHeader('Content-type:application/pdf'); 
        return $lv_buffer;
				break;
			
			
			//    P R E S T A D O R E S
      case "#dshprs":
        $lo_post = $this->co_reg->request->post;
        $lv_prscod = isset($lo_post['prscod']) ? $lo_post['prscod'] : '';
        $lv_tmetot = 0; $lv_qtytot = 0; $lv_lqdtot = 0;
        $lv_plnmthyth = isset($lo_post['plnmthyth']) ? $lo_post['plnmthyth'] : date('m/Y');
        $lv_lqd_mdl = $this->co_reg->load->model('hltprslqd');
        
        // valido que se haya especificado el prestador
        if($lv_prscod){
          // recupero fechas
          $lv_plnyth = trim(explode('/', $lv_plnmthyth)[1]);
          $lv_plnmth = trim(explode('/', $lv_plnmthyth)[0]);
          
          $lv_dtefrm = new DateTime($lv_plnyth. '/'.$lv_plnmth.'/01');
          $lv_dteto = new DateTime($lv_plnyth. '/'.$lv_plnmth.'/01');
          $lv_dteto->modify('last day of this month');

          // busco horas, sesiones y totales del prestador
          $lv_prm = array('vewfldflt' => '[~fltrow~]l.prscod'.chr(9).'='.chr(9).chr(9).$lv_prscod.chr(9).chr(9).
                                    '[~fltrow~]convert(smalldatetime,dbo.gettagvalue(^strdte^,l.HltPrsLqdAtr001),103)'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Y-m-d').chr(9).$lv_dteto->format('Y-m-d').chr(9).
                                    '[~fltrow~]l.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
          $lv_lqd_arr = $lv_lqd_mdl->getList($lv_prm, null, null, false); 
          if(count($lv_lqd_arr)){
            // busco las posiciones de las liquidaciones
            $lv_lqdcod_arr = array();
            foreach($lv_lqd_arr as $lv_row){
              array_push($lv_lqdcod_arr, $lv_row['hltprslqdcod']);
            }

            $lv_lqddoc_mdl = $this->co_reg->load->model('hltprslqddoc');
            $lv_prm = array('vewfldflt' => '[~fltrow~]ld.hltprslqdcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lv_lqdcod_arr).chr(9).chr(9).
                                      '[~fltrow~]ld.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
            $lv_lqddoc_arr = $lv_lqddoc_mdl->getList($lv_prm); 

            foreach($lv_lqddoc_arr as $lv_row){
              $lv_tmetot += $lv_row['hltplnctrtme'];
              $lv_qtytot += $lv_row['hltplnctrqty'];
              $lv_lqdtot += $lv_row['hltprslqddoctot'];
            }
          }

          // incluyo servicios y gastos no liquidados
          /* -------------------------------------------------------------------------------
          	Esta es la parte que hay que cambiar para conseguir las evoluciones.
            Team Pediátrico no tiene una clase de doc que se puede identificar con codext así que
            o crean/hacen una clase "identificable" para agarrar el srcobjtyp desde ahí
            o se cambia esto de acá
          */
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lv_docclscod = '';
          $lv_prm = array('vewfldflt' =>'[~fltrow~]d.sysdocclscodext'.chr(9).''.chr(9).'LQD_EV'.chr(9).chr(9).chr(9).
                                        '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                                        );
          $lv_docclsarr = $lo_docclsmdl->getList( $lv_prm );		// obtengo las clases de documentos definidas para este objeto
          if ( count($lv_docclsarr)>0 ) {											
            $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
          }
          $lo_docclsmdl->load( array('sysdocclscod'=>$lv_docclscod) );

          $lv_prm = array('prscod'=>$lv_prscod, 
                          'hltprslqdstrdte'=>$lv_dtefrm->format('d/m/Y'), 
                          'hltprslqdenddte'=>$lv_dteto->format('d/m/Y'), 
                          'sysdocclscod'=>$lo_docclsmdl->sysdocclscod
                         );
          $lo_opnsvc_rs = $lv_lqd_mdl->getOpenServices( array(), $lv_prm );
          // --------------------------------------------------------------------------------
          $lv_prm = array('prscod'=>$lv_prscod, 
                          'hltprslqdstrdte'=>$lv_dtefrm->format('d/m/Y'), 
                          'hltprslqdenddte'=>$lv_dteto->format('d/m/Y'), 
                         );
          $lo_opnexp_rs = $lv_lqd_mdl->getOpenExpenses( array(), $lv_prm );

          foreach($lo_opnsvc_rs as $lv_row){
            $lv_tmetot += $lv_row['hltplnctrtme'];
            $lv_qtytot += $lv_row['hltplnctrqty'];
            $lv_lqdtot += $lv_row['hltprslqddoctot'];
          }
          foreach($lo_opnexp_rs as $lv_row){
            $lv_lqdtot += $lv_row['hltprslqddoctot'];
          }
        }
        
        $lv_data = array('tmetot' => $lv_tmetot,
                         'qtytot' => $lv_qtytot,
                         'lqdtot' => $lv_lqdtot,
                         'plnmthyth' => $lv_plnmthyth,
                         'prstxt' => htmlentities(isset($lo_post['prstxt'])?$lo_post['prstxt']:''),
                         'prscod' => isset($lo_post['prscod'])?$lo_post['prscod']:'');
        
        // recupero novedades
        $lv_nws_mdl = $this->co_reg->load->model('grlnws');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]n.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
        $lv_data['nws'] = $lv_nws_mdl->getList($lv_prm, null, null, false);
        // cargo datos de cada novedad
        foreach($lv_data['nws'] as &$lv_row){
          $lv_nws_mdl->load(array('nwscod'=>$lv_row['nwscod']),false);
          $lv_row = $lv_nws_mdl->getData();
        }
        unset($lv_row);
        
        return $this->co_reg->document->getView( 'zcutp1_tpedshprs', array('data'=>$lv_data, 'actcod'=>$this->data['actcod']) );
        break;
      /* 
      R E P O R T E S   D E   L I U I D A C I O N E S   A S A N T E
      */
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
        $lo_mdllqd = $this->co_reg->load->model('hltprslqd');
        
				$lv_prmflt = array();
				if($lv_maxrec==false){ 
					$lv_prmflt['vewmaxrec']=$lo_post['vewmaxrec'];
				}
        //LIQUIDACIONES
        $lv_fltarrevl = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        $lv_vewfldord = (isset($lo_post['vewfldord'])&&$lo_post['vewfldord']!='')?$lo_post['vewfldord']:'hltprslqddtecnv desc';
        $lv_vewfldord =str_replace('hltprslqddtecnv','l.hltprslqddte',$lv_vewfldord);
        
				for($i=count($lv_fltarrevl)-1; $i>0; $i--){
					if(stripos(';hltprslqdtxt;hltprslqdcod;hltprslqddtecnv;hltprslqddte;prscod;prstxt;',';'.explode(chr(9),$lv_fltarrevl[$i])[0].';')===false){
						unset($lv_fltarrevl[$i]);
					}else{
            $lv_fltarrevl[$i] = str_replace('hltprslqddtecnv','l.hltprslqddte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('hltprslqddte','l.hltprslqddte',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('hltprslqdcod','l.hltprslqdcod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('hltprslqdtxt','l.hltprslqdtxt',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('prscod','l.prscod',$lv_fltarrevl[$i]);
            $lv_fltarrevl[$i] = str_replace('prstxt','l.prstxt',$lv_fltarrevl[$i]);
          }
				}
				$lv_prmflt = array('vewfldflt' =>'[~fltrow~]l.docsts'.chr(9).'IN'.chr(9).chr(9).'A'.chr(10).'C'.chr(9).chr(9).
																			   (count($lv_fltarrevl)>0?implode('[~fltrow~]',$lv_fltarrevl):''),
													 							'vewmaxrec'=>$lo_post['vewmaxrec'],
                           							'vewfldord' => $lv_vewfldord
												  							);
        $lo_rslqd = $lo_mdllqd->getList($lv_prmflt, null, null, false);
        $lv_data_sqlstm[] = $lo_mdllqd->getsysdata('sqlstm');
        
        // Obtengo los id de liquidacion
        $lo_lqdcodlst=array_column($lo_rslqd, 'hltprslqdcod','hltprslqdcod');
        $lo_prscodlst=array_column($lo_rslqd, 'prscod','prscod');
        
        // MEDIOS DE PAGO
        $lo_tsrpaymthmdl = $this->co_reg->load->model('tsrpaymth');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9). 'A'.chr(9).chr(9));
				$lo_rstsrpaymth = $lo_tsrpaymthmdl->getList($lv_prm);
        $lv_data_sqlstm[] = $lo_tsrpaymthmdl->getsysdata('sqlstm');

        //verificar si $lo_rslqd es correcto o va $lo_rstsrpaymth
        $lo_paymthlst=array_column($lo_rslqd, 'paymthtxt','paymthtxt');
        
        //POSICIONES DE LAS LIQUIDACIONES
        $lo_lqdcodmdl = $this->co_reg->load->model('hltprslqddoc');
        //Ejemplo de agrupamiento
        // La idea es realizar el agripamiento para traer directamente los datos de:
        // 		Subtotal Factura G,Subtotal Horas G, Hon. Debe G,Hon. Haber G y Total
        $lv_prm= array('vewfldflt' =>'[~fltrow~]ld.docsts'.chr(9).'IN'.chr(9).chr(9).'A'.chr(10).'C'.chr(9).chr(9).
																			'[~fltrow~]ld.hltprslqdcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lo_lqdcodlst).chr(9).chr(9),
                        //'vewmaxrec'=>$lo_post['vewmaxrec'],
                        //'vewfldord' => $lv_vewfldord,
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
        //return $lo_rslqddoc; break;
        
        $lo_lqddoctot =[];
        foreach($lo_rslqddoc as $lv_row){
          if(!array_key_exists($lv_row['hltprslqdcod'], $lo_lqddoctot)){
            $lo_lqddoctot[$lv_row['hltprslqdcod']]=array('subfacg'=>0,
                                                          'subhrsg'=>0,
                                                          'subdebg'=>0,
                                                          'subhabg'=>0,
                                                          'tot'=>0,
                                                         );
          }
          $lo_lqddoctot[$lv_row['hltprslqdcod']]['subfacg']=$lv_row['subfacg'];
          $lo_lqddoctot[$lv_row['hltprslqdcod']]['subhrsg']=$lv_row['subhrsg'];
          $lo_lqddoctot[$lv_row['hltprslqdcod']]['subdebg']=$lv_row['subdebg'];
          $lo_lqddoctot[$lv_row['hltprslqdcod']]['subhabg']=$lv_row['subhabg'] * -1;
          $lo_lqddoctot[$lv_row['hltprslqdcod']]['tot']=$lv_row['tot'];
          
          /*
          // Subtotal Factura G
          if($lv_row['hltprslqddoctot']>0){
             $lo_lqddoctot[$lv_row['hltprslqdcod']]['subfacg']+=$lv_row['hltprslqddoctot'];  
          }
          // Subtotal Horas G
          if($lv_row['refobjtyp']=='HLT_PCR' && $lv_row['hltprslqddoctot']>0){
             $lo_lqddoctot[$lv_row['hltprslqdcod']]['subhrsg']+=$lv_row['hltprslqddoctot'];  
          }
          // Hon. Debe G
          if($lv_row['refobjtyp']=='BUY_EXP' && $lv_row['hltprslqddoctot']>0){
             $lo_lqddoctot[$lv_row['hltprslqdcod']]['subdebg']+=$lv_row['hltprslqddoctot'];  
          }
          //Hon. Haber G
          if($lv_row['refobjtyp']=='BUY_EXP' &&  $lv_row['hltprslqddoctot']<0){
             $lo_lqddoctot[$lv_row['hltprslqdcod']]['subhabg']+=$lv_row['hltprslqddoctot'] * -1;  
          }
          //Total
          $lo_lqddoctot[$lv_row['hltprslqdcod']]['tot']+=$lv_row['hltprslqddoctot'];
          */
        }
        
        /* IMPUESTOS */
				/* Filtros*/
				$lo_taxmdl = $this->co_reg->load->model('grldattax');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9). 'A'.chr(9).chr(9).
																			'[~fltrow~]taxsrctyp'.chr(9).'='.chr(9).chr(9). 'HLT_PRS'.chr(9).chr(9).
                       								'[~fltrow~]taxsrccod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lo_prscodlst).chr(9).chr(9)
                       );
				$lo_rstax = $lo_taxmdl->getList($lv_prm);
				$lv_data_sqlstm[]= $lo_taxmdl->getsysdata('sqlstm');
        $lo_taxLst=array();
        foreach($lo_rstax as $lv_rowtax){
          $lo_taxLst[$lv_rowtax['taxsrccod']]=$lv_rowtax;
        }  
        

        $lv_ret=array();
        $lo_lqdlst=[];
        foreach($lo_rslqd as $lv_row){
          $lv_row['hltprslqdtot']=$lv_row['hltprslqdtot']!=null?$lv_row['hltprslqdtot']:'0';
          $lv_row['hltprslqdtot']=number_format($lv_row['hltprslqdtot'], 2, ',', '');
          $lv_buf['taxcod001']='';
          if(isset($lo_taxLst[$lv_row['prscod']])){
            $lv_buf=$lo_taxLst[$lv_row['prscod']];
          }
          
          $lv_buf['paymthtxt']='';
          if(isset($lo_paymthlst[$lv_row['paymthcod']])){
            $lv_buf['paymthtxt']=$lo_paymthlst[$lv_row['paymthcod']];
          }
          
          $lv_buf['subfacg']=0;
          $lv_buf['subhrsg']=0;
          $lv_buf['subdebg']=0;
          $lv_buf['subhabg']=0;
          $lv_buf['tot']=0;
          if(isset($lo_lqddoctot[$lv_row['hltprslqdcod']])){
            $lv_buf['subfacg']=$lo_lqddoctot[$lv_row['hltprslqdcod']]['subfacg'];
            $lv_buf['subhrsg']=$lo_lqddoctot[$lv_row['hltprslqdcod']]['subhrsg'];
            $lv_buf['subdebg']=$lo_lqddoctot[$lv_row['hltprslqdcod']]['subdebg'];
            $lv_buf['subhabg']=$lo_lqddoctot[$lv_row['hltprslqdcod']]['subhabg'];
            $lv_buf['tot']=$lo_lqddoctot[$lv_row['hltprslqdcod']]['tot'];
          }
          $lv_ret[]=array_merge($lv_row,$lv_buf);
           $lo_lqdlst[] = $lv_row['hltprslqdcod'];
        }
        $lv_ret[0]['sqlsmt']=$lv_data_sqlstm;
        ini_set('memory_limit', $lv_lmtmem);
        return $lv_ret; 
      	break;
      case '#grlprmcarupd':
        //https://temasis.com.ar/sysdev/tmssOnLine/index.php?prg=zcutp1_tin&act=grlprmcarupd&prm_mdlcod=TPEVLPRNBL
        $lv_ret = array('errtyp'=>'S','errcod'=>'','errtxt'=>'');
        if(!isset($lp_prm['mdlcod'])){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>'-1','errtxt'=>'No se encontro parametro [mdlcod]') );
        }
        $lo_txtmdl = $this->co_reg->load->model('sysappmdlprm');
        
        if ( !$lo_txtmdl->load($lp_prm['mdlcod'])) {
          return $lo_txtmdl->document->getJson( array('errtyp'=>'E','errcod'=>$lo_txtmdl->errcod,'errtxt'=>$lo_txtmdl->errtxt) );
        }
        $lv_mdlatrval001='';
        $lv_mdlatrval001.='<dtestr>' . (new DateTime('first day of last month'))->format('Y-m-d') . '</dtestr>' ;
        $lv_mdlatrval001.='<dteend>' . (new DateTime('last day of last month'))->format('Y-m-d'). '</dteend>' ;
        $lv_key['mdlcod']=$lo_txtmdl->mdlcod;
        $lv_key['mdlatrval001']=$lv_mdlatrval001;
        $lv_key['docsts']=$lo_txtmdl->docsts;
        
        if ( !$lo_txtmdl->save($lv_key)) {
          return $lo_txtmdl->document->getJson( array('errtyp'=>'E','errcod'=>$lo_txtmdl->errcod,'errtxt'=>$lo_txtmdl->errtxt) );
        }
        
        return $this->co_reg->document->getJson($lv_ret);
        
      	
				break;  
        
      case '#getosdeapi': 
        //https://developers.gorse.ar/index.php?prg=zcutp1_tpe&act=getosdeapi
        $lv_dte = date("Y-m-d H:i:s");
        $lv_curdte = new DateTime($lv_dte);
        $lv_prm=[];
        if(1==2){//desarrorro
          $lv_prm['apiurl']="https://homologaciones.activiaweb.com.ar/WSActiviaC.asmx/ExecuteFileTransactionSL?pos=0000&fileContent=";
          $lv_prm['dte']=$lv_curdte->format('Ymd');//'20250202';
          $lv_prm['evldte']=$lv_curdte->format('Ymd');//'20250202';
          $lv_prm['hur']='1556';
          $lv_prm['gpslon']='-34.499002493371265';
          $lv_prm['gpslat']='-58.54909279401593';
          $lv_prm['aficod']='60671956201';
          $lv_prm['seccod']='218';
        }else{//produccion
          $lv_prm['apiurl']="https://wsconectado.activiaweb.com.ar/WSActiviaC.asmx/ExecuteFileTransactionSL?pos=0000&fileContent=";
          $lv_prm['dte']=$lv_curdte->format('Ymd');//'20250202';
          $lv_prm['evldte']=$lv_curdte->format('Ymd');//'20250202';
          $lv_prm['hur']='1556';
          $lv_prm['gpslon']='-34.499002493371265';
          $lv_prm['gpslat']='-58.54909279401593';
          $lv_prm['aficod']='61151057905';
          $lv_prm['seccod']='000';
        }
        $ctrZcu = $this->co_reg->load->controller('zcutp1');
        $lv_ret = $ctrZcu->senOsdeEvlDif($lv_prm);
        echo "<code>";
        //echo $lv_ret['data']['datreq'];
        var_dump($lv_ret['data']['datres']);
        echo "</code>";
        return '';
        break;
      case '#getosdeapi_v2':
        //https://developers.gorse.ar/index.php?prg=zcutp1_tpe&act=getosdeapi_v2
        $lv_dte = date("Y-m-d H:i:s");
        $lv_curdte = new DateTime($lv_dte);
        $lp_prm=[];
        $wsdl='';
        if(1==1){//desarrollo
          $wsdl="https://homologaciones.activiaweb.com.ar/WSActiviaC.asmx/ExecuteFileTransactionSL?pos=0000&fileContent=";
          $lp_prm['dte']=$lv_curdte->format('Ymd');//'20250202';
          $lp_prm['evldte']=$lv_curdte->format('Ymd');//'20250202';
          $lp_prm['hur']='1556';
          $lp_prm['gpslon']='-34.499002493371265';
          $lp_prm['gpslat']='-58.54909279401593';
          $lp_prm['aficod']='60671956201';
          $lp_prm['seccod']='218';
        }else{//produccion
          $wsdl="https://wsconectado.activiaweb.com.ar/WSActiviaC.asmx/ExecuteFileTransactionSL?pos=0000&fileContent=";
          $lp_prm['dte']=$lv_curdte->format('Ymd');//'20250202';
          $lp_prm['evldte']=$lv_curdte->format('Ymd');//'20250202';
          $lp_prm['hur']='1556';
          $lp_prm['gpslon']='-34.499002493371265';
          $lp_prm['gpslat']='-58.54909279401593';
          $lp_prm['aficod']='61151057905';
          $lp_prm['seccod']='000';
        }
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
            $lv_xmlosd.='<CodPrestacion>420170</CodPrestacion>';//420170->OK
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
        $lv_datres=new SimpleXMLElement($response);
        var_dump($lv_datres);
        return '';
        break;
      case '#patfrmpnt':
        $lo_post = $this->co_reg->request->post;
        
        
        // Busco Paciente
        $mdlPat = $this->co_reg->load->model('hltpat');
				$mdlPat->load(array('patcod'=>$lp_prm['stkmovdoccod']));      
        
        //DATOS CAMPOS  FROMULARIOS
        $lo_datfldmdl = $this->co_reg->load->model('grldatfrmfld');
        $lo_wrklst=[$lp_prm['stkmovdoccod']];
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]f.srcobjcod001'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_wrklst) .chr(9).chr(9),
													 'vewfldord' => 'f.frmdatcod'
													);
        
        $lo_datfld_rs= $lo_datfldmdl->getlist($lv_prmflt);
        $lo_frmdat=array_column($lo_datfld_rs, 'frmdatval','frmdatfldcodext');
        
        //echo '<textarea>'.$lo_datfldmdl->getSysData('sqlstm').'</textarea>';
        //return '';break;        
        $mdlPat->frmdat=$lo_frmdat;
        $lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' => $this->co_reg->sec,
												'doc' => $this->co_reg->document,
												'data' => $mdlPat,
												'actcod' => $this->data['actcod'],
												'model' => self::MODEL
												);
        $lv_buffer = $this->co_reg->document->getView( 'zcutp1_tpepatfrmpnt',$lv_prm );
				$this->co_reg->response->addHeader('Content-type:application/pdf');
        return $lv_buffer;
				break;
      case '#delinfosd':{
        $lv_ret= array('errcod'=>0,'errtxt'=>'error desde DelOsdeEvl','errtyp'=>'S','data'=>array());
        $post=$this->co_reg->request->post;
        $retIsOsde=$this->isOsde($post);
        if(!$retIsOsde['isosde']){
        	$lv_ret['errcod']='-110';
          $lv_ret['errtxt']='No es una evolucion del financiador Osde';
          $lv_ret['errtyp']='W';
        	return $this->co_reg->document->getJson($lv_ret);
        }
        //$retModEvl= $this->modifiEvolution($post,$newVal);
        $post= array_merge($post,$retIsOsde);
        $retDelOsde=$this->DelOsdeEvl($post,true);
        return $this->co_reg->document->getJson($retDelOsde);
        
      }
      // 	EVOLUCION - KINESIOLOGÍA Y SOEP
      case '#evlsoekin':{
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
        $matplncmt='N/I';
        $osdeOrd ='N/I';
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
              $buff=explode( '|', $lp_crepln[0]['matcmt'] );
              $matplncmt= $buff[0]??'NI';
              $osdeOrd=$buff[1]??'NI' ;
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
          $lo_plnmdl->pat->matplncmt=$matplncmt;//'420170'
          $lo_plnmdl->pat->osdeord=$osdeOrd;//'420170'
          //Autorizacion
          
         
          
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
          $lo_plnmdl->pat->osdeord=$osdeOrd;//'420170'
          
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
      }
      case '#evlsoekin01':{
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
      }
		case '#hltpatcreplnrep':
      $lo_post = $this->co_reg->request->post;
      $lv_data_sqlstm = array();
      // EXTRAER DOCSTS
      $lv_docsts = '';
      $lv_fltarr_all = explode('[~fltrow~]', $lo_post['vewfldflt'] ?? '');
      foreach ($lv_fltarr_all as $flt) {
          $parts = explode(chr(9), $flt);
          if (count($parts) >= 3 && preg_match('/docsts$/i', trim($parts[0]))) {
              $lv_docsts = trim($parts[2]);
          }
      }
      // MODELOS
      $lo_plnmdl = $this->co_reg->load->model('hltpatcrepln');
      $lo_posmdl = $this->co_reg->load->model('hltpatcreplnmat');

      // FILTROS CABECERA
      $lv_fltarr = explode('[~fltrow~]', $lo_post['vewfldflt'] ?? '');
      for ($i = count($lv_fltarr)-1; $i >= 0; $i--) {
          if (empty($lv_fltarr[$i])) continue;
          $campo = explode(chr(9), $lv_fltarr[$i])[0];
          if (stripos(';pattxt;patcreplncod;patcreplnstrdte;patcreplnenddte;',
              ';'.$campo.';') === false) {
              unset($lv_fltarr[$i]);
          }
      }
      $lv_prm_pln = array();
      if ($lv_docsts != '') {
          $lv_prm_pln['docsts'] = $lv_docsts;
      }
      $lv_prm_pln['vewfldflt'] = (count($lv_fltarr) > 0 ? implode('[~fltrow~]', $lv_fltarr) : '');
      $lv_prm_pln['vewfldord'] = $lo_post['vewfldord'] ?? '';
      $lv_prm_pln['vewmaxrec'] = ((int)($lo_post['vewmaxrec'] ?? 101)) - 1;
      $lv_plans = $lo_plnmdl->getlist($lv_prm_pln, null, null, false);
      $lv_data_sqlstm[] = $lo_plnmdl->getSysData('sqlstm');

      // FILTROS POSICIONES
      $lv_fltarrmat = explode('[~fltrow~]', $lo_post['vewfldflt'] ?? '');
      for ($i = count($lv_fltarrmat)-1; $i >= 0; $i--) {
          if (empty($lv_fltarrmat[$i])) continue;
          $campo = explode(chr(9), $lv_fltarrmat[$i])[0];
          if (stripos(';matcod;mattxt;',
              ';'.$campo.';') === false) {
              unset($lv_fltarrmat[$i]);
          }
      }
      $lv_prm_pos = array();
      if ($lv_docsts != '') {
          $lv_prm_pos['docsts'] = $lv_docsts;
      }
      $lv_prm_pos['vewfldflt'] = (count($lv_fltarrmat) > 0 ? implode('[~fltrow~]', $lv_fltarrmat) : '');
      $lv_prm_pos['vewmaxrec'] = 10000;
      $lv_pos = $lo_posmdl->getlist($lv_prm_pos);
      $lv_data_sqlstm[] = $lo_posmdl->getsysdata('sqlstm');
      // MAPEAR POSICIONES
      $lv_pos_map = array();
      foreach ($lv_pos as $row) {
          $lv_pos_map[$row['patcreplncod']][] = $row;
      }
      // PREPARO SALIDA
      $lv_ret = array();
      foreach ($lv_plans as $plan) {
          $lv_cod = $plan['patcreplncod'];
          if (!empty($lv_pos_map[$lv_cod])) {
              foreach ($lv_pos_map[$lv_cod] as $pos) {
                  $lvRow = $plan;
                  $lvRow['matcod']    = $pos['matcod'];
                  $lvRow['mattxt']    = $pos['mattxt'];
                  $lvRow['matqty']    = $pos['matqty'];
                  $lvRow['matuntcod']    = $pos['matuntcod'];
                  $lvRow['matfrq']    = $pos['matfrq'];
                  $lvRow['matfrqqty'] = $pos['matfrqqty'];
                  $lvRow['matcmt'] = $pos['matcmt'];
                  $lv_ret[] = $lvRow;
              }
          } else {
              $lvRow = $plan;
              $lvRow['matcod']    = '';
              $lvRow['mattxt']    = '';
              $lvRow['matqty']    = '';
              $lvRow['matuntcod']    = '';
              $lvRow['matfrq']    = '';
              $lvRow['matfrqqty'] = '';
              $lvRow['matcmt']    = '';
              $lv_ret[] = $lvRow;
          }
      }
      if (!empty($lv_ret)) {
          $lv_ret[0]['sqlstm'] = $lv_data_sqlstm;
      }
      return $lv_ret;
        break;
        
      case '#evlsoekin00':{
				$lo_post = $this->co_reg->request->post;
        /*
        $lo_patmdl = $this->co_reg->load->model('hltpat');
        if(!$lo_patmdl->load(array('patcod'=>$lo_post['patcod']),false)){
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_patmdl->errtyp,'errcod'=>$lo_patmdl->errcod,'errtxt'=>$lo_patmdl->errtxt) ); 
        }
        */
        
        $lo_post['evlevl']=isset($lo_post['evlevl'])?(substr($lo_post['evlevl'], 0, 3000)):'';
        $lo_post['evlevl'] = preg_replace('/[<>°]/', '', $lo_post['evlevl']);
        $lo_post['docsts']='A';
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
        $lo_post['evlatr001']=$lo_post['evlatr001']??'';
        $lv_evlinfprc=isset($this->co_reg->request->post['evlinfprc'])?$this->co_reg->request->post['evlinfprc']:'0';
        $lv_evlcncmtv=isset($this->co_reg->request->post['evlcncmtv'])?$this->co_reg->request->post['evlcncmtv']:'';
        $lo_post['evlinfprc']= $lv_evlinfprc;
        $lv_docsts = ( $lv_evlinfprc=='1'?'A':'P' );
        $lo_post['docsts'] = $lv_docsts;
        $lo_post['evlatr001'].='<evlinfprc>'.$this->co_reg->db->sqldata($lv_evlinfprc).'</evlinfprc>';
        $lo_post['evlatr001'].= '<evlcncmtv>'.$lv_evlcncmtv.'</evlcncmtv>';
        
        $lv_ret =[];
        if(1==1){
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
            $lv_prm['osdeord']=$lo_post['osdeord'];
            $lv_prm['aficod']=$lo_datpermdl->hhrmedcovaflnum;//'60671956201';//$lo_patmdl->hhrmedcovaflnum??'60671956201';
            $lv_prm['seccod']=$lo_post['seccod']??'218';
            $lv_ret=[];
            $lv_data = array('now'=>$lv_curdte->format('d/m/Y'),'evldte'=>$lv_evldte->format('d/m/Y'));
            
            if($lv_curdte->format('Ymd')==$lv_evldte->format('Ymd')){
              $lv_ret = $this->senOsdeEvl($lv_prm);  
            }else{
              $lv_ret = $this->senOsdeEvlDif($lv_prm);
          	}
            $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
            if(!$lo_plndtemdl->load(array('plnid'=>$lo_post['plnid'],'plndteid'=>$lo_post['plndteid']))){
              $lo_plndtemdl->prstxt='No encontrado';
              $lo_plndtemdl->pattxt='No encontrado';               
            }
            //cambiar y usar el log nuevo: Ver actividad PatToLG de zcutp1_tin linea 3394
            if(strtoupper($lv_intval['activeLog'])=='X'){
              $lo_applogmdl = $this->co_reg->load->model('sysapplog');
              $lv_errlog=[];
              $lv_errlog['srcobjtyp']='SYS_INT';
              $lv_errlog['srcobjcod001']=$lo_intmdl->sysintcod;
              $lv_errlog['srcobjcod002']='';
              $lv_errlog['applogtxt']='';
              $lv_errlog['mdlcod']='zcutp1';
              $lv_errlog['prgcod']='evlsoekin00';
              $lv_errlog['docsts']='A';
              $lv_errlog['applogerrtyp']=$lv_ret['errtyp'];
              $lv_errlog['applogerrcod']=trim($lv_ret['data']['rtaadic']);
              
              $lv_errlog['applogtecinf']='';
              $lv_errlog['applogtecinf'].='Paciente ('  . $lo_post['patcod'].')'. $lo_plndtemdl->pattxt. PHP_EOL;
              $lv_errlog['applogtecinf'].='Afil. Num. ' . $lv_prm['aficod']. PHP_EOL;
              $lv_errlog['applogtecinf'].='Prestador (' . $lo_post['prscod'].') '. $lo_plndtemdl->prstxt. PHP_EOL;
              $lv_errlog['applogtecinf'].='Cod. Seg. (' . $lv_prm['seccod'].')'. PHP_EOL;
              $lv_errlog['applogtecinf'].='Cod. Pres. [' . $lv_prm['prescod']. PHP_EOL;
              $lv_errlog['applogtecinf'].='Fecha de planificacion '.$lv_evldte->format('d/m/Y'). PHP_EOL;
              $lv_errlog['applogtecinf'].='apinroref='.trim($lv_ret['data']['nroref']). PHP_EOL;
              $lv_errlog['applogtecinf'].='msjdisp='.trim($lv_ret['errtxt']). PHP_EOL;
              
              $lv_errlog['applogerrtxt']='';
              $lv_errlog['applogerrtxt'].=trim($lv_ret['errtxt']);
              $lv_errlog['applogerrtxt'].='</code>';
              $lv_errlog['applogtxt']=$lv_ret['data']['datreq'];
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
                /*
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
                */
                // obtengo mensaje de notificacion
                $lv_txtcodext = 'HLTEVLGRL';
                $lo_txtmdl = $this->co_reg->load->model('grldattxt');

                if( $lo_txtmdl->load(array('txtcodext' => $lv_txtcodext, 'txtsys' => 1), false) ){
                    $lv_usrmsg = $lo_txtmdl->txttxt;
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
    	}
      case '#evlsoekin04':{
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
				$lo_post = $this->co_reg->request->post;
        $lv_ret =[];
        $retIsOsde=$this->isOsde($lo_post);
        if($retIsOsde['isosde']){
        	$lo_post= array_merge($lo_post,$retIsOsde);
        	$retDelOsde=$this->DelOsdeEvl($lo_post,false);
        }	
        $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
        $lo_evlmdl->delete($lo_post, false);
        return $this->co_reg->document->getJson( array('errtyp'=>$lo_evlmdl->errtyp,'errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt) );        
        break;
      }
      case "#evlinfosd":{
        $ret= $this->sendOsde($this->co_reg->request->post);
        return $this->co_reg->document->getJson($ret);
        break;        
      }
    	//Imprecion de evoluciones desde cliente
	    case '#tpeevlpntbch':{
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
      }
        
		}

  }
  
  public function modifiEvolution($lp_prm=array(),$lp_newval=array()){
    $ret= array('errtyp'=>'S','errcod'=>'0','errtxt'=>'');
    $dataPatEvl['evldte']=$lp_newval['evldte']??$dataPatEvl['evldte']->format('Ymd');
    $dataPatEvl= array_merge($dataPatEvl,$lp_newval);
    if (!$mdlPatEvl->save($dataPatEvl)) {
      return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$mdlPatEvl->errcod,'errtxt'=>$mdlPatEvl->errtxt) );
    }
    return $dataPatEvl;
  }
  
  public function isOsde($lp_prm = array()){
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
      $lv_intval['emllstesp']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'spcemllst_'.$lp_prm['spccod']);
      $lv_intval['emllstspcall']=$this->co_reg->document->gettagvalue($lo_intmdl->sysintatr,'spcemllst_*');
      $lv_intval['sysintcod']= $lo_intmdl->sysintcod;

      $lv_intval['cuscod']= $lp_prm['cuscod'];
      $lv_intval['spccnv']=[];
      foreach($lo_intmdl->sysintcnv as $lo_rowcnv){
        $lv_intval['spccnv'][$lo_rowcnv['sysintcnvkey']]=$lo_rowcnv['sysintcnvout001'];
      }
    }
    // Es paciente osde?
    $lv_bolspccod=true;
    if(stripos($lv_intval['spccodlst'], ';'.$lp_prm['spccod'].";")===false){
      $lv_bolspccod=false;
    }
    $lv_bolcuscod=true;
    if(stripos($lv_intval['cuscodlst'], ';'.$lp_prm['cuscod'].";")===false){
      $lv_bolcuscod=false;
    }
    $lv_intval['isosde']=$lv_bolspccod && $lv_bolcuscod;
    return $lv_intval;
  }
  
  public function DelOsdeEvl($lp_prm = array(),$lp_ModEvl=false ) {
    $lv_ret= array('errcod'=>0,'errtxt'=>'','errtyp'=>'S','data'=>array());
    
    /* OBTEGO LA PLANIFICACION */
    $mdlPatEvl = $this->co_reg->load->model('hltpatevl');
    if (!$mdlPatEvl->load($lp_prm)) {
      $lv_ret['errtyp']='E';
      $lv_ret['errcod']=$mdlPatEvl->errcod;
      $lv_ret['errtxt']=$mdlPatEvl->errtxt;
      return $lv_ret;
    }
    if($this->co_reg->document->gettagvalue($mdlPatEvl->evlatr001,'apisenddelok')=='1' || $this->co_reg->document->gettagvalue($mdlPatEvl->evlatr001,'apisendok')=='0' ){
      return $lv_ret;
    }
    $dataPatEvl= $mdlPatEvl->getData();
    
    //Borro el informe en Osde
    $lv_now = date('Ymd');
    $lv_prm=[];
    $lv_prm['dte']=$lv_now ;
    $lv_prm['hur']='1556';
    $lv_prm['apinroref']=$this->co_reg->document->gettagvalue($mdlPatEvl->evlatr001,'apinroref');
    $lv_prm['apiurl']=$lp_prm['apiurl'];
    $lv_prm['evldte']=$mdlPatEvl->evldte->format('Ymd');
    $retDelOsde=$this->SendDelOsde($lv_prm);
    
    //Guardo el log
    $lo_applogmdl = $this->co_reg->load->model('sysapplog');
    $lv_errlog=[];
    $lv_errlog['srcobjtyp']='SYS_INT';
    $lv_errlog['srcobjcod001']=$lp_prm['sysintcod'];
    $lv_errlog['srcobjcod002']='';
    $lv_errlog['applogtxt']='';
    $lv_errlog['mdlcod']='zcutp1';
    $lv_errlog['prgcod']='evlsoekin00';
    $lv_errlog['docsts']='A';
    $lv_errlog['applogerrtyp']=$lv_ret['errtyp'];
    $lv_errlog['applogerrcod']=trim($retDelOsde['errcod']);
    
    $lv_errlog['applogtecinf']='';
    $lv_errlog['applogtecinf'].='Paciente: ('  . $lp_prm['patcod'].')'. $mdlPatEvl->pattxt. PHP_EOL;
    $lv_errlog['applogtecinf'].='Prestador: (' . $lp_prm['prscod'].') '. $mdlPatEvl->prstxt. PHP_EOL;
    $lv_errlog['applogtecinf'].='Evolucion: ' . $lp_prm['evlcod'].' <strong>Motivo: </strong>'. ($lp_ModEvl ? 'Cancelacion': 'Eliminacion' ) . PHP_EOL;
    $lv_errlog['applogtecinf'].='Fecha de evolucion: '.$mdlPatEvl->evldte->format('d/m/Y'). PHP_EOL;
    $lv_errlog['applogtecinf'].='apinroref= '.trim($retDelOsde['data']['nroref']). PHP_EOL;
    $lv_errlog['applogtecinf'].='msjdisp= '.trim($retDelOsde['errtxt']). PHP_EOL;
    
    $lv_errlog['applogerrtxt']='';
    $lv_errlog['applogerrtxt'].'<code>';
    $lv_errlog['applogerrtxt'].=trim($retDelOsde['errtxt']);
    $lv_errlog['applogerrtxt'].='</code>';
    $lv_errlog['applogtxt']=$retDelOsde['data']['datreq'];
    $lo_applogmdl->save($lv_errlog);
    
    $attr='';
    if($lv_ret['errtyp']=='S'){
    	$attr= "<apisenddelok>1</apisenddelok><apidelnroref>".trim($retDelOsde['data']['nroref'])."</apidelnroref><delmsjdisp>".trim($retDelOsde['errtxt'])."</delmsjdisp><delrtaadic>".trim($retDelOsde['data']['rtaadic'])."</delrtaadic>";
    }else{
      $attr= "<apisenddelok>0</apisenddelok><apidelnroref>".$retDelOsde['errtyp']."-".$retDelOsde['errcod']."</apidelnroref><delmsjdisp>".trim($retDelOsde['errtxt'])."</delmsjdisp><delrtaadic>".trim($retDelOsde['data']['rtaadic'])."</delrtaadic>";
    }
		if($lp_ModEvl){
      // Modifico los datos de la evolucion
      $dataPatEvl['evlatr001']= str_replace('<apisendok>1</apisendok>','',$dataPatEvl['evlatr001']);
      $dataPatEvl['evlatr001'].= $attr;
      $dataPatEvl['evldte']=$mdlPatEvl->evldte->format('d/m/Y');
      //Guardo la evolucion
      if (!$mdlPatEvl->save($dataPatEvl)) {
        $lv_ret['errtyp']='E';
        $lv_ret['errcod']=$mdlPatEvl->errcod;
        $lv_ret['errtxt']=$mdlPatEvl->errtxt;
        return $lv_ret;
      }
    }    
    return $lv_ret;
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
    		$lv_xmlosd.='<Preautorizacion>';
          $lv_xmlosd.='<CodigoPreautorizacion>'.$lp_prm['osdeord'].'</CodigoPreautorizacion>';
    		$lv_xmlosd.='</Preautorizacion>';
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
  public function senOsdeEvlDif($lp_prm = array() ) {
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
    		$lv_xmlosd.='<Preautorizacion>';
          $lv_xmlosd.='<CodigoPreautorizacion>'.$lp_prm['osdeord'].'</CodigoPreautorizacion>';
    		$lv_xmlosd.='</Preautorizacion>';
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
  public function SendDelOsde($lp_prm = array() ) {
    $lv_ret= array('errcod'=>-1,'errtxt'=>'E','errtyp'=>'S','data'=>array());
    $wsdl=$lp_prm['apiurl']??"https://homologaciones.activiaweb.com.ar/WSActiviaC.asmx/ExecuteFileTransactionSL?pos=0000&fileContent=";
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
  public function sendOsde($lp_prm){
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
      $lv_prm['osdeord']=$lp_prm['osdeord'];
      $lv_prm['aficod']=$lo_datpermdl->hhrmedcovaflnum;//'60671956201';//$lo_patmdl->hhrmedcovaflnum??'60671956201';
      $lv_prm['seccod']=$lo_post['seccod']??'218';
      $lv_ret=[];
      $lv_data = array('now'=>$lv_curdte->format('d/m/Y'),'evldte'=>$lv_evldte->format('d/m/Y'));

      $lv_ret = $this->senOsdeEvlDif($lv_prm);
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
        $lv_errlog['applogtecinf']='';
        $lv_errlog['applogtecinf'].='Paciente ('  . $lo_post['patcod'].')'. $lo_plndtemdl->pattxt. PHP_EOL;
        $lv_errlog['applogtecinf'].='Afil. Num. ' . $lv_prm['aficod']. PHP_EOL;
        $lv_errlog['applogtecinf'].='Prestador (' . $lo_post['prscod'].') '. $lo_plndtemdl->prstxt. PHP_EOL;
        $lv_errlog['applogtecinf'].='Cod. Seg. (' . $lv_prm['seccod'].')'. PHP_EOL;
        $lv_errlog['applogtecinf'].='Cod. Pres. [' . $lv_prm['prescod']. PHP_EOL;
        $lv_errlog['applogtecinf'].='Fecha de planificacion '.$lv_evldte->format('d/m/Y'). PHP_EOL;
        $lv_errlog['applogtecinf'].='apinroref='.trim($lv_ret['data']['nroref']). PHP_EOL;
        $lv_errlog['applogtecinf'].='msjdisp='.trim($lv_ret['errtxt']). PHP_EOL;

        $lv_errlog['applogerrtxt']='';
        $lv_errlog['applogerrtxt'].=trim($lv_ret['errtxt']);
        $lv_errlog['applogerrtxt'].='</code>';
        $lv_errlog['applogtxt']=$lv_ret['data']['datreq'];
        $lo_applogmdl->save($lv_errlog);
      }
      $lo_post['evlatr001']= str_replace('<apisendok>0</apisendok>','',$lo_post['evlatr001']);
      $lo_post['evlatr001']= str_replace('<apisenddelok>0</apisenddelok>','',$lo_post['evlatr001']);
      
      if($lv_ret['errtyp']=='S'){
        $lo_post['evlatr001'] .= "<apisendok>1</apisendok><apinroref>".trim($lv_ret['data']['nroref'])."</apinroref><msjdisp>".trim($lv_ret['errtxt'])."</msjdisp><rtaadic>".trim($lv_ret['data']['rtaadic'])."</rtaadic><prescod>" . $lv_prm['prescod']."</prescod>";
      }else{
        $lo_post['evlatr001'] .= "<apisendok>0</apisendok><apinroref>".$lv_ret['errtyp']."-".$lv_ret['errcod']."</apinroref><msjdisp>".trim($lv_ret['errtxt'])."</msjdisp><rtaadic>".trim($lv_ret['data']['rtaadic'])."</rtaadic><prescod>" . $lv_prm['prescod']."</prescod>";
      }
      $lo_post['evlatr001']='<row>'.$lo_post['evlatr001'].'</row>';
      // limpio la descripción de la evolución para que no se repita
      $lo_post['evlevl'] = '';
      if(!$lo_evlmdl->save($lo_post, false)){
        return array('errtyp'=>$lo_evlmdl->errtyp,'errcod'=>$lo_evlmdl->errcod,'errtxt'=>$lo_evlmdl->errtxt); 
      }
      return $ret ;
    }
  }
}
?>

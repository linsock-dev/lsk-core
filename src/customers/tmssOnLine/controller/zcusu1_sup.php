<?php
final class zcusu1_supController extends tmssController { 
	const MODEL = 'zcusu1';
	const VIEW  = 'zcusu1';
	const ID = '';
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

		$this->data['actcod'] = $lp_act;
		
		$lp_act = '#' . $lp_act; 
    switch( $lp_act ) {
			
			
			// IMPRESION - REMITO
			case '#stkmovdocpnt':
				
				// obtengo datos del documento
				$lo_stkdocmdl = $this->co_reg->load->model('stkmovdoc');
				$lv_stkmovdoccod = (isset($this->co_reg->request->post['stkmovdoccod'])?$this->co_reg->request->post['stomovdoccod']:$lp_prm['stkmovdoccod']);
				$lo_stkdocmdl->load( array('stkmovdoccod'=>$lv_stkmovdoccod), false );

        if ( $lo_stkdocmdl->docsts!='C' ) {
          return $this->co_reg->document->getJson(array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Debe contabilizar el documento para imprimir el Remito.'));
				}
        
        // cargo datos de obra
        $lo_stesrcmdl = $this->co_reg->load->model('cnsste');
        $lo_stedstmdl = $this->co_reg->load->model('cnsste');
        if( $lo_stkdocmdl->srcobjtyp=='CNS_STE' || $lo_stkdocmdl->dstobjtyp=='CNS_STE' ){
          if($lo_stkdocmdl->srcobjtyp=='CNS_STE'){ $lo_stesrcmdl->load(array('stecod'=>$lo_stkdocmdl->srcobjcod),false); }
          if($lo_stkdocmdl->dstobjtyp=='CNS_STE'){ $lo_stedstmdl->load(array('stecod'=>$lo_stkdocmdl->dstobjcod),false); }
        }

        $lv_buffer = $this->co_reg->document->getView( 'zcusu1_stkmovdocpnt', array('data'=>$lo_stkdocmdl,'actcod'=>$this->data['actcod'], 'stesrc'=>$lo_stesrcmdl, 'stedst'=>$lo_stedstmdl) );
        $this->co_reg->response->addHeader('Content-type:application/pdf'); 
        return $lv_buffer;
				break;
      
      
      // VALE DE SALIDA - CONFIRMACON. confirma la recepción de un documento
      case '#stkmovdoccnfepp':
        $lo_post = $this->co_reg->document->post;
        
        // cargo datos del movimiento
        $lo_movmdl = $this->co_reg->load->model('stkmovdoc');
        $lo_movmdl->load( array('stkmovdoccod'=>$lo_post['stkmovdoccod']), false );
        
        // confirma la recepción
        $lo_movmdl->confirm( $lo_post );
        return $this->co_reg->document->getJson( array('errtyp'=>$lo_movmdl->errtyp,'errcod'=>$lo_movmdl->errcod,'errtxt'=>$lo_movmdl->errtxt) );
        break;
      
      
			// IMPRESION - VALE ENTRADA/SALIDA/TRANSFERENCIA/DEVOLUCION
      case '#stkmovdocvalpnt':
      case '#stkmovdocvaltrspnt':
      case '#stkmovdocvaldevpnt':
				
				// obtengo datos del documento
				$lo_stkdocmdl = $this->co_reg->load->model('stkmovdoc');
				$lv_stkmovdoccod = (isset($this->co_reg->request->post['stkmovdoccod'])?$this->co_reg->request->post['stomovdoccod']:$lp_prm['stkmovdoccod']);
				$lo_stkdocmdl->load( array('stkmovdoccod'=>$lv_stkmovdoccod), false );

        if ( $lo_stkdocmdl->docsts!='C' ) {
          return $this->co_reg->document->getJson(array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Debe contabilizar el documento para imprimir el Remito.'));
				}

        // cargo datos de obra
        $lo_stesrcmdl = $this->co_reg->load->model('cnsste');
        $lo_stedstmdl = $this->co_reg->load->model('cnsste');
        if( $lo_stkdocmdl->srcobjtyp=='CNS_STE' || $lo_stkdocmdl->dstobjtyp=='CNS_STE' ){
          if($lo_stkdocmdl->srcobjtyp=='CNS_STE'){ $lo_stesrcmdl->load(array('stecod'=>$lo_stkdocmdl->srcobjcod),false); }
          if($lo_stkdocmdl->dstobjtyp=='CNS_STE'){ $lo_stedstmdl->load(array('stecod'=>$lo_stkdocmdl->dstobjcod),false); }
        }
        
        // obtengo datos de la empresa
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );

        if ($lp_act=='#stkmovdocvalpnt')	 { $lv_buffer = $this->co_reg->document->getView( 'zcusu1_stkmovdocvalpnt', array('data'=>$lo_stkdocmdl,'datbus'=>$lo_busmdl,'stesrc'=>$lo_stesrcmdl,'stedst'=>$lo_stedstmdl,'actcod'=>$this->data['actcod'],'msgqty'=>(isset($lp_prm['msgqty'])?$lp_prm['msgqty']:1)) ); }
        if ($lp_act=='#stkmovdocvaltrspnt'){ $lv_buffer = $this->co_reg->document->getView( 'zcusu1_stkmovdocvaltrspnt', array('data'=>$lo_stkdocmdl,'datbus'=>$lo_busmdl,'stesrc'=>$lo_stesrcmdl,'stedst'=>$lo_stedstmdl,'actcod'=>$this->data['actcod'],'msgqty'=>(isset($lp_prm['msgqty'])?$lp_prm['msgqty']:1)) ); }
        if ($lp_act=='#stkmovdocvaldevpnt'){ $lv_buffer = $this->co_reg->document->getView( 'zcusu1_stkmovdocvaldevpnt', array('data'=>$lo_stkdocmdl,'datbus'=>$lo_busmdl,'stesrc'=>$lo_stesrcmdl,'stedst'=>$lo_stedstmdl,'actcod'=>$this->data['actcod'],'msgqty'=>(isset($lp_prm['msgqty'])?$lp_prm['msgqty']:1)) ); }
        
        $this->co_reg->response->addHeader('Content-type:application/pdf'); 
        return $lv_buffer;
				break;      
      
      
			// IMPRESION - REMITO EPP
			case '#stkmovdocepppnt':
				
				// MOVIMEINTO. obtengo datos del documento
				$lo_stkdocmdl = $this->co_reg->load->model('stkmovdoc');
        $lv_stkmovdoccod = (isset($this->co_reg->request->post['stkmovdoccod'])?$this->co_reg->request->post['stomovdoccod']:$lp_prm['stkmovdoccod']);
				$lo_stkdocmdl->load( array('stkmovdoccod'=>$lv_stkmovdoccod), false );
        
        if ( $lo_stkdocmdl->docsts!='C' ) {
          return $this->co_reg->document->getJson(array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Debe contabilizar el documento para imprimir el Formulario.'));
				}
				
        // EMPRESA. obtiene empresa
        $lo_busmdl = $this->co_reg->load->model('admbus');
        $lo_busmdl->load(array('buscod'=>$this->co_reg->sec->buscod),false);
				
        // EMPLEADO. obtiene empleado
        $lo_empmdl = $this->co_reg->load->model('hhremp');
        $lo_empmdl->load(array('hhrempcod'=>$lo_stkdocmdl->dstobjcod), false);

				// EMPLEADO - CARGOS. obtengo cargos del empleado en la fecha del documento
				$lo_chrasgmdl = $this->co_reg->load->model('hhrchrasg');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]ca.srcobjtyp'.chr(9).'='.chr(9).chr(9). $lo_stkdocmdl->dstobjtyp .chr(9).chr(9).
																			'[~fltrow~]ca.srcobjcod'.chr(9).'='.chr(9).chr(9). $lo_stkdocmdl->dstobjcod .chr(9).chr(9).
																			'[~fltrow~]ca.hhrchrasgdtestr'.chr(9).'<='.chr(9).chr(9). $lo_stkdocmdl->stkmovdocdte->format('Y-m-d') .chr(9).chr(9).
																			'[~fltrow~]isnull(ca.hhrchrasgdteend,^'.$lo_stkdocmdl->stkmovdocdte->format('Y-m-d').'^)'.chr(9).'>='.chr(9).chr(9). $lo_stkdocmdl->stkmovdocdte->format('Y-m-d') .chr(9).chr(9));
				$lo_rs = $lo_chrasgmdl->getList( $lv_prm, null, null, false );
				$lo_empmdl->chrasg = $lo_rs;

				// MATERIALES. obtengo atributos de materiales
				$lv_matlst=array();
				foreach($lo_stkdocmdl->stkmovdocmat as $lv_row){$lv_matlst[]=$lv_row['matcod'];}
				$lo_matmdl = $this->co_reg->load->model('stkmat');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]m.matcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lv_matlst) .chr(9).chr(9));
				$lo_rs = $lo_matmdl->getList( $lv_prm, null, null, false );
				$lo_stkdocmdl->mat = $lo_rs;
				
        $lv_buffer = $this->co_reg->document->getView( 'zcusu1_stkmovdocepppnt', array('data'=>$lo_stkdocmdl,'bus'=>$lo_busmdl,'emp'=>$lo_empmdl,'actcod'=>$this->data['actcod'],'msgqty'=>(isset($lp_prm['msgqty'])?$lp_prm['msgqty']:1)) );
				$this->co_reg->response->addHeader('Content-type:application/pdf'); 
				return $lv_buffer;
				break;
      
      
			// FORMULARIO INSPECCION / ATS / SEGURIDAD / PRODUCCION / CERTIFICACION
			case '#evtfrmins':case '#evtfrmctrseg':case '#evtfrmats':case '#evtfrmprd':case '#evtfrmcrt':
				$lo_post = $this->co_reg->request->post;
				$this->data['actcod'] = (isset($lo_post['actcod'])?$lo_post['actcod']:'');
        $lo_evtmdl = $this->co_reg->load->model( 'cnssteevt' );
				$lo_evtmdl->create();
        
        if((isset($lo_post['steevtdoccod'])?$lo_post['steevtdoccod']:'')!=''){
					$lo_docmdl = $this->co_reg->load->model('cnssteevtdoc');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]sed.steevtdoccod'.chr(9).'='.chr(9).chr(9).$lo_post['steevtdoccod'].chr(9).chr(9));
					$lo_rs2 = $lo_docmdl->getList( $lv_prm );
          
          if( $this->data['actcod'] == '001' ) {
						$lo_rs2[0]['steevtcod'] = '';
        		$lo_rs2[0]['steevtdoccod'] = '';
					}
          
        	$lo_evtmdl->evtdoc = $lo_rs2;
       	}
			
        switch($lp_act){					
          case '#evtfrmins':
            $lo_evtmdl->stecod = $lo_post['stecod'];
            $lo_evtmdl->sysdocclscod = $lo_post['sysdocclscod'];
            $lo_evtmdl->navbar = isset($lo_post['navbar']) ? 'X':'';
            return $this->co_reg->document->getView( 'zcusu1_evtfrmins', array('data'=>$lo_evtmdl,'actcod'=>$this->data['actcod'], 'oldSec'=>$lo_post['oldSec']) );
            break;
						
          case '#evtfrmctrseg':
            return $this->co_reg->document->getView( 'zcusu1_evtfrmctrseg', array('data'=>$lo_evtmdl,'actcod'=>$this->data['actcod'], 'oldSec'=>$lo_post['oldSec']) );
            break;
						
          case '#evtfrmats':
						$lo_docmdl = $this->co_reg->load->model('cnssteevtdoc');
            $lo_steemprs = array();
            $lo_newrskctr = array();
            $lv_tsk_arr = array();
            if((isset($lo_post['steevtdte'])?$lo_post['steevtdte']:'')!=''){
              // TRABAJADORES
              // buscar evento de asistencia del día
            	$lo_evt2mdl = $this->co_reg->load->model('cnssteevt');
              $lv_prm = array('vewfldflt' =>'[~fltrow~]dc.sysdocclstxt'.chr(9).'='.chr(9).chr(9).'ASISTENCIA'.chr(9).chr(9).
                                            '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).'CNS_EVT'.chr(9).chr(9).
                                            '[~fltrow~]se.steevtdte'.chr(9).'='.chr(9).chr(9). $this->co_reg->db->tsqldate($lo_post['steevtdte']).chr(9).chr(9).
                                            '[~fltrow~]se.stecod'.chr(9).'='.chr(9).chr(9).$lo_post['stecod'].chr(9).chr(9).
                                            '[~fltrow~]dc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                            '[~fltrow~]se.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                           );
              $lo_rs = $lo_evt2mdl->getList($lv_prm, null, null, false);
                
              if(count($lo_rs)>0){
                // TRABAJADORES: busco trabajadores que asistieron
                $lv_prm = array('vewfldflt' =>'[~fltrow~]se.steevtcod'.chr(9).'='.chr(9).chr(9).$lo_rs[0]['steevtcod'].chr(9).chr(9).
                                              '[~fltrow~]sed.srcobjtyp'.chr(9).'='.chr(9).chr(9).'HHR_EMP'.chr(9).chr(9).
                                              '[~fltrow~]dbo.getTagValue(^assflg^,sed.steevtdocatr)'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9).
                                              '[~fltrow~]sed.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                              );
                $lo_steemprs = $lo_docmdl->getList($lv_prm);
              }
            }
            
            if(count($lo_evtmdl->evtdoc)>0){
              // RIESGOS / CONTROLES: textos de las tareas
              $lo_txtmdl = $this->co_reg->load->model('grldattxt');
              // busco textos de riesgos y controles de las tareas  
							$raw_data = $lo_evtmdl->evtdoc[0]['steevtdocatr'];
							// Convertir a UTF-8
              $utf8_data = mb_convert_encoding($raw_data,'UTF-8','iso-8859-1');
							// Decodificar como JSON
							$data_array = json_decode($utf8_data, true);

              $lv_prm = array('vewfldflt' =>'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                            '[~fltrow~]t.txtsrccod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), array_column($data_array['ATS_TSK']['tsklst'], 'cnstskcod')).chr(9).chr(9).
                                            '[~fltrow~]tt.txttypcodext'.chr(9).'IN'.chr(9).chr(9).('CNSTSKRSK'.chr(10).'CNSTSKRSKCTR').chr(9).chr(9)
                  );
              $lo_txtrs = $lo_txtmdl->getList($lv_prm);
              $lv_tsk_arr = $data_array['ATS_TSK']['tsklst'];
              foreach($lv_tsk_arr as &$lv_row){
                $lv_row['txt'] = array('CNSTSKRSK' => '', 'CNSTSKRSKCTR' => '');
                foreach($lo_txtrs as $lv_row2){
                  if($lv_row2['txtsrccod'] == $lv_row['cnstskcod']){
                    $lv_row['txt'][$lv_row2['txttypcodext']] .= $lv_row2['txttxt'];
                  }
                }
              }
              unset($lv_row);              
              // NUEVOS RIESGOS / CONTROLES
              $lo_newrskctr = $data_array['ATS_TSK']['newrskctr'];
            }
            
            
            $lo_evtmdl->tsklst = $lv_tsk_arr;
            $lo_evtmdl->steemp = $lo_steemprs;
            $lo_evtmdl->newrskctr = $lo_newrskctr;

            return $this->co_reg->document->getView( 'zcusu1_evtfrmats', array('data'=>$lo_evtmdl,'actcod'=>$this->data['actcod'], 'oldSec'=>$lo_post['oldSec']) );
            break;	
          case '#evtfrmcrt':
              //cargo el documento
            $lo_cnssteevtdocmdl = $this->co_reg->load->model( 'cnssteevtdoc' );
            $lv_prm = array('vewfldflt' =>'[~fltrow~]sed.srcobjtxt'.chr(9).'='.chr(9).chr(9).'CERTIFICACION'.chr(9).chr(9).
                                            '[~fltrow~]sed.srcobjtyp'.chr(9).'='.chr(9).chr(9).'CNS_EVT_FRM'.chr(9).chr(9).
                                            '[~fltrow~]se.steevtdte'.chr(9).'='.chr(9).chr(9). $this->co_reg->db->tsqldate($lo_post['steevtdte']).chr(9).chr(9).
                                            '[~fltrow~]sed.steevtcod'.chr(9).'='.chr(9).chr(9).$lo_post['steevtcod'].chr(9).chr(9).
                                            '[~fltrow~]se.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                            '[~fltrow~]sed.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                           );
            $lo_rs = $lo_cnssteevtdocmdl->getList($lv_prm);
            $lo_evtmdl->cnssteevtdoc=$lo_rs;
            return $this->co_reg->document->getView( 'zcusu1_evtfrmcrt', array('data'=>$lo_evtmdl,'actcod'=>$this->data['actcod'], 'oldSec'=>$lo_post['oldSec']) );
            break;
          case '#evtfrmprd':
             //cargo el documento
            $lo_cnssteevtdocmdl = $this->co_reg->load->model( 'cnssteevtdoc' );
            $lv_prm = array('vewmaxrec' =>'100',
                            'vewfldflt' =>  '[~fltrow~]sed.steevtcod'.chr(9).'='.chr(9).chr(9).$lo_post['steevtcod'].chr(9).chr(9).
                                            '[~fltrow~]sed.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                           );
            $lo_rs = $lo_cnssteevtdocmdl->getList($lv_prm);
            $lo_evtmdl->cnssteevtdoc=$lo_rs;
            //cargo clase de documento
            $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
            $lo_evtmdl->sysdocclscod = $lo_post['sysdocclscod'];
            if ( $lo_docclsmdl->load( array('sysdocclscod'=>$lo_evtmdl->sysdocclscod) ) ) {
							$lo_evtmdl->sysdoccls = $lo_docclsmdl;
						}
            //recupero liquidacion
            // Extraer los valores del campo 'steevtdoccod'
            $lv_cod_arr = array_column($lo_rs, 'steevtdoccod');
            // Concatenar los valores separados por coma
            $lv_codlstflt = implode(';', $lv_cod_arr);
            $lo_cnsprslqddocmdl = $this->co_reg->load->model( 'cnsprslqddoc' );
          	$lv_prm2 = array('vewmaxrec' =>'100',
                            'vewfldflt' =>'[~fltrow~]ld.refobjcod001'.chr(9).'IN'.chr(9).chr(9).str_ireplace(';',chr(10),($lv_codlstflt??'')).chr(9).chr(9)
                          );
            $lo_rs2 = $lo_cnsprslqddocmdl->getList($lv_prm2);
            // Iterar sobre el primer array
            foreach ($lo_rs as &$lv_row) {
                // Buscar coincidencias en el segundo array
                foreach ($lo_rs2 as $lv_row2) {
                    if ($lv_row['steevtdoccod'] == $lv_row2['refobjcod001']) {
                        $lv_row['cnsprslqdcod'] = $lv_row2['cnsprslqdcod'];
                        break; 
                    }
                }
            }
            $lo_evtmdl->cnssteevtdoc=$lo_rs;
            
            return $this->co_reg->document->getView( 'zcusu1_evtfrmprd', array('data'=>$lo_evtmdl,'actcod'=>$this->data['actcod'], 'oldSec'=>$lo_post['oldSec']) );
            break;
					}
				break;
      
      // Liquidacion - Reporte SS
      case '#rptlqdcns':
     		$lo_post = $this->co_reg->request->post;
        $lv_vewfldflt = ($lo_post['vewfldflt']??'');
        if(stripos($lv_vewfldflt,'cnsprslqdstrdte') == false || stripos($lv_vewfldflt,'cnsprslqdenddte') == false){
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Indique un período.') );
        }
        
        $lv_vewflt  = ('[~fltrow~]se.steevtdte'.chr(9).'BT'.chr(9).chr(9).'cnsprslqdstrdte'.chr(9).'cnsprslqdenddte'.chr(9)
          						.'[~fltrow~]ISNULL(ld.cnsprslqdcod,^^)'.chr(9).'='.chr(9).chr(9).''.chr(9).chr(9));
        $lv_fltarr = explode( '[~fltrow~]', $lv_vewfldflt );
        foreach($lv_fltarr as $lv_rowarr){
          if(stripos($lv_rowarr,'cnsprslqdstrdte')!==false ){   
            $lv_fltdte = explode('=', $lv_rowarr);
           	$lv_fltdte = trim($lv_fltdte[1]);
            $lv_vewflt = str_replace('cnsprslqdstrdte',$lv_fltdte,$lv_vewflt);
          } else if(stripos($lv_rowarr,'cnsprslqdenddte')!==false ){
            $lv_fltdte = explode('=', $lv_rowarr);
           	$lv_fltdte = trim($lv_fltdte[1]);
            $lv_vewflt = str_replace('cnsprslqdenddte',$lv_fltdte,$lv_vewflt);
          }
       	}
      	$lv_vewmaxrec = ($lo_post['vewmaxrec']??'100');
        $lv_vewfldord = ($lo_post['vewfldord']??'');
        $lo_cnsprslqdmdl = $this->co_reg->load->model('cnsprslqd');
        $lo_cnsprslqdmdl->opnsrv = array();

        $lv_prm = array('vewmaxrec' =>$lv_vewmaxrec,
												'vewfldflt' =>$lv_vewflt,
                       	'vewfldord'=> $lv_vewfldord);
        $lo_rs = $lo_cnsprslqdmdl->getOpenServices($lv_prm);
        
        $lv_prctot = 0;
        $lv_sqdtot= 0 ;
        $lv_retarr = array();
      	foreach($lo_rs as $lv_row){
          $lv_tmp = json_decode(mb_convert_encoding($lv_row['steevtdocatr'], 'UTF-8', 'ISO-8859-1'),true);
          $lv_tmp = mb_convert_encoding($lv_tmp, 'ISO-8859-1', 'UTF-8');
					$lv_tmp['stetxt']=$lv_row['stetxt'];
					$lv_tmp['stecod']=$lv_row['stecod'];
					$lv_tmp['steevtcod']=$lv_row['steevtcod'];
          $lv_tmp['steevtdtetxt']=$lv_row['steevtdtetxt'];
          $lv_tmp['tskprcbse']=isset($lv_tmp['tskprcbse']) && $lv_tmp['tskprcbse']!='' ? $lv_tmp['tskprcbse'] : 0;
          $lv_tmp['tskrec']=isset($lv_tmp['tskrec']) && $lv_tmp['tskrec']!='' ? $lv_tmp['tskrec'] : 0;
          $lv_tmp['tsktot']=isset($lv_tmp['tsktot']) && $lv_tmp['tsktot']!='' ? $lv_tmp['tsktot'] : 0;
          $lv_retarr[] = $lv_tmp;
          $lv_prctot += $lv_tmp['tsktot'];
          if(!isset($lv_sqd[$lv_row['stecod']])){
            $lv_sqd[$lv_row['stecod']]='1';
          	$lv_sqdtot +=1 ;
          } 
        }
        
        if($lv_sqdtot){
        	//Acomodo las keys del array para el return
          $lv_keys = array_keys($lv_retarr[0]); 
          $lv_total = array_fill_keys($lv_keys, '0'); 

          // Sobrescribe los valores específicos
          $lv_total['sqdtxt'] = 'TOTAL OBRAS';
          $lv_total['stetxt'] = $lv_sqdtot;
          $lv_total['tsktot'] = $lv_prctot;

          $lv_retarr[] = $lv_total;
        }
        
        return $lv_retarr;
      break;
        
			//CONTRATO PRD / CRT
      case '#slslstprccod':
        $lo_post = $this->co_reg->request->post;
        $lo_cnsstemdl = $this->co_reg->load->model( 'cnsste' );
        $lo_slssvcmdl = $this->co_reg->load->model( 'slssvc' );
				//añadir validaciones
        if($lo_cnsstemdl->load( array('stecod'=>$lo_post['stecod']),false )==false ){
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_cnsstemdl->errtyp,'errcod'=>$lo_cnsstemdl->errcod,'errtxt'=>$lo_cnsstemdl->errtxt) );
        }
        $lv_cnsstestr=$lo_cnsstemdl->cnssteatr;
        $lv_slssvccodext=$this->co_reg->document->getTagValue( $lv_cnsstestr, 'ATR_NCT');
        if($lv_slssvccodext==''){
        	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'LA OBRA NO TIENE CONTRATO ASOCIADO') );
        }
        //recupero contrato con codigo externo
        $lv_prm = array('vewmaxrec' =>'10',
												'vewfldflt' => '[~fltrow~]o.slssvccodext'.chr(9).'='.chr(9).chr(9).$lv_slssvccodext.chr(9).chr(9).
																			'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_slssvcdat = $lo_slssvcmdl->getList($lv_prm, null, null, false);
        if(count($lo_slssvcdat)==0){ 
        	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_slssvcmdl->errcod,'errtxt'=>'ID DE CONTRATO INVALIDO. ') );
        }
        if(count($lo_slssvcdat)>1){
        	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_slssvcmdl->errcod,'errtxt'=>'SE ENCONTRO MAS DE UN CONTRATO CON ESE CODIGO DE CONTRATO ASOCIADO A LA OBRA. ') );
        }
        //recuper codigo de lista de precio
        $lv_slsprclstcod=$lo_slssvcdat[0]['slsprclstcod'];
        if($lv_slsprclstcod==''){
        	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'EL CONTRATO NO TIENE LISTA DE PRECIOS ASOCIADA') );
        }
        //recupero coef de incremento
        $lv_slsprcancvar=$this->co_reg->document->getTagValue( $lo_slssvcdat[0]['slssvcatr'], 'atr_ancvar' );
        if($lv_slsprcancvar==''){
        	return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'EL CONTRATO NO TIENE DEFINIDO EL COEF') );
        }
        return $this->co_reg->document->getJson(array('slsprclstcod'=>$lv_slsprclstcod,'slsprcancvar'=>$lv_slsprcancvar));
        break;
        
        
      	//IMPRESION DE CERTIFICACION tareas/maeteriales
       case '#evtfrmcrtpnt':case '#evtfrmcrtmatpnt':            
				$lo_post = $this->co_reg->request->post;
				$lv_evtcod = (isset($lo_post['steevtcod'])?$lo_post['steevtcod']:$lp_prm['steevtcod']);
				// EVENTO. cargo el evento de certificacion
				$lo_evtmdl = $this->co_reg->load->model('cnssteevt');
				$lo_evtmdl->load( array('steevtcod'=>$lv_evtcod), false );
        
        //DOCUMENTO. cargo documento del formulario del evento
        $lo_cnssteevtdocmdl = $this->co_reg->load->model( 'cnssteevtdoc' );
            $lv_prm = array('vewfldflt' =>'[~fltrow~]sed.srcobjtxt'.chr(9).'='.chr(9).chr(9).'CERTIFICACION'.chr(9).chr(9).
                                            '[~fltrow~]sed.srcobjtyp'.chr(9).'='.chr(9).chr(9).'CNS_EVT_FRM'.chr(9).chr(9).
                                            '[~fltrow~]se.steevtdte'.chr(9).'='.chr(9).chr(9). $this->co_reg->db->tsqldate($lo_evtmdl->steevtdte->format('d/m/Y')).chr(9).chr(9).
                                            '[~fltrow~]sed.steevtcod'.chr(9).'='.chr(9).chr(9).$lv_evtcod.chr(9).chr(9).
                                            '[~fltrow~]se.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                            '[~fltrow~]sed.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                           );
        $lo_rs = $lo_cnssteevtdocmdl->getList($lv_prm);
        $lo_evtmdl->cnssteevtdoc=$lo_rs;
            
				
				// OBRA. cargo datos de la obra
				$lo_stemdl = $this->co_reg->load->model('cnsste');
				$lo_stemdl->load( array('stecod'=>$lo_evtmdl->stecod), false );
        
        // CONTRATO. cargo datos de la obra
        $lv_steatr=$lo_stemdl->cnssteatr;
        $lv_slssvccodext=$this->co_reg->document->getTagValue( $lv_steatr, 'ATR_NCT');
        $lo_stemdl->slssvccodext=$lv_slssvccodext;   
        
        // CONTACTOS de las obras
        $lo_cntmdl = $this->co_reg->load->model( 'grldatcnt' );
        $lv_prm = array('vewfldflt'=>	'[~fltrow~]c.cntsrccod'.chr(9).'='.chr(9).chr(9).$lo_evtmdl->stecod.chr(9).chr(9).
																			'[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9). 'CNS_STE' .chr(9).chr(9).
																			'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9) );
				$lo_stemdl->stecnt = $lo_cntmdl->getList( $lv_prm, null, null, false );

        // EMPRESA. obtiene empresa
        $lo_busmdl = $this->co_reg->load->model('admbus');
        $lo_busmdl->load(array('buscod'=>$this->co_reg->sec->buscod),false);
        if($lp_act=='#evtfrmcrtpnt'){
        	$lv_buffer = $this->co_reg->document->getView( 'zcusu1_evtfrmcrtpnt', array('data'=>$lo_evtmdl, 'ste'=>$lo_stemdl,'bus'=>$lo_busmdl,'actcod'=>$this->data['actcod'],'msgqty'=>(isset($lp_prm['msgqty'])?$lp_prm['msgqty']:1)) );
        }else if($lp_act=='#evtfrmcrtmatpnt'){
        	$lv_buffer = $this->co_reg->document->getView( 'zcusu1_evtfrmcrtmatpnt', array('data'=>$lo_evtmdl, 'ste'=>$lo_stemdl,'bus'=>$lo_busmdl,'actcod'=>$this->data['actcod'],'msgqty'=>(isset($lp_prm['msgqty'])?$lp_prm['msgqty']:1)) );
        }
				$this->co_reg->response->addHeader('Content-type:application/pdf'); 
        return $lv_buffer;
        break;

			// IMPRESION - FORMULARIO ATS / INSPECCION / SEGURIDAD
			case '#evtfrminspnt':case '#evtfrmctrsegpnt':case '#evtfrmatspnt': 
        
				ini_set('memory_limit', '1000M');
				$lo_post = $this->co_reg->request->post;
				$lv_evtcod = (isset($lo_post['steevtcod'])?$lo_post['steevtcod']:$lp_prm['steevtcod']);
        
				// EVENTO. cargo el evento de inspeccion
				$lo_evtmdl = $this->co_reg->load->model('cnssteevt');
				$lo_evtmdl->load( array('steevtcod'=>$lv_evtcod), false );
				
				// OBRA. cargo datos de la obra
				$lo_stemdl = $this->co_reg->load->model('cnsste');
				$lo_stemdl->load( array('stecod'=>$lo_evtmdl->stecod), false );

				// DOMICILIO
        $lo_adrmdl = $this->co_reg->load->model( 'grldatadr' );
				$lv_adrapikey = $lo_adrmdl->getApiKey();
				$lo_stemdl->adrapikey = $lv_adrapikey;
				
        // CONTACTOS de las obras
        $lo_cntmdl = $this->co_reg->load->model( 'grldatcnt' );
        $lv_prm = array('vewfldflt'=>	'[~fltrow~]c.cntsrccod'.chr(9).'='.chr(9).chr(9).$lo_evtmdl->stecod.chr(9).chr(9).
																			'[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9). 'CNS_STE' .chr(9).chr(9).
																			'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9) );
				$lo_stemdl->stecnt = $lo_cntmdl->getList( $lv_prm, null, null, false );

				// ASISTENCIA. buscar evento de asistencia del día
				$lo_evtassmdl = $this->co_reg->load->model('cnssteevt');
				$lo_evtdocmdl = $this->co_reg->load->model('cnssteevtdoc');
				$lo_stemdl->ass = array();
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dc.sysdocclstxt'.chr(9).'='.chr(9).chr(9).'ASISTENCIA'.chr(9).chr(9).
																			'[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).'CNS_EVT'.chr(9).chr(9).
																			'[~fltrow~]se.steevtdte'.chr(9).'='.chr(9).chr(9). date_format($lo_evtmdl->steevtdte,'Y-m-d').chr(9).chr(9).
																			'[~fltrow~]se.stecod'.chr(9).'='.chr(9).chr(9).$lo_evtmdl->stecod.chr(9).chr(9).
																			'[~fltrow~]dc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]se.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
										 );
				$lo_rs = $lo_evtassmdl->getList($lv_prm, null, null, false);
       
				// busco trabajadores que asistieron
				if(count($lo_rs)>0){
          
					$lv_prm = array('vewfldflt' =>'[~fltrow~]se.steevtcod'.chr(9).'='.chr(9).chr(9).$lo_rs[0]['steevtcod'].chr(9).chr(9).
																				'[~fltrow~]sed.srcobjtyp'.chr(9).'='.chr(9).chr(9).'HHR_EMP'.chr(9).chr(9).
																				'[~fltrow~]dbo.getTagValue(^assflg^,sed.steevtdocatr)'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9).
																				'[~fltrow~]sed.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
												);
					$lo_rsass = $lo_evtdocmdl->getList($lv_prm);
					$lv_emplst = '';
					foreach($lo_rsass as $lv_row){ $lv_emplst.=($lv_emplst==''?'':chr(10)).$lv_row['srcobjcod']; }
					
					$lo_taxmdl = $this->co_reg->load->model('grldattax');
					$lv_prm = arraY('vewfldflt'=>'[~fltrow~]t.taxsrctyp'.chr(9).'='.chr(9).chr(9).'HHR_EMP'.chr(9).chr(9).
																			'[~fltrow~]t.taxsrccod'.chr(9).'IN'.chr(9).chr(9).$lv_emplst.chr(9).chr(9) );
					$lo_rstax = $lo_taxmdl->getList($lv_prm);
					
					// completo el empleado con el nro de documento
					$lv_out = array();
					foreach($lo_rsass as $lv_row){
						foreach($lo_rstax as $lv_rowtax){
							if($lv_rowtax['taxsrccod']==$lv_row['srcobjcod']){ $lv_row['taxiibb']=$lv_rowtax['taxiibb']; break; }
						}
						$lv_out[] = $lv_row;
					}
					$lo_stemdl->ass = $lv_out;
				}

				// ADJUNTOS. cargo y serializo adjuntos de la inspeccion
				$lo_flecnt = array();
				$lo_flemdl = $this->co_reg->load->model('grldatupl');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]f.flesrccod'.chr(9).''.chr(9).$lv_evtcod.chr(9).chr(9).chr(9).
																			'[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9).'CNS_EVT'.chr(9).chr(9)
												);
				$lo_rs = $lo_flemdl->getList( $lv_prm );
				foreach($lo_rs as $lv_row){
					$lo_flecnt[ $lv_row['flecod'] ] = $lo_flemdl->getfilecontents( array('flecod'=>$lv_row['flecod']) );
				}				
				$lo_stemdl->flecnt = $lo_flecnt;
				
        // EMPRESA. obtiene empresa
        $lo_busmdl = $this->co_reg->load->model('admbus');
        $lo_busmdl->load(array('buscod'=>$this->co_reg->sec->buscod),false);
        
        //-------------------------------------------------------------------------------------------------------------
				if(count($lo_evtmdl->evtdoc)>0 && $lp_act=='#evtfrmatspnt' ){
             
          $raw_data = ($lo_evtmdl->evtdoc[0]['steevtdocatr'] ?? '');           
          $utf8_data = mb_convert_encoding($raw_data, 'UTF-8', 'ISO-8859-1');
          $data_array = json_decode($utf8_data, true);
    
          $lo_cnsrskctr = $this->co_reg->load->model('cnsrskctr');
         
          $lv_tsk_arr = $data_array['ATS_TSK']['tsklst'] ?? [];
				
          
          foreach ($lv_tsk_arr as &$lv_row) {
              $lv_row['txt'] = ['CNSTSKRSK' => '', 'CNSTSKRSKCTR' => ''];

              $lv_rsk_ids = $lv_row['rsklst'] ?? [];
              $lv_ctr_ids = $lv_row['ctrlst'] ?? [];
             

              //  Obtener descripciones de los riesgos
              if (!empty($lv_rsk_ids)) {
                  $lv_prm = array(
                      'vewfldflt' => '[~fltrow~]cnsrskctrcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lv_rsk_ids).chr(9).chr(9)
                  );
                  $lp_rskrs = $lo_cnsrskctr->getList($lv_prm, null, null, false);
                  $lv_row['txt']['CNSTSKRSK'] = implode("\n", array_column($lp_rskrs, 'cnsrskctrtxt'));
              }

              //  Obtener descripciones de los controles
              if (!empty($lv_ctr_ids)) {
                  $lv_prm = array(
                      'vewfldflt' => '[~fltrow~]cnsrskctrcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lv_ctr_ids).chr(9).chr(9)
                  );
                  $lp_ctrrs = $lo_cnsrskctr->getList($lv_prm, null, null, false);
                  $lv_row['txt']['CNSTSKRSKCTR'] = implode("\n", array_column($lp_ctrrs, 'cnsrskctrtxt'));
              }
          }
          unset($lv_row);
          $lo_evtmdl->tsklst = $lv_tsk_arr;
        
      	}
        //-------------------------------------------------------------------------------------------------------------
        
				// IMPRESION
				if($lp_act=='#evtfrmctrsegpnt'){
        $lv_buffer = $this->co_reg->document->getView( 'zcusu1_evtfrmctrsegpnt', array('data'=>$lo_evtmdl, 'ste'=>$lo_stemdl,'fle'=>$lo_flemdl,'bus'=>$lo_busmdl,'actcod'=>$this->data['actcod'],'msgqty'=>(isset($lp_prm['msgqty'])?$lp_prm['msgqty']:1)) );
				}else if($lp_act=='#evtfrminspnt'){
        $lv_buffer = $this->co_reg->document->getView( 'zcusu1_evtfrminspnt', array('data'=>$lo_evtmdl, 'ste'=>$lo_stemdl,'fle'=>$lo_flemdl,'bus'=>$lo_busmdl,'actcod'=>$this->data['actcod'],'msgqty'=>(isset($lp_prm['msgqty'])?$lp_prm['msgqty']:1)) );
				}else if($lp_act=='#evtfrmatspnt'){
        $lv_buffer = $this->co_reg->document->getView( 'zcusu1_evtfrmatspnt', array('data'=>$lo_evtmdl, 'ste'=>$lo_stemdl,'fle'=>$lo_flemdl,'bus'=>$lo_busmdl,'actcod'=>$this->data['actcod'],'msgqty'=>(isset($lp_prm['msgqty'])?$lp_prm['msgqty']:1), 'stk'=>$lv_tsk_arr) );
				}
				$this->co_reg->response->addHeader('Content-type:application/pdf'); 
				return $lv_buffer;
				break;
				
				
			//   O R D E N   D E   C O M P R A
			case '#buyordordpnt':
				$lo_post = $this->co_reg->request->post;
				
				// obtengo datos del documento
				$lo_buyordmdl = $this->co_reg->load->model('buyord');
				$lv_buyordcod = (isset($lo_post['buyordcod'])?$lo_post['buyordcod']:$lp_prm['buyordcod']);
				$lo_buyordmdl->load( array('buyordcod'=>$lv_buyordcod), false );
        
        // obtengo proveedor
        $lo_buysup = $this->co_reg->load->model('buysup');
        $lo_buysup->load( array('supcod'=>$lo_buyordmdl->srcobjcod), false );
        $lo_buyordmdl->sup = $lo_buysup;
				
        // obtengo el texto de asistentes
        $lo_grldattxtmdl = $this->co_reg->load->model('grldattxt');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]tt.txttypcodext'.chr(9).'='.chr(9).chr(9).'ASSISTENTES'.chr(9).chr(9).
                        							'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'BUY_ORD'.chr(9).chr(9).
                                      '[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).$lv_buyordcod.chr(9).chr(9)
                       ); 
        $lo_rs = $lo_grldattxtmdl->getList( $lv_prm );
				if(count($lo_rs)>0){
					$lo_buyordmdl->asstxt = $lo_rs[0];
				} else {
					$lo_buyordmdl->asstxt = array();
				}
        
        $lv_buffer = $this->co_reg->document->getView('zcusu1_buyordordpnt', array('data'=>$lo_buyordmdl,'actcod'=>$this->data['actcod']));
				$this->co_reg->response->addHeader('Content-type:application/pdf');
				return $lv_buffer;
				break;
    
				//  L I Q U I D A C I O N   D E   P R E S T A D O R E S    I M P R E S I O N
			case '#cnsprslqdpnt':
				$lo_post = $this->co_reg->request->post;
				
				// obtengo datos del documento
				$lo_cnsprslqdmdl = $this->co_reg->load->model('cnsprslqd');
				$lv_cnsprslqdcod = (isset($lo_post['cnsprslqdcod'])?$lo_post['cnsprslqdcod']:$lp_prm['cnsprslqdcod']);
				$lo_cnsprslqdmdl->load( array('cnsprslqdcod'=>$lv_cnsprslqdcod), false );
        $lv_buffer = $this->co_reg->document->getView('zcusu1_cnsprslqdpnt', array('data'=>$lo_cnsprslqdmdl,'actcod'=>$this->data['actcod']));
				$this->co_reg->response->addHeader('Content-type:application/pdf');
				return $lv_buffer;
				break;
        
        
			//	 D A S H B O A R D
			case '#dsh':
        return $this->co_reg->document->getView( 'zcusu1_dsh', array( 'data'=>'','actcod'=>$this->data['actcod'] ) );
        break;
    		
      
      // DASHBOARD JEFE DE OBRA 
      case '#dshjfo':
        $lo_post = $this->co_reg->request->post;
        $lv_lvl = strval(isset($lo_post['level']) ? $lo_post['level'] : 1);
        $lv_opt = (isset($lo_post['option']) ? $lo_post['option'] : 'cnsste');
        $lo_obj = new stdClass();
        $lo_obj->sysdoccls = '';
        foreach($lo_post as $lv_key => $lv_val){
          if($lv_key != 'ajax'){
            $lo_obj->$lv_key = $lv_val;
          }
        }
        
        switch($lv_opt){
        case 'cnsste':
        
        $lo_cnsste_rs = array();
        $lo_obj->cnsste = $lo_cnsste_rs;
        
        // verifico jefe de obra
        // obtengo id de parámetro de empleado
        $lo_usrprmmdl = $this->co_reg->load->model( 'syssecusrprm' );
        $lv_prm = array('vewfldflt'=>	'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_def_rs = $lo_usrprmmdl->getDefinitions( $lv_prm );
        foreach($lo_def_rs as $lv_row){
          if($lv_row['secusrprmreffld'] == 'hhrempcod'){
            $lv_prmcod = $lv_row['secusrprmcod']; 
            
            // obtengo parámetros de empleado del usuario
            $lv_prm = array('vewfldflt' =>'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).($this->co_reg->sec->usrcod).chr(9).chr(9).
                                          '[~fltrow~]p.prmcod'.chr(9).'='.chr(9).chr(9).$lv_prmcod.chr(9).chr(9).
                                          '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
            $lo_prm_rs = $lo_usrprmmdl->getList( $lv_prm );
            
            // obtengo valores de los parámetros
            $lv_dstcod = '';
            foreach($lo_prm_rs as $lv_row2){
              if(isset($lv_row2['prmval']) && $lv_row2['prmval']!=''){
                $lv_dstcod .= ($lv_dstcod !== '' ? chr(10) : '').$lv_row2['prmval'];
              }
            }
            
            if($lv_dstcod !== ''){
              $lo_cntmdl = $this->co_reg->load->model( 'cnsbudmat' );
              $lv_prm = array('vewfldflt' =>'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9). //Obras activas
																						'[~fltrow~]t.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9). //Tareas activas
                														'[~fltrow~]t.rspobjtyp'.chr(9).'='.chr(9).chr(9).'HHR_EMP'.chr(9).chr(9). //Jefe de obra
                              							'[~fltrow~]t.rspobjcod'.chr(9).'IN'.chr(9).chr(9).$lv_dstcod.chr(9).chr(9). //Jefe de obra
                              							'[~fltrow~]tc.cnstskclscodext'.chr(9).'='.chr(9).chr(9).'CUADRILLA'.chr(9).chr(9).'TAREA'.chr(9).chr(9). //Clasificacion de Tareas CUADRILLA O TAREA
                														'[~fltrow~]tc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9). //Clasificacion de Tareas activas
                              							'[~fltrow~]b.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9), 
                             'vewfldgrp' =>'s.stecod',
                             'vewfldord' =>'s.stecod'); //Presupuestos activos
            	$lo_cnt_rs = $lo_cntmdl->getList( $lv_prm);
              
              // busco obras 
              $lv_cntcod = implode(chr(10), array_column($lo_cnt_rs, 'stecod'));
             	if($lv_cntcod !== ''){
        				$lo_cnsmdl = $this->co_reg->load->model( 'cnsste' );
        				$lv_prm = array('vewfldflt'=>	'[~fltrow~]s.stecod'.chr(9).'IN'.chr(9).chr(9).$lv_cntcod.chr(9).chr(9).
                                							'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
              	$lo_cnsste_rs = $lo_cnsmdl->getList($lv_prm, null, null, false);
                
              }
            }
            
            
            // si el usuario no tenía ningún parámetro de empleado
            if($lv_dstcod === ''){
              return $this->co_reg->document->getJson(array('errtyp'=>'E','errcod'=>'-1','errtxt'=> $this->co_reg->language->message('insufficientuserparameters', array())));
            }

          	$lo_obj->cnsste = $lo_cnsste_rs;
            
            break;
          }
        } 
        break;
       
        case 'csm':    
        //CONSUMO. Se obtiene los consumos activos  
        $lo_post = $this->co_reg->request->post;
        $lo_stkmdl = $this->co_reg->load->model( 'stkmovdoc' );
        $lv_prm = array('vewfldflt'=>	'[~fltrow~]d.srcobjtyp'.chr(9).'='.chr(9).chr(9).'STK_SOU'.chr(9).chr(9).
                        							'[~fltrow~]d.sysdocclscod'.chr(9).'='.chr(9).chr(9).'CONSUMO'.chr(9).chr(9).
                        							'[~fltrow~]d.dstobjtyp'.chr(9).'='.chr(9).chr(9).'CNS_STE'.chr(9).chr(9).
                       								'[~fltrow~]d.dstobjcod'.chr(9).'='.chr(9).chr(9).$lo_post['stecod'].chr(9).chr(9));
        $lo_rs = $lo_stkmdl->getList( $lv_prm, null, null, false );
        break;

      //Recupera las obras para Super visor y Jefe de Obra
			case '#getSiteList':
        $lv_prm = array('vewfldflt'=>	'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
        $lo_stemdl = $this->co_reg->load->model( 'cnsste' );
        $lo_rs = $lo_stemdl->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson(array('data'=>$lo_rs));
        break;
        
    	// DASHBOARD. Obtiene lista de pedidos de una obra (Inventario) hacia una obra en en particular
     	case '#pedList':
        $lo_stkmovmdl = $this->co_reg->load->model( 'stkmovdoc' );
        $lv_prm = array('vewfldflt'=>	'[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).'STK_SIV'.chr(9).chr(9).
                        							'[~fltrow~]dc.sysdocclscodext'.chr(9).'='.chr(9).chr(9).'PEDIDO'.chr(9).chr(9).
                        							'[~fltrow~]d.dstobjtyp'.chr(9).'='.chr(9).chr(9).'CNS_STE'.chr(9).chr(9).
                        							'[~fltrow~]d.dstobjcod'.chr(9).'='.chr(9).chr(9).$lp_prm['stecod'].chr(9).chr(9)
                       );
        $lo_rs = $lo_stkmovmdl->getList($lv_prm, null, null, false);
        return $this->co_reg->document->getJson($lo_rs);
        break;
        }    
        
        return $this->co_reg->document->getView( 'zcusu1_dshjfo', array( 'data' => $lo_obj,'actcod'=>$this->data['actcod'] ) );
        break;
        
         case 'addDte': 
            $lo_post = $this->co_reg->request->post;
						
            // busco clase de documento de evento
            $lo_sktmatmdl = $this->co_reg->load->model('stkmat');
            $lv_prm = array('vewfldflt' =>'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9). //material activo
                            							'[~fltrow~]m.matuntcod'.chr(9).'='.chr(9).chr(9).'UM'.chr(9).chr(9). //Unidad de medida 
                            							'[~fltrow~]m.matcstqty'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) //Cantidad 
                            );
            $lo_rs = $lo_sktmatmdl->getList( $lv_prm, null, null, false );

            
        
        
      // DASHBOARD SUPERVISOR  
      case '#dshsup':
        $lo_post = $this->co_reg->request->post;
        $lv_lvl = strval(isset($lo_post['level']) ? $lo_post['level'] : 1);
        $lv_opt = (isset($lo_post['option']) ? $lo_post['option'] : 'cnsste');
        $lo_obj = new stdClass();
        $lo_obj->sysdoccls = '';
        foreach($lo_post as $lv_key => $lv_val){
          if($lv_key != 'ajax'){
            $lo_obj->$lv_key = $lv_val;
          }
        }
        
        switch($lv_opt){
          case 'cnsste':
        		/* 
            	Busco obras del supervisor ss. 
            	Son las obras cuyo contacto es un empleado (interlocutor) "supervisor supplysouth" que figura entre
              los parámetros del usuario.
            */
            $lo_cnsste_rs = array();

            // verifico supervisor
            // obtengo id de parámetro de empleado
            $lo_usrprmmdl = $this->co_reg->load->model( 'syssecusrprm' );
            $lv_prm = array('vewfldflt'=>	'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
            $lo_def_rs = $lo_usrprmmdl->getDefinitions( $lv_prm );
            foreach($lo_def_rs as $lv_row){
              if($lv_row['secusrprmreffld'] == 'hhrempcod'){
                $lv_prmcod = $lv_row['secusrprmcod']; 

                // obtengo parámetros de empleado del usuario
                $lv_prm = array('vewfldflt' =>'[~fltrow~]p.usrcod'.chr(9).'='.chr(9).chr(9).($this->co_reg->sec->usrcod).chr(9).chr(9).
                                              '[~fltrow~]p.prmcod'.chr(9).'='.chr(9).chr(9).$lv_prmcod.chr(9).chr(9).
                                              '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
                $lo_prm_rs = $lo_usrprmmdl->getList( $lv_prm );

                // obtengo valores de los parámetros
                $lv_dstcod = '';
                foreach($lo_prm_rs as $lv_row2){
                  if(isset($lv_row2['prmval']) && $lv_row2['prmval']!=''){
                    $lv_dstcod .= ($lv_dstcod !== '' ? chr(10) : '').$lv_row2['prmval'];
                  }
                }

                if($lv_dstcod !== ''){
                  // busco ids de obras en las que el usuario es contacto supervisor ss
                  $lo_cntmdl = $this->co_reg->load->model( 'grldatcnt' );
                  $lv_prm = array('vewfldflt' =>'[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9).'CNS_STE'.chr(9).chr(9).
                                                '[~fltrow~]c.cntdsttyp'.chr(9).'='.chr(9).chr(9).'HHR_EMP'.chr(9).chr(9).
                                                '[~fltrow~]c.cntdstcod'.chr(9).'IN'.chr(9).chr(9).$lv_dstcod.chr(9).chr(9).
                                                '[~fltrow~]ct.sysdocclscodext'.chr(9).'IN'.chr(9).chr(9).'SUPSUP'.chr(10).'INSSUP'.chr(9).chr(9).
                                                '[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9));
                  $lo_cnt_rs = $lo_cntmdl->getList( $lv_prm, null, null, false );
									
                  // busco obras
                  $lv_cntcod = implode(chr(10), array_column($lo_cnt_rs, 'cntsrccod'));
                  if($lv_cntcod !== ''){
                    $lo_cnsmdl = $this->co_reg->load->model( 'cnsste' );
                    $lv_prm = array('vewfldflt'=>	'[~fltrow~]s.stecod'.chr(9).'IN'.chr(9).chr(9).$lv_cntcod.chr(9).chr(9).
                                                  '[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
                    $lo_cnsste_rs = $lo_cnsmdl->getList($lv_prm, null, null, false);
                  }
                }

                break;
              }
            }
            
            // si el usuario no tenía ningún parámetro de empleado, no podía ser supervisor de ninguna obra
            if($lv_dstcod === ''){
              return $this->co_reg->document->getJson(array('errtyp'=>'E','errcod'=>'-1','errtxt'=> $this->co_reg->language->message('insufficientuserparameters', array())));
            }

          	$lo_obj->cnsste = $lo_cnsste_rs;
            
            break;
            
          case 'evtlist':
            $lo_post = $this->co_reg->request->post;
            
            // cargo listado de eventos según el tipo de formulario
            $lo_evtmdl = $this->co_reg->load->model('cnssteevt');
            $lv_prm = array('vewfldflt' =>'[~fltrow~]se.stecod'.chr(9).'='.chr(9).chr(9).$lo_post['stecod'].chr(9).chr(9).
                                          '[~fltrow~]dc.sysdocclstxt'.chr(9).'='.chr(9).chr(9).$lo_post['evttxt'].chr(9).chr(9).
                                          '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).'CNS_EVT'.chr(9).chr(9).
                                          '[~fltrow~]dc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                          '[~fltrow~]se.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                            );
            $lv_evt_arr = $lo_evtmdl->getList( $lv_prm, null, null, false );
            
            $lo_obj->cnssteevt = $lv_evt_arr;
            
            break;
            
            
          case 'showFrm':
            $lo_post = $this->co_reg->request->post;
            
            // cargo evento para obtener clase de documento
            $lo_evtmdl = $this->co_reg->load->model('cnssteevt');
            $lv_prm = array('vewfldflt' =>'[~fltrow~]se.steevtcod'.chr(9).'='.chr(9).chr(9).$lo_post['steevtcod'].chr(9).chr(9));
            $lo_rs = $lo_evtmdl->getList( $lv_prm, null, null, false );
            
            $this->co_reg->request->post['sysdocclscod'] = $lo_rs[0]['sysdocclscod'];
            
            // abro vista del evento
            $lo_evtcnt = $this->co_reg->load->controller('cnssteevt');
            return $lo_evtcnt->index('03', array('dateOnly' => 'X'));
            
            break;
            
            
          case 'addEvt': 
            $lo_post = $this->co_reg->request->post;
            // busco clase de documento de evento
            $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
            $lv_prm = array('vewfldflt' => '[~fltrow~]d.sysdocclstxt'.chr(9).'='.chr(9).chr(9).$lo_post['sysdocclstxt'].chr(9).chr(9).
                                          '[~fltrow~]d.objtyp'.chr(9).'='.chr(9).chr(9).'CNS_EVT'.chr(9).chr(9).
                                          '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                            );
            $lo_rs = $lo_docclsmdl->getList( $lv_prm );

            if(count($lo_rs)>0){
              $this->co_reg->request->post['sysdocclscod'] = $lo_rs[0]['sysdocclscod'];
              $lv_steevtdte = new DateTime(date('Y-m-d'));
              $this->co_reg->request->post['steevtdte'] = $lv_steevtdte->format('d/m/Y');

              // abro vista para crear evento
              $lo_evtcnt = $this->co_reg->load->controller('cnssteevt');
              $lv_prm = array('dateOnly' => 'X', 
                              'title' => (isset($lo_post['title']) ? $lo_post['title'] : ''),
                              'subtitle' => (isset($lo_post['subtitle']) ? htmlentities($lo_post['subtitle']) : ''));
              return $lo_evtcnt->index('01', $lv_prm);
            }

            break;
          }
					
          $lv_view_arr = array('data' => $lo_obj,'actcod'=>$this->data['actcod']);
          $lv_view_arr['title'] = (isset($lo_post['title']) ? $lo_post['title'] : '');
          $lv_view_arr['subtitle'] = (isset($lo_post['subtitle']) ? htmlentities($lo_post['subtitle']) : '');
        	
          return $this->co_reg->document->getView( 'zcusu1_dshsup', $lv_view_arr );
        
          break;
			
      //   P A R T E   D I A R I O   -   E D E N O R
			case '#cnsdayprt':
        $lo_post = $this->co_reg->request->post;
				$lv_dat = $lo_post;
				
        // CLIENTE. se cargan los datos del cliente seleccionado
        $lo_cusmdl = $this->co_reg->load->model( 'slscus' );
        if( !$lo_cusmdl->load( array('cuscod' => $lo_post['cuscod']), false ) ){ 
          return $this->co_reg->document->getJson(array('errtyp'=>$lo_cusmdl->errtyp,'errcod'=>$lo_cusmdl->errcod,'errtxt'=>$lo_cusmdl->errtxt));
        } else {
					$lv_dat['cus'] = $lo_cusmdl;
				}
        
				$lv_stelst = '';
        //$arr_stelst = array();
				$lv_emplst = '';
				$lv_vhclst = '';

        // ASISTENCIAS. se obtienen la lista de asistencia del dia indicado
				$lv_dat['ass'] = array();
        $lo_assmdl = $this->co_reg->load->model( 'cnssteevtdoc' );
        $lv_prm = array('vewfldflt'=>	'[~fltrow~]se.steevtdte'.chr(9).'='.chr(9).chr(9).$this->co_reg->db->tsqldate($lo_post['docdte']).chr(9).chr(9).
																			//'[~fltrow~]dbo.getTagValue(^assflg^,sed.steevtdocatr)'.chr(9).'='.chr(9).chr(9).'1'.chr(9).chr(9).
																			'[~fltrow~]se.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
        $lo_rs = $lo_assmdl->getList( $lv_prm );
				$i=0;
				foreach( $lo_rs as $lv_row){
					if( stripos($lv_row['steevtdocatr'],'<assflg>1</assflg>')!==false ){
						$lv_dat['ass'][] = $lv_row;
						$i++;
						if(stripos(chr(10).$lv_stelst.chr(10),chr(10).$lv_row['stecod'].chr(10))===false){ $lv_stelst .= ($lv_stelst==''?'':chr(10)) . $lv_row['stecod']; }
						if(stripos(chr(10).$lv_emplst.chr(10),chr(10).$lv_row['srcobjcod'].chr(10))===false){ $lv_emplst .= ($lv_emplst==''?'':chr(10)) . $lv_row['srcobjcod']; }
						//array_push($arr_stelst,$lv_row['srcobjcod']);
					}
				}
        if($i==0){ return $this->co_reg->document->getJson( array( 'errtyp'=>'E','errcod'=>'01','errtxt'=>'No hay ningun registro de asistencia en la fecha indicada: '.$lo_post['docdte'] ) ); }

        // obtengo datos de choferes con asistencia
        $lo_chrmdl = $this->co_reg->load->model('hhrchrasg');
        $lv_prm = array('vewfldflt'=>	'[~fltrow~]ca.srcobjtyp'.chr(9).'='.chr(9).chr(9). 'HHR_EMP' .chr(9).chr(9).
                        							'[~fltrow~]ct.hhrchrtypcodext'.chr(9).'='.chr(9).chr(9). 'CHOFER' .chr(9).chr(9).
																			'[~fltrow~]ca.srcobjcod'.chr(9).'IN'.chr(9).chr(9). $lv_emplst .chr(9).chr(9) );
        $lo_chrrs = $lo_chrmdl->getList( $lv_prm, null, null, false );
        foreach( $lv_dat['ass'] as $lv_key => $lv_assrow){
          foreach( $lo_chrrs as $lv_chrrow){
            if ($lv_assrow['srcobjcod'] == $lv_chrrow['srcobjcod']){
              $lv_dat['ass'][$lv_key]['chr'] = $lv_chrrow['hhrchrtypcodext'];
            }
          }
        }
				
				// TAX. obtengo datos impositivos
				$lo_taxmdl = $this->co_reg->load->model('grldattax');
        $lv_prm = array('vewfldflt'=>	'[~fltrow~]t.taxsrctyp'.chr(9).'='.chr(9).chr(9). 'HHR_EMP' .chr(9).chr(9).
																			'[~fltrow~]t.taxsrccod'.chr(9).'IN'.chr(9).chr(9). $lv_emplst .chr(9).chr(9) );
				$lv_dat['tax'] = $lo_taxmdl->getList( $lv_prm );

				// UNIDADES. se obtienen las unidades para el reporte y se limita la lista de obras
        $lo_cntmdl = $this->co_reg->load->model( 'grldatcnt' );
        
        $lv_prm = array('vewfldflt'=> '[~fltrow~]c.cntsrccod'.chr(9).'IN'.chr(9).chr(9). $lv_stelst .chr(9).chr(9).
																			'[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9). 'CNS_STE' .chr(9).chr(9).
																			'[~fltrow~]c.cntdsttyp'.chr(9).'='.chr(9).chr(9). 'SLS_CUS' .chr(9).chr(9).
																			($lo_post['cnstsktyp']=='edenor' ? '[~fltrow~]c.cntdstcod'.chr(9).'='.chr(9).chr(9). $lo_post['untcuscod'] .chr(9).chr(9) : '').
																			'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9) );
				$lo_rs = $lo_cntmdl->getList( $lv_prm, null, null, false );
        if(  count($lo_rs)==0 ){ 
          return $this->co_reg->document->getJson( array( 'errtyp'=>'E','errcod'=>'01','errtxt'=>'No hay ningun registro de asistencia para el Cliente/Unidad indicados.' ) );
        } else {
					$lv_stelst = '';
					foreach( $lo_rs as $lv_row){ 
            if(stripos(chr(10).$lv_stelst.chr(10),chr(10).$lv_row['cntsrccod'].chr(10))===false){ $lv_stelst .= ($lv_stelst==''?'':chr(10)) . $lv_row['cntsrccod']; }
          }
				}

        // OBRAS. se obtienen lista de obras del cliente
        $lo_stemdl = $this->co_reg->load->model( 'cnsste' );
        $lv_prm = array('vewfldflt'=>'[~fltrow~]s.stecod'.chr(9).'IN'.chr(9).chr(9). $lv_stelst .chr(9).chr(9).
																		 '[~fltrow~]s.cuscod'.chr(9).'='.chr(9).chr(9). $lo_cusmdl->cuscod .chr(9).chr(9).
																		 '[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9));
        $lv_dat['ste'] = $lo_stemdl->getList( $lv_prm, null, null, false );
        if(  count($lv_dat['ste'])==0 ){ 
          return $this->co_reg->document->getJson( array( 'errtyp'=>'E','errcod'=>'01','errtxt'=>'No hay registradas asistencias para las obras asociadas al cliente: #'.$lo_cusmdl->cuscod.' - '.$lo_cusmdl->custxt ) );
        }
				
				// CONTACTOS de las obras
        $lo_cntmdl = $this->co_reg->load->model( 'grldatcnt' );
        $lv_prm = array('vewfldflt'=>	'[~fltrow~]c.cntsrccod'.chr(9).'IN'.chr(9).chr(9). $lv_stelst .chr(9).chr(9).
																			'[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9). 'CNS_STE' .chr(9).chr(9).
																			'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9) );
				$lv_dat['stecnt'] = $lo_cntmdl->getList( $lv_prm, null, null, false );
        
				// PRESUPUESTOS. se obtiene las tareas de los presupuestos de las obras
        $lo_budmatmdl = $this->co_reg->load->model( 'cnsbudmat' );
        $lv_prm = array('vewfldflt'=>	'[~fltrow~]s.stecod'.chr(9).'IN'.chr(9).chr(9). $lv_stelst .chr(9).chr(9).
																			'[~fltrow~]b.deldte IS NULL'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9).
																			'[~fltrow~]bm.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9) );
        $lv_dat['bud'] = $lo_budmatmdl->getList( $lv_prm );
				foreach( $lv_dat['bud'] as $lv_row){ 
					if($lv_row['srcobjtyp']=='LOG_VHC'){
            if(stripos(chr(10).$lv_vhclst.chr(10),chr(10).$lv_row['srcobjcod001'].chr(10))===false){ $lv_vhclst .= ($lv_vhclst==''?'':chr(10)) . $lv_row['srcobjcod001']; }
          }
					if($lv_row['srcobjtyp']=='HHR_EMP'){
            if(stripos(chr(10).$lv_emplst.chr(10),chr(10).$lv_row['srcobjcod001'].chr(10))===false){ $lv_emplst .= ($lv_emplst==''?'':chr(10)) . $lv_row['srcobjcod001']; }
          }
				}
				
				// AVANCE. recupero tareas en curso
				$lv_dat['tsk'] = array();
        $lv_prm = array('vewfldflt'=>	'[~fltrow~]se.steevtdte'.chr(9).'='.chr(9).chr(9).(isset($lo_post['docdte'])?$this->co_reg->db->tsqldate( $lo_post['docdte'] ):'').chr(9).chr(9).
																			'[~fltrow~]s.stecod'.chr(9).'IN'.chr(9).chr(9). $lv_stelst .chr(9).chr(9).
																			//'[~fltrow~]dbo.getTagValue(^tsksts^,sed.steevtdocatr)'.chr(9).'='.chr(9).chr(9).'C'.chr(9).chr(9).
																			'[~fltrow~]se.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																			'[~fltrow~]s.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
        $lo_rs = $lo_assmdl->getList( $lv_prm );
				foreach($lo_rs as $lv_row){
					if( stripos($lv_row['steevtdocatr'],'<tsksts>C</tsksts>')!==false){
						$lv_dat['tsk'][] = $lv_row;
					}
				}

				// VEHICULOS. se obtienen los id de los vehiculos utilizado en la obra actual
				$lo_vhcmdl = $this->co_reg->load->model('logvhc');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]v.vhccod'.chr(9).'IN'.chr(9).chr(9).$lv_vhclst.chr(9).chr(9).
																			'[~fltrow~]v.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9) );
				$lv_dat['vhc'] = $lo_vhcmdl->getList( $lv_prm, null, null, false );

				// EMPLEADOS. se obtienen los datos de los empleados con asistencia
				/*
				$lo_empmdl = $this->co_reg->load->model('hhremp');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.hhrempcod'.chr(9).'IN'.chr(9).chr(9).$lv_emplst.chr(9).chr(9).
																			'[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9). 'A' .chr(9).chr(9) );
				$lv_dat['emp'] = $lo_empmdl->
        
        ( $lv_prm );
				*/

				// PDF. se arma el pdf con los datos obtenidos
        if($lo_post['cnstsktyp']=='edenor'){
        	$lv_buffer = $this->co_reg->document->getView( 'zcusu1_cnsdayprtpnt', array( 'data'=>$lv_dat,'actcod'=>$this->data['actcod'] ) ); 
        }else if($lo_post['cnstsktyp']=='aceras' || $lo_post['cnstsktyp']=='inspeccion'){
          $lv_buffer = $this->co_reg->document->getView( 'zcusu1_cnsdayprtpntsup', array( 'data'=>$lv_dat,'actcod'=>$this->data['actcod'] ) );
        }
        if (!isset($lv_buffer)){
					return $this->co_reg->document->getJson( array( 'errtyp'=>'E','errcod'=>'01','errtxt'=>'No se pudieron recuperar datos') );          
        }else{
        	$this->co_reg->response->addHeader('Content-type:application/pdf');
					return $lv_buffer; 
        }
				break;
			
			
			// REQUISICION. se notifica a usuarios por cambio de estados
			// los codigos externos de los textos son :
			// - BUYORDMSGREQREJ rechazo de requisicion. se notifica al usuario creador.
			// - BUYORDMSGREQCTE creacion de requisicion se notifica a compras@supplysouth.com.ar
			// se reemplaza [%1] por el ID de requisicion
			case '#chkRequisicion':
        $lo_usrmdl = $this->co_reg->load->model('syssecusr');
        $lv_mailto = array();
        $lv_txt = '';

				// determino si el entorno es desarrollo o producción
				$lv_env = $this->co_reg->config->get('environmet');

        // TEXTO DE MAIL. Obtengo texto del mensaje      
        // - valido si estoy haciendo una carga de requisicion o una actualizacion con rechazo modificado
        if( $lp_prm['mdlprv']->sysdocrejcod == 0 && (isset($lp_prm['data']['sysdocrejcod']) && $lp_prm['data']['sysdocrejcod'] != '') && $lp_prm['action'] != 'NEW'){
          $lv_txt = 'BUYORDMSGREQREJ';
          $lo_usrmdl->load(array('usrcod' => $lp_prm['mdlprv']->cteusr));
          $lv_mailto[] = array('address' => $lo_usrmdl->adr->adreml); 
        } else if($lp_prm['action'] == 'NEW'){
          $lv_txt = 'BUYORDMSGREQCTE';

					if($lv_env=='dev'){
						$lv_mailto[] = array('address' => 'chisas@temasis.ar');
					}else if($lv_env=='prd'){
						$lv_mailto[] = array('address' => 'compras@supplysouth.com.ar');
					}
        }
        
        $lv_usrmsg='';
        $lo_txtmdl = $this->co_reg->load->model('grldattxt');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).$lv_txt.chr(9).chr(9).
                                      '[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9),
                        'vewmaxrec'=>'1');
        $lo_rs = $lo_txtmdl->getList($lv_prm);
        if( count($lo_rs)!=0 ) {
          $lv_usrmsg = html_entity_decode($lo_rs[0]['txttxt']);
        } else {
          return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Error de configuraci&oacute;n. No se encontr&oacute; el texto ['.($lp_oldmdl->crmcntstscod=='' ? $lv_crmcntntfnew : $lv_crmcntntfupd ).']' ) );
        }

        //MAIL. Envío mail
        if( $lv_usrmsg!= '' ) {
          $lo_eml = new tmssMail();
          $lv_emlprm['to'] = $lv_mailto;

          $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Supply South SRL') );  
          $lv_emlprm['subject'] = 'Pedido de requisicion # '.$lp_prm['data']['buyordcod'];
          $lv_usrmsg = str_replace( '[%1]', '# '.$lp_prm['data']['buyordcod'], $lv_usrmsg );   
          
          $lv_emlprm['bodyhtml'] = $lv_usrmsg;
          if ( !$lo_eml->send( $lv_emlprm ) ) {
            return $this->co_reg->document->getJson( array('errtyp' => 'E', 'errcod' => -1, 'errtxt' => $lo_eml->getError()) );
          } 
        }
         
        break;
		}	
  }
}
?>
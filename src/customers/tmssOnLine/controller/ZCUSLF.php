<?php
final class zcuslfController extends tmssController { 
	const MODEL = 'zcuslf';
	const VIEW  = 'zcuslf';
	const ID = '';
  protected $co_reg;
	private $lo_mdl;
  private $data = array();
   
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; $this->data['tskbar_arr'] = []; $this->data['pryinfo_arr'] = []; }
  
  
  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {

    // all methods of this class are available for logged users check user session    
		$this->co_reg->request->post['ajax']='1';
		$lv_lgnbuf = $this->co_reg->user->checkUserLogin();
		if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		$this->data['actcod'] = $lp_act;
		
		$lp_act = '#' . $lp_act; 
    switch( $lp_act ) {
			
			
			// FORMULARIO ASISTENCIA TECNICA
      case '#evtfrmasstec':
        $lo_post = $this->co_reg->request->post;
				$this->data['actcod'] = (isset($lo_post['actcod'])?$lo_post['actcod']:'');
        $lo_evtmdl = $this->co_reg->load->model( 'cnssteevt' );
				$lo_evtmdl->create();
        //si tengo un documento lo obtengo con el getlist 
        if(($lo_post['steevtdoccod']??'')!=''){
					$lo_docmdl = $this->co_reg->load->model('cnssteevtdoc');
          $lv_prm = array('vewfldflt' =>'[~fltrow~]sed.steevtdoccod'.chr(9).'='.chr(9).chr(9).$lo_post['steevtdoccod'].chr(9).chr(9));
					$lo_rs = $lo_docmdl->getList( $lv_prm );
          
          if( $this->data['actcod'] == '001' ) {
						$lo_rs[0]['steevtcod'] = '';
        		$lo_rs[0]['steevtdoccod'] = '';
					}
        	$lo_evtmdl->evtdoc = $lo_rs[0];
       	}
        
        //PLANIFICACION. cargo datos de la planificacion asociada a la obra
        $lo_cnsbudmdl = $this->co_reg->load->model( 'cnsbud' );
        $lo_cnsbudmdl->create();
    		if(($lo_post['stecod']??'')!=''){
          $lv_prm = array('vewfldflt' =>'[~fltrow~]b.stecod'.chr(9).'='.chr(9).chr(9).($lo_post['stecod']).chr(9).chr(9).
                                        '[~fltrow~]b.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                          );
          $lo_rs2 = $lo_cnsbudmdl->getList($lv_prm, null, null, false);
          if ($lo_rs2[0]['budcod'] ?? null) {
            $lo_cnsbudmdl->load(array('budcod' => $lo_rs2[0]['budcod']));
          }
          else{ 
          	return $this->co_reg->document->getJson(array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Debe crear una planificaci&oacute;n.'));
          }
        }
        
        $lo_budtsk = $lo_cnsbudmdl->budtsk ?? array();
        if (!is_array($lo_budtsk)) $lo_budtsk = [];
        $lo_budtsk = array_filter($lo_budtsk, function($lv_row) {
            return $lv_row['srcobjtyp'] == 'CNS_TSK' && ($lv_row['cnstskclscodext'] ?? '') != 'CUADRILLA';
        });
        $lo_evtmdl->tskbar = $lo_budtsk;
        
        return $this->co_reg->document->getView( 'zcuslf_evtfrmasstec', array('data'=>$lo_evtmdl,'actcod'=>$this->data['actcod'], 'oldSec'=>$lo_post['oldSec']) );
        break;
        
        
      case '#evtfrmprecrt':
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
        //cargo el documento
        $lo_cnssteevtdocmdl = $this->co_reg->load->model( 'cnssteevtdoc' );
        $lv_prm = array('vewfldflt' =>'[~fltrow~]sed.srcobjtxt'.chr(9).'='.chr(9).chr(9).'PRE CERTIFICACION'.chr(9).chr(9).
                                        '[~fltrow~]sed.srcobjtyp'.chr(9).'='.chr(9).chr(9).'CNS_EVT_FRM'.chr(9).chr(9).
                                        '[~fltrow~]se.steevtdte'.chr(9).'='.chr(9).chr(9). $this->co_reg->db->tsqldate($lo_post['steevtdte']).chr(9).chr(9).
                                        '[~fltrow~]sed.steevtcod'.chr(9).'='.chr(9).chr(9).$lo_post['steevtcod'].chr(9).chr(9).
                                        '[~fltrow~]se.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                        '[~fltrow~]sed.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9)
                       );
        $lo_rs = $lo_cnssteevtdocmdl->getList($lv_prm);
        $lo_evtmdl->cnssteevtdoc=$lo_rs;
        return $this->co_reg->document->getView( 'zcuslf_evtfrmprecrt', array('data'=>$lo_evtmdl,'actcod'=>$this->data['actcod'], 'oldSec'=>$lo_post['oldSec']) );
        break;
       	
        
      //IMPRESION ASISTENCIA TECNICA (A2)
      case '#evtfrmasstecpnt':
        $lo_post = $this->co_reg->request->post;
        $lv_evtcod = $lo_post['steevtcod'] ?? $lp_prm['steevtcod'] ?? '';
        $lv_pry = $lo_post['pry'] ?? $lp_prm['pry'] ?? '';
        
        if($lv_pry){
          $lv_pryinfo = $this->getPryInfoOfEvents()[$lv_pry];
          $lv_evt_arr = $lp_prm['a2'];
          $lv_budtsk = $lv_pryinfo['budtsk'];
          $lo_stemdl = $this->co_reg->load->model('cnsste');
          $lo_stemdl->load(array('stecod' => $lv_pryinfo['stecod']), false);
          $lo_stemdl->rspobjtxt = $lv_pryinfo['rspobjtxt'];
        }else{
          // Determinar si es un array de códigos o un solo código
          $lv_evtcods = is_array($lv_evtcod) ? $lv_evtcod : [$lv_evtcod];
          if (empty($lv_evtcods)) { return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => -1, 'errtxt' => 'No se indicaron eventos para la impresión A2.')); }

          // EVENTO. cargo el o los eventos A2
          $lv_events_data = [];
          $lo_evtmdl = $this->co_reg->load->model('cnssteevt');
          $lv_prm = array('vewfldflt' => '[~fltrow~]se.steevtcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lv_evtcods).chr(9).chr(9),
                        'vewfldord' => 'se.steevtcod'); 
          $lv_evt_arr = $lo_evtmdl->getList($lv_prm, null, null, false);

          $lo_evtdocmdl = $this->co_reg->load->model('cnssteevtdoc');
          $lv_evtdoc_arr = $lo_evtdocmdl->getList( $lv_prm );

          // unir información
          foreach($lv_evt_arr as $i => &$lo_evt){
            $lo_evt['evtdoc']['steevtdocatr'] = json_decode(mb_convert_encoding($lv_evtdoc_arr[$i]['steevtdocatr'], 'UTF-8', 'iso-8859-1'), true);
          }
          unset($lo_evt);

          // OBRA. cargo datos de la obra 
          $lo_stemdl = $this->co_reg->load->model('cnsste');
          $lo_stemdl->load(array('stecod' => $lv_evt_arr[0]['stecod']), false);

          //PLANIFICACION. cargo datos de la planificacion asociada a las obras
          $lo_cnsbudmdl = $this->co_reg->load->model('cnsbud');
          $lv_prm = array(
              'vewfldflt' => '[~fltrow~]b.stecod' . chr(9) . '=' . chr(9) . chr(9) .$lo_stemdl->stecod. chr(9) . chr(9) .
                            '[~fltrow~]b.docsts' . chr(9) . '=' . chr(9) . chr(9) . 'A' . chr(9) . chr(9),
              'vewfldord' => 'b.budcod',
              'vewmaxrec' => 1
          );
          $lv_bud_rs = $lo_cnsbudmdl->getList($lv_prm, null, null, false);
          $lo_cnsbudmdl->load(array('budcod' => $lv_bud_rs[0]['budcod']), false);

          $lv_budtsk = $lo_cnsbudmdl->budtsk;
          
          //RESPONSABLE. busco la cuadrilla
          foreach($lv_budtsk as $lo_budtsk){
            if (($lo_budtsk['cnstskclscodext'] ?? '') == 'CUADRILLA') {
              $lv_sqdtskcod = $lo_budtsk['srcobjcod001'];
              break;
            }
          }
          $lo_cnstskmdl = $this->co_reg->load->model('cnstsk');
          $lo_cnstskmdl->load(array('cnstskcod' => $lv_sqdtskcod), false);
          $lo_stemdl->rspobjtxt = $lo_cnstskmdl->rspobjtxt;
        }
        
        //TAREAS. cargo TAREAS DE CLASE BAREMO. 
        // Para todos los A2, los baremos son iguales. En el zip se generan varios A2.
        if(empty($this->data['tskbar_arr'])){
          $lo_cnstskmdl2 = $this->co_reg->load->model('cnstsk');
          $lv_prm = array('vewfldflt' => '[~fltrow~]dc.sysdocclscodext' . chr(9) . '=' . chr(9) . chr(9) . 'BAREMO' . chr(9) . chr(9) .
                                          '[~fltrow~]t.docsts' . chr(9) . '=' . chr(9) . chr(9) . 'A' . chr(9) . chr(9));
          $this->data['tskbar_arr'] = $lo_cnstskmdl2->getList($lv_prm, null, null, false);
      	}
        
        $lv_buffer = $this->co_reg->document->getView('zcuslf_evtfrmasstecpnt', array('events' => $lv_evt_arr, 'ste' => $lo_stemdl, 'tsk'=>$this->data['tskbar_arr'], 'budtsk'=>$lv_budtsk));
        $this->co_reg->response->addHeader('Content-type:application/pdf');
        return $lv_buffer;
      	break;
        
        
      // IMPRESION REMITO
      case '#stkmovpnt':
        $lo_post = $this->co_reg->request->post;
        $lo_stemdl = $this->co_reg->load->model('cnsste');
        $lo_evtmdl = $this->co_reg->load->model('cnssteevt');
        $lo_evtdocmdl = $this->co_reg->load->model('cnssteevtdoc');
        
        // Busco eventos A2 de la obra
        $lv_stecod = $lo_post['srcobjcod'];
        $lv_prmevt = array('vewfldflt' => '[~fltrow~]se.stecod' . chr(9) . '=' . chr(9) . chr(9) . $lv_stecod . chr(9) . chr(9) .
                													'[~fltrow~]dc.sysdocclscodext' . chr(9) . '=' . chr(9) . chr(9) . 'ASIS TEC' . chr(9) . chr(9),
                          'vewfldord' => 'se.steevtcod');
        $lv_evt_arr = $lo_evtmdl->getList($lv_prmevt, null, null, false);
      	
        if (empty($lv_evt_arr)) { return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => -2, 'errtxt' => 'No existen eventos A2 de la obra.')); }

        $lv_evtcods = array_column($lv_evt_arr, 'steevtcod');  
        $lv_prm = array('vewfldflt' => '[~fltrow~]se.steevtcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lv_evtcods).chr(9).chr(9),
                    'vewfldord' => 'se.steevtcod'); 
        $lv_evtdoc_arr = $lo_evtdocmdl->getList( $lv_prm );
        foreach($lv_evt_arr as $i => &$lo_evt){
          $lo_evt['evtdoc'] = $lv_evtdoc_arr[$i];
        }
        unset($lo_evt);
        
        $lo_stemdl->load(array('stecod' => $lo_post['srcobjcod']), false);

        $lv_buffer = $this->co_reg->document->getView('zcuslf_stkmovpnt', array('ste' => $lo_stemdl, 'evt' => $lv_evt_arr));
        $this->co_reg->response->addHeader('Content-type:application/pdf');
        return $lv_buffer;
        break;
    
        
      //IMPRESION LIBRO PE 
      case '#cnslqdbokpnt':
        $lo_post = $this->co_reg->request->post;
        $lv_cnslqdcod = (isset($lo_post['cnslqdcod']) ? $lo_post['cnslqdcod'] : $lp_prm['cnslqdcod']);

        //LIQUIDACION. cargo la liquidacion
        $lo_cnslqdmdl = $this->co_reg->load->model('cnslqd');
        $lo_cnslqdmdl->load(array('cnslqdcod' => $lv_cnslqdcod), false);

        // Validamos que existan IDs para evitar errores de sintaxis 
        $lv_lqddoc_arr = $lo_cnslqdmdl->cnslqddoc;
        if (empty($lv_lqddoc_arr)) { return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => -4, 'errtxt' => 'Seleccione eventos A2 para el libro PE.')); }
        
        // OBRA. cargo datos de la obra, para saber el nombre de la ciudad, que comparten todas las obras de la certificación
        $lo_stemdl = $this->co_reg->load->model('cnsste');
        $lo_stemdl->load(array('stecod' => $lv_lqddoc_arr[0]['stecod']));
        $lo_cnslqdmdl->lndtwntxt = $lo_stemdl->adr->lndtwntxt;

        $lv_remitos_unicos = [];
        foreach ($lv_lqddoc_arr as $lo_lqddoc) {
          $lv_evtdocatr = json_decode($lo_lqddoc['steevtdocatr'], true);
          $lv_remito = trim($lv_evtdocatr['steevtdocrem'] ?? '');
          // Si existe remito, lo guardamos usando el valor como CLAVE. Esto elimina duplicados automáticamente (hash map).
          if ($lv_remito !== '') {
              $lv_remitos_unicos[$lv_remito] = $lv_remito;
          }
        }
        $lo_cnslqdmdl->steevtdocremarr = $lv_remitos_unicos;

        // EMPRESA. obtiene empresa
        $lo_busmdl = $this->co_reg->load->model('admbus');
        $lo_busmdl->load(array('buscod' => $this->co_reg->sec->buscod), false);

        $lv_buffer = $this->co_reg->document->getView('zcuslf_cnslqdbok', array('data' => $lo_cnslqdmdl, 'bus' => $lo_busmdl));
        $this->co_reg->response->addHeader('Content-type:application/pdf');
        return $lv_buffer;
        break;  
        
        
      //IMPRESION PRECERTIFICACION 
      case '#cnslqdprecrtpnt':
        $lo_post = $this->co_reg->request->post;
        $lv_cnslqdcod = $lo_post['cnslqdcod'] ?? $lp_prm['cnslqdcod'] ?? '';
        $lv_pec = $lo_post['pec'] ?? $lp_prm['pec'] ?? '';
        $lv_cnstskclscodext = strtoupper($lo_post['cnstskclscodext'] ?? $lp_prm['cnstskclscodext'] ?? '');

        //LIQUIDACION. cargo la liquidacion
        if($lv_cnslqdcod){
          $lo_cnslqdmdl = $this->co_reg->load->model('cnslqd');
          $lo_cnslqdmdl->load(array('cnslqdcod' => $lv_cnslqdcod), false);
          $lv_lqddoc_arr = $lo_cnslqdmdl->cnslqddoc;
        }else{
          $lo_cnslqdmdl = $lp_prm['cnslqd'];
        }
        $lv_lqddoc_arr = $lo_cnslqdmdl->cnslqddoc;
				if (empty($lv_lqddoc_arr)) { return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => -3, 'errtxt' => 'Seleccione eventos A2 para la precertificación.')); }
				$lo_cnslqdmdl->cnslqddochie = $this->getPecTskcodHie($lv_lqddoc_arr, $lv_cnstskclscodext);
        
        // OBRA. cargo datos de la obra, para saber el nombre de la ciudad, que comparten todas las obras de la certificación
        $lo_stemdl = $this->co_reg->load->model('cnsste');
        $lo_stemdl->load(array('stecod' => $lo_cnslqdmdl->cnslqddoc[0]['stecod']));
        $lo_cnslqdmdl->lndtwntxt = $lo_stemdl->adr->lndtwntxt;
        
        if($lv_pec !== ''){ 
          if(isset($lo_cnslqdmdl->cnslqddochie[$lv_pec])){
          	$lo_cnslqdmdl->cnslqddochie = array($lv_pec => $lo_cnslqdmdl->cnslqddochie[$lv_pec]);
          }else{
            return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => -8, 'errtxt' => 'No hay eventos A2 con PEC '.$lv_pec));
          }
        }
        
        // EMPRESA. obtiene empresa
        $lo_busmdl = $this->co_reg->load->model('admbus');
        $lo_busmdl->load(array('buscod' => $this->co_reg->sec->buscod), false);

        $lv_buffer = $this->co_reg->document->getView('zcuslf_cnslqdprecrtpnt', array('data' => $lo_cnslqdmdl, 'bus' => $lo_busmdl));
        if($lp_prm['nohdr'] ?? '' !== 'X') { $this->co_reg->response->addHeader('Content-type:application/pdf'); }
        return $lv_buffer;
        break;  
        
      
      //REPORTE DE EDENOR, EN CARPETA ZIP
      case '#rptzip':
        // Configuración de entorno (Memoria y Tiempo)
        set_time_limit(0);
        $lv_lmtmem = ini_get('memory_limit');
        ini_set('memory_limit', '2048M');
	
        $lo_post = $this->co_reg->request->post;
        $lv_vewfldflt = (isset($lo_post['vewfldflt']) ? $lo_post['vewfldflt'] : $lp_prm['vewfldflt']);

        // Obtener Liquidación Base
        $lo_cnslqdmdl = $this->co_reg->load->model('cnslqd');
        $lo_rs = $lo_cnslqdmdl->getList(array('vewfldflt' => $lv_vewfldflt));
        if (empty($lo_rs)) { return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => -5, 'errtxt' => 'Liquidación no encontrada.')); }
        $lv_cnslqdcod = $lo_rs[0]['cnslqdcod'];
        $lv_cnslqdcodext = $lo_rs[0]['cnslqdcodext'];
        $lo_cnslqdmdl->load(array('cnslqdcod' => $lv_cnslqdcod), false);
        $lv_lqddoc_arr = $lo_cnslqdmdl->cnslqddoc;
        if (empty($lv_lqddoc_arr)) { return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => -6, 'errtxt' => 'Liquidación sin eventos A2 para procesar.')); }

        $lv_pryinfo_arr = $this->getPryInfoOfEvents($lv_lqddoc_arr); 
        $lv_cnslqddochie = $this->getPecTskcodHie($lv_lqddoc_arr);

        // Preparar ZIP y Controlador Auxiliar
        $zip = new ZipArchive();
        $tmp_file = tempnam(sys_get_temp_dir(), 'LQD_');
        if ($zip->open($tmp_file, ZipArchive::OVERWRITE) !== TRUE) { return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => -7, 'errtxt' => 'Error creando ZIP TMP.')); }

        // Carga de recursos comunes
        $lo_busmdl = $this->co_reg->load->model('admbus');
        $lo_busmdl->load(array('buscod' => $this->co_reg->sec->buscod), false);
        $lo_stemdl = $this->co_reg->load->model('cnsste');
        $lo_stemdl->load(array('stecod' => $lo_cnslqdmdl->cnslqddoc[0]['stecod']));
        $lv_lndtwntxt = $lo_stemdl->adr->lndtwntxt;

        // Crear carpeta raíz con formato PE {cnslqdcodext} {lndtwntxt} LOC
        $lv_root_folder = 'PE ' . $lv_cnslqdcodext . ' ' . $lv_lndtwntxt . ' LOC';
        $lv_root_folder = preg_replace('/[^a-zA-Z0-9_-]/', ' ', $lv_root_folder);  // Limpiar caracteres no válidos para nombres de carpeta

        // INSTANCIA DEL CONTROLADOR (RECURSIVIDAD/DELEGACION)
        // Instanciamos una sola vez el controlador para reutilizarlo
        $lo_ctr_sub = $this->co_reg->load->controller('zcuslf');

        // Loop Principal
        foreach ($lv_cnslqddochie as $lv_pec => $lv_itemsbycod) {
          // A. PRECERTIFICACIÓN (Resumida por PEC)
          $pdf_precert = $this->index('cnslqdprecrtpnt', ['pec' => $lv_pec, 'nohdr' => 'X', 'cnslqd' => $lo_cnslqdmdl]);
          
          $safe_pec = preg_replace('/[^a-zA-Z0-9_-]/', '_', $lv_pec);
          $zip->addFromString($lv_root_folder . '/PEC ' . $safe_pec . '/PEC ' . $safe_pec . ' CERTI.pdf', $pdf_precert);

          // B. ASISTENCIA TÉCNICA - Agrupar por PROYECTO
          // Primero, agrupar eventos por proyecto
          $lv_events_by_project = [];
          foreach($lv_pryinfo_arr as $lv_pry => $lv_pryinfo){
            $lv_aux = array_filter($lv_pryinfo['a2evts'], function($lv_a2) use($lv_pec){
							$lv_evtdocatr = json_decode(mb_convert_encoding($lv_a2['steevtdocatr'], 'UTF-8', 'iso-8859-1'), true); 
              return $lv_evtdocatr['steevtdocpec'] == $lv_pec;
            });
            if(!empty($lv_aux)) { $lv_events_by_project[$lv_pry] = $lv_aux; }
          }

          // Generar un PDF por proyecto con múltiples páginas
          foreach ($lv_events_by_project as $lv_proyecto => $lv_events) {
            // Llamar al método con array de códigos de eventos
            $lv_pdfbin = $this->index('evtfrmasstecpnt', ['pry' => $lv_proyecto, 'a2' => $lv_events]);
            
            // Agregar al ZIP con nombre del proyecto (12 dígitos con ceros a la izquierda)
            if (!empty($lv_pdfbin) && is_string($lv_pdfbin)) {
              // Formatear el proyecto a 12 dígitos con ceros a la izquierda
              $lv_proyecto_formatted = str_pad($lv_proyecto, 12, '0', STR_PAD_LEFT);
              $zip->addFromString($lv_root_folder . '/PEC ' . $safe_pec . '/A2/' . $lv_proyecto_formatted . '.pdf', $lv_pdfbin);
            }
          }
        }
        
        // 6. armado de excel 
        $lv_xlsdat = $lo_ctr_sub->index('cnslqdrpt', ['vewfldflt' => $lv_vewfldflt]);
        $rows = $lv_xlsdat ?? [];
        // --------------------------------------------------------------------------
        // DEFINICIÓN 1: LIQUIDACIÓN (Basado en la imagen con montos y totales)
        // --------------------------------------------------------------------------
        $def1 = [
            ["key" => "steevtdte", "label" => "FECHA", "type" => "DATE"],
            ["key" => "steevtdocpec", "label" => "P EMPRE", "type" => "TEXT"],
            ["key" => "steevtdocrem", "label" => "REMITO", "type" => "TEXT"],
            ["key" => "cnssteatrpry", "label" => "OT REF", "type" => "TEXT"],
            ["key" => "cnstsktyp", "label" => "TIPO DE TRABAJO", "type" => "TEXT"],
            ["key" => "steevtadr", "label" => "DIRECCION", "type" => "TEXT"], // Dirección del evento (rango)
            ["key" => "cnslqddocqty", "label" => "CANT", "type" => "NUMBER"],
            ["key" => "cnslqddocprc", "label" => "UNIT", "type" => "mon"],
            ["key" => "cnslqddocsubtot", "label" => "SUBT", "type" => "mon"],
            ["key" => "cnslqddocrec", "label" => "REC", "type" => "mon"],
            ["key" => "cnslqddoctot", "label" => "TOTAL", "type" => "mon"],
            ["key" => "cnstskrspobjtxt", "label" => "OFICIAL", "type" => "TEXT"],
            ["key" => "cnttxt", "label" => "CONTACTO", "type" => "TEXT"],
        ];

        // --------------------------------------------------------------------------
        // DEFINICIÓN 2: DETALLE TÉCNICO (Basado en la imagen con zonas y estados)
        // --------------------------------------------------------------------------
        $def2 = [
            ["key" => "cnssteatrpryid", "label" => "ID AC", "type" => "TEXT"],
            ["key" => "lndtwntxt", "label" => "REGION", "type" => "TEXT"],
            ["key" => "lndtwngrptxt", "label" => "ZONA", "type" => "TEXT"],
            ["key" => "cnslqddocsts", "label" => "ESTADO", "type" => "TEXT"],
            ["key" => "steevtdocpecdte", "label" => "FECHA CIERRE TAREA", "type" => "DATE"],
            ["key" => "steevtdocpectme", "label" => "HORA CIERRE TAREA", "type" => "TIME"],
            ["key" => "cnssteadr", "label" => "DIRECCION", "type" => "TEXT"], // Dirección exacta (sitio)
            ["key" => "adrzontxt", "label" => "PARTIDO", "type" => "TEXT"],
            ["key" => "cnstsk", "label" => "TIPO", "type" => "TEXT"],
            ["key" => "cnstskcodext", "label" => "CODIGO", "type" => "TEXT"],
            ["key" => "cnstsktxt", "label" => "DESCRIPCION", "type" => "TEXT"],
            ["key" => "steevtdocqty", "label" => "CANTIDAD", "type" => "TEXT"], // Ojo: usa steevtdocqty aquí
            ["key" => "cnslqdprecrtsvc", "label" => "CONTRATO", "type" => "TEXT"],
            ["key" => "cnstsksubtyp", "label" => "SUBTIPO", "type" => "TEXT"],
            ["key" => "steevtdocpec", "label" => "PE CONCERT", "type" => "TEXT"],
            ["key" => "cnslqddoccrt", "label" => "CERTIFICADO", "type" => "TEXT"],
            ["key" => "cnslqdcodext", "label" => "PE SELF", "type" => "TEXT"],
            ["key" => "cnslqddte", "label" => "FECHA PE", "type" => "DATE"],
        ];

        // --------------------------------------------------------------------------
        // FUNCIÓN GENERADORA (Para no repetir código)
        // --------------------------------------------------------------------------
        function generarExcelHtml($rows, $definition, $title)
        {
            ob_start();
            ?>
            <html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel"
                xmlns="http://www.w3.org/TR/REC-html40">

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                <style>
                    table {
                        border-collapse: collapse;
                        width: 100%;
                        font-family: Calibri, sans-serif;
                        font-size: 12px;
                    }

                    td,
                    th {
                        border: 1px solid #999;
                        padding: 5px;
                        vertical-align: middle;
                    }

                    .header {
                        background-color: #002060;
                        color: #ffffff;
                        font-weight: bold;
                        text-align: center;
                        height: 30px;
                    }

                    .num {
                        text-align: center;
                        white-space: nowrap;
                    }

                    .mon {
                        text-align: center;
                        white-space: nowrap;
                        mso-number-format: "#\,##0\.00\ $";
                    }

                    .txt {
                        text-align: center;
                        mso-number-format: "\@";
                    }

                    .date {
                        text-align: center;
                    }
                </style>
            </head>

            <body>
                <table>
                    <thead>
                        <tr>
                            <?php foreach ($definition as $col): ?>
                                <th class="header">
                                    <?php echo htmlspecialchars($col['label']); ?>
                                </th>
                            <?php endforeach; ?>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($rows as $row): ?>
                            <tr>
                                <?php foreach ($definition as $col): ?>
                                    <?php
                                    $key = $col['key'];
                                    $val = $row[$key] ?? '';
                                    $type = $col['type'];

                                    // Manejo de Objetos DateTime
                                    if ($val instanceof DateTime || $val instanceof DateTimeImmutable) {
                                        $format = ($type === 'TIME') ? 'H:i' : 'd/m/Y';
                                        $val = $val->format($format);
                                    }

                                    // Clases CSS según tipo
                                    $cssClass = 'txt';
                                    if ($type === 'NUMBER')
                                        $cssClass = 'num';
                                    if ($type === 'DATE' || $type === 'TIME')
                                        $cssClass = 'date';
                                    if ($type === 'mon'){
                                      $cssClass = $type;
                                      $val = number_format($val, 2, ',', '.');
                                    }
                                    ?>
                                    <td class="<?php echo $cssClass; ?>">
                                        <?php echo htmlspecialchars((string) $val); ?>
                                    </td>
                                <?php endforeach; ?>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </body>

            </html>
            <?php
            return ob_get_clean();
        }

        // --------------------------------------------------------------------------
        // GENERACIÓN Y AGREGADO AL ZIP
        // --------------------------------------------------------------------------

        // 1. Generar Archivo de Liquidación (Imagen 2)
        $htmlLiquidacion = generarExcelHtml($rows, $def1, 'Reporte de Liquidación');
        $zip->addFromString($lv_root_folder . '/RESUMEN PE ' . $lv_cnslqdcodext . '.xls', $htmlLiquidacion);

        // 2. Generar Archivo Técnico (Imagen 1)
        array_pop($rows);
        $htmlTecnico = generarExcelHtml($rows, $def2, 'Detalle Técnico de Obras');
        $zip->addFromString($lv_root_folder . '/DETALLE CERTIFICACION ' . $lv_lndtwntxt . ' PE ' . $lv_cnslqdcodext . '.xls', $htmlTecnico);

        // 9. LIBRO PE
        $lv_pdfbok = $lo_ctr_sub->index('cnslqdbokpnt', [
            'cnslqdcod' => $lv_cnslqdcod,
            'msgqty' => 1
        ]);

        if (!empty($lv_pdfbok) && is_string($lv_pdfbok)) {
          $zip->addFromString($lv_root_folder . '/PE LIBRO ' . $lv_cnslqdcodext . '.pdf', $lv_pdfbok);
        }
        // Listo. El zip ahora tiene los dos archivos solicitados.

        $zip->close();
        ini_set('memory_limit', $lv_lmtmem);


        // 10. Retorno
        if (file_exists($tmp_file)) {
            // Limpieza de buffer por si quedaron espacios o warnings
            while (ob_get_level())
                ob_end_clean();

            header('Content-Description: File Transfer');
            header('Content-Type: application/zip');
            header('Content-Disposition: attachment; filename="Liquidacion_' . $lv_cnslqdcodext . '.zip"');
            header('Content-Length: ' . filesize($tmp_file));
            header('Pragma: public');
            header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
            header('Expires: 0');

            readfile($tmp_file);
            unlink($tmp_file); // Borramos el temporal del servidor
            exit; // Matamos el proceso para que no se imprima nada más
        } else {
            return $this->co_reg->document->getJson(['errtyp' => 'E', 'errtxt' => 'Error al generar ZIP.']);
        }
        break;  
        
        
      //REPORTE ZIP SIMPLIFICADO - SIN ESTRUCTURA PEC
      case '#rptzipalt':
        set_time_limit(0);
        $lv_lmtmem = ini_get('memory_limit');
        ini_set('memory_limit', '2048M');

        $lo_post = $this->co_reg->request->post;
        $lv_vewfldflt = (isset($lo_post['vewfldflt']) ? $lo_post['vewfldflt'] : $lp_prm['vewfldflt']);

        // Obtener Liquidación
        $lo_cnslqdmdl = $this->co_reg->load->model('cnslqd');
        $lo_rs = $lo_cnslqdmdl->getList(array('vewfldflt' => $lv_vewfldflt));
        if (empty($lo_rs)) {
          return $this->co_reg->document->getJson(['errtyp' => 'E', 'errtxt' => 'Liquidación no encontrada.']);
        }

        $lv_cnslqdcod = $lo_rs[0]['cnslqdcod'];
        $lv_cnslqdcodext = $lo_rs[0]['cnslqdcodext'];
        $lo_cnslqdmdl->load(array('cnslqdcod' => $lv_cnslqdcod), false);

        $lv_ids = array_column($lo_cnslqdmdl->cnslqddoc, 'refobjcod002');
        if (empty($lv_ids))
          return $this->co_reg->document->getJson(['errtyp' => 'E', 'errtxt' => 'Sin documentos.']);

        // Cargar eventos
        $lo_cnssteevtdocmdl = $this->co_reg->load->model('cnssteevtdoc');
        $lv_prm = array(
            'vewfldflt' =>
                '[~fltrow~]sed.srcobjtxt' . chr(9) . '=' . chr(9) . chr(9) . 'ASISTENCIA TECNICA' . chr(9) . chr(9) .
                '[~fltrow~]sed.srcobjtyp' . chr(9) . '=' . chr(9) . chr(9) . 'CNS_EVT_FRM' . chr(9) . chr(9) .
                '[~fltrow~]sed.steevtcod' . chr(9) . 'IN' . chr(9) . chr(9) . implode(chr(10), $lv_ids) . chr(9) . chr(9) .
                '[~fltrow~]se.docsts' . chr(9) . '=' . chr(9) . chr(9) . 'A' . chr(9) . chr(9) .
                '[~fltrow~]sed.docsts' . chr(9) . '=' . chr(9) . chr(9) . 'A' . chr(9) . chr(9)
        );
        $lo_rs = $lo_cnssteevtdocmdl->getList($lv_prm);
        if (empty($lo_rs))
          return $this->co_reg->document->getJson(['errtyp' => 'E', 'errtxt' => 'No se encontraron datos.']);

        // Agrupar por proyecto
        $lv_steevtdocval = [];
        foreach ($lo_rs as $row) {
          $row['steevtdocpec'] = $json['steevtdocpec'] ?? '';
          $row['cnstskcod'] = $json['cnstskcod'] ?? '';
          $lv_steevtdocval[trim((string) $row['steevtdoccod'])] = $row;
        }

        $lv_events_by_project = [];
        foreach ($lo_cnslqdmdl->cnslqddoc as $row) {
          $key = trim((string) $row['refobjcod001']);
          if (isset($lv_steevtdocval[$key])) {
          	$json = json_decode(mb_convert_encoding($row['steevtdocatr'], 'UTF-8', 'iso-8859-1'), true); 
            $merged = array_merge($lv_steevtdocval[$key], $json, $row);

            // Obtener proyecto y contacto
            $lo_ste_temp = $this->co_reg->load->model('cnsste');
            $lo_ste_temp->load(array('stecod' => $row['stecod']));
            $lv_proyecto = $this->co_reg->document->getTagValue($lo_ste_temp->cnssteatr, 'atr_pry');
            if (empty($lv_proyecto)) {
                $lv_proyecto = '000000000000';
            }

            // Obtener contacto
            $lo_cntmdl = $this->co_reg->load->model('grldatcnt');
            $lv_flt = array(
                'vewfldflt' => '[~fltrow~]c.cntsrctyp' . chr(9) . '=' . chr(9) . chr(9) . 'CNS_STE' . chr(9) . chr(9) .
                    '[~fltrow~]c.cntsrccod' . chr(9) . '=' . chr(9) . chr(9) . $lo_ste_temp->stecod . chr(9) . chr(9) .
                    '[~fltrow~]ct.sysdocclscodext' . chr(9) . '=' . chr(9) . chr(9) . 'CCTEDENOR' . chr(9) . chr(9)
            );
            $lv_arr_dat = $lo_cntmdl->getList($lv_flt, array('cntsrctyp' => 'CNS_STE'), null, false);
            $lv_cnttxt = $lv_arr_dat[0]['cnttxt'] ?? '-';

            if (!isset($lv_events_by_project[$lv_proyecto])) {
              $lv_events_by_project[$lv_proyecto] = ['events' => [], 'items' => [], 'cnttxt' => $lv_cnttxt];
            }

            $lv_events_by_project[$lv_proyecto]['events'][] = $merged['steevtcod'];

            $pec = $merged['steevtdocpec'] ?: 'GENERAL';
            $cod = $merged['cnstskcod'] ?: 'UNI_' . $key;

            if (!isset($lv_events_by_project[$lv_proyecto]['items'][$pec])) {
              $lv_events_by_project[$lv_proyecto]['items'][$pec] = [];
            }

            if (isset($lv_events_by_project[$lv_proyecto]['items'][$pec][$cod])) {
              $lv_events_by_project[$lv_proyecto]['items'][$pec][$cod]['cnslqddocqty'] += (float) $merged['cnslqddocqty'];
            } else {
              $lv_events_by_project[$lv_proyecto]['items'][$pec][$cod] = $merged;
            }
          }
        }

        // Preparar ZIP
        $zip = new ZipArchive();
        $tmp_file = tempnam(sys_get_temp_dir(), 'LQD_SIMPLE_');
        if ($zip->open($tmp_file, ZipArchive::OVERWRITE) !== TRUE) {
          return $this->co_reg->document->getJson(['errtyp' => 'E', 'errtxt' => 'Error creando ZIP.']);
        }

        $lo_busmdl = $this->co_reg->load->model('admbus');
        $lo_busmdl->load(array('buscod' => $this->co_reg->sec->buscod), false);
        $lo_stemdl = $this->co_reg->load->model('cnsste');
        $lo_stemdl->load(array('stecod' => $lo_cnslqdmdl->cnslqddoc[0]['stecod']));
        $lv_lndtwntxt = $lo_stemdl->adr->lndtwntxt;

        $lv_root_folder = 'PE ' . $lv_cnslqdcodext . ' ' . $lv_lndtwntxt . ' LOC';
        $lv_root_folder = preg_replace('/[^a-zA-Z0-9_-]/', ' ', $lv_root_folder);

        $lo_ctr_sub = $this->co_reg->load->controller('zcuslf');

        // Generar PDFs por proyecto
        foreach ($lv_events_by_project as $lv_proyecto => $lv_data) {
          $lv_proyecto_formatted = str_pad($lv_proyecto, 12, '0', STR_PAD_LEFT);

          // Limpiar cnttxt para nombre de archivo
          $lv_cnttxt_clean = preg_replace('/[^a-zA-Z0-9_-]/', ' ', $lv_data['cnttxt']);
          $lv_filename_base = $lv_proyecto_formatted . ' ' . $lv_cnttxt_clean;

          // Precertificación
          $lo_mdl_pec = clone $lo_cnslqdmdl;
          $lo_mdl_pec->lndtwntxt = $lv_lndtwntxt;
          $lo_mdl_pec->cnslqddoc = $lv_data['items'];

          $pdf_precert = $this->co_reg->document->getView('zcuslf_cnslqdprecrtpnt', [
              'data' => $lo_mdl_pec,
              'bus' => $lo_busmdl,
              'actcod' => $this->data['actcod']
          ]);

          // Asistencias
          $lv_pdfbin_asist = $lo_ctr_sub->index('evtfrmasstecpnt', [
              'steevtcod' => $lv_data['events'],
              'msgqty' => 1
          ]);

          if (!empty($pdf_precert) && is_string($pdf_precert)) {
            $zip->addFromString($lv_root_folder . '/' . $lv_filename_base . '_PRECERT.pdf', $pdf_precert);
          }

          if (!empty($lv_pdfbin_asist) && is_string($lv_pdfbin_asist)) {
            $zip->addFromString($lv_root_folder . '/' . $lv_filename_base . '_ASIST.pdf', $lv_pdfbin_asist);
          }
      	}	

        // Excel y Libro
        $lv_xlsdat = $lo_ctr_sub->index('cnslqdrpt', ['vewfldflt' => $lv_vewfldflt]);
        $rows = $lv_xlsdat ?? [];

        $def1 = [
            ["key" => "steevtdte", "label" => "FECHA", "type" => "DATE"],
            ["key" => "steevtdocpec", "label" => "P EMPRE", "type" => "TEXT"],
            ["key" => "steevtdocrem", "label" => "REMITO", "type" => "TEXT"],
            ["key" => "cnssteatrpry", "label" => "OT REF", "type" => "TEXT"],
            ["key" => "cnstsktyp", "label" => "TIPO DE TRABAJO", "type" => "TEXT"],
            ["key" => "steevtadr", "label" => "DIRECCION", "type" => "TEXT"],
            ["key" => "cnslqddocqty", "label" => "CANT", "type" => "NUMBER"],
            ["key" => "cnslqddocprc", "label" => "UNIT", "type" => "NUMBER"],
            ["key" => "cnslqddocsubtot", "label" => "SUBT", "type" => "NUMBER"],
            ["key" => "cnslqddocrec", "label" => "REC", "type" => "NUMBER"],
            ["key" => "cnslqddoctot", "label" => "TOTAL", "type" => "NUMBER"],
            ["key" => "cnstskrspobjtxt", "label" => "OFICIAL", "type" => "TEXT"],
            ["key" => "cnttxt", "label" => "CONTACTO", "type" => "TEXT"],
        ];

        function generarExcelSimple($rows, $definition)
        {
            ob_start();
            ?>
            <html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel"
                xmlns="http://www.w3.org/TR/REC-html40">

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                <style>
                    table {
                        border-collapse: collapse;
                        width: 100%;
                        font-family: Arial, sans-serif;
                        font-size: 12px
                    }

                    td,
                    th {
                        border: 1px solid #999;
                        padding: 5px;
                        vertical-align: middle
                    }

                    .header {
                        background-color: #002060;
                        color: #fff;
                        font-weight: bold;
                        text-align: center;
                        height: 30px
                    }

                    .num {
                        text-align: right;
                        white-space: nowrap
                    }

                    .txt {
                        text-align: left;
                        mso-number-format: "\@"
                    }

                    .date {
                        text-align: center
                    }
                </style>
            </head>

            <body>
                <table>
                    <thead>
                        <tr>
                                                <?php foreach ($definition as $col): ?>
                                <th class="header"><?php echo htmlspecialchars($col['label']); ?></th><?php endforeach; ?>
                        </tr>
                    </thead>
                    <tbody>
                                            <?php foreach ($rows as $row): ?>
                            <tr>
                                                        <?php foreach ($definition as $col):
                                                            $val = $row[$col['key']] ?? '';
                                                            if ($val instanceof DateTime || $val instanceof DateTimeImmutable) {
                                                                $val = $val->format(($col['type'] === 'TIME') ? 'H:i' : 'd/m/Y');
                                                            }
                                                            $cssClass = ($col['type'] === 'NUMBER') ? 'num' : (($col['type'] === 'DATE' || $col['type'] === 'TIME') ? 'date' : 'txt');
                                                            ?>
                                                                <td class="<?php echo $cssClass; ?>"><?php echo htmlspecialchars((string) $val); ?></td>
                              <?php endforeach; ?>
                            </tr><?php endforeach; ?>
                    </tbody>
                </table>
            </body>

            </html>
            <?php
            return ob_get_clean();
        }

        $htmlLiquidacion = generarExcelSimple($rows, $def1);
        $zip->addFromString($lv_root_folder . '/RESUMEN PE ' . $lv_cnslqdcodext . '.xls', $htmlLiquidacion);

        $lv_pdfbok = $lo_ctr_sub->index('cnslqdbokpnt', ['cnslqdcod' => $lv_cnslqdcod, 'msgqty' => 1]);
        if (!empty($lv_pdfbok) && is_string($lv_pdfbok)) {
          $zip->addFromString($lv_root_folder . '/PE LIBRO ' . $lv_cnslqdcodext . '.pdf', $lv_pdfbok);
        }

        $zip->close();
        ini_set('memory_limit', $lv_lmtmem);

        if (file_exists($tmp_file)) {
          while (ob_get_level())
              ob_end_clean();
          header('Content-Description: File Transfer');
          header('Content-Type: application/zip');
          header('Content-Disposition: attachment; filename="Liquidacion_Simple_' . $lv_cnslqdcodext . '.zip"');
          header('Content-Length: ' . filesize($tmp_file));
          header('Pragma: public');
          header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
          header('Expires: 0');
          readfile($tmp_file);
          unlink($tmp_file);
          exit;
        } else {
          return $this->co_reg->document->getJson(['errtyp' => 'E', 'errtxt' => 'Error al generar ZIP.']);
        }
        break;  
        
        
      // REPORTE EDENOR / CERTIFICACION
      case '#cnslqdrpt':
        $lo_post = $this->co_reg->request->post;

        // Gestión de memoria 
        $lv_lmtmem = ini_get('memory_limit');
        ini_set('memory_limit', '2048M');

        $lv_vewfldflt = $lo_post['vewfldflt'] ?? $lp_prm['vewfldflt'] ?? '';

        // Carga de Liquidación (Cabecera y Detalle)
        $lo_cnslqdmdl = $this->co_reg->load->model('cnslqd');
        $lv_prmlqd = array('vewfldflt' => $lv_vewfldflt);
        $lo_rslqd = $lo_cnslqdmdl->getList($lv_prmlqd, null, null, false);

        if (empty($lo_rslqd)) {
          return array();
        }

        $lv_cnslqdcod = $lo_rslqd[0]['cnslqdcod'];
        $lv_codext = $lo_rslqd[0]['cnslqdcodext'];
        $lv_cnslqddte = $lo_rslqd[0]['ctedte'] ?? '';

        $lo_cnslqdmdl->load(array('cnslqdcod' => $lv_cnslqdcod), false);
        $lo_lqddoc = $lo_cnslqdmdl->cnslqddoc; // Detalle de la liquidación

        // Recolección de IDs 
        $lv_idsevt = []; // IDs de Eventos (refobjcod002)
        $lv_idsdoc = []; // IDs de Documentos (refobjcod001)
        $lv_rows = []; // Filas a procesar

        foreach ($lo_lqddoc as $row) {
          if (!empty($row['refobjcod002']))
              $lv_idsevt[] = $row['refobjcod002'];
          if (!empty($row['refobjcod001']))
              $lv_idsdoc[] = $row['refobjcod001'];
          // Obtengo datos de la obra 
          $lo_stemdl = $this->co_reg->load->model('cnsste');
          $lo_stemdl->load(array('stecod' => $row['stecod']));
          $row['cnssteatrpry'] = $this->co_reg->document->getTagValue($lo_stemdl->cnssteatr, 'atr_pry');
          $row['lndtwntxt'] = $lo_stemdl->adr->lndtwntxt;
          $row['lndtwngrptxt'] = $lo_stemdl->adr->lndtwngrptxt;
          $row['adrzontxt'] = $lo_stemdl->adr->adrzontxt;
          //Obtengo el contacto de la obra 
          $lo_cntmdl = $this->co_reg->load->model('grldatcnt');
          $lv_flt = array(
              'vewfldflt' => '[~fltrow~]c.cntsrctyp' . chr(9) . '=' . chr(9) . chr(9) . 'CNS_STE' . chr(9) . chr(9) .
                  '[~fltrow~]c.cntsrccod' . chr(9) . '=' . chr(9) . chr(9) . $lo_stemdl->stecod . chr(9) . chr(9) .
                  '[~fltrow~]ct.sysdocclscodext' . chr(9) . '=' . chr(9) . chr(9) . 'CCTEDENOR' . chr(9) . chr(9)
          );
          $lv_prm = array('cntsrctyp' => 'CNS_STE');
          $lv_arr_dat = $lo_cntmdl->getList($lv_flt, $lv_prm, null, false);
          $row['cnttxt'] = $lv_arr_dat[0]['cnttxt'] ?? '-';
          $lv_rows[] = $row;
        }

        // Mapa de Eventos 
        $lo_mapevt = [];
        if (!empty($lv_idsevt)) {
          $lv_idsevt = array_unique($lv_idsevt); // Evitar duplicados 
          $lo_evtmdl = $this->co_reg->load->model('cnssteevt');
          $lv_prm = array('vewfldflt' => '[~fltrow~]se.steevtcod' . chr(9) . 'IN' . chr(9) . chr(9) . implode(chr(10), $lv_idsevt) . chr(9) . chr(9));
          $lo_rs_evt = $lo_evtmdl->getList($lv_prm);

          foreach ($lo_rs_evt as $row) {
            $lo_mapevt[$row['steevtcod']] = $row;
          }
        }

        // Mapa de Documentos y Atributos JSON
        $lv_map_evtdoc = [];
        if (!empty($lv_idsdoc)) {
          $lv_idsdoc = array_unique($lv_idsdoc);
          $lo_evtdocmdl = $this->co_reg->load->model('cnssteevtdoc');
          $lv_prm = array('vewfldflt' => '[~fltrow~]sed.steevtdoccod' . chr(9) . 'IN' . chr(9) . chr(9) . implode(chr(10), $lv_idsdoc) . chr(9) . chr(9));
          $lo_rs_evtdoc = $lo_evtdocmdl->getList($lv_prm);

          foreach ($lo_rs_evtdoc as $row) {
            // Decodificamos el JSON 
            $lv_atr = json_decode(mb_convert_encoding($row['steevtdocatr'], 'UTF-8', 'iso-8859-1'), true); 
            //PLANIFICACION. cargo datos de la planificacion asociada a la obra
            $lo_cnsbudmdl = $this->co_reg->load->model('cnsbud');
            $lv_prm = array(
                'vewfldflt' => '[~fltrow~]b.stecod' . chr(9) . '=' . chr(9) . chr(9) . ($row['stecod']) . chr(9) . chr(9) .
                    '[~fltrow~]b.docsts' . chr(9) . '=' . chr(9) . chr(9) . 'A' . chr(9) . chr(9)
            );
            $lo_rs3 = $lo_cnsbudmdl->getList($lv_prm, null, null, false);
            $lo_cnsbudmdl->load(array('budcod' => $lo_rs3[0]['budcod']));
            $lo_evtmdl->budtsk = $lo_cnsbudmdl->budtsk;
            //busco la cuadrilla dentro de las tareas
            $lo_budtsk = $lo_cnsbudmdl->budtsk;//-->contiene integrantes

            $lv_cnstskcod = '';
            foreach ($lo_budtsk as $lp_i => $lp_row) {
              if (($lp_row['cnstskclscodext'] ?? '') == "CUADRILLA") {
                $lv_cnstskcod = $lp_row['srcobjcod001'];
                break;
              }
            }

            $lo_cnstskmdl2 = $this->co_reg->load->model('cnstsk');
            $lo_cnstskmdl2->load(array('cnstskcod' => $lv_cnstskcod));
            $lv_map_evtdoc[$row['steevtdoccod']] = [
                // Extraemos datos del JSON
                'cnstskcodext' => $lv_atr['cnstskcodext'] ?? '',
                'cnstskrspobjtxt' => $lo_cnstskmdl2->rspobjtxt ?? '',
                'cnstsktxt' => $lv_atr['cnstsktxt'] ?? '',
                'cnstsk' => $lv_atr['cnstskclscodext'] ?? '',
                'steevtdocpec' => $lv_atr['steevtdocpec'] ?? '', // PEC
                'steevtdocrem' => $lv_atr['steevtdocrem'] ?? '', // Remito
                'steevtdocpectme' => $lv_atr['steevtdocpectme'] ?? '',
                'steevtdocqty' => $lv_atr['steevtdocqty'] ?? '',
                'steevtdocpecdte' => $lv_atr['steevtdocpecdte'] ?? '',
                'cnstsktyp' => ($lv_atr['cnstskcodext'] ?? '') . ' ' . ($lv_atr['cnstsktxt'] ?? ''),    // Tipo de tarea
                'qty_orig' => $row['steevtdocqty'] ?? 0,         // Cantidad 
                'steevtadr' => 'De ' . ($lv_atr['steevtdocstrlnk'] ?? '') . ' a ' . ($lv_atr['steevtdocendlnk'] ?? '') . ' en ' . ($lv_atr['steevtdocadr'] ?? ''),// Dirección del evento
                'cnssteadr' => $lv_atr['steevtdocadr'] ?? ''

            ];
          }
        }

        ini_set('memory_limit', $lv_lmtmem);
        // Construcción del Array Final
        $lv_ret = [];
        $lv_prctot = 0;
        foreach ($lv_rows as $lv_lqdrow) {
          // Claves de enlace
          $lv_id_evt = $lv_lqdrow['refobjcod002'] ?? '';
          $lv_id_doc = $lv_lqdrow['refobjcod001'] ?? '';

          // Obtener datos auxiliares
          $lv_evtdat = $lo_mapevt[$lv_id_evt] ?? [];
          $lv_docdat = $lv_map_evtdoc[$lv_id_doc] ?? [];

          // Mapeo final
          $lv_data = [
              // Datos de la Liquidación
              'cnslqdcodext' => $lv_codext,
              'cnslqddte' => $lv_cnslqddte,
              'cnslqddocqty' => (float) ($lv_lqdrow['cnslqddocqty'] ?? 0),
              'cnslqddocprc' => (float) ($lv_lqdrow['cnslqddocprc'] ?? 0),
              'cnslqddoctot' => (float) ($lv_lqdrow['cnslqddoctot'] ?? 0),
              'cnslqddocrec' => (float) ($lv_lqdrow['cnslqddocrec'] ?? 0),
              'cnslqddocsubtot' => (float) (($lv_lqdrow['cnslqddocqty'] ?? 0) * ($lv_lqdrow['cnslqddocprc'] ?? 0)),
              'cnslqddoccrt' => '-',
              'cnslqddocsts' => 'REALIZADA',
              'cnstskrspobjtxt' => $lv_docdat['cnstskrspobjtxt'],
              'cnttxt' => $lv_lqdrow['cnttxt'],

              // Datos del Evento 
              'steevtdte' => $lv_evtdat['steevtdte'] ?? '',
              'cnssteadr' => $lv_docdat['cnssteadr'] ?? '',
              'steevtadr' => $lv_docdat['steevtadr'] ?? '',
              'cnssteatrpry' => $lv_lqdrow['cnssteatrpry'] ?? '', // Atributo proyecto
              'cnssteatrpryid' => str_pad($lv_lqdrow['cnssteatrpry'] ?? '', 12, '0', STR_PAD_LEFT),
              'lndtwntxt' => $lv_lqdrow['lndtwntxt'] ?? '',
              'lndtwngrptxt' => $lv_lqdrow['lndtwngrptxt'] ?? '',
              'adrzontxt' => $lv_lqdrow['adrzontxt'] ?? '',

              // Datos del Documento / Tarea 
              'steevtdocqty' => $lv_docdat['steevtdocqty'] ?? 0,
              'cnstskcodext' => $lv_docdat['cnstskcodext'] ?? '',
              'cnstsktxt' => $lv_docdat['cnstsktxt'] ?? '',
              'steevtdocpec' => $lv_docdat['steevtdocpec'] ?? '',
              'steevtdocrem' => $lv_docdat['steevtdocrem'] ?? '',
              'cnstsktyp' => $lv_docdat['cnstsktyp'] ?? '',
              'cnstsksubtyp' => '-',

              // Fechas del PEC 
              'steevtdocpecdte' => $lv_docdat['steevtdocpecdte'] ?? '',
              'steevtdocpectme' => $lv_docdat['steevtdocpectme'] ?? '',

              // Otros 
              'cnstsk' => 'BAREMO',
              'cnslqdprecrtsvc' => 9000008061
          ];

          $lv_ret[] = $lv_data;
          $lv_prctot += $lv_data['cnslqddoctot'];
        }

        if($lv_prctot){
          //Acomodo las keys del array para el return
          $lv_keys = array_keys($lv_ret[0]); 
          $lv_total = array_fill_keys($lv_keys, ''); 

          // Sobrescribe los valores específicos
          $lv_total['steevtdocpec'] = $lv_codext;
          $lv_total['cnslqddocqty'] = 0;
          $lv_total['cnslqddocprc'] = 0;
          $lv_total['cnslqddocsubtot'] = 0;
          $lv_total['cnslqddocrec'] = 0;
          $lv_total['steevtdocqty'] = 0;
          $lv_total['cnslqddoctot'] = $lv_prctot;

          $lv_ret[] = $lv_total;
        }		

        return $lv_ret;
      	break;
		}	
  }
  
  private function getPecTskcodHie($lp_cnslqddoc, $lp_cnstskclscodext = ''){
    if(empty($this->data['pectskcodhie'])){
    	$lv_cnslqddochie = [];

     	foreach ($lp_cnslqddoc as $lv_row) {
        $lv_key = $lv_row['refobjcod001']; // steevtdoccod
        $lv_evtdocatr = json_decode(mb_convert_encoding($lv_row['steevtdocatr'], 'UTF-8', 'iso-8859-1'), true); 

        if (!isset($lv_evtdocatr['cnstskclscodext']) || !($lv_evtdocatr['cnstskclscodext'] == $lp_cnstskclscodext || $lp_cnstskclscodext == '')) { continue; }

        // MRG: Merged (Fila fusionada)
        $lv_rowmrg = array_merge($lv_row, $lv_evtdocatr);

        // Variables temporales cortas para decisión
        $lv_pec = $lv_rowmrg['steevtdocpec'] ?: 'GENERAL';
        $lv_tskcod = $lv_rowmrg['cnstskcod'] ?: 'UNI_' . $lv_key; // UNI = Único

        // --- AGRUPACIÓN JERÁRQUICA ---
        // Nivel 1: PEC
        if (!isset($lv_cnslqddochie[$lv_pec])) {
            $lv_cnslqddochie[$lv_pec] = array();
        }

        // Nivel 2: TSKCOD (Item)
        if (isset($lv_cnslqddochie[$lv_pec][$lv_tskcod])) {
            // QTY: Quantity (Acumulamos cantidad)
            $lv_cnslqddochie[$lv_pec][$lv_tskcod]['cnslqddocqty'] += (float) $lv_rowmrg['cnslqddocqty'];
        } else {
            $lv_cnslqddochie[$lv_pec][$lv_tskcod] = $lv_rowmrg; // Nuevo ingreso en la jerarquía
        }
     	}
      $this->data['pectskcodhie'] = $lv_cnslqddochie;
		}
    
    return $this->data['pectskcodhie'];
  }
  
  // devuelve todos los proyectos a los que pertenecen los eventos provistos
  // "info del proyecto": detalles de planificación, obra, eventos A2 y responsable de cuadrilla
  private function getPryInfoOfEvents($lp_evt_arr = []){
    if(empty($this->data['pryinfo_arr'])){
      $lv_stecods = implode(chr(10), array_column($lp_evt_arr, 'stecod'));

      // OBRA. cargo obras de las obras de los eventos. Cada obra es 1 proyecto
      $lo_stemdl = $this->co_reg->load->model('cnsste');
      $lv_prm = array( 'vewfldflt' => '[~fltrow~]s.stecod'.chr(9).'IN'.chr(9).chr(9).$lv_stecods.chr(9).chr(9) );
      $lv_ste_rs = $lo_stemdl->getList($lv_prm, null, null, false);

      //PLANIFICACION. cargo tareas de la planificacion asociada a las obras
      $lo_cnsbudmatmdl = $this->co_reg->load->model('cnsbudmat');
      $lv_prm = array(
          'vewfldflt' => '[~fltrow~]b.stecod'.chr(9).'IN'.chr(9).chr(9).$lv_stecods.chr(9).chr(9).
                        '[~fltrow~]b.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
          'vewfldord' => 'b.budcod'
      );
      $lv_budtks_rs = $lo_cnsbudmatmdl->getList($lv_prm, null, null, false);
      
      // solo nos quedamos con las tareas de 1 planificación de la obra que esté activa y sea la más reciente
      $lv_budtskbyste_arr = [];
      $lv_rspcodbyste_arr = [];
      foreach($lv_budtks_rs as $lo_budtsk){
        $lv_stecod = $lo_budtsk['stecod'];
        $lv_budcod = $lo_budtsk['budcod'];
        $lv_discarded = false;

        if( isset($lv_budtskbyste_arr[$lv_stecod]) ){
          if( key($lv_budtskbyste_arr[$lv_stecod]) == $lv_budcod ){
            $lv_budtskbyste_arr[$lv_stecod][$lv_budcod][] = $lo_budtsk;  
          }else{
            $lv_discarded = true;
          }
        }else{
          $lv_budtskbyste_arr[$lv_stecod] = array($lv_budcod => array($lo_budtsk));
        }

        // guardo tarea de cuadrilla para luego recuperar el responsable de cada obra
        if(!$lv_discarded && ($lo_budtsk['cnstskclscodext'] ?? '') == 'CUADRILLA' && !isset($lv_rspcodbyste_arr[$lv_stecod])){
          $lv_rspcodbyste_arr[$lv_stecod] = $lo_budtsk['srcobjcod001'];
        }   
      }

      // RESPONSABLE. Busca al responsable de cuadrilla de cada obra
      $lo_cnstskmdl = $this->co_reg->load->model('cnstsk');
      $lv_prm = array( 'vewfldflt' => '[~fltrow~]t.cnstskcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lv_rspcodbyste_arr).chr(9).chr(9) );
      $lv_sqdtsk_arr = $lo_cnstskmdl->getList($lv_prm, null, null, false);
      $lv_rsptxt_arr = array_column($lv_sqdtsk_arr, 'rspobjtxt', 'cnstskcod');

      $lv_pryinfo = [];
      foreach($lv_ste_rs as $lo_ste){
        $lv_pry = $this->co_reg->document->getTagValue($lo_ste['cnssteatr'], 'atr_pry');
        if(empty($lv_pry)) $lv_pry = '000000000000';
        $lv_stecod = $lo_ste['stecod'];
        $lv_pryinfo[$lv_pry] = $lo_ste; 
        $lv_pryinfo[$lv_pry]['rspobjtxt'] = $lv_rsptxt_arr[$lv_rspcodbyste_arr[$lv_stecod]];
        $lv_pryinfo[$lv_pry]['budtsk'] = array_values($lv_budtskbyste_arr[$lv_stecod])[0];
        $lv_a2evts = array_filter($lp_evt_arr, function($lv_evt) use($lv_stecod){ return $lv_evt['stecod'] == $lv_stecod; });
        foreach($lv_a2evts as &$lv_a2){
          if(!isset($lv_a2['evtdoc'])){
        		$lv_evtdocatr = json_decode(mb_convert_encoding($lv_a2['steevtdocatr'], 'UTF-8', 'iso-8859-1'), true); 
						$lv_a2['evtdoc']['steevtdocatr'] = $lv_evtdocatr;
          }
        }
        unset($lv_a2); 
        $lv_pryinfo[$lv_pry]['a2evts'] = $lv_a2evts;
      }
      
      $this->data['pryinfo_arr'] = $lv_pryinfo;
		}
    
    return $this->data['pryinfo_arr'];
  }
}
?>
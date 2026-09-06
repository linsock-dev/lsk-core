 <?php
final class zcutp1_tmgController extends tmssController {
	const MODEL = 'zcutp1';
	const VIEW  = 'zcutp1_tmg';
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

      // C A R G A   M A S I V A   C A P A C I T A C I O N E S
      case '#hltcapblk':
          $lo_data = array();
          
          // Inicializamos
          $lo_data['prsclscodlst'] = ''; 
          $lo_data['crmcnttyp']    = '';

          // Cargamos el parámetro de empresa/módulo 'CAPBLK'
          $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');
          if ($lo_prmmdl->load(array('mdlcod' => 'CAPBLK'), false)) {
              $lv_prmraw = $lo_prmmdl->mdlatrval001;
              
              // Extraemos las listas configuradas
              $lo_data['prsclscodlst'] = $this->co_reg->document->gettagvalue($lv_prmraw, 'prsclscodlst');
              $lo_data['crmcnttyp']    = $this->co_reg->document->gettagvalue($lv_prmraw, 'crmcnttyp');
            	$lo_data['crmcntmtv']    = $this->co_reg->document->gettagvalue($lv_prmraw, 'crmcntmtv');
          }

          return $this->co_reg->document->getView('zcutp1_tincapblk', array(
              'data'   => $lo_data, 
              'actcod' => $this->data['actcod']
          ));
      break;
    case '#hltcapblksve':
          $lo_pst = $this->co_reg->request->post;

          // 1. Validaciones iniciales
          if (empty($lo_pst['hltcatvalcod']) || empty($lo_pst['tbl_prscod'])) {
              return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => -1, 'errtxt' => 'Faltan datos obligatorios.'));
          }
          // 2. BUSQUEDA DINÁMICA DE CLASE DE DOCUMENTO (Para HLT_PRS)
          $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
          $lv_prmdoccls = array(
              'vewfldflt' => '[~fltrow~]d.objtyp' . chr(9) . '=' . chr(9) . chr(9) . 'CRM_CNT' . chr(9) . chr(9) .
                             '[~fltrow~]d.docsts' . chr(9) . '=' . chr(9) . chr(9) . 'A'       . chr(9) . chr(9)
          );
          // Pasamos la variable definida
          $lo_doccls_rs = $lo_docclsmdl->getList($lv_prmdoccls, null, null, false);

          $lv_sysdocclscod = null;
          foreach ($lo_doccls_rs as $lv_row) {
              if ($this->co_reg->document->gettagvalue($lv_row['sysdocclsatr'], 'srcobjtyp') === 'HLT_PRS') {
                  $lv_sysdocclscod = $lv_row['sysdocclscod'];
                  break;
              }
          }

          $lv_prslst = $lo_pst['tbl_prscod'];    
          $lv_catlst = $lo_pst['hltcatvalcod'];   
          $lv_errlst = array();                   
          $lv_proqty = 0;                         

          $lo_capmdl = $this->co_reg->load->model('hltprscat');
          $lo_crmmdl = $this->co_reg->load->model('crmcnt');
          $lo_mtvmdl = $this->co_reg->load->model('crmcntmtv');

          foreach ($lv_prslst as $lv_prscod) {
              
              // -------------------------------------------------------------
              // A. GESTIÓN DE CAPACITACIONES
              // -------------------------------------------------------------
              $lo_capmdl->create();
              $lo_existing_rs = $lo_capmdl->load(array('prscod' => $lv_prscod));

              $lv_catproqty = 0; 
							$lv_catpntlst=array();
              foreach ($lv_catlst as $lv_catcod) {
                  $lv_hltprscatcod = '';
                  if (is_array($lo_existing_rs) && count($lo_existing_rs) > 0) {
                      foreach ($lo_existing_rs as $lv_row) {
                          if ($lv_row['hltcatcod'] == $lo_pst['hltcatcod'] && $lv_row['hltcatvalcod'] == $lv_catcod) {
                              if (($lv_row['docsts'] ?? 'A') != 'A') continue;
                              // Obtenemos el ID para forzar el UPDATE. 
                              $lv_hltprscatcod = $lv_row['hltprscatcod'] ?? '';
                              break; 
                          }
                      }
                  }

                  $lo_capmdl->create();
                  $lv_capdat = array(
                      'prscod'       => $lv_prscod,
                      'hltcatcod'    => $lo_pst['hltcatcod'], 
                      'hltcatvalcod' => $lv_catcod,
                      'hltcatstrdte' => $lo_pst['capstrdte'], 
                      'hltcatenddte' => $lo_pst['capenddte'] ?? '', 
                      'docsts'       => 'A'
                  );

                  // Asignamos ID
                  if (!empty($lv_hltprscatcod)) {
                      $lv_capdat['hltprscatcod'] = $lv_hltprscatcod;
                  }

                  if (!$lo_capmdl->save($lv_capdat, false)) {
                      $lv_errlst[] = "Error en Prestador {$lv_prscod} (Cat {$lv_catcod}): {$lo_capmdl->errtxt}";
                  } else {
                      $lv_proqty++; 
                      $lv_catproqty++; 
                  }
              }
              // -------------------------------------------------------------
              // B. CREACIÓN DE CONTACTO CRM 
              // -------------------------------------------------------------
              if ($lv_catproqty > 0 && !empty($lo_pst['crmcnttypcod'])) {
                  
                  $lo_crmmdl->create();
                  
                  // Obtenemos prioridad y estado desde la configuración del motivo
                  $lv_crmcntmtvcod = $lo_pst['crmcntmtvcod'];
        
                  $lo_mtvmdl->create();
                  if ($lo_mtvmdl->load(array('crmcntmtvcod' => $lv_crmcntmtvcod), false)) {
                      // Asignamos los valores de la configuración de motivos
                      $lv_crmcntprtcod = $lo_mtvmdl->crmcntprtcod;
                      $lv_crmcntstscod = $lo_mtvmdl->crmcntstscod;
                  }
                  
                  // Armamos la descripción con las categorías
                  $lv_catstr_arr = array();
                  foreach ($lv_catlst as $lv_catid) {
                      $lv_catstr_arr[] = $lo_pst['hltcatvaltxt'][$lv_catid] ?? $lv_catid;
                  }
                  // Formato con saltos de línea y tabulación 
                  $lv_crmcntrqs = $lo_pst['crmcntdsc'] . "\r\n\r\nCategorías:\r\n    " . implode("\r\n    ", $lv_catstr_arr);
                  
                  $lv_crmdat = array(
                      'crmcnttypcod' => $lo_pst['crmcnttypcod'],
                      'crmcntmtvcod' => $lv_crmcntmtvcod,
                      'crmcnttxt'    => $lo_pst['crmcnttxt'],
                      'crmcntrefdoc' => $lo_pst['crmcntref'] ?? '', 
                      'crmcntrqs'    => $lv_crmcntrqs, 
                      
                      'crmcntsrctyp' => 'HLT_PRS',  
                      'crmcntsrccod' => $lv_prscod, 
                      
                      'crmcntdte'    => date('d/m/Y'), 
                      'sysdocclscod' => $lv_sysdocclscod, 
                      
                      // Asignación directa desde la configuración del motivo
                      'crmcntprtcod' => $lv_crmcntprtcod,
                      'crmcntstscod' => $lv_crmcntstscod,
                      
                      'docsts'       => 'A',
                    	'usrcod'			 => $this->co_reg->sec->usrcod
                  );

                  // Guardamos el registro
                  if (!$lo_crmmdl->save($lv_crmdat, false)) {
                      $lv_errlst[] = "Error al registrar Historial CRM (Prestador {$lv_prscod}): {$lo_crmmdl->errtxt}";
                  }
              }
            	if(1==1){
                
              
            	// -------------------------------------------------------------
              // C. CREACIÓN CERTFICADO EN PDF
              // -------------------------------------------------------------
            	//Busco los datos del prestador
            	$lo_prsmdl = $this->co_reg->load->model('hltprs');
            	;
            	if ( $lo_prsmdl->load(array('prscod'=>$lv_prscod),false) == false ) {
              	$lv_errlst[] = "No fue posible cargar el prestador (Prestador {$lv_prscod}): {$lo_prsmdl->errtxt}";
              }
            	//var_dump($lv_catstr_arr);
            	$lo_prsmdl->hltcatvallst=$lv_catstr_arr;
              $lv_prm = array('lang'  => $this->co_reg->language,
                              'doc' => $this->co_reg->document,
                              'data' => $lo_prsmdl
                              );   
              $lv_buffer = 	$this->co_reg->load->view('zcutp1_tinhltcapblkpnt', $lv_prm);
                
              // -------------------------------------------------------------
              // D. ENVIO DE CERTIFICADO POR MAIL
              // -------------------------------------------------------------
            	// obtengo mensaje de notificacion
              $lvTxtCodExt='TXTCAPEML';
              $lo_txtmdl = $this->co_reg->load->model('grldattxt');
              if( $lo_txtmdl->load(array('txtcodext' => $lvTxtCodExt, 'txtsys' => 1), false) ){
                  $lv_usrmsg = $lo_txtmdl->txttxt;
              } else {
                	$lv_errlst[] = "No se pudo cargar el texto para enviar el mail al prestador (Prestador {$lv_prscod})";
              }
            
            	$lo_eml = new tmssMail();
              $lv_emlprm['to'] =array(array('address' => $lo_prsmdl->adr->adreml));
              $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) ); 
              $lo_ntf_arr[] = array('ntftyp' => 'ntfstsnew');
              $lv_emlprm['subject'] = 'Certificado de ' . $lo_pst['crmcnttxt'];
              $lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
							$lv_usrmsg = str_replace( '[%2]', $lo_prsmdl->prstxt, $lv_usrmsg );
            	$lv_emlprm['bodyhtml'] = $lv_usrmsg;
            	$lv_emlprm['attachmentsString'] =array(array(	'file'       => $lv_buffer,
                                                            'fileName'   => 'Certificado',
                                                            'fileFormat' => 'base64',
                                                            'mimeType'   => 'application/pdf'
                                                            ));
              
            if ( !$lo_eml->send( $lv_emlprm ) ) {
            	$lv_errlst[] = "No fue posible enviar el mail al prestador (Prestador {$lv_prscod}): {$lo_eml->getError()}";
            } 
          }
					}
          // 3. Respuesta final 
          $lv_errtyp = 'S';
          $lv_errcod = 0;

          if (count($lv_errlst) > 0) {
              $lv_errtyp = 'W';
              $lv_errcod = 1;
              $lv_msg = 'Se procesaron '.$lv_proqty.' registros. Errores: '.implode(' | ', $lv_errlst);
          } elseif ($lv_proqty == 0) {
              $lv_errtyp = 'W';
              $lv_msg = 'No se registraron cambios válidos.';
          } else {
              $lv_msg = 'Carga exitosa.';
          }
          return $this->co_reg->document->getJson(array('errtyp' => $lv_errtyp,'errcod' => $lv_errcod,'errtxt' => $lv_msg));
      	break;
      case '#prscappnt': {
          $lo_post = $this->co_reg->request->post;
          $lv_crmcntcod = $lo_post['srcobjcod'];
          $lo_crmmdl = $this->co_reg->load->model('crmcnt');
          if ( $lo_crmmdl->load(array('crmcntcod'=>$lv_crmcntcod),false) == false ) {
            $lv_errlst[] = "No fue posible cargar el prestador (Prestador {$lv_prscod}): {$lo_prsmdl->errtxt}";
          }
          $lv_prscod=$lo_crmmdl->crmcntsrccod;

          // -------------------------------------------------------------
          // A. CREACIÓN CERTFICADO EN PDF
          // -------------------------------------------------------------
          //Busco los datos del prestador
          $lo_prsmdl = $this->co_reg->load->model('hltprs');
          if ( $lo_prsmdl->load(array('prscod'=>$lv_prscod),false) == false ) {
            $lv_errlst[] = "No fue posible cargar el prestador (Prestador {$lv_prscod}): {$lo_prsmdl->errtxt}";
          }


          $texto= $lo_crmmdl->crmcntrqs;
          $lineas = preg_split('/\r\n|\r|\n/', $texto);

          $categorias = [];
          $enCategorias = false;
          foreach ($lineas as $linea) {
            $linea = trim($linea);

            if (stripos($linea, 'Categor') === 0) {
                $enCategorias = true;
                continue;
            }

            if ($enCategorias && $linea !== '') {
                $categorias[] = $linea;
            }
          }
          $lo_prsmdl->hltcatvallst=$categorias;
          $lv_prm = array('lang'  => $this->co_reg->language,
                          'doc' => $this->co_reg->document,
                          'data' => $lo_prsmdl
                          );   
          $lv_buffer = 	$this->co_reg->load->view('zcutp1_tinhltcapblkpnt', $lv_prm);
        

          // -------------------------------------------------------------
          // D. ENVIO DE CERTIFICADO POR MAIL
          // -------------------------------------------------------------
          // obtengo mensaje de notificacion
          $lvTxtCodExt='TXTCAPEML';
          $lo_txtmdl = $this->co_reg->load->model('grldattxt');
          if( $lo_txtmdl->load(array('txtcodext' => $lvTxtCodExt, 'txtsys' => 1), false) ){
              $lv_usrmsg = $lo_txtmdl->txttxt;
          } else {
              $lv_errlst[] = "No se pudo cargar el texto para enviar el mail al prestador (Prestador {$lv_prscod})";
          }

          $lo_eml = new tmssMail();
          $lv_emlprm['to'] =array(array('address' => $lo_prsmdl->adr->adreml));
          $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) ); 
          $lo_ntf_arr[] = array('ntftyp' => 'ntfstsnew');
          $lv_emlprm['subject'] = 'Certificado de ' . $lo_crmmdl->crmcnttxt; 
          $lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
         	$lv_usrmsg = str_replace( '[%2]', $lo_prsmdl->prstxt, $lv_usrmsg );
          $lv_emlprm['bodyhtml'] = $lv_usrmsg;
          $lv_emlprm['attachmentsString'] =array(array(	'file'       => $lv_buffer,
                                                        'fileName'   => 'Certificado',
                                                        'fileFormat' => 'base64',
                                                        'mimeType'   => 'application/pdf'
                                                        ));

        if ( !$lo_eml->send( $lv_emlprm ) ) {
          $lv_errlst[] = "No fue posible enviar el mail al prestador (Prestador {$lv_prscod}): {$lo_eml->getError()}";
        } 
        $this->co_reg->response->addHeader('Content-type:application/pdf'); 
        return $lv_buffer;
        break;
      }
	  
	  // R E P O R T E   D E   P A C I E N T E S
	  // Origen PR: ?prg=zcutp1_tmg&act=hltpatrpt
	  // Origen PR con roles: ?prg=zcutp1_tmg&act=hltpatrlsrpt
	  case '#hltpatrpt':
	  case '#hltpatrlsrpt':
		$lv_withroles = ($lp_act==='#hltpatrlsrpt');
		$lo_post = $this->co_reg->request->post;
		$lv_fltstr = ($lo_post['vewfldflt']??'');
		$lv_ordstr = ($lo_post['vewfldord']??'');
		$lv_maxrec = trim((string)($lo_post['vewmaxrec']??'100'));

		// Roles en columnas: prm_rlscol001=MEC, prm_rlscol002=COORD, etc.
		// Si no se informan estos parametros, el origen conserva una fila por rol.
		$lo_rlscolcfg = array();
		foreach ( (array)$lp_prm as $lv_prmnme=>$lv_prmval ) {
			if ( !preg_match('/^prm_rlscol([0-9]{1,3})$/i', (string)$lv_prmnme, $lo_prmmtc) ) { continue; }
			$lv_colnme = 'rlscol'.str_pad($lo_prmmtc[1], 3, '0', STR_PAD_LEFT);
			$lo_rlscodlst = preg_split('/[,;|]+/', strtoupper((string)$lv_prmval));
			foreach ( $lo_rlscodlst as $lv_rlscodext ) {
				$lv_rlscodext = trim($lv_rlscodext);
				if ( $lv_rlscodext!='' ) { $lo_rlscolcfg[$lv_colnme][$lv_rlscodext] = $lv_rlscodext; }
			}
		}
		// Compatibilidad con el parametro usado por otros reportes de roles.
		if ( count($lo_rlscolcfg)==0 && trim((string)($lp_prm['prm_prsrlscodext']??''))!='' ) {
			$lv_rlscodext = strtoupper(trim((string)$lp_prm['prm_prsrlscodext']));
			$lo_rlscolcfg['rlscol001'][$lv_rlscodext] = $lv_rlscodext;
		}

		// Traduce los nombres publicados por el origen a los alias reales de HLT_PAT_DEF.
		$lo_patfldmap = array(
			'sysdocclstxt'=>'dc.sysdocclstxt', 'patcod'=>'p.patcod', 'patcodext'=>'p.patcodext',
			'pattxt'=>'p.pattxt', 'perbrndte'=>'pp.perbrndte', 'persex'=>'pp.persex',
			'docsts'=>'p.docsts', 'hltdisclstxt'=>'pdc.hltdisclstxt', 'adrzontxt'=>'pdz.adrzontxt',
			'lndregtxt'=>'lr.lndregtxt', 'custxt'=>'c.custxt', 'idttyptxt'=>'id.idttyptxt',
			'taxdocnum'=>'t.taxdocnum', 'hhrmedcovtxt'=>'pp.hhrmedcovtxt',
			'patreqdte'=>'p.patreqdte', 'patevldte'=>'p.patevldte', 'patinbdte'=>'p.patinbdte',
			'patoutdte'=>'p.patoutdte', 'patpro'=>'p.patpro', 'patwgt'=>'p.patwgt', 'pathgh'=>'p.pathgh',
			'hltpatclstxt'=>'pcl.hltpatclstxt', 'adrstr'=>'a.adrstr', 'adrtwn'=>'a.adrtwn',
			'adrcty'=>'a.adrcty', 'adrphn001'=>'a.adrphn001', 'adrphn002'=>'a.adrphn002',
			'adrmblphn'=>'a.adrmblphn', 'adreml'=>'a.adreml', 'lndtxt'=>'l.lndtxt',
			'adrstrnum'=>'a.adrstrnum', 'adrstrflr'=>'a.adrstrflr', 'adrstrunt'=>'a.adrstrunt',
			'adrstrbld'=>'a.adrstrbld', 'adrpstcod'=>'a.adrpstcod'
		);

		$lo_patfltarr = array();
		foreach ( explode('[~fltrow~]', (string)$lv_fltstr) as $lv_fltrow ) {
			if ( $lv_fltrow==='' ) { continue; }
			$lo_fltpart = explode(chr(9), $lv_fltrow);
			$lv_fld = strtolower(trim((string)($lo_fltpart[0]??'')));
			$lo_fldpart = explode('.', $lv_fld);
			$lv_fldcln = end($lo_fldpart);
			if ( !isset($lo_patfldmap[$lv_fldcln]) ) { continue; }
			$lo_fltpart[0] = $lo_patfldmap[$lv_fldcln];
			$lo_patfltarr[] = implode(chr(9), $lo_fltpart);
		}
		$lv_patflt = count($lo_patfltarr)>0 ? '[~fltrow~]'.implode('[~fltrow~]', $lo_patfltarr) : '';

		$lv_patord = '';
		if ( trim($lv_ordstr)!=='' && strpos($lv_ordstr, ',')===false ) {
			$lo_ordpart = preg_split('/\s+/', trim($lv_ordstr));
			$lo_fldpart = explode('.', strtolower(trim((string)($lo_ordpart[0]??''))));
			$lv_fldcln = end($lo_fldpart);
			if ( isset($lo_patfldmap[$lv_fldcln]) ) {
				$lv_patord = $lo_patfldmap[$lv_fldcln].(strtoupper((string)($lo_ordpart[1]??''))==='DESC'?' DESC':' ASC');
			}
		}
		$lo_patmdl = $this->co_reg->load->model('hltpat');
		$lo_patprm = array(
			'vewfldflt'=>$lv_patflt,
			'vewfldord'=>($lv_patord==''?'p.ctedte desc':$lv_patord),
			'vewmaxrec'=>$lv_maxrec
		);
		// Mantiene la misma autorizacion y las restricciones de usuario de HLT_PAT_DEF 08.
		$lo_patrs = $lo_patmdl->getList($lo_patprm, null, null, true);
		if ( !is_array($lo_patrs) || isset($lo_patrs['errtyp']) || count($lo_patrs)==0 ) { return $lo_patrs; }

		// HLT_PAT_DEF utiliza AdrStrNum para AdrDom pero no lo devuelve individualmente.
		$lo_patcodlst = array();
		foreach ( $lo_patrs as $lo_patrow ) {
			$lv_patcod = trim((string)($lo_patrow['patcod']??''));
			if ( $lv_patcod!='' ) { $lo_patcodlst[$lv_patcod] = $lv_patcod; }
		}
		$lo_patcodlst = array_values($lo_patcodlst);
		if ( count($lo_patcodlst)>0 ) {
			$lo_adrmdl = $this->co_reg->load->model('grldatadr');
			$lo_adrrs = $lo_adrmdl->getList(array(
				'vewfldflt'=>'[~fltrow~]a.adrsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_PAT'.chr(9).chr(9).
								 '[~fltrow~]a.adrsrccod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lo_patcodlst).chr(9).chr(9),
				'vewfldord'=>'a.adrnum'
			), array());
			$lo_adrnummap = array();
			foreach ( (array)$lo_adrrs as $lo_adrrow ) {
				$lv_patcod = trim((string)($lo_adrrow['adrsrccod']??''));
				if ( $lv_patcod!='' && !isset($lo_adrnummap[$lv_patcod]) ) {
					$lo_adrnummap[$lv_patcod] = ($lo_adrrow['adrstrnum']??'');
				}
			}
			foreach ( $lo_patrs as &$lo_patrow ) {
				$lv_patcod = trim((string)($lo_patrow['patcod']??''));
				$lo_patrow['adrstrnum'] = ($lo_adrnummap[$lv_patcod]??($lo_patrow['adrstrnum']??''));
			}
			unset($lo_patrow);
		}

		if ( !$lv_withroles ) { return $lo_patrs; }

		$lo_rlsfldmap = array(
			'patprsrlscod'=>'p.patprsrlscod', 'prsrlscod'=>'p.prsrlscod',
			'prsrlscodext'=>'r.prsrlscodext', 'prsrlstxt'=>'r.prsrlstxt',
			'prscod'=>'pr.prscod', 'prstxt'=>'pr.prstxt',
			'rlsusrcod'=>'p.usrcod', 'patprsrlsdocsts'=>'p.docsts',
			'patprsrlstxt'=>'dbo.GetTagValue(^patprsrlstxt^,p.patprsrlsatr001)',
			'patprsrlsphn'=>'dbo.GetTagValue(^patprsrlsphn^,p.patprsrlsatr001)',
			'rlsasgtxt'=>'(dbo.GetTagValue(^patprsrlstxt^,p.patprsrlsatr001)+isnull(pr.prstxt,^^))'
		);
		$lo_rlsfltarr = array();
		foreach ( explode('[~fltrow~]', (string)$lv_fltstr) as $lv_fltrow ) {
			if ( $lv_fltrow==='' ) { continue; }
			$lo_fltpart = explode(chr(9), $lv_fltrow);
			$lv_fld = strtolower(trim((string)($lo_fltpart[0]??'')));
			$lo_fldpart = explode('.', $lv_fld);
			$lv_fldcln = end($lo_fldpart);
			if ( !isset($lo_rlsfldmap[$lv_fldcln]) ) { continue; }
			$lo_fltpart[0] = $lo_rlsfldmap[$lv_fldcln];
			$lo_rlsfltarr[] = implode(chr(9), $lo_fltpart);
		}
		$lv_rlsflt = count($lo_rlsfltarr)>0 ? '[~fltrow~]'.implode('[~fltrow~]', $lo_rlsfltarr) : '';
		$lv_hasrlsflt = ($lv_rlsflt!='');

		$lv_rlsord = '';
		if ( trim($lv_ordstr)!=='' && strpos($lv_ordstr, ',')===false ) {
			$lo_ordpart = preg_split('/\s+/', trim($lv_ordstr));
			$lo_fldpart = explode('.', strtolower(trim((string)($lo_ordpart[0]??''))));
			$lv_fldcln = end($lo_fldpart);
			if ( isset($lo_rlsfldmap[$lv_fldcln]) ) {
				$lv_rlsord = $lo_rlsfldmap[$lv_fldcln].(strtoupper((string)($lo_ordpart[1]??''))==='DESC'?' DESC':' ASC');
			}
		}
		$lo_rlsmdl = $this->co_reg->load->model('hltpatprsrls');
		$lo_rlspvtcodlst = array();
		foreach ( $lo_rlscolcfg as $lo_rlscolcodlst ) {
			foreach ( $lo_rlscolcodlst as $lv_rlscodext ) { $lo_rlspvtcodlst[$lv_rlscodext] = $lv_rlscodext; }
		}
		$lv_rlspvtflt = count($lo_rlspvtcodlst)>0
			? '[~fltrow~]r.prsrlscodext'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),array_values($lo_rlspvtcodlst)).chr(9).chr(9)
			: '';
		$lo_rlsprm = array(
			'vewfldflt'=>'[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lo_patcodlst).chr(9).chr(9).
							 '[~fltrow~]p.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).$lv_rlspvtflt.$lv_rlsflt,
			'vewfldord'=>($lv_rlsord==''?'p.patcod, r.prsrlstxt, pr.prstxt':$lv_rlsord)
		);
		$lo_rlsrs = $lo_rlsmdl->getList($lo_rlsprm, null, null, true);
		$lo_rlsbypat = array();
		foreach ( (array)$lo_rlsrs as $lo_rlsrow ) {
			$lo_rlsbypat[(string)($lo_rlsrow['patcod']??'')][] = $lo_rlsrow;
		}

		// Con parametros de columnas se devuelve una sola fila por paciente.
		if ( count($lo_rlscolcfg)>0 ) {
			$lo_ret = array();
			foreach ( $lo_patrs as $lo_patrow ) {
				$lv_patcod = (string)($lo_patrow['patcod']??'');
				$lo_row = $lo_patrow;
				$lo_rlscolval = array();
				foreach ( $lo_rlscolcfg as $lv_colnme=>$lo_rlscodlst ) {
					$lo_row[$lv_colnme] = '';
					$lo_rlscolval[$lv_colnme] = array();
				}

				foreach ( ($lo_rlsbypat[$lv_patcod]??array()) as $lo_rlsrow ) {
					$lv_rlscodext = strtoupper(trim((string)($lo_rlsrow['prsrlscodext']??'')));
					$lv_rlsnme = trim((string)($lo_rlsrow['prstxt']??''));
					if ( $lv_rlsnme==='' ) {
						$lv_rlsnme = trim((string)$this->co_reg->document->getTagValue(($lo_rlsrow['patprsrlsatr001']??''), 'patprsrlstxt'));
					}
					if ( $lv_rlsnme==='' ) { continue; }
					foreach ( $lo_rlscolcfg as $lv_colnme=>$lo_rlscodlst ) {
						if ( isset($lo_rlscodlst[$lv_rlscodext]) ) { $lo_rlscolval[$lv_colnme][$lv_rlsnme] = $lv_rlsnme; }
					}
				}

				foreach ( $lo_rlscolval as $lv_colnme=>$lo_rlsnmelst ) {
					$lo_row[$lv_colnme] = implode('; ', array_values($lo_rlsnmelst));
				}
				$lo_ret[] = $lo_row;
			}
			if ( $lv_maxrec!=='' && intval($lv_maxrec)>0 ) { $lo_ret = array_slice($lo_ret, 0, intval($lv_maxrec)); }
			return $lo_ret;
		}

		$lo_ret = array();
		foreach ( $lo_patrs as $lo_patrow ) {
			$lv_patcod = (string)($lo_patrow['patcod']??'');
			$lo_patrls = ($lo_rlsbypat[$lv_patcod]??array());
			if ( count($lo_patrls)==0 ) {
				if ( $lv_hasrlsflt ) { continue; }
				$lo_patrls[] = array();
			}

			foreach ( $lo_patrls as $lo_rlsrow ) {
				$lo_row = $lo_patrow;
				$lv_atr = ($lo_rlsrow['patprsrlsatr001']??'');
				$lo_row['patprsrlscod'] = ($lo_rlsrow['patprsrlscod']??'');
				$lo_row['prsrlscod'] = ($lo_rlsrow['prsrlscod']??'');
				$lo_row['prsrlscodext'] = ($lo_rlsrow['prsrlscodext']??'');
				$lo_row['prsrlstxt'] = ($lo_rlsrow['prsrlstxt']??'');
				$lo_row['prscod'] = ($lo_rlsrow['prscod']??'');
				$lo_row['prstxt'] = ($lo_rlsrow['prstxt']??'');
				$lo_row['rlsusrcod'] = ($lo_rlsrow['usrcod']??'');
				$lo_row['patprsrlsdocsts'] = ($lo_rlsrow['docsts']??'');
				$lo_row['patprsrlstxt'] = $this->co_reg->document->getTagValue($lv_atr, 'patprsrlstxt');
				$lo_row['patprsrlsphn'] = $this->co_reg->document->getTagValue($lv_atr, 'patprsrlsphn');
				$lo_row['rlsasgtxt'] = trim($lo_row['prstxt'])!='' ? $lo_row['prstxt'] : $lo_row['patprsrlstxt'];
				$lo_ret[] = $lo_row;
			}
		}

		if ( $lv_maxrec!=='' && intval($lv_maxrec)>0 ) { $lo_ret = array_slice($lo_ret, 0, intval($lv_maxrec)); }
		return $lo_ret;
		break;

	  // R E P O R T E   D E   P L A N I F I C A C I O N
      case '#hltplnrep':
        $lv_lmtmem = ini_get('memory_limit');
        ini_set('memory_limit', '2048M');
        $lo_post = $this->co_reg->request->post;

        $lo_mdlplndte = $this->co_reg->load->model('hltplndte');

        $lv_vewfldord = (isset($lo_post['vewfldord']) && $lo_post['vewfldord'] != '') ? $lo_post['vewfldord'] : 'pld.plndte desc';

        $lv_fltarr = explode('[~fltrow~]', (isset($lo_post['vewfldflt']) ? $lo_post['vewfldflt'] : ''));
        $lv_fltarr = explode('[~fltrow~]', (isset($lo_post['vewfldflt']) ? $lo_post['vewfldflt'] : ''));
        for($i=count($lv_fltarr)-1; $i>0; $i--){
            $lv_fld = explode(chr(9), $lv_fltarr[$i])[0];

            // Limpiamos cualquier prefijo viejo que mande la vista
            $lv_fld_clean = strtolower(preg_replace('/^[a-zA-Z]+\./', '', $lv_fld));

            // Mapeamos los campos a las tablas correctas del modelo de detalle (hltplndte)
            if(stripos(';cuscod;patcod;prscod;spccod;docsts;', ';'.$lv_fld_clean.';') !== false){
                $lv_fltarr[$i] = str_replace($lv_fld, 'pl.'.$lv_fld_clean, $lv_fltarr[$i]);
            }
            elseif(stripos(';plndte;plndteto;', ';'.$lv_fld_clean.';') !== false){
                $lv_fltarr[$i] = str_replace($lv_fld, 'pld.'.$lv_fld_clean, $lv_fltarr[$i]);
            }
            elseif(stripos(';pattxt;patcodext;', ';'.$lv_fld_clean.';') !== false){
                $lv_fltarr[$i] = str_replace($lv_fld, 'p.'.$lv_fld_clean, $lv_fltarr[$i]);
            }
            elseif(stripos(';prstxt;', ';'.$lv_fld_clean.';') !== false){
                $lv_fltarr[$i] = str_replace($lv_fld, 'r.'.$lv_fld_clean, $lv_fltarr[$i]); 
            }
            elseif(stripos(';evldte;evldtecnv;', ';'.$lv_fld_clean.';') !== false){
                $lv_fltarr[$i] = str_replace($lv_fld, 'pld.evldte', $lv_fltarr[$i]);
            }
            elseif(stripos(';hltplnctrdte;', ';'.$lv_fld_clean.';') !== false){
                $lv_fltarr[$i] = str_replace($lv_fld, 'pld.'.$lv_fld_clean, $lv_fltarr[$i]);
            }
        }
        $lv_vewfldflt = (count($lv_fltarr) > 0 ? implode('[~fltrow~]', $lv_fltarr) : '');

        $lv_prmplndte = array(
            'vewfldflt' => $lv_vewfldflt,
            'vewmaxrec' => isset($lo_post['vewmaxrec']) ? $lo_post['vewmaxrec'] : '',
            'vewfldord' => $lv_vewfldord
        );

        $lo_rsplndte = $lo_mdlplndte->getList($lv_prmplndte, null, null, false);

        // POST-PROCESAMIENTO: Mapeo de Clase de Documento y Alias visuales
        if (is_array($lo_rsplndte) && count($lo_rsplndte) > 0) {
            $lo_mdldocls = $this->co_reg->load->model('sysdoccls');

            // Obtenemos los IDs de clases únicos
            $lv_clscods = array_unique(array_column($lo_rsplndte, 'sysdocclscod'));
            $lv_clsmap = array();

            // Consultamos el catálogo 1 sola vez
            if (count($lv_clscods) > 0) {
                $lo_rscls = $lo_mdldocls->getList(array('vewfldflt' => '[~fltrow~]sysdocclscod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lv_clscods).chr(9).chr(9)));
                foreach ((array)$lo_rscls as $lv_cls) {
                    $lv_clsmap[$lv_cls['sysdocclscod']] = $lv_cls['sysdocclstxt'];
                }
            }
            // Inyectamos los datos respetando las llaves 
            foreach ($lo_rsplndte as &$lv_row) {
                $lv_clstxt = isset($lv_clsmap[$lv_row['sysdocclscod']]) ? $lv_clsmap[$lv_row['sysdocclscod']] : '';

                // Replicamos el sysdocclstxt
                $lv_row['sysdocclstxt'] = $lv_clstxt;
                $lv_row['dc.sysdocclstxt'] = $lv_clstxt;

                // Replicamos el hltdisclstxt
                $lv_row['pdc.hltdisclstxt'] = isset($lv_row['hltdisclstxt']) ? $lv_row['hltdisclstxt'] : '';
            }
            unset($lv_row); 
        }

        ini_set('memory_limit', $lv_lmtmem);
        return $lo_rsplndte;
        break;
        
      // R E P O R T E   L I Q U I D A C I O N   D E S G L O S A D A
      case '#hltprslqddet':
          $lv_lmtmem = ini_get('memory_limit');
          ini_set('memory_limit', '2048M');
          $lo_post = $this->co_reg->request->post;
          // Carga de modelos
          $lo_mdllqd = $this->co_reg->load->model('hltprslqd');
          $lo_mdldoc = $this->co_reg->load->model('hltprslqddoc');
          $lo_mdlprs = $this->co_reg->load->model('hltprs');
          $lo_ret = array();

          // 1- FILTROS. Separo los filtros
          $lv_fltarrdoc = array(); 
          $lv_fltarrpst = array(); 
          $lv_fltarrlqd = explode('[~fltrow~]', $lo_post['vewfldflt']); 

          // Ordenamiento por defecto y limpieza de prefijos 
          $lv_vewfldord = (isset($lo_post['vewfldord']) && $lo_post['vewfldord'] != '') ? $lo_post['vewfldord'] : 'l.hltprslqdcod desc';
          $lv_vewfldord = str_replace('hltprslqddtecnv', 'l.hltprslqddte', $lv_vewfldord);
          $lv_vewfldord = str_replace('id.', '', $lv_vewfldord);

          for($i=count($lv_fltarrlqd)-1; $i>0; $i--){
            $lv_fldraw = explode(chr(9), $lv_fltarrlqd[$i])[0];
            $lv_fldcln = str_replace(array('id.','l.','ld.'), '', $lv_fldraw);

            // 1.1 Filtros Cabecera
            if(stripos(';hltprslqdcod;docsts;', ';'.$lv_fldcln.';') !== false){
              $lv_fltarrlqd[$i] = str_replace('id.', '', $lv_fltarrlqd[$i]);
              $lv_fltarrlqd[$i] = str_replace($lv_fldcln, 'l.'.$lv_fldcln, $lv_fltarrlqd[$i]);
            }
            // 1.2 Filtros Detalle
            elseif(stripos(';hltprslqddocdte;', ';'.$lv_fldcln.';') !== false){
              $lv_flttmp = str_replace('id.', '', $lv_fltarrlqd[$i]);
              array_push($lv_fltarrdoc, str_replace($lv_fldcln, 'ld.'.$lv_fldcln, $lv_flttmp));
              unset($lv_fltarrlqd[$i]); 
            }
            // 1.3 Post-Filtros (Memoria)
            elseif(in_array($lv_fldcln, array('spctxt','custxt','hltprslqdtxt','hltprslqddoctxt'))){
              $lv_fldval = explode(chr(9), $lv_fltarrlqd[$i]);
              array_push($lv_fltarrpst, array(
                'fldname' => $lv_fldcln, 
                'fldval'  => (isset($lv_fldval[2]) ? strtolower(trim($lv_fldval[2])) : '')
              ));
              unset($lv_fltarrlqd[$i]); 
            }
            // 1.4 Limpieza: Elimino filtros vacios o que no apliquen 
            else{
              unset($lv_fltarrlqd[$i]);
            }
          }
          // 2- CABECERA. Consulto las liquidaciones
          $lv_prmlqd = array('vewfldflt' => '[~fltrow~]l.docsts'.chr(9).'IN'.chr(9).chr(9).'A'.chr(10).'C'.chr(9).chr(9).
                                            (count($lv_fltarrlqd)>0 ? implode('[~fltrow~]', $lv_fltarrlqd) : ''),
                             'vewmaxrec' => $lo_post['vewmaxrec'],
                             'vewfldord' => $lv_vewfldord
                            );
          $lo_rslqd = $lo_mdllqd->getList($lv_prmlqd, null, null, false);

          if(count($lo_rslqd) == 0){
            ini_set('memory_limit', $lv_lmtmem);
            return $lo_ret;
          }

          // 3- DETALLE. Creo array de IDs y consulto los documentos asociados
          $lo_lqdlst = array();
          $lo_prslst = array();

          foreach ($lo_rslqd as $lv_rowlqd) {
            array_push($lo_lqdlst, $lv_rowlqd['hltprslqdcod']);
            // Guardo IDs de prestadores unicos 
            if(isset($lv_rowlqd['prscod']) && !in_array($lv_rowlqd['prscod'], $lo_prslst)){
              array_push($lo_prslst, $lv_rowlqd['prscod']);
            }
          }
          // Filtro detalle por la lista de IDs de cabecera obtenida
          $lv_prmdoc = array('vewfldflt' => '[~fltrow~]ld.hltprslqdcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lo_lqdlst).chr(9).chr(9).
                                            (count($lv_fltarrdoc)>0 ? '[~fltrow~]'.implode('[~fltrow~]', $lv_fltarrdoc) : ''),
                             'vewfldord' => 'ld.hltprslqdcod ASC'
                            );
          $lo_rsdoc = $lo_mdldoc->getList($lv_prmdoc); 

          // 4- PRESTADORES. Recupero para mapear la clase 
          $lo_prsmap = array();
          if(count($lo_prslst) > 0){
            $lv_prmprs = array('vewfldflt' => '[~fltrow~]p.prscod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lo_prslst).chr(9).chr(9));
            $lo_rsprs = $lo_mdlprs->getList($lv_prmprs);
            foreach($lo_rsprs as $lv_rowprs){
              $lo_prsmap[$lv_rowprs['prscod']] = $lv_rowprs;
            }
          }

          // 5- SALIDA. Indexo la cabecera y cruzo todos los datos
          $lo_lqdmap = array();
          foreach($lo_rslqd as $lv_rowlqd) {
            $lo_lqdmap[$lv_rowlqd['hltprslqdcod']] = $lv_rowlqd;
          }

          foreach ($lo_rsdoc as $lv_rowdoc) {
            if(!isset($lo_lqdmap[$lv_rowdoc['hltprslqdcod']])){ continue; }

            $lv_rowlqd = $lo_lqdmap[$lv_rowdoc['hltprslqdcod']];
            $lv_rowprs = (isset($lo_prsmap[$lv_rowlqd['prscod']]) ? $lo_prsmap[$lv_rowlqd['prscod']] : array());

            $lv_rowdoc['hltprslqddoctot'] = number_format((float)$lv_rowdoc['hltprslqddoctot'], 2, ',', '.');

            // Fechas de periodo
            $lv_period = '';
            if(isset($lv_rowlqd['hltprslqdatr001']) && $lv_rowlqd['hltprslqdatr001'] != '') {
              $lv_strdte = $this->co_reg->document->getTagValue($lv_rowlqd['hltprslqdatr001'], 'strdte');
              $lv_enddte = $this->co_reg->document->getTagValue($lv_rowlqd['hltprslqdatr001'], 'enddte');
              if($lv_strdte != '' && $lv_enddte != '') {
                $lv_period = $lv_strdte . ' - ' . $lv_enddte;
              }
            }

            $lv_buf = array(
              'hltprslqdtxt' => (isset($lv_rowlqd['hltprslqdtxt']) ? $lv_rowlqd['hltprslqdtxt'] : ''),
              'prscod'       => (isset($lv_rowlqd['prscod']) ? $lv_rowlqd['prscod'] : ''),
              'prstxt'       => (isset($lv_rowlqd['prstxt']) ? $lv_rowlqd['prstxt'] : ''),
              'sysdocclstxt' => (isset($lv_rowprs['sysdocclstxt']) ? $lv_rowprs['sysdocclstxt'] : ''),
              'lqdperiod'    => $lv_period
            );

            $lv_merged = array_merge($lv_rowdoc, $lv_buf);

            // 5.1 POST-FILTROS. Aplico las busquedas sobre la fila ya armada
            $lv_match = true;
            foreach($lv_fltarrpst as $lv_fpst) {
              $lv_fldname = $lv_fpst['fldname'];
              $lv_fldval  = $lv_fpst['fldval'];

              // Descripcion: Si no hay desc. en cabecera, se busca en detalle
              if($lv_fldname == 'hltprslqdtxt') {
                $lv_curval = strtolower($lv_merged['hltprslqdtxt'] != '' ? $lv_merged['hltprslqdtxt'] : (isset($lv_merged['hltprslqddoctxt']) ? $lv_merged['hltprslqddoctxt'] : ''));
              } else {
                $lv_curval = strtolower(isset($lv_merged[$lv_fldname]) ? $lv_merged[$lv_fldname] : '');
              }

              // Si falla al menos una condicion, se descarta todo el registro
              if($lv_fldval != '' && strpos($lv_curval, $lv_fldval) === false) {
                $lv_match = false;
                break;
              }
            }
            if($lv_match) {
              array_push($lo_ret, $lv_merged);
            }
          }

          ini_set('memory_limit', $lv_lmtmem);
          return $lo_ret;
    break;
        
	case '#crmcntchgntf':

		$lo_crmcntmdl = $this->co_reg->load->model('crmcnt');
		$lo_crmcntmdl->setData($lp_prm['data']);
		$lp_prm['chkntf'] = $lo_crmcntmdl->checkNotification($lp_prm['mdlprv'], $lo_crmcntmdl);

		if (!empty($lp_prm['chkntf']['usrntf'])) {

			// Combino la comparacion real con los flags que devuelve checkNotification.
			$lv_chgstsflg = (
				(($lp_prm['data']['crmcntstscod'] ?? '') != $lp_prm['mdlprv']->crmcntstscod) ||
				isset($lp_prm['chkntf']['mtvntf']['chgsts'])
			);

			$lv_chgresflg = (
				(($lp_prm['data']['usrcod'] ?? '') != $lp_prm['mdlprv']->usrcod) ||
				isset($lp_prm['chkntf']['mtvntf']['newres'])
			);

			$lv_chgcmtflg = (($lp_prm['data']['crmcntcmt'] ?? '') != $lp_prm['mdlprv']->crmcntcmt);

			$lv_html = function ($lv_value) {
				return htmlspecialchars((string)$lv_value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
			};

			$lv_loadtxt = function ($lv_cod) {
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
				return $lo_txtmdl->load(array('txtcodext' => $lv_cod, 'txtsys' => 1), false)
					? $lo_txtmdl->txttxt
					: false;
			};

			$lv_from = array(array(
				'address' => 'noreply@temasis.com.ar',
				'name' => $this->co_reg->sec->bustxt
			));

			$lv_contact_title_html = $lv_html($lp_prm['data']['crmcnttxt'] ?? '');
			$lv_business_html = $lv_html($this->co_reg->sec->bustxt);
			$lv_ticket_html = $lv_html($lp_prm['data']['crmcntcod'] ?? '');
			$lv_status_html = $lv_html($lp_prm['data']['crmcntststxt'] ?? '');
			$lv_responsible_html = $lv_html(strtoupper($lp_prm['data']['usrcod'] ?? ''));

			$lv_status_text = trim((string)($lp_prm['data']['crmcntststxt'] ?? ''));
			$lv_status_class_data = (string)($lp_prm['data']['crmcntstscls'] ?? '');
			$lv_status_class_model = isset($lo_crmcntmdl->crmcntstscls)
				? (string)$lo_crmcntmdl->crmcntstscls
				: '';

			// La finalizacion se detecta por cualquiera de las fuentes disponibles.
			// El texto FINALIZ funciona como fallback para estados como "8 - FINALIZADO".
			$lv_isfinal = $lv_chgstsflg && (
				$lv_status_class_data === '1' ||
				$lv_status_class_model === '1' ||
				isset($lp_prm['chkntf']['mtvntf']['stscls']) ||
				stripos($lv_status_text, 'FINALIZ') !== false
			);

			// Normalizacion de comentarios manteniendo UTF-8.
			$lv_comment_raw = html_entity_decode(
				(string)($lp_prm['data']['crmcntcmt'] ?? ''),
				ENT_QUOTES | ENT_HTML5,
				'UTF-8'
			);

			$lv_comment_raw = preg_replace(
				array(
					'/<br\s*\/?>/i',
					'/<\/p\s*>/i',
					'/<p\b[^>]*>/i',
					'/<\/div\s*>/i',
					'/<div\b[^>]*>/i'
				),
				array(
					"\n",
					"\n",
					'',
					"\n",
					''
				),
				$lv_comment_raw
			);

			$lv_comment_html = nl2br(
				htmlspecialchars(
					trim(strip_tags($lv_comment_raw)),
					ENT_QUOTES | ENT_SUBSTITUTE,
					'UTF-8'
				)
			);

			$lv_detailrow = function ($lv_label, $lv_value, $lv_changed = false, $lv_last = false) {

				$lv_padding = $lv_last ? '0' : '0 0 21px 0';

				return
					'<tr>'.
						'<td class="detail-label" style="padding:0 0 6px 0; font-family:Arial,Helvetica,sans-serif; font-size:11px; line-height:16px; font-weight:bold; letter-spacing:1px; color:#7A869A;">'.
							$lv_label.
						'</td>'.
					'</tr>'.
					'<tr>'.
						'<td class="detail-value" style="padding:'.$lv_padding.'; font-family:Arial,Helvetica,sans-serif; font-size:16px; line-height:25px; color:#172B4D; word-break:normal; overflow-wrap:break-word;">'.
							($lv_changed ? '<strong>' : '').
							$lv_value.
							($lv_changed ? '</strong>' : '').
						'</td>'.
					'</tr>';
			};

			$lv_datatbl =
				'<table role="presentation" width="100%" border="0" cellspacing="0" cellpadding="0" style="width:100%; border-collapse:collapse;">'.
					$lv_detailrow('ESTADO', $lv_status_html, $lv_chgstsflg).
					$lv_detailrow('COMENTARIOS', $lv_comment_html, $lv_chgcmtflg, true).
				'</table>';

			$lv_datatbl2 =
				'<table role="presentation" width="100%" border="0" cellspacing="0" cellpadding="0" style="width:100%; border-collapse:collapse;">'.
					$lv_detailrow('ESTADO', $lv_status_html, $lv_chgstsflg).
					$lv_detailrow('RESPONSABLE', $lv_responsible_html, $lv_chgresflg).
					$lv_detailrow('COMENTARIOS', $lv_comment_html, $lv_chgcmtflg, true).
				'</table>';

			$lv_mentionbox =
				'<table role="presentation" width="100%" border="0" cellspacing="0" cellpadding="0" class="mention-box" style="width:100%; margin:0 0 27px 0; background-color:#EAF6FB; border:1px solid #CBE8F3; border-radius:12px;">'.
					'<tr>'.
						'<td style="padding:18px 20px;">'.
							'<div class="mention-title" style="margin:0 0 5px 0; font-size:15px; line-height:22px; font-weight:bold; color:#126B9A;">'.
								'Te mencionaron en este contacto'.
							'</div>'.
							'<div class="mention-text" style="font-size:14px; line-height:22px; color:#44546A;">'.
								'Revis&aacute; el comentario registrado a continuaci&oacute;n.'.
							'</div>'.
						'</td>'.
					'</tr>'.
				'</table>';

			$lv_rating_button = function ($lv_ticket) {

				return
					'<td class="button_td" align="center" style="height:46px; background-color:#267A5B; border-radius:8px; text-align:center;">'.
						'<a class="button_link" href="https://teammedicalgroup.com.ar/IT/index.php?ticket_id='.rawurlencode((string)$lv_ticket).'" style="display:block; padding:0 24px; font-size:15px; line-height:46px; font-weight:bold; color:#FFFFFF; text-decoration:none;">'.
							'Calific&aacute; la atenci&oacute;n'.
						'</a>'.
					'</td>';
			};


			// NUEVO TICKET
			if (isset($lp_prm['chkntf']['mtvntf']['newcnt'])) {

				$lv_mailto = array();

				foreach ($lp_prm['chkntf']['usrntf'] as $lv_row) {
					if ($lv_row['ntftyp'] == 'usrreq') {
						$lv_mailto[] = array('address' => $lv_row['adreml']);
					}
				}

				if (!empty($lv_mailto)) {

					$lv_usrmsg = $lv_loadtxt('CRMCNTNTFNEW');

					if ($lv_usrmsg === false) {
						return $this->co_reg->document->getJson(array(
							'errtyp' => 'E',
							'errcod' => 1003,
							'errtxt' => ' No se pudo cargar el texto [CRMCNTNTFNEW]. '
						));
					}

					$lv_source = (($lp_prm['data']['crmcntsrccntcod'] ?? '') == '')
						? ($lp_prm['data']['crmcntsrctxt'] ?? '')
						: ($lp_prm['data']['crmcntsrccnttxt'] ?? '');

					$lv_usrmsg = strtr($lv_usrmsg, array(
						'[%1]' => $lv_contact_title_html,
						'[%2]' => $lv_html($lv_source),
						'[%3]' => $lv_ticket_html,
						'[%4]' => $lv_business_html,
						'[%9]' => ''
					));

					$lv_emlprm = array(
						'to' => $lv_mailto,
						'from' => $lv_from,
						'subject' => 'Ticket creado #'.$lp_prm['data']['crmcntcod'].' - '.$lp_prm['data']['crmcnttxt'],
						'bodyhtml' => $lv_usrmsg
					);

					$lo_ntf_arr[] = array('ntftyp' => 'ntfstsnew');

					$lo_eml = new tmssMail();

					if (!$lo_eml->send($lv_emlprm)) {
						return $this->co_reg->document->getJson(array(
							'errtyp' => 'E',
							'errcod' => -1,
							'errtxt' => $lo_eml->getError()
						));
					}
				}
			}


			// CAMBIO DE ESTADO / RESPONSABLE
			if (
				$lv_chgstsflg ||
				isset($lp_prm['chkntf']['mtvntf']['newres'])
			) {

				$lv_mailto = array();
				$lv_mailcco = array();
				$lv_mailasg = array();
				$lv_reqflg = false;

				foreach ($lp_prm['chkntf']['usrntf'] as $lv_row) {

					if (
						$lv_row['ntftyp'] == 'usrreq' &&
						$lv_chgstsflg
					) {
						$lv_reqflg = true;
						$lv_mailto[] = array('address' => $lv_row['adreml']);

					} elseif ($lv_row['ntftyp'] == 'usrasg') {

						$lv_mailasg[] = array('address' => $lv_row['adreml']);

					} elseif ($lv_row['ntftyp'] == 'usrntf') {

						$lv_mailcco[] = array('address' => $lv_row['adreml']);
					}
				}

				$lv_msg = $lv_loadtxt('CRMCNTNTFUPD');

				if ($lv_msg === false) {
					return $this->co_reg->document->getJson(array(
						'errtyp' => 'E',
						'errcod' => 1003,
						'errtxt' => ' No se pudo cargar el texto [CRMCNTNTFUPD]. '
					));
				}

				$lv_notification_type = $lv_isfinal
					? 'CONTACTO FINALIZADO'
					: 'CONTACTO ACTUALIZADO';

				$lv_action_text = $lv_isfinal
					? 'finaliz&oacute;'
					: 'actualiz&oacute;';


				// SOLICITANTE
				if ($lv_reqflg) {

					if ($lv_isfinal) {

						// Si finaliza, el solicitante SIEMPRE recibe CRMCNTNTFASG.
						$lv_usrmsg = $lv_loadtxt('CRMCNTNTFASG');

						if ($lv_usrmsg === false) {
							return $this->co_reg->document->getJson(array(
								'errtyp' => 'E',
								'errcod' => 1003,
								'errtxt' => ' No se pudo cargar el texto [CRMCNTNTFASG]. '
							));
						}

						// Si llegamos aca el ticket ya fue identificado como finalizado.
						// No vuelvo a depender de crmcntstscls para mostrar la encuesta.
						$lv_button = $lv_rating_button($lp_prm['data']['crmcntcod']);

						$lv_usrmsg = strtr($lv_usrmsg, array(
							'[%1]' => $lv_contact_title_html,
							'[%2]' => '',
							'[%3]' => $lv_ticket_html,
							'[%4]' => '',
							'[%5]' => $lv_business_html,
							'[%6]' => '',
							'[%7]' => '',
							'[%8]' => '',
							'[%9]' => $lv_button
						));

						$lv_subject =
							'Ticket finalizado #'.
							$lp_prm['data']['crmcntcod'].
							' - '.
							$lp_prm['data']['crmcnttxt'];

					} else {

						$lv_source = (($lp_prm['data']['crmcntsrccntcod'] ?? '') == '')
							? ($lp_prm['data']['crmcntsrctxt'] ?? '')
							: ($lp_prm['data']['crmcntsrccnttxt'] ?? '');

						$lv_usrmsg = strtr($lv_msg, array(
							'[%1]' => $lv_contact_title_html,
							'[%2]' => $lv_html($lv_source),
							'[%3]' => 'actualiz&oacute;',
							'[%4]' => $lv_ticket_html,
							'[%5]' => $lv_datatbl,
							'[%6]' => $lv_business_html,
							'[%7]' => 'CONTACTO ACTUALIZADO',
							'[%8]' => '',
							'[%9]' => ''
						));

						$lv_subject =
							'Contacto actualizado #'.
							$lp_prm['data']['crmcntcod'].
							' - '.
							$lp_prm['data']['crmcnttxt'];
					}

					$lv_emlprm = array(
						'to' => $lv_mailto,
						'from' => $lv_from,
						'subject' => $lv_subject,
						'bodyhtml' => $lv_usrmsg
					);

					$lo_ntf_arr[] = array('ntftyp' => 'ntfstsnew');

					$lo_eml = new tmssMail();

					if (!$lo_eml->send($lv_emlprm)) {
						return $this->co_reg->document->getJson(array(
							'errtyp' => 'E',
							'errcod' => -1,
							'errtxt' => $lo_eml->getError()
						));
					}
				}


				// RESPONSABLE + USUARIOS NOTIFICADOS
				$lv_usrmsg2 = strtr($lv_msg, array(
					'[%1]' => $lv_contact_title_html,
					'[%2]' => $lv_html($lp_prm['data']['usrcod'] ?? ''),
					'[%3]' => $lv_action_text,
					'[%4]' => $lv_ticket_html,
					'[%5]' => $lv_datatbl2,
					'[%6]' => $lv_business_html,
					'[%7]' => $lv_notification_type,
					'[%8]' => '',
					'[%9]' => ''
				));

				$lv_emlprm2 = array(
					'to' => empty($lv_mailasg)
						? array(array(
							'address' => 'noreply@temasis.com.ar',
							'name' => $this->co_reg->sec->bustxt
						))
						: $lv_mailasg,

					'bcc' => $lv_mailcco,
					'from' => $lv_from,

					'subject' =>
						'Contacto '.
						($lv_isfinal ? 'finalizado' : 'actualizado').
						' #'.
						$lp_prm['data']['crmcntcod'].
						' - '.
						$lp_prm['data']['crmcnttxt'],

					'bodyhtml' => $lv_usrmsg2
				);

				$lo_ntf_arr[] = array('ntftyp' => 'ntfstsnew');

				$lo_eml2 = new tmssMail();

				if (!$lo_eml2->send($lv_emlprm2)) {
					return $this->co_reg->document->getJson(array(
						'errtyp' => 'E',
						'errcod' => -1,
						'errtxt' => $lo_eml2->getError()
					));
				}
			}


			// USUARIOS MENCIONADOS
			if (isset($lp_prm['chkntf']['mtvntf']['newmen'])) {

				$lv_mailmen = array();
				$lv_mailcco = array();

				foreach ($lp_prm['chkntf']['usrntf'] as $lv_row) {
					if ($lv_row['ntftyp'] == 'usrmen') {
						$lv_mailmen[] = $lv_row['adreml'];
					}
				}

				foreach ($lv_mailmen as $lv_mail) {

					$lv_escape = false;

					foreach ($lp_prm['chkntf']['usrntf'] as $lv_row) {

						if ($lv_mail != $lv_row['adreml']) {
							continue;
						}

						if (
							$lv_row['ntftyp'] == 'usrreq' &&
							$lv_chgstsflg
						) {
							$lv_escape = true;

						} elseif (
							(
								$lv_row['ntftyp'] == 'usrasg' ||
								$lv_row['ntftyp'] == 'usrntf'
							)
							&&
							(
								$lv_chgstsflg ||
								isset($lp_prm['chkntf']['mtvntf']['newres'])
							)
						) {
							$lv_escape = true;
						}
					}

					if (!$lv_escape) {
						$lv_mailcco[] = array('address' => $lv_mail);
					}
				}

				if (!empty($lv_mailcco)) {

					$lv_msg_men = $lv_loadtxt('CRMCNTNTFUPD');

					if ($lv_msg_men === false) {
						return $this->co_reg->document->getJson(array(
							'errtyp' => 'E',
							'errcod' => 1003,
							'errtxt' => ' No se pudo cargar el texto [CRMCNTNTFUPD]. '
						));
					}

					$lv_usrmsg3 = strtr($lv_msg_men, array(
						'[%1]' => $lv_contact_title_html,
						'[%2]' => '',
						'[%3]' => 'actualiz&oacute;',
						'[%4]' => $lv_ticket_html,
						'[%5]' => $lv_datatbl,
						'[%6]' => $lv_business_html,
						'[%7]' => 'FUISTE MENCIONADO',
						'[%8]' => $lv_mentionbox,
						'[%9]' => ''
					));

					$lv_emlprm3 = array(
						'to' => array(array(
							'address' => 'noreply@temasis.com.ar',
							'name' => $this->co_reg->sec->bustxt
						)),
						'bcc' => $lv_mailcco,
						'from' => $lv_from,

						'subject' =>
							'Ha sido mencionado en el contacto #'.
							$lp_prm['data']['crmcntcod'].
							' - '.
							$lp_prm['data']['crmcnttxt'],

						'bodyhtml' => $lv_usrmsg3
					);

					$lo_ntf_arr[] = array('ntftyp' => 'ntfstsnew');

					$lo_eml3 = new tmssMail();

					if (!$lo_eml3->send($lv_emlprm3)) {
						return $this->co_reg->document->getJson(array(
							'errtyp' => 'E',
							'errcod' => -1,
							'errtxt' => $lo_eml3->getError()
						));
					}
				}
			}
		}
	break;   
      case '#chkduppln':
        $lo_post = $this->co_reg->request->post;
        $sysdocclscod = $lo_post['sysdocclscod'] ?? '';
        $prm_dup = isset($lp_prm['dupblk']) ? $lp_prm['dupblk'] : null;
        $lv_dupdte = false;
        $lv_duptme = false;
        
        $lv_tmpdte = DateTime::createFromFormat('d/m/Y', $lo_post['plndte']);
				$lv_plndtefmt = $lv_tmpdte->format('Y-m-d');

        $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
        $lv_prm = array('vewmaxrec' =>'100',
                  'vewfldflt'=>'[~fltrow~]pl.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                     '[~fltrow~]pl.spccod'.chr(9).'='.chr(9).chr(9).$lo_post['spccod'].chr(9).chr(9).
                                     '[~fltrow~]pl.prscod'.chr(9).'='.chr(9).chr(9).$lo_post['prscod'].chr(9).chr(9).
                                     '[~fltrow~]pl.patcod'.chr(9).'='.chr(9).chr(9).$lo_post['patcod'].chr(9).chr(9).
                                     '[~fltrow~]pld.plndte'.chr(9).'='.chr(9).chr(9).$lv_plndtefmt.chr(9).chr(9)
                       );
        $lo_objrs = $lo_plndtemdl->getList($lv_prm, null, null, false);
        $new_prstxt 	 = ($lo_post['prstxt']     ?? '');
        $new_pattxt 	 = ($lo_post['pattxt']     ?? '');
        $new_plndte    = ($lo_post['plndte']     ?? '');
        $new_plninbdte = ($lo_post['plninbdte']  ?? ''); 
        $new_plnoutdte = ($lo_post['plnoutdte']  ?? ''); 
        
        foreach ($lo_objrs as $row) {
          // Mismo día/rango de días
          if($new_plninbdte != $new_plnoutdte){
            $lv_plninbdte = ($row['plninbdte'] ?? '');
            $lv_plninbdte = $lv_plninbdte instanceof DateTime ? $lv_plninbdte->format('H:i') : (!empty($lv_plninbdte) ? (new DateTime($lv_plninbdte))->format('H:i') : '');

            $lv_plnoutdte = ($row['plnoutdte'] ?? '');
            $lv_plnoutdte = $lv_plnoutdte instanceof DateTime ? $lv_plnoutdte->format('H:i') : (!empty($lv_plnoutdte) ? (new DateTime($lv_plnoutdte))->format('H:i') : '');
            
            if($lv_plnoutdte == $lv_plninbdte){ $lv_dupdte = true; break; }

            $lv_in  = ($lv_plninbdte !== '') ? ((int)substr($lv_plninbdte,0,2) * 60 + (int)substr($lv_plninbdte,3,2)) : null;
            $lv_out = ($lv_plnoutdte !== '') ? ((int)substr($lv_plnoutdte,0,2) * 60 + (int)substr($lv_plnoutdte,3,2)) : null;
            $n_in  = ($new_plninbdte !== '') ? ((int)substr($new_plninbdte,0,2) * 60 + (int)substr($new_plninbdte,3,2)) : null;
            $n_out = ($new_plnoutdte !== '') ? ((int)substr($new_plnoutdte,0,2) * 60 + (int)substr($new_plnoutdte,3,2)) : null;
            $lv_duptme = ($lv_in !== null && $lv_out !== null && $n_in !== null && $n_out !== null) && ($lv_in < $n_out) && ($n_in < $lv_out); 
          }else{
            $lv_dupdte = true;
            break;
          }
        }

        if (($lv_dupdte === true || $lv_duptme === true) && $lo_post['plnid']=='') {
          // Existe una planificación vigente
          if ($prm_dup === 'x') {
            // Bloquea siempre si prm_dup = 'x'
            if ($lv_dupdte === true) {
                return array('errtyp' => 'E','errcod' => -1,'errtxt' => 'Ya existe una planificación para ' . $new_prstxt . ', ' . $new_pattxt . ' y la fecha ' . $new_plndte . '.');
            } else {
                return array('errtyp' => 'E','errcod' => -1,'errtxt' => 'Ya existe una planificación en el horario ' . $new_plninbdte . '–' . $new_plnoutdte . ' para ' . $new_prstxt . ', ' . $new_pattxt . ' y la fecha ' . $new_plndte . '.');
            }
          } else {
            // Si no es 'x', devuelve advertencia con erralt
            if ($lv_dupdte === true) {
              return array('errtyp' => 'S','errcod' => 0, 'erralt' => 'Existe una planificación con la misma fecha');
            } else { // $lv_overlap === true
              return array('errtyp' => 'S','errcod' => 0, 'erralt' => 'Existe una planificación con horario superpuesta');
            }
          }
      	} else {
          // no hay duplicidad
          return array('errtyp' => 'S','errcod' => 0,'errtxt' => '');
      	}
        
      break;

			
			// -----------------------------------------------------------------------
			//
			//  I M P R E S I O N E S
			//
			// -----------------------------------------------------------------------
			
			
			
      // COMODATO
			case '#stkmovdocpnt':
				$lo_stkdocmdl = $this->co_reg->load->model('stkmovdoc');
				$lo_datcntmdl = $this->co_reg->load->model('grldatcnt');
				$lv_stkmovdoccod = (isset($this->co_reg->request->post['stkmovdoccod'])?$this->co_reg->request->post['stomovdoccod']:$lp_prm['stkmovdoccod']);
				$lo_stkdocmdl->load( array('stkmovdoccod'=>$lv_stkmovdoccod), false );
				$lo_datcntmdl->load( array('cntcod'=>$lo_stkdocmdl->dstcntcod), false );
        //var_dump($lo_stkdocmdl);
        //if ($lo_stkdocmdl->dstobjtxt == "TERAPIAS ODDS (TEAM INFUSION CHILE)") {
    		//	$lo_stkdocmdl->sysdocclstxt = "CONSUMO CHILE";
				//} 

				$lo_stkdocmdl->dstcnt=$lo_datcntmdl;				
				if ( $lo_stkdocmdl->docsts!='C' ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Debe contabilizar el documento para imprimir el Remito.'));
				}
				$lv_vewcod = isset($lp_prm['vewcus'])?$lp_prm['vewcus']:'zcutp1_tmg_rempntsis';
				$lv_buffer = 	$this->co_reg->load->view($lv_vewcod , array('data'=>$lo_stkdocmdl,'actcod'=>$this->data['actcod']) );
				$this->co_reg->response->addHeader('Content-type:application/pdf'); 
				return $lv_buffer;
				break;
      
			
			// DEVOLUCION COMODATO
			case '#stkmovdevpnt':
				$lo_stkdocmdl = $this->co_reg->load->model('stkmovdoc');
				$lo_datcntmdl = $this->co_reg->load->model('grldatcnt');
				$lv_stkmovdoccod = (isset($this->co_reg->request->post['stkmovdoccod'])?$this->co_reg->request->post['stomovdoccod']:$lp_prm['stkmovdoccod']);
				$lo_stkdocmdl->load( array('stkmovdoccod'=>$lv_stkmovdoccod), false );
				$lo_datcntmdl->load( array('cntcod'=>$lo_stkdocmdl->dstcntcod), false );
				$lo_stkdocmdl->dstcnt=$lo_datcntmdl;
				if ( $lo_stkdocmdl->docsts!='C' ) {
					return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>-1,'errtxt'=>'Debe contabilizar el documento para imprimir el Remito.'));
				}
				$lv_vewcod = isset($lp_prm['vewcus'])?$lp_prm['vewcus']:'zcutp1_tmg_devpntsis';
				$lv_buffer = 	$this->co_reg->load->view($lv_vewcod , array('data'=>$lo_stkdocmdl,'actcod'=>$this->data['actcod']) );
				$this->co_reg->response->addHeader('Content-type:application/pdf'); 
				return $lv_buffer;
				break;    


			
			// -----------------------------------------------------------------------
			//
			//  G E S T I O N   D E   P E R M I S O S
			//
			// -----------------------------------------------------------------------
			
      case '#crmacsmgm':
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' => $this->co_reg->sec,
												'data' => $this->lo_mdl,
												'actcod' => (isset($lp_prm['actcod'])?$lp_prm['actcod']:$this->data['actcod']),
												'model' => self::MODEL
												);
				$lv_buffer = 	$this->co_reg->load->view('zcutp1_tmg_crmacsmgm', $lv_prm);
				return $lv_buffer;
        break;
      /*  T I K E T E R A  */
      case '#tkt':
        $lo_cntmdl = $this->co_reg->load->model('crmcnt');
        
        $lo_ret=[];
        $lo_ret[]=array(
          						'crmcntcod'=>'1001',
          						'crmcnttxt'=>'MONITOREO TELEFONICO TAKZYRO/VOSZO PARA CHILE',
          						'crmcntmtvtxt'=>'ASIGNACION DE ACCESOS (SOFTWARE)',
          						'crmcnttyptxt'=>'Temasis',
          						'crmcntprt'=>'Alta',
          						'crmcntdte'=>'01-01-2023',
          						'crmcntststxt'=>'1 - PLANIFICADO',
          						'crmcntclr'=>'style="background-color: red;"'
        							 );
        $lo_ret[]=array(
          						'crmcntcod'=>'1002',
          						'crmcnttxt'=>'Ticket 2',
          						'crmcntmtvtxt'=>'Incidencia',
          						'crmcnttyptxt'=>'ISIS',
          						'crmcntprt'=>'Media',
          						'crmcntdte'=>'02-01-2023',
          						'crmcntststxt'=>'2 - EN PROCESO',
          						'crmcntclr'=>'style="background-color: orange;"'
        							 );
        $lo_ret[]=array(
          						'crmcntcod'=>'1003',
          						'crmcnttxt'=>'Ticket 3',
          						'crmcntmtvtxt'=>'Pedido',
          						'crmcnttyptxt'=>'Administracion IT',
          						'crmcntprt'=>'Baja',
          						'crmcntdte'=>'03-01-2023',
          						'crmcntststxt'=>'3 - EN PROVEEDOR',
          						'crmcntclr'=>'style="background-color: green;"'
        							 );
        $lo_ret[]=array(
          						'crmcntcod'=>'1004',
          						'crmcnttxt'=>'Ticket 4',
          						'crmcntmtvtxt'=>'Proyecto',
          						'crmcnttyptxt'=>'Temasis',
          						'crmcntprt'=>'Media',
          						'crmcntdte'=>'04-01-2023',
          						'crmcntststxt'=>'5 - PENDIENTE DE USUARIO',
          						'crmcntclr'=>'style="background-color: yellow;"'
        							 );
        $lo_ret[]=array(
          						'crmcntcod'=>'1010',
          						'crmcnttxt'=>'Ticket 5',
          						'crmcntmtvtxt'=>'Pedido',
          						'crmcnttyptxt'=>'ISIS',
          						'crmcntprt'=>'Alta',
          						'crmcntdte'=>'05-01-2023',
          						'crmcntststxt'=>'8 - FINALIZADO',
          						'crmcntclr'=>'style="background-color: blue;"'
        							 );
        $lo_ret[]=array(
          						'crmcntcod'=>'ssss',
          						'crmcnttxt'=>'Ticket 5',
          						'crmcntmtvtxt'=>'Pedido',
          						'crmcnttyptxt'=>'ISIS',
          						'crmcntprt'=>'Alta',
          						'crmcntdte'=>'05-01-2023',
          						'crmcntststxt'=>'8 - FINALIZADO',
          						'crmcntclr'=>'style="background-color: blue;"'
        							 );
        $lo_ret[]=array(
          						'crmcntcod'=>'101eeee0',
          						'crmcnttxt'=>'Ticket 5',
          						'crmcntmtvtxt'=>'Pedido',
          						'crmcnttyptxt'=>'ISIS',
          						'crmcntprt'=>'Alta',
          						'crmcntdte'=>'05-01-2023',
          						'crmcntststxt'=>'8 - FINALIZADO',
          						'crmcntclr'=>'style="background-color: blue;"'
        							 );
        $lo_cntmdl->crmcntlst=$lo_ret;
        
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' => $this->co_reg->sec,
												//'data' => $this->lo_mdl,
                        'data' => $lo_cntmdl,
												'actcod' => (isset($lp_prm['actcod'])?$lp_prm['actcod']:$this->data['actcod']),
												'model' => self::MODEL
												);
				$lv_buffer = 	$this->co_reg->load->view('zcutp1_tmgtktlst', $lv_prm);
				return $lv_buffer;
        break;
      /*  T I K E T E R A  V E R  */
      case '#tkt03': case'#tkt02':
        $lo_cntmdl = $this->co_reg->load->model('crmcnt');
        
        $lo_cntmdl->crmcnttxt='Ticket 5';
        $lo_cntmdl->crmcntmtvcod='0';
        $lo_cntmdl->crmcntmtvtxt='Pedido';
        $lo_cntmdl->crmcnttyptxt='ISIS';
        $lo_cntmdl->crmcntprtcod='0';
        $lo_cntmdl->crmcntprt='Alta';
        $lo_cntmdl->crmcntdte='05-01-2023';
        $lo_cntmdl->crmcntrqs='implementar una mejora en el proceso de preparación de pedidos para poder evitar que se generen pedidos con insumos a valor 0 por error humano / del sistema';
        $lo_cntmdl->crmcntsrccncod='';
        $lo_cntmdl->crmcntsrccnttxt='';
        $lo_cntmdl->usrcod='GRUSSO';

        $lo_crmtyplst =array( '25' => 'ADMINISTRACION IT',
                              '23' => 'APERTURA SOFTWARE',
                              '26' => 'BACKOFFICE',
                              '24' => 'GENESYS',
                              '21' => 'GOMEDISYS',
                              '22' => 'ISIS',
                              '34' => 'TALIGENT',
                              '20' => 'TEMASIS');
        $lo_crmcntmtvlst = array(	'74' => 'PEDIDO',
                                  '75' => 'MEJORA - CAMBIO (RFC)',
                                  '76' => 'INCIDENCIA',
                                  '92' => 'REUNION - CAPACITACION',
                                  '98' => 'DESARROLLO INTERNO',
                                  '115' => 'CONSULTA',
                                  '134' => 'SOPORTE EXTENDIDO',
                                  '205' => 'PROYECTO');
        $lo_crmcntprtlst =array('10' => 'ALTA',
                                '11' => 'BAJA',
                                '12' => 'MEDIA');
        
        $lo_crmcntstslst=array(	'19' => '0 - BACKLOG',
                                '11' => '1 - PLANIFICADO',
                                '12' => '2 - EN PROCESO',
                                '13' => '3 - EN PROVEEDOR',
                                '14' => '4 - PRUEBAS QA',
                                '15' => '5 - PENDIENTE DE USUARIO',
                                '18' => '6 - EN DEFINICIONES',
                                '17' => '7 - CANCELADO',
                                '16' => '8 - FINALIZADO'
                            );
        $lv_crmcntcod = (isset($this->co_reg->request->post['cntcod'])?$this->co_reg->request->post['crmcntcod']:$lp_prm['crmcntcod']);
        $lo_cntmdl->crmtyplst=$lo_crmtyplst;
        $lo_cntmdl->crmcntmtvlst=$lo_crmcntmtvlst;
        $lo_cntmdl->crmcntprtlst=$lo_crmcntprtlst;
        $lo_cntmdl->crmcntcod=$lv_crmcntcod;
        $lo_cntmdl->sysdoccls=array('sysdocclscod'=>'0');
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' => $this->co_reg->sec,
                        'data' =>$lo_cntmdl,
												'actcod' =>'01',
												'model' => self::MODEL
												);
				$lv_buffer = 	$this->co_reg->load->view('zcutp1_tmgtktdet', $lv_prm);
				return $lv_buffer;
        break;
      /*  T I K E T E R A  V E R  */
      case '#tkt03':
        $lo_cntmdl = $this->co_reg->load->model('crmcnt');
        $lo_cntmdl->crmcntcod=$lv_crmcntcod;
        $lo_cntmdl->sysdoccls=array('sysdocclscod'=>'0');
				$lv_prm = array('lang'  => $this->co_reg->language,
												'input' => $this->co_reg->input,
												'sec' => $this->co_reg->sec,
                        'data' =>$lo_cntmdl,
												'actcod' => '02',
												'model' => self::MODEL
												);
				$lv_buffer = 	$this->co_reg->load->view('zcutp1_tmgtktdet', $lv_prm);
				return $lv_buffer;
        break;
      case '#crmcntntfgrl':
        $lo_clsmdl = $this->co_reg->load->model('sysdoccls');
        // determino destinatarios
        $lv_mailto = array();
        $data=$lp_prm['data'];
             
        if(!$lo_clsmdl->load(array('sysdocclscod'=>$data['sysdocclscod']))){
          return 'error';
          
        }

$lv_atrusr = <<<XML
<?xml version='1.0'?> 
<document>
.htmlentities($lo_clsmdl->sysdocclsatrusr).
</document>
XML;
$lv_dat = simplexml_load_string($lv_atrusr);
        $lv_buffer='';
        $lv_grltxtcod='';
        $lv_emlntflst='';
        $lv_clsprm=[];
        $lv_keymtv='_'.$lp_prm['data']['crmcntmtvcod'];
        foreach($lv_dat as $row_key=>$lv_val){
          $lv_enc=false;
          if ( strpos($row_key ,$lv_keymtv)===false) {
            $lv_enc=false;
          }else{
            $lv_enc=true;
          }         
          if ( $lv_enc) {
            $key =str_replace($lv_keymtv, '', $row_key);
            $lv_clsprm[$key]=$lv_val;
          }
        }
        $lv_emlntflst=$lv_clsprm['emlntflst'];
        $lv_grltxtcod=$lv_clsprm['grltxtcod'];
        
        $lo_txtmdl = $this->co_reg->load->model('grldattxt');
        if ( $lo_txtmdl->load(array('txtcod'=>$lv_grltxtcod)) == false ) {
          $lv_buffer = '-100: NO EXISTE EL MENSAGE CON EL CODIGO ' . $lv_grltxtcod;
          return $lv_buffer;
          break;
        } 
        
        $lv_env = $this->co_reg->config->get('environmet');
        if($lv_env=='dev'){
        	$lv_mailto[] = array('address'=>'grusso@teaminfusion.com');
        }
        $lv_mailtoarr = explode(';',str_replace(',',';',$lv_emlntflst));
				foreach( $lv_mailtoarr as $lv_val) {
					$lv_mailto[] = array('address'=>$lv_val);
				}
        $data['buscod']=$this->co_reg->sec->buscod; 
        $data['bustxt']=$this->co_reg->sec->bustxt; 
        
        $lv_usrmsgout=$lo_txtmdl->txttxt;
        // envío mail
        if ( count($lv_mailto)>0 ) {
          $lo_eml = new tmssMail();
          $lv_emlprm['to'] = $lv_mailto;
          $lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt) );
          $lv_emlprm['subject'] = isset($lv_clsprm['subject'])?$lv_clsprm['subject']:'Asunto desconocido';
          
          foreach($lv_clsprm as $lv_key=>$lv_val){
            $lv_usrmsgout = str_replace( '[%'.$lv_key.']', $lv_val, $lv_usrmsgout );
          }
          foreach($data as $lv_key=>$lv_val){
            if(gettype($lv_val) =='object'){
              if (get_class($lv_val)=='DateTime' || get_class($lv_val)=='Date'){
              	$lv_usrmsgout = str_replace( '[%'.$lv_key.']', $lv_val->format('d/m/Y'), $lv_usrmsgout );
            	}else{
              	$lv_usrmsgout = str_replace( '[%'.$lv_key.']', $lv_val, $lv_usrmsgout );
              }
            }else{
              if(gettype($lv_val) =='string' || gettype($lv_val) =='integer'){
              	$lv_usrmsgout = str_replace( '[%'.$lv_key.']', $lv_val, $lv_usrmsgout );
              }
            }
					}
          $lv_emlprm['bodyhtml'] = $lv_usrmsgout;
          if ( !$lo_eml->send( $lv_emlprm )) {
            $lv_ret['errtyp']='E';
            $lv_ret['errcod']='-1';
            $lv_ret['errtxt']= 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
          }
        }
        return $lv_usrmsgout;
        break;
        
      case '#tinfrmrpt'://PASAR A OTRO CONTROLADOR
        /*
        	Descripcion: Esta actividad se utiliza para la generacion de reportes de los contactos de crm con los formularios de los pasos de los worflows configurados. 
          Filtros desde el front:  La misma puede ser filtrada por los campos de los contacto.
          Filtros desde el origen:
          	cntmtv: Motivos de contacto, filtrara los contactos de CRM por la lista de motivos especificada, si son más de uno deven ir separado por , (Coma)
            wrkflwcodlst: Codigos de workfolws, filtrara los pasos de los workflows por la lista de codigos de workflows especificada, si son más de uno deven ir separado por , (Coma)
            relsts: Estado de los workflkoes, filtrara los pasos de los workflows por la lista de estados  especificada, si son más de uno deven ir separado por , (Coma)
            sysdocfrmcod: Codigos de formularios, filtrara los datos cargados en los formularios por la lista de codigos de formularios especificada, si son más de uno deven ir separado por , (Coma)
        */
        //https://developers.gorse.ar/index.php?prg=zcutp1_tmg&act=tinfrmrpt&prm_cntmtv=142&prm_objmdl=hltpat&prm_objcodidx=p.patco&&prm_objcodtxt=pattxt
        
        //Filtro por estado y motivo de contacto
        //https://developers.gorse.ar/index.php?prg=zcutp1_tmg&act=tinfrmrpt&prm_cntmtv=142&prm_relsts=R,A
        
        //Filtro por Motivo de contacto y workflow
        //https://developers.gorse.ar/index.php?prg=zcutp1_tmg&act=tinfrmrpt&prm_cntmtv=142&wrkflwcodlst=25,42
        
        //Filtro por motivo de contacto y formulario
        //https://developers.gorse.ar/index.php?prg=zcutp1_tmg&act=tinfrmrpt&prm_cntmtv=142&sysdocfrmcod=43,42
        
        
        /*
        Se debe optimizar y reformular los desarrollos para la generacion de reportes dinamicos de los wofklows y formularios.
        Las actividades se encuentran dentro de ZCUPT1_TIN y son:
        tinfrmrpt
        tinfrmsturpt

        En ambas Actividades se debe tener en cuenta y pasar los siguientes datos para filtrar los datos a obtener. Enviando por parametro:
        - Motivos de Contacto
        - Estado de liberacion
        - Registros maximos

        Adicionalmente se debe tener en cuenta que se puede optimizar la obtencion de los datos realizacion Group By,obteniendo tambien los datos de cabeceras directamente desde las consultas de las posiciones
        , entendiendose, se puede obtener la cabecera del workflow directamente en la obtencion de las posiciones. 
        Lo mismo para formularios, se peuden obtener las definiciones de campos directamente al obtener los campos.
        */
        //Contactos->
        
        $lo_post = $this->co_reg->request->post;
        $lv_ret= array();
        $lv_data_sqlstm = array();
        $deb_lst = array();
        $lv_data_rs = array();
        //$lv_lmtmem= ini_get('memory_limit');
        //$lv_memlmt='2048';
        //ini_set('memory_limit', $lv_memlmt.'M');
        
        $lv_crmmtvls = str_replace(',',chr(10),($lp_prm['cntmtv']??''));//crmcntsrctyp
        $lv_wrkflwcodls = str_replace(',',chr(10),($lp_prm['wrkflwcodlst']??''));//crmcntsrctyp
        $lv_sysdocfrmcodls = str_replace(',',chr(10),($lp_prm['sysdocfrmcod']??''));//crmcntsrctyp
        $lv_relstsls = str_replace(',',chr(10),($lp_prm['relsts']??''));//crmcntsrctyp
        $lv_rshwemtfrm = $lp_prm['shwemtfrm']??'';//Visualiza los contactos tienen formularios vesios
        
        
        //Ver
        /*
        $lv_objmdl= $lp_prm['objmdl']??'';
        if($lv_objmdl!=''){
          $lv_objstsidx= $lp_prm['objstsidx']??'p.patcod';
          $lv_objcodtxt= $lp_prm['objcodtxt']??'p.pattxt';
          $lo_objmdl = $this->co_reg->load->model($lv_objmdl);
          $lv_prm = array('vewfldflt'=>'[~fltrow~]'.$lv_objstsidx.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
          $lo_objrs = $lo_objmdl->getList( $lv_prm, null, null, false );
          $lv_data_sqlstm[]=$lo_objmdl->getSysData('sqlstm');
        }
        */
        //-Ver
        
        /*
        //BUSCO LOS MOTIVOS (para obtener las clases de documeto de los mismos) 
        $lo_mtvmdl = $this->co_reg->load->model('crmcntmtv');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]m.crmcntmtvcod'.chr(9).'IN'.chr(9).chr(9).$lv_crmmtvls.chr(9).chr(9),
													 'vewfldord' =>'m.crmcntmtvcod desc'
													);
        $lo_crmmtv_rs= $lo_mtvmdl->getlist($lv_prmflt,null,null,false);//$lo_crmmtv_rs= $lo_mtvmdl->getlist($lv_prmflt, null, null, false);//seguridad CRM
        $lv_data_sqlstm[]=$lo_mtvmdl->getSysData('sqlstm');       
        */
        
        // CONTACTOS CRM
        $lo_cntmdl = $this->co_reg->load->model('crmcnt');
        
        //Filtros CONTACTOS CRM 
				$lv_fltarrcnt = explode('[~fltrow~]',$lo_post['vewfldflt']??'' );		
				for($i=count($lv_fltarrcnt)-1; $i>0; $i--){
					if(stripos(';crmcnttxt;crmcnttyptxt;crmcntsrccnttxt;crmcntsrctxt;crmcntmtvtxt;crmcntcod;crmcntreqdte;',';'.explode(chr(9),$lv_fltarrcnt[$i])[0].';')===false){
						unset($lv_fltarrcnt[$i]);
					}
				}
        $lv_prmflt = array('vewfldflt' =>(count($lv_fltarrcnt)>0?implode('[~fltrow~]',$lv_fltarrcnt):'').
                           								'[~fltrow~]c.docsts'.chr(9).'IN'.chr(9).chr(9).'A'.chr(9).chr(9),
													 'vewfldord' => 'c.crmcntreqdte desc',
                           'vewmaxrec'=> ($lo_post['vewmaxrec']??'101')-1
													);
        
        // filtro externo de motivos de contactos
        if($lv_crmmtvls !=''){
        	$lv_prmflt['vewfldflt'].='[~fltrow~]c.crmcntmtvcod'.chr(9).'IN'.chr(9).chr(9).$lv_crmmtvls.chr(9).chr(9);
        }
        
        $lo_crmcnt_rs= $lo_cntmdl->getlist($lv_prmflt,null,null,false);
        $lv_data_sqlstm[]=$lo_cntmdl->getSysData('sqlstm');
        $lv_crmcntcodlst= array_column($lo_crmcnt_rs, 'crmcntcod');
        $deb_lst['crmcntcodlst']= $lv_crmcntcodlst;
        
        // WORK FLOW
        //Filtros CONTACTOS CRM 
				$lv_fldattwrk = explode('[~fltrow~]',$lo_post['vewfldflt']??'' );		
				for($i=count($lv_fldattwrk)-1; $i>0; $i--){
					if(stripos(';;',';'.explode(chr(9),$lv_fldattwrk[$i])[0].';')===false){
						unset($lv_fldattwrk[$i]);
					}
				}
        $lo_wrkmdl = $this->co_reg->load->model('grldatwrk');
        $lv_prmflt = array('vewfldflt' =>(count($lv_fldattwrk)>0?implode('[~fltrow~]',$lv_fldattwrk):'').
                           							 '[~fltrow~]dw.srcobjcod001'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lv_crmcntcodlst) .chr(9).chr(9).
                           							 '[~fltrow~]dw.srcobjtyp'.chr(9).'='.chr(9).chr(9). 'CRM_CNT'.chr(9).chr(9),
													 'vewfldord' => 'dw.srcobjcod001'
													);
        
        
        if($lv_wrkflwcodls !=''){
        	$lv_prmflt['vewfldflt'].='[~fltrow~]dw.wrkflwcod'.chr(9).'IN'.chr(9).chr(9).$lv_wrkflwcodls.chr(9).chr(9);
        }
        
        if($lv_relstsls !=''){
        	$lv_prmflt['vewfldflt'].='[~fltrow~]relsts'.chr(9).'IN'.chr(9).chr(9).$lv_relstsls.chr(9).chr(9);
        }
        $lo_wrk_rs= $lo_wrkmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_wrkmdl->getSysData('sqlstm');
        
        $lo_wrklst= array_column($lo_wrk_rs, 'wrkflwdatcod','wrkflwdatcod');
        $deb_lst['wrklst']= $lo_wrklst;
        
        $lo_wrkCntLst= array_column($lo_wrk_rs, 'srcobjcod001','wrkflwdatcod');
        $deb_lst['wrkCntLst']= $lo_wrkCntLst;
        
        
        //DATOS CAMPOS  FROMULARIOS
        $lo_datfldmdl = $this->co_reg->load->model('grldatfrmfld');
        $lv_fltfrmfld = explode('[~fltrow~]',$lo_post['vewfldflt']??'' );		
				for($i=count($lv_fltfrmfld)-1; $i>0; $i--){
					if(stripos(';;',';'.explode(chr(9),$lv_fltfrmfld[$i])[0].';')===false){
						unset($lv_fltfrmfld[$i]);
					}
				}
        
        $lv_prmflt = array('vewfldflt' =>(count($lv_fltfrmfld)>0?implode('[~fltrow~]',$lv_fltfrmfld):'').
                           							  '[~fltrow~]f.srcobjcod001'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_wrklst) .chr(9).chr(9),//'[~fltrow~]f.srcobjcod002'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_wrkstplst) .chr(9).chr(9),//'[~fltrow~]f.frmdatcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_datcodlst) .chr(9).chr(9),
													 'vewfldord' => 'f.frmdatcod'
													);
        
        if($lv_sysdocfrmcodls !=''){
        	$lv_prmflt['vewfldflt'].='[~fltrow~]sf.sysdocfrmcod'.chr(9).'IN'.chr(9).chr(9).$lv_sysdocfrmcodls.chr(9).chr(9);
        }
        $lo_datfld_rs= $lo_datfldmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_datfldmdl->getSysData('sqlstm');
        
        //CREO UNA LISTA DE LOS CODIGOS DE FORMULARIOS 
        $lo_frmlst = array_column($lo_datfld_rs, 'sysdocfrmcod','sysdocfrmcod');
        $deb_lst['frmlst']= $lo_frmlst;
        
        // DEFINICION FROMULARIOS CAMPOS
        $lo_frmfldmdl = $this->co_reg->load->model('sysdocfrmfld');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]sysdocfrmcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_frmlst) .chr(9).chr(9).
                           							 '[~fltrow~]sysfldinptyp'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),array('COMBO','LIST')) .chr(9).chr(9),
													 'vewfldord' => 'sysdocfrmcod'
													);
        $lo_deffld_rs= $lo_frmfldmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_frmfldmdl->getSysData('sqlstm');
        $lo_defFld =[];
        foreach($lo_deffld_rs as $rowDefFld){
          $coldata=$rowDefFld['sysfldinptyp']=='LIST'?8:7;
          $lo_defFld[$rowDefFld['sysdocfrmfldcod']]=[];
          $lo_defFld[$rowDefFld['sysdocfrmfldcod']]['opnlst']=[];
          $lo_defFld[$rowDefFld['sysdocfrmfldcod']]['data']=explode("\n",json_decode($rowDefFld['sysdocfrmfldatr'],true)[$coldata]['sysdocfrmfldatrval']);
          foreach($lo_defFld[$rowDefFld['sysdocfrmfldcod']]['data'] as $rowData){
            $lv_opnAux=explode("|",$rowData);
            $lo_defFld[$rowDefFld['sysdocfrmfldcod']]['opnlst'][$lv_opnAux[0]]=$lv_opnAux[1]??'';
          }
        }
        $deb_lst['defFld']= $lo_defFld;
        
        $ret=[];
        $data= [];
        $keyAnt='';
        foreach($lo_datfld_rs as $rowFrmDat){
          $key = $lo_wrkCntLst[$rowFrmDat['srcobjcod001']];
          if(!array_key_exists($key,$data)){
            $data[$key]=[];
          }
          /*
          if($keyAnt!=$key){
            $keyAnt= $key;
            $data[$keyAnt]=[];
          }
          */
          $datval=[];
          
          if (array_key_exists($rowFrmDat['frmdocfldcod'], $lo_defFld)) {
            //acá va el manej de la seleccion multiple
            $frmdatval= $rowFrmDat['frmdatval'];
            $frmdatvallst = explode('|', $frmdatval);
            $fldcod=$rowFrmDat['frmdocfldcod'];
            $frmdattxtlst=[];
            $txterr='';
            foreach($frmdatvallst  as $row){
              if(isset($lp_prm['debugger'])){
                $txterr=('@'.$fldcod.'@->'.$row);
              }
              $frmdattxtlst[]=$lo_defFld[$fldcod]['opnlst'][$row]?? $txterr;
            }
						//$rowFrmDat['frmdatval']=implode(' | ', $frmdattxtlst);
            $datval=implode(' | ', $frmdattxtlst);
            //$rowFrmDat['frmdatval']= $lo_defFld[$fldcod]['opnlst'][ $frmdatval]?? '@'.$frmdatval.'@';
          }else{
            $datval=$rowFrmDat['frmdatval'];
          }
          $data[$key][$rowFrmDat['frmdatfldcodext']]=$datval;//$rowFrmDat['frmdatval'];
        }
        $deb_lst['data']= $data;
        
        foreach($lo_crmcnt_rs as $rowCrmCnt){
          if (!in_array($rowCrmCnt['crmcntcod'], $lo_wrkCntLst)) {
            continue;
          }
          
          if (array_key_exists($rowCrmCnt['crmcntcod'], $data)) {
            $rowCrmCnt=$rowCrmCnt+$data[$rowCrmCnt['crmcntcod']];
        		$ret[]=$rowCrmCnt;            
          //}else if ($lv_relstsls=='' && $lv_wrkflwcodls ==''){
          }else if ($lv_rshwemtfrm!=''){
            $ret[]=$rowCrmCnt;
          }
        }
        if(isset($lp_prm['debugger'])){
          $ret[0]['z_sqlstm']=$lv_data_sqlstm;
          $ret[0]['z_debug_data']=$deb_lst;
        }
        if(($lp_prm['vewlog']??'')!=''){
        	return $this->co_reg->document->getJson($ret);
        }
        return $ret;
        break;
        
      //   D A S H B O A R D   S P L I T   ( grilla + detalle en una misma vista )
			// La misma operacion sirve para la carga inicial y para las recargas (filtro / boton Actualizar):
			//   - carga inicial (sin 'dshrld'): devuelve la VISTA con el listado ya embebido.
			//   - recarga    ('dshrld'='1'):    la vista ya esta montada, devuelve SOLO el JSON del listado.
			case '#crmslsdsh':
				$lo_post = $this->co_reg->request->post;

				// filtro fijo de origen: la bandeja lista unicamente contactos HLT_PAT + los filtros/orden de la vista
				$lv_srcflt = '[~fltrow~]c.crmcntsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_PAT'.chr(9).chr(9);
				$lv_vewopt = array(
					'vewfldflt' => $lv_srcflt.$this->resolveCrmSlsPatFilter( ($lo_post['vewfldflt']??'')!='' ? html_entity_decode($lo_post['vewfldflt']) : '' ),
					'vewfldord' => ( $lo_post['vewfldord'] ?? '' ),
					'vewmaxrec' => ( $lo_post['vewmaxrec'] ?? '100' )
				);

				// listado de contactos SIN control de autorizacion (authCheck=false -> op 18 del SP)
				$lo_cntmdl = $this->co_reg->load->model('crmcnt');
				$lv_cntrs  = $lo_cntmdl->getList( $lv_vewopt, array(), null, false );
				if ( !is_array($lv_cntrs) ) { $lv_cntrs = array(); }

				// resuelvo el Cod. de Protocolo (patcodext) de los contactos HLT_PAT (antes: 2do llamado a #crmslsprt)
				$lv_cntrs = $this->resolveCrmSlsProtocol( $lv_cntrs );

				// recarga (filtro / Actualizar): la vista ya esta montada, devuelvo solo los datos
				if ( ($lo_post['dshrld'] ?? '')=='1' ) {
					return $this->co_reg->document->getJson( $lv_cntrs );
				}

				// carga inicial: adjunto el listado al modelo de contactos (la vista lo lee via $vew_data->cntlst)
				// y devuelvo la vista. OJO: el _tmg no tiene modelo propio cargado ($this->lo_mdl es null y asignarle
				// una propiedad revienta): se pasa el modelo crmcnt como 'data', mismo patron que la ficha de
				// paciente (#crmslsdtl), que pasa el modelo hltpat con las evoluciones adjuntas en ->evl.
				$lo_cntmdl->cntlst = $lv_cntrs;
				return $this->co_reg->document->getView('zcutp1_crmcntsls', array('data'=>$lo_cntmdl, 'actcod'=>$this->data['actcod']));
				break;
        
			//   C O D .   D E   P R O T O C O L O   ( resolvedor para la bandeja CRM )
			// OBSOLETO: la bandeja (op #crmslsdsh) ya resuelve el patcodext server-side via resolveCrmSlsProtocol().
			// Se conserva por compatibilidad (recibe los CrmCntSrcCod y devuelve el mapa patcod => patcodext).
			case '#crmslsprt':
				$lo_post = $this->co_reg->request->post;

				// patcod: lista de CrmCntSrcCod separados por coma; quito vacios y duplicados (reindexo)
				$lv_patcodlst = ( $lo_post['patcod'] ?? '' );
				$lv_srccodarr = array_values( array_unique( array_filter( array_map('trim', explode(',', $lv_patcodlst)), function($lp_v){ return $lp_v!==''; } ) ) );

				// recupero los pacientes filtrando por los patcod (operador IN) y armo el mapa patcod => patcodext.
				// el framework envuelve el valor en ^...^ (delimitador de string); para un IN cada codigo debe ir
				// con sus propios delimitadores -> uno los valores con ^,^ y los extremos los cierra el wrap: ^758^,^690^
				$lv_patmap = array();
				if( count($lv_srccodarr)>0 ){
					$lo_patmdl = $this->co_reg->load->model('hltpat');
					$lv_prmpat = array('vewfldflt' => '[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9).implode('^,^', $lv_srccodarr).chr(9).chr(9),
														 'vewmaxrec' => (string)count($lv_srccodarr)
														);
					$lo_patrs = $lo_patmdl->getList($lv_prmpat);
					foreach($lo_patrs as $lv_patrow){ $lv_patmap[$lv_patrow['patcod']] = ($lv_patrow['patcodext']??''); }
				}

				return $this->co_reg->document->getJson( $lv_patmap );
				break;    
        
      //   F I C H A   D E   P A C I E N T E   ( detalle de un paciente del dashboard CRM )  
      case '#crmslsdtl':
				$lo_post = $this->co_reg->request->post;

				// el load del paciente trabaja con el ID (PatCod), NO con el Cod. de Protocolo (PatCodExt);
				// por eso el front envia el patcod junto al patcodext en la request
				$lv_patcod = ( $lo_post['patcod'] ?? $lp_prm['patcod'] ?? '' );

				// recupero los datos del paciente y los paso a la vista.
				if( trim((string)$lv_patcod)=='' ){
					return $this->getCrmSlsDtlErr( 'No se recibio el codigo de paciente (PatCod) en la request.', '' );
				}

				$lo_patmdl = $this->co_reg->load->model('hltpat');
				if( !$lo_patmdl->load( array('patcod'=>$lv_patcod), false ) ){
					return $this->getCrmSlsDtlErr( '['.$lo_patmdl->errcod.'] '.$lo_patmdl->errtxt, $lv_patcod );
				}
        
        // cargo el nombre de la obra social del paciente
        $lo_perdatmdl = $this->co_reg->load->model('grldatper');
				if( !$lo_perdatmdl->load( array('persrctyp'=>'HLT_PAT', 'persrccod'=>$lv_patcod) ) ){
					return $this->getCrmSlsDtlErr( '['.$lo_perdatmdl->errcod.'] '.$lo_perdatmdl->errtxt, $lv_patcod );
				}
				$lo_patmdl->hhrmedcovtxt = $lo_perdatmdl->hhrmedcovtxt;
        
				// evoluciones medicas del paciente (Historia Clinica):
				// Se acota a los ultimos 6 meses (por EvlDte) para que la consulta sea performante.
				$lo_evlmdl = $this->co_reg->load->model('hltpatevl');
				$lv_evlprm = array('vewfldflt' => '[~fltrow~]e.patcod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9).
																					'[~fltrow~]e.evldte>=dateadd(month,-6,getdate())'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9),
													 'vewfldord' => 'e.evldte DESC',
													 'vewmaxrec' => '200');
				$lv_evlrs = $lo_evlmdl->getList( $lv_evlprm, null, null, false );
				if ( !is_array($lv_evlrs) ) { $lv_evlrs = array(); }

				// Motivo de no realizacion (Historia Clinica): para las evoluciones NO realizadas (DocSts='P')
				// se resuelve la descripcion del motivo a partir de la sigla <EVLCNCMTV> de la evolucion y del
				// CusCod (financiador), contra el parametro EVLCNCMTVLST.
				$lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');
				$lv_mtvatr = ( $lo_prmmdl->load(array('mdlcod'=>'EVLCNCMTVLST')) ? $lo_prmmdl->mdlatrval001 : '' );
				$lo_mtvmap = array();	// cache de mapas sigla=>descripcion por CusCod (evita reparsear el tag por fila)

				foreach ( $lv_evlrs as $lv_i => $lv_evlrow ) {
					// solo las no realizadas (DocSts='P') llevan motivo de no realizacion
					if ( strtoupper((string)($lv_evlrow['docsts'] ?? ''))!='P' ) { continue; }

					// sigla del motivo: tag <EVLCNCMTV> guardado en los atributos de la evolucion (EvlAtr001)
					$lv_sig = trim( $this->co_reg->document->getTagValue( ($lv_evlrow['evlatr001'] ?? ''), 'EVLCNCMTV' ) );
					if ( $lv_sig=='' ) { continue; }

					// mapa sigla=>descripcion del financiador de la evolucion (con cache); fallback a la lista ALL
					$lv_cuscod = (string)($lv_evlrow['cuscod'] ?? '');
					if ( !isset($lo_mtvmap[$lv_cuscod]) ) {
						$lv_lst = $this->co_reg->document->getTagValue( $lv_mtvatr, 'CUS_'.$lv_cuscod );
						if ( $lv_lst=='' ) { $lv_lst = $this->co_reg->document->getTagValue( $lv_mtvatr, 'ALL' ); }
						$lo_map = array();
						foreach ( explode(';', $lv_lst) as $lv_pair ) {
							$lv_kv = explode(',', $lv_pair, 2);
							if ( trim($lv_kv[0])!='' ) { $lo_map[ strtoupper(trim($lv_kv[0])) ] = trim($lv_kv[1] ?? ''); }
						}
						$lo_mtvmap[$lv_cuscod] = $lo_map;
					}

					// descripcion del motivo para la sigla de la evolucion (queda '' si no matchea)
					$lv_evlrs[$lv_i]['evlcncmtvtxt'] = ( $lo_mtvmap[$lv_cuscod][ strtoupper($lv_sig) ] ?? '' );
				}

				$lo_patmdl->evl = $lv_evlrs;

				// Contactos CRM del paciente (seccion Contactos de la ficha): se recuperan aca con getList del modelo
				// (mismo patron que las evoluciones de arriba). El origen del contacto es el paciente.
				// Se acota a los ultimos 6 meses (por CrmCntReqDte) para que la consulta sea performante.
				// authCheck=false (op 18 del SP): mismo criterio que el load del paciente y el dashboard, para que
				// la ficha funcione aunque el usuario no tenga la autorizacion estandar de CRM/CNT.
				$lo_cntmdl = $this->co_reg->load->model('crmcnt');
				$lv_cntprm = array('vewfldflt' => '[~fltrow~]c.crmcntsrctyp'.chr(9).'='.chr(9).chr(9).'HLT_PAT'.chr(9).chr(9).
																					'[~fltrow~]c.crmcntsrccod'.chr(9).'='.chr(9).chr(9).$lv_patcod.chr(9).chr(9).
																					'[~fltrow~]c.crmcntreqdte>=dateadd(month,-6,getdate())'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9),
													 'vewfldord' => 'c.ctedte DESC',
													 'vewmaxrec' => '100');
				$lv_cntrs = $lo_cntmdl->getList( $lv_cntprm, null, null, false );
				if ( !is_array($lv_cntrs) ) { $lv_cntrs = array(); }

				// color del motivo (token <clr> del atributo CrmCntPrtAtr): se resuelve aca para no parsear XML en la
				// vista (mismo criterio que la vista de listado; pinta el badge del motivo del contacto)
				foreach ( $lv_cntrs as $lv_i => $lv_cntrow ) {
					$lv_cntrs[$lv_i]['crmcntprtclr'] = trim( $this->co_reg->document->getTagValue( ($lv_cntrow['crmcntprtatr'] ?? ''), 'clr' ) );
				}

				$lo_patmdl->cnt = $lv_cntrs;

				return $this->co_reg->document->getView('zcutp1_crmcntslsdtl', array('data'=>$lo_patmdl, 'actcod'=>$this->data['actcod']));
				break;
        
      case '#cntfrmrpt':{
        $lo_post = $this->co_reg->request->post;
        $lv_ret= array();
        $lv_data_sqlstm = array();
        $deb_lst=array();
        
        
        $lv_crmmtvls = str_replace(',',chr(10),($lp_prm['cntmtv']??''));//crmcntsrctyp
        $lv_sysdocfrmcodls = str_replace(',',chr(10),($lp_prm['sysdocfrmcod']??''));//crmcntsrctyp
        $lv_rshwemtfrm = $lp_prm['shwemtfrm']??'';//Visualiza los contactos tienen formularios vesios
        
        // CONTACTOS CRM
        $lo_cntmdl = $this->co_reg->load->model('crmcnt');
        
        //Filtros CONTACTOS CRM 
				$lv_fltarrcnt = explode('[~fltrow~]',$lo_post['vewfldflt']??'' );		
				for($i=count($lv_fltarrcnt)-1; $i>0; $i--){
					if(stripos(';crmcnttxt;crmcnttyptxt;crmcntsrccnttxt;crmcntsrctxt;crmcntmtvtxt;crmcntcod;crmcntreqdte;crmcntrefdoc;crmcntststxt;usrtxt;lndregtxt;',';'.explode(chr(9),$lv_fltarrcnt[$i])[0].';')===false){
						unset($lv_fltarrcnt[$i]);
					}else{
						$lv_fltpat=true;
            $lv_fltarrpat[$i] = str_replace('usrtxt','u.usrtxt',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('lndregtxt','lr.lndregtxt',$lv_fltarrpat[$i]);
            $lv_fltarrpat[$i] = str_replace('crmcntststxt','s.crmcntststxt',$lv_fltarrpat[$i]);
          }
				}
        $lv_prmflt = array('vewfldflt' =>(count($lv_fltarrcnt)>0?implode('[~fltrow~]',$lv_fltarrcnt):'').
                           								'[~fltrow~]c.docsts'.chr(9).'IN'.chr(9).chr(9).'A'.chr(9).chr(9),
													 'vewfldord' => 'c.crmcntreqdte desc',
                           'vewmaxrec'=> ($lo_post['vewmaxrec']??'101')-1
													);
        
        // filtro externo de motivos de contactos
        if($lv_crmmtvls !=''){
        	$lv_prmflt['vewfldflt'].='[~fltrow~]c.crmcntmtvcod'.chr(9).'IN'.chr(9).chr(9).$lv_crmmtvls.chr(9).chr(9);
        }
        
        $lo_crmcnt_rs= $lo_cntmdl->getlist($lv_prmflt,null,null,false);
        $lv_data_sqlstm[]=$lo_cntmdl->getSysData('sqlstm');
        $lv_crmcntcodlst= array_column($lo_crmcnt_rs, 'crmcntcod');
        $lo_wrkCntLst= $lv_crmcntcodlst;
        $deb_lst['crmcntcodlst']= $lv_crmcntcodlst;
        
        
        //DATOS CAMPOS  FROMULARIOS
        $lo_datfldmdl = $this->co_reg->load->model('grldatfrmfld');
        $lv_fltfrmfld = explode('[~fltrow~]',$lo_post['vewfldflt']??'' );		
				for($i=count($lv_fltfrmfld)-1; $i>0; $i--){
					if(stripos(';;',';'.explode(chr(9),$lv_fltfrmfld[$i])[0].';')===false){
						unset($lv_fltfrmfld[$i]);
					}
				}
        
        $lv_prmflt = array('vewfldflt' =>(count($lv_fltfrmfld)>0?implode('[~fltrow~]',$lv_fltfrmfld):'').
                           							  '[~fltrow~]f.srcobjcod001'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lv_crmcntcodlst) .chr(9).chr(9),//'[~fltrow~]f.srcobjcod002'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_wrkstplst) .chr(9).chr(9),//'[~fltrow~]f.frmdatcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_datcodlst) .chr(9).chr(9),
													 'vewfldord' => 'f.frmdatcod'
													);
        
        if($lv_sysdocfrmcodls !=''){
        	$lv_prmflt['vewfldflt'].='[~fltrow~]sf.sysdocfrmcod'.chr(9).'IN'.chr(9).chr(9).$lv_sysdocfrmcodls.chr(9).chr(9);
        }
        $lo_datfld_rs= $lo_datfldmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_datfldmdl->getSysData('sqlstm');
        
        //CREO UNA LISTA DE LOS CODIGOS DE FORMULARIOS 
        $lo_frmlst = array_column($lo_datfld_rs, 'sysdocfrmcod','sysdocfrmcod');
        $deb_lst['frmlst']= $lo_frmlst;
        
        // DEFINICION FROMULARIOS CAMPOS
        $lo_frmfldmdl = $this->co_reg->load->model('sysdocfrmfld');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]sysdocfrmcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_frmlst) .chr(9).chr(9).
                           							 '[~fltrow~]sysfldinptyp'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),array('COMBO','LIST')) .chr(9).chr(9),
													 'vewfldord' => 'sysdocfrmcod'
													);
        $lo_deffld_rs= $lo_frmfldmdl->getlist($lv_prmflt);
        $lv_data_sqlstm[]=$lo_frmfldmdl->getSysData('sqlstm');
        
        $lo_defFld =[];
        foreach($lo_deffld_rs as $rowDefFld){
          $coldata=$rowDefFld['sysfldinptyp']=='LIST'?8:7;
          $key= strtolower($rowDefFld['sysdocfrmfldcodext']);
          if(!array_key_exists($key,$lo_defFld)){
            $lo_defFld[$key]=[];
          }
          $aux =explode("\n",json_decode($rowDefFld['sysdocfrmfldatr'],true)[$coldata]['sysdocfrmfldatrval']);
          foreach($aux as $rowData){
            $lv_opnAux=explode("|",$rowData);
            $keyCbo=$key.'_'.trim($lv_opnAux[0]);
            $datCbo=trim($lv_opnAux[1]);
            $lo_defFld[$key][$keyCbo]=$datCbo;
          }
        }
        $deb_lst['z_defFld']= $lo_defFld;
        
        $datFld =[];
        foreach($lo_datfld_rs as $rowDatFrm){
					$keyCrmCnt= $rowDatFrm['srcobjcod001'];
          if(!array_key_exists($keyCrmCnt,$datFld)){
            $datFld[$keyCrmCnt]=[];
          }
          if(array_key_exists($rowDatFrm['frmdatfldcodext'],$lo_defFld)){
            $key=$rowDatFrm['frmdatfldcodext'];
            $keyCbo=$key.'_'.trim($rowDatFrm['frmdatval']);
            $valLst=$lo_defFld[$rowDatFrm['frmdatfldcodext']];
            $datFld[$keyCrmCnt][$rowDatFrm['frmdatfldcodext']]=$valLst[$keyCbo];
          }else{
          	$datFld[$keyCrmCnt][$rowDatFrm['frmdatfldcodext']]=$rowDatFrm['frmdatval'];
          }
          
        }
        $deb_lst['datfld']= $datFld;
        foreach($lo_crmcnt_rs as $rowCrmCnt){
          if(array_key_exists($rowCrmCnt['crmcntcod'],$datFld)){
          	$ret[]=$rowCrmCnt + $datFld[$rowCrmCnt['crmcntcod']];
          }else{
            $ret[]=$rowCrmCnt;
          }
        }
        
        
        if(isset($lp_prm['debugger'])){
          $ret[0]['z_sqlstm']=$lv_data_sqlstm;
          $ret[0]['z_debug_data']=$deb_lst;
        }
        if(($lp_prm['vewlog']??'')!=''){
        	return $this->co_reg->document->getJson($ret);
        }
        return $ret;
        break; 
      }
      case '#prcupdbchsve':{
        $lo_post = $this->co_reg->request->post;
        $lv_ret = array('errcod'=>'','errtyp'=>'S','errtxt'=>'','data'=>'');
        //hltprsprc
        $lv_vewmaxrec='';
        $lo_prsprcmdl = $this->co_reg->load->model('hltprsprc');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]p.prsprccod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lo_post['prsprccodlst']) .chr(9).chr(9),
                        'vewfldord' => 'prsprccod desc',
                        'vewmaxrec' => $lv_vewmaxrec);
        $lo_ordmatrs = $lo_prsprcmdl->getList($lv_prm);
        $lv_sqlstmlst[]=$lo_prsprcmdl->getsysdata('sqlstm');
        $prclst=array();
        $lv_ret['sqlstmlst']=array();
        foreach($lo_post['prsprccodlst'] as $rowPrc){
          $lo_prsprcmdl->load(array('prsprccod'=>$rowPrc));
          $lv_prsprcpre=$lo_prsprcmdl->getData();
          // Inactivo el actual
          $lo_prsprcmdl = $this->co_reg->load->model('hltprsprc');
          $lv_prsprcpre['docsts']='A';
          $lv_prsprcpre['prsprcdtestr']=$lv_prsprcpre['prsprcdtestr']->format('d/m/Y');
          $lv_dteto = new DateTime($this->co_reg->db->sqldate($lo_post['prsprcdtestr']));
          $lv_dteto =$lv_dteto->modify('-1 day');
          $lv_prsprcpre['prsprcdteend']=$lv_dteto->format('d/m/Y');//$lo_post['prsprcdtestr'];//$lv_prsprcpre['prsprcdteend']->format('d/m/Y');
        	$lo_prsprcmdl->save($lv_prsprcpre);
          $lv_ret['sqlstmlst'][]=$lo_prsprcmdl->getsysdata('sqlstm');
          
          //Agrego nuevo valor
          $lo_prsprcmdl = $this->co_reg->load->model('hltprsprc');
          $la_prc=0;
                  
          if($lo_post['prsprctyp']=='1'){
            $la_prc=($lv_prsprcpre['prsprcval'] * $lo_post['prsprcval'])/100;
            $lv_prsprcpre['prsprcval']=$lv_prsprcpre['prsprcval']+ $la_prc;
          }else{
            $lv_prsprcpre['prsprcval']=$lo_post['prsprcval'];
          }
          $lv_prsprcpre['prsprccod']='';
          $lv_prsprcpre['prsprcdtestr']=$lo_post['prsprcdtestr'];
          $lv_prsprcpre['prsprcdteend']=$lo_post['prsprcdteend'];
          $lv_prsprcpre['docsts']='A';
          $lo_prsprcmdl->save($lv_prsprcpre);
          $lv_ret['sqlstmlst'][]=$lo_prsprcmdl->getsysdata('sqlstm');
          
          $prclst[]=$lv_prsprcpre;
          
          
        }
        $lv_ret['data']=$prclst;
        
        return $this->co_reg->document->getJson( $lv_ret );
	    	break;
      }
      case '#prcupdbch':{
        $lv_prm = array('lang' 	=> $this->co_reg->language,
													'input' => $this->co_reg->input,
													'sec' 	=> $this->co_reg->sec,
													'load'  => $this->co_reg->load,
													'data' => array(),
													'actcod'=> $this->data['actcod']
													//,'model' => self::MODEL
													);
					$lv_buffer = 	$this->co_reg->load->view('zcutp1_tinprcupdbch', $lv_prm);
					return $lv_buffer;
        break;
      }
      case '#prcupdbchdat':{
        
        $lo_post = $this->co_reg->request->post;
        $lv_ret = array('errcod'=>'','errtyp'=>'S','errtxt'=>'','data'=>'');
        $lv_sqlstmlst=array();
        $lv_vewfldflt = ($lo_post['vewfldflt'] ?? '');
        $lv_fltarr = explode('[~fltrow~]', $lv_vewfldflt);
        // Filtros permitidos
        $lv_map = array(
          'p.prsprccod' => 'prsprccod',
          'prsprctyp' =>'prsprctyp',
          'spctxt' =>'spctxt',
          'prstxt' =>'prstxt',
          'hltdisclstxt' =>'hltdisclstxt',
          'pattxt' =>'pattxt',
          'docsts' =>'p.docsts',
          'prsprcdtestr' =>'prsprcdtestr',
          'prsprcdteend' =>'prsprcdteend',
          'prsprcval' =>'prsprcval'

        );
        $lv_filtro_pedido='';
        $lv_vewmaxrec='';
        for ($i = count($lv_fltarr) - 1; $i > 0; $i--) {
          $lv_rowarr = $lv_fltarr[$i];
          if ($lv_rowarr === '') { continue; }
          $lv_parts = explode(chr(9), $lv_rowarr);
          $lv_fld = trim($lv_parts[0] ?? '');
          if ($lv_fld === '') { continue; }

          // Pedido (buyordmat)
          
          if (isset($lv_map[$lv_fld])) {
            $lv_parts_ped = $lv_parts;
            $lv_parts_ped[0] = $lv_map[$lv_fld];
            $lv_filtro_pedido .= '[~fltrow~]' . implode(chr(9), $lv_parts_ped);
          }
        }
        $lo_ordmatmdl = $this->co_reg->load->model('hltprsprc');
        $lv_prm = array('vewfldflt' => $lv_filtro_pedido,
                        'vewfldord' => 'prsprccod desc',
                        'vewmaxrec' => $lv_vewmaxrec);
        $lo_ordmatrs = $lo_ordmatmdl->getList($lv_prm);
        $lv_sqlstmlst[]=$lo_ordmatmdl->getsysdata('sqlstm');
        
				$lv_ret['data']=$lo_ordmatrs;
        $lv_ret['log']=$lv_sqlstmlst;
        return $this->co_reg->document->getJson( $lv_ret );
	    	break;
      }
      // CONTACTOS CRM CON DATOS DEL ULTIMO CIERRE
      case '#crmcntdetcls':{
        $lo_post = $this->co_reg->request->post;
        $lv_fltstr = $lo_post['vewfldflt'] ?? '';
        $lo_fltcnt = array();
        $lo_fltcls = array();

          $lv_getfldnme = function($lp_fldnme) {
          $lo_fldpart = explode('.', strtolower(trim($lp_fldnme)));
          return end($lo_fldpart);
        };

        $lv_getdteval = function($lp_val, $lp_endofday = false) {
          if ($lp_val instanceof DateTimeInterface) { return $lp_val->getTimestamp(); }

          $lv_val = trim((string)$lp_val);
          if ($lv_val === '') { return null; }

          foreach (array('d/m/Y H:i:s', 'd/m/Y H:i', 'd/m/Y', 'Y-m-d H:i:s', 'Y-m-d H:i', 'Y-m-d') as $lv_fmt) {
            $lo_dte = DateTime::createFromFormat('!' . $lv_fmt, $lv_val);
            if ($lo_dte instanceof DateTime) {
              if ($lp_endofday && strpos($lv_fmt, 'H:i') === false) { $lo_dte->setTime(23, 59, 59); }
              return $lo_dte->getTimestamp();
            }
          }

          $lv_tme = strtotime($lv_val);
          return $lv_tme === false ? null : $lv_tme;
        };

        $lv_getcmpval = function($lp_val, $lp_isdte = false) use ($lv_getdteval) {
          if ($lp_isdte) {
            $lv_dteval = $lv_getdteval($lp_val);
            return $lv_dteval === null ? 0 : $lv_dteval;
          }
          return strtolower(trim((string)$lp_val));
        };

        $lv_matchflt = function($lp_val, $lp_flt, $lp_isdte = false) use ($lv_getdteval) {
          $lv_opr = strtoupper(trim($lp_flt[1] ?? ''));
          $lv_val = $lp_flt[2] ?? '';
          $lv_str = $lp_flt[3] ?? '';
          $lv_end = $lp_flt[4] ?? '';

          if (substr($lv_val, 0, 6) === '(like)') {
            $lv_opr = 'LIKE';
            $lv_val = substr($lv_val, 6);
          } elseif (substr($lv_val, 0, 4) === '(in)') {
            $lv_opr = 'IN';
            $lv_str = str_replace(';', chr(10), substr($lv_val, 4));
          }

          if ($lv_opr === 'EE') { return $lp_val === '' || $lp_val === null; }
          if ($lv_opr === 'NE') { return $lp_val !== '' && $lp_val !== null; }

          if ($lp_isdte) {
            $lv_cmp = $lv_getdteval($lp_val);
            $lv_ini = $lv_getdteval($lv_str !== '' ? $lv_str : $lv_val);
            $lv_fin = $lv_getdteval($lv_end, true);

            if ($lv_cmp === null) { return false; }
            switch ($lv_opr) {
              case 'BT': return $lv_ini !== null && $lv_fin !== null && $lv_cmp >= $lv_ini && $lv_cmp <= $lv_fin;
              case 'NB': return $lv_ini !== null && $lv_fin !== null && !($lv_cmp >= $lv_ini && $lv_cmp <= $lv_fin);
              case 'GT': return $lv_ini !== null && $lv_cmp > $lv_ini;
              case 'GE': return $lv_ini !== null && $lv_cmp >= $lv_ini;
              case 'LT': return $lv_ini !== null && $lv_cmp < $lv_ini;
              case 'LE': return $lv_ini !== null && $lv_cmp <= $lv_ini;
              case 'NS':
              case '<>': return $lv_ini !== null && date('Y-m-d', $lv_cmp) !== date('Y-m-d', $lv_ini);
              default: return $lv_ini !== null && date('Y-m-d', $lv_cmp) === date('Y-m-d', $lv_ini);
            }
          }

          $lv_cmp = strtolower(trim((string)$lp_val));
          $lv_val = strtolower(trim((string)$lv_val));
          $lv_str = strtolower(trim((string)$lv_str));
          $lv_end = strtolower(trim((string)$lv_end));

          switch ($lv_opr) {
            case '':
            case 'LIKE': return strpos($lv_cmp, $lv_val) !== false;
            case 'SW': return strpos($lv_cmp, $lv_str) === 0;
            case 'EW': return $lv_str === '' || substr($lv_cmp, -strlen($lv_str)) === $lv_str;
            case 'IN': return in_array($lv_cmp, array_map('strtolower', preg_split('/\r?\n/', $lv_str)));
            case 'NI': return !in_array($lv_cmp, array_map('strtolower', preg_split('/\r?\n/', $lv_str)));
            case 'BT': return $lv_cmp >= $lv_str && $lv_cmp <= $lv_end;
            case 'NB': return !($lv_cmp >= $lv_str && $lv_cmp <= $lv_end);
            case 'GT': return $lv_cmp > $lv_str;
            case 'GE': return $lv_cmp >= $lv_str;
            case 'LT': return $lv_cmp < $lv_str;
            case 'LE': return $lv_cmp <= $lv_str;
            case 'NS':
            case '<>': return $lv_cmp !== $lv_str;
            default: return $lv_cmp === $lv_str;
          }
        };
        // Los campos calculados se filtran luego de recuperar el ultimo cierre.
        foreach (explode('[~fltrow~]', $lv_fltstr) as $lv_fltrow) {
          if ($lv_fltrow === '') { continue; }

          $lo_fltdat = explode(chr(9), $lv_fltrow);
          $lv_fldnme = $lv_getfldnme($lo_fltdat[0] ?? '');
          if (in_array($lv_fldnme, array('crmcntclsusr', 'crmcntclsdte'))) {
            $lo_fltcls[] = $lo_fltdat;
          } else {
            $lo_fltcnt[] = $lv_fltrow;
          }
        }

        $lv_ord = trim($lo_post['vewfldord'] ?? '');
        $lo_orddat = preg_split('/\s+/', $lv_ord);
        $lv_ordfld = $lv_getfldnme($lo_orddat[0] ?? '');
        $lv_ordcls = in_array($lv_ordfld, array('crmcntclsusr', 'crmcntclsdte'));

        $lo_cntmdl = $this->co_reg->load->model('crmcnt');
        $lv_prmcnt = array(
          'vewfldflt' => count($lo_fltcnt) > 0 ? '[~fltrow~]' . implode('[~fltrow~]', $lo_fltcnt) : '',
          'vewfldord' => $lv_ordcls ? '' : $lv_ord
        );

        // Si hay filtro u orden por cierre, el limite se aplica sobre el resultado enriquecido.
        if (count($lo_fltcls) == 0 && !$lv_ordcls && isset($lo_post['vewmaxrec'])) {
          $lv_prmcnt['vewmaxrec'] = $lo_post['vewmaxrec'];
        }

        $lo_cnt = $lo_cntmdl->getList($lv_prmcnt, array(), null, false);
        if (!is_array($lo_cnt) || isset($lo_cnt['errtyp']) || count($lo_cnt) == 0) {
          return $lo_cnt;
        }

        // Estados cuyo flag indica que el contacto queda cerrado.
        $lo_stsmdl = $this->co_reg->load->model('crmcntsts');
        $lo_sts = $lo_stsmdl->getList(array(
          'vewfldflt' => '[~fltrow~]s.crmcntstscls' . chr(9) . '=' . chr(9) . chr(9) . '1' . chr(9) . chr(9)
 				), array(), null, false);

        if (!is_array($lo_sts) || isset($lo_sts['errtyp'])) {
          return $lo_sts;
        }

        $lo_clsststxt = array();
        foreach ($lo_sts as $lv_stsrow) {
          if (($lv_stsrow['crmcntststxt'] ?? '') !== '') {
            $lo_clsststxt[] = $lv_stsrow['crmcntststxt'];
          }
        }

        $lo_clsbycnt = array();
        $lo_cntcod = array_values(array_unique(array_filter(array_column($lo_cnt, 'crmcntcod'), function($lp_val) {
          return $lp_val !== '' && $lp_val !== null;
        })));

        if (count($lo_clsststxt) > 0 && count($lo_cntcod) > 0) {
          $lo_chgmdl = $this->co_reg->load->model('sysdocchg');
          $lv_prmchg = array(
            'vewfldflt' => '[~fltrow~]dc.chgdocsrctyp' . chr(9) . '=' . chr(9) . chr(9) . 'CRM_CNT' . chr(9) . chr(9)
                             . '[~fltrow~]dc.chgdocsrccod' . chr(9) . 'IN' . chr(9) . chr(9) . implode(chr(10), $lo_cntcod) . chr(9) . chr(9)
                             . '[~fltrow~]dca.chgdocatrnme' . chr(9) . '=' . chr(9) . chr(9) . 'Estado' . chr(9) . chr(9)
                             . '[~fltrow~]dca.chgdocatrnew' . chr(9) . 'IN' . chr(9) . chr(9) . implode(chr(10), $lo_clsststxt) . chr(9) . chr(9),
            'extra' => '<rownumber>2</rownumber>'
          );
          $lo_chg = $lo_chgmdl->getVariousDetails($lv_prmchg);

          if (!is_array($lo_chg) || isset($lo_chg['errtyp'])) {
            return $lo_chg;
          }

          foreach ($lo_chg as $lv_chgrow) {
            $lv_cntcod = (string)($lv_chgrow['chgdocsrccod'] ?? '');
            if ($lv_cntcod !== '' && !isset($lo_clsbycnt[$lv_cntcod])) {
              $lo_clsbycnt[$lv_cntcod] = $lv_chgrow;
            }
          }
        }

        $lo_ret = array();
        foreach ($lo_cnt as $lv_cntrow) {
          $lv_cntcod = (string)($lv_cntrow['crmcntcod'] ?? '');
          $lv_clsrow = $lo_clsbycnt[$lv_cntcod] ?? array();
          $lv_cntrow['crmcntclsusr'] = $lv_clsrow['cteusr'] ?? '';
          $lv_cntrow['crmcntclsdte'] = $lv_clsrow['ctedte'] ?? '';

          $lv_match = true;
          foreach ($lo_fltcls as $lo_fltdat) {
           $lv_fldnme = $lv_getfldnme($lo_fltdat[0] ?? '');
            if (!$lv_matchflt($lv_cntrow[$lv_fldnme] ?? '', $lo_fltdat, $lv_fldnme === 'crmcntclsdte')) {
              $lv_match = false;
              break;
            }
          }

          if ($lv_match) { $lo_ret[] = $lv_cntrow; }
        }

        if ($lv_ordcls) {
          $lv_orddir = strtoupper($lo_orddat[1] ?? 'ASC') === 'DESC' ? -1 : 1;
          usort($lo_ret, function($lp_rowa, $lp_rowb) use ($lv_ordfld, $lv_orddir, $lv_getcmpval) {
            $lv_isdte = $lv_ordfld === 'crmcntclsdte';
            $lv_vala = $lv_getcmpval($lp_rowa[$lv_ordfld] ?? '', $lv_isdte);
            $lv_valb = $lv_getcmpval($lp_rowb[$lv_ordfld] ?? '', $lv_isdte);
            if ($lv_vala == $lv_valb) { return 0; }
            return ($lv_vala < $lv_valb ? -1 : 1) * $lv_orddir;
          });
        }

        if ((count($lo_fltcls) > 0 || $lv_ordcls) && isset($lo_post['vewmaxrec']) && $lo_post['vewmaxrec'] !== '') {
          // parseViewOptions solicita un registro adicional para detectar si hay mas resultados.
          $lo_ret = array_slice($lo_ret, 0, intval($lo_post['vewmaxrec']) + 1);
        }

        return $lo_ret;
        break;
      }

		}
	}


	// R E S U E L V E   E L   C O D .   D E   P R O T O C O L O   ( patcodext )   de las filas de la bandeja CRM
	// Recibe las filas del listado de contactos y devuelve las mismas filas con el patcodext resuelto para las
	// de origen HLT_PAT. El PatCodExt (Cod. de Protocolo) no viene en el listado de CRM_CNT: se obtiene del
	// modelo HLTPAT a partir del CrmCntSrcCod (= PatCod) de cada contacto, con un unico getList por IN.
	private function resolveCrmSlsProtocol( $lp_rows ) {
		if ( !is_array($lp_rows) || count($lp_rows)==0 ) { return $lp_rows; }

		// junto los CrmCntSrcCod (PatCod) de los contactos HLT_PAT, sin vacios ni duplicados
		$lv_srccodarr = array();
		foreach ( $lp_rows as $lv_row ) {
			if ( ($lv_row['crmcntsrctyp']??'')=='HLT_PAT' && trim((string)($lv_row['crmcntsrccod']??''))!='' ) {
				$lv_srccodarr[] = trim((string)$lv_row['crmcntsrccod']);
			}
		}
		$lv_srccodarr = array_values( array_unique( $lv_srccodarr ) );
		if ( count($lv_srccodarr)==0 ) { return $lp_rows; }

		// mapa PatCod => PatCodExt. authCheck=false (op 18 del SP de HLT_PAT): el dashboard debe resolver el protocolo aunque el usuario
		// no tenga la autorizacion estandar del programa Pacientes (mismo criterio que el listado de contactos).
		$lo_patmdl = $this->co_reg->load->model('hltpat');
		$lv_prmpat = array('vewfldflt' => '[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9).implode('^,^', $lv_srccodarr).chr(9).chr(9),
											 'vewmaxrec' => (string)count($lv_srccodarr)
											);
		$lo_patrs = $lo_patmdl->getList( $lv_prmpat, null, null, false );
		$lv_patmap = array();
		if ( is_array($lo_patrs) ) {
			foreach ( $lo_patrs as $lv_patrow ) { $lv_patmap[$lv_patrow['patcod']] = ($lv_patrow['patcodext']??''); }
		}

		// vuelco el patcodext a cada fila por su CrmCntSrcCod
		foreach ( $lp_rows as $lv_k => $lv_row ) {
			$lv_cod = (string)($lv_row['crmcntsrccod']??'');
			if ( $lv_cod!='' && isset($lv_patmap[$lv_cod]) ) { $lp_rows[$lv_k]['patcodext'] = $lv_patmap[$lv_cod]; }
		}
		return $lp_rows;
	}

	// T R A D U C E   E L   F I L T R O   D E   C O D .   P A C I E N T E   ( patcodext -> c.crmcntsrccod )
	// La bandeja CRM muestra el PatCodExt (patcodext), que NO es columna del SP de CRM_CNT (se resuelve luego
	// via resolveCrmSlsProtocol). Para poder filtrar por el, se extrae la fila del filtro 'patcodext', se
	// resuelven en HLT_PAT los PatCod cuyo PatCodExt matchea (relacion 1:1) y se reemplaza por un filtro sobre
	// c.crmcntsrccod (= PatCod), que si es columna filtrable del SP.
	private function resolveCrmSlsPatFilter( $lp_fltstr ) {
		// sin filtro por Cod. Paciente: devuelvo el filtro entrante tal cual
		if ( strpos((string)$lp_fltstr, 'patcodext') === false ) { return (string)$lp_fltstr; }

		// separo las filas del filtro; saco la de patcodext y me quedo con ella
		$lv_fltarr = explode('[~fltrow~]', $lp_fltstr);
		$lv_out    = array();
		$lv_patflt = '';
		foreach ( $lv_fltarr as $lv_row ) {
			if ( $lv_row==='' ) { continue; }
			$lv_col = explode(chr(9), $lv_row);
			if ( ($lv_col[0]??'')==='p.patcodext' ) { $lv_patflt = "[~fltrow~]".$lv_row; continue; }
			$lv_out[] = $lv_row;
		}
		
		// filtro por patcodext sin valor (raro): devuelvo el resto sin tocar
		if ( $lv_patflt==='' ) { return ( count($lv_out)>0 ? '[~fltrow~]'.implode('[~fltrow~]', $lv_out) : '' ); }

		// resuelvo los PatCod cuyo PatCodExt matchea el valor (LIKE, mismo criterio que el resto del filtro).
		$lo_patmdl = $this->co_reg->load->model('hltpat');
		$lo_patrs  = $lo_patmdl->getList( array( 'vewfldflt' => $lv_patflt, 'vewmaxrec' => '1000' ), null, null, false );
    
		$lv_patcodarr = array();
		if ( is_array($lo_patrs) ) {
			foreach ( $lo_patrs as $lv_patrow ) {
				$lv_pc = trim( (string)($lv_patrow['patcod']??'') );
				if ( $lv_pc!=='' ) { $lv_patcodarr[] = $lv_pc; }
			}
		}
		$lv_patcodarr = array_values( array_unique( $lv_patcodarr ) );

		// ningun paciente matchea -> filtro imposible (grilla vacia, no la lista completa)
		if ( count($lv_patcodarr)===0 ) {
			$lv_out[] = 'c.crmcntsrccod'.chr(9).'='.chr(9).chr(9).'-1'.chr(9).chr(9);
		} else {
			// el framework envuelve cada valor de string en ^...^; para el IN uno los PatCod con ^,^ (ej ^758^,^690^)
			$lv_out[] = 'c.crmcntsrccod'.chr(9).'IN'.chr(9).chr(9).implode('^,^', $lv_patcodarr).chr(9).chr(9);
		}

		return '[~fltrow~]'.implode('[~fltrow~]', $lv_out);
	}

	private function getCrmSlsDtlErr( $lp_errtxt, $lp_patcod ) {
		return '<section id="crmslsdtlerr" data-title="Ficha de Paciente">'
		     .   '<div style="margin:18px;padding:16px 18px;border:1px solid #f5c9c9;border-radius:10px;background:#fdecec;color:#b3261e;font-weight:700;">'
		     .     '<div style="font-size:15px;margin-bottom:8px;"><i class="fa-solid fa-triangle-exclamation"></i> No se pudo abrir la ficha del paciente.</div>'
		     .     '<div style="font-weight:400;color:#7a3b38;">PatCod: '.htmlspecialchars((string)$lp_patcod).'</div>'
		     .     '<div style="font-weight:400;color:#7a3b38;">'.htmlspecialchars((string)$lp_errtxt).'</div>'
		     .   '</div>'
		     . '</section>';
	}
}
?>

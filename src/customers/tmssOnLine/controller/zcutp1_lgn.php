<?php 
final class zcutp1_lgnController extends tmssController {
	const MODEL = 'zcutp1'; 
	const VIEW  = 'zcutp1_lgn';
	const ID = '';    
  protected $co_reg; 
	private $lo_mdl;
	private $data = array();
	
  function __construct(&$lp_reg) { $this->co_reg = $lp_reg; } 

  /**
   * Carga en bloque los nombres de contacto y los domicilios necesarios para
   * el reporte de entregas. Los indices evitan consultar la base por cada fila.
   */
  private function getTraDlvDestinationData($lp_dlvrs, &$lp_sqlstm) {
    $lv_cntids = array();
    $lv_objids = array();

    foreach($lp_dlvrs as $lv_row){
      $lv_dstcntcod = trim((string)($lv_row['dstcntcod']??''));
      if($lv_dstcntcod!=='' && $lv_dstcntcod!=='0'){
        $lv_cntids[$lv_dstcntcod] = true;
      }

      $lv_dstobjtyp = trim((string)($lv_row['dstobjtyp']??''));
      $lv_dstobjcod = trim((string)($lv_row['dstobjcod']??''));
      if($lv_dstobjtyp!=='' && $lv_dstobjcod!==''){
        $lv_objids[$lv_dstobjtyp][$lv_dstobjcod] = true;
      }
    }

    $lv_ret = array(
      'cnttxt' => array(),
      'cntadr' => array(),
      'objadr' => array()
    );

    if(count($lv_cntids)>0){
      $lv_cntcodlst = implode(chr(10), array_keys($lv_cntids));

      $lo_cntmdl = $this->co_reg->load->model('grldatcnt');
      $lo_cntrs = $lo_cntmdl->getList(array(
        'vewfldflt' => '[~fltrow~]c.cntcod'.chr(9).'IN'.chr(9).chr(9).$lv_cntcodlst.chr(9).chr(9),
        'vewmaxrec' => 9999
      ), array(), null, false);
      $lp_sqlstm[] = $lo_cntmdl->getsysdata('sqlstm');

      if(is_array($lo_cntrs) && !isset($lo_cntrs['errtyp'])){
        foreach($lo_cntrs as $lv_row){
          $lv_cntcod = trim((string)($lv_row['cntcod']??''));
          if($lv_cntcod!=='' && !isset($lv_ret['cnttxt'][$lv_cntcod])){
            $lv_ret['cnttxt'][$lv_cntcod] = $lv_row['cnttxt']??'';
          }
        }
      }

      $lo_adrmdl = $this->co_reg->load->model('grldatadr');
      $lo_adrrs = $lo_adrmdl->getList(array(
        'vewfldflt' => '[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                       '[~fltrow~]a.adrsrctyp'.chr(9).'='.chr(9).chr(9).'GRL_CCT'.chr(9).chr(9).
                       '[~fltrow~]a.adrsrccod'.chr(9).'IN'.chr(9).chr(9).$lv_cntcodlst.chr(9).chr(9),
        'vewfldord' => 'a.ctedte desc',
        'vewmaxrec' => 9999
      ));
      $lp_sqlstm[] = $lo_adrmdl->getsysdata('sqlstm');

      if(is_array($lo_adrrs) && !isset($lo_adrrs['errtyp'])){
        foreach($lo_adrrs as $lv_row){
          $lv_cntcod = trim((string)($lv_row['adrsrccod']??''));
          if($lv_cntcod!=='' && !isset($lv_ret['cntadr'][$lv_cntcod])){
            $lv_ret['cntadr'][$lv_cntcod] = $lv_row;
          }
        }
      }
    }

    foreach($lv_objids as $lv_objtyp=>$lv_cods){
      $lo_adrmdl = $this->co_reg->load->model('grldatadr');
      $lo_adrrs = $lo_adrmdl->getList(array(
        'vewfldflt' => '[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                       '[~fltrow~]a.adrsrctyp'.chr(9).'='.chr(9).chr(9).$lv_objtyp.chr(9).chr(9).
                       '[~fltrow~]a.adrsrccod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), array_keys($lv_cods)).chr(9).chr(9),
        'vewfldord' => 'a.ctedte desc',
        'vewmaxrec' => 9999
      ));
      $lp_sqlstm[] = $lo_adrmdl->getsysdata('sqlstm');

      if(!is_array($lo_adrrs) || isset($lo_adrrs['errtyp'])){ continue; }
      foreach($lo_adrrs as $lv_row){
        $lv_objcod = trim((string)($lv_row['adrsrccod']??''));
        $lv_key = $lv_objtyp.'|'.$lv_objcod;
        if($lv_objcod!=='' && !isset($lv_ret['objadr'][$lv_key])){
          $lv_ret['objadr'][$lv_key] = $lv_row;
        }
      }
    }

    return $lv_ret;
  }

  /** Arma una direccion legible sin separadores vacios. */
  private function formatTraDlvAddress($lp_adr) {
    if(!is_array($lp_adr) || count($lp_adr)===0){ return ''; }

    $lv_ret = array();
    $lv_street = trim((string)($lp_adr['adrstr']??($lp_adr['adrstrnme']??'')));
    if($lv_street!==''){ $lv_ret[] = $lv_street; }
    if(trim((string)($lp_adr['adrstrnum']??''))!==''){
      $lv_ret[] = 'Nro. '.trim((string)$lp_adr['adrstrnum']);
    }
    if(trim((string)($lp_adr['adrstrflr']??''))!==''){
      $lv_ret[] = 'Piso '.trim((string)$lp_adr['adrstrflr']);
    }
    if(trim((string)($lp_adr['adrstrunt']??''))!==''){
      $lv_ret[] = 'Dto. '.trim((string)$lp_adr['adrstrunt']);
    }
    if(trim((string)($lp_adr['adrtwntxt']??''))!==''){
      $lv_ret[] = trim((string)$lp_adr['adrtwntxt']);
    }
    if(trim((string)($lp_adr['adrcty']??''))!==''){
      $lv_ret[] = trim((string)$lp_adr['adrcty']);
    }

    return implode(', ', $lv_ret);
  }

  /** Devuelve el comentario solamente cuando la entrega fue informada como fallida. */
  private function getTraDlvFailureComment($lp_cnftyp, $lp_cnfcmt) {
    $lv_cnftyp = strtoupper(trim((string)$lp_cnftyp));
    return in_array($lv_cnftyp, array('NO', 'N', 'NO ENTREGADO'), true) ? ($lp_cnfcmt??'') : '';
  }

	
	
  // INDEX. metodo principal de la clase
  public function index( $lp_act , $lp_prm = array() ) {


    // all methods of this class are available for logged users check user session
		/*
		if ( $lp_act!='C1' && $lp_act!='C2' && $lp_act!='sndmlmatequ') {
			$this->co_reg->request->post['ajax']='1';
			$lv_lgnbuf = $this->co_reg->user->checkUserLogin();
			if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }
		}  
		*/

		// load model
		// $this->lo_mdl = $this->co_reg->load->model( self::MODEL );

		$this->data['actcod'] = $lp_act;
		// $lv_isShop = stripos(DIR_APPLICATION,'/tmssShop/');
		// $lv_dir =$lv_isShop!== false?'':'..\..\tmssOnLine\\';
		$lv_dir='';
		//$lo_mdlmovdocmat = $this->co_reg->load->model( 'stkmovdocmat',$lv_dir);

		$lp_act = '#' . $lp_act;
    switch( $lp_act ) {

			// D A S H B O A R D
      case '#': case '#08': case '#02':case '#dsh':
      	$lo_ordmdl = $this->co_reg->load->model('slsord');
      	$lo_movdocmdl = $this->co_reg->load->model('stkmovdoc');

				$lo_data = array();
				$lv_prm = array();

        $lo_vew = $this->co_reg->load->model('grlvew',$lv_dir);
				$lv_dtefrm = new DateTime();
				$lv_dteto = new DateTime();
				$lv_dtefrm->modify('first day of january');
				$lv_dteto->modify('last day of december');

				/* 1.1 - Busco las clases de documento de pedidos */
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).'='.chr(9).chr(9).'SLS_ORD'.chr(9).chr(9) .
																			'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_rscls = $lo_docclsmdl->getList($lv_prm);

				$lv_clsflt='';
				foreach ($lo_rscls as $lv_row) {
					$lv_clsflt .= ($lv_clsflt==''?'':chr(10)).$lv_row['sysdocclscod'];
				}


				/* 1.2- busco los pedidos del año en curso */
				$lv_prm = array('vewfldflt' =>'[~fltrow~]o.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).$lv_clsflt.chr(9).chr(9).
																			'[~fltrow~]slsorddte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9));
				$lo_rsord = $lo_ordmdl->getlist($lv_prm, null, null, false);
				/*Pedidos por mes*/
				$lo_arrmth= array('01'=>'Enero','02'=>'Febrero','03'=>'Marzo','04'=>'Abril','05'=>'Mayo','06'=>'Junio','07'=>'Julio','08'=>'Agosto','09'=>'Septiembre','10'=>'Octubre','11'=>'Noviembre','12'=>'Diciembre');
				$lo_ret= array();
				$lo_ret['Acumulado'] = array('Enero'=>0,'Febrero'=>0,'Marzo'=>0,'Abril'=>0,'Mayo'=>0,'Junio'=>0,'Julio'=>0,'Agosto'=>0,'Septiembre'=>0,'Octubre'=>0,'Noviembre'=>0,'Diciembre'=>0,);
				$lo_data['pedmth']['acumulado']=array();
				foreach ($lo_rsord as $lv_row_ord) {
					if(!isset($lo_ret[ $lv_row_ord['sysdocclstxt']])){
						$lo_ret[$lv_row_ord['sysdocclstxt']] = array('Enero'=>0,'Febrero'=>0,'Marzo'=>0,'Abril'=>0,'Mayo'=>0,'Mayo'=>0,'Junio'=>0,'Julio'=>0,'Agosto'=>0,'Septiembre'=>0,'Octubre'=>0,'Noviembre'=>0,'Diciembre'=>0,);
					}
					$lo_ret[$lv_row_ord['sysdocclstxt']][$lo_arrmth[$lv_row_ord['slsorddte']->format('m')]]+=1;
					$lo_ret['Acumulado'][$lo_arrmth[$lv_row_ord['slsorddte']->format('m')]]+=1;

				}
				$lo_data['pedmth'] =$lo_ret;
				$lo_data['pedqty'] =count($lo_rsord);

				/*2 - Compras y Ventas por mes */

				/*2.1 - Busco las clases de documento de Compras(CPA) y Ventas (VTA)*/
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]d.sysdocclscodext'.chr(9).'IN'.chr(9).chr(9).'VTA'.chr(10).'CPA'.chr(9).chr(9).
																			'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_rscls = $lo_docclsmdl->getList($lv_prm);

				$lv_clsarr=array();
				foreach ($lo_rscls as $lv_row) {
					$lv_clsarr[$lv_row['sysdocclscodext']]=$lv_row['sysdocclscod'];
				}
				
				/*2.2 - busco los pedidos del año en curso*/
				$lv_prm = array('vewfldflt' =>'[~fltrow~]d.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).($lv_clsarr['VTA']??'').chr(10).($lv_clsarr['CPA']??'').chr(9).chr(9).
																			'[~fltrow~]stkmovdocdte'.chr(9).'BT'.chr(9).chr(9).$lv_dtefrm->format('Ymd').chr(9).$lv_dteto->format('Ymd').chr(9));
				$lo_rsmov = $lo_movdocmdl->getlist($lv_prm, null, null, false);
				
				$lo_ret= array();
				foreach ($lo_rsmov as $lv_row_mov) {
					if(!isset($lo_ret[ $lv_row_mov['sysdocclstxt']])){
						$lo_ret[$lv_row_mov['sysdocclstxt']] = array('01'=>0,'02'=>0,'03'=>0,'04'=>0,'05'=>0,'06'=>0,'07'=>0,'08'=>0,'09'=>0,'10'=>0,'11'=>0,'12'=>0,);
					}
					$lo_ret[$lv_row_mov['sysdocclstxt']][$lv_row_mov['stkmovdocdte']->format('m')]+=1;

				}
				$lo_data['movmth'] =$lo_ret;
        // determino destinatarios
        // obtengo texto del mensaje
				$lo_txtmdl = $this->co_reg->load->model('sysappmdlprm');
				$lo_txtmdl->load(array('mdlcod'=>'UPDCSTMAT'));
        $lv_mailto = array();
				$lv_permatcstperarr = explode(',',strtoupper($this->co_reg->document->gettagvalue($lo_txtmdl->mdlatrval001,'updcstmatusr')));
        $lo_data['matcstupdper']=in_array(strtoupper($this->co_reg->sec->usrcod),$lv_permatcstperarr);
        

				return $this->co_reg->document->getView('zcutp1_lgndsh', array('data'=>$lo_data,'model' => '','actcod'=>$this->data['actcod']));
        break;
        
			// ---------------------------------------------------------------------
			//
			// R E P O R T E S
			//
			// ---------------------------------------------------------------------
      // REPORTE LIQUIDACION DE INSUMOS 
      case '#slsslslqdrpt':

          $lv_lmtmem = ini_get('memory_limit');
          ini_set('memory_limit', '2048M'); 

          $lo_lqdmdl = $this->co_reg->load->model('slsslslqd');
          $lo_clsmdl = $this->co_reg->load->model('sysdoccls'); 
          $lo_post   = $this->co_reg->request->post;

          $lv_vewfldflt = (isset($lo_post['vewfldflt']) ? $lo_post['vewfldflt'] : '');
          $lv_vewmaxrec = (isset($lo_post['vewmaxrec']) ? $lo_post['vewmaxrec'] : '');
          $lv_vewfldord = (isset($lo_post['vewfldord']) ? $lo_post['vewfldord'] : 'l.slsslslqddte desc');

          /* PREPARAMOS LOS FILTROS DE CABECERA Y DETALLE */
          $lv_fltdet = array(); 
          $lv_fltarr = explode('[~fltrow~]', $lv_vewfldflt);

          for ($i = count($lv_fltarr) - 1; $i > 0; $i--) {
              $lv_fld = explode(chr(9), $lv_fltarr[$i])[0];
              $lv_val = isset(explode(chr(9), $lv_fltarr[$i])[2]) ? str_replace('%', '', strtoupper(trim(explode(chr(9), $lv_fltarr[$i])[2]))) : '';

             // 1. CAPTURAMOS LOS FILTROS DEL DETALLE
              if ($lv_fld === 'stkcnttxt' || $lv_fld === 'refobjtyptxt') {
                  $lv_fltdet[$lv_fld] = $lv_val;
                  unset($lv_fltarr[$i]); 
              } 
              // 2. LISTA DE CABECERA 
              else if (stripos(';slsslslqdcod;slsslslqddtecnv;custxt;cuscod;docsts;', ';' . $lv_fld . ';') === false) {
                  unset($lv_fltarr[$i]);
              } 
              // 3. REEMPLAZOS DE CABECERA
              else {
                  $lv_fltarr[$i] = str_replace('slsslslqdcod', 'l.slsslslqdcod', $lv_fltarr[$i]);
                  // Convertimos la columna para que coincida con el formato del calendario
                  $lv_fltarr[$i] = str_replace('slsslslqddtecnv', 'CONVERT(VARCHAR, l.slsslslqddte, 23)', $lv_fltarr[$i]);    
                  $lv_fltarr[$i] = str_replace('custxt',       'l.custxt',       $lv_fltarr[$i]);
                  $lv_fltarr[$i] = str_replace('cuscod',       'l.cuscod',       $lv_fltarr[$i]);
                  $lv_fltarr[$i] = str_replace('docsts',       'l.docsts',       $lv_fltarr[$i]);
              }
          }

          $lv_prm = array(
              'vewfldflt' => (count($lv_fltarr) > 0 ? '[~fltrow~]' . implode('[~fltrow~]', $lv_fltarr) : ''),
              'vewfldord' => $lv_vewfldord,
              'vewmaxrec' => $lv_vewmaxrec
          );

          $lo_rslqd = $lo_lqdmdl->getList($lv_prm, null, null, false);
          $lv_sqlstm = $lo_lqdmdl->getsysdata('sqlstm');

          $lv_ret = array();
          $lv_refclscch = array(); 

          foreach ($lo_rslqd as $lv_row) {

              $lv_row['slsslslqddtecnv'] = $lv_row['slsslslqddte'];
              unset($lv_row['slsslslqddte'], $lv_row['ctedte'], $lv_row['upddte'], $lv_row['accdte']);

              $lv_strdte = '';
              $lv_enddte = '';
              if (strpos($lv_row['slsslslqdatr001'], '<strdte>') !== false) {
                  $lv_strdte = explode('</strdte>', explode('<strdte>', $lv_row['slsslslqdatr001'])[1])[0];
              }
              if (strpos($lv_row['slsslslqdatr001'], '<enddte>') !== false) {
                  $lv_enddte = explode('</enddte>', explode('<enddte>', $lv_row['slsslslqdatr001'])[1])[0];
              }

              $lv_row['slsslslqdstrdte'] = $lv_strdte;
              $lv_row['slsslslqdenddte'] = $lv_enddte;

              $lv_clscod = $lv_row['sysdocclscod'];
              if (!isset($lv_refclscch[$lv_clscod])) {
                  $lv_clsprm = array('vewfldflt' => '[~fltrow~]sysdocclscod'.chr(9).'='.chr(9).chr(9).$lv_clscod.chr(9).chr(9));
                  $lv_clsdta = $lo_clsmdl->getList($lv_clsprm);
                  $lv_ref = '';
                  if (!empty($lv_clsdta) && isset($lv_clsdta[0]['sysdocclsatr'])) {
                      $lv_atr = $lv_clsdta[0]['sysdocclsatr'];
                      if (strpos($lv_atr, '<refdoccls>') !== false) {
                          $lv_ref = explode('</refdoccls>', explode('<refdoccls>', $lv_atr)[1])[0];
                      }
                  }
                  $lv_refclscch[$lv_clscod] = $lv_ref;
              }

              $lv_srvprm = array(
                  'slsslslqdcod'    => $lv_row['slsslslqdcod'],
                  'cuscod'          => $lv_row['cuscod'],
                  'slsslslqdstrdte' => $lv_strdte,
                  'slsslslqdenddte' => $lv_enddte,
                  'sysdocclscod'    => $lv_clscod,
                  'refdoccls'       => $lv_refclscch[$lv_clscod] 
              );

              $lv_srvlst = $lo_lqdmdl->getOpenServices([], $lv_srvprm);
              $lv_hasitm = false;

              if (!empty($lv_srvlst)) {
                  foreach ($lv_srvlst as $lv_itmrow) {

                      if (($lv_itmrow['slsslslqddoccod'] ?? 0) > 0) {

                          $lv_pasflt = true;
                          if (isset($lv_fltdet['stkcnttxt']) && strpos(strtoupper($lv_itmrow['stkcnttxt'] ?? ''), $lv_fltdet['stkcnttxt']) === false) {
                              $lv_pasflt = false;
                          }
                          if (isset($lv_fltdet['refobjtyptxt']) && strpos(strtoupper($lv_itmrow['refobjtyptxt'] ?? ''), $lv_fltdet['refobjtyptxt']) === false) {
                              $lv_pasflt = false;
                          }

                          if ($lv_pasflt) {
                              $lv_hasitm = true;
                              unset($lv_itmrow['ctedte'], $lv_itmrow['upddte']); 

                              $lv_qty  = (float)($lv_itmrow['slsslslqddocqtysaved'] ?? $lv_itmrow['matqty']);
                              $lv_prc  = (float)($lv_itmrow['untmatprc'] ?? 0);
                              $lv_sgn = (($lv_itmrow['refobjtyp'] ?? '') === 'STK_SIN') ? -1 : 1;

                              $lv_itmrow['matqty']          = $lv_qty;
                              $lv_itmrow['slsslslqddocprc'] = $lv_prc;
                              $lv_itmrow['slsslslqddoctot'] = $lv_sgn * $lv_prc * $lv_qty;

                              // LÓGICA DE ASIGNACIÓN
                              $lv_ext = trim((string)($lv_itmrow['movcodext'] ?? ''));
                              $lv_movval = trim((string)($lv_itmrow['movcod'] ?? '')); 

                              $lv_itmrow['stkmovdoccod'] = $lv_movval; 
                              $lv_itmrow['movcod']       = ($lv_ext !== '') ? $lv_ext : $lv_movval; 

                              array_push($lv_ret, array_merge($lv_row, $lv_itmrow));
                          }
                      }
                  }
              } 

              if (!$lv_hasitm && empty($lv_fltdet)) {
                  $lv_row['matqty']          = 0.0;
                  $lv_row['slsslslqddocprc'] = 0.0;
                  $lv_row['slsslslqddoctot'] = 0.0;
                  $lv_row['stkmovdoccod']    = '';
                  $lv_row['movcod']          = ''; 
                  array_push($lv_ret, $lv_row);
              }
          }

          if (count($lv_ret) > 0) {
              $lv_ret[0]['sqlstm'] = [$lv_sqlstm];
          }

          ini_set('memory_limit', $lv_lmtmem);
          return $lv_ret;
        break;

      // REPORTE LOGISTICO DE LIQUIDACION DE INSUMOS
      // Actividad independiente de slsslslqdrpt para no alterar el reporte existente.
      case '#slsslslqdlogrpt':
        $lv_lmtmem = ini_get('memory_limit');
        ini_set('memory_limit', '2048M');

        $lo_lqdmdl    = $this->co_reg->load->model('slsslslqd');
        $lo_clsmdl    = $this->co_reg->load->model('sysdoccls');
        $lo_movmatmdl = $this->co_reg->load->model('stkmovdocmat');
        $lo_cntmdl    = $this->co_reg->load->model('grldatcnt');
        $lo_permdl    = $this->co_reg->load->model('grldatper');
        $lo_post      = $this->co_reg->request->post;

        $lv_vewfldflt = $lo_post['vewfldflt'] ?? '';
        // grlvew suma 1 al maximo recibido. Nunca enviar una cadena vacia
        // porque en PHP 8 produce "Unsupported operand types: string + int".
        $lv_vewmaxrec = (isset($lo_post['vewmaxrec']) && is_numeric($lo_post['vewmaxrec']))
          ? (int)$lo_post['vewmaxrec']
          : 100;
        $lv_vewfldord = $lo_post['vewfldord'] ?? 'l.slsslslqddte desc';
        $lv_sqlstm    = array();

        /*
         * Los filtros de cabecera se envian al getList de liquidaciones.
         * Los demas se aplican despues de completar movimiento, contacto y obra social.
         */
        $lv_hdrflt = array();
        $lv_detflt = array();
        $lv_hdrmap = array(
          'slsslslqdcod' => 'l.slsslslqdcod',
          'custxt'       => 'l.custxt'
        );
        $lv_detfld = array(
          'movcodext',
          'slsordcod',
          'stkmovdoccnfdtecnv',
          'refobjtyptxt',
          'stkcnttxt',
          'stkcntcodext',
          'mattxt',
          'hhrmedcovtxt',
          'slsslslqdstrdte',
          'slsslslqdenddte',
          'slsslslqdperiodo'
        );

        foreach (explode('[~fltrow~]', $lv_vewfldflt) as $lv_fltrow) {
          if ($lv_fltrow === '') { continue; }
          $lv_fltdat = explode(chr(9), $lv_fltrow);
          if (count($lv_fltdat) !== 6) { continue; }

          $lv_fld = trim($lv_fltdat[0]);
          if (isset($lv_hdrmap[$lv_fld])) {
            $lv_fltdat[0] = $lv_hdrmap[$lv_fld];
            $lv_hdrflt[] = implode(chr(9), $lv_fltdat);
          } else if (in_array($lv_fld, $lv_detfld, true)) {
            $lv_detflt[] = $lv_fltdat;
          }
        }

        // Si hay filtros de detalle no se limita la cabecera antes de evaluarlos,
        // porque una liquidacion valida podria quedar fuera del primer bloque.
        $lv_hdrmaxrec = (count($lv_detflt) === 0 ? $lv_vewmaxrec : null);
        $lv_lqdprm = array(
          'vewfldflt' => (count($lv_hdrflt) > 0 ? '[~fltrow~]'.implode('[~fltrow~]', $lv_hdrflt) : ''),
          'vewfldord' => $lv_vewfldord
        );
        // Omitir la clave por completo cuando deben evaluarse filtros de detalle;
        // una cadena vacia si activaria el isset del core y volveria a causar el error.
        if ($lv_hdrmaxrec !== null) { $lv_lqdprm['vewmaxrec'] = $lv_hdrmaxrec; }
        $lo_rslqd = $lo_lqdmdl->getList($lv_lqdprm, null, null, false);
        $lv_sqlstm[] = $lo_lqdmdl->getsysdata('sqlstm');

        if (!is_array($lo_rslqd) || isset($lo_rslqd['errtyp'])) {
          ini_set('memory_limit', $lv_lmtmem);
          return array();
        }

        $lv_rows = array();
        $lv_refclscch = array();

        foreach ($lo_rslqd as $lv_lqdrow) {
          $lv_clscod = $lv_lqdrow['sysdocclscod'] ?? '';
          if (!isset($lv_refclscch[$lv_clscod])) {
            $lv_ref = '';
            if ($lv_clscod !== '') {
              $lv_clsprm = array(
                'vewfldflt' => '[~fltrow~]sysdocclscod'.chr(9).'='.chr(9).chr(9).$lv_clscod.chr(9).chr(9)
              );
              $lv_clsdta = $lo_clsmdl->getList($lv_clsprm);
              if (is_array($lv_clsdta) && !empty($lv_clsdta[0]['sysdocclsatr'])) {
                $lv_ref = $this->co_reg->document->getTagValue($lv_clsdta[0]['sysdocclsatr'], 'refdoccls');
              }
            }
            $lv_refclscch[$lv_clscod] = $lv_ref;
          }

          $lv_lqdatr = $lv_lqdrow['slsslslqdatr001'] ?? '';
          $lv_strdte = $this->co_reg->document->getTagValue($lv_lqdatr, 'strdte');
          $lv_enddte = $this->co_reg->document->getTagValue($lv_lqdatr, 'enddte');
          $lv_srvprm = array(
            'slsslslqdcod'    => $lv_lqdrow['slsslslqdcod'] ?? '',
            'cuscod'          => $lv_lqdrow['cuscod'] ?? '',
            'slsslslqdstrdte' => $lv_strdte,
            'slsslslqdenddte' => $lv_enddte,
            'sysdocclscod'    => $lv_clscod,
            'refdoccls'       => $lv_refclscch[$lv_clscod]
          );
          $lv_srvlst = $lo_lqdmdl->getOpenServices(array(), $lv_srvprm);

          if (!is_array($lv_srvlst) || isset($lv_srvlst['errtyp'])) { continue; }

          foreach ($lv_srvlst as $lv_itmrow) {
            // Solo se informan articulos efectivamente asignados a la liquidacion.
            if ((int)($lv_itmrow['slsslslqddoccod'] ?? 0) <= 0) { continue; }

            $lv_qtysaved = (float)($lv_itmrow['slsslslqddocqtysaved'] ?? 0);
            $lv_qty = ($lv_qtysaved > 0 ? $lv_qtysaved : (float)($lv_itmrow['matqty'] ?? 0));
            $lv_prc = (float)($lv_itmrow['untmatprc'] ?? ($lv_itmrow['slsslslqddocprc'] ?? 0));
            $lv_origamt = (float)($lv_itmrow['matprctot'] ?? 0);
            $lv_sign = ($lv_origamt < 0 || ($lv_itmrow['refobjtyp'] ?? '') === 'STK_SIN') ? -1 : 1;
            $lv_movcod = $lv_itmrow['stkmovdoccod'] ?? ($lv_itmrow['movcod'] ?? '');

            $lv_rows[] = array(
              'slsslslqdcod'        => $lv_lqdrow['slsslslqdcod'] ?? '',
              'slsslslqdstrdte'     => $lv_strdte,
              'slsslslqdenddte'     => $lv_enddte,
              'slsslslqdperiodo'    => trim($lv_strdte.' - '.$lv_enddte, ' -'),
              'stkmovdoccod'        => $lv_movcod,
              'movcodext'           => $lv_itmrow['movcodext'] ?? ($lv_itmrow['stkmovdoccodext'] ?? ''),
              'slsordcod'           => $lv_itmrow['slsordcod'] ?? ($lv_itmrow['docrefcod'] ?? ''),
              'stkmovdocdtecnv'     => $lv_itmrow['refdte'] ?? ($lv_itmrow['stkmovdocdtecnv'] ?? ''),
              'stkmovdoccnfdtecnv'  => $lv_itmrow['stkmovdoccnfdtecnv'] ?? ($lv_itmrow['stkmovdoccnfdte'] ?? ''),
              'stkmovdoccnftyp'     => $lv_itmrow['stkmovdoccnftyp'] ?? '',
              'refobjtyptxt'        => $lv_itmrow['refobjtyptxt'] ?? '',
              'cuscod'              => $lv_lqdrow['cuscod'] ?? '',
              'custxt'              => $lv_lqdrow['custxt'] ?? '',
              'stkcntcod'           => $lv_itmrow['stkcntcod'] ?? '',
              'stkcnttxt'           => $lv_itmrow['stkcnttxt'] ?? '',
              'stkcntcodext'        => $lv_itmrow['stkcntcodext'] ?? ($lv_itmrow['dstcntcodext'] ?? ''),
              'matdocclstxt'        => $lv_itmrow['matdocclstxt'] ?? '',
              'matcod'              => $lv_itmrow['matcod'] ?? '',
              'matcodext'           => $lv_itmrow['matcodext'] ?? '',
              'mattxt'              => $lv_itmrow['mattxt'] ?? '',
              'matbchcodext'        => $lv_itmrow['matbchcodext'] ?? '',
              'matbchduedtecnv'     => $lv_itmrow['matbchduedtecnv'] ?? '',
              'matqty'              => $lv_qty,
              'matuntcod'           => $lv_itmrow['matuntcod'] ?? '',
              'matcst'              => (float)($lv_itmrow['matcst'] ?? 0),
              'slsslslqddocprc'     => $lv_prc,
              'slsslslqddoctot'     => $lv_sign * $lv_prc * $lv_qty,
              'hhrmedcovtxt'        => '',
              'stkmovdocmatcod'     => $lv_itmrow['stkmovdocmatcod'] ?? ''
            );
          }
        }

        /* Completa datos de movimiento en bloques: pedido, confirmacion, clase,
         * codigo de material, lote y vencimiento. */
        $lv_movmatids = array();
        foreach ($lv_rows as $lv_row) {
          $lv_id = trim((string)($lv_row['stkmovdocmatcod'] ?? ''));
          if ($lv_id !== '') { $lv_movmatids[$lv_id] = true; }
        }

        $lv_movmatidx = array();
        foreach (array_chunk(array_keys($lv_movmatids), 400) as $lv_idchunk) {
          $lv_movprm = array(
            'vewfldflt' => '[~fltrow~]dm.stkmovdocmatcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lv_idchunk).chr(9).chr(9),
            'vewmaxrec' => count($lv_idchunk) + 10
          );
          $lv_movrs = $lo_movmatmdl->getList($lv_movprm);
          if (!is_array($lv_movrs) || isset($lv_movrs['errtyp'])) { continue; }
          foreach ($lv_movrs as $lv_movrow) {
            $lv_id = trim((string)($lv_movrow['stkmovdocmatcod'] ?? ''));
            if ($lv_id !== '' && !isset($lv_movmatidx[$lv_id])) {
              $lv_movmatidx[$lv_id] = $lv_movrow;
            }
          }
        }

        foreach ($lv_rows as &$lv_row) {
          $lv_id = trim((string)($lv_row['stkmovdocmatcod'] ?? ''));
          if ($lv_id === '' || !isset($lv_movmatidx[$lv_id])) { continue; }
          $lv_movrow = $lv_movmatidx[$lv_id];
          $lv_row['stkmovdoccod']       = $lv_movrow['stkmovdoccod'] ?? $lv_row['stkmovdoccod'];
          $lv_row['movcodext']          = $lv_movrow['stkmovdoccodext'] ?? $lv_row['movcodext'];
          $lv_row['slsordcod']          = $lv_movrow['docrefcod'] ?? $lv_row['slsordcod'];
          $lv_row['stkmovdocdtecnv']    = $lv_movrow['stkmovdocdtecnv'] ?? $lv_row['stkmovdocdtecnv'];
          $lv_row['stkmovdoccnfdtecnv'] = $lv_movrow['stkmovdoccnfdte'] ?? $lv_row['stkmovdoccnfdtecnv'];
          $lv_row['stkmovdoccnftyp']    = $lv_movrow['stkmovdoccnftyp'] ?? $lv_row['stkmovdoccnftyp'];
          $lv_row['stkcntcodext']       = $lv_movrow['dstcntcodext'] ?? $lv_row['stkcntcodext'];
          $lv_row['matdocclstxt']       = $lv_movrow['matdocclstxt'] ?? $lv_row['matdocclstxt'];
          $lv_row['matcod']             = $lv_movrow['matcod'] ?? $lv_row['matcod'];
          $lv_row['matcodext']          = $lv_movrow['matcodext'] ?? $lv_row['matcodext'];
          $lv_row['mattxt']             = $lv_movrow['mattxt'] ?? $lv_row['mattxt'];
          $lv_row['matbchcodext']       = $lv_movrow['matbchcodext'] ?? $lv_row['matbchcodext'];
          $lv_row['matbchduedtecnv']    = $lv_movrow['matbchduedtecnv'] ?? $lv_row['matbchduedtecnv'];
          $lv_row['matuntcod']          = $lv_movrow['matuntcod'] ?? $lv_row['matuntcod'];
          $lv_row['matcst']             = (float)($lv_movrow['matcst'] ?? $lv_row['matcst']);
        }
        unset($lv_row);

        // Completa codigo externo y obra social de cada contacto.
        $lv_cntids = array();
        foreach ($lv_rows as $lv_row) {
          $lv_cntcod = trim((string)($lv_row['stkcntcod'] ?? ''));
          if ($lv_cntcod !== '') { $lv_cntids[$lv_cntcod] = true; }
        }

        $lv_cntidx = array();
        $lv_peridx = array();
        foreach (array_chunk(array_keys($lv_cntids), 400) as $lv_cntchunk) {
          $lv_cntprm = array(
            'vewfldflt' => '[~fltrow~]c.cntcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lv_cntchunk).chr(9).chr(9),
            'vewmaxrec' => count($lv_cntchunk) + 10
          );
          $lv_cntrs = $lo_cntmdl->getList($lv_cntprm, array(), null, false);
          if (is_array($lv_cntrs) && !isset($lv_cntrs['errtyp'])) {
            foreach ($lv_cntrs as $lv_cntrow) {
              $lv_cntcod = trim((string)($lv_cntrow['cntcod'] ?? ''));
              if ($lv_cntcod !== '' && !isset($lv_cntidx[$lv_cntcod])) {
                $lv_cntidx[$lv_cntcod] = $lv_cntrow;
              }
            }
          }

          $lv_perprm = array(
            'vewfldflt' => '[~fltrow~]p.persrctyp'.chr(9).'='.chr(9).chr(9).'GRL_CCT'.chr(9).chr(9).
                           '[~fltrow~]p.persrccod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lv_cntchunk).chr(9).chr(9),
            'vewmaxrec' => count($lv_cntchunk) + 10
          );
          $lv_perrs = $lo_permdl->getList($lv_perprm);
          if (is_array($lv_perrs) && !isset($lv_perrs['errtyp'])) {
            foreach ($lv_perrs as $lv_perrow) {
              $lv_cntcod = trim((string)($lv_perrow['persrccod'] ?? ''));
              if ($lv_cntcod !== '' && !isset($lv_peridx[$lv_cntcod])) {
                $lv_peridx[$lv_cntcod] = $lv_perrow;
              }
            }
          }
        }

        foreach ($lv_rows as &$lv_row) {
          $lv_cntcod = trim((string)($lv_row['stkcntcod'] ?? ''));
          if (isset($lv_cntidx[$lv_cntcod])) {
            $lv_row['stkcntcodext'] = $lv_cntidx[$lv_cntcod]['cntcodext'] ?? $lv_row['stkcntcodext'];
          }
          if (isset($lv_peridx[$lv_cntcod])) {
            $lv_row['hhrmedcovtxt'] = $lv_peridx[$lv_cntcod]['hhrmedcovtxt'] ?? '';
          }
        }
        unset($lv_row);

        // Normaliza fechas para comparar filtros de calendario aunque la fuente use dd/mm/yyyy.
        $lv_normdte = function($lp_val) {
          $lv_val = trim((string)$lp_val);
          if ($lv_val === '') { return ''; }
          foreach (array('Y-m-d', 'd/m/Y', 'Ymd', 'Y-m-d H:i:s', 'd/m/Y H:i:s') as $lv_fmt) {
            $lv_dte = DateTime::createFromFormat($lv_fmt, $lv_val);
            if ($lv_dte !== false) { return $lv_dte->format('Y-m-d'); }
          }
          return $lv_val;
        };

        $lv_matchflt = function($lp_val, $lp_flt) use ($lv_normdte) {
          $lv_opr = strtoupper(trim((string)($lp_flt[1] ?? '')));
          $lv_like = trim((string)($lp_flt[2] ?? ''));
          $lv_str = trim((string)($lp_flt[3] ?? ''));
          $lv_end = trim((string)($lp_flt[4] ?? ''));
          $lv_val = trim((string)$lp_val);
          $lv_valcmp = strtoupper($lv_val);

          if ($lv_opr === '' || $lv_opr === 'LIKE') {
            return strpos($lv_valcmp, strtoupper($lv_like)) !== false;
          }
          if ($lv_opr === 'EE') { return $lv_val === ''; }
          if ($lv_opr === 'NE') { return $lv_val !== ''; }
          if ($lv_opr === 'SW') { return strpos($lv_valcmp, strtoupper($lv_str)) === 0; }
          if ($lv_opr === 'EW') {
            $lv_find = strtoupper($lv_str);
            return $lv_find === '' || substr($lv_valcmp, -strlen($lv_find)) === $lv_find;
          }
          if ($lv_opr === 'IN' || $lv_opr === 'NI') {
            $lv_lst = preg_split('/\r\n|\r|\n/', strtoupper($lv_str));
            $lv_in = in_array($lv_valcmp, $lv_lst, true);
            return ($lv_opr === 'IN' ? $lv_in : !$lv_in);
          }

          $lv_valdte = $lv_normdte($lv_val);
          $lv_strdte = $lv_normdte($lv_str);
          $lv_enddte = $lv_normdte($lv_end);
          if ($lv_valdte !== '' && preg_match('/^\d{4}-\d{2}-\d{2}$/', $lv_valdte)) {
            $lv_valcmp = $lv_valdte;
            $lv_str = $lv_strdte;
            $lv_end = $lv_enddte;
          } else if (is_numeric($lv_val) && is_numeric($lv_str)) {
            $lv_valcmp = (float)$lv_val;
            $lv_str = (float)$lv_str;
            $lv_end = (float)$lv_end;
          } else {
            $lv_str = strtoupper($lv_str);
            $lv_end = strtoupper($lv_end);
          }

          if ($lv_opr === 'BT') { return $lv_valcmp >= $lv_str && $lv_valcmp <= $lv_end; }
          if ($lv_opr === 'NB') { return !($lv_valcmp >= $lv_str && $lv_valcmp <= $lv_end); }
          if ($lv_opr === 'GT') { return $lv_valcmp > $lv_str; }
          if ($lv_opr === 'GE') { return $lv_valcmp >= $lv_str; }
          if ($lv_opr === 'LT') { return $lv_valcmp < $lv_str; }
          if ($lv_opr === 'LE') { return $lv_valcmp <= $lv_str; }
          if ($lv_opr === 'NS' || $lv_opr === '<>') { return $lv_valcmp != $lv_str; }
          return $lv_valcmp == $lv_str;
        };

        // El filtro virtual de periodo trabaja contra ambas puntas de la liquidacion.
        // Para un rango se consideran las liquidaciones cuyo periodo se superpone.
        $lv_matchperiod = function($lp_strdte, $lp_enddte, $lp_flt) use ($lv_normdte) {
          $lv_rowstr = $lv_normdte($lp_strdte);
          $lv_rowend = $lv_normdte($lp_enddte);
          if ($lv_rowstr === '' || $lv_rowend === '') { return false; }

          $lv_opr = strtoupper(trim((string)($lp_flt[1] ?? '')));
          $lv_fltstr = trim((string)($lp_flt[3] ?? ''));
          $lv_fltend = trim((string)($lp_flt[4] ?? ''));
          if ($lv_fltstr === '') { $lv_fltstr = trim((string)($lp_flt[2] ?? '')); }
          $lv_fltstr = $lv_normdte($lv_fltstr);
          $lv_fltend = $lv_normdte($lv_fltend);

          if ($lv_opr === 'EE') { return false; }
          if ($lv_opr === 'NE') { return true; }
          if ($lv_opr === 'BT' && $lv_fltstr !== '' && $lv_fltend !== '') {
            return $lv_rowstr <= $lv_fltend && $lv_rowend >= $lv_fltstr;
          }
          if ($lv_opr === 'NB' && $lv_fltstr !== '' && $lv_fltend !== '') {
            return !($lv_rowstr <= $lv_fltend && $lv_rowend >= $lv_fltstr);
          }
          if ($lv_fltstr === '') { return true; }

          // Con una sola fecha, devuelve liquidaciones que contienen esa fecha.
          return $lv_rowstr <= $lv_fltstr && $lv_rowend >= $lv_fltstr;
        };

        $lv_ret = array();
        $lv_maxrec = (int)$lv_vewmaxrec;
        foreach ($lv_rows as $lv_row) {
          $lv_pass = true;
          foreach ($lv_detflt as $lv_flt) {
            $lv_fld = $lv_flt[0];
            $lv_ismatch = ($lv_fld === 'slsslslqdperiodo')
              ? $lv_matchperiod($lv_row['slsslslqdstrdte'] ?? '', $lv_row['slsslslqdenddte'] ?? '', $lv_flt)
              : $lv_matchflt($lv_row[$lv_fld] ?? '', $lv_flt);
            if (!$lv_ismatch) {
              $lv_pass = false;
              break;
            }
          }
          if (!$lv_pass) { continue; }

          unset($lv_row['stkmovdocmatcod']);
          $lv_ret[] = $lv_row;
          if ($lv_maxrec > 0 && count($lv_ret) >= $lv_maxrec + 1) { break; }
        }

        if (count($lv_ret) > 0) { $lv_ret[0]['sqlstm'] = $lv_sqlstm; }

        ini_set('memory_limit', $lv_lmtmem);
        return $lv_ret;
        break;

       // LIQUIDACION DE INSUMOS PDF
      case '#slsslslqdpnt':
        // 1. Cabecera de Liquidacion
        $lo_lqdmdl = $this->co_reg->load->model('slsslslqd');
        if( $lo_lqdmdl->load( array( 'slsslslqdcod' => $lp_prm['slsslslqdcod'] ), false ) == false ){
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_lqdmdl->errtyp,'errcod'=>$lo_lqdmdl->errcod,'errtxt'=>$lo_lqdmdl->errtxt) );
        }
        $lv_slsslslqdcod = $lo_lqdmdl->slsslslqdcod;
        
        // 2. Cliente
        $lo_cusmdl = $this->co_reg->load->model('slscus');
        if( $lo_cusmdl->load( array( 'cuscod' => $lo_lqdmdl->cuscod ), false ) == false ){
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_cusmdl->errtyp,'errcod'=>$lo_cusmdl->errcod,'errtxt'=>$lo_cusmdl->errtxt) );
        }
        $lv_slsslslqdcus = $lo_lqdmdl->custxt;

        // 3. Extracción de variables XML
        $lv_strdte = $this->co_reg->document->getTagValue($lo_lqdmdl->slsslslqdatr001, 'strdte');
        $lv_enddte = $this->co_reg->document->getTagValue($lo_lqdmdl->slsslslqdatr001, 'enddte');

        // Cargamos la clase de documento para obtener refdoccls
        $lo_doccls = $this->co_reg->load->model('sysdoccls');
        $lo_doccls->load(array('sysdocclscod' => $lo_lqdmdl->sysdocclscod), false);
        $lv_refdoccls = $this->co_reg->document->getTagValue($lo_doccls->sysdocclsatr, 'refdoccls');

        // 4. Obtener datos cruzados 
        $lv_dat_all = $lo_lqdmdl->getOpenServices([], array(
            'slsslslqdcod'    => $lv_slsslslqdcod,
            'cuscod'          => $lo_lqdmdl->cuscod,
            'slsslslqdstrdte' => $lv_strdte,
            'slsslslqdenddte' => $lv_enddte,
            'sysdocclscod'    => $lo_lqdmdl->sysdocclscod,
            'refdoccls'       => $lv_refdoccls
        ));
        
        // 5. Filtrar solo los asignados a esta liquidación
        $lv_dat = array();
        if (!empty($lv_dat_all)) {
            foreach ($lv_dat_all as $row) {
                if (!empty($row['slsslslqddoccod']) && $row['slsslslqddoccod'] > 0) {
                    $lv_dat[] = $row;
                }
            }
        }
        // 6. Imprimir PDF
        $lv_dte = new Datetime();
        $this->co_reg->response->addHeader('Content-type:application/pdf');
        return $this->co_reg->document->getView( 'zcutp1_lgn_liqslspnt', array(
            'data'            => $lv_dat,
            'dte'             => $lv_dte->format('d/m/Y'),
            'slsslslqdcod'    => $lv_slsslslqdcod,
            'msgqty'          => $lp_prm['msgqty'] ?? '1',
            'cuscod'          => $lo_cusmdl->cuscod,
            'custxt'          => $lv_slsslslqdcus,
            'slsslslqdstrdte' => $lv_strdte,
            'slsslslqdenddte' => $lv_enddte
        ));
        break;
			// T I E M P O S    P E D I D O S
      case '#lgnrptmovtme':
        ini_set('memory_limit', '1000M'); 
        
        // obtiene los parametros
        $lo_post = $this->co_reg->request->post;

        // carga modelos
        $lo_ordmdl = $this->co_reg->load->model( 'slsord' );
        $lo_docflwmdl = $this->co_reg->load->model( 'grldocflwpos' );
				$lo_movmdl = $this->co_reg->load->model( 'stkmovdoc' );
        
        // FILTROS ------------------------------------------------------------
        
        // separa los filtros
        $lv_flt = explode( '[~fltrow~]', $lo_post['vewfldflt'] );

				// crea los parametros para los getList
				$lv_fltped = '';
				$lv_fltmov = '';
				foreach($lv_flt as $lv_row){
					if( strstr($lv_row,'stkmovdoccod') || strstr($lv_row,'stkmovdocdte') || strstr($lv_row,'stkmovdocsts') || strstr($lv_row,'stkmovsysdoctretxt') ){
						if( strstr($lv_row,'stkmovdocsts') ){ $lv_row = str_ireplace('stkmovdocsts','docsts',$lv_row); }
            if( strstr($lv_row,'stkmovsysdoctretxt') ){ $lv_row = str_ireplace('stkmovsysdoctretxt','sysdoctretxt',$lv_row); }
						$lv_fltmov .= '[~fltrow~]'.$lv_row;
					} else {
						if( strstr($lv_row,'slsordctedte') ){ $lv_row = str_ireplace('slsordctedte','CONVERT(DATE,o.ctedte)',$lv_row); }
            if( strstr($lv_row,'ordsysdoctretxt') ){ $lv_row = str_ireplace('ordsysdoctretxt','sysdoctretxt',$lv_row); }
						$lv_fltped .= '[~fltrow~]'.$lv_row;
					}
				}
				
        // PEDIDOS ------------------------------------------------------------
        // obtiene los datos de pedidos
        $lv_prm = array('vewfldflt' => '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).'SLS_ORD'.chr(9).chr(9).
																			 ( $lv_fltped!=''?$lv_fltped:'' ) );
				if($lv_fltmov==''){ $lv_prm['vewmaxrec'] = $lo_post['vewmaxrec']; }
        $lo_ordrs = $lo_ordmdl->getList( $lv_prm, null, null, false );

				// armar un string con los IDs de pedidos
				$lv_ordlst = '';
				foreach( $lo_ordrs as $lv_row ){
					if( stripos(chr(10).$lv_ordlst.chr(10),chr(10).$lv_row['slsordcod'].chr(10))===false ){
						$lv_ordlst .= ($lv_ordlst!=''?chr(10):'') . $lv_row['slsordcod'];
					}
				}
        
        // FLUJO DE DATOS -----------------------------------------------------
        // obtiene los datos del fujo de documentos
        $lv_prm = array('vewfldflt' => '[~fltrow~]fp.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                        							 '[~fltrow~]fp.srcobjtyp'.chr(9).'='.chr(9).chr(9).'SLS_ORD'.chr(9).chr(9).
                        							 '[~fltrow~]fp.refobjtyp'.chr(9).'IN'.chr(9).chr(9).'STK_SOU'.chr(10).'STK_SIN'.chr(9).chr(9).
                       								 ( $lv_ordlst!='' ? '[~fltrow~]fp.srcobjcod'.chr(9).'IN'.chr(9).chr(9).$lv_ordlst.chr(9).chr(9) : '') );
        $lo_docflwrs = $lo_docflwmdl->getList( $lv_prm );
        
        // arama string con los datos IDs de movimientos obtenidos del flujo de datos
        $lv_docflwstr = '';
				foreach( $lo_docflwrs as $lv_row ){
					if( stripos(chr(10).$lv_docflwstr.chr(10) , chr(10).$lv_row['refobjcod'].chr(10))===false ){
						$lv_docflwstr .= ($lv_docflwstr!=''?chr(10):'') . $lv_row['refobjcod'];
					}
				}
        
        // MOVIMIENTOS --------------------------------------------------------
        // carga datos de movimientos referenciados
        $lo_movrs = array();
        if( $lv_docflwstr!=''){
          $lv_prm = array( 'vewfldflt' => '[~fltrow~]d.stkmovdoccod'.chr(9).'IN'.chr(9).chr(9).$lv_docflwstr.chr(9).chr(9).
																					( $lv_fltmov!=''?$lv_fltmov:'' ) );
          $lo_movrs = $lo_movmdl->getList( $lv_prm, null, null, false );
        }

        // ARRAY DE DATOS -----------------------------------------------------
        
        //maximo de registros
        $lv_maxrec = $lo_post['vewmaxrec'];
        
        //arma array de datos
        $lv_data = array();
        foreach( $lo_ordrs as $lv_ord ){
					$lv_found = false;
					$lv_movlst = '';
					
					// asigna los datos del pedido
					$lv_ord['slsordctedte'] = $lv_ord['ctedte']->format('d/m/Y H:i:s');
          $lv_ord['ordsysdoctretxt'] = $lv_ord['sysdoctretxt'];
					unset($lv_ord['docsts']);
					
          // encuentra los movimientos del pedido
          foreach( $lo_docflwrs as $lv_index=>$lv_docflw ){
            if( $lv_docflw['srcobjcod']==$lv_ord['slsordcod'] && stripos(chr(10).$lv_movlst.chr(10),chr(10).$lv_docflw['refobjcod'].chr(10))===false ){
							
							$lv_movlst .= ($lv_movlst!=''?chr(10):'') . $lv_docflw['refobjcod'];
							
              // recorre los movimientos
              foreach( $lo_movrs as $lv_mov ){
                if( $lv_mov['stkmovdoccod']==$lv_docflw['refobjcod'] ){
                  $lv_found = true;
									
                  // asigna datos del movimiento
                  $lv_mov['stkmovdocctedte'] = $lv_mov['ctedte']->format('d/m/Y H:i:s');
                  $lv_mov['stkmovsysdoctretxt'] = $lv_mov['sysdoctretxt'];
                  if( $lv_mov['upddte'] != null && strtoupper($lv_mov['docsts']) == 'C' ){
										$lv_mov['stkmovdocupddte'] = $lv_mov['upddte']->format('d/m/Y H:i:s');
									}
                  $lv_mov['stkmovdocsts'] = $lv_mov['docsts'];
                  unset($lv_mov['sysdoctrecod']);
                  
                  // calcula las diferencias de tiempos
                  $lv_diff = array();
                  $lv_diff['movcteordcte'] = $lv_ord['ctedte']->diff( $lv_mov['ctedte'] )->format("%ad %H:%I:%S");
                  if($lv_mov['upddte'] != null && strtoupper($lv_mov['docsts']) == 'C'){
                  	$lv_diff['movupdmovcte'] = $lv_mov['ctedte']->diff( $lv_mov['upddte'] )->format("%ad %H:%I:%S");
                    $lv_diff['movupdordcte'] = $lv_ord['ctedte']->diff( $lv_mov['upddte'] )->format("%ad %H:%I:%S");  
                  }
                  
                  // añade los datos al rray de datos
          				array_push( $lv_data, array_merge( $lv_ord, $lv_mov, $lv_diff ) );
                  
                  $lv_maxrec--;
                  break;
                }
              }
              
              // borra este flujo de datos
              unset($lo_docflwrs[$lv_index]);
              
              // revisa que no se exeda el maximo
          		if( $lv_maxrec == 0 ){ break; }
            }
          }
          
          
          // agrega datos del pedido si no se encontro ningun movimiento
          if( ( $lv_fltmov!='' && strtoupper($lv_ord['sysdoctrecod'])=='N' ) || ( $lv_fltmov=='' && !$lv_found && $lv_maxrec > 0 ) ){            
            array_push( $lv_data, $lv_ord );            
            $lv_maxrec--;
          }
          
          //revisa que no se exeda el maximo
          if( $lv_maxrec == 0 ){ break; }
        }
        
				// devuelve el array al reporte
        return $lv_data;
        break;
      	
        
        
      //   M O V I M I E N T O S    V A L O R I Z A D O S
			case '#lgnrptmovval':
				return $this->co_reg->document->getView('zcutp1_lgnrepmovval', array('data'=>array(),'actcod'=>$this->data['actcod']));
				break;



			//   M O V I M I E N T O S    V A L O R I Z A D O S   -  D A T O S
			case '#lgnrptmovvaldat':
				$lo_movmatmdl = $this->co_reg->load->model('stkmovdocmat');
				$lv_prm=array();

				$lv_vewfldflt = (isset($this->co_reg->request->post['vewfldflt'])?$this->co_reg->request->post['vewfldflt']:'');
				$lv_vewmaxrec = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewmaxrec']:'');

				$lv_prm = array('vewfldflt' => $lv_vewfldflt,
												'vewmaxrec' => $lv_vewmaxrec);

				$lv_lmtmem= ini_get('memory_limit');
				ini_set('memory_limit', '2048M');

				$lo_rsmovmat = $lo_movmatmdl->getList( $lv_prm );
				$lv_json = $this->co_reg->document->getJson( array('data'=>$lo_rsmovmat,'data_sqlstm'=>$lo_movmatmdl->getsysdata('sqlstm')) );

				ini_set('memory_limit', $lv_lmtmem);
				return $lv_json;
				break;
			
			
			//   M O V I M I E N T O S    V A L O R I Z A D O S   -  D A T O S
			case '#lgnrptmovvaldat2':
				$lo_movmatmdl = $this->co_reg->load->model('stkmovdocmat');
				$lv_prm=array();

				$lv_vewfldflt = (isset($this->co_reg->request->post['vewfldflt'])?$this->co_reg->request->post['vewfldflt']:'');
				$lv_vewmaxrec = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewmaxrec']:'');

				$lv_prm = array('vewfldflt' => $lv_vewfldflt,
												'vewmaxrec' => $lv_vewmaxrec);

				$lv_lmtmem= ini_get('memory_limit');
				ini_set('memory_limit', '2048M');

				$lo_rsmovmat = $lo_movmatmdl->getList( $lv_prm );
				$lv_data_sqlstm = $lo_movmatmdl->getsysdata('sqlstm');
				
				ini_set('memory_limit', $lv_lmtmem);
				return $lo_rsmovmat ;
				break;
        
      //	R E P O R T E   D E   C L I E N T E S 
			case '#slscusrpt':
				$lo_cusmdl = $this->co_reg->load->model('slscus');
				$lv_prm=array();

				$lv_vewfldflt = (isset($this->co_reg->request->post['vewfldflt'])?$this->co_reg->request->post['vewfldflt']:'');
				$lv_vewmaxrec = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewmaxrec']:'');
        $lv_vewfldord = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewfldord']:'');

				$lv_prm = array('vewfldflt' => $lv_vewfldflt,
                        'vewfldord' => $lv_vewfldord,
												'vewmaxrec' => $lv_vewmaxrec);

				$lv_lmtmem= ini_get('memory_limit');
				ini_set('memory_limit', '2048M');
        
				$lo_rscus = $lo_cusmdl->getList( $lv_prm, null, null, false );
				$lv_data_sqlstm = $lo_cusmdl->getsysdata('sqlstm');
        
        /* IMPUESTOS */
				/* Filtros*/
				$lo_taxmdl = $this->co_reg->load->model('grldattax');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9). 'A'.chr(9).chr(9).
																			'[~fltrow~]taxsrctyp'.chr(9).'='.chr(9).chr(9). 'SLS_CUS'.chr(9).chr(9));
				$lo_rstax = $lo_taxmdl->getList($lv_prm);
        $lo_taxLst=array();
        foreach($lo_rstax as $lv_rowtax){
          $lo_taxLst[$lv_rowtax['taxsrccod']]=$lv_rowtax['taxdocnum'];
        }
        
        /* DIRECCIONES */
				/* Filtros*/
				$lo_adrmdl = $this->co_reg->load->model('grldatadr');
        /* PREPARAMOS LOS FILTROS*/
				$lv_fltarradr = explode('[~fltrow~]',$this->co_reg->request->post['vewfldflt'] );
        $lv_cntfltadr = false;
				for($i=count($lv_fltarradr)-1; $i>0; $i--){
				 if(stripos(';lndregtxt;adrtwn;',';'.explode(chr(9),$lv_fltarradr[$i])[0].';')===false){
				 	unset($lv_fltarradr[$i]);
				 }else{
           $lv_cntfltadr = true;
         }
				}
        
				$lv_prmadr = array('vewfldflt' =>'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9). 'A'.chr(9).chr(9).
																				 '[~fltrow~]AdrSrcTyp'.chr(9).'='.chr(9).chr(9). 'SLS_CUS'.chr(9).chr(9).
                           							 (count($lv_fltarradr)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltarradr):''),
                          );
				$lo_rsadr = $lo_adrmdl->getList($lv_prmadr);
				//$lv_data_sqlstm[]= $lo_taxmdl->getsysdata('sqlstm');
        //echo $lo_adrmdl->getsysdata('sqlstm');
        $lo_drLst=array();
        foreach($lo_rsadr as $lv_rowadr){
          $lo_drLst[$lv_rowadr['adrsrccod']]['lndregtxt']=$lv_rowadr['lndregtxt'];
          $lo_drLst[$lv_rowadr['adrsrccod']]['adrstr']=$lv_rowadr['adrstr'];
          $lo_drLst[$lv_rowadr['adrsrccod']]['adrstrnum']=$lv_rowadr['adrstrnum'];
          $lo_drLst[$lv_rowadr['adrsrccod']]['adrcty']=$lv_rowadr['adrcty'];
          $lo_drLst[$lv_rowadr['adrsrccod']]['adrtwn']=$lv_rowadr['adrtwn'];
        }    
        //print_r($lo_drLst);
        $lv_ret=array();
        foreach($lo_rscus as $lv_row){
          
          $lv_row['taxcod001']='';
          if(isset($lo_taxLst[$lv_row['cuscod']])){
            $lv_row['taxcod001']=$lo_taxLst[$lv_row['cuscod']];
          }
          $lv_row['lndregtxt']='';
          $lv_row['adrstr']='';
          $lv_row['adrstrnum']='';
          $lv_row['adrcty']='';
          $lv_row['adrtwn']='';
          if(isset($lo_drLst[$lv_row['cuscod']])){
            $lv_row['lndregtxt']=$lo_drLst[$lv_row['cuscod']]['lndregtxt'];
            $lv_row['adrstr']=$lo_drLst[$lv_row['cuscod']]['adrstr'];
            $lv_row['adrstrnum']=$lo_drLst[$lv_row['cuscod']]['adrstrnum'];
            $lv_row['adrcty']=$lo_drLst[$lv_row['cuscod']]['adrcty'];
            $lv_row['adrtwn']=$lo_drLst[$lv_row['cuscod']]['adrtwn'];
          }
          
        	$lv_ret[]=$lv_row;
        }				
				ini_set('memory_limit', $lv_lmtmem);
        
				return $lv_ret ;
				break;
			
			
			
			//   M O V I M I E N T O S    V A L O R I Z A D O S  F A C T U R A C I O N
			case '#btnrpt003':
				return $this->co_reg->document->getView('zcutp1_lgnrepfac', array('data'=>array(),'actcod'=>$this->data['actcod']));
				break;
			
        
   
			//LIQUIDACION DE SERVICIOS
      case '#slssvclqdpnt':
        //Liquidacion
        $lo_svclqdmdl = $this->co_reg->load->model('slssvclqd');
        if( $lo_svclqdmdl->load( array( 'slssvclqdcod' => $lp_prm['slssvclqdcod'] ), false ) == false ){
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_svclqdmdl->errtyp,'errcod'=>$lo_svclqdmdl->errcod,'errtxt'=>$lo_svclqdmdl->errtxt) );
        }
        $lv_slssvclqdcod = $lo_svclqdmdl->slssvclqdcod;//codigo de liquidacion
        
        //Cliente
        $lo_cusmdl = $this->co_reg->load->model('slscus');
        if( $lo_cusmdl->load( array( 'cuscod' => $lo_svclqdmdl->cuscod ), false ) == false ){
          return $this->co_reg->document->getJson( array('errtyp'=>$lo_cusmdl->errtyp,'errcod'=>$lo_cusmdl->errcod,'errtxt'=>$lo_cusmdl->errtxt) );
        }
        $lv_slssvclqdcus = $lo_svclqdmdl->custxt;//cliente
        
        //fecha 
        $lv_dte = new Datetime();
        
        //array de datos
				$lo_svclqddocmdl = $this->co_reg->load->model('slssvclqddoc');
        $lv_dat = $lo_svclqddocmdl->getServices( array(), array( 'slssvclqdcod' => $lo_svclqdmdl->slssvclqdcod ) );

        // foreach para identificar y actualizar las filas nuevas y eliminar las viejas
        foreach( $lv_dat as $key => $lv_row ){
          if($lv_row['refobjtyp'] == 'SLS_SVL'){
            $lv_rowid = $lv_row['refobjcod002'];
            foreach ($lv_dat as $key2 => $lv_row2){
              if ($lv_row2['slssvclqddoccod'] == $lv_rowid){
                $lv_dat[$key]['refobjtyp'] = $lv_row2['refobjtyp'];
                $lv_dat[$key]['stkobjtyp'] = $lv_row2['stkobjtyp'];
                $lv_dat[$key]['matcod'] = $lv_row2['matcod'];
                $lv_dat[$key]['refobjcod001'] = $lv_row2['refobjcod001'];
                $lv_dat[$key]['refobjcod002'] = $lv_row2['refobjcod002'];
                $lv_dat[$key]['slssvclqddoccodext'] = $lv_row2['slssvclqddoccodext'];
                $lv_dat[$key]['aju'] = "X";
                unset($lv_dat[$key2]);
                break;
              } 
            }
          }
        }
        // Ordena el array primero por material y después por usuario para que se muestre igual que en las liquidaciones
        //function sortByContact($a, $b) { return $a['stkcntcod'] - $b['stkcntcod']; }
        //function sortByMaterial($a, $b) { return $a['matcod'] - $b['matcod']; }
        //usort($lv_dat, 'sortByMaterial');
        //usort($lv_dat, 'sortByContact');
        
        $this->co_reg->response->addHeader('Content-type:application/pdf');
        return $this->co_reg->document->getView( 'zcutp1_lgn_liqalqpnt', array('data'=>$lv_dat,'dte'=>$lv_dte->format('d/m/Y'),'slssvclqdcod'=>$lv_slssvclqdcod,'msgqty'=>$lp_prm['msgqty']??'1','cuscod'=>$lo_cusmdl->cuscod,'custxt'=>$lv_slssvclqdcus));
        break;

        
        
			//   M O V I M I E N T O S    V A L O R I Z A D O S   F A C T U R A C I O N  -  D A T O S
      case '#btnrpt003dat':
      $lo_cusmdl = $this->co_reg->load->model('slscus');
      $lo_prcmdl = $this->co_reg->load->model('slsprclst');
      $lo_ordmatmdl = $this->co_reg->load->model('slsordmat');
      $lo_movmatmdl = $this->co_reg->load->model('stkmovdocmat');
      $lv_data_sqlstm=[];

      $lv_lmtmem= ini_get('memory_limit');
      ini_set('memory_limit', '2048M');

      // BUSCO LOS MOVIMIENTO DE STOCK
      $lv_clsbuf = array('VTA','DVC');
      $lv_vewfldflt = $this->co_reg->request->post['vewfldflt'] ?? '';
      $lv_vewmaxrec = $this->co_reg->request->post['vewmaxrec'] ?? '';
      $lv_isvew = $this->co_reg->request->post['isvew'] ?? '';
      $lv_prm=array();
      $lv_prm = array('vewfldflt' =>'[~fltrow~]dc.sysdocclscodext'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lv_clsbuf).chr(9).chr(9).
                                     $lv_vewfldflt,
                      'vewmaxrec' => $lv_vewmaxrec,
                      'vewfldord' =>'d.stkmovdocdte DESC');
      $lo_rsmovmat = $lo_movmatmdl->getList( $lv_prm );
      $lv_data_sqlstm[] = $lo_movmatmdl->getsysdata('sqlstm');
      // RECORRO LOS DATOS Y GUARDO LOS CODIGOS DE CLIENTE Y POSICIONES DE ORDEN DE COMPRA PARA USARLOS PARA LOS FILTROS DE LOS GETLIST CORRESPONDIENTES
      $lv_cusbuf = array();
      $lv_ordposbuf = array();
      foreach ($lo_rsmovmat as $lo_row) {
        if (!in_array($lo_row['dstobjcod'], $lv_cusbuf)) {
          $lv_cusbuf[]=$lo_row['dstobjcod'];
        }

        if (!in_array($lo_row['docrefposcod'], $lv_ordposbuf)) {
          $lv_ordposbuf[]=$lo_row['docrefposcod'];
        }
        /*
        if (!in_array($lo_row['docrefcod'], $lv_ordbuf)) {
          $lv_ordbuf[]=$lo_row['docrefcod'];
        }
        */
      }
      /* BUSCAMOS LOS CLIENTES DE LOS MOVIMIENTOS DE MATERIAL*/
      sort($lv_cusbuf, SORT_NUMERIC); // ordeno de menor a mayor los IDs
      $lv_prm = array('vewfldflt' =>'[~fltrow~]c.cuscod'.chr(9).'BT'.chr(9).chr(9).reset($lv_cusbuf).chr(9).end($lv_cusbuf).chr(9).chr(9));
      $lo_rscus= $lo_cusmdl->getlist($lv_prm, null, null, false);
      $lv_data_sqlstm[] = $lo_cusmdl->getsysdata('sqlstm');

      // RECORRO LOS DATOS Y GUARDO LOS CODIGOS DE LISTA DE PRECIO UTILIZADAS PARA LOS CLIENTES PARA USARLOS PARA LOS FILTROS DE LOS GETLIST CORRESPONDIENTES
      $lv_prcbuf = array();
      $lv_cusprclst=array();
      foreach ($lo_rscus as $lo_row) {
        if (!in_array($lo_row['slsprclstcod'], $lv_prcbuf)) {
          $lv_prcbuf[]=$lo_row['slsprclstcod'];
        }
        $lv_cusprclst[$lo_row['cuscod']]=$lo_row['slsprclstcod']; 
      }
      /* BUSCAMOS LAS LISTAS DE PRECIO DE LOS CLIENTES */
      sort($lv_prcbuf, SORT_NUMERIC); // ordeno de menor a mayor los IDs
      $lv_prm = array('vewfldflt' =>'[~fltrow~]pl.SlsPrcLstCod'.chr(9).'BT'.chr(9).chr(9).reset($lv_prcbuf).chr(9).end($lv_prcbuf).chr(9).chr(9));
      $lo_rsprc= $lo_prcmdl->getlist($lv_prm);
      $lv_data_sqlstm[] = $lo_prcmdl->getsysdata('sqlstm');

      /* BUSCAMOS LOS PEDIDOS REFERANCIADOS EN LOS MOVIMIENTOS DE MATERIALES */
      sort($lv_ordposbuf, SORT_NUMERIC); // ordeno de menor a mayor los IDs
      $lv_prm = array();
      $lv_prm = array('vewfldflt' =>'[~fltrow~]SlsOrdMatCod'.chr(9).'BT'.chr(9).chr(9).reset($lv_ordposbuf).chr(9).end($lv_ordposbuf).chr(9).chr(9));
      $lo_rsordmat= $lo_ordmatmdl->getlist($lv_prm);
      $lv_data_sqlstm[] = $lo_ordmatmdl->getsysdata('sqlstm');

      $lo_ret=array();
      foreach ($lo_rsmovmat as $lv_row) {
        $lo_enc = array();
        $lo_enc['stkmovdoccod']=$lv_row['stkmovdoccod'];
        $lo_enc['stkmovdoccodext']=$lv_row['stkmovdoccodext'];
        $lo_enc['stkmovdocdtecnv']=$lv_row['stkmovdocdtecnv'];
        $lo_enc['stkmovdoccnfdte']=$lv_row['stkmovdoccnfdte'];
        $lo_enc['stkmovdoccnftyp']=$lv_row['stkmovdoccnftyp'];
        $lo_enc['sysdocclstxt']=$lv_row['sysdocclstxt'];
        $lo_enc['matdocclstxt']=$lv_row['matdocclstxt'];
        $lo_enc['matcod']=$lv_row['matcod'];
        $lo_enc['matcodext']=$lv_row['matcodext'];
        $lo_enc['mattxt']=$lv_row['mattxt'];
        $lo_enc['matbchcodext']=$lv_row['matbchcodext'];
        $lo_enc['matbchduedtecnv']=$lv_row['matbchduedtecnv'];
        $lo_enc['matsercodext']=$lv_row['matsercodext'];
        $lo_enc['matuntcod']=$lv_row['matuntcod'];
        $lo_enc['srcobjtyptxt']=$lv_row['srcobjtyptxt'];
        $lo_enc['srcobjtxt']=$lv_row['srcobjtxt'];
        $lo_enc['srccnttxt']=$lv_row['srccnttxt'];
        $lo_enc['dstobjtyptxt']=$lv_row['dstobjtyptxt'];
        $lo_enc['dstobjtxt']=$lv_row['dstobjtxt'];
        $lo_enc['dstcnttxt']=$lv_row['dstcnttxt'];
        $lo_enc['dstcntcodext']=$lv_row['dstcntcodext'];
        $lo_enc['matcstlst']=floatval($lv_row['matcstlst']);
        $lo_enc['matcst']=floatval($lv_row['matcst']);
        $lo_enc['matqty']=$lv_row['matqty'];
        $lo_enc['prcord']='0';
        $lo_enc['prclst']='0';
        $lo_enc['slsordcod']=$lv_row['docrefcod'];

        /* AGREGAMOS LOS PRECIOS DE LISTA*/
        foreach ($lo_rsprc as $lv_row_prclst) {
          if(isset( $lv_cusprclst[$lv_row['dstobjcod']])){
            if($lv_row_prclst['slsprclstcod'] == $lv_cusprclst[$lv_row['dstobjcod']]&&$lv_row_prclst['slsprcsrccod']==$lv_row['matcod']){
              $lo_enc['prclst']= $lv_row_prclst['slsprc'];
            }
          }
        }

        /* AGREGAMOS LOS PRECIOS DE VENTA*/
        foreach ($lo_rsordmat as $lv_row_prcord) {
          if($lv_row_prcord['slsordmatcod']==$lv_row['docrefposcod']){
            $lo_enc['prcord']= $lv_row_prcord['matprc'] * $lv_row['matqty'];
          }
        }
        $lo_ret[]=$lo_enc;
      }

      // si existe el parámetro "isvew" en el POST y es igual a "X", lo devuelvo con el formato que recibe la vista 
      if ($lv_isvew == 'X'){ $lv_ret = $this->co_reg->document->getJson( array('data'=>$lo_ret,'data_sqlstm'=>$lv_data_sqlstm) ); } else { $lv_ret = $lo_ret; }
      //ini_set('memory_limit', $lv_lmtmem );
      return $lv_ret;
      break;	
        
      // REFERENCIA PARA FUTUROS CAMBIOS
			/*case '#btnrpt003dat':
				$lo_cusmdl = $this->co_reg->load->model('slscus');
				$lo_prcmdl = $this->co_reg->load->model('slsprclst');
				$lo_ordmatmdl = $this->co_reg->load->model('slsordmat');
				$lo_movmatmdl = $this->co_reg->load->model('stkmovdocmat');
        $lv_data_sqlstm=[];
        
        global $memLogs;
				
				$lv_lmtmem= ini_get('memory_limit');
				ini_set('memory_limit', '5120M');
        
        // BUSCO LOS MOVIMIENTO DE STOCK
				$lv_clsbuf = array('VTA','DVC');
				$lv_vewfldflt = $this->co_reg->request->post['vewfldflt'] ?? '';
				$lv_vewmaxrec = $this->co_reg->request->post['vewmaxrec'] ?? '';
        $lv_isvew = $this->co_reg->request->post['isvew'] ?? '';
				$lv_prm=array();
				$lv_prm = array('vewfldflt' =>'[~fltrow~]dc.sysdocclscodext'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lv_clsbuf).chr(9).chr(9).
																			 $lv_vewfldflt,
												'vewmaxrec' => $lv_vewmaxrec,
												'vewfldord' =>'d.stkmovdocdte DESC');
				$lo_rsmovmat = $lo_movmatmdl->getList( $lv_prm );
        $lv_data_sqlstm[] = $lo_movmatmdl->getsysdata('sqlstm');
        // RECORRO LOS DATOS Y GUARDO LOS CODIGOS DE CLIENTE Y POSICIONES DE ORDEN DE COMPRA PARA USARLOS PARA LOS FILTROS DE LOS GETLIST CORRESPONDIENTES
				$lv_cusbuf = array();
				$lv_ordposbuf = array();
        
				foreach ($lo_rsmovmat as $lo_row) {
          $lv_cusbuf[$lo_row['dstobjcod']]    = true; // uso hash en vez de in_array
          $lv_ordposbuf[$lo_row['docrefposcod']] = true;
        }
        
        $lv_cusbuf    = array_keys($lv_cusbuf);
    		$lv_ordposbuf = array_keys($lv_ordposbuf);
        
				// BUSCAMOS LOS CLIENTES DE LOS MOVIMIENTOS DE MATERIAL
        sort($lv_cusbuf, SORT_NUMERIC); // ordeno de menor a mayor los IDs
        $lv_prm = array('vewfldflt' =>'[~fltrow~]c.cuscod'.chr(9).'BT'.chr(9).chr(9).reset($lv_cusbuf).chr(9).end($lv_cusbuf).chr(9).chr(9));
				$lo_rscus= $lo_cusmdl->getlist($lv_prm, null, null, false);
				$lv_data_sqlstm[] = $lo_cusmdl->getsysdata('sqlstm');
        
        // RECORRO LOS DATOS Y GUARDO LOS CODIGOS DE LISTA DE PRECIO UTILIZADAS PARA LOS CLIENTES PARA USARLOS PARA LOS FILTROS DE LOS GETLIST CORRESPONDIENTES
				$lv_prcbuf = array();
				$lv_cusprclst=array();
				foreach ($lo_rscus as $lo_row) {
          $lv_prcbuf[$lo_row['slsprclstcod']] = true;
          $lv_cusprclst[$lo_row['cuscod']] = $lo_row['slsprclstcod'];
				}
        unset($lo_rscus); $lo_rscus = null; gc_collect_cycles(); // libero memoria
        
				// BUSCAMOS LAS LISTAS DE PRECIO DE LOS CLIENTES
        sort($lv_prcbuf, SORT_NUMERIC); // ordeno de menor a mayor los IDs
				$lv_prm = array('vewfldflt' =>'[~fltrow~]pl.SlsPrcLstCod'.chr(9).'BT'.chr(9).chr(9).reset($lv_prcbuf).chr(9).end($lv_prcbuf).chr(9).chr(9));
				$lo_rsprc= $lo_prcmdl->getlist($lv_prm);
				$lv_data_sqlstm[] = $lo_prcmdl->getsysdata('sqlstm');
        
        $lv_prcidx = [];
        foreach ($lo_rsprc as $lo_row) {
          $lv_prcidx[$lo_row['slsprclstcod']][$lo_row['slsprcsrccod']] = $lo_row['slsprc'];
        }
        unset($lo_rsprc); $lo_rsprc = null; gc_collect_cycles(); // libero memoria

				// BUSCAMOS LOS PEDIDOS REFERANCIADOS EN LOS MOVIMIENTOS DE MATERIALES 
        sort($lv_ordposbuf, SORT_NUMERIC); // ordeno de menor a mayor los IDs
				$lv_prm = array();
				$lv_prm = array('vewfldflt' =>'[~fltrow~]SlsOrdMatCod'.chr(9).'BT'.chr(9).chr(9).reset($lv_ordposbuf).chr(9).end($lv_ordposbuf).chr(9).chr(9));
				$lo_rsordmat= $lo_ordmatmdl->getlist($lv_prm);
				$lv_data_sqlstm[] = $lo_ordmatmdl->getsysdata('sqlstm');
        
        $lv_ordidx = [];
        foreach ($lo_rsordmat as $lo_row) {
            $lv_ordidx[$lo_row['slsordmatcod']] = $lo_row['matprc'];
        }
        unset($lo_rsordmat); $lo_rsordmat=null; gc_collect_cycles(); // libero memoria
        
				$lo_ret=array();
				foreach ($lo_rsmovmat as $lv_row) {
					$lo_enc = array();
					$lo_enc['stkmovdoccod']=$lv_row['stkmovdoccod'];
					$lo_enc['stkmovdoccodext']=$lv_row['stkmovdoccodext'];
					$lo_enc['stkmovdocdtecnv']=$lv_row['stkmovdocdtecnv'];
          $lo_enc['stkmovdoccnfdte']=$lv_row['stkmovdoccnfdte'];
          $lo_enc['stkmovdoccnftyp']=$lv_row['stkmovdoccnftyp'];
					$lo_enc['sysdocclstxt']=$lv_row['sysdocclstxt'];
					$lo_enc['matdocclstxt']=$lv_row['matdocclstxt'];
					$lo_enc['matcod']=$lv_row['matcod'];
					$lo_enc['matcodext']=$lv_row['matcodext'];
					$lo_enc['mattxt']=$lv_row['mattxt'];
					$lo_enc['matbchcodext']=$lv_row['matbchcodext'];
					$lo_enc['matbchduedtecnv']=$lv_row['matbchduedtecnv'];
					$lo_enc['matsercodext']=$lv_row['matsercodext'];
					$lo_enc['matuntcod']=$lv_row['matuntcod'];
					$lo_enc['srcobjtyptxt']=$lv_row['srcobjtyptxt'];
					$lo_enc['srcobjtxt']=$lv_row['srcobjtxt'];
					$lo_enc['srccnttxt']=$lv_row['srccnttxt'];
					$lo_enc['dstobjtyptxt']=$lv_row['dstobjtyptxt'];
					$lo_enc['dstobjtxt']=$lv_row['dstobjtxt'];
					$lo_enc['dstcnttxt']=$lv_row['dstcnttxt'];
					$lo_enc['dstcntcodext']=$lv_row['dstcntcodext'];
					$lo_enc['matcstlst']=floatval($lv_row['matcstlst']);
					$lo_enc['matcst']=floatval($lv_row['matcst']);
					$lo_enc['matqty']=$lv_row['matqty'];
					$lo_enc['prcord']='0';
					$lo_enc['prclst']='0';
					$lo_enc['slsordcod']=$lv_row['docrefcod'];

          // AGREGAMOS LOS PRECIOS DE LISTA
          if (isset($lv_cusprclst[$lv_row['dstobjcod']])) {
            $lv_prclstcod = $lv_cusprclst[$lv_row['dstobjcod']];
            if (isset($lv_prcidx[$lv_prclstcod][$lv_row['matcod']])) {
              $lo_enc['prclst'] = $lv_prcidx[$lv_prclstcod][$lv_row['matcod']];
            }
          }

					// AGREGAMOS LOS PRECIOS DE VENTA
          if (isset($lv_ordidx[$lv_row['docrefposcod']])) {
            $lo_enc['prcord'] = $lv_ordidx[$lv_row['docrefposcod']] * $lv_row['matqty'];
          }

          $lo_ret[] = $lo_enc;
      	}
    		unset($lo_rsmovmat); $lo_rsmovmat=null; gc_collect_cycles(); // libero memoria
        
        // si existe el parámetro "isvew" en el POST y es igual a "X", lo devuelvo con el formato que recibe la vista 
        if ($lv_isvew == 'X'){ $lv_ret = $this->co_reg->document->getJson( array('data'=>$lo_ret,'data_sqlstm'=>$lv_data_sqlstm,'mem_logs'=>$memLogs) ); } 
        else { $lv_ret = ['data'=>$lo_ret,'mem_logs'=>$memLogs]; }
				ini_set('memory_limit', $lv_lmtmem );
				return $lv_ret;
				break;*/
        
			
      //  R E P O R T E  P E D I D O S   P O R   S O L I C I T A N T E 
			case '#lgnrptordcus':
				$lo_ordmdl = $this->co_reg->load->model('slsord');
        $lo_post = $this->co_reg->request->post;
        
        /* BUACAMOS LOS PEDIDOS */
        /* PREPARAMOS LOS FILTROS*/
				$lv_fltarrord = explode('[~fltrow~]',$lo_post['vewfldflt'] );
				for($i=count($lv_fltarrord)-1; $i>0; $i--){
          if(stripos(';slsordcod;sysdocclstxt;dstobjtxt;dstcnttxt;slsorddtecnv;cteusr;sysdoctretxt;',';'.explode(chr(9),$lv_fltarrord[$i])[0].';')===false){
          	unset($lv_fltarrord[$i]);
          }else {
            $lv_fltarrord[$i] = str_replace('slsordcod','o.slsordcod',$lv_fltarrord[$i]);
            //$lv_fltarrord[$i] = str_replace('slsorddte','o.slsorddte',$lv_fltarrord[$i]);
            $lv_fltarrord[$i] = str_replace('sysdocclstxt','dc.sysdocclstxt',$lv_fltarrord[$i]);
            $lv_fltarrord[$i] = str_replace('dstcnttxt','cn.cnttxt',$lv_fltarrord[$i]);
            $lv_fltarrord[$i] = str_replace('cteusr','cteusr',$lv_fltarrord[$i]);
            $lv_fltarrord[$i] = str_replace('sysdoctretxt','sysdoctretxt',$lv_fltarrord[$i]);
            $lv_fltarrord[$i] = str_replace('slsorddtecnv','slsorddte',$lv_fltarrord[$i]);
          }
          
				}
				
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																				 (count($lv_fltarrord)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltarrord):''),
																				 'vewmaxrec'=>$lo_post['vewmaxrec'],
																			   'vewfldord' => 'o.ctedte desc');
        $lo_rsord=$lo_ordmdl->getlist($lv_prmflt, null, null, false);
        
        /* BUSQUEDA DE DIRECCIONES DE LOS CONTACTOS */
        
        $lv_fltarradr = explode('[~fltrow~]',$lo_post['vewfldflt'] );
        $lv_fltadr = false;
				for($i=count($lv_fltarradr)-1; $i>0; $i--){
          if(stripos(';adrzon;',';'.explode(chr(9),$lv_fltarradr[$i])[0].';')===false){
          	unset($lv_fltarradr[$i]);
          }else {
            $lv_fltadr = true;
            $lv_fltarradr[$i] = str_replace('adrzon','a.adrzon',$lv_fltarradr[$i]);
          }
          
				}
        
        $lo_adrmdl = $this->co_reg->load->model('grldatadr');
        $lv_prmfltadr = array('vewfldflt' =>'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																				 '[~fltrow~]a.adrsrctyp'.chr(9).'='.chr(9).chr(9).'GRL_CCT'.chr(9).chr(9).
                              				(count($lv_fltarradr)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltarradr):''),
																				 'vewmaxrec'=>$lo_post['vewmaxrec'],
																			   'vewfldord' => 'a.ctedte desc');
        $lo_rsadr=$lo_adrmdl->getlist($lv_prmfltadr);
        //echo $lo_ordmdl->getsysdata('sqlstm');
        
        $lo_adrrlst=array();
        foreach($lo_rsadr as $lo_rowadr){
          $lo_adrrlst[$lo_rowadr['adrsrccod']]['adrzon']=$lo_rowadr['adrzon'];
        }
        
        //var_dump($lo_adrrlst['338']['adrzon']);
        
        $lo_ret=array();
        foreach($lo_rsord as $lo_row){
        	$lo_ord=$lo_row;
          $lo_ord['adrzon']='';
          if(isset($lo_adrrlst[$lo_row['dstcntcod']])){
            	$lo_ord['adrzon']=$lo_adrrlst[$lo_row['dstcntcod']]['adrzon'];
            
          }elseif($lv_fltadr==true){
            continue;
          }
          
          $lo_ret[]=$lo_ord;
        }
        
				return $lo_ret;
				break;
			
			
			
      //  R E P O R T E  P E D I D O S   P A R C I A L E S 
			case '#lgnrptordcusmat':
				$lo_ordmdl = $this->co_reg->load->model('slsord');
        $lo_post = $this->co_reg->request->post;
        
        /* PREPARAMOS LOS FILTROS PARA CABECERA DE PEDIDOS*/
				$lv_fltarrpre = explode('[~fltrow~]',$lo_post['vewfldflt'] );
				for($i=count($lv_fltarrpre)-1; $i>0; $i--){
          
				if(stripos(';slsordcod;sysdocclstxt;dstcnttxt;cteusr;dstobjtxt;dstcnttxt;ord_sysdoctretxt;slsorddte;slsorddtecnv;',';'.explode(chr(9),$lv_fltarrpre[$i])[0].';')===false){
 				 	unset($lv_fltarrpre[$i]);
				 }else{
           $lv_fltarrpre[$i] = str_replace('slsordcod','o.slsordcod',$lv_fltarrpre[$i]);
           $lv_fltarrpre[$i] = str_replace('sysdocclstxt','dc.sysdocclstxt',$lv_fltarrpre[$i]);
           $lv_fltarrpre[$i] = str_replace('dstcnttxt','cn.cnttxt',$lv_fltarrpre[$i]);
           $lv_fltarrpre[$i] = str_replace('cteusr','cteusr',$lv_fltarrpre[$i]);
           $lv_fltarrpre[$i] = str_replace('ord_sysdoctretxt','sysdoctretxt',$lv_fltarrpre[$i]);
           $lv_fltarrpre[$i] = str_replace('slsorddtecnv','slsorddte',$lv_fltarrpre[$i]);
          $lv_fltarrpre[$i] = str_replace('slsorddte','o.slsorddte',$lv_fltarrpre[$i]);
         }
				}
        
				
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																				 (count($lv_fltarrpre)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltarrpre):''),
																				 'vewmaxrec'=>$lo_post['vewmaxrec'],
																			   'vewfldord' => 'o.ctedte desc');
				$lo_rsord= $lo_ordmdl->getlist($lv_prmflt, null, null, false);
        // OBTENGO LOS CODIGOS DE PACIENTE PARA CONSULTAR LAS DIRECCIONES
        $lv_patcodlst=[];
        foreach ($lo_rsord as $lv_rowOrd){
          $lv_patkey=$lv_rowOrd['dstcntcod'];
        	if (!in_array($lv_patkey,$lv_patcodlst)){
          	$lv_patcodlst[]=$lv_patkey;
          }
        }
        
        /* PREPARAMOS LOS FILTROS PARA CABECERA DE PEDIDOS*/
				$lv_fltarradr = explode('[~fltrow~]',$lo_post['vewfldflt'] );
         $lv_cntfltadr = false;
				for($i=count($lv_fltarradr)-1; $i>0; $i--){
          
				 if(stripos(';adrzon;trazontxt;',';'.explode(chr(9),$lv_fltarradr[$i])[0].';')===false){
				 	unset($lv_fltarradr[$i]);
				 }else{
            $lv_cntfltadr = true;
           $lv_fltarradr[$i] = str_replace('trazontxt','trazontxt',$lv_fltarradr[$i]);
           //$lv_fltarradr[$i] = str_replace('adrzon','adrzon',$lv_fltarradr[$i]);
         }
				}
        
        $lo_adrmdl = $this->co_reg->load->model('grldatadr');
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                           							 '[~fltrow~]a.adrsrctyp'.chr(9).'='.chr(9).chr(9).'GRL_CCT'.chr(9).chr(9).
                           							 '[~fltrow~]adrsrccod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lv_patcodlst).chr(9).chr(9).
                           							 (count($lv_fltarradr)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltarradr):''),
																				 'vewmaxrec'=>$lo_post['vewmaxrec'],
																			   'vewfldord' => 'a.ctedte desc');
				$lo_rsadr= $lo_adrmdl->getlist($lv_prmflt);
        //var_dump($lo_adrmdl->getsysdata('sqlstm'));break;
        
        $lv_adrlst=[];
        foreach ($lo_rsadr as $lv_rowadr){
          $lv_adrpatkey=$lv_rowadr['adrsrccod'];
          if(!array_key_exists($lv_adrpatkey, $lv_adrlst)) {
              //echo "El elemento 'first' está en el array";
            $lv_adrlst[$lv_adrpatkey]=$lv_rowadr;
          }
        }
        $lo_ordmatmdl = $this->co_reg->load->model('slsordmat');
        /* PREPARAMOS LOS FILTROS POSICIONES DE PEDIDOS*/
				$lv_fltarr = explode('[~fltrow~]',$lo_post['vewfldflt'] );
				for($i=count($lv_fltarr)-1; $i>0; $i--){
          
				 if(stripos(';matcod;mattxt;matqty;sysdocrejtxt;sysdoctretxt;',';'.explode(chr(9),$lv_fltarr[$i])[0].';')===false){
				 	unset($lv_fltarr[$i]);
				 }else{
           $lv_fltarr[$i] = str_replace('matcod','m.matcod',$lv_fltarr[$i]);
           $lv_fltarr[$i] = str_replace('mattxt','m.mattxt',$lv_fltarr[$i]);
           $lv_fltarr[$i] = str_replace('matqty','matqty',$lv_fltarr[$i]);
           $lv_fltarr[$i] = str_replace('sysdocrejtxt','dr.sysdocrejtxt',$lv_fltarr[$i]);
           $lv_fltarr[$i] = str_replace('sysdoctretxt','dt.sysdoctretxt',$lv_fltarr[$i]);
         }
				}
        $lv_prm = array('vewfldflt' =>'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
																				 (count($lv_fltarr)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltarr):''),
																				 'vewmaxrec'=>$lo_post['vewmaxrec'],
																			   'vewfldord' => 'o.ctedte desc');
        
				$lo_rsordmat= $lo_ordmatmdl->getlist($lv_prm);
        $lo_rsret = array();
        foreach ($lo_rsordmat as $lv_rowMat){
          $lo_rowret = array('matcod'=>$lv_rowMat['matcod'],
                             'mattxt'=>$lv_rowMat['mattxt'],
                             'matqty'=>$lv_rowMat['matqty'],
                             'matprc'=>$lv_rowMat['matprc'],
                             'mattot'=>$lv_rowMat['mattot'],
                             'slsordcod'=>'',
                             'sysdocclstxt'=>'',
                             'dstobjtxt'=>'',
                             'dstcnttxt'=>'',
                             'slsorddtecnv'=>'',
                             'slsorddte'=>'',
                             'cteusr'=>'',
                             'sysdocrejtxt'=>$lv_rowMat['sysdocrejtxt'],
                             'sysdoctretxt'=>$lv_rowMat['sysdoctretxt']
          									);
          foreach ($lo_rsord as $lv_rowOrd){
            if($lv_rowMat['slsordcod']== $lv_rowOrd['slsordcod']){
              $lv_dstcodkey=  $lv_rowOrd['dstcntcod'];
  						$lo_rowret['slsordcod']=$lv_rowOrd['slsordcod'];
              $lo_rowret['sysdocclstxt']=$lv_rowOrd['sysdocclstxt'];
              $lo_rowret['dstobjtxt']=$lv_rowOrd['dstobjtxt'];
              $lo_rowret['dstcnttxt']=$lv_rowOrd['dstcnttxt'];
              $lo_rowret['slsorddtecnv']=$lv_rowOrd['slsorddtecnv'];
              $lo_rowret['slsorddte']=$lv_rowOrd['slsorddte'];
              $lo_rowret['cteusr']=$lv_rowOrd['cteusr'];
							$lo_rowret['ord_sysdoctretxt']=$lv_rowOrd['sysdoctretxt']; // Usa el alias          
              $lo_rowret['adrzon']=isset($lv_adrlst[$lv_dstcodkey])?$lv_adrlst[$lv_dstcodkey]['adrzon']:'';
              $lo_rowret['trazontxt']=isset($lv_adrlst[$lv_dstcodkey])?$lv_adrlst[$lv_dstcodkey]['trazontxt']:'';
            }
        	}
          if($lo_rowret['slsordcod']==''){continue;}
          if( $lv_cntfltadr && $lo_rowret['trazontxt'] == ''){continue;}
          $lo_rsret[]=$lo_rowret;
        }
        return $lo_rsret;
				break;
      //  R E P O R T E  P E D I D O S   P A R C I A L E S 
			case '#rptordpend':
        /*GRUSSO*/
				$lo_ordmdl = $this->co_reg->load->model('slsord');
        $lo_post = $this->co_reg->request->post;
        $lstSqlSmt=[];
      
        /* PREPARAMOS LOS FILTROS PARA CABECERA DE PEDIDOS*/
				$lv_fltarrpre = explode('[~fltrow~]',$lo_post['vewfldflt'] );
				for($i=count($lv_fltarrpre)-1; $i>0; $i--){
          
				if(stripos(';slsordcod;sysdocclstxt;dstcnttxt;cteusr;dstobjtxt;dstcnttxt;ord_sysdoctretxt;slsorddte;slsorddtecnv;',';'.explode(chr(9),$lv_fltarrpre[$i])[0].';')===false){
 				 	unset($lv_fltarrpre[$i]);
				 }else{
           $lv_fltarrpre[$i] = str_replace('slsordcod','o.slsordcod',$lv_fltarrpre[$i]);
           $lv_fltarrpre[$i] = str_replace('sysdocclstxt','dc.sysdocclstxt',$lv_fltarrpre[$i]);
           $lv_fltarrpre[$i] = str_replace('dstcnttxt','cn.cnttxt',$lv_fltarrpre[$i]);
           $lv_fltarrpre[$i] = str_replace('cteusr','cteusr',$lv_fltarrpre[$i]);
           $lv_fltarrpre[$i] = str_replace('ord_sysdoctretxt','sysdoctretxt',$lv_fltarrpre[$i]);
           $lv_fltarrpre[$i] = str_replace('slsorddtecnv','slsorddte',$lv_fltarrpre[$i]);
         }
				}
        
				$lstSysDocTreCod=$lp_prm['sysdoctrelst']??'P,N';
        $lstSysDocClsCod=$lp_prm['clscodextlst']??'PEDM,PEDW,PEDT' ;
        $lv_prmflt = array('vewfldflt' =>'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                           							 '[~fltrow~]o.sysdoctrecod'.chr(9).'IN'.chr(9).chr(9).str_replace(',', chr(10), $lstSysDocTreCod).chr(9).chr(9).
                           							 '[~fltrow~]dc.sysdocclscodext'.chr(9).'IN'.chr(9).chr(9).str_replace(',', chr(10), $lstSysDocClsCod).chr(9).chr(9).
																				 (count($lv_fltarrpre)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltarrpre):''),
																				 'vewmaxrec'=>$lo_post['vewmaxrec'],
																			   'vewfldord' => 'o.ctedte desc');
				$lo_rsord= $lo_ordmdl->getlist($lv_prmflt, null, null, false);
        $lstSqlSmt[]=$lo_ordmdl->getsysdata('sqlstm');
        // OBTENGO LOS CODIGOS DE PACIENTE PARA CONSULTAR LAS DIRECCIONES
        $lv_patcodlst=[];
        foreach ($lo_rsord as $lv_rowOrd){
          $lv_patkey=$lv_rowOrd['dstcntcod'];
        	if (!in_array($lv_patkey,$lv_patcodlst)){
          	$lv_patcodlst[]=$lv_patkey;
          }
        }
        
        $lo_ordmatmdl = $this->co_reg->load->model('slsordmat');
        /* PREPARAMOS LOS FILTROS POSICIONES DE PEDIDOS*/
				$lv_fltarr = explode('[~fltrow~]',$lo_post['vewfldflt'] );
				for($i=count($lv_fltarr)-1; $i>0; $i--){
          
				 if(stripos(';matcod;mattxt;matqty;sysdocrejtxt;sysdoctretxt;',';'.explode(chr(9),$lv_fltarr[$i])[0].';')===false){
				 	unset($lv_fltarr[$i]);
				 }else{
           $lv_fltarr[$i] = str_replace('matcod','m.matcod',$lv_fltarr[$i]);
           $lv_fltarr[$i] = str_replace('mattxt','m.mattxt',$lv_fltarr[$i]);
           $lv_fltarr[$i] = str_replace('matqty','matqty',$lv_fltarr[$i]);
           $lv_fltarr[$i] = str_replace('sysdocrejtxt','dr.sysdocrejtxt',$lv_fltarr[$i]);
           $lv_fltarr[$i] = str_replace('sysdoctretxt','dt.sysdoctretxt',$lv_fltarr[$i]);
         }
				}
        $lv_prm = array('vewfldflt' =>'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                        								 '[~fltrow~]om.sysdoctrecod'.chr(9).'IN'.chr(9).chr(9).str_replace(',', chr(10), $lstSysDocTreCod).chr(9).chr(9).
																				 (count($lv_fltarr)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltarr):''),
																				 'vewmaxrec'=>$lo_post['vewmaxrec'],
																			   'vewfldord' => 'o.ctedte desc');
        
				$lo_rsordmat= $lo_ordmatmdl->getlist($lv_prm);
        $lstSqlSmt[]=$lo_ordmatmdl->getsysdata('sqlstm');
        $lo_rsret = array();
        foreach ($lo_rsordmat as $lv_rowMat){
          $lo_rowret = array('matcod'=>$lv_rowMat['matcod'],
                             'mattxt'=>$lv_rowMat['mattxt'],
                             'matqty'=>$lv_rowMat['matqty'],
                             'slsordcod'=>'',
                             'sysdocclstxt'=>'',
                             'dstobjtxt'=>'',
                             'dstcnttxt'=>'',
                             'slsorddtecnv'=>'',
                             'slsorddte'=>'',
                             'cteusr'=>'',
                             'sysdocrejtxt'=>$lv_rowMat['sysdocrejtxt'],
                             'sysdoctretxt'=>$lv_rowMat['sysdoctretxt']
          									);
          foreach ($lo_rsord as $lv_rowOrd){
            if($lv_rowMat['slsordcod']== $lv_rowOrd['slsordcod']){
              $lv_dstcodkey=  $lv_rowOrd['dstcntcod'];
  						$lo_rowret['slsordcod']=$lv_rowOrd['slsordcod'];
              $lo_rowret['sysdocclstxt']=$lv_rowOrd['sysdocclstxt'];
              $lo_rowret['dstobjtxt']=$lv_rowOrd['dstobjtxt'];
              $lo_rowret['dstcnttxt']=$lv_rowOrd['dstcnttxt'];
              $lo_rowret['slsorddtecnv']=$lv_rowOrd['slsorddtecnv'];
              $lo_rowret['slsorddte']=$lv_rowOrd['slsorddte'];
              $lo_rowret['cteusr']=$lv_rowOrd['cteusr'];
							$lo_rowret['ord_sysdoctretxt']=$lv_rowOrd['sysdoctretxt']; // Usa el alias
            }
        	}
          if($lo_rowret['slsordcod']==''){continue;}
          
          //if( $lv_cntfltadr && $lo_rowret['trazontxt'] == ''){continue;}
          $lo_rsret[]=$lo_rowret;
        }
        $lo_rsret[0]['sqlsmt']= $lstSqlSmt;
        return $lo_rsret;
				break;		
      // M A I L   A U T O M A T I C O   L O T E   Y   V E N C I M I E N T O
			case '#lngstkmatstklst':
        $lo_stkmdl = $this->co_reg->load->model('stkmatstk');
				/*Filtro los Materiales */
        $lv_flt='17,39,93,94,95,98,99,100,101,112,113,144,210,214,231,234,244,260,273,291,315,319,329,330,382,383,384,391,409,439,440,479,503,560,565,679,581,583,605,642,643,668,708,709,1881,2341';
        $lv_flt= str_replace(',', chr(10), $lv_flt);
  			
				$lv_prm = array('vewfldflt' =>'[~fltrow~]m.matcod'.chr(9).'IN'.chr(9).chr(9).$lv_flt.chr(9).chr(9));
				$lo_rsmatstk= $lo_stkmdl->getlist($lv_prm);
				$lv_data_sqlstm = $lo_stkmdl->getsysdata('sqlstm');
        //echo '<code>'.($lv_data_sqlstm).'</code>';
        //$lv_buf ='<table >';
        $lv_buf	='<tr>';
				$lv_buf.='<th>Lugar</th>';        
        $lv_buf.='<th>Material</th>';
        $lv_buf.='<th>Descripcion</th>';
        $lv_buf.='<th>Lote</th>';
        $lv_buf.='<th>Vencimiento</th>';
        $lv_buf.='<th>Serie</th>';
        $lv_buf.='<th>Cantidad</th>';
        $lv_buf.='</tr>';
        foreach ($lo_rsmatstk as $lv_row){
          $lv_buf.='<tr>';
          $lv_buf.='<td>'.$lv_row['stkobjtxt'].'</td>';
          $lv_buf.='<td>'.$lv_row['matcod'].'</td>';
          $lv_buf.='<td>'.$lv_row['mattxt'].'</td>';
          $lv_buf.='<td>'.$lv_row['matbchcodext'].'</td>';
          $lv_buf.='<td>'.$lv_row['matbchduedtecnv'].'</td>';
          $lv_buf.='<td>'.$lv_row['matsercodext'].'</td>';
          $lv_buf.='<td>'.$lv_row['matqty'].'</td>';
          $lv_buf.='</tr>';
        }

        // obtengo texto del mensaje
				$lv_usrmsg='';
        /*
				$lo_txtmdl = $this->co_reg->load->model('grldattxt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'STKMATSTKLST'.chr(9).chr(9).
																			'[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'STK_MAT_STK'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_txtmdl->getList($lv_prm);
				//$lv_data_sqlstm= $lo_rs['data_sqlstm'];
				//unset($lo_rs['data_sqlprm']); unset($lo_rs['data_sqltxt']); unset($lo_rs['data_sqlstm']);
				if( count($lo_rs)!=0 ) {
					$lv_usrmsg = $lo_rs[0]['txttxt'];
				} else {
					$lv_usrmsg = '';
					$lv_errcod = '-1';
					$lv_errtxt = 'No se encontró el texto del mensaje.';
				}
        */
        // obtengo mensaje de notificacion
        $lv_txtcodext = 'STKMATSTKLST';
        $lo_txtmdl = $this->co_reg->load->model('grldattxt');

        if( $lo_txtmdl->load(array('txtcodext' => $lv_txtcodext, 'txtsys' => 1), false) ){
            $lv_usrmsg = $lo_txtmdl->txttxt;
        } else {
          $lv_usrmsg = '';
          $lv_errcod = '-1';
          $lv_errtxt = 'No se encontró el texto del mensaje.';
        }
        
				//// determino destinatarios
				$lv_issisdev = stripos($_SERVER['REQUEST_URI'],'/sysdev/');
				
				if($lv_issisdev !== false){
					$lv_mailto[] = array('address'=>'grusso@teaminfusion.com');
					$lv_mailto[] = array('address'=>'cdominguez@teaminfusion.com');
					
				}else{
					$lv_mailto[] = array('address'=>'svento@logindoor.com.ar');
          $lv_mailto[] = array('address'=>'dt@logindoor.com.ar');
          $lv_mailto[] = array('address'=>'grusso@teaminfusion.com');
					$lv_mailto[] = array('address'=>'cdominguez@teaminfusion.com');
				
				}
        
				// envío mail
				if ( $lv_usrmsg!='') {
					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = $lv_mailto;
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>'Team Training ') );
					$lv_emlprm['subject'] = 'Reporte mensual de stock con lote y vencimiento (COVIDIEN)';
					$lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
					$lv_usrmsg = str_replace( '[%2]', $lv_buf , $lv_usrmsg);
					//$lv_usrmsg = str_replace( '[%4]', $this->co_reg->sec->usrtxt, $lv_usrmsg);
					//$lv_usrmsg = str_replace( '[%3]', utf8_decode($lo_post['crmcntsrctxt']), $lv_usrmsg);
					//$lo_post['crmcntrqs']=str_replace(chr(13),'<BR>',$lo_post['crmcntrqs']);
					//$lo_post['crmcntrqs']=$lo_post['crmcntrqs'].'<br><br><small>Interacci&oacute;n creada: '.$lv_now->format('d/m/Y').'</small>';
					//$lv_usrmsg = str_replace( '[%5]', utf8_decode($lo_post['crmcntrqs']), $lv_usrmsg);
					//$lv_usrmsg = str_replace( '[%6]', utf8_decode($lo_post['crmcntdte']), $lv_usrmsg);
					$lv_emlprm['bodyhtml'] = $lv_usrmsg;
					if ( $lo_eml->send( $lv_emlprm ) ) {
						$lv_errcod = '0';
						$lv_errtxt = 'Enviado';
					} else {
						$lv_errcod = '-1';
						$lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
						return '<errtyp>E</errtyp><errcod>'.$lv_errcod.'</errcod><errtxt>'.$lv_errtxt.'</errtxt>';
					}
				}
				return '<errtyp></errtyp><errcod></errcod><errtxt></errtxt>';
				break;
			
			
			
			
        
				// ---------------------------------------------------------------------
				//
				//	I M P R E S I O N E S
				//
				// ---------------------------------------------------------------------

        // S E G U I M I E N T O   O C A   S I M P L E
        // Todo el proceso queda dentro del case: transporte, cURL, XML y PDF.
        case '#lgnocatrkpnt':
        case '#lgnocatrksimplepnt':
          $lo_post = $this->co_reg->request->post;
          $lv_tracod = trim((string)($lp_prm['tracod']??($lo_post['tracod']??'')));

          // Cuando se ejecuta desde SYS_INT solo se valida la configuracion.
          if($lv_tracod==='' && isset($lo_post['sysint']) && is_array($lo_post['sysint'])){
            $lv_execatr = $lo_post['sysint']['sysintatr']??array();
            if(!is_array($lv_execatr)){
              $lv_execatr = array(
                'endpoint'=>$this->co_reg->document->getTagValue((string)$lv_execatr, 'endpoint'),
                'cuit'=>$this->co_reg->document->getTagValue((string)$lv_execatr, 'cuit')
              );
            }
            $lv_execendpoint = trim((string)($lv_execatr['endpoint']??''));
            $lv_execurl = parse_url($lv_execendpoint);
            if($lv_execendpoint==='' || trim((string)($lv_execatr['cuit']??''))===''){
              return array('errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'La interfaz debe informar endpoint y cuit.');
            }
            if(!is_array($lv_execurl) || strtolower((string)($lv_execurl['scheme']??''))!=='https' ||
               strtolower((string)($lv_execurl['host']??''))!=='webservice.oca.com.ar'){
              return array('errtyp'=>'E', 'errcod'=>-2, 'errtxt'=>'El endpoint debe ser HTTPS y pertenecer a webservice.oca.com.ar.');
            }
            return array('errtyp'=>'S', 'errcod'=>0, 'errtxt'=>'Configuracion OCA_TRACKING validada.');
          }

          if($lv_tracod==='' || !ctype_digit($lv_tracod) || intval($lv_tracod)<=0){
            return $this->co_reg->document->getJson(array(
              'errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'No se indico un transporte valido.'
            ));
          }

          $lo_tramdl = $this->co_reg->load->model('logtra');
          if(!$lo_tramdl->load(array('tracod'=>intval($lv_tracod), 'objtyp'=>'LOG_TRA'), false)){
            return $this->co_reg->document->getJson(array(
              'errtyp'=>'E', 'errcod'=>intval($lo_tramdl->errcod??-2),
              'errtxt'=>trim((string)($lo_tramdl->errtxt??'No se encontro el transporte.'))
            ));
          }

          $lo_tradata = array_change_key_case((array)$lo_tramdl->getData(), CASE_LOWER);
          $lv_transportista = strtoupper(trim((string)($lo_tradata['drvtxt']??'')));
          $lv_tracking = preg_replace('/\s+/', '', trim((string)($lo_tradata['tracodext']??'')));

          if($lv_transportista!=='OCA'){
            return $this->co_reg->document->getJson(array(
              'errtyp'=>'E', 'errcod'=>-3,
              'errtxt'=>'El transporte no corresponde a OCA.'
            ));
          }
          if($lv_tracking==='' || !ctype_digit($lv_tracking)){
            return $this->co_reg->document->getJson(array(
              'errtyp'=>'E', 'errcod'=>-4,
              'errtxt'=>'El transporte OCA no tiene un numero de tracking valido en el campo Codigo.'
            ));
          }
          if(!function_exists('curl_init')){
            return $this->co_reg->document->getJson(array(
              'errtyp'=>'E', 'errcod'=>-5, 'errtxt'=>'El servidor no tiene habilitada la extension cURL.'
            ));
          }

          // Recupera endpoint y parametros desde la interfaz configurada en el front.
          $lo_intmdl = $this->co_reg->load->model('sysint');
          $lv_intrs = $lo_intmdl->getList(array(
            'vewfldflt'=>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'OCA_TRACKING'.chr(9).chr(9).
                         '[~fltrow~]i.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
            'vewmaxrec'=>'1'
          ));
          if(!is_array($lv_intrs) || count($lv_intrs)===0 || !$lo_intmdl->load(array('sysintcod'=>$lv_intrs[0]['sysintcod']))){
            return $this->co_reg->document->getJson(array(
              'errtyp'=>'E', 'errcod'=>-6, 'errtxt'=>'No se pudo cargar la interfaz activa OCA_TRACKING.'
            ));
          }

          $lv_intatr = (string)$lo_intmdl->sysintatr;
          $lv_endpoint = trim((string)$this->co_reg->document->getTagValue($lv_intatr, 'endpoint'));
          $lv_cuit = trim((string)$this->co_reg->document->getTagValue($lv_intatr, 'cuit'));
          $lv_documento = trim((string)$this->co_reg->document->getTagValue($lv_intatr, 'documento'));
          if($lv_endpoint==='' || $lv_cuit===''){
            return $this->co_reg->document->getJson(array(
              'errtyp'=>'E', 'errcod'=>-7, 'errtxt'=>'La interfaz OCA_TRACKING debe informar endpoint y cuit.'
            ));
          }
          $lv_endpointparts = parse_url($lv_endpoint);
          if(!is_array($lv_endpointparts) || strtolower((string)($lv_endpointparts['scheme']??''))!=='https' ||
             strtolower((string)($lv_endpointparts['host']??''))!=='webservice.oca.com.ar'){
            return $this->co_reg->document->getJson(array(
              'errtyp'=>'E', 'errcod'=>-7,
              'errtxt'=>'El endpoint de OCA debe ser HTTPS y pertenecer a webservice.oca.com.ar.'
            ));
          }

          $lv_url = rtrim($lv_endpoint, '?&').'?'.
            http_build_query(array(
              'NroDocumentoCliente'=>$lv_documento,
              'CUIT'=>$lv_cuit,
              'Pieza'=>$lv_tracking
            ), '', '&', PHP_QUERY_RFC3986);

          // Mismo patron de conexion usado por getosdeapi_v2.
          $lo_curl = curl_init();
          curl_setopt_array($lo_curl, array(
            CURLOPT_URL=>$lv_url,
            CURLOPT_RETURNTRANSFER=>true,
            CURLOPT_ENCODING=>'',
            CURLOPT_MAXREDIRS=>10,
            CURLOPT_TIMEOUT=>0,
            CURLOPT_FOLLOWLOCATION=>true,
            CURLOPT_HTTP_VERSION=>CURL_HTTP_VERSION_1_1,
            CURLOPT_SSL_VERIFYPEER=>false,
            CURLOPT_SSL_VERIFYHOST=>0,
            CURLOPT_CUSTOMREQUEST=>'GET',
            CURLOPT_HTTPHEADER=>array('Accept: application/xml, text/xml;q=0.9')
          ));
          $lv_xmltxt = curl_exec($lo_curl);
          $lv_curlerrno = curl_errno($lo_curl);
          $lv_curlerror = curl_error($lo_curl);
          $lv_httpstatus = intval(curl_getinfo($lo_curl, CURLINFO_HTTP_CODE));
          if(PHP_VERSION_ID<80500){ curl_close($lo_curl); }

          if($lv_xmltxt===false){
            return $this->co_reg->document->getJson(array(
              'errtyp'=>'E', 'errcod'=>-8,
              'errtxt'=>'No se pudo consultar OCA (cURL '.$lv_curlerrno.'): '.$lv_curlerror
            ));
          }
          if($lv_httpstatus!==200){
            return $this->co_reg->document->getJson(array(
              'errtyp'=>'E', 'errcod'=>-9,
              'errtxt'=>'OCA respondio con estado HTTP '.$lv_httpstatus.'.'
            ));
          }

          $lv_libxmlprevious = libxml_use_internal_errors(true);
          $lo_xml = simplexml_load_string((string)$lv_xmltxt, 'SimpleXMLElement', LIBXML_NONET | LIBXML_NOBLANKS);
          libxml_clear_errors();
          libxml_use_internal_errors($lv_libxmlprevious);
          if($lo_xml===false){
            return $this->co_reg->document->getJson(array(
              'errtyp'=>'E', 'errcod'=>-10, 'errtxt'=>'OCA devolvio un XML invalido.'
            ));
          }

          $lo_envios = $lo_xml->xpath('//*[local-name()="NewDataSet"]/*[local-name()="Table"]');
          $lo_eventos = $lo_xml->xpath('//*[local-name()="NewDataSet"]/*[local-name()="Table1"]');
          if(!is_array($lo_envios) || count($lo_envios)===0){
            return $this->co_reg->document->getJson(array(
              'errtyp'=>'E', 'errcod'=>-11,
              'errtxt'=>'OCA no encontro informacion para el tracking '.$lv_tracking.'.'
            ));
          }

          // Respuesta estructurada obtenida directamente del XML de OCA.
          $lo_envio = $lo_envios[0];
          $lv_oca = array(
            'envio'=>array(
              'numero'=>trim((string)$lo_envio->NumeroEnvio),
              'remito'=>trim((string)$lo_envio->Remito),
              'paquetes'=>trim((string)$lo_envio->CantidadPaquetes),
              'retiro'=>array(
                'calle'=>trim((string)$lo_envio->DomicilioRetiro),
                'numero'=>trim((string)$lo_envio->NumeroRetiro),
                'localidad'=>trim((string)$lo_envio->LocalidadRetiro),
                'provincia'=>trim((string)$lo_envio->PciaRetiro),
                'codigo_postal'=>trim((string)$lo_envio->CodigoPostalRetiro)
              ),
              'entrega'=>array(
                'destinatario'=>trim((string)$lo_envio->Apellido.' '.(string)$lo_envio->Nombre),
                'calle'=>trim((string)$lo_envio->Calle),
                'numero'=>trim((string)$lo_envio->Numero),
                'localidad'=>trim((string)$lo_envio->Localidad),
                'provincia'=>trim((string)$lo_envio->Provincia),
                'codigo_postal'=>trim((string)$lo_envio->CodigoPostal)
              )
            ),
            'eventos'=>array()
          );

          foreach((array)$lo_eventos as $lo_evento){
            $lv_oca['eventos'][] = array(
              'fecha'=>trim((string)$lo_evento->Fecha),
              'estado'=>preg_replace('/\s+/u', ' ', trim((string)$lo_evento->Desdcripcion_Estado))
            );
          }
          $lv_oca['eventos'] = array_reverse($lv_oca['eventos']);

          $lf_html = function($lp_value){
            return htmlspecialchars((string)$lp_value, ENT_QUOTES, 'UTF-8');
          };
          $lf_fecha = function($lp_value){
            try{
              $lo_fecha = new DateTimeImmutable((string)$lp_value);
              return $lo_fecha->format('H:i:s')==='00:00:00'
                ? $lo_fecha->format('d/m/Y')
                : $lo_fecha->format('d/m/Y H:i');
            }catch(Exception $lo_exception){ return (string)$lp_value; }
          };

          $lv_ultimoestado = $lv_oca['eventos'][0]['estado']??'Envio registrado en OCA';
          $lv_ultimafecha = isset($lv_oca['eventos'][0]) ? $lf_fecha($lv_oca['eventos'][0]['fecha']) : '';
          $lv_retiro = trim($lv_oca['envio']['retiro']['calle'].' '.$lv_oca['envio']['retiro']['numero']);
          $lv_retiroloc = trim($lv_oca['envio']['retiro']['codigo_postal'].' - '.$lv_oca['envio']['retiro']['localidad'].' - '.$lv_oca['envio']['retiro']['provincia'], ' -');
          $lv_entrega = trim($lv_oca['envio']['entrega']['calle'].' '.$lv_oca['envio']['entrega']['numero']);
          $lv_entregaloc = trim($lv_oca['envio']['entrega']['codigo_postal'].' - '.$lv_oca['envio']['entrega']['localidad'].' - '.$lv_oca['envio']['entrega']['provincia'], ' -');

          $lv_html = '<table cellpadding="7" style="background-color:#49a4df;color:#ffffff;">'.
              '<tr><td width="35%" style="font-size:15px;"><b>LOGINDOOR</b></td>'.
              '<td width="65%" style="font-size:11px;text-align:right;"><b>DETALLE DEL ENVIO OCA</b><br>Tracking '.$lf_html($lv_tracking).'</td></tr>'.
            '</table><br><br>'.
            '<table cellpadding="5" style="border:1px solid #dce7ee;">'.
              '<tr style="background-color:#e9f6ef;color:#1e6d4a;">'.
                '<td><b>ESTADO ACTUAL</b><br>'.$lf_html($lv_ultimoestado).'<br>'.$lf_html($lv_ultimafecha).'</td>'.
              '</tr>'.
            '</table><br><br>'.
            '<table cellpadding="4" style="border:1px solid #dce7ee;">'.
              '<tr style="background-color:#49a4df;color:#ffffff;">'.
                '<td width="40%"><b>Numero de envio</b></td><td width="30%"><b>Remito</b></td><td width="30%"><b>Paquetes</b></td>'.
              '</tr>'.
              '<tr><td>'.$lf_html($lv_oca['envio']['numero']).'</td><td>'.$lf_html($lv_oca['envio']['remito']).'</td><td>'.$lf_html($lv_oca['envio']['paquetes']).'</td></tr>'.
            '</table><br><br>'.
            '<table cellpadding="4" style="border:1px solid #dce7ee;">'.
              '<tr style="background-color:#49a4df;color:#ffffff;"><td width="50%"><b>RETIRO</b></td><td width="50%"><b>ENTREGA</b></td></tr>'.
              '<tr><td>'.$lf_html($lv_retiro).'<br>'.$lf_html($lv_retiroloc).'</td>'.
              '<td><b>'.$lf_html($lv_oca['envio']['entrega']['destinatario']).'</b><br>'.$lf_html($lv_entrega).'<br>'.$lf_html($lv_entregaloc).'</td></tr>'.
            '</table><br><br>'.
            '<table cellpadding="3" style="border:1px solid #dce7ee;">'.
              '<thead><tr style="background-color:#49a4df;color:#ffffff;"><th width="25%"><b>FECHA</b></th><th width="75%"><b>EVENTO</b></th></tr></thead><tbody>';

          foreach($lv_oca['eventos'] as $lv_indice=>$lv_evento){
            $lv_html .= '<tr style="background-color:'.($lv_indice%2===0?'#f4f8fa':'#ffffff').';">'.
              '<td width="25%">'.$lf_html($lf_fecha($lv_evento['fecha'])).'</td>'.
              '<td width="75%">'.$lf_html($lv_evento['estado']).'</td></tr>';
          }
          $lv_html .= '</tbody></table>';

          if(!class_exists('TCPDF', false)){
            require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');
          }
          $lo_pdf = new TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);
          $lo_pdf->SetCreator('Temasis');
          $lo_pdf->SetAuthor('Logindoor');
          $lo_pdf->SetTitle('Detalle de envio OCA '.$lv_tracking);
          $lo_pdf->SetMargins(10, 10, 10);
          $lo_pdf->SetAutoPageBreak(true, 10);
          $lo_pdf->SetFont('helvetica', '', 8.5);
          $lo_pdf->setCellHeightRatio(1.05);
          $lo_pdf->setPrintHeader(false);
          $lo_pdf->setPrintFooter(false);
          $lo_pdf->AddPage();
          $lo_pdf->writeHTML($lv_html, true, false, true, false, '');

          $lv_filename = 'Detalle_envio_OCA_'.$lv_tracking.'.pdf';
          $this->co_reg->response->addHeader('Content-Type: application/pdf');
          $this->co_reg->response->addHeader('Content-Disposition: inline; filename="'.$lv_filename.'"');
          return $lo_pdf->Output($lv_filename, 'S');
          break;

        // H O J A   D E   R U T A   D E L   T R A N S P O R T I S T A
        // Actividad para la clase de mensaje LOG_TRA desde la opcion Compartir.
        case '#lgntrardmpnt':
          $lo_post = $this->co_reg->request->post;
          $lv_tracod = $lo_post['tracod']??($lp_prm['tracod']??'');
          $lv_tracod = trim((string)$lv_tracod);
          if($lv_tracod==='' || !ctype_digit($lv_tracod) || intval($lv_tracod)<=0){
            return $this->co_reg->document->getJson(array(
              'errtyp'=>'E', 'errcod'=>-1,
              'errtxt'=>'No se indico un transporte valido para imprimir.'
            ));
          }

          $lo_tramdl = $this->co_reg->load->model('logtra');
          if(!$lo_tramdl->load(array('tracod'=>intval($lv_tracod), 'objtyp'=>'LOG_TRA'), false)){
            return $this->co_reg->document->getJson(array(
              'errtyp'=>'E', 'errcod'=>$lo_tramdl->errcod,
              'errtxt'=>$lo_tramdl->errtxt
            ));
          }
          $lo_tradat = $lo_tramdl->getData();
          if(trim((string)($lo_tradat['tracod']??''))===''){
            return $this->co_reg->document->getJson(array(
              'errtyp'=>'E', 'errcod'=>-2,
              'errtxt'=>'No se encontro el transporte solicitado.'
            ));
          }

          // LOG_TRA_DEF ya devuelve en "dlv" las mismas paradas que muestra
          // la pantalla de Transporte. Se utiliza esa fuente para que la grilla
          // y la hoja de ruta no dependan de consultas diferentes.
          $lo_dlvrs = $lo_tradat['dlv']??array();
          if(is_string($lo_dlvrs)){
            $lv_dlvjson = json_decode(utf8_encode($lo_dlvrs), true);
            $lo_dlvrs = is_array($lv_dlvjson) ? $lv_dlvjson : array();
          }
          if(!is_array($lo_dlvrs)){ $lo_dlvrs = array(); }
          foreach($lo_dlvrs as $lv_index=>$lv_row){
            if(is_array($lv_row)){ $lo_dlvrs[$lv_index] = array_change_key_case($lv_row, CASE_LOWER); }
          }

          // Los ingresos se imprimen como retiros (origen); el resto como entregas (destino).
          $lv_dlvuniq = array();
          foreach($lo_dlvrs as $lv_row){
            $lv_key = trim((string)($lv_row['tradlvcod']??''));
            if($lv_key===''){ $lv_key = trim((string)($lv_row['stkmovdoccod']??'')); }
            if($lv_key==='' || isset($lv_dlvuniq[$lv_key])){ continue; }

            $lv_isin = strtoupper(trim((string)($lv_row['stkmovobjtyp']??'')))==='STK_SIN';
            $lv_prefix = $lv_isin ? 'src' : 'dst';
            $lv_row['routeoperation'] = $lv_isin ? 'RETIRO' : 'ENTREGA';
            $lv_row['dstobjtyp'] = $lv_row[$lv_prefix.'objtyp']??'';
            $lv_row['dstobjcod'] = $lv_row[$lv_prefix.'objcod']??'';
            $lv_row['dstcntcod'] = $lv_row[$lv_prefix.'cntcod']??'';
            $lv_row['dstobjtxt'] = $lv_row[$lv_prefix.'objtxt']??'';
            $lv_row['dstcnttxt'] = $lv_row[$lv_prefix.'cnttxt']??'';
            $lv_dlvuniq[$lv_key] = $lv_row;
          }
          $lo_dlvrs = array_values($lv_dlvuniq);
          usort($lo_dlvrs, function($lp_a, $lp_b){
            $lv_ordcmp = intval($lp_a['tradlvord']??0) <=> intval($lp_b['tradlvord']??0);
            if($lv_ordcmp!==0){ return $lv_ordcmp; }
            return intval($lp_a['stkmovdoccod']??0) <=> intval($lp_b['stkmovdoccod']??0);
          });

          // Carga en bloque los contactos y domicilios, evitando una consulta por parada.
          $lv_cntids = array();
          $lv_objids = array();
          foreach($lo_dlvrs as $lv_row){
            $lv_cntcod = trim((string)($lv_row['dstcntcod']??''));
            if($lv_cntcod!=='' && $lv_cntcod!=='0'){ $lv_cntids[$lv_cntcod] = true; }
            $lv_objtyp = trim((string)($lv_row['dstobjtyp']??''));
            $lv_objcod = trim((string)($lv_row['dstobjcod']??''));
            if($lv_objtyp!=='' && $lv_objcod!==''){ $lv_objids[$lv_objtyp][$lv_objcod] = true; }
          }

          $lv_dstdat = array('cnttxt'=>array(), 'cntadr'=>array(), 'objadr'=>array());
          if(count($lv_cntids)>0){
            $lv_cntcodlst = implode(chr(10), array_keys($lv_cntids));
            $lo_cntmdl = $this->co_reg->load->model('grldatcnt');
            $lo_cntrs = $lo_cntmdl->getList(array(
              'vewfldflt'=>'[~fltrow~]c.cntcod'.chr(9).'IN'.chr(9).chr(9).$lv_cntcodlst.chr(9).chr(9),
              'vewmaxrec'=>9999
            ), array(), null, false);
            if(is_array($lo_cntrs) && !isset($lo_cntrs['errtyp'])){
              foreach($lo_cntrs as $lv_row){
                $lv_cntcod = trim((string)($lv_row['cntcod']??''));
                if($lv_cntcod!=='' && !isset($lv_dstdat['cnttxt'][$lv_cntcod])){
                  $lv_dstdat['cnttxt'][$lv_cntcod] = $lv_row['cnttxt']??'';
                }
              }
            }

            $lo_adrmdl = $this->co_reg->load->model('grldatadr');
            $lo_adrrs = $lo_adrmdl->getList(array(
              'vewfldflt'=>'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                           '[~fltrow~]a.adrsrctyp'.chr(9).'='.chr(9).chr(9).'GRL_CCT'.chr(9).chr(9).
                           '[~fltrow~]a.adrsrccod'.chr(9).'IN'.chr(9).chr(9).$lv_cntcodlst.chr(9).chr(9),
              'vewfldord'=>'a.ctedte desc',
              'vewmaxrec'=>9999
            ));
            if(is_array($lo_adrrs) && !isset($lo_adrrs['errtyp'])){
              foreach($lo_adrrs as $lv_row){
                $lv_cntcod = trim((string)($lv_row['adrsrccod']??''));
                if($lv_cntcod!=='' && !isset($lv_dstdat['cntadr'][$lv_cntcod])){
                  $lv_dstdat['cntadr'][$lv_cntcod] = $lv_row;
                }
              }
            }
          }

          foreach($lv_objids as $lv_objtyp=>$lv_cods){
            $lo_adrmdl = $this->co_reg->load->model('grldatadr');
            $lo_adrrs = $lo_adrmdl->getList(array(
              'vewfldflt'=>'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                           '[~fltrow~]a.adrsrctyp'.chr(9).'='.chr(9).chr(9).$lv_objtyp.chr(9).chr(9).
                           '[~fltrow~]a.adrsrccod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), array_keys($lv_cods)).chr(9).chr(9),
              'vewfldord'=>'a.ctedte desc',
              'vewmaxrec'=>9999
            ));
            if(!is_array($lo_adrrs) || isset($lo_adrrs['errtyp'])){ continue; }
            foreach($lo_adrrs as $lv_row){
              $lv_objcod = trim((string)($lv_row['adrsrccod']??''));
              $lv_key = $lv_objtyp.'|'.$lv_objcod;
              if($lv_objcod!=='' && !isset($lv_dstdat['objadr'][$lv_key])){
                $lv_dstdat['objadr'][$lv_key] = $lv_row;
              }
            }
          }

          $lf_routeaddress = function($lp_adr){
            if(!is_array($lp_adr) || count($lp_adr)===0){ return ''; }
            $lv_ret = array();
            $lv_street = trim((string)($lp_adr['adrstr']??($lp_adr['adrstrnme']??'')));
            $lv_number = trim((string)($lp_adr['adrstrnum']??''));
            if($lv_street!=='' || $lv_number!==''){
              $lv_ret[] = trim($lv_street.($lv_number!==''?' '.$lv_number:''));
            }
            $lv_unit = array();
            if(trim((string)($lp_adr['adrstrbld']??''))!==''){ $lv_unit[] = 'Edif. '.trim((string)$lp_adr['adrstrbld']); }
            if(trim((string)($lp_adr['adrstrflr']??''))!==''){ $lv_unit[] = 'Piso '.trim((string)$lp_adr['adrstrflr']); }
            if(trim((string)($lp_adr['adrstrunt']??''))!==''){ $lv_unit[] = 'Dto. '.trim((string)$lp_adr['adrstrunt']); }
            if(count($lv_unit)>0){ $lv_ret[] = implode(' - ', $lv_unit); }
            foreach(array('adrzontxt','adrzon','adrtwntxt','adrcty','lndregtxt','lndtxt') as $lv_key){
              $lv_value = trim((string)($lp_adr[$lv_key]??''));
              if($lv_value!=='' && !in_array($lv_value, $lv_ret, true)){ $lv_ret[] = $lv_value; }
            }
            $lv_postcode = trim((string)($lp_adr['adrpstcod']??''));
            if($lv_postcode!==''){ $lv_ret[] = 'CP '.$lv_postcode; }
            return implode(', ', $lv_ret);
          };

          $lf_routephones = function($lp_adr){
            if(!is_array($lp_adr)){ return ''; }
            $lv_ret = array();
            foreach(array('adrmblphn','adrphn001','adrphn002','adremgphn') as $lv_key){
              $lv_value = trim((string)($lp_adr[$lv_key]??''));
              if($lv_value!=='' && !in_array($lv_value, $lv_ret, true)){ $lv_ret[] = $lv_value; }
            }
            return implode(' / ', $lv_ret);
          };

          $lv_stops = array();
          foreach($lo_dlvrs as $lv_index=>$lv_row){
            $lv_cntcod = trim((string)($lv_row['dstcntcod']??''));
            $lv_objkey = trim((string)($lv_row['dstobjtyp']??'')).'|'.trim((string)($lv_row['dstobjcod']??''));
            $lv_cnttxt = $lv_dstdat['cnttxt'][$lv_cntcod]??($lv_row['dstcnttxt']??'');
            $lv_objtxt = $lv_row['dstobjtxt']??'';
            if(trim((string)$lv_objtxt)==='' && isset($lv_dstdat['objadr'][$lv_objkey])){
              $lv_objtxt = $lv_dstdat['objadr'][$lv_objkey]['adrnme001']??'';
            }
            $lv_adr = array();
            if($lv_cntcod!=='' && isset($lv_dstdat['cntadr'][$lv_cntcod])){
              $lv_adr = $lv_dstdat['cntadr'][$lv_cntcod];
            }else if(isset($lv_dstdat['objadr'][$lv_objkey])){
              $lv_adr = $lv_dstdat['objadr'][$lv_objkey];
            }

            $lv_stops[] = array(
              'order'=>intval($lv_row['tradlvord']??0)>0 ? intval($lv_row['tradlvord']) : ($lv_index+1),
              'operation'=>$lv_row['routeoperation']??'ENTREGA',
              'document_number'=>$lv_row['stkmovdoccodext']??'',
              'movement_id'=>$lv_row['stkmovdoccod']??'',
              'destination'=>$lv_objtxt,
              'contact'=>$lv_cnttxt,
              'address'=>$lf_routeaddress($lv_adr),
              'phones'=>$lf_routephones($lv_adr),
              'email'=>trim((string)($lv_adr['adreml']??'')),
              'map_reference'=>trim((string)($lv_adr['adrmapgeo']??'')),
              'comments'=>trim((string)($lv_row['tradlvisucmt']??''))
            );
          }

          $lv_data = array(
            'tracod'=>$lo_tradat['tracod']??'',
            'tracodext'=>$lo_tradat['tracodext']??'',
            'tradte'=>$lo_tradat['tradte']??'',
            'traroutxt'=>$lo_tradat['traroutxt']??'',
            'drvtxt'=>$lo_tradat['drvtxt']??'',
            'vhccodext'=>$lo_tradat['vhccodext']??'',
            'printedat'=>new DateTime(),
            'printedby'=>$this->co_reg->sec->usrtxt??($this->co_reg->sec->usrcod??''),
            'stops'=>$lv_stops
          );

          $lv_filenamecod = trim((string)($lv_data['tracodext']??''));
          if($lv_filenamecod===''){ $lv_filenamecod = trim((string)($lv_data['tracod']??'')); }
          $lv_filenamecod = preg_replace('/[^A-Za-z0-9_-]+/', '_', $lv_filenamecod);
          $lv_filename = 'Hoja_de_ruta_'.$lv_filenamecod.'.pdf';

          $this->co_reg->response->addHeader('Content-Type: application/pdf');
          $this->co_reg->response->addHeader('Content-Disposition: inline; filename="'.$lv_filename.'"');

          require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

          $lf_pdftext = function($lp_value){
            if($lp_value instanceof DateTimeInterface){
              $lp_value = $lp_value->format('d/m/Y H:i');
            }
            $lv_value = (string)$lp_value;
            if(function_exists('mb_check_encoding') && !mb_check_encoding($lv_value, 'UTF-8')){
              $lv_value = mb_convert_encoding($lv_value, 'UTF-8', 'ISO-8859-1');
            }
            return htmlspecialchars($lv_value, ENT_QUOTES, 'UTF-8');
          };

          $lf_pdfdate = function($lp_value, $lp_withtime=false){
            if($lp_value instanceof DateTimeInterface){
              return $lp_value->format($lp_withtime?'d/m/Y H:i':'d/m/Y');
            }
            $lv_value = trim((string)$lp_value);
            if($lv_value===''){ return ''; }
            try{
              $lv_date = new DateTime($lv_value);
              return $lv_date->format($lp_withtime?'d/m/Y H:i':'d/m/Y');
            }catch(Exception $lo_exception){
              return $lv_value;
            }
          };

          $lv_routecode = trim((string)($lv_data['tracodext']??''));
          if($lv_routecode===''){ $lv_routecode = '#'.($lv_data['tracod']??''); }
          $lv_routedate = $lf_pdfdate($lv_data['tradte']??'');
          $lv_printedat = $lf_pdfdate($lv_data['printedat']??'', true);
          $lv_stops = (isset($lv_data['stops']) && is_array($lv_data['stops'])) ? $lv_data['stops'] : array();

          $lo_pdf = new class('L', 'mm', 'A4', true, 'UTF-8', false) extends TCPDF {
            private $routeCode = '';
            private $routeId = '';
            private $routeDate = '';
            private $printedAt = '';
            private $printedBy = '';
            private $logoPath = 'library/images/logos/zcutp1_logindoor.jpg';

            public function setRouteIdentity($lp_code, $lp_id, $lp_date, $lp_printedat, $lp_printedby){
              $this->routeCode = (string)$lp_code;
              $this->routeId = (string)$lp_id;
              $this->routeDate = (string)$lp_date;
              $this->printedAt = (string)$lp_printedat;
              $this->printedBy = (string)$lp_printedby;
            }

            public function Header(){
              $this->SetFillColor(246, 246, 246);
              $this->Rect(0, 0, $this->getPageWidth(), 27, 'F');

              if(is_file($this->logoPath) && @getimagesize($this->logoPath)!==false){
                $this->Image($this->logoPath, 9, 5, 55, 0, '', '', 'T', false, 300);
              }else{
                $this->SetTextColor(35, 35, 35);
                $this->SetFont('helvetica', 'B', 14);
                $this->SetXY(9, 8);
                $this->Cell(55, 8, 'LOGINDOOR', 0, 0, 'L');
              }

              $this->SetTextColor(42, 42, 42);
              $this->SetFont('helvetica', 'B', 16);
              $this->SetXY(72, 5);
              $this->Cell(115, 8, 'HOJA DE RUTA #'.$this->routeId, 0, 0, 'L');
              $this->SetFont('helvetica', '', 7.5);
              $this->SetTextColor(95, 95, 95);
              $this->SetXY(72, 14);
              $this->Cell(115, 5, 'DOCUMENTO OPERATIVO PARA EL TRANSPORTISTA', 0, 0, 'L');

              $this->SetTextColor(42, 42, 42);
              $this->SetFont('helvetica', 'B', 11);
              $this->SetXY(198, 6);
              $this->Cell(90, 6, 'TRANSPORTE '.$this->routeCode, 0, 0, 'R');
              $this->SetFont('helvetica', '', 8);
              $this->SetTextColor(95, 95, 95);
              $this->SetXY(198, 14);
              $this->Cell(90, 5, $this->routeDate, 0, 0, 'R');

              $this->SetDrawColor(150, 150, 150);
              $this->Line(9, 27, $this->getPageWidth()-9, 27);
              $this->SetTextColor(0, 0, 0);
            }

            public function Footer(){
              $this->SetY(-10);
              $this->SetDrawColor(185, 185, 185);
              $this->Line(9, $this->GetY(), $this->getPageWidth()-9, $this->GetY());
              $this->SetY(-8);
              $this->SetTextColor(95, 95, 95);
              $this->SetFont('helvetica', '', 6.5);
              $this->Cell(220, 4, 'Impreso '.$this->printedAt.($this->printedBy!==''?' - '.$this->printedBy:''), 0, 0, 'L');
              $this->Cell(68, 4, 'Pagina '.$this->getAliasNumPage().' de '.$this->getAliasNbPages(), 0, 0, 'R');
            }
          };

          $lo_pdf->SetCreator('Temasis');
          $lo_pdf->SetAuthor('Logindoor');
          $lo_pdf->SetTitle('Hoja de ruta '.$lv_routecode);
          $lo_pdf->SetSubject('Hoja de ruta para el transportista');
          $lo_pdf->SetKeywords('hoja de ruta, transporte, entregas');
          $lo_pdf->setRouteIdentity($lv_routecode, $lv_data['tracod']??'', $lv_routedate, $lv_printedat, $lv_data['printedby']??'');
          $lo_pdf->SetMargins(9, 31, 9);
          $lo_pdf->setPrintHeader(false);
          $lo_pdf->SetHeaderMargin(0);
          $lo_pdf->SetFooterMargin(5);
          $lo_pdf->SetAutoPageBreak(true, 13);
          $lo_pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
          $lo_pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
          $lo_pdf->setCellHeightRatio(1.0);
          $lo_pdf->AddPage('L');
          $lo_pdf->Header();
          $lo_pdf->SetY(31);

          $lv_summary = '<table width="100%" cellpadding="2" cellspacing="0" border="1" bordercolor="#b8b8b8">'.
            '<tr bgcolor="#eeeeee">'.
              '<td width="12%"><font size="6.5" color="#666666">FECHA</font><br><b>'.$lf_pdftext($lv_routedate!==''?$lv_routedate:'Sin informar').'</b></td>'.
              '<td width="23%"><font size="6.5" color="#666666">CHOFER</font><br><b>'.$lf_pdftext(($lv_data['drvtxt']??'')!==''?$lv_data['drvtxt']:'Sin informar').'</b></td>'.
              '<td width="15%"><font size="6.5" color="#666666">VEHICULO</font><br><b>'.$lf_pdftext(($lv_data['vhccodext']??'')!==''?$lv_data['vhccodext']:'Sin informar').'</b></td>'.
              '<td width="25%"><font size="6.5" color="#666666">RUTA</font><br><b>'.$lf_pdftext(($lv_data['traroutxt']??'')!==''?$lv_data['traroutxt']:'Sin informar').'</b></td>'.
              '<td width="7%" align="center"><font size="6.5" color="#666666">PARADAS</font><br><b>'.count($lv_stops).'</b></td>'.
              '<td width="9%" align="center"><font size="6.5" color="#666666">HORA INICIO</font><br><b>________</b></td>'.
              '<td width="9%" align="center"><font size="6.5" color="#666666">HORA FIN</font><br><b>________</b></td>'.
            '</tr>'.
          '</table>';
          $lo_pdf->SetFont('helvetica', '', 8);
          $lo_pdf->writeHTML($lv_summary, true, false, true, false, '');

          $lv_tablehead = '<table width="100%" cellpadding="2" cellspacing="0" border="1" bordercolor="#9c9c9c">'.
            '<thead>'.
              '<tr bgcolor="#555555" style="color:#ffffff;">'.
                '<th width="14%" align="center"><b>ORDEN / REMITO / MOV.</b></th>'.
                '<th width="34%"><b>DESTINO Y DIRECCION</b></th>'.
                '<th width="20%"><b>CONTACTO</b></th>'.
                '<th width="16%"><b>COMENTARIOS</b></th>'.
                '<th width="16%"><b>REGISTRO MANUAL</b></th>'.
              '</tr>'.
            '</thead><tbody>';

          $lv_tablerows = array();
          if(count($lv_stops)===0){
            $lv_tablerows[] = '<tr><td colspan="5" align="center"><br><b>El transporte no tiene paradas asociadas.</b><br></td></tr>';
          }

          foreach($lv_stops as $lv_index=>$lv_stop){
            $lv_destination = trim((string)($lv_stop['destination']??''));
            $lv_contact = trim((string)($lv_stop['contact']??''));
            if($lv_destination===''){ $lv_destination = $lv_contact!=='' ? $lv_contact : 'Destino sin informar'; }

            $lv_document = trim((string)($lv_stop['document_number']??''));
            if($lv_document===''){ $lv_document = 'Sin numero externo'; }

            $lv_contacthtml = $lv_contact!=='' ? '<b>'.$lf_pdftext($lv_contact).'</b><br>' : '';
            if(trim((string)($lv_stop['phones']??''))!==''){
              $lv_contacthtml .= $lf_pdftext($lv_stop['phones']).'<br>';
            }
            if(trim((string)($lv_stop['email']??''))!==''){
              $lv_contacthtml .= $lf_pdftext($lv_stop['email']).'<br>';
            }
            if($lv_contacthtml===''){
              $lv_contacthtml = '<font color="#777777">Sin datos de contacto</font>';
            }

            $lv_comments = trim((string)($lv_stop['comments']??''));
            if($lv_comments===''){ $lv_comments = '-'; }

            $lv_mapreference = trim((string)($lv_stop['map_reference']??''));
            $lv_address = trim((string)($lv_stop['address']??''));
            if($lv_address===''){ $lv_address = 'Domicilio sin informar'; }

            $lv_bgcolor = ($lv_index%2===0) ? '#ffffff' : '#f1f1f1';
            $lv_tablerows[] = '<tr bgcolor="'.$lv_bgcolor.'">'.
              '<td width="14%" align="center"><font size="10"><b>'.$lf_pdftext($lv_stop['order']??($lv_index+1)).'</b></font><br>'.
                '<font size="7.5"><b>'.$lf_pdftext($lv_document).'</b></font><br>'.
                '<font size="6" color="#666666">ID mov.: '.$lf_pdftext($lv_stop['movement_id']??'').'</font>'.
              '</td>'.
              '<td width="34%"><font size="8"><b>'.$lf_pdftext($lv_destination).'</b></font><br>'.
                '<font size="6" color="#555555"><b>'.$lf_pdftext($lv_stop['operation']??'ENTREGA').'</b></font><br>'.
                $lf_pdftext($lv_address).
                ($lv_mapreference!==''?'<br><font size="6" color="#666666">GPS: '.$lf_pdftext($lv_mapreference).'</font>':'').
              '</td>'.
              '<td width="20%">'.$lv_contacthtml.'</td>'.
              '<td width="16%">'.$lf_pdftext($lv_comments).'</td>'.
              '<td width="16%"><font size="11"><b>[&nbsp;&nbsp;&nbsp;]</b></font><font size="6.5"> ENTREGADO</font><br>'.
                '<font size="11"><b>[&nbsp;&nbsp;&nbsp;]</b></font><font size="6.5"> NO ENTREGADO</font><br>'.
                '<font size="6.5"><b>HORA:</b> __________</font></td>'.
            '</tr>';
          }

          $lo_pdf->SetFont('helvetica', '', 6.8);
          $lv_pageqty = max(1, intval(ceil(count($lv_tablerows)/12)));
          $lv_rowsperpage = intval(ceil(count($lv_tablerows)/$lv_pageqty));
          $lv_tablepages = array_chunk($lv_tablerows, max(1, $lv_rowsperpage));
          foreach($lv_tablepages as $lv_pageindex=>$lv_pagerows){
            if($lv_pageindex>0){
              $lo_pdf->AddPage('L');
              $lo_pdf->Header();
              $lo_pdf->SetY(31);
            }
            $lo_pdf->writeHTML($lv_tablehead.implode('', $lv_pagerows).'</tbody></table>', true, false, true, false, '');
          }

          $lo_pdf->Ln(2);
          if($lo_pdf->GetY()>168){
            $lo_pdf->AddPage('L');
            $lo_pdf->Header();
            $lo_pdf->SetY(31);
          }
          $lv_obsy = $lo_pdf->GetY();
          $lo_pdf->SetDrawColor(150, 150, 150);
          $lo_pdf->SetTextColor(65, 65, 65);
          $lo_pdf->SetFont('helvetica', 'B', 7);
          $lo_pdf->MultiCell(180, 22, "OBSERVACIONES:\n", 1, 'L', false, 0, 9, $lv_obsy, true, 0, false, true, 22, 'T');
          $lo_pdf->SetTextColor(0, 0, 0);
          $lo_pdf->SetFont('helvetica', '', 8);
          $lo_pdf->SetXY(195, $lv_obsy+9);
          $lo_pdf->Cell(93, 6, 'Firma del chofer: _______________________________', 0, 1, 'L');

          return $lo_pdf->Output($lv_filename, 'S');
          break;
				
				//    P R E S U P U E S T O
				case '#slsordqtapnt':

				// obtengo datos del documento
				$lo_slsordmdl = $this->co_reg->load->model('slsord');
				$lv_slsordcod = (isset($this->co_reg->request->post['slsordcod'])?$this->co_reg->request->post['slsordcod']:$lp_prm['slsordcod']);
				$lo_slsordmdl->load( array('slsordcod'=>$lv_slsordcod), false );
        
        
        // Obtengo la direccion
        $lo_adrmdl = $this->co_reg->load->model('grldatadr');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]a.adrsrctyp '.chr(9).'='.chr(9).chr(9).$lo_slsordmdl->dstobjtyp.chr(9).chr(9).
																			'[~fltrow~]a.adrsrccod '.chr(9).'='.chr(9).chr(9).$lo_slsordmdl->dstobjcod.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_adrmdl->getList($lv_prm);
        
        if(count($lo_rs)>0){
          $lo_slsordmdl->dstobjadrstr=$lo_rs[0]['adrstr'];
          $lo_slsordmdl->dstobjadrstrnum=$lo_rs[0]['adrstrnum'];
          $lo_slsordmdl->dstobjadrstrflr=$lo_rs[0]['adrstrflr'];
          $lo_slsordmdl->dstobjadrstrunt=$lo_rs[0]['adrstrunt'];
          $lo_slsordmdl->dstobjadrstrbld=$lo_rs[0]['adrstrbld'];
          $lo_slsordmdl->dstobjlndregtxt=$lo_rs[0]['lndregtxt'];
          $lo_slsordmdl->dstobjadrpstcod=$lo_rs[0]['adrpstcod'];
        }
        
        
        // cargo textos de cotizacion
       	$lo_txtmdl = $this->co_reg->load->model('grldattxt');
       	$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9). 'SLS_QTA' .chr(9).chr(9).
       								 							 '[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9). $lo_slsordmdl->slsordcod .chr(9).chr(9) );
       	$lo_txtrs = $lo_txtmdl->getList( $lv_prm );
        
				// obtengo nombre de la persona que creó el documento
				$lo_usrmdl = $this->co_reg->load->model('syssecusr');
				$lo_usrmdl->load( array('usrcod'=>$lo_slsordmdl->cteusr) );
				$lo_slsordmdl->cteusrtxt = $lo_usrmdl->usrtxt;

				$this->co_reg->response->addHeader('Content-type:application/pdf');
        $lv_buffer = $this->co_reg->document->getView('zcutp1_lgnslsordqtapnt', array('data'=>$lo_slsordmdl,'txt'=>$lo_txtrs,'actcod'=>$this->data['actcod']) );
				return $lv_buffer;
				break;
      
      // I M P R E S I O N   O R D E N   D E   R E T I R O 
			case '#movdocmovretpnt':

				// obtengo datos del documento
				$lo_stkmovmdl = $this->co_reg->load->model('stkmovdoc');
				$lv_stkmovdoccod = (isset($this->co_reg->request->post['stkmovdoccod'])?$this->co_reg->request->post['stkmovdoccod']:$lp_prm['stkmovdoccod']);
				$lo_stkmovmdl->load( array('stkmovdoccod'=>$lv_stkmovdoccod), false );
        
        // Obtengo la direccion
        $lo_adrmdl = $this->co_reg->load->model('grldatadr');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]a.adrsrctyp '.chr(9).'='.chr(9).chr(9).$lo_stkmovmdl->srcobjtyp.chr(9).chr(9).
																			'[~fltrow~]a.adrsrccod '.chr(9).'='.chr(9).chr(9).$lo_stkmovmdl->srcobjcod.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_adrmdl->getList($lv_prm);
        
        if(count($lo_rs)>0){
          $lo_stkmovmdl->dstobjadrstr=$lo_rs[0]['adrstr'];
          $lo_stkmovmdl->dstobjadrstrnum=$lo_rs[0]['adrstrnum']??'';
          $lo_stkmovmdl->dstobjadrstrflr=$lo_rs[0]['adrstrflr']??'';
          $lo_stkmovmdl->dstobjadrstrunt=$lo_rs[0]['adrstrunt']??'';
          $lo_stkmovmdl->dstobjadrstrbld=$lo_rs[0]['adrstrbld']??'';
          $lo_stkmovmdl->dstobjlndregtxt=$lo_rs[0]['lndregtxt']??'';
          $lo_stkmovmdl->dstobjadrpstcod=$lo_rs[0]['adrpstcod']??'';
          
          
        }
        
       
        
				// obtengo nombre de la persona que creó el documento
				$lo_usrmdl = $this->co_reg->load->model('syssecusr');
				$lo_usrmdl->load( array('usrcod'=>$lo_stkmovmdl->cteusr) );
				$lo_stkmovmdl->cteusrtxt = $lo_usrmdl->usrtxt;

				$this->co_reg->response->addHeader('Content-type:application/pdf');
				return $this->co_reg->document->getView('zcutp1_lgnslsordqtapnt', array('data'=>$lo_stkmovmdl,'actcod'=>'movdocmovret') );
				break;
			
			
			
			//   O R D E N   D E   C O M P R A
			case '#buyordordpnt':

				// obtengo datos del documento
				$lo_buyordmdl = $this->co_reg->load->model('buyord');
				$lv_buyordcod = (isset($this->co_reg->request->post['buyordcod'])?$this->co_reg->request->post['buyordcod']:$lp_prm['buyordcod']);
				$lo_buyordmdl->load( array('buyordcod'=>$lv_buyordcod), false );

                // cargo textos de cotizacion
                $lo_txtmdl = $this->co_reg->load->model('grldattxt');
                $lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9). 'BUY_ORD' .chr(9).chr(9).
       			   							  '[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9). $lo_buyordmdl->buyordcod .chr(9).chr(9) );
                $lo_txtrs = $lo_txtmdl->getList( $lv_prm );

				// obtengo nombre de la persona que creó el documento
				$lo_usrmdl = $this->co_reg->load->model('syssecusr');
				$lo_usrmdl->load( array('usrcod'=>$lo_buyordmdl->cteusr) );
				$lo_buyordmdl->cteusrtxt = $lo_usrmdl->usrtxt;

				$this->co_reg->response->addHeader('Content-type:application/pdf');
				return $this->co_reg->document->getView('zcutp1_lgnbuyordordpnt', array('data'=>$lo_buyordmdl,'txt'=>$lo_txtrs,'actcod'=>$this->data['actcod']));
				break;
			
			
			
			//   F A C T U R A
			case '#slsinvpnt':
				$lo_post = $this->co_reg->request->post;
				$lv_slsinvcod = (isset($lo_post['slsinvcod'])?$lo_post['slsinvcod']:$lp_prm['slsinvcod']);

				// FACTURA. cargo datos de factura
				$lo_invmdl = $this->co_reg->load->model('slsinv');
				$lo_invmdl->load( array('slsinvcod'=>$lv_slsinvcod), false );

				// CHECK
        if( $lo_invmdl->docsts!='C' ){
          return $this->co_reg->document->getjson ( array ('errtyp'=>'E', 'errcod'=>-11,'errtxt'=>'El documento debe estar contabilizado.'));
        }
				

				// EMPRESA. cargo datos de empresa
				$lo_busmdl = $this->co_reg->load->model('admbus');
				$lo_busmdl->load( array('buscod'=>$this->co_reg->sec->buscod), false );

				// FACTURA ELECTRONICA. cargo datos de factura electronica (puede no tener si es interna)
				$lo_fcemdl = $this->co_reg->load->model('slsinvfce');
				$lo_fcemdl->load( array('slsinvcod'=>$lv_slsinvcod), false );

				// CLIENTE. contactos del cliente -destinatario de factura-
				$lo_cusmdl = $this->co_reg->load->model('slscus');
				$lo_cntmdl = $this->co_reg->load->model('grldatcnt');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]c.cntsrctyp'.chr(9).'='.chr(9).chr(9).$lo_invmdl->dstobjtyp .chr(9).chr(9).
																			'[~fltrow~]c.cntsrccod'.chr(9).'='.chr(9).chr(9).$lo_invmdl->dstobjcod .chr(9).chr(9).
																			'[~fltrow~]dbo.getTagValue(^invadr^,ct.sysdocclsatr)'.chr(9).'='.chr(9).chr(9). 'X' .chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_cntmdl->getList($lv_prm, null, null, false);
				if(count($lo_rs)>0){
					if( $lo_rs[0]['cntdsttyp']=='SLS_CUS' ) {
						$lo_cusmdl->load( array('cuscod'=>$lo_rs[0]['cntdstcod']), false );
						$lo_cusmdl2 = $lo_cusmdl;
					} else {
						$lo_cntmdl->load( array('cntcod'=>$lo_rs[0]['cntcod']), false );
						$lo_cntmdl->custxt = $lo_cntmdl->cnttxt;
						$lo_cusmdl2 = $lo_cntmdl;
					}
				} else {
					$lo_cusmdl->load( array('cuscod'=>$lo_invmdl->dstobjcod), false );
					$lo_cusmdl2 = $lo_cusmdl;
				}

				// LOCALIZACION ARGENTINA. cargo datos de localizacion Argentina
				$lo_posmdl = $this->co_reg->load->model('finlocargpos');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]p.slsposcod'.chr(9).'='.chr(9).chr(9).$lo_invmdl->slsposcod .chr(9).chr(9).
																			'[~fltrow~]p.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lo_invmdl->sysdocclscod .chr(9).chr(9).
																			'[~fltrow~]p.argltrcodext'.chr(9).'='.chr(9).chr(9).$this->co_reg->document->getTagValue($lo_fcemdl->slsinvfceatr,'argltrcodext') .chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_posmdl->getList($lv_prm,null,null,false);
				if(count($lo_rs)>0){
					$lo_posmdl->load( array('argposcod'=>$lo_rs[0]['argposcod']), false );
				}

				$this->co_reg->response->addHeader('Content-type:application/pdf');
				return $this->co_reg->document->getView('zcutp1_lgnslsinvpnt', array('bus'=>$lo_busmdl,'cus'=>$lo_cusmdl2,'inv'=>$lo_invmdl,'fce'=>$lo_fcemdl,'pos'=>$lo_posmdl,'actcod'=>$this->data['actcod']));
				break;
			
			
			
			//    E T I Q U E T A S    -    T I P O    0 0 1
			case '#stkmatlbl001pnt':
        
				// obtengo datos del documento
        $lp_prm['matsercod']=$lp_prm['matsercod']??'';
        $lp_prm['matbchcod']=$lp_prm['matbchcod']??'';
        if($lp_prm['matsercod']==''){
          $lo_stkbchmdl = $this->co_reg->load->model('stkmatbch');
          $lo_stkbchmdl->load( array('matbchcod'=>$lp_prm['matbchcod']), true );          
        }else{
					$lo_stksermdl = $this->co_reg->load->model('stkmatser');
          $lo_stksermdl->load( array('matsercod'=>$lp_prm['matsercod']), false );
        }
        
				//return $this->co_reg->document->getJson (array('errtyp'=>'E', 'errcod'=>-11,'errtxt'=>$lo_stkbchmdl->matsercod));
        $prmData=array('data'=>($lp_prm['matsercod']!=''?$lo_stksermdl:$lo_stkbchmdl)
                       ,'msgqty'=>(isset($this->co_reg->request->get['msgqty'])?$this->co_reg->request->get['msgqty']:'1')
                       ,'actcod' => $this->data['actcod']);
				$this->co_reg->response->addHeader('Content-type:application/pdf');
				return $this->co_reg->document->getView('zcutp1_lgnstkmatbarcod001pnt',  $prmData);
				break;

			case '#sndmlmatequ':
				$lo_txtmdl = $this->co_reg->load->model('grldattxt',$lv_dir);
				$lo_ordmdl =$this->co_reg->load->model('slsord',$lv_dir);
				$lo_matmdl =$this->co_reg->load->model('stkmat',$lv_dir);
				$lo_matclsmdl =$this->co_reg->load->model('stkmatcls',$lv_dir);
				$lo_docclsmdl = $this->co_reg->load->model('sysdoccls',$lv_dir);
				$lo_vew = $this->co_reg->load->model('grlvew',$lv_dir);
				$lo_post= $this->co_reg->request->post;

				$lv_usrmsg = '';
				$lv_errcod = '0';
				$lv_errtxt = '';// obtengo texto del mensaje
				/*
				$lv_prm = array('vewfldflt' =>'[~fltrow~]t.txtcodext'.chr(9).'='.chr(9).chr(9).'SLSORDEQU'.chr(9).chr(9).
																			'[~fltrow~]t.lngcod'.chr(9).'='.chr(9).chr(9).'ES'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrctyp'.chr(9).'='.chr(9).chr(9).'SLS_ORD'.chr(9).chr(9).
																			'[~fltrow~]t.txtsrccod'.chr(9).'='.chr(9).chr(9).'**'.chr(9).chr(9),
												'vewmaxrec'=>'1');
				$lo_rs = $lo_txtmdl->getList($lv_prm,array(),$lo_vew,$lv_dir);
				if( count($lo_rs)!=0 ) {
					$lv_usrmsg = $lo_rs[0]['txttxt'];
				} else {
					$lv_usrmsg = '';
					$lv_errcod = '-1';
					$lv_errtxt = 'No se encontró el texto del mensaje.';
				}
        */
				// obtengo mensaje de notificacion
        $lv_txtcodext = 'SLSORDEQU';
        $lo_txtmdl = $this->co_reg->load->model('grldattxt');

        if( $lo_txtmdl->load(array('txtcodext' => $lv_txtcodext, 'txtsys' => 1), false) ){
            $lv_usrmsg = $lo_txtmdl->txttxt;
        } else {
          $lv_usrmsg = '';
          $lv_errcod = '-1';
          $lv_errtxt = 'No se encontró el texto del mensaje.';
        }
				$lo_ordmdl->load(array('slsordcod'=>$lp_prm['slsordcod']), false);

				$lv_prm = array('vewfldflt' =>'[~fltrow~]sysdocclscodext'.chr(9).'='.chr(9).chr(9).'EQU'.chr(9).chr(9));
				$doccls = $lo_docclsmdl->getList($lv_prm);
				$lv_matclscod = $doccls[0]['sysdocclscod'];

				$lv_matordlst='';
				foreach ($lo_ordmdl->slsordmat as $lv_row) {
					$lv_matordlst .= ($lv_matordlst==''?'':chr(10)).$lv_row['matcod'];
				}

				// obtenemos los matoriales de equipamiento del pedido
				$lv_prm = array('vewfldflt' =>'[~fltrow~]m.matcod'.chr(9).'IN'.chr(9).chr(9).$lv_matordlst .chr(9).chr(9).
																			'[~fltrow~]dc.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lv_matclscod.chr(9).chr(9),
												'vewfldord' => 'm.matcod');
				$lo_mat_rs = $lo_matmdl->getList($lv_prm, null, null, false);
				if(count($lo_mat_rs)>0){
					// determino destinatarios
					$lv_usremlstr = $this->co_reg->document->getTagValue($lp_prm['document_parameters'] , 'mailto');
					if ( $lv_usremlstr=='' ) {
						$lv_errcod = '-2';
						$lv_errtxt = 'No se indicaron destinatarios.';
					} else {
						$lv_mailto = array();
						foreach( explode(' ',$lv_usremlstr) as $lv_key=>$lv_val ) {
							$lv_mailto[] = array('address'=>$lv_val);
						}
					}

					$lo_eml = new tmssMail();
					$lv_emlprm['to'] = $lv_mailto;
					$lv_emlprm['from'] = array( array('address'=>'noreply@temasis.com.ar', 'name'=>$this->co_reg->sec->bustxt ));
					$lv_emlprm['subject'] = $this->co_reg->sec->bustxt.' - Nuevo pedido con equipamiento';
					$lv_usrmsg = str_replace( '[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg );
					$lv_usrmsg = str_replace( '[%2]', 'Pedido Nro '.$lp_prm['slsordcod'], $lv_usrmsg );
					$lv_usrmsg = str_replace( '[%9]', 'https://temasis.com.ar/logindoor-com-ar/', $lv_usrmsg );
					$lv_emlprm['bodyhtml'] = $lv_usrmsg;

					if ( $lo_eml->send( $lv_emlprm ) ) {
						$lv_errcod = '0';
						$lv_errtxt = 'Enviado';
					} else {
						$lv_errcod = '-1';
						$lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>'.$lo_eml->getError().'<br><br>Consulte al administrador del sistema.';
					}
				}
				break;
      
			
    	// V A L I D A C I O N    -    C O N T A C T O
      case '#chkcntstk':
        $lo_matStkMdl = $this->co_reg->load->model('stkmatstk');
        // recupero stock
        $lv_prm = array('vewfldflt' =>'[~fltrow~]s.stkcntcod'.chr(9).'='.chr(9).chr(9).$lp_prm['data']['cntcod'].chr(9).chr(9).
                                      '[~fltrow~]s.stkobjtyp '.chr(9).'='.chr(9).chr(9).'SLS_CUS'.chr(9).chr(9));
        $lo_rs = $lo_matStkMdl->getList($lv_prm, null, null, false);
        if($lp_prm['action']== 'UPDATE' && strtoupper($lp_prm['data']['docsts']) == 'I' && count($lo_rs) > 0 ){
          return array('errtyp'=>"E", 'errcod'=>-1, 'errtxt'=>'No se puede inactivar el Contacto. El Contacto posee stock asignado, por favor realice los movimientos correspondientes.');
        }
        return array('errtyp'=>"S", 'errcod'=>0, 'errtxt'=>'');
      	break;
			
			// ---------------------------------------------------------------------
			//
			//	V A L I D A C I O N E S    /    E X I S T S
			//
			// ---------------------------------------------------------------------
			
			
			
			//		CHECK - LISTA DE PRECIOS
      //		valida que antes de borrarse o inactivarse una lista de precios no se encuentre
    	//		asignada a ningun cliente y en tal caso, muestra la lista de clientes asignados.
      case '#chkslsprc':
        
        if($lp_prm['action'] != 'NEW'){
          // cargo modelo de clientes
          $lo_mdlcus = $this->co_reg->load->model('slscus');

          // recupero lista de clientes
          $lv_prm = array('vewfldflt' =>'[~fltrow~]c.slsprclstcod'.chr(9).'='.chr(9).chr(9).$lp_prm['data']['slsprclstcod'].chr(9).chr(9));
          $lo_rs = $lo_mdlcus->getList($lv_prm, null, null, false);
					
          switch( $lp_prm['action'] ) {
            case 'UPDATE': case 'DELETE':
              if( count($lo_rs) > 0 ) {
                	$lv_cus = '';
                	foreach($lo_rs as $lv_row){ $lv_cus .=' ['.$lv_row['cuscod'].']'; }
              		if($lp_prm['data']['docsts'] != $lp_prm['prv_data']->docsts && strtoupper($lp_prm['data']['docsts']) === 'I') {
                  	return array('errtyp'=>"E", 'errcod'=>-1, 'errtxt'=>'No se puede inactivar lista de precio. Asociada al cliente: <br>'.$lv_cus);
                  } else if( $lp_prm['action'] == 'DELETE'){
                 		return array('errtyp'=>"E", 'errcod'=>-1, 'errtxt'=>'No se puede borrar lista de precio. Asociada al cliente: <br>'.$lv_cus); 
                  }                
              }
          }
        }
        return array('errtyp'=>"S", 'errcod'=>0, 'errtxt'=>''); 
        break;
      
      
        
			//		CHECK - C O N D I C I O N E S   D E   P A G O
			case '#chkordpaytmr':
				if( isset($lp_prm['data']['nofrmchk']) ) { return ''; }
				$lo_supmdl = $this->co_reg->load->model('buysup');
				$lo_paymdl = $this->co_reg->load->model('finpaytrm');

				$lo_supmdl->load(array('supcod'=>$lp_prm['data']['srcobjcod']), false);

				$lv_ret = '';
				if($lo_supmdl->paytrmcod!=$lp_prm['data']['paytrmcod']){
					$lo_rspay = $lo_paymdl->getList(null,null,null,false);
					$lv_lstPay=array();
					foreach ($lo_rspay as $lo_row) {
						$lv_lstPay[$lo_row['paytrmcod']]=$lo_row['paytrmtxt'];

					}

					$lv_lst = '<p>La condicion de pago seleccionada es diferente a la configurada en el proveedor.</p>'.
										'<P>Cond.Pago proveedor: <strong>'. $lv_lstPay[$lo_supmdl->paytrmcod].'</strong></P>'.
										'<P>Cond.Pago seleccionada: <strong>'.$lv_lstPay[ $lp_prm['data']['paytrmcod']].'</strong></P>'.
										'<p>Desea continuar de todas formas?</p>';
					$lv_ret='/*script*/'.
						'BootstrapDialog.show({'.
							'title: "Comparaci&oacute;n de Condiciones de pago", '.
							'message: $("'.$lv_lst.'"),'.
							'type: BootstrapDialog.TYPE_WARNING ,'.
							'size: BootstrapDialog.SIZE_NORMAL,'.
							'buttons: [{ label: "NO", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } }, '.
												'{ label: "SI", cssClass: "btn-primary",	action: function(dialogItself){ $('.chr(39).'#'.$lp_prm['data']['sec'].'_frm'.chr(39).').append('.chr(39).'<input type="hidden" name="nofrmchk" value="X">'.chr(39).'); '.$lp_prm['data']['sec'].'_fnc({action: "00"}); dialogItself.close(); }}]'.
						'});';
					}
				return $lv_ret;
				break;
        
        
        
			//		CHECK - ASIGNACIÓN DE RECURSOS
      //		valida que antes de grabarse una consignación, sus recursos se encuentren
    	//		dentro del contrato con el cliente.
      case "#chksoumatsvc":
        $lv_ret = $lv_ret = array('errtyp'=>'S', 'errcod'=>0, 'errtxt'=>'');
        
        // guardo ids de materiales
        $lv_movmat_arr = ($lp_prm['data']['stkmovdocmat'] != '' ? explode(chr(9), substr($lp_prm['data']['stkmovdocmat'], 1)) : array() );
        $lv_matcod_arr = array();
        foreach($lv_movmat_arr as $lv_row){
          $lv_matcod_arr[] = $this->co_reg->document->getTagValue($lv_row, 'matcod');
        }
        
        // busco recursos dentro del contrato
        $lo_svcmatmdl = $this->co_reg->load->model('slssvcmat');
        $lv_stkmovdocdtecnv = DateTime::createFromFormat('d/m/Y', $lp_prm['data']['stkmovdocdte'])->format('Y-m-d');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                        							'[~fltrow~]o.dstobjtyp'.chr(9).'='.chr(9).chr(9).'SLS_CUS'.chr(9).chr(9).
                        							'[~fltrow~]o.dstobjcod'.chr(9).'='.chr(9).chr(9).$lp_prm['data']['dstobjcod'].chr(9).chr(9).
																			'[~fltrow~]o.slssvcstrdte'.chr(9).'LE'.chr(9).chr(9). $lv_stkmovdocdtecnv .chr(9).chr(9).
																			'[~fltrow~]o.slssvcenddte'.chr(9).'GE'.chr(9).chr(9). $lv_stkmovdocdtecnv .chr(9).chr(9).
																			'[~fltrow~]1=(case when isnull(om.slssvcstrdte,0)=0 then 1 else (case when om.slssvcstrdte <= ^'.$lv_stkmovdocdtecnv.'^ then 1 else 0 end) end)'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9).
																			'[~fltrow~]1=(case when isnull(om.slssvcenddte,0)=0 then 1 else (case when om.slssvcenddte >= ^'.$lv_stkmovdocdtecnv.'^ then 1 else 0 end) end)'.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9).
                       								'[~fltrow~]om.matcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10), $lv_matcod_arr) .chr(9).chr(9));
				$lv_svcmat_arr = $lo_svcmatmdl->getList( $lv_prm );

        // descarto los recursos que no estén fuera del contrato
        foreach($lv_matcod_arr as $lv_key => &$lv_row){
          foreach($lv_svcmat_arr as $lv_row2){
            if($lv_row == $lv_row2['matcod']){ 
              unset($lv_matcod_arr[$lv_key]);
              break; 
            }
          }
        }
        unset($lv_row);

        if(count($lv_matcod_arr) > 0){
          $lv_ret = array('errtyp'=>'E', 'errcod'=>-1, 'errtxt'=>'<b>Materiales fuera de contrato</b><br>Los siguientes materiales no están incluidos en el contrato:<br>'.implode(', ', $lv_matcod_arr));
        }
      
        return $lv_ret;
        break;
        
			
        
			//
			//    CHECK - COTIZACIONES ANTERIORES
			//
			case '#chkCotiz':
				if( isset($lp_prm['data']['nofrmchk']) ) { return ''; }
				
				$lo_excrtemdl = $this->co_reg->load->model('finexcrte');
				$lv_strdte = new DateTime(date('Y-m-d'));
				$lv_enddte = new DateTime(date('Y-m-d'));
				$lv_strdte->modify('-3 months');

				// busco cotizaciones anteriores (3 meses)
				$lo_ordmdl = $this->co_reg->load->model('slsord');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]o.slsorddte'.chr(9).'BT'.chr(9).chr(9). $lv_strdte->format('Y-m-d') .chr(9). $lv_enddte->format('Y-m-d') .chr(9).
																			($lp_prm['ordmdlprv']->slsordcod!=''?'[~fltrow~]o.slsordcod'.chr(9).'<>'.chr(9).chr(9). $lp_prm['ordmdlprv']->slsordcod .chr(9).chr(9):'').
																			'[~fltrow~]o.dstobjtyp'.chr(9).'='.chr(9).chr(9). $lp_prm['data']['dstobjtyp'] .chr(9).chr(9).
																			'[~fltrow~]o.dstobjcod'.chr(9).'='.chr(9).chr(9). $lp_prm['data']['dstobjcod'] .chr(9).chr(9).
																			($lp_prm['data']['dstcntcod']!=0 && 1==2?'[~fltrow~]o.dstcntcod'.chr(9).'='.chr(9).chr(9). $lp_prm['data']['dstcntcod'] .chr(9).chr(9):''),
												'vewfldord' =>'o.slsorddte DESC');
				$lo_rs = $lo_ordmdl->getList( $lv_prm, null, null, false );
				
				// armo lista de cotizaciones
				$lv_ordlst = '';
				foreach($lo_rs as $lv_row){	
					if(stripos(chr(10).$lv_ordlst.chr(10),chr(10).$lv_row['slsordcod'].chr(10))===false){ $lv_ordlst .= $lv_row['slsordcod'].chr(10); }
				}
					
				// armo lista de codigos de material a comparar
				$lv_ordmatlst = '';
				$lv_buffer = $lp_prm['data']['slsordmat'];
				if ($lv_buffer!='') {
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_slsordmatarr = json_decode($lv_buffer,true);
					foreach( $lv_slsordmatarr as $lv_row ) {
						if(stripos(chr(10).$lv_ordmatlst.chr(10),chr(10).$lv_row['matcod'].chr(10))===false){ $lv_ordmatlst .= $lv_row['matcod'].chr(10); }
					}
				}
				
				//  si no hay cotizaciones o materiales a comparar, no se realiza ninguna accion
				if($lv_ordlst=='' || $lv_ordmatlst==''){ return ''; }
				
				$lv_lmtmem= ini_get('memory_limit');
				ini_set('memory_limit', '2048M');
					
				// obtengo materiales de las cotizaciones anteriores
				$lo_ordmatmdl = $this->co_reg->load->model('slsordmat');
				$lv_prm = array('vewfldflt' =>'[~fltrow~]o.slsordcod'.chr(9).'IN'.chr(9).chr(9).$lv_ordlst.chr(9).chr(9).
																			'[~fltrow~]o.matcod'.chr(9).'IN'.chr(9).chr(9).$lv_ordmatlst.chr(9).chr(9),
												'vewfldord'=>'o.slsorddte DESC');
				$lo_rsmat = $lo_ordmatmdl->getList( $lv_prm );

				// verifico la última cotización para cada material
				$lv_lst = '';
				$lv_curcodact = $lp_prm['data']['curcod'];
				$lv_buffer = $lp_prm['data']['slsordmat'];
				if ($lv_buffer!='') {
					$lv_buffer = html_entity_decode($lv_buffer);
					$lv_slsordmatarr = json_decode($lv_buffer,true);
					foreach( $lv_slsordmatarr as $lv_row ) {
						foreach($lo_rsmat as $lv_rowmat) {
							if($lv_row['matcod']==$lv_rowmat['matcod']) {

								$lv_curcodant = $lv_rowmat['curcod'];
								$lv_excrte = 1;
								if($lv_curcodact!=$lv_curcodant) {
									// si la moneda de la cotizacion anterior (lv_rowmat) es distinta del documento actual $lp_prm['data']['curcod']
									// ===> obtengo cotizacion de moneda (lv_rowmat['curcod']) a la fecha actual
									$lv_excrters = $lo_excrtemdl->getExchangeRate( null, array('curcodsrc'=>$lv_curcodant,'curcoddst'=>$lv_curcodact,'excrtedtefrm'=>$lp_prm['data']['slsorddte'],'excrteclscodext'=>'VTA') );
									if( count($lv_excrters)>0 ) {
										$lv_excrte = $lv_excrters[0]['finexcrte'];
									} else {
										$lv_excrte = 0;
									}
								}
								// comparo valor convertido vs valor del documento actual
								$lv_valant = 	floatval($lv_rowmat['matprc']) * $lv_excrte;
								$lv_valact = floatval($lv_row['matprc']);
								if( $lv_valact < $lv_valant ){
									$lv_lst .= '<tr><td>'.$lv_rowmat['slsordcod'].'</td><td>'.$lv_rowmat['slsorddtecnv'].'</td><td>'.$lv_rowmat['mattxt'].'<br><small>'.$lv_rowmat['matcod'].'</small></td><td align=right>'.number_format($lv_rowmat['matprc'],2).' '.$lv_curcodant.($lv_curcodant!=$lv_curcodact?'<br><small>'.number_format($lv_valant,2).' '.$lv_curcodact.'</small>':'').'</td><td align=right>'.number_format($lv_row['matprc'],2).' '.$lv_curcodact.'</td><td align=right>'.($lv_curcodant!=$lv_curcodact?number_format($lv_excrte,5):'').'</td><td>'.number_format( (1-($lv_valant/$lv_valact))*100,2).'%</td></tr>';
									break;
								}
							}
						}
					}
				}

				// si hay valores menores, devuelvo cuadro de dialogo
				$lv_ret = '';
				if ($lv_lst!='') {
					$lv_lst = '<p>Se econtraron 1 o mas cotizaciones previas con precios menores a los cargados.</p>'.
										'<table class='.chr(39).'table table-bordered'.chr(39).'>'.
										'<thead><tr><th>ID</th><th>Fecha</th><th>Material</th><th>Anterior</th><th>Actual</th><th>T/C</th><th>Var</th></tr></thead><tbody>'.$lv_lst.'</tbody></table>'.
										'<p>Desea continuar de todas formas?</p>';
					$lv_ret='/*script*/'.
						'BootstrapDialog.show({'.
							'title: "Comparaci&oacute;n de Cotizacones", '.
							'message: $("'.$lv_lst.'"),'.
							'type: BootstrapDialog.TYPE_PRIMARY,'.
							'size: BootstrapDialog.SIZE_WIDE,'.
							'buttons: [{ label: "NO", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } }, '.
												'{ label: "SI", cssClass: "btn-primary",	action: function(dialogItself){ $('.chr(39).'#'.$lp_prm['data']['sec'].'_frm'.chr(39).').append('.chr(39).'<input type="hidden" name="nofrmchk" value="X">'.chr(39).'); '.$lp_prm['data']['sec'].'_fnc({action: "00"}); dialogItself.close(); }}]'.
						'});';
				}

				ini_set('memory_limit', $lv_lmtmem);
				return $lv_ret;
				break;
			
			  //
        // CHECK - PRECIO DEL MATERIAL IGUAL A CERO
        //
        case '#chkPrecioCero':
          $ret=[];
          $ret['errtyp']='S';
          $ret['errcod']='0';
        	$ret['errtxt']='';
        	$ret['errjva']='';
        	$lp_prm['data']['slsordmat'] = html_entity_decode($lp_prm['data']['slsordmat']);
        	$lstOrdMat= json_decode($lp_prm['data']['slsordmat'], true);
        	$section= $lp_prm['data']['lv_sec']??'';
        	if(($lp_prm['data']['nofrmchk']??'')!=''){ return $ret; }
        	$errMat=[];
        	foreach($lstOrdMat as $rowMat){
	        //  Solo valido si viene el campo matprc
      			if (isset($rowMat['matprc'])) {
           			$matprc = $rowMat['matprc'] ?? 0;
            		if ($matprc <= 0) { $errMat[] = $rowMat; }
				}
			}
          if(($lp_prm['data']['nofrmchk']??'')=='' && count($errMat)>0){

            // Muestro los materiales que tienen valor 0
            $htmlList = "<ul>";
            foreach($errMat as $mat){
              $matnam = $mat['mattxt'] ?? 'SIN NOMBRE';
              $matcod = $mat['matcod'] ?? 'SIN CODIGO';
              $htmlList .= "<li><strong>{$matcod}</strong> - {$matnam}</li>";
            }
            $htmlList .= "</ul>";

            $tmp_dialog=''.
            'BootstrapDialog.show({'.
              'title: "Verificación del pedido", '.
							'message: "<strong>¡Atención!</strong><br>Este pedido contiene uno o más artículos cuyo precio es igual a 0.<br> Materiales afectados:<br>'.$htmlList.'¿Desea guardar el pedido igualmente?",'.
              'type: BootstrapDialog.TYPE_WARNING ,'.
              'size: BootstrapDialog.SIZE_NORMAL,'.
              'buttons: [{ label: "NO", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } }, '.
                        '{ label: "SI", cssClass: "btn-primary",	action: function(dialogItself){ $('.chr(39).'#'.$section.'_frm'.chr(39).').append('.chr(39).'<input type="hidden" name="nofrmchk" value="X">'.chr(39).'); '.$section.'_fnc({action: "00"}); dialogItself.close(); }}]'.
            '});';

            $ret = array(
              'errtyp'=>'E',
              'errcod'=>'-125',
              'errtxt'=>'Existe una posición con valor 0',
              'errjva'=>$tmp_dialog
            );
          }

          return $ret;
          break;    
			// ---------------------------------------------------------------------
			//
			//	I N T E R F A C E S
			//
			// ---------------------------------------------------------------------
			
      case '#stkmovdet':
		// IMPRESIONES DE MOVIMIENTOS. El parametro tipo selecciona interno o inter_planta.
				$lo_stkdocmdl = $this->co_reg->load->model('stkmovdoc');
				$lv_stkmovdoccod = $this->co_reg->request->post['stkmovdoccod']
                                      ?? $this->co_reg->request->post['stomovdoccod']
                                      ?? $lp_prm['stkmovdoccod']
                                      ?? '';
		$lv_pnttipo = $this->co_reg->request->post['tipo']
											?? $lp_prm['tipo']
											?? 'interno';
		$lv_pnttipo = strtolower(trim((string)$lv_pnttipo, " \t\n\r\0\x0B'\""));
		if(!in_array($lv_pnttipo, array('interno', 'inter_planta'), true)){
		  return $this->co_reg->document->getJson(array(
			'errtyp'=>'E',
			'errcod'=>-11,
			'errtxt'=>'Tipo de impresion invalido. Los valores admitidos son interno e inter_planta.'
		  ));
		}

        if($lv_stkmovdoccod==='' || !ctype_digit((string)$lv_stkmovdoccod) || intval($lv_stkmovdoccod)<=0){
          return $this->co_reg->document->getJson(array(
            'errtyp'=>'E',
            'errcod'=>-11,
			'errtxt'=>'No se informo un movimiento de stock valido para imprimir.'
          ));
        }

        if(!$lo_stkdocmdl->load(array('stkmovdoccod'=>intval($lv_stkmovdoccod)), false)){
          return $this->co_reg->document->getJson(array(
            'errtyp'=>'E',
            'errcod'=>($lo_stkdocmdl->errcod??-11),
            'errtxt'=>($lo_stkdocmdl->errtxt!=''?$lo_stkdocmdl->errtxt:'No se pudo cargar el movimiento de stock solicitado.')
          ));
        }
		$lo_stkdocmdl->pnttipo = $lv_pnttipo;

		// Compatibilidad: el mensaje historico sin parametro conserva la impresion interna.
		if($lv_pnttipo==='interno'){
		  $lv_prm = array('lang'  => $this->co_reg->language,
						'input' => $this->co_reg->input,
						'sec' => $this->co_reg->sec,
						'doc' => $this->co_reg->document,
						'data' => $lo_stkdocmdl,
						'actcod' => $this->data['actcod'],
						'model' => self::MODEL
						);
		  $lv_buffer = $this->co_reg->load->view('zcutp1_lgn_stkmovdet', $lv_prm);
		  $this->co_reg->response->addHeader('Content-type:application/pdf');
		  return $lv_buffer;
		}

        if($lo_stkdocmdl->docsts!=='C'){
          return $this->co_reg->document->getJson(array(
            'errtyp'=>'E',
            'errcod'=>-11,
            'errtxt'=>'Debe contabilizar el movimiento antes de imprimir el Remito Inter Planta.'
          ));
        }

        $lv_docrejcod = trim((string)$lo_stkdocmdl->sysdocrejcod);
        if($lv_docrejcod!=='' && $lv_docrejcod!=='0'){
          return $this->co_reg->document->getJson(array(
            'errtyp'=>'E',
            'errcod'=>-11,
            'errtxt'=>'No se puede imprimir el Remito Inter Planta porque el movimiento esta rechazado o anulado.'
          ));
        }

        if(trim((string)$lo_stkdocmdl->srcobjtyp)==='' || intval($lo_stkdocmdl->srcobjcod)<=0 ||
           trim((string)$lo_stkdocmdl->dstobjtyp)==='' || intval($lo_stkdocmdl->dstobjcod)<=0){
          return $this->co_reg->document->getJson(array(
            'errtyp'=>'E',
            'errcod'=>-11,
            'errtxt'=>'El movimiento no tiene definidos correctamente el origen y el destino.'
          ));
        }

        // Mantengo unicamente posiciones activas y preparo los textos de impresion.
        $lv_matlst = array();
        foreach(($lo_stkdocmdl->stkmovdocmat??array()) as $lv_row){
          $lv_rejcod = trim((string)($lv_row['sysdocrejcod']??'0'));
          if($lv_rejcod!=='' && $lv_rejcod!=='0'){ continue; }

          $lv_duedtetxt = trim((string)($lv_row['matbchduedtecnv']??''));
          if($lv_duedtetxt==='' && isset($lv_row['matbchduedte']) && is_a($lv_row['matbchduedte'], 'DateTime')){
            $lv_duedtetxt = $lv_row['matbchduedte']->format('d/m/Y');
          }

          $lv_row['matqtypnt'] = number_format(floatval($lv_row['matqty']??0), 2, ',', '.');
          $lv_row['matbchcodextpnt'] = (intval($lv_row['matbchcod']??0)>0?trim((string)($lv_row['matbchcodext']??'')):'');
          $lv_row['matsercodextpnt'] = (intval($lv_row['matsercod']??0)>0?trim((string)($lv_row['matsercodext']??'')):'');
          $lv_row['matbchduedtepnt'] = $lv_duedtetxt;
          $lv_matlst[] = $lv_row;
        }

        if(count($lv_matlst)===0){
          return $this->co_reg->document->getJson(array(
            'errtyp'=>'E',
            'errcod'=>-11,
            'errtxt'=>'El movimiento no tiene posiciones activas para imprimir.'
          ));
        }
        $lo_stkdocmdl->stkmovdocmat = $lv_matlst;

        // Resuelvo de forma determinista los domicilios activos del origen y destino.
        $lo_adrmdl = $this->co_reg->load->model('grldatadr');
        $lv_objlst = array(
          'src'=>array('typ'=>$lo_stkdocmdl->srcobjtyp, 'cod'=>$lo_stkdocmdl->srcobjcod),
          'dst'=>array('typ'=>$lo_stkdocmdl->dstobjtyp, 'cod'=>$lo_stkdocmdl->dstobjcod)
        );

        foreach($lv_objlst as $lv_idx=>$lv_obj){
		  // La direccion es informativa: el deposito sigue siendo imprimible aunque no tenga una activa.
		  $lo_stkdocmdl->set('pnt'.$lv_idx.'adrtxt', '');
          $lv_adrprm = array(
            'vewfldflt'=>'[~fltrow~]a.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                         '[~fltrow~]a.adrsrctyp'.chr(9).'='.chr(9).chr(9).$lv_obj['typ'].chr(9).chr(9).
                         '[~fltrow~]a.adrsrccod'.chr(9).'='.chr(9).chr(9).$lv_obj['cod'].chr(9).chr(9),
            'vewfldord'=>'a.ctedte desc',
            'vewmaxrec'=>'1'
          );
          $lv_adrrs = $lo_adrmdl->getList($lv_adrprm);
		  if(is_array($lv_adrrs) && !isset($lv_adrrs['errtyp']) && count($lv_adrrs)>0){
			$lv_adr = $lv_adrrs[0];
			$lv_adrpart = array();
			$lv_adrstreet = trim((string)($lv_adr['adrstr']??($lv_adr['adrstrnme']??'')));
			$lv_adrnum = trim((string)($lv_adr['adrstrnum']??''));
			if($lv_adrstreet!=='' || $lv_adrnum!==''){
			  $lv_adrpart[] = trim($lv_adrstreet.($lv_adrnum!==''?' '.$lv_adrnum:''));
			}
			if(trim((string)($lv_adr['adrstrflr']??''))!==''){
			  $lv_adrpart[] = 'Piso '.trim((string)$lv_adr['adrstrflr']);
			}
			if(trim((string)($lv_adr['adrstrunt']??''))!==''){
			  $lv_adrpart[] = 'Dto. '.trim((string)$lv_adr['adrstrunt']);
			}
			if(trim((string)($lv_adr['adrstrbld']??''))!==''){
			  $lv_adrpart[] = trim((string)$lv_adr['adrstrbld']);
			}
			$lv_adrtown = trim((string)($lv_adr['adrtwntxt']??($lv_adr['adrtwn']??'')));
			if($lv_adrtown!==''){ $lv_adrpart[] = $lv_adrtown; }
			if(trim((string)($lv_adr['adrcty']??''))!=='' && strcasecmp(trim((string)$lv_adr['adrcty']), $lv_adrtown)!==0){
			  $lv_adrpart[] = trim((string)$lv_adr['adrcty']);
			}
			if(trim((string)($lv_adr['adrpstcod']??''))!==''){
			  $lv_adrpart[] = 'CP '.trim((string)$lv_adr['adrpstcod']);
			}
			if(trim((string)($lv_adr['lndregtxt']??''))!==''){
			  $lv_adrpart[] = trim((string)$lv_adr['lndregtxt']);
			}

			if(count($lv_adrpart)>0){
			  $lo_stkdocmdl->set('pnt'.$lv_idx.'adrtxt', implode(', ', $lv_adrpart));
			}
		  }
        }

        // Datos comerciales de Logindoor obtenidos de la empresa configurada.
        $lo_busmdl = $this->co_reg->load->model('admbus');
        if(!$lo_busmdl->load(array('buscod'=>$this->co_reg->sec->buscod), false)){
          return $this->co_reg->document->getJson(array(
            'errtyp'=>'E',
            'errcod'=>-11,
            'errtxt'=>'No se pudieron cargar los datos comerciales de Logindoor.'
          ));
        }

        $lv_busadrpart = array();
        $lv_busadrstreet = trim((string)$lo_busmdl->adr->adrstr);
        $lv_busadrnum = trim((string)$lo_busmdl->adr->adrstrnum);
        if($lv_busadrstreet!=='' || $lv_busadrnum!==''){
          $lv_busadrpart[] = trim($lv_busadrstreet.($lv_busadrnum!==''?' '.$lv_busadrnum:''));
        }
        if(trim((string)$lo_busmdl->adr->adrstrflr)!==''){
          $lv_busadrpart[] = 'Piso '.trim((string)$lo_busmdl->adr->adrstrflr);
        }
        if(trim((string)$lo_busmdl->adr->adrstrunt)!==''){
          $lv_busadrpart[] = 'Dto. '.trim((string)$lo_busmdl->adr->adrstrunt);
        }
        $lv_busadrtown = trim((string)$lo_busmdl->adr->adrtwntxt);
        if($lv_busadrtown===''){ $lv_busadrtown = trim((string)$lo_busmdl->adr->adrtwn); }
        if($lv_busadrtown!==''){ $lv_busadrpart[] = $lv_busadrtown; }
        if(trim((string)$lo_busmdl->adr->adrcty)!=='' && strcasecmp(trim((string)$lo_busmdl->adr->adrcty), $lv_busadrtown)!==0){
          $lv_busadrpart[] = trim((string)$lo_busmdl->adr->adrcty);
        }
        if(trim((string)$lo_busmdl->adr->lndregtxt)!==''){
          $lv_busadrpart[] = trim((string)$lo_busmdl->adr->lndregtxt);
        }

        $lv_taxcod = preg_replace('/[^0-9]/', '', (string)$lo_busmdl->tax->taxcod);
        $lv_taxcodtxt = $lv_taxcod;
        if(strlen($lv_taxcod)===11){
          $lv_taxcodtxt = substr($lv_taxcod,0,2).'-'.substr($lv_taxcod,2,8).'-'.substr($lv_taxcod,10,1);
        }

		$lo_stkdocmdl->pntremitocod = '00001-'.str_pad((string)intval($lv_stkmovdoccod), 8, '0', STR_PAD_LEFT);
        $lo_stkdocmdl->pntstkmovdocdtetxt = (is_a($lo_stkdocmdl->stkmovdocdte, 'DateTime')?$lo_stkdocmdl->stkmovdocdte->format('d/m/Y'):'');
        $lo_stkdocmdl->pntsrcobjtxt = trim((string)$lo_stkdocmdl->srcobjtyptxt).
                                          (trim((string)$lo_stkdocmdl->srcobjtyptxt)!=='' && trim((string)$lo_stkdocmdl->srcobjtxt)!==''?': ':'').
                                          trim((string)$lo_stkdocmdl->srcobjtxt);
        $lo_stkdocmdl->pntdstobjtxt = trim((string)$lo_stkdocmdl->dstobjtyptxt).
                                          (trim((string)$lo_stkdocmdl->dstobjtyptxt)!=='' && trim((string)$lo_stkdocmdl->dstobjtxt)!==''?': ':'').
                                          trim((string)$lo_stkdocmdl->dstobjtxt);
        $lo_stkdocmdl->pntsrccnttxt = (intval($lo_stkdocmdl->srccntcod)>0?trim((string)$lo_stkdocmdl->srccnttxt):'');
        $lo_stkdocmdl->pntdstcnttxt = (intval($lo_stkdocmdl->dstcntcod)>0?trim((string)$lo_stkdocmdl->dstcnttxt):'');
        $lo_stkdocmdl->pntstkmovdoccmttxt = trim((string)$lo_stkdocmdl->stkmovdoccmt);
        $lo_stkdocmdl->pntbustxt = trim((string)$lo_busmdl->bustxt);
        $lo_stkdocmdl->pntbusadrtxt = implode(', ', $lv_busadrpart);
        $lo_stkdocmdl->pntbustaxcattxt = trim((string)$lo_busmdl->tax->taxcattxt);
        $lo_stkdocmdl->pntbuscuittxt = $lv_taxcodtxt;
        $lo_stkdocmdl->pntbusiibbtxt = trim((string)$lo_busmdl->tax->taxiibb);
        $lo_stkdocmdl->pntbusactstrtxt = (is_a($lo_busmdl->tax->taxactstr, 'DateTime')?$lo_busmdl->tax->taxactstr->format('d/m/Y'):'');

		// Nombre del usuario que contabilizo el movimiento (AccUsr), sin leyenda adicional.
		$lv_accusr = trim((string)($lo_stkdocmdl->accusr??''));
		$lo_stkdocmdl->pntaccusrtxt = $lv_accusr;
		if($lv_accusr!==''){
		  $lo_accusrmdl = $this->co_reg->load->model('syssecusr');
		  if($lo_accusrmdl->load(array('usrcod'=>$lv_accusr), false)){
			$lv_accusrtxt = trim((string)$lo_accusrmdl->usrtxt);
			if($lv_accusrtxt!==''){ $lo_stkdocmdl->pntaccusrtxt = $lv_accusrtxt; }
		  }
		}

        $lv_prm = array('lang'  => $this->co_reg->language,
                      'input' => $this->co_reg->input,
                      'sec' => $this->co_reg->sec,
                      'doc' => $this->co_reg->document,
                      'data' => $lo_stkdocmdl,
                      'actcod' => $this->data['actcod'],
                      'model' => self::MODEL
                      );
					$lv_buffer = $this->co_reg->load->view('zcutp1_lgn_stkmovdet', $lv_prm);
					$this->co_reg->response->addHeader('Content-type:application/pdf');
					return $lv_buffer;
        break;
      case '#buyordlst':
        $lo_ordmatmdl = $this->co_reg->load->model('buyordmat');
        $lstSqlStm=[];
        /* PREPARAMOS LOS FILTROS DE LAS POSICIONES DE LOS PEDIDOS*/
        $lv_vewfldflt = (isset($this->co_reg->request->post['vewfldflt'])?$this->co_reg->request->post['vewfldflt']:'');
				$lv_vewmaxrec = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewmaxrec']:'');
        $lv_vewfldord = (isset($this->co_reg->request->post['vewfldord'])?$this->co_reg->request->post['vewfldord']:'o.buyorddte desc');
        
				$lv_fltarr = explode('[~fltrow~]',$lv_vewfldflt );
				for($i=count($lv_fltarr)-1; $i>0; $i--){
				 if(stripos(';matcod;mattxt;matqty;buyordcod;buyorddte;buyorddtecnv;sysdoctretxt;dc.sysdocclstxt;sysdocrejtxt;',';'.explode(chr(9),$lv_fltarr[$i])[0].';')===false){
				 	unset($lv_fltarr[$i]);
				 }else{
           $lv_fltarr[$i] = str_replace('matcod','m.matcod',$lv_fltarr[$i]);
           $lv_fltarr[$i] = str_replace('buyordcod','o.buyordcod',$lv_fltarr[$i]);
           $lv_fltarr[$i] = str_replace('mattxt','m.mattxt',$lv_fltarr[$i]);
           $lv_fltarr[$i] = str_replace('matqty','matqty',$lv_fltarr[$i]);
           $lv_fltarr[$i] = str_replace('buyorddtecnv','buyorddte',$lv_fltarr[$i]);
           $lv_fltarr[$i] = str_replace('buyorddte','o.buyorddte',$lv_fltarr[$i]);
         }
				}
        $lv_ordmatprm = array('vewfldflt' =>'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                         							 			'[~fltrow~]om.sysdoctrecod'.chr(9).'IN'.chr(9).chr(9). 'N' .chr(9).chr(9).
                              							(count($lv_fltarr)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltarr):''),
                              'vewfldord' => ($lv_vewfldord==''?'o.buyorddte desc':$lv_vewfldord),
                              'vewmaxrec' => $lv_vewmaxrec);
        $lo_rsordmat = $lo_ordmatmdl->getList($lv_ordmatprm);
        $lstSqlStm[]=$lo_ordmatmdl->getsysdata('sqlstm');
        
        $lv_ordlst = array();
        foreach( $lo_rsordmat as $lo_row) {
        	$lv_ordlst[] = $lo_row['buyordcod'];
        }
        
        //PREPARAMOS LOS FILTROS DE LOS PEDIDOS
        $lv_fltordarr = explode('[~fltrow~]',$lv_vewfldflt );
        $lv_fltord = false;
        for($i=count($lv_fltordarr)-1; $i>0; $i--){
				 if(stripos(';o.sysdoctretxt;srcobjtxt;sysdoctretxt2;',';'.explode(chr(9),$lv_fltordarr[$i])[0].';')===false){
				 	unset($lv_fltordarr[$i]);
				 }else{
           $lv_fltordarr[$i] = str_replace('o.sysdoctretxt','sysdoctretxt',$lv_fltordarr[$i]);
           $lv_fltordarr[$i] = str_replace('srcobjtxt','srcobjtxt',$lv_fltordarr[$i]);
           $lv_fltordarr[$i] = str_replace('sysdoctretxt2','sysdoctretxt',$lv_fltordarr[$i]);
           $lv_fltord = true;
         }
				}
        
        $lo_ordmdl = $this->co_reg->load->model('buyord');
        
        $lv_ordprm = array('vewfldflt' =>'[~fltrow~]o.buyordcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lv_ordlst) .chr(9).chr(9).
                           							 '[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                           								(count($lv_fltordarr)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltordarr):'')
                          );
        $lo_rsord = $lo_ordmdl->getList($lv_ordprm, null, null, false);
        $lstSqlStm[]=$lo_ordmdl->getsysdata('sqlstm');

        
        
        $lv_ordmatlst=array();
        foreach( $lo_rsord as $lo_ordrow) {
        	$lv_ordmatlst[$lo_ordrow['buyordcod']]['srcobjtxt']=$lo_ordrow['srcobjtxt'];
          $lv_ordmatlst[$lo_ordrow['buyordcod']]['sysdoctretxt']=$lo_ordrow['sysdoctretxt'];
        }
        $lo_ret=array();
				foreach( $lo_rsordmat as $lo_row) {
        	$lo_ordrow=$lo_row;
          $lo_ordrow['srcobjtxt']='';
          $lo_ordrow['sysdoctretxt2']='';
          
          if(isset($lv_ordmatlst[$lo_ordrow['buyordcod']])){
            $lo_ordrow['srcobjtxt']=$lv_ordmatlst[$lo_ordrow['buyordcod']]['srcobjtxt'];
            $lo_ordrow['sysdoctretxt2']=$lv_ordmatlst[$lo_ordrow['buyordcod']]['sysdoctretxt'];    
          }elseif($lv_fltord==true){
            continue;
          }
          $lo_ret[]=$lo_ordrow;
          
        }
        $lo_ret[0]['sqlstm']=$lstSqlStm;
        return $lo_ret;
        break;
        case '#stkmstmatlst':
          $lo_matmdl = $this->co_reg->load->model('stkmat');
        	/* PREPARAMOS LOS FILTROS DE LAS POSICIONES DE LOS PEDIDOS*/
          $lv_vewfldflt = (isset($this->co_reg->request->post['vewfldflt'])?$this->co_reg->request->post['vewfldflt']:'');
          $lv_vewmaxrec = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewmaxrec']:'');
          $lv_vewfldord = (isset($this->co_reg->request->post['vewfldord'])?$this->co_reg->request->post['vewfldord']:'');

          $lv_fltarr = explode('[~fltrow~]',$lv_vewfldflt );
          for($i=count($lv_fltarr)-1; $i>0; $i--){
           if(stripos(';matcod;mattxt',';'.explode(chr(9),$lv_fltarr[$i])[0].';')===false){
            unset($lv_fltarr[$i]);
           }
            else{
             $lv_fltarr[$i] = str_replace('matcod','m.matcod',$lv_fltarr[$i]);
             //$lv_fltarr[$i] = str_replace('buyordcod','o.buyordcod',$lv_fltarr[$i]);
             $lv_fltarr[$i] = str_replace('mattxt','m.mattxt',$lv_fltarr[$i]);
             //$lv_fltarr[$i] = str_replace('matqty','matqty',$lv_fltarr[$i]);
             //$lv_fltarr[$i] = str_replace('buyorddtecnv','buyorddte',$lv_fltarr[$i]);
           }
          }
          $lv_matprm = array('vewfldflt' =>'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
                      											(count($lv_fltarr)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltarr):''),
                                'vewfldord' => $lv_vewfldord,
                                'vewmaxrec' => $lv_vewmaxrec);
          $lo_rsmat = $lo_matmdl->getList($lv_matprm, null, null, false); 
          //echo $lo_matmdl->getsysdata('sqlstm');
        
        	/*Archivos*/
        	$lo_flemdl = $this->co_reg->load->model('grldatupl');
          $lv_prm = array('vewfldflt'=>'[~fltrow~]f.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                       '[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9).'STK_MAT'.chr(9).chr(9),
                          'vewfldord'=>'f.flesrctyp, f.flesrccod, f.fleduedte DESC'
                          );
          $lo_flers = $lo_flemdl->getList( $lv_prm );       
        	//echo $lo_flemdl->getsysdata('sqlstm');
        
        
        	/*Perfil*/
        	$lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        	$lv_prm = array('vewfldflt'=>'[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                       '[~fltrow~]d.objtyp'.chr(9).'='.chr(9).chr(9).'STK_MAT'.chr(9).chr(9),
                          'vewfldord'=>'d.objtyp'
                          );
          $lo_clsrs = $lo_docclsmdl->getList( $lv_prm );
          $lo_ret=array();
        	foreach( $lo_rsmat as $lo_row) {
        		$lo_matrow=$lo_row;
            $lo_matrow['matfleqty']=0;
            $lo_matrow['matserdocclstxt']='';
            foreach($lo_flers as $lv_flerow){
              if($lv_flerow['flesrccod']==$lo_row['matcod']){
								$lo_matrow['matfleqty']++;
              }
            }
            if(isset($lo_row['matserdocclscod'])){
              
              foreach($lo_clsrs as $lv_clsrow){
                if($lv_clsrow['sysdocclscod']==$lo_row['matserdocclscod']){
                  $lo_matrow['matserdocclstxt']=$lv_clsrow['sysdocclstxt'];
                }
              }
            }
            
          $lo_ret[]=$lo_matrow;
          }

          return $lo_ret;
        
        break;
      
      //Generar codigo externo
      case '#matextcodgen':
        
        //return array('errtyp'=>'E','errcod'=>'11','errtxt'=>'sarasa');

       	//return array('errtyp'=>'E','errcod'=>'11','errtxt'=>$lp_prm['action']);
        //break;
        
       	$lv_matcod=str_pad($lp_prm['data']['matcod'], 5  , '0', STR_PAD_LEFT);
        $lv_matcod=str_pad($lp_prm['data']['matcod'], 5  , '0', STR_PAD_LEFT);
        $lv_sysdocclscod=str_pad($lp_prm['data']['sysdocclscod'], 4  , '0', STR_PAD_LEFT);
        $lv_matclscod=str_pad($lp_prm['data']['matclscod'], 2  , '0', STR_PAD_LEFT);
        $lv_mathiecod =str_pad($lp_prm['data']['mathiecod'], 3  , '0', STR_PAD_LEFT);
        $lv_matcodext=$lv_sysdocclscod.$lv_matclscod.$lv_mathiecod.$lv_matcod;
        
        if($lp_prm['data']['matcodext']!=$lv_matcodext){
          $lp_prm['data']['matcodext']=$lv_matcodext;
          $lo_matmdl = $this->co_reg->load->model('stkmat');
          $lo_matmdl->save($lp_prm['data'], false);          
        }
        
        return array('errtyp'=>'S','errcod'=>'0','errtxt'=>'');
        break;
        
      // IMPRESION - REMITO
			case '#stkmovdocpnt':
        $sqlStm=[];
				// obtengo datos del documento
				$lo_stkdocmdl = $this->co_reg->load->model('stkmovdoc');
				$lo_datcntmdl = $this->co_reg->load->model('grldatcnt');

				$lv_stkmovdoccod = (isset($this->co_reg->request->post['stkmovdoccod'])?$this->co_reg->request->post['stomovdoccod']:$lp_prm['stkmovdoccod']);
				$lo_stkdocmdl->load( array('stkmovdoccod'=>$lv_stkmovdoccod), false );
				$lo_datcntmdl->load( array('cntcod'=>$lo_stkdocmdl->dstcntcod), false );
				$lo_stkdocmdl->dstcnt=$lo_datcntmdl;
        
        if ( $lo_stkdocmdl->docsts!='C' ) {
          return $this->co_reg->document->getJson (array('errtyp'=>'E', 'errcod'=>-11,'errtxt'=>'Debe contabilizar el documento para imprimir el Remito.'));
        }
        
        /* 1.1 - Busco las clases de documento de pedidos */
        $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]d.objtyp'.chr(9).'='.chr(9).chr(9).'STK_SOU'.chr(9).chr(9) .
                                      '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
        $lo_rscls = $lo_docclsmdl->getList($lv_prm);
        $lo_docclsls= array();
        foreach ($lo_rscls as $lv_row) {
          $lv_clsarr[$lv_row['sysdocclscod']]=$lv_row['sysdocclscodext'];
        }
        $lo_stkdocmdl->sysdocclscodext= $lv_clsarr[$lo_stkdocmdl->sysdocclscod];

        /* 1.2 Busco los pedidos de referencia de la salida*/
        $lo_flwposmdl = $this->co_reg->load->model('grldocflwpos');
        $lv_flwposprm = array('vewfldflt' =>'[~fltrow~]refobjtyp'.chr(9).'='.chr(9).chr(9).'STK_SOU'.chr(9).chr(9) .
                                      '[~fltrow~]refobjcod'.chr(9).'='.chr(9).chr(9).$lv_stkmovdoccod.chr(9).chr(9) .
                                      '[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
        $lo_rsflwpos = $lo_flwposmdl->getList($lv_flwposprm);

        $lv_flwarr = array();
        foreach ($lo_rsflwpos as $lv_rowflw) {
          if (!in_array($lv_rowflw['srcobjcod'], $lv_flwarr)) {
            $lv_flwarr[]=$lv_rowflw['srcobjcod'];
          }
        }

        // Obtengo los datos del cliente
      $lo_cusmdl = $this->co_reg->load->model('slscus');
      $lo_cusmdl->load( array('cuscod'=>$lo_stkdocmdl->dstobjcod), false );
      $lo_stkdocmdl->dstcus=$lo_cusmdl;  


      // Obtengo la zona adrzon
      //$lo_zonmdl = $this->co_reg->load->model('grldatzon');

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

        /* 1.3 Busco las cotizaciones de referencia del pedido*/
        $lo_flwposqtamdl = $this->co_reg->load->model('grldocflwpos');
        $lv_flwposqtaprm = array('vewfldflt' =>'[~fltrow~]refobjtyp'.chr(9).'='.chr(9).chr(9).'SLS_ORD'.chr(9).chr(9) .
                                               '[~fltrow~]refobjcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lv_flwarr).chr(9).chr(9).
                                               '[~fltrow~]docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
        $lo_rsflwqtapos = $lo_flwposqtamdl->getList($lv_flwposqtaprm);

        $lv_flwqtaarr = array();
        foreach ($lo_rsflwqtapos as $lv_rowqtaflw) {
          if (!in_array($lv_rowqtaflw['srcobjcod'], $lv_flwqtaarr)) {
            $lv_flwqtaarr[]=$lv_rowqtaflw['srcobjcod'];
          }
        }    

        $lv_prm = array('lang'  => $this->co_reg->language,
                        'input' => $this->co_reg->input,
                        'sec' => $this->co_reg->sec,
                        'doc' => $this->co_reg->document,
                        'data' => $lo_stkdocmdl,
                        'adddat' => array('flwarr'=>$lv_flwarr,
                                          'flwqtaarr'=>$lv_flwqtaarr),
                        'actcod' => $this->data['actcod'],
                        'model' => self::MODEL
                        );
        // Busco la clases de documentos usadas
        $lstDocClsCodExt=['INS','FPR','ELA'];
        $mdlDocCls = $this->co_reg->load->model('sysdoccls');
        $prmDocCls = array('vewfldflt' =>'[~fltrow~]sysdocclscodext'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lstDocClsCodExt).chr(9).chr(9));
        $rsDocClsLst = $mdlDocCls->getList($prmDocCls);
        $sqlStm[]=$mdlDocCls->getsysdata('sqlstm');
        $lstClsCod=array_column($rsDocClsLst, 'sysdocclscod','sysdocclscodext');  

        $lvkitLst=[];
        $lstMatCod=[];
        foreach($lo_stkdocmdl->stkmovdocmat as $rowMat){
          $key= $rowMat['stkmovdocmatcod'];//$rowMat['matcod'];
          if($rowMat['matdocclscod']==$lstClsCod['FPR']){
            if(!array_key_exists($rowMat['matcod'],$lvkitLst)){
              $lvkitLst[$key]=[];
            }
            $lstMatCod[]= $rowMat['matcod'];
            $lvkitLst[$key]['matcod']=$rowMat['matcod'];
            $lvkitLst[$key]['matbchcod']=$rowMat['matbchcod'];
            $lvkitLst[$key]['matbchcodext']=$rowMat['matbchcodext'];
            $lvkitLst[$key]['matqty']=$rowMat['matqty'];
          }
        }
        
        //Traer lista de materiales de los kits del pedido
        $mdlMatLst = $this->co_reg->load->model('stkmatlst');
        $prmMatLst = array('vewfldflt' =>'[~fltrow~]ml.matcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lstMatCod).chr(9).chr(9).
                                         '[~fltrow~]ml.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
        $rsMatLst = $mdlMatLst->getList($prmMatLst, null, null, false);
        $sqlStm[]=$mdlMatLst->getsysdata('sqlstm');
        $lstMatLstCod= array_column($rsMatLst, 'matlstcod');
        
        $mdlMatLstMat = $this->co_reg->load->model('stkmatlstmat');
        $prmMatLstMat = array('vewfldflt' =>'[~fltrow~]ml.matlstcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lstMatLstCod).chr(9).chr(9).
                                         '[~fltrow~]ml.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
        $rsMatLstMat = $mdlMatLstMat->getList($prmMatLstMat);
        $sqlStm[]=$mdlMatLstMat->getsysdata('sqlstm');
        $LstMatLst=[];
        foreach($rsMatLst as $rowMat){
          $key=$rowMat['matcod'];
          if(!array_key_exists($key,$LstMatLst)){
            $LstMatLst[$key]=[];
          }
          $lstMatLstMat=[];
          foreach($rsMatLstMat as $rowMatLstMat){
            $key2=$rowMatLstMat['matlstmatcod'];
            if($rowMat['matlstcod']==$rowMatLstMat['matlstcod']){
              if(!array_key_exists($key2,$lstMatLstMat)){
                $lstMatLstMat[$key2]=[];
              }
              $lstMatLstMat[$key2]=array('matcod'=>$rowMatLstMat['srcobjcod'],'srcobjtxt'=>$rowMatLstMat['srcobjtxt'],'matqty'=>$rowMatLstMat['matqty'],'matuntcod'=>$rowMatLstMat['matuntcod']);
              
            }
          }
          $LstMatLst[$key]['matlstmat']=$lstMatLstMat;
        }
        
        // Busco los materiales de las elaboraciones (para obtener los codigos de los movimientos de las elaboraciones)
        $mdlMovMat = $this->co_reg->load->model('stkmovdocmat');
        $prmMovDoc = array('vewfldflt' =>'[~fltrow~]dm.matcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lstMatCod).chr(9).chr(9).
                           							 '[~fltrow~]dc.sysdocclscod'.chr(9).'='.chr(9).chr(9).$lstClsCod['ELA'].chr(9).chr(9).//113
                                         '[~fltrow~]mb.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
        $rsMovMatElb = $mdlMovMat->getList($prmMovDoc);
        $lstMovDoc=array_column($rsMovMatElb, 'stkmovdoccod');
        $sqlStm[]=$mdlMovMat->getsysdata('sqlstm');
        
        // Busco todos los materiales del movimiento de las elaboraciones (para obtener todas los Movimientos)
        $prmMovDoc = array('vewfldflt' =>'[~fltrow~]dm.stkmovdoccod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lstMovDoc).chr(9).chr(9),
                           'vewfldord' =>'dm.stkmovdoccod asc'  );
        $rsMovMat = $mdlMovMat->getList($prmMovDoc);
        $sqlStm[]=$mdlMovMat->getsysdata('sqlstm');
        $lstMovMatKit=[];
        $lstMovMatCmp=[];
        $lstMovMat=[];
        
        // Recorro las elaboraciones para dividir los kits de los componentes
        $keyStkMovDocCodAnt='';
        foreach($rsMovMat as $rowMovMat){
          $key=$rowMovMat['stkmovdoccod'];
          if($rowMovMat['matdocclscod']==$lstClsCod['FPR']){ //ES KIT 111
            if(!array_key_exists($key,$lstMovMatKit)){
              $lstMovMatKit[$key]=[];
            }
            //Guardo el lote del kit
            $lstMovMatKit[$key]=array('matbchcodext'=>$rowMovMat['matbchcodext'],'matbchcod'=>$rowMovMat['matbchcod']);
          }else{// if($rowMovMat['matdocclscod']==$lstClsCod['INS']){  // ES INSUMO 36
            if(!array_key_exists($key,$lstMovMatCmp)){
              $lstMovMatCmp[$key]=[];
            }
            //guardo los datos del insumo
            $lstMovMatCmp[$key][]=array('matbchcodext'=>$rowMovMat['matbchcodext']
                                        ,'matbchduedte'=>$rowMovMat['matbchduedte']
                                        ,'matbchcod'=>$rowMovMat['matbchcod']
                                       	,'matcod'=>$rowMovMat['matcod']
                                       	,'mattxt'=>$rowMovMat['mattxt']
                                       	,'matcodext'=>$rowMovMat['matcodext']
                                       );
          }
        }
        
        $lstMovMatCmpBch=[];//Lista de lostes de la composicion
        foreach($lstMovMatKit as  $key => $valMovMat){
          $matMchCod= $valMovMat['matbchcod'];//Lote del kit
          $lstMovMatCmpBch[$matMchCod]['lstmatcmpbch']=$lstMovMatCmp[$key];// Componentes del kit
        }
        
        $lstCmpBchTot=[];
        $lstCmpBchTot['matusebch']=[];
        $lstCmpBchTot['matnotusebch']=[];
        // recorro las posiciones del movimiento que son kit para agregarle los componentes usados
        foreach($lvkitLst as &$row){
          if($row['matbchcod']==''){
            continue;
          }
          foreach($lstMovMatCmpBch[$row['matbchcod']]['lstmatcmpbch'] as &$rowCmpBch){
            $key=$rowCmpBch['matbchcod'];
            $idx='matusebch';
            if($rowCmpBch['matbchcod']==0){
            	$idx='matnotusebch';
              $key= $rowCmpBch['matcod'];
            }
            if(!array_key_exists($key,$lstCmpBchTot[$idx])){
              $lstCmpBchTot[$idx][$key]=$rowCmpBch;
              $lstCmpBchTot[$idx][$key]['matqtycmp']=0;
            }
            foreach($LstMatLst[$row['matcod']]['matlstmat'] as $rowMatlst){
            	if($rowMatlst['matcod']==$lstCmpBchTot[$idx][$key]['matcod']){
                $lstCmpBchTot[$idx][$key]['matqtycmp']+=($rowMatlst['matqty'] * $row['matqty']);
              }
            }
            /*
            foreach($LstMatLst[$row['matcod']]['matlstmat'] as $rowMatlst){
            	if($rowMatlst['matcod']==$rowCmpBch['matcod']){
                $rowCmpBch['matqtycmp']=($rowMatlst['matqty'] * $row['matqty']);
              }
            }
          */
          }
          //$row['matlstbchmat']=$lstMovMatCmpBch[$row['matbchcod']]['lstmatcmpbch'];
        }
        
        $lv_vewcod = isset($lp_prm['vewcus'])?$lp_prm['vewcus']:'zcutp1_stkmovdocpnt';
        $lv_prm['vewkitlst']=$lp_prm['vewkitlst']??'' ;
        $lv_prm['cmp']=$lvkitLst;
        $lv_prm['cmplst']=$lstCmpBchTot;
        
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
				$lo_stkdocmdl->load( array('stkmovdoccod'=>$lv_stkmovdoccod), false );
        //if($lo_stkdocmdl->docsts!='C'){
        //	return '<errtyp>E</errtyp><errcod>-1</errcod><errtxt>El documento debe estar contabilizado.</errtxt>';
        //}
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
        $lo_rsstk=$lo_matstk->getlist($lv_prm);
        if(count($lo_rsstk)>=1){
          return $this->co_reg->document->getJson ( array ('errtyp'=>'E', 'errcod'=>-11,'errtxt'=>'Debe realizar la determinacion de lotes, Nro de serie o en su defecto rechazarlo.'));
        }
        $lo_matlst= array();
        foreach ($lo_stkdocmdl->stkmovdocmat as $lv_row) {	
          if(!in_array( $lv_row['matcod'],$lo_matlst)){
            $lo_matlst[]=$lv_row['matcod'];	
          }
        }
        $lv_prm = array('lang'  => $this->co_reg->language,
                      'input' => $this->co_reg->input,
                      'sec' => $this->co_reg->sec,
                      'doc' => $this->co_reg->document,
                      'data' => $lo_stkdocmdl,
                      'datastk' => $lo_rsstk,
                      'actcod' => $this->data['actcod'],
                      'model' => self::MODEL
                      );
        $lv_buffer = 	$this->co_reg->load->view('zcutp1_stkmovdocpck', $lv_prm);
        $this->co_reg->response->addHeader('Content-type:application/pdf'); 
        return $lv_buffer;

				break;
      //
			//    Check LQD Data
			//
			case '#chklqddat':
        $lv_prscod=$lp_prm['data']['prscod'];
        $lv_ret=array('errtyp'=>'S','errcod'=>'0','errtxt'=>'');
        $lo_prsmdl = $this->co_reg->load->model('hltprs');
        if(!$lo_prsmdl->load(array('prscod'=>$lv_prscod), false)){
        	return array('errtyp'=>'E','errcod'=>$lo_prsmdl->errcod,'errtxt'=>$lo_prsmdl->errtxt);  
        }
        $lv_errlst=array();
        
        if($lo_prsmdl->bnk->bnkacccbu==''){
          $lv_errlst[]=array('errtxt'=>'Falta CBU');
        }  
        if($lo_prsmdl->bnk->bnktxt==''){
          $lv_errlst[]=array('errtxt'=>'Falta Banco');
        }        
        if($lo_prsmdl->tax->idttyptxt!='CUIT'){
          $lv_errlst[]=array('errtxt'=>'Falta CUIT');
        }
        if(count($lv_errlst)>0){
          $lv_ret['errtyp']='E';
          $lv_ret['errcod']=count($lv_errlst)*-100;
          $lv_ret['errtxt']='Faltan datos en el prestador o alguno es erroneo:';
          foreach($lv_errlst as $lo_row_err){
            $lv_ret['errtxt'].='<br>'.$lo_row_err['errtxt'];
          }
        }
        
        return $lv_ret;
        break;

      //
			//    Check LQD Data
			//
			case '#lstprccat':
        // Preparo parametros
        $lo_post = $this->co_reg->request->post; 
        $lv_vewfldflt = ($lo_post['vewfldflt']??'');
				$lv_vewmaxrec = ($lo_post['vewmaxrec']??'');
        $lv_msgtyp=($lo_post['msgtyp']??'');
 				
        // Obtengo datos
        $lo_prcmdl = $this->co_reg->load->model('slsprclst');
        $lv_prm = array('vewfldflt' =>$lv_vewfldflt,
                        'vewmaxrec' => $lv_vewmaxrec);
        $lo_rs=$lo_prcmdl->getList($lv_prm);
        
        // Armo salida
        if($lv_msgtyp=='pdf'){
          $lv_buffer = $this->co_reg->document->getView( 'zcutp1_lgnlstprccatpnt', array('data'=>$lo_rs,'actcod'=>$this->data['actcod']) );
          $this->co_reg->response->addHeader('Content-type:application/pdf');
          return $lv_buffer;
        }
        return $lo_rs;
        break;
        
    	//
			//    Check LQD Data
			//
			case '#matcstupd':
        return $this->co_reg->document->getView('zcutp1_lgnmatcstupd', array('data'=>array(),'actcod'=>$this->data['actcod']));
        break;
    //
    //    Check LQD Data
    //
    case '#matcstupddat':
    	$lo_ret = [];
      $lo_data_sqlstm=[];
      $lo_cstmdl = $this->co_reg->load->model('stkmatcst');
        
      $lv_vewfldflt = (isset($this->co_reg->request->post['vewfldflt'])?$this->co_reg->request->post['vewfldflt']:'');
			$lv_vewmaxrec = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewmaxrec']:'');
      //PREPARAMOS LOS FILTROS DE LOS PEDIDOS
        $lv_fltordarr = explode('[~fltrow~]',$lv_vewfldflt );
        $lo_data_sqlstm[]= $lv_vewfldflt;
        $lo_data_sqlstm[]= $lv_fltordarr;
        for($i=count($lv_fltordarr)-1; $i>0; $i--){
           if(stripos(';m.matcod;m.mattxt;matcst;matcstcurcod;matcstqty;m.docsts;suptxt;stkmatcstlstupddte;mc.matcstlstupd;',';'.explode(chr(9),$lv_fltordarr[$i])[0].';')===false){
             unset($lv_fltordarr[$i]);
           }else{
             $lo_data_sqlstm[]=utf8_encode($lv_fltordarr[$i]);
             $lv_flt=explode(chr(9),$lv_fltordarr[$i]);
             $lo_data_sqlstm[]= $lv_flt;
            if($lv_flt[0]=='stkmatcstlstupddte'){
              $lv_dteflt=explode('-',$lv_flt[3]);
              $lo_data_sqlstm[]=$lv_dteflt;
              $lv_flt[3]=$lv_dteflt[2].'/'.$lv_dteflt[1].'/'.$lv_dteflt[0];
              $lv_fltordarr[$i]=implode(chr(9),$lv_flt);
            }
          }
        }
        //$lo_data_sqlstm[]=$lv_fltordarr;
        $lv_ordprm = array('vewfldflt' 	=> (count($lv_fltordarr)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltordarr):''),
                            'vewmaxrec' => $lv_vewmaxrec,
                            'vewfldord'	=>'mattxt DESC');
      $lo_ret=$lo_cstmdl->getList($lv_ordprm);
      $lo_data_sqlstm[]=$lo_cstmdl->getsysdata('sqlstm');
      
     	$lv_json = $this->co_reg->document->getJson( array('data'=>$lo_ret,'data_sqlstm'=>$lo_data_sqlstm) );
      return $lv_json;
      break;
    case '#matcstupdedt':
    	$lo_ret =['errtyp'=>'S','errcod'=>0,'errtxt'=>''];
      $lv_updcsttyp= (isset($this->co_reg->request->post['updcsttyp'])?$this->co_reg->request->post['updcsttyp']:'');
      $lv_updcstqty = (isset($this->co_reg->request->post['updcstqty'])?$this->co_reg->request->post['updcstqty']:'');
        
      $lv_matcodlst = (isset($this->co_reg->request->post['matcodlst'])?$this->co_reg->request->post['matcodlst']:'');
      $lo_cstmdl = $this->co_reg->load->model('stkmatcst');
      $lv_prm = array('vewfldflt' =>'[~fltrow~]m.matcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lv_matcodlst).chr(9).chr(9),
                      'vewfldord' =>'m.matcod DESC');
      
      $lo_matcstlst=$lo_cstmdl->getList($lv_prm);
      $lo_ret=[];
      foreach($lo_matcstlst as $lo_row_matcst){
        $lo_matcst=['matcod'=>$lo_row_matcst['matcod'],
                   	'matcstcurcod'=>$lo_row_matcst['matcstcurcod'],
                    'matcstqty'=>$lo_row_matcst['matcstqty'],
                    'matcstuntcod'=>$lo_row_matcst['matcstuntcod'],
                    'matcst'=>$lo_row_matcst['matcst']
                   ];
        if ($lv_updcsttyp=='0'){
          $lo_matcst['matcst']=$lv_updcstqty;
        }else {
          $lv_matcst=$lo_matcst['matcst'];
					$lv_matcst+=($lv_matcst*$lv_updcstqty)/100;
					$lo_matcst['matcst']=$lv_matcst;
        }
        $lo_cstmdl->save($lo_matcst);
        $lo_ret[]=$lo_matcst;
      }
      $lv_ret_json = $this->co_reg->document->getJson( array('data'=>$lo_ret) );
      return $lv_ret_json;
      break;
        
    // T I E M P O S    P E D I D O S
      case '#matstkrpt':
        $lv_lmtmem= ini_get('memory_limit');
				ini_set('memory_limit', '2048M');
        $lv_ret=[];
        $lo_data_sqlstm=[];
        $lv_vewfldflt = (isset($this->co_reg->request->post['vewfldflt'])?$this->co_reg->request->post['vewfldflt']:'');
				$lv_vewmaxrec = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewmaxrec']:'');
        // BUSCAMOS LOS MATERIALES ACTIVOS CON CLASE ACTIVA
        
        
        // PERMISOS: DETERMINAMOS SI EL USUARIO ES APTO PARA LA VISUALIZACION DE VARIOS PRESTADORES
        // BUSCAMOS PARAMETROS DE EMPRESA
        
        $lo_txtmdl = $this->co_reg->load->model('sysappmdlprm');
				$lo_txtmdl->load(array('mdlcod'=>'rptstkmat'));
        $lv_flt= str_replace(';', chr(10), $this->co_reg->document->gettagvalue($lo_txtmdl->mdlatrval001,'stlid'));
        
        $lo_matmdl = $this->co_reg->load->model('stkmat');
        $lv_vewfldflt= str_replace("matcod", "m.matcod", $lv_vewfldflt);
        $lv_vewfldflt= str_replace("mattxt", "m.mattxt", $lv_vewfldflt);
        $lv_matprm = array('vewfldflt' 	=>'[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                           								'[~fltrow~]dc.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
          																 $lv_vewfldflt,
                            'vewmaxrec' => $lv_vewmaxrec,
                            'vewfldord'	=>'mattxt DESC');
        
        $lo_matlst=$lo_matmdl->getList($lv_matprm, null, null, false);
        $lo_data_sqlstm[]=$lo_matmdl->getsysdata('sqlstm');
        
        
      	$lo_matstkmdl = $this->co_reg->load->model('stkmatstk');
        $lv_vewfldflt= str_replace("matcod", "matcod", $lv_vewfldflt);
        $lv_vewfldflt= str_replace("mattxt", "mattxt", $lv_vewfldflt);
        $lv_ordprm = array('vewfldflt' 	=> '[~fltrow~]stkobjcod'.chr(9).'IN'.chr(9).chr(9).$lv_flt.chr(9).chr(9).
                           								 '[~fltrow~]mb.docsts=^A^ or ms.docsts=^A^ '.chr(9).'ZZ'.chr(9).chr(9).chr(9).chr(9).
          																 $lv_vewfldflt,
                            'vewmaxrec' => $lv_vewmaxrec,
                            'vewfldord'	=>'mattxt DESC');
        $lo_matstklst=$lo_matstkmdl->getList($lv_ordprm);
        $lo_data_sqlstm[]=$lo_matstkmdl->getsysdata('sqlstm');
        /*
        $lv_aux=[];
        foreach($lo_matstklst as $lo_matstkrow){
          $lv_key=$lo_matstkrow['matcod'];
          //$lv_idx=0;
          $lv_idx=array_search($lv_key,  array_column($lv_aux, 'matcod'));
          if($lv_idx!==false){
          	$lv_aux[$lv_idx]['matqty']+= $lo_matstkrow['matqty'];
          }else{
            $lv_aux[]=array('matcod'=>$lo_matstkrow['matcod'],
                                     'mattxt'=>$lo_matstkrow['mattxt'],
                                     //'matcodext'=>$lo_matstkrow['matcodext'],
                                     'matqty'=>$lo_matstkrow['matqty'],
                                     'matuntcod'=>$lo_matstkrow['matuntcod']);
            
          }
        }
        
        $lv_ret=$lv_aux;
        */
        $lv_matstklst=[];
        foreach($lo_matstklst as $lo_matstkrow){
          $lv_key=$lo_matstkrow['matcod'];
          if(!array_key_exists($lv_key, $lv_matstklst)){
            $lv_matstklst[$lv_key]=array('matqty'=>0);
          }
          $lv_matstklst[$lv_key]['matqty']+=$lo_matstkrow['matqty'];
        }
        
        foreach($lo_matlst as $lo_matrow){
          $lv_rownew=$lo_matrow;
          $lv_key=$lo_matrow['matcod'];
          if(!array_key_exists($lv_key, $lv_matstklst)){
            $lv_rownew['matqty']=0;
          }else{
            $lv_rownew['matqty']=$lv_matstklst[$lv_key]['matqty'];
          }
          $lv_ret[]=$lv_rownew;
        }
        ini_set('memory_limit', $lv_lmtmem);
        $lv_ret[0]['sqlstm']=$lo_data_sqlstm;
        return $lv_ret;
      	break;
      //   REPORTE DE DEVOLUCIONES PASAR A CONTROLADOR LGN
			case '#movdocsindev':
        /*Obtengo los parametros de empresa*/
        $lv_sqlstmlst=[];
        $lo_appprmmdl = $this->co_reg->load->model('sysappmdlprm');
        $lo_appprmmdl->load(array('mdlcod'=>'sinmotdev'));
        $lv_clsflt= str_replace(',', chr(10), $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001,'sindevdoccls'));// Clases incluidas en el reporte
				
        $lo_movdocmdl = $this->co_reg->load->model('stkmovdocmat');
        /* PREPARAMOS LOS FILTROS */
          $lv_vewfldflt = (isset($this->co_reg->request->post['vewfldflt'])?$this->co_reg->request->post['vewfldflt']:'');
          $lv_vewmaxrec = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewmaxrec']:'');
          $lv_vewfldord = (isset($this->co_reg->request->post['vewfldord'])?$this->co_reg->request->post['vewfldord']:'');

          $lv_fltarr = explode('[~fltrow~]',$lv_vewfldflt );
          for($i=count($lv_fltarr)-1; $i>0; $i--){
              $lv_fltarr[$i] = str_replace('sysdocclstxt','dc.sysdocclstxt',$lv_fltarr[$i]);
              $lv_fltarr[$i] = str_replace('stkmovdoccod','d.stkmovdoccod',$lv_fltarr[$i]);
              $lv_fltarr[$i] = str_replace('srcobjtxt','srcobjtxt',$lv_fltarr[$i]);
              $lv_fltarr[$i] = str_replace('srccnttxt','srccnttxt',$lv_fltarr[$i]);
              $lv_fltarr[$i] = str_replace('matcod','m.matcod',$lv_fltarr[$i]);
              $lv_fltarr[$i] = str_replace('mattxt','m.mattxt',$lv_fltarr[$i]);
              $lv_fltarr[$i] = str_replace('matsercodext','ms.matsercodext',$lv_fltarr[$i]);
              $lv_fltarr[$i] = str_replace('sysdocrsntxt','sysdocrsntxt',$lv_fltarr[$i]);
              $lv_fltarr[$i] = str_replace('stkmovdoccodext','stkmovdoccodext',$lv_fltarr[$i]);
              $lv_fltarr[$i] = str_replace('stkmovdocdtecnv','stkmovdocdte',$lv_fltarr[$i]);
          }
        
				$lv_prm = array('vewfldflt' =>'[~fltrow~]d.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).$lv_clsflt.chr(9).chr(9).
                      								(count($lv_fltarr)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltarr):''),
                        'vewfldord' => $lv_vewfldord,
                        'vewmaxrec' => $lv_vewmaxrec);
				$lo_rsmov = $lo_movdocmdl->getlist($lv_prm, null, null, false);
        $lv_sqlstmlst[]=$lo_movdocmdl->getsysdata('sqlstm');
        $lo_rsmov[0]['sqlstm']=$lv_sqlstmlst;
        return $lo_rsmov;
        
        break;
      //		Reporte de movimentos de salida junto con los pedidos linkeados a cada movimiento.
      case '#stkmovpedremrpt':
        $lo_movdocmdl = $this->co_reg->load->model('stkmovdoc');
        $lv_vewfldflt = (isset($this->co_reg->request->post['vewfldflt'])?$this->co_reg->request->post['vewfldflt']:'');
        $lv_vewmaxrec = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewmaxrec']:'');
        $lv_vewfldord = (isset($this->co_reg->request->post['vewfldord'])?$this->co_reg->request->post['vewfldord']:'');

        $lv_ordprm = array('vewfldflt' 	=> $lv_vewfldflt,
                            'vewmaxrec' => $lv_vewmaxrec,
                            'vewfldord'	=>'');
        $lo_rsMov=$lo_movdocmdl->getList($lv_ordprm, null, null, false);
        $lo_data_sqlstm[]=$lo_movdocmdl->getsysdata('sqlstm');
        $lv_stkmovdoccod_lst = array_column($lo_rsMov, 'stkmovdoccod');        
        
        $lo_flwposmdl = $this->co_reg->load->model('grldocflwpos');
        $lv_prm = array('vewfldflt' =>'[~fltrow~]refobjtyp'.chr(9).'IN'.chr(9).chr(9).'STK_SOU'.chr(9).chr(9).
                      								'[~fltrow~]refobjcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lv_stkmovdoccod_lst).chr(9).chr(9),
                        'vewfldord' => 'refobjcod');
        $lo_rsFlwPos=$lo_flwposmdl->getList($lv_prm);
        $lo_data_sqlstm[]=$lo_flwposmdl->getsysdata('sqlstm');
        $lv_FlwPosLst =[];
        
        foreach($lo_rsFlwPos as $lo_flwPosRow){
          $lv_key = $lo_flwPosRow['refobjcod'];
          if (!array_key_exists($lv_key, $lv_FlwPosLst)) {
          	$lv_FlwPosLst[$lv_key]=[];
          }
          if (!in_array($lo_flwPosRow['srcobjcod'],  $lv_FlwPosLst[$lv_key])){
          	$lv_FlwPosLst[$lv_key][]=$lo_flwPosRow['srcobjcod'];
          }
          
        }
        
        $lv_ret=[];
        foreach($lo_rsMov as $lo_movRow){
          $lv_newData=array('srcobjcodref'=>'');
          if(isset($lv_FlwPosLst[$lo_movRow['stkmovdoccod']])){
          	 $lv_newData['srcobjcodref'] =implode(',',$lv_FlwPosLst[$lo_movRow['stkmovdoccod']]);
          }
          /*
          $lv_newData= array('srcobjcodref'=>'');
          foreach($lo_rsFlwPos as $lo_flwRow){          
            if($lo_flwRow['refobjcod']==$lo_movRow['stkmovdoccod']){
              $lv_newData['srcobjcodref'].= ($lv_newData['srcobjcodref']==''?'':',').$lo_flwRow['srcobjcod'];
            }
          }
          */
          array_push( $lv_ret, array_merge( $lv_newData, $lo_movRow));       
        }
        
        $lv_ret[0]['sqlstm']=$lo_data_sqlstm;
        return $lv_ret;
        break;
        
    	//   MATERIALES DESDE LOGIN A TEAMPEDIATRICO
      case '#MatToTp':
        $lv_ret=array('errtyp'=>'S','errcod'=>0,'errtxt'=>'');
        
        $lo_dat = $lp_prm['data'];
				
				// obtengo datos de la interfaz
				$lo_itzmdl = $this->co_reg->load->model('sysint');
        $lo_applogmdl = $this->co_reg->load->model('sysapplog');
        $lv_errlog=[];
        
        
        
        
				$lv_prm = array('vewfldflt' =>'[~fltrow~]i.sysintcodext'.chr(9).'='.chr(9).chr(9).'MAT_TO_TP'.chr(9).chr(9).
																			'[~fltrow~]i.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9) );
				$lo_rs = $lo_itzmdl->getList( $lv_prm );
				if(count($lo_rs)==1) {          
					$lo_itzmdl->load( array('sysintcod'=>$lo_rs[0]['sysintcod']) );
					$lo_dat['cntsrctyp'] = 'SLS_CUS';
          $lo_dat['apires'] = $this->co_reg->document->getTagValue($lo_itzmdl->sysintatr , 'apiurl');
          $lo_dat['prytkn'] = $this->co_reg->document->getTagValue($lo_itzmdl->sysintatr , 'apitkn');
          $lo_dat['usrcod'] = $this->co_reg->document->getTagValue($lo_itzmdl->sysintatr , 'usrcod');
          $lo_dat['usrpwd'] = $this->co_reg->document->getTagValue($lo_itzmdl->sysintatr , 'usrpwd');
					$lo_dat['sysdocclscodnew'] = $this->co_reg->document->getTagValue($lo_itzmdl->sysintatr , 'sysdocclscod');
          $lo_dat['matclscodnew'] ='';
				} else {
          $lv_ret['errtyp']='E';
          $lv_ret['errcod']=-11;
          $lv_ret['errtxt']='error. no se obtuvo la interfaz [MAT_TO_TP]';
          return $lv_ret; 
				}
        $lv_errlog['srcobjtyp']='SYS_INT';
        $lv_errlog['srcobjcod001']=$lo_itzmdl->sysintcod;
        $lv_errlog['srcobjcod002']='';
        $lv_errlog['applogtxt']='';
        $lv_errlog['applogtecinf']='';
        $lv_errlog['mdlcod']='zcutp1_lgn';
        $lv_errlog['prgcod']='MatToTp';
        $lv_errlog['docsts']='A';
        
        foreach($lo_itzmdl->sysintcnv as $lo_rowcnv){
          //$lv_intval['spccnv'][$lo_rowcnv['sysintcnvkey']]=$lo_rowcnv['sysintcnvout001'];
          if($lo_rowcnv['sysintcnvkey']=='STK_MAT_SYSDOCCLSCOD' && $lo_rowcnv['sysintcnvinb001']== $lo_dat['sysdocclscod']){
          	$lo_dat['sysdocclscodnew']=$lo_rowcnv['sysintcnvout001'];
            $lo_dat['matclscodnew'] =$lo_rowcnv['sysintcnvout002'];
          }
        }
        //print_r($lo_itzmdl->sysintcnv);
        //return array('errtyp'=>'E','errtxt'=>$lo_dat['matclscodnew'],'errcod'=>'-333'); 
        // obtengo token de sesion de usuario Nuevo
        $lo_pryctr = $this->co_reg->load->controller('sysapppry');
        
        $lv_retTkn = $lo_pryctr->callRemoteApi($lo_dat);
        
        $lv_retTkn=$lv_retTkn??array('errtyp'=>'E','errtxt'=>'Valor [NULL]','errcod'=>'-333');
        if($lv_retTkn['errtyp']=='S'){ $lo_dat['usrtkn']=  $lv_retTkn['token']; } else { 
          $lv_errlog['applogerrtyp']='E';
          $lv_errlog['applogerrcod']='-333';
          $lv_errlog['applogerrtxt']=$lv_retTkn['errmsg']??$lv_retTkn['errtxt'];
          $lo_applogmdl->save($lv_errlog);
          
          return array('errtyp'=>'E','errtxt'=>$lv_retTkn['errmsg']??$lv_retTkn['errtxt'],'errcod'=>'-333'); 
        }
        $lv_matcod='NEW?';
        if ($lp_prm['action']=='UPDATE'){
          $lp_prm_api=$lo_dat;
          $lp_prm_api['apires'] = '/'.$lo_dat['apires'] . '/stock-materials/search?code=LIKE$'.$lo_dat['matcod'];
          $lo_pryctr = $this->co_reg->load->controller('sysapppry');
          
          $lv_retmat = $lo_pryctr->callRemoteApi($lp_prm_api);
          if(!isset($lv_retmat['errtyp']) || $lv_retmat['errtyp']=='E'){
            $lv_errlog['applogerrtyp']=$lv_retmat['errtyp'];
            $lv_errlog['applogerrcod']=$lv_retmat['errcod'];
            $lv_errlog['applogerrtxt']=$lv_retmat['errtxt'];
            $lo_applogmdl->save($lv_errlog);
            return $lv_retmat;
          }
          foreach($lv_retmat['data'] as $row_mat){
            if($row_mat['code']==$lo_dat['matcod']){
              $lv_matcod=$row_mat['id'];
              break;
            }
          }
        }        
        
        $lo_dat['grlcntcod']=$lv_matcod; 
        $lo_dat['data']['PST']['id'] = '';//$lo_dat['matcod'];
        $lo_dat['data']['PST']['name']=$lo_dat['mattxt'];
        $lo_dat['data']['PST']['additional_data']='';//$lo_dat['additional_data'];
        $lo_dat['data']['PST']['status']=$lo_dat['docsts'];
        
        //$lo_dat['data']['PST']['category_id']=$lo_dat['sysdocclscodnew'];
        
        // - Clase de documento (Conversiones)
        $lo_dat['data']['PST']['documentclass_id']=$lo_dat['sysdocclscodnew'];
        // - Jerarquia
        $lo_dat['data']['PST']['hierarchy_id']='';//$lo_dat['mathiecod'];
        // - Clasificacion
        $lo_dat['data']['PST']['classification_id']=$lo_dat['matclscodnew'];//'';//1;//$lo_dat['matclscod'];
        $lo_dat['data']['PST']['code']=$lo_dat['matcod'];
        //$lo_dat['data']['PST']['unitcode']=$lo_dat['unit_code'];
        $lo_dat['data']['PST']['unit_code']=$lo_dat['matuntcod'];
        
        /* determino el entorno en el que se está ejecutando */
        
        //$lv_issisdev = stripos($_SERVER['REQUEST_URI'],'developers.gorse.ar');
        //if($lv_issisdev === false){
        //  $lv_baseurl='https://developers.gorse.ar/api.gorse.php/'.$lo_dat['apires'] .'/stock-materials/'.$lo_dat['grlcntcod']; 	
        //}else{
        //  $lv_baseurl='https://customers.gorse.ar/api.gorse.php/'.$lo_dat['apires'] .'/stock-materials/'.$lo_dat['grlcntcod'];
        //}
        
        $lv_baseurl='https://customers.gorse.ar/api.gorse.php/'.$lo_dat['apires'] .'/stock-materials/'.$lo_dat['grlcntcod'];
        if (str_contains($_SERVER['HTTP_HOST'],'developers.gorse.ar')) {
        	$lv_baseurl='https://developers.gorse.ar/api.gorse.php/'.$lo_dat['apires'] .'/stock-materials/'.$lo_dat['grlcntcod'];
        }
        
        $lv_errlog['applogerrtxt'] = 'URI: '.$_SERVER['HTTP_HOST'].' - <br>'.$lv_baseurl.'<br>';
        //$lv_retTkn=array('errtyp'=>'E','errtxt'=>$lv_baseurl,'errcod'=>'-333');return $lv_retTkn;
        $curl = curl_init($lv_baseurl);
        $lv_jsonpost= json_encode($lo_dat['data']['PST']);
        $lv_errlog['applogtxt']=$lv_jsonpost;;
        curl_setopt_array($curl, array(	CURLOPT_URL => $lv_baseurl,
                                    CURLOPT_RETURNTRANSFER => true,
                                    CURLOPT_ENCODING => '',
                                    CURLOPT_MAXREDIRS => 10,
                                    CURLOPT_TIMEOUT => 0,
                                    CURLOPT_FOLLOWLOCATION => true,
                                    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
                                    CURLOPT_SSL_VERIFYHOST=>0,
                                    CURLOPT_SSL_VERIFYPEER=>0,
                                    CURLOPT_CUSTOMREQUEST => 'POST',
                                    CURLOPT_POSTFIELDS =>$lv_jsonpost,
                                    CURLOPT_HTTPHEADER => array(
                                                                'Content-Type: application/json',
                                                                'crossDomain: true',
                                                                'proyect-token: '.$lo_dat['prytkn'],
                                                                'user-token: '.$lo_dat['usrtkn'],
                                                              ),
                                ));
        if( ! $lo_rs = curl_exec($curl)){
          trigger_error(curl_error($curl));
        }

        $statusCode = curl_getinfo($curl, CURLINFO_HTTP_CODE);
        // Manejar la respuesta de cURL
        if ($statusCode != 200){
          $lv_ret['errtyp']='E';
          $lv_ret['errcod']= $statusCode; 
          $lv_ret['errtxt']=  'Server Response:'. $statusCode;
          $lv_errlog['applogerrtyp']=$lv_ret['errtyp'];
          $lv_errlog['applogerrcod']=$lv_ret['errcod'];
          $lv_errlog['applogerrtxt']=$lv_ret['errtxt'];
          $lo_applogmdl->save($lv_errlog);
          return $lv_ret;
        }
        curl_close($curl);

        //return array('errtyp'=>'E','errtxt'=>'error prueba','errcod'=>'-333'); 
        return $lv_ret;
        break;
        
      //REPORTE SEGUIMIENTO DE PEDIDO
      case '#rptmovord':
        $lo_post = $this->co_reg->request->post;
        $lv_ret = [];
        $lv_sqlstm =[];
        $lv_vewfldflt = ($lo_post['vewfldflt']??'');

        $lv_filtro_pedido = '';
        $lv_filtro_entrega = '';
        $lv_filtro_archivo = '';
        $lv_filtro_archivo2 = -1;
        $lv_fltarr = explode( '[~fltrow~]', (isset($lv_vewfldflt)?$lv_vewfldflt:'') );
        foreach($lv_fltarr as $lv_rowarr){
					if(stripos($lv_rowarr,'o.slsordcod')!==false ||
						 stripos($lv_rowarr,'slsordclstxt')!==false ||
             stripos($lv_rowarr,'dstobjtxt')!==false ||
             stripos($lv_rowarr,'cn.cnttxt')!==false ||
             stripos($lv_rowarr,'o.slsorddte')!==false ||
             stripos($lv_rowarr,'cteusr')!==false ||
             stripos($lv_rowarr,'dt.sysdoctretxt')!==false ){
              $lv_rowarr2 = str_ireplace('slsordclstxt','dc.sysdocclstxt',$lv_rowarr);
              $lv_filtro_pedido .= '[~fltrow~]'.$lv_rowarr2;
          }
					if(stripos($lv_rowarr,'d.stkmovdocdte')!== false ||
             stripos($lv_rowarr,'d.stkmovdoccodext')!== false ||
             stripos($lv_rowarr,'dc.sysdocclstxt')!== false ||
          	 stripos($lv_rowarr,'d.docsts')!== false ){
            		$lv_filtro_entrega .= '[~fltrow~]'.$lv_rowarr;
          }
					if( stripos($lv_rowarr,'file_ctedte')!== false ||
							stripos($lv_rowarr,'file_cteusr')!== false ){
                $lv_rowarr = str_ireplace('file_ctedte','f.ctedte',$lv_rowarr);
                $lv_rowarr = str_ireplace('file_cteusr','f.cteusr',$lv_rowarr);
                $lv_filtro_archivo .= '[~fltrow~]'.$lv_rowarr;
					} else if (stripos($lv_rowarr,'file_hasfile')!== false){
						$lv_filtro_archivo2 = (stripos($lv_rowarr,'SI')!=false?1:0);  
          }
        }

        $lv_vewmaxrec = ($lo_post['vewmaxrec']??'100');
        $lv_vewfldord = ($lo_post['vewfldord']??'');

        // PEDIDOS. obtengo todos los pedidos
        $lo_ordmdl=$this->co_reg->load->model('slsord');
        $lv_prm = array('vewfldflt'=>$lv_filtro_pedido,
                                    //'[~fltrow~]o.slsordcod'.chr(9).'IN'.chr(9).chr(9).$lv_slsordcod_lst.chr(9).chr(9),
												'vewfldord'=>'o.slsorddte desc',
                        'vewmaxrec'=>$lv_vewmaxrec);
        $lo_ordrs = $lo_ordmdl->getList($lv_prm,null,null,false);
        // armo clave para filtro de flujo
        $lv_stkmovdoccod_lst = '';
        $lv_slsordcod_lst = '';
        foreach ($lo_ordrs as $lv_row) {
          $lv_slsordcod_lst .= ($lv_slsordcod_lst==''?'':chr(10)).$lv_row['slsordcod'];
        }
        
				// FLUJO. Obtener pedidos-movimientos de salida desde el flujo
				if($lv_slsordcod_lst!=''){
					$lo_flwmdl = $this->co_reg->load->model('grldocflw');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]fp.srcobjtyp'.chr(9).'='.chr(9).chr(9).'SLS_ORD'.chr(9).chr(9).
																				'[~fltrow~]fp.srcobjcod'.chr(9).'IN'.chr(9).chr(9).$lv_slsordcod_lst.chr(9).chr(9).
																				'[~fltrow~]fp.refobjtyp'.chr(9).'='.chr(9).chr(9).'STK_SOU'.chr(9).chr(9).
																				'[~fltrow~]fp.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													'vewfldgrp'=>'fp.srcobjcod, fp.refobjcod',
													'vewmaxrec'=>9999);
					$lo_flwrs = $lo_flwmdl->getList($lv_prm,null,null);
          $lv_sqlstm[]=$lo_flwmdl->getsysdata('sqlstm');

					// armo clave para filtro de movimientos de salida
					foreach ($lo_flwrs as $lv_row) {
						$lv_stkmovdoccod_lst .= ($lv_stkmovdoccod_lst==''?'':chr(10)).$lv_row['refobjcod'];
					}
				} else {
					$lo_flwrs = array();
				}

				// MOVIMINETOS DE SALIDA. obtengo todas los movimientos de salida
        if( $lv_stkmovdoccod_lst!='' ){
          $lo_soumdl= $this->co_reg->load->model('stkmovdoc');
          $lv_prm=array('vewfldflt'=>$lv_filtro_entrega.
                                    '[~fltrow~]d.stkmovdoccod'.chr(9).'IN'.chr(9).chr(9).$lv_stkmovdoccod_lst.chr(9).chr(9),
                       'vewmaxrec'=>9999);
          $lo_sours = $lo_soumdl->getList($lv_prm,null,null,false);
          $lv_sqlstm[]=$lo_soumdl->getsysdata('sqlstm');
					
          // ARCHIVOS
          $lo_flemdl= $this->co_reg->load->model('grldatupl');
          $lv_prm = array('vewfldflt'=>$lv_filtro_archivo.
																			'[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9).'STK_SOU'.chr(9).chr(9).
                                       '[~fltrow~]f.flesrccod'.chr(9).'IN'.chr(9).chr(9).$lv_stkmovdoccod_lst.chr(9).chr(9),
                         'vewmaxrec'=>9999);
          $lo_flers = $lo_flemdl->getList($lv_prm,null,null);
          $lv_sqlstm[]=$lo_flemdl->getsysdata('sqlstm');
          
        } else {
          $lo_sours = array();
          $lo_flers = array();
        }
         
        // se recorre todo el flujo
				foreach($lo_ordrs as $lv_row_ord){ 
					$lv_row['slsordcod'] = $lv_row_ord['slsordcod'];				//ID o.slsordcod
					$lv_row['slsordclstxt'] = $lv_row_ord['sysdocclstxt'];	//Tipo dc.sysdocclstxt
					$lv_row['dstobjtxt'] = $lv_row_ord['dstobjtxt'];				//Cliente dstobjtxt
					$lv_row['cnttxt'] = $lv_row_ord['dstcnttxt'];						//Destino(Contacto)
					$lv_row['slsorddte'] = $lv_row_ord['slsorddte'];				//Fecha de solicitud
					$lv_row['cteusr'] = $lv_row_ord['cteusr'];							//Solicitante
					$lv_row['sysdoctretxt'] = $lv_row_ord['sysdoctretxt'];	//Tratamiento
					$lv_row['stkmovdoccod'] = '';
					$lv_row['stkmovdocdte'] = '';
					$lv_row['stkmovdoccodext'] = '';
					$lv_row['sysdocclstxt'] = '';
          $lv_row['stkmovdocsts'] = '';
					$lv_row['file_ctedte'] = '';
					$lv_row['file_ctehrs'] = ''; 
					$lv_row['file_cteusr'] = '';
					$lv_row['file_hasfile'] = '';

          // recorro el flujo
					$i=0;
          foreach($lo_flwrs as $lv_row_flw){
						if( $lv_row_flw['srcobjcod']==$lv_row_ord['slsordcod'] ){
							$i++;
							// se busca el movimiento de salida
							$lo_sou = array();
							foreach($lo_sours as $lv_row_sou){ if($lv_row_sou['stkmovdoccod']==$lv_row_flw['refobjcod']){ $lo_sou=$lv_row_sou; break; }}
							if(count($lo_sou)>0){              
								$lv_row['stkmovdoccod'] = $lo_sou['stkmovdoccod'];			//CODIGO DE MOVIMIENTO 
								$lv_row['stkmovdocdte'] = $lo_sou['stkmovdocdte'];			//FECHA DE REMITO 
								$lv_row['stkmovdoccodext'] = $lo_sou['stkmovdoccodext'];//NUMERO DE REMITO
								$lv_row['sysdocclstxt'] = $lo_sou['sysdocclstxt'];			//TIPO DE REMITO
                $lv_row['stkmovdocsts'] = $lo_sou['docsts']; //ESTADO DE MOVIMIENTO

								// se busca si tiene archivo
								$lo_fle = array();
								foreach($lo_flers as $lv_row_fle){ if($lv_row_fle['flesrccod']==$lo_sou['stkmovdoccod']){ $lo_fle=$lv_row_fle; break; }}
								
								// Si tiene filtro de archivos
								if( ($lv_filtro_archivo2==1 && count($lo_fle)>0) || ($lv_filtro_archivo2==0 && count($lo_fle)==0) || $lv_filtro_archivo2==-1 ) {
									if( count($lo_fle)>0 ){
										$lv_row['file_ctedte'] = $lo_fle['ctedte']; 			//FECHA DE CREACION DE MOVIMIENTO
										$lv_tmp = $lo_fle['ctedte']; 
										$lv_row['file_ctehrs'] = $lv_tmp->format('H:i');	//HORA DE CREACION DE MOVIMIENTO
										$lv_row['file_cteusr'] = $lo_fle['cteusr']; 		  //OPERADOR DE MOVIMIENTO  
									}
									$lv_row['file_hasfile'] = (count($lo_fle)>0?'SI':'NO');
									array_push($lv_ret,$lv_row);
								}
							
							} else if( $lv_filtro_entrega=='' && $lv_filtro_archivo=='' && $lv_filtro_archivo2==-1 ){
								array_push($lv_ret,$lv_row);
							}
						}
          }
					if( $i==0 && $lv_filtro_entrega=='' && $lv_filtro_archivo=='' && $lv_filtro_archivo==-1 ){
						array_push($lv_ret,$lv_row);
					}
					
        }
        $lv_ret[0]['sqlstm']=$lv_sqlstm;
    		return $lv_ret;
        break;
      case '#chksup': 
        $ret = array('errtyp'=>'S','errcod'=>'0','errtxt'=>'');
        $section= $lp_prm['data']['lv_sec']??'';
        //Busco las clase de documento
        $mdlCls=$this->co_reg->load->model('sysdoccls');
        $lvClsCodExtIn=['PP'];
        $lv_prm = array('vewfldflt'=>'[~fltrow~]d.objtyp'.chr(9).'='.chr(9).chr(9).'BUY_SUP'.chr(9).chr(9).
                                     '[~fltrow~]d.sysdocclscodext'.chr(9).'IN'.chr(9).chr(9).implode(chr(10),$lvClsCodExtIn).chr(9).chr(9),
                         'vewmaxrec'=>9999);
        $rsClsLst = $mdlCls->getList($lv_prm,null,null);
        $lstClsCod=array_column($rsClsLst, 'sysdocclscod','sysdocclscodext'); 
        
        //Busco el proveedor
        $mdlSup=$this->co_reg->load->model('buysup');
        $mdlSup->load(array('supcod'=>$lp_prm['data']['srcobjcod']));
        if(isset($lstClsCod['PP']) && $mdlSup->sysdocclscod==$lstClsCod['PP']){
          $tmp_dialog=''.
            'BootstrapDialog.show({'.
              'title: "Verificación del proveedor", '.
							'message: "<strong>¡Atención!</strong><br>El proveedor <strong>' .$mdlSup->suptxt.'</strong> no se encuentra aprobado.",'.
              'type: BootstrapDialog.TYPE_DANGER ,'.
              'size: BootstrapDialog.SIZE_NORMAL,'.
            '});';
          $ret = array(
          'errtyp'=>'E',
          'errcod'=>'-125',
          'errtxt'=>'<strong>¡Atención!</strong><br>El proveedor <strong>' .$mdlSup->suptxt.'</strong> no se encuentra aprobado.',
          'errjva'=>$tmp_dialog
        	);
        }
        return $ret;
        break;
        
      //REPORTE ORDEN DE COMPRA LOGISTICA. (Pedidos) 
      case "#rptbuyord":
        $lo_ordmatmdl = $this->co_reg->load->model('buyordmat');
        $lstSqlStm=[];
        /* PREPARAMOS LOS FILTROS DE LAS POSICIONES DE LOS PEDIDOS*/
        $lv_vewfldflt = (isset($this->co_reg->request->post['vewfldflt'])?$this->co_reg->request->post['vewfldflt']:'');
				$lv_vewmaxrec = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewmaxrec']:'');
        $lv_vewfldord = (isset($this->co_reg->request->post['vewfldord'])?$this->co_reg->request->post['vewfldord']:'o.buyorddte desc');
        
				$lv_fltarr = explode('[~fltrow~]',$lv_vewfldflt );
				for($i=count($lv_fltarr)-1; $i>0; $i--){
				 if(stripos(';matcod;mattxt;buyorddte;sysdoctretxt;sysdocrejtxt;',';'.explode(chr(9),$lv_fltarr[$i])[0].';')===false){
				 	unset($lv_fltarr[$i]);
				 }else{
           $lv_fltarr[$i] = str_replace('matcod','m.matcod',$lv_fltarr[$i]); //ID Material
           $lv_fltarr[$i] = str_replace('mattxt','m.mattxt',$lv_fltarr[$i]); //Descripcion Material
           $lv_fltarr[$i] = str_replace('buyorddte','o.buyorddte',$lv_fltarr[$i]); //Fecha OC
           $lv_fltarr[$i] = str_replace('sysdocrejtxt','dr.sysdocrejtxt',$lv_fltarr[$i]); //Motivo de rechazo
           $lv_fltarr[$i] = str_replace('sysdoctretxt','dt.sysdoctretxt',$lv_fltarr[$i]); //Tratamiento de posicion
         }
				}
        $lv_ordmatprm = array('vewfldflt' =>'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                              							'[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).'BUY_ORD'.chr(9).chr(9).
                              							(count($lv_fltarr)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltarr):''),
                              'vewfldord' => ($lv_vewfldord==''?'o.buyorddte desc':$lv_vewfldord),
                              'vewmaxrec' => $lv_vewmaxrec);
        $lo_rsordmat = $lo_ordmatmdl->getList($lv_ordmatprm);
        $lstSqlStm[]=$lo_ordmatmdl->getsysdata('sqlstm');
        
        $lv_ordlst = array();
        foreach( $lo_rsordmat as $lo_row) {
        	$lv_ordlst[] = $lo_row['buyordcod'];
        }
        
        //PREPARAMOS LOS FILTROS DE LOS PEDIDOS
        $lv_fltordarr = explode('[~fltrow~]',$lv_vewfldflt );
        $lv_fltord = false;
        for($i=count($lv_fltordarr)-1; $i>0; $i--){
				 if(stripos(';sysdoctretxt2;srcobjtxt;',';'.explode(chr(9),$lv_fltordarr[$i])[0].';')===false){
				 	unset($lv_fltordarr[$i]);
				 }else{
           $lv_fltordarr[$i] = str_replace('sysdoctretxt2','sysdoctretxt',$lv_fltordarr[$i]); //Tratamiento de cabecera
           $lv_fltordarr[$i] = str_replace('srcobjtxt','srcobjtxt',$lv_fltordarr[$i]); //Proveedor
           $lv_fltord = true;
         }
				}
        
        $lo_ordmdl = $this->co_reg->load->model('buyord');
        
        $lv_ordprm = array('vewfldflt' =>'[~fltrow~]o.buyordcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lv_ordlst) .chr(9).chr(9).
                           							 '[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                                         '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).'BUY_ORD'.chr(9).chr(9).
                           								(count($lv_fltordarr)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltordarr):'')
                          );
        $lo_rsord = $lo_ordmdl->getList($lv_ordprm, null, null, false);
        $lstSqlStm[]=$lo_ordmdl->getsysdata('sqlstm');

        
        
        $lv_ordmatlst=array();
        foreach( $lo_rsord as $lo_ordrow) {
        	$lv_ordmatlst[$lo_ordrow['buyordcod']]['srcobjtxt']=$lo_ordrow['srcobjtxt'];
          $lv_ordmatlst[$lo_ordrow['buyordcod']]['sysdoctretxt']=$lo_ordrow['sysdoctretxt'];
        }
        $lo_ret=array();
				foreach( $lo_rsordmat as $lo_row) {
        	$lo_ordrow=$lo_row;
          $lo_ordrow['srcobjtxt']='';
          $lo_ordrow['sysdoctretxt2']='';
          
          if(isset($lv_ordmatlst[$lo_ordrow['buyordcod']])){
            $lo_ordrow['srcobjtxt']=$lv_ordmatlst[$lo_ordrow['buyordcod']]['srcobjtxt'];
            $lo_ordrow['sysdoctretxt2']=$lv_ordmatlst[$lo_ordrow['buyordcod']]['sysdoctretxt'];    
          }elseif($lv_fltord==true){
            continue;
          }
          $lo_ret[]=$lo_ordrow;
          
        }
        $lo_ret[0]['sqlstm']=$lstSqlStm;
        return $lo_ret;
			break;
      //   R E P O R T E   L O G I S T I C A   -   T R A N S P O R T E S / E N T R E G A S
      case '#lgnrpttradlv':
        $lo_post = $this->co_reg->request->post;
        $lv_data_sqlstm = array();

        $lo_tramdl = $this->co_reg->load->model('logtra');
        $lo_dlvmdl = $this->co_reg->load->model('logtradlv');

        $lv_flttra = array();
        $lv_fltdlv = array();
        $lv_fltarr = explode('[~fltrow~]', ($lo_post['vewfldflt']??''));

        $lv_trafldmap = array(
          'tracod' => 't.tracod',
          'tracodext' => 't.tracodext',
          'tradte' => 't.tradte',
          'drvtxt' => 'd.drvtxt',
          'trastrdte' => 't.trastrdte',
          'traenddte' => 't.traenddte',
          'trasts' => 'trasts',
          'tradlvqty' => 't.tradlvqty',
          'traroutxt' => 'r.traroutxt',
          'vhccodext' => 'v.vhccodext'
        );

        $lv_dlvfldmap = array(
          'stkmovdoccod' => 'td.stkmovdoccod',
          'stkmovdoccodext' => 'd.stkmovdoccodext',
          'dstobjtxt' => 'ad.adrnme001',
          'dstcnttxt' => 'adc.adrnme001',
          'stkmovdoccnfdte' => 'dbo.gettagvalue(^cnfdte^, d.stkmovdoccnf)',
          'stkmovdoccnftyp' => 'dbo.gettagvalue(^cnftyp^, d.stkmovdoccnf)',
          'stkmovdoccnfcmt' => 'dbo.gettagvalue(^cnfcmt^, d.stkmovdoccnf)'
        );

        for($i=count($lv_fltarr)-1; $i>0; $i--){
          $lv_fltrow = explode(chr(9), $lv_fltarr[$i]);
          $lv_fldcod = strtolower(trim($lv_fltrow[0]??''));

          if(isset($lv_trafldmap[$lv_fldcod])){
            $lv_fltrow[0] = $lv_trafldmap[$lv_fldcod];
            $lv_flttra[] = implode(chr(9), $lv_fltrow);
          }else if(isset($lv_dlvfldmap[$lv_fldcod])){
            $lv_fltrow[0] = $lv_dlvfldmap[$lv_fldcod];
            $lv_fltdlv[] = implode(chr(9), $lv_fltrow);
          }
        }

        $lv_traidx = array();
        $lv_tracodlst = '';

        // Si hay filtros de cabecera, primero se obtienen los transportes para acotar las entregas.
        if(count($lv_flttra)>0){
          $lv_prmtra = array(
            'vewfldflt' => '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).'LOG_TRA'.chr(9).chr(9).
                           '[~fltrow~]'.implode('[~fltrow~]', $lv_flttra),
            'vewfldord' => 't.tracod desc'
          );
          $lo_trars = $lo_tramdl->getList($lv_prmtra, null, null, false);
          $lv_data_sqlstm[] = $lo_tramdl->getsysdata('sqlstm');

          if(!is_array($lo_trars) || isset($lo_trars['errtyp'])){
            return array();
          }

          foreach($lo_trars as $lv_rowtra){
            $lv_tracod = $lv_rowtra['tracod']??'';
            if($lv_tracod===''){ continue; }
            $lv_traidx[$lv_tracod] = $lv_rowtra;
            $lv_tracodlst .= ($lv_tracodlst==''?'':chr(10)).$lv_tracod;
          }

          if($lv_tracodlst==''){
            return array();
          }
        }

        $lv_prmdlv = array(
          'vewfldflt' => ($lv_tracodlst!=''?'[~fltrow~]td.tracod'.chr(9).'IN'.chr(9).chr(9).$lv_tracodlst.chr(9).chr(9):'').
                         (count($lv_fltdlv)>0?'[~fltrow~]'.implode('[~fltrow~]', $lv_fltdlv):''),
          'vewfldord' => 'td.tracod desc, td.tradlvord, td.tradlvcod',
          'vewmaxrec' => ($lo_post['vewmaxrec']??'101')
        );
        $lo_dlvrs = $lo_dlvmdl->getList($lv_prmdlv);
        $lv_data_sqlstm[] = $lo_dlvmdl->getsysdata('sqlstm');

        if(!is_array($lo_dlvrs) || isset($lo_dlvrs['errtyp']) || count($lo_dlvrs)==0){
          return array();
        }

        // LOG_TRA_DLV_DEF enlaza domicilios y puede repetir una entrega si hay mas de uno.
        $lv_dlvuniq = array();
        foreach($lo_dlvrs as $lv_rowdlv){
          $lv_dlvkey = trim((string)($lv_rowdlv['tradlvcod']??''));
          if($lv_dlvkey===''){
            $lv_dlvkey = trim((string)($lv_rowdlv['tracod']??'')).'|'.trim((string)($lv_rowdlv['stkmovdoccod']??''));
          }
          if(!isset($lv_dlvuniq[$lv_dlvkey])){
            $lv_dlvuniq[$lv_dlvkey] = $lv_rowdlv;
          }
        }
        $lo_dlvrs = array_values($lv_dlvuniq);

        // Si no hubo filtros de cabecera, se cargan solo los transportes referenciados por las entregas encontradas.
        if(count($lv_traidx)==0){
          foreach($lo_dlvrs as $lv_rowdlv){
            $lv_tracod = $lv_rowdlv['tracod']??'';
            if($lv_tracod!=='' && stripos(chr(10).$lv_tracodlst.chr(10), chr(10).$lv_tracod.chr(10))===false){
              $lv_tracodlst .= ($lv_tracodlst==''?'':chr(10)).$lv_tracod;
            }
          }

          if($lv_tracodlst!=''){
            $lv_prmtra = array(
              'vewfldflt' => '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).'LOG_TRA'.chr(9).chr(9).
                             '[~fltrow~]t.tracod'.chr(9).'IN'.chr(9).chr(9).$lv_tracodlst.chr(9).chr(9),
              'vewfldord' => 't.tracod desc'
            );
            $lo_trars = $lo_tramdl->getList($lv_prmtra, null, null, false);
            $lv_data_sqlstm[] = $lo_tramdl->getsysdata('sqlstm');

            if(!is_array($lo_trars) || isset($lo_trars['errtyp'])){
              return array();
            }

            foreach($lo_trars as $lv_rowtra){
              if(($lv_rowtra['tracod']??'')===''){ continue; }
              $lv_traidx[$lv_rowtra['tracod']] = $lv_rowtra;
            }
          }
        }

        $lv_dstdat = $this->getTraDlvDestinationData($lo_dlvrs, $lv_data_sqlstm);
        $lv_ret = array();
        foreach($lo_dlvrs as $lv_rowdlv){
          $lv_tracod = $lv_rowdlv['tracod']??'';
          if(!isset($lv_traidx[$lv_tracod])){ continue; }

          $lv_rowtra = $lv_traidx[$lv_tracod];
          $lv_dstcntcod = trim((string)($lv_rowdlv['dstcntcod']??''));
          $lv_dstobjkey = trim((string)($lv_rowdlv['dstobjtyp']??'')).'|'.trim((string)($lv_rowdlv['dstobjcod']??''));
          $lv_dstcnttxt = $lv_dstdat['cnttxt'][$lv_dstcntcod]??($lv_rowdlv['dstcnttxt']??'');
          $lv_dstobjtxt = $lv_rowdlv['dstobjtxt']??'';
          if(trim((string)$lv_dstobjtxt)==='' && isset($lv_dstdat['objadr'][$lv_dstobjkey])){
            $lv_dstobjtxt = $lv_dstdat['objadr'][$lv_dstobjkey]['adrnme001']??'';
          }

          // El domicilio del contacto tiene prioridad. Si no existe, se usa el del objeto destino.
          $lv_dstadr = array();
          if($lv_dstcnttxt!=='' && isset($lv_dstdat['cntadr'][$lv_dstcntcod])){
            $lv_dstadr = $lv_dstdat['cntadr'][$lv_dstcntcod];
          }else if(isset($lv_dstdat['objadr'][$lv_dstobjkey])){
            $lv_dstadr = $lv_dstdat['objadr'][$lv_dstobjkey];
          }

          $lv_cnftyp = $lv_rowdlv['stkmovdoccnftyp']??($lv_rowdlv['dlvcnfsts']??'');
          $lv_cnfcmt = $lv_rowdlv['stkmovdoccnfcmt']??($lv_rowdlv['dlvcnfcmt']??'');
          $lv_ret[] = array(
            'tracod' => $lv_rowtra['tracod']??'',
            'tracodext' => $lv_rowtra['tracodext']??'',
            'tradte' => $lv_rowtra['tradte']??'',
            'drvtxt' => $lv_rowtra['drvtxt']??'',
            'trastrdte' => $lv_rowtra['trastrdte']??'',
            'traenddte' => $lv_rowtra['traenddte']??'',
            'trasts' => $lv_rowtra['trasts']??'',
            'tradlvqty' => $lv_rowtra['tradlvqty']??'',
            'traroutxt' => $lv_rowtra['traroutxt']??'',
            'vhccodext' => $lv_rowtra['vhccodext']??'',
            'stkmovdoccod' => $lv_rowdlv['stkmovdoccod']??'',
            'stkmovdoccodext' => $lv_rowdlv['stkmovdoccodext']??'',
            'dstobjtxt' => $lv_dstobjtxt,
            'dstcnttxt' => $lv_dstcnttxt,
            'dstadrtxt' => $this->formatTraDlvAddress($lv_dstadr),
            'dstlndregtxt' => $lv_dstadr['lndregtxt']??'',
            'dstzontxt' => trim((string)($lv_dstadr['adrzontxt']??''))!=='' ? $lv_dstadr['adrzontxt'] : ($lv_dstadr['adrzon']??''),
            'stkmovdoccnfdte' => ($lv_rowdlv['stkmovdoccnfdte']??($lv_rowdlv['dlvcnfdte']??'')),
            'stkmovdoccnftyp' => $lv_cnftyp,
            'stkmovdoccnfcmt' => $this->getTraDlvFailureComment($lv_cnftyp, $lv_cnfcmt)
          );
        }

        if(count($lv_ret)>0){
          $lv_ret[0]['sqlstm'] = $lv_data_sqlstm;
        }

        return $lv_ret;
        break;
      case '#buyordrpt': {
        $lo_ordmatmdl = $this->co_reg->load->model('buyordmat');
        $lstSqlStm=[];
        /* PREPARAMOS LOS FILTROS DE LAS POSICIONES DE LOS PEDIDOS*/
        $lv_vewfldflt = (isset($this->co_reg->request->post['vewfldflt'])?$this->co_reg->request->post['vewfldflt']:'');
				$lv_vewmaxrec = (isset($this->co_reg->request->post['vewmaxrec'])?$this->co_reg->request->post['vewmaxrec']:'');
        $lv_vewfldord = (isset($this->co_reg->request->post['vewfldord'])?$this->co_reg->request->post['vewfldord']:'o.buyorddte desc');
        
        // mapas de campos permitidos por getList
        $lv_det_map = array(
          'matcod'         => 'm.matcod',
          'mattxt'         => 'm.mattxt',
          'matqty'         => 'matqty',
          'buyordcod'      => 'o.buyordcod',
          'buyorddtecnv'   => 'buyorddte',
          'buyorddte'      => 'o.buyorddte',
          'sysdoctretxt'   => 'dt.sysdoctretxt',
          'dc.sysdocclstxt'=> 'dc.sysdocclstxt',
          'sysdocrejtxt'   => 'dr.sysdocrejtxt'
        );
        $lv_cab_map = array(
          'o.sysdoctretxt' => 'sysdoctretxt',
          'sysdoctretxt2'  => 'sysdoctretxt',
          'srcobjtxt'      => 'srcobjtxt'
        );
        
        $lv_fltarr_det = array();
        $lv_fltarr_cab = array();
        $lv_fltord = false;
        $lv_fltrows = explode('[~fltrow~]', $lv_vewfldflt);
        for ($i = count($lv_fltrows) - 1; $i > 0; $i--) {
          $lv_row = $lv_fltrows[$i];
          if ($lv_row === '') { continue; }
          $lv_parts = explode(chr(9), $lv_row);
          $lv_fld = trim($lv_parts[0] ?? '');
          if ($lv_fld === '') { continue; }
          // si el campo aplica a detalle, lo agrego transformado
          if (isset($lv_det_map[$lv_fld])) {
            $lv_parts_det = $lv_parts;
            $lv_parts_det[0] = $lv_det_map[$lv_fld];
            $lv_fltarr_det[] = implode(chr(9), $lv_parts_det);
          }
          // si el campo aplica a cabecera, lo agrego transformado
          if (isset($lv_cab_map[$lv_fld])) {
            $lv_parts_cab = $lv_parts;
            $lv_parts_cab[0] = $lv_cab_map[$lv_fld];
            $lv_fltarr_cab[] = implode(chr(9), $lv_parts_cab);
            $lv_fltord = true;
          }
        }
        $lv_ordmatprm = array('vewfldflt' =>'[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                         							 			'[~fltrow~]om.sysdoctrecod'.chr(9).'IN'.chr(9).chr(9). 'N' .chr(9).chr(9).
                              							(count($lv_fltarr_det)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltarr_det):''),
                              'vewfldord' => ($lv_vewfldord==''?'o.buyorddte desc':$lv_vewfldord),
                              'vewmaxrec' => $lv_vewmaxrec);
        $lo_rsordmat = $lo_ordmatmdl->getList($lv_ordmatprm);
        $lstSqlStm[]=$lo_ordmatmdl->getsysdata('sqlstm');
        
        $lv_ordlst = array_values(array_unique(array_column($lo_rsordmat, 'buyordcod')));
        
        $lo_ordmdl = $this->co_reg->load->model('buyord');
        
        $lv_ordprm = array('vewfldflt' =>'[~fltrow~]o.buyordcod'.chr(9).'IN'.chr(9).chr(9). implode(chr(10),$lv_ordlst) .chr(9).chr(9).
                           							 '[~fltrow~]o.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9).
                           								(count($lv_fltarr_cab)>0?'[~fltrow~]'.implode('[~fltrow~]',$lv_fltarr_cab):'')
                          );
        $lo_rsord = $lo_ordmdl->getList($lv_ordprm, null, null, false);
        $lstSqlStm[]=$lo_ordmdl->getsysdata('sqlstm');
        
        $lv_ordmatlst=array();
        foreach( $lo_rsord as $lo_ordrow) {
        	$lv_ordmatlst[$lo_ordrow['buyordcod']]['srcobjtxt']=$lo_ordrow['srcobjtxt'];
          $lv_ordmatlst[$lo_ordrow['buyordcod']]['sysdoctretxt']=$lo_ordrow['sysdoctretxt'];
        }
        $lo_ret=array();
				foreach( $lo_rsordmat as $lo_row) {
        	$lo_ordrow=$lo_row;
          $lo_ordrow['srcobjtxt']='';
          $lo_ordrow['sysdoctretxt2']='';
          
          if(isset($lv_ordmatlst[$lo_ordrow['buyordcod']])){
            $lo_ordrow['srcobjtxt']=$lv_ordmatlst[$lo_ordrow['buyordcod']]['srcobjtxt'];
            $lo_ordrow['sysdoctretxt2']=$lv_ordmatlst[$lo_ordrow['buyordcod']]['sysdoctretxt'];    
          }elseif($lv_fltord==true){
            continue;
          }
          $lo_ret[]=$lo_ordrow;
          
        }
        $lo_ret[0]['sqlstm']=$lstSqlStm;
        return $lo_ret;
        break;
      }
      //REPORTE SEGUIMIENTO DE ORDEN DE COMPRA
	      case '#rptmovbuyord':{
        $lo_post = $this->co_reg->request->post;
        $lv_ret = [];
        $lv_sqlstmlst=[];
        $lv_vewfldflt = ($lo_post['vewfldflt'] ?? '');
        $lv_fltarr = explode('[~fltrow~]', $lv_vewfldflt);
        $lv_filtro_pedido = '';
        $lv_filtro_entrega = '';
        $lv_filtro_archivo = '';
        $lv_filtro_archivo2 = -1;
        // Campos permitidos y mapeos
        $lv_map_pedido = array(
          'buyordcod'    => 'o.buyordcod',
          'buyordclstxt'   => 'dc.sysdocclstxt',
          'srcobjtxt'      => 'srcobjtxt',
          'buyorddte'    => 'o.buyorddte',
          'cteusr'         => 'o.cteusr',
          'sysdoctretxt'=> 'dt.sysdoctretxt'
        );
        $lv_map_entrega = array(
          'd.stkmovdocdte'    => 'd.stkmovdocdte',
          'd.stkmovdoccodext' => 'd.stkmovdoccodext',
          'dc.sysdocclstxt'   => 'dc.sysdocclstxt'
        );
        $lv_map_archivo = array(
          'file_ctedte' => 'f.ctedte',
          'file_cteusr' => 'f.cteusr'
        );
        for ($i = count($lv_fltarr) - 1; $i > 0; $i--) {
          $lv_rowarr = $lv_fltarr[$i];
          if ($lv_rowarr === '') { continue; }
          $lv_parts = explode(chr(9), $lv_rowarr);
          $lv_fld = trim($lv_parts[0] ?? '');
          if ($lv_fld === '') { continue; }
          // Pedido (buyord)
          if (isset($lv_map_pedido[$lv_fld])) {
            $lv_parts_ped = $lv_parts;
            $lv_parts_ped[0] = $lv_map_pedido[$lv_fld];
            $lv_filtro_pedido .= '[~fltrow~]' . implode(chr(9), $lv_parts_ped);
          }
          // Entrega (stkmovdoc / STK_SIN)
          if (isset($lv_map_entrega[$lv_fld])) {
            $lv_parts_ent = $lv_parts;
            $lv_parts_ent[0] = $lv_map_entrega[$lv_fld];
            $lv_filtro_entrega .= '[~fltrow~]' . implode(chr(9), $lv_parts_ent);
          }
          // Archivo (grldatupl)
          if (isset($lv_map_archivo[$lv_fld])) {
            $lv_parts_fle = $lv_parts;
            $lv_parts_fle[0] = $lv_map_archivo[$lv_fld];
            $lv_filtro_archivo .= '[~fltrow~]' . implode(chr(9), $lv_parts_fle);
          } else if (stripos($lv_fld, 'file_hasfile') !== false) {
            // Mantiene semántica actual SI/NO
            $lv_filtro_archivo2 = (stripos($lv_rowarr, 'SI') !== false ? 1 : 0);
          }
        }
        $lv_vewmaxrec = ($lo_post['vewmaxrec']??'100');
        // ORDENES DE COMPRA. obtengo todas las ordenes
        $lo_ordmdl=$this->co_reg->load->model('buyord');
        
        $lv_prm = array('vewfldflt'=>$lv_filtro_pedido,
												'vewfldord'=>'o.buyorddte desc',
                        'vewmaxrec'=>$lv_vewmaxrec);
        $lo_ordrs = $lo_ordmdl->getList($lv_prm,null,null,false);
        $lv_sqlstmlst[]=$lo_ordmdl->getsysdata('sqlstm');
        //var_dump($lv_sqlstmlst);
        // armo clave para filtro de flujo
        $lv_stkmovdoccod_lst = '';
        $lv_buyordcod_lst = '';
        foreach ($lo_ordrs as $lv_row) {
          $lv_buyordcod_lst .= ($lv_buyordcod_lst==''?'':chr(10)).$lv_row['buyordcod'];
        }

				// FLUJO. Obtener ordenes-movimientos de entrada desde el flujo
				if($lv_buyordcod_lst!=''){
					$lo_flwmdl = $this->co_reg->load->model('grldocflw');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]fp.srcobjtyp'.chr(9).'='.chr(9).chr(9).'BUY_ORD'.chr(9).chr(9).
																						'[~fltrow~]fp.srcobjcod'.chr(9).'IN'.chr(9).chr(9).$lv_buyordcod_lst.chr(9).chr(9).
																						'[~fltrow~]fp.refobjtyp'.chr(9).'='.chr(9).chr(9).'STK_SIN'.chr(9).chr(9).
																						'[~fltrow~]fp.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
															'vewfldgrp'=>'fp.srcobjcod, fp.refobjcod',
															'vewmaxrec'=>9999);
					$lo_flwrs = $lo_flwmdl->getList($lv_prm,null,null);
          $lv_sqlstmlst[]=$lo_flwmdl->getsysdata('sqlstm');

					// armo clave para filtro de movimientos de entrada
					foreach ($lo_flwrs as $lv_row) {
						$lv_stkmovdoccod_lst .= ($lv_stkmovdoccod_lst==''?'':chr(10)).$lv_row['refobjcod'];
					}
				} else {
					$lo_flwrs = array();
				}

				// MOVIMIENTOS DE ENTRADA. obtengo todas los movimientos de entrada
        if( $lv_stkmovdoccod_lst!='' ){
          $lo_sinmdl= $this->co_reg->load->model('stkmovdoc');
          $lv_prm=array('vewfldflt'=>$lv_filtro_entrega.
                                    '[~fltrow~]d.stkmovdoccod'.chr(9).'IN'.chr(9).chr(9).$lv_stkmovdoccod_lst.chr(9).chr(9),
                       'vewmaxrec'=>9999);
          $lo_sinrs = $lo_sinmdl->getList($lv_prm,null,null,false);
          $lv_sqlstmlst[]=$lo_sinmdl->getsysdata('sqlstm');

          // ARCHIVOS
          $lo_flemdl= $this->co_reg->load->model('grldatupl');
          $lv_prm = array('vewfldflt'=>$lv_filtro_archivo.
																					'[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9).'STK_SIN'.chr(9).chr(9).
                                       '[~fltrow~]f.flesrccod'.chr(9).'IN'.chr(9).chr(9).$lv_stkmovdoccod_lst.chr(9).chr(9),
                         'vewmaxrec'=>9999);
          $lo_flers = $lo_flemdl->getList($lv_prm,null,null);
          $lv_sqlstmlst[]=$lo_flemdl->getsysdata('sqlstm');

        } else {
          $lo_sinrs = array();
          $lo_flers = array();
        }

        // se recorre todo el flujo
				foreach($lo_ordrs as $lv_row_ord){
					$lv_row['buyordcod'] = $lv_row_ord['buyordcod'];
					$lv_row['buyordclstxt'] = $lv_row_ord['sysdocclstxt'];
					$lv_row['srcobjtxt'] = $lv_row_ord['srcobjtxt'];
					$lv_row['buyorddte'] = $lv_row_ord['buyorddte'];
					$lv_row['cteusr'] = $lv_row_ord['cteusr'];
					$lv_row['sysdoctretxt'] = $lv_row_ord['sysdoctretxt'];
					$lv_row['stkmovdoccod'] = '';
					$lv_row['stkmovdocdte'] = '';
					$lv_row['stkmovdoccodext'] = '';
					$lv_row['sysdocclstxt'] = '';
					$lv_row['file_ctedte'] = '';
					$lv_row['file_ctehrs'] = '';
					$lv_row['file_cteusr'] = '';
					$lv_row['file_hasfile'] = '';

          // recorro el flujo
					$i=0;
          foreach($lo_flwrs as $lv_row_flw){
						if( $lv_row_flw['srcobjcod']==$lv_row_ord['buyordcod'] ){
							$i++;
							// se busca el movimiento de entrada
							$lo_sin = array();
							foreach($lo_sinrs as $lv_row_sin){ if($lv_row_sin['stkmovdoccod']==$lv_row_flw['refobjcod']){ $lo_sin=$lv_row_sin; break; }}
							if(count($lo_sin)>0){
								$lv_row['stkmovdoccod'] = $lo_sin['stkmovdoccod'];
								$lv_row['stkmovdocdte'] = $lo_sin['stkmovdocdte'];
								$lv_row['stkmovdoccodext'] = $lo_sin['stkmovdoccodext'];
								$lv_row['sysdocclstxt'] = $lo_sin['sysdocclstxt'];

								// se busca si tiene archivo
								$lo_fle = array();
								foreach($lo_flers as $lv_row_fle){ if($lv_row_fle['flesrccod']==$lo_sin['stkmovdoccod']){ $lo_fle=$lv_row_fle; break; }}

								// Si tiene filtro de archivos
								if( ($lv_filtro_archivo2==1 && count($lo_fle)>0) || ($lv_filtro_archivo2==0 && count($lo_fle)==0) || $lv_filtro_archivo2==-1 ) {
									if( count($lo_fle)>0 ){
										$lv_row['file_ctedte'] = $lo_fle['ctedte'];
										$lv_tmp = $lo_fle['ctedte'];
										$lv_row['file_ctehrs'] = $lv_tmp->format('H:i');
										$lv_row['file_cteusr'] = $lo_fle['cteusr'];
									}
									$lv_row['file_hasfile'] = (count($lo_fle)>0?'SI':'NO');
									array_push($lv_ret,$lv_row);
								}

							} else if( $lv_filtro_entrega=='' && $lv_filtro_archivo=='' && $lv_filtro_archivo2==-1 ){
								array_push($lv_ret,$lv_row);
							}
						}
          }
					if( $i==0 && $lv_filtro_entrega=='' && $lv_filtro_archivo=='' && $lv_filtro_archivo2==-1 ){
						array_push($lv_ret,$lv_row);
					}
        }
        $lv_ret[0]['sqlstm']=$lv_sqlstmlst;
	    	return $lv_ret;
        break;
    	}
      case '#slssvclqdpntxls':
        $lo_slssvclqd = $this->co_reg->load->model('slssvclqd');
        $lv_slssvclqdcod = (isset($this->co_reg->request->post['srcobjcod'])?$this->co_reg->request->post['srcobjcod']:$lp_prm['srcobjcod']);
        
        $lv_prm = array('vewfldflt' =>'[~fltrow~]l.slssvclqdcod'.chr(9).'='.chr(9).chr(9).$lv_slssvclqdcod.chr(9).chr(9));
        $lo_slssvclqd = $lo_slssvclqd->getList($lv_prm);
        
        $lo_slssvclqddoc = $this->co_reg->load->model('slssvclqddoc');
        $lv_dat = $lo_slssvclqddoc->getServices( array(), array( 'slssvclqdcod' => $lv_slssvclqdcod ) );
        
        $this->co_reg->response->addHeader('Content-Disposition: attachment; filename=Liquidaciones.xls');
        $this->co_reg->response->addHeader('Content-Type: application/vnd.ms-excel');

        $lv_buffer = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head>
        <style id="Leads_style">
          table {
            mso-displayed-decimal-separator:"\.";
            mso-displayed-thousand-separator:"\,";
          } 
        </style>
        </head><body>';
        
        
        $lv_dat_idx = array();
        foreach( $lv_dat as $key => $lv_row ) {
          $lv_dat_idx[$lv_row['slssvclqddoccod']] = $key;
        }
        foreach( $lv_dat as $key => $lv_row ) {
          if($lv_row['refobjtyp'] == 'SLS_SVL'){
            $lv_rowid = $lv_row['refobjcod002'];
            if( isset($lv_dat_idx[$lv_rowid]) && isset($lv_dat[$lv_dat_idx[$lv_rowid]]) ) {
              $key2 = $lv_dat_idx[$lv_rowid];
              $lv_dat[$key]['refobjtyp'] = $lv_dat[$key2]['refobjtyp'];
              $lv_dat[$key]['stkobjtyp'] = $lv_dat[$key2]['stkobjtyp'];
              $lv_dat[$key]['matcod'] = $lv_dat[$key2]['matcod'];
              $lv_dat[$key]['refobjcod001'] = $lv_dat[$key2]['refobjcod001'];
              $lv_dat[$key]['refobjcod002'] = $lv_dat[$key2]['refobjcod002'];
              $lv_dat[$key]['slssvclqddoccodext'] = $lv_dat[$key2]['slssvclqddoccodext'];
              $lv_dat[$key]['aju'] = "X";
              unset($lv_dat[$key2]);
              unset($lv_dat_idx[$lv_rowid]);
            }
          }
        }
        unset($lv_dat_idx);

        // recolecta IDs de movimientos y contactos para datos adicionales
        $lv_movids = array();
        $lv_cntids = array();
        foreach( $lv_dat as $lv_row ) {
          if( ($lv_row['aju']??'') != 'X' && $lv_row['refobjtyp'] != 'STK_HST' && !empty($lv_row['refobjcod001']) ) {
            $lv_movids[$lv_row['refobjcod001']] = true;
          }
          if( !empty($lv_row['stkcntcod']) ) {
            $lv_cntids[$lv_row['stkcntcod']] = true;
          }
        }

        // CARGA MOVIMIENTOS (remito + serie) para filas con movimiento directo (NO STK_HST)
        // stkmovdoccod|stkmovdocmatcod
        $lv_movdat = array();
        if( !empty($lv_movids) ) {
          $lv_movkey = implode(chr(10), array_keys($lv_movids));
          $lo_movmatmdl = $this->co_reg->load->model('stkmovdocmat');
          $lv_prm = array('vewfldflt' => '[~fltrow~]d.stkmovdoccod'.chr(9).'IN'.chr(9).chr(9).$lv_movkey.chr(9).chr(9).
                           '[~fltrow~]d.docsts'.chr(9).'='.chr(9).chr(9).'C'.chr(9).chr(9));
          $lo_movmatrs = $lo_movmatmdl->getList($lv_prm);
          if( is_array($lo_movmatrs) && !isset($lo_movmatrs['errtyp']) ) {
            foreach( $lo_movmatrs as $lv_row ) {
              $lv_idx = $lv_row['stkmovdoccod'] . '|' . $lv_row['stkmovdocmatcod'];
              $lv_movdat[$lv_idx] = array(
                'stkmovdoccodext' => ($lv_row['stkmovdoccodext'] ?? ''),
                'matsercodext' => ($lv_row['matsercodext'] ?? '')
              );
            }
          }
        }

        // busca el serial desde el stock actual del paciente (stkmatstk)
        // No usa movimientos porque STK_HST no tiene movimiento asociado a la liquidacion
        // stkobjcod|stkcntcod|matcod para asociar cada serial al contacto correcto
        $lv_fbdat = array();
        $lv_fbkeys = array();
        foreach( $lv_dat as $lv_row ) {
          if( ($lv_row['refobjtyp']??'') == 'STK_HST' && ($lv_row['aju']??'') != 'X' && !empty($lv_row['stkobjcod']) ) {
            $lv_fbkeys[$lv_row['stkobjcod']][$lv_row['matcod']] = true;
          }
        }
        if( !empty($lv_fbkeys) ) {
          $lo_stkmdl = $this->co_reg->load->model('stkmatstk');
          $lv_patkey = implode(chr(10), array_keys($lv_fbkeys));
          $lv_allmats = array();
          foreach( $lv_fbkeys as $lv_mats ) {
            foreach( $lv_mats as $lv_mat => $lv_true ) {
              $lv_allmats[$lv_mat] = true;
            }
          }
          $lv_matkey = implode(chr(10), array_keys($lv_allmats));
          $lv_flt = '[~fltrow~]s.stkobjcod'.chr(9).'IN'.chr(9).chr(9).$lv_patkey.chr(9).chr(9).
                    '[~fltrow~]s.matcod'.chr(9).'IN'.chr(9).chr(9).$lv_matkey.chr(9).chr(9).
                    '[~fltrow~]s.matqty'.chr(9).'>'.chr(9).chr(9).'0'.chr(9).chr(9).
                    '[~fltrow~]m.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9);
          $lo_rs = $lo_stkmdl->getList(array('vewfldflt' => $lv_flt, 'vewmaxrec' => 9999));
          if( is_array($lo_rs) && !isset($lo_rs['errtyp']) ) {
            foreach( $lo_rs as $lv_stkrow ) {
              $lv_mcod = $lv_stkrow['matcod'] ?? '';
              $lv_pcod = $lv_stkrow['stkobjcod'] ?? '';
              $lv_ccod = $lv_stkrow['stkcntcod'] ?? '';
              if( $lv_mcod === '' || $lv_pcod === '' ) continue;
              $lv_fbkey = $lv_pcod . '|' . $lv_ccod . '|' . $lv_mcod;
              if( !isset($lv_fbdat[$lv_fbkey]) ) {
                $lv_fbdat[$lv_fbkey] = array(
                  'matsercodext' => $lv_stkrow['matsercodext'] ?? ''
                );
              }
            }
          }
        }

        // CARGA CODIGOS EXTERNOS DE CONTACTOS
        $lv_cntdat = array();
        if( !empty($lv_cntids) ) {
          $lv_cntkey = implode(chr(10), array_keys($lv_cntids));
          $lo_cntmdl = $this->co_reg->load->model('grldatcnt');
          $lv_prm = array('vewfldflt' => '[~fltrow~]c.cntcod'.chr(9).'IN'.chr(9).chr(9).$lv_cntkey.chr(9).chr(9));
          $lo_cntrs = $lo_cntmdl->getList($lv_prm, array(), null, false);
          if( is_array($lo_cntrs) && !isset($lo_cntrs['errtyp']) ) {
            foreach( $lo_cntrs as $lv_row ) {
              $lv_cntdat[$lv_row['cntcod']] = ($lv_row['cntcodext'] ?? '');
            }
          }
        }

        // CABECERA EXCEL
        $lv_buffer .= '<table style="border: #000000 1px solid;" x:publishsource="Excel">';
        $lv_buffer .= '<tr>'.
                        '<th style="background-color: #4472C4; color: #FFFFFF; font-weight: bold; border: #000000 1px solid;">ID Liquidacion</th>'.
                        '<th style="background-color: #4472C4; color: #FFFFFF; font-weight: bold; border: #000000 1px solid;">Fecha</th>'.
                        '<th style="background-color: #4472C4; color: #FFFFFF; font-weight: bold; border: #000000 1px solid;">Cliente</th>'.
                        '<th style="background-color: #4472C4; color: #FFFFFF; font-weight: bold; border: #000000 1px solid;">Destino</th>'.
                        '<th style="background-color: #4472C4; color: #FFFFFF; font-weight: bold; border: #000000 1px solid;">ID Recurso</th>'.
                        '<th style="background-color: #4472C4; color: #FFFFFF; font-weight: bold; border: #000000 1px solid;">Recurso</th>'.
                        '<th style="background-color: #4472C4; color: #FFFFFF; font-weight: bold; border: #000000 1px solid;">Cantidad</th>'.
                        '<th style="background-color: #4472C4; color: #FFFFFF; font-weight: bold; border: #000000 1px solid;">Dias</th>'.
                        '<th style="background-color: #4472C4; color: #FFFFFF; font-weight: bold; border: #000000 1px solid;">Importe</th>'.
                        '<th style="background-color: #4472C4; color: #FFFFFF; font-weight: bold; border: #000000 1px solid;">Total</th>'.
                        '<th style="background-color: #4472C4; color: #FFFFFF; font-weight: bold; border: #000000 1px solid;">Cod. Ext. Contacto</th>'.
                        '<th style="background-color: #4472C4; color: #FFFFFF; font-weight: bold; border: #000000 1px solid;">Nro Remito</th>'.
                        '<th style="background-color: #4472C4; color: #FFFFFF; font-weight: bold; border: #000000 1px solid;">Nro Serie</th>'.
                       '</tr>';

        $lv_rows = array();
        $lv_lqdid = $lo_slssvclqd[0]['slssvclqdcod'];
        $lv_lqddte = date_format($lo_slssvclqd[0]['slssvclqddte'],'d/m/Y');
        $lv_lqdcustxt = $lo_slssvclqd[0]['custxt'];
        foreach ($lv_dat as $lv_row) {
          if( ($lv_row['refobjtyp']??'') == 'STK_HST' ) {
            $lv_fbkey = ($lv_row['stkobjcod']??'') . '|' . ($lv_row['stkcntcod']??'') . '|' . ($lv_row['matcod']??'');
            $lv_remito = '';
            $lv_serial = isset($lv_fbdat[$lv_fbkey]) ? $lv_fbdat[$lv_fbkey]['matsercodext'] : '';
          } else {
            $lv_idx = $lv_row['refobjcod001'] . '|' . $lv_row['refobjcod002'];
            $lv_remito = isset($lv_movdat[$lv_idx]) ? $lv_movdat[$lv_idx]['stkmovdoccodext'] : '';
            $lv_serial = isset($lv_movdat[$lv_idx]) ? $lv_movdat[$lv_idx]['matsercodext'] : '';
          }
          $lv_cntcodext = isset($lv_cntdat[$lv_row['stkcntcod']]) ? $lv_cntdat[$lv_row['stkcntcod']] : '';
          $lv_rows[] = '<tr>'.
                        '<td style="color: #000000; font-weight: bold; border: #000000 1px solid;">'.$lv_lqdid.'</td>'.
                        '<td style="color: #000000; font-weight: bold; border: #000000 1px solid;">'.$lv_lqddte.'</td>'.
                        '<td style="color: #000000; font-weight: bold; border: #000000 1px solid;">'.$lv_lqdcustxt.'</td>'.
                        '<td style="color: #000000; font-weight: bold; border: #000000 1px solid;">'.$this->co_reg->document->getTagValue($lv_row['slssvclqddocatr001'],'refobjsubgrptxt').'</td>'.
                        '<td style="color: #000000; font-weight: bold; border: #000000 1px solid;">'.$lv_row['slssvclqddoccodext'].'</td>'.
                        '<td style="color: #000000; font-weight: bold; border: #000000 1px solid;">'.$lv_row['slssvclqddoctxt'].'</td>'.
                        '<td style="color: #000000; font-weight: bold; border: #000000 1px solid;">'.$lv_row['slssvclqddocqty'].'</td>'.
                        '<td style="color: #000000; font-weight: bold; border: #000000 1px solid;">'.$lv_row['slssvclqddocday'].'</td>'.
                        '<td style="color: #000000; font-weight: bold; border: #000000 1px solid;">'.$lv_row['slssvclqddocprc'].'</td>'.
                        '<td style="color: #000000; font-weight: bold; border: #000000 1px solid;">'.$lv_row['slssvclqddoctot'].'</td>'.
                        '<td style="color: #000000; font-weight: bold; border: #000000 1px solid;">'.$lv_cntcodext.'</td>'.
                        '<td style="color: #000000; font-weight: bold; border: #000000 1px solid;">'.$lv_remito.'</td>'.
                        '<td style="color: #000000; font-weight: bold; border: #000000 1px solid;">'.$lv_serial.'</td>'.
                      '</tr>';
        }
        $lv_buffer .= implode('', $lv_rows) . '</table></body></html>';
        unset($lv_rows);
        return $lv_buffer ;
      break;
        
      //REPORTE SEGUIMIENTO DE ORDEN DE COMPRA
      case '#rptmovbuy':{
        $lo_post = $this->co_reg->request->post;
        //$lo_get = $this->co_reg->request->get;
        $lv_ret = array();
        $lv_sqlstmlst=array();

        $lv_vewfldflt = ($lo_post['vewfldflt'] ?? '');
        $lv_vewmaxrec = ($lo_post['vewmaxrec'] ?? '100');
        $lv_vewfldord = ($lo_post['vewfldord'] ?? '');

        $lv_objtyp = trim($lp_prm['objtyp'] ?? '');
        $lv_sysdocclscodlst = trim($lp_prm['sysdocclscodlst'] ?? ($lp_prm['sysdocclscod'] ?? ''));
        $lv_fletypcodlst = trim($lp_prm['fletypcodlst'] ?? '');

        $lv_fltarr = explode('[~fltrow~]', $lv_vewfldflt);
        $lv_filtro_mov = '';
        $lv_filtro_archivo = '';
        $lv_filtro_archivo2 = -1;
        $lv_map_mov = array(
          'stkmovdoccod' => 'd.stkmovdoccod',
          'stkmovdoccodext' => 'd.stkmovdoccodext',
          'stkmovdocdtecnv' => 'stkmovdocdte',
          'stkmovdocdte' => 'd.stkmovdocdte',
          'sysdocclstxt' => 'dc.sysdocclstxt',
          'stkmovdocmatcod' =>'stkmovdocmatcod',
          'sysdoctretxt' => 'dt.sysdoctretxt',
          'srcobjtxt' => 'srcobjtxt',
          'srccnttxt' => 'srccnttxt',
          'dstobjtxt' => 'dstobjtxt',
          'dstcnttxt' => 'dstcnttxt',
          'matcod' => 'm.matcod',
          'mattxt' => 'm.mattxt',
          'matsercodext' => 'ms.matsercodext'
        );
        $lv_map_archivo = array(
          'file_ctedte' => 'f.ctedte',
          'file_cteusr' => 'f.cteusr'
        );

        for ($i = count($lv_fltarr) - 1; $i > 0; $i--) {
          $lv_rowarr = $lv_fltarr[$i];
          if ($lv_rowarr === '') { continue; }
          $lv_parts = explode(chr(9), $lv_rowarr);
          $lv_fld = trim($lv_parts[0] ?? '');
          if ($lv_fld === '') { continue; }

          if (isset($lv_map_mov[$lv_fld])) {
            $lv_parts_mov = $lv_parts;
            $lv_parts_mov[0] = $lv_map_mov[$lv_fld];
            $lv_filtro_mov .= '[~fltrow~]' . implode(chr(9), $lv_parts_mov);
          }
          if (isset($lv_map_archivo[$lv_fld])) {
            $lv_parts_fle = $lv_parts;
            $lv_parts_fle[0] = $lv_map_archivo[$lv_fld];
            $lv_filtro_archivo .= '[~fltrow~]' . implode(chr(9), $lv_parts_fle);
          } else if (stripos($lv_fld, 'file_hasfile') !== false) {
            $lv_filtro_archivo2 = (stripos($lv_rowarr, 'SI') !== false ? 1 : 0);
          }
        }

        $lv_filtro_get = '';
        if ($lv_objtyp != '') {
          $lv_filtro_get .= '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).$lv_objtyp.chr(9).chr(9);
        }
        if ($lv_sysdocclscodlst != '') {
          $lv_filtro_get .= '[~fltrow~]d.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).str_replace(',', chr(10), $lv_sysdocclscodlst).chr(9).chr(9);
        }

        $lo_movmdl = $this->co_reg->load->model('stkmovdocmat');
        $lv_prm = array(
          'vewfldflt' => $lv_filtro_get . $lv_filtro_mov,
          'vewfldord' => ($lv_vewfldord != '' ? $lv_vewfldord : 'd.stkmovdocdte desc'),
          'vewmaxrec' => $lv_vewmaxrec
        );
        $lo_movrs = $lo_movmdl->getList($lv_prm, null, null, false);
        $lv_sqlstmlst[]=$lo_movmdl->getsysdata('sqlstm');
        
        

        if (!is_array($lo_movrs) || isset($lo_movrs['errtyp']) || count($lo_movrs) == 0) {
          $lv_ret[0]['sqlstm']=$lv_sqlstmlst;
          return $lv_ret;
        }

        $lv_stkmovdoccod_arr = array_values(array_unique(array_column($lo_movrs, 'stkmovdoccod')));
        $lo_flers = array();
        if (count($lv_stkmovdoccod_arr) > 0) {
          $lv_flesrc_lst = implode(chr(10), $lv_stkmovdoccod_arr);
          $lv_filtro_fle_get = '';
          if ($lv_objtyp != '') {
            $lv_filtro_fle_get .= '[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9).$lv_objtyp.chr(9).chr(9);
          }
          if ($lv_fletypcodlst != '') {
            $lv_filtro_fle_get .= '[~fltrow~]f.fletypcod'.chr(9).'IN'.chr(9).chr(9).str_replace(',', chr(10), $lv_fletypcodlst).chr(9).chr(9);
          }

          $lo_flemdl = $this->co_reg->load->model('grldatupl');
          $lv_prm = array(
            'vewfldflt' => $lv_filtro_archivo . $lv_filtro_fle_get .
                           '[~fltrow~]f.flesrccod'.chr(9).'IN'.chr(9).chr(9).$lv_flesrc_lst.chr(9).chr(9),
            'vewmaxrec' => 9999
          );
          $lo_flers = $lo_flemdl->getList($lv_prm, null, null);
          $lv_sqlstmlst[]=$lo_flemdl->getsysdata('sqlstm');
          if (!is_array($lo_flers) || isset($lo_flers['errtyp'])) {
            $lo_flers = array();
          }
        }

        $lv_fleidx = array();
        foreach ($lo_flers as $lv_row_fle) {
          $lv_key = $lv_row_fle['flesrccod'];
          if (!isset($lv_fleidx[$lv_key])) {
            $lv_fleidx[$lv_key] = $lv_row_fle;
          }
        }

        foreach ($lo_movrs as $lv_row_mov) {
          $lv_key = $lv_row_mov['stkmovdoccod'];
          $lv_hasfile = isset($lv_fleidx[$lv_key]);
          if (($lv_filtro_archivo2 == 1 && !$lv_hasfile) || ($lv_filtro_archivo2 == 0 && $lv_hasfile)) {
            continue;
          }

          $lv_row = $lv_row_mov;
          $lv_row['file_hasfile'] = ($lv_hasfile ? 'SI' : 'NO');
          $lv_row['file_ctedte'] = '';
          $lv_row['file_ctehrs'] = '';
          $lv_row['file_cteusr'] = '';
          if ($lv_hasfile) {
            $lv_row['file_ctedte'] = $lv_fleidx[$lv_key]['ctedte'];
            $lv_row['file_cteusr'] = $lv_fleidx[$lv_key]['cteusr'];
            if ($lv_fleidx[$lv_key]['ctedte'] != null) {
              $lv_row['file_ctehrs'] = $lv_fleidx[$lv_key]['ctedte']->format('H:i');
            }
          }
          $lv_ret[] = $lv_row;
        }
        $lv_ret[0]['sqlstm']=$lv_sqlstmlst;
        return $lv_ret;
        break;
      }
      //Movimientos de Materiales con Adjuntos
      case '#rptmovmatbuy':{
        $lo_post = $this->co_reg->request->post;
        //$lo_get = $this->co_reg->request->get;
        $lv_ret = array();
        $lv_sqlstmlst=array();

        $lv_vewfldflt = ($lo_post['vewfldflt'] ?? '');
        $lv_vewmaxrec = ($lo_post['vewmaxrec'] ?? '100');
        $lv_vewfldord = ($lo_post['vewfldord'] ?? '');

        $lv_objtyp = trim($lp_prm['objtyp'] ?? '');
        $lv_sysdocclscodlst = trim($lp_prm['sysdocclscodlst'] ?? ($lp_prm['sysdocclscod'] ?? ''));
        $lv_fletypcodlst = trim($lp_prm['fletypcodlst'] ?? '');

        $lv_fltarr = explode('[~fltrow~]', $lv_vewfldflt);
        $lv_filtro_mov = '';
        $lv_filtro_archivo = '';
        $lv_filtro_archivo2 = -1;
        $lv_map_mov = array(
          'stkmovdoccod' => 'd.stkmovdoccod',
          'stkmovdoccodext' => 'd.stkmovdoccodext',
          'stkmovdocdtecnv' => 'stkmovdocdte',
          'stkmovdocdte' => 'd.stkmovdocdte',
          'sysdocclstxt' => 'dc.sysdocclstxt',
          'stkmovdocmatcod' =>'stkmovdocmatcod',
          'sysdoctretxt' => 'dt.sysdoctretxt',
          'srcobjtxt' => 'srcobjtxt',
          'srccnttxt' => 'srccnttxt',
          'dstobjtxt' => 'dstobjtxt',
          'dstcnttxt' => 'dstcnttxt',
          'matcod' => 'm.matcod',
          'mattxt' => 'm.mattxt',
          'matsercodext' => 'ms.matsercodext'
        );
        $lv_map_archivo = array(
          'file_ctedte' => 'f.ctedte',
          'file_cteusr' => 'f.cteusr'
        );

        for ($i = count($lv_fltarr) - 1; $i > 0; $i--) {
          $lv_rowarr = $lv_fltarr[$i];
          if ($lv_rowarr === '') { continue; }
          $lv_parts = explode(chr(9), $lv_rowarr);
          $lv_fld = trim($lv_parts[0] ?? '');
          if ($lv_fld === '') { continue; }

          if (isset($lv_map_mov[$lv_fld])) {
            $lv_parts_mov = $lv_parts;
            $lv_parts_mov[0] = $lv_map_mov[$lv_fld];
            $lv_filtro_mov .= '[~fltrow~]' . implode(chr(9), $lv_parts_mov);
          }
          if (isset($lv_map_archivo[$lv_fld])) {
            $lv_parts_fle = $lv_parts;
            $lv_parts_fle[0] = $lv_map_archivo[$lv_fld];
            $lv_filtro_archivo .= '[~fltrow~]' . implode(chr(9), $lv_parts_fle);
          } else if (stripos($lv_fld, 'file_hasfile') !== false) {
            $lv_filtro_archivo2 = (stripos($lv_rowarr, 'SI') !== false ? 1 : 0);
          }
        }

        $lv_filtro_get = '';
        if ($lv_objtyp != '') {
          $lv_filtro_get .= '[~fltrow~]dc.objtyp'.chr(9).'='.chr(9).chr(9).$lv_objtyp.chr(9).chr(9);
        }
        if ($lv_sysdocclscodlst != '') {
          $lv_filtro_get .= '[~fltrow~]d.sysdocclscod'.chr(9).'IN'.chr(9).chr(9).str_replace(',', chr(10), $lv_sysdocclscodlst).chr(9).chr(9);
        }

        $lo_movmdl = $this->co_reg->load->model('stkmovdocmat');
        $lv_prm = array(
          'vewfldflt' => $lv_filtro_get . $lv_filtro_mov,
          'vewfldord' => ($lv_vewfldord != '' ? $lv_vewfldord : 'd.stkmovdocdte desc'),
          'vewmaxrec' => $lv_vewmaxrec
        );
        $lo_movrs = $lo_movmdl->getList($lv_prm, null, null, false);
        $lv_sqlstmlst[]=$lo_movmdl->getsysdata('sqlstm');
        
        

        if (!is_array($lo_movrs) || isset($lo_movrs['errtyp']) || count($lo_movrs) == 0) {
          $lv_ret[0]['sqlstm']=$lv_sqlstmlst;
          return $lv_ret;
        }

        $lv_stkmovdoccod_arr = array_values(array_unique(array_column($lo_movrs, 'stkmovdoccod')));
        $lo_flers = array();
        if (count($lv_stkmovdoccod_arr) > 0) {
          $lv_flesrc_lst = implode(chr(10), $lv_stkmovdoccod_arr);
          $lv_filtro_fle_get = '';
          if ($lv_objtyp != '') {
            $lv_filtro_fle_get .= '[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9).$lv_objtyp.chr(9).chr(9);
          }
          if ($lv_fletypcodlst != '') {
            $lv_filtro_fle_get .= '[~fltrow~]f.fletypcod'.chr(9).'IN'.chr(9).chr(9).str_replace(',', chr(10), $lv_fletypcodlst).chr(9).chr(9);
          }

          $lo_flemdl = $this->co_reg->load->model('grldatupl');
          $lv_prm = array(
            'vewfldflt' => $lv_filtro_archivo . $lv_filtro_fle_get .
                           '[~fltrow~]f.flesrccod'.chr(9).'IN'.chr(9).chr(9).$lv_flesrc_lst.chr(9).chr(9),
            'vewmaxrec' => 9999
          );
          $lo_flers = $lo_flemdl->getList($lv_prm, null, null);
          $lv_sqlstmlst[]=$lo_flemdl->getsysdata('sqlstm');
          if (!is_array($lo_flers) || isset($lo_flers['errtyp'])) {
            $lo_flers = array();
          }
        }

        $lv_fleidx = array();
        foreach ($lo_flers as $lv_row_fle) {
          $lv_key = $lv_row_fle['flesrccod'];
          if (!isset($lv_fleidx[$lv_key])) {
            $lv_fleidx[$lv_key] = $lv_row_fle;
          }
        }

        foreach ($lo_movrs as $lv_row_mov) {
          $lv_key = $lv_row_mov['stkmovdoccod'];
          $lv_hasfile = isset($lv_fleidx[$lv_key]);
          if (($lv_filtro_archivo2 == 1 && !$lv_hasfile) || ($lv_filtro_archivo2 == 0 && $lv_hasfile)) {
            continue;
          }

          $lv_row = $lv_row_mov;
          $lv_ordkey = (string)($lv_row_mov['docrefcod'] ?? '') . '|' . (string)($lv_row_mov['docrefposcod'] ?? '');

          $lv_row['file_hasfile'] = ($lv_hasfile ? 'SI' : 'NO');
          $lv_row['file_ctedte'] = '';
          $lv_row['file_ctehrs'] = '';
          $lv_row['file_cteusr'] = '';
          if ($lv_hasfile) {
            $lv_row['file_ctedte'] = $lv_fleidx[$lv_key]['ctedte'];
            $lv_row['file_cteusr'] = $lv_fleidx[$lv_key]['cteusr'];
            if ($lv_fleidx[$lv_key]['ctedte'] != null) {
              $lv_row['file_ctehrs'] = $lv_fleidx[$lv_key]['ctedte']->format('H:i');
            }
          }
          $lv_ret[] = $lv_row;
        }
        $lv_ret[0]['sqlstm']=$lv_sqlstmlst;
        return $lv_ret;
        break;
      	
      }
      //REPORTE SEGUIMIENTO DE ORDEN DE COMPRA
      case '#rptmovbuyord':{
        $lo_post = $this->co_reg->request->post;
        $lv_ret = [];
        $lv_vewfldflt = ($lo_post['vewfldflt'] ?? '');
        $lv_fltarr = explode('[~fltrow~]', $lv_vewfldflt);
        $lv_filtro_pedido = '';
        $lv_filtro_entrega = '';
        $lv_filtro_archivo = '';
        $lv_filtro_archivo2 = -1;
        // Campos permitidos y mapeos
        $lv_map_pedido = array(
          'o.buyordcod'    => 'o.buyordcod',
          'buyordclstxt'   => 'dc.sysdocclstxt',
          'srcobjtxt'      => 'srcobjtxt',
          'o.buyorddte'    => 'o.buyorddte',
          'cteusr'         => 'cteusr',
          'dt.sysdoctretxt'=> 'dt.sysdoctretxt'
        );
        $lv_map_entrega = array(
          'd.stkmovdocdte'    => 'd.stkmovdocdte',
          'd.stkmovdoccodext' => 'd.stkmovdoccodext',
          'dc.sysdocclstxt'   => 'dc.sysdocclstxt'
        );
        $lv_map_archivo = array(
          'file_ctedte' => 'f.ctedte',
          'file_cteusr' => 'f.cteusr'
        );
        for ($i = count($lv_fltarr) - 1; $i > 0; $i--) {
          $lv_rowarr = $lv_fltarr[$i];
          if ($lv_rowarr === '') { continue; }
          $lv_parts = explode(chr(9), $lv_rowarr);
          $lv_fld = trim($lv_parts[0] ?? '');
          if ($lv_fld === '') { continue; }
          // Pedido (buyord)
          if (isset($lv_map_pedido[$lv_fld])) {
            $lv_parts_ped = $lv_parts;
            $lv_parts_ped[0] = $lv_map_pedido[$lv_fld];
            $lv_filtro_pedido .= '[~fltrow~]' . implode(chr(9), $lv_parts_ped);
          }
          // Entrega (stkmovdoc / STK_SIN)
          if (isset($lv_map_entrega[$lv_fld])) {
            $lv_parts_ent = $lv_parts;
            $lv_parts_ent[0] = $lv_map_entrega[$lv_fld];
            $lv_filtro_entrega .= '[~fltrow~]' . implode(chr(9), $lv_parts_ent);
          }
          // Archivo (grldatupl)
          if (isset($lv_map_archivo[$lv_fld])) {
            $lv_parts_fle = $lv_parts;
            $lv_parts_fle[0] = $lv_map_archivo[$lv_fld];
            $lv_filtro_archivo .= '[~fltrow~]' . implode(chr(9), $lv_parts_fle);
          } else if (stripos($lv_fld, 'file_hasfile') !== false) {
            // Mantiene semántica actual SI/NO
            $lv_filtro_archivo2 = (stripos($lv_rowarr, 'SI') !== false ? 1 : 0);
          }
        }
        $lv_vewmaxrec = ($lo_post['vewmaxrec']??'100');
        // ORDENES DE COMPRA. obtengo todas las ordenes
        $lo_ordmdl=$this->co_reg->load->model('buyord');
        $lv_prm = array('vewfldflt'=>$lv_filtro_pedido,
												'vewfldord'=>'o.buyorddte desc',
                        'vewmaxrec'=>$lv_vewmaxrec);
        $lo_ordrs = $lo_ordmdl->getList($lv_prm,null,null,false);
        // armo clave para filtro de flujo
        $lv_stkmovdoccod_lst = '';
        $lv_buyordcod_lst = '';
        foreach ($lo_ordrs as $lv_row) {
          $lv_buyordcod_lst .= ($lv_buyordcod_lst==''?'':chr(10)).$lv_row['buyordcod'];
        }

				// FLUJO. Obtener ordenes-movimientos de entrada desde el flujo
				if($lv_buyordcod_lst!=''){
					$lo_flwmdl = $this->co_reg->load->model('grldocflw');
					$lv_prm = array('vewfldflt' =>'[~fltrow~]fp.srcobjtyp'.chr(9).'='.chr(9).chr(9).'BUY_ORD'.chr(9).chr(9).
																						'[~fltrow~]fp.srcobjcod'.chr(9).'IN'.chr(9).chr(9).$lv_buyordcod_lst.chr(9).chr(9).
																						'[~fltrow~]fp.refobjtyp'.chr(9).'='.chr(9).chr(9).'STK_SIN'.chr(9).chr(9).
																						'[~fltrow~]fp.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
															'vewfldgrp'=>'fp.srcobjcod, fp.refobjcod',
															'vewmaxrec'=>9999);
					$lo_flwrs = $lo_flwmdl->getList($lv_prm,null,null);

					// armo clave para filtro de movimientos de entrada
					foreach ($lo_flwrs as $lv_row) {
						$lv_stkmovdoccod_lst .= ($lv_stkmovdoccod_lst==''?'':chr(10)).$lv_row['refobjcod'];
					}
				} else {
					$lo_flwrs = array();
				}

				// MOVIMIENTOS DE ENTRADA. obtengo todas los movimientos de entrada
        if( $lv_stkmovdoccod_lst!='' ){
          $lo_sinmdl= $this->co_reg->load->model('stkmovdoc');
          $lv_prm=array('vewfldflt'=>$lv_filtro_entrega.
                                    '[~fltrow~]d.stkmovdoccod'.chr(9).'IN'.chr(9).chr(9).$lv_stkmovdoccod_lst.chr(9).chr(9),
                       'vewmaxrec'=>9999);
          $lo_sinrs = $lo_sinmdl->getList($lv_prm,null,null,false);

          // ARCHIVOS
          $lo_flemdl= $this->co_reg->load->model('grldatupl');
          $lv_prm = array('vewfldflt'=>$lv_filtro_archivo.
																					'[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9).'STK_SIN'.chr(9).chr(9).
                                       '[~fltrow~]f.flesrccod'.chr(9).'IN'.chr(9).chr(9).$lv_stkmovdoccod_lst.chr(9).chr(9),
                         'vewmaxrec'=>9999);
          $lo_flers = $lo_flemdl->getList($lv_prm,null,null);

        } else {
          $lo_sinrs = array();
          $lo_flers = array();
        }

        // se recorre todo el flujo
				foreach($lo_ordrs as $lv_row_ord){
					$lv_row['buyordcod'] = $lv_row_ord['buyordcod'];
					$lv_row['buyordclstxt'] = $lv_row_ord['sysdocclstxt'];
					$lv_row['srcobjtxt'] = $lv_row_ord['srcobjtxt'];
					$lv_row['buyorddte'] = $lv_row_ord['buyorddte'];
					$lv_row['cteusr'] = $lv_row_ord['cteusr'];
					$lv_row['sysdoctretxt'] = $lv_row_ord['sysdoctretxt'];
					$lv_row['stkmovdoccod'] = '';
					$lv_row['stkmovdocdte'] = '';
					$lv_row['stkmovdoccodext'] = '';
					$lv_row['sysdocclstxt'] = '';
					$lv_row['file_ctedte'] = '';
					$lv_row['file_ctehrs'] = '';
					$lv_row['file_cteusr'] = '';
					$lv_row['file_hasfile'] = '';

          // recorro el flujo
					$i=0;
          foreach($lo_flwrs as $lv_row_flw){
						if( $lv_row_flw['srcobjcod']==$lv_row_ord['buyordcod'] ){
							$i++;
							// se busca el movimiento de entrada
							$lo_sin = array();
							foreach($lo_sinrs as $lv_row_sin){ if($lv_row_sin['stkmovdoccod']==$lv_row_flw['refobjcod']){ $lo_sin=$lv_row_sin; break; }}
							if(count($lo_sin)>0){
								$lv_row['stkmovdoccod'] = $lo_sin['stkmovdoccod'];
								$lv_row['stkmovdocdte'] = $lo_sin['stkmovdocdte'];
								$lv_row['stkmovdoccodext'] = $lo_sin['stkmovdoccodext'];
								$lv_row['sysdocclstxt'] = $lo_sin['sysdocclstxt'];

								// se busca si tiene archivo
								$lo_fle = array();
								foreach($lo_flers as $lv_row_fle){ if($lv_row_fle['flesrccod']==$lo_sin['stkmovdoccod']){ $lo_fle=$lv_row_fle; break; }}

								// Si tiene filtro de archivos
								if( ($lv_filtro_archivo2==1 && count($lo_fle)>0) || ($lv_filtro_archivo2==0 && count($lo_fle)==0) || $lv_filtro_archivo2==-1 ) {
									if( count($lo_fle)>0 ){
										$lv_row['file_ctedte'] = $lo_fle['ctedte'];
										$lv_tmp = $lo_fle['ctedte'];
										$lv_row['file_ctehrs'] = $lv_tmp->format('H:i');
										$lv_row['file_cteusr'] = $lo_fle['cteusr'];
									}
									$lv_row['file_hasfile'] = (count($lo_fle)>0?'SI':'NO');
									array_push($lv_ret,$lv_row);
								}

							} else if( $lv_filtro_entrega=='' && $lv_filtro_archivo=='' && $lv_filtro_archivo2==-1 ){
								array_push($lv_ret,$lv_row);
							}
						}
          }
					if( $i==0 && $lv_filtro_entrega=='' && $lv_filtro_archivo=='' && $lv_filtro_archivo2==-1 ){
						array_push($lv_ret,$lv_row);
					}

        }
	    	return $lv_ret;
        break;
     	}
      // REPORTE SEGUIMIENTO DE ORDEN DE COMPRA POR POSICION
      case '#rptmovbuyordmat':{
        $lo_post = $this->co_reg->request->post;
        $lv_ret = array();
        $lv_sqlstmlst=array();
        $lv_vewfldflt = ($lo_post['vewfldflt'] ?? '');
        $lv_fltarr = explode('[~fltrow~]', $lv_vewfldflt);
        $lv_filtro_pedido = '';
        $lv_filtro_mov = '';
        $lv_filtro_archivo = '';
        $lv_filtro_archivo2 = -1;
	
        // Campos permitidos y mapeos
        $lv_map_pedido = array(
          'buyordcod'    => 'om.buyordcod',
          'om.buyordmatcod' => 'om.buyordmatcod',
          'matcod'       => 'om.matcod',
          'matcodext'       => 'm.matcodext',
          'mattxt'       => 'm.mattxt',
          'buyorddte'     => 'o.buyorddte',
          'buyordcodext'  => 'o.buyordcodext',
          'buyordclstxt'    => 'dc.sysdocclstxt',
          'sysdoctretxt' => 'dt.sysdoctretxt',
          'sysdocrejtxt' => 'dr.sysdocrejtxt',
          'srcobjtxt'       => 'srcobjtxt'
        );
        $lv_map_mov = array(
          'd.stkmovdocdte'    => 'd.stkmovdocdte',
          'stkmovdoccod' => 'd.stkmovdoccod',
          'stkmovdoccodext' => 'd.stkmovdoccodext',
          'dc.sysdocclstxt'   => 'dc.sysdocclstxt',
          'dm.matcod'         => 'dm.matcod',
          'matcodext'         => 'm.matcodext'
        );
        $lv_map_archivo = array(
          'file_ctedte' => 'f.ctedte',
          'file_cteusr' => 'f.cteusr'
        );

        for ($i = count($lv_fltarr) - 1; $i > 0; $i--) {
          $lv_rowarr = $lv_fltarr[$i];
          if ($lv_rowarr === '') { continue; }
          $lv_parts = explode(chr(9), $lv_rowarr);
          $lv_fld = trim($lv_parts[0] ?? '');
          if ($lv_fld === '') { continue; }

          // Pedido (buyordmat)
          if (isset($lv_map_pedido[$lv_fld])) {
            $lv_parts_ped = $lv_parts;
            $lv_parts_ped[0] = $lv_map_pedido[$lv_fld];
            $lv_filtro_pedido .= '[~fltrow~]' . implode(chr(9), $lv_parts_ped);
          }
          // Movimiento (stkmovdocmat)
          if (isset($lv_map_mov[$lv_fld])) {
            $lv_parts_mov = $lv_parts;
            $lv_parts_mov[0] = $lv_map_mov[$lv_fld];
            $lv_filtro_mov .= '[~fltrow~]' . implode(chr(9), $lv_parts_mov);
          }
          // Archivo (grldatupl)
          if (isset($lv_map_archivo[$lv_fld])) {
            $lv_parts_fle = $lv_parts;
            $lv_parts_fle[0] = $lv_map_archivo[$lv_fld];
            $lv_filtro_archivo .= '[~fltrow~]' . implode(chr(9), $lv_parts_fle);
          } else if (stripos($lv_fld, 'file_hasfile') !== false) {
            $lv_filtro_archivo2 = (stripos($lv_rowarr, 'SI') !== false ? 1 : 0);
          }
        }

        $lv_vewmaxrec = ($lo_post['vewmaxrec'] ?? '100');

        // DETALLES DE ORDEN DE COMPRA
        $lo_ordmatmdl = $this->co_reg->load->model('buyordmat');
        $lv_prm = array('vewfldflt' => $lv_filtro_pedido,
                        'vewfldord' => 'o.buyorddte desc',
                        'vewmaxrec' => $lv_vewmaxrec);
        $lo_ordmatrs = $lo_ordmatmdl->getList($lv_prm);
        $lv_sqlstmlst[]=$lo_ordmatmdl->getsysdata('sqlstm');

        $lv_buyordcod_lst = '';
        $lv_buyordmatcod_lst = '';
        foreach ($lo_ordmatrs as $lv_row) {
          $lv_buyordcod_lst .= ($lv_buyordcod_lst==''?'':chr(10)).$lv_row['buyordcod'];
          $lv_buyordmatcod_lst .= ($lv_buyordmatcod_lst==''?'':chr(10)).$lv_row['buyordmatcod'];
        }

        // MOVIMIENTOS DE ENTRADA POR POSICION
        if ($lv_buyordcod_lst != '' && $lv_buyordmatcod_lst != '') {
          $lo_movmatmdl = $this->co_reg->load->model('stkmovdocmat');
          $lv_prm = array('vewfldflt' => $lv_filtro_mov.
                                        '[~fltrow~]dc.objtyp'.chr(9).'IN'.chr(9).chr(9).'STK_SIN'.chr(9).chr(9).
                                        '[~fltrow~]dm.docreftyp'.chr(9).'='.chr(9).chr(9).'BUY_ORD'.chr(9).chr(9).
                                        '[~fltrow~]dm.docrefcod'.chr(9).'IN'.chr(9).chr(9).$lv_buyordcod_lst.chr(9).chr(9).
                                        '[~fltrow~]dm.docrefposcod'.chr(9).'IN'.chr(9).chr(9).$lv_buyordmatcod_lst.chr(9).chr(9),
                          'vewmaxrec' => 9999);
          $lo_movmatrs = $lo_movmatmdl->getList($lv_prm, null, null, false);
          $lv_sqlstmlst[]=$lo_movmatmdl->getsysdata('sqlstm');
        } else {
          $lo_movmatrs = array();
        }

        // ARCHIVOS DE MOVIMIENTOS DE ENTRADA
        $lv_movdoccod_lst = '';
        foreach ($lo_movmatrs as $lv_row) {
          $lv_movdoccod_lst .= ($lv_movdoccod_lst==''?'':chr(10)).$lv_row['stkmovdoccod'];
        }
        if ($lv_movdoccod_lst != '') {
          $lo_flemdl = $this->co_reg->load->model('grldatupl');
          $lv_prm = array('vewfldflt' => $lv_filtro_archivo.
                                        '[~fltrow~]f.flesrctyp'.chr(9).'='.chr(9).chr(9).'STK_SIN'.chr(9).chr(9).
                                        '[~fltrow~]f.flesrccod'.chr(9).'IN'.chr(9).chr(9).$lv_movdoccod_lst.chr(9).chr(9),
                          'vewmaxrec' => 9999);
          $lo_flers = $lo_flemdl->getList($lv_prm, null, null);
          $lv_sqlstmlst[]=$lo_flemdl->getsysdata('sqlstm');
        } else {
          $lo_flers = array();
        }

        // Index de movimientos por docref (buyordcod|buyordmatcod)
        $lv_movidx = array();
        foreach ($lo_movmatrs as $lv_row) {
          $lv_key = $lv_row['docrefcod'] . '|' . $lv_row['docrefposcod'];
          if (!isset($lv_movidx[$lv_key])) { $lv_movidx[$lv_key] = array(); }
          $lv_movidx[$lv_key][] = $lv_row;
        }

        // Index de archivos por stkmovdoccod
        $lv_fleidx = array();
        foreach ($lo_flers as $lv_row) {
          if (!isset($lv_fleidx[$lv_row['flesrccod']])) {
            $lv_fleidx[$lv_row['flesrccod']] = $lv_row;
          }
        }

        foreach ($lo_ordmatrs as $lv_row_ordmat) {
          $lv_row = $lv_row_ordmat;
          $lv_row['ordmatqty'] = ($lv_row_ordmat['matqty'] ?? '');
          unset($lv_row['matqty']);
          $lv_row['stkmovdoccod'] = '';
          $lv_row['stkmovdocmatcod'] = '';
          $lv_row['stkmovdoccodext'] = '';
          $lv_row['stkmovdocdte'] = '';
          $lv_row['stkmovsysdocclstxt'] = '';
          $lv_row['movmatqty'] = '';
          $lv_row['file_ctedte'] = '';
          $lv_row['file_ctehrs'] = '';
          $lv_row['file_cteusr'] = '';
          $lv_row['file_hasfile'] = '';

          $lv_key = $lv_row_ordmat['buyordcod'] . '|' . $lv_row_ordmat['buyordmatcod'];
          $lv_movlst = ($lv_movidx[$lv_key] ?? array());

          if (count($lv_movlst) > 0) {
            foreach ($lv_movlst as $lv_row_mov) {
              $lv_row_movdat = $lv_row;
              $lv_row_movdat['stkmovdoccod'] = $lv_row_mov['stkmovdoccod'];
              $lv_row_movdat['stkmovdocmatcod'] = $lv_row_mov['stkmovdocmatcod'];
              $lv_row_movdat['stkmovdoccodext'] = $lv_row_mov['stkmovdoccodext'];
              $lv_row_movdat['stkmovdocdte'] = ($lv_row_mov['stkmovdocdte'] ?? ($lv_row_mov['stkmovdocdtecnv'] ?? ''));
              $lv_row_movdat['stkmovsysdocclstxt'] = $lv_row_mov['sysdocclstxt'];
              $lv_row_movdat['movmatqty'] = ($lv_row_mov['matqty'] ?? '');

              $lo_fle = array();
              if (isset($lv_fleidx[$lv_row_mov['stkmovdoccod']])) {
                $lo_fle = $lv_fleidx[$lv_row_mov['stkmovdoccod']];
              }

              $lv_hasfile = (count($lo_fle) > 0);
              if ($lv_filtro_archivo != '' && !$lv_hasfile) { continue; }
              if ($lv_filtro_archivo2 == 1 && !$lv_hasfile) { continue; }
              if ($lv_filtro_archivo2 == 0 && $lv_hasfile) { continue; }

              if ($lv_hasfile) {
                $lv_row_movdat['file_ctedte'] = $lo_fle['ctedte'];
                $lv_tmp = $lo_fle['ctedte'];
                $lv_row_movdat['file_ctehrs'] = $lv_tmp->format('H:i');
                $lv_row_movdat['file_cteusr'] = $lo_fle['cteusr'];
              }
              $lv_row_movdat['file_hasfile'] = ($lv_hasfile ? 'SI' : 'NO');
              array_push($lv_ret, $lv_row_movdat);
            }
          } else if ($lv_filtro_mov == '' && $lv_filtro_archivo == '' && $lv_filtro_archivo2 == -1) {
            array_push($lv_ret, $lv_row);
          }
        }
					$lv_ret[0]['sqlstm']=$lv_sqlstmlst;
	        return $lv_ret;
	        break;
	      }

	      // DEMO LOGISTICA. Maquetado de la notificacion manual de proximidad.
	      // Esta accion es ZCU y no modifica LOG_TRA ni el centro de mensajes core.
	      case '#logtranotifydemo':
	        $lo_post = $this->co_reg->request->post;
	        $lv_data = array(
	          'tracod' => $lp_prm['tracod'] ?? ($lo_post['tracod'] ?? '191'),
	          'tracodext' => $lp_prm['tracodext'] ?? ($lo_post['tracodext'] ?? 'E22'),
	          'driver' => 'CONDUCTOR PRINCIPAL',
	          'vehicle' => 'T',
	          'status' => 'INICIADO',
	          'notification_url' => 'https://www.logindoor.com.ar/proximaentrega.php?route_token=demo-route-E22',
	          'deliveries' => array(
	            array(
	              'id'=>'16289', 'code'=>'449', 'destination'=>'TERAPIAS ODDS',
	              'address'=>'Av. Corrientes 1642, CABA', 'phone'=>'+54 9 11 5555-0191',
	              'email'=>'recepcion@terapiasodds.demo', 'has_geo'=>true
	            ),
	            array(
	              'id'=>'16293', 'code'=>'455', 'destination'=>'TERAPIAS ODDS',
	              'address'=>'Domicilio sin coordenadas cargadas', 'phone'=>'+54 9 11 5555-0455',
	              'email'=>'entregas@terapiasodds.demo', 'has_geo'=>false
	            )
	          )
	        );

	        return $this->co_reg->document->getView('zcutp1_lgn_logtranotifydemo', array(
	          'data'=>$lv_data,
	          'model'=>'',
	          'actcod'=>$this->data['actcod']
	        ));
	        break;
	    } // fin case
  }
}
?>

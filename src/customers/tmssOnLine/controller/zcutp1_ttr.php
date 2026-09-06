<?php
final class zcutp1_ttrController extends tmssController {
	const MODEL = 'zcutp1';
	const VIEW  = 'zcutp1_ttr';
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
		$this->co_reg->request->post['ajax']='1';
		$lv_lgnbuf = $this->co_reg->user->checkUserLogin();
		if ( $lv_lgnbuf!='' ) { return $lv_lgnbuf; }

		$this->data['actcod'] = $lp_act;
		$lp_act = '#' . $lp_act;

    switch( $lp_act ) {
			case '#dshtch':{
				return [];
				break;
      }
      case '#test':{
        $lv_usrmsg='';
        // obtengo mensaje de notificacion
        $lv_txtcodext = $lp_prm['txtcodext']??'CRMCNTNTFNEW';
        $lo_txtmdl = $this->co_reg->load->model('grldattxt');

        if( $lo_txtmdl->load(array('txtcodext' => $lv_txtcodext, 'txtsys' => 1), false) ){
            $lv_usrmsg = $lo_txtmdl->txttxt;
        } else {
            $lv_usrmsg=$lo_txtmdl->errtxt;
        }
        return $lv_usrmsg;
        //return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lv_usrmsg));
      }

      // CONTACTOS CRM CON DATOS DEL ULTIMO CIERRE
      case '#crmcntdetcls':{
        // 1. PARAMETROS DEL REPORTE
        // El diseñador envía filtros, orden y cantidad máxima dentro del POST.
        // Se separan los filtros normales de CRM de los filtros de cierre porque
        // crmcntclsusr y crmcntclsdte no existen en CRM_CNT_DEF: se calculan más abajo.
        $lo_post = $this->co_reg->request->post;
        $lv_fltstr = $lo_post['vewfldflt'] ?? '';
        $lo_fltcnt = array();
        $lo_fltcls = array();

        // 2. FUNCIONES AUXILIARES PARA FILTROS Y ORDEN
        // Quita el alias SQL de un campo. Por ejemplo, "c.crmcntcod" se convierte
        // en "crmcntcod", que es la clave utilizada en los arrays de resultados.
        $lv_getfldnme = function($lp_fldnme) {
          $lo_fldpart = explode('.', strtolower(trim($lp_fldnme)));
          return end($lo_fldpart);
        };

        // Convierte DateTime o textos con los formatos usados por TEMASIS a timestamp.
        // $lp_endofday permite que el límite superior de un filtro "entre fechas"
        // incluya todo el día indicado y no solamente las 00:00:00.
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

        // Normaliza un valor para poder ordenarlo. Las fechas se comparan como
        // timestamps y los textos en minúsculas para que el orden no dependa del case.
        $lv_getcmpval = function($lp_val, $lp_isdte = false) use ($lv_getdteval) {
          if ($lp_isdte) {
            $lv_dteval = $lv_getdteval($lp_val);
            return $lv_dteval === null ? 0 : $lv_dteval;
          }
          return strtolower(trim((string)$lp_val));
        };

        // Evalúa en PHP un filtro del diseñador sobre los campos calculados de cierre.
        // Replica los operadores principales de grlvew: contiene, comienza/termina con,
        // IN, entre, mayor/menor, igual, distinto, vacío y no vacío.
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

        // 3. SEPARACION DE FILTROS
        // Los filtros comunes se envían a CRM_CNT_DEF para que se resuelvan en SQL.
        // Los de usuario/fecha de cierre se guardan para aplicarlos después de unir
        // cada contacto con su registro de auditoría.
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

        // También se identifica si el orden solicitado pertenece a un campo calculado.
        // Si es así, no puede enviarse a CRM_CNT_DEF y se aplicará al final en PHP.
        $lv_ord = trim($lo_post['vewfldord'] ?? '');
        $lo_orddat = preg_split('/\s+/', $lv_ord);
        $lv_ordfld = $lv_getfldnme($lo_orddat[0] ?? '');
        $lv_ordcls = in_array($lv_ordfld, array('crmcntclsusr', 'crmcntclsdte'));

        // 4. CONTACTOS BASE
        // Se utiliza el getList estándar de crmcnt, que ejecuta CRM_CNT_DEF operación 08/18
        // y devuelve todos los campos que ya tenía el origen original del reporte.
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

        // 5. ESTADOS QUE REPRESENTAN UN CIERRE
        // Se consulta CRM_CNT_STS y se conservan los estados cuyo CrmCntStsCls es 1.
        // El historial guarda en ChgDocAtrNew el texto del estado, no su código;
        // por eso se arma una lista con crmcntststxt.
        // Se usa authCheck=false para ejecutar la operación interna 18. La operación
        // 08 exigiría permiso LISTAR (**), aunque esta sea una consulta auxiliar del
        // reporte. VER (03) no puede utilizarse porque requiere un ID y devuelve un
        // solo estado, mientras que aquí deben obtenerse todos los estados de cierre.
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

        // IDs de los contactos recuperados. Limitan la consulta de auditoría para no
        // traer cambios correspondientes a contactos que no forman parte del reporte.
        $lo_cntcod = array_values(array_unique(array_filter(array_column($lo_cnt, 'crmcntcod'), function($lp_val) {
          return $lp_val !== '' && $lp_val !== null;
        })));

        // 6. ULTIMO CAMBIO A UN ESTADO DE CIERRE
        // SYS_DOC_CHG identifica el documento CRM_CNT y SYS_DOC_CHG_ATR contiene
        // el atributo modificado. Se buscan únicamente cambios del atributo "Estado"
        // cuyo valor nuevo pertenezca a la lista de estados de cierre.
        // <rownumber>2</rownumber> hace que getVariousDetails devuelva rownumber 1:
        // el cambio de cierre más reciente de cada contacto.
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

          // Indexa el último cierre por ID de contacto para poder unirlo sin recorrer
          // todo el historial nuevamente por cada fila del reporte.
          foreach ($lo_chg as $lv_chgrow) {
            $lv_cntcod = (string)($lv_chgrow['chgdocsrccod'] ?? '');
            if ($lv_cntcod !== '' && !isset($lo_clsbycnt[$lv_cntcod])) {
              $lo_clsbycnt[$lv_cntcod] = $lv_chgrow;
            }
          }
        }

        // 7. UNION DEL CONTACTO CON LOS DATOS DE CIERRE
        // CteUsr y CteDte pertenecen a SYS_DOC_CHG_ATR. Se publican con alias únicos
        // para no pisar c.cteusr, que en el reporte original significa "CREADO POR".
        // Si un contacto nunca fue cerrado, ambos campos quedan vacíos.
        $lo_ret = array();
        foreach ($lo_cnt as $lv_cntrow) {
          $lv_cntcod = (string)($lv_cntrow['crmcntcod'] ?? '');
          $lv_clsrow = $lo_clsbycnt[$lv_cntcod] ?? array();
          $lv_cntrow['crmcntclsusr'] = $lv_clsrow['cteusr'] ?? '';
          $lv_cntrow['crmcntclsdte'] = $lv_clsrow['ctedte'] ?? '';

          // Los filtros de cierre se aplican recién ahora, cuando los valores calculados
          // ya están incorporados en la fila del contacto.
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

        // 8. ORDEN POR CAMPOS DE CIERRE
        // El orden de los campos originales ya lo realizó CRM_CNT_DEF. Este bloque
        // solamente se ejecuta para crmcntclsusr o crmcntclsdte.
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

        // 9. LIMITE FINAL
        // Cuando hubo que filtrar u ordenar en PHP, el límite no podía aplicarse antes
        // en CRM_CNT_DEF. Se aplica aquí y se conserva el registro adicional que utiliza
        // el motor de vistas para saber si existen más resultados.
        if ((count($lo_fltcls) > 0 || $lv_ordcls) && isset($lo_post['vewmaxrec']) && $lo_post['vewmaxrec'] !== '') {
          // parseViewOptions solicita un registro adicional para detectar si hay mas resultados.
          $lo_ret = array_slice($lo_ret, 0, intval($lo_post['vewmaxrec']) + 1);
        }

        return $lo_ret;
        break;
      }       
        
      // R E P O R T E   L I Q U I D A C I O N   D E S G L O S A D A
      case '#hltprslqddet':
        $lv_lmtmem = ini_get('memory_limit');
        ini_set('memory_limit', '2048M');

        $lo_post = $this->co_reg->request->post;

        // Modelos
        $lo_mdllqd = $this->co_reg->load->model('hltprslqd');
        $lo_mdldoc = $this->co_reg->load->model('hltprslqddoc');
        $lo_mdlprs = $this->co_reg->load->model('hltprs');

        $lo_ret = array();

        // 1- FILTROS
        $lo_flthdr = array();      // filtros que sí pueden bajar a HLT_PRS_LQD
        $lo_fltdoc = array();      // filtros comunes de detalle
        $lo_fltdocsrv = array();   // filtros de detalle solo para prestaciones
        $lo_fltpst = array();      // post-filtros inevitables
        $lv_hasspcflt = false;

        $lv_vewfldflt = (isset($lo_post['vewfldflt']) ? $lo_post['vewfldflt'] : '');
        $lo_fltrow = explode('[~fltrow~]', $lv_vewfldflt);

        // Orden de cabecera: mantengo criterio original y corrijo fecha convertida
        $lv_vewfldord = (isset($lo_post['vewfldord']) && $lo_post['vewfldord'] != '' ? $lo_post['vewfldord'] : 'l.hltprslqdcod desc');
        $lv_vewfldord = str_replace('id.hltprslqddtecnv', 'l.hltprslqddte', $lv_vewfldord);
        $lv_vewfldord = str_replace('id.hltprslqddocdtecnv', 'ld.hltprslqddocdte', $lv_vewfldord);
        $lv_vewfldord = str_replace('id.', '', $lv_vewfldord);

        for ($i = count($lo_fltrow) - 1; $i > 0; $i--) {
            $lo_row = explode(chr(9), $lo_fltrow[$i]);
            $lv_fldraw = (isset($lo_row[0]) ? trim($lo_row[0]) : '');
            $lv_fldcln = str_replace(array('id.', 'l.', 'ld.', 's.', 'sc.', 'be.', 'ei.', 'p.'), '', $lv_fldraw);
            $lv_flttmp = str_replace('id.', '', $lo_fltrow[$i]);

            // 1.1 Filtros que sí viven en cabecera
            if (in_array($lv_fldcln, array('hltprslqdcod', 'docsts', 'hltprslqddte', 'prscod', 'prstxt', 'cuscod'))) {
                $lo_flthdr[] = str_replace($lv_fldcln, 'l.' . $lv_fldcln, $lv_flttmp);
            }

            // 1.2 Filtros comunes de detalle
            elseif (in_array($lv_fldcln, array('hltprslqddocdte', 'hltprslqddoctxt'))) {
                $lo_fltdoc[] = str_replace($lv_fldcln, 'ld.' . $lv_fldcln, $lv_flttmp);
            }

            // 1.3 Especialidad: solo aplica a prestaciones
            elseif ($lv_fldcln == 'spctxt') {
                $lo_fltdocsrv[] = str_replace($lv_fldcln, 's.' . $lv_fldcln, $lv_flttmp);
                $lv_hasspcflt = true;
            }

            // 1.4 Financiador:
            // - en prestaciones se puede bajar a BD con sc.custxt
            // - en gastos se reconstruye por imputación => también queda post-filtro
            elseif ($lv_fldcln == 'custxt') {
                $lo_fltdocsrv[] = str_replace($lv_fldcln, 'sc.' . $lv_fldcln, $lv_flttmp);
                $lo_fltpst[] = array(
                    'fldname' => 'custxt',
                    'fldval'  => (isset($lo_row[2]) ? strtolower(trim($lo_row[2])) : '')
                );
            }

            // 1.5 Descripción de liquidación:
            // la mantengo en memoria porque, si la cabecera viene vacía, el código actual
            // hace fallback a texto de detalle
            elseif (in_array($lv_fldcln, array('hltprslqdtxt', 'refobjtyp'))) {
                $lo_fltpst[] = array(
                    'fldname' => $lv_fldcln,
                    'fldval'  => (isset($lo_row[2]) ? strtolower(trim($lo_row[2])) : '')
                );
            }
        }

        // 2- CABECERA
        $lv_hdrflt = '[~fltrow~]l.docsts' . chr(9) . 'IN' . chr(9) . chr(9) . 'A' . chr(10) . 'C' . chr(9) . chr(9)
                   . (count($lo_flthdr) > 0 ? '[~fltrow~]' . implode('[~fltrow~]', $lo_flthdr) : '');

        $lv_prmlqd = array(
            'vewfldflt' => $lv_hdrflt,
            'vewmaxrec' => (isset($lo_post['vewmaxrec']) ? $lo_post['vewmaxrec'] : ''),
            'vewfldord' => $lv_vewfldord
        );

        $lo_rslqd = $lo_mdllqd->getList($lv_prmlqd, null, null, false);

        if (count($lo_rslqd) == 0) {
            ini_set('memory_limit', $lv_lmtmem);
            return $lo_ret;
        }

        // 3- INDEXO CABECERA Y PRESTADORES
        $lo_lqdids = array();
        $lo_prsids = array();
        $lo_lqdmap = array();
        $lv_lqdsrt = 0;

        foreach ($lo_rslqd as $lv_rowlqd) {
            $lv_lqdcod = $lv_rowlqd['hltprslqdcod'];

            $lo_lqdids[] = $lv_lqdcod;
            $lo_lqdmap[$lv_lqdcod] = $lv_rowlqd;
            $lo_lqdmap[$lv_lqdcod]['__sortidx'] = $lv_lqdsrt++;
            $lo_lqdmap[$lv_lqdcod]['lqdperiod'] = '';

            if (isset($lv_rowlqd['hltprslqdatr001']) && $lv_rowlqd['hltprslqdatr001'] != '') {
                $lv_strdte = $this->co_reg->document->getTagValue($lv_rowlqd['hltprslqdatr001'], 'strdte');
                $lv_enddte = $this->co_reg->document->getTagValue($lv_rowlqd['hltprslqdatr001'], 'enddte');

                if ($lv_strdte != '' && $lv_enddte != '') {
                    $lo_lqdmap[$lv_lqdcod]['lqdperiod'] = $lv_strdte . ' - ' . $lv_enddte;
                }
            }

            if (isset($lv_rowlqd['prscod']) && $lv_rowlqd['prscod'] != '') {
                $lo_prsids[$lv_rowlqd['prscod']] = $lv_rowlqd['prscod'];
            }
        }

        // 4- DETALLE PRESTACIONES
        $lo_rsdocsrv = array();
        $lv_prmdocsrv = array(
            'vewfldflt' => '[~fltrow~]ld.hltprslqdcod' . chr(9) . 'IN' . chr(9) . chr(9) . implode(chr(10), $lo_lqdids) . chr(9) . chr(9)
                         . '[~fltrow~]ld.refobjtyp' . chr(9) . 'IN' . chr(9) . chr(9) . 'HLT_PCR' . chr(10) . 'HLT_EVL' . chr(9) . chr(9)
                         . (count($lo_fltdoc) > 0 ? '[~fltrow~]' . implode('[~fltrow~]', $lo_fltdoc) : '')
                         . (count($lo_fltdocsrv) > 0 ? '[~fltrow~]' . implode('[~fltrow~]', $lo_fltdocsrv) : ''),
            'vewfldord' => 'ld.hltprslqdcod ASC, ld.hltprslqddoccod ASC'
        );
        $lo_rsdocsrv = $lo_mdldoc->getList($lv_prmdocsrv);

        // 5- DETALLE GASTOS
        // Si hay filtro por especialidad, no tiene sentido consultar gastos
        $lo_rsdocexp = array();
        if (!$lv_hasspcflt) {
            $lv_prmdocexp = array(
                'vewfldflt' => '[~fltrow~]ld.hltprslqdcod' . chr(9) . 'IN' . chr(9) . chr(9) . implode(chr(10), $lo_lqdids) . chr(9) . chr(9)
                             . '[~fltrow~]ld.refobjtyp' . chr(9) . '=' . chr(9) . chr(9) . 'BUY_EXP' . chr(9) . chr(9)
                             . (count($lo_fltdoc) > 0 ? '[~fltrow~]' . implode('[~fltrow~]', $lo_fltdoc) : ''),
                'vewfldord' => 'ld.hltprslqdcod ASC, ld.hltprslqddoccod ASC'
            );
            $lo_rsdocexp = $lo_mdldoc->getList($lv_prmdocexp);
        }

        // 6- PRESTADORES
        $lo_prsmap = array();
        if (count($lo_prsids) > 0) {
            $lv_prmprs = array(
                'vewfldflt' => '[~fltrow~]p.prscod' . chr(9) . 'IN' . chr(9) . chr(9) . implode(chr(10), array_values($lo_prsids)) . chr(9) . chr(9)
            );

            $lo_rsprs = $lo_mdlprs->getList($lv_prmprs);
            foreach ($lo_rsprs as $lv_rowprs) {
                $lo_prsmap[$lv_rowprs['prscod']] = $lv_rowprs;
            }
        }

        // 7- FINANCIADOR DE GASTOS POR IMPUTACION A PACIENTE
        $lo_expcusmap = array();

        if (count($lo_rsdocexp) > 0) {
            $lo_expcods = array();
            $lo_expdoccods = array();

            foreach ($lo_rsdocexp as $lv_rowdoc) {
                $lo_expcods[$lv_rowdoc['refobjcod001']] = $lv_rowdoc['refobjcod001'];
                $lo_expdoccods[$lv_rowdoc['refobjcod002']] = $lv_rowdoc['refobjcod002'];
            }

            if (count($lo_expcods) > 0 && count($lo_expdoccods) > 0) {
                // NOTA:
                // se asume que el alias de modelo es buyexpdocimp
                $lo_mdlexpimp = $this->co_reg->load->model('buyexpdocimp');

                $lv_prmimp = array(
                    'vewfldflt' => '[~fltrow~]ei.buyexpcod' . chr(9) . 'IN' . chr(9) . chr(9) . implode(chr(10), array_values($lo_expcods)) . chr(9) . chr(9)
                                 . '[~fltrow~]ei.buyexpdoccod' . chr(9) . 'IN' . chr(9) . chr(9) . implode(chr(10), array_values($lo_expdoccods)) . chr(9) . chr(9)
                                 . '[~fltrow~]ei.srcobjtyp' . chr(9) . '=' . chr(9) . chr(9) . 'HLT_PAT' . chr(9) . chr(9),
                    'vewfldord' => 'ei.buyexpcod ASC, ei.buyexpdoccod ASC'
                );

                $lo_rsimp = $lo_mdlexpimp->getList($lv_prmimp);

                $lo_exppatmap = array();
                $lo_patids = array();

                foreach ($lo_rsimp as $lv_rowimp) {
                    $lv_expkey = $lv_rowimp['buyexpcod'] . '|' . $lv_rowimp['buyexpdoccod'];

                    if (!isset($lo_exppatmap[$lv_expkey])) {
                        $lo_exppatmap[$lv_expkey] = array();
                    }

                    if (isset($lv_rowimp['srcobjtyp']) && $lv_rowimp['srcobjtyp'] == 'HLT_PAT' && isset($lv_rowimp['srcobjcod001']) && $lv_rowimp['srcobjcod001'] != '') {
                        $lo_exppatmap[$lv_expkey][$lv_rowimp['srcobjcod001']] = $lv_rowimp['srcobjcod001'];
                        $lo_patids[$lv_rowimp['srcobjcod001']] = $lv_rowimp['srcobjcod001'];
                    }
                }

                if (count($lo_patids) > 0) {
                    $lo_mdlpat = $this->co_reg->load->model('hltpat');

                    $lv_prmpat = array(
                        'vewfldflt' => '[~fltrow~]p.patcod' . chr(9) . 'IN' . chr(9) . chr(9) . implode(chr(10), array_values($lo_patids)) . chr(9) . chr(9)
                    );

                    $lo_rspat = $lo_mdlpat->getList($lv_prmpat);

                    $lo_patmap = array();
                    foreach ($lo_rspat as $lv_rowpat) {
                        $lo_patmap[$lv_rowpat['patcod']] = $lv_rowpat;
                    }

                    foreach ($lo_exppatmap as $lv_expkey => $lo_patcods) {
                        $lo_cusvals = array();

                        foreach ($lo_patcods as $lv_patcod) {
                            if (isset($lo_patmap[$lv_patcod]['custxt']) && trim($lo_patmap[$lv_patcod]['custxt']) != '') {
                                $lo_cusvals[$lo_patmap[$lv_patcod]['custxt']] = $lo_patmap[$lv_patcod]['custxt'];
                            }
                        }

                        if (count($lo_cusvals) > 0) {
                            // Si el gasto tiene varias imputaciones con distintos financiadores,
                            // se concatenan valores únicos para no perder información.
                            $lo_expcusmap[$lv_expkey] = implode(' / ', array_values($lo_cusvals));
                        }
                    }
                }
            }
        }

        // 8- MERGE FINAL
        $lo_rsdoc = array_merge($lo_rsdocsrv, $lo_rsdocexp);

        // Sin helper extra: mapeo inline para el texto del tipo
        $lo_refobjmap = array(
            'HLT_EVL' => 'PRESTACION',
            'BUY_EXP' => 'GASTO'
        );

        foreach ($lo_rsdoc as $lv_rowdoc) {
            if (!isset($lo_lqdmap[$lv_rowdoc['hltprslqdcod']])) { continue; }

            $lv_rowlqd = $lo_lqdmap[$lv_rowdoc['hltprslqdcod']];
            $lv_rowprs = (isset($lo_prsmap[$lv_rowlqd['prscod']]) ? $lo_prsmap[$lv_rowlqd['prscod']] : array());

            // Financiador:
            // 1) detalle si ya lo trae
            // 2) cabecera como fallback
            // 3) para BUY_EXP, si existe, sobreescribe con el financiador reconstruido por imputación
            $lv_custxt = (isset($lv_rowdoc['custxt']) ? $lv_rowdoc['custxt'] : '');
            if ($lv_custxt == '' && isset($lv_rowlqd['custxt'])) {
                $lv_custxt = $lv_rowlqd['custxt'];
            }

            if (isset($lv_rowdoc['refobjtyp']) && $lv_rowdoc['refobjtyp'] == 'BUY_EXP') {
                $lv_expkey = $lv_rowdoc['refobjcod001'] . '|' . $lv_rowdoc['refobjcod002'];
                if (isset($lo_expcusmap[$lv_expkey]) && $lo_expcusmap[$lv_expkey] != '') {
                    $lv_custxt = $lo_expcusmap[$lv_expkey];
                }
            }

            $lv_refobjtypsrc = (isset($lv_rowdoc['refobjtyp']) ? $lv_rowdoc['refobjtyp'] : '');
            $lv_refobjtyp = (isset($lo_refobjmap[$lv_refobjtypsrc]) ? $lo_refobjmap[$lv_refobjtypsrc] : $lv_refobjtypsrc);

            $lv_merged = array_merge($lv_rowdoc, array(
                'refobjtypsrc' => $lv_refobjtypsrc,
                'refobjtyp'    => $lv_refobjtyp,
                'custxt'       => $lv_custxt,
                'hltprslqdtxt' => (isset($lv_rowlqd['hltprslqdtxt']) ? $lv_rowlqd['hltprslqdtxt'] : ''),
                'prscod'       => (isset($lv_rowlqd['prscod']) ? $lv_rowlqd['prscod'] : ''),
                'prstxt'       => (isset($lv_rowlqd['prstxt']) ? $lv_rowlqd['prstxt'] : ''),
                'sysdocclstxt' => (isset($lv_rowprs['sysdocclstxt']) ? $lv_rowprs['sysdocclstxt'] : ''),
                'lqdperiod'    => (isset($lv_rowlqd['lqdperiod']) ? $lv_rowlqd['lqdperiod'] : ''),
                '__sortidx'    => (isset($lv_rowlqd['__sortidx']) ? $lv_rowlqd['__sortidx'] : 0),
                '__docidx'     => (isset($lv_rowdoc['hltprslqddoccod']) ? intval($lv_rowdoc['hltprslqddoccod']) : 0)
            ));

            // 8.1 POST-FILTROS
            $lv_match = true;
            foreach ($lo_fltpst as $lv_fpst) {
                $lv_fldname = $lv_fpst['fldname'];
                $lv_fldval = $lv_fpst['fldval'];

                if ($lv_fldname == 'hltprslqdtxt') {
                    $lv_curval = strtolower(
                        trim(
                            $lv_merged['hltprslqdtxt'] != ''
                            ? $lv_merged['hltprslqdtxt']
                            : (isset($lv_merged['hltprslqddoctxt']) ? $lv_merged['hltprslqddoctxt'] : '')
                        )
                    );
                } else {
                    $lv_curval = strtolower(trim(isset($lv_merged[$lv_fldname]) ? $lv_merged[$lv_fldname] : ''));
                }

                if ($lv_fldval != '' && strpos($lv_curval, $lv_fldval) === false) {
                    $lv_match = false;
                    break;
                }
            }

            if ($lv_match) {
                $lv_merged['hltprslqddoctot'] = number_format((float)$lv_merged['hltprslqddoctot'], 2, ',', '.');
                $lo_ret[] = $lv_merged;
            }
        }

        // 9- Orden final: preservo el orden de cabecera y luego el orden del detalle ya persistido
        if (count($lo_ret) > 1) {
            usort($lo_ret, function($lp_a, $lp_b) {
                if ($lp_a['__sortidx'] == $lp_b['__sortidx']) {
                    if ($lp_a['__docidx'] == $lp_b['__docidx']) { return 0; }
                    return ($lp_a['__docidx'] < $lp_b['__docidx'] ? -1 : 1);
                }
                return ($lp_a['__sortidx'] < $lp_b['__sortidx'] ? -1 : 1);
            });
        }

        foreach ($lo_ret as $lv_key => $lv_row) {
            unset($lo_ret[$lv_key]['__sortidx'], $lo_ret[$lv_key]['__docidx']);
        }

        ini_set('memory_limit', $lv_lmtmem);
        if(isset($lp_prm['ctefle'])){
          $lo_fle = $this->co_reg->load->model('grldatupl');
          $lv_flenme=$this->co_reg->sec->usrcod.'_data.txt';
          $lv_tmp_path = $lo_fle->createTempFile($lv_flenme);
          //$lv_texto=$lp_prm['ctefle'];
          $lv_texto = $this->co_reg->document->getJson( array('datlst'=>$this->co_reg->document->array_utf8_converter($lo_ret),'data_sqlstm'=>'') );
          //$lv_texto = "Este es un texto de prueba v2";
          file_put_contents($lv_tmp_path, $lv_texto);
        }
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
          'stkmovdoccnftyp' => 'dbo.gettagvalue(^cnftyp^, d.stkmovdoccnf)'
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

        if(count($lo_dlvrs)==0){
          return array();
        }

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

            foreach($lo_trars as $lv_rowtra){
              if(($lv_rowtra['tracod']??'')===''){ continue; }
              $lv_traidx[$lv_rowtra['tracod']] = $lv_rowtra;
            }
          }
        }

        $lv_ret = array();
        foreach($lo_dlvrs as $lv_rowdlv){
          $lv_tracod = $lv_rowdlv['tracod']??'';
          if(!isset($lv_traidx[$lv_tracod])){ continue; }

          $lv_rowtra = $lv_traidx[$lv_tracod];
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
            'dstobjtxt' => $lv_rowdlv['dstobjtxt']??'',
            'dstcnttxt' => $lv_rowdlv['dstcnttxt']??'',
            'stkmovdoccnfdte' => ($lv_rowdlv['stkmovdoccnfdte']??($lv_rowdlv['dlvcnfdte']??'')),
            'stkmovdoccnftyp' => ($lv_rowdlv['stkmovdoccnftyp']??($lv_rowdlv['dlvcnfsts']??''))
          );
        }

        if(count($lv_ret)>0){
          $lv_ret[0]['sqlstm'] = $lv_data_sqlstm;
        }
        $lv_ret[0]['sqlstm'] = $lv_data_sqlstm;
				if(isset($lp_prm['ctefle'])){
          $lo_fle = $this->co_reg->load->model('grldatupl');
          $lv_tmp_path = $lo_fle->createTempFile('testFile.json');
          
          //$lv_texto = $this->co_reg->document->getJson( array('datlst'=>$this->co_reg->document->array_utf8_converter($lv_ret),'data_sqlstm'=>$lv_data_sqlstm) );
          $lv_texto= $lp_prm['ctefle'];
          //$lv_texto = "Este es un texto de prueba v2";
          file_put_contents($lv_tmp_path, $lv_texto);
          }
        return $lv_ret;
        break;

      //   EVOLUCION -COAGUCHEK - CREAR/VER
      case '#evlcoa': case '#evlcoa02':{
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
        $lv_plndte = $lo_plndtemdl->plndte;
        $lv_evlcod = $lo_plndtemdl->evlcod;
        $lv_prscod = $lo_plndtemdl->prscod; 
        $lv_patcod = $lo_plndtemdl->patcod;
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
        
        $lo_plndtemdl->load( array('plnid'=>$lv_plnid, 'plndteid'=>$lv_plndteid) );
				// CREAR EVOLUCION
				if ( $lv_evlcod=='' ) {
					
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
        
        $lv_prm['data']->evlcncmtvlst = $lv_mtvarr;
        $lv_prm['data']->patchgdte='';//$PatChgDte;
        $lv_prm['data']->matcod = $lo_matmdl->matcod;
        $lv_prm['data']->mattxt = $lo_matmdl->mattxt;
        $lv_prm['data']->matuntcod = $lo_matmdl->matuntcod;
        $lv_prm['data']->endpoint=self::VIEW;
        
				$lv_buffer = 	$this->co_reg->load->view('zcutp1_tinevlcoa', $lv_prm);
				return $lv_buffer;
        break;
    	}
			
			//   EVOLUCION -COAGUCHEK - GRABAR
			case '#evlcoa00':{
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
				//$lv_buf_arr['evlevl']= $lv_buf_arr['evlevl'];
        $lv_buf_arr['evlevl']= $lv_buf_arr['evlcod']==''?$lv_buf_arr['evlevl']:'';
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
        if($lv_buf_arr['evlcod']==''){
					$lv_buf_arr['evlobj']=$lv_buf_arr['evlinfprc']=='1'?'REALIZADO '.$lv_evldte :'NO REALIZADO' . chr(13) . $lv_buf_arr['evlcncmtv'] . chr(13) . $lv_buf_arr['evlcnccmt'];
        }
				//$lv_buf_arr['evlobj']=$lv_buf_arr['evlinfprc']=='1'?'REALIZADO '.$lv_evldte :'NO REALIZADO' . chr(13) . $lv_buf_arr['evlcncmtv'] . chr(13) . $lv_buf_arr['evlcnccmt'];
				
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
          $lv_prm = array('vewfldflt' =>'[~fltrow~]ft.objtyp'.chr(9).'='.chr(9).chr(9).'HLT_EVL'.chr(9).chr(9).
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
          
          // elimino los materiales 
          $lvMatDelLst = html_entity_decode($this->co_reg->request->post['evlmatdel']);
          $lvMatDelArr = explode(";",$lvMatDelLst);//json_decode($lv_buffer,true);
          foreach( $lvMatDelArr as $lv_row ) {
            if ($lo_evlmatmdl->delete(array('evlmatcod'=>$lv_row))==false) {
              return $this->co_reg->document->getJson( array('errtyp'=>'E','errcod'=>$lo_evlmatmdl->errcod,'errtxt'=>$lo_evlmatmdl->errtxt) );
            }
          }
          
          // EVOLUCION MATERIALES - grabo datos de materiales
					$lv_buffer = $this->co_reg->request->post['evlmat'];
					if ($lv_buffer!='') {
						$lv_buffer = html_entity_decode($lv_buffer);
						$lv_mat_arr = json_decode($lv_buffer,true);
						foreach( $lv_mat_arr as $lv_row ) {
							if( !isset($lv_row['matcod']) || $lv_row['matcod']==''|| $lv_row['matcod']=='0'){
                continue;
              }
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
        if( $lv_buf_arr['evlcod']=='' && ($lv_buf_arr['fvrpt']=='on'||$lv_buf_arr['fvrpt']=='1')){
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
			
			//   EVOLUCION -COAGUCHEK - BORRAR
			case '#evlcoa04':{
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
    	}
      // R E P O R T E   L I Q U I D A C I O N   D E S G L O S A D A
      case '#hltprslqddet':{
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
        $lv_fltarrlqd = explode('[~fltrow~]', ($lo_post['vewfldflt'] ?? ''));

        // Ordenamiento por defecto y limpieza de prefijos 
        $lv_vewfldord = (isset($lo_post['vewfldord']) && $lo_post['vewfldord'] != '') ? $lo_post['vewfldord'] : 'l.hltprslqdcod desc';
        $lv_vewfldorddoc = 'ld.hltprslqdcod ASC';
        if(stripos($lv_vewfldord, 'hltprslqddocdte') !== false){
          $lv_vewfldorddoc = str_ireplace(array('id.','ld.','l.'), '', $lv_vewfldord);
          $lv_vewfldorddoc = str_ireplace('hltprslqddocdtecnv', 'hltprslqddocdte', $lv_vewfldorddoc);
          $lv_vewfldorddoc = str_ireplace('hltprslqddocdte', 'ld.hltprslqddocdte', $lv_vewfldorddoc);
          $lv_vewfldord = 'l.hltprslqdcod desc';
        }else{
          $lv_vewfldord = str_replace('hltprslqddtecnv', 'l.hltprslqddte', $lv_vewfldord);
          $lv_vewfldord = str_replace('id.', '', $lv_vewfldord);
        }

        for($i=count($lv_fltarrlqd)-1; $i>0; $i--){
          $lv_fltdat = explode(chr(9), $lv_fltarrlqd[$i]);
          $lv_fldraw = (isset($lv_fltdat[0]) ? $lv_fltdat[0] : '');
          $lv_fldcln = strtolower(str_replace(array('id.','l.','ld.','sc.','pc.','c.'), '', $lv_fldraw));

          // 1.1 Filtros Cabecera
          if(stripos(';hltprslqdcod;docsts;', ';'.$lv_fldcln.';') !== false){
            $lv_fltdat[0] = 'l.'.$lv_fldcln;
            $lv_fltarrlqd[$i] = implode(chr(9), $lv_fltdat);
          }
          // 1.2 Filtros Detalle
          elseif(stripos(';hltprslqddocdte;hltprslqddocdtecnv;', ';'.$lv_fldcln.';') !== false){
            $lv_fltdat[0] = 'ld.hltprslqddocdte';
            array_push($lv_fltarrdoc, implode(chr(9), $lv_fltdat));
            unset($lv_fltarrlqd[$i]); 
          }
          // 1.3 Post-Filtros (Memoria)
          elseif(in_array($lv_fldcln, array('spctxt','cuscod','custxt','financiador','hltprslqdtxt','hltprslqddoctxt','refobjtyp'))){
            $lv_fldval = $lv_fltdat;
            $lv_fltval = (isset($lv_fldval[2]) && trim($lv_fldval[2]) != '' ? $lv_fldval[2] : (isset($lv_fldval[3]) ? $lv_fldval[3] : ''));
            array_push($lv_fltarrpst, array(
              'fldname' => $lv_fldcln, 
              'fldopr'  => (isset($lv_fldval[1]) ? strtoupper(trim($lv_fldval[1])) : 'LIKE'),
              'fldval'  => strtolower(trim($lv_fltval)),
              'fldin'   => (isset($lv_fldval[3]) ? strtolower(str_replace(array(chr(13).chr(10), chr(13)), chr(10), trim($lv_fldval[3]))) : '')
            ));
            unset($lv_fltarrlqd[$i]); 
          }
          // 1.4 Limpieza: Elimino filtros vacios o que no apliquen 
          else{
            unset($lv_fltarrlqd[$i]);
          }
        }
        $lv_fltlqd = (count($lv_fltarrlqd)>0 ? implode('[~fltrow~]', $lv_fltarrlqd) : '');
        $lv_fltlqdsts = '[~fltrow~]l.docsts'.chr(9).'IN'.chr(9).chr(9).'A'.chr(10).'C'.chr(9).chr(9);
        $lo_rslqd = array();
        $lo_rsdoc = array();
        $lo_lqdlst = array();
        $lo_prslst = array();

        // 2- DETALLE PRIMERO. Si hay filtros sobre posiciones, evito limitar cabeceras antes de aplicar fecha/detalle.
        if(count($lv_fltarrdoc)>0){
          $lv_prmdoc = array('vewfldflt' => implode('[~fltrow~]', $lv_fltarrdoc),
                             'vewfldord' => $lv_vewfldorddoc
                            );
          $lo_rsdoc = $lo_mdldoc->getList($lv_prmdoc);

          if(count($lo_rsdoc) == 0){
            ini_set('memory_limit', $lv_lmtmem);
            return $lo_ret;
          }

          foreach($lo_rsdoc as $lv_rowdoc){
            if(isset($lv_rowdoc['hltprslqdcod']) && $lv_rowdoc['hltprslqdcod'] != ''){
              $lo_lqdlst[$lv_rowdoc['hltprslqdcod']] = $lv_rowdoc['hltprslqdcod'];
            }
          }

          $lv_prmlqd = array('vewfldflt' => $lv_fltlqdsts.
                                              '[~fltrow~]l.hltprslqdcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lo_lqdlst).chr(9).chr(9).
                                              $lv_fltlqd,
                             'vewmaxrec' => ($lo_post['vewmaxrec'] ?? ''),
                             'vewfldord' => $lv_vewfldord
                            );
          $lo_rslqd = $lo_mdllqd->getList($lv_prmlqd, null, null, false);
        }else{
          // 2- CABECERA. Sin filtros de detalle, mantengo el flujo original para respetar el limite de cabeceras.
          $lv_prmlqd = array('vewfldflt' => $lv_fltlqdsts.$lv_fltlqd,
                             'vewmaxrec' => ($lo_post['vewmaxrec'] ?? ''),
                             'vewfldord' => $lv_vewfldord
                            );
          $lo_rslqd = $lo_mdllqd->getList($lv_prmlqd, null, null, false);
        }

        if(count($lo_rslqd) == 0){
          ini_set('memory_limit', $lv_lmtmem);
          return $lo_ret;
        }

        // 3- DETALLE. Creo array de IDs y consulto los documentos asociados
        $lo_lqdlst = array();

        foreach ($lo_rslqd as $lv_rowlqd) {
          $lo_lqdlst[$lv_rowlqd['hltprslqdcod']] = $lv_rowlqd['hltprslqdcod'];
          // Guardo IDs de prestadores unicos 
          if(isset($lv_rowlqd['prscod']) && $lv_rowlqd['prscod'] != ''){
            $lo_prslst[$lv_rowlqd['prscod']] = $lv_rowlqd['prscod'];
          }
        }

        if(count($lv_fltarrdoc)==0){
          // Filtro detalle por la lista de IDs de cabecera obtenida
          $lv_prmdoc = array('vewfldflt' => '[~fltrow~]ld.hltprslqdcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lo_lqdlst).chr(9).chr(9),
                             'vewfldord' => $lv_vewfldorddoc
                            );
          $lo_rsdoc = $lo_mdldoc->getList($lv_prmdoc);
        }

        // 3.1 FINANCIADOR DE GASTOS. Resuelvo imputaciones a pacientes en batch.
        $lo_expcusmap = array();
        $lo_expkeymap = array();
        $lo_buyexplst = array();
        $lo_buyexpdoclst = array();
        foreach($lo_rsdoc as $lv_rowdoc){
          if(($lv_rowdoc['refobjtyp'] ?? '') == 'BUY_EXP'){
            $lv_expkey = ($lv_rowdoc['refobjcod001'] ?? '').'_'.($lv_rowdoc['refobjcod002'] ?? '');
            $lo_expkeymap[$lv_expkey] = true;
            if(($lv_rowdoc['refobjcod001'] ?? '') != ''){ $lo_buyexplst[$lv_rowdoc['refobjcod001']] = $lv_rowdoc['refobjcod001']; }
            if(($lv_rowdoc['refobjcod002'] ?? '') != ''){ $lo_buyexpdoclst[$lv_rowdoc['refobjcod002']] = $lv_rowdoc['refobjcod002']; }
          }
        }

        if(count($lo_expkeymap) > 0 && count($lo_buyexplst) > 0 && count($lo_buyexpdoclst) > 0){
          $lo_mdlimp = $this->co_reg->load->model('buyexpdocimp');
          $lv_prmimp = array('vewfldflt' => '[~fltrow~]ei.srcobjtyp'.chr(9).'='.chr(9).chr(9).'HLT_PAT'.chr(9).chr(9).
                                              '[~fltrow~]ei.buyexpcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lo_buyexplst).chr(9).chr(9).
                                              '[~fltrow~]ei.buyexpdoccod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lo_buyexpdoclst).chr(9).chr(9),
                             'vewfldord' => 'ei.buyexpcod, ei.buyexpdoccod, ei.buyexpdocimpcod'
                            );
          $lo_rsimp = $lo_mdlimp->getList($lv_prmimp);
          $lo_imppatmap = array();
          $lo_patlst = array();

          foreach($lo_rsimp as $lv_rowimp){
            $lv_expkey = ($lv_rowimp['buyexpcod'] ?? '').'_'.($lv_rowimp['buyexpdoccod'] ?? '');
            if(!isset($lo_expkeymap[$lv_expkey]) || ($lv_rowimp['srcobjcod001'] ?? '') == ''){ continue; }
            if(!isset($lo_imppatmap[$lv_expkey])){ $lo_imppatmap[$lv_expkey] = array(); }
            $lo_imppatmap[$lv_expkey][] = $lv_rowimp['srcobjcod001'];
            $lo_patlst[$lv_rowimp['srcobjcod001']] = $lv_rowimp['srcobjcod001'];
          }

          if(count($lo_patlst) > 0){
            $lo_mdlpat = $this->co_reg->load->model('hltpat');
            $lv_prmpat = array('vewfldflt' => '[~fltrow~]p.patcod'.chr(9).'IN'.chr(9).chr(9).implode(chr(10), $lo_patlst).chr(9).chr(9));
            $lo_rspat = $lo_mdlpat->getList($lv_prmpat, null, null, false);
            $lo_patcusmap = array();

            foreach($lo_rspat as $lv_rowpat){
              if(($lv_rowpat['patcod'] ?? '') == ''){ continue; }
              $lo_patcusmap[$lv_rowpat['patcod']] = array('cuscod' => ($lv_rowpat['cuscod'] ?? ''), 'custxt' => ($lv_rowpat['custxt'] ?? ''));
            }

            foreach($lo_imppatmap as $lv_expkey => $lo_patlst){
              foreach($lo_patlst as $lv_patcod){
                if(isset($lo_patcusmap[$lv_patcod]) && ($lo_patcusmap[$lv_patcod]['cuscod'] ?? '') != ''){
                  $lo_expcusmap[$lv_expkey] = $lo_patcusmap[$lv_patcod];
                  break;
                }
              }
            }
          }
        }

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
          $lv_refobjtyp = ($lv_rowdoc['refobjtyp'] ?? '');

          $lv_rowdoc['hltprslqddoctot'] = number_format((float)$lv_rowdoc['hltprslqddoctot'], 2, ',', '.');
          $lv_rowdoc['refobjtypraw'] = $lv_refobjtyp;
          $lv_rowdoc['refobjtyp'] = ($lv_refobjtyp == 'HLT_EVL' ? 'PRESTACION' : ($lv_refobjtyp == 'BUY_EXP' ? 'GASTO' : $lv_refobjtyp));

          if($lv_refobjtyp == 'BUY_EXP'){
            $lv_expkey = ($lv_rowdoc['refobjcod001'] ?? '').'_'.($lv_rowdoc['refobjcod002'] ?? '');
            if(isset($lo_expcusmap[$lv_expkey])){
              $lv_rowdoc['cuscod'] = $lo_expcusmap[$lv_expkey]['cuscod'];
              $lv_rowdoc['custxt'] = $lo_expcusmap[$lv_expkey]['custxt'];
            }
          }else if(!isset($lv_rowdoc['cuscod']) && isset($lv_rowlqd['cuscod'])){
            $lv_rowdoc['cuscod'] = $lv_rowlqd['cuscod'];
          }

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
            $lv_fldopr  = ($lv_fpst['fldopr'] ?? 'LIKE');
            $lv_fldval  = $lv_fpst['fldval'];
            $lv_fldin   = ($lv_fpst['fldin'] ?? '');

            // Descripcion: Si no hay desc. en cabecera, se busca en detalle
            if($lv_fldname == 'hltprslqdtxt') {
              $lv_curval = strtolower($lv_merged['hltprslqdtxt'] != '' ? $lv_merged['hltprslqdtxt'] : (isset($lv_merged['hltprslqddoctxt']) ? $lv_merged['hltprslqddoctxt'] : ''));
            } else if($lv_fldname == 'financiador') {
              $lv_curval = strtolower(($lv_merged['cuscod'] ?? '').' '.($lv_merged['custxt'] ?? ''));
            } else if($lv_fldname == 'refobjtyp') {
              $lv_curval = strtolower(($lv_merged['refobjtyp'] ?? '').' '.($lv_merged['refobjtypraw'] ?? ''));
            } else {
              $lv_curval = strtolower(isset($lv_merged[$lv_fldname]) ? $lv_merged[$lv_fldname] : '');
            }

            // Si falla al menos una condicion, se descarta todo el registro
            if($lv_fldval != '') {
              $lv_fltfail = false;
              if($lv_fldopr == 'IN' || substr($lv_fldval, 0, 4) == '(in)'){
                $lv_inraw = ($lv_fldin != '' ? $lv_fldin : (substr($lv_fldval, 0, 4) == '(in)' ? substr($lv_fldval, 4) : $lv_fldval));
                $lv_inarr = explode(chr(10), str_replace(array(chr(13).chr(10), chr(13), ';'), chr(10), $lv_inraw));
                $lv_found = false;
                foreach($lv_inarr as $lv_inval){
                  $lv_inval = strtolower(trim($lv_inval));
                  if($lv_inval == ''){ continue; }
                  if((($lv_fldname == 'refobjtyp' || $lv_fldname == 'financiador') && strpos($lv_curval, $lv_inval) !== false) || ($lv_fldname != 'refobjtyp' && $lv_fldname != 'financiador' && $lv_curval == $lv_inval)){
                    $lv_found = true;
                    break;
                  }
                }
                $lv_fltfail = !$lv_found;
              }else if(($lv_fldopr == '=' || $lv_fldopr == 'EQ') && $lv_fldname != 'refobjtyp' && $lv_fldname != 'financiador'){
                $lv_fltfail = ($lv_curval != $lv_fldval);
              }else{
                $lv_fltfail = (strpos($lv_curval, $lv_fldval) === false);
              }

              if($lv_fltfail) {
                $lv_match = false;
                break;
              }
            }
          }
          if($lv_match) {
            array_push($lo_ret, $lv_merged);
          }
        }

        ini_set('memory_limit', $lv_lmtmem);
        if(isset($lp_prm['ctefle'])){
          $lo_fle = $this->co_reg->load->model('grldatupl');
          $lv_flenme=$this->co_reg->sec->usrcod.'_data.txt';
          $lv_tmp_path = $lo_fle->createTempFile($lv_flenme);
          //$lv_texto=$lp_prm['ctefle'];
          $lv_texto = $this->co_reg->document->getJson( array('datlst'=>$this->co_reg->document->array_utf8_converter($lv_ret),'data_sqlstm'=>$lv_data_sqlstm) );
          //$lv_texto = "Este es un texto de prueba v2";
          file_put_contents($lv_tmp_path, $lv_texto);
        }
        return $lo_ret;
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
        
      case '#testgetlist':{
        $lo_post = $this->co_reg->request->post;
        $lv_ret= array();
        $lv_data_sqlstm = array();
        $lv_data_rs = array();
        $lv_crmmtvls = str_replace(',',chr(10),($lp_prm['cntmtv']??''));
        $lv_crmtypls = str_replace(',',chr(10),($lp_prm['cnttyp']??''));
        // CONTACTOS CRM
        $lo_cntmdl = $this->co_reg->load->model('crmcnt');
        //Filtros CONTACTOS CRM 
				$lv_fltarrcnt = explode('[~fltrow~]',$lo_post['vewfldflt']??'' );		
				for($i=count($lv_fltarrcnt)-1; $i>0; $i--){
					if(stripos(';crmcnttxt;crmcnttyptxt;crmcntsrccnttxt;crmcntsrctxt;crmcntmtvtxt;crmcntcod;crmcntreqdte;crmcntduedte;crmcntststxt;crmcntrqs;usrcod;crmcnttypcod;custxt;',';'.explode(chr(9),$lv_fltarrcnt[$i])[0].';')===false){
						unset($lv_fltarrcnt[$i]);
					}else{
            $lv_fltarrcnt[$i]=str_replace('usrcod','c.usrcod',$lv_fltarrcnt[$i]);
            $lv_fltarrcnt[$i]=str_replace('crmcntreqdte','c.crmcntreqdte',$lv_fltarrcnt[$i]);
            //echo $lv_fltarrcnt[$i];
          }
				}
        $lv_prmflt = array('vewfldflt' =>(count($lv_fltarrcnt)>0?implode('[~fltrow~]',$lv_fltarrcnt):'').
                           								'[~fltrow~]c.crmcntsrctyp'.chr(9).'='.chr(9).chr(9).'SLS_CUS'.chr(9).chr(9).
                           								'[~fltrow~]c.docsts'.chr(9).'='.chr(9).chr(9).'A'.chr(9).chr(9),
													 'vewfldord' => 'c.crmcntreqdte desc',
                           'vewmaxrec'=> ($lo_post['vewmaxrec']??'101')-1
													);
        if($lv_crmmtvls !=''){
        	$lv_prmflt['vewfldflt'].='[~fltrow~]c.crmcntmtvcod'.chr(9).'IN'.chr(9).chr(9).$lv_crmmtvls.chr(9).chr(9);
        }
        if($lv_crmtypls !=''){
        	$lv_prmflt['vewfldflt'].='[~fltrow~]c.crmcnttypcod'.chr(9).'IN'.chr(9).chr(9).$lv_crmtypls.chr(9).chr(9);
        }
        $lo_crmcnt_rs= $lo_cntmdl->getlist($lv_prmflt,null,null,false);
        $lv_data_sqlstm[]=$lo_cntmdl->getSysData('sqlstm');
        $lv_crmcntsrccodlst= array_column($lo_crmcnt_rs, 'crmcntsrccod','crmcntsrccod');
        
        // Parametro de empresa
        $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');	
        if(!$lo_prmmdl->load(array('mdlcod'=>'RPTCRMACT'))){
        	return array('errtyp'=>'E','errcod'=>$lo_prmmdl->errcod,'errtxt'=>$lo_prmmdl->errtxt);
        }
        $lv_data_sqlstm[]= $lo_prmmdl->getsysdata('sqlstm');   
        $lv_attr=$lo_prmmdl->mdlatrval001;//str_replace("*", "all", $lo_prmmdl->mdlatrval001);
        
        $lv_ret =[];
        foreach($lo_crmcnt_rs as $rowCnt){
          $lv_cusKey= $rowCnt['crmcntsrccod'];
          $lvRow=$rowCnt;
          $lvRow['crmcntcuscattxt']=$this->co_reg->document->gettagvalue($lv_attr,'MTV_'.$rowCnt['crmcntmtvcod']);
          //$lvRow['crmcntcuscattxt']=$this->co_reg->document->gettagvalue($lv_attr,'ALL');
          if($lvRow['crmcntcuscattxt']==''){
            $lvRow['crmcntcuscattxt']=$this->co_reg->document->gettagvalue($lv_attr,'ALL');
          }
          
          $lv_ret[]=$lvRow;
        }
        $lv_ret[0]['sqlstm']=$lv_data_sqlstm;
        //$lp_prm['ctefle']='hola';
        if(isset($lp_prm['ctefle'])){
          $lo_fle = $this->co_reg->load->model('grldatupl');
          $lv_flenme=$this->co_reg->sec->usrcod.'_data.txt';
          $lv_tmp_path = $lo_fle->createTempFile($lv_flenme);
          //$lv_texto=$lp_prm['ctefle'];
          $lv_texto = $this->co_reg->document->getJson( array('datlst'=>$this->co_reg->document->array_utf8_converter($lv_ret),'data_sqlstm'=>$lv_data_sqlstm) );
          //$lv_texto = "Este es un texto de prueba v2";
          file_put_contents($lv_tmp_path, $lv_texto);
        }
        return $lv_ret;
        break;
      }
      case '#testhtml':{
        return '<a href="?prg=zcutp1_ttr&act=testfile">Descargar</a>';
        break;	
      }
      case '#testfile':{
        $lv_dir = '../files/'.$this->co_reg->sec->buscod.'/TMP';
        $lp_nme=$this->co_reg->sec->usrcod.'_data.txt';
        $lv_tmp_path = $lv_dir.'/'.$lp_nme;
        //$lv_tmp_path = $lv_dir.'/testFile2.txt';
        header('Content-Type: application/text');
        header('Content-Disposition: attachment; filename="'.$lp_nme.'"');
        readfile($lv_tmp_path);
        break;	
      }
		}
	}
}
?>

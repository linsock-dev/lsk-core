<?php
final class zcucvController extends tmssController
{
    const MODEL = 'zcucv';
    const VIEW = 'zcucv';
    const ID = '';
    protected $co_reg;
    private $lo_mdl;
    private $data = array();

    function __construct(&$lp_reg)
    {
        $this->co_reg = $lp_reg;
    }

    // INDEX. metodo principal de la clase
    public function index($lp_act, $lp_prm = array())
    {

        // all methods of this class are available for logged users check user session
        if ($lp_act != 'C1' && $lp_act != 'C2') {
            $this->co_reg->request->post['ajax'] = '1';
            $lv_lgnbuf = $this->co_reg->user->checkUserLogin();
            if ($lv_lgnbuf != '') {
                return $lv_lgnbuf;
            }
        }

        // load model
        $this->data['actcod'] = $lp_act;
        $lo_mdlevl = $this->co_reg->load->model('hltpatevl');

        $lp_act = '#' . $lp_act;
        switch ($lp_act) {

            //   EVOLUCION - CREAR/VER/MODIFICAR
            case '#evlinf':
            case '#02': {
                $lo_post = $this->co_reg->request->post;

                //Instanciamos los modelos
                $lo_patmdl = $this->co_reg->load->model('hltpat');
                $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
                $lo_plndtemdl2 = $this->co_reg->load->model('hltplndte');
                $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
                $lo_vew = $this->co_reg->load->model('grlvew');
                $lo_prmmdl = $this->co_reg->load->model('sysappmdlprm');
                $lo_matmdl = $this->co_reg->load->model('stkmat');
                $lo_docclsmdl = $this->co_reg->load->model('sysdoccls');
                $lo_docchgmdl = $this->co_reg->load->model('sysdocchg');

                // Obtenemos los parametros post
                $lv_evlcod = ($lo_post['evlcod'] ?? $lp_prm['evlcod'] ?? $lp_prm['prm_evlcod'] ?? '');
                $lv_plnid = ($lo_post['plnid'] ?? $lp_prm['plnid'] ?? '');
                $lv_plndteid = ($lo_post['plndteid'] ?? $lp_prm['plndteid'] ?? '');
                $lv_hhcc = ($lo_post['hhcc'] ?? '');
                $lv_spccod = ($lo_post['spccod'] ?? $lp_prm['spccod'] ?? '1');

                // Buscar datos sugerencia de material 
                // 1. Busco el parametro para obtener los campos obligatorios seguespecialidad 
                $lv_fldrec = [];
                if ($lo_prmmdl->load(array('mdlcod' => 'HLTSPCFRMREQ'))) {
                    $lv_fldrec = explode(';', $this->co_reg->document->getTagValue(strtolower($lo_prmmdl->mdlatrval001), $lv_spccod));
                }
                // cargo la planificacion
                $lo_plndtemdl->load(array('plnid' => $lv_plnid, 'plndteid' => $lv_plndteid));

                $PatChgDte = '';
                $lv_plndte = $lo_plndtemdl->plndte;
                $lv_evlcod = ($lv_evlcod != '' ? $lv_evlcod : $lo_plndtemdl->evlcod);
                $lv_prscod = $lo_plndtemdl->prscod;
                $lv_patcod = $lo_plndtemdl->patcod;
                $lv_pattxt = $lo_plndtemdl->pattxt;

                // obtengo clase de documento
                $lv_docclscod = ($lo_post['sysdocclscod'] ?? '');
                if ($lv_docclscod == '') {															// si no se indico
                    $lv_prm = array(
                        'vewfldflt' => '[~fltrow~]d.objtyp' . chr(9) . '' . chr(9) . 'HLT_EVL' . chr(9) . chr(9) . chr(9) .
                            '[~fltrow~]d.docsts' . chr(9) . '=' . chr(9) . chr(9) . 'A' . chr(9) . chr(9)
                    );
                    $lv_docclsarr = $lo_docclsmdl->getList($lv_prm);		// obtengo las clases de documentos definidas para este objeto
                    if (count($lv_docclsarr) == 1) {											// si hay solo una la tomo como default
                        $lv_docclscod = $lv_docclsarr[0]['sysdocclscod'];
                    } else {
                        return $this->co_reg->document->getView('sysdocclslst', array('url' => '?prg=' . self::CONTROLLER . '&act=01', 'doccls' => $lv_docclsarr));
                    }
                }
                if ($lo_docclsmdl->load(array('sysdocclscod' => $lv_docclscod))) {			// obtengo toda la info de la clase de documento
                    $lo_plndtemdl->sysdoccls = $lo_docclsmdl;
                } else {
                    echo 'No se pudieron cargar los datos de la clase de documento.';
                }


                // Buscar datos sugerencia de material
                // Busco el parametro para obtener el codigo de material segun la especialidad
                /*if (!$lo_prmmdl->load(array('mdlcod' => 'PTMAT'))) {
                    return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => $lo_prmmdl->errcod, 'errtxt' => $lo_prmmdl->errtxt));
                }*/

                // Busco los datos del paciente para obtener la clas. de enfermedad
                if (!$lo_patmdl->load(array('patcod' => $lo_plndtemdl->patcod), false)) {
                    return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => $lo_patmdl->errcod, 'errtxt' => $lo_patmdl->errtxt));
                }

                // MATERIAL. Busco el material
                //$lv_matcod = $this->co_reg->document->getTagValue($lo_prmmdl->mdlatrval001, $lo_patmdl->hltdisclscod);
                $lo_plndtemdl->mattxt = '';
                $lo_plndtemdl->matcod = '';
                $lo_plndtemdl->matuntcod = '';
                /*if ($lv_matcod != '') {
                    if (!$lo_matmdl->load(array('matcod' => $lv_matcod), false)) {
                        return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => $lo_matmdl->errcod, 'errtxt' => $lo_matmdl->errtxt));
                    }
                    $lo_plndtemdl->matcod = $lo_matmdl->matcod;
                    $lo_plndtemdl->mattxt = $lo_matmdl->mattxt;
                    $lo_plndtemdl->matuntcod = $lo_matmdl->matuntcod;
                }*/

                // CREAR EVOLUCION
                if ($lv_evlcod == '') {
                    $lv_dteto = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
                    $lv_dtefrm = new DateTime($this->co_reg->db->sqldate($lv_plndte->format('Ymd')));
                    $lv_dteto->modify('last day of previous month');
                    $lv_dtefrm->modify('first day of previous month');
                    $lv_patflt = '';

                    // obtenemos evoluciones realizadas del mes anterior
                    $lv_prm_list = array(
                        'vewfldflt' => '[~fltrow~]e.evldte' . chr(9) . 'BT' . chr(9) . chr(9) . $lv_dtefrm->format('Ymd') . chr(9) . $lv_dteto->format('Ymd') . chr(9) .
                            ($lv_prscod != '' ? '[~fltrow~]e.prscod' . chr(9) . '=' . chr(9) . chr(9) . $lv_prscod . chr(9) . chr(9) : '') .
                            ($lv_patcod != '' ? '[~fltrow~]e.patcod' . chr(9) . '=' . chr(9) . chr(9) . $lv_patcod . chr(9) . chr(9) : ''),
                        'vewfldord' => 'e.evldte'
                    );
                    $lo_evl_rs = $lo_evlmdl->getList($lv_prm_list, null, null, false);

                    // Generamos la lista de planificaciones ya evolucionadas
                    foreach ($lo_evl_rs as $lv_row) {
                        $lv_patflt .= ($lv_patflt == '' ? '' : chr(10)) . $lv_row['plndteid'];
                    }

                    // obtenemos planificaciones del mes anterior que no estan evolucionadas 
                    $lv_prm_list2 = array(
                        'vewfldflt' => '[~fltrow~]pld.plndteid' . chr(9) . 'NI' . chr(9) . chr(9) . $lv_patflt . chr(9) . chr(9) .
                            '[~fltrow~]pld.plndte' . chr(9) . 'BT' . chr(9) . chr(9) . $lv_dtefrm->format('Ymd') . chr(9) . $lv_dteto->format('Ymd') . chr(9) .
                            ($lv_prscod != '' ? '[~fltrow~]pl.prscod' . chr(9) . '=' . chr(9) . chr(9) . $lv_prscod . chr(9) . chr(9) : '') .
                            ($lv_patcod != '' ? '[~fltrow~]pl.patcod' . chr(9) . '=' . chr(9) . chr(9) . $lv_patcod . chr(9) . chr(9) : ''),
                        'vewfldord' => 'pld.plndteid'
                    );
                    $lo_pln_rs = $lo_plndtemdl2->getList($lv_prm_list2);

                    // preparo datos de vista
                    $lo_plndtemdl->evlatr = array();
                    $lo_plndtemdl->evlspc = array();
                    $lo_plndtemdl->evlmat = array();
                    $lo_plndtemdl->evldte = $lo_plndtemdl->plndte;
                    $lo_plndtemdl->docsts = 'P';

                    // buscar ultimo peso
                    $lv_prmchg = array('chgdocsrctyp' => 'HLT_PAT', 'chgdocsrccod' => $lo_patmdl->patcod);
                    $rsChg = $lo_docchgmdl->getDetail($lv_prmchg);
                    $lv_prm = array(
                        'doc' => $this->co_reg->document,
                        'data' => $lo_plndtemdl, // datos de planificación
                        'actcod' => $this->data['actcod'],
                        'rsplndte' => $lo_pln_rs // fechas no evolucionadas de mes anterior
                    );

                    // VER EVOLUCION
                } else {
                    // cargo datos generales de la evolucion
                    $lo_evlmdl->load(array('evlcod' => $lv_evlcod), false);
                    if ($lo_plndtemdl->plnid == '') {
                        $lo_plndtemdl->load(array('plnid' => $lo_evlmdl->plnid, 'plndteid' => $lo_evlmdl->plndteid));
                    }
                    // obtengo toda la info de la clase de documento
                    if ($lo_docclsmdl->load(array('sysdocclscod' => $lo_evlmdl->sysdocclscod))) {
                        $lo_evlmdl->sysdoccls = $lo_docclsmdl;
                    }
                    $lo_plndtemdl->matuntcod = '';
                    // preparo datos de vista
                    $lv_prm = array(
                        'doc' => $this->co_reg->document,
                        'data' => $lo_evlmdl,
                        'actcod' => $this->data['actcod'],
                        'rsplndte' => array(),
                    );
                }

                // * REGRESO LA VISTA *

                //Buscar motivos de no infucion dependiendo de el financiador de la planificacion
                /*if (!$lo_prmmdl->load(array('mdlcod' => 'EVLCNCMTVLST'))) {
                    return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => $lo_prmmdl->errcod, 'errtxt' => $lo_prmmdl->errtxt));
                }*/

                /*$lv_evlcncmtvlst = $this->co_reg->document->gettagvalue($lo_prmmdl->mdlatrval001, 'CUS_' . $lo_plndtemdl->cuscod);	// MAILS
                if ($lv_evlcncmtvlst == '') {
                    $lv_evlcncmtvlst = $this->co_reg->document->gettagvalue($lo_prmmdl->mdlatrval001, 'ALL');	// MAILS
                }
                $lv_evlcncmtvrows = explode(";", $lv_evlcncmtvlst);
                $lv_mtvarr = array();
                foreach ($lv_evlcncmtvrows as $lv_rowmtv) {
                    $lv_cncmtvrow = explode(",", $lv_rowmtv);
                    $lv_mtvarr[$lv_cncmtvrow[0]] = $lv_cncmtvrow[1];
                }
                $lv_prm['data']->evlcncmtvlst = $lv_mtvarr;*/
                $lv_prm['data']->hhcc = $lv_hhcc;
                $lv_prm['data']->fldrec = $lv_fldrec;
                $lv_prm['data']->patchgdte = '';//$PatChgDte;
                $lv_prm['data']->patwgt = $lo_patmdl->patwgt ?? '';
                $lv_prm['data']->pattxt = $lo_patmdl->pattxt ?? '';
                $lv_prm['data']->patsex = $lo_patmdl->per->persex ?? '';
                $lv_prm['data']->evldia = $lo_patmdl->evldia ?? '';
                $lv_prm['data']->matcod = $lo_matmdl->matcod;
                $lv_prm['data']->mattxt = $lo_matmdl->mattxt;
                $lv_prm['data']->matuntcod = $lo_matmdl->matuntcod;
                $lv_prm['data']->plnid = $lo_plndtemdl->plnid;
                $lv_prm['data']->plndteid = $lo_plndtemdl->plndteid;
                $lv_prm['data']->delcod = $lo_plndtemdl->delcod;
                $lv_prm['data']->endpoint = self::VIEW;

                return $this->co_reg->document->getView('zcucv_hltevl', $lv_prm);
                break;
            }

            //   EVOLUCION - GRABAR
            case '#evlinf00':
                $lo_post = $this->co_reg->request->post;

                // Decode JSON inputs
                $frm_arr = array();
                if (isset($lo_post['frm_json'])) {
                    $frm_arr = json_decode(html_entity_decode($lo_post['frm_json']), true);
                    if (is_array($frm_arr)) {
                        $lo_post = array_merge($lo_post, $frm_arr);
                    }
                }

                $lv_plnid = ($lo_post['plnid'] ?? $lp_prm['plnid'] ?? '');
                $lv_plndteid = ($lo_post['plndteid'] ?? $lp_prm['plndteid'] ?? '');

                // Set evlatr001 as clean JSON
                $lo_post['evlatr001'] = isset($lo_post['frm_json']) ? html_entity_decode($lo_post['frm_json']) : '{}';

                // Process materials
                $mat_arr = array();
                if (isset($lo_post['mat_json']) && $lo_post['mat_json'] != '') {
                    $mat_arr = json_decode(html_entity_decode($lo_post['mat_json']), true);
                }
                $lo_post['evlmat'] = json_encode($mat_arr);
                $this->co_reg->request->post = $lo_post;

                $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
                $lo_evlmatmdl = $this->co_reg->load->model('hltpatevlmat');
                $lo_patmdl = $this->co_reg->load->model('hltpat');
                $lo_patmdl->load(array('patcod' => $lo_post['patcod'] ?? ''), false);

                $lv_buf_arr = &$lo_post;
                $lv_evldte = (isset($lo_post['evldte']) ? $lo_post['evldte'] : ($lp_prm['evldte'] ?? ''));
                $lv_evlinfprc = isset($lo_post['evlinfprc']) ? $lo_post['evlinfprc'] : '';
                $lv_docsts = ($lv_evlinfprc == '1' ? 'A' : 'P');
                $lo_post['docsts'] = $lv_docsts;

                if ($lo_post['evlcod'] == '') {
                    $lo_post['evlobj'] = $lv_evlinfprc == '1' ? 'REALIZADO ' . $lv_evldte : 'NO REALIZADO';
                }

                // EVOLUCION - grabo los datos
                if ($lo_evlmdl->save($lo_post, false) == false) {
                    return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => $lo_evlmdl->errcod, 'errtxt' => $lo_evlmdl->errtxt));
                }


                $lv_errcod = $lo_evlmdl->errcod;
                $lv_errtxt = $lo_evlmdl->errtxt;

                /* GRABO EL ICONO EN LA PLANIFICACION*/
                /* OBTEGO LA PLANIFICACION */
                $lo_plndtemdl = $this->co_reg->load->model('hltplndte');
                $lo_plndtearr = array();
                $lo_plndtearr['plndteid'] = $lv_plndteid;
                $lo_plndtearr['plnid'] = $lv_plnid;
                if (!$lo_plndtemdl->load($lo_plndtearr)) {
                    return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => $lo_plndtemdl->errcod, 'errtxt' => $lo_plndtemdl->errtxt));
                }
                $lo_plndtearr['plndteatr'] = $lo_plndtemdl->plndteatr;
                $lo_plndtearr['hltplndteatrusricn'] = 'fa-solid fa-message-medical';
                if (!$lo_plndtemdl->save($lo_plndtearr)) {
                    return $this->co_reg->document->getJson(array('errtyp' => 'E', 'errcod' => $lo_plndtemdl->errcod, 'errtxt' => $lo_plndtemdl->errtxt));
                }

                // obtengo mensaje de notificacion
                $lo_txtmdl = $this->co_reg->load->model('grldattxt');
                if ($lo_txtmdl->load(array('txtcodext' => 'HLTEVLGRL', 'txtsys' => 1), false)) {
                    $lv_usrmsg = $lo_txtmdl->txttxt;
                } else {
                    $lv_usrmsg = '';
                    $lv_errcod = '-1';
                    $lv_errtxt = 'No se encontro el texto del mensaje.';
                }

                $ctlZcucv = $this->co_reg->load->controller('zcucv');
                $lvDataFarma = $lv_buf_arr;
                $lvDataFarma['patcod'] = $lo_patmdl->patcod;
                $lvDataFarma['pattxt'] = $lo_patmdl->pattxt;
                $ctlZcucv->sendMailFarma($lvDataFarma);
                return $this->co_reg->document->getJson(array('errtyp' => 'S', 'errcod' => $lv_errcod, 'errtxt' => $lv_errtxt, 'evlcod' => $lo_evlmdl->evlcod));
                break;

            // EVOLUCION - BORRAR
            case '#evlinf04':
                $lo_post = $this->co_reg->request->post;
                $lv_evlcod = ($lo_post['evlcod'] ?? $lp_prm['evlcod'] ?? '');
                $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
                $lo_evlmdl->delete(array('evlcod' => $lv_evlcod), false);
                return $this->co_reg->document->getJson(array('errtyp' => $lo_evlmdl->errtyp, 'errcod' => $lo_evlmdl->errcod, 'errtxt' => $lo_evlmdl->errtxt));
                break;


            // -----------------------------------------------------
            // EVENTO ADVERSO - impresion
            // -----------------------------------------------------
            case '#hltpatevleaprn':
                $lo_post = $this->co_reg->request->post;

                // EVOLUCION. cargo evolucion
                $lo_evlmdl = $this->co_reg->load->model('hltpatevl');
                $lv_evlcod = ($lo_post['evlcod'] ?? $lp_prm['evlcod'] ?? 0);
                $lo_evlmdl->load(array('evlcod' => $lv_evlcod), false);

                // PACIENTE. cargo paciente
                $lo_patmdl = $this->co_reg->load->model('hltpat');
                $lo_patmdl->load(array('patcod' => $lo_evlmdl->patcod), false);

                // PRESTADOR. cargo prestador
                $lo_prsmdl = $this->co_reg->load->model('hltprs');
                $lo_prsmdl->load(array('prscod' => $lo_evlmdl->prscod), false);

                // VISTA. devuelvo vista (pdf)
                $lv_prm = array('evl' => $lo_evlmdl, 'pat' => $lo_patmdl, 'prs' => $lo_prsmdl);
                $lv_buffer = $this->co_reg->document->getview('zcucv_hltpatevleapnt', $lv_prm);
                $this->co_reg->response->addHeader('Content-type:application/pdf');
                return $lv_buffer;
                break;

        }
    }

    public function sendMailFarma($lpData)
    {
        $lpData['evlcod'] = $lpData['evlcod'] ?? 'ERR';
        $lpData['cuscod'] = $lpData['cuscod'] ?? '';
        $lpData['patcod'] = $lpData['patcod'] ?? '';
        $lpData['pattxt'] = $lpData['pattxt'] ?? '';
        $lpData['spccod'] = $lpData['spccod'] ?? '';
        $lpData['spctxt'] = $lpData['spctxt'] ?? '';
        $lpData['evlcmt'] = $lpData['evlcmt'] ?? '';

        // obtengo mensaje de notificacion
        $lo_txtmdl = $this->co_reg->load->model('grldattxt');
        if ($lo_txtmdl->load(array('txtcodext' => 'HLTEVLGRL', 'txtsys' => 1), false)) {
            $lv_usrmsg = $lo_txtmdl->txttxt;
        } else {
            $lv_usrmsg = '';
            $lv_errcod = '-1';
            $lv_errtxt = 'No se encontro el texto del mensaje.';
        }

        // determino destinatarios
        $lo_appprmmdl = $this->co_reg->load->model('sysappmdlprm');
        if ($lo_appprmmdl->load(array('mdlcod' => 'CNFEMLFMV')) == false) {
            $lv_buffer = '-100: NO EXISTE PARAMETRO DE EMPRESA CON EL CODIGO "CNFEMLFMV"';
            return $lv_buffer;
        }

        $lv_sndeml = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001, $lpData['cuscod']);	// MAILS
        if ($lv_sndeml == '') {
            $lv_sndeml = $this->co_reg->document->gettagvalue($lo_appprmmdl->mdlatrval001, '*');	// MAILS
        }
        $lv_mailtoarr = explode(';', $lv_sndeml);
        foreach ($lv_mailtoarr as $lv_val) {
            $lv_mailto[] = array('address' => $lv_val);
        }
        // env铆o mail
        if ($lv_usrmsg != '') {
            $lo_eml = new tmssMail();
            $lv_emlprm = array();
            $lv_emlprm['to'] = $lv_mailto;
            $lv_emlprm['from'] = array(array('address' => 'noreply@temasis.com.ar', 'name' => 'LSDM'));
            $lv_emlprm['subject'] = 'Evolucion para reporte a FV';
            $lv_usrmsg = str_replace('[%1]', $this->co_reg->sec->bustxt, $lv_usrmsg);
            $lv_usrmsg = str_replace('[%2]', 'Evoluci&oacute;n para reportar a farmacovigilancia', $lv_usrmsg);
            $lv_usrmsg = str_replace('[%3]', 'Paciente : ( #' . $lpData['patcod'] . ' ) <strong>' . utf8_decode($lpData['pattxt']) . '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace('[%3]', 'Financiador : ( #' . $lpData['cuscod'] . ' ) <strong>' . utf8_decode($lpData['custxt']) . '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace('[%3]', 'Fecha de evolucion: ( #' . $lpData['evlcod'] . ' ) <strong>' . $lpData['evldte'] . '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace('[%3]', 'Prestador : ( #' . $lpData['prscod'] . ' ) <strong>' . utf8_decode($lpData['prstxt']) . '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace('[%3]', 'Especialidad : ( #' . $lpData['spccod'] . ' ) <strong>' . utf8_decode($lpData['spctxt']) . '</strong><br/>[%3]', $lv_usrmsg);
            $lv_usrmsg = str_replace('[%3]', 'Comentarios:<br/>' . utf8_decode($lpData['evlcmt']) . '<br/>', $lv_usrmsg);
            $lv_emlprm['bodyhtml'] = $lv_usrmsg;
            if ($lo_eml->send($lv_emlprm)) {
                $lv_errcod = '';
                $lv_errtxt = '';
            } else {
                $lv_errcod = '-1';
                $lv_errtxt = 'Se produjo un error al enviar el mail de confirmaci&oacute;n. <br><br>' . $lo_eml->getError() . '<br><br>Consulte al administrador del sistema.';
                return array('errtyp' => 'E', 'errcod' => $lv_errcod, 'errtxt' => $lv_errtxt);
            }
        }
    }

}
?>
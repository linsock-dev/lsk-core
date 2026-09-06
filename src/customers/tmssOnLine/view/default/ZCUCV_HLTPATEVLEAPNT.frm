<?php
/*
    // Include the main TCPDF library (search for installation path).
    require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

    // create new PDF document
    $pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'ISO-8859-1', false);

    // remove default header/footer
    $pdf->setPrintHeader(false);
    $pdf->setPrintFooter(false);

    // set default monospaced font
    $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

    // set margins
    $pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);

    // set auto page breaks
    $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

    // set image scale factor
    $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

    // ---------------------------------------------------------
    // Paleta de colores (apariencia levemente mas moderna)
    // ---------------------------------------------------------
    $lv_colorTitulo   = '#1F3864'; // azul oscuro para titulos de seccion
    $lv_colorBanda    = '#EAF1F8'; // fondo suave para bandas de seccion
    $lv_colorLinea    = '#B9C6D6'; // lineas/bordes suaves
    $lv_colorTexto    = '#222222';

    // ---------------------------------------------------------
    // Helper: castilla de checkbox (checked / unchecked) + etiqueta
    // No se modifica ningun texto original del formulario.
    // ---------------------------------------------------------
    function co_checkbox($pv_label, $pv_checked = false) {
        $lv_box = $pv_checked
            ? '<span style="border:0.6pt solid #1F3864; background-color:#1F3864; color:#FFFFFF; padding:0 3px;"><b>X</b></span>'
            : '<span style="border:0.6pt solid #1F3864; padding:0 5px;">&nbsp;</span>';
        return $lv_box . '&nbsp;&nbsp;' . $pv_label;
    }

    // Helper: banda de titulo de seccion
    function co_seccion($pv_titulo, $pv_color_banda, $pv_color_titulo) {
        return '<table cellpadding="4" cellspacing="0" border="0" style="width:100%;">'.
                    '<tr><td style="background-color:'.$pv_color_banda.'; color:'.$pv_color_titulo.';"><b>'.$pv_titulo.'</b></td></tr>'.
                '</table>';
    }

    // ---------------------------------------------------------
    // Datos de origen (mismo criterio que evolucion.php: objeto $vew_data)
    // Si no llegan datos, se completan los campos en blanco para respetar
    // el formulario tal cual figura en el documento original.
    // ---------------------------------------------------------
    $lv_fte_espontaneo   = isset($vew_data->fteesp)      ? $vew_data->fteesp      : false;
    $lv_fte_offlabel     = isset($vew_data->fteofl)      ? $vew_data->fteofl      : false;
    $lv_fte_errmed       = isset($vew_data->fteerm)      ? $vew_data->fteerm      : false;
    $lv_fte_abuso        = isset($vew_data->fteabu)      ? $vew_data->fteabu      : false;
    $lv_fte_estclin      = isset($vew_data->fteecl)      ? $vew_data->fteecl      : false;

    $lv_numlocal         = isset($vew_data->numloc)      ? $vew_data->numloc      : '';
    $lv_fecrec           = isset($vew_data->fecrec)      ? $vew_data->fecrec      : '';
    $lv_fecseg           = isset($vew_data->fecseg)      ? $vew_data->fecseg      : '';

    $lv_grave_no         = isset($vew_data->grvno)       ? $vew_data->grvno       : false;
    $lv_grave_si         = isset($vew_data->grvsi)       ? $vew_data->grvsi       : false;
    $lv_grave_inicial    = isset($vew_data->grvini)      ? $vew_data->grvini      : false;
    $lv_grave_segv       = isset($vew_data->grvsegv)     ? $vew_data->grvsegv     : '';

    $lv_crit_muerte      = isset($vew_data->critmue)     ? $vew_data->critmue     : false;
    $lv_crit_malform     = isset($vew_data->critmal)     ? $vew_data->critmal     : false;
    $lv_crit_riesgo      = isset($vew_data->critrie)     ? $vew_data->critrie     : false;
    $lv_crit_discap      = isset($vew_data->critdis)     ? $vew_data->critdis     : false;
    $lv_crit_hosp        = isset($vew_data->crithos)     ? $vew_data->crithos     : false;
    $lv_crit_otro        = isset($vew_data->critotr)     ? $vew_data->critotr     : false;

    $lv_ciudad           = isset($vew_data->ciudad)      ? $vew_data->ciudad      : '';
    $lv_pais             = isset($vew_data->pais)        ? $vew_data->pais        : 'Argentina';
    $lv_desvio_cal       = isset($vew_data->desvcal)     ? $vew_data->desvcal     : false;
    $lv_reclamo_prod     = isset($vew_data->reclprod)    ? $vew_data->reclprod    : '';

    $lv_prof_no          = isset($vew_data->profno)      ? $vew_data->profno      : false;
    $lv_prof_si          = isset($vew_data->profsi)      ? $vew_data->profsi      : false;
    $lv_notif_nombre     = isset($vew_data->notnom)      ? $vew_data->notnom      : '';
    $lv_notif_relacion   = isset($vew_data->notrel)      ? $vew_data->notrel      : '';

    $lv_via_deptofv      = isset($vew_data->viadfv)      ? $vew_data->viadfv      : false;
    $lv_via_psp          = isset($vew_data->viapsp)      ? $vew_data->viapsp      : false;
    $lv_via_deptocal     = isset($vew_data->viadca)      ? $vew_data->viadca      : false;
    $lv_via_web          = isset($vew_data->viaweb)      ? $vew_data->viaweb      : false;
    $lv_via_otra         = isset($vew_data->viaotr)      ? $vew_data->viaotr      : false;
    $lv_via_otra_txt     = isset($vew_data->viaotrtxt)   ? $vew_data->viaotrtxt   : '';

    $lv_pac_iniciales    = isset($vew_data->paciniciales)? $vew_data->paciniciales: '';
    $lv_pac_peso         = isset($vew_data->pacpeso)     ? $vew_data->pacpeso     : '';
    $lv_pac_fecnac       = isset($vew_data->pacfecnac)   ? $vew_data->pacfecnac   : '';
    $lv_pac_edad         = isset($vew_data->pacedad)     ? $vew_data->pacedad     : '';
    $lv_pac_sexo_m       = isset($vew_data->pacsexm)     ? $vew_data->pacsexm     : false;
    $lv_pac_sexo_f       = isset($vew_data->pacsexf)     ? $vew_data->pacsexf     : false;

    $lv_med_generico     = isset($vew_data->medgen)      ? $vew_data->medgen      : '';
    $lv_med_comercial    = isset($vew_data->medcom)      ? $vew_data->medcom      : '';
    $lv_med_dosis        = isset($vew_data->meddos)      ? $vew_data->meddos      : '';
    $lv_med_frecuencia   = isset($vew_data->medfre)      ? $vew_data->medfre      : '';
    $lv_med_via          = isset($vew_data->medvia)      ? $vew_data->medvia      : '';

    $lv_med_indicacion   = isset($vew_data->medind)      ? $vew_data->medind      : '';
    $lv_med_feccom       = isset($vew_data->medfeccom)   ? $vew_data->medfeccom   : '';
    $lv_med_fecfin       = isset($vew_data->medfecfin)   ? $vew_data->medfecfin   : '';
    $lv_med_reexp        = isset($vew_data->medreexp)    ? $vew_data->medreexp    : '';
    $lv_med_reexp_fec    = isset($vew_data->medreexpfec) ? $vew_data->medreexpfec : '';
    $lv_med_lote         = isset($vew_data->medlote)     ? $vew_data->medlote     : '';

    $lv_concom           = isset($vew_data->concom)      ? $vew_data->concom      : array();

    $lv_antecedentes     = isset($vew_data->antclin)     ? $vew_data->antclin     : '';

    $lv_eva_feccom       = isset($vew_data->evafeccom)   ? $vew_data->evafeccom   : '';
    $lv_eva_resp_fvg     = isset($vew_data->evarespfvg)  ? $vew_data->evarespfvg  : '';

    $lv_res_requirtto    = isset($vew_data->resreqtto)   ? $vew_data->resreqtto   : false;
    $lv_res_recintegrum  = isset($vew_data->resrecint)   ? $vew_data->resrecint   : false;
    $lv_res_recsecuelas  = isset($vew_data->resrecsec)   ? $vew_data->resrecsec   : false;
    $lv_res_norecup      = isset($vew_data->resnorec)    ? $vew_data->resnorec    : false;
    $lv_res_desconocido  = isset($vew_data->resdesc)     ? $vew_data->resdesc     : false;
    $lv_res_reqhosp      = isset($vew_data->resreqhos)   ? $vew_data->resreqhos   : false;
    $lv_res_riesgovida   = isset($vew_data->resriesgo)   ? $vew_data->resriesgo   : false;
    $lv_res_malformacion = isset($vew_data->resmalfor)   ? $vew_data->resmalfor   : false;
    $lv_res_otro         = isset($vew_data->resotro)     ? $vew_data->resotro     : false;
    $lv_res_muerte       = isset($vew_data->resmuerte)   ? $vew_data->resmuerte   : false;
    $lv_res_fecmuerte    = isset($vew_data->resfecmuerte)? $vew_data->resfecmuerte: '';

    $lv_firma_nombre     = 'Florencia Amato';
    $lv_firma_cargo      = 'Medica';
    $lv_firma_usuario    = 'f.amato';

    // ===========================================================
    // PAGINA 1
    // ===========================================================
    $pdf->AddPage('P');
    $pdf->setfont('helvetica', '', 9);

    // --- Encabezado ---
    $lv_html  = '<table cellpadding="2" cellspacing="0" border="0" style="width:100%;">'.
                    '<tr>'.
                        '<td style="width:70%;"><b style="font-size:13pt; color:'.$lv_colorTitulo.';">Formulario de Casos de Notificaci&oacute;n obligatoria</b><br/>'.
                        '<span style="color:#666666;">Anexo de #SOP</span></td>'.
                        '<td style="width:30%; text-align:right;"><b>Versi&oacute;n 2</b><br/>P&aacute;gina 1</td>'.
                    '</tr>'.
                '</table>'.
                '<hr style="color:'.$lv_colorLinea.'; height:1.2pt; margin-top:2px; margin-bottom:6px;"/>';
    $pdf->setxy(15, 15);
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    // --- DATOS ADMINISTRATIVOS ---
    $pdf->writeHTML(co_seccion('DATOS ADMINISTRATIVOS', $lv_colorBanda, $lv_colorTitulo), true, false, true, false, '');

    $lv_html = '<table cellpadding="3" cellspacing="0" border="0" style="width:100%;">'.
                    '<tr>'.
                        '<td style="width:22%;"><b>Fuente</b></td>'.
                        '<td>'.co_checkbox('Espontaneo', $lv_fte_espontaneo).'</td>'.
                        '<td>'.co_checkbox('Off-Label', $lv_fte_offlabel).'</td>'.
                        '<td>'.co_checkbox('Error de Medicaci&oacute;n', $lv_fte_errmed).'</td>'.
                    '</tr>'.
                    '<tr>'.
                        '<td></td>'.
                        '<td>'.co_checkbox('Abuso/sobredosis', $lv_fte_abuso).'</td>'.
                        '<td colspan="2">'.co_checkbox('Estudio Cl&iacute;nico.', $lv_fte_estclin).'</td>'.
                    '</tr>'.
                '</table>';
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    $lv_html = '<table cellpadding="3" cellspacing="0" border="0" style="width:100%;">'.
                    '<tr>'.
                        '<td style="width:34%;"><b>Numero Local:</b> '.$lv_numlocal.'</td>'.
                        '<td style="width:33%;"><b>Fecha de recepci&oacute;n (fecha 0):</b> '.$lv_fecrec.'</td>'.
                        '<td style="width:33%;"><b>Fecha seguimiento (si aplica):</b> '.$lv_fecseg.'</td>'.
                    '</tr>'.
                '</table>';
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    $lv_html = '<table cellpadding="3" cellspacing="0" border="0" style="width:100%;">'.
                    '<tr>'.
                        '<td style="width:16%;"><b>&iquest;Caso Grave?</b></td>'.
                        '<td style="width:10%;">'.co_checkbox('No', $lv_grave_no).'</td>'.
                        '<td style="width:10%;">'.co_checkbox('Si', $lv_grave_si).'</td>'.
                        '<td style="width:64%;">Si es si, indicar el/los criterio/s '.
                            co_checkbox('Inicial (V0)', $lv_grave_inicial).'&nbsp;&nbsp;&nbsp;Seguimiento V: '.$lv_grave_segv.
                        '</td>'.
                    '</tr>'.
                '</table>';
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    $lv_html = '<table cellpadding="3" cellspacing="0" border="0.4" bordercolor="'.$lv_colorLinea.'" style="width:100%;">'.
                    '<tr><td colspan="3" style="background-color:#F5F8FB;"><b>Criterios para Caso Grave:</b></td></tr>'.
                    '<tr>'.
                        '<td style="width:33%;">'.co_checkbox('Muerte', $lv_crit_muerte).'</td>'.
                        '<td style="width:33%;">'.co_checkbox('Malformaci&oacute;n', $lv_crit_malform).'</td>'.
                        '<td style="width:33%;">'.co_checkbox('Riesgo de vida', $lv_crit_riesgo).'</td>'.
                    '</tr>'.
                    '<tr>'.
                        '<td>'.co_checkbox('Discapacidad/ Incapacidad', $lv_crit_discap).'</td>'.
                        '<td colspan="2">'.co_checkbox('Hospitalizaci&oacute;n o prolonga hospitalizaci&oacute;n', $lv_crit_hosp).'</td>'.
                    '</tr>'.
                    '<tr>'.
                        '<td colspan="3">'.co_checkbox('Otro', $lv_crit_otro).'</td>'.
                    '</tr>'.
                '</table>';
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    $lv_html = '<table cellpadding="3" cellspacing="0" border="0" style="width:100%;">'.
                    '<tr>'.
                        '<td style="width:25%;"><b>Ciudad:</b> '.$lv_ciudad.'</td>'.
                        '<td style="width:25%;"><b>Pa&iacute;s:</b> '.$lv_pais.'</td>'.
                        '<td style="width:25%;">'.co_checkbox('Desv&iacute;o de Calidad', $lv_desvio_cal).'</td>'.
                        '<td style="width:25%;"><b>Reclamo de producto #:</b> (si aplica) '.$lv_reclamo_prod.'</td>'.
                    '</tr>'.
                '</table>';
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    // --- Datos del Notificador ---
    $pdf->writeHTML(co_seccion('Datos del Notificador (si el notificador es el propio paciente, no completar)', $lv_colorBanda, $lv_colorTitulo), true, false, true, false, '');

    $lv_html = '<table cellpadding="3" cellspacing="0" border="0" style="width:100%;">'.
                    '<tr>'.
                        '<td style="width:20%;"><b>Profesional de la salud:</b></td>'.
                        '<td style="width:8%;">'.co_checkbox('No', $lv_prof_no).'</td>'.
                        '<td style="width:8%;">'.co_checkbox('Si', $lv_prof_si).'</td>'.
                        '<td style="width:64%;">Si es si, indicar</td>'.
                    '</tr>'.
                    '<tr>'.
                        '<td colspan="2"><b>Nombre:</b> '.$lv_notif_nombre.'</td>'.
                        '<td colspan="2"><b>Relaci&oacute;n:</b> '.$lv_notif_relacion.'</td>'.
                    '</tr>'.
                '</table>';
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    $lv_html = '<table cellpadding="3" cellspacing="0" border="0" style="width:100%;">'.
                    '<tr>'.
                        '<td style="width:20%;"><b>V&iacute;a de recepci&oacute;n</b></td>'.
                        '<td style="width:16%;">'.co_checkbox('Depto. FV', $lv_via_deptofv).'</td>'.
                        '<td style="width:16%;">'.co_checkbox('PSP', $lv_via_psp).'</td>'.
                        '<td style="width:16%;">'.co_checkbox('Depto. Calidad', $lv_via_deptocal).'</td>'.
                        '<td style="width:16%;">'.co_checkbox('P&aacute;gina Web', $lv_via_web).'</td>'.
                        '<td style="width:16%;">'.co_checkbox('Otra: '.$lv_via_otra_txt, $lv_via_otra).'</td>'.
                    '</tr>'.
                '</table>';
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    // --- INFORMACION DEL PACIENTE ---
    $pdf->writeHTML(co_seccion('INFORMACION DEL PACIENTE', $lv_colorBanda, $lv_colorTitulo), true, false, true, false, '');

    $lv_sexo = co_checkbox('Masculino', $lv_pac_sexo_m).'<br/>'.co_checkbox('Femenino', $lv_pac_sexo_f);

    $lv_html = '<table cellpadding="3" cellspacing="0" border="0.4" bordercolor="'.$lv_colorLinea.'" style="width:100%;">'.
                    '<tr style="background-color:#F5F8FB;">'.
                        '<td style="width:20%;" align="center"><b>Iniciales del paciente</b></td>'.
                        '<td style="width:15%;" align="center"><b>Peso</b></td>'.
                        '<td style="width:25%;" align="center"><b>Fecha de Nacimiento</b></td>'.
                        '<td style="width:15%;" align="center"><b>Edad</b></td>'.
                        '<td style="width:25%;" align="center"><b>Sexo</b></td>'.
                    '</tr>'.
                    '<tr>'.
                        '<td align="center">'.$lv_pac_iniciales.'</td>'.
                        '<td align="center">&hellip;&hellip;kg '.$lv_pac_peso.'</td>'.
                        '<td align="center">&hellip;&hellip;./&hellip;&hellip;./&hellip;&hellip; '.$lv_pac_fecnac.'</td>'.
                        '<td align="center">&hellip;&hellip;. a&ntilde;os '.$lv_pac_edad.'</td>'.
                        '<td>'.$lv_sexo.'</td>'.
                    '</tr>'.
                '</table>';
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    // --- Medicamento sospechado ---
    $pdf->writeHTML(co_seccion('Medicamento sospechado', $lv_colorBanda, $lv_colorTitulo), true, false, true, false, '');

    $lv_html = '<table cellpadding="3" cellspacing="0" border="0.4" bordercolor="'.$lv_colorLinea.'" style="width:100%;">'.
                    '<tr style="background-color:#F5F8FB;">'.
                        '<td style="width:22%;" align="center"><b>Nombre Gen&eacute;rico</b></td>'.
                        '<td style="width:22%;" align="center"><b>Nombre Comercial</b></td>'.
                        '<td style="width:18%;" align="center"><b>Dosis</b></td>'.
                        '<td style="width:18%;" align="center"><b>Frecuencia</b></td>'.
                        '<td style="width:20%;" align="center"><b>V&iacute;a de Administracion</b></td>'.
                    '</tr>'.
                    '<tr>'.
                        '<td align="center">'.$lv_med_generico.'</td>'.
                        '<td align="center">'.$lv_med_comercial.'</td>'.
                        '<td align="center">'.$lv_med_dosis.'</td>'.
                        '<td align="center">'.$lv_med_frecuencia.'</td>'.
                        '<td align="center">'.$lv_med_via.'</td>'.
                    '</tr>'.
                '</table>';
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    $lv_html = '<table cellpadding="3" cellspacing="0" border="0.4" bordercolor="'.$lv_colorLinea.'" style="width:100%;">'.
                    '<tr style="background-color:#F5F8FB;">'.
                        '<td style="width:34%;" align="center"><b>Indicacion</b></td>'.
                        '<td style="width:33%;" align="center"><b>Fecha de comienzo</b></td>'.
                        '<td style="width:33%;" align="center"><b>Fecha de finalizacion</b></td>'.
                    '</tr>'.
                    '<tr>'.
                        '<td align="center">'.$lv_med_indicacion.'</td>'.
                        '<td align="center">'.$lv_med_feccom.'</td>'.
                        '<td align="center">'.$lv_med_fecfin.'</td>'.
                    '</tr>'.
                '</table>';
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    $lv_html = '<table cellpadding="3" cellspacing="0" border="0" style="width:100%;">'.
                    '<tr>'.
                        '<td style="width:66%;"><b>Si finaliz&oacute;, hubo reexposici&oacute;n?</b> SI/NO - Aclarar fecha de reexposici&oacute;n: '.$lv_med_reexp.' '.$lv_med_reexp_fec.'</td>'.
                        '<td style="width:34%;"><b>Nro de Lote:</b> '.$lv_med_lote.'</td>'.
                    '</tr>'.
                '</table>';
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    // --- Medicacion concomitante ---
    $pdf->writeHTML(co_seccion('Medicaci&oacute;n concomitante', $lv_colorBanda, $lv_colorTitulo), true, false, true, false, '');

    $lv_tbl = '<table cellpadding="3" cellspacing="0" border="0.4" bordercolor="'.$lv_colorLinea.'" style="width:100%;">'.
                    '<tr style="background-color:#F5F8FB;">'.
                        '<td style="width:34%;" align="center"><b>Producto</b></td>'.
                        '<td style="width:33%;" align="center"><b>Dosis</b></td>'.
                        '<td style="width:33%;" align="center"><b>Indicaci&oacute;n</b></td>'.
                    '</tr>';
    if (is_array($lv_concom) && count($lv_concom) > 0) {
        foreach ($lv_concom as $lv_row) {
            $lv_tbl .= '<tr>'.
                            '<td align="center">'.(isset($lv_row['prod']) ? $lv_row['prod'] : '').'</td>'.
                            '<td align="center">'.(isset($lv_row['dosis']) ? $lv_row['dosis'] : '').'</td>'.
                            '<td align="center">'.(isset($lv_row['indic']) ? $lv_row['indic'] : '').'</td>'.
                        '</tr>';
        }
    } else {
        $lv_tbl .= '<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>';
    }
    $lv_tbl .= '</table>';
    $pdf->writeHTML($lv_tbl, true, false, true, false, '');

    // --- Antecedentes clinicos relevantes ---
    $pdf->writeHTML(co_seccion('Antecedentes cl&iacute;nicos relevantes', $lv_colorBanda, $lv_colorTitulo), true, false, true, false, '');
    $pdf->writeHTML('<table cellpadding="3" cellspacing="0" border="0.4" bordercolor="'.$lv_colorLinea.'" style="width:100%;"><tr><td style="height:40px;">'.$lv_antecedentes.'&nbsp;</td></tr></table>', true, false, true, false, '');

    // ===========================================================
    // PAGINA 2
    // ===========================================================
    $pdf->AddPage('P');
    $pdf->setxy(15, 15);

    $lv_html  = '<table cellpadding="2" cellspacing="0" border="0" style="width:100%;">'.
                    '<tr>'.
                        '<td style="width:70%;"><b style="font-size:13pt; color:'.$lv_colorTitulo.';">Formulario de Casos de Notificaci&oacute;n obligatoria</b><br/>'.
                        '<span style="color:#666666;">Anexo de #SOP</span></td>'.
                        '<td style="width:30%; text-align:right;"><b>Versi&oacute;n 2</b><br/>P&aacute;gina 2</td>'.
                    '</tr>'.
                '</table>'.
                '<hr style="color:'.$lv_colorLinea.'; height:1.2pt; margin-top:2px; margin-bottom:6px;"/>';
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    // --- Datos del Evento Adverso ---
    $pdf->writeHTML(co_seccion('Datos del Evento Adverso', $lv_colorBanda, $lv_colorTitulo), true, false, true, false, '');

    $lv_html = '<table cellpadding="3" cellspacing="0" border="0" style="width:100%;">'.
                    '<tr>'.
                        '<td style="width:34%;"><b>Fecha de comienzo:</b> '.$lv_eva_feccom.'</td>'.
                        '<td style="width:66%; vertical-align:top;"><b>Resultado</b><br/>'.
                            co_checkbox('Requiri&oacute; tratamiento', $lv_res_requirtto).'<br/>'.
                            co_checkbox('Recuperado ad integrum', $lv_res_recintegrum).'<br/>'.
                            co_checkbox('Recuperado con secuelas', $lv_res_recsecuelas).'<br/>'.
                            co_checkbox('No recuperado aun', $lv_res_norecup).'<br/>'.
                            co_checkbox('Desconocido', $lv_res_desconocido).'<br/>'.
                            co_checkbox('Requiri&oacute; o prolongo su hospitalizaci&oacute;n', $lv_res_reqhosp).'<br/>'.
                            co_checkbox('Riesgo de vida', $lv_res_riesgovida).'<br/>'.
                            co_checkbox('Malformaci&oacute;n', $lv_res_malformacion).'<br/>'.
                            co_checkbox('Otro', $lv_res_otro).'<br/>'.
                            co_checkbox('Muerte', $lv_res_muerte).'<br/>'.
                            '* fecha de muerte: &hellip;.&hellip;/&hellip;&hellip;/&hellip;&hellip;. '.$lv_res_fecmuerte.
                        '</td>'.
                    '</tr>'.
                '</table>';
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    $lv_html = '<table cellpadding="3" cellspacing="0" border="0" style="width:100%;">'.
                    '<tr>'.
                        '<td><b>Responsable de FVG:</b> '.$lv_eva_resp_fvg.'</td>'.
                    '</tr>'.
                '</table>';
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    // --- Firma ---
    $pdf->Ln(15);
    $lv_html = '<table cellpadding="1" cellspacing="0" border="0" style="width:60%;">'.
                    '<tr><td style="border-top:0.6pt solid '.$lv_colorLinea.';">&nbsp;</td></tr>'.
                    '<tr><td><b>'.$lv_firma_nombre.'</b></td></tr>'.
                    '<tr><td>'.$lv_firma_cargo.'</td></tr>'.
                    '<tr><td>'.$lv_firma_usuario.'</td></tr>'.
                '</table>';
    $pdf->writeHTML($lv_html, true, false, true, false, '');

    $pdf->Output('eventoadverso.pdf', 'I');
    */

// Prevent deprecation warnings and notices from corrupting the PDF output in PHP 8.1+
error_reporting(E_ALL & ~E_DEPRECATED & ~E_USER_DEPRECATED & ~E_NOTICE);
ini_set('display_errors', '0');

// Include the main TCPDF library (search for installation path).
require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

// create new PDF document
$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'ISO-8859-1', false);

// remove default header/footer
$pdf->setPrintHeader(false);
$pdf->setPrintFooter(false);

// set default monospaced font
$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

// set margins
$pdf->SetMargins(15, 15, 15);

// set auto page breaks
$pdf->SetAutoPageBreak(TRUE, 20);

// set image scale factor
$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

// set font for modern look
$pdf->SetFont('helvetica', '', 10);

// ---------------------------------------------------------
$pdf->AddPage('P');

// Header
$lv_html = '<table border="0" cellpadding="5" style="font-family: helvetica; font-size: 9;"><tbody><tr>'
    . '<td width="80%" style="font-weight:bold; font-size:12; background-color:#C6D9F1;" align="center">Formulario de Casos de Notificación obligatoria</td>'
    . '<td width="20%" style="font-weight:unset; font-size:9; background-color:#C6D9F1;" align="right">Anexo de #SOP<br>Versión 3</td>'
    . '</tr></tbody></table>';
$pdf->writeHTML($lv_html, true, false, true, false, '');
$pdf->Ln(1);

// DATOS ADMINISTRATIVOS
$lv_html = '<table border="1" cellpadding="5" style="font-family: helvetica; font-size: 9;"><tbody>'
    . '<tr><td colspan="4" style="font-weight:bold; font-size:11; background-color:#C6D9F1;">Datos Administrativos</td></tr>'
    . '<tr>'
    . '<td>Fuente_<br>'
    . '[___] Espontáneo<br>'
    . '[___] Off-label<br>'
    . '[___] Error de medicación<br>'
    . '[___] Abuso / sobredosis<br>'
    . '[___] Estudio clínico'
    . '</td>'
    . '<td>Numero Local:<br><br><br><br>'
    . '[___] Inicial<br>'
    . '[___] Seguimiento<br><br>'
    . ' Desvío de Calidad<br><br><br>'
    . ' Reclamo de producto #:<br>(si aplica)<br>'
    . '</td>'
    . '<td>Fecha de recepcion (fecha 0):<br><br>_____/_____/________<br><br>'
    . 'Fecha de seguimiento<br>(si aplica):<br><br>_____/_____/________<br><br>'
    . 'Ciudad:<br><br>País: <b>Argentina</b>'
    . '</td>'
    . '<td>¿ Caso Grave ?<br>'
    . '[___] NO<br>'
    . '[___] SI<br>'
    //.' si es SI, inidcal el los criterio s<br>'
    //.' Criterios para Caso Grave:<br>'
    . '[___] Muerte<br>'
    . '[___] Malformación<br>'
    . '[___] Riesgo de vida<br>'
    . '[___] Discapacidad / Incapacidad<br>'
    . '[___] Hospitalización o prolonga hospitalización<br>'
    . '[___] Otro<br>'
    . '</td>'
    . '</tr>'
    . '<tr>'
    . '<td colspan="3"><b>Datos del Notificador</b> (si el notificador es el propio paciente, no completar)<br><br>'
    . 'Profesional de la salud: <span>&nbsp;</span> [___] No [___] Si. Si es si, indicar<br><br>'
    . 'Nombre:<br><br>'
    . 'Relación:<br>'
    . '</td>'
    . '<td>Vía de recepción:<br>'
    . '[___] Depto. FV<br>'
    . '[_X_] PSP<br>'
    . '[___] Depto. Calidad<br>'
    . '[___] Pagina Web<br>'
    . '[___] Otra:<br>'
    . '</td>'
    . '</tr>'
    . '</tbody></table>';
$pdf->writeHTML($lv_html, true, false, true, false, '');
$pdf->Ln(1);

// INFORMACION DEL PACIENTE
$lv_edad = '---';
$lv_fecha = '---';

if ($vew_pat->per->perbrndte instanceof DateTimeInterface) {
    $lv_fecha = $vew_pat->per->perbrndte->format('d/m/Y');
    $lv_diff = $vew_pat->per->perbrndte->diff(new DateTime());
    if ($lv_diff->y > 0) {
        $lv_edad = $lv_diff->y . ' año' . ($lv_diff->y != 1 ? 's' : '');
    } else {
        $lv_edad = $lv_diff->m . ' mes' . ($lv_diff->m != 1 ? 'es' : '');
    }
}

$lv_sexo = ($vew_pat->per->persex == 'M') ? 'Masculino' : (($vew_pat->per->persex == 'F') ? 'Femenino' : '---');

$lv_html = '<table border="1" cellpadding="5" style="font-family: helvetica; font-size: 9;"><tbody>'
    . '<tr><td colspan="5" style="font-weight:bold; font-size:11; background-color:#C6D9F1;">INFORMACION DEL PACIENTE</td></tr>'
    . '<tr>'
    . '<td align="center" width="15%">Iniciales</td>'
    . '<td align="center" width="15%">Peso</td>'
    . '<td align="center" width="20%">Fecha Nacimiento</td>'
    . '<td align="center" width="15%">Edad</td>'
    . '<td align="center" width="35%">Sexo</td>'
    . '</tr>'
    . '<tr>'
    . '<td align="center"><b>' . $vew_pat->patpro . '</b></td>'
    . '<td align="center"><b>' . ($vew_pat->patwgt > 0 ? rtrim(rtrim(number_format($vew_pat->patwgt, 2, ',', ''), '0'), ',') . ' kg' : '---') . '</b></td>'
    . '<td align="center"><b>' . $lv_fecha . '</b></td>'
    . '<td align="center"><b>' . $lv_edad . '</b></td>'
    . '<td align="center"><b>' . $lv_sexo . '</b></td>'
    . '</tr>'
    . '</tbody></table>';
$pdf->writeHTML($lv_html, true, false, true, false, '');
$pdf->Ln(1);

// Medicamento sospechado
$lv_buf_arr = [];
$lv_buf_arr = is_array($vew_evl->evlatr001) ? $vew_evl->evlatr001 : json_decode(html_entity_decode($vew_evl->evlatr001), true);
if (is_array($lv_buf_arr)) {
    $lv_buf_arr = array_change_key_case($lv_buf_arr, CASE_LOWER);
}
$lv_advobs = $lv_buf_arr['advobs'] ?? '';
$lv_med_sospechado = null;
$lv_lotes_sospechado = [];
$lv_concomitantes = [];
$lv_strtme = $lv_buf_arr['strtme'] ?? '';
$lv_endtme = $lv_buf_arr['endtme'] ?? '';

if (is_array($vew_evl->evlmat)) {
    foreach ($vew_evl->evlmat as $lv_row) {
        if (!empty($lv_row['matcod'])) {
            if ($lv_med_sospechado === null) {
                $lv_med_sospechado = $lv_row;
            }
            if (!empty($lv_row['matbchcodext'])) {
                $lv_lotes_sospechado[] = $lv_row['matbchcodext'];
            }
            if ($lv_strtme == '') {
                $lv_strtme = $lv_row['atrstrtme'] ?? $lv_row['strtme'] ?? '';
            }
            if ($lv_endtme == '') {
                $lv_endtme = $lv_row['atrendtme'] ?? $lv_row['endtme'] ?? '';
            }
        } else {
            $lv_concomitantes[] = $lv_row;
        }
    }
}

$lv_med_fecha_comienzo = '';
if ($vew_evl->evldte instanceof DateTimeInterface) {
    $lv_med_fecha_comienzo = $vew_evl->evldte->format('d/m/Y');
} elseif (!empty($vew_evl->evldte)) {
    $lv_med_fecha_comienzo = $vew_evl->evldte;
}
$lv_med_fecha_fin = $lv_med_fecha_comienzo;

if (!empty($lv_strtme)) {
    $lv_med_fecha_comienzo .= ' ' . $lv_strtme;
}
if (!empty($lv_endtme)) {
    $lv_med_fecha_fin .= ' ' . $lv_endtme;
}

$lv_med_dosis_txt = ($lv_buf_arr['matdos'] ?? '');
if (!empty($lv_buf_arr['matuntcod']) || !empty($lv_med_sospechado['matuntcod'])) {
    $lv_med_dosis_txt .= ' ' . ($lv_buf_arr['matuntcod'] ?? $lv_med_sospechado['matuntcod'] ?? '');
}
$lv_med_dosis_txt = trim($lv_med_dosis_txt);

$lv_lotes_sospechado_str = implode(',', array_unique($lv_lotes_sospechado));

$lv_html = '<table border="1" cellpadding="5" style="font-family: helvetica; font-size: 9;"><tbody>'
    . '<tr><td colspan="5" style="font-weight:bold; font-size:11; background-color:#C6D9F1;">Medicamento sospechado</td></tr>'
    . '<tr><td align="center">Nombre Genérico</td><td align="center">Nombre Comercial</td><td align="center">Dosis</td><td align="center">Frecuencia</td><td align="center">Vía de Administración</td></tr>'
    . '<tr><td></td><td><b>' . ($lv_med_sospechado['mattxt'] ?? '') . '</b></td><td><b>' . $lv_med_dosis_txt . '</b></td><td></td><td></td></tr>'
    . '<tr><td align="center">Indicación</td><td align="center">Fecha de Comienzo</td><td align="center">Fecha de Finalización</td><td align="center">Si finalizó, hubo reexposición?</td><td align="center">Lote</td></tr>'
    . '<tr><td></td><td><b>' . $lv_med_fecha_comienzo . '</b></td><td><b>' . $lv_med_fecha_fin . '</b></td><td>SI/NO - Aclarar fecha de reexposición</td><td><b>' . $lv_lotes_sospechado_str . '</b></td></tr>'
    . '</tbody></table>';
$pdf->writeHTML($lv_html, true, false, true, false, '');
$pdf->Ln(1);

// Medicación concomitante
$lv_html = '<table border="1" cellpadding="5" style="font-family: helvetica; font-size: 9;"><tbody>'
    . '<tr><td colspan="3" style="font-weight:bold; font-size:11; background-color:#C6D9F1;">Medicación concomitante</td></tr>'
    . '<tr><td align="center" width="50%">Producto</td><td align="center" width="25%">Dosis</td><td align="center" width="25%">Indicación</td></tr>';
if (count($lv_concomitantes) > 0) {
    foreach ($lv_concomitantes as $lv_row) {
        $lv_html .= '<tr><td><b>' . ($lv_row['mattxt'] ?? '') . '</b></td><td><b>' . ($lv_row['matqty'] ?? '') . '</b></td><td><b>' . ($lv_row['matcmt'] ?? '') . '</b></td></tr>';
    }
} else {
    $lv_html .= '<tr><td>-----</td><td>-----</td><td>-----</td></tr>';
}
$lv_html .= '</tbody></table>';
$pdf->writeHTML($lv_html, true, false, true, false, '');
$pdf->Ln(1);

// Antecedentes
$lv_html = '<table border="1" cellpadding="5" style="font-family: helvetica; font-size: 9;"><tbody>'
    . '<tr><td style="font-weight:bold; font-size:11; background-color:#C6D9F1;">Antecedentes clínicos relevantes</td></tr>'
    . '<tr><td> <br><br><br><br> </td></tr>'
    . '</tbody></table>';
$pdf->writeHTML($lv_html, true, false, true, false, '');
$pdf->Ln(1);

// Datos del Evento Adverso
$lv_advobs_html = nl2br(htmlspecialchars($lv_advobs));
if (empty(trim($lv_advobs))) {
    $lv_advobs_html = '&nbsp;';
} else {
    $lv_advobs_html = '<b>' . $lv_advobs_html . '</b>';
}

$lv_html = '<table border="1" cellpadding="5" style="font-family: helvetica; font-size: 9;"><tbody>'
    . '<tr><td colspan="3" style="font-weight:bold; font-size:11; background-color:#C6D9F1;">Datos del Evento Adverso</td></tr>'
    . '<tr><td colspan="3" style="height: 100px; vertical-align: top;">' . $lv_advobs_html . '</td></tr>'
    . '<tr><td align="center" width="25%">Fecha de comienzo</td><td align="center" width="50%">Resultado</td><td align="center" width="25%">Responsable de FVG</td></tr>'
    . '<tr><td><br>_____/_____/__________</td><td>'
    . '[___] Requirió tratamiento<br>'
    . '[___] Recuperado ad integrum<br>'
    . '[___] Recuperado con secuelas<br>'
    . '[___] No recuperado aun<br>'
    . '[___] Desconocido<br>'
    . '[___] Requirió o prolongo su hospitalización<br>'
    . '[___] Riesgo de vida<br>'
    . '[___] Malformación<br>'
    . '[___] Otro<br>'
    . '[___] Muerte / fecha de muerte:  _____/_____/________'
    . '</td><td><br>Florencia Amato<br>Medica<br>f.amato</td></tr>'
    . '</tbody></table>';
$pdf->writeHTML($lv_html, true, false, true, false, '');

// Clean any previous output buffer to avoid "Some data has already been output" error
if (ob_get_length()) {
    ob_clean();
}
$pdf->Output('formulario_evento_adverso.pdf', 'I');
?>
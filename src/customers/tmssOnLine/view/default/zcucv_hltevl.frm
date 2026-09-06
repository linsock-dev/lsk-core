<?php
// url del formulario
$lv_lnk = '?prg=zcucv&prm_evlcod=' . $vew_data->evlcod;

// campos requeridos 
$lv_reqflddef = array();
$lv_reqfldusrtxt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr, 'sysdocclsreqfld');
$lv_reqfldusr = ($lv_reqfldusrtxt != '' ? explode(';', $lv_reqfldusrtxt) : array());
$vew_input->setReqFields(array_merge($lv_reqflddef, $lv_reqfldusr));

// clave del documento 
$lv_dockey = $vew_data->evlcod;
// módulo y programa 
$lv_mdlcod = 'HLT';
$lv_prgcod = 'EVL';

// titulo 
$lv_title = $vew_lang->evolution;

if ($vew_actcod == 'evlinf') {
    $vew_actcod = $vew_data->evlcod != '' ? '03' : '01';
}

// Librería de estilos bootstrap 
include_once('_library.frm');

// valores x default 
$lv_evlctr = '';
$lv_strtme = '';
$lv_endtme = '';
$lv_vol = '';
$lv_prmmed = '0';
$lv_flt = '0';
$lv_bmbinf = '0';
$lv_advevt = '0';
$lv_advobs = '';

$lv_evlmat = is_array($vew_data->evlmat) ? $vew_data->evlmat : json_decode(html_entity_decode($vew_data->evlmat ?? ''), true);
if (is_array($lv_evlmat)) {
    foreach ($lv_evlmat as &$row) {
        if (isset($row['matatrval001']) && is_string($row['matatrval001'])) {
            $attr_arr = json_decode($row['matatrval001'], true);
            if (is_array($attr_arr)) {
                foreach ($attr_arr as $k => $v) {
                    $row[$k] = $v;
                    $row['atr' . $k] = $v;
                }
            }
        }
    }
    unset($row);
}

if ($vew_data->evlcod != '') {
    $lv_buf_arr = is_array($vew_data->evlatr001) ? $vew_data->evlatr001 : json_decode(html_entity_decode($vew_data->evlatr001 ?? ''), true);

    if (!is_array($lv_buf_arr)) {
        $lv_buf_arr = array();
    }
    $lv_buf_arr = array_change_key_case($lv_buf_arr, CASE_LOWER);

    $vew_data->evlinfprc = strtoupper($lv_buf_arr['evlinfprc'] ?? '');
    if ($vew_data->evlinfprc == '')
        $vew_data->evlinfprc = $vew_data->docsts == 'A' ? '1' : '0';
    $vew_data->frm = strtoupper($lv_buf_arr['dvcfrm'] ?? $lv_buf_arr['frm'] ?? '');
    $vew_data->patwgt = strtoupper($lv_buf_arr['patwgt'] ?? '');
    $vew_data->matdos = strtoupper($lv_buf_arr['matdos'] ?? '');
    $vew_data->matuntcod = strtoupper($lv_buf_arr['matuntcod'] ?? '');

    $lv_strtme = $lv_buf_arr['strtme'] ?? '';
    $lv_endtme = $lv_buf_arr['endtme'] ?? '';
    $lv_vol = $lv_buf_arr['vol'] ?? '';
    $lv_prmmed = $lv_buf_arr['prmmed'] ?? '0';
    $lv_flt = $lv_buf_arr['flt'] ?? '0';
    $lv_bmbinf = $lv_buf_arr['bmbinf'] ?? '0';
    $lv_advevt = $lv_buf_arr['advevt'] ?? '0';
    $lv_advobs = $lv_buf_arr['advobs'] ?? '';

    $lv_evlctr = $lv_buf_arr['ctr_json'] ?? '';
    if (is_array($lv_evlctr)) {
        $lv_evlctr = json_encode($lv_evlctr);
    }

    if (is_array($lv_evlmat)) {
        foreach ($lv_evlmat as $row) {
            if (!empty($row['matcod'])) {
                if ($lv_strtme == '')
                    $lv_strtme = $row['atrstrtme'] ?? $row['strtme'] ?? '';
                if ($lv_endtme == '')
                    $lv_endtme = $row['atrendtme'] ?? $row['endtme'] ?? '';
                if ($lv_vol == '')
                    $lv_vol = $row['atrvol'] ?? $row['vol'] ?? '';
                if ($lv_prmmed == '0')
                    $lv_prmmed = $row['atrprmmed'] ?? $row['prmmed'] ?? '0';
                if ($lv_flt == '0')
                    $lv_flt = $row['atrflt'] ?? $row['flt'] ?? '0';
                if ($lv_bmbinf == '0')
                    $lv_bmbinf = $row['atrbmbinf'] ?? $row['bmbinf'] ?? '0';
                if ($lv_advevt == '0')
                    $lv_advevt = $row['atradvevt'] ?? $row['advevt'] ?? '0';
                if ($lv_advobs == '')
                    $lv_advobs = $row['atradvrea'] ?? $row['advrea'] ?? $row['atradvobs'] ?? $row['advobs'] ?? '';

                if (empty($vew_data->matcod)) {
                    $vew_data->matcod = $row['matcod'];
                }
                if (empty($vew_data->mattxt)) {
                    $vew_data->mattxt = $row['mattxt'] ?? '';
                }
                if (empty($vew_data->matuntcod)) {
                    $vew_data->matuntcod = $row['matuntcod'] ?? '';
                }
                break;
            }
        }
    }
}

// Configuracion de botones
$vew_tbl['new'] = array('pos' => 'L','per' => false);
$vew_tbl['cpy'] = array('pos' => 'D','per' => false);
$vew_tbl['clsL'] = array('pos' => 'L', 'per' => ($vew_data->hhcc == 'X'), 'ttl' => $vew_lang->close, 'id' => 'btncls', 'icn' => 'fas fa-arrow-left', 'css' => 'btn navbar-btn tmss-navbar-btn arrow-left', 'acc' => $lv_sec . '_fncbckext();');
$vew_tbl['prnR'] = array('pos' => 'R','per' => $vew_sec->hasPermission('HLT', 'EVL', '05') && $vew_data->docsts == 'A', 'id' => 'btnprn');
$vew_tbl['sveL'] = array('pos' => 'L','per' => !$vew_readonly, 'acc' => $lv_sec . '_fnc({action: ' . chr(39) . 'evlinf00' . chr(39) . '});');
$vew_tbl['sveR'] = array('pos' => 'R','per' => !$vew_readonly, 'acc' => $lv_sec . '_fnc({action: ' . chr(39) . 'evlinf00' . chr(39) . '});');
$vew_tbl['modL'] = array('pos' => 'L', 'per' => ($vew_sec->hasPermission('HLT', 'EVL', '02') && $vew_actcod == '03' && $vew_data->evlinfprc == '1'), 'ttl' => $vew_lang->modify, 'id' => '', 'icn' => 'fas fa-pencil-alt', 'css' => 'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'acc' => $lv_sec . '_fnc({action: ' . chr(39) . '02' . chr(39) . '});');
$vew_tbl['del'] = array('pos' => 'D','per' => $vew_sec->hasPermission('HLT', 'EVL', '04') && $vew_data->evlcod != '', 'acc' => $lv_sec . '_fnc({action: ' . chr(39) . 'evlinfx4' . chr(39) . '});');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $vew_lang->evolution; ?>">
    <style>
        .htContextMenu {
            z-index: 10000 !important;
        }
    </style>
    <?php include('grldocfrmtlb.frm'); ?>

    <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm"
        enctype="multipart/form-data">
        <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
        <input type="hidden" id="sysdocclscod" name="sysdocclscod" value="<?= $vew_data->sysdoccls->sysdocclscod; ?>">
        <input type="hidden" id="spccod" name="spccod" value="<?= $vew_data->spccod; ?>">
        <input type="hidden" id="spctxt" name="spctxt" value="<?= $vew_data->spctxt; ?>">
        <input type="hidden" id="patcod" name="patcod" value="<?= $vew_data->patcod; ?>">
        <input type="hidden" id="pattxt" name="pattxt" value="<?= $vew_data->pattxt; ?>">
        <input type="hidden" id="prscod" name="prscod" value="<?= $vew_data->prscod; ?>">
        <input type="hidden" id="prstxt" name="prstxt" value="<?= $vew_data->prstxt; ?>">
        <input type="hidden" id="plnid" name="plnid" value="<?= $vew_data->plnid; ?>">
        <input type="hidden" id="plndteid" name="plndteid" value="<?= $vew_data->plndteid; ?>">
        <input type="hidden" id="evlcmt" name="evlcmt" value="<?= $vew_data->evlcmt; ?>">
        <input type="hidden" id="evlcod" name="evlcod" value="<?= $vew_data->evlcod; ?>">
        <input type="hidden" id="delcod" name="delcod" value="<?= $vew_data->delcod; ?>">
        <input type="hidden" id="evlmatdel" name="evlmatdel" value="">
        <input type="hidden" id="tmpmatbchcod" name="tmpmatbchcod" data-fldnme="matbchcod" value="">
        <input type="hidden" id="tmpmatbchcodext" name="tmpmatbchcodext" data-fldnme="matbchcodext" value="">
        <input type="hidden" id="tmpmatbchduedte" name="tmpmatbchduedte" data-fldnme="matbchduedte" value="">
        <input type="hidden" id="ajax" name="ajax" value="0">

        <input type="hidden" id="flesrctyp" name="flesrctyp" value="<?= 'HLT_EVL'; ?>">
        <input type="hidden" id="patchgdte" name="patchgdte" value="<?= $vew_data->patchgdte; ?>">
        <div class="container-fluid" role="tabpanel">
            <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
                <li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab"
                        data-toggle="tab"><?= $vew_lang->general; ?></a></li>
                <li class="pull-right">
                    <h4># <strong><?= $vew_data->evlcod; ?></strong></h4>
                </li>
            </ul>
            <div class="tab-content tmss-tab-content">
                <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
                    <div class="row">

                        <div class="card">
                            <div class="card-header">
                                <?php
                                $lv_sex_icon = [
                                    'M' => ' <i class="fas fa-mars text-info" title="Masculino" style="margin-left: 8px;"></i>',
                                    'F' => ' <i class="fas fa-venus text-danger" title="Femenino" style="margin-left: 8px;"></i>',
                                    'X' => ' <i class="fas fa-transgender" title="No binario" style="margin-left: 8px; color: #9c27b0;"></i>'
                                ][strtoupper(trim($vew_data->patsex ?? ''))] ?? '';
                                ?>
                                <div class="card-title"><?= strtoupper($vew_data->pattxt) . $lv_sex_icon; ?></div>
                            </div>
                            <div class="card-body tmss-card-body-edit">
                                <input type="hidden" name="patsex" id="patsex" value="<?= $vew_data->patsex; ?>">
                                <?php
                                echo vew_boot($lv_col210, array('label' => $vew_lang->diagnostic, 'input' => gethtml('evldia', 'evldia', $vew_data->evldia, $lv_always_disabled)));
                                echo vew_boot($lv_col222222, array(
                                    'label1' => $vew_lang->weight,
                                    'input1' => gethtml('patwgt', 'docnum0603', $vew_data->patwgt, $lv_default),
                                    'label2' => 'kg'
                                ));
                                ?>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Datos de evolucion</div>
                            </div>
                            <div class="card-body tmss-card-body-edit">
                                <?php
                                echo vew_boot($lv_col2424, array(
                                    'label1' => 'Fecha de la infusi&oacute;n',
                                    'input1' => gethtml('evldte', 'docdte', $vew_data->evldte, $lv_default),
                                    'label2' => 'Se realiz&oacute; la infusi&oacute;n',
                                    'input2' => gethtml('evlinfprc', 'checkbox', $vew_data->evlinfprc, $lv_default)
                                ));
                                ?>
                            </div>
                        </div>

                        <div class="card tmss-hot-ttl">
                            <div class="card-header">
                                <div class="card-title">
                                    <span> Controles </span>
                                </div>
                            </div>
                        </div>
                        <div id="ctrhot" name="ctrhot"></div>


                        <div id="evlyesinf_div">
                            <textarea id="evlmat" name="evlmat" class="hidden"></textarea>

                            <div class="card treatment-card">
                                <div class="card-header">
                                    <div class="card-title">Tratamiento</div>
                                </div>
                                <div class="card-body tmss-card-body-edit">
                                    <?php
                                    // Row 1: Medicamento (ampliado, unidad oculta)
                                    echo vew_boot($lv_col210, array(
                                        'label' => 'Medicamento',
                                        'input' => vew_boot(array('style' => 'search', 'readonly' => $vew_readonly), array('input' => gethtml('mattxt', 'typeahead', $vew_data->mattxt, $lv_default))) . gethtml('matcod', 'hidden', $vew_data->matcod) . gethtml('matuntcod', 'hidden', $vew_data->matuntcod)
                                    ));
                                    // Row 2: Dosis & Vol. (ml)
                                    echo vew_boot($lv_col2424, array(
                                        'label1' => 'Dosis',
                                        'input1' => gethtml('matdos', 'docnum0802', $vew_data->matdos, $lv_default),
                                        'label2' => 'Vol. (ml)',
                                        'input2' => gethtml('vol', 'docnum0802', $lv_vol, $lv_default)
                                    ));

                                    // Row 3: Inicio & Fin
                                    echo vew_boot($lv_col2424, array(
                                        'label1' => 'Hs. Inicio',
                                        'input1' => gethtml('strtme', 'doccmt1x10', $lv_strtme, $lv_default),
                                        'label2' => 'Hs. Fin',
                                        'input2' => gethtml('endtme', 'doccmt1x10', $lv_endtme, $lv_default)
                                    ));

                                    // Row 4: Premed., Filtro, Bomba
                                    echo vew_boot($lv_col222222, array(
                                        'label1' => 'Premed.',
                                        'input1' => gethtml('prmmed', 'checkbox', $lv_prmmed, $lv_default),
                                        'label2' => 'Filtro',
                                        'input2' => gethtml('flt', 'checkbox', $lv_flt, $lv_default),
                                        'label3' => 'Bomba',
                                        'input3' => gethtml('bmbinf', 'checkbox', $lv_bmbinf, $lv_default)
                                    ));
                                    ?>
                                    <hr>
                                    <h4 class="lotes-title">Lote/s de Medicamento</h4>
                                    <div id="mathot" name="mathot"></div>
                                </div>
                            </div>

                            <div id="prmmed_card" class="hidden">
                                <div class="card tmss-hot-ttl">
                                    <div class="card-header">
                                        <div class="card-title">
                                            <span> Premedicaci&oacute;n </span>
                                        </div>
                                    </div>
                                </div>
                                <div id="prmhot" name="prmhot" style="margin-bottom: 15px;"></div>
                            </div>
                            <div class="card" id="advevt_div">
                                <div class="card-header">
                                    <div class="card-title">Eventos Adversos</div>
                                </div>
                                <div class="card-body tmss-card-body-edit">
                                    <?php
                                    echo vew_boot(array($lv_colsm210, $lv_colxs48), array('label' => 'Ocurri&oacute; un <br> evento adverso', 'input' => gethtml('advevt', 'checkbox', $lv_advevt, $lv_default)));
                                    echo vew_boot($lv_col210, array('label' => 'Observaciones', 'input' => gethtml('advobs', 'doccmt2x50', $lv_advobs, $lv_default)));
                                    ?>
                                </div>
                            </div>
                        </div><!-- /row -->

                    </div> <!-- /_tab001 -->
                </div> <!-- /tab-content -->
            </div> <!-- /container-fluid -->

            <div class="tmss-mob-btn">
                <br /><br /><br />
                <br /><br /><br />
            </div>

    </form>
    <script>
        var lv_fldrec = <?= strtolower(json_encode($vew_data->fldrec)); ?>;
        <?php
        $initial_evlmat = [];
        $initial_evlprm = [];
        if (is_array($lv_evlmat)) {
            foreach ($lv_evlmat as $lo_matrow) {
                if (!empty($lo_matrow['matcod'])) {
                    $initial_evlmat[] = [
                        'evlmatcod' => $lo_matrow['evlmatcod'] ?? '',
                        'matcod' => $lo_matrow['matcod'] ?? '',
                        'mattxt' => $lo_matrow['mattxt'] ?? '',
                        'matqty' => $lo_matrow['matqty'] ?? '',
                        'matuntcod' => $lo_matrow['matuntcod'] ?? '',
                        'matbchcodext' => $lo_matrow['matbchcodext'] ?? $lo_matrow['matbtchcod'] ?? '',
                        'matbchduedte' => !empty($lo_matrow['matbchduedte']) ? (is_a($lo_matrow['matbchduedte'], 'DateTime') ? date_format($lo_matrow['matbchduedte'], 'd/m/Y') : (is_array($lo_matrow['matbchduedte']) && !empty($lo_matrow['matbchduedte']['date']) ? date_format(date_create($lo_matrow['matbchduedte']['date']), 'd/m/Y') : (is_string($lo_matrow['matbchduedte']) ? (preg_match('/^\d{2}\/\d{2}\/\d{4}$/', $lo_matrow['matbchduedte']) ? $lo_matrow['matbchduedte'] : (($lv_date = date_create($lo_matrow['matbchduedte'])) ? date_format($lv_date, 'd/m/Y') : $lo_matrow['matbchduedte'])) : ''))) : '',
                    ];
                } else {
                    $initial_evlprm[] = [
                        'evlmatcod' => $lo_matrow['evlmatcod'] ?? '',
                        'prod' => $lo_matrow['mattxt'] ?? '',
                        'dosis' => $lo_matrow['matqty'] ?? '',
                        'ind' => $lo_matrow['matcmt'] ?? ''
                    ];
                }
            }
        }
        ?>
        var <?= $lv_sec; ?>_hotctr_renderer = function (instance, td, row, col, prop, value, cellProperties) {
            Handsontable.renderers.TextRenderer.apply(this, arguments);
            td.style.backgroundColor = '#<?= ($vew_readonly ? 'F1F1F1' : 'FFFFFF'); ?>';
        };
        var <?= $lv_sec; ?>_hotctrset = {
            height: 196,
            stretchH: "all",
            autoColumnSize: true,
            autoWrapRow: false,
            rowHeaders: false,
            minSpareRows: 0,
            licenseKey: gv_handsontable_lc,
            colHeaders: ["-", "Previo al Comienzo", "Hora 1", "Hora 2", "Al finalizar"],
            columns: [
                { type: "text", data: "ctrtxt", renderer: <?= $lv_sec; ?>_hotctr_renderer, readOnly: true },
                { type: "text", data: "ctrprv", renderer: <?= $lv_sec; ?>_hotctr_renderer <?= ($vew_readonly ? ', readOnly: true ' : ''); ?> },
                { type: "text", data: "ctrhs1", renderer: <?= $lv_sec; ?>_hotctr_renderer <?= ($vew_readonly ? ', readOnly: true ' : ''); ?> },
                { type: "text", data: "ctrhs2", renderer: <?= $lv_sec; ?>_hotctr_renderer <?= ($vew_readonly ? ', readOnly: true ' : ''); ?> },
                { type: "text", data: "ctrend", renderer: <?= $lv_sec; ?>_hotctr_renderer <?= ($vew_readonly ? ', readOnly: true ' : ''); ?> }
            ]
        };
        var <?= $lv_sec; ?>_hotctr;

        var <?= $lv_sec; ?>_hotprm_renderer = function (instance, td, row, col, prop, value, cellProperties) {
            Handsontable.renderers.TextRenderer.apply(this, arguments);
            td.style.backgroundColor = '#<?= ($vew_readonly ? 'F1F1F1' : 'FFFFFF'); ?>';
        };
        var <?= $lv_sec; ?>_hotprmset = {
            height: 150,
            stretchH: "all",
            autoColumnSize: true,
            <?= ($vew_readonly ? '' : 'contextMenu: ["remove_row"],') ?>
            autoWrapRow: false,
            rowHeaders: true,
            minSpareRows: <?= ($vew_readonly ? '0' : '1') ?>,
            licenseKey: gv_handsontable_lc,
            colHeaders: ["Producto", "Dosis", "Indicaci&oacute;n"],
            columns: [
                { type: "text", data: "prod", renderer: <?= $lv_sec; ?>_hotprm_renderer <?= ($vew_readonly ? ', readOnly: true ' : ''); ?> },
                { type: "text", data: "dosis", renderer: <?= $lv_sec; ?>_hotprm_renderer <?= ($vew_readonly ? ', readOnly: true ' : ''); ?> },
                { type: "text", data: "ind", renderer: <?= $lv_sec; ?>_hotprm_renderer <?= ($vew_readonly ? ', readOnly: true ' : ''); ?> }
            ],
            beforeRemoveRow: function (index, amount) {
                var lv_dat = <?= $lv_sec; ?>_hotprm.getSourceData();
            var lvEvlMatDel = $("#<?= $lv_sec; ?> #evlmatdel").val();
            var lvEvlMatDelLst = lvEvlMatDel ? lvEvlMatDel.split(';') : [];
            for(var i = index; i<index + amount; i++) {
            if (lv_dat[i] && lv_dat[i]["evlmatcod"]) {
                lvEvlMatDelLst.push(lv_dat[i]["evlmatcod"]);
            }
        }
        $("#<?= $lv_sec; ?> #evlmatdel").val(lvEvlMatDelLst.join(';'));
            }
        };
        var <?= $lv_sec; ?>_hotprm;

        var <?= $lv_sec; ?>_hotmat_renderer = function (instance, td, row, col, prop, value, cellProperties) {
            if (prop == "icn") {
                $(td).empty();
                <?php if (!$vew_readonly) { ?>
                    var lv_btn = "<div class='text-center'><a href='#' onclick='<?= $lv_sec; ?>_findBatch(" + row + ");' ><span class='fas fa-search'></span></a></div>";
                    $(td).append(lv_btn);
                <?php } ?>
                td.style.backgroundColor = '#<?= ($vew_readonly ? 'F1F1F1' : 'FFFFFF'); ?>';
            } else {
                Handsontable.renderers.TextRenderer.apply(this, arguments);
                if (prop == "matbchduedte") {
                    td.style.backgroundColor = '#F1F1F1';
                    cellProperties.readOnly = true;
                } else {
                    td.style.backgroundColor = '#<?= ($vew_readonly ? 'F1F1F1' : 'FFFFFF'); ?>';
                }
            }
        };
        var <?= $lv_sec; ?>_hotmat_chg = [];
        var <?= $lv_sec; ?>_hotmatset = {
            height: 200,
            stretchH: "all",
            autoColumnSize: true,
            <?= ($vew_readonly ? '' : 'contextMenu: ["remove_row"],') ?>
            autoWrapRow: false,
            rowHeaders: true,
            minSpareRows: <?= ($vew_readonly ? '0' : '1') ?>,
            licenseKey: gv_handsontable_lc,
            colHeaders: ["Viales", "Lote", "", "Vencimiento"],
            columns: [
                { type: "numeric", data: "matqty", width: 100, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly ? ', readOnly: true' : ''); ?>, numericFormat: { pattern: "0,0.00", culture: "es-AR" } },
                {
                    type: "autocomplete", data: "matbchcodext", renderer: <?= $lv_sec; ?>_hotmat_renderer, <?= ($vew_readonly ? 'readOnly: true, ' : ''); ?>
                    source: function (query, process) {
                        var lv_matcod = $("#<?= $lv_sec; ?> #matcod").val();
                        if (!lv_matcod || lv_matcod === "") {
                            process([]);
                            return;
                        }
                        $.ajax({
                            url: "?prg=stkmatstk&act=28",
                            type: "POST",
                            dataType: "json",
                            data: {
                                prm_matcodext: lv_matcod,
                                stkobjtyp: "HLT_PAT",
                                stkobjcod: "<?= $vew_data->patcod; ?>"
                            },
                            success: function (response) {
                                var lv_dat = [];
                                <?= $lv_sec; ?>_hotmat_chg = [];
                                for (var i = 0; i < response.data.length; i++) {
                                    if (response.data[i]["matbchcodext"]) {
                                        var formattedDte = response.data[i]["matbchduedte"];
                                        if (typeof formattedDte === 'object' && formattedDte !== null && formattedDte.date) {
                                            var d = new Date(formattedDte.date);
                                            var dd = String(d.getDate()).padStart(2, '0');
                                            var mm = String(d.getMonth() + 1).padStart(2, '0');
                                            var yyyy = d.getFullYear();
                                            formattedDte = dd + '/' + mm + '/' + yyyy;
                                        }
                                        <?= $lv_sec; ?>_hotmat_chg.push({
                                            matbchcodext: response.data[i]["matbchcodext"],
                                            matbchduedte: formattedDte
                                        });
                                        if (!lv_dat.includes(response.data[i]["matbchcodext"])) {
                                            lv_dat.push(response.data[i]["matbchcodext"]);
                                        }
                                    }
                                }
                                process(lv_dat);
                            }
                        });
                    },
                    strict: true
                },
                { type: "text", data: "icn", width: 18, renderer: <?= $lv_sec; ?>_hotmat_renderer, editor: false, readOnly: true },
                { type: "text", data: "matbchduedte", width: 120, renderer: <?= $lv_sec; ?>_hotmat_renderer, readOnly: true }
            ],
            beforeChange: function (changes, source) {
                if (source == "edit" && changes[0][1] == "matbchcodext") {
                    var lv_value = changes[0][3];
                    for (var i = 0; i < <?= $lv_sec; ?>_hotmat_chg.length; i++) {
                        if (<?= $lv_sec; ?>_hotmat_chg[i].matbchcodext == lv_value) {
                            changes.push([changes[0][0], "matbchduedte", "", String(<?= $lv_sec; ?>_hotmat_chg[i].matbchduedte)]);
                            break;
                        }
                    }
                }
            },
            beforeRemoveRow: function (index, amount) {
                var lv_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
            var lvEvlMatDel = $("#<?= $lv_sec; ?> #evlmatdel").val();
            var lvEvlMatDelLst = lvEvlMatDel ? lvEvlMatDel.split(';') : [];
            for(var i = index; i<index + amount; i++) {
            if (lv_dat[i] && lv_dat[i]["evlmatcod"]) {
                lvEvlMatDelLst.push(lv_dat[i]["evlmatcod"]);
            }
        }
        $("#<?= $lv_sec; ?> #evlmatdel").val(lvEvlMatDelLst.join(';'));
            }
        };
        var <?= $lv_sec; ?>_hotmat;

        $(function () {
            // Load Handsontables
            tmssLoadScript("handsontable", function () {
                <?= $lv_sec; ?>_hotctr = new Handsontable($("#<?= $lv_sec; ?> #ctrhot")[0], <?= $lv_sec; ?>_hotctrset);
                var ctrDataObj = (<?= !empty($lv_evlctr) ? html_entity_decode($lv_evlctr) : '{}'; ?>) || {};
                <?= $lv_sec; ?>_hotctr.loadData([
                    { ctrtxt: "Hora", ctrprv: ctrDataObj.pretme || '', ctrhs1: ctrDataObj.hr1tme || '', ctrhs2: ctrDataObj.hr2tme || '', ctrend: ctrDataObj.fintme || '' },
                    { ctrtxt: "T.A.", ctrprv: ctrDataObj.prebpr || '', ctrhs1: ctrDataObj.hr1bpr || '', ctrhs2: ctrDataObj.hr2bpr || '', ctrend: ctrDataObj.finbpr || '' },
                    { ctrtxt: "F.C.", ctrprv: ctrDataObj.prehrt || '', ctrhs1: ctrDataObj.hr1hrt || '', ctrhs2: ctrDataObj.hr2hrt || '', ctrend: ctrDataObj.finhrt || '' },
                    { ctrtxt: "Frec.Resp.", ctrprv: ctrDataObj.prersp || '', ctrhs1: ctrDataObj.hr1rsp || '', ctrhs2: ctrDataObj.hr2rsp || '', ctrend: ctrDataObj.finrsp || '' },
                    { ctrtxt: "SO2", ctrprv: ctrDataObj.preso2 || '', ctrhs1: ctrDataObj.hr1so2 || '', ctrhs2: ctrDataObj.hr2so2 || '', ctrend: ctrDataObj.finso2 || '' },
                    { ctrtxt: "Temperatura", ctrprv: ctrDataObj.pretmp || '', ctrhs1: ctrDataObj.hr1tmp || '', ctrhs2: ctrDataObj.hr2tmp || '', ctrend: ctrDataObj.fintmp || '' },
                    { ctrtxt: "Observaciones", ctrprv: ctrDataObj.preobs || '', ctrhs1: ctrDataObj.hr1obs || '', ctrhs2: ctrDataObj.hr2obs || '', ctrend: ctrDataObj.finobs || '' }
                ]);
                <?= $lv_sec; ?>_hotctr.render();

                <?= $lv_sec; ?>_hotprm = new Handsontable($("#<?= $lv_sec; ?> #prmhot")[0], <?= $lv_sec; ?>_hotprmset);
                <?= $lv_sec; ?>_hotprm.loadData(<?= json_encode($initial_evlprm); ?>);
                <?= $lv_sec; ?>_hotprm.render();

                <?= $lv_sec; ?>_hotmat = new Handsontable($("#<?= $lv_sec; ?> #mathot")[0], <?= $lv_sec; ?>_hotmatset);
                <?= $lv_sec; ?>_hotmat.loadData(<?= json_encode($initial_evlmat); ?>);
                <?= $lv_sec; ?>_hotmat.render();
            });

            // Toggle checkbox setup
            tmssLoadScript("toggle", function () {
                $("#<?= $lv_sec; ?> :checkbox").each(function () {
                    $(this).bootstrapToggle({ onstyle: "success", offstyle: "default", on: "Si", off: "No", size: "small" });
                    <?php if ($vew_readonly) { ?>
                        $(this).bootstrapToggle('disable')
                    <?php } ?>
                    $(this).trigger("change");
                });
            });

            // Checkbox change handlers for layout show/hide
            $("#<?= $lv_sec; ?> #evlinfprc").on("change", function () {
                if ($(this).is(":checked") || ($(this).attr("type") === "hidden" && $(this).val() === "1") || <?= $vew_readonly ? ($vew_data->evlinfprc == '1' ? 'true' : 'false') : 'false' ?>) {
                    $("#<?= $lv_sec; ?> #evlyesinf_div").removeClass("hidden");
                    if (window["<?= $lv_sec; ?>_hotctr"]) { <?= $lv_sec; ?>_hotctr.render(); }
                    if (window["<?= $lv_sec; ?>_hotmat"]) { <?= $lv_sec; ?>_hotmat.render(); }
                } else {
                    $("#<?= $lv_sec; ?> #evlyesinf_div").addClass("hidden");
                }
            });

            $("#<?= $lv_sec; ?> #prmmed").on("change", function () {
                if ($(this).is(":checked") || <?= $vew_readonly ? ($lv_prmmed == '1' ? 'true' : 'false') : 'false' ?>) {
                    $("#<?= $lv_sec; ?> #prmmed_card").removeClass("hidden");
                    if (window["<?= $lv_sec; ?>_hotprm"]) { <?= $lv_sec; ?>_hotprm.render(); }
                } else {
                    $("#<?= $lv_sec; ?> #prmmed_card").addClass("hidden");
                }
            });

            // Typeahead de material
            var lo_get = { "fldsec": "<?= $lv_sec; ?>", "fldflt": { "m.docsts": "A" }, "fldasg": { "matcod": "matcod", "mattxt": "mattxt", "matuntcod": "matuntcod" } };
            tmssTypeahead($("#<?= $lv_sec; ?> #mattxt"), "stkmat", lo_get);

            $("#<?= $lv_sec; ?> #matcod").on("change", function () {
                if (window["<?= $lv_sec; ?>_hotmat"]) {
                    var lo_matdat = <?= $lv_sec; ?>_hotmat.getSourceData();
                    var lvEvlMatDel = $("#<?= $lv_sec; ?> #evlmatdel").val();
                    var lvEvlMatDelLst = lvEvlMatDel ? lvEvlMatDel.split(';').filter(Boolean) : [];
                    lo_matdat.forEach(function (lo_row) {
                        if (lo_row && lo_row.evlmatcod) {
                            lvEvlMatDelLst.push(lo_row.evlmatcod);
                        }
                    });
                    $("#<?= $lv_sec; ?> #evlmatdel").val(lvEvlMatDelLst.join(';'));
                    <?= $lv_sec; ?>_hotmat.loadData([]);
                }
            });

            $("#<?= $lv_sec; ?> #evlinfprc").trigger("change");
            $("#<?= $lv_sec; ?> #prmmed").trigger("change");
        });

        function <?= $lv_sec; ?>_removeRow(e) {
            $(e).parent().parent().remove();
        }

        function <?= $lv_sec; ?>_removeRowEdit(e, id) {
            var lvEvlMatDel = $("#<?= $lv_sec; ?> #evlmatdel").val();
            var lvEvlMatDelLst = lvEvlMatDel ? lvEvlMatDel.split(';') : [];
            lvEvlMatDelLst.push(id);
            $("#<?= $lv_sec; ?> #evlmatdel").val(lvEvlMatDelLst.join(';'));
            $(e).parent().parent().remove();
        }

        // BUSCAR LOTE
        function <?= $lv_sec; ?>_findBatch(lv_row) {
            var lv_matcod = $("#<?= $lv_sec; ?> #matcod").val();
            if (lv_matcod == "" || lv_matcod == undefined) {
                toastr.warning("Debe seleccionar un material.");
            } else {
                $("#<?= $lv_sec; ?> #tmpmatbchcod, #<?= $lv_sec; ?> #tmpmatbchcodext, #<?= $lv_sec; ?> #tmpmatbchduedte").data("row", lv_row);
                tmssPopup("Buscar Lote", "?prg=stkmatbch&prm_vewcod=VEW_STK_MAT_BCH&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[tmpmatbchcod:matbchcod],[tmpmatbchcodext:matbchcodext],[tmpmatbchduedte:matbchduedtecnv]&prm_fldflt=[b.matcod:" + lv_matcod + "]");
            }
        }
        $("#<?= $lv_sec; ?> #tmpmatbchcod, #<?= $lv_sec; ?> #tmpmatbchcodext, #<?= $lv_sec; ?> #tmpmatbchduedte").on("change", function (e) { 
            <?= $lv_sec; ?>_hotmat.setDataAtRowProp($(this).data("row"), $(this).data("fldnme"), $(this).prop("value"));
        });

        function <?= $lv_sec; ?>_fncbckext(lp_prm) {
            if (lp_prm['errtyp'] == 'E' && lp_prm['errtxt'] != '') { toastr.warning(lp_prm['errtxt']); return false; }
            if (gv_<?= $lv_sec; ?>_last_action == "evlinf00" || gv_<?= $lv_sec; ?>_last_action == "00") {
                if (lp_prm['errtyp'] == 'E') { toastr.warning(lp_prm['errtxt']); return false; }
                toastr.success(lp_prm['errtxt'] != '' ? lp_prm['errtxt'] : 'Evoluci&oacute;n grabada correctamente.');
                gv_<?= $lv_sec; ?>_last_action = "02";
                tmssCallProcess("?prg=<?= $vew_data->endpoint; ?>&act=02", { evlcod: lp_prm.evlcod }, <?= $lv_sec; ?>_fncbckext);
                return false;
            }
            if (gv_<?= $lv_sec; ?>_last_action == "evlinf04" || gv_<?= $lv_sec; ?>_last_action == "04") {
                if (lp_prm['errtyp'] == 'E') { toastr.warning(lp_prm['errtxt']); return false; }
                toastr.warning(lp_prm['errtxt'] != '' ? lp_prm['errtxt'] : 'Evoluci&oacute;n borrada correctamente.');
            }
            if (gv_<?= $lv_sec; ?>_last_action == "02") {
                $("#<?= $lv_sec; ?>").replaceWith(lp_prm);
                return false;
            }
            $.each(BootstrapDialog.dialogs, function (id, dialog) {
                if (dialog.getModalBody().find("section:first").prop("id") == "<?= $lv_sec; ?>") {
                    dialog.close();
                }
            });
            tmssTabSecCls($("#<?= $lv_sec; ?>"));
        }

        function <?= $lv_sec; ?>_fncext(lp_prm) {
            $("#<?= $lv_sec; ?> #tmss_actcod").val(lp_prm["action"]);

            if (lp_prm["action"] == "evlinfx4" || lp_prm["action"] == "04") {
                BootstrapDialog.confirm({
                    title: 'Borrar Evoluci&oacute;n',
                    message: '&iquest;Desea borrar el documento?',
                    type: BootstrapDialog.TYPE_WARNING,
                    callback: function (result) {
                        if (result) { <?= $lv_sec; ?>_fnc({ action: "evlinf04" }); }
                    }
                });
                return false;
            }

            if (lp_prm["action"] == "evlinf00" || lp_prm["action"] == "00") {
                var lv_err = 0;
                var lv_arr = [];
                var lv_advevt = $("#<?= $lv_sec; ?> #advevt").prop("checked") ? "1" : "0";
                var lv_advobs = $("#<?= $lv_sec; ?> #advobs").val();

                $("#<?= $lv_sec; ?> #advobs").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
                if (lv_advevt == "1" && lv_advobs == "") {
                    $("#<?= $lv_sec; ?> #advobs").parentsUntil(".tmss-form-group").parent().addClass("has-error");
                    lv_err++;
                }
                $("#<?= $lv_sec; ?> #patwgt").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
                if ($("#<?= $lv_sec; ?> #patwgt").val() == "" && lv_fldrec.includes("patwgt")) {
                    $("#<?= $lv_sec; ?> #patwgt").parentsUntil(".tmss-form-group").parent().addClass("has-error");
                    lv_err++;
                }

                if (($("#<?= $lv_sec; ?> #matdos").val() == "" || $("#<?= $lv_sec; ?> #matdos").val() == "0") && lv_fldrec.includes("matdos")) {
                    toastr.warning("Falta indicar Dosis total en el tratamiento.");
                    lv_err++;
                }

                var lv_totalqty = 0;
                var lv_totalmedcnt = 0;
                if (window["<?= $lv_sec; ?>_hotmat"]) {
                    var lo_matdat = <?= $lv_sec; ?>_hotmat.getSourceData();
                    lo_matdat.forEach(function (lo_row) {
                        if (lo_row.matbchcodext && lo_row.matbchcodext.trim() !== '') {
                            lv_totalmedcnt++;
                            var lv_qty = parseFloat(lo_row.matqty) || 0;
                            lv_totalqty += lv_qty;
                            lv_arr.push({
                                "evlmatcod": lo_row.evlmatcod || "",
                                "matcod": $("#<?= $lv_sec; ?> #matcod").val(),
                                "mattxt": $("#<?= $lv_sec; ?> #mattxt").val(),
                                "matqty": lv_qty,
                                "matcmt": "",
                                "matbtchcod": lo_row.matbchcodext || "",
                                "matbchcodext": lo_row.matbchcodext || "",
                                "matuntcod": $("#<?= $lv_sec; ?> #matuntcod").val() || "UN",
                                "matbchduedte": lo_row.matbchduedte || ""
                            });
                        }
                    });

                    var lv_evlmatdel = $("#<?= $lv_sec; ?> #evlmatdel").val();
                    if (lv_evlmatdel && lv_evlmatdel !== '') {
                        lv_evlmatdel.split(';').forEach(function (lv_id) {
                            if (lv_id && lv_id.trim() !== '') {
                                lv_arr.push({
                                    "evlmatcod": lv_id,
                                    "deleted": "X"
                                });
                            }
                        });
                    }
                }

                if (window["<?= $lv_sec; ?>_hotprm"]) {
                    var lo_prmdat = <?= $lv_sec; ?>_hotprm.getSourceData();
                    lo_prmdat.forEach(function (lo_row) {
                        if ((lo_row.prod && lo_row.prod.trim() !== '') || (lo_row.dosis && lo_row.dosis.trim() !== '') || (lo_row.ind && lo_row.ind.trim() !== '')) {
                            lv_arr.push({
                                "evlmatcod": lo_row.evlmatcod || "",
                                "matcod": "",
                                "mattxt": lo_row.prod || "",
                                "matqty": lo_row.dosis || "",
                                "matcmt": lo_row.ind || "",
                                "matbtchcod": ""
                            });
                        }
                    });
                }

                var lv_is_checked = $("#<?= $lv_sec; ?>_frm #evlinfprc").is(":checked") || ($("#<?= $lv_sec; ?>_frm #evlinfprc").attr("type") === "hidden" && $("#<?= $lv_sec; ?>_frm #evlinfprc").val() === "1");
                if (lv_is_checked && (($("#<?= $lv_sec; ?> #matcod").val() !== '' && lv_totalmedcnt == 0) || (lv_totalmedcnt == 0 && lv_fldrec.includes("tbldat")))) {
                    toastr.warning("Debe agregar al menos un lote de medicamento en los tratamientos.");
                    lv_err++;
                }

                var lo_mapped_fields = ['evlcod', 'patcod', 'prscod', 'spccod', 'evldte', 'evlcmt', 'plnid', 'plndteid', 'sysdocclscod', 'delcod'];
                var lo_materials_fields = ['matcod', 'mattxt', 'matuntcod', 'evlmatdel', 'tmpmatbchcod', 'tmpmatbchcodext', 'tmpmatbchduedte'];

                var lo_frmobj = {};
                var lo_dat = new FormData();
                var lv_frmarr = $("#<?= $lv_sec; ?>_frm").serializeArray();
                for (var i = 0; i < lv_frmarr.length; i++) {
                    var lv_name = lv_frmarr[i].name;
                    var lv_val = lv_frmarr[i].value;
                    if (lo_mapped_fields.includes(lv_name)) {
                        lo_dat.append(lv_name, lv_val);
                    } else if (!lo_materials_fields.includes(lv_name)) {
                        lo_frmobj[lv_name] = lv_val;
                    }
                }
                lo_frmobj['evlinfprc'] = lv_is_checked ? "1" : "0";
                lo_frmobj['prmmed'] = $("#<?= $lv_sec; ?> #prmmed").is(":checked") ? "1" : "0";
                lo_frmobj['flt'] = $("#<?= $lv_sec; ?> #flt").is(":checked") ? "1" : "0";
                lo_frmobj['bmbinf'] = $("#<?= $lv_sec; ?> #bmbinf").is(":checked") ? "1" : "0";
                lo_frmobj['advevt'] = $("#<?= $lv_sec; ?> #advevt").is(":checked") ? "1" : "0";

                lo_frmobj['ctr_json'] = {};
                if (window["<?= $lv_sec; ?>_hotctr"]) {
                    var lo_ctrdat = <?= $lv_sec; ?>_hotctr.getSourceData();
                    if (lo_ctrdat && lo_ctrdat.length >= 7) {
                        lo_frmobj['ctr_json'] = {
                            pretme: lo_ctrdat[0].ctrprv, hr1tme: lo_ctrdat[0].ctrhs1, hr2tme: lo_ctrdat[0].ctrhs2, fintme: lo_ctrdat[0].ctrend,
                            prebpr: lo_ctrdat[1].ctrprv, hr1bpr: lo_ctrdat[1].ctrhs1, hr2bpr: lo_ctrdat[1].ctrhs2, finbpr: lo_ctrdat[1].ctrend,
                            prehrt: lo_ctrdat[2].ctrprv, hr1hrt: lo_ctrdat[2].ctrhs1, hr2hrt: lo_ctrdat[2].ctrhs2, finhrt: lo_ctrdat[2].ctrend,
                            prersp: lo_ctrdat[3].ctrprv, hr1rsp: lo_ctrdat[3].ctrhs1, hr2rsp: lo_ctrdat[3].ctrhs2, finrsp: lo_ctrdat[3].ctrend,
                            preso2: lo_ctrdat[4].ctrprv, hr1so2: lo_ctrdat[4].ctrhs1, hr2so2: lo_ctrdat[4].ctrhs2, finso2: lo_ctrdat[4].ctrend,
                            pretmp: lo_ctrdat[5].ctrprv, hr1tmp: lo_ctrdat[5].ctrhs1, hr2tmp: lo_ctrdat[5].ctrhs2, fintmp: lo_ctrdat[5].ctrend,
                            preobs: lo_ctrdat[6].ctrprv, hr1obs: lo_ctrdat[6].ctrhs1, hr2obs: lo_ctrdat[6].ctrhs2, finobs: lo_ctrdat[6].ctrend
                        };
                    }
                }

                lo_dat.append('frm_json', JSON.stringify(lo_frmobj));
                lo_dat.append('mat_json', lv_arr.length == 0 ? "" : JSON.stringify(lv_arr));
                lo_dat.append('evlmatdel', $("#<?= $lv_sec; ?> #evlmatdel").val());

                if (lv_err > 0) {
                    toastr.warning("Complete los campos obligatorios.<br>Incompletos (" + lv_err + ").");
                    return false;
                }
                if (!tmssFormValidation($("#<?= $lv_sec; ?>_frm"))) { return false; }

                tmssCallProcessFile("?prg=<?= $vew_data->endpoint; ?>&act=evlinf00", lo_dat, <?= $lv_sec; ?>_fncbckext);
                return false;
            }
        }
    </script>

    <?php include('grldocfrmscr.frm'); ?>
</section>
<?php 
	// url del formulario
  $lv_lnk = '?prg=fintaxexe&prm_fintaxexecod='.$vew_data->fintaxexecod;

	// campos requeridos
	$vew_input->RequiredFields( array('fintaxexestrdte','fintaxexeenddte','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->fintaxexecod;

	// titulo
	$lv_title = $vew_lang->accountingexercise;
	
	// módulo y programa
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'TEX';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <textarea class="hidden" id="fintaxexeper" name="fintaxexeper"></textarea>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->fintaxexecod; ?><?= gethtml('fintaxexecod','hidden',$vew_data->fintaxexecod); ?></strong></h4></li>
			</ul>
      
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('fintaxexecodext', 'doccmt1x20', $vew_data->fintaxexecodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('fintaxexetxt', 'doccmt1x50', $vew_data->fintaxexetxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->start, 			'input'=>gethtml('fintaxexestrdte', 'docdte', $vew_data->fintaxexestrdte, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->end,   			'input'=>gethtml('fintaxexeenddte', 'docdte', $vew_data->fintaxexeenddte, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div> <!-- /card -->
						</div> <!-- /col -->
            <div class="col-md-6">
              
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->periods; ?>
                  <?php if(!$vew_readonly){ ?><a href="#" onclick="<?= $lv_sec; ?>_generarPeriodosMensuales();" class="card-icon" title="Generar periodos mensuales"><i class="far fa-sync"></i></a><?php } ?>
                </div></div>
                <div class="card-body">
              		<div id="fintaxexeperhot" name="fintaxexeperhot"></div>
                </div>
              </div>

            </div> <!-- /col -->
					</div> <!-- /row -->
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <script>
	function <?= $lv_sec; ?>_generarPeriodosMensuales() {
    // Obtener valores de los campos con jQuery
    const lv_strdtestr = $("#<?= $lv_sec; ?> #fintaxexestrdte").val();
    const lv_enddtestr = $("#<?= $lv_sec; ?> #fintaxexeenddte").val();

    // Validar que los campos tengan valor
    if (!lv_strdtestr || !lv_enddtestr) {
    	toastr.error('Los campos de fecha no pueden estar vacíos.');
      return;
    }

    // Parsear con moment.js (formato dd/mm/yyyy)
    const lv_strdte = moment(lv_strdtestr, "DD/MM/YYYY");
    const lv_enddte = moment(lv_enddtestr, "DD/MM/YYYY");

    // Validar que las fechas sean válidas
    if (!lv_strdte.isValid() || !lv_enddte.isValid()) {
      toastr.warning("Las fechas ingresadas no son válidas.");
      return;
    }
    if (lv_strdte.isAfter(lv_enddte)) {
      toastr.warning("La fecha de inicio no puede ser mayor a la fecha de fin.");
      return;
    }

    const lv_per = [];
    let lv_cur = lv_strdte.clone();

    while (lv_cur.isSameOrBefore(lv_enddte, "month")) {
        // Inicio del período: cursor actual (respeta día exacto en el primer mes)
        const lv_strper = lv_cur.clone();

        // Fin del período: último día del mes del cursor
        let lv_endper = lv_cur.clone().endOf("month");

        // Si el fin del mes supera la fecha límite, usar la fecha límite
        if (lv_endper.isAfter(lv_enddte)) {
            lv_endper = lv_enddte.clone();
        }

        lv_per.push({ fintaxexeperstrdte: lv_strper.format("DD/MM/YYYY"), fintaxexeperenddte: lv_endper.format("DD/MM/YYYY"), docsts: "ACTIVO" });

        // Avanzar al primer día del mes siguiente
        lv_cur = lv_cur.clone().add(1, "month").startOf("month");
    }

    <?= $lv_sec; ?>_fintaxexeper.loadData( lv_per );
    <?= $lv_sec; ?>_fintaxexeper.render();
	}
  </script>
	<script>
		var <?= $lv_sec; ?>_fintaxexeper_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if ( prop=="fintaxexeperstrdte" || prop=="fintaxexeperenddte" ) {
				Handsontable.renderers.DateRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_fintaxexepercnt = $("#<?= $lv_sec; ?> #fintaxexeperhot")[0];
		var <?= $lv_sec; ?>_fintaxexeperet = {
			height: 396,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
      rowHeaders: true,
			minSpareRows: <?= ($vew_readonly ?'0':'1') ?>,
      licenseKey: gv_handsontable_lc,
			colHeaders: ["<?= $vew_lang->start; ?>", "<?= $vew_lang->end; ?>", "<?= $vew_lang->status; ?>"],
			columns: [
        { type: "date", data: "fintaxexeperstrdte", width: "50px", renderer: <?= $lv_sec; ?>_fintaxexeper_renderer <?= ($vew_readonly?', readOnly: true':''); ?>,
        dateFormat: 'DD/MM/YYYY', correctFormat: true, allowEmpty: true, datePickerConfig: { firstDay: 0, showWeekNumber: false, numberOfMonths: 1 }},
        { type: "date", data: "fintaxexeperenddte", width: "50px", renderer: <?= $lv_sec; ?>_fintaxexeper_renderer <?= ($vew_readonly?', readOnly: true':''); ?>,
        dateFormat: 'DD/MM/YYYY', correctFormat: true, allowEmpty: true, datePickerConfig: { firstDay: 0, showWeekNumber: false, numberOfMonths: 1 }},
        { type: "autocomplete", data: "docsts", width: "50px", renderer: <?= $lv_sec; ?>_fintaxexeper_renderer <?= ($vew_readonly?', readOnly: true':''); ?>,
        strict: true, source: ['ACTIVO','INACTIVO']}
			]
		};
		var <?= $lv_sec; ?>_fintaxexeper;

		// cargo datos en handsontable
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_fintaxexeper = new Handsontable(<?= $lv_sec; ?>_fintaxexepercnt, <?= $lv_sec; ?>_fintaxexeperet);
      var lv_dat = [<?php
				$lv_buffer='';
        if( is_array($vew_data->fintaxexeper) ){
          foreach($vew_data->fintaxexeper as $lv_row){
            if( $lv_row['fintaxexeperstrdte']!=null && $lv_row['fintaxexeperenddte']!=null){
	            $lv_row['docsts'] = ((strcmp($lv_row['docsts'],"A") == 0)||(strcmp($lv_row['docsts'],"ACTIVO") == 0)?"ACTIVO":"INACTIVO");
              $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                          'fintaxexeperstrdte:"'.date('d/m/Y', strtotime($lv_row['fintaxexeperstrdte'])).'",'.
                          'fintaxexeperenddte:"'.date('d/m/Y', strtotime($lv_row['fintaxexeperenddte'])).'",'.
                          'docsts:"'.$lv_row['docsts'].'"'.
                          '}';
            }
          }
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_fintaxexeper.loadData( lv_dat );
			<?= $lv_sec; ?>_fintaxexeper.render();
		});
  </script>
  <script>
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				var lo_dat = <?= $lv_sec; ?>_fintaxexeper.getSourceData();
        let lv_dat = lo_dat.filter(c => c.fintaxexeperstrdte!=null && c.fintaxexeperenddte!=null && c.docsts!=null);
        $("#<?= $lv_sec; ?> #fintaxexeper").prop("value", (lv_dat.length>0?JSON.stringify(lv_dat):"[]") );
			}
		}
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
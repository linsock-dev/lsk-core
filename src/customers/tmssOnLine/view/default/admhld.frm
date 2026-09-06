<?php 
	// url del formulario
  $lv_lnk = '?prg=admhld&prm_hldcod='.$vew_data->hldcod;

	// campos requeridos
	$vew_input->RequiredFields( array('hldday','lndtxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->hldcod;

	// titulo
	$lv_title = $vew_lang->holiday;

	// módulo y programa
	$lv_mdlcod = 'ADM';
	$lv_prgcod = 'HLD';

	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hldcod; ?><?= gethtml('hldcod','hidden',$vew_data->hldcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

        <!-- General -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          
					<div class="col-md-4">
            <!-- Feriado -->
            <div class="card">
              <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
              <div class="card-body tmss-card-body-edit">
								<?php
                  echo vew_boot($lv_col48, array('label'=>$vew_lang->country, 'input'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_data->lndtxt,$vew_data->hldcod==""?$lv_default:$lv_always_disabled),
                                                                                                 array("input"=>gethtml('lndtxt', 'doccmt1x50', $vew_data->lndtxt,$vew_data->hldcod==""?$lv_default:$lv_always_disabled) )) ));
									echo gethtml('lndcod', 'hidden', $vew_data->lndcod);
								?>
                <div class="form-group  tmss-form-group">
                  <label class="col-xs-4 control-label text-nowrap"><?= $vew_lang->year; ?></label>
                  <div class="col-xs-8">
                    <div class="input-group date " data-date-format="yyyy" data-date-autoclose="true" data-date-today-highlight="true"  data-date-show-on-focus="false" data-date-language="es" data-date-enable-on-readonly="false" data-date-clear-btn="true" data-provide="datepicker" data-date-start-view="2" data-date-min-view-mode="2">
                      <input type="text" id="hldday" name="hldday" value="<?= ($vew_data->hldday != ""?$vew_data->hldday->format('Y'):"");?>" maxlength="4" class="form-control tmssInputRequired <?= $vew_data->hldcod!=''?'tmssAlwaysDisabled':'';?>" placeholder="?" >
                      <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                    </div>
                  </div>                 
                </div>
                <?= vew_boot($lv_col48, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); ?>
              </div>
            </div>
          </div>
				
          <!-- Movimientos -->
          <div class="col-md-8">
            <div class="card tmss-hot-ttl">
              <div class="card-header"><div class="card-title"><?=  $vew_lang->holidays; ?></div></div>
            </div>
            <div id="hldmovhot" name="hldmovhot"></div>
            <textarea class="hidden" id="hldmov" name="hldmov"></textarea>
          </div>
          
        </div> <!-- /_tab001 -->
      </div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
    // Typeahead for lndcod
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"lndcod":"lndcod" , "lndtxt":"lndtxt"}} ;
    tmssTypeahead($("#<?= $lv_sec; ?> #lndtxt"), "grladrlnd", lo_get);
  </script>
  <script>    
		// Handsontable for holliday movemnts
		var <?= $lv_sec; ?>_hldmov_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if ( prop=="hldmovday" ) {
				Handsontable.renderers.DateRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_hldmovcnt = $("#<?= $lv_sec; ?> #hldmovhot")[0];
		var <?= $lv_sec; ?>_hldmovet = {
			height: 396,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly ?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->date; ?>", "<?= $vew_lang->motive; ?>" ],
			columns: [
				{	type: "date", data: "hldmovday", width: "30", renderer: <?= $lv_sec; ?>_hldmov_renderer <?= ($vew_readonly?', readOnly: true':''); ?>, dateFormat: 'DD/MM', correctFormat: true,	allowEmpty: true,	datePickerConfig: {firstDay: 0,	showWeekNumber: false, numberOfMonths: 1} },
				{ type: "text", data: "hldmovtxt", renderer: <?= $lv_sec; ?>_hldmov_renderer <?= ($vew_readonly?', readOnly: true':''); ?> }
			],
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hldmov;

		// cargo datos en handsontable
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hldmov = new Handsontable(<?= $lv_sec; ?>_hldmovcnt, <?= $lv_sec; ?>_hldmovet);
			var lv_dat = [<?php 
				$lv_buffer='';
				foreach($vew_data->hldmov as $lv_row){
          // convierto el array de valores en una array asociativo clave-valor con claves en minusculas
          $lv_rowdat = array_change_key_case( array_combine( array_keys($lv_row), array_values($lv_row)));
          $lv_day = date_create_from_format('Y-m-d',substr($lv_rowdat['hldmovday'],0,10));
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
											'hldmovcod:"'.$lv_rowdat['hldmovcod'].'",'.
											'hldmovday:"'.$lv_day->format('d/m').'",'.
											'hldmovtxt:"'.utf8_decode($lv_rowdat['hldmovtxt']).'"'.
											'}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hldmov.loadData( lv_dat );
			<?= $lv_sec; ?>_hldmov.render();
		});
	</script>
  <script>
		// form submit externa
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if(lp_prm.action=="00"){
				// get dates from handsontable
				var lo_dat = <?= $lv_sec; ?>_hldmov.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["hldmovday"]!=undefined && lo_dat[i]["hldmovtxt"]!=undefined ) {
							lv_arr.push({	"hldmovcod":lo_dat[i]["hldmovcod"] != undefined ? lo_dat[i]["hldmovcod"] : "",
														"hldmovday":lo_dat[i]["hldmovday"],
														"hldmovtxt":lo_dat[i]["hldmovtxt"]
													});
						}
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #hldmov").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #hldmov").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
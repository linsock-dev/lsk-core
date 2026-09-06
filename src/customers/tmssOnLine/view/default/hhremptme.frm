<?php		
	// url del formulario
  $lv_lnk = '?prg=hhremptme';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->schedule;
	
	// módulo y programa
	$lv_mdlcod = '';
	$lv_prgcod = '';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

	<nav class="navbar navbar-default tmss-navbar <?= ($vew_readonly?'hidden':''); ?>">
		<div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '00'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success" title="<?= $vew_lang->save;  ?>"><span class="far fa-save"></span><span class="hidden-xs"> <?= $vew_lang->save; ?></span></a>
			</ul>
		</div>
	</nav>
	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('hhrempcod','hidden',$vew_data->hhrempcod); ?>
		<div class="containter-fluid">			
			<textarea id="hhremptme" name="hhremptme" class="hidden"></textarea>
			<div id="hhremptmehot"></div>
		</div>
	</form>
	<script>
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if ( prop=="hhremptmestr" || prop=="hhremptmeend" ) {
				Handsontable.renderers.DateRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else if ( prop=="wrkplctxt" || prop=="wrkstetxt" || prop=="hhrtmerngtxt" ) {
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_hotdocdel = [];
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #hhremptmehot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 146,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->start; ?>", "<?= $vew_lang->end; ?>", "<?= $vew_lang->workplace; ?>","<?= $vew_lang->workstation; ?>", "<?= $vew_lang->schedule; ?>" ],
			columns: [
				{type: "date", data: "hhremptmestr", width: 75, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					dateFormat: 'DD/MM/YYYY',	correctFormat: true,	allowEmpty: false,
					datePickerConfig: {	firstDay: 0,	showWeekNumber: false, numberOfMonths: 1	}
				},
				{type: "date", data: "hhremptmeend", width: 75, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					dateFormat: 'DD/MM/YYYY',	correctFormat: true,	allowEmpty: false,
					datePickerConfig: {	firstDay: 0,	showWeekNumber: false, numberOfMonths: 1	}
				},
				{type: "autocomplete", data: "wrkplctxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
						$.ajax({
							url: "?prg=hhrwrkplc&act=18", dataType: "json", data: { prm_wrkplctxt: query },
              success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.wrkplctxt);
                process(items);
              },
              error: function () {
                <?= $lv_sec; ?>_autocompleteCache = [];
                process([]);
              }
						});
					},
					strict: true
				},
				{type: "autocomplete", data: "wrkstetxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
						$.ajax({
							url: "?prg=hhrwrkste&act=18", dataType: "json", data: { prm_wrkstetxt: query },
              success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.wrkstetxt);
                process(items);
              },
              error: function () {
                <?= $lv_sec; ?>_autocompleteCache = [];
                process([]);
              }
						});
					},
					strict: true
				},
				{type: "autocomplete", data: "hhrtmerngtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
						$.ajax({
							url: "?prg=hhrtmerng&act=18", dataType: "json", data: { prm_hhrtmerngtxt: query },
              success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.hhrtmerngtxt);
                process(items);
              },
              error: function () {
                <?= $lv_sec; ?>_autocompleteCache = [];
                process([]);
              }
						});
					},
					strict: true
				}
			],
      afterChange: function(changes, source) {
      	if (changes && changes.length > 0 && source == 'edit') {
        	const row = changes[0][0];
          const valueSelected = changes[0][3] || "";
          
          if( changes[0][1]=="wrkplctxt"){
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "wrkplccod", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.wrkplctxt === valueSelected);
            	if (selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "wrkplccod", selectedItem.wrkplccod);
            	else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          } else if (changes[0][1]=="wrkstetxt") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "wrkstecod", "");
            } else {
            	const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.wrkstetxt === valueSelected);
            	if (selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "wrkstecod", selectedItem.wrkstecod);
            	else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          } else if (changes[0][1]=="hhrtmerngtxt") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "hhrtmerngcod", "");
            } else {
                const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.hhrtmerngtxt === valueSelected);
                if (selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "hhrtmerngcod", selectedItem.hhrtmerngcod);
                else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          }
        }
      },
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["hhremptmecod"]!='' && lv_dat[i]["hhremptmecod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			},
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotdoc;
		
		// cargo datos en handsontable
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
				$lv_buffer = '';
				foreach( $vew_data->hhremptme as $lv_row ) {
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'hhremptmecod:"'.$lv_row['hhremptmecod'].'",'.
												'hhremptmestr: "'.$lv_row['hhremptmestr']->format('d/m/Y').'", '.
												'hhremptmeend: "'.$lv_row['hhremptmeend']->format('d/m/Y').'", '.
												'wrkplccod:"'.($lv_row['wrkplccod']==0?'':$lv_row['wrkplccod']).'",'.
												'wrkplctxt:"'.($lv_row['wrkplctxt']==null?'':$lv_row['wrkplctxt']).'",'.
												'wrkstecod:"'.$lv_row['wrkstecod'].'",'.
												'wrkstetxt:"'.$lv_row['wrkstetxt'].'",'.
												'hhrtmerngcod:"'.$lv_row['hhrtmerngcod'].'",'.
												'hhrtmerngtxt:"'.$lv_row['hhrtmerngtxt'].'"}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
		
		$(function(e){ tmssHandsontableResize(); });
	</script>
	<script>
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {				
			if (lp_prm["action"]=="00") {
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = [];
				for (var i=0; i<lo_dat.length-1; i++) {
					if( lo_dat[i]["hhremptmestr"] && lo_dat[i]["hhremptmeend"] && lo_dat[i]["wrkstecod"] && lo_dat[i]["hhrtmerngcod"]  ){
						lv_arr.push({	"hhremptmecod": lo_dat[i]["hhremptmecod"],
													"wrkplccod": lo_dat[i]["wrkplccod"],
													"hhremptmestr": lo_dat[i]["hhremptmestr"],
													"hhremptmeend": lo_dat[i]["hhremptmeend"],
													"wrkplctxt": lo_dat[i]["wrkplctxt"],
													"wrkstecod": lo_dat[i]["wrkstecod"],
													"wrkstetxt": lo_dat[i]["wrkstetxt"],
													"hhrtmerngcod": lo_dat[i]["hhrtmerngcod"],
													"hhrtmerngtxt": lo_dat[i]["hhrtmerngtxt"]
												});
					}else{ 
            toastr.warning("Completar campos de per&iacute;odo, puesto de trabajo y horario.");
            return false;
          }
				}
				
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"hhremptmecod":<?= $lv_sec; ?>_hotdocdel[i]["hhremptmecod"], "deleted":"X" });
				}

				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #hhremptme").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #hhremptme").prop("value", JSON.stringify( lv_arr ) );
				}
			}			
		}
	</script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
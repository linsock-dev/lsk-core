<?php
	/* url del formulario */
  $lv_lnk = '?prg=hltspctme';

	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = '';

	/* titulo */
	$lv_title = $vew_lang->schedule;
	
	/* módulo y programa */
	$lv_mdlcod = '';
	$lv_prgcod = '';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
	
	$vew_data->delcod = ($vew_data->delcod==0?'':$vew_data->delcod);
	$vew_data->spccod = ($vew_data->spccod==0?'':$vew_data->spccod);
	$vew_data->prscod = ($vew_data->prscod==0?'':$vew_data->prscod);
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
		<?= gethtml('delcod', 'hidden', $vew_data->delcod); ?>
		<?= gethtml('spccod', 'hidden', $vew_data->spccod); ?>
		<?= gethtml('prscod', 'hidden', $vew_data->prscod); ?>
		<div class="containter-fluid">			
			<?php 
				echo vew_boot($lv_col210, array('label'=>$vew_lang->delegation,'input'=>gethtml('deltxt', 'doccmt1x50', $vew_data->deltxt, $lv_always_disabled) ));
				echo vew_boot($lv_col210, array('label'=>$vew_lang->specialty, 'input'=>gethtml('spctxt', 'doccmt1x50', $vew_data->spctxt, $lv_always_disabled) ));
				echo vew_boot($lv_col210, array('label'=>$vew_lang->provider,  'input'=>gethtml('prstxt', 'doccmt1x50', $vew_data->prstxt, $lv_always_disabled) ));
			?>
			<textarea id="hltspctme" name="hltspctme" class="hidden"></textarea>
			<div id="hltspctmehot"></div>
		</div>
	</form>

	<script>
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if ( prop=="deltxt" || prop=="spctxt" ) {
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else if ( prop=="tmedaytxt" ) {
				Handsontable.renderers.DropdownRenderer.apply(this, arguments);			
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else if ( prop=="tmestr" || prop=="tmeend" ) {
				Handsontable.renderers.TimeRenderer.apply(this, arguments);			
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else if ( prop=="tmeqty" || prop=="tmefrq" || prop=="tmeovr" ) {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);			
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_hotdocdel = [];
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #hltspctmehot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 200,
			formulas: false,
			stretchH: "all",
			colHeaders: [ <?= ($vew_data->delcod==''?'"Lugar",':'').($vew_data->prscod!=''?'"Especialidad",':''); ?> "Dia", "Hs.Desde", "Hs.Hasta", "Pacientes", "Frecuencia (Minutos)", "Sobreturnos" ],
			columns: [
				<?php if($vew_data->delcod==''){ ?>
				{type: "autocomplete", data: "deltxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "?prg=hltdel&act=18", dataType: "json", data: { prm_deltxt: query },
							success: function (response) {
								<?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.deltxt);
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
				<?php } ?>
				<?php if( $vew_data->prscod!='' ) { ?>
				{type: "autocomplete", data: "spctxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "?prg=hltspc&act=18", dataType: "json", data: { prm_spctxt: query },
							success: function (response) {
								<?= $lv_sec; ?>_autocompleteCache = response || [];
								const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.spctxt);
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
				<?php } ?>
				{ type: "dropdown", data: "tmedaytxt", width: 80, source: ["Lunes","Martes","Miercoles","Jueves","Viernes","Sabado","Domingo"], strict: true, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
				{ type: "time", data: "tmestr", width: 50, timeFormat: "HH:mm", correctFormat: true, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
				{ type: "time", data: "tmeend", width: 50, timeFormat: "HH:mm", correctFormat: true, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
				{ type: "numeric", data: "tmeqty", width: 50, numericFormat: {pattern: "0", culture: "es-AR"}, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
				{ type: "numeric", data: "tmefrq", width: 50, numericFormat: {pattern: "0", culture: "es-AR"}, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
				{ type: "numeric", data: "tmeovr", width: 50, numericFormat: {pattern: "0", culture: "es-AR"}, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> }
			],
			afterChange : function(changes, source) {
				if (changes && changes.length > 0) {
					const row = changes[0][0];
          const valueSelected = changes[0][3] || "";
          if (changes[0][1]=="deltxt") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "delcod", "");
            } else {
                const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.deltxt === valueSelected);
                if (selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "delcod", selectedItem.delcod);
                else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          } else if(changes[0][1]=="spctxt") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "spccod", "");
            } else {
                const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.spctxt === valueSelected);
                if (selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "spccod", selectedItem.spccod);
                else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          } else if(changes[0][1]=="tmedaytxt") {
            var lv_value = changes[0][3];
            lv_value = String(lv_value=="Lunes"?"1":
                            (lv_value=="Martes"?"2":
                            (lv_value=="Miercoles"?"3":
                            (lv_value=="Jueves"?"4":
                            (lv_value=="Viernes"?"5":
                            (lv_value=="Sabado"?"6":
                            (lv_value=="Domingo"?"7":"")))))))
            <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "tmeday",  lv_value);
          }
        }
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["spctmecod"]!='' && lv_dat[i]["spctmecod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			},
			minSpareRows: 1,
			startRows: 1,
			startCols: 3,
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotdoc;
		
		// cargo datos en handsontable
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
				$lv_buffer = '';
				$lv_days_arr = array(1=>'Lunes',2=>'Martes',3=>'Miercoles',4=>'Jueves',5=>'Viernes',6=>'Sabado',7=>'Domingo');
				foreach( $vew_data->hltspctme as $lv_row ) {
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'spctmecod:"'.$lv_row['spctmecod'].'",'.
												'delcod:"'.$lv_row['delcod'].'",'.
												'deltxt:"'.$lv_row['deltxt'].'",'.
												'spccod:"'.$lv_row['spccod'].'",'.
												'spctxt:"'.$lv_row['spctxt'].'",'.
												'prscod:"'.$lv_row['prscod'].'",'.
												'prstxt:"'.$lv_row['prstxt'].'",'.
												'tmedaytxt:"'.$lv_days_arr[ $lv_row['tmeday'] ].'",'.
												'tmeday:"'.$lv_row['tmeday'].'",'.
												'tmestr:"'.$lv_row['tmestr']->format('H:i').'",'.
												'tmeend:"'.$lv_row['tmeend']->format('H:i').'",'.
												'tmeqty: '.$lv_row['tmeqty'].','.
												'tmefrq: '.$lv_row['tmefrq'].','.
												'tmeovr: '.$lv_row['tmeovr'].'}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
	<script>
		$(function(e){ tmssHandsontableResize(); });

		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {				
			if (lp_prm["action"]=="00") {
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = [];
				var lv_str;
				var lv_end;
				var lv_errqty = 0;
				for (var i=0; i<lo_dat.length; i++) {
					if( lo_dat[i]["tmeday"]!=undefined && parseInt(lo_dat[i]["tmeday"])>0 && parseInt(lo_dat[i]["tmeday"])<=7 ){
            if(lo_dat[i]["tmestr"]=="" || lo_dat[i]["tmestr"]==undefined ){lo_dat[i]["tmestr"]="00:00";}
            if(lo_dat[i]["tmeend"]=="" || lo_dat[i]["tmeend"]==undefined ){lo_dat[i]["tmeend"]="23:59";}
						lv_str = moment( lo_dat[i]["tmestr"], "HH:mm");
						lv_end = moment( lo_dat[i]["tmeend"], "HH:mm");
						if( lv_str.isBefore(lv_end)==false ) {
							<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 2, "valid", false);
							<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 3, "valid", false);
							lv_errqty++;
						} else {
							<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 2, "valid", true);
							<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 3, "valid", true);
						}
						lv_arr.push({	"spctmecod": lo_dat[i]["spctmecod"],
													"delcod": lo_dat[i]["delcod"],
													"spccod": (lo_dat[i]["spccod"]==undefined?0:lo_dat[i]["spccod"]),
													"prscod": (lo_dat[i]["prscod"]==undefined?0:lo_dat[i]["prscod"]),
													"tmeday": lo_dat[i]["tmeday"],
													"tmestr": lo_dat[i]["tmestr"],
													"tmeend": lo_dat[i]["tmeend"],
													"tmeqty": (lo_dat[i]["tmeqty"]==undefined?0:lo_dat[i]["tmeqty"]),
													"tmefrq": (lo_dat[i]["tmefrq"]==undefined?0:lo_dat[i]["tmefrq"]),
													"tmeovr": (lo_dat[i]["tmeovr"]==undefined?0:lo_dat[i]["tmeovr"])
												});
					} else if ( lo_dat[i]["spctmecod"]!=undefined && lo_dat[i]["spctmecod"]!="" ) {
						lv_arr.push({ "spctmecod": lo_dat[i]["spctmecod"], "deleted":"X" });
					}
				}
				<?= $lv_sec; ?>_hotdoc.render();
				if ( lv_errqty>0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }

				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"spctmecod":<?= $lv_sec; ?>_hotdocdel[i]["spctmecod"], "deleted":"X" });
				}

				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #hltspctme").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #hltspctme").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
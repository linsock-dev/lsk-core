<?php
	// url del formulario
  $lv_lnk = '?prg=edumod&prm_edumodcod='.$vew_data->edumodcod;

	// campos requeridos
	$vew_input->RequiredFields( array('edumodtxt','custxt','cuscod','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->edumodcod; 

	// titulo
	$lv_title = $vew_lang->module;
	
	// módulo y programa
	$lv_mdlcod = 'EDU';
	$lv_prgcod = 'MOD';

	// librería de estilos bootstrap
	include_once('_library.frm');
	
	$lv_pr = $vew_doc->getTagValue($vew_data->edumodatr,'sumtyp');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
		<textarea id="edumodpln" name="edumodpln" class="hidden"></textarea>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->edumodcod; ?><?= gethtml('edumodcod','hidden',$vew_data->edumodcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">  
            <div class="col-md-6">
						
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->module; ?> 
										<span class="tmss-card-icon">
                    	<?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?>
                    	<?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);?>
                  	</span>
									</div>	
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('edumodcodext', 'doccmt1x20', $vew_data->edumodcodext, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('edumodtxt', 'doccmt1x50', $vew_data->edumodtxt, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div> <!-- /card --> 
							
						</div>
						<div class="col-md-6">
						
          		<div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->data; ?></div></div>
              	<div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->customer, 'input'=>vew_boot(array('style'=>'search','readonly'=>$vew_readonly), array('input'=>gethtml('custxt', 'doccmt1x50', $vew_data->custxt, $lv_default) )) ));
                    echo gethtml('cuscod', 'hidden', $vew_data->cuscod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->counter, 'input'=>gethtml('edumodatrsumtyp', array(''=>'','I'=>'Materia Individual','G'=>'Grupo de Materias'), $vew_doc->getTagValue($vew_data->edumodatr,'sumtyp'), $lv_default) ));
                   ?>
                </div>
              </div> <!-- /card --> 

						</div>
					</div>
					<div class="row">
            <div class="col-md-12">
							<div id="edumodplnhot" name="edumodplnhot"></div>
						</div> 
    			</div>
				</div> <!-- /tab-pane -->
    	</div> <!-- /tab-content -->
		</div> <!-- /container-fluid -->
  </form>
	<script>
  	// TYPEAHEAD - C L I E N T E S
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt":{"c.docsts":"A"}, "fldasg" : {"cuscod": "cuscod", "custxt" : "custxt"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #custxt"), "slscus", lo_get);
	</script>
	<script>
		//	M A T E R I A S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if(prop=="edumodplnatrtyp"){
				Handsontable.renderers.DropdownRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else {
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #edumodplnhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Plan", "Carrera", "Curso", "Materia", "Origen" ],
			columns: [
				{type: "autocomplete", data: "educurtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
						$.ajax({
							url: "?prg=educur&act=18", dataType: "json", data: { prm_educurtxt: query },
              success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.educurtxt);
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
				{type: "autocomplete", data: "educartxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
						$.ajax({
							url: "?prg=educar&act=18", dataType: "json", data: { prm_educartxt: query },
							success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.educartxt);
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
				{type: "autocomplete", data: "educoutxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
						$.ajax({
							url: "?prg=educou&act=18", dataType: "json", data: { prm_educoutxt: query },
							success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.educoutxt);
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
				{type: "autocomplete", data: "edusubtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
						$.ajax({
							url: "?prg=edusub&act=18", dataType: "json", data: { prm_edusubtxt: query },
							success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.edusubtxt);
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
				{type: "dropdown", data: "edumodplnatrtyp", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: ["1-Evaluado","2-Inasistencia"],
					strict: true
				}
			],
      afterChange: function(changes, source) {
        if (changes && changes.length > 0 && source === 'edit') {
          const row = changes[0][0];
          const valueSelected = changes[0][3] || "";
          
          if (changes[0][1]=="educurtxt"){
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "educurcod", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.educurtxt === valueSelected);
              if (selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "educurcod", selectedItem.educurcod);
              else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          } else if (changes[0][1]=="educartxt") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "educarcod", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.educartxt === valueSelected);
              if (selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "educarcod", selectedItem.educarcod);
              else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          } else if (changes[0][1]=="educoutxt") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "educoucod", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.educoutxt === valueSelected);
              if (selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "educoucod", selectedItem.educoucod);
              else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          } else if (changes[0][1]=="edusubtxt") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "edusubcod", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.edusubtxt === valueSelected);
              if (selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "edusubcod", selectedItem.edusubcod);
              else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          }
        } 
      },
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["edumodplncod"]!="" && lv_dat[i]["edumodplncod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotdocerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotdocerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotdocerr.splice(lv_inx,1); }	
				}
			},
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotdoc;	

		// cargo datos en handsontable
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->edumodpln as $lv_row){ 
					$lv_typ = $vew_doc->getTagValue($lv_row['edumodplnatr'],'ctrtyp');
					$lv_typ = ($lv_typ=='1'?'1-Evaluado':($lv_typ=='2'?'2-Inasistencia':''));
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'edumodplncod:"'.$lv_row['edumodplncod'].'",'.
												'educurcod:"'.$lv_row['educurcod'].'",'.
												'educurtxt:"'.$lv_row['educurtxt'].'",'.
												'educarcod:"'.$lv_row['educarcod'].'",'.
												'educartxt:"'.$lv_row['educartxt'].'",'.
												'educoucod:"'.$lv_row['educoucod'].'",'.
												'educoutxt:"'.$lv_row['educoutxt'].'",'.
												'edusubcod:"'.$lv_row['edusubcod'].'",'.
												'edusubtxt:"'.$lv_row['edusubtxt'].'",'.
												'edumodplnatrtyp:"'.$lv_typ.'"}'; 
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
  <script>		
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }

				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length-1; i++) {
					if ( Object.keys(lo_dat[i]).length!=0 ) {
						lv_arr.push({	"edumodplncod":(lo_dat[i].hasOwnProperty("edumodplncod")?lo_dat[i]["edumodplncod"]:""),
													"educurcod":lo_dat[i]["educurcod"],
													"educarcod":lo_dat[i]["educarcod"],
													"educoucod":lo_dat[i]["educoucod"],
													"edusubcod":lo_dat[i]["edusubcod"],
													"edumodplnatrtyp":lo_dat[i]["edumodplnatrtyp"]
												});
					}
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"edumodplncod":<?= $lv_sec; ?>_hotdocdel[i]["edumodplncod"], "edumodplnatrtyp":<?= $lv_sec; ?>_hotdocdel[i]["edumodplnatrtyp"], "deleted":"X" });
				}
				$("#<?= $lv_sec; ?> #edumodpln").text( (lv_arr.length==0?"":JSON.stringify(lv_arr)) );
			}			
		}
  </script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
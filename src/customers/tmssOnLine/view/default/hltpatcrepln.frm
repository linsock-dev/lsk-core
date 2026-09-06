<?php
	/* url del formulario */
  $lv_lnk = '?prg=hltpatcrepln&prm_patcreplncod='.$vew_data->patcreplncod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('patcod','patcreplnstrdte','patcreplnenddte','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->patcreplncod; 

	/* titulo */
	$lv_title = $vew_lang->careplan;
	
	/* m?dulo y programa */
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PLA';

	/* librer?a de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!--navbar-->
	<?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>

		<textarea class="d-none" id="patcreplnmat" name="patcreplnmat"></textarea>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->patcreplncod; ?><?= gethtml('patcreplncod', 'hidden', $vew_data->patcreplncod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->careplan; ?>
               			<span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                    <?php 
                      echo gethtml('sysdocclstxt', 'hidden', $vew_data->sysdoccls->sysdocclstxt);
                      echo gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);
                    ?>
                	</div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->patient,'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                          		array('input'=>gethtml('pattxt',	'typeahead',	$vew_data->pattxt,	$lv_default) ))
                                                      ));
                    echo gethtml('patcod', 'hidden', $vew_data->patcod);
                  	echo vew_boot($lv_col255, array('label'=>$vew_lang->period, 'input'=>gethtml('patcreplnstrdte',	 'docdte',	$vew_data->patcreplnstrdte,	$lv_default), 
                                                    														'input2'=>gethtml('patcreplnenddte', 'docdte',	$vew_data->patcreplnenddte,	$lv_default) ));
                  ?>
                </div>
              </div> <!-- card -->
						</div>
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->data; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->authorization,'input'=>gethtml('patcreplnaut','doccmt1x20',$vew_data->patcreplnaut,$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,				'input'=>gethtml('docsts', 			'docsts',		 $vew_data->docsts, 		 $lv_default) ));
                  ?>
                </div>
              </div> <!-- card -->
						</div>
					</div>
          
          <div class="card tmss-hot-ttl">
            <div class="card-header">
              <div class="card-title">
                <?= $vew_lang->SUPPLIES; ?>
              <span class="tmss-card-icon"></span>	
              </div>
            </div>
          </div>
          <div id="patcreplnmathot" name="patcreplnmathot"></div>
				</div> <!-- fin tab001 -->

			</div> <!-- tabcontent -->    
		</div> <!-- container-fluid -->
  </form>
	<script>
    // Typeahead de Paciente 
     var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"p.docsts":"A"}, "fldasg":{"patcod":"patcod", "pattxt":"pattxt"}};
      tmssTypeahead($("#<?= $lv_sec; ?> #pattxt"), "hltpat", lo_get);
    		
		$("#<?= $lv_sec; ?> #patcreplncod").on("change",function(e){
			tmssLink("index.php?prg=hltpatcrepln&act=03&prm_patcreplncod="+$("#<?= $lv_sec; ?> #patcreplncod").prop("value"), [{ target: "_replace_with", target_id: "#<?= $lv_sec; ?>" }] );
			toastr.info("Visualizando documento <strong>"+$("#<?= $lv_sec; ?> #patcreplncod").prop("value")+"</strong>");
		});
	</script>
	<script>
		//	M A T E R I A L E S
		var <?= $lv_sec; ?>_hotmat_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if ( prop=="mattxt" ) {
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			} else if ( prop=="matqty" || prop=="matfrqqty" ) {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);			
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			} else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			}
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotmatdel = [];
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotmatcnt = $("#<?= $lv_sec; ?> #patcreplnmathot")[0];
		var <?= $lv_sec; ?>_hotmatset = {
			height: 396,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: ["ID", "Clasificacion", "Denominacion", "Cantidad", "UM", "Frecuencia", "UM Frec", "Comentarios"],
			columns: [
				{type: "text", data: "matcod", renderer: <?= $lv_sec; ?>_hotmat_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
        {type: "text", data: "matclstxt",	width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= (', readOnly: true');	?>},
				{type: "autocomplete", data: "mattxt", renderer: <?= $lv_sec; ?>_hotmat_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "index.php?prg=stkmat&act=17", dataType: "json", data: {	prm_mattxt: query },
							success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.mattxt);
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
				{type: "numeric", data: "matqty", 		width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
        {type: "text", 		data: "matuntcod",	width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly?', readOnly: true':'');	?>},
				{type: "numeric", data: "matfrqqty", 	width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0", culture: "es-AR"} },
				{type: "dropdown",data: "matfrq", 	  source: ["Dia", "Semana","Mes","Ano"],	width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly?', readOnly: true':'');	?>},
				{type: "text", 		data: "matcmt",			width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly?', readOnly: true':'');	?>}
			],
      afterChange: function(changes, source) {
        if (changes && changes.length > 0 && source === 'edit') {
          const row = changes[0][0];
          const valueSelected = changes[0][3] || "";
          
          if (changes[0][1] === "mattxt") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matcod", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.mattxt === valueSelected);
              if (selectedItem) {
                <?= $lv_sec; ?>_hotmat.setDataAtRowProp(row, "matcod", selectedItem.matcod, 'autocomplete');
                <?= $lv_sec; ?>_hotmat.setDataAtRowProp(row, "matclstxt", (selectedItem.matclstxt !== null ? selectedItem.matclstxt : ''), 'autocomplete');
                <?= $lv_sec; ?>_hotmat.setDataAtRowProp(row, "matqty", 1, 'autocomplete');
                <?= $lv_sec; ?>_hotmat.setDataAtRowProp(row, "matuntcod", selectedItem.matuntcod, 'autocomplete');
              } else {
                <?= $lv_sec; ?>_hotmat.setDataAtRowProp(row, "matcod", null, 'autocomplete');
                <?= $lv_sec; ?>_hotmat.setDataAtRowProp(row, "matclstxt", null, 'autocomplete');
                <?= $lv_sec; ?>_hotmat.setDataAtRowProp(row, "matqty", null, 'autocomplete');
                <?= $lv_sec; ?>_hotmat.setDataAtRowProp(row, "matuntcod", null, 'autocomplete');
								toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
              } 
            }
					}
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["patcreplnmatcod"]!="" && lv_dat[i]["patcreplnmatcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotmatdel.push( lv_dat[i] );
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
		var <?= $lv_sec; ?>_hotmat;	

		// cargo datos en handsontable
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotmat = new Handsontable(<?= $lv_sec; ?>_hotmatcnt, <?= $lv_sec; ?>_hotmatset);	
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->patcreplnmat as $lv_row){ 
					$lv_matfrq = '';
					switch($lv_row['matfrq']){
						case 'D': $lv_matfrq='Dia'; break;
						case 'S': $lv_matfrq='Semana'; break;
						case 'M': $lv_matfrq='Mes'; break;
						case 'A': $lv_matfrq='Ano'; break;
					}
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'patcreplnmatcod:"'.$lv_row['patcreplnmatcod'].'",'.
												'matcod:"'.$lv_row['matcod'].'",'.
												'mattxt:"'.$lv_row['mattxt'].'",'.
												'matqty: '.$lv_row['matqty'].' ,'.
												'matuntcod:"'.$lv_row['matuntcod'].'",'.
												'matfrq:"'.$lv_matfrq.'",'.
												'matfrqqty: '.$lv_row['matfrqqty'].' ,'.
            						'matclstxt:"'.(isset($lv_row['matclstxt'])?$lv_row['matclstxt']:'').'",'.
												'matcmt:"'.$lv_row['matcmt'].'"}'; }
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotmat.loadData( lv_dat );
			<?= $lv_sec; ?>_hotmat.render();
		});
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
      // al grabar
			if ( lp_prm["action"]=="00" ) {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
				
				// obtengo datos de handsontable de Especialidades
				var lo_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( Object.keys(lo_dat[i]).length!=0 ) {
						var lv_matfrq = "";
						if (lo_dat[i]["matfrq"]!=undefined) { 
							lv_matfrq = lo_dat[i]["matfrq"];
							lv_matfrq = lv_matfrq.substring(0,1);
						}
						lv_arr.push({	"patcreplnmatcod":(lo_dat[i].hasOwnProperty("patcreplnmatcod")?lo_dat[i]["patcreplnmatcod"]:""),
													"matcod":lo_dat[i]["matcod"],
                         	"matclstxt:":lo_dat[i]["matclstxt"],
													"mattxt":lo_dat[i]["mattxt"],
													"matqty":lo_dat[i]["matqty"],
													"matuntcod":lo_dat[i]["matuntcod"],
													"matfrq":lv_matfrq,
													"matfrqqty":(lo_dat[i].hasOwnProperty("matfrqqty")?lo_dat[i]["matfrqqty"]:""),
													"matcmt":(lo_dat[i].hasOwnProperty("matcmt")?lo_dat[i]["matcmt"]:"")
												});
					}
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotmatdel.length; i++) {
					lv_arr.push({	"patcreplnmatcod":<?= $lv_sec; ?>_hotmatdel[i]["patcreplnmatcod"], "deleted":"X" });
				}
				$("#<?= $lv_sec; ?> #patcreplnmat").prop("value", (lv_arr.length==0?"":JSON.stringify(lv_arr)) );						
			}
    }
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
<?php
	// url del formulario
  $lv_lnk = "?prg=crmcntmtv&prm_crmcntmtvcod=".$vew_data->crmcntmtvcod; 
 
	// campos requeridos
	$vew_input->RequiredFields( array('crmcnttypcod','crmcntmtvtxt','crmcntstscod','docsts',) );

	// clave del documento
	$lv_dockey = $vew_data->crmcntmtvcod;

	// titulo
	$lv_title = $vew_lang->contactmotive;

	// m dulo y programa
	$lv_mdlcod = 'CRM';
	$lv_prgcod = 'MTV';

	$vew_data->crmcntmtvfrmnme = $vew_doc->getTagValue($vew_data->crmcntmtvatr,'crmcntmtvfrmnme');
	
	// librería de estilos bootstrap
  include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
   <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>

		<div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->statuses; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->crmcntmtvcod; ?><?= gethtml('crmcntmtvcod','hidden',$vew_data->crmcntmtvcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
            <!--  Trajeta Motivo  -->
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->MOTIVE; ?></div></div>
                <div class="card-body tmss-card-body-edit">  
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('crmcntmtvcodext', 'doccmt1x20', $vew_data->crmcntmtvcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('crmcntmtvtxt', 'doccmt1x50', $vew_data->crmcntmtvtxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>                            
						</div> <!-- col-md-6 -->
          
        		<!--  Trajeta arriba der -->
          	<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">  
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->authorizationcode, 'input'=>gethtml('autcod','autcod', 									$vew_data->autcod, $lv_default ) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->form,							 'input'=>gethtml('crmcntmtvfrm', 'doccmt1x250',      $vew_data->crmcntmtvfrm, 	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->name,							 'input'=>gethtml('crmcntmtvfrmnme', 'doccmt1x250',   $vew_data->crmcntmtvfrmnme,$lv_default) ));
                  ?>
                </div>
              </div>                           
						</div> <!-- col-md-6 -->
          </div> <!-- row -->
          
          <!--  Trajeta datos por defecto -->
      		<div class="row">
          	<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->DEFAULTDATA; ?></div></div>
                <div class="card-body tmss-card-body-edit">  
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 			'input'=>gethtml('crmcnttypcod', 'crmcnttypcod_lst', $vew_data->crmcnttypcod, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->priority,		'input'=>gethtml('crmcntprtcod', 'crmcntprtcod_lst', $vew_data->crmcntprtcod, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('crmcntstscod', 'crmcntstscod_lst', $vew_data->crmcntstscod, $lv_default) ));
                  ?>
                </div>
              </div>                            
						</div> <!-- col-md-6 -->
        
      
      			<!--  Trajeta actividades -->
          	<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->ACTIVITIES; ?></div></div>
                <div class="card-body tmss-card-body-edit">  
                  <div class="col-sm-12"><?= gethtml('crmcntmtvact', 'doccmt5x50', $vew_data->crmcntmtvact, $lv_default); ?></div>
                </div>
              </div>
            </div> <!-- col-md-6 -->
  
					</div>	<!-- row -->
				</div> <!-- tab001 -->

				<!-- ESTADO  -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<div class="">
						<textarea class="hidden" id="crmcntstshottxt" name="crmcntstshottxt"></textarea>
						<div id="crmcntstshot"></div>
					</div>
				</div>

			</div> <!-- /tab-content -->
		</div><!-- /container-fluid -->
	</form>
	<script>
		// ESTADOS Y RESPONSABLE
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if (prop=="crmcntststxtstr" || prop=="crmcntststxtend") {
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
				var lv_id = instance.getDataAtRowProp(row,"crmcntstscod");
				if ( (lv_id==null?"":lv_id)!="" ) {
					td.style.backgroundColor = "#F1F1F1";
					cellProperties.readOnly = true;
				} else {
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				}
			} else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #crmcntstshot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 196,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= $vew_readonly?'0':'1'?>,
			colHeaders: [ "Estado inicial", "Rol", "Estado final", "Asignaci&oacute;n","Notificaci&oacute;n" ],
			columns: [
				{type: "autocomplete", data: "crmcntststxtstr", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
						$.ajax({
							url: "index.php?prg=crmcntsts&act=18", dataType: "json", data: {	prm_crmcntststxt: query },
              success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.crmcntststxt);
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
				{type: "text", data: "crmcntstsusrcod", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true ':''); ?>},
				{type: "autocomplete", data: "crmcntststxtend", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
						$.ajax({
							url: "?prg=crmcntsts&act=18", dataType: "json", data: {	prm_crmcntststxt: query },
              success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.crmcntststxt);
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
        {type: "text", data: "crmcntmtvstsusrasg", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "text", data: "crmcntmtvstsusrres", width: 100, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>}
			],
      afterChange: function(changes, source) {
      	if (changes && changes.length > 0 && source === 'edit') {
          const row = changes[0][0];
          const valueSelected = changes[0][3] || "";
          
          if (changes[0][1] === "crmcntststxtstr") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "crmcntstscod", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.crmcntststxt === valueSelected);
              if (selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "crmcntstscodstr", selectedItem.crmcntstscod);
              else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          }

          if (changes[0][1] === "crmcntststxtend") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "crmcntstscod", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.crmcntststxt === valueSelected);
              if (selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "crmcntstscodend", selectedItem.crmcntstscod);
              else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          }
        }
      },
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["crmcntmtvstscod"]!="" && lv_dat[i]["crmcntmtvstscod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			},
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotdoc;

		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
				$lv_buffer = '';
				foreach( $vew_data->crmcntmtvsts as $lv_row) {
					//usuario de asignación
          $lv_crmcntmtvstsusrasg = $vew_doc->getTagValue($lv_row['crmcntmtvstsatr'],'usrasg');
					//usuario de respuesta
          $lv_crmcntmtvstsusrres = $vew_doc->getTagValue($lv_row['crmcntmtvstsatr'],'usrres');
          
          $lv_buffer .= ($lv_buffer==''?'':', ').'{crmcntmtvcod: "'.$lv_row['crmcntmtvcod'].'",'.
																								 'crmcntstscodstr: "'.$lv_row['crmcntstscodstr'].'",'.
																								 'crmcntstsusrcod: "'.$lv_row['crmcntstsusrcod'].'",'.
																								 'crmcntstscodend: "'.$lv_row['crmcntstscodend'].'",'.
																								 'crmcntmtvstscod: "'.$lv_row['crmcntmtvstscod'].'",'.
																								 'crmcntmtvstsusrasg: "'.$lv_crmcntmtvstsusrasg.'",'.
            																		 'crmcntmtvstsusrres: "'.$lv_crmcntmtvstsusrres.'",'.
																								 'crmcntststxtstr: "'.$lv_row['crmcntststxtstr'].'",'.
																								 'crmcntststxtend: "'.$lv_row['crmcntststxtend'].'"'.
																								 '}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
  <script>
    //para que se cargue correctamente en la tabla de motivo de contacto
    $(function(){
    	$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab002']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
    });
  </script>
  <script>
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				var lv_arr = new Array();

				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"crmcntmtvstscod":<?= $lv_sec; ?>_hotdocdel[i]["crmcntmtvstscod"],
												"crmcntstscodstr":<?= $lv_sec; ?>_hotdocdel[i]["crmcntstscodstr"],
												"crmcntstsusrcod":<?= $lv_sec; ?>_hotdocdel[i]["crmcntstsusrcod"],
												"crmcntstscodend":<?= $lv_sec; ?>_hotdocdel[i]["crmcntstscodend"],
												"crmcntmtvstsusrasg":<?= $lv_sec; ?>_hotdocdel[i]["crmcntmtvstsusrasg"],
                       	"crmcntmtvstsusrres":<?= $lv_sec; ?>_hotdocdel[i]["crmcntmtvstsusrres"],
												"deleted":"X" });
				}
				
				// obtengo datos de handsontable de estado de motivo de contacto
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for (var i=0; i<lo_dat.length -1 ; i++) {
					if ( Object.keys(lo_dat[i]).length!=0 ) {
						lv_arr.push({	"crmcntmtvstscod":lo_dat[i]["crmcntmtvstscod"],
													"crmcntstscodstr":lo_dat[i]["crmcntstscodstr"],
													"crmcntstsusrcod":lo_dat[i]["crmcntstsusrcod"],
													"crmcntstscodend":lo_dat[i]["crmcntstscodend"],
													"crmcntmtvstsusrasg":lo_dat[i]["crmcntmtvstsusrasg"],
                         	"crmcntmtvstsusrres":lo_dat[i]["crmcntmtvstsusrres"]
												});
					}
				}
				$("#<?= $lv_sec; ?> #crmcntstshottxt").text( (lv_arr.length==0?"":JSON.stringify(lv_arr)) );
			}
		}
  </script>
  <!-- include del script -->
  <?php include('grldocfrmscr.frm'); ?>
</section>
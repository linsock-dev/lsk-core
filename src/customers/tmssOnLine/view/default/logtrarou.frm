<?php		
	// url del formulario
  $lv_lnk = "?prg=logtrarou&prm_traroucod=".$vew_data->traroucod;

	// campos requeridos
	$vew_input->RequiredFields( array('traroutxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->traroucod; 

	// titulo
	$lv_title = $vew_lang->route;
	
	// módulo y programa
	$lv_mdlcod = 'LOG';
	$lv_prgcod = 'ROU';
	
  // librería de estilos bootstrap
  include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml( 'tmss_actcod' , 'hidden', '' ); ?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->traroucod; ?><?= gethtml('traroucod','hidden',$vew_data->traroucod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                     <?= $lv_title; ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">                   
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 		'input'=>gethtml('traroucodext', 'doccmt1x20', $vew_data->traroucodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('traroutxt', 'doccmt1x50', $vew_data->traroutxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>   
						</div>
						<div class="col-md-6">
							<textarea class="hidden" id="trarouzon" name="trarouzon"></textarea>
							<div id="trarouzonhot" name="trarouzonhot"></div>
						</div>
					</div>
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if ( prop=='prftxt' ) {
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			} else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			}
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #trarouzonhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Zona" ],
			columns: [
				{type: "autocomplete", data: "trazontxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
						$.ajax({
							url: "?prg=logtrazon&act=18", dataType: "json", data: {	prm_trazontxt: query },
              success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.trazontxt);
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
        if (changes && changes.length > 0) {
          const row = changes[0][0];
          const valueSelected = changes[0][3] || "";
          if (changes[0][1]=="trazontxt"){
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "trazoncod", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.trazontxt === valueSelected);
              if (selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "trazoncod", selectedItem.trazoncod);
              else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          }
        }
      },
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["trarouzoncod"]!="" && lv_dat[i]["trarouzoncod"]!=undefined ) {
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
				foreach($vew_data->trarouzon as $lv_row){ 
          $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
            'trarouzoncod:"'.$lv_row['trarouzoncod'].'", '.
            'trazoncod:"'.$lv_row['trazoncod'].'", '.
            'trazontxt:"'.$lv_row['trazontxt'].'"'.
          '}';
        }
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
  <script>		
		// form submit externo
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      //Al grabar
			if ( lp_prm["action"]=="00" ) {
        var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
        var lv_arr = new Array();
        
        if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
        
        for (var i=0; i < lv_dat.length; i++) {
          if(lv_dat[i]["trazoncod"]!=undefined) {
            lv_arr.push({	"trarouzoncod":lv_dat[i]["trarouzoncod"],
                          "trazoncod":lv_dat[i]["trazoncod"],
                          "trazontxt":lv_dat[i]["trazontxt"],
                        });
          }
				}
        
        var lv_del = <?= $lv_sec; ?>_hotdocdel;
        for (var i=0; i < lv_del.length; i++) {
          lv_arr.push({	"trarouzoncod":lv_del[i]["trarouzoncod"],
                       	"trazoncod":lv_del[i]["trazoncod"],
                        "trazontxt":lv_del[i]["trazontxt"],
                   	   	"deleted":"X"
                      });
				}
        
        
      	if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #trarouzon").prop("value", "");						
				} else {
					$("#<?= $lv_sec; ?> #trarouzon").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section> 
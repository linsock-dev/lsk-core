<?php
	// url del formulario 
  $lv_lnk = '?prg=grldatzon&prm_objtyp='.$vew_data->objtyp;

	// campos requeridos 
	$vew_input->RequiredFields( array('objtyp') );

	// clave del documento 
	$lv_dockey = $vew_data->objtyp;

	// titulo 
	$lv_title = $vew_lang->zones;

	// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'ZON';

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <textarea id="adrzoncol" name="adrzoncol" class="hidden"></textarea>

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <!-- GENERAL -->
					<div class="row">
						<div class="col-md-4">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->object; ?></div></div>
								<div class="card-body">
									<?= vew_boot($lv_col210, array('label'=>$vew_lang->object, 'input'=>gethtml('objtyp','doccmt1x50', $vew_data->objtyp, ($vew_actcod=='01'?$lv_default:$lv_always_disabled) ) )); ?>
								</div>
							</div>
						</div>
						<div class="col-md-8">
							<div class="card tmss-card-hot">
								<div class="card-header"><div class="card-title"><?= $vew_lang->zones; ?></div></div>
								<div id="adrzonhot"></div>
							</div>
						</div>
          </div>
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
				if ( prop=="adrzontxt" || prop=="adrzoncodext") {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
        }else if ( prop=="docsts" ) {
					Handsontable.renderers.DropdownRenderer.apply(this, arguments);			
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				}
			}
		};

		var <?= $lv_sec; ?>_hotdocdel = [];
    var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #adrzonhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->zone; ?>", "<?= $vew_lang->ExternalCode; ?>", "<?= $vew_lang->status; ?>"],
			columns: [
        { type: "text", data: "adrzontxt", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
        { type: "text", data: "adrzoncodext", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
        { type: "dropdown", data: "docsts", width: 50, source:['Activo', 'Inactivo'], renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> }
			],
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["adrzoncod"]!="" && lv_dat[i]["adrzoncod"]!=undefined ) {
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
				$lv_buffer='';
				foreach($vew_data->list as $lv_row) {
					if( isset($lv_row['docsts']) ){
						$lv_docsts = ( $lv_row['docsts']=='A' ? 'Activo' : ( $lv_row['docsts']=='I' ? 'Inactivo' : '' ));
					}
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'vewfld_in_db: "X",'.
												'adrzoncod: "'.($lv_row['adrzoncod']??'').'" ,'.
												'adrzontxt:"'.($lv_row['adrzontxt']??'').'" ,'.
												'adrzoncodext: "'.($lv_row['adrzoncodext']??'').'" ,'.
												'docsts:"'.$lv_docsts.'"'.'}';
				} 
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
	<script>
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
       // al grabar
			if(lp_prm["action"]=="00"){
				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();

        // agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
          
          var docsts = (<?= $lv_sec; ?>_hotdocdel[i]["docsts"].trim() == "Inactivo" ? "I" : (<?= $lv_sec; ?>_hotdocdel[i]["docsts"].trim()=="Activo"?"A":""));	//Pasar deslpegable a letra
					lv_arr.push({	"adrzoncod":<?= $lv_sec; ?>_hotdocdel[i]["adrzoncod"],
												"adrzontxt":<?= $lv_sec; ?>_hotdocdel[i]["adrzontxt"],
          							"adrzoncodext":<?= $lv_sec; ?>_hotdocdel[i]["adrzoncodext"],
												"docsts":docsts,
												"deleted":"X"
											});
				}

        lv_vewfldbuffer = "/";
				for (var i=0; i<lo_dat.length-1; i++) {
          if(lv_vewfldbuffer.indexOf("/"+lo_dat[i]["adrzontxt"]+"/") !== -1){
            toastr.warning("No puede ingresar nombres duplicados.");
						return false;
          }
          lv_vewfldbuffer += lo_dat[i]["adrzontxt"]+"/";
          if(lo_dat[i]["adrzontxt"] == undefined || lo_dat[i]["docsts"] == undefined){
          	toastr.warning("Complete los campos de zona y estado.");
						return false;
          }

          if (lo_dat[i]["adrzontxt"]!="" && lo_dat[i]["adrzontxt"]!=undefined ){
          var docsts = (lo_dat[i]["docsts"].trim() == "Inactivo" ? "I" : (lo_dat[i]["docsts"].trim()=="Activo"?"A":""));	//Pasar deslpegable a letra
            lv_arr.push({	"adrzoncod":lo_dat[i]["adrzoncod"],
                          "adrzontxt":lo_dat[i]["adrzontxt"],
                          "adrzoncodext":lo_dat[i]["adrzoncodext"],
                          "docsts":docsts
                        });
					}
				}

				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #adrzoncol").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #adrzoncol").prop("value", JSON.stringify( lv_arr ) );
				}
			}
			
		}
  </script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
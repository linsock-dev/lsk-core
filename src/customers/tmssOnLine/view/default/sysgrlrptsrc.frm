<?php
	// url del formulario
  $lv_lnk = '?prg=sysgrlrptsrc';

	// campos requeridos
	$vew_input->RequiredFields( array('rptsrctxt','rptsrcsys','rptsrcsrc','rptsrctyp','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->rptsrccod;

	// titulo
	$lv_title = $vew_lang->reportsource;

	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'RPS';

	// librer?a de estilos bootstrap
	include_once('_library.frm');
	
	// si no tiene permiso para modificar origenes del sistema, anulo las opciones
  $lv_rptsrcsys_arr = array(); $lv_rptsrcsys_arr[1] = $vew_lang->user;
  $lv_rptsrctyp_arr = array(); $lv_rptsrctyp_arr['PR'] = $vew_lang->program;
	if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'05')){
		$lv_rptsrcsys_arr[0] = $vew_lang->system;
		$lv_rptsrctyp_arr['SP'] = 'StoredProcedure';
	} else if($vew_data->rptsrcsys==0){
    $lv_rptsrcsys_arr[0] = $vew_lang->system;
		$lv_rptsrctyp_arr['SP'] = 'StoredProcedure';
		$vew_tbl['modL'] = array('per'=>false);
		$vew_tbl['modR'] = array('per'=>false);
		$vew_tbl['cpy'] = array('per'=>false);
		$vew_tbl['delsep'] = array('per'=>false);
		$vew_tbl['del'] = array('per'=>false);
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<textarea class="hidden" id="rptcol"></textarea>

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->rptsrccod; ?><?= gethtml('rptsrccod', 'hidden', $vew_data->rptsrccod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <!-- GENERAL -->
					<div class="row">
						<div class="col-md-6">
							<div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->source; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('rptsrctxt', 'doccmt1x50', $vew_data->rptsrctxt, $lv_default) ));
                   	if (!$vew_readonly && $vew_data->rptsrccod != '') {
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 'input'=>gethtml('', 'doccmt1x50', ($vew_data->rptsrcsys == 0 ? $vew_lang->system : $vew_lang->user), $lv_always_disabled, true)));
                      echo gethtml('rptsrcsys', 'hidden', $vew_data->rptsrcsys);
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->class, 'input'=>gethtml('rptsrctyp', $lv_rptsrctyp_arr, $vew_data->rptsrctyp, $lv_default, true)));
                    } else {
											echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 'input'=>gethtml('rptsrcsys', $lv_rptsrcsys_arr, $vew_data->rptsrcsys, $lv_default, true)));
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->class, 'input'=>gethtml('rptsrctyp', $lv_rptsrctyp_arr, $vew_data->rptsrctyp, $lv_default, true)));
                    }
										echo vew_boot($lv_col210, array('label'=>$vew_lang->source,	'input'=>gethtml('rptsrcsrc', 'doccmt5x50', html_entity_decode($vew_data->rptsrcsrc), $lv_default) ));										
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, 		$lv_default) ));
                  ?>
                </div>
              </div>
						</div>
						<div class="col-md-6">
							<div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->columns; ?></div></div>
                <div class="card-body tmss-card-body-edit">
									<textarea class="hidden" id="rptcol" name="rptcol"></textarea>
									<div id="rptsrccolhot"></div>
                </div>
							</div>
						</div>
					</div><!-- /row -->
				</div><!-- /_tab001 -->
			</div><!-- /tab-content -->
    </div><!-- /container-fluid -->
  </form>
	<script>
    $(document).ready(function() {
      if ($("#<?= $lv_sec; ?> #rptsrcsys").val() == 1) {
        $("#<?= $lv_sec; ?> #rptsrctyp").empty().append($("<option>", { value: "PR", text: "<?= $vew_lang->program?>" }));
      }
      $("#<?= $lv_sec; ?> #rptsrcsys").on("change",function(){
        if ($(this).val() == 1) {
          $("#<?= $lv_sec; ?> #rptsrctyp").empty().append($("<option>", { value: "PR", text: "<?= $vew_lang->program?>" }));
        } else {
          $("#<?= $lv_sec; ?> #rptsrctyp").empty();
          $("#<?= $lv_sec; ?> #rptsrctyp").append($("<option>", { value: "PR", text: "<?= $vew_lang->program?>" }));
          $("#<?= $lv_sec; ?> #rptsrctyp").append($("<option>", { value: "SP", text: "StoredProcedure" }));
        }
      });
    });
  </script>
	<script>
    
		//	C O L U M N A S
		var <?= $lv_sec; ?>_hotcol_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
		};
		var <?= $lv_sec; ?>_hotcoltmpchg = [];
		var <?= $lv_sec; ?>_hotcoltmpdel = [];
		var <?= $lv_sec; ?>_hotcolcnt = $("#<?= $lv_sec; ?> #rptsrccolhot")[0];
		var <?= $lv_sec; ?>_hotcolset = {
			height: 196,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Cod", "CodInt", "Nombre", "DefCampo" ],
			columns: [
				{type: "text", data: "rptsrccolcodext", renderer: <?= $lv_sec; ?>_hotcol_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
        {type: "text", data: "rptsrccolcodint", renderer: <?= $lv_sec; ?>_hotcol_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "text", data: "rptsrccoltxt", renderer: <?= $lv_sec; ?>_hotcol_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "text", data: "rptsrccolatrdef", renderer: <?= $lv_sec; ?>_hotcol_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>}
			],
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotcol.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]['rptsrccolcod']!='' && lv_dat[i]['rptsrccolcod']!=undefined ) {
						<?= $lv_sec; ?>_hotcoltmpdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotcol;

		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotcol = new Handsontable(<?= $lv_sec; ?>_hotcolcnt, <?= $lv_sec; ?>_hotcolset);
			var lv_dat = [<?php
				$lv_buffer = '';
        foreach( $vew_data->col  as $lv_row) {
					$lv_buffer .= ($lv_buffer==''?'':', ').'{'
												.'rptsrccolcod: "'.$lv_row['rptsrccolcod'].'", '
												.'rptsrccolcodext: "'.$lv_row['rptsrccolcodext'].'", '
            						.'rptsrccolcodint: "'.$lv_row['rptsrccolcodint'].'", '
												.'rptsrccoltxt: "'.utf8_encode($lv_row['rptsrccoltxt']).'", '
												.'rptsrccolatrdef: "'.$vew_doc->getTagValue($lv_row['rptsrccolatr'], "def").'"}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotcol.loadData( lv_dat );
			<?= $lv_sec; ?>_hotcol.render();
		});
	</script>
  <script>
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				// obtengo datos de handsontable de roles
				var lo_dat = <?= $lv_sec; ?>_hotcol.getSourceData();
				var lv_arr = new Array();
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotcoltmpdel.length; i++) {
					lv_arr.push({	"rptsrccolcod":<?= $lv_sec; ?>_hotcoltmpdel[i]["rptsrccolcod"], "deleted":"X" });
				}
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["rptsrccolcodext"]!="" && lo_dat[i]["rptsrccolcodext"]!=undefined ){
						lv_arr.push({	"rptsrccolcod":lo_dat[i]["rptsrccolcod"],
													"rptsrccolcodext":lo_dat[i]["rptsrccolcodext"],
                         	"rptsrccolcodint":lo_dat[i]["rptsrccolcodint"],
													"rptsrccoltxt":lo_dat[i]["rptsrccoltxt"],
													"rptsrccolatrdef":lo_dat[i]["rptsrccolatrdef"]
												});
					}
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #rptcol").text("");
				} else {
          let visualizar = JSON.stringify(lv_arr);
          const removeAccents = (str) => {
  					return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
					}
          var cadena = removeAccents(visualizar);
          $("#<?= $lv_sec; ?> #rptcol").text( cadena );
				}
			}
		}
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
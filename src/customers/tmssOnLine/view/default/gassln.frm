<?php		
	// url del formulario
  $lv_lnk = '?prg=gassln&prm_slncod='.$vew_data->slncod;

	// campos requeridos
	$vew_input->RequiredFields( array('slntxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->slncod; 

	// titulo
	$lv_title = $vew_lang->salon;
	
	// modulo y programa
	$lv_mdlcod = 'GAS';
	$lv_prgcod = 'SLN';
	
	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  
	<!-- Nav-bar -->
  <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->slncod; ?><?= gethtml('slncod','hidden',$vew_data->slncod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
						<div class='col-md-6'>
							<div class="card">
								<div class="card-header"><?= $vew_lang->saloon; ?></div>
								<div class="card-body tmss-card-body-edit">
                  <?php
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 'input'=>gethtml('slntyp', array('D'=>'Delivery','S'=>'Salon','K'=>'Kiosco'), $vew_data->slntyp, $lv_default, true) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->saloontable, 'input'=>gethtml('slncodext', 'doccmt1x20',$vew_data->slncodext,$lv_default) ));
                  	/*echo vew_boot($lv_col210, array("label"=>$vew_lang->waiter,
                                                    "input1"=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly ),
                                                                        array('input'=>gethtml('slsordmzo', 'typeahead', $vew_data->slsordmzo, $lv_default ) )) )); */
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('slntxt', 'doccmt1x50',$vew_data->slntxt , $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
								</div>
							</div>  <!-- /card -->
						</div> <!-- /col -->     
            <div class="col-md-6">
              <div class="card">
                <div class="card-header"><?= $vew_lang->data; ?></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->customer,
																										'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly),
																																			array('input'=>gethtml('custxt', 'doccmt1x50',$vew_data->custxt,$lv_default))
																									)));
										echo gethtml('cuscod','hidden',$vew_data->cuscod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->storelocation, 
																										'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly),
																																			array('input'=>gethtml('strloctxt', 'doccmt1x50',$vew_data->strloctxt,$lv_default))
																									)));
										echo gethtml('strloccod','hidden',$vew_data->strloccod);
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->order,
																										'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly),
 																																			array('input'=>gethtml('sysdocclstxt_ord', 'doccmt1x50',$vew_data->sysdocclstxt_ord,$lv_default)) 
																									)));
										echo gethtml('sysdocclscod_ord','hidden',$vew_data->sysdocclscod_ord);
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->stock,
																										'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly),
																																			array('input'=>gethtml('sysdocclstxt_stk', 'doccmt1x50',$vew_data->sysdocclstxt_stk,$lv_default))
																									)));
										echo gethtml('sysdocclscod_stk','hidden',$vew_data->sysdocclscod_stk);
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->pricelist,
																										'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly),
																																			array('input'=>gethtml('slsprclsttxt', 'doccmt1x50',$vew_data->slsprclsttxt,$lv_default))
																									)));
										echo gethtml('slsprclstcod','hidden',$vew_data->slsprclstcod);
                  ?>
                </div>
              </div> <!-- /card -->
              <div class="card">
                <div class="card-header"><?= $vew_lang->saloontables; ?></div>
                <div class="card-body tmss-card-body-edit">
                  <div id="slntblsht" name="slntblsht"></div>
                  <textarea class="d-none" id="slntbls" name="slntbls"></textarea> 
                  <textarea class="d-none" id="slntblsdel" name="slntblsdel"></textarea> 
                </div>
              </div> <!-- /card -->
            </div> <!-- /col -->
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"cuscod":"cuscod", "custxt":"custxt"}};
		tmssTypeahead($("#<?= $lv_sec; ?> #custxt"), "slscus", lo_get);

		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"strloccod":"strloccod", "strloctxt":"strloctxt"}};
		tmssTypeahead($("#<?= $lv_sec; ?> #strloctxt"), "stkstrloc", lo_get);

		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"sysdocclscod_ord":"sysdocclscod", "sysdocclstxt_ord":"sysdocclstxt"}};
		tmssTypeahead($("#<?= $lv_sec; ?> #sysdocclstxt_ord"), "sysdoccls", lo_get);
		
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"sysdocclscod_stk":"sysdocclscod", "sysdocclstxt_stk":"sysdocclstxt"}};
		tmssTypeahead($("#<?= $lv_sec; ?> #sysdocclstxt_stk"), "sysdoccls", lo_get);
		
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"slsprclstcod":"slsprclstcod", "slsprclsttxt":"slsprclsttxt"}};
		tmssTypeahead($("#<?= $lv_sec; ?> #slsprclsttxt"), "slsprc", lo_get);
	</script>
  <script>
		// Handsontable for tables
		var <?= $lv_sec; ?>_slntbl_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if ( prop=="slntblcodext" || prop=="slntblqty") {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);			
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_slntbldel = [];
		var <?= $lv_sec; ?>_slntblcnt = $("#<?= $lv_sec; ?> #slntblsht")[0];
		var <?= $lv_sec; ?>_slntblset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: true,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly ?'0':'1') ?>,
			colHeaders: [ "Mesa","N&uacute;mero de personas " ],
			//language: 'es-AR',
			columns: [
				{ type: "numeric", data: "slntblcodext", numericFormat: {pattern: "0", culture: "es-AR"}, width: 100, renderer: <?= $lv_sec; ?>_slntbl_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
				{ type: "numeric", data: "slntblqty", numericFormat: {pattern: "0", culture: "es-AR"}, width: 100, renderer: <?= $lv_sec; ?>_slntbl_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
			],
			beforeRemoveRow: function(index, changes, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_slntbl.getSourceData();
				for( var i=index; i<=index+changes-1; i++){
					if ( lv_dat[i]["slntblcod"]!="" && lv_dat[i]["slntblcod"]!=undefined) {
						<?= $lv_sec; ?>_slntbldel.push(lv_dat[i]["slntblcod"]);
					} 
				}
			},
		};
		var <?= $lv_sec; ?>_slntbl;
		
		// cargo datos en handsontable
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_slntbl = new Handsontable(<?= $lv_sec; ?>_slntblcnt, <?= $lv_sec; ?>_slntblset);
			var lv_dat = [<?php
				$lv_buffer='';
				if(is_array($vew_data->slntbls)){
					foreach($vew_data->slntbls as $lv_row){ 
						$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'slntblcod:"'.$lv_row['slntblcod'].'",'.
												'slntblcodext:"'.$lv_row['slntblcodext'].'",'.
												'slntblqty:"'.$lv_row['slntblqty'].'"'.
												'}'; 
					}
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_slntbl.loadData( lv_dat );
			<?= $lv_sec; ?>_slntbl.render();
		});

	</script>
	<script>
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// get data from handsontable
			var lo_dat = <?= $lv_sec; ?>_slntbl.getSourceData();
			var lv_arr = new Array();
			for (var i=0; i<lo_dat.length; i++) {
				if ( lo_dat[i]["slntblcodext"]!=undefined && lo_dat[i]["slntblqty"]!=undefined ) {
						lv_arr.push({	"slntblcod":lo_dat[i]["slntblcod"] != undefined ? lo_dat[i]["slntblcod"] : "",
													"slntblcodext":lo_dat[i]["slntblcodext"] != undefined ? lo_dat[i]["slntblcodext"] : "",
													"slntblqty":lo_dat[i]["slntblqty"] != undefined ? lo_dat[i]["slntblqty"] : "",
													"deleted":""
												});
					}
			}
			// get deleted dates 
			for(i=0; i< <?= $lv_sec; ?>_slntbldel.length; i++){
				lv_arr.push({	"slntblcod":<?= $lv_sec; ?>_slntbldel[i] , "slntblcodext":"","slntblqty":"", "deleted":"x"});
			}
			if (lv_arr.length==0) {
				$("#<?= $lv_sec; ?> #slntbls").prop("value", "");
			} else {
				$("#<?= $lv_sec; ?> #slntbls").prop("value", JSON.stringify( lv_arr ) );
			}
		}
	</script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
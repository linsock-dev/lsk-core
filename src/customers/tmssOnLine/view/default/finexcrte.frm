<?php		
	// url del formulario 
  $lv_lnk = "?prg=finexcrte&prm_excrteclscod=".$vew_data->excrteclscod.'&prm_curcodsrc='.$vew_data->curcodsrc.'&prm_curcoddst='.$vew_data->curcoddst;

	// campos requeridos 
	$vew_input->RequiredFields( array('excrteclscod','curcodsrc','curcoddst', 'docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->excrteclscod; 

	// titulo 
	$lv_title = $vew_lang->exchangerate;
	
	// módulo y programa 
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'EXR';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
	
	// Botones x VISTA
	$vew_tbl['cpy'] = array('per'=>false);
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden','')?>
		    
    <div class="container-fluid" role="tabpanel">
   		<!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                  <?php 
                   	echo vew_boot($lv_col210, array('label'=>$vew_lang->class, 
                                                   	'input'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->excrteclscod==''?$vew_readonly:true)),
                                                                      	array('input'=>gethtml('excrteclstxt', 'typeahead', $vew_data->excrteclstxt, ($vew_data->excrteclscod==''?$lv_default:$lv_always_disabled) ) )) ));
                    echo '<input type="hidden" id="excrteclscod" name="excrteclscod" value="'.$vew_data->excrteclscod.'">';
                    echo vew_boot($lv_col2424, array('label1'=>$vew_lang->from,
                      															 'input1'=>vew_boot( array('style'=>'search', 'readonly'=>($vew_data->excrteclscod==''?$vew_readonly:true)),
                                                                      	 array('label'=>$vew_lang->from, 'input'=>gethtml('curcodsrc', 'curcod', $vew_data->curcodsrc, $lv_always_disabled ) )),
                                                   	 'label2'=>$vew_lang->to,
                                                     'input2'=>vew_boot( array('style'=>'search', 'readonly'=>($vew_data->excrteclscod==''?$vew_readonly:true)), 
                                                                      	 array('label'=>$vew_lang->to, 'input'=>gethtml('curcoddst', 'curcod', $vew_data->curcoddst, $lv_always_disabled ) ))
                                                   ));
                  ?>
                </div>
              </div>
						</div>
						<div class="col-md-6">
              <div class="card tmss-hot-ttl">
              	<div class="card-header">
                	<div class="card-title"><?= $vew_lang->data; ?>
                  	<span class="tmss-card-icon"><i class="far fa-money-bill-alt"></i></span>
                  </div>
								</div>
              </div>
              <textarea id="finexcrte" name="finexcrte" class="hidden"></textarea>
							<div id="excrtesht"></div>
						</div>
					</div>
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
		var <?= $lv_sec; ?>_hotexc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			var lv_excrtecod = "";
			if (<?= $lv_sec; ?>_hotexc!=undefined) {
				lv_excrtecod = <?= $lv_sec; ?>_hotexc.getDataAtRowProp(row,"excrtecod");
				if(lv_excrtecod==null){lv_excrtecod="";}
			}
			if ( prop=="excrtedtefrm" ) {
				Handsontable.renderers.DateRenderer.apply(this, arguments);			
				td.style.backgroundColor = (lv_excrtecod!=""?"#F1F1F1":"#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>");
				if(lv_excrtecod!=""){cellProperties.readOnly = true;}
			} else if ( prop=="excrte"  ) {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);			
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else if ( prop=="excrtedstqty" ) {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);			
				td.style.backgroundColor = (lv_excrtecod!=""?"#F1F1F1":"#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>");
				if(lv_excrtecod!=""){cellProperties.readOnly = true;}
			}
		};
		var <?= $lv_sec; ?>_hotexcdel = [];
		var <?= $lv_sec; ?>_hotexccnt = $("#<?= $lv_sec; ?> #excrtesht")[0];
		var <?= $lv_sec; ?>_hotexcset = {
			height: 396,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Fecha","Tpo.Cambio","Cant" ],
			columns: [
				{ type: "date", data: "excrtedtefrm", renderer: <?= $lv_sec; ?>_hotexc_renderer <?= ($vew_readonly?', readOnly: true':''); ?>,
					dateFormat: 'DD/MM/YYYY',
					correctFormat: true,
					allowEmpty: false,
					datePickerConfig: {
						firstDay: 0,
						showWeekNumber: false,
						numberOfMonths: 1
					}
				},
				{ type: "numeric", data: "excrte", numericFormat: {pattern: "0.00000", culture: "es-AR"}, width: 100, renderer: <?= $lv_sec; ?>_hotexc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
				{	type: "numeric", data: "excrtedstqty", numericFormat: {pattern: "0.00", culture: "es-AR"}, width: 50, renderer: <?= $lv_sec; ?>_hotexc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> }
			],
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotexc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["excrtecod"]!="" && lv_dat[i]["excrtecod"]!=undefined ) {
						<?= $lv_sec; ?>_hotexcdel.push( lv_dat[i] );
					}
				}
			},
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotexc;
		
		// cargo datos en handsontable
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotexc = new Handsontable(<?= $lv_sec; ?>_hotexccnt, <?= $lv_sec; ?>_hotexcset);
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->finexcrte as $lv_row) { 
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'excrtecod:"'.$lv_row['excrtecod'].'",'.
												'excrtedtefrm:"'.$lv_row['excrtedtefrmcnv'].'",'.
												'excrte: '.$lv_row['excrte'].' ,'.
												'excrtedstqty: '.$lv_row['excrtedstqty'].'}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotexc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotexc.render();		
		});
	</script>
  <script>
    // excrteclstxt
    var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldasg" : {"excrteclscod" : "excrteclscod", "excrteclstxt" : "excrteclstxt"} }; 
    tmssTypeahead($("#<?= $lv_sec; ?> #excrteclstxt"), "finexcrtecls", lo_get);
                  
    // curcodsrc
   	var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldasg" : {"curcodsrc" : "curcod"}, "typeahead":false }; 
    tmssTypeahead($("#<?= $lv_sec; ?> #curcodsrc"), "admcur", lo_get);

    // curcoddst
   	var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldasg" : {"curcoddst" : "curcod"}, "typeahead":false }; 
    tmssTypeahead($("#<?= $lv_sec; ?> #curcoddst"), "admcur", lo_get);
	</script>
  <script>		
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {				
			// al grabar
			if ( lp_prm["action"]=="00" ) {
			
				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotexc.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["excrtedtefrm"]!="" && lo_dat[i]["excrtedtefrm"]!=undefined ) {
						lv_arr.push({	"excrtecod":lo_dat[i]["excrtecod"],
													"excrtedtefrm":lo_dat[i]["excrtedtefrm"],
													"excrte":lo_dat[i]["excrte"],
													"excrtedstqty":lo_dat[i]["excrtedstqty"]
												});
					}
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotexcdel.length; i++) {
					lv_arr.push({	"excrtecod":<?= $lv_sec; ?>_hotexcdel[i]["excrtecod"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #finexcrte").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #finexcrte").prop("value", JSON.stringify( lv_arr ) );
				}
									
			}
		}
  </script>
	<!-- Form Submit -->
	<?php include('grldocfrmscr.frm'); ?>
</section>
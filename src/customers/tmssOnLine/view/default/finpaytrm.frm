<?php		
	// url del formulario 
  $lv_lnk = '?prg=finpaytrm&prm_paytrmcod='.$vew_data->paytrmcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('paytrmtxt','paytrmbseduedte','paytrmatrman','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->paytrmcod; 

	// titulo 
	$lv_title = $vew_lang->paymentsterm;
	
	// mÃ³dulo y programa 
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'PYT';
	
	// librer&iacute;a de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden','')?>
		<textarea class="hidden" id="paytrmdue" name="paytrmdue"></textarea>
		
    <div class="container-fluid" role="tabpanel">
			<!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->paytrmcod; ?><?= gethtml('paytrmcod','hidden',$vew_data->paytrmcod) ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
            	<div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">   
                  <?php 
                    echo vew_boot($lv_colsm210, array('label'=>$vew_lang->code, 			'input'=>gethtml('paytrmcodext','doccmt1x20', $vew_data->paytrmcodext,$lv_default) ));
                    echo vew_boot($lv_colsm210, array('label'=>$vew_lang->description,'input'=>gethtml('paytrmtxt', 	'doccmt1x50', $vew_data->paytrmtxt, 	$lv_default) ));
                    echo vew_boot($lv_colsm210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 			'docsts', 		$vew_data->docsts, 			$lv_default) ));
                  ?>
                </div>
              </div>
						</div>
						<div class="col-md-6">
            	<div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->data; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_colsm210, array('label'=>$vew_lang->group,	'input'=>gethtml('paytrmgrp', 	'paytrmgrp_lst', $vew_data->paytrmgrp, 	$lv_default) ));
                    echo vew_boot($lv_colsm210, array('label'=>'Fecha Base',			'input'=>gethtml('paytrmbseduedte', array(''=>'','C'=>'Contabilizaci&oacute;n','I'=>'Creaci&oacute;n','D'=>'Documento','L'=>'&Uacute;ltimo D&iacute;a del Mes','F'=>'Primer D&iacute;a del Mes Siguiente','X'=>'D&iacute;a Fijo','Z'=>'Personalizado'), $vew_data->paytrmbseduedte, $lv_default, true) ));
                    echo vew_boot($lv_colsm210, array('label'=>$vew_lang->program,'input'=>gethtml('paytrmbseduedtefnc', 	'doccmt1x250', $vew_data->paytrmbseduedtefnc, 	$lv_default) ));
                    echo vew_boot( array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->manual,	'input'=>gethtml('PayTrmAtrMan', 'checkbox', $vew_doc->getTagValue($vew_data->paytrmatr,'man'), 	$lv_default) ));
                  ?>
                </div>
              </div>
							<div id="paytrmduehot"></div>
						</div>
					</div>
				</div> <!-- fin _tab001 -->
				
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
				if ( prop=="paytrmdueamt" || prop=="paytrmdueqty" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);			
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				} else if ( prop=="paytrmduetyp" ) {
					Handsontable.renderers.DropdownRenderer.apply(this, arguments);			
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				}
			}
		};
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #paytrmduehot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Porcentaje","Tipo","Cant" ],
			columns: [
				{ type: "numeric", data: "paytrmdueamt", numericFormat: {pattern: "0.00", culture: "es-AR"}, width: 100, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
				{ type: "dropdown", data: "paytrmduetyp", source: ["Dia", "Mes", "<?= utf8_decode('Año'); ?>"], width: 100, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
				{	type: "numeric", data: "paytrmdueqty", numericFormat: {pattern: "0", culture: "es-AR"}, width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> }
			],
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["paytrmduecod"]!="" && lv_dat[i]["paytrmduecod"]!=undefined ) {
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
				foreach($vew_data->due as $lv_row) { 
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'paytrmduecod:"'.$lv_row['paytrmduecod'].'",'.
												'paytrmdueamt: '.$lv_row['paytrmdueamt'].' ,'.
												'paytrmduetyp:"'.($lv_row['paytrmduetyp']=='1'?'Dia':($lv_row['paytrmduetyp']=='30'?'Mes':($lv_row['paytrmduetyp']=='365'?utf8_decode('Año'):''))).'",'.
												'paytrmdueqty: '.$lv_row['paytrmdueqty'].'}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
  <script>
		// Function to validate handson table before submit
		function <?= $lv_sec; ?>_hotvalidate(  ) {
			var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
			var paytrmdueamtsum = 0;
			for (var i=0; i<lo_dat.length-1; i++) {
				if ( lo_dat[i]["paytrmdueamt"]==undefined || lo_dat[i]["paytrmduetyp"]==undefined || lo_dat[i]["paytrmdueqty"]==undefined || 
						 lo_dat[i]["paytrmdueamt"]=="" || lo_dat[i]["paytrmduetyp"]=="" ) {
					toastr.warning('Complete los datos de la fila ' + (i+1));
					return false;
				}
				paytrmdueamtsum += lo_dat[i]["paytrmdueamt"] != undefined ? lo_dat[i]["paytrmdueamt"] : 0;
			}
			if($("td").hasClass('htInvalid')){
					toastr.warning('Verifique los datos de la tabla');
					return false;
			}
			return true;
		}
  </script>
	<script>	
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      
			// guardar
			if(lp_prm["action"]=="00"){
        // validar la tabla antes de guardar
      	if (!<?= $lv_sec; ?>_hotvalidate()) { return false; }
				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["paytrmdueamt"]!="" && lo_dat[i]["paytrmdueamt"]!=undefined ) {
						lv_arr.push({	"paytrmduecod":lo_dat[i]["paytrmduecod"] != undefined ? lo_dat[i]["paytrmduecod"] : "",
													"paytrmdueamt":lo_dat[i]["paytrmdueamt"] != undefined ? lo_dat[i]["paytrmdueamt"] : "",
													"paytrmduetyp":lo_dat[i]["paytrmduetyp"]=="Dia"?1:lo_dat[i]["paytrmduetyp"]=="Mes"?30:lo_dat[i]["paytrmduetyp"]== "<?= utf8_decode("Año") ?>"?365:"",
													"paytrmdueqty":lo_dat[i]["paytrmdueqty"] != undefined ? lo_dat[i]["paytrmdueqty"] : "",
													"deleted":""
												});
					}
				}
	
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"paytrmduecod":<?= $lv_sec; ?>_hotdocdel[i]["paytrmduecod"],
												"paytrmdueamt":"",
												"paytrmduetyp":"",
												"paytrmdueqty":"",
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #paytrmdue").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #paytrmdue").prop("value", JSON.stringify( lv_arr ) );
				}

				// Validate that sum(paytrmdueamt)=100 or 0
				if(!<?= $lv_sec; ?>_hotvalidate()){
					return;
				}
			}
		}
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
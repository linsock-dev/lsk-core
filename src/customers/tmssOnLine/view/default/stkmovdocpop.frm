<?php
	/* url del formulario */
  $lv_lnk = "?prg=stkmovdoc&prm_stkmovdoc=".$vew_data->stkmovdoccod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('stkmovdocdte') );

	/* clave del documento */
	$lv_dockey = $vew_data->patcod; 

	/* titulo */
	$lv_title = $vew_lang->patient;
	
	/* m?dulo y programa */
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'MOV';

	/* librer?a de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">

		<textarea style="display: none;" id="stkmovdocmat" name="stkmovdocmat"></textarea>
              
		<!-- GENERAL -->
		<div class="container-fluid">
		
			<div class="row">
				<div class="col-md-8">
					<?php 
						echo vew_boot($lv_col237, array('label'=>$vew_lang->class
																						,'input1'=>gethtml('sysdocclscod', 'doccod', $vew_data->sysdocclscod, $lv_always_disabled)
																						,'input2'=>gethtml('sysdocclstxt', 'doccmt1x50', $vew_data->sysdocclstxt, $lv_always_disabled) ));
					?>
					<div class="row">
						<label class="control-label col-md-2"><?= $vew_lang->from; ?></label>
						<div class="col-md-10">
							<?php
								echo '<input type="hidden" id="srcobjtyp" name="srcobjtyp" value="STK_STL">';
								echo vew_boot($lv_col237, array("label"=>$vew_lang->storelocation, 	
																								"input1"=>vew_boot(	array("style"=>"search", "readonly"=>$vew_readonly), 
																																		array("input"=>gethtml("srcobjcod", "strloccod", $vew_data->srcobjcod, $lv_default) )),
																								"input2"=>gethtml("srcobjtxt", "strloctxt", $vew_data->srcobjtxt, $lv_always_disabled) )); 
							?>
						</div>
					</div>
					<div class="row">
						<label class="control-label col-md-2"><?= $vew_lang->to; ?></label>
						<div class="col-md-10">
							<?php
								echo '<input type="hidden" id="dstobjtyp" name="dstobjtyp" value="HLT_PAT">';
								echo '<input type="hidden" id="dstobjcod" name="dstobjcod" value="'.$vew_data->dstobjcod.'">';
								echo vew_boot($lv_col210, array("label"=>$vew_lang->patient,
																				"input1"=>vew_boot(	array("style"=>"search", "readonly"=>$vew_readonly),
																														array("input"=>gethtml("dstobjtxt", "doccmt1x50", $vew_data->dstobjtxt,$lv_default) )) ));
							?>
						</div>
					</div>
					<?= vew_boot($lv_col210, array("label"=>$vew_lang->comments,	"input"=>gethtml("stkmovdoccmt",	"doccmt1x50",$vew_data->stkmovdoccmt,$lv_default) )); ?>
				</div>
				<div class="col-md-4">
					<?php 
						echo vew_boot($lv_col210, array("label"=>$vew_lang->id, 		"input"=>gethtml("stkmovdoccod",		"doccod",		$vew_data->stkmovdoccod,	$lv_always_disabled) ));
						echo vew_boot($lv_col210, array("label"=>$vew_lang->date, 	"input"=>gethtml("stkmovdocdte",		"docdte",		$vew_data->stkmovdocdte,	$lv_default) ));
						echo vew_boot($lv_col210, array("label"=>$vew_lang->number,	"input"=>gethtml("stkmovdoccodext",	"doccmt1x20",$vew_data->stkmovdoccodext,$lv_default) ));
						echo vew_boot($lv_col210, array("label"=>$vew_lang->locked, "input"=>gethtml("stkmovdoclck",		"yesno",		$vew_data->stkmovdoclck,	$lv_default) ));
						echo vew_boot($lv_col210, array("label"=>$vew_lang->status,	"input"=>gethtml("docsts", 					"stkdocsts",$vew_data->docsts, 				$lv_always_disabled) ));
						// -- COMENTARIOS --								
					?>
				</div>
			</div>
			<div id="stkmovdocmathot" name="stkmovdocmathot"></div>
			
		</div> <!-- container-fluid -->
  </form>
	<script>
		/**
		 *
		 *	M A T E R I A L E S
		 *
		 */
		var <?= $lv_sec; ?>_hotmat_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if ( prop=='mattxt' ) {
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			} else if ( prop=='matqty' ) {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);			
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			} else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			}
		};
		var <?= $lv_sec; ?>_hotmatchg = [];
		var <?= $lv_sec; ?>_hotmatdel = [];
		var <?= $lv_sec; ?>_hotmatcnt = $("#<?= $lv_sec; ?> #stkmovdocmathot")[0];
		var <?= $lv_sec; ?>_hotmatset = {
			height: 196,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Codigo", "Denominacion", "Cantidad", "UM", "Lote", "Vto", "Nro Serie" ],
			columns: [
				{type: "text", data: "matcod", renderer: <?= $lv_sec; ?>_hotmat_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "autocomplete", data: "mattxt", renderer: <?= $lv_sec; ?>_hotmat_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "numeric", data: "matqty", width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "matuntcod", width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly?', readOnly: true':'');	?> },
				{type: "text", data: "matbchcodext", width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly?', readOnly: true':'');	?> },
				{type: "date", data: "matbchduedte", width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly?', readOnly: true':'');	?> },
				{type: "text", data: "matsercodext",width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly?', readOnly: true':'');	?> }
			],
		};
		var <?= $lv_sec; ?>_hotmat;

		tmssLoadScript("handsontable", function(){
			<?= $lv_sec; ?>_hotmat = new Handsontable(<?= $lv_sec; ?>_hotmatcnt, <?= $lv_sec; ?>_hotmatset);	
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->stkmovdocmat as $lv_row){ 
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'stkmovdocmatcod:"'.$lv_row['stkmovdocmatcod'].'",'.
												'matcod:"'.$lv_row['matcod'].'",'.
												'mattxt:"'.$lv_row['mattxt'].'",'.
												'matqty: '.$lv_row['matqty'].' ,'.
												'matuntcod:"'.$lv_row['matuntcod'].'",'.
												'matbchcodext:"'.$lv_row['matbchcodext'].'",'.
												'matbchduedte:"'.$lv_row['matbchduedtecnv'].'",'.
												'matsercodext:"'.$lv_row['matsercodext'].'"}'; }
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotmat.loadData( lv_dat );
			<?= $lv_sec; ?>_hotmat.render();
		});
	</script>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";

		// edit mode
    tmssFormEdit('<?= $lv_sec; ?>',<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	</script>
</section>
</section>
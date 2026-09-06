<?php		
	// url del formulario 
  $lv_lnk = '?prg=stkmatidt';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->conversion;
	
	// módulo y programa 
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'MAT';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');

	// id de sección 
	$lv_sec = ( ($vew_oldSec??'')!='' ? $vew_oldSec : $lv_sec );
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>

		<div class="containter-fluid">
			<div class="row">
				<div class="col-md-12">
          <?= gethtml('matcod','hidden',$vew_data->matcod); ?>
					<textarea id="matidt" name="matidt" class="hidden"></textarea>
					<div id="matidthot"></div>
				</div>
			</div>
		</div>
		
	</form>
	<script>
		// O B J E T O S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if (prop=="matidtuntcod" || prop=="matidtcodext") { 
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];		
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #matidthot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Identificacion", "Cantidad", "UM", "Ctdad.Base" ],
			columns: [
				{type: "text", data: "matidtcodext", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "numeric", data: "matidtqty", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "autocomplete", data: "matidtuntcod", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "?prg=stkmatunt&act=18", dataType: "json", data: {	prm_matuntcod: query }, minLength: 1,
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
							success: function (response) {
								var lv_dat = [];
								for (var i=0; i < response.data.length; i++) {
									lv_dat.push( response.data[i]["matuntcod"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				},
				{type: "numeric", data: "matbseqty", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} }
			],
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotdocerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotdocerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotdocerr.splice(lv_inx,1); }	
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotobj.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["matidtcod"]!="" && lv_dat[i]["matidtcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotobj;	
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotobj = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [<?php
				$lv_buffer = '';
				foreach( $vew_data->matidtlst as $lv_row) {
					$lv_buffer .= ($lv_buffer==''?'':', ').
						'{matidtcod: "'.$lv_row['matidtcod'].'", '.
						'matidtqty: '.$lv_row['matidtqty'].' ,'.
						'matidtuntcod: "'.$lv_row['matidtuntcod'].'", '.
						'matbseqty: '.$lv_row['matbseqty'].' ,'.
						'matidtcodext: "'.$lv_row['matidtcodext'].'"}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotobj.loadData( lv_dat );
			<?= $lv_sec; ?>_hotobj.render();
		});
	</script>
	<script>
		$(function(e){ tmssHandsontableResize(); });
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>,"#buscod");
	</script>
</section>
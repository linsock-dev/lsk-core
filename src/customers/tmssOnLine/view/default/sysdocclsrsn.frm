<?php
	// url del formulario 
  $lv_lnk = '?prg=sysdocclsrsn';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->orderreasons;
	
	// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'DOC';

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>"> 
  <a href="#" id="btnsubmit" class="hidden" onclick="<?= $lv_sec; ?>_fnc({action: '00'});"></a>
	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
		<div class="containter-fluid">
      <?= gethtml('sysdocclscod','hidden',$vew_data->sysdocclscod); ?>
      <textarea id="sysdocrsn" name="sysdocrsn" class="hidden"></textarea>
      <div id="sysdocrsnhot"></div>
    </div>
	</form>
	<script>
		// O B J E T O S 
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if (prop=="sysdocrsntxt") { 
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";				
			}
			
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];		
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #sysdocrsnhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Motivo", "Orden", "Manual" ],
			columns: [
				{type: "autocomplete", data: "sysdocrsntxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>				
					source: function (query, process) {
						$.ajax({
							url: "index.php?prg=sysdocrsn&act=18", dataType: "json", data: {	prm_objtyp: "<?= $vew_data->objtyp; ?>", prm_sysdocclscod: "<?= $vew_data->sysdocclscod; ?>", prm_sysdocrsntxt: query },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); exit();}},
							success: function (response) {
								// guardo todos los datos adicionales en una variable temporal
								var lv_dat = [];
								<?= $lv_sec; ?>_hotdocchg = [];
								for (var i=0; i < response.length; i++) {
									<?= $lv_sec; ?>_hotdocchg.push( {sysdocrsntxt: response[i]["sysdocrsntxt"], sysdocrsncod: response[i]["sysdocrsncod"]} );
									lv_dat.push( response[i]["sysdocrsntxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				},
				{type: "text", data: "sysdocclsrsnord", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "text", data: "sysdocclsrsnman", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>}
			],
			beforeChange : function(changes, source) {
				// asigno los datos adicionales a la fila
				if(source=="edit" && changes[0][1]=="sysdocrsntxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].sysdocrsntxt == lv_value) {
							changes.push([ changes[0][0], "sysdocrsncod", "", String(<?= $lv_sec; ?>_hotdocchg[i].sysdocrsncod) ]);
						}
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
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotobj.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["sysdocclsrsncod"]!="" && lv_dat[i]["sysdocclsrsncod"]!=undefined ) {
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
				foreach( $vew_data->docrsn as $lv_row) {
					$lv_buffer .= ($lv_buffer==''?'':', ').'{sysdocclsrsncod: "'.$lv_row['sysdocclsrsncod'].'", sysdocrsncod: "'.$lv_row['sysdocrsncod'].'", sysdocrsntxt: "'.$lv_row['sysdocrsntxt'].'", sysdocclsrsnord: "'.$vew_doc->getTagValue($lv_row['sysdocclsrsnatr'],'rsnord').'", sysdocclsrsnman: "'.$vew_doc->getTagValue($lv_row['sysdocclsrsnatr'],'rsnman').'"}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotobj.loadData( lv_dat );
			<?= $lv_sec; ?>_hotobj.render();
		});
	</script>
	<script>
		$(function(e){ tmssHandsontableResize(); });

		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if (lp_prm["action"]=="00") {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
				
				// obtengo datos de handsontable de roles
				var lo_dat = <?= $lv_sec; ?>_hotobj.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["sysdocrsncod"]!="" && lo_dat[i]["sysdocrsncod"]!=undefined ){
						lv_arr.push({	"sysdocclsrsncod":lo_dat[i]["sysdocclsrsncod"],
													"sysdocclscod":$("#<?= $lv_sec; ?> #sysdocclscod").prop("value"),
													"sysdocrsncod":lo_dat[i]["sysdocrsncod"],
													"sysdocclsrsnord":lo_dat[i]["sysdocclsrsnord"],
													"sysdocclsrsnman":lo_dat[i]["sysdocclsrsnman"],
													"docsts":"A"
												});
					}
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"sysdocclsrsncod":<?= $lv_sec; ?>_hotdocdel[i]["sysdocclsrsncod"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #sysdocrsn").text("");
				} else {
					$("#<?= $lv_sec; ?> #sysdocrsn").text( JSON.stringify( lv_arr ) );
				}
			}
		}
	</script>
   <?php include( 'grldocfrmscr.frm' ); ?>
</section>
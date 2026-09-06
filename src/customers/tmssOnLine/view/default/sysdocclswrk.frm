<?php
	// url del formulario 
  $lv_lnk = '?prg=sysdocclswrk';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->workflows;
	
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
      <textarea id="sysdocwrk" name="sysdocwrk" class="hidden"></textarea>
      <div id="sysdocwrkhot"></div>
    </div>
	</form>
	<script>
		// O B J E T O S 
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if (prop=="wrkflwtxt") { 
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];		
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #sysdocwrkhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->workflow; ?>" ],
			columns: [
				{type: "autocomplete", data: "wrkflwtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>				
					source: function (query, process) {
						$.ajax({
							url: "?prg=sysdocwrk&act=18", dataType: "json", data: {	prm_wrkflwtxt: query },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); exit();}},
							success: function (response) {
								// guardo todos los datos adicionales en una variable temporal
								var lv_dat = [];
								<?= $lv_sec; ?>_hotdocchg = [];
								for (var i=0; i < response.length; i++) {
									<?= $lv_sec; ?>_hotdocchg.push( {wrkflwtxt: response[i]["wrkflwtxt"], wrkflwcod: response[i]["wrkflwcod"]} );
									lv_dat.push( response[i]["wrkflwtxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				}
			],
			beforeChange : function(changes, source) {
				// asigno los datos adicionales a la fila
				if(source=="edit" && changes[0][1]=="wrkflwtxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].wrkflwtxt == lv_value) {
							changes.push([ changes[0][0], "wrkflwcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].wrkflwcod) ]);
						}
					}
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["sysdocclswrkcod"]!="" && lv_dat[i]["sysdocclswrkcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotdoc;
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [<?php
				$lv_buffer = '';
				foreach( $vew_data->docwrk as $lv_row) {
					$lv_buffer .= ($lv_buffer==''?'':', ').'{sysdocclswrkcod: "'.$lv_row['sysdocclswrkcod'].'", wrkflwcod: "'.$lv_row['wrkflwcod'].'", wrkflwtxt: "'.$lv_row['wrkflwtxt'].'"}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
	<script>
		$(function(e){ tmssHandsontableResize(); });

		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if (lp_prm["action"]=="00") {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
				
				var lv_arr = new Array();
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"sysdocclswrkcod":<?= $lv_sec; ?>_hotdocdel[i]["sysdocclswrkcod"],
												"deleted":"X"
											});
				}
				// obtengo datos de handsontable de roles
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["wrkflwcod"]!="" && lo_dat[i]["wrkflwcod"]!=undefined ){
						lv_arr.push({	"sysdocclswrkcod":lo_dat[i]["sysdocclswrkcod"],
													"sysdocclscod":$("#<?= $lv_sec; ?> #sysdocclscod").prop("value"),
													"wrkflwcod":lo_dat[i]["wrkflwcod"],
													"docsts":"A"
												});
					}
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #sysdocwrk").text("");
				} else {
					$("#<?= $lv_sec; ?> #sysdocwrk").text( JSON.stringify( lv_arr ) );
				}
			}
		}
	</script>
   <?php include( 'grldocfrmscr.frm' ); ?>
</section>
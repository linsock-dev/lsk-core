<?php
	// url del formulario 
  $lv_lnk = '?prg=stkmatstklvl';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->stocks;
	
	// módulo y programa 
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'MAT';

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

	<nav class="navbar navbar-default tmss-navbar <?= ($vew_readonly?'hidden':''); ?>">
		<div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '00'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success" title="<?= $vew_lang->save;  ?>"><span class="far fa-save"></span><span class="hidden-xs"> <?= $vew_lang->save; ?></span></a>
			</ul>
		</div>
	</nav>
	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">

		<div class="containter-fluid">
			<div class="row">
				<div class="col-md-12">
					<input type="hidden" id="matcod" name="matcod" value="<?= $vew_data->matcod; ?>">
					<textarea id="matstklvl" name="matstklvl" class="hidden"></textarea>
					<div id="matstklvlhot"></div>
				</div>
			</div>
		</div>
		
	</form>
	<script>
		// O B J E T O S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if (prop=="stkobjtyptxt") { 
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else if (prop=="stkobjcod" || prop=="stkcntcod") {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_hotdocpst = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];		
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #matstklvlhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Tipo", "Codigo", "Contacto", "Max", "Min", "Min%", "Res", "Res%" ],
			columns: [				
				{type: "dropdown", data: "stkobjtyptxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "index.php?prg=sysobjtyp&act=18", dataType: "json", 
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); exit();}},
							success: function (response) {
								var lv_dat = [];
								<?= $lv_sec; ?>_hotdocchg = [];
								for (var i=0; i < response.length; i++) {
									<?= $lv_sec; ?>_hotdocchg.push( {objtypcod: response[i]["objtypcod"], objtyptxt: response[i]["objtyptxt"]} );
									lv_dat.push( response[i]["objtyptxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				},
				{type: "text", data: "stkobjcod", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "text", data: "stkcntcod", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "numeric", data: "stkmatlvlmax", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "stkmatlvlmin", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "stkmatlvlmip", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "stkmatlvlres", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "stkmatlvlrep", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} }
			],
			afterChange: function(changes, source) {
				if (<?= $lv_sec; ?>_hotdoc!=undefined && <?= $lv_sec; ?>_hotdocpst==false && changes!=null) {
					for(var i=0; i<changes.length; i++) {
						var lv_dat = <?= $lv_sec; ?>_hotdoc.getDataAtRow( changes[i][0] );
						if ( lv_dat[3]!=0 && lv_dat[3]!=undefined && changes[i][1]!="stkmatlvlmin" && changes[i][1]!="stkmatlvlres") {
							var lv_max = lv_dat[3];
							var lv_min = lv_dat[4];
							var lv_mip = lv_dat[5];
							var lv_res = lv_dat[6];
							var lv_rep = lv_dat[7];
							if ( lv_mip!=undefined && lv_mip!=0 ) {	
								lv_min = (lv_max * lv_mip / 100).toFixed(2); 
								<?= $lv_sec; ?>_hotdocpst = true;
								<?= $lv_sec; ?>_hotdoc.setDataAtRowProp(changes[0][0],"stkmatlvlmin",lv_min);
								<?= $lv_sec; ?>_hotdocpst = false;
							}
							if ( lv_rep!=undefined && lv_rep!=0 ) {	
								lv_res = (lv_max * lv_rep / 100).toFixed(2); 
								<?= $lv_sec; ?>_hotdocpst = true;
								<?= $lv_sec; ?>_hotdoc.setDataAtRowProp(changes[0][0],"stkmatlvlres",lv_res);
								<?= $lv_sec; ?>_hotdocpst = false;
							}
						}
					}
				}
			},
			beforeChange : function(changes, source) {
				if(source=="edit" && changes[0][1]=="stkobjtyptxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].objtyptxt == lv_value) {
							changes.push([ changes[0][0], "stkobjtyp", "", String(<?= $lv_sec; ?>_hotdocchg[i].objtypcod) ]);
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
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["stkmatlvlcod"]!="" && lv_dat[i]["stkmatlvlcod"]!=undefined ) {
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
				foreach( $vew_data->matstklvllst as $lv_row) {
					foreach ( $vew_data->stkobjtypdef as $lv_rowdef ) {
						if ( $lv_rowdef['objtypcod']==$lv_row['stkobjtyp'] ) {
							$lv_buffer .= ($lv_buffer==''?'':', ').
								'{stkmatlvlcod: "'.$lv_row['stkmatlvlcod'].'", '.
								'stkobjtyptxt: "'.$lv_rowdef['objtyptxt'].'", '.
								'stkobjtyp: "'.$lv_row['stkobjtyp'].'", '.
								'stkobjcod: "'.$lv_row['stkobjcod'].'", '.
								'stkcntcod: "'.$lv_row['stkcntcod'].'", '.
								'stkmatlvlmax: '.$lv_row['stkmatlvlmax'].' , '.
								'stkmatlvlmin: '.$lv_row['stkmatlvlmin'].' , '.
								'stkmatlvlmip: '.$lv_row['stkmatlvlmip'].' , '.
								'stkmatlvlres: '.$lv_row['stkmatlvlres'].' , '.
								'stkmatlvlrep: '.$lv_row['stkmatlvlrep'].' }';
							break;
						}
					}
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
	<script>
		$(function(e){ tmssHandsontableResize(); });
    var gv_<?= $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $("#<?= $lv_sec; ?>_frm"), "<?= $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    });

		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {
				
				if (lp_prm["action"]=="00") {
					if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
					
					// obtengo datos de handsontable de roles
					var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
					var lv_arr = new Array();
					for (var i=0; i<lo_dat.length; i++) {
						if ( lo_dat[i]["stkobjtyp"]!="" && lo_dat[i]["stkobjtyp"]!=undefined ){
							lv_arr.push({	"stkmatlvlcod":lo_dat[i]["stkmatlvlcod"],
														"stkobjtyp":lo_dat[i]["stkobjtyp"],
														"stkobjcod":lo_dat[i]["stkobjcod"],
														"stkcntcod":lo_dat[i]["stkcntcod"],
														"stkmatlvlmax":lo_dat[i]["stkmatlvlmax"],
														"stkmatlvlmin":lo_dat[i]["stkmatlvlmin"],
														"stkmatlvlmip":lo_dat[i]["stkmatlvlmip"],
														"stkmatlvlres":lo_dat[i]["stkmatlvlres"],
														"stkmatlvlrep":lo_dat[i]["stkmatlvlrep"]
													});
						}
					}
					// agrego las filas eliminadas
					for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
						lv_arr.push({	"stkmatlvlcod":<?= $lv_sec; ?>_hotdocdel[i]["stkmatlvlcod"],
													"deleted":"X"
												});
					}
					if (lv_arr.length==0) {
						$("#<?= $lv_sec; ?> #matstklvl").text("");
					} else {
						$("#<?= $lv_sec; ?> #matstklvl").text( JSON.stringify( lv_arr ) );
					}
				}
				
				gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
				var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':'03'); ?>":gv_<?= $lv_sec; ?>_last_action);
				tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
			}
		}

		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>,"#buscod");
	</script>
</section>
<?php
	// url del formulario
  $lv_lnk = '?prg=sysdocclsmsg';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->messageclasses;
	
	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'DOC';
	
  // librería de estilos
  include_once('_library.frm');
?> 
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <a href="#" id="btnsubmit" class="hidden" onclick="<?= $lv_sec; ?>_fnc({action: '00'});"></a>
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>

		<div class="containter-fluid">
			<div class="row">
				<div class="col-md-12">
          <?= gethtml('sysdocclscod','hidden',$vew_data->sysdocclscod); ?>
         <textarea id="sysdocmsg" name="sysdocmsg" class="hidden"></textarea>
         <div id="sysdocmsghot"></div>
				</div>
			</div>
		</div>
		
	</form>
	<script>
		// O B J E T O S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if (prop=="sysdocmsgtxt" || prop=="sysdocclsmsgevt") { 
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];		
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #sysdocmsghot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Clase Mensaje", "Evento" ],
			columns: [
				{type: "autocomplete", data: "sysdocmsgtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>				
					source: function (query, process) {
						$.ajax({
							url: "index.php?prg=sysdocmsg&act=18", dataType: "json", data: {	prm_sysdocmsgtxt: query, prm_objtypcod: "<?= $vew_data->objtypcod ?>" },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); exit();}},
							success: function (response) {
								// guardo todos los datos adicionales en una variable temporal
								var lv_dat = [];
								<?= $lv_sec; ?>_hotdocchg = [];
								for (var i=0; i < response.length; i++) {
									<?= $lv_sec; ?>_hotdocchg.push( {sysdocmsgtxt: response[i]["sysdocmsgtxt"], sysdocmsgcod: response[i]["sysdocmsgcod"]} );
									lv_dat.push( response[i]["sysdocmsgtxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				},
				{type: "dropdown", data: "sysdocclsmsgevt", source: ["Manual", "Grabar","Contabilizar"], renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
			],
			beforeChange : function(changes, source) {
				// asigno los datos adicionales a la fila
				if(source=="edit" && changes[0][1]=="sysdocmsgtxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].sysdocmsgtxt == lv_value) {
							changes.push([ changes[0][0], "sysdocmsgcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].sysdocmsgcod) ]);
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
					if ( lv_dat[i]["sysdocclsmsgcod"]!="" && lv_dat[i]["sysdocclsmsgcod"]!=undefined ) {
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
				foreach( $vew_data->docmsg as $lv_row) {
					$lv_buffer .= ($lv_buffer==''?'':', ').'{sysdocclsmsgcod: "'.$lv_row['sysdocclsmsgcod'].'", sysdocmsgcod: "'.$lv_row['sysdocmsgcod'].'", sysdocmsgtxt: "'.$lv_row['sysdocmsgtxt'].'", sysdocclsmsgevt: "'.$vew_doc->getTagValue($lv_row['sysdocclsmsgatr'],'evt').'"}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotobj.loadData( lv_dat );
			<?= $lv_sec; ?>_hotobj.render();
		});
	</script>
	<script>
		$(function(e){ tmssHandsontableResize(); });

		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if (lp_prm["action"]=="00") {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
				
				// obtengo datos de handsontable de roles
				var lo_dat = <?= $lv_sec; ?>_hotobj.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["sysdocmsgcod"]!="" && lo_dat[i]["sysdocmsgcod"]!=undefined ){
						lv_arr.push({	"sysdocclsmsgcod":lo_dat[i]["sysdocclsmsgcod"],// Dato invisible dentro de la tabla
													"sysdocclscod":$("#<?= $lv_sec; ?> #sysdocclscod").prop("value"),// codigo clase de documento
													"sysdocmsgcod":lo_dat[i]["sysdocmsgcod"],//código de clase de mensaje
													"sysdocclsmsgatrevt":lo_dat[i]["sysdocclsmsgevt"],// Dato invisible dentro de la tabla(debugger indefinida)
													"docsts":"A"
												});
					}
				}      
				 
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"sysdocclsmsgcod":<?= $lv_sec; ?>_hotdocdel[i]["sysdocclsmsgcod"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #sysdocmsg").text("");
				} else {
					$("#<?= $lv_sec; ?> #sysdocmsg").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
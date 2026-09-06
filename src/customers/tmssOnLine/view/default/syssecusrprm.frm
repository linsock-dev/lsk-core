<?php
	// url del formulario 
  $lv_lnk = '?prg=syssecusrprm';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->permissions;
	
	// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'USR';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<a href="#" class="hidden" id="btnsubmit" onclick="<?= $lv_sec; ?>_fnc({action: '00'});"></a>

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('buscod','hidden',$vew_data->buscod); ?>
		<?= gethtml('usrcod','hidden',($vew_data->usrcod!=''?$vew_data->usrcod:'**')); ?>
		
		<div>
			<textarea id="usrprm" name="usrprm" class="hidden"></textarea>
			<div id="usrprmhot"></div>
		</div>
	</form>
	<script>
		/*
		 *
		 *	O B J E T O S
		 *
		 */
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if (prop=="prmtxt") { 
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
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #usrprmhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->parameter; ?>", "<?= $vew_lang->restriction; ?>", "<?= $vew_lang->default; ?>" ],
			columns: [				
				{type: "dropdown", data: "prmtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "index.php?prg=syssecusrprm&act=18", dataType: "json", 
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="//script"){ eval(jqXHR.responseText); exit();}},
							success: function (response) {
								var lv_dat = [];
								<?= $lv_sec; ?>_hotdocchg = [];
								for (var i=0; i < response.length; i++) {
									<?= $lv_sec; ?>_hotdocchg.push( {prmtxt: response[i]["secusrprmtxt"], prmcod: response[i]["secusrprmcod"], prmfld: response[i]["secusrprmreffld"], prmobjtyp: response[i]["objtypcod"]} );
									lv_dat.push( response[i]["secusrprmtxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				},
				{type: "text", data: "prmval", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "text", data: "prmvaldef", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>}
			],
			beforeChange : function(changes, source) {
				if(source=="edit" && changes[0][1]=="prmtxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].prmtxt == lv_value) {
							changes.push([ changes[0][0], "prmcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].prmcod) ]);
							changes.push([ changes[0][0], "prmfld", "", String(<?= $lv_sec; ?>_hotdocchg[i].prmfld) ]);
							changes.push([ changes[0][0], "prmobjtyp", "", String(<?= $lv_sec; ?>_hotdocchg[i].prmobjtyp) ]);
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
					if ( lv_dat[i]["usrprmcod"]!="" && lv_dat[i]["usrprmcod"]!=undefined ) {
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
				foreach( $vew_data->usrprm as $lv_row) {
					foreach ( $vew_data->usrprmdef as $lv_rowdef ) {
						if ( $lv_rowdef['secusrprmcod']==$lv_row['prmcod'] ) {
							$lv_buffer .= ($lv_buffer==''?'':', ').'{usrprmcod: "'.$lv_row['usrprmcod'].'", prmcod: "'.$lv_row['prmcod'].'", prmtxt: "'.$lv_rowdef['secusrprmtxt'].'", prmval: "'.$lv_row['prmval'].'", prmvaldef: "'.$lv_row['prmvaldef'].'", prmfld: "'.$lv_row['prmfld'].'", prmobjtyp: "'.$lv_row['prmobjtyp'].'"}';
							break;
						}
					}
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
					if ( lo_dat[i]["prmcod"]!="" && lo_dat[i]["prmcod"]!=undefined ){
						lv_arr.push({	"usrprmcod":lo_dat[i]["usrprmcod"],
													"prmcod":lo_dat[i]["prmcod"],
													"prmfld":lo_dat[i]["prmfld"],
													"prmval":lo_dat[i]["prmval"],
													"prmvaldef":lo_dat[i]["prmvaldef"],
													"prmobjtyp":lo_dat[i]["prmobjtyp"]
												});
					}
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"usrprmcod":<?= $lv_sec; ?>_hotdocdel[i]["usrprmcod"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #usrprm").text("");
				} else {
					$("#<?= $lv_sec; ?> #usrprm").text( JSON.stringify( lv_arr ) );
				}
			}
		}
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
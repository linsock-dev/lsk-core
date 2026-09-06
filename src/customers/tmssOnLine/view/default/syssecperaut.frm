<?php
	// url del formulario 
  $lv_lnk = '?prg=syssecperaut';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->permissions;
	
	// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'AUT';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<a href="#" class="hidden" id="btnsubmit" onclick="<?= $lv_sec; ?>_fnc({action: '00'});"></a>

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('buscod','hidden',$vew_data->buscod); ?>
    <?= gethtml('usrcod','hidden',($vew_data->usrcod!=''?$vew_data->usrcod:'**')); ?>
    <?= gethtml('usrgrpcod','hidden',($vew_data->usrgrpcod!=''?$vew_data->usrgrpcod:'**')); ?>
		<textarea id="peraut" name="peraut" class="hidden"></textarea>
		<div id="autobjhot"></div>
	</form>
	<script>
		/*
		 *
		 *	O B J E T O S
		 *
		 */
		var <?= $lv_sec; ?>_hotobj_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
		};
		var <?= $lv_sec; ?>_hotobjtmpchg = [];
		var <?= $lv_sec; ?>_hotobjtmpdel = [];
		var <?= $lv_sec; ?>_hotobjcnt = $("#<?= $lv_sec; ?> #autobjhot")[0];
		var <?= $lv_sec; ?>_hotobjset = {
			height: 230,
			width: 400,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: 1,
			colHeaders: [ "<?= $vew_lang->object; ?>", "<?= $vew_lang->authorization; ?>" ],
			columns: [				
				{type: "dropdown", data: "objtypcod", renderer: <?= $lv_sec; ?>_hotobj_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "index.php?prg=sysobjtyp&act=18", dataType: "json", 
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="//script"){ eval(jqXHR.responseText); exit();}},
							success: function (response) {
								// guardo todos los datos adicionales en una variable temporal
								var lv_dat = [];
								<?= $lv_sec; ?>_hotobjtmpchg = [];
								for (var i=0; i < response.length; i++) {
									//<?= $lv_sec; ?>_hotobjtmpchg.push( {objtypcod: response[i]["objtypcod"]} );
									lv_dat.push( response[i]["objtypcod"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				},
				{type: "text", data: "autcod", renderer: <?= $lv_sec; ?>_hotobj_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>}
			],
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotobj.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]['key']!='' && lv_dat[i]['key']!=undefined ) {
						<?= $lv_sec; ?>_hotobjtmpdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotobj;
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotobj = new Handsontable(<?= $lv_sec; ?>_hotobjcnt, <?= $lv_sec; ?>_hotobjset);	
			var lv_dat = [<?php
				$lv_buffer = '';
				foreach( $vew_data->autobj as $lv_row) {
					$lv_buffer .= ($lv_buffer==''?'':', ').'{key: "'.$lv_row['objtypcod'].chr(9).$lv_row['autcod'].'", objtypcod: "'.$lv_row['objtypcod'].'", autcod: "'.$lv_row['autcod'].'"}';
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
				// obtengo datos de handsontable de roles
				var lo_dat = <?= $lv_sec; ?>_hotobj.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["objtypcod"]!="" && lo_dat[i]["objtypcod"]!=undefined && lo_dat[i]["autcod"]!="" && lo_dat[i]["autcod"]!=undefined ){
						lv_arr.push({	"key":lo_dat[i]["key"],
													"objtypcod":lo_dat[i]["objtypcod"],
													"autcod":lo_dat[i]["autcod"]
												});
					}
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotobjtmpdel.length; i++) {
					lv_arr.push({	"key":<?= $lv_sec; ?>_hotobjtmpdel[i]["key"],
												"objtypcod":<?= $lv_sec; ?>_hotobjtmpdel[i]["objtypcod"],
												"autcod":<?= $lv_sec; ?>_hotobjtmpdel[i]["autcod"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #peraut").text("");
				} else {
					$("#<?= $lv_sec; ?> #peraut").text( JSON.stringify( lv_arr ) );
				}
			}
		}
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
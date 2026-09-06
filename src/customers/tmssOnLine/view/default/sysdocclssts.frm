<?php
	// url del formulario 
  $lv_lnk = '?prg=sysdocclssts';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->statuses;
	
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
    <?= gethtml('objtypcod','hidden',$vew_data->objtypcod); ?>    
		<div class="containter-fluid">
      <?= gethtml('sysdocclscod','hidden',$vew_data->sysdocclscod); ?>
      <textarea id="sysdocsts" name="sysdocsts" class="hidden"></textarea>
      <div id="sysdocstshot"></div>
    </div>
	</form>
	<script>
		// O B J E T O S 
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			//No está la propiedad sysdocclsstsevt acá.
      if (prop=="sysdocststxt" || prop=="sysdocclsstsevt") { 
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
      }else{
        Handsontable.renderers.TextRenderer.apply(this, arguments); 
      }
			td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];		
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #sysdocstshot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Estado", "Orden", "Manual" ],
			columns: [
				{type: "autocomplete", data: "sysdocststxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>				
					source: function (query, process) {
            var lv_post = [{name:"sysdocststxt",value:query},
                           {name:"objtypcod",value:$("#<?= $lv_sec; ?> #objtypcod").val()}];
            tmssCallProcessNoBackdrop("index.php?prg=sysdocsts&act=18", lv_post, function(data){
            	// guardo todos los datos adicionales en una variable temporal
              var lv_dat = [];
              <?= $lv_sec; ?>_hotdocchg = [];
              for (var i=0; i < data.length; i++) {
                <?= $lv_sec; ?>_hotdocchg.push( {sysdocststxt: data[i]["sysdocststxt"], sysdocstscod: data[i]["sysdocstscod"]} );
                lv_dat.push( data[i]["sysdocststxt"] );
              }
              process( lv_dat );
            });
					},
					strict: true
				},
				{type: "numeric", data: "sysdocclsstsord", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "numeric", data: "sysdocclsstsman", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>}
			],
			beforeChange : function(changes, source) {
				// asigno los datos adicionales a la fila
				if(source=="edit" && changes[0][1]=="sysdocststxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].sysdocststxt == lv_value) {
							changes.push([ changes[0][0], "sysdocstscod", "", String(<?= $lv_sec; ?>_hotdocchg[i].sysdocstscod) ]);
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
					if ( lv_dat[i]["sysdocclsstscod"]!="" && lv_dat[i]["sysdocclsstscod"]!=undefined ) {
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
				foreach( $vew_data->docsts as $lv_row) {
					$lv_buffer .= ($lv_buffer==''?'':', ').'{sysdocclsstscod: "'.$lv_row['sysdocclsstscod'].'", sysdocstscod: "'.$lv_row['sysdocstscod'].'", sysdocststxt: "'.$lv_row['sysdocststxt'].'", sysdocclsstsord: "'.$vew_doc->getTagValue($lv_row['sysdocclsstsatr'],'stsord').'", sysdocclsstsman: "'.$vew_doc->getTagValue($lv_row['sysdocclsstsatr'],'stsman').'"}';
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
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {
				
				if (lp_prm["action"]=="00") {
					if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
					
					// obtengo datos de handsontable de roles
					var lo_dat = <?= $lv_sec; ?>_hotobj.getSourceData();
					var lv_arr = new Array();
					for (var i=0; i<lo_dat.length; i++) {
						if ( lo_dat[i]["sysdocstscod"]!="" && lo_dat[i]["sysdocstscod"]!=undefined ){
							lv_arr.push({	"sysdocclsstscod":lo_dat[i]["sysdocclsstscod"],
														"sysdocclscod":$("#<?= $lv_sec; ?> #sysdocclscod").prop("value"),
														"sysdocstscod":lo_dat[i]["sysdocstscod"],
														"sysdocclsstsord":lo_dat[i]["sysdocclsstsord"],
														"sysdocclsstsman":lo_dat[i]["sysdocclsstsman"],
														"docsts":"A"
													});
						}
					}
					// agrego las filas eliminadas
					for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
						lv_arr.push({	"sysdocclsstscod":<?= $lv_sec; ?>_hotdocdel[i]["sysdocclsstscod"],
													"deleted":"X"
												});
					}
					if (lv_arr.length==0) {
						$("#<?= $lv_sec; ?> #sysdocsts").text("");
					} else {
						$("#<?= $lv_sec; ?> #sysdocsts").text( JSON.stringify( lv_arr ) );
					}
				}
			}
		}
	</script>
   <?php include( 'grldocfrmscr.frm' ); ?>
</section>
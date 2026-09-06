<?php
	// url del formulario 
  $lv_lnk = '?prg=sysdocclsfle';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->contacts;
	
	// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'DOC';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<a href="#" id="btnsubmit" class="hidden" onclick="<?= $lv_sec; ?>_fnc({action: '00'});"></a>
	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>

		<div class="containter-fluid">
			<div class="row">
				<div class="col-md-12">
          <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdocclscod); ?>
					<textarea id="sysdocfle" name="sysdocfle" class="hidden"></textarea>
					<div id="sysdocflehot"></div>
				</div>
			</div>
		</div>
		
	</form>
	<script>
		// O B J E T O S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if (prop=="sysdocclstxt") { 
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else if (prop=="sysdocclsflereq") { 
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";				
			}
			
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];	
		var <?= $lv_sec; ?>_hotdocfle = $("#<?= $lv_sec; ?> #sysdocflehot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->FILESTYPES; ?>", "<?= $vew_lang->required; ?>", "<?= $vew_lang->quantity; ?>","Modo Presentacion" ],//agregar traduccion
			columns: [
				{type: "autocomplete", data: "fletyptxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>				
           source: function (query, process) {
              $.ajax({
                url: "?prg=grldatfletyp&act=17", dataType: "json", data: {prm_fletyptxt: query}, minLength: 2,
                complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
                success: function (response) {
                  var lv_dat = [];
                  <?= $lv_sec; ?>_hotdocchg = [];
                  for (var i=0; i < response.length; i++) {
                    <?= $lv_sec; ?>_hotdocchg.push( {fletyptxt: response[i]["fletyptxt"], fletypcod: response[i]["fletypcod"]} );
                    lv_dat.push( response[i]["fletyptxt"] );
                  }
                  process( lv_dat );
                }
              });
          },
					strict: true
				},       
				{type: "text", data: "sysdocclsflereq", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "numeric", data: "sysdocclsfleqty", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
        {type: 'dropdown',data:"sysdocclsflemod",source: ['adjunto', 'perfil'],renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>}
			],
			beforeChange : function(changes, source) {
				// asigno los datos adicionales a la fila
				if(source=="edit" && changes[0][1]=="fletyptxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].fletyptxt == lv_value) {
							changes.push([ changes[0][0], "fletypcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].fletypcod) ]);
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
			}
		};
		var <?= $lv_sec; ?>_hotobj;
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotobj = new Handsontable(<?= $lv_sec; ?>_hotdocfle, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [<?php
				$lv_buffer = '';
				foreach( $vew_data->docclsfle as $lv_row) {
					$lv_buffer .= ($lv_buffer==''?'':', ').'{sysdocclsflecod: "'.$lv_row['sysdocclsflecod'].'",
                                                  fletyptxt: "'.$lv_row['fletyptxt'].'", 
                                                  fletypcod: "'.$lv_row['fletypcod'].'", 
                                                  sysdocclsflereq: "'.$vew_doc->getTagValue($lv_row['sysdocclsfleatr'],'sysdocclsflereq').'", 
                                                  sysdocclsfleqty: "'.$vew_doc->getTagValue($lv_row['sysdocclsfleatr'],'sysdocclsfleqty').'",
                                                  sysdocclsflemod: "'.$vew_doc->getTagValue($lv_row['sysdocclsfleatr'],'sysdocclsflemod').'"

                                                  }';
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
					if ( lo_dat[i]["fletypcod"]!="" && lo_dat[i]["fletypcod"]!=undefined ){
            var lv_atr = '<sysdocclsflereq>' + (lo_dat[i]["sysdocclsflereq"] || '') + '</sysdocclsflereq>' +
                         '<sysdocclsfleqty>' + (lo_dat[i]["sysdocclsfleqty"] || '') + '</sysdocclsfleqty>' +
                         '<sysdocclsflemod>' + (lo_dat[i]["sysdocclsflemod"] || '') + '</sysdocclsflemod>';
            
						lv_arr.push({	"sysdocclsflecod":lo_dat[i]["sysdocclsflecod"] != undefined ? lo_dat[i]["sysdocclsflecod"] : null,
                          "fletypcod":lo_dat[i]["fletypcod"],
                         	"sysdocclsfleatr": lv_atr,
													"docsts":"A"
												});
					}
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #sysdocfle").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #sysdocfle").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}

	</script>
   <?php include( 'grldocfrmscr.frm' ); ?>
</section>
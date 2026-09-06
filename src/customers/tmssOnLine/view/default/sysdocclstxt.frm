<?php
	// url del formulario
  $lv_lnk = '?prg=sysdocclstxt';

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

	//Botones de vista
	$vew_tbl['clsL'] = array('per'=>false);
  $vew_tbl['clsR'] = array('per'=>false);
	$vew_tbl['canc'] = array('per'=>false);
	$vew_dropdown = false; 
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>"> 
  <a href="#" id="btnsubmit" class="hidden" onclick="<?= $lv_sec; ?>_fnc({action: '00'});"></a>
	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
		<div class="containter-fluid">
      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdocclscod); ?>
      <textarea id="sysdoctxt" name="sysdoctxt" class="hidden"></textarea>
      <div id="sysdoctxthot"></div>
    </div>
	</form>
	<script>
		// OBJETOS
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
     	if (<?= $lv_sec; ?>_hotobj!=undefined) {
        if (prop=="txttyptxt" || prop=="sysdocclstxtdeftxt") { 
          Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
          td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
        } 		
        
        if(<?= $lv_sec; ?>_hotobj.getDataAtRowProp(row, "deleted") != "" && <?= $lv_sec; ?>_hotobj.getDataAtRowProp(row, "deleted") != undefined){
          td.style.backgroundColor = "#F1F1F1";
        }
     	}
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];		
		var <?= $lv_sec; ?>_hotdoctxt = $("#<?= $lv_sec; ?> #sysdoctxthot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Tipos de texto", "Valor por defecto" ],
			columns: [
				{type: "autocomplete", data: "txttyptxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>				
           source: function (query, process) {
              $.ajax({
                url: "?prg=grldattxttyp&act=18", dataType: "json", data: { prm_txttyptxt: query}, minLength: 2,
                complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
                success: function (response) {
                  var lv_dat = [];
                  <?= $lv_sec; ?>_hotdocchg = [];
                  for (var i=0; i < response.length; i++) {
                    <?= $lv_sec; ?>_hotdocchg.push( {txttyptxt: response[i]["txttyptxt"], txttypcod: response[i]["txttypcod"]} );
                    lv_dat.push( response[i]["txttyptxt"] );
                  }
                  process( lv_dat );
                }
              });
          },
					strict: true
				},
       
        {type: "autocomplete", data: "sysdocclstxtdeftxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>				
           source: function (query, process) {
              $.ajax({
                url: "?prg=grldattxt&act=18", dataType: "json", data: { prm_txtcodext: query, prm_txtsrccod : "**"}, minLength: 2,
                complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
                success: function (response) {
                  var lv_dat = [];
                  <?= $lv_sec; ?>_hotdocchg = [];
                  for (var i=0; i < response.length; i++) {
                    <?= $lv_sec; ?>_hotdocchg.push( {sysdocclstxtdeftxt: response[i]["txtcodext"], sysdocclstxtdef: response[i]["txtcod"]} );
                    lv_dat.push( response[i]["txtcodext"] );
                  }
                  process( lv_dat );
                }
              });
          },
					strict: true
				},
			],
			beforeChange : function(changes, source) {
				// asigno los datos adicionales a la fila
				if(source=="edit" && changes[0][1]=="txttyptxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].txttyptxt == lv_value) {
							changes.push([ changes[0][0], "txttypcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].txttypcod) ]);
						}
					}
				} else if(source=="edit" && changes[0][1]=="sysdocclstxtdeftxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].sysdocclstxtdeftxt == lv_value) {
							changes.push([ changes[0][0], "sysdocclstxtdef", "", String(<?= $lv_sec; ?>_hotdocchg[i].sysdocclstxtdef) ]);
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
					if ( lv_dat[i]["sysdocclstxtcod"]!="" && lv_dat[i]["sysdocclstxtcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotobj;
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotobj = new Handsontable(<?= $lv_sec; ?>_hotdoctxt, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [<?php
				$lv_buffer = '';
        // se hace la carga de datos
				foreach( $vew_data->docclstxt as $lv_row) { 
					$lv_buffer .= ($lv_buffer==''?'':', ').'{txttypcod: "'.$lv_row['txttypcod'].'",
          																				 sysdocclstxtcod: "'.$lv_row['sysdocclstxtcod'].'",
                                                   txttyptxt: "'.$lv_row['txttyptxt'].'", 
                                                   sysdocclstxtdef: "'.$vew_doc->getTagValue($lv_row['sysdocclstxtatr'],'sysdocclstxtdef').'",
                                                   sysdocclstxtdeftxt: "'.$lv_row['txtcodext'].'"}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotobj.loadData( lv_dat );
			<?= $lv_sec; ?>_hotobj.render();
		});
	</script>
	<script>
		$(function(e){ tmssHandsontableResize(); });

    // server response ext
    function <?= $lv_sec; ?>_fncbckext( lp_prm ) {
      var lv_cell;
      var lv_dat = <?= $lv_sec; ?>_hotobj.getSourceData();
      
      if(!tmssBackMessageProcessing( lp_prm, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" )){
        
        // recorro las filas para buscar la fila que tiene un error
        for( var i=0; i<=lv_dat.length-1; i++){
          if ( lv_dat[i]["sysdocclstxtcod"] == lp_prm.row) {    
            
            // pinto la fila de rojo
            for (var j = 0; j < <?= $lv_sec; ?>_hotobj.countCols(); j++) { 
            	lv_cell = <?= $lv_sec; ?>_hotobj.getCell(i, j);                                                                                                               
              lv_cell.style.backgroundColor = "#ff4c42"; 
            }           
            
            break;
          }
        }
        
        if(lp_prm.errcod == -1){
        	toastr.warning("Ocurri&oacute; un error al grabar. Corrija los errores y vuelva a cargar el popup.");
        }
      }else{
        $("#<?= $lv_sec; ?>").replaceWith( lp_prm );
      }
    }
    
		// form submit externo
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if (lp_prm["action"]=="00") {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
				
				// obtengo datos de handsontable de roles
				var lo_dat = <?= $lv_sec; ?>_hotobj.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["txttyptxt"]!="" && lo_dat[i]["txttyptxt"]!=undefined  && (lo_dat[i]["deleted"]=="" || lo_dat[i]["deleted"]==undefined)){
						lv_arr.push({	"sysdocclstxtcod":lo_dat[i]["sysdocclstxtcod"],
              						"txttypcod":lo_dat[i]["txttypcod"],
													"txttyptxt":lo_dat[i]["txttyptxt"],
													"sysdocclstxtdef":lo_dat[i]["sysdocclstxtdef"],
													"docsts":"A"
												});
					}
				} 
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"sysdocclstxtcod":<?= $lv_sec; ?>_hotdocdel[i]["sysdocclstxtcod"],
												"deleted":"X"
											});
				}
        
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #sysdoctxt").text("");
				} else {
					$("#<?= $lv_sec; ?> #sysdoctxt").text( JSON.stringify( lv_arr ) );
				}
			}
      
    }
			
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
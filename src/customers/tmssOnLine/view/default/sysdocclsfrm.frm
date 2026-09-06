<?php
	// url del formulario
  $lv_lnk = '?prg=sysdocclsfrm';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->contacts;

	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'CLS';

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
      <textarea id="sysdocfrm" name="sysdocfrm" class="hidden"></textarea>
      <div id="sysdocfrmhot"></div>
    </div>
	</form>
	<script>
		// OBJETOS
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
     	if (<?= $lv_sec; ?>_hotobj!=undefined) {
        if (true) {
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
		var <?= $lv_sec; ?>_hotdoctxt = $("#<?= $lv_sec; ?> #sysdocfrmhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->forms ?>", "<?= $vew_lang->condtype ?>", "<?= $vew_lang->condition ?>", "<?= $vew_lang->required ?>" ],
			columns: [
				{type: "autocomplete", data: "sysdocfrmtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>				
           source: function (query, process) {
              $.ajax({
                url: "?prg=sysdocfrm&act=18", dataType: "json", data: { prm_txttyptxt: query}, minLength: 2,
                complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
                success: function (response) {
                  var lv_dat = [];
                  <?= $lv_sec; ?>_hotdocchg = [];
                  for (var i=0; i < response.length; i++) {
                    <?= $lv_sec; ?>_hotdocchg.push( {sysdocfrmtxt: response[i]["sysdocfrmtxt"], sysdocfrmcod: response[i]["sysdocfrmcod"]} );
                    lv_dat.push( response[i]["sysdocfrmtxt"] );
                  }
                  process( lv_dat );
                }
              });
          },
					strict: true
				},
        {type: "dropdown", data: "cndtyp", source: ["Formula", "Personalizada"], renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
        {type: "text", data: "cndval", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "dropdown", data: "sysdocclsfrmreq", source: ["No", "Si"], renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> }
			],
			beforeChange : function(changes, source) {
				// asigno los datos adicionales a la fila
				if(source=="edit" && changes[0][1]=="sysdocfrmtxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].sysdocfrmtxt == lv_value) {
							changes.push([ changes[0][0], "sysdocfrmcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].sysdocfrmcod) ]);
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
            if ( lv_dat[i]["sysdocclsfrmcod"]!="" && lv_dat[i]["sysdocclsfrmcod"]!=undefined ) {
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
				foreach( $vew_data->docclsfrm as $lv_row) {
          $lv_cndtyp = ($lv_row['cndtyp']=='FOR'?'Formula':($lv_row['cndtyp']=='ZCU'?'Personalizada':''));
					$lv_buffer .= ($lv_buffer==''?'':', ').'{sysdocclsfrmcod: "'.$lv_row['sysdocclsfrmcod'].'",
          																				 sysdocfrmcod: "'.$lv_row['sysdocfrmcod'].'",
          																				 sysdocfrmtxt: "'.$lv_row['sysdocfrmtxt'].'",
                                                   cndtyp: "'.$lv_cndtyp.'",
                                                 	 cndval: "'.$lv_row['cndval'].'",
																									 sysdocclsfrmreq: "'.(((int)$lv_row['sysdocclsfrmreq'] === 1) ? 'Si' : 'No').'"
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

    // server response ext
    function <?= $lv_sec; ?>_fncbckext( lp_prm ) {
      var lv_cell;
      var lv_dat = <?= $lv_sec; ?>_hotobj.getSourceData();
      var lv_inderr = undefined;
      var lv_deleted = [];
      if(!tmssBackMessageProcessing( lp_prm, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" )){

        lv_inderr = <?= $lv_sec; ?>_hotdocdel.findIndex(function(val){ return val == lp_prm.row});
        lv_deleted = <?= $lv_sec; ?>_hotdocdel.filter(function(val, i){ return i < lv_inderr});

        // recorro las filas para buscar la fila que tiene un error
        for( var i=0; i<=lv_dat.length-1; i++){
          if ( lv_dat[i]["sysdocclsfrmcod"] == lp_prm.row) {

            // pinto la fila de rojo
            for (var j = 0; j < <?= $lv_sec; ?>_hotobj.countCols(); j++) {
            	lv_cell = <?= $lv_sec; ?>_hotobj.getCell(i, j);
              lv_cell.style.backgroundColor = "#ff4c42";
            }

            break;
          }
        }
      }

      // quito las filas que ya fueron eliminadas (en el server) de la tabla
      var lv_len = lv_dat.length-1;
      for( var i=0; i <= lv_len ; i++ ){
        lv_cell = <?= $lv_sec; ?>_hotobj.getCell(i, 0);
        if(lv_cell.style.backgroundColor == "rgb(241, 241, 241)"){
          if(lv_deleted.length > 0){
            if(lv_deleted.find(function(val){ return lv_dat[i]["sysdocclsfrmcod"] == val;}) == undefined){
              continue;
            }
          }else if(lv_inderr != undefined){
            if(<?= $lv_sec; ?>_hotdocdel.find(function(val){ return lv_dat[i]["sysdocclsfrmcod"] == val;}) != undefined){
              continue;
            }
          }
        	<?= $lv_sec; ?>_hotobj.alter('remove_row', i);
          i--;
          lv_len--;
        }
      }
    }

		// form submit externo
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if (lp_prm["action"]=="00") {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }

				// obtengo datos de handsontable de roles
				var lo_dat = <?= $lv_sec; ?>_hotobj.getSourceData();
        
        for (var i = 0; i < lo_dat.length; i++) {
          var lv_typ = lo_dat[i]["cndtyp"];
          var lv_val = lo_dat[i]["cndval"];

          if ((lv_typ && !lv_val) || (!lv_typ && lv_val)) {
            toastr.warning("Datos incompletos. Complete ambos campos (Tipo cond. y Condici&oacute;n)");
            return false;
          }
        }
        
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["sysdocfrmtxt"]!="" && lo_dat[i]["sysdocfrmtxt"]!=undefined  && (lo_dat[i]["deleted"]=="" || lo_dat[i]["deleted"]==undefined)){
          	var lv_req = (lo_dat[i]["sysdocclsfrmreq"] === "Si") ? 1 : 0;

            lv_arr.push({	"sysdocclsfrmcod":lo_dat[i]["sysdocclsfrmcod"],
              						"sysdocfrmcod":lo_dat[i]["sysdocfrmcod"],
													"sysdocfrmtxt":lo_dat[i]["sysdocfrmtxt"],
                         	"cndtyp":lo_dat[i]["cndtyp"],
                          "cndtyp":lo_dat[i]["cndtyp"]=="Formula"?"FOR":lo_dat[i]["cndtyp"]=="Personalizada"?"ZCU":"",
                          "cndval":lo_dat[i]["cndval"],
                         	"sysdocclsfrmreq":lv_req,
													"docsts":"A"
												});
					}
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"sysdocclsfrmcod":<?= $lv_sec; ?>_hotdocdel[i]["sysdocclsfrmcod"],
												"deleted":"X"
											});
				}

				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #sysdocfrm").text("");
				} else {
					$("#<?= $lv_sec; ?> #sysdocfrm").text( JSON.stringify( lv_arr ) );
				}
			}
    }
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
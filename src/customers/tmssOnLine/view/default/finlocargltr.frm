<?php		
	// url del formulario 
  $lv_lnk = '?prg=finlocargltr';
 
	// campos requeridos 
	$vew_input->RequiredFields( array('argltrcodext','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->argltrcodext; 

	// titulo 
	$lv_title = $vew_lang->letter;
	
	// módulo y programa 
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'ARLTR';
	
	// libreria de estilos bootstrap
	include_once('_library.frm');
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden','')?>
		
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->argltrcodext; ?><?= gethtml('argltrcodext','hidden',$vew_data->argltrcodext) ?></strong></h4></li>
      </ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->letter,	'input'=>gethtml('argltrcodext', 'doccmt1x2', $vew_data->argltrcodext, ($vew_data->argltrcodext==""?$lv_default:$lv_always_disabled)) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', 		'docsts', 		$vew_data->docsts, 		$lv_default) )); 
                  ?>
                </div>
              </div>
						</div>
						<div class="col-md-6">
              <div class="card tmss-hot-ttl">
              	<div class="card-header"><div class="card-title"><?= $vew_lang->data; ?></div></div>
              </div>
              <div id="fields">
                <textarea class="hidden" id="argltrrules" name="argltrrules"></textarea>
                <div id="argltrruleshot"></div>
              </div>
						</div>
					</div>
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
    
  </form>
	<script>
    function filterHeaderRow(data) {
      return data.filter(row => {
       // Si la fila solo tiene 'argltrcod' con valor y nada más
       const lv_key = Object.keys(row).filter(k => k !== 'argltrcod');
       return !(row.argltrcod && lv_key.every(k => !row[k]));
      });
  	}
    
		var <?= $lv_sec; ?>_hotcol_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      const isSet = field => instance.getDataAtRowProp(row, field) != null && instance.getDataAtRowProp(row, field) !== "";
		
      if (prop === 'taxcattxtsrc') {
        Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
        td.style.backgroundColor = '#<?= ($vew_readonly ? 'F1F1F1' : 'FFFFFF'); ?>';
        if (isSet('argltrcod') && isSet('taxcatcodsrc')) {
            cellProperties.readOnly = true;
            td.style.backgroundColor = '#F1F1F1';
        }
        
      }else if (prop === 'taxcattxtdst') {
        Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
        td.style.backgroundColor = '#<?= ($vew_readonly ? 'F1F1F1' : 'FFFFFF'); ?>';
        if (isSet('argltrcod') && isSet('taxcatcoddst')) {
            cellProperties.readOnly = true;
            td.style.backgroundColor = '#F1F1F1';
        }
        
      }else if (prop === 'taxcatcodsrc' || prop === 'taxcatcoddst') {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = '#F1F1F1';
        
      }else if (prop === 'argltroprtyp') {
        Handsontable.renderers.DropdownRenderer.apply(this, arguments);
        td.style.backgroundColor = '#<?= ($vew_readonly ? 'F1F1F1' : 'FFFFFF'); ?>';
        if (isSet('argltrcod') && isSet('argltroprtyp')) {
            cellProperties.readOnly = true;
            td.style.backgroundColor = '#F1F1F1';
        }
        
      }else {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = '#<?= ($vew_readonly ? 'F1F1F1' : 'FFFFFF'); ?>';
      }
    };

		var <?= $lv_sec; ?>_hotcoltmpdel = [];
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotcolcnt = $("#<?= $lv_sec; ?> #argltrruleshot")[0];
		var <?= $lv_sec; ?>_hotcolset = {
			height: 196,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
      allowEmpty: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "","<?= $vew_lang->source;?>", "","<?= $vew_lang->destination;?>", "Operacion<?php //echo $vew_lang->operation;?>" ],
			columns: [
				{	type: "text", 
					data: "taxcatcodsrc", 
					width: '7%', 
					renderer: <?= $lv_sec; ?>_hotcol_renderer , 
					readOnly: true 
				},
				{	type: "autocomplete", 
					data: "taxcattxtsrc",
					width: '35%', 
					renderer: <?= $lv_sec; ?>_hotcol_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
        		$.ajax({
          		url: 'index.php?prg=fintaxcat&act=18',
          		dataType: 'json',
          		data: {
            		prm_taxcattxt: query,
								prm_lndcod: 'AR'
          		},
              success: function (response) {
                <?= $lv_sec; ?>_autocompleteCacheSrc = response || [];
                const items = <?= $lv_sec; ?>_autocompleteCacheSrc.map(item => item.taxcattxt);
                process(items);
              },
              error: function () {
                <?= $lv_sec; ?>_autocompleteCacheSrc = [];
                process([]);
              }
        		});
      		},
      		strict: true,
					allowInvalid: false,
					allowEmpty: false
				},
				{	type: "text", 
					data: "taxcatcoddst", 
					width: '7%', 
					renderer: <?= $lv_sec; ?>_hotcol_renderer,
					readOnly: true
				},
				{	type: "autocomplete", 
					data: "taxcattxtdst",
					width: '35%', 
					renderer: <?= $lv_sec; ?>_hotcol_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
        		$.ajax({
          		url: 'index.php?prg=fintaxcat&act=18',
          		dataType: 'json',
          		data: {
            		prm_taxcattxt: query,
								prm_lndcod: 'AR'
          		},
              success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.taxcattxt);
                process(items);
              },
              error: function () {
                <?= $lv_sec; ?>_autocompleteCache = [];
                process([]);
              }
        		});
      		},
      		strict: true,
					allowInvalid: false,
					allowEmpty: false
				},
				{	type: "dropdown", 
					data: "argltroprtyp", 
					width: '20%',
					renderer: <?= $lv_sec; ?>_hotcol_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: ['Local', 'Exterior'],
					allowEmpty: false
				}
			],
      afterChange: function(changes, source) {
      	if (changes && changes.length > 0 && source === 'edit') {
          const row = changes[0][0];
          const valueSelected = changes[0][3] || "";
          if (changes[0][1]=="taxcattxtsrc") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotcol.setDataAtRowProp(row, "taxcatcodsrc", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCacheSrc.find(item => item.taxcattxt === valueSelected);
              if (selectedItem) <?= $lv_sec; ?>_hotcol.setDataAtRowProp(row, "taxcatcodsrc", selectedItem.taxcatcod);
              else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          } else if (changes[0][1]=="taxcattxtdst") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotcol.setDataAtRowProp(row, "taxcatcoddst", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.taxcattxt === valueSelected);
              if (selectedItem) <?= $lv_sec; ?>_hotcol.setDataAtRowProp(row, "taxcatcoddst", selectedItem.taxcatcod);
              else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          }
        }
      },
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotcol.getSourceData();
        // Si solo hay una fila
        if (lv_dat.length === 1) {
          let lv_keys = Object.keys(lv_dat[0]).filter(k => k !== "argltrcod"); // keys de cada fila excepto argltrcod
        	let lv_onlargltrcod = lv_dat[0].argltrcod && lv_keys.every(k => !lv_dat[0][k]); // flag para saber si solo tiene argltrcod
          if (lv_onlargltrcod) return; // no hacemos nada si está vacía
        }
        
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]['argltrcod']!='' && lv_dat[i]['argltrcod']!=undefined ) {
						<?= $lv_sec; ?>_hotcoltmpdel.push( lv_dat[i] );
					}
				}
			},
      licenseKey: gv_handsontable_lc
  	};
		var <?= $lv_sec; ?>_hotcol;
		
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotcol = new Handsontable(<?= $lv_sec; ?>_hotcolcnt, <?= $lv_sec; ?>_hotcolset);	
			var lv_dat = [<?php
				$lv_buffer = '';
				if(is_array($vew_data->recordset)){
					foreach( $vew_data->recordset as $lv_row) {
						$lv_argltroprtyp = $lv_row['argltroprtyp'] == "L" ? 'Local' : ($lv_row['argltroprtyp'] == "E" ? 'Exterior' : $lv_row['argltroprtyp']);
						$lv_buffer .= ($lv_buffer==''?'':', ').'{'
                          .'argltrcod: "'.($lv_row['argltrcod'] ?? '').'", '
                          .'taxcatcodsrc: "'.($lv_row['taxcatcodsrc'] ?? '').'", '
                          .'taxcattxtsrc: "'.($lv_row['taxcattxtsrc'] ?? '').'", '
                          .'taxcatcoddst: "'.($lv_row['taxcatcoddst'] ?? '').'", '
                          .'taxcattxtdst: "'.($lv_row['taxcattxtdst'] ?? '').'", '
                          .'argltroprtyp: "'.($lv_argltroprtyp ?? '').'"}';

					}
				}
				echo $lv_buffer;
			?>];
      lv_dat = filterHeaderRow(lv_dat);
      
			<?= $lv_sec; ?>_hotcol.loadData( lv_dat );
			<?= $lv_sec; ?>_hotcol.render();
      
      <?= $lv_sec; ?>_hotcol.addHook("afterChange", function(changes, source){
        if(source !== "loadData") {
          this.loadData( filterHeaderRow(this.getSourceData()) );
        }
    	});
		});
	</script>
  <script>		
		// form submit ext
    function <?= $lv_sec; ?>_fncext(lp_prm) {
    	// al grabar o borrar
    	if (lp_prm["action"] == "00") {
        // obtengo datos de handsontable 
        var lo_dat = <?= $lv_sec; ?>_hotcol.getSourceData();
        var lv_arr = [];
        for (var i = 0; i < lo_dat.length; i++) {
					var row = lo_dat[i];

          // solo agrego filas válidas con los 3 campos completos
          if (row["taxcatcodsrc"] && row["taxcatcoddst"] && row["argltroprtyp"]) {
            lv_arr.push({
                "argltrcod": row["argltrcod"],
                "taxcatcodsrc": row["taxcatcodsrc"],
                "taxcatcoddst": row["taxcatcoddst"],
                "argltroprtyp": row["argltroprtyp"].substring(0, 1)
          	});
          }
        }
        
        // agrego una fila vacía que simula la cabecera
        lv_arr.push({ "taxcatcodsrc": '', "taxcatcoddst": '', "argltroprtyp": '' });

        // agrego las filas eliminadas
        for (var i = 0; i < <?= $lv_sec; ?>_hotcoltmpdel.length; i++) {
          lv_arr.push({
            "argltrcod": <?= $lv_sec; ?>_hotcoltmpdel[i]["argltrcod"],
            "deleted": "X"
          });
        }

        // envío datos al input oculto
        if (lv_arr.length == 0) {
          $("#<?= $lv_sec; ?> #argltrrules").text("");
        }else {
          $("#<?= $lv_sec; ?> #argltrrules").text(JSON.stringify(lv_arr));
        }
    	}
  	}
  </script>
 	<!-- Form Submit -->
	<?php include('grldocfrmscr.frm'); ?>
</section>
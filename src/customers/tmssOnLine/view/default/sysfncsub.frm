<?php
	// url del formulario 
  $lv_lnk = "?prg=sysfncsub";

	// campos requeridos 
	$vew_input->RequiredFields( array('sysfncttl','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->sysfnccod;

	// titulo 
	$lv_title = $vew_lang->subscriptions;
	
	// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'FNC';
	
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
		<?= gethtml('tmss_actcod','hidden',''); ?>
    <div class="containter-fluid">
      <div class="row">
        <div class="col-md-12">
        <?php
          echo vew_boot($lv_col210, array('label'=>$vew_lang->id, 'input'=>gethtml('sysfnccod', 'doccmt1x50', $vew_data->sysfnc->sysfnccod, $lv_always_disabled) ));
					echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('sysfnctxt', 'doccmt1x50', $vew_data->sysfnc->sysfnctxt, $lv_always_disabled) ));
					echo vew_boot($lv_col210, array('label'=>$vew_lang->module, 'input'=>gethtml('mdlcod', 'doccmt1x50', $vew_data->sysfnc->mdlcod, $lv_always_disabled) ));
        ?><br>
        </div>
        <div class="col-md-12">
          <?= gethtml('sysfnccod','hidden',$vew_data->sysfnc->sysfnccod); ?>
          <textarea id="fnccus" name="fnccus" class="hidden"></textarea>
          <div id="sysfncsubhot" name="sysfncsubhot"></div>
        </div>
      </div>
    </div>
	</form>
	<script>
		// C L I E N T E S
		var <?= $lv_sec; ?>_hotcus_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      var sysfncsubcod = instance.getDataAtRowProp(row, "sysfncsubcod");
			if ( prop=="sysfncsubcod" ) {
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
      } else if ( prop=="cuscod" ) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = "#F1F1F1";
        cellProperties.readOnly = true;
      } else if (prop === "custxt" ) {
        Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
        if (sysfncsubcod !== null && sysfncsubcod !== undefined && sysfncsubcod !== '') {
            td.style.backgroundColor = "#F1F1F1";
            cellProperties.readOnly = true;
        }
			} else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			}
		};
		var <?= $lv_sec; ?>_hotcustmpchg = [];
		var <?= $lv_sec; ?>_hotcustmpdel = [];
		var <?= $lv_sec; ?>_hotcuscnt = $("#<?= $lv_sec; ?> #sysfncsubhot")[0];
		var <?= $lv_sec; ?>_hotcusset = {
			height: 146,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "ID", "Cliente", "Desde", "Hasta"],
			columns: [
				{type: "text", data: "cuscod", renderer: <?= $lv_sec; ?>_hotcus_renderer, readOnly: false },
				{type: "autocomplete", data: "custxt", renderer: <?= $lv_sec; ?>_hotcus_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "index.php?prg=slscus&act=28", dataType: "json", data: {	prm_spctxt: query},
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); return;}},
							success: function (response) {
								// guardo todos los datos adicionales en una variable temporal
								var lv_dat = [];
								<?= $lv_sec; ?>_hotcustmpchg = [];
								for (var i=0; i < response.length; i++) {
									<?= $lv_sec; ?>_hotcustmpchg.push( {custxt: response[i]["custxt"], cuscod: response[i]["cuscod"]} );
									lv_dat.push( response[i]["custxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				},
				{type: "date", data: "sysfncsubstrdte", renderer: <?= $lv_sec; ?>_hotcus_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "date", data: "sysfncsubenddte", renderer: <?= $lv_sec; ?>_hotcus_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> }
			],
			beforeChange: function (changes, source) {
        if (source === "edit" && changes[0][1] === "custxt") {
          var lv_value = changes[0][3];
          for (var i = 0; i < <?= $lv_sec; ?>_hotcustmpchg.length; i++) {
            if (<?= $lv_sec; ?>_hotcustmpchg[i].custxt === lv_value) {
              changes.push([changes[0][0], "cuscod", "", String(<?= $lv_sec; ?>_hotcustmpchg[i].cuscod)]);
            }
          }
        }
    	},
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotcus.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]['sysfncsubcod']!='' && lv_dat[i]['sysfncsubcod']!=undefined ) {
						<?= $lv_sec; ?>_hotcustmpdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotcus;

		// cargo datos en handsontable
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotcus = new Handsontable(<?= $lv_sec; ?>_hotcuscnt, <?= $lv_sec; ?>_hotcusset);
      var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->fnccus as $lv_row){
          $lv_buffer .= ($lv_buffer!=''?',':'').'{sysfncsubcod:"'.$lv_row['sysfncsubcod'].'", cuscod:"'.$lv_row['cuscod'].'", custxt:"'.$lv_row['custxt'].'", sysfncsubstrdte:"'.date_format($lv_row['sysfncsubstrdte'],'d/m/Y').'", sysfncsubenddte:"'.date_format($lv_row['sysfncsubenddte'],'d/m/Y').'"}'; 
        }
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotcus.loadData( lv_dat );
			<?= $lv_sec; ?>_hotcus.render();
		});
	</script>
	<script>
    $(function(e){ tmssHandsontableResize(); });
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      // obtengo datos de handsontable de roles
      if (lp_prm["action"]=="00") {
        var lo_dat = <?= $lv_sec; ?>_hotcus.getSourceData();
        var lv_arr = new Array();
        
        for (var i = 0; i < lo_dat.length - 1; i++) {
          if (!lo_dat[i]["custxt"] || !lo_dat[i]["cuscod"] || !lo_dat[i]["sysfncsubstrdte"] || !lo_dat[i]["sysfncsubenddte"]) {
            toastr.warning("Complete todos los campos");
            return false;
          } else {
            if(lo_dat[i]["sysfncsubcod"] == undefined){
              lo_dat[i]["sysfncsubcod"] = "";
            }
            lv_arr.push({	"sysfncsubcod":lo_dat[i]["sysfncsubcod"],
                          "sysfnccod":$("#<?= $lv_sec; ?> #sysfnccod").prop("value"),
                          "cuscod":lo_dat[i]["cuscod"],
                          "custxt":lo_dat[i]["custxt"],
                          "sysfncsubstrdte":lo_dat[i]["sysfncsubstrdte"],
                          "sysfncsubenddte":lo_dat[i]["sysfncsubenddte"],
                          "docsts":"A"
                        });
        	}
        }
        // agrego las filas eliminadas
        for (var i=0; i< <?= $lv_sec; ?>_hotcustmpdel.length; i++) {
          lv_arr.push({	"sysfncsubcod":<?= $lv_sec; ?>_hotcustmpdel[i]["sysfncsubcod"],
                        "deleted":"X"
                     });
        }
        if (lv_arr.length==0) {
          $("#<?= $lv_sec; ?> #fnccus").prop("value", "");
        } else {
          $("#<?= $lv_sec; ?> #fnccus").prop("value", JSON.stringify( lv_arr ) );
        }
      }
		}
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
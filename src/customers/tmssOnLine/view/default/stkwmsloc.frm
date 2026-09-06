<?php
	// url del formulario
  $lv_lnk = '?prg=stkwmsloc&prm_wmsloccod='.$vew_data->wmsloccod;

	// campos requeridos
	$vew_input->RequiredFields( array('wmsloctxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->wmsloccod;

	// titulo
	$lv_title = $vew_lang->location;
	
	// módulo y programa
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'WLC';
    
	$lv_atr = array();
	$lv_atr[] = array('atrcod'=>'locwid', 'atrtxt'=>'Ancho');
	$lv_atr[] = array('atrcod'=>'lochgt', 'atrtxt'=>'Alto');
	$lv_atr[] = array('atrcod'=>'locdpt', 'atrtxt'=>'Profundidad');
	$lv_atr[] = array('atrcod'=>'locudm', 'atrtxt'=>'UM Dim');
	$lv_atr[] = array('atrcod'=>'locmwt', 'atrtxt'=>'Peso Máx');
	$lv_atr[] = array('atrcod'=>'locuwt', 'atrtxt'=>'UM Peso');
	$lv_atr[] = array('atrcod'=>'locmvl', 'atrtxt'=>'Volumen Máx');
	$lv_atr[] = array('atrcod'=>'locuvl', 'atrtxt'=>'UM Vol');
	$lv_atr[] = array('atrcod'=>'locasq', 'atrtxt'=>'Cant. Autoapilado');
        
        

	$lv_atrcod = array_column($lv_atr, 'atrcod');
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->attributes; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->wmsloccod; ?><?= gethtml('wmsloccod', 'hidden', $vew_data->wmsloccod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">	
			
        <!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code,'input'=>gethtml('wmsloccodext', 'doccmt1x50', $vew_data->wmsloccodext, $lv_default) ));
                   	echo vew_boot($lv_col210, array('label'=>$vew_lang->area,
                                                    'input'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly ),
                                                                        array('input'=>gethtml('wmsaretxt', 'doccmt1x20', $vew_data->wmsaretxt, $lv_default ) )) )); 
                  	echo gethtml('wmsarecod', 'hidden', $vew_data->wmsarecod);
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('wmsloctxt', 'doccmt1x50', $vew_data->wmsloctxt, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status,'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
                </div>
             	</div> <!-- /card -->
          	</div> <!-- /col -->
            <div class="col-md-6">
              <div class="card tmss-hot-ttl">
                <div class="card-header"><div class="card-title"><?= $vew_lang->indicators; ?></div></div>
              </div><!-- /card -->
              <textarea class = "hidden" id = "stkwmsind" name = "stkwmsind"></textarea>
              <div id = "stkwmsindhot"> </div>
            </div><!-- /col -->
          </div><!-- /row -->
				</div> <!-- /_tab001 -->
        
        <!-- /Atributos -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<div class="row">
						<div class="col-md-6">
              <div class="card tmss-hot-ttl">
                <div class="card-header"><div class="card-title"><?= $vew_lang->standardattributes; ?></div></div>
              </div> <!-- /card -->
              <textarea class = "hidden" id = "stkwmsloc" name = "stkwmsloc"></textarea>
              <div id = "stkwmslochot"></div>
            </div>
						<div class="col-md-6">
              <div class="card tmss-hot-ttl">
                <div class="card-header"><div class="card-title"><?= $vew_lang->attributes; ?></div></div>
              </div> <!-- /card -->
              <textarea class = "hidden" id = "stkwmslocatr" name = "stkwmslocatr"></textarea>
            	<div id = "stkwmsatrhot"></div>
            </div>
          </div>
        </div>
		  </div> <!-- /tab-content -->
  	</div> <!-- /container-fluid -->
  </form>
	<script>
    var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      if(prop=="stkwmsindtxt"){
        Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
      }else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
      }
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #stkwmslochot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
    height: 396,
    stretchH: "all",
    minSpareRows: 0,
    colHeaders: ["<?= $vew_lang->Attribute; ?>", "<?= $vew_lang->Value	; ?>"],
    columns: [
      {type: "text", data: "stkwmsloctxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true},
      {type: "numeric", data: "stkwmslocval", numericFormat: {pattern: "0,0.00", culture: "es-AR"}, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true ':''); ?>}
      ],
    cells: function (row, col, prop) {
    var cellProperties = {}; 
    if(col == 1){
        switch(row){
          case <?= array_search('locudm', $lv_atrcod) ?>:
            cellProperties.type = "dropdown";
            cellProperties.source = ["cm", "m", "mm"];
            cellProperties.renderer = <?= $lv_sec; ?>_hotdoc_renderer;
            break;
          case <?= array_search('locuwt', $lv_atrcod) ?>:
            cellProperties.type = "dropdown";
            cellProperties.source = ["kg", "tn"] ;
            cellProperties.renderer = <?= $lv_sec; ?>_hotdoc_renderer;
            break;
          case <?= array_search('locuvl', $lv_atrcod) ?>:
            cellProperties.type = "dropdown";
            cellProperties.source = ["m3", "cm3"] ;
            cellProperties.renderer = <?= $lv_sec; ?>_hotdoc_renderer;
            break;
        }
    }

    return cellProperties;
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
    licenseKey: gv_handsontable_lc
  };
  var <?= $lv_sec; ?>_hotdoc;

  // cargo datos en handsontable
  tmssLoadScript("handsontable16",function(){
    <?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
    var lv_dat = [<?php
      $lv_buffer='';
      foreach($lv_atr as $lv_row){
        $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                    'stkwmsloccod:"'.$lv_row['atrcod'].'",'.
                    'stkwmsloctxt:"'.$lv_row['atrtxt'].'",'.
                    'stkwmslocval:"'.$vew_doc->getTagValue($vew_data->wmslocatr, $lv_row['atrcod']).
                '"}'; 
      }
      echo $lv_buffer;
    ?>];
    <?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
    <?= $lv_sec; ?>_hotdoc.render();
  });
    
  var <?= $lv_sec; ?>_hotdocatrcnt = $("#<?= $lv_sec; ?> #stkwmsatrhot")[0];
	var <?= $lv_sec; ?>_hotdocatrset = {
    height: 396,
    stretchH: "all",
    <?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
    minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
    colHeaders: ["<?= $vew_lang->Attribute; ?>", "<?= $vew_lang->Value	; ?>"],
    columns: [
      {type: "text", data: "stkwmsloccod", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true ':''); ?>},
      {type: "text", data: "stkwmslocval", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true ':''); ?>}
      ],
    beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["stkwmsloccod"]!="" && lv_dat[i]["stkwmsloccod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			},
    licenseKey: gv_handsontable_lc
  };
  var <?= $lv_sec; ?>_hotdocatr;
  tmssLoadScript("handsontable16",function(){
    <?= $lv_sec; ?>_hotdocatr = new Handsontable(<?= $lv_sec; ?>_hotdocatrcnt, <?= $lv_sec; ?>_hotdocatrset);	
    var lv_dat = [<?php
        $lv_buffer='';

        $xml = simplexml_load_string('<root>'.$vew_data->wmslocatr.'</root>');

        $fixed = [
            'LOCWID','LOCHGT','LOCDPT','LOCUDM',
            'LOCMWT','LOCUWT','LOCMVL','LOCUVL','LOCASQ'
        ];

        if($xml){
            foreach($xml as $tag => $value){
                if(in_array($tag, $fixed)) continue;

                $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                    'stkwmsloccod:"'.$tag.'",'.
                    'stkwmslocval:"'.$value.'"'.
                '}';
            }
        }

        echo $lv_buffer;
    ?>];
    <?= $lv_sec; ?>_hotdocatr.loadData( lv_dat );
    <?= $lv_sec; ?>_hotdocatr.render();
  });
  
    
  var <?= $lv_sec; ?>_autocompleteCache = [];
  var <?= $lv_sec; ?>_hotdocdelind = [];
  var <?= $lv_sec; ?>_hotdocindcnt = $("#<?= $lv_sec; ?> #stkwmsindhot")[0];
	var <?= $lv_sec; ?>_hotdocindset = {
    height: 396,
    stretchH: "all",
    <?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
    minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
    colHeaders: ["<?= $vew_lang->Description	; ?>"],
    columns: [
      {type: "autocomplete", data: "stkwmsindtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?' readOnly: true, ':''); ?>
      source (query, process) {
						$.ajax({
							url: "?prg=stkwmsind&act=18", dataType: "json", data: {	prm_wmsindtxt: query },
              success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.wmsindtxt);
                process(items);
              },
              error: function () {
                <?= $lv_sec; ?>_autocompleteCache = [];
                process([]);
              }
						});
					},
					strict: true
				}
      ],
    afterChange: function(changes, source) {
      if(source == "autocomplete") return;
      if (changes && changes.length > 0) {
        const row = changes[0][0];
        const valueSelected = changes[0][3] || "";
        if (changes[0][1]=="stkwmsindtxt"){
          if (valueSelected === "") {
            <?= $lv_sec; ?>_hotdocind.setDataAtRowProp(row, "stkwmsindcod", "");
          } else {
            var selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.wmsindtxt === valueSelected);
            if (selectedItem) {
              <?= $lv_sec; ?>_hotdocind.setDataAtRowProp(row, "stkwmsindcod", selectedItem.wmsindcod);
            }
            else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
          }
        }
      }
    },
    beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotdocind.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["stkwmslocindcod"]!="" && lv_dat[i]["stkwmslocindcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdelind.push( lv_dat[i] );
					}
				}
			},
    licenseKey: gv_handsontable_lc
  };
  var <?= $lv_sec; ?>_hotdocind;
  tmssLoadScript("handsontable16",function(){
    <?= $lv_sec; ?>_hotdocind = new Handsontable(<?= $lv_sec; ?>_hotdocindcnt, <?= $lv_sec; ?>_hotdocindset);	
    var lv_dat = [<?php
        $lv_buffer='';
				foreach($vew_data->stkwmsind as $lv_row){ $lv_buffer .= ($lv_buffer!=''?',':'').'{stkwmsindcodext:"'.$lv_row['wmsindcodext'].'", stkwmsindtxt:"'.$lv_row['wmsindtxt'].'", stkwmslocindcod:"'.$lv_row['wmslocindcod'].'", stkwmsindcod:"'.$lv_row['wmsindcod'].'"}';}
        echo $lv_buffer;
    ?>];
    <?= $lv_sec; ?>_hotdocind.loadData( lv_dat );
    <?= $lv_sec; ?>_hotdocind.render();
  });
  </script>
  <script>
	    // Area
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"wmsarecod":"wmsarecod", "wmsaretxt":"wmsaretxt"}};
  	tmssTypeahead($("#<?= $lv_sec; ?> #wmsaretxt"), "stkwmsare", lo_get);
  </script>
  <script>
    // form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      // al grabar
			if ( lp_prm["action"]=="00" ) {
      	// Obtiene datos de HOT de atributos de vehículo  
        var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
        var lo_datatr = <?= $lv_sec; ?>_hotdocatr.getSourceData();
        var lv_dat = "";
        for (var i=0; i<lo_dat.length ; i++) {
          lv_dat += "<" + lo_dat[i]["stkwmsloccod"] + ">" + lo_dat[i]["stkwmslocval"] + "</" + lo_dat[i]["stkwmsloccod"] + ">";
        }
        for (var i=0; i<lo_datatr.length ; i++) {
          if(!lo_datatr[i]["stkwmsloccod"]) continue;
          lv_dat += "<" + lo_datatr[i]["stkwmsloccod"] + ">" + lo_datatr[i]["stkwmslocval"] + "</" + lo_datatr[i]["stkwmsloccod"] + ">";
        }
        $("#<?= $lv_sec; ?> #stkwmslocatr").prop("value", lv_dat );
        
        var lv_datind = <?= $lv_sec; ?>_hotdocind.getSourceData();
        var lv_arr = new Array();
                
        for (var i=0; i < lv_datind.length; i++) {
          if(lv_datind[i]["stkwmsindcod"]!=undefined) {
            lv_arr.push({	"wmslocindcod":lv_datind[i]["stkwmslocindcod"],
                          "wmsindcod":lv_datind[i]["stkwmsindcod"]
                        });
          }
				}
        
        var lv_del = <?= $lv_sec; ?>_hotdocdelind;
        for (var i=0; i < lv_del.length; i++) {
          lv_arr.push({	"wmslocindcod":lv_del[i]["stkwmslocindcod"],
                       	"wmsindcod":lv_del[i]["stkwmsindcod"],
                   	   	"deleted":"X"
                      });
				}
                
      	if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #stkwmsind").prop("value", "");						
				} else {
					$("#<?= $lv_sec; ?> #stkwmsind").prop("value", JSON.stringify( lv_arr ) );
				}
      }
      
    
    }
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
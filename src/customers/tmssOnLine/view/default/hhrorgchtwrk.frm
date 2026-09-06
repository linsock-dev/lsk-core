<?php
	// url del formulario
  $lv_lnk = '?prg=hhrorgcht';

	// campos requeridos
	$vew_input->RequiredFields( array('wrkstetxt', 'wrkstecod') );

	// clave del documento
	$lv_dockey = $vew_data->hhrorgchtwrkcod;
	
	// titulo
	$lv_title = $vew_lang->organizationchart;

	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'ORG';
	
	// librería de estilos bootstrap
	include_once('_library.frm');

	$vew_readonly = $vew_actcod == '13';

	// corrige tildes
	$lv_asg_arr = $vew_data->asg;
	foreach($lv_asg_arr as &$lv_row){
    $lv_row['hhremptxt'] = utf8_encode($lv_row['hhremptxt']);
    $lv_row['wrkplctxt'] = utf8_encode($lv_row['wrkplctxt']);
    $lv_row['wrkstepft'] = $lv_row['wrkstepft'] == 1;
    $lv_row['hhremptmestr'] = date_format($lv_row['hhremptmestr'], 'd/m/Y');
  }
	unset($lv_row);

	$lv_cap_arr = $vew_data->cap;
	foreach($lv_cap_arr as &$lv_row){
    $lv_row['wrkplctxt'] = utf8_encode($lv_row['wrkplctxt']);
    $lv_row["captyp"] = $lv_row["hhrorgchtwrkcaptyp"] ? $vew_lang->staff : $vew_lang->hours;
  }
	unset($lv_row);
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('hhrorgchtwrkcod', 'hidden', $vew_data->hhrorgchtwrkcod); ?>
    <?= gethtml('hhrorgchtcod', 'hidden', $vew_data->hhrorgchtcod); ?>
    <?= gethtml('wrkstehghcod', 'hidden', $vew_data->wrkstehghcod); ?>
    <?= gethtml('svedata', 'hidden', ''); ?>
    <a href="#" class="hidden" id="svebtn" onclick="<?= $lv_sec; ?>_save();"></a>
    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
      <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
        <li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
        <li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->capacity; ?></a></li>
        <li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->assignment; ?></a></li>
        <li class="pull-right"><h4># <strong id="hhrorgchtwrkcod"><?= $vew_data->hhrorgchtwrkcod ?></strong><?= gethtml('hhrorgchtwrkcod', 'hidden', $vew_data->hhrorgchtwrkcod); ?></h4></li>
      </ul>
      <div class="tab-content tmss-tab-content">

        <!-- GENERAL -->
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
            <div class="col-md-12">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->workstation; ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                  	if(count($lv_asg_arr)){
                    	echo vew_boot($lv_col210,	array('label'=>$vew_lang->workstation, 'input'=>gethtml('wrkstetxt', 'doccmt1x50', $vew_data->wrkstetxt, $lv_always_disabled) ));
                    }else{
                      echo vew_boot($lv_col210,	array('label'=>$vew_lang->workstation, 
                                                        'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                            array('input'=>gethtml('wrkstetxt', 'typeahead', '', $lv_default) ) )
                                                         ));
                    }
                    echo gethtml('wrkstecod', 'hidden', $vew_data->wrkstecod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('wrkstedes', 'doccmt4x50', $vew_data->wrkstedes, $lv_always_disabled) ));
                  ?>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- CAPACIDAD -->
        <div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
          <div class="row">
            <div class="col-md-12">
              <div class="card tmss-hot-ttl">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->capacity; ?>
                  </div>
                </div>
              </div>
              <div id="captbl"></div>
            </div>
          </div>
        </div>

        <!-- ASIGNACIÓN -->
        <div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
          <div class="row">
            <div class="col-md-12">
              <div class="card tmss-hot-ttl">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->assignment; ?>
                  </div>
                </div>
              </div>
            	<div id="asgtbl"></div>
            </div>
          </div>  
        </div>

      </div>
    </div>
  </form>
  <script>
    $("a[href='#<?= $lv_sec; ?>_tab002']").on('shown.bs.tab', function(e){
      lv_<?= $lv_sec; ?>_cap_tbl.render();  
    });
    
    $("a[href='#<?= $lv_sec; ?>_tab003']").on('shown.bs.tab', function(e){
      lv_<?= $lv_sec; ?>_asg_tbl.render();
    });
  </script>
  <script>
    // CONFIGURACIÓN DE LAS TABLAS
    var lv_<?= $lv_sec; ?>_asg_tbl, lv_<?= $lv_sec; ?>_cap_tbl;
    
    var <?= $lv_sec; ?>_cap_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if( lv_<?= $lv_sec; ?>_cap_tbl != undefined ) {
        td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
        
				if ( prop=="hhrorgchtwrkpft" || prop=="hhrorgchtwrknonpft" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
				} else if ( prop=="wrkplctxt" ) {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
				} else {
					Handsontable.renderers.DropdownRenderer.apply(this, arguments);
				}
			}
		};
    var <?= $lv_sec; ?>_capchg = [];
		var <?= $lv_sec; ?>_capdel = [];
		var <?= $lv_sec; ?>_caperr = [];
    var <?= $lv_sec; ?>_capset = {
			height: 196,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],'); ?>
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->workplace;?>", "<?= $vew_lang->productive;?>", "<?= $vew_lang->nonproductive;?>", "<?= $vew_lang->type;?>" ],
			columns: [
				{type: "autocomplete", data: "wrkplctxt", width: 60, renderer: <?= $lv_sec; ?>_cap_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "?prg=hhrwrkplc&act=18", dataType: "json", data: {	prm_wrkplctxt: query },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
							success: function (response) {
								var lv_dat = [];
								<?= $lv_sec; ?>_capchg = [];
								for (var i=0; i < response.length; i++) {
									<?= $lv_sec; ?>_capchg.push( {wrkplctxt: response[i]["wrkplctxt"], wrkplccod: response[i]["wrkplccod"]} );
									lv_dat.push( response[i]["wrkplctxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				},
				{type: "numeric", data: "hhrorgchtwrkpft", width: 15, renderer: <?= $lv_sec; ?>_cap_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
        {type: "numeric", data: "hhrorgchtwrknonpft", width: 15, renderer: <?= $lv_sec; ?>_cap_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "dropdown", data: "captyp", width: 10, source: ["<?= $vew_lang->hours; ?>", "<?= $vew_lang->staff; ?>"], width: 18, renderer: <?= $lv_sec; ?>_cap_renderer <?= ($vew_readonly?', readOnly: true':'');	?> }
			],
			beforeChange : function(changes, source) {
				if(source=="edit"){
          var lv_value = changes[0][3];
          if(changes[0][1]=="wrkplctxt") {
            for(var i=0 ; i < <?= $lv_sec; ?>_capchg.length ; i++) {
              if(<?= $lv_sec; ?>_capchg[i].wrkplctxt == lv_value) {
                changes.push([ changes[0][0], "wrkplccod", "", <?= $lv_sec; ?>_capchg[i].wrkplccod ]);
              }
            }
          }else if(changes[0][1]=="captyp"){ 
            var lv_typkey = lv_value == "<?= $vew_lang->hours; ?>" ? 0 : 1;
            changes.push([ changes[0][0], "hhrorgchtwrkcaptyp", "", lv_typkey ]);
          }
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = lv_<?= $lv_sec; ?>_cap_tbl.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["wrkplccod"]!="" && lv_dat[i]["wrkplccod"]!=undefined ) {
						<?= $lv_sec; ?>_capdel.push( lv_dat[i] );
					}
				}
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_caperr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_caperr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_caperr.splice(lv_inx,1); }
				}
			}
		};
    
    
    
    // A S I G N A C I O N E S asignaciones
    var <?= $lv_sec; ?>_asg_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if( lv_<?= $lv_sec; ?>_asg_tbl != undefined ) {
        td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
        
				if ( prop=="wrkstepft" ) {
					Handsontable.renderers.CheckboxRenderer.apply(this, arguments);
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
				}
			}
		};
    var <?= $lv_sec; ?>_asgchg = [];
    var <?= $lv_sec; ?>_asgdel = [];
    var <?= $lv_sec; ?>_asgerr = [];
    var <?= $lv_sec; ?>_asgset = {
			height: 350,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],'); ?>
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
      colHeaders: [ "<?= $vew_lang->workplace;?>", "<?= $vew_lang->responsible;?>", "<?= $vew_lang->schedule;?>", "<?= $vew_lang->productive;?>" ],
			columns: [
				{type: "autocomplete", data: "wrkplctxt", width: 50, renderer: <?= $lv_sec; ?>_asg_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "?prg=hhrwrkplc&act=18", dataType: "json", data: {	prm_wrkplctxt: query },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
							success: function (response) {
								var lv_dat = [];
								<?= $lv_sec; ?>_asgchg = [];
								for (var i=0; i < response.length; i++) {
									<?= $lv_sec; ?>_asgchg.push( {wrkplctxt: response[i]["wrkplctxt"], wrkplccod: response[i]["wrkplccod"]} );
									lv_dat.push( response[i]["wrkplctxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				},
				{type: "autocomplete", data: "hhremptxt", width: 50, renderer: <?= $lv_sec; ?>_asg_renderer <?= ($vew_readonly?', readOnly: true':'');	?>,
        	source: function (query, process) {
						$.ajax({
							url: "?prg=hhremp&act=18", dataType: "json", data: {	prm_hhremptxt: query },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
							success: function (response) {
								var lv_dat = [];
								<?= $lv_sec; ?>_asgchg = [];
								for (var i=0; i < response.data.length; i++) {
									<?= $lv_sec; ?>_asgchg.push( {hhremptxt: response.data[i]["hhremptxt"], hhrempcod: response.data[i]["hhrempcod"]} );
									lv_dat.push( response.data[i]["hhremptxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
        },
        {type: "autocomplete", data: "hhrtmerngtxt", width: 40, renderer: <?= $lv_sec; ?>_asg_renderer <?= ($vew_readonly?', readOnly: true':'');	?>,
        	source: function (query, process) {
						$.ajax({
							url: "?prg=hhrtmerng&act=18", dataType: "json", data: {	prm_hhrtmerngtxt: query },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
							success: function (response) {
								var lv_dat = [];
								<?= $lv_sec; ?>_asgchg = [];
								for (var i=0; i < response.data.length; i++) {
									<?= $lv_sec; ?>_asgchg.push( {hhrtmerngtxt: response.data[i]["hhrtmerngtxt"], hhrtmerngcod: response.data[i]["hhrtmerngcod"]} );
									lv_dat.push( response.data[i]["hhrtmerngtxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
        },
				{type: "checkbox", data: "wrkstepft", width: 10, width: 18, renderer: <?= $lv_sec; ?>_asg_renderer <?= ($vew_readonly?', readOnly: true':'');	?> }
			],
			beforeChange : function(changes, source) {
				if(source=="edit"){
          var lv_value = changes[0][3];
          if(changes[0][1]=="wrkplctxt") {
            for(var i=0 ; i < <?= $lv_sec; ?>_asgchg.length ; i++) {
              if(<?= $lv_sec; ?>_asgchg[i].wrkplctxt == lv_value) {
                changes.push([ changes[0][0], "wrkplccod", "", <?= $lv_sec; ?>_asgchg[i].wrkplccod ]);
              }
            }
          }else if(changes[0][1]=="hhremptxt"){ 
            for(var i=0 ; i < <?= $lv_sec; ?>_asgchg.length ; i++) {
              if(<?= $lv_sec; ?>_asgchg[i].hhremptxt == lv_value) {
                changes.push([ changes[0][0], "hhrempcod", "", <?= $lv_sec; ?>_asgchg[i].hhrempcod ]);
              }
            }
          }else if(changes[0][1]=="hhrtmerngtxt"){ 
            for(var i=0 ; i < <?= $lv_sec; ?>_asgchg.length ; i++) {
              if(<?= $lv_sec; ?>_asgchg[i].hhrtmerngtxt == lv_value) {
                changes.push([ changes[0][0], "hhrtmerngcod", "", <?= $lv_sec; ?>_asgchg[i].hhrtmerngcod ]);
              }
            }
          }
        }
      },
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = lv_<?= $lv_sec; ?>_asg_tbl.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["wrkplccod"]!="" && lv_dat[i]["wrkplccod"]!=undefined
             && lv_dat[i]["hhrempcod"]!="" && lv_dat[i]["hhrempcod"]!=undefined
             && lv_dat[i]["hhrtmerngcod"]!="" && lv_dat[i]["hhrtmerngcod"]!=undefined) {
						<?= $lv_sec; ?>_asgdel.push( lv_dat[i] );
					}
				}
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_asgerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_asgerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_asgerr.splice(lv_inx,1); }
				}
			}
		};
    
    tmssLoadScript("handsontable", function(){
      lv_<?= $lv_sec; ?>_cap_tbl = new Handsontable($("#<?= $lv_sec; ?> #captbl")[0], <?= $lv_sec; ?>_capset); 
      lv_<?= $lv_sec; ?>_asg_tbl = new Handsontable($("#<?= $lv_sec; ?> #asgtbl")[0], <?= $lv_sec; ?>_asgset); 
      lv_<?= $lv_sec; ?>_asg_tbl.loadData(<?= json_encode($lv_asg_arr); ?> ?? []);
      lv_<?= $lv_sec; ?>_cap_tbl.loadData(<?= json_encode($lv_cap_arr); ?> ?? []);
    });
  </script>
  <script>
    function <?= $lv_sec; ?>_formatDate(lp_dte){
      var lv_day = lp_dte.getDate();
      var lv_mth = lp_dte.getMonth()+1;
      lv_day = (lv_day < 10 ? '0' : '') + lv_day;
      lv_mth = (lv_mth < 10 ? '0' : '') + lv_mth;
      return  lv_day +  "/" + lv_mth + "/" + lp_dte.getFullYear();  
    }
    
  	tmssTypeahead($("#<?= $lv_sec; ?> #wrkstetxt"), "wrkste", {fldsec: "<?= $lv_sec; ?>", fldasg: {"wrkstetxt": "wrkstetxt", "wrkstecod": "wrkstecod", "wrkstedes": "wrkstedes"}}, 
                	{"afterAssign": function(data){
                    $("#<?= $lv_sec; ?> #wrkstetxt").val($("#<?= $lv_sec; ?> #wrkstetxt:first").val()); 
                    
                    var lv_pst = [{name: "hhremptmedte", value: <?= $lv_sec; ?>_formatDate(new Date())},
                                 {name: "nomaxrec", value: "X"}];
                    
                    // actualizo las asignaciones 
                    tmssCallProcess("?prg=hhremptme&act=18&prm_wrkstecod="+$("#<?= $lv_sec; ?> #wrkstecod").val(), lv_pst, function(data){
                      if(data.data){
                        var lv_asg = data.data;
                        for(let i=0; i < lv_asg.length; i++){
                          lv_asg[i]["hhremptmestr"] = <?= $lv_sec; ?>_formatDate(new Date(lv_asg[i]["hhremptmestr"]["date"]));
                          lv_asg[i]["hhremptmeend"] = <?= $lv_sec; ?>_formatDate(new Date(lv_asg[i]["hhremptmeend"]["date"]));
                          lv_asg[i]["wrkstepft"] = lv_asg[i]["wrkstepft"] == 1;
                        }

                        lv_<?= $lv_sec; ?>_asg_tbl.loadData(lv_asg);
                      }
                    });
                  }});
  </script>
  <script>
    function <?= $lv_sec; ?>_save(){
      // reuno datos de capacidad
      var lo_dat = lv_<?= $lv_sec; ?>_cap_tbl.getSourceData();
      var lv_cap = new Array();
      for (var i=0; i<lo_dat.length-1; i++) {
        if ( lo_dat[i]["wrkplccod"] != "" && lo_dat[i]["wrkplccod"] != undefined ) {
          lv_cap.push({	"hhrorgchtwrkcapcod":	lo_dat[i]["hhrorgchtwrkcapcod"],
                        "wrkplccod":					lo_dat[i]["wrkplccod"],
                        "hhrorgchtwrkpft":		lo_dat[i]["hhrorgchtwrkpft"],
                        "hhrorgchtwrknonpft":	lo_dat[i]["hhrorgchtwrknonpft"],
                        "hhrorgchtwrkcaptyp":	lo_dat[i]["hhrorgchtwrkcaptyp"]
                      });
        }else{
					toastr.warning("Todos los registros de capacidad deben tener un lugar de trabajo v&aacute;lido.");
          return false;
        }
      }
      // agrego las filas eliminadas
      for (var i=0; i< <?= $lv_sec; ?>_capdel.length; i++) {
        lv_cap.push({ "hhrorgchtwrkcapcod": <?= $lv_sec; ?>_capdel[i]["hhrorgchtwrkcapcod"], "deleted":"X"});
      }
       
      // reuno datos de asignaciones
      var lo_dat = lv_<?= $lv_sec; ?>_asg_tbl.getSourceData();
      var lv_asg = new Array();
      for (var i=0; i<lo_dat.length-1; i++) {
        if ( lo_dat[i]["wrkplccod"] != "" && lo_dat[i]["wrkplccod"] != undefined
           && lo_dat[i]["hhrempcod"] != "" && lo_dat[i]["hhrempcod"] != undefined
           && lo_dat[i]["hhrtmerngcod"] != "" && lo_dat[i]["hhrtmerngcod"] != undefined ) {
          lv_asg.push({	"hhrorgchtwrkempcod":	lo_dat[i]["hhrorgchtwrkempcod"],
                        "hhrempcod":					lo_dat[i]["hhrempcod"],
                        "wrkplccod":					lo_dat[i]["wrkplccod"],
                        "hhrtmerngcod":				lo_dat[i]["hhrtmerngcod"],
                        "hhremptmecod":				lo_dat[i]["hhremptmecod"],
                        "wrkstepft":					lo_dat[i]["wrkstepft"] ? 1 : 0,
                        "hhremptmestr":				lo_dat[i]["hhremptmestr"]
                      });
        }else{
					toastr.warning("Todos los registros de asignaci&oacute;n deben tener un lugar de trabajo, empleado y horario v&aacute;lidos.");
          return false;
        }
      }
      // agrego las filas eliminadas
      for (var i=0; i< <?= $lv_sec; ?>_asgdel.length; i++) {
        lv_asg.push({ "hhrorgchtwrkempcod": <?= $lv_sec; ?>_asgdel[i]["hhrorgchtwrkempcod"], 
                     "hhremptmecod": <?= $lv_sec; ?>_asgdel[i]["hhremptmecod"],
                     "deleted":"X"});
      }
      
      var lv_pst = [{name:"wrkstecod", value: $("#<?= $lv_sec; ?> #wrkstecod").val()},
                    {name:"hhrorgchtcod", value: $("#<?= $lv_sec; ?> #hhrorgchtcod").val()},
                    {name:"hhrorgchtwrkcod", value: $("#<?= $lv_sec; ?> #hhrorgchtwrkcod").val()},
                    {name:"wrkstehghcod", value: $("#<?= $lv_sec; ?> #wrkstehghcod").val()},
                    {name:"cap", value: JSON.stringify(lv_cap)},
                    {name:"asg", value: JSON.stringify(lv_asg)}];
      
      $("#<?= $lv_sec; ?> #svedata").val(JSON.stringify(lv_pst));
    }
  </script>
  <script>
  	function <?= $lv_sec; ?>_formeditext(){
      tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='11'||$vew_actcod=='12'?'true':'false'); ?>);
    }
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
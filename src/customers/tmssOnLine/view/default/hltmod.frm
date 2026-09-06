<?php
	// url del formulario 
  $lv_lnk = '?prg=hltmod&prm_hltmodcod='.$vew_data->hltmodcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('hltmodtxt','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->hltmodcod; 

	// titulo 
	$lv_title = $vew_lang->module;
	
	// módulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'MOD';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!--navbar-->
	<?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
    
    <textarea id="hltmodpln" name="hltmodpln" class="hidden"></textarea>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hltmodcod; ?><?= gethtml('hltmodcod', 'hidden', $vew_data->hltmodcod) ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title">
                  <?= $vew_lang->module; ?>
                  <span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->doccls->sysdocclstxt)); ?></span>
                  <?php 
                    echo gethtml('sysdocclstxt', 'hidden', $vew_data->doccls->sysdocclstxt);
                    echo gethtml('sysdocclscod', 'hidden', $vew_data->doccls->sysdocclscod);
                  ?>
                </div></div>

                <div class="card-body tmss-card-body-edit">
                	<?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('hltmodcodext', 'doccmt1x20', $vew_data->hltmodcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hltmodtxt', 'doccmt1x50', $vew_data->hltmodtxt, $lv_default) ));								
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div><!--body-->
              </div><!--card-->
						</div>
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->data; ?></div></div>

                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->customer,
                                            'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly ),
                                                                array('input'=>gethtml('custxt', 'typeahead', $vew_data->custxt,$lv_default) ))));
                  	echo gethtml('cuscod', 'hidden', $vew_data->cuscod);
                  ?>
                </div><!--body-->
              </div><!--card-->
						</div>
					</div>
					<hr>
					<div id="hltmodplnhot" name="hltmodplnhot"></div>
				</div> <!-- fin _tab001 -->

			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
		// CLIENTE
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"cuscod":"cuscod", "custxt":"custxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #custxt"), "slscus", lo_get);
	</script>
	<script>
		/**
		 *
		 *	E S P E C I A L I D A D E S
		 *
		 */
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if(prop=="edumodplnatrtyp" || prop=="srcobjtyptxt"){
				Handsontable.renderers.DropdownRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
      }else if ( prop == "srcobjcod" || prop == "hltmodplncod"){
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = "#F1F1F1";
      }else {
        Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
        td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #hltmodplnhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->id; ?>", "<?= $vew_lang->Source; ?>", "<?= $vew_lang->code; ?>", "<?= $vew_lang->name; ?>", "<?= $vew_lang->Type; ?>" ],
			columns: [
				{type: "text", data: "hltmodplncod", width: 5, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
        {type: "dropdown", data: "srcobjtyptxt", source: ["<?= $vew_lang->Specialties; ?>","<?= $vew_lang->DiseasesClassification; ?>","<?= $vew_lang->zones; ?>"], width: 30, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?',readOnly: true, ':''); ?>},
        {type: "text", data: "srcobjcod", width: 7, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
        {type: "autocomplete", data: "srcobjtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, width: 100, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
            //obtengo el nombre del tipo de objeto seleccionado
            var lv_srcobjtyptxt = "";
            lv_srcobjtyptxt = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( this.row, "srcobjtyptxt" );
            //obtiene el tipo de objeto
            var lv_srcobjtyp = <?= $lv_sec; ?>_getSrcobjtyp( lv_srcobjtyptxt );
						var lv_url = "?prg="+lv_srcobjtyp.url+"&act=18";
            var lv_prm = lv_srcobjtyp.id+"txt";
            //si no se selecciono un tipo de objeto o no se pudo recuperar el tipo de objeto no se devuelve nada
            if( lv_srcobjtyp != "" ){
              $.ajax({
                url: lv_url, type: "POST", dataType: "json", data: [{ name: lv_prm, value: query }, {name:"objtyp", value:"HLT_PAT"}],
                success: function(response){
                  <?= $lv_sec; ?>_autocompleteCache = Array.isArray(response?.data) ? response.data : Array.isArray(response) ? response : [];
                  const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item[lv_srcobjtyp.id+"txt"]);
                  process(items);
                },
                error: function () {
                  <?= $lv_sec; ?>_autocompleteCache = [];
                  process([]);
                }
              });
            }
					},
					strict: true
				},
				{type: "dropdown", data: "hltmodplnatr", renderer: <?= $lv_sec; ?>_hotdoc_renderer, width: 20, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: ["1-Evaluado","2-Inasistencia"],
					strict: true
				}
			],			
      afterChange : function(changes, source) {
        if(source === "edit" && changes && changes.length > 0){
          const row = changes[0][0];
          const valueSelected = changes[0][3] || "";
          if (changes[0][1] === "srcobjtyptxt" && changes[0][2] != changes[0][3]) {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "srcobjcod", "");
            } else {
              const colSource = <?= $lv_sec; ?>_hotdoc.getSettings().columns.find(c => c.data == "srcobjtyptxt").source;
              const selectedItem = colSource.find(item => item === valueSelected);
              if(selectedItem) {
                <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "srcobjtxt", "", "autocomplete");
                <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "srcobjcod", "", "autocomplete");
              } else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          }
          if ( changes[0][1] === "srcobjtxt") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "srcobjcod", "");
            } else {
              //obtengo el nombre del tipo de objeto seleccionado
              var lv_srcobjtyptxt = "";
              lv_srcobjtyptxt = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( row, "srcobjtyptxt" );
              //obtiene el tipo de objeto
              var lv_srcobjtyp = <?= $lv_sec; ?>_getSrcobjtyp( lv_srcobjtyptxt );
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item[lv_srcobjtyp.id+"txt"] === valueSelected);
              if (selectedItem) { <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "srcobjcod", selectedItem[lv_srcobjtyp.id+"cod"]);
              } else { 
                <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "srcobjcod", "", "autocomplete");
                toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
              }
            }
          }
        }
      },
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["hltmodplncod"]!="" && lv_dat[i]["hltmodplncod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
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
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotdoc;	

		// cargo datos en handsontable
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
      var lv_dat = [<?php
        $lv_buffer='';
        if ($vew_data->hltmodpln != ''){
          foreach($vew_data->hltmodpln as $lv_row){
            $lv_typ = $vew_doc->getTagValue($lv_row['hltmodplnatr'],'ctrtyp');
            $lv_typ = ($lv_typ=='1'?'1-Evaluado':($lv_typ=='2'?'2-Inasistencia':''));
            $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                          'hltmodplncod:"'.$lv_row['hltmodplncod'].'",'.
                          'srcobjtyptxt:"'.($lv_row['srcobjtyp']=='HLT_SPC' ? $vew_lang->Specialties : ($lv_row['srcobjtyp']=='HLT_DCL' ? $vew_lang->DiseasesClassification : $vew_lang->zones) ).'",'.
                          'srcobjtyp:"'.$lv_row['srcobjtyp'].'",'.
                          'srcobjtxt:"'.$lv_row['srcobjtxt'].'",'.
                          'srcobjcod:"'.$lv_row['srcobjcod001'].'",'.
                          'hltmodplnatr:"'.$lv_row['hltmodplnatr'].'"}'; 
          }
          echo $lv_buffer;
        }
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
    
    // Se utiliza únicamente para saber a qué controlador llamar para hacer el getList de especialidades o clasificaciones de infermedades
    function <?= $lv_sec; ?>_getSrcobjtyp( lp_srcobjtyptxt ){
      switch( lp_srcobjtyptxt ){
        case "<?= $vew_lang->Specialties; ?>":
          return {id:"spc", url:"hltspc"};
          break;
          
        case "<?= $vew_lang->DiseasesClassification; ?>":
          return {id:"hltdiscls", url:"hltdiscls"};
          break;
          
        case "<?= $vew_lang->zones; ?>":
          return {id:"adrzon", url:"grldatzon"};
          break;
          
        default:
          return "";
      }
    }
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
      // al grabar
			if(lp_prm["action"]=="00") {
        var lv_arr = new Array();
        
				// agrego las filas eliminadas
				for (var i=0; i< <?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({"hltmodplncod":<?= $lv_sec; ?>_hotdocdel[i]["hltmodplncod"],"deleted":"X"});
				}
				
				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();			
				for (var i=0; i<lo_dat.length; i++) {
          //obtiene el codigo de objeto
          if(lo_dat[i]["srcobjtyp"] != undefined){
            lv_srcobjtyp = lo_dat[i]["srcobjtyp"];
          }else{
            if(lo_dat[i]["srcobjtyptxt"] == "<?= $vew_lang->Specialties; ?>"){
              lv_srcobjtyp = "HLT_SPC";
            }else if(lo_dat[i]["srcobjtyptxt"] == "<?= $vew_lang->DiseasesClassification; ?>"){
              lv_srcobjtyp = "HLT_DCL";
            }else if(lo_dat[i]["srcobjtyptxt"] == "<?= $vew_lang->zones; ?>"){
              lv_srcobjtyp = "SYS_ZON";
            }
          }
          if(lo_dat[i]["srcobjtxt"]!=undefined && lo_dat[i]["srcobjtyp"]!=""){
            lv_arr.push({	"hltmodplncod":(lo_dat[i]["hltmodplncod"] == undefined?"":lo_dat[i]["hltmodplncod"]),
                         	"srcobjcod001":lo_dat[i]["srcobjcod"],
                         	"srcobjtyp":lv_srcobjtyp,
                          "hltmodplnatr":lo_dat[i]["hltmodplnatr"]
                        });
          }
				}
        
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #hltmodpln").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #hltmodpln").prop("value", JSON.stringify( lv_arr ) );
				}
			}
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
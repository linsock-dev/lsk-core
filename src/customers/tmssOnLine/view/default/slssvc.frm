<?php
	// url del formulario 
  $lv_lnk = '?prg=slssvc&prm_slssvccod='.$vew_data->slssvccod.'&prm_mdlcod='.$vew_data->mdlcod.'&prm_prgcod='.$vew_data->prgcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('dstobjtyp','dstobjcod','dstobjtxt','slssvcdte', 'slssvcstrdte','slssvcenddte','curcod','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->slssvccod; 

	// titulo 
	$lv_title = $vew_lang->document;
	
	// modulo y programa 
	$lv_mdlcod = 'SLS';
	$lv_prgcod = 'SVC';

	// valores x default 
	if ( $vew_data->slssvccod=='' ) {
		$vew_data->slssvcdte = date('d/m/Y');
		$vew_data->docsts = 'A';
		$vew_data->curexcrte = 1;
	}

	$lv_objtyp = $vew_data->mdlcod.'_'.$vew_data->prgcod;
	$lv_objcod = $vew_data->slssvccod;
	$lv_dstobjtyp = strtoupper($vew_doc->getTagValue( $vew_data->sysdoccls->sysdocclsatr, 'dstobjtyp' ));
	$lv_slsprclstancvar=$vew_doc->getTagValue( $vew_data->slssvcatr, 'atr_ancvar' );
	
	// librer?a de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('sec','hidden',$lv_sec); ?>
		<?= gethtml('slssvctot','hidden',$vew_data->slssvctot); ?>
    <?= gethtml('slssvcmat','hidden',''); ?>
    <textarea class="hidden" id="slssvcatr" name="slssvcatr"></textarea>

    <div class="container-fluid" role="tabpanel"> 
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->slssvccod; ?><?= gethtml('slssvccod','hidden',$vew_data->slssvccod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
            
            <!-- Tarjeta contratos-->
						<div class="col-md-4">
              <div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $vew_lang->contracts; ?>
										<span class="tmss-card-icon">
                      <?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?>
                      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
										</span>
									</div>
								</div>
                
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    switch( $lv_dstobjtyp ) {
                      case 'SLS_CUS':
                        echo vew_boot($lv_colsm39, array('label'=>$vew_lang->customer, 
                                                        'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                            array('input'=>gethtml('dstobjtxt', 'typeahead', $vew_data->dstobjtxt, $lv_default) ))
                                                        ));
                        echo gethtml('dstobjtyp', 'hidden', $lv_dstobjtyp);
                  			echo gethtml('dstobjcod', 'hidden', $vew_data->dstobjcod);
                      break;
                    }
                    echo vew_boot($lv_colsm39, array("label"=>$vew_lang->description, "input"=>gethtml('slssvctxt', 'doccmt1x50', $vew_data->slssvctxt, $lv_default) ));
                    echo vew_boot($lv_colsm39, array('label'=>$vew_lang->status,	'input1'=>gethtml('docsts', 	 'docsts',	$vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div> <!-- card -->
            </div>	<!-- col-md-4 -->
             
           	<!-- Tarjeta ventas--> 
            <div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
              <div class="col-md-4">
                <div class="card">
                  <div class="card-header"><div class="card-title"><?= $vew_lang->sales; ?></div></div>
                  <div class="card-body tmss-card-body-edit">
                    <?php
                      echo vew_boot($lv_colxs48 , array('label'=>'Lista Precio',					
                                                      'input1'=>vew_boot( array('style'=>'search','readonly'=>$vew_readonly),
                                                                          array('input'=>gethtml('slsprclsttxt', 'typeahead', $vew_data->slsprclsttxt, $lv_default) ))
                                                       )); 
                      echo gethtml('slsprclstcod', 'hidden', $vew_data->slsprclstcod);
                      echo vew_boot($lv_colxs48, array('label'=>$vew_lang->exchangerate,	'input'=>gethtml('curexcrte', 'docnum0905', $vew_data->curexcrte, $lv_always_disabled) )); 
                      echo vew_boot($lv_colxs48, array('label'=>$vew_lang->variation,	'input'=>gethtml('slsprclstancvar', 'docqty', $lv_slsprclstancvar, $lv_default) )); 
                    ?>
                  </div>
                </div>
              </div>
            </div>   
            
            <!-- Tarjeta datos-->
						<div class="col-md-4">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->data; ?>
                    <span class="tmss-card-icon">
                    	<?= '<b><span id="slssvctotlbl">'.number_format(floatval($vew_data->slsordtotamt),2).'</span></b> '.strtolower($vew_data->curcod); ?>
                      <?= gethtml('curcod', 'hidden', $vew_data->curcod); ?>
                      <?= gethtml('slsordtot','hidden',$vew_data->slsordtot); ?>
                    </span>
                  </div>
                </div>             
                <div class="card-body tmss-card-body-edit"> 
                  <?php 								                    
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,   'input'=>gethtml('slssvccodext', 'doccmt1x50', $vew_data->slssvccodext, $lv_default) ));
                    echo vew_boot($lv_colsm210 , array('label'=>$vew_lang->date, 	'input'=>gethtml('slssvcdte',	'docdte',	$vew_data->slssvcdte,	$lv_default) ));
                    echo vew_boot($lv_col255, array('label'=>$vew_lang->period,
                                                     'input1'=>gethtml('slssvcstrdte',	'docdte',	$vew_data->slssvcstrdte,	$lv_default), 
                                                     'input2'=>gethtml('slssvcenddte',	'docdte',	$vew_data->slssvcenddte,	$lv_default) )); 
                  ?>
                </div>
              </div> <!-- card -->
      	    </div> <!-- col -->
      		</div> <!-- row -->
          
          <div class="card tmss-hot-ttl">
            <div class="card-header"><div class="card-title"><?= $vew_lang->material ?></div></div>
          </div>
          <div id="slssvcmathot" name="slssvcmathot"></div>
  
        </div> <!-- fin tab001 -->       
    	</div> <!-- tabcontent -->     
  	</div> <!-- container-fluid --> 
	</form>
	<script>
		// calcula totales de grilla
		function <?= $lv_sec; ?>_calcTotal() {
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
				var lst_slssvcmat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_slssvcmattot = 0;
				for(var i=0; i<lst_slssvcmat.length; i++){
					if(lst_slssvcmat[i].mattot!=undefined){
						lv_slssvcmattot+=Number(lst_slssvcmat[i].mattot);
					}
				}
				$("#<?= $lv_sec; ?> #slssvctotlbl").text( numbro(lv_slssvcmattot).format("0,0.00") );
				$("#<?= $lv_sec; ?> #slssvctot").prop("value",lv_slssvcmattot);
			}
		}
		
    //Queda pendiente definir el uso para esta seccion
		function <?= $lv_sec; ?>_refreshPrices() {
		}
	
		$("#<?= $lv_sec; ?> #slssvcdte").on("change",function(e){
			var lv_pstdat = [{name:"excrteclscodext", value:"vta"},
											 {name:"curcodsrc",value:$(this).prop("value")},
											 {name:"excrtedtefrm",value:$("#<?= $lv_sec; ?> #slssvcdte").prop("value")}
											];
			tmssCallProcess("?prg=finexcrte&act=19", lv_pstdat, function(data){
				$("#<?= $lv_sec; ?> #curexcrte").prop("value",(data.length>=1?(data[0]["finexcrte"]!=null?data[0]["finexcrte"]:""):""));
				<?= $lv_sec; ?>_refreshPrices();
			});
		});
		
		// curcod
		$("#<?= $lv_sec; ?> #curcod").on("change",function(e){
			var lv_pstdat = [{name:"excrteclscodext", value:"vta"},
											 {name:"curcodsrc",value:$(this).prop("value")},
											 {name:"excrtedtefrm",value:$("#<?= $lv_sec; ?> #slssvcdte").prop("value")}
											];
			tmssCallProcess("?prg=finexcrte&act=19", lv_pstdat, function(data){
				$("#<?= $lv_sec; ?> #curexcrte").prop("value",(data.length>=1?(data[0]["finexcrte"]!=null?data[0]["finexcrte"]:""):""));
			});
		}).next("span").children("a:first").on("click", function(e) { e.preventDefault();
			tmssPopup("<?= $vew_lang->currency; ?>","?prg=admcur&prm_vewcod=VEW_ADM_CUR_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[curcod:curcod]");
		});
				
  </script>
	<script>
		<?php if ($lv_dstobjtyp=='SLS_CUS'){ ?>
		// typeahead  -  dstobjtxt
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"c.docsts" : "A"},  "fldasg":{"dstobjtxt" : "custxt", "dstobjcod" : "cuscod", "slsprclsttxt":"slsprclsttxt", "curcod" : "curcod", "slsprclstcod" : "slsprclstcod" }};
    tmssTypeahead($("#<?= $lv_sec; ?> #dstobjtxt"), "slscus", lo_get); 
		<?php } ?>
		
    // typeahead  -  slsprclsttxt
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"p.docsts" : "A"}, "fldasg":{"slsprclstcod" : "slsprclstcod", "slsprclsttxt" : "slsprclsttxt", "curcod":"curcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #slsprclsttxt"), "slsprc", lo_get);    
	</script>
	<script>
		// MATERIALES
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
				var lv_ro_color = "#F1F1F1";
				var lv_color = "#FFFFFF";
				var lv_ro = <?=($vew_readonly?'true':'false'); ?>;
				if ( prop=="matqty" || prop=="matprc" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);			
					td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
					cellProperties.readOnly = (lv_ro?true:false);
				} else if ( prop=="slssvcstrdte" || prop=="slssvcenddte" ) {
					Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
					td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
					cellProperties.readOnly = (lv_ro?true:false);
				} else if ( prop=="mattot" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);			
					td.style.backgroundColor = lv_ro_color;
					cellProperties.readOnly = true;
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
					cellProperties.readOnly = (lv_ro?true:false);
				}
			}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #slssvcmathot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Material", "Descripcion", "Cantidad", "UM", "Importe", "Desde", "Hasta", "SubTotal", "" ],
			columns: [
				{type: "text", data: "matcod", width: 25, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
				{type: "autocomplete", data: "mattxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
            $.ajax({
              url: "index.php?prg=stkmat&act=17", dataType: "json", data: {	prm_mattxt: query },
              success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.mattxt);
                process(items);
              },
              error: function() {
                  <?= $lv_sec; ?>_autocompleteCache = [];
                  process([]);
              }
            });
					},
				strict: true
				},
				{type: "numeric", data: "matqty", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "matuntcod", width: 18, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
				{type: "numeric", data: "matprc", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "date", data: "slssvcstrdte", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, 
					dateFormat: 'DD/MM/YYYY',
					correctFormat: true,
					allowEmpty: false,
					datePickerConfig: {
						firstDay: 0,
						showWeekNumber: false,
						numberOfMonths: 1
					}
				},
				{type: "date", data: "slssvcenddte", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, 
					dateFormat: 'DD/MM/YYYY',
					correctFormat: true,
					allowEmpty: false,
					datePickerConfig: {
						firstDay: 0,
						showWeekNumber: false,
						numberOfMonths: 1
					}
				},
				{type: "numeric", data: "mattot", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true, numericFormat: {pattern: "0,0.00", culture: "es-AR"} }
			],
			afterChange: function(changes, source) {
        if (changes && changes.length > 0) {
          const row = changes[0][0];
          const valueSelected = changes[0][3] || "";
					if(changes[0][1]=="mattxt") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matcod", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.mattxt === valueSelected); 
              if(selectedItem) {
                <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matcod", selectedItem.matcod);
                <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matuntcod", selectedItem.matuntcod);
                  // si existe lista de precio asignada // y no hay precio indicado para el material, obtengo el precio
                if ( $("#<?= $lv_sec; ?> #slsprclstcod").prop("value")!="" ){ 
                  var lv_pstdat =[{name:"slsprclstcod",value: $("#<?= $lv_sec; ?> #slsprclstcod").prop("value")}, 
                                  {name:"slsprclstdte",value: $("#<?= $lv_sec; ?> #slssvcdte").prop("value")}, 
                                  {name:"slsprcsrctyp",value: "STK_MAT"},
                                  {name:"slsprcsrccod",value: selectedItem.matcod},
                                  {name:"currow",value: row}
                                  ]
                  tmssCallProcessNoBackdrop("?prg=slsprclst&act=17", lv_pstdat, function(data){
                    if(data.length>0){
                      <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matprc",data[0]["slsprc"]);
                    }
                  });
                }
              } else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          } else if(changes[0][1] == "matqty" || changes[0][1] == "matprc") {
            if(<?= $lv_sec; ?>_hot_autocomplete!=true) {
              if (<?= $lv_sec; ?>_hotdoc!=undefined) {
                var lv_qty = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row, "matqty");
								var lv_prc = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row, "matprc");
								var lv_tot = (lv_qty==null?0:lv_qty)*(lv_prc==null?0:lv_prc);
								<?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "mattot", lv_tot );
              }
            }
          } else if(changes[0][1] == "mattot") {
          	<?= $lv_sec; ?>_calcTotal();
          }
        }
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["slssvcmatcod"]!="" && lv_dat[i]["slssvcmatcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
					var lv_found=0;
					var lv_newinx;
					for( var x=<?= $lv_sec; ?>_hotdocerr.length-1; x>=0; x-- ) {
						if( <?= $lv_sec; ?>_hotdocerr[x].endsWith("_"+i.toString()) ){
							<?= $lv_sec; ?>_hotdocerr.splice(x,1);
							lv_found=1;
						} else if(lv_found==0) { 
							lv_newinx = <?= $lv_sec; ?>_hotdocerr[x].split("_");
							lv_newinx[1] = Number(lv_newinx[1])-1;
							<?= $lv_sec; ?>_hotdocerr[x] = lv_newinx[0]+"_"+lv_newinx[1].toString();
						}
					}
				}
			},
			afterRemoveRow: function(index, amount){
				if (<?= $lv_sec; ?>_hotdoc!=undefined) {
					<?= $lv_sec; ?>_calcTotal();
        }
			},
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotdoc;	
		
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->slssvcmat as $lv_row){ 
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'slssvcmatcod:"'.$lv_row['slssvcmatcod'].'",'.
												'matcod:"'.$lv_row['matcod'].'",'.
												'mattxt:"'.$lv_row['mattxt'].'",'.
												'matqty: '.$lv_row['matqty'].' ,'.
												'matuntcod:"'.$lv_row['matuntcod'].'",'.
												'matprc: '.$lv_row['matprc'].' ,'.
												'slssvcstrdte: "'.$lv_row['slssvcstrdtecnv'].'" ,'.
												'slssvcenddte: "'.$lv_row['slssvcenddtecnv'].'" ,'.
												'mattot: '.($lv_row['matqty']*$lv_row['matprc']).
												'}'; 
												}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
			<?= $lv_sec; ?>_calcTotal();
		});
	</script>
  <script>
		// server response
    function <?= $lv_sec; ?>_fncbckext( data ) {
			try {
				//var lv_xml = $.parseXML( "< ? xml version='1.0' encoding='utf-8'? ><xmldata>" + data + "</xmldata>" );
				var lv_errcod = data.errcod; //$(lv_xml).find("errcod").eq(0).text();
				var lv_errrow = data.errrow; //$(lv_xml).find("row").eq(0).text();
				if ( lv_errcod!="0" && lv_errrow!="" ) {
					<?= $lv_sec; ?>_hotdoc.setCellMeta( Number(lv_errrow), 2, "valid", false);
				}
				<?= $lv_sec; ?>_hotdoc.render();
			} catch (e) {}
      if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
        if (gv_<?= $lv_sec; ?>_last_action=="04") {
          tmssTabSecCls( $("#<?= $lv_sec; ?>") );
        } else {
          $("#<?= $lv_sec; ?>").replaceWith( data );
        }
      }
    }
		
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if ( lp_prm["action"]=="01" ) {
				tmssLink("?prg=slssvc&act=01&prm_mdlcod=<?= $vew_data->mdlcod; ?>&prm_prgcod=<?= $vew_data->prgcod; ?>", [{target: "_replace_with", target_id: "#<?= $lv_sec; ?>"}]);
				return false;
			}
			
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
        lv_dat = "<atr_ancvar>"+$("#<?=$lv_sec;?> #slsprclstancvar").val()+"</atr_ancvar>";
				$("#<?= $lv_sec; ?> #slssvcatr").prop("value", lv_dat );
        
				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["matcod"]!="" && lo_dat[i]["matcod"]!=undefined ) {
						lv_arr.push({	"slssvcmatcod":lo_dat[i]["slssvcmatcod"],
													"matcod":lo_dat[i]["matcod"],
													"mattxt":lo_dat[i]["mattxt"],
													"matqty":lo_dat[i]["matqty"],
													"matuntcod":lo_dat[i]["matuntcod"],
													"matprc":lo_dat[i]["matprc"],
													"curcod":lo_dat[i]["curcod"],
													"slssvcstrdte":lo_dat[i]["slssvcstrdte"],
													"slssvcenddte":lo_dat[i]["slssvcenddte"],
													"mattot":lo_dat[i]["mattot"]
												});
					}
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({ "slssvccod": $("#<?= $lv_sec; ?> #slssvccod").prop("value"),
												"slssvcmatcod": <?= $lv_sec; ?>_hotdocdel[i]["slssvcmatcod"],
												"matqty":<?= $lv_sec; ?>_hotdocdel[i]["matqty"],
												"matuntcod":<?= $lv_sec; ?>_hotdocdel[i]["matuntcod"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #slssvcmat").prop("value", "");						
				} else {
					$("#<?= $lv_sec; ?> #slssvcmat").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}	
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
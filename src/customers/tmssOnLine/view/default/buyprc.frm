<?php 
	// url del formulario
  $lv_lnk = '?prg=buyprc&prm_buyprccod='.$vew_data->buyprccod;

	// campos requeridos
	$vew_input->RequiredFields( array('supcod','suptxt','buyprcstrdte','buyprcenddte','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->buyprccod;

	// titulo
	$lv_title = $vew_lang->general;

	// modulo y programa
	$lv_mdlcod = 'BUY';
	$lv_prgcod = 'PRC';

	// librer?a de estilos bootstrap
	include_once('_library.frm');
	
	// id de clase de documento para carga de material
	$lv_sysdocclscodmat = $vew_doc->gettagvalue($vew_data->sysdoccls->sysdocclsatr,'sysdocclscodmat');
	if( !$vew_sec->hasPermission('STK','MAT','01') ){ $lv_sysdocclscodmat = ''; }	
	
	// oculto botones modificar y borrar
	$vew_tbl = array();
	$vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['modR'] = array('per'=>false);
	$vew_tbl['cpy'] = array('per'=>false);
	//$vew_tbl['del'] = array('per'=>false);
	//$vew_tbl['delsep'] = array('per'=>false);
	$vew_tbl['sveL'] = array('ttl'=>$vew_lang->process,'icn'=>'fas fa-cogs');
	$vew_tbl['sveR'] = array('ttl'=>$vew_lang->process,'icn'=>'fas fa-cogs');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml( 'tmss_actcod' , 'hidden', '' ); ?>
    <input type="file" id="uplfle" class="hidden" charset="utf-8">
    <textarea class="hidden" id="buyprcmat" name="buyprcmat"></textarea>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->buyprccod; ?><?= gethtml( 'buyprccod' , 'hidden', $vew_data->buyprccod ); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
							<div class="card">
								<div class="card-header">
									<div class="card-title"><?= $vew_lang->general; ?>
										<div class="tmss-card-icon">
                      <?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?>
											<?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
										</div>
									</div>
								</div>
								<div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col210, array('label'=>$vew_lang->supplier,
																										'input'=>vew_boot(
																											array('style'=>'search', 'readonly'=>$vew_readonly ),
																											array('input'=>gethtml('suptxt', 'typeahead',$vew_data->suptxt,$lv_default))
																										))
																	);
                    echo gethtml('supcod','hidden',$vew_data->supcod);
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('buyprctxt', 'doccmt1x50', $vew_data->buyprctxt, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', 		($vew_data->docsts=='C'?'docstsacc':'docsts'),	$vew_data->docsts, ($vew_data->docsts=='C'?$lv_always_disabled:$lv_default) ) ));
									?>
								</div>
							</div>
						</div>
            
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->parameters; ?>
									<span class="tmss-card-icon">
										<?= (!$vew_readonly ? '<a href="#" id="btncurchg" class="cursor:pointer">'.strtoupper($vew_data->curcod).'</a>' : strtoupper($vew_data->curcod) ); ?>
										<?= gethtml('curcod', 'hidden', $vew_data->curcod); ?>
										<?= gethtml('curexcrte','hidden',''); ?>
									</span>
								</div></div>
								<div class="card-body tmss-card-body-edit">
									<?php
                    echo vew_boot($lv_col255, array('label'=>$vew_lang->period, 'input'=>gethtml('buyprcstrdte',	'docdte',	$vew_data->buyprcstrdte,	$lv_default), 'input2'=>gethtml('buyprcenddte',	'docdte',	$vew_data->buyprcenddte,	$lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->decimal,'input'=>gethtml('buyprcatrfledec', array(''=>'Sin Decimal','.'=>'Punto',','=>'Coma'), $vew_doc->getTagValue($vew_data->buyprcatr,'fledec'), ( $vew_readonly ? $lv_always_disabled : $lv_default) )));
										echo vew_boot($lv_col210, array('label'=>'Crear Materiales','input'=>gethtml('buyprcatrnewmat', 'checkbox', $vew_doc->getTagValue($vew_data->buyprcatr,'newmat'), ( $vew_readonly || $lv_sysdocclscodmat=='' ? $lv_always_disabled : $lv_default ) )));
                  	echo vew_boot($lv_col210, array('label'=>'Actualiza Costos','input'=>gethtml('buyprcatrupdcst', 'checkbox', $vew_doc->getTagValue($vew_data->buyprcatr,'updcst'), ( $vew_readonly ? $lv_always_disabled : $lv_default) )));
                  ?>
								</div>
							</div>
            </div>
					</div>

					<!-- PRECIOS -->
					<div class="card tmss-hot-ttl">
						<div class="card-header">
							<div class="card-title"><?= $vew_lang->prices; ?>
								<?php if(!$vew_readonly) { ?><a class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" id="btnupl" title="<?= $vew_lang->upload; ?>"><i class="fas fa-upload"></i></a><?php } ?>
							</div>
						</div>
					</div>
					<div id="buyprcmathot" name="buyprcmathot"></div>

				</div> <!-- /tab001 -->
				
			</div> <!-- /tab-content -->
		</div> <!-- /container-fluid -->
  </form>
	<script>
		// proveedor
		var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"supcod" : "supcod", "suptxt" : "suptxt"}}; 
		tmssTypeahead($("#<?= $lv_sec; ?> #suptxt"), "buysup", lo_get);

    // moneda
    $("#<?= $lv_sec; ?> #btncurchg").on("click", function(e) { e.preventDefault();
      tmssPopup("Monedas","?prg=admcur&prm_vewcod=VEW_ADM_CUR_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[curcod:curcod]&prm_fldflt=[c.docsts:a]",function(){
        //si la moneda es diferente muestra el tipo de cambio
        var lv_pstdat = [{name:"curcodsrc",value:$("#<?= $lv_sec; ?> #curcod").prop("value")}, // Pesos
                         {name:"excrtedtefrm",value:$("#<?= $lv_sec; ?> #buyorddte").prop("value")}, // Fecha
                         {name:"excrteclscodext", value: "CPA" } // Codigo externo de la clase (CPA)
                        ]; 
        // Se guarda el valor de la moneda
        $("#<?= $lv_sec; ?> #btncurchg").text(lv_pstdat[0]["value"]);
				/*
        //obtiene el tipo de cambio segun la moneda y la fecha de cabecera
        tmssCallProcess("?prg=finexcrte&act=19", lv_pstdat, function(data){
          var lv_curexcrte= (data.length>=1?(data[0]["finexcrte"]!=null?data[0]["finexcrte"]:""):"");
          $("#<?= $lv_sec; ?> #curexcrte").prop("value",lv_curexcrte);
          if(data[0]["finexcrte"]==null){
            toastr.warning("No se puede determinar el tipo de cambio a " + lv_pstdat[0]["value"]);
          }
        });
				*/
      });
    });
	</script>
	<script>
		tmssLoadScript("sheetjs",function(){
			// ARCHIVO. boton cargar archivo
			$("#<?= $lv_sec; ?> #btnupl").on("click",function(e){e.preventDefault();
				
				// valido que se haya ingresado un proveedor (la busqueda de codigos existentes se hace previamente por proveedor)
				if($("#<?= $lv_sec; ?> #supcod").val()==""){
					toastr.warning("Debe indicar un Proveedor.");
					$("#<?= $lv_sec; ?> #suptxt").focus();
					return;
				}
				
				$("#<?= $lv_sec; ?> #uplfle").trigger("click");
			});
			
			
			// PROCESO. se procesa el archivo cargado
			$("#<?= $lv_sec; ?> #uplfle").on("change",function(e){
				var lv_flenme = $(this).prop("files")[0].name;
				var lv_fletyp = $(this).prop("files")[0].type;
				var lv_flesze = $(this).prop("files")[0].size;
				
				<?= $lv_sec; ?>_hotdoc.loadData([]);

				var lo_reader = new FileReader();
				lo_reader.readAsArrayBuffer( e.target.files[0] );
				
				lo_reader.onload = function (evt) {
					//var lo_dat = new Uint8Array( lo_reader.result );
          var lo_dat = lo_reader.result;
          //console.log(cptable);
					var lo_wb = XLSX.read(lo_dat, {type: 'array'});
					var lo_ws = lo_wb.Sheets[lo_wb.SheetNames[0]];
          //console.log(lo_ws);
					var lo_arr = XLSX.utils.sheet_to_json(lo_ws, {header:1});
					var lv_hotarr = [];

					// BUSQUEDA. FALTA: armar string de busqueda para buscar todos los codigos de material en una sola llamada
					var lv_supmatcod="";
					for(var i=1; i<lo_arr.length; i++){
            if(lo_arr[i][0]!=undefined && lo_arr[i][0]!="" ) lv_supmatcod += (lv_supmatcod==""?"":";")+lo_arr[i][0];
					}
					
					var lv_pstdat=[{name:"supcod",value:$("#<?= $lv_sec; ?> #supcod").val()},{name:"supmatcod",value:lv_supmatcod}];
					tmssCallProcess("?prg=buyprc&act=17",lv_pstdat,function(data){
						for(var i=1; i<lo_arr.length; i++){
							var lv_matcod="", lv_mattxt="", lv_matuntcod="";
							
							// PRECIO. se normaliza el precio
							var lv_prc = lo_arr[i][2];
              lv_prc=lv_prc.toString().replace("$","").replace(" ","");
							if( $("#<?= $lv_sec; ?> #buyprcatrfledec").val()=="." ){
								lv_prc = lv_prc.replace(",","");	// simbolo decimal '.'
							} else if ( $("#<?= $lv_sec; ?> #buyprcatrfledec").val()=="," ) {
								lv_prc = lv_prc.replace(".","").replace(",",".");	// simbolo decimal ','
							}
							
							// CONVERSION. busca conversion de material existente
							for( var x=0; x<data.length; x++ ){
								if( lo_arr[i][0]==data[x].supmatcod ){
									lv_matcod = data[x].matcod;
									lv_mattxt = data[x].mattxt;
									lv_matuntcod = data[x].matuntcod;
									break;
								}
							}
							//console.log( cptable.utils.encode(28591,lo_arr[i][1]));
							lv_hotarr.push({supmatcod:lo_arr[i][0],				// cod proveedor
															supmattxt:lo_arr[i][1],				// descripcion proveedor
															supmatprc:parseFloat(lv_prc),	// precio
															supmatuntcod:lo_arr[i][3],		// uni med
                              matcod:lv_matcod,
															mattxt:lv_mattxt,
                              matuntcod:lv_matuntcod
														});
							
						}
						<?= $lv_sec; ?>_hotdoc.loadData( lv_hotarr );
						<?= $lv_sec; ?>_hotdoc.render();
					});
				};
			});
			
		});
	</script>
	<script>
  	// P R E C I O S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if( <?= $lv_sec; ?>_hotdoc != undefined ) {
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				if( prop=="matcod" ) { td.style.backgroundColor = "#F1F1F1"; }
				if ( prop=="supmatprc" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
				}
			}
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #buyprcmathot")[0];
    var <?= $lv_sec; ?>_hot_paste = false;
    var <?= $lv_sec; ?>_hot_paste_array = [];
		var <?= $lv_sec; ?>_hot_autocomplete = false;
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
      <?= ($vew_readonly? '':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->code; ?>", "<?= $vew_lang->description; ?>", "<?= $vew_lang->price; ?>","<?= $vew_lang->unit; ?>", "<?= $vew_lang->id; ?>","<?= $vew_lang->description; ?>","<?= $vew_lang->unit; ?>" ],
			columns: [
        {type: "text", data: "supmatcod", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly ?'readOnly: true, ':''); ?> allowEmpty: false },
				{type: "text", data: "supmattxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?',readOnly: true ':''); ?> },
				{type: "numeric", data: "supmatprc", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer , <?= ($vew_readonly?'readOnly: true, ':''); ?> numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "supmatuntcod", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?',readOnly: true ':''); ?> },
        {type: "text", data: "matcod", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true },
        {type: "autocomplete", data: "mattxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly ?'readOnly: true, ':''); ?>
					source (query, process) {
            $.ajax({
              url: "?prg=stkmat&act=17", dataType: "json", data: {	prm_mattxt: query }, minLength: 2,
              success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.mattxt);
                process(items);
              },
              error: function () {
                <?= $lv_sec; ?>_autocompleteCache = [];
                process([]);
              }
            });
					},
					strict: true
				},
        {type: "text", data: "matuntcod", width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly ?',readOnly: true ':''); ?> }
			],
      afterChange: function(changes, source) {
        if (changes && changes.length > 0 && source === 'edit') {
          const row = changes[0][0];
          const valueSelected = changes[0][3] || "";
          if( changes[0][1]=="mattxt"){
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matcod", "", 'autocomplete');
            	<?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matuntcod", "", 'autocomplete');
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.mattxt === valueSelected);
              if (selectedItem) { 
                <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matcod", selectedItem.matcod, 'autocomplete');
                <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matuntcod", selectedItem.matuntcod, 'autocomplete');
              } else { toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia."); }
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
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotdoc;

		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php 
				$lv_buffer='';
				foreach($vew_data->buyprcmat as $lv_row){
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'supmatcod:\''.$lv_row['supmatcod'].'\','.
												'supmattxt:\''.$lv_row['supmattxt'].'\','.
            						'supmatprc:\''.(float)$lv_row['supmatprc'].'\','.
            						'supmatuntcod:\''.$lv_row['supmatuntcod'].'\','.
            						'matcod:\''.$lv_row['matcod'].'\','.
												'mattxt:\''.$lv_row['mattxt'].'\','.
            						'matuntcod:\''.$lv_row['matuntcod'].'\'}';
				} 
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
  <script>
  	var gv_<?= $lv_sec; ?>_last_action="";
    // server response ext
    function <?= $lv_sec; ?>_fncbckext(data) {
      if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="09") {
					toastr.info("Documento contabilizado.");
					<?= $lv_sec; ?>_fnc({action: "99"});
				} else if (gv_<?= $lv_sec; ?>_last_action=="29") {
					toastr.info("Documento Anulado.");
					<?= $lv_sec; ?>_fnc({action: "99"});
				} else if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    }
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {

				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();

				// solo se aceptan registros que tengan los datos de proveedor indicados
				// si NO se indico crear material todos los registros deben tener conversion
				for(var i=0; i<lo_dat.length-1; i++){
					<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 0, "valid", ((typeof lo_dat[i]["supmatcod"]!="undefined"?lo_dat[i]["supmatcod"]:"")!="") );
					<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 1, "valid", ((typeof lo_dat[i]["supmattxt"]!="undefined"?lo_dat[i]["supmattxt"]:"")!="") );
          <?= $lv_sec; ?>_hotdoc.setCellMeta(i, 1, "valid", ((typeof lo_dat[i]["supmattxt"]!="undefined" && lo_dat[i]["supmattxt"].length <51?lo_dat[i]["supmattxt"]:"")!="") );
					<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 2, "valid", ((typeof lo_dat[i]["supmatprc"]!="undefined"?lo_dat[i]["supmatprc"]:"")!="") );
					<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 3, "valid", ((typeof lo_dat[i]["supmatuntcod"]!="undefined"?lo_dat[i]["supmatuntcod"]:"")!="") );
					if( $("#<?= $lv_sec; ?> #buyprcatrnewmat").val()=="0" ){
						<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 4, "valid", ((typeof lo_dat[i]["matcod"]!="undefined"?lo_dat[i]["matcod"]:"")!="") );
						<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 5, "valid", ((typeof lo_dat[i]["mattxt"]!="undefined"?lo_dat[i]["mattxt"]:"")!="") );
						<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 6, "valid", ((typeof lo_dat[i]["matuntcod"]!="undefined"?lo_dat[i]["matuntcod"]:"")!="") );
					} else {
						<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 4, "valid", true );
						<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 5, "valid", true );
						<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 6, "valid", true );
					}
				}
				
				var lv_errcnt = 0;
				var lo_err = <?= $lv_sec; ?>_hotdoc.getCellsMeta();
				for(var x=0; x<lo_err.length; x++){ lv_errcnt += (lo_err[x].valid==false?1:0); }
				if(lv_errcnt>=1){
					toastr.warning("Verifique los datos faltantes o invalidos, y recordar que la longitud de la descripcion tiene que ser menor a 50 caracteres.");
					<?= $lv_sec; ?>_hotdoc.render();
					return false;
				}

				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length-1; i++) {
						lv_arr.push({	"supmatcod":lo_dat[i]["supmatcod"],
													"supmattxt":lo_dat[i]["supmattxt"],
                          "supmatprc":lo_dat[i]["supmatprc"],
                          "supmatuntcod":lo_dat[i]["supmatuntcod"],
													"matcod":lo_dat[i]["matcod"],
													"mattxt":lo_dat[i]["mattxt"],
													"matuntcod":lo_dat[i]["matuntcod"]
												});
					}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #buyprcmat").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #buyprcmat").prop("value", JSON.stringify( lv_arr ) );
				}
      }
		}
	</script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
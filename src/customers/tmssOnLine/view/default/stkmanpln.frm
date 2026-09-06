<?php
	// url del formulario
  $lv_lnk = '?prg=stkmanpln&prm_stkmanplncod='.$vew_data->stkmanplncod;
	
	// campos requeridos
	$vew_input->RequiredFields(array('stkmanplntxt', 'docsts'));

	// clave del documento
	$lv_dockey = $vew_data->stkmanplncod;

	// titulo
	$lv_title = $vew_lang->request;

	// modulo y programa
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'MPL';
	
  // librería de estilos
  include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
     <?= gethtml('tmss_actcod', 'hidden', ''); ?>

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->stkmanplncod; ?><?= gethtml('stkmanplncod','hidden',$vew_data->stkmanplncod); ?></strong></h4></li>
      </ul>
			<div class="tab-content tmss-tab-content">

				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                 <div class="card-title"><?= $vew_lang->plan; ?> 
									 <span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
										<?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
               		</div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 				'input'=>gethtml('stkmanplncodext', 'doccmt1x20', $vew_data->stkmanplncodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 	'input'=>gethtml('stkmanplntxt', 'doccmt1x50', $vew_data->stkmanplntxt, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div> <!-- /card -->
						</div> <!-- /col -->
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->frequency; ?></div></div>
								<div class="card-body tmss-card-body-edit">
									<div class="form-group tmss-form-group">
										<label class="col-md-2 control-label text-nowrap"><?= $vew_lang->frequency; ?></label>
										<a href="#" id="sysintfrqlnk" class="col-sm-10 control-label"> --Frecuencia-- </a>
										<?= gethtml('sysintfrq', 'hidden', $vew_data->sysintfrq); ?>
									</div>
								</div>
							</div>						
						</div> <!-- /col -->
					</div> <!-- /row -->

          <div class="col-md-12">
            <div class="row">         
              <div class="card tmss-hot-ttl">
                <div class="card-header"><div class="card-title"><?= $vew_lang->materials; ?></div></div>
              </div>      
							<div id="stkmanplnmathot" name="stkmanplnmathot"></div>
            </div> <!-- /row -->
          </div> <!-- /col -->
					
				</div> <!-- /tab001 -->
			</div> <!--/tab-content -->
		</div> <!-- /container-fluid -->
  </form>
	<script>
    // BUSCAR NRO DE SERIE
		function <?= $lv_sec; ?>_findSerial( lv_row ) {
			var lv_matcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row,"matcod");
			if ( lv_matcod=="" || lv_matcod==undefined ) {
				toastr.warning("Debe seleccionar un material.");
			} else {
				$("#<?= $lv_sec; ?> #tmpmatsercod, #<?= $lv_sec; ?> #tmpmatsercodext").data("row",lv_row);
        var lv_objcod = ($("#<?= $lv_sec; ?> #srcobjcod").val() == "" || $("#<?= $lv_sec; ?> #srcobjcod").val() == "0" ? $("#<?= $lv_sec; ?> #dstobjcod").val() : $("#<?= $lv_sec; ?> #srcobjcod").val())
        tmssPopup("Buscar numero de serie","?prg=stkmatser&prm_vewcod=VEW_STK_MAT_SER_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[tmpmatsercod:matsercod],[tmpmatsercodext:matsercodext]&prm_fldflt=[s.matcod:"+lv_matcod+"],[s.docsts:A],[stkobjcod:"+lv_objcod+"]");
			}
		}

		$("#<?= $lv_sec; ?> #tmpmatsercod, #<?= $lv_sec; ?> #tmpmatsercodext").on("change",function(e) { 
			<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( $(this).data("row"), $(this).data("fldnme"), $(this).prop("value") );
		});
		
    $(function(){
      <?= $lv_sec; ?>_updateFrequencyName();
    });
    
    // MODIFICAR HORARIO
    $("#<?= $lv_sec; ?> #sysintfrqlnk").on("click",function(e){ e.preventDefault();
      var lv_cfg = {};
      lv_cfg["frq"] = ["D", "W", "M"];
			lv_cfg["strdte"] = $("#<?= $lv_sec; ?> #plndte").val();
			lv_cfg["enddte"] = $("#<?= $lv_sec; ?> #plndteto").val();
			lv_cfg["tmetyp"] = "S";
      lv_cfg["readonly"] = "<?= $vew_readonly; ?>";
      
      var lv_pstdat = [{name:"cfg", value: JSON.stringify(lv_cfg)}, {name:"prvdat", value:$("#<?= $lv_sec; ?> #sysintfrq").val()}];
			tmssCallProcess("?prg=grldattsk&act=sch",lv_pstdat,function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->frequency; ?>",
					message: $(data),
					type: BootstrapDialog.TYPE_PRIMARY,
          closable: true,
          draggable: true,
         	buttons: [{ label: "<?= ($vew_readonly?$vew_lang->close:$vew_lang->cancel); ?>", cssClass: "<?= ($vew_readonly?'btn-default':'btn-danger'); ?>", action: function(dialog){ dialog.close(); } },
                    {	label: "<?= $vew_lang->select ?>", cssClass: "btn-info <?= ($vew_readonly?'hidden':''); ?>",	action: function(dialog){
                      // recuperar selección
											dialog.$modalBody.find("#serialize").trigger("click");
											$("#<?= $lv_sec; ?> #sysintfrq").val( dialog.$modalBody.find("#grldattskatr").val() );											
                      <?= $lv_sec; ?>_updateFrequencyName();
                      dialog.close();
											}
										}]
				});
			});
    });
    // obtiene el texto descriptipo de la frecuencia
    function <?= $lv_sec; ?>_updateFrequencyName(){
			tmssCallProcess("?prg=grldattsk&act=getfrqtxt", [{name:"frq", value:$("#<?= $lv_sec; ?> #sysintfrq").val()}], function(data){ 
				$("#<?= $lv_sec; ?> #sysintfrqlnk").text(data.frqtxt);
			});
    }		
	</script>  
  <script>
		/**
		 *
		 *	M A T E R I A L E S
		 *
		 */
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
				var lv_ro_color = "#F1F1F1";
				var lv_color = "#FFFFFF";
				var lv_ro = <?=($vew_readonly?'true':'false'); ?>;
      	var lv_matuseser = (<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"matuseser")=="1"?true:false);
				if (prop=="matsercodext") {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro || !lv_matuseser ? lv_ro_color: lv_color);
					cellProperties.readOnly =  (lv_ro || !lv_matuseser ? true:false);
				}else if ( prop=="icn3") { 
					if( lv_matuseser ){
						var lv_btn = "<a href='#' onclick='<?= $lv_sec; ?>_findSerial("+row+");' class='btn btn-default btn-sm'><span class='fas fa-search'></span></a>";
						$(td).empty().append(lv_btn);
						$(td).addClass("text-center");
					}
					td.style.backgroundColor = lv_ro_color;
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro ? lv_ro_color:lv_color);
					cellProperties.readOnly = (lv_ro  ? true:false);
				}
			}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #stkmanplnmathot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly ?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->code; ?>", "<?= $vew_lang->material; ?>", "<?= $vew_lang->serialnumber; ?>"<?= (!$vew_readonly ? ',""':'') ?> ],
			columns: [
				{type: "text", data: "matcod", width: 25, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
				{type: "autocomplete", data: "mattxt", width: 80, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
       				var lv_objcod = ($("#<?= $lv_sec; ?> #srcobjcod").val() == "" || $("#<?= $lv_sec; ?> #srcobjcod").val() == "0" ? $("#<?= $lv_sec; ?> #dstobjcod").val() : $("#<?= $lv_sec; ?> #srcobjcod").val())
            if ( query.length>1 && <?= $lv_sec; ?>_hot_paste!=true ) {
							$.ajax({
								url: "?prg=stkmat&act=17", dataType: "json", data: { prm_mattxt: query },
								complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/ *script* /"){ eval(jqXHR.responseText); }},
								success: function (response) {
									var lv_dat = [];
									<?= $lv_sec; ?>_hotdocchg = [];
									for (var i=0; i < response.data.length; i++) {
										<?= $lv_sec; ?>_hotdocchg.push( {mattxt: response.data[i]["mattxt"], 
                                                     matcod: response.data[i]["matcod"], 
                                                     matuseser: response.data[i]["matuseser"]} );
										lv_dat.push( response.data[i]["mattxt"] );
									}
									process( lv_dat );
								}
							});
						} else {
							<?= $lv_sec; ?>_hot_paste = false;
						}
					},
					strict: true
				},        
      	{type: "text", data: "matsercodext", width: 25, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true }
       	<?= (!$vew_readonly ? ',{type: "text", data: "icn3", width: 8, renderer: '.$lv_sec.'_hotdoc_renderer, editor: false, readOnly: true }':''); ?>
			],
			beforeChange : function(changes, source) {
				if(source=="edit" && changes[0][1]=="mattxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].mattxt == lv_value) {
							changes.push([ changes[0][0], "matcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].matcod) ]);
              changes.push([ changes[0][0], "matuseser", "", String(<?= $lv_sec; ?>_hotdocchg[i].matuseser) ]);
						}
					}
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["stkmanplnmatcod"]!="" && lv_dat[i]["stkmanplnmatcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			},
		};
		var <?= $lv_sec; ?>_hotdoc;

		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
				$lv_buffer='';
        if ( is_array($vew_data->stkmanplnmat) ) {
				foreach($vew_data->stkmanplnmat as $lv_row){
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
													'stkmanplnmatcod:"'.$lv_row['stkmanplnmatcod'].'",'.
													'matcod:"'.$lv_row['matcod'].'",'.
													'mattxt:`'.$lv_row['mattxt'].'`,'.
													'matsercod:`'.$lv_row['matsercod'].'`,'.
													'matsercodext:`'.$lv_row['matsercodext'].'`,'.
												'}';
					}
        }
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>  
  <script>
		// SUBMIT. prepara los datos antes de grabar
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if ( lp_prm["action"]=="00" ) {
				// obtengo datos de handsontable
        var err = 0;
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
				var lv_arr_error = new Array();

				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["mattxt"]!="" && lo_dat[i]["mattxt"]!=undefined ) {
            	if (lo_dat[i]["matuseser"]=="1" && lo_dat[i]["matsercod"]==undefined ) {	
								lv_arr_error.push(i);
								//pintar las celdas de color rojo que esten dentro del array
								<?= $lv_sec; ?>_hotdoc.setCellMeta(i, <?= $lv_sec; ?>_hotdoc.propToCol("matsercodext"), "valid", false);
							}else{
            		lv_arr.push({	"stkmanplnmatcod":lo_dat[i]["stkmanplnmatcod"],
															"matcod":lo_dat[i]["matcod"],
															"mattxt":lo_dat[i]["mattxt"],
															"matsercod":lo_dat[i]["matsercod"]
														});
          	}
          }
				}
         // verifico error
        if(lv_arr_error.length > 0){
          <?= $lv_sec; ?>_hotdoc.render();
          // mensaje
          toastr.warning("Falta agregar numero de seriado o el material pertenece a otra Ubicacion");
          return false;
        }
          
				// agrego las filas eliminadas
				for (var i=0; i < <?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"stkmanplnmatcod":<?= $lv_sec; ?>_hotdocdel[i]["stkmanplnmatcod"],
												"deleted":"X"
											});
				}
          
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #stkmanplnmat").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #stkmanplnmat").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
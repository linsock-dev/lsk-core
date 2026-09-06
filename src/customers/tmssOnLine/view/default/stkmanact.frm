<?php
	// url del formulario
  $lv_lnk = '?prg=stkmanact&stkmanactcod='.$vew_data->stkmanactcod;
	
	// campos requeridos
	$lv_reqfld = array('docsts', 'dstobjtxt');
	$vew_input->RequiredFields($lv_reqfld);
  
	// clave del documento
	$lv_dockey = $vew_data->stkmanactcod;

	// titulo
	$lv_title = $vew_lang->activity;

	// modulo y programa
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'MCA';
	$lv_objtyp = 'STK'.'_'.'MCA';
	
	// valores x default
	if ( $vew_data->stkmanactcod=='' ) {
		$vew_data->stkmanactdte = date('d/m/Y');
		$vew_data->docsts = 'A';
	}

	$lv_rejarr = array(''=>'');
	foreach($vew_data->sysdoccls->sysdocclsrej as $lv_row) {
    $lv_rejarr[ $lv_row['sysdocrejcod'] ] = $lv_row['sysdocrejtxt'];
	}

	// Botones por vista
  $vew_tbl['btnaccdelL'] = array ('id'=>'btnaccdelL', 'pos'=>'L', 'per'=>$vew_data->docsts=='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'29'), 'acc'=>'', 'ttl'=>$vew_lang->cancel, 'icn'=>'far fa-file-circle-xmark', 'css'=>'btn btn-danger navbar-btn tmss-navbar-btn tmss-desk-btn tmssAlwaysEnabled tmssHiddeOnEdit');
  $vew_tbl['btnaccdelR'] = array ('id'=>'btnaccdelR', 'pos'=>'R', 'per'=>$vew_data->docsts=='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'29'), 'acc'=>'', 'ttl'=>$vew_lang->cancel, 'icn'=>'far fa-file-circle-xmark', 'css'=>'btn btn-danger navbar-btn tmss-navbar-btn tmss-mob-btn tmssAlwaysEnabled tmssHiddeOnEdit');
  $vew_tbl['accL'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09') && $vew_data->sysdoctrecod!='C', 'acc'=>'');
	$vew_tbl['accR'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09') && $vew_data->sysdoctrecod!='C', 'acc'=>'');
	$vew_tbl['modL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl['modR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	
  // librería de estilos
  include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod', 'hidden', ''); ?>
		<?= gethtml('stkmovdoccod', 'hidden', $vew_data->stkmovdoccod); ?>
		<textarea class="hidden" id="stkmanactmat" name="stkmanactmat"></textarea>
		<textarea class="hidden" id="stkmaninv" name="stkmaninv"></textarea>
		<textarea class="hidden" id="stkmovdocmat" name="stkmovdocmat"></textarea>
		<input type="hidden" id="tmpmatsercod" name="tmpmatsercod" data-fldnme="matsercod" value="">
		<input type="hidden" id="tmpmatsercodext" name="tmpmatsercodext" data-fldnme="matsercodext" value="">
		<input type="hidden" id="tmpmatbchcod" name="tmpmatbchcod" data-fldnme="matbchcod" value="">
		<input type="hidden" id="tmpmatbchcodext" name="tmpmatbchcodext" data-fldnme="matbchcodext" value="">
      
		<div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?=$vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->stkmanactcod; ?><?= gethtml('stkmanactcod', 'hidden', $vew_data->stkmanactcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
			
				<!-- GENERAL --> 
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
						
							<div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $vew_lang->activities; ?>
										<span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
										<?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
									</div>
								</div>
								<div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col210, array('label' => $vew_lang->date, 'input' => gethtml('stkmanactdte', 'docdte', $vew_data->stkmanactdte, $lv_default)));
                  	echo vew_boot($lv_col210, array('label' => $vew_lang->description, 'input' => gethtml('stkmanacttxt', 'doccmt1x50', $vew_data->stkmanacttxt, $lv_default)));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>  gethtml('docsts', ($vew_data->docsts=='C'?'docstsacc':'docsts'),	$vew_data->docsts, ($vew_data->docsts=='C'?$lv_always_disabled:$lv_default) ) ));
									?>
								</div>
							</div> <!-- /card -->
							
						</div> <!-- /col -->
						<div class="col-md-6">
						
							<div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $vew_lang->details; ?>
										<?php if($vew_data->sysdoctrecod=='N'){ ?><span><span class="far fa-circle"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
										<?php if($vew_data->sysdoctrecod=='P'){ ?><span class="text-warning"><span class="far fa-circle-half-stroke"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
										<?php if($vew_data->sysdoctrecod=='C'){ ?><span class="text-success"><span class="fas fa-circle"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
										<?php if($vew_data->sysdoctrecod==''){ echo '&nbsp;'; } ?>
									</div>
								</div>
								<div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col210, array('label'=>$vew_lang->comments,	'input'=>gethtml('stkmanactcmt','doccmt1x50',$vew_data->stkmanactcmt,$lv_default) ));
									?>
								</div>
							</div> <!-- /card -->
							
						</div> <!-- /col -->
					</div> <!-- /row -->
					
					<div class="card tmss-hot-ttl">
						<div class="card-header">
							<div class="card-title">
								<?= $vew_lang->TASK ?>
								<a href="#" id="btndocref" class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" title="<?= $vew_lang->reference; ?>"><i class="fas fa-plus"></i></a>
							</div>
						</div>
					</div>
					<div id="buyordmathot" name="buyordmathot"></div>
					
					<div class="card tmss-hot-ttl">
						<div class="card-header">
							<div class="card-title">
								<?= $vew_lang->SUPPLIES ?> / <?= $vew_lang->SERVICES ?>
                <a id="invlnk" title="<?= $vew_lang->inventory; ?>" class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnEdit" aria-hidden="true"><i class="fa fa-archive"></i></a>
								<div class="tmss-card-icon col-sm-3">
                  <?php
                    echo vew_boot($lv_col210,	array('label' => $vew_lang->storelocation,
                                        'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                            array('input'=>gethtml('dstobjtxt', 'typeahead', (isset($vew_data->stkmovdoc[0]['dstobjtxt']) ? $vew_data->stkmovdoc[0]['dstobjtxt'] : ''), $lv_default) ))
																				 ));
										echo gethtml('dstobjcod', 'hidden', (isset($vew_data->stkmovdoc[0]['dstobjcod']) ? $vew_data->stkmovdoc[0]['dstobjcod'] : ''));
                  ?>
                </div>
							</div>
						</div>
					</div>
					<div id="stkmanacthot" name="stkmanacthot"></div>
					
        </div> <!-- /tab001 -->
      </div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>

	<!-- Ventana de rechazo -->
	<div id="rowfrm" class="hidden">
		<form class="form-horizontal tmss-form-horizontal pt-0 pb-0">
			<?php
				echo vew_boot($lv_col210, array('label'=>$vew_lang->REJECTION,'input'=>gethtml('rowstkactmatrejcod', $lv_rejarr, '', $lv_default) ));
				echo vew_boot($lv_col210, array('label'=>$vew_lang->comments,	'input'=>gethtml('rowbuyordmatbuytxt',	'doccmt1x50', '', $lv_default) ));
			?>
		</form>
	</div>	
	<script>
		// TYPEAHEAD - ALMACEN
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"a.docsts":"A"}, "fldasg":{"dstobjcod":"strloccod", "dstobjtxt":"strloctxt"}};
 		tmssTypeahead($("#<?= $lv_sec; ?> #dstobjtxt"), "stkstrloc", lo_get);
    
    // Guarda el valor anterior de dstobjcod
    $("#<?= $lv_sec; ?> #dstobjcod").data("previous", $("#<?= $lv_sec; ?> #dstobjcod").val());
    // Maneja el evento change en storelocation
    $("#<?= $lv_sec; ?> #dstobjtxt").data("previous", $("#<?= $lv_sec; ?> #dstobjtxt").val()).on("change", function () {
      var lv_input = $(this);
      var lv_prevValue = lv_input.data("previous");
      var lv_newValue = lv_input.val();
      var lv_dstobjcod = $("#<?= $lv_sec; ?> #dstobjcod").data("previous");

      // Si la tabla tiene valores, muestra el diálogo de confirmación
      if (<?= $lv_sec; ?>_hotdoc.countRows() > 1 && !lv_input.data("dialogShown")) {
        lv_input.data("dialogShown", true);

        <?= $lv_sec; ?>_confirmDialog("Los insumos/servicios ser&aacute;n borrados de la tabla. &iquest;Desea continuar?", function (result) {
          if (result) {
              // Marcar materiales como eliminados
              var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
              for (var i = 0; i < lv_dat.length; i++) {
                if (lv_dat[i]["stkmovdocmatcod"] && lv_dat[i]["stkmovdocmatcod"] !== undefined) {
                  lv_dat[i]["deleted"] = "X"; 
                  <?= $lv_sec; ?>_hotdocdel.push(lv_dat[i]);
                }
              }
              // Vaciar la tabla
              <?= $lv_sec; ?>_hotdoc.loadData([]);
              // Guardar el nuevo valor
              lv_input.data("previous", lv_newValue);
              $("#<?= $lv_sec; ?> #dstobjcod").data("previous", $("#<?= $lv_sec; ?> #dstobjcod").val());
          } else {
              // Restaurar los valores anteriores si se cancela
              lv_input.val(lv_prevValue);
              $("#<?= $lv_sec; ?> #dstobjcod").val(lv_dstobjcod);
          }
          lv_input.data("dialogShown", false);
        });
      } else {
        // Si la tabla está vacía, permitir el cambio sin mostrar el diálogo
        lv_input.data("previous", lv_newValue);
        $("#<?= $lv_sec; ?> #dstobjcod").data("previous", $("#<?= $lv_sec; ?> #dstobjcod").val());
      }
    });
    
    // Función para mostrar el diálogo de confirmación
    function <?= $lv_sec; ?>_confirmDialog(message, callback) {
      BootstrapDialog.show({
        title: "<?= $vew_lang->confirmation; ?>",
        message: message,
        closable: false,
        type: BootstrapDialog.TYPE_WARNING,
        buttons: [ { label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function (dialog) { dialog.close(); callback(false); } },
                   { label: "<?= $vew_lang->accept; ?>", cssClass: "btn-danger", action: function (dialog) { dialog.close(); callback(true); } }
                 ],
      });
    }
			
		// CONTABILIZAR
		$("#<?= $lv_sec; ?> #btnacc").on("click",function(e){ e.preventDefault();
			if ($("#stkmanacthot table tbody").find("tr").length > 0){
        BootstrapDialog.confirm({
          title: "Contabilizar", 
          message:"Desea contabilizar el documento ?",
          type: BootstrapDialog.TYPE_PRIMARY,
          callback: function(result){	if(result){	 <?= $lv_sec; ?>_fnc({action: "09"}); } }
				});
      }	else {
      	BootstrapDialog.confirm({
        	title: "Contabilizar", 
          message:"Debe seleccionar al menos un Insumo o Servicio.",
          type: BootstrapDialog.TYPE_PRIMARY
        });
      }
		});

		// BUSCAR NRO DE SERIE
		function <?= $lv_sec; ?>_findSerial(lv_row) {
			var lv_matcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row, "matcod");
			if (lv_matcod == "" || lv_matcod == undefined) {
				toastr.warning("Debe seleccionar un material.");
			} else {
				$("#<?= $lv_sec; ?> #tmpmatsercod, #<?= $lv_sec; ?> #tmpmatsercodext").data("row", lv_row);
				var lv_objcod = ($("#<?= $lv_sec; ?> #dstobjcod").val() == "" || $("#<?= $lv_sec; ?> #dstobjcod").val() == "0" ? $("#<?= $lv_sec; ?> #dstobjcod").val() : $("#<?= $lv_sec; ?> #dstobjcod").val())
				tmssPopup("Buscar numero de serie","?prg=stkmatser&prm_vewcod=VEW_STK_MAT_SER_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[tmpmatsercod:matsercod],[tmpmatsercodext:matsercodext]&prm_fldflt=[s.matcod:"+lv_matcod+"],[s.docsts:A],[stkobjcod:"+lv_objcod+"]");
			}
		}
		$("#<?= $lv_sec; ?> #tmpmatsercod, #<?= $lv_sec; ?> #tmpmatsercodext").on("change", function(e) {
			<?= $lv_sec; ?>_hotdoc.setDataAtRowProp($(this).data("row"), $(this).data("fldnme"), $(this).prop("value"));
		});

		// BUSCAR LOTE
		function <?= $lv_sec; ?>_findBatch(lv_row) {      
			var lv_matcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row, "matcod");
			if (lv_matcod == "" || lv_matcod == undefined) {
				toastr.warning("Debe seleccionar un material.");
			} else {
				$("#<?= $lv_sec; ?> #tmpmatbchcod, #<?= $lv_sec; ?> #tmpmatbchcodext").data("row", lv_row);
        tmssPopup("Buscar Lote","?prg=stkmatstk&prm_vewcod=VEW_STK_MAT_STK_BCH_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[tmpmatbchcod:matbchcod],[tmpmatbchcodext:matbchcodext]&prm_fldflt=[s.matcod:" +lv_matcod + "],[s.docsts:A],[s.stkobjtyp:STK_STL],[s.stkobjcod:"+$("#<?= $lv_sec; ?> #dstobjcod").val()+"],[not isnull(s.matbchcod_^0^):0]");
			}
		}
		$("#<?= $lv_sec; ?> #tmpmatbchcod, #<?= $lv_sec; ?> #tmpmatbchcodext").on("change",function(e) {
			<?= $lv_sec; ?>_hotdoc.setDataAtRowProp($(this).data("row"), $(this).data("fldnme"), $(this).prop("value"));
		});
			
		 // MOTIVO DE RECHAZO
		function <?= $lv_sec; ?>_showDetails( lv_row ) {
			var lv_id = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(lv_row,"stkmanordcod");
			BootstrapDialog.show({
				title: "Orden de trabajo <small>#"+lv_id+"</small>",
				message: $("#<?= $lv_sec; ?> #rowfrm > form").clone(),
				type: BootstrapDialog.TYPE_INFO,
				buttons: [{ label: "Cancelar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
									{	label: "OK", cssClass: "btn-primary",	action: function(dialogItself){
										<?= $lv_sec; ?>_hotmat.setDataAtRowProp(lv_row,"buyordmatbuytxt",dialogItself.getModalBody().find("#rowbuyordmatbuytxt").val());
										<?= $lv_sec; ?>_hotmat.setDataAtRowProp(lv_row,"sysdocrejcod",dialogItself.getModalBody().find("#rowstkactmatrejcod").val());
										dialogItself.close();
									}
								}],
				onshow: function(dialog) {
					// asigno valores de la grilla
					var lv_frm = $(dialog.$modalContent);
					$(lv_frm).find("#rowbuyordmatbuytxt").prop("value", <?= $lv_sec; ?>_hotmat.getDataAtRowProp(lv_row,"buyordmatbuytxt") );
					$(lv_frm).find("#rowstkactmatrejcod").prop("value", <?= $lv_sec; ?>_hotmat.getDataAtRowProp(lv_row,"sysdocrejcod") );
				}
			});
		}
	</script>
	<script>
		/**
		 *
		 *	I N S U M O S
		 *
		 */
		var <?= $lv_sec; ?>_hotdoc_renderer = function(instance, td, row, col, prop, value, cellProperties) {
			if (<?= $lv_sec; ?>_hotdoc != undefined) {
				var lv_ro_color = "#F1F1F1";
				var lv_color = "#FFFFFF";
				var lv_ro = <?=($vew_readonly?'true':'false'); ?>;
        
				var lv_matuseser = (<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row, "matuseser") == "1" ? true : false);
				var lv_matusebch = (<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row, "matusebch") == "1" ? true : false);
        var lv_matcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row, "matcod");
				
				if (prop == "matsercodext") {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro || !lv_matcod || !lv_matuseser ? lv_ro_color : lv_color);
					cellProperties.readOnly = (lv_ro || !lv_matcod ? true : false);
				} else if (prop == "icn3" && lv_matuseser) {
          if (lv_matcod) {
            var lv_btn = "<div onclick='<?= $lv_sec; ?>_findSerial("+row+");' class='text-center cursor-pointer'><a href='#'><i class='fas fa-search'></i></a></div>";
            $(td).empty().append(lv_btn);
            $(td).addClass("text-center");
            td.style.backgroundColor = lv_ro_color;
          } else {
            $(td).empty();
          }
				} else if (prop == "matuntcod") {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro || !lv_matusebch ? lv_ro_color : lv_color);
					cellProperties.readOnly = (lv_ro || !lv_matusebch ? true : false);
				} else if (prop == "matbchcodext") {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro || !lv_matusebch ? lv_ro_color : lv_color);
					cellProperties.readOnly = (lv_ro || !lv_matusebch ? true : false);
        } else if (prop == "matqty"){
          Handsontable.renderers.NumericRenderer.apply(this, arguments);			
          td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
          cellProperties.readOnly = (lv_ro?true:false);			
				} else if (prop == "icn4" && lv_matusebch) {
					var lv_btn = "<div onclick='<?= $lv_sec; ?>_findBatch("+row+");' class='text-center cursor-pointer'><a href='#'><i class='fas fa-search'></i></a></div>";
					$(td).empty().append(lv_btn);
					$(td).addClass("text-center");
					td.style.backgroundColor = lv_ro_color;
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro ? lv_ro_color : lv_color);
					cellProperties.readOnly = (lv_ro ? true : false);
				}
			}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotdocdel = [];
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #stkmanacthot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 250,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly ?'0':'1') ?>,
			colHeaders: ["<?= $vew_lang->code; ?>", "<?= $vew_lang->description; ?>", "<?= $vew_lang->quantity; ?>", "<?= $vew_lang->um; ?>", "<?= $vew_lang->batch; ?>", <?php if (!$vew_readonly){  ?> "",<?php } ?> "<?= $vew_lang->serialnumber; ?>", <?php if (!$vew_readonly){  ?> "", <?php } ?>],
			columns: [{type: "text",data: "matcod",width:20,renderer: <?= $lv_sec; ?>_hotdoc_renderer,editor: false,readOnly: true}, {
				type: "autocomplete",
				data: "mattxt",
				renderer: <?= $lv_sec; ?>_hotdoc_renderer,
				<?= ($vew_readonly?'readOnly: true, ':''); ?>
				source (query, process) {
          var lv_objcod = ($("#<?= $lv_sec; ?> #dstobjcod").val() == "" || $("#<?= $lv_sec; ?> #dstobjcod").val() == "0" ? $("#<?= $lv_sec; ?> #dstobjcod").val() : $("#<?= $lv_sec; ?> #dstobjcod").val())
					if (query.length > 1 && <?= $lv_sec; ?>_hot_paste != true) {
						$.ajax({
							url: "?prg=stkmatstk&act=27", dataType: "json", data: {prm_mattxt: query, prm_stkobjtyp: 'STK_STL', prm_stkobjcod: lv_objcod},
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
					} else {
						<?= $lv_sec; ?>_hot_paste = false;
					}
				},
				strict: true
			},
			{type: "numeric",data: "matqty",width: 50,renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true ':''); ?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"}},
			{type: "text",data:"matuntcod",width: 50,renderer: <?= $lv_sec; ?>_hotdoc_renderer,editor: false, readOnly: true},
			{ type: "text",data: "matbchcodext",width: 50,renderer: <?= $lv_sec; ?>_hotdoc_renderer,editor: false,readOnly: true},
			<?php if (!$vew_readonly) {  ?> {type: "text",data: "icn4",width: 20,renderer: <?= $lv_sec; ?>_hotdoc_renderer,editor: false,readOnly: true}, <?php } ?> 
			{type: "text",data: "matsercodext",width: 50,renderer: <?= $lv_sec; ?>_hotdoc_renderer,editor: false,readOnly: true},
			<?php if (!$vew_readonly) {  ?> {type: "text",data: "icn3", width: 20,renderer: <?= $lv_sec; ?>_hotdoc_renderer,editor: false,readOnly: true},<?php } ?>
			],
      afterChange: function(changes, source) {
        if (changes && changes.length > 0 && source === 'edit') {
          const row = changes[0][0];
          const valueSelected = changes[0][3] || "";
          if( changes[0][1]=="mattxt"){
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matcod", "");
            } else {
                const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.mattxt === valueSelected);
                if (selectedItem) { 
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matcod", selectedItem.matcod, 'autocomplete');
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matuntcod", selectedItem.matuntcod, 'autocomplete');
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matuseser", selectedItem.matuseser, 'autocomplete');
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matusebch", selectedItem.matusebch, 'autocomplete');
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matqty", "", 'autocomplete');
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matsercod", "", 'autocomplete');
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matsercodext", "", 'autocomplete');
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matbchcodext", "", 'autocomplete');
                } else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia."); 
            	}
          }
        }
      },
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for (var i = index; i <= index + amount - 1; i++) {
					if (lv_dat[i]["stkmovdocmatcod"] != "" && lv_dat[i]["stkmovdocmatcod"] != undefined) {
						<?= $lv_sec; ?>_hotdocdel.push(lv_dat[i]);
					}
				}
			},
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotdoc;
		
		tmssLoadScript("handsontable16", function() {
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
			$lv_buffer='';
			if ( is_array($vew_data->stkmovdocmat) ) {
				foreach($vew_data->stkmovdocmat as $lv_row){
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
											'stkmovdocmatcod:"'.$lv_row['stkmovdocmatcod'].'",'.
											'matcod:"'.$lv_row['matcod'].'",'.
											'mattxt:`'.$lv_row['mattxt'].'`,'.
            					'matuseser:`'.$lv_row['matuseser'].'`,'.
											'matsercod:`'.$lv_row['matsercod'].'`,'.
											'matsercodext:`'.$lv_row['matsercodext'].'`,'.
											'matusebch:`'.$lv_row['matusebch'].'`,'.
											'matbchcod:`'.$lv_row['matbchcod'].'`,'.
											'matbchcodext:`'.$lv_row['matbchcodext'].'`,'.
											'matuntcod:`'.$lv_row['matuntcod'].'`,'.
											'matqty:`'.(float)$lv_row['matqty'].'`,'.
										'}';
				}
			}
			echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData(lv_dat);
			<?= $lv_sec; ?>_hotdoc.render();
		});

	</script>
	<script>
		$("#<?= $lv_sec ?> #invlnk").on("click", function(e) { e.preventDefault();
			var lv_mdlcod = "STK";
			var lv_prgcod = "SIV";
			tmssLink('?prg=stkmovdoc&act=03&prm_stkmovdoccod=<?= strval($vew_data->stkmovdoccod); ?>&prm_mdlcod='+lv_mdlcod+'&prm_prgcod='+lv_prgcod, [{target: "_new_section"}]);
		});
	</script>
	<script>
		// AGREGAR ORDENES
		$("#<?= $lv_sec; ?> #btndocref").on("click", function(e) { e.preventDefault();
      // envío referencias agregadas que aún no hayan sido grabadas para que las desestime
			var lv_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
			var lv_refarr = new Array();
			for (var i=0; i<lv_dat.length; i++) {
				if ( (lv_dat[i]["stkmanactmatcod"]==undefined ? "":lv_dat[i]["stkmanactmatcod"])=="") { 
          lv_refarr.push({"stkmanordmatcod":lv_dat[i]["stkmanordmatcod"]});
				}
			}
      var lv_pstdat = [	{name: "refarr", value: JSON.stringify(lv_refarr)} ];
			tmssCallProcess("?prg=stkmanord&act=ordfnd", lv_pstdat, function(data) {
				BootstrapDialog.show({
					size: BootstrapDialog.SIZE_WIDE,
					title: "Agregar ordenes de trabajo",
					message: $(data),
					buttons: [{label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself) { dialogItself.close(); }},
										{label: "<?= $vew_lang->add; ?>", cssClass: "btn-success", action: function(dialogItself) {
											if (dialogItself.getModalBody().find("input[name=rowchk]:checked").length == 0) {
												toastr.warning("Debe indicar al menos una posci&oacute;n de referencia.");
												return false;
											}
											var lv_data = <?= $lv_sec; ?>_hotmat.getSourceData();
											if (lv_data.length != 0) {
												if (lv_data[lv_data.length - 1].mattxt == undefined) {
													lv_data.splice(lv_data.length - 1, 1);
												} else {
													lv_data.splice(lv_data.length, 1);
												}
											}
											dialogItself.getModalBody().find("input[name=rowchk]:checked").each(function(e) {
												var lv_matcod = $(this).data("ordcod");
												var lv_dat = dialogItself.getModalBody().find( "#" + lv_matcod + "_data").text();
												var lo_dat = JSON.parse(lv_dat);
												lv_data.push({
													"stkmanordcod": lo_dat["stkmanordcod"],
													"stkmanordtxt": lo_dat["stkmanordtxt"],
													"stkmanordmatcod": lo_dat["stkmanordmatcod"],
													"mattxt": lo_dat["mattxt"],
                          "matsercodext": lo_dat["matsercodext"],
													"stkmanordmatatr": lo_dat["stkmanordmatatr"],
                          "docreftyp":'STK_MCO',
                          "docrefcod":lo_dat["stkmanordcod"],
                          "docrefposcod":lo_dat["stkmanordmatcod"]
												});
											});
											<?= $lv_sec; ?>_hotmat.loadData(lv_data);
											dialogItself.close();
										}}]
				});
			});
		});

		/**
		 *
		 *	M A T E R I A L E S
		 *
		 */
		var <?= $lv_sec; ?>_hotmat_renderer = function(instance, td, row, col, prop, value, cellProperties) {
				if (<?= $lv_sec; ?>_hotmat != undefined) {
						var lv_ro_color = "#F1F1F1";
						var lv_color = "#FFFFFF";
						var lv_ro = <?=($vew_readonly?'true':'false'); ?>;
						
						var lv_sysdocrejcod = <?= $lv_sec; ?>_hotmat.getDataAtRowProp(row,"sysdocrejcod");
						lv_sysdocrejcod = (lv_sysdocrejcod==null || lv_sysdocrejcod==""?"0":lv_sysdocrejcod);
											
					if (prop=="icn") {
						var lv_btn = "<a onclick='<?= $lv_sec; ?>_showDetails("+row+");' class='btn "+(lv_sysdocrejcod!="0"?"btn-danger":"btn-default")+" btn-sm'><span class='fa fa-ellipsis-h'></span></a>";
						$(td).empty().append(lv_btn);
						$(td).addClass("text-center");
						td.style.backgroundColor = lv_ro;
					} else {
						Handsontable.renderers.TextRenderer.apply(this, arguments);
						td.style.backgroundColor = (lv_ro_color);
						cellProperties.readOnly = (lv_ro ? true : false);
					}
				}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotmatdel = [];
		var <?= $lv_sec; ?>_hotmatcnt = $("#<?= $lv_sec; ?> #buyordmathot")[0];
		var <?= $lv_sec; ?>_hotmatset = {
      height: 250,
      stretchH: "all",
      <?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
      minSpareRows: 0,
      colHeaders: ["Orden", "Material a reparar", "<?= $vew_lang->serialnumber; ?>", "Descripcion Original", ""],
      columns: [
          {type: "text",data: "stkmanordtxt",width: 10,renderer: <?= $lv_sec; ?>_hotmat_renderer,editor: false,readOnly: true},
          {type: "text",data: "mattxt",width: 10,renderer: <?= $lv_sec; ?>_hotmat_renderer,editor: false,readOnly: true},
          {type: "text",data: "matsercodext",width: 10,renderer: <?= $lv_sec; ?>_hotmat_renderer,editor: false,readOnly: true},
          {type: "text",data: "stkmanordmatatr",width: 10,renderer: <?= $lv_sec; ?>_hotmat_renderer,editor: false, readOnly: true },
          {type: "text",data: "icn", width: 2, renderer: <?= $lv_sec; ?>_hotmat_renderer, editor: false, readOnly: true},          
      ],
      beforeRemoveRow: function(index, amount, logicalRows) {
        // me guardo todas las filas eliminadas (solo si tienen ID de registro)
        var lv_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
        for (var i = index; i <= index + amount - 1; i++) {
          if (lv_dat[i]["stkmanordmatcod"] != "" && lv_dat[i]["stkmanordmatcod"] != undefined) {
            <?= $lv_sec; ?>_hotmatdel.push(lv_dat[i]);
          }
        }
      },
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotmat;

		tmssLoadScript("handsontable16", function() {
				<?= $lv_sec; ?>_hotmat = new Handsontable(<?= $lv_sec; ?>_hotmatcnt, <?= $lv_sec; ?>_hotmatset);
				var lv_dat = [<?php
				$lv_buffer='';
				if ( is_array($vew_data->stkmanactmat) ) {
				foreach($vew_data->stkmanactmat as $lv_row){
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
													'stkmanactmatcod:"'.$lv_row['stkmanactmatcod'].'",'. 
													'stkmanordmatcod:`'.$lv_row['stkmanordmatcod'].'`,'. 
													'stkmanordcod:`'.$lv_row['stkmanordcod'].'`,'. 
													'stkmanordtxt:`'.$lv_row['stkmanordtxt'].'`,'. 
													'stkmanactcod:`'.$lv_row['stkmanactcod'].'`,'.
													'mattxt:`'.$lv_row['mattxt'].'`,'.             
            							'matsercodext:`'.$lv_row['matsercodext'].'`,'. 
													'stkmanordmatatr:`'.$lv_row['stkmanordmatatr'].'`,'. 
													'sysdocrejcod:"'.$lv_row['sysdocrejcod'].'",'.    
                          'docreftyp:"'.($lv_row['docreftyp']??'').'",'.
                          'docrefcod:"'.($lv_row['docrefcod']??0).'",'.
                          'docrefposcod:"'.($lv_row['docrefposcod']??0).'",'.
												'}';
					}
				}
				echo $lv_buffer;
			?>];
				<?= $lv_sec; ?>_hotmat.loadData(lv_dat);
				<?= $lv_sec; ?>_hotmat.render();
		});

	</script>
	<script>

		// S U B M I T. prepara los datos antes de grabar
		function <?= $lv_sec; ?>_fncext(lp_prm) {

			////////////////////////////// M A T E R I A L E S //////////////////////////////
			if (lp_prm["action"] == "00") {
				// obtengo datos de handsontable
				var err = 0;
				var lo_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
				var lv_arr = new Array();
				var lv_arr_error = new Array();

        if( lo_dat.length == 0 ){
					toastr.warning("Falta agregar un material a reparar");
					return false;
        }
        
				for (var i = 0; i < lo_dat.length; i++) {
          lv_arr.push({
            "stkmanactmatcod": lo_dat[i]["stkmanactmatcod"],
            "stkmanordcod": lo_dat[i]["stkmanordcod"],
            "stkmanordmatcod": lo_dat[i]["stkmanordmatcod"],
            "sysdocrejcod": lo_dat[i]["sysdocrejcod"],
            "docreftyp":lo_dat[i]["docreftyp"],
            "docrefcod":lo_dat[i]["docrefcod"],
            "docrefposcod":lo_dat[i]["docrefposcod"]
          });
				}

				// agrego las filas eliminadas
				for (var i = 0; i < <?= $lv_sec; ?>_hotmatdel.length; i++) {
					lv_arr.push({
						"stkmanactmatcod": <?= $lv_sec; ?>_hotmatdel[i]["stkmanactmatcod"],
						"deleted": "X"
					});
				}

				if (lv_arr.length == 0) {
					$("#<?= $lv_sec; ?> #stkmanactmat").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #stkmanactmat").prop("value", JSON.stringify(lv_arr));
				}

				////////////////////////////// I N S U M O S //////////////////////////////
				// obtengo datos de handsontable
				var err = 0;
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
				var lv_arr_error = new Array();
        var lv_err = false;
				for (var i = 0; i < lo_dat.length; i++) {
					if (lo_dat[i]["mattxt"] != "" && lo_dat[i]["mattxt"] != undefined) {
						if (lo_dat[i]["matuseser"] == "1" && (lo_dat[i]["matsercod"] == undefined || lo_dat[i]["matsercod"] == "")) {
              lv_err = true;
							<?= $lv_sec; ?>_hotdoc.setCellMeta(i, <?= $lv_sec; ?>_hotdoc.propToCol("matsercodext"), "valid",false);
						} 
            if (lo_dat[i]["matusebch"] == "1" && lo_dat[i]["matbchcod"] == undefined) {
              lv_err = true;
							<?= $lv_sec; ?>_hotdoc.setCellMeta(i, <?= $lv_sec; ?>_hotdoc.propToCol("matbchcodext"), "valid", false);
						}
            if (!lo_dat[i]["matqty"]) {
              lv_err = true;
							<?= $lv_sec; ?>_hotdoc.setCellMeta(i, <?= $lv_sec; ?>_hotdoc.propToCol("matqty"), "valid", false);
						}
            if(lv_err){
							lv_arr_error.push(i);
            }else{
							lv_arr.push({
								"stkmovdocmatcod": lo_dat[i]["stkmovdocmatcod"],
								"matcod": lo_dat[i]["matcod"],
								"mattxt": lo_dat[i]["mattxt"],
								"matsercod": lo_dat[i]["matsercod"],
								"matsercodext": lo_dat[i]["matsercodext"],
								"matusebch": lo_dat[i]["matusebch"],
								"matbchcodext": lo_dat[i]["matbchcodext"],
								"matuntcod": lo_dat[i]["matuntcod"],
								"matqty": lo_dat[i]["matqty"]
							});
						}
					}
				}

				// verifico error
				if (lv_arr_error.length > 0) {
					<?= $lv_sec; ?>_hotdoc.render();
					toastr.warning("Verificar casillas marcadas");
					return false;
				}

				// agrego las filas eliminadas
				for (var i = 0; i < <?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({
						"stkmovdoccod": "<?= $vew_data->stkmovdoccod; ?>",
						"stkmovdocmatcod": <?= $lv_sec; ?>_hotdocdel[i]["stkmovdocmatcod"],
						"matcod": <?= $lv_sec; ?>_hotdocdel[i]["matcod"],
						"mattxt": <?= $lv_sec; ?>_hotdocdel[i]["mattxt"],
						"matsercod": <?= $lv_sec; ?>_hotdocdel[i]["matsercod"],
						"matsercodext": <?= $lv_sec; ?>_hotdocdel[i]["matsercodext"],
						"matbchcod": <?= $lv_sec; ?>_hotdocdel[i]["matusebch"],
						"matbchcodext": <?= $lv_sec; ?>_hotdocdel[i]["matbchcodext"],
						"matuntcod": <?= $lv_sec; ?>_hotdocdel[i]["matuntcod"],
						"matqty": <?= $lv_sec; ?>_hotdocdel[i]["matqty"], 
						"deleted": "X"
					});
				}

				if (lv_arr.length == 0) {
					$("#<?= $lv_sec; ?> #stkmaninv").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #stkmaninv").prop("value", JSON.stringify(lv_arr));
				}
			}
		}

			
		// CONFIRMA - C O N T A B I L I Z A R 
		function <?= $lv_sec; ?>_fncbckext( data ) {
      if ( gv_<?= $lv_sec; ?>_last_action=="09" && data.errcod!=0 && data.hasOwnProperty("errmat") && data.errmat != "" && data.errmat!='[]') {
        var lv_matarr = JSON.parse(data.errmat);
        toastr.warning("Hubo un error al intentar contabilizar el inventario. Por favor corrijalos y vuelva a contabilizar la actividad.<br>"
                       +data.errcod+": "+data.errtxt);
        
        var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData(); //Datos handsontable
        var lv_found;
        for(var i=0; i<lv_dat.length; i++){
          lv_found==false;
          for(var x=0; x<lv_matarr.length; x++){
            // errores de stock
            if ( data.errcod==-601 && lv_matarr[x].matcod==lv_dat[i].matcod ) {
              lv_found==true;
              <?= $lv_sec; ?>_hotdoc.setCellMeta(i, 1, "valid", false);
            // errores de lote
            } else if ( (data.errcod==-302 || data.errcod==-402 || data.errcod==-502 || data.errcod==-602) && lv_matarr[x].matcod==lv_dat[i].matcod && lv_matarr[x].matbchcodext == lv_dat[i].matbchcodext ) {
              gund==true;
              <?= $lv_sec; ?>_hotdoc.setCellMeta(i, <?= $lv_sec; ?>_hotdoc.propToCol("matbchcodext"), "valid", false);
              <?= $lv_sec; ?>_hotdoc.setCellMeta(i, <?= $lv_sec; ?>_hotdoc.propToCol("matbchduedte"), "valid", false);
            // errores de nros de serie
            } else if ( (data.errcod==-403 || data.errcod==-503 || data.errcod==-603) && lv_matarr[x].matcod==lv_dat[i].matcod && lv_matarr[x].matsercodext == lv_dat[i].matsercodext ) {
              lv_found==true;
              <?= $lv_sec; ?>_hotdoc.setCellMeta(i, <?= $lv_sec; ?>_hotdoc.propToCol("matsercodext"), "valid", false);
            } 
          }
          if(lv_found==false){
            <?= $lv_sec; ?>_hotdoc.setCellMeta(i, 2, "valid", true);
            <?= $lv_sec; ?>_hotdoc.setCellMeta(i, 4, "valid", true);
            <?= $lv_sec; ?>_hotdoc.setCellMeta(i, 6, "valid", true);
            <?= $lv_sec; ?>_hotdoc.setCellMeta(i, 7, "valid", true);
          }
        }
        <?= $lv_sec; ?>_hotdoc.render();
      } else {
        if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
          if (gv_<?= $lv_sec; ?>_last_action=="09") {
            toastr.info("Documento contabilizado.");
            <?= $lv_sec; ?>_fnc({action: "99"});
          } else if (gv_<?= $lv_sec; ?>_last_action=="04") {
            tmssTabSecCls( $("#<?= $lv_sec; ?>") );
          } else {
            $("#<?= $lv_sec; ?>").replaceWith( data );
          }
        } 
      }
		}
	</script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
<?php
	// url del formulario
  $lv_lnk = '?prg=stkmanreq&prm_stkmanreqcod='.$vew_data->stkmanreqcod;
	
	// campos requeridos
	$vew_input->RequiredFields(array('stkmanreqtxt', 'docsts', 'srcobjtyp', 'srcobjtxt'));

	// clave del documento
	$lv_dockey = $vew_data->stkmanreqcod;

	// titulo
	$lv_title = $vew_lang->request;

	// modulo y programa
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'MCS';
	
  // librería de estilos
  include_once('_library.frm');
	
	$lv_vew = ($vew_data->vew==''?'req':$vew_data->vew);

	$lv_stkmatsysdocclscod = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'stkmat_sysdocclscod');

	// Asigna la clase 'hidden' si el Tipo es STK_STL(Almacenes)
	$lv_hidden = ($vew_data->srcobjtyp === 'STK_STL') ? 'hidden' : '';

	if ( $vew_data->stkmanreqcod=='' ) {
		$vew_data->stkmanreqdte = date('d/m/Y');
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
     <?= gethtml('tmss_actcod', 'hidden', ''); ?>
     <?= gethtml('vew', 'hidden', $lv_vew); ?>
		<textarea class="hidden" id="stkmanreqmat" name="stkmanreqmat"></textarea>
    <input type="hidden" id="tmpmatsercod" 		name="tmpmatsercod" 		data-fldnme="matsercod" 		value="">
    <input type="hidden" id="tmpmatsercodext" name="tmpmatsercodext" 	data-fldnme="matsercodext" 	value="">	

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->stkmanreqcod; ?><?= gethtml('stkmanreqcod','hidden',$vew_data->stkmanreqcod); ?></strong></h4></li>
      </ul>
			<div class="tab-content tmss-tab-content">

				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                 <div class="card-title"><?= $vew_lang->REQUEST; ?> 
									 <span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
										<?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);?>
               		</div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 				'input'=>gethtml('stkmanreqdte', 'docdte', $vew_data->stkmanreqdte, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 	'input'=>gethtml('stkmanreqtxt', 'doccmt1x50', $vew_data->stkmanreqtxt, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div> <!-- /card -->
						</div> <!-- /col -->
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
									<div class="card-title">
                    <?php if($vew_data->sysdoctrecod=='N'){ ?><span><span class="far fa-circle"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod=='P'){ ?><span class="text-warning"><span class="far fa-circle-half-stroke"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod=='C'){ ?><span class="text-success"><span class="fas fa-circle"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod==''){ echo '&nbsp;'; } ?>
										<span class="card-icon"><?= $vew_lang->location; ?> / <?= $vew_lang->place; ?></span>
									</div>
								</div>
                <div class="card-body tmss-card-body-edit">
                  <?php                  
										echo vew_boot($lv_col210, array('label'=>$vew_lang->type,
																									'input2'=>gethtml('srcobjtyp', 
																																		array(''=>'', 'SLS_CUS'=>'CLIENTE','HLT_PAT'=>'PACIENTE','STK_STL'=>'ALMACEN'), $vew_data->srcobjtyp, $vew_data->sysdoctrecod=='N' || $vew_data->sysdoctrecod==''?$lv_default:$lv_always_disabled)));
										echo '<div id="lct">'; 
										echo vew_boot($lv_col210,	array('label'=>$vew_lang->location, 
																										'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_data->sysdoctrecod=='N' || $vew_data->sysdoctrecod==''?$vew_readonly:true), 
																																			array('input'=>gethtml('srcobjtxtaux', 'typeahead', $vew_data->srcobjtxt, $vew_data->sysdoctrecod=='N' || $vew_data->sysdoctrecod==''?$lv_default:$lv_always_disabled) ) )));        
										echo gethtml('srcobjcod', 'hidden', $vew_data->srcobjcod);
										echo '</div>';
										echo '<div id="cnt" class="'.$lv_hidden.'">'; 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->contact,
																										'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_data->sysdoctrecod=='N' || $vew_data->sysdoctrecod==''?$vew_readonly:true),
																																			array('input'=>gethtml('srccnttxtaux', 'typeahead', $vew_data->srccnttxt, $vew_data->sysdoctrecod=='N' || $vew_data->sysdoctrecod==''?$lv_default:$lv_always_disabled) ) )));
									
										echo gethtml('srccntcod', 'hidden', $vew_data->srccntcod);
										echo '</div>';
									?>
                </div>
              </div> <!-- /card -->
						</div> <!-- /col -->
					</div> <!-- /row -->

          <div class="col-md-12">
            <div class="row">         
              <div class="card tmss-hot-ttl">
                <div class="card-header"><div class="card-title"><?= $vew_lang->materials; ?></div></div>
              </div>      
							<div id="buyordmathot" name="buyordmathot"></div>
            </div> <!-- /row -->
          </div> <!-- /col -->
					
				</div> <!-- /tab001 -->
			</div> <!--/tab-content -->
		</div> <!-- /container-fluid -->
  </form>
  <script>
    $("#<?= $lv_sec; ?>").on("change","#srcobjtyp, #srcobjcod, #srccntcod", function() { 
      var lv_input = $(this);
      var lv_prevValue = $(lv_input).data("previous");
      var lv_newValue = $(lv_input).val();
      if(lv_prevValue == lv_newValue){return true;}
      
      // valores anteriores de srcobjtxt y srccntcod
      var lv_srcobjtxt = $("#<?= $lv_sec; ?> #srcobjtxt");
  		var lv_srccnttxt = $("#<?= $lv_sec; ?> #srccnttxt");
      
      // Si la tabla tiene valores, muestra el diálogo de confirmación
      if (<?= $lv_sec; ?>_hotdoc.countRows() > 1 && !$(this).data("dialogShown")) {
        $(this).data("dialogShown", true);
        <?= $lv_sec; ?>_confirmDialog("Los materiales ser&aacute;n borrados de la tabla. &iquest;Desea continuar?", function (result) {
          if (result) {
            // Marcar materiales como eliminados
            var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
            for (var i = 0; i < lv_dat.length; i++) {
              if (lv_dat[i]["stkmanreqmatcod"] && lv_dat[i]["stkmanreqmatcod"] !== undefined) {
                lv_dat[i]["deleted"] = "X"; 
                <?= $lv_sec; ?>_hotdocdel.push(lv_dat[i]);
              }
            }
            // Vaciar la tabla
            <?= $lv_sec; ?>_hotdoc.loadData([]);
            
						// Guardar el nuevo valor
            $(lv_input).data("previous", lv_newValue);
           	lv_srcobjtxt.data("previous", lv_srcobjtxt.val());
           	lv_srccnttxt.data("previous", lv_srccnttxt.val());
            <?= $lv_sec; ?>_update($(lv_input).attr("id"));
            if($(lv_input).attr("id")=="srcobjtyp"){ 
              $("#<?= $lv_sec; ?> #srcobjcod").val(0);
              $("#<?= $lv_sec; ?> #srccntcod").val(0);
            }
          } else {
            // Restaurar los valores anteriores si se cancela
            $(lv_input).val(lv_prevValue);
           	lv_srcobjtxt.val(lv_srcobjtxt.data("previous"));
           	lv_srccnttxt.val(lv_srccnttxt.data("previous"));
          }
          $(lv_input).data("dialogShown", false);
        });
      } else { 
        // Hacer el cambio sin el dialog cuando la tabla esta vacia
        $(lv_input).data("previous", lv_newValue);
        lv_srcobjtxt.data("previous", lv_srcobjtxt.val());
        lv_srccnttxt.data("previous", lv_srccnttxt.val());
        <?= $lv_sec; ?>_update($(lv_input).attr("id"));
        if($(lv_input).attr("id")=="srcobjtyp"){ 
          $("#<?= $lv_sec; ?> #srcobjcod").val(0);
          $("#<?= $lv_sec; ?> #srccntcod").val(0);
        }
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
		
    // Función que actualiza los campos
    function <?= $lv_sec; ?>_update(value) { 
      if (value === "srcobjtyp") {
        // Cuando cambia de selector "srcobjtyp"
        var lv_srcobjtyp = $("#<?= $lv_sec; ?> #srcobjtyp").val();

        // quito typeaheads asociados al anterior tipo de ubicación
        $("#<?= $lv_sec; ?> #lct").find(".hidden").siblings().remove().removeClass("hidden");
        $("#<?= $lv_sec; ?> #cnt").find(".hidden").siblings().remove().removeClass("hidden");
        
        var lv_newsrcobjtxt = $("#<?= $lv_sec; ?> #srcobjtxtaux").val("").parent().clone().addClass("hidden");
        var lv_newsrccnttxt = $("#<?= $lv_sec; ?> #srccnttxtaux").val("").parent().clone().addClass("hidden");
        lv_newsrcobjtxt.find("#srcobjtxtaux").attr("id", "srcobjtxt").attr("name", "srcobjtxt").addClass("tmssInputRequired");
        lv_newsrccnttxt.find("#srccnttxtaux").attr("id", "srccnttxt").attr("name", "srccnttxt");
        
        var lo_getsrc = {"fldsec":"<?= $lv_sec; ?>"};
        var lv_defsrc = "";
        switch(lv_srcobjtyp) {
          case 'STK_STL':
            lo_getsrc["fldflt"] = {"a.docsts":"A"};
            lo_getsrc["fldasg"] = {"srcobjtxt":"strloctxt", "srcobjcod":"strloccod"};
            lv_defsrc = "stkstrloc";
            $("#<?= $lv_sec; ?> #cnt").addClass("hidden");
           break;
            
          case 'SLS_CUS':	case 'HLT_PAT':
						var lo_getcnt = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"srccnttxt":"cnttxt", "srccntcod":"cntcod"}, "fldflt":{ "c.cntsrctyp": $("#<?= $lv_sec; ?> #srcobjtyp"), "c.cntsrccod" : $("#<?= $lv_sec; ?> #srcobjcod"), "c.docsts":"A"} };
            tmssTypeahead(lv_newsrccnttxt.find("#srccnttxt"), "grldatcnt", lo_getcnt, {"afterAssign": function(data){ if(data.$modal == undefined){ $("#<?= $lv_sec; ?> #srccntcod").trigger("change"); }}});
            
            if(lv_srcobjtyp == "SLS_CUS"){
              lo_getsrc["fldflt"] = {"c.docsts":"A"};
              lo_getsrc["fldasg"] = {"srcobjtxt":"custxt", "srcobjcod":"cuscod"};
              lv_defsrc = "slscus";  
            }else{
              lo_getsrc["fldflt"] = {"p.docsts":"A"};
              lo_getsrc["fldasg"] = {"srcobjtxt":"pattxt", "srcobjcod":"patcod"};
              lv_defsrc = "hltpat";
            }
            
            $("#<?= $lv_sec; ?> #cnt").removeClass("hidden").insertAfter("#<?= $lv_sec; ?> #lct" );
          break;
        };
        if(lv_defsrc){
      		tmssTypeahead(lv_newsrcobjtxt.find("#srcobjtxt"), lv_defsrc, lo_getsrc, {"afterAssign": function(data){ if(data.$modal == undefined){ $("#<?= $lv_sec; ?> #srcobjcod").trigger("change"); }}});
				}        
        $("#<?= $lv_sec; ?> #srcobjtxtaux").parent().before(lv_newsrcobjtxt).addClass("hidden");
        lv_newsrcobjtxt.removeClass("hidden");
        $("#<?= $lv_sec; ?> #srccnttxtaux").parent().before(lv_newsrccnttxt).addClass("hidden");
        lv_newsrccnttxt.removeClass("hidden")
        
      } else if (value === "srcobjcod") {
        // Limpiar campos de contacto si cambia el cliente
        $("#<?= $lv_sec; ?> #srccnttxt").val("");
        $("#<?= $lv_sec; ?> #srccntcod").val("");
      }
    }
    
    $(function(){ 
      <?= $lv_sec; ?>_update("srcobjtyp");
      $("#<?= $lv_sec; ?> #srcobjtxt").val("<?= $vew_data->srcobjtxt?>");
      $("#<?= $lv_sec; ?> #srccnttxt").val("<?= $vew_data->srccnttxt?>");
      
      // Guarda los valores anteriores de srcobjcod y srccntcod (caso modificación de solicitud)
    	$("#<?= $lv_sec; ?> #srcobjcod, #<?= $lv_sec; ?> #srccntcod, #<?= $lv_sec; ?> #srcobjtyp, #<?= $lv_sec; ?> #srcobjtxt, #<?= $lv_sec; ?> #srccnttxt").each(function () { $(this).data("previous", $(this).val()); });
    });
    
    // BUSCAR NRO DE SERIE
		function <?= $lv_sec; ?>_findSerial( lv_row ) {
			var lv_matcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row,"matcod");
			if ( lv_matcod=="" || lv_matcod==undefined ) {
				toastr.warning("Debe seleccionar un material.");
			} else {
				$("#<?= $lv_sec; ?> #tmpmatsercod, #<?= $lv_sec; ?> #tmpmatsercodext").data("row",lv_row);
        var lv_objcod = ($("#<?= $lv_sec; ?> #srcobjcod").val() == "" || $("#<?= $lv_sec; ?> #srcobjcod").val() == "0" ? $("#<?= $lv_sec; ?> #dstobjcod").val() : $("#<?= $lv_sec; ?> #srcobjcod").val());
        var lv_contact = $("#<?= $lv_sec; ?> #srccntcod").val();
        if (lv_contact === "") {
        	tmssPopup("Buscar numero de serie","?prg=stkmatser&prm_vewcod=VEW_STK_MAT_SER_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[tmpmatsercod:matsercod],[tmpmatsercodext:matsercodext]&prm_fldflt=[s.matcod:"+lv_matcod+"],[s.docsts:A],[stkobjcod:"+lv_objcod+"],[stkcntcod:0]");
				} else {
          tmssPopup("Buscar numero de serie","?prg=stkmatser&prm_vewcod=VEW_STK_MAT_SER_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[tmpmatsercod:matsercod],[tmpmatsercodext:matsercodext]&prm_fldflt=[s.matcod:"+lv_matcod+"],[s.docsts:A],[stkobjcod:"+lv_objcod+"],[stkcntcod:"+lv_contact+"]");
        }
      }
		}

		$("#<?= $lv_sec; ?> #tmpmatsercod, #<?= $lv_sec; ?> #tmpmatsercodext").on("change",function(e) { 
			<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( $(this).data("row"), $(this).data("fldnme"), $(this).prop("value") );
		});
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
      	var lv_matuseser = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"matuseser")=="1";
				var lv_matcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row, "matcod");
        
				// esta linea es referenciada por otro documento
				var lv_docrefqty = false;
				var lv_docrefminqty = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"docrefminqty");
				if ( (lv_docrefminqty==null?"":lv_docrefminqty.toString())!="" ) { lv_docrefqty = true; }

				if (prop == "matsercodext") {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro || !lv_matcod || !lv_matuseser || lv_docrefqty ? lv_ro_color : lv_color);
					cellProperties.readOnly = (lv_ro || !lv_matcod || lv_docrefqty ? true : false);
				} else if (prop == "icn3" && lv_matuseser) {
          if (lv_matcod && !lv_docrefqty) {
            var lv_btn = "<div onclick='<?= $lv_sec; ?>_findSerial("+row+");' class='text-center cursor-pointer'><a href='#'><i class='fas fa-search'></i></a></div>";
            $(td).empty().append(lv_btn);
            $(td).addClass("text-center");
          } else {
            $(td).empty();
          }
          td.style.backgroundColor = lv_ro_color;
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
          if(prop == "stkmanreqmatatr"){
            td.style.backgroundColor = (lv_ro ? lv_ro_color:lv_color);
            cellProperties.readOnly = (lv_ro  ? true:false);
          }else{
            td.style.backgroundColor = (lv_ro || lv_docrefqty? lv_ro_color:lv_color);
            cellProperties.readOnly = (lv_ro || lv_docrefqty? true:false);
          }
				}
			}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #buyordmathot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly ?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->code; ?>", "<?= $vew_lang->material; ?>", "<?= $vew_lang->serialnumber; ?>"<?= (!$vew_readonly ? ',""':'') ?>, "Descripcion Averia" ],
			columns: [
				{type: "text", data: "matcod", width: 25, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
				{type: "autocomplete", data: "mattxt", width: 80, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
       				var lv_objcod = ($("#<?= $lv_sec; ?> #srcobjcod").val() == "" || $("#<?= $lv_sec; ?> #srcobjcod").val() == "0" ? $("#<?= $lv_sec; ?> #dstobjcod").val() : $("#<?= $lv_sec; ?> #srcobjcod").val());
              var lv_contact = ($("#<?= $lv_sec; ?> #srccntcod").val() == "" || $("#<?= $lv_sec; ?> #srccntcod").val() == "0" ? "0" : $("#<?= $lv_sec; ?> #srccntcod").val());
            if ( query.length>1 && <?= $lv_sec; ?>_hot_paste!=true ) {
							$.ajax({
								url: "?prg=stkmatstk&act=27", dataType: "json", data: { prm_mattxt: query, prm_stkobjtyp: $("#<?= $lv_sec; ?> #srcobjtyp").val(), prm_stkobjcod: lv_objcod, prm_stkcntcod: lv_contact, prm_sysdocclscod: <?= json_encode($lv_stkmatsysdocclscod); ?>  },
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
      	{type: "text", data: "matsercodext", width: 25, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },  
       	<?= (!$vew_readonly ? '{type: "text", data: "icn3", width: 8, renderer: '.$lv_sec.'_hotdoc_renderer, editor: false, readOnly: true },':''); ?>
        {type: "text", data: "stkmanreqmatatr", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
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
                <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matuseser", selectedItem.matuseser, 'autocomplete');
                <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matsercodext", "", 'autocomplete');
                <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matsercod", "", 'autocomplete');
              } else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          }
        }
      },
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["docrefsrcqty"]!="" && lv_dat[i]["docrefsrcqty"]!=undefined) {
						toastr.warning("No se pueden borrar posiciones que estan referenciadas por otros documentos.");
						return false;
					} else if ( lv_dat[i]["stkmanreqmatcod"]!="" && lv_dat[i]["stkmanreqmatcod"]!=undefined ) {
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

		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
				$lv_buffer='';
        if ( is_array($vew_data->stkmanreqmat) ) {
				foreach($vew_data->stkmanreqmat as $lv_row){
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
													'stkmanreqmatcod:"'.$lv_row['stkmanreqmatcod'].'",'.
													'matcod:"'.$lv_row['matcod'].'",'.
													'mattxt:`'.$lv_row['mattxt'].'`,'.
													'matsercod:`'.$lv_row['matsercod'].'`,'.
													'matsercodext:`'.$lv_row['matsercodext'].'`,'.
													'matuseser:`'.$lv_row['matuseser'].'`,'.
													($lv_row['refposqty']!=''?'docrefsrcqty: '.abs($lv_row['refposqty']-1).',':'').
													($lv_row['refposqty']!=''?'docrefminqty: '.$lv_row['refposqty'].',':'').
													'stkmanreqmatatr:`'.$lv_row['stkmanreqmatatr'].'`'.
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
    function <?= $lv_sec; ?>_GridRefresh(){ <?= $lv_sec; ?>_fnc({action: '99'}); }
    
		// SUBMIT. prepara los datos antes de grabar
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if ( lp_prm["action"]=="00" ) {
				// obtengo datos de handsontable
        var err = 0;
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
				var lv_arr_error = new Array();
				
        if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
        
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["mattxt"]!="" && lo_dat[i]["mattxt"]!=undefined ) {
            	if (lo_dat[i]["matuseser"]=="1" && (lo_dat[i]["matsercod"]==undefined || lo_dat[i]["matsercod"] == "")) {	
								lv_arr_error.push(i);
								//pintar las celdas de color rojo que esten dentro del array
								<?= $lv_sec; ?>_hotdoc.setCellMeta(i, <?= $lv_sec; ?>_hotdoc.propToCol("matsercodext"), "valid", false);
							}else{
            		lv_arr.push({	"stkmanreqmatcod":lo_dat[i]["stkmanreqmatcod"],
															"matcod":lo_dat[i]["matcod"],
															"mattxt":lo_dat[i]["mattxt"],
															"matsercod":lo_dat[i]["matsercod"],
															"stkmanreqmatatr":lo_dat[i]["stkmanreqmatatr"],
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
					lv_arr.push({	"stkmanreqmatcod":<?= $lv_sec; ?>_hotdocdel[i]["stkmanreqmatcod"],
												"deleted":"X"
											});
				}
          
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #stkmanreqmat").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #stkmanreqmat").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
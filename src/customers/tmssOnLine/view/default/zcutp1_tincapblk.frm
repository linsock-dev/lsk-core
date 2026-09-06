<?php
	/* url del formulario */
	$lv_lnk = "?prg=zcutp1_tmg";
	/* clave del documento */
	$lv_dockey = '';
	/* titulo */
	$lv_title = 'Carga masiva de capacitaciones';

	/* modulo y programa */
	$lv_mdlcod = 'DSH';
	$lv_prgcod = 'CAP';

	$vew_actcod = '01'; 

	/* libreria de estilos */
	include_once('_library.frm');

	/* Inicializar valores por defecto */
	if ( !is_array($vew_data) ) { $vew_data = array(); }
	if ( $vew_actcod == '01' ) {
		if ( empty($vew_data['capstrdte']) ) {
			$vew_data['capstrdte'] = date('d/m/Y');
		}
		if ( empty($vew_data['capenddte']) ) {
			$lv_enddte = new DateTime(date('Y-m-d'));
			$lv_enddte->modify('+1 year');
			$vew_data['capenddte'] = $lv_enddte->format('d/m/Y');
		}
	}

	/* campos requeridos */
	$vew_input->RequiredFields( array('hltcattxt', 'hltcatvalcod', 'capstrdte', 'crmcnttyptxt', 'crmcntmtvtxt', 'crmcnttxt', 'crmcntref', 'crmcntdsc') );

	/* botones */
	$vew_tbl['sveL'] = array('pos'=>'L', 'per'=>true);
	$vew_tbl['sveR'] = array('pos'=>'R', 'per'=>true);
	// Desactivamos impresión 
	$vew_tbl['prnR'] = array('per'=>false);
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <style>
    #<?= $lv_sec; ?> #crmcntdsc { resize: none; }
  </style>
	<?php include('zcutp_docfrmtlb.frm'); ?>

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod', 'hidden', '') ?>

		<div class="container-fluid" role="tabpanel">
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">

					<div class="row">
						<div class="col-md-12">
							<h4 class="text-primary"><strong><?= $lv_title; ?></strong></h4>
							<p class="text-muted">Permite registrar capacitaciones de prestadores y crear contactos de CRM de manera masiva.</p>
						</div>
					</div>

					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-header">
									<div class="card-title text-primary">1. Datos de capacitaci&oacute;n</div>
								</div>
								<div class="card-body tmss-card-body-edit">
									<div class="row">
										<div class="col-md-3">
											<?php echo vew_boot($lv_col1212, array(
												'label' => 'Grupo <span class="text-danger">*</span>',
												'input' => vew_boot(array('style'=>'search','readonly'=>$vew_readonly), array(
													'input' => gethtml('hltcattxt', 'typeahead', $vew_data['hltcattxt'] ?? '', array('atrval'=>array('css'=>'form-control', 'placeholder'=>'Seleccione un grupo...')))
												))
											)); ?>
											<?php echo gethtml('hltcatcod', 'hidden', $vew_data['hltcatcod'] ?? ''); ?>
										</div>
										<div class="col-md-3">
                        <?php echo vew_boot($lv_col1212, array(
                            'label' => 'Categor&iacute;a <span class="text-danger">*</span>',
                            'input' => '
                                <div class="dropdown">
                                    <button class="form-control dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" 
                                            style="text-align: left; width: 100%; background-color: #fff; height: 34px; position: relative;">
                                        <span id="cat_label" style="display: inline-block; width: 90%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">Seleccione las categor&iacute;as...</span> 
                                        <span class="caret" style="position: absolute; right: 10px; top: 14px;"></span>
                                    </button>
                                    <div class="dropdown-menu" id="cat_chk_container" onclick="event.stopPropagation();" 
                                         style="width: 100%; max-height: 200px; overflow-y: auto; padding: 10px; border: 1px solid #ccc; box-shadow: 0 6px 12px rgba(0,0,0,0.175);">
                                        <div class="text-muted" style="margin-top: 5px;">Seleccione un grupo primero...</div>
                                    </div>
                                </div>
                            '
                        )); ?>
                    </div>
										<div class="col-md-3">
											<?php echo vew_boot($lv_col1212, array(
												'label' => 'Fecha desde <span class="text-danger">*</span>',
												'input' => gethtml('capstrdte', 'docdte', $vew_data['capstrdte'] ?? '', array('atrval'=>array('css'=>'form-control', 'placeholder'=>'dd/mm/aaaa')))
											)); ?>
										</div>
										<div class="col-md-3">
											<?php echo vew_boot($lv_col1212, array(
												'label' => 'Fecha hasta',
												'input' => gethtml('capenddte', 'docdte', $vew_data['capenddte'] ?? '', array('atrval'=>array('css'=>'form-control tmssAlwaysDisabled', 'disabled'=>'disabled', 'placeholder'=>'dd/mm/aaaa'))) 
														 . '<span class="help-block"><small>Se calcula autom&aacute;ticamente a un a&ntilde;o</small></span>'
											)); ?>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>

					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-header">
									<div class="card-title text-primary">2. Datos para creaci&oacute;n de contacto CRM</div>
								</div>
								<div class="card-body tmss-card-body-edit">
									<div class="row">
										
										<div class="col-md-4">
											<?php echo vew_boot($lv_col1212, array(
												'label' => 'Tipo de contacto <span class="text-danger">*</span>',
												'input' => vew_boot(array('style'=>'search','readonly'=>$vew_readonly), array(
													'input' => gethtml('crmcnttyptxt', 'typeahead', $vew_data['crmcnttyptxt'] ?? '', array('atrval'=>array('css'=>'form-control', 'placeholder'=>'Seleccione un tipo...')))
												))
											)); ?>
											<?php echo gethtml('crmcnttypcod', 'hidden', $vew_data['crmcnttypcod'] ?? ''); ?>
											
											<?php echo vew_boot($lv_col1212, array(
												'label' => 'Motivo <span class="text-danger">*</span>',
												'input' => vew_boot(array('style'=>'search','readonly'=>$vew_readonly), array(
													'input' => gethtml('crmcntmtvtxt', 'typeahead', $vew_data['crmcntmtvtxt'] ?? '', array('atrval'=>array('css'=>'form-control', 'placeholder'=>'Seleccione un motivo...')))
												))
											)); ?>
											<?php echo gethtml('crmcntmtvcod', 'hidden', $vew_data['crmcntmtvcod'] ?? ''); ?>
										</div>

										<div class="col-md-4">
											<?php echo vew_boot($lv_col1212, array(
												'label' => 'T&iacute;tulo <span class="text-danger">*</span>',
												'input' => gethtml('crmcnttxt', 'doccmt1x50', $vew_data['crmcnttxt'] ?? '', array('atrval'=>array('css'=>'form-control', 'placeholder'=>'Ingrese el t&iacute;tulo...')))
											)); ?>

											<?php echo vew_boot($lv_col1212, array(
												'label' => 'Referencia <span class="text-danger">*</span>',
												'input' => gethtml('crmcntref', 'doccmt1x20', $vew_data['crmcntref'] ?? '', array('atrval'=>array('css'=>'form-control', 'placeholder'=>'Ingrese la referencia...')))
											)); ?>
										</div>

										<div class="col-md-4">
											<?php echo vew_boot($lv_col1212, array(
												'label' => 'Descripci&oacute;n <span class="text-danger">*</span>',
												'input' => gethtml('crmcntdsc', 'doccmt10x50', $vew_data['crmcntdsc'] ?? '', array('atrval'=>array('css'=>'form-control', 'rows'=>'5', 'style'=>'resize:none;', 'placeholder'=>'Ingrese la descripci&oacute;n...')))
											)); ?>
										</div>

									</div>
								</div>
							</div>
						</div>
					</div>

					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<div class="card-header">
									<div class="card-title text-primary">3. Selecci&oacute;n de prestadores</div>
								</div>
								<div class="card-body tmss-card-body-edit">
									<div class="row">
										<div class="col-md-6">
											<div class="alert alert-info" style="padding: 6px 12px; margin-bottom: 0; height: 34px; line-height: 1.5;">
												<i class="fas fa-info-circle"></i> Busque y seleccione los prestadores que desea incluir. Luego presione "Agregar".
											</div>
										</div>
										<div class="col-md-5">
											<?php echo vew_boot(array('style'=>'search','readonly'=>$vew_readonly), array(
												'input' => gethtml('prstxt', 'typeahead', '', array('atrval'=>array('css'=>'form-control', 'placeholder'=>'Buscar prestador...')))
											)); ?>
											<?php echo gethtml('prscod', 'hidden', ''); ?>
											<?php echo gethtml('prsdoctyp', 'hidden', ''); ?>
										</div>
										<div class="col-md-1">
											<button type="button" id="<?= $lv_sec; ?>_btnAddPrs" class="btn btn-primary btn-block"><i class="fas fa-plus"></i> Agregar</button>
										</div>
									</div>
									
									<div class="row">
										<div class="col-md-12">
											<div class="table-responsive border" style="margin-top: 15px;">
												<table class="table table-striped table-bordered table-hover m-0" id="<?= $lv_sec; ?>_tblPrs" style="margin-bottom: 0;">
													<thead>
														<tr>
															<th style="width: 60px;" class="text-center">N&ordm;</th>
															<th>C&oacute;digo prestador</th>
															<th>Prestador</th>
															<th>Tipo de prestador</th>
															<th>Estado</th>
															<th style="width: 40px;"></th>
														</tr>
													</thead>
													<tbody>
													</tbody>
												</table>
											</div>
											
											<div id="<?= $lv_sec; ?>_prs_empty_state" class="well text-center text-muted" style="margin-top: -1px; border-top-left-radius: 0; border-top-right-radius: 0;">
												<i class="fas fa-inbox fa-3x"></i>
												<p style="margin-top: 10px;">No hay registros agregados</p>
											</div>
										</div>
									</div>
									
								</div>
							</div>
						</div>
					</div>
				</div> 
			</div> 
		</div> 
	</form>

	<script>
 	// =========================================================
 	// TYPEAHEADS
 	// =========================================================
	// 1. HLT_CAT // GRUPO Y CARGA DE SELECT CATEGORÍA
	var lo_get_grp = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"docsts" : "A"},"fldasg" : {"hltcattxt" : "hltcattxt", "hltcatcod" : "hltcatcod"}}; 

  var lo_cbk_grp = {
      "afterAssign": function() {
          $("#<?= $lv_sec; ?> #hltcatcod").trigger("change");
      }
  };

	tmssTypeahead($("#<?= $lv_sec; ?> #hltcattxt"), "hltcat", lo_get_grp, lo_cbk_grp);

	// Cuando asigna el código oculto del Grupo, disparamos la búsqueda
    $("#<?= $lv_sec; ?> #hltcatcod").on("change", function(){
        var lv_hltcatcod = $(this).val();
        var $container = $("#<?= $lv_sec; ?> #cat_chk_container");

        // Resetear botón y contenedor de Categorías inmediatamente
        $("#<?= $lv_sec; ?> #cat_label").html("Seleccione las categor&iacute;as...");
        $container.empty().append('<div class="text-muted" style="margin-top: 5px;"><i class="fas fa-spinner fa-spin"></i> Cargando...</div>');
        
        if(!lv_hltcatcod || lv_hltcatcod === ""){
            $container.empty().append('<div class="text-muted" style="margin-top: 5px;">Seleccione un grupo primero...</div>');
            return;
        }
        
        tmssCallProcessNoBackdropErr("?prg=hltcat&act=28&prm_hltcatcod=" + lv_hltcatcod, [], function(res){
            $container.empty(); 
            var catlst = res.data || res;
            if(catlst && catlst.length > 0){
                $.each(catlst, function(index, item){
                    $container.append(
                        '<div class="checkbox" style="margin-top: 2px; margin-bottom: 2px;">' +
                            '<label style="font-weight: normal; cursor: pointer;">' +
                                '<input type="checkbox" name="hltcatvalcod[]" value="' + item.hltcatvalcod + '"> ' + item.hltcatval +
                                '<input type="hidden" name="hltcatvaltxt[' + item.hltcatvalcod + ']" value="' + item.hltcatval + '">' +
                            '</label>' +
                        '</div>'
                    );
                });
            } else {
                $container.append('<div class="text-muted" style="margin-top: 5px;">Sin categorías disponibles</div>');
            }
        });
    });

    // Limpieza
    $("#<?= $lv_sec; ?> #hltcattxt").on("keyup", function(){
        if($(this).val() === "") {
            $("#<?= $lv_sec; ?> #hltcatcod").val("").trigger("change");
        }
    });
    // Actualizar el texto del botón de categorías según la selección
    $("#<?= $lv_sec; ?> #cat_chk_container").on("change", "input[name='hltcatvalcod[]']", function() {
        var $chks = $("#<?= $lv_sec; ?> #cat_chk_container input[name='hltcatvalcod[]']:checked");
        var lv_txt = "Seleccione las categor&iacute;as..."; 

        if ($chks.length === 1) {
            lv_txt = $chks.closest('label').text().trim();
        } else if ($chks.length > 1) {
            lv_txt = $chks.length + " categor&iacute;as seleccionadas";
        }

        // Usamos .html() para que procese el &iacute;
        $("#<?= $lv_sec; ?> #cat_label").html(lv_txt);
    });

	// 3. CRM_CNT_TYP // TIPO DE CONTACTO CRM 
    // Función de limpieza 
    var lo_afterAssignTyp = function() {
        $("#<?= $lv_sec; ?> #crmcntmtvtxt").val(""); 
        $("#<?= $lv_sec; ?> #crmcntmtvcod").val("");
    }; 

    var lo_get_typ = {
        "fldsec" : "<?= $lv_sec; ?>",
        "fldflt" : {"docsts" : "A", "crmcnttypcod" : "(in)<?= str_replace(',', ';', $vew_data['crmcnttyp']) ?>"}, 
        "fldasg" : {"crmcnttyptxt" : "crmcnttyptxt", "crmcnttypcod" : "crmcnttypcod"}
    }; 

    tmssTypeahead($("#<?= $lv_sec; ?> #crmcnttyptxt"), "crmcnttyp", lo_get_typ, {"afterAssign" : lo_afterAssignTyp});

    // Limpieza manual
    $("#<?= $lv_sec; ?> #crmcnttyptxt").on("keyup change", function(){
        if($(this).val() === "") {
            $("#<?= $lv_sec; ?> #crmcnttypcod").val("");
            lo_afterAssignTyp();
        }
    });

	// 4. CRM_CNT_MTV // MOTIVO CONTACTO CRM (HIJO)
	var lo_get_mtv = {
	  "fldsec" : "<?= $lv_sec; ?>", 
	  "fldflt" : {
	    "m.docsts" : "A", 
	    "m.crmcnttypcod": $("#<?= $lv_sec; ?> #crmcnttypcod") 
	  }, 
	  "fldasg" : {"crmcntmtvtxt" : "crmcntmtvtxt", "crmcntmtvcod" : "crmcntmtvcod"}
	}; 
	tmssTypeahead($("#<?= $lv_sec; ?> #crmcntmtvtxt"), "crmcntmtv", lo_get_mtv);

 	// 5. PRESTADORES
    var lo_get_prs = {
        "fldsec" : "<?= $lv_sec; ?>", 
        "fldflt" : {
            "p.docsts" : "A"
            <?php if (!empty($vew_data['prsclscodlst'])): ?>
            , "p.sysdocclscod" : "(in)<?= str_replace(',', ';', $vew_data['prsclscodlst']) ?>"
            <?php endif; ?>
        }, 
        "fldasg" : { "prstxt" : "prstxt", "prscod" : "prscod" }
    }; 
    
    var lo_cbk_prs = {
        "afterAssign": function() {
            var lv_prscod = $("#<?= $lv_sec; ?> #prscod").val();
            var lv_prstxt = $("#<?= $lv_sec; ?> #prstxt").val();
            
            if (!lv_prscod || lv_prscod === "" || !lv_prstxt || lv_prstxt === "") {
                return;
            }
            $("#<?= $lv_sec; ?> #prsdoctyp").val("Cargando...");
            var lv_url = "?prg=hltprs&act=18&prm_prstxt=" + encodeURIComponent(lv_prstxt);
            tmssCallProcessNoBackdropErr(
                lv_url, 
                [],
                function(res) {
                    var lv_list = (res.data || res);
                    if (!Array.isArray(lv_list)) { lv_list = [lv_list]; }
                    var lv_clstxt = "-";
                    for (var i = 0; i < lv_list.length; i++) {
                        if (lv_list[i].prscod == lv_prscod || lv_list[i]["p.prscod"] == lv_prscod) {
                            lv_clstxt = lv_list[i].sysdocclstxt || lv_list[i].sysdocsistxt || "-";
                            break; 
                        }
                    }
                    $("#<?= $lv_sec; ?> #prsdoctyp").val(lv_clstxt);
                    setTimeout(function() {
                        $("#<?= $lv_sec; ?>_btnAddPrs").focus();
                    }, 300);
                }
            );
        }
    };
    
    tmssTypeahead($("#<?= $lv_sec; ?> #prstxt"), "hltprs", lo_get_prs, lo_cbk_prs);

    // Limpieza manual del buscador de prestadores
    $("#<?= $lv_sec; ?> #prstxt").on("keyup change", function() {
        if($(this).val() === "") {
            $("#<?= $lv_sec; ?> #prscod, #<?= $lv_sec; ?> #prsdoctyp").val("");
        }
    });

 	// =========================================================
	// EVENTOS Y VALIDACIONES DE LA TABLA
	// =========================================================
 
	$(document).ready(function() {
	    
	    // Calcular fecha hasta (+1 año)
	    $("#<?= $lv_sec; ?> #capstrdte").on("change", function() {
	        var lv_dte = $(this).val();
	        if(lv_dte && lv_dte.length === 10) {
	            var lv_prts = lv_dte.split('/');
	            var lv_fch = new Date(lv_prts[2], lv_prts[1] - 1, lv_prts[0]);
	            lv_fch.setFullYear(lv_fch.getFullYear() + 1);
	            var lv_dy = ("0" + lv_fch.getDate()).slice(-2);
	            var lv_mo = ("0" + (lv_fch.getMonth() + 1)).slice(-2);
	            var lv_yr = lv_fch.getFullYear();
	            $("#<?= $lv_sec; ?> #capenddte").val(lv_dy + "/" + lv_mo + "/" + lv_yr);
	        }
	    });
	    // --- TABLA PRESTADORES ---
	    // Única función que controla la UI de la tabla
	    function fnc_renderTableUI() {
	        var $tbody = $("#<?= $lv_sec; ?>_tblPrs tbody");
	        var $rows = $tbody.find("tr");
	        
	        // 1. Mostrar/Ocultar el estado vacío
	        if ($rows.length > 0) {
	            $("#<?= $lv_sec; ?>_prs_empty_state").hide();
	        } else {
	            $("#<?= $lv_sec; ?>_prs_empty_state").show();
	        }
	        
	        // 2. Renumerar las filas correctamente 
	        $rows.each(function(index) {
	            $(this).find("td:first").text(index + 1);
	        });
	    }

	    // Evento: Agregar Prestador
	    $("#<?= $lv_sec; ?>_btnAddPrs").on("click", function() {
	        var lv_prscod = $("#<?= $lv_sec; ?> #prscod").val();
	        var lv_prstxt = $("#<?= $lv_sec; ?> #prstxt").val();
	        var lv_doctyp = $("#<?= $lv_sec; ?> #prsdoctyp").val() || "-";
            
	        if (!lv_prscod || !lv_prstxt) {
	            toastr.warning("Busque y seleccione un prestador valido de la lista.");
	            return;
	        }
	        // Verificar duplicados
	        var lv_exists = false;
	        $("#<?= $lv_sec; ?>_tblPrs tbody input[name='tbl_prscod[]']").each(function() {
	            if ($(this).val() === lv_prscod) { lv_exists = true; }
	        });

	        if (lv_exists) {
	            toastr.warning("El prestador ya se encuentra en la tabla.");
	            return;
	        }

	        // Crear nueva fila
	        var lv_newrow = `
	            <tr>
	                <td class="text-center"></td> <td>${lv_prscod}<input type="hidden" name="tbl_prscod[]" value="${lv_prscod}"></td>
	                <td>${lv_prstxt}</td>
	                <td>${lv_doctyp}</td>
	                <td>ACTIVO</td>
	                <td class="text-center">
	                    <button type="button" class="btn btn-xs btn-default text-danger btnRemovePrs" title="Eliminar">
	                        <i class="fas fa-trash-alt"></i>
	                    </button>
	                </td>
	            </tr>
	        `;
	        // Agregar al DOM y actualizar UI
	        $("#<?= $lv_sec; ?>_tblPrs tbody").append(lv_newrow);
	        fnc_renderTableUI();

	        // Limpiar el input visible del typeahead 
          $("#<?= $lv_sec; ?> #prstxt").val("").typeahead('val', '').trigger('change').focus();
          $("#<?= $lv_sec; ?> #prscod").val("");
          $("#<?= $lv_sec; ?> #prsdoctyp").val("");

	    });

	    // Evento: Eliminar Prestador
	    $("#<?= $lv_sec; ?>_tblPrs").on("click", ".btnRemovePrs", function() {
	        $(this).closest("tr").remove(); // Borra la fila
	        fnc_renderTableUI();            // Re-evalúa la tabla
	    });

	    // Ejecución inicial
	    fnc_renderTableUI();
	});

  function <?= $lv_sec; ?>_fncbckext(data) {
      if (!tmssBackMessageProcessing(data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "")) return;
      var lv_is_json = (typeof data === 'object') || (typeof data === 'string' && data.trim().startsWith('{'));

      // 3. Si la acción es la de guardado, procesamos el resultado JSON
      if (["hltcapblksve", "00"].includes(gv_<?= $lv_sec; ?>_last_action) && lv_is_json) {
          var lo_json = (typeof data === 'string') ? JSON.parse(data) : data;

          // Mapeo directo: letra a función de toastr
          var lv_toastrType = {'S': 'success', 'I': 'info', 'W': 'warning', 'E': 'error'}[lo_json.errtyp];
          if (lv_toastrType) toastr[lv_toastrType](lo_json.errtxt);
          // 4. Refresh de vista
          setTimeout(function() {
              tmssCallProcessNoBackdrop("?prg=zcutp1_tmg&act=hltcapblk", [], function(lv_html_res) {
                  $("#<?= $lv_sec; ?>").replaceWith(lv_html_res);
              });
          }, 2500);
      } 
      else if (!lv_is_json) {
          $("#<?= $lv_sec; ?>").replaceWith(data);
      }
  }

 	function <?= $lv_sec; ?>_fncext(lp_prm) {
    if (lp_prm["action"] == "99") {
        tmssCallProcessNoBackdrop("?prg=zcutp1_tmg&act=hltcapblk", [], function(htmlrsp) {
            $("#<?= $lv_sec; ?>").replaceWith(htmlrsp);
          	toastr.info("Documento actualizado.");
        });
        return false; 
    }
    if (lp_prm["action"] == "00") {
        if ( tmssCheckRequiredFields( $("#<?= $lv_sec; ?>_frm") ) == false ) { return false; }
        if ($("#<?= $lv_sec; ?>_tblPrs tbody tr").length === 0) {
            toastr.warning("Agregue al menos un prestador a la tabla.");
            return false;
        }
        lp_prm["action"] = "hltcapblksve"; 
    }
    return true;
}
</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
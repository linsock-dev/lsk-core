<?php
	// url del formulario 
  $lv_lnk = "?prg=grldattsk&prm_tskcod=".$vew_data->tskcod;

	// campos requeridos
	$vew_input->RequiredFields( array('tsktxt','tskurl','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->tskcod;

	// titulo
	$lv_title = $vew_lang->scheduletask;

	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'TSK';

	// librer?a de estilos bootstrap
	include_once('_library.frm');

	$lv_inturl = $vew_doc->getTagValue($vew_data->grldattskatr,'int_url');
	$vew_data->log = ($vew_data->log ?? "") == "" ? [] : $vew_data->log;

  $vew_tbl['cpy']  = array('per'=>false);

	// MAILS DE ERROR. se guardan dentro de tskatr bajo la clave 'errormail'.
	// Se extraen para mostrarlos en su campo propio y no en la grilla de parámetros.
	$lv_erreml = '';
	$lv_atrlst = json_decode( html_entity_decode($vew_data->tskatr ?? '[]', ENT_QUOTES, 'UTF-8'), true );
	if ( is_array($lv_atrlst) ) {
		foreach ( $lv_atrlst as $lv_pair ) {
			if ( is_array($lv_pair) && array_key_exists('errormail', $lv_pair) ) { $lv_erreml = $lv_pair['errormail']; }
		}
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<style>
		/* URL: más alto para ver URLs largas y redimensionable sólo en vertical */
		#<?= $lv_sec; ?> #tskurl { min-height: 90px; resize: vertical; }
	</style>
	<?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('tskfrqatr','hidden',''); ?>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->tskcod; ?><?= gethtml('tskcod','hidden',$vew_data->tskcod); ?></strong></h4></li>
      </ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
						
							<div class="card">
								<div class="card-header">
									<div class="card-title"><?= $vew_lang->scheduletask; ?>
										<?php if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'10') && $vew_readonly){?><span class="pull-right"><a href="#" class="btn btn-success btn-sm" id="btnexe"><i class="far fa-flag"></i> <?= $vew_lang->execute; ?></a></span><?php } ?>
									</div>
								</div>
								<div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('tskcodext', 'doccmt1x20', $vew_data->tskcodext, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('tsktxt', 'doccmt1x50',	$vew_data->tsktxt, $lv_default) ));
                  ?> 
                  <div class="form-group tmss-form-group">
                    <label class="col-sm-2 control-label"><?= $vew_lang->frequency; ?></label>
                    <a href="#" id="frqschbtn" class="col-sm-10 control-label"><span id="frqtxt">Configuraci&oacute;n</span></a>
                  </div>
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
								</div>
							</div>
							
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->parameters; ?></div></div>
              	<div class="card-body">
									<?= vew_boot($lv_col210, array('label'=>'URL', 'input'=>gethtml('tskurl', 'doccmt1x400', $vew_data->tskurl, $lv_default))); ?>
									<?= vew_boot($lv_col210, array('label'=>'Mails de error', 'input'=>gethtml('tskerreml', 'doccmt1x400', $lv_erreml, $lv_default))); ?>
									<div class="form-group tmss-form-group"><div class="col-sm-offset-2 col-sm-10"><small class="text-muted">Separar varias direcciones con punto y coma (;). Vac&iacute;o = no se env&iacute;an mails de error.</small></div></div>
                  <?= vew_boot($lv_col210, array('label'=>'POST','input'=>'<div id="grldattskatrhot" name="grldattskatrhot"></div>')); ?>
									<textarea id="tskatr" name="tskatr" class="hidden"></textarea>
                </div>
              </div>
							
						</div><!-- /col-md-6 -->
						<div class="col-md-6">
							
							<!-- LOG EJECUCION -->
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->log; ?></div></div>
								<div class="card-body tmss-card-body-edit">
									<table class="table table-condensed">
										<thead><tr><th width="150"><?= $vew_lang->date; ?></th><th width="50"><?= $vew_lang->type; ?></th><th width="50"><?= $vew_lang->code; ?></th><th><?= $vew_lang->description; ?></th></tr></thead>
										<tbody>
											<?php
											
												foreach($vew_data->log as $lv_row){
                          $lv_loginf = json_decode(html_entity_decode($lv_row['applogtecinf'] ?? '', ENT_QUOTES, 'UTF-8'), true, 512, JSON_INVALID_UTF8_SUBSTITUTE);
													if (is_array($lv_loginf) && isset($lv_loginf['errtyp'])) { echo '<tr class="'.($lv_loginf['errtyp']=='E'?'danger':($lv_loginf['errtyp']=='W'?'warning':'')).'">'.
														'<td>'.date_format($lv_row['ctedte'],'d/m/Y H:i').'</td>'.
														'<td>'.$lv_loginf['errtyp'].'</td>'.
														'<td>'.$lv_loginf['errcod'].'</td>'.
														'<td>'.$lv_loginf['errmsg'].'</td>'.
															'</tr>';
													} else {
														// JSON no decodificable: vuelco el contenido crudo en la columna descripción
														echo '<tr class="warning">'.
															'<td>'.date_format($lv_row['ctedte'],'d/m/Y H:i').'</td>'.
															'<td></td>'.
															'<td></td>'.
															'<td><pre style="white-space:pre-wrap;word-break:break-all;margin:0">'.htmlspecialchars((string)($lv_row['applogtecinf'] ?? ''), ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8').'</pre></td>'.
															'</tr>';
													}
													/* FIN BLOQUE LOG */ 
												}
											?>
										</tbody>
									</table>
								</div>
							</div>
							
						</div>
					</div>
				</div> <!-- /tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
    // AÑADIR FRECUENCIA
    $("#<?= $lv_sec; ?> #frqschbtn").on("click",function(e){ e.preventDefault();
      <?= $lv_sec; ?>_openDialog(null);
    });
    
		// CHECK FREQUENCIA
    function <?= $lv_sec; ?>_validateFrequencyConfig(lv_frqcfg){
      // función para formatear fechas
      function parseDateTime(lp_dte, lp_tme){
        if(!lp_dte || !lp_tme) return null;
        let lv_sptdte = lp_dte.split("/");
        return new Date( lv_sptdte[2], lv_sptdte[1]-1, lv_sptdte[0], lp_tme.split(":")[0], lp_tme.split(":")[1] );
      }

      /* ===== VALIDACIONES ===== */

      // inicio
      if(!lv_frqcfg.strdte || !lv_frqcfg.strtme)
        return "Debe indicar fecha y hora de inicio.";

      let lv_strdte = parseDateTime(lv_frqcfg.strdte, lv_frqcfg.strtme);
      if(lv_strdte < new Date())
        return "La fecha/hora de inicio no puede ser anterior a la actual.";

      // frecuencia
      if(["D","W","M"].includes(lv_frqcfg.frqtyp)){
        if(!lv_frqcfg.frqqty || parseInt(lv_frqcfg.frqqty,10) <= 0)
          return "El valor de frecuencia debe ser mayor a 0.";
      }

      // repetición
      if(lv_frqcfg.frqtmeqty){
        if(!lv_frqcfg.frqstrtme || !lv_frqcfg.frqendtme)
          return "Debe indicar horario de inicio y fin para la repetición.";

        if(lv_frqcfg.frqstrtme >= lv_frqcfg.frqendtme)
          return "El horario de inicio de repetición debe ser menor al de fin.";
      }

      // semanal
      if(lv_frqcfg.frqtyp === "W"){
        if(!lv_frqcfg.wekday || lv_frqcfg.wekday === "0000000")
          return "Debe seleccionar al menos un día de la semana.";
      }

      // mensual
      if(lv_frqcfg.frqtyp === "M" && lv_frqcfg.daynum){
        let d = parseInt(lv_frqcfg.daynum,10);
        if(d <= 0 || d > 31)
          return "El día del mes debe estar entre 1 y 31.";
      }

      // fin
      if (lv_frqcfg.frqtyp !== "U"){
        if(!lv_frqcfg.enddte || !lv_frqcfg.endtme)
          return "Debe indicar fecha y hora de finalización.";

        let lv_enddte = parseDateTime(lv_frqcfg.enddte, lv_frqcfg.endtme);
        if(lv_enddte < new Date())
          return "La fecha de finalización no puede ser anterior a la actual.";

        if(lv_enddte <= lv_strdte)
          return "La fecha de finalización debe ser posterior a la de inicio.";
      }

      return null; // OK
    }

    
    // DIALOG FRECUENCIAS
    function <?= $lv_sec; ?>_openDialog(){
      var lv_cfg = {};
      lv_cfg["frq"] = ["U","D", "W", "M"];
			lv_cfg["tmetyp"] = "TF";
      //lv_cfg["dtetyp"] = "DS";
      lv_cfg["readonly"] = <?= $vew_readonly ? 'true' : 'false' ?>;
      // si el usuario cambio los datos de frecuencia y no grabó, se los paso igual. Si no, le paso los grabados en la base
      let lv_prv = null;
      const lv_rawfrqatr = $("#<?= $lv_sec; ?> #tskfrqatr").val();

      if (lv_rawfrqatr) {
        lv_prv = lv_rawfrqatr;
      } else {
        lv_prv = '<?= html_entity_decode($vew_data->tskfrqatr); ?>';
      }

			var lv_pstdat =[{name:"cfg", value: JSON.stringify(lv_cfg)},
											{name:"srcobjtyp", value:"<?=$lv_mdlcod.'_'.$lv_prgcod?>"},
											{name:"srcobjcod001", value:"<?=$vew_data->tskcod?>"},
                     	{name:"tskfrqatr", value:lv_prv},
                     	{name:"actcod", value:'<?=$vew_actcod?>'}];
			tmssCallProcess("?prg=grldattsk&act=sch",lv_pstdat,function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->frequency; ?>",
					message: $(data),
					type: BootstrapDialog.TYPE_PRIMARY,
          closable: true,
          draggable: true,
         	buttons: [{label: "<?=$vew_lang->cancel ?>", cssClass: "btn-warning", action: function(dialog){ dialog.close(); } },
                    {label: "<?= $vew_lang->accept ?>", cssClass: "btn-success",	action: function(dialog){
                      dialog.$modalBody.find("#btnsubmit").trigger("click");

                      let lv_frm = dialog.$modalBody.find('form[name="tskschfrm"]');
                      if(!lv_frm.length) return;

                      let lv_json = lv_frm.find("#grldattsk").val();
                      if(!lv_json){
                        toastr.warning("No se pudo generar la configuración de la tarea.");
                        return;
                      }

                      let lv_frqcfg = {};
                      try{
                        lv_frqcfg = JSON.parse(lv_json);
                      }catch(e){
                        toastr.warning("Configuración inválida.");
                        return;
                      }
                      
                      let lv_err = <?= $lv_sec; ?>_validateFrequencyConfig(lv_frqcfg);
                      if(lv_err){
                        toastr.warning(lv_err);
                        return;
                    	}
                      /* ===== OK ===== */ $("#<?= $lv_sec; ?> #tskfrqatr").val(lv_json); dialog.close();
                    }
          				}
                 ]   
        });
      });
    }
    
    //insertar frecuencia
    /*function <?= $lv_sec; ?>_insertFrequency(lp_tskcod,lp_tsktxt){
      let lv_tskfrqatr = JSON.parse( $("#vew_1765562989693c5a6d55958 #tskfrqatr").val() );
      $("#frqlst").append("<div class='form-group tmss-form-group grldattskfrq'>"
                    +"<div class='col-xs-1 <?=($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02')?'':'hidden');?>'><input type='checkbox'></div>"
                   	+"<a href='#' class='col-xs-11' data-tskcod='"+lp_tskcod+"'>"+lp_tsktxt+" </a>"
										+"</div>");
    }*/
    
		// EJECUTAR
		$("#<?= $lv_sec; ?> #btnexe").on("click", function (e) {
      e.preventDefault();

      // si no hay URL definida no permito la ejecución
      const lv_url_raw = $("#<?= $lv_sec; ?> #tskurl").val();
      if (!lv_url_raw) { toastr.warning("No hay URL definida; no se puede ejecutar la tarea.", "Error de Configuración"); return; }

      // parseo correcto de la URL (base = origin actual para soportar URLs relativas tipo "?prg=...&act=...")
      const lv_url_obj = new URL(lv_url_raw, window.location.origin);
			const lv_url = lv_url_obj.searchParams;
      // parámetros definidos en la HOT
      let lv_prm = {};
      let lv_rws = <?= $lv_sec; ?>_hotatr.getSourceData().filter(r => (r.intatrcod ?? "") !== "");
			lv_rws.forEach(r => { lv_prm[r.intatrcod.toLowerCase()] = r.intatrval ?? "";  });

      // agrego automáticamente el resto de parámetros de la URL
      lv_url.forEach((value, key) => {
          if (key.toUpperCase() !== "PRG" && key.toUpperCase() !== "ACT") {
              lv_prm[key.toLowerCase()] = value;
          }
      });

      // payload final
      const lv_pstdat = [
        { name: "prg", value: (lv_url.get("PRG") ?? "").toLowerCase() },
        { name: "act", value: (lv_url.get("ACT") ?? "").toLowerCase() },
        { name: "prm", value: JSON.stringify(lv_prm) }
      ];
      
      // tskcod SOLO si existe
      const lv_tskcod = <?= json_encode($vew_data->tskcod ?? null) ?>;
      if (lv_tskcod !== null) {
        lv_pstdat.push({ name: "tskcod", value: lv_tskcod });
      }

      tmssCallProcess("?prg=grldattsk&act=executetask", lv_pstdat, function (data) {
        // normalizo: si el framework devuelve string, intento parsear
        if (typeof data === 'string') { try { data = JSON.parse(data); } catch(e) {} }
        const lv_errtyp = (data && data.errtyp) || 'E';
        const lv_errtxt = (data && data.errtxt) || 'Sin respuesta del servidor.';
        if (lv_errtyp === 'S')      { toastr.success(lv_errtxt); }
        else if (lv_errtyp === 'W') { toastr.warning(lv_errtxt); }
        else                        { toastr.error(lv_errtxt); }
      });
    });

	</script>
	<script>
		var <?= $lv_sec; ?>_hotatr_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
		};
		var <?= $lv_sec; ?>_hotatrcnt = $("#<?= $lv_sec; ?> #grldattskatrhot")[0];
		var <?= $lv_sec; ?>_hotatrset = {
			height: 396,
			formulas: false,
			stretchH: "all",
			autoWrapRow: true,
			rowHeaders: false,
			colHeaders: [ "<?= $vew_lang->name; ?>", "<?= $vew_lang->value; ?>" ],
			columns: [
				{	type: "text", data: "intatrcod", width: 50, renderer: <?= $lv_sec; ?>_hotatr_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
				{	type: "text", data: "intatrval", width: 50, renderer: <?= $lv_sec; ?>_hotatr_renderer <?= ($vew_readonly?', readOnly: true':''); ?> }
			],
			minSpareRows: <?= ($vew_readonly?'0':'1'); ?>,
			startRows: 1,
			startCols: 1
		};
		var <?= $lv_sec; ?>_hotatr;

		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotatr = new Handsontable(<?= $lv_sec; ?>_hotatrcnt, <?= $lv_sec; ?>_hotatrset);
			var lv_dat = [<?php
				$lv_sdat = json_decode($vew_data->tskatr, true);
				$lv_buffer = '';
        if ($lv_sdat){
          foreach ($lv_sdat as $lv_row){
            foreach($lv_row as $lv_nme=>$lv_val){
              // errormail no es un parámetro: se edita en su campo dedicado, no en la grilla
              if ( strtolower($lv_nme)=='errormail' ) { continue; }
              $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                          'intatrcod:"'.$lv_nme.'",'.
                          'intatrval:"'.$lv_val.'"}';
            }
        	}
        }
        echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotatr.loadData( lv_dat );
			<?= $lv_sec; ?>_hotatr.render();
		});
	</script>
  <script>
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if(lp_prm["action"]=="10"){
				BootstrapDialog.confirm({
					title: "Ejecutar Interfaz",
					message:"Desea ejecutar la interfaz ahora ?",
					type: BootstrapDialog.TYPE_WARNING,
					callback: function(result){
						if(result){
							var lv_pstdat = [];
							tmssCallProcess( "<?= $vew_data->grldattskurl; ?>",lv_pstdat,function(data){
								if( typeof data=="string" ){
									if(data.substr(0,10)=="/*script*/"){
										eval(data);
									} else {
										var lv_tmptab = $("#pageTabContent > .tab-pane.active > .tab-frame:last");
										$(lv_tmptab).find("> section").each( function() { $(this).hide(); });
										$(lv_tmptab).append(data);
										return false;
									}
								} else {
									if(data.errcod=="0") {
										toastr.info("Interfaz ejecutada.");
										<?= $lv_sec; ?>_fnc({action: "03"});
									} else {
										toastr.warning("Error al ejecutar la interfaz:<br>"+data.errcod+": "+data.errtxt);
										$("#<?= $lv_sec; ?> #btnrun").prop("readonly","").removeClass("disabled").find("span:first").addClass("fa-play").removeClass("fa-spinner fa-spin fa-fw");
									}
								}									
							});
							
							//$("#<?= $lv_sec; ?> #btnrun").prop("readonly","readonly").addClass("disabled").find("span:first").removeClass("fa-play").addClass("fa-spinner fa-spin fa-fw");
							//toastr.info("La interfaz se está ejecutando.");
							return;
						}
					}
				});
				return false;
			}
      
      // Pasa a minúscula las claves del JSON para evitar errores.
      function <?= $lv_sec; ?>_tmss_jsonKeysToLower(lp_obj) {
        if (Array.isArray(lp_obj)) { return lp_obj.map(<?= $lv_sec; ?>_tmss_jsonKeysToLower); }

        if (lp_obj !== null && typeof lp_obj === "object") {
          return Object.keys(lp_obj).reduce((acc, key) => {
            acc[key.toLowerCase()] = <?= $lv_sec; ?>_tmss_jsonKeysToLower(lp_obj[key]);
            return acc;
          }, {});
        }

        return lp_obj;
      }

      if (lp_prm["action"] == "00") {
        var lo_dat = <?= $lv_sec; ?>_hotatr.getSourceData();
        var lv_buf = [];
				
        // recupero el JSON guardado desde el schedule. Si no se abrió el mismo, utilizo la frecuencia cargada desde el backend
        let lv_json = $("#<?= $lv_sec; ?> #tskfrqatr").val();
        if(!lv_json) {
          lv_json = '<?= $vew_data->tskfrqatr; ?>';
          if(!lv_json || lv_json=="[]"){
            toastr.warning("No se pudo generar la configuración de la tarea.");
            return;
          }
          // lo agrego al DOM
          $("#<?= $lv_sec; ?> #tskfrqatr").val(lv_json);
        }

        let lv_frqcfg = {};
        try{
          lv_frqcfg = <?= $lv_sec; ?>_tmss_jsonKeysToLower( JSON.parse(lv_json) );
        }catch(e){
          toastr.warning("Configuración de frecuencia inválida.");
          e.preventDefault();
          return false;
        }

        let lv_err = <?= $lv_sec; ?>_validateFrequencyConfig(lv_frqcfg);
        if(lv_err){
          toastr.warning(lv_err);
          e.preventDefault();
          return false;
        }

        for (var i = 0; i < lo_dat.length; i++) {
          if ( lo_dat[i]["intatrcod"] !== "" && lo_dat[i]["intatrcod"] !== null && lo_dat[i]["intatrcod"] !== undefined ) {
            lv_buf.push({ [lo_dat[i]["intatrcod"]]: lo_dat[i]["intatrval"] });
          }
        }

        // MAILS DE ERROR. se guardan dentro de tskatr bajo la clave 'errormail', no como
        // parámetro. Se quita lo que pueda haber quedado en la grilla y se agrega el campo.
        lv_buf = lv_buf.filter(function(o){ return !Object.keys(o).some(function(k){ return k.toLowerCase() === "errormail"; }); });
        var lv_erreml = ($("#<?= $lv_sec; ?> #tskerreml").val() || "").trim();
        if (lv_erreml !== "") { lv_buf.push({ errormail: lv_erreml }); }

        $("#<?= $lv_sec; ?> #tskatr").text(JSON.stringify(lv_buf));
      }
		}
  </script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
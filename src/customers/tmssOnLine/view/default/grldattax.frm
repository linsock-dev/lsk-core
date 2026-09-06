<div class="card">
  <div class="card-header">
    <div class="card-title">
      <?= $vew_lang->taxes; ?>
    </div> 
  </div>    
	
    <?php if($vew_readonly){ ?>
    <div class="card-body tmss-card-body-edit">
			<!-- Modo lectura -->
			<input type="hidden" id="taxnum" name="taxnum" value="<?= $vew_data->tax->taxnum; ?>">
			<input type="hidden" id="taxcattxt" name="taxcattxt" value="<?= $vew_data->tax->taxcattxt; ?>">
			<input type="hidden" id="taxcatcod" name="taxcatcod" value="<?= $vew_data->tax->taxcatcod; ?>">
			<input type="hidden" id="idttypcod" name="idttypcod" value="<?= $vew_data->tax->taxdoctyp; ?>">
      <input type="hidden" id="idttyptxt" name="idttyptxt" value="<?= $vew_data->tax->idttyptxt; ?>">
			<input type="hidden" id="taxcod001" name="taxcod001" value="<?= $vew_data->tax->taxcod; ?>">
			<input type="hidden" id="taxcod002" name="taxcod002" value="<?= $vew_data->tax->taxiibb; ?>">
			<input type="hidden" id="taxactstr" name="taxactstr" value="<?= ($vew_data->tax->taxactstr !='') ? $vew_data->tax->taxactstr->format("d/m/Y"):''; ?>">
			<?php
				$lv_tax = ($vew_data->tax->taxcattxt!=''?'<label>'.$vew_lang->fiscalcategory.'</label><div>'.$vew_data->tax->taxcattxt.'</div>':'');
        $lv_taxtxt = '';
        if($vew_data->tax->taxcod == '' || $vew_data->tax->taxiibb == ''){
          if($vew_data->tax->taxcod == ''){
            if($vew_data->tax->taxiibb == ''){
              $lv_taxtxt = '';
            }else{
              $lv_taxtxt = $vew_data->tax->taxiibb;
            }
          }else{
            $lv_taxtxt = $vew_data->tax->taxcod;
          } 
        }else{
          $lv_taxtxt = $vew_data->tax->taxcod.' / '.$vew_data->tax->taxiibb;
        }
        $lv_tax .= ($vew_data->tax->idttyptxt=='' || $lv_taxtxt==''?'':'<label>'.$vew_lang->taxcode.' general</label><div>'.$vew_data->tax->idttyptxt.': '.$lv_taxtxt.'</div>');
				$lv_tax .= ($vew_data->tax->taxactstr!=''?'<label>'.$vew_lang->startactivities.'</label><div>'.($vew_data->tax->taxactstr)->format('d/m/Y').'</div>':'');				
      	echo (($lv_tax == '')?'(Sin informaci&oacute;n)':'<strong>'.utf8_encode($lv_tax).'</strong>');
			?>
    </div> 
    <?php } else { ?>
  	<div class="card-body tmss-card-body-edit">
  		<!-- Modo edición -->
      <?php 
				echo vew_boot($lv_col210, array('label'=>$vew_lang->fiscalcategory, 
																				'input1'=>vew_boot(	array('style'=>'search','readonly'=>$vew_readonly), 
																														array('input'=>gethtml('taxcattxt', 'typeahead', $vew_data->tax->taxcattxt, $lv_default) )) )); 
				echo gethtml('taxcatcod', 'hidden', $vew_data->tax->taxcatcod);			
				echo '<div class="form-group tmss-form-group">'
							.'<label class="col-xs-2 control-label text-nowrap">'.$vew_lang->taxcode.' 1</label>'
							.'<div class="col-xs-3">'.gethtml('idttypcod',array(),'', $lv_default).'</div>'
							.'<div class="col-xs-7">'
								.'<div class="">'
									.gethtml('taxcod001','doccmt1x20',$vew_data->tax->taxcod, $lv_default)
									.'<span class="input-group-btn hidden"><a href="#" class="btn btn-default" tabindex="-1" id="taxcod001btn">&nbsp;<i class="fas fa-download"></i></a></span>'
								.'</div>'
							.'</div>'
						.'</div>';
				echo '<a href="#"><i class="fas fa-external-link-alt hidden"></i></a>';
				echo vew_boot($lv_col210, array('label'=>$vew_lang->taxcode.' 2', 'input'=>gethtml('taxcod002','admtaxcod',$vew_data->tax->taxiibb,$lv_default) ));
				echo vew_boot($lv_col210, array('label'=>$vew_lang->startactivities, 'input'=>gethtml('taxactstr','docdte',$vew_data->tax->taxactstr,$lv_default) ));
			?>
    </div> 
		<?php } ?> 
</div> <!-- card -->
<script>
  // si se quiere ingresar identidad fiscal sin haber cargado un pais, aparece un warning 
  $("#<?= $lv_sec; ?> #idttypcod").on("focus", function(e){
    var lv_lndcod = $("#<?= $lv_sec; ?> #lndcod").val();
    if (!lv_lndcod){
      e.preventDefault();
      toastr.warning("Se debe seleccionar un pais.");
    }        
  });
</script>
<script>
	function <?= $lv_sec; ?>_grdattax_updIdttypcod( lp_callback ){
		var lv_lndcod = $("#<?= $lv_sec; ?> #lndcod").prop("value");
		$("#<?= $lv_sec; ?> #idttypcod option").remove();
		$("#<?= $lv_sec; ?> #idttypcod").append("<option value=''></option>");
		tmssCallProcessNoBackdrop("?prg=admidttyp&act=19",[{name:"lndcod",value:lv_lndcod}],function(data){
			for(var i=0; i<data.length; i++){
				$("#<?= $lv_sec; ?> #idttypcod").append("<option value='"+data[i].idttypcod+"'>"+data[i].idttyptxt+"</option>");
			}
			if(typeof lp_callback!="undefined"){ lp_callback(); }
		});
		
		<?php if(!$vew_readonly){ ?>
		// localizacion AR - ARGENTINA
		if(lv_lndcod=="AR"){
			tmssCallProcessNoBackdropErr("?prg=finlocargwss&act=AfipCnsIns&prm_frmchk=x",[],function(data){
				// verifico si es posible realizar la conexión con AFIP
				if(data.errtyp!="S"){
					$("#<?= $lv_sec; ?> #taxcod001").parent().removeClass("input-group");
					$("#<?= $lv_sec; ?> #taxcod001").next().addClass("hidden");
					return;
				}				
				$("#<?= $lv_sec; ?> #taxcod001").parent().addClass("input-group");
				$("#<?= $lv_sec; ?> #taxcod001").next().removeClass("hidden");	
				$("#<?= $lv_sec; ?> #taxcod001btn").on("click",function(e){ e.preventDefault();
					<?= $lv_sec; ?>_grldattax_ar_cnsins();
				});
			},function(dataerr){});
		}
		<?php } ?>
		
	}
	
	$(function(){
		// si cambia el país, cambio las opciones de los identificadores fiscales
		$("#<?= $lv_sec; ?> #lndcod").on("change",function(e){ e.preventDefault();
			<?= $lv_sec; ?>_grdattax_updIdttypcod();
		});
		<?= $lv_sec; ?>_grdattax_updIdttypcod( function(){
			$("#<?= $lv_sec; ?> #idttypcod").prop("value", "<?= $vew_data->tax->taxdoctyp; ?>");
		});
	});
	
	<?php if(!$vew_readonly){ ?>
    function <?= $lv_sec; ?>_grldattax_ar_cnsins(){
      BootstrapDialog.show({
        title: "AFIP - Constancia de Inscripci&oacute;n", 
        message: $("<div><h3>Recuperando datos desde AFIP...</h3><h4>Aguarde un instante <i class='fas fa-spinner fa-spin'></i></h4></div>"),
        type: BootstrapDialog.TYPE_PRIMARY,
        onshown: function(dialog){
          dialog.getButton("btntke").disable();
          var lv_pstdat = [{name:"objtypcod",value:"<?= $lv_mdlcod.'_'.$lv_prgcod; ?>"},{name:"idPersona",value:$("#<?= $lv_sec; ?> #taxcod001").prop("value")}];
          tmssCallProcessNoBackdropErr("?prg=finlocargwss&act=AfipCnsIns",lv_pstdat,function(data){
            // recupero datos
            var lv_adrfrtnme = data.personaReturn.datosGenerales.nombre;
            var lv_adrlstnme = data.personaReturn.datosGenerales.apellido;
            var lv_adrnme001 = data.personaReturn.datosGenerales.razonSocial;
            var lv_adrstr = data.personaReturn.datosGenerales.domicilioFiscal.direccion;
            var lv_adrpstcod = data.personaReturn.datosGenerales.domicilioFiscal.codPostal;
            var lv_lndregcod = data.personaReturn.datosGenerales.domicilioFiscal.idProvincia;
            var lv_lndregtxt = data.personaReturn.datosGenerales.domicilioFiscal.descripcionProvincia;
            var lv_adrcty = data.personaReturn.datosGenerales.domicilioFiscal.localidad;
            var lv_taxactstr = data.personaReturn.datosGenerales.fechaContratoSocial;
            var lv_idttyptxt = data.personaReturn.datosGenerales.tipoClave;
            var lv_idttypcod = (lv_idttyptxt=="CUIT"?"80":(lv_idttyptxt=="CUIL"?"86":""));
            var lv_taxcod001 = data.personaReturn.datosGenerales.idPersona;
            var lv_taxcatcod = "";						
            var lv_taxcattxt = "";
            var lv_adrnme001_fld = "";

            // monotributo
            if(data.personaReturn.datosMonotributo){
              if(data.personaReturn.datosMonotributo.impuesto){
                if(data.personaReturn.datosMonotributo.impuesto.length!=undefined){
                  for(var i=0; i<data.personaReturn.datosMonotributo.impuesto.length; i++){
                    for(var x=0; x<data.sysintcnv.length; x++){
                      if(data.sysintcnv[x].sysintcnvinb001==data.personaReturn.datosMonotributo.impuesto[i].idImpuesto){
                        lv_taxcatcod = data.sysintcnv[x].sysintcnvout001;
                        lv_taxcattxt = data.sysintcnv[x].sysintcnvout002;
                        break;
                      }
                    }
                  }
                } else {
                  for(var x=0; x<data.sysintcnv.length; x++){
                    if(data.sysintcnv[x].sysintcnvinb001==data.personaReturn.datosMonotributo.impuesto.idImpuesto){
                      lv_taxcatcod = data.sysintcnv[x].sysintcnvout001;
                      lv_taxcattxt = data.sysintcnv[x].sysintcnvout002;
                      break;
                    }
                  }
                }
              }
            }

            // regimen general
            if(data.personaReturn.datosRegimenGeneral) {
              if(data.personaReturn.datosRegimenGeneral.impuesto){
                if(data.personaReturn.datosRegimenGeneral.impuesto.length!=undefined){
                  for(var i=0; i<data.personaReturn.datosRegimenGeneral.impuesto.length; i++){
                    for(var x=0; x<data.sysintcnv.length; x++){
                      if(data.sysintcnv[x].sysintcnvinb001==data.personaReturn.datosRegimenGeneral.impuesto[i].idImpuesto){
                        lv_taxcatcod = data.sysintcnv[x].sysintcnvout001;
                        lv_taxcattxt = data.sysintcnv[x].sysintcnvout002;
                        break;
                      }
                    }
                  }
                } else {
                  for(var x=0; x<data.sysintcnv.length; x++){
                    if(data.sysintcnv[x].sysintcnvinb001==data.personaReturn.datosRegimenGeneral.impuesto.idImpuesto){
                      lv_taxcatcod = data.sysintcnv[x].sysintcnvout001;
                      lv_taxcattxt = data.sysintcnv[x].sysintcnvout002;
                      break;
                    }
                  }
                }
              }
            }

            // normalizo datos
            lv_adrfrtnme = (lv_adrfrtnme==undefined?"":lv_adrfrtnme);
            lv_adrlstnme = (lv_adrlstnme==undefined?"":lv_adrlstnme);
            lv_adrnme001 = (lv_adrnme001==undefined?"":lv_adrnme001);
            lv_adrstr 	 = (lv_adrstr==undefined?"":lv_adrstr);
            lv_adrpstcod = (lv_adrpstcod==undefined?"":lv_adrpstcod);
            lv_lndregcod = (lv_lndregcod==undefined?"":(lv_lndregcod<10?"0"+lv_lndregcod:lv_lndregcod));
            lv_lndregtxt = (lv_lndregtxt==undefined?"":lv_lndregtxt);
            lv_adrcty 	 = (lv_adrcty==undefined?"":lv_adrcty);
            lv_taxactstr = (lv_taxactstr==undefined?"": moment(lv_taxactstr).format("DD/MM/YYYY"));
            lv_idttyptxt = (lv_idttyptxt==undefined?"":lv_idttyptxt);
            lv_idttypcod = (lv_idttypcod==undefined?"":lv_idttypcod);
            lv_taxcatcod = (lv_taxcatcod==undefined?"":lv_taxcatcod);
            lv_taxcattxt = (lv_taxcattxt==undefined?"":lv_taxcattxt);
            lv_adrnme001_fld = (data.objtypkeytxt!="" && data.objtypkeytxt!=undefined ? data.objtypkeytxt : "");

            var lv_msg = "";
            lv_msg += "<input type='hidden' id='adrfrtnme' name='adrfrtnme' value='"+lv_adrfrtnme+"'>";
            lv_msg += "<input type='hidden' id='adrlstnme' name='adrlstnme' value='"+lv_adrlstnme+"'>";
            lv_msg += "<input type='hidden' id='adrnme001' name='adrnme001' value='"+lv_adrnme001+"'>";
            lv_msg += "<input type='hidden' id='adrnme001fld' name='adrnme001fld' value='"+lv_adrnme001_fld+"'>";
            lv_msg += "<input type='hidden' id='adrstr' 	 name='adrstr' 		value='"+lv_adrstr+"'>";
            lv_msg += "<input type='hidden' id='adrpstcod' name='adrpstcod' value='"+lv_adrpstcod+"'>";
            lv_msg += "<input type='hidden' id='adrcty' 	 name='adrcty' 		value='"+lv_adrcty+"'>";
            lv_msg += "<input type='hidden' id='lndregcod' name='lndregcod' value='"+lv_lndregcod+"'>";
            lv_msg += "<input type='hidden' id='lndregtxt' name='lndregtxt' value='"+lv_lndregtxt+"'>";
            lv_msg += "<input type='hidden' id='taxcatcod' name='taxcatcod' value='"+lv_taxcatcod+"'>";
            lv_msg += "<input type='hidden' id='taxcattxt' name='taxcattxt' value='"+lv_taxcattxt+"'>";
            lv_msg += "<input type='hidden' id='idttypcod' name='idttypcod' value='"+lv_idttypcod+"'>";
            lv_msg += "<input type='hidden' id='taxactstr' name='taxactstr' value='"+lv_taxactstr+"'>";
            lv_msg += "<table class='table'><tbody>";
            lv_msg += "<tr><td><b><?= $vew_lang->name; ?></b></td><td>"+lv_adrnme001+" "+lv_adrfrtnme+" "+lv_adrlstnme+"</td></tr>";
            lv_msg += "<tr><td><b><?= $vew_lang->address; ?></b></td><td>"+lv_adrstr+"<br>"+lv_adrpstcod+(lv_adrcty==""?"":" - "+lv_adrcty)+"<br>"+lv_lndregtxt+"</td></tr>";
            lv_msg += "<tr><td><b><?= $vew_lang->taxes; ?></b></td><td>"+lv_idttyptxt+" "+lv_taxcod001+"<br>"+lv_taxcatcod+" - "+lv_taxcattxt+"<br>"+lv_taxactstr+"</td></tr>";
            lv_msg += "</tbody></table>";
            dialog.$modalBody.html( "<div class='container-fluid'>"+lv_msg+"</div>" );
            dialog.getButton("btntke").enable();
          }, 
          function(callback){
						if(callback.errtyp!="S"){ dialog.$modalBody.html("<div class='container-fluid'><i class='fas fa-exclamation-triangle fa-3x text-warning pull-left pr-20'></i> "+callback.errtxt+"</div>"); return; }
            if(callback.personaReturn.errorConstancia){ dialog.$modalBody.html("<div class='container-fluid'><i class='fas fa-exclamation-triangle fa-3x text-warning pull-left pr-20'></i> "+callback.personaReturn.errorConstancia.apellido+" "+callback.personaReturn.errorConstancia.nombre+" ("+callback.personaReturn.errorConstancia.idPersona+") "+callback.personaReturn.errorConstancia.error+"</div>"); return; }            
          });
        },
        buttons: [
          {label:"<?= $vew_lang->cancel; ?>", cssClass:"btn-danger",action:function(dialog){dialog.close();}},
          {label:"<?= $vew_lang->download; ?>",cssClass:"btn-success",id:"btntke",action:function(dialog){
            // si se gestiona apellido/nombre, asigno valores
            if($("#<?= $lv_sec; ?> #adrlstnme").length!=0){
              // si realmente hay apellido/nombre en los datos obtenidos
              if(dialog.$modalBody.find("#adrlstnme").prop("value")!=""){
                $("#<?= $lv_sec; ?> #adrlstnme").prop("value", dialog.$modalBody.find("#adrlstnme").prop("value") );
                $("#<?= $lv_sec; ?> #adrfrtnme").prop("value", dialog.$modalBody.find("#adrfrtnme").prop("value") );
              } else {
                $("#<?= $lv_sec; ?> #adrlstnme").prop("value", dialog.$modalBody.find("#adrnme001").prop("value") );
                $("#<?= $lv_sec; ?> #adrfrtnme").prop("value", "");
              }
            // si no se gestiona apellido/nombre
            } else {
              var lv_adrnme001_fld = dialog.$modalBody.find("#adrnme001fld").prop("value");
              lv_adrnme001_fld = ( lv_adrnme001_fld==""?"adrnme001":lv_adrnme001_fld );
              if(dialog.$modalBody.find("#adrnme001").prop("value")!=""){
                $("#<?= $lv_sec; ?> #"+lv_adrnme001_fld).prop("value", dialog.$modalBody.find("#adrnme001").prop("value") );
              } else {
                $("#<?= $lv_sec; ?> #"+lv_adrnme001_fld).prop("value", dialog.$modalBody.find("#adrlstnme").prop("value")+(dialog.$modalBody.find("#adrfrtnme").prop("value")!=""?", "+dialog.$modalBody.find("#adrfrtnme").prop("value") : "" ) );
              }
            }
            $("#<?= $lv_sec; ?> #adrstr").prop("value", dialog.$modalBody.find("#adrstr").prop("value") );
            $("#<?= $lv_sec; ?> #adrstrnum").prop("value", "" );
            $("#<?= $lv_sec; ?> #adrstrflr").prop("value", "" );
            $("#<?= $lv_sec; ?> #adrstrunt").prop("value", "" );
            $("#<?= $lv_sec; ?> #adrstrbld").prop("value", "" );
            $("#<?= $lv_sec; ?> #adrpstcod").prop("value", dialog.$modalBody.find("#adrpstcod").prop("value") );
            $("#<?= $lv_sec; ?> #adrcty").prop("value", "" );
            $("#<?= $lv_sec; ?> #adrtwn").prop("value", dialog.$modalBody.find("#adrtwn").prop("value") );
            $("#<?= $lv_sec; ?> #adrzon").prop("value", "" );
            $("#<?= $lv_sec; ?> #lndregcod").prop("value", dialog.$modalBody.find("#lndregcod").prop("value") );
            $("#<?= $lv_sec; ?> #lndregtxt").prop("value", dialog.$modalBody.find("#lndregtxt").prop("value") );
            $("#<?= $lv_sec; ?> #taxcatcod").prop("value", dialog.$modalBody.find("#taxcatcod").prop("value") );
            $("#<?= $lv_sec; ?> #taxcattxt").prop("value", dialog.$modalBody.find("#taxcattxt").prop("value") );
            $("#<?= $lv_sec; ?> #idttypcod").prop("value", dialog.$modalBody.find("#idttypcod").prop("value") );
            $("#<?= $lv_sec; ?> #taxcod002").prop("value", "" );
            $("#<?= $lv_sec; ?> #taxactstr").prop("value", dialog.$modalBody.find("#taxactstr").prop("value") );
            dialog.close();
            }
          }]
      });
    }
  
    // taxcattxt
  	var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{ "l.lndcod" : $("#<?= $lv_sec; ?> #lndcod") },"fldasg":{"taxcatcod":"taxcatcod", "taxcattxt":"taxcattxt"}};
  	tmssTypeahead($("#<?= $lv_sec; ?> #taxcattxt"), 'fintaxcat', lo_get);

    // taxcod001
    $("#<?= $lv_sec ?> #taxcod001").blur( function (e){ e.preventDefault();
      var lv_taxcod = $("#<?= $lv_sec ?> #idttypcod").val();
      var lv_lndcod = $("#<?= $lv_sec; ?> #lndcod").val();

      // localizacion ARGENTINA - validación de CUIL/CUIT
      if( lv_lndcod == "AR" && (lv_taxcod=="80" || lv_taxcod=="86") ){
        var lv_validate = <?= $lv_sec ?>_AR_validateCuit( $(this).val() )
        if ( lv_validate == false ){
          $(this).parent().parent().addClass("has-error");

          e.stopPropagation();
          $(this).focus();
        } else {
          $(this).parent().parent().removeClass("has-error");
        } 
        
        // Chile - validacion de rut
      }	else if(lv_lndcod == "CL" && lv_taxcod=="80" ){
        var lv_validate = <?= $lv_sec ?>_CL_validateRUT( $(this).val() )
        if ( lv_validate == false ){
          $(this).parent().parent().addClass("has-error");
          e.stopPropagation();
          $(this).focus();
        } else {
          $(this).parent().parent().removeClass("has-error");
        }
      }	
    });

    // Validacion CUIT - CUIL Argentina
    function <?= $lv_sec ?>_AR_validateCuit( lv_var ){
      var lv_strvar = lv_var.toString();
      if ( lv_strvar.length == 11 ) {
        var lv_char_1_2 = lv_strvar.charAt(0)+lv_strvar.charAt(1);
        if ( lv_char_1_2 == "20" || lv_char_1_2 == "23"|| lv_char_1_2 == "24" || lv_char_1_2 == "27" || lv_char_1_2 == "30" || lv_char_1_2 == "33" || lv_char_1_2 == "34"  ) {
          var lv_count = lv_strvar.charAt(0)*5+lv_strvar.charAt(1)*4+lv_strvar.charAt(2)*3+lv_strvar.charAt(3)*2+lv_strvar.charAt(4)*7+lv_strvar.charAt(5)*6+lv_strvar.charAt(6)*5+lv_strvar.charAt(7)*4+lv_strvar.charAt(8)*3+lv_strvar.charAt(9)*2+lv_strvar.charAt(10)*1;                             
          var lv_div = lv_count/11;
          if(lv_div==Math.floor(lv_div)) {
            return true;
          }
        }
      }
      return false;
    }
  
  	 // Validacion RUT CHILE
     function <?= $lv_sec ?>_CL_validateRUT( lv_var ){

      // Obtiene el valor ingresado quitando puntos y guión.
      var lv_val = lv_var.replace(/([.-\s,])/g, "");
			
      // Divide el valor ingresado en dígito verificador y resto del RUT.
      lv_strvar = lv_val.slice(0, -1);   																// "Cuerpo" se cambio por "lv_strvar"
      var lv_dv = lv_val.slice(-1).toUpperCase();															// "valor" se cambio por "lv_val"

      // Separa con un Guión el cuerpo del dígito verificador.    
      lv_var = typeof lv_var === 'string' ? lv_var.replace(/^0+|[^0-9kK]+/g, '').toUpperCase(): '';

      var lv_result = lv_var.slice(-4, -1) + '-' + lv_var.substr(lv_var.length - 1);
      for (var i = 4; i < lv_var.length; i += 3) {
        lv_result = lv_var.slice(-3 - i, -i) + '.' + lv_result;
      }

      lv_var = lv_result;

      // Si no cumple con el mínimo ej. (n.nnn.nnn)
      if (lv_strvar.length < 7) {
        toastr.warning("RUT muy corto");
        return false;
      }
       
      // Si no cumple con el máximo ej. (nn.nnn.nnn-n)
      if (lv_strvar.length > 9) {
        toastr.warning("RUT excede el m&aacute;ximo de caracteres");
        return false;
      }

      // Calcular Dígito Verificador "Método del Módulo 11"
      var lv_count = 0;																					//"suma" se cambio por "lv_count"
      var lv_mul = 2;																						//"multiplo" se cambio por "lv_mul"												

      // Para cada dígito del Cuerpo
      for (i = 1; i <= lv_strvar.length; i++) {
        // Obtener su Producto con el Múltiplo Correspondiente
        var lv_index = lv_mul * lv_val.charAt(lv_strvar.length - i);

        // Sumar al Contador General
        lv_count = lv_count + lv_index;

        // Consolidar Múltiplo dentro del rango [2,7]
        if (lv_mul < 7) {
          lv_mul = lv_mul + 1;
        } else {
          lv_mul = 2;
        }
      }

      // Calcular Dígito Verificador en base al Módulo 11
      var lv_dvEsp = 11 - (lv_count % 11);                   // dvEsperado => lv_dvEsp

      // Casos Especiales (0 y K)
      lv_dv = lv_dv == "K" ? 10 : lv_dv;
      lv_dv = lv_dv == 0 ? 11 : lv_dv;

      // Validar que el Cuerpo coincide con su Dígito Verificador
      if (lv_dvEsp != lv_dv) {
        toastr.warning("El CUIL/CUIT es invalido.");
        return false;        
      } else {
        return true;
      }
    } 
	<?php } ?>
</script>
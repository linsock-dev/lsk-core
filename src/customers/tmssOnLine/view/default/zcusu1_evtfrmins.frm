<?php
	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = '';
	
	// modulo y programa 
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'SU1';

	// libreria de estilos bootstrap 
	include_once('_library.frm');
	
	$lv_sec = ( ($vew_oldSec??'')!='' ? $vew_oldSec : $lv_sec );
	$lv_steevtcod = $vew_data->evtdoc[0]['steevtcod']??'';
	$lv_steevtdoccod = $vew_data->evtdoc[0]['steevtdoccod']??'';

  // secciones y categorías del formulario
	$lv_entity_arr = array('&OACUTE;' => 'Ó', '&UACUTE;' => 'Ú', '&NTILDE;' => 'Ñ');
  foreach($lv_entity_arr as &$lv_row){
    $lv_row = htmlentities($lv_row, ENT_COMPAT | ENT_HTML401, "UTF-8");
  }
  unset($lv_row);

	if (count($vew_data->evtdoc) > 0 && $vew_doc->getTagValue($vew_data->evtdoc[0]['steevtdocatr'], 'alc_gel') !== ''){
		$ins_hyg =array('title' => strtoupper($vew_lang->hygiene),
										'icon' => 'fas fa-pump-medical', 
										'cat' => array(	'alc_gel' => 'Alcohol en gel',
																		'agu_jab' =>'Agua y jab&oacute;n para lavado de manos', 
																		'kit_vhc' => 'Kit desinfectante en veh&iacute;culo'));
	} else {
		$ins_hyg =array('title' => strtoupper($vew_lang->hygiene), 
										'icon' => 'fas fa-pump-medical', 
										'cat' => array('ele_hyg' => 'Elementos de higiene'));
	}

  $lv_ctr = array('INS_SGN' => array('title' => str_replace(array_keys($lv_entity_arr), array_values($lv_entity_arr), strtoupper($vew_lang->signaling)), 'icon' => 'fas fa-exclamation-triangle', 
                                    'cat' => array('car_per' => 'Cartel permiso de obra / institucional p&uacute;blica',
                                                  'car_adv' => 'Carteles de advertencia &ldquo;peligro hombres trabajando&rdquo; &ldquo;circule con precauci&oacute;n&rdquo; &ldquo;peligro zanja abierta&rdquo; &ldquo;reducci&oacute;n de calzada&rdquo;', 
                                                  'con_cal' => 'Conos en calzadas se&ntilde;alizaci&oacute;n vehicular',
                                                  'cin_prv' => 'Cinta de prevenci&oacute;n peatonal',
                                                  'cru_cal' => 'Cruzada sobre calzada',
                                                  'cru_bal' => 'Cruzada con baliza nocturna')),
                  'INS_PPR' => array('title' => str_replace(array_keys($lv_entity_arr), array_values($lv_entity_arr), strtoupper($vew_lang->publicprotection)), 'icon' => 'fas fa-briefcase-medical', 
                                    'cat' => array('val_com' => 'Vallado completo',
                                                  'abe_val_det_fal' => 'Aberturas menores a 50 cm. En vallas (deterioradas con faltantes)', 
                                                  'her_ens_ala_ens' => 'Herrajes ensamblado (uso de alambre y/o sin ensamblar)',
                                                  'est_val' => 'Estabilidad del vallado',
                                                  'pas_ptn' => 'Paso peatonal',
                                                  'caj' => 'Cajones',
                                                  'her_ens' => 'Herrajes ensamblado',
                                                  'rej' => 'Rejillas')),
                  'INS_CSC' => array('title' => strtoupper($vew_lang->constructionsiteconditions), 'icon' => 'fas fa-drafting-compass', 
                                    'cat' => array('tie_esc' =>'Tierra y escombro contenido',
                                                  'pas_ptn_lbr' => 'Paso peatonal libre de obst&acute;culos', 
                                                  'znj_abi_prt' => 'Zanja abierta con protecci&oacute;n',
                                                  'ord_lmp' => 'Orden y limpieza',
                                                  'mat_acp' => 'Materiales acopiados',
                                                  'rsd_dsp' => 'Residuos - Disposici&oacute;n')),
                  'INS_TLS' => array('title' => strtoupper($vew_lang->tools), 'icon' => 'fas fa-tools', 
                                    'cat' => array('pls' => 'Palas',
                                                  'pic' => 'Pico', 
                                                  'mas' => 'Masa',
                                                  'mrt_nmt' => 'Martillo neum&aacute;tico',
                                                  'mtc' => 'Motocompresor',
                                                  'grp_elc' => 'Grupo electr&oacute;geno',
                                                  'mld' => 'Amoladora',
                                                  'tbl_elc_por' => 'Tablero el&eacute;ctrico portable',
                                                  'psn' => 'Apisonador',
                                                  'tnl' => 'Tunelera',
                                                  'bat_mzc_mat' => 'Batea para mezcla de materiales',
                                                  'gjr' => 'Agujereadora')),
                  'INS_JSC' => array('title' => strtoupper($vew_lang->jobsecurity), 'icon' => 'fas fa-user-hard-hat', 
                                    'cat' => array('cms' => 'Camisa',
                                                  'pnt' => 'Pantal&oacute;n', 
                                                  'cas' => 'Casco',
                                                  'gnt_cue' => 'Guante de cuero',
                                                  'clz_seg' => 'Calzado de seguridad',
                                                  'prt_ocu' => 'Protector ocular',
                                                  'prt_fac' => 'Protector facial',
                                                  'prt_aud' => 'Protector auditivo',
                                                  'faj_lum' => 'Faja lumbar',
                                                  'tpb_cov' => 'Tapabocas &#8211 Covid-19')), 
                  'INS_TND' => array('title' => 'TENDIDO', 'icon' => 'fas fa-paint-roller', 
                                    'cat' => array('prt_cbl_los_lad' => 'Protecciones de cables losetas / ladrillos',
                                                    'enr_cbl' => 'Enrollado de cable', 
                                                    'rdl' => 'Rodillos',
                                                    'int' => 'Interferencias',
                                                    'cap' => 'Capuchones',
                                                    'cin_adv_los' => 'Cinta de advertencias / loseta')),
                  'INS_DOC' => array('title' => str_replace(array_keys($lv_entity_arr), array_values($lv_entity_arr), strtoupper($vew_lang->documentation)), 'icon' => 'far fa-file-alt', 
                                    'cat' => array('pln' => 'Plano',
                                                  'per_mnc' => 'Permisos municipales', 
                                                  'cre_art_srl' =>'Credenciales ART / SUPPLY SOUTH S.R.L',
                                                  'mts' => 'MTS (M&eacute;todo de trabajo seguro)',
                                                  'pln_seg_vig' => 'Plan de seguridad vigente',
                                                  'crt_art' => 'Certificado de cobertura de ART')),
                  'INS_HYG' => $ins_hyg
					);
?> 
<section id="<?= $lv_sec; ?>">
  <style>
    .card.tmss-dropdown-card.tmss-closed-card > .card-header{ border-bottom: none !important; }
    .tmss-dropdown-card > div:first-child:hover{ cursor: pointer; }
    .tmss-dropdown-card .big-card-title { font-size: 25px; font-weight: bold; color: #0e0e0e; display: flex; align-items: center; justify-content: space-between; }
  </style>      
	<?= gethtml('steevtcod', 'hidden', $lv_steevtcod); ?>
	<?= gethtml('steevtdoccod', 'hidden', $lv_steevtdoccod); ?>
	<textarea class="hidden" id="steevtdocdat" name="steevtdocdat">"<?= (count($vew_data->evtdoc)>0 ? $vew_data->evtdoc[0]['steevtdocatr'] : '');?>"</textarea>

	<div class="row">
		<div class="col-sm-6 col-xs-12">
    <?php
      $lv_frmsection = '';
      $lv_frmsection .= 
        '<div class="card tmss-dropdown-card tmss-closed-card" data-frm="INS_ACT">
          <div class="card-header">
            <div class="card-title big-card-title">'.
              strtoupper($vew_lang->activity).'<i class="fas fa-triangle-person-digging"></i>
            </div>
          </div>
          <div class="card-body hidden">
            <div class="tmss-vertbl-scroll" style="height:100%">
              <table class="table table-hover table-no-bordered table-condensed">
                <thead>
                  <tr>
                    <th width="50%">'.$vew_lang->type.'</th>
                    <th width="10%"></th>
                    <th width="10%"></th>
                    <th width="10%"></th>
                    <th width="10%"></th>
                    <th width="10%"></th>
                    <th width="10%"></th>
                  </tr>
                </thead>
                <tbody>
                  <tr data-cat="exc">
                    <td>Excavaci&oacute;n</td>
                    <td></td> <td></td> <td></td> <td></td> <td></td>
                    <td class="text-center"><input class="cursor-pointer" type="checkbox" value="exc" ></td>
                  </tr>
                  <tr data-cat="tnd">
                    <td>Tendido</td>
                    <td class="text-right">BT</td>
                    <td class="text-center">
                      <input class="cursor-pointer" type="checkbox" value="tbt">
                    </td>
                    <td class="text-right">MT</td>
                    <td class="text-center">
                      <input class="cursor-pointer" type="checkbox" value="tmt">
                    </td>
                    <td class="text-right">AT</td>
                    <td class="text-center">
                      <input class="cursor-pointer" type="checkbox" value="tat">
                    </td>
                  </tr>
                  <tr data-cat="vrd">
                    <td>Veredas</td>
                    <td></td> <td></td> <td></td> <td></td> <td></td>
                    <td class="text-center">
                      <input class="cursor-pointer" type="checkbox" value="vrd">
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>';
      $lv_nextcol = false;
      $i = 0;
      $j = 0;
      
      foreach($lv_ctr as $lv_key => $lv_row){                
        if(count($lv_ctr) / ($i+1) < 2 && !$lv_nextcol){
          $lv_nextcol = true;
          //$lv_frmsection .= '</div><div class="col-md-4 col-sm-6 col-xs-12 ">';  
          $lv_frmsection .= '</div><div class="col-sm-6 col-xs-12 ">';              
        }

        $lv_frmsection .= 
          '<div class="card tmss-dropdown-card tmss-closed-card" data-frm="'.$lv_key.'">'.
            '<div class="card-header">'.
              '<div class="card-title big-card-title">'.
                $lv_row['title'].'<i class="'.$lv_row['icon'].'"></i>'.
              '</div>'.
            '</div>'.
            '<div class="card-body hidden">'.
              '<div class="tmss-vertbl-scroll" style="height:100%">'.
                '<table class="table table-hover table-no-bordered table-condensed">'.
                  '<thead>'.
          					(!$vew_readonly?'<tr><th colspan="1"></th><th colspan="3" class="text-center"> <a class="cursor-pointer chkall">Marcar todo</a> </th></tr>':'').
                    '<tr>'.
                      '<th width="60%">'.$vew_lang->category.'</th>'.
                      '<th class="text-center" width="12%"> <i class="fa-solid fa-check"></i> </th>'.
                      '<th class="text-center" width="12%"> <i class="fa-solid fa-xmark"></i> </th>'.
                      '<th class="text-center" width="15%"> N / A </th>'.
                    '</tr>'.
                  '</thead>'.
                  '<tbody>';

        foreach($lv_row['cat'] as $lv_key2 => $lv_row2){
          
          $lv_frmsection .= '<tr data-cat="'.$lv_key2.'">'.
                              '<td>'.$lv_row2.'</td>'.
                              '<td class="text-center"><input class="cursor-pointer" type="radio" name="row'.$j.'" value="yes"></td>'.
                              '<td class="text-center"><input class="cursor-pointer" type="radio" name="row'.$j.'" value="no"></td>'.
                              '<td class="text-center"><input class="cursor-pointer" type="radio" name="row'.$j.'" value="na"></td>'.
                            '</tr>';
          $j++;
        }

        $lv_frmsection .= '</tbody></table></div></div></div>';
        $i++;
      }
      echo $lv_frmsection;
    ?>
		</div>
  </div>
  <script>
    $(function(){ 
      // carga datos de las secciones
			var lv_dat = "<?= ($vew_data->evtdoc[0]['steevtdocatr']??''); ?>";
      var lv_frm = "";
      var lv_ro = <?= $vew_readonly ? 'true' : 'false'?>;
      $("#<?= $lv_sec; ?> [data-frm]").each(function(){
        lv_frm = $(this).data("frm");
        $(this).find("td input").each(function(){
          if(lv_frm == "INS_ACT"){ 
            $(this).prop("checked", $($(lv_dat).filter(lv_frm).html()).filter($(this).val()).html() === "1" ? true : false);
          }else{
            if($(this).val() == $($(lv_dat).filter(lv_frm).html()).filter($(this).parents("tr").data("cat")).html()){
             	$(this).prop("checked", true);
              if($(this).is("[value='no']")){
                var lv_incrow = $("<tr><td colspan='4'>Descripci&oacute;n del incumplimiento: <textarea rows='2' class='form-control'></textarea></td></tr>");
               	lv_incrow.find("textarea").prop("readonly", lv_ro);
                lv_incrow.find("textarea").val( $($(lv_dat).filter(lv_frm).html()).filter($(this).parents("tr").data("cat")+"-inc").html() );
                
                $(this).parents("tr").after(lv_incrow);
              }
            }
          }
        });
      });  
    });
    
    <?php if($vew_readonly){ ?>
			$("#<?= $lv_sec; ?> :radio, #<?= $lv_sec; ?> :checkbox").click(function(){ return false; });
    <?php } ?>
  </script>
  <script>
    // botón marcar todo
    $("#<?= $lv_sec; ?> .chkall").on("click", function(e){ e.preventDefault();
      var lv_msg = '<div class="form-horizontal"><div class="container-fluid"><div class="row">';
     	lv_msg += '<?= vew_boot($lv_col210, array('label'=>'Marcar',	'input'=>gethtml('chktyp', ['yes'=>'OK', 'no'=>'NO OK', 'na'=>'N/A'], 'OK', $lv_default) )); ?>';
      lv_msg += "<input id='frm' class='hidden' value='"+$(this).parents("[data-frm]").data("frm")+"'>";
      lv_msg += "</div></div></div>";

      BootstrapDialog.show({
        message: lv_msg,
        closable: false,
        draggable: true,
        buttons:[{label: "<?= $vew_lang->close; ?>", cssClass: "btn-default", action: function(dialog){ dialog.close(); }},
                {	label: "OK", cssClass: "btn-primary", action:function(dialogItself){
                  var lv_opt = $(dialogItself.$modalBody).find("#chktyp").val();
                  var lv_frm = $(dialogItself.$modalBody).find("#frm").val();
                  $("#<?= $lv_sec; ?> [data-frm="+lv_frm+"] :radio[value="+lv_opt+"]").trigger("click");

                   dialogItself.close();
                }}]
      });
    });
  </script>
  <script>
    // abre/cierra una sección del formulario cuando se clickea sobre su cabecera
    $("#<?= $lv_sec; ?> .tmss-dropdown-card > div:not(.card-body)").on("click", function(e){ e.preventDefault;
      $(this).parent().toggleClass("tmss-closed-card");
      $(this).siblings(".card-body").toggleClass("hidden");
    });
  </script>
  <script>
    // Marco radio button si toco celda
    $("#<?= $lv_sec;?> [data-frm] td:has(input[type=radio])").on("click", function(e){ 
      $(this).find("input").prop("checked", true);
      $(this).find("input").triggerHandler("change");
    });
    
    // Muestro u oculto descripción de incumplimiento
    $("#<?= $lv_sec;?> input[type='radio']").on("change", function(e){  
                 
      // verifico si no existe la fila de incumplimientos
      if($(this).parents("tr").next(":not([data-cat])").length == 0){
				// la añado si el no está checkeado
        if($(this).prop("checked") && $(this).is("[value='no']")){
        	$(this).parents("tr").after($("<tr><td colspan='4'>Descripci&oacute;n del incumplimiento: <textarea rows='2' class='form-control'></textarea></td></tr>"));
        }
      }else{
        $(this).parents("tr").next(":not([data-cat])").toggleClass("hidden", !($(this).is("[value='no']")));
      }
		});
  </script>
  <script>
    // verifica que todos los campos hayan sido completados para las secciones que lo requieran (incluye comentarios por incumplimiento)
    function <?= $lv_sec; ?>_checkForm(){
      var lv_req_qty = 0;
      var lv_req_aux = 0;
      var lv_inc_qty = 0;
      var lv_inc_aux = 0;
      var lv_valid = false;
      $("#<?= $lv_sec; ?> [data-frm]").each(function(){
        lv_req_aux = lv_req_qty;
        lv_inc_aux = lv_inc_qty;
        
        // busco si hay una fila sin completar
        $(this).find("table tbody tr").each(function(){ 
          if($(this).find("input[type=radio]").length > 0 && $(this).find("input[type=radio]:checked").length == 0){
          	lv_req_qty++;
            return false;
        	}else if($(this).find("input[type=radio]").length > 0 && $(this).find("input[type=radio][value=no]").is(":checked")){
            if($(this).next().find("textarea").val() == ""){
              lv_inc_qty++;
              return false;
            }
          }
        });
        
        // añado clase de error al icono
        if( lv_req_aux != lv_req_qty  || lv_inc_aux != lv_inc_qty){
        	$(this).find("i:eq(0)").addClass("text-danger");
        }else{
        	$(this).find("i:eq(0)").removeClass("text-danger");
        }
      });
      
      if(lv_req_qty){
        toastr.warning( "Complete todos los controles.<br>Incompletos ("+lv_req_qty+")." );
      }else if(lv_inc_qty){
        toastr.warning( "Complete todos los comentarios sobre incumplimientos." );
      }else{
        lv_valid = true;
      }
      
      return lv_valid;
    }
    
    // fija los datos del formulario en los campos como JSON
    function <?= $lv_sec; ?>_sve( lp_sec ){ 
      if(!<?= $lv_sec; ?>_checkForm()){
        return false;
      }
			var lv_insdat = {"steevtdoccod": $("#<?= $lv_sec; ?> #steevtdoccod").prop("value"),
												"srcobjtyp": "CNS_EVT_FRM",
												"srcobjcod": "1",
                        "srcobjtxt": "INSPECCION",
                      	"steevtdocatr": ""
                      };
      var lv_frmatr = ""; 
			
      // recorre las secciones del formulario
      $("#<?= $lv_sec; ?> table").each(function(){
      	lv_frmatr += "<"+$(this).parents("[data-frm]").data("frm")+">";
        
        // recorre cada categoría
        $(this).find("tbody tr").each(function(){ 
          if($(this).find("input[type=radio]").length>0){
            var lv_val = $(this).find("input:checked").val();
          	lv_frmatr += "<"+$(this).data("cat")+">" + lv_val + "</"+$(this).data("cat")+">";
            
            // Verifico si hay que guardar un incumplimiento
            if($(this).next(":not([data-cat])").length > 0){ 
              lv_frmatr += "<"+$(this).data("cat")+"-inc>" + $(this).next(":not([data-cat])").find("textarea").val() + "</"+$(this).data("cat")+"-inc>";
            }
          }else{
            $(this).find("input[type=checkbox]").each(function(){
              var lv_tag = $(this).val();
              lv_frmatr += "<"+lv_tag+">" + ($(this).is(":checked") ? 1 : 0) + "</"+lv_tag+">";
            });
          }
        });
        
        lv_frmatr += "</"+$(this).parents("[data-frm]").data("frm")+">"; 
      });
      
      lv_insdat["steevtdocatr"] = lv_frmatr;
      
			// fija los valores en los campos
			$("#<?= $lv_sec; ?> #steevtdocdat").text( JSON.stringify([lv_insdat]) );
      
      return true;
    }
  </script>
</section>
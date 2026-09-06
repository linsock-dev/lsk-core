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
 
  $lv_ctr = array('CTR_5RO' => array('title' => '5 REGLAS DE ORO', 'icon' => 'fas fa-shield-check', 
                                    'cat' => array('crt_tns' => 'Corte efectivo de todas las fuentes de tensi&oacute;n',
                                                  'apr_crt_sec' => 'Bloque de los aparatos de corte o de seccionamiento', 
                                                  'aus_tns' => 'Comprobaci&oacute;n de ausencia de tensi&oacute;n',
                                                  'gnd_cir' => 'Puesta a tierra y en corto circuito',
                                                  'det_zon_sng' => 'Determinac&oacute;n de la zona de trabajo y señalizaci&oacute;n de los equipos m&aacute;s pr&oacute;ximos bajo tensi&oacute;n')),
                  'CTR_PPT' => array('title' => 'PROCEDIMIENTO PT 6202', 'icon' => 'fas fa-draw-square', 
                                    'cat' => array('zon_prt' => 'Creaci&oacute;n de la Zona Protegida',
                                                  'zon_tra' => 'Creaci&oacute;n de la Zona de Trabajo', 
                                                  'pat' => 'Procedimiento de colocaci&oacute; de P.A.T. transitoria',
                                                  'seg_nvl_tns' => 'Distancia de seguridad de acuerdo al nivel de tensi&oacute;n',
                                                  'prt_seg' => 'Comportamiento y cumplimiento de requisitos en el trabajo y durante la reposici&oacute;n del servicio (cumplimiento PT6202 Entrega y devoluci&oacute;n MT o PT6106) - Protocolo de Seguridad N&deg;')),
                  'CTR_SEG' => array('title' => 'NORMAS Y PROCED. DE SEGURIDAD', 'icon' => 'fad fa-shield', 
                                    'cat' => array('ps05' =>'PS-05 Planilla de Autocontrol EPP, ESC y Herram Anex E y F',
                                                  'is40' => 'IS-40 Trabajo en altura - Comprobaci&oacute;n estado del poste', 
                                                  'it_5407_54023' => 'IT-5407 Y 54023 Identificaci&oacute;n y pinchado de cable (BT-MT)',
                                                  'ps13' => 'PS-13 Apuntalamiento de excavaciones y zanjas',
                                                  'is59' => 'IS-59 An&aacute; de Tarea Segura &#8211 Trabajos de Contratistas')),
                  'CTR_PUB' => array('title' => 'NORMAS Y PROCED. DE SEG. EN VIA PUBLICA', 'icon' => 'fas fa-walking', 
                                    'cat' => array('vld' => 'Vallado (Estado de vallas, cierre, faltante, etc.)',
                                                  'prl_mdr' => 'Parillas de madera', 
                                                  'sng_prt_pub' => 'Elementos de se&ntilde;alizaci&oacute;n de v&iacute;a p&uacute;blica (carteles e iluminaci&oacute;n)',
                                                  'con_cin' => 'Conos / columnas, cintas / cadenas',
                                                  'pln_vhc' => 'Planchones para veh&iacute;culos',
                                                  'cnt_grnd' => 'Contenedores de tierra',
                                                  'snd_ptn' => 'Senda peatonal')),
                  'CTR_MAM' => array('title' => 'NORMAS Y PROCED. DE MEDIO AMBIENTE', 'icon' => 'fas fa-tree', 
                                    'cat' => array('seg_res' => 'Segregaci&oacute;n de residuos',
                                                  'ord_lmp' => 'Orden y limpieza general', 
                                                  'per_hdr' => 'P&eacute;rdida de hidrocarburos (incluye veh&iacute;culos, equipos, gr&uacute;as e incidentes durante los trabajos)',
                                                  'trn_tra' => 'Transporte de transformadores (Batea, amarres, lona, etc.)',
                                                  'cnt_der' => 'Contenci&oacute;n de derrames de aceites y remediaci&oacute;n de suelos')), 
                  'CTR_PRT' => array('title' => 'ELEMENTOS DE PROTECCION PERSONAL', 'icon' => 'fas fa-hard-hat', 
                                    'cat' => array('cas' => 'Casco',
                                                    'cal_seg' => 'Calzado de seguridad', 
                                                    'rop_tra' => 'Ropa de trabajo (*)',
                                                    'gnt_dmt' => 'Guantes diel&eacute;ctricos de MT',
                                                    'gnt_dbt' => 'Guantes diel&eacute;ctricos de BT',
                                                    'gnt_pmc' => 'Guantes protecci&oacute;n mec&acute;nica',
                                                    'gnt_kev' => 'Guantes de kevlar (protecci&oacute;n t&eacute;rmica)',
                                                    'gnt_acr' => 'Guantes de acrilonitrilo (protecci&oacute;n qu&iacute;mica)',
                                                    'prt_ocu' => 'Protecci&oacute;n ocular (gafas)',
                                                    'msk_adf' => 'Mascara anti-deflagratoria',
                                                    'rsc_alt' => 'Equipo rescate para trabajo en altura',
                                                    'arn_seg' => 'Arn&eacute;s de seguridad',
                                                    'msk_fpo' => 'M&acute;scara con filtro para polvo',
                                                    'msk_fga' => 'M&acute;scara con filtro para gases',
                                                    'prt_aud' => 'Protector auditivo',
                                                    'trp' => 'Trepadores'),
                 										'note' => '(*) Se eval&uacute;a seguridad e imagen'),
                  'CTR_SEG_COL' => array('title' => 'HERRAMIENTAS Y SEGURIDAD COLECTIVA', 'icon' => 'fas fa-tools', 
                                    'cat' => array('prt_man' => 'P&eacute;rtiga de maniobra',
                                                  'det_btmt' => 'Detector de tensi&oacute;n y concordancia de fase (MT-BT)', 
                                                  'bst_dsc' =>'Bast&oacute;n descargador',
                                                  'eqp_pat' => 'Equipo de PAT normalizado',
                                                  'alf_ais' => 'Alfombras aislantes',
                                                  'prt_ais' => 'Mantas/ Vainas/Protectores y pantallas aislantes',
                                                  'sog_srv' => 'Soga de servicio',
                                                  'esc_die' => 'Escaleras diel&eacute;ctricas',
                                                  'tls_ais_tbt' => 'Herramientas aisladas p/trabajos en BT con tensi&oacute;n',
                                                  'mnp_fnh' => 'Manopla extracci&oacute;n fusibles NH',
                                                  'eqp' => 'Equipos')),
                  'CTR_VHC' => array('title' => 'ESTADO DE VEHICULOS', 'icon' => 'fas fa-snowplow', 
                                    'cat' => array('hid' => 'Hidroelevador/Hidrogrua',
                                                  'vhc_dom' =>'Veh&iacute;culos (*) Dominio:', 
                                                  'mat_vhc' => 'Estiba de materiales en veh&iacute;culos',
                                                  'vtv' =>'VTV. Vencimiento', 
                                                  'mtf_vnc' =>'Matafuego vehicular. Vencimiento', 
                                                  'bot_aux' =>'Botiqu&iacute;n de primeros auxilios', 
                                                  'reg_cnd' =>'Registro de conducir'),
                 										'note' => '(*) Se eval&uacute;a seguridad e imagen'));
?> 
<section id="<?= $lv_sec; ?>">
  <style>
    .card.tmss-dropdown-card.tmss-closed-card > .card-header { border-bottom: none !important; }
    .tmss-dropdown-card > div:first-child:hover { cursor: pointer; }
    .tmss-dropdown-card .big-card-title { font-size: 25px; font-weight: bold; color: #0e0e0e; display: flex; align-items: center; justify-content: space-between;}
  </style>
  <?= gethtml('steevtcod', 'hidden', $lv_steevtcod); ?>
  <?= gethtml('steevtdoccod', 'hidden', $lv_steevtdoccod); ?>
  <textarea class="hidden" id="steevtdocdat" name="steevtdocdat"></textarea>
	
  <div class="row">
		<div class="col-sm-6 col-xs-12">
		<?php
    // armo menú
    //$lv_frmsection =  '<div class="col-md-offset-2 col-md-4 col-sm-6 col-xs-12 ">';
    $lv_frmsection = '';
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
                  (!$vew_readonly?'<tr><th colspan="1"></th><th colspan="3" class="text-center"><a class="cursor-pointer chkall">Marcar todo</a></th></tr>':'').
                  '<tr>'.
                    '<th width="60%">'.$vew_lang->concept.'</th>'.
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

      $lv_frmsection .= '</tbody></table></div>';
      $lv_frmsection .= (isset($lv_row['note']) ? '<span>'.$lv_row['note'].'</span>' : '');
      $lv_frmsection .= '</div></div>';
      $i++;
    }
    echo $lv_frmsection;
		?>
		</div>
  </div>
  <script>
    $(function(){ 
      // carga datos de las secciones
			var lv_dat = "<?= $vew_data->evtdoc[0]['steevtdocatr']; ?>";
      var lv_frm = "";
      var lv_ro = <?= $vew_readonly ? 'true' : 'false'?>;
      
      $("#<?= $lv_sec; ?> [data-frm]").each(function(){
        lv_frm = $(this).data("frm");
        $(this).find("td input").each(function(){
          if($(this).val() == $($(lv_dat).filter(lv_frm).html()).filter($(this).parents("tr").data("cat")).html()){
            $(this).prop("checked", true);
          }
        });
      });  
    });
    
    <?php if($vew_readonly){ ?>
			$("#<?= $lv_sec; ?> :radio").click(function(){ return false; });
    <?php } ?>
  </script>
  <script>
    // abre/cierra una sección del formulario cuando se clickea sobre su cabecera
    $("#<?= $lv_sec; ?> .tmss-dropdown-card > div:not(.card-body)").on("click", function(e){ e.preventDefault;
      $(this).parent().toggleClass("tmss-closed-card");
      $(this).siblings(".card-body").toggleClass("hidden");
    });
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
    // verifica que todos los campos hayan sido completados para las secciones que lo requieran
    function <?= $lv_sec; ?>_checkForm(){
      var lv_req_qty = 0;
      var lv_aux = 0;
      var lv_valid = false;
      $("#<?= $lv_sec; ?> [data-frm]").each(function(){
        lv_aux = lv_req_qty;
        
        // busco si hay una fila sin completar
        $(this).find("table tbody tr").each(function(){ 
          if($(this).find("input[type=radio]").length > 0 && $(this).find("input[type=radio]:checked").length == 0){
          	lv_req_qty++;
            return false;
        	}
        });
        
        // añado clase de error al icono
        if( lv_aux != lv_req_qty ){
        	$(this).find("i:eq(0)").addClass("text-danger");
        }else{
        	$(this).find("i:eq(0)").removeClass("text-danger");
        }
      });
      
      if(lv_req_qty){
        toastr.options.timeOut= 2000;
        toastr.warning( "Complete todos los controles.<br>Incompletos ("+lv_req_qty+")." );
      }else{
        lv_valid = true;
      }
      
      return lv_valid;
    }
    
    // fija los datos del formulario en los campos como JSON
    function <?= $lv_sec; ?>_sve( lp_sec ){ 
      if(!<?= $lv_sec; ?>_checkForm()){ return false; }
      
			var lv_insdat = {"steevtdoccod": $("#<?= $lv_sec; ?> #steevtdoccod").prop("value"),
												"srcobjtyp": "CNS_EVT_FRM",
												"srcobjcod": "1",
                        "srcobjtxt": "CONTROLSEGURIDAD",
                      	"steevtdocatr": ""};
      var lv_frmatr = ""; 
			
      // recorre las secciones del formulario
      $("#<?= $lv_sec; ?> table").each(function(){
      	lv_frmatr += "<"+$(this).parents("[data-frm]").data("frm")+">";
        
        // recorre cada categor&iacute;a
        $(this).find("tbody tr").each(function(){ 
          var lv_val = $(this).find("input:checked").val();
          lv_frmatr += "<"+$(this).data("cat")+">" + lv_val + "</"+$(this).data("cat")+">";
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
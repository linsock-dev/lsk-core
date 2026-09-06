<?php
	// CONFIGURACION: ($vew_data->cfg)
	//  dtetyp: DS-date single / DR-date range / DT-date start (with time)
	//  tmetyp: TS-time single / TR-time range / TF-time frequency 
	//ME QUEDO CON DT,DS Y TF Y AÑADO DF como opcional

	// Planificación de Salud (DR=+ TR=10-11 -> L-M-V)
	// Ejecución de Interfaces (cada 10 minutos, TR=de 20-06, DR=todos los dias)
	// Recordatorios (tareas / crm / general) (DS TS)
	// Horarios HR (...)

	// url del formulario 
  $lv_lnk = '?prg=grldattsk&prm_tskcod='.$vew_data->tskcod;

	// campos requeridos
	$vew_input->RequiredFields( array('grltskstrdte') );

	// clave del documento 
	$lv_dockey = $vew_data->tskcod;

	// titulo 
	$lv_title = $vew_lang->frequency;
	
	// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'TSK';
	
	// libreria de estilos bootstrap
	include_once('_library.frm');

	// array tipos de frecuencia 
	$lv_frqtyptxt = array('U'=>$vew_lang->oneTime, 'D'=>$vew_lang->daily, 'W'=>$vew_lang->weekly, 'M'=>$vew_lang->monthly, 'Y'=>$vew_lang->yearly);
	$lv_frqtyp_arr = array();
 	foreach($vew_data->cfg['frq']??array() as $lv_row){
    if(isset($lv_frqtyptxt[$lv_row])){ $lv_frqtyp_arr[$lv_row] = $lv_frqtyptxt[$lv_row]; }
  }

  //array de frecuencia
  $lv_frqtxt = array('D'=>'day', 'W'=>'week', 'M'=>'month');
  $lv_frqtxt_arr = array('singular'=>array(), 'plural'=>array());
  foreach($vew_data->cfg['frq']??array() as $lv_row){
    if(isset($lv_frqtxt[$lv_row])){
      $lv_sgntxt = $vew_lang->{$lv_frqtxt[$lv_row]};
      $lv_plrtxt = $vew_lang->{$lv_frqtxt[$lv_row].($lv_row!='U'?'S':'')};
      // contiene traducidos los tipos de frecuencia en singular y plural
      $lv_frqtxt_arr['singular'][$lv_row] = html_entity_decode($lv_sgntxt);
      $lv_frqtxt_arr['plural'][$lv_row] = html_entity_decode($lv_plrtxt);
    }
  }    
  $vew_data->tskfrqatr = json_decode( html_entity_decode($vew_data->prvdat), true );
	$vew_readonly = ($vew_data->cfg['readonly'] ?? false);
?>
<section id="<?= $lv_sec; ?>">
	<style>
    [aria-disabled="true"] .frqwekdayW { pointer-events: none; }
		.frqwekdayW:hover, .frqwekdayW.selected{ background-color:#d9edf7; }
		.frqwekdayW { border-radius: 20px; padding: 5px 0px; border: 2px solid #d9edf7; margin-bottom: 2px; margin-right: 2px; cursor: pointer; }
		#<?= $lv_sec; ?> select:disabled, #<?= $lv_sec; ?> input:disabled, #<?= $lv_sec; ?> textarea:disabled { cursor: default; }
	</style>
  <a href="#" class="hidden" id="grldattsksve" onclick="<?= $lv_sec; ?>_serializar();"></a>
  <a href="#" class="hidden" id="btnsubmit" onclick="<?= $lv_sec; ?>_serializar();"></a>
  
	<form method="POST" class="form-horizontal tmss-form-horizontal" name="tskschfrm" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('grldattsk','hidden',''); ?>
    <?= gethtml('cfg','hidden',json_encode($vew_data->cfg)); ?>
    <?= gethtml('submited','hidden',''); ?>

    <div class="container-fluid">
      <?php
        // FECHA (DS-date single / DR-date range / DT-date/time start)
        // dtetyp,strdte,enddte
        // dte_ro???

      //validar si es modalidad U unicamente, si tiene modalidad U  solo muestra fecha de inicio y segun parametro muestra tambien la hora o no 
      //si tiene modalidades diferentes a U muestra el DR 
        if (in_array('U',$vew_data->cfg['frq']??array())){
          $lv_dtetyp = (($vew_data->cfg['dtetyp']??'')=='DS' ? 'DS' : 'DT');
        }else{
           $lv_dtetyp='DR';
        }
        echo '<div data-frqcod="U/D/W/M/Y">';
        switch($lv_dtetyp){
          case 'DT':
            echo vew_boot($lv_colsm255, array('label'=>$vew_lang->start,
              'input1'=>gethtml('grltskstrdte','docdte', ($vew_data->tskfrqatr['strdte']??''), isset($vew_data->cfg['dte_ro'])?$lv_always_disabled:$lv_default),
              'input2'=>gethtml('grltskstrtme','doctme', ($vew_data->tskfrqatr['strtme']??''), isset($vew_data->cfg['dte_ro'])?$lv_always_disabled:$lv_default)));
            break;
          case 'DS':
            echo vew_boot($lv_colsm210, array('label'=>$vew_lang->date, 
              'input'=>gethtml('grltskstrdte','docdte', ($vew_data->tskfrqatr['strdte']??''), isset($vew_data->cfg['dte_ro'])?$lv_always_disabled:$lv_default) ));
            break;
          case 'DR':
            echo vew_boot($lv_colsm255, array('label'=>$vew_lang->period,
              'input1'=>gethtml('grltskstrdte','docdte', ($vew_data->tskfrqatr['strdte']??''), isset($vew_data->cfg['dte_ro'])?$lv_always_disabled:$lv_default),
              'input2'=>gethtml('grltskenddte','docdte', ($vew_data->tskfrqatr['enddte']??''), isset($vew_data->cfg['dte_ro'])?$lv_always_disabled:$lv_default)));
            break;
        }
	      echo '</div>';
      ?>
      
      <!-- Frecuencia -->
      <?php if(count($lv_frqtyp_arr)>0){ ?>
      <div data-frqcod="U/D/W/M/Y">
        <?php
  				//if (!$vew_readonly){
            echo vew_boot($lv_colxs210, array('label'=>$vew_lang->frequency,
                                           		'input'=>gethtml('grltskfrqtyp',$lv_frqtyp_arr, $vew_data->tskfrqatr['frqtyp']??'U', $lv_default, true)));
          //}
          /*else {
            echo vew_boot($lv_colxs210, array('label'=>$vew_lang->frequency,
                                              'input'=>gethtml('grltskfrqtyp','doccmt1x10', $lv_frqtyptxt[$vew_data->tskfrqatr['frqtyp']]??'U', $lv_always_disabled, true))); 	
          }*/
            
        ?>
      </div>
      <?php } ?>
      <div>
        <div data-frqcod="D/W/M/Y">
          <?php
            echo vew_boot($lv_colxs246, array('label1'=>$vew_lang->each,
                                           'input1'=>gethtml('grltskfrqqty','docnum0300', ($vew_data->tskfrqatr['frqqty']??'') != '' ? $vew_data->tskfrqatr['frqqty'] : 1, $lv_default),
                                           'input2'=>'<label id="frqnumtxt" class="control-label text-nowrap"></label>'));
          ?>
        </div>
        <!-- opcion semanal: dias de la semana -->
        <div data-frqcod="W" class="tmss-bold text-center" aria-disabled="<?= $vew_readonly ? 'true' : 'false' ?>">
          <?= gethtml('frqwekday', 'hidden', $vew_data->tskfrqatr['wekday']??''); ?>
          <!-- opcion semanal: dias de la semana -->
          <div class="row col-sm-offset-2">
            <div class="col-xs-2 frqwekdayW"><?= $vew_lang->day001; ?></div>
            <div class="col-xs-2 frqwekdayW"><?= $vew_lang->day002; ?></div>
            <div class="col-xs-2 frqwekdayW"><?= $vew_lang->day003; ?></div>
            <div class="col-xs-2 frqwekdayW"><?= $vew_lang->day004; ?></div>
            <div class="col-xs-2 frqwekdayW"><?= $vew_lang->day005; ?></div>
          </div>
          <div class="row col-sm-offset-2">
            <div class="col-xs-2 frqwekdayW"><?= $vew_lang->day006; ?></div>
            <div class="col-xs-2 frqwekdayW"><?= $vew_lang->day007; ?></div>
          </div>

          <!--<table class="table table-condensed"><thead><tr>
            <?php
              $lv_days = array($vew_lang->day001,$vew_lang->day002,$vew_lang->day003,$vew_lang->day004,$vew_lang->day005,$vew_lang->day006,$vew_lang->day007);

              foreach($lv_days as $lv_row){
                echo '<th class="text-center frqwekdayW cursor-pointer">'.$lv_row.'</th>';
              }
            ?>
          </tr></thead><tbody></tbody></table>-->
        </div>

        <!-- opciones mesnsuales/anuales -->
        <div class="row" data-frqcod="M/Y">
          <div class="col-sm-offset-2 col-sm-10 col-xs-12">
            <table class="table table-condensed table-hover">
              <thead><tr><th colspan="3"><?= $vew_lang->repeat.' '.strtolower($vew_lang->the); ?></th></tr></thead>
              <tbody>
                <tr class="cursor-pointer">
                  <td style="width: 10px; vertical-align: middle;"><input type="radio" name="numorwek" value="num" checked="checked"></td>
                  <td class="cursor-pointer">
                    
                    <?= vew_boot($lv_colsm255, array('label' => $vew_lang->day,
                                                     'input'=>gethtml('grltskdaynum','docnum0300', ($vew_data->tskfrqatr['daynum']??'') != '' ? $vew_data->tskfrqatr['daynum'] : 1, $lv_default))); ?>
                  </td>
                </tr>
                <tr class="cursor-pointer">
                  <td style="width: 10px;vertical-align: middle;"><input type="radio" name="numorwek" value="wek"></td>
                  <td>
                    <?= vew_boot($lv_colxs66, array('input1'=>gethtml('grltskdaytyp',
                                                                         array('1'=>'Primer','2'=>'Segundo','3'=>'Tercer','4'=>'Cuarto','L'=>'Ultimo')
                                                                         ,$vew_data->tskfrqatr['weknum']??'',$lv_default,true),
                                                    'input2'=>gethtml('grltskwekday', 
                                                                         array('2'=>'Lunes','3'=>'Martes','4'=>'Miercoles','5'=>'Jueves','6'=>'Viernes','7'=>'Sabado','1'=>'Domingo', 'L'=>'Dia del mes')
                                                                         ,$vew_data->tskfrqatr['wekday']??'',$lv_default,true) ));
                    ?>
                  </td>
                </tr>
                <!-- opciones anuales -->
                <tr class="text-center" data-frqcod="Y">
                  <td><?= $vew_lang->month; ?></td>
                  <td></td>
                  <td>
                    <?= vew_boot($lv_colxs66, array('input'=>gethtml('grltskfrqmth',
                        array('1'=>'Enero','2'=>'Febrero','3'=>'Marzo','4'=>'Abril','5'=>'Mayo','6'=>'Junio','7'=>'Julio','8'=>'Agosto','9'=>'Septiembre','10'=>'Octubre','11'=>'Noviembre','12'=>'Diciembre')
                        ,$vew_data->tskfrqatr['mth']??'',$lv_default))); ?>
                  </td>
                </tr>
              </tbody>
            </table>        
          </div>  
        </div>
        <?php
        // HORA (TS-time single/ TF-time frequency)
        $lv_tmetyp = ($vew_data->cfg['tmetyp']??'');
        if($lv_tmetyp=='TF'){
          echo vew_boot($lv_colsm2424, array('label'=>$vew_lang->repeateach,
                                           'input'=>gethtml('grltsktmerpt',array(''=>'','5'=>'5 minutos','10'=>'10 minutos','15'=>'15 minutos','30'=>'30 minutos','45'=>'45 minutos','60'=>'1 hora','180'=>'3 horas','360'=>'6 horas'),$vew_data->tskfrqatr['frqtmeqty']??'', (isset($vew_data->cfg['dte_ro'])?$lv_always_disabled:$lv_default)) ));
          echo vew_boot($lv_colsm255,array('label1'=>$vew_lang->schedule, 'input1'=>gethtml('grlfrqstrtme','doctme', $vew_data->tskfrqatr['frqstrtme']??'',  (isset($vew_data->cfg['dte_ro'])?$lv_always_disabled:$lv_default)),
                                            'input2'=>gethtml('grlfrqendtme','doctme', $vew_data->tskfrqatr['frqendtme']??'',  (isset($vew_data->cfg['dte_ro'])?$lv_always_disabled:$lv_default)) ));
        }
        if($lv_dtetyp!='DR' ){
          echo '<div data-frqcod="D/W/M/Y">';
          echo vew_boot($lv_colsm255, array('label'=>$vew_lang->endson,
                                        'input1'=>gethtml('grltskenddte','docdte', ($vew_data->tskfrqatr['enddte']??''), isset($vew_data->cfg['dte_ro'])?$lv_always_disabled:$lv_default),
                                        'input2'=>gethtml('grltskendtme','doctme', ($vew_data->tskfrqatr['endtme']??''), isset($vew_data->cfg['dte_ro'])?$lv_always_disabled:$lv_default)));
          echo '</div>';
        }
      ?>
      </div>
    </div>
    
    
  </form>
  <script>
    $(document).ready(function() {
      // paso el booleano de PHP a una variable de JavaScript
      var lv_isreadonly = <?= $vew_readonly ? 'true' : 'false' ?>;

      if (lv_isreadonly) {
        // deshabilito el select de frecuencia para que no se pueda cambiar su valor
        $("#<?= $lv_sec; ?> select").prop('disabled', true);
      }
    });
    
    function <?= $lv_sec; ?>_serializar(){
			$("#<?= $lv_sec; ?> #submited").prop("value","X");
      // objeto de tags e inputs en donde buscar sus respectivos datos
      // frqtyp indica a la frecuencia que corresponde el tag
      // applies indica que el dato se solicita por config de la vista
      var lv_frqfld = {frqqty: 		{input: "grltskfrqqty", frqtyp:"D/W/M/Y"},
                       frqtmeqty:	{input: "grltsktmerpt", frqtyp:"U/D/W/M/Y"},
                       wekday: 		{input: "frqwekday", 		frqtyp:"W/M/Y",	opt:"wek"},
                       daynum: 		{input: "grltskdaynum", frqtyp:"M/Y", 	opt:"num"},
                       weknum: 		{input: "grltskdaytyp", frqtyp:"M/Y",		opt:"wek"},
                       //mth: 			{input: "grltskfrqmth", frqtyp:"Y"},
                       strdte: 		{input: "grltskstrdte", frqtyp:"U/D/W/M/Y"},
                       enddte: 		{input: "grltskenddte", frqtyp:"D/W/M/Y"},
                       strtme: 		{input: "grltskstrtme", frqtyp:"U/D/W/M/Y"},
                       endtme: 		{input: "grltskendtme", frqtyp:"U/D/W/M/Y"},
                       frqstrtme: {input: "grlfrqstrtme", frqtyp:"U/D/W/M/Y"},
                       frqendtme: {input: "grlfrqendtme",	frqtyp:"U/D/W/M/Y"}                      
                      };
      
      var lv_frqdat = {frqtyp: $("#<?= $lv_sec; ?> #grltskfrqtyp").val()};
      var lv_frqdattag = "";
      
      // añade datos a la frecuencia según corresponda
      for(const [key, value] of Object.entries(lv_frqfld)){
        if((value["frqtyp"]!=undefined && value["frqtyp"].indexOf(lv_frqdat["frqtyp"]) != -1) || (value["applies"]!=undefined && value["applies"])){ 
          if(value["opt"]==undefined || lv_frqdat["frqtyp"]=="W" || $("#<?= $lv_sec; ?> [name=numorwek]:checked").val() == value["opt"]){
        		lv_frqdat[key] = ($("#<?= $lv_sec; ?> #"+value["input"]).val() != undefined ? $("#<?= $lv_sec; ?> #"+value["input"]).val() : "") ;
          }
        }
      }
      
      lv_frqdattag = JSON.stringify(lv_frqdat);
      $("#<?= $lv_sec; ?> #grldattsk").val(lv_frqdattag);
    }

    //muestra y oculta las opciones que varían según la frecuencia seleccionada
    function <?= $lv_sec; ?>_showFrequencyOptions(lp_frqcod){
      $("#<?= $lv_sec; ?> [data-frqcod*="+lp_frqcod+"]").removeClass("hidden");
      $("#<?= $lv_sec; ?> [data-frqcod]:not([data-frqcod*="+lp_frqcod+"])").addClass("hidden");
    }
		
    // coloca los días seleccionados en formato DLMMJVS
    function <?= $lv_sec; ?>_updWekDay(){
      var lv_wekday = "";
      var lv_frqtyp = $("#<?= $lv_sec; ?> #grltskfrqtyp").val();
      
      if(lv_frqtyp == "W"){
        $("#<?= $lv_sec; ?> .frqwekdayW").each(function(){
          lv_wekday+=($(this).hasClass("selected") ? "1" :"0"); 
        });
        lv_wekday = lv_wekday.substring(lv_wekday.length-1) + lv_wekday.substring(0, lv_wekday.length-1);
      }else if(lv_frqtyp == "M" || lv_frqtyp == "Y"){
        if( $("#<?= $lv_sec; ?> #grltskwekday").val() =="L"){
          lv_wekday = "L";
        }else{
        	lv_wekday = "0000000".substring(0, $("#<?= $lv_sec; ?> #grltskwekday").val()-1) + "1" + "0000000".substring($("#<?= $lv_sec; ?> #grltskwekday").val());
        }
      }
      
      $("#<?= $lv_sec; ?> #frqwekday").val(lv_wekday);
    }
  </script>
  <script>    
    $(function(){
      $("#<?= $lv_sec; ?> [type=number]").attr("min", 1);
      
      // mostrar configuración para el tipo de frecuencia seleccionado
      var lv_frqtyp = $("#<?= $lv_sec; ?> #grltskfrqtyp").val();
      <?= $lv_sec; ?>_showFrequencyOptions( lv_frqtyp );
      
      // marca (visualmente) los días seleccionados, si había datos previos
      var lv_wekday = $("#<?= $lv_sec; ?> #frqwekday").val();
      if(lv_wekday != '' && lv_wekday != '0000000'){ 
        if(lv_frqtyp == "W"){
          // roto a izquierda los días (DLMMJVS -> LMMJVSD)
          lv_wekday = lv_wekday.substring(1) + lv_wekday.substring(0,1);
          
          // marco los días
          $("#<?= $lv_sec; ?> .frqwekdayW").each(function(i){
            $(this).toggleClass("selected", lv_wekday.substring(i, i+1) == '1');
          });
      	}else{ 
          $("#<?= $lv_sec; ?> #grltskwekday").val(lv_wekday == "L" ? "L": lv_wekday.indexOf("1") + 1);
          $("#<?= $lv_sec; ?> [name=numorwek][value=wek]").prop("checked", "checked"); 
        }
      }
			
			$("#<?= $lv_sec; ?> #grltskdaytyp").trigger("change");
      $("#<?= $lv_sec; ?> #grltskfrqqty").trigger("change");
			<?= $lv_sec; ?>_updWekDay();
    });

    // marca un radio button cuando se clickea sobre la fila que lo contiene
		$("#<?= $lv_sec; ?> :radio").parents("tr").on("click", function(e){ 
      $(this).find(":radio").prop("checked", "checked");
    });
		    
    // FRECUENCIA. al cambiar
    $("#<?= $lv_sec; ?> #grltskfrqtyp").on("change", function(e){
      lv_frqtxt_arr=<?= json_encode($lv_frqtxt_arr['singular'])?>;
      $("#<?= $lv_sec; ?> #frqnumtxt").text(lv_frqtxt_arr[$(this).val()]);
      $("#<?= $lv_sec; ?> #grltskfrqqty").val(1);
    	<?= $lv_sec; ?>_showFrequencyOptions($(this).val() );
      <?= $lv_sec; ?>_updWekDay();      
    });
    		
  	$("#<?= $lv_sec; ?> #grltskdaytyp").on("change", function(e){ 
      $("#<?= $lv_sec; ?> #grltskwekday").find("option[value='L']").toggleClass("hidden", $(this).val() != "L");
      if($(this).val() != "L" && $("#<?= $lv_sec; ?> #grltskwekday").val() == "L"){
      	$("#<?= $lv_sec; ?> #grltskwekday").val("2");
      }
    });

    // cambia texto de plural a singular y viceversa 
    $("#<?= $lv_sec; ?> #grltskfrqqty").on("change", function(e){ 
      var lv_select = "";
      var lv_translation = $("#<?= $lv_sec; ?> #grltskfrqtyp").data("translation") == undefined ? "" : $("#<?= $lv_sec; ?> #grltskfrqtyp").data("translation");
      var lv_val = $("#<?= $lv_sec; ?> [data-frqcod]:not(.hidden) #grltskfrqtyp").val();
      
      if($(this).val() == 1 && (lv_translation=="plural" || lv_translation=="")){
        lv_frqtxt_arr=<?= json_encode($lv_frqtxt_arr['singular']??'')?>;
        $("#<?= $lv_sec; ?> #frqnumtxt").text(lv_frqtxt_arr[lv_val]);
        
      }else if($(this).val() > 1 && (lv_translation=="singular" || lv_translation=="")){
        lv_frqtxt_arr=<?= json_encode($lv_frqtxt_arr['plural']??'')?>;
        $("#<?= $lv_sec; ?> #frqnumtxt").text(lv_frqtxt_arr[lv_val]);
       
      }
    });
    
    // selecciona / deselecciona día en frecuencia semanal
    $("#<?= $lv_sec; ?> .frqwekdayW").on("click", function(){
      $(this).toggleClass("selected");
      <?= $lv_sec; ?>_updWekDay();
    });
    
    // actualiza los días cuando cambia la frecuencia o se selecciona otro día (caso mes o año)
    $("#<?= $lv_sec; ?> #grltskwekday").on("change", function(){
      <?= $lv_sec; ?>_updWekDay();
    });
  </script>
  <script>
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if ( lp_prm["action"]=="00" ) { <?= $lv_sec; ?>_serializar();}
		}
  </script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
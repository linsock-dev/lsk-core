<?php
	/* url del formulario */
  $lv_lnk = '?prg=sysdocwrk&prm_wrkflwcod='.$vew_data->wrkflwcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('wrkflwtxt', 'docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->wrkflwcod;

	/* titulo */
	$lv_title = $vew_lang->workflow;

	/* m�dulo y programa */
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'WRK';

	/* librer�a de estilos bootstrap */
	include_once('_library.frm');

	$lv_acttyp_arr = array('NTF_SOL' => 'Notificar a Solicitante',
                         'NTF_APR' => 'Notificar a Aprobadores Previos',
                         'NTF_ALL' => 'Notificar a Todos los usuarios de la cadena',
                         'NTF_USR' => 'Notificar a usuarios específicos',
                         'DOC_UPD' => 'Actualizar informacion del documento',
                         'ZCU' => 'Personalizada',
                         'DOC_APR' => 'Aprobar Workflow',
                         'DOC_REJ' => 'Rechazar Workflow');

	// arma array con datos de pasos
	$lv_stp_arr = array();
  if($vew_data->sysdocwrkstp != ''){
    $i = 0;
    foreach($vew_data->sysdocwrkstp as $lv_row){
      $j = 0;
      $lv_stp_arr[$i] = array('wrkflwstpcod' => $lv_row['wrkflwstpcod'],
                              'code' => $i,
                              'wrkflwstprow' => $lv_row['wrkflwstprow'],
                              'wrkflwstpfrmcod' => $lv_row['wrkflwstpfrmcod'],
                              'wrkflwstpfrmtxt' => $lv_row['wrkflwstpfrmtxt'],
                              'wrkflwstptxt' => ( isset($lv_row['wrkflwstptxt']) ? $lv_row['wrkflwstptxt'] : $lv_row['wrkflwstprow'] ),
                              'wrkflwstpcndtyp' => $vew_doc->getTagValue($lv_row['wrkflwstpcnd'],'typ'),
                              'wrkflwstpcndval' => $vew_doc->getTagValue($lv_row['wrkflwstpcnd'],'val'),
                              'wrkflwstpres' => array(),
                             	'wrkflwstpactdel' => array());
      
      // acciones
      $lv_act = array();
      $lv_stp_arr[$i]['wrkflwstpactstr'] = array();
      $lv_stp_arr[$i]['wrkflwstpactrel'] = array();
      $lv_stp_arr[$i]['wrkflwstpactrej'] = array();
      $lv_stp_arr[$i]['wrkflwstpres'] = array();

      foreach($vew_data->sysdocwrkact as $lv_row2){
				if($lv_row['wrkflwstpcod']==$lv_row2['wrkflwstpcod']){
					$lv_act = array('wrkflwactcod' => $lv_row2['wrkflwactcod'],
													'wrkflwacttyp' => $lv_row2['wrkflwacttyp'],
													'wrkflwacttyptxt' => (isset($lv_acttyp_arr[$lv_row2['wrkflwacttyp']]) ? $lv_acttyp_arr[$lv_row2['wrkflwacttyp']] : ''),
													'wrkflwactval' =>$lv_row2['wrkflwactval'] );
					switch($lv_row2['wrkflwactevt']){
						case 'STR': array_push($lv_stp_arr[$i]['wrkflwstpactstr'], $lv_act); break;
						case 'REL': array_push($lv_stp_arr[$i]['wrkflwstpactrel'], $lv_act); break;
						case 'REJ': array_push($lv_stp_arr[$i]['wrkflwstpactrej'], $lv_act); break;
					}
				}
      }
      // responsables
      while($vew_doc->getTagValue($lv_row['wrkflwstpatr'],'res'.$j) != ''){
      	$lv_tmp = $vew_doc->getTagValue($lv_row['wrkflwstpatr'], 'res'.$j);
        array_push( $lv_stp_arr[$i]['wrkflwstpres'], 
                   array('wrkflwstprestyp' => ($vew_doc->getTagValue($vew_doc->getTagValue($lv_row['wrkflwstpatr'], 'res'.$j), 'typ') == 'USR' ? $vew_lang->user : $vew_lang->rol),
                        'wrkflwstpresval' => $vew_doc->getTagValue($vew_doc->getTagValue($lv_row['wrkflwstpatr'], 'res'.$j), 'val')));
        $j++;
      }
      
      $i++;
    }
  }
?>
<style>
  .tmssElementPlaced{ width: 100%; height: 60px; display:table; margin: 2px; border-radius: 30px; cursor: pointer; }
  .tmssElementDropable{ flex-grow: 1; display: flex; flex-flow: column; overflow-x: visible; padding: 15px 0px 15px 0px; align-items: center; }
  .tmss-blue-border.tmssStep, .tmssStep:hover{ border: 2px solid #2fa4e7; background-color: #efefef; }
  .tmssStep{ display: flex; justify-content: center; align-items: center; text-align: center; padding: 10px; border: 1px solid #2fa4e7; }
  .tmss-blue-border{ border: 1px solid #2fa4e7; }
  .tmssTruncatedText{ overflow: hidden; white-space: nowrap; text-overflow: ellipsis; }
</style>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <textarea id="wrkflwstp" name="wrkflwstp" class="hidden"></textarea>
    <textarea id="wrkflwact" name="wrkflwact" class="hidden"></textarea>
    
    <div class="container-fluid" role="tabpanel">
      <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->wrkflwcod; ?><?= gethtml('wrkflwcod', 'hidden', $vew_data->wrkflwcod); ?></strong></h4></li>
			</ul>
      
      <div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
            
            <div class="col-md-5 col-sm-12">
              <!-- WORKFLOW -->
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->workflow; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('wrkflwcodext','doccmt1x20', $vew_data->wrkflwcodext, $lv_default) )); ?>
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('wrkflwtxt', 'doccmt1x50', $vew_data->wrkflwtxt, $lv_default) )); ?>
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); ?>
						
                  <!-- CONDITION -->
                  <div class="form-group tmss-form-group">
                    <label class="col-sm-2 control-label text-nowrap"><?= $vew_lang->condition; ?></label>
                    <div class="col-sm-10">
                      <?= vew_boot($lv_col210, array('label'=>$vew_lang->type, 'input'=>gethtml('wrkflwcndtyp', [''=>'','FOR'=>'F&oacute;rmula', 'ZCU'=>'Personalizada'], $vew_doc->getTagValue($vew_data->wrkflwcnd, 'typ'), $lv_default) )); ?>
                      <?= vew_boot($lv_col210, array('label'=>$vew_lang->value, 'input'=>gethtml('wrkflwcndval', 'doccmt1x250', $vew_doc->getTagValue($vew_data->wrkflwcnd, 'val'), $lv_default) )); ?>
                    </div>
                  </div>
                  
                  <!-- START -->
                  <div class="form-group tmss-form-group">
                    <label class="col-sm-12 control-label text-nowrap">
                      <span class="pr-5"><?= $vew_lang->start; ?></span>
                      <a href="#" class="btnwrkflwshwtbl pull-left tmss-pr-10 tmssAlwaysEnabled" data-tbl="wrkflwstrhot"><i class="fas fa-chevron-down"></i></a>
                    </label>
                    <div class="col-sm-12">
                      <div id="wrkflwstrhot" name="wrkflwstrhot" class="hide"></div>
                    </div>
                  </div>
                  
                  <!-- RELEASE -->
                  <div class="form-group tmss-form-group">
                    <label class="col-sm-12 control-label text-nowrap">
                      <span class="pr-5"><?= $vew_lang->release; ?></span>
                      <a href="#" class="btnwrkflwshwtbl pull-left tmss-pr-10 tmssAlwaysEnabled" data-tbl="wrkflwrelhot"><i class="fas fa-chevron-down"></i></a>
                    </label>
                    <div class="col-sm-12">
                      <div id="wrkflwrelhot" name="wrkflwrelhot" class="hide"></div>
                    </div>
                  </div>
                  
                  <!-- REJECTION -->
                  <div class="form-group tmss-form-group">
                    <label class="col-sm-12 control-label text-nowrap">
                      <span class="pr-5"><?= $vew_lang->rejection; ?></span>
                      <a href="#" class="btnwrkflwshwtbl pull-left tmss-pr-10 tmssAlwaysEnabled" data-tbl="wrkflwrejhot"><i class="fas fa-chevron-down"></i></a>
                    </label>
                    <div class="col-sm-12">
                      <div id="wrkflwrejhot" name="wrkflwrejhot" class="hide"></div>
                    </div>
                  </div>
                  
                </div>
              </div>
            </div> <!-- col -->
            
            
            <div class="col-md-2 col-sm-4">
              <!-- STEPS -->
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->steps; ?>
                    <a href="#" id="btnaddstp" class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" title="<?= $vew_lang->add; ?>"><i class="fas fa-plus"></i></a>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit tmssForm">
                  <div class="tmssElementDropable">
                    <?php
                    if(is_array($vew_data->sysdocwrkstp)){
                       foreach($vew_data->sysdocwrkstp as $lv_key=>$lv_row){ 
                        echo '<div class="tmssStep tmssElementPlaced" data-code='.$lv_key.' data-wrkflwstpcod='.$lv_row['wrkflwstpcod'].' data-wrkflwstprow='.$lv_row['wrkflwstprow'].'><span class="tmssTruncatedText">'.$lv_row['wrkflwstptxt'].'</span></div>';
                      }
                    }
                    ?>
                  </div>
                </div>
              </div>
            </div> <!-- col -->
            
            
            <div class="col-md-5 col-sm-8">
            	<!-- ATTRIBUTES -->
              <div class="card tmssStepAttributes">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->attributes; ?> <span id="wrkflwstprow"></span> </div>
                </div>
                <div class="card-body tmss-card-body-edit hidden">
                  <?php
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('wrkflwstptxt','doccmt1x50', $vew_data->wrkflwstptxt, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=> $vew_lang->form, 
                                                    'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                        array('input'=>gethtml('wrkflwstpfrmtxt', 'typeahead', '' ,$lv_default) ))
                                                    ));
										echo gethtml( 'wrkflwstpfrmcod', 'hidden', '' );
                  ?>
                  
                  <!-- CONDITION -->
                  <div class="form-group tmss-form-group">
                    <label class="col-sm-2 control-label text-nowrap"><?= $vew_lang->condition; ?></label>
                    <div class="col-sm-10">
                      <?php
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->type,	'input'=>gethtml('wrkflwstpcndtyp', [''=>'','FOR'=>'F&oacute;rmula', 'ZCU'=>'Personalizada'], '', $lv_default) ));
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->value,	'input'=>gethtml('wrkflwstpcndval', 'doccmt1x250', '', $lv_default) ));
                      ?>
                    </div>
                  </div>
                  
                  <!-- START -->
                  <div class="form-group tmss-form-group">
                    <label class="col-sm-12 control-label text-nowrap">
                      <span class="pr-5"><?= $vew_lang->start; ?></span>
                      <a href="#" class="btnstpshwtbl pull-left tmss-pr-10 tmssAlwaysEnabled" data-tbl="stpstrhot"><i class="fas fa-chevron-down"></i></a>
                    </label>
                    <div class="col-sm-12">
                      <div id="stpstrhot" name="stpstrhot" class="hide"></div>
                    </div>
                  </div>
                  
                  <!-- RELEASE -->
                  <div class="form-group tmss-form-group">
                    <label class="col-sm-12 control-label text-nowrap">
                      <span class="pr-5"><?= $vew_lang->release; ?></span>
                      <a href="#" class="btnstpshwtbl pull-left tmss-pr-10 tmssAlwaysEnabled" data-tbl="stprelhot"><i class="fas fa-chevron-down"></i></a>
                    </label>
                    <div class="col-sm-12">
                      <div id="stprelhot" name="stprelhot" class="hide"></div>
                    </div>
                  </div>
                  
                  <!-- REJECTION -->
                  <div class="form-group tmss-form-group">
                    <label class="col-sm-12 control-label text-nowrap">
                      <span class="pr-5"><?= $vew_lang->rejection; ?></span>
                      <a href="#" class="btnstpshwtbl pull-left tmss-pr-10 tmssAlwaysEnabled" data-tbl="stprejhot"><i class="fas fa-chevron-down"></i></a>
                    </label>
                    <div class="col-sm-12">
                      <div id="stprejhot" name="stprejhot" class="hide"></div>
                    </div>
                  </div>
                  
                  <!-- RESPONSIBLES -->
                  <div class="form-group tmss-form-group">
                    <label class="col-sm-12 control-label text-nowrap">
                      <span class="pr-5"><?= $vew_lang->responsible; ?></span>
                      <a href="#" class="btnstpshwtbl pull-left tmss-pr-10 tmssAlwaysEnabled" data-tbl="stpreshot"><i class="fas fa-chevron-down"></i></a>
                    </label>
                    <div class="col-sm-12">
                      <div id="stpreshot" name="stpreshot" class="hide"></div>
                    </div>
                  </div>
                  
                  <!-- DELETE -->
                  <div class="col-sm-12 tmssHiddeOnRead">
                    <div class="text-center">
                      <div class="btn btn-danger" id="btnrmvstp"><i class="far fa-times"></i><span> <?= $vew_lang->delete; ?></span></div>
                    </div>
                  </div>
                  
                </div>
              </div>
            </div> <!-- col -->
            
          </div>
				</div>
      </div>
    </div>
  </form>
  <script> 
    // Tipos de acciones
    var <?= $lv_sec; ?>_gv_acttyp_arr = <?= json_encode($lv_acttyp_arr); ?> 
        
    // Recupero atributos de los pasos
		var <?= $lv_sec; ?>_gv_stpatr_arr = [<?php
				$lv_buffer='';
				foreach($lv_stp_arr as $lv_row){ 
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
											'wrkflwstpcod:"'.$lv_row['wrkflwstpcod'].'",'.
											'code:"'.$lv_row['code'].'",'.
											'wrkflwstprow:'.$lv_row['wrkflwstprow'].','.
											'wrkflwstpfrmcod:'.$lv_row['wrkflwstpfrmcod'].','.
											'wrkflwstpfrmtxt:`'.$lv_row['wrkflwstpfrmtxt'].'`,'.
											'wrkflwstptxt:`'.$lv_row['wrkflwstptxt'].'`,'.
											'wrkflwstpcndtyp:"'.$lv_row['wrkflwstpcndtyp'].'",'.
											'wrkflwstpcndval:"'.$lv_row['wrkflwstpcndval'].'",'.
											'wrkflwstpres:`'.json_encode($lv_row['wrkflwstpres']).'`,'.
											'wrkflwstpactdel:`'.json_encode($lv_row['wrkflwstpactdel']).'`,'.
											'wrkflwstpactstr:`'.json_encode($lv_row['wrkflwstpactstr']).'`,'.
											'wrkflwstpactrel:`'.json_encode($lv_row['wrkflwstpactrel']).'`,'.
											'wrkflwstpactrej:`'.json_encode($lv_row['wrkflwstpactrej']).'`'.
											'}'; 
										}
				echo $lv_buffer;
			?>];
    $.each(<?= $lv_sec; ?>_gv_stpatr_arr, function(i, elem){
      elem["wrkflwstpres"] = JSON.parse(elem["wrkflwstpres"]);
      elem["wrkflwstpactdel"] = JSON.parse(elem["wrkflwstpactdel"]);
      elem["wrkflwstpactstr"] = JSON.parse(elem["wrkflwstpactstr"]);
      elem["wrkflwstpactrel"] = JSON.parse(elem["wrkflwstpactrel"]);
      elem["wrkflwstpactrej"] = JSON.parse(elem["wrkflwstpactrej"]);
    });
  </script>
  <script>
    // SELECCIÓN DE PASO ---------------------------------------------------------------------------------------------------------------
    $("#<?= $lv_sec; ?>").on("click", ".tmssStep", function(e){
      <?= $lv_sec; ?>_addHighlight( $(this) );
      <?= $lv_sec; ?>_showAttributes( $($("#<?= $lv_sec; ?> .tmss-blue-border")[0]) );
    });
    // ---------------------------------------------------------------------------------------------------------------------------------
    
    <?php if( !$vew_readonly ){ ?>  
    // SORTABLE PASOS ------------------------------------------------------------------------------------------------------------------
    tmssLoadScript("jquery-ui", function(){
      $("#<?= $lv_sec; ?> .tmssElementDropable").sortable({
        containment: ".tmssForm",
        scroll: false,
        cursorAt: {top:20},
        start: function(event, ui){
          //acomoda el placeholder del elemento
          ui.placeholder.removeClass("tmssStep");
          ui.placeholder.removeClass("tmss-blue-border");
          ui.placeholder.addClass("ui-state-highlight");
          ui.placeholder.css("width", ui.item.width);
          ui.placeholder.css("visibility", "visible");
        },
        stop: function(event, ui){
          // acomoda el placeholder del elemento
          ui.placeholder.css("visibility", "hidden");

          // marca el elemento seleccionado
          <?= $lv_sec; ?>_addHighlight( ui.item );
          
          // cambio los números de los pasos
          $("#<?= $lv_sec; ?> .tmssStep").each(function(i, elem){
            var lv_ind = <?= $lv_sec; ?>_gv_stpatr_arr.findIndex(function(stp){ return stp.code == $(elem).data("code"); });
            <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]["wrkflwstprow"] = i+1;
            $(elem).data("wrkflwstprow", i+1);
          });
          
          // cambio el número de paso en la tarjeta de atributos
          $("#<?= $lv_sec; ?> #wrkflwstprow").text(" - <?= $vew_lang->step; ?> "+ ui.item.data("wrkflwstprow"));
        }
      });
    });
    // ---------------------------------------------------------------------------------------------------------------------------------
    
    // AGREGAR / QUITAR PASOS ----------------------------------------------------------------------------------------------------------
    $("#<?= $lv_sec; ?> #btnaddstp").click(function(e){ 
      e.preventDefault; 
      $("#<?= $lv_sec; ?> .tmssStepAttributes .card-body").removeClass("hidden");
      <?= $lv_sec; ?>_addStep();
      <?= $lv_sec; ?>_addHighlight( $("#<?= $lv_sec; ?> .tmssStep:last-child") );
    });

    $("#<?= $lv_sec; ?> #btnrmvstp").click(function(e){
      e.preventDefault; 
      <?= $lv_sec; ?>_removeStep($("#<?= $lv_sec; ?> .tmss-blue-border"));
    });
    
    function <?= $lv_sec; ?>_addStep(){ 
      // armo estructura de datos para el paso
      var lv_row = $("#<?= $lv_sec; ?> .tmssStep").length + 1;
      var lv_stp = $("<div class='tmssStep tmssElementPlaced' data-code="+ lv_row + " data-wrkflwstpcod='' data-wrkflwstprow='"+lv_row+"'><span class='tmssTruncatedText'>"+lv_row+"</span></div>");
      <?= $lv_sec;?>_gv_stpatr_arr.push({code: lv_row,
                                         wrkflwstpcod: "", 
                                         wrkflwstprow: lv_row, 
                                         wrkflwstptxt: lv_row,
                                         wrkflwstpfrmtxt: "",
                                         wrkflwstpfrmcod: "",
                                         wrkflwstpcndtyp: "",
                                         wrkflwstpcndval: "",
                                         wrkflwstpactstr:[], 
                                         wrkflwstpactrel:[], 
                                         wrkflwstpactrej:[], 
                                         wrkflwstpres:[]
                                        });
      
      // presentación: vacío atributos, coloco nro de paso y agrego paso a la lista
      $("#<?= $lv_sec; ?> .tmssStepAttributes").hide();
      
      $("#<?= $lv_sec; ?> #wrkflwstprow").text(" - <?= $vew_lang->step; ?> " + lv_row);
      
      $.each(
        <?= $lv_sec;?>_gv_stpatr_arr[<?= $lv_sec;?>_gv_stpatr_arr.length - 1], 
        function(prop){ 
          if(prop != "wrkflwstprow"){
            $("#<?= $lv_sec; ?> #" + prop).val(<?= $lv_sec;?>_gv_stpatr_arr[<?= $lv_sec;?>_gv_stpatr_arr.length - 1][prop]);
          }
      });
      
      <?= $lv_sec; ?>_hotstpstr.loadData(new Array());
			<?= $lv_sec; ?>_hotstprel.loadData(new Array());
			<?= $lv_sec; ?>_hotstprej.loadData(new Array());
			<?= $lv_sec; ?>_hotres.loadData(new Array());
      
      $("#<?= $lv_sec; ?> .tmssElementDropable").append(lv_stp);
      $("#<?= $lv_sec; ?> .tmssStepAttributes").show();
    }
    
    
    function <?= $lv_sec; ?>_removeStep(lp_stp){ 
      var lv_ind = <?= $lv_sec; ?>_gv_stpatr_arr.findIndex(function(stp){ return stp.wrkflwstpcod == lp_stp.data("wrkflwstpcod"); });
      
      BootstrapDialog.confirm({
        title: 'Borrar paso',
        message: '¿Desea borrar el paso '+<?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]['wrkflwstptxt']+'?',
        type: BootstrapDialog.TYPE_WARNING,
        callback: function(result) {
          if(result) {
            // quita el paso del listado y pone deleted en el array
            <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]["deleted"] = "X";
            lp_stp.remove();

            // si hay pasos, muestra los atributos del primer paso 
            if($("#<?= $lv_sec; ?> .tmssStep").length > 0){
              <?= $lv_sec; ?>_addHighlight( $($("#<?= $lv_sec; ?> .tmssStep")[0]) );
              <?= $lv_sec; ?>_showAttributes( $($("#<?= $lv_sec; ?> .tmssStep")[0]) );
            }else{
              // oculta los atributos
              $("#<?= $lv_sec; ?> .tmssStepAttributes .card-body").addClass("hidden");
              $("#<?= $lv_sec; ?> #wrkflwstprow").text("");
            }
          }
        }
			});
    }
    // ---------------------------------------------------------------------------------------------------------------------------------
    <?php } ?>  
    
  	function <?= $lv_sec; ?>_addHighlight( lp_step ){
      $("#<?= $lv_sec; ?> .tmss-blue-border").removeClass("tmss-blue-border");
      lp_step.addClass("tmss-blue-border");
    }
     
    // MOSTRAR ATRIBUTOS DE PASOS ----------------------------------------------------------------------------------------------------
    function <?= $lv_sec; ?>_showAttributes( lp_step ){ 
      // busco atributos del paso a mostrar 
      var lo_atr = <?= $lv_sec; ?>_gv_stpatr_arr.find(function(elem){ return elem.code == lp_step.data("code"); });
      var lo_atrkey_arr = Object.keys(lo_atr);
      
      // coloco el valor de los atributos en los campos
      for(var i = 0; i < lo_atrkey_arr.length; i++){
        $("#<?= $lv_sec; ?> #" + lo_atrkey_arr[i]).val(lo_atr[lo_atrkey_arr[i]]);
      }
      
      $("#<?= $lv_sec; ?> #wrkflwstprow").text(" - <?= $vew_lang->step; ?> " + lp_step.data("wrkflwstprow"))
      
			<?= $lv_sec; ?>_hotstpstr.loadData( lo_atr['wrkflwstpactstr'].slice() );
			<?= $lv_sec; ?>_hotstprel.loadData( lo_atr['wrkflwstpactrel'].slice() );
			<?= $lv_sec; ?>_hotstprej.loadData( lo_atr['wrkflwstpactrej'].slice() ); 
			<?= $lv_sec; ?>_hotres.loadData( lo_atr['wrkflwstpres'].slice() );
      
      $("#<?= $lv_sec; ?> .tmssStepAttributes .card-body").removeClass("hidden");
    }
    // ---------------------------------------------------------------------------------------------------------------------------------
  </script>
  <script>
		var <?= $lv_sec; ?>_gv_hotact_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      if(prop == "wrkflwacttyp"){
        Handsontable.renderers.DropdownRenderer.apply(this, arguments);
      } else {
      	Handsontable.renderers.TextRenderer.apply(this, arguments);
      }
      
      td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
		};
  </script>
  <script>
    /**
		 * 
		 *	A C C I O N E S    D E    I N I C I O ( W O R K F L O W )
		 *
		 */
		var <?= $lv_sec; ?>_hotstrerr = [];
		var <?= $lv_sec; ?>_hotstrdel = [];
		var <?= $lv_sec; ?>_hotstrcnt = $("#<?= $lv_sec; ?> #wrkflwstrhot")[0];
		var <?= $lv_sec; ?>_hotstrset = {
			height: 198,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
      colHeaders: [ "<?= $vew_lang->type; ?>","<?= $vew_lang->value; ?>"],
			columns: [
        {type: "dropdown", data: "wrkflwacttyptxt", width: 30, renderer: <?= $lv_sec; ?>_gv_hotact_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, 
         source: Object.values(<?= $lv_sec; ?>_gv_acttyp_arr) },
        {type: "text", data: "wrkflwactval", width: 40, renderer: <?= $lv_sec; ?>_gv_hotact_renderer <?= ($vew_readonly?', readOnly: true':'');	?> }
			],
      beforeChange : function(changes, source) {
        if (changes && changes.length){
					if (changes[0][1]=="wrkflwacttyptxt") {
						var lv_value = changes[0][3];
            changes.push([ changes[0][0], "wrkflwacttyp", "", Object.keys(<?= $lv_sec; ?>_gv_acttyp_arr).find(function(key){ return <?= $lv_sec; ?>_gv_acttyp_arr[key] === changes[0][3]; })]);
					}
        }
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotstr.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["wrkflwactcod"]!="" && lv_dat[i]["wrkflwactcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotstrdel.push( lv_dat[i] );
					}
				}
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotstrerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotstrerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotstrerr.splice(lv_inx,1); }
				}
			}
		};
		var <?= $lv_sec; ?>_hotstr;
		tmssLoadScript("handsontable",function(){ 
			<?= $lv_sec; ?>_hotstr = new Handsontable(<?= $lv_sec; ?>_hotstrcnt, <?= $lv_sec; ?>_hotstrset);
			var lv_dat = [<?php
				$lv_buffer='';
        if($vew_data->sysdocwrkact != ''){ 
          foreach($vew_data->sysdocwrkact as $lv_row){ 
            if(isset($lv_row['wrkflwactevt']) && $lv_row['wrkflwactevt'] == 'STR' && $lv_row['wrkflwstpcod'] == 0){
              $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                            'wrkflwactcod:"'.$lv_row['wrkflwactcod'].'",'.
                            'wrkflwacttyp:"'.$lv_row['wrkflwacttyp'].'",'.
                            'wrkflwacttyptxt:"'.(isset($lv_acttyp_arr[$lv_row['wrkflwacttyp']]) ? $lv_acttyp_arr[$lv_row['wrkflwacttyp']] : '').'",'.
                            'wrkflwactval:"'.$lv_row['wrkflwactval'].'"'.
                            '}';
            }
          }
        }
				echo $lv_buffer;
			?>];
      
      //carga los datos
			<?= $lv_sec; ?>_hotstr.loadData( lv_dat );
			<?= $lv_sec; ?>_hotstr.render();
		});
  </script>
  <script>
    /**
		 *
		 *	A C C I O N E S    D E    L I B E R A C I Ó N ( W O R K F L O W )
		 *
		 */
    
		var <?= $lv_sec; ?>_hotrelerr = [];
		var <?= $lv_sec; ?>_hotreldel = [];
		var <?= $lv_sec; ?>_hotrelcnt = $("#<?= $lv_sec; ?> #wrkflwrelhot")[0];
		var <?= $lv_sec; ?>_hotrelset = {
			height: 198,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
      colHeaders: [ "<?= $vew_lang->type; ?>","<?= $vew_lang->value; ?>"],
			columns: [
        {type: "dropdown", data: "wrkflwacttyptxt", width: 30, renderer: <?= $lv_sec; ?>_gv_hotact_renderer <?= ($vew_readonly?', readOnly: true':'');?>, source: Object.values(<?= $lv_sec; ?>_gv_acttyp_arr)  },
        {type: "text", data: "wrkflwactval", width: 40, renderer: <?= $lv_sec; ?>_gv_hotact_renderer <?= ($vew_readonly?', readOnly: true':'');	?> }
			],
      beforeChange: function(changes, source) {
        if (changes && changes.length){
					if (changes[0][1]=="wrkflwacttyptxt") {
						var lv_value = changes[0][3];
            changes.push([ changes[0][0], "wrkflwacttyp", "", Object.keys(<?= $lv_sec; ?>_gv_acttyp_arr).find(function(key){ return <?= $lv_sec; ?>_gv_acttyp_arr[key] === changes[0][3]; })]);
					}
        }
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotrel.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["wrkflwactcod"]!="" && lv_dat[i]["wrkflwactcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotreldel.push( lv_dat[i] );
					}
				}
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotrelerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotrelerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotrelerr.splice(lv_inx,1); }
				}
			}
		};
		var <?= $lv_sec; ?>_hotrel;

		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotrel = new Handsontable(<?= $lv_sec; ?>_hotrelcnt, <?= $lv_sec; ?>_hotrelset);
			var lv_dat = [<?php
				$lv_buffer='';
        if($vew_data->sysdocwrkact != ''){
          foreach($vew_data->sysdocwrkact as $lv_row){
            if(isset($lv_row['wrkflwactevt']) && $lv_row['wrkflwactevt'] == 'REL' && $lv_row['wrkflwstpcod'] == 0){
              $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                            'wrkflwactcod:"'.$lv_row['wrkflwactcod'].'",'.
                            'wrkflwacttyp:"'.$lv_row['wrkflwacttyp'].'",'.
                            'wrkflwacttyptxt:"'.(isset($lv_acttyp_arr[$lv_row['wrkflwacttyp']]) ? $lv_acttyp_arr[$lv_row['wrkflwacttyp']] : '').'",'.
                            'wrkflwactval:"'.$lv_row['wrkflwactval'].'"'.
                            '}';
            }
          }
        }
				echo $lv_buffer;
			?>];
      
      //carga los datos
			<?= $lv_sec; ?>_hotrel.loadData( lv_dat );
			<?= $lv_sec; ?>_hotrel.render();
		});
  </script>
  <script>
    /**
		 *
		 *	A C C I O N E S    D E    R E C H A Z O ( W O R K F L O W )
		 *
		 */
    
		var <?= $lv_sec; ?>_hotrejerr = [];
		var <?= $lv_sec; ?>_hotrejdel = [];
		var <?= $lv_sec; ?>_hotrejcnt = $("#<?= $lv_sec; ?> #wrkflwrejhot")[0];
		var <?= $lv_sec; ?>_hotrejset = {
			height: 198,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
      colHeaders: [ "<?= $vew_lang->type; ?>","<?= $vew_lang->value; ?>"],
			columns: [
        {type: "dropdown", data: "wrkflwacttyptxt", width: 30, renderer: <?= $lv_sec; ?>_gv_hotact_renderer <?= ($vew_readonly?', readOnly: true':'');?>, source: Object.values(<?= $lv_sec; ?>_gv_acttyp_arr) },
        {type: "text", data: "wrkflwactval", width: 40, renderer: <?= $lv_sec; ?>_gv_hotact_renderer <?= ($vew_readonly?', readOnly: true':'');	?> }
			],
      beforeChange : function(changes, source) {
        if (changes && changes.length){
					if (changes[0][1]=="wrkflwacttyptxt") {
						var lv_value = changes[0][3];
            changes.push([ changes[0][0], "wrkflwacttyp", "", Object.keys(<?= $lv_sec; ?>_gv_acttyp_arr).find(function(key){ return <?= $lv_sec; ?>_gv_acttyp_arr[key] === changes[0][3]; })]);
					}
        }
			},  
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotrej.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["wrkflwactcod"]!="" && lv_dat[i]["wrkflwactcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotrejdel.push( lv_dat[i] );
					}
				}
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotrejerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotrejerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotrejerr.splice(lv_inx,1); }
				}
			}
		};
		var <?= $lv_sec; ?>_hotrej;

		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotrej = new Handsontable(<?= $lv_sec; ?>_hotrejcnt, <?= $lv_sec; ?>_hotrejset);
			var lv_dat = [<?php
				$lv_buffer='';
        if($vew_data->sysdocwrkact != ''){
          foreach($vew_data->sysdocwrkact as $lv_row){
            if(isset($lv_row['wrkflwactevt']) && $lv_row['wrkflwactevt'] == 'REJ' && $lv_row['wrkflwstpcod'] == 0){
              $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                            'wrkflwactcod:"'.$lv_row['wrkflwactcod'].'",'.
                            'wrkflwacttyp:"'.$lv_row['wrkflwacttyp'].'",'.
                            'wrkflwacttyptxt:"'.(isset($lv_acttyp_arr[$lv_row['wrkflwacttyp']]) ? $lv_acttyp_arr[$lv_row['wrkflwacttyp']] : '').'",'.
                            'wrkflwactval:"'.$lv_row['wrkflwactval'].'"'.
                            '}';
            }
          }
        }
				echo $lv_buffer;
			?>];
      
      //carga los datos
			<?= $lv_sec; ?>_hotrej.loadData( lv_dat );
			<?= $lv_sec; ?>_hotrej.render();
		});
  </script>
  <script>
    /**
		 * 
		 *	A C C I O N E S    D E    I N I C I O ( P A S O S )
		 *
		 */
    
		var <?= $lv_sec; ?>_hotstpstrerr = [];
		var <?= $lv_sec; ?>_hotstpstrcnt = $("#<?= $lv_sec; ?> #stpstrhot")[0];
		var <?= $lv_sec; ?>_hotstpstrset = {
			height: 198,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
      colHeaders: [ "<?= $vew_lang->type; ?>","<?= $vew_lang->value; ?>"],
			columns: [
        {type: "dropdown", data: "wrkflwacttyptxt", width: 30, renderer: <?= $lv_sec; ?>_gv_hotact_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, 
         source: Object.values(<?= $lv_sec; ?>_gv_acttyp_arr) },
        {type: "text", data: "wrkflwactval", width: 40, renderer: <?= $lv_sec; ?>_gv_hotact_renderer <?= ($vew_readonly?', readOnly: true':'');	?> }
			],
      beforeChange : function(changes, source) {
        if (changes && changes.length){
					if (changes[0][1]=="wrkflwacttyptxt") {
						var lv_value = changes[0][3];
            changes.push([ changes[0][0], "wrkflwacttyp", "", Object.keys(<?= $lv_sec; ?>_gv_acttyp_arr).find(function(key){ return <?= $lv_sec; ?>_gv_acttyp_arr[key] === changes[0][3]; })]);
					}
        }
			},
      afterChange: function(changes, source) {
        if(source != "loadData"){ 
          var lv_ind = <?= $lv_sec; ?>_gv_stpatr_arr.findIndex(function(elem){ return elem.code == $("#<?= $lv_sec; ?> .tmss-blue-border").data("code"); });
          <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]['wrkflwstpactstr'] = <?= $lv_sec; ?>_hotstpstr.getSourceData().slice(0, -1);
      	}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotstpstr.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["wrkflwactcod"]!="" && lv_dat[i]["wrkflwactcod"]!=undefined ) { 
            var lv_ind = <?= $lv_sec; ?>_gv_stpatr_arr.findIndex(function(elem){ return elem.code == $("#<?= $lv_sec; ?> .tmss-blue-border").data("code"); });
            <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]['wrkflwstpactdel'].push({"wrkflwactcod": lv_dat[i]["wrkflwactcod"]});
          }
				}
			},
			afterRemoveRow: function(index, amount, logicalRows) {
        var lv_ind = <?= $lv_sec; ?>_gv_stpatr_arr.findIndex(function(elem){ return elem.code == $("#<?= $lv_sec; ?> .tmss-blue-border").data("code"); });
        <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]['wrkflwstpactstr'] = <?= $lv_sec; ?>_hotstpstr.getSourceData().slice(0, -1);
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotstpstrerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotstpstrerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotstpstrerr.splice(lv_inx,1); }
				}
			}
		};
		var <?= $lv_sec; ?>_hotstpstr;

		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotstpstr = new Handsontable(<?= $lv_sec; ?>_hotstpstrcnt, <?= $lv_sec; ?>_hotstpstrset);
      <?= $lv_sec; ?>_hotstpstr.loadData(new Array());
		});
  </script>
  <script>
    /**
		 *
		 *	A C C I O N E S    D E    L I B E R A C I Ó N ( P A S O S )
		 *
		 */
    
		var <?= $lv_sec; ?>_hotstprelerr = [];
		var <?= $lv_sec; ?>_hotstpreldel = [];
		var <?= $lv_sec; ?>_hotstprelcnt = $("#<?= $lv_sec; ?> #stprelhot")[0];
		var <?= $lv_sec; ?>_hotstprelset = {
			height: 198,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
      colHeaders: [ "<?= $vew_lang->type; ?>","<?= $vew_lang->value; ?>"],
			columns: [
        {type: "dropdown", data: "wrkflwacttyptxt", width: 30, renderer: <?= $lv_sec; ?>_gv_hotact_renderer <?= ($vew_readonly?', readOnly: true':'');?>, source: Object.values(<?= $lv_sec; ?>_gv_acttyp_arr) },
        {type: "text", data: "wrkflwactval", width: 40, renderer: <?= $lv_sec; ?>_gv_hotact_renderer <?= ($vew_readonly?', readOnly: true':'');	?> }
			],
      beforeChange : function(changes, source) {
        if (changes && changes.length){
					if (changes[0][1]=="wrkflwacttyptxt") {
						var lv_value = changes[0][3];
            changes.push([ changes[0][0], "wrkflwacttyp", "", Object.keys(<?= $lv_sec; ?>_gv_acttyp_arr).find(function(key){ return <?= $lv_sec; ?>_gv_acttyp_arr[key] === changes[0][3]; })]);
					}
        }
			},
      afterChange: function(changes, source) {
        if(source != "loadData"){ 
          var lv_ind = <?= $lv_sec; ?>_gv_stpatr_arr.findIndex(function(elem){ return elem.code == $("#<?= $lv_sec; ?> .tmss-blue-border").data("code"); });
          <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]['wrkflwstpactrel'] = <?= $lv_sec; ?>_hotstprel.getSourceData().slice(0, -1);
      	}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotstprel.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["wrkflwactcod"]!="" && lv_dat[i]["wrkflwactcod"]!=undefined ) { 
            var lv_ind = <?= $lv_sec; ?>_gv_stpatr_arr.findIndex(function(elem){ return elem.code == $("#<?= $lv_sec; ?> .tmss-blue-border").data("code"); });
            <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]['wrkflwstpactdel'].push({"wrkflwactcod": lv_dat[i]["wrkflwactcod"]});
          }
				}
			},
			afterRemoveRow: function(index, amount, logicalRows) {
        var lv_ind = <?= $lv_sec; ?>_gv_stpatr_arr.findIndex(function(elem){ return elem.code == $("#<?= $lv_sec; ?> .tmss-blue-border").data("code"); });
        <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]['wrkflwstpactrel'] = <?= $lv_sec; ?>_hotstpstr.getSourceData().slice(0, -1);
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotstprelerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotstprelerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotstprelerr.splice(lv_inx,1); }
				}
			}
		};
		var <?= $lv_sec; ?>_hotstprel;

		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotstprel = new Handsontable(<?= $lv_sec; ?>_hotstprelcnt, <?= $lv_sec; ?>_hotstprelset);
      <?= $lv_sec; ?>_hotstprel.loadData(new Array());
		});
  </script>
  <script>
    /**
		 *
		 *	A C C I O N E S    D E    R E C H A Z O ( P A S O S )
		 *
		 */
    
		var <?= $lv_sec; ?>_hotstprejerr = [];
		var <?= $lv_sec; ?>_hotstprejdel = [];
		var <?= $lv_sec; ?>_hotstprejcnt = $("#<?= $lv_sec; ?> #stprejhot")[0];
		var <?= $lv_sec; ?>_hotstprejset = {
			height: 198,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
      colHeaders: [ "<?= $vew_lang->type; ?>","<?= $vew_lang->value; ?>"],
			columns: [
        {type: "dropdown", data: "wrkflwacttyptxt", width: 30, renderer: <?= $lv_sec; ?>_gv_hotact_renderer <?= ($vew_readonly?', readOnly: true':'');?>, source: Object.values(<?= $lv_sec; ?>_gv_acttyp_arr) },
        {type: "text", data: "wrkflwactval", width: 40, renderer: <?= $lv_sec; ?>_gv_hotact_renderer <?= ($vew_readonly?', readOnly: true':'');	?> }
			],
      beforeChange : function(changes, source) {
        if (changes && changes.length){
					if (changes[0][1]=="wrkflwacttyptxt") {
						var lv_value = changes[0][3];
            changes.push([ changes[0][0], "wrkflwacttyp", "", Object.keys(<?= $lv_sec; ?>_gv_acttyp_arr).find(function(key){ return <?= $lv_sec; ?>_gv_acttyp_arr[key] === changes[0][3]; })]);
					}
        }
			},
      afterChange: function(changes, source) {
        if(source != "loadData"){ 
          var lv_ind = <?= $lv_sec; ?>_gv_stpatr_arr.findIndex(function(elem){ return elem.code == $("#<?= $lv_sec; ?> .tmss-blue-border").data("code"); });
          <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]['wrkflwstpactrej'] = <?= $lv_sec; ?>_hotstprej.getSourceData().slice(0, -1);
      	}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotstprej.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["wrkflwactcod"]!="" && lv_dat[i]["wrkflwactcod"]!=undefined ) { 
            var lv_ind = <?= $lv_sec; ?>_gv_stpatr_arr.findIndex(function(elem){ return elem.code == $("#<?= $lv_sec; ?> .tmss-blue-border").data("code"); });
            <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]['wrkflwstpactdel'].push({"wrkflwactcod": lv_dat[i]["wrkflwactcod"]});
          }
				}
			},
			afterRemoveRow: function(index, amount, logicalRows) {
        var lv_ind = <?= $lv_sec; ?>_gv_stpatr_arr.findIndex(function(elem){ return elem.code == $("#<?= $lv_sec; ?> .tmss-blue-border").data("code"); });
        <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]['wrkflwstpactrej'] = <?= $lv_sec; ?>_hotstpstr.getSourceData().slice(0, -1);
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotstprejerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotstprejerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotstprejerr.splice(lv_inx,1); }
				}
			}
		};
		var <?= $lv_sec; ?>_hotstprej;

		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotstprej = new Handsontable(<?= $lv_sec; ?>_hotstprejcnt, <?= $lv_sec; ?>_hotstprejset);
      <?= $lv_sec; ?>_hotstprej.loadData(new Array());
		});
  </script>
  <script>
    /**
		 *
		 *	R E S P O N S A B L E S
		 *
		 */
		var <?= $lv_sec; ?>_hotres_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      if(prop == "wrkflwstprestyp"){
        Handsontable.renderers.DropdownRenderer.apply(this, arguments);
      } else {
      	Handsontable.renderers.TextRenderer.apply(this, arguments);
      }
      
      td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
		};
    //debugger;
		var <?= $lv_sec; ?>_hotreserr = [];
		var <?= $lv_sec; ?>_hotresdel = [];
		var <?= $lv_sec; ?>_hotrescnt = $("#<?= $lv_sec; ?> #stpreshot")[0];
		var <?= $lv_sec; ?>_hotresset = {
			height: 198,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
      colHeaders: [ "<?= $vew_lang->type; ?>","<?= $vew_lang->value; ?>"],
			columns: [
        {type: "dropdown", data: "wrkflwstprestyp", width: 30, renderer: <?= $lv_sec; ?>_hotres_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, 
         source: ["<?= $vew_lang->user; ?>", "<?= $vew_lang->rol; ?>"] },
        {type: "text", data: "wrkflwstpresval", width: 40, renderer: <?= $lv_sec; ?>_hotres_renderer <?= ($vew_readonly?', readOnly: true':'');	?> }
			],
      afterChange: function(changes, source) {
        if(source != "loadData"){ 
          var lv_ind = <?= $lv_sec; ?>_gv_stpatr_arr.findIndex(function(elem){ return elem.code == $("#<?= $lv_sec; ?> .tmss-blue-border").data("code"); });
          <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]['wrkflwstpres'] = <?= $lv_sec; ?>_hotres.getSourceData().slice(0, -1);
      	}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotres.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["wrkflwactcod"]!="" && lv_dat[i]["wrkflwactcod"]!=undefined ) {
						var lv_ind = <?= $lv_sec; ?>_gv_stpatr_arr.findIndex(function(elem){ return elem.code == $("#<?= $lv_sec; ?> .tmss-blue-border").data("code"); });
            <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]['wrkflwstpactdel'].push({"wrkflwactcod": lv_dat[i]["wrkflwactcod"]});
					}
				}
			},
      afterRemoveRow: function(index, amount, logicalRows) {
        var lv_ind = <?= $lv_sec; ?>_gv_stpatr_arr.findIndex(function(elem){ return elem.code == $("#<?= $lv_sec; ?> .tmss-blue-border").data("code"); });
        <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]['wrkflwstpres'] = <?= $lv_sec; ?>_hotres.getSourceData().slice(0, -1);
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotreserr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotreserr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotreserr.splice(lv_inx,1); }
				}
			}
		};
		var <?= $lv_sec; ?>_hotres;

		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotres = new Handsontable(<?= $lv_sec; ?>_hotrescnt, <?= $lv_sec; ?>_hotresset);
      <?= $lv_sec; ?>_hotres.loadData(new Array());
      
      // selecciona y muestra los atributos del primer paso al cargar
    	if($("#<?= $lv_sec; ?> .tmssStep").length > 0){
      	 <?= $lv_sec; ?>_addHighlight($($("#<?= $lv_sec; ?> .tmssStep")[0]));
        <?= $lv_sec; ?>_showAttributes($($("#<?= $lv_sec; ?> .tmssStep")[0]));
      }
		});
  </script>
  <script>
    // ACTUALIZAR DATOS DE PASOS ------------------------------------------------------------------------------------------------------
    $("#<?= $lv_sec; ?> .tmssStepAttributes input, #<?= $lv_sec; ?> .tmssStepAttributes select").on("change", function(e){ 
    	var lv_ind = <?= $lv_sec; ?>_gv_stpatr_arr.findIndex(function(elem){ return elem.code == $("#<?= $lv_sec; ?> .tmss-blue-border").data("code"); });
      
      // Si la descripción está vacía, se coloca el nro del paso
      if($(this).attr("id")=="wrkflwstptxt"){
        if($(this).val().trim() == ""){
        	$(this).val(<?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]["wrkflwstprow"]);
        }
        
        // Actualizo el texto mostrado en el paso
        $("#<?= $lv_sec; ?> .tmss-blue-border span").text($(this).val());
      }
      
      // Guardo el valor en el paso
      <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind][$(this).attr("id")] = $(this).val();
      
      // Actualizo el código de formulario
      if($(this).attr("id")=="wrkflwstpfrmtxt"){
        <?= $lv_sec; ?>_gv_stpatr_arr[lv_ind]["wrkflwstpfrmcod"] = $("#<?= $lv_sec; ?> #wrkflwstpfrmcod").val();
      }
    });
    // --------------------------------------------------------------------------------------------------------------------------------
  </script>
  <script>
    // BOTONES PARA TABLAS INICO, LIBERACIÓN, RECHAZO (WORKFLOW Y PASOS) --------------------------------------------------------------
    
    // mostrar/ocultar acciones de inicio/liberación/rechazo del workflow
    $("#<?= $lv_sec; ?> .btnwrkflwshwtbl, #<?= $lv_sec; ?> .btnstpshwtbl").on("click", function(e){ 
      e.preventDefault(); 
      
      // ocultar las otras acciones
      $("#<?= $lv_sec; ?> .btnwrkflwshwtbl, #<?= $lv_sec; ?> .btnstpshwtbl").not(this).each(function(i, e){$("#<?= $lv_sec; ?> #"+$(e).data("tbl")).addClass("hide");});
      $("#<?= $lv_sec; ?> .btnwrkflwshwtbl i, #<?= $lv_sec; ?> .btnstpshwtbl i").not($(this).find("i")).removeClass("fa-chevron-up").addClass("fa-chevron-down");

      // ocultar/mostrar las acciones del botón clickeado
      $("#<?= $lv_sec; ?> #" + $(this).data("tbl")).toggleClass("hide");
      $(this).find("i").toggleClass("fa-chevron-up fa-chevron-down");
      
   		<?= $lv_sec; ?>_hotstr.render();
   		<?= $lv_sec; ?>_hotrel.render();
   		<?= $lv_sec; ?>_hotrej.render();
   		<?= $lv_sec; ?>_hotstpstr.render();
   		<?= $lv_sec; ?>_hotstprel.render();
   		<?= $lv_sec; ?>_hotstprej.render();
   		<?= $lv_sec; ?>_hotres.render();
    });
  </script>
  <script>
		var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"docsts" : "A", }, "fldasg" : {"wrkflwstpfrmtxt" : "sysdocfrmtxt", "wrkflwstpfrmcod" : "sysdocfrmcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #wrkflwstpfrmtxt"), "sysdocfrm", lo_get);
  </script>
  <script>
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {
        
        // acciones de inicio (workflow)
        // obtengo datos
				var lv_arr = new Array();
				var lo_dat = <?= $lv_sec; ?>_hotstr.getSourceData();
        
        // agrego las filas eliminadas
				for (var i=0; i< <?= $lv_sec; ?>_hotstrdel.length; i++) {
          lv_arr.push({ "wrkflwactcod":<?= $lv_sec; ?>_hotstrdel[i]["wrkflwactcod"],
                      "deleted":"X"
                    });
        }
        
				// agrego las filas a grabar
				for (var i=0; i< lo_dat.length; i++) {
					if(lo_dat[i]["wrkflwacttyp"]!=undefined && lo_dat[i]["wrkflwacttyp"]!=""){
            lv_arr.push({	"wrkflwactcod": lo_dat[i]["wrkflwactcod"],
                         	"wrkflwactevt": "STR",
                         	"wrkflwacttyp": lo_dat[i]["wrkflwacttyp"],
                         	"wrkflwactval": lo_dat[i]["wrkflwactval"]
                        });
          }
				}
        
        // acciones de liberación (workflow)
				lo_dat = <?= $lv_sec; ?>_hotrel.getSourceData();
        
        // agrego las filas eliminadas
				for (var i=0; i< <?= $lv_sec; ?>_hotreldel.length; i++) {
          lv_arr.push({ "wrkflwactcod":<?= $lv_sec; ?>_hotreldel[i]["wrkflwactcod"],
                      "deleted":"X"
                    });
        }
        
				// agrego las filas a grabar
				for (var i=0; i< lo_dat.length; i++) {
					if(lo_dat[i]["wrkflwacttyp"]!=undefined && lo_dat[i]["wrkflwacttyp"]!=""){
            lv_arr.push({	"wrkflwactcod": lo_dat[i]["wrkflwactcod"],
                         	"wrkflwactevt": "REL",
                         	"wrkflwacttyp": lo_dat[i]["wrkflwacttyp"],
                         	"wrkflwactval": lo_dat[i]["wrkflwactval"]
                        });
          }
				}
        
        // acciones de rechazo (workflow)
        // obtengo datos
				lo_dat = <?= $lv_sec; ?>_hotrej.getSourceData();
        
        // agrego las filas eliminadas
				for (var i=0; i< <?= $lv_sec; ?>_hotrejdel.length; i++) {
          lv_arr.push({ "wrkflwactcod":<?= $lv_sec; ?>_hotrejdel[i]["wrkflwactcod"],
                      "deleted":"X"
                    });
        }
        
				// agrego las filas a grabar
				for (var i=0; i< lo_dat.length; i++) {
					if(lo_dat[i]["wrkflwacttyp"]!=undefined && lo_dat[i]["wrkflwacttyp"]!=""){
            lv_arr.push({	"wrkflwactcod": lo_dat[i]["wrkflwactcod"],
                         	"wrkflwactevt": "REJ",
                         	"wrkflwacttyp": lo_dat[i]["wrkflwacttyp"],
                         	"wrkflwactval": lo_dat[i]["wrkflwactval"]
                        });
          }
				}
        
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #wrkflwact").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #wrkflwact").prop("value", JSON.stringify( lv_arr ) );
				}
        
        // junta datos de las acciones de pasos
        var lv_stp_arr = JSON.parse(JSON.stringify(<?= $lv_sec; ?>_gv_stpatr_arr));   
        for(var i = 0; i< lv_stp_arr.length; i++) { 
					if(lv_stp_arr[i]["wrkflwstpres"][0] != undefined && Object.keys(lv_stp_arr[i]["wrkflwstpres"][0]).length > 0 ){
         		lv_stp_arr[i]["wrkflwstpres"].forEach(function(elem){ if(elem["wrkflwstprestyp"] != undefined){ elem["wrkflwstprestyp"] = (elem["wrkflwstprestyp"] == "<?= $vew_lang->user; ?>" ? "USR": "ROL"); } });
          }else{
            delete lv_stp_arr[i]["wrkflwstpres"];
          }
          
          lv_stp_arr[i]["wrkflwstpactstr"].forEach(function(elem){ if(elem["wrkflwacttyp"] != undefined){ elem["wrkflwactevt"] = "STR"; }});
          lv_stp_arr[i]["wrkflwstpactrel"].forEach(function(elem){ if(elem["wrkflwacttyp"] != undefined){ elem["wrkflwactevt"] = "REL"; }});
          lv_stp_arr[i]["wrkflwstpactrej"].forEach(function(elem){ if(elem["wrkflwacttyp"] != undefined){ elem["wrkflwactevt"] = "REJ"; }});
          lv_stp_arr[i]["wrkflwstpact"] = lv_stp_arr[i]["wrkflwstpactstr"].concat(lv_stp_arr[i]["wrkflwstpactrel"], lv_stp_arr[i]["wrkflwstpactrej"]);
          
					delete lv_stp_arr[i]["wrkflwstpactstr"];
          delete lv_stp_arr[i]["wrkflwstpactrel"];
          delete lv_stp_arr[i]["wrkflwstpactrej"];
        }
        
        $("#<?= $lv_sec; ?> #wrkflwstp").prop("value", JSON.stringify(lv_stp_arr) );
        
			}
		}
	</script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
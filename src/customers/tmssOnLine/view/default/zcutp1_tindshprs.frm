<?php		
	/* url del formulario */
  $lv_lnk = '?prg=zcutp1_tin&act=  dshprs'; 
	/* campos requeridos */
	$vew_input->RequiredFields( array() );
	/* clave del documento */
	$lv_dockey = '';
	/* titulo */
	$lv_title = $vew_lang->dashboard;
	/* módulo y programa */
	$lv_mdlcod = 'DSH';
	$lv_prgcod = 'PRS';
	//$vew_actcod = 'dshprs';
  $vew_actcod = '02';
	/* librería de estilos  */
	include_once('_library.frm');
  $lv_lqdtot = 0;
  $lo_lqdcustotlst=array();

  /* PRECIOS EVOLUCIONES */
  foreach ($vew_data['prslqd'] as $lo_rowlqd){
    $lv_lqdtot +=$lo_rowlqd['hltprslqddoctot'];
    $lv_patcod=$lo_rowlqd['hltprslqddoccodext'];
    $lv_custxt= $vew_data['patcus'][$lv_patcod];
    if(!array_key_exists($lv_custxt,$lo_lqdcustotlst)){ 
      $lo_lqdcustotlst[$lv_custxt]['cusevl']=0;
      $lo_lqdcustotlst[$lv_custxt]['cusexp']=0;
      $lo_lqdcustotlst[$lv_custxt]['custot']=0;
      $lo_lqdcustotlst[$lv_custxt]['cuslqd']=0;
      $lo_lqdcustotlst[$lv_custxt]['cuslqdcnt']=0;
    }
     $lo_lqdcustotlst[$lv_custxt]['cusevl']+=$lo_rowlqd['hltprslqddoctot'];
    if(isset($vew_data['prslqdsts'][$lo_rowlqd['hltprslqdcod']]) && $vew_data['prslqdsts'][$lo_rowlqd['hltprslqdcod']]=='C'){
      $lo_lqdcustotlst[$lv_custxt]['cuslqdcnt']+=$lo_rowlqd['hltprslqddoctot'];
    }else{
      $lo_lqdcustotlst[$lv_custxt]['cuslqd']+=$lo_rowlqd['hltprslqddoctot'];
    }
    $lo_lqdcustotlst[$lv_custxt]['custot']+=$lo_rowlqd['hltprslqddoctot'];
  }
  /*PRECIOS GASTOS */
  foreach ($vew_data['prssub'] as $lo_rowlqd){
    $lv_lqdtot +=$lo_rowlqd['hltprslqddoctot'];
    if(isset($vew_data['impcus'][$lo_rowlqd['refobjcod002']])){
      $lv_custxt= $vew_data['impcus'][$lo_rowlqd['refobjcod002']];
    }else{
      $lv_custxt='(ADMINISTRATIVO)';
    }
    if(!array_key_exists($lv_custxt,$lo_lqdcustotlst)){
      $lo_lqdcustotlst[$lv_custxt]['cusevl']=0;
      $lo_lqdcustotlst[$lv_custxt]['cusexp']=0;
      $lo_lqdcustotlst[$lv_custxt]['custot']=0;
      $lo_lqdcustotlst[$lv_custxt]['cuslqd']=0;
      $lo_lqdcustotlst[$lv_custxt]['cuslqdcnt']=0;
    }
    $lo_lqdcustotlst[$lv_custxt]['cusexp']+=$lo_rowlqd['hltprslqddoctot'];

    if(isset($vew_data['prslqdsts'][$lo_rowlqd['hltprslqdcod']]) && $vew_data['prslqdsts'][$lo_rowlqd['hltprslqdcod']]=='C'){
      $lo_lqdcustotlst[$lv_custxt]['cuslqdcnt']+=$lo_rowlqd['hltprslqddoctot'];
    }else{
      $lo_lqdcustotlst[$lv_custxt]['cuslqd']+=$lo_rowlqd['hltprslqddoctot'];
    }
    $lo_lqdcustotlst[$lv_custxt]['custot']+=$lo_rowlqd['hltprslqddoctot'];
  }
	/* Botones por Vista */
	$vew_tbl['sveL'] = array('per'=>false);
	$vew_tbl['sveR'] = array('per'=>false);
	$vew_tbl['clsL'] = array('per'=>false);
	$vew_tbl['clsR'] = array('per'=>false);
	$vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['modR'] = array('per'=>false);
	$vew_tbl['new'] = array('per'=>false);
	$vew_tbl['cpy'] = array('per'=>false);
	$vew_tbl['canc'] = array('per'=>false);
	$vew_tbl['flt'] = array('per'=>false);
	$vew_tbl['asgL'] = array('per'=>false);
	$vew_tbl['asgR'] = array('per'=>false);
	$vew_tbl['dwn'] = array('per'=>false);
	$vew_tbl['dte'] = array('pos'=>'L', 'per'=>false, 'ttl'=>'', 'id'=>'dtedesnav','icn'=>'', 'css'=>'', 'acc'=>'');
	$vew_tbl['rfrsh'] = array('per'=>false);
	$vew_tbl['prnR'] = array('per'=>false);
	$vew_tbl['rfrsh'] = array('per'=>false,'ttl'=>'Actualizar');

?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>" style="background-color: #f6f6f6 !important;">
  <!--navbar-->
  <?php include('zcutp_docfrmtlb.frm'); ?> 

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?=gethtml('tmss_actcod','hidden','');?>
    <div class="container-fluid">
      <textarea id="plnmthyth" name="plnmthyth" class="visible-print"><?= $vew_data['plnmthyth'] ?></textarea>
      <div id="dtedes" class="form-group tmss-form-group tmss-navbar-date tmss-mobile tmss-dte-des">
      </div>
      <div class="row mb-1">
        <div class="col-sm-6 col-md-3 mb-1">
          <?=gethtml('dtpval','hidden', $vew_data['plnmthyth']);?>
          <a href="#" id="plnmthythinp" onclick="<?php echo $lv_sec; ?>_fnc({action: 'dtp'});" class="btn btn-default" title ="Fecha"><span class="far fa-calendar fa-lg"></span><span id="dtpspn"> | <?= $vew_data['plnmthyth'] ?></span></a>
        </div>
        <div class="col-sm-6 col-md-4 mb-1">
          <?php
            if($vew_data['pervewprs']){
              $lv_prscod=$vew_data['prscod'];
              $lv_prstxt =$vew_data['prstxt'];
              echo vew_boot($lv_col210, array('label'=>$vew_lang->provider,
                                              'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly ),
                                                                  array('input'=>gethtml('prstxt', 'doccmt1x50', $lv_prstxt,$lv_default ) )) ));
              echo gethtml('prscod','hidden',$lv_prscod);     
            }
          ?>
        </div>
        <div class="col-xs-0 col-sm-0 col-md-5 mb-30">
        </div>
      </div><!--/row -->
      <div class="row">
        <!-- Pacientes -->
        <div class="col-sm-6 col-md-3">
          <div class="dashboard-box" style="cursor: pointer;" id="dshtkt">
            <div class="dashboard-icon" style="background-color: #173B6F;"><i class="fas fa-users fa-3x"></i></div>
            <div class="dashboard-info" style="background-color: #ffffff; color: #0b9444; text-align: center;">
              <div style="font-weight: bold; font-size: 36px;"><?=count($vew_data['patplnlst']);?></div>
              <label style="font-size: 18px; font-weight: normal;">Pacientes planificados</label><br>
            </div>
          </div>
          <table class="table hidden" id="dshtkttbl">
            <thead><tr><th>#</th><th><?= $vew_lang->customer; ?></th><th><?= 'PRESTACIONES' ?></th><th><?= 'GASTOS' ?></th><th><?= 'TOTAL' ?></th></tr></thead>
            <tbody>
              		<?php 
  										foreach($lo_lqdcustotlst as $cuskey => $custot){
                      	echo '<tr><td></td><td>'.$cuskey.'</td><td>'.$custot['cusevl'].'</td></td><td>'.$custot['cusexp'].'</td><td>'.$custot['custot'].'</td></tr>'; 
                    	}
              		?>
            </tbody>
          </table>
        </div> <!-- /Pacientes -->
        <!-- Evoluciones pendientes -->
        <div class="col-sm-6 col-md-3">
          <div class="dashboard-box" id="dshinv">
            <div class="dashboard-icon" style="background-color: #DD4B39;"><span class="fas fa-pencil fa-3x"></span></div>
            <div class="dashboard-info" style="background-color: #ffffff; color: #0b9444; text-align: center;">
              <div style="font-weight: bold; font-size: 36px;"><?=count($vew_data['plnpenls']);?></div>  
              <label style="font-size: 18px; font-weight: normal;">Evoluciones pendientes</label><br>
            </div>
          </div> 
        </div> <!-- /Evoluciones pendientes -->
        <!-- Evoluciones realizadas -->
        <div class="col-sm-6 col-md-3">
          <div class="dashboard-box" style="cursor: pointer;" id="dshfnc">
            <div class="dashboard-icon" style="background-color: #00A65A;"><span class="fas fa-check fa-3x"></span></div>
            <div class="dashboard-info" style="background-color: #ffffff; color: #0b9444; text-align: center;">
              <div style="font-weight: bold; font-size: 36px;"><?=count($vew_data['evllst']);?></div>  
              <label style="font-size: 18px; font-weight: normal;">Evoluciones realizadas</label><br>
            </div>
          </div> 
        </div> <!-- /Evoluciones realizadas -->
        <!-- Acumulado -->
        <div class="col-sm-6 col-md-3">
          <div class="dashboard-box" style="cursor: pointer;" id="dshlog">
            <div class="dashboard-icon" style="background-color: #CD5F25;"><span class="fas fa-dollar-sign fa-3x"></span></div>
            <div class="dashboard-info" style="background-color: #ffffff; color: #0b9444; text-align: center;">
              <div style="font-weight: bold; font-size: 36px;">$ <?=$lv_lqdtot;?></div>  
              <label style="font-size: 18px; font-weight: normal;">Acumulado</label><br>
            </div>
          </div>			
        </div> <!-- /Acumulado -->
        <!-- Novedades -->
        <div style="background: #fff;">
          <div class="col-md-12" style="border-top: 1px solid #d0d0d0;">
            <div style="border-bottom: 1px solid #e5e9ed; margin-bottom: 5px;">
              <label style="color: #6c88b6; margin-top: 5px;" id="sqlinfo"><?= $vew_lang->news?></label>
            </div>
            <?php
                $lv_buffer = '';
                foreach($vew_data['nws'] as $lv_row){
                  $lv_buffer .='<div class="card">';
                    $lv_buffer .='<div class="card-header">';
                      $lv_buffer .='<div class="card-title">';
                      	$lv_buffer .='<strong>'.$lv_row['nwsmsg'].'</strong>';
                      $lv_buffer .='<span class="tmss-card-icon" style="padding-top: 0px;">';
                      	$lv_buffer .=$lv_row['nwsdte']->format('d/m/Y');
                      $lv_buffer .='</span>';
                      $lv_buffer .='</div>';
                    $lv_buffer .='</div>';

                    $lv_buffer .='<div class="tmss-card-body-edit" style="padding-left: 10px;"><br>';
                      $lv_buffer .='<ul>';
                      $lv_buffer .= $lv_row['txttxt'];
                      $lv_buffer .='</ul>';
                    $lv_buffer .='</div>';//card-body
                  $lv_buffer .='</div>';//card
                }
                echo $lv_buffer;
            ?>
          </div>
        </div><!-- /Novedades -->	
      </div><!-- /row -->	
	</div><!-- /container-fluid -->
</form>
  <script>
    function <?= $lv_sec; ?>_refresh(){
      var lv_dtpval=  $("#<?= $lv_sec; ?> #dtpval").val();
      $("#<?= $lv_sec; ?> #plnmthyth").text( lv_dtpval);
      $("#<?= $lv_sec; ?> #dtpspn").text( " | " + lv_dtpval );
      <?= $lv_sec; ?>_fncext({action: ''}); 
    }
  </script>
  <script>
    // prstxt
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"prstxt" : "prstxt", "prscod" : "prscod"}}; 
    lo_callback =  {"afterAssign" : function(){<?= $lv_sec; ?>_refresh();}}
    tmssTypeahead($("#<?= $lv_sec; ?> #prstxt"), "hltprs", lo_get,lo_callback);     
  </script>
  <script>
  	$(function(){
      //añade el datepicer a la barra de desplazamiento
      $("#<?= $lv_sec; ?> #dtpval").datepicker({
          format: "mm/yyyy",
          startView: "months", 
          minViewMode: "months"
      }).on("change",function(e){
        //cierra el datepicker cuando se selecciona un mes
        $('.datepicker').hide();
        //recarga la vista
        <?= $lv_sec; ?>_refresh();
      });
    	//agrega un badge al filtro
      $("#<?= $lv_sec; ?> #btnflt").append("<span id='fltcnt' class='badge'></span>"); 
      //si se desplazo la vista se agregan clases al navbar para que sea visible
      if ($(window).scrollTop() > 50) {
        $(".navbar-fixed-top").removeClass("tmss-shadow");
        $(".tmss-navbar-fixed").addClass("tmss-navbar-fixed-hold").parent().css("padding-top","50px");
      } else {
        $(".navbar-fixed-top").addClass("tmss-shadow");
        $(".tmss-navbar-fixed").removeClass("tmss-navbar-fixed-hold").parent().css("padding-top","");
      }
      if( !tmssIsMobile() ){
        //remueve las clases mobile
        $("#<?= $lv_sec; ?> .tmss-mobile").removeClass("tmss-mobile"); 
        //si se carga en desktop se carga la barra de desplazamiento en el navbar
        $("#<?= $lv_sec; ?> #dtedes").find("#btnplnbck, #btnplnfrw").removeClass("col-sm-1");
        $("#<?= $lv_sec; ?> #dtedes").removeClass().addClass("btn-group tmss-dte-des");
        //$("#<?= $lv_sec; ?> #dtedes").find("#plnmthythinp").addClass("col-sm-6")
        $("#<?= $lv_sec; ?> #dtedes").appendTo($("#<?= $lv_sec; ?> #dtedesnav").parent());
      }else{
        //mueve los iconos del lado izquiero al lado derecho
        $("#<?= $lv_sec; ?> .tmss-hltplnwek-table div[name='pln'] .dteicnrgt").each(function(){
          $(this).append( $(this).parent().find(".dteicnlft i") );
        });
      }
      //se borra el boton de referencia de la barra de desplazamiento
      $("#<?= $lv_sec; ?> #dtedesnav").remove();
    })
  </script>  
  <script>
    //evento para abrir datepicker con el icono
    $("#<?= $lv_sec; ?> #plnmthythinp i").click(function(e){e.preventDefault();$(this).parents().eq(1).find("input").datepicker("show"); })

    $("#<?= $lv_sec; ?> #dshinv").on("click",function(e){ e.preventDefault();
      tmssLink("?prg=hltpln&prm_plnvew=plnwek&prm_mdlcod=hlt&prm_prgcod=pls&prm_vewcod=", [{target: "_new_section", post_data: []}] );
    });
    // tickets
    $("#<?= $lv_sec; ?> #dshtkt").on("click", function(e){ e.preventDefault();
      tmssLink("?prg=hltpat&prm_mdlcod=hlt&prm_prgcod=pat&prm_vewcod=VEW_HLT_PAT", [{target: "_new_section", post_data: []}] );
    });
    // log de cambios
    $("#<?= $lv_sec; ?> #dshlog").on("click", function(e){ e.preventDefault();
      BootstrapDialog.show({
        size: BootstrapDialog.SIZE_WIDE,
        title: "Acumulado",
        closable: true,
        draggable: true,
        message: $("#<?= $lv_sec; ?> #dshtkttbl").clone().removeClass("hidden")
      });
    });
  </script>
<script>		
  // form submit
  function <?= $lv_sec; ?>_fncext( lp_prm ) {
    if (lp_prm["action"]=="dtp" ){
       $("#<?= $lv_sec; ?> #dtpval").datepicker("show");
      $("#<?= $lv_sec; ?> .datepicker").css("left", ($("#<?= $lv_sec; ?> #dtpval").offset().left - ($("#<?= $lv_sec; ?> #dtpval").width()/2)) + "px" );
      return false;
    } else {
      gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
      var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':'03'); ?>":gv_<?= $lv_sec; ?>_last_action);
      tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
    }
    return true;
  }
  // edit mode
	tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
</script>
<?php include('grldocfrmscr.frm'); ?>
</section>
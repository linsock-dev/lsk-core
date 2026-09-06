<?php
	/* url del formulario */
  $lv_lnk = '?prg=zcutp1_tpe';

	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = '';

	/* titulo */
	$lv_title = $vew_lang->dashboard;
	
	/* módulo y programa */
	$lv_mdlcod = 'DSH';
	$lv_prgcod = 'PRS';

	$vew_actcod = '02';

	/* librería de estilos bootstrap */
	include_once('_library.frm');

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
	$vew_tbl['prnR'] = array('per'=>false);
	$vew_tbl['rfrsh'] = array('per'=>false,'ttl'=>'Actualizar');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>" style="background-color: #f6f6f6 !important;">
	<style>
	.dashboard-box { color: #ffffff; text-align: center; background: #ffffff !important; width: 100% !important; box-shadow: 0 1px 1px rgb(0 0 0 / 10%) !important; border-radius: 2px !important; margin-bottom: 15px !important; }
  .dashboard-icon { padding-top: 27px; float: left; height: 100px; width: 90px; }
	.dashboard-info { padding-top: 5px; margin-left: 90px; height: 100px; } 
  @media only screen and (max-width: 600px) {
    .dashboard-info { margin-left: 0px !important; }
  }
	</style>
	
  <!--navbar-->
  <?php include('grldocfrmtlb.frm'); ?> 

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
  	<?= gethtml('tmss_actcod', 'hidden', '');?>
    
    <div class="container-fluid">
      <textarea id="plnmthyth" name="plnmthyth" class="visible-print"><?= $vew_data['plnmthyth'] ?></textarea>

      <div class="row">
        <div class="col-xs-12 col-sm-6 col-md-3">
          <input id="dtpval" type="text" class="form-control text-center hidden" value="<?= $vew_data['plnmthyth'] ?> ">
          <a href="#" id="plnmthythinp" class="btn btn-default" title ="<?= $vew_lang->date?>"><span class="far fa-calendar fa-lg"></span>| <span id="dtpspn"><?= $vew_data['plnmthyth'] ?></span></a>
          <br>
          <br>
        </div>
        <div class="col-xs-12 col-sm-6 col-md-4">
        <?php
          echo vew_boot($lv_col210, array('label'=>$vew_lang->provider,
                                          'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly ),
                                                              array('input'=>gethtml('prstxt', 'doccmt1x50', $vew_data['prstxt'], $lv_default ) )) ));
          echo gethtml('prscod','hidden', $vew_data['prscod']);   
        ?>
        </div>
        <div class="col-xs-12">
        	<br>
        </div>
      </div>
      
      <div class="row">
        <div class="col-md-<?= $vew_data['tmetot'] || $vew_data['qtytot']? ($vew_data['tmetot'] && $vew_data['qtytot']?1:3):4 ?>"></div>
        <!-- Horas -->
        <?php if($vew_data['tmetot']){ ?>

        <div class="col-xs-12 col-sm-6 col-md-3">
          <div class="dashboard-box" style="cursor: pointer;" id="dshtkt">
            <div class="dashboard-icon" style="background-color: #0086b5;"><i class="fas fa-user-clock fa-3x"></i></div>
            <div class="dashboard-info" style="background-color: #ffffff; color: #0b9444;">
              <div style="font-weight: bold; font-size: 36px;"><?= $vew_data['tmetot']; ?></div>
              <label style="font-size: 18px; font-weight: normal;">Horas Acumuladas</label><br>
            </div>
          </div>
        </div> 

        <?php } ?>

        <!-- Sesiones -->
        <?php if($vew_data['qtytot']){ ?>

        <div class="col-xs-12 col-sm-6 col-md-3">
          <div class="dashboard-box" style="cursor: pointer;" id="dshtkt">
            <div class="dashboard-icon" style="background-color: #eb8800;"><i class="fas fa-calendar-check fa-3x"></i></div>
            <div class="dashboard-info" style="background-color: #ffffff; color: #0b9444;">
              <div style="font-weight: bold; font-size: 36px;"><?= $vew_data['qtytot']; ?></div>
              <label style="font-size: 18px; font-weight: normal;">Sesiones Acumuladas</label><br>
            </div>
          </div>
        </div> 

        <?php } ?>

        <!-- Acumulado -->
        <div class="col-xs-12 col-sm-6 col-md-3">
          <div class="dashboard-box" style="cursor: pointer;" id="dshtkt">
            <div class="dashboard-icon" style="background-color: #e05709;"><i class="fas fa-dollar-sign fa-3x"></i></div>
            <div class="dashboard-info" style="background-color: #ffffff; color: #0b9444;">
              <div style="font-weight: bold; font-size: 36px;">$ <?= $vew_data['lqdtot']; ?></div>
              <label style="font-size: 18px; font-weight: normal;">Total Acumulado</label><br>
            </div>
          </div>
        </div> 
        
			</div>	
      
      <!-- novedades -->
      <div class="row" style="background: #fff;">
        <div class="col-md-12" style="border-top: 1px solid #d0d0d0;">
					<div style="border-bottom: 1px solid #e5e9ed; margin-bottom: 5px;">
            <label style="color: #6c88b6; margin-top: 5px;"><?= $vew_lang->news?></label>
    			</div>
          <?php
  						$lv_buffer = '';
              foreach($vew_data['nws'] as $lv_row){
                $lv_buffer .= ($lv_buffer?'<hr>':'').'<div>'.
                  '<p style=" font-size: 20px; color: #000; font-weight: bold;">'.$lv_row['nwstxt'].'</p>'.
                  ($lv_row['nwsmsg']?'<p style="font-size: 18px; font-weight: bold;">'.$lv_row['nwsmsg'].'</p>':'').
                  $lv_row['txttxt'].
                  '</div>';
              }
              
              echo $lv_buffer;
          ?>
        </div>
      </div>
      
  	</div>
	</form>
  <script>
    $("#<?= $lv_sec; ?> #dtpval").datepicker({
        format: "mm/yyyy",
        startView: "months", 
        minViewMode: "months"
    }).on("change",function(e){
      $(".datepicker").hide();
      //recarga la vista
      <?= $lv_sec; ?>_refresh();
    });
    
    function <?= $lv_sec; ?>_refresh(){ 
      var lv_dtpval = $("#<?= $lv_sec; ?> #dtpval").val();
      $("#<?= $lv_sec; ?> #plnmthyth").text( lv_dtpval);
      $("#<?= $lv_sec; ?> #dtpspn").text(lv_dtpval);
      
      if($("#<?= $lv_sec; ?> #prscod").val()){
      	<?= $lv_sec; ?>_fnc({action: "dshprs"}); 
      }
    }
  </script>
  <script>
  $("#<?= $lv_sec; ?> #plnmthythinp").on("click", function(e){
    $("#<?= $lv_sec; ?> #dtpval").datepicker("show");
    $("#<?= $lv_sec; ?> .datepicker").css("left", ($("#<?= $lv_sec; ?> #dtpval").offset().left - ($("#<?= $lv_sec; ?> #dtpval").width()/2)) + "px" );
  });
  </script>
  <script>
		// prstxt
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"prstxt" : "prstxt", "prscod" : "prscod"}}; 
    var lo_callback =  {"afterAssign" : function(){<?= $lv_sec; ?>_refresh();}}
    tmssTypeahead($("#<?= $lv_sec; ?> #prstxt"), "hltprs", lo_get, lo_callback);     
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
    
    
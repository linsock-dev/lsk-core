<?php
	/* url del formulario */
  $lv_lnk = '?prg=tsrbnktjt&prm_bnktjtcod='.$vew_data->bnknum;

	/* campos requeridos */
	$vew_input->RequiredFields( array('bnktjttxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->bnknum;

	/* titulo */
	$lv_title = $vew_lang->treasurycards;
	
	/* módulo y programa */
	$lv_mdlcod = 'TSR';
	$lv_prgcod = 'BNJ';
	
	// valores x default
	$vew_data->bnksrctyp='ADM_BUS';

	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <!-- Nav-bar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->bnknum; ?><?= gethtml('bnknum','hidden',$vew_data->bnknum); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">			
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->treasurycards; ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                   <?php 
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->number,'input'=>gethtml('bnktjtnum', 'docnum1600', $vew_data->bnktjtnum, $lv_default) ));	
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->owner,'input'=>gethtml('bnktjttxt', 'doccmt1x50', $vew_data->bnktjttxt, $lv_default) ));
                   	echo vew_boot($lv_col210, array('label'=> $vew_lang->duedate,'input'=>gethtml('bnktjtenddte',	'typeahead',  ($vew_data->bnktjtenddte!=''?date_format($vew_data->bnktjtenddte,"m/Y"):''),	$lv_default) ));	
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status,'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  	echo gethtml('paymthcod','hidden',$vew_data->paymthcod);		
                  	echo gethtml('bnksrctyp','hidden',$vew_data->bnksrctyp);
                  	echo gethtml('bnksrccod','hidden',$vew_data->bnksrccod);
                  ?>
                </div>
						  </div> <!-- /card -->
            </div> <!-- /col -->
					</div> <!-- /row -->
				</div> <!-- /tab001 -->
		  </div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <script>
    $("#<?= $lv_sec; ?> #bnktjtenddte").datepicker({
        format: "mm/yyyy",
        startView: "years", 
        minViewMode: "months"
    }).on("change",function(e){
      //cierra el datepicker cuando se selecciona un mes
      $('.datepicker').hide();
    });
    
  </script> 
	<?php include('grldocfrmscr.frm'); ?>
</section>
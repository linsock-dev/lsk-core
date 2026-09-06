<?php
	// url del formulario
  $lv_lnk = '?prg=stkqmsprf&prm_qmsprfcod='.$vew_data->qmsprfcod;

	// campos requeridos
	$vew_input->RequiredFields( array('qmsprftxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->qmsprfcod;

	// titulo
	$lv_title = $vew_lang->profile;
	
	// módulo y programa
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'QPF';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->qmsprfcod; ?><?= gethtml('qmsprfcod', 'hidden', $vew_data->qmsprfcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">	
			
        <!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code,'input'=>gethtml('qmsprfcodext', 'doccmt1x50', $vew_data->qmsprfcodext, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('qmsprftxt', 'doccmt1x50', $vew_data->qmsprftxt, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status,'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
                </div>
             	</div> <!-- /card -->
          	</div> <!-- /col -->
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->procedure; ?></div></div>
                <div class="card-body tmss-card-body-edit">
									
									FALTA: definir formularios, grupos y etiquetas
									
                </div>
             	</div> <!-- /card -->
          	</div> <!-- /col -->
					</div> <!-- /row -->
				</div> <!-- /_tab001 -->
				
		  </div> <!-- /tab-content -->
  	</div> <!-- /container-fluid -->
  </form>

	<?php include('grldocfrmscr.frm'); ?>
</section>
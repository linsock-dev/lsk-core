<?php
	// url del formulario
  $lv_lnk = '?prg=hhroutrsn&prm_hhroutrsncod='.$vew_data->hhroutrsncod;

	// campos requeridos
	$vew_input->RequiredFields( array('hhroutrsntxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->hhroutrsncod;

	// titulo
	$lv_title = $vew_lang->outreason;
	
	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'OUR';
	
	// Libreria de estilos bootstrap
  include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

	 <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
    
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hhroutrsncod; ?><?= gethtml('hhroutrsncod','hidden',$vew_data->hhroutrsncod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 		'input'=>gethtml('hhroutrsncodext', 'doccmt1x20', $vew_data->hhroutrsncodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hhroutrsntxt', 'doccmt1x50', $vew_data->hhroutrsntxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
						    </div>
              </div>
            </div>
					</div>
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
 <?php include('grldocfrmscr.frm'); ?>
</section>
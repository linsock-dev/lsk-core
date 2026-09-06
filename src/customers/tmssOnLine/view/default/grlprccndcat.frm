<?php	
	// url del formulario
  $lv_lnk = '?prg=grlprccndcat';

	// campos requeridos
	$vew_input->RequiredFields( array('prccndcattxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->prccndcatcod; 

	// titulo
	$lv_title = $vew_lang->categories;
	
	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'PCC';

	// libreria de estilos bootstrap
	include_once('_library.frm');
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
    <?= gethtml('prccndcataccseq', 'hidden', ''); ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->prccndcatcod; ?><?= gethtml('prccndcatcod', 'hidden', $vew_data->prccndcatcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->category; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,  			'input'=>gethtml('prccndcatcodext', 'doccmt1x20', $vew_data->prccndcatcodext, $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('prccndcattxt', 'doccmt1x50', $vew_data->prccndcattxt, $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); 
                  ?>
                </div>
              </div>
						</div><!-- /col-md-6 -->
					</div><!-- /row -->
				</div> <!-- /_tab001 -->
				
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
    
  </form>
  <?php include('grldocfrmscr.frm'); ?>
</section>
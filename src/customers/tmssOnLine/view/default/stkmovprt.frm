<?php
	// url del formulario 
  $lv_lnk = '?prg=stkmovprt&prm_stkmovprtcod='.$vew_data->stkmovprtcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('stkmovprttxt','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->stkmovprtcod;

	// titulo 
	$lv_title = $vew_lang->classification;

	// módulo y programa 
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'PRT';

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		
    <div class="container-fluid">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->stkmovprtcod; ?><?= gethtml('stkmovprtcod','hidden',$vew_data->stkmovprtcod); ?></strong></h4></li>
			</ul>
      
      <div class="tab-content tmss-tab-content">
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
        	<div class="row">
					
						<div class="col-sm-6">
              <div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->deliverypriority; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('stkmovprtcodext', 'doccmt1x20', $vew_data->stkmovprtcodext, $lv_default)),	$vew_readonly);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('stkmovprttxt', 'doccmt1x50', $vew_data->stkmovprttxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                 ?>
                </div>               
              </div> <!-- /card -->
						</div> <!-- /col-6 -->
            <div class="col-sm-6"></div>
            
					</div> <!-- /row -->
        </div> <!-- /tabpanel -->
      </div> <!-- /tab-content -->
		</div> <!-- /container-fluid -->
  </form>
	<?php include('grldocfrmscr.frm'); ?>
</section>
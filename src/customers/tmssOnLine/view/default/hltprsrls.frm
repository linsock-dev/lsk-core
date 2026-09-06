<?php
	/* url del formulario */
  $lv_lnk = '?prg=hltprsrls&prm_prsrlscod='.$vew_data->prsrlscod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('prsrlstxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->prsrlscod;

	/* titulo */
	$lv_title = $vew_lang->roles;
	
	/* m�dulo y programa */
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'RLS';
	
	/* librer�a de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->prsrlscod; ?><input type="hidden" id="prsrlscod" name="prsrlscod" value="<?= $vew_data->prsrlscod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->rol; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 		'input'=>gethtml('prsrlscodext', 'doccod', $vew_data->prsrlscodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('prsrlstxt', 'doccmt1x50', $vew_data->prsrlstxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
						</div>
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->parameters; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?= vew_boot(array($lv_colsm210, $lv_colxs48), array('label'=>'Act. param. usr', 'input'=>gethtml('atrval001', 'checkbox', $vew_doc->getTagValue($vew_data->prsrlsatrval001,'updusrprm'), $lv_default) )); ?>
                </div> <!-- /body -->
              </div> <!-- /card -->
						</div>
					</div>
				</div> <!-- /_tab001 -->
				
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
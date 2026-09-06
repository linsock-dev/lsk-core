<?php
	// url del formulario
  $lv_lnk = '?prg=hhrwrkste&prm_wrkstecod='.$vew_data->wrkstecod;

	// campos requeridos
	$vew_input->RequiredFields( array('wrkstetxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->wrkstecod; 

	// titulo
	$lv_title = $vew_lang->workstation;
	
	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'WKS';
	
	// librería de estilos
  include_once('_library.frm');
?> 
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->wrkstecod; ?><?= gethtml('wrkstecod','hidden',$vew_data->wrkstecod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
          <div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('wrkstecodext','doccmt1x20', $vew_data->wrkstecodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('wrkstetxt', 	'doccmt1x50', $vew_data->wrkstetxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 'input'=>gethtml('wrkstetyp', [''=>'','D'=>'DEPARTAMENTO', 'S'=>'SERVICIO', 'F'=>'FUNCI&Oacute;N'], $vew_data->wrkstetyp, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
								</div>
              </div>
            </div>
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->jobdescription; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?= vew_boot($lv_col12, array('input'=>gethtml('wrkstedes', 'doccmt5x50', $vew_data->wrkstedes, $lv_default) )); ?>
								</div>
            </div>
          </div>
				</div><!-- /tab-panel -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <?php include('grldocfrmscr.frm'); ?>
</section>
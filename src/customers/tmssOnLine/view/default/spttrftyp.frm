<?php
	// url del formulario
  $lv_lnk = '?prg=spttrftyp&prm_spttrftypcod='.$vew_data->spttrftypcod;

	// campos requeridos
	$vew_input->RequiredFields( array('','spttrftyptxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->spttrftypcod;

	// titulo
	$lv_title = $vew_lang->tariffstypes;
	
	// módulo y programa
	$lv_mdlcod = 'SPT';
	$lv_prgcod = 'TRT';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
		    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapa -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->spttrftypcod; ?><?= gethtml('spttrftypcod','hidden',$vew_data->spttrftypcod); ?></strong></h4></li>
			</ul>
      <div class="tab-content tmss-tab-content">
			<!-- Tablas -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
						
              <div class="card">
            		<div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
            		<div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('spttrftypcodext', 'doccodext', $vew_data->spttrftypcodext, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('spttrftyptxt', 'doccmt1x50', $vew_data->spttrftyptxt, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
								</div>
              </div>
							
            </div>
						<div class="col-md-6">
						
              <div class="card">
            		<div class="card-header"><div class="card-title"><?= $vew_lang->period; ?></div></div>
            		<div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_colsm210, array('label'=>$vew_lang->period,			'input'=>gethtml('spttrftypprd', array(''=>'','U'=>'UNICO','M'=>'MENSUAL','Y'=>'ANUAL'), $vew_doc->getTagValue($vew_data->spttrftypatr,'prd'), $lv_default, true) ));
                    echo vew_boot( array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->activity, 'input'=>gethtml('spttrftypact', 'checkbox', $vew_doc->getTagValue($vew_data->spttrftypatr,'act'), $lv_default) ));
                    echo vew_boot( array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->tournament, 'input'=>gethtml('spttrftyptrn', 'checkbox', $vew_doc->getTagValue($vew_data->spttrftypatr,'trn'), $lv_default) ));
                    echo vew_boot( array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->partner, 'input'=>gethtml('spttrftypptn', 'checkbox', $vew_doc->getTagValue($vew_data->spttrftypatr,'ptn'), $lv_default) ));
                  ?>
                </div>
              </div>
							
            </div> <!-- / col -->
          </div> <!-- /row -->
      	</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div><!-- /container-fluid -->
  </form>
  <?php include('grldocfrmscr.frm'); ?>
</section>
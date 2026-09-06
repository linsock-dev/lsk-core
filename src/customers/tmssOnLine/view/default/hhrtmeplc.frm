<?php
	// url del formulario
  $lv_lnk = '?prg=hhrtmeplc&prm_hhrtmeplccod='.$vew_data->hhrtmeplccod;

	// campos requeridos
	$vew_input->RequiredFields( array('hhrtmeplctxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->hhrtmeplccod;

	// titulo
	$lv_title = $vew_lang->placeofregistration;
	
	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'TMP';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('hhrtmeplcatr','hidden',$vew_data->hhrtmeplcatr); ?>
		<div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hhrtmeplccod; ?><?= gethtml('hhrtmeplccod','hidden',$vew_data->hhrtmeplccod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">		
					<div class="row">
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
								<div class="card-body tmss-card-body-edit">
									<?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('hhrtmeplccodext', 'doccodext', $vew_data->hhrtmeplccodext, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hhrtmeplctxt', 'doccmt1x50', $vew_data->hhrtmeplctxt, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
								</div>
							</div><!-- /card -->
						</div><!-- /col-md-6 -->
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->attributes; ?></div></div>
								<div class="card-body tmss-card-body-edit">
									<?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->workplace,
                                                    'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly ),
                                                                        array('input'=>gethtml('wrkplctxt', 'typeahead', $vew_data->wrkplctxt, $lv_default ) )) )); 
                  	echo gethtml('wrkplccod','hidden',$vew_data->wrkplccod);
									?>
								</div>
							</div> <!-- /card -->
						</div> <!-- /col-md-6 -->
					</div> <!-- /row -->
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
		</div> <!-- /container-fluid -->
  </form>
	<script>
    //Typeahead Clasificacion 
    var lo_get = { "fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"p.docsts":"A"}, "fldasg" : {"wrkplccod":"wrkplccod", "wrkplctxt" : "wrkplctxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #wrkplctxt"), "hhrwrkplc", lo_get)	
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
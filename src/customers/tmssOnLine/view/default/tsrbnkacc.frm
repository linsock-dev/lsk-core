<?php
	/* url del formulario */
  $lv_lnk = '?prg=tsrbnkacc&prm_bnkacccod='.$vew_data->bnkacccod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('bnkacctxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->bnkacccod;

	/* titulo */
	$lv_title = $vew_lang->account;
	
	/* módulo y programa */
	$lv_mdlcod = 'TSR';
	$lv_prgcod = 'BNA';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <!-- Nav-bar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->bnkacccod; ?><?= gethtml('bnkacccod', 'hidden', $vew_data->bnkacccod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">	
        <!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code,'input'=>gethtml('bnkacccodext', 'doccmt1x50', $vew_data->bnkacccodext, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('bnkacctxt', 'doccmt1x50', $vew_data->bnkacctxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->currency,
                         	                          'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                    array('input'=>gethtml('curcod', 'curcod', $vew_data->curcod, $lv_always_disabled ) ))
                                                    ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status,'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
                </div>
             	</div>
          	</div>
            <div class="col-md-6"><?php include('grldatbnk.frm'); ?></div>
					</div>
          <div class="row">
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= 'Cuenta Deudora'; ?></div></div>
								<?php include('grldatacc.frm'); ?>
							</div>
						</div>
					</div>
					</div> <!-- fin _tab001 -->
		  	</div> <!-- tabcontent -->
  		</div> <!-- container-fluid -->
  	</form>
	<script>
    // curcod
    var lo_get = {"fldsec": "<?= $lv_sec; ?>" ,"fldasg": {"curcod":"curcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #curcod"), "admcur", lo_get);
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
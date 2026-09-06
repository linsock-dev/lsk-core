<?php
	// url del formulario 
  $lv_lnk = '?prg=finacc&prm_finacccod='.$vew_data->finacccod;

	// campos requeridos 
	$vew_input->RequiredFields( array('finacctxt','curcod','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->finacccod;

	// titulo 
	$lv_title = $vew_lang->account;
	
	// módulo y programa 
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'ACC';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden','')?>
		
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->finacccod; ?><?= gethtml('finacccod','hidden',$vew_data->finacccod) ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              <div class="card tmss-hot-ttl">
              	<div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,			'input'=>gethtml('finacccodext', 'doccmt1x20', $vew_data->finacccodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('finacctxt', 'doccmt1x50', $vew_data->finacctxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
						</div>
						<div class="col-md-6">
              <div class="card tmss-hot-ttl">
              	<div class="card-header"><div class="card-title"><?= $vew_lang->data; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->classification,	'input'=>gethtml('finaccclscod', 'finaccclscod', $vew_data->finaccclscod, ($vew_data->finacccod==''?$lv_default:$lv_always_disabled) ) ));
                    echo vew_boot($lv_col237, array('label'=>$vew_lang->currency,				'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('curcod', 'curcod', $vew_data->curcod, $lv_always_disabled ) )) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->comments,				'input'=>gethtml('finacctxtext', 'doccmt5x50', $vew_data->finacctxtext, $lv_default) ));
                  ?>
                 <!-- <div class="form-group tmss-form-group">
                    <label class="col-xs-2 control-label text-nowrap"><?= $vew_lang->profile; ?></label>
                    <div class="col-xs-10"></div>
                  </div> -->
                </div>  
              </div>
						</div>
					</div>
				</div> <!-- /_tab001 -->

			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		// curcod y curtxt
    var lo_get = {"fldsec":"<?=$lv_sec;?>", "fldasg":{"curcod":"curcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #curcod"), "admcur", lo_get);
	</script>
   <!-- Form Submit -->
	<?php include('grldocfrmscr.frm'); ?>
</section>
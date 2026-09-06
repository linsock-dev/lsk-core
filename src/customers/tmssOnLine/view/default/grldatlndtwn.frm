<?php
	// url del formulario
  $lv_lnk = '?prg=grldatlndtwn&prm_lndtwncod='.$vew_data->lndtwncod;

	// campos requeridos
	$vew_input->RequiredFields( array('lndtwntxt','lndtxt','lndcod','lndregtxt','lndregcod','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->lndtwncod; 

	// titulo
	$lv_title = $vew_lang->city;
	
	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'TWN';
		
	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
    
		<div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->lndtwncod; ?><?= gethtml('lndtwncod', 'hidden', $vew_data->lndtwncod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-sm-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('lndtwncodext', 'doccmt1x20', $vew_data->lndtwncodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('lndtwntxt', 'doccmt1x50', $vew_data->lndtwntxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); 
                  ?>
                </div>
              </div>
            </div>
						<div class="col-sm-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->place; ?></div></div>
                <div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col210, array('label'=>$vew_lang->country, 'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('lndtxt', 'typeahead', $vew_data->lndtxt, $lv_default) )) ));
										echo gethtml('lndcod', 'hidden', $vew_data->lndcod);
										echo vew_boot($lv_col210, array('label'=>$vew_lang->region, 'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('lndregtxt', 'typeahead', $vew_data->lndregtxt, $lv_default) )) ));
										echo gethtml('lndregcod', 'hidden', $vew_data->lndregcod);
										echo vew_boot($lv_col210, array('label'=>$vew_lang->area, 'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('lndtwngrptxt', 'typeahead', $vew_data->lndtwngrptxt, $lv_default) )) ));
										echo gethtml('lndtwngrpcod', 'hidden', $vew_data->lndtwngrpcod);
									?>
                </div>
              </div>
            </div>
					</div>
				</div>
			</div> <!-- /tab-content -->
		</div> <!-- /tabpanel -->
  </form>
	<script>
		// lndtxt
		var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"lndcod" : "lndcod", "lndtxt" : "lndtxt"}}; 
		tmssTypeahead($("#<?= $lv_sec; ?> #lndtxt"), "grladrlnd", lo_get, {"afterAssign": function(){ $("#<?= $lv_sec; ?> #lndcod").change(); }});

		// lndregtxt
		var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"lndregcod" : "lndregcod", "lndregtxt" : "lndregtxt"}, "fldflt" : {"l.lndcod" : $("#<?= $lv_sec; ?> #lndcod")}}; 
		tmssTypeahead($("#<?= $lv_sec; ?> #lndregtxt"), "grladrlndreg", lo_get);
		
		// lndtwngrptxt
		var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"lndtwngrpcod":"lndtwngrpcod", "lndtwngrptxt" : "lndtwngrptxt"}}; 
		tmssTypeahead($("#<?= $lv_sec; ?> #lndtwngrptxt"), "grldatlndtwngrp", lo_get);
	</script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
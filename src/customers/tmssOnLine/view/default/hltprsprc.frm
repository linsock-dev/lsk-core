<?php
	// url del formulario 
  $lv_lnk = '?prg=hltprsprc&prm_prsprccod='.$vew_data->prsprccod;

	// campos requeridos 
	$vew_input->RequiredFields( array('prsprctyp','prsprcval','curcod','prsprcdtestr','prsprcdteend','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->prsprccod;

	// titulo 
	$lv_title = $vew_lang->prices;
	
	// m�dulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PRC';
	
	// librer�a de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->prsprccod; ?><?= gethtml('prsprccod','hidden',$vew_data->prsprccod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->prices; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 		'input'=>gethtml('prsprctyp', 'prsprctyp_lst', $vew_data->prsprctyp, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->specialty,
                                                    'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                        array('input'=>gethtml('spctxt', 'typeahead', $vew_data->spctxt,$lv_default) )) ));
                  	echo gethtml('spccod', 'hidden', $vew_data->spccod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->provider,
                                                    'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                        array('input'=>gethtml('prstxt', 'typeahead', $vew_data->prstxt,$lv_default) ))));
                  	echo gethtml('prscod', 'hidden', $vew_data->prscod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->diseaseclassification, 
																										'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
																																				array('input'=>gethtml('hltdisclstxt', 'typeahead', $vew_data->hltdisclstxt, $lv_default) ))));
                    echo gethtml('hltdisclscod', 'hidden', $vew_data->hltdisclscod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->patient,
                                                    'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                        array('input'=>gethtml('pattxt', 'typeahead', $vew_data->pattxt,$lv_default) ))));
                  	echo gethtml('patcod', 'hidden', $vew_data->patcod);
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));										
                  ?>
                </div> <!-- /body -->
              </div> <!-- /card -->
						</div>
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->values; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col273, array('label'=>$vew_lang->value,	
                                                    'input1'=>gethtml('prsprcval', 'docqty', $vew_data->prsprcval, $lv_default),
                                                    'input2'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                        array('input'=>gethtml('curcod', 'curcod', $vew_data->curcod,$lv_always_disabled ) )) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->start,	'input'=>gethtml('prsprcdtestr', 'docdte', $vew_data->prsprcdtestr, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->end,		'input'=>gethtml('prsprcdteend', 'docdte', $vew_data->prsprcdteend, $lv_default) ));
                  ?>
                </div> <!-- /body -->
              </div> <!-- /card -->
						</div>
					</div>
				</div> <!-- /_tab001 -->

			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		// spctxt
		var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldasg" : {"spctxt" : "spctxt", "spccod":"spccod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #spctxt"), "hltspc", lo_get);
		
		// prstxt
		var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldasg" : {"prstxt" : "prstxt", "prscod":"prscod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #prstxt"), "hltprs", lo_get);
		
		// pattxt
		var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldasg" : {"pattxt" : "pattxt", "patcod":"patcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #pattxt"), "hltpat", lo_get);
		
		// curcod
		var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldasg" : {"curcod" : "curcod"}, "typeahead":false }; 
    tmssTypeahead($("#<?= $lv_sec; ?> #curcod"), "admcur", lo_get);
		
    // clasificacion de enfermedad
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"docsts" : "A"}, "fldasg" : {"hltdisclstxt" : "hltdisclstxt", "hltdisclscod" : "hltdisclscod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #hltdisclstxt"), "hltdiscls", lo_get);
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
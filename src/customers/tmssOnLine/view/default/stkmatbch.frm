<?php
	// url del formulario
  $lv_lnk = '?prg=stkmatbch&prm_matbchcod='.$vew_data->matbchcod;

	// campos requeridos
	$vew_input->RequiredFields( array('matbchcodext','matcod','mattxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->matbchcod;

	// titulo
	$lv_title = $vew_lang->batch;

	// m?dulo y programa
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'BCH';

	// librer?a de estilos bootstrap
	include_once('_library.frm');

  // Botones por Vista
  $vew_tbl['hisL'] = array('pos'=>'L', 'per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'19'), 'id'=>'btnhst', 'ttl'=>$vew_lang->history, 'icn'=>'fas fa-history', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn','acc'=>'');
  $vew_tbl['hisR'] = array('pos'=>'R', 'per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'19'), 'id'=>'btnhst', 'ttl'=>$vew_lang->history, 'icn'=>'fas fa-history', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn','acc'=>'');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
        <li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->matbchcod; ?><?= gethtml('matbchcod','hidden',$vew_data->matbchcod) ?></strong></h4></li>
			</ul>
      <div class="row">
        <div class="col-md-6">
				
          <div class="card">
            <div class="card-header"><div class="card-title"><?= $vew_lang->batch; ?>
              	<span class="tmss-card-icon">
									<span><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
              		<?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
								</span>
            	</div>
            </div>
						<div class="card-body tmss-card-body-edit">
							<?php
							echo vew_boot($lv_col210, array('label'=>$vew_lang->material,
																							'input'=>vew_boot(	
																								array('style'=>'search', 'readonly'=>($vew_data->matbchcod == '' ? $vew_readonly : true)),
																								array('input'=>gethtml('mattxt',	'typeahead',	$vew_data->mattxt, ($vew_data->matbchcod == '' ? $lv_default : $lv_always_disabled)) )
																							))
														);
								echo gethtml('matcod', 'hidden', $vew_data->matcod);
								echo vew_boot($lv_col210, array('label'=>$vew_lang->batch,	'input'=>gethtml('matbchcodext','doccmt1x20', $vew_data->matbchcodext,$lv_default) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->duedate,'input'=>gethtml('matbchduedte', 'docdte', $vew_data->matbchduedte, $lv_default) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', 			'docsts', $vew_data->docsts, 			$lv_default) ));
							?>
						</div>
					</div>
					
				</div>
        <div class="col-md-6">
				
          <div class="card">
						<div class="card-header"><div class="card-title"><?= $vew_lang->supplier; ?></div></div> 
						<div class="card-body tmss-card-body-edit">
							<?php
								echo vew_boot($lv_col210, array('label'=>$vew_lang->supplier,
																								'input'=>vew_boot(	
																									array('style'=>'search', 'readonly'=>$vew_readonly), 
																									array('input'=>gethtml('suptxt',	'typeahead',	$vew_data->suptxt, $lv_default) )
																								))
															);
								echo vew_boot($lv_col210, array('label'=>$vew_lang->productiondate,'input'=>gethtml('matbchprddte', 'docdte', $vew_data->matbchprddte, $lv_default) ));
								echo gethtml('supcod', 'hidden', $vew_data->supcod);
							?>
						</div>
					</div>
					
				</div>
			</div>
		</div>
  </form>
	<script>
		// HISTORIAL
		$("#<?= $lv_sec; ?> #btnhst").on("click",function(e){ e.preventDefault();
			tmssPopup("<?= $vew_lang->history; ?>","?prg=stkmovdocmat&act=08&prm_vewcod=VEW_STK_MAT_BCH_HST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldflt=[dm.matbchcod:<?= $vew_data->matbchcod; ?>]");
		});
    
    // MATERIAL
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"m.docsts":"A", "m.matusebch":"1"}, "fldasg":{"mattxt":"mattxt", "matcod":"matcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #mattxt"), "stkmat", lo_get);
    
    // PROVEEDOR
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"s.docsts":"A"}, "fldasg":{"suptxt":"suptxt", "supcod":"supcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #suptxt"), "buysup", lo_get);
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
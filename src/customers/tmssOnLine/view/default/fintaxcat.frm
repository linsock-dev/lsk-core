<?php	
	// url del formulario
  $lv_lnk = '?prg=fintaxcat&prm_lndcod='.$vew_data->lndcod.'&prm_taxcatcod='.$vew_data->taxcatcod;

	// campos requeridos
	$vew_input->RequiredFields( array('taxcatcod', 'taxcattxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->taxcatcod;

	// titulo
	$lv_title = $vew_lang->taxcategory;
	
	// módulo y programa
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'TCT';
	
  // librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('taxcatcodsve', 'hidden', $vew_data->taxcatcodsve); ?>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->taxcatcod; ?></strong><?=($vew_data->taxcatcod != '') ? gethtml('taxcatcod', 'hidden', $vew_data->taxcatcod) : '';?></h4></li>
      </ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">		
          <div class="row">
						<div class="col-md-6">
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                  <?php 
                  	if( $vew_data->taxcatcod == '' ){ echo vew_boot($lv_col210, array('label'=>$vew_lang->id,'input'=>gethtml('taxcatcod', 'doccmt1x50', $vew_data->taxcatcod, $lv_default) )); }
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->country, 	
                                                    'input'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->taxcatcod == '' ? $vew_readonly:$lv_always_disabled) ), 
                                                                        array('input'=>gethtml('lndtxt', 'adrlndtxt', $vew_data->lndtxt, ($vew_data->taxcatcod == '' ? $lv_default:$lv_always_disabled) ) )) )); 
                  	echo gethtml('lndcod', 'hidden', $vew_data->lndcod);	
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('taxcattxt', 'doccmt1x50', $vew_data->taxcattxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 		'docsts', 		$vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
            </div>
          </div> 
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		// lndtxt
    var lp_get = {"fldsec": "<?= $lv_sec; ?>", "fldasg": {"lndtxt" : "lndtxt", "lndcod" : "lndcod"} };
    tmssTypeahead($("#<?= $lv_sec; ?> #lndtxt"), "grladrlnd", lp_get);
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
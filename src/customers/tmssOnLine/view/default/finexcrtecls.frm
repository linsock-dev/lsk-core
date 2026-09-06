<?php
	// url del formulario 
  $lv_lnk = "?prg=finexcrtecls&prm_excrteclscod=".$vew_data->excrteclscod;

	// campos requeridos 
	$vew_input->RequiredFields( array('excrteclstxt','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->excrteclscod; 

	// titulo 
	$lv_title = $vew_lang->ExchangeRateClasses;
	
	// módulo y programa 
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'EXC';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->excrteclscod; ?><?= gethtml('excrteclscod','hidden',$vew_data->excrteclscod)?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">		
          <div class="row">
						<div class="col-md-6">
              <div class="card">
              	<div class="card-header">
                	<div class="card-title"><?= $lv_title; ?>
                  	<span class="tmss-card-icon"><i class="fas fa-adjust"></i></span>
                  </div>
								</div>
								<div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 		'input'=>gethtml('excrteclscodext', 'doccmt1x20', $vew_data->excrteclscodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('excrteclstxt', 'doccmt1x50', $vew_data->excrteclstxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
            </div>
          </div>
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form><!-- Form Submit -->
	<?php include('grldocfrmscr.frm'); ?>
</section>
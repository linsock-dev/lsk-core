<?php		
	// url del formulario
  $lv_lnk = '?prg=logvhccls&prm_vhcclscod='.$vew_data->vhcclscod;

	// campos requeridos
	$vew_input->RequiredFields( array('vhcclscod','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->vhcclscod; 

	// titulo
	$lv_title = $vew_lang->vehiclesClass;
	
	// módulo y programa
	$lv_mdlcod = 'LOG';
	$lv_prgcod = 'VCC';
	
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
				<li class="pull-right"><h4>#<strong><?= $vew_data->vhcclscod; ?><?= gethtml('vhcclscod','hidden',$vew_data->vhcclscod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="rows">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $lv_title; ?></div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,	'input'=>gethtml('vhcclscodext', 'doccmt1x20',	$vew_data->vhcclscodext, $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('vhcclstxt', 'doccmt1x50', $vew_data->vhcclstxt, $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts,	$lv_default) )); 
                  ?>
                </div>
              </div>
						</div>
					</div>
				</div>
			</div> <!-- tabcontent -->    
		</div> <!-- /container-fluid -->
  </form>
  <!-- Include del script-->
  <?php include('grldocfrmscr.frm'); ?>
</section>
<?php
	// url del formulario
  $lv_lnk = '?prg=hhrwrkplc&prm_wrkplccod='.$vew_data->wrkplccod;

	// campos requeridos
	$vew_input->RequiredFields( array('wrkplctxt','docsts','lndcod') );

	// clave del documento
	$lv_dockey = $vew_data->wrkplccod; 

	// titulo
	$lv_title = $vew_lang->workplace;
	
	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'WKP';
	
	// librería de estilos
  include_once('_library.frm');
?> 
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->wrkplccod; ?><?= gethtml('wrkplccod','hidden',$vew_data->wrkplccod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
          <div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                    <span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                    <?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('wrkplccodext','doccmt1x20', $vew_data->wrkplccodext, $lv_default) ));
                    echo gethtml('adrnme001','hidden',$vew_data->adrnme001);
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('wrkplctxt', 	'doccmt1x50', $vew_data->wrkplctxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
								</div>
              </div>
            </div> 
          </div>
             
          <!-- DIRECCION / CONTACTO -->
          <div class="row">
            <div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
            <div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
          </div>

				</div><!-- /tab-panel -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <script>	
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {					
        $("#<?= $lv_sec; ?> #adrnme001").prop("value", $("#<?= $lv_sec; ?> #wrkplctxt").val());
				if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adreml")) ) { return false; }
				if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adrwebpge")) ) { return false; }
			}	
    }
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
<?php
	// url del formulario 
  $lv_lnk = '?prg=slspos&prm_slsposcod='.$vew_data->slsposcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('slspostxt','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->slsposcod;

	// titulo 
	$lv_title = $vew_lang->pointofsales;
	
	// módulo y programa 
	$lv_mdlcod = 'SLS';
	$lv_prgcod = 'POS';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!--navbar-->
  <?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
    <div class="container-fluid" role="tabpanel">
      <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
        <li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
    		<li class="pull-right"><h4># <strong><?= $vew_data->slsposcod; ?><?= gethtml('slsposcod', 'hidden', $vew_data->slsposcod); ?></strong></h4></li>
			</ul>
      <div class="row">
        <div class="col-md-6">
          <div class="card">
            <div class="card-header"><div class="card-title"><?= $vew_lang->pointofsales; ?></div></div>
            <div class="card-body tmss-card-body-edit">
              <?php 
                echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('slsposcodext', 'doccodext', $vew_data->slsposcodext, $lv_default) ));
                echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('slspostxt', 'doccmt1x50', $vew_data->slspostxt, $lv_default) ));
                echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
              ?>
            </div>
          </div>
        </div> <!--Cliente-->
      </div>
      <!-- DIRECCION / CONTACTO -->
      <div class="row">
        <div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
        <div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
      </div>
    </div> <!-- container-fluid -->
  </form>
	<script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
      // al grabar
			if ( lp_prm["action"]=="00" ) {
				if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adreml")) ) { return false; }
				if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adrwebpge")) ) { return false; }
			}
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
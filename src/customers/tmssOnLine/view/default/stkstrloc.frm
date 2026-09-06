<?php
	/* url del formulario */
  $lv_lnk = '?prg=stkstrloc&prm_strloccod='.$vew_data->strloccod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('strloctxt','docsts','lndcod') );

	/* clave del documento */
	$lv_dockey = $vew_data->strloccod;

	/* titulo */
	$lv_title = $vew_lang->storelocation;

	/* m�dulo y programa */
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'STL';

  /* librer�a de estilos bootstrap */
  include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->strloccod; ?><input type="hidden" id="strloccod" name="strloccod" value="<?= $vew_data->strloccod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          
        	<div class="row">
            <div class="col-md-6">
              <div class="card">
								<div class="card-header">
									<div class="card-title">
                    <?= $lv_title; ?>
                    <span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdocclstxt)); ?> <i class="fas fa-user"></i></span>
                    <?php
                      echo gethtml('sysdocclscod', 'hidden', $vew_data->sysdocclscod);
                      echo gethtml('sysdocclstxt', 'hidden', $vew_data->sysdocclstxt);
                    ?>
                  </div>
                </div> 
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('strloccodext','doccmt1x20', $vew_data->strloccodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('strloctxt', 	'doccmt1x50', $vew_data->strloctxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 			'docsts', 		$vew_data->docsts, $lv_default) ));
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
      	</div> 
      </div> <!-- tab-content -->
    </div> <!-- container-fluid -->
  </form>
  <script>
    // Submit EXT 
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      // al grabar
      if ( lp_prm["action"]=="00" ) {
        if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adreml")) ) { return false; }
        if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adrwebpge")) ) { return false; }
      }
    }
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
<?php	
	// url del formulario 
  $lv_lnk = '?prg=educar&prm_educarcod='.$vew_data->educarcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('educartxt','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->educarcod;

	// titulo 
	$lv_title = $vew_lang->career;
	
	// módulo y programa 
	$lv_mdlcod = 'EDU';
	$lv_prgcod = 'CAR';

  // librería de estilos
  include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?php echo gethtml('tmss_actcod', 'hidden', '');?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->educarcod; ?><?= gethtml( 'educarcod' , 'hidden', $vew_data->educarcod ); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->career; ?></div></div>   
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('educarcodext', 'doccodext',  $vew_data->educarcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('educartxt', 	 'doccmt1x50', $vew_data->educartxt,    $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 			 'docsts',     $vew_data->docsts,       $lv_default) ));
                  ?>
                </div>
              </div> <!-- /card -->
            </div> <!-- /col -->
          </div> <!-- /row -->
				</div> <!-- /tab-pane -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
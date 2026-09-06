<?php
	/* url del formulario */
  $lv_lnk = "?prg=stkmatcls&prm_matclscod=".$vew_data->matclscod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('matclstxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->matclscod;

	/* titulo */
	$lv_title = $vew_lang->classification;

	/* módulo y programa */
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'CLS';

	/* librería de estilos bootstrap */
	include_once('_library.frm');

	$vew_data->matclsord = $vew_doc->getTagValue( $vew_data->matclsatr, 'matclsord' );
	$vew_data->matclsimg = $vew_doc->getTagValue( $vew_data->matclsatr, 'matclsimg' );
?>

<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		
    <div class="container-fluid">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->matclscod; ?><input type="hidden" id="matclscod" name="matclscod" value="<?= $vew_data->matclscod; ?>"></strong></h4></li>
			</ul>
      
      <div class="tab-content tmss-tab-content">
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
        	<div class="row">
						<div class="col-sm-6">
              <div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $vew_lang->Classification; ?>
										<span class="tmss-card-icon"> <i class="fas fa-toolbox"></i>	</span>
              		</div>
								</div>
                
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('matclscodext', 'doccmt1x20', $vew_data->matclscodext, $lv_default)),	$vew_readonly);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('matclstxt', 'doccmt1x50', $vew_data->matclstxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                 ?>
                </div>
               
              </div> <!-- card -->
						</div> <!-- col-6 -->
            
            
            <div class="col-sm-6">
              <div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $vew_lang->sequence; ?>
										<span class="tmss-card-icon"> <i class="fas fa-toolbox"></i>	</span>
              		</div>
								</div>
                
                <div class="card-body tmss-card-body-edit">
                  <?php
                   echo vew_boot($lv_col210, array('label'=>$vew_lang->sequence, 'input'=>gethtml('matclsord', 'doccmt1x50', $vew_data->matclsord, $lv_default) ));
                    $vew_data->matclsimg = strtolower($vew_data->matclsimg);
                    echo vew_boot($lv_col291, array('label'=>$vew_lang->image,
                                              'input1'=>gethtml('matclsimg', 'doccmt1x50', $vew_data->matclsimg,	$lv_default),
                                              'input2'=>($vew_data->matclsimg==''?'':(substr($vew_data->matclsimg,0,6)=='class:'?'<span class="'.substr($vew_data->matclsimg,6,strlen($vew_data->matclsimg)-6).'"></span>':'<div class="center-text"><img class="img-responsive" src="/library/images/'.$vew_data->matclsimg.'"></div>'))	));
                  ?>
                </div>
               
              </div> <!-- card -->
						</div> <!-- col-6 -->
            
            
					</div> <!-- row -->
        </div> <!-- pane -->
      </div> <!-- tabcontent -->
		</div> <!-- container-fluid -->
  </form>
	<?php include('grldocfrmscr.frm'); ?>
</section>
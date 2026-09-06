<?php
	// url del formulario 
  $lv_lnk = "?prg=sptptncat&prm_ptncatcod=".$vew_data->ptncatcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('ptncattxt','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->ptncatcod; 

	// titulo 
	$lv_title = $vew_lang->categories; 
	
	// módulo y programa 
	$lv_mdlcod = 'SPT';
	$lv_prgcod = 'CAT';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->ptncatcod; ?><?= gethtml('ptncatcod','hidden',$vew_data->ptncatcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">	
          <div class="row">
						<div class="col-md-6">
						
          		<div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->code,	'input'=>gethtml('ptncatcodext', 'doccmt1x20',$vew_data->ptncatcodext, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>gethtml('spttrfcod', 'hidden', $vew_data->spttrfcod) )); //HIDDEN
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('ptncattxt',	'doccmt1x50', $vew_data->ptncattxt, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->sex,'input'=>gethtml('ptncatsex', 'adrsex', $vew_data->ptncatsex , $lv_default) ));
                	?>
                	<div class="form-group tmss-form-group">
                  	<label class="col-xs-2 control-label"><?= $vew_lang->age; ?></label>
                  	<div class="col-xs-4"><?= gethtml('ptncatagestr', 'docnum0300', $vew_data->ptncatagestr , $lv_default);?></div>
                  	<label class="col-xs-2 control-label"><?= $vew_lang->to; ?></label>
                  	<div class="col-xs-4"><?= gethtml('ptncatageend', 'docnum0300', $vew_data->ptncatageend , $lv_default);?></div>
                	</div>
                	<?php
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', 	$vew_data->docsts, $lv_default) ));
                	?>
                </div>
              </div>
							
            </div>
            <div class="col-md-6">
						
          		<div class="card">
                <div class="card-header">
                	<div class="card-title"><?= $vew_lang->DATA ?></div>
								</div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->tariff,	
                                                        'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                          array('input'=>gethtml('spttrftxt', 'typeahead', $vew_data->spttrftxt, $lv_default))
                                                                         ))
                                      );
                    echo gethtml('spttrftypcod', 'hidden', $vew_data->spttrftypcod);
                  	echo vew_boot( array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->manual,	'input'=>gethtml('ptncatchgman', 'checkbox', $vew_data->ptncatchgman, 	$lv_default) ));
                  ?>
                </div>
              </div>
							
            </div> <!-- /col -->
          </div> <!-- /row -->
        </div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <script>
	  var lo_get = {"fldsec": "<?= $lv_sec; ?>" ,"fldasg": {"spttrftxt":"spttrftxt", "spttrfcod":"spttrfcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #spttrftxt"), "spttrf", lo_get);
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
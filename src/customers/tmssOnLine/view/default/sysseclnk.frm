<?php
	// url del formulario 
  $lv_lnk = '?prg=sysseclnk&prm_sysseclnkcod='.$vew_data->sysseclnkcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('objtyp','usrgrpcod','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->sysseclnkcod;

	// titulo 
	$lv_title = $vew_lang->linking;

	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'SLK';

	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
		<!--navbar-->
   <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml( 'tmss_actcod' , 'hidden', '' ); ?>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->sysseclnkcod;?><?= gethtml( 'sysseclnkcod' , 'hidden', $vew_data->sysseclnkcod ); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

        
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
          <div class="col-md-4">
            <div class="card">
              <div class="card-header">
                <div class="card-title">
                  <?= $vew_lang->link; ?>
                </div>
              </div>
            	<div class="card-body tmss-card-body-edit">
                <?php
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->object,
                                                  'input'=> vew_boot(array('style'=>'search','readonly'=>$vew_readonly),
                                                          array('input'=>gethtml('objtyptxt',
                                                                                 'typeahead',
                                                                                 $vew_data->objtyptxt,
                                                                                 $lv_default)))));
                	echo gethtml('objtyp','hidden',$vew_data->objtyp);
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->role,
                                                  'input'=> vew_boot(array('style'=>'search','readonly'=>$vew_readonly),
                                                            array('input'=>gethtml('usrgrptxt',
                                                                                 'typeahead',
                                                                                 $vew_data->usrgrptxt,
                                                                                 $lv_default)))));	
                	echo gethtml('usrgrpcod','hidden',$vew_data->usrgrpcod);
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->parameter,
                                                  'input'=>gethtml('usrprmcod', 'secusrprmcod_lst', $vew_data->usrprmcod, $lv_default)));
     
                	echo vew_boot($lv_col210, array('label'=>$vew_lang->source,		'input'=>gethtml('sysseclnksrcfld', 'doccmt1x20', $vew_data->sysseclnksrcfld, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->status,		'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                ?>
               
              </div>
            </div>
            </div>
          </div>
				</div>

			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->

  </form>
  <script>
    //Datos typeahead
    //OBJTYP
       	var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"o.docsts":"A"}, "fldasg":{"objtyptxt":"objtyptxt", "objtyp":"objtypcod"}};
      	tmssTypeahead($("#<?= $lv_sec; ?> #objtyptxt"),'sysobjtyp',lo_get);
    //Usrgrp
        var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"docsts":"A"}, "fldasg":{"usrgrptxt":"usrgrptxt", "usrgrpcod":"usrgrpcod"}};
      	tmssTypeahead($("#<?= $lv_sec; ?> #usrgrptxt"),'syssecgrp',lo_get);

  </script>
    <?php include('grldocfrmscr.frm') ?>
</section>
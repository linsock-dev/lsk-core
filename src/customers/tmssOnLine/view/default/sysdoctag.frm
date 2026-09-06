<?php 
	// url del formulario
  $lv_lnk = '?prg=sysdoctag&prm_sysdoctagcod='.$vew_data->sysdoctagcod;

	// campos requeridos
	$vew_input->RequiredFields( array('sysdoctagtxt','objtypcod','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->sysdoctagcod;

	// titulo
	$lv_title = $vew_lang->message;

	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'TAG';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>

    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
        <li class="pull-right"><h4># <strong><?= $vew_data->sysdoctagcod; ?><?= gethtml('sysdoctagcod', 'hidden', $vew_data->sysdoctagcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row"> 
            <div class="col-md-6">
						
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $vew_lang->tag; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('sysdoctagcodext', 'doccodext', $vew_data->sysdoctagcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('sysdoctagtxt', 'doccmt1x50', $vew_data->sysdoctagtxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
            		</div>
              </div>
						
						</div>
            <div class="col-md-6">
						
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $vew_lang->attributes; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->object, 	'input'=>gethtml('objtypcod','doccmt1x20', $vew_data->objtypcod, $lv_default ) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->color,    'input'=>gethtml('sysdoctagatrclr', 'color',  $vew_doc->gettagvalue($vew_data->sysdoctagatr,'clr'), $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->authorizationcode, 'input'=>gethtml('autcod', 'autcod', $vew_data->autcod, $lv_default) ));
                  ?>
                </div>
              </div>
							
						</div>
					</div>
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <!-- Form Submit -->
	<?php include('grldocfrmscr.frm'); ?>
</section>
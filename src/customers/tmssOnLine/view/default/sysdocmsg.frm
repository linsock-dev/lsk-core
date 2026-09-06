<?php 
	// url del formulario
  $lv_lnk = '?prg=sysdocmsg&prm_sysdocmsgcod='.$vew_data->sysdocmsgcod;

	// campos requeridos
	$vew_input->RequiredFields( array('sysdocmsgtxt','objtypcod','sysdocmsgatrtyp','sysdocmsgatrfrm','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->sysdocmsgcod;

	// titulo
	$lv_title = $vew_lang->message;

	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'MSG';
	
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
        <li class="pull-right"><h4># <strong><?= $vew_data->sysdocmsgcod; ?><?= gethtml('sysdocmsgcod', 'hidden', $vew_data->sysdocmsgcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row"> 
            <!--Primera tarjeta-->
            <div class="col-md-6">
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $vew_lang->MESSAGECLASSES; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('sysdocmsgcodext', 'doccodext', $vew_data->sysdocmsgcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('sysdocmsgtxt', 'doccmt1x50', $vew_data->sysdocmsgtxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
            		</div>
              </div>
						</div>
            <!--Segunda tarjeta-->
            <div class="col-md-6">
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $vew_lang->parameters; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->object, 'input'=>gethtml('objtypcod','objtypcod_lst', $vew_data->objtypcod, ($vew_data->sysdocmsgcod==''?$lv_default:$lv_always_disabled) ) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->type,			'input'=>gethtml('sysdocmsgatrtyp',array(''=>'','pdf'=>'Pantalla/Impreso','scr'=>'Script','ajx'=>'Ajax'),$vew_doc->getTagValue($vew_data->sysdocmsgatr,'msgtyp'), $lv_default, true) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->form, 		'input'=>gethtml('sysdocmsgatrfrm', 'doccmt2x100', $vew_doc->getTagValue($vew_data->sysdocmsgatr,'msgfrm'), $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->authorizationcode, 'input'=>gethtml('autcod', 'autcod', $vew_data->autcod, $lv_default) ));
                  ?>
                </div>
              </div>
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->sendbyemail; ?></div></Div>
                <div class="card-body">
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->userexit, 'input'=>gethtml('sysdocmsgatremlext', 'doccmt2x100', $vew_doc->getTagValue($vew_data->sysdocmsgatr,'emlext'), $lv_default) )); ?>
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->template, 'input'=>gethtml('sysdocmsgatremltxt', 'doccmt1x50', $vew_doc->getTagValue($vew_data->sysdocmsgatr,'emltxt'), $lv_default) )); ?>
                </div>
              </div>
						</div>
					</div>
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
  <!-- Form Submit -->
	<?php include('grldocfrmscr.frm'); ?>
</section>
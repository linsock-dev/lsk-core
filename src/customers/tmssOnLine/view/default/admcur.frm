<?php
	// url del formulario
  $lv_lnk = '?prg=admcur&prm_vewcod='.$vew_data->curcod;

	// campos requeridos
	$vew_input->RequiredFields( array('curcod','curtxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->curcodint;

	// titulo
	$lv_title = $vew_lang->currency;
	
	// módulo y programa
	$lv_mdlcod = 'ADM';
	$lv_prgcod = 'CUR';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->curcodint; ?><?= gethtml('curcodint','hidden',$vew_data->curcodint); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
        
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">		
          <div class="row">
						<div class="col-md-6">
              
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,	'input'=>gethtml('curcod', 'doccmt1x50', $vew_data->curcod, ($vew_actcod=='01'?$lv_default:$lv_always_disabled) )));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('curtxt', 'doccmt1x50', $vew_data->curtxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
              
            </div><!-- /col -->
						<div class="col-md-6">

              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->settings; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col39, array('label'=>$vew_lang->sign,		 'input'=>gethtml('cursgn', 'doccmt1x2', $vew_data->cursgn, $lv_default )));
                    echo vew_boot($lv_col39, array('label'=>$vew_lang->decimals, 'input'=>gethtml('curdec', 'docnum0300', $vew_data->curdec, $lv_default )));
                    echo vew_boot($lv_col39, array('label'=>$vew_lang->description.' ('.$vew_lang->short.')', 'input'=>gethtml('curtxtsht', 'doccmt1x10', $vew_data->curtxtsht, $lv_default) ));
                    echo vew_boot($lv_col39, array('label'=>$vew_lang->description.' ('.$vew_lang->medium.')', 'input'=>gethtml('curtxtmed', 'doccmt1x20', $vew_data->curtxtmed, $lv_default) ));
                  ?>
                </div>
              </div>

            </div><!-- /col -->
          </div><!-- /row -->
				</div> <!-- /_tab001 -->
        
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <?php include('grldocfrmscr.frm'); ?>
</section>
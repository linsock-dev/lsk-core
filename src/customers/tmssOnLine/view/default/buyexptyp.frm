<?php
	/* url del formulario */
  $lv_lnk = '?prg=buyexptyp&prm_buyexptypcod='.$vew_data->buyexptypcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('buyexptyptxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->buyexptypcod;

	/* titulo */
	$lv_title = $vew_lang->type;

	/* m�dulo y programa */
	$lv_mdlcod = 'BUY';
	$lv_prgcod = 'EXT';

	/* librer�a de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<!-- Nav-Bar -->
  <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->buyexptypcod; ?><input type="hidden" id="buyexptypcod" name="buyexptypcod" value="<?= $vew_data->buyexptypcod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              
               <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('buyexptypcodext', 'doccmt1x20', $vew_data->buyexptypcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('buyexptyptxt', 'doccmt1x50', $vew_data->buyexptyptxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
						    </div>
              </div>
						</div>
						<div class="col-md-6">
							<div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->account; ?>
                  </div>
                </div>
                  <?php include('grldatacc.frm'); ?>
              </div>
						</div>
					</div>
				</div> <!-- fin _tab001 -->

			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
 	<?php include('grldocfrmscr.frm'); ?>
</section>
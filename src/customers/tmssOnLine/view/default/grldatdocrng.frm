<?php
	/* url del formulario */
  $lv_lnk = "?prg=grldatdocrng&prm_docrngcod=".$vew_data->docrngcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('docrngtxt','objtypcod','docrngstrnum','docrngendnum','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->docrngcod;

	/* titulo */
	$lv_title = $vew_lang->numerationrange;

	/* módulo y programa */
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'RNG';

	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

	<!--navbar-->
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<textarea style="display: none;" id="sysdocclsatr_dat" name="sysdocclsatr_dat"></textarea>

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
        <li class="pull-right"><h4># <strong><?= $vew_data->docrngcod; ?><?= gethtml( 'docrngcod' , 'hidden', $vew_data->docrngcod ); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              
              <div class="card">
								<div class="card-header">
									<div class="card-title"><?= $vew_lang->numerationrange; ?></div>
								</div>
								<div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			 'input'=>gethtml('docrngcodext','doccod', $vew_data->docrngcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('docrngtxt', 'doccmt1x50', $vew_data->docrngtxt, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 'input'=>gethtml('objtypcod','objtypcod_lst', $vew_data->objtypcod, ($vew_actcod=='01'?$lv_default:$lv_always_disabled) ) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
								</div>
							</div>
              
						</div>
						<div class="col-md-6">
              
              <div class="card">
								<div class="card-header">
									<div class="card-title"><?= $vew_lang->numeration; ?></div>
								</div>
								<div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->start, 	'input'=>gethtml('docrngstrnum','docrngnum', $vew_data->docrngstrnum, $lv_default ) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->end, 		'input'=>gethtml('docrngendnum','docrngnum', $vew_data->docrngendnum, $lv_default ) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->current,'input'=>gethtml('docrngcurnum','docrngnum', $vew_data->docrngcurnum, $lv_default ) ));
                  ?>
                </div>
              </div>
						</div>
					</div>
				</div> <!-- fin _tab001 -->

			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>

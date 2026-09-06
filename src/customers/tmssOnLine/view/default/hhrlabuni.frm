<?php
	/* url del formulario */
  $lv_lnk = '?prg=hhrlabuni&prm_hhrlabunicod='.$vew_data->hhrlabunicod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('hhrlabunitxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->hhrlabunicod;

	/* titulo */
	$lv_title = $vew_lang->workersunion;
	
	/* módulo y programa */
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'LUN';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

	<!-- Nav-bar -->
	<?php include('grldocfrmtlb.frm'); ?>
	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
	<input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		    
		<div class="container-fluid" role="tabpanel">
		<!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hhrlabunicod; ?><input type="hidden" id="hhrlabunicod" name="hhrlabunicod" value="<?= $vew_data->hhrlabunicod; ?>"></strong></h4></li>
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
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('hhrlabunicodext', 'doccodext', $vew_data->hhrlabunicodext, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hhrlabunitxt', 'doccmt1x50', $vew_data->hhrlabunitxt, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
								</div>
							</div>
						</div>
					</div>
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
		</div> <!-- container-fluid -->
  </form>
 <?php include('grldocfrmscr.frm'); ?>
</section>
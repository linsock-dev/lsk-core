<?php
	/* url del formulario */
  $lv_lnk = "?prg=edustu&prm_stucod=".$vew_data->stucod;

	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = $vew_data->stucod;

	/* titulo */
	$lv_title = $vew_lang->student;
	
	/* m?dulo y programa */
	$lv_mdlcod = 'EDU';
	$lv_prgcod = 'STU';
	
	/* librer?a de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    
		<div class="row">
			<div class="col-md-6">
				<?php 
					echo vew_boot($lv_col210, array('label'=>$vew_lang->id, 'input'=>gethtml('stucod', 'doccod', $vew_data->stucod,$lv_always_disabled) )); 
					echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('stucodext', 'doccod', $vew_data->stucodext,$lv_always_disabled) )); 
					echo vew_boot($lv_col210, array('label'=>$vew_lang->name, 'input'=>gethtml('stutxt', 'doccmt1x50',$vew_data->stutxt,$lv_always_disabled) )); 
				?>
			</div>
			<div class="col-md-6">
				<?php include('grldatadrsml.frm'); ?>
				<?php include('grldatadrcntsml.frm'); ?>
			</div>
		</div>
  </form>
	<?php include('grldocfrmscr.frm'); ?>
</section>
<?php
	/* url del formulario */
  $lv_lnk = "?prg=hltprs&prm_prscod=".$vew_data->prscod;

	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = $vew_data->prscod; 

	/* titulo */
	$lv_title = $vew_lang->provider;
	
	/* m?dulo y programa */
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PRS';
	
	/* librer?a de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    
		<div class="row">
			<div class="col-md-6">
				<?php 
					echo vew_boot($lv_col210, array("label"=>$vew_lang->id,   "input"=>gethtml("prscod",   "doccod", 	$vew_data->prscod,$lv_always_disabled) )); 
					echo vew_boot($lv_col210, array("label"=>$vew_lang->code,	"input"=>gethtml("prscodext","doccod", 	$vew_data->prscodext,$lv_always_disabled) )); 
					echo vew_boot($lv_col210, array("label"=>$vew_lang->name,	"input"=>gethtml("prstxt",	"prstxt",$vew_data->prstxt,$lv_always_disabled) )); 
				?>
			</div>
			<div class="col-md-6">
				<?php include('grldatadrsml.frm'); ?>
				<?php include('grldatadrcntsml.frm'); ?>
			</div>
		</div>
  </form>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
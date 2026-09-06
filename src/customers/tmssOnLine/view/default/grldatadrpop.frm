<?php
	/* url del formulario */
  $lv_lnk = "?prg=grldatadr&prm_adrnum=".$vew_data->adrnum;

	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = $vew_data->adrnum; 

	/* titulo */
	$lv_title = $vew_lang->patient;
	
	/* modulo y programa */
	$lv_mdlcod = $vew_data->adrsrctyp;
	$lv_prgcod = $vew_data->adrsrccod;
	
	/* librer?a de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    
		<div class="row">
			<div class="col-md-6">
				<?php 
					echo vew_boot($lv_col210, array("label"=>$vew_lang->id,   "input"=>gethtml("adrsrccod",	"doccod", 			$vew_data->adr->adrsrccod,$lv_always_disabled) )); 
					echo vew_boot($lv_col210, array("label"=>$vew_lang->name,	"input"=>gethtml("adrnme001",	"doccmt1x100",	$vew_data->adr->adrnme001,$lv_always_disabled) )); 
				?>
			</div>
		</div>
		<div class="row">
			<div class="col-md-6">
				<?php include('grldatadr.frm'); ?>
			</div>
			<div class="col-md-6">
				<?php include('grldatadrcnt.frm'); ?>
			</div>
		</div>
  </form>
	<?php include('grldocfrmscr.frm'); ?>
</section>
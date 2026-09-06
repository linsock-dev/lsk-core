<?php
	// url del formulario
  $lv_lnk = '?prg=sysobj';

	// campos requeridos
	$vew_input->RequiredFields( array('systratxt','srcbuscod','srcobjtyp','srcobjcod001') );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->objects;

	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'OBJ';

	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>" >
	<form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
		<div class="container-fluid">
			<div class="row">
				<?= vew_boot($lv_colsm210, array('label'=>$vew_lang->title, 'input'=>gethtml('systratxt', 'doccmt1x50', $vew_data->systratxt, $lv_default) )); ?>
				<hr>
				<label><?= $vew_lang->source ?></label>
				<?php
          echo vew_boot($lv_colsm210, array('label'=>$vew_lang->developergroup, 'input'=>gethtml('sysdevgrpcod', $vew_data->devgrp, $vew_data->sysdevgrpcod??'', $lv_default)));
					echo vew_boot($lv_colsm210, array('label'=>$vew_lang->company, 'input'=>gethtml('srcbuscod', 'doccmt1x50',$vew_data->srcbuscod, $lv_default) ));
					echo vew_boot($lv_colsm210, array('label'=>$vew_lang->object, 'input'=>gethtml('srcobjtyp', 'doccmt1x50',$vew_data->srcobjtyp, $lv_default) ));
					echo vew_boot($lv_colsm210, array('label'=>$vew_lang->code.'1', 'input'=>gethtml('srcobjcod001', 'doccmt1x50',$vew_data->srcobjcod001, $lv_default) ));
					echo vew_boot($lv_colsm210, array('label'=>$vew_lang->code.'2', 'input'=>gethtml('srcobjcod002', 'doccmt1x50',$vew_data->srcobjcod002, $lv_default) ));
				?>
			</div>
		</div>
	</form>
	<script>
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	</script>
</section>

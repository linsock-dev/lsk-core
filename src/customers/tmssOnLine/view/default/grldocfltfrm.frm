<?php		
	/* url del formulario */
  $lv_lnk = "";

	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = '';

	/* titulo */
	$lv_title = $vew_lang->filter;
	
	/* módulo y programa */
	$lv_mdlcod = '';
	$lv_prgcod = '';

	$vew_actcod = '02';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('docsts','hidden','A'); ?>

		<div class="container-fluid">
			<?php
				echo vew_boot($lv_col210, array('label'=>$vew_lang->id, 	'input'=>gethtml('vewfltcod', 'doccod', $vew_data->vewfltcod, $lv_always_disabled) ));
				echo vew_boot($lv_col210, array('label'=>$vew_lang->name,	'input'=>gethtml('vewflttxt', 'doccmt1x50', $vew_data->vewflttxt, $lv_default) ));
			?>
			<div class="row">
				<label class="control-label col-sm-2">Publico</label>
				<div class="col-sm-4"><input type="checkbox" id="vewfltpub" name="vewfltpub" <?= ($vew_data->vefltpub==1?'checked="checked"':''); ?>></div>
				<label class="control-label col-sm-2">Por Defecto</label>
				<div class="col-sm-4"><input type="checkbox" id="vewfltdef" name="vewfltdef" <?= ($vew_data->vewfltdef==1?'checked="checked"':''); ?>></div>
			</div>

		</div> <!-- /container-fluid -->
	</form>
	<script>
		tmssLoadScript("toggle",function(){
			$("#<?= $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: "success", offstyle: "default", on: "Si", off: "No", size: "small" });
				$(this).trigger("change");
			});
		});
	</script>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";
		
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	</script>
</section>
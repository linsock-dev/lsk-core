<div id="<?= $lv_sec; ?>_tch" class="hidden">
	<form class="form-horizontal">
		<div class="form-group tmss-form-group">
			<label class="col-sm-2 control-label text-nowrap"><?= $vew_lang->code; ?></label>
			<div class="col-sm-10"><input type="TEXT" value="<?= $vew_defhdr['vewcod']; ?>" class="form-control tmssAlwaysDisabled" readonly="readonly"></div>
		</div>
		<div class="form-group tmss-form-group">
			<label class="col-sm-2 control-label text-nowrap"><?= $vew_lang->source; ?></label>
			<div class="col-sm-10"><textarea type="TEXTAREA" id="tchsrccod" rows="5" class="form-control tmssAlwaysDisabled" readonly="readonly"><?= $vew_defhdr['vewsrc']; ?></textarea></div>
		</div>
		<div class="form-group tmss-form-group">
			<label class="col-sm-2 control-label text-nowrap"><?= $vew_lang->system; ?></label>
			<div class="col-sm-10"><input type="TEXT" class="form-control tmssAlwaysDisabled" readonly="readonly" value="<?= $vew_defhdr['vewsrcsys']; ?>"></div>
		</div>
	</form>
	<script>
		$("#<?= $lv_sec; ?> #btntchinf").on("click", function(e) {
			<?php if ( strtoupper($vew_sec->usrcod)=='TEMASIS' || strtoupper($vew_sec->usrcod)=='CDOMINGUEZ' || strtoupper($vew_sec->usrcod)=='GRUSSO' || strtoupper(substr($vew_sec->buscod,0,7))=='TEMASIS' ) { ?>
			BootstrapDialog.show({
				title: "<?= $vew_lang->technicalinfo; ?>",
				message: $("#<?= $lv_sec; ?>_tch > form").clone(),
				size: BootstrapDialog.SIZE_WIDE,
				buttons: [{ label: "<?= $vew_lang->close; ?>", cssClass: "btn-primary", action: function(dialogItself){dialogItself.close();} }]
			});
			<?php } else { ?>
				toastr.warning("Operación solo disponible para sistemas.");
			<?php } ?>
		});
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>_tch", false );
	</script>
</div>
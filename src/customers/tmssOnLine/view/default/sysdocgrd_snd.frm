<div class="modal fade" id="<?= $vew_token; ?>_snd" tabindex="-1" role="dialog" aria-hidden="true" style="z-index:9000">
	<form>
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#<?= $vew_token; ?>_snd').modal('hide');" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<h4 class="modal-title"><?= $vew_lang->send; ?></h4>
				</div>
				<div class="modal-body tmssFilterMaxHeight">
					<div class="form-group">
						<label class="control-label"><?= $vew_lang->to; ?></label>
						<input type="email" class="form-control" value="" placeholder="e-mail" required>
						<strong>Nota: </strong>Separe múltiples direcciones de email con coma (,).
					</div>
					<div class="form-group">
						<label class="control-label"><?= $vew_lang->comments; ?></label>
						<textarea class="form-control"></textarea>
					</div>
				</div>
				<div class="modal-footer">
					<button class="btn btn-primary" id="vewfltregset">Enviar</button>
					<button class="btn btn-default" id="vewsndcnc">Cancelar</button>
				</div>
			</div>
		</div>
	</form>
</div><!-- modal -->

<script>
	// cancel
	$("#<?= $lv_sec; ?> #vewsndcnc").on("click",function(e){
		$("#<?= $vew_token; ?>_snd").modal("hide");
	});
</script>
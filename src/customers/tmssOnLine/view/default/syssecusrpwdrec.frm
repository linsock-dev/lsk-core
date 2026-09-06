<?php
	/* id de sección */
	$lv_sec = $vew_token;
?>
<section id="<?= $lv_sec; ?>">
	<div class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<form method="POST" action="?prg=syssecusrpwd&act=12">
				<input type="hidden" id="sysenv" name="sysenv" value="<?= $vew_sysenv; ?>">
				<input type="hidden" id="bseurl" name="bseurl" value="<?= $vew_bseurl; ?>">
				<input type="hidden" id="bsecnx" name="bsecnx" value="<?= $vew_bsecnx; ?>">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					<h4 class="modal-title">Cambiar contrase&ntilde;a</h4>
				</div>
				<div class="modal-body">
						<p>Por favor, ingrese la cuenta de correo electr&oacute;nico asociada al usuario.<br>
						Un email ser&aacute; enviado a la casilla de correo para continuar con los pasos de recuperaci&oacute;n de contrase&ntilde;a.</p>
						<div class="form-group">
							<label for="usreml" class="control-label">E-mail:</label>
							<input type="email" id="usreml" name="usreml" class="form-control" required>
						</div>
				</div>
				<div class="modal-footer">
					<button type="submit" class="btn btn-primary">Enviar</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
				</div>
				</form>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->

	<script>
		$('#<?= $lv_sec; ?> .modal')
							.modal({backdrop: 'static', keyboard: false})
							.on('hidden.bs.modal', function(){
									document.location.href=$('#bseurl').prop('value');
								});
		$('#<?= $lv_sec; ?> #usreml').focus();
	</script>
</section>
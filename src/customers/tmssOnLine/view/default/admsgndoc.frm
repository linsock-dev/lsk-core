<?php
	// url del formulario 
  $lv_lnk = "?prg=admsgn&prm_sgncod=".$vew_data->sgncod;

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = $vew_data->sgncod;

	// módulo y programa 
	$lv_mdlcod = 'ADM';
	$lv_prgcod = 'SGN';

	// librería de estilos bootstrap 
	include_once('_library.frm');

	$lv_flelstarr = json_decode(html_entity_decode($vew_data->flelst),true);
?>
<section id="<?= $lv_sec; ?>">
	<div class="container-fluid">
		<input type="hidden" id="sgncod" value="<?= $vew_data->sgncod ?>">
		<input type="hidden" id="sgnpwd" value="">

		<?php if($vew_data->sgncod==''){ ?>

			<!--mensaje sin firma-->
			<div class="row" id="<?php $lv_sec; ?>_msgFirma">
				<div class="col-xs-1 col-md-3"></div>
					<div class="col-xs-10 col-md-6">
						<h3>Sin firma</h3>
						<blockquote>
							<p>No tiene firma cargada o vigente.</p>
						</blockquote>
					</div>
				<div class="col-xs-1 col-md-3"></div>
			</div>
			<!--fin mensaje sin firma-->

		<?php } else { ?>

			<!-- firma de documentos -->
			<div class="row">
				<div class="col-md-4">
					<input type="hidden" id="sgnpwd" value="">
					<h4 class="text-nowrap"><?= $vew_sec->usrtxt; ?></h4>
					<label class="control-label text-nowrap"><?= $vew_data->sgnini; ?></label><br>
					<?php include('grldatuplshwpth.frm'); ?><br>
				</div>
				<div class="col-md-8 text-center">
				
					<?php if(count($lv_flelstarr)==0){ ?>
						
						<h3>Sin documentos</h3>
						<blockquote>
							<p>No se encontraron documentos pendientes de firmar.</p>
						</blockquote>
						<script>
							$.each(BootstrapDialog.dialogs, function(id, dialog){
								if(dialog.$modalBody.find("section").prop("id")=="<?= $lv_sec; ?>"){
									dialog.$modalFooter.find("#btnsgn").addClass("hidden");
								}
							});
						</script>
					<?php } else { ?>

						<p>Seleccione los documentos que desea firmar:</p>
						<table class="table table-bordered">
							<thead><tr class="bg-primary"><th class="text-center" style="width: 30px;"><input type="checkbox"></th><th>Documentos</th><th style="width:30px;"></th></tr></thead>
							<tbody>
								<?php
									foreach($lv_flelstarr as $lv_row) {
										echo '<tr data-sgndocsrctyp="'.$lv_row['sgndocsrctyp'].'" data-sgndocsrccod001="'.$lv_row['sgndocsrccod001'].'" data-sgndocsrccod002="'.$lv_row['sgndocsrccod002'].'" data-fleurl="'.$lv_row['fleurl'].'" data-flepst="'.$lv_row['flepst'].'" data-flenme="'.$lv_row['flenme'].'">'.
														'<td class="text-center"><input type="checkbox"></td>'.
														'<td class="text-left">'.$lv_row['flenme'].'</td>'.
														'<td><i class="fas"></i></td>'.
													'</tr>';
									}
								?>
							</tbody>
						</table>
						
					<?php } ?>
					<br>
				</div>
			</div>
			<!-- firma de documentos - fin -->
		<?php } ?>
	</div>
	<script>
		$("#<?= $lv_sec; ?> table thead input[type=checkbox]").on("change",function(){
			$("#<?= $lv_sec; ?> table tbody input[type=checkbox]").prop("checked", $(this).is(":checked")).trigger("change");
		});
		$("#<?= $lv_sec; ?> table tbody input[type=checkbox]").on("change",function(){
			if($(this).is(":checked") && !($(this).hasClass("hidden"))){
				$(this).parent().parent().addClass("bg-warning");
			} else {
				$(this).parent().parent().removeClass("bg-warning");
			}
		});
	</script>
</section>
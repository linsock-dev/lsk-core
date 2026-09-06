<?php
	// campos requeridos 
	$vew_input->RequiredFields( array('sysdocclscod') );

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>">
	<form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
		<input type="submit" class="hidden">
		<input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<input type="hidden" id="srcobjtyp" name="srcobjtyp" value="<?= $vew_data['srcobjtyp']; ?>">
		<input type="hidden" id="srcobjcod" name="srcobjcod" value="<?= $vew_data['srcobjcod']; ?>">
		
		<div class="container-fluid">
			<div id="norecords" style="display: none;" class="container-fluid">
				<h3><i class="fas fa-exclamation-triangle"></i>&nbsp;&nbsp;No se encontraron resultados.</h3>
			</div>
			<div class="row">
				<div class="form-group tmss-form-group">
					<label class="control-label col-sm-2"><?= $vew_lang->destination; ?></label>
					<div class="col-sm-10">
						<select id="sysdocclscod" name="sysdocclscod" class="form-control">
							<option></option>
							<?php 
								foreach($vew_doccls as $lv_row) {
									echo '<option data-objtyp="'.$lv_row['objtyp'].'" value="'.$lv_row['sysdocclscod'].'">'.$lv_row['sysdocclstxt'].'</option>';
								}
							?>
						</select>
					</div>
				</div>
			</div><br>
			<table id="doctbl" class="table table-condensed">
				<thead>
					<tr>
						<th><input type='checkbox' id='hdrchk'></th>
						<th>ID</th>
						<th>Codigo</th>
						<th>Descripcion</th>
						<th>Cantidad</th>
						<th style='text-align: center;'>Cant.Ref</th>
						<th></th>
					</tr>
				</thead>
				<tbody id="doctblbdy">
					<?php foreach($vew_docpos as $lv_row) { ?>
						<tr style="min-height: 36px;">
						<td style="vertical-align: middle;"><?php if($lv_row['matqty']>0){ ?><input type='checkbox' id='rowchk' data-doccod="<?= $lv_row['doccod']; ?>" data-docposcod="<?= $lv_row['docposcod']; ?>"><?php } ?></td>
						<td style="vertical-align: middle;"><?= $lv_row['docposcod']; ?></td>
						<td style="vertical-align: middle;"><?= $lv_row['matcod']; ?></td>
						<td style="vertical-align: middle;"><?= $lv_row['mattxt']; ?></td>
						<td style="vertical-align: middle; text-align: right;"><?= number_format($lv_row['matqty'], 2).' '.$lv_row['matuntcod']; ?></td>
						<td align="right"><input id="<?= $lv_row['doccod'].'_'.$lv_row['docposcod'].'_qty'; ?>" class="form-control" type="number" min="0" max="<?= number_format($lv_row['matqty'], 2, '.', ''); ?>" step="any" value="<?= number_format($lv_row['matqty'], 2, '.', ''); ?>"></td>
						<td><?= 'Lot: '.$lv_row['matbchcodext'].' / Ser: '.$lv_row['matsercodext']; ?></td>
						</tr>
					<?php } ?>
				</tbody>
			</table>
		</div> <!-- /container-fluid -->
	</form>
  <script>
		$("#<?= $lv_sec; ?> #hdrchk").on("click",function(e){
			var lv_chk = $(this).prop("checked");
			$("#<?= $lv_sec; ?> #rowchk").each(function(e){
				$(this).prop("checked",lv_chk).trigger("change");
			});
		});
		$("#<?= $lv_sec; ?> #rowchk").on("change",function(e){
			if ( $(this).is(":checked") ) {
				$(this).parent().parent().addClass("bg-info");
			} else {
				$(this).parent().parent().removeClass("bg-info");
			}
		});
  </script>
</section>
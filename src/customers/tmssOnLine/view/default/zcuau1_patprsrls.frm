<?php
	// url del formulario 
  $lv_lnk = "";

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->information;
	
	// módulo y programa 
	$lv_mdlcod = '';
	$lv_prgcod = '';

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<div class="container-fluid">
	<div class="row">
		<table class="table table-condensed table-striped table-bordered table-hover" id="patlst" >
			<thead>
				<tr><th><?= $vew_lang->id; ?></th><th><?= $vew_lang->patient; ?></th><th>Ult.Act.</th></tr>
			</thead>
			<tbody>
				<?php
					foreach($vew_data as $lv_row) {
						echo '<tr data-patcod="'.$lv_row['patcod'].'" data-prscod="'.$lv_row['prscod'].'" data-spccod="'.$lv_row['spccod'].'">'.
									'<td>'.$lv_row['patcod'].'</td>'.
									'<td>'.$lv_row['pattxt'].'</td>'.
									'<td style="white-space: nowrap;">'.date_format($lv_row['maxupddte'],'d-m-Y').'</td>'.
									'</tr>';
					}
				?>
			</tbody>
		</table>
	</div>
	</div>
</section>
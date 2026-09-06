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
		<div style="overflow-y: scroll;">
		<table class="table table-condensed table-striped table-bordered table-hover" id="patlst" >
			<thead>
				<tr>
					<th>Fecha</th>
					<th>¿Ha presentado complicaciones hepáticas?</th>
					<th>¿Desarrollo de Ascitis?</th>
					<th>¿Desarrollo de PBE?</th>
					<th>¿Desarrollo de Encefalopatía?</th>
					<th>¿Sangrado variceal?</th>
					<th>¿Trasplante hepático?</th>
					<th>¿Salió de lista de trasplante hepático?</th>
					<th>¿Hepatocarcinoma?</th>
					<th>Hepatocarcinoma - Fecha</th>					
					<th>¿Complicaciones extrahepáticas?</th>
					<th>Comp.Extrahep. - Diabetes</th>
					<th>Comp.Extrahep. - Enfermedad coronaria</th>
					<th>Comp.Extrahep. - Enfermedad cerebrovascular</th>
					<th>¿Muerte?</th>
					<th>Muerte - Fecha</th>
				</tr>
			</thead>
			<tbody>
				<?php
					foreach($vew_data as $lv_row) {
						echo '<tr>'.
									'<td style="white-space: nowrap;">'.date_format($lv_row['frmevlcomdte'],'d-m-Y').'</td>'.
									'<td>'.$lv_row['frmevlcom'].'</td>'.
									'<td>'.$lv_row['frmevlcomasc'].'</td>'.
									'<td>'.$lv_row['frmevlcompbe'].'</td>'.
									'<td>'.$lv_row['frmevlcomenc'].'</td>'.
									'<td>'.$lv_row['frmevlcomsan'].'</td>'.
									'<td>'.$lv_row['frmevlcomtra'].'</td>'.
									'<td>'.$lv_row['frmevlcomtradte'].'</td>'.
									'<td>'.$lv_row['frmevlcomlstout'].'</td>'.
									'<td>'.$lv_row['frmevlcomhpt'].'</td>'.
									'<td>'.$lv_row['frmevlcomhptdte'].'</td>'.
									'<td>'.$lv_row['frmevlcomcex'].'</td>'.
									'<td>'.$lv_row['frmevlcomcexdia'].'</td>'.
									'<td>'.$lv_row['frmevlcomcexcor'].'</td>'.
									'<td>'.$lv_row['frmevlcomcexcer'].'</td>'.
									'<td>'.$lv_row['frmevlcommue'].'</td>'.
									'<td style="white-space: nowrap;">'.date_format($lv_row['frmevlcommuedte'],'d-m-Y').'</td>'.
									'</tr>';
					}
				?>
			</tbody>
		</table>
		</div>
	</div>
	</div>
</section>
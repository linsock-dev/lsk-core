<?php
	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

	// create new PDF document
	$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'ISO-8859-1', false);

	// remove default header/footer
	$pdf->setPrintHeader(false);
	$pdf->setPrintFooter(false);

	// set default monospaced font
	$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

	// set margins
	$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
 
	// set auto page breaks
	$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);  

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
	

	// ---------------------------------------------------------
	$pdf->AddPage('');
	
	// Encabezado
	$pdf->setfont('Courier', 'B', 18);
	$pdf->text( 60, 10, 'Registro de elaboración');
	$pdf->setfont('Courier', '', 10);
	$pdf->text( 20, 20, 'NRO. '.$vew_data->stkmovelbcod);																					// id
	$pdf->text( 20, 25, 'FECHA: '.date_format($vew_data->stkmovelbdte, 'd-m-Y'));									// fecha
	$pdf->text( 20, 30, 'MATERIAL ELABORADO: ('.$vew_data->matcod . ')'.$vew_data->mattxt);				// MATERIAL
	$pdf->text( 20, 35, 'DEPOSITO: ('.$vew_data->srcobjcod . ')'.$vew_data->srcobjtxt);						// DEPOSITO
	$pdf->text( 20, 40, 'CANTIDAD: '.$vew_data->matqty);																					// CANTIDAD
	if($vew_data->docsts=='C'){ 
    $pdf->text( 20, 45, 'LOTE : '.$vew_data->matbchcodext);																			// Lote
    $pdf->text( 20, 50, 'VENCIMIENTO: '.date_format($vew_data->matbchduedte, 'd-m-Y'));					// Vencimiento
  }

	// Posiciones
	$pdf->setfont('Courier', '', 10);
	$lv_buffer = '<table cellpadding="4" cellspacing="0" border="1">'.
								'<tr style="background-color: #f1f1f1; font-weight: bold;">'.
									'<td width="25">#</td>'.
									'<td width="60">Cod</td>'.
									'<td width="250">Descripcion</td>'.
									'<td width="60" align="right">Cant</td>'.
									'<td width="90">Lote</td>'.
									'<td width="100">Vencimiento</td>'.
									'<td width="100">Serie</td>'.
									'</tr>';
	$i=0;
	foreach($vew_data->stkmovelbmat as $lv_row) {

		// if($lv_row['sysdocrejcod']=='0' || $lv_row['sysdocrejcod']==null) {
			$i++;
			$lv_buffer .= '<tr>'.
										'<td style="background-color: #f1f1f1;">'.$i.'</td>'.
										'<td>'.$lv_row['matcod'].'</td>'.
										'<td>'.utf8_encode($lv_row['mattxt']).'</td>'.
										'<td align="right">'.number_format($lv_row['matqty'],2).'</td>'.
										'<td>'.($lv_row['matbchcod']==0?'':$lv_row['matbchcodext']).'</td>'.
										'<td>'.($lv_row['matbchcod']==0?'':$lv_row['matbchduedtecnv']).'</td>'.
										'<td>'.($lv_row['matsercod']==0?'':$lv_row['matsercodext']).'</td>'.
										'</tr>';
		// }
	}	

	$lv_buffer .= '</table>';	
	$pdf->setxy( 11, $pdf->getY()+6);
	$pdf->writeHTML($lv_buffer);
	
	$pdf->setfont('Courier', '', 12);
	$pdf->text( 20, $pdf->getY()+6, 'Comentarios: '.$vew_data->stkmovelbcmt);					// Comentarios

	$pdf->setfont('Courier', '', 12);
	$pdf->text( 20, $pdf->getY()+12, 'Elaborado por: '.$vew_data->cteusr);					// Comentarios
	if($vew_data->docsts=='C'){ 
    $pdf->setfont('Courier', '', 12);
    $pdf->text( 20, $pdf->getY()+6, 'Controlado por: '.$vew_data->updusr);					// Comentarios
  }

	$pdf->Output('Elaboracion_'.$vew_data->stkmovelbcod.'.pdf', 'I');	
?>
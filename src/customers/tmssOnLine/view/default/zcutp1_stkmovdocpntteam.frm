<?php
	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

	// create new PDF document
	$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);

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
	$pdf->AddPage('P');
	
	// Encabezado
	$pdf->setfont('Courier', 'B', 12);
	$pdf->text( 150, 33, date_format($vew_data->stkmovdocdte, 'd    m     Y'));	// fecha
	$pdf->text( 40, 59,  $vew_data->dstcnttxt);																	// nombre
	$pdf->text( 40, 69,  $vew_data->dstcnt->adr->adrstr.' '.$vew_data->dstcnt->adr->adrstrnum);						// domicilio
	$pdf->text( 40, 79,  $vew_data->dstcnt->adr->lndregtxt);				// localidad
	
	// Posiciones
	$pdf->setfont('Courier', '', 10);
	$lv_buffer = '<table border=0 cellpadding=0 cellspacing=0>';
	foreach($vew_data->stkmovdocmat as $lv_row) {
		if($lv_row['sysdocrejcod']=='0' || $lv_row['sysdocrejcod']==null) {
			$lv_buffer .= '<tr>'.
										'<td align="right" width="95">'.number_format($lv_row['matqty'],0).'</td>'.
										'<td width="40"></td>'.
										'<td width="400">'.utf8_encode($lv_row['mattxt']).'</td>'.
										'</tr>';
			if ( $lv_row['matbchcodext']!='' ) {
				$lv_buffer .= '<tr style="font-size: 9px;"><td colspan="2"></td><td>Lote: '.$lv_row['matbchcodext'].' - Vto: '.date_format($lv_row['matbchduedte'],'d/m/Y').'</td></tr>';
			}
			if ( $lv_row['matsercod']!='' ) {
				$lv_buffer .= '<tr style="font-size: 9px;"><td colspan="2"></td><td>Serie: '.$lv_row['matsercodext'].'</td></tr>';			
			}
		}
	}	
	$lv_buffer .= '</table>';
	$pdf->setxy( 11, 116);
	$pdf->writeHTML($lv_buffer);
	// ---------------------------------------------------------

	$pdf->Output('remito.pdf', 'I');	
?>
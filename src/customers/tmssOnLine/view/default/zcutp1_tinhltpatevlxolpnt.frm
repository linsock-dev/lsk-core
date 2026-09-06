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
	$pdf->AddPage('P');
	$pdf->setfont('Courier', '', 11);

	// Encabezado
	$pdf->Image('/library/images/logos/zcutp1_logoTeamInfusionAR.jpg', 30, 13, 30, 30, '', '', 'T', false, 300, '', false, false, 0, false, false, false);
	$pdf->text( 147, 30,'Evolución Nro. '.$vew_data->evlcod);
	$pdf->text( 147, 40,'Fecha: '.date_format($vew_data->evldte, 'd/m/Y'));
	$pdf->text( 30, 60,'Paciente:      ('. $vew_data->patcod.')'. $vew_data->pattxt );
	$pdf->text( 30, 65,'Prestador:     ('. $vew_data->prscod.')'. $vew_data->prstxt );
	$pdf->text( 30, 70,'Especialidad:  ('. $vew_data->spccod.')'. $vew_data->spctxt );
	$pdf->text( 30, 75,'Lugar:         ('. $vew_data->delcod.')'. $vew_data->deltxt );
	
	// EVOLUCION
	$pdf->setfont('Courier', 'B', 13);
	$pdf->text( 30, 85,'EVOLUCION');
	$pdf->setfont('Courier', '', 11);
	$lv_tbl = '<table  border="0" cellpadding="1" cellspacing="5"><tbody>'.
							'<tr><td width="100" align="right"><b>Realizado?</b></td><td width="400">'.($vew_doc->getTagValue($vew_data->evlatr001,'rea')=='1'?'SI':'NO').'</td></tr>'.
							'<tr><td width="100" align="right"><b>Profesional</b></td><td width="400">'.$vew_doc->getTagValue($vew_data->evlatr001,'prf').'</td></tr>'.
							'<tr><td width="100" align="right"><b>Dosis</b></td><td width="400">'.$vew_doc->getTagValue($vew_data->evlatr001,'meddss').'</td></tr>'.
							'<tr><td width="100" align="right"><b>Lote</b></td><td width="400">'.$vew_doc->getTagValue($vew_data->evlatr001,'medbch').'</td></tr>'.
							'</tbody></table>';
	$pdf->setxy( 30, 95);
	$pdf->writeHTML($lv_tbl);
	
	$pdf->setfont('Courier', 'B', 13);
	$pdf->text( 30, 150,'Comentarios');
	$pdf->setfont('Courier', '', 11);
	$pdf->setxy( 30, 155);
	$pdf->MultiCell(170, 40, $vew_data->evlevl, 0, 'L', 0, 0, '' ,'', true);

	$pdf->Output('evolucion.pdf', 'I');	
?>
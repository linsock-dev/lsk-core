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
	$lv_totdeb = 0;
	$lv_totcre = 0;

	$pdf->AddPage('P');
	$pdf->setfont('Courier', '', 11);
	
	// styles
	$line_style = array('width' => 0.2, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0));

	// Encabezado
	$pdf->Image('/library/images/logos/zcutp1_logoTeamInfusionAR.jpg', 30, 13, 30, 30, '', '', 'T', false, 300, '', false, false, 0, false, false, false);
	$pdf->text( 147, 40,'Fecha: '.date_format($vew_data->evldte, 'd/m/Y'));
	$pdf->text( 30, 60,'Paciente:      ('. $vew_data->patcod.')'. $vew_data->pattxt );
	$pdf->text( 30, 65,'Prestador:     ('. $vew_data->prstxt );
	$pdf->text( 30, 70,'Especialidad:  ('. $vew_data->spccod.')'. $vew_data->spctxt );
	$pdf->Line(30, 80, 180, 80, $line_style);
	$pdf->text( 30, 85,'Medicación:    '.  strtoupper(utf8_decode($vew_doc->getTagValue($vew_data->evlatr001,'evlmd1'))));
	$pdf->text( 30, 90,'Patología:     '.  strtoupper(utf8_decode($vew_doc->getTagValue($vew_data->evlatr001,'evlpa1'))));
	
	$pdf->setfont('Courier', 'B', 13);
	$pdf->text( 30, 105,'Evolucion');
	$pdf->setfont('Courier', '', 11);
	//$pdf->text( 30, 225,$vew_data->evlevl);
	$pdf->setxy( 30, 110);
	$pdf->MultiCell(170, 40, $vew_data->evlevl, 0, 'L', 0, 0, '' ,'', true);

	$pdf->Output('example_002.pdf', 'I');	
?>
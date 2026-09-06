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
	$lv_totdeb = 0;
	$lv_totcre = 0;
    
	$pdf->AddPage('P');
	$pdf->setfont('Courier', '', 11);
	// styles
	$head_line_style =  array('width' => 0.5, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0));
	
	// Encabezado
	$pdf->Image('/library/images/logos/zcutp1_logoTeamInfusionAR.jpg', 30, 13, 30, 30, '', '', 'T', false, 300, '', false, false, 0, false, false, false);
	$pdf->text( 147, 40,'Fecha: '.date_format($vew_data->evldte, 'd/m/Y'));
	$pdf->text( 30, 60,'Paciente:      ('. $vew_data->patcod.')'. $vew_data->pattxt );
	$pdf->text( 30, 65,'Prestador:     '. $vew_data->prstxt );
	$pdf->text( 30, 70,'Especialidad:  ('. $vew_data->spccod.')'. $vew_data->spctxt );

	$lv_buf = $vew_doc->getTagValue($vew_data->evlatr001,'row');
	$vew_data->evlmthprc=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlmthprc')));
 	$vew_data->evlmtt=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlmtt')));
 	$vew_data->evlhhs=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlhhs')));
 	$vew_data->evltg1=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg1')));
	$vew_data->evltg2=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg2')));
  $vew_data->evltg3=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg3')));
	$vew_data->evltg4=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg4')));
	$vew_data->evltg5=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg5')));
	$vew_data->evltg6=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg6')));
	$vew_data->evltg7=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg7')));
	$vew_data->evltg8=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg8')));
	$vew_data->evltg9=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg9')));
	 $pdf->Line( 30, 78, 190, 78, $head_line_style);
	 $pdf->text( 30, 80,'¿Se comunico?: '.($vew_data->evlmthprc=='1'?'SI':'NO')); 
	 $pdf->text( 30, 85,'Horario: '.$vew_data->evlhhs); 

	 $pdf->text( 30, 92,'Signos y Sintomas de RA');
	$pdf->setfont('Courier', '', 11);
	$lv_tbl = '<table  border="0" cellpadding="1" cellspacing="1">';
	$lv_tbl .= '<tr>'.
							'<td style="width:50%" align="rigth">Locales:</td>'.
							'<td style="width:50%"><strong>'.($vew_data->evltg1=='ON'?'SI':'NO').'</strong></td>'.
						'</tr>';

	$lv_tbl .= '<tr>'.
							'<td style="width:50%" align="rigth">Fiebre / escalofríos</td>'.
							'<td style="width:50%"><strong>'.($vew_data->evltg2=='ON'?'SI':'NO').'</strong></td>'.
						'</tr>';
	$lv_tbl .= '<tr>'.
							'<td style="width:50%" align="rigth">Sensación de debilidad, decaimiento (hipotensión) :</td>'.
							'<td style="width:50%"><strong>'.($vew_data->evltg3=='ON'?'SI':'NO').'</strong></td>'.
						'</tr>';
	$lv_tbl .= '<tr>'.
							'<td style="width:50%" align="rigth">Mareos :</td>'.
							'<td style="width:50%"><strong>'.($vew_data->evltg4=='ON'?'SI':'NO').'</strong></td>'.
						'</tr>';
	$lv_tbl .= '<tr>'.
							'<td style="width:50%" align="rigth">Cefalea :</td>'.
							'<td style="width:50%"><strong>'.($vew_data->evltg5=='ON'?'SI':'NO').'</strong></td>'.
						'</tr>';
	$lv_tbl .= '<tr>'.
							'<td style="width:50%" align="rigth">Nauseas o vómitos :</td>'.
							'<td style="width:50%"><strong>'.($vew_data->evltg6=='ON'?'SI':'NO').'</strong></td>'.
						'</tr>';
	$lv_tbl .= '<tr>'.
							'<td style="width:50%" align="rigth">Tos :</td>'.
							'<td style="width:50%"><strong>'.($vew_data->evltg7=='ON'?'SI':'NO').'</strong></td>'.
						'</tr>';
	$lv_tbl .= '<tr>'.
							'<td style="width:50%" align="rigth">Dificultad para respirar :</td>'.
							'<td style="width:50%"><strong>'.($vew_data->evltg8=='ON'?'SI':'NO').'</strong></td>'.
						'</tr>';
	$lv_tbl .= '<tr>'.
							'<td style="width:50%" align="rigth">Palpitaciones :</td>'.
							'<td style="width:50%"><strong>'.($vew_data->evltg9=='ON'?'SI':'NO').'</strong></td>'.
						'</tr>';
	
	$lv_tbl .= '</table>';
	$pdf->setxy( 30, 100);
	$pdf->writeHTML($lv_tbl);





	


	
	$pdf->setfont('Courier', 'B', 13);
	$pdf->text( 30, 160,'Evolucion');
	$pdf->setfont('Courier', '', 11);
	//$pdf->text( 30, 225,$vew_data->evlevl);
	$pdf->setxy( 30, 165);
	$pdf->MultiCell(170, 40, $vew_data->evlevl, 0, 'L', 0, 0, '' ,'', true);

	$pdf->Output('example_002.pdf', 'I');
?>
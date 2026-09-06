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
	//Enunciado signos
	$pdf->setfont('Courier', 'B', 13);
	 $pdf->Line( 30, 78, 190, 78, $head_line_style);	
	$pdf->text( 30, 80,'SIGNOS VITALES');
	$pdf->setfont('Courier', '', 11);
	//Cabecera Datos Signos
	$lv_tbl = '<table  border="0" cellpadding="1" cellspacing="1">'.
							'<tr>'.
								'<td width="80" align="center"><b>Peso</b></td>'.
								'<td width="80" align="center"><b>Temp.</b></td>'.
								'<td width="100" align="center"><b>Frec.Card</b></td>'.
								'<td width="100" align="center"><b>Frec.Resp.</b></td>'.
								'<td width="110" align="center"><b>Tension Art.</b></td>'.
							'</tr>';
	//Datos Signos
	
	foreach($vew_data->evlspc as $lv_row) {
		$lv_tbl .= '<tr>'.
								'<td align="center">'.$this->co_reg->document->getTagValue($lv_row['evlatrval001'],'P').'</td>'.
								'<td align="center">'.$this->co_reg->document->getTagValue($lv_row['evlatrval001'],'T').'</td>'.
								'<td align="center">'.$this->co_reg->document->getTagValue($lv_row['evlatrval001'],'FC').'</td>'.
								'<td align="center">'.$this->co_reg->document->getTagValue($lv_row['evlatrval001'],'FR').'</td>'.
								'<td align="center">'.$this->co_reg->document->getTagValue($lv_row['evlatrval001'],'TA').'</td>'.
							'</tr>';
	}
	
	
	$lv_tbl .= '</table>';
	$pdf->setxy( 30, 85);
	$pdf->writeHTML($lv_tbl);
	//Enunciado infusion
	$pdf->setfont('Courier', 'B', 13);
	$pdf->text( 30, 135,'APLICACION');
	$pdf->setfont('Courier', '', 11);
	//Cabecera infusion
	$lv_tbl = '<table  border="0" cellpadding="1" cellspacing="1">'.
						'<tr>'.
							'<td width="100" align="center"><b>Producto</b></td>'.
							'<td width="70" align="center"><b>Hora.</b></td>'.
							'<td width="70" align="center"><b>Viales</b></td>'.
							'<td width="80" align="center"><b>Lote</b></td>'.
							'<td width="100" align="center"><b>Vto.</b></td>'.
							'<td width="120" align="center"><b>Reacc. Advers.</b></td>'.
						'</tr>';

//Datos infusion

	foreach($vew_data->evlmat as $lv_row) {
		$lv_tbl .= '<tr>'.
								'<td align="center">'.$lv_row['mattxt'].'</td>'.
								'<td align="center">'.$this->co_reg->document->getTagValue($lv_row['matatrval001'],'STRTME').'</td>'.
								'<td align="center">'.$lv_row['matqty'].'</td>'.
								'<td align="center">'.$lv_row['matbchcodext'].'</td>'.
								'<td align="center">'.date_format($lv_row['matbchduedte'], 'd/m/Y').'</td>'.
								'<td align="center">'.$this->co_reg->document->getTagValue($lv_row['matatrval001'],'ADVREA').'</td>'.
							'</tr>';	

							
	} 

	$lv_tbl .= '</table>';
	$pdf->setxy( 30, 140);
	$pdf->writeHTML($lv_tbl);
	
	$pdf->setfont('Courier', 'B', 13);
	$pdf->text( 30, 200,'Evolucion');
	$pdf->setfont('Courier', '', 11);
	//$pdf->text( 30, 225,$vew_data->evlevl);
	$pdf->setxy( 30, 205);
	$pdf->MultiCell(170, 40, $vew_data->evlevl, 0, 'L', 0, 0, '' ,'', true);

	$pdf->Output('example_002.pdf', 'I');	
?>
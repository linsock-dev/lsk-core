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
	$pdf->AddPage('L');
	
	// Encabezado
	$pdf->setfont('Courier', 'B', 18);
	$pdf->text( 220, 10, 'HOJA DE PICKING');
	$pdf->text( 240, 20, $vew_data->stkmovdoccod);		// id
	$pdf->setfont('Courier', 'B', 12);
	$pdf->text( 20, 10, date_format($vew_data->stkmovdocdte, 'd-m-Y'));	// fecha
	$pdf->text( 20, 15, $vew_data->dstobjtxt);				// nombre
	$pdf->text( 20, 20, $vew_data->dstcnttxt);				// contacto
	$pdf->text( 20, 25, $vew_data->dstobjadrstr);			// domicilio
	$pdf->text( 20, 30, $vew_data->dstobjadrcty);			// localidad

	// Posiciones
	$pdf->setfont('Courier', '', 10);
	$lv_buffer = '<table cellpadding="4" cellspacing="0" border="1">'.
								'<tr style="background-color: #f1f1f1; font-weight: bold;">'.
									'<td width="25">#</td>'.
									'<td width="45">ID</td>'.
    							'<td width="60">Codigo</td>'.
									'<td width="300">Descripcion</td>'.
									'<td width="60" align="right">Cantidad</td>'.
    							'<td width="60" align="right">Unidad</td>'.
									'<td width="90">Lote</td>'.
									'<td width="100">Vencimiento</td>'.
									'<td width="100">Serie</td>'.
									'<td width="170">Comentarios</td>'.
									'</tr>';
	$i=0;
	foreach($vew_data->stkmovdocmat as $lv_row) {
		$lv_cmt ='';

    
			$i++;
			$lv_buffer .= '<tr>'.
										'<td style="background-color: #f1f1f1;">'.$i.'</td>'.
										'<td>'.$lv_row['matcod'].'</td>'.
        						'<td>'.$lv_row['matcodext'].'</td>'.
										'<td>'.utf8_encode($lv_row['mattxt']).'</td>'.
										'<td align="right">'.number_format($lv_row['matqty'],2).'</td>'.
        						'<td align="left">'.$lv_row['matuntcod'].'</td>'.
										'<td>'.($lv_row['matbchcod']==0?'':$lv_row['matbchcodext']).'</td>'.
										'<td>'.($lv_row['matbchcod']==0?'':$lv_row['matbchduedtecnv']).'</td>'.
										'<td>'.($lv_row['matsercod']==0?'':$lv_row['matsercodext']).'</td>'.
										'<td>'.$lv_cmt.'</td>'.
										'</tr>';
	}	
	$lv_buffer .= '</table>';	
	$pdf->setxy( 7, $pdf->getY()+6);
	$pdf->writeHTML($lv_buffer);
	
	$pdf->setfont('Courier', '', 12);
	$pdf->text( 20, $pdf->getY()+6, 'Comentarios: '.$vew_data->stkmovdoccmt);					// Comentarios

	$pdf->Output('remito.pdf', 'I');	
?>
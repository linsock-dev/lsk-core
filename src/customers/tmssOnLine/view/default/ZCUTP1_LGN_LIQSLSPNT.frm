<?php
	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

	// create new PDF document
	$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, false, 'ISO-8859-1', false);

	// remove default header/footer
	$pdf->setPrintHeader(false);
	$pdf->setPrintFooter(false);

	// set default monospaced font
	$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

	// set margins
	$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);

	// set auto page breaks
	$pdf->SetAutoPageBreak(TRUE, 1);

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

	// ---------------------------------------------------------
	for($i = 0; $i < $vew_msgqty; $i++){
		$pdf->AddPage('L');
		
		$pdf->setfont('helvetica', '', 13);
		
		// Cliente
    $pdf->SetXY(14, 10);
    $pdf->Cell(0, 0, $vew_lang->customer.': '.$vew_custxt, 0, 0, 'C');

		// Periodo de liquidación 
    $pdf->text(14, 18, utf8_decode('Período DESDE: ' . $vew_slsslslqdstrdte . ' HASTA: ' . $vew_slsslslqdenddte));

    // liquidacion
    $pdf->text(14, 24, 'Liquidacion: #'.$vew_slsslslqdcod);
		
		$lv_buffer = '';
		
		// Tabla
		$lv_buffer .= '<table border="1" cellpadding="2" cellspacing="0">';
		
		// encabezado
		$lv_buffer .= '<tr style="background-color:#e6e6e6;">
						<td align="center" width="110">Contacto</td>
						<td align="center" width="55" >ID Mov</td>
						<td align="center" width="80" >Fecha</td>
						<td align="center" width="95" >Tipo</td>
						<td align="center" width="55" >Remito</td>
						<td align="center" width="50" >ID Mat</td>
						<td align="center" width="215">Material</td>
						<td align="center" width="50" >Cant</td>
						<td align="center" width="75" >Precio</td>
						<td align="center" width="75" >Total</td>
					</tr>';
		
		// cuerpo
		$lv_total = 0;
		if (!empty($vew_data)) {
			foreach($vew_data as $lv_row){
			    
			    // 1. Textos 
			    $lv_stkcnttxt = $lv_row['stkcnttxt'] ?? '';
			    $lv_stkmovcod = $lv_row['stkmovdoccod'] ?? $lv_row['movcod'] ?? '';
			    $lv_refdte    = $lv_row['refdte'] ?? '';
			    $lv_reftyp    = $lv_row['refobjtyptxt'] ?? '';
			    $lv_matcod    = $lv_row['matcod'] ?? '';
			    $lv_mattxt    = $lv_row['mattxt'] ?? '';
			    $lv_ext = $lv_row['movcodext'] ?? $lv_row['stkmovdoccodext'] ?? '';
			    $lv_remito = (trim((string)$lv_ext) !== '') ? $lv_ext : $lv_stkmovcod;
			    
			    // 2. CÁLCULO DE CANTIDAD 
          $lv_qty = (float)($lv_row['slsslslqddocqtysaved'] ?? $lv_row['slsslslqddocqtynew'] ?? $lv_row['matqty'] ?? 0);
          $lv_prc = (float)($lv_row['untmatprc'] ?? 0);

          // 3. DETERMINAR EL SIGNO (Para devoluciones)
          $matprctot_orig = (float)($lv_row['matprctot'] ?? 0);
          $lv_sign = ($matprctot_orig < 0) ? -1 : 1;
          // 4. CALCULAR TOTAL REAL
          $lv_tot = $lv_qty * $lv_prc * $lv_sign;
          // 5. Formateo para impresión
          $fmt_prc = ($lv_prc < 0) ? '-$' . number_format(abs($lv_prc), 2, ',', '.') : '$' . number_format($lv_prc, 2, ',', '.');
          $fmt_tot = ($lv_tot < 0) ? '-$' . number_format(abs($lv_tot), 2, ',', '.') : '$' . number_format($lv_tot, 2, ',', '.');
        
				$lv_buffer .= '<tr>
							  <td>'.$lv_stkcnttxt.'</td>
							  <td align="center">'.$lv_stkmovcod.'</td>
							  <td align="center">'.$lv_refdte.'</td>
							  <td>'.$lv_reftyp.'</td>
							  <td align="center">'.$lv_remito.'</td>
							  <td align="center">'.$lv_matcod.'</td>
							  <td>'.$lv_mattxt.'</td>
							  <td align="center">'.number_format( (float)$lv_qty, 2, ',', '.' ).'</td>
							  <td align="right">$'.number_format( (float)$lv_prc, 2, ',', '.' ).'</td>
							  <td align="right">$'.number_format( (float)$lv_tot, 2, ',', '.' ).'</td>
							</tr>';
				
				$lv_total = $lv_total + (float)$lv_tot;
			}
		}

		// asigna el total
		$pdf->text(237, 10, $vew_lang->total.': $'.number_format( $lv_total, 2, ',', '.' ));
		
		// cierra tabla
		$lv_buffer .= '</table>';
		
		// devuelve la tabla
		$pdf->setfont('helvetica', '', 9);
		
		$pdf->setxy(15, 34);
		$pdf->writeHTML($lv_buffer);
	}
	
	$pdf->Output('a.pdf', 'I');	
?>
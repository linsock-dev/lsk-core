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
	$pdf->SetAutoPageBreak(TRUE, 1); //PDF_MARGIN_BOTTOM);  

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
	

	// ---------------------------------------------------------
	$pdf->AddPage('P');
	
	
	// Encabezado
	$pdf->setfont('helvetica', 'B', 10);
	$pdf->line( 5,4,205,4);	
	$pdf->line( 5,4,5,78);	
	$pdf->line( 205,4,205,78);	
	$pdf->text( 90, 5, 'ORIGINAL');
	$pdf->line( 5,10,205,10);
	$pdf->setfont('helvetica', 'B', 34);
	$pdf->text( 95, 10, 'X');
	$pdf->line( 92,10,92,25);
	$pdf->line( 108,10,108,25);
	$pdf->line( 92,25,108,25);
	$pdf->line( 100,25,100,60);
	
	$pdf->setfont('helvetica', '', 8);
	$pdf->Image('/library/images/logos/zcutp1_teampediatrico.jpg',8,12,80);
	$pdf->text( 8, 38, 'Domicilio Fiscal: Almirante Juan Francisco Segui 781 - CABA');
	//$pdf->text( 8, 42, 'Centro de Distribución: General Villegas 2430, Sarandi. Avellaneda.');
	//$pdf->text(	8, 46, 'Administración: Rivera 26 - Of. B, Villa Adelina, San Isidro, Bs. As.');
	$pdf->text( 8, 50, 'Tel.: 0810-888-3402');
	$pdf->text( 8, 54, 'IVA Responsable Inscripto');
	
	$pdf->setfont('helvetica', 'B', 24);
	$pdf->text( 115, 12, 'PRESUPUESTO');
	$pdf->setfont('helvetica', 'B', 12);
	$pdf->text( 115, 25, 'Nro.: 00001-'.str_pad($vew_data->slsordcod, 8, '0', STR_PAD_LEFT));
	$pdf->setfont('helvetica', '', 8);
	$lo_mth=array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
	$pdf->text( 115, 35, 'Buenos Aires, '.date_format($vew_data->slsorddte,'d').' de '.$lo_mth[date_format($vew_data->slsorddte,'m')-1].' de '.date_format($vew_data->slsorddte,'Y'));
	$pdf->text( 115, 46, 'C.U.I.T.: 30-69922789-3');
	$pdf->text( 115, 50, 'Ingresos Brutos: 1003614');
	$pdf->text( 115, 54, 'Fecha de Inicio de Actividades: 28-04-1999');

	$pdf->setfont('helvetica', '', 10);
	$pdf->line( 5,60,205,60);
	$pdf->text( 8, 63,  $vew_data->dstobjtxt);
	$pdf->text( 8, 70,  $vew_data->dstobjadrstr . ($vew_data->dstobjadrcty!=''?' - '.$vew_data->dstobjadrcty:'') . ($vew_data->dstobjlndregtxt!=''?' - '.$vew_data->dstobjlndregtxt:'') );
	
	$pdf->text( 125, 63,  'Condición de Pago:    '.$vew_data->paytrmtxt);
	$pdf->text( 125, 70,  'Dirección de Entrega: A CONVENIR');
	$pdf->line( 5,78,205,78);
	
	// Posiciones
	$pdf->setfont('helvetica', '', 8);
	$pdf->setxy( 5, 80 );
	$lv_buffer = '<table border=0 cellpadding="5" cellspacing="2">';
	$lv_buffer .= '<thead><tr style="background-color:#C6C6C6;">'.
								'<td align="center" width="80">C&oacute;digo</td>'.
								'<td align="center" width="300">Producto / Servicio</td>'.
								'<td align="center" width="80">Cantidad</td>'.
								'<td align="center" width="80">U.medida</td>'.
								'<td align="center" width="80">Precio Unit.</td>'.
								'<td align="center" width="80">Subtotal</td>'.
								'</tr></thead>';
	$lv_tot = 0;
	foreach($vew_data->slsordmat as $lv_row) {
		if($lv_row['sysdocrejcod']=='0' || $lv_row['sysdocrejcod']==null ) {
			$lv_buffer .= '<tr>'.
										'<td align="left"  width="80">'.$lv_row['matcod'].'</td>'.
										'<td align="left"  width="300">'.utf8_encode($lv_row['mattxt']).'</td>'.
										'<td align="right" width="80">'.number_format($lv_row['matqty'],0).'</td>'.
										'<td align="left"  width="80">'.$lv_row['matuntcod'].'</td>'.
										'<td align="right" width="80">'.number_format($lv_row['matprc'],2).'</td>'.
										'<td align="right" width="80">'.number_format($lv_row['matqty']*$lv_row['matprc'],2).'</td>'.
										'</tr>';
			$lv_tot += ($lv_row['matqty']*$lv_row['matprc']);
		}	
	}
	$lv_buffer .= '</tbody></table>';
	$pdf->writeHTML($lv_buffer);
	// ---------------------------------------------------------

	$pdf->setfont('helvetica', 'B', 14);
	$pdf->text( 135, 247, 'TOTAL: '.$vew_data->curcod.'     '.number_format($lv_tot,2));

	// PIE
	$pdf->line( 5,260,205,260);	
	$pdf->line( 5,260,5,292);	
	$pdf->line( 205,260,205,292);	
	$pdf->line( 5,292,205,292);
	$pdf->setfont('helvetica', 'B', 10);
	$pdf->text( 10, 263, 'Observaciones:');
	$pdf->setfont('helvetica', '', 10);
	//$pdf->text( 10, 268, 'Presupuesto válido por 10 días.');
	$pdf->text( 10, 273, 'Los valores expresados no incluyen I.V.A.');
	//$pdf->text( 10, 278, 'El costo de envío es a convenir, sujeto a tiempos y distancias.');
	$pdf->text( 160, 278, 'Team Pediatrico S.R.L.');

	$pdf->setfont('helvetica', 'B', 10);
	$pdf->setxy(160,273);
	$pdf->Cell(0,0,$vew_data->cteusrtxt,0,0,'C');
	
	$pdf->Output('presupuesto.pdf', 'I');	
?>
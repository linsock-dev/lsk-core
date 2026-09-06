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
	$pdf->SetAutoPageBreak(TRUE, 1);

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
	

	// ---------------------------------------------------------
	$pdf->AddPage('P');
	
	
	// ENCABEZADO
	$pdf->Image('library/images/logos/zcutms_temasisargentina.jpg',8,7,80);
	$pdf->setfont('helvetica', 'B', 34);
	// ******************************************************************
	//$pdf->text( 95, 10, 'A');
	// ******************************************************************
	//$pdf->line( 92,10,108,10);
	//$pdf->line( 92,10,92,25);
	//$pdf->line( 108,10,108,25);
	//$pdf->line( 92,25,108,25);
	//$pdf->setfont('helvetica', 'B', 7);
	//$pdf->text( 92, 27, 'Cod.Nro. '.$vew_pos->argposcodext);
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->text( 8, 35, $vew_bus->bustxt);
	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 8, 42, $vew_bus->adr->adrstr.($vew_bus->adr->adrstrnum!=''?' '.$vew_bus->adr->adrstrnum:'').($vew_bus->adr->adrstrflr!=''?' Pso.'.$vew_bus->adr->adrstrflr:'').' Dto.'.$vew_bus->adr->adrstrunt);
	$pdf->text( 8, 46, ($vew_bus->adr->adrpstcod!=''?'CP: '.$vew_bus->adr->adrpstcod.' - ':'').$vew_bus->adr->lndregtxt);
	$pdf->text( 8, 50, $vew_bus->adr->lndtxt);
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->text( 8, 54, $vew_bus->tax->taxcattxt);	
	$pdf->setfont('helvetica', 'B', 24);
	$pdf->text( 115, 12, $vew_svc->sysdocclstxt);
	//$pdf->text( 115, 12, $vew_pos->argpostxt);
	$pdf->setfont('helvetica', 'B', 12);
	$pdf->text( 115, 25, 'Nro.: '.str_pad($vew_svc->slssvccod, 8, '0', STR_PAD_LEFT));
	$pdf->setfont('helvetica', '', 8);
	$lo_mth=array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
	$pdf->text( 115, 35, 'Buenos Aires, '.date_format($vew_svc->slssvcdte,'d').' de '.$lo_mth[date_format($vew_svc->slssvcdte,'m')-1].' de '.date_format($vew_svc->slssvcdte,'Y'));
	$pdf->text( 115, 42, 'C.U.I.T.: '.substr($vew_bus->tax->taxcod,0,2).'-'.substr($vew_bus->tax->taxcod,2,8).'-'.substr($vew_bus->tax->taxcod,10,1) );
	$pdf->text( 115, 46, 'Ingresos Brutos: '.$vew_bus->tax->taxiibb);
	$pdf->text( 115, 50, 'Fecha de Inicio de Actividades: '.date_format($vew_bus->tax->taxactstr,'d-m-Y'));
	
	
	// CLIENTE
	$pdf->setfont('helvetica', 'B', 10);
	$pdf->line( 6,60,206,60);
	$pdf->text( 8, 65,  $vew_svc->dstobjtxt);
	$pdf->setfont('helvetica', '', 10);
	$pdf->text( 8, 70,  $vew_svc->dstadrstr.' '.$vew_svc->dstadrstrnum. ($vew_svc->dstadrcty!=''?' - '.$vew_svc->dstadrcty:'') . ($vew_svc->dstlndregtxt!=''?' - '.$vew_svc->dstlndregtxt:'') );
	$pdf->text( 115, 65,  'Validez:  '.date_format($vew_svc->slssvcstrdte,'d/m/Y').' al '.date_format($vew_svc->slssvcenddte,'d/m/Y'));
	
	
	// POSICIONES
	$pdf->setfont('helvetica', '', 8);
	$pdf->setxy( 5, 80 );
	$lv_buffer = '<table border=0 cellpadding="2" cellspacing="2">';
	$lv_buffer .= '<thead><tr style="background-color:#C6C6C6;">'.
								'<td align="center" width="80">C&oacute;digo</td>'.
								'<td align="center" width="300">Producto / Servicio</td>'.
								'<td align="center" width="80">Cantidad</td>'.
								'<td align="center" width="80">U.medida</td>'.
								'<td align="center" width="80">Precio Unit.</td>'.
								'<td align="center" width="80">Subtotal</td>'.
								'</tr></thead>';
	$lv_tot = 0;
	foreach($vew_svc->slssvcmat as $lv_row) {
			// ******************************************************************
			// SI SE INDICO TEXTO DE VENTA USAR ESO EN LUGAR DEL TEXTO DEL MATERIAL
			// FALTA INDICAR EL SIGNO DE LA MONEDA
			// ******************************************************************
			$lv_buffer .= '<tr>'.
										'<td align="left"  width="80">'.($lv_row['matcodext']!=''?$lv_row['matcodext']:$lv_row['matcod']).'</td>'.
										'<td align="left"  width="300">'.utf8_encode($lv_row['mattxt']).'<small>'.($lv_row['slssvcstrdte']==''?'':'<br>Valido desde: '.$lv_row['slssvcstrdte']->format('d.m.Y')).($lv_row['slssvcenddte']==''?'':' - Hasta: '.$lv_row['slssvcenddte']->format('d.m.Y')).'</small></td>'.
										'<td align="right" width="80">'.number_format($lv_row['matqty'],0).'</td>'.
										'<td align="left"  width="80">'.$lv_row['matuntcod'].'</td>'.
										'<td align="right" width="80">'.($lv_row['matprc']==0?'':number_format($lv_row['matprc'],2)).'</td>'.
										'<td align="right" width="80">'.($lv_row['matprc']==0?'Bonificado':number_format($lv_row['matqty']*$lv_row['matprc'],2)).'</td>'.
										'</tr>';
			$lv_tot += ($lv_row['matqty']*$lv_row['matprc']);
	}
	$lv_buffer .= '</tbody></table>';
	$pdf->writeHTML($lv_buffer);
	

	// COMENTARIOS
	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 5, 240, '(*) Los valores expresados en el presente documento no incluyen impuestos.');

	
	// PIE
	$pdf->line( 5,245,205,245);	
	$pdf->setfont('helvetica', '', 10);
	// define QRcode style
	$code2 = 'Temasis Argentina SRL'.chr(10).'Pujol 1275 - Capital Federal'.chr(10).'+54 11 50213613'.chr(10).'www.Temasis.ar'.chr(10).'info@temasis.ar';
	$style2 = array(
			'border' => true,
			'vpadding' => 'auto',
			'hpadding' => 'auto',
			'fgcolor' => array(0,0,0),
			'bgcolor' => false, //array(255,255,255)
			'module_width' => 1, // width of a single module in points
			'module_height' => 1 // height of a single module in points
	);
	$pdf->write2DBarcode($code2, 'QRCODE,H', 5, 250, 30, 30, $style2, 'N');
	$pdf->setfont('helvetica', 'B', 10);
	$pdf->text( 40, 250, 'www.Temasis.ar');
	$pdf->setfont('helvetica', '', 10);
	$pdf->text( 40, 255, 'info@temasis.ar');
	
	
	// SUBTOTAL
	$pdf->setxy(110,245);
	// ******************************************************************
	$lv_buffer2='<table border=0 cellpadding="5" cellspacing="2"><tbody>'.
							'<tr style="font-size: 16px;"><td width="160" align="right">Subtotal '.$vew_svc->cursgn.'</td><td width="160" align="right">'.number_format($lv_tot,2).'</td></tr>'.
							'</tbody></table>';
	// ******************************************************************
	$pdf->writeHTML($lv_buffer2);	
	
	// TOTAL
	$pdf->setxy(110,270);
	// ******************************************************************
	$lv_buffer2='<table border=0 cellpadding="5" cellspacing="2"><tbody>'.
							'<tr style="background-color:#C6C6C6; font-size: 18px; font-weight: bold;"><td width="160" align="right">TOTAL '.$vew_svc->cursgn.'</td><td width="160" align="right"><span style="float:left;">'.$vew_svc->cursgn.'</span>'.number_format($lv_tot,2).'</td></tr>'.
							'</tbody></table>';
	// ******************************************************************
	$pdf->writeHTML($lv_buffer2);
	


	
	$pdf->AddPage('P');
	// ENCABEZADO
	$pdf->Image('library/images/logos/zcutms_temasisargentina.jpg',8,7,80);
	$pdf->setfont('helvetica', 'B', 34);
	// ******************************************************************
	//$pdf->text( 95, 10, 'A');
	// ******************************************************************
	//$pdf->line( 92,10,108,10);
	//$pdf->line( 92,10,92,25);
	//$pdf->line( 108,10,108,25);
	//$pdf->line( 92,25,108,25);
	//$pdf->setfont('helvetica', 'B', 7);
	//$pdf->text( 92, 27, 'Cod.Nro. '.$vew_pos->argposcodext);
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->text( 8, 35, $vew_bus->bustxt);
	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 8, 42, $vew_bus->adr->adrstr.($vew_bus->adr->adrstrnum!=''?' '.$vew_bus->adr->adrstrnum:'').($vew_bus->adr->adrstrflr!=''?' Pso.'.$vew_bus->adr->adrstrflr:'').' Dto.'.$vew_bus->adr->adrstrunt);
	$pdf->text( 8, 46, ($vew_bus->adr->adrpstcod!=''?'CP: '.$vew_bus->adr->adrpstcod.' - ':'').$vew_bus->adr->lndregtxt);
	$pdf->text( 8, 50, $vew_bus->adr->lndtxt);
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->text( 8, 54, $vew_bus->tax->taxcattxt);	
	$pdf->setfont('helvetica', 'B', 24);
	$pdf->text( 115, 12, $vew_svc->sysdocclstxt);
	//$pdf->text( 115, 12, $vew_pos->argpostxt);
	$pdf->setfont('helvetica', 'B', 12);
	$pdf->text( 115, 25, 'Nro.: '.str_pad($vew_svc->slssvccod, 8, '0', STR_PAD_LEFT));
	$pdf->setfont('helvetica', '', 8);
	$lo_mth=array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
	$pdf->text( 115, 35, 'Buenos Aires, '.date_format($vew_svc->slssvcdte,'d').' de '.$lo_mth[date_format($vew_svc->slssvcdte,'m')-1].' de '.date_format($vew_svc->slssvcdte,'Y'));
	$pdf->text( 115, 42, 'C.U.I.T.: '.substr($vew_bus->tax->taxcod,0,2).'-'.substr($vew_bus->tax->taxcod,2,8).'-'.substr($vew_bus->tax->taxcod,10,1) );
	$pdf->text( 115, 46, 'Ingresos Brutos: '.$vew_bus->tax->taxiibb);
	$pdf->text( 115, 50, 'Fecha de Inicio de Actividades: '.date_format($vew_bus->tax->taxactstr,'d-m-Y'));
	// CONDICIONES
	$pdf->setfont('helvetica', '', 10);
	$pdf->line( 6,60,206,60);
	$pdf->setxy( 5, 70 );
	$lv_buffer2='<h1>CONDICIONES DE PAGO Y EFECTOS POR MOROSIDAD</h1>'.
							'<br><h2>1. Plazo de Pago por Adelantado y Bonificación:</h2>'.
							'<br>El pago de los servicios contratados se realizará de manera mensual y por adelantado, debiendo efectuarse dentro de los primeros <b>diez (10) días</b> calendario de cada mes en curso.<br>'.
							'<br><b>Incentivo por pago puntual:</b> Si el CLIENTE realiza el pago total de la factura antes o el mismo <b>día diez (10)</b> de su vencimiento, se le otorgará un descuento del 5%, el cual se aplicará de forma automática en la factura del mes inmediato posterior.'.
							'<br><h2>2. Intereses por Pago Tardío:</h2>'.
							'<br>Cualquier factura que se pague después del último día del mes de vencimiento, generará un <b>cargo por mora del 5%</b> sobre el saldo adeudado. Dicho cargo se verá reflejado y facturado en el siguiente ciclo de facturación.</br>'.
							'<br><h2>3. Suspensión del Servicio (Más de 60 días):</h2>'.
							'<br>En caso de que el CLIENTE acumule un retraso en el pago superior a los <b>sesenta (60) días</b> calendario, EL PROVEEDOR quedará plenamente facultado para suspender de manera temporal o definitiva la prestación del servicio, sin necesidad de previo aviso judicial y sin que esto exima al CLIENTE de la obligación de liquidar los saldos pendientes y los recargos acumulados. La reactivación del servicio estará sujeta al pago total de la deuda.<br>';
	$pdf->writeHTML($lv_buffer2);
	

	// OUTPUT
	$pdf->Output($vew_svc->dstobjtxt.' - Suscripcion Nro '.$vew_svc->slssvccod.' - '.date_format($vew_svc->slssvcstrdte,'Y').'.pdf', (($vew_getbuffer??'')==''?'I':'S') );	
?>
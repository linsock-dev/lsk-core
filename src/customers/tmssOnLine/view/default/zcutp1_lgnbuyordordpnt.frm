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
 
 
  $vew_data->buyordcod = $vew_data->buyordcod ?? 0;
  $vew_data->buyorddte = $vew_data->buyorddte ?? newDateTime();
  $vew_data->curcod = $vew_data->curcod ?? '';
  $vew_data->cteusrtxt = $vew_data->cteusrtxt ?? '';
	$vew_data->srcobjtxt = $vew_data->srcobjtxt ?? '';
 
	$pdf->AddPage('P');
	$lv_isord=$vew_actcod=='movdocmovret'?1:0;
	// Encabezado
	$pdf->setfont('helvetica', '', 8);
	switch ($vew_data->buscod) {
		case 'TINFUSIONAR':
			$pdf->Image('library/images/logos/lsdmh.jpg',20, 15, 60);			
			$pdf->setfont('helvetica', '', 10);
			$pdf->text( 43, 32, 'LSDM S.A.');
			$pdf->setfont('helvetica', '', 8);
			$pdf->text( 8, 42, 'Domicilio Fiscal: Almte. F. J. Segui 785. CABA');
			$pdf->text(	8, 46, 'Administración: Rivera 26 - Of. B, Villa Adelina, San Isidro, Bs. As.');
			$pdf->text( 8, 50, 'Tel.: 0810-362-0022');
			$pdf->text( 8, 54, 'IVA Responsable Inscripto');
			$pdf->text( 115, 46, 'C.U.I.T.: 33-71470265-9');
			$pdf->text( 115, 50, 'Ingresos Brutos: 1283640-11');
			$pdf->text( 115, 54, 'Fecha de Inicio de Actividades: 01-01-2015');
			$pdf->text( 170, 278, 'LSDM SA');			
			break;
		case 'LOGIN':
			$pdf->Image('library/images/logos/zcutp1_logindoor.jpg',8,12,80);
			$pdf->text( 8, 38, 'Domicilio Fiscal: Av. Rivadavia 4975 - P.2 - Dpto.129 - CABA');
			$pdf->text( 8, 42, 'Centro de Distribucion: Av. B.Ader 3620, Nave 6, Villa Adelina, Bs.As.');
			$pdf->text(	8, 46, 'Administración: Rivera 26 - Of. B, Villa Adelina, San Isidro, Bs. As.');
			$pdf->text( 8, 50, 'Tel.: 0810-362-0222');
			$pdf->text( 8, 54, 'IVA Responsable Inscripto');	
			$pdf->text( 115, 46, 'C.U.I.T.: 30-71124438-3');
			$pdf->text( 115, 50, 'Ingresos Brutos CM: 30-71124438-3');
			$pdf->text( 115, 54, 'Fecha de Inicio de Actividades: 28-04-1999');
			$pdf->text( 170, 278, 'Logindoor S.A.');			
			break;			
		case 'TPEDIATRICO':
			$pdf->Image('library/images/logos/teampediatricon.jpg', 15, 5, 75, '', '', '', 'T', false, 100, '', false, false, 0, false, false, false);		
			$pdf->text( 8, 42, 'Domicilio Fiscal: Almte. F. J. Segui 785. CABA');
			$pdf->text(	8, 46, 'Administración: Rivera 26 - Of. B, Villa Adelina, San Isidro, Bs. As.');
			$pdf->text( 8, 50, 'Tel.: 0810-362-0222');
			$pdf->text( 8, 54, 'IVA Responsable Inscripto');	
			$pdf->text( 115, 46, 'C.U.I.T.: 30-69922789-3');
			$pdf->text( 115, 50, 'Ingresos Brutos CM: 30-69922789-3');
			$pdf->text( 115, 54, 'Fecha de Inicio de Actividades: 28-04-1999');	
			$pdf->text( 170, 278, 'Team Pediatrico S.R.L.');			
			break;
		default;
		$pdf->Image('library/images/logos/zcutp1_logindoor.jpg',8,12,80);
		$pdf->text( 8, 38, 'Domicilio Fiscal: Av. Rivadavia 4975 - P.2 - Dpto.129 - CABA');
		$pdf->text( 8, 42, 'Centro de Distribución: General Villegas 2430, Sarandi. Avellaneda.');
		$pdf->text(	8, 46, 'Administración: Rivera 26 - Of. B, Villa Adelina, San Isidro, Bs. As.');
		$pdf->text( 8, 50, 'Tel.: 0810-362-0222');
		$pdf->text( 8, 54, 'IVA Responsable Inscripto');	
		$pdf->text( 115, 46, 'C.U.I.T.: 30-71124438-3');
		$pdf->text( 115, 50, 'Ingresos Brutos CM: 30-71124438-3');
		$pdf->text( 115, 54, 'Fecha de Inicio de Actividades: 28-04-1999');
		$pdf->text( 170, 278, 'Logindoor S.A.');		
	}
 
	
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

 
 
	$pdf->setfont('helvetica', 'B', 24);
	$pdf->text( 115, 12, 'ORDEN DE COMPRA');
	$pdf->setfont('helvetica', 'B', 12);
	$pdf->text( 115, 25, 'Nro.: 00001-'.str_pad($vew_data->buyordcod, 8, '0', STR_PAD_LEFT));
	$pdf->setfont('helvetica', '', 8);
	$lo_mth=array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
	$pdf->text( 115, 35, 'Buenos Aires, '.date_format($vew_data->buyorddte,'d').' de '.$lo_mth[date_format($vew_data->buyorddte,'m')-1].' de '.date_format($vew_data->buyorddte,'Y'));
 
 
	$pdf->setfont('helvetica', '', 10);
	$pdf->line( 5,60,205,60);
	$pdf->text( 8, 63,  $vew_data->srcobjtxt);
	$pdf->text( 8, 70,  $vew_data->srcobjadrstr . ($vew_data->srcobjadrcty!=''?' - '.$vew_data->srcobjadrcty:'') . ($vew_data->srcobjlndregtxt!=''?' - '.$vew_data->srcobjlndregtxt:'') );
	$pdf->text( 125, 63,  'Condición de Pago:        '.($vew_data->paytrmtxt!=''?$vew_data->paytrmtxt:'----------'));
	$pdf->text( 125, 70,  'Dirección de Entrega:     A CONVENIR');
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
	foreach($vew_data->buyordmat as $lv_row) {
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
  	//$vew_txt = $vew_txt ?? [];
	$pdf->setfont('helvetica', 'B', 10);
	$pdf->text( 10, 263, 'Observaciones:');
	$pdf->setfont('helvetica', '', 10);
	$lv_0=''; 
	$lv_tx=0;
	 
    foreach ($vew_txt as $lv_row) {
      if(utf8_encode($lv_row['txttypcodext']=='OBSCHG')){
			$lv_0.=html_entity_decode(htmlspecialchars_decode(utf8_encode($lv_row['txttxt'])));
			$lv_tx++;
			break;
        }
    }

    if($lv_tx==0) { $pdf->text( 10, 273, 'Los valores expresados no incluyen I.V.A.'); }
    
    $pdf->setxy( 0, 265 ); 
    $pdf->writeHTML( $lv_0 );

	$pdf->setfont('helvetica', 'B', 10);
	$pdf->setxy(170,273);
	$pdf->Cell(0,0,$vew_data->cteusrtxt,0,0,'C');

	$pdf->Output('orden_de_compra.pdf', 'I');

?>
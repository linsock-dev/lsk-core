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

  $lv_ref = '';
  foreach($vew_data->buyordmat as $lv_row){
    if ($lv_row['docrefcod'] != 0){
    	if(strpos('/'.$lv_ref.'/','/'.$lv_row['docrefcod'].'/')===false){ $lv_ref.=($lv_ref==''?'':'/').$lv_row['docrefcod']; } 
    }
  }
	
	// ---------------------------------------------------------
	$pdf->AddPage('P');

	// Encabezado
	$pdf->setfont('helvetica', '', 10);
	$pdf->line( 5,4,205,4);
	$pdf->line( 5,4,5,78);
	$pdf->line( 205,4,205,78);
	$pdf->SetFillColor(0,0,0);
	$pdf->text( 170, 5, 'F-007-SS Rev.01');
	$pdf->line( 5,10,205,10);
	$pdf->setfont('helvetica', 'B', 34);
	$pdf->text( 95, 10, 'X');
	$pdf->line( 92,10,92,25);
	$pdf->line( 108,10,108,25);
	$pdf->line( 92,25,108,25);
	$pdf->line( 100,25,100,60);

	$pdf->setfont('helvetica', '', 8);
	$pdf->Image('library/images/logos/supplysouth.jpg',8,12,80);
	$pdf->text( 8, 40, 'Dirección: (C.P. 1870) Av Escalada 2081 - Mataderos - CABA');
	$pdf->text( 8, 44, 'Tel./Fax: 4-11-4635-2300');
	$pdf->text(	8, 48, 'CUIT Nº: 30-71401068-5');
	$pdf->text( 8, 52, 'IVA Responsable Inscripto');

	$pdf->setfont('helvetica', 'B', 24);
	$pdf->text( 115, 12, 'ORDEN DE COMPRA');
	$pdf->setfont('helvetica', 'B', 12);
	$pdf->setxy(115, 28);
	$pdf->text( 115, 25, 'Nro.: '.str_pad($vew_data->buyordcod, 8, '0', STR_PAD_LEFT));
	$pdf->setfont('helvetica', '', 9);
	$pdf->text( 115, 35, 'Fecha: '.date_format($vew_data->buyorddte,'d/m/Y'));
	$pdf->text( 115, 39, 'Nº R.I.: '.$lv_ref);

	$pdf->setfont('helvetica', '', 10);
	$pdf->line( 5,60,205,60);
	$pdf->text( 8, 62, 'Proveedor:');
  $pdf->text( 8, 67, 'Dirección:');
  $pdf->text( 8, 72, 'Tel./Fax:');
	$pdf->text( 108, 72, 'e-mail:');
	$pdf->text( 108, 62, 'Nro. Oferta Proverdor:');
	$pdf->setfont('helvetica', 'B', 9);
	$pdf->text( 144, 62, $vew_data->buyordcodext);
	$pdf->text( 28, 62, $vew_data->srcobjtxt);	
  $pdf->text( 28, 67, $vew_data->sup->adrstr . ($vew_data->sup->adr->adrstrnum!=''?' '.$vew_data->sup->adr->adrstrnum:'') . ($vew_data->sup->adr->adrstrflr!=''?' - Pso.'.$vew_data->sup->adr->adrstrflr:'') . ($vew_data->sup->adr->adrstrunt!=''?' - Dto.'.$vew_data->sup->adr->adrstrunt:''). ($vew_data->sup->adr->adrstrbld!=''?' - Edf.'.$vew_data->sup->adr->adrstrbld:'') . ($vew_data->sup->adrcty!=''?' - '.$vew_data->sup->adrcty:'') . ($vew_data->sup->lndregtxt!=''?' - '.$vew_data->sup->lndregtxt:''));
  $pdf->text( 28, 72, $vew_data->sup->adrphn001 . ($vew_data->sup->adrphn002!=''?' - '.$vew_data->sup->adrphn002:'') . ($vew_data->sup->adrmblphn!=''?' - '.$vew_data->sup->adrmblphn:''));
	$pdf->text( 125, 72, strtolower($vew_data->sup->adreml));

	$pdf->line( 5,78,205,78);

	// Posiciones
	$pdf->setfont('helvetica', '', 8);
	$pdf->setxy( 5, 80 );
	$lv_buffer = '<table border=1 cellpadding="5" cellspacing="2">';
	$lv_buffer .= '<thead><tr style="background-color:#C6C6C6;">'.
								'<td align="center" width="80">Nº Item</td>'.
								'<td align="center" width="80">Cantidad</td>'.
								'<td align="center" width="300">Descripci&oacute;n</td>'.
								'<td align="center" width="120">Importe</td>'.
								'<td align="center" width="120">Total</td>'.
								'</tr></thead>';
	$lv_tot = 0;
	foreach($vew_data->buyordmat as $key=>$lv_row) {
		if($lv_row['sysdocrejcod']=='0' || $lv_row['sysdocrejcod']==null ) {
			$lv_buffer .= '<tr>'.
										'<td align="center"  width="80">'.($key+1).'</td>'.
        						'<td align="center" width="80">'.number_format($lv_row['matqty'],0).'</td>'.
										'<td align="left"  width="300">'.utf8_encode($lv_row['mattxt']).'</td>'.
        						'<td align="right" width="120">'.number_format($lv_row['matprc'],2).'</td>'.										
										'<td align="right" width="120">'.number_format($lv_row['matqty']*$lv_row['matprc'],2).'</td>'.
										'</tr>';
			$lv_tot += ($lv_row['matqty']*$lv_row['matprc']);
		}
	}
	// asistentes
	if( count($vew_data->asstxt)>0 ){
		$lv_buffer .= '<tr><td></td><td></td><td><b>Asistentes:</b>'.html_entity_decode(utf8_encode($vew_data->asstxt['txttxt'])).'</td></tr>';
	}
	$lv_buffer .= '</tbody></table>';
	$pdf->writeHTML($lv_buffer);
	
	$pdf->SetDrawColor(198,198,198);
	$pdf->line( 28,80,28,230);
  $pdf->line( 52,80,52,230);
  $pdf->line( 137,80,137,230);
  $pdf->line( 171,80,171,230);
	$pdf->SetDrawColor(0,0,0);
  $pdf->line( 5,230,205,230);
	// ---------------------------------------------------------

	$pdf->setfont('helvetica', '', 12);
	$pdf->SetFillColor(255,255,255);
	$pdf->text( 140, 237, 'Subtotal: ');	
	$pdf->setxy(170, 237);
	$pdf->Cell(0, 0, $vew_data->curcod.'  '.number_format($lv_tot,2), '', 1, 'R', 1, '', 0, false, 'T', 'C');
	$pdf->setfont('helvetica', 'B', 12);
	$pdf->text( 140, 247, 'TOTAL: ');
	$pdf->setxy(170, 247);
	$pdf->Cell(0, 0, $vew_data->curcod.'  '.number_format($lv_tot,2), '', 1, 'R', 1, '', 0, false, 'T', 'C');

	// PIE
	$pdf->line( 5,260,205,260);
	
	$pdf->setfont('helvetica', 'B', 10);
	$pdf->text( 10, 263, 'Condición de pago:');
  $pdf->text( 10, 268, 'Plazo de entrega:');
  $pdf->text( 10, 273, 'Lugar de entrega:');
  $pdf->text( 10, 278, 'Observaciones:');
	$pdf->setfont('helvetica', '', 10);
	$pdf->text( 50, 263, $vew_data->paytrmtxt);
  $pdf->text( 50, 268, '-----');
  $pdf->text( 50, 273, '-----');
  $pdf->text( 50, 278, '-----');

	$pdf->Image('library/images/logos/supplysouth_iso9001_45001_iqnet.jpg',153,263,45);

	$pdf->Output('OC'.str_pad($vew_data->buyordcod, 8, '0', STR_PAD_LEFT).'_'.$vew_data->buyorddte->format('Ymd').'_.pdf', 'I');
?>
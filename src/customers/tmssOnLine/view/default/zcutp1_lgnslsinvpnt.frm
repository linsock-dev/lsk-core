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
	$pdf->text( 95, 9, $vew_pos->argltrcodext);

	$pdf->setfont('helvetica', 'B', 7);
	$pdf->text( 92, 22, 'Cod.Nro. '.$vew_pos->argposcodext);

	$pdf->line( 92,10,92,25);
	$pdf->line( 108,10,108,25);
	$pdf->line( 92,25,108,25);
	$pdf->line( 100,25,100,60);
	
	$pdf->setfont('helvetica', '', 8);
	$pdf->Image('/library/images/logos/zcutp1_logindoor.jpg',8,12,80);
	
	$pdf->text( 8, 38, $vew_bus->bustxt);	
	$pdf->text( 8, 42, $vew_bus->adr->adrstr.($vew_bus->adr->adrstrnum!=''?' '.$vew_bus->adr->adrstrnum:'').($vew_bus->adr->adrstrflr!=''?' Pso.'.$vew_bus->adr->adrstrflr:'').' Dto.'.$vew_bus->adr->adrstrunt);
	$pdf->text( 8, 46, ($vew_bus->adr->adrpstcod!=''?'CP: '.$vew_bus->adr->adrpstcod.' - ':'').$vew_bus->adr->lndregtxt);
	$pdf->text(	8, 50, $vew_bus->adr->lndtxt);
	$pdf->text( 8, 54, $vew_bus->tax->taxcattxt);
	
	$pdf->setfont('helvetica', 'B', 24);
	$pdf->text( 115, 12, $vew_pos->argpostxt);
	$pdf->setfont('helvetica', 'B', 12);
	$pdf->text( 115, 25, 'Nro.: '.substr($vew_inv->slsinvcodext,0,strlen($vew_inv->slsinvcodext)-9).'-'.substr($vew_inv->slsinvcodext, -8) );
	$pdf->setfont('helvetica', '', 8);
	$lo_mth=array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
	$pdf->text( 115, 35, 'Buenos Aires, '.date_format($vew_inv->slsinvdte,'d').' de '.$lo_mth[date_format($vew_inv->slsinvdte,'m')-1].' de '.date_format($vew_inv->slsinvdte,'Y') );
	$pdf->text( 115, 46, 'C.U.I.T.: '.substr($vew_bus->tax->taxcod,0,2).'-'.substr($vew_bus->tax->taxcod,2,8).'-'.substr($vew_bus->tax->taxcod,10,1));
	$pdf->text( 115, 50, 'Ingresos Brutos: '.$vew_bus->tax->taxiibb);
	$pdf->text( 115, 54, 'Fecha de Inicio de Actividades: '.date_format($vew_bus->tax->taxactstr,'d-m-Y'));

	$pdf->setfont('helvetica', '', 10);
	$pdf->line( 5,60,205,60);
	$pdf->text( 8, 61,  $vew_cus->custxt);
	$pdf->text( 8, 65,  $vew_cus->adr->adrstr.' '.$vew_cus->adr->adrstrnum. ($vew_cus->adr->adrcty!=''?' - '.$vew_cus->adr->adrcty:'') . ($vew_cus->adr->lndregtxt!=''?' - '.$vew_cus->adr->lndregtxt:'') );
	$pdf->text( 8, 69,  $vew_cus->tax->taxcattxt);
	$pdf->text( 8, 73,  'C.U.I.T.: '.substr($vew_cus->tax->taxcod,0,2).'-'.substr($vew_cus->tax->taxcod,2,8).'-'.substr($vew_cus->tax->taxcod,10,1) );	
	
	$pdf->text( 125, 63,  'Condición de Pago: '.$vew_inv->paytrmtxt);
	$pdf->text( 125, 70,  'Fecha Vto de Pago: '.($vew_inv->slsinvduedte != '' ? $vew_inv->slsinvduedte->format('d/m/Y') : ''));
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
	foreach($vew_inv->slsinvmat as $lv_row) {
		if($lv_row['sysdocrejcod']=='0' || $lv_row['sysdocrejcod']==null ) {
			$lv_mattxt = $vew_doc->getTagValue($lv_row['slsinvmatatr'],'slsinvmatslstxt');
			$lv_mattxt = utf8_encode(trim($lv_mattxt)!=''?trim($lv_mattxt):$lv_row['mattxt']);
			$lv_buffer .= '<tr>'.
										'<td align="left"  width="80">'.$lv_row['matcod'].'</td>'.
										'<td align="left"  width="300">'.$lv_mattxt.'</td>'.
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

	// PIE
	$pdf->line( 5,245,205,245);	
	$pdf->line( 5,245,5,292);	
	$pdf->line( 205,245,205,292);	
	$pdf->line( 5,292,205,292);
	
	// ******************************************************************
	// defino codigo de barras y determino digito verificador (Resolución General A.F.I.P. 1.702/04)
	//$code = '30716290545001000016945506491190120191118';	
	$code = $vew_bus->tax->taxcod .str_pad($vew_pos->argposcodext, 3, '0', STR_PAD_LEFT) .str_pad($vew_inv->slsposcodext, 5, '0', STR_PAD_LEFT) .$vew_fce->slsinvfceautcodext . ($vew_fce->slsinvfceautduedte != '' ? date_format($vew_fce->slsinvfceautduedte,'Ymd') : '');
	$lv_sum1 = 0; for($i=1;$i<strlen($code);$i=$i+2){$lv_sum1+=substr($code,$i,1);}
	$lv_sum1 = $lv_sum1 * 3;
	$lv_sum2 = 0; for($i=0;$i<strlen($code);$i=$i+2){$lv_sum2+=substr($code,$i,1);}
	$lv_sum3 = $lv_sum1 + $lv_sum2;
	$lv_digi = 10 - ($lv_sum3 % 10);
	$code .= $lv_digi;
	// define barcode style
	$style = array(
			'position' => '',
			'align' => 'C',
			'stretch' => false,
			'fitwidth' => true,
			'cellfitalign' => '',
			'border' => false,
			'hpadding' => 'auto',
			'vpadding' => 'auto',
			'fgcolor' => array(0,0,0),
			'bgcolor' => false, //array(255,255,255),
			'text' => true,
			'font' => 'helvetica',
			'fontsize' => 6,
			'stretchtext' => 4
	);
	$pdf->write1DBarcode($code, 'I25', 15, 275, '', 12, 0.23, $style, 'N');

	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 18, 287, 'C.A.E.: '.$vew_fce->slsinvfceautcodext);
	$pdf->text( 54, 287, 'Vto. C.A.E.: '.($vew_fce->slsinvfceautduedte != '' ? date_format($vew_fce->slsinvfceautduedte,'d/m/Y') : '')  );

	
	// SUBTOTAL
	$pdf->setxy(110,235);
	// ******************************************************************
	$lv_buffer2='<table border=0 cellpadding="5" cellspacing="2"><tbody>'.
							'<tr style="font-size: 16px;"><td width="160" align="right">Subtotal</td><td width="160" align="right">'.number_format($vew_inv->slsinvnetamt,2).'</td></tr>'.
							'</tbody></table>';
	// ******************************************************************
	$pdf->writeHTML($lv_buffer2);
		
	// IMPUESTOS
	$pdf->setxy(110,248);
	// ******************************************************************
	$lv_buffer2='<table border=0 cellpadding="5" cellspacing="2"><tbody>';
	foreach($vew_inv->slsinvprc as $lv_row){
		if($lv_row['fintaxtypcat']=='IVA' && $lv_row['srcobjcod002']=='' && $lv_row['prccndtot']!=0 ){
			$lv_buffer2.='<tr style="font-size: 16px;"><td width="160" align="right">'.$lv_row['prccndtxt'].' '.number_format($lv_row['prccndqty']).' '.$lv_row['prccnduntcod'].'</td><td width="160" align="right">'.number_format($lv_row['prccndtot'],2).'</td></tr>';
		}
	}
	$lv_buffer2.='</tbody></table>';
	// ******************************************************************
	$pdf->writeHTML($lv_buffer2);
	
	
	// TOTAL
	$pdf->setxy(110,270);
	// ******************************************************************
	$lv_buffer2='<table border=0 cellpadding="5" cellspacing="2"><tbody>'.
							'<tr style="background-color:#C6C6C6; font-size: 18px; font-weight: bold;"><td width="160" align="right">TOTAL</td><td width="160" align="right">'.number_format($vew_inv->slsinvtotamt,2).'</td></tr>'.
							'</tbody></table>';
	// ******************************************************************
	$pdf->writeHTML($lv_buffer2);
	
	
	$pdf->Output($vew_pos->argpostxt.'_'.$vew_inv->slsinvcodext.'.pdf', 'I');	
?>
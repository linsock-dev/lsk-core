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
	$lv_dstobjtxt2Renglones = (strlen(($vew_data->dstobjtxt??'').(($vew_data->dstcnttxt??'')!=''?' - '.$vew_data->dstcnttxt:'')) > 50?7:0);
	// Encabezado
	$pdf->setfont('helvetica', 'B', 10);
	$pdf->line( 5,4,205,4);	
	$pdf->line( 5,4,5,78+$lv_dstobjtxt2Renglones);	
	$pdf->line( 205,4,205,78+$lv_dstobjtxt2Renglones);	
	$pdf->text( 90, 5, 'ORIGINAL');
	$pdf->line( 5,10,205,10);
	$pdf->setfont('helvetica', 'B', 30);
	$pdf->text( 92, 10, 'CP');
	$pdf->line( 92,10,92,25);
	$pdf->line( 108,10,108,25);
	$pdf->line( 92,25,108,25);
	//$pdf->line( 100,25,100,60);

	$pdf->setfont('helvetica', '', 8);
	//$pdf->text( 91, 26, 'Código N° 91');
	$pdf->setfont('helvetica', '', 7);
	$pdf->text( 93, 30, 'Documento');
	$pdf->text( 95, 33, 'no válido');
	$pdf->text( 93, 36, 'como factura');
	$pdf->line( 100,40,100,60);
		
	//$pdf->Image('/library/images/logos/zcutp1_logindoor.jpg',8,12,80);
	$pdf->setfont('helvetica', 'B', 18);
	$pdf->text( 8, 13, 'Supply South S.R.L.');
	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 8, 25, 'Montajes Electromecánicos y Civiles');
  $pdf->text( 8, 42, 'Domicilio Fiscal: Av. Escalada 2081 - CP1407 - CABA');
	$pdf->text( 8, 46, 'Tel.: (011) 4635-2300');
	$pdf->text( 14, 50, ' (011) 2113-0548');
	$pdf->text( 8, 54, 'IVA Responsable Inscripto');
	
	$pdf->setfont('helvetica', 'B', 24);
	$pdf->text( 115, 12, 'CARTA DE PORTE');
	$pdf->setfont('helvetica', 'B', 12);
	$pdf->text( 115, 25, 'Nro.: '.str_pad($vew_data->stkmovdoccod, 8, '0', STR_PAD_LEFT));
	$pdf->setfont('helvetica', '', 8);
	$lo_mth=array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
	$pdf->text( 115, 35, 'Buenos Aires, '.date_format($vew_data->stkmovdocdte,'d').' de '.$lo_mth[date_format($vew_data->stkmovdocdte,'m')-1].' de '.date_format($vew_data->stkmovdocdte,'Y'));
	$pdf->text( 115, 46, 'C.U.I.T.: 30-71401068-5');
	$pdf->text( 115, 50, 'Ingresos Brutos CM: 30-71401068-5');
	$pdf->text( 115, 54, 'Fecha de Inicio de Actividades: 08-08-2012');
	
	$pdf->setfont('helvetica', '', 10);
	$pdf->line( 5,60,205,60);
	if($lv_dstobjtxt2Renglones == 0){
    	$pdf->text( 8, 63,  $vew_data->dstobjtxt . ($vew_data->dstcnttxt!=''?' - '.$vew_data->dstcnttxt:'') );
  }else{
    	$pdf->text( 8, 63, substr($vew_data->dstobjtxt. ($vew_data->dstcnttxt!=''?' - '.$vew_data->dstcnttxt:''),0,strrpos(substr($vew_data->dstobjtxt. ($vew_data->dstcnttxt!=''?' - '.$vew_data->dstcnttxt:''),0,50),' ',0)));
      $pdf->text( 8, 70, substr($vew_data->dstobjtxt. ($vew_data->dstcnttxt!=''?' - '.$vew_data->dstcnttxt:''),strrpos(substr($vew_data->dstobjtxt. ($vew_data->dstcnttxt!=''?' - '.$vew_data->dstcnttxt:''),0,50),' ',0)+1));
  }
	$pdf->text( 8, 70+$lv_dstobjtxt2Renglones,  $vew_data->dstobjadrstr .' '.$vew_data->dstobjadrstrnum. ($vew_data->dstobjadrcty!=''?' - '.$vew_data->dstobjadrcty:'') . ($vew_data->dstobjlndregtxt!=''?' - '.$vew_data->dstobjlndregtxt:'') );
	$pdf->text( 125, 63,  'Retira: '.$vew_doc->gettagvalue($vew_data->stkmovdocatr,'pic') );
	$pdf->text( 125, 70,  'Proyecto: '.$vew_stesrc->stecodext.($vew_stesrc->stecodext!='' && $vew_stedst->stecodext!=''?' / ':'').$vew_stedst->stecodext);
	$pdf->line( 5,78+$lv_dstobjtxt2Renglones,205,78+$lv_dstobjtxt2Renglones);
	
	// Posiciones
	$pdf->setfont('helvetica', '', 8);
	$pdf->setxy( 5, 80+$lv_dstobjtxt2Renglones );	
	$lv_buffer = '<table border=0 cellpadding="5" cellspacing="2">';
	$lv_buffer .= '<thead><tr style="background-color:#C6C6C6;">'.
								'<td align="center" width="80">C&oacute;digo</td>'.
								'<td align="center" width="450">Producto / Servicio</td>'.
								'<td align="center" width="80">Cantidad</td>'.
								'<td align="center" width="80">U.medida</td>'.
								'</tr></thead>';
	foreach($vew_data->stkmovdocmat as $lv_row) {
		if($lv_row['sysdocrejcod']=='0' || $lv_row['sysdocrejcod']==null) {
			$lv_addDat = '';
			if ( $lv_row['matbchcodext']!='' ) { $lv_addDat .= '<br><span style="font-size: 9px;">Lote: '.$lv_row['matbchcodext'].' - Vto: '.date_format($lv_row['matbchduedte'],'d/m/Y').'</span>'; }
			if ( $lv_row['matsercod']!='' ) { $lv_addDat .= '<br><span style="font-size: 9px;">Serie: '.$lv_row['matsercodext'].'</span>'; }
			$lv_buffer .= '<tr>'.
										'<td align="left"  width="80">'.$lv_row['matcod'].'</td>'.
										'<td align="left"  width="450">'.utf8_encode($lv_row['mattxt']).$lv_addDat.'</td>'.
										'<td align="right" width="80">'.number_format($lv_row['matqty'],0).'</td>'.
										'<td align="left"  width="80">'.$lv_row['matuntcod'].'</td>'.
										'</tr>';
		}
	}	
	$lv_buffer .= '</tbody></table>';
	$pdf->writeHTML($lv_buffer);
	// ---------------------------------------------------------

	//$pdf->text( 135, 247, 'TOTAL: '.$vew_data->curcod.'     '.number_format($lv_tot,2));

	$pdf->setfont('helvetica', '', 8);
	$pdf->setxy( 5, 244 );
	$pdf->writehtml( '<table border="1" cellpadding="5"width="708"><tr><td>Fecha Carga</td><td>Transportista</td><td>Patente</td><td>Conductor</td><td>Destinatario</td><td>Control Salida</td><td>Emisor Documento</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td><td>'.$vew_data->accusr.'<br>'.$vew_data->accdte->format('d/m/Y H:i').'</td></tr></table>');
  /*  
  $pdf->text( 10, 250, 'Fecha Carga');
  $pdf->text( 10, 250, 'Transportista');
  $pdf->text( 10, 250, 'Patente');
  $pdf->text( 10, 250, 'Conductor');
  $pdf->text( 10, 250, 'Destinatario');
  $pdf->text( 10, 250, 'Control Salida');
  $pdf->text( 10, 250, 'Emisor Documento');
*/

	// PIE
	$pdf->line( 5,260,205,260);	
	$pdf->line( 5,260,5,292);	
	$pdf->line( 205,260,205,292);	
	$pdf->line( 5,292,205,292);
	$pdf->setfont('helvetica', '', 10);
	$pdf->text( 10, 263, 'Observaciones:');
	$pdf->setfont('helvetica', 'B', 10);
	$pdf->text( 37, 263, $vew_data->stkmovdoccmt );
	$pdf->setfont('helvetica', '', 10);
	//$pdf->text( 10, 268, 'Presupuesto válido por 10 días.');
	//$pdf->text( 10, 273, 'Los valores expresados no incluyen I.V.A.');
	//$pdf->text( 10, 278, 'El costo de envío es a convenir, sujeto a tiempos y distancias.');
	$pdf->setxy( 10, 278 );
  $pdf->writehtml( '<table><tr><td>En cumplimiento a la D.N. "B" Nro. 32/2006 de la D.P.R. de la Pcia. de Bs. As. y la res. Nº 1678/AGIP/2017 (GCBA), se consigna que los bienes trasladados tienen el carácter de bienes de uso; no constituyendo autotransporte, ni acarreo, ni transporte comercial alguno.</td></tr></table>' );


	$pdf->setfont('helvetica', 'B', 10);
	$pdf->setxy(170,273);
	//$pdf->Cell(0,0,$vew_data->cteusrtxt,0,0,'C');

	$pdf->Output('remito.pdf', 'I');	
?>
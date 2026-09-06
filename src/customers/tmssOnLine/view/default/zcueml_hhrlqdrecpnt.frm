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
	$pdf->AddPage('L');
	
	// Encabezado
	if($vew_data->bus->busimg!=''){$pdf->Image('@'.$vew_data->bus->busimg, 20,10,20);}
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->text( 40, 10, $vew_data->bus->bustxt);
	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 40, 15, ucwords(strtolower($vew_data->bus->adr->adrstr)).' '.$vew_data->bus->adr->adrstrnum);
	$pdf->text( 80, 15, $vew_data->bus->tax->taxcattxt.' '.$vew_data->bus->tax->idttyptxt.': '.$vew_data->bus->tax->taxdocnum);

	if($vew_data->bus->busimg!=''){$pdf->Image('@'.$vew_data->bus->busimg, 160,10,20);}
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->text( 180, 10, $vew_data->bus->bustxt);
	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 180, 15, ucwords(strtolower($vew_data->bus->adr->adrstr)).' '.$vew_data->bus->adr->adrstrnum);
	$pdf->text( 220, 15, $vew_data->bus->tax->taxcattxt.' '.$vew_data->bus->tax->idttyptxt.': '.$vew_data->bus->tax->taxdocnum);
	
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->text( 100, 20, 'PERIODO DE PAGO' );
	$pdf->text( 240, 20, 'PERIODO DE PAGO' );
	
	$pdf->setfont('helvetica', '', 8);
	$lv_meses = array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
	$pdf->text( 100, 25, $lv_meses[ intval($vew_data->hhrlqdstrdte->format('m'))-1 ].' de '.$vew_data->hhrlqdstrdte->format('Y') );
	$pdf->text( 40, 25, 'Recibo N° '.$vew_data->hhrlqdcod );
	$pdf->line( 20,32,140,32);	
	$pdf->text( 20, 35, $vew_doc->getTagValue($vew_data->hhrlqdatr001,'srcobjtxt') );
	$pdf->text( 70, 35, 'Legajo: '.$vew_data->srcobjcod001);
	$pdf->text( 100, 35, $vew_data->emp->tax->idttyptxt.': '.$vew_data->emp->tax->taxdocnum);

	$pdf->text( 240, 25, $lv_meses[ intval($vew_data->hhrlqdstrdte->format('m'))-1 ].' de '.$vew_data->hhrlqdstrdte->format('Y') );
	$pdf->text( 180, 25, 'Recibo N° '.$vew_data->hhrlqdcod );
	$pdf->line( 160,32,280,32);	
	$pdf->text( 160, 35, $vew_doc->getTagValue($vew_data->hhrlqdatr001,'srcobjtxt') );
	$pdf->text( 210, 35, 'Legajo: '.$vew_data->srcobjcod001);
	$pdf->text( 240, 35, $vew_data->emp->tax->idttyptxt.': '.$vew_data->emp->tax->taxdocnum);
	
	$lv_prcschtxt = $vew_doc->getTagValue($vew_data->hhrlqdatr001,'prcschtxt');	
	$lv_chratr = $vew_doc->getTagValue($vew_data->hhrlqdatr001,'chratr');
	$lv_sitrev = $vew_doc->getTagValue($lv_chratr,'sitrev');
	
	$pdf->text( 20, 40, $vew_data->chrasg->hhrchrtyptxt  );
	$pdf->text( 100, 40, ($lv_sitrev=='T'?'TITULAR':$lv_sitrev) );
	$pdf->text( 20, 44, 'Ingreso: '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'empstrdte') );
	$pdf->text( 60, 44, 'Alta Cargo: '.$vew_data->chrasg->hhrchrasgdtestr->format('d.m.Y') );
	$pdf->text( 100, 44, 'Baja Cargo: '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'chrenddte') );
	$pdf->text( 20, 48, 'Egreso: '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'empenddte') );
	$pdf->text( 60, 48, 'Antiguedad: '.$vew_doc->getTagValue($lv_chratr,'oldyth').'.'.$vew_doc->getTagValue($lv_chratr,'oldmth') );
	$pdf->text( 20, 52, 'Convenio: Dipregep....' );
	$pdf->setxy(110,52); $pdf->Cell( 30, 0, ucwords(strtolower($lv_prcschtxt)) , 0 , 0 , 'R' );

	$pdf->text( 1600, 40, $vew_data->chrasg->hhrchrtyptxt );
	$pdf->text( 240, 40, ($lv_sitrev=='T'?'TITULAR':$lv_sitrev)  );
	$pdf->text( 160, 44, 'Ingreso: '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'empstrdte') );
	$pdf->text( 200, 44, 'Alta Cargo: '.$vew_data->chrasg->hhrchrasgdtestr->format('d.m.Y') );
	$pdf->text( 240, 44, 'Baja Cargo: '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'chrenddte') );
	$pdf->text( 160, 48, 'Egreso: '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'empenddte') );
	$pdf->text( 200, 48, 'Antiguedad: '.$vew_doc->getTagValue($lv_chratr,'oldyth').'.'.$vew_doc->getTagValue($lv_chratr,'oldmth') );
	$pdf->text( 160, 52, 'Convenio: Dipregep.... ' );
	$pdf->setxy(250,52); $pdf->Cell( 30, 0, ucwords(strtolower($lv_prcschtxt)) , 0 , 0 , 'R' );

/*
persub
stdloccodext
var_dump($vew_data->hhrlqdatr001);
*/
	// Egreso: 	Antiguedad: (yy.mm)
	// Convenio: 	Dipregep...
	// CONCEPTOS		REMUN.	DESC	NO REMUN.
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->text( 40, 60, 'CONCEPTOS' );
	$pdf->setxy(80, 60); $pdf->Cell( 20, 0, 'REMUN.' , 0 , 0 , 'R' );
	$pdf->setxy(100,60); $pdf->Cell( 20, 0, 'DESC.' , 0 , 0 , 'R' );
	$pdf->setxy(120,60); $pdf->Cell( 20, 0, 'NO REMUN.' , 0 , 0 , 'R' );
	$pdf->line( 20,64,140,64);

	$pdf->text( 180,60, 'CONCEPTOS' );
	$pdf->setxy(220,60); $pdf->Cell( 20, 0, 'REMUN.' , 0 , 0 , 'R' );
	$pdf->setxy(240,60); $pdf->Cell( 20, 0, 'DESC.' , 0 , 0 , 'R' );
	$pdf->setxy(260,60); $pdf->Cell( 20, 0, 'NO REMUN.' , 0 , 0 , 'R' );
	$pdf->line( 160,64,280,64);


	$pdf->setfont('helvetica', '', 8);
	$lv_x = 65;
	$lv_col = 0;
	$lv_tot_rem = 0;
	$lv_tot_des = 0;
	$lv_tot_nre = 0;
	foreach($vew_data->txtprc as $lv_row){
		if($lv_row['prccndtxt']=='TOTAL REMUNERATIVO'){ $lv_col++; }
		if($lv_row['prccndtxt']=='TOTAL DESCUENTOS'){ $lv_col++; }
		if($lv_row['prccndtxt']=='TOTAL NO REMUNERATIVO'){ $lv_col++; }
		if($lv_row['prccndtot']==0 || $lv_row['prccndstd']!=''){ continue; }
		$lv_txt = htmlentities($lv_row['prccndtxt']);
		$lv_txt = str_ireplace('&igrave;','U',$lv_txt);
		$lv_txt = ucwords(strtolower($lv_txt));
		if($lv_row['prccndcodext']=='OOSS'){ $lv_txt.= ' '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'medcovcodext'); }
		if($lv_row['prccndcodext']=='ANTIGUEDAD'){ $lv_txt.= ' AA.MM '.$vew_doc->getTagValue($lv_chratr,'oldyth').'.'.$vew_doc->getTagValue($lv_chratr,'oldmth'); }
		if($lv_row['prccndcodext']=='SINDICATO'){ $lv_txt.= ' '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'medcovcodext'); }
		if($lv_row['prccndcodext']=='SINDICATO'){ $lv_txt.= ' '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'medcovcodext'); }
		$pdf->text( 20, $lv_x, $lv_txt );
		$pdf->text( 160, $lv_x, $lv_txt );
		$pdf->text( 70, $lv_x, number_format($lv_row['prccndqty'],2).' '.strtolower($lv_row['prccnduntcod']) );
		$pdf->text( 210, $lv_x, number_format($lv_row['prccndqty'],2).' '.strtolower($lv_row['prccnduntcod']) );
		if($lv_col==0){
			$lv_tot_rem+=$lv_row['prccndtot']; 
			$pdf->setxy( 80, $lv_x );
			$pdf->Cell( 20, 0, number_format($lv_row['prccndtot'],2) , 0 , 0 , 'R' );
			$pdf->setxy( 220, $lv_x );
			$pdf->Cell( 20, 0, number_format($lv_row['prccndtot'],2) , 0 , 0 , 'R' );
		} else if($lv_col==1){
			$lv_tot_des+=$lv_row['prccndtot']; 
			$pdf->setxy( 100, $lv_x ); 
			$pdf->Cell( 20, 0, number_format($lv_row['prccndtot'],2) , 0 , 0 , 'R' );
			$pdf->setxy( 240, $lv_x ); 
			$pdf->Cell( 20, 0, number_format($lv_row['prccndtot'],2) , 0 , 0 , 'R' );
		} else {
			$lv_tot_nre+=$lv_row['prccndtot'];
			$pdf->setxy( 120, $lv_x );
			$pdf->Cell( 20, 0, number_format($lv_row['prccndtot'],2) , 0 , 0 , 'R' );
			$pdf->setxy( 260, $lv_x );
			$pdf->Cell( 20, 0, number_format($lv_row['prccndtot'],2) , 0 , 0 , 'R' );
		}
		$lv_x += 5;
	}

	$lv_tot = $lv_tot_rem+$lv_tot_des+$lv_tot_nre;
	$pdf->setfont('helvetica', 'B', 9);
	$pdf->line( 20,150,140,150 );
	$pdf->text( 40, 153, 'SUBTOTALES' );
	$pdf->setxy( 80, 153 ); $pdf->Cell( 20, 0, number_format($lv_tot_rem,2) , 0 , 0 , 'R' );
	$pdf->setxy( 100, 153 ); $pdf->Cell( 20, 0, number_format($lv_tot_des,2) , 0 , 0 , 'R' );
	$pdf->setxy( 120, 153 ); $pdf->Cell( 20, 0, number_format($lv_tot_nre,2) , 0 , 0 , 'R' );
	$pdf->line( 20,160,140,160 );
	$pdf->text( 90, 163, 'TOTAL NETO' );
	$pdf->setxy( 120, 163 ); $pdf->Cell( 20, 0, number_format($lv_tot,2) , 0 , 0 , 'R' );
	$pdf->line( 90,170,140,170 );
	$pdf->text( 20, 163, 'LUGAR y FECHA DEP.APO.MES.ANT:' );
	$pdf->text( 20, 172, 'LUGAR y FECHA PAGO:' );
	
	$pdf->line( 160,150,280,150);
	$pdf->text( 180, 153, 'SUBTOTALES' );
	$pdf->setxy( 220, 153 ); $pdf->Cell( 20, 0, number_format($lv_tot_rem,2) , 0 , 0 , 'R' );
	$pdf->setxy( 240, 153 ); $pdf->Cell( 20, 0, number_format($lv_tot_des,2) , 0 , 0 , 'R' );
	$pdf->setxy( 260, 153 ); $pdf->Cell( 20, 0, number_format($lv_tot_nre,2) , 0 , 0 , 'R' );
	$pdf->line( 160,160,280,160);
	$pdf->text( 230, 163, 'TOTAL NETO' );
	$pdf->setxy( 260, 163 ); $pdf->Cell( 20, 0, number_format($lv_tot,2) , 0 , 0 , 'R' );
	$pdf->line( 230,170,280,170);

	$pdf->text( 160, 163, 'LUGAR y FECHA DEP.APO.MES.ANT:' );
	$pdf->text( 160, 172, 'LUGAR y FECHA PAGO:' );

	$lv_num = round( $lv_tot,2);

	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 20, 180, ucfirst(strtolower($vew_doc->numberToWords( $lv_num, '', 'CENTAVOS' ))) );
	$pdf->text( 20, 188, 'RECIBI CONFORME EN CONCEPTO:' );
	$pdf->text( 20, 191, 'DE MI REMUNERACION CORRESPONDIENTE' );
	$pdf->text( 20, 194, 'AL PERIODO ARRIBA INDICADO Y' );
	$pdf->text( 20, 197, 'DUPLICADO DE LA MISMA' );
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->line( 90,196,140,196);
	$pdf->text( 100, 197, 'FIRMA DEL EMPLEADO' );

	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 160, 180, ucfirst(strtolower($vew_doc->numberToWords( $lv_num, '', 'CENTAVOS' ))) );
	$pdf->text( 160, 188, 'RECIBI CONFORME EN CONCEPTO:' );
	$pdf->text( 160, 191, 'DE MI REMUNERACION CORRESPONDIENTE' );
	$pdf->text( 160, 194, 'AL PERIODO ARRIBA INDICADO Y' );
	$pdf->text( 160, 197, 'DUPLICADO DE LA MISMA' );
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->line( 230,196,280,196);
	$pdf->text( 232, 197, 'Firma del Empleador / Rep.Legal' );

	$pdf->Output('recibo.pdf', 'I');	
?>
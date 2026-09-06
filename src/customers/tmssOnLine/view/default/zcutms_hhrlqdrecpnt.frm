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
	$pdf->SetAutoPageBreak(TRUE, 1); //PDF_MARGIN_BOTTOM);

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
	
	$lv_meses = array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');

	// ---------------------------------------------------------
	$pdf->AddPage('L');
	
	// Encabezado
	//if($vew_data->bus->busimg!=''){$pdf->Image('@'.$vew_data->bus->busimg, 20,10,20);}
	$pdf->Image('library/images/logos/zcutms_temasisargentina2.jpg',20,10,20);	
	$pdf->setfont('helvetica', 'B', 10);
	$pdf->text( 45, 10, $vew_data->bus->bustxt);
	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 45, 15, $vew_data->bus->adr->adrstr.($vew_data->bus->adr->adrstrnum!=''?' '.$vew_data->bus->adr->adrstrnum:'').($vew_data->bus->adr->adrstrflr!=''?' Pso.'.$vew_data->bus->adr->adrstrflr:'').' Dto.'.$vew_data->bus->adr->adrstrunt);
	$pdf->text( 45, 20, ucwords(strtolower($vew_data->bus->adr->lndregtxt)));
	$pdf->text( 45, 25, $vew_data->bus->tax->taxcattxt);
	$pdf->text( 45, 30, $vew_data->bus->tax->idttyptxt.': '.substr($vew_data->bus->tax->taxcod,0,2).'-'.substr($vew_data->bus->tax->taxcod,2,8).'-'.substr($vew_data->bus->tax->taxcod,10,1) );

	//if($vew_data->bus->busimg!=''){$pdf->Image('@'.$vew_data->bus->busimg, 160,10,20);}
	$pdf->Image('library/images/logos/zcutms_temasisargentina2.jpg',160,10,20);	
	$pdf->setfont('helvetica', 'B', 10);
	$pdf->text( 185, 10, $vew_data->bus->bustxt);
	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 185, 15, $vew_data->bus->adr->adrstr.($vew_data->bus->adr->adrstrnum!=''?' '.$vew_data->bus->adr->adrstrnum:'').($vew_data->bus->adr->adrstrflr!=''?' Pso.'.$vew_data->bus->adr->adrstrflr:'').' Dto.'.$vew_data->bus->adr->adrstrunt);
	$pdf->text( 185, 20, ucwords(strtolower($vew_data->bus->adr->lndregtxt)));
	$pdf->text( 185, 25, ucwords(strtolower($vew_data->bus->tax->taxcattxt)));
	$pdf->text( 185, 30, $vew_data->bus->tax->idttyptxt.': '.substr($vew_data->bus->tax->taxcod,0,2).'-'.substr($vew_data->bus->tax->taxcod,2,8).'-'.substr($vew_data->bus->tax->taxcod,10,1) );

	$pdf->setfont('helvetica', 'B', 12);
	$pdf->text( 105, 10, 'RECIBO N° '.$vew_data->hhrlqdcod );
	$pdf->text( 245, 10, 'RECIBO N° '.$vew_data->hhrlqdcod );
	
	$pdf->setfont('helvetica', 'B', 10);
	$pdf->text( 105, 25, 'PERIODO DE PAGO' );
	$pdf->text( 245, 25, 'PERIODO DE PAGO' );
	
	$pdf->setfont('helvetica', '', 10);
	$pdf->text( 105, 30, $lv_meses[ intval($vew_data->hhrlqdstrdte->format('m'))-1 ].' de '.$vew_data->hhrlqdstrdte->format('Y') );
	$pdf->text( 245, 30, $lv_meses[ intval($vew_data->hhrlqdstrdte->format('m'))-1 ].' de '.$vew_data->hhrlqdstrdte->format('Y') );
	
	$lv_chratr = $vew_doc->getTagValue($vew_data->hhrlqdatr001,'chratr');
	
	$pdf->line( 20,37,140,37);	
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->text( 20, 40, utf8_encode($vew_doc->getTagValue($vew_data->hhrlqdatr001,'srcobjtxt')) );
	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 20, 45, $vew_data->chrasg->hhrchrtyptxt  );
	$pdf->text( 20, 49, 'Ingreso: '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'empstrdte') );
	$pdf->text( 20, 53, 'Egreso: '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'empenddte') );
	$pdf->text( 60, 49, 'Alta Cargo: '.$vew_data->chrasg->hhrchrasgdtestr->format('d.m.Y') );
	$pdf->text( 60, 53,'Baja Cargo: '. ($vew_data->chrasg->hhrchrasgdteend instanceof DateTime ? $vew_data->chrasg->hhrchrasgdteend->format('d.m.Y'): '') );
	$pdf->text( 100, 40, $vew_data->emp->tax->idttyptxt.': '.$vew_data->emp->tax->taxdocnum);
	$pdf->text( 100, 45, 'Legajo: '.$vew_data->srcobjcod001);
	$pdf->text( 100, 49, 'Antiguedad: '.$vew_doc->getTagValue($lv_chratr,'oldyth').'.'.$vew_doc->getTagValue($lv_chratr,'oldmth') );
	$pdf->line( 20,59,140,59);	

	$pdf->line( 160,37,280,37);	
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->text( 160, 40, utf8_encode($vew_doc->getTagValue($vew_data->hhrlqdatr001,'srcobjtxt')) );
	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 160, 45, $vew_data->chrasg->hhrchrtyptxt );
	$pdf->text( 160, 49, 'Ingreso: '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'empstrdte') );
	$pdf->text( 160, 53, 'Egreso: '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'empenddte') );
	$pdf->text( 200, 49, 'Alta Cargo: '.$vew_data->chrasg->hhrchrasgdtestr->format('d.m.Y') );
	$pdf->text( 200, 53, 'Baja Cargo: '.($vew_data->chrasg->hhrchrasgdteend instanceof DateTime ? $vew_data->chrasg->hhrchrasgdteend->format('d.m.Y'): '') );
	$pdf->text( 240, 40, $vew_data->emp->tax->idttyptxt.': '.$vew_data->emp->tax->taxdocnum);
	$pdf->text( 240, 45, 'Legajo: '.$vew_data->srcobjcod001);
	$pdf->text( 240, 49, 'Antiguedad: '.$vew_doc->getTagValue($lv_chratr,'oldyth').'.'.$vew_doc->getTagValue($lv_chratr,'oldmth') );
	$pdf->line( 160,59,280,59);	

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
		if($lv_row['prccndcatcodext']=='REM'){ $lv_col=1; }
		if($lv_row['prccndcatcodext']=='DESC'){ $lv_col=2; }
		if($lv_row['prccndcatcodext']=='NREM'){ $lv_col=3; }
		if($lv_row['prccndtot']==0 || $lv_row['prccndstd']!=''){ continue; }
		$lv_txt = htmlentities($lv_row['prccndtxt']);
		$lv_txt = str_ireplace('&igrave;','U',$lv_txt);
		$lv_txt = ucwords(strtolower($lv_txt));
		if($lv_row['prccndcodext']=='OOSS'){ $lv_txt.= ' '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'medcovcodext'); }
		$pdf->text( 20, $lv_x, $lv_txt );
		$pdf->text( 160, $lv_x, $lv_txt );
		if($lv_row['prccndqty']!=0){
			$pdf->text( 70, $lv_x, number_format($lv_row['prccndqty'],2).' '.strtolower($lv_row['prccnduntcod']) );
			$pdf->text( 210, $lv_x, number_format($lv_row['prccndqty'],2).' '.strtolower($lv_row['prccnduntcod']) );
		}
		if($lv_col==1){
			$lv_tot_rem+=$lv_row['prccndtot']; 
			$pdf->setxy( 80, $lv_x );
			$pdf->Cell( 20, 0, number_format($lv_row['prccndtot'],2) , 0 , 0 , 'R' );
			$pdf->setxy( 220, $lv_x );
			$pdf->Cell( 20, 0, number_format($lv_row['prccndtot'],2) , 0 , 0 , 'R' );
		} else if($lv_col==2){
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


	// LEYENDA para RECIBO
	foreach($vew_data->grltxt as $lv_row){
		if( $lv_row['txttypcodext']=='HHRLEYREC'){
			$pdf->writeHTMLcell( 100,20, 160,140, utf8_decode(html_entity_decode($lv_row['txttxt'])) );
			$pdf->writeHTMLcell( 100,20, 20,140, utf8_decode(html_entity_decode($lv_row['txttxt'])) );
		}
	}
	foreach($vew_data->grltxt2 as $lv_row){
		if( $lv_row['txttypcodext']=='HHRLEYREC'){
			$pdf->writeHTMLcell( 80,20, 160,145, utf8_decode(html_entity_decode($lv_row['txttxt'])) );
			$pdf->writeHTMLcell( 80,20, 20,145, utf8_decode(html_entity_decode($lv_row['txttxt'])) );
		}
	}


	$lv_tot = $lv_tot_rem-$lv_tot_des+$lv_tot_nre;
	$pdf->line( 20,150,140,150 );
	$pdf->setfont('helvetica', 'B', 9);
	$pdf->text( 40, 153, 'SUBTOTALES' );
	$pdf->setxy( 80, 153 ); $pdf->Cell( 20, 0, number_format($lv_tot_rem,2) , 0 , 0 , 'R' );
	$pdf->setxy( 100, 153 ); $pdf->Cell( 20, 0, number_format($lv_tot_des,2) , 0 , 0 , 'R' );
	$pdf->setxy( 120, 153 ); $pdf->Cell( 20, 0, number_format($lv_tot_nre,2) , 0 , 0 , 'R' );
	$pdf->line( 20,160,140,160 );
	$pdf->text( 90, 163, 'TOTAL NETO' );
	$pdf->setxy( 120, 163 ); $pdf->Cell( 20, 0, number_format($lv_tot,2) , 0 , 0 , 'R' );
	$pdf->line( 90,170,140,170 );
	$pdf->text( 20, 163, 'LUGAR y FECHA PAGO:' );
	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 20, 168, $vew_data->emp->bnk->bnktxt );
	
	$pdf->line( 160,150,280,150);
	$pdf->setfont('helvetica', 'B', 9);
	$pdf->text( 180, 153, 'SUBTOTALES' );
	$pdf->setxy( 220, 153 ); $pdf->Cell( 20, 0, number_format($lv_tot_rem,2) , 0 , 0 , 'R' );
	$pdf->setxy( 240, 153 ); $pdf->Cell( 20, 0, number_format($lv_tot_des,2) , 0 , 0 , 'R' );
	$pdf->setxy( 260, 153 ); $pdf->Cell( 20, 0, number_format($lv_tot_nre,2) , 0 , 0 , 'R' );
	$pdf->line( 160,160,280,160);
	$pdf->text( 230, 163, 'TOTAL NETO' );
	$pdf->setxy( 260, 163 ); $pdf->Cell( 20, 0, number_format($lv_tot,2) , 0 , 0 , 'R' );
	$pdf->line( 230,170,280,170);
	$pdf->text( 160, 163, 'LUGAR y FECHA PAGO:' );
	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 160, 168, $vew_data->emp->bnk->bnktxt );
	
	$lv_num = round( $lv_tot,2);

	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 20, 173, ucfirst(strtolower($vew_doc->numberToWords( $lv_num, '', 'CENTAVOS' ))) );
	$pdf->text( 20, 188, 'RECIBI CONFORME EN CONCEPTO:' );
	$pdf->text( 20, 191, 'DE MI REMUNERACION CORRESPONDIENTE' );
	$pdf->text( 20, 194, 'AL PERIODO ARRIBA INDICADO Y' );
	$pdf->text( 20, 197, 'DUPLICADO DE LA MISMA' );
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->line( 90,196,140,196);
	$pdf->text( 100, 197, 'FIRMA DEL EMPLEADO' );

	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 160, 173, ucfirst(strtolower($vew_doc->numberToWords( $lv_num, '', 'CENTAVOS' ))) );
	$pdf->text( 160, 188, 'RECIBI CONFORME EN CONCEPTO:' );
	$pdf->text( 160, 191, 'DE MI REMUNERACION CORRESPONDIENTE' );
	$pdf->text( 160, 194, 'AL PERIODO ARRIBA INDICADO Y' );
	$pdf->text( 160, 197, 'DUPLICADO DE LA MISMA' );
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->line( 230,196,280,196);
	$pdf->text( 232, 197, 'Firma del Empleador / Rep.Legal' );

	$pdf->Output('recibo.pdf', 'I');	
?>
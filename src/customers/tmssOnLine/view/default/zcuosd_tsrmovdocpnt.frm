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
	
	// armo tabla de valores
	$lv_values_tot = 0;
	$lv_values =  '<table cellpadding="3"><thead><tr style="font-weight:bold;"><th width="240">Concepto</th><th width="20"></th><th width="110" align="center">Importe</th></tr></thead>';
	$lv_values.= '<tbody>';
	foreach($vew_data->tsrmovdocval as $lv_row){
		$lv_txt = $vew_data->tsrmovdoctxt.($vew_data->tsrpatmthtyp=='CHQ'?'':'');
		$lv_values.= '<tr><td width="240">'.$lv_txt.'</td><td width="20" align="right">'.($lv_row['curcod']=='ARS'?'$':$lv_row['curcod']).'</td><td width="110" align="right">'.number_format($lv_row['tsrmovdocvalamt'],2,',','.').'</td></tr>';
		$lv_values_tot += $lv_row['tsrmovdocvalamt'];
	}
	$lv_values.= '<tr style="background-color:#f1f1f1; font-weight:bold; font-size:14px;"><td width="240" align="right">TOTAL</td><td width="20" align="right">'.($vew_data->curcod=='ARS'?'$':$vew_data->curcod).'</td><td width="110" align="right">'.number_format($lv_values_tot,2,',','.').'</td></tr>';
	$lv_values.= '</tbody></table>';	

	// armo codigo de barras
	$lv_bar_style = array(
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
	$lv_depcod = (count($vew_int)>0?$vew_doc->gettagvalue($vew_int[0]['sysintatr'],$vew_data->srcobjtyp.'_'.$vew_data->srcobjcod):0);;
	$lv_barcod= '0330'.
							str_pad($vew_data->tsrmovdoccod,6,'0',STR_PAD_LEFT).
							$vew_data->tsrmovdocdte->format('mY').
							str_pad( $lv_depcod, 5, '0', STR_PAD_LEFT).
							str_pad( $lv_values_tot*100,10,'0',STR_PAD_LEFT);
	$lv_barcod.=mod10($lv_barcod);		


	// BOLETA 1 ---------------------------------------------------------------
	
	//-- recuadro general
	$pdf->line(5,  5, 200,5 );	// -
	$pdf->line(5,  5, 5,  87);	// |
	$pdf->line(200,5, 200,87);	// |
	$pdf->line(5,  87,200,87);	// -
	
	// emisor
	$pdf->setfont( 'helvetica','', 9);
	$pdf->text( 10, 7, $vew_bus->bustxt );
	$pdf->text( 10, 12, $vew_bus->adr->adrstr.' '.$vew_bus->adr->adrstrnum.($vew_bus->adr->adrstrflr!=''?' p.'.$vew_bus->adr->adrstrflr:'') );
	$pdf->text( 10, 17, '('. $vew_bus->adr->adrpstcod . ') - ' . $vew_bus->adr->lndregtxt );

	// titulo
	$pdf->line( 105,5,105,25); // |
	$pdf->setfont( 'helvetica','B',11 );
	$pdf->setxy(125, 7); $pdf->cell(60, 7,'BOLETA DE DEPOSITO',0,false,'C' );
	$pdf->setxy(125,12); $pdf->cell(60, 7, 'Nº '. str_pad($vew_data->tsrmovdoccod,6,'0',STR_PAD_LEFT), 0, false, 'C' );
	$pdf->setfont( 'helvetica','', 10 );
	$pdf->setxy(125,17); $pdf->cell(60, 7, $vew_data->tsrmovdocdte->format('m/Y'), 0, false, 'C' );

	// depositante
	$pdf->line( 5,25,200,25);	 // -
	$pdf->setfont( 'helvetica','B', 9 );
	$pdf->text( 10, 27, $vew_data->srcobjtxt );
	$pdf->setfont( 'helvetica','', 9 );
	$pdf->text( 10, 32, $vew_data->adrstr.' '.$vew_data->adrstrnum.($vew_data->adrstrflr!=''?' p.'.$vew_data->adrstrflr:'') );
	$pdf->text( 10, 37, '('. $vew_data->adrpstcod . ') - ' . $vew_data->lndregtxt );
	if($vew_data->taxcod!=''){$pdf->text( 10, 43, 'C.U.I.T. : '. $vew_data->taxcod );}
	
	// valores
	$pdf->setfont( 'helvetica','',10 );
	$pdf->setxy( 90, 27 );
	$pdf->writehtml( $lv_values );
	
	// importe en letras
	$pdf->setFont( 'helvetica','',9);
	$pdf->text(10,72, 'Son Pesos: '.ucfirst(strtolower($vew_doc->numberToWords( $lv_values_tot, '', 'CENTAVOS' ))) );

	// codigo de barras
	//$pdf->write1DBarcode($lv_barcod, 'I25', 130, 65, '', 12, 0.53, $lv_bar_style, 'N');
	$pdf->write1DBarcode($lv_barcod, 'C128', 130, 65, '', 12, 0.53, $lv_bar_style, 'N');

	$pdf->setfont('helvetica','',8);
	$pdf->setxy( 160, 80); $pdf->cell( 40, 10, 'Talon para el DEPOSITANTE' );

	$pdf->setfont( 'helvetica','',6);
	$pdf->setxy( 185, 85); $pdf->cell( 40, 10, 'Corte Aquí');
	
	
	
	// BOLETA 2 ---------------------------------------------------------------
	
	$pdf->line( 5,92,200,92);			// -
	$pdf->line( 5,92,5,180);			// |
	$pdf->line( 200,92,200,180);	// |
	$pdf->line( 5,180,200,180);		// _
	
	// emisor
	$pdf->setfont( 'helvetica','', 9);
	$pdf->text( 10, 94, $vew_bus->bustxt );
	$pdf->text( 10, 99, $vew_bus->adr->adrstr.' '.$vew_bus->adr->adrstrnum.($vew_bus->adr->adrstrflr!=''?' p.'.$vew_bus->adr->adrstrflr:'') );
	$pdf->text( 10, 104, '('. $vew_bus->adr->adrpstcod . ') - ' . $vew_bus->adr->lndregtxt );
	
	// titulo
	$pdf->line( 105,92,105,112);	// |		
	$pdf->setfont( 'helvetica','B',11 );
	$pdf->setxy(125, 94); $pdf->cell(60, 7,'BOLETA DE DEPOSITO',0,false,'C' );
	$pdf->setxy(125, 99); $pdf->cell(60, 7, 'Nº '. str_pad($vew_data->tsrmovdoccod,6,'0',STR_PAD_LEFT), 0, false, 'C' );
	$pdf->setfont( 'helvetica','', 10 );
	$pdf->setxy(125,104); $pdf->cell(60, 7, $vew_data->tsrmovdocdte->format('m/Y'), 0, false, 'C' );
	
	// depositante
	$pdf->line( 5,112,200,112);		// -
	$pdf->setfont( 'helvetica','B', 9 );
	$pdf->text( 10, 114, $vew_data->srcobjtxt );
	$pdf->setfont( 'helvetica','', 9 );
	$pdf->text( 10, 119, $vew_data->adrstr.' '.$vew_data->adrstrnum.($vew_data->adrstrflr!=''?' p.'.$vew_data->adrstrflr:'') );
	$pdf->text( 10, 124, '('. $vew_data->adrpstcod . ') - ' . $vew_data->lndregtxt );
	if($vew_data->taxcod!=''){$pdf->text( 10, 130, 'C.U.I.T. : '. $vew_data->taxcod );}

	// valores
	$pdf->setxy( 90, 114 );
	$pdf->writehtml( $lv_values );

	// importe en letras
	$pdf->setfont( 'helvetica','',9 );
	$pdf->text(10,162, 'Son Pesos: '.ucfirst(strtolower($vew_doc->numberToWords( $lv_values_tot, '', 'CENTAVOS' ))) );

	// codigo de barras
	$pdf->write1DBarcode($lv_barcod, 'C128', 130, 160, '', 12, 0.53, $lv_bar_style, 'N');		

	$pdf->setfont( 'helvetica','',8 );
	$pdf->setxy( 170, 173); $pdf->cell( 40, 10, 'Talon para el BANCO');

	
	function mod10($docnum){
		$M10OnlyCorrectData = '';
		$M10StringLength = strlen($docnum);
		//Check to make sure data is numeric and remove dashes, etc.
		for($M10I=0; $M10I<$M10StringLength; $M10I++){
			//Add all numbers to OnlyCorrectData string
			//2006.2 BDA modified the next 2 lines for compatibility with different office versions
			$CurrentCharNum = ord(substr($docnum, $M10I, 1));
			if ( $CurrentCharNum > 47 && $CurrentCharNum < 58 ) {
				$M10OnlyCorrectData .= substr($docnum, $M10I, 1);
			}
    }
		// Generate MOD 10 check digit
    $M10Factor = 3;
    $M10WeightedTotal = 0;
    $M10StringLength = strlen($docnum);
    for( $M10I=$M10StringLength-1; $M10I>0; $M10I-- ){
			//Get the value of each number starting at the end
			//CurrentCharNum = Mid(docnum, I, 1)
			//Multiply by the weighting factor which is 3,1,3,1...
			//and add the sum together
      $M10WeightedTotal += (intval(substr($docnum, $M10I, 1)) * $M10Factor);
      //Change factor for next calculation
      $M10Factor = 4 - $M10Factor;
    }
    //Find the CheckDigit by finding the smallest number that = a multiple of 10
    $M10I = ($M10WeightedTotal % 10);
		return strval( $M10I!=0 ? 10-$M10I : 0 );
	}
	
	
	// OUTPUT
	$pdf->Output($vew_bus->bustxt.' - BoletaDeposito Nro '.$vew_data->tsrmovdoccod.' - '.$vew_data->tsrmovdocdte->format('Ym').'.pdf', 'I');	
?>
<?php
	// --------------------------------------------------------------------------
	// ORDEN MEDICA PARA APLICACION
	// Formulario para ROCHE - MEDICOS
	// --------------------------------------------------------------------------
	
	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');
	
	// Extend the TCPDF class to create custom Footer
	class RCHTCPDF extends TCPDF {
		// Page footer
		public function Footer() {
			// Position at 15 mm from bottom
			// Set font
			$this->SetFont('helvetica', '', 8);
			$this->text(80, -12, 'Team Infusion es un departamento de LSDM S.A.');
			$this->text(85, -8, 'Rivera 26 - Villa Adelina - Tel.: 5245-3404.');
		}
}
	// create new PDF document
	$pdf = new RCHTCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'ISO-8859-1', false);

	// remove default header/footer
	$pdf->setPrintHeader(false);

	// set default monospaced font
	$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

	// set margins
	$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);

	// set auto page breaks
	$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

	
	// add a page
	$pdf->AddPage('P');

	// styles
	$head_line_style =  array('width' => 0.5, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0));
	$line_style = array('width' => 0.2, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0));
	$block_style = array('B');
	
	
	// ENCABEZADO
	$pdf->setfont('helvetica','b', 14);
	$pdf->setTextColor(150, 20, 20);
	$pdf->text(10, 8, 'INDICACIÓN MÉDICA PARA PRESTACIÓN DOMICILIARIA');
	$pdf->Line(0, 15, 146, 15, $head_line_style);
	$pdf->Line(5, 0, 5, 300, $line_style);
	$pdf->Rect(0, 0, 4.7, 14.7, 'DF', $block_style, array(220, 220, 200));
	$pdf->Image('/library/images/logos/zcutp1_logoTeamInfusionAR.jpg', 165, 8, 42, 36, '', '', 'T', false, 300, '', false, false, 0, false, false, false);
	
	
	// CUERPO
	$pdf->setfont('helvetica', '', 11);
	$pdf->setTextColor(0, 0, 0);
	$pdf->text( 20, 38,'FECHA ' );
	$pdf->text( 20, 58,'PACIENTE:');
	$pdf->text( 20, 68,'FECHA DE NACIMIENTO:'); 
	$pdf->text( 110, 68,'PESO:');
	$pdf->text(170, 68,'Kg.');
	$pdf->text( 20, 78,'DNI:' );
	$pdf->text( 20, 88, 'DOMICILIO:' );
	$pdf->text(20, 98, 'LOCALIDAD:');
	$pdf->text(20, 108, 'TELEFONO PART.:');
	$pdf->text(120, 108, 'CELULAR:');
	$pdf->text(20, 118, 'COBERTURA MÉDICA:'); 
	$pdf->text(130, 118, 'N°:');
	$pdf->text(20, 131, 'MÉDICO TRATANTE:');
	$pdf->text(20, 140, 'TELÉFONO:');
	$pdf->text(20, 153, 'INDICACIÓN:');
	$pdf->text(20, 163, 'DROGA:'); 
	$pdf->text(95, 163, 'CANT. DE VIALES:');
	$pdf->text(20, 173, 'NOMBRE COMERCIAL');
	$pdf->text(20, 183, 'DOSIS INDICADA:');
	$pdf->text(20, 193, 'FRECUENCIA (DÍAS):');
	$pdf->text(20, 203, 'MODO DE ADMINISTRACIÓN:');
	$pdf->text(20, 213, 'DILUCION:');
	$pdf->text(20, 223, 'TIEMPO DE ADMINISTRACIÓN:');
	
	$lv_premed = '';
	if( ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgpardss') == '') && ($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgparfrq') == 0) ) && 
			( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgdifdss') == '') && ($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgdiffrq') == 0) ) && 
			( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr001') == '') && ($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr001dss') == 0) && ($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr001frq') == 0) ) && 
			( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr002') == '') && ($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr002dss') == 0) && ($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr002frq') == 0) ) ) {
					$lv_premed = 'NO';
		} else {
			$lv_premed = 'SI';
	};
	$pdf->text(20, 238, 'PREMEDICACION:'); 
	
	
	// DATOS
	$pdf->setfont('helvetica', 'B', 11);
	$pdf->text( 45, 38, date_format($vew_data->evl->evldte, 'd / m / Y') );
	$pdf->text( 45, 58, $vew_data->pat->pattxt );
	$pdf->text( 70, 68, ( ($vew_data->pat->per->perbrndte != null )?(date_format($vew_data->pat->per->perbrndte, 'd/m/Y')):' - ' ) ); 
	$pdf->text(145, 68, ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'patwgt') == '')? '-' : $vew_doc->getTagValue($vew_data->evl->evlatr001,'patwgt') )); 
	$pdf->text( 30, 78, (($vew_data->pat->tax->taxcod == '')?'-':$vew_data->pat->tax->taxcod) );
	$pdf->text( 45, 88, (($vew_data->pat->adr->adrstr == '')?'-':$vew_data->pat->adr->adrstr).'			'
											.(($vew_data->pat->adr->adrstrnum == '')?'-':$vew_data->pat->adr->adrstrnum).'			'
											.(($vew_data->pat->adr->adrstrflr == '')?'-':$vew_data->pat->adr->adrstrflr.'°')
											.(($vew_data->pat->adr->adrstrunt == '')?'':$vew_data->pat->adr->adrstrunt).
											'			Edificio:	'.(($vew_data->pat->adr->adrstrbld == '')?'-':$vew_data->pat->adr->adrstrbld) );
	$pdf->text(45, 98, ( ($vew_data->pat->adr->adrtwntxt == '')?'-':$vew_data->pat->adr->adrtwntxt) );
	$pdf->text(55, 108, ( ($vew_data->pat->adr->adrphn001 != '' && $vew_data->pat->adr->adrphn002 != '') ? $vew_data->pat->adr->adrphn001.'		/		'.$vew_data->pat->adr->adrphn002 : (($vew_data->pat->adr->adrphn001 == '')?( ($vew_data->pat->adr->adrphn002 == '')?'-':$vew_data->pat->adr->adrphn002 ) : $vew_data->pat->adr->adrphn001) ) );
	$pdf->text(140, 108, ( ($vew_data->pat->adr->adrmblphn == '')?'-':$vew_data->pat->adr->adrmblphn) );
	$pdf->text(65, 118, (($vew_data->pat->per->hhrmedcovtxt == '')?'-':$vew_data->pat->per->hhrmedcovtxt).'	-	'.(($vew_data->pat->per->hhrmedcovaflpln == '')?'-':$vew_data->pat->per->hhrmedcovaflpln) ); 
	$pdf->text(140, 118, ( ($vew_data->pat->per->hhrmedcovaflnum == '')?'-':$vew_data->pat->per->hhrmedcovaflnum) );
	
	$pdf->text(60, 131, $vew_data->prs->prstxt);
	$pdf->text(45, 140, ( ($vew_data->prs->adr->adrphn001 != '' && $vew_data->prs->adr->adrphn002 != '') ? $vew_data->prs->adr->adrphn001.'		/		'.$vew_data->prs->adr->adrphn002 : (($vew_data->prs->adr->adrphn001 == '')?( ($vew_data->prs->adr->adrphn002 == '')?'-':$vew_data->prs->adr->adrphn002 ) : $vew_data->prs->adr->adrphn001) ));
	
	$pdf->text(50, 153, strtoupper(($vew_doc->getTagValue($vew_data->evl->evlatr001,'hltdisclstxt')=='')?'-':$vew_doc->getTagValue($vew_data->evl->evlatr001,'hltdisclstxt')) );
	
	$pdf->text(40, 163, strToUpper(($vew_doc->getTagValue($vew_data->evl->evlatr001,'drg')=='')?'-':$vew_doc->getTagValue($vew_data->evl->evlatr001,'drg'))); 
	$pdf->text(130, 163, strToUpper(($vew_doc->getTagValue($vew_data->evl->evlatr001,'cntv')=='')?'-':$vew_doc->getTagValue($vew_data->evl->evlatr001,'cntv')));
	$pdf->text(65, 173, strToUpper($vew_doc->getTagValue($vew_data->evl->evlatr001,'mattxt')) );
	$pdf->text(55, 183, strToUpper($vew_doc->getTagValue($vew_data->evl->evlatr001,'dos')) );
	$pdf->text(60, 193, strToUpper(($vew_doc->getTagValue($vew_data->evl->evlatr001,'fre')=='')?'-':$vew_doc->getTagValue($vew_data->evl->evlatr001,'fre')) );
	$pdf->text(75, 203, strToUpper(($vew_doc->getTagValue($vew_data->evl->evlatr001,'madm')=='')?'-':$vew_doc->getTagValue($vew_data->evl->evlatr001,'madm')));
	$pdf->text(40, 213, strToUpper(($vew_doc->getTagValue($vew_data->evl->evlatr001,'dil')=='')?'-':$vew_doc->getTagValue($vew_data->evl->evlatr001,'dil')));
	$pdf->text(80, 223, strToUpper(($vew_doc->getTagValue($vew_data->evl->evlatr001,'tadm')=='')?'-':$vew_doc->getTagValue($vew_data->evl->evlatr001,'tadm')));
	$pdf->text(55, 238, $lv_premed);
	
	
	// PREMEDICACION
	// etiquetas
	$pdf->setfont('helvetica', '', 10);
	$lv_premedinfotxt = '';
	$lv_premedinfodat = '';
	if($lv_premed == 'SI'){
		$lv_premedinfotxt =	$pdf->text(135, 224, 'Paracetamol:').
												$pdf->text(135, 229, 'Difenhidranima:').
												$pdf->text(135, 234, ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr001') != '')?$vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr001').':':'') ).
												$pdf->text(135, 239, ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr002') != '')?$vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr002').':':'') );
	}
	$pdf->text(105, 223, $lv_premedinfotxt);
	// datos
	$pdf->setfont('helvetica', 'B', 10);
	if($lv_premed == 'SI'){
		$lv_premedinfodat =	$pdf->text(165, 224, (($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgpardss')=='')?'':$vew_doc->getTagValue($vew_data->evl->evlatr001,'drgpardss').' mg')).
												$pdf->text(165, 229, (($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgdifdss')=='')?'':$vew_doc->getTagValue($vew_data->evl->evlatr001,'drgdifdss').' mg')).
												$pdf->text(165, 234, (($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr001dss')=='')?'':$vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr001dss').' mg')).
												$pdf->text(165, 239, (($vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr002dss')=='')?'':$vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr002dss').' mg'));
	}
	$pdf->text(105, 223, $lv_premedinfodat);
	
	
	$pdf->text(30, 263, '.....................................................');
	$pdf->text(110, 263, '.....................................................................');
	$pdf->setfont('helvetica', '', 11);
	$pdf->text(44, 267, 'Fecha y Hora');
	$pdf->text(117, 267, 'Firma y Sello Medico Tratante');
	
	
	// **************************************************************************
	// FIRMA ELECTRONICA. verifico si se requiere firmar el documento
	// 
	// **************************************************************************
	if( count($vew_data->sgndat)>0 ){
		// info adicional
		$lv_dat = array('Name'=>$vew_data->sgndat['usrtxt'],
										'Date'=>$vew_data->sgndat['sgndte'],
										'ID'=>$vew_data->sgndat['sgncod']
										);
		$lv_crt = 'file://'.realpath($vew_data->sgndat['crtsgnfle']);
		$lv_key = 'file://'.$vew_data->sgndat['crtkeyfle'];
		$lv_pwd = $vew_data->sgndat['crtpwdstr'];
		$lv_img = $vew_data->sgndat['crtimgfle'];
		
		// firma de documento
		$pdf->setSignature($lv_crt, $lv_key, $lv_pwd, '', 2, $lv_dat);

		// escribo info de la firma (firmante y fecha/hora)
		$pdf->writeHTMLCell(169,'',130,260,'<b>'.strtoupper($vew_data->sgndat['usrtxt']).'</b>');
		$pdf->writeHTMLCell(169,'',40,260,'<b>'.$vew_data->sgndat['sgndte']->format('d/m/Y H:i').'</b>');

		// create content for signature (image and/or text)
	 	$pdf->Image($lv_img, 112, 250, 20, 20, 'PNG');

		// define active area for signature appearance
		$pdf->setSignatureAppearance(112, 250, 15, 15);
		
		// *** set an empty signature appearance *** ==> SOLO PARA FIRMAS ADICIONALES (con acrobat reader)
		// $pdf->addEmptySignatureAppearance(180, 80, 15, 15);
	} else {
		// $pdf->RoundedRect(112, 250, 15, 15, 0, '1000');
		// $pdf->writeHTMLCell(169,'',130,260,'<b>FIRMANTE</b>');
		// $pdf->writeHTMLCell(169,'',40,260,'<b>FECHA/HORA</b>');
	}
	// **************************************************************************
	
	
	// PIE
	$pdf->Rect(0, 282, 4.7, 14.7, 'DF', $block_style, array(220, 220, 200));
	$pdf->Line(0, 282, 210, 282, $line_style);
	
	
	// Close and output PDF document
	$pdf->Output('OrdenMedicaParaInfusion'.$vew_data->evl->evlcod.'.pdf', 'I');
?>	
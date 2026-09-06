<?php
	// --------------------------------------------------------------------------
	// HISTORIA CLINICA
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
	$pdf = new RCHTCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);

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
	$pdf->text(10, 8, 'HISTORIA CLINICA');
	$pdf->Line(0, 15, 126, 15, $head_line_style);
	$pdf->Line(5, 0, 5, 300, $line_style);
	$pdf->Rect(0, 0, 4.7, 14.7, 'DF', $block_style, array(220, 220, 200));
	$pdf->Image('/library/images/logos/zcutp1_logoTeamInfusionAR.jpg', 165, 8, 42, 36, '', '', 'T', false, 300, '', false, false, 0, false, false, false);

	// CUERPO
	$pdf->setfont('helvetica', '', 11);
	$pdf->setTextColor(0, 0, 0);
	$pdf->text( 20, 38,'FECHA ' );
	$pdf->text( 20, 48,'PACIENTE:');
	$pdf->text( 130, 48,'DNI:' );
	$pdf->text(20, 58, 'INSTITUTO DE REFERENCIA:');
	$pdf->text(20, 68, 'DIAGNOSTICO:');
	$pdf->text(20, 78, 'MEDICACIÓN CRÓNICA DEL PACIENTE:');
	$lv_antcli =$pdf->text(25, 98, '1. HTA (Hipertension Arterial):').
							$pdf->text(25, 108, '2. CARDIOPATIA ISQUEMICA:').
							$pdf->text(25, 118, '3. SOBREPESO:').
							$pdf->text(25, 128, '4. EPOC (Enfermedad Pulmonar Obstructiva Crónica):').
							$pdf->text(25, 138, '5. IRC (Insuficiencia Renal Crónica):').
							$pdf->text(25, 148, '6. EPILEPSIA:').
							$pdf->text(130, 98, '7. ICC (Insuficiencia Cardiaca):').
							$pdf->text(130, 108, '8. ARRITMIAS:').
							$pdf->text(130, 118, '9. ASMA:').
							$pdf->text(130, 128, '10. TBQ (Tabaquismo):').
							$pdf->text(130, 138, '11. ACV (Accidente Cerebrovascular):').
							$pdf->text(130, 148, '12. ALERGIAS:');

	$pdf->text(20, 88, 'ANTECEDENTES CLINICOS:'.$lv_antcli);
	$pdf->text(20, 158, 'DETALLES:');

	//Datos
	$pdf->setFont('helvetica', 'B', 11);
	$pdf->text(50, 38,$vew_data->evl->evldte->format('d/m/Y'));
	$pdf->text(50, 48,strtoupper($vew_data->evl->pattxt));
	$pdf->text(145, 48,$vew_data->pat->tax->taxcod );
	$pdf->text(75, 58, strtoupper(($vew_doc->getTagValue($vew_data->evl->evlatr001,'ref') =='')?'-':$vew_doc->getTagValue($vew_data->evl->evlatr001,'ref')) );
	$pdf->text(50, 68, strtoupper(($vew_doc->getTagValue($vew_data->evl->evlatr001,'hltdisclstxt')=='')?'-':$vew_doc->getTagValue($vew_data->evl->evlatr001,'hltdisclstxt')) );
	$pdf->text(95, 78, strtoupper($vew_doc->getTagValue($vew_data->evl->evlatr001,'medcro')));

	$lv_antclidat =$pdf->text(80, 98, ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'hta')=='on')?'SI':'-' )).
							$pdf->text(85, 108, ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'ci')=='on')?'SI':'-' )).
							$pdf->text(60, 118, ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'sp')=='on')?'SI':'-' )).
							$pdf->text(122, 128, ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'epc')=='on')?'SI':'-' )).
							$pdf->text(95, 138, ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'irc')=='on')?'SI':'-' )).
							$pdf->text(55, 148, ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'epi')=='on')?'SI':'-' )).
							$pdf->text(190, 98, ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'icc')=='on')?'SI':'-' )).
							$pdf->text(160, 108, ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'arrtms')=='on')?'SI':'-' )).
							$pdf->text(150, 118, ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'asm')=='on')?'SI':'-' )).
							$pdf->text(175, 128, ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'tbq')=='on')?'SI':'-' )).
							$pdf->text(197, 138, ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'acv')=='on')?'SI':'-' )).
							$pdf->text(160, 148, ( ($vew_doc->getTagValue($vew_data->evl->evlatr001,'alg')=='on')?'SI':'-' ));

	$pdf->text(20, 88, $lv_antclidat);
	$pdf->writeHTMLCell(149,'',42, 158, ($vew_data->evl->evlsub == ''?'-':$vew_data->evl->evlsub) );
	
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
		$pdf->writeHTMLCell(169,'',128,260,'<b>'.strtoupper($vew_data->sgndat['usrtxt']).'</b>');
		$pdf->writeHTMLCell(169,'',40,260,'<b>'.$vew_data->sgndat['sgndte']->format('d/m/Y H:i').'</b>');

		// create content for signature (image and/or text)
	 	$pdf->Image($lv_img, 110, 250, 15, 15, 'PNG');

		// define active area for signature appearance
		$pdf->setSignatureAppearance(110, 250, 15, 15);
		
		// *** set an empty signature appearance *** ==> SOLO PARA FIRMAS ADICIONALES (con acrobat reader)
		// $pdf->addEmptySignatureAppearance(180, 80, 15, 15);
	} else {
		// $pdf->RoundedRect(110, 250, 15, 15, 0, '1000');
		// $pdf->writeHTMLCell(169,'',128,260,'<b>FIRMANTE</b>');
		// $pdf->writeHTMLCell(169,'',40,260,'<b>FECHA/HORA</b>');
	}
	// **************************************************************************
	
	// PIE
	$pdf->Rect(0, 282, 4.7, 14.7, 'DF', $block_style, array(220, 220, 200));
	$pdf->Line(0, 282, 210, 282, $line_style);


	// Close and output PDF document
	$pdf->Output('HistoriaClinica'.$vew_data->evl->evlcod.'.pdf', 'I');
?>
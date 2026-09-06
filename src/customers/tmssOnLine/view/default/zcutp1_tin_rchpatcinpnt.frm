<?php
	// --------------------------------------------------------------------------
	// CONSENTIMIENTO INFORMADO
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
	
	
	// --------------------------------------------------------------------------
	//
	//  P A G I N A   1
	//
	// --------------------------------------------------------------------------
	
	
	
	// add a page
	$pdf->AddPage('P');

	// styles
	$head_line_style =  array('width' => 0.5, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0));
	$line_style = array('width' => 0.2, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0));
  $block_style = array('B');
	
	// ENCABEZADO
	$pdf->setfont('helvetica','b', 14);
	$pdf->setTextColor(150, 20, 20);
	$pdf->text(10, 8, 'CONSENTIMIENTO INFORMADO');
	$pdf->Line(0, 15, 126, 15, $head_line_style);
	$pdf->Line(5, 0, 5, 300, $line_style);
	$pdf->Rect(0, 0, 4.7, 14.7, 'DF', $block_style, array(220, 220, 200));
	$pdf->Image('/library/images/logos/zcutp1_logoTeamInfusionAR.jpg', 165, 8, 42, 36, '', '', 'T', false, 300, '', false, false, 0, false, false, false);
	
	// CUERPO
	$pdf->setfont('helvetica', 'b', 12);
	$pdf->setTextColor(0, 0, 0);
	$pdf->text(10, 35, 'INGRESO AL PROGRAMA DE SOPORTE A PACIENTES');
	$pdf->setfont('helvetica', '', 9);
	$pdf->writeHTMLCell(169,'',10, 45, 'Nombre y apellido del paciente: <b>'.strtoupper($vew_data->pat->pattxt).'</b>');
	$pdf->writeHTMLCell(169,'',120, 45, 'DNI: <b>'.(($vew_data->pat->tax->taxcod == '')?'-':$vew_data->pat->tax->taxcod).'</b>');
	$pdf->writeHTMLCell(169,'',10, 55, 'Fecha de Nacimiento del Paciente: <b>'.( ($vew_data->pat->per->perbrndte != null )?(date_format($vew_data->pat->per->perbrndte, 'd/m/Y')):' - ' ).'</b>');
	$pdf->text(120, 55, 'Edad del Paciente:');	
	$pdf->text(10, 65, 'Nombre y apellido de padre, madre, tutor, curador o persona de apoyo del Paciente:');
	$pdf->text(10, 70, '(en caso de corresponder por ser el paciente menor o incapaz, o tener su capacidad restringida)');
	$pdf->text(10, 75, 'Grado de Parentesco o Carácter (apoyo, tutor o curador):');
	$pdf->text(120, 75, 'DNI:');
	$pdf->writeHTMLCell(169,'',10, 85, 'Nombre y apellido del médico a cargo: <b>'.strtoupper($vew_data->prs->prstxt).'</b>');
	$pdf->text(10, 95, 'Domicilio del paciente:');
	$pdf->Line(10, 100, 200, 100, $head_line_style);
	$pdf->text(10, 105, 'Señores TEAM INFUSION,');
	$pdf->text(10, 110, 'Rivera 26, 1°A, Villa Adelina.');
	$pdf->text(10, 120, 'De nuestra mayor consideración:');
	$html ='<ol style="line-height:150%;">'.
					'En mi carácter de paciente / progenitor o tutor del paciente [tachar lo que no corresponda] vengo a prestar el consentimiento informado y, en consecuencia, manifestar que:<br>'.
					'<li>He sido informado por el Dr./a <b>'.strtoupper($vew_data->prs->prstxt).'</b> acerca de la conveniencia de que el medicamento denominado <b>'.strToUpper($vew_doc->getTagValue($vew_data->evl->evlatr001,'mattxt')).'</b> sea aplicado a través de un servicio de aplicación domiciliaria de TEAM INFUSION. '.
					'La aplicación del producto se realizará en:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.…. el domicilio del Paciente indicado en el encabezado.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.…. dentro de una ambulancia UTIM, en su domicilio. <br><i>(Indicar con una cruz la opción que corresponda)</i><br>'.
					'La aplicación del producto estará a cargo de profesional de enfermería entrenado y capacitado de TEAM INFUSION, siguiendo la indicación de su médico a cargo. '.
					'En caso de presentar alguna reacción adversa durante la aplicación del medicamento y/o inmediatamente después de finalizada su aplicación, que implique la necesidad de traslado hasta el centro de salud correspondiente, el mismo será realizado por la ambulancia UTIM contratada por TEAM INFUSION, presente en el domicilio al momento de la aplicación.'.
					'</li>'.
					'<li>El Dr./a. <b>'.strtoupper($vew_data->prs->prstxt).'</b> me ha explicado en forma clara, precisa y adecuada, conforme mi estado de salud, cual es la naturaleza del procedimiento propuesto y el objetivo del servicio prestado por TEAM INFUSION, incluyendo riesgos, alternativas disponibles, eventuales beneficios, inconvenientes y limitaciones del medicamento a ser aplicado y del servicio de aplicación.</li>'.
					'<li>Se me ha informado también sobre los eventos adversos que podrían ocasionarse y las molestias que el procedimiento podría producir, las cuales consisten mayormente en eventuales dolores locales, hematoma, endurecimiento en el sitio de punción y en menor probabilidad, reacción de hipersensibilidad al producto. Estoy satisfecho con esas explicaciones y manifiesto que las he comprendido en su totalidad y que acepto que se realice el procedimiento según lo establecido.</li>'.
					'<li>El Dr./a. <b>'.strtoupper($vew_data->prs->prstxt).'</b> y un representante de TEAM INFUSION han respondido cada una de mis preguntas y evacuado todas las dudas que le he planteado. </li>'.
					'<li>Se me ha explicado que los potenciales beneficios del tratamiento con el medicamento <b>'.strToUpper($vew_doc->getTagValue($vew_data->evl->evlatr001,'mattxt')).'</b> en mi domicilio son:'.
						'<ul>'.
							'<li>Disponibilidad horaria que permite mantener las actividades rutinarias del paciente sin interrupciones;</li>'.
							'<li>Evitar traslados y tiempos de espera;</li>'.
							'<li>Mejorar la  adherencia al tratamiento;</li>'.
							'<li>Evitar el contacto con pacientes con enfermedades infecto-contagiosas, sobre todo en época invernal.</li>'.
						'</ul>'.
					'</li>'.
					'<li>Asimismo, se me informa y presto mi consentimiento, que mis datos personales, información de contacto, prescripción del medicamento e información clínica relacionada con la prestación del medicamento y el servicio, brindados y recolectados por TEAM INFUSION, serán compartidos únicamente con las partes involucradas, al sólo y <u><b>exclusivo fin de</b></u> prestar el servicio aquí descripto. Toda la información recolectada, será tratada en forma confidencial y según lo establecen las leyes de protección de datos personales. </li>'.
					'<li>Se me informó que los datos de contacto de TEAM INFUSIÓN son los siguientes:<br><b>info@teaminfusion.com</b><br><b>coordinacion@teaminfusion.com</b><br>Y que por cualquier emergencia debo comunicarme a:<br><b>0810-362-0022</b><br><b>011-5245-3404</b></li>'.
				'</ol>';
	$pdf->writeHTMLCell(165, '', 5, 130, $html);
	
	
	
	// PIE
	$pdf->Rect(0, 282, 4.7, 14.7, 'DF', $block_style, array(220, 220, 200));
	$pdf->Line(0, 282, 210, 282, $line_style);
	
	
	
	// --------------------------------------------------------------------------
	//
	//  P A G I N A   2
	//
	// --------------------------------------------------------------------------
	
	
	
	// add a page
	$pdf->addPage('P');
	
	
	
	// ENCABEZADO
	$pdf->setfont('helvetica','b', 14);
	$pdf->setTextColor(150, 20, 20);
	$pdf->text(10, 8, 'CONSENTIMIENTO INFORMADO');
	$pdf->Line(0, 15, 126, 15, $head_line_style);
	$pdf->Line(5, 0, 5, 300, $line_style);
	$pdf->Rect(0, 0, 4.7, 14.7, 'DF', $block_style, array(220, 220, 200));
	$pdf->Image('/library/images/logos/zcutp1_logoTeamInfusionAR.jpg', 165, 8, 42, 36, '', '', 'T', false, 300, '', false, false, 0, false, false, false);
	
	
	
	// CUERPO
	$pdf->setfont('helvetica', '', 10);
	$pdf->setTextColor(0, 0, 0);
	$pdf->text(10, 105, 'Firma y aclaración del paciente: ');
	$pdf->text(10, 115, 'Fecha y Hora: ');
	$html2 = '<p style="line-height:150%;">Yo en carácter de madre/padre/tutor/curador/persona de apoyo (tachar lo que no corresponda) ………………………………………, DNI …………………… he sido asesorado respecto de riesgos / beneficios de la realización del tratamiento con el medicamento <b>'.strToUpper($vew_doc->getTagValue($vew_data->evl->evlatr001,'mattxt')).'</b> en el domicilio del Paciente, habiendo realizado todas las preguntas del caso, manifiesto que se me ha respondido y se han evacuado todas las dudas que este procedimiento me generó, y consiento el inicio del tratamiento domiciliario.</p>';
	$pdf->writeHTMLCell(155, '', 10, 125, $html2);
	$pdf->text(10, 175, 'Firma y aclaración del paciente: ');
	$pdf->text(10, 185, 'Fecha y Hora: ');
	$pdf->Line(10, 195, 200, 195, $head_line_style);
	$pdf->text(10, 200, 'Firma y aclaración del médico: ');
	$pdf->text(10, 215, 'Sello/Matricula: ');
	$pdf->text(10, 230, 'Fecha y Hora: ');
	
	
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
		$pdf->writeHTMLCell(169,'',70,215,'<b>'.strtoupper($vew_data->sgndat['usrtxt']).'</b>');
		$pdf->writeHTMLCell(169,'',70,230,'<b>'.$vew_data->sgndat['sgndte']->format('d/m/Y H:i').'</b>');

		// create content for signature (image and/or text)
	 	$pdf->Image($lv_img, 70, 200, 15, 15, 'PNG');

		// define active area for signature appearance
		$pdf->setSignatureAppearance(70, 200, 15, 15);
		
		// *** set an empty signature appearance *** ==> SOLO PARA FIRMAS ADICIONALES (con acrobat reader)
		// $pdf->addEmptySignatureAppearance(180, 80, 15, 15);
	} else {
		// $pdf->RoundedRect(70, 200, 15, 15, 0, '1000');
		// $pdf->writeHTMLCell(169,'',70,215,'<b>FIRMANTE</b>');
		// $pdf->writeHTMLCell(169,'',70,230,'<b>FECHA/HORA</b>');
	}
	// **************************************************************************
	
	
	// PIE
	$pdf->Rect(0, 282, 4.7, 14.7, 'DF', $block_style, array(220, 220, 200));
  $pdf->Line(0, 282, 210, 282, $line_style);
	
	
	// Close and output PDF document
	$pdf->Output('ConsInformado'.$vew_data->evl->evlcod.'.pdf', 'I');
?>
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
	$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);  

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
	
	// ---------------------------------------------------------
	$pdf->AddPage('P');
	//$pdf->setfont('Courier', '', 11);
	
	// Encabezado
  // $pdf->Image('/library/images/logos/zcutp1_logoTeamInfusionAR.jpg', 30, 13, 30, 30, '', '', 'T', false, 300, '', false, false, 0, false, false, false);
	
	// Titulo
	$pdf->setfont('helvetica', 'B', 18);
	$pdf->text( 10, 10,'TURNO');
	
	$lv_mtharr = Array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
	$lv_dayarr = Array('Lunes','Martes','Miercoles','Jueves','Viernes','Sabado','Domingo');
	$lv_dtestr = $lv_dayarr[ date_format($vew_data->plndte,'N')-1 ].' '.
								date_format($vew_data->plndte,'d').' de '.
								$lv_mtharr[ date_format($vew_data->plndte,'n') ].', '.
								date_format($vew_data->plndte,'Y');
	// Datos Turno
	$pdf->setfont('helvetica', '', 11);
	$lv_tbltrn = '<table  border="0" cellpadding="5" cellspacing="1">'.
							'<tr><td width="140">Fecha:</td><td><h2>'.$lv_dtestr.'</h2></td></tr>'.
							'<tr><td>Hora:</td><td><h1>'.date_format($vew_data->plninbdte,'H:i').'</h1></td></tr>'.
							'<tr><td>Direccion:</td><td>'.utf8_encode($vew_data->del->deltxt).'</td></tr>'.
							($vew_data->del->adr->adrstr!=''?'<tr><td></td><td>'.utf8_encode($vew_data->del->adr->adrstr).' '.utf8_encode($vew_data->del->adr->adrstrnum).
								($vew_data->del->adr->adrstrflr!=''?', Piso: '.utf8_encode($vew_data->del->adr->adrstrflr):'').
								($vew_data->del->adr->adrstrunt!=''?', Unidad: '.utf8_encode($vew_data->del->adr->adrstrunt):'').'</td></tr>' : '').
							($vew_data->del->adr->lndregtxt!='' || $vew_data->del->adr->lndtxt!=''?'<tr><td></td><td>'.utf8_encode($vew_data->del->adr->lndregtxt).($vew_data->del->adr->lndtxt!=''?($vew_data->del->adr->lndregtxt!=''?', ':'').utf8_encode($vew_data->del->adr->lndtxt):'').'</td></tr>' : '').
							($vew_data->del->adr->adrphn001!='' || $vew_data->del->adr->adrphn002!=''?'<tr><td>Telefono:</td><td>'.utf8_encode($vew_data->del->adr->adrphn001).($vew_data->del->adr->adrphn002!=''?' / '.utf8_encode($vew_data->del->adr->adrphn002):'').'</td></tr>':'').
							($vew_data->del->adr->adreml!=''?'<tr><td>Mail:</td><td>'.utf8_encode($vew_data->del->adr->adreml).'</td></tr>':'').
							($vew_data->spc->spccod!=''?'<tr><td>Especialidad:</td><td>'.utf8_encode($vew_data->spc->spctxt).'</td></tr>':'').
							($vew_data->prs->prscod!=''?'<tr><td>Medico/Especialista:</td><td>'.utf8_encode($vew_data->prs->prstxt).'</td></tr>':'').
							($vew_data->plncmt!=''?'<tr><td>Observaciones:</td><td>'.utf8_encode($vew_data->plncmt).'</td></tr>':'').
						'</table>';
	$pdf->setxy( 10, 20);
	$pdf->writeHTML($lv_tbltrn);

	$pdf->Output('turno.pdf', 'I');	
?>
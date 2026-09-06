<?php
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

	$lv_pnttipo = strtolower(trim((string)($vew_data->pnttipo??'interno')));
	if($lv_pnttipo==='interno'){
		// Impresion historica de traslado dentro del mismo almacen.
		$lv_docsts = array('A'=>'ACTIVO', 'C'=>'CONTABILIZADO', 'I'=>'INACTIVO');
		$lv_stkmovdoclck = array('0'=>'NO', '1'=>'SI');
		$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'ISO-8859-1', false);
		$pdf->setPrintHeader(false);
		$pdf->setPrintFooter(false);
		$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
		$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
		$pdf->SetAutoPageBreak(true, PDF_MARGIN_BOTTOM);
		$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
		$pdf->AddPage('L');

		$lv_posy = 10;
		$pdf->SetFont('courier', 'B', 16);
		$pdf->Text(160, $lv_posy, utf8_encode((string)$vew_data->sysdocclstxt).'  #'.(string)$vew_data->stkmovdoccod);
		$pdf->SetFont('courier', 'B', 12);
		$lv_posy = 20;
		$lv_dtetxt = (is_a($vew_data->stkmovdocdte, 'DateTime')?$vew_data->stkmovdocdte->format('d-m-Y'):(string)($vew_data->stkmovdocdtecnv??''));
		$pdf->Text(20, $lv_posy, 'Fecha: '.$lv_dtetxt);
		$lv_posy += 5;

		if((string)$vew_data->srcobjcod!=='' && (string)$vew_data->srcobjcod!=='0'){
			$pdf->SetFont('courier', 'B', 12);
			$pdf->Text(20, $lv_posy, 'ORIGEN');
			$pdf->SetFont('courier', '', 12);
			$lv_posy += 5;
			$pdf->Text(20, $lv_posy, ' '.utf8_encode((string)$vew_data->srcobjtyptxt).': '.utf8_encode((string)$vew_data->srcobjtxt));
			$lv_posy += 5;
			if((string)$vew_data->srccntcod!=='' && (string)$vew_data->srccntcod!=='0'){
				$pdf->Text(20, $lv_posy, ' CONTACTO: '.utf8_encode((string)$vew_data->srccnttxt));
				$lv_posy += 5;
			}
		}

		if((string)$vew_data->dstobjcod!=='' && (string)$vew_data->dstobjcod!=='0'){
			$pdf->SetFont('courier', 'B', 12);
			$pdf->Text(20, $lv_posy, 'DESTINO');
			$pdf->SetFont('courier', '', 12);
			$lv_posy += 5;
			$pdf->Text(20, $lv_posy, ' '.utf8_encode((string)$vew_data->dstobjtyptxt).': '.utf8_encode((string)$vew_data->dstobjtxt));
			$lv_posy += 5;
			if((string)$vew_data->dstcnttxt!=='' && (string)$vew_data->dstcnttxt!=='0'){
				$pdf->Text(20, $lv_posy, ' CONTACTO: '.utf8_encode((string)$vew_data->dstcnttxt));
				$lv_posy += 5;
			}
		}

		$lv_posy2 = 25;
		$pdf->Text(150, $lv_posy2, 'NRO.: '.(string)$vew_data->stkmovdoccodext);
		$lv_posy2 += 5;
		$pdf->Text(150, $lv_posy2, 'BLOQUEADO: '.($lv_stkmovdoclck[(string)$vew_data->stkmovdoclck]??(string)$vew_data->stkmovdoclck));
		$lv_posy2 += 5;
		$pdf->Text(150, $lv_posy2, 'ESTADO: '.($lv_docsts[(string)$vew_data->docsts]??(string)$vew_data->docsts).' '.utf8_encode((string)$vew_data->sysdoctretxt));
		$pdf->Text(20, $lv_posy, 'COMENTARIO: '.utf8_encode((string)$vew_data->stkmovdoccmt));
		$lv_posy += 5;

		$pdf->SetFont('courier', '', 10);
		$lv_buffer = '<table cellpadding="4" cellspacing="0" border="1">'.
						'<tr style="background-color: #f1f1f1; font-weight: bold;">'.
							'<td width="25">#</td>'.
							'<td width="60">Cod</td>'.
							'<td width="300">Descripcion</td>'.
							'<td width="60" align="right">Cant</td>'.
							'<td width="60">UM</td>'.
							'<td width="90">Lote</td>'.
							'<td width="100">Vencimiento</td>'.
							'<td width="100">Serie</td>'.
						'</tr>';
		$lv_idx = 0;
		foreach(($vew_data->stkmovdocmat??array()) as $lv_row){
			$lv_idx++;
			$lv_buffer .= '<tr>'.
							'<td style="background-color: #f1f1f1;">'.$lv_idx.'</td>'.
							'<td>'.($lv_row['matcod']??'').'</td>'.
							'<td>'.utf8_encode((string)($lv_row['mattxt']??'')).'</td>'.
							'<td align="right">'.number_format(floatval($lv_row['matqty']??0), 2).'</td>'.
							'<td>'.($lv_row['matuntcod']??'').'</td>'.
							'<td>'.(intval($lv_row['matbchcod']??0)===0?'':($lv_row['matbchcodext']??'')).'</td>'.
							'<td>'.(intval($lv_row['matbchcod']??0)===0?'':($lv_row['matbchduedtecnv']??'')).'</td>'.
							'<td>'.(intval($lv_row['matsercod']??0)===0?'':($lv_row['matsercodext']??'')).'</td>'.
						'</tr>';
		}
		$lv_buffer .= '</table>';
		$pdf->SetXY(20, $lv_posy+4);
		$pdf->writeHTML($lv_buffer);

		$lv_outcod = preg_replace('/[^A-Za-z0-9_-]/', '_', (string)$vew_data->stkmovdoccod);
		$pdf->Output('Traslado_Interno_'.$lv_outcod.'.pdf', 'I');
		return;
	}

	class LGNStkMovDetPDF extends TCPDF {
		public $remito;

		public function Header() {
			$lo_data = $this->remito;

			// Geometria tradicional reutilizada del Presupuesto Logindoor.
			$this->SetDrawColor(0, 0, 0);
			$this->SetLineWidth(0.20);
			$this->Rect(5, 4, 200, 74);
			$this->Line(5, 10, 205, 10);
			$this->SetFont('helvetica', 'B', 10);
			$this->SetXY(80, 4);
			$this->Cell(50, 6, 'ORIGINAL', 0, 0, 'C');

			$lv_logo = 'library/images/logos/zcutp1_logindoor.jpg';
			if(is_file($lv_logo) && @getimagesize($lv_logo)!==false){
				$this->Image($lv_logo, 8, 12, 80, 0, '', '', '', false, 300);
			}else{
				$this->SetFont('helvetica', 'B', 24);
				$this->Text(8, 15, 'LOGINDOOR');
			}

			// Identificacion central tipo comprobante X.
			$this->Rect(97, 10, 16, 15);
			$this->SetFont('helvetica', 'B', 30);
			$this->MultiCell(16, 15, 'X', 0, 'C', false, 0, 97, 10, true, 0, false, true, 15, 'M');
			$this->Line(105, 25, 105, 60);

			// Cabecera fija solicitada para el remito inter planta.
			$this->SetFont('helvetica', '', 6.5);
			$this->SetXY(8, 34);
			$this->Cell(89, 3.5, 'Malvinas Argentinas 4541, Victoria, Bs.As.', 0, 1, 'L');
			$this->SetXY(8, 38);
			$this->Cell(89, 3.5, 'Parque Ader - Av. Bernardo Ader 3620, Nave 6 Villa Adelina, Bs. As.', 0, 1, 'L');
			$this->SetXY(8, 42);
			$this->Cell(89, 3.5, 'Administración: Rivera 26 - Of. B, Villa Adelina, San Isidro, Bs. As.', 0, 1, 'L');
			$this->SetXY(8, 46);
			$this->Cell(89, 3.5, 'Tel.: 0810-362-0222', 0, 1, 'L');
			$this->SetFont('helvetica', '', 7.3);
			$this->SetXY(8, 52);
			$this->Cell(89, 3.5, 'IVA Responsable Inscripto', 0, 1, 'L');

			$this->SetFont('helvetica', 'B', 19);
			$this->Text(116, 13, 'REMITO INTER PLANTA');
			$this->SetFont('helvetica', 'B', 12);
			$this->Text(115, 25, 'Nro.: '.(string)$lo_data->pntremitocod);
			$this->SetFont('helvetica', '', 9);
			$this->Text(115, 35, 'Fecha: '.(string)$lo_data->pntstkmovdocdtetxt);
			$this->SetFont('helvetica', '', 8);
			$this->Text(115, 46, 'C.U.I.T.: '.(string)$lo_data->pntbuscuittxt);
			$this->Text(115, 50, 'Ingresos Brutos: '.(string)$lo_data->pntbusiibbtxt);
			$this->Text(115, 54, 'Fecha de Inicio de Actividades: '.(string)$lo_data->pntbusactstrtxt);

			// Franja operativa equivalente al bloque cliente/entrega del Presupuesto.
			$this->Line(5, 60, 205, 60);
			$this->Line(105, 60, 105, 78);
			$this->SetFont('helvetica', 'B', 8);
			$this->Text(8, 62, 'ORIGEN');
			$this->Text(108, 62, 'DESTINO');
			$this->SetFont('helvetica', '', 7.4);
			$this->SetXY(8, 66);
			$this->MultiCell(94, 3.2, utf8_encode((string)$lo_data->pntsrcobjtxt), 0, 'L', false, 1);
			$this->SetXY(108, 66);
			$this->MultiCell(94, 3.2, utf8_encode((string)$lo_data->pntdstobjtxt), 0, 'L', false, 1);
			$this->SetFont('helvetica', '', 6.7);
			$this->SetXY(8, 70);
			$this->MultiCell(94, 3, utf8_encode((string)$lo_data->pntsrcadrtxt), 0, 'L', false, 1);
			$this->SetXY(108, 70);
			$this->MultiCell(94, 3, utf8_encode((string)$lo_data->pntdstadrtxt), 0, 'L', false, 1);
			if((string)$lo_data->pntsrccnttxt!==''){
				$this->Text(8, 75, 'Contacto: '.utf8_encode((string)$lo_data->pntsrccnttxt));
			}
			if((string)$lo_data->pntdstcnttxt!==''){
				$this->Text(108, 75, 'Contacto: '.utf8_encode((string)$lo_data->pntdstcnttxt));
			}
		}

		public function Footer() {
			$this->SetY(-5.5);
			$this->SetFont('helvetica', '', 6.5);
			$this->Cell(100, 3, 'Documento no comercial - Traslado inter planta', 0, 0, 'L');
			$this->Cell(96, 3, 'Página '.$this->getAliasNumPage().' / '.$this->getAliasNbPages(), 0, 0, 'R');
		}

		public function RemitoTableHeader() {
			$lv_posx = 5;
			$lv_posy = $this->GetY();
			$lv_widths = array(20, 70, 18, 16, 28, 28, 20);
			$lv_titles = array('Código', 'Producto / Servicio', 'Cantidad', 'U. medida', 'Lote', 'Serie', 'Vencimiento');
			$this->SetFillColor(198, 198, 198);
			$this->SetFont('helvetica', '', 7.5);
			foreach($lv_titles as $lv_idx=>$lv_title){
				$this->MultiCell($lv_widths[$lv_idx], 7, $lv_title, 0, 'C', true, 0, $lv_posx, $lv_posy, true, 0, false, true, 7, 'M');
				$lv_posx += $lv_widths[$lv_idx];
			}
			$this->SetY($lv_posy+7);
		}
	}

	$pdf = new LGNStkMovDetPDF('P', PDF_UNIT, PDF_PAGE_FORMAT, true, 'ISO-8859-1', false);
	$pdf->remito = $vew_data;
	$pdf->SetCreator('Temasis');
	$pdf->SetAuthor(utf8_encode((string)$vew_data->pntbustxt));
	$pdf->SetTitle('Remito Inter Planta '.(string)$vew_data->pntremitocod);
	$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
	$pdf->SetMargins(5, 80, 5);
	$pdf->SetHeaderMargin(0);
	$pdf->SetFooterMargin(3);
	// El paginado de posiciones es manual para reservar el pie tradicional.
	$pdf->SetAutoPageBreak(false, 0);
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
	$pdf->SetFont('helvetica', '', 8);
	$pdf->AddPage('P');
	$pdf->RemitoTableHeader();

	$lv_widths = array(20, 70, 18, 16, 28, 28, 20);
	$lv_aligns = array('L', 'L', 'R', 'C', 'L', 'L', 'C');
	$pdf->SetFont('helvetica', '', 7.5);

	foreach($vew_data->stkmovdocmat as $lv_row){
		$lv_values = array(
			utf8_encode((string)($lv_row['matcod']??'')),
			utf8_encode((string)($lv_row['mattxt']??'')),
			(string)($lv_row['matqtypnt']??''),
			utf8_encode((string)($lv_row['matuntcod']??'')),
			utf8_encode((string)($lv_row['matbchcodextpnt']??'')),
			utf8_encode((string)($lv_row['matsercodextpnt']??'')),
			(string)($lv_row['matbchduedtepnt']??'')
		);
		$lv_rowh = 5.5;
		foreach($lv_values as $lv_idx=>$lv_value){
			$lv_rowh = max($lv_rowh, $pdf->getStringHeight($lv_widths[$lv_idx]-2, $lv_value)+0.8);
		}

		if($pdf->GetY()+$lv_rowh>255){
			$pdf->AddPage('P');
			$pdf->RemitoTableHeader();
			$pdf->SetFont('helvetica', '', 7.5);
		}

		$lv_posx = 5;
		$lv_posy = $pdf->GetY();
		foreach($lv_values as $lv_idx=>$lv_value){
			$pdf->MultiCell($lv_widths[$lv_idx], $lv_rowh, $lv_value, 0, $lv_aligns[$lv_idx], false, 0, $lv_posx, $lv_posy, true, 0, false, true, $lv_rowh, 'M');
			$lv_posx += $lv_widths[$lv_idx];
		}
		$pdf->SetY($lv_posy+$lv_rowh);
	}

	// Pie tradicional con observaciones y conformidad, solo en la ultima pagina.
	$pdf->SetFont('helvetica', '', 8);
	$lv_cmttxt = utf8_encode((string)$vew_data->pntstkmovdoccmttxt);
	$lv_accusrtxt = utf8_encode((string)($vew_data->pntaccusrtxt??''));
	$lv_cmtheight = max(12, $pdf->getStringHeight(118, $lv_cmttxt)+4);
	$lv_usrheight = ($lv_accusrtxt!==''?5:0);
	$lv_footerheight = max(32, $lv_cmtheight+$lv_usrheight+12);
	$lv_footery = 292-$lv_footerheight;
	if($pdf->GetY()>$lv_footery-3){
		$pdf->AddPage('P');
	}

	$pdf->SetDrawColor(0, 0, 0);
	$pdf->Rect(5, $lv_footery, 200, $lv_footerheight);
	$pdf->SetFont('helvetica', 'B', 9);
	$pdf->Text(10, $lv_footery+4, 'Observaciones:');
	$pdf->SetFont('helvetica', '', 8);
	$pdf->MultiCell(118, $lv_cmtheight, $lv_cmttxt, 0, 'L', false, 1, 10, $lv_footery+10, true, 0, false, true, $lv_cmtheight, 'T');
	if($lv_accusrtxt!==''){
		$pdf->SetXY(10, $lv_footery+10+$lv_cmtheight);
		$pdf->Cell(118, 4, $lv_accusrtxt, 0, 0, 'L');
	}

	$lv_signy = $lv_footery+$lv_footerheight-11;
	$pdf->Line(137, $lv_signy, 165, $lv_signy);
	$pdf->Line(171, $lv_signy, 199, $lv_signy);
	$pdf->SetFont('helvetica', 'B', 7.5);
	$pdf->SetXY(137, $lv_signy+1);
	$pdf->Cell(28, 4, 'FIRMA', 0, 0, 'C');
	$pdf->SetXY(171, $lv_signy+1);
	$pdf->Cell(28, 4, 'ACLARACIÓN', 0, 0, 'C');

	$lv_outcod = preg_replace('/[^A-Za-z0-9_-]/', '_', (string)$vew_data->pntremitocod);
	$pdf->Output('Remito_Inter_Planta_'.$lv_outcod.'.pdf', 'I');
?>

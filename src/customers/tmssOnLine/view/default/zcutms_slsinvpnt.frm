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
	
	
	// ENCABEZADO
	$pdf->Image('library/images/logos/zcutms_temasisargentina.jpg',8,7,80,'','','http://www.tcpdf.org', '', false, 300);
	$pdf->setfont('helvetica', 'B', 34);
	$pdf->text( 95, 10, $vew_pos->argltrcodext);
	$pdf->line( 92,10,108,10);
	$pdf->line( 92,10,92,25);
	$pdf->line( 108,10,108,25);
	$pdf->line( 92,25,108,25);
	$pdf->setfont('helvetica', 'B', 7);
	$pdf->text( 92, 27, 'Cod.Nro. '.$vew_pos->argposcodext);
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->text( 8, 35, $vew_bus->bustxt);
	$pdf->setfont('helvetica', '', 8);
	$lv_adr = $vew_bus->adr->adrstr.($vew_bus->adr->adrstrnum!=''?' '.$vew_bus->adr->adrstrnum:'').($vew_bus->adr->adrstrflr!=''?' Pso.'.$vew_bus->adr->adrstrflr:'').($vew_bus->adr->adrstrunt!=''?' Dto.'.$vew_bus->adr->adrstrunt:'');
	$pdf->text( 8, 42, $vew_bus->adr->adrstr.($vew_bus->adr->adrstrnum!=''?' '.$vew_bus->adr->adrstrnum:'').($vew_bus->adr->adrstrflr!=''?' Pso.'.$vew_bus->adr->adrstrflr:'').($vew_bus->adr->adrstrunt!=''?' Dto.'.$vew_bus->adr->adrstrunt:'') );
	$pdf->text( 8, 46, ($vew_bus->adr->adrpstcod!=''?'CP: '.$vew_bus->adr->adrpstcod.' - ':'').$vew_bus->adr->lndregtxt);
	$pdf->text( 8, 50, $vew_bus->adr->lndtxt);
	$pdf->setfont('helvetica', 'B', 8);
	$pdf->text( 8, 54, $vew_bus->tax->taxcattxt);	
	$pdf->setfont('helvetica', 'B', (strlen($vew_pos->argpostxt)>20?14:24) );
	$pdf->writeHTMLCell(90,'', 115, 12, utf8_encode($vew_pos->argpostxt) );
	
	$pdf->setfont('helvetica', 'B', 12);
	$pdf->text( 115, 25, 'Nro.: '.substr($vew_inv->slsinvcodext,0,strlen($vew_inv->slsinvcodext)-9).'-'.substr($vew_inv->slsinvcodext, -8) );
	$pdf->setfont('helvetica', '', 8);
	$lo_mth=array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
	$pdf->text( 115, 35, 'Buenos Aires, '.date_format($vew_inv->slsinvdte,'d').' de '.$lo_mth[date_format($vew_inv->slsinvdte,'m')-1].' de '.date_format($vew_inv->slsinvdte,'Y'));
	$pdf->text( 115, 42, 'C.U.I.T.: '.substr($vew_bus->tax->taxcod,0,2).'-'.substr($vew_bus->tax->taxcod,2,8).'-'.substr($vew_bus->tax->taxcod,10,1) );
	$pdf->text( 115, 46, 'Ingresos Brutos: '.$vew_bus->tax->taxiibb);
	$pdf->text( 115, 50, 'Fecha de Inicio de Actividades: '.date_format($vew_bus->tax->taxactstr,'d-m-Y'));
	
	
	// CLIENTE
	$pdf->setfont('helvetica', '', 10);
	$pdf->line( 6,60,206,60);
	$pdf->text( 8, 62,  $vew_cus->custxt);
	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 8, 67,  utf8_encode( $vew_cus->adr->adrstr.' '.$vew_cus->adr->adrstrnum. ($vew_cus->adr->adrcty!=''?' - '.$vew_cus->adr->adrcty:'') . ($vew_cus->adr->lndregtxt!=''?' - '.$vew_cus->adr->lndregtxt:'') ) );
	$pdf->text( 8, 71,  $vew_cus->tax->taxcattxt);
	$pdf->text( 8, 75,  'C.U.I.T.: '.substr($vew_cus->tax->taxcod,0,2).'-'.substr($vew_cus->tax->taxcod,2,8).'-'.substr($vew_cus->tax->taxcod,10,1) );	
	if($vew_doc->getTagValue( $vew_fce->slsinvfceatr , $vew_fce->buscod.'CBU' )!=''){
		$pdf->text( 125, 62,  'CBU del Emisor:  '.$vew_doc->getTagValue( $vew_fce->slsinvfceatr , $vew_fce->buscod.'CBU' ) );
		if($vew_inv->slsinvstrdte==''){$vew_inv->slsinvstrdte=$vew_inv->slsinvdte;}
		if($vew_inv->slsinvenddte==''){$vew_inv->slsinvenddte=$vew_inv->slsinvdte;}
		$pdf->text( 125, 75,  'Periodo:  '.$vew_inv->slsinvstrdte->format('d/m/Y').' - '.$vew_inv->slsinvenddte->format('d/m/Y') );
	} else if($vew_doc->getTagValue( $vew_fce->slsinvfceatr , $vew_fce->buscod.'CBUALS' )!='' ){
		$pdf->text( 125, 62,  'Alias CBU del Emisor:  '.$vew_doc->getTagValue( $vew_fce->slsinvfceatr , $vew_fce->buscod.'CBUALS' ) );
		if($vew_inv->slsinvstrdte==''){$vew_inv->slsinvstrdte=$vew_inv->slsinvdte;}
		if($vew_inv->slsinvenddte==''){$vew_inv->slsinvenddte=$vew_inv->slsinvdte;}
		$pdf->text( 125, 75,  'Periodo:  '.$vew_inv->slsinvstrdte->format('d/m/Y').' - '.$vew_inv->slsinvenddte->format('d/m/Y') );
	}
	$pdf->text( 125, 67,  'Condición de Pago:  '.$vew_inv->paytrmtxt);
	$pdf->text( 125, 71,  'Fecha Vto de Pago:  '.$vew_inv->slsinvduedte->format('d/m/Y') );
	$pdf->line( 6,79,206,79);
	// ******************************************************************
	// FALTA INDICAR TIPO DE CAMBIO PARA MONEDAS EXTRANJERAS
	// ******************************************************************
	
	$lv_discrimina = true; //($vew_pos->argltrcodext=='B' || $vew_pos->argltrcodext=='C' ? false : true );
	
	// POSICIONES
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
			
			
			$lv_vattot = 0;
			if( !$lv_discrimina ){
				foreach($vew_inv->slsinvprc as $lv_rowprc){
					if($lv_rowprc['srcobjcod001']==$lv_row['slsinvcod'] && $lv_rowprc['srcobjcod002']==$lv_row['slsinvmatcod'] && $lv_rowprc['fintaxtypcat']=='IVA'){
						$lv_vattot += $lv_rowprc['prccndtot'];
					}
				}
			}
			
			// ******************************************************************
			// FALTA INDICAR EL SIGNO DE LA MONEDA
			// ******************************************************************
			$lv_mattxt = $vew_doc->getTagValue($lv_row['slsinvmatatr'],'slsinvmatslstxt');
			$lv_mattxt = utf8_encode(trim($lv_mattxt)!=''?trim($lv_mattxt):$lv_row['mattxt']);
			$lv_buffer .= '<tr>'.
										'<td align="left"  width="80">'.$lv_row['matcod'].'</td>'.
										'<td align="left"  width="300">'.$lv_mattxt.'</td>'.
										'<td align="right" width="80">'.number_format($lv_row['matqty'],2).'</td>'.
										'<td align="left"  width="80">'.$lv_row['matuntcod'].'</td>'.
										'<td align="right" width="80">'.number_format($lv_row['matprc']+($lv_vattot / ($lv_row['matqty']==0?1:$lv_row['matqty']) ),2).'</td>'.
										'<td align="right" width="80">'.number_format(($lv_row['matqty']*$lv_row['matprc'])+$lv_vattot,2).'</td>'.
										'</tr>';
			$lv_tot += ($lv_row['matqty']*($lv_row['matprc']+$lv_vattot));
		}	
	}
	$lv_buffer .= '</tbody></table>';
	$pdf->writeHTML($lv_buffer);
	
	
	// PIE
	$pdf->line( 5,245,205,245);	
	$pdf->setfont('helvetica', '', 10);
	
	// ******************************************************************
	// defino codigo de barras y determino digito verificador (Resolución General A.F.I.P. 1.702/04)
	//$code = '30716290545001000016945506491190120191118';	
	/*
	$code = $vew_bus->tax->taxcod .str_pad($vew_pos->argposcodext, 3, '0', STR_PAD_LEFT) .str_pad($vew_inv->slsposcodext, 5, '0', STR_PAD_LEFT) .$vew_fce->slsinvfceautcodext .date_format($vew_fce->slsinvfceautduedte,'Ymd');
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
	$pdf->write1DBarcode($code, 'I25', 35, 265, '', 12, 0.23, $style, 'N');
	*/
	
	// **************************************************************************
	// RG 4892/2020 nueva resolucion AFIP (QR en lugar de codigo de barras)
	//	ver	Numérico 1 digito	OBLIGATORIO – versión del formato de los datos del comprobante	1
	//	fecha	full-date (RFC3339)	OBLIGATORIO – Fecha de emisión del comprobante	"2020-10-13"
	//	cuit	Numérico 11 dígitos	OBLIGATORIO – Cuit del Emisor del comprobante	30000000007
	//	ptoVta	Numérico hasta 5 digitos	OBLIGATORIO – Punto de venta utilizado para emitir el comprobante	10
	//	tipoCmp	Numérico hasta 3 dígitos	OBLIGATORIO – tipo de comprobante (según Tablas del sistema )	1
	//	nroCmp	Numérico hasta 8 dígitos	OBLIGATORIO – Número del comprobante	94
	//	importe	Decimal hasta 13 enteros y 2 decimales	OBLIGATORIO – Importe Total del comprobante (en la moneda en la que fue emitido)	12100
	//	moneda	3 caracteres	OBLIGATORIO – Moneda del comprobante (según Tablas del sistema )	"DOL"
	//	ctz	Decimal hasta 13 enteros y 6 decimales	OBLIGATORIO – Cotización en pesos argentinos de la moneda utilizada (1 cuando la moneda sea pesos)	65
	//	tipoDocRec	Numérico hasta 2 dígitos	DE CORRESPONDER – Código del Tipo de documento del receptor (según Tablas del sistema )	80
	//	nroDocRec	Numérico hasta 20 dígitos	DE CORRESPONDER – Número de documento del receptor correspondiente al tipo de documento indicado	20000000001
	//	tipoCodAut	string	OBLIGATORIO – “A” para comprobante autorizado por CAEA, “E” para comprobante autorizado por CAE	"E"
	//	codAut	Numérico 14 dígitos	OBLIGATORIO – Código de autorización otorgado por AFIP para el comprobante	70417054367476
	// ejemplo:
	// $code64 = base64_encode( '{"ver":1,"fecha":"2020-10-13","cuit":30000000007,"ptoVta":10,"tipoCmp":1,"nroCmp":94,"importe":12100,"moneda":"DOL","ctz":65,"tipoDocRec":80,"nroDocRec":20000000001,"tipoCodAut":"E","codAut":70417054367476}' );	
	$code64 = base64_encode( 
							json_encode( 
								array('ver'=>1,
									'fecha'=>$vew_inv->slsinvdte->format('Y-m-d'),
									'cuit'=>$vew_bus->tax->taxcod,
									'ptoVta'=>intval($vew_inv->slsposcodext),
									'tipoCmp'=>intval($vew_pos->argposcodext),
									'nroCmp'=>intval(substr($vew_inv->slsinvcodext, -8)),
									'importe'=>intval($vew_inv->slsinvtotamt*100),
									'moneda'=>($vew_inv->curcod=='ARS'?'PES':($vew_inv->curcod='USD'?'DOL':'***')),
									'ctz'=>intval( ($vew_inv->curexcrte==0?1:$vew_inv->curexcrte) * 1000000 ),
									//'tipoDocRec'=>'',
									//'nroDocRec'=>'',
									'tipoCodAut'=>'E',
									'codAut'=>$vew_fce->slsinvfceautcodext
								)
							)
						);	
	$code = 'https://www.afip.gob.ar/fe/qr/?p='.$code64;	
	$style = array(
			'border' => true,
			'vpadding' => 'auto',
			'hpadding' => 'auto',
			'fgcolor' => array(0,0,0),
			'bgcolor' => false, //array(255,255,255)
			'module_width' => 1, // width of a single module in points
			'module_height' => 1 // height of a single module in points
	);
	$pdf->write2DBarcode($code, 'QRCODE,H', 55, 247, 30, 30, $style, 'N');
	// FIN - nueva resolucion AFIP
	// **************************************************************************
	
	// define QRcode style
	/*
	$code2 = 'BEGIN:VCARD
						VERSION:3.0
						N:Temasis;Argentina;;;
						FN:Temasis Argentina SRL
						TITLE:Temasis Argentina SRL
						PHOTO;VALUE=URI;TYPE=GIF:/library/images/logos/TemasisArgentina_280px.png
						EMAIL;TYPE=INTERNET;TYPE=WORK;TYPE=PREF:info@temasis.ar
						URL;TYPE=Homepage:https://temasis.ar
						TEL;WORK;VOICE:+54 11 5021-3613
						ADR;WORK;PREF:;;Pujol 1275;Ciudad Autónoma de Buenos Aires;AR;C1416CIC;Argentina
						END:VCARD';
	*/
	$code2 = $vew_bus->bustxt.chr(10).$lv_adr.' - '.$vew_bus->adr->lndregtxt.chr(10).'+54 11 50213613'.chr(10).'www.Temasis.ar'.chr(10).'info@temasis.ar';
	$style2 = array(
			'border' => true,
			'vpadding' => 'auto',
			'hpadding' => 'auto',
			'fgcolor' => array(0,0,0),
			'bgcolor' => false, //array(255,255,255)
			'module_width' => 1, // width of a single module in points
			'module_height' => 1 // height of a single module in points
	);
	$pdf->write2DBarcode($code2, 'QRCODE,H', 5, 247, 30, 30, $style2, 'N');
	$pdf->setfont('helvetica', 'B', 10);
	$pdf->text( 5, 278, 'www.Temasis.ar');
	$pdf->setfont('helvetica', '', 10);
	$pdf->text( 5, 283, 'info@temasis.ar');
	$pdf->setfont('helvetica', '', 8);
	$pdf->text( 53, 278, 'C.A.E.: '.$vew_fce->slsinvfceautcodext );
	$pdf->text( 53, 283, 'Vto. C.A.E.: '. ($vew_fce->slsinvfceautduedte != NULL ? date_format($vew_fce->slsinvfceautduedte,'d/m/Y') : '')  );
	
	
	// SUBTOTAL -----------------------------------------------------------------
	$pdf->setxy(110,235);
	$lv_buffer2='<table border=0 cellpadding="5" cellspacing="2"><tbody>'.
							'<tr style="font-size: 16px;"><td width="160" align="right">Subtotal</td><td width="160" align="right">'.number_format( ( $lv_discrimina ? $vew_inv->slsinvnetamt : $vew_inv->slsinvtotamt ) ,2).'</td></tr>'.
							'</tbody></table>';
	$pdf->writeHTML($lv_buffer2);
		
	// IMPUESTOS ----------------------------------------------------------------
	if( $lv_discrimina ) {
		$pdf->setxy(110,248);
		$lv_buffer2='<table border=0 cellpadding="5" cellspacing="2"><tbody>';
		foreach($vew_inv->slsinvprc as $lv_row){
			if($lv_row['fintaxtypcat']=='IVA' && $lv_row['srcobjcod002']=='' && $lv_row['prccndtot']!=0 ){
				$lv_buffer2.='<tr style="font-size: 16px;"><td width="160" align="right">'.$lv_row['prccndtxt'].' '.number_format($lv_row['prccndqty']).' '.$lv_row['prccnduntcod'].'</td><td width="160" align="right">'.number_format($lv_row['prccndtot'],2).'</td></tr>';
			}
		}
		$lv_buffer2.='</tbody></table>';
		$pdf->writeHTML($lv_buffer2);
	}
	
	// TOTAL --------------------------------------------------------------------
	$pdf->setxy(110,270);
	$lv_buffer2='<table border=0 cellpadding="5" cellspacing="2"><tbody>'.
							'<tr style="background-color:#C6C6C6; font-size: 18px; font-weight: bold;"><td width="160" align="right">TOTAL</td><td width="160" align="right">'.number_format($vew_inv->slsinvtotamt,2).'</td></tr>'.
							'</tbody></table>';
	$pdf->writeHTML($lv_buffer2);
	
	
	// OUTPUT
	$pdf->Output($vew_bus->bustxt.' - '.$vew_pos->argltrcodext.' '.$vew_inv->slsinvcodext, (($vew_getbuffer??'')==''?'I':'S') );	
?>
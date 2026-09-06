<?php
	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

	// ===========================================================
	// SUPUESTOS SOBRE EL MODELO DE DATOS
	// -----------------------------------------------------------
	// Ademas de lo que ya usaba el recibo original ($vew_data->txtprc,
	// $vew_data->grltxt, $vew_data->grltxt2, etc.) esta version agrega
	// tres bloques nuevos que necesitan que $vew_data traiga la
	// siguiente informacion. Si en tu view-model estos datos ya existen
	// con otro nombre, alcanza con ajustar las 3 lineas marcadas
	// "AJUSTAR AQUI" mas abajo; el resto del script no cambia.
	//
	// 1) $vew_data->txtprc_pat  (array) -> conceptos A CARGO DEL EMPLEADOR
	//    (ART, Contribucion Jubilacion, Contribucion OO.SS., Seguro de
	//    vida, conceptos derivados del CCT, etc). Mismo formato que
	//    txtprc:
	//      [
	//        'prccndtxt'      => 'ART',
	//        'prccndqty'      => 3,        // alicuota / cantidad
	//        'prccnduntcod'   => '%',      // unidad ('%','$', etc.)
	//        'prccndbas'      => '',       // base de calculo (opcional, texto)
	//        'prccndtot'      => 0,        // monto
	//        'prccndstd'      => '',       // si viene con algo, la fila no se imprime
	//      ]
	//
	// 2) $vew_data->txtres (array) -> renglones del cuadro final
	//    "Detalle de la composicion salarial":
	//      [ 'restxttxt' => 'Total Costo Sindical',   'resemp' => 0, 'restrab' => 0 ]
	//      [ 'restxttxt' => 'Total Seguridad Social',  'resemp' => 0, 'restrab' => 0 ]
	//      [ 'restxttxt' => 'Total Obra Social',       'resemp' => 0, 'restrab' => 0 ]
	//      [ 'restxttxt' => 'Total costo INSSJP',      'resemp' => 0, 'restrab' => 0 ]
	//      [ 'restxttxt' => 'Total costo ART',         'resemp' => 0, 'restrab' => 0 ]
	//      [ 'restxttxt' => 'Total Costo SCVO',         'resemp' => 0, 'restrab' => 0 ]
	//
	// 3) $vew_data->grftort (array) -> datos para el grafico de torta
	//    "Costo total empleador":
	//      [ 'grflbl' => 'Sueldo Neto',       'grfval' => 0 ]
	//      [ 'grflbl' => 'Seguridad Social',  'grfval' => 0 ]
	//      [ 'grflbl' => 'Costo Sindical',    'grfval' => 0 ]
	//      [ 'grflbl' => 'Obra Social',       'grfval' => 0 ]
	//      [ 'grflbl' => 'FAM',               'grfval' => 0 ]
	//      [ 'grflbl' => 'ART',               'grfval' => 0 ]
	// ===========================================================

	// create new PDF document (formato moderno, una columna, orientacion vertical)
	$pdf = new TCPDF('P', PDF_UNIT, 'A4', true, 'UTF-8', false);

	// remove default header/footer
	$pdf->setPrintHeader(false);
	$pdf->setPrintFooter(false);

	// set default monospaced font
	$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

	// set margins
	$pdf->SetMargins(15, 10, 15);

	// set auto page breaks
	$pdf->SetAutoPageBreak(TRUE, 10);

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

	// ---------------------------------------------------------
	// PALETA DE COLORES (moderna, tonos acordes al isologo de la empresa)
	// ---------------------------------------------------------
	$C_PRIMARY      = array(21, 87, 74);     // verde/teal oscuro - encabezados y textos fuertes
	$C_PRIMARY_SOFT = array(60, 130, 112);   // teal medio - detalles y lineas
	$C_ACCENT_BG    = array(232, 245, 240);  // fondo mint muy claro - tarjetas
	$C_TABLE_HEAD   = array(21, 87, 74);     // fondo encabezado de tabla
	$C_BAR_TITULO   = array(225, 232, 229);  // fondo de barras de titulo (COSTO TOTAL EMPLEADOR, etc.)
	$C_ZEBRA        = array(246, 250, 248);  // fila alterna clara
	$C_TEXT_DARK    = array(35, 40, 38);     // texto principal
	$C_TEXT_GRAY    = array(110, 116, 113);  // texto secundario
	$C_WHITE        = array(255, 255, 255);
	$C_BORDER       = array(222, 231, 227);  // lineas suaves

	// colores para el grafico de torta (6 categorias, igual orden que la leyenda)
	$C_CHART = array(
		array(31, 119, 180),   // Sueldo Neto
		array(214, 64, 69),    // Seguridad Social
		array(44, 160, 44),    // Costo Sindical
		array(148, 103, 189),  // Obra Social
		array(255, 143, 40),   // FAM
		array(23, 160, 150),   // ART
	);

	$lv_meses = array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');

	// dimensiones utiles de pagina
	$lv_margen_izq = 15;
	$lv_margen_der = 195; // ancho A4 210mm - 15mm margen derecho
	$lv_ancho_util = $lv_margen_der - $lv_margen_izq; // 180mm

	// ===========================================================
	// helper: barra de titulo con monto a la derecha
	// (se usa para COSTO TOTAL EMPLEADOR / SUB TOTAL CONTRIBUCIONES
	// EMPLEADOR / SUELDO BRUTO / SUELDO NETO)
	// ===========================================================
	function dibujar_barra_titulo(&$pdf, $x, $y, $w, $h, $titulo, $monto, $bg, $fg, $fontsize=9){
		$pdf->SetFillColor($bg[0], $bg[1], $bg[2]);
		$pdf->Rect($x, $y, $w, $h, 'F');
		$pdf->SetTextColor($fg[0], $fg[1], $fg[2]);
		$pdf->setfont('helvetica', 'B', $fontsize);
		$lv_monto_w = 35;
		$pdf->setxy($x, $y + ($h - $fontsize/2.83)/2 - 0.5);
		$pdf->Cell($w - $lv_monto_w, 0, $titulo, 0, 0, 'C');
		$pdf->setxy($x + $w - $lv_monto_w - 3, $y + ($h - $fontsize/2.83)/2 - 0.5);
		$pdf->Cell($lv_monto_w, 0, '$ '.number_format($monto,2), 0, 0, 'R');
	}

	// ===========================================================
	// helper: encabezado de tabla de 4 columnas (CONCEPTO / UNIDAD / BASE / MONTO)
	// usado para los conceptos a cargo del empleador
	// ===========================================================
	function dibujar_header_tabla4(&$pdf, $x, $y, $w, $col2, $col3, $col4, $bg, $fg){
		$pdf->SetFillColor($bg[0], $bg[1], $bg[2]);
		$pdf->Rect($x, $y, $w, 6, 'F');
		$pdf->SetTextColor($fg[0], $fg[1], $fg[2]);
		$pdf->setfont('helvetica', 'B', 7.5);
		//$pdf->text( $x + 2, $y + 4.2, 'CONCEPTO' );
		$pdf->text( $x + 2, $y + 1.3, 'CONCEPTO' );
		$pdf->setxy($col2 - 20, $y + 1.3); $pdf->Cell(20, 0, 'UNIDAD', 0, 0, 'R');
		$pdf->setxy($col3 - 30, $y + 1.3); $pdf->Cell(30, 0, 'BASE', 0, 0, 'R');
		$pdf->setxy($col4 - 24, $y + 1.3); $pdf->Cell(24, 0, 'MONTO', 0, 0, 'R');
	}

	// ===========================================================
	// helper: grafico de torta simple con leyenda (usa PieSector nativo de TCPDF)
	// ===========================================================
	function dibujar_grafico_torta(&$pdf, $xc, $yc, $r, $datos, $colores, $titulo,
									$C_TEXT_DARK, $C_TEXT_GRAY){
		$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
		$pdf->setfont('helvetica', 'B', 8.5);
		$pdf->text( $xc - $r, $yc - $r - 5, $titulo );

		$lv_suma = 0;
		foreach($datos as $lv_d){ $lv_suma += floatval($lv_d['grfval']); }
		if($lv_suma <= 0){ $lv_suma = 1; } // evita division por cero, no dibuja porciones reales

		$lv_ang = 0;
		$lv_i = 0;
		foreach($datos as $lv_d){
			$lv_pct = floatval($lv_d['grfval']) / $lv_suma;
			$lv_ang2 = $lv_ang + ($lv_pct * 360);
			$lv_col = isset($colores[$lv_i]) ? $colores[$lv_i] : array(180,180,180);
			$pdf->SetFillColor($lv_col[0], $lv_col[1], $lv_col[2]);
			$pdf->SetDrawColor(255,255,255);
			if($lv_ang2 > $lv_ang){
				$pdf->PieSector($xc, $yc, $r, $lv_ang, $lv_ang2, 'FD');
			}
			$lv_ang = $lv_ang2;
			$lv_i++;
		}

		// leyenda debajo del grafico
		$lv_ly = $yc + $r + 5;
		$lv_i = 0;
		foreach($datos as $lv_d){
			$lv_col = isset($colores[$lv_i]) ? $colores[$lv_i] : array(180,180,180);
			$pdf->SetFillColor($lv_col[0], $lv_col[1], $lv_col[2]);
			$pdf->Rect($xc - $r, $lv_ly, 2.6, 2.6, 'F');
			$pdf->SetTextColor($C_TEXT_GRAY[0], $C_TEXT_GRAY[1], $C_TEXT_GRAY[2]);
			$pdf->setfont('helvetica', '', 6.8);
			$pdf->text( $xc - $r + 4, $lv_ly + 2.3, $lv_d['grflbl'] );
			$lv_ly += 3.6;
			$lv_i++;
		}
	}

	// ===========================================================
	// armado principal del recibo (una sola pagina)
	// ===========================================================
	function pintar_recibo(&$pdf, $vew_data, $vew_doc, $lv_meses, $lv_margen_izq, $lv_margen_der, $lv_ancho_util,
							$C_PRIMARY, $C_PRIMARY_SOFT, $C_ACCENT_BG, $C_TABLE_HEAD, $C_BAR_TITULO, $C_ZEBRA,
							$C_TEXT_DARK, $C_TEXT_GRAY, $C_WHITE, $C_BORDER, $C_CHART){

		$pdf->AddPage();

		// -------------------------------------------------------
		// Franja superior de color (detalle moderno)
		// -------------------------------------------------------
		$pdf->SetFillColor($C_PRIMARY[0], $C_PRIMARY[1], $C_PRIMARY[2]);
		$pdf->Rect(0, 0, 210, 3.5, 'F');

		// -------------------------------------------------------
		// Encabezado: logo + datos de la empresa
		// -------------------------------------------------------
		$lv_y0 = 10;
		//if($vew_data->bus->busimg!=''){$pdf->Image('@'.$vew_data->bus->busimg, $lv_margen_izq, $lv_y0, 14);}
		$pdf->Image('library/images/logos/zcutms_temasisargentina2.jpg', $lv_margen_izq, $lv_y0, 14);

		$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
		$pdf->setfont('helvetica', 'B', 10.5);
		$pdf->text( $lv_margen_izq + 18, $lv_y0 + 1, $vew_data->bus->bustxt );

		$pdf->SetTextColor($C_TEXT_GRAY[0], $C_TEXT_GRAY[1], $C_TEXT_GRAY[2]);
		$pdf->setfont('helvetica', '', 7.5);
		$pdf->text( $lv_margen_izq + 18, $lv_y0 + 5.5,
			$vew_data->bus->adr->adrstr.
			($vew_data->bus->adr->adrstrnum!=''?' '.$vew_data->bus->adr->adrstrnum:'').
			($vew_data->bus->adr->adrstrflr!=''?' Pso.'.$vew_data->bus->adr->adrstrflr:'').
			' Dto.'.$vew_data->bus->adr->adrstrunt
		);
		$pdf->text( $lv_margen_izq + 18, $lv_y0 + 9, ucwords(strtolower($vew_data->bus->adr->lndregtxt)) );
		$pdf->text( $lv_margen_izq + 18, $lv_y0 + 12.5, ucwords(strtolower($vew_data->bus->tax->taxcattxt)) );
		$pdf->text( $lv_margen_izq + 18, $lv_y0 + 16,
			$vew_data->bus->tax->idttyptxt.': '.
			substr($vew_data->bus->tax->taxcod,0,2).'-'.substr($vew_data->bus->tax->taxcod,2,8).'-'.substr($vew_data->bus->tax->taxcod,10,1)
		);

		// -------------------------------------------------------
		// Insignia "RECIBO N°" (arriba a la derecha)
		// -------------------------------------------------------
		$lv_badge_w = 58;
		$lv_badge_x = $lv_margen_der - $lv_badge_w;
		$pdf->RoundedRect($lv_badge_x, $lv_y0, $lv_badge_w, 9.5, 2, '1111', 'F', array(), $C_PRIMARY);
		$pdf->SetTextColor($C_WHITE[0], $C_WHITE[1], $C_WHITE[2]);
		$pdf->setfont('helvetica', 'B', 11);
		$pdf->setxy($lv_badge_x, $lv_y0 + 2.3);
		$pdf->Cell($lv_badge_w, 0, 'RECIBO de SUELDO N° '.$vew_data->hhrlqdcod, 0, 0, 'C');

		// -------------------------------------------------------
		// Recuadro "PERIODO DE PAGO"
		// -------------------------------------------------------
		$pdf->RoundedRect($lv_badge_x, $lv_y0 + 11.5, $lv_badge_w, 11.5, 2, '1111', 'F', array(), $C_ACCENT_BG);
		$pdf->SetTextColor($C_PRIMARY[0], $C_PRIMARY[1], $C_PRIMARY[2]);
		$pdf->setfont('helvetica', 'B', 7.5);
		$pdf->setxy($lv_badge_x, $lv_y0 + 13.2);
		$pdf->Cell($lv_badge_w, 0, 'PERIODO DE PAGO', 0, 0, 'C');
		$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
		$pdf->setfont('helvetica', '', 8.5);
		$pdf->setxy($lv_badge_x, $lv_y0 + 17.5);
		$pdf->Cell($lv_badge_w, 0, $lv_meses[ intval($vew_data->hhrlqdstrdte->format('m'))-1 ].' de '.$vew_data->hhrlqdstrdte->format('Y'), 0, 0, 'C');

		// -------------------------------------------------------
		// Tarjeta con datos del empleado
		// -------------------------------------------------------
		$lv_card_y = $lv_y0 + 26;
		$lv_card_h = 22;
		$pdf->RoundedRect($lv_margen_izq, $lv_card_y, $lv_ancho_util, $lv_card_h, 2, '1111', 'F', array(), $C_ACCENT_BG);

		$lv_chratr = $vew_doc->getTagValue($vew_data->hhrlqdatr001,'chratr');

		$pdf->SetTextColor($C_PRIMARY[0], $C_PRIMARY[1], $C_PRIMARY[2]);
		$pdf->setfont('helvetica', 'B', 9.5);
		$pdf->text( $lv_margen_izq + 4, $lv_card_y + 4.5, utf8_encode($vew_doc->getTagValue($vew_data->hhrlqdatr001,'srcobjtxt')) );

		$pdf->SetTextColor($C_TEXT_GRAY[0], $C_TEXT_GRAY[1], $C_TEXT_GRAY[2]);
		$pdf->setfont('helvetica', '', 7.5);
		$pdf->text( $lv_margen_izq + 4, $lv_card_y + 8.5, $vew_data->chrasg->hhrchrtyptxt );

		$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
		$pdf->setfont('helvetica', '', 7.5);
		$pdf->text( $lv_margen_izq + 4,  $lv_card_y + 13, 'Ingreso: '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'empstrdte') );
		$pdf->text( $lv_margen_izq + 4,  $lv_card_y + 17, 'Egreso: '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'empenddte') );
		$pdf->text( $lv_margen_izq + 55, $lv_card_y + 13, 'Alta Cargo: '.$vew_data->chrasg->hhrchrasgdtestr->format('d.m.Y') );
		$pdf->text( $lv_margen_izq + 55, $lv_card_y + 17, 'Baja Cargo: '.($vew_data->chrasg->hhrchrasgdteend instanceof DateTime ? $vew_data->chrasg->hhrchrasgdteend->format('d.m.Y') : '') );

		$pdf->text( $lv_margen_izq + 110, $lv_card_y + 4.5,  $vew_data->emp->tax->idttyptxt.': '.$vew_data->emp->tax->taxdocnum );
		$pdf->text( $lv_margen_izq + 110, $lv_card_y + 8.5, 'Legajo: '.$vew_data->srcobjcod001 );
		$pdf->text( $lv_margen_izq + 110, $lv_card_y + 13, 'Antiguedad: '.$vew_doc->getTagValue($lv_chratr,'oldyth').'.'.$vew_doc->getTagValue($lv_chratr,'oldmth') );

		// =========================================================
		// PASO 1: pre-calculo de totales (para poder mostrar las
		// barras de titulo ANTES de imprimir el detalle de cada tabla)
		// =========================================================
		$lv_tot_pat = 0; // costo total de contribuciones patronales
		$lv_pat_rows = isset($vew_data->txtprc_pat) ? $vew_data->txtprc_pat : array();
		foreach($lv_pat_rows as $lv_row){
			if($lv_row['prccndtot']==0 || (isset($lv_row['prccndstd']) && $lv_row['prccndstd']!='')){ continue; }
			$lv_tot_pat += $lv_row['prccndtot'];
		}

		$lv_tot_rem = 0; $lv_tot_des = 0; $lv_tot_nre = 0;
		$lv_col_calc = 0;
		foreach($vew_data->txtprc as $lv_row){
			if($lv_row['prccndcatcodext']=='REM'){ $lv_col_calc=1; }
			if($lv_row['prccndcatcodext']=='DESC'){ $lv_col_calc=2; }
			if($lv_row['prccndcatcodext']=='NREM'){ $lv_col_calc=3; }
			if($lv_row['prccndtot']==0 || $lv_row['prccndstd']!=''){ continue; }
			if($lv_col_calc==1){ $lv_tot_rem += $lv_row['prccndtot']; }
			else if($lv_col_calc==2){ $lv_tot_des += $lv_row['prccndtot']; }
			else { $lv_tot_nre += $lv_row['prccndtot']; }
		}
		$lv_tot_neto = $lv_tot_rem - $lv_tot_des + $lv_tot_nre;
		$lv_costo_tot_empleador = $lv_tot_rem + $lv_tot_nre + $lv_tot_pat;

		// columnas comunes para las tablas de 4 y de 3 columnas de montos
		$lv_col_concepto = $lv_margen_izq + 2;
		$lv_col_a_r = $lv_margen_izq + 112; $lv_col_a_w = 24; // UNIDAD / CANT.
		$lv_col_b_r = $lv_margen_izq + 145; $lv_col_b_w = 30; // BASE / REMUN.
		$lv_col_c_r = $lv_margen_der - 2;   $lv_col_c_w = 30; // MONTO / DESC. / NO REMUN.

		$lv_y = $lv_card_y + $lv_card_h + 4;

		// =========================================================
		// BLOQUE 2: SUELDO BRUTO + detalle de conceptos del empleado
		// (remunerativos / descuentos / no remunerativos)
		// =========================================================
		dibujar_barra_titulo($pdf, $lv_margen_izq, $lv_y, $lv_ancho_util, 6, 'SUELDO BRUTO', $lv_tot_rem, $C_BAR_TITULO, $C_TEXT_DARK);
		$lv_y += 8;

		$pdf->SetFillColor($C_TABLE_HEAD[0], $C_TABLE_HEAD[1], $C_TABLE_HEAD[2]);
		$pdf->Rect($lv_margen_izq, $lv_y, $lv_ancho_util, 6, 'F');
		$pdf->SetTextColor($C_WHITE[0], $C_WHITE[1], $C_WHITE[2]);
		$pdf->setfont('helvetica', 'B', 7.5);
		//$pdf->text( $lv_col_concepto, $lv_y + 4.2, 'CONCEPTOS' );
		$pdf->text( $lv_col_concepto, $lv_y + 1.3, 'CONCEPTOS' );
		$pdf->setxy($lv_col_a_r - $lv_col_a_w, $lv_y + 1.3); $pdf->Cell($lv_col_a_w, 0, 'UNIDAD', 0, 0, 'R');
		$pdf->setxy($lv_col_b_r - $lv_col_b_w, $lv_y + 1.3); $pdf->Cell($lv_col_b_w, 0, 'BASE', 0, 0, 'R');
		$pdf->setxy($lv_col_c_r - $lv_col_c_w, $lv_y + 1.3); $pdf->Cell($lv_col_c_w, 0, 'MONTO', 0, 0, 'R');
		$lv_y += 6;

		$pdf->setfont('helvetica', '', 7.5);
		$lv_idx = 0;
		$lv_col = 0;
		foreach($vew_data->txtprc as $lv_row){
			if($lv_row['prccndcatcodext']=='REM'){ $lv_col=1; }
			if($lv_row['prccndcatcodext']=='DESC'){ $lv_col=2; }
			if($lv_row['prccndcatcodext']=='NREM'){ $lv_col=3; }
			if($lv_row['prccndtot']==0 || $lv_row['prccndstd']!=''){ continue; }

			if($lv_idx % 2 == 0){
				$pdf->SetFillColor($C_ZEBRA[0], $C_ZEBRA[1], $C_ZEBRA[2]);
				$pdf->Rect($lv_margen_izq, $lv_y, $lv_ancho_util, $lv_row_h, 'F');
			}

			$lv_txt = htmlentities($lv_row['prccndtxt']);
			$lv_txt = str_ireplace('&igrave;','U',$lv_txt);
			$lv_txt = ucwords(strtolower($lv_txt));
			if($lv_row['prccndcodext']=='OOSS'){ $lv_txt.= ' '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'medcovcodext'); }

			$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
			$pdf->text( $lv_col_concepto, $lv_y + $lv_row_h - 1.4, $lv_txt );

			if($lv_row['prccndqty']!=0){
				$pdf->setxy($lv_col_a_r - $lv_col_a_w, $lv_y + 0.7);
				$pdf->Cell($lv_col_a_w, 0, number_format($lv_row['prccndqty'],2).' '.strtolower($lv_row['prccnduntcod']), 0, 0, 'R');
			}

			if($lv_col==1 || $lv_col==2){
				$pdf->setxy($lv_col_b_r - $lv_col_b_w, $lv_y + 0.7);
				$pdf->Cell($lv_col_b_w, 0, ($lv_col==2?'-':'').number_format($lv_row['prccndtot'],2), 0, 0, 'R');
			} else {
				$pdf->setxy($lv_col_c_r - $lv_col_c_w, $lv_y + 0.7);
				$pdf->Cell($lv_col_c_w, 0, number_format($lv_row['prccndtot'],2), 0, 0, 'R');
			}

			$lv_y += $lv_row_h;
			$lv_idx += 1;
		}

		$pdf->SetDrawColor($C_BORDER[0], $C_BORDER[1], $C_BORDER[2]);
		$pdf->line( $lv_margen_izq, $lv_y, $lv_margen_der, $lv_y );
		$lv_y += 2;


		// =========================================================
		// BLOQUE 1: COSTO TOTAL EMPLEADOR + detalle de contribuciones
		// =========================================================
		dibujar_barra_titulo($pdf, $lv_margen_izq, $lv_y, $lv_ancho_util, 6, 'COSTO TOTAL EMPLEADOR', $lv_costo_tot_empleador, $C_BAR_TITULO, $C_TEXT_DARK);
		$lv_y += 8;

		dibujar_header_tabla4($pdf, $lv_margen_izq, $lv_y, $lv_ancho_util, $lv_col_a_r, $lv_col_b_r, $lv_col_c_r, $C_TABLE_HEAD, $C_WHITE);
		$lv_y += 6;

		$pdf->setfont('helvetica', '', 7.5);
		$lv_row_h = 4.6;
		$lv_idx = 0;
		foreach($lv_pat_rows as $lv_row){
			if($lv_row['prccndtot']==0 && (!isset($lv_row['prccndqty']) || $lv_row['prccndqty']==0) && (empty($lv_row['prccndtxt']))){ continue; }
			if(isset($lv_row['prccndstd']) && $lv_row['prccndstd']!=''){ continue; }

			if($lv_idx % 2 == 0){
				$pdf->SetFillColor($C_ZEBRA[0], $C_ZEBRA[1], $C_ZEBRA[2]);
				$pdf->Rect($lv_margen_izq, $lv_y, $lv_ancho_util, $lv_row_h, 'F');
			}
			$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
			$pdf->text( $lv_col_concepto, $lv_y + $lv_row_h - 1.4, $lv_row['prccndtxt'] );

			if(!empty($lv_row['prccndqty'])){
				$pdf->setxy($lv_col_a_r - $lv_col_a_w, $lv_y + 0.7);
				$pdf->Cell($lv_col_a_w, 0, number_format($lv_row['prccndqty'],2).($lv_row['prccnduntcod']=='%'?'%':' '.$lv_row['prccnduntcod']), 0, 0, 'R');
			}
			if(!empty($lv_row['prccndbas'])){
				$pdf->setxy($lv_col_b_r - $lv_col_b_w, $lv_y + 0.7);
				$pdf->Cell($lv_col_b_w, 0, $lv_row['prccndbas'], 0, 0, 'R');
			}
			if(!empty($lv_row['prccndtot'])){
				$pdf->setxy($lv_col_c_r - $lv_col_c_w, $lv_y + 0.7);
				$pdf->Cell($lv_col_c_w, 0, '$ '.number_format($lv_row['prccndtot'],2), 0, 0, 'R');
			}
			$lv_y += $lv_row_h;
			$lv_idx++;
		}
		if($lv_idx==0){ $lv_y += $lv_row_h; } // deja aire si no hay filas patronales cargadas

		$pdf->SetDrawColor($C_BORDER[0], $C_BORDER[1], $C_BORDER[2]);
		$pdf->line( $lv_margen_izq, $lv_y, $lv_margen_der, $lv_y );
		$lv_y += 2;

		dibujar_barra_titulo($pdf, $lv_margen_izq, $lv_y, $lv_ancho_util, 6, 'SUB TOTAL CONTRIBUCIONES EMPLEADOR', $lv_tot_pat, $C_ACCENT_BG, $C_PRIMARY);
		$lv_y += 9;


		// -------------------------------------------------------
		// COMPOSICION SALARIAL (remunerativo / no remunerativo / descuentos)
		// -------------------------------------------------------
		$pdf->SetFillColor($C_ACCENT_BG[0], $C_ACCENT_BG[1], $C_ACCENT_BG[2]);
		$pdf->Rect($lv_margen_izq, $lv_y, $lv_ancho_util, 6, 'F');
		$pdf->SetTextColor($C_PRIMARY[0], $C_PRIMARY[1], $C_PRIMARY[2]);
		$pdf->setfont('helvetica', 'B', 7.5);
		$pdf->text( $lv_col_concepto, $lv_y + 4.2, 'COMPOSICION SALARIAL:' );
		$pdf->setfont('helvetica', '', 7.5);
		$pdf->text( $lv_margen_izq + 55, $lv_y + 4.2, 'Remunerativo: $ '.number_format($lv_tot_rem,2) );
		$pdf->text( $lv_margen_izq + 100, $lv_y + 4.2, 'No Remunerativo: $ '.number_format($lv_tot_nre,2) );
		$pdf->text( $lv_margen_izq + 148, $lv_y + 4.2, 'Descuentos: $ '.number_format($lv_tot_des,2) );
		$lv_y += 7;

		dibujar_barra_titulo($pdf, $lv_margen_izq, $lv_y, $lv_ancho_util, 6.5, 'SUELDO NETO', $lv_tot_neto, $C_PRIMARY, $C_WHITE, 9.5);
		$lv_y += 10;

		// =========================================================
		// BLOQUE 3: detalle final de la composicion salarial + grafico
		// =========================================================
		$pdf->SetDrawColor($C_BORDER[0], $C_BORDER[1], $C_BORDER[2]);
		$pdf->line( $lv_margen_izq, $lv_y, $lv_margen_der, $lv_y );
		$lv_y += 4;

		$pdf->SetTextColor($C_PRIMARY[0], $C_PRIMARY[1], $C_PRIMARY[2]);
		$pdf->setfont('helvetica', 'BU', 8.5);
		$pdf->text( $lv_margen_izq, $lv_y, 'Detalle de la composicion salarial' );
		$lv_y += 5;

		$lv_res_rows = isset($vew_data->txtres) ? $vew_data->txtres : array();
		$lv_mitad = ceil(count($lv_res_rows)/2);
		$lv_col_izq = array_slice($lv_res_rows, 0, $lv_mitad);
		$lv_col_der = array_slice($lv_res_rows, $lv_mitad);

		$lv_x_col2 = $lv_margen_izq + 95;
		$lv_y_res_start = $lv_y;
		$lv_y_izq = $lv_y_res_start;
		foreach($lv_col_izq as $lv_row){
			$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
			$pdf->setfont('helvetica', 'B', 7.5);
			$pdf->text( $lv_margen_izq, $lv_y_izq, $lv_row['restxttxt'].':' );
			$pdf->setxy($lv_margen_izq + 55, $lv_y_izq - 3); $pdf->Cell(35, 0, '$ '.number_format($lv_row['resemp']+$lv_row['restrab'],2), 0, 0, 'R');
			$pdf->setfont('helvetica', '', 7);
			$pdf->text( $lv_margen_izq, $lv_y_izq + 3.5, 'Empleador: $ '.number_format($lv_row['resemp'],2) );
			$pdf->text( $lv_margen_izq, $lv_y_izq + 7, 'Trabajador: $ '.number_format($lv_row['restrab'],2) );
			$lv_y_izq += 12;
		}
		$lv_y_der = $lv_y_res_start;
		foreach($lv_col_der as $lv_row){
			$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
			$pdf->setfont('helvetica', 'B', 7.5);
			$pdf->text( $lv_x_col2, $lv_y_der, $lv_row['restxttxt'].':' );
			$pdf->setxy($lv_x_col2 + 45, $lv_y_der - 3); $pdf->Cell(35, 0, '$ '.number_format($lv_row['resemp']+$lv_row['restrab'],2), 0, 0, 'R');
			$pdf->setfont('helvetica', '', 7);
			$pdf->text( $lv_x_col2, $lv_y_der + 3.5, 'Empleador: $ '.number_format($lv_row['resemp'],2) );
			$pdf->text( $lv_x_col2, $lv_y_der + 7, 'Trabajador: $ '.number_format($lv_row['restrab'],2) );
			$lv_y_der += 12;
		}

		// grafico de torta "Costo total empleador" a la derecha
		$lv_graf_datos = isset($vew_data->grftort) ? $vew_data->grftort : array();
		if(count($lv_graf_datos) > 0){
			dibujar_grafico_torta($pdf, $lv_margen_der - 20, $lv_y_res_start + 20, 14, $lv_graf_datos, $C_CHART,
				'Costo total empleador', $C_TEXT_DARK, $C_TEXT_GRAY);
		}

		$lv_y = max($lv_y_izq, $lv_y_der, ($lv_y_res_start + 20 + 14 + 5 + count($lv_graf_datos)*3.6)) + 2;

		$pdf->SetTextColor($C_TEXT_GRAY[0], $C_TEXT_GRAY[1], $C_TEXT_GRAY[2]);
		$pdf->setfont('helvetica', 'I', 6.8);
		$pdf->text( $lv_margen_izq, $lv_y, 'Nota: Seguridad social del empleador incluye SIPA, Fondo Nacional de Empleo y Asignaciones Familiares.' );
		$lv_y += 6;

		// -------------------------------------------------------
		// Leyendas del recibo (si hay espacio, se muestran compactas)
		// -------------------------------------------------------
		foreach($vew_data->grltxt as $lv_row){
			if( $lv_row['txttypcodext']=='HHRLEYREC'){
				$pdf->SetTextColor($C_TEXT_GRAY[0], $C_TEXT_GRAY[1], $C_TEXT_GRAY[2]);
				$pdf->writeHTMLcell( $lv_ancho_util, 10, $lv_margen_izq, $lv_y, utf8_decode(html_entity_decode($lv_row['txttxt'])) );
				$lv_y += 10;
			}
		}
		foreach($vew_data->grltxt2 as $lv_row){
			if( $lv_row['txttypcodext']=='HHRLEYREC'){
				$pdf->writeHTMLcell( $lv_ancho_util, 8, $lv_margen_izq, $lv_y, utf8_decode(html_entity_decode($lv_row['txttxt'])) );
				$lv_y += 8;
			}
		}

		// -------------------------------------------------------
		// Lugar/fecha de pago + importe en palabras
		// -------------------------------------------------------
		$pdf->SetTextColor($C_TEXT_GRAY[0], $C_TEXT_GRAY[1], $C_TEXT_GRAY[2]);
		$pdf->setfont('helvetica', 'B', 7.5);
		$pdf->text( $lv_margen_izq, $lv_y, 'LUGAR y FECHA PAGO:' );
		$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
		$pdf->setfont('helvetica', '', 7.5);
		$pdf->text( $lv_margen_izq + 40, $lv_y, $vew_data->emp->bnk->bnktxt );
		$lv_y += 5;

		$lv_num = round( $lv_tot_neto, 2 );
		$pdf->SetTextColor($C_TEXT_GRAY[0], $C_TEXT_GRAY[1], $C_TEXT_GRAY[2]);
		$pdf->setfont('helvetica', 'I', 7.5);
		$pdf->text( $lv_margen_izq, $lv_y, ucfirst(strtolower($vew_doc->numberToWords( $lv_num, '', 'CENTAVOS' ))) );
		$lv_y += 6;

		// -------------------------------------------------------
		// Constancia y firmas
		// -------------------------------------------------------
		$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
		$pdf->setfont('helvetica', '', 7.5);
		$pdf->text( $lv_margen_izq, $lv_y,      'RECIBI CONFORME EN CONCEPTO DE MI REMUNERACION CORRESPONDIENTE' );
		$pdf->text( $lv_margen_izq, $lv_y + 3.2, 'AL PERIODO ARRIBA INDICADO Y DUPLICADO DE LA MISMA' );

		$lv_y_firma = $lv_y + 12;
		$pdf->SetDrawColor($C_PRIMARY[0], $C_PRIMARY[1], $C_PRIMARY[2]);
		$lv_firma1_x1 = $lv_margen_izq + 90; $lv_firma1_x2 = $lv_margen_der;
		$lv_firma_mid = ($lv_firma1_x1 + $lv_firma1_x2) / 2;

		$pdf->line( $lv_firma1_x1, $lv_y_firma, $lv_firma_mid - 2, $lv_y_firma );
		$pdf->line( $lv_firma_mid + 2, $lv_y_firma, $lv_firma1_x2, $lv_y_firma );

		$pdf->setfont('helvetica', 'B', 7);
		$pdf->setxy($lv_firma1_x1, $lv_y_firma + 1.5);
		$pdf->Cell($lv_firma_mid - 2 - $lv_firma1_x1, 0, 'FIRMA DEL EMPLEADO', 0, 0, 'C');
		$pdf->setxy($lv_firma_mid + 2, $lv_y_firma + 1.5);
		$pdf->Cell($lv_firma1_x2 - ($lv_firma_mid + 2), 0, 'Firma del Empleador / Rep.Legal', 0, 0, 'C');
	}

	// ---------------------------------------------------------
	// Ejecuta el armado del recibo
	// ---------------------------------------------------------
	pintar_recibo($pdf, $vew_data, $vew_doc, $lv_meses, $lv_margen_izq, $lv_margen_der, $lv_ancho_util,
		$C_PRIMARY, $C_PRIMARY_SOFT, $C_ACCENT_BG, $C_TABLE_HEAD, $C_BAR_TITULO, $C_ZEBRA,
		$C_TEXT_DARK, $C_TEXT_GRAY, $C_WHITE, $C_BORDER, $C_CHART);

	$pdf->Output('recibo.pdf', 'I');
?>

<?php
/*
	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

	// create new PDF document (formato moderno, una columna, orientacion vertical)
	$pdf = new TCPDF('P', PDF_UNIT, 'A4', true, 'UTF-8', false);

	// remove default header/footer
	$pdf->setPrintHeader(false);
	$pdf->setPrintFooter(false);

	// set default monospaced font
	$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

	// set margins
	$pdf->SetMargins(15, 12, 15);

	// set auto page breaks
	$pdf->SetAutoPageBreak(TRUE, 12);

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

	// ---------------------------------------------------------
	// PALETA DE COLORES (moderna, tonos acordes al isologo de la empresa)
	// ---------------------------------------------------------
	$C_PRIMARY      = array(21, 87, 74);     // verde/teal oscuro - encabezados y textos fuertes
	$C_PRIMARY_SOFT = array(60, 130, 112);   // teal medio - detalles y lineas
	$C_ACCENT_BG    = array(232, 245, 240);  // fondo mint muy claro - tarjetas
	$C_TABLE_HEAD   = array(21, 87, 74);     // fondo encabezado de tabla
	$C_ZEBRA        = array(246, 250, 248);  // fila alterna clara
	$C_TEXT_DARK    = array(35, 40, 38);     // texto principal
	$C_TEXT_GRAY    = array(110, 116, 113);  // texto secundario
	$C_WHITE        = array(255, 255, 255);
	$C_BORDER       = array(222, 231, 227);  // lineas suaves

	$lv_meses = array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');

	// dimensiones utiles de pagina
	$lv_margen_izq = 15;
	$lv_margen_der = 195; // ancho A4 210mm - 15mm margen derecho
	$lv_ancho_util = $lv_margen_der - $lv_margen_izq; // 180mm

	// ===========================================================
	// helper local para no repetir codigo del recibo (se llama 1 sola vez
	// pero queda modularizado por si en el futuro se necesita reimprimir)
	// ===========================================================
	function pintar_recibo(&$pdf, $vew_data, $vew_doc, $lv_meses, $lv_margen_izq, $lv_margen_der, $lv_ancho_util,
							$C_PRIMARY, $C_PRIMARY_SOFT, $C_ACCENT_BG, $C_TABLE_HEAD, $C_ZEBRA, $C_TEXT_DARK, $C_TEXT_GRAY, $C_WHITE, $C_BORDER){

		$pdf->AddPage();

		// -------------------------------------------------------
		// Franja superior de color (detalle moderno)
		// -------------------------------------------------------
		$pdf->SetFillColor($C_PRIMARY[0], $C_PRIMARY[1], $C_PRIMARY[2]);
		$pdf->Rect(0, 0, 210, 4, 'F');

		// -------------------------------------------------------
		// Encabezado: logo + datos de la empresa
		// -------------------------------------------------------
		$lv_y0 = 12;
		//if($vew_data->bus->busimg!=''){$pdf->Image('@'.$vew_data->bus->busimg, $lv_margen_izq, $lv_y0, 16);}
		$pdf->Image('library/images/logos/zcutms_temasisargentina2.jpg', $lv_margen_izq, $lv_y0, 16);

		$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
		$pdf->setfont('helvetica', 'B', 11);
		$pdf->text( $lv_margen_izq + 20, $lv_y0 + 1, $vew_data->bus->bustxt );

		$pdf->SetTextColor($C_TEXT_GRAY[0], $C_TEXT_GRAY[1], $C_TEXT_GRAY[2]);
		$pdf->setfont('helvetica', '', 8);
		$pdf->text( $lv_margen_izq + 20, $lv_y0 + 6,
			$vew_data->bus->adr->adrstr.
			($vew_data->bus->adr->adrstrnum!=''?' '.$vew_data->bus->adr->adrstrnum:'').
			($vew_data->bus->adr->adrstrflr!=''?' Pso.'.$vew_data->bus->adr->adrstrflr:'').
			' Dto.'.$vew_data->bus->adr->adrstrunt
		);
		$pdf->text( $lv_margen_izq + 20, $lv_y0 + 10, ucwords(strtolower($vew_data->bus->adr->lndregtxt)) );
		$pdf->text( $lv_margen_izq + 20, $lv_y0 + 14, ucwords(strtolower($vew_data->bus->tax->taxcattxt)) );
		$pdf->text( $lv_margen_izq + 20, $lv_y0 + 18,
			$vew_data->bus->tax->idttyptxt.': '.
			substr($vew_data->bus->tax->taxcod,0,2).'-'.substr($vew_data->bus->tax->taxcod,2,8).'-'.substr($vew_data->bus->tax->taxcod,10,1)
		);

		// -------------------------------------------------------
		// Insignia "RECIBO N°" (arriba a la derecha)
		// -------------------------------------------------------
		$lv_badge_w = 60;
		$lv_badge_x = $lv_margen_der - $lv_badge_w;
		$pdf->RoundedRect($lv_badge_x, $lv_y0, $lv_badge_w, 11, 2, '1111', 'F', array(), $C_PRIMARY);
		$pdf->SetTextColor($C_WHITE[0], $C_WHITE[1], $C_WHITE[2]);
		$pdf->setfont('helvetica', 'B', 12);
		$pdf->setxy($lv_badge_x, $lv_y0 + 3);
		$pdf->Cell($lv_badge_w, 0, 'RECIBO N° '.$vew_data->hhrlqdcod, 0, 0, 'C');

		// -------------------------------------------------------
		// Recuadro "PERIODO DE PAGO"
		// -------------------------------------------------------
		$pdf->RoundedRect($lv_badge_x, $lv_y0 + 14, $lv_badge_w, 13, 2, '1111', 'F', array(), $C_ACCENT_BG);
		$pdf->SetTextColor($C_PRIMARY[0], $C_PRIMARY[1], $C_PRIMARY[2]);
		$pdf->setfont('helvetica', 'B', 8);
		$pdf->setxy($lv_badge_x, $lv_y0 + 16);
		$pdf->Cell($lv_badge_w, 0, 'PERIODO DE PAGO', 0, 0, 'C');
		$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
		$pdf->setfont('helvetica', '', 9);
		$pdf->setxy($lv_badge_x, $lv_y0 + 21);
		$pdf->Cell($lv_badge_w, 0, $lv_meses[ intval($vew_data->hhrlqdstrdte->format('m'))-1 ].' de '.$vew_data->hhrlqdstrdte->format('Y'), 0, 0, 'C');

		// -------------------------------------------------------
		// Tarjeta con datos del empleado
		// -------------------------------------------------------
		$lv_card_y = $lv_y0 + 33;
		$lv_card_h = 28;
		$pdf->RoundedRect($lv_margen_izq, $lv_card_y, $lv_ancho_util, $lv_card_h, 2, '1111', 'F', array(), $C_ACCENT_BG);

		$lv_chratr = $vew_doc->getTagValue($vew_data->hhrlqdatr001,'chratr');

		$pdf->SetTextColor($C_PRIMARY[0], $C_PRIMARY[1], $C_PRIMARY[2]);
		$pdf->setfont('helvetica', 'B', 10);
		$pdf->text( $lv_margen_izq + 4, $lv_card_y + 5, utf8_encode($vew_doc->getTagValue($vew_data->hhrlqdatr001,'srcobjtxt')) );

		$pdf->SetTextColor($C_TEXT_GRAY[0], $C_TEXT_GRAY[1], $C_TEXT_GRAY[2]);
		$pdf->setfont('helvetica', '', 8);
		$pdf->text( $lv_margen_izq + 4, $lv_card_y + 10, $vew_data->chrasg->hhrchrtyptxt );

		$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
		$pdf->text( $lv_margen_izq + 4,  $lv_card_y + 15, 'Ingreso: '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'empstrdte') );
		$pdf->text( $lv_margen_izq + 4,  $lv_card_y + 19, 'Egreso: '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'empenddte') );
		$pdf->text( $lv_margen_izq + 55, $lv_card_y + 15, 'Alta Cargo: '.$vew_data->chrasg->hhrchrasgdtestr->format('d.m.Y') );
		$pdf->text( $lv_margen_izq + 55, $lv_card_y + 19, 'Baja Cargo: '.($vew_data->chrasg->hhrchrasgdteend instanceof DateTime ? $vew_data->chrasg->hhrchrasgdteend->format('d.m.Y') : '') );

		$pdf->text( $lv_margen_izq + 110, $lv_card_y + 5,  $vew_data->emp->tax->idttyptxt.': '.$vew_data->emp->tax->taxdocnum );
		$pdf->text( $lv_margen_izq + 110, $lv_card_y + 10, 'Legajo: '.$vew_data->srcobjcod001 );
		$pdf->text( $lv_margen_izq + 110, $lv_card_y + 15, 'Antiguedad: '.$vew_doc->getTagValue($lv_chratr,'oldyth').'.'.$vew_doc->getTagValue($lv_chratr,'oldmth') );

		// -------------------------------------------------------
		// Tabla de conceptos
		// -------------------------------------------------------
		$lv_col_concepto = $lv_margen_izq + 2;
		$lv_col_qty_r    = $lv_margen_izq + 112; // borde derecho columna cantidad
		$lv_col_qty_w    = 24;
		$lv_col_rem_r    = $lv_margen_izq + 136;
		$lv_col_rem_w    = 24;
		$lv_col_des_r    = $lv_margen_izq + 160;
		$lv_col_des_w    = 24;
		$lv_col_nre_r    = $lv_margen_der - 2;
		$lv_col_nre_w    = 32;

		$lv_tabla_y = $lv_card_y + $lv_card_h + 6;

		$pdf->SetFillColor($C_TABLE_HEAD[0], $C_TABLE_HEAD[1], $C_TABLE_HEAD[2]);
		$pdf->Rect($lv_margen_izq, $lv_tabla_y, $lv_ancho_util, 7, 'F');
		$pdf->SetTextColor($C_WHITE[0], $C_WHITE[1], $C_WHITE[2]);
		$pdf->setfont('helvetica', 'B', 8);
		$pdf->text( $lv_col_concepto, $lv_tabla_y + 4.8, 'CONCEPTOS' );
		$pdf->setxy($lv_col_qty_r - $lv_col_qty_w, $lv_tabla_y + 2); $pdf->Cell($lv_col_qty_w, 0, 'CANT.', 0, 0, 'R');
		$pdf->setxy($lv_col_rem_r - $lv_col_rem_w, $lv_tabla_y + 2); $pdf->Cell($lv_col_rem_w, 0, 'REMUN.', 0, 0, 'R');
		$pdf->setxy($lv_col_des_r - $lv_col_des_w, $lv_tabla_y + 2); $pdf->Cell($lv_col_des_w, 0, 'DESC.', 0, 0, 'R');
		$pdf->setxy($lv_col_nre_r - $lv_col_nre_w, $lv_tabla_y + 2); $pdf->Cell($lv_col_nre_w, 0, 'NO REMUN.', 0, 0, 'R');

		$pdf->setfont('helvetica', '', 8);
		$lv_row_h  = 6;
		$lv_y      = $lv_tabla_y + 7;
		$lv_idx    = 0;
		$lv_col    = 0;
		$lv_tot_rem = 0;
		$lv_tot_des = 0;
		$lv_tot_nre = 0;

		foreach($vew_data->txtprc as $lv_row){
			if($lv_row['prccndcatcodext']=='REM'){ $lv_col=1; }
			if($lv_row['prccndcatcodext']=='DESC'){ $lv_col=2; }
			if($lv_row['prccndcatcodext']=='NREM'){ $lv_col=3; }
			if($lv_row['prccndtot']==0 || $lv_row['prccndstd']!=''){ continue; }

			// fila cebra
			if($lv_idx % 2 == 0){
				$pdf->SetFillColor($C_ZEBRA[0], $C_ZEBRA[1], $C_ZEBRA[2]);
				$pdf->Rect($lv_margen_izq, $lv_y, $lv_ancho_util, $lv_row_h, 'F');
			}

			$lv_txt = htmlentities($lv_row['prccndtxt']);
			$lv_txt = str_ireplace('&igrave;','U',$lv_txt);
			$lv_txt = ucwords(strtolower($lv_txt));
			if($lv_row['prccndcodext']=='OOSS'){ $lv_txt.= ' '.$vew_doc->getTagValue($vew_data->hhrlqdatr001,'medcovcodext'); }

			$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
			$pdf->text( $lv_col_concepto, $lv_y + $lv_row_h - 1.8, $lv_txt );

			if($lv_row['prccndqty']!=0){
				$pdf->setxy($lv_col_qty_r - $lv_col_qty_w, $lv_y + 1);
				$pdf->Cell($lv_col_qty_w, 0, number_format($lv_row['prccndqty'],2).' '.strtolower($lv_row['prccnduntcod']), 0, 0, 'R');
			}

			if($lv_col==1){
				$lv_tot_rem+=$lv_row['prccndtot'];
				$pdf->setxy($lv_col_rem_r - $lv_col_rem_w, $lv_y + 1);
				$pdf->Cell($lv_col_rem_w, 0, number_format($lv_row['prccndtot'],2), 0, 0, 'R');
			} else if($lv_col==2){
				$lv_tot_des+=$lv_row['prccndtot'];
				$pdf->setxy($lv_col_des_r - $lv_col_des_w, $lv_y + 1);
				$pdf->Cell($lv_col_des_w, 0, number_format($lv_row['prccndtot'],2), 0, 0, 'R');
			} else {
				$lv_tot_nre+=$lv_row['prccndtot'];
				$pdf->setxy($lv_col_nre_r - $lv_col_nre_w, $lv_y + 1);
				$pdf->Cell($lv_col_nre_w, 0, number_format($lv_row['prccndtot'],2), 0, 0, 'R');
			}

			$lv_y   += $lv_row_h;
			$lv_idx += 1;
		}

		// linea de cierre de la tabla
		$pdf->SetDrawColor($C_BORDER[0], $C_BORDER[1], $C_BORDER[2]);
		$pdf->line( $lv_margen_izq, $lv_y, $lv_margen_der, $lv_y );

		// -------------------------------------------------------
		// Leyendas del recibo
		// -------------------------------------------------------
		$lv_y_leyenda = $lv_y + 4;
		$pdf->SetTextColor($C_TEXT_GRAY[0], $C_TEXT_GRAY[1], $C_TEXT_GRAY[2]);
		foreach($vew_data->grltxt as $lv_row){
			if( $lv_row['txttypcodext']=='HHRLEYREC'){
				$pdf->writeHTMLcell( $lv_ancho_util, 20, $lv_margen_izq, $lv_y_leyenda, utf8_decode(html_entity_decode($lv_row['txttxt'])) );
			}
		}
		$lv_y_leyenda += 20;
		foreach($vew_data->grltxt2 as $lv_row){
			if( $lv_row['txttypcodext']=='HHRLEYREC'){
				$pdf->writeHTMLcell( $lv_ancho_util, 16, $lv_margen_izq, $lv_y_leyenda, utf8_decode(html_entity_decode($lv_row['txttxt'])) );
			}
		}

		// -------------------------------------------------------
		// Subtotales y total neto
		// -------------------------------------------------------
		$lv_tot = $lv_tot_rem - $lv_tot_des + $lv_tot_nre;
		$lv_y_sub = 235;

		$pdf->SetDrawColor($C_BORDER[0], $C_BORDER[1], $C_BORDER[2]);
		$pdf->line( $lv_margen_izq, $lv_y_sub, $lv_margen_der, $lv_y_sub );

		$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
		$pdf->setfont('helvetica', 'B', 9);
		$pdf->text( $lv_col_concepto, $lv_y_sub + 5, 'SUBTOTALES' );
		$pdf->setxy($lv_col_rem_r - $lv_col_rem_w, $lv_y_sub + 2); $pdf->Cell($lv_col_rem_w, 0, number_format($lv_tot_rem,2), 0, 0, 'R');
		$pdf->setxy($lv_col_des_r - $lv_col_des_w, $lv_y_sub + 2); $pdf->Cell($lv_col_des_w, 0, number_format($lv_tot_des,2), 0, 0, 'R');
		$pdf->setxy($lv_col_nre_r - $lv_col_nre_w, $lv_y_sub + 2); $pdf->Cell($lv_col_nre_w, 0, number_format($lv_tot_nre,2), 0, 0, 'R');

		// recuadro destacado TOTAL NETO
		$lv_y_total = $lv_y_sub + 10;
		$lv_total_box_w = 65;
		$lv_total_box_x = $lv_margen_der - $lv_total_box_w;
		$pdf->RoundedRect($lv_total_box_x, $lv_y_total, $lv_total_box_w, 11, 2, '1111', 'F', array(), $C_PRIMARY);
		$pdf->SetTextColor($C_WHITE[0], $C_WHITE[1], $C_WHITE[2]);
		$pdf->setfont('helvetica', 'B', 9);
		$pdf->setxy($lv_total_box_x + 3, $lv_y_total + 3);
		$pdf->Cell(30, 0, 'TOTAL NETO', 0, 0, 'L');
		$pdf->setfont('helvetica', 'B', 11);
		$pdf->setxy($lv_total_box_x, $lv_y_total + 2.5);
		$pdf->Cell($lv_total_box_w - 3, 0, number_format($lv_tot,2), 0, 0, 'R');

		// lugar y fecha de pago (a la izquierda del total)
		$pdf->SetTextColor($C_TEXT_GRAY[0], $C_TEXT_GRAY[1], $C_TEXT_GRAY[2]);
		$pdf->setfont('helvetica', 'B', 8);
		$pdf->text( $lv_margen_izq, $lv_y_total + 3, 'LUGAR y FECHA PAGO:' );
		$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
		$pdf->setfont('helvetica', '', 8);
		$pdf->text( $lv_margen_izq, $lv_y_total + 8, $vew_data->emp->bnk->bnktxt );

		// importe en palabras
		$lv_num = round( $lv_tot, 2 );
		$pdf->SetTextColor($C_TEXT_GRAY[0], $C_TEXT_GRAY[1], $C_TEXT_GRAY[2]);
		$pdf->setfont('helvetica', 'I', 8);
		$pdf->text( $lv_margen_izq, $lv_y_total + 16, ucfirst(strtolower($vew_doc->numberToWords( $lv_num, '', 'CENTAVOS' ))) );

		// -------------------------------------------------------
		// Constancia y firmas
		// -------------------------------------------------------
		$lv_y_firma = $lv_y_total + 24;
		$pdf->SetTextColor($C_TEXT_DARK[0], $C_TEXT_DARK[1], $C_TEXT_DARK[2]);
		$pdf->setfont('helvetica', '', 8);
		$pdf->text( $lv_margen_izq, $lv_y_firma,      'RECIBI CONFORME EN CONCEPTO:' );
		$pdf->text( $lv_margen_izq, $lv_y_firma + 3,  'DE MI REMUNERACION CORRESPONDIENTE' );
		$pdf->text( $lv_margen_izq, $lv_y_firma + 6,  'AL PERIODO ARRIBA INDICADO Y' );
		$pdf->text( $lv_margen_izq, $lv_y_firma + 9,  'DUPLICADO DE LA MISMA' );

		$pdf->SetDrawColor($C_PRIMARY[0], $C_PRIMARY[1], $C_PRIMARY[2]);

		$lv_firma1_x1 = $lv_margen_izq + 90; $lv_firma1_x2 = $lv_margen_izq + 178;
		$lv_firma_mid = ($lv_firma1_x1 + $lv_firma1_x2) / 2;

		$pdf->line( $lv_firma1_x1, $lv_y_firma + 14, $lv_firma_mid - 2, $lv_y_firma + 14 );
		$pdf->line( $lv_firma_mid + 2, $lv_y_firma + 14, $lv_firma1_x2, $lv_y_firma + 14 );

		$pdf->setfont('helvetica', 'B', 7.5);
		$pdf->setxy($lv_firma1_x1, $lv_y_firma + 15.5);
		$pdf->Cell($lv_firma_mid - 2 - $lv_firma1_x1, 0, 'FIRMA DEL EMPLEADO', 0, 0, 'C');
		$pdf->setxy($lv_firma_mid + 2, $lv_y_firma + 15.5);
		$pdf->Cell($lv_firma1_x2 - ($lv_firma_mid + 2), 0, 'Firma del Empleador / Rep.Legal', 0, 0, 'C');
	}

	// ---------------------------------------------------------
	// Ejecuta el armado del recibo
	// ---------------------------------------------------------
	pintar_recibo($pdf, $vew_data, $vew_doc, $lv_meses, $lv_margen_izq, $lv_margen_der, $lv_ancho_util,
		$C_PRIMARY, $C_PRIMARY_SOFT, $C_ACCENT_BG, $C_TABLE_HEAD, $C_ZEBRA, $C_TEXT_DARK, $C_TEXT_GRAY, $C_WHITE, $C_BORDER);

	$pdf->Output('recibo.pdf', 'I');
*/
?>

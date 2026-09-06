<?php
	/*
	b.	El ancho del papel es de 55mm y es continuo (pero se pueden imprimir de a una etiqueta)
	c.	Etiqueta ancho 50mm, alto 25mm.
	d.	Especio entre etiquetas 3mm.
	*/

	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

	$lv_count = $vew_msgqty;
	
	//$pageLayout = array( 65 * $lv_count, 140 ); //  or array($height, $width) 
	$pageLayout = array( 65, 140 ); //  or array($height, $width) 
	
	// create new PDF document
	//$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);
	$pdf = new TCPDF('P', 'px', $pageLayout, true, 'ISO-8859-1', false);

	// remove default header/footer
	$pdf->setPrintHeader(false);
	$pdf->setPrintFooter(false);

	// set default monospaced font
	$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

	// set margins
	//$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
	$pdf->SetMargins(0, 0, 0);
 
	// set auto page breaks
	$pdf->SetAutoPageBreak(FALSE, 0); //PDF_MARGIN_BOTTOM);  

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
	

	// ---------------------------------------------------------

	// set style for barcode
	$style = array(
		'border' => false,
		'vpadding' => 'auto',
		'hpadding' => 'auto',
		'fgcolor' => array(0,0,0),
		'bgcolor' => false, //array(255,255,255)
		'module_width' => 1, // width of a single module in points
		'module_height' => 1 // height of a single module in points
	);
	
	for($i=0; $i<$lv_count; $i++) {
		$pdf->AddPage('L', $pageLayout);
		$lv_posy = 5;
		$code = $vew_data->matcod.'|'.($vew_data->matbchcod!=0?$vew_data->matbchcod:'').'|'.($vew_data->matsercod!=0?$vew_data->matsercod:'').'|'.$vew_data->matuntcod;
		$pdf->setfont('helvetica', '', 8);
		$pdf->write2DBarcode($code, 'QRCODE,L', 0, $lv_posy+13, 50, 50, $style, 'N');	
    $pdf->MultiCell(
    140, // ancho total de la etiqueta
    0, // alto autoajustable
    utf8_decode($vew_data->mattxt), // texto del material
    0, // sin bordes
    'L', // alineación izquierda
    false, // sin fondo
    1, // salto de linea
    0, // posición X
    $lv_posy-2, // posición Y actual
    true // reset height
);
		//$pdf->text( 0, $lv_posy, $vew_data->mattxt );
		$pdf->text( 45, $lv_posy+48, "LOGINDOOR" );
    
		if($vew_data->matbchcod!='') {
      $lv_posy+=18;
      $pdf->text( 45, $lv_posy, 'Lote: '.$vew_data->matbchcodext); 
      $lv_posy+=15; 
      $pdf->text( 45, $lv_posy, 'Vto: '.$vew_data->matbchduedte->format('d/m/Y') );
    }
		if($vew_data->matsercod!='') { $lv_posy+=15; $pdf->text( 45, $lv_posy, 'Serie: '.$vew_data->matsercodext ); }
		//$lv_posy += 65;
	}
	
	$pdf->Output('etiquetas.pdf', 'I');	
?>
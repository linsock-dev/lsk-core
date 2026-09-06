<?php
require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'ISO-8859-1', false);
$pdf->setPrintHeader(false);
$pdf->setPrintFooter(false);
$pdf->SetMargins(0, 0, 0);
$pdf->SetAutoPageBreak(FALSE);
$pdf->AddPage();

$pdf->SetTextColor(0, 0, 180); 
$pdf->SetFont('courier', 'B', 12); 


// Fecha
$lv_date = $vew_evt[0]['steevtdte']; // Fecha

$pdf->SetXY(154, 48); 
$pdf->Cell(10, 5, $lv_date->format('d'));

$pdf->SetXY(162, 48); 
$pdf->Cell(10, 5, $lv_date->format('m'));

$pdf->SetXY(170, 48); 
$pdf->Cell(10, 5, $lv_date->format('y'));


// Cliente (Sector)
$pdf->SetXY(40, 71);
$pdf->Cell(100, 5, mb_convert_encoding($vew_ste->custxt, 'UTF-8', 'iso-8859-1') . ' ('.mb_convert_encoding($vew_ste->adr->adrtwn, 'UTF-8', 'iso-8859-1').')');


$cursor = 122; 

foreach ($vew_evt as $lv_row) {
  if (isset($lv_row['evtdoc']['steevtdocatr']) && !empty($lv_row['evtdoc']['steevtdocatr'])) {

    // Decodificar JSON
    $lv_docatr = json_decode(mb_convert_encoding($lv_row['evtdoc']['steevtdocatr'], 'UTF-8', 'iso-8859-1'), true);

    $lv_qty = $lv_docatr['steevtdocqty'] ?? ''; 		// Cantidad
    $lv_adr = $lv_docatr['steevtdocadr'] ?? '';				// Direccion
    $lv_baremo = $lv_docatr['cnstsktxt'] ?? '';				// Baremo
    $lv_barcodext = $lv_docatr['cnstskcodext'] ?? '';		// Codigo Externo Baremo

    $lv_evttxt = $lv_baremo . " ( ".$lv_barcodext." )";

    // Cantidad
    $pdf->SetXY(30, $cursor);
    $pdf->Cell(10, 5, $lv_qty, 0, 0, 'C');

    // Detalle (Evento)
    $pdf->SetXY(48, $cursor);
    $pdf->Cell(100, 5, $lv_evttxt);

    // Domicilio
    $pdf->SetXY(48, $cursor + 7); 
    $pdf->Cell(100, 5, $lv_adr);
  }
  
  $cursor += 20; 

  // Control de fin de página
  if ($cursor > 210) break;
}

// Proyecto
$pdf->SetXY(54, 226); 
$pdf->Cell(50, 5, $vew_doc->getTagValue($vew_ste->cnssteatr, 'atr_pry'));

$pdf->Output('REMITO.pdf', 'I');	
?>
<?php
	//ver: ZCUTP1_TINSLSORDPNT
	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');
	
	// Extend the TCPDF class to create custom Header and Footer
	class MYPDF extends TCPDF {
    var $lo_data;

    public function tmssSetData($lp_data) {
        $this->lo_data = $lp_data;
    }

    // Page header
    public function Header() {
        $style = array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 64, 128));
        
        $this->RoundedRect(0, 0, 210, 2, 0, '0000', 'DF', $style, array(152, 67, 174));
        $this->Image('library/images/logos/zcutp1_logindoor.jpg', 8, 7, 60);
        
        $this->SetFont('helvetica', '', 14);
        $this->SetY(10);
        $this->writeHTML('<b>LISTA DE PRECIOS</b>', true, false, false, false, 'R');
        
        $this->SetFont('helvetica', '', 12);
        $lv_now = new DateTime();
        $this->SetY(18);
        $this->writeHTML('Fecha: ' . date_format($lv_now, 'd/m/Y'), true, false, false, false, 'R');
    }

    // Page footer
    public function Footer() {
        $this->SetFont('helvetica', 'I', 8);
        $this->SetTextColor(0, 0, 0);
        // 1. Número de página centrado
        $this->SetY(275);
        $this->Cell(0, 10, 'Página ' . $this->getAliasNumPage() . ' / ' . $this->getAliasNbPages(), 0, 0, 'C', 0, '', 0, false, 'T', 'M');
        // 2. Tabla de footer
        $this->SetY(285);

        $lv_footer = '<table style="width:100%; font-size:8px;" border="0" cellpadding="1">';
        $lv_footer .= '<tr>';
        $lv_footer .= '<td style="width:32%; text-align:left;">Av. B. Ader 3620</td>';
        $lv_footer .= '<td style="width:36%; text-align:center;"><a href="https://www.logindoor.com.ar" target="_blank" style="text-decoration:none; color:#000000;">www.logindoor.com.ar</a></td>';
        $lv_footer .= '<td style="width:32%; text-align:right;">Ventas Logindoor</td>';
        $lv_footer .= '</tr>';
        $lv_footer .= '<tr>';
        $lv_footer .= '<td style="text-align:left;">Villa Adelina, San Isidro</td>';
        $lv_footer .= '<td style="text-align:center;"></td>';
        $lv_footer .= '<td style="text-align:right;">0810-362-0222</td>';
        $lv_footer .= '</tr>';
        $lv_footer .= '<tr>';
        $lv_footer .= '<td style="text-align:left;">Buenos Aires, Argentina</td>';
        $lv_footer .= '<td style="text-align:center;"></td>';
        $lv_footer .= '<td style="text-align:right;">pedidos@logindoor.com.ar</td>';
        $lv_footer .= '</tr>';
        $lv_footer .= '</table>';

        $this->writeHTML($lv_footer, true, false, true, false, '');

        // 3. Línea inferior
        $style = array('width' => 0.3, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 64, 128));
        $this->RoundedRect(0, 295, 210, 2, 0, '0000', 'DF', $style, array(80, 107, 191));
    }
	}
	// create new PDF document
	$pdf = new MYPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'ISO-8859-1', false);

	// fija datos de cabecera/pie
	$pdf->tmssSetData( $vew_data);

	// set default monospaced font
	$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

	// set margins
	$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
	$pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
	$pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

	// set auto page breaks
	$pdf->SetAutoPageBreak(true, PDF_MARGIN_BOTTOM);

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
	
	// ---------------------------------------------------------
	$pdf->AddPage('P');

  $lv_buffer = '';

  //Tabla
  $lv_buffer .= '<table border="1" cellpadding="2" cellspacing="0" style="font-size:10px;">';

  //encabezado
  $lv_buffer .= '<tr style="background-color:#e6e6e6;">'.
                  '<td align="center" width="50">ID</td>'.
                  '<td align="center" width="500">DESCRIPCION</td>'.
                  '<td align="RIGTH" width="100">PRECIO</td>'.
                '</tr>';

  //cuerpo
  foreach($vew_data as $lv_row){
    $lv_buffer .= '<tr>
                    <td>'.($lv_row['matcod'] != NULL ? $lv_row['matcod'] : '') .'</td>
                    <td>'.($lv_row['mattxt'] != NULL ? utf8_encode($lv_row['mattxt']) :'') . '</td>
                    <td align="right">'.($lv_row['slsprc'] != NULL ? number_format($lv_row['slsprc'],2) :'') . '</td>
                  </tr>';
  }

  //cierra tabla
  $lv_buffer .= '</table>';

  //devuelve la tabla
  $pdf->setfont('helvetica', '', 9);
  $pdf->setxy(10, 30);
  $pdf->writeHTML($lv_buffer);  
	
	
	$pdf->Output('Lista.pdf', 'I');	
?>
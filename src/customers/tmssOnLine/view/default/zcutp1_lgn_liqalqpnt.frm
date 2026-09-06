<?php
	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

	// create new PDF document
	$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, false, 'ISO-8859-1', false);

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
	for($i = 0; $i <$vew_msgqty; $i++){
    $pdf->AddPage('L');
    
    $pdf->setfont('helvetica', '', 13);
    
    //fecha
    $pdf->text(14, 10, $vew_lang->date.': '.$vew_dte);
    
    //liquidacion
    $pdf->text(14, 15, 'Liquidacion: #'.$vew_slssvclqdcod);
    
    // Cliente
    $pdf->text(105, 10, $vew_lang->customer.': '.$vew_custxt);
        
    $lv_buffer = '';
    
    //Tabla
    $lv_buffer .= '<table border="1" cellpadding="2" cellspacing="0">';
    
    //encabezado
    $lv_buffer .= '<tr style="background-color:#e6e6e6;">
    								<td align="center" width="180"> '.$vew_lang->patient.'</td>
										<td align="center" width="50"> '.$vew_lang->id.' </td>
                  	<td align="center" width="270"> '.$vew_lang->equipment.'</td>
                  	<td align="center" width="50">'.$vew_lang->quantity.'</td>
                  	<td align="center" width="50">'.$vew_lang->days.'</td>
                  	<td align="center" width="100">'.$vew_lang->amount.'</td>
                  	<td align="center" width="100">'.$vew_lang->total.'</td>
                  </tr>';
    
    //cuerpo
    $lv_total = 0;
    foreach($vew_data as $lv_row){
      $lv_buffer .= '<tr>
                      <td>'.($lv_row['stkcnttxt'] != NULL?$lv_row['stkcnttxt']:'').'</td>
											<td>'.($lv_row['matcod'] != NULL?$lv_row['matcod']:'').'</td>
                      <td>'.($lv_row['slssvclqddoctxt'] != NULL?$lv_row['slssvclqddoctxt']:'').'</td>
                      <td align="center">'.($lv_row['slssvclqddocqty'] != NULL?number_format( $lv_row['slssvclqddocqty'] ):1).'</td>
                      <td align="center">'.($lv_row['slssvclqddocday'] != NULL?number_format( $lv_row['slssvclqddocday'] ):1).'</td>
                      <td align="right">$'.($lv_row['slssvclqddocprc'] != NULL?number_format( $lv_row['slssvclqddocprc'], 2, ',', '.' ):'').'</td>
                      <td align="right">$'.($lv_row['slssvclqddoctot'] != NULL?number_format( $lv_row['slssvclqddoctot'], 2, ',', '.' ):'').'</td>
                    </tr>';
      $lv_total = $lv_total + $lv_row['slssvclqddoctot'];
    }
    
    //asigna el total
    $pdf->text(237, 10, $vew_lang->total.': $'.number_format( $lv_total, 2, ',', '.' ));
    
    //cierra tabla
    $lv_buffer .= '</table>';
    
    //devuelve la tabla
    $pdf->setfont('helvetica', '', 9);
    $pdf->setxy(15, 23 );
    $pdf->writeHTML($lv_buffer);
  }
	
	$pdf->Output('a.pdf', 'I');	
?>
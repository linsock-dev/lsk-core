<?php
	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');
	
	$lo_docsts=array('A'=>'ACTIVO','C'=>'CONTABILIZADO','I'=>'iNACTIVO');
	$lo_stkmovdoclck = array('0'=>'NO','1'=>'SI');
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
	$pdf->AddPage('L');
	$lv_posx=10;
	// Encabezado
	$pdf->setfont('Courier', 'B', 16);
	$pdf->text( 160, $lv_posx, $vew_data->sysdocclstxt . '  #'.$vew_data->stkmovdoccod);
	$pdf->setfont('Courier', 'B', 12);
	$lv_posx=20;
	$pdf->text( 20, $lv_posx, 'Fecha: '.date_format($vew_data->stkmovdocdte, 'd-m-Y'));	// fecha
	$lv_posx=$lv_posx+5;

	//Origen
	if( $vew_data->srcobjcod!='' && $vew_data->srcobjcod!='0'){
    $pdf->setfont('Courier', 'B', 12);
    $pdf->text( 20, $lv_posx, 'ORIGEN');	
    $pdf->setfont('Courier', '', 12);
    $lv_posx=$lv_posx+5;
    $pdf->text( 20, $lv_posx, ' '.utf8_encode($vew_data->srcobjtyptxt).': '.utf8_encode($vew_data->srcobjtxt));
    $lv_posx=$lv_posx+5;
    if($vew_data->srccntcod!='' && $vew_data->srccntcod!='0')
    { 
      $pdf->text( 20, $lv_posx, ' CONTACTO: '.utf8_encode($vew_data->srccnttxt));
      $lv_posx=$lv_posx+5;
    }
  }

	//Destino
	if( $vew_data->dstobjcod!='' && $vew_data->dstobjcod!='0'){
    $pdf->setfont('Courier', 'B', 12);
    $pdf->text( 20, $lv_posx, 'DESTINO');
    $pdf->setfont('Courier', '', 12);
    $lv_posx=$lv_posx+5;
    $pdf->text( 20, $lv_posx, ' '.utf8_encode($vew_data->dstobjtyptxt).': '.utf8_encode($vew_data->dstobjtxt));
    $lv_posx=$lv_posx+5;
    if($vew_data->dstcnttxt!='' && $vew_data->dstcnttxt!='0')
    { 
      $pdf->text( 20, $lv_posx, ' CONTACTO: '.utf8_encode($vew_data->dstcnttxt));
      $lv_posx=$lv_posx+5;
    }
  }

	$lv_posx2=25;
	$pdf->text( 150, $lv_posx2, 'NRO.: '.$vew_data->stkmovdoccodext);											
	$lv_posx2=$lv_posx2+5;
	$pdf->text( 150, $lv_posx2, 'BLOQUEADO: '.$lo_stkmovdoclck [$vew_data->stkmovdoclck]);
	$lv_posx2=$lv_posx2+5;
	$pdf->text( 150, $lv_posx2, 'ESTADO: '.$lo_docsts[$vew_data->docsts] .' ' . $vew_data->sysdoctretxt);													
	$lv_posx2=$lv_posx+5;
	$pdf->text( 20, $lv_posx, 'COMENTARIO: '.$vew_data->stkmovdoccmt );																		
	$lv_posx=$lv_posx+5;
	
	// Posiciones
	$pdf->setfont('Courier', '', 10);
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
	$i=0;
	foreach($vew_data->stkmovdocmat as $lv_row) {
			$i++;
			$lv_buffer .= '<tr>'.
										'<td style="background-color: #f1f1f1;">'.$i.'</td>'.
										'<td>'.$lv_row['matcod'].'</td>'.
										'<td>'.utf8_encode($lv_row['mattxt']).'</td>'.
										'<td align="right">'.number_format($lv_row['matqty'],2).'</td>'.
										'<td>'.$lv_row['matuntcod'].'</td>'.
										'<td>'.($lv_row['matbchcod']==0?'':$lv_row['matbchcodext']).'</td>'.
										'<td>'.($lv_row['matbchcod']==0?'':$lv_row['matbchduedtecnv']).'</td>'.
										'<td>'.($lv_row['matsercod']==0?'':$lv_row['matsercodext']).'</td>'.
										'</tr>';
	}	
	$lv_buffer .= '</table>';	
	$pdf->setxy( 20, $pdf->getY()+9);
	$pdf->writeHTML($lv_buffer);

	$pdf->Output($vew_data->sysdocclstxt.'.pdf', 'I');	
?>
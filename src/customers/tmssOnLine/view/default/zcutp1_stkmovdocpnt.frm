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
	//$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);  
	$pdf->SetAutoPageBreak(TRUE, 10); 
	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
	

	// ---------------------------------------------------------
	$pdf->AddPage('P');
	
	// Encabezado
	$pdf->setfont('Courier', 'B', 11);
	$pdf->text( 150, 33, date_format($vew_data->stkmovdocdte, 'd    m     Y'));	// fecha
	$pdf->text( 40, 61,  $vew_data->dstobjtxt);																	// nombre
	$pdf->setfont('Courier', '', 8);
	$pdf->text( 145, 69, 'Conforme a Remito N ' .$vew_data->stkmovdoccodext);	 // Remito N
	$pdf->setfont('Courier', 'B', 11);
	$pdf->text( 40, 69,substr(  
            ' ' . $vew_data->dstobjadrstr 
            .' '.$vew_data->dstobjadrstrnum
            .' '.$vew_data->dstobjadrstrflr
            .' '.$vew_data->dstobjadrstrunt
            .' '.$vew_data->dstobjadrstrbld
            . ' (' . $vew_data->dstcus->adrpstcod.')' 
            ,0,65));	// domicilio
	$pdf->text( 40, 79,  ' '. substr(
    ' '.$vew_data->dstobjadrtwntxt
    ,0,35 ));// localidad
	$pdf->text( 154, 79, $vew_data->dstcus->taxdocnum);													// CUIT
	$pdf->text( 33, 88,  $vew_data->dstcus->taxcattxt
                .'   Prov: '.$vew_data->dstobjlndregtxt
            );													// IVA
	$pdf->setfont('Courier', '', 8);
	/* Pedidos */
	if(isset($vew_adddat)&&isset($vew_adddat['flwarr'])&& count($vew_adddat['flwarr'])>0){ 
    $strflw='';
    foreach($vew_adddat['flwarr'] as $lv_rowflw){
      $strflw .= $strflw !=''?  '; '.$lv_rowflw:$lv_rowflw;
    }
    //$strflw= $vew_adddat['flwarr'][0];
		$pdf->text( 145, 60, 'Ped. de ref.: ' . $strflw);
  }
	/* Cotizaciones*/
	if(isset($vew_adddat)&&isset($vew_adddat['flwqtaarr'])&& count($vew_adddat['flwqtaarr'])>0){ 
    $strflwqta='';
    foreach($vew_adddat['flwqtaarr'] as $lv_rowflwqta){
      $strflwqta .= $strflwqta !=''?  '; '.$lv_rowflwqta:$lv_rowflwqta;
    }
		$pdf->text( 140, 70, 'Cotiz. de ref.: ' . $strflwqta);
  }
	// Posiciones
	$pdf->setfont('Courier', '', 10);
	$lv_buffer = '<table border=0 cellpadding=0 cellspacing=0>'; 
	foreach($vew_data->stkmovdocmat as $lv_row) {
		if(($lv_row['sysdocrejcod']=='0' || $lv_row['sysdocrejcod']==null ) || $vew_data->sysdocclscodext=='DEPRO') {
      if(array_key_exists($lv_row['stkmovdocmatcod'],$vew_cmp) && $vew_vewkitlst!='' ){
        continue;
      }else{
        $lv_buffer .= '<tr>'. 
                      '<td align="right" width="95">'.number_format($lv_row['matqty'],2).'</td>'.
                      '<td width="40"></td>'.
                      '<td width="400">'.utf8_encode($lv_row['mattxt']).'</td>'. 
                      '</tr>';
        if ( $lv_row['matbchcodext']!='' && $lv_row['matbchcodext']!=NULL ) {
          $lv_buffer .= '<tr style="font-size: 9px;"><td colspan="2"></td><td>Lote: '.$lv_row['matbchcodext'].' - Vto: '.date_format($lv_row['matbchduedte'],'d/m/Y').'</td></tr>';
        }
        if ( $lv_row['matsercod']!='' && $lv_row['matsercod']!=NULL) {
          $lv_buffer .= '<tr style="font-size: 9px;"><td colspan="2"></td><td>Serie: '.$lv_row['matsercodext'].'</td></tr>';			
        }
        if ( $lv_row['sysdocrsntxt']!='' && $lv_row['sysdocrsntxt']!=NULL) {
          $lv_buffer .= '<tr style="font-size: 9px;"><td colspan="2"></td><td>Motivo: '.$lv_row['sysdocrsntxt'].'</td></tr>';
        }         
      }
			
		}
	} 
	if($vew_vewkitlst!=''){
    foreach($vew_cmplst['matusebch'] as $row){
      $lv_buffer .= '<tr>'.
                    '<td align="right" width="95">'.number_format($row['matqtycmp'],2).'</td>'.
                    '<td width="40"></td>'.
                    '<td width="400">'.utf8_encode($row['mattxt']).'</td>'.
                    '</tr>';
      if ( $row['matbchcodext']!='' && $row['matbchcodext']!=NULL ) {
        $lv_buffer .= '<tr style="font-size: 9px;"><td colspan="2"></td><td>Lote: '.$row['matbchcodext'].' - Vto: '.date_format($row['matbchduedte'],'d/m/Y').'</td></tr>';
      }
    }
    foreach($vew_cmplst['matnotusebch'] as $row){
      $lv_buffer .= '<tr>'.
                    '<td align="right" width="95">'.number_format($row['matqtycmp'],2).'</td>'.
                    '<td width="40"></td>'.
                    '<td width="400">'.utf8_encode($row['mattxt']).'</td>'.
                    '</tr>';
    }
  }
	
	$lv_buffer .= '</table>';
	$pdf->text( 153, 247,  'CANT. BULTOS:');	
	$pdf->text( 153, 253,  'PESO:');	 

	$pdf->setxy( 8, 120);
	$pdf->writeHTML($lv_buffer);
	$pdf->setfont('Courier', '', 7);
	$pdf->text( 45, 255, 'Observaciones: ' .utf8_encode($vew_data->dstcnttxt));	 // OBSERVACIONES CONTACTO
	// ---------------------------------------------------------

	$pdf->Output('remito.pdf', 'I');	
?>
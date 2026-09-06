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
	$lv_grpqty = count($vew_data);
	$lv_lstmth = intval($vew_data[0]['hhrlqdgrpstrdte']->format('m'));
  $lv_meses = array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
  $lv_val001 = 0;
  $lv_val002 = 0;

	for($i=0; $i < $lv_grpqty; $i++){
    // verifica si cambió el período
    if($vew_data[$i]['hhrlqdgrpstrdte']->format('m') != $lv_lstmth || !$i){
      if($i){
        // cierra página actual
        $lv_buffer .= '<tr>'.
                  '<td colspan="6" style="font-weight:bold; font-size:12px; border-top:1px solid black; border-bottom:1px solid black;">TOTALES</td>'.
                  '<td style="font-weight:bold; font-size:12px; border-top:1px solid black; border-bottom:1px solid black;" align="right">'.number_format($lv_tot001,2).'</td>'.
                  '<td style="font-weight:bold; font-size:12px; border-top:1px solid black; border-bottom:1px solid black;" align="right">'.number_format($lv_tot002,2).'</td>'.
                  '</tr>';
        $lv_buffer .= '</tbody></table>';
        $pdf->writeHTML( $lv_buffer );
      }
      
      // prepara nueva página
			$lv_lstmth = intval($vew_data[$i]['hhrlqdgrpstrdte']->format('m'));
      $lv_val001 = 0;
      $lv_val002 = 0;
      
      $pdf->AddPage('P');
      
      // ENCABEZADO
      $pdf->setfont('helvetica', 'B', 12);
      $pdf->text( 55, 30, 'CAJA COMPLEMENTARIA PARA '.strtoupper($lv_meses[$lv_lstmth]).' DE '.$vew_data[$i]['hhrlqdgrpstrdte']->format('Y') );
      
      $pdf->setfont('helvetica', 'B', 12);
      $pdf->text( 10, 8, $vew_datbus->bustxt );
      $pdf->setfont('helvetica', '', 8);
      $pdf->text( 10, 14, $vew_datbus->adr->adrstr.' '.$vew_datbus->adr->adrstrnum );
      $pdf->text( 10, 18, '( '.$vew_datbus->adr->adrpstcod.' ) '.$vew_datbus->adr->adrtwntxt );
      $pdf->text( 10, 22, $vew_datbus->adr->adrphn001 );

      $pdf->text( 170, 18, 'Pagina: '.$pdf->getAliasNumPage() );
      
      // tabla caja comp
      $pdf->setfont('helvetica', '', 7);
      $pdf->setxy( 10, 40 );
      $lv_tot001 = 0;
      $lv_tot002 = 0;
      $lv_buffer = '<table cellpadding="5"><tbody>';
      $lv_buffer .= '<tr>'.
                    '<td width="30" style="font-weight:bold;">Mes</td>'.
                    '<td width="30" style="font-weight:bold;">Año</td>'.
                    '<td width="250" style="font-weight:bold;">Apellido y Nombres</td>'.
                    '<td width="80" style="font-weight:bold;">DNI</td>'.
                    '<td width="40" style="font-weight:bold;">CONV.</td>'.
                    '<td width="45" style="font-weight:bold;">CARGO</td>'.
                    '<td width="90" align="right" style="font-weight:bold;">TOT. REMUN</td>'.
                    '<td width="90" align="right" style="font-weight:bold;">IMP. CAJA COM</td>'.
                    '</tr>';
    }
    
    foreach($vew_data[$i]['hhrlqddoc'] as $lv_rowdoc){
      foreach($vew_data[$i]['hhrlqddocprc'] as $lv_rowprc){
        if($lv_rowdoc['hhrlqdcod']==$lv_rowprc['srcobjcod001'] && $lv_rowprc['prcschcndrow']=='399'){$lv_val001=$lv_rowprc['prccndtot'];$lv_tot001+=$lv_val001;}
        if($lv_rowdoc['hhrlqdcod']==$lv_rowprc['srcobjcod001'] && $lv_rowprc['prccndcodext']=='CAJCOM'){$lv_val002=$lv_rowprc['prccndtot'];$lv_tot002+=$lv_val002;}
      }		
      $lv_buffer .= '<tr>'.
                    '<td style="border-top:1px solid black;">'.$lv_rowdoc['hhrlqdstrdte']->format('m').'</td>'.
                    '<td style="border-top:1px solid black;">'.$lv_rowdoc['hhrlqdstrdte']->format('Y').'</td>'.
                    '<td style="border-top:1px solid black;">'.$lv_rowdoc['srcobjtxt'].'</td>'.
                    '<td style="border-top:1px solid black;">'.$lv_rowdoc['taxiibb'].'</td>'.
                    '<td style="border-top:1px solid black;">'.'-'.'</td>'.
                    '<td style="border-top:1px solid black;">'.$lv_rowdoc['hhrchrtyptxt'].'</td>'.
                    '<td style="border-top:1px solid black;" align="right">'.number_format($lv_val001,2).'</td>'.
                    '<td style="border-top:1px solid black;" align="right">'.number_format($lv_val002,2).'</td>'.
                    '</tr>';
    }
  }

	$lv_buffer .= '<tr>'.
            '<td colspan="6" style="font-weight:bold; font-size:12px; border-top:1px solid black; border-bottom:1px solid black;">TOTALES</td>'.
            '<td style="font-weight:bold; font-size:12px; border-top:1px solid black; border-bottom:1px solid black;" align="right">'.number_format($lv_tot001,2).'</td>'.
            '<td style="font-weight:bold; font-size:12px; border-top:1px solid black; border-bottom:1px solid black;" align="right">'.number_format($lv_tot002,2).'</td>'.
            '</tr>';
  $lv_buffer .= '</tbody></table>';
  $pdf->writeHTML( $lv_buffer );
	
	$pdf->Output('listado_caja_complementaria.pdf', 'I');	
?>
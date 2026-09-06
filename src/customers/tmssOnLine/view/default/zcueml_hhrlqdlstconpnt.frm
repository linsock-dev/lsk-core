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
	$pdf->SetAutoPageBreak(TRUE, 1); //PDF_MARGIN_BOTTOM);

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
                      '<td colspan="5" style="font-weight:bold; font-size:12px; border-top:1px solid black; border-bottom:1px solid black;">TOTALES</td>'.
                      '<td style="font-weight:bold; font-size:12px; border-top:1px solid black; border-bottom:1px solid black;" align="right">'.number_format($lv_tot001,2).'</td>'.
                      '<td style="font-weight:bold; font-size:12px; border-top:1px solid black; border-bottom:1px solid black;" align="right">'.number_format(0,2).'</td>'.
                      '<td style="font-weight:bold; font-size:12px; border-top:1px solid black; border-bottom:1px solid black;" align="right">'.number_format(0,2).'</td>'.
                      '</tr>';
    		$lv_buffer .= '</tbody></table>';
				$pdf->writeHTML( $lv_buffer );
      }
      
      // prepara nueva página
      $lv_lstmth = intval($vew_data[$i]['hhrlqdgrpstrdte']->format('m'));
      $lv_val001 = 0;
      $lv_tot001 = 0;

      $pdf->AddPage('L');

      // ENCABEZADO
      $pdf->setfont('helvetica', 'B', 12);
      $pdf->text( 55, 30, 'LISTADO CONSOLIDADO POR PERSONA PARA EL PERÍODO DE '.strtoupper($lv_meses[$lv_lstmth]).' DE '.$vew_data[$i]['hhrlqdgrpstrdte']->format('Y') );

      $pdf->setfont('helvetica', 'B', 12);
      $pdf->text( 10, 8, $vew_datbus->bustxt );
      $pdf->setfont('helvetica', '', 8);
      $pdf->text( 10, 14, $vew_datbus->adr->adrstr.' '.$vew_datbus->adr->adrstrnum );
      $pdf->text( 10, 18, '( '.$vew_datbus->adr->adrpstcod.' ) '.$vew_datbus->adr->adrtwntxt );
      $pdf->text( 10, 22, $vew_datbus->adr->adrphn001 );

      $pdf->text( 260, 18, 'Pagina:'.$pdf->getAliasNumPage() );
      
      // tabla listado consolidado
      $pdf->setfont('helvetica', '', 7);
      $pdf->setxy( 15, 40 );
      $lv_tot001 = 0;
      $lv_tot002 = 0;
      $lv_buffer = '<table cellpadding="5"><tbody>';
      $lv_buffer .= '<tr>'.
                    '<td width="80" style="border-top:1px solid black; background-color:#f1f1f1; font-weight:bold;">ORDEN</td>'.
                    '<td width="90" style="border-top:1px solid black; background-color:#f1f1f1; font-weight:bold;">COD. PERS.</td>'.
                    '<td width="270" style="border-top:1px solid black; background-color:#f1f1f1; font-weight:bold;">APELLIDO Y NOMBRES</td>'.
                    '<td width="100" style="border-top:1px solid black; background-color:#f1f1f1; font-weight:bold;">NRO. CUIL</td>'.
                    '<td width="120" style="border-top:1px solid black; background-color:#f1f1f1; font-weight:bold;">DOCUMENTO</td>'.
                    '<td width="100" align="right" style="border-top:1px solid black; background-color:#f1f1f1; font-weight:bold;">REMUNER</td>'.
                    '<td width="100" align="right" style="border-top:1px solid black; background-color:#f1f1f1; font-weight:bold;">SINDICTA</td>'.
                    '<td width="100" align="right" style="border-top:1px solid black; background-color:#f1f1f1; font-weight:bold;">INCENTIV</td>'.
                    '</tr>';
    }
    
    $j=0;
    foreach($vew_data[$i]['hhrlqddoc'] as $lv_row){
      $j++;
      $lv_val002=0;
      foreach($vew_data[$i]['hhrlqddocprc'] as $lv_rowprc){
        if($lv_row['hhrlqdcod']==$lv_rowprc['srcobjcod001'] && $lv_rowprc['prcschcndrow']=='399'){$lv_val001=$lv_rowprc['prccndtot'];break;}
        if($lv_row['hhrlqdcod']==$lv_rowprc['srcobjcod001'] && $lv_rowprc['prccndcodext']=='SINDICATO'){$lv_val002=$lv_rowprc['prccndtot'];break;}
      }
      $lv_tot001+=$lv_val001;
      $lv_buffer .= '<tr>'.
                    '<td style="border-top:1px solid black;">'.str_pad($j,10,'0',STR_PAD_LEFT).'</td>'.
                    '<td style="border-top:1px solid black;">'.$lv_row['srcobjcod'].'</td>'.
                    '<td style="border-top:1px solid black;">'.$lv_row['srcobjtxt'].'</td>'.
                    '<td style="border-top:1px solid black;">'.substr($lv_row['taxcod'],0,2).'-'.substr($lv_row['taxcod'],2,8).'-'.substr($lv_row['taxcod'],10,1).'</td>'.
                    '<td style="border-top:1px solid black;">'.$lv_row['taxiibb'].'</td>'.
                    '<td style="border-top:1px solid black;" align="right">'.number_format($lv_val001,2).'</td>'.
                    '<td style="border-top:1px solid black;" align="right">'.number_format(0,2).'</td>'.
                    '<td style="border-top:1px solid black;" align="right">'.number_format(0,2).'</td>'.
                    '</tr>';
		}

	}

  $lv_buffer .= '<tr>'.
                '<td colspan="5" style="font-weight:bold; font-size:12px; border-top:1px solid black; border-bottom:1px solid black;">TOTALES</td>'.
                '<td style="font-weight:bold; font-size:12px; border-top:1px solid black; border-bottom:1px solid black;" align="right">'.number_format($lv_tot001,2).'</td>'.
                '<td style="font-weight:bold; font-size:12px; border-top:1px solid black; border-bottom:1px solid black;" align="right">'.number_format(0,2).'</td>'.
                '<td style="font-weight:bold; font-size:12px; border-top:1px solid black; border-bottom:1px solid black;" align="right">'.number_format(0,2).'</td>'.
                '</tr>';
	$lv_buffer .= '</tbody></table>';
	$pdf->writeHTML( $lv_buffer );
		
	$pdf->Output('listado_consolidado.pdf', 'I');	
?>
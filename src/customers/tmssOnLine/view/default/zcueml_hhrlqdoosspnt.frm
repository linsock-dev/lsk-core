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
	for($i=0; $i < $lv_grpqty; $i++){
    $pdf->AddPage('P');
    if(!$i){
      // Encabezado
      $pdf->setfont('helvetica', 'B', 12);
      $pdf->text( 55, 15, 'PLANILLA DISCRIMINATIVA APORTES OBRA SOCIAL' );
    }

    $pdf->setfont('helvetica', '', 10);
    $pdf->text( 15, 25, 'Establecimiento: '.$vew_data[$i]['stdloctxt'] );
    $pdf->text( 15, 32, 'Característica: DIEGEP '.$vew_data[$i]['stdloccodext'] );
    $pdf->text( 15, 39, 'Dirección: '.$vew_data[$i]['adrstr'].' '.$vew_data[$i]['adrstrnum'] );
    $lv_meses = array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
    $pdf->text( 140, 25, 'Período: '.strtoupper($lv_meses[intval($vew_data[$i]['hhrlqdgrpstrdte']->format('m'))]).' de '.$vew_data[$i]['hhrlqdgrpstrdte']->format('Y') );
    $pdf->text( 140, 32, 'Orden de Pago: '.$vew_data[$i]['hhrlqdgrpcod'] );
    $pdf->text( 140, 39, 'Subvencion: %' );

    $pdf->setfont('helvetica', '', 8);
    $pdf->setxy( 15, 50 );
    $lv_tot001 = 0;
    $lv_tot002 = 0;
    $lv_buffer = '<table cellpadding="5"><tbody>';
    $lv_buffer .= '<tr>'.
                  '<td width="80" align="center" style="border:1px solid black;">&nbsp;<br>D.N.I. Nro</td>'.
                  '<td width="310" align="center" style="border:1px solid black;">&nbsp;<br>Apellido y Nombres</td>'.
                  '<td width="90" align="center" style="border:1px solid black;">3%<br>Aporte Personal</td>'.
                  '<td width="90" align="center" style="border:1px solid black;">6%<br>Aporte Patronal</td>'.
                  '<td width="90" align="center" style="border:1px solid black;">&nbsp;<br>Total Aportado</td>'.
                  '</tr>';
    foreach($vew_data[$i]['hhrlqddoc'] as $lv_row){
      $lv_val = 0;
      foreach($vew_data[$i]['hhrlqddocprc'] as $lv_rowprc){
        if($lv_row['hhrlqdcod']==$lv_rowprc['srcobjcod001'] && $lv_rowprc['prccndcodext']=='OOSS'){$lv_val=abs($lv_rowprc['prccndtot']);break;}
      }
      $lv_buffer .= '<tr>'.
                    '<td style="border:1px solid black;">'.$lv_row['taxiibb'].'</td>'.
                    '<td style="border:1px solid black;">'.$lv_row['srcobjtxt'].'</td>'.
                    '<td style="border:1px solid black;" align="right">'.number_format($lv_val,2).'</td>'.
                    '<td style="border:1px solid black;" align="right">'.number_format($lv_val*2,2).'</td>'.
                    '<td style="border:1px solid black;" align="right">'.number_format($lv_val*3,2).'</td>'.
                    '</tr>';
      $lv_tot001 += $lv_val;
      $lv_tot002 += $lv_val*2;
    }
    $lv_buffer .= '</tbody></table>';
    $pdf->writeHTML( $lv_buffer );


    $pdf->setfont('helvetica', 'B', 9);
    $pdf->setxy( 15, 240 );
    $lv_buffer = '<table border="0"><tbody><tr>'.
                  '<td width="385" align="right">TOTAL o TRANSPORTE</td>'.
                  '<td width="85" align="right">'.number_format($lv_tot001,2).'</td>'.
                  '<td width="85" align="right">'.number_format($lv_tot002,2).'</td>'.
                  '<td width="85" align="right">'.number_format($lv_tot001+$lv_tot002,2).'</td>'.
                  '</tr></tbody></table>';
    $pdf->writeHTML( $lv_buffer );


    $pdf->setfont('helvetica', '', 10);
    $pdf->text( 15, 265 , 'Nota: La Presente tiene carácter de Declaración Jurada.' );
    $pdf->text( 30, 275 , '.........................................................................' );
    $pdf->text( 35, 279 , 'Firma y Sello del Representante Legal' );
    $pdf->text( 120, 275 , '.........................................................................' );
    $pdf->text( 135, 279 , 'Sello del Establecimiento' );
  }

	$pdf->Output('listado_ooss.pdf', 'I');	
?>
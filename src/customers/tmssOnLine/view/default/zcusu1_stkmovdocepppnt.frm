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

	for($i=0; $i < $vew_msgqty; $i++){
    // ---------------------------------------------------------
    $pdf->AddPage('L');

    // Encabezado
    $pdf->Image('library/images/logos/supplysouth.jpg',10,5,32);
    $pdf->setfont('helvetica', '', 8);
    $pdf->text( 243, 8, 'F-'); 
    $pdf->setfont('helvetica', 'B', 8);
    $pdf->text( 247, 8, '065-SS');

    $pdf->setfont('helvetica', '', 8);
    $pdf->text( 262, 8, 'REV:'); 
    $pdf->setfont('helvetica', 'B', 8);
    $pdf->text( 269, 8, '00');

    $pdf->setfont('helvetica', 'I', 9);
    $pdf->text( 234, 12, 'Resolución 299/11, Anexo I' );

    //$pdf->line( 10,17,278,17);
    $pdf->setfont('helvetica', '', 11);
    $pdf->Rect( 10, 17, 265, 5, 'DF', array(), array(0, 0, 0));
    $pdf->setxy( 73, 17 );	
    $pdf->writeHTML('<span color="#FFFFFF">ENTREGA DE ROPA DE TRABAJO Y ELEMENTOS DE PROTECCIÓN PERSONAL</span>');
    $pdf->line( 10,22,275,22);	
    $pdf->line( 10,29,275,29);	
    $pdf->line( 10,36,275,36);	
    $pdf->line( 10,43,275,43);	
    $pdf->line( 10,68,275,68);	

    //$pdf->line( 10,13,278,13);	
    $pdf->line( 10,17,10,68);	
    $pdf->line( 275,17,275,68);	

    $pdf->line( 185,22,185,36);	
    $pdf->line( 115,29,115,36);	
    $pdf->line( 150,29,150,36);	
    $pdf->line( 200,36,200,43);	
    $pdf->line( 150,43,150,68);	

    $pdf->setfont('helvetica', '', 6);
    $pdf->text( 11, 24, '(1)');
    $pdf->text( 186, 24, '(2)');
    $pdf->text( 11, 31, '(3)');
    $pdf->text( 116, 31, '(4)');
    $pdf->text( 151, 31, '(5)');
    $pdf->text( 186, 31, '(6)');
    $pdf->text( 11, 38, '(7)');
    $pdf->text( 201, 38, '(8)');
    $pdf->text( 11, 45, '(9)');
    $pdf->text( 151, 45, '(10)');
    $pdf->text( 21, 70, '(11)');
    $pdf->text( 111, 70, '(12)');
    $pdf->text( 145, 70, '(13)');
    $pdf->text( 167, 70, '(14)');
    $pdf->text( 186, 70, '(15)');
    $pdf->text( 204, 70, '(16)');
    $pdf->text( 223, 70, '(17)');
    $pdf->text( 11, 172, '(18)');
    $pdf->setfont('helvetica', '', 8);
    $pdf->text( 15, 24, 'Razón Social:');
    $pdf->text( 190, 24, 'C.U.I.T.:');
    $pdf->text( 15, 31, 'Dirección:');
    $pdf->text( 120, 31, 'Localidad:');
    $pdf->text( 155, 31, 'C.P.:');
    $pdf->text( 190, 31, 'Provincia:');
    $pdf->text( 15, 38, 'Nombre y Apellido del Trabajador:');
    $pdf->text( 205, 38, 'D.N.I.:');
    $pdf->text( 15, 45, 'Descripción breve del puesto/s de trabajo en el/los cuales se desmpeña en trabajador:');
    $pdf->text( 156, 45, 'Elementos de protección personal, necesarios para el trabajador, según el puesto de trabajo:');
    $pdf->setfont('helvetica', 'B', 8);
    $pdf->text( 35, 24, $vew_bus->bustxt );
    $pdf->text( 205, 24, $vew_bus->tax->taxcod);
    $pdf->text( 30, 31, $vew_bus->adr->adrstr.' '.$vew_bus->adr->adrstrnum.' '.$vew_bus->adr->adrstrflr.$vew_bus->adr->adrstrunt);
    $pdf->text( 135, 31, $vew_bus->adr->adrtwntxt);
    $pdf->text( 163, 31, $vew_bus->adr->adrpstcod);
    $pdf->text( 205, 31, $vew_bus->adr->lndregtxt);
    $pdf->text( 62, 38, utf8_encode($vew_emp->hhremptxt));
    $pdf->text( 185, 38, $vew_emp->hhrempcodext);
    $pdf->text( 215, 38, $vew_emp->tax->taxiibb);

    // cargos
    $lv_i=50;
    $lv_txt='';
    foreach($vew_emp->chrasg as $lv_row){
      $pdf->text( 15, $lv_i, $lv_row['hhrchrtyptxt']);
      $lv_txt .= ($lv_txt==''?'':'<br>').utf8_encode($lv_row['hhrchrtypcmt']);
      $lv_i+=5;
    }
    $pdf->setXY( 156, 50 );
    $pdf->writeHTML('<table border="0" width="417"><tbody><tr><td>'.$lv_txt.'</td></tr></table>');

    // Posiciones
    $pdf->setfont('helvetica', '', 8);
    $pdf->setxy( 10, 70 );	
    $lv_buffer = '<table border=0 cellpadding="5" cellspacing="0">';
    $lv_buffer .= '<tbody><tr>'.
                  '<th align="center" width="40" style="border:1px solid black;">-</th>'.
                  '<th align="center" width="320" style="border:1px solid black;">Producto</th>'.
                  '<th align="center" width="120" style="border:1px solid black;">Tipo // Modelo</th>'.
                  '<th align="center" width="80" style="border:1px solid black;">Marca</th>'.
                  '<th align="center" width="65" style="border:1px solid black;">Posee certificación SI // NO</th>'.
                  '<th align="center" width="65" style="border:1px solid black;">Cantidad</th>'.
                  '<th align="center" width="65" style="border:1px solid black;">Fecha de entrega</th>'.
                  '<th align="center" width="183" style="border:1px solid black;">Firma del trabajador</th>'.
                  '</tr>';
    foreach($vew_data->stkmovdocmat as $lv_row) {
      if($lv_row['sysdocrejcod']=='0' || $lv_row['sysdocrejcod']==null) {

        $lv_tipo = '';
        $lv_modelo = '';
        $lv_marca = '';
        $lv_cert = '';
        foreach($vew_data->mat as $lv_rowmat){
          if($lv_rowmat['matcod']==$lv_row['matcod']){
            $lv_i = 0;
            $lv_rowatr = $vew_doc->getTagValue($lv_rowmat['matatr'],'atr'.$lv_i);
            while($lv_rowatr!=''){
              if( strtolower($vew_doc->getTagValue($lv_rowatr,'matatrnme'))=='tipo'){$lv_tipo=$vew_doc->getTagValue($lv_rowatr,'matatrval');}
              if( strtolower($vew_doc->getTagValue($lv_rowatr,'matatrnme'))=='modelo'){$lv_modelo=$vew_doc->getTagValue($lv_rowatr,'matatrval');}
              if( strtolower($vew_doc->getTagValue($lv_rowatr,'matatrnme'))=='marca'){$lv_marca=$vew_doc->getTagValue($lv_rowatr,'matatrval');}
              if( strtolower($vew_doc->getTagValue($lv_rowatr,'matatrnme'))=='certificacion'){$lv_cert=$vew_doc->getTagValue($lv_rowatr,'matatrval');}
              $lv_i++;
              $lv_rowatr = $vew_doc->getTagValue($lv_rowmat['matatr'],'atr'.$lv_i);
            }
            break;
          }
        }

        $lv_buffer .= '<tr>'.
                      '<td align="left"  style="border:1px solid black;">'.$lv_row['matcod'].'</td>'.
                      '<td align="left"  style="border:1px solid black;">'.$lv_row['mattxt'].'</td>'.
                      '<td align="right" style="border:1px solid black;">'.$lv_tipo.($lv_tipo!='' && $lv_modelo!=''?' ':'').$lv_modelo.'</td>'.
                      '<td align="right" style="border:1px solid black;">'.$lv_marca.'</td>'.
                      '<td align="right" style="border:1px solid black;">'.($lv_cert==''?'NO':$lv_cert).'</td>'.
                      '<td align="right" style="border:1px solid black;">'.number_format($lv_row['matqty'],0).'</td>'.
                      '<td align="center" style="border:1px solid black;">'.$vew_data->stkmovdocdte->format('d.m.Y').'</td>'.
                      '<td align="left"  style="border:1px solid black;"></td>'.
                      '</tr>';
      }
    }	
    $lv_buffer .= '</tbody></table>';
    $pdf->writeHTML($lv_buffer);


    // PIE
    $pdf->line( 10,170,275,170);	
    $pdf->line( 10,170,10,200);	
    $pdf->line( 275,170,275,200);
    $pdf->line( 10,200,275,200);

    $pdf->setfont('helvetica', '', 8);
    $pdf->text( 16, 172, 'Información Adicional:');
    $pdf->text( 16, 177, 'Los trabajadores firmantes se comprometen al uso y conservacion adecuada de los E.P.P. entregados como lo establece la Ley Nº 19587 Dec.351/79 Cap.19');

    $pdf->text( 16, 192, 'ID #'.$vew_data->stkmovdoccod);

    $pdf->text( 120, 192, 'Fecha:');
    $pdf->text( 160, 192, 'Autorizado por: .....................................');
    $pdf->text( 220, 192, 'Entregado por: .....................................');

  	$pdf->setfont('helvetica', '', 10);    
  }	
	$pdf->Output('remito.pdf', 'I');
?>
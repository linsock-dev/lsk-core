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
  $lo_sysdocclsmdl= $this->co_reg->load->model('sysdoccls');
  $lo_sysdocclsmdl->load( array('sysdocclscod'=>$vew_data->stkmovdoccod));
  $lv_srcobjtyp = $this->co_reg->request->post['srcobjtyp'];
	$lv_dstobjtxt_2renglones = (strlen($vew_data->dstobjtxt) > 25?7:0);
	
  for($i=0; $i<$vew_msgqty; $i++){
    $pdf->AddPage('P');

    // Encabezado
    $pdf->line( 5,9,205,9);	
    $pdf->line( 5,9,5,($lv_srcobjtyp=='stk_sou'?76:68)+$lv_dstobjtxt_2renglones);	
    $pdf->line( 205,9,205,($lv_srcobjtyp=='stk_sou'?76:68)+$lv_dstobjtxt_2renglones);	

    $pdf->setfont('helvetica', '', 7);
    $pdf->text( 180, 5, 'F' );
    $pdf->text( 195, 5, 'REV' );
    $pdf->setfont('helvetica', 'B', 7);
    $pdf->text( 182, 5, '-046-SS' );
    $pdf->text( 201, 5, '00' );
	    
    $pdf->setfont('helvetica', 'B', 10);
    $pdf->text( 8, 12, $vew_datbus->bustxt );
    $pdf->setfont('helvetica', '', 9);
    $pdf->text( 8, 18, 'Montajes Electromecánicos y Civiles' );
    $pdf->text( 8, 22, $vew_datbus->adr->adrstr.' '.$vew_datbus->adr->adrstrnum);
    $pdf->text( 58, 22, $vew_datbus->adr->adrcty);
    $pdf->text(	8, 26, $vew_datbus->adr->lndregtxt);
    $pdf->text( 58,26, $vew_datbus->adr->adrpstcod);
    $pdf->line( 5, 34, 205, 34);
    

    $pdf->line( 100, 9, 100, 49+$lv_dstobjtxt_2renglones);
    $pdf->line( 133, 9, 133, 34);
    $pdf->setfont('helvetica', 'B', 24);
    $pdf->text( 102, 16, 'TRANS');
    $pdf->setfont('helvetica', 'B', 9);
    $pdf->text( 140, 9, 'TRANSFERENCIA ENTRE ALMACENES');
    $pdf->line( 133, 14, 205, 14);
    $pdf->setfont('helvetica', 'B', 20);
    $pdf->text( 135, 15, 'N°:');
    $pdf->setXY(150, 15); $pdf->cell( 50, 5, $vew_data->stkmovdoccod, 0, 0, 'R');
    $pdf->line( 133, 25, 205, 25);
    $pdf->setfont('helvetica', '', 12);
    $pdf->text( 135, 27, 'Fecha:');
    $pdf->setXY(150, 27); $pdf->cell( 50, 5, $vew_data->stkmovdocdte->format('d/m/Y'), 0, 0, 'R');

    $pdf->setfont('helvetica', '', 12);
    $pdf->text( 8, 35, 'Origen:');
    $pdf->text( 8, 42, 'Destino:');
    $pdf->text( 105, 35, 'Reserva:');
    $pdf->text( 105, 42, 'Retira:');
    $pdf->line( 5,49+$lv_dstobjtxt_2renglones,205,49+$lv_dstobjtxt_2renglones);
    $pdf->text( 8, 51+$lv_dstobjtxt_2renglones, 'Doc. Relac.:');
    $pdf->line( 64, 49+$lv_dstobjtxt_2renglones, 64, 58+$lv_dstobjtxt_2renglones);
    $pdf->text( 65, 51+$lv_dstobjtxt_2renglones, 'Referencia:');
    $pdf->line( 5,58+$lv_dstobjtxt_2renglones,205,58+$lv_dstobjtxt_2renglones);
    $pdf->text( 8, 60+$lv_dstobjtxt_2renglones, 'Proyecto:');
    $pdf->line( 5,68+$lv_dstobjtxt_2renglones,205,68+$lv_dstobjtxt_2renglones);
    if($lv_srcobjtyp=='stk_sou'){
      $pdf->text( 8, 69+$lv_dstobjtxt_2renglones, 'Comentarios:');
      $pdf->line( 5,76+$lv_dstobjtxt_2renglones,205,76+$lv_dstobjtxt_2renglones);
    }
    
    $pdf->setfont('helvetica', 'B', 12);
    $pdf->text( 25, 35, $vew_data->srcobjtxt );
    if($lv_dstobjtxt_2renglones == 0){
    	$pdf->text( 25, 42, $vew_data->dstobjtxt );
    }else{
    	$pdf->text( 25, 42, substr($vew_data->dstobjtxt,0,strrpos(substr($vew_data->dstobjtxt,0,25),' ',0)));
      $pdf->text( 25, 42+$lv_dstobjtxt_2renglones, substr($vew_data->dstobjtxt,strrpos(substr($vew_data->dstobjtxt,0,25),' ',0)+1));
    }
    $pdf->text( 120, 42, $vew_doc->gettagvalue($vew_data->stkmovdocatr,'pic') );
    $contacto = ($lv_srcobjtyp=='stk_sou'?$vew_data->dstcnttxt:$vew_data->srccnttxt);
    $pdf->text( 90, 51+$lv_dstobjtxt_2renglones, $contacto);
    $pdf->text( 29, 60+$lv_dstobjtxt_2renglones, $vew_stesrc->stecodext.($vew_stesrc->stecodext!='' && $vew_stedst->stecodext!=''?' / ':'').$vew_stedst->stecodext);
    if($lv_srcobjtyp=='stk_sou'){
    	$pdf->text( 35, 69+$lv_dstobjtxt_2renglones, $vew_data->stkmovdoccmt );
    }

    // Posiciones
    $pdf->setfont('helvetica', '', 10);
    $pdf->setxy( 5, 80+$lv_dstobjtxt_2renglones );	
    $lv_buffer = '<table border="1" cellpadding="5" cellspacing="0">';
    $lv_buffer .= '<tbody><tr>'.
                  '<td align="center" width="90">MATRICULA</td>'.
                  '<td align="center" width="438">DESCRIPCION</td>'.
                  '<td align="center" width="90">UNIDAD</td>'.
                  '<td align="center" width="90">CANTIDAD</td>'.
                  '</tr>';
    foreach($vew_data->stkmovdocmat as $lv_row) {
      if($lv_row['sysdocrejcod']=='0' || $lv_row['sysdocrejcod']==null) {
        $lv_buffer .= '<tr>'.
                      '<td align="left">'.$lv_row['matcodext'].'</td>'.
                      '<td align="left">'.utf8_encode($lv_row['mattxt']).'</td>'.
                      '<td align="left">'.$lv_row['matuntcod'].'</td>'.
                      '<td align="right">'.number_format($lv_row['matqty'],2).'</td>'.
                      '</tr>';
      }
    }	
    $lv_buffer .= '</tbody></table>';
    $pdf->writeHTML($lv_buffer);
    // ---------------------------------------------------------

    $pdf->setfont('helvetica', 'B', 14);
    
    // PIE
    $pdf->line( 5,260,205,260);	
    $pdf->line( 5,260,5,285);	
    $pdf->line( 205,260,205,285);	
    $pdf->line( 5,285,205,285);
    $pdf->setfont('helvetica', '', 9);
    $pdf->text( 30, 261, 'Emisor');
    $pdf->text( 6, 270, 'Firma:');
    $pdf->text( 23, 268, $vew_data->accusr );
    $pdf->text( 23, 272, $vew_data->accdte->format('d/m/Y H:i') );
    $pdf->text( 6, 278, 'Aclaración:');
    $pdf->line( 70,260,70,285);	
    $pdf->text( 92, 261, 'Despachante');
    $pdf->text( 71, 270, 'Firma:');
    $pdf->text( 71, 278, 'Aclaración:');
    $pdf->line( 135,260,135,285);	
    $pdf->text( 161, 261, 'Receptor');
    $pdf->text( 136, 270, 'Firma:');
    $pdf->text( 136, 278, 'Aclaración:');

    $pdf->setfont('helvetica', '', 6);
    $pdf->text( 5, 287, $vew_data->ctedte->format('d/m/Y H:i') );
    $pdf->text( 188, 287, 'Página 1 de 1');
  }

	$pdf->Output(($lv_srcobjtyp=='stk_sou'?'vale_de_salida.pdf':'vale_de_ingreso.pdf'), 'I');	
?>
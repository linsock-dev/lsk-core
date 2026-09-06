<?php
  // Include the main TCPDF library (search for installation path).
  require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

	// Extend the TCPDF class to create custom Header and Footer
	class MYPDF extends TCPDF { 
    public function Header() {
			// FALTA: TOMAR EL LOGO DESDE LA EMPRESA => USAR COMO REFERENCIA LA IMPRESION DE FACTURA (SLSINV)
			$this->Image('library/images/logos/supplysouth.jpg',10,5,32);
			$this->setfont('helvetica', 'B', 12);
			$this->text( 65, 7, 'ANALISIS DE TRABAJO SEGURO (A.T.S.)'); 
			$this->setfont('helvetica', '', 8);
			$this->text( 178, 7, 'F-008-SS'); $this->text( 178, 11, 'Rev. 00'); 
			$this->line( 10,19,195,19); 
    }
		
    public function Footer() {
			$this->SetY(-15);
			$this->line( 10,$this->getY(),195,$this->getY());
			$this->SetFont('helvetica', 'I', 7);
			$this->text(178, $this->getY()+4, 'Pagina '.$this->getAliasNumPage().' de '.$this->getAliasNbPages() );
    }
	}

  // create new PDF document
  $pdf = new MYPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'ISO-8859-1', false);

  // remove default header/footer
  //$pdf->setPrintHeader(false);
  //$pdf->setPrintFooter(false);

  // set default monospaced font
  $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

  // set margins
  $pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
	$pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
	$pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

  // set auto page breaks
  $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);

  // set image scale factor
  $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

	for($i=0; $i<$vew_msgqty; $i++){
    // ---------------------------------------------------------
    $pdf->AddPage('P');

		// ENCABEZADO OBRA
    // obtengo unidad de negocio
    $lv_unttxt = '';
    foreach( $vew_ste->stecnt as $lv_rowcnt ){
      if($lv_rowcnt['sysdocclscodext']=='UNT'){
        $lv_unttxt = $lv_rowcnt['cntdsttxt'];
        break;
      }
    }
    // obtengo supevisor ss
    $lv_supsuptxt = '';
    foreach( $vew_ste->stecnt as $lv_rowcnt ){
      if($lv_rowcnt['sysdocclscodext']=='SUPSUP'){
        $lv_supsuptxt = $lv_rowcnt['cntdsttxt'];
        break;
      }
    }
    $pdf->setfont('helvetica', 'B', 8);
    $pdf->text( 10, 24, 'UNIDAD DE NEGOCIO:'); 
    $pdf->text( 108, 24, 'SUPERVISOR:');
    $pdf->text( 10, 31, 'FECHA:');
    $pdf->text( 60, 31, 'ID:');
    $pdf->text( 108, 31, 'UBICACIÓN:');
    $pdf->setfont('helvetica', '', 9);
    $pdf->text( 42, 24, $lv_unttxt);
    $pdf->text( 24, 31, date_format($vew_data->steevtdte,'d/m/Y') );
    $pdf->text( 66, 31, $vew_data->stecod.'.'.$vew_data->steevtcod);
    $pdf->text( 129, 24, $lv_supsuptxt);
    $pdf->text( 129, 31, $vew_ste->adr->adrstr.' '.$vew_ste->adr->adrstrnum.' '.$vew_ste->adr->adrstrflr. $vew_ste->adr->adrstrunt);
		$pdf->line( 10,38,195,38);


		// FORMULARIO    		
    // secciones y categorías del formulario
		$lv_ctr = [];
  	$lv_ctr[] = array('title' => 'EPP a utilizar durante todas las etapas de la tarea', 
											'cat' =>array('rop_cal' => 'Ropa de trabajo y Calzado de Seguridad',
																		'cas_seg' => 'Casco de Seguridad', 
																		'prt_ocu' => 'Gafas de protección ocular',
																		'prt_mcn' => 'Guantes de Protección mecánica',
																		'gnt_dbt' => 'Guantes Dieléctricos BT',
																		'gnt_dmt' => 'Guantes Dieléctricos MT',
																		'msk_adf' => 'Máscara antideflagratoria',
																		'arn_seg' => 'Arnés de Seguridad'));
    
    $utf8_data = mb_convert_encoding($vew_data->evtdoc[0]['steevtdocatr'],'UTF-8','iso-8859-1');
    $lv_atr = json_decode ($utf8_data,true);
        
    $lv_strtsk='';
		$lv_strrsk='';
		$lv_strctr='';
		$lv_stroth='';
		$lv_buffer = '<table width="100%" border=0 cellpadding="1" cellspacing="0">'
		  .'<tr>'
		    .'<th style="background-color:#CCC; font-size:14px;" align="center" width="220px"><b>Descripción de los pasos de la tarea a realizar</b></th>'
		    .'<th style="background-color:#CCC; font-size:14px;" align="center" width="220px"><b>Riesgos asociados a cada paso</b></th>'
		    .'<th style="background-color:#CCC; font-size:14px;" align="center" width="220px"><b>Medidas de control asociadas a cada riesgo</b></th>'
		  .'</tr>';
		foreach ($lv_atr as $lv_key => $lv_tsk) {
		  if ($lv_key == 'ATS_TSK') {
		    foreach ($vew_data->tsklst as $lv_rowtsk) {
            // convierto y separo por líneas
            $lv_rsk_lines = array_filter(array_map('trim', explode("\n", strip_tags(utf8_encode($lv_rowtsk['txt']['CNSTSKRSK'] ?? '')))));
            $lv_ctr_lines = array_filter(array_map('trim', explode("\n", strip_tags(utf8_encode($lv_rowtsk['txt']['CNSTSKRSKCTR'] ?? '')))));

            $lv_buffer .= '<tr style="text-align: center;">'
                .'<td>'.htmlspecialchars($lv_rowtsk['cnstsktxt']).'</td>'
                .'<td>'.(!empty($lv_rsk_lines) ? implode("<br>", $lv_rsk_lines) : '-').'</td>'
                .'<td>'.(!empty($lv_ctr_lines) ? implode("<br>", $lv_ctr_lines) : '-').'</td>'
                .'</tr>';       
		    }
		  }
		} 
		$lv_buffer .= '</table>';
  $pdf->setxy( 10, 45 );
  $pdf->writeHTML($lv_buffer);
$lv_buffer2 = '<table width="100%" border=0 cellpadding="1" cellspacing="0">'
		  .'<tr>' 
		    .'<th style="background-color:#CCC; font-size:14px;" align="center" width="100%"><b>Otros Riegos/Controles</b></th>'
		  .'</tr>';
	$max_count = count($lv_atr['ATS_TSK']['newrskctr']);
	if ($max_count == 0) {
		$lv_buffer2 .= '<tr><td align="center">-</td><td align="center">-</td></tr>';
	} else {
		for ($i = 0; $i < $max_count; $i++) {
		    $risk_txt = empty($lv_atr['ATS_TSK']['newrskctr'][$i]['rskctrtxt']) ? '-' : $lv_atr['ATS_TSK']['newrskctr'][$i]['rskctrtxt'];
		    $lv_buffer2 .= '<tr><td align="center">' . $risk_txt . '</td></tr>';
		}
	}
	$lv_buffer2 .= '</table>';

	$pdf->setxy(10, $pdf->getY());	
	$pdf->writeHTML($lv_buffer2);
    
		// ELEMENTOS EPP.
		$pdf->setxy( 10, $pdf->getY() );	
		$lv_atsepp = '';
		foreach($lv_atr as $lv_key=>$lv_tsk){
			if($lv_key=='ATS_EPP'){ $lv_atsepp = $lv_tsk; }
		}
		$lv_buffer = '';
    foreach($lv_ctr as $lv_row){
      $lv_buffer = '<table width="100%" border=0 cellpadding="5" cellspacing="0">'.
                    '<thead><tr><th colspan="4" style="background-color:#CCC; font-size:14px;" align="center"><b>'.$lv_row['title'].'</b></th></tr></thead>'.
                    '<tbody>';
      
			// para cada item de la seccion
			$i=0;
			foreach($lv_row['cat'] as $lv_key=>$lv_txt){
				// si es el primero de la linea, agrego un TR
				if($i%2==0){$lv_buffer.='<tr>';}
				// obtengo valor
				$lv_val = $vew_doc->getTagValue($lv_atsepp, $lv_key);
				// determino si tiene motivo de no cumplimiento
				// armo salida
        $lv_buffer .= '<td align="left" width="40%" style="border-bottom: #CCC 1px solid;">'.$lv_txt.'</td>'.
          						'<td align="right" width="10%" style="border-bottom: #CCC 1px solid;">'.($lv_val=='1'?'SI':($lv_val=='0'?'No':'')).'</td>';
				// si es el ultimo de la fila, cierro con /TR
				if($i%2!=0){$lv_buffer.='</tr>';}
				$i++;
      }
			// si quedo linea sin cerrar, la cierro
			if($i%2!=0){$lv_buffer.='<td colspan="2" style="border-bottom:#CCC 1px solid;"></td></tr>';}
      
      $lv_buffer .= '</tbody></table>'; 
    	$pdf->writeHTML($lv_buffer);      
    }
		
		// ASISTENTES. se muestra la tabla con los asistentes del día
		if( count($vew_ste->ass)>0 ){
			// titulo. escribo titulo de seccion
			$pdf->setxy(10, $pdf->getY()+10 );
			$pdf->setfont('helvetica', 'B', 9);
			$pdf->text( 10, $pdf->getY(), 'ASISTENTES ('.count($vew_ste->ass).'):' ); 
			$pdf->line( 10,$pdf->getY()+5,195,$pdf->getY()+5);
			$pdf->setfont('helvetica', '', 9);
      $lv_buffer = '<table width="100%" border=0 cellpadding="5" cellspacing="0"><thead><tr><th width="400" style="border-bottom: #CCC 1px solid;">Nombre</th><th width="252" style="border-bottom: #CCC 1px solid;">Documento</th></tr></thead><tbody>';
			foreach($vew_ste->ass as $lv_row){
				$lv_buffer.='<tr><td width="400">'.utf8_encode($lv_row['srcobjtxt']).'</td><td width="252">'.(isset($lv_row['taxiibb'])?number_format(intval($lv_row['taxiibb']),0,'','.'):'').'</td></tr>';
			}
      $lv_buffer .= '</tbody></table>'; 
			$pdf->setxy(10, $pdf->getY()+10 );
    	$pdf->writeHTML($lv_buffer);
		}
		
		// UBICACION. se muestra ubicación de la obra
		if($vew_ste->adrmapgeo!=''){
			// titulo. escribo titulo de seccion
			$pdf->setxy(10, $pdf->getY()+10 );
			$pdf->setfont('helvetica', 'B', 9);
			$pdf->text( 10, $pdf->getY(), 'GEOLOCALIZACION:'); 
			$pdf->setfont('helvetica', '', 9);
			$pdf->text( 47, $pdf->getY(), $vew_ste->adrmapgeo);
			$pdf->line( 10,$pdf->getY()+5,195,$pdf->getY()+5);
			// mapa. recupero mapa e imprimo imagen
			$url ='https://maps.googleapis.com/maps/api/staticmap?center='.$vew_ste->adrmapgeo.'&zoom=14&size=400x250&markers=color:red%7Clabel:S%7C'.$vew_ste->adrmapgeo.'&key='.$vew_ste->adrapikey;
			$pdf->Image($url,10,$pdf->GetY()+10,0,0,'PNG');
		}
		
		// ADJUNTOS. se muestran los archivos adjuntos de tipo imagen
		if( count($vew_ste->flecnt)>0 ){
			// titulo. escribo titulo de seccion
			$pdf->setxy(10, $pdf->getY()+90 );
			$pdf->setfont('helvetica', 'B', 9);
			$pdf->text( 10, $pdf->getY(), 'ADJUNTOS ('.count($vew_ste->flecnt).'):'); 
			$pdf->line( 10,$pdf->getY()+5,195,$pdf->getY()+5);
			// imagenes. imprimo imagenes en el documento
			$i=0;
			$pdf->setJPEGQuality(75);
			$pdf->setXY(10, $pdf->getY()+10);
			foreach($vew_ste->flecnt as $lv_fle){
				$lv_imgb64 = $lv_fle; //base64_decode(base64_encode($lv_fle));
				$pdf->Image('@'.$lv_imgb64, $x=($i%2==0?10:110), $y=$pdf->getY(), $w=85, $h=70, $type='', $link='', $align='', $resize=true, $dpi=300, $palign='', $ismask=false, $imgmask=false, $border=0, $fitbox=false, $hidden=false, $fitonpage=false);
				if($i%2!=0){ $pdf->setXY( 10, $pdf->getY()+75 ); }
				$i++;
			}
		}
		
  }	
	$pdf->Output($vew_ste->stecod.'_ATS_'.date_format($vew_data->steevtdte,'Ymd').'_'.$vew_data->steevtcod.'.pdf', 'I');
?>
<?php
  // Include the main TCPDF library (search for installation path).
  require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

	// Extend the TCPDF class to create custom Header and Footer
	class MYPDF extends TCPDF {
    public function Header() {
			// FALTA: TOMAR EL LOGO DESDE LA EMPRESA => USAR COMO REFERENCIA LA IMPRESION DE FACTURA (SLSINV)
			$this->Image('library/images/logos/supplysouth.jpg',10,5,32);
			$this->setfont('helvetica', 'B', 12);
			$this->text( 65, 7, 'INSPECCION DE OBRA EN VIA PUBLICA'); 
			$this->setfont('helvetica', '', 8);
			$this->text( 178, 7, 'F-112-SS'); $this->text( 178, 11, 'Rev. 02'); 
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
    // ACTIVIDAD
    $pdf->Rect( 10, 40, 185, 8, 'DF', array(), array(204, 204, 204));
    $pdf->setfont('helvetica', 'B', 11);
    $pdf->text( 15, 42, 'ACTIVIDAD');
    $pdf->setfont('helvetica', '', 11);
    // excavación
    $lv_val = $vew_doc->getTagValue($vew_data->evtdoc[0]['steevtdocatr'], 'exc');
    $pdf->text( 45, 42, 'Excavación');
    $pdf->setxy(69, 42 );	
    $pdf->writeHTML('<span style="font-family:zapfdingbats;">'.($lv_val ? '3' : '5').'</span>');
    // tendido
    $pdf->text( 80, 42, 'Tendido'); $pdf->text( 98, 42, 'BT'); $pdf->text( 112, 42, 'MT'); $pdf->text( 128, 42, 'AT');
    $lv_val = $vew_doc->getTagValue($vew_data->evtdoc[0]['steevtdocatr'], 'tbt');
    $pdf->setxy( 106, 42 );	
    $pdf->writeHTML('<span style="font-family:zapfdingbats;">'.($lv_val ? '3' : '5').'</span>');
    $lv_val = $vew_doc->getTagValue($vew_data->evtdoc[0]['steevtdocatr'], 'tmt');
    $pdf->setxy( 121, 42 );	
    $pdf->writeHTML('<span style="font-family:zapfdingbats;">'.($lv_val ? '3' : '5').'</span>');
    $lv_val = $vew_doc->getTagValue($vew_data->evtdoc[0]['steevtdocatr'], 'tat');
    $pdf->setxy( 136, 42 );	
    $pdf->writeHTML('<span style="font-family:zapfdingbats;">'.($lv_val ? '3' : '5').'</span>');
    // veredas
    $lv_val = $vew_doc->getTagValue($vew_data->evtdoc[0]['steevtdocatr'], 'vrd');
    $pdf->text( 155, 42, 'Veredas');
    $pdf->setxy( 175, 42 );	
    $pdf->writeHTML('<span style="font-family:zapfdingbats;">'.($lv_val ? '3' : '5').'</span>');
    
    // Posiciones
    $pdf->setfont('helvetica', '', 8);
    $pdf->setxy( 10, 53 );	
    
  $lv_currdate = new DateTime(date('Y-m-d'));
	$lv_steevtdte = $vew_data->steevtdte!=='' ? $vew_data->steevtdte : $lv_currdate;
	$lv_steevtdte = $lv_steevtdte->format('d/m/Y');
	$lv_steevtdte = strtotime($lv_steevtdte); 
    
     if (count($vew_data->evtdoc) > 0 && $vew_doc->getTagValue($vew_data->evtdoc[0]['steevtdocatr'], 'alc_gel') !== ''){
      	$ins_hyg = array(array('tag' => 'alc_gel', 'txt' => 'Alcohol en gel'),
                  										 array('tag' => 'agu_jab', 'txt' =>'Agua y jabón para lavado de manos'), 
                                       array('tag' => 'kit_vhc', 'txt' => 'Kit desinfectante en vehículo'));
      } else {
        $ins_hyg = array(array('tag' => 'ele_hyg', 'txt' => 'Elementos de higiene'));
      }
    
    // secciones y categorías del formulario
  	$lv_ctr = array(array('title' => 'SEÑALIZACIÓN', 
                          'cat' => array(array('tag' => 'car_per', 'txt' => 'Cartel permiso de obra / institucional pública'),
                                        array('tag' => 'car_adv', 'txt' => 'Carteles de advertencia "peligro hombres trabajando" "circule con precaución" "peligro zanja abierta" "reducción de calzada"'), 
                                        array('tag' => 'con_cal', 'txt' => 'Conos en calzadas señalización vehicular'),
                                        array('tag' => 'cin_prv', 'txt' => 'Cinta de prevención peatonal'),
                                        array('tag' => 'cru_cal', 'txt' => 'Cruzada sobre calzada'),
                                        array('tag' => 'cru_bal', 'txt' => 'Cruzada con baliza nocturna'))),
                  array('title' => 'PROTECCIÓN PÚBLICA', 
                        'cat' => array(array('tag' => 'val_com', 'txt' => 'Vallado completo'),
                                      array('tag' => 'abe_val_det_fal', 'txt' => 'Aberturas menores a 50 cm. En vallas (deterioradas con faltantes)'), 
                                      array('tag' => 'her_ens_ala_ens', 'txt' => 'Herrajes ensamblado (uso de alambre y/o sin ensamblar)'),
                                      array('tag' => 'est_val', 'txt' => 'Estabilidad del vallado'),
                                      array('tag' => 'pas_ptn', 'txt' => 'Paso peatonal'),
                                      array('tag' => 'caj', 'txt' => 'Cajones'),
                                      array('tag' => 'her_ens', 'txt' => 'Herrajes ensamblado'),
                                      array('tag' => 'rej', 'txt' => 'Rejillas'))),
                  array('title' => strtoupper($vew_lang->constructionsiteconditions), 
                        'cat' => array(array('tag' => 'tie_esc', 'txt' =>'Tierra y escombro contenido'),
                                      array('tag' => 'pas_ptn_lbr', 'txt' => 'Paso peatonal libre de obstáculos'), 
                                      array('tag' => 'znj_abi_prt', 'txt' => 'Zanja abierta con protección'),
                                      array('tag' => 'ord_lmp', 'txt' => 'Orden y limpieza'),
                                      array('tag' => 'mat_acp', 'txt' => 'Materiales acopiados'),
                                      array('tag' => 'rsd_dsp', 'txt' => 'Residuos - Disposición'))),
                  array('title' => strtoupper($vew_lang->tools), 
                        'cat' => array(array('tag' => 'pls', 'txt' => 'Palas'),
                                      array('tag' => 'pic', 'txt' => 'Pico'), 
                                      array('tag' => 'mas', 'txt' => 'Masa'),
                                      array('tag' => 'mrt_nmt', 'txt' => 'Martillo neumático'),
                                      array('tag' => 'mtc', 'txt' => 'Motocompresor'),
                                      array('tag' => 'grp_elc', 'txt' => 'Grupo electrógeno'),
                                      array('tag' => 'mld', 'txt' => 'Amoladora'),
                                      array('tag' => 'tbl_elc_por', 'txt' => 'Tablero eléctrico portable'),
                                      array('tag' => 'psn', 'txt' => 'Apisonador'),
                                      array('tag' => 'tnl', 'txt' => 'Tunelera'),
                                      array('tag' => 'bat_mzc_mat', 'txt' => 'Batea para mezcla de materiales'),
                                      array('tag' => 'gjr', 'txt' => 'Agujereadora'))),
                  array('title' => strtoupper($vew_lang->jobsecurity), 
                        'cat' => array(array('tag' => 'cms', 'txt' => 'Camisa'),
                                      array('tag' => 'pnt', 'txt' => 'Pantalón'), 
                                      array('tag' => 'cas', 'txt' => 'Casco'),
                                      array('tag' => 'gnt_cue', 'txt' => 'Guante de cuero'),
                                      array('tag' => 'clz_seg', 'txt' => 'Calzado de seguridad'),
                                      array('tag' => 'prt_ocu', 'txt' => 'Protector ocular'),
                                      array('tag' => 'prt_fac', 'txt' => 'Protector facial'),
                                      array('tag' => 'prt_aud', 'txt' => 'Protector auditivo'),
                                      array('tag' => 'faj_lum', 'txt' => 'Faja lumbar'),
                                      array('tag' => 'tpb_cov', 'txt' => 'Tapabocas – Covid-19'))), 
                  array('title' => 'TENDIDO', 
                        'cat' => array(array('tag' => 'prt_cbl_los_lad', 'txt' => 'Protecciones de cables losetas / ladrillos'),
                                        array('tag' => 'enr_cbl', 'txt' => 'Enrollado de cable'), 
                                        array('tag' => 'rdl', 'txt' => 'Rodillos'),
                                        array('tag' => 'int', 'txt' => 'Interferencias'),
                                        array('tag' => 'cap', 'txt' => 'Capuchones'),
                                        array('tag' => 'cin_adv_los', 'txt' => 'Cinta de advertencias / loseta'))),
                  array('title' => 'DOCUMENTACIÓN', 
                        'cat' => array(array('tag' => 'pln', 'txt' => 'Plano'),
                                      array('tag' => 'per_mnc', 'txt' => 'Permisos municipales'), 
                                      array('tag' => 'cre_art_srl', 'txt' =>'Credenciales ART / SUPPLY SOUTH S.R.L'),
                                      array('tag' => 'mts', 'txt' => 'MTS (Método de trabajo seguro)'),
                                      array('tag' => 'pln_seg_vig', 'txt' => 'Plan de seguridad vigente'),
                                      array('tag' => 'crt_art', 'txt' => 'Certificado de cobertura de ART'))),
                  array ('title' => 'HIGIENE', 'cat' => $ins_hyg)
          );
    
    foreach($lv_ctr as $lv_row){
      $lv_buffer = '<table width="100%" border=0 cellpadding="5" cellspacing="0">'.
                    '<thead><tr><th colspan="4" style="background-color:#CCC; font-size:14px;" align="center"><b>'.$lv_row['title'].'</b></th></tr></thead>'.
                    '<tbody>';
      
      for($i = 0; $i < ceil(count($lv_row['cat'])/2); $i++ ){
        $lv_inc = false;
      	$lv_rowinc = '<tr><td colspan="2" style="background-color:#f2f2f2; border-bottom: #CCC 1px solid;">';
        $lv_val = $vew_doc->getTagValue($vew_data->evtdoc[0]['steevtdocatr'], $lv_row['cat'][$i]['tag']);
        
        $lv_buffer .= '<tr>'.
          						'<td align="left" style="border-bottom: #CCC 1px solid;">'.$lv_row['cat'][$i]['txt'].'</td>'.
          						'<td align="right" style="border-bottom: #CCC 1px solid;">'.($lv_val=='yes'?'Bien':($lv_val=='no'?'No cumple':'N/A')).'</td>';
        if($lv_val == 'no'){
          $lv_inc = true;
          $lv_inc = $vew_doc->getTagValue($vew_data->evtdoc[0]['steevtdocatr'], $lv_row['cat'][$i]['tag'].'-inc');
          $lv_inc = utf8_encode($lv_inc);
          $lv_rowinc .= 'DESCRIPCIÓN: '.$lv_inc;
        }
        $lv_rowinc .= '</td>';
          
        $j = $i + ceil(count($lv_row['cat'])/2);
        $lv_rowinc .= '<td colspan="2" style="background-color:#f2f2f2; border-bottom: #CCC 1px solid;">';
        if($j < count($lv_row['cat'])){
        	$lv_val = $vew_doc->getTagValue($vew_data->evtdoc[0]['steevtdocatr'], $lv_row['cat'][$j]['tag']);
          $lv_buffer .= '<td align="left" style="border-bottom: #CCC 1px solid;">'.$lv_row['cat'][$j]['txt'].'</td>'.
          							'<td align="right" style="border-bottom: #CCC 1px solid;">'.($lv_val=='yes'?'Bien':($lv_val=='no'?'No cumple':'N/A')).'</td>';
          if($lv_val == 'no'){
            $lv_inc = true;
            $lv_inc = $vew_doc->getTagValue($vew_data->evtdoc[0]['steevtdocatr'], $lv_row['cat'][$j]['tag'].'-inc');
            $lv_inc = utf8_encode($lv_inc);
            $lv_rowinc .= 'DESCRIPCIÓN: '.$lv_inc;
          }
        }else{
          $lv_buffer .= '<td style="border-bottom: #CCC 1px solid;"></td><td style="border-bottom: #CCC 1px solid;"></td>';
        }
        $lv_rowinc .= '</td>';
        
        $lv_rowinc .= '</tr>';
        $lv_buffer .= '</tr>'.($lv_inc ? $lv_rowinc : '');
      }
      
      $lv_buffer .= '</tbody></table>'; 
    	$pdf->writeHTML($lv_buffer);
      
      // reposiciono 
      $pdf->setxy( 10, $pdf->getY() + 1 );	
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
				$lv_buffer.='<tr><td width="400">'.utf8_encode($lv_row['srcobjtxt']).'</td><td width="252">'.number_format(intval( ($lv_row['taxiibb']??0) ),0,'','.').'</td></tr>';
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
	$pdf->Output($vew_ste->stecod.'_Inspeccion_'.date_format($vew_data->steevtdte,'Ymd').'_'.$vew_data->steevtcod.'.pdf', 'I');
?>
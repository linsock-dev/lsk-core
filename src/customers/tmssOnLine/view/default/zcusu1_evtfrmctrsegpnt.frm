<?php
  // Include the main TCPDF library (search for installation path).
  require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

	// Extend the TCPDF class to create custom Header and Footer
	class MYPDF extends TCPDF {
    public function Header() {
			// FALTA: TOMAR EL LOGO DESDE LA EMPRESA => USAR COMO REFERENCIA LA IMPRESION DE FACTURA (SLSINV)
			$this->Image('library/images/logos/supplysouth.jpg',10,5,32);
			$this->setfont('helvetica', 'B', 12);
			$this->text( 75, 7, 'CONTROL DE SEGURIDAD'); 
			$this->setfont('helvetica', '', 8);
			$this->text( 178, 7, 'F-111-SS'); $this->text( 178, 11, 'Rev. 00'); 
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

	for($i=0; $i < $vew_msgqty; $i++){
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
    // Posiciones
    $pdf->setfont('helvetica', '', 8);
    $pdf->setxy( 10, 40 );	
    
    // secciones y categorías del formulario
		$lv_ctr = [];
  	$lv_ctr[] = array('title' => '5 REGLAS DE ORO', 
                      'cat' =>array('crt_tns' => 'Corte efectivo de todas las fuentes de tensión',
																		'apr_crt_sec' => 'Bloque de los aparatos de corte o de seccionamiento', 
																		'aus_tns' => 'Comprobación de ausencia de tensión',
																		'gnd_cir' => 'Puesta a tierra y en corto circuito',
																		'det_zon_sng' => 'Determinacón de la zona de trabajo y señalización de los equipos más próximos bajo tensión'
																		));
    $lv_ctr[] = array('title' => 'PROCEDIMIENTO PT 6202', 
											'cat' =>array('zon_prt' => 'Creación de la Zona Protegida',
																		'zon_tra' => 'Creación de la Zona de Trabajo', 
																		'pat' => 'Procedimiento de colocació de P.A.T. transitoria',
																		'seg_nvl_tns' => 'Distancia de seguridad de acuerdo al nivel de tensión',
																		'prt_seg' => 'Comportamiento y cumplimiento de requisitos en el trabajo y durante la reposición del servicio (cumplimiento PT6202 Entrega y devolución MT o PT6106) - Protocolo de Seguridad N°'
																		));
    $lv_ctr[] = array('title' => 'NORMAS Y PROCEDIMIENTOS DE SEGURIDAD', 
											'cat' =>array('ps05' =>'PS-05 Planilla de Autocontrol EPP, ESC y Herram Anex E y F',
																		'is40' => 'IS-40 Trabajo en altura - Comprobación estado del poste', 
																		'it_5407_54023' => 'IT-5407 Y 54023 Identificación y pinchado de cable (BT-MT)',
																		'ps13' => 'PS-13 Apuntalamiento de excavaciones y zanjas',
																		'is59' => 'IS-59 Aná de Tarea Segura – Trabajos de Contratistas'
																		));
    $lv_ctr[] = array('title' => 'NORMAS Y PROCEDIMIENTOS DE SEGURIDAD EN VIA PUBLICA', 
											'cat' =>array('vld' => 'Vallado (Estado de vallas, cierre, faltante, etc.)',
																		'prl_mdr' => 'Parillas de madera', 
																		'sng_prt_pub' => 'Elementos de señalización de vía pública (carteles e iluminación)',
																		'con_cin' => 'Conos / columnas, cintas / cadenas',
																		'pln_vhc' => 'Planchones para vehículos',
																		'cnt_grnd' => 'Contenedores de tierra',
																		'snd_ptn' => 'Senda peatonal'
																		));
    $lv_ctr[] = array('title' => 'NORMAS Y PROCEDIMIENTOS EN MEDIO AMBIENTE', 
											'cat' =>array('seg_res' => 'Segregación de residuos',
																		'ord_lmp' => 'Orden y limpieza general', 
																		'per_hdr' => 'Pérdida de hidrocarburos (incluye vehículos, equipos, grúas e incidentes durante los trabajos)',
																		'trn_tra' => 'Transporte de transformadores (Batea, amarres, lona, etc.)',
																		'cnt_der' => 'Contención de derrames de aceites y remediación de suelos'
																		));
    $lv_ctr[] = array('title' => 'ELEMENTOS DE PROTECCION PERSONAL', 
											'cat' =>array('cas' => 'Casco',
																		'cal_seg' => 'Calzado de seguridad', 
																		'rop_tra' => 'Ropa de trabajo (*)',
																		'gnt_dmt' => 'Guantes dieléctricos de MT',
																		'gnt_dbt' => 'Guantes dieléctricos de BT',
																		'gnt_pmc' => 'Guantes protección mecánica',
																		'gnt_kev' => 'Guantes de kevlar (protección térmica)',
																		'gnt_acr' => 'Guantes de acrilonitrilo (protección química)',
																		'prt_ocu' => 'Protección ocular (gafas)',
																		'msk_adf' => 'Mascara anti-deflagratoria',
																		'rsc_alt' => 'Equipo rescate para trabajo en altura',
																		'arn_seg' => 'Arnés de seguridad',
																		'msk_fpo' => 'Mascara con filtro para polvo',
																		'msk_fga' => 'Mascara con filtro para gases',
																		'prt_aud' => 'Protector auditivo',
																		'trp' => 'Trepadores'
																		));
    $lv_ctr[] = array('title' => 'HERRAMIENTAS Y SEGURIDAD COLECTIVA', 
											'cat' =>array('prt_man' => 'Pértiga de maniobra',
																		'det_btmt' => 'Detector de tensión y concordancia de fase (MT-BT)', 
																		'bst_dsc' =>'Bastón descargador',
																		'eqp_pat' => 'Equipo de PAT normalizado',
																		'alf_ais' => 'Alfombras aislantes',
																		'prt_ais' => 'Mantas/ Vainas/Protectores y pantallas aislantes',
																		'sog_srv' => 'Soga de servicio',
																		'esc_die' => 'Escaleras dieléctricas',
																		'tls_ais_tbt' => 'Herramientas aisladas p/trabajos en BT con tensión',
																		'mnp_fnh' => 'Manopla extracción fusibles NH',
																		'eqp' => 'Equipos'
																		));
    $lv_ctr[] = array('title' => 'ESTADO DE VEHICULOS', 
											'cat' =>array('hid' => 'Hidroelevador/Hidrogrua',
																		'vhc_dom' => 'Vehículos (*) Dominio:', 
																		'mat_vhc' => 'Estiba de materiales en vehículos',
																		'vtv' => 'VTV. Vencimiento',
																		'mtf_vnc' => 'Matafuego vehicular. Vencimiento',
																		'bot_aux' => 'Botiquín de primeros auxilios',
																		'reg_cnd' => 'Registro de conducir',
																		));
    
    // para cada seccion
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
				$lv_val = $vew_doc->getTagValue($vew_data->evtdoc[0]['steevtdocatr'], $lv_key);
				// determino si tiene motivo de no cumplimiento
				$lv_mtv='';
        if($lv_val=='no'){
          $lv_mtv = $vew_doc->getTagValue($vew_data->evtdoc[0]['steevtdocatr'], $lv_key.'-inc');
					if($lv_mtv!=''){ $lv_mtv='DESCRIPCION: '.$lv_mtv; }
        }
				// armo salida
        $lv_buffer .= '<td align="left" width="40%" style="border-bottom: #CCC 1px solid;">'.$lv_txt.($lv_mtv!=''?'<br><b>'.$lv_mtv.'</b>':'').'</td>'.
          						'<td align="right" width="10%" style="border-bottom: #CCC 1px solid;">'.($lv_val=='yes'?'Bien':($lv_val=='no'?'No cumple':'N/A')).'</td>';
				// si es el ultimo de la fila, cierro con /TR
				if($i%2!=0){$lv_buffer.='</tr>';}
				$i++;
      }
			// si quedo linea sin cerrar, la cierro
			if($i%2!=0){$lv_buffer.='<td colspan="2" style="border-bottom:#CCC 1px solid;"></td></tr>';}
      
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
				$lv_buffer.='<tr><td width="400">'.mb_convert_encoding($lv_row['srcobjtxt'],'UTF-8','iso-8859-1').'</td><td width="252">'.number_format(intval($lv_row['taxiibb']),0,'','.').'</td></tr>';
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
	$pdf->Output($vew_ste->stecod.'_ControlSeguridad_'.date_format($vew_data->steevtdte,'Ymd').'_'.$vew_data->steevtcod.'.pdf', 'I');
?>
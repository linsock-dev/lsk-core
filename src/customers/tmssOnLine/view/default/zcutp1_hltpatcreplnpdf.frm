<?php
  require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');
  class MYPDF extends TCPDF {

    public function Header() {
      $this->SetXY(22.4, 3);
      $this->Image('https://customers.gorse.ar/library/images/logos/teampediatrico.jpg', 22.4, 3, 40, 20, '', '', '', false, 30, '', false, false, 0);

      $this->SetFont('helvetica', 'B', 6); 
      $this->SetTextColor(34, 68, 136);

      $this->SetXY(59, 7); // Posición fija para el título
      $this->SetFont('helvetica', 'B', 18);
      $this->Cell(102, 1, 'Formulario', 0, 0, 'C');

      $this->SetXY(39, 14); // Posición fija para el subtítulo
      $this->SetFont('helvetica', 'I', 10);
      $this->Cell(140, 7, 'Registro del plan de cuidados', 0, 0, 'C');
    }
     
    public function Footer() {
        // Posición del footer
        $this->SetFont('helvetica', 'B', 6); 
        $this->SetTextColor(34, 68, 136);
        $this->SetXY(160.4, 280);
        $this->Write(0, 'Codigo: OP-PR-02.F0-01');
    	
    }
  }

  //CREANDO NUEVO DOCUMNETO PDF
  $pdf = new MYPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT,true, 'UTF-8', false);
  $pdf->SetMargins(5, 10, 2); // Establecer márgenes (izquierda, arriba, derecha)
  $pdf->Ln(30);

  //establecer margenes
  $pdf->SetMargins(25, 25, 25, 40);
	$pdf->SetHeaderMargin(5,5,5,10);
  $pdf->setPrintFooter(true); //Defino el estado del footer
  $pdf->setPrintHeader(true); //Defino el estado del Header
  $pdf->SetAutoPageBreak(true,23);
 	$pdf->addPage();
	
  // set default header data
  $pdf->setHeaderData(PDF_HEADER_LOGO, PDF_HEADER_LOGO_WIDTH, PDF_HEADER_TITLE, PDF_HEADER_STRING);
	$pdf->setFooterData(PDF_HEADER_LOGO_WIDTH, PDF_HEADER_TITLE, PDF_HEADER_STRING);

	// set margins
  $pdf->SetHeaderMargin(5,5,5,10);
  $pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

	$lv_lstdte = '-';
	$lv_epcdte = '-';
	$lv_crerqm = '-';
	$lv_chgpln = '-';
	$lv_mds = '-';
	foreach ($vew_data->txtdat as $elemento) {
  	if (isset($elemento["txttypcodext"]) && $elemento["txttypcodext"] === "TXT_UI") { $lv_lstdte = $elemento["txttxt"]; }
  	elseif (isset($elemento["txttypcodext"]) && $elemento["txttypcodext"] === "FDE") { $lv_epcdte = $elemento["txttxt"]; }
  	elseif (isset($elemento["txttypcodext"]) && $elemento["txttypcodext"] === "REQE") { $lv_crerqm = $elemento["txttxt"]; }
    elseif (isset($elemento["txttypcodext"]) && $elemento["txttypcodext"] === "CC") { $lv_chgpln = $elemento["txttxt"]; }
    elseif (isset($elemento["txttypcodext"]) && $elemento["txttypcodext"] === "MDS") { $lv_mds = $elemento["txttxt"]; }
  }
		
	$lv_cmpmed = '-';
	$lv_cmpenf = '-';
	$lv_cmpreh = '-';

	foreach ($vew_data->htlpat->prsrls as $elemento) {
  	if (isset($elemento["prsrlscodext"]) && $elemento["prsrlscodext"] === "CMPMED") { $lv_cmpmed = $elemento["prstxt"]; }
  	elseif (isset($elemento["prsrlscodext"]) && $elemento["prsrlscodext"] === "CMPENF") { $lv_cmpenf = $elemento["prstxt"]; }
  	elseif (isset($elemento["prsrlscodext"]) && $elemento["prsrlscodext"] === "CMPREH") { $lv_cmpreh = $elemento["prstxt"]; }
    
  }

	$lv_patcpx = $vew_data->htlpat->patcpx;

	$lv_buffer = '<table border="1" cellpadding="2" align="auto" style="font-family: Helvetica;font-size: 8pt;width: 100%;">'.
								'<tr nobr="true">'.
									'<th style="background-color:#dedede; font-weight: bold">FECHA DE VIGENCIA</th>'.
										'<td>'.date_format($vew_data->patcreplnenddte,'d/m/Y').'</td>'.
									'<th style="background-color:#dedede; font-weight: bold">N° DE PLAN</th>'.
										'<td>'.$vew_data->patcreplncod.'</td>'.
									'</tr></table>';
  
	$lv_buffer .=	'<h3 style= text align="center"; color="rgb(34, 68, 136)">REGISTRO DEL PLAN DE CUIDADOS</h3>'.
								'<table border="1" cellpadding="2" align="center" style="font-family: Helvetica;font-size: 8pt;">'.
									'<tr nobr="true">'.
										'<th style="background-color:#dedede; font-weight: bold; text-align: left;" colspan="1">NOMBRE</th>'.
											'<td>'.$vew_data->pattxt.'</td>'.
										'<th style="background-color:#dedede; font-weight: bold; text-align: left;" colspan="1">FECHA DE NACIMIENTO</th>'.
											'<td>'. (is_object($vew_data->htlpat->per->perbrndte) ? $vew_data->htlpat->per->perbrndte->format('d/m/Y') : '-') .'</td>'.
									'</tr>'.  
									'<tr>'.
										'<th style="background-color:#dedede; font-weight: bold; text-align: left;" colspan="1">PESO ACTUAL</th>'.
											'<td>'.($vew_data->patwgt!=''? floatval($vew_data->patwgt) .'Kg' : '-' ).'</td>'.
										'<th style="background-color:#dedede; font-weight: bold; text-align: left;" colspan="1">CAT. DEL CUIDADO</th>'.
											'<td>'.($lv_patcpx=='M'?'Media':($lv_patcpx=='A'?'Alta':($lv_patcpx=='B'?'Baja':'-'))).'</td>'.
									'</tr>'.
									'<tr nobr="true">'.
										'<th style="background-color:#dedede; font-weight: bold; text-align: left;" colspan="1">FINANCIADOR</th>'.
										'<td style="text-align: center;" colspan="3">'. ($vew_data->htlpat->custxt!=''?$vew_data->htlpat->custxt:'-').'</td>'. 
									'</tr>'.
									'<tr>'.
										'<th style="background-color:#dedede; font-weight: bold; text-align: left;" colspan="1">DIAGNOSTICO MEDICO</th>'.
										'<td style="text-align: center;" colspan="3">'.($vew_data->htlpat->hltdisclstxt!=''?utf8_encode($vew_data->htlpat->hltdisclstxt):'-').'</td>'.
									'</tr>'.
									'<tr>'.
										'<th style="background-color:#dedede; font-weight: bold; text-align: left;" colspan="1">MEDICO DE SEGUIMIENTO</th>'.
											'<td style="text-align: center;" colspan="3">'.$lv_mds. '</td>'.
									'</tr>'.
									'<tr>'.
										'<th style="background-color:#dedede; font-weight: bold; text-align: left;" colspan="1">DIAGNOSTICO PRINCIPAL DE ENFERMERIA</th>'.
										'<td style="text-align: center;" colspan="3">'.($vew_data->htlpat->evldia!=''?utf8_encode($vew_data->htlpat->evldia):'-'). '</td>'.
									'</tr>'.
									'<tr>'.
										'<th style="background-color:#dedede; font-weight: bold; text-align: left;" colspan="1">ULTIMA INTERNACION</th>'.
											'<td style="text-align: center;" colspan="3">'.$lv_lstdte.'</td>'.
									'</tr>'.
									'<tr>'.
										'<th style="background-color:#dedede; font-weight: bold; text-align: left;" colspan="1">FECHA DE EPICRISIS</th>'.
											'<td style="text-align: center;" colspan="3">'.$lv_epcdte.'</td>'.
									'</tr>'.
									'</table>';

  $lv_buffer .= '<h3 style= text align="center"; color="rgb(34, 68, 136)">DATOS DEL DOMICILIO</h3>'.
								'<table border="1" cellpadding="2" align="center" style="font-family: Helvetica;font-size: 8pt">'.
									'<tr nobr="true">'.
										'<th style="background-color:#dedede; font-weight: bold">DIRECCION</th>'.
										'<th style="background-color:#dedede; font-weight: bold">NUMERO</th>'.
										'<th style="background-color:#dedede; font-weight: bold">PISO</th>'.
										'<th style="background-color:#dedede; font-weight: bold">TEL.CONTACTO</th>'.
										'<th style="background-color:#dedede; font-weight: bold">LOCALIDAD</th>'.
										'<th style="background-color:#dedede; font-weight: bold">ZONA</th>'.
									'</tr>'.
									'<tr>'.
										'<td>'.($vew_data->htlpat->adr->adrstr!='' ? utf8_encode($vew_data->htlpat->adr->adrstr):'-').'</td>'.
										'<td>'.($vew_data->htlpat->adr->adrstrnum!='' ? utf8_encode($vew_data->htlpat->adr->adrstrnum):'-').'</td>'.
										'<td>'.($vew_data->htlpat->adr->adrstrflr!='' ? $vew_data->htlpat->adr->adrstrflr:'-').'</td>'.
										'<td>'.($vew_data->htlpat->adr->adrmblphn!='' ? $vew_data->htlpat->adr->adrmblphn:'-').'</td>'.
										'<td>'.($vew_data->htlpat->adr->adrcty!='' ? utf8_encode($vew_data->htlpat->adr->adrcty):'-').'</td>'.
										'<td>'.($vew_data->htlpat->adr->adrtwn!='' ? utf8_encode($vew_data->htlpat->adr->adrtwn):'-').'</td>'.
									'</tr></table>';

	$lv_buffer .= '<h3 style= text align="center"; color="rgb(34, 68, 136)">REQUERIMIENTOS</h3>'.
								'<table border="1" cellpadding="2" align="center" style="font-family: Helvetica;font-size: 8pt;">'.
									'<tr nobr="true">'.
										'<td style="background-color:#dedede; font-weight: bold">DISPOSITIVOS DEL PACIENTE Y SEGURIDAD DEL PACIENTE</td>'.
									'</tr>';

	$max_count = count($vew_data->patcreplnmat);
	if ($max_count == 0) {
		$lv_buffer .= '<tr><td align="center">-</td></tr>';
	} else {
		for ($i = 0; $i < $max_count; $i++) {
			if ($vew_data->patcreplnmat[$i]['sysdocclscodext'] == "CERH" && $vew_data->patcreplnmat[$i]['matclstxt'] == "DISPOSITIVOS Y SEGURIDAD"){
				$lv_buffer .= '<tr><td align="center">' . $vew_data->patcreplnmat[$i]['mattxt'] . '</td></tr>';
			}      
		}
	}
	$lv_buffer .= '</table>';

	$lv_buffer .= '<h3 style= text align="center"; color="rgb(34, 68, 136)">RECURSOS HUMANOS DEL PACIENTE</h3>'.
								'<table border="1" cellpadding="2" align="center" style="font-family: Helvetica;font-size: 8pt;">'.
									'<tr nobr="true">'.
										'<th style="background-color:#dedede; font-weight: bold">CLASE</th>'.
										'<th style="background-color:#dedede; font-weight: bold">DENOMINACION</th>'.
										'<th style="background-color:#dedede; font-weight: bold">CANTIDAD</th>'.
										'<th style="background-color:#dedede; font-weight: bold">UM</th>'.
										'<th style="background-color:#dedede; font-weight: bold">FRECUENCIA</th>'.
										'<th style="background-color:#dedede; font-weight: bold">UM FRECUENCIA</th>'.
									'</tr>';
	
	if ($max_count == 0) {
		$lv_buffer .= '<tr><td align="center">-</td><td align="center">-</td><td align="center">-</td><td align="center">-</td><td align="center">-</td><td align="center">-</td></tr>';
	} else {
		foreach($vew_data->patcreplnmat as $lv_row){
			if ($lv_row['sysdocclscodext']=='CERH' && $lv_row['matclstxt']=='RECURSOS HUMANOS'){
				 $lv_buffer .= '<tr>'.
										'<td>'.$lv_row['matclstxt'] .'</td>'.
										'<td>'.$lv_row['mattxt'] .'</td>'.
										'<td>'.$lv_row['matqty'] .'</td>'.
										'<td>'.$lv_row['matuntcod'] .'</td>'.
										'<td>'.floatval($lv_row['matfrqqty']) .'</td>'.
										'<td>'.($lv_row['matfrq']=='D'?'Dia' : ($lv_row['matfrq']=='S'?'Semana' : ($lv_row['matfrq']=='M'?'Mes' : ($lv_row['matfrq']=='A'?'Año' : '-')))).'</td>'.
									'</tr>';
			}
		}
	}
	$lv_buffer .= '</table>';

	$lv_buffer .= '<h3 style= text align="center"; color="rgb(34, 68, 136)">CUIDADOS ASIGNADOS</h3>'.
		'<table border="1" cellpadding="2" align="center" style="font-family: Helvetica;font-size: 8pt;">'.
		'<tr nobr="true">'.
			'<th style="background-color:#dedede; font-weight: bold">REQUERIMIENTO DEL CUIDADO</th>'.
		'</tr>'.
		'<tr nobr="true">'.
			'<td style="text-align: center;" colspan="3">'.$lv_crerqm.'</td>'.
		'</tr>'.
		'</table>';

	$lv_buffer .= '<h3 style= text align="center"; color="rgb(34, 68, 136)">EQUIPAMIENTO E INSUMOS</h3>'.
						'<table border="1" cellpadding="2" align="center" style="font-family: Helvetica;font-size: 8pt;">'.
							'<tr nobr="true">'.
								'<th style="background-color:#dedede; font-weight: bold">ID</th>'.
      					'<th style="background-color:#dedede; font-weight: bold">CLASE</th>'.
								'<th style="background-color:#dedede; font-weight: bold">DENOMINACION</th>'.
								'<th style="background-color:#dedede; font-weight: bold">CANTIDAD</th>'.
							'</tr>';
		
		if ($max_count == 0) {
      $lv_buffer .= '<tr><td align="center">-</td><td align="center">-</td><td align="center">-</td><td align="center">-</td></tr>';
    } else {
      foreach($vew_data->patcreplnmat as $lv_row) {
      	if ($lv_row['sysdocclscodext']=='CEE' || $lv_row['sysdocclscodext']=='CEI'){
           $lv_buffer .= '<tr>'.
											'<td>'. $lv_row['matcod'] .'</td>'.
											'<td>'. $lv_row['matclstxt'] .'</td>'.  
             					'<td>'. $lv_row['mattxt'] .'</td>'.
             					'<td>'. floatval($lv_row['matqty']) .'</td>'.
             				'</tr>';
        }
      }
    }
		$lv_buffer .= '</table>';
		
		$lv_buffer .= '<h3 style= text align="center"; color="rgb(34, 68, 136)">VALIDADO POR</h3>'.
						'<table border="1" cellpadding="2" align="center" style="font-family: Helvetica;font-size: 8pt;">'.
							'<tr nobr="true">'.
								'<th style="background-color:#dedede; font-weight: bold; text-align: left;">DIRECCION MEDICA</th>'.
      					'<td>Silvio Torres</td>'.
      				'</tr>'.
      				'<tr>'.
      					'<th style="background-color:#dedede; font-weight: bold; text-align: left;">COORDINACION MEDICA</th>'.
      					'<td>Pablo Reyes</td>'.
      				'</tr>'.
      				'<tr>'.
								'<th style="background-color:#dedede; font-weight: bold; text-align: left;">COORDINACION ENFERMERIA</th>'.
      					'<td>'.$lv_cmpenf.'</td>'.
      				'</tr>'.
      				'<tr>'.
      					'<th style="background-color:#dedede; font-weight: bold; text-align: left;">COORDINACION REHABILITACION</th>'.
      					'<td>'.$lv_cmpreh.'</td>'.
							'</tr>'.
      '</table>';

		$lv_buffer .= '<h3 style= text align="center"; color="rgb(34, 68, 136)">FECHA DE CIERRE DEL PLAN</h3>'.
									'<table border="1" cellpadding="2" align="center" style="font-family: Helvetica;font-size: 8pt;">'.
										'<tr nobr="true">'.
											'<th style="background-color:#dedede; font-weight: bold">N° DE PLAN</th>'.
											'<th style="background-color:#dedede; font-weight: bold">FECHA DE CIERRE</th>'.
											'<th style="background-color:#dedede; font-weight: bold">CAMBIOS</th>'.
										'</tr>'.
										'<tr>'.
											'<td>'.$vew_data->patcreplncod.'</td>'.
											'<td>'.date_format($vew_data->patcreplnstrdte,'d/m/Y').'</td>'.
											'<td>'.$lv_chgpln.'</td>'.
										'</tr></table>';

	$pdf->setxy( 25, 30 );
	$pdf->writeHTML($lv_buffer);
	$pdf->Output('pdf'.date('Y-m-d').'.pdf', 'I');
?>
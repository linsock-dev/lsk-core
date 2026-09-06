<?php
require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

// Crear nuevo PDF en orientación horizontal (L para landscape)
$pdf = new TCPDF('L', PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);


// Clonamos la fecha original para evitar modificar el objeto original
$lqddte = clone $vew_data->cnsprslqdstrdte;
// Formateamos el resultado en "mes/año"
$lv_dthlqd = $lqddte->format('m-Y');
// Información del documento
$pdf->SetCreator(PDF_CREATOR);
$pdf->SetAuthor('TEMASIS');
$pdf->SetTitle("Liquidación {$vew_data->cnsprslqdcod} {$vew_data->srcobjtxt} {$lv_dthlqd}");
$pdf->SetSubject('PDF de Liquidación');
$pdf->SetKeywords('TCPDF, PDF, liquidación');

// Configuración de página
$pdf->setPrintHeader(false); // Sin encabezado
$pdf->setPrintFooter(false); // Sin pie de página
$pdf->SetMargins(15, 15, 15); // Márgenes
$pdf->SetAutoPageBreak(TRUE, 15);

// Agregar página (orientación landscape ya está configurada)
$pdf->AddPage();

// Mapeo de los meses en español
$lv_mth_arr = [
    1 => 'Enero', 2 => 'Febrero', 3 => 'Marzo', 4 => 'Abril', 5 => 'Mayo', 6 => 'Junio',
    7 => 'Julio', 8 => 'Agosto', 9 => 'Septiembre', 10 => 'Octubre', 11 => 'Noviembre', 12 => 'Diciembre'
];
// Obtener el mes numérico y el año
$lv_mth = (int)$vew_data->cnsprslqdstrdte->format('m'); // El mes en formato numérico
// Obtener el nombre del mes en español
$lv_mthtxt = $lv_mth_arr[$lv_mth];

// Configuración de fuente general
$pdf->SetFont('helvetica', 'B', 12);

// Texto "MONTADOR" y "PERIODO"
$pdf->SetXY($pdf->GetX()+20, $pdf->GetY());
$pdf->Cell(30, 10, 'MONTADOR:', 0, 0);
$pdf->Cell(60, 10, $vew_data->srcobjtxt, 0, 1);
$pdf->SetXY($pdf->GetX()+20, $pdf->GetY());
$pdf->Cell(30, 10, 'PERIODO:', 0, 0);
$pdf->Cell(60, 10, $lv_mthtxt. ' ' . $vew_data->cnsprslqdstrdte->format('Y'), 0, 1);

$pdf->SetFont('helvetica', '', 9);

// Contenido del PDF
// Concatenar todo el HTML en una sola asignación con tamaños de celdas
$lv_buffertbl = '<table border="1" cellspacing="0" cellpadding="1" width="100%">
					<thead>
          	<tr style="background-color:black; color:white" >
            	<th align="center" width="32"><strong>ID</strong></th>
              <th align="center" width="114"><strong>DIRECCIÓN</strong></th>
              <th align="center" width="74"><strong>CÓDIGO</strong></th>
              <th align="center" width="284"><strong>DESCRIPCIÓN</strong></th>
              <th align="center" width="38"><strong>Un</strong></th>
              <th align="center" width="55"><strong>CANT.</strong></th>
              <th align="center" width="70"><strong>RECARGO</strong></th>
              <th align="center" width="84"><strong>MONTO</strong></th>
          	</tr>
            </thead>
            <tbody>';

$lo_srv =is_array($vew_data->srv)?$vew_data->srv:array();	
$lv_buffer='';
$lv_cnt=0;
$lv_cnttotrow=count($lo_srv);
$lv_cnttot=0;
foreach ($lo_srv as $lv_row) {
  $lv_dat=json_decode($lv_row['cnsprslqddocatr001']);
  $lv_buffer .= '<tr style="height: 30px;">
                <td align="center" width="32">' . $lv_row['stecod'] . '</td>
                <td align="center" width="114" style="height: 30px;">' .utf8_encode($lv_row['stetxt']). '</td>
                <td align="center" width="74"> ' . $lv_row['tskcodext'] . '</td>
                <td align="left" width="284">' .htmlentities(mb_convert_encoding(($lv_row['tsktxt']??''),'UTF-8','iso-8859-1')). '</td>
                <td align="center" width="38">' . $lv_row['matuntcod'] . '</td>
                <td align="center" width="55">' . number_format($lv_row['cnsprslqddocqty'], 0) . '</td>
                <td align="center" width="70">' . number_format($lv_row['tskrec'], 2) . '</td>
                <td align="center" width="84">' .number_format($lv_row['cnsprslqddoctot'], 2) . '</td>
              </tr>';
      $lv_cnt++;
      $lv_cnttot++;
  // Verificar si el contador ha llegado a 12
    if ($lv_cnt == 12 || $lv_cnttot==$lv_cnttotrow) {
        $lv_buffer =$lv_buffertbl.$lv_buffer.'</tbody></table>'; // Cerrar la tabla actual
      	
        // Escribir el HTML en el PDF
      	$pdf->SetFont('helvetica', '', 9);	
				$pdf->writeHTML($lv_buffer, true, false, true, false, '');
				$lv_buffer='';
      
        // Celdas para el monto total
        $pdf->SetFont('helvetica', 'B', 9);
        $pdf->SetXY($pdf->GetX()+210.5, $pdf->GetY()-4.5);
        $pdf->Cell(25, 7, 'Monto total:', 1, 0, 'C'); // Celda para el texto "Monto total"
        $pdf->Cell(29.5, 7, '$'.number_format(floatval($vew_data->cnsprslqdtot),2,',','.'), 1, 1, 'C');  // Celda para el valor del monto

      	$lv_cnt=0; 
      	if($lv_cnttot!=$lv_cnttotrow){
          // Agregar una nueva página
          $pdf->AddPage();
          // Configuración de fuente general
          $pdf->SetFont('helvetica', 'B', 12);

          // Texto "MONTADOR" y "PERIODO"
          $pdf->SetXY($pdf->GetX()+20, $pdf->GetY());
          $pdf->Cell(30, 10, 'MONTADOR:', 0, 0);
          $pdf->Cell(60, 10, $vew_data->srcobjtxt, 0, 1);
          $pdf->SetXY($pdf->GetX()+20, $pdf->GetY());
          $pdf->Cell(30, 10, 'PERIODO:', 0, 0);
          $pdf->Cell(60, 10, $lv_mthtxt. ' ' . $vew_data->cnsprslqdstrdte->format('Y'), 0, 1);

          $pdf->SetFont('helvetica', '', 9);
        }
    }
}

// Cerrar y mostrar el PDF
$pdf->Output("Liquidación {$vew_data->cnsprslqdcod} {$vew_data->srcobjtxt} {$lv_dthlqd} .pdf", 'I');

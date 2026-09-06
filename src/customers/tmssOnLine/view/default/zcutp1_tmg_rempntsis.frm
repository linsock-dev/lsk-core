<?php
  require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

  // PATCH: trabajar en UTF-8 para evitar conversiones raras
  $pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);

  $pdf->setPrintHeader(false); 
  $pdf->setPrintFooter(false);
  $pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
  $pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
  $pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);
  $pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);

  // PATCH: helpers para sanitizar valores
  $S = function($v) { return is_scalar($v) ? (string)$v : ''; };
  $D = function($v, $fmt) { return ($v instanceof DateTimeInterface) ? $v->format($fmt) : ''; };
  $N = function($v, $dec=0) { return is_numeric($v) ? number_format((float)$v, $dec) : number_format(0, $dec); };

  $pdf->AddPage('P');

  $lv_mes = array(
    '01'=>'Enero','02'=>'Febrero','03'=>'Marzo','04'=>'Abril','05'=>'Mayo','06'=>'Junio',
    '07'=>'Julio','08'=>'Agosto','09'=>'Septiembre','10'=>'Octubre','11'=>'Noviembre','12'=>'Diciembre',
  );

  $dstobjtxt = $S($vew_data->dstobjtxt ?? '');
  $srcobjtxt = $S($vew_data->srcobjtxt ?? '');

  $lv_lugar  = ($dstobjtxt!='TERAPIAS ODDS (TEAM INFUSION CHILE)') ? 'SAN ISIDRO, ' : 'SANTIAGO, ';

  // Encabezado
  switch ($dstobjtxt) {
    case 'LSDM':
      $pdf->Image('library/images/logos/zcutp1_lsdm.jpg', 95, 9, 25, '', '', '', 'T', false, 300, '', false, false, 0, false, false, false);
      $lv_buffer2 = 'LSDM SA';
      $lv_buffer4 = 'TI-PR-09.FO-01';
      break;
    case 'LOGINDOOR':
      $pdf->Image('library/images/logos/logindoor.jpg', 95, 9, 22, '', '', '', 'T', false, 300, '', false, false, 0, false, false, false);
      $lv_buffer2 = 'LOGINDOOR SRL';
      $lv_buffer4 = 'TI-PR-09.FO-01';
      break;
    case 'TERAPIAS ODDS (TEAM INFUSION CHILE)':
      $pdf->Image('library/images/logos/todds_small_1.jpg', 92, 10, 33, 17, '', '', 'T', false, 300, '', false, false, 0, false, false, false);
      $lv_buffer2 = 'TERAPIAS ODDS';
      $lv_buffer4 = 'TI-PR-09.FO-01';
      break;
    default:
			$pdf->Image('library/images/logos/teampediatrico.jpg', 95, 9, 22, '', '', '', 'T', false, 300, '', false, false, 0, false, false, false);
      $lv_buffer2 = 'TEAM PEDIATRICO SRL';
      $lv_buffer4 = 'TI-PR-09.FO-01';
  }
  // Normalizo por si acaso:
  $lv_buffer2 = $S($lv_buffer2 ?? '');
  $lv_buffer4 = $S($lv_buffer4 ?? '');

  // --------- Detalle de materiales (seguro) ----------
  $lv_buffer = '<table border="0" cellpadding="0" cellspacing="0">';
  foreach ((array)($vew_data->stkmovdocmat ?? []) as $lv_row) {
    $lv_row = (array)$lv_row;
    $rej = $lv_row['sysdocrejcod'] ?? null;
    if ($rej === '0' || $rej === 0 || $rej === null) {
      $lv_buffer .= '<tr>'.
        '<td align="right" width="95">'.$N($lv_row['matqty'] ?? 0, 0).'</td>'.
        '<td width="40"></td>'.
        // PATCH: no usar utf8_encode; ya trabajamos en UTF-8
        '<td width="400">'.$S($lv_row['mattxt'] ?? '').'</td>'.
        '</tr>';

      if (!empty($lv_row['matbchcodext'] ?? '')) {
        $vto = $D($lv_row['matbchduedte'] ?? null, 'd/m/Y');
        $lv_buffer .= '<tr style="font-size:10px;"><td colspan="2"></td><td>Lote: '
                    .$S($lv_row['matbchcodext']).' - Vto: '.$vto.'</td></tr>';
      }
      if (!empty($lv_row['matsercodext'] ?? '')) {
        $lv_buffer .= '<tr style="font-size:10px;"><td colspan="2"></td><td>Serie: '
                    .$S($lv_row['matsercodext']).'</td></tr>';
      }
    }
  }
  $lv_buffer .= '</table>';

  // Comentarios
  $lv_buffer5 = '';
  if (!($vew_data->stkmovdoccmt === null || $vew_data->stkmovdoccmt === '')) {
    $lv_buffer5 = '<br>Comentarios: ' . $S($vew_data->stkmovdoccmt) . '<br>';
  }

  $lv_buffer3 = ($dstobjtxt!='TERAPIAS ODDS (TEAM INFUSION CHILE)')
    ? ' Fijando como jurisdicción la de tribunales ordinarios de la Ciudad de San Isidro con exclusión de cualquier otra que pudiere corresponderle.'
    : '';

  // --------- Comunes para fecha/numero/clase ----------
  $fec_d = $D($vew_data->stkmovdocdte ?? null, 'd');
  $fec_m = $D($vew_data->stkmovdocdte ?? null, 'm');
  $fec_Y = $D($vew_data->stkmovdocdte ?? null, 'Y');
  $mes_txt = $lv_mes[$fec_m] ?? '';
  $lv_fecha_larga = $S($lv_lugar).$fec_d.' de '.$mes_txt.' de '.$fec_Y;

  $doccod = $S($vew_data->stkmovdoccod ?? '');
  $cls    = $S($vew_data->sysdocclstxt ?? '');
  $dstcnt = $S($vew_data->dstcnttxt ?? '');
	$view = ($dstobjtxt === 'TERAPIAS ODDS (TEAM INFUSION CHILE)') ? 'CONSUMO CHILE' : $cls;


  // --------- Switch principal ----------
  switch ($view) {
    case "CONSUMO CHILE":
      $pdf->SetFont('helvetica', 'B', 12);
      $pdf->Text(50, 40, 'REGISTRO DE COMODATOS DE EQUIPOS AL PERSONAL');
      $pdf->Text(175, 12, 'N°'.$doccod);

      $pdf->SetFont('helvetica', '', 11);
      // PATCH: $stretch=0 (no ''), $ishtml=false aquí
      $pdf->MultiCell(85, 5, $lv_fecha_larga, 0, 'R', 0, 0, 105, 50, true, 0, false, true, 10, 'T');

      $pdf->SetFont('helvetica', '', 10);
      // PATCH: $stretch=0, $ishtml=true
      $pdf->MultiCell(
          165, 200,
          '<p style="line-height:184%">
          Las partes Empleador y Trabajador, acuerdan que, para efectos del ejercicio de las funciones que realiza el Trabajador de acuerdo a su contrato de trabajo, la Empresa le entrega, mientras que se encuentre prestando servicios, como herramienta necesaria para desarrollar su trabajo:
          <br/><br/>' . $lv_buffer . '<br/>' .
          $lv_buffer5 .
          'Se deja constancia que los equipos mencionados son de propiedad exclusiva de la Empresa.
          <br/><br/>Por tanto, por medio de la presente, la Empresa <b>TERAPIAS ODDS</b>, en adelante también el “Empleador”, hace entrega al Trabajador <b>'. $dstcnt .'</b>, cédula de identidad número _________________________, los equipos anteriormente mencionados.
          <br/>El trabajador recibe conforme el/los equipo/s asignado/s, y toma conocimiento en este acto de las condiciones para su uso, y toma conocimiento que el Equipo debe ser utilizado únicamente para fines laborales.
          <br/><br/><b>El Trabajador se compromete a:</b>
          <br/><br/>1- Emplear el máximo cuidado en la conservación y mantención de los equipos, destinándolos en forma exclusiva al cumplimiento de las funciones que el contrato de trabajo suscrito entre las partes le impone.
          <br/><br/>2- Velar por la custodia de los equipos en todo momento, evitando pérdidas o mermas en estos.
          <br/><br/>3- Evitar hacer uso indebido del equipo, limitándolo al exclusivo uso para el ejercicio de sus funciones.
          <br/><br/>4- Asimismo, evitar situaciones de riesgo que puedan dañar o afectar el funcionamiento a los equipos, tales como beber líquidos o ingerir alimentos cerca de ellos, utilizarlos para tareas que no tengan relación con la labor encomendada por la Empresa, entre otros.
          <br/><br/>En caso de daños en el Equipo o sus accesorios, o en caso de extravío o pérdida del Equipo, que no correspondan al desgaste por uso, o algún caso fortuito o fuerza mayor, el trabajador autoriza al Empleador a descontar de su remuneración, el valor de reparación o el valor de reposición según sea el caso.
          <br/><br/>Se deja constancia que el Equipo asignado, con sus respectivos accesorios, son de propiedad de la Empresa, y que deberán ser devueltos por el Trabajador al término de su contrato de trabajo, o en cualquier momento ante el solo requerimiento de la Empresa, y por ello es intransferible, quedando expresamente prohibido, tanto la cesión a cualquier título o el préstamo del equipo.
          <br/><br/>Los datos almacenados en los equipos entregados que sean propiedad o contengan información de <b>TERAPIAS ODDS</b> no pueden ser divulgados, vendidos ni puestos a disposición de terceros.
          <br/><br/>Por último, se deja constancia que la entrega de este beneficio es en virtud de la prestación de los servicios del trabajador, esto es, es necesario para desarrollar las funciones para las cuales fue contratado, siendo entonces una herramienta de trabajo y en consecuencia no es considerado remuneración o beneficio y no está afecta a cotizaciones previsionales, al no ser una regalía sino sólo un útil de trabajo.
          <br/><br/><b>En prueba de conformidad:</b>
          <br/><br/>
          <table cellspacing="0" cellpadding="5" border="1">
            <tr>
              <td>Firma:<br/><br/><br/></td>
              <td>Firma:<br/><br/><br/></td>
            </tr>
            <tr>
              <td>Aclaración:<br/></td>
              <td>Aclaración:<br/></td>
            </tr>
            <tr>
              <td>RUT:<br/></td>
              <td>RUT:<br/></td>
            </tr>
          </table>
          <table cellspacing="1" cellpadding="1" border="0">
            <tr>
              <td align="center"><i>Entrega conforme</i></td>
              <td align="center"><i>Recibe conforme</i></td>
            </tr>
          </table>
          </p>',
          0, 'J', 0, 1, 25, 65, true, '', $ishtml = true
        );

      $pdf->SetFont('helvetica', '', 14);
      $pdf->MultiCell(85, 5, '<b><i>Ref.: ' . $lv_buffer4 . '</i></b>', 0, 'R', 0, 0, 105, 265, true, 0, true, true, 10, 'T');
      break;

    case "CONSUMO":
      $pdf->SetFont('helvetica', 'B', 12);
      $pdf->Text(64, 39, 'REGISTRO DE ENTREGA PARA CONSUMO');
      $pdf->Text(175, 12, 'N°'.$doccod);

      $pdf->SetFont('helvetica', '', 11);
      $pdf->MultiCell(85, 5, $lv_fecha_larga, 0, 'R', 0, 0, 105, 50, true, 0, false, true, 10, 'T');

      $pdf->SetFont('helvetica', '', 10);
      $pdf->MultiCell(165, 200, '<p style="line-height:184%">Se entrega del Área de Tecnologias de la Información (TI) en este acto el equipo/insumo según detalle: <br><b>'
        .$lv_buffer
        .'<br>'
        .$lv_buffer5
        .'</b><br>El mismo será utilizado para los fines según fue acordado/autorizado. Se deja constancia de quien remite y recibe.<br> '.
        '<table cellspacing="0" cellpadding="5" border="1">
            <tr>
                <td>Firma:<br/><br/><br/></td>
                <td>Firma:<br/><br/><br/></td>
            </tr>
            <tr>
                <td>Aclaracion:<br></td>
                <td>Aclaracion:<br></td>
            </tr>
            <tr>
                <td>DNI:<br/></td>
                <td>DNI:<br/></td>
            </tr>    
          </table>
          <table cellspacing="1" cellpadding="1" border="0">
            <tr>
                <td align="center"><i>Entrega conforme</i></td>
                <td align="center"><i>Recibe conforme</i></td>
            </tr>
          </table>
      </p> 
      ', 0, 'J', 0, 1, 25 ,65, true,'',$ishtml=true);	 
      break;

    default:
      $pdf->SetFont('helvetica', 'B', 12);
      $pdf->Text(50, 37, 'REGISTRO DE COMODATOS DE EQUIPOS AL PERSONAL');

      $pdf->SetFont('helvetica', '', 11);
      $pdf->MultiCell(85, 5, $lv_fecha_larga, 0, 'R', 0, 0, 105, 50, true, 0, false, true, 10, 'T');

      $pdf->SetFont('helvetica', '', 10);
      $pdf->MultiCell(165, 200, '<p style="line-height:184%">Recibo de <b>' .$lv_buffer2. '</b> en este acto el equipo según detalle: <br><b>'
        // HACER EL FOREACH DE TODOS LOS MATERIALES ACA

        .$lv_buffer
        
        .'</b><br>para uso exclusivo del desempeño de mis actividades laborales asignadas. 
        <br><br><b>Clausula I:</b>
        <br>Los daños ocasionados por mal manejo o imprudencia, serán mi responsabilidad y asumo las consecuencias que esto deriven
        <br><br><b>Cláusula II:</b>
        <br>Este equipo pertenece a ' . $lv_buffer2 . ' y es intransferible, quedando expresamente prohibida la cesión total o parcial de los derechos y obligaciones derivados del mismo.
        <br><br><b>Cláusula III:</b>
        <br>Concluida la necesidad de utilización del equipo, autorizo al inmediato retiro por ' .$lv_buffer2. ' y/o quienes ellos autoricen dejando una constancia de retiro sin excepción como documento que acredite la entrega del equipo. Que deberá ser devuelto en perfecto estado de uso, conservación y funcionamiento, salvo el desgaste propio de su adecuada utilización.
        <br><br><b>Cláusula IV:</b>
        <br>En el caso que el equipamiento fuere perdido, extraviado, destruido, deteriorado, dañado o utilizado con un fin indebido, o no fuere restituido, el solicitante tendrá a su cargo la obligación de abonar el valor del equipo.Asimismo, la obligación de restitución o en su defecto el valor monetario del mismo, cabe a sus herederos y/o quien suscribe el presente en nombre del solicitante.
        <br><br><b>Cláusula V:</b>
        <br>En caso que el solicitante o quien suscribe en su nombre no cumpliesen con las obligaciones a su cargo consignadas en la cláusula III del presente documento, ' .$lv_buffer2. ' quedará habilitado a iniciar acciones legales correspondientes, pudiendo además iniciar las acciones penales derivadas del delito de retención indebida. '. $lv_buffer3 .'
        <br><br><b>Cláusula VI:</b>
        <br>Los datos almacenados en los equipos entregados que sean propiedad o contengan información de ' .$lv_buffer2. '  no pueden ser divulgados, vendidos ni puestos a disposición de terceros. 
        <br><br><b>Cláusula VII:</b>
        <br>Para todos los efectos legales derivados del presente, la/el Sra./Sr. <b>' .$vew_data->dstcnttxt. '</b>
        <br>fija su domicilio en ___________________________________________________________________
        <br/>donde serán válidas todas las notificaciones que se le cursen, salvo que su modificación sea notificada de modo fehaciente. En prueba de conformidad, se firman dos ejemplares del mismo tenor a un solo efecto. 
        <br/><br/>
          <br>
        <table cellspacing="0" cellpadding="5" border="1">
          <tr>
              <td>Firma:<br/><br/><br/></td>
              <td>Firma:<br/><br/><br/></td>
          </tr>
          <tr>
              <td>Aclaracion:<br></td>
              <td>Aclaracion:<br></td>
          </tr>
          <tr>
              <td>DNI:<br/></td>
              <td>DNI:<br/></td>
          </tr>    
        </table>
        <table cellspacing="1" cellpadding="1" border="0">
          <tr>
              <td align="center"><i>Entrega conforme</i></td>
              <td align="center"><i>Recibe conforme</i></td>
          </tr>
        </table> 
      </p> 
        
        ', 0, 'J', 0, 1, 25 ,65, true,'',$ishtml=true);

      $pdf->SetFont('helvetica', '', 14);
      $pdf->MultiCell(85, 5, '<b><i>Ref.: ' . $lv_buffer4 . '</i></b>', 0, 'R', 0, 0, 105, 265, true, 0, true, true, 10, 'T');
  }

  // Barcode (valores saneados)
  $style = array('border'=>false,'padding'=>0,'fgcolor'=>array(0,0,0),'bgcolor'=>false,'module_width'=>1,'module_height'=>1);
  $pdf->write2DBarcode('Movimiento '.$cls.' # '.$doccod, 'QRCODE,L', 168, 240, 20, 20, $style, 'N');

  // -------- Salida segura --------
  // PATCH: evitar que warnings arruinen el PDF (sólo para esta salida)
  $old_display = ini_get('display_errors');
  ini_set('display_errors', '0');
  while (ob_get_level() > 0) { ob_end_clean(); }

  $pdf->Output('remito.pdf', 'I');

  ini_set('display_errors', $old_display);
?>

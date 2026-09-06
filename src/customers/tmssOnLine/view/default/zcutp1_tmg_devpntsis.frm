<?php
	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');
	
	setlocale(LC_TIME, 'es_ES', 'esp_esp'); 
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
	$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);  

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
	
	// ---------------------------------------------------------
	$pdf->AddPage('P');
	$lv_mes=array('01'=>'Enero',
               	'02'=>'Febrero',
                '03'=>'Marzo',
                '04'=>'Abril',
                '05'=>'Mayo',
                '06'=>'Junio',
                '07'=>'Julio',
                '08'=>'Agosto',
                '09'=>'Septiembre',
                '10'=>'Octubre',
                '11'=>'Noviembre',
                '12'=>'Diciemmre',
               	);
$lv_lugar=  $vew_data->srcobjtxt!='TERAPIAS ODDS (TEAM INFUSION CHILE)'?'SAN ISIDRO, ':'SANTIAGO, ';
	
	// Encabezado
	
	switch ($vew_data->srcobjtxt) {
		case 'LSDM':
			$pdf->Image('library/images/logos/zcutp1_lsdm.jpg', 95, 9, 25, '', '', '', 'T', false, 300, '', false, false, 0, false, false, false);
			$lv_buffer2 = 'LSDM SA';
      $lv_buffer4 = 'TI - RE - 02';
			break;
		case 'LOGINDOOR':
			$pdf->Image('library/images/logos/logindoor.jpg', 95, 9, 22, '', '', '', 'T', false, 300, '', false, false, 0, false, false, false);
			$lv_buffer2 = 'LOGINDOOR SRL';
      $lv_buffer4 = 'TI - RE - 01';      
			break;			
		case 'TERAPIAS ODDS (TEAM INFUSION CHILE)':
      $pdf->Image('library/images/logos/todds_small_1.jpg', 92, 10, 33, 17, '', '', 'T', false, 300, '', false, false, 0, false, false, false);
			$lv_buffer2 = 'TERAPIAS ODDS';
			break;
		default;
		$pdf->Image('library/images/logos/teampediatrico.jpg', 95, 9, 22, '', '', '', 'T', false, 300, '', false, false, 0, false, false, false);
		$lv_buffer2 = 'TEAM PEDIATRICO SRL';
    $lv_buffer4 = 'TI - RE - 01';      
	}
	$lv_buffer = '';
	//$lv_buffer = '<b> catidad: '.count($vew_data->stkmovdocmat).'</b>';
	$lv_buffer .= '<table border=0 cellpadding=0 cellspacing=0>';
	foreach($vew_data->stkmovdocmat as $lv_row) {
    
		if($lv_row['sysdocrejcod']=='0' || $lv_row['sysdocrejcod']==null) {
			$lv_buffer .= '<tr>'.
										'<td align="right" width="95"><b>'.number_format($lv_row['matqty'],0).'</b></td>'.
										'<td width="40"></td>'.
										'<td width="400"><b>'.utf8_encode($lv_row['mattxt']).'</b> ';
                    if ( $lv_row['matbchcodext']!='' ) {
                      $lv_buffer .= '<i>- Lote: '.$lv_row['matbchcodext'].' - Vto: '.date_format($lv_row['matbchduedte'],'d/m/Y').'</i>';
                    }
                    if ( $lv_row['matsercodext']!='' ) {
                      $lv_buffer .= '<i>- Serie: #'.$lv_row['matsercodext'].'</i>';
                    }
      $lv_buffer .= '</td></tr>';
		}
    
	}
	$lv_buffer .= '</table>';
  

  
	//INICIO DEL MENSAJE
	
	$pdf->setfont('helvetica', 'B', 12);
	$pdf->text( 62, 37, 'REGISTRO DE DEVOLUCIÓN DE EQUIPOS');		// TITULO
  $pdf->setfont('helvetica', '', 11);
	$pdf->MultiCell(85, 5, $lv_lugar .date_format($vew_data->stkmovdocdte,  'd').' de '.$lv_mes[date_format($vew_data->stkmovdocdte,  'm')].' de '.date_format($vew_data->stkmovdocdte,  'Y') , 0, 'R', 0, 0,105, 50, true, 0, false, true, 10, 'T');

	$pdf->setfont('helvetica', '', 10);
  $pdf->MultiCell(165, 200, ''
	.'<p style="line-height:184%">A través de la presente se hace la devolución formal de los equipos cuyo propietario es <b>' .$lv_buffer2. '</b> con asignación temporal a <b>' .(isset($vew_data->srccnttxt)?$vew_data->srccnttxt:'___________________________________'). '</b> para uso exclusivo del desempeño de sus actividades laborales asignadas.<br>Según detalle:<br>'
  .$lv_buffer
	.'<br>El equipo en cuestión fue devuelto a ___________________________________________________, quien firma una copia en conformidad y a continuación detallan las condiciones de recepción del mismo: <b>' .(isset($vew_data->stkmovdoccmt)?$vew_data->stkmovdoccmt:'________________________________'). '</b>'
  .'<br>__________________________________________________________________________________'
  .'<br>Se deja constancia de que todos los archivos de propiedad de <b>' .$lv_buffer2. '</b>  serán resguardados y el resto de la información será borrada sin posibilidad alguna de reclamo, a excepcion de la informacion sujeta a litigios legales.'
	.'</p>'
	//.'<br>'
	.'<table cellspacing="0" cellpadding="5" border="1">
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
	', 0, 'J', 0, 1, 25 ,65, true,'',$ishtml=true);


	 $pdf->setfont('helvetica', '', 14);
	 $pdf->MultiCell(85, 5, '<b><i>Ref.: ' .$lv_buffer4. '</i></b>', 0, 'R', 0, 0,105, 265, true, 0, $ishtml=true, true, 10, 'T');
	// set style for barcode



	$style = array(
		'border' => false,
		'padding' => 0,
		'fgcolor' => array(0,0,0),
		'bgcolor' => false, //array(255,255,255)
		'module_width' => 1, // width of a single module in points
		'module_height' => 1 // height of a single module in points
	);
	$pdf->write2DBarcode('Movimiento '. $vew_data->sysdocclstxt .' # '.$vew_data->stkmovdoccod, 'QRCODE,L', 168, 240, 20, 20, $style, 'N');
	
	
	// ---------------------------------------------------------

	$pdf->Output('Devolucion_comodato.pdf', 'I');	
?>  
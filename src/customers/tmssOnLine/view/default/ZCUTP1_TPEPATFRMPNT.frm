<?php
  require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');
  class MYPDF extends TCPDF {
    protected $totalPages; // Variable para almacenar el número total de páginas
    public function __construct() {
      parent::__construct();
      // Habilitar salto de página automático
      $this->SetAutoPageBreak(true, 15); // El segundo parámetro establece la distancia entre el final del contenido y el borde inferior de la página
    }
    public function Header() {
      $this->Ln(10);
      $this->Image('https://customers.gorse.ar/library/images/logos/teampediatrico.jpg', 21, 2, 40, 20, '', '', '', false, 30, '', false, false, 0);
      //$this->Image($logo, 190, 12, 15 );

      $this->SetFont('helvetica','B',5); //Tipo de fuente y tamaño de letra
      $this->SetXY(160, 8);
      $this->SetTextColor(34,68,136);
      $this->Write(0, 'Codigo: OP-PR-01.FO-05');
      /*
      $this->SetFont('helvetica','B',5); //Tipo de fuente y tamaño de letra
      $this->SetXY(145, 7);
      $this->SetTextColor(34,68,136);
      $this->Write(0, 'Fecha de vigencia: 13/06/2025');
      */

      $this->SetFont('helvetica','B',5); //Tipo de fuente y tamaño de letra
      $this->SetXY(160, 10);
      $this->SetTextColor(34,68,136);
      $this->Write(0, 'Elaboracion: Silvio Torres');
			/*
      $this->SetFont('helvetica','B',5); //Tipo de fuente y tamaño de letra
      $this->SetXY(174.2, 11);
      $this->SetTextColor(34,68,136);
      $this->Write(0, 'Revision: 1.0');
			*/
      $this->SetFont('helvetica','B',18); //Tipo de fuente y tamaño de letra
      $this->SetXY(90, 5);
      $this->SetTextColor(34,68,136);
      $this->Write(0, 'Formulario');
      
      $this->SetFont('helvetica','I',10); //Tipo de fuente y tamaño de letra
      $this->SetXY(60, 13);
      $this->SetTextColor(34,68,136);
      $this->Write(0, 'Informe de Admisión al Servicio de Internación Domiciliaria');
      /*
      $this->Ln(-5);
      $this->SetFont('helvetica','B',18); //('helvetica','B',8)
      $this->Cell(30);
      $this->Cell(84,17, 'Formulario',0,0,'C');
      
      $this->Ln(7); //Salto de Linea
      $this->SetFont('helvetica','I',10);
      $this->Cell(10);
      $this->Cell(123,15, 'Informe de Admisión al Servicio de Internación Domiciliaria',0,0,'C');
			*/
      $this->SetY(37);
      $this->SetFont('helvetica', '', 8);
      //Mostrar cantidad de paginas
      //$this->Cell(0, 10, 'Page '.$this->getAliasNumPage().'/'.$this->getAliasNbPages(), 0, false, 'C', 0, '', 0, false, 'T', 'M');
    }
    public function Footer() {
      // Comprueba si es la última página
      //if ($this->getPage() == $this->totalPages) {
        // Posición del footer
        $this->SetY(-20);
        $this->SetFont('helvetica', '', 8);
        $this->html =  '<table border="1" cellpadding="2" align="center" style="font-family: Helvetica; font-weight: bold; font-size: 8pt;">
                        <tr nobr="true">
                        <th style=text align="left">Revisado por:</th>
                        <td style=text align="left">Aprobado por:</td>
                        </tr>
                        <tr>
                        <th style=text align="center">Denis Valiñas</th>
                        <td style=text align="center">Santiago Murga</td>
                        </tr>
                        <tr>
                        <th style=text align="right">Administrador del SGC</th>
                        <td style=text align="right">Gerentre General</td>
                        </tr>
                        </table>
                        
                        ';

        $this->writeHTML($this->html, true, false, true, false, '');
      //}
    }
    public function Close() {
      // Obtener el número total de páginas antes de cerrar el PDF
      $this->totalPages = $this->getNumPages();
      parent::Close();
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
  $order   = array("\r\n", "\n", "\r");
  $replace = '<br />';
	$frmDat=$vew_data->frmdat;
	$frmDat['TPEPATINF01']=utf8_encode($frmDat['TPEPATINF01']??'');
  $frmDat['TPEPATINF01'] = str_replace($order, $replace, $frmDat['TPEPATINF01']);
	$frmDat['TPEPATINF02']=utf8_encode($frmDat['TPEPATINF02']??'');
  $frmDat['TPEPATINF02'] = str_replace($order, $replace, $frmDat['TPEPATINF02']);
	$frmDat['TPEPATINF03']=utf8_encode($frmDat['TPEPATINF03']??'');
  $frmDat['TPEPATINF03'] = str_replace($order, $replace, $frmDat['TPEPATINF03']);
	$frmDat['TPEPATINF04']=utf8_encode($frmDat['TPEPATINF04']??'');
  $frmDat['TPEPATINF04'] = str_replace($order, $replace, $frmDat['TPEPATINF04']);
	$frmDat['TPEPATINF05']=utf8_encode($frmDat['TPEPATINF05']??'');
  $frmDat['TPEPATINF05'] = str_replace($order, $replace, $frmDat['TPEPATINF05']);
	$frmDat['TPEPATINF06']=utf8_encode($frmDat['TPEPATINF06']??'');
  $frmDat['TPEPATINF06'] = str_replace($order, $replace, $frmDat['TPEPATINF06']);
	$frmDat['TPEPATINF07']=utf8_encode($frmDat['TPEPATINF07']??'');
  $frmDat['TPEPATINF07'] = str_replace($order, $replace, $frmDat['TPEPATINF07']);
	$frmDat['TPEPATINF08']=utf8_encode($frmDat['TPEPATINF08']??'');
  $frmDat['TPEPATINF08'] = str_replace($order, $replace, $frmDat['TPEPATINF08']);
	$frmDat['TPEPATINF09']=utf8_encode($frmDat['TPEPATINF09']??'');
  $frmDat['TPEPATINF09'] = str_replace($order, $replace, $frmDat['TPEPATINF09']);
	$frmDat['TPEPATINF10']=utf8_encode($frmDat['TPEPATINF10']??'');
  $frmDat['TPEPATINF10'] = str_replace($order, $replace, $frmDat['TPEPATINF10']);
	$frmDat['TPEPATINF11']=utf8_encode($frmDat['TPEPATINF11']??'');
  $frmDat['TPEPATINF11'] = str_replace($order, $replace, $frmDat['TPEPATINF11']);
	$frmDat['TPEPATINF12']=utf8_encode($frmDat['TPEPATINF12']??'');
  $frmDat['TPEPATINF12'] = str_replace($order, $replace, $frmDat['TPEPATINF12']);
	$frmDat['TPEPATINF13']=utf8_encode($frmDat['TPEPATINF13']??'');
	$frmDat['TPEPATINF13'] = str_replace($order, $replace, $frmDat['TPEPATINF13']);
	$frmDat['TPEPATINF14']=utf8_encode($frmDat['TPEPATINF14']??'');
  $frmDat['TPEPATINF14'] = str_replace($order, $replace, $frmDat['TPEPATINF14']);
	$frmDat['TPEPATINF15']=utf8_encode($frmDat['TPEPATINF15']??'');
  $frmDat['TPEPATINF15'] = str_replace($order, $replace, $frmDat['TPEPATINF15']);
	$frmDat['TPEPATINF16']=utf8_encode($frmDat['TPEPATINF16']??'');
  $frmDat['TPEPATINF16'] = str_replace($order, $replace, $frmDat['TPEPATINF16']);
	$frmDat['TPEPATINF17']=utf8_encode($frmDat['TPEPATINF17']??'');
  $frmDat['TPEPATINF17'] = str_replace($order, $replace, $frmDat['TPEPATINF17']);
	$frmDat['TPEPATINF18']=utf8_encode($frmDat['TPEPATINF18']??'');
  $frmDat['TPEPATINF18'] = str_replace($order, $replace, $frmDat['TPEPATINF18']);
	$frmDat['TPEPATINF19']=utf8_encode($frmDat['TPEPATINF19']??'');
  $frmDat['TPEPATINF19'] = str_replace($order, $replace, $frmDat['TPEPATINF19']);

	$lo_perbrndte=$vew_data->per->perbrndte==null?'':$vew_data->per->perbrndte->format('d/m/Y');
	$lv_buffer='';
  $lv_buffer .= '<h4>INFORME DE ADMISION AL SERVICIO DE INTERNACION DOMICILIARIA</h4>'.
                  '<table style="font-family: Helvetica;font-size: 11px" >'.
                    '<tr style="line-height: 1.5;"><td><strong>Nombre y apellidos de paciente:</strong> '. utf8_encode($vew_data->pattxt). '</td></tr>'. 
                    '<tr style="line-height: 1.5;"><td><strong>Fecha de nacimiento:</strong> '. $lo_perbrndte. '</td></tr>'.
                    '<tr style="line-height: 1.5;"><td><strong>Numero de DNI:</strong> '. $vew_data->tax->taxcod. '</td></tr>'.
                    '<tr style="line-height: 1.5;"><td><strong>Numero de afiliado:</strong> '. $vew_data->per->hhrmedcovaflpln. '</td></tr>'.
                    '<tr style="line-height: 1.5;"><td><strong>Obra social:</strong> '. utf8_encode($vew_data->per->hhrmedcovtxt). '</td></tr>'.
                    '<tr style="line-height: 1.5;"><td><strong>Domicilio:</strong> '. utf8_encode($vew_data->adr->adrstr). '</td></tr>'.
    								'<tr style="line-height: 1.5;"><td><strong>Localidad:</strong> '. utf8_encode($vew_data->adr->adrtwn). '</td></tr>'.
    
    								'<tr style="line-height: 1.5;"><td><strong>Correo electrónico:</strong> '. $frmDat['TPEPATINF01']. '</td></tr>'.
    								'<tr style="line-height: 1.5;"><td><strong>Nombre de la madre:</strong> '. $frmDat['TPEPATINF02']. '</td></tr>'.
    								'<tr style="line-height: 1.5;"><td><strong>Ocupación:</strong>  '. $frmDat['TPEPATINF03']. ' </td></tr>'.
    								'<tr style="line-height: 1.5;"><td><strong>Edad:</strong> '. intval($frmDat['TPEPATINF04']). ' </td></tr>'.
    								'<tr style="line-height: 1.5;"><td><strong>Celular:</strong> '. $frmDat['TPEPATINF05']. '</td></tr>'.
    								'<tr style="line-height: 1.5;"><td><strong>Nombre del padre:</strong> '. $frmDat['TPEPATINF06']. '</td></tr>'.
    								'<tr style="line-height: 1.5;"><td><strong>Ocupación:</strong>  '. $frmDat['TPEPATINF07']. '</td></tr>'.
    								'<tr style="line-height: 1.5;"><td><strong>Edad:</strong> '. intval($frmDat['TPEPATINF08']). ' </td></tr>'.
    								'<tr style="line-height: 1.5;"><td><strong>Celular:</strong> '. $frmDat['TPEPATINF09']. '</td></tr>'.
    								'<tr style="line-height: 1.5;"><td><strong>Nombre del médico de cabecera:</strong> '. $frmDat['TPEPATINF10']. '</td></tr>'.
    								'<tr style="line-height: 1.5;"><td><strong>Fecha de evaluación:</strong> '. $frmDat['TPEPATINF11']. '</td></tr>'.
                  '</table>';
	$pdf->setxy( 12, 30 );
	$pdf->writeHTML($lv_buffer);
	$lv_buffer ='';
	$lv_buffer .= '<h4>¿Tiene algún servicio de ID, equipos o insumos con otra empresa ?</h4>'.
                  '<table style="font-family: Helvetica;font-size: 12px">'.
                    '<tr><td>'. $frmDat['TPEPATINF18']. '</td></tr>'. 
                  '</table>';
	$lv_buffer .= '<h4>¿Cual?</h4>'.
                  '<table style="font-family: Helvetica;font-size: 12px">'.
                    '<tr><td>'. $frmDat['TPEPATINF19']. '</td></tr>'. 
                  '</table>';

  $lv_buffer .= '<h4>Evaluación</h4>'.
                  '<table style="font-family: Helvetica;font-size: 12px">'.
                    '<tr><td>'. $frmDat['TPEPATINF12']. '</td></tr>'. 
                  '</table>';
	//$pdf->setxy( 12, 150 );
	//$pdf->writeHTML($lv_buffer);
	$lv_buffer .= '<h4>Recurso humano</h4>'.
                  '<table style="font-family: Helvetica;font-size: 12px">'.
                    '<tr><td>'. $frmDat['TPEPATINF13']. '</td></tr>'. 
                  '</table>';
	//$pdf->setxy( 12, 200 );
	//$pdf->writeHTML($lv_buffer);
	

	//$pdf->AddPage('P');
	$lv_buffer .= '<h4>Equipos</h4>'.
                  '<table style="font-family: Helvetica;font-size: 12px">'.
                    '<tr><td>'. $frmDat['TPEPATINF14']. '</td></tr>'. 
                  '</table>';
	//$pdf->setxy( 12, 30 );
	//$pdf->writeHTML($lv_buffer);
	$lv_buffer .= '<h4>Sugerencias</h4>'.
                  '<table style="font-family: Helvetica;font-size: 12px">'.
                    '<tr><td>'. $frmDat['TPEPATINF15']. '</td></tr>'. 
                  '</table>';
	//$pdf->setxy( 12, 90 );
	//$pdf->writeHTML($lv_buffer);
	$lv_buffer .= '<h4>Descartables</h4>'.
                  '<table style="font-family: Helvetica;font-size: 12px">'.
                    '<tr><td>'. $frmDat['TPEPATINF16']. '</td></tr>'. 
                  '</table>';
	
	//$pdf->setxy( 12, 150 );
	//$pdf->writeHTML($lv_buffer);
	/*
	$lv_buffer = '<h4>Servicio/s con otra/s empresa/s</h4>'.
                  '<table style="font-family: Helvetica;font-size: 12px">'.
                    '<tr><td>'. $frmDat['TPEPATINF17']. '</td></tr>'. 
                  '</table>';
	$pdf->setxy( 12, 90 );
	$pdf->writeHTML($lv_buffer);
	*/
	$lv_buffer .= '<h4>Nombre y apellido del coordinador</h4>'.
                  '<table style="font-family: Helvetica;font-size: 12px">'.
                    '<tr><td>'. $frmDat['TPEPATINF17']. '</td></tr>'. 
                  '</table>';

	//$pdf->setxy( 12, 210 );
	//$pdf->writeHTML($lv_buffer);
	$pdf->setxy( 12, 150 );
	$pdf->writeHTML($lv_buffer);

//$pdf->AddPage('P');
	$pdf->Output('INF_ADM_'.$vew_data->patcod.'.pdf', 'I');
?>
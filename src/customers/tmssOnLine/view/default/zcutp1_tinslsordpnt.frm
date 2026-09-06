<?php
	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

	// Extend the TCPDF class to create custom Header and Footer
	class MYPDF extends TCPDF {

		var $lo_data;
    public function tmssSetData($lp_data) {
        $this->lo_data = $lp_data;
    }

    //Page header
    public function Header() {
			$style5 = array('width' => 0, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 64, 128));
			$this->RoundedRect(0, 0, 255, 2, 0, '0101', 'DF', $style5, array(152, 67, 174) );
			$this->Image('library/images/logos/zcutp1_lsdm.jpg',8,7,40);
			$this->setfont('helvetica', '', 12);
			$this->setY(10); $this->writeHTML('Presupuesto Nro. <b>'.str_pad($this->lo_data->slsordcod, 8, '0', STR_PAD_LEFT).'</b>', true, false, false, false, 'R');
			$lo_mth=array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
			$this->setY(18); $this->writeHTML(date_format($this->lo_data->slsorddte,'d').' de '.$lo_mth[date_format($this->lo_data->slsorddte,'m')-1].' de '.date_format($this->lo_data->slsorddte,'Y'), true, false, false, false, 'R');
    }

    // Page footer
    public function Footer() {
			$this->setfont('helvetica', 'I', 12);	
			$this->setXY( 15, 285 );
			$this->writeHTML( '<a href="https://www.lsdm.global" target="_blank" style="text-decoration:none;">www.lsdm.global</a>' );
			$this->setXY( 90, 285 );
			$this->writeHTML( '<a href="mailto:info@lsdm.global" target="_blank" style="text-decoration:none;">info@lsdm.global</a>' );
			$this->setfont('helvetica', '', 8);	
			$this->text( 178, 286, 'Página '.$this->getAliasNumPage().' de '.$this->getAliasNbPages() );
			$style5 = array('width' => 0, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 64, 128));
			$this->RoundedRect(0, 295, 255, 297, 0, '0101', 'DF', $style5, array(80, 107, 191) );
    }
	}

	// create new PDF document
	$pdf = new MYPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'ISO-8859-1', false);

	// fija datos de cabecera/pie
	$pdf->tmssSetData( $vew_ord );

	// set default monospaced font
	$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

	// set margins
	$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP+25, PDF_MARGIN_RIGHT);
	$pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
	$pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

	// set auto page breaks
	$pdf->SetAutoPageBreak(true, PDF_MARGIN_BOTTOM);

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
	
	// ---------------------------------------------------------
	$pdf->AddPage('P');

	//$pdf->setfont('helvetica', 'B', 16);	
	//$pdf->setY(40); $pdf->writeHTML($vew_ord->dstobjtxt);
	//$pdf->setfont('helvetica', 'B', 12);	
	//$pdf->setY(55); $pdf->writeHTML($vew_ord->slsordtxt);
	//$pdf->setfont('helvetica', 'B', 14);	
	
	//$pdf->setY(60);  $pdf->writeHTML('<p style="color: #333399;">Propuesta económica</p>');
	$pdf->setfont('helvetica', '', 12);		
	$pdf->setY(50);
	$pdf->writeHTML('<table cellspacing="0" cellpadding="1" border="1"  align="center"><tr><td colspan="1" width="33%"><b>'.utf8_encode($vew_ord->slsordtxt).'</b></td><td colspan="2" width="33%">Propuesta de servicio<br><b>'.utf8_encode($vew_ord->dstobjtxt).'</b></td><td colspan="3" width="33%">Fecha de elaboracion<br>'. date_format($vew_ord->slsorddte,"d/m/Y") .'<br></td></tr></table>');	
	
	
	// Posiciones
	$pdf->setfont('helvetica', '', 8);
	$lv_buffer = '';	
	//$lv_buffer = '<table border=0 cellpadding="5" cellspacing="2" style="font-size:10px;">';
	//$lv_buffer .= '<thead><tr style="background-color:#C6C6C6;">'.
	//							'<td align="center" width="50">Código</td>'.
	//							'<td align="center" width="360">Producto / Servicio</td>'.
	//							'<td align="center" width="50">Ctdad.</td>'.
	//							'<td align="center" width="80">Precio Unit.</td>'.
	//							'<td align="center" width="80">Subtotal</td>'.
	//							'</tr></thead>';
	//$lv_tot = 0;
	//foreach($vew_ord->slsordmat as $lv_row) {
  //  
  //  foreach($vew_ord->slsordprc as $lv_prcrow){
  //    // busco que coincida la condición de precio con la que está indicada en la clase de documento
  //    if($lv_prcrow['prcschcndrow'] == $vew_prcschcndrow){
  //      // busco que esa condición de precio sea para el material epecificado
  //      if($lv_prcrow['srcobjcod002'] == $lv_row['slsordmatcod']){
  //        $lv_prcbuffer = '<td align="right" width="80">'.number_format($lv_prcrow['prccndtot']??0,2).'</td>';
  //      }
  //    }
  //  }
  //  $lv_buffer .= '<tr>'.
  //                '<td align="left"  width="50">'.$lv_row['matcod'].'</td>'.
  //                '<td align="left"  width="360">'.utf8_encode($lv_row['mattxt']??'').'</td>'.
  //                '<td align="right" width="50">'.number_format($lv_row['matqty']??0,0).'</td>'.
  //                '<td align="right" width="80">'.number_format($lv_row['matprc']??0,2).'</td>'.
  //    						(isset($lv_prcbuffer) ? $lv_prcbuffer : '<td align="right" width="80">'.number_format($lv_row['matprc']??0 * $lv_row['matqty']??0,2).'</td>').
	//								'</tr>';
	//}
	//$lv_buffer .= '</tbody></table>';
	
	$pdf->setfont('helvetica', '', 11);
	$lv_0=''; foreach($vew_txt as $lv_row){if(utf8_encode($lv_row['txttypcodext']=='QTA_0')){$lv_0.=html_entity_decode(htmlspecialchars_decode(utf8_encode($lv_row['txttxt'])));break;}}
	$lv_1=''; foreach($vew_txt as $lv_row){if(utf8_encode($lv_row['txttypcodext']=='QTA_1')){$lv_1.=html_entity_decode(htmlspecialchars_decode(utf8_encode($lv_row['txttxt'])));break;}}
	$lv_2=''; foreach($vew_txt as $lv_row){if(utf8_encode($lv_row['txttypcodext']=='QTA_2')){$lv_2.=html_entity_decode(htmlspecialchars_decode(utf8_encode($lv_row['txttxt'])));break;}}
	$lv_3=''; foreach($vew_txt as $lv_row){if(utf8_encode($lv_row['txttypcodext']=='QTA_3')){$lv_3.=html_entity_decode(htmlspecialchars_decode(utf8_encode($lv_row['txttxt'])));break;}}
	$lv_4=''; foreach($vew_txt as $lv_row){if(utf8_encode($lv_row['txttypcodext']=='QTA_4')){$lv_4.=html_entity_decode(htmlspecialchars_decode(utf8_encode($lv_row['txttxt'])));break;}}		
	$lv_buffer = '<p style="color: #3333AA;"><b></b></p>'
							.'<p style="text-align: justify;">'
							.$lv_0
							.'<br>'
							.$lv_1
							.'<br>'
							.$lv_2
							.'<br>'						
							.$lv_3
							.'<br>'
							.$lv_buffer
    					.'<br>'
							.$lv_4
							.'</p><br>'  
							.($vew_ord->slsordenddte != '' ? '<p style="text-align: justify;font-size:9px;"><i>ESTA PROPUESTA ES VALIDA HASTA EL '. date_format($vew_ord->slsordenddte,"d/m/Y").' LUEGO DEBERÁ AJUSTARSE SEGÚN VALORES VIGENTES.</i></p>' : '');
	$pdf->setY(65); $pdf->writeHTML( $lv_buffer );
	


	
	// OUTPUT
	$pdf->Output('CW'.$vew_ord->slsordcod.'-'.ucwords(strtolower($vew_ord->dstobjtxt)).'-'.ucfirst(strtolower($vew_ord->slsordtxt)).'.pdf', 'I');	
?>
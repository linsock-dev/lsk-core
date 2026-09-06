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
			$this->RoundedRect(0, 0, 255, 2, 0, '0101', 'DF', $style5, array(247, 149, 26) );
			$this->Image('library/images/logos/zcutms_temasisargentina.jpg',8,7,80);
			$this->setfont('helvetica', '', 12);
			$this->setY(10); $this->writeHTML('Presupuesto Nro. <b>'.str_pad($this->lo_data->slsordcod, 8, '0', STR_PAD_LEFT).'</b>', true, false, false, false, 'R');
			$lo_mth=array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
			$this->setY(18); $this->writeHTML(date_format($this->lo_data->slsorddte,'d').' de '.$lo_mth[date_format($this->lo_data->slsorddte,'m')-1].' de '.date_format($this->lo_data->slsorddte,'Y'), true, false, false, false, 'R');
    }

    // Page footer
    public function Footer() {
			$this->setfont('helvetica', 'I', 12);	
			$this->setXY( 15, 285 );
			$this->writeHTML( '<a href="https://www.temasis.ar" target="_blank" style="text-decoration:none;">www.temasis.ar</a>' );
			$this->setXY( 90, 285 );
			$this->writeHTML( '<a href="mailto:info@temasis.ar" target="_blank" style="text-decoration:none;">info@temasis.ar</a>' );
			$this->setfont('helvetica', '', 8);	
			$this->text( 178, 286, 'Página '.$this->getAliasNumPage().' de '.$this->getAliasNbPages() );
			$style5 = array('width' => 0, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 64, 128));
			$this->RoundedRect(0, 295, 255, 297, 0, '0101', 'DF', $style5, array(10, 147, 67) );
    }
	}

	// create new PDF document
	$pdf = new MYPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'ISO-8859-1', false);

	// fija datos de cabecera/pie
	$pdf->tmssSetData( $vew_ord );

	// set default monospaced font
	$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

	// set margins
	$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP+10, PDF_MARGIN_RIGHT);
	$pdf->SetHeaderMargin(PDF_MARGIN_HEADER);
	$pdf->SetFooterMargin(PDF_MARGIN_FOOTER);

	// set auto page breaks
	$pdf->SetAutoPageBreak(true, PDF_MARGIN_BOTTOM);

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
	
	// ---------------------------------------------------------
	$pdf->AddPage('P');

	$pdf->setfont('helvetica', 'B', 16);	
	$pdf->setY(40); $pdf->writeHTML($vew_ord->dstobjtxt);
	$pdf->setfont('helvetica', 'B', 12);	
	$pdf->setY(55); $pdf->writeHTML($vew_ord->slsordtxt);
	$pdf->setfont('helvetica', 'B', 14);	
	$pdf->setY(70);  $pdf->writeHTML('<p style="color: #333399;">Propuesta económica</p>');
	$pdf->setfont('helvetica', '', 12);
	$lv_paytxt=''; foreach($vew_txt as $lv_row){if($lv_row['txttypcodext']=='QTA_PAG'){$lv_paytxt.=html_entity_decode($lv_row['txttxt']);break;}}
	$lv_buffer = '<p style="text-align: justify;">El precio por la implementación de las mejoras (ver Anexo I) es de <b><span style="color: #3333FF;">$ '.number_format($vew_ord->slsordtotamt,2,',','.').'</span></b> (pesos '.strtolower($vew_doc->numberToWords( $vew_ord->slsordtotamt,'','')).') más IVA.</p>'
							.'<p style="color: #3333AA;"><b>Modalidad de Pago</b></p>'
							.$lv_paytxt
							.'<p style="color: #333399;"><b>Condiciones</b></p>'
							.'<p style="color: #6666AA;"><b>Pruebas unitarias e integrales</b></p>'
							.'<p style="text-align: justify;">Temasis Argentina SRL realizará las pruebas unitarias. El cliente designará un responsable por la realización y aceptación de las pruebas integrales. La aprobación de estas últimas, será necesaria para la puesta en productivo.</p>'
							.'<p style="color: #333399;"><b>Validez</b></p>'
							.'<p>El presente documento tendrá validez dentro de los 30 días de realizada la presentación.</p>';
	$pdf->setY(80); $pdf->writeHTML( $lv_buffer );
	
	// --------------------------------------------------------------------------
	$pdf->AddPage('P');

	$pdf->setY(45); $pdf->writeHTML('<p style="color: #333399;"><b>Anexo I – Detalle de mejoras</b></p>');
	$pdf->setY(65); 
	foreach($vew_txt as $lv_row){
		if($lv_row['txttypcodext']??''=='QTA_MEJ'){
			$pdf->writeHTML(html_entity_decode(utf8_encode($lv_row['txttxt']??'')));
//html_entity_decode($lv_row['txttxt']==null?'':
			break;
		}
	}
	
	// OUTPUT
	$pdf->Output('CW'.$vew_ord->slsordcod.'-'.ucwords(strtolower($vew_ord->dstobjtxt)).'-'.ucfirst(strtolower($vew_ord->slsordtxt)).'.pdf', 'I');	
?>
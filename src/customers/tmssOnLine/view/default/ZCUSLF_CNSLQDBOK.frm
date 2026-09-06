<?php
require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

class PedidoEmpresaPDF extends TCPDF {
	public $lqd;    
  
  public function Header() {
		$this->SetCellPadding(2);
    // Empresa 
    $this->SetFont('helvetica', 'B', 10);
    $this->SetXY(10, 10);
    $this->Cell(150, 8, 'SELF INGENIERIA ELECTRICA S.R.L.', 1, 0, 'L');
    //N de Pedido
    $this->Cell(40, 8, $this->lqd->cnslqdcodext, 1, 1, 'C');
    // Título
    $this->SetFont('helvetica', 'B', 12);
    $this->Cell(190, 10, 'PEDIDO DE EMPRESA', 1, 1, 'C');

    // Contratación / Fecha
    $this->SetFont('helvetica', '', 9);
    $this->Cell(60, 8, 'CONTRATACION:', 1, 0);
    $this->Cell(80, 8, '9000008061', 1, 0);
    $this->Cell(20, 8, 'FECHA:', 1, 0);
    $lv_dte = $this->lqd->ctedte->format('d/m/Y') ?? '';
   
    $this->Cell(30, 8, $lv_dte, 1, 1);
    
  	}

   public function Footer() {

    $this->SetFont('helvetica', '', 9);
    $this->SetCellPadding(2);

    $this->SetY(-50);
    $this->SetX(10);
		$lv_dte = $this->lqd->ctedte->format('d/m/Y') ?? '';
    $this->SetFont('helvetica', 'B', 9);
    $this->Cell(95, 8, 'ENTREGADO        FECHA: '.$lv_dte, 1, 0);
    $this->Cell(95, 8, 'RECIBIDO        FECHA:', 1, 1);

    $this->SetFont('helvetica', '', 9);
    $this->Cell(95, 20, 'Firma:', 1, 0);
		$this->Cell(95, 20, 'Firma:', 1, 1);

    $this->Cell(95, 8, 'Aclaración:', 1, 0);
    $this->Cell(95, 8, 'Aclaración:', 1, 1);
  }
}

// PDF
$pdf = new PedidoEmpresaPDF('P','mm','A4',true,'UTF-8',false);
$pdf->lqd = $vew_data;
$pdf->SetMargins(10, 45, 10);
$pdf->SetAutoPageBreak(true, 50);
$pdf->AddPage();
$pdf->SetFont('helvetica', '', 10);
$lv_remtxt = implode(' - ', $vew_data->steevtdocremarr);
// Texto principal
$txt = 'Por medio de la presente hago entrega de los trabajos realizados en el sector de "'
       . mb_convert_encoding($vew_data->lndtwntxt, 'UTF-8', 'iso-8859-1')
       . '", con remitos N° ' . $lv_remtxt . '.';

$pdf->MultiCell(0, 5, $txt, 0, 'L');
$pdf->Ln(1);

$pdf->Output('pedido_empresa.pdf', 'I');

<?php
	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

	// Extend the TCPDF class to create custom Header and Footer
	class MYPDF extends TCPDF {
    public $lv_data;
    public $lv_bus;
    public function setCustomer($lp_data){$this->lv_data=$lp_data;}
    public function setBus($lp_data){$this->lv_bus=$lp_data;}
    
    // ENCABEZADO
    public function Header() {
      $lv_imgdat = json_decode($this->lv_data->img, true);

      if (isset($lv_imgdat['flecnt'])) {
				$lv_img =$lv_imgdat['flecnt']; // Guardar la imagen en la variable
				$lv_imgdat = base64_decode($lv_imgdat['flecnt']);
				$this->Image('@'.$lv_imgdat, 8, 7, 55);
      }

      $this->setfont('helvetica', 'B', 8);
      $this->text( 8, 35, $this->lv_bus->bustxt);
      $this->line( 92,10,108,10);
      $this->line( 92,10,92,25);
      $this->line( 108,10,108,25);
      $this->line( 92,25,108,25);
      $this->setfont('helvetica', '', 7);
      $this->text( 87, 27, 'Documento NO valido');
			$this->text( 93, 29, 'como factura');
      $this->setfont('helvetica', '', 8);
			$lv_adr = utf8_encode($this->lv_bus->adr->adrstr??'');
			$lv_adr .= ($lv_adr!='' && $this->lv_bus->adr->adrstrnum??''!=''?' ':'').utf8_encode($this->lv_bus->adr->adrstrnum??'');
			$lv_adr .= ($lv_adr!='' && $this->lv_bus->adr->adrstrflr??''!=''?' Pso.':'').utf8_encode($this->lv_bus->adr->adrstrflr??'');
			$lv_adr .= ($lv_adr!='' && $this->lv_bus->adr->adrstrunt??''!=''?' Dto.':'').utf8_encode($this->lv_bus->adr->adrstrunt??'');
      $this->text( 8, 42, $lv_adr );
			$lv_cty = utf8_encode($this->lv_bus->adr->adrpstcod);
			$lv_cty .= ($lv_cty!='' && $this->lv_bus->adr->adrtwn!=''?' - ':'').utf8_encode($this->lv_bus->adr->adrtwn);
			$lv_cty .= ($lv_cty!='' && $this->lv_bus->adr->adrcty!=''?' - ':'').utf8_encode($this->lv_bus->adr->adrcty);
			$lv_cty .= ($lv_cty!='' && $this->lv_bus->adr->lndregtxt!=''?' - ':'').utf8_encode($this->lv_bus->adr->lndregtxt);
      $this->text( 8, 46, $lv_cty );
      $this->text( 8, 50, $this->lv_bus->adr->lndtxt);
      $this->setfont('helvetica', 'B', 8);
      $this->text( 8, 54, $this->lv_bus->tax->taxcattxt);	
      $this->setfont('helvetica', 'B', 16);
      $this->text( 115, 10, ($this->lv_data->sysdoccls->objtyp=='STK_SOU'?'VALE DE SALIDA':'VALE DE ENTRADA'));
      $this->setfont('helvetica', 'B', 12);
			if( $this->lv_data->stkmovdoccodext=='' ){
				$this->text( 115, 20, 'ID #'.$this->lv_data->stkmovdoccod);
			} else {
				$this->text( 115, 20, 'Nro. '.$this->lv_data->stkmovdoccodext);
			}
      $this->setfont('helvetica', '', 8);
      $lo_mth=array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
      $this->text( 115, 35, 'Buenos Aires, '.date_format($this->lv_data->stkmovdocdte,'d').' de '.$lo_mth[date_format($this->lv_data->stkmovdocdte,'m')-1].' de '.date_format($this->lv_data->stkmovdocdte,'Y'));
      $this->text( 115, 42, 'C.U.I.T.: '.substr($this->lv_bus->tax->taxcod,0,2).'-'.substr($this->lv_bus->tax->taxcod,2,8).'-'.substr($this->lv_bus->tax->taxcod,10,1) );
      $this->text( 115, 46, 'Ingresos Brutos: '.$this->lv_bus->tax->taxiibb??'');
      $this->text( 115, 50, 'Fecha de Inicio de Actividades: '. ($this->lv_bus->tax->taxactstr!=''?(date_format($this->lv_bus->tax->taxactstr,'d-m-Y')):''));
    }
		
    public function Footer() {
      $this->SetY(-25);
      $this->setfont('helvetica', '', 12);
      $this->text( 25, $this->getY(),   '.........................................                   .........................................');
      $this->text( 25, $this->getY()+7, '        Recibí conforme                                     Aclaración');
      $this->SetY(-15);
			$this->SetFont('helvetica', '', 8);
			$this->text(180, $this->getY(), 'Pagina '.$this->getAliasNumPage().' de '.$this->getAliasNbPages() );
    }
		
    public function infoCliente(){
      // CLIENTE
      $this->setfont('helvetica', 'B', 8);
      $this->line( 6,60,206,60);
      $this->text( 8, 62,  utf8_encode($this->lv_data->sysdoccls->objtyp=='STK_SOU'?$this->lv_data->dstobjtxt:$this->lv_data->srcobjtxt));
      $this->setfont('helvetica', '', 8);
      if($this->lv_data->adr!=null){
				$lv_adr = utf8_encode($this->lv_data->adr['adrstr']??'');
				$lv_adr .= ($lv_adr!='' && $this->lv_data->adr['adrstrnum']!=''?' '.utf8_encode($this->lv_data->adr['adrstrnum']):'');
				$lv_adr .= ($lv_adr!='' && $this->lv_data->adr['adrstrflr']!=''?' Pso. '.utf8_encode($this->lv_data->adr['adrstrflr']):'');
				$lv_adr .= ($lv_adr!='' && $this->lv_data->adr['adrstrunt']!=''?' Dto. '.utf8_encode($this->lv_data->adr['adrstrunt']):'');
      	$this->text( 8, 67, $lv_adr );

				$lv_cty = utf8_encode($this->lv_data->adr['adrpstcod']??'');
				$lv_cty .= ($lv_cty!='' && $this->lv_data->adr['adrtwn']??''!=''?' - '.utf8_encode($this->lv_data->adr['adrtwn']):'');
				$lv_cty .= ($lv_cty!='' && $this->lv_data->adr['adrcty']??''!=''?' - '.utf8_encode($this->lv_data->adr['adrcty']):'');
				$lv_cty .= ($lv_cty!='' && $this->lv_data->adr['lndregtxt']??''!=''?' - '.utf8_encode($this->lv_data->adr['lndregtxt']):'');
      	$this->text( 8, 72, $lv_cty );

				$lv_phn = $this->lv_data->adr['adrphn001']??'';
				$lv_phn .= ($lv_phn!='' && $this->lv_data->adr['adrphn002']??''!=''?' / '.$this->lv_data->adr['adrphn002']:'');
				$lv_phn .= ($lv_phn!='' && $this->lv_data->adr['adrmblphn']??''!=''?' / '.$this->lv_data->adr['adrmblphn']:'');
      	if($lv_phn!=''){ $this->text( 8, 77,  'Telefono: '. $lv_phn ); }
      }
    }
		
    public function infoContacto(){
      $this->setfont('helvetica', '', 8);
      $this->text( 115, 67,  utf8_encode($this->lv_data->cnt->cnttxt??''));
      if($this->lv_data->cnt->adr !=null){
        $this->setfont('helvetica', 'B', 8);
        $this->text( 115, 62, ($this->lv_data->sysdoccls->objtyp=='STK_SOU'?'LUGAR DE ENTREGA':'LUGAR DE RETIRO'));
      	$this->setfont('helvetica', '', 8);
				
				$lv_adr = utf8_encode($this->lv_data->cnt->adr->adrstr??'');
				$lv_adr .= ($lv_adr!='' && $this->lv_data->cnt->adr->adrstrnum!=''?' ':'').utf8_encode($this->lv_data->cnt->adr->adrstrnum);
				$lv_adr .= ($lv_adr!='' && $this->lv_data->cnt->adr->adrstrflr!=''?' Pso.':'').utf8_encode($this->lv_data->cnt->adr->adrstrflr);
				$lv_adr .= ($lv_adr!='' && $this->lv_data->cnt->adr->adrstrunt!=''?' Dto.':'').utf8_encode($this->lv_data->cnt->adr->adrstrunt);
        $this->text( 115, 72, $lv_adr );
				
				$lv_cty = utf8_encode($this->lv_data->cnt->adr->adrpstcod);
				$lv_cty .= ($lv_cty!='' && $this->lv_data->cnt->adr->adrtwn!=''?' - ':'').utf8_encode($this->lv_data->cnt->adr->adrtwn);
				$lv_cty .= ($lv_cty!='' && $this->lv_data->cnt->adr->adrcty!=''?' - ':'').utf8_encode($this->lv_data->cnt->adr->adrcty);
				$lv_cty .= ($lv_cty!='' && $this->lv_data->cnt->adr->lndregtxt!=''?' - ':'').utf8_encode($this->lv_data->cnt->adr->lndregtxt);
				$this->text( 115, 77, $lv_cty );
				
				$lv_phn = $this->lv_data->cnt->adr->adrphn001??'';
				$lv_phn .= ($lv_phn!='' && $this->lv_data->cnt->adr->adrphn002!=''?' / ':'') . $this->lv_data->cnt->adr->adrphn002;
				$lv_phn .= ($lv_phn!='' && $this->lv_data->cnt->adr->adrmblphn!=''?' / ':'') . $this->lv_data->cnt->adr->adrmblphn;
      	if($lv_phn!=''){ $this->text( 115, 82,  'Telefono: '. $lv_phn ); }
      }
    }
	}
	
	// create new PDF document
	$pdf = new MYPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'ISO-8859-1', false);
	$pdf->setCustomer($vew_data);
	$pdf->setBus($vew_bus);

	// set default monospaced font
	$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

	// set margins
	$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
 
	// set auto page breaks
	//$pdf->SetAutoPageBreak(TRUE, PDF_MARGIN_BOTTOM);  
	$pdf->SetAutoPageBreak(TRUE, 10); 
	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
	
	// ---------------------------------------------------------
	
	$pdf->AddPage('P');
	$pdf->infoCliente();	
	$pdf->infoContacto();	

	// POSICIONES
	$lv_tot=0;
	$lv_cnt=0;
	$lv_cnttotrow=count($vew_data->stkmovdocmat);
	$lv_cnttot=0;
	$lv_buffer='';
	$lv_buffertbl='<table border="0" cellpadding="5" cellspacing="0">'
									.'<thead>'
										.'<tr style="background-color:#c7c7c7;">'
											.'<th width="70">ID</th>'
											.'<th width="120">Codigo</th>'
											.'<th width="390">Descripcion</th>'
											.'<th width="120" align="right">Cantidad</th>'
                    .'</tr>'
    							.'</thead>'
									.'<tbody>';
	
	foreach($vew_data->stkmovdocmat as $lv_row) {
    if(($lv_row['sysdocrejcod']=='0' || $lv_row['sysdocrejcod']==null ) || $vew_data->sysdocclscodext=='DEPRO') {
        $lv_buffer .= '<tr>'
                        .'<td width="70">'.$lv_row['matcod'].'</td>'
                        .'<td width="120">'.$lv_row['matcodext'].'</td>'
                        .'<td width="390">'.utf8_encode($lv_row['mattxt'])
													.($lv_row['matbchcodext']!='' && $lv_row['matbchcodext']!=NULL ? '<br><span style="font-size: 9px;">Lote: '.$lv_row['matbchcodext'].($lv_row['matbchduedte']!=''?(' - Vto: '.date_format($lv_row['matbchduedte'],'d/m/Y')):'').'</span>' : '' )
													.($lv_row['matsercod']!='' && $lv_row['matsercod']!=NULL ? '<br><span style="font-size: 9px;">Serie: '.$lv_row['matsercod'].'</span>' : '' )
													.($lv_row['sysdocrsntxt']!='' && $lv_row['sysdocrsntxt']!=NULL ? '<br><span style="font-size: 9px;">Motivo: '.$lv_row['sysdocrsntxt'].'</span>' : '' )
												.'</td>'
												.'<td width="120" align="right">'.number_format($lv_row['matqty'],2).' '.$lv_row['matuntcod'].'</td>'
                      .'</tr>';
      $lv_cnt++;
      $lv_cnttot++;
		}
		
    // 20 lineas x pagina
    if ($lv_cnt==20 || $lv_cnttot==$lv_cnttotrow) {
			$pdf->setfont('helvetica', '', 9 );
			$lv_buffer = $lv_buffertbl.$lv_buffer.'</tbody></table>'; 
			$pdf->setxy( 7, 87 );
			$pdf->writeHTML($lv_buffer);
			$lv_buffer='';
			$lv_cnt=0; 
			// si no es la ultima pagina, se agrega una nueva para continuar con lo siguiente
			if($lv_cnttot!=$lv_cnttotrow){
				$pdf->AddPage('P');
				$pdf->infoCliente();
				$pdf->infoContacto();
			}
    }
	}	
	
	$pdf->Output( ($vew_data->sysdoccls->objtyp=='STK_SOU'?'valeSalida':'valeEntrada').'_'.$vew_data->stkmovdoccod.'.pdf', 'I');	
?>
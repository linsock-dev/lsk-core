<?php
	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

	// create new PDF document
	$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, true, 'UTF-8', false);

	// remove default header/footer
	$pdf->setPrintHeader(false);
	$pdf->setPrintFooter(false);

	// set default monospaced font
	$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

	// set margins
	$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
 
	// set auto page breaks
	$pdf->SetAutoPageBreak(TRUE, 1);

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
	

	// ---------------------------------------------------------
	$pdf->AddPage('P');
	
	$lo_mth = array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
	$pdf->setfont('helvetica', '', 14);
	
	// Logo
	//if($vew_data->bus->busimg!=''){$pdf->Image('@'.$vew_data->bus->busimg, 10,10,40);}
	$pdf->Image('library/images/logos/zcutms_temasisargentina.jpg',10,10,80);

	// Fecha
	$pdf->text( 135, 20, date('d').' de '.$lo_mth[date('m')-1].' de '.date('Y') );

	if( count($vew_data->chrasg)>0 ){
		// Leyenda
    try{
			$lv_taxdoctyptxt = ($vew_data->tax->taxdoctyp=='86'?'CUIL':($vew_data->tax->taxdoctyp=='80'?'CUIL':'DNI'));
			$lv_taxdocnum = ($vew_data->tax->taxdoctyp=='86' || $vew_data->tax->taxdoctyp=='80' ? substr($vew_data->tax->taxdocnum,0,2).'-'.substr($vew_data->tax->taxdocnum,2,8).'-'.substr($vew_data->tax->taxdocnum,10,1) : number_format($vew_data->tax->taxdocnum,0,'','.') );			
      $lv_txt = 'Certifico que el/la Sr./Sra. <b>'.$vew_data->hhremptxt.'</b> '.$lv_taxdoctyptxt.' '.$lv_taxdocnum.
        ' se desempe&ntilde;a como <b>'.$vew_data->chrasg[0]['hhrchrtyptxt'].'</b>, '.
        ' en nuestra Instituci&oacute;n: <b>'.$vew_data->bus->bustxt.'</b> ('.$vew_data->bus->tax->idttyptxt.' '.substr($vew_data->bus->tax->taxcod,0,2).'-'.substr($vew_data->bus->tax->taxcod,2,8).'-'.substr($vew_data->bus->tax->taxcod,10,1).') '.
        ' ubicado en <b>'.$vew_data->bus->adr->adrstr.($vew_data->bus->adr->adrstrnum!=''?' '.$vew_data->bus->adr->adrstrnum:'').($vew_data->bus->adr->adrstrflr!=''?' Pso.'.$vew_data->bus->adr->adrstrflr:'').($vew_data->bus->adr->adrstrunt!=''?' Dto.'.$vew_data->bus->adr->adrstrunt:'').', '.ucwords(strtolower($vew_data->bus->adr->lndregtxt)).', '.ucwords(strtolower($vew_data->bus->adr->lndtxt)).'.</b><br><br>'.
        'Se extiende el presente certificado a pedido del interesado para ser presentado ante qui&eacute;n corresponda.';
      $pdf->writeHTMLcell(180,180,15,60, utf8_encode($lv_txt) );
    }catch (Throwable $e) {
      $pdf->writeHTMLCell(180, 180, 15, 60, utf8_encode(
        "<b style='color:red;'>Error al generar el certificado:</b> Los datos del empleado est&aacute;n incompletos."
    	));
      $pdf->Output('Certificado_de_Trabajo.pdf', 'I');
		}
	}

	// firma
	$lv_firma = base64_decode('/9j/4AAQSkZJRgABAQAAAQABAAD/4gHYSUNDX1BST0ZJTEUAAQEAAAHIAAAAAAQwAABtbnRyUkdCIFhZWiAAAAAAAAAAAAAAAABhY3NwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAA9tYAAQAAAADTLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlkZXNjAAAA8AAAACRyWFlaAAABFAAAABRnWFlaAAABKAAAABRiWFlaAAABPAAAABR3dHB0AAABUAAAABRyVFJDAAABZAAAAChnVFJDAAABZAAAAChiVFJDAAABZAAAAChjcHJ0AAABjAAAADxtbHVjAAAAAAAAAAEAAAAMZW5VUwAAAAgAAAAcAHMAUgBHAEJYWVogAAAAAAAAb6IAADj1AAADkFhZWiAAAAAAAABimQAAt4UAABjaWFlaIAAAAAAAACSgAAAPhAAAts9YWVogAAAAAAAA9tYAAQAAAADTLXBhcmEAAAAAAAQAAAACZmYAAPKnAAANWQAAE9AAAApbAAAAAAAAAABtbHVjAAAAAAAAAAEAAAAMZW5VUwAAACAAAAAcAEcAbwBvAGcAbABlACAASQBuAGMALgAgADIAMAAxADb/2wBDAAMCAgICAgMCAgIDAwMDBAYEBAQEBAgGBgUGCQgKCgkICQkKDA8MCgsOCwkJDRENDg8QEBEQCgwSExIQEw8QEBD/2wBDAQMDAwQDBAgEBAgQCwkLEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBD/wAARCABpAMwDASIAAhEBAxEB/8QAGwABAAIDAQEAAAAAAAAAAAAAAAEFAgMEBgn/xAA4EAABAwMBBQUFBwQDAAAAAAABAAIDBAURBhIhMVFiE0FhcZEHFCIygRZCcqGxwdEVIyRSU4OS/8QAGAEBAQEBAQAAAAAAAAAAAAAAAAECAwT/xAAsEQEAAQIEAwcEAwAAAAAAAAAAAQIRAxIhMRNRkUFhcYGx0fAEIzLBM6Hh/9oADAMBAAIRAxEAPwD6pooPBSgIiICIiAiIgIiICIiAiIgIiICIiAiIgIiICIiCFKjkpQQeClQeClAREQEREBERARQ44UbWDgqXGSLmrbjRW6A1NdUsgjH3nnG/kOZ8AqG6aouronR6atDamoIBa6rkEEWD97/bHmAumHh1Yn4peHp0VaL7bIIGurrrRMka0dpiZuA7G/G/K0N1dp17xHFcmyOPDYje78wFMlXJVyi4HXeDshNDDUztPARwuz+eF5vUftT07pQbV9iqqQHAbthm048NzQ7aO8juWqMKuuctMXk2ezRVcVzuNXTMqqG1hzJWB7O2mDDgjI3AHCiL7SyjaqHUFN0tDpT6/CszTMbi1RUtzuDLayL+oX0U8kh2GMjiaXSOPANbvKaalv08M0t6aWxuePdRJGGTdnjjKGnZDs54dyZdM1xdIiLIIiII5KVHJSgg8FKg8FKAiLRV1tLQwPqayojghjGXPe4AD1Qb1BOBnKqXXqoqmPNooJJxsB0c0p7OF+eTjvP0C0m33y4wsZcrqad3zObQjZYfDbdl3phbyc5skrWetpaZu3U1McTRxMjg39VUfayKsbK2w0FVcZIxhpbGY4nO5do7A9MrrZp20lzZKiginkbjD5Rtu3eJyrIMaBgDA8Fb4dMaaz0hIvO7x/vWsLnKaWsfR22R7Ts00U3aPAx8zngbvphcVs0ZfbfcJ6ynv5h7aIRy1L4dpwAOcNDif/R9F62amtFFWOuJpY21dRhhkaz+5JgbhzOFzXCWnZA6u1BVQ0tDEciNz8NI6z978K9EfUVRpRERE93pe92ckdqi+xdsudaatk9dWPHzVtVUveGuH/Gzc3nvG4K9oLDp7T1IRHBDG3i+ad20555uc7itDrvd64bGnrUWQxuANRVsLGOYO+Ng+J3hnAXkI9J6n1HXm7aquPuNvbIZIIajZMze4Zb8jPIZPMldKc2NFsXEy0x2bz0hZm20LB3tAsE9YyLTtiFbSRzBtZXOhEMETO8sJGZXcmtB81a3G+aubNSnS2j4quilIM0tVVCmc0HvazBJ+uFyfaD2d6Mp2skvdI+aNpa3EonqH9IDcn6DAVfcvaDSTUz66ubdaa2BzNgUVM8yPz3SPIAbvx8LfVSMHiVROFhzbvvr0tdqLxuuLgy5XJ8lDV3F9RI+MO9wt57JsZzv7SfOceh8F02zRdjoZIq2pttEaiH4mFkQDYt3M73Hxcqum1LdX0Pu+jPZ9XxHOWOrmspoTn7/AMxc70yuWSze0a6VAmu1PbZGvbsuglrX+7N/6mNBf9XFYyVxTN6opjxi/RbvVVWprfT1BoKFstdV4z2NM3bxy2nfK36laom6rubBJWSU9pZtb4YsTSFvIvPwtPkD5rG22nUVPQx0r6+20fZt2WtoaTDW+A2yVol0neqmXbqtdXnZ72QNhib+Tcj1XGOHTtMf3P6sLa22O2Wxu1TU5MriXOmlJfI4njlx3/su10scQ+OVjR4uAVNRaQoKVhjnrrnXbROTU1sjtx7sAgKTofSTi4yWGleXcdtpdn1WJimdZqmZ8P8ARZm529u51fTA+Mrf5W2Gpp6jPYTxyY47Dwf0VVHorSEbQxmmbYAOH+Mz+F22+zWm1FxtltpqXb+bsYwzPopMUW0mfnmO1ERZEclKjkpQQeClQeClBR6uvdVYLS+4U0BeGuaJZCxz2wMPGQtb8TgOQVdZ5tLVxbcqjUdJdqiRoPaSzNDG/giJwz9fFeswCuWotNqq3B1VbKWYt4GSFriPULrRXTFOWY84+ftJv2Oea+WCJhbNdqFrcbwZ28PVVdd7R9EWzEc+o6QuA3MiJld9AwFXjLRaoiDHbKRpHAthaMfktrmU0DS/s442t3l2AAE+1ymfOPaTV56m15ba9ubfbb1UZ3gttsrAR5vACr7prXVrHyQWbQVRI5jQTNWV0MMTAe92HE/TirWe81F3DqawxySNJINR8se44I2v43+S6qSwQhzZbk/3x7XCRjXN/tRHob+5yV2jhYWtVPlMzPpZnWdpeXs109oN1DKiGyWlnaFzZKuepkdsEbvgZsDI8tx5rpi0ZqmetFwu2rqaolyCGi2NLYxyYHPIaerGV7RwAxgeior1rCy2iZtE6o7ese7YbTw/E8Hu2gOASMavEqy4VER4R73LW1qly1mi/fMyXDVt/eMbxHWCBnoxo/VVj7RpK2xGSGkYYsFrquvkfUF5G4bEbiS8+IGFYU1NqTUDo57hEKGExnLJBksfncWxnv8AF3orygslDRSipMZmqg0MNTN8Urh59w8BuTiThTaqq893yyxq89abAIHyusNkpbeyY9oa6ogaZpHHlGANkeePJXVFpq3wzPq6ztK+pcc9rVO29n8DflYPIK3wBwClca8auub/ADqtmIa0cApwFKLlZUYwpREBERAREQEREEclKjkpQQeClQeClAUHgjuCof6/Ndql9Bp5gma0ESVzhmCNwOC1v+7hv3DcMb1qmmatkmbO263qktQbG8vlqpd0NPENqSQ+Q4DxO4Kugstwvbm1mpnbDAQ+O3wyHs4z1uGNs/krG2Want73VDnGorJWhs1VIB2kmOA3cByA3KxAA4BbjEij+Pfn7cvVLX3YxQxRMEcUbWNaMANGAFmoxhSuW+stK++W6e6299BBcZ6EykB0sONvYz8TQTwyN2RvGdy0WjS1gsh7S3WuGOU73TOG3I444lxySfFWxGeKYAWorriMsToWiQADgFKIsgiIgIiICIiAiIgIiICIiCOSlRyUoIPBSihBK1w08FNGIaeGOKNucMY0NAycncFsRBGApREBERAREQEREBERAREQEREBERAREQEREEclKhSgjhvWJJPfhZHgfJazxQTjqKY6isUQZY6imOorFEGWOopjqKxRBljqKY6isUQZY6imOorFEGWOopjqKxRBljqKY6isUQZY6imOorFEGWOopjqKxRBljqKY6isUQZY6imOorFEGwE7gSslqH7hbUH//2Q==');
	$pdf->Image('@'.$lv_firma, 77,127,60);
	$pdf->setfont('helvetica', '', 14);
	$pdf->text( 75, 150, 'Ignacio Martin Dominguez' );
	$pdf->setfont('helvetica', 'B', 14);
	$pdf->text( 80, 157, 'SOCIO GERENTE' );

	
	$pdf->Output('Certificado_de_Trabajo.pdf', 'I');
?>
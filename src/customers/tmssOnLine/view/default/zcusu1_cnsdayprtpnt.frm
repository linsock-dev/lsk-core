<?php
	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

	// create new PDF document
	$pdf = new TCPDF(PDF_PAGE_ORIENTATION, PDF_UNIT, PDF_PAGE_FORMAT, false, 'ISO-8859-1', false);

	// remove default header/footer
	$pdf->setPrintHeader(false);
	$pdf->setPrintFooter(false);

	// set default monospaced font
	$pdf->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);

	// set margins
	$pdf->SetMargins(PDF_MARGIN_LEFT, PDF_MARGIN_TOP, PDF_MARGIN_RIGHT);
  
	// set auto page breaks
	$pdf->SetAutoPageBreak(TRUE, 1); //PDF_MARGIN_BOTTOM);

	// set image scale factor
	$pdf->setImageScale(PDF_IMAGE_SCALE_RATIO);
	
	// ---------------------------------------------------------
	$pdf->AddPage('L');


	// UNIDAD. busco la unidad en la primer obra
	$lv_untcod = '';
	$lv_unttxt = '';
	$lv_untadr = '';
	$lv_untzon = '';
	foreach( $vew_data['stecnt'] as $lv_rowcnt ){
		if($lv_rowcnt['sysdocclscodext']=='UNT'){
			//$lv_untcod = $lv_rowcnt['cntdstcodext'];
			$lv_unttxt = $lv_rowcnt['cntdsttxt'];
			$lv_untstr = $lv_rowcnt['cntdstadrstr'];
			$lv_untzon = $lv_rowcnt['cntdstadrzon'];
			break;
		}
	}	

	// E N C A B E Z A D O
	$pdf->Image('library/images/logos/supplysouth.jpg',200,5,50);
	$pdf->Image('library/images/logos/supplysouth_iso9001_45001_iqnet.jpg',265,5,25);
	$pdf->setfont('Helvetica', 'B', 9);
	$pdf->setxy(15,5); $pdf->Cell(85, 10, $vew_data['cus']->custxt, 1, 0, 'L');
	$pdf->setfont('Helvetica', '', 9);
	$pdf->setxy(15,15); $pdf->Cell(85, 5, 'Area: '.$lv_untstr, 1, 0, 'L');
	$pdf->setxy(15,20); $pdf->Cell(85, 5, 'Unidad: '.$lv_unttxt, 1, 0, 'L');
	$pdf->setxy(15,25); $pdf->Cell(85, 5, 'Atencion: '.$lv_untcod, 1, 0, 'L');
	$pdf->setfont('Helvetica', 'B', 9);
	$pdf->setxy(105,5); $pdf->Cell(85, 10, 'PARTE DIARIO - '.$vew_data['docdte'], 1, 0, 'C');
	$pdf->setfont('Helvetica', '', 9);
	$pdf->setxy(105,15); $pdf->Cell(85, 5, 'CONTRATISTA: '.$vew_sec->bustxt, 1, 0, 'L');
	$pdf->setxy(105,20); $pdf->Cell(85, 5, 'SUBGERENCIA: '.$lv_untzon, 1, 0, 'L');

	// C U E R P O
	$pdf->setfont('Helvetica', '', 7);
	$lv_buffer= '<table border="1" cellspacing="0" cellpadding="3" width="100%">'.
								'<tr style="background-color:#e6e6e6;">'.
									'<th colspan="3" width="170"></th>'.
									'<th align="center" colspan="3" width="360">PERSONAL</th>'.
									'<th align="center" width="140">DIRECCION / LOCALIDAD</th>'.
									'<th align="center" width="140">TRABAJOS</th>'.
									'<th align="center" colspan="2" width="80">HORARIOS</th>'.
									'<th align="center" colspan="2" width="120">VEHICULO</th>'.
								'</tr>'.
								'<tr style="background-color:#e6e6e6;">'.
									'<td align="center" width="70">Supervisor<br>Edenor</td>'.
									'<td align="center" width="70">Pedido N</td>'.
									'<td align="center" width="30">ID</td>'.
									'<td align="center" width="150">Operario<br>Nombre y Apellido</td>'.
									'<td align="center" width="70">CUIL</td>'.
									'<td align="center" width="140">Responsable<br>Nombre y Apellido</td>'.
									'<td align="center" width="140">Ubicacion de la zona de trabajo</td>'.
									'<td align="center" width="140">Descripcion de las Tareas a<br>realizar en el dia de la fecha</td>'.
									'<td align="center" width="40">De Hs.</td>'.
									'<td align="center" width="40">A Hs.</td>'.
									'<td align="center" width="70">Tipo</td>'.
									'<td align="center" width="50">Patente</td>'.
								'</tr>';
	

	// SUPERVISOR (SUP). busco y separo supervisores y responsables del cliente
	$lv_sup = array();
  foreach( $vew_data['stecnt'] as $lv_rowcnt ){
    if( $lv_rowcnt['sysdocclscodext'] === 'SUP' ){
      $lv_sup[$lv_rowcnt['cntsrccod'].'_SUP'] = $lv_rowcnt['cnttxt'];
    } else if ( $lv_rowcnt['sysdocclscodext'] === 'SUPSUP' ){
      $lv_sup[$lv_rowcnt['cntsrccod'].'_SUPSUP'] = $lv_rowcnt['cnttxt'];
    }
  }


	// Busco las tareas de inspección y reparación para excluirlas para cada obra
  $lv_rowexcbud = array();
  foreach( $vew_data['bud'] as $lv_rowbud ){
    if (($lv_rowbud['cnstskclscodext']=='INSPECCION' || $lv_rowbud['cnstskclscodext']=='ACERAS')){
      if(!isset($lv_rowexcbud[$lv_rowbud['stecod']])){ $lv_rowexcbud[$lv_rowbud['stecod']] = array(); }
      array_push($lv_rowexcbud[$lv_rowbud['stecod']], $lv_rowbud['budmatrow']);
    }
  }


	// TAREA. listo tareas en curso (informa avance para la fecha)
	$lv_tsk = array();
  foreach($vew_data['tsk'] as $lv_rowtsk){
    if($lv_rowtsk['srcobjtyp']=='CNS_TSK'){
      $lv_tsk[$lv_rowtsk['srcobjcod']] = $lv_rowtsk['srcobjtxt'];
    }
  }


	// VEHICULOS. recupero lista de vehículos de la obras
	$lv_vhc = array();
  foreach( $vew_data['vhc'] as $lv_rowvhc ){
    $lv_vhc[$lv_rowvhc['vhccod']] = array('vhctxt' 		=> $lv_rowvhc['vhctxt'], 
                                          'vhcclstxt' => $lv_rowvhc['vhcclstxt']);
  }


  // DATOS IMPOSITIVOS. organizo cuit/cuil de empleados
  $lv_taxcemp = array();
  foreach($vew_data['tax'] as $lv_rowtax){ 
    $lv_taxemp[$lv_rowtax['taxsrccod']] = $lv_rowtax['taxcod'];
  }


	// ASISTENCIAS. recupero la lista de asistencias
	$lv_emp = array();
  foreach( $vew_data['ass'] as $lv_rowass ){
    // SOLO recupero empleados. No proveedores
    if ($lv_rowass['srcobjtyp'] == 'HHR_EMP'){
      if(!isset($lv_emp[$lv_rowass['srcobjcod'].'_'.$lv_rowass['stecod']])){
        $lv_emp[$lv_rowass['srcobjcod'].'_'.$lv_rowass['stecod']] = array();
      }

      array_push($lv_emp[$lv_rowass['srcobjcod'].'_'.$lv_rowass['stecod']], 
                 array('emptxt' => $lv_rowass['srcobjtxt'].(isset($lv_rowass['chr']) && $lv_rowass['chr'] == 'CHOFER' ? ' (chofer)' : '' ),
                       'taxcod' => (isset($lv_taxemp[$lv_rowass['srcobjcod']]) ? $lv_taxemp[$lv_rowass['srcobjcod']] : ''),
                       'tmestr' => $vew_doc->getTagValue($lv_rowass['steevtdocatr'],'tmestr'),
                       'tmeend' => $vew_doc->getTagValue($lv_rowass['steevtdocatr'],'tmeend')
                      ));
    }
	}


	// Listo todas las tareas, empleados y vehículos por obra
	$lv_stetsk = array();
	$lv_stevhc = array();
	$lv_steemp = array();
	// arrays para que no se repitan vehículos ni empleados en una obra
  $lv_vhcarr = array();
  $lv_emparr = array();
	foreach( $vew_data['bud'] as $lv_rowbud ){
    $lv_rowexc = isset($lv_rowexcbud[$lv_rowbud['stecod']]) ? $lv_rowexcbud[$lv_rowbud['stecod']] : array();
    $lv_inc = true;
    
    if(!isset($lv_emparr[$lv_rowbud['stecod']])){
      $lv_emparr[$lv_rowbud['stecod']] = array();
    }
    
    if(count($lv_rowexc) > 0){
      // Compruebo que no se muestren tareas/empleados de reparación o de inspección
      foreach($lv_rowexc as $lv_row){
        if(substr($lv_rowbud['budmatrow'],0,strlen($lv_row)) == $lv_row){
          $lv_inc = false;
          break;
        }
      }
      
      // excluyo al empleado de la obra
      if(!$lv_inc && $lv_rowbud['srcobjtyp']=='HHR_EMP'){
        if(!in_array( $lv_rowbud['srcobjcod001'], $lv_emparr[$lv_rowbud['stecod']])){
          array_push($lv_emparr[$lv_rowbud['stecod']], $lv_rowbud['srcobjcod001']);
        }
      }
    }
    
    if($lv_inc){
      if(!isset($lv_stetsk[$lv_rowbud['stecod']])){
        $lv_stetsk[$lv_rowbud['stecod']] = array();
      }

      if(!isset($lv_stevhc[$lv_rowbud['stecod']])){
        $lv_stevhc[$lv_rowbud['stecod']] = array();
      }

      if(!isset($lv_vhcarr[$lv_rowbud['stecod']])){
        $lv_vhcarr[$lv_rowbud['stecod']] = array();
      }
      
      if(!isset($lv_steemp[$lv_rowbud['stecod']])){
        $lv_steemp[$lv_rowbud['stecod']] = array();
      }

      // TAREA. recupero nombre de la/s tareas
      if($lv_rowbud['srcobjtyp']=='CNS_TSK' && $lv_rowbud['cnstskclscodext']=='TAREA'){
        if(isset($lv_tsk[$lv_rowbud['srcobjcod001']])){
          if(!in_array($lv_rowbud['srcobjtxt'], $lv_stetsk[$lv_rowbud['stecod']])){
            array_push($lv_stetsk[$lv_rowbud['stecod']], $lv_rowbud['srcobjtxt']);
          }
        }

      // VEHICULOS. recupero lista de vehículos de la obras
      } else if($lv_rowbud['srcobjtyp']=='LOG_VHC'){
				if(!in_array( $lv_vhc[$lv_rowbud['srcobjcod001']]['vhctxt'], $lv_vhcarr[$lv_rowbud['stecod']])){
            array_push($lv_vhcarr[$lv_rowbud['stecod']], $lv_vhc[$lv_rowbud['srcobjcod001']]['vhctxt']);
            array_push($lv_stevhc[$lv_rowbud['stecod']], $lv_vhc[$lv_rowbud['srcobjcod001']]);
        }
      } else if($lv_rowbud['srcobjtyp']=='HHR_EMP'){
        if(!in_array( $lv_rowbud['srcobjcod001'], $lv_emparr[$lv_rowbud['stecod']]) && isset($lv_emp[$lv_rowbud['srcobjcod001'].'_'.$lv_rowbud['stecod']])){
          array_push($lv_emparr[$lv_rowbud['stecod']], $lv_rowbud['srcobjcod001']);
          foreach($lv_emp[$lv_rowbud['srcobjcod001'].'_'.$lv_rowbud['stecod']] as $lv_rowemp){
             array_push($lv_steemp[$lv_rowbud['stecod']], $lv_rowemp);
          }
        }
      }
    }
  }


	// DATOS. recorro las obras
	$lv_dat = array();
	foreach( $vew_data['ste'] as $lv_rowste ){
		$lv_dat['stecodext'] = $lv_rowste['stecodext'];
		$lv_dat['steadr'] = $lv_rowste['adrstr'].' '.$lv_rowste['adrstrnum'].' '.$lv_rowste['adrtwn'];
		$lv_dat['sup']= ( isset($lv_sup[$lv_rowste['stecod'].'_SUP']) ? $lv_sup[$lv_rowste['stecod'].'_SUP'] : '' );
		$lv_dat['res']= ( isset($lv_sup[$lv_rowste['stecod'].'_SUPSUP']) ? $lv_sup[$lv_rowste['stecod'].'_SUPSUP'] : '');
    $lv_dat['tsk'] = isset($lv_stetsk[$lv_rowste['stecod']]) ? $lv_stetsk[$lv_rowste['stecod']] : array() ;
    $lv_dat['vhc'] = isset($lv_stevhc[$lv_rowste['stecod']]) ? $lv_stevhc[$lv_rowste['stecod']] : array() ;
    $lv_dat['emp'] = isset($lv_steemp[$lv_rowste['stecod']]) ? $lv_steemp[$lv_rowste['stecod']] : array() ;
		
		$i=0;
		$lv_tot = count($lv_dat['emp']);
		if($lv_tot>0){
			$lv_tot = ($lv_tot<count($lv_dat['vhc'])?count($lv_dat['vhc']):$lv_tot);
			$lv_tot = ($lv_tot<count($lv_dat['tsk'])?count($lv_dat['tsk']):$lv_tot);
			$lv_tot = ($lv_tot==0?1:$lv_tot);
			for($i=0; $i<$lv_tot;$i++){
				$lv_buffer.= '<tr>'.
												'<td '.($i==0?'style="background-color:#C6C6C6;"':'').'>'.($i==0?$lv_dat['sup']:'').'</td>'.
												'<td '.($i==0?'style="background-color:#C6C6C6;"':'').'>'.($i==0?$lv_dat['stecodext']:'').'</td>'.
												'<td>'.($i==0?$lv_rowste['stecod']:'').'</td>'.
												'<td>'.($i<count($lv_dat['emp'])?ucwords(strtolower($lv_dat['emp'][$i]['emptxt'])):'').'</td>'.
												'<td>'.($i<count($lv_dat['emp'])?$lv_dat['emp'][$i]['taxcod']:'').'</td>'.
												'<td>'.($i==0?ucwords(strtolower($lv_dat['res'])):'').'</td>'.
												'<td>'.($i==0?ucwords(strtolower($lv_dat['steadr'])):'').'</td>'.
												'<td>'.($i<count($lv_dat['tsk'])?ucwords(strtolower($lv_dat['tsk'][$i])):'').'</td>'.
												'<td>'.($i<count($lv_dat['emp'])?$lv_dat['emp'][$i]['tmestr']:'').'</td>'.
												'<td>'.($i<count($lv_dat['emp'])?$lv_dat['emp'][$i]['tmeend']:'').'</td>'.
												'<td>'.($i<count($lv_dat['vhc'])?ucwords(strtolower($lv_dat['vhc'][$i]['vhcclstxt'])):'').'</td>'.
												'<td>'.($i<count($lv_dat['vhc'])?$lv_dat['vhc'][$i]['vhctxt']:'').'</td>'.
											'</tr>';		
			}
		}
	}	
	$lv_buffer .= '</table>';
	$pdf->setxy(5,32);
	$pdf->writeHTML($lv_buffer);
		
	$pdf->Output('parte_diario.pdf', 'I');	
?>
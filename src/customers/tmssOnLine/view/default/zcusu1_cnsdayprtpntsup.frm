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

	// LOGOS
	$pdf->Image('library/images/logos/supplysouth.jpg',20,5,50);
	$pdf->Image('library/images/logos/supplysouth_iso9001_45001_iqnet.jpg',265,13,25);
	
	// E N C A B E Z A D O
	$pdf->setfont('Helvetica', 'B', 14);
	$pdf->setxy(75,5); $pdf->Cell(190, 20, '', 0, 0 ,'C');
	$pdf->setxy(75,5); $pdf->cell(190, 10, 'Parte Diario Supply South - '.(strtoupper($vew_data['cnstsktyp'])=='ACERAS'?'REPARACION DE ACERAS':'INSPECCION SGI-SST'), 0, 0 ,'C');
	$pdf->setxy(75,13); $pdf->cell(190, 10, 'Fecha: '.$vew_data['docdte'], 0, 0 ,'C');
	$pdf->setfont('Helvetica', '', 8);
	$pdf->setxy(265,5); $pdf->cell(25, 10, 'F-096 -SS Rev.01',0,0,'R');

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


	// TAREA. listo tareas en curso (informa avance para la fecha)
	$lv_tsk = array();
	foreach($vew_data['tsk'] as $lv_rowtsk){
    $lv_tsk[$lv_rowtsk['stecod'].'_'.$lv_rowtsk['srcobjtyp'].'_'.$lv_rowtsk['srcobjcod']] = $lv_rowtsk['srcobjtxt'];
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


	// POSICIONES DE PRESUPUESTO. Guardo las posiciones de inspección/aceras
	$lv_sterowinc = array();
	// array para guardar proveedores y empleado que estén EN una tarea
	$lv_steassintsk = array();
	// array para guardar TODAS las tareas de una obra
	$lv_stealltsk = array();
	foreach( $vew_data['bud'] as $lv_rowbud ){
    if ($lv_rowbud['cnstskclscodext']== strtoupper($vew_data['cnstsktyp'])){
      if(strtoupper($vew_data['cnstsktyp'])=='INSPECCION'){
        if(!isset($lv_tsk[$lv_rowbud['stecod'].'_'.$lv_rowbud['srcobjtyp'].'_'.$lv_rowbud['srcobjcod001']])){
          continue;
        }
      }

      if(!isset($lv_sterowinc[$lv_rowbud['stecod']])){
        $lv_sterowinc[$lv_rowbud['stecod']] = array();
      }

      array_push($lv_sterowinc[$lv_rowbud['stecod']], $lv_rowbud['budmatrow']);
    }
    
    if(strpos($lv_rowbud['budmatrow'], '.') != false && ($lv_rowbud['srcobjtyp']=='BUY_SUP' || $lv_rowbud['srcobjtyp']=='HHR_EMP')){
      array_push($lv_steassintsk, $lv_rowbud);
    } 
    
    if($lv_rowbud['srcobjtyp'] == 'CNS_TSK'){
      if(!isset($lv_stealltsk[$lv_rowbud['stecod']])){
        $lv_stealltsk[$lv_rowbud['stecod']] = array();
      }
      
      array_push($lv_stealltsk[$lv_rowbud['stecod']], $lv_rowbud);
    }
  }


	// TAREAS Y VEHÍCULOS POR OBRA
	$lv_stetsk = array();
	$lv_stevhc = array();
	// array para que no se repitan vehículos en una obra
	$lv_vhcarr = array();
  foreach( $vew_data['bud'] as $lv_rowbud){ 
    if($lv_rowbud['srcobjtyp']=='CNS_TSK' || $lv_rowbud['srcobjtyp']=='LOG_VHC'){
      $lv_rowinc = isset($lv_sterowinc[$lv_rowbud['stecod']])?$lv_sterowinc[$lv_rowbud['stecod']]:array(); 
      $lv_ste = (isset($lv_steste[$lv_rowbud['stecod']])?$lv_steste[$lv_rowbud['stecod']]:array());
      $lv_inc = false;

      // Verifico que la posición esté DENTRO de una posición de inspeccion/seguridad
      foreach($lv_rowinc as $lv_budmatrow){
        if(substr($lv_rowbud['budmatrow'],0,strlen($lv_budmatrow))==$lv_budmatrow && $lv_rowbud['budmatrow']!=$lv_budmatrow){
          $lv_inc = true;
          break;
        }
      }

      if($lv_inc){

        if(!isset($lv_stetsk[$lv_rowbud['stecod']])){
          $lv_stetsk[$lv_rowbud['stecod']] = array();
        }

        if(!isset($lv_vhcarr[$lv_rowbud['stecod']])){
          $lv_vhcarr[$lv_rowbud['stecod']] = array();
        }

        if(!isset($lv_stevhc[$lv_rowbud['stecod']])){
          $lv_stevhc[$lv_rowbud['stecod']] = array();
        }

        // TAREA. recupero nombre de las tarea
        if($lv_rowbud['srcobjtyp']=='CNS_TSK'){
          if(strtoupper($vew_data['cnstsktyp'])=='ACERAS'){
            if($lv_rowbud['cnstskclscodext']!='TAREA' || !isset($lv_tsk[$lv_rowbud['stecod'].'_'.$lv_rowbud['srcobjtyp'].'_'.$lv_rowbud['srcobjcod001']])){
              continue;
            }
          }

          array_push($lv_stetsk[$lv_rowbud['stecod']], $lv_rowbud['srcobjtxt']);

        // VEHICULOS. recupero nombre del vehículo
        } else if($lv_rowbud['srcobjtyp']=='LOG_VHC'){
          if(!in_array( $lv_vhc[$lv_rowbud['srcobjcod001']]['vhctxt'], $lv_vhcarr[$lv_rowbud['stecod']])){
              array_push($lv_vhcarr[$lv_rowbud['stecod']], $lv_vhc[$lv_rowbud['srcobjcod001']]['vhctxt']);
              array_push($lv_stevhc[$lv_rowbud['stecod']], $lv_vhc[$lv_rowbud['srcobjcod001']]);
          }
        }
      }
    }
  }


	//Variable para saber si hay inspector en una obra
  $lv_inspste = array();
  $lv_steemp = array();
  // EMPLEADOS. recupero la lista de asistencia
  if(strtoupper($vew_data['cnstsktyp'])!='ACERAS' || !empty($lv_stetsk)){
    $lv_ass = array();
    foreach( $vew_data['ass'] as $lv_rowass ){
    	$lv_ass[$lv_rowass['stecod'].'_'.$lv_rowass['srcobjtyp'].'_'.$lv_rowass['srcobjcod']] = 
        array('emptxt'=>$lv_rowass['srcobjtxt'],
              'taxcod'=>(isset($lv_taxemp[$lv_rowass['srcobjcod']]) ? $lv_taxemp[$lv_rowass['srcobjcod']] : ''),
              'tmestr'=>$vew_doc->getTagValue($lv_rowass['steevtdocatr'],'tmestr'),
              'tmeend'=>$vew_doc->getTagValue($lv_rowass['steevtdocatr'],'tmeend')
              );
    }
    
    // array para que no se repitan las asistencias en una obra
    $lv_assarr = array();
    // EMPLEADOS. listo empleados por obra
    foreach( $lv_steassintsk as $lv_rowbud ){ 
      if(!empty($lv_stetsk[$lv_rowbud['stecod']])){
        $lv_rowinc = isset($lv_sterowinc[$lv_rowbud['stecod']]) ? $lv_sterowinc[$lv_rowbud['stecod']] : array();
        // busco que la tarea del empleado sea ACERAS o INSPECCION según corresponda
        $lv_inc = false;
        // variable para indicar que la persona es un inspector
        $lv_insp = false;
        
        foreach( $lv_stealltsk[$lv_rowbud['stecod']] as $lv_rowbud2 ){
          if($lv_rowbud2['stecod']==$lv_rowbud['stecod'] && $lv_rowbud2['budmatrow'].'.'===substr($lv_rowbud['budmatrow'],0,strlen($lv_rowbud2['budmatrow'].'.'))){

            if($lv_rowbud2['cnstskclscodext']=='ACERAS' || !empty($lv_rowinc)){
              // Verificar que el veredista sea veredista en ESA obra y no se muestre si hace otro trabajo en otra obra o en una obra sin evento de avance
              if(strtoupper($vew_data['cnstsktyp'])=='ACERAS' && $lv_rowbud2['cnstskclscodext']=='ACERAS'){
                $lv_inc = true; 
                break; 
              }else{
                if ($lv_rowbud['srcobjtyp'] == 'HHR_EMP'){
                  $lv_inc = true; 
                  foreach($lv_rowinc as $lv_insprow){
                    if(substr($lv_rowbud2['budmatrow'],0,strlen($lv_insprow)) === $lv_insprow){
                      $lv_insp = true;
                      $lv_inspste[$lv_rowbud['stecod']] = true;
                      break 2;
                    }
                  }
                }
              }
            }
          }
        }
        
        if($lv_inc){
          if(!isset($lv_steemp[$lv_rowbud['stecod']])){
            $lv_steemp[$lv_rowbud['stecod']] = array();
          }
          if(!in_array($lv_rowbud['stecod'].'_'.$lv_rowbud['srcobjtyp'].'_'.$lv_rowbud['srcobjcod001'], $lv_assarr)){
            if(isset($lv_ass[$lv_rowbud['stecod'].'_'.$lv_rowbud['srcobjtyp'].'_'.$lv_rowbud['srcobjcod001']])){
              array_push($lv_assarr, $lv_rowbud['stecod'].'_'.$lv_rowbud['srcobjtyp'].'_'.$lv_rowbud['srcobjcod001']);
              $lv_emp = $lv_ass[$lv_rowbud['stecod'].'_'.$lv_rowbud['srcobjtyp'].'_'.$lv_rowbud['srcobjcod001']];
              $lv_emp['insp'] = $lv_insp; //No se pega directamente el string de inspector acá porque después se hace un strtolower y lo deforma
              array_push($lv_steemp[$lv_rowbud['stecod']], $lv_emp);
            }else{
              $lv_inspste[$lv_rowbud['stecod']] = false;
            }
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
		$lv_dat['emp'] = array();
    if(isset($lv_steemp[$lv_rowste['stecod']])){
    	foreach($lv_steemp[$lv_rowste['stecod']] as $lv_emp){
        $lv_dat['emp'][] = $lv_emp;
      }
    }
    $lv_insp = isset($lv_inspste[$lv_rowste['stecod']]) ? $lv_inspste[$lv_rowste['stecod']] : false;
    
    // si es una inspección y no hay inspector, no muestra la obra
    if(strtoupper($vew_data['cnstsktyp'])=='ACERAS' || $lv_insp){
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
                          '<td>'.($i<count($lv_dat['emp'])?ucwords(strtolower($lv_dat['emp'][$i]['emptxt'])).($lv_dat['emp'][$i]['insp'] ? ' (Inspector SST)' : ''):'').'</td>'.
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
	}	
	$lv_buffer .= '</table>';
	$pdf->setxy(5,30);
	$pdf->writeHTML($lv_buffer);
		
	$pdf->Output('parte_diario.pdf', 'I');	
?>
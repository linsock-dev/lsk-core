<?php
	// Include the main TCPDF library (search for installation path).
	require_once('library/plugins/phptools/tcpdf/6.7.4/tcpdf.php');

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
	$lv_grpqty = count($vew_data);

	// recorro liquidaciones
	for($i=0; $i < $lv_grpqty; $i++){
		$lv_totdeb = 0;
		$lv_totcre = 0;
      
    // abro nueva página
    $pdf->AddPage('P');

    // Encabezado
    $pdf->setfont('Courier', '', 9);
    $pdf->line( 10, 20, 200, 20 );

    //'-- nro liquidación
    //$pdf->text( 153, 13, html_entity_decode(utf8_encode($vew_lang->liquidation)).' Nº: '.substr('00000000',0,8-strlen($vew_data[$i]['hltprslqdcod'])).$vew_data[$i]['hltprslqdcod'] );
    $pdf->text( 153, 13, 'Orden de pago Nº: '.substr('00000000',0,8-strlen($vew_data[$i]['hltprslqdcod'])).$vew_data[$i]['hltprslqdcod'] );

    //'-- legajo
    $pdf->text( 35, 23, $vew_lang->legajo.':');
    $pdf->text( 70, 23, $vew_data[$i]['prscod'] . ' - Cod.Ext: ' . $vew_data[$i]['prs']['prscodext'] );

    //'-- apellido y nombre
    $pdf->text( 35, 28, $vew_lang->lastname.' '.$vew_lang->firstname );
    $pdf->text( 70, 28, substr(html_entity_decode(utf8_encode($vew_data[$i]['prs']['prstxt'])),0,43) );

    //'-- condición frente al IVA
    $pdf->text( 35, 33, html_entity_decode(utf8_encode($vew_lang->condition)).':' );
    $pdf->text( 70, 33, ($vew_data[$i]['prs']['taxcattxt']==''?'----------':$vew_data[$i]['prs']['taxcattxt']) ); 

    //'-- categorización: puntos $ (valor unitario)
    $pdf->text( 150, 23, html_entity_decode(utf8_encode($vew_lang->categorisation)).':');
    $pdf->text( 155, 28, $vew_lang->points.':');
    $pdf->text( 180, 28, ($vew_data[$i]['hltlqdcatpts']>0?$vew_data[$i]['hltlqdcatpts']:'----------') );
    $pdf->text( 155, 33, $vew_lang->price.':');
    $pdf->text( 180, 33, ($vew_data[$i]['hltlqdcatprc']>0?'$ '.$vew_data[$i]['hltlqdcatprc']:'----------') );

    //'-- linea + tabla (codigo, concepto, total honorarios, total devoluciones)
    $pdf->line( 10, 40, 200, 40 );
    $pdf->setxy( 10,45 );
    $lv_tbl = '<table  border="0" cellpadding="1" cellspacing="1">'.
                '<tr>'.
                  '<td width="90">'.utf8_encode($vew_lang->id).'</td>'.
                  '<td width="297">'.html_entity_decode(utf8_encode($vew_lang->description)).'</td>'.
                  '<td width="135" align="right">'.utf8_encode($vew_lang->fee).'</td>'.
                  '<td width="135" align="right">'.utf8_encode($vew_lang->returns).'</td>'.
                '</tr>';

    $lv_row2 = array();
    $lv_evllst = array();
    $lv_exprows = '';
    foreach($vew_data[$i]['lqddoc'] as &$lv_row) {
      if($lv_row['refobjtyp'] != 'BUY_EXP'){
        //  suma el total de todas las posiciones cuyo paciente (control o evolución) tenga el mismo id
        // el nro de sesiones es el nro de posiciones que comparten ese dato
        if ( isset($lv_row2[$lv_row['hltprslqddoccodext']]) ) {
          $lv_row2[$lv_row['hltprslqddoccodext']]['hltprslqddoctot'] += $lv_row['hltprslqddoctot'];
          $lv_row2[$lv_row['hltprslqddoccodext']]['hltprslqddocses']++;
          $lv_row2[$lv_row['hltprslqddoccodext']]['hltplnctrqtytot'] += $lv_row['hltplnctrqty'];
          $lv_row2[$lv_row['hltprslqddoccodext']]['hltplnctrtmetot'] += $lv_row['hltplnctrtme'];
        } else {
          $lv_row2[$lv_row['hltprslqddoccodext']] = 
                    array('hltprslqddoccodext'=>$lv_row['hltprslqddoccodext'],
                          'hltprslqddoctxt'=>$lv_row['hltprslqddoctxt'],
                          'hltprslqddocses'=>1,
                          'refobjcod001'=>$lv_row['refobjcod001'],
                          'hltprslqddoctot'=>$lv_row['hltprslqddoctot'],
                          'hltplnctrqtytot'=>$lv_row['hltplnctrqty'],
                          'hltplnctrtmetot'=>$lv_row['hltplnctrtme'] 
                          );
        }

        // cuenta cantidad de evoluciones agrupados por paciente y especialidad
        if($lv_row['refobjtyp'] == 'HLT_EVL'){
          if(!isset($lv_evllst[$lv_row['patcod']])){$lv_evllst[$lv_row['patcod']]=array();}
          if(!isset($lv_evllst[$lv_row['patcod']][$lv_row['spctxt']])){$lv_evllst[$lv_row['patcod']][$lv_row['spctxt']]=0;}
          $lv_evllst[$lv_row['patcod']][$lv_row['spctxt']]++;
        }
      }else{
        $lv_lnsqtalst= explode('_',($lv_row['buyexpcodext']??'') );
        //$lv_lnsqtatxt='(1/999)';
        $lv_lnsqtatxt = count($lv_lnsqtalst)>1 && $lv_lnsqtalst[1]>0?'('.$lv_lnsqtalst[1].'/'.$lv_row['hltlnsqta'].')':'';
        $lv_exprows.='<tr>'.
                      '<td>'.$lv_row['hltprslqddoccodext'].'</td>'.
                      '<td>'.html_entity_decode(utf8_encode($lv_row['hltprslqddoctxt'])).' '.$lv_lnsqtatxt.' </td>'.
                      '<td align="right">$ '.number_format($lv_row['hltprslqddoctot']>0?$lv_row['hltprslqddoctot']:0,2,',','.').'</td>'.
                      '<td align="right">$ '.number_format($lv_row['hltprslqddoctot']<0?$lv_row['hltprslqddoctot']*(-1):0,2,',','.').'</td>'.
                    '</tr>';	
      }       

      $lv_totdeb += $lv_row['hltprslqddoctot']>0?$lv_row['hltprslqddoctot']:0;
      $lv_totcre += $lv_row['hltprslqddoctot']<0?$lv_row['hltprslqddoctot']*(-1):0;
    }

    // coloca cada posición de liquidación como una fila en la tabla
    foreach($lv_row2 as $lv_row) {
      $lv_hltplnctrtxt='ses.';
      $lv_hltplnctrval=$lv_row['hltplnctrqtytot'];
      if($lv_row['hltplnctrtmetot']>0){
         $lv_hltplnctrtxt='Hs.';
      	 $lv_hltplnctrval=$lv_row['hltplnctrtmetot'];
        
      }
      $lv_tbl .= '<tr>'.
                  '<td>'.$lv_row['hltprslqddoccodext'].'</td>'.
                  //'<td>'.html_entity_decode(utf8_encode($lv_row['hltprslqddoctxt'])).' ('.$lv_row['hltprslqddocses'].' ses.)</td>'.
        					'<td>'.html_entity_decode(utf8_encode($lv_row['hltprslqddoctxt'])).' ('.$lv_hltplnctrval.' '. $lv_hltplnctrtxt .')</td>'.
                  '<td align="right">$ '.number_format($lv_row['hltprslqddoctot'],2,',','.').'</td>'.
                  '<td align="right">$ 0.00</td>'.
                '</tr>';
			/*
      if($lv_row['hltprslqddocses']>1){
        $lv_tbl .= '<tr style="font-size: 10px;"><td colspan="0"></td><td><b>Especialidades:</b> </td></tr>';
        if(isset($lv_evllst[$lv_row['hltprslqddoccodext']])){
          foreach($lv_evllst[$lv_row['hltprslqddoccodext']] as $lo_keyevl=>$lo_valevl){
              // muestra cantidad de evoluciones por especialidad
              $lv_tbl .= '<tr style="font-size: 8px;"><td colspan="0"></td><td>'.$lo_keyevl.' ('.$lo_valevl.')'.'</td></tr>';
          }
        }else{
          $lv_tbl .= '<tr style="font-size: 8px;"><td colspan="0"></td><td><b>No se puede obtener las evoluciones</b></td></tr>';
        }
      }
      */
    }   

    $lv_tbl .= $lv_exprows.'</table>';
    $pdf->setxy( 10, 45);
    $pdf->writeHTML($lv_tbl);


    //'--  linea + subtotal + total
    $lv_posy = $pdf->gety();
    $pdf->line( 10, ($lv_posy<195?195:$lv_posy), 200, ($lv_posy<195?195:$lv_posy));
    $pdf->line( 130, ($lv_posy<196?196:$lv_posy), 200, ($lv_posy<196?196:$lv_posy));
    $pdf->setxy( 10, ($lv_posy<197?197:$lv_posy));
    $pdf->setFont( 'Courier', 'B' );
    $lv_tot = $lv_totdeb-$lv_totcre;
    $lv_tbl = '<table border="0" cellpadding="3" cellspacing="3">'.
                '<tr>'.
                	'<td width="200"></td>'. 
                  '<td width="187" align="right">'.$vew_lang->subtotal.'</td>'.
                  '<td width="135" align="right">$ '.number_format($lv_totdeb,2,',','.').'</td>'.
                  '<td width="135" align="right">$ '.number_format($lv_totcre,2,',','.').'</td>'.
                '</tr>'.
                '<tr>'.
                    '<td width="200"></td>'.
                  '<td width="187" align="right">'.$vew_lang->total.'</td>'.
                  '<td width="135" align="right">'.($lv_tot>0?'$ '.number_format($lv_tot,2,',','.'):'').'</td>'.
                  '<td width="135" align="right">'.($lv_tot<0?'$ '.number_format($lv_tot,2,',','.'):'').'</td>'.
                '</tr>'.
              '</table>';
    $pdf->writeHTML($lv_tbl);

    //'-- linea + total a cobrar + tabla con importe neto a pagar
    $pdf->line( 10, $pdf->gety()-5, 200, $pdf->gety()-5 );
    $pdf->setxy( 10, $pdf->gety()-5 );
    $pdf->setFont( 'Courier', 'B' );
    $lv_tbl = '<table border="0" cellpadding="3" cellspacing="3">'.
                '<tr>'.
                  '<td width="387" align="left" colspan="2">'.strtoupper($vew_lang->totalreceivables).'</td>'.
                '</tr>'.
                '<tr>'.
                  '<td width="522" align="left">'.strtoupper($vew_data[$i]['hltprslqdtxt']).'</td>'.
                  '<td width="135" align="right">$ '.number_format($lv_tot,2,',','.').'</td>'.
                '</tr>'.
              '</table>';
    $pdf->writeHTML($lv_tbl);

    //'-- linea + medio de pago + tabla de pagos
    $pdf->line( 10, $pdf->gety()-5, 200, $pdf->gety()-5 );
    
    $pdf->setxy( 10, $pdf->gety()-3);
    $lv_tbl = '<table border="0" cellspacing="3">'.
      					(!$vew_data[$i]['prs']['paymthtxt']?'':
                '<tr>'.
                	'<td width="500" align="left">'.strtoupper($vew_lang->PAYMENTMETHODS).' </td>'.
                '</tr>'.
                '<tr>'.
                	'<td width="500" align="left">'.$vew_data[$i]['prs']['paymthtxt'].' '.html_entity_decode(utf8_encode($vew_data[$i]['prs']['bnktxt']??'')).
                 		(!$vew_data[$i]['prs']['bnkbch']?'':', Suc. '.$vew_data[$i]['prs']['bnkbch']).
                 		(!$vew_data[$i]['prs']['bnkaccnum']?'':', N° Cta '.$vew_data[$i]['prs']['bnkaccnum']).
                 		(!$vew_data[$i]['prs']['bnkacccbu']?'':', CBU '.$vew_data[$i]['prs']['bnkacccbu']).
                 		(!$vew_data[$i]['prs']['bnkacctyp']?'':', Cta Tpo '.(strtoupper($vew_data[$i]['prs']['bnkacctyp'])=='CA'?'CAJA DE AHORROS': (strtoupper($vew_data[$i]['prs']['bnkacctyp'])=='CC'?'CUENTA CORRIENTE':''))).
                 		(!$vew_data[$i]['prs']['idttyptxt']?'':', '.$vew_data[$i]['prs']['idttyptxt'].' '.$vew_data[$i]['prs']['taxiibb']).
      						'</td>'.
                '</tr>').
      					(!$vew_data[$i]['prs']['taxcod']?'':
                '<tr>'.
                    '<td width="500" align="left">CUIT: '.$vew_data[$i]['prs']['taxcod'].' </td>'.
                '</tr>').
              '</table>';
    $pdf->writeHTML($lv_tbl);

    //'-- firmas
    $pdf->setxy( 10, $pdf->gety()+10);
    $lv_tbl = '<table border="0">'.
                '<tr>'.
                  '<td width="90"></td>'.
                  '<td width="200" align="center">..........................</td>'.
                  '<td width="100"></td>'.
                  '<td width="200" align="center">..........................</td>'.
                '</tr>'.
                '<tr>'.
                  '<td></td>'.
                  '<td align="center">'.$vew_lang->authorizedby.'</td>'.
                  '<td></td>'.
                  '<td align="center">'.substr(html_entity_decode(utf8_encode($vew_data[$i]['prs']['prstxt'])),0,25).'</td>'.
                '</tr>'.
              '</table>';
    $pdf->writeHTML($lv_tbl);
  }
	//'-- legajo
    $pdf->text( 175, 268, 'AF-PR-01.FO-09'); // mas de 268 no va, se pasa de hoja
	//Close and output PDF document
	$pdf->Output('example_002.pdf', 'I');	
?>
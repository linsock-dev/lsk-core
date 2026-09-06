<?php 
	if($vew_data->nevl!=''){ 
    $vew_data->evlcod='';
    $vew_data->plnid='';
    $vew_data->plndteid='';  
    $lv_dockey ='';
    $vew_actcod='01';
  } else {
		$vew_actcod = ($vew_data->evlcod!=''?'03':'02');
	}
//	var_dump($vew_data->frmdtestr);
 // var_dump($vew_data->frmdteend);

	if($vew_data->frmdteva!=''){
    $vew_actcod='00';
  }

	// url del formulario
  $lv_lnk = '?prg=zcutp1_tpe&prm_evlfrm='.$vew_evlfrm.'&prm_evlcod='.$vew_data->evlcod;

	// clave del documento
	$lv_dockey = $vew_data->evlcod;

	// titulo
	$lv_title = $vew_lang->document;

	// modulo y programa
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'TP1';
	//echo '<code>@';	var_dump($vew_data->evl->evlatr001); echo '@</code>';
	$persnd=false;
	$perdelsnd= false;
	$lv_evlDte= $lv_dockey?$vew_data->evl->evldte:$vew_data->plndte->plndte;
  $dteNow = new DateTime();
	$dteDif = (int) ($dteNow->diff($lv_evlDte)->format('%r%a'));

	if ($vew_data->evlcod=='') {
		$vew_data->evlinfprc = '';
	}else{
    $lv_evlatrval001=strtoupper($vew_data->evl->evlatr001);
    $apiSendOk=$vew_doc->getTagValue($lv_evlatrval001,'apisendok')=='1';
    $apiSendDelOk=$vew_doc->getTagValue($lv_evlatrval001,'apisenddelok')=='1';
    $vew_data->msjdisp = strtoupper($vew_doc->getTagValue($lv_evlatrval001,'msjdisp'));
    if(!$apiSendOk){
      if((in_array("COOR_OSDE",$vew_data->usrgrplst) &&  abs($dteDif) <=60) ||  $vew_data->usrcod=='grusso' || $vew_data->usrcod = 'cdominguez' || $vew_data->usrcod == 'fbeitia'){
        $persnd=true;
      }
      /*
      if ($vew_doc->getTagValue($lv_evlatrval001,'rtaadic')!='08' && $vew_doc->getTagValue($lv_evlatrval001,'rtaadic')!='00') {
        if(in_array("COOR_OSDE",$vew_data->usrgrplst) &&  abs($dteDif) <=60 ){//if(in_array("COOR_OSDE",$vew_data->usrgrplst) && ($lv_evlDte->format('Y') === $dteNow->format('Y') &&  $lv_evlDte->format('m') === $dteNow->format('m'))){
          $persnd=true;
        }
      }
      
      */
    }
    if($apiSendOk && !$apiSendDelOk){
      if((in_array("COOR_OSDE",$vew_data->usrgrplst) &&  abs($dteDif) <=60) ||  $vew_data->usrcod=='grusso' || $vew_data->usrcod = 'cdominguez' || $vew_data->usrcod == 'fbeitia'){
        $perdelsnd=true;
      }
      
    }
    
    
	 	$vew_data->evlinfprc = strtoupper($vew_doc->getTagValue($lv_evlatrval001,'evlinfprc'));
    $vew_data->evlcncmtv=strtoupper($vew_doc->getTagValue($lv_evlatrval001,'evlcncmtv'));;
    
	 	if ($vew_data->evlinfprc ==''){
	 		if ($vew_data->docsts=='A') {
				$vew_data->evlinfprc = '1';
			}	else{
	 			$vew_data->evlinfprc = '0';
	 		}
	 	}
	}

	$lv_reqfld = array();
  switch(strtoupper($vew_evlfrm)){
    case 'AKR': $lv_reqfld = array('evlaus', 'mantor', 'esttos', 'drepos', 'ejsres', 'aspsec'); break;
    case 'FONO': $lv_reqfld = array('juepsi', 'atnlen', 'bascom', 'esttem', 'comalt', 'mecemi', 'estsen', 'traneu'); break;
    case 'KINMOTO': $lv_reqfld = array('evlmot', 'ejact', 'trapos', 'marcha', 'estmot', 'mov', 'bid'); break;
    case 'ESTTEM': $lv_reqfld = array('evlpsi', 'estsen', 'estpsi', 'estvis'); break;
    case 'TERDEG': $lv_reqfld = array('movlin', 'praoro', 'tecali', 'esttem', 'refsuc'); break;
    case 'TEROCU': $lv_reqfld = array('movsup', 'estcog', 'hablud', 'motfin', 'graesc', 'habhig'); break;
    case 'ENF': $lv_reqfld = array('evlcnccmt','tas','tad', 'fc', 'fr', 'tmp', 'spo2', 'evlevl'); break;
    case 'MED': $lv_reqfld = array('evlcnccmt', 'evlevl'); break;   
  }

	// campos requeridos
	$vew_input->RequiredFields( $lv_reqfld );

	// librer?a de estilos bootstrap
	include_once('_library.frm');
	/* config nav */
	//$vew_tbl['clsR'] = array('per'=> ($vew_hhcc!='X') );
	$vew_tbl['clsL'] = array('pos'=>'L','per'=>($vew_hhcc=='X'), 'ttl'=>$vew_lang->close, 'id'=>'btncls','icn'=>'fas fa-arrow-left', 'css'=>'btn navbar-btn tmss-navbar-btn arrow-left', 'acc'=>$lv_sec.'_fncbckext();');

	$vew_tbl['sveL'] = array('acc'=>$lv_sec.'_fncGeo({action: '.chr(39).'evlsoekin00'.chr(39).'});' );
	$vew_tbl['sveR'] = array('acc'=>$lv_sec.'_fncGeo({action: '.chr(39).'evlsoekin00'.chr(39).'});' );
	$vew_tbl['rfrsh'] = array('id'=>'', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlsoekin01'.chr(39).'});', 'css'=>'tmss-Opt', 'icn'=>'fas fa-sync-alt', 'ttl'=>$vew_lang->refresh, 'per'=>true, 'pos'=>'');
	$vew_tbl['newL'] = array('pos'=>'L','per'=>$vew_data->frmdteva=='' && $vew_sec->hasPermission('HLT','EVL','01') && $vew_readonly && ($vew_hhcc!='X'), 'ttl'=>$vew_lang->new, 'id'=>'','icn'=>'fas fa-file-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlsoekin'.chr(39).'});' );
	$vew_tbl['newR'] = array('pos'=>'R','per'=>$vew_data->frmdteva=='' && $vew_sec->hasPermission('HLT','EVL','01') && $vew_readonly && ($vew_hhcc!='X') , 'ttl'=>$vew_lang->new, 'id'=>'','icn'=>'fas fa-file-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit  tmss-mob-btn', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlsoekin'.chr(39).'});' );
	$vew_tbl['del'] = array('per'=>$vew_sec->hasPermission('HLT','EVL','04') && $vew_readonly, 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlsoekin04'.chr(39).'});' );
	if($persnd){
  	$vew_tbl['sndL'] = array_merge($vew_tbl['newL'],array('per'=>true,'pos'=>'L','ttl'=>'Inf. Osde','acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlinfosd'.chr(39).'});','icn'=>'fas fa-paper-plane' ));  
  }else if($perdelsnd){
  	$vew_tbl['sndL'] = array_merge($vew_tbl['newL'],array('per'=>true,'pos'=>'L','ttl'=>'Anular Osde','acc'=>$lv_sec.'_fnc({action: '.chr(39).'delinfosd'.chr(39).'});','icn'=>'fa-solid fa-xmark fa-xl' ));  
  }
	
	
	// calculo edad
	
	if($vew_data->pat->per->perbrndte!=''){
    $lv_birthdate = $vew_data->pat->per->perbrndte->format('d-m-Y');
    $lv_age = date_diff(date_create($lv_birthdate), date_create(date('Y-m-d')));
    $lv_agestr = ($lv_age->y>0?$lv_age->y.' '.$vew_lang->years:'').($lv_age->y<5 && $lv_age->m>0?' '.$lv_age->m.' '.$vew_lang->months:'').($lv_age->y<1?' '.$lv_age->d.' '.$vew_lang->days:'');
  }else{
    $lv_birthdate = '';
    $lv_agestr = '';
  }

	// selecciono dato de peso y altura
	$lv_atr = $lv_dockey ? html_entity_decode($vew_data->evl->evlatr001) : '';
	$lv_wgt = $lv_dockey ? $this->co_reg->document->getTagValue($lv_atr,'patwgt') : $vew_data->pat->patwgt;
	$lv_hgh = $lv_dockey ? $this->co_reg->document->getTagValue($lv_atr,'pathgh') : $vew_data->pat->pathgh;
  $vew_data->evllon=strtoupper($vew_doc->getTagValue($lv_atr,'evllon'));
  $vew_data->evllat=strtoupper($vew_doc->getTagValue($lv_atr,'evllat'));
	$vew_data->apinroref=strtoupper($vew_doc->getTagValue($lv_atr,'apinroref'));
	$vew_data->seccod=strtoupper($vew_doc->getTagValue($lv_atr,'seccod'));
	$vew_data->rtaadic=strtoupper($vew_doc->getTagValue($lv_atr,'rtaadic'));
	$vew_data->msjdisp=strtoupper($vew_doc->getTagValue($lv_atr,'msjdisp'));
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm');?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml( 'atr' , 'hidden', $lv_atr ); ?>
    <?= gethtml( 'evlatr001' , 'hidden', '' ); ?>
		<?= gethtml( 'tmss_actcod' , 'hidden', '' ); ?>
    <?= gethtml( 'sysdocclscod' , 'hidden', $vew_data->sysdoccls->sysdocclscod ); ?>
    <?= gethtml( 'patcod' , 'hidden', $vew_data->pat->patcod ); ?>
    <?= gethtml( 'prscod' , 'hidden', $vew_data->prscod ); ?>
    <?= gethtml( 'spccod' , 'hidden', $vew_data->spccod ); ?>
    <?= gethtml( 'delcod' , 'hidden', $vew_data->delcod ); ?>
    <?= gethtml( 'plnid' , 'hidden', $vew_data->plnid ); ?>
    <?= gethtml( 'plndteid' , 'hidden', $vew_data->plndteid ); ?>
    <?= gethtml( 'nevl' , 'hidden', '' ); ?>
    <?= gethtml( 'hhcc' , 'hidden', $vew_hhcc  ); ?>
    <?= gethtml( 'apinroref' , 'hidden', $vew_data->apinroref ); ?>
    <?= gethtml( 'evllat' , 'hidden', $vew_data->evllat ); ?>
    <?= gethtml( 'evllon' , 'hidden', $vew_data->evllon ); ?>
    <?= gethtml( 'cuscod' , 'hidden', $vew_data->pat->cuscod ); ?>
    <?= gethtml( 'matplncmt' , 'hidden', $vew_data->pat->matplncmt ); ?>
    <?= gethtml( 'osdeord' , 'hidden', $vew_data->pat->osdeord ); ?>
    <?= gethtml( 'msjdisp' , 'hidden', $vew_data->msjdisp ); ?>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $lv_dockey; ?><?= gethtml( 'evlcod' , 'hidden', $lv_dockey ); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          
           <!-- DATOS PACIENTE -->
					<div class="row <?=($vew_data->frmdteva==''?'hidden':'')?>">
						<div class="col-md-12">
							<div class="alert alert-danger" role="alert"><strong>Atencion!!! </strong><br><?=$vew_data->txterrfrm;?></div>
						</div>
          </div> <!-- DATOS PACIENTE --> 
          
					<div class="row"><!-- DATOS PACIENTE -->
						<div class="col-md-12">
							<div class="card">
								<div class="card-header"><div class="card-title">Datos del paciente</div></div>
								<div class="card-body">
									<?php
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->DIAGNOSTIC, 
                                                     'input'=>gethtml('evldia', 'doccmt4x50', $vew_data->pat->evldia, $lv_always_disabled) ) );
                  	echo vew_boot($lv_col2424, array('label1'=>$vew_lang->BIRTHDATE, 
                                                     'input1'=>gethtml('perbrndte', 'docdte', $vew_data->pat->per->perbrndte, $lv_always_disabled), 
                                                     'label2'=>$vew_lang->age,	
                                                     'input2'=>gethtml('patage', 'doccmt1x20',	$lv_agestr, $lv_always_disabled ) ));
                  	echo vew_boot($lv_col222222, array('label1'=>$vew_lang->weight.' (kg)', 
                                                     'input1'=>gethtml('patwgt', 'docnum0603', $lv_wgt, $lv_default), 
                                                     'label2'=>$vew_lang->HEIGHT.' (cm)',	
                                                     'input2'=>gethtml('pathgh', 'docnum0603',	$lv_hgh, $lv_default ),
                                                     'label3'=>'IMC', 
                                                     'input3'=>gethtml('evlimc', 'docprctot', '', $lv_always_disabled) ));
									?>
								</div><!-- fin card-body-->
							</div> <!-- fin card-->
						</div><!-- fin col-md-12-->
          </div> <!-- DATOS PACIENTE -->
          
          <!-- EVOLUCION -->
          <div class="row">
						<div class="col-md-12">
              <div class='card'>
								<div class="card-header"><div class="card-title">Datos de evoluci&oacute;n</div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                  	//$lv_evlDte= $lv_dockey?$vew_data->evl->evldte:$vew_data->plndte->plndte;//$lv_dockey?$vew_data->evl->evldte::date('d/m/Y');
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('evldte', 'docdte', $lv_evlDte, $lv_always_disabled)));
                  	echo vew_boot(array($lv_colsm210, $lv_colxs48),array('label'=>'Se realiz&oacute;', 'input'=>gethtml('evlinfprc','checkbox',$vew_data->evlinfprc,$lv_default) ));
                  ?>
                  <div id='evlcncmtvgrp'>
                  <hr>
                    <?php 
                    echo vew_boot($lv_col210,array('label'=>$vew_lang->motive,
                                                   'input'=>gethtml('evlcncmtv',$vew_data->evlcncmtvlst,
                                																		$vew_data->evlcncmtv,
                                                    								$lv_default) 
                                                  ));
                    ?>
                  </div>
                	<?php 
                  /*

                    echo vew_boot($lv_col210,array('label'=>$vew_lang->comments, 'input'=>gethtml('evlcnccmt','doccmt5x50',$vew_data->evlcnccmt,$lv_default) ));              
                  */
                  ?>
                  
                </div><!--fin card-body -->
              </div> <!--fin card-->
              
              <div class='card'>
              	<div class="card-body tmss-card-body-edit">
                  <div class="card-title" id="evlcnccmtttl"><?= $vew_lang->SUBJETIVE; ?></div>
                  <div data-attr>
                  	<?= vew_boot($lv_col210, array('label'=>'', 'input'=>gethtml('evlcnccmt', 'doccmt5x50', $this->co_reg->document->getTagValue($lv_atr,'evlcnccmt'), $lv_default))); ?>
                	</div>
              </div><!--fin card-body -->
              </div> <!--fin card-->
              
							<div class="card" id="evlcard"> <!-- datos de evolucion-->
								<div class="card-body tmss-card-body-edit">
                  <!-- <div class="card-title">API</div> -->

                  <div class="card-title"><?= $vew_lang->OBJECTIVE; ?></div>  
                  <div data-attr>
                  <?php
                  	echo vew_boot($lv_col2424, array('label1'=>'TA Sist&oacutelica',	
                                                     'input1'=>gethtml('tas', 'docrngnum',	$this->co_reg->document->getTagValue($lv_atr,'tas'), $lv_default), 
                                                     'label2'=>'TA Diast&oacutelica', 
                                                     'input2'=>gethtml('tad', 'docrngnum', $this->co_reg->document->getTagValue($lv_atr,'tad'), $lv_default ) ));
                  	echo vew_boot($lv_col2424, array('label1'=>'Frec. Card&iacute;aca', 
                                                     'input1'=>gethtml('fc', 'docrngnum', $this->co_reg->document->getTagValue($lv_atr,'fc'), $lv_default), 
                                                     'label2'=>'Frec. Respiratoria',	
                                                     'input2'=>gethtml('fr', 'docrngnum',	$this->co_reg->document->getTagValue($lv_atr,'fr'), $lv_default ) ));
                  	echo vew_boot($lv_col2424, array('label1'=>'Temperatura', 
                                                     'input1'=>gethtml('tmp', 'docprctot', $this->co_reg->document->getTagValue($lv_atr,'tmp'), $lv_default), 
                                                     'label2'=>'SpO2',	
                                                     'input2'=>gethtml('spo2', 'docrngnum',	$this->co_reg->document->getTagValue($lv_atr,'spo2'), $lv_default ) ));
                    if(strtoupper($vew_evlfrm)=='ENF'){
                    echo vew_boot($lv_col2424, array('label1'=>'Glucemia', 
                                                     'input1'=>gethtml('glu', 'docrngnum', $this->co_reg->document->getTagValue($lv_atr,'glu'), $lv_default)) );
                    }
                  ?>
                  </div>
                  <hr>
                  <div class="card-title"><?= $vew_lang->evolution; ?></div>
                  <?php
                  $lv_opt = array();
                  switch(strtoupper($vew_evlfrm)){
                    case 'AKR':
                      $lv_opt = array(array('atr'=>'evlaus', 'txt'=>'Evaluaci&oacute;n/Auscultaci&oacute;n'), 
                                      array('atr'=>'mantor', 'txt'=>'Maniobras Tor&aacute;cicas'), 
                                      array('atr'=>'esttos', 'txt'=>'Estimulaci&oacute;n de Tos'), 
                                      array('atr'=>'drepos', 'txt'=>'Drenaje Postural'), 
                                      array('atr'=>'ejsres', 'txt'=>'Ejercicios Respiratorios'), 
                                      array('atr'=>'aspsec', 'txt'=>'Aspiraciones de Secreciones'),
                                      array('atr'=>'actter', 'txt'=>'Se monitoriza actividad terapeutica'));
                      break;
                    case 'FONO':
                      $lv_opt = array(array('atr'=>'juepsi', 'txt'=>'Juego Psicomotor'), 
                                      array('atr'=>'atnlen', 'txt'=>'Atenci&oacute;n Lenguaje'), 
                                      array('atr'=>'bascom', 'txt'=>'Base Comunicativa'),
                                      array('atr'=>'esttem', 'txt'=>'Estimulaci&oacute;n Termo T&aacute;ctil'), 
                                      array('atr'=>'comalt', 'txt'=>'Comunicaci&oacute;n Alternativa'),
                                      array('atr'=>'mecemi', 'txt'=>'Mecanismos de Emisi&oacute;n'), 
                                      array('atr'=>'estsen', 'txt'=>'Estimulaci&oacute;n Sensorial'),
                                      array('atr'=>'traneu', 'txt'=>'Tratamiento Neuroling&uuml;istico'),
                                      array('atr'=>'actter', 'txt'=>'Se monitoriza actividad terapeutica'));
                      break;
                    case 'KINMOTO':
                      $lv_opt = array(array('atr'=>'evlmot', 'txt'=>'Evaluaci&oacute;n Motora'), 
                                      array('atr'=>'ejact', 'txt'=>'Ejercitaci&oacute;n Activa'), 
                                      array('atr'=>'trapos', 'txt'=>'Trabajo Postural'),
                                     	array('atr'=>'marcha', 'txt'=>'Marcha'), 
                                      array('atr'=>'estmot', 'txt'=>'Estimulaci&oacute;n Motora'), 
                                      array('atr'=>'mov', 'txt'=>'Movilizaciones'), 
                                      array('atr'=>'bid', 'txt'=>'Bidepestaci&oacute;n'),
                                      array('atr'=>'actter', 'txt'=>'Se monitoriza actividad terapeutica'));
                      break;
                    case 'ESTTEM':
                      $lv_opt = array(array('atr'=>'evlpsi', 'txt'=>'Evaluaci&oacute;n Psicomotora'), 
                                      array('atr'=>'estsen', 'txt'=>'Estimulaci&oacute;n Sensorial'),
                                      array('atr'=>'estpsi', 'txt'=>'Estimulaci&oacute;n Psicomotora'), 
                                      array('atr'=>'estvis', 'txt'=>'Estimulaci&oacute;n Visual'),
                                      array('atr'=>'actter', 'txt'=>'Se monitoriza actividad terapeutica'));
                      break;
                    case 'TERDEG':
                      $lv_opt = array(array('atr'=>'movlin', 'txt'=>'Movimiento Linguales'), 
                                      array('atr'=>'praoro', 'txt'=>'Praxias oro-faciales'), 
                                      array('atr'=>'tecali', 'txt'=>'T&eacute;cnica Alimentaria'),
                                      array('atr'=>'esttem', 'txt'=>'Estimulaci&oacute;n Termo T&aacute;ctil'), 
                                      array('atr'=>'refsuc', 'txt'=>'Reflejo Succi&oacute;n'),
                                      array('atr'=>'actter', 'txt'=>'Se monitoriza actividad terapeutica'));
                      break;
                    case 'TEROCU':
                      $lv_opt = array(array('atr'=>'movsup', 'txt'=>'Movilizaci&oacute;n de Miembros Superiores'), 
                                      array('atr'=>'estcog', 'txt'=>'Estimulaci&oacute;n Cognitiva'),
                                     	array('atr'=>'hablud', 'txt'=>'Habilidades L&uacute;dicas'), 
                                      array('atr'=>'motfin', 'txt'=>'Motricidad Fina'), 
                                      array('atr'=>'graesc', 'txt'=>'Grafo Escritura'),
                                     	array('atr'=>'habhig', 'txt'=>'H&aacute;bitos de Higiene y Aseo'),
                                      array('atr'=>'actter', 'txt'=>'Se monitoriza actividad terapeutica'));
                      break;      
                  }
                  
                  if(count($lv_opt)){
                    $lv_chk = '';
                    for($i=0; $i<count($lv_opt); $i=$i+2){
                      if(count($lv_opt)-$i>1){
                        $lv_chk .= vew_boot( array($lv_col4242, $lv_colsm4242, $lv_colxs9393), array('label1'=>$lv_opt[$i]['txt'],  
                                                                'input1'=>gethtml($lv_opt[$i]['atr'], 'checkbox', $this->co_reg->document->getTagValue($lv_atr, $lv_opt[$i]['atr']) ? 'on' : 'off',  $lv_default),
                                                               	'label2'=>$lv_opt[$i+1]['txt'],  
                                                                'input2'=>gethtml($lv_opt[$i+1]['atr'], 'checkbox', $this->co_reg->document->getTagValue($lv_atr, $lv_opt[$i+1]['atr']) ? 'on' : 'off',  $lv_default))); 
                      }else{
                        $lv_chk .= vew_boot( array($lv_col4242, $lv_colsm4242, $lv_colxs9393), array('label1'=>$lv_opt[$i]['txt'],  
                                                                'input1'=>gethtml($lv_opt[$i]['atr'], 'checkbox', $this->co_reg->document->getTagValue($lv_atr, $lv_opt[$i]['atr']) ? 'on' : 'off',  $lv_default),
                                                               	'label2'=>'',  
                                                                'input2'=>''));
                      }
                    }
                    echo '<div data-attr>'.$lv_chk.'</div>';
                  }else{
                		echo vew_boot($lv_col210, array('label'=>'', 
                                                    'input'=>gethtml('evlevl', 'doccmt5x50', $lv_dockey ? $vew_data->evl->evlevl : '', $lv_default) ) );
                  }
                  ?>
                  <br>
								</div> <!-- fin body -->
							</div> <!-- fin card Datos de evolucion-->
              <div class="card" id="evlseccar"> <!-- datos de evolucion-->
								<div class="card-body tmss-card-body-edit">
                  <?= vew_boot($lv_col2424, array('label'=>'Cod. de seguridad', 'input'=>gethtml('seccod', 'doccmt1x50', $vew_data->seccod, $lv_default)));?>
                  <small>
                  	
                  	<?=$vew_data->rtaadic . ' : ' .$vew_data->msjdisp ;//vew_boot($lv_col2424, array('label'=>'Mensaje', 'input'=>gethtml('msj', 'doccmt1x50', $vew_data->rtaadic . ':' .$vew_data->msjdisp  , $lv_default)));?>
                  </small>
                </div>
              </div>
						</div> <!-- fin col-md-12 -->
					</div> <!-- fin row -->
				</div> <!-- fin tab001 -->
				
			</div> <!-- tabcontent -->
		</div> <!-- container-fluid -->
  </form>
  <script>
    $(function(){
      $("#<?= $lv_sec; ?> #tad").attr("step", 1);
      $("#<?= $lv_sec; ?> #tas").attr("step", 1);
      $("#<?= $lv_sec; ?> #fc").attr("step", 1);
      $("#<?= $lv_sec; ?> #fr").attr("step", 1);
      $("#<?= $lv_sec; ?> #tmp").attr("step", 0.10);
      $("#<?= $lv_sec; ?> #spo2").attr("step", 1);
      $("#<?= $lv_sec; ?> #glu").attr("step", 0.10);
      $("#<?= $lv_sec; ?> #evlcnccmt").attr("maxlength", 3000);
      $("#<?= $lv_sec; ?> #evlevl").attr("maxlength", 3000);
      vewFormData();
      //$("#<?php echo $lv_sec; ?> #evlinfprc").trigger("change");
      $("#<?= $lv_sec; ?> #patwgt").trigger("focusout");
      if ("geolocation" in navigator) {
        navigator.geolocation.getCurrentPosition(onSucccess, onError, config );
      } else {
          alert("el navegador no soporta la geolocalización");
      }
      disabeToggleactter();
    });  
  </script>
  <script>
  function vewSecurityCode(){ 
    const inputFecha = document.querySelector("#<?= $lv_sec; ?> #evldte")
    const inputSecCod = document.querySelector("#<?= $lv_sec; ?> #evlseccar")
    const valEvlDte = inputFecha.value;
    lv_dte =valEvlDte.split("/");
    const lv_evldte = new Date(Date.parse(lv_dte[2] + "-" + lv_dte[1] + "-" + lv_dte[0] + " 00:00"));
    //const lv_evldte = new Date(inputFecha);
    const fechaActual = new Date();
    // Establecer la hora de ambas fechas a 00:00:00 para comparar solo la fecha
    lv_evldte.setHours(0, 0, 0, 0);
    fechaActual.setHours(0, 0, 0, 0);

    // Comparar las fechas
    inputSecCod.classList.remove('hidden')
    if (lv_evldte.getTime() != fechaActual.getTime()) {
        //alert("La fecha ingresada distinta a la actual.");
        inputSecCod.classList.add('hidden')
    }
  }
    
  function disabeToggleactter() {
    //var lv_actter = document.querySelector("#<?php echo $lv_sec; ?> [name='actter']");
    if(lo_actter.checked){
      $("#<?php echo $lv_sec; ?> [name='actter']").trigger("click") 
    }
  }
  </script>
  <?php
  if(count($lv_opt)){
  ?>
  <script>
    var lo_actter = document.querySelector("#<?php echo $lv_sec; ?> [name='actter']");
    function enableToggle() {
          <?php
          foreach($lv_opt as $lv_row){
            if($lv_row['atr']!='actter'){
          ?>
              var lo_<?=$lv_row['atr'];?> = document.querySelector("#<?php echo $lv_sec; ?> [name='<?=$lv_row['atr'];?>']");
              if(lo_<?=$lv_row['atr'];?>.checked){
                //lo_evlaus.checked = false;
              	$("#<?php echo $lv_sec; ?> [name='<?=$lv_row['atr'];?>']").trigger("click");
                //$("#<?php echo $lv_sec; ?> [name='<?=$lv_row['atr'];?>']").prop('readonly', true);
        			}
      				//else{
              //   $("#<?php echo $lv_sec; ?> [name='<?=$lv_row['atr'];?>']").prop('readonly', false);
              //}
          <?php
            }
          }
          ?>
    }
   
    
    lo_actter.addEventListener("change", enableToggle);
    var lo_chklst = document.querySelectorAll("#<?php echo $lv_sec; ?> input[type='checkbox']");
    lo_chklst.forEach(function(input) {
      if(input.name !='actter'){ 
      	input.addEventListener("change", disabeToggleactter);
      }
    });
  </script>
  <?php  
  }
  ?>
  <script>
     function	vewFormData(){
        
       	vewSecurityCode()
        lv_evlinfprc = document.querySelector("#<?php echo $lv_sec; ?> #evlinfprc"); //$("#<?php echo $lv_sec; ?> #evlinfprc");
        if (lv_evlinfprc.checked) {
          console.log('Se realizo')
          $("#<?php echo $lv_sec; ?> #evlcncmtvgrp").addClass("hidden");
          $("#<?php echo $lv_sec; ?> #evlcard").removeClass("hidden");
          $("#<?php echo $lv_sec; ?> #evlcnccmtttl").text("<?= $vew_lang->SUBJETIVE;?>") 
        }else {
          console.log('No se realizo')
          $("#<?php echo $lv_sec; ?> #evlcncmtvgrp").removeClass("hidden");
          $("#<?php echo $lv_sec; ?> #evlcard").addClass("hidden");
          $("#<?php echo $lv_sec; ?> #evlcnccmtttl").text("<?= $vew_lang->COMMENTS;?>")
        }
      }
    // se ejecuta si los permisos son concedidos y se encuentra una ubicación
    function onSucccess(position) {
      var output = document.getElementById("geomap");
      console.log(position.coords.latitude, position.coords.longitude);
      lv_lat=position.coords.latitude;
      lv_lon= position.coords.longitude;
      $("#<?php echo $lv_sec; ?> #evllat").attr("value",lv_lat);
      $("#<?php echo $lv_sec; ?> #evllon").attr("value",lv_lon);

    }
    //se ejecuta si el permiso fue denegado o no se puede encontrar una ubicación
    function onError() {
      
      console.log("ocurrio un error o no hay permisos para ver la ubicación");
    }

    var config = {
      enableHighAccuracy: true, 
      maximumAge        : 30000, 
      timeout           : 27000
    };
    

    
    // cálculo de imc
  	$("#<?= $lv_sec; ?> #patwgt, #<?= $lv_sec; ?> #pathgh").on("focusout", function(e){ 
      var lv_wgh = $("#<?= $lv_sec; ?> #patwgt").val();
      var lv_hgt = $("#<?= $lv_sec; ?> #pathgh").val();
      if(lv_wgh && lv_hgt && !isNaN(lv_wgh) && !isNaN(lv_hgt)){
        lv_wgh = parseFloat(lv_wgh);
        lv_hgt = parseFloat(lv_hgt)/100;
        $("#<?= $lv_sec; ?> #evlimc").val(Math.round(lv_wgh*100/(lv_hgt*lv_hgt))/100);
      }else{
        $("#<?= $lv_sec; ?> #evlimc").val("");
      }
    });
  </script>

  <script>
  	tmssLoadScript("toggle",function(){
			$("#<?php echo $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: "success", offstyle: "default", on: "Si", off: "No", size: "small" });
				$(this).trigger("change");
			});
		});
  </script>	
  
  <script>
    $("#<?php echo $lv_sec; ?> #evlinfprc").on("change",function(e){
      /*
      
      if ($(this).is(":checked")) {
        console.log('Se realizo')
        $("#<?php echo $lv_sec; ?> #evlcncmtvgrp").addClass("hidden");
        $("#<?php echo $lv_sec; ?> #evlcard").removeClass("hidden");
        $("#<?php echo $lv_sec; ?> #evlcnccmtttl").text("<?= $vew_lang->SUBJETIVE;?>") 
      }else {
        console.log('No se realizo')
        $("#<?php echo $lv_sec; ?> #evlcncmtvgrp").removeClass("hidden");
        $("#<?php echo $lv_sec; ?> #evlcard").addClass("hidden");
        $("#<?php echo $lv_sec; ?> #evlcnccmtttl").text("<?= $vew_lang->COMMENTS;?>")
      }
      */
      vewFormData()
    });
  </script>
  <script>
    // server response ext 
    function <?= $lv_sec; ?>_fncbckext(data) {
      if(!data){tmssTabSecCls( $("#<?= $lv_sec; ?>") );}
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="evlsoekin04") { 
          toastr.warning( "Documento <b>"+$("#<?= $lv_sec?> #evlcod").val()+"</b> borrado.", "<?= $lv_title; ?>" );
          
          // cierra formulario
          if($("#<?= $lv_sec; ?>").parents(".modal-content").length){
            $("#<?= $lv_sec; ?>").parents(".modal-content").find(".modal-header").find(".close").click();
          }else{
						tmssTabSecCls( $("#<?= $lv_sec; ?>") );
          }
				} else if (gv_<?= $lv_sec; ?>_last_action=="evlsoekin00" || gv_<?= $lv_sec; ?>_last_action=="evlsoekin") { 
          var lv_evlcod= $("#<?= $lv_sec?> #evlcod").val()?"<b>"+$("#<?= $lv_sec?> #evlcod").val()+"</b>":"";
          if(gv_<?= $lv_sec; ?>_last_action=="evlsoekin00"){
          	toastr.success( "Documento "+ lv_evlcod +" grabado.", "<?= $lv_title; ?>" );  
          }else{
            toastr.info( "Documento "+ lv_evlcod +" actualizado.", "<?= $lv_title; ?>" );
          }
					
					$("#<?= $lv_sec; ?>").replaceWith( data );
        }  else if (gv_<?= $lv_sec; ?>_last_action=="evlinfosd") {
          toastr.info( "Documento" );
        }  else if (gv_<?= $lv_sec; ?>_last_action=="delinfosd") {
          //astr.info( "response del Osde " + data.errtxt );
          tmssTabSecCls( $("#<?= $lv_sec; ?>") );
        }  else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}			
			}
    }
    
    function <?= $lv_sec; ?>_fncGeo(lp_prm ) {
      //se ejecuta si los permisos son concedidos y se encuentra una ubicación 
      lv_evlinfprc = document.querySelector("#<?php echo $lv_sec; ?> #evlinfprc")
      lv_evllat = document.querySelector("#<?php echo $lv_sec; ?> #evllat")
      lv_evllon = document.querySelector("#<?php echo $lv_sec; ?> #evllon")

      function onSucccess2(position) {
        var output = document.getElementById("geomap");        
        lv_lat=position.coords.latitude;
        lv_lon= position.coords.longitude;
        $("#<?php echo $lv_sec; ?> #evllat").attr("value",lv_lat);
        $("#<?php echo $lv_sec; ?> #evllon").attr("value",lv_lon);
        <?=$lv_sec;?>_fnc( lp_prm );         
      }

      //se ejecuta si el permiso fue denegado o no se puede encontrar una ubicación
      function onError2() {
        BootstrapDialog.show({
            title: "No se puede realizar la EVOLUCION",
            message: "Por favor  Active la GEOLOCALIZACION o Comuniquese con su cordinador/ra",
            type: BootstrapDialog.TYPE_WARNING,
          });
      }
			
      if(lv_evlinfprc.checked==false || (lv_evllat.value!='' && lv_evllon.value !='')){
        <?=$lv_sec;?>_fnc( lp_prm );       
      }else{
      	navigator.geolocation.getCurrentPosition(onSucccess2, onError2, config );
      }
    }
    
    // form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			
			// nuevo
      if(lp_prm["action"]=="evlsoekin"){ $("#<?=$lv_sec;?> #nevl").prop("value","X"); }
      
			// grabar
			if ( lp_prm["action"]=="evlsoekin00" ) {
        var lv_val_qty = 0;
        var lo_valerrtxt=[];
        var lv_req_qty=0;
        lv_evlinfprc = document.querySelector("#<?php echo $lv_sec; ?> #evlinfprc");
        
        if(lv_evlinfprc.checked){
        
      		if ( !tmssCheckRequiredFields( $("#<?= $lv_sec; ?>_frm") ) ) { lv_req_qty++; }
          
          $("#<?= $lv_sec; ?>_frm").find("input[type='number']").each( function() {
            switch ($(this)[0].name) {
              case 'tas':{
                if($(this).val()!='' && ($(this).val()<0 || ($(this).val()>240))){
                  $(this).parentsUntil(".tmss-form-group").parent().addClass("has-error");
                  lo_valerrtxt.push('El valor del campo TA Sist&oacute;lica debe ser de 0 a 240');
                  lv_val_qty++;
                }
                break;
              }
              case 'tad':{
                if($(this).val()!='' && ($(this).val()<0 || ($(this).val()>150))){
                  $(this).parentsUntil(".tmss-form-group").parent().addClass("has-error");
                  lo_valerrtxt.push('El valor del campo TA Diast&oacute;lica debe ser de 0 a 150');
                  lv_val_qty++;
                }
                break;
              }
              case 'fc':{
                let lv_val = false
                if($(this).val()!='' && ($(this).val()!='0' && ($(this).val()<40 || $(this).val()>220))){
                  $(this).parentsUntil(".tmss-form-group").parent().addClass("has-error");
                  lo_valerrtxt.push('El valor del campo Frec. Card&iacute;aca debe estar entre 40 y 220 o ser igual a 0');
                  lv_val_qty++;
                }


                break;
              }
              case 'pathgh':{
                if($(this).val()!='' && ($(this).val()<0 || $(this).val()>2500)){
                  $(this).parentsUntil(".tmss-form-group").parent().addClass("has-error");
                  lo_valerrtxt.push('El valor del campo altura debe estar entre 0 y 2.500');
                  lv_val_qty++;
                }
                break;
              }
              case 'fr':{
                if($(this).val()!='' && ($(this).val()!='' && $(this).val()!='0' && ($(this).val()<10 || $(this).val()>70))){
                  $(this).parentsUntil(".tmss-form-group").parent().addClass("has-error");
                  lo_valerrtxt.push('El valor del campo Frec. Respiratoria debe estar entre 10 y 70 o ser igual a 0');
                  lv_val_qty++;
                }
                break;
              }
              case 'tmp':{
                if($(this).val()!='' && ($(this).val()!='0' && ($(this).val()<34 || $(this).val()>42))){
                    
                    $(this).parentsUntil(".tmss-form-group").parent().addClass("has-error");
                    lo_valerrtxt.push('El valor del campo Temperatura debe estar entre 34 y 42 o ser igual a 0');
                    lv_val_qty++;
                  }
                break;
              }
              case 'spo2':{
                if($(this).val()!='' && ($(this).val()!='0' && ($(this).val()<50 || $(this).val()>100))){
                  $(this).parentsUntil(".tmss-form-group").parent().addClass("has-error");
                  lo_valerrtxt.push('El valor del campo SpO2 debe estar entre 50 y 100 o ser igual a 0');
                  lv_val_qty++;
                }
                break;
              }
              case 'glu':{
                if($(this).val()!='' && ($(this).val()!='0' && ($(this).val()<0 || $(this).val()>500))){
                //if($(this).val()!='' && $(this).val()!='0' && $(this).val()<70 || $(this).val()>500){
                  $(this).parentsUntil(".tmss-form-group").parent().addClass("has-error");
                  lo_valerrtxt.push('El valor del campo Glucemia debe estar entre 1 y 500');
                  lv_val_qty++;
                }
                break;
              }
            }
          });
        
          if ( lv_val_qty!=0 ||lv_req_qty!=0) {
            if(lv_val_qty!=0){
              toastr.options.timeOut= 2000;
              lo_valerrtxt.forEach((msj) => toastr.warning(msj));
            }
            return false;
          }
        }else{
          lv_evlcncmtv=document.querySelector("#<?php echo $lv_sec; ?> #evlcncmtv")
          lv_evlcnccmt=document.querySelector("#<?php echo $lv_sec; ?> #evlcnccmt")
          $("#<?php echo $lv_sec; ?> #evlcnccmt").parentsUntil(".tmss-form-group").parent().parent().removeClass("has-error");
          
          if(lv_evlcnccmt.value==''){
            $("#<?php echo $lv_sec; ?> #evlcnccmt").parentsUntil(".tmss-form-group").parent().parent().addClass("has-error");
            toastr.warning("No se ha seleccionado una opcion");
          }
          
          $("#<?php echo $lv_sec; ?> #evlcncmtv").parentsUntil(".tmss-form-group").parent().parent().removeClass("has-error");
          if(lv_evlcncmtv.value==''){
            $("#<?php echo $lv_sec; ?> #evlcncmtv").parentsUntil(".tmss-form-group").parent().parent().addClass("has-error");
            toastr.warning("No se ha seleccionado una opcion");     
          }
          if(lv_evlcncmtv.value=='' || lv_evlcnccmt.value==''){
            return false;
          }
          
          
        }
				var lo_chklst = document.querySelector("#<?php echo $lv_sec; ?> input[type='checkbox']:checked");
        var lo_chktotlst = document.querySelector("#<?php echo $lv_sec; ?> input[type='checkbox']");
        
        $("#<?php echo $lv_sec; ?> [name='actter']").parentsUntil(".tmss-form-group").parent().parent().removeClass("has-error");
        if( lo_chktotlst.length>0 &&lo_chklst.length <=0){
          $("#<?php echo $lv_sec; ?> [name='actter']").parentsUntil(".tmss-form-group").parent().parent().addClass("has-error");
          toastr.warning("No se ha seleccionado una opcion");
          return false;
        }   
        
        var lv_atr = "<pathgh>"+$("#<?= $lv_sec; ?> #pathgh").val()+"</pathgh><patwgt>"+$("#<?= $lv_sec; ?> #patwgt").val()+"</patwgt>";
        $("#<?= $lv_sec; ?> [data-attr] input, #<?= $lv_sec; ?> [data-attr] textarea").each(function(){
          let value =$(this).val();
          let key = $(this).attr("id");
        	
          if(key==='evlcnccmt'){
            value = value.slice(0,3000);
            value = value.replace(/[<>°]/g, '');
          }
          if(key==='evlevl'){
            value = value.slice(0,3000);
            value = value.replace(/[<>°]/g, '');
          }
          //lv_atr+= "<"+$(this).attr("id")+">"+$(this).val()+"</"+$(this).attr("id")+">";
          lv_atr+= "<"+key+">"+ value +"</"+key+">";
        });
        lv_atr+= "<evllat>"+$("#<?= $lv_sec; ?> #evllat").val()+"</evllat>";
        lv_atr+= "<evllon>"+$("#<?= $lv_sec; ?> #evllat").val()+"</evllon>";
        
        
        $("#<?= $lv_sec; ?> #evlatr001").val(lv_atr);
        if($("#<?= $lv_sec; ?> #evlevl").val()){
        	lvEvlEvl = $("#<?= $lv_sec; ?> #evlevl").val().replace(/[<>°]/g, '');
        $("#<?= $lv_sec; ?> #evlevl").val(lvEvlEvl);
          
        }
        
        let lv_dtestr = new Date(Date.parse("<?=$vew_data->frmdtestr->format('Y-m-d');?>"+ " 00:00"));
    
        let lv_dteend = new Date(Date.parse("<?=$vew_data->frmdteend->format('Y-m-d');?>" + " 23:53"));
        
        lv_dte =$("#<?= $lv_sec; ?> #evldte").val().split("/");
        let lv_evldte = new Date(Date.parse(lv_dte[2] + "-" + lv_dte[1] + "-" + lv_dte[0] + " 00:00"));
        
        if(lv_evldte<lv_dtestr || lv_evldte>lv_dteend){
          toastr.warning("<?=$vew_data->txterrtst;?>");
          return false;
        }
        if(!tmssFormValidation($("#<?php echo $lv_sec; ?>_frm"))){return false;}
  
			// borrar
			}else if(lp_prm["action"]=="evlsoekin04"){
        if(lp_prm["result"]!=undefined){
          if(!lp_prm["result"]){
            return false;
          }else{
      			gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
            tmssMessageProcessing( "<?= $lv_sec; ?>", "evlsoekin04", "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
          }
        } else {
          BootstrapDialog.confirm({
            title: "Borrar <?=$lv_title; ?>",
            message: "¿Desea borrar el documento "+$("#<?= $lv_sec?> #evlcod").val()+ "?",
            type: BootstrapDialog.TYPE_WARNING,
            callback: function(result) {
              <?= $lv_sec; ?>_fncext( {action:"evlsoekin04", result:result});
            }
          });
          return false;
      	}
			// cancelar
      }else if(lp_prm["action"]=="98"){
        if($("#<?= $lv_sec; ?>").parents(".modal-content").length){
          $("#<?= $lv_sec; ?>").parents(".modal-content").find(".modal-header").find(".close").click();
        }else{
          tmssTabSecCls( $("#<?= $lv_sec; ?>") );
        }
        return false;
      }else if(lp_prm["action"]=="delinfosd"){
        return true;
      }
      
		}
  </script>
  <?php include('grldocfrmscr.frm'); ?>
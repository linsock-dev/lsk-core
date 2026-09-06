<?php
	// url del formulario
  $lv_lnk = '?prg=crmcnt&prm_crmcntcod='.$vew_data->crmcntcod;

	// campos requeridos
	$lv_reqflddef = array('crmcnttypcod','crmcntmtvcod','crmcntmtvtxt','crmcntprtcod','crmcntstscod','crmcnttxt','crmcntrqs','crmcntsrctxt');
	$lv_reqfldusrtxt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'sysdocclsreqfld');
	$lv_reqfldusr = ($lv_reqfldusrtxt!=''?explode(';',$lv_reqfldusrtxt):array());
	$vew_input->setReqFields( array_merge($lv_reqflddef,$lv_reqfldusr) );

	// clave del documento
	$lv_dockey = $vew_data->crmcntcod;

	// titulo
	$lv_title = $vew_lang->contact;

	// modulo y programa
	$lv_mdlcod = 'CRM';
	$lv_prgcod = 'CNT';
	$lv_objtyp = $lv_mdlcod.'_'.$lv_prgcod;

	// valores x default
	if ( $vew_data->crmcntcod=='' ) { $vew_data->crmcntreqdte = date('d/m/Y'); }
	$vew_data->cmrcntcmtdte = date('d/m/Y');
	$vew_data->crmcntmtvfrmnme = $vew_doc->getTagValue($vew_data->crmcntmtvatr,'crmcntmtvfrmnme');
	$lv_srcobjtyp = strtoupper($vew_doc->getTagValue( $vew_data->sysdoccls->sysdocclsatr, 'srcobjtyp' ));

	// libreria de estilos bootstrap
	include_once('_library.frm');
	
	$lv_blc = false;
  if($vew_data->crmcntstsblc == 1) {
    $lv_blc = true;
    $lv_blcexclst = $vew_data->crmcntstsblcexc ?? '[]';
    $lv_blcexclst = json_decode($lv_blcexclst);
    foreach($lv_blcexclst as $lv_row) {
      if($lv_row->typ == 'USR') $lv_blc = $lv_row->val != $vew_sec->usrcod;
      else if($lv_row->typ == 'ROL') {
        foreach($vew_data->usrgrp as $lv_row2) $lv_blc = $lv_row->val != $lv_row2['usrgrpcod'];
      }
      if(!$lv_blc) break;
    }
  }
	// Botones por vista
	$vew_tbl['modL'] = array('pos'=>'L','per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02') && !$lv_blc, 'ttl'=>$vew_lang->modify, 'id'=>'btnmodL','icn'=>'fas fa-pencil-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'02'.chr(39).'});' );
	$vew_tbl['del'] = array('pos'=>'D','per'=>($lv_dockey??'')!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && !$lv_blc, 'ttl'=>$vew_lang->delete, 'id'=>'','icn'=>'fas fa-trash-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'04'.chr(39).'});' );
	$vew_tbl['delsep'] = array('pos'=>'D','per'=>($lv_dockey??'')!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && !$lv_blc, 'ttl'=>'', 'id'=>'','icn'=>'', 'css'=>'divider', 'acc'=>'' );
	$vew_tbl['btnasg'] = array('pos'=>'L','per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'05') && !$lv_blc, 'ttl'=>$vew_lang->reply, 'id'=>'btnasg','icn'=>'fas fa-share', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit', 'acc'=>'' );

	// Origenes. parametros segun el origen
	$lv_objmdl = explode('_',$lv_srcobjtyp)[0];
  $lv_objprg = explode('_',$lv_srcobjtyp)[1];
	$lv_srcurl = '';
	$lv_srccod = '';
	$lv_srctxt = '';
	$lv_srclbl = '';
	switch( $lv_srcobjtyp ) {
		case 'SLS_CUS':
			$lv_srcurl = 'slscus';
			$lv_srccod = 'cuscod';
			$lv_srctxt = array('custxt');
			$lv_srclbl = $vew_lang->customer;
			break;
		case 'BUY_SUP': 
			$lv_srcurl = 'buysup';
			$lv_srccod = 'supcod';
			$lv_srctxt = array('suptxt');
			$lv_srclbl = $vew_lang->supplier;
			break;
		case 'HLT_PAT': 
			$lv_srcurl = 'hltpat';
			$lv_srccod = 'patcod';
			$lv_srctxt = array('adrlstnme', 'adrfrtnme');
			$lv_srclbl = $vew_lang->patient;
			break;
		case 'HLT_PRS': 
			$lv_srcurl = 'hltprs';
			$lv_srccod = 'prscod';
			$lv_srctxt = array('prstxt');
			$lv_srclbl = $vew_lang->provider;
			break;
		case 'EDU_STU': 
			$lv_srcurl = 'edustu';
			$lv_srccod = 'stucod';
			$lv_srctxt = array('stutxt');
			$lv_srclbl = $vew_lang->student;
			break;
		case 'EDU_TCH': 
			$lv_srcurl = 'edutch';
			$lv_srccod = 'tchcod';
			$lv_srctxt = array('tchtxt');
			$lv_srclbl = $vew_lang->teachers;
			break;
		default:
			$lv_srclbl = $vew_lang->requester;
			break;
	}
	// carga el atributo document change
	$lv_documentchange = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'uexit_documentchange');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>  
	<style>
		.tmss-fixed-header th{ background: white; position: sticky; top: 0; }		
		.tmss-selected{background-color: #f1f1f1}
		@media (max-width: 960px){ .tmss-crm-text-mobile { margin-top: 4vh; } .tmss-crm-first-circle {zoom:0.75; margin-top: 7vh;} }
		.tmss-crm-circle-wrap {transform: translateX(-10px); margin: 20px auto; width: 180px; height: 180px; background: #e6e2e7; border-radius: 50%; }
		.tmss-crm-circle-wrap .tmss-crm-circle .tmss-crm-mask, .tmss-crm-circle-wrap .tmss-crm-circle .tmss-crm-fill { width: 180px; height: 180px; position: absolute; border-radius: 50%; }
		.tmss-crm-circle-wrap .tmss-crm-circle .tmss-crm-mask { clip: rect(0px, 180px, 180px, 90px); }
		.tmss-crm-circle-wrap .tmss-crm-circle .tmss-crm-mask .tmss-crm-fill { clip: rect(0px, 91px, 180px, 0px); background-color: #2fa4e7; } 
		.tmss-crm-circle-wrap .tmss-crm-circle .tmss-crm-mask.tmss-crm-full, .tmss-crm-circle-wrap .tmss-crm-circle .tmss-crm-fill { animation: fill ease-in-out 2.5s; transform: rotate( calc((180deg * <?= ($vew_doc->getTagValue($vew_data->crmcntatr, 'prg') != '' ? ($vew_doc->getTagValue($vew_data->crmcntatr, 'prg')>=100?'100':$vew_doc->getTagValue($vew_data->crmcntatr, 'prg')) . '' : '0'); ?>) / 100 )); } 
		@keyframes fill { 0% { transform: rotate(0deg); width:0px; height;0px} 20%{height:180px; width:180px;} 100% { transform: rotate( calc((180deg * <?= ($vew_doc->getTagValue($vew_data->crmcntatr, 'prg') != '' ? ($vew_doc->getTagValue($vew_data->crmcntatr, 'prg')>=100?'100':$vew_doc->getTagValue($vew_data->crmcntatr, 'prg')) . '' : '0'); ?>) / 100 )) ); } }
		.tmss-crm-percent{font-size: 24px;}
		.tmss-crm-circle-wrap .tmss-crm-inside-circle { transform: translate(15px, 15px); color:#2fa4e7; width: 130px; height: 130px; border-radius: 50%; background: #fff; line-height: 130px; text-align: center; margin-top: 10px; margin-left: 10px; position: absolute; z-index: 100; font-weight: 700; font-size: 3em; }
		.tmss-wrap {display: block; box-sizing: border-box; height: 300px; width: 300px;}
	</style>

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?php
 			echo gethtml('tmss_actcod',	'hidden', '');
    	echo gethtml('crmcntmtvfrmnme',	'hidden', $vew_data->crmcntmtvfrmnme);
    	echo gethtml('crmcntcmtdte',	'hidden', '');
    ?>
		<textarea class="hidden" id="crmcntcmt" name="crmcntcmt"><?= $vew_data->crmcntcmt; ?></textarea>
		<textarea class="hidden" id="crmcntatr" name="crmcntatr"><?= preg_replace('/<esttme>[0-9.]*<\/esttme><prg>[0-9]*<\/prg><duedte>[0-9\/]*<\/duedte>/', '', strtolower($vew_data->crmcntatr)); ?></textarea>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
        <?php if ($vew_actcod != '01'){ ?><li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->progress; ?></a></li><?php } ?>
				<li class="pull-right"><h4># <strong><?= $vew_data->crmcntcod; ?><?= gethtml('crmcntcod',	'hidden', $vew_data->crmcntcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="<?= ($vew_data->crmcntcod==''?'col-md-6':'col-md-4'); ?>">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $lv_title; ?>
                    <span class="tmss-card-icon">
                      <?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?>
                      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
                    </span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                    <?php
                      echo gethtml('crmcntsrctyp', 'hidden', $lv_srcobjtyp);
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('crmcntdte', 	'docdte', 		$vew_data->crmcntreqdte, $lv_default) ));
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->title, 'input'=>gethtml('crmcnttxt', 	'doccmt1x50', $vew_data->crmcnttxt, $lv_default ) ));
											
											if( count(explode('_',$lv_srcobjtyp))==2 ){
                        $lv_srcinfper = $vew_sec->hasPermission($lv_objmdl, $lv_objprg, '03') && $vew_readonly;
												$lv_btngrp ='<span class="input-group-btn">'.
																			($vew_readonly?'':'<a href="#" class="btn btn-default">&nbsp;<i class="fas fa-search"></i></a>').
																			($lv_srcinfper ? '<a href="#" id="btnsrcinf" class="btn btn-default" title="'.$vew_lang->additionalinfo.'">&nbsp;<i class="fas fa-info"></i></a>' : '').
                                      ($vew_sec->hasPermission($lv_objmdl, $lv_objprg, '01') && !$vew_readonly ? '<a href="#" id="btnsrcadd" class="btn btn-default '.($vew_data->crmcntsrccod!=''?'d-none':'').'">&nbsp;<i class="fas fa-plus"></i></a>' : '' ).
                                      ($vew_sec->hasPermission($lv_objmdl, $lv_objprg, '02') && !$vew_readonly ? '<a href="#" id="btnsrcedt" class="btn btn-default '.($vew_data->crmcntsrccod==''?'d-none':'').'">&nbsp;<i class="fas fa-pencil-alt"></i></a>' : '' ).
																		'</span>';
                        
												echo vew_boot($lv_col210,	array('label'=>$lv_srclbl,
																												'input'=>vew_boot(array('style'=>'custom', 'readonly'=>$lv_srcinfper ? false : $vew_readonly),
																																					array('custom'=>$lv_btngrp, 'input'=>gethtml('crmcntsrctxt', 'typeahead', $vew_data->crmcntsrctxt, $lv_default) )),
																											));
											}
                      echo gethtml('crmcntsrccod', 'hidden', $vew_data->crmcntsrccod);
                      echo gethtml('crmcntsrcclscod', 'hidden', $vew_data->crmcntsrcclscod);
                  
                      switch( $lv_srcobjtyp ) {
                        case 'SLS_CUS':	case 'BUY_SUP': case 'HLT_PAT':
                          $lv_cntinfper = $vew_sec->hasPermission($lv_objmdl, $lv_objprg.'C', '03') && $vew_readonly && $vew_data->crmcntsrccntcod;
													$lv_btngrp ='<span class="input-group-btn">'.
																				($vew_readonly?'':'<a href="#" class="btn btn-default">&nbsp;<i class="fas fa-search"></i></a>').
																				($lv_cntinfper ? '<a href="#" id="btncntinf" class="btn btn-default" title="'.$vew_lang->additionalinfo.'">&nbsp;<i class="fas fa-info"></i></a>' : '' ).
																				($vew_sec->hasPermission($lv_objmdl, $lv_objprg.'C', '01') && !$vew_readonly ? '<a href="#" id="btncntadd" class="btn btn-default '.($vew_data->crmcntsrccntcod!=''?'d-none':'').'" title="'.$vew_lang->add.'">&nbsp;<i class="fas fa-plus"></i></a>' : '' ).
																				($vew_sec->hasPermission($lv_objmdl, $lv_objprg.'C', '02') && !$vew_readonly ? '<a href="#" id="btncntedt" class="btn btn-default '.($vew_data->crmcntsrccntcod==''?'d-none':'').'" title="'.$vew_lang->edit.'">&nbsp;<i class="fas fa-pencil-alt"></i></a>' : '' ).
																			'</span>';
													echo vew_boot($lv_col210,	array('label'=>$vew_lang->contact,
																													'input'=>vew_boot(array('style'=>'custom', 'readonly'=> $lv_cntinfper ? false : $vew_readonly),
																																						array('custom'=>$lv_btngrp, 'input'=>gethtml('crmcntsrccnttxt', 'typeahead', $vew_data->crmcntsrccnttxt, $lv_default) )),
																												));
                          break;
                      }
                   		echo gethtml('crmcntsrccntcod', 'hidden', $vew_data->crmcntsrccntcod);
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('crmcntrqs', 'doccmt10x50', $vew_data->crmcntrqs, $lv_default) ));
                    ?>
                </div>
              </div> <!-- /card -->
						</div> <!-- /col -->
						<div class="<?= ($vew_data->crmcntcod==''?'col-md-6':'col-md-3'); ?>">
              <div class="card">
                <div class="card-header"><div class="card-title"><span id="crmcntststxtlbl"><?= (trim($vew_data->crmcntststxt)!=''?$vew_data->crmcntststxt:'&nbsp;'); ?></span></div></div>
                <div class="card-body tmss-card-body-edit">
									<?php
										echo gethtml('crmcnttyptxt', 'hidden', $vew_data->crmcnttyptxt);
										echo vew_boot($lv_col39, array('label'=>$vew_lang->type, 'input'=>gethtml('crmcnttypcod', 'crmcnttypcod_lst', $vew_data->crmcnttypcod, $lv_default ) ));
										echo vew_boot($lv_col39, array('label'=>$vew_lang->motive,
																										'input1'=>vew_boot( array('style'=>'search','readonly'=>$vew_readonly),
																																				array('input'=>gethtml('crmcntmtvtxt', 'typeahead', $vew_data->crmcntmtvtxt, $lv_default )
																																			)) ));
										echo gethtml('crmcntmtvcod', 'hidden', $vew_data->crmcntmtvcod);
										echo gethtml('crmcntmtvact', 'hidden', $vew_data->crmcntmtvact);
										echo gethtml('crmcntmtvfrm', 'hidden', $vew_data->crmcntmtvfrm);
										echo gethtml('crmcntprttxt', 'hidden', $vew_data->crmcntprttxt);	
										echo vew_boot($lv_col39, array('label'=>$vew_lang->priority,	'input'=>gethtml('crmcntprtcod', 'crmcntprtcod_lst', $vew_data->crmcntprtcod, $lv_default) ));
										if( $vew_readonly ){
											echo gethtml('crmcntduedte','hidden',(is_a($vew_data->crmcntduedte,'DateTime')?date_format($vew_data->crmcntduedte,'d/m/Y'):''));
											echo gethtml('crmcntatrtmeduedte','hidden',$vew_doc->gettagvalue($vew_data->crmcntatr,'tmeduedte'));
											echo vew_boot($lv_col39, array('label'=>$vew_lang->DueDate, 'input'=>gethtml('', 'doccmt1x50', (is_a($vew_data->crmcntduedte,'DateTime')?date_format($vew_data->crmcntduedte,'d.m.Y'):'').' '.$vew_doc->gettagvalue($vew_data->crmcntatr,'tmeduedte'), $lv_always_disabled) ));
										} else {
											echo vew_boot($lv_col39, array('label'=>$vew_lang->DueDate,		
																										'input'=>gethtml('crmcntduedte', 'docdte', $vew_data->crmcntduedte, $lv_default) 
											));
											echo vew_boot($lv_col39, array('label'=>'',		
																										'input'=>gethtml('crmcntatrtmeduedte', 'doctme', $vew_doc->gettagvalue($vew_data->crmcntatr,'tmeduedte'), $lv_default) 
											));
										}
										echo vew_boot($lv_col39, array('label'=>$vew_lang->responsible,	'input'=>gethtml('usrcod', 'doccmt1x50',$vew_data->usrcod, $lv_default) ));	
										echo vew_boot($lv_col39, array('label'=>$vew_lang->reference,	'input'=>gethtml('crmcntrefdoc', 'doccmt1x20',$vew_data->crmcntrefdoc, $lv_default) ));	
                  	echo vew_boot($lv_col39, array('label'=>$vew_lang->contactroute, 'input'=>gethtml('crmcntwaycod', 'doccmt1x20',$vew_data->crmcntwaycod, $lv_default) ));
                  	echo gethtml('crmcntststxt', 'hidden', $vew_data->crmcntststxt); 
										echo gethtml('crmcntstscod', 'hidden', $vew_data->crmcntstscod); 
									?>
                </div>
              </div> <!-- /card -->
							
							<div class="card" id="divact" class="hidden">
								<div class="card-header"><div class="card-title"><?= $vew_lang->activities; ?></div></div>
								<div class="card-body tmss-card-body-edit"><span id="divacttxt"></span></div>
							</div>

            </div> <!-- /col -->
						
						<div class="col-md-5 <?= ($vew_data->crmcntcod==''?'hidden':''); ?>">													
							<div id="divhst">
								<div id="divchgdoclst"></div>
      				</div>
						</div> <!-- /col -->

          </div> <!-- /row -->
				</div> <!-- /tab001 -->
        
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab002">
					<div class="row">
            <div class="col-md-6" id="prgleftcol">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= ($vew_actcod!='02'?$vew_lang->INDICATORS:$vew_lang->data); ?></div></div>
                <div class="card-body">
                  <div class="row">
                    <?php if ($vew_actcod != '001'){
                      if($vew_readonly){ ?>
                        <div class="col-xs-12">
                          <div id="firstpanel" class="text-center">
                            <div class="col-xs-6">
                              <h4 style="color: #2fa4e7;"><b><?= $vew_lang->estimated; ?></b></h4>
                              <h2 style="font-size: 48px; font-weight:700; margin-top: 3%; color: #2fa4e7;"><?= ($vew_doc->getTagValue($vew_data->crmcntatr, 'esttme') != '' ? $vew_doc->getTagValue($vew_data->crmcntatr, 'esttme') : '0'); ?><span class="tmss-percent-span" style="font-size: 24px; color:#2fa4e7">hs</span></h2>
                            </div>
                            <div class="col-xs-6">
                              <h4 style="color: #2fa4e7;"><b><?= $vew_lang->duedate; ?></b></h4>
                              <h4 style="color: #2fa4e7; margin-top: 5%;"><?= (is_object($vew_data->crmcntduedte)?date_format($vew_data->crmcntduedte,'d/m/Y'):''); ?></h4>
                              <?php 
                                if( is_object($vew_data->crmcntduedte) ){
                                  $lv_date = $vew_data->crmcntduedte; 
																	$lv_now = new DateTime('now');
																	$lv_dif = date_diff( $lv_now , $lv_date );
                                  echo '<h3 style="color: '.($lv_now < $lv_date ? ($lv_dif->days<=7 ? 'red' :'#a6a6a6') : 'red').';">'.
																		($lv_now < $lv_date ? ($lv_dif->days==0 && $lv_dif->format('%R')=='+' ? 'Falta ' : ($lv_dif->format('%R')=='+' ? 'Faltan ': '')) : '').
																		($lv_dif->days+($lv_dif->format('%R')=='+' ? 1 : 0)).
																		($lv_dif->days==0 || ($lv_dif->days==1 && $lv_dif->format('%R')=='-') ? ' d&iacute;a' :' d&iacute;as').
																		($lv_now < $lv_date ? '' : ' vencido').
																		'</h3>';
                                }
                              ?>
                            </div>
                          </div>
                        </div>
                    		<div class="col-xs-12"><hr></div>
                        <div class="col-xs-6">
                          <div id="secondpanel">
                            <h4 class="text-center tmss-crm-text-mobile" style="color: #2fa4e7;"><b>AVANCE</b></h4>
                            <div class="tmss-crm-first-circle" style="transform: translateX(10px)">
                              <div class="tmss-crm-circle-wrap">
                                <div class="tmss-crm-circle">
                                  <div class="tmss-crm-mask tmss-crm-full">
                                    <div class="tmss-crm-fill tmss-crm-fill1"></div>
                                  </div>
                                  <div class="tmss-crm-mask half">
                                    <div class="tmss-crm-fill tmss-crm-fill1"></div>
                                  </div>
                                  <div class="tmss-crm-inside-circle">
                                    <?= ($vew_doc->getTagValue($vew_data->crmcntatr, 'prg') != '' ? $vew_doc->getTagValue($vew_data->crmcntatr, 'prg') : '0'); ?><span class="tmss-crm-percent">%</span>
                                  </div>
                                </div>
                              </div>
                            </div>
                            <h4 class="text-center tmss-crm-text-mobile" style="color: #2fa4e7; margin-top: 28px;"><?= ($vew_doc->getTagValue($vew_data->crmcntatr, 'prg') == '100' ? '<b>COMPLETADO</b>' : '<b style="visibility:hidden">.</b>'); ?></h4>
                          </div>
                        </div>
                        <div class="col-xs-6">
                          <div id="secondpanel">
                            <h2 class="text-center" style="font-weight:700; font-size: 48px; margin-top: 3%; color: #2fa4e7;" ><span id="crmcntregtme">0</span><span class="tmss-percent-span" style="font-size: 24px; color:#2fa4e7">hs</span></h2>
                            <h4 class="text-center" style="color: #2fa4e7;"><b>REGISTRADAS<br> DE AVANCE</b></h4>
                            <hr>
                            <div style="transform: translateX(10px); zoom:0.65;">
                              <div class="tmss-crm-circle-wrap">
                                <div class="tmss-crm-circle tmss-crm-circle2">
                                  <div class="tmss-crm-mask tmss-crm-full2">
                                    <div class="tmss-crm-fill tmss-crm-fill2"></div>
                                  </div>
                                  <div class="tmss-crm-mask half">
                                    <div class="tmss-crm-fill tmss-crm-fill2"></div>
                                  </div>
                                  <div class="tmss-crm-inside-circle">
                                    <span class="tmss-crm-number2" id=hrsprcntspan>0</span><span class="tmss-crm-number2 tmss-crm-percent">%</span>
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                      <?php 
                      echo gethtml('crmcntprg', 'hidden', $vew_doc->getTagValue($vew_data->crmcntatr, 'prg'));
                      echo gethtml('crmcntesttme', 'hidden', $vew_doc->getTagValue($vew_data->crmcntatr, 'esttme'));
                    }else{ ?>
                      <div class="card-body tmss-card-body-edit">
                        <?php
                        echo (!$vew_readonly ? vew_boot($lv_col210, array('label'=>"Horas estimadas",		'input'=>gethtml('crmcntesttme', 'docnum0601', $vew_doc->getTagValue($vew_data->crmcntatr, 'esttme'), $lv_default) )) : '');
                        echo (!$vew_readonly ? '<div class="form-group"><label class="col-xs-2 control-label text-nowrap">'.$vew_lang->progress.'</label><div class="col-xs-10"><input type="NUMBER" id="crmcntprg" name="crmcntprg" value="'.$vew_doc->getTagValue($vew_data->crmcntatr, 'prg').'" maxlength="6" min="0" max="100" step="1" class="form-control"></div></div>':'');
                        echo '</div>';
                        ?>
                      </div>
                  <?php } ?>
                  </div>
              	</div>
          		</div>
            <div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    Registro de horas
                    <?php if(!$lv_blc) {?>
                      <a href="#" id="btnrmvrows" class="card-icon" title="<?= $vew_lang->delete; ?>"><i class="far fa-trash-alt"></i></a>
                      <a href="#" id="btnaddrow" class="card-icon" title="<?= $vew_lang->new; ?>"><i class="far fa-plus"></i></a>
                    <?php } ?>
                  </div>
                </div>
                <div class="card-body">
                  <div class="tmss-scrollbar" style="overflow-y: auto;" id="regtble"></div>
                </div>
              </div>
            <?php } ?>
          	</div>
          </div>
				</div> <!-- /tab002 -->
        
			</div> <!-- /tab-content -->
		</div> <!-- /container-fluid -->
	</form>
	<style>.extra-wide-dialog .modal-dialog { width: 85vw; }</style>
  <?php if ($vew_actcod!='02') { ?>
  	<script>
      //load grldatupl_divbtn
      lv_chgdocsrctyp="<?= $lv_objtyp; ?>"; 
      lv_chgdocsrccod="<?= $lv_dockey; ?>"; 
			function <?= $lv_sec; ?>_grldatupl_btnupl() {
        tmssCallProcess("?prg=sysdocchg&act=13&prm_chgdocsrctyp="+lv_chgdocsrctyp+"&prm_chgdocsrccod="+lv_chgdocsrccod+"&prm_bcksec=<?= $lv_sec; ?>&prm_main=comentarios",[],function(data) {
          $('#<?= $lv_sec; ?> #divchgdoclst').html(data);
          if("<?= $lv_blc; ?>")
          {
            $('#<?= $lv_sec; ?> #divchgdoclst').html(data)       
              .find('a[name="btnedt"]')
              .remove();
          }
        });
      }
      <?= $lv_sec; ?>_grldatupl_btnupl();
    </script>
	<?php }?>
	
  <script>
    <?php if($vew_sec->hasPermission($lv_objmdl, $lv_objprg, '01') ||  $vew_sec->hasPermission($lv_objmdl, $lv_objprg, '02')){ ?>
      $("#<?= $lv_sec; ?> #btnsrcadd, #<?= $lv_sec; ?> #btnsrcedt").on("click", function(e){ e.preventDefault();
        <?= $lv_sec; ?>_opnsrc();
      });
    <?php } ?>
    
    $("#<?= $lv_sec; ?> #btnsrcinf").on("click",function(e){ e.preventDefault();
			<?= $lv_sec; ?>_opnsrc();
		});
    
    function <?= $lv_sec; ?>_opnsrc() {
      var lv_crmcntsrccod = $("#<?= $lv_sec; ?> #crmcntsrccod").val();
      var lv_act = lv_crmcntsrccod ? ("<?= $vew_readonly ?>" ? "03" : "02") : "01";
      var lv_pstdat = [{name:"<?=$lv_srccod;?>", value: lv_crmcntsrccod}]
      tmssLink("?prg=<?=$lv_srcurl;?>&act="+lv_act, [{target: "_new_section", post_data: lv_pstdat}]);
    }
  </script>
  <script>
    var lv_<?= $lv_sec; ?>_srctxt = <?= json_encode($lv_srctxt); ?>;
    
    function <?= $lv_sec; ?>_GridRefresh(lp_data){  
      // actualizar campo Origen
      var lv_crmcntsrccod_new = lp_data["<?= $lv_srccod; ?>"] != undefined ? lp_data["<?= $lv_srccod; ?>"] : "";
      if(lv_crmcntsrccod_new != "" ){
      	var lv_crmcntsrccod_act = $("#<?= $lv_sec; ?> #crmcntsrccod").val();
      	$("#<?= $lv_sec; ?> #crmcntsrccod").val(lv_crmcntsrccod_new)
        if(lv_crmcntsrccod_new != lv_crmcntsrccod_act){ $("#<?= $lv_sec; ?> #crmcntsrccod").trigger("change"); }
        $("#<?= $lv_sec; ?> #crmcntsrctxt").val(lv_<?= $lv_sec; ?>_srctxt.map((elem) => lp_data[elem]).join(", ").toUpperCase());
      }
      
      // actualizar campo Contacto
      var lv_crmcntsrccntcod_new = lp_data["cntcod"] != undefined ? lp_data["cntcod"] : "";
      if(lv_crmcntsrccntcod_new != "" ){
      	var lv_crmcntsrccntcod_act = $("#<?= $lv_sec; ?> #crmcntsrccntcod").val();
      	$("#<?= $lv_sec; ?> #crmcntsrccntcod").val(lv_crmcntsrccntcod_new)
        if(lv_crmcntsrccntcod_new != lv_crmcntsrccntcod_act){ $("#<?= $lv_sec; ?> #crmcntsrccntcod").trigger("change"); }
        $("#<?= $lv_sec; ?> #crmcntsrccnttxt").val(lp_data["cnttxt"]);
      }
    }
  </script>
	<script>
		// ------------------------------------------------------------------------
		// CONTACTOS
		// ------------------------------------------------------------------------
		
		$(function(){	$("#<?= $lv_sec; ?> #crmcntsrccod").trigger("change"); });
		
		// cambiar. evento de cambio de contacto
    $("#<?= $lv_sec; ?> #crmcntsrccod").on("change", function(){
      $("#<?= $lv_sec; ?> #btnsrcadd").toggleClass("d-none", $("#<?= $lv_sec; ?> #crmcntsrccod").val()!="");
      $("#<?= $lv_sec; ?> #btnsrcedt, #<?= $lv_sec; ?> #btncntadd").toggleClass("d-none", $("#<?= $lv_sec; ?> #crmcntsrccod").val()=="");
      $("#<?= $lv_sec; ?> #crmcntsrccntcod").trigger("change");
    });
       
		$("#<?= $lv_sec; ?> #crmcntsrccntcod").on("change", function(){
      if($("#<?= $lv_sec; ?> #crmcntsrccod").val()==""){
      	$("#<?= $lv_sec; ?> #crmcntsrccnttxt, #<?= $lv_sec; ?> #crmcntsrccntcod").val("");  
      }
      $("#<?= $lv_sec; ?> #btncntadd").toggleClass("d-none", $("#<?= $lv_sec; ?> #crmcntsrccod").val()=="" || $("#<?= $lv_sec; ?> #crmcntsrccntcod").val()!="");
      $("#<?= $lv_sec; ?> #btncntedt").toggleClass("d-none", $("#<?= $lv_sec; ?> #crmcntsrccod").val()=="" || $("#<?= $lv_sec; ?> #crmcntsrccntcod").val()=="");
		});
    
    // Para asignar el responsable en función del cliente
    $("#<?= $lv_sec; ?> #crmcntsrccod").on("change", function(){ 
      var lv_crmcntsrccod = $(this).val();
      if ("<?= $lv_documentchange; ?>") {
        var lv_pstdat =[{name: "crmcntsrccod", value: lv_crmcntsrccod},
                        {name: "sec", value: "<?= $lv_sec; ?>"}
                       ];
        tmssCallProcessNoBackdrop("<?= $lv_documentchange; ?>", lv_pstdat, function(data){
          if (data.substring(0,10)=="/*script*/") { eval(data); }
        });
      }
		});
    
		// info, agregar y editar contacto
		$("#<?= $lv_sec; ?> #btncntinf, #<?= $lv_sec; ?> #btncntadd, #<?= $lv_sec; ?> #btncntedt").on("click",function(e){ e.preventDefault(); <?= $lv_sec; ?>_cntedt(); });
		
		// editar. funcion para editar/agregar/ver contacto
		function <?= $lv_sec; ?>_cntedt() {
			var lv_cntcod = $("#<?= $lv_sec; ?> #crmcntsrccntcod").prop("value");
      var lv_act = lv_cntcod ? ("<?= $vew_readonly ?>" ? "03" : "02") : "01";
			var lv_pstdat =[{name:"cntsrctyp",value:$("#<?= $lv_sec; ?> #crmcntsrctyp").val()},
											{name:"cntsrccod",value:$("#<?= $lv_sec; ?> #crmcntsrccod").val()},
											{name:"srcdocclscod",value:$("#<?= $lv_sec; ?> #crmcntsrcclscod").val()},
											{name:"cntcod",value: lv_cntcod},
											{name:"lv_sec",value:"<?= $lv_sec; ?>"}];
      tmssLink("?prg=grldatcnt&act="+lv_act, [{target: "_new_section", post_data: lv_pstdat}]);
		}	
	</script>
	<script>
		$(function(){
			<?php 
      if(!$vew_readonly){
        switch ($lv_srcobjtyp) { 
          case 'SLS_CUS':
            echo 'var lo_get = {"fldsec": "'.$lv_sec.'", "fldflt": {"c.docsts":"A"}, "fldasg": {"crmcntsrccod":"cuscod", "crmcntsrctxt":"custxt", "crmcntsrcclscod":"sysdocclscod"}}; ';
            echo 'tmssTypeahead($("#'.$lv_sec.' #crmcntsrctxt"), "slscus", lo_get, {"afterAssign":function(){$("#'.$lv_sec.' #crmcntsrccnttxt").prop("value",""); $("#'.$lv_sec.' #crmcntsrccntcod").prop("value",""); $("#'.$lv_sec.' #crmcntsrccod").trigger("change");}} );';
            break;
          case 'BUY_SUP':
            echo 'var lo_get = {"fldsec": "'.$lv_sec.'", "fldflt": {"s.docsts":"A"}, "fldasg": {"crmcntsrccod":"supcod", "crmcntsrctxt":"suptxt", "crmcntsrcclscod":"sysdocclscod"}}; ';
            echo 'tmssTypeahead($("#'.$lv_sec.' #crmcntsrctxt"), "buysup", lo_get, {"afterAssign":function(){$("#'.$lv_sec.' #crmcntsrccnttxt").prop("value",""); $("#'.$lv_sec.' #crmcntsrccntcod").prop("value",""); $("#'.$lv_sec.' #crmcntsrccod").trigger("change");}} );';
            break;
          case 'HLT_PAT':
            echo 'var lo_get = {"fldsec": "'.$lv_sec.'", "fldflt": {"p.docsts":"A"}, "fldasg": {"crmcntsrccod":"patcod", "crmcntsrctxt":"pattxt", "crmcntsrcclscod":"sysdocclscod"}}; ';
            echo 'tmssTypeahead($("#'.$lv_sec.' #crmcntsrctxt"), "hltpat", lo_get, {"afterAssign":function(){$("#'.$lv_sec.' #crmcntsrccnttxt").prop("value",""); $("#'.$lv_sec.' #crmcntsrccntcod").prop("value",""); $("#'.$lv_sec.' #crmcntsrccod").trigger("change");}} );';
            break;
          case 'HLT_PRS':
            echo 'var lo_get = {"fldsec": "'.$lv_sec.'", "fldflt": {"p.docsts":"A"}, "fldasg": {"crmcntsrccod":"prscod", "crmcntsrctxt":"prstxt", "crmcntsrcclscod":"sysdocclscod"}}; ';
            echo 'tmssTypeahead($("#'.$lv_sec.' #crmcntsrctxt"), "hltprs", lo_get, {"afterAssign":function(){$("#'.$lv_sec.' #crmcntsrccnttxt").prop("value",""); $("#'.$lv_sec.' #crmcntsrccntcod").prop("value",""); $("#'.$lv_sec.' #crmcntsrccod").trigger("change");}} );';
            break;
          case 'EDU_STU':
            echo 'var lo_get = {"fldsec": "'.$lv_sec.'", "fldflt": {"p.docsts":"A"}, "fldasg": {"crmcntsrccod":"stucod", "crmcntsrctxt":"stutxt", "crmcntsrcclscod":"sysdocclscod"}}; ';
            echo 'tmssTypeahead($("#'.$lv_sec.' #crmcntsrctxt"), "edustu", lo_get, {"afterAssign":function(){$("#'.$lv_sec.' #crmcntsrccnttxt").prop("value",""); $("#'.$lv_sec.' #crmcntsrccntcod").prop("value",""); $("#'.$lv_sec.' #crmcntsrccod").trigger("change");}} );';
            break;
          case 'EDU_TCH':
            echo 'var lo_get = {"fldsec": "'.$lv_sec.'", "fldflt": {"p.docsts":"A"}, "fldasg": {"crmcntsrccod":"tchcod", "crmcntsrctxt":"tchtxt", "crmcntsrcclscod":"sysdocclscod"}}; ';
            echo 'tmssTypeahead($("#'.$lv_sec.' #crmcntsrctxt"), "edutch", lo_get, {"afterAssign":function(){$("#'.$lv_sec.' #crmcntsrccnttxt").prop("value",""); $("#'.$lv_sec.' #crmcntsrccntcod").prop("value",""); $("#'.$lv_sec.' #crmcntsrccod").trigger("change");}} );';
            break;
        }

        // source contact
        if($lv_srcobjtyp=='SLS_CUS' || $lv_srcobjtyp=='BUY_SUP' || $lv_srcobjtyp=='HLT_PAT'){
          echo 'var lo_get = {"fldsec" : "'.$lv_sec.'", "fldflt":{ "c.cntsrctyp":$("#'.$lv_sec.' #crmcntsrctyp"), "c.cntsrccod": $("#'.$lv_sec.' #crmcntsrccod"), "c.docsts": "A"}, "fldasg" : {"crmcntsrccntcod" : "cntcod", "crmcntsrccnttxt" : "cnttxt"}}; ';
          echo 'tmssTypeahead($("#'.$lv_sec.' #crmcntsrccnttxt"), "grldatcnt", lo_get, {"afterAssign":function(){$("#'.$lv_sec.' #crmcntsrccntcod").trigger("change");}} );';
        }
      }
			?>
    
			// MOTIVO DE CONTACTO. crmcntmtvtxt
			var lo_get = {"fldsec" : "<?= $lv_sec; ?>","fldflt":{"m.crmcnttypcod": $("#<?= $lv_sec; ?> #crmcnttypcod"), "m.docsts": "A"}, "fldasg" : {"crmcntmtvcod" : "crmcntmtvcod", "crmcntmtvtxt" : "crmcntmtvtxt", "crmcntmtvact":"crmcntmtvact", "crmcntmtvfrm":"crmcntmtvfrm", "crmcntmtvfrmnme":"crmcntmtvfrmnme", "crmcntprtcod":"crmcntprtcod", "crmcntstscod":"crmcntstscod", "crmcntststxt":"crmcntststxt" }};
			var lv_crmcntmtvfnc = function(){
				<?= $lv_sec; ?>_getRes($("#<?= $lv_sec;?> #crmcntmtvcod").val());
				<?= $lv_sec; ?>_refreshScreen(); }
			tmssTypeahead($("#<?= $lv_sec; ?> #crmcntmtvtxt"), "crmcntmtv", lo_get,{"afterAssign":lv_crmcntmtvfnc });
			
		});
		
		$("#<?= $lv_sec; ?> #crmcnttypcod").on("change",function(e){ e.preventDefault();
			$("#<?= $lv_sec; ?> #crmcntmtvtxt").prop("value", "");
			$("#<?= $lv_sec; ?> #crmcntmtvcod").prop("value", "");
			$("#<?= $lv_sec; ?> #crmcntmtvact").prop("value", "");
			$("#<?= $lv_sec; ?> #crmcntmtvfrm").prop("value", "");
			$("#<?= $lv_sec; ?> #crmcntmtvfrmnme").prop("value", "");
			$("#<?= $lv_sec; ?> #crmcntprtcod").prop("value", "");
			$("#<?= $lv_sec; ?> #crmcntstscod").prop("value", "");
			<?= $lv_sec; ?>_refreshScreen();
		});

		$("#<?= $lv_sec; ?> #crmcntsrcinf").on("click",function(e){ e.preventDefault();
			tmssLink("?prg=<?=$lv_srcurl;?>&act=03",[{target:"_new_section",post_data:[{name:"<?=$lv_srccod;?>",value: $("#<?= $lv_sec; ?> #crmcntsrccod").val()}] }]);
		});
    
    $("#<?= $lv_sec; ?> #crmcnttypcod").on("change",function(e){ e.preventDefault();
			$("#<?= $lv_sec; ?> #crmcntmtvtxt").prop("value", "");
			$("#<?= $lv_sec; ?> #crmcntmtvcod").prop("value", "");
			$("#<?= $lv_sec; ?> #crmcntmtvact").prop("value", "");
			$("#<?= $lv_sec; ?> #crmcntmtvfrm").prop("value", "");
			$("#<?= $lv_sec; ?> #crmcntmtvfrmnme").prop("value", "");
			$("#<?= $lv_sec; ?> #crmcntprtcod").prop("value", "");
			$("#<?= $lv_sec; ?> #crmcntstscod").prop("value", "");
			<?= $lv_sec; ?>_refreshScreen();
    });
    		
    
		// RESPONDER
		$("#<?= $lv_sec; ?> #btnasg").on("click",function(e){ e.preventDefault();
			//datos post
			lv_pstdat = [{ "name":"crmcntcod", "value":$("#<?= $lv_sec?> #crmcntcod").prop("value") }];

			// se obtiene la vista de responder
			tmssCallProcess("?prg=crmcnt&act=cntasg", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->reply; ?>",
					message: $(data),
					closable:false, 
					draggable: true,
					size: BootstrapDialog.SIZE_NORMAL,
					buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialogItself){ dialogItself.close(); } },
										{	label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success",	action: function(dialog){
                      //obtiene el cuerpo del dialogo
											var lv_frm = dialog.$modalBody;
											var lv_cmtdte = $(lv_frm).find("#crmcntcmtdte").prop("value");
											var lv_stscod = $(lv_frm).find("#crmcntstscod").prop("value");
											var lv_ststxt = $(lv_frm).find("#crmcntstscod option:selected").text();
                      var lv_stscls = $(lv_frm).find("#crmcntstscls").prop("value");

                      //obtiene el comentario
											var lv_txt = $(lv_frm).find("#crmcntcmt").prop("value");
											lv_txt = lv_txt.replace(/(?:\r\n|\r|\n)/g, "<br>");
											
                      //obtiene el codigo de responsable
                      var lv_usr = $(lv_frm).find("#usrcod").prop("value");
											
                      //revisa que haya un codigo de 
                      if (lv_stscod=="") { toastr.warning("Debe completar todos los valores."); return false; }
											//define datos post
                      var lv_pstdat =[{"name":"crmcntcmt","value":lv_txt},
																			{"name":"crmcntstscod","value":lv_stscod},
																			{"name":"crmcntststxt","value":lv_ststxt},
																			{"name":"crmcntcmtdte","value":lv_cmtdte},
																			{"name":"usrcod","value":lv_usr},
																			{"name":"crmcntcod", "value":$("#<?= $lv_sec; ?> #crmcntcod").prop("value")},
																			{"name":"crmcntmtvcod", "value":$("#<?= $lv_sec; ?> #crmcntmtvcod").prop("value")},
                                      {"name":"crmcntsrctyp", "value":$("#<?= $lv_sec; ?> #crmcntsrctyp").prop("value")},
                                      {"name":"crmcnthrs", "value":$(lv_frm).find("#crmcnthrs").prop("value")},
                                      {"name":"crmcntprg", "value":$("#<?= $lv_sec; ?> #crmcntprg").prop("value")},
                                      {"name":"sysdocclscod", "value":$("#<?= $lv_sec; ?> #sysdocclscod").prop("value")}
																			];
                      
                      var <?= $lv_sec; ?>_guardarCambios = function() {
                        // cambia el estado y responsable y crea un comentario
                        tmssCallProcessNoBackdrop("?prg=crmcnt&act=12", lv_pstdat, function(data){
                          dialog.close();
                        });
                        // actualiza las horas consumidas
                        if ($("#crmcnthrs").prop("value") > 0){
                          lv_pstdat[4]["value"] = $("#<?= $lv_sec; ?> #usrcod").prop("value");
                          tmssCallProcessNoBackdrop("?prg=crmcnt&act=13", lv_pstdat, function(data){ }); 
                        }
                        // actualiza el progreso
                        if ($(lv_frm).find("#crmcntprg").prop("value") != $("#<?= $lv_sec; ?> #crmcntprg").val()){
                          $("#<?= $lv_sec; ?> #crmcntprg").val($(lv_frm).find("#crmcntprg").prop("value"));
                          $("#<?= $lv_sec; ?> #usrcod").val(lv_usr);
                          $("#<?= $lv_sec; ?> #crmcntstscod").val(lv_stscod);
                          $("#<?= $lv_sec; ?> #crmcntststxt").val(lv_ststxt);
                          <?= $lv_sec; ?>_fnc({action: "00"});	// si hay cambio de progreso, graba el formulario
                        }else{
                          <?= $lv_sec; ?>_fnc({action: "99"});	// si no se cambia el progreso, no es necesario grabar el formulario y solo lo actualiza
                        }
                      }
                    	
                      if(lv_stscls == 1){
                        BootstrapDialog.show({
                          title: "<?= $vew_lang->closecontact; ?>",
                          message: "Finalizar&aacute; el contacto una vez pase al estado " + lv_ststxt.toUpperCase() + ". &iquest;Desea proceder?",
                          type: BootstrapDialog.TYPE_WARNING,
                          closable: true,
                          draggable: true,
                          size: BootstrapDialog.SIZE_NORMAL,
                          buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
                                    {	label: "<?= $vew_lang->yes; ?>", cssClass: "btn-warning",	action: function(confirmDialog){
                                        confirmDialog.close();
                                        <?= $lv_sec; ?>_guardarCambios();
                                      }
                                    }
                                   ]
                        });
                      }
                      else{
                        <?= $lv_sec; ?>_guardarCambios();
                      }
										}
									}],
				});
			});
		});
    //se asigna el responsable por defecto del motivo de contacto
		function <?= $lv_sec; ?>_getRes(lp_crmcntmtvcod){
      //obtiene la tabla de cambios de estado del motivo de contacto
    	tmssCallProcessNoBackdrop("?prg=crmcntmtv&act=mtvsts", [{name:'crmcntmtvcod',value:lp_crmcntmtvcod}], function( data ){
        //recorre la tabla
        for(var i=0; i<data.length; i++){
          //encuentra el registro sin codigo de inicio
          if(data[i]["crmcntstscodstr"] == 0){
            //revisa que el registro tenga atributos definidos
          	if(data[i]["crmcntmtvstsatr"] != ""){
              //si hay responsable por defecto lo obtiene y lo asigna
              $("#<?= $lv_sec; ?> #usrcod").val( $("<div>"+data[i]["crmcntmtvstsatr"]+"</div>").find("usrasg").text() );
            }
            break;
          }
        }
      });
    }
    </script>
  <script>
		// ------------------------------------------------------------------------
		// TIEMPOS
		// ------------------------------------------------------------------------
    
		<?= $lv_sec; ?>_refreshTable();
    $("#<?= $lv_sec; ?>_tab002").removeClass("active");

		// seleccionar. evento de seleccion en checkbox de registro de tiempos
		function <?= $lv_sec; ?>_attachEventReg() {
      $("#<?= $lv_sec; ?> #tblreg tbody tr").on("click",function(e){
        $(this).toggleClass("tmss-selected");
        if (e.target.nodeName != "INPUT"){
          if($(this).find("td input").prop("checked")==true){
            $(this).find("td input").prop("checked", false);
          }else{
            $(this).find("td input").prop("checked", true);
          } 
        }
        //Si todos están checkeados
        if($("#<?= $lv_sec; ?> #tblreg tbody tr td input:checked").length == $("#<?= $lv_sec; ?> #tblreg tbody tr td input").length){
          $("#<?= $lv_sec; ?> #btnsel").prop( "checked", true );
        }else{
          $("#<?= $lv_sec; ?> #btnsel").prop( "checked", false );
        }
      });
      
      //Botón de seleccionar/deseleccionar todos
      $("#<?= $lv_sec; ?> #btnsel").on("click",function(e){
        if($(this).is(":checked")){
          $("#<?= $lv_sec; ?> #tblreg tbody tr").addClass("tmss-selected"); 
          $("#<?= $lv_sec; ?> #tblreg tbody tr td input").prop( "checked", true );
        }else{
          $("#<?= $lv_sec; ?> #tblreg tbody tr").removeClass("tmss-selected");
          $("#<?= $lv_sec; ?> #tblreg tbody tr td input").prop( "checked", false );
        }
      });
    }
      
    // borrar. boton de borrar filas
    $("#<?= $lv_sec; ?> #btnrmvrows").on("click",function(e){
			var lv_codarr = [];
			$("#<?= $lv_sec; ?> #tblreg tbody tr td input:checked").each(function() {
				lv_codarr.push($(this).parent().parent().data("hhrtmeregcod"));
			});
			if (lv_codarr.length != 0){
				lv_post = [{"name":"hhrtmeregcod", "value":lv_codarr}];
				BootstrapDialog.show({
          title: "<?= $vew_lang->delete; ?>",
          message: "Se eliminar&aacute;n los registros seleccionados",
          draggable: true,
          buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialogItself){ dialogItself.close(); } },
                    {	label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success",	action: function(dialog){
                      tmssCallProcess("?prg=hhrtmereg&act=04", lv_post, function(data){});          
                      dialog.close();
                      <?= $lv_sec; ?>_refreshTable();
                    }
                  }],
				}); 
			}else{toastr.warning("Seleccione los registros que desee eliminar."); }
    });

		// refresh. actualiza el contenido de la tabla de tiempos
    function <?= $lv_sec; ?>_refreshTable() {
      //Espera antes de hacer un refresh para que se realicen todas las llamadas ajax
      setTimeout(function(){
        var lv_tothrs=0;
        tmssCallProcessNoBackdrop("?prg=hhrtmereg&act=08", [{name:"crmcntcod", value:$("#<?= $lv_sec; ?> #crmcntcod").prop("value")}], function(data){
          var lv_buffer = "<table id='tblreg' class='table table-condensed tmss-fixed-header'>"+
                            "<thead>"+
                              "<tr>"+
                                ("<?= !$lv_blc; ?>" ? "<th scope='col'><input id='btnsel' class='form-check-input row-select' type='checkbox'></th>" : "")+
                                "<th scope='col' ><?= $vew_lang->date; ?></th>"+
                                "<th scope='col' ><?= $vew_lang->user; ?></th>"+
                                "<th scope='col' ><?= $vew_lang->hours; ?></th>"+
                              "</tr>"+
                            "</thead>"+
                            "<tbody>";
          for(var i=0; i<data["data"].length; i++){
            var lv_hrsamnt = (data["data"][i]["hhrtmeregqty"].substr(0,1) == "." ? "0"+data["data"][i]["hhrtmeregqty"] : data["data"][i]["hhrtmeregqty"]);
            lv_tothrs += parseFloat(lv_hrsamnt,10);
            lv_date = new Date(data["data"][i]["hhrtmeregdte"]["date"].substr(0,10));
            lv_date.setDate(lv_date.getDate()+1); 
            lv_buffer+= "<tr data-hhrtmeregcod='"+data["data"][i]["hhrtmeregcod"]+"'>" +
                          ("<?= !$lv_blc; ?>" ? "<td class='hover'><input class='form-check-input row-select' type='checkbox'></td>" : "") +
                          "<td class='hover'>"+
                              (((lv_date.getDate()).toString().length)==1?"0"+(lv_date.getDate()):(lv_date.getDate()))+"/"+
                              (((lv_date.getMonth()+1).toString().length)==1?"0"+(lv_date.getMonth()+1):(lv_date.getMonth()+1))+"/"+
                              lv_date.getFullYear()+"</td>" +
                          "<td class='hover' data-hhrtmeregcod='"+data["data"][i]["hhrtmeregcod"]+"'>"+data["data"][i]["hhrtmesrccod001"]+"</td>" +
                          "<td class='hover text-right'>"+parseFloat(lv_hrsamnt,10).toFixed(1)+"</td>" +
                        "</tr>";
          }
          lv_buffer+="</tbody></table>";

          $("#<?= $lv_sec; ?> #regtble").empty();
          $("#<?= $lv_sec; ?> #regtble").append(lv_buffer);
          <?= $lv_sec; ?>_attachEventReg();
          $("#<?= $lv_sec; ?> #regtble").css({"max-height":"60vh"});

          $("#<?= $lv_sec; ?> #crmcntregtme").text(lv_tothrs>0 ? lv_tothrs.toFixed(1) : 0);
          if(lv_tothrs>=1 && <?= $vew_doc->getTagValue($vew_data->crmcntatr, 'esttme')!=''?1:0; ?> > 0) {
            var lv_hrsprcntge = Math.round(lv_tothrs.toFixed(1)/<?= ($vew_doc->getTagValue($vew_data->crmcntatr, 'esttme')!=''?$vew_doc->getTagValue($vew_data->crmcntatr, 'esttme'):'1'); ?>*100);
            $("#<?= $lv_sec; ?> #hrsprcntspan").text(lv_hrsprcntge);
            $("#<?= $lv_sec; ?> .tmss-crm-number2").css({"color": (lv_hrsprcntge > "100" ? "red" : "#2fa4e7")});
            $("#<?= $lv_sec; ?> .tmss-crm-circle-wrap .tmss-crm-circle .tmss-crm-mask .tmss-crm-fill2").css({"visibility":"visible", "background-color": (lv_hrsprcntge > "100" ? "red" : "#2fa4e7")});
            $("#<?= $lv_sec; ?> .tmss-crm-circle-wrap .tmss-crm-circle .tmss-crm-mask.tmss-crm-full2, .tmss-crm-circle-wrap .tmss-crm-circle .tmss-crm-fill2").css({ "animation": "fill ease-in-out 2.5s", "transform": "rotate("+(180 * (lv_hrsprcntge>=100?100:lv_hrsprcntge)) / 100+"deg)"});
            $("#<?= $lv_sec; ?> .tmss-crm-circle-wrap .tmss-crm-inside-circle2").css({"color": (lv_hrsprcntge > "100" ? "red !important" : "#2fa4e7 !important")});
          }else{
            $("#<?= $lv_sec; ?> .tmss-crm-number2").css({"color": "#2fa4e7"});
            $("#<?= $lv_sec; ?> .tmss-crm-circle-wrap .tmss-crm-circle .tmss-crm-mask .tmss-crm-fill2").css({"visibility": "hidden"});
          }
          if(<?= $vew_doc->getTagValue($vew_data->crmcntatr, 'prg')=='' || $vew_doc->getTagValue($vew_data->crmcntatr, 'prg')=='0' ? 0 : 1; ?> == 0) {
            $("#<?= $lv_sec; ?> .tmss-crm-circle-wrap .tmss-crm-circle .tmss-crm-mask .tmss-crm-fill1").css({"visibility": "hidden"});
          }else{
            $("#<?= $lv_sec; ?> .tmss-crm-circle-wrap .tmss-crm-circle .tmss-crm-mask .tmss-crm-fill1").css({"visibility": "visible"});
          }
        });
    	},250);
    }
      
    // agregar. muestra la vista para agregar registos de tiempo
    $("#<?= $lv_sec; ?> #btnaddrow").on("click",function(e){ e.preventDefault(); 
      lv_pstdat = [{ "name":"crmcntcod", "value":$("#<?= $lv_sec?> #crmcntcod").prop("value") }];
      tmssCallProcess("?prg=crmcnt&act=cntasgtme", lv_pstdat, function(data){
        BootstrapDialog.show({
          title: "<?= $vew_lang->add; ?>",
          message: $(data),
          draggable: true,
          closable: false,
          onshown: function(dialog){ dialog.$modalBody.find("#crmcnthrs:first").focus(); },
          buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialogItself){ dialogItself.close(); } },
                    {	label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success",	action: function(dialog){
                      var lv_frm = dialog.$modalBody;
                      var lv_crmcnthrs = $(lv_frm).find("#crmcnthrs").prop("value");
                      if (lv_crmcnthrs > 0){
                        var lv_cmtdte = $(lv_frm).find("#crmcntcmtdte").prop("value");
                        var lv_usr = $(lv_frm).find("#usrcod").prop("value");
                        var lv_pstdat =[{"name":"crmcntcmtdte","value":lv_cmtdte},
                                        {"name":"usrcod","value":lv_usr},
                                        {"name":"crmcntcod", "value":$("#<?= $lv_sec; ?> #crmcntcod").prop("value")},
                                        {"name":"crmcntmtvcod", "value":$("#<?= $lv_sec; ?> #crmcntmtvcod").prop("value")},
                                        {"name":"crmcntsrctyp", "value":$("#<?= $lv_sec; ?> #crmcntsrctyp").prop("value")},
                                        {"name":"crmcnthrs", "value":lv_crmcnthrs},
                                        {"name":"sysdocclscod", "value":$("#<?= $lv_sec; ?> #sysdocclscod").prop("value")}
                                        ];
                        tmssCallProcess("?prg=crmcnt&act=13", lv_pstdat, function(data){});           	          
                        dialog.close();
                        <?= $lv_sec; ?>_refreshTable(); 
                      }else{
                        toastr.warning("Introduzca un valor v&aacute;lido.");
                      }
                    }
                  }],
        });
      });
    });
    </script>
	<script>
		function <?= $lv_sec; ?>_refreshScreen() {
			$("#<?= $lv_sec; ?> #crmcntststxtlbl").html( ($("#<?= $lv_sec; ?> #crmcntststxt").val()!=""?$("#<?= $lv_sec; ?> #crmcntststxt").val():"&nbsp;") );
			var lv_btnnme = $("#<?= $lv_sec; ?> #crmcntmtvfrmnme").prop("value");
			lv_btnnme = (lv_btnnme=="" || lv_btnnme==undefined?"<?= $vew_lang->form; ?>":lv_btnnme);
			$("#<?= $lv_sec; ?> #btnfrmspan").text( " "+lv_btnnme );
			if ( $("#<?= $lv_sec; ?> #crmcntmtvfrm").prop("value")!="" ) {
				$("#<?= $lv_sec; ?> #btnfrm").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #btnfrm").addClass("hidden");
			}
			$("#<?= $lv_sec; ?> #divacttxt").text( $("#<?= $lv_sec; ?> #crmcntmtvact").prop("value") );
			if ( $("#<?= $lv_sec; ?> #crmcntmtvact").prop("value")!="" ) {
				$("#<?= $lv_sec; ?> #divact").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #divact").addClass("hidden");
			}
      lv_crmcntatrval=$("#crmcntatr").val();
      if ( $("<?= $vew_data->crmcntatr ?>").length >3) {
				$("#<?= $lv_sec; ?> #btnfrm").removeClass("btn-warning").addClass(" btn-success");
			}
		}

		// establece los valores del formulario
		function <?= $lv_sec; ?>_formSetData( lp_frm, lp_dat ) {
			var lv_dat = $('<div>'+lp_dat+'</div>');
			var lv_key = "";
			var lv_val = "";
      var lv_id ="";
			var lv_changing="";
			for( var i=0; i<$(lv_dat).children().length; i++ ) {
				lv_key = $(lv_dat).children().eq(i).prop("nodeName");
				lv_val = $(lv_dat).children().eq(i).text();
				lv_id = $("<div>"+lp_frm+"</div>").find("section").prop("id");
				if ( $(lp_frm).find("#"+lv_key.toLowerCase()).length!=0 ) {
					lv_changing = lv_changing + "$('#"+lv_id+"').find('#"+lv_key.toLowerCase()+"').prop('value','"+lv_val+"');";
				}
			}
			if ( lv_changing!="" ) { lv_changing = "<scr"+"ipt>"+lv_changing+"</scr"+"ipt>"; }
			return lp_frm + lv_changing;
		}

		// obtiene los valores del formulario
		function <?= $lv_sec; ?>_formGetData( lp_frm ) {
			if ( tmssCheckRequiredFields($(lp_frm))==true ) {
				var lv_buf = "";
				var lv_arr = $(lp_frm).serializeArray();
				for( var i=0; i<lv_arr.length; i++) {
					lv_buf += "<"+lv_arr[i]["name"]+">"+lv_arr[i]["value"]+"</"+lv_arr[i]["name"]+">";
				}
				return lv_buf;
			} else {
				return "";
			}
		}

		$("#<?= $lv_sec; ?> #btnfrm").on("click",function(e){e.preventDefault();
			var lv_frm = $("#<?= $lv_sec; ?> #crmcntmtvfrm").prop("value");
			lv_frm = lv_frm.toLowerCase();
			lv_frm = lv_frm.replace(/&amp;/g,"&");
			lv_frm = lv_frm.replace(/&lt;/g,"<");
			lv_frm = lv_frm.replace(/&gt;/g,">");
			lv_frm = lv_frm + "&prm_actcod=<?= $vew_actcod; ?>";
      if(lv_frm.includes("<crmcntsrccod>")){
        if($("#<?= $lv_sec; ?> #crmcntsrccod").prop("value")!=""){
        	lv_frm = lv_frm.replace(/\<crmcntsrccod\>/g,$("#<?= $lv_sec; ?> #crmcntsrccod").prop("value"));
        }else{
           toastr.warning("Debe completar "+ "<?= $lv_srclbl;?>"+".");
         	$("#<?= $lv_sec; ?> #crmcntsrctxt").closest(".form-group").addClass("has-error");
          return;
        }
      }
			tmssCallProcess( lv_frm, [], function( data ) {
				data = <?= $lv_sec; ?>_formSetData( data, $("#<?= $lv_sec; ?> #crmcntatr").text() );
				if ( data!="" ) {
					BootstrapDialog.show({
						title: $("#<?= $lv_sec; ?> #btnfrm").text(),
						message: $(data),
						size: BootstrapDialog.SIZE_WIDE,
						<?php if ( $vew_readonly ) { ?>
						buttons: [{ label: "Cerrar", cssClass: "btn-primary", action: function(dialogItself){dialogItself.close();} }]
						<?php } else { ?>
						buttons: [{ label: "Cancelar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
											{	label: "OK", cssClass: "btn-success",	action: function(dialogItself){
                        var lv_buf = <?= $lv_sec; ?>_formGetData( $(dialogItself.options.message[0]).find("form[id]")[0] );
												if (lv_buf=="") { return false; }
												$("#<?= $lv_sec; ?> #crmcntatr").text( lv_buf );
												$("#<?= $lv_sec; ?> #btnfrm").removeClass("btn-warning").addClass("btn-success");
												dialogItself.close();
											}
										}]
						<?php } ?>
					});
				}
			});
		});
		<?= $lv_sec; ?>_refreshScreen();
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			$("#<?= $lv_sec; ?> #crmcnttyptxt").prop("value", $("#<?= $lv_sec; ?> #crmcnttypcod :selected").text() );
			$("#<?= $lv_sec; ?> #crmcntprttxt").prop("value", $("#<?= $lv_sec; ?> #crmcntprtcod :selected").text() );
		}
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
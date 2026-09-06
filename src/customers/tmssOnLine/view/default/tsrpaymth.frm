<?php 
	/* url del formulario */
  $lv_lnk = "?prg=tsrpaymth&prm_paymthcod=".$vew_data->paymthcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('paymthtxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->paymthcod; 

	/* titulo */
	$lv_title = $vew_lang->paymentways;
	
	/* módulo y programa */
	$lv_mdlcod = 'TSR';
	$lv_prgcod = 'PMT';
	
	//carga los tongle de si es cobranza y/o pago
	$tsrpaymthatrtsrtid=($vew_doc->getTagValue($vew_data->tsrpaymthatr,'tsrtid')==1?'ON':'OFF');
	$tsrpaymthatrtsrtin=($vew_doc->getTagValue($vew_data->tsrpaymthatr,'tsrtin')==1?'ON':'OFF');
  $tsrpaymthatrtsrtou=($vew_doc->getTagValue($vew_data->tsrpaymthatr,'tsrtou')==1?'ON':'OFF');
	/* librería de estilos bootstrap */
  include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->paymthcod; ?><?=gethtml('paymthcod','hidden',$vew_data->paymthcod)?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">				
          <div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">  
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('paymthcodext','doccmt1x20', $vew_data->paymthcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('paymthtxt', 	'doccmt1x50', $vew_data->paymthtxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 			'docsts', 		$vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>           
            </div> 
            <div class="col-md-6">
             <div class="card">
              <div class="card-header">
               <div class="card-title">
                <?= $vew_lang->data; ?>
               </div>
              </div>
              <div class="card-body tmss-card-body-edit">
               <?php
                echo vew_boot($lv_col210, array('label'=>$vew_lang->type,'input'=>gethtml('paymthtyp', 'paymthtyp_lst',$vew_data->paymthtyp, $lv_default) ));
					      echo vew_boot(array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->RECEIVED,	'input'=>gethtml('tsrpaymthatrtsrtin', 'onoff', $tsrpaymthatrtsrtin == 'ON' ? '1':'0' , $lv_default) ));
                echo vew_boot(array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->PAYMENTS,	'input'=>gethtml('tsrpaymthatrtsrtou', 'onoff',$tsrpaymthatrtsrtou  == 'ON' ? '1':'0' , $lv_default) ));
                echo vew_boot(array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->DEPOSITS,	'input'=>gethtml('tsrpaymthatrtsrtid', 'onoff',$tsrpaymthatrtsrtid  == 'ON' ? '1':'0' , $lv_default) ));
              ?>
              </div>
             </div>
            </div>
          </div>
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
  <?php include('grldocfrmscr.frm'); ?>
</section>
<?php 
	// url del formulario
  $lv_lnk = '?prg=tsrmovtyp&prm_tsrmovtypcod='.$vew_data->tsrmovtypcod;

	// campos requeridos
	$vew_input->RequiredFields( array('tsrmovtyptxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->tsrmovtypcod; 

	// titulo
	$lv_title = $vew_lang->concept;
	
	// módulo y programa
	$lv_mdlcod = 'TSR';
	$lv_prgcod = 'TYP';
	
	// librería de estilos bootstrap
  include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->tsrmovtypcod; ?><?=gethtml('tsrmovtypcod','hidden',$vew_data->tsrmovtypcod)?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">				
          <div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">  
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('tsrmovtypcodext','doccmt1x20', $vew_data->tsrmovtypcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('tsrmovtyptxt', 	'doccmt1x50', $vew_data->tsrmovtyptxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 			'docsts', 		$vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>           
            </div> 
            <div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->data; ?></div></div>
								<div class="card-body tmss-card-body-edit">
									<?php
                    echo vew_boot($lv_col210, array('label'=>'Saldo',	'input'=>gethtml('tsrmovtypblc','doccmt1x20', $vew_data->tsrmovtypblc, $lv_default) ));
									?>
								</div>
							</div>
							
              <!-- CONTABILIDAD -->
              <div class="card"> 
								<div class="card-header"><div class="card-title"><?= $vew_lang->account; ?></div></div>
								<?php include('grldatacc.frm'); ?>
              </div>
            </div>
          </div>
					
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <?php include('grldocfrmscr.frm'); ?>
</section>
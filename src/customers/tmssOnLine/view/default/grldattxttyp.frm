<?php
	// librería de estilos bootstrap
	include_once('_library.frm');
		
	// url del formulario
  $lv_lnk = '?prg=grldattxttyp&prm_txttypcod='.$vew_data->txttypcod;

	// campos requeridos
	$vew_input->RequiredFields( array('txttyptxt','objtyp','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->txttypcod; 

	// titulo
	$lv_title = $vew_lang->type;
	
	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'TXY';
	
	// librería de estilos
  include_once('_library.frm');

	$lv_clsarr = array(''=>'','NWS'=>'Novedades','WWW'=>'Web','DSH'=>'Dashboard');

?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->txttypcod; ?><?= gethtml('txttypcod','hidden',$vew_data->txttypcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">	
          <div class="col-md-6">
            <div class="card">
              <div class="card-header">
                <div class="card-title"><?= $lv_title; ?></div>
              </div>
              <div class="card-body tmss-card-body-edit">
                <?php 
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 					'input'=>gethtml('txttypcodext','doccmt1x20', $vew_data->txttypcodext, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->description,		'input'=>gethtml('txttyptxt', 	'doccmt1x50', $vew_data->txttyptxt, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->classification, 'input'=>gethtml('txttypatrcls',$lv_clsarr, 	$vew_doc->gettagvalue($vew_data->txttypatr,'cls'), $lv_default) )); 
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->status,					'input'=>gethtml('docsts', 			'docsts', 		$vew_data->docsts, $lv_default) ));
                ?>
              </div>
            </div>
          </div>
				</div> <!-- /_tab001 -->
				
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
		
  </form>
  <?php include('grldocfrmscr.frm'); ?>
</section>
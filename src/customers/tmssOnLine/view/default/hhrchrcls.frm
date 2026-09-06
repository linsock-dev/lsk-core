<?php		
	/* url del formulario */
  $lv_lnk = '?prg=hhrchrcls&prm_hhrchrclscod='.$vew_data->hhrchrclscod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('hhrchrclstxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->hhrchrclscod;

	/* titulo */
	$lv_title = $vew_lang->chargesclass;
	
	/* módulo y programa */
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'CHS';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hhrchrclscod; ?><?= gethtml('hhrchrclscod','hidden',$vew_data->hhrchrclscod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('hhrchrclscodext', 'doccodext', $vew_data->hhrchrclscodext, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hhrchrclstxt', 'doccmt1x50', $vew_data->hhrchrclstxt, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
                </div>
              </div>
						</div>
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->data; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                	<?php
                  	echo vew_boot($lv_col210, array('label'=>'Asig.Horas', 					'input'=>gethtml('hhrchrclsatrtmeasg',array(''=>'','M'=>'MANUAL','C'=>'CONTROL HORAS','S'=>'SIN ASIGNACION'), $vew_doc->getTagValue($vew_data->hhrchrclsatr,'tmeasg'), $lv_default, true) ));
                    echo vew_boot($lv_col210, array('label'=>'Det.Antig&uuml;edad', 'input'=>gethtml('hhrchrclsatroldasg',array(''=>'','C'=>'MANUAL POR CLASE','H'=>'MANUAL POR CARGO','P'=>'MANUAL POR PERSONA','S'=>'SIN ASIGNACION'), $vew_doc->getTagValue($vew_data->hhrchrclsatr,'oldasg'), $lv_default, true) ));
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
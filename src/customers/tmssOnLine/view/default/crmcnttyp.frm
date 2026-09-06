<?php
	// url del formulario
  $lv_lnk = '?prg=crmcnttyp&prm_crmcnttypcod='.$vew_data->crmcnttypcod;

	// campos requeridos
	$vew_input->RequiredFields( array( 'crmcnttyptxt', 'docsts') );

	// clave del documento
	$lv_dockey = $vew_data->crmcnttypcod; 

	// titulo
	$lv_title = $vew_lang->contacttype;
	
	// modulo y programa
	$lv_mdlcod = 'CRM';
	$lv_prgcod = 'TYP';
		
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->crmcnttypcod; ?><?= gethtml('crmcnttypcod', 'hidden', $vew_data->crmcnttypcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit"> 
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('crmcnttypcodext', 'doccmt1x20',	$vew_data->crmcnttypcodext,	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('crmcnttyptxt', 		'doccmt1x50',	$vew_data->crmcnttyptxt, 		$lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 					'docsts', 		$vew_data->docsts, 					$lv_default) )); 
                  ?>
						    </div>
							</div>
						</div>
            <div class="col-sm-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->data; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->authorizationcode, 'input'=>gethtml('autcod','autcod', $vew_data->autcod, $lv_default ) ));									
										echo vew_boot($lv_col210, array('label'=>$vew_lang->color,    'input'=>gethtml('crmcnttypatrclr','bg-color', $vew_doc->getTagValue($vew_data->crmcnttypatr,'clr'), $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->sortorder,	'input'=>gethtml('crmcnttypatrord','docnum0300', $vew_doc->getTagValue($vew_data->crmcnttypatr,'ord'), 	$lv_default) ));
                  ?>
                </div>
							</div>
            </div>
					</div>
				</div>
			</div> <!-- /tab-content -->
		</div> <!-- /tabpanel -->
  </form>
	<script>
		$(function(){ $("#<?= $lv_sec; ?> #crmcnttypatrclr").trigger("change"); });
		$("#<?= $lv_sec; ?> #crmcnttypatrclr").on("change",function(){
			if($(this).val()==""){
				$(this).css("background-color","");
				$(this).css("color","");
			} else {
				$(this).css("background-color","var("+$(this).val()+")");
				$(this).css("color","var("+$(this).val()+"-text)");
			}
		});
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
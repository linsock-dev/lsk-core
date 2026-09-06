<?php
	// url del formulario
  $lv_lnk = '?prg=finlocargcai';

	// campos requeridos 
	$vew_input->RequiredFields( array('slspostxt','sysdocclstxt','argltrcodext','docsts','argcaicodext','argcaiduedte') );

	// clave del documento 
	$lv_dockey = $vew_data->argcaicod; 

	// titulo
	$lv_title = 'CAI'/*$vew_lang->reportsource*/;
	
	// modulo y programa 
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'ARCAI';
	
	// libreria de estilos bootstrap 
	include_once('_library.frm');
	
	// Botones x Vista 
	$vew_tbl['cpy'] = array('per'=>false);
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden','') ?>
		<textarea class="hidden" id="argltrrules"></textarea>
		
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->argcaicod; ?><?= gethtml('argcaicod','hidden',$vew_data->argcaicod) ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
              	<div class="card-header">
                	<div class="card-title"><?= $lv_title; ?>
                  </div>
								</div>
								<div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col39, array('label'=>$vew_lang->PointOfSales, 	'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('slspostxt', 'doccmt1x20', $vew_data->slspostxt, $lv_default) )) ));
                  	echo gethtml('slsposcod', 'hidden', $vew_data->slsposcod);

                    echo vew_boot($lv_col39, array('label'=>$vew_lang->documentclass, 	'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('sysdocclstxt', 'doccmt1x20', $vew_data->sysdocclstxt, $lv_default) )) ));
										echo gethtml('sysdocclscod', 'hidden', $vew_data->sysdocclscod);

                    echo vew_boot($lv_col39, array('label'=>$vew_lang->letter, 	'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('argltrcodext', 'doccmt1x2', $vew_data->argltrcodext, $lv_always_disabled) )) ));
                  	echo gethtml('argltrcod', 'hidden', $vew_data->argltrcodext);

                    echo vew_boot($lv_col39, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 		'docsts', 		$vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
						</div>
						<div class="col-md-6">
              <div class="card">
              	<div class="card-header">
                	<div class="card-title"><?= $vew_lang->data; ?>
                  </div>
								</div>
								<div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->authorization,	'input'=>gethtml('argcaicodext', 'doccmt1x20', $vew_data->argcaicodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->duedate,	'input'=>gethtml('argcaiduedte', 'docdte', $vew_data->argcaiduedte, $lv_default) ));
                  ?>
                </div>
              </div>
						</div>
					</div>
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form><!-- Form Submit -->
  
  <script>
    // slspostxt
    var lo_get = {"fldsec":"<?=$lv_sec;?>", "fldasg": {"slsposcod":"slsposcod", "slspostxt":"slspostxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #slspostxt"), "slspos", lo_get);
    
    // sysdocclstxt
    var lo_get = {"fldsec":"<?=$lv_sec;?>", "fldasg": {"sysdocclstxt":"sysdocclstxt", "sysdocclscod":"sysdocclscod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #sysdocclstxt"), "sysdoccls", lo_get);
    
		// argltrcod
    var lo_get = {"fldsec":"<?=$lv_sec;?>", "fldasg": {"argltrcod":"argltrcodext", "argltrcodext":"argltrcodext"}, "typeahead":false};
    tmssTypeahead($("#<?= $lv_sec; ?> #argltrcodext"), "finlocargltr", lo_get);
  </script>
   <!-- Form Submit -->
	<?php include('grldocfrmscr.frm'); ?>
</section>
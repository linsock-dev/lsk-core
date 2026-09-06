<?php 
	/* url del formulario */
  $lv_lnk = "?prg=sysdocsts&prm_sysdocstscod=".$vew_data->sysdocstscod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('sysdocststxt','objtypcod','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->sysdocstscod; 

	/* titulo */
	$lv_title = $vew_lang->message;
	
	/* módulo y programa */
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'DCS';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
   	<?= gethtml('tmss_actcod', 'hidden', ''); ?>
    
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		    
    <div class="container-fluid" role="tabpanel">
      
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->sysdocstscod; ?><?= gethtml('sysdocstscod', 'hidden', $vew_data->sysdocstscod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
              	<div class="card-header">
                	<div class="card-title"><?= $vew_lang->DOCUMENTSTATUS; ?>
                  	<span class="tmss-card-icon"><i class="fas fa-asterisk"></i></span>
                  </div>
								</div>
								<div class="card-body tmss-card-body-edit">
                	<?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 		'input'=>gethtml('sysdocstscodext', 'doccodext', $vew_data->sysdocstscodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('sysdocststxt', 'doccmt1x50', $vew_data->sysdocststxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
              	</div>
              </div>
						</div>
						<div class="col-md-6">
              <div class="card">
              	<div class="card-header">
                	<div class="card-title"><?= $vew_lang->data; ?>
                  	<span class="tmss-card-icon"><i class="fas fa-file-invoice"></i></span>
                  </div>
								</div>
								<div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->object, 'input'=>gethtml('objtypcod','objtypcod_lst', $vew_data->objtypcod, ($vew_data->sysdocstscod==''?$lv_default:$lv_always_disabled) ) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->authorizationcode, 'input'=>gethtml('autcod', 'autcod', $vew_data->autcod, $lv_default) ));
                  ?>
                </div>  
              </div>
						</div>
					</div>
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
  <!-- Form Submit -->
	<?php include('grldocfrmscr.frm'); ?>
</section>
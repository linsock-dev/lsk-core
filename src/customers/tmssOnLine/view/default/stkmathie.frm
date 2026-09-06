<?php		
	/* url del formulario */
  $lv_lnk = '?prg=stkmathie&prm_mathiecod='.$vew_data->mathiecod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('mathietxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->mathiecod;

	/* titulo */
	$lv_title = $vew_lang->hierarchy;
	
	/* m?dulo y programa */
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'HIE';
	
	/* librer?a de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		    
    <div class="container-fluid" role="tabpanel">

			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->mathiecod; ?><input type="hidden" id="mathiecod" name="mathiecod" value="<?= $vew_data->mathiecod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              <div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $vew_lang->hierarchy; ?>
										<span class="tmss-card-icon">
                      <i class="fas fa-user"></i>
										</span>
                    </div>
									</div> 
                    <div class="card-body tmss-card-body-edit">
                    <?php 
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->code,					'input'=>gethtml('mathiecodext','doccmt1x20', $vew_data->mathiecodext,$lv_default) ));
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->description,  'input'=>gethtml('mathietxt', 	'doccmt1x50', $vew_data->mathietxt, 	$lv_default) )); 
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			  'input'=>gethtml('docsts', 			'docsts', $vew_data->docsts, 			$lv_default) ));
                    ?>
                  </div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $vew_lang->data; ?>
										<span class="tmss-card-icon">
                      <i class="fas fa-user"></i>
										</span>
                    </div>
									</div> 
                    <div class="card-body tmss-card-body-edit">
                    <?php
                      echo vew_boot($lv_col237, array('label'=>$vew_lang->topfolder, 
                                                      'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->mathiecod!=''?true:$vew_readonly)), 
                                                                          array('input'=>gethtml('mathiepar', 'doccod', $vew_data->mathiepar, ($vew_data->mathiecod!=''?$lv_always_disabled:$lv_default) ) )
                                                                        ),
                                                      'input2'=>gethtml('mathiepartxt',	'doccmt1x50',	$vew_data->mathiepartxt, $lv_always_disabled)
                                                      )
                                    );
                    ?>
                  </div>
                </div>
              </div>
            </div>					
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
		// mathiepar
		$("#<?= $lv_sec; ?> #mathiepar")
			.on("keyup", function(){ if($(this).prop("value")==""){$("#<?= $lv_sec; ?> #mathiepartxt").prop("value","");} })
			.next("span").children("a:first").on("click", function(evt) {
				tmssPopup("Jerarqu&iacute;as","index.php?prg=stkmathie&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[mathiepar:mathiecod],[mathiepartxt:mathietxt]");
				evt.preventDefault();
			});
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
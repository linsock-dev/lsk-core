<?php
	// url del formulario
  $lv_lnk = '?prg=edutchprc&prm_tchprccod='.$vew_data->tchprccod;

	// campos requeridos
	$vew_input->RequiredFields( array('tchprctyp','tchprcval','curcod','tchprcdtestr','tchprcdteend','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->tchprccod;

	// titulo 
	$lv_title = $vew_lang->prices;
	
	// módulo y programa
	$lv_mdlcod = 'EDU';
	$lv_prgcod = 'RPR';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
  	<?php
    	echo gethtml('tmss_actcod', 'hidden', '');
      echo gethtml('educurcod', 	'hidden', $vew_data->educurcod);
    	echo gethtml('educarcod', 	'hidden', $vew_data->educarcod);
    	echo gethtml('educoucod', 	'hidden', $vew_data->educoucod);
    	echo gethtml('edusubcod', 	'hidden', $vew_data->edusubcod);
    	echo gethtml('educurplncod', 	'hidden', $vew_data->educurplncod);
    	echo gethtml('tchcod', 			'hidden', $vew_data->tchcod);
		?>								
    <div class="container-fluid" role="tabpanel">
      	<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->tchprccod; ?><?= gethtml( 'tchprccod' , 'hidden', $vew_data->tchprccod ); ?></strong></h4></li>
			</ul>
      <div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->price; ?></div></div>   
                <div class="card-body tmss-card-body-edit">
                 	<?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 			'input'=>gethtml('tchprctyp', 'tchprctyp_lst', $vew_data->tchprctyp, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->teacher,		'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('tchtxt', 'doccmt1x50', $vew_data->tchtxt, $lv_default)) )));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->curriculum, 'input2'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('educurtxt', 'doccmt1x50', $vew_data->educurtxt, $lv_default)) )));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->career, 		'input3'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('educartxt', 'doccmt1x50', $vew_data->educartxt, $lv_default)) )));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->course, 		'input4'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('educoutxt', 'doccmt1x50', $vew_data->educoutxt, $lv_default)) )));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->subject, 		'input5'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('edusubtxt', 'doccmt1x50', $vew_data->edusubtxt, $lv_default)) )));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->attendance,	'input'=>gethtml('edustuass', 'tchprcass_lst', $vew_data->edustuass, $lv_default) ));                  	
                  ?>
                </div>
              </div> <!-- /card -->
            </div>
             <div class="col-md-6">
              <div class="card">
                <div class="card-body tmss-card-body-edit">
                 	<?php
											echo vew_boot($lv_col273, array('label'=>$vew_lang->value,	
																								'input1'=>gethtml('tchprcval', 'docqty', $vew_data->tchprcval, $lv_default),
                                                'input2'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                                                         array('input'=>gethtml('curcod', 'curcod', $vew_data->curcod, $lv_default) )) ));
											echo vew_boot($lv_col210, array('label'=>$vew_lang->start,	'input'=>gethtml('tchprcdtestr', 'docdte', $vew_data->tchprcdtestr, $lv_default) ));
											echo vew_boot($lv_col210, array('label'=>$vew_lang->end,		'input'=>gethtml('tchprcdteend', 'docdte', $vew_data->tchprcdteend, $lv_default) ));
											echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
                </div>
              </div> 
            </div> 
          </div> <!-- /row --> 
				</div> <!-- /tap-pane -->
			</div> <!-- /tab-content -->
		</div> <!-- /container-fluid -->
  </form>
	<script>
    //PLAN DE ESTUDIOS
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"c.docsts":"A"}, "fldasg":{"educurcod":"c.educurcod", "educurtxt":"c.educurtxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #educurtxt"), 'educurcur', lo_get);
    
    //CARRERA -> filtro plan de estudio
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"a.docsts":"A", "c.educurcod": $("#<?= $lv_sec; ?> #educurcod")}, "fldasg":{"educurplncod":"cp.educurplncod","educartxt":"a.educartxt", "educarcod":"a.educarcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #educartxt"), 'educurcar', lo_get);
    
    //CURSOS -> filtro plan de estudio, carrera
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"o.docsts":"A", "c.educurcod": $("#<?= $lv_sec; ?> #educurcod"),"cp.educurplncod": $("#<?= $lv_sec; ?> #educurplncod"),"a.educarcod": $("#<?= $lv_sec; ?> #educarcod")}, "fldasg" : {"educoutxt":"o.educoutxt", "educoucod" : "o.educoucod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #educoutxt"), "educurcou", lo_get);
    
    //MATERIA -> filtro plan de estudio, carrera, cursos
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"s.docsts":"A", "c.educurcod": $("#<?= $lv_sec; ?> #educurcod"),"cp.educurplncod": $("#<?= $lv_sec; ?> #educurplncod"),"a.educarcod": $("#<?= $lv_sec; ?> #educarcod"),"o.educoucod": $("#<?= $lv_sec; ?> #educoucod")}, "fldasg" : {"edusubtxt":"edusubtxt", "edusubcod" : "edusubcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #edusubtxt"), "educursub", lo_get);

    //PROFESOR
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"t.docsts":"A"}, "fldasg":{"tchcod":"tchcod", "tchtxt":"tchtxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #tchtxt"), 'edutch', lo_get);
    
    // educurcod
		$("#<?= $lv_sec; ?> #curcod")
			.next("span").children("a:first").on("click", function(e) { e.preventDefault();
				tmssPopup("Monedas","index.php?prg=admcur&prm_vewcod=VEW_ADM_CUR_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[curcod:curcod]");
			});
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
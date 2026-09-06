<?php
	// url del formulario
  $lv_lnk = '?prg=eduplnpre&prm_eduplnprecod='.$vew_data->eduplnprecod;

	// campos requeridos
	$vew_input->RequiredFields( array('stucod','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->eduplnprecod;

	// titulo 
	$lv_title = $vew_lang->preregister;
	
	// m?dulo y programa
	$lv_mdlcod = 'EDU';
	$lv_prgcod = 'PLP';

	// librer?a de estilos bootstrap
	include_once('_library.frm');
	
	// valores x default
	if( $vew_data->eduplnprecod=='' ){
		$vew_data->eduplnpredte = date('d/m/Y');
	}	
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <!-- Inputs para el plan de estudio -->
    <?php
    	echo gethtml('tmss_actcod','hidden','');
    	echo gethtml('eduplnprecod', 'hidden', $vew_data->eduplnprecod);
    	echo gethtml('educurplncod', 'hidden',	$vew_data->educurplncod); // Plan de Estudio Tabla
    	echo gethtml('educurcod', 'hidden', $vew_data->educurcod); // Plan Estudio
    	echo gethtml('educarcod', 'hidden', $vew_data->educarcod); // Carrera
    	echo gethtml('educoucod', 'hidden', $vew_data->educoucod); // Curso
    	echo gethtml('edusubcod', 'hidden', $vew_data->edusubcod); // Materia			
    	echo gethtml('stdloccod', 'hidden', $vew_data->stdloccod); // Lugar
    	echo gethtml('stucod', 'hidden',	$vew_data->stucod); // Alumno
    ?>
		
    <div class="container-fluid" role="tabpanel">
      <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
       	<li class="pull-right"><h4># <strong><?= $vew_data->eduplnprecod ?><?= gethtml('eduplnprecod','hidden',$vew_data->eduplnprecod); ?></strong></h4></li>
      </ul>
			<div class="tab-content tmss-tab-content">
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">   
            <div class="col-md-6">
							
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->students; ?> 
									 <span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                    <?php 
                      echo gethtml('sysdocclstxt', 'hidden', $vew_data->sysdoccls->sysdocclstxt);
                      echo gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);
                    ?>
									</div>	
                </div>
                <div class="card-body tmss-card-body-edit">
                 <?php
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->date,
                                        'input1'=>vew_boot(array('style'=>'search','readonly'=>$lv_default),   
                                                           array('input'=>gethtml('eduplnpredte', 'docdte', $vew_data->eduplnpredte, $lv_default)) )));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->student, 		
                                        'input1'=>vew_boot( array('style'=>'search','readonly'=>$vew_readonly), 																				
                                                           	array('input'=>gethtml('stutxt', 'typeahead', $vew_data->stutxt, $lv_default) )) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status,'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
								</div> 
							</div> <!-- /card -->
                
						</div>
            
            <div class="col-md-6">
							
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->PREINSCRIPTIONS; ?>
									</div>	
                </div>
                <div class="card-body tmss-card-body-edit">
                 <?php
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->curriculum,
																				'input1'=>vew_boot(	array('style'=>'search','readonly'=>$vew_readonly),
																														array('input'=>gethtml('educurtxt', 'typeahead', $vew_data->educurtxt, $lv_default) )) ));
                                                    
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->career,
																				'input1'=>vew_boot( array('style'=>'search','readonly'=>$vew_readonly),
                                        	                  array('input'=>gethtml('educartxt', 'typeahead', $vew_data->educartxt, $lv_default) )) ));
                  
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->course,
                                          'input1'=>vew_boot( array('style'=>'search','readonly'=>$vew_readonly),
                                                              array('input'=>gethtml('educoutxt', 'typeahead', $vew_data->educoutxt, $lv_default) )) ));

                    echo vew_boot($lv_col210, array('label'=>$vew_lang->subject,
                                          'input1'=>vew_boot( array('style'=>'search','readonly'=>$vew_readonly),
                                                              array('input'=>gethtml('edusubtxt', 'typeahead', $vew_data->edusubtxt, $lv_default) )) ));
                  	
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->place, 		
                                          'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
																															array('input'=>gethtml('stdloctxt', 'typeahead', $vew_data->stdloctxt, $lv_default) )) )); 
                  ?>
								</div> 
							</div> <!-- /card -->
                
						</div>
            
					</div> <!-- /row -->
				</div> <!-- /tab-panel -->
			</div> <!-- /tab-content -->    
    </div> <!-- /container-fluid -->
  </form>
<script>
  	//PLAN DE ESTUDIOS
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"c.docsts":"A"}, "fldasg":{"educurcod":"educurcod", "educurtxt":"educurtxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #educurtxt"), "educurcur", lo_get, {"afterAssign" : function(){ 
			$("#<?= $lv_sec; ?> #educarcod").prop("value",""); 
			$("#<?= $lv_sec; ?> #educartxt").prop("value",""); 
			$("#<?= $lv_sec; ?> #educoucod").prop("value",""); 
			$("#<?= $lv_sec; ?> #educoutxt").prop("value",""); 
			$("#<?= $lv_sec; ?> #edusubcod").prop("value",""); 
			$("#<?= $lv_sec; ?> #edusubtxt").prop("value",""); 
		}});
		
    //CARRERA -> filtro plan de estudio
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"a.docsts":"A", "c.educurcod": $("#<?= $lv_sec; ?> #educurcod")}, "fldasg":{"educartxt":"educartxt", "educarcod":"educarcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #educartxt"), "educurcar", lo_get, {"afterAssign" : function(){ 
			$("#<?= $lv_sec; ?> #educoucod").prop("value",""); 
			$("#<?= $lv_sec; ?> #educoutxt").prop("value",""); 
			$("#<?= $lv_sec; ?> #edusubcod").prop("value",""); 
			$("#<?= $lv_sec; ?> #edusubtxt").prop("value",""); 
		}});
		
    //CURSOS -> filtro plan de estudio, carrera
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"o.docsts":"A", "c.educurcod": $("#<?= $lv_sec; ?> #educurcod"),"a.educarcod": $("#<?= $lv_sec; ?> #educarcod")}, "fldasg" : {"educoutxt":"educoutxt", "educoucod" : "educoucod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #educoutxt"), "educurcou", lo_get, {"afterAssign" : function(){ 
			$("#<?= $lv_sec; ?> #edusubcod").prop("value",""); 
			$("#<?= $lv_sec; ?> #edusubtxt").prop("value",""); 
		}});
		
    //MATERIA -> filtro plan de estudio, carrera, cursos
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"s.docsts":"A", "c.educurcod": $("#<?= $lv_sec; ?> #educurcod"),"a.educarcod": $("#<?= $lv_sec; ?> #educarcod"),"o.educoucod": $("#<?= $lv_sec; ?> #educoucod")}, "fldasg" : {"educurplncod":"educurplncod", "edusubcod":"edusubcod", "edusubtxt":"edusubtxt"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #edusubtxt"), "educursub", lo_get);
		
  	//ESTUDIANTE	
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"p.docsts":"A"}, "fldasg":{"stucod":"stucod", "stutxt":"stutxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #stutxt"), "edustu", lo_get);
		
  	//LUGAR DE ESTUDIO
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"s.docsts":"A"}, "fldasg":{"stdloccod":"stdloccod", "stdloctxt":"stdloctxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #stdloctxt"), 'edustdloc', lo_get);
	</script>
  <?php include('grldocfrmscr.frm'); ?>	
</section>
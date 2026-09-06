<?php
	// url del formulario 
  $lv_lnk = "?prg=cnsras&prm_rascod=".$vew_data->rascod;

	// campos requeridos 
	$vew_input->RequiredFields( array('mattxt','matcod','srcobjtyp','srcobjtxt','srcobjcod','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->rascod; 

	// titulo 
	$lv_title = $vew_lang->assignation;
	
	// módulo y programa 
	$lv_mdlcod = 'CNS';
	$lv_prgcod = 'RAS';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	 <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->assignation; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->rascod; ?><?= gethtml('rascod','hidden',$vew_data->rascod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                  		echo gethtml('matcod','hidden',$vew_data->matcod);
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->material, 
                                                      'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                  array('input'=>gethtml('mattxt', 'mattxt', $vew_data->mattxt, $lv_default) )
                                                                  )
                                                      )
                                    );
                  		echo gethtml('srcobjtyp','hidden',$vew_data->srcobjtyp);
                      echo vew_boot($lv_col210, array("label"=>$vew_lang->object, 'input'=>gethtml('srcobjtyptxt', 'doccmt1x50', 'Usuario', $lv_always_disabled) )); 
                      echo vew_boot($lv_col237, array('label'=>$vew_lang->code,
                                                      'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                  				array('input'=>gethtml('srcobjcod', 'doccmt1x20', $vew_data->srcobjcod, $lv_always_disabled) )
                                                                  			),
                                                      'input2'=>gethtml('srcobjtxt', 'doccmt1x50', $vew_data->srcobjtxt, $lv_always_disabled)
                                                      ));
      								echo vew_boot($lv_col210, array("label"=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); 
                  ?>
                </div>
              </div>
            </div>
          </div>
        </div> <!-- fin _tab001 -->

        <!-- DATOS ADICIONALES -->	
      </div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
    
  </form>
  <script>    
    // typeahead srcobjtxt 
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"srcobjcod":"usrcod", "srcobjtxt":"usrtxt"}, "typeahead":false};
    tmssTypeahead($("#<?= $lv_sec; ?> #srcobjcod"), "syssecusr", lo_get);

		// FALTA: deberían ser materiales no relevantes para stock que no tengan BOMs
    // typeahead mattxt
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"m.docsts":"A"}, "fldasg":{"matcod":"matcod", "mattxt":"mattxt", "matuntcod":"matuntcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #mattxt"), "stkmat", lo_get);
  </script>
  <?php include('grldocfrmscr.frm');?>
</section>
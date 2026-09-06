<?php
	// url del formulario
  $lv_lnk = "?prg=hltspcstd&prm_spcstdcod=".$vew_data->spcstdcod; 

	// campos requeridos
	$vew_input->RequiredFields( array('spcstdtxt','spccod','spctxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->spcstdcod; 

	// titulo
	$lv_title = $vew_lang->specialty;
	
	// m�dulo y programa
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'STD';

	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
     <?= gethtml('tmss_actcod', 'hidden', ''); ?>
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->spcstdcod; ?><?= gethtml('spcstdcod', 'hidden', $vew_data->spcstdcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->study; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                	<?php 
                  		echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 				'input'=>gethtml('spcstdcodext', 'doccmt1x20', $vew_data->spcstdcodext, $lv_default) ));
                 		 	echo vew_boot($lv_col210, array('label'=>$vew_lang->description,	'input'=>gethtml('spcstdtxt', 'doccmt1x50', $vew_data->spcstdtxt, $lv_default) ));
											echo vew_boot($lv_col210, array('label'=>$vew_lang->specialty,    'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
																																																						array('input'=>gethtml('spctxt', 'typeahead', $vew_data->spctxt,$lv_default) )) ));
											echo gethtml('spccod','hidden',$vew_data->spccod);
                  		echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
						</div>
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->comments; ?></div></div>
								<div class="card-body tmss-card-body-edit">
									<textarea id="<?= $lv_sec ?>_txt" name="spcstdcmt"><div><?= $vew_data->spcstdcmt; ?></div></textarea>
								</div>
							</div><!-- /card -->
						</div><!-- /col -->
					</div><!-- /row -->
				</div> <!-- /_tab001 -->				
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form> 
  <script>
    // SPCTXT
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"docsts": "A"}, "fldasg": {"spccod":"spccod", "spctxt":"spctxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #spctxt"), "hltspc", lo_get,{});
	
    tmssLoadScript("tinymce",function(){
			tinyMCE.init({ 
				selector: "#<?= $lv_sec ?>_txt",
				language: 'es',
				height: 350, 
				menubar: false,
				toolbar: false,
				<?= $vew_readonly ? 'readonly: 1': ''?>				
				<?php if(!$vew_readonly){?>
					plugins: ['importcss searchreplace autolink autosave save directionality visualblocks visualchars image link media template codesample charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists wordcount imagetools textpattern noneditable help charmap emoticons'],
					menubar: 'edit view insert format table tc',
					toolbar: 'undo redo | bold italic underline strikethrough | fontselect fontsizeselect formatselect | alignleft aligncenter alignright alignjustify | outdent indent |  numlist bullist checklist | forecolor backcolor casechange permanentpen  removeformat | charmap emoticons | fullscreen  preview print | insertfile image media  link codesample | showcomments addcomment',
					buttons: [{ label: "<?= $vew_readonly ? $vew_lang->close : $vew_lang->cancel ?>", cssClass: "btn-danger", action: function(dialog){ 
										tinyMCE.remove()
										dialog.close(); 
										} },
									<?php if(!$vew_readonly){ ?>
									{	label: "<?= $vew_lang->accept ?>", cssClass: "btn-success",	action: function(dialog){
											tinyMCE.triggerSave();
											var lv_sec = dialog.getModalBody().find("section:first").prop("id");
											tinyMCE.remove()
											dialog.close();
									}
									}<?php } ?>]
				<?php } ?>
			});
		});  
  </script>
  <script>
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if(lp_prm["action"]=="00"){
        tinyMCE.triggerSave();
			}
		}
  </script>	
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
<?php		
	// url del formulario
  $lv_lnk = '?prg=grlnws&prm_nwscod='.$vew_data->nwscod;

	// campos requeridos
	$vew_input->RequiredFields( array('nwstxt','txttypcod','lngcod','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->nwscod; 

	// titulo
	$lv_title = $vew_lang->news;
	
	// modulo y programa
	$lv_mdlcod = 'GRL';
	$lv_prgcod = 'NWS';
	
	// array de tipos de texto
	$lv_txttyp = array(''=>'');
	foreach($vew_data->txttyp as $lv_row){
    $lv_txttyp[$lv_row['txttypcod']] = $lv_row['txttyptxt']; 
  }
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  
	<style>
		.preview .modal-dialog { width: 70%; height:70%; }
	</style>	
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
    <?= gethtml('txtcod', 'hidden', '') ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->nwscod; ?><?= gethtml('nwscod', 'hidden', $vew_data->nwscod);?></strong></h4></li>
			</ul>      
			<div class="tab-content tmss-tab-content">
				
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
            <div class="col-md-4">
              <div class="card">
              	<div class="card-header">
                  <div class="card-title"><?= $lv_title; ?>
                  	<span class="tmss-card-icon">
                      <?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?> 
                      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
                    </span>
                  </div>
								</div>
              	<div class="card-body tmss-card-body-edit">
                  <?php
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->date,	'input'=>gethtml('nwsdte', 'docdte', $vew_data->nwsdte, $lv_default)));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->title,		'input'=>gethtml('nwstxt', 	'doccmt1x250', $vew_data->nwstxt, 	$lv_default)));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->category, 'input'=>gethtml('txttypcod', $lv_txttyp, $vew_data->txtcod, $lv_default)));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,		'input'=>gethtml('docsts', 		'docsts', $vew_data->docsts, 		$lv_default)));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->language,	'input'=>gethtml('lngcod', 		'lngcod', $vew_data->lngcod, 		$lv_default)));
                  ?>
                </div>
              </div>
						</div>
            
            <div class="col-md-8">
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $vew_lang->NWSIMAGE; ?></div></div>
              	<div class="card-body tmss-card-body-edit">
                  <div class="col-xs-4"><?php include('grldatuplshwpth.frm'); ?></div>
                  <div class="col-xs-8"><?= vew_boot($lv_col12, array('input'=>gethtml('nwsmsg', 'doccmt4x50', $vew_data->nwsmsg, $lv_default))); ?></div>
                </div>
              </div>
						</div>
            
            <div class="col-md-12">
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $vew_lang->NOVELTY; ?><a href="#" id="btnmdl" class="card-icon tmssHiddeOnRead" title="<?= $vew_lang->model; ?>"><i class="fas fa-book"></i></a></div></div>
              	<div class="card-body tmss-card-body-edit">
                  <div id="preview" class="grlnws_containerpreview">
                    <textarea id="<?= $lv_sec ?>_txt" name="grlnwsbdy">
                      <div><?= isset($vew_data->grlnwsbdy[0]['txttxt']) ? $vew_data->grlnwsbdy[0]['txttxt']: ""; ?></div>
                    </textarea>
                  </div>  
                </div>
              </div>
						</div>
            <?= gethtml('txtbdycod', 'hidden', $vew_actcod!='001' ? (isset($vew_data->grlnwsbdy[0]["txtcod"]) ? $vew_data->grlnwsbdy[0]["txtcod"] : '') : ''); ?>
            
					</div>
				</div> <!-- /_tab001 -->
				
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
		
  </form>
  <script>
    $(function(){
    $("#<?=$lv_sec?> #nwsmsg").attr("placeholder", "<?=$vew_lang->HEADER; ?>...");
    tmssLoadScript("tinymce",function(){
				tinyMCE.init({ 
					selector: "#<?= $lv_sec ?>_txt",
          language: 'es',
					height: 350, 
					menubar: false,
          toolbar: false,
          <?= $vew_readonly ? 'readonly: 1': ''?>
          
          <?php if(!$vew_readonly){?>
            plugins: ['print preview fullpage importcss searchreplace autolink autosave save directionality visualblocks visualchars fullscreen image link media template codesample charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists wordcount imagetools textpattern noneditable help charmap emoticons'],
						menubar: 'file edit view insert format table tc',
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
    })
  </script>
	<script>    
		// botón de modelo. carga un modelo de novedad
		$("#<?= $lv_sec; ?> #btnmdl").on("click", function(e) { e.preventDefault();
			$("#<?= $lv_sec; ?> #txtcod").prop("value","");
			tmssPopup("Modelos","?prg=grldattxt&act=08&prm_vewcod=VEW_GRL_DAT_TXT&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[txtcod:txtcod],[dstcnttxt:cnttxt]&prm_fldflt=[txtsrccod:**]",function(){
        var lv_txtcod = $("#<?= $lv_sec; ?> #txtcod").prop("value");
				if(lv_txtcod!=""){
					tmssCallProcess("?prg=grldattxt&act=05", {txtcod: lv_txtcod}, function(data) {
            // le pasa el modelo de novedad a la preview
            tinyMCE.activeEditor.setContent(data);
            tinyMCE.triggerSave();
					});
				}
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
  <?php include('grldocfrmscr.frm'); ?>
</section>
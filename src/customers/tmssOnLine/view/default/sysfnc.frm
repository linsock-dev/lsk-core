<?php
	// url del formulario
  $lv_lnk = '?prg=sysfnc&prm_sysfnccod='.$vew_data->sysfnccod;

	// campos requeridos
	$vew_input->RequiredFields( array('sysfnctxt','sysfncttl','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->sysfnccod;  

	// titulo
	$lv_title = $vew_lang->functions;
	
	/// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'FNC';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->texts; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->sysfnccod; ?><?= gethtml('sysfnccod','hidden',$vew_data->sysfnccod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $lv_title ?></div></div>
								<div class="card-body tmss-card-body-edit">									
									<?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code,'input'=>gethtml('sysfnccodext', 'doccmt1x20', $vew_data->sysfnccodext, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('sysfnctxt', 'doccmt1x50', $vew_data->sysfnctxt, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->title, 'input'=>gethtml('sysfncttl', 'doccmt5x50', $vew_data->sysfncttl, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
								</div>
							</div>
						</div> <!-- /col -->
						<div class="<?= ($vew_data->sysfnccod!=''?'col-md-4':'col-md-6'); ?>">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->data; ?></div></div>
								<div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col210, array('label'=>$vew_lang->module, 'input'=>gethtml('mdlcod', 'mdlcod', $vew_data->mdlcod, 		$lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->hidden, 'input'=>gethtml('sysfnchde', 'yesno', $vew_data->sysfnchde, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->group, 'input'=>gethtml('sysfncgrp', 'doccmt1x50', $vew_doc->getTagValue($vew_data->sysfncatrval001,'sysfncgrp'), $lv_default) ));
										echo vew_boot($lv_col291, array('label'=>$vew_lang->image,  	
																							'input1'=>gethtml('sysfncpic', 'doccmt1x50', $vew_data->sysfncpic,	$lv_default),
																							'input2'=>($vew_data->sysfncpic==''?'':(substr(trim(strtolower($vew_data->sysfncpic)),0,6)=='class:'?'<span class="'.substr($vew_data->sysfncpic,6,strlen($vew_data->sysfncpic)-6).'"></span>':'<div class="center-text"><img class="img-responsive" src="/library/images/'.$vew_data->sysfncpic.'"></div>'))	)); 
									?>
								</div>
							</div>
						</div> <!-- /col -->
						<div class="col-md-2 <?= ($vew_data->sysfnccod!=''?'':'hidden'); ?>">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->options; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <a href="#" class="card-opt-body text-left" id="btnopr"><i class="fas fa-key"></i> <?= $vew_lang->operations; ?></a>
                  <a href="#" class="card-opt-body text-left" id="btncus"><i class="fas fa-users"></i> <?= $vew_lang->customers; ?></a>
                </div>
							</div>
						</div> <!-- /col -->
					</div> <!-- /row -->
				</div> <!-- /tab001 -->

				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<textarea id="<?= $lv_sec; ?>_sysfncdes" name="sysfncdes"><?= $vew_data->sysfncdes; ?></textarea>
				</div> <!-- /tab002 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		// OPERACIONES
		$("#<?= $lv_sec; ?> #btnopr").on("click", function(e) { e.preventDefault();
			tmssCallProcess("?prg=sysfncopr&act=<?= ($vew_readonly?'03':'02'); ?>", {sysfnccod: $("#<?= $lv_sec; ?> #sysfnccod").prop("value")}, function(data) {
				BootstrapDialog.show({
					title: "<?= $vew_lang->operations; ?>",
					size: BootstrapDialog.SIZE_WIDE,
					message: $(data)
				});
			});
		});
		
		// CLIENTES
		$("#<?= $lv_sec; ?> #btncus").on("click", function(e) { e.preventDefault();
			tmssCallProcess("?prg=sysfncsub&act=<?= ($vew_readonly?'03':'02'); ?>", {sysfnccod: $("#<?= $lv_sec; ?> #sysfnccod").prop("value")}, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->customers; ?>",
					message: $(data),
          draggable: true,
          size: BootstrapDialog.SIZE_WIDE
				});
			});
		});
		
		// TEXTOS
		tmssLoadScript("tinymce", function(){
			if(tinyMCE.get("<?= $lv_sec; ?>_sysfncdes")!=null) {
				tinyMCE.get("<?= $lv_sec; ?>_sysfncdes").destroy();
			}
			tinyMCE.init({ 
				selector: "#<?= $lv_sec; ?>_tab002 textarea", 
				height: 300, 
				menubar: false
				<?= ($vew_readonly?', readonly: 1':''); ?>
			});
		});
	</script>

	<?php include('grldocfrmscr.frm'); ?>
</section>
<?php
	// url del formulario 
  $lv_lnk = '?prg=syssecgrp&prm_usrgrpcod='.$vew_data->usrgrpcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('usrgrpcodext','usrgrptxt','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->usrgrpcod;

	// titulo 
	$lv_title = $vew_lang->group;

	// m�dulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'GRP';

	// librer�a de estilos bootstrap 
	include_once('_library.frm');
	
	$lv_optedt = ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02')?'02':'03');
	
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('usrgrpcod','hidden',$vew_data->usrgrpcod); ?>
    <?= gethtml('objtypcod','hidden',$vew_objtyp); ?>

		<div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<?php if($vew_actcod!='01'){ ?><li class="pull-right"><h4># <strong><?= $vew_data->usrgrpcod; ?><?= gethtml('usrgrpcod','hidden',$vew_data->usrgrpcod); ?></strong></h4></li><?php } ?>
			</ul>
			
      <div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
        	<div class="row">
          	<div class="<?= ($vew_data->usrgrpcod!=''?'col-md-10':'col-md-12'); ?>">
              
              <div class="row">
								<div class="col-md-6">
                	<!-- ROL -->
                  <div class="card">
                  	<div class="card-header"><div class="card-title"><?= $vew_lang->role; ?></div></div>
                    <div class="card-body tmss-card-body-edit">
                    	<?php
                      	if($vew_actcod=='01'){ echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('usrgrpcodext', 'usrgrpcod', $vew_data->usrgrpcod, ($vew_data->usrgrpcod==''?$lv_default:$lv_always_disabled)) )); }
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('usrgrptxt', 'usrgrptxt', $vew_data->usrgrptxt, $lv_default) ));
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->start,			'input'=>gethtml('strpge', 'doccmt1x50', $vew_doc->getTagValue($vew_data->usrgrpatr001,'strpge'), $lv_default) ));
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                      ?>
                    </div>
                  </div> <!-- card -->
              	</div> <!-- col-md-6 -->
							</div> <!-- row -->
							
            </div> <!-- /col-sm-10 -->
						<?php if ( $vew_data->usrgrpcod!='' ) { ?>
						<div class="col-md-2 text-center">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->operations; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <a href="#" id="btnper" class="card-opt-body text-left"><i class="far fa-key"></i> <?= $vew_lang->permissions; ?></a>
                  <a href="#" id="btnusr" class="card-opt-body text-left"><i class="far fa-users"></i> <?= $vew_lang->users; ?></a>
                  <a href="#" id="btnaut" class="card-opt-body text-left"><i class="far fa-user-secret"></i> <?= $vew_lang->authorizations; ?></a>
                  <a href="#" id="btnasg" class="card-opt-body text-left"><i class="far fa-user-shield"></i> <?= $vew_lang->directive; ?></a>
                </div>
              </div>
						</div> <!-- /col-md-2 -->
						<?php } ?>
          </div> <!-- /row -->
        
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
		</div> <!-- container-fluid -->
  </form>
	<script>
		//  P E R M I S O S
		$("#<?= $lv_sec; ?> #btnper").on("click", function(e) { e.preventDefault(); 
			tmssCallProcess("?prg=syssecper&act=<?= $lv_optedt; ?>",{usrgrpcod: $("#<?= $lv_sec; ?> #usrgrpcod").prop("value")}, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->permissions; ?>",
					message: $(data),
					draggable: true,
					size: BootstrapDialog.SIZE_WIDE
					<?php if($lv_optedt=='02'){ ?>
					,buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
										{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){ $(dialogItself.$modalBody).find("#btnsubmit").trigger("click"); }}]
					<?php } ?>
				});
			});
		});

		//  U S U A R I O S
		$("#<?= $lv_sec; ?> #btnusr").on("click", function(e) { e.preventDefault();
			tmssCallProcess("?prg=syssecusrgrp&act=<?= $lv_optedt; ?>",{usrgrpcod: $("#<?= $lv_sec; ?> #usrgrpcod").prop("value")}, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->users; ?>",
					message: $(data),
					draggable: true,
					size: BootstrapDialog.SIZE_WIDE
					<?php if($lv_optedt=='02'){ ?>
					,buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
										{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){ $(dialogItself.$modalBody).find("#btnsubmit").trigger("click"); }}]
					<?php } ?>
				});
			});
		});

		//  P E R M I S O S  -  O B J E T O S   D E   A U T O R I Z A C I O N
		$("#<?= $lv_sec; ?> #btnaut").on("click", function(e) { e.preventDefault(); 
			tmssCallProcess("?prg=syssecperaut&act=<?= $lv_optedt; ?>",{usrgrpcod: $("#<?= $lv_sec; ?> #usrgrpcod").prop("value")}, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->authorizationobjects; ?>",
					message: $(data),
					draggable: true,
					size: BootstrapDialog.SIZE_WIDE
					<?php if($lv_optedt=='02'){ ?>
					,buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
										{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){ $(dialogItself.$modalBody).find("#btnsubmit").trigger("click"); }}]
					<?php } ?>
				});
			});
		});
		
		// A S I G N A C I Ó N   D E   G R U P O S   D E   D I R E C T I V A S
		$("#<?= $lv_sec; ?> #btnasg").on("click", function(e) { e.preventDefault();
			var lv_pstdat =[{name:"srcobjcod001", value: $("#<?= $lv_sec; ?> #usrgrpcod").prop("value")},
											{name:"srcobjtyp", value: $("#<?= $lv_sec; ?> #objtypcod").prop("value")}];
			tmssCallProcess("?prg=syssecdrtgrpasg&act=<?= $lv_optedt; ?>", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->directive; ?>",
					message: $(data),
					size: BootstrapDialog.SIZE_WIDE
					<?php if($lv_optedt=='02'){ ?>
					,buttons:[{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); }},
										{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){ $(dialogItself.$modalBody).find("#btnsubmit").trigger("click"); }}]
					<?php } ?>
				});
			});
		});		
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
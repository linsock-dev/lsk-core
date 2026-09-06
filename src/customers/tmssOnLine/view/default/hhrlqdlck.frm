<?php
	// url del formulario
  $lv_lnk = '?prg=hhrlqdlck&prm_hhrlqdlckcod='.$vew_data->hhrlqdlckcod;

	// campos requeridos
	$vew_input->RequiredFields( array('hhrlqdlckstrdte','hhrlqdlckenddte','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->hhrlqdlckcod;

	// titulo
	$lv_title = $vew_lang->locks;
	
	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'LCK';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<input type="hidden" id="hhrlqdlckatr" name="hhrlqdlckatr" value="<?= htmlentities($vew_data->hhrlqdlckatr); ?>">
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hhrlqdlckcod; ?><?= gethtml('hhrlqdlckcod','hidden',$vew_data->hhrlqdlckcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->locks; ?></div></div>
								<div class="card-body">
									<?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 	'input'=>gethtml('hhrlqdlckcodext', 'doccodext', $vew_data->hhrlqdlckcodext, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->from, 	'input'=>gethtml('hhrlqdlckstrdte', 'docdte', $vew_data->hhrlqdlckstrdte, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->to, 		'input'=>gethtml('hhrlqdlckenddte', 'docdte', $vew_data->hhrlqdlckenddte, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
								</div>
							</div>
									
						</div>
						<div class="col-md-6">
						
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->area; ?></div></div>
								<div class="card-body">
									<?php
										echo vew_boot($lv_col210, array('label'=>$vew_lang->charges,			'input'=>gethtml('hhrlqdlckatrcha', 'checkbox', ($vew_doc->getTagValue($vew_data->hhrlqdlckatr,'hhr_cha')!=''?true:false), $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->licences, 		'input'=>gethtml('hhrlqdlckatrlic', 'checkbox', ($vew_doc->getTagValue($vew_data->hhrlqdlckatr,'hhr_lic')!=''?true:false), $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->substitutions,'input'=>gethtml('hhrlqdlckatrsub', 'checkbox', ($vew_doc->getTagValue($vew_data->hhrlqdlckatr,'hhr_sub')!=''?true:false), $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->assistences, 	'input'=>gethtml('hhrlqdlckatrass', 'checkbox', ($vew_doc->getTagValue($vew_data->hhrlqdlckatr,'hhr_ass')!=''?true:false), $lv_default) ));
									?>
								</div>
							</div>
							
						</div>
					</div>		
				
				</div> <!-- /_tab001 -->		
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		tmssLoadScript("toggle",function(){
			$("#<?= $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: 'success', offstyle: 'default', on: 'Si', off: 'No', size: 'small' });
			});
		});
	</script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
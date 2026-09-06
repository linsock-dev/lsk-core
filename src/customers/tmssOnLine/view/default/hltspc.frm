<?php
	/* url del formulario */
  $lv_lnk = "?prg=hltspc&prm_spccod=".$vew_data->spccod; 

	/* campos requeridos */
	$vew_input->RequiredFields( array('spctxt','spctyp','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->spccod; 

	/* titulo */
	$lv_title = $vew_lang->specialty;
	
	/* m�dulo y programa */
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'SPC';
	
	/* librer�a de estilos bootstrap */
	include_once('_library.frm');

	$vew_tbl['tmeL'] = array('pos'=>'L', 'per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'), 'id'=>'btntme', 'ttl'=>$vew_lang->schedule, 'icn'=>'fas fa-clock', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn','acc'=>'');
	$vew_tbl['tmeR'] = array('pos'=>'R', 'per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'), 'id'=>'btntme', 'ttl'=>$vew_lang->schedule, 'icn'=>'fas fa-clock', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn','acc'=>'');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!--navbar-->
	<?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->spccod; ?><?= gethtml('spccod', 'hidden', $vew_data->spccod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->specialty; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                	<?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('spccodext', 'doccmt1x20', $vew_data->spccodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('spctxt', 'spctxt', $vew_data->spctxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->type,       'input'=>gethtml('spctyp', 'spctyp', $vew_data->spctyp, $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->color,      'input'=>gethtml('spcclr', 'color',  $vew_data->spcclr, $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
						</div>
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->planning; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->planning,'input'=>gethtml('spcplntyp','spcplntyp',	$vew_data->spcplntyp,$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->control,'input'=>gethtml('spcctrtyp',	'spcctrtyp',	$vew_data->spcctrtyp,$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->form,   'input'=>gethtml('spcfrm',		'doccmt1x250',$vew_data->spcfrm   ,$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->sortorder,	'input'=>gethtml('spcord',		'docnum0500', 				$vew_data->spcord, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->role,		'input'=>gethtml('hltprsrlscod','hltprsrlscod_lst',$vew_doc->getTagValue($vew_data->spcatrval001,'hltprsrlscod'), $lv_default) ));
                    echo vew_boot(array($lv_colsm210, $lv_colxs48), array('label'=>'Ctrl.Stock',			'input'=>gethtml('spcstkctr', 'checkbox',$vew_doc->getTagValue($vew_data->spcatrval001,'spcstkctr'), $lv_default) ));
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
		$("#<?= $lv_sec; ?> #btntme").on("click",function(e){
			e.preventDefault();
			var lv_pstdat = [{name:"spccod", value:"<?= $vew_data->spccod; ?>"}];
			tmssCallProcess("?prg=hltspctme&act=03",lv_pstdat,function(data){
				BootstrapDialog.show({
					size: BootstrapDialog.SIZE_WIDE,
					title: "<?= $vew_lang->schedule; ?>",
					closable: false,
					draggable: true,
					message: $(data),
					buttons: [{ label: "Cerrar", cssClass: "btn-default", action: function(dialogRef){ dialogRef.close(); } }]
				});
			});
		});
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
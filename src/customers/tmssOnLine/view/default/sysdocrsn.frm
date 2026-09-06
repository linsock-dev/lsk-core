<?php
	// url del formulario 
  $lv_lnk = "?prg=sysdocrsn&prm_sysdocrsncod=".$vew_data->sysdocrsncod;

	// campos requeridos 
	$vew_input->RequiredFields( array('sysdocrsntxt','objtypcod','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->sysdocrsncod; 

	// titulo 
	$lv_title = $vew_lang->orderreasons;
	
	// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'DCO';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <nav class="navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<?php if ($vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'01')) { ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '01'});"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->new; ?>"><span class="far fa-file"></span><span class="hidden-xs"> <?= $vew_lang->new; ?></span></a><?php } ?>
				<?php if ($vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'01')) { ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '001'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->copy; ?>"><span class="far fa-copy"></span><span class="hidden-xs"> <?= $vew_lang->copy; ?></span></a><?php } ?>
				<?php if ($vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02')) { ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '02'});"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->modify; ?>"><span class="fas fa-pencil-alt"></span><span class="hidden-xs"> <?= $vew_lang->modify; ?></span></a><?php } ?>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '00'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success" title="<?= $vew_lang->save;  ?>"><span class="far fa-save"></span><span class="hidden-xs"> <?= $vew_lang->save; ?></span></a>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '98'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-danger" title="<?= $vew_lang->cancel; ?>"><span class="fas fa-times"></span><span class="hidden-xs"> <?= $vew_lang->cancel; ?></span></a>				
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<!--Dropdown-->
				<div class="btn-group dropdown">
					<a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><span class="fas fa-ellipsis-v"></span></a>
					<form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
						<!--Actualizar-->
						<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '99'});" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
						<!--Info-->
						<?php include('grlvewinfbtn.frm'); ?>
						<!--Borrar-->
						<?php if ($vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04')){ ?>
							<li class="divider"></li>
							<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '04'});"  class="tmssLink" title="<?= $vew_lang->delete; ?>"><span style="width:20px" class="fas fa-trash-alt"></span><?= $vew_lang->delete; ?></a></li>
						<?php } ?>
						<!--Ayuda-->
						<?php include('sysappprghlpbtn.frm'); ?>
					</form>
				</div>
				<!--Cerrar-->
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
  </nav>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->sysdocrsncod; ?><input type="hidden" id="sysdocrsncod" name="sysdocrsncod" value="<?= $vew_data->sysdocrsncod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
							<?php 
								echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 		'input'=>gethtml('sysdocrsncodext', 'doccodext', $vew_data->sysdocrsncodext, $lv_default) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('sysdocrsntxt', 'doccmt1x50', $vew_data->sysdocrsntxt, $lv_default) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
							?>
						</div>
						<div class="col-md-6">
							<?php 
								echo vew_boot($lv_col210, array('label'=>$vew_lang->object, 'input'=>gethtml('objtypcod','objtypcod_lst', $vew_data->objtypcod, ($vew_data->sysdocrsncod==''?$lv_default:$lv_always_disabled) ) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->authorizationcode, 'input'=>gethtml('autcod', 'autcod', $vew_data->autcod, $lv_default) ));
							?>
						</div>
					</div>
				</div> <!-- fin _tab001 -->

			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $("#<?= $lv_sec; ?>_frm"), "<?= $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    });
		
		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
			var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':'03'); ?>":gv_<?= $lv_sec; ?>_last_action);
			tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
		}

		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>
</section>
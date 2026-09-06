<?php	
	// url del formulario 
  $lv_lnk = '?prg=hltpatmod&prm_hltpatmodcod='.$vew_data->hltpatmodcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('patcod','pattxt','hltmodcod','hltmodtxt','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->hltpatmodcod; 

	// titulo 
	$lv_title = $vew_lang->module;
	
	// módulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PAM';

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<?php if ($vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'01')) { ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '01'});"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->new; ?>"><span class="far fa-file"></span><span class="hidden-xs"> <?= $vew_lang->new; ?></span></a><?php } ?>
				<?php if ($vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'01')) { ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '001'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->copy; ?>"><span class="far fa-copy"></span><span class="hidden-xs"> <?= $vew_lang->copy; ?></span></a><?php } ?>
				<?php if ($vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02')) { ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '02'});"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->modify; ?>"><span class="fas fa-pencil-alt"></span><span class="hidden-xs"> <?= $vew_lang->modify; ?></span></a><?php } ?>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '00'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success" title="<?= $vew_lang->save;  ?>"><span class="far fa-save"></span><span class="hidden-xs"> <?= $vew_lang->save; ?></span></a>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '98'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-danger" title="<?= $vew_lang->cancel; ?>"><span class="fas fa-times"></span><span class="hidden-xs"> <?= $vew_lang->cancel; ?></span></a>
			</ul>
			<ul class="navbar-right btn-toolbar tmss-navbar-right">
				<!--Dropdown-->
				<div class="btn-group dropdown">
					<a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><span class="fas fa-ellipsis-v"></span></a>
					<form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
						<!--Actualizar-->
						<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '99'});" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
						<!--Info-->
						<li><a href="#" class="tmsLink" id="btnshowinfo"><i style="width:20px" class="fas fa-info"></i><?= $vew_lang->additionalInfo; ?></a></li>
						<!--Borrar-->
						<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly){ ?>
							<li class="divider"></li>
							<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '04'});"  class="tmssLink" title="<?= $vew_lang->delete; ?>"><span style="width:20px" class="fas fa-trash-alt"></span><?= $vew_lang->delete; ?></a></li>
						<?php } ?>
						<!--Ayuda-->
						<?php include('sysappprghlpbtn.frm'); ?> 							
					</form>
				</div>
				<!--Cerrar-->
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn tmss-navbar-btn navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
  </nav>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hltpatmodcod; ?><input type="hidden" id="hltpatmodcod" name="hltpatmodcod" value="<?= $vew_data->hltpatmodcod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
							<?php 
								echo vew_boot($lv_col210, array('label'=>$vew_lang->patient, 
																				'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->hltpatmodcod!=''?true:$vew_readonly)), 
																														array('input'=>gethtml('pattxt', 'pattxt', $vew_data->pattxt, ($vew_data->hltpatmodcod!=''?$lv_always_disabled:$lv_default)) ))));
								echo '<input type="hidden" id="patcod" name="patcod" value="'.$vew_data->patcod.'">';
								echo vew_boot($lv_col210, array('label'=>$vew_lang->module,
																				'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->hltpatmodcod!=''?true:$vew_readonly)),
																														array('input'=>gethtml('hltmodtxt','doccmt1x50', $vew_data->hltmodtxt,($vew_data->hltpatmodcod!=''?$lv_always_disabled:$lv_default)) ))));
								echo '<input type="hidden" id="hltmodcod" name="hltmodcod" value="'.$vew_data->hltmodcod.'">';
								echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
							?>
						</div>
						<div class="col-md-6">
							<?php
								echo vew_boot($lv_col210, array('label'=>$vew_lang->start,'input'=>gethtml('hltpatmodstrdte', 'docdte', $vew_data->hltpatmodstrdte, $lv_default) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->end,'input'=>gethtml('hltpatmodenddte', 'docdte', $vew_data->hltpatmodenddte, $lv_default) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->authorization,'input'=>gethtml('hltpatmodaut','doccmt1x20',$vew_data->hltpatmodaut,$lv_default) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->comments,'input'=>gethtml('hltpatmodcmt',		'doccmt5x50',$vew_data->hltpatmodcmt,	$lv_default) ));
							?>
						</div>
					</div>
				</div> <!-- fin _tab001 -->

			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
		//INFO adicional
		$("#<?= $lv_sec; ?> #btnshowinfo").on("click",function(e){e.preventDefault
			var lv_dat=[{"infttl":"<?= $vew_lang->createdby;?>","infdat":"<?= $vew_data->cteusr; ?>"},
									{"infttl":"<?= $vew_lang->createddate; ?>","infdat":"<?= ($vew_data->ctedte!=''?date_format($vew_data->ctedte,'d-m-Y h:i:s'):''); ?>"},
									{"infttl":"<?= $vew_lang->updatedby; ?>","infdat":"<?= $vew_data->updusr; ?>"},
									{"infttl":"<?= $vew_lang->updateddate; ?>","infdat":"<?= ($vew_data->upddte!=''?date_format($vew_data->upddte,'d-m-Y h:i:s'):''); ?>"}];
			var lv_pstdat=[{name:"infdat",value:JSON.stringify(lv_dat)}];
			tmssPopup("Info","?prg=grlvew&act=showinfo",function(){},lv_pstdat);
		});

		// PACIENTE
		tmssLoadScript("typeahead",function(){
			$("#<?= $lv_sec; ?> #pattxt").typeahead({
				onSelectAjaxData: function(data){ $("#<?= $lv_sec; ?> #patcod").prop("value", data.data.patcod); },
				ajax: {
					url: "index.php?prg=hltpat&act=18",
					displayField: "pattxt",
					valueField: "pattxt",
					timeout: 500, triggerLength: 1, method: "get", loadingClass: "fas fa-spinner",
					preDispatch: function(query){ return {prm_pattxt: query}; },
					preProcess: function(data){ return (data.length==0?false:data); }
				}
			}).next().next("span").children("a:first").on("click", function(evt) {
				tmssPopup("Pacientes","index.php?prg=hltpat&prm_vewcod=VEW_HLT_PAT_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[patcod:patcod],[pattxt:pattxt]");
				evt.preventDefault();
			});
		});
		
    // MODULO
    $("#<?= $lv_sec; ?> #hltmodtxt")
        .on("keyup", function(){ if($(this).prop("value")==""){$("#<?= $lv_sec; ?> #hltmodtxt").prop("value","");$("#<?= $lv_sec; ?> #hltmodcod").prop("value","");} })
        .next("span").children("a:first").on("click", function(evt) {
					tmssPopup("M&oacute;dulo","index.php?prg=hltmod&prm_vewcod=VEW_HLT_MOD_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[hltmodcod:m.hltmodcod],[hltmodtxt:m.hltmodtxt]");
					evt.preventDefault();
        });
	</script>
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
			var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':($vew_actcod=='01'?'01':'03')); ?>":gv_<?= $lv_sec; ?>_last_action);
			tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
		}

		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>
</section>
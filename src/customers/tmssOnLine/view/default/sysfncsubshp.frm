<?php
	// url del formulario 
  $lv_lnk = '?prg=sysfncsub&act=18';

	// campos requeridos 
	$vew_input->RequiredFields( array('','') );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = '';

	// módulo y programa 
	$lv_mdlcod = '';
	$lv_prgcod = '';

	// librería de estilos bootstrap 
	include_once('_library.frm');

	// quito ZCU que no están suscriptos
	for($i=0; $i<count($vew_fnclst); $i++){
		if($vew_fnclst[$i]['mdlcod']=='ZCU') {
			foreach($vew_fnccus as $lv_row){
				if($lv_row['sysfnccod']!=$vew_fnclst[$i]['sysfnccod']){
					unset($vew_fnclst[$i]);
					break;
				}
			}
		}
	}

	$lo_mnu = array();
	$lv_qtyfnc = 0;
	foreach($vew_fnclst as $lv_row){
		$lv_qtyfnc++;
		if( !isset($lo_mnu[$lv_row['mdlcod']]) ) {
			$lo_mnu[$lv_row['mdlcod']] = array('sysfncgrp'=>$lv_row['sysfncgrp'], 'mdlcod'=>$lv_row['mdlcod'], 'mdltxt'=>$lv_row['mdltxt'], 'fncqty'=>1);
		} else {
			$lo_mnu[$lv_row['mdlcod']]['fncqty']++;
		}
	}

	$lo_mnusub = array();
	$lv_qtysub = 0;
	foreach($vew_fnccus as $lv_row){
		$lv_qtysub++;
		if( !isset($lo_mnusub[$lv_row['mdlcod']]) ) {
			$lo_mnusub[$lv_row['mdlcod']] = array('fncqty'=>1);
		} else {
			$lo_mnusub[$lv_row['mdlcod']]['fncqty']++;
		}
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<!--Dropdown-->
				<div class="btn-group dropdown">
					<a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><span class="fas fa-ellipsis-v"></span></a>
					<form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
						<!--Actualizar-->
						<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '99'});" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
						<li><a href="#" onclick="tmssLink('?prg=sysappdsh&act=dsh');" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->dashboard; ?></a></li>
						<!--Ayuda-->
						<?php include('sysappprghlpbtn.frm'); ?>
					</form>
				</div>
				<!--Cerrar-->
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
  </nav>

	<div class="container-fluid">
		<div class="row">
			<div class="col-sm-4 col-md-3 col-lg-2">

				<div id="mdllst">
					<ul>
						<?php
						$lv_buffer = '';
						$lv_lstgrp = '';
						foreach($lo_mnu as $lv_row){
								$lv_row['sysfncgrp'] = ($lv_row['sysfncgrp']==''?'General':$lv_row['sysfncgrp']);
								if($lv_row['sysfncgrp']!=$lv_lstgrp){
									if($lv_lstgrp!=''){$lv_buffer.='</ul></li>';}
									$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"fas fa-cubes", "opened": true}'.chr(39).'>'.$lv_row['sysfncgrp'].'<ul>';
									$lv_lstgrp = $lv_row['sysfncgrp'];
								}
								$lv_buffer .= '<li name="sysfncgrp" data-jstree='.chr(39).'{"icon":"fas fa-cube"}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-sysfncgrp="'.$lv_row['sysfncgrp'].'">'.(isset($lo_mnusub[$lv_row['mdlcod']])?'<strong>':'').$vew_lang->getTranslation($lv_row['mdltxt']).(isset($lo_mnusub[$lv_row['mdlcod']])?'</strong>':'').
												(1==2?'<span class="badge">'.$lv_row['fncqty'].'</span> '.
												(isset($lo_mnusub[$lv_row['mdlcod']])?'<span class="badge" style="background-color: #43bf2d;">'.$lo_mnusub[$lv_row['mdlcod']]['fncqty'].'</span> ':''):'').
												'</li>';
							}
							if($lv_buffer==''){$lv_buffer.='</ul></li>';}
						?>
						<li name="sysfncall" data-jstree='{"icon":"fas fa-list-ul"}'>Todo <span class="badge"><?= $lv_qtyfnc; ?></span></li>
						<li name="sysfncsus" data-jstree='{"icon":"fas fa-tasks"}'>Suscriptos <span class="badge"><?= $lv_qtysub; ?></span></li>
						<li name="sysfnccls" data-jstree='{"icon":"fas fa-project-diagram", "opened":true}'>Clasificacion<ul><?= $lv_buffer; ?></ul>
						</li>
					</ul>
				</div>
			</div>
			<div class="col-sm-8 col-md-9 col-lg-10" style="border-left: #a6a6a6 1px solid; background-color: #f1f1f1;">
				<div class="row">
					<?php	foreach($vew_fnclst as $lv_row) {
							$lv_found = false;
							foreach($vew_fnccus as $lv_rowcus){if($lv_row['sysfnccod']==$lv_rowcus['sysfnccod']){$lv_found=true;}}
						?>
						<div class="col-xs-6 col-sm-4 col-md-3 col-lg-2 tmssOptionBox" data-mdlcod="<?= $lv_row['mdlcod']; ?>" data-sysfnccod="<?= $lv_row['sysfnccod']; ?>" data-sus="<?= ($lv_found==true?'1':'0'); ?>">
							<div class="tmssOptionBoxDiv <?= ($lv_found==true?'tmssOptionBoxDivSub':''); ?>">
								<div style="padding: 10px; min-height: 50px;" class="text-center">
									<?php if($lv_found==true){ ?>
									<span class="fas fa-check-circle" style="color: #FF9800;float: left;font-size: 24px;position: absolute;left:20px;"></span>
									<?php } ?>
									<span class="fa <?= ($lv_row['sysfncpic']!=''?$lv_row['sysfncpic']:'fa-cogs'); ?> fa-4x" style="color:#696969;"></span>
								</div>
								<div style="overflow: hidden; text-overflow: ellipsis; padding: 5px; min-height: 90px; max-height:90px;">
									<div style=" margin-bottom: 5px; max-height: 40px; min-height: 40px;"><strong><?= $lv_row['sysfnctxt']; ?></strong><br><small><?= $vew_lang->getTranslation($lv_row['mdltxt']); ?></small></div><br>
									<span style="float: left; font-size: 12px; white-space: nowrap;"><span class="fas fa-star"></span><span class="fas fa-star"></span><span class="fas fa-star"></span><span class="fas fa-star"></span><span class="fas fa-star"></span></span>
									<span style="float: right; font-size: 12px; white-space: nowrap;">ARS 0.-</span>
								</div>
							</div>
						</div>
					<?php } ?>
				</div>
			</div>
		</div> <!-- /row -->
	</div> <!-- /container-fluid -->
	<style>
		.tmssOptionBox { padding: 5px; }
		.tmssOptionBoxDiv { background-color: #ffffff; cursor: pointer; border: #a6a6a6 1px solid;  margin-right: 5px; margin: 5px; border-radius: 5px; }
		.tmssOptionBoxDiv:hover { background-color: #f1f1f1; }
		//.tmssOptionBoxDivSub { background-color: #0b9444; color: #ffffff; }
		//.tmssOptionBoxDivSub h5 { color: #ffffff; }
		//.tmssOptionBoxDivSub:hover { background-color: #075f2d; }
	</style>
	<script>
		tmssLoadScript("jstree",function(){
			$("#mdllst").jstree({
				"core": { "expand_selected_onload" : false, "themes": {	"responsive": true } }
			});

			$("#<?= $lv_sec; ?> li[name='sysfncall']").on("click",function(e){
				e.preventDefault();
				$("#<?= $lv_sec; ?> .tmssOptionBox").show("slow");
			});

			$("#<?= $lv_sec; ?> li[name='sysfncsus']").on("click",function(e){
				e.preventDefault();
				$("#<?= $lv_sec; ?> .tmssOptionBox[data-sus=0]").hide("slow");
				$("#<?= $lv_sec; ?> .tmssOptionBox[data-sus=1]").show("slow");
			});

			$("#<?= $lv_sec; ?> li[name='sysfncgrp']").on("click",function(e){
				e.preventDefault();
				$("#<?= $lv_sec; ?> .tmssOptionBox:not([data-mdlcod='"+$(this).data("mdlcod")+"'])").hide("slow");
				$("#<?= $lv_sec; ?> .tmssOptionBox[data-mdlcod='"+$(this).data("mdlcod")+"']").show("slow");
			});

			$("#<?= $lv_sec; ?> .tmssOptionBox").on("click",function(e){
				e.preventDefault();
				var lv_pstdat = [{name:"sysfnccod",value:$(this).data("sysfnccod")}];
				tmssCallProcess("?prg=sysfnc&act=13",lv_pstdat,function(data){
					BootstrapDialog.show({
						title: "Suscripci&oacute;n",
						message: $(data),
						size: BootstrapDialog.SIZE_WIDE,
						buttons: [{ label: 'Cerrar', action: function(dialogItSelf) { dialogItSelf.close(); } }]
					});
				});
			});
		});
 	</script>
</section>
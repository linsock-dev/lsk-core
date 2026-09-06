<?php
	// inicializo
	$lv_sysseclnklst = $vew_sysseclnk->initialize($lv_mdlcod.'_'.$lv_prgcod, $lv_dockey, $vew_data->adr->adreml);

	// verifico si el usuario esta bloqueado
	$lv_sysseclnkusrlck = ($lv_sysseclnklst['syssecusr']->usracclck!=''?true:false);
?>
<input type="hidden" id="grldatadrcntusr" name="grldatadrcntusr" value="<?= $lv_sysseclnklst['syssecusr']->usrcod; ?>">
<script>
	function <?= $lv_sec; ?>_refreshCreateLinkBtn( dialog ) {
		lv_usr = $("#<?= $lv_sec; ?> #grldatadrcntusr").prop("value");
		if (lv_usr!="") {
			dialog.$modalBody.find("#sysseclnknew").html("<i class="+String.fromCharCode(34)+"far fa-link"+String.fromCharCode(34)+"></i> <?= $vew_lang->link; ?>");
		} else {
			dialog.$modalBody.find("#sysseclnknew").html("<i class="+String.fromCharCode(34)+"far fa-file"+String.fromCharCode(34)+"></i> <?= $vew_lang->new; ?>");
		}
	}
	
	function <?= $lv_sec; ?>_sysseclnk_show(){
		var lv_msg = "<div class='row'>";
		lv_msg += "<input type='hidden' id='usrcod' name='usrcod' value='<?= $lv_sysseclnklst['syssecusr']->usrcod; ?>'>";
		lv_msg += "<input type='hidden' id='usrtxt' name='usrtxt' value='<?= $vew_data->adr->adrnme001; ?>'>";
		lv_msg += "<div class='col-md-6'><div class='list-group'>";
		lv_msg += "<h5>Accesos</h5>";
		lv_msg += "<a href='#' id='sysseclnknew' class='list-group-item <?= (count($lv_sysseclnklst['syssecusrlnk'])==0 && $vew_sec->hasPermission('SYS','SLK','11')==true?'':'disabled'); ?>'><i class='far fa-link'></i> <?= $vew_lang->link; ?></a>";
		lv_msg += "<a href='#' id='sysseclnkdel' class='list-group-item <?= (count($lv_sysseclnklst['syssecusrlnk'])!=0 && $lv_sysseclnklst['syssecusr']->usrcod!='' && $vew_sec->hasPermission('SYS','SLK','14')==true?'':'disabled'); ?>'><i class='far fa-trash-alt'></i> <?= $vew_lang->delete; ?></a>";
		lv_msg += "<a href='#' id='sysseclnkulk' class='list-group-item <?= (count($lv_sysseclnklst['syssecusrlnk'])!=0 && $vew_sec->hasPermission('SYS','SLK','24')==true?'':'disabled'); ?>'><i class='far fa-unlink'></i> <?= $vew_lang->unlink; ?></a>";
		lv_msg += "<a href='#' id='sysseclnkunl' class='list-group-item <?= ($lv_sysseclnkusrlck && $vew_sec->hasPermission('SYS','SLK','17')==true?'':'disabled'); ?>'><i class='far fa-unlock'></i> <?= $vew_lang->unlock; ?></a>";
		lv_msg += "</div></div>";
		lv_msg += "<div class='col-md-6'><div class='list-group'>";
		lv_msg += "<h5>Informaci&oacute;n</h5>";
		lv_msg += "<a href='#' id='sysseclnksnd' class='list-group-item <?= (count($lv_sysseclnklst['syssecusrlnk'])!=0 && $vew_sec->hasPermission('SYS','SLK','25')==true?'':'disabled'); ?>'><i class='far fa-envelope'></i> <?= $vew_lang->send; ?></a>";
		lv_msg += "<a href='?prg=syshlp&act=99' target='_blank' class='list-group-item' id='sysseclnkhlp'><i class='far fa-info-circle'></i> <?= $vew_lang->help; ?></a>";
		lv_msg += "</div></div></div>";

		BootstrapDialog.show({
			title:"Autogesti&oacute;n de Usuarios",
			message: $(lv_msg),
			onshown:function(dialog){
				<?= $lv_sec; ?>_refreshCreateLinkBtn( dialog );
				
				// crear / vincular
				<?php if ($vew_sec->hasPermission('SYS','SLK','11')) { ?>
				dialog.$modalBody.find("#sysseclnknew").on("click",function(e) { e.preventDefault();
					if ($(this).hasClass("disabled")) { return false; }
					var lv_lst = "<?php foreach ($lv_sysseclnklst['sysseclnk'] as $lv_sysseclnklstrow){echo '<option value='.chr(39).$lv_sysseclnklstrow['usrgrpcod'].chr(39).' data-usrprmcod='.chr(39).$lv_sysseclnklstrow['usrprmcod'].chr(39).' data-usrprmfld='.chr(39).$lv_sysseclnklstrow['sysseclnksrcfld'].chr(39).'>'.$lv_sysseclnklstrow['usrgrptxt'].'</option>';} ?>";
					var lv_usrcod = $("#<?= $lv_sec; ?> #grldatadrcntusr").prop("value");
					var lv_msg = (lv_usrcod!=""?"Desea crear un nuevo acceso de dato maestro y vincularlo a la cuenta ["+lv_usrcod+"]?":"Desea crear un nuevo usuario para acceso al sistema?");
					lv_msg += "<br><br>Seleccione el rol<br><select id='sysseclnkgrp' name='sysseclnkgrp' class='form-control'><option value=''></option>"+lv_lst+"</select>";
					BootstrapDialog.show({
						title: "Nuevo Acceso", 
						message: $("<div>"+lv_msg+"</div>"), 
						buttons: [{label:"<?= $vew_lang->cancel; ?>",cssClass:"btn-danger",action:function(dialog2){dialog2.close();}},
											{label:"<?= $vew_lang->ok; ?>",cssClass:"btn-success",action:function(dialog2){
												if ( dialog2.$modalBody.find("#sysseclnkgrp option:selected").prop("value")=="" ){
													toastr.warning("Debe seleccionar un grupo.");
													return false;
												}
												var lv_usrcod = $("#<?= $lv_sec; ?> #grldatadrcntusr").prop("value");
												var lv_grpcod = dialog2.$modalBody.find("#sysseclnkgrp option:selected").prop("value");
												var lv_prmcod = dialog2.$modalBody.find("#sysseclnkgrp option:selected").data("usrprmcod");
												var lv_prmfld = dialog2.$modalBody.find("#sysseclnkgrp option:selected").data("usrprmfld");
												lv_prmfld = lv_prmfld.toLowerCase();
												var lv_pstdat = [	{name:"adrlstnme",value: "<?= $lv_mdlcod.'_'.$lv_prgcod; ?>"},
																					{name:"adrfrtnme",value: "<?= $lv_dockey; ?>"},
																					{name:"adreml",		value: "<?= $vew_data->adr->adreml; ?>"},
																					{name:"usrgrpcod",value: lv_grpcod },
																					{name:"usrprmcod",value: lv_prmcod },
																					{name:"usrprmval",value: $("#<?= $lv_sec; ?> #"+lv_prmfld).prop("value") },
																					{name:"lngcod",		value: "ES"},
																					{name:"docsts",		value: "A"},
																					{name:"usrcod",		value: lv_usrcod },
																					{name:"usrtxt",		value: dialog.$modalBody.find("#usrtxt").prop("value") },
																					{name:"srcobjtyp",value: "<?= $lv_mdlcod.'_'.$lv_prgcod; ?>" },
																					{name:"srcobjcod",value: "<?= $lv_dockey; ?>" }
																				];
												tmssCallProcess("?prg=sysseclnk&act=11",lv_pstdat,function(data){ 
													var lv_errcod = data["errcod"]?data["errcod"]:0;
													var lv_errtxt = data["errtxt"]?data["errtxt"]:"";
													var lv_usrcod = data["usrcod"];
													if ( lv_errcod==0 ) {
														$("#<?= $lv_sec; ?> #grldatadrcntusr").prop("value",lv_usrcod);
														dialog.$modalBody.find("#sysseclnknew").addClass("disabled");
														dialog.$modalBody.find("#sysseclnkdel").removeClass("disabled");
														dialog.$modalBody.find("#sysseclnkulk").removeClass("disabled");
														dialog.$modalBody.find("#sysseclnksnd").removeClass("disabled");
														<?= $lv_sec; ?>_refreshCreateLinkBtn( dialog );
														toastr.options.timeOut= 2000;
														toastr.success("Usuario creado.");
														dialog2.close();
													} else {
														toastr.options.timeOut= 4000;
														toastr.warning("Se produjo un error al crear el usuario.<br>"+lv_errcod+": "+lv_errtxt);
													}
												});
											}}]
					});
				});
				<?php } ?>
				
				// borrar usuario
				<?php if ($vew_sec->hasPermission('SYS','SLK','14')) { ?>
				dialog.$modalBody.find("#sysseclnkdel").on("click",function(e) { e.preventDefault();
					if ($(this).hasClass("disabled")) { return false; }
					BootstrapDialog.show({
						title: "Borrar Usuario", 
						type: BootstrapDialog.TYPE_WARNING,
						message: "Desea borrar el acceso del usuario al sistema?", 
						buttons: [{label:"<?= $vew_lang->cancel; ?>",cssClass:"btn-danger",action:function(dialog2){dialog2.close();}},
											{label:"<?= $vew_lang->ok; ?>",cssClass:"btn-success",action:function(dialog2){
												var lv_pstdat = [{name:"usrcod",value: $("#<?= $lv_sec; ?> #grldatadrcntusr").prop("value")}];
												tmssCallProcess("?prg=sysseclnk&act=14",lv_pstdat,function(data){
													var lv_errcod = data["errcod"]?data["errcod"]:0;
													var lv_errtxt = data["errtxt"]?data["errtxt"]:"";
													if ( lv_errcod==0 ) {
														$("#<?= $lv_sec; ?> #grldatadrcntusr").prop("value","");
														dialog.$modalBody.find("#sysseclnknew").removeClass("disabled");
														dialog.$modalBody.find("#sysseclnkdel").addClass("disabled");
														dialog.$modalBody.find("#sysseclnkulk").addClass("disabled");
														dialog.$modalBody.find("#sysseclnkunl").addClass("disabled");
														dialog.$modalBody.find("#sysseclnksnd").addClass("disabled");
														<?= $lv_sec; ?>_refreshCreateLinkBtn( dialog );
														dialog2.close();
														toastr.options.timeOut= 2000;
														toastr.success("Usuario borrado.");
													} else {
														toastr.options.timeOut= 4000;
														toastr.warning("Se produjo un error al crar el usuario.<br>"+lv_errcod+": "+lv_errtxt);
													}
												});
											}}]
					});
				});
				<?php } ?>

				// desvincular
				<?php if ($vew_sec->hasPermission('SYS','SLK','24')) { ?>
				dialog.$modalBody.find("#sysseclnkulk").on("click",function(e) { e.preventDefault();
					if ($(this).hasClass("disabled")) { return false; }
					BootstrapDialog.show({
						title: "Desvincular cuentas", 
						type: BootstrapDialog.TYPE_WARNING,
						message: "Desea desvincular el dato maestro de la cuenta de usuario?", 
						buttons: [{label:"<?= $vew_lang->cancel; ?>",cssClass:"btn-danger",action:function(dialog2){dialog2.close();}},
											{label:"<?= $vew_lang->ok; ?>",cssClass:"btn-success",action:function(dialog2){
												var lv_pstdat =[{name:"usrcod",value: $("#<?= $lv_sec; ?> #grldatadrcntusr").prop("value")},
																				{name:"srcobjtyp",value: "<?= $lv_mdlcod.'_'.$lv_prgcod; ?>"},
																				{name:"srcobjcod",value: "<?= $lv_dockey; ?>"}];
												tmssCallProcess("?prg=sysseclnk&act=24",lv_pstdat,function(data){
													var lv_errcod = data["errcod"]?data["errcod"]:0;
													var lv_errtxt = data["errtxt"]?data["errtxt"]:"";
													if ( lv_errcod==0 ) {
														dialog.$modalBody.find("#sysseclnknew").removeClass("disabled");
														dialog.$modalBody.find("#sysseclnkdel").addClass("disabled");
														dialog.$modalBody.find("#sysseclnkulk").addClass("disabled");
														dialog.$modalBody.find("#sysseclnkunl").addClass("disabled");
														dialog.$modalBody.find("#sysseclnksnd").addClass("disabled");
														dialog2.close();
														toastr.options.timeOut= 2000;
														toastr.success("Cuentas desvinculadas.");
													} else {
														toastr.options.timeOut= 4000;
														toastr.warning("Se produjo un error al crear el usuario.<br>"+lv_errcod+": "+lv_errtxt);
													}
												});
											}}]
					});
				});
				<?php } ?>
				
				// desbloquear usuario
				<?php if ($vew_sec->hasPermission('SYS','SLK','17')) { ?>
				dialog.$modalBody.find("#sysseclnkunl").on("click",function(e) { e.preventDefault();
					if ($(this).hasClass("disabled")) { return false; }
					BootstrapDialog.show({
						title: "Desbloquear usuario", 
						type: BootstrapDialog.TYPE_WARNING,
						message: "Desea desbloquear el acceso del usuario al sistema?", 
						buttons: [{label:"<?= $vew_lang->cancel; ?>",cssClass:"btn-danger",action:function(dialog2){dialog2.close();}},
											{label:"<?= $vew_lang->ok; ?>",cssClass:"btn-success",action:function(dialog2){
												var lv_pstdat = [{name:"usrcod",value: $("#<?= $lv_sec; ?> #grldatadrcntusr").prop("value")}];
												tmssCallProcess("?prg=sysseclnk&act=17",lv_pstdat,function(data){
													var lv_errcod = data["errcod"]?data["errcod"]:0;
													var lv_errtxt = data["errtxt"]?data["errtxt"]:"";
													if ( lv_errcod==0 ) {
														dialog.$modalBody.find("#sysseclnkunl").removeClass("disabled");
														dialog2.close();
														toastr.options.timeOut= 2000;
														toastr.success("Usuario desbloqueado.");
													} else {
														toastr.options.timeOut= 4000;
														toastr.warning("Se produjo un error al desbloquear el usuario.<br>"+lv_errcod+": "+lv_errtxt);
													}
												});
											}}]
					});
				});
				<?php } ?>

				// enviar info
				<?php if ($vew_sec->hasPermission('SYS','SLK','25')) { ?>
				dialog.$modalBody.find("#sysseclnksnd").on("click",function(e) { e.preventDefault();
					if ($(this).hasClass("disabled")) { return false; }
					BootstrapDialog.show({
						title: "Enviar informaci&oacute;n", 
						type: BootstrapDialog.TYPE_INFO,
						message: "Desea enviar la informaci&oacute;n de acceso al usuario?", 
						buttons: [{label:"<?= $vew_lang->cancel; ?>",cssClass:"btn-danger",action:function(dialog2){dialog2.close();}},
											{label:"<?= $vew_lang->ok; ?>",cssClass:"btn-success",action:function(dialog2){
												var lv_pstdat = [{name: "usrcod", value: $("#<?= $lv_sec; ?> #grldatadrcntusr").prop("value")}];
												tmssCallProcess("?prg=sysseclnk&act=25",lv_pstdat,function(data){ 
													var lv_errcod = data["errcod"]?data["errcod"]:0;
													var lv_errtxt = data["errtxt"]?data["errtxt"]:"";
													if ( lv_errcod==0 ) {
														dialog2.close();
														toastr.options.timeOut= 2000;
														toastr.success("Información enviada.");
													} else {
														toastr.options.timeOut= 4000;
														toastr.warning("Se produjo un error al enviar la información de acceso.<br>"+lv_errcod+": "+lv_errtxt);
													}
												});
											}}]
					});
				});
				<?php } ?>
			
			}
		});
	}
</script>
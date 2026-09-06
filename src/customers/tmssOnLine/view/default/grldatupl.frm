<?php		
	// campos requeridos
	$vew_input->RequiredFields( array() );

	// modulo y programa
	$lv_mdlcod = explode('_',$vew_data->flesrctyp)[0];
	$lv_prgcod = explode('_',$vew_data->flesrctyp)[1];
		
	// librer?a de estilos bootstrap
	include_once('_library.frm');
		
	$lv_fletyparr = array();
	if ( count($vew_data->fletyplst)!=0 ) {
		$lv_fletyparr = array(''=>'');
		foreach( $vew_data->fletyplst as $lv_row ) {
			$lv_fletyparr[$lv_row['fletypcod']] = $lv_row['fletyptxt'];
		}
	}
?>
<section id="<?= $lv_sec; ?>">
	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('flecod','hidden',$vew_data->flecod); ?>
		<?= gethtml('flesrctyp','hidden',$vew_data->flesrctyp); ?>
		<?= gethtml('flesrccod','hidden',$vew_data->flesrccod); ?>
		<?= gethtml('flesrcfld','hidden',$vew_data->flesrcfld); ?>
		<?= gethtml('camera_base64','hidden',''); ?>
		<?= gethtml('upltyp','hidden',''); ?>
		<div class="container-fluid">
			<div class="row">
				<div class="<?= (count($vew_data->fletyplst)==0?'col-md-12':'col-md-7'); ?>">
					<div class="tmssContainer" id="pht" style="min-height: 300px; background-repeat: no-repeat; background-position: center; background-size: contain; text-align: center; vertical-align: middle; padding-top: 120px;"></div>
					<div class="text-center" id="fleinf"></div>
				</div>
				<div class="<?= (count($vew_data->fletyplst)==0?'hidden':'col-md-5'); ?>">
					<div class="row">
						<div class="form-group tmss-form-group"><label class="col-xs-4 control-label"><?= $vew_lang->type; ?></label><div class="col-xs-8">
							<select class="form-control" id="fletypcod" name="fletypcod" <?= ($vew_data->flecod!=''?'disabled="disabled"':'');  ?> >
								<option value=""></option>
								<?php 
									foreach($vew_data->fletyplst as $lv_row){ 
										echo '<option value="'.$lv_row['fletypcod'].'" data-fletypsel="'.$vew_doc->getTagValue($lv_row['fletypatr'],'FLETYPATRSEL').'" data-fletypduedte="'.$vew_doc->getTagValue($lv_row['fletypatr'],'FLETYPATRDUE').'" '.($vew_data->flecod!='' && $vew_data->fletypcod==$lv_row['fletypcod']?'selected="selected"':'').'>'.$lv_row['fletyptxt'].'</option>'; 
									} 
								?>
							</select>
						</div></div>
						<div id="divduedte"><?= vew_boot($lv_col48, array('label'=>$vew_lang->duedate, 'input'=>gethtml('fleduedte', 'docdte', $vew_data->fleduedte, $lv_default ) )); ?></div>
						<div id="divppl"><div class="form-group tmss-form-group"><label class="col-xs-4 control-label"><?= $vew_lang->main; ?></label><div class="col-xs-8"><input type="checkbox" id="fleatrppl" name="fleatrppl" <?= ($vew_doc->getTagValue($vew_data->fleatr,'ppl')=='1'?'checked="checked"':''); ?>></div></div></div>
						<div id="divcmt"><?= vew_boot($lv_col48, array('label'=>$vew_lang->comments,'input'=>gethtml('flecmt', 'doccmt2x50', $vew_data->flecmt, $lv_default ) )); ?></div>
					</div>
				</div>
			</div>
			<a href="#" class="hidden" id="btncam"></a>
			<a href="#" class="hidden" id="btnfle"></a>
			<a href="#" class="hidden" id="btnsve"></a>
			<a href="#" class="hidden" id="btndwn"></a>
      <a href="#" class="hidden" id="btndel"></a>
		</div>
	</form>
	
	<div class="hidden"><input type="file" id="uplfle"></div>
	
	<script>
		// cambios en atributo principal/fecha vto
		$("#<?= $lv_sec; ?> #fleduedte, #<?= $lv_sec; ?> #fleatrppl").on("change",function(){
			$.each(BootstrapDialog.dialogs, function(id, dialog){
				if(dialog.$modalBody.find("section").prop("id")=="<?= $lv_sec; ?>"){
          lv_fleatrppl = ($("#<?= $lv_sec; ?> #fleatrppl").prop("checked") == true ? 1 : 0);
      		if ($("#<?= $lv_sec; ?> #fleduedte").val() == "<?= ($vew_data->fleduedte instanceof DateTime ? $vew_data->fleduedte->format('d/m/Y') : ''); ?>" && lv_fleatrppl == "<?= $vew_doc->getTagValue($vew_data->fleatr,'ppl'); ?>"){
            dialog.getButton("btnupl").addClass("hidden");
          }else{
            dialog.getButton("btnupl").removeClass("hidden");
          }
				}
			});			
		});
		
		// cambios en imagen (camara o archivo)
		$("#<?= $lv_sec; ?> #upltyp").on("change",function(){
			$.each(BootstrapDialog.dialogs, function(id, dialog){
				if(dialog.$modalBody.find("section").prop("id")=="<?= $lv_sec; ?>"){
					dialog.getButton("btnupl").removeClass("hidden");
				}
			});
		});

		//   G R A B A R
		$("#<?= $lv_sec; ?> #btnsve").on("click",function(e){	e.preventDefault();
		
			if( $("#<?= $lv_sec; ?> #fletypcod option").length>1 ){
				if( $("#<?= $lv_sec; ?> #fletypcod").prop("value")=="" ) {
					toastr.warning("Debe indicar el tipo de archivo");
          return false;
					$("#<?= $lv_sec; ?> #fletypcod").focus();
				} else if( $("#<?= $lv_sec; ?> #fleduedte").prop("value")=="" && $("#<?= $lv_sec; ?> #fletypcod option:selected").data("fletypduedte")=="1" ) {
					toastr.warning("Debe indicar la fecha de vencimiento del archivo");
					$("#<?= $lv_sec; ?> #fleduedte").focus();
          return false;
				}
			}
			var lo_dat = new FormData();
			var lv_frmarr = $("#<?= $lv_sec; ?>_frm").serializeArray();
			for(var i=0; i<lv_frmarr.length; i++){ lo_dat.append(lv_frmarr[i].name,lv_frmarr[i].value); }
			
			// upload data from Camera
			if( $("#<?= $lv_sec; ?> #upltyp").prop("value")=="C" ) {
				lo_dat.append("camera_base64", $("#camera_base64").val());
				tmssCallProcessFile("?prg=grldatupl&act=uploadImage", lo_dat, function(data) {
					$.each(BootstrapDialog.dialogs, function(id, dialog){
						if( dialog.$modalBody.find("section").prop("id")=="<?= $lv_sec; ?>" ) { dialog.close(); }
					});
				});
			// upload data from Files
			} else if( $("#<?= $lv_sec; ?> #upltyp").prop("value")=="F" ) {
				var lo_fle = $("#<?= $lv_sec; ?> #uplfle").prop("files")[0];
				lo_dat.append("archivo",lo_fle);
				tmssCallProcessFile("?prg=grldatupl&act=uploadFile",lo_dat,function(data){
					$.each(BootstrapDialog.dialogs, function(id, dialog){
						if( dialog.$modalBody.find("section").prop("id")=="<?= $lv_sec; ?>" ) { dialog.close(); }
					});
				});
			// update file data
			} else {
        lo_dat.append("fletypcod", $("#<?= $lv_sec; ?> #fletypcod").prop("value"));
				tmssCallProcessFile("?prg=grldatupl&act=save",lo_dat,function(data){
					$.each(BootstrapDialog.dialogs, function(id, dialog){
						if( dialog.$modalBody.find("section").prop("id")=="<?= $lv_sec; ?>" ) { dialog.close(); }
					});
				});
			}
		});
		
		
		
		//   A R C H I V O
		$("#<?= $lv_sec; ?> #btnfle").on("click",function(e){	e.preventDefault();
			$("#<?= $lv_sec; ?> #uplfle").trigger("click");
		});
		$("#<?= $lv_sec; ?> #uplfle").on("change",function(e){
			var lv_flenme = $(this).prop("files")[0].name;
			var lv_fletyp = $(this).prop("files")[0].type;
			var lv_flesze = $(this).prop("files")[0].size;
			var lv_fleszecnv = "";
			var lo_reader = new FileReader();
			lo_reader.onload = function (evt) {
				if(evt.target.result.substring(0,11)=="data:image/"){
					$("#<?= $lv_sec; ?> .tmssContainer").css("background-image", "url("+evt.target.result+")");
				} else {
					$("#<?= $lv_sec; ?> .tmssContainer").css("background-image", "url(library/images/icon_file.png)");
				}
			}
			try{
				var i = Math.floor( Math.log(lv_flesze) / Math.log(1024) );
				lv_fleszecnv = ( lv_flesze / Math.pow(1024, i) ).toFixed(1) * 1 + " " + ["b", "kb", "mb", "gb", "tb"][i];
			} catch(e){}
			$("#<?= $lv_sec; ?> #fleinf").html("<b>"+lv_flenme+"</b><br><small>"+lv_fleszecnv+" - "+lv_fletyp+"</small>");
			$("#<?= $lv_sec; ?> #upltyp").prop("value","F").trigger("change");
			lo_reader.readAsDataURL( $(this).prop("files")[0] );
		});
		
		
		
		//  C A M A R A
		$("#<?= $lv_sec; ?> #btncam").on("click",function(e){	e.preventDefault();
			tmssCallProcess("?prg=grldatupl&act=showUploadCam", [], function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->camera; ?>",
					message: $(data),
					type: BootstrapDialog.TYPE_PRIMARY,
					buttons: [{	id: "btndel",	icon: "fas fa-trash", label: " Volver a Tomar", cssClass: "btn-default pull-left hidden",
											action: function(dialog){
												$(dialog.$modalBody).find("#btndelpht").trigger("click");
												this.addClass("hidden");
												dialog.getButton("btnok").addClass("hidden");
												dialog.getButton("btntke").removeClass("hidden");
											}
										},
										{	id: "btnok", icon: "fas fa-check", label: " Listo",	cssClass: "btn-success hidden",
											action: function(dialog){
												var data_uri = $(dialog.$modalBody).find("img:first").prop("src");
												$("#<?= $lv_sec; ?> #camera_base64").val( $(dialog.$modalBody).find("#camera_base64").val() );
												$("#<?= $lv_sec; ?> .tmssContainer").css("background-image" , "url("+data_uri+")");
												$("#<?= $lv_sec; ?> #fleinf").html("<b><?= $vew_lang->camera; ?></b>");
												$("#<?= $lv_sec; ?> #upltyp").prop("value","C").trigger("change");
												dialog.close();
											}
										},
										{	id: "btntke",	icon: "fas fa-camera", label: " Tomar Foto", cssClass: "btn-primary",
											action: function(dialog){
												$(dialog.$modalBody).find("#btntkepht").trigger("click");
												this.addClass("hidden");
											}
										}],
					onhide: function(dialog){ $(dialog.$modalBody).find("#btnendpht").trigger("click"); }
				});
			});
		});


		// DOWNLOAD
		$("#<?= $lv_sec; ?> #btndwn").on("click",function(e){ e.preventDefault();
			var lv_flecod = $("#<?= $lv_sec; ?> #tblfle tbody tr.bg-info:first").data("flecod");
			window.open( "?prg=grldatupl&act=downloadFile&prm_flesrctyp=<?= $vew_data->flesrctyp; ?>&prm_flesrccod=<?= $vew_data->flesrccod; ?>&prm_flecod=<?= $vew_data->flecod; ?>" );
		});
		
		// DELETE
		<?php if($vew_data->readonly==0 && ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'U4') || $vew_data->fletypcod==0) ){ ?>
		$("#<?= $lv_sec; ?> #btndel").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm({
				title: "<?= $vew_lang->delete; ?>",
				message: "¿Desea borrar el documento <strong><?= $vew_data->flenme; ?></strong> ?",
				type: BootstrapDialog.TYPE_WARNING,
				callback: function(result) {
					if(result) {
						var lv_pstdat = [{name:"flesrctyp",value:"<?= $vew_data->flesrctyp; ?>"},{name:"flesrccod",value:"<?= $vew_data->flesrccod; ?>"},{name:"flecod",value:"<?= $vew_data->flecod; ?>"}];
						tmssCallProcess("?prg=grldatupl&act=deleteFile", lv_pstdat, function(data){
							<?php if($vew_data->oldsec != ''){ ?>
								$("#<?= $vew_data->oldsec ?> .grldatupl_container").removeData("flecod");
								$("#<?= $vew_data->oldsec ?> .grldatupl_container").css("background-image" , "url(library/images/TemasisArgentina_Isotipo_280gray.png)" );						
							<?php } ?>
							toastr.warning("Documento borrado", "<?= $vew_lang->attachments; ?>");
							$.each(BootstrapDialog.dialogs, function(id, dialog){
								if(dialog.$modalBody.find("section").prop("id")=="<?= $lv_sec; ?>"){
									dialog.close();
								}
							});
						});
					}
				}
			});
		});
		<?php } ?>
		
		// checkbox de imagen principal
		tmssLoadScript("toggle",function(){
			$("#<?= $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: 'success', offstyle: 'default', on: 'Si', off: 'No', size: 'small' });
			});
		});
		
		
		// cambio en el tipo de archivo
		$("#<?= $lv_sec; ?> #fletypcod").on("change",function(e){
			if( $(this).find("option:selected").data("fletypduedte")=="1" ) {
				$("#<?= $lv_sec; ?> #divduedte").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #divduedte").addClass("hidden");
			}
			if( $(this).find("option:selected").data("fletypsel")=="1" ) {
				$("#<?= $lv_sec; ?> #divppl").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #divppl").addClass("hidden");
			}
		});
		
		
		
		$(function(){
			<?php if($vew_data->flecod!=''){ ?>
				// pre-carga de imagen
				var lv_pstdat =[
          {name:"flesrctyp",value:"<?= $vew_data->flesrctyp; ?>"},
          {name:"flesrccod",value:"<?= $vew_data->flesrccod; ?>"},
          {name:"flecod",value:"<?= $vew_data->flecod; ?>"}
        ];
				$("#<?= $lv_sec; ?> .tmssContainer").html("<i class='fas fa-circle-notch fa-spin fa-5x'></i>");
				tmssCallProcessNoBackdrop("?prg=grldatupl&act=getFile&prm_content=x", lv_pstdat, function(data){
					$("#<?= $lv_sec; ?> .tmssContainer").html("");
					if(data["fleimg"]==true){
						$("#<?= $lv_sec; ?> .tmssContainer").css("background-image", "url(data:image/jpeg;base64,"+data["flecnt"]+")");
					} else {
						$("#<?= $lv_sec; ?> .tmssContainer").css("background-image", "url(library/images/icon_file.png)");
					}
					var lv_flenme = data["flenme"];
					var lv_fletyp = data["fletyp"];
					var lv_flesze = data["flesze"];
					var lv_fleszecnv = "";
					try{
						var i = Math.floor( Math.log(lv_flesze) / Math.log(1024) );
						lv_fleszecnv = ( lv_flesze / Math.pow(1024, i) ).toFixed(1) * 1 + " " + ["b", "kb", "mb", "gb", "tb"][i];
					} catch(e){}
					$("#<?= $lv_sec; ?> #fleinf").html("<b>"+lv_flenme+"</b><br><small>"+lv_fleszecnv+" - "+lv_fletyp+"</small>");

					// BOTONES. se muestran los botones del dialogo de imágenes
					$.each(BootstrapDialog.dialogs, function(id, dialog){
						if(dialog.$modalBody.find("section").prop("id")=="<?= $lv_sec; ?>"){
							//if( dialog.getButton("btndel")!=null ){
							<?php if($vew_data->readonly==0 && ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'U4') || $vew_data->fletypcod==0) ){ ?>dialog.getButton("btndel").removeClass("hidden");<?php } ?>
							<?php if($vew_data->readonly==0 && ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'U1') || $vew_data->fletypcod==0) ){ ?>dialog.getButton("btncam").removeClass("hidden");<?php } ?>
							<?php if($vew_data->readonly==0 && ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'U1') || $vew_data->fletypcod==0) ){ ?>dialog.getButton("btnfle").removeClass("hidden");<?php } ?>
							dialog.getButton("btndwn").removeClass("hidden");
						}
					});
				});

				
			<?php } else { ?>
				lv_img = "library/images/TemasisArgentina_Isotipo_280gray.png";
				$("#<?= $lv_sec; ?> .tmssContainer").css("background-image" , "url("+lv_img+")" );
				$.each(BootstrapDialog.dialogs, function(id, dialog){
					if(dialog.$modalBody.find("section").prop("id")=="<?= $lv_sec; ?>"){
						<?php if($vew_data->readonly==false && ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'U1') || $vew_data->fletypcod==0) ){ ?>dialog.getButton("btncam").removeClass("hidden");<?php } ?>
						<?php if($vew_data->readonly==false && ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'U1') || $vew_data->fletypcod==0) ){ ?>dialog.getButton("btnfle").removeClass("hidden");<?php } ?>
					}
				});
				
				if( $("#<?= $lv_sec; ?> #fletypcod option").length==2){
					$("#<?= $lv_sec; ?> #fletypcod option:last").prop("selected","selected");
				}
			<?php } ?>
			
			// actualización del tipo de archivo
			$("#<?= $lv_sec; ?> #fletypcod").trigger("change");	
			
			tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_data->flecod==''?'true':'false'); ?>);
		});
	</script>
</section>
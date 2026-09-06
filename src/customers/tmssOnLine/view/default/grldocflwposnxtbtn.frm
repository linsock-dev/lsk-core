<?php if( isset($lv_mdlcod) && isset($lv_prgcod) && ((isset($lv_dockey)?$lv_dockey:'')!='') && isset($lv_sec) && is_object($vew_data->sysdoccls) ){ ?>
<li><a href="#" id="btnnxt" class="tmssLink hidden"><i style="width:20px" class="fas fa-sign-in-alt"></i><?= $vew_lang->nextdocument ?></a></li>
<script>
	tmssCallProcessNoBackdrop("?prg=grldocflw&act=nextBtn&prm_srcobjtyp=<?= $lv_mdlcod.'_'.$lv_prgcod; ?>&prm_srcobjcod=<?= $lv_dockey; ?>&prm_sysdocclscod=<?= $vew_data->sysdoccls->sysdocclscod; ?>&prm_sec=<?= $lv_sec; ?>",{},function(data){
		if(data.length>0){ $("#<?= $lv_sec; ?> #btnnxt").removeClass("hidden"); }
	});

	$("#<?= $lv_sec; ?> #btnnxt").on("click",function(e){ e.preventDefault();
		tmssCallProcess( "?prg=grldocflw&act=nextLst", [{name:"sysdocclscod",value:"<?= $vew_data->sysdoccls->sysdocclscod; ?>"},
																										{name:"srcobjtyp",value:"<?= $lv_mdlcod.'_'.$lv_prgcod; ?>"},
																										{name:"srcobjcod",value:"<?= $lv_dockey; ?>"},
																										{name:"sec",value:"<?= $lv_sec; ?>"}], function(data) {
			BootstrapDialog.show({
				title: "<?= $vew_lang->nextdocument; ?>",
				message: $(data),
				type: BootstrapDialog.TYPE_PRIMARY,
				size: BootstrapDialog.SIZE_WIDE,
				buttons: [{label: "<?= $vew_lang->cancel; ?>", action: function(dialogRef){dialogRef.close();}},
									{label: "<?= $vew_lang->create; ?>", cssClass: "btn-success", action: function(dialogRef){
										var lv_bdy = dialogRef.getModalBody();
										$(lv_bdy).find("input[type=submit]").trigger("click");
									}}],
				onshown: function(dialogRef){
					var lv_bdy = dialogRef.getModalBody();
					$(lv_bdy).find("form:first").on("submit",function(e){
						e.preventDefault();
						e.stopPropagation();
						if( $(lv_bdy).find("#sysdocclscod").prop("value")=="" ){
							toastr.warning("Debe indicar una clase de documento.");
						} else if ( $(lv_bdy).find("#rowchk:checked").length==0 ) {
							toastr.warning("Debe seleccionar al menos un material a copiar.");
						} else {
							var lv_pstdat = $(this).serializeArray();
							lv_pstdat.push( {name:"objtyp", value:$(lv_bdy).find("#sysdocclscod").find("option:selected").data("objtyp")} );
							var lv_pstdatrow = [];
							$(lv_bdy).find("#rowchk:checked").each(function(){
								lv_pstdatrow.push( $(this).data("docposcod") +";"+ $(lv_bdy).find("#"+$(this).data("doccod")+"_"+$(this).data("docposcod")+"_qty").prop("value") );
							});
							lv_pstdat.push( {name:"matrow", value:JSON.stringify(lv_pstdatrow)} );
							tmssCallProcess("?prg=grldocflw&act=nextDoc", lv_pstdat, function(data) {
								var lv_urldoc = data.url;
								var lv_pstdatdoc = [];
								for(var i in data){ 
									if(typeof data[i] === "object" ) {
										lv_pstdatdoc.push( {name:i, value:JSON.stringify(data[i]) });
									} else {
										lv_pstdatdoc.push( {name:i, value:data[i] });
									}
								}
								tmssLink( lv_urldoc, [{target: "_new_section", post_data: lv_pstdatdoc}]);
								dialogRef.close();
							});
						}
						return false;
					});
				}
			});
		});
	});
</script>
<?php } ?>
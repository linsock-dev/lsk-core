<?php if(isset($lv_mdlcod) && isset($lv_prgcod) && ((isset($lv_dockey)?$lv_dockey:'')!='') && isset($lv_sec) && is_object($vew_data->sysdoccls) === true ){ ?>
	<a href="#" id="grldatupl_btnupl" title="<?= $vew_lang->attachments; ?>" class="btn navbar-btn tmss-navbar-btn hidden"></a>
	<script>
		// boton - archivos
		$("#<?= $lv_sec; ?> #grldatupl_btnupl").on("click",function(e){ e.preventDefault();
			var lv_pstdat = [{name:"flesrctyp",value:"<?= $lv_mdlcod.'_'.$lv_prgcod; ?>"},{name:"flesrccod",value:"<?= $lv_dockey; ?>"},{name:"sysdocclscod", value:$("#<?= $lv_sec; ?> #sysdocclscod").val()}];
			tmssCallProcess("?prg=grldatupl&act=showUploadGrid",lv_pstdat,function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->attachments; ?>",
					size: BootstrapDialog.SIZE_WIDE,
					message: $(data),
					onhide: function(dialog){
						<?= $lv_sec; ?>_grldatupl_btnuplupl_refresh(); 
						if( typeof <?= $lv_sec; ?>_grldatupl_showMainPhoto!=="undefined"){<?= $lv_sec; ?>_grldatupl_showMainPhoto();} ;
						if( typeof <?= $lv_sec; ?>_grldatupl_showGallery!=="undefined"){<?= $lv_sec; ?>_grldatupl_showGallery();} ;
					}
				});
			});
		});

		// boton - archivos - refresh de cantidades
		function <?= $lv_sec; ?>_grldatupl_btnuplupl_refresh(){
      var lv_objtyp = "<?= $vew_data->sysdoccls->objtyp; ?>";
			var lv_pstdat = [{name:"flesrctyp",value:lv_objtyp},{name:"flesrccod",value:"<?= $lv_dockey; ?>"},{name:"sysdocclscod", value:$("#<?= $lv_sec; ?> #sysdocclscod").val()}];
			tmssCallProcessNoBackdrop("?prg=grldatupl&act=getUploadList",lv_pstdat,function(data){
				var lv_qty = data.length;
				if(lv_qty>0){
					$("#<?= $lv_sec; ?> #grldatupl_btnupl").removeClass("tmss-navbar-btn").addClass("btn-success").html("<i class='fas fa-paperclip'></i> <span class='badge'>"+lv_qty+"</span>");
				} else {
					$("#<?= $lv_sec; ?> #grldatupl_btnupl").removeClass("btn-success").addClass("tmss-navbar-btn").html("<i class='fas fa-paperclip'></i>");
				}
			});
		}
		
		// boton se determina si se debe mostrar en funcion de si hay tipos de archivos definidos
		$(function(){
      var lv_pstdat = [{name:"sysdocclscod", value:$("#<?= $lv_sec; ?> #sysdocclscod").val()}]
			tmssCallProcessNoBackdrop("?prg=sysdocclsfle&act=18",lv_pstdat,function(data){
				if(data.length>0){
					$("#<?= $lv_sec; ?> #grldatupl_btnupl").removeClass("hidden");
					<?= $lv_sec; ?>_grldatupl_btnuplupl_refresh();
				} else {
					$("#<?= $lv_sec; ?> #grldatupl_btnupl").addClass("hidden");
				}
			});
		});
	</script>
<?php } ?>
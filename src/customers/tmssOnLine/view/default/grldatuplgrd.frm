<?php
	// GRILLA DE ADJUNTOS
	
	/* id de sección */
	$lv_sec = $vew_token;

	/* modulo y programa */
	$lv_mdlcod = explode('_',$vew_data->flesrctyp)[0];
	$lv_prgcod = explode('_',$vew_data->flesrctyp)[1];
?>
<section id="<?= $lv_sec; ?>">

  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<?php if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'U1')){ ?><a href="#" id="btnupl" class="btn btn-default navbar-btn" title="<?= $vew_lang->upload; ?>"><i class="fas fa-upload"></i><span class="hidden-xs"> <?= $vew_lang->upload; ?></span></a><?php } ?>
				<?php if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'U3')){ ?><a href="#" id="btnvew" class="btn btn-default navbar-btn hidden" title="<?= $vew_lang->view; ?>"><i class="fas fa-glasses"></i><span class="hidden-xs"> <?= $vew_lang->view; ?></span></a><?php } ?>
				<?php if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'U3')){ ?><a href="#" id="btndwn" class="btn btn-default navbar-btn hidden" title="<?= $vew_lang->download; ?>"><i class="fas fa-download"></i><span class="hidden-xs"> <?= $vew_lang->download; ?></span></a><?php } ?>
				<?php if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'U4')){ ?><a href="#" id="btndel" class="btn btn-danger navbar-btn hidden" title="<?= $vew_lang->delete; ?>"><i class="fas fa-trash-alt"></i><span class="hidden-xs"> <?= $vew_lang->delete; ?></span></a><?php } ?>
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<a href="#" id="btnrfh" class="btn btn-default navbar-btn"><span class="fas fa-sync-alt"></span></a>
			</ul>
		</div>
  </nav>
	
	<table class="table table-condensed table-hover" id="tblfle">
		<thead>
			<tr>
				<th><?= $vew_lang->file; ?></th>
        <th class="hidden-xs hidden-sm"><?= $vew_lang->type; ?></th>
				<th class="hidden-xs hidden-sm"><?= $vew_lang->registry; ?></th>
				<th class="hidden-xs hidden-sm"><?= $vew_lang->size; ?></th>
			</tr>
		</thead>
		<tbody></tbody>
	</table>
	
	<a href="#" class="hidden" id="lnkdwn" target="_blank">
	
	<script>
		// UPLOAD
		<?php if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'U1')){ ?>
		$("#<?= $lv_sec; ?> #btnupl").on("click",function(e){ e.preventDefault();
			var lv_pstdat = [
				{name:"flesrctyp",value:"<?= $vew_data->flesrctyp; ?>"},
				{name:"flesrccod",value:"<?= $vew_data->flesrccod; ?>"},
				{name:"fletypcod",value:"<?= $vew_data->fletypcod; ?>"},
        {name:"sysdocclscod",value:"<?= $vew_data->sysdocclscod; ?>"},
				{name:"flecod",value:$("#<?= $lv_sec; ?> .tmssContainer").data("flecod")}
			];
			tmssCallProcess("?prg=grldatupl&act=showUpload", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->upload; ?>",
					message: $(data),
					type: BootstrapDialog.TYPE_PRIMARY,
					size: BootstrapDialog.SIZE_WIDE,
					buttons: [{ id:"btncam", icon: "fas fa-camera", label: "<span class='hidden-xs'>Usar la </span>C&aacute;mara",	cssClass: "btn-default pull-left hidden",
											action: function(dialog){ $(dialog.$modalBody).find("#btncam").trigger("click"); }
										},
										{	id:"btnfle", icon: "far fa-file", label: "<span class='hidden-xs'>Subir un </span>Archivo", cssClass: "btn-default pull-left hidden",
											action: function(dialog){ $(dialog.$modalBody).find("#btnfle").trigger("click"); }
										},
										{ id:"btndwn", icon: "fas fa-download", label: "<?= $vew_lang->download; ?>", cssClass: "btn-default hidden",
											action: function(dialog){ $(dialog.$modalBody).find("#btndwn").trigger("click"); }
										},
										{ id:"btndel", icon: "fas fa-times", label: "<?= $vew_lang->delete; ?>", cssClass: "btn-danger hidden",
											action: function(dialog){ $(dialog.$modalBody).find("#btndel").trigger("click"); }
										},
										{ id:"btnupl", icon: "far fa-save", label: "<?= $vew_lang->save; ?>", cssClass: "btn-success hidden",
											action: function(dialog){ $(dialog.$modalBody).find("#btnsve").trigger("click"); }
										}],
					onhide: function(dialogRef){ <?= $lv_sec; ?>_refreshList(); }
				});
			});
		});
		<?php } ?>
		
		
		// DOWNLOAD
		<?php if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'U3')){ ?>
		$("#<?= $lv_sec; ?> #btndwn").on("click",function(e){ e.preventDefault();
			var lv_flecod = $("#<?= $lv_sec; ?> #tblfle tbody tr.bg-info:first").data("flecod");
			window.open( "?prg=grldatupl&act=downloadFile&prm_flesrctyp=<?= $vew_data->flesrctyp; ?>&prm_flesrccod=<?= $vew_data->flesrccod; ?>&prm_flecod="+lv_flecod );
		});
		<?php } ?>
		
		
		// DELETE
		<?php if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'U4')){ ?>
		$("#<?= $lv_sec; ?> #btndel").on("click",function(e){ e.preventDefault();
			var lv_flecod = $("#<?= $lv_sec; ?> #tblfle tbody tr.bg-info:first").data("flecod");
			var lv_fletxt = $("#<?= $lv_sec; ?> #tblfle tbody tr.bg-info td:first").text();
			BootstrapDialog.confirm({
				title: "<?= $vew_lang->delete; ?>",
				message: "¿Desea borrar el documento <strong>"+lv_fletxt+"</strong> ?",
				type: BootstrapDialog.TYPE_WARNING,
				callback: function(result) {
					if(result) {
						var lv_pstdat = [{name:"flesrctyp",value:"<?= $vew_data->flesrctyp; ?>"},{name:"flesrccod",value:"<?= $vew_data->flesrccod; ?>"},{name:"flecod",value:lv_flecod}];
						tmssCallProcess("?prg=grldatupl&act=deleteFile", lv_pstdat, function(data){
							toastr.warning("Documento borrado", "<?= $vew_lang->attachments; ?>");
							<?= $lv_sec; ?>_refreshList();
						});
					}
				}
			});
		});
		<?php } ?>
		
		
		// VIEW
		<?php if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'U3')){ ?>
		$("#<?= $lv_sec; ?> #btnvew").on("click",function(e){ e.preventDefault();
			var lv_pstdat =[{name:"flesrctyp",value:"<?= $vew_data->flesrctyp; ?>"},
											{name:"flesrccod",value:"<?= $vew_data->flesrccod; ?>"},
											{name:"flecod",value:$("#<?= $lv_sec; ?> #tblfle tbody tr.bg-info:first").data("flecod")},
                      {name:"sysdocclscod",value:"<?= $vew_data->sysdocclscod; ?>"},
											{name:"fletypcod",value:$("#<?= $lv_sec; ?> #tblfle tbody tr.bg-info:first").data("fletypcod")}];
			tmssCallProcess("?prg=grldatupl&act=showUpload", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->attachment; ?>",
					message: $(data),
					type: BootstrapDialog.TYPE_PRIMARY,
					size: BootstrapDialog.SIZE_WIDE,
					buttons: [{ id:"btncam", icon: "fas fa-camera", label: "<span class='hidden-xs'>Usar la </span>C&aacute;mara",	cssClass: "btn-default pull-left hidden",
											action: function(dialog){ $(dialog.$modalBody).find("#btncam").trigger("click"); }
										},
										{	id:"btnfle", icon: "far fa-file", label: "<span class='hidden-xs'>Subir un </span>Archivo", cssClass: "btn-default pull-left hidden",
											action: function(dialog){ $(dialog.$modalBody).find("#btnfle").trigger("click"); }
										},
										{ id:"btndwn", icon: "fas fa-download", label: "<?= $vew_lang->download; ?>", cssClass: "btn-default hidden",
											action: function(dialog){ $(dialog.$modalBody).find("#btndwn").trigger("click"); }
										},
										<?php if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'U4')){ ?>
										{ id:"btndel", icon: "fas fa-times", label: "<?= $vew_lang->delete; ?>", cssClass: "btn-danger hidden",
											action: function(dialog){ $(dialog.$modalBody).find("#btndel").trigger("click"); }
										},
										<?php } ?>
										{ id:"btnupl", icon: "far fa-save", label: "<?= $vew_lang->save; ?>", cssClass: "btn-success hidden",
											action: function(dialog){ $(dialog.$modalBody).find("#btnsve").trigger("click"); }
										}],
					onhide: function(dialogRef){ <?= $lv_sec; ?>_refreshList(); }
				});
			});
		});
		<?php } ?>
		
		
		// REFRESH
		$("<?= $lv_sec; ?> #btnrfh").on("click",function(e){ e.preventDefault();
			<?= $lv_sec; ?>_refreshList();
		});
		
		
		// set principal
		$("#<?= $lv_sec; ?> #ppllnk").on("click",function(e){ e.preventDefault();
			var lv_flecod = $(this).data("flecod");
			tmssCallProcess("?prg=grldatupl&act=12&prm_flesrctyp=<?= $vew_data->flesrctyp; ?>&prm_flesrccod=<?= $vew_data->flesrccod; ?>&prm_lv_sec=<?= $vew_data->vew_sec; ?>&prm_flecod="+ lv_flecod,{}, function(data){
				<?= $lv_sec; ?>_refreshList();
			});
		});
		
		
		// refresh list
		function <?= $lv_sec; ?>_refreshList() {
			var lv_pstdat = [{name:"flesrctyp",value:"<?= $vew_data->flesrctyp; ?>"},{name:"flesrccod",value:"<?= $vew_data->flesrccod; ?>"},{name:"sysdocclscod",value:"<?= $vew_data->sysdocclscod; ?>"},];
			tmssCallProcessNoBackdrop("?prg=grldatupl&act=getUploadList",lv_pstdat,function(data){
				$("#<?= $lv_sec; ?> #btnvew").addClass("hidden");
				$("#<?= $lv_sec; ?> #btndel").addClass("hidden");
				$("#<?= $lv_sec; ?> #btndwn").addClass("hidden");
				var lv_buf = "";
				var lv_flesze;
				var lv_fleszecnv;
				var lv_ctedte;
        var lv_duedte;
				for(var i=0; i<data.length; i++){
					lv_flesze = data[i]["flesze"];
					lv_fleszecnv = "";
					try{
						var x = Math.floor( Math.log(lv_flesze) / Math.log(1024) );
						lv_fleszecnv = ( lv_flesze / Math.pow(1024, x) ).toFixed(1) * 1 + " " + ["b", "kb", "mb", "gb", "tb"][x];
					} catch(e){}
					lv_ctedte = moment( data[i]["ctedte"].date ).format("DD/MM/Y HH:mm");
          lv_duedte = (data[i]["fleduedte"])?moment(data[i]["fleduedte"]["date"]).format("DD/MM/YYYY"):"";
					lv_buf += "<tr data-flecod='"+data[i]["flecod"]+"' data-fletypcod='"+data[i]["fletypcod"]+"'><td>"+data[i]["flenme"]+"</td><td>"+data[i]["fletyptxt"]+((data[i]["fleduedte"])?" <br><small> VTO: "+lv_duedte+"</small> ":"")+"</td><td class='hidden-xs hidden-sm'>"+lv_ctedte+"<br><small>"+data[i]["cteusr"].toLowerCase()+"</small></td><td class='hidden-xs hidden-sm'>"+lv_fleszecnv+"</td></tr>";
        }
				$("#<?= $lv_sec; ?> #tblfle tbody").html( lv_buf );

				// attach file selection
				$("#<?= $lv_sec; ?> #tblfle tbody tr").on("click",function(e){ e.preventDefault();
					if( $(this).hasClass("bg-info") ) {
						$(this).removeClass("bg-info")
						$("#<?= $lv_sec; ?> #btnvew").addClass("hidden");
						$("#<?= $lv_sec; ?> #btndel").addClass("hidden");
						$("#<?= $lv_sec; ?> #btndwn").addClass("hidden");
					} else {
						$("#<?= $lv_sec; ?> #tblfle tbody tr").removeClass("bg-info");
						$(this).addClass("bg-info");
						$("#<?= $lv_sec; ?> #btnvew").removeClass("hidden");
						$("#<?= $lv_sec; ?> #btndwn").removeClass("hidden");
						$("#<?= $lv_sec; ?> #btndel").removeClass("hidden");
					}
				});
				
			});
		}
		
		
		$(function(){
			<?= $lv_sec; ?>_refreshList();
		});
	</script>
</section>
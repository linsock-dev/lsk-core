<?php if($lv_dockey != ''){ ?> 
	<nav class="navbar navbar-default tmss-navbar">
		<div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','01')) { ?><a href="#" id="grldatcntbtnnew" class="btn btn-default navbar-btn"><span class="far fa-file"></span><span class="hidden-xs"> Nuevo</span></a><?php } ?>
			</ul>
			<ul class="nav navbar-nav navbar-right tmss-navbar-right">
				<input type="text"  class="form-control tmssAlwaysEnabled mt-6" id="grldatcntfndtxt" placeholder="Buscar...">
			</ul>
		</div>
	</nav>
	<div class="table-responsive">
		<table id="grldatcnttbl" class="table table-striped table-condensed">
			<tbody></tbody>
		</table>
	</div>
	<script>  
		// REFRESH
		function <?= $lv_sec; ?>_GridRefresh() {
      $("#<?= $lv_sec; ?> #grldatcnttbl tbody").html( "<tr><td><i class='far fa-gear fa-spin'></i> Cargando lista de contactos...</td></tr>" );
			var lv_buffer = "";
      var lv_sysdocclscodcnt = '<?= $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'grlcnt_sysdocclscod'); ?>';
			tmssCallProcessNoBackdrop("?prg=grldatcnt&act=09&prm_cntsrctyp=<?= $lv_mdlcod."_".$lv_prgcod; ?>&prm_cntsrccod=<?= $lv_dockey; ?>&prm_bcksec=<?= $lv_sec; ?>", [], function(data) {
        $("#<?= $lv_sec; ?> #grldatcnttbl tbody").html( "" );
				if( data.list.length==0 ){
        	$("#<?= $lv_sec; ?> #grldatcnttbl tbody").html( "<tr><td>No hay contactos cargados.</td></tr>" );
        }
        for( var i=0; i<data.list.length; i++){   
					lv_buffer += "<tr>"; 
					lv_buffer += "<td width='60' class='text-center'><i class='far fa-user-circle fa-2x' style='margin-top:10px;'></i></td>";
					lv_buffer += "<td class='v-align-middle' data-cntcod='1'><a href='#' name='grldatcnttxt' data-id="+data.list[i].cntcod+"><h5><strong>"+( (data.list[i].cntdsttxt != "" && data.list[i].cntdsttxt != null) ? data.list[i].cntdsttxt : data.list[i].cnttxt )+"</strong><br><small>"+data.list[i].sysdocclstxtcnt+"</small></h5></a></td>";
					lv_buffer += "<td class='v-align-middle' class='hidden-xs'><a href='#'>"+(data.list[i].adreml != "" && data.list[i].adreml != null ? data.list[i].adreml : "")+"</a></td>";
					lv_buffer += "<td class='v-align-middle' class='hidden-xs hidden-sm'><a href='#''>"+(data.list[i].adrphn001 != "" && data.list[i].adrphn001 != null ? data.list[i].adrphn001 : "")+"</a></td>";
					lv_buffer += "<td class='v-align-middle' class='hidden-xs hidden-sm hidden-md'><a href='#'>"+(data.list[i].adrmblphn != "" && data.list[i].adrmblphn != null ? data.list[i].adrmblphn : "")+"</a></td>";
					<?php if( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','04') ) { ?> 
						lv_buffer += "<td width='60' class='v-align-middle' class='text-center'><a href='#' id='grldatcntdellnk' class='btn btn-danger' title='+<?= $vew_lang->delete; ?>+' data-cntcod="+data.list[i].cntcod+" data-cnttxt="+data.list[i].cnttxt+"><span class='fas fa-trash-alt'></span></a></td>";
					<?php } ?>
					lv_buffer += "</tr>";
				}
				$("#<?= $lv_sec; ?> #grldatcnttbl tbody").html( lv_buffer );

				// reaplica el filtro de búsqueda sobre la lista recién cargada
				<?= $lv_sec; ?>_GridFilter();

				<?php if ( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','03') ) { ?>
					// VISUALIZAR
					$("#<?= $lv_sec; ?> a[name='grldatcnttxt']").on("click",function(e){      
						tmssLink("?prg=grldatcnt&act=03&prm_cntcod="+$(this).data("id")+"&prm_cntsrctyp=<?= $lv_mdlcod."_".$lv_prgcod; ?>&prm_srcdocclscod="+$("#<?= $lv_sec; ?> #sysdocclscod").val()+"&prm_cntsrccod=<?= $lv_dockey; ?>&prm_bcksec=<?= $lv_sec; ?>", [{target: "_new_section"}]);
					});
				<?php } ?>

				<?php if ( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','04') ) { ?>
					// BORRAR
					$("#<?= $lv_sec; ?> #grldatcntdellnk").on("click",function(e){
						var lv_cntcod = $(this).data("cntcod");
						BootstrapDialog.confirm({
							title: "Borrar",
							message: "¿Desea borrar el documento <strong>"+$(this).data("cnttxt")+"</strong> ?",
							type: BootstrapDialog.TYPE_WARNING,
							callback: function(result) {
								if(result) {
									tmssCallProcess("?prg=grldatcnt&act=04&prm_bcksec=<?= $lv_sec; ?>", [{name:"cntcod",value:lv_cntcod},{name:"cntsrctyp",value:"<?= $lv_mdlcod."_".$lv_prgcod; ?>"},{name:"cntsrccod",value:"<?= $lv_dockey; ?>"}], function(data){
										toastr.success("Documento borrado", "<?= $vew_lang->contact; ?>");
										<?= $lv_sec; ?>_GridRefresh();
									});
								}
							}
						});
					});
				<?php } ?>				
			});
		}
		
    // FILTRO. muestra/oculta las filas de la lista según el texto buscado (filtrado en cliente)
    function <?= $lv_sec; ?>_GridFilter() {
      var lv_txt = $("#<?= $lv_sec; ?> #grldatcntfndtxt").prop("value").toLowerCase();
      $("#<?= $lv_sec; ?> #grldatcnttbl > tbody > tr").each(function(x){
        if ($(this).text().toLowerCase().indexOf( lv_txt )!=-1) {
          $(this).removeClass("hidden");
        } else {
          $(this).addClass("hidden");
        }
      });
    }

    // BUSCAR
    $("#<?= $lv_sec; ?> #grldatcntfndtxt").on("keyup",function(e){e.preventDefault();e.stopPropagation();
      <?= $lv_sec; ?>_GridFilter();
		});
    
    //evita que el formulario se entere del evento submit
    $("#<?= $lv_sec; ?> #grldatcntfndtxt").keydown(function(e){
      if(e.keyCode == 13) {
        e.preventDefault();
        return false;
      }
    });

		<?php if ( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','01') ) { ?>
			// CREAR
			$("#<?= $lv_sec; ?> #grldatcntbtnnew").on("click",function(e){
				tmssLink("?prg=grldatcnt&act=01&prm_cntsrctyp=<?= $lv_mdlcod."_".$lv_prgcod; ?>&prm_srcdocclscod="+$("#<?= $lv_sec; ?> #sysdocclscod").val()+"&prm_cntsrccod=<?= $lv_dockey; ?>&prm_bcksec=<?= $lv_sec; ?>", [{target: "_new_section"}]);
			});
		<?php } ?>
		
		
		$(function(){
			$("#<?= $lv_sec; ?> #grldatcntfndtxt").focus();
      <?= $lv_sec; ?>_GridRefresh();     // Carga de lista de contactos
		});
	</script>
<?php } ?>
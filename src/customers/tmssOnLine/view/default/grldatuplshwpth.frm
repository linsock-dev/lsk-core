<?php if(isset($lv_mdlcod) && isset($lv_prgcod) && isset($lv_dockey) && isset($lv_sec) && isset($vew_sec) && isset($vew_doc) && isset($vew_data)){ ?>
<?php
	// muestra las fotos disponibles de un objeto (requiere que se defina un tipo de archivo)
	// requiere:
	// - variables globales: $lv_mdlcod / $lv_prgcod
	// - objetos globales: $vew_doc / $vew_lang / $vew_data->sysdoccls
	// - parámetro de clase de documento [fletypcodpic]
	$lv_grldatupl_objtyp 		= $lv_mdlcod.'_'.$lv_prgcod;
	$lv_grldatupl_fletypcod = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'fletypcodpic');
	$lv_grldatupl_sysdocclscod = $vew_data->sysdoccls->sysdocclscod;
	$lv_grldatupl_edt 			= ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02') && $lv_dockey!='');
?>
<section>
	<div class="grldatupl_divpic">
		<?php if($lv_grldatupl_fletypcod!='' && $lv_grldatupl_fletypcod!='0'){ ?>
			<div class="row">
        <div class="col-xs-1">
					<a href="#" id="gallery_btnupl" class="tmss-table-icon " title="Subir"><i class="fas fa-upload"></i></a>
        </div>
				<div class="col-xs-11">
          <i class="fas fa-chevron-right grldatupl_gallery_btnnext " id="btnscrollright"></i>
          <i class="fas fa-chevron-left grldatupl_gallery_btnback" id="btnscrollleft"></i>
					<div class="grldatupl_gallery_slide" id="grldatupl_phtgal"></div>
        </div>
			</div>
    <hr class="grldatupl_gallery_hr">
      <div class="col-xs-12">
      	<div class="grldatupl_container_gallery grldatupl_container" id="grldatupl_btnvew" data-flecod=""><div class="grldatupl_link"><i class="fas fa-camera"></i><p><?= ($lv_grldatupl_edt?$vew_lang->update:$vew_lang->view); ?></p></div></div>
      </div>
		<?php } else { ?>
			<div class="grldatupl_container" id="grldatupl_btnvew" data-flecod="" ><div class="grldatupl_link"><i class="fas fa-camera"></i><p><?= ($lv_grldatupl_edt?$vew_lang->update:$vew_lang->view); ?></p></div></div>
		<?php } ?>
	</div>
	<script>		
		<?php if($lv_grldatupl_fletypcod!='' && $lv_grldatupl_fletypcod!='0'){ ?>
			// Get main photo on load
			$(function(){ <?= $lv_sec; ?>_grldatupl_showGallery(); });
		
			// muestra la galería de fotos del objeto
			function <?= $lv_sec; ?>_grldatupl_showGallery(){
				$("#<?= $lv_sec; ?> #grldatupl_phtgal").html("");
				var lv_pstdat =[{name:"flesrctyp",value:"<?= $lv_grldatupl_objtyp; ?>"},
												{name:"flesrccod",value:"<?= $lv_dockey; ?>"},
												{name:"fletypcod",value:"<?= $lv_grldatupl_fletypcod; ?>"},
                       	{name:"sysdocclscod",value:"<?= $lv_grldatupl_sysdocclscod; ?>"}];
				tmssCallProcessNoBackdrop("?prg=grldatupl&act=getUploadList",lv_pstdat,function(data){
					for(var i=0; i<data.length; i++){
						var lv_pstdat2 =[{name:"flesrctyp",value:"<?= $lv_grldatupl_objtyp; ?>"},
														{name:"flesrccod",value:"<?= $lv_dockey; ?>"},
														{name:"flecod",value:data[i]["flecod"]},
														{name:"fletypcod",value:"<?= $lv_grldatupl_fletypcod; ?>"}];
						var lv_pic = $("<div class='tmss-spinner'></div>");
						$(lv_pic).appendTo( $("#<?= $lv_sec; ?> #grldatupl_phtgal") );
						tmssCallProcessNoBackdrop("?prg=grldatupl&act=getFile&prm_content=x",lv_pstdat2,function(data2){
							var lv_img = "";
							if(data2["fleimg"]==false){
								lv_img = "/library/images/icon_file.png";
							} else if(data2["flecnt"]==""){
								lv_img = "/library/images/TemasisArgentina_Isotipo_280gray.png";
							} else {
								lv_img = "data:image/jpeg;base64,"+data2["flecnt"];
							}
              var lv_pic2 = $(".tmss-spinner").first();
              $(lv_pic2).attr("data-flecod",data2["flecod"]);
              $(lv_pic2).removeClass("tmss-spinner").addClass("grldatupl_gallery");
							$(lv_pic2).css("background-image" , "url("+lv_img+")" );
							$(lv_pic2).on("click",function(e){ e.preventDefault(); <?= $lv_sec; ?>_grldatupl_selPhoto( $(this).data("flecod") ); });
             	//si la cantidad de fotos ocupa mas espacio del que hay para mostrar , muestra el boton next para deslizar
              if(  $('#grldatupl_phtgal')[0].scrollWidth !=$('#grldatupl_phtgal')[0].clientWidth  ){
      					$('#btnscrollright').show('slow');
      				}
              //Si está seteada como imagne principal, la muestra a la derecha al cargar
              if($("<div>"+data2['fleatr']+"<div>").find("ppl").text() == "1"){
                $("#<?= $lv_sec; ?> .grldatupl_container").css("background-image", $("#<?= $lv_sec; ?> .grldatupl_gallery[data-flecod='"+data2.flecod+"']").css("background-image") );
								$("#<?= $lv_sec; ?> .grldatupl_container").data("flecod",data2.flecod);
              }
						});
					}
				});
			}

			// asigna la imagen seleccionada y el id
			function <?= $lv_sec; ?>_grldatupl_selPhoto( lp_flecod ){
				$("#<?= $lv_sec; ?> .grldatupl_container").css("background-image", $("#<?= $lv_sec; ?> .grldatupl_gallery[data-flecod='"+lp_flecod+"']").css("background-image") );
				$("#<?= $lv_sec; ?> .grldatupl_container").data("flecod",lp_flecod);
			}

		<?php } else { ?>
		
			// Get main photo on load
			$(function(){ <?= $lv_sec; ?>_grldatupl_showMainPhoto(); });

			// obtiene la foto principal del documento
			function <?= $lv_sec; ?>_grldatupl_showMainPhoto() {
				var lv_flecod = $("#<?= $lv_sec; ?> .grldatupl_container").data("flecod");
				var lv_pstdat =[{name:"flesrctyp",value:"<?= $lv_grldatupl_objtyp; ?>"},
												{name:"flesrccod",value:"<?= $lv_dockey; ?>"},
												{name:"flecod",value:lv_flecod},
												{name:"fletypcod",value:"<?= $lv_grldatupl_fletypcod; ?>"}];
				tmssCallProcessNoBackdrop("?prg=grldatupl&act=getFile"+(lv_flecod!=""?"":"&prm_main=x")+"&prm_content=x", lv_pstdat, function(data){
					$("#<?= $lv_sec; ?> .grldatupl_container").data("flecod",data["flecod"]);
					if(data["fleimg"]==false){
						$("#<?= $lv_sec; ?> .grldatupl_container").css("background-image", "url(/library/images/icon_file.png)");
					} else if(data["flecnt"]==""){
						$("#<?= $lv_sec; ?> .grldatupl_container").css("background-image" , "url(/library/images/TemasisArgentina_Isotipo_280gray.png)" );						
					} else {
						$("#<?= $lv_sec; ?> .grldatupl_container").css("background-image", "url(data:image/jpeg;base64,"+data["flecnt"]+")");
					}
					var lv_img = (data["flecnt"] ? "data:image/jpeg;base64,"+data["flecnt"] : "");
					lv_img = (lv_img!=""?lv_img:"/library/images/TemasisArgentina_Isotipo_280gray.png");
					$("#<?= $lv_sec; ?> .grldatupl_container").css("background-image" , "url("+lv_img+")" );
				});
			}
			
		<?php } ?>
		
		// ver-actualizar
		$("#<?= $lv_sec; ?> #grldatupl_btnvew").on("click",function(e){ e.preventDefault();
    	<?= $lv_sec; ?>_ShowUpload( $("#<?= $lv_sec; ?> .grldatupl_container").data("flecod") );
    });
    
    //showupload con valor '' para subir imagen
    $("#<?= $lv_sec; ?> #gallery_btnupl").on("click",function(e){ e.preventDefault();
    	<?= $lv_sec; ?>_ShowUpload('');
    });
    
    //scroll para la izquierda- y mostrar boton de flecha para la izquierda
    $("#<?= $lv_sec; ?> #btnscrollright").on("click",function(e){
      $lv_scroll=$('#grldatupl_phtgal')[0].scrollLeft+200;
      $("#grldatupl_phtgal").animate({scrollLeft:"+=200"},1000);
      $('#btnscrollleft').show('slow');
      if( $('#grldatupl_phtgal')[0].scrollWidth-$lv_scroll   < $('#grldatupl_phtgal')[0].clientWidth+2 ){
      	$('#btnscrollright').hide('slow');
      }
    });
    
    //scroll para la derecha- y mostrar boton de flecha para la derecha
    $("#<?= $lv_sec; ?> #btnscrollleft").on("click",function(e){
      $lv_scroll=$('#grldatupl_phtgal')[0].scrollLeft-200;
      $("#grldatupl_phtgal").animate({scrollLeft:"-=200"},1000);
      $('#btnscrollright').show('slow'); 
      if($lv_scroll<2){
        $('#btnscrollleft').hide('slow');
      }
    });
    
    //ver-subir imagen
    function <?= $lv_sec; ?>_ShowUpload( lp_flecod ){
      var lv_pstdat = [
          {name:"flesrctyp",value:"<?= $lv_grldatupl_objtyp; ?>"},
          {name:"flesrccod",value:"<?= $lv_dockey; ?>"},
          {name:"fletypcod",value:"<?= $lv_grldatupl_fletypcod; ?>"},
          {name:"flecod",value:lp_flecod},
					{name:"sysdocclscod",value:"<?= $lv_grldatupl_sysdocclscod; ?>"},
          {name:"sec",value:"<?= $lv_sec; ?>"},
					{name:"readonly",value:"<?= $vew_readonly; ?>"}
      ];
      tmssCallProcess("?prg=grldatupl&act=showUpload", lv_pstdat, function(data){
          BootstrapDialog.show({
            title: "<?= $vew_lang->image; ?>",
            message: $(data),
            type: BootstrapDialog.TYPE_PRIMARY,
            size: BootstrapDialog.SIZE_WIDE,
            <?php if($lv_grldatupl_edt) { ?>
              buttons: [{ id:"btncam", icon: "fas fa-camera", label: "<span class='hidden-xs'>Usar la </span>C&aacute;mara", cssClass: "btn-default pull-left hidden",
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
            <?php } ?>
          
					onhide: function(dialogRef){ 
						if( typeof <?= $lv_sec; ?>_grldatupl_btnuplupl_refresh!=="undefined"){<?= $lv_sec; ?>_grldatupl_btnuplupl_refresh();}
						if( typeof <?= $lv_sec; ?>_grldatupl_showMainPhoto!=="undefined"){<?= $lv_sec; ?>_grldatupl_showMainPhoto();}
						if( typeof <?= $lv_sec; ?>_grldatupl_showGallery!=="undefined"){<?= $lv_sec; ?>_grldatupl_showGallery();}
					}
				});
			});                                                                  
    }
	</script>
</section>
<?php } ?>
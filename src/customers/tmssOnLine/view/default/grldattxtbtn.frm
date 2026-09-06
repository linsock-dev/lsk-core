<?php if(isset($lv_mdlcod) && isset($lv_prgcod) && (isset($lv_dockey)?$lv_dockey:'')!='' && is_object($vew_data->sysdoccls) === true ){ $lv_txt_readonly = !($vew_tbl_int['modL']['per']??true); ?>
<span name="grldattxtbtn_span"></span>
<a href="hidden" id="btnupdsts"></a>
<script>
	$(function(){
    // revisa si hay tipos de textos asignados para determinar si mostrar el boton
		var lv_pstdat =[{name:"sysdocclscod", value:$("#<?= $lv_sec; ?> #sysdocclscod").val()}];
    
    tmssCallProcessNoBackdrop("?prg=sysdocclstxt&act=18", lv_pstdat,  function(data){ 
      if( data.length > 0 ){ 

				// TEXTOS. preparo boton y desplegable con los textos
				var lv_buffer = "<div class='btn-group dropdown'>"
											+ "<a href='#' class='btn navbar-btn tmss-navbar-btn dropdown-toggle' data-toggle='dropdown'><i class='far fa-text'></i><span class='badge'>"+data.length+"</span></a>"
											+ "<form class='dropdown-menu dropdown-menu-right tmssBrandMnuUsr' aria-labelledby='dLabel' name='grldattxtbtn_form'>"
				for(var i=0; i<data.length; i++){
					lv_buffer += "<li><a href='#' data-sysdocclstxtcod='"+data[i].txtcod+"' data-txttypcod='"+data[i].txttypcod+"' data-txttyptxt='"+data[i].txttyptxt.toLowerCase()+"' class='tmss-Opt'><i class='far fa-square'></i>"+data[i].txttyptxt.toLowerCase()+"</a></li>";
				}
				lv_buffer += "</form></div>";
				$("#<?= $lv_sec; ?> span[name=grldattxtbtn_span]").html( lv_buffer );
					
        // STATUS. actualizo status de textos
        $("#<?= $lv_sec; ?> #btnupdsts").trigger("click");
				
				// VER TEXTO. cargo texto (onClick)
				$("#<?= $lv_sec; ?> form[name=grldattxtbtn_form] a").on("click",function(e){ e.preventDefault();
					var lv_txttyptxt = $(this).data("txttyptxt");
          var lv_txtcod = $(this).data("txtcod");
					var lv_pstdat2=[{name:"txtcod", value:lv_txtcod},
													{name:"txtsrctyp", value:"<?= $lv_mdlcod.'_'.$lv_prgcod; ?>"},
													{name:"txtsrccod", value:"<?= $lv_dockey; ?>"},
													{name:"sysdocclscod", value:$("#<?= $lv_sec; ?> #sysdocclscod").val()},
													{name:"txttypcod",value:$(this).data("txttypcod")},
                          {name:"sysdocclstxtcod", value:$(this).data("sysdocclstxtcod")},
													{name:"readonly", value:<?= ($lv_txt_readonly?'true':'false'); ?> }];
					tmssCallProcess("?prg=grldattxt&act=dialog", lv_pstdat2,  function(data2){ 
						BootstrapDialog.show({
							title: lv_txttyptxt,
							type: BootstrapDialog.TYPE_PRIMARY,
							size: BootstrapDialog.SIZE_WIDE,
							draggable:true,
							closable:true,
							message: $(data2)
              <?php if(!$lv_txt_readonly){ ?>
							,buttons: [{ label: "<?= $vew_lang->cancel; ?>", id:"btncls", cssClass: "btn-danger", action: function(dialog){ dialog.close(); } },
												{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success", action:function(dialog){
														var lo_body = dialog.getModalBody();
														$(lo_body).find("#btnsve").data("btn_callback", function() {
                              $("#<?= $lv_sec; ?> #btnupdsts").data("callback", function(){
                                if($("#<?= $lv_sec; ?> #btnsve").data("no_cls") == undefined){
                                  dialog.close();
                                }
                            	}).trigger("click");
                        		}).trigger("click");
													}
												},
                        {label: "<?= $vew_lang->delete; ?>", id:"btndel", cssClass: "btn-warning pull-left", action: function(dialog){ 
														var lo_body = dialog.getModalBody();
														$(lo_body).find("#btndel").data("btn_callback", function() {
                              $("#<?= $lv_sec; ?> #btnupdsts").data("callback", function(){
                                if($("#<?= $lv_sec; ?> #btndel").data("no_cls") == undefined){
                                  dialog.close();
                                }
                            	}).trigger("click");
                        		}).trigger("click");
                        }}
                        ],
              onshow: function(dialog){
                var lo_body = dialog.getModalBody();
                if( $(lo_body).find("#txtcod").val()=="" ){
                  dialog.getModalFooter().find("#btndel").addClass("hidden");
                }
              }
              <?php } ?>
						});
					});
				});
					
			}
    });
	});

  // STATUS. actualizo status de textos
  $("#<?= $lv_sec; ?> #btnupdsts").on("click",function(e){e.preventDefault();
    var lv_callback = $(this).data("callback");
    var lv_pstdat2=[{name:"txtsrctyp", value:"<?= $lv_mdlcod.'_'.$lv_prgcod; ?>"},
                    {name:"txtsrccod", value:"<?= $lv_dockey; ?>"}]
    tmssCallProcessNoBackdrop("?prg=grldattxt&act=18", lv_pstdat2,  function(data2){ 
      $("#<?= $lv_sec; ?> span[name=grldattxtbtn_span] > div > a").removeClass("btn-success");
      $("#<?= $lv_sec; ?> form[name=grldattxtbtn_form] a").data("txtcod","");
      $("#<?= $lv_sec; ?> form[name=grldattxtbtn_form] a i").prop("class","far fa-square");
      for(var i=0; i<data2.length; i++){
        $("#<?= $lv_sec; ?> form[name=grldattxtbtn_form] a[data-txttypcod="+data2[i]["txttypcod"]+"]").data("txtcod",data2[i]["txtcod"]);
        $("#<?= $lv_sec; ?> form[name=grldattxtbtn_form] a[data-txttypcod="+data2[i]["txttypcod"]+"] i").prop("class","far fa-check");
      } 
      if( $("#<?= $lv_sec; ?> form[name=grldattxtbtn_form] a").length==data2.length ){
        $("#<?= $lv_sec; ?> span[name=grldattxtbtn_span] > div > a").addClass("btn-success");
      }
    	if(typeof lv_callback === "function") lv_callback();
    });
  });
</script>
<?php } ?>
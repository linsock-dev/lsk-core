<?php if(isset($lv_mdlcod) && isset($lv_prgcod) && (isset($lv_dockey)?$lv_dockey:'')!='' && is_object($vew_data->sysdoccls) === true ){ ?>
<span name="grldatfrmbtn_span"></span>
<script>
	$(function(){ 

    // formulario es requerido (0/1 o "Si"/"No")
    function <?=$lv_sec; ?>_isFrmRequired(row){
      var v = row.sysdocclsfrmreq;
      if (v === true) return true;
      if (v === 1 || v === "1") return true;
      if (typeof v === "string" && v.toLowerCase() === "si") return true;
      return false;
    }

    window["<?=$lv_sec; ?>_frmreq_toasts"] = window["<?=$lv_sec; ?>_frmreq_toasts"] || {};

    // revisa si hay formularios asignados para determinar si mostrar el boton
    var lv_pstdat = $("#<?= $lv_sec; ?>_frm").serializeArray();
		lv_pstdat.push({name:"srcobjtyp",    value:"<?= $lv_mdlcod.'_'.$lv_prgcod; ?>"});
    lv_pstdat.push({name:"srcobjcod001", value:"<?= $lv_dockey; ?>"});
    <?= (isset($lv_dockey002)?'lv_pstdat.push({name:"srcobjcod002",value:"'.$lv_dockey002.'"});':''); ?>

    tmssCallProcessNoBackdrop("?prg=grldatfrm&act=18", lv_pstdat,  function(data){ 
      if( data.length > 0 ){ 

				// FORMULARIOS. preparo boton y desplegable con los formularios
				var lv_buffer = "<div class='btn-group dropdown'>"
											+ "<a href='#' class='btn navbar-btn tmss-navbar-btn dropdown-toggle' data-toggle='dropdown'><i class='far fa-table-layout'></i><span class='badge'>"+data.length+"</span></a>"
											+ "<form class='dropdown-menu dropdown-menu-right tmssBrandMnuUsr' aria-labelledby='dLabel' name='grldatfrmbtn_form'>"

				for(var i=0; i<data.length; i++){
					var lv_frmdat = (data[i].frmdatcod && data[i].frmdatcod!="") ? data[i].frmdatcod : "";
					var lv_icon   = (lv_frmdat!="") ? 'far fa-check' : 'far fa-square';
					lv_buffer += "<li><a href='#' data-sysdocfrmcod='"+data[i].sysdocfrmcod+"' data-frmdatcod='"+lv_frmdat+"' data-frmtxt='"+data[i].sysdocfrmtxt.toLowerCase()+"' class='tmss-Opt'><i class='"+lv_icon+"'></i>"+data[i].sysdocfrmtxt.toLowerCase()+"</a></li>";

          // toast por cada formulario requerido
          if (<?=$lv_sec; ?>_isFrmRequired(data[i])) {
            var lv_key = String(data[i].sysdocfrmcod || data[i].sysdocfrmtxt);
            if (!window["<?=$lv_sec; ?>_frmreq_toasts"][lv_key]) {
              toastr.info("El formulario " + data[i].sysdocfrmtxt + " es requerido.");
              window["<?=$lv_sec; ?>_frmreq_toasts"][lv_key] = true;
            }
          }
				}

				lv_buffer += "</form></div>";
				$("#<?= $lv_sec; ?> span[name=grldatfrmbtn_span]").html( lv_buffer );
				
				var lv_count = data.filter(function(e){ return (e.frmdatcod!="" && e.frmdatcod!=undefined) }).length;
				if( lv_count > 0 && lv_count == data.length ){
					$("#<?= $lv_sec; ?> span[name=grldatfrmbtn_span] > div > a").addClass("btn-success");
				}
        
				// VER FORMULARIO. cargo formulario (onClick)
				$("#<?= $lv_sec; ?> form[name=grldatfrmbtn_form] a").on("click",function(e){ e.preventDefault();
					var lv_frmtxt = $(this).data("frmtxt");
					var lv_pstdat2=[{name:"frmdatcod", value:$(this).data("frmdatcod")},
													{name:"srcobjtyp", value:"<?= $lv_mdlcod.'_'.$lv_prgcod; ?>"},
													{name:"srcobjcod001", value:"<?= $lv_dockey; ?>"},
													<?= (isset($lv_dockey002)?'{name:"srcobjcod002",value:"'.$lv_dockey002.'"},':''); ?>
													{name:"sysdocclscod", value:$("#<?= $lv_sec; ?> #sysdocclscod").val()},
													{name:"sysdocfrmcod",value:$(this).data("sysdocfrmcod")},
													{name:"readonly", value:"<?= $vew_tbl_int['frmR']['readonly'] ?>"}];
					tmssCallProcess("?prg=grldatfrm&act=03", lv_pstdat2,  function(data2){ 
						BootstrapDialog.show({
							title: lv_frmtxt,
							type: BootstrapDialog.TYPE_PRIMARY,
							size: BootstrapDialog.SIZE_WIDE,
							draggable:true,
							closable:false,
							message: $(data2),
							buttons: [{ label: "<?= $vew_lang->cancel; ?>", id:"btncls", cssClass: "btn-danger", action: function(dialog){ dialog.close(); } },
												{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success <?= ($vew_tbl_int['frmR']['readonly']?'hidden':''); ?>", action:function(dialog){
														var lo_body = dialog.getModalBody();
														$(lo_body).find("#btnsve").data("btn_callback", function() {
                              <?=$lv_sec; ?>_updateFrmStatus(function() {
                                if($("#<?= $lv_sec; ?> #btnsve").data("no_cls") == undefined){
                                  dialog.close();
                                }
                              });
                            })
                            .trigger("click");
													}
												}]
						});
					});
				});
					
			}
    });
	});
  function <?=$lv_sec; ?>_updateFrmStatus(lp_callback){
  		// STATUS. actualizo status de formularios

				var lv_pstdat2=[{name:"srcobjtyp", value:"<?= $lv_mdlcod.'_'.$lv_prgcod; ?>"},
												{name:"srcobjcod001", value:"<?= $lv_dockey; ?>"}
												<?= (isset($lv_dockey002)?',{name:"srcobjcod002",value:"'.$lv_dockey002.'"}':''); ?>]
				tmssCallProcessNoBackdrop("?prg=grldatfrm&act=18", lv_pstdat2,  function(data2){ 
					for(var i=0; i<data2.length; i++){
						$("#<?= $lv_sec; ?> form[name=grldatfrmbtn_form] a[data-sysdocfrmcod="+data2[i]["sysdocfrmcod"]+"]").data("frmdatcod",data2[i]["frmdatcod"]);
						$("#<?= $lv_sec; ?> form[name=grldatfrmbtn_form] a[data-sysdocfrmcod="+data2[i]["sysdocfrmcod"]+"] i").prop("class","far fa-check");
					}
					if( $("#<?= $lv_sec; ?> form[name=grldatfrmbtn_form] a").length==data2.length ){
						$("#<?= $lv_sec; ?> span[name=grldatfrmbtn_span] > div > a").addClass("btn-success");
					}
          if(typeof lp_callback === "function") lp_callback();
				});
  }
  
</script>
<?php } ?>
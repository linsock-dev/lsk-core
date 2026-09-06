<?php if(isset($lv_mdlcod) && isset($lv_prgcod) && ($lv_dockey??'')!='' && is_object($vew_data->sysdoccls)===true && $vew_readonly){ ?>
<span name="grldatwrkbtn_span"></span>
<script>
	// revisa si hay workflows asignados para determinar si mostrar el boton
	var lv_pstdat= [{name:"srcobjtyp", value:"<?= $lv_mdlcod.'_'.$lv_prgcod; ?>"},
									{name:"srcobjcod001", value:"<?= $lv_dockey; ?>"},
									<?= (isset($lv_dockey002)?'{name:"srcobjcod002",value:"'.$lv_dockey002.'"},':''); ?>
									{name:"sysdocclscod", value:$("#<?= $lv_sec; ?> #sysdocclscod").val()}];
	tmssCallProcessNoBackdrop("?prg=grldatwrk&act=18", lv_pstdat,  function(data){
		if( data.length > 0 ){
			var lv_released_qty = 0;
			var lv_rejected_qty = 0;
			var lv_buffer = "";
			
			// preparo botones
			for(var i=0; i<data.length; i++){
				lv_buffer += "<li><a href='#' class='tmss-Opt' data-wrkflwcod='"+data[i].wrkflwcod+"' data-wrkflwtxt='"+data[i].wrkflwtxt.toLowerCase()+"' data-wrkflwdatcod='"+data[i].wrkflwdatcod+"'><i class='"+(data[i].relsts=="A"?"far fa-check":(data[i].relsts=="R"?"far fa-times":"far fa-square"))+"'></i>"+data[i].wrkflwtxt.toLowerCase()+"</a></li>";
				if( data[i].relsts=="A" ){ lv_released_qty++; }
				if( data[i].relsts=="R" ){ lv_rejected_qty++; }
			}			
			var lv_button_class = (lv_released_qty==data.length?"btn-success":(lv_rejected_qty==data.length?"btn-danger":(lv_released_qty+lv_rejected_qty>0?"btn-warning":"")));

			// WORKFLOWS. preparo boton y desplegable con los workflows
			var lv_buffer2 = "<div class='btn-group dropdown'>"
										+ "<a href='#' class='btn navbar-btn tmss-navbar-btn dropdown-toggle "+lv_button_class+"' data-toggle='dropdown'><i class='far fa-flag'></i><span class='badge'>"+data.length+"</span></a>"
										+ "<form class='dropdown-menu dropdown-menu-right tmssBrandMnuUsr' aria-labelledby='dLabel' name='grldatwrkbtn_form'>"
										+ lv_buffer
										+ "</form></div>";
			$("#<?= $lv_sec; ?> span[name=grldatwrkbtn_span]").html( lv_buffer2 );
			
			// VER. cargo workflow (onClick)
			$("#<?= $lv_sec; ?> form[name=grldatwrkbtn_form] a").on("click",function(e){ e.preventDefault();
				var lv_wrkflwtxt = $(this).data("wrkflwtxt").toUpperCase();
				var lv_pstdat2=[{name:"wrkflwdatcod", value:$(this).data("wrkflwdatcod")},
												{name:"wrkflwcod", value:$(this).data("wrkflwcod")},
												{name:"srcobjtyp", value:"<?= $lv_mdlcod.'_'.$lv_prgcod; ?>"},
												{name:"srcobjcod001", value:"<?= $lv_dockey; ?>"},
												{name:"srcobjcod002", value:"<?= ($lv_dockey002??''); ?>"}];
				tmssCallProcess("?prg=grldatwrk&act=03", lv_pstdat2,  function(data2){ 
					BootstrapDialog.show({
						title: lv_wrkflwtxt,
						type: BootstrapDialog.TYPE_PRIMARY,
						size: BootstrapDialog.SIZE_WIDE,
						draggable:true,
						closable:true,
						message: $(data2),
             onhidden: function(dialogItself){
       					 // Llamada a la función después de que se haya cerrado
      					  <?=$lv_sec?>_updateWrkStatus();
    					}
					});
				});
			});

		}
	});
   function <?=$lv_sec; ?>_updateWrkStatus(){
  		// STATUS. actualizo status de formularios
				var lv_pstdat2=[{name:"srcobjtyp", value:"<?= $lv_mdlcod.'_'.$lv_prgcod; ?>"},
												{name:"srcobjcod001", value:"<?= $lv_dockey; ?>"}
												<?= (isset($lv_dockey002)?',{name:"srcobjcod002",value:"'.$lv_dockey002.'"}':''); ?>]
				tmssCallProcessNoBackdrop("?prg=grldatwrk&act=18", lv_pstdat2,  function(data2){ 
          var lv_countA = 0;
          var lv_countR = 0;
					for(var i=0; i<data2.length; i++){
            if(data2[i]["relsts"] == "A"){
              	$("#<?= $lv_sec; ?> form[name=grldatwrkbtn_form] a[data-wrkflwcod="+data2[i]["wrkflwcod"]+"]").data("wrkflwdatcod",data2[i]["wrkflwdatcod"]);
								$("#<?= $lv_sec; ?> form[name=grldatwrkbtn_form] a[data-wrkflwcod="+data2[i]["wrkflwcod"]+"] i").prop("class","far fa-check");
           			lv_countA++;
            }
          	if(data2[i]["relsts"] == "R"){
              	$("#<?= $lv_sec; ?> form[name=grldatwrkbtn_form] a[data-wrkflwcod="+data2[i]["wrkflwcod"]+"]").data("wrkflwdatcod",data2[i]["wrkflwdatcod"]);
								$("#<?= $lv_sec; ?> form[name=grldatwrkbtn_form] a[data-wrkflwcod="+data2[i]["wrkflwcod"]+"] i").prop("class","far fa-times");
            		lv_countR++;
            }
						
					}
					if(lv_countA==data2.length ){
						$("#<?= $lv_sec; ?> span[name=grldatwrkbtn_span] > div > a").addClass("btn-success");
					}else 					if(lv_countR==data2.length ){
            $("#<?= $lv_sec; ?> span[name=grldatwrkbtn_span] > div > a").addClass("btn-danger");
          }
				});
  }
</script>
<?php } ?>
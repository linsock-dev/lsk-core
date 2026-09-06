<li id="<?= $lv_sec; ?>_hlpdiv_sep" class="hidden divider"></li>
<li id="<?= $lv_sec; ?>_hlpdiv_opt" class="hidden"><a href="#" class="tmsLink" id="hlpbtn"><i style="width:20px" class="fas fa-question"></i><?= $vew_lang->help ?></a></li>
<script>
	$(function(){
		tmssCallProcessNoBackdrop("?prg=sysappprg&act=help",[{name:"mdlcod",value:"<?= $lv_mdlcod; ?>"},{name:"prgcod",value:"<?= $lv_prgcod; ?>"},{name:"optype",value:"check"}],function(data){
			if(data==true){
				$("#<?= $lv_sec; ?>_hlpdiv_opt").removeClass("hidden");
				$("#<?= $lv_sec; ?>_hlpdiv_sep").removeClass("hidden");
			}
		});

		$("#<?= $lv_sec; ?> #hlpbtn").on("click",function(e){ e.preventDefault();
			tmssCallProcessNoBackdrop("?prg=sysappprg&act=help",[{name:"mdlcod",value:"<?= $lv_mdlcod; ?>"},{name:"prgcod",value:"<?= $lv_prgcod; ?>"},{name:"optype",value:"get"}],function(data){
				BootstrapDialog.show({				
					title:"Ayuda",
					message: $(data),
					type: BootstrapDialog.TYPE_INFO,
					size: BootstrapDialog.SIZE_WIDE,
					buttons: [{ label: "Cerrar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } }]
				});
			});
		});
	});
</script>
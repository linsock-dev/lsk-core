<?php if(isset($lv_mdlcod) && isset($lv_prgcod) && ($lv_dockey??'')!='' && is_object($vew_data->sysdoccls) === true ){ ?>
	<li><a href="#" id="btnmsg" class="tmssLink hidden"><i style="width:20px" class="far fa-share-nodes"></i><?= $vew_lang->share; ?></a></li>
	<script>
    // busco si para la clase de documento hay mensajes disponibles
		var lv_pstdat =[{name:"sysdocclscod",value:"<?= $vew_data->sysdoccls->sysdocclscod; ?>"}];
	    tmssCallProcessNoBackdrop("?prg=sysdocclsmsg&act=18",lv_pstdat,function(data){
				if(data.length==0){ return false; }
      $("#<?= $lv_sec; ?> #btnmsg").removeClass("hidden");
      
      // dialogo de mensajes
      $("#<?= $lv_sec; ?> #btnmsg").on("click",function(e){ e.preventDefault();
        var lv_pstdat =[{name:"srcobjtyp",value:"<?= $lv_mdlcod.'_'.$lv_prgcod; ?>"},
                        {name:"srcobjcod",value:"<?= $lv_dockey; ?>"},
                        {name:"srcobjcod002",value:"<?= ($lv_dockey002??''); ?>"},
                       	{name:"sysdocclscod",value:"<?= $vew_data->sysdoccls->sysdocclscod; ?>"},
                    		{name:"lv_sec",value:"<?= $lv_sec; ?>"}];
        tmssCallProcess("?prg=grldatmsg&act=06",lv_pstdat,function( data ) {
          BootstrapDialog.show({
            title: "<?= $vew_lang->share; ?>",
            message: $( data ),
            closable: true,
            draggable: true, 
            type: BootstrapDialog.TYPE_PRIMARY
            //size: BootstrapDialog.SIZE_WIDE
          });
        });
      });
		
		});
	</script>
<?php } ?>

<?php 
	if(!is_object($vew_data??null)){return;}
	// verifico si esta definido el objeto sysdoccls o doccls
	$lv_sysdoc = $vew_data->sysdoccls ? $vew_data->sysdoccls : ($vew_data->doccls ? $vew_data->doccls : false);  

  if(isset($lv_mdlcod) && isset($lv_prgcod) && ( (isset($lv_dockey)?$lv_dockey:'')!='' ) && $lv_sysdoc != false ) { ?>
    <li><a href="#" id="grldocflwstsbtn" class="tmssLink tmssHiddeOnEdit"><i style="width:20px" class="far fa-list-tree"></i>Flujo Doc.</a></li>
    <script>
      $("#<?= $lv_sec; ?> #grldocflwstsbtn").on("click",function(e){ e.preventDefault(); 
        var lv_pstdat = [{name:"srcobjtyp",value:"<?= $lv_mdlcod.'_'.$lv_prgcod; ?>"}, {name:"srcobjcod", value:"<?= $lv_dockey; ?>"}];
        tmssLink("?prg=grldocflw&act=statuslst", [{target: "_new_section",post_data: lv_pstdat}] );
      });
    </script>
  <?php } ?>
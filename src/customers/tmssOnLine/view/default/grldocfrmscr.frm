<?php
	$vew_actcod = ($vew_actcod??'');
	$lv_dockey = ($lv_dockey??'');
	$lv_buscodcus = $vew_sec->buscodcus != NULL ? $vew_sec->buscodcus:'';
  if(isset($lv_lnk) && isset($lv_mdlcod) && isset($lv_prgcod) && $lv_mdlcod!='SYS' && $lv_mdlcod!='PRG' )$lv_lnk.='&prm_mdlcod='.$lv_mdlcod.'&prm_prgcod='.$lv_prgcod;
	
?>
<script>
	//INFO adicional
	$("#<?= $lv_sec; ?> #btnshowinfo").on("click",function(e){e.preventDefault
		var lv_dat=[{"infttl":"<?= $vew_lang->createdby;?>","infdat":"<?= ($vew_data->cteusr??''); ?>"},
								{"infttl":"<?= $vew_lang->createddate; ?>","infdat":"<?= (($vew_data->ctedte??'')!=''?date_format($vew_data->ctedte,'d-m-Y h:i:s'):''); ?>"},
								{"infttl":"<?= $vew_lang->updatedby; ?>","infdat":"<?= ($vew_data->updusr??''); ?>"},
								{"infttl":"<?= $vew_lang->updateddate; ?>","infdat":"<?= (($vew_data->upddte??'')!=''?date_format($vew_data->upddte,'d-m-Y h:i:s'):''); ?>"}];
		// datos adicionales provistos por el usuario ( array llamado <sec>_infusrdat )
		if( typeof lv_<?= $lv_sec; ?>_infusrdat != "undefined" ){
			for(var i=0; i< lv_<?= $lv_sec; ?>_infusrdat.length; i++){
				lv_dat.push( lv_<?= $lv_sec; ?>_infusrdat[i] );
			}
		}
		var lv_pstdat=[{name:"infdat",value:JSON.stringify(lv_dat)}];
		tmssPopup("Info","?prg=grlvew&act=showinfo",function(){},lv_pstdat);
	});
</script>
<script>
  if( $("#<?= $lv_sec; ?>_frm").find("#lv_sec").length==0){ 
    $("#<?= $lv_sec; ?>_frm").append("<input type='hidden' id='lv_sec' name='lv_sec' value='<?= $lv_sec; ?>'>"); 
  }
</script>
<script>
	var gv_<?= $lv_sec; ?>_last_action="";

	// server response
	tmssLinkForm( $("#<?= $lv_sec; ?>_frm"), "<?= $lv_lnk; ?>", function (data) {
		if(typeof <?= $lv_sec; ?>_fncbckext==="function"){
			if( <?= $lv_sec; ?>_fncbckext( data )==false ){
				return;
			}
		}else if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
			if (gv_<?= $lv_sec; ?>_last_action=="04") {
				tmssTabSecCls( $("#<?= $lv_sec; ?>") );
			} else {
				$("#<?= $lv_sec; ?>").replaceWith( data );
			}
		}
	});
  
	// form submit
	function <?= $lv_sec; ?>_fnc( lp_prm ) { 
		if(typeof <?= $lv_sec; ?>_fncext==="function"){
			if( <?= $lv_sec; ?>_fncext( lp_prm )==false ){
				return;
			}
		}
		
		gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
		var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='01'?'01':($vew_actcod=='02'?'02':'03')); ?>":gv_<?= $lv_sec; ?>_last_action);
		tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= ($lv_title??''); ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
	}
  
	// edit mode
	if(typeof <?= $lv_sec; ?>_formeditext==="function"){
		<?= $lv_sec; ?>_formeditext();
	}else {
		tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	}  
</script>
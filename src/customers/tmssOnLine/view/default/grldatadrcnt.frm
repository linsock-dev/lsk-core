<div class="card">
  <div class="card-header">
    <div class="card-title"><?= $vew_lang->contact; ?><span class="tmss-card-icon"><i class="fas fa-phone"></i></span></div>
	</div>
  <?php if($vew_readonly) { ?>
  	<div class="card-body tmss-card-body-edit">
    	<!--Modo lectura-->
			<input type="hidden" id="adrphn001" name="adrphn001" value="<?= $vew_data->adr->adrphn001; ?>">
			<input type="hidden" id="adrphn002" name="adrphn002" value="<?= $vew_data->adr->adrphn002; ?>">
			<input type="hidden" id="adrmblphn" name="adrmblphn" value="<?= $vew_data->adr->adrmblphn; ?>">
			<input type="hidden" id="adreml" 		name="adreml" 	 value="<?= $vew_data->adr->adreml; ?>">
			<input type="hidden" id="adrwebpge" name="adrwebpge" value="<?= $vew_data->adr->adrwebpge; ?>">
			<?php
        $lv_cnt = '';
				if($vew_data->adr->adrphn001!='' || $vew_data->adr->adrphn002!=''){ $lv_cnt .= '<label>'.$vew_lang->phone.'</label><div>'.($vew_data->adr->adrphn001!=''?'<a href="#" onclick="window.location.href='.chr(39).'callto:'.$vew_data->adr->adrphn001 .chr(39).'">'.$vew_data->adr->adrphn001.'</a>':'').($vew_data->adr->adrphn002!=''?($vew_data->adr->adrphn001!=''?' / ':'').'<a href="#" onclick="window.location.href='.chr(39).'callto:'.$vew_data->adr->adrphn002 .chr(39).'">'.$vew_data->adr->adrphn002.'</a>':'').'</div>'; }
				if($vew_data->adr->adrmblphn!=''){ $lv_cnt .= '<label>'.$vew_lang->mobilephone.'</label><div><a href="#" onclick="window.location.href='.chr(39).'callto:'.$vew_data->adr->adrmblphn .chr(39).'">'.$vew_data->adr->adrmblphn.'</a></div>'; }
				if($vew_data->adr->adreml!=''){ 
					$lv_cnt .= ($lv_cnt!=''?'':'').'<label>'.$vew_lang->email.'</label>';         
					
          if(isset($vew_sysseclnk)) { 
						$lv_cnt .= '<a href="#" onclick="'.$lv_sec.'_sysseclnk_show();" class="card-icon" title="'.$vew_lang->user.'"><i class="fas fa-user"></i></a>';
						include('grldatadrcntusr.frm');
					} 
					$lv_cnt .= '<div><a href="#" onclick="window.location.href='.chr(39).'mailto:'.$vew_data->adr->adreml .chr(39).'">'.$vew_data->adr->adreml.'</a></div>'; 
				}
				if($vew_data->adr->adrwebpge!=''){ $lv_cnt .= '<label>'.$vew_lang->WebPage.'</label><div><a href="#" onclick="window.open('.chr(39). $vew_data->adr->adrwebpge .chr(39).');" target="_blank">'.$vew_data->adr->adrwebpge.'</a></div>'; }
				echo ($lv_cnt==''?'(Sin informaci&oacute;n)':'<strong>'.utf8_encode($lv_cnt).'</strong>');
			?>
    </div>
	<?php } else { ?>
  	<div class="card-body tmss-card-body-edit">
    	<!-- Modo edición -->
			<?php
				echo vew_boot($lv_col210, array('label'=>$vew_lang->phone, 			'input'=>gethtml('adrphn001', 'adrphn', $vew_data->adr->adrphn001, $lv_default))); 
				echo vew_boot($lv_col210, array('label'=>$vew_lang->phone, 			'input'=>gethtml('adrphn002', 'adrphn', $vew_data->adr->adrphn002, $lv_default))); 
				echo vew_boot($lv_col210, array('label'=>$vew_lang->mobilephone,'input'=>gethtml('adrmblphn', 'adrphn', $vew_data->adr->adrmblphn, $lv_default))); 
				echo gethtml('adrfax','hidden',$vew_data->adr->adrfax);
				echo vew_boot($lv_col210, array('label'=>$vew_lang->email, 			'input'=>gethtml('adreml','adreml', $vew_data->adr->adreml, $lv_default)));
				echo vew_boot($lv_col210, array('label'=>$vew_lang->webpage, 		'input'=>gethtml('adrwebpge', 'adrweb', $vew_data->adr->adrwebpge, $lv_default))); 
			?>
    </div>
		<script>
			$("#<?= $lv_sec; ?> #adrwebpge").on("blur",function(e){
				var lv_url = $(this).prop("value"); 
				if ( lv_url!="" ) {
					lv_url=lv_url.toLowerCase(); 
					if(lv_url.substring(0,7)!="http://" && lv_url.substring(0,8)!="https://" && lv_url.substring(0,7)!="http:\\" && lv_url.substring(0,8)!="https:\\") {
						lv_url = "https://" + lv_url;
					}
					$(this).prop("value",lv_url);
				}
			});
		</script>
  <?php } ?>
</div>
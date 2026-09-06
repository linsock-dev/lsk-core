<?php
	/*
		IMPORTANTE:
			- se requiere el campo ADRNUM
				este campo se encuentra en la vista GrlDatAdr.frm
				si no se incluye la vista, debera incluirse el campo de manera independiente				
	*/
?>
<div class="container-fluid">
	<div class="row">
		<?php
			echo vew_boot($lv_col210, array("label"=>$vew_lang->phone,			
																			"input"=>vew_boot(array("style"=>($vew_data->adr->adrphn001==""?"nothing":"phone"),"readonly"=>$vew_readonly),
																												array("id"=>"#".$lv_sec." #adrphn001","input"=>gethtml("adrphn001", "adrphn", $vew_data->adr->adrphn001, $lv_default) )) )); 
			echo vew_boot($lv_col210, array("label"=>$vew_lang->phone, 			
																			"input"=>vew_boot(array("style"=>($vew_data->adr->adrphn002==""?"nothing":"phone"),"readonly"=>$vew_readonly),
																												array("id"=>"#".$lv_sec." #adrphn002","input"=>gethtml("adrphn002", "adrphn", $vew_data->adr->adrphn002, $lv_default) )) )); 
			echo vew_boot($lv_col210, array("label"=>$vew_lang->mobilephone,
																			"input"=>vew_boot(array("style"=>($vew_data->adr->adrmblphn==""?"nothing":"phone"),"readonly"=>$vew_readonly),	
																												array("id"=>"#".$lv_sec." #adrmblphn","input"=>gethtml("adrmblphn", "adrphn", $vew_data->adr->adrmblphn, $lv_default) )) )); 
			echo vew_boot($lv_col210, array("label"=>$vew_lang->email,
																			"input"=>vew_boot(array("style"=>($vew_data->adr->adreml==""?"nothing":"email"),"readonly"=>$vew_readonly),
																												array("id"=>"#".$lv_sec." #adreml","input"=>gethtml("adreml","adreml", $vew_data->adr->adreml, $lv_default) )) ));
		?>
	</div>
</div>
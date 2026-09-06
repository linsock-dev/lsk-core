<?php
	// url del formulario 
  $lv_lnk = '?prg=sysappprg';

	// clave del documento 
	$lv_dockey = $vew_data->prgcod; 

	// titulo 
	$lv_title = $vew_lang->program;
	
	// m?dulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'PRG';

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
    <input type="hidden" id="mdlcod" name="mdlcod" value="<?php echo $vew_data->mdlcod; ?>">
    <input type="hidden" id="prgcod" name="prgcod" value="<?php echo $vew_data->prgcod; ?>">
		<div class="container-fluid" style="height:300px;display:block;overflow-y:scroll;">
			<input type="hidden" name="lngcod" id="lngcod" value="ES">
			<?php
				echo html_entity_decode($vew_data->txt);
			?>
    </div> <!-- container-fluid -->
    
</section>
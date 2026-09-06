<?php
	// url del formulario 
	$lv_lnk = '';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	// $lv_dockey = $vew_data->crtby; 

	// titulo 
	$lv_title = $vew_lang->info;
	
	// modulo y programa 
	$lv_mdlcod = 'GRL';
	$lv_prgcod = 'VEW';

	// libreria de estilos bootstrap 
	include_once('_library.frm');

	$lv_hidden = array( 'atrval'=>array('class'=>'hidden') );
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<form class="form-horizontal tmss-form-horizontal container-fluid">
		<div >	
			<?php 
				foreach($vew_data->infdat as $lv_row){
					echo vew_boot($lv_col48, array('label'=>$lv_row['infttl'],'input'=>gethtml('', 'doccmt1x50',$lv_row['infdat'], $lv_always_disabled) ));
				}
			?>
		</div>
	</form>
</section>
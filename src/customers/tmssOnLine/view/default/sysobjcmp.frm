<?php
	// url del formulario
  $lv_lnk = '';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = '';

	// modulo y programa
	$lv_mdlcod = '';
	$lv_prgcod = '';

	// libreria de estilos bootstrap
	include_once('_library.frm');

	$lv_verlst = array();
	$lv_verlst['DEV'] = 'Desarollo';
	foreach( $vew_data->objver as $lv_row ){ $lv_verlst[$lv_row['sysobjver']] = $lv_row['sysobjver']; }
	$lv_verlst['PRD'] = 'Productivo';
?>
<div class="row">
  <div class="col-sm-6">
    <div class="card">
      <div class="card-header">
        <div class="card-title"><?= $vew_lang->source; ?>
          <div class="card-icon"><?= gethtml('dstobjver',$lv_verlst,'DEV'); ?></div>
        </div>
      </div>
      <div class="card-body tmss-card-body-edit">
        <div></div>
      </div>
    </div>
  </div>
  <div class="col-sm-6">
    <div class="card">
      <div class="card-header">
        <div class="card-title"><?= $vew_lang->destination; ?>
        	<div class="card-icon"><?= gethtml('dstobjver',$lv_verlst,'PRD'); ?></div>
        </div>
    	</div>
      <div class="card-body tmss-card-body-edit">
        <div></div>
      </div>
    </div>
  </div>
</div>
<?php
	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* m�dulo y programa */
	$lv_mdlcod = 'CRM';
	$lv_prgcod = 'CNT';

	/* librer�a de estilos bootstrap */
	include_once('_library.frm');
	
	// valores x default
	$vew_data->crmcntcmtdte = date('d/m/Y');
?>
<section id="<?= $lv_sec; ?>">
	<div class="form-horizontal">
		<div class="container-fluid">
      <div class="row">
				<?php
					echo vew_boot($lv_colsm210, array('label'=>$vew_lang->date, 'input'=>gethtml('crmcntcmtdte', 'docdte', $vew_data->crmcntcmtdte, $lv_default) ));
					echo vew_boot($lv_colsm210, array('label'=>$vew_lang->responsible,'input'=>gethtml('usrcod', 'doccmt1x50', $vew_sec->usrcod, $lv_default) ));
        	echo vew_boot($lv_col210, array('label'=>$vew_lang->hours, 'input'=>gethtml('crmcnthrs', 'docnum0601', $vew_data->crmcnthrs, $lv_default) ));
				?>
			</div>
		</div>
	</div>
</section>
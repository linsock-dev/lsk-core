<?php
	/* url del formulario */
  $lv_lnk = '?prg=grladrlndreg&prm_lndregcod='.$vew_data->lndcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('lndregtxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->lndregcod; 

	/* titulo */
	$lv_title = $vew_lang->region;
	
	/* módulo y programa */
	$lv_mdlcod = 'GRL';
	$lv_prgcod = 'lndregcod';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>  
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<?php 
						echo vew_boot($lv_col210, array('label'=>$vew_lang->code   ,'input'=>gethtml('lndregcod', 'lndregcod', $vew_data->lndregcod, $lv_always_disabled) ));
						echo vew_boot($lv_col210, array('label'=>$vew_lang->london ,'input'=>gethtml('lndcod'   , 'lndcod', $vew_data->lndcod, $lv_default) ));
						echo vew_boot($lv_col210, array('label'=>$vew_lang->name   ,'input'=>gethtml('lndregtxt', 'lndregtxt', $vew_data->lndregtxt, $lv_default) ));
						echo vew_boot($lv_col210, array('label'=>$vew_lang->status ,'input'=>gethtml('docsts'   , 'docsts', $vew_data->docsts, $lv_default) ));
					?>
				</div> <!-- fin _tab001 -->
				
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<?php include('grldocfrmscr.frm'); ?>
</section>
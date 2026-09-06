<?php
	// url del formulario 
  $lv_lnk = "?prg=hltpat&prm_patcod=".$vew_data->patcod;

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = $vew_data->patcod; 

	// titulo 
	$lv_title = $vew_lang->patient;
	
	// m?dulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PAT';

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
    
		<div class="row">
			<div class="col-md-6">
				<?php 
					echo vew_boot($lv_col210, array("label"=>$vew_lang->id,   "input"=>gethtml("patcod",   "doccod", 	$vew_data->patcod,$lv_always_disabled) )); 
					echo vew_boot($lv_col210, array("label"=>$vew_lang->code,	"input"=>gethtml("patcodext","doccod", 	$vew_data->patcodext,$lv_always_disabled) )); 
					echo vew_boot($lv_col210, array("label"=>$vew_lang->name,	"input"=>gethtml("pattxt","pattxt",$vew_data->pattxt,$lv_always_disabled) )); 
				?>
				<?php 
					echo vew_boot($lv_col210, array("label"=>$vew_lang->diseaseclassification, "input"=>gethtml("hltdisclstxt", "hltdisclstxt", $vew_data->hltdisclstxt, $lv_always_disabled) ));
					echo vew_boot($lv_col210, array("label"=>$vew_lang->diagnosticcode, "input"=>gethtml("patdiatxt", "patdiatxt", $vew_data->patdiatxt, $lv_always_disabled) ));
					echo vew_boot($lv_col210, array("label"=>$vew_lang->cronicity, "input"=>gethtml("patcrotxt", "doccmt1x50",$vew_data->patcrotxt, $lv_always_disabled) ));
				?>
				<?php
					echo vew_boot($lv_col210, array("label"=>$vew_lang->medicalcoverage, "input"=>gethtml("cushsptxt","custxt", $vew_data->custxthsp, $lv_always_disabled) ));
					echo vew_boot($lv_col210, array("label"=>$vew_lang->affiliated,	"input"=>gethtml("pataflnum",	"pataflnum",	$vew_data->pataflnum,	$lv_always_disabled) )); 
					echo vew_boot($lv_col210, array("label"=>$vew_lang->plan, "input"=>gethtml("pataflpln",	"pataflpln",	$vew_data->pataflpln,	$lv_always_disabled) ));  
				?>
			</div>
			<div class="col-md-6">
				<?php include('grldatadrsml.frm'); ?>
				<?php include('grldatadrcntsml.frm'); ?>
			</div>
		</div>
  </form>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $('#<?= $lv_sec; ?>_frm'), '<?= $lv_lnk; ?>', function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, '<?= $lv_title; ?>', '<b><?= $lv_dockey; ?></b>' ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=='04') {
					tmssTabSecCls( $('#<?= $lv_sec; ?>') );
				} else {
					$('#<?= $lv_sec; ?>').replaceWith( data );
				}
			}
    });
		
		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			gv_<?= $lv_sec; ?>_last_action = lp_prm['action'];
			var lv_action = (gv_<?= $lv_sec; ?>_last_action=='99'?'<?= ($vew_actcod=='02'?'02':'03'); ?>':gv_<?= $lv_sec; ?>_last_action);
			tmssMessageProcessing( '<?= $lv_sec; ?>', lv_action, '<?= $lv_title; ?>', '<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>' );
		}
		
		// edit mode
    tmssFormEdit('<?= $lv_sec; ?>',<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	</script>
</section>
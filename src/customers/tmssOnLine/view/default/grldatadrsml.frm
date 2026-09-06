<div class="container-fluid">
	<div class="row">
		<?= gethtml('adrnum','hidden',$vew_data->adr->adrnum); ?>
		<?php 
			if ( $vew_data->adr->adrmapgeo=='' ) {
				echo vew_boot($lv_col210, array('label'=>$vew_lang->address, 		'input'=>gethtml('adrstr', 'adrstr', $vew_data->adr->adrstr, $lv_default) ));
			} else {
				echo vew_boot($lv_col210, array('label'=>$vew_lang->address, 
																				'input'=>vew_boot(array('style'=>'map', 'readonly'=>$vew_readonly, 'adrmapgeo'=>$vew_data->adr->adrmapgeo ), 
																													array('id'=>'adrstr', 'input'=>gethtml('adrstr', 'adrstr', $vew_data->adr->adrstr, $lv_default) )) )); 
			}
			?>
		<div class="form-group  tmss-form-group">
			<label class="col-xs-2 control-label text-nowrap">&nbsp;</label>
			<div class="col-xs-3 col-sm-3" style="padding-right: 2px;"><input type="TEXT" id="adrstrnum" name="adrstrnum" value="<?= $vew_data->adr->adrstrnum; ?>" maxlength="6" class="form-control" readonly="readonly" placeholder="<?= $vew_lang->number; ?>"></div>
			<div class="col-xs-2 col-sm-2" style="padding-left: 2px; padding-right: 2px;"><input type="TEXT" id="adrstrflr" name="adrstrflr" value="<?= $vew_data->adr->adrstrflr; ?>" maxlength="6" class="form-control" readonly="readonly" placeholder="<?= $vew_lang->floor; ?>"></div>
			<div class="col-xs-2 col-sm-2" style="padding-left: 2px; padding-right: 2px;"><input type="TEXT" id="adrstrunt" name="adrstrunt" value="<?= $vew_data->adr->adrstrunt; ?>" maxlength="6" class="form-control" readonly="readonly" placeholder="<?= $vew_lang->unit; ?>"></div>
			<div class="col-xs-3 col-sm-3" style="padding-left: 2px;"><input type="TEXT" id="adrstrbld" name="adrstrbld" value="<?= $vew_data->adr->adrstrbld; ?>" maxlength="6" class="form-control" readonly="readonly" placeholder="<?= $vew_lang->building; ?>"></div>
		</div>
		<?php
			echo vew_boot($lv_col210, array('label'=>$vew_lang->city, 'input'=>gethtml('adrcty', 'adrcty', $vew_data->adr->adrcty, $lv_default) )); 
			echo vew_boot($lv_col210, array('label'=>$vew_lang->town, 'input'=>gethtml('adrtwntxt',	'adrtwn', $vew_data->adr->adrtwn,	$lv_default) )); 
			echo vew_boot($lv_col210, array('label'=>$vew_lang->country, 'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('lndtxt', 'typeahead', $vew_data->adr->lndtxt, $lv_default) )) ));
			echo gethtml('lndcod','hidden',$vew_data->adr->lndcod);
			echo vew_boot($lv_col210, array('label'=>$vew_lang->region, 'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('lndregtxt', 'typeahead', $vew_data->adr->lndregtxt, $lv_default) )) ));
			echo gethtml('lndregcod','hidden',$vew_data->adr->lndregcod);
		?>
	</div>
</div>
<script>
	// lndtxt
	var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"lndcod" : "lndcod", "lndtxt" : "lndtxt"}}; 
	tmssTypeahead($("#<?= $lv_sec; ?> #lndtxt"), "grladrlnd", lo_get, {"afterAssign": function(){ $("#<?= $lv_sec; ?> #lndcod").change(); }});

	// lndregtxt
	var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"lndregcod" : "lndregcod", "lndregtxt" : "lndregtxt"}, "fldflt" : {"l.lndcod" : $("#<?= $lv_sec; ?> #lndcod")}}; 
	tmssTypeahead($("#<?= $lv_sec; ?> #lndregtxt"), "grladrlndreg", lo_get);
</script>
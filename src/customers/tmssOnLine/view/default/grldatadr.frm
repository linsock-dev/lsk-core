<div class="card">  
	<div class="card-header"><div class="card-title"><?= $vew_lang->address; ?></div></div>
    <div class="card-body tmss-card-body-edit">
			<?php	
				echo gethtml('lndregcod', 'hidden', $vew_data->adr->lndregcod);
				echo gethtml('lndtwncod','hidden', $vew_data->adr->lndtwncod);
				echo gethtml('adrzoncod', 'hidden', $vew_data->adr->adrzoncod);      
				echo gethtml('trazoncod', 'hidden', $vew_data->adr->trazoncod);
				
				// solo lectura
				if($vew_readonly){
					echo gethtml('lndregtxt', 'hidden', $vew_data->adr->lndregtxt);
          echo gethtml('lndcod', 'hidden', $vew_data->adr->lndcod);
					echo gethtml('lndtxt', 'hidden', $vew_data->adr->lndtxt);
					echo gethtml('trazontxt', 'hidden', $vew_data->adr->trazontxt);
					echo gethtml('adrzon', 'hidden', $vew_data->adr->adrzon);
					echo gethtml('adrtwn', 'hidden', $vew_data->adr->adrtwn);
					echo gethtml('lndtwntxt', 'hidden', $vew_data->adr->lndtwntxt);
					echo gethtml('adrpstcod', 'hidden', $vew_data->adr->adrpstcod);
					echo gethtml('adrcty', 'hidden', $vew_data->adr->adrcty);
					echo gethtml('adrstrbld', 'hidden', $vew_data->adr->adrstrbld);
					echo gethtml('adrstrunt', 'hidden', $vew_data->adr->adrstrunt);
					echo gethtml('adrstrflr', 'hidden', $vew_data->adr->adrstrflr);
					echo gethtml('adrstrnum', 'hidden', $vew_data->adr->adrstrnum);
					echo gethtml('adrstr', 'hidden', $vew_data->adr->adrstr);
					echo gethtml('adrnum', 'hidden', $vew_data->adr->adrnum);
					$lv_adr = '';
					$lv_adr001 = $vew_data->adr->adrstr;
					$lv_adr001 .= ($vew_data->adr->adrstrnum!=''?' '.$vew_data->adr->adrstrnum:'');
					$lv_adr001 .= ($vew_data->adr->adrstrflr!=''?' - Pso.'.$vew_data->adr->adrstrflr:'');
					$lv_adr001 .= ($vew_data->adr->adrstrunt!=''?' - Dto.'.$vew_data->adr->adrstrunt:'');
					$lv_adr001 .= ($vew_data->adr->adrstrbld!=''?' - Edf.'.$vew_data->adr->adrstrbld:'');
					if($vew_data->adr->adrmapgeo!=''){
						$lv_adr001 .= '<a href="#" onclick="window.open('.chr(39).'http://www.google.com/maps/search/?api=1&query='.$vew_data->adr->adrmapgeo .chr(39).');" class="card-icon" title="'.$vew_lang->map.'"><i class="fas fa-map-marker-alt"></i></a>';
					}
					$lv_adrzon = $vew_data->adr->adrzon != '' ? $vew_data->adr->adrzon : ( $vew_data->adr->adrzontxt != '' ? $vew_data->adr->adrzontxt : '' );				
					$lv_twntxt = ($vew_data->adr->lndtwntxt!=''?$vew_data->adr->lndtwntxt:$vew_data->adr->adrtwn);				
					if($vew_data->adr->adrpstcod!='' || $lv_twntxt!=''){ $lv_adr001 .= ($lv_adr001==''?'':'<br>').$vew_data->adr->adrpstcod.($vew_data->adr->adrpstcod!='' && $lv_twntxt!=''?' - ':'').$lv_twntxt; }
					if($vew_data->adr->adrcty!='' || $lv_adrzon!=''){ $lv_adr001 .= ($lv_adr001==''?'':'<br>').$vew_data->adr->adrcty.($vew_data->adr->adrcty!='' && $lv_adrzon!=''?' - ':'').$lv_adrzon; }
					if($vew_data->adr->lndregcod!='' || $vew_data->adr->lndtxt!=''){ $lv_adr001 .= ($lv_adr001==''?'':'<br>').$vew_data->adr->lndregtxt.($vew_data->adr->lndregtxt!='' && $vew_data->adr->lndtxt!=''?' - ':'').$vew_data->adr->lndtxt; }
					if($lv_adr001!=''){ $lv_adr = '<div>'.$lv_adr001.'</div>'; }

					if($vew_data->adr->trazontxt!=''){ $lv_adr .= ($lv_adr!=''?'':'').'<label>'.$vew_lang->transportzone.'</label><div>'.$vew_data->adr->trazontxt.'</div>'; }				
					echo (($lv_adr == '')?'(Sin informaci&oacute;n)':'<strong>'.$lv_adr.'</strong>');
				
				// modo edicion
				} else {
					
					if ( $vew_data->adr->adrmapgeo=='' ) {
						echo vew_boot($lv_col210, array('label'=>$vew_lang->address, 		'input'=>gethtml('adrstr', 'adrstr', $vew_data->adr->adrstr, $lv_default) ));
					} else {
						echo vew_boot($lv_col210, array('label'=>$vew_lang->address, 
																						'input'=>vew_boot(array('style'=>'map', 'readonly'=>$vew_readonly, 'adrmapgeo'=>$vew_data->adr->adrmapgeo ), 
																															array('id'=>'adrstr', 'input'=>gethtml('adrstr', 'adrstr', $vew_data->adr->adrstr, $lv_default) )) )); 
					}
					echo '<div class="form-group  tmss-form-group">';
					echo '<label class="col-xs-2 control-label text-nowrap">&nbsp;</label>';
					echo '<div class="col-xs-3 col-sm-3"><input type="TEXT" id="adrstrnum" name="adrstrnum" value="'.$vew_data->adr->adrstrnum.'" maxlength="6" class="form-control" placeholder="'.$vew_lang->number.'"></div>';
					echo '<div class="col-xs-2 col-sm-2"><input type="TEXT" id="adrstrflr" name="adrstrflr" value="'.$vew_data->adr->adrstrflr.'" maxlength="6" class="form-control" placeholder="'.$vew_lang->floor.'"></div>';
					echo '<div class="col-xs-2 col-sm-2"><input type="TEXT" id="adrstrunt" name="adrstrunt" value="'.$vew_data->adr->adrstrunt.'" maxlength="6" class="form-control" placeholder="'.$vew_lang->unit.'"></div>';
					echo '<div class="col-xs-3 col-sm-3"><input type="TEXT" id="adrstrbld" name="adrstrbld" value="'.$vew_data->adr->adrstrbld.'" maxlength="6" class="form-control" placeholder="'.$vew_lang->building.'"></div>';
					echo '</div>';
          echo gethtml('lndcod', 'hidden', $vew_data->adr->lndcod == '' ? $vew_sec->lndcod:$vew_data->adr->lndcod);	
					echo vew_boot($lv_col210, array('label'=>$vew_lang->country, 'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('lndtxt', 'typeahead', $vew_data->adr->lndtxt == '' ? $vew_sec->lndtxt:$vew_data->adr->lndtxt, $lv_default) )) ));
					echo vew_boot($lv_col210, array('label'=>$vew_lang->region, 'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('lndregtxt', 'typeahead', $vew_data->adr->lndregtxt, $lv_default) )) ));
					echo '<div id="div_adrtwn" class="">';
					echo vew_boot($lv_col210, array('label'=>$vew_lang->city, 'input'=>gethtml('adrtwn', 'adrtwn', $vew_data->adr->adrtwn,	$lv_default) )); 
					echo '</div><div id="div_lndtwntxt" class="hidden">';
					echo vew_boot($lv_col210, array('label'=>$vew_lang->city, 'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('lndtwntxt', 'typeahead', $vew_data->adr->lndtwntxt,	$lv_default) )) )); 
					echo '</div>';
					echo vew_boot($lv_col210, array('label'=>$vew_lang->postcode,	'input'=>gethtml('adrpstcod', 'adrpstcod',$vew_data->adr->adrpstcod, $lv_default) )); 
					echo vew_boot($lv_col210, array('label'=>$vew_lang->town, 		'input'=>gethtml('adrcty', 		'adrcty', 	$vew_data->adr->adrcty, 		$lv_default) )); 
					echo vew_boot($lv_col210, array('label'=>$vew_lang->zone, 		'input'=>gethtml('adrzon', 		'adrzon', 	$vew_data->adr->adrzon, 	$lv_default) ));
					echo vew_boot($lv_col210, array('label'=>$vew_lang->transport,'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('trazontxt', 'typeahead', $vew_data->adr->trazontxt, $lv_default) )) ));
					?>
					<script>
						// lndtxt
						var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"lndcod" : "lndcod", "lndtxt" : "lndtxt"}}; 
						tmssTypeahead($("#<?= $lv_sec; ?> #lndtxt"), "grladrlnd", lo_get, {"afterAssign": function(){ $("#<?= $lv_sec; ?> #lndcod").change(); }});
						// lndregtxt
						var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"lndregcod":"lndregcod", "lndregtxt":"lndregtxt"}, "fldflt" : {"l.lndcod" : $("#<?= $lv_sec; ?> #lndcod")}}; 
						tmssTypeahead($("#<?= $lv_sec; ?> #lndregtxt"), "grladrlndreg", lo_get);
						// lndtwntxt
						var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"lndtwncod" : "lndtwncod", "lndtwntxt" : "lndtwntxt"}, "fldflt" : {"lt.docsts":"A", "lt.lndcod":$("#<?= $lv_sec; ?> #lndcod"), "lt.lndregcod":$("#<?= $lv_sec; ?> #lndregcod") }}; 
						tmssTypeahead($("#<?= $lv_sec; ?> #lndtwntxt"), "grldatlndtwn", lo_get);
						// trazontxt
						var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"trazoncod" : "trazoncod", "trazontxt" : "trazontxt"}}; 
						 tmssTypeahead($("#<?= $lv_sec; ?> #trazontxt"), "logtrazon", lo_get);
					
						// verifica activacion de gestion de ciudades
						tmssCallProcessNoBackdrop("?prg=sysappmdlprm&act=getParameter",[{name:"mdlcod",value:"GRL"},{name:"prmcod",value:"ENABLE_CITIES"}],function(data){
							var lv_enable = false;
							if(data.data.length>0){ if(data.data[0].prmval=="X"){ lv_enable=true; } }
							if(lv_enable==true){
								// oculto localidad (sin typeahead)
								$("#<?= $lv_sec; ?> #div_adrtwn").addClass("hidden");					
								// muestro localidad (con typeahead)
								$("#<?= $lv_sec; ?> #div_lndtwntxt").removeClass("hidden");
							}
						});						
						tmssCallProcessNoBackdrop("?prg=grldatzon&act=19", [{name:"objtyp", value:"<?= ($vew_data->adr->adrsrctyp==''?$lv_mdlcod.'_'.$lv_prgcod:$vew_data->adr->adrsrctyp); ?>"}], function(data){
							if (data.data==1){
								var lv_buffer = '<?= vew_boot($lv_col210, array('label'=>$vew_lang->zone, 'input'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('adrzontxt', 'typeahead', $vew_data->adr->adrzontxt, $lv_default) )) )); ?>'
								$("#<?= $lv_sec; ?> #adrzon").closest(".form-group.tmss-form-group").replaceWith(lv_buffer);
								// Si tiene definido alwaysDisabled entonces griso el campo
								if( $("#<?= $lv_sec; ?> #adrzon").hasClass("tmssAlwaysDisabled") ){ $("#<?= $lv_sec; ?> #adrzon").attr("readonly", "true") }    
								// adrzontxt
								var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"adrzoncod" : "adrzoncod", "adrzontxt" : "adrzontxt"}, "fldflt" : {"z.docsts" : 'A', "z.objtyp" : "<?= ($vew_data->adr->adrsrctyp==''?$lv_mdlcod.'_'.$lv_prgcod:$vew_data->adr->adrsrctyp); ?>" }}; 
								tmssTypeahead($("#<?= $lv_sec; ?> #adrzontxt"), "grldatzon", lo_get);
							}
						});
					</script>
					<?php
				}
      ?>
    </div> 
</div>
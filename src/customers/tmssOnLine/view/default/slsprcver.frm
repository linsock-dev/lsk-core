<?php
	// url del formulario 
  $lv_lnk = '?prg=slsprcver&prm_slsprclstcod='.$vew_data->slsprclstcod.'&prm_slsprclstvercod='.$vew_data->slsprclstvercod;

	// campos requeridos
	$vew_input->RequiredFields( array('slsprclststrdte', 'docsts', 'slsprclstancsrc') );

	// clave del documento
	$lv_dockey = $vew_data->slsprclstvercod;

	// titulo
	$lv_title = $vew_lang->version;
	
	// módulo y programa
	$lv_mdlcod = 'SLS';
	$lv_prgcod = 'PRC';
	
	if($vew_sec->hasPermission('SLS','PRC','02')){ $vew_actcod='02'; }
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">  
  <form method="POST" class="form-horizontal tmss-form-horizontal pb-0" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<a href="#" class="hidden" id="btndelete" onclick="<?= $lv_sec; ?>_fnc({action: '04'});"></a>
		<a href="#" class="hidden" id="btnsubmit" onclick="<?= $lv_sec; ?>_fnc({action: '00'});"></a>
		
		<div class="container-fluid">	
      <div class="row">
				<div class="col-md-5">
					
          <div class="card">
            <div class="card-header">
              <div class="card-title"><?= $vew_lang->validity;?>
								<span class="tmss-card-icon"># <?= $vew_data->slsprclstvercod; ?></span>
                <?= gethtml('slsprclstcod','hidden',$vew_data->slsprclstcod); ?>
                <?= gethtml('slsprclstvercod','hidden',$vew_data->slsprclstvercod); ?>
            	</div>
            </div>
            <div class="card-body tmss-card-body-edit">
              <?= vew_boot($lv_colsm39, array('label'=>$vew_lang->from, 'input'=>gethtml('slsprclststrdte', 'docdte', $vew_data->slsprclststrdte, ($vew_data->slsprclstvercod==''?$lv_default:$lv_always_disabled)) )); ?>
              <?= vew_boot($lv_colsm39, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));?>
            </div>
          </div>
					
				</div>
				<div class="col-md-7">
				
					<div class="card">
						<div class="card-header"><div class="card-title"><?= $vew_lang->source; ?></div></div>
            <div class="card-body">
              <?php
                echo vew_boot($lv_colsm39, array('label'=>$vew_lang->base, 'input'=>gethtml('slsprclstancsrc', 'prclstancsrc', $vew_data->slsprclstancsrc, ($vew_data->slsprclstvercod==''?$lv_default:$lv_always_disabled)) ));
                echo '<div id="slsprclstanctypdiv">';
									echo vew_boot($lv_colsm39, array('label'=>$vew_lang->variation,'input'=>gethtml('slsprclstancvar', 'docqty', $vew_data->slsprclstancvar, ($vew_data->slsprclstvercod==''?$lv_default:$lv_always_disabled)) ));
									echo '</div>';
                echo '<div id="slsprclstancdiv">';
									echo vew_boot($lv_colsm39, array('label'=>$vew_lang->pricelist, 'input'=>vew_boot( array('style'=>'search','readonly'=>$vew_readonly), array('input'=>gethtml('slsprclstancprctxt', 'doccmt1x50', $vew_data->slsprclstancprctxt, ($vew_data->slsprclstvercod==''?$lv_default:$lv_always_disabled)) ))));
									echo gethtml('slsprclstancprccod','hidden',$vew_data->slsprclstancprccod);
                echo '</div>';
                echo '<div id="slsprclstupddiv">';
									echo vew_boot($lv_colsm39, array('label'=>$vew_lang->scope, 'input'=>gethtml('slsprclstanctyp', 'prclsttyp', $vew_data->slsprclstanctyp, ($vew_data->slsprclstvercod==''?$lv_default:$lv_always_disabled)) ));
									echo '<div id="slsprclstanctypdivtxt" class="hidden">'.vew_boot($lv_colsm39, array('label'=>'', 'input'=>'<span class="text-danger" id="slsprclstanctyptxt"></span>')).'</div>';
									echo vew_boot($lv_colsm39, array('label'=>$vew_lang->upgrade,'input'=>gethtml('slsprclstancupd', 'prclstancupd', $vew_data->slsprclstancupd, $lv_default) ));
                echo '</div>';
              ?>  
            </div>
					</div>
					
				</div>
			</div><!-- /row -->
    </div><!-- /container-fluid -->
  </form>
	<script>
		// slsprclsttxt - typeahead
		tmssTypeahead($("#<?= $lv_sec; ?> #slsprclstancprctxt"), "slsprc", {"fldsec":"<?= $lv_sec; ?>", 
                                                                        "fldasg":{"slsprclstancprccod":"slsprclstcod", 
                                                                                  "slsprclstancprctxt":"slsprclsttxt"}, 
                                                                        "fldflt":{"p.docsts":"A"}});
		
		// tipo. se muestra leyenda
		$("#<?= $lv_sec; ?> #slsprclstanctyp").on("change",function(){
			if($(this).val()=="1"){
				$("#<?= $lv_sec; ?> #slsprclstanctypdivtxt").removeClass("hidden");
				$("#<?= $lv_sec; ?> #slsprclstanctyptxt").html("Se consideran solo los productos indicados.");
			} else if($(this).val()=="2"){
				$("#<?= $lv_sec; ?> #slsprclstanctypdivtxt").removeClass("hidden");
				$("#<?= $lv_sec; ?> #slsprclstanctyptxt").html("Se consideran todos los productos de la Base.");
			} else {
				$("#<?= $lv_sec; ?> #slsprclstanctypdivtxt").addClass("hidden");
			}
		});

		$("#<?= $lv_sec; ?> #slsprclstancsrc").on("change",function(){
			if($(this).val()=="1" || $(this).val()=="2"){
				$("#<?= $lv_sec; ?> #slsprclstupddiv").removeClass("hidden");
				$("#<?= $lv_sec; ?> #slsprclstanctypdiv").removeClass("hidden");
				$("#<?= $lv_sec; ?> #slsprclstanctyp").addClass("tmssInputRequired");
				$("#<?= $lv_sec; ?> #slsprclstancupd").addClass("tmssInputRequired");
			} else {
				$("#<?= $lv_sec; ?> #slsprclstupddiv").addClass("hidden");
				$("#<?= $lv_sec; ?> #slsprclstanctypdiv").addClass("hidden");
				$("#<?= $lv_sec; ?> #slsprclstanctyp").removeClass("tmssInputRequired");
				$("#<?= $lv_sec; ?> #slsprclstancupd").removeClass("tmssInputRequired");
			}
			if($(this).val()=="2"){
				$("#<?= $lv_sec; ?> #slsprclstancdiv").removeClass("hidden");
				$("#<?= $lv_sec; ?> #slsprclstancprctxt").addClass("tmssInputRequired");
			} else {
				$("#<?= $lv_sec; ?> #slsprclstancdiv").addClass("hidden");
				$("#<?= $lv_sec; ?> #slsprclstancprctxt").removeClass("tmssInputRequired");
			}
		});

		$(function(){
      $("#<?= $lv_sec; ?> #slsprclstancvar").attr("min",-999)
			$("#<?= $lv_sec; ?> #slsprclstancsrc").trigger("change"); 
			$("#<?= $lv_sec; ?> #slsprclstanctyp").trigger("change"); 
		});
	</script>
  <script>			
		// server response ext
    function <?= $lv_sec; ?>_fncbckext(data) {
			var lv_error = (data.hasOwnProperty("errcod")?(data.errcod==0?false:true):false);
			
			// BORRAR. documento borrado se cierra la seccion
			if(lv_error==false && gv_<?= $lv_sec; ?>_last_action=="04") {
        	BootstrapDialog.closeAll(); 
				return;
      }
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				$("#<?= $lv_sec; ?>").replaceWith( data );		
			}
    }
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
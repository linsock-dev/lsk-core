<?php if($vew_readonly){ ?>
  <div class="card-body tmss-card-body">
    <!-- Modo lectura -->
   	<?php
      echo gethtml( 'accnum' , 'hidden', $vew_data->acc->accnum ); 
      echo gethtml( 'finacctxt' , 'hidden', $vew_data->acc->finacctxt );
      echo gethtml( 'finacccod' , 'hidden', $vew_data->acc->finacccod );
      $lv_acc = ($vew_data->acc->finacctxt!=''?'<label>'.$vew_lang->account.'</label><div>'.$vew_data->acc->finacctxt.'</div>':'');
      echo (($lv_acc == '')?'(Sin informaci&oacute;n)':'<strong>'.$lv_acc.'</strong>');
    ?>
  </div>
<?php } else { ?> 
	<!-- Modo edición -->
	<div class="card-body tmss-card-body-edit">
		<?php 
			echo vew_boot($lv_col210, array("label"=>$vew_lang->account
																			, "input1"=>vew_boot(	array("style"=>"search","readonly"=>$vew_readonly)
																													 , array("input"=>gethtml("finacctxt", "typeahead", $vew_data->acc->finacctxt, $lv_default) )) )); 
			echo gethtml( 'finacccod' , 'hidden', $vew_data->acc->finacccod ); 
		?>
	</div>
	<script>  
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"finacccod" : "finacccod", "finacctxt" : "finacctxt"}}; 
  	tmssTypeahead($("#<?= $lv_sec; ?> #finacctxt"), "finacc", lo_get);
	</script>
<?php } ?>
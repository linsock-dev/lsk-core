<div class="card">
	<div class="card-header">
		<div class="card-title"><?= $vew_lang->bank; ?><span class="tmss-card-icon"><i class="fas fa-university"></i></span></div>
	</div>
	
  <?php if($vew_readonly){ ?>
    <div class="card-body tmss-card-body-edit">
    	<!--Modo lectura-->
      <?= gethtml('bnknum','hidden', $vew_data->bnk->bnknum); ?>
      <?= gethtml('paymthcod','hidden', $vew_data->bnk->paymthcod); ?>
      <?= gethtml('paymthtxt','hidden', $vew_data->bnk->paymthtxt); ?>
      <?= gethtml('bnktxt','hidden', $vew_data->bnk->bnktxt); ?>
      <?= gethtml('bnkcod','hidden', $vew_data->bnk->bnkcod); ?>
      <?= gethtml('bnkacccbu','hidden', $vew_data->bnk->bnkacccbu); ?>
      <?= gethtml('bnkacccbuals','hidden', $vew_data->bnk->bnkacccbuals); ?>
      <?= gethtml('bnkbch','hidden', $vew_data->bnk->bnkbch); ?>
      <?= gethtml('bnkaccnum','hidden', $vew_data->bnk->bnkaccnum); ?>
      <?= gethtml('bnkacctyp','hidden', $vew_data->bnk->bnkacctyp); ?>
      <?php
        $lv_bnk = (intval($vew_data->bnk->paymthcod)!=0?'<label>'.$vew_lang->paymentmode.'</label><div>'.$vew_data->bnk->paymthtxt.'</div>':'');
        $lv_bnk .= (intval($vew_data->bnk->bnkcod)!=0?'<label>'.$vew_lang->bank.'</label><div>'.$vew_data->bnk->bnktxt.'</div>':'');
        $lv_bnk .= ($vew_data->bnk->bnkacccbu!=''?'<label>'.$vew_lang->cbu.'</label><div>'.$vew_data->bnk->bnkacccbu.'</div>':'');
        $lv_bnk .= ($vew_data->bnk->bnkacccbuals!=''?'<label>'.$vew_lang->cbualias.'</label><div>'.$vew_data->bnk->bnkacccbuals.'</div>':'');
        $lv_acctyptxt = (strtoupper($vew_data->bnk->bnkacctyp)=='CA'?'CAJA DE AHORROS': (strtoupper($vew_data->bnk->bnkacctyp)=='CC'?'CUENTA CORRIENTE':'') );
        $lv_bnk .= ($lv_acctyptxt!=''?'<label>'.$vew_lang->accounttype.'</label><div>'.$lv_acctyptxt.'</div>':'');

        $lv_bnk .= ($vew_data->bnk->bnkbch!='' || $vew_data->bnk->bnkaccnum!='' ?'<label>'.$vew_lang->account.' / '.$vew_lang->branch.'</label><div>'.$vew_data->bnk->bnkaccnum.' / '.$vew_data->bnk->bnkbch.'</div>':'');
				echo ($lv_bnk == ''?'(Sin informaci&oacute;n)':'<strong>'.utf8_encode($lv_bnk).'</strong>');
      ?>
    </div>
	<?php } else { ?>
    <div class="card-body tmss-card-body-edit">
      <!--Modo edición-->
      <?php
        echo vew_boot($lv_col210, array('label'=>$vew_lang->paymentmode, 	'input'=>gethtml('paymthcod', 'tsrpytmth_lst',	$vew_data->bnk->paymthcod, $lv_default) )); 
        echo vew_boot($lv_col210, array('label'=>$vew_lang->bank,					'input'=>vew_boot( array('style'=>'search','readonly'=>$vew_readonly), 
                                                                                             array('input'=>gethtml('bnktxt', 'typeahead', $vew_data->bnk->bnktxt, $lv_default) )) ));
  			echo gethtml ('bnkcod', 'hidden', $vew_data->bnk->bnkcod);
        echo vew_boot($lv_col210, array('label'=>$vew_lang->cbu, 					'input'=>gethtml('bnkacccbu', 'bnkacccbu',	$vew_data->bnk->bnkacccbu, $lv_default) )); 
        echo vew_boot($lv_col210, array('label'=>$vew_lang->cbualias, 		'input'=>gethtml('bnkacccbuals', 'doccmt1x20',	$vew_data->bnk->bnkacccbuals, $lv_default) )); 
        echo vew_boot($lv_col210, array('label'=>$vew_lang->accounttype, 	'input'=>gethtml('bnkacctyp', 'bnkacctyp', 	$vew_data->bnk->bnkacctyp, $lv_default) )); 
        echo vew_boot($lv_col210, array('label'=>$vew_lang->branch, 			'input'=>gethtml('bnkbch', 		'bnkbch', 		$vew_data->bnk->bnkbch, 		$lv_default) )); 
        echo vew_boot($lv_col210, array('label'=>$vew_lang->accountnumber,'input'=>gethtml('bnkaccnum', 'bnkaccnum', 	$vew_data->bnk->bnkaccnum, $lv_default) )); 
      ?>
    </div>
  <?php } ?>
</div> <!-- /card -->
<script>
	// bnktxt - typeahead
  var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{ "docsts" : "A"}, "fldasg":{ "bnkcod" : "bnkcod", "bnktxt" : "bnktxt"}};
  tmssTypeahead($('#<?= $lv_sec; ?> #bnktxt'), "tsrbnk", lo_get);
</script>
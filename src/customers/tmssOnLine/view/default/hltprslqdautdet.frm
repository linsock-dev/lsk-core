<?php	
	// campos requeridos
	$vew_input->RequiredFields( array() );

	// librería de estilos bootstrap
	include_once('_library.frm');

	if ( !isset($vew_actcod) ) { $vew_actcod = '11'; }
	$vew_readonly = ($vew_actcod=='10'?false:true);
?>
<div id="<?= $lv_sec; ?>_opndet">
  <table class="table table-condensed <?= ($vew_readonly ? 'table-striped' : ''); ?> ">
    <thead>
      <tr>
        <th><input type="checkbox" id="opnlqdchkhdr"></th>
        <th><?=$vew_lang->class?></th>
        <th><?= $vew_lang->code; ?></th>
        <th><?= $vew_lang->name; ?></th>
        <?= ($vew_data->grpcuscod==''?'':'<th>'.$vew_lang->financial.'</th>'); ?>
        <th><?= $vew_lang->PaymentMode; ?></th>
        <th class="text-right"><?= $vew_lang->points; ?></th>
        <th class="text-right"><?= $vew_lang->categoryprice; ?></th>
        <th class="text-right"><?= $vew_lang->hours; ?></th>
        <th class="text-right"><?= $vew_lang->sessions; ?></th>
        <th class="text-right"><?= $vew_lang->price; ?></th>
        <th class="text-right"><?= $vew_lang->expenses; ?></th>
        <th class="text-right"><?= $vew_lang->total; ?></th>
        <?php	
          foreach ($vew_data->opnlqd as $lv_row) {	
            if(isset($lv_row['errtyp'])){ 
              if($lv_row['errtyp'] != 'S'){
                echo '<th></th>';
                break;
              }
            }
          }
        ?>
      </tr>
    </thead>
    <tbody>
      <?php
        foreach ($vew_data->opnlqd as $lv_row) {	
          if(isset($lv_row['errtyp'])){ 
            $lv_err = '';
            $lv_arrerr = explode( chr(10), html_entity_decode( $lv_row['errtxt']??'' ) ) ;
            array_pop($lv_arrerr);	
            foreach ($lv_arrerr as $lv_row1) {
              $lv_err.='<li class=\''.($lv_row['errtyp']=='W' ? 'liwrn' :( $lv_row['errtyp']=='E' ? 'lierr' : '')).'\'>'.$lv_row1.'</li>';
            }
          }
          echo '<tr '.(isset($lv_row['errtyp'])?($lv_row['errtyp']=='W'?'class="trwrn"':($lv_row['errtyp']=='E'?'class="trerr"':'')):'').'>'.
                '<td>'.(isset($lv_row['errtyp'])?($lv_row['errtyp']!='E' ? '<input type="checkbox" id="opnlqdchk" data-prscod="'.$lv_row['prscod'].'" data-objtot="'.$lv_row['hltlqdtot'].'" '.(isset($lv_row['hltprslqdcod']) && !$vew_readonly?'checked="checked"':'').'>' : ''):'<input type="checkbox" id="opnlqdchk" data-prscod="'.$lv_row['prscod'].'" data-objtot="'.$lv_row['hltlqdtot'].'" data-hltprslqdcod="'.(isset($lv_row['hltprslqdcod'])?$lv_row['hltprslqdcod']:'').'" '.(isset($lv_row['hltprslqdcod']) && !$vew_readonly?'checked="checked"':'').'>').'</td>'.
                '<td>'.($lv_row["sysdocclstxt"]??'').'</td>'.
            		'<td>'.$lv_row['prscod'].'</td>'.
                '<td>'.(isset($lv_row['hltprslqdcod'])?'<a href="#" name="lqdlnk" data-hltprslqdcod="'.$lv_row['hltprslqdcod'].'">'.$lv_row['prstxt'].'</a>':$lv_row['prstxt']).'</td>'.
                ($vew_data->grpcuscod==''?'':'<td>'.$lv_row['custxt'].'</td>').
                '<td>'.(isset($lv_row['paymthtxt'])?$lv_row['paymthtxt']:'').'</td>'.
                '<td class="text-right">'.number_format($lv_row['hltlqdcatpts']??0,0,',','.').'</td>'.													
                '<td class="text-right">'.number_format($lv_row['hltlqdcatprc']??0,2,',','.').'</td>'.
                '<td class="text-right">'.number_format($lv_row['hltlqdhrsqty']??0,2,',','.').'</td>'.
                '<td class="text-right">'.number_format($lv_row['hltlqdsesqty']??0,0,',','.').'</td>'.
                '<td class="text-right">'.number_format($lv_row['hltlqdprc']??0,2,',','.').'</td>'.
                '<td class="text-right">'.number_format($lv_row['hltlqdnwstot']??0,2,',','.').'</td>'.
                '<td class="text-right">'.number_format($lv_row['hltlqdtot']??0,2,',','.').'</td>'.
                (isset($lv_row['errtyp']) ? '<td>'.($lv_row['errtyp']!='S' ? '<a tabindex="0" role="button"  data-toggle="popover" data-placement="left"  title="'.($lv_row['errtyp']=='W' ? 'Advertencias' : 'Errores').'" data-content="<ul>'.$lv_err.'</ul>" ><i class="fas fa-triangle-exclamation"></i></a>' : '').'</td>' : '').
                '</tr>';
        } 
      ?>
    </tbody>
  </table>
</div><!-- /tab-pane -->
<script>
  $(function() {
    $("#<?= $lv_sec; ?>_opndet tbody a[data-toggle= \"popover\"]").popover({ html: true });
  });

	// link - documento
	$("#<?= $lv_sec; ?>_opndet a[name='lqdlnk']").on("click",function(e){ e.preventDefault();
		tmssLink("?prg=hltprslqd&act=03&prm_mdlcod=HLT&prm_prgcod=LQM&prm_hltprslqdcod="+$(this).data("hltprslqdcod")+"&prm_bcksec=<?= $vew_data->bcksec; ?>", [{target: "_new_section", post_data: [{name:"hltprslqdcod", value:$(this).data("hltprslqdcod")}] }] );                               
	});
</script>
<script>
	tmssFormEdit("<?= $lv_sec; ?>_opndet",<?= ($vew_actcod=='11'?'true':'false'); ?>);
</script>
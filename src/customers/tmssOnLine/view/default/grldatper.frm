<div class="container-fluid">
	<div class="row">
    <div class="card">
      <div class="card-header"><div class="card-title"><?= $vew_lang->personaldata; ?></div></div>
      <div class="card-body tmss-card-body-edit">
        <?php if($vew_readonly) { ?>
					<?php
            echo gethtml('pernum', 'hidden', $vew_data->per->pernum);
            echo gethtml('perbrndte', 'hidden', (is_object($vew_data->per->perbrndte)?$vew_data->per->perbrndte->format('d/m/Y'):$vew_data->per->perbrndte));
            echo gethtml('persex', 'hidden', $vew_data->per->persex);
            echo gethtml('civstscod', 'hidden', $vew_data->per->civstscod);
 						echo gethtml('civststxt', 'hidden', $vew_data->per->civststxt);
            echo gethtml('pernattxt', 'hidden', $vew_data->per->pernattxt);
            echo gethtml('pernatcod', 'hidden', $vew_data->per->pernatcod);
            echo gethtml('hhrmedcovcod', 'hidden', $vew_data->per->hhrmedcovcod);
            echo gethtml('hhrmedcovtxt', 'hidden', $vew_data->per->hhrmedcovtxt);
            echo gethtml('hhrmedcovaflpln', 'hidden', $vew_data->per->hhrmedcovaflpln);
            echo gethtml('hhrmedcovaflnum', 'hidden', $vew_data->per->hhrmedcovaflnum);

            $lv_cnt = '';
            if($vew_data->per->perbrndte!=''){ 
              $fecha_nacimiento = $vew_data->per->perbrndte->format('d-m-Y');
              $dia_actual = date('Y-m-d');
              $lv_age = date_diff(date_create($fecha_nacimiento), date_create($dia_actual));
              $lv_agestr = ($lv_age->y>0?$lv_age->y.' '.$vew_lang->years:'').($lv_age->y<5 && $lv_age->m>0?' '.$lv_age->m.' '.$vew_lang->months:'').($lv_age->y<1?' '.$lv_age->d.' '.$vew_lang->days:'');
              $lv_cnt .= '<i class="fas fa-birthday-cake pr-5"></i> '.$vew_data->per->perbrndte->format('d/m/Y'). ' ('.$lv_agestr.' )'; 
            }
            if($vew_data->per->persex!=''){ $lv_cnt .= ($lv_cnt!=''?'<br>':'').'<i class="fas fa-restroom pr-5"></i> '.($vew_data->per->persex=='M'?'Masculino':($vew_data->per->persex=='F'?'Femenino':($vew_data->per->persex=='X'?'No binario':''))); }
            if($vew_data->per->civstscod!=''){ $lv_cnt .= ($lv_cnt!=''?'<br>':'').'<i class="fas fa-ring pr-5"></i> '.$vew_data->per->civststxt; }
            if($vew_data->per->pernattxt!=''){ $lv_cnt .= ($lv_cnt!=''?'<br>':'').'<i class="fas fa-globe pr-5"></i> '.$vew_data->per->pernattxt; }
            if(intval($vew_data->per->hhrmedcovcod)!=0){ $lv_cnt .= ($lv_cnt!=''?'<br>':'').'<i class="fas fa-clinic-medical pr-5"></i> '.$vew_data->per->hhrmedcovtxt; }
            if($vew_data->per->hhrmedcovaflpln!='' || $vew_data->per->hhrmedcovaflnum!=''){ $lv_cnt .= ($lv_cnt!=''?'<br>':'').'<span class="pr-5 pl-24">'.$vew_data->per->hhrmedcovaflpln.($vew_data->per->hhrmedcovaflpln!='' && $vew_data->per->hhrmedcovaflnum!=''?' / ':'').$vew_data->per->hhrmedcovaflnum.'</span>'; }
            echo (($lv_cnt == '')?'(Sin informaci&oacute;n)':'<strong>'.$lv_cnt.'</strong>');
          ?>
        <?php } else { ?>

          <?php 
            echo gethtml('pernum', 'hidden', $vew_data->per->pernum);
            echo vew_boot($lv_col210, array('label'=>$vew_lang->borndate, 	'input'=>gethtml('perbrndte','docdte',$vew_data->per->perbrndte,$lv_default) )); 
            echo vew_boot($lv_col210, array('label'=>$vew_lang->sex, 				'input'=>gethtml('persex','adrsex',$vew_data->per->persex,$lv_default) )); 
            echo vew_boot($lv_col210, array("label"=>$vew_lang->civilstatus,'input'=>gethtml('civstscod','percivsts',$vew_data->per->civstscod,$lv_default) )); 
            echo vew_boot($lv_col210, array('label'=>$vew_lang->nationality,'input'=>vew_boot(	array('style'=>'search','readonly'=>$vew_readonly),  array('input'=>gethtml('pernattxt', 'adrlndtxt', $vew_data->per->pernattxt, $lv_default) )) ));
            echo gethtml('pernatcod', 'hidden', $vew_data->per->pernatcod);
            echo vew_boot($lv_col210, array('label'=>$vew_lang->medicalcoverage,'input'=>vew_boot(	array('style'=>'search','readonly'=>$vew_readonly),  array('input'=>gethtml('hhrmedcovtxt', 'doccmt1x50', $vew_data->per->hhrmedcovtxt, $lv_default) )) ));
            echo gethtml('hhrmedcovcod', 'hidden', $vew_data->per->hhrmedcovcod);
            echo vew_boot(array($lv_col255, $lv_colxs1266), array('label'=>$vew_lang->plan.'/'.$vew_lang->affiliatednumber, 'input1'=>gethtml('hhrmedcovaflpln','doccmt1x50',$vew_data->per->hhrmedcovaflpln,$lv_default), 'input2'=>gethtml('hhrmedcovaflnum','doccmt1x50',$vew_data->per->hhrmedcovaflnum,$lv_default) )); 
          ?>
					<script>
          
            // si se quiere ingresar estado civil sin haber cargado un pais, aparece un warning 
            $("#<?= $lv_sec; ?> #civstscod").on("focus", function(e){
              var lv_lndcod = $("#<?= $lv_sec; ?> #lndcod").val();
              if (!lv_lndcod){
                e.preventDefault();
                toastr.warning("Se debe seleccionar un pais.");
              }                                         
          	});
            
        	</script>
          <script>
            // lndnat
            var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"pernatcod":"lndcod", "pernattxt":"lndtxt"}};
            tmssTypeahead($("#<?= $lv_sec; ?> #pernattxt"), "grladrlnd", lo_get);

            // medcov
            var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"c.docsts" : "A"}, "fldasg":{"hhrmedcovcod":"hhrmedcovcod", "hhrmedcovtxt":"hhrmedcovtxtful"}};
            tmssTypeahead($("#<?= $lv_sec; ?> #hhrmedcovtxt"), "hhrmedcov", lo_get);
					</script>
        	<script>
            // percivsts
            // si cambia el país, cambio las opciones de estados civiles
            $("#<?= $lv_sec; ?> #lndcod").on("change",function(e){ e.preventDefault();
              <?= $lv_sec; ?>_update_civsts();
            });
        	
            function <?= $lv_sec; ?>_update_civsts( lp_callback ){
              var lv_lndcod = $("#<?= $lv_sec; ?> #lndcod").prop("value");
              $("#<?= $lv_sec; ?> #civstscod option").remove();
              $("#<?= $lv_sec; ?> #civstscod").append("<option value=''></option>");
              tmssCallProcessNoBackdrop("?prg=grladrlndciv&act=19",[{name:"lndcod",value:lv_lndcod}],function(data){
                for(var i=0; i<data.length; i++){
                  $("#<?= $lv_sec; ?> #civstscod").append("<option value='"+data[i].civstscod+"'>"+data[i].civststxt+"</option>");
                }
                if(typeof lp_callback!="undefined"){ lp_callback(); }
              });
            }

            $(function(){
              <?= $lv_sec; ?>_update_civsts( function(){
                $("#<?= $lv_sec; ?> #civstscod").prop("value", "<?= $vew_data->per->civstscod; ?>");
              });
            });
          </script>
        <?php } ?>
      </div>
    </div>
	</div>
</div>
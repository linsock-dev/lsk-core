<?php 
	/* librería de estilos bootstrap */
	include_once('_library.frm');

	/* campos requeridos */
	$vew_input->RequiredFields( array() );
		
	/* -- acción por default */
	if ( !isset($vew_actcod) ) { $vew_actcod = '13'; }
	$vew_readonly = ($vew_actcod=='11'||$vew_actcod=='12'?false:true);
?>
<div id="<?= $lv_sec; ?>">
	<div class="container-fluid" role="tabpanel">
    <hr style="margin-top: 10px; margin-bottom:10px">
		<ul class="nav nav-pills" role="tablist">
      <li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_opnsrv" role="tab" data-toggle="tab">Prestaciones <span class="badge opnsrvbdg"></span></a></li>
			<li role="presentation"><a href="#<?= $lv_sec; ?>_opnexp" role="tab" data-toggle="tab"><?= $vew_lang->expenses; ?> <span class="badge opnexpbdg"></span></a></li>
			<div class="pull-right">
				<h3 style="margin-top: 5px; margin-bottom: 5px;"><small><?= $vew_lang->total; ?></small>&nbsp;&nbsp;&nbsp;<span id="hltlqdtot"><?= number_format(floatval(0),2,',','.'); ?></span></h3>
			</div>
		</ul>
    <hr style="margin-top: 10px; margin-bottom:10px">
		<div class="tab-content tmss-tab-content">
			
			<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_opnsrv">
				<table class="table table-condensed table-bordered" id="opnsrvtbl">
					<thead>
						<tr>
              <th class="text-center"> <?php if(!$vew_readonly){ ?><input type="checkbox" id="btnsel"><?php } ?> </th>
							<th style="width: 550px;">Descripci&oacute;n</th>
							<th style="width: 100px;" class="text-right">Cantidad</th>
							<th style="width: 150px;" class="text-right">Importe</th>
							<th style="width: 150px;" class="text-right">Total</th>
						</tr>
					</thead>
					<tbody>
						<?php	
            	// módulos
            	$lv_modgrp = array();
            
            	foreach($vew_data->opnsrv as $lv_row){
                if(!in_array($lv_row['slsprcsrctxt'], $lv_modgrp)){
                  echo '<tr class="modgrp" name="itmgrp" data-modcod="'.$lv_row['modcod'].'">'.
                        '<td style="width: 35px; padding-left: 0px; border-bottom:0px;"></td>'.
                        '<td style="border-bottom:0px;">'.$lv_row['slsprcsrctxt'].'</td>'.
                        '<td style="border-bottom:0px;" class="text-right" name="grpqty"></td>'.
                        '<td style="border-bottom:0px;" class="text-right" name="grpprc"></td>'.
                        '<td style="border-bottom:0px;" class="text-right" name="grptot"></td>'.
                        '</tr>';
                  array_push($lv_modgrp, $lv_row['slsprcsrctxt']);
								}
              ?>
            		<script>
                  
                  // controles
                  var lv_modcod = <?= $lv_row['modcod']; ?>;
                  
                  var lv_item = `<?php
                									$lv_refobjtyp = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'srcobjtyp');
                									$lv_refobjtyptxt = ($lv_refobjtyp == 'HLT_PCR' ? 'CONTROL DE PRESTACIONES' : 'EVOLUCI&Oacute;N');
                									$lv_refobjcod001 = $lv_row['refobjcod001']??$lv_row['hltplnctrcod']??$lv_row['evlcod'];
                									/* busco fecha por control o evaluación. 
                                  	Igual siempre pregunto por evldte porque registros anteriores están cargados con evldte
                                  */
                									$lv_srcdte = ($lv_row['srcdte'] ?? $lv_row['evldte'] ?? '');
                									$lv_srcdte = $lv_srcdte ? $lv_srcdte->format('d/m/Y') : '';
                                  echo '<tr class="bg-secondary" name="itmgrp" data-modcod="'.$lv_row['modcod'].'" data-rowqty="1" data-rowprc="'.$lv_row['slsprc'].'">'.
                                        '<td class="text-center" style="padding-left: 10px; border-top:0px; border-bottom:0px;">'.
                                          '<input type="checkbox" name="itmchk" class="'.($vew_readonly?'hidden':'').'"'.
                                    				' data-hltlqddoccod="'.(isset($lv_row['hltlqddoccod']) ? $lv_row['hltlqddoccod'] : '').'"'.
                                            ' data-modcod="'.$lv_row['modcod'].'"'.
                                            ' data-modtxt="'.$lv_row['slsprcsrctxt'].'"'.
                                    				' data-rowprc="'.$lv_row['slsprc'].'"'.
                                    				' data-rowqty="1"'.
                                    				' data-refobjtyp="'.$lv_refobjtyp.'"'.
                                    				' data-refobjtyptxt="'.$lv_refobjtyptxt.'"'.
                                            ' data-plnid="'.$lv_row['plnid'].'"'.
                                            ' data-plndteid="'.$lv_row['plndteid'].'"'.
                                            ' data-spcfrm="'.$lv_row['spcfrm'].'"'.
                                    				' data-patcodext="'.(isset($lv_row['patcodext']) && $lv_row['patcodext'] != '' ? $lv_row['patcodext'] : '').'"'.
                                    				' data-patcod="'.$lv_row['patcod'].'"'.
                                    				' data-pattxt="'.$lv_row['pattxt'].'"'.
                                    				' data-patpro="'.$lv_row['patpro'].'"'.
                                    				' data-evlcod="'.((isset($lv_row['evlcod'])) ? $lv_row['evlcod'] : '"').'"'.
                                    				' data-evlnum="'.((isset($lv_row['evlnum'])) ? $lv_row['evlnum'] : '"').'"'.
                                    				' data-srcdte="'.$lv_srcdte.'"'.
                                    				' data-hltdisclscod="'.$lv_row['hltdisclscod'].'"'.
                                    				' data-hltdisclstxt="'.$lv_row['hltdisclstxt'].'"'.
                                    				' data-refobjcod001="'.(isset($lv_row['hltplnctrcod']) ? $lv_row['hltplnctrcod'] : $lv_row['evlcod']).'"'.
                                    				' data-refobjcod002="'.(isset($lv_row['hltplnctrdtecod']) ? $lv_row['hltplnctrdtecod'] : $lv_row['evlnum']).'"'.
                                            ($lv_row['hltlqdcod']!=''?' checked ':'').
                                            '>'.
                                        '</td>'.
                                        '<td style="border-top:0px; border-bottom:0px;"><small><a href="#" name="evllnk" data-refobjtyp="'.$lv_refobjtyp.'" data-refobjcod001="'.$lv_refobjcod001.'">'.
                                        	(isset($lv_row['patcodext']) && $lv_row['patcodext'] != '' ? $lv_row['patcodext'] : '').
                                    			(isset($lv_row['patpro']) && $lv_row['patpro'] != '' ? ' - '.$lv_row['patpro'] : '').
                                    			(isset($lv_row['pattxt']) && $lv_row['pattxt'] != '' ? ' - '.$lv_row['pattxt'] : '').
                                    			(isset($lv_row['hltplnctrcmt']) && $lv_row['hltplnctrcmt'] != '' ? ' - '.$lv_row['hltplnctrcmt'] : '').
                                    			(isset($lv_row['hltdisclstxt']) && $lv_row['hltdisclstxt'] != '' ? ' - '.$lv_row['hltdisclstxt'] : '').
                                    			($lv_srcdte ? ' - '.$lv_srcdte: '').
                                        '</td>'.
                                        '<td style="border-top:0px; border-bottom:0px;" class="text-right" name="rowqty">1</td>'.
                                        '<td style="border-top:0px; border-bottom:0px;" class="text-right" name="rowprc">'.number_format($lv_row['slsprc'], 2).'</td>'.
                                    		'<td style="border-top:0px; border-bottom:0px;" class="text-right" name="rowtot"></td>'.
                                        '</tr>';
                      ?>`;
                  // se coloca después de la fila con el nombre del material que se está leyendo
                  
                  $(lv_item).insertAfter("#<?= $lv_sec; ?> .modgrp[data-modcod="+lv_modcod+"]");
            		</script>
            <?php
							}
						?>
					</tbody>
				</table>
			</div>
      
      <div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_opnexp">
				<table class="table table-condensed table-bordered" id="opnexptbl">
          <thead>
						<tr>
              <th class="text-center" style="width: 35px"> <?php if(!$vew_readonly){ ?><input type="checkbox" id="btnselexp"><?php } ?> </th>
							<th style="width: 175px;">C&oacute;digo</th>
							<th style="width: 275px;" class="text-left">Fecha</th>
							<th style="width: 300px;" class="text-left">Concepto</th>
							<th style="width: 200px;" class="text-right">Total</th>
						</tr>
					</thead>
					<tbody>
						<?php	
							foreach ($vew_data->opnexp as $lv_row) { 
								echo	'<tr class="bg-secondary">'.
                        '<td class="text-center" style="padding-left: 10px; border-top:0px; border-bottom:0px; width: 35px;">'.
                          '<input type="checkbox" name="itmchk" class="'.($vew_readonly?'hidden':'').'"'.
                  				'data-hltlqddoccod="'.(isset($lv_row['hltlqddoccod']) ? $lv_row['hltlqddoccod'] : '').'"'.
                          'data-refobjtyp="'.$lv_row['refobjtyp'].'"'.
                  				'data-rowprc="'.$lv_row['hltlqddoctot'].'"'.
                          'data-rowqty="1"'.
                  				'data-hltlqddoccodext="'.$lv_row['hltlqddoccodext'].'"'.
                          'data-refobjcod001="'.$lv_row['refobjcod001'].'"'.
                          'data-refobjcod002="'.$lv_row['refobjcod002'].'"'.
                          'data-hltlqddocdte="'.(isset($lv_row['hltlqddocdte'])?($lv_row['hltlqddocdte']->format('YmdHis')):'').'"'.
                          'data-hltlqddoctot="'.$lv_row['hltlqddoctot'].'"'.
                  				'data-hltlqddoctxt="'.$lv_row['hltlqddoctxt'].'"'.
                          (isset($lv_row['hltlqdcod'])?'checked="checked"':'').
                          '>'.
                        '</td>'.
                        '<td>'.$lv_row['hltlqddoccodext'].'</td>'.
                        '<td>'.$lv_row['hltlqddocdtecnv'].'</td>'.
                        '<td>'.$lv_row['hltlqddoctxt'].'</td>'.
                        '<td>'.number_format($lv_row['hltlqddoctot'],2,',','.').'</td>'.
                      '</tr>';
							} 
						?>
					</tbody>
				</table>
			</div>
      
		</div>		
	</div> <!-- /panel-group -->
</div> <!-- /row -->
<script>
	var <?= $lv_sec; ?>_hhrlqddet_hold = false;
	
  function <?= $lv_sec; ?>_calcTotal() {
		var lv_grltot = 0;
		var lv_rowtot = 0;

		var lv_sel = Array();
		$("#<?= $lv_sec; ?> #hltlqdtot").html( Number(0).toFixed(2) ); 
		$("#<?= $lv_sec; ?> #opnsrvtbl tr[name=itmgrp] td[name=grpqty]").html( Number(0).toFixed(0) ); 
		$("#<?= $lv_sec; ?> #opnsrvtbl tr[name=itmgrp] td[name=grptot]").html( Number(0).toFixed(2) ); 
		
		// obtengo registros marcados
		$("#<?= $lv_sec; ?> #opnsrvtbl input[name=itmchk]:checked").each(function( index ){
			lv_sel.push({
        modcod: $(this).data("modcod"),
				refobjtyptxt: $(this).data("refobjtyptxt"),
				refobjtyp: $(this).data("refobjtyp"),
				rowqty: $(this).data("rowqty"),
				rowprc: $(this).data("rowprc")
			});			
			<?php //if($vew_readonly){ ?>
			//lv_rowtot = parseFloat($(this).parent().parent().find("td[name=rowtot]").html().replace(/,/g, ''));
			<?php //} else { ?>
			lv_rowtot = Number($(this).data("rowqty") * $(this).data("rowprc"));
			<?php //} ?>
			lv_grltot += lv_rowtot;
		});
		// actualizo sub-grupos
		$("#<?= $lv_sec; ?> tr[name=itmgrp]").each(function( index ){
			var lv_qty = 0;
			var lv_tot = 0;
			for(var i=0; i<lv_sel.length; i++){
				if(lv_sel[i].modcod==$(this).data("modcod")){
					lv_tot += Number(lv_sel[i].rowqty * lv_sel[i].rowprc);
          lv_qty ++;
				}
			}
			$(this).find("td[name=grptot]").html( "<b>"+Number(lv_tot).toFixed(2)+"</b>" );
      $(this).find("td[name=grpqty]").html( "<b>"+Number(lv_qty).toFixed(0)+"</b>" );
		});
    // incluyo gastos
    $("#<?= $lv_sec; ?> #opnexptbl input[name=itmchk]:checked").each(function( index ){
			lv_rowtot = Number($(this).data("hltlqddoctot"));
			lv_grltot += lv_rowtot;
		});
		$("#<?= $lv_sec; ?> #hltlqdtot").html( Number(lv_grltot).toFixed(2).toLocaleString() );
  }
  
  
	// cambia el check de cabecera según los checks de posiciones
  function <?= $lv_sec; ?>_changeHeaderCheck(lp_tblid){
    // busca que no haya ni un check desmarcado y que la cantidad de checks sea mayor a 0
    if(!$("#<?= $lv_sec; ?> #"+lp_tblid+" input[name=itmchk]").toArray().some(function(itmchk){ return !$(itmchk).is(":checked"); })
      && $("#<?= $lv_sec; ?> #"+lp_tblid+" input[name=itmchk]").length > 0){
      $("#<?= $lv_sec; ?> #"+lp_tblid+" input[type=checkbox]:first").prop("checked", true);
    }else{
      $("#<?= $lv_sec; ?> #"+lp_tblid+" input[type=checkbox]:first").prop("checked", false);
    }
  }
  
  
  $(function(){
    $("#<?= $lv_sec; ?> a[name='evllnk']").on("click",function(e){ e.preventDefault();
      var lv_mdlcod = $(this).data("refobjtyp").split("_")[0];
      var lv_prgcod = $(this).data("refobjtyp").split("_")[1];
                                                                  
			if (lv_prgcod == "PCR"){
      	tmssLink("?prg=hltplnctr&act=03&prm_mdlcod="+lv_mdlcod+"&prm_prgcod="+lv_prgcod+"&prm_hltplnctrcod="+$(this).data("refobjcod001"), [{target: "_new_section", post_data: [] }] );  
      }else if (lv_prgcod == "EVL"){
        var lv_frm = $(this).parent().parent().parent().find("input[name=itmchk]").data("spcfrm");
        if(lv_frm != ""){
          lv_frm = lv_frm.replace("&AMP;","&").toLowerCase();
        }else{
          // Si el formulario esta vacio, entonces  voy a recuperar el formulario de evolucion estandar (hltpatevl)
          lv_frm = "?prg=hltpatevl&act=03";
        }
        
        var lv_pstdat={ evlcod: $(this).parent().parent().parent().find("input[name=itmchk]").data("refobjcod001"),
                        patcod: $(this).parent().parent().parent().find("input[name=itmchk]").data("patcod"),
                        plnid: $(this).parent().parent().parent().find("input[name=itmchk]").data("plnid"),
                        plndteid: $(this).parent().parent().parent().find("input[name=itmchk]").data("plndteid"),
                        popup: "X"};
        tmssCallProcess(lv_frm,lv_pstdat,function(data){
          BootstrapDialog.show({
            title: $(this).parent().find("input[name=itmchk]").data("patcod"),
            message: $(data),
            size: BootstrapDialog.SIZE_WIDE
          });
        });
      }
    });

    //Botón de seleccionar/deseleccionar todas las prestaciones/evoluciones
    $("#<?= $lv_sec; ?> #btnsel").on("click",function(e){
			<?= $lv_sec; ?>_hhrlqddet_hold=true;
      if($(this).is(":checked")){
        $("#<?= $lv_sec; ?> #opnsrvtbl tr[name=itmgrp] td input[name=itmchk]:not(:checked)").trigger( "click" );
      }else{
        $("#<?= $lv_sec; ?> #opnsrvtbl tr[name=itmgrp] td input[name=itmchk]:checked").trigger( "click" );
      }
			<?= $lv_sec; ?>_calcTotal();
			<?= $lv_sec; ?>_hhrlqddet_hold=false;
    });
    
    //Botón de seleccionar/deseleccionar todos los gastos
    $("#<?= $lv_sec; ?> #btnselexp").on("click",function(e){
      if($(this).is(":checked")){
        $("#<?= $lv_sec; ?> #opnexptbl td input[name=itmchk]:not(:checked)").trigger( "click" );
      }else{
        $("#<?= $lv_sec; ?> #opnexptbl td input[name=itmchk]:checked").trigger( "click" );
      }
    });

    // item - checkbox
    $("#<?= $lv_sec; ?> #opnsrvtbl input[name=itmchk]").on("change",function(e){ e.preventDefault();
      var lv_rowtot=0;
      if($(this).is(":checked")){
        lv_rowtot = $(this).data("rowqty") * $(this).data("rowprc");
      }
      $(this).parent().parent().find("td[name=rowtot]").html( Number(lv_rowtot).toFixed(2) );
			if(<?= $lv_sec; ?>_hhrlqddet_hold==false){ <?= $lv_sec; ?>_calcTotal();	}
    });
    
    // gasto - checkbox
    $("#<?= $lv_sec; ?> #opnexptbl input[name=itmchk]").on("change",function(e){ e.preventDefault();
      <?= $lv_sec; ?>_calcTotal();
    });

    // cambia el check de cabecera según los checks de posiciones
    $("#<?= $lv_sec; ?> input[name=itmchk]").on("click", function(e){
			var lv_tblid = $(this).closest("table").attr('id');
      <?= $lv_sec; ?>_changeHeaderCheck(lv_tblid);
		});
    
    $("#<?= $lv_sec; ?> table").each(function(i){
      <?= $lv_sec; ?>_changeHeaderCheck($(this).attr("id"));
    });
		<?= $lv_sec; ?>_calcTotal();
	});
  
	tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='11'||$vew_actcod=='12'?'true':'false'); ?>);
</script>
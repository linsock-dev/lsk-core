<?php
	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// librería de estilos bootstrap 
	include_once('_library.frm');
		
	// acción por default 
	if ( !isset($vew_actcod) ) { $vew_actcod = '13'; }
	$vew_readonly = ($vew_actcod=='11'||$vew_actcod=='12'?false:true);
?>
<div id="<?= $lv_sec; ?>">
	<div class="container-fluid" role="tabpanel">
		<ul class="nav nav-pills" role="tablist">
			<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_opnsrv" role="tab" data-toggle="tab">Prestaciones <span class="badge opnsrvbdg"></span></a></li>
			<li role="presentation"><a href="#<?= $lv_sec; ?>_opnexp" role="tab" data-toggle="tab"><?= $vew_lang->expenses; ?> <span class="badge opnexpbdg"></span></a></li>
			<div class="pull-right">
				<h3 style="margin-top: 0px; margin-bottom: 0px;"><small><?= $vew_lang->total; ?></small>&nbsp;&nbsp;&nbsp;<span id="edulqdtot"><?= number_format(floatval(0),2,',','.'); ?></span></h3>
			</div>
		</ul>
		<hr style="margin-top: 10px; margin-bottom: 10px;">
		<div class="tab-content tmss-tab-content">
			
			<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_opnsrv">
				<div class="row">
					<label class="control-label col-md-2"><?= $vew_lang->quantity; ?></label>
					<div class="col-md-2"><?= gethtml('opnsrvqty','docqty','',$lv_always_disabled); ?></div>
					<div class="col-md-4"></div>
					<label class="control-label col-md-2"><?= $vew_lang->subtotal; ?></label>
					<div class="col-md-2"><?= gethtml('opnsrvtot','docqty','',$lv_always_disabled); ?></div>
				</div>
				<hr>
				<table class="table table-condensed table-bordered" id="opnsrvtbl">
					<thead>
						<tr>
							<th><input type="checkbox" id="opnsrvchkhdr"></th>
							<th>Descripci&oacute;n</th>
							<th class="text-right">Cantidad</th>
							<th class="text-right">Importe</th>
							<th class="text-right">Total</th>
						</tr>
					</thead>
					<tbody> 
						<?php	
							$lv_row = array(); 
            	$lv_opnsrv = is_array($vew_data)?$vew_data['opnsrv']:$vew_data->opnsrv;
            	foreach($lv_opnsrv as $lv_rowdat){ if(isset($lv_rowdat['edulqddocqty']) && $lv_rowdat['edulqddocqty']>0){$lv_row[]=$lv_rowdat;} }
							$lv_lstgrp = '';
							for($i=0; $i<count($lv_row); $i++) {
								
								// grupo o registro individual (sin módulo) //71 al 79 edulqd hasta que termine el save
								if($lv_lstgrp!=$lv_row[$i]['refobjgrpcod'] || $lv_row[$i]['refobjgrpcod']==''){
									echo '<tr>'.
												'<td>'.($lv_row[$i]['refobjgrpcod']==''?'':'<a href="#" name="opnsrvgrp" data-refobjgrpcod="'.$lv_row[$i]['refobjgrpcod'].'"><span class="fas fa-chevron-right"></span></a>').'&nbsp;&nbsp;<input type="checkbox" id="opnsrvchkgrp" data-refobjgrpcod="'.$lv_row[$i]['refobjgrpcod'].'" data-edulqddocqty="'.$lv_row[$i]['edulqddocqty'].'" data-edulqddoctot="'.$lv_row[$i]['edulqddoctot'].'" '.($lv_row[$i]['edulqdcod']!=0?'checked="checked"':'').'></td>'.
												'<td>'.$lv_row[$i]['refobjgrptxt'].'</td>'.
												'<td class="text-right">'.($lv_row[$i]['refobjgrpcod']==''?number_format($lv_row[$i]['edulqddocqty'],0,'.',','):'').'</td>'.
												'<td class="text-right">'.number_format($lv_row[$i]['edulqddocprc'],2,'.',',').'</td>'.
												'<td class="text-right">'.($lv_row[$i]['refobjgrpcod']==''?number_format($lv_row[$i]['edulqddoctot'],2,'.',','):'').'</td>'.
												'</tr>';
									$lv_lstgrp = $lv_row[$i]['refobjgrpcod'];
								}
								
								// registros individuales (se agrupan varias prestaciones en un mismo nivel -liquidación por grupo de materias-)
								if($lv_row[$i]['refobjgrpcod']!=''){
									$lv_buffer=''; $lv_sumqty=0; $lv_sumtot=0;
									for($x=$i; $x<count($lv_row); $x++) {
										if($lv_row[$i]['refobjgrpcod']!=$lv_row[$x]['refobjgrpcod'] || $lv_row[$i]['refobjsubgrpcod']!=$lv_row[$x]['refobjsubgrpcod'] ) { break; }
										$lv_buffer .= '<br><a href="#" name="evllnk" '.
																		'data-refobjtyp="'.$lv_row[$x]['refobjtyp'].'" '.
																		'data-refobjcod001="'.$lv_row[$x]['refobjcod001'].'" '.
																		'data-refobjcod002="'.$lv_row[$x]['refobjcod002'].'" '.
																		'data-refobjgrpcod="'.$lv_row[$x]['refobjgrpcod'].'" '.
																		'data-refobjgrptxt="'.$lv_row[$x]['refobjgrptxt'].'" '.
																		'data-refobjsubgrpcod="'.$lv_row[$x]['refobjsubgrpcod'].'" '.
																		'data-refobjsubgrptxt="'.$lv_row[$x]['refobjsubgrptxt'].'" '.
																		'data-edulqdcod="'.$lv_row[$x]['edulqdcod'].'" '.
																		'data-edulqddoccod="'.$lv_row[$x]['edulqddoccod'].'" '.
																		'data-edulqddocqty="'.$lv_row[$x]['edulqddocqty'].'" '.
																		'data-edulqddocprc="'.$lv_row[$x]['edulqddocprc'].'" '.
																		'data-edulqddoctot="'.$lv_row[$x]['edulqddoctot'].'" '.
																		'data-edulqddocdte="'.$lv_row[$x]['edulqddocdte'].'" '.
																		'data-edulqddoctxt="'.$lv_row[$x]['edulqddoctxt'].'" '.
																		'data-edulqddoccodext="'.$lv_row[$x]['edulqddoccodext'].'" '.
																		'data-curcod="'.$lv_row[$x]['curcod'].'" '.
																		'data-eduevlfrm="'.$lv_row[$x]['eduevlfrm'].'" '.
																		'data-eduplncod="'.$lv_row[$x]['eduplncod'].'" '.
																		'data-eduplndtecod="'.$lv_row[$x]['eduplndtecod'].'" '.
																		'>'.$lv_row[$x]['edulqddocdte'].'</a> - '.$lv_row[$x]['edulqddoctxt'];
										$lv_sumqty += $lv_row[$x]['edulqddocqty'];
										$lv_sumtot += $lv_row[$x]['edulqddoctot'];
									}
									echo '<tr class="bg-info hidden" data-refobjgrpcod="'.$lv_row[$i]['refobjgrpcod'].'">'.
												'<td style="padding-left: 40px;"><input type="checkbox" id="opnsrvchk" data-refobjgrpcod="'.$lv_row[$i]['refobjgrpcod'].'" data-edulqddocqty="'.round($lv_sumqty,0).'" data-edulqddocprc="'.$lv_row[$i]['edulqddocprc'].'" data-edulqddoctot="'.$lv_sumtot.'" '.($lv_row[$i]['edulqddoccod']!=0?'checked="checked"':'').'></td>'.
												'<td>'.$lv_row[$i]['refobjsubgrptxt'].'<small>'.$lv_buffer.'</small></td>'.
												'<td class="text-right">'.number_format($lv_sumqty,0,'.',',').'</td>'.
												'<td></td>'.
												'<td class="text-right">'.number_format($lv_sumtot,2,'.',',').'</td>'.
												'</tr>';
									$i = $x-1;
								}
							}
						?>
					</tbody>
				</table>
			</div>

			<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_opnexp">
				<div class="row">
					<div class="col-md-7"></div>
					<label class="control-label col-md-2">Total</label>
					<div class="col-md-3"><?= gethtml('opnexptot','docqty','',$lv_always_disabled); ?></div>
				</div>
				<table class="table table-condensed table-striped">
					<thead><tr><th><input type="checkbox" id="opnexpchkhdr"></th><th>Fecha</th><th>Tipo</th><th>Total</th></tr></thead>
					<tbody>
						<?php	
            	$lv_opnexp = is_array($vew_data)?$vew_data['opnexp']:$vew_data->opnexp;
							foreach ($lv_opnexp as $lv_row) {
								echo '<tr>'.
											'<td><input type="checkbox" id="opnexpchk" data-refobjtyp="'.$lv_row['refobjtyp'].'" data-refobjcod001="'.$lv_row['refobjcod001'].'" data-refobjcod002="'.$lv_row['refobjcod002'].'" data-edulqddoctot="'.$lv_row['edulqddoctot'].'" '.($lv_row['edulqddoccod']!=0?'checked="checked"':'').'></td>'.
											'<td><a href="#" name="explnk" '.
														'data-refobjtyp="'.$lv_row['refobjtyp'].'" '.
														'data-refobjcod001="'.$lv_row['refobjcod001'].'" '.
														'data-refobjcod002="'.$lv_row['refobjcod002'].'" '.
														'data-edulqdcod="'.$lv_row['edulqdcod'].'" '.
														'data-edulqddoccod="'.$lv_row['edulqddoccod'].'" '.
														'data-edulqddocqty="'.$lv_row['edulqddocqty'].'" '.
														'data-edulqddoctot="'.$lv_row['edulqddoctot'].'" '.
                  					'data-edulqddocdte="'.($lv_row['edulqddocdte']!=null?(is_string($lv_row['edulqddocdte'])?$lv_row['edulqddocdte']:$lv_row['edulqddocdte']->format('d/m/Y')):'').'" '.
														'data-edulqddoctxt="'.$lv_row['edulqddoctxt'].'" '.
														'data-curcod="'.$lv_row['curcod'].'" '.											
														'>'.($lv_row['edulqddocdte']!=null?(is_string($lv_row['edulqddocdte'])?$lv_row['edulqddocdte']:$lv_row['edulqddocdte']->format('d/m/Y')):'').'</a></td>'.
											'<td>'.$lv_row['edulqddoctxt'].'</td>'.
											'<td>'.number_format($lv_row['edulqddoctot'],2,',','.').'</td>'.
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
	$("#<?= $lv_sec; ?> a[name='evllnk']").on("click",function(e){
		e.preventDefault();
		if( $(this).data("eduevlfrm")!="" ) {
			tmssLink($(this).data("eduevlfrm"), [{target: "_new_section", post_data: 
				[
					{name:"evlcod", value:$(this).data("refobjcod001")},
					{name:"eduplncod", value:$(this).data("eduplncod")},
					{name:"eduplndtecod", value:$(this).data("eduplndtecod")},
					{name:"stucod", value:$(this).data("refobjsubgrpcod")}
				]
				}] );
		}
	});

	$("#<?= $lv_sec; ?> a[name='explnk']").on("click",function(e){
		e.preventDefault();
		tmssLink("?prg=buyexp&act=03", [{target: "_new_section", post_data: [{name:"buyexpcod", value:$(this).data("refobjcod001")}] }] );
	});

	$("#<?= $lv_sec; ?> #opnsrvtbl a[name='opnsrvgrp']").on("click",function(e){
		e.preventDefault();
		var lv_show = $(this).find("span:first").hasClass("fa-chevron-right");
		if(lv_show) { 
			$(this).find("span:first").removeClass("fa-chevron-right").addClass("fa-chevron-down");
			$("#<?= $lv_sec; ?> #opnsrvtbl tbody tr[data-refobjgrpcod='"+$(this).data("refobjgrpcod")+"']").removeClass("hidden");
		} else {
			$(this).find("span:first").removeClass("fa-chevron-down").addClass("fa-chevron-right");
			$("#<?= $lv_sec; ?> #opnsrvtbl tbody tr[data-refobjgrpcod='"+$(this).data("refobjgrpcod")+"']").addClass("hidden");
		}
	});
	
	
	
	function <?= $lv_sec; ?>_calcTotal() {
		var lv_srvids = "";
		var lv_srvqty = 0;
		var lv_srvtot = 0;
		var lv_srvdoc = [];
		
		var lv_expids = "";
		var lv_expqty = 0;
		var lv_exptot = 0.0;
		var lv_expdoc = [];
		
		$("#<?= $lv_sec; ?> #opnsrvchkgrp").each(function() {
			var lv_qty = 0;
			var lv_tot = 0;
			$("#<?= $lv_sec; ?> #opnsrvchk[data-refobjgrpcod='"+$(this).data("refobjgrpcod")+"']").each(function(){
				lv_srvids += (lv_srvids==""?"":"|")+$(this).data("refobjids");
				var lv_chk=false;
				if($(this).is(":checked")) {
					lv_chk=true;
					lv_qty += $(this).data("edulqddocqty");
					lv_tot += $(this).data("edulqddoctot");
				}
				$(this).parent().parent().find("a[name='evllnk']").each(function(){
					lv_srvdoc.push({ "refobjtyp":$(this).data("refobjtyp"),
												"refobjcod001":$(this).data("refobjcod001"),
												"refobjcod002":$(this).data("refobjcod002"),
												"refobjgrpcod":$(this).data("refobjgrpcod"),
												"refobjgrptxt":$(this).data("refobjgrptxt"),
												"refobjsubgrpcod":$(this).data("refobjsubgrpcod"),
												"refobjsubgrptxt":$(this).data("refobjsubgrptxt"),
												"edulqddoccod":$(this).data("edulqddoccod"),
												"edulqddocqty":$(this).data("edulqddocqty"),
												"edulqddocprc":$(this).data("edulqddocprc"),
												"edulqddoctot":$(this).data("edulqddoctot"),
												"edulqddocdte":$(this).data("edulqddocdte"),
												"edulqddoctxt":$(this).data("edulqddoctxt"),
												"edulqddoccodext":$(this).data("edulqddoccodext"),
												"curcod":$(this).data("curcod"),
												"deleted":(lv_chk==true?"":"X")
											});
				});
			});
			$(this).parent().next().next().text( Number(lv_qty).toFixed(0) );
			$(this).parent().next().next().next().next().text( Number(lv_tot).toFixed(2) );
			$(this).parent().parent().css("font-weight",(lv_qty>0?"bold":"") );
			lv_srvqty += Number(lv_qty);
			lv_srvtot += Number(lv_tot)
		});
		$("#<?= $vew_data['sec']; ?> #opnsrvids").text( JSON.stringify(lv_srvdoc) );
		lv_srvtot = Math.round(lv_srvtot*100)/100;
		lv_srvqty = Math.round(lv_srvqty);
		$("#<?= $lv_sec; ?> #opnsrvtot").prop("value", Number(lv_srvtot).toFixed(2) );
		$("#<?= $lv_sec; ?> #opnsrvqty").prop("value", Number(lv_srvqty).toFixed(0) );
		$("#<?= $lv_sec; ?> .opnsrvbdg").text((lv_srvqty==0?"":Number(lv_srvqty).toFixed(0) ));


		$("#<?= $lv_sec; ?> #opnexpchk").each(function(){
			var lv_chk = false;
			if($(this).is(":checked")) {
				lv_chk=true;
				lv_expids += (lv_expids==""?"":"|")+$(this).data("refobjids");
				lv_expqty += 1;
				lv_exptot += Number($(this).data("edulqddoctot"));
			}
			$(this).parent().parent().find("a[name='explnk']").each(function(){
				lv_expdoc.push({"refobjtyp":$(this).data("refobjtyp"),
											"refobjcod001":$(this).data("refobjcod001"),
											"refobjcod002":$(this).data("refobjcod002"),
											"edulqddoccod":$(this).data("edulqddoccod"),
											"edulqddocqty":$(this).data("edulqddocqty"),
											"edulqddocprc":$(this).data("edulqddocprc"),
											"edulqddoctot":$(this).data("edulqddoctot"),
											"edulqddocdte":$(this).data("edulqddocdte"),
											"edulqddoctxt":$(this).data("edulqddoctxt"),
											"edulqddoccodext":$(this).data("edulqddoccodext"),
											"curcod":$(this).data("curcod"),
											"deleted":(lv_chk==true?"":"X")
										});
			});
		});
		$("#<?= $vew_data['sec']; ?> #opnexpids").text( JSON.stringify(lv_expdoc) );
		lv_exptot = Math.round(lv_exptot*100)/100;
		lv_expqty = Math.round(lv_expqty);
		$("#<?= $lv_sec; ?> #opnexptot").prop("value", Number(lv_exptot).toFixed(2) );
		$("#<?= $lv_sec; ?> #opnexpqty").prop("value", Number(lv_expqty).toFixed(0) );
		$("#<?= $lv_sec; ?> .opnexpbdg").text((lv_expqty==0?"":Number(lv_expqty).toFixed(0) ));

		
		$("#<?= $lv_sec; ?> #edulqdtot").text( Number(lv_srvtot+lv_exptot).toFixed(2) );
	}

	var lv_hdrchk = false;
	$(function(){
		// prestaciones checkbox - posicion
		$("#<?= $lv_sec; ?> #opnsrvchk").on("change", function(e){
			if(lv_hdrchk==false) { <?= $lv_sec; ?>_calcTotal(); }
		});

		// prestaciones checkbox - grupo
		$("#<?= $lv_sec; ?> #opnsrvchkgrp").on("change", function(e){
			e.preventDefault();
			$("#<?= $lv_sec; ?> #opnsrvchk[data-refobjgrpcod='"+$(this).data("refobjgrpcod")+"']").prop("checked", $(this).is(":checked") ); 
			if(lv_hdrchk==false) { <?= $lv_sec; ?>_calcTotal(); }
		});
		
		// prestaciones checkbox - cabecera
		$("#<?= $lv_sec; ?> #opnsrvchkhdr").on("change",function(e){
			e.preventDefault();
			lv_hdrchk = true;
			$("#<?= $lv_sec; ?> #opnsrvchkgrp").prop("checked", $(this).is(":checked") ).trigger("change"); 
			<?= $lv_sec; ?>_calcTotal();
			lv_hdrchk = false;
		});

		// gastos checkbox - cabecera
		$("#<?= $lv_sec; ?> #opnexpchkhdr").on("change",function(e){
			e.preventDefault();
			lv_hdrchk = true;
			$("#<?= $lv_sec; ?> #opnexpchk").prop("checked", $(this).is(":checked") ).trigger("change"); 
			<?= $lv_sec; ?>_calcTotal();
			lv_hdrchk = false;
		});
		
		// gastos checkbox - posicion
		$("#<?= $lv_sec; ?> #opnexpchk").on("change", function(e){
			if(lv_hdrchk==false) { <?= $lv_sec; ?>_calcTotal(); }
		});
		
		<?= $lv_sec; ?>_calcTotal();
	});
	
	tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='11'||$vew_actcod=='12'?'true':'false'); ?>);
</script>
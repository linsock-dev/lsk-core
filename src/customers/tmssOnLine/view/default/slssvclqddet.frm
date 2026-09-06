<?php
	// url del formulario
  $lv_lnk = '';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento */
	$lv_dockey = ''; 
	
	// titulo
	$lv_title = $vew_lang->services;
	
	// módulo y programa
	$lv_mdlcod = 'SLS';
	$lv_prgcod = 'SVL';
		
	// librería de estilos bootstrap
	include_once('_library.frm');

	// accion por default para esta vista
	if ( !isset($vew_actcod) ) { $vew_actcod = '13'; }
	$vew_readonly = ($vew_actcod=='11'||$vew_actcod=='12'?false:true);
	
	
	// verifica si tiene permisos para realizar ajustes
	$lv_edtper = ($vew_readonly && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02') && strtoupper($vew_data->docsts)!='C' ? true : false );
	
	// si no se hace una copia del array, no se puede modificar
	$lo_opnsrv = $vew_data->opnsrv;	
	// foreach para identificar y actualizar las filas nuevas y marcar cuáles son las viejas que hay que eliminar
	foreach( $lo_opnsrv as &$lv_row ){
		
		$lv_row['stkobjtxt'] = (isset($lv_row['stkobjtxt']) && $lv_row['stkobjtxt']!='' ? $lv_row['stkobjtxt'] : $vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'refobjgrptxt'));
		$lv_row['stkmovdocdtecnv'] = (isset($lv_row['stkmovdocdtecnv']) && $lv_row['stkmovdocdtecnv']!='' ? $lv_row['stkmovdocdtecnv'] : $vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'stkmovdocdtecnv'));
		$lv_row['refobjtyptxt'] = (isset($lv_row['refobjtyptxt']) && $lv_row['refobjtyptxt']!='' ? $lv_row['refobjtyptxt'] : $vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'refobjtyptxt'));		
		
		if($lv_row['refobjtyp'] == 'SLS_SVL'){
			$lv_rowid = $lv_row['refobjcod002'];
			foreach ($lo_opnsrv as $key2 => $lv_row2){
				if ($lv_row2['slssvclqddoccod'] == $lv_rowid){
					if($vew_readonly){
						$lv_row['refobjtyp'] = $lv_row2['refobjtyp'];
						$lv_row['stkobjtyp'] = $lv_row2['stkobjtyp'];
						$lv_row['refobjcod001'] = $lv_row2['refobjcod001'];
						$lv_row['refobjcod002'] = $lv_row2['refobjcod002'];
						$lv_row['slssvclqddoccodext'] = $lv_row2['slssvclqddoccodext'];
					}
					$lv_row['matcod'] = $lv_row2['matcod'];
					$lv_row['aju'] = "X";
					unset($lo_opnsrv[$key2]);
					break;
				}
			}
		}
	}
	unset($lv_row);	
?>
<section id="<?= $lv_sec; ?>">
    <?= gethtml('newrows','hidden',''); ?>
		<div class="card">
			<div class="card-header">
				<div class="card-title">
					<?= $lv_title; ?>
					<span class="tmss-card-icon font-weight-bold" id="slssvclqdtot">
						<strong><?= number_format(floatval(0),2,',','.'); ?></strong>
					</span>
				</div>
			</div>
			<div class="card-body tmss-card-body-edt">
        <textarea class="hidden" id="opnsrv" name="opnsrv"><?= json_encode($vew_data->opnsrv, JSON_INVALID_UTF8_SUBSTITUTE); ?></textarea>
				<!--<div id="calc_progress"></div>-->
				<table class="table table-condensed table-hover" id="opnsrvtbl">
					<thead>
						<tr>
							<th width="75"><?= ($vew_readonly?'':'<input type="checkbox" id="opnsrvchkhdr">'); ?></th>
							<th>Descripci&oacute;n</th>
							<th width="100" class="text-right">Cantidad</th>
							<th width="100" class="text-right">D&iacute;as</th>
							<th width="100" class="text-right">Importe</th>
							<th width="100" class="text-right">Total</th>
						</tr>
					</thead>
					<tbody>
						<?php
							$lv_buffer = '';
							$lv_lstgrp = '';
            	$lv_cntgrp = array();
            	$lv_matgrp = array();            	
							foreach( $lo_opnsrv as $lv_row ){
								// grupo (cliente)
								if($lv_lstgrp!=$lv_row['stkobjcod']){
									$lv_buffer .= '<tr name="grp" data-stkobjtxt="'.$lv_row['stkobjtxt'].'" data-stkobjcod="'.$lv_row['stkobjcod'].'">'.
												'<td><a href="#" name="grp" data-stkobjtxt="'.$lv_row['stkobjtxt'].'" data-stkobjcod="'.$lv_row['stkobjcod'].'"><span class="fas fa-chevron-right"></span></a>'.
													($vew_readonly?'':'&nbsp;&nbsp;<input type="checkbox" name="grpchk" data-stkobjtyp="'.$lv_row['stkobjtyp'].'" data-stkobjcod="'.$lv_row['stkobjcod'].'">').
												'</td>'.
												'<td>'.$lv_row['stkobjtxt'].'</td><td class="tmss-bb-0"></td><td class="tmss-bb-0"></td><td class="tmss-bb-0"></td>'.
												'<td class="text-right" name="mattot">'.number_format(0,2,'.',',').'</td>'.
												'</tr>';
									$lv_lstgrp = $lv_row['stkobjcod'];
								}
								
								// subgrupo (contactos)
								if(!isset( $lv_cntgrp[$lv_row['stkobjcod'].'_'.$lv_row['stkcntcod']] )){
									$lv_buffer .= '<tr class="bg-info hidden cntgrp" name="subgrp" data-stkobjtxt="'.$lv_row['stkobjtxt'].'" data-stkobjcod="'.$lv_row['stkobjcod'].'" data-stkcntcod="'.$lv_row['stkcntcod'].'">'.
												'<td class="tmss-pl-25">'.
													'<a href="#" name="subgrp" data-stkobjtxt="'.$lv_row['stkobjtxt'].'" data-stkobjcod="'.$lv_row['stkobjcod'].'" data-stkcntcod="'.$lv_row['stkcntcod'].'"><span class="fas fa-chevron-right"></span></a>'.
													($vew_readonly?'':'&nbsp;&nbsp;<input type="checkbox" name="subgrpchk" data-stkobjtyp="'.$lv_row['stkobjtyp'].'" data-stkobjcod="'.$lv_row['stkobjcod'].'" data-stkcntcod="'.$lv_row['stkcntcod'].'">').
												'</td>'.
												'<td>'.
                    			$lv_row['stkcnttxt'].
													// El botón de realizar un ajuste se muestra si está en readonly, se tienen permisos de edición y no está contabilizado
                    			($lv_edtper ? '<a href="#" name="edtsubgrp" class="pull-right" data-stkobjtxt="'.$lv_row['stkobjtxt'].'" data-stkobjcod="'.$lv_row['stkobjcod'].'" data-stkcntcod="'.$lv_row['stkcntcod'].'"><span class="fas fa-pencil-alt"></span></a>' : '').
                    		'</td><td class="tmss-bb-0"></td><td class="tmss-bb-0"></td><td class="tmss-bb-0"></td>'.
												'<td class="text-right" name="mattot">'.number_format(0,2,'.',',').'</td>'.
												'</tr>';
									$lv_cntgrp[$lv_row['stkobjcod'].'_'.$lv_row['stkcntcod']] = 1;
								}
                
                // subgrupo (materiales)
                // se colocan los materiales en un array y se verifica para evitar que haya dos filas iguales con mismo cliente, contacto y material
								if(!isset($lv_matgrp[ $lv_row['stkobjcod'].'_'.$lv_row['stkcntcod'].'_'.$lv_row['matcod']])){
                     $lv_buffer .= '<tr class="hidden matgrp" name="itmgrp" data-matcod="'.$lv_row['matcod'].'" data-stkobjtxt="'.$lv_row['stkobjtxt'].'" data-stkobjcod="'.$lv_row['stkobjcod'].'" data-stkcntcod="'.$lv_row['stkcntcod'].'">'.
                                        '<td class="tmss-bb-0"></td><td class="tmss-bb-0">'.$lv_row['mattxt'].'</td>'.
                                        '<td class="tmss-bb-0"></td><td class="tmss-bb-0"></td><td class="tmss-bb-0"></td><td class="tmss-bb-0"></td></tr>';
									$lv_matgrp[ $lv_row['stkobjcod'].'_'.$lv_row['stkcntcod'].'_'.$lv_row['matcod']] = 1;
								}

								$lv_buffer .= '<tr class="bg-secondary hidden" name="itmgrp" data-stkobjtxt="'.$lv_row['stkobjtxt'].'" data-stkobjcod="'.$lv_row['stkobjcod'].'" data-stkcntcod="'.$lv_row['stkcntcod'].'">'. //Arma fila de los materiales
										'<td class="tmss-pl-55 tmss-bt-0 tmss-bb-0">'.
											'<input type="checkbox" name="itmchk" class="'.($vew_readonly?'hidden':'').'"'.
												'data-slssvclqddoccod="'.$lv_row['slssvclqddoccod'].'" '.
												'data-stkobjtyp="'.$lv_row['stkobjtyp'].'" '.
												'data-stkobjcod="'.$lv_row['stkobjcod'].'" '.
												'data-stkcntcod="'.$lv_row['stkcntcod'].'" '.
												'data-refobjtyp="'.$lv_row['refobjtyp'].'" '.
												'data-refobjcod001="'.$lv_row['refobjcod001'].'" '.
												'data-refobjcod002="'.$lv_row['refobjcod002'].'" '.
												'data-refobjgrpcod="'.$lv_row['stkobjcod'].'" '.
												'data-stkobjtxt="'.$lv_row['stkobjtxt'].'" '.
												'data-refobjsubgrpcod="'.$lv_row['stkcntcod'].'" '.
												'data-refobjsubgrptxt="'.$lv_row['stkcnttxt'].'" '.
												'data-matcod="'.$lv_row['matcod'].'" '.
												'data-mattxt="'.$lv_row['mattxt'].'" '.
												'data-stkmovdocdtecnv="'.$lv_row['stkmovdocdtecnv'].'" '.
												'data-refobjtyptxt="'.$lv_row['refobjtyptxt'].'" '.
												'data-matqty="'.(isset($lv_row['slssvclqddocqty']) && $lv_row['slssvclqddocqty']!=0 ? $lv_row['slssvclqddocqty'] : (isset($lv_row['matqty']) ? $lv_row['matqty']:1) ).'" '. 
												'data-matday="'.(isset($lv_row['slssvclqddocday']) && $lv_row['slssvclqddocday']!=0 ? $lv_row['slssvclqddocday'] : (isset($lv_row['days']) ? $lv_row['days'] : '')).'" '.
												'data-matprc="'.(isset($lv_row['slssvclqddocprc']) ? $lv_row['slssvclqddocprc'] : (isset($lv_row['svcmatprc']) ? $lv_row['svcmatprc'] : '') ).'"'.
												($lv_row['slssvclqddoccod']!=''?' checked ':'').
												'>'.
										'</td>'.
										'<td class="tmss-bt-0 tmss-bb-0" '.($lv_row['refobjtyp']!='STK_HST'?' ><small><a href="#" name="movlnk" data-refobjtyp="'.$lv_row['refobjtyp'].'" data-refobjcod001="'.$lv_row['refobjcod001'].'">'.$lv_row['stkmovdocdtecnv'].' - '.$lv_row['refobjtyptxt'].'</a>'.(isset($lv_row['aju']) ? ' - AJUSTADO' : '').'</small>':
													' name="movlnk"><small>'.$lv_row['stkmovdocdtecnv'].' - '.$lv_row['refobjtyptxt'].(isset($lv_row['aju']) ? ' - AJUSTADO' : '')).'</small></td>'.
										'<td class="tmss-bt-0 tmss-bb-0 text-right" name="matqty">'.number_format(isset($lv_row['slssvclqddocqty']) && $lv_row['slssvclqddocqty']!="" ? $lv_row['slssvclqddocqty'] : (isset($lv_row['matqty']) ? $lv_row['matqty'] : 1),0,'.',',').'</td>'.
										'<td class="tmss-bt-0 tmss-bb-0 text-right" name="matday">'.number_format(isset($lv_row['slssvclqddocday']) && $lv_row['slssvclqddocday']!=0 ? $lv_row['slssvclqddocday'] : (isset($lv_row['days']) ? $lv_row['days'] : ''),0,'.',',').'</td>'.
										'<td class="tmss-bt-0 tmss-bb-0 text-right" name="matprc">'.number_format(isset($lv_row['slssvclqddocprc']) ? $lv_row['slssvclqddocprc'] : (isset($lv_row['svcmatprc']) ? $lv_row['svcmatprc'] : '') ,2,'.',',').'</td>'.
										'<td class="tmss-bt-0 tmss-bb-0 text-right" name="mattot">'.number_format( ($lv_row['slssvclqddoctot']??0),2,'.',',').'</td>'.
										'</tr>';
							}
							echo $lv_buffer;
						?>
					</tbody>
				</table>
			
			</div> <!-- /card-body -->
		</div> <!-- /card -->
	<script>
		var gv_<?= $lv_sec; ?>_hdrchk = false;
		var gv_<?= $lv_sec; ?>_crntrg = "";
		
		// group - click
		$("#<?= $lv_sec; ?> a[name='grp']").on("click",function(e){ e.preventDefault();
			$("#<?= $lv_sec; ?> tr[name='subgrp']").addClass("hidden");
			$("#<?= $lv_sec; ?> tr[name='itmgrp']").addClass("hidden");
			var lv_show = $(this).find("span:first").hasClass("fa-chevron-right");
			if(lv_show){
				$("#<?= $lv_sec; ?> tr[name='subgrp'][data-stkobjtxt='"+$(this).data("stkobjtxt")+"']").removeClass("hidden");
				$(this).find("span:first").removeClass("fa-chevron-right");
				$(this).find("span:first").addClass("fa-chevron-down");
			} else {
				$("#<?= $lv_sec; ?> tr[name='subgrp'][data-stkobjtxt='"+$(this).data("stkobjtxt")+"']").addClass("hidden");
				$(this).find("span:first").removeClass("fa-chevron-down");			
				$(this).find("span:first").addClass("fa-chevron-right");
			}
		});
		
		// subgroup - click
		$("#<?= $lv_sec; ?> a[name='subgrp']").on("click",function(e){ e.preventDefault();
			var lv_show = $(this).find("span:first").hasClass("fa-chevron-right");
			if(lv_show){
				$("#<?= $lv_sec; ?> tr[name='itmgrp'][data-stkobjtxt='"+$(this).data("stkobjtxt")+"'][data-stkcntcod="+$(this).data("stkcntcod")+"]").removeClass("hidden");
				$(this).find("span:first").removeClass("fa-chevron-right");
				$(this).find("span:first").addClass("fa-chevron-down");
			} else {
				$("#<?= $lv_sec; ?> tr[name='itmgrp'][data-stkobjtxt='"+$(this).data("stkobjtxt")+"'][data-stkcntcod="+$(this).data("stkcntcod")+"]").addClass("hidden");
				$(this).find("span:first").removeClass("fa-chevron-down");			
				$(this).find("span:first").addClass("fa-chevron-right");
			}
		});
		
		// edit subgroup - click
		$("#<?= $lv_sec; ?> a[name='edtsubgrp']").on("click",function(e){ e.preventDefault();
			var lv_pstdat = $("#<?= $vew_data->oldsec; ?>_frm").serializeArray();
			for(var i=lv_pstdat.length-1;i>0;i--){
				if(lv_pstdat[i]["name"]=="opnsrv" || lv_pstdat[i]["name"]=="opnsrvids" || lv_pstdat[i]["name"]=="opnexpids" || lv_pstdat[i]["name"]=="itmchk"){ 
				 lv_pstdat.splice(i,1); 
				}
			}
			lv_pstdat.push({"name":"stkcntcod","value":$(this).data("stkcntcod")});
			tmssCallProcess("?prg=slssvclqd&act=slssvclqdaju", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "Ajustar",
					message: $(data),
					draggable: true,
					closable: false,
					onshow: function(dialog){ dialog.$modalDialog.css("width","90vw"); },
					size: BootstrapDialog.SIZE_WIDE,
					buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialogItself){ dialogItself.close(); } },
										{	label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success",	action: function(dialog){
											
											var lv_rows = [];
											var lv_dat;
											$(dialog.$modalBody).find("input.hidden").each(function(){
												// para cada registro actualizado
												if($(this).data("matstrdte") != undefined || $(this).data("aju") == "X"){
													
													lv_dat = {slssvclqddoccod: $(this).data("slssvclqddoccod"),
																		stkmovdocdtecnv: $(this).data("stkmovdocdtecnv"),
																		slssvclqddoccodext: $(this).data("matcod"),
																		slssvclqddoctxt: $(this).data("mattxt"),
																		slssvclqddocqty:Number($(this).data("matqty")),
																		slssvclqddocday:Number($(this).data("matday")),
																		slssvclqddocprc:Number($(this).data("matprc")),
																		slssvclqddoctot:Number($(this).data("matqty"))*Number($(this).data("matprc"))*Number($(this).data("matday")),
																		refobjgrpcod:$(this).data("refobjgrpcod"),
																		refobjgrptxt:$(this).data("stkobjtxt"),
																		refobjsubgrpcod:$(this).data("refobjsubgrpcod"),
																		refobjsubgrptxt:$(this).data("refobjsubgrptxt"),
																		refobjtyp:$(this).data("refobjtyp"),
																		refobjtyptxt:$(this).data("refobjtyptxt"),
																		refobjcod001:$(this).data("refobjcod001"),
																		refobjcod002:$(this).data("refobjcod002"),
																		slssvclqddocaju:$(this).data("aju"),
																		slssvclqddocstrdte:$(this).data("matstrdte"),
																		slssvclqddocenddte:$(this).data("matenddte"),
																		slssvclqddocmtv:$(this).data("matmtv"),
																		oldrefobjcod002:$(this).data("oldrefobjcod002"),
																		slssvclqddocoldcod:$(this).data("oldrefobjcod")};
													
													if($(this).data("matstrdte") == "" || $(this).data("matenddte") == ""){
														lv_dat["deleted"]="X";  
													}
													lv_rows.push( lv_dat );
												}
											});
											
											var lv_pstdat = [{name:"newrows", value:JSON.stringify(lv_rows)},{name:"slssvclqdcod", value:$("#<?= $vew_data->oldsec; ?>_frm ").find("#slssvclqdcod").val()}];
											tmssCallProcess("?prg=slssvclqd&act=slssvclqdajusve", lv_pstdat, function(data){});
											<?= $vew_data->oldsec; ?>_fnc({action: '99'});
											dialog.close();
										}
									}],
				});
			});
		});
		
		// cambia el check de cabecera según los checks de posiciones
		// lp_prnsel: selector del padre (name itmgrp/subgrp/grp o id de check de cabecera)
		// lp_chldsel: selector del hijo (name itmgrp/subgrp/grp)
		// lp_cmndat: data común entre el check desde que se llama la función y el padre
		function <?= $lv_sec; ?>_changeHeaderCheck(lp_prnsel, lp_chlsel, lp_cmndat){
			// inputs relacionados al padre 
			var lv_input = $("#<?= $lv_sec; ?> #opnsrvtbl "+lp_chlsel+lp_cmndat+" input").length;
			// inputs relacionados al padre marcados
			var lv_inputchk = $("#<?= $lv_sec; ?> #opnsrvtbl "+lp_chlsel+lp_cmndat+" input:checked").length;		
			//Si todos están checkeados se va a chequear al padre
			if(lv_input == lv_inputchk){
				$("#<?= $lv_sec; ?> #opnsrvtbl "+lp_prnsel+lp_cmndat+" input").prop( "checked", true );
			} else {  
			if( $("#<?= $lv_sec; ?> #opnsrvtbl "+lp_prnsel+lp_cmndat+" input").prop( "checked") != false ){
				$("#<?= $lv_sec; ?> #opnsrvtbl "+lp_prnsel+lp_cmndat+" input").prop( "checked", false );
				}
			}
		}  
		
	 
		function <?= $lv_sec; ?>_calcTotal() {
			var lv_grltot = 0;
			var lv_rowtot = 0;

			//var lv_sel = Array();
			$("#<?= $lv_sec; ?> #slssvclqdtot > strong").html( Number(0).toFixed(2).toLocaleString() ); 
			$("#<?= $lv_sec; ?> tr[name=grp] td[name=matqty]").html( Number(0).toFixed(0) ); 
			$("#<?= $lv_sec; ?> tr[name=grp] td[name=mattot]").html( Number(0).toFixed(2) ); 
			$("#<?= $lv_sec; ?> tr[name=subgrp] td[name=matqty]").html( Number(0).toFixed(0) ); 
			$("#<?= $lv_sec; ?> tr[name=subgrp] td[name=mattot]").html( Number(0).toFixed(2) ); 
			
			// obtengo registros marcados
			$("#<?= $lv_sec; ?> input[name=itmchk]:checked").each(function( index ){	
				<?php if($vew_readonly){ ?>
				lv_rowtot = parseFloat($(this).parent().parent().find("td[name=mattot]").html().replace(/,/g, ''));
				<?php } else { ?>
				lv_rowtot = $(this).data("matqty") * $(this).data("matday") * $(this).data("matprc");
				// actualizo total de fila
				$(this).parent().parent().find("td[name=mattot]").html( Number(lv_rowtot).toFixed(2) );
				<?php } ?>
				lv_grltot += lv_rowtot;
			});
			
			// actualizo totales de registros NO seleccionados
			<?php if($vew_readonly){ ?>
			$("#<?= $lv_sec; ?> input[name=itmchk]:not(:checked)").each(function(){
				$(this).parent().parent().find("td[name=mattot]").html( Number(lv_rowtot).toFixed(2) );
			});
			<?php } ?>
			
			// actualizo sub-grupos
			$("#<?= $lv_sec; ?> tr[name=subgrp]").each(function(){
				var lv_tot = 0;
				$("#<?= $lv_sec; ?> tr[name=itmgrp][data-stkobjtxt='"+$(this).data("stkobjtxt")+"'][data-stkobjcod='"+$(this).data("stkobjcod")+"'][data-stkcntcod='"+$(this).data("stkcntcod")+"']").each(function(){
					if($(this).find("input[name=itmchk]:checked").length>0){
						lv_tot += $(this).find("input[name=itmchk]").data("matqty")*$(this).find("input[name=itmchk]").data("matprc")*$(this).find("input[name=itmchk]").data("matday");
					}
				});				
				$(this).find("td[name=mattot]").html( Number(lv_tot).toFixed(2) );
				$(this).data("mattot",lv_tot);
			});
			
			// actualizo grupos
			$("#<?= $lv_sec; ?> tr[name=grp]").each(function(){
				var lv_tot = 0;				
				$("#<?= $lv_sec; ?> tr[name=subgrp][data-stkobjcod='"+$(this).data("stkobjcod")+"']").each(function(){
					lv_tot += $(this).data("mattot");
				});
				$(this).find("td[name=mattot]").html( Number(lv_tot).toFixed(2).toLocaleString() );
			});
			
			$("#<?= $lv_sec; ?> #slssvclqdtot > strong").html( Number(lv_grltot).toFixed(2).toLocaleString() );
		}
		
		

		// header - checkbox
		$("#<?= $lv_sec; ?> #opnsrvchkhdr").on("change", function(e){ e.preventDefault();    
			if( gv_<?= $lv_sec; ?>_hdrchk==false ){
				gv_<?= $lv_sec; ?>_hdrchk = true;
				$("#<?= $lv_sec; ?> input[name=grpchk]").prop("checked", $(this).is(":checked") ); 
				$("#<?= $lv_sec; ?> input[name=subgrpchk]").prop("checked", $(this).is(":checked") ); 
				$("#<?= $lv_sec; ?> input[name=itmchk]").prop("checked", $(this).is(":checked") );
				<?= $lv_sec; ?>_calcTotal();
				gv_<?= $lv_sec; ?>_hdrchk = false;
			}
		});
		
		
		
		// grupo - checkbox
		$("#<?= $lv_sec; ?> input[name=grpchk]").on("change", function(e){ e.preventDefault();
			<?= $lv_sec; ?>_changeHeaderCheck("thead > tr", "tr[name='grp']", "");
			if(gv_<?= $lv_sec; ?>_hdrchk==false){
				gv_<?= $lv_sec; ?>_hdrchk = true;
				$("#<?= $lv_sec; ?> input[name=subgrpchk][data-stkobjtyp="+$(this).data("stkobjtyp")+"][data-stkobjcod="+$(this).data("stkobjcod")+"]").prop("checked", $(this).is(":checked") ); 
				$("#<?= $lv_sec; ?> input[name=itmchk][data-stkobjtyp="+$(this).data("stkobjtyp")+"][data-stkobjcod="+$(this).data("stkobjcod")+"]").prop("checked", $(this).is(":checked") ); 
				<?= $lv_sec; ?>_calcTotal();
				gv_<?= $lv_sec; ?>_hdrchk = false;        
			}
		});
		
		
		
		// subgrupo - checkbox
		$("#<?= $lv_sec; ?> input[name=subgrpchk]").on("change", function(e){ e.preventDefault();
			<?= $lv_sec; ?>_changeHeaderCheck("tr[name='grp']", "tr[name='subgrp']", "[data-stkobjcod='" + $(this).data("stkobjcod") + "']");
			<?= $lv_sec; ?>_changeHeaderCheck("thead > tr", "tr[name='grp']", "");
			if(gv_<?= $lv_sec; ?>_hdrchk==false){
				gv_<?= $lv_sec; ?>_hdrchk = true;
				$("#<?= $lv_sec; ?> input[name=itmchk][data-stkobjtyp="+$(this).data("stkobjtyp")+"][data-stkobjcod="+$(this).data("stkobjcod")+"][data-stkcntcod="+$(this).data("stkcntcod")+"]").prop("checked", $(this).is(":checked") ); 
				<?= $lv_sec; ?>_calcTotal();
				gv_<?= $lv_sec; ?>_hdrchk = false;
			}		
		});
		

		
		// item - checkbox
		$("#<?= $lv_sec; ?> input[name=itmchk]").on("change",function(e){ e.preventDefault();
			<?= $lv_sec; ?>_changeHeaderCheck("tr[name='subgrp']", "tr[name='itmgrp']", "[data-stkobjcod='" + $(this).data("stkobjcod") + "'][data-stkcntcod='" + $(this).data("stkcntcod") + "']");
			<?= $lv_sec; ?>_changeHeaderCheck("tr[name='grp']", "tr[name='subgrp']", "[data-stkobjcod='"+$(this).data("stkobjcod")+"']");
			<?= $lv_sec; ?>_changeHeaderCheck("thead > tr", "tr[name='grp']", "");
			if(gv_<?= $lv_sec; ?>_hdrchk==false){
				$("#<?= $lv_sec; ?> #opnsrvchkgrp").prop("checked", $(this).is(":checked") ); //.trigger("change"); 
				<?= $lv_sec; ?>_calcTotal();
			}
		});

		
		// link - documento
		$("#<?= $lv_sec; ?> a[name='movlnk']").on("click",function(e){ e.preventDefault();
			var lv_mdlcod = $(this).data("refobjtyp").split("_")[0];
			var lv_prgcod = $(this).data("refobjtyp").split("_")[1];
			tmssLink("?prg=stkmovdoc&act=03&prm_mdlcod="+lv_mdlcod+"&prm_prgcod="+lv_prgcod+"&prm_stkmovdoccod="+$(this).data("refobjcod001")+"&prm_objtyp="+$(this).data("refobjtyp"), [{target: "_new_section", post_data: [{name:"stkmovdoccod", value:$(this).data("stkmovdoccod")},{name:"objtyp", value:$(this).data("objtyp")}] }] );
		});
		
		
		
		$(function(){
			// actualizo checkboxs de sub-grupos
			$("#<?= $lv_sec; ?> tr[name=subgrp]").each(function(){
				<?= $lv_sec; ?>_changeHeaderCheck("tr[name='subgrp']", "tr[name='itmgrp']", "[data-stkobjcod='"+$(this).data("stkobjcod")+"'][data-stkcntcod='"+$(this).data("stkcntcod")+"']");
			});
			
			// actualizo checkboxs de grupos
			$("#<?= $lv_sec; ?> tr[name=grp]").each(function(){
				<?= $lv_sec; ?>_changeHeaderCheck("tr[name='grp']", "tr[name='subgrp']", "[data-stkobjcod='"+$(this).data("stkobjcod")+"']");
			});
			
			// actualizo checkboxs general
			$("#<?= $lv_sec; ?> thead tr").each(function(){
				<?= $lv_sec; ?>_changeHeaderCheck("thead > tr", "tr[name='grp']", "");
			});

			<?= $lv_sec; ?>_calcTotal();
		});
		
		tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='11'||$vew_actcod=='12'?'true':'false'); ?>);
	</script>
</section>
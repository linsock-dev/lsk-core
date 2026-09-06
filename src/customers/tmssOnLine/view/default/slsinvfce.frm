<?php
	// url del formulario 
  $lv_lnk = "?prg=slsinvfce";

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = ''; 

	// titulo 
	$lv_title = $vew_lang->invoice;
	
	// módulo y programa 
	$lv_mdlcod = 'SLS';
	$lv_prgcod = 'FCE';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');

	// Botones por vista 
	$vew_tbl['sveL'] = array('per'=>false);
  $vew_tbl['sveR'] = array('per'=>false);
	$vew_tbl['modL'] = array('per'=>false);	
	$vew_tbl['modR'] = array('per'=>false);
	$vew_tbl['canc'] = array('per'=>false);
	$vew_tbl['new'] = array('per'=>false);
	$vew_tbl['cpy'] = array('per'=>false);
	$vew_tbl['sendL'] = array('pos'=>'L','per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01'), 'ttl'=>$vew_lang->send, 'id'=>'btnsend','icn'=>'fas fa-satellite-dish', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'acc'=>'');
	$vew_tbl['sendD'] = array('pos'=>'D','per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01'), 'ttl'=>$vew_lang->send, 'id'=>'btnsend','icn'=>'fas fa-satellite-dish', 'css'=>'tmss-Opt tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn', 'acc'=>'');
	$vew_tbl['askD'] = array('pos'=>'D','per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01'), 'ttl'=>'Consultas AFIP', 'id'=>'btnask','icn'=>'fas fa-question', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'acc'=>'');
	$vew_tbl['removeL'] = array('pos'=>'L','per'=>true,'ttl'=>'Anular','id'=>'btnremove','icn'=>'fas fa-file-circle-xmark','css'=>'btn btn-danger navbar-btn tmss-navbar-btn tmss-desk-btn tmssAlwaysEnabled tmssHiddeOnEdit','acc' =>'');
	$vew_tbl['removeD'] = array('pos'=>'D','per'=>true,'ttl'=>'Anular','id'=>'btnremove','icn'=>'fas fa-file-circle-xmark','css'=>'tmss-Opt tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn', 'acc'=>'');
  $vew_tbl['delR'] = array('pos'=>'D','per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04'), 'ttl'=>$vew_lang->delete, 'id'=>'btndel','icn'=>'fas fa-trash-alt', 'css'=>'tmss-Opt tmssAlwaysEnabled tmssHiddeOnEdit', 'acc'=>'');
	$vew_tbl['fltR'] = array('pos'=>'R','per'=>true, 'ttl'=>'', 'id'=>'btnflt','icn'=>'fas fa-filter', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'acc'=>'');
	$vew_tbl['delsep'] = array('per'=>false);
	$vew_tbl['del'] = array('per'=>false);
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<!--navbar-->
	<?php include('grldocfrmtlb.frm'); ?>
  <div>
		<table class="table table-condensed table-bordered" id="tblfce">
			<thead>
				<tr>
					<?php	if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01')){?>
						<th><input type='checkbox' id='checkbox_all'></th>
					<?php } ?>
					<th><?= $vew_lang->ID;?></th>
					<th><?= $vew_lang->date;?></th>
					<th><?= $vew_lang->type;?></th>
					<th><?= $vew_lang->PointOfSales;?></th>
					<th><?= $vew_lang->code;?></th>
					<th><?= $vew_lang->number;?></th>
					<th><?= $vew_lang->authorization;?></th>
					<th><?= $vew_lang->duedate;?></th>
					<th><?= $vew_lang->status;?></th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
    <div class="hidden" id="ask_div">
      <div class="row">
        <div class="col-xs-6">
          <select class="form-control" id="ask_select">
            <option value="FEDummy">FEDummy</option>
            <option value="FECompUltimoAutorizado">FECompUltimoAutorizado</option>
            <option value="FECompConsultar">FECompConsultar</option>
            <option value="FEParamGetTiposCbte">FEParamGetTiposCbte</option>
            <option value="FEParamGetTiposConcepto">FEParamGetTiposConcepto</option>
            <option value="FEParamGetTiposDoc">FEParamGetTiposDoc</option>
            <option value="FEParamGetTiposIva">FEParamGetTiposIva</option>
            <option value="FEParamGetTiposMonedas">FEParamGetTiposMonedas</option>
            <option value="FEParamGetTiposOpcional">FEParamGetTiposOpcional</option>
            <option value="FEParamGetTiposTributos">FEParamGetTiposTributos</option>
            <option value="FEParamGetPtosVenta">FEParamGetPtosVenta</option>
            <option value="FEParamGetCotizacion">FEParamGetCotizacion</option>
          </select>
        </div>
        <div class="col-xs-2 hidden" id="ask_ptoVta_d"><input class="form-control" placeholder="PtoVta" id="ask_ptoVta"></div>
        <div class="col-xs-2 hidden" id="ask_cbteTipo_d"><input class="form-control" placeholder="CbteTipo" id="ask_cbteTipo"></div>
        <div class="col-xs-2 hidden" id="ask_cbteNro_d"><input class="form-control" placeholder="CbteNro" id="ask_cbteNro"></div>
        <div class="col-xs-2 hidden" id="ask_monId_d"><input class="form-control" placeholder="monId" id="ask_monId"></div>
      </div>
      <div class="row">
        <div class="col-xs-12">
        	<pre id="ask_response_raw"></pre>
        </div>
      </div>
    </div>
  </div>
	<script>
		var gv_<?= $lv_sec; ?>_flt = [
			{'fldttl': '<?= $vew_lang->ID; ?>', 'fldcod': 'i.slsinvcod', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
			{'fldttl': '<?= $vew_lang->date; ?>', 'fldcod': 'slsinvdtecnv', 'fldtyp': 'DATE', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
			{'fldttl': '<?= $vew_lang->type; ?>', 'fldcod': 'dc.sysdocclstxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
			{'fldttl': '<?= $vew_lang->PointOfSales; ?>', 'fldcod': 'sp.slsposcodext', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
			{'fldttl': '<?= $vew_lang->code; ?>', 'fldcod': 'fe.slsinvfcecodext', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
			{'fldttl': '<?= $vew_lang->number; ?>', 'fldcod': 'fe.slsinvfcecodext', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
			{'fldttl': '<?= $vew_lang->status; ?>', 'fldcod': 'docststxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''}
			];
		
		
		// FILTRO
		$("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
			tmssFilterShowDialog(gv_<?= $lv_sec; ?>_flt,<?= $lv_sec; ?>_GridRefresh);
		});
		
		
		// CHECK ALL
		$("#<?= $lv_sec; ?> #checkbox_all").on("click",function(e){
    	$("#<?= $lv_sec; ?> input:checkbox").not(this).prop("checked", this.checked);
		});
		
		
		// GRID REFRESH
		function <?= $lv_sec; ?>_GridRefresh(lp_flt) {
			var lv_fltint;
			if(lp_flt!=null){
				lv_fltint = tmssFilterParseToInternal(lp_flt);
				gv_<?= $lv_sec; ?>_flt = lp_flt;
				$("#<?= $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
			} else {
				lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
			}
			if(lv_fltint["maxrec"]==""){lv_fltint["maxrec"]="100";}
			tmssCallProcess("?prg=slsinvfce&act=08", [{name:"vewmaxrec", value:lv_fltint["maxrec"]}, {name:"vewfldflt", value:lv_fltint["fltstr"]}], function(data){
				var lv_buffer="";
				for (var i=0;i<data.length;i++) {
					var lv_tr_style = "";
					switch(data[i].docsts) {
					 case "R": lv_tr_style = "class='bg-danger'"; break;
					 case "O": lv_tr_style = "class='bg-warning'"; break;
					 case "A": lv_tr_style = "class='bg-success'"; break;
					}
					lv_checkbox = (data[i].docsts != "A" && data[i].docsts != "O" && data[i].docsts != "N")? "<input type='checkbox' class='checkbox' value='"+data[i].slsinvcod+"'>" : "";
					lv_slsinvfcelog = data[i].slsinvfcelog == null ? '' : (data[i].slsinvfcelog).replace(/##/g,"<br>");
					lv_state = 	(data[i].docsts == null ? "" :
											(data[i].docsts == "A" ? "<i class='fas fa-check' title='Aprobado'></i>" : 
											(data[i].docsts == "O" ? "<i class='fas fa-check-square' title='Observado'></i>" : 
                      (data[i].docsts == "N" ? "<i class='fas' title='Anulado'></i>" : 
											(data[i].docsts == "R" ? "<i class='fas fa-times' title='Rechazado'></i>" : 
											(data[i].docsts == "P" ? "<i class='fas' title='Pendiente'></i>" : 
											(data[i].docsts == "E" ? "<i class='fas fa-cogs' title='En Proceso'></i>" : "")))))));
					data[i].slsinvfceautnum = data[i].slsinvfceautnum == "" ? null :  data[i].slsinvfceautnum;

					lv_buffer +="<tr "+lv_tr_style+">"
										<?php	if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01')){?>
										+"<td>"+lv_checkbox+"</td>"
										<?php } ?>
										+"<td><a href='#' name='slsinv' data-slsinvcod='"+data[i].slsinvcod+"' data-objtyp='"+data[i].objtyp+"'>"+data[i].slsinvcod+"</a></td>"
										+"<td>"+(data[i].slsinvdtecnv == null ? "" : data[i].slsinvdtecnv) +"</td>"
										+"<td>"+(data[i].sysdocclstxt == null ? "" : data[i].sysdocclstxt) +"</td>"
										+"<td>"+(data[i].slsposcodext == null ? "" : data[i].slsposcodext) +"</td>"
										+"<td>"+(data[i].slsinvfceatr == null ? "" : $("<div>"+data[i].slsinvfceatr+"</div>").find("argltrcodext").text() ) +"</td>"
										+"<td>"+(data[i].slsinvfcecodext == null ? "" : data[i].slsinvfcecodext) +"</td>"
										+"<td>"+(data[i].slsinvfceautcodext == null ? "" : data[i].slsinvfceautcodext) +"</td>"
										+"<td>"+(data[i].slsinvfceautduedtecnv == null ? "" : data[i].slsinvfceautduedtecnv) +"</td>"
										+"<td name='slsinvlog' data-slsinvcod='"+data[i].slsinvcod+"' class='text-center'>"+lv_state+"</td>"
										+"</tr>";
				}
				$("#<?= $lv_sec; ?> #tblfce tbody").html(lv_buffer);
				
				// INVOICE
				$("#<?= $lv_sec; ?> #tblfce tbody tr a[name=slsinv]").on("click",function(e){ e.preventDefault();
					var lv_objtyp = $(this).data("objtyp").split("_");
					tmssLink("?prg=slsinv&act=03&prm_mdlcod="+lv_objtyp[0]+"&prm_prgcod="+lv_objtyp[1], [{target: "_new_section", post_data: [{name:"slsinvcod", value:$(this).data("slsinvcod")}] }] );
				});
				
				// LOG
				$("#<?= $lv_sec; ?> #tblfce tbody tr td[name=slsinvlog]").on("click",function(e){ e.preventDefault();
					tmssCallProcess("?prg=slsinvfce&act=showLog", [{name:"slsinvcod",value:$(this).data("slsinvcod")}], function(data){
						BootstrapDialog.show({
							size: BootstrapDialog.SIZE_WIDE,
							title: "<?= $vew_lang->log; ?>",
							message: $(data)
						});
					});
				});
				
			});
		}
		
		
		// ENVIAR
		$("#<?= $lv_sec; ?> #btnsend").on("click",function(e){ e.preventDefault();
			var lv_proc = [];
			$("#<?= $lv_sec; ?> #tblfce tbody input:checkbox:checked").each(function() {
				lv_proc.push($(this).prop("value"));
			});
			if(lv_proc.length<=0){ toastr.warning("Debe seleccionar al menos un registo para enviar"); return; }
			tmssCallProcess("?prg=slsinvfce&act=showSlsInvFce", [{name:"slsinvcod",value:JSON.stringify(lv_proc)},{name: "showlog", value: 0}], function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->send; ?>", 
					message: $(data),
					type: BootstrapDialog.TYPE_PRIMARY,
					onhidden: function(dialog){ <?= $lv_sec; ?>_GridRefresh( gv_<?= $lv_sec; ?>_flt ); }
				});
			});
		});
		
		
		// BORRAR
		$("#<?= $lv_sec; ?> #btndel").on("click",function(e){ e.preventDefault();
			var lv_proc = [];
			$("#<?= $lv_sec; ?> #tblfce tbody input:checkbox:checked").each(function() {
				lv_proc.push($(this).prop("value"));
			});
			if(lv_proc.length<=0){ toastr.warning("Debe seleccionar al menos un registo para borrar"); return; }
			BootstrapDialog.show({
				title: "<?= $vew_lang->delete; ?>",
				message: "Est&aacute; seguro que desea borrar las facturas electr&oacute;nicas: "+JSON.stringify(lv_proc),
				buttons: [{label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialog){ dialog.close(); }},
									{label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success", action: function(dialog) {
										tmssCallProcess("?prg=slsinvfce&act=04", [{name:"slsinvcod",value:JSON.stringify(lv_proc)}], function(data){ 
											<?= $lv_sec; ?>_GridRefresh(gv_<?= $lv_sec; ?>_flt); 
										});
										dialog.close();
									}}]
			});
		});		
    
    
    // QUITAR
		$("#<?= $lv_sec; ?> #btnremove").on("click",function(e){ e.preventDefault();
			var lv_proc = [];
			$("#<?= $lv_sec; ?> #tblfce tbody input:checkbox:checked").each(function() {
				lv_proc.push($(this).prop("value"));
			});
			if(lv_proc.length<=0){ toastr.warning("Debe seleccionar al menos un registo para quitar"); return; }
			BootstrapDialog.show({
				title: "Anular",
				message: "Est&aacute; seguro que desea anular las facturas electr&oacute;nicas: "+JSON.stringify(lv_proc),
				buttons: [{label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialog){ dialog.close(); }},
									{label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success", action: function(dialog) {
										tmssCallProcess("?prg=slsinvfce&act=05", [{name:"slsinvcod",value:JSON.stringify(lv_proc)}], function(data){ 
											<?= $lv_sec; ?>_GridRefresh(gv_<?= $lv_sec; ?>_flt); 
										});
										dialog.close();
									}}]
			});
		});		
		
		
		// CONSULTA AFIP
		$("#<?= $lv_sec; ?> #btnask").on("click",function(e){ e.preventDefault();
			BootstrapDialog.show({
				title: "Consultas AFIP",
				message: $("#<?= $lv_sec; ?> #ask_div").clone().removeClass("hidden"),
				buttons: [{label: "Cerrar", action: function(dialog) { dialog.close(); } },
									{label: "Enviar", cssClass: "btn-success", action: function(dialog) {
										var lv_method 		= dialog.$modalBody.find("#ask_select option:selected").val();
										var lv_ptoVta 	= (lv_method=="FECompConsultar" || lv_method=="FECompUltimoAutorizado" ? dialog.$modalBody.find("#ask_ptoVta").val() : "" );
										var lv_cbteTipo = (lv_method=="FECompConsultar" || lv_method=="FECompUltimoAutorizado" ? dialog.$modalBody.find("#ask_cbteTipo").val() : "" );
										var lv_cbteNro 	= (lv_method=="FECompConsultar" ? dialog.$modalBody.find("#ask_cbteNro").val() : "" );
										var lv_monId 		= (lv_method=="FEParamGetCotizacion" ? dialog.$modalBody.find("#ask_monId").val() : "" );
										var lv_pstdat = {"method":lv_method, "ptoVta":lv_ptoVta, "cbteTipo":lv_cbteTipo, "cbteNro":lv_cbteNro, "monId":lv_monId};
										tmssCallProcess( "?prg=slsinvfce&act=consultAfip", lv_pstdat, function(data){
											var lv_dat;
											if(typeof data=="object"){
												lv_dat = data;
											} else {
												try { lv_dat = JSON.parse(data); } catch(e){}
											}
											if (typeof lv_dat==="object" && lv_dat!==null) {
												dialog.$modalBody.find("#ask_response_raw").text(JSON.stringify(lv_dat, null, "  "));
											} else {
												dialog.$modalBody.find("#ask_response_raw").text(data);
											}
										});
                }
            }],
        onshow: function(dialog){
          dialog.$modalBody.find("[readonly]").attr("readonly", false);
        },
				onshown: function(dialog){
					dialog.$modalBody.find("#ask_select").on("change",function(e){ e.preventDefault();
						var lv_cnt = $(this).parent().parent();
						var lv_method = $(this).find("option:selected").val();
						if(lv_method == "FECompConsultar" ){
							$(lv_cnt).find("#ask_ptoVta_d").removeClass("hidden");
							$(lv_cnt).find("#ask_cbteTipo_d").removeClass("hidden");
							$(lv_cnt).find("#ask_cbteNro_d").removeClass("hidden");
							$(lv_cnt).find("#ask_monId_d").addClass("hidden");
						}else if(lv_method == "FECompUltimoAutorizado"){
							$(lv_cnt).find("#ask_ptoVta_d").removeClass("hidden");
							$(lv_cnt).find("#ask_cbteTipo_d").removeClass("hidden");
							$(lv_cnt).find("#ask_cbteNro_d").addClass("hidden");
							$(lv_cnt).find("#ask_monId_d").addClass("hidden");
						}else if(lv_method == "FEParamGetCotizacion"){
							$(lv_cnt).find("#ask_ptoVta_d").addClass("hidden");
							$(lv_cnt).find("#ask_cbteTipo_d").addClass("hidden");
							$(lv_cnt).find("#ask_cbteNro_d").addClass("hidden");
							$(lv_cnt).find("#ask_monId_d").removeClass("hidden");
						}else{
							$(lv_cnt).find("#ask_ptoVta_d").addClass("hidden");
							$(lv_cnt).find("#ask_cbteTipo_d").addClass("hidden");
							$(lv_cnt).find("#ask_cbteNro_d").addClass("hidden");
							$(lv_cnt).find("#ask_monId_d").addClass("hidden");
						}
					})
					dialog.$modalBody.find("#ask_select").trigger("change");
				}
			});
		});
		
		<?= $lv_sec; ?>_GridRefresh();
  </script>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
      if (lp_prm['action']=='99') {
				<?= $lv_sec; ?>_GridRefresh();
				toastr.success("Actualizado.");
			}
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
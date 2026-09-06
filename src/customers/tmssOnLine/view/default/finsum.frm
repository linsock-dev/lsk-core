<?php
	// url del formulario
  $lv_lnk = '?prg=finsum&prm_finsumcod='.$vew_data->finsumcod;
 
	// campos requeridos
	$vew_input->RequiredFields( array('docsts') );

	// clave del documento
	$lv_dockey = $vew_data->finsumcod;

	// titulo
	$lv_title = $vew_lang->summary;

	// módulo y programa
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'SUM';
	
	// librería de estilos bootstrap
	include_once('_library.frm');

  $vew_tbl['payL'] = array('pos'=>'L','per'=> $vew_sec->hasPermission('TSR','TIN','01'),'ttl'=>'Cargar Pago','icn'=>'far fa-money-bill','css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled btn-success tmss-desk-btn','id'=>'btnpayL','acc'=>'');
  $vew_tbl['payR'] = array('pos'=>'R','per'=> $vew_sec->hasPermission('TSR','TIN','01'),'ttl'=>'Cargar Pago','icn'=>'far fa-money-bill','css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled btn-success tmss-mob-btn','id'=>'btnpayR','acc'=>'');
	$vew_tbl['togDocR'] = array('pos'=>'R','per'=> true,'ttl'=>'','icn'=>'far fa-file-check','css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled btn-success tmss-desk-btn','id'=>'btntogdocR','acc'=>'', 'tooltip'=>'Mostrar/ocultar documentos con saldo 0.');
  $vew_tbl['fltR'] = array('pos'=>'R','per'=> true,'ttl'=>'','icn'=>'fas fa-filter','css'=>'btn  navbar-btn tmss-navbar-btn tmssAlwaysEnabled','id'=>'btnflt','acc'=>'');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('curcod', 'hidden', $vew_data->curcod); ?>
		<?= gethtml('finsumtot','hidden',$vew_data->finsumtot); ?>
    <?= gethtml('finsumflt','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
			<div class="tab-content tmss-tab-content">	
        <!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="card"> 
						<div class="card-header"><div class="card-title"><?= $vew_data->srcobjtxt ?><span class="tmss-card-icon"><?= '<b><span id="slsordtotlbl">'.number_format(floatval($vew_data->finsumtot),2).'</span></b> '.strtolower($vew_data->curcod); ?></span></div></div>
						<div class="card-body">
							<table class="table" id="finsumdoctbl">
								<thead> 
									<tr>
										<th width="10"></th>
										<th><?= $vew_lang->voucher; ?></th>
										<th><?= $vew_lang->reference; ?></th>
										<th width="120"><?= $vew_lang->date; ?></th>
										<th width="120"><?= $vew_lang->duedate; ?></th>
										<th width="120" class="text-right"><?= $vew_lang->amount; ?></th>
										<th width="120" class="text-right"><?= $vew_lang->balance; ?></th>
									</tr>
								</thead>
								<tbody></tbody>
							</table>
						</div>
					</div> <!-- /card -->
        </div> <!-- /tab-pane -->
      </div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <script>
	$("#<?= $lv_sec; ?> #btnpayL, #<?= $lv_sec; ?> #btnpayR").on("click",function(e){ e.preventDefault();
		tmssLink("?prg=tsrmovdoc&act=01&prm_objtyp=tsr_tin&prm_mdlcod=tsr&prm_prgcod=tin",[{post_data: [{name:"srcobjcod",value:"<?= $vew_data->srcobjcod; ?>"},{name:"srcobjtxt",value:"<?= $vew_data->srcobjtxt; ?>"}], target: "_new_section"}]);
	});
  </script>
  <script>	
	$(function(){
		// carga inicial de registros
		<?= $lv_sec; ?>_getList( gv_<?= $lv_sec; ?>_flt,true);
	});
	
  // filtro - boton
	$("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
		tmssFilterShowDialog(gv_<?= $lv_sec; ?>_flt,<?= $lv_sec; ?>_getList);
	});
  
  // filtro - parametros  
	var gv_<?= $lv_sec; ?>_flt = [
		{"fldttl": "<?= $vew_lang->voucher; ?>", "fldcod": "fd.docobjtyp","fldtyp": "TEXT", "flttyp": "LIKE", "fldvalstr": "", "fldvalend": ""},
    {"fldttl": "<?= $vew_lang->date; ?>", "fldcod": "fd.docobjdte","fldtyp": "DATE", "flttyp": "LIKE", "fldvalstr": "", "fldvalend": ""},
    {"fldttl": "<?= $vew_lang->duedate; ?>", "fldcod": "fd.docobjduedte","fldtyp": "DATE", "flttyp": "LIKE", "fldvalstr": "", "fldvalend": ""},
    {"fldttl": "<?= $vew_lang->amount; ?>", "fldcod": "fd.finsumdoctot","fldtyp": "NUMBER", "flttyp": "LIKE", "fldvalstr": "", "fldvalend": ""},
    {"fldttl": "<?= $vew_lang->balance; ?>", "fldcod": "fd.finsumdoctotrst","fldtyp": "NUMBER", "flttyp": "LIKE", "fldvalstr": "", "fldvalend": ""},
	];
    
	//Condiciones del filtro
	function <?= $lv_sec; ?>_getList(lp_flt,lp_vew=false){		
		var lv_fltint;
		if(lp_flt!=null){
			lv_fltint = tmssFilterParseToInternal(lp_flt);
			gv_<?= $lv_sec; ?>_flt = lp_flt;
			$("#<?= $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
		} else {
			lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
		}
		if( lv_fltint["maxrec"]=="" ){ lv_fltint["maxrec"]="100"; }
		
		var lv_pstdat =[{name:"finsumcod", value:"<?= $vew_data->finsumcod ?>"},
										{name:"vewmaxrec", value: lv_fltint["maxrec"] }, 
										{name:"vewfldflt", value: lv_fltint["fltstr"] }];
		tmssCallProcess("?prg=finsum&act=18", lv_pstdat, function(data){
			var lv_buffer="";
			var lv_key = "";
			var lv_keyimp="";
			var lv_vou="";
			var lv_ttl="";
			var lv_vouimp="";
			var lv_trcnthid=0;
			
			// recorro todos los comprobantes
      var lv_fac_arr = [];
      var lv_mov_arr = [];
			for (var i = 0; i < data.data.length; i++) {
				var lv_row = data.data[i];
				switch( lv_row.docobjtyp ) {
					case 'SLS_INV': lv_vou = "FC"; lv_ttl="FACTURA"; break;
					case 'SLS_CRE': lv_vou = "NC"; lv_ttl="NOTA DE CREDITO"; break;
					case 'SLS_DEB': lv_vou = "ND"; lv_ttl="NOTA DE DEBITO"; break;
					case 'BUY_INV': lv_vou = "FC"; lv_ttl="FACTURA"; break;
					case 'BUY_CRE': lv_vou = "NC"; lv_ttl="NOTA DE CREDITO"; break;
					case 'BUY_DEB': lv_vou = "ND"; lv_ttl="NOTA DE DEBITO"; break;
					case 'TSR_TIN': lv_vou = "CB"; lv_ttl="COBRANZA"; break;
					case 'TSR_TOU': lv_vou = "PY"; lv_ttl="PAGO"; break;
				}
        
        lv_row['type'] = lv_vou;

				// calculo la cantidad de dias de vencido el comprobante
				lv_days = 0;
				if(lv_row.finsumdoctotrst>0){
					lv_duedte = moment( lv_row.docobjduedte );
					lv_nowdte = moment();
					lv_days = lv_duedte.diff( lv_nowdte, "days");					
				}
				
				// armo registro de comprobante
        if (lv_vou == 'FC'){
        	lv_fac_arr.push(lv_row);  
        }else if (lv_vou == 'CB'){
          lv_mov_arr.push(lv_row);
        }
      }
      
      for (var i = 0; i < lv_fac_arr.length; i++) {
        lv_row = lv_fac_arr[i];
        lv_key = lv_row.impobjtyp+"_"+lv_row.impobjcod;
        lv_obj = lv_row.docobjtyp+"_"+lv_row.docobjcod;
        lv_row.finsumdoctot = lv_row.finsumdoctot * (lv_row.docobjtyp=="TSR_TIN" || lv_row.docobjtyp=="TST_TOU" ? -1 : 1 );
        debugger;
        lv_buffer ="<tr data-key='"+lv_key+"' data-obj='"+lv_obj+"' class='"+(lv_key==lv_obj?"":"bg-info")+"' data-objcod="+lv_row.docobjcod+" id=docrow>"
                  +"<td class='fas fa-chevron-right' name='lnkgrp'></td>"
                  +"<td><a href='#' data-toggle='tooltip' data-placement='right' title='"+lv_ttl+"' name='lnkdoc'  data-docobjtyp='"+lv_row.docobjtyp+"' data-docobjcod='"+lv_row.docobjcod+"' >"+lv_row.type+" "+(lv_row.docobjcodext==null?lv_row.docobjcod:lv_row.docobjcodext)+"</a></td>"
                  +"<td>"+lv_row.refobjtxt+"</td>"
                  +"<td>"+(lv_row.docobjdte!=null ? moment(lv_row.docobjdte.date).format("DD/MM/YYYY"):"")+"</td>"
                  +"<td "+(lv_days<0?"class='text-danger'":"")+">"+(lv_row.docobjduedte!=null ? moment(lv_row.docobjduedte.date).format("DD.MMM")+(lv_days<0?" ("+lv_days.toString()+")":""):"")+"</td>"
                  +"<td class='text-right'>"+parseFloat(lv_row.finsumdoctot).toLocaleString()+"</td>"
                  +"<td class='text-right' id='finbal'>"+(lv_row.docobjtyp==lv_row.impobjtyp && lv_row.docobjcod==lv_row.impobjcod ? parseFloat(lv_row.finsumdoctotrst).toLocaleString() : "" )+"</td>"
                  +"</tr>";
        $(lv_buffer).appendTo( $("#<?= $lv_sec; ?> tbody") );
        for (var c = 0; c < lv_mov_arr.length; c++) {
          var lv_mov_row = lv_mov_arr[c];
          if (lv_mov_arr[c].impobjcod == lv_fac_arr[i].docobjcod){
            lv_key = lv_mov_row.impobjtyp+"_"+lv_mov_row.impobjcod;
            lv_obj = lv_mov_row.docobjtyp+"_"+lv_mov_row.docobjcod;
            lv_mov_row.finsumdoctot = lv_mov_row.finsumdoctot * (lv_mov_row.docobjtyp=="TSR_TIN" || lv_mov_row.docobjtyp=="TST_TOU" ? -1 : 1 );
            lv_buffer ="<tr data-key='"+lv_key+"' data-obj='"+lv_obj+"' class='"+(lv_key==lv_obj?"":"bg-info")+" hidden' data-srccod="+lv_row.docobjcod+" id='movrow'>"
                      +"<td name='lnkgrp'></td>"
                      +"<td><a href='#' data-toggle='tooltip' data-placement='right' title='"+lv_ttl+"' name='lnkdoc'  data-docobjtyp='"+lv_mov_row.docobjtyp+"' data-docobjcod='"+lv_mov_row.docobjcod+"' >"+lv_mov_row.type+" "+(lv_mov_row.docobjcodext==null?lv_mov_row.docobjcod:lv_mov_row.docobjcodext)+"</a></td>"
                      +"<td>"+lv_mov_row.refobjtxt+"</td>"
                      +"<td>"+(lv_mov_row.docobjdte!=null ? moment(lv_mov_row.docobjdte.date).format("DD/MM/YYYY"):"")+"</td>"
                      +"<td "+(lv_days<0?"class='text-danger'":"")+">"+(lv_mov_row.docobjduedte!=null ? moment(lv_mov_row.docobjduedte.date).format("DD.MMM")+(lv_days<0?" ("+lv_days.toString()+")":""):"")+"</td>"
                      +"<td class='text-right'>"+parseFloat(lv_mov_row.finsumdoctot).toLocaleString()+"</td>"
                      +"<td class='text-right'>"+(lv_mov_row.docobjtyp==lv_mov_row.impobjtyp && lv_mov_row.docobjcod==lv_mov_row.impobjcod ? parseFloat(lv_mov_row.finsumdoctotrst).toLocaleString() : "" )+"</td>"
                      +"</tr>";
            $(lv_buffer).appendTo( $("#<?= $lv_sec; ?> tbody") );
          }
        }
			}
			
			//cantidad de registros
			if(lp_vew){
				lv_buffer="<span class='pagination-info'>Registros encontrados <span class='badge'>"+(data.data.length-lv_trcnthid)+"</span></span>";
				$("#<?= $lv_sec; ?> table").after(lv_buffer);
			}else{
				lv_buffer="<span class='pagination-info'>Registros encontrados <span class='badge'>"+(data.data.length-lv_trcnthid)+"</span></span>";
				$("#<?= $lv_sec; ?> span.pagination-info").html(lv_buffer);
			}
			//tooltip comprobante
			//$('[data-toggle="tooltip"]').tooltip();   
			
			
			// MOSTRAR/OCULTAR MOVIMIENTOS. mostrar u ocultar movimientos de un comprobante
			$("#<?= $lv_sec; ?>	[name=lnkgrp]").on("click",function(e){ e.preventDefault();
				$("#<?= $lv_sec; ?> [data-srccod="+this.parentNode.getAttribute('data-objcod')+"]").toggleClass("hidden");
				if(this.className=="fas fa-chevron-right"){
					$(this).removeClass("fa-chevron-right").addClass("fa-chevron-down");
				}else{
					$(this).removeClass("fa-chevron-down").addClass("fa-chevron-right");
				}
			});
			
      // MOSTRAR/OCULTAR DOCUMENTOS. mostrar u ocultar documentos con saldo 0
			$("#<?= $lv_sec; ?>	#btntogdocR").on("click",function(e){ e.preventDefault();
        var lv_docarr = $("#<?= $lv_sec; ?> #docrow");
				var lv_movarr = $("#<?= $lv_sec; ?> #movrow");
        for (var i = 0; i<lv_docarr.length; i++){
          if ($(lv_docarr[i]).children('#finbal').text() == 0){
            $(lv_docarr[i]).toggleClass('hidden');
            for (var c = 0; c<lv_movarr.length; c++){
              if ($(lv_docarr[i]).children().hasClass('fa-chevron-down')){
                if ($(lv_movarr[c]).attr('data-srccod') == $(lv_docarr[i]).attr('data-objcod')){
                  $("#<?= $lv_sec; ?> #movrow[data-srccod="+$(lv_docarr[i]).attr('data-objcod')+"]").toggleClass('hidden');
                }
              }
            }    
          }
        }
      });
			
			// LINK COMP. link de comprobante
			$("#<?= $lv_sec; ?>	a[name=lnkdoc]").on("click",function(e){ e.preventDefault();
				var lv_objtyp = $(this).data("docobjtyp");
				if( lv_objtyp.toLowerCase()=="tsr_tin" || lv_objtyp.toLowerCase()=="tsr_tou" ){
					var lv_prg = "tsrmovdoc";
				} else {
					var lv_prg = $(this).data("docobjtyp").replace("_","").toLowerCase();
				}
				var lv_docobjtypcod=lv_prg+"cod";
				var lv_mdlcod=$(this).data("docobjtyp").split("_")[0];
				var lv_docobjcod = $(this).data("docobjcod");                                                          
				var lv_prgcod = $(this).data("docobjtyp").split("_")[1];
				tmssLink("?prg="+lv_prg+"&act=03&prm_mdlcod="+lv_mdlcod+"&prm_prgcod="+lv_prgcod+"&prm_"+lv_docobjtypcod+"="+lv_docobjcod,
								 [{target: "_new_section"}]);
			});			
		});
  }
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
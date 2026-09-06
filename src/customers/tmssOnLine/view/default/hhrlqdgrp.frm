<?php
	// url del formulario
  $lv_lnk = '?prg=hhrlqdgrp';

	// campos requeridos
	$vew_input->RequiredFields( array('hhrlqdgrpdte','hhrlqdgrptxt','hhrlqdgrpstrdte','hhrlqdgrpenddte', 'docsts', 'prcschcod','prcschtxt') );

	// clave del documento
	$lv_dockey = $vew_data->hhrlqdgrpcod;

	// titulo
	$lv_title = $vew_lang->liquidation;
	
	// modulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'LQG';
	
	// librería de estilos bootstrap
  include_once('_library.frm');

	// valores x default
	if ( $vew_data->hhrlqdgrpcod=='' && $vew_readonly==false ) {
		$vew_data->hhrlqdgrpdte = date('d/m/Y');
		$vew_data->docsts = 'A';
		$lv_curdte = new DateTime( date('Y-m-d') );
		if ( $lv_curdte->format('d')>10 ) {
			$lv_strdte = new DateTime(date('Y-m-d'));
			$lv_enddte = new DateTime(date('Y-m-d'));
			$lv_strdte->modify('first day of this month');
			$lv_enddte->modify('last day of this month');
		} else {
			$lv_strdte = new DateTime(date('Y-m-d'));
			$lv_enddte = new DateTime(date('Y-m-d'));
			$lv_strdte->modify('first day of last month');
			$lv_enddte->modify('last day of last month');
		}
		$vew_data->hhrlqdgrpstrdte = $lv_strdte->format('d/m/Y');
		$vew_data->hhrlqdgrpenddte = $lv_enddte->format('d/m/Y');		
	}
	$lv_srcobjtyp = $vew_doc->getTagValue($vew_data->sysdocclsref->sysdocclsatr,'srcobjtyp');
	$lv_prcschcndrow = $vew_doc->getTagValue($vew_data->sysdocclsref->sysdocclsatr,'prcschcndrow');

	// botones por vista
  $vew_tbl['modL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl['modR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl['sveR'] = array('id'=>'btnsve', 'acc'=>'');
  $vew_tbl['sveL'] = array('id'=>'btnsve', 'acc'=>'');
	$vew_tbl['canc'] = array('id'=>'btncnc');
	$vew_tbl['cpy'] = array('per'=>false);
	$vew_tbl['accL'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09'), 'acc'=>$lv_sec.'_accounting();');
	$vew_tbl['accR'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09'), 'acc'=>$lv_sec.'_accounting();');
	$vew_tbl['del'] = array('per'=> $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly && $vew_data->docsts!='C' );
	
	// DETALLE. arma filas con detalle de liquidación
	$lv_grptot = 0;
	$lv_grpdet = '';
	foreach($vew_data->hhrlqddoc as $lv_row){
		$lv_docatr = array();
		$lv_tot = 0;
		$lv_docprc = array();
		foreach($vew_data->hhrlqddocprc as $lv_rowprc){
			if($lv_rowprc['srcobjcod001']==$lv_row['hhrlqdcod']){
				$lv_docprc[]=$lv_rowprc;
				if($lv_rowprc['prcschcndrow']==$lv_prcschcndrow){ $lv_tot=$lv_rowprc['prccndtot']; }
			}
		}
		$lv_grptot += $lv_tot;
		$lv_docatr001 = $vew_doc->getTagValue($lv_row['hhrlqdatr001'],'chratr');
		$lv_docatr['hrs']=$vew_doc->getTagValue($lv_docatr001,'hrs');
		$lv_docatr['hrstyp']=$vew_doc->getTagValue($lv_docatr001,'hrstyp');
		$lv_docatr['oldyth']=$vew_doc->getTagValue($lv_docatr001,'oldyth');
		$lv_docatr['oldmth']=$vew_doc->getTagValue($lv_docatr001,'oldmth');
		$lv_docatr['sitrev']=$vew_doc->getTagValue($lv_docatr001,'sitrev');
		$lv_docatr['seq']=$vew_doc->getTagValue($lv_docatr001,'seq');
		$lv_docatr['dni']=$lv_row['taxiibb'];
		$lv_grpdet .= '<tr data-hhrchrasgcod="'.$lv_row['hhrchrasgcod'].'" data-srcobjcod="'.$lv_row['srcobjcod'].'" data-hhrlqdcod="'.$lv_row['hhrlqdcod'].'">'
				.'<td class="text-center '.($vew_readonly?'hidden':'').'"><input class="cursor-pointer" type="checkbox" checked></td>'
				.'<td>'.($vew_sec->hasPermission('HHR','LQD','03')?'<a href="#" name="lnklqd">'.$lv_row['hhrlqdcod'].'</a>':$lv_row['hhrlqdcod']).'</td>'
				.'<td name="srcobjtxt">'.utf8_encode($lv_row['srcobjtxt']).'</td>'
				.'<td name="hhrchrtyptxt">'.($vew_sec->hasPermission('HHR','CHA','03')?'<a href="#" name="lnkcha">'.$lv_row['hhrchrtyptxt'].'</a>':$lv_row['hhrchrtyptxt']).'</td>'
				.'<td name="hhrchrasgdtestr">'.$lv_row['hhrchrstrdte'].'</td>'
				.'<td name="hhrchrasgdteend">'.$lv_row['hhrchrenddte'].'</td>'
				.'<td name="hhrlqdtot" class="text-right bg-info" style="font-weight:bold;">'.number_format($lv_tot,2).'</td>'
				.'<td>'
					.'<a href="#" class="card-icon" name="btndet"><i class="fas fa-ellipsis-h"></i></a>'
					.'<textarea class="hidden" name="txtprc">'.JSON_ENCODE($lv_docprc).'</textarea>'
					.'<textarea class="hidden" name="txtatr">'.JSON_ENCODE($lv_docatr).'</textarea>'
				.'</td>'
				.'</tr>';
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include("grldocfrmtlb.frm"); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('prcschcndrow','hidden',$lv_prcschcndrow); ?>
		<?= gethtml('sysdocclscodref','hidden',$vew_data->sysdocclsref->sysdocclscod); ?>
    <div id="excelcontainer"class="hidden"></div>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hhrlqdgrpcod; ?><?= gethtml('hhrlqdgrpcod','hidden',$vew_data->hhrlqdgrpcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-4">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->group; ?>
                    <span class="tmss-card-icon">
                    	<span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                    	<?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
                    </span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 	'input'=>gethtml('hhrlqdgrpdte', 'docdte', $vew_data->hhrlqdgrpdte, ($vew_data->hhrlqdgrpcod==''?$lv_default:$lv_always_disabled) ) ));
                    echo vew_boot($lv_col255, array('label'=>$vew_lang->period,
                                                    'input1'=>gethtml('hhrlqdgrpstrdte', 'docdte', $vew_data->hhrlqdgrpstrdte, ($vew_data->hhrlqdgrpcod==''?$lv_default:$lv_always_disabled) ),
                                                    'input2'=>gethtml('hhrlqdgrpenddte', 'docdte', $vew_data->hhrlqdgrpenddte, ($vew_data->hhrlqdgrpcod==''?$lv_default:$lv_always_disabled) )
                                                  ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hhrlqdgrptxt', 'doccmt1x50', $vew_data->hhrlqdgrptxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->schema, 
                                                'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                    array('input'=>gethtml('prcschtxt', 'typeahead', $vew_data->prcschtxt, $lv_default) )
                                                                  )));
                    echo '<input type="hidden" id="prcschcod" name="prcschcod" value="'.$vew_data->prcschcod.'">';
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', ($vew_data->docsts=='C'?'docstsacc':'docsts'), $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
             	</div>
						</div>
						<div class="col-md-8">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->liquidation; ?>
										<span class="card-icon tmss-bold" name="grptot"><?= number_format($lv_grptot); ?></span>
                    <a href="#" id="btncalc" class="card-icon tmssHiddeOnRead" title="<?= $vew_lang->calculate;  ?>"><i class="far fa-bolt"></i></a>
                    <a href="#" id="btnflt" class="card-icon <?= ($vew_data->hhrlqdgrpcod!=''?'hidden':''); ?>" title="<?= $vew_lang->filter; ?>"><i class="fas fa-filter"></i><span id="fltcnt" class="badge"></span></a>
                    <a href="#" id="btndwn" download="GrupoLiquidacion.xls" class="card-icon tmssHiddeOnEdit" title="<?= $vew_lang->download; ?>"><span class="fas fa-download"></span></a>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <div id="prgbar" style="height: 3px; width:0%; background-color:#f44336; position: absolute; top: 0px; left: 5px;"></div>
									<table class="table table-stripped table-hover table-condensed" id="hhrlqddet">
										<thead>
											<tr>
												<th class="text-center <?=($vew_readonly?'hidden':'');?>" width="30"><input class="cursor-pointer" type="checkbox" <?= ($vew_actcod == '02' ? 'checked' : ''); ?>></th>
												<th><?= $vew_lang->id; ?></th>
												<th><?= $vew_lang->source; ?></th>
												<th><?= $vew_lang->charge; ?></th>
												<th><?= $vew_lang->inbound; ?></th>
												<th><?= $vew_lang->outbound; ?></th>
												<th><?= $vew_lang->total; ?></th>
												<th width="20"></th>
											</tr>
										</thead>
										<tbody><?= $lv_grpdet; ?></tbody>
									</table>
									<div class="hidden"><table id="<?= $lv_sec; ?>_datatable"></table></div>
               	</div>
              </div>
						</div><!-- /col-md-6 -->
					</div><!-- /row -->
				</div> <!-- /_tab001 -->

			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		//FILTRO PERSONALIZADO
		var gv_<?= $lv_sec; ?>_flt=[{"fldttl": "<?= $vew_lang->id; ?>"   				,"fldcod": "srcobjcod", "fldtyp":"TEXT", "flttyp": "", "fldvalstr": "","fldvalend": ""},
																{"fldttl": "<?= $vew_lang->name; ?>" 				,"fldcod": "srcobjtxt", "fldtyp":"TEXT", "flttyp": "", "fldvalstr": "","fldvalend": ""},
																{"fldttl": "<?= $vew_lang->workersunion; ?>","fldcod": "lu.hhrlabunitxt", "fldtyp":"TEXT", "flttyp": "", "fldvalstr": "","fldvalend": ""},
																{"fldttl": "<?= $vew_lang->agreement; ?>"		,"fldcod": "ag.hhragrtxt", "fldtyp":"TEXT", "flttyp": "", "fldvalstr": "","fldvalend": ""},
																{"fldttl": "<?= $vew_lang->chargesclass; ?>","fldcod": "cc.hhrchrclstxt", "fldtyp":"TEXT", "flttyp": "", "fldvalstr": "","fldvalend": ""},
																{"fldttl": "<?= $vew_lang->charge; ?>"			,"fldcod": "ct.hhrchrtyptxt", "fldtyp":"TEXT", "flttyp": "", "fldvalstr": "","fldvalend": ""},
																{"fldttl": "<?= $vew_lang->inbound; ?>"			,"fldcod": "ca.hhrchrasgdtestr", "fldtyp":"DATE", "flttyp": "", "fldvalstr": "","fldvalend": ""},
																{"fldttl": "<?= $vew_lang->outbound; ?>"		,"fldcod": "ca.hhrchrasgdteend", "fldtyp":"DATE", "flttyp": "", "fldvalstr": "","fldvalend": ""},
																{"fldttl": "<?= $vew_lang->level; ?>"				,"fldcod": "stdloctxt", "fldtyp":"TEXT", "flttyp": "", "fldvalstr": "","fldvalend": ""},
                                {"fldttl": "<?= $vew_lang->subsidized; ?>"	,"fldcod": "persub", "fldtyp":"TEXT", "flttyp": "", "fldvalstr": "","fldvalend": ""},
																{"fldcod": "vewmaxrec","fldvalstr": "<?= ($vew_data->vewmaxrec!=''?$vew_data->vewmaxrec:'999') ?>"}];
		
		// filtro - boton
		$("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
			tmssFilterShowDialog(gv_<?= $lv_sec; ?>_flt,<?= $lv_sec; ?>_filtSources,"VEW_HHR_LQD_GRP_SRC_LST");
		});
		
		function <?= $lv_sec; ?>_filtSources(lp_flt) {
      for (var key in lp_flt) {
        if (lp_flt[key].fldcod == "persub"){
          if (lp_flt[key].fldvalstr.toUpperCase() == "SI" || lp_flt[key].fldvalstr.toUpperCase() == "S" || lp_flt[key].fldvalstr.toUpperCase() == "1"){
            lp_flt[key].fldvalstr = "1";
          }else if (lp_flt[key].fldvalstr.toUpperCase() == "NO" || lp_flt[key].fldvalstr.toUpperCase() == "N" || lp_flt[key].fldvalstr.toUpperCase() == "0"){
						lp_flt[key].fldvalstr = "0";
          }else{
          	lp_flt[key].fldvalstr = "";
          }
        }
      }
			var lv_fltint;
			if(lp_flt!=null){
				lv_fltint = tmssFilterParseToInternal(lp_flt);
				gv_<?= $lv_sec; ?>_flt = lp_flt;
				$("#<?= $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
			} else {
				lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
			}
			if(lv_fltint["maxrec"]==""){lv_fltint["maxrec"]="100";}

			if(lv_fltint!=$("#<?= $lv_sec; ?> #vewflt").prop("value")){
				var lv_pstdat= [{name:"vewflt",value:JSON.stringify(lv_fltint)},
												{name:"hhrlqdstrdte",value:$("#<?= $lv_sec; ?> #hhrlqdgrpstrdte").prop("value")},
												{name:"hhrlqdenddte",value:$("#<?= $lv_sec; ?> #hhrlqdgrpenddte").prop("value")},
												{name:"sysdocclscod",value:$("#<?= $lv_sec; ?> #sysdocclscodref").prop("value")}];
				tmssCallProcess("?prg=hhrlqd&act=getSources",lv_pstdat,function(data){
					var lo_dat = data.data;
					var lv_buffer = "";
					for(var i=0; i<lo_dat.length; i++){
						lv_buffer += "<tr data-hhrchrasgcod='"+lo_dat[i].hhrchrasgcod+"' data-srcobjcod='"+lo_dat[i].srcobjcod+"' data-hhrlqdcod=''>"
											+ "<td class='text-center'><input class='cursor-pointer' type='checkbox'></td>"
											+ "<td></td>"
											+ "<td name='srcobjtxt'>"+lo_dat[i].srcobjtxt+"</td>"
											+ "<td name='hhrchrtyptxt'>"+lo_dat[i].hhrchrtyptxt+"</td>"
											+ "<td name='hhrchrasgdtestr'>"+lo_dat[i].hhrchrasgdtestrcnv+"</td>"
											+ "<td name='hhrchrasgdteend'>"+(lo_dat[i].hhrchrasgdteendcnv==null?"":lo_dat[i].hhrchrasgdteendcnv)+"</td>"
											+ "<td name='hhrlqdtot' class='text-right bg-info' style='font-weight:bold;'>0.00</td>"
											+ "<td><a href='#' class='card-icon' name='btndet'><i class='fas fa-ellipsis-h'></i></a><textarea class='hidden' name='txtprc'></textarea></td>"
											+ "</tr>";
					}
					$("#<?= $lv_sec; ?> #hhrlqddet tbody").html(lv_buffer);
					
					// attach de eventos para visualizar esquema de precios
					$("#<?= $lv_sec; ?> #hhrlqddet tbody tr a[name=btndet]").on("click",function(e){ e.preventDefault();
						<?= $lv_sec; ?>_showDetails( $(this).parent().parent() );
					});

					// attacj de evento para contador de cantidad seleccionada
					$("#<?= $lv_sec; ?> #hhrlqddet tbody input[type=checkbox]").on("change",function(e){
						<?= $lv_sec; ?>_refreshQty();
					});
				
				});
			}
		}
	</script>
	<script>
		// tabla - checkbok cabecera
		$("#<?= $lv_sec; ?> #hhrlqddet thead input[type=checkbox]").on("click",function(e){ 
			$("#<?= $lv_sec; ?> #hhrlqddet tbody input[type=checkbox]").prop("checked", $(this).prop("checked"));
			<?= $lv_sec; ?>_refreshQty();
		});

		function <?= $lv_sec; ?>_refreshQty() {
			// agrego contador de items seleccionados
			var lv_qty = $("#<?= $lv_sec; ?> #hhrlqddet tbody input[type=checkbox]:checked").length;
			if( lv_qty>0 ){
				$("#<?= $lv_sec; ?> #btncalc span.badge").removeClass("hidden").text( lv_qty );
			} else {
				$("#<?= $lv_sec; ?> #btncalc span.badge").addClass("hidden").text("");
			}
		}
		
		function <?= $lv_sec; ?>_GridRefresh(){
			<?= $lv_sec; ?>_fnc({action: "99"});
		}
		
		// prcschtxt - typeahead
		var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg":{ "prcschcod":"prcschcod", "prcschtxt":"prcschtxt"}, "fldflt":{"docsts":"A", "mdlcod":"HHR"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #prcschtxt"), "prcsch", lo_get);
		
		
		// CALCULAR
		$("#<?= $lv_sec; ?> #btncalc").on("click", function(e) { e.preventDefault();
			// si existe algún cambio manual en las filas seleccionadas, pregunta. Si no, directamente actualiza los precios
			if($("#<?= $lv_sec; ?> input:checked").length > 0){
      	if($("#<?= $lv_sec; ?> #hhrlqddet").html().indexOf('"prcchgman":"X"') != -1){
        
          BootstrapDialog.show({
            title: "Calcular liquidaciones",
            message: "Existen liquidaciones modificadas manualmente. &iquest;Desea mantener estas modificaciones?",
            closable: true,
            draggable: true,
            buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default pull-left", action: function(dialogItself){ dialogItself.close(); } },
                      {	label: "<?= $vew_lang->no; ?>", cssClass: "btn-danger",	action: function(dialogItself){ <?= $lv_sec; ?>_calcPrices(); dialogItself.close(); } },
                      {	label: "<?= $vew_lang->yes; ?>", cssClass: "btn-success",	action: function(dialogItself){ <?= $lv_sec; ?>_calcPrices(true); dialogItself.close(); } }]
          });
        
        }else{
          <?= $lv_sec; ?>_calcPrices();
        }   
     	}else{
				toastr.warning("Debe seleccionar al menos una posici&oacute;n a calcular");
			}                                              
    });
		
    function <?= $lv_sec; ?>_calcPrices(lp_keepchg = false){
			// verifico campos obligatorios y elementos seleccionados
			if( tmssCheckRequiredFields($("#<?= $lv_sec; ?>_frm")) ){
				if($("#<?= $lv_sec; ?> #hhrlqddet tbody input[type=checkbox]:checked").length==0){
					toastr.warning("Debe indicar al menos un elemento a calcular.");
					return false;
				}
			} else { return false; }
			
			// deshabilitar todos los campos y selectores actuales
			var lv_tot = 0;
			var lv_max = $("#<?= $lv_sec; ?> #hhrlqddet tbody input[type=checkbox]:checked").length;
			$("#<?= $lv_sec; ?> #prgbar").css("width","0%").removeClass("hidden");
			$("#<?= $lv_sec ;?> #btnflt").addClass("hidden");
			
			
			$("#<?= $lv_sec; ?> #hhrlqddet tbody input[type=checkbox]:checked").each(function(){
				$(this).parent().parent().find("td[name=hhrlqdtot]").removeClass("bg-success").addClass("bg-info").html("<i class='fas fa-spinner fa-spin'></i>");
			});
			
			// realizo calculo individual
			var lv_grptot = 0;
			$("#<?= $lv_sec; ?> #hhrlqddet tbody input[type=checkbox]:checked").each(function(){
				
				var lv_dochdr = [];
				lv_dochdr.push({name:"sysdocclscod",value:$("#<?= $lv_sec; ?> #sysdocclscodref").prop("value") });
				lv_dochdr.push({name:"hhrlqddte",value:$("#<?= $lv_sec; ?> #hhrlqdgrpdte").prop("value") });
				lv_dochdr.push({name:"hhrlqdstrdte",value:$("#<?= $lv_sec; ?> #hhrlqdgrpstrdte").prop("value") });
				lv_dochdr.push({name:"hhrlqdenddte",value:$("#<?= $lv_sec; ?> #hhrlqdgrpenddte").prop("value") });
				lv_dochdr.push({name:"hhrlqdtxt",value:$("#<?= $lv_sec; ?> #hhrlqdgrptxt").prop("value") });
				lv_dochdr.push({name:"prcschcod",value:$("#<?= $lv_sec; ?> #prcschcod").prop("value") });
				lv_dochdr.push({name:"docsts",value:$("#<?= $lv_sec; ?> #docsts").prop("value") });
				var lv_tr = $(this).parent().parent();				
				lv_dochdr.push({name:"hhrlqdcod",value:$(lv_tr).data("hhrlqdcod")});
				lv_dochdr.push({name:"hhrchrasgcod",value:$(lv_tr).data("hhrchrasgcod")});
				lv_dochdr.push({name:"srcobjcod",value:$(lv_tr).data("srcobjcod")});
				lv_dochdr.push({name:"hhrchrasgdtestr",value:$(lv_tr).find("td[name=hhrchrasgdtestr]").text()});
				lv_dochdr.push({name:"hhrchrasgdteend",value:$(lv_tr).find("td[name=hhrchrasgdteend]").text()});
				lv_dochdr.push({name:"srcobjtxt",value:$(lv_tr).find("td[name=srcobjtxt]").text()});
				lv_dochdr.push({name:"hhrchrtyptxt",value:$(lv_tr).find("td[name=hhrchrtyptxt]").text()});
				
        if (lp_keepchg){
        	var lv_docprc = $(lv_tr).find("textarea[name=txtprc]").text();
        }else{
          var lv_docprc = "";
        }
        
				// limpio la grilla de liquidaciones
				tmssCallProcessNoBackdrop("?prg=hhrlqd&act=calc",[{name:"dochdr",value:JSON.stringify(lv_dochdr)},{name:"docprc", value: lv_docprc}],function(data){

					// calculo TOTAL de liquidacion
					var lv_net=0;
					for(var x=0;x<data.docprc.length;x++){ 
						if( $("#<?= $lv_sec; ?> #prcschcndrow").prop("value")=="" && data.docprc[x].prccndcod!="0" ){
							lv_net += data.docprc[x].prccndtot;
						} else if( $("#<?= $lv_sec; ?> #prcschcndrow").prop("value")==data.docprc[x].prcschcndrow ) {
							lv_net = data.docprc[x].prccndtot;
							x=data.docprc.length;
						}
					}
					
					lv_grptot += lv_net;
					$("#<?= $lv_sec; ?> span[name=grptot]").html( lv_grptot.toLocaleString() );
					
					// actualizo fila de liquidación
					$(lv_tr).find("td[name=hhrlqdtot]").removeClass("bg-info").addClass("bg-success").html( lv_net.toLocaleString() ); //lv_net.toFixed(2) );
					$(lv_tr).find("textarea[name=txtprc]").text(JSON.stringify(data.docprc));
			
					// actualizo barra de progreso
					lv_tot++;
					if(lv_tot==lv_max){ 
						$("#<?= $lv_sec; ?> #prgbar").addClass("hidden");
					} else {
						$("#<?= $lv_sec; ?> #prgbar").animate({width:Number(lv_tot*100/lv_max)+"%"},"slow");
					}
				});
			});
    }
		
		
		
		// S A V E
		$("#<?= $lv_sec; ?> #btnsve").on("click",function(e){ e.preventDefault();
			if($("#<?= $lv_sec; ?> #hhrlqddet tbody input[type=checkbox]:checked").length==0){
				toastr.warning("Debe indicar al menos un elemento a grabar.");
				return false;
			} else {
				$("#<?= $lv_sec; ?> #btnsve").addClass("hidden");
				$("#<?= $lv_sec; ?> #btncnc").addClass("hidden");
				$("#<?= $lv_sec; ?> #btncalc").addClass("hidden");
				var lv_pstdat = $("#<?= $lv_sec ?>_frm").serializeArray();
        
				for(var i=lv_pstdat.length-1;i>0;i--){
					if(lv_pstdat[i]["name"]=="txtprc" || lv_pstdat[i]["name"]=="srcobjchk" || lv_pstdat[i]["name"]=="txtatr"){ lv_pstdat.splice(i,1); }
				}
				tmssCallProcess("?prg=hhrlqdgrp&act=00",lv_pstdat,function(data){
					if(data.errtyp=="S"){
						$("#<?= $lv_sec; ?> #hhrlqdgrpcod").prop("value",data.hhrlqdgrpcod);
					} else {
						toastr.warning("Se produjo un error al grabar el documento. "+data.errtxt);
						return false;
					}
					
					var lv_toterr = 0;
					var lv_tot = 0;
					var lv_max = $("#<?= $lv_sec; ?> #hhrlqddet tbody input[type=checkbox]:checked").length;
					$("#<?= $lv_sec; ?> #prgbar").css("width","0%").removeClass("hidden");
					
					$("#<?= $lv_sec; ?> #hhrlqddet tbody input[type=checkbox]:checked").each(function(){
						var lv_tr = $(this).parent().parent();
						var lv_pstdat2 = [];
						lv_pstdat2.push({name:"hhrlqddte",value:$("#<?= $lv_sec; ?> #hhrlqdgrpdte").prop("value")});
						lv_pstdat2.push({name:"hhrlqdstrdte",value:$("#<?= $lv_sec; ?> #hhrlqdgrpstrdte").prop("value")});
						lv_pstdat2.push({name:"hhrlqdenddte",value:$("#<?= $lv_sec; ?> #hhrlqdgrpenddte").prop("value")});
						lv_pstdat2.push({name:"hhrchrasgdtestr",value:$(lv_tr).find("td[name=hhrchrasgdtestr]").text()});
						lv_pstdat2.push({name:"hhrchrasgdteend",value:$(lv_tr).find("td[name=hhrchrasgdteend]").text()});
						lv_pstdat2.push({name:"hhrlqdtxt",value:$("#<?= $lv_sec; ?> #hhrlqdgrptxt").prop("value")});
						lv_pstdat2.push({name:"hhrlqdgrpcod",value:$("#<?= $lv_sec; ?> #hhrlqdgrpcod").prop("value")});
						lv_pstdat2.push({name:"prcschcod",value:$("#<?= $lv_sec; ?> #prcschcod").prop("value")});
						lv_pstdat2.push({name:"prcschtxt",value:$("#<?= $lv_sec; ?> #prcschtxt").prop("value")});
						lv_pstdat2.push({name:"hhrlqdcod",value:$(lv_tr).data("hhrlqdcod")});
						lv_pstdat2.push({name:"srcobjtyp",value:"<?= $lv_srcobjtyp; ?>"});
						lv_pstdat2.push({name:"srcobjcod001",value:$(lv_tr).data("srcobjcod")});
						lv_pstdat2.push({name:"srcobjcod002",value:""});
						lv_pstdat2.push({name:"hhrchrasgcod",value:$(lv_tr).data("hhrchrasgcod")});
						lv_pstdat2.push({name:"txtprc",value:$(lv_tr).find("textarea[name=txtprc]").text()});
						lv_pstdat2.push({name:"sysdocclscod",value:$("#<?= $lv_sec; ?> #sysdocclscodref").prop("value")});
						lv_pstdat2.push({name:"docsts",value:"A"});
						tmssCallProcess("?prg=hhrlqd&act=00",lv_pstdat2,function(data){
							if(data.errtyp=="E"){
								lv_toterr++;
								$("#<?= $lv_sec; ?> #hhrlqddet tbody tr[data-hhrchrasgcod="+data.hhrchrasgcod+"]").addClass("bg-danger");
								$("#<?= $lv_sec; ?> #hhrlqddet tbody tr[data-hhrchrasgcod="+data.hhrchrasgcod+"] td:first").html("<i class='fas fa-exclamation'></i>");
							} else {
								$("#<?= $lv_sec; ?> #hhrlqddet tbody tr[data-hhrchrasgcod="+data.hhrchrasgcod+"]").addClass("bg-success");
								$("#<?= $lv_sec; ?> #hhrlqddet tbody tr[data-hhrchrasgcod="+data.hhrchrasgcod+"] td:first").html("<i class='fas fa-check'></i>");
							}
							
							// actualizo barra de progreso
							lv_tot++;
							if(lv_tot==lv_max){ 
								$("#<?= $lv_sec; ?> #prgbar").addClass("hidden");
								if(lv_toterr>0){
									toastr.warning("Los datos han sido grabados. Revise los errores.");
								} else {
									toastr.success("Los datos han sido grabados.");
								}
								<?= $lv_sec; ?>_fnc({action: "03"});
							} else {
								$("#<?= $lv_sec; ?> #prgbar").animate({width:Number(lv_tot*100/lv_max)+"%"},"slow");
							}
							
						});
					});
					
				});
			}
		});
		
		
		
		// showDetails
		// muestra el detalle de una liquidación
		function <?= $lv_sec; ?>_showDetails( lv_row ) {
			if($(lv_row).find("textarea[name=txtprc]").val() != ""){
        var lv_dochdr = $("#<?= $lv_sec; ?>_frm").serializeArray();
        lv_dochdr.push({name:"hhrchrasgcod",value:$(lv_row).data("hhrchrasgcod")});
        lv_dochdr.push({name:"srcobjcod",value:$(lv_row).data("srcobjcod")});
        lv_dochdr.push({name:"hhrchrasgdtestr",value:$(lv_row).find("td[name=hhrchrasgdtestr]").text()});
        lv_dochdr.push({name:"hhrchrasgdteend",value:$(lv_row).find("td[name=hhrchrasgdteend]").text()});
        lv_dochdr.push({name:"hhrlqddte",value:$("#<?= $lv_sec; ?> #hhrlqdgrpdte").prop("value")});
        lv_dochdr.push({name:"hhrlqdstrdte",value:$("#<?= $lv_sec; ?> #hhrlqdgrpstrdte").prop("value")});
        lv_dochdr.push({name:"hhrlqdenddte",value:$("#<?= $lv_sec; ?> #hhrlqdgrpenddte").prop("value")});
        lv_dochdr.push({name:"hhrlqdtxt",value:$("#<?= $lv_sec; ?> #hhrlqdgrptxt").prop("value")});
        lv_dochdr.push({name:"srcobjtyp",value:"<?= $lv_srcobjtyp; ?>"});
        lv_dochdr.push({name:"srcobjcod001",value:$(lv_row).data("srcobjcod")});
        lv_dochdr.push({name:"srcobjcod002",value:""});
        lv_dochdr.push({name:"hhrchrasgcod",value:$(lv_row).data("hhrchrasgcod")});
        lv_dochdr.push({name:"txtprc",value:$(lv_row).find("textarea[name=txtprc]").text()});
        lv_dochdr.push({name:"sysdocclscod",value:$("#<?= $lv_sec; ?> #sysdocclscodref").prop("value")});

        // quitar precios de la cabecera
        for(var x=0;x<lv_dochdr.length;x++){
          if(lv_dochdr[x]["name"]=="txtprc"){lv_dochdr.splice(x,1);x--;}
          if(lv_dochdr[x]["name"]=="sysdocclscod"){lv_dochdr.splice(x,1);x--;}
        }
        lv_dochdr.push({name:"sysdocclscod",value:$("#<?= $lv_sec; ?> #sysdocclscodref").prop("value")});

        var lv_docpos = {};
        var lv_docprc = JSON.parse($(lv_row).find("textarea[name=txtprc]").val());

        var lv_pstdat=[ {name:"dochdr",	value: JSON.stringify(lv_dochdr) },
                        {name:"docpos",	value: JSON.stringify(lv_docpos) },
                        {name:"docprc",	value: JSON.stringify(lv_docprc) },
                        {name:"readonly",value:<?= ($vew_readonly?'true':'false'); ?>}
                      ];
        tmssCallProcess("?prg=hhrlqd&act=13", lv_pstdat, function(data){
          BootstrapDialog.show({
            title: "Liquidaci&oacute;n", 
            draggable: true,
            closable: true,
            message: $(data),
            type: BootstrapDialog.TYPE_PRIMARY,
            size: BootstrapDialog.SIZE_WIDE
            <?php if(!$vew_readonly){ ?>
            ,buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger <?= ($vew_readonly?'hidden':''); ?>", action: function(dialogItself){ dialogItself.close(); } },
                      {	label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success <?= ($vew_readonly?'hidden':''); ?>",	action: function(dialogItself){
                        var lv_dat = dialogItself.$modalBody.find("#grldatprc").val();
                        var lv_dat_arr = JSON.parse(lv_dat);

                        // calculo TOTAL de liquidacion
                        var lv_net=0;
                        for(var x=0;x<lv_dat_arr.length;x++){ 
                          if( $("#<?= $lv_sec; ?> #prcschcndrow").prop("value")=="" && lv_dat_arr[x].prccndcod!="0" ){
                            lv_net += lv_dat_arr[x].prccndtot;
                          } else if( $("#<?= $lv_sec; ?> #prcschcndrow").prop("value")==lv_dat_arr[x].prcschcndrow ) {
                            lv_net = lv_dat_arr[x].prccndtot;
                            x=lv_dat_arr.length;
                          }
                        }

                        // actualizo fila de liquidación
                        $(lv_row).find("td[name=hhrlqdtot]").removeClass("bg-info").addClass("bg-success").html( Number(lv_net).toFixed(2));											
                        $(lv_row).find("textarea[name=txtprc]").text( lv_dat );											

                        dialogItself.close();
                        }
                      }]
            <?php } ?>
          });
        });
    	}
			return false;			
		}
		
		
		// CONTABILIZAR
		function <?= $lv_sec; ?>_accounting() {
			BootstrapDialog.confirm({
				title: "<?= $vew_lang->accounting; ?>",
				message: "¿Desea contabilizar el documento?",
				type: BootstrapDialog.TYPE_WARNING,
				callback: function(result) { if(result) { <?= $lv_sec; ?>_fnc({action: "09"}); } }
			});
		}
		
		<?php if($vew_data->hhrlqdgrpcod!='') { ?>
			// attach de eventos para visualizar esquema de precios
			$("#<?= $lv_sec; ?> #hhrlqddet tbody tr a[name=btndet]").on("click",function(e){ e.preventDefault();
				<?= $lv_sec; ?>_showDetails( $(this).parent().parent() );
			});

			$("#<?= $lv_sec; ?> #hhrlqddet tbody a[name=lnklqd]").on("click",function(e){ e.preventDefault();
				var lv_pstdat = [{name:"hhrlqdcod",value:$(this).parent().parent().data("hhrlqdcod")}];
				tmssLink("?prg=hhrlqd&act=03",[{target: "_new_section",post_data:lv_pstdat}] );
			});
			
			$("#<?= $lv_sec; ?> #hhrlqddet tbody a[name=lnkcha]").on("click",function(e){ e.preventDefault();
				var lv_pstdat = [{name:"hhrchrasgcod",value:$(this).parent().parent().data("hhrchrasgcod")}];
				tmssLink("?prg=hhrchrasg&act=03",[{target: "_new_section",post_data:lv_pstdat}] );
			});
		<?php } ?>
	</script>
	<script>
		// EXPORTAR. descarga todas las condiciones calculadas como XLS
		tmssLoadScript("excellentexport2", function(){
			$("#<?= $lv_sec; ?> #btndwn").on("click",function(e){
				var lv_tbl = "";
				var lv_hdr = "";
				var lv_bdy = "";
				// recorro todas las liquidaciones
				$("#<?= $lv_sec; ?> textarea[name=txtprc]").each(function(){
					var lv_arr = ($(this).text()=="" ? [] : JSON.parse($(this).text()) );
					// cargo titulos de cabecera
					if(lv_hdr==""){
						lv_hdr += "<tr><th>ID</th><th>Origen</th><th>Cargo</th><th>ID Asignacion</th><th>Entrada</th><th>Salida</th><th>DNI</th><th>Sec</th><th>Hs</th><th>Ant</th><th>Ant%</th>";
						for(var i=0; i<lv_arr.length; i++){ lv_hdr += "<th style='"+(lv_arr[i].prccndstd=="X"?"background-color: #f1f1f1;":"")+"'>"+lv_arr[i].prccndtxt+"</th>"; }
						lv_hdr += "</tr>";
					}

					// cargo valores
					var lv_tr = $(this).parent().parent();
					if( $(lv_tr).find("textarea[name=txtatr]").text()!="" ){
						lv_atrarr = JSON.parse($(lv_tr).find("textarea[name=txtatr]").text());
						lv_bdy += "<tr><td>"+$(lv_tr).data("hhrlqdcod")+"</td><td>"+$(lv_tr).find("td[name=srcobjtxt]").text()+"</td><td>"+$(lv_tr).find("td[name=hhrchrtyptxt]").text()+"</td><td>"+$(lv_tr).data("hhrchrasgcod")+"</td><td>"+$(lv_tr).find("td[name=hhrchrasgdtestr]").text()+"</td><td>"+$(lv_tr).find("td[name=hhrchrasgdteend]").text()+"</td>"+
						(lv_atrarr['dni']!="" ? "<td>"+lv_atrarr["dni"]+"</td>" : "<td></td>" ) +
						(lv_atrarr['seq']!="" ? "<td>"+lv_atrarr["seq"]+"</td>" : "<td></td>" ) +
						(lv_atrarr['hrs']!="" ? "<td>"+Number(lv_atrarr["hrs"])+"</td>" : "<td></td>" ) +
						(lv_atrarr['oldyth']!="" && lv_atrarr["oldmth"]!="" ? "<td>"+(lv_atrarr["oldyth"]<10?"0":"")+lv_atrarr["oldyth"]+"."+(lv_atrarr["oldmth"]<10?"0":"")+lv_atrarr["oldmth"]+"</td>" : "<td></td>" );
						lv_antflg = false;
						for(var i=0; i<lv_arr.length; i++){
							if (lv_arr[i].prccndcodext == "ANTIGUEDAD"){
								lv_bdy += "<td>"+Number(lv_arr[i].prccndqty).toFixed(2).replace(".",",")+"</td>";
								lv_antflg = true;
							}
						}
						if (!lv_antflg){lv_bdy += "<td></td>";}
						for(var i=0; i<lv_arr.length; i++){ lv_bdy += "<td style='"+(lv_arr[i].prccndstd=="X"?"background-color: #f1f1f1;":"")+"'>"+Number(lv_arr[i].prccndtot).toFixed(2).replace(".",",")+"</td>"; }
						lv_bdy += "</tr>";
					}
				});
				lv_tbl = "<table id='<?= $lv_sec; ?>_datatable'><thead>"+lv_hdr+"</thead><tbody>"+lv_bdy+"</tbody></table>";
				$("#<?= $lv_sec; ?>_datatable").replaceWith(lv_tbl); 
				
				return ExcellentExport.excel(this, "<?= $lv_sec; ?>_datatable", "GrupoLiquidacion");
			});
		});
	</script>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";

		// server response ext
    function <?= $lv_sec; ?>_fncbckext(data) {
      if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="09") {
					toastr.info("Documento contabilizado.");
					<?= $lv_sec; ?>_fnc({action: "99"});
				} else if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    }
		
    // form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      $("#<?= $lv_sec; ?> textarea[name=txtprc]").remove();
      $("#<?= $lv_sec; ?> textarea[name=txtatr]").remove();
			if ( lp_prm["action"]=="14" ) {
				BootstrapDialog.confirm({
					title: "<?= $vew_lang->delete; ?>",
					message: "ATENCION: Este documento se encuentra contabilizado.<br>&iquest;Desea borrarlo?",
					type: BootstrapDialog.TYPE_WARNING,
					callback: function(result) { if(result) { <?= $lv_sec; ?>_fnc({action: "04"}); } }
				});
				return false;
			}
		}
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
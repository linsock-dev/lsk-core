<?php
	/* librería de estilos bootstrap */
	include_once('_library.frm');
		
	/* url del formulario */
  $lv_lnk = "?prg=edutchlqd&prm_edutchlqdcod=".$vew_data->edutchlqdcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('edutchlqddte','edutchlqdtxt','tchtxt', 'tchcod','edutchlqdstrdte','edutchlqdenddte', 'docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->edutchlqdcod;

	/* titulo */
	$lv_title = $vew_lang->liquidation;
	
	/* módulo y programa */
	$lv_mdlcod = 'EDU';
	$lv_prgcod = 'LQM';
	

	
	/* valores x default */
	if ( $vew_data->edutchlqdcod=='' && $vew_readonly==false ) {
		$vew_data->edutchlqddte = date('d/m/Y');
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

		$vew_data->edutchlqdstrdte = $lv_strdte->format('d/m/Y');
		$vew_data->edutchlqdenddte = $lv_enddte->format('d/m/Y');		
	} else {
		$vew_data->edutchlqdstrdte = $vew_doc->getTagValue($vew_data->edutchlqdatr001,'strdte');
		$vew_data->edutchlqdenddte = $vew_doc->getTagValue($vew_data->edutchlqdatr001,'enddte');
	}
	
	$lv_prnfrm = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'print_form');	

	// Botones por vista
  $vew_tbl['accL'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09') && $vew_data->sysdoctrecod!='C', 'acc'=>$lv_sec.'_accounting();');
	$vew_tbl['accR'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09') && $vew_data->sysdoctrecod!='C', 'acc'=>$lv_sec.'_accounting();');
	$vew_tbl['modL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl['modR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl['delsep'] = array('per'=> $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'14') && $vew_readonly && $vew_data->docsts!='C' );
	$vew_tbl['del'] = array('per'=> $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'14') && $vew_readonly && $vew_data->docsts!='C' );
	$vew_tbl['btnprn'] = array('pos'=>'L','per'=>$vew_data->docsts=='C' && $lv_prnfrm!='','ttl'=>$vew_lang->print,'icn'=>'fas fa-print','css'=>'btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit','id'=>'btnprn','acc'=>'' );
	$vew_tbl['nxtL'] = array('pos'=>'L','per'=>true,'ttl'=>$vew_lang->data,'icn'=>'fas fa-sync-alt','css'=>'btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-default','id'=>'btnnxt1','acc'=>'' );

?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
 	<?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
		<textarea id="opnsrvids" name="opnsrvids" class="hidden"></textarea>
		<textarea id="opnexpids" name="opnexpids" class="hidden"></textarea>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->data; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->edutchlqdcod; ?><input type="hidden" id="edutchlqdcod" name="edutchlqdcod" value="<?= $vew_data->edutchlqdcod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->LIQUIDATION; ?>
                    <span class="tmss-card-icon">
                      <span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);?> 
                    </span> 
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                    <?php 
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 		'input'=>gethtml('edutchlqddte', 'docdte', $vew_data->edutchlqddte, ($vew_data->edutchlqdcod==''?$lv_default:$lv_always_disabled) ) ));
                      echo vew_boot($lv_col255, array('label'=>$vew_lang->period,
                                                      'input1'=>gethtml('edutchlqdstrdte', 'docdte', $vew_data->edutchlqdstrdte, ($vew_data->edutchlqdcod==''?$lv_default:$lv_always_disabled)),
                                                      'input2'=>gethtml('edutchlqdenddte', 'docdte', $vew_data->edutchlqdenddte, ($vew_data->edutchlqdcod==''?$lv_default:$lv_always_disabled))
                                                    ));
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('edutchlqdtxt', 'doccmt1x50', $vew_data->edutchlqdtxt, $lv_default) ));
                      echo vew_boot($lv_col273, array('label'=>$vew_lang->teacher,
                                                      'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->edutchlqdcod==''?$vew_readonly:true) ),
                                                                          array('input'=>gethtml('tchtxt', 'doccmt1x50', $vew_data->tchtxt, ($vew_data->edutchlqdcod==''?$lv_default:$lv_always_disabled) ) )),
                                                      'input2'=>gethtml('tchcod','doccod',$vew_data->tchcod,$lv_always_disabled) ));
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', ($vew_data->docsts=='C'?'docstsacc':'docsts'), $vew_data->docsts, $lv_default) ));
                    ?>
                </div>
              </div>
						</div>
					</div>
				</div> <!-- fin _tab001 -->

				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<div id="edutchlqddet"></div>
				</div> <!-- /tab-pane -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
		//INFO adicional
		$("#<?= $lv_sec; ?> #btnshowinfo").on("click",function(e){e.preventDefault
			var lv_dat=[{"infttl":"<?= $vew_lang->createdby;?>","infdat":"<?= $vew_data->cteusr; ?>"},
									{"infttl":"<?= $vew_lang->createddate; ?>","infdat":"<?= ($vew_data->ctedte!=''?date_format($vew_data->ctedte,'d-m-Y h:i:s'):''); ?>"},
									{"infttl":"<?= $vew_lang->updatedby; ?>","infdat":"<?= $vew_data->updusr; ?>"},
									{"infttl":"<?= $vew_lang->updateddate; ?>","infdat":"<?= ($vew_data->upddte!=''?date_format($vew_data->upddte,'d-m-Y h:i:s'):''); ?>"}];
			var lv_pstdat=[{name:"infdat",value:JSON.stringify(lv_dat)}];
			tmssPopup("Info","?prg=grlvew&act=showinfo",function(){},lv_pstdat);
		});

		function <?= $lv_sec; ?>_calcTotal() {
			var lv_qtysrv = 0;
			var lv_totsrv = 0;
			$("#<?= $lv_sec; ?> #edutchlqddet #opnsrvchk:checked").each(function(){lv_qtysrv++; lv_totsrv+=Number($(this).data("refobjtot"));});
			$("#<?= $lv_sec; ?> #edutchlqddet #opnsrvtot").prop("value", lv_totsrv);
			$("#<?= $lv_sec; ?> #edutchlqddet .opnsrvbdg").text((lv_qtysrv==0?"":lv_qtysrv));
			var lv_qtyexp = 0;
			var lv_totexp = 0;
			$("#<?= $lv_sec; ?> #edutchlqddet #opnexpchk:checked").each(function(){lv_qtyexp++; lv_totexp+=Number($(this).data("refobjtot"));});
			$("#<?= $lv_sec; ?> #edutchlqddet #opnexptot").prop("value", lv_totexp);		
			$("#<?= $lv_sec; ?> #edutchlqddet .opnexpbdg").text((lv_qtyexp==0?"":lv_qtyexp));
			
			$("#<?= $lv_sec; ?> #edutchlqddet #edutchlqdtot").text( Number(lv_totsrv+lv_totexp).toFixed(2) );		
		}
		
		// DATOS
		$("#<?= $lv_sec; ?> #btnnxt1").on("click", function(e) { e.preventDefault();
			// valido datos mínimos
			if ( tmssCheckRequiredFields( $("#<?= $lv_sec; ?>_frm") )==false ) { return false;}
			// cambiar tab
			$("#<?= $lv_sec; ?> a[href='#<?= $lv_sec; ?>_tab002']").trigger("click");
			// obtener datos
			var lv_pstdat ={tchcod: $("#<?= $lv_sec; ?> #tchcod").prop("value"),
											edutchlqdcod: $("#<?= $lv_sec; ?> #edutchlqdcod").prop("value"),
											edutchlqdstrdte: $("#<?= $lv_sec; ?> #edutchlqdstrdte").prop("value"),
											edutchlqdenddte: $("#<?= $lv_sec; ?> #edutchlqdenddte").prop("value"),
											sysdocclscod: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value"),
											token: "<?= $lv_sec; ?>"};
			tmssCallProcess("?prg=edutchlqd&act=<?= ($vew_readonly?'13':($vew_data->edutchlqdcod==''?'11':'12')); ?>",lv_pstdat,function(data){
				$("#<?= $lv_sec; ?> #edutchlqddet").html(data); 
				$("#<?= $lv_sec; ?> #tchtxt").prop("readonly","readonly").next().next().addClass("hidden").parent().removeClass("input-group");
				$("#<?= $lv_sec; ?> #edutchlqdstrdte").prop("readonly","readonly");
				$("#<?= $lv_sec; ?> #edutchlqdenddte").prop("readonly","readonly");
				// adjunto eventos
				$("#<?= $lv_sec; ?> #edutchlqddet input:checkbox").on("change",function(e){
					if ( $(this).prop("id")=="opnsrvchkhdr" ) { $("#<?= $lv_sec; ?> #edutchlqddet #opnsrvchk").prop("checked", $(this).is(":checked") ); }
					if ( $(this).prop("id")=="opnexpchkhdr" ) {	$("#<?= $lv_sec; ?> #edutchlqddet #opnexpchk").prop("checked", $(this).is(":checked") ); }
					<?= $lv_sec; ?>_calcTotal();
				});
				<?= $lv_sec; ?>_calcTotal();
			});
		});
		
		// CONTABILIZAR
		function <?= $lv_sec; ?>_accounting() {
			BootstrapDialog.confirm({
				title: "<?= $vew_lang->accounting; ?>",
				message: "¿Desea contabilizar el documento?",
				type: BootstrapDialog.TYPE_WARNING,
				callback: function(result) { if(result) { <?= $lv_sec; ?>_fnc({action: "09"}); } }
			});
		}
		
		// IMPRIMIR
		$("#<?= $lv_sec; ?> #btnprn").on("click",function(e){
			// mostrar formulario
			window.open("<?= $lv_prnfrm; ?>&prm_edutchlqdcod="+$("#<?= $lv_sec; ?> #edutchlqdcod").prop("value") );
		});
		
		<?php if ($vew_data->edutchlqdcod!='') { ?>
			$("#<?= $lv_sec; ?> #btnnxt").trigger("click");
		<?php } ?>
	</script>
	<script>
		// spctxt
		tmssLoadScript("typeahead",function(){
			$("#<?= $lv_sec; ?> #spctxt").typeahead({
				onSelectAjaxData: function(data){
					$("#<?= $lv_sec; ?> #spccod").prop("value", data.data.spccod); },
				ajax: {
					url: "?prg=hltspc&act=18",
					displayField: "spctxt",
					valueField: "spctxt",
					timeout: 500,	triggerLength: 1,	method: "get", loadingClass: "fas fa-spinner",
					preDispatch: function(query){ return {prm_spctxt: query}; },
					preProcess: function(data){ return (data.length==0?false:data); }
				}
			}).next().next("span").children("a:first").on("click", function(e) { e.preventDefault();
				tmssPopup("<?= $vew_lang->specialties; ?>","?prg=hltspc&prm_vewcod=VEW_HLT_SPC_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[spctxt:spctxt],[spccod:spccod]");
			});
		});
		
		// tchtxt
		tmssLoadScript("typeahead",function(){
			$("#<?= $lv_sec; ?> #tchtxt").typeahead({
				onSelectAjaxData: function(data){
					$("#<?= $lv_sec; ?> #tchcod").prop("value", data.data.tchcod); },
				ajax: {
					url: "?prg=edutch&act=18",
					displayField: "tchtxt",
					valueField: "tchtxt",
					timeout: 500,	triggerLength: 1,	method: "get", loadingClass: "fas fa-spinner",
					preDispatch: function(query){ return {prm_tchtxt: query}; },
					preProcess: function(data){ return (data.length==0?false:data); }
				}
			}).next().next("span").children("a:first").on("click", function(e) { e.preventDefault();
				tmssPopup("<?= $vew_lang->teachers; ?>","?prg=edutch&prm_vewcod=VEW_EDU_TCH_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[tchtxt:tchtxt],[tchcod:tchcod]");
			});
		});
		
		// stutxt
		tmssLoadScript("typeahead",function(){
			$("#<?= $lv_sec; ?> #stutxt").typeahead({
				onSelectAjaxData: function(data){
					$("#<?= $lv_sec; ?> #stucod").prop("value", data.data.stucod); },
				ajax: {
					url: "?prg=edustu&act=18",
					displayField: "stutxt",
					valueField: "stutxt",
					timeout: 500,	triggerLength: 1,	method: "get", loadingClass: "fas fa-spinner",
					preDispatch: function(query){ return {prm_stutxt: query}; },
					preProcess: function(data){ return (data.length==0?false:data); }
				}
			}).next().next("span").children("a:first").on("click", function(e) { e.preventDefault();
				tmssPopup("<?= $vew_lang->students; ?>","?prg=edustu&prm_vewcod=VEW_EDU_STU_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[stutxt:stutxt],[stucod:stucod]");
			});
		});
		
		// curcod
		$("#<?= $lv_sec; ?> #curcod").next("span").children("a:first").on("click", function(e) { e.preventDefault();
			tmssPopup("Pacientes","?prg=admcur&prm_vewcod=VEW_ADM_CUR_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[curcod:curcod]");
		});
	</script>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $("#<?= $lv_sec; ?>_frm"), "<?= $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="09") {
					toastr.info("Documento contabilizado.");
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    });
		
		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			if ( lp_prm["action"]=="14" ) {
				BootstrapDialog.confirm({
					title: "<?= $vew_lang->delete; ?>",
					message: "ATENCION: Este documeno se encuentra contabilizado.<br>¿Desea borrarlo?",
					type: BootstrapDialog.TYPE_WARNING,
					callback: function(result) { if(result) { <?= $lv_sec; ?>_fnc({action: "04"}); } }
				});
				return false;
			
			} else if ( lp_prm["action"]=="00" ) {
				var lv_opnsrvids = "";
				$("#<?= $lv_sec; ?> #edutchlqddet #opnsrvchk:checked").each(function(){lv_opnsrvids+=$(this).data("refobjcod001")+"_"+$(this).data("refobjcod002")+"|";});
				$("#<?= $lv_sec; ?> #opnsrvids").text(lv_opnsrvids);
				var lv_opnexpids = "";
				$("#<?= $lv_sec; ?> #edutchlqddet #opnexpchk:checked").each(function(){lv_opnexpids+=$(this).data("refobjcod001")+"_"+$(this).data("refobjcod002")+"|";});
				$("#<?= $lv_sec; ?> #opnexpids").text(lv_opnexpids);
			}
			
			gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
			var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':($vew_actcod=='01'?'01':'03')); ?>":gv_<?= $lv_sec; ?>_last_action);
			tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
		}

		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>
</section>
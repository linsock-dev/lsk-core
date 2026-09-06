<?php		
	// url del formulario
  $lv_lnk = '?prg=hltprslqd&prm_hltprslqdcod='.$vew_data->hltprslqdcod;

	// campos requeridos
	$vew_input->RequiredFields( array('hltprslqddte','hltprslqdtxt','prstxt', 'prscod','hltprslqdstrdte','hltprslqdenddte', 'docsts') );

	// clave del documento
	$lv_dockey = $vew_data->hltprslqdcod;

	// titulo
	$lv_title = $vew_lang->liquidation;
	
	// modulo y programa
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'LQM';

	// libreria de estilos bootstrap
	include_once('_library.frm');
	
	// valores x default
	if ( $vew_data->hltprslqdcod=='' && $vew_readonly==false ) {
		$vew_data->hltprslqddte = date('d/m/Y');
		$vew_data->docsts = 'A';
		
		$lv_curdte = new DateTime( date('Y-m-d') );
    $lv_strdte = new DateTime(date('Y-m-d'));
    $lv_enddte = new DateTime(date('Y-m-d'));
    $lv_strdte->modify('first day of last month');
    $lv_enddte->modify('last day of last month');

		$vew_data->hltprslqdstrdte = $lv_strdte->format('d/m/Y');
		$vew_data->hltprslqdenddte = $lv_enddte->format('d/m/Y');		
	} else {
		$vew_data->hltprslqdstrdte = $vew_doc->getTagValue($vew_data->hltprslqdatr001,'strdte');
		$vew_data->hltprslqdenddte = $vew_doc->getTagValue($vew_data->hltprslqdatr001,'enddte');
	}
	
	//$lv_prnfrm = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'print_form');	

	/* botones */
	$vew_tbl['cpy'] = array('per'=>false);
	$vew_tbl['accL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'09'), 'acc'=>$lv_sec.'_accounting();');
	$vew_tbl['accR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'09'), 'acc'=>$lv_sec.'_accounting();');	
	$vew_tbl['modL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
	$vew_tbl['modR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
	$vew_tbl['del'] = array('per'=>($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly && $vew_data->docsts!='C') || ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'14') && $vew_readonly && $vew_data->docsts=='C'), 'acc'=>$lv_sec.'_fnc({action:`14`});' );
	//$vew_tbl['delsep'] = array('per'=>($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly && $vew_data->docsts!='C'));
	$vew_tbl['dataL'] = array('pos'=>'L', 'per'=>true, 'id'=>'btndata', 'ttl'=>$vew_lang->data, 'icn'=>'fas fa-sync-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnRead tmss-desk-btn', 'acc'=>'');
	$vew_tbl['dataR'] = array('pos'=>'R', 'per'=>true, 'id'=>'btndata', 'ttl'=>$vew_lang->data, 'icn'=>'fas fa-sync-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnRead tmss-mob-btn', 'acc'=>'');
	//$vew_tbl['delaccL'] = array('pos'=>'L', 'per'=>($vew_data->docsts=='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'14')), 'id'=>'', 'ttl'=>$vew_lang->delete, 'icn'=>'fas fa-trash-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'acc'=>$lv_sec.'_fnc({action: "14"});');
	//$vew_tbl['delaccR'] = array('pos'=>'R', 'per'=>($vew_data->docsts=='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'14')), 'id'=>'', 'ttl'=>$vew_lang->delete, 'icn'=>'fas fa-trash-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn', 'acc'=>$lv_sec.'_fnc({action: "14"});');
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
				<li class="pull-right"><h4># <strong><?= $vew_data->hltprslqdcod; ?><input type="hidden" id="hltprslqdcod" name="hltprslqdcod" value="<?= $vew_data->hltprslqdcod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
								<div class="card-header">
									<div class="card-title"><?= $vew_lang->liquidation; ?>
										<span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                    <?= gethtml('sysdocclstxt','hidden',$vew_data->sysdoccls->sysdocclstxt); ?>
                    <?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
									</div>
								</div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('hltprslqddte', 'docdte', $vew_data->hltprslqddte, ($vew_data->hltprslqdcod==''?$lv_default:$lv_always_disabled) ) ));
                    echo vew_boot($lv_col255, array('label'=>$vew_lang->period,
                                                    'input1'=>vew_boot($lv_col12, array('input'=>gethtml('hltprslqdstrdte', 'docdte', $vew_data->hltprslqdstrdte, ($vew_data->hltprslqdcod==''?$lv_default:$lv_always_disabled) ) )),
                                                    'input2'=>vew_boot($lv_col12, array('input'=>gethtml('hltprslqdenddte', 'docdte', $vew_data->hltprslqdenddte, ($vew_data->hltprslqdcod==''?$lv_default:$lv_always_disabled) ) ))
                                                  ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hltprslqdtxt', 'doccmt1x50', $vew_data->hltprslqdtxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->provider,
                                                    'input'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->hltprslqdcod==''?$vew_readonly:true) ),
                                                                        array('input'=>gethtml('prstxt', 'doccmt1x50', $vew_data->prstxt, ($vew_data->hltprslqdcod==''?$lv_default:$lv_always_disabled) ) )) ));
                    echo gethtml('prscod','hidden',$vew_data->prscod);                  
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->financial,
                                                    'input'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->hltprslqdcod==''?$vew_readonly:true)),
                                                                        array('input'=>gethtml('custxt', 'doccmt1x50', $vew_data->custxt, ($vew_data->hltprslqdcod==''?$lv_default:$lv_always_disabled) ) )) ));                          
                    echo gethtml('cuscod','hidden',$vew_data->cuscod);
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', ($vew_data->docsts=='C'?'docstsacc':'docsts'), $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div> <!-- /card -->
						</div> <!-- /col-md-6 -->
					</div> <!-- /row -->
				</div> <!-- /_tab001 -->

				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<div id="hltprslqddet"></div>
				</div> <!-- /tab-pane -->
	
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
    // AUDITORIA. datos adicionales para pantalla de auditoria
    <?php if( $vew_data->accusr!='' ){
			echo 'var lv_'.$lv_sec.'_infusrdat=[{"infttl":"'.$vew_lang->accountedby.'","infdat":"'.$vew_data->accusr.'"},{"infttl":"'.$vew_lang->accounteddate.'","infdat":"'.(gettype($vew_data->accdte) == 'object' ? ($vew_data->accdte)->format('d-m-Y h:i:s') : $vew_data->accdte).'"}];';
    } ?>    
	
		function <?= $lv_sec; ?>_calcTotal() {
			var lv_qtysrv = 0;
			var lv_totsrv = 0;
			var lv_tottme = 0;
      var lv_totqty = 0;
			$("#<?= $lv_sec; ?> #hltprslqddet #opnsrvchk:checked").each(function(){
        lv_qtysrv++; 
        lv_totsrv+=Number($(this).data("refobjtot"));
        lv_tottme+=Number($(this).data("tme"));
        lv_totqty+=Number($(this).data("qty"));
      });
			$("#<?= $lv_sec; ?> #hltprslqddet #opnsrvtme").prop("value", lv_tottme);
			$("#<?= $lv_sec; ?> #hltprslqddet #opnsrvses").prop("value", lv_totqty);
			$("#<?= $lv_sec; ?> #hltprslqddet #opnsrvtot").prop("value", lv_totsrv);
			$("#<?= $lv_sec; ?> #hltprslqddet .opnsrvbdg").text((lv_qtysrv==0?"":lv_qtysrv));
			var lv_qtyexp = 0;
			var lv_totexp = 0;
			$("#<?= $lv_sec; ?> #hltprslqddet #opnexpchk:checked").each(function(){lv_qtyexp++; lv_totexp+=Number($(this).data("refobjtot"));});
			$("#<?= $lv_sec; ?> #hltprslqddet #opnexptot").prop("value", lv_totexp);		
			$("#<?= $lv_sec; ?> #hltprslqddet .opnexpbdg").text((lv_qtyexp==0?"":lv_qtyexp));
			
			$("#<?= $lv_sec; ?> #hltprslqddet #hltprslqdtot").text( Number(lv_totsrv+lv_totexp).toFixed(2) );		
		}
		
		// DATOS
		$("#<?= $lv_sec; ?> #btndata").on("click", function(e) { e.preventDefault(); 
			// valido datos minimos
			if ( tmssCheckRequiredFields( $("#<?= $lv_sec; ?>_frm") )==false ) { return false;}
			// cambiar tab
			$("#<?= $lv_sec; ?> a[href='#<?= $lv_sec; ?>_tab002']").trigger("click");
			// obtener datos
      var lv_pstdat ={prscod: $("#<?= $lv_sec; ?> #prscod").prop("value"),
                      cuscod: $("#<?= $lv_sec; ?> #cuscod").prop("value"),
                      hltprslqdcod: $("#<?= $lv_sec; ?> #hltprslqdcod").prop("value"),
                      hltprslqdstrdte: $("#<?= $lv_sec; ?> #hltprslqdstrdte").prop("value"),
                      hltprslqdenddte: $("#<?= $lv_sec; ?> #hltprslqdenddte").prop("value"),
                      sysdocclscod: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value"),
                      token: "<?= $lv_sec; ?>" };
			tmssCallProcess("<?= ($vew_readonly?'?prg=hltprslqd&act=13':'?prg=hltprslqd&act=11'); ?>",lv_pstdat,function(data){
				if (data.substring(0,10)=="/*script*/") { eval(data); } else {
					$("#<?= $lv_sec; ?> #hltprslqddet").html(data); 
					$("#<?= $lv_sec; ?> #prstxt").prop("readonly","readonly").next().next().addClass("hidden").parent().removeClass("input-group");
					$("#<?= $lv_sec; ?> #hltprslqdstrdte").prop("readonly","readonly");
					$("#<?= $lv_sec; ?> #hltprslqdenddte").prop("readonly","readonly");
          
          <?php if($vew_readonly){ ?> 
        		$("#<?= $lv_sec; ?> #hltlqdcatpts").val(<?= $vew_data->hltlqdcatpts; ?>);
        		$("#<?= $lv_sec; ?> #hltlqdcatprc").val(<?= $vew_data->hltlqdcatprc; ?>);
          <?php } ?>
          
					// adjunto eventos
					$("#<?= $lv_sec; ?> #hltprslqddet input:checkbox").on("change",function(e){ 
            if($(this).is($(this).parents("table").find(":checkbox:first"))){ 
              $(this).parents("table").find(":checkbox").prop("checked", $(this).prop("checked"));
            }else{
              $(this).parents("table").find(":checkbox:first").prop("checked", $(this).parents("table").find(":checkbox:not(:first):checked").length-1 == $(this).parents("table").find(":checkbox:not(:first)").length-1);
            }
						<?= $lv_sec; ?>_calcTotal();
					});
          
          $("#<?= $lv_sec; ?> #hltprslqddet table").each(
            function(){  
              $(this).find("thead :checkbox").prop("checked", $(this).find("tbody :checkbox:checked").length == $(this).find("tbody :checkbox").length && $(this).find("tbody :checkbox").length);
           });
          
					<?= $lv_sec; ?>_calcTotal();
				}
			});
		})
		
		// CONTABILIZAR
		function <?= $lv_sec; ?>_accounting() {
			BootstrapDialog.confirm({
				title: "<?= $vew_lang->accounting; ?>",
				message: "�Desea contabilizar el documento?",
				type: BootstrapDialog.TYPE_WARNING,
				callback: function(result) { if(result) { <?= $lv_sec; ?>_fnc({action: "09"}); } }
			});
		}
		
		<?php if ($vew_data->hltprslqdcod!='') { ?>
    $(function(){
			$("#<?= $lv_sec; ?> #btndata").trigger("click");
    });
		<?php } ?>
	</script>
	<script>
    // custxt
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"custxt" : "custxt", "cuscod" : "cuscod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #custxt"), "slscus", lo_get);    
    
		// prstxt
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"prstxt" : "prstxt", "prscod" : "prscod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #prstxt"), "hltprs", lo_get);     
	</script>
  <script>
		// server response ext
    function <?= $lv_sec; ?>_fncbckext( data ) {
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
			if ( lp_prm["action"]=="14" ) {
				var lv_sts = $("#<?= $lv_sec; ?> #docsts").val().toUpperCase();
				BootstrapDialog.confirm({
					title: "<?= $vew_lang->delete; ?>",
					message: (lv_sts=="C"?"ATENCION: Este documeno se encuentra contabilizado.<br>":"")+"Desea borrar el documento?",
					type: BootstrapDialog.TYPE_WARNING,
					callback: function(result) { if(result) { <?= $lv_sec; ?>_fnc({action: "04"}); } }
				});
				return false;
			
			} else if ( lp_prm["action"]=="00" ) {
				var lv_opnsrvids = "";
				$("#<?= $lv_sec; ?> #hltprslqddet #opnsrvchk:checked").each(function(){lv_opnsrvids+=$(this).data("refobjcod001")+"_"+$(this).data("refobjcod002")+"|";});
				$("#<?= $lv_sec; ?> #opnsrvids").text(lv_opnsrvids);
				var lv_opnexpids = "";
				$("#<?= $lv_sec; ?> #hltprslqddet #opnexpchk:checked").each(function(){lv_opnexpids+=$(this).data("refobjcod001")+"_"+$(this).data("refobjcod002")+"|";});
				$("#<?= $lv_sec; ?> #opnexpids").text(lv_opnexpids);
			}
		}
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
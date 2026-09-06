<?php
	/* url del formulario */
  $lv_lnk = '?prg=hltprslqdaut&prm_hltprslqdgrpcod='.$vew_data->hltprslqdgrpcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('hltprslqdgrpdte','hltprslqdgrptxt','hltprslqdgrpstrdte','hltprslqdgrpenddte', 'docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->hltprslqdgrpcod;

	/* titulo */
	$lv_title = $vew_lang->liquidation;
	
	/* m�dulo y programa */
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'LQA';
	
	/* librer�a de estilos bootstrap */
	include_once('_library.frm');
	
	/* valores x default */
	if ( $vew_data->hltprslqdgrpcod=='' && $vew_readonly==false ) {
		$vew_data->hltprslqdgrpdte = date('d/m/Y');
		$vew_data->docsts = 'A';
		
		$lv_curdte = new DateTime( date('Y-m-d') );
    $lv_strdte = new DateTime(date('Y-m-d'));
    $lv_enddte = new DateTime(date('Y-m-d'));
    $lv_strdte->modify('first day of this month');
    $lv_enddte->modify('last day of this month');

		$vew_data->hltprslqdgrpstrdte = $lv_strdte->format('d/m/Y');
		$vew_data->hltprslqdgrpenddte = $lv_enddte->format('d/m/Y');		
	} 
	
	$lv_prnfrm = $vew_doc->getTagValue($vew_data->lqdsysdoccls->sysdocclsatr,'print_form');	
	$lv_grpcuscod = $vew_doc->getTagValue($vew_data->lqdsysdoccls->sysdocclsatr,'grpcuscod');	

	/* botones */
	$vew_tbl['cpy'] = array('per'=>false);
	$vew_tbl['accL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'09'), 'id'=>'btnacc', 'acc'=>'');
	$vew_tbl['accR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'09'), 'id'=>'btnacc', 'acc'=>'');	
	$vew_tbl['modL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
	$vew_tbl['modR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
	$vew_tbl['del'] = array('per'=>($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly && $vew_data->docsts!='C'));
	$vew_tbl['delsep'] = array('per'=>($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly && $vew_data->docsts!='C'));	
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

 	<!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<textarea id="opnlqdids" name="opnlqdids" class="hidden"></textarea>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hltprslqdgrpcod; ?><input type="hidden" id="hltprslqdgrpcod" name="hltprslqdgrpcod" value="<?= $vew_data->hltprslqdgrpcod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $vew_lang->liquidation; ?> 
										<span class="tmss-card-icon">
                      <span style="padding-right: 5px;"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                      <i class="fas fa-cogs"></i>
                    </span>
                    <input type="hidden" id="sysdocclscod" name="sysdocclscod" value="<?= $vew_data->sysdoccls->sysdocclscod; ?>">
									</div>
								</div>
                
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 		'input'=>gethtml('hltprslqdgrpdte', 'docdte', $vew_data->hltprslqdgrpdte, ($vew_data->hltprslqdgrpcod==''?$lv_default:$lv_always_disabled) ) ));
                    echo vew_boot($lv_col255, array('label'=>$vew_lang->period,
                                                    'input1'=>vew_boot($lv_col12, array('input'=>gethtml('hltprslqdgrpstrdte', 'docdte', $vew_data->hltprslqdgrpstrdte, ($vew_data->hltprslqdgrpcod==''?$lv_default:$lv_always_disabled) ) )),
                                                    'input2'=>vew_boot($lv_col12, array('input'=>gethtml('hltprslqdgrpenddte', 'docdte', $vew_data->hltprslqdgrpenddte, ($vew_data->hltprslqdgrpcod==''?$lv_default:$lv_always_disabled) ) ))
                                                  ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hltprslqdgrptxt', 'doccmt1x50', $vew_data->hltprslqdgrptxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', ($vew_data->docsts=='C'?'docstsacc':'docsts'), $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div> <!-- card -->
						</div> <!-- col-md-6 -->
            
						<div class="col-md-6">
              <div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $vew_lang->data; ?> 
                    <span class="tmss-card-icon"> 
                    	<b><span id="hltprslqdtot"></span></b>
                    </span>
                  </div>
								</div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                  	if($lv_grpcuscod){
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->financial,
                                                      'input'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->hltprslqdcod==''?$vew_readonly:true)),
                                                                          array('input'=>gethtml('custxt', 'doccmt1x50', $vew_data->custxt, ($vew_data->hltprslqdcod==''?$lv_default:$lv_always_disabled) ) )) ));                          
                      echo gethtml('cuscod','hidden',$vew_data->cuscod);
                    }
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->paymentmode, 	'input'=>gethtml('paymthcod', 'tsrpytmth_lst',	$vew_data->paymthcod, $lv_default) )); 
                   
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->class,
                                                    'input'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->hltprslqdcod==''?$vew_readonly:true)),
                                                                        array('input'=>gethtml('sysdocclstxt', 'doccmt1x50', $vew_data->sysdocclstxtprs, ($vew_data->hltprslqdcod==''?$lv_default:$lv_always_disabled) ) )) ));       
                  	echo gethtml('sysdocclscodprs','hidden',$vew_data->sysdocclscodprs);
                  ?>
                </div>
              </div> <!-- card -->
						</div> <!-- col-md-6 -->
					</div> <!-- row -->
          <div class="row">
            <div class="col-md-12">
              <div class="card"> 
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->liquidations; ?> 
                    <a class="card-icon text-center tmssHiddeOnRead" id="btndata" title="<?= $vew_lang->data; ?>"><i class="fas fa-sync-alt"></i></a>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
									<div id="hltprslqdautdet"></div>
                </div>
              </div>
            </div>
          </div>
				</div> <!-- fin _tab001 -->
	
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
		$(function(){
			if(<?= $vew_data->hltprslqdgrpcod!=''?'true':'false'?>){
        $("#<?=$lv_sec;?> #btndata").trigger("click");}
		});
	
    // custxt
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"custxt" : "custxt", "cuscod" : "cuscod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #custxt"), "slscus", lo_get);    
    
    // sysdocclstxt
    var lo_get = {"fldsec":"<?=$lv_sec;?>","fldasg":{"sysdocclscodprs":"sysdocclscod", "sysdocclstxt":"sysdocclstxt"}, "fldflt":{"objtyp":"HLT_PRS"}};
    tmssTypeahead($("#<?=$lv_sec;?> #sysdocclstxt"),"sysdoccls",lo_get);
	
		function <?= $lv_sec; ?>_calcTotal() { 
			var lv_qtylqd = 0;
			var lv_totlqd = 0;
			$("#<?= $lv_sec; ?> #hltprslqdautdet #opnlqdchk<?= $vew_readonly?'':':checked'; ?>").each(function(){lv_qtylqd++; lv_totlqd+=Number($(this).data("objtot"));});
			$("#<?= $lv_sec; ?> #hltprslqdautdet #opnlqdtot").prop("value", lv_totlqd);
			$("#<?= $lv_sec; ?> #hltprslqdautdet .opnlqdbdg").text((lv_qtylqd==0?"":lv_qtylqd));
			$("#<?= $lv_sec; ?> #hltprslqdtot").text( Number(lv_totlqd).toFixed(2) );		
		}
		
		// DATOS
		$("#<?= $lv_sec; ?> #btndata").on("click", function(e) { e.preventDefault();
			// valido datos m�nimos
			if ( tmssCheckRequiredFields( $("#<?= $lv_sec; ?>_frm") )==false ) { return false;}
			// cambiar tab
			$("#<?= $lv_sec; ?> a[href='#<?= $lv_sec; ?>_tab002']").trigger("click");
			// obtener datos
      lv_pstdat =[{"name":"hltprslqdgrpcod", "value":$("#<?= $lv_sec; ?> #hltprslqdgrpcod").prop("value")},
									{"name":"hltprslqdgrpstrdte", "value":$("#<?= $lv_sec; ?> #hltprslqdgrpstrdte").prop("value")},
									{"name":"hltprslqdgrpenddte", "value":$("#<?= $lv_sec; ?> #hltprslqdgrpenddte").prop("value")},
									{"name":"sysdocclscod", "value":$("#<?= $lv_sec; ?> #sysdocclscod").prop("value")},
									{"name":"paymthcod", "value":$("#<?= $lv_sec; ?> #paymthcod").prop("value")},
									{"name":"bnkcod", "value":$("#<?= $lv_sec; ?> #bnkcod").prop("value")},
									{"name":"cuscod", "value":$("#<?= $lv_sec; ?> #cuscod").prop("value")},
									{"name":"grpcuscod","value":"<?= $lv_grpcuscod; ?>"},
                  {"name":"sysdocclscodprs","value":$("#<?=$lv_sec;?> #sysdocclscodprs").prop("value")},
									{"name":"token", "value":"<?= $lv_sec; ?>" }];
      tmssCallProcess("?prg=hltprslqdaut&act=<?= ($vew_readonly?'11':'10'); ?>&prm_bcksec=<?= $lv_sec; ?>", lv_pstdat, function(data){
				$("#<?= $lv_sec; ?> #hltprslqdautdet").html(data); 
				$("#<?= $lv_sec; ?> #hltprslqdgrpstrdte").prop("readonly","readonly");
				$("#<?= $lv_sec; ?> #hltprslqdgrpenddte").prop("readonly","readonly");
        
				<?= $lv_sec; ?>_calcTotal();
				
        // adjunto eventos
        $("#<?= $lv_sec; ?> #hltprslqdautdet input:checkbox").on("change",function(e){
					// marca todos los check
          if ( $(this).prop("id")=="opnlqdchkhdr" ) { 
            $("#<?= $lv_sec; ?> #hltprslqdautdet #opnlqdchk").prop("checked", $(this).is(":checked") ); 
          }else{
            $("#<?= $lv_sec; ?> #hltprslqdautdet #opnlqdchkhdr").prop("checked", $("#<?= $lv_sec; ?> #hltprslqdautdet #opnlqdchk:checked").length == $("#<?= $lv_sec; ?> #hltprslqdautdet #opnlqdchk").length ); 
          }	
          
          <?= (!$vew_readonly ? $lv_sec.'_calcTotal();' : ''); ?>
				});		
        
        $("#<?= $lv_sec; ?> #opnlqdchkhdr").prop("checked", $("#<?= $lv_sec; ?> #hltprslqdautdet #opnlqdchk:checked").length == $("#<?= $lv_sec; ?> #hltprslqdautdet #opnlqdchk").length && $("#<?= $lv_sec; ?> #hltprslqdautdet #opnlqdchk").length); 
			});
		})
		
    
		// CONTABILIZAR
		$("#<?= $lv_sec; ?> #btnacc").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm({
				title: "<?= $vew_lang->accounting; ?>",
				message: "�Desea contabilizar el documento?",
				type: BootstrapDialog.TYPE_PRIMARY,
				callback: function(result) { if(result) { <?= $lv_sec; ?>_fnc({action: "09"}); } }
			});
		});
		
    function <?= $lv_sec; ?>_GridRefresh(){
			<?= $lv_sec; ?>_fnc({action: "99"});
		}
	</script>
  <script>
  	function <?= $lv_sec; ?>_getMessageData(lv_msg){ 
      var lv_lqdids = "";
      ($("#<?= $lv_sec; ?> #hltprslqdautdet #opnlqdchk:checked").each(function(){lv_lqdids+=$(this).data("hltprslqdcod")+"|";}));
      return JSON.stringify({"hltprslqdcod": lv_lqdids});
    }
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
			if ( lp_prm["action"]=="00" ) {
				var lv_opnlqdids = "";
				$("#<?= $lv_sec; ?> #hltprslqdautdet #opnlqdchk:checked").each(function(){lv_opnlqdids+=$(this).data("prscod")+"|";});
				$("#<?= $lv_sec; ?> #opnlqdids").text(lv_opnlqdids);
			}
		}
  </script>
	<!-- Form Submit -->
	<?php include('grldocfrmscr.frm'); ?>
</section> 
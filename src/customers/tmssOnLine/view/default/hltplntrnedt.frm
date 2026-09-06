<?php	
	// url del formulario
  $lv_lnk = '?prg=hltplntrn&prm_popup='.$vew_data->popup;

	// campos requeridos
	$vew_input->RequiredFields( array('plndte','plndteto','patcod','pattxt','spccod','spctxt','docsts','deltxt','prstxt') );

	// clave del documento
	$lv_dockey = $vew_data->plnid;
	$lv_dockey002 = $vew_data->plndteid;

	// titulo
	$lv_title = $vew_lang->turn;
	
	// módulo y programa
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PLT';	
	
	$vew_actcod = ($vew_data->evlcod!=''?'03':$vew_actcod);
	if ( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,$vew_actcod)==false ) { $vew_actcod = '03'; }
	
	// librería de estilos bootstrap
	include_once('_library.frm');

  // Botones de vista */
	$vew_tbl['nxt'] = array('per'=>false);
	$vew_tbl['new'] = array('per'=>false);
  $vew_tbl['modL'] = array('per'=>(  $vew_data->evlcod!='' ? false : $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02') ));
	$vew_tbl['rfrsh'] = array('pos'=>'D', 'per'=>true, 'ttl'=>$vew_lang->refresh, 'id'=>'', 'icn'=>'fas fa-sync-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'99'.chr(39).'});'); 	
	$vew_tbl['del'] = array('per'=>true);
	$vew_tbl['cpy'] = array('per'=>false);
	$vew_tbl['canc'] = array('acc'=>'tmssTabSecCls($('.chr(39).'#'.$lv_sec.chr(39).'));');
	$vew_tbl['clsL'] = array('acc'=>'tmssTabSecCls($('.chr(39).'#'.$lv_sec.chr(39).'));');
	$vew_tbl['clsR'] = array('acc'=>'tmssTabSecCls($('.chr(39).'#'.$lv_sec.chr(39).'));');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod', 'hidden', '' ) ?> 	
    <?= gethtml('spcfrm', 'hidden',   $vew_data->spc->spcfrm) ?> 				
    <?= gethtml('docsts', 'hidden',  ($vew_data->docsts==''?'A':$vew_data->docsts)) ?> 				
		<?= gethtml('plnid','hidden',$vew_data->plnid); ?>
		<?= gethtml('plndteid','hidden',$vew_data->plndteid); ?>
		<?= gethtml('plndte','hidden',date_format($vew_data->plndte,'d/m/Y')); ?>
		<?= gethtml('plndteto', 'hidden', ($vew_data->plndteto==''?'':date_format($vew_data->plndteto,'d/m/Y'))); ?>		
		<?= gethtml('plninbdte','hidden',date_format($vew_data->plninbdte,'H:i')); ?>
		<?= gethtml('plnoutdte','hidden',date_format($vew_data->plnoutdte,'H:i')); ?> 
		
		<div class="container-fluid">
			<div class="row">
				<div class="col-md-6">
					<div class="card">
						<div class="card-header">
							<div class="card-title"><?= $vew_lang->turn; ?>
								<span class="card-icon"><?= $vew_data->sysdoccls->sysdocclstxt; ?>
									<?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
								</span>
							</div>
						</div>
						<div class="card-body">
							<?php
								$lv_dayarr = Array('Lunes','Martes','Miercoles','Jueves','Viernes','Sabado','Domingo');
								echo vew_boot($lv_col210, array('label'=>$vew_lang->schedule, 
																								'input'=>gethtml('','doccmt1x50',strtoupper($lv_dayarr[ date_format($vew_data->plndte,'N')-1 ]).' '
																																				.date_format($vew_data->plndte,'d/m/Y').' '
																																				.date_format($vew_data->plninbdte,'H:i').' - '
																																				.date_format($vew_data->plnoutdte,'H:i')
																																,$lv_always_disabled) )); 
								
								echo vew_boot($lv_col210, array('label'=>$vew_lang->patient, 
																								'input1'=>vew_boot(  array('style'=>'custom', 'readonly'=>$vew_readonly),
																																		 array('custom'=>($vew_data->evlcod==''?'<span class="input-group-btn"><a href="#" class="btn btn-default">&nbsp;<span class="fas fa-search"></span></a>'.($vew_sec->hasPermission('HLT','PAT','01') ? '<a href="#" id="btnpatadd" class="btn btn-default '.($vew_data->patcod==''?'':'hidden').'">&nbsp;<span class="fas fa-plus"></span></a>' : '' ).($vew_sec->hasPermission('HLT','PAT','02') ? '<a href="#" id="btnpatedt" class="btn btn-default '.($vew_data->patcod!=''?'':'hidden').'">&nbsp;<span class="fas fa-pencil-alt"></span></a>' : '' ).'</span>':''),
																																					 'input'=>gethtml('pattxt', 'typeahead', $vew_data->pat->pattxt,$lv_default))) ));
								echo gethtml('patcod', 'hidden', $vew_data->pat->patcod);
								
								// FINANCIADOR --------------------------------
								if($vew_data->pat->patcod == '' || $vew_data->plnid != ''){
									echo vew_boot($lv_col210, array('label'=>$vew_lang->financial, 
																									'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
																																			array('input'=>gethtml('custxt', 'custxt', $vew_data->custxt, $lv_always_disabled) )) ));
									echo gethtml('cuscod', 'hidden', $vew_data->cuscod);       
								}else{
									echo vew_boot($lv_col210, array('label'=>$vew_lang->financial, 
																									'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
																																			array('input'=>gethtml('custxt', 'custxt', $vew_data->pat->custxt, $lv_always_disabled) )) ));
									echo gethtml('cuscod', 'hidden', $vew_data->pat->cuscod);                 
								}
								// --------------------------------------------
								echo vew_boot($lv_col210, array('label'=>$vew_lang->provider, 
																								'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
																																		array('input'=>gethtml('prstxt', 'typeahead', $vew_data->prs->prstxt,($vew_data->evlcod!=''?$lv_always_disabled:$lv_default)) )) ));
								echo gethtml('prscod', 'hidden', $vew_data->prs->prscod); 
								
								echo vew_boot($lv_col210, array('label'=>$vew_lang->place, 			
																								'input'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->del->deltxt== '' )? $vew_readonly : 	$lv_always_disabled), 
																																		array('input'=>gethtml('deltxt', 'typeahead', $vew_data->del->deltxt,($vew_data->del->deltxt== '' )? $lv_default : 	$lv_always_disabled) )) ));
            
								echo gethtml('delcod', 'hidden', $vew_data->del->delcod); 
								
								echo vew_boot($lv_col210, array('label'=>$vew_lang->specialty, 	
																								'input'=>gethtml('spctxt', 'typeahead', $vew_data->spc->spctxt,	$lv_always_disabled) ));
								echo gethtml('spccod', 'hidden', $vew_data->spc->spccod); 
								
								echo vew_boot( array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->overturn,	
																																			 'input'=>gethtml('hltplndteatrdayful', 'checkbox', ( ($vew_data->plnid=='' && $vew_data->dayful!='') || $vew_doc->getTagValue($vew_data->plndteatr,'dayful')!=''? 1 :''), 	$lv_default) ));
							?>
						</div>
					</div>
				</div> <!-- /col-md-9 -->
				<div class="col-sm-6 col-md-3">
					<div class="card">
						<div class="card-header"><div class="card-title"><?= $vew_lang->comments; ?></div></div>
						<div class="card-body">
							<?= gethtml("plncmt", "doccmt5x50",	$vew_data->plncmt, $lv_default); ?>
						</div>
					</div>
				</div>
				<div class="col-sm-6 col-md-3">
					<div class="card">
						<div class="card-header">
							<div class="card-title"><?= $vew_lang->activities; ?>
								<span class="tmss-card-icon"><small>#<?= $vew_data->plnid .'/'. $vew_data->plndteid; ?></small></span>
							</div>
						</div>
						<div class="card-body tmss-card-body-edit">
							<a href="#" class="card-opt-body text-left <?= ($vew_doc->getTagValue($vew_data->plndteatr,'plntrnrec')!=''?'bg-primary':''); ?>" <?= ($vew_data->plndteid=='' || !$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'11') || $vew_doc->getTagValue($vew_data->plndteatr,'plntrnrec')!='' || $vew_data->evlcod!='' ? '' : 'id="btnrec"' ); ?> ><i class="far fa-hospital" style="min-width:25px;"></i> Recepcionar <span class="pull-right tmss-bold"><?= $vew_doc->getTagValue($vew_data->plndteatr,'plntrnrec'); ?></span></a>
							<a href="#" class="card-opt-body text-left <?= ($vew_doc->getTagValue($vew_data->plndteatr,'plntrncal')!=''?'bg-primary':''); ?>" <?= ($vew_data->plndteid=='' || !$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'12') || $vew_doc->getTagValue($vew_data->plndteatr,'plntrncal')!='' || $vew_data->evlcod!='' ? '' : 'id="btncal"' ); ?> ><i class="fas fa-sign-in-alt" style="min-width:25px;"></i> Llamar <span class="pull-right tmss-bold"><?= $vew_doc->getTagValue($vew_data->plndteatr,'plntrncal'); ?></span></a>
							<a href="#" class="card-opt-body text-left <?= ($vew_doc->getTagValue($vew_data->plndteatr,'plntrnatn')!=''?'bg-primary':''); ?>" <?= ($vew_data->plndteid=='' || !$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'15') || $vew_doc->getTagValue($vew_data->plndteatr,'plntrnatn')!='' || $vew_data->evlcod!='' ? '' : 'id="btnatn"' ); ?> ><i class="fas fa-handshake" style="min-width:25px;"></i> Atender <span class="pull-right tmss-bold"><?= $vew_doc->getTagValue($vew_data->plndteatr,'plntrnatn'); ?></span></a>
							<a href="#" class="card-opt-body text-left <?= ($vew_data->evlcod!=''?'bg-primary':''); ?>" <?= ($vew_data->plndteid=='' || ($vew_data->evlcod=='' && !$vew_sec->hasPermission('HLT','EVL','01')) || ($vew_data->evlcod!='' && !$vew_sec->hasPermission('HLT','EVL','03'))? '' : 'id="btnevl"' ); ?> ><i class="fas fa-file-medical" style="min-width:25px;"></i> Evolucionar <span class="pull-right tmss-bold"><?= ($vew_data->evlcod!=''?$vew_data->evlctedte->format('H:i'):''); ?></span></a>
							<a href="#" class="card-opt-body text-left" <?= ($vew_data->plndteid=='' || !$vew_sec->hasPermission('HLT','HST','03')?'': 'id="btnhst"' ); ?> ><i class="fas fa-history" style="min-width:25px;"></i> Historia Cl&iacute;nica</a>
						</div>
					</div>
				</div> <!-- /col-md-3 -->
			</div> <!-- /row -->
		</div> <!-- /container-fluid -->
  </form>
	<style>.extra-wide-dialog .modal-dialog { width: 85vw; }</style>	
	<script>
		$("#<?= $lv_sec; ?> #btnrec").on("click",function(e){ e.preventDefault(); <?= $lv_sec; ?>_fnc({action: "11"}); });
		$("#<?= $lv_sec; ?> #btncal").on("click",function(e){ e.preventDefault(); <?= $lv_sec; ?>_fnc({action: "12"}); });
		$("#<?= $lv_sec; ?> #btnatn").on("click",function(e){ e.preventDefault(); <?= $lv_sec; ?>_fnc({action: "15"}); });
		$("#<?= $lv_sec; ?> #btnevl").on("click",function(e){ e.preventDefault();
			var lv_pstdat=[	{name:"evlcod",value:"<?= $vew_data->evlcod; ?>"},
											{name:"plnid",value:"<?= $vew_data->plnid; ?>"},
											{name:"plndteid",value:"<?= $vew_data->plndteid; ?>"},
											{name:"delcod",value:"<?= $vew_data->delcod; ?>"},
											{name:"spccod",value:"<?= $vew_data->spccod; ?>"},
											{name:"prscod",value:"<?= $vew_data->prscod; ?>"},
											{name:"patcod",value:"<?= $vew_data->patcod; ?>"},
											{name:"evlcod",value:"<?= $vew_data->evlcod; ?>"}
										];										
			var lv_frm = $("#<?= $lv_sec; ?> #spcfrm").prop("value");
			lv_frm = lv_frm.replace("&AMP;","&");
			lv_frm = lv_frm.toLowerCase();		
			if( lv_frm=="" ) { lv_frm = "?prg=hltpatevl&act=<?= ($vew_data->evlcod==''?'01':'03'); ?>"; }
      tmssCallProcess(lv_frm,lv_pstdat,function(data){
				BootstrapDialog.show({
					title: $("#<?= $lv_sec; ?> #pattxt").prop("value") + " ("+$("#<?= $lv_sec; ?> #patcod").prop("value")+")",
					message: $(data),
					size: BootstrapDialog.SIZE_WIDE,
					draggable: true,
          onhide: function(){
            <?= $lv_sec; ?>_fnc({action: '99'});
          }
				});
			});
		});
		
		$("#<?= $lv_sec; ?> #btnhst").on("click",function(e){ e.preventDefault();
			var lv_pstdat = [{name:"patcod",value:"<?= $vew_data->patcod; ?>"}];
			tmssLink("?prg=hltpathst&act=03", [{target: "_new_section", post_data: lv_pstdat}]);
		});
		
		function <?= $lv_sec; ?>_GridRefresh() {
			<?php if($vew_actcod!='01' && !$vew_readonly){ echo $lv_sec.'_fnc({action: "02"});'; } ?>
		}

		$("#<?= $lv_sec; ?> #btnpatadd").on("click",function(e){ e.preventDefault();
			<?= $lv_sec; ?>_patedt();
		});
		
		$("#<?= $lv_sec; ?> #btnpatedt").on("click",function(e){ e.preventDefault();
			<?= $lv_sec; ?>_patedt();
		});

		function <?= $lv_sec; ?>_patedt() {
			var lv_patcod = $("#<?= $lv_sec; ?> #patcod").prop("value");
			var lv_pstdat = [{name:"hltpatvew",value:"hltpatinftyp002"},{name:"patcod",value: lv_patcod},{name:"lv_sec",value:"<?= $lv_sec; ?>"}];
			tmssCallProcess("?prg=hltpat&act="+(lv_patcod==""?"01":"02"), lv_pstdat, function(data){
				BootstrapDialog.show({
					size: BootstrapDialog.SIZE_WIDE,
					title: "<?= $vew_lang->patient; ?>",
					closable: true,
					draggable: true,
					cssClass: "extra-wide-dialog",
					message: $(data),
					onhidden: function(dialogRef) {
            if(dialogRef.$modalBody.find("#patcod").length>0){
              var lv_patcod = dialogRef.$modalBody.find("#patcod").prop("value");
              var lv_pattxt = dialogRef.$modalBody.find("#pattxt").prop("value");
              var lv_custxt = dialogRef.$modalBody.find("#custxt").prop("value");
              var lv_cuscod = dialogRef.$modalBody.find("#cuscod").prop("value");
              if( lv_patcod!="" ) {
                $("#<?= $lv_sec; ?> #patcod").prop("value",lv_patcod).trigger("change");
                $("#<?= $lv_sec; ?> #pattxt").prop("value",lv_pattxt);
                $("#<?= $lv_sec; ?> #custxt").prop("value",lv_custxt);
                $("#<?= $lv_sec; ?> #cuscod").prop("value",lv_cuscod);
              }
            }
          }
				});
			});
		}
	</script>
	<script>
		$("#<?= $lv_sec; ?> #patcod").on("change", function(){
			if($(this).prop("value")==""){
				$("#<?= $lv_sec; ?> #btnpatadd").removeClass("hidden");
				$("#<?= $lv_sec; ?> #btnpatedt").addClass("hidden");			
			} else {
				$("#<?= $lv_sec; ?> #btnpatadd").addClass("hidden");
				$("#<?= $lv_sec; ?> #btnpatedt").removeClass("hidden");			
			}
		});
  </script>
	<script>    
    // PATTXT
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg": { "patcod":"patcod", "pattxt":"pattxt", "cuscod":"cuscod", "custxt":"custxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #pattxt"), "hltpattxtfnd", lo_get);

    // FINANCIADOR
    $("#<?= $lv_sec; ?> #custxt").next("span").children("a:first").on("click", function(e){ e.preventDefault;                                                                              
      tmssPopup("<?= $vew_lang->financial; ?>","?prg=grldatcnt&prm_vewcod=VEW_GRL_DAT_CNT_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldflt=[c.cntsrctyp:HLT_PAT , c.cntsrccod:"+$("#<?=$lv_sec;?> #patcod").val()+" , sysdocclsinvadratr:X]&prm_fldasg=[custxt:c.cnttxt],[cuscod:c.cntdstcod]");                                                           
    });
  	
    // LUGAR DE ATENCION
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"d.docsts":"A"}, "fldasg":{"delcod":"delcod", "deltxt":"deltxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #deltxt"), "hltdel", lo_get);
		
		// PRESTADOR
    //var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg": {"prstxt":"prstxt", "prscod":"prscod"}};
    //tmssTypeahead($("#<?= $lv_sec; ?> #prstxt"), "hltprs", lo_get);
    
    // PRESTADOR
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"p.docsts":"A", "ps.spccod" : "<?= $vew_data->spccod; ?>"}, "fldasg": {"prscod":"prscod", "prstxt":"prstxt"}};
		tmssTypeahead($("#<?= $lv_sec; ?> #prstxt"), "hltspcprs", lo_get);
     
    // SPCTXT
    //var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"p.prscod": $("#<?= $lv_sec; ?> #prscod")}, "fldasg": {"spccod":"s.spccod", "spctxt":"s.spctxt", "spcctrtyp":"s.spcctrtyp"}};
    //tmssTypeahead($("#<?= $lv_sec; ?> #spctxt"), "hltprsspc", lo_get);
	</script>
  <script>      
    // form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) { 
      // grabado - asignaciones
      if (lp_prm["action"]=="00") {
        $("#<?= $lv_sec; ?> #plndteto").prop("value", $("#<?= $lv_sec; ?> #plndte").prop("value") );
      }
     	var error = ( lp_prm["action"]=="04" && "<?= $vew_data->evlcod ?>"!="" ? true : false );
        if(error){
        	toastr.warning("No se pueden borrar planificaciones evolucionadas"); 
          return false;
        }
    }
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
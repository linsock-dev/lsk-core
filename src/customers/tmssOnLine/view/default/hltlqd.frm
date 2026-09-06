<?php
	/* url del formulario */
  $lv_lnk = "?prg=hltlqd&prm_hltlqdcod=".$vew_data->hltlqdcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('hltlqddte','hltlqdtxt','custxt', 'cuscod','hltlqdstrdte','hltlqdenddte', 'docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->hltlqdcod;

	/* titulo */
	$lv_title = $vew_lang->liquidation;
	
	/* m�dulo y programa */
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'LQC';
	
	/* librer�a de estilos bootstrap */
	include_once('_library.frm');
	
	/* valores x default */
	if ( $vew_data->hltlqdcod=='' && $vew_readonly==false ) {
		$vew_data->hltlqddte = date('d/m/Y');
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

		$vew_data->hltlqdstrdte = $lv_strdte->format('d/m/Y');
		$vew_data->hltlqdenddte = $lv_enddte->format('d/m/Y');
	}
	
	$lv_prnfrm = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'print_form');	

  $vew_tbl['modR'] = array('pos'=>'R', 'per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'), 'ttl'=>$vew_lang->modify, 'icn'=>'fas fa-pencil-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn','acc'=>$lv_sec.'_fnc({action: '.chr(39).'02'.chr(39).'});');
  $vew_tbl['modL'] = array('pos'=>'L', 'per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'), 'ttl'=>$vew_lang->modify, 'icn'=>'fas fa-pencil-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn','acc'=>$lv_sec.'_fnc({action: '.chr(39).'02'.chr(39).'});');
  $vew_tbl['accL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'09'), 'acc'=>$lv_sec.'_accounting();');
  $vew_tbl['accR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'09'), 'acc'=>$lv_sec.'_accounting();');
  $vew_tbl['prn'] = array('pos'=>'L', 'per'=>$vew_data->docsts=='C' && $lv_prnfrm!='', 'id'=>'btnprn', 'ttl'=>$vew_lang->print, 'icn'=>'fas fa-print', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit');
  $vew_tbl['delL'] = array('pos'=>'L', 'per'=>$vew_data->docsts=='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'14'), 'ttl'=>$vew_lang->delete, 'icn'=>'fas fa-trash-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit','acc'=>$lv_sec.'_fnc({action: '.chr(39).'14'.chr(39).'});');
  $vew_tbl['nxtL'] = array('pos'=>'L', 'per'=>true, 'id'=>'btndatL', 'ttl'=>$vew_lang->data, 'icn'=>'fas fa-sync-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnRead tmss-desk-btn','acc'=>'');
	$vew_tbl['nxtR'] = array('pos'=>'R', 'per'=>true, 'id'=>'btndatR', 'ttl'=>$vew_lang->data, 'icn'=>'fas fa-sync-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnRead tmss-mob-btn','acc'=>'');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!--navbar-->
	<?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
		<textarea id="opnsrvids" name="opnsrvids" class="hidden"></textarea>
		<textarea id="opnexpids" name="opnexpids" class="hidden"></textarea>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->data; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hltlqdcod; ?><?= gethtml('hltlqdcod', 'hidden', $vew_data->hltlqdcod) ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              
              <div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $vew_lang->liquidation; ?>
										<span class="tmss-card-icon"><span><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span><i class="far fa-handshake"></i></span>
                    <?php 
                    	echo gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);
                    	echo gethtml('sysdocclstxt', 'hidden', $vew_data->sysdoccls->sysdocclstxt);
                    ?>
									</div>
								</div>
                
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 		'input'=>gethtml('hltlqddte', 'docdte', $vew_data->hltlqddte, ($vew_data->hltlqdcod==''?$lv_default:$lv_always_disabled) ) ));
                    echo vew_boot($lv_col255, array('label'=>$vew_lang->period,
                                                    'input1'=>gethtml('hltlqdstrdte', 'docdte', $vew_data->hltlqdstrdte, ($vew_data->hltlqdcod==''?$lv_default:$lv_always_disabled) ),
                                                    'input2'=>gethtml('hltlqdenddte', 'docdte', $vew_data->hltlqdenddte, ($vew_data->hltlqdcod==''?$lv_default:$lv_always_disabled) )
                                                  ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hltlqdtxt', 'doccmt1x50', $vew_data->hltlqdtxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->customer,
                                                    'input'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->hltlqdcod==''?$vew_readonly:true) ),
                                                                        array('input'=>gethtml('custxt', 'typeahead', $vew_data->custxt, ($vew_data->hltlqdcod==''?$lv_default:$lv_always_disabled) ) )) ));
                    echo gethtml('cuscod', 'hidden', $vew_data->cuscod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', ($vew_data->docsts=='C'?'docstsacc':'docsts'), $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div> <!-- card -->
						</div>
						<!--div class="col-md-6">
							<?php
								echo vew_boot($lv_col210, array('label'=>$vew_lang->class,
																			'input'=>gethtml('sysdocclstxt', 'doccmt1x50', $vew_data->sysdoccls->sysdocclstxt, $lv_always_disabled) )); 
								echo gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);
							?>
						</div-->
					</div>
				</div> <!-- fin _tab001 -->

				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<div id="hltlqddet"></div>
				</div> <!-- /tab-pane -->
	
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
		// DATOS
		$("#<?= $lv_sec; ?> #btndatL, #<?= $lv_sec; ?> #btndatR").on("click", function(e) {
			// valido datos m�nimos
			if ( tmssCheckRequiredFields( $("#<?= $lv_sec; ?>_frm") )==false ) { return false;}
			// cambiar tab
			$("#<?= $lv_sec; ?> a[href='#<?= $lv_sec; ?>_tab002']").trigger("click");
			// obtener datos
			var lv_pstdat = {
							cuscod: $("#<?= $lv_sec; ?> #cuscod").prop("value"),
							hltlqdcod: $("#<?= $lv_sec; ?> #hltlqdcod").prop("value"),
							hltlqdstrdte: $("#<?= $lv_sec; ?> #hltlqdstrdte").prop("value"),
							hltlqdenddte: $("#<?= $lv_sec; ?> #hltlqdenddte").prop("value"),
							sysdocclscod: $("#<?= $lv_sec; ?> #sysdocclscod").prop("value"),
							token: "<?= $lv_sec; ?>"
							};
			tmssCallProcess("?prg=hltlqd&act=<?= ($vew_readonly?'13':($vew_data->hltlqdcod==''?'11':'12')); ?>", lv_pstdat, function(data){
				$("#<?= $lv_sec; ?> #hltlqddet").html(data); 
				$("#<?= $lv_sec; ?> #custxt").prop("readonly","readonly").next().next().addClass("hidden").parent().removeClass("input-group");
				$("#<?= $lv_sec; ?> #hltlqdstrdte").prop("readonly","readonly");
				$("#<?= $lv_sec; ?> #hltlqdenddte").prop("readonly","readonly");				
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
			window.open("<?= $lv_prnfrm; ?>&prm_hltlqdcod="+$("#<?= $lv_sec; ?> #hltlqdcod").prop("value") );
		});
		
		<?php if ($vew_data->hltlqdcod!='') { ?>
			$("#<?= $lv_sec; ?> #btndatL").trigger("click");
		<?php } ?>
	</script>
	<script>		
		// custxt
		var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldasg" : {"custxt" : "custxt", "cuscod" : "cuscod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #custxt"), "slscus", lo_get);
    
		// curcod
		var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldasg" : {"curcod" : "curcod"}, "typeahead":false }; 
    tmssTypeahead($("#<?= $lv_sec; ?> #curcod"), "admcur", lo_get);
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
    
    function <?= $lv_sec; ?>_fncext(lp_prm){
      if ( lp_prm["action"]=="14" ) {
				BootstrapDialog.confirm({
					title: "<?= $vew_lang->delete; ?>",
					message: "ATENCION: Este documeno se encuentra contabilizado.<br>�Desea borrarlo?",
					type: BootstrapDialog.TYPE_WARNING,
					callback: function(result) { if(result) { <?= $lv_sec; ?>_fnc({action: "04"}); } }
				});
				return false;
			
			} else if ( lp_prm["action"]=="00" ) {
        var lv_ids = [];
				var lv_dat;
				$("#<?= $lv_sec; ?> #opnsrvtbl input[name=itmchk]").each(function(){
					lv_dat = {hltlqdmodcod:$(this).data("modcod"),
                    hltlqddoccod:$(this).data("hltlqddoccod"),
										hltlqddocprc:Number($(this).data("rowprc")),
										hltlqddocqty:Number($(this).data("rowqty")),
                    hltlqddoctot:Number($(this).data("rowqty") * $(this).data("rowprc")),
										refobjtyp:$(this).data("refobjtyp"),
                    refobjtyptxt:$(this).data("refobjtyptxt"),
                    refobjcod002:$(this).data("refobjcod002"),
										refobjcod001:$(this).data("refobjcod001"),
                    hltlqddocatr001: {
                      modcod:$(this).data("modcod"),
                      modtxt:$(this).data("modtxt"),
                      spcfrm:$(this).data("spcfrm"),
                      plnid:$(this).data("plnid"),
                      plndteid:$(this).data("plndteid"),
                      evlcod:$(this).data("evlcod"),
                      evlnum:$(this).data("evlnum"),
                      srcdte:$(this).data("srcdte"),
                      patcod:$(this).data("patcod"),
                      patcodext:$(this).data("patcodext"),
                      pattxt:$(this).data("pattxt"),
                      patpro:$(this).data("patpro"),
                      hltdisclscod:$(this).data("hltdisclscod"),
                      hltdisclstxt:$(this).data("hltdisclstxt")
                    }};
					if(!$(this).is(":checked") && $(this).data("hltlqddoccod")!="" ){
						lv_dat["delete"]="X"; 
						lv_ids.push( lv_dat );
					} else if($(this).is(":checked")) {
						lv_ids.push( lv_dat );
					}
				});	
				$("#<?= $lv_sec; ?> #opnsrvids").prop("value", JSON.stringify(lv_ids) );
      
        
        var lv_ids = [];
				var lv_dat;
				$("#<?= $lv_sec; ?> #opnexptbl input[name=itmchk]").each(function(){
					lv_dat = {hltlqddoccod:$(this).data("hltlqddoccod"),
										hltlqddocprc:Number($(this).data("rowprc")),
										hltlqddocqty:Number($(this).data("rowqty")),
                    hltlqddoctot:Number($(this).data("hltlqddoctot")),
                    hltlqddoccodext:Number($(this).data("hltlqddoccodext")),
                   	hltlqddoctxt:$(this).data("hltlqddoctxt"),                    
                   	hltlqddocdte:$(this).data("hltlqddocdte"),
										refobjtyp:$(this).data("refobjtyp"),      
										refobjcod001:$(this).data("refobjcod001"),    
                    refobjcod002:$(this).data("refobjcod002")};
					if(!$(this).is(":checked") && $(this).data("hltlqddoccod")!="" ){
						lv_dat["delete"]="X"; 
						lv_ids.push( lv_dat );
					} else if($(this).is(":checked")) {
						lv_ids.push( lv_dat );
					}
				});
        $("#<?= $lv_sec; ?> #opnexpids").prop("value", JSON.stringify(lv_ids) );
			}
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
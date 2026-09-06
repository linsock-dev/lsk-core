<?php
	// url del formulario
  $lv_lnk = "?prg=edulqd&prm_edulqdcod=".$vew_data->edulqdcod;

	// campos requeridos
	$vew_input->RequiredFields( array('edulqddte','edulqdtxt','custxt', 'cuscod','edulqdstrdte','edulqdenddte', 'docsts') );

	// clave del documento
	$lv_dockey = $vew_data->edulqdcod;

	// titulo
	$lv_title = $vew_lang->liquidation;
	
	// módulo y programa
	$lv_mdlcod = 'EDU';
	$lv_prgcod = 'LQC';

	// librería de estilos bootstrap
	include_once('_library.frm');
	
	/* valores x default */
	if ( $vew_data->edulqdcod=='' && $vew_readonly==false ) {
		$vew_data->edulqddte = date('d/m/Y');
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

		$vew_data->edulqdstrdte = $lv_strdte->format('d/m/Y');
		$vew_data->edulqdenddte = $lv_enddte->format('d/m/Y');		
	} else {
		$vew_data->edulqdstrdte = $vew_doc->getTagValue($vew_data->edulqdatr001,'strdte');
		$vew_data->edulqdenddte = $vew_doc->getTagValue($vew_data->edulqdatr001,'enddte');
	}
	
	$lv_prnfrm = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'print_form');	
	$lv_cusdaturl = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'edulqdcusurl');
	
	// BOTONES
	$vew_tbl['modL'] = array('pos'=>'L','per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'), 'ttl'=>$vew_lang->modify);
	$vew_tbl['delL'] = array('pos'=>'L','per'=>$vew_data->docsts=='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'14'), 'ttl'=>$vew_lang->delete,'acc'=>$lv_sec.'_fnc({action: '.chr(39).'14'.chr(39).'});');
	$vew_tbl['accL'] = array('pos'=>'L','per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'09'), 'ttl'=>$vew_lang->accounting,'acc'=>$lv_sec.'_accounting();');
	$vew_tbl['prn'] = array('pos'=>'L','per'=>$vew_data->docsts=='C' && $lv_prnfrm!='', 'ttl'=>$vew_lang->print, 'id'=>'btnprn','icn'=>'fas fa-print','css'=>'btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit','acc'=>'');
	$vew_tbl['nxtL'] = array('pos'=>'L', 'per'=>true, 'id'=>'btnnxt1', 'ttl'=>$vew_lang->data, 'icn'=>'fas fa-sync-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnRead tmss-desk-btn','acc'=>''); 
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
				<li class="pull-right"><h4># <strong><?= $vew_data->edulqdcod; ?><?= gethtml('edulqdcod','hidden',$vew_data->edulqdcod); ?></strong></h4></li>
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
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 		'input'=>gethtml('edulqddte', 'docdte', $vew_data->edulqddte, ($vew_data->edulqdcod==''?$lv_default:$lv_always_disabled) ) ));
                    echo vew_boot($lv_col255, array('label'=>$vew_lang->period,
                                                    'input1'=>vew_boot($lv_col210, array('label'=>$vew_lang->from,'input'=>gethtml('edulqdstrdte', 'docdte', $vew_data->edulqdstrdte, ($vew_data->edulqdcod==''?$lv_default:$lv_always_disabled) ) )),
                                                    'input2'=>vew_boot($lv_col210, array('label'=>$vew_lang->to, 	'input'=>gethtml('edulqdenddte', 'docdte', $vew_data->edulqdenddte, ($vew_data->edulqdcod==''?$lv_default:$lv_always_disabled) ) ))
                                                  ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('edulqdtxt', 'doccmt1x50', $vew_data->edulqdtxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->customer, 'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->edulqdcod==''?$vew_readonly:true) ), array('input'=>gethtml('custxt', 'doccmt1x50', $vew_data->custxt, ($vew_data->edulqdcod==''?$lv_default:$lv_always_disabled) ) )) ));
                    echo '<input type="hidden" id="cuscod" name="cuscod" value="'.$vew_data->cuscod.'">';

                  	echo vew_boot($lv_col255, array('label'=>$vew_lang->status,	
																								'input1'=>gethtml('docsts', 'docstsacc',	$vew_data->docsts, $lv_default),
																								'input2'=>'<h4 style="margin-top: 8px; margin-bottom: 5px;" class="'.($vew_data->sysdoctrecod=='C'?'text-success':($vew_data->sysdoctrecod=='P'?'text-warning':'')).'">'.strtoupper($vew_data->sysdoctretxt).'</h4>' 
																								));
                   ?>
                </div>
              </div>
						</div>
					</div>
				</div> <!-- fin _tab001 -->

				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<div id="edulqddet"></div>
				</div> <!-- /tab-pane -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
		// DATOS
		$("#<?= $lv_sec; ?> #btnnxt1").on("click", function(e) {
			// valido datos mínimos
			if ( tmssCheckRequiredFields( $("#<?= $lv_sec; ?>_frm") )==false ) { return false;}
			// cambiar tab
			$("#<?= $lv_sec; ?> a[href='#<?= $lv_sec; ?>_tab002']").trigger("click");
			// obtener datos
			var lv_pstdat = $("#<?= $lv_sec; ?>_frm").serializeArray();
			lv_pstdat.push({name:"sec",value:"<?= $lv_sec; ?>"},
										{name:"readonly",value:<?= ($vew_readonly?'true':'false'); ?>});
			tmssCallProcess("<?= ($lv_cusdaturl==''?'?prg=edulqd&act=edulqd':$lv_cusdaturl); ?>",lv_pstdat,function(data){
				$("#<?= $lv_sec; ?> #edulqddet").html(data); 
				$("#<?= $lv_sec; ?> #custxt").prop("readonly","readonly").next().next().addClass("hidden").parent().removeClass("input-group");
				$("#<?= $lv_sec; ?> #edulqdstrdte").prop("readonly","readonly");
				$("#<?= $lv_sec; ?> #edulqdenddte").prop("readonly","readonly");
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
			window.open("<?= $lv_prnfrm; ?>&prm_edulqdcod="+$("#<?= $lv_sec; ?> #edulqdcod").prop("value") );
		});
		
		<?php if ($vew_data->edulqdcod!='') { ?>
			$("#<?= $lv_sec; ?> #btnnxt1").trigger("click");
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
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
<?php
	/* url del formulario */
  $lv_lnk = "?prg=slssvclqd&prm_slssvclqdcod=".$vew_data->slssvclqdcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('slssvclqddte','slssvclqdtxt','custxt', 'cuscod','slssvclqdstrdte','slssvclqdenddte', 'docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->slssvclqdcod;

	/* titulo */
	$lv_title = $vew_lang->liquidation;
	
	/* módulo y programa */
	$lv_mdlcod = 'SLS';
	$lv_prgcod = 'SVL';

	/* librería de estilos bootstrap */
	include_once('_library.frm');

	/* valores x default */
	if ( $vew_data->slssvclqdcod=='' && $vew_readonly==false ) {
		$vew_data->slssvclqddte = date('d/m/Y');
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

		$vew_data->slssvclqdstrdte = $lv_strdte->format('d/m/Y');
		$vew_data->slssvclqdenddte = $lv_enddte->format('d/m/Y');		
	} else {
		$vew_data->slssvclqdstrdte = $vew_doc->getTagValue($vew_data->slssvclqdatr001,'strdte');
		$vew_data->slssvclqdenddte = $vew_doc->getTagValue($vew_data->slssvclqdatr001,'enddte');
	}
	
	$lv_prnfrm = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'print_form');	
	$lv_cusdaturl = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'slssvclqdcusurl');

	$vew_tbl['accL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'09'), 'id'=>'btnacc', 'acc'=> $lv_sec.'_accounting()');
	$vew_tbl['accR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'09'), 'id'=>'btnacc', 'acc'=> $lv_sec.'_accounting()');
	$vew_tbl['data'] = array('pos'=>'L','per'=>true, 'ttl'=>$vew_lang->data, 'id'=>'btnnxttab','icn'=>'fas fa-sync-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnRead tmss-desk-btn', 'acc'=>'' );
	$vew_tbl['sveR'] = array('id'=>'btnsve', 'acc'=>'');
  $vew_tbl['sveL'] = array('id'=>'btnsve', 'acc'=>'');
	$vew_tbl['canc'] = array('id'=>'btncnc');
	$vew_tbl['modL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
	$vew_tbl['modR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
	$vew_tbl['delsep'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'04'));
	$vew_tbl['del'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'04'));
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
				<li class="pull-right"><h4># <strong><?= $vew_data->slssvclqdcod; ?><?= gethtml('slssvclqdcod','hidden',$vew_data->slssvclqdcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $lv_title; ?>
										<span class="tmss-card-icon">
                      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
										</span>
									</div>
								</div>              
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->customer, 'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->slssvclqdcod==''?$vew_readonly:true) ), array('input'=>gethtml('custxt', 'typeahead', $vew_data->custxt, ($vew_data->slssvclqdcod==''?$lv_default:$lv_always_disabled) ) )) ));
                    echo gethtml('cuscod', 'hidden', $vew_data->cuscod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('slssvclqdtxt', 'doccmt1x50', $vew_data->slssvclqdtxt, $lv_default) ));      
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	
                                                    'input1'=>gethtml('docsts', 'docstsacc',	$vew_data->docsts, $lv_default),
                                                    ));
                  ?>
                </div>
              </div> <!-- /card -->
            </div> <!-- /col-6 -->
            <div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->data; ?>
                    <span class="tmss-card-icon">
                      <i class="fas fa-dollar-sign"></i>
                    </span>	
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">  
                  <?php
                    echo vew_boot($lv_col244, array('label'=>$vew_lang->date, 'input'=>gethtml('slssvclqddte', 'docdte', $vew_data->slssvclqddte, ($vew_data->slssvclqdcod==''?$lv_default:$lv_always_disabled) ) ));
                		echo vew_boot($lv_col255, array('label'=>$vew_lang->period, 'input'=>gethtml('slssvclqdstrdte',	'docdte',	$vew_data->slssvclqdstrdte,	$lv_default), 'input2'=>gethtml('slssvclqdenddte',	'docdte',	$vew_data->slssvclqdenddte,	$lv_default) ));
                  ?>
                </div>
              </div>
            </div> <!-- /col-6 -->
         	</div> <!-- /row -->
					
					<div id="slssvclqddet"></div>
					
        </div>
      </div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>		
		// DATOS
		$("#<?= $lv_sec; ?> #btnnxttab").on("click", function(e) { e.preventDefault();
			// valido datos mínimos
			if ( tmssCheckRequiredFields( $("#<?= $lv_sec; ?>_frm") )==false ) { return false;}
			// obtener datos
			var lv_pstdat = $("#<?= $lv_sec; ?>_frm").serializeArray();
			lv_pstdat.push({name:"sec",value:"<?= $lv_sec; ?>"},
										{name:"readonly",value:<?= ($vew_readonly?'true':'false'); ?>});
			tmssCallProcess("<?= ($lv_cusdaturl==''?'?prg=slssvclqd&act='.($vew_actcod=='01'?'11':($vew_actcod=='02'?'12':'13')):$lv_cusdaturl); ?>",lv_pstdat,function(data){
				$("#<?= $lv_sec; ?> #slssvclqddet").html(data); 
				$("#<?= $lv_sec; ?> #custxt").prop("readonly","readonly").next().next().addClass("hidden").parent().removeClass("input-group");
				$("#<?= $lv_sec; ?> #slssvclqdstrdte").prop("readonly","readonly");
				$("#<?= $lv_sec; ?> #slssvclqdenddte").prop("readonly","readonly");
			});
		})
		
		// CONTABILIZAR
		function <?= $lv_sec; ?>_accounting() {
			BootstrapDialog.confirm({
				title: "<?= $vew_lang->accounting; ?>",
				message: "&iquest;Desea contabilizar el documento?",
				type: BootstrapDialog.TYPE_WARNING,
				callback: function(result) { if(result) { <?= $lv_sec; ?>_fnc({action: "09"}); } }
			});
		}
		
		// estados del documento
		$("#<?= $lv_sec; ?> #btndocsts").on("click",function(e){ e.preventDefault(); 
			tmssCallProcess("?prg=grldocsts&act=03", {sysdocclscod: "<?= $vew_data->sysdoccls->sysdocclscod; ?>", srcobjtyp: "<?= $lv_mdlcod.'_'.$lv_prgcod; ?>", srcobjcod: "<?= $vew_data->slssvclqdcod; ?>"}, function(data){
				BootstrapDialog.show({
					size: BootstrapDialog.SIZE_WIDE,
					title: "<?= $vew_lang->statuses; ?>",
					message: $(data)
				});
			});
		});

   	<?php if ($vew_data->slssvclqdcod!='') { ?>
			$("#<?= $lv_sec; ?> #btnnxttab").trigger("click");
		<?php } ?> 
	</script>
	<script>		
		// TYPEAHEAD   custxt
    var lo_get = { "fldsec" : "<?= $lv_sec; ?>", "fldasg": { "custxt" : "custxt", "cuscod" : "cuscod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #custxt"), "slscus", lo_get);

		// curcod
		$("#<?= $lv_sec; ?> #curcod").next("span").children("a:first").on("click", function(e) { e.preventDefault(); 
			tmssPopup("<?= $vew_lang->currencies; ?>","?prg=admcur&prm_vewcod=VEW_ADM_CUR_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[curcod:curcod]");
		});
	</script>
  <script>
    // S A V E
		$("#<?= $lv_sec; ?> #btnsve").on("click",function(e){ e.preventDefault();
      if ( !tmssCheckRequiredFields( $("#<?= $lv_sec; ?>_frm") ) ) { return false; }
                                                         
      $("#<?= $lv_sec; ?> #btnsve").addClass("hidden");
      $("#<?= $lv_sec; ?> #btncnc").addClass("hidden");
      $("#<?= $lv_sec; ?> #btnnxttab").addClass("hidden");
                                                         
      var lv_pstdat = $("#<?= $lv_sec ?>_frm").serializeArray();
      for(var i=lv_pstdat.length-1; i > 0; i--){
        if(lv_pstdat[i]["name"]=="opnsrv" || lv_pstdat[i]["name"]=="opnsrvids" || lv_pstdat[i]["name"]=="opnexpids" || lv_pstdat[i]["name"]=="itmchk"){ 
         lv_pstdat.splice(i,1); 
        }
      }
                                                         
      tmssCallProcess("?prg=slssvclqd&act=00",lv_pstdat,function(data){
        if(data.errtyp == "S"){
          $("#<?= $lv_sec; ?> #slssvclqdcod").prop("value", data.slssvclqdcod);
        } else {
          toastr.warning("Se produjo un error al grabar el documento. "+data.errtxt);
          return false;
        }

				var lv_slssvclqddockey = "";
				$("#<?= $lv_sec; ?> input[name=itmchk]:checked").each(function(){
					lv_slssvclqddockey += (lv_slssvclqddockey==""?"":String.fromCharCode(10))
															+$(this).data("stkobjtyp")+"|"+$(this).data("stkobjcod")+"|"+$(this).data("stkcntcod")+"|"
															+$(this).data("refobjtyp")+"|"+$(this).data("refobjcod001")+"|"+$(this).data("refobjcod002");
				});
				var lv_pstdat2 = [{name:"slssvclqdcod", value:data.slssvclqdcod},
													{name:"cuscod", value:$("#<?= $lv_sec; ?> #cuscod").val()},
													{name:"slssvclqdstrdte", value:$("#<?= $lv_sec; ?> #slssvclqdstrdte").val()},
													{name:"slssvclqdenddte", value:$("#<?= $lv_sec; ?> #slssvclqdenddte").val()},
													{name:"slssvclqddockey", value:lv_slssvclqddockey}];
				tmssCallProcess("?prg=slssvclqd&act=docsve",lv_pstdat2,function(data2){
					toastr.success("Los datos han sido grabados.");
					<?= $lv_sec; ?>_fnc({action: "03"});
				});
      });
		});
  </script>
  <script>
    // server response
    function <?= $lv_sec; ?>_fncbckext( data ) {
      if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
        if (gv_<?= $lv_sec; ?>_last_action=="04") {
          tmssTabSecCls( $("#<?= $lv_sec; ?>") );
        } else if (gv_<?= $lv_sec; ?>_last_action=="09"){
          toastr.info("Documento contabilizado.");
          <?= $lv_sec; ?>_fnc({action: "99"});
          return;
        } else{
          $("#<?= $lv_sec; ?>").replaceWith( data );
        }
      }
    }
		
		// form submit EXT
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      // limpio campos
      $("#<?= $lv_sec; ?> #opnsrv, #<?= $lv_sec; ?> #opnsrvids, #<?= $lv_sec; ?> #opnexpids, #<?= $lv_sec; ?> [name='itmchk']").remove();       
		}
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
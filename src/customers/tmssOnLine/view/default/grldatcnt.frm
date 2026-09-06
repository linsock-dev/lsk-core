<?php
	// url del formulario
  $lv_lnk = '?prg=grldatcnt&prm_cntcod='.$vew_data->cntcod.'&prm_cntsrctyp='.$vew_data->cntsrctyp.'&prm_cntsrccod='.$vew_data->cntsrccod.'&prm_srcdocclscod='.$vew_data->srcdocclscod.'&prm_bcksec='.$vew_data->bcksec.'&prm_popup='.$vew_data->popup;

	// campos requeridos
	$vew_input->RequiredFields( array('sysdocclscodcnt','sysdocclstxtcnt','cnttxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->cntcod;

	// titulo
	$lv_title = $vew_lang->contact;

	// modulo y programa
	$lv_mdlcod = explode('_',$vew_data->cntsrctyp)[0];
	$lv_prgcod = explode('_',$vew_data->cntsrctyp)[1] . 'C';

	// objeto de referencia
	$lv_refobjtyp = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'refobjtypcod');

	// libreria de estilos bootstrap
	include_once('_library.frm');
	
	// Botones por Vista
	$vew_tbl['clsL'] = array('per'=>true, 'acc'=>(!$vew_readonly && $lv_dockey!='' && $vew_data->popup==''? $lv_sec.'_fnc({action: '.chr(39).'98'.chr(39).'});': $lv_sec.'_close();'));
	$vew_tbl['clsR'] = array('per'=>true, 'acc'=>$lv_sec.'_close();');

?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', $vew_data->cntsrctyp); ?>
    <?= gethtml('cntsrctyp', 'hidden', $vew_data->cntsrctyp); ?>
		<?= gethtml('cntsrccod', 'hidden', $vew_data->cntsrccod); ?>
    <?= gethtml('srcdocclscod', 'hidden', $vew_data->srcdocclscod); ?>
		<?= gethtml('adrnum', 'hidden', $vew_data->adrnum);	?>
		
    <div class="container-fluid" role="tabpanel"> 
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation" id="tabtax"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->cntcod; ?><?= gethtml('cntcod','hidden',$vew_data->cntcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                    <span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                    <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <div id="rowdatgrl">
                    <?php
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('cntcodext', 'doccmt1x20', $vew_data->cntcodext, $lv_default) ));
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->name,'input'=>gethtml('cnttxt', 'doccmt1x50', $vew_data->cnttxt, $lv_default) ));
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                    ?>
                  </div>
                  <div class="hidden" id="rowdatcnt">
                    <?php
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->name, 
                                                      'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly ),
                                                                          array('input'=>gethtml('cntdsttxt', 'typeahead', $vew_data->cntdsttxt,$lv_default) )) 
                                                     ));
                    	echo gethtml('cntdsttyp', 'hidden', $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'refobjtyp')); 
                    	echo gethtml('cntdstcod', 'hidden', $vew_data->cntdstcod); 
                    	echo gethtml('cntdstdocclscod', 'hidden', $lv_refobjtyp); 
                    ?>
                  </div>
                </div>
              </div>
						</div> 
            <div class="col-md-6" id="rowdatper">
              <?php include('grldatper.frm'); ?>
          	</div>
					</div> <!-- end row -->
          
					<!-- DIRECCION / CONTACTO -->
					<div class="row" id="rowdatadr">
						<div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
						<div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
					</div>
				</div> <!-- /_tab001 -->

				<!-- IMPUESTOS / BANCOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
					<div class="row">
						<div class="col-md-6"><?php include('grldattax.frm'); ?></div>
						<div class="col-md-6"><?php include('grldatbnk.frm'); ?></div>
					</div>
				</div> <!-- /_tab003 -->

      </div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->

  </form>
	<script>    
		$("#<?= $lv_sec; ?> #cntdsttyp").on("change",function(){			
			var lv_cntdsttyp = $(this).prop("value");
      
			if(lv_cntdsttyp==""){
				$("#<?= $lv_sec; ?> #tabtax").removeClass("hidden");
				$("#<?= $lv_sec; ?> #rowdatadr").removeClass("hidden");
				$("#<?= $lv_sec; ?> #rowdatgrl").removeClass("hidden");
				$("#<?= $lv_sec; ?> #rowdatper").removeClass("hidden");
				$("#<?= $lv_sec; ?> #rowdatcnt").addClass("hidden");
				$("#<?= $lv_sec; ?> #cntdsttxt").removeClass("tmssInputRequired");
			}else{				
				$("#<?= $lv_sec; ?> #tabtax").addClass("hidden");
				$("#<?= $lv_sec; ?> #rowdatadr").addClass("hidden");
				$("#<?= $lv_sec; ?> #rowdatgrl").addClass("hidden");
				$("#<?= $lv_sec; ?> #rowdatper").addClass("hidden");
				$("#<?= $lv_sec; ?> #rowdatcnt").removeClass("hidden");
        $("#<?= $lv_sec; ?> #cntdsttxt").unbind("click").next().next("span").children("a:first").unbind("click");
				$("#<?= $lv_sec; ?> #cntdsttxt").prop("placeholder","?");
				$("#<?= $lv_sec; ?> #cntdsttxt").addClass("tmssInputRequired");
				
				if(lv_cntdsttyp=="SLS_CUS"){
          var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"cntdstcod":"cuscod","cntdsttxt":"custxt"} };
          tmssTypeahead($("#<?= $lv_sec; ?> #cntdsttxt"), "slscus", lo_get);
				} else if(lv_cntdsttyp=="BUY_SUP"){
          var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"cntdstcod":"supcod","cntdsttxt":"suptxt"} };
          tmssTypeahead($("#<?= $lv_sec; ?> #cntdsttxt"), "buysup", lo_get);
				} else if(lv_cntdsttyp=="HHR_EMP"){
          var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"cntdstcod":"hhrempcod","cntdsttxt":"hhremptxt"} };
          tmssTypeahead($("#<?= $lv_sec; ?> #cntdsttxt"), "hhremp", lo_get);
				} else if(lv_cntdsttyp=="HLT_PAT"){
          var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"cntdstcod":"patcod","cntdsttxt":"pattxt"} };
          tmssTypeahead($("#<?= $lv_sec; ?> #cntdsttxt"), "hltpat", lo_get);
				} else if(lv_cntdsttyp=="EDU_STU"){
          var lv_flt_opt = ($("#<?= $lv_sec; ?> #cntdstdocclscod").prop("value") != "" ? { "dc.sysdocclscod":"(in)"+$("#<?= $lv_sec; ?> #cntdstdocclscod").val() } : {});
        	var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : eval(lv_flt_opt), "fldasg" : {"cntdstcod":"stucod","cntdsttxt":"stutxt"} };
          tmssTypeahead($("#<?= $lv_sec; ?> #cntdsttxt"), "edustu", lo_get);
				} else if(lv_cntdsttyp=="EDU_TCH"){
        	var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {}, "fldasg" : {"cntdstcod":"tchcod","cntdsttxt":"tchtxt"} };
          tmssTypeahead($("#<?= $lv_sec; ?> #cntdsttxt"), "edutch", lo_get);
				} else if(lv_cntdsttyp=="HLT_PRS"){
        	var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"p.sysdocclscod":'<?= $lv_refobjtyp ?>', "p.docsts": "A"}, "fldasg" : {"cntdstcod":"prscod","cntdsttxt":"prstxt"} };
          tmssTypeahead($("#<?= $lv_sec; ?> #cntdsttxt"), "hltprs", lo_get);
				}else if(lv_cntdsttyp=="SPT_PTN"){
        	var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {}, "fldasg" : {"cntdstcod":"ptncod","cntdsttxt":"ptntxt"} };
          tmssTypeahead($("#<?= $lv_sec; ?> #cntdsttxt"), "sptptn", lo_get);          
				}else if(lv_cntdsttyp=="CNS_TSK"){
        	var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {}, "fldasg" : {"cntdstcod":"cnstskcod","cntdsttxt":"cnstsktxt"} };
          tmssTypeahead($("#<?= $lv_sec; ?> #cntdsttxt"), "cnstsk", lo_get);          
				}
			}
		});

		function <?= $lv_sec; ?>_close(){
			<?php
				if( $vew_data->popup!='' ) {
					echo '$.each(BootstrapDialog.dialogs, function(id, dialog){ if(dialog.getModalBody().find("#'.$lv_sec.'").length>0){dialog.close();} });';
				} else if( $vew_data->bcksec!=''){ 
					echo 'if(typeof window["'.$vew_data->bcksec.'_GridRefresh"]!="undefined"){ '.$vew_data->bcksec.'_GridRefresh(); }';
				} 
				if( $vew_data->popup=='' ){	echo 'tmssTabSecCls( $("#'.$lv_sec.'") );'; }
			?>
		}

		$(function(){ $("#<?= $lv_sec; ?> #cntdsttyp").trigger("change"); });
	</script>
  <script>
    // form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
    	// al grabar
			if ( lp_prm['action']=="00" ) {
				// si se indico origen de contacto, obtengo nombre y fijo estado activo
				if($("#<?= $lv_sec; ?> #cntdsttyp").prop("value")!=""){
					$("#<?= $lv_sec; ?> #cnttxt").prop("value",$("#<?= $lv_sec; ?> #cntdsttxt").prop("value"));
					$("#<?= $lv_sec; ?> #docsts").prop("value","a");					
				}				
			}
    }
    
    // server response ext
    function <?= $lv_sec; ?>_fncbckext( data) {
      if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="04") {
					<?= $lv_sec; ?>_close();
				} else if ( typeof data == "string" && data.substring(0,10)=="/*script*/" ) {
					eval( data );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    }
  </script>
  <?php include('grldocfrmscr.frm') ?>
</section>
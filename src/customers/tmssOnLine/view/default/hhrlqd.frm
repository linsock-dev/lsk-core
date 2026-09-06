<?php	
	// url del formulario
  $lv_lnk = "?prg=hhrlqd&prm_hhrlqdcod=".$vew_data->hhrlqdcod;

	// campos requeridos
	$vew_input->RequiredFields( array('hhrlqddte','hhrlqdtxt','hhrlqdstrdte','hhrlqdenddte', 'docsts', 'prcschcod','prcschtxt') );

	// clave del documento
	$lv_dockey = $vew_data->hhrlqdcod;

	// titulo
	$lv_title = $vew_lang->liquidation;
	
	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'LQD';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
	
	// valores x default
	if ( $vew_data->hhrlqdcod=='' && $vew_readonly==false ) {
		$vew_data->hhrlqddte = date('d/m/Y');
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
		$vew_data->hhrlqdstrdte = $lv_strdte->format('d/m/Y');
		$vew_data->hhrlqdenddte = $lv_enddte->format('d/m/Y');		
	} else {
		//$vew_data->hhrlqdstrdte = $vew_doc->getTagValue($vew_data->hhrlqdatr001,'lqdstrdte');
		//$vew_data->hhrlqdenddte = $vew_doc->getTagValue($vew_data->hhrlqdatr001,'lqdenddte');
		$vew_data->srcobjcod = $vew_doc->getTagValue($vew_data->hhrlqdatr001,'srcobjcod');
		$vew_data->srcobjtxt = $vew_doc->getTagValue($vew_data->hhrlqdatr001,'srcobjtxt');
		$vew_data->hhrchrasgtxt = $vew_doc->getTagValue($vew_data->hhrlqdatr001,'chrtyptxt');
		$vew_data->prcschtxt = $vew_doc->getTagValue($vew_data->hhrlqdatr001,'prcschtxt');
	}
    $vew_data->srcobjtyp=$vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'srcobjtyp');
  	$lv_prcschcndrow = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prcschcndrow');
  

	// botones por vista
	$vew_tbl_int['modL'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl_int['modR'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl['cpy'] = array('per'=>false);
	$vew_tbl['sveR'] = array('id'=>'btnsve');
  $vew_tbl['sveL'] = array('id'=>'btnsve');
	$vew_tbl['canc'] = array('id'=>'btncnc');
	$vew_tbl['accL'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09'), 'acc'=>$lv_sec.'_accounting();');
	$vew_tbl['accR'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09'), 'acc'=>$lv_sec.'_accounting();');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include("grldocfrmtlb.frm"); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('prcschcndrow','hidden',$lv_prcschcndrow); ?>
		<?= gethtml('hhrchrasgdtestr','hidden',''); ?>
		<?= gethtml('hhrchrasgdteend','hidden',''); ?>
		<textarea class="hidden" id="txtprc" name="txtprc"><?= JSON_ENCODE( $vew_data->txtprc ); ?></textarea>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hhrlqdcod; ?><?= gethtml('hhrlqdcod','hidden',$vew_data->hhrlqdcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-4">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->liquidation; ?>
                    <span class="tmss-card-icon">
                    	<span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                    	<input type="hidden" id="sysdocclscod" name="sysdocclscod" value="<?= $vew_data->sysdoccls->sysdocclscod; ?>">
                    </span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('hhrlqddte', 'docdte', $vew_data->hhrlqddte, ($vew_data->hhrlqdcod==''?$lv_default:$lv_always_disabled) ) ));
                    echo vew_boot($lv_col255, array('label'=>$vew_lang->period,
                                                    'input1'=>gethtml('hhrlqdstrdte', 'docdte', $vew_data->hhrlqdstrdte, ($vew_data->hhrlqdcod==''?$lv_default:$lv_always_disabled) ),
                                                    'input2'=>gethtml('hhrlqdenddte', 'docdte', $vew_data->hhrlqdenddte, ($vew_data->hhrlqdcod==''?$lv_default:$lv_always_disabled) )
                                                  ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hhrlqdtxt', 'doccmt1x50', $vew_data->hhrlqdtxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->source, 
                                                    'input1'=>vew_boot(	array('style'=>'search', 'readonly'=> ($vew_data->hhrlqdcod==''?$vew_readonly:true) ), 
                                                                        array('input'=>gethtml('srcobjtxt', 'typeahead', $vew_data->srcobjtxt, ($vew_data->hhrlqdcod==''?$lv_default:$lv_always_disabled) ) )
                                                                      )));
                    echo gethtml('srcobjcod','hidden',$vew_data->srcobjcod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->charge, 
                                                    'input1'=>vew_boot(	array('style'=>'search', 'readonly'=> ($vew_data->hhrlqdcod==''?$vew_readonly:true) ), 
                                                                        array('input'=>gethtml('hhrchrasgtxt', 'typeahead', $vew_data->hhrchrasgtxt, ($vew_data->hhrlqdcod==''?$lv_default:$lv_always_disabled) ) )
                                                                      )));
                    echo gethtml('hhrchrasgcod','hidden',$vew_data->hhrchrasgcod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->schema, 
                                                    'input1'=>vew_boot(	array('style'=>'search', 'readonly'=> ($vew_data->hhrlqdcod==''?$vew_readonly:true) ), 
                                                                        array('input'=>gethtml('prcschtxt', 'typeahead', $vew_data->prcschtxt, ($vew_data->hhrlqdcod==''?$lv_default:$lv_always_disabled) ) )
                                                                      )));
                    echo gethtml('prcschcod','hidden',$vew_data->prcschcod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', ($vew_data->docsts=='C'?'docstsacc':'docsts'), $vew_data->docsts, $lv_default) ));
                  ?>
              	</div>
              </div>
						</div>
						<div class="col-md-8"> 
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->liquidation; ?>
                    <a href="#" id="btncalc" class="card-icon tmssHiddeOnRead" title="<?= $vew_lang->calculate;  ?>"><i class="far fa-bolt"></i></a>
                  </div>
                </div>
                <div id="hhrlqddet"></div>
              </div>
            </div>
					</div>
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		 $(function(){<?= $lv_sec; ?>_showPrices();});
		
		// srcobjtxt - typeahead
		<?php if($vew_data->srcobjtyp=='EDU_TCH'){ ?>
			var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg":{ "srcobjtxt":"tchtxt", "srcobjcod":"tchcod"}, "fldflt":{"p.docsts":"A"}};
			tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "edutch", lo_get);
		<?php } else if($vew_data->srcobjtyp=='HHR_EMP') { ?>
			var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg":{ "srcobjtxt":"hhremptxt", "srcobjcod":"hhrempcod"}, "fldflt":{"p.docsts":"A"}};
			tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "hhremp", lo_get);		
		<?php } ?>

    // hhrchrasg - typeahead
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg":{ "hhrchrasgcod":"hhrchrasgcod", "hhrchrasgtxt":"hhrchrtyptxt"}, "fldflt":{"ca.srcobjcod":$("#<?= $lv_sec; ?> #srcobjcod")}};
    tmssTypeahead($("#<?= $lv_sec; ?> #hhrchrasgtxt"), "hhrchrasg", lo_get);
    
    // prcschtxt - typeahead
		var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg":{ "prcschcod":"prcschcod", "prcschtxt":"prcschtxt"}, "fldflt":{"ps.docsts":"A", "ps.mdlcod":"HHR"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #prcschtxt"), "prcsch", lo_get);		
		
		// CALCULAR
		$("#<?= $lv_sec; ?> #btncalc").on("click", function(e) { e.preventDefault();
			// completo datos de cabecera con los datos del formulario                 
      var lv_dochdr = [];
      lv_dochdr.push({name:"sysdocclscod",value:$("#<?= $lv_sec; ?> #sysdocclscod").prop("value") });
      lv_dochdr.push({name:"hhrlqddte",value:$("#<?= $lv_sec; ?> #hhrlqddte").prop("value") });
      lv_dochdr.push({name:"hhrlqdstrdte",value:$("#<?= $lv_sec; ?> #hhrlqdstrdte").prop("value") });
      lv_dochdr.push({name:"hhrlqdenddte",value:$("#<?= $lv_sec; ?> #hhrlqdenddte").prop("value") });
      lv_dochdr.push({name:"hhrlqdtxt",value:$("#<?= $lv_sec; ?> #hhrlqdtxt").prop("value") });
      lv_dochdr.push({name:"prcschcod",value:$("#<?= $lv_sec; ?> #prcschcod").prop("value") });
      lv_dochdr.push({name:"docsts",value:$("#<?= $lv_sec; ?> #docsts").prop("value") });
      lv_dochdr.push({name:"hhrlqdcod",value:$("#<?= $lv_sec; ?> #hhrlqdcod").prop("value")});
      lv_dochdr.push({name:"hhrchrasgcod",value:$("#<?= $lv_sec; ?> #hhrchrasgcod").prop("value")});
      lv_dochdr.push({name:"srcobjcod",value:$("#<?= $lv_sec; ?> #srcobjcod").prop("value")});
      lv_dochdr.push({name:"srcobjtxt",value:$("#<?= $lv_sec; ?> #srcobjtxt").prop("value")});
      lv_dochdr.push({name:"hhrchrtyptxt",value:$("#<?= $lv_sec; ?> #hhrchrtyptxt").prop("value")});
			//var lv_docprc = JSON.stringify(<?= $lv_sec; ?>_hot_grldatprc.getSourceData());
    	var lv_pstdat = [ {name:"dochdr",value: JSON.stringify(lv_dochdr)},
													//{name:"docpos",value: lv_docpos }, // lv_docpos
													//{name:"docprc",value: lv_docprc },
													{name:"readonly",value:<?= ($vew_readonly?'true':'false');?>}
												];
			tmssCallProcessNoBackdrop("?prg=hhrlqd&act=calc",lv_pstdat,function(data){
				// calculo TOTAL de liquidacion
				var lv_net=0;
				for(var x=0;x<(data.docprc.length);x++){ 
					if( $("#<?= $lv_sec; ?> #prcschcndrow").prop("value")=="" && data.docprc[x].prccndcod!="0" ){
						lv_net += data.docprc[x].prccndtot;
					} else if( $("#<?= $lv_sec; ?> #prcschcndrow").prop("value")==data.docprc[x].prcschcndrow ) {
						lv_net = data.docprc[x].prccndtot;
						x=data.docprc.length;
					}
				}

				$("#<?= $lv_sec; ?> #txtprc").text( JSON.stringify(data.docprc) );					
				<?= $lv_sec; ?>_showPrices();					
			});
			
		});
		
		
		// SHOW PRICES. muestra el detalle de una liquidación
		function <?= $lv_sec; ?>_showPrices() {
			var lv_dochdr = $("#<?= $lv_sec; ?>_frm").serializeArray();
			lv_dochdr.push({name:"hhrchrasgcod",value:$("#<?= $lv_sec; ?> #hhrchrasgcod").prop("value")});
			lv_dochdr.push({name:"srcobjcod",value:$("#<?= $lv_sec; ?> #srcobjcod").prop("value")});
			lv_dochdr.push({name:"hhrchrasgdtestr",value:$("#<?= $lv_sec; ?> #hhrchrasgdtestr").prop("value")});
			lv_dochdr.push({name:"hhrchrasgdteend",value:$("#<?= $lv_sec; ?> #hhrchrasgdteend").prop("value")});
			
			// quitar precios de la cabecera
			for(var x=0;x<lv_dochdr.length;x++){if(lv_dochdr[x]["name"]=="txtprc"){lv_dochdr.splice(x,1);x--;}}
			
			var lv_docpos = {};
			var lv_docprc = JSON.parse( $("#<?= $lv_sec; ?> #txtprc").val() );
			
			var lv_pstdat=[ {name:"dochdr",	value: JSON.stringify(lv_dochdr) },
											{name:"docpos",	value: JSON.stringify(lv_docpos) },
											{name:"docprc",	value: JSON.stringify(lv_docprc) },
											{name:"readonly",value:<?= ($vew_readonly?'true':'false'); ?>},
                      {name:"sec",value:"<?= $lv_sec;?>"}
										];
			tmssCallProcess("?prg=hhrlqd&act=13", lv_pstdat, function(data){ 
				$("#<?= $lv_sec; ?> #hhrlqddet").html( data );
			});
			return false;			
		}
		
		
		// CONTABILIZAR
		function <?= $lv_sec; ?>_accounting() {
			BootstrapDialog.confirm({
				title: "<?= $vew_lang->accounting; ?>",
				message: "&iquest;Desea contabilizar el documento?",
				type: BootstrapDialog.TYPE_WARNING,
				callback: function(result) { if(result) { <?= $lv_sec; ?>_fnc({action: "09"}); } }
			});
		}
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
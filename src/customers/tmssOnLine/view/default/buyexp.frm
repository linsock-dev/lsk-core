<?php 
	// url del formulario
  $lv_lnk = "?prg=buyexp&prm_buyexpcod=".$vew_data->buyexpcod;

	// campos requeridos
	$vew_input->RequiredFields( array('srcobjtyp','srcobjcod','srcobjtxt','buyexpdte','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->buyexpcod;

	// titulo
	$lv_title = $vew_lang->expenses;

	// modulo y programa
	$lv_mdlcod = 'BUY';
	$lv_prgcod = 'EXP';

	// librer?a de estilos bootstrap
	include_once('_library.frm');
	
	// valores x default
	if ( $vew_data->buyexpcod=='' ) {
		$vew_data->buyexpdte = date('d/m/Y');
		$vew_data->docsts = 'A';
	}

	$lv_srcobjtyp = strtoupper($vew_doc->getTagValue( $vew_data->sysdoccls->sysdocclsatr, 'srcobjtyp' ));
	$lv_impobjtyp = strtoupper($vew_doc->getTagValue( $vew_data->sysdoccls->sysdocclsatr, 'impobjtyp' ));
	$lv_impobjreq = strtoupper($vew_doc->getTagValue( $vew_data->sysdoccls->sysdocclsatr, 'impobjreq' ));

	$lv_rejarr = array(''=>'');
	foreach($vew_data->sysdoccls->sysdocclsrej as $lv_row) {
		if (strtoupper($vew_doc->getTagValue($lv_row['sysdocclsrejatr'],'rejman'))=='X'){
			$lv_rejarr[ $lv_row['sysdocrejcod'] ] = $lv_row['sysdocrejtxt'];
		}
	}
	
	// Botones por vista
  if( $vew_data->docsts=='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'29') ){
    $vew_tbl['btnaccdeldiv'] = array ('per'=>true, 'pos'=>'D', 'css'=>'divider');
    $vew_tbl['btnaccdel'] = array ('id'=>'btnaccdel', 'pos'=>'D', 'per'=>true, 'acc'=>'', 'ttl'=>$vew_lang->cancel, 'icn'=>'far fa-file-circle-xmark text-danger', 'css'=>'tmss-Opt tmssAlwaysEnabled tmssHiddeOnEdit text-danger');  
  }
  $vew_tbl['accL'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09') && $vew_data->sysdoctrecod!='C', 'acc'=>'');
	$vew_tbl['accR'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09') && $vew_data->sysdoctrecod!='C', 'acc'=>'');
	$vew_tbl['modL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl['modR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl['delsep'] = array('per'=> $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly && $vew_data->docsts!='C' );
	$vew_tbl['del'] = array('per'=> $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly && $vew_data->docsts!='C' );
	$vew_tbl['frmR'] = array('per'=>false);
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml( 'tmss_actcod' , 'hidden', '' ); ?>
    <?= gethtml( 'buyexptot' , 'hidden', $vew_data->buyexptot ); ?>
    <?= gethtml('impobjtyp' , 'hidden', '' ); ?>
		<textarea class="hidden" id="buyexpdoc" name="buyexpdoc"></textarea>
		<textarea class="hidden" id="buyexpdocimp" name="buyexpdocimp"></textarea>

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->buyexpcod; ?><?= gethtml( 'buyexpcod' , 'hidden', $vew_data->buyexpcod ); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-8">
							
							<div class="card">
								<div class="card-header">
									<div class="card-title"><?= $vew_lang->expenditure; ?>
										<div class="tmss-card-icon">
											<?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?>
											<?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
										</div>
									</div>
								</div>
								<div class="card-body tmss-card-body-edit">
									<?php
										echo gethtml('srcobjtyp','hidden',($vew_data->buyexpcod!=''?$vew_data->srcobjtyp:$vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'srcobjtyp')) );
										if ($lv_srcobjtyp=='HLT_PRS' || $lv_srcobjtyp=='BUY_SUP' || $lv_srcobjtyp=='EDU_TCH' || $lv_srcobjtyp=='HLT_PLN'){
											echo vew_boot($lv_col210, array('label'=>($lv_srcobjtyp=='HLT_PRS'?$vew_lang->provider:
																															 ($lv_srcobjtyp=='BUY_SUP'?$vew_lang->supplier:
																															 ($lv_srcobjtyp=='EDU_TCH'?$vew_lang->teacher:
																															 ($lv_srcobjtyp=='HLT_PLN'?$vew_lang->planning:'')))),
																											'input'=>vew_boot(
																												array('style'=>'search', 'readonly'=>($vew_data->srcobjcod!=''?true:$vew_readonly) ),
																												array('input'=>gethtml('srcobjtxt', 'typeahead', ($lv_srcobjtyp=='HLT_PLN'?$vew_data->srcobjcod:$vew_data->srcobjtxt),($vew_data->srcobjcod!=''?$lv_always_disabled:$lv_default)))
																											))
																		);
											echo gethtml('srcobjcod','hidden',$vew_data->srcobjcod);
										}
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('buyexptxt', 'doccmt1x50', $vew_data->buyexptxt, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', ($vew_data->docsts=='C'?'docstsacc':'docsts'),	$vew_data->docsts, ($vew_data->docsts=='C'?$lv_always_disabled:$lv_default) ) ));
									?>
								</div>
							</div>
							
						</div>
						<div class="col-md-4">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->data; ?>
									<span class="tmss-card-icon">
                    	<?= '<b><span id="buyexptotlbl"></span></b> '.strtolower($vew_data->curcod); ?>
                      <?= gethtml('curcod', 'hidden', $vew_data->curcod); ?>
                    </span>                  
                  </div>
                </div>
								<div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('buyexpdte',	'docdte',	$vew_data->buyexpdte,	$lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('buyexpcodext',	'doccmt1x20',	$vew_data->buyexpcodext,	$lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->rejection, 'input'=>gethtml('sysdocrejcod', $lv_rejarr, $vew_data->sysdocrejcod, $lv_default) ));
									?>
								</div>
							</div>
							
						</div>
					</div>
					<div id="buyexpdochot" name="buyexpdochot"></div>
				</div> <!-- fin tab001 -->
				
			</div> <!-- tabcontent -->
		</div> <!-- container-fluid -->
  </form>
	<script>
		// calcula totales de grilla
		function <?= $lv_sec; ?>_calcTotal(lp_hot) {
			var lst_buyexpdoctot = lp_hot.getDataAtProp("buyexpdoctot");
			var lv_buyexptot = 0;
			lst_buyexpdoctot.forEach(function(element) {
				lv_buyexptot+=Number(element);
			});
			$("#<?= $lv_sec; ?> #buyexptotlbl").text( numbro(lv_buyexptot).format("0,0.00") );
			$("#<?= $lv_sec; ?> #buyexptot").prop("value",lv_buyexptot);
		}
    
		<?php if ($lv_srcobjtyp=='HLT_PRS'){ ?>
      // srcobjtxt
       var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"srcobjcod" : "prscod", "srcobjtxt" : "prstxt"}}; 
      tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "hltprs", lo_get);
		<?php } ?>
    
		<?php if ($lv_srcobjtyp=='BUY_SUP'){ ?>
      // srcobjtxt
       var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"srcobjcod" : "supcod", "srcobjtxt" : "suptxt"}}; 
      tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "buysup", lo_get);
		<?php } ?>
    
		<?php if ($lv_srcobjtyp=='EDU_TCH'){ ?>
      // srcobjtxt
      var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"srcobjcod" : "tchcod", "srcobjtxt" : "tchtxt"}}; 
      tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "edutch", lo_get); 
		<?php } ?>

		// CONTABILIZAR
		$("#<?= $lv_sec; ?> #btnacc").on("click",function(e){
			BootstrapDialog.confirm({
				title: "Contabilizar",
				message:"Desea contabilizar el documento ?",
				type: BootstrapDialog.TYPE_PRIMARY,
				callback: function(result){
					if(result){
						<?= $lv_sec; ?>_fnc({action: "09"});
					}
				}
			});
		});

		// ANULAR CONTABILIZACION
		$("#<?= $lv_sec; ?> #btnaccdel").on("click",function(e){
			BootstrapDialog.confirm({
				title: "Anular Contabilizacion",
				message:"Desea anular la contabilizacion del documento ?",
				type: BootstrapDialog.TYPE_WARNING,
				callback: function(result){
					if(result){
						<?= $lv_sec; ?>_fnc({action: "29"});
					}
				}
			});
		});
	</script>
	<script>
  	// C O M P R O B A N T E S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if( <?= $lv_sec; ?>_hotdoc != undefined ) {
				if ( prop=="buyexpdoctot" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				} else if ( prop=="icn" ) {
					var lv_btn = "<a href='#' onclick='<?= $lv_sec; ?>_showDetails("+row+");' class='btn btn-default btn-sm'><span class='fa fa-ellipsis-h'></span></a>";
					var lv_sysdocrejcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( row, "sysdocrejcod" );
					if( lv_sysdocrejcod!="0" && lv_sysdocrejcod!="" && lv_sysdocrejcod!=null && lv_sysdocrejcod!=undefined ) {
						lv_btn += "&nbsp;<span class='fas fa-ban'></span>";
					}
					$(td).empty().append(lv_btn);
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				}
			}
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #buyexpdochot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],'); ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
      licenseKey: gv_handsontable_lc,
			colHeaders: [ "<?= $vew_lang->date; ?>", "<?= $vew_lang->type; ?>", "Nro.Comrpobante", "<?= $vew_lang->amount; ?>", "" ],
			columns: [
        {type: "date", data: "buyexpdocdte", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					dateFormat: 'DD/MM/YYYY',	correctFormat: true, allowEmpty: false,	datePickerConfig: {	firstDay: 0, showWeekNumber: false,	numberOfMonths: 1	}
				},
				{type: "autocomplete", data: "buyexptyptxt",width: 70, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						if ( query.length>1) {
              tmssCallProcessNoBackdrop("?prg=buyexptyp&act=17&prm_buyexptyptxt="+query,[],function(data){
                var lv_data = data.data
               	var lv_dat = [];
                for (var i=0; i < lv_data.length; i++) {
                    <?= $lv_sec; ?>_hotdocchg.push({
                        buyexptyptxt: lv_data[i]["buyexptyptxt"],
                        buyexptypcod: lv_data[i]["buyexptypcod"]
                    });
                    lv_dat.push( lv_data[i]["buyexptyptxt"] );
                }
              	process( lv_dat );
              });
						} else { process( [query] ); }
					},
					strict: true
				},
				{type: "text", data: "buyexpdocnum", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?> },
				{type: "numeric", data: "buyexpdoctot", width: 30, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "icn", width: 20, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true }
			],
			beforeChange : function(changes, source) {
				if(changes && changes.length && source=="edit" && source!="CopyPaste.paste"){
          if(changes[0][1]=="buyexptyptxt") {
            var lv_value = changes[0][3];
            for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
              if(<?= $lv_sec; ?>_hotdocchg[i].buyexptyptxt == lv_value) {
                changes.push([ changes[0][0], "buyexptypcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].buyexptypcod) ]);
              }
            }
          }
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["buyexpdoccod"]!="" && lv_dat[i]["buyexpdoccod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			},
			afterChange: function(changes, source) { if (<?= $lv_sec; ?>_hotdoc!=undefined) { <?= $lv_sec; ?>_calcTotal(<?= $lv_sec; ?>_hotdoc); } },
			afterRemoveRow: function(index, amount){ if (<?= $lv_sec; ?>_hotdoc!=undefined) { <?= $lv_sec; ?>_calcTotal(<?= $lv_sec; ?>_hotdoc); } }
		};
		var <?= $lv_sec; ?>_hotdoc;

		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->buyexpdoc as $lv_row){
          $lv_dte = new DateTime($lv_row['buyexpdocdte']);
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'buyexpdoccod:"'.$lv_row['buyexpdoccod'].'",'.
												'buyexpdocdte:"'.$lv_dte->format('d/m/Y').'",'.
												'buyexptypcod:"'.$lv_row['buyexptypcod'].'",'.
												'buyexptyptxt:\''.($lv_row['buyexptyptxt']??'').'\','.
												'buyexpdoctot: '.$lv_row['buyexpdoctot'].','.
												'buyexpdocnum:\''.($lv_row['buyexpdocnum']??'').'\','.
												'buyexpdoccmt:\''.($lv_row['buyexpdoccmt']??'').'\','.
												'sysdocrejcod:"'.($lv_row['sysdocrejcod']??'').'",'.
            						'supcod:"'.($lv_row['supcod']??'').'",'.
												'impobjlst: "",'.
												'buyexpdocatr:\''.($lv_row['buyexpdocatr']??'').'\','.
												'docsts:"'.$lv_row['docsts'].'"}';
												} 
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );

			<?php
				$i=0;
				foreach($vew_data->buyexpdoc as $lv_row){
					$lv_imparr = array();
					foreach($vew_data->buyexpdocimp as $lv_rowi){
						if($lv_row['buyexpdoccod']==$lv_rowi['buyexpdoccod'] || ( isset($lv_row['buyexpdoccodold']) && $lv_row['buyexpdoccodold']==$lv_rowi['buyexpdoccod']) ){
							$lv_imparr[]=array(
                'buyexpdocimpcod'=>$lv_rowi['buyexpdocimpcod'],
                'srcobjtyp'=>$lv_rowi['srcobjtyp'],
                'srcobjcod001'=>$lv_rowi['srcobjcod001'],
                'srcobjcod002'=>$lv_rowi['srcobjcod002']??'',
                'srcobjtxt'=>($lv_rowi['srcobjtxt']??($lv_rowi['impobjtxt']??'')),
                'cntobjtxt' => $lv_rowi['impobjcnttxt'] ?? '',
                'buyexpdocimpqty'=> isset($lv_rowi['buyexpdocimpqty']) ? number_format($lv_rowi['buyexpdocimpqty'],2) : '');
						}
					}
					$lv_impjsn = json_encode( $vew_doc->array_utf8_converter($lv_imparr) );
					if ( json_last_error() != JSON_ERROR_NONE ) { $lv_impjsn=''; }
					echo $lv_sec.'_hotdoc.setDataAtRowProp('.$i.',"impobjlst",'.$lv_impjsn.');';
					$i++;
				}
			?>

			<?= $lv_sec; ?>_hotdoc.render();
			<?= $lv_sec; ?>_calcTotal(<?= $lv_sec; ?>_hotdoc);
		});
	</script>
	<script>
		function <?= $lv_sec; ?>_showDetails( lv_row ) {
      var lv_title = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row,"buyexpdocdte")+" - "+<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row,"buyexptyptxt") + " - Nro: "+<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row,"buyexpdocnum");
			var lv_implst = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row,"impobjlst");
			lv_implst = (lv_implst==null?[]:lv_implst);
			var lv_pstdat=[ {name:"sysdocclscod",value:$("#<?= $lv_sec; ?> #sysdocclscod").prop("value")},
											{name:"buyexpdoccmt",value:<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row,"buyexpdoccmt")},
											{name:"sysdocrejcod",value:<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row,"sysdocrejcod")},
											{name:"impobjlst",value:JSON.stringify( lv_implst )},
											{name:"buyexpdocatr",value:<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row,"buyexpdocatr")},
											{name:"readonly",value:"<?= $vew_readonly; ?>"}
										];
			tmssCallProcess("?prg=buyexp&act=13", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: lv_title,
					message: $(data),
          draggable: true,
					type: BootstrapDialog.TYPE_PRIMARY,
					size: BootstrapDialog.SIZE_WIDE,
					buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } }
                    <?php if(!$vew_readonly){ ?> 
                    	, {	label: "Aceptar", cssClass: "btn-success",	action: function(dialogItself){
                        var lv_dat = eval( dialogItself.$modalBody.find("section").attr("id") + "_getData()" );
                        // validar porcentaje
                        var lv_pct = lv_dat.reduce( (prev, curr) => {if(curr.delete)  return prev; return prev + (Number(curr.buyexpdocimpqty) || 0);}, 0);
                        var lv_item0 = lv_dat.some(item => Number(item.buyexpdocimpqty) == 0);
                        if (lv_item0 && lv_dat.length>1) {
                          toastr.warning("Ning&uacute;n elemento puede tener 0%.");
                          return;
                        }
                        
                        if(lv_pct != 100 && lv_dat.length > 1){
                          toastr.warning("El porcentaje total debe ser 100%. Actualmente es ["+lv_pct+"%]")
                          return
                        }else{
                          if(lv_dat.length == 1){
                            lv_dat[0].buyexpdocimpqty = 100;
                          }

                          $("#<?= $lv_sec; ?> input[name=impobjtyp]").val( dialogItself.getModalBody().find("#impobjtyp").val() );

                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"buyexpdoccmt",dialogItself.getModalBody().find("#buyexpdoccmt").val());
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"sysdocrejcod",dialogItself.getModalBody().find("#sysdocrejcod").val());
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"buyexpdocatr",dialogItself.getModalBody().find("#buyexpdocatr").text());
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"impobjlst", lv_dat );

                          dialogItself.close();
                        }
                    	}
                  	}
                  <?php } ?>
                 ]
        });
			});
			return false;
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
				} else if (gv_<?= $lv_sec; ?>_last_action=="29") {
					toastr.info("Documento Anulado.");
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
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }

				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
        var lv_index = 0;
        var lv_impobjarr = [];
        var lv_impret = true;
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["buyexpdoctot"]!="" && lo_dat[i]["buyexpdoctot"]!=undefined ) {
						<?php if($lv_impobjreq!=''){ ?>
              var lv_activos = lo_dat[i]["impobjlst"].filter(function(item) {
                return !item.deleted;
            });
						if(lo_dat[i]["impobjlst"]=="" || lo_dat[i]["impobjlst"]==undefined || lv_activos.length == 0 ){
							<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 0, "valid", false);
							<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 1, "valid", false);
							<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 2, "valid", false);
							<?= $lv_sec; ?>_hotdoc.render();
              lv_impret = false;
						} else {
							<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 0, "valid", true);
							<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 1, "valid", true);
							<?= $lv_sec; ?>_hotdoc.setCellMeta(i, 2, "valid", true);
						}
						<?php } ?>
            if ("impobjlst" in lo_dat[i] && lo_dat[i].impobjlst != null && lo_dat[i].impobjlst.length > 0) {
              lo_dat[i]["impobjlst"] = lo_dat[i]["impobjlst"].map((item) => ({...item, index: lv_index,srcobjtyp:"<?=$lv_impobjtyp ?>"}));
              lv_impobjarr.push(...lo_dat[i]["impobjlst"]);
            }
            var lv_buyexpcod =$("#<?= $lv_sec; ?> #buyexpcod").prop("value");
						lv_arr.push({	"buyexpdoccod":(lv_buyexpcod!='')?lo_dat[i]["buyexpdoccod"]:'',
													"buyexpdocdte":lo_dat[i]["buyexpdocdte"],
													"buyexptypcod":lo_dat[i]["buyexptypcod"],
													"buyexpdoctot":lo_dat[i]["buyexpdoctot"],
													"buyexpdocnum":lo_dat[i]["buyexpdocnum"],
													"buyexpdoccmt":lo_dat[i]["buyexpdoccmt"],
													"sysdocrejcod":lo_dat[i]["sysdocrejcod"],
													"buyexpdocatr":lo_dat[i]["buyexpdocatr"],
                         	"supcod":lo_dat[i]["supcod"],
                         	"index": lv_index
												});
            lv_index++;
					}
				}
				if (!lv_impret){								toastr.warning("Se debe indicar una imputacion."); return false; }
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({ "buyexpcod":lv_buyexpcod,
												"buyexpdoccod": <?= $lv_sec; ?>_hotdocdel[i]["buyexpdoccod"],
												"delete":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #buyexpdoc").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #buyexpdoc").prop("value", JSON.stringify( lv_arr ) );
				}
        if(lv_impobjarr.length==0){
          $("#<?= $lv_sec; ?> #buyexpdocimp").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #buyexpdocimp").prop("value", JSON.stringify( lv_impobjarr ) );
				}
			}
		}
	</script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
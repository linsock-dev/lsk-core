<?php
	// url del formulario
  $lv_lnk = '?prg=slsprclst&act=03&prm_slsprclstcod='.$vew_data->slsprcver->slsprclstcod.'&prm_slsprclstvercod='.$vew_data->slsprcver->slsprclstvercod;

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = $vew_data->slsprcver->slsprclstvercod;

	// titulo
	$lv_title = $vew_lang->prices;
	
	// módulo y programa
	$lv_mdlcod = 'SLS';
	$lv_prgcod = 'PRC';

	if( $vew_sec->hasPermission('SLS','PRC','02') ){ $vew_actcod='02'; }
	$lv_hassca = ($vew_doc->getTagValue($vew_data->slsprc->sysdoccls->sysdocclsatr,'prccndcod') != '' && $vew_doc->getTagValue($vew_data->slsprc->sysdoccls->sysdocclsatr,'prccndaccseqord') !='');

	// librería de estilos bootstrap
	include_once('_library.frm');

	$vew_tbl['del'] = array('per'=>false);
	$vew_tbl['delsep'] = array('per'=>false);
	$vew_tbl['flt'] = array('pos'=>'R','per'=>true, 'ttl'=>'', 'id'=>'btnflt','tooltip'=>$vew_lang->filter, 'icn'=>'far fa-filter', 'css'=>'btn tmss-navbar-btn navbar-btn tmss-desk-btn', 'acc'=>'tmssFilterShowDialog(gv_'.$lv_sec.'_flt,'.$lv_sec.'_filterPrices);' );
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?> 
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('slsprclstcod','hidden',$vew_data->slsprcver->slsprclstcod); ?>
		<?= gethtml('slsprclstvercod','hidden',$vew_data->slsprcver->slsprclstvercod); ?>
		<?= gethtml('curcod','hidden',$vew_data->slsprc->curcod); ?>
		<?= gethtml('vewfldflt001','hidden',''); ?>
		<?= gethtml('vewmaxrec001','hidden',''); ?>
		<?= gethtml('slsprcflt','hidden',''); ?>
		<textarea id="slsprclst" name="slsprclst" class="hidden"></textarea>
		
    <div class="container-fluid">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->prices; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->slsprc->slsprclstcod.' / '.$vew_data->slsprcver->slsprclstvercod; ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">	
					<div class="card tmss-hot-ttl">
						<div class="card-header">
							<div class="card-title">
								<?= $vew_data->slsprc->slsprclsttxt; ?>
								<small class="tmss-desk-btn">( <?= $vew_lang->validity.': '.$vew_data->slsprcver->slsprclststrdte->format('d/m/Y'); ?> )</small>
								<?php if( $vew_data->slsprcver->slsprclstancsrc==3){ ?><a id="btnupl" class="card-icon tmssAlwaysEnabled" title="<?= $vew_lang->upload; ?>"><i class="far fa-upload" ></i></a><?php } ?>
								<a id="btnver" class="card-icon tmssAlwaysEnabled" title="<?= $vew_lang->versions; ?>"><i class="far fa-folder-tree" ></i></a> 
                <?php
                $lv_validity = date('Y-m-d');
                if( ($vew_data->slsprcver->slsprclstancsrc==1 || $vew_data->slsprcver->slsprclstancsrc==2) && $vew_data->slsprcver->slsprclstancupd==1 
                && $lv_validity >= $vew_data->slsprcver->slsprclststrdte->format('Y-m-d') && $lv_validity <= $vew_data->slsprcver->slsprclstenddte->format('Y-m-d')
                ){ ?><a id="btnupd" class="card-icon tmssAlwaysEnabled" title="<?= $vew_lang->synchronize; ?>" ><i class="far fa-sync"></i></a><?php } ?>
								<a id="btnsim" class="card-icon tmssAlwaysEnabled" title="<?= $vew_lang->updatePrices; ?>"><i class="far fa-calculator"></i></a>
							</div>
						</div>
					</div>
					<div id="slsprclsthot" name="slsprclsthot"></div>
				</div>
				
			</div><!-- /tab-content -->
    </div> <!-- /container-fluid -->    
	</form>
	
	<!--VISTA DE VARIACION DE PRECIOS-->
	<div class="hidden" id="prcvar">
		<form method="POST" class="form-horizontal tmss-form-horizontal pb-0">
      <div class="card">
      	<div class="card-body">
					<p><span class="card-icon"><i class="far fa-circle-info fa-2x text-info"></i></span> Utilice estas opciones para establecer el precio usando precios/importes fijos o porcentuales.</p>
					<?php
						echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 'input'=>gethtml('prcvartyp', array(''=>'','F'=>'Sumar/Restar','R'=>'Reemplazar'), '', $lv_default) ));
						if($vew_data->slsprcver->slsprclstancsrc==1 || $vew_data->slsprcver->slsprclstancsrc==2) {
          		echo vew_boot($lv_col210, array('label'=>$vew_lang->variation.' (%)', 'input'=>gethtml('prcvarper', 'docnum0300', '', $lv_default) ));
          	}
				
						echo vew_boot($lv_col210, array('label'=>$vew_lang->price, 'input'=>gethtml('prcvaramt', 'docnum0300', '', $lv_default) ));
					?>
					<hr>
					<p><span class="card-icon"><i class="far fa-circle-info fa-2x text-info"></i></span> Puede modificar el precio resultante hasta alcanzar el valor de redondeo. <br><b>Ejemplo:</b> el valor 100, actualizar&aacute; el precio entre 50 al 149 como 100.</p>
					<div class="form-group tmss-form-group">
						<label class="col-sm-2 control-label text-nowrap"><?= $vew_lang->rounding; ?></label>
						<div class="col-sm-10"><input type="NUMBER" id="prcvarrnd" name="prcvarrnd" value="" maxlength="10" min="-99999999" max="99999999" step="0.01" class="form-control"></div>
					</div>
        </div>
      </div><!-- /card -->
		</form>
	</div> 
	<!-- FIN  VISTA DE VARIACION DE PRECIOS-->	
	
	<script>
  // sinconizar precios base (costo / precio)
	$("#<?= $lv_sec; ?> #btnupd").on("click", function(e){ e.preventDefault();
    BootstrapDialog.show({
      title: "Sincronizar Precios",
      type: BootstrapDialog.TYPE_INFO,
      message: "¿Desea actualizar solo los materiales filtrados o todos?",
      buttons:[{ label: "Todos", cssClass: "btn-default", action: function(dialogRef){
        					if (gv_<?= $lv_sec; ?>_flt) {
                    for (var i = 0; i < gv_<?= $lv_sec; ?>_flt.length; i++) {
                      gv_<?= $lv_sec; ?>_flt[i].fldvalstr = "";
                    }
                  }
                  <?= $lv_sec; ?>_filterPrices(gv_<?= $lv_sec; ?>_flt);
                	var lv_pstdat = [{name:"slsprclstcod",value:"<?= $vew_data->slsprc->slsprclstcod; ?>"},
                                   {name:"slsprclstvercod", value:"<?= $vew_data->slsprcver->slsprclstvercod; ?>"},
                                   {name:"slsprclstancupd",value:"1"},
                                  ]
                  tmssCallProcess("?prg=slsprclst&act=<?= ($vew_data->slsprcver->slsprclstancsrc=='1'?'06':'07'); ?>", lv_pstdat, function(data){
                    <?= $lv_sec; ?>_synchronizePrices(data);
                    dialogRef.close();
                  });
                }
              },
              {label: "Filtrados", cssClass: "btn-warning", action: function(dialogRef){
                var lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
                var lv_pstdat = [{name:"slsprclstcod",value:"<?= $vew_data->slsprc->slsprclstcod; ?>"},
                                 {name:"slsprclstvercod", value:"<?= $vew_data->slsprcver->slsprclstvercod; ?>"},
                                 {name:"slsprclstancupd",value:"1"},
                                 {name:"vewfldflt", value: lv_fltint["fltstr"]}
                                ]
                tmssCallProcess("?prg=slsprclst&act=<?= ($vew_data->slsprcver->slsprclstancsrc=='1'?'06':'07'); ?>", lv_pstdat, function(data){
                  <?= $lv_sec; ?>_synchronizePrices(data);
                  dialogRef.close();
                });
              }},
              { label: "Cancelar", cssClass: "btn-danger", action: function(dialogRef){ dialogRef.close(); } }
      ]
    });
	});
    
  function <?= $lv_sec; ?>_synchronizePrices(data) {
  	var lv_srcRaw = <?= $lv_sec; ?>_hotdoc.getSourceData();
    var lv_src = lv_srcRaw.filter(function(row) { return row && row.slsprcsrccod;});
    var lv_ids = {};
    
    for (var i = 0; i < lv_src.length; i++) {
      if (lv_src[i].slsprcsrccod) {
        lv_ids[lv_src[i].slsprcsrccod] = i;
      }
    } 

    for (var i = 0; i < data.length; i++) {
      var lv_item = data[i];
      var lv_cod = lv_item.slsprcsrccod;
      
      if (lv_ids[lv_cod] !== undefined) {
        var lv_newCost = parseFloat(lv_item.slsprcref) || 0;
        var lv_id = lv_ids[lv_cod];
				var lv_oldCost = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_id, 'slsprcref') || 0;
        
        if (lv_newCost.toFixed(3) !== lv_oldCost) {
          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_id, 'slsprcref', lv_newCost, "setting");
          var lv_prcvar = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_id, 'slsprcvar') || 0;
          var lv_prc = Math.round(((lv_newCost != undefined ? lv_newCost : 0) * (1 + (isNaN(lv_prcvar) ? 0 : lv_prcvar / 100))) * 100) / 100;
          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_id, 'slsprc', lv_prc, "setting");
          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_id, 'save', true, "setting");
        }
      } else {
        var lv_prc = Math.round(((lv_item.slsprcref != undefined ? lv_item.slsprcref : 0) * (1 + (isNaN(lv_item.slsprcvar) ? 0 : lv_item.slsprcvar / 100))) * 100) / 100;
        var lv_dat = {	slsprclstcod: lv_item.slsprclstcod,
												slsprclstvercod: lv_item.slsprclstvercod,  
												slsprcsrctyp: lv_item.slsprcsrctyp || "STK_MAT",
												slsprcsrccod: lv_item.slsprcsrccod,
												matsysdocclstxt: lv_item.matsysdocclstxt,
												slsprcsrctxt: <?= $lv_sec; ?>_decodeHtml(lv_item.slsprcsrctxt),
												slsprcref: (lv_item.slsprcref == null)? 0:lv_item.slsprcref,
												slsprcvar: (lv_item.slsprcvar == null)? 0:lv_item.slsprcvar,
												slsprc: lv_prc,
												slsprcqty: lv_item.slsprcqty,
												slsprcuntcod: lv_item.slsprcuntcod,
												matclstxt: lv_item.matclstxt,
												mathietxt: lv_item.mathietxt,
                      	grldatprcsca: "[]",
                      	save: true
											};
        lv_src.push(lv_dat);
      }
    }
    <?= $lv_sec; ?>_hotdoc.loadData(lv_src);
  }
  
    $(function(e){
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab001']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
		});
		
		// versiones. permite cambiar la version que se esta visualizando
		$("#<?= $lv_sec; ?> #btnver").on("click",function(e){ e.preventDefault();
			tmssPopup("<?= $vew_lang->versions; ?>","?prg=slsprcver&act=08&prm_vewcod=VEW_SLS_PRC_VER_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[slsprclstvercod:pv.slsprclstvercod]&prm_fldflt=[pv.slsprclstcod:"+$("#<?= $lv_sec; ?> #slsprclstcod").prop("value")+"]");
		});
		$("#<?= $lv_sec; ?> #slsprclstvercod").on("change",function(e){
			toastr.info("Visualizando precios de validez <strong>#"+$("#<?= $lv_sec; ?> #slsprclstvercod").prop("value")+"</strong>");
			tmssLink("?prg=slsprclst&act=03",[{target:"_replace_with",target_id:"#<?= $lv_sec; ?>",
																			 post_data:[{name:"slsprclstcod",value:$("#<?= $lv_sec; ?> #slsprclstcod").val()},
																									{name:"slsprclstvercod",value:$("#<?= $lv_sec; ?> #slsprclstvercod").val()}]
																			}]);
		});
	</script>
	<script>		
		//FILTRO PERSONALIZADO 
		var gv_<?= $lv_sec; ?>_flt;

		<?php if ($vew_data->slsprcflt=='[]' || $vew_data->slsprcflt=='') { ?>
			gv_<?= $lv_sec; ?>_flt = [{'fldttl': '<?= $vew_lang->id; ?>', 'fldcod': 'pl.slsprcsrccod', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '', 'fldvalend': ''},
																{'fldttl': '<?= $vew_lang->class; ?>', 'fldcod': 'dcm.sysdocclstxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},		
        												{'fldttl': '<?= $vew_lang->description; ?>', 'fldcod': 'slsprcsrctxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->source; ?>', 'fldcod': 'pl.slsprcref', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->variation; ?>', 'fldcod': 'pl.slsprcvar', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->price; ?>', 'fldcod': 'pl.slsprc', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->quantity; ?>', 'fldcod': 'pl.slsprcqty', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
                                {'fldttl': '<?= $vew_lang->classification; ?>', 'fldcod': 'mc.matclstxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
                                {'fldttl': '<?= $vew_lang->hierarchy; ?>', 'fldcod': 'mh.mathietxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
																{'fldcod': 'vewmaxrec','fldvalstr': '9999'}];
		<?php } else {?>
			gv_<?= $lv_sec; ?>_flt = JSON.parse('<?= html_entity_decode($vew_data->slsprcflt); ?>');
		<?php }; ?>
		
		
		// carga de precios
		function <?= $lv_sec; ?>_filterPrices(lp_flt) {
			// condiciones del filtro
			$("#<?= $lv_sec; ?> #slsprcflt").val(JSON.stringify(lp_flt));

			var lv_fltint;
			if(lp_flt!=null){
				lv_fltint = tmssFilterParseToInternal(lp_flt);
				gv_<?= $lv_sec; ?>_flt = lp_flt;
				$("#<?= $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
			} else {
				lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
			}
			if(lv_fltint["maxrec"]==""){lv_fltint["maxrec"]="9999";}
      
      // mando filtros por post para tomarlos cuando se efectue una copia y mantener el filtro del usuario al traer materiales
      $("#<?= $lv_sec; ?> #vewmaxrec001").val(lv_fltint["maxrec"]);
      $("#<?= $lv_sec; ?> #vewfldflt001").val(lv_fltint["fltstr"]);
      
			lv_pstdat=[	{"name":"slsprclstcod", "value":$("#<?= $lv_sec; ?> #slsprclstcod").prop("value") },
									{"name":"slsprclstvercod", "value":$("#<?= $lv_sec; ?> #slsprclstvercod").prop("value") },
									{"name":"vewmaxrec", "value": lv_fltint["maxrec"] }, 
									{"name":"vewfldflt", "value": lv_fltint["fltstr"] },
									{"name":"prccndcod", "value": "<?= $vew_doc->getTagValue($vew_data->slsprc->sysdoccls->sysdocclsatr,'prccndcod'); ?>" },
									{"name":"prccndacccod", "value": "<?= $vew_doc->getTagValue($vew_data->slsprc->sysdoccls->sysdocclsatr,'prccndaccseqord'); ?>" }
								];
			tmssCallProcess("?prg=slsprclst&act=23", lv_pstdat, function(data){
				var lv_dat = [];
				var lv_buffer="";
				lv_buffer="<span class='pagination-info'>Registros encontrados <span class='badge'>"+(data["data"].length)+"</span></span>";
				$("#<?= $lv_sec; ?> #datqty").html(lv_buffer);
				
				for (var stu in data["data"]) {
					lv_prcsca = [];
					for (var sca in data['prcsca']) {
						if (data["data"][stu].slsprclstprccod == data['prcsca'][sca].slsprclstprccod){
							lv_prcsca.push(data['prcsca'][sca]);
						}
					}
          
					lv_dat.push({	slsprclstprccod: data["data"][stu].slsprclstprccod,
												slsprclstcod: data["data"][stu].slsprclstcod,
												slsprclstvercod: data["data"][stu].slsprclstvercod,  
												slsprcsrctyp: data["data"][stu].slsprcsrctyp, 
												slsprcsrccod: data["data"][stu].slsprcsrccod,
												matsysdocclstxt: data["data"][stu].matsysdocclstxt,
												slsprcsrctxt: <?= $lv_sec; ?>_decodeHtml(data["data"][stu].slsprcsrctxt),
												slsprcref: (data["data"][stu].slsprcref == null)? 0:data["data"][stu].slsprcref,
												slsprcvar: (data["data"][stu].slsprcvar == null)? 0:data["data"][stu].slsprcvar,
												slsprc: data["data"][stu].slsprc,
												slsprcqty: data["data"][stu].slsprcqty,
												slsprcuntcod: data["data"][stu].slsprcuntcod,
												matclstxt: data["data"][stu].matclstxt,
												mathietxt: data["data"][stu].mathietxt,
												grldatprcsca: JSON.stringify(lv_prcsca)            						
											});
				}
				<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
				<?= $lv_sec; ?>_hotdoc.render();
			});
    }
    
    function <?= $lv_sec; ?>_decodeHtml(lp_html) {
      var lv_txt = document.createElement("textarea");
      lv_txt.innerHTML = lp_html;
      return lv_txt.value;
		}		
	</script>
	<script>
    
    //SUBIDA DE ARCHIVO
		$("#<?= $lv_sec; ?> #btnupl").on("click",function(e){ e.preventDefault();   
			var lv_pstdat =[{name:"slsprclstcod",value:$("#<?= $lv_sec; ?> #slsprclstcod").val()},
                      {name:"slsprclstvercod",value:$("#<?= $lv_sec; ?> #slsprclstvercod").val()},
                      {name:"sysdocclscod",value:$("#<?= $lv_sec; ?> #sysdocclscod").val()}
                    ];
   		tmssCallProcess("?prg=slsprclst&act=slsprcupl", lv_pstdat, function(data){
        BootstrapDialog.show({
					title: "<?= $vew_lang->upload; ?>",
					message: $(data),
					closable: true,
					draggable: true,
					type: BootstrapDialog.TYPE_PRIMARY,
					size: BootstrapDialog.SIZE_WIDE,
					buttons: [{label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default'", action: function(dialog){ dialog.close();} },
										{label: "<?= $vew_lang->continue ?>", cssClass: "btn-success hidden",id:"btnnxt",	action: function(dialog){dialog.$modalBody.find("#btnsve").trigger("click");}}
                   ],
					onhide: function(dialog){
						//recupero codigo y texto
						lv_slsprcrsh=dialog.$modalBody.find("#slsprcrsh").val();
						//actualizo o no la vista
						if(lv_slsprcrsh){ <?= $lv_sec; ?>_filterPrices(gv_<?= $lv_sec; ?>_flt); }
					}
				});
    	});
		});
	</script>
	<script>
		// VARIACION DE PRECIOS
		$("#<?= $lv_sec; ?> #btnsim").on("click",function(e){ e.preventDefault()
			BootstrapDialog.show({
				title: "<?= $vew_lang->updatePrices; ?>",
				message: $("#<?= $lv_sec; ?> #prcvar").clone().removeClass("hidden"),
				type: BootstrapDialog.TYPE_PRIMARY,
				closable: true,
        draggable: true,
				buttons:[	{label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(e){e.close();} }, 
									{label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success", action: function(dialog){
										// recupero valores del formulario
										var lv_vartyp = dialog.getModalBody().find("#prcvartyp").val();
										var lv_varamt = dialog.getModalBody().find("#prcvaramt").val();
										var lv_varper = dialog.getModalBody().find("#prcvarper").val();
										var lv_varrnd = dialog.getModalBody().find("#prcvarrnd").val();
										
										// actualizo valores
										var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
										for(var i = 0; i < lo_dat.length -1 ; i++){											
											if(lo_dat[i]["slsprcref"]==undefined){ lo_dat[i]["slsprcref"]=0; }
											if(lo_dat[i]["slsprcvar"]==undefined){ lo_dat[i]["slsprcvar"]=0; }
											if(lo_dat[i]["slsprcprc"]==undefined){ lo_dat[i]["slsprcprc"]=0; }
											// actualizo
											if(Number(lv_varamt)!=0){
												lo_dat[i]["slsprc"] = (lv_vartyp=="R"?lv_varamt:Number(lo_dat[i]["slsprc"])+Number(lv_varamt)); 
												if(Number(lo_dat[i]["slsprcref"])!=0){
                        	lo_dat[i]["slsprcvar"] = ((Number(lo_dat[i]["slsprc"])-Number(lo_dat[i]["slsprcref"]))/lo_dat[i]["slsprcref"])*100;
                        }
											} else if (Number(lv_varper??0)!=0){
												lo_dat[i]["slsprcvar"] = (lv_vartyp=="R"?lv_varper:Number(lo_dat[i]["slsprcvar"])+Number(lv_varper));
                        if(Number(lo_dat[i]["slsprcref"])!=0){
                        	lo_dat[i]["slsprc"] = Number(lo_dat[i]["slsprcref"]) * (1+(Number(lo_dat[i]["slsprcvar"])/100));
                        }else{
                        	lo_dat[i]["slsprc"] = Number(lo_dat[i]["slsprc"]) * (1+Number(lv_varper)/100);
                        }
											}
                      //input de redondeo
                      
											if(Number(lv_varrnd)!=0){
											// calculo redondeo
											lo_dat[i]["slsprc"] = Math.round(Number(lo_dat[i]["slsprc"])/ Number(lv_varrnd)) * Number(lv_varrnd); 
                      lo_dat[i]["slsprcvar"] = ((Number(lo_dat[i]["slsprc"])-Number(lo_dat[i]["slsprcref"]))/Number(lo_dat[i]["slsprcref"]!=0?lo_dat[i]["slsprcref"]:1))*100;;
                      }
										}
										
										// vuelvo a cargar los valores en la grilla
										<?= $lv_sec; ?>_hotdoc.loadData( lo_dat );
										dialog.close();
									}}], 
				onshown: function(dialog){
					dialog.getModalBody().find("#prcvaramt").on("keyup", function(){ dialog.getModalBody().find("#prcvarper").prop("value",""); });
					dialog.getModalBody().find("#prcvarper").on("keyup", function(){ dialog.getModalBody().find("#prcvaramt").prop("value",""); });
				} 
			});
		});	
	</script>	
	<script>
		//
		//
		//	P R E C I O S
		//
		//
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {	
 			var lv_ro = <?= ($vew_readonly?'true':'false'); ?>;
      var lv_ro_color = "#F1F1F1";
      var lv_color = "#FFFFFF";
      
      var lv_sca = typeof <?= $lv_sec; ?>_hotdoc != "undefined" && <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( row, "grldatprcsca" ) != null;
      if(lv_sca){
        var lv_scahot = JSON.parse( <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( row, "grldatprcsca" ) );
        //si no hay ninguna columna no eliminada cuenta que no hay escala
        lv_sca=(lv_scahot.length>0?(typeof lv_scahot[0]["deleted"] != "undefined"?false:lv_sca):false)
      }      
      td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
			if ( prop=="slsprcsrctxt" ) {
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
			} else if ( prop=="slsprcsrccod" ) {
				Handsontable.renderers.TextRenderer.apply(this, arguments);			
        td.style.backgroundColor = "#F1F1F1";
			} else if ( prop=="slsprcuntcod" ) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = (lv_ro || lv_sca?lv_ro_color:lv_color);
			} else if ( prop=="slsprcref" ) {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);				
				td.style.backgroundColor = lv_ro_color;
			} else if(prop=="icn"){			
				td.style.backgroundColor = lv_ro_color;
        if( typeof <?= $lv_sec; ?>_hotdoc != "undefined" ){
            var lv_rowdat = <?= $lv_sec; ?>_hotdoc.getSourceDataAtRow(row);
            var lv_valid = typeof lv_rowdat.slsprcqty != "undefined" && typeof lv_rowdat.slsprcuntcod != "undefined" && typeof lv_rowdat.slsprc != "undefined";
            if( lv_valid && <?= ( $vew_actcod != '00' && $vew_actcod != '03' ? true : "lv_sca" ); ?> ){
              $(td).empty().append("<div class='text-center cursor-pointer' onclick='<?= $lv_sec; ?>_priceScale("+row+");'><a href='#' class='" + (lv_sca?"tmss-a-true":"tmss-a-false") + "'><i class='far fa-chart-line'></i></a></div>");
            }
          }
        }else if(prop=="matsysdocclstxt" || prop=="matclstxt" || prop=="mathietxt"){		
          Handsontable.renderers.TextRenderer.apply(this, arguments);
          td.style.backgroundColor = "#F1F1F1";
        } else {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);			
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}

			var prclstancsrc = $("#<?= $lv_sec ?> #slsprclstancsrc").prop("value");
			if( prop == "slsprc"){
				if(prclstancsrc == "1" || prclstancsrc == "2"){
					cellProperties.readOnly = true;
					td.style.backgroundColor = "#F1F1F1";
				} else {
					<?=  $vew_readonly ? 'cellProperties.readOnly = true': 'cellProperties.readOnly = ""'?>;
				}
			}

			if( prop == "slsprcvar"){
				if(prclstancsrc == "" || prclstancsrc == "3"){
					cellProperties.readOnly = true;
					td.style.backgroundColor = "#F1F1F1";
				}else {
					<?=  $vew_readonly ? 'cellProperties.readOnly = true': 'cellProperties.readOnly = ""'?>;
				}
			}
		};
    var <?= $lv_sec; ?>_hotrowselected = [];
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #slsprclsthot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1'); ?>,
			colHeaders:["<?= $vew_lang->id; ?>", 
									"<?= $vew_lang->description; ?>", 
									<?php if($vew_data->slsprcver->slsprclstancsrc==1 || $vew_data->slsprcver->slsprclstancsrc==2){ echo '"'.($vew_data->slsprcver->slsprclstancsrc==1?$vew_lang->cost:$vew_lang->price).'", "'. $vew_lang->variation.'",'; } ?> 
									"<?= $vew_lang->price; ?>", 
									"<?= $vew_lang->quantity; ?>", 
									"<?= $vew_lang->um; ?>", 
									<?php if($lv_hassca){ echo '"'.$vew_lang->scale.'",'; } ?> 
									"<?= $vew_lang->class; ?>", 
									"<?= $vew_lang->classification; ?>", 
									"<?= $vew_lang->hierarchy; ?>"],
			columns: [				
				{type: "text", data: "slsprcsrccod", width: 15, renderer: <?= $lv_sec; ?>_hotdoc_renderer,editor: false, <?= ($vew_readonly?'readOnly: true, ':'readOnly: true'); ?>},
        {type: "autocomplete", data: "slsprcsrctxt", width:85, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						if ( <?= $lv_sec; ?>_hot_paste==false ) {
							switch ( "<?= $vew_doc->getTagValue($vew_data->slsprc->sysdoccls->sysdocclsatr,'srcobjtyp'); ?>" ) {
								case "STK_MAT":
									$.ajax({
										url:"?prg=stkmat&act=17", dataType:"json", data:{prm_mattxt: query},
										complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
										success: function (response) {
											var lv_dat = [];
											<?= $lv_sec; ?>_hotdocchg = [];
											for (var i=0; i < response.data.length; i++) {
												<?= $lv_sec; ?>_hotdocchg.push( {slsprcsrctxt: response.data[i]["mattxt"], 
                                                         slsprcsrctyp: "STK_MAT", slsprcsrccod: response.data[i]["matcod"], 
                                                         slsprcuntcod: response.data[i]["matuntcod"], 
                                                         slsprcqty: response.data[i]["matcstqty"],
                                                         matcst: response.data[i]["matcst"]} );
												lv_dat.push( response.data[i]["mattxt"] );
											}
											process( lv_dat );
										}
									});
									break;
								case "EDU_MOD":
									$.ajax({
										url:"?prg=edumod&act=17", dataType:"json", data:{prm_edumodtxt: query},
										complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
										success: function (response) {
											var lv_dat = [];
											<?= $lv_sec; ?>_hotdocchg = [];
											for (var i=0; i < response.data.length; i++) {
												<?= $lv_sec; ?>_hotdocchg.push( {slsprcsrctxt: response.data[i]["edumodtxt"], slsprcsrctyp: "EDU_MOD", slsprcsrccod: response.data[i]["edumodcod"], slsprcuntcod: "UN", matcst: 0} );
												lv_dat.push( response.data[i]["edumodtxt"] );
											}
											process( lv_dat );
										}
									});
									break;
                case "HLT_MOD":
									$.ajax({
										url:"?prg=hltmod&act=17", dataType:"json", data:{prm_hltmodtxt: query},
										complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
										success: function (response) {
											var lv_dat = [];
											<?= $lv_sec; ?>_hotdocchg = [];
											for (var i=0; i < response.data.length; i++) {
												<?= $lv_sec; ?>_hotdocchg.push( {slsprcsrctxt: response.data[i]["hltmodtxt"], slsprcsrctyp: "HLT_MOD", slsprcsrccod: response.data[i]["hltmodcod"], slsprcuntcod: "UN", matcst: 0} );
												lv_dat.push( response.data[i]["hltmodtxt"] );
											}
											process( lv_dat );
										}
									});
									break;
								case "CNS_TSK":
									$.ajax({
										url:"?prg=cnstsk&act=17", dataType:"json", data:{prm_cnstsktxt: query},
										complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
										success: function (response) {
											var lv_dat = [];
											<?= $lv_sec; ?>_hotdocchg = [];
											for (var i=0; i < response.data.length; i++) {
												<?= $lv_sec; ?>_hotdocchg.push( {slsprcsrctxt: response.data[i]["cnstsktxt"], slsprcsrctyp: "CNS_TSK", slsprcsrccod: response.data[i]["cnstskcod"], slsprcuntcod: "UN", matcst: 0} );
												lv_dat.push( response.data[i]["cnstsktxt"] );
											}
											process( lv_dat );
										}
									});
									break;
							}
							
						}
					},
					strict: true
				},
				<?php if($vew_data->slsprcver->slsprclstancsrc==1 || $vew_data->slsprcver->slsprclstancsrc==2) { ?>
					{type: "numeric", data: "slsprcref", width: 20, renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
					{type: "numeric", data: "slsprcvar", width: 15, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				<?php } ?>
				{type: "numeric", data: "slsprc", width: 20, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "slsprcqty", width: 20, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "slsprcuntcod", width: 10, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
        <?php if($lv_hassca){ ?>
					{type: "text", 		data: "icn", width:15,renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
				<?php } ?>
				{type: "text", data: "matsysdocclstxt", width: 30, renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true},
				{type: "text", data: "matclstxt", width: 30, renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true},
				{type: "text", data: "mathietxt", width: 30, renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true}
			],
      afterChange: function(changes, source) { 
				if (changes && changes.length && <?= $lv_sec; ?>_hotdoc!=undefined && source!="setting") {
          for(var i=0; i<changes.length; i++) {
            var lv_row = changes[i][0];
            <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( lv_row, "save", true, "setting" );
          }
          
          if(source=="edit"){
            for(var i=0; i<changes.length; i++) {
              if( changes[i][1]=="slsprcvar") {
                var lv_row = changes[i][0];
                var lv_prcref = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0], "slsprcref");
                var lv_prcvar = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0], "slsprcvar");
                if(Number(lv_prcref)!=0){
                  var lv_prc = Math.round(((lv_prcref!=undefined?lv_prcref:0)*(1+(isNaN(lv_prcvar)?0:lv_prcvar/100)))*100)/100;
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( lv_row, "slsprc", lv_prc, "setting" );
                }
              }
              if (changes[i][1]=="slsprc"){
               var lv_row = changes[i][0];
                var lv_prcref = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0], "slsprcref");
                var lv_prc =  <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0], "slsprc");
                if(Number(lv_prcref)!=0){
                  var lv_prcvar = ((lv_prc-lv_prcref)/lv_prcref)*100;
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( lv_row, "slsprcvar", lv_prcvar, "setting" );
                }
              }
            }
          }
				}
			},
			beforeChange : function(changes, source) {
				var lv_value = changes[0][3];
				if (source=="edit" && changes[0][1]=="slsprcsrctxt") {
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].slsprcsrctxt == lv_value) {
              var lv_item = <?= $lv_sec; ?>_hotdocchg[i];
							changes.push([ changes[0][0], "slsprcsrctyp", "", String(lv_item.slsprcsrctyp) ]);
							changes.push([ changes[0][0], "slsprcsrccod", "", String(lv_item.slsprcsrccod) ]);
							changes.push([ changes[0][0], "slsprcqty", "", (lv_item.slsprcqty ? String(lv_item.slsprcqty) : "1") ]);
							changes.push([ changes[0][0], "slsprcuntcod", "", String(lv_item.slsprcuntcod) ]);
							if("<?=$vew_data->slsprcver->slsprclstancsrc;?>"=="2"){
								lv_pstdat=[	{"name":"slsprclstcod", "value":"<?=$vew_data->slsprcver->slsprclstancprccod;?>" },
                            {"name":"slsprcsrctyp", "value":String(lv_item.slsprcsrctyp) },
                            {"name":"slsprcsrccod", "value":String(lv_item.slsprcsrccod) },
                					];
			          tmssCallProcess("?prg=slsprclst&act=17", lv_pstdat, function(data){
                	if(data.length>0) {<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[0][0], "slsprcref", String(data[0].slsprc),"edit" );
                                     <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[0][0], "slsprcvar", String(<?= $vew_data->slsprcver->slsprclstancvar?? 0 ?>),"edit" );
                  }else{ 
                    			<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[0][0], "slsprcref", String(lv_item.matcst),"edit" );
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[0][0], "slsprcvar", String(<?= $vew_data->slsprcver->slsprclstancvar?? 0 ?>),"edit" );
                       }
                });
              }else{
              	changes.push([ changes[0][0], "slsprcref", "", String(lv_item.matcst) ]);
                changes.push([ changes[0][0], "slsprcvar", "", String(<?= $vew_data->slsprcver->slsprclstancvar?? 0 ?>)]);
              }

						}
					}
				}
			},
      cells: function(row, col, prop){
        var cellProperties = {}
        var lv_sca = typeof <?= $lv_sec; ?>_hotdoc != "undefined" && <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( row, "grldatprcsca" ) != null;
        if(lv_sca){
          var lv_scahot = JSON.parse( <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( row, "grldatprcsca" ) );
          //si no hay ninguna columna no eliminada cuenta que no hay escala
          lv_sca=(lv_scahot.length>0?(typeof lv_scahot[0]["deleted"] != "undefined"?false:lv_sca):false)
        }
        if ( ( prop == "slsprcuntcod") && lv_sca ) { cellProperties.readOnly = true; }
        return cellProperties;
      },
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["slsprclstprccod"]!="" && lv_dat[i]["slsprclstprccod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotdocerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotdocerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotdocerr.splice(lv_inx,1); }	
				}
			},
      afterSelectionEnd: function(){
        <?= $lv_sec; ?>_hotrowselected = [];
        var lv_selected = <?= $lv_sec; ?>_hotdoc.getSelected();
        for (var i = 0; i < lv_selected.length; i += 1) {
        	var lv_item = lv_selected[i];
        	<?= $lv_sec; ?>_hotrowselected.push(<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_item[0], 'slsprcsrccod'));
        }
      }
		};
		var <?= $lv_sec; ?>_hotdoc;	
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			<?= $lv_sec; ?>_filterPrices(gv_<?= $lv_sec; ?>_flt);
		});
    
    
    function <?= $lv_sec; ?>_priceScale( lv_row ) {
      var lv_rowdat = <?= $lv_sec; ?>_hotdoc.getSourceDataAtRow(lv_row);
      
      var lv_valid = lv_rowdat.slsprcqty && lv_rowdat.slsprcuntcod && lv_rowdat.slsprc;
      if( !lv_valid ){ return false; }
      
    	lv_rowdat['readonly'] = <?= ($vew_readonly ? 'true' : 'false') ?>;
      lv_rowdat['key1'] = (lv_rowdat['slsprclstcod']==undefined ? '' : lv_rowdat['slsprclstcod']);
      lv_rowdat['key2'] = lv_rowdat['slsprclstvercod'];
      lv_rowdat['key3'] = lv_rowdat['slsprclstprccod'];
      lv_rowdat['prccndqty'] = lv_rowdat['slsprcqty'];
      lv_rowdat['prccnduntcod'] = lv_rowdat['slsprcuntcod'];
      lv_rowdat['prccndval'] = lv_rowdat['slsprc'];
      lv_rowdat['curcod'] = $("#<?= $lv_sec; ?> #curcod").val();
      tmssCallProcess("?prg=grlprccndrec&act=prcsca", lv_rowdat, function(data){
        BootstrapDialog.show({
          title: "Escala de precios",
          message: $(data),
          draggable: true,
          closable: <?= ($vew_readonly ? 'true' : 'false') ?>,
          size: BootstrapDialog.SIZE_WIDE,
          buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialogItself){ dialogItself.close(); } }
                    <?php if(!$vew_readonly){ ?>  
                      ,
												{	id:"btn-accept", label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success",	action: function(dialog){
                        let lv_ret = eval( dialog.$modalBody.find("section").attr("id") + "_getData()" );
												//si hay errores se le avisa al usuario que los corrija
                    		if( lv_ret.err ){ toastr.warning("Corrija los errores en la tabla"); return false; }
                        var lv_dat = lv_ret.data;
                        var lv_del = lv_ret.del;                      
                        var lv_finaldata = [];
                        for (var i=0; i<lv_dat.length; i++){ lv_finaldata.push(lv_dat[i]); }
                        for (var i=0; i<lv_del.length; i++){
                          lv_del[i]['deleted'] = 'X';
                          lv_finaldata.push(lv_del[i]);
                        }
                          
                        <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row, "grldatprcsca", JSON.stringify(lv_finaldata));
                        dialog.close();
                      }
                    } 
                  <?php } ?>
                      ],
        	onshown: function(dialog){
        		let secID = dialog.$modalBody.find("section").attr("id"); 
        		eval( "if( typeof " + secID + "_hotdoc  != 'undefined' ){ " + secID + "_hotdoc.render();" + secID + "_hotdoc.render(); }" )
      		},
        });
      });
    }
	</script>
	<script>
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			
			if (lp_prm["action"]=="98") {
				tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				return false;
			
			} else if (lp_prm["action"]=="00") {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
				
				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["slsprcsrccod"]!="" && lo_dat[i]["slsprcsrccod"]!=undefined && lo_dat[i]["save"]){
						lv_arr.push({	"slsprclstprccod":lo_dat[i]["slsprclstprccod"],
													"slsprcsrctyp":lo_dat[i]["slsprcsrctyp"],
													"slsprcsrccod":lo_dat[i]["slsprcsrccod"],
													"slsprcref":lo_dat[i]["slsprcref"],
													"slsprcvar":lo_dat[i]["slsprcvar"],
													"slsprc":lo_dat[i]["slsprc"],
													"slsprcqty":lo_dat[i]["slsprcqty"],
													"slsprcuntcod":lo_dat[i]["slsprcuntcod"],
                         	"grldatprcsca":lo_dat[i]["grldatprcsca"]
												});
					}
				}
        
				// agrego las filas eliminadas
				for (var i=0; i< <?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"slsprclstprccod":<?= $lv_sec; ?>_hotdocdel[i]["slsprclstprccod"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #slsprclst").text("");
          toastr.warning("No hay cambios para grabar.");
          return false;
				} else {
          $("#<?= $lv_sec; ?> #slsprclst").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
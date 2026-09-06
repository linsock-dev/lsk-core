<?php
	// url del formulario 
  $lv_lnk = '?prg=stkmatser&prm_matsercod='.$vew_data->matsercod;

	// campos requeridos 
	$vew_input->RequiredFields( array('matsercodext','mattxt','matcod','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->matsercod;

	// titulo 
	$lv_title = $vew_lang->serialnumber;

	// modulo y programa 
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'SER';

	//obtiene la cantidad de columnas en la tabla de atributos
	$x=0;
  while( $vew_doc->getTagValue($vew_data->stkmatseratr,'atr'.$x)!='' ) { $x++; }
	$lv_matserqty = ( $x > 6 ? 6 : $x );

	// libreria de estilos bootstrap 
	include_once('_library.frm');
	
  $vew_tbl['hisL'] = array('pos'=>'L', 'per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'19'), 'id'=>'btnhst', 'ttl'=>$vew_lang->history, 'icn'=>'fas fa-history', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn','acc'=>'');
  $vew_tbl['hisR'] = array('pos'=>'R', 'per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'19'), 'id'=>'btnhst', 'ttl'=>$vew_lang->history, 'icn'=>'fas fa-history', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn','acc'=>'');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden','')?>
    
    <div class="container-fluid">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->matsercod; ?><?= gethtml('matsercod','hidden',$vew_data->matsercod) ?></strong></h4></li>
			</ul>
		</div>
    <div class="container-fluid" role="tabpanel">
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
            <div class="col-md-6">
							
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $lv_title; ?>
										<span class="tmss-card-icon">
											<span><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
										</span>
									</div>
								</div>
								<div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->material,
																								'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->matsercod!=''?true:$vew_readonly)),
																																		array('input'=>gethtml('mattxt', 'typeahead', $vew_data->mattxt, ($vew_data->matsercod!=''?$lv_always_disabled:$lv_default)) )
																																	)));
                    echo gethtml('matcod', 'hidden', $vew_data->matcod);
                  
                  
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->serialnumber,	'input'=>gethtml('matsercodext', 'doccmt1x20', $vew_data->matsercodext, $lv_default) ));
                    
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->batch,
																								'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->mattxt!=''?true:$vew_readonly)),
																																		array('input'=>gethtml('matbchcodext', 'typeahead', $vew_data->matbchcodext, ($vew_data->mattxt!=''?$lv_always_disabled:$lv_default)) )
																																	)));
                  	echo gethtml('matbchcod', 'hidden', $vew_data->matbchcod);
                  
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,				'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
							
						</div>
            <div class="col-md-6">
						
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $vew_lang->location; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                  <?php 
                    $lv_dat = array(''=>'');
                    foreach($vew_data->sysobjtyp as $lv_row){ $lv_dat[$lv_row['objtypcod']]=$lv_row['objtyptxt']; }
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->type,	'input'=>gethtml('stkobjtyp', $lv_dat, $vew_data->stkobjtyp, $lv_always_disabled) ));
                    echo vew_boot($lv_col210,	array('label'=>$vew_lang->source,
                                                    'input'=>gethtml('stkobjtxt', 'doccmt1x50', $vew_data->stkobjtxt, $lv_always_disabled) ));
                  	echo gethtml('stkobjcod', 'hidden', $vew_data->stkobjcod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->contact,
                                                    'input'=>gethtml('stkcnttxt', 'doccmt1x50', $vew_data->stkcnttxt,$lv_always_disabled) ));
                  	echo gethtml('stkcntcod', 'hidden', $vew_data->stkcntcod);
                    echo vew_boot($lv_col2424, array('label1'=>$vew_lang->start,
                                                     'input1'=>gethtml('stkobjstrdte', 'docdte', $vew_data->stkobjstrdte, $lv_always_disabled),
                                                     'label2'=>$vew_lang->end,
                                                     'input2'=>gethtml('stkobjenddte', 'docdte', $vew_data->stkobjenddte, $lv_always_disabled) ));
                  ?>
                </div>
              </div>
						
						</div>
					</div>
          <div class="row">
            <div class="col-md-6">
              <div class="card tmss-hot-ttl">
                <div class="card-header"><div class="card-title"><?= $vew_lang->attributes; ?></div></div>
                <div class="card-body tmss-card-body-edit">
									<textarea class="hidden" id="stkmatseratr" name="stkmatseratr"></textarea>
									<div id="matseratrsht" name="matseratrsht"></div>
                </div>
              </div>
            </div>
            <div class="col-md-6">
							
              <div class="card tmss-hot-ttl">
              	<div class="card-header"><div class="card-title"><?= $vew_lang->warranty; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->supplier,
																								'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
																																		array('input'=>gethtml('suptxt', 'typeahead', $vew_data->suptxt, $lv_default) )
																																	) ) );
                  	echo gethtml('supcod', 'hidden', $vew_data->supcod);
              			echo vew_boot($lv_col2424, array('label1'=>$vew_lang->start,
                                                 'input1'=>gethtml('supwrtstrdte', 'docdte', $vew_data->supwrtstrdte, $lv_default),
                                               	 'label2'=>$vew_lang->end,
                                                 'input2'=>gethtml('supwrtenddte', 'docdte', $vew_data->supwrtenddte, $lv_default) ));
                  ?>
                </div>
              </div>
							
						</div>
          </div>
				</div>
			</div>
    </div> <!-- /container-fluid -->
  </form>
  <script>
		// HISTORIAL
		$("#<?= $lv_sec; ?> #btnhst").on("click",function(e){ e.preventDefault();
			tmssPopup("<?= $vew_lang->history; ?>","?prg=stkmovdocmat&act=08&prm_vewcod=VEW_STK_MAT_SER_HST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldflt=[dm.matsercod:<?= $vew_data->matsercod; ?>]");
		});
		
		// MATERIAL
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"matcod":"matcod", "mattxt":"mattxt"},"fldflt":{"m.matuseser":"1"}};
		tmssTypeahead($("#<?= $lv_sec; ?> #mattxt"), "stkmat", lo_get);
    
    // LOTE
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"matbchcod":"matbchcod", "matbchcodext":"matbchcodext"},"fldflt":{"b.matcod":$("#<?= $lv_sec; ?> #matcod")}};
		tmssTypeahead($("#<?= $lv_sec; ?> #matbchcodext"), "stkmatbch", lo_get);

		// PROVEEDOR
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"supcod":"supcod", "suptxt":"suptxt"}};
		tmssTypeahead($("#<?= $lv_sec; ?> #suptxt"), "buysup", lo_get);
    
    $("#<?= $lv_sec; ?> #mattxt").on("change", function() {
        // Vaciar el campo de lote
        $("#<?= $lv_sec; ?> #matbchcodext").val('');
        $("#<?= $lv_sec; ?> #matbchcod").val('');
    });
  </script>
  <script>
		var <?= $lv_sec; ?>_hotmatseratr_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
		};
		var <?= $lv_sec; ?>_hotmatseratrcnt = $("#<?= $lv_sec; ?> #matseratrsht")[0];
		var <?= $lv_sec; ?>_hotmatseratrset = {
			height: 35 + <?= (!$vew_readonly?6:$lv_matserqty); ?>*23,
			formulas: false,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			colHeaders: [ "Atributo","Valor" ],
			columns: [
				{ type: "text", data: "matseratrnme", renderer: <?= $lv_sec; ?>_hotmatseratr_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
				{ type: "text", data: "matseratrval", renderer: <?= $lv_sec; ?>_hotmatseratr_renderer <?= ($vew_readonly?', readOnly: true':''); ?> }
			],
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotmatseratr;

		// cargo datos en handsontable ATRIBUTOS
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotmatseratr = new Handsontable(<?= $lv_sec; ?>_hotmatseratrcnt, <?= $lv_sec; ?>_hotmatseratrset);
			var lv_dat = [<?php
				$lv_buffer='';
				$x=0;
				while( $vew_doc->getTagValue($vew_data->stkmatseratr,'atr'.$x)!='' ) {
					$lv_data = $vew_doc->getTagValue($vew_data->stkmatseratr, 'atr'.$x);
					$lv_atrnme = $vew_doc->getTagValue($lv_data,'matseratrnme');
					$lv_atrval = $vew_doc->getTagValue($lv_data,'matseratrval');
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'matseratrnme:"'.$lv_atrnme.'",'.
												'matseratrval:"'.$lv_atrval.'"}';
					$x++;
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotmatseratr.loadData( lv_dat );
			<?= $lv_sec; ?>_hotmatseratr.render();
		});
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      if(lp_prm["action"] == "00"){

        //Pasar a un text area el contenido del HandsOnTable de atributos
				var lo_dat = <?= $lv_sec; ?>_hotmatseratr.getSourceData();
				var lv_buf = "";
				x=0;
				for (var i=0; i<lo_dat.length; i++) {
					if(lo_dat[i]["matseratrnme"]!="" && lo_dat[i]["matseratrnme"]!=undefined){
						lv_buf += "<atr"+x+"><matseratrnme>"+lo_dat[i]["matseratrnme"]+"</matseratrnme><matseratrval>"+(lo_dat[i]["matseratrval"]!=undefined?lo_dat[i]["matseratrval"]:"")+"</matseratrval></atr"+x+">";
						x++;
					}
				}
				$("#<?= $lv_sec; ?> #stkmatseratr").text(lv_buf);
				
      }
		}
  </script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
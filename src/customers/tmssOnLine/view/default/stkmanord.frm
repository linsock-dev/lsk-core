<?php
	// url del formulario
  $lv_lnk = '?prg=stkmanord&stkmanordcod='.$vew_data->stkmanordcod;
	
	// campos requeridos
	$lv_reqfld = array('stkmanordtxt', 'docsts');

	if($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'rspobjtyp')!='') { array_push( $lv_reqfld, 'rspobjcod','rspobjtyp','rspcobjtxt'); }
	
	$vew_input->RequiredFields($lv_reqfld);

	// clave del documento
	$lv_dockey = $vew_data->stkmanordcod;

	// titulo
	$lv_title = $vew_lang->workorders;

	// modulo y programa
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'MCO';
	
	// valores x default
	if ( $vew_data->stkmanordcod=='' ) {
		$vew_data->stkmanorddte = date('d/m/Y');
		$vew_data->docsts = 'A';
	}
	
  // librería de estilos
  include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
     <?= gethtml('tmss_actcod', 'hidden', ''); ?> 
    
    <textarea class="hidden" id="stkmanordmat" name="stkmanordmat"></textarea>

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->stkmanordcod; ?><?= gethtml('stkmanordcod','hidden',$vew_data->stkmanordcod); ?></strong></h4></li>
      </ul>
			<div class="tab-content tmss-tab-content">

				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                 <div class="card-title"><?= $vew_lang->WORKORDERS; ?> 
									 <span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
										<?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
               		</div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 	'input'=>gethtml('stkmanordtxt', 'doccmt1x50', $vew_data->stkmanordtxt, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div> <!-- /card -->
						</div> <!-- /col -->
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">  
                    <?php if($vew_data->sysdoctrecod=='N'){ ?><span><span class="far fa-circle"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod=='P'){ ?><span class="text-warning"><span class="far fa-circle-half-stroke"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod=='C'){ ?><span class="text-success"><span class="fas fa-circle"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod==''){ echo '&nbsp;'; } ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                    <?php
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('stkmanorddte', 'docdte', $vew_data->stkmanorddte, $lv_default) ));
											  $lv_ttl='';
                        switch( strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'rspobjtyp')) ) {
                          case 'HHR_EMP': $lv_ttl = $vew_lang->employee; break;
                          case 'SYS_USR': $lv_ttl = $vew_lang->system; break;
                          case 'BUY_SUP': $lv_ttl = $vew_lang->supplier; break;
                          default: $lv_ttl = $vew_lang->responsible; break;
                        }
                        if( $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'rspobjtyp')!='' ) {
                          echo vew_boot($lv_col210,	array('label'=>$lv_ttl, 
                                                          'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                              array('input'=>gethtml('srcobjtxt', 'typeahead', $vew_data->srcobjtxt, $lv_default) ))
                                                           ));
                        } else {
                          echo vew_boot($lv_col210,	array('label'=>$lv_ttl, 'input'=>gethtml('srcobjtxt', 'typeahead', $vew_data->rspobjtxt, $lv_default) ));
                        }
                        echo gethtml('rspobjtyp', 'hidden', strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'rspobjtyp')) );
                        echo gethtml('rspobjcod', 'hidden', $vew_data->rspobjcod); 
                  	?>
                </div>
              </div> <!-- /card -->
						</div> <!-- /col -->
					</div> <!-- /row -->

          <div class="col-md-12">
            <div class="row">         
              <div class="card tmss-hot-ttl">
                <div class="card-header">
                  <div class="card-title">
                  <?= $vew_lang->task; ?>
                  <a href="#" id="btndocref" class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" title="<?= $vew_lang->reference; ?>"><i class="fas fa-plus"></i></a>
                 </div>
                </div>    
								<div id="buyordmathot" name="buyordmathot"></div>
              </div>      
            </div> <!-- /row -->
          </div> <!-- /col -->
				</div> <!-- fin tab001 -->
			</div> <!--tabcontent -->
		</div> <!-- container-fluid -->
  </form>
  
  	<script>
		
    // TYPEAHEADS
		<?php
		switch( strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'rspobjtyp')) ) {
			case 'HHR_EMP': ?>
     		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"rspobjcod":"hhrempcod", "srcobjtxt":"hhremptxt"}};
 				tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "hhremp", lo_get);
				<?php break;
			case 'SYS_USR': ?> 
     		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"rspobjcod":"usrcod", "srcobjtxt":"usrtxt"}};
 				tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "syssecusr", lo_get);
				<?php break;
			case 'BUY_SUP': ?>
     		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"rspobjcod":"supcod", "srcobjtxt":"suptxt"}};
 				tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "buysup", lo_get);
				<?php break;
			}
		?>
  	</script>
  
	<script>
		// AGREGAR REFERENCIA
		$("#<?= $lv_sec; ?> #btndocref").on("click",function(e){  e.preventDefault();    
      // envío referencias agregadas que aún no hayan sido grabadas para que las desestime
			var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
			var lv_refarr = new Array();
			for (var i=0; i<lv_dat.length; i++) {
				if ( (lv_dat[i]["stkmanordmatcod"]==undefined ? "":lv_dat[i]["stkmanordmatcod"])=="") { 
          lv_refarr.push({"stkmanreqmatcod":lv_dat[i]["stkmanreqmatcod"]});
				}
			} 
      var lv_pstdat = [	{name: "refarr", value: JSON.stringify(lv_refarr)} ];
			tmssCallProcess("?prg=stkmanreq&act=reqfnd", lv_pstdat, function(data){
			BootstrapDialog.show({
				size: BootstrapDialog.SIZE_WIDE,
				title: "Agregar Materiales",
				message: $(data),
				buttons: [{ label: "Cancelar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
									{	label: "Agregar", cssClass: "btn-success",	action: function(dialogItself){
										if ( dialogItself.getModalBody().find("input[name=rowchk]:checked").length==0 ) {
											toastr.warning("Debe indicar al menos una posci&oacute;n de referencia.");
											return false;
										}
										var lv_row = <?= $lv_sec; ?>_hotdoc.countRows()-1;
										var lv_data = <?= $lv_sec; ?>_hotdoc.getSourceData();
											if(lv_data.length != 0){
												if(lv_data[lv_data.length-1].mattxt == undefined){
													lv_data.splice( lv_data.length-1, 1);
												}else{
													lv_data.splice( lv_data.length, 1 );
												}
											}
											dialogItself.getModalBody().find("input[name=rowchk]:checked").each(function(e){ 
											var lv_matcod = $(this).data("matcod");
											var lv_dat = dialogItself.getModalBody().find("textarea[data-matcod="+lv_matcod+"]").val();
											var lo_dat = JSON.parse( lv_dat ); 
											lv_data.push({"srcobjtxt":lo_dat["srcobjtxt"],
																		"matcod":lo_dat["matcod"],
																		"mattxt":lo_dat["mattxt"],
																		"matsercod":lo_dat["matsercod"],
                                    "matsercodext":lo_dat["matsercodext"],
																		"stkmanordmatatr":lo_dat["stkmanreqmatatr"],
																		"stkmanreqcod":lo_dat["stkmanreqcod"],
																		"stkmanreqmatcod":lo_dat["stkmanreqmatcod"],
                                    "docreftyp":'STK_MCS',
                                    "docrefcod":lo_dat["stkmanreqcod"],
                                    "docrefposcod":lo_dat["stkmanreqmatcod"]
																	 });
										});
										<?= $lv_sec; ?>_hotdoc.loadData(lv_data);
										dialogItself.close();
									}
								}]
					});
				});
		});
	</script>
  <script>
		/**
		 *
		 *	M A T E R I A L E S
		 *
		 */
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
				var lv_ro_color = "#F1F1F1";
				var lv_color = "#FFFFFF";
				var lv_ro = <?=($vew_readonly?'true':'false'); ?>;  
        
        Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = (lv_ro_color);
				cellProperties.readOnly = (lv_ro ? true:false);
			}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #buyordmathot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: '0',
			colHeaders: [ "<?= $vew_lang->location; ?>", "<?= $vew_lang->material; ?>", "<?= $vew_lang->serialnumber; ?>", "Descripcion Averia", "<?= $vew_lang->treatment; ?>" ],
			columns: [
        {type: "text", data: "srcobjtxt", width: 10, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
				{type: "text", data: "mattxt", width: 10, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
        {type: "text", data: "matsercodext", width: 10, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
      	{type: "text", data: "stkmanordmatatr", width: 40, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },  
        {type: "text", data: "sysdoctretxt", width: 10, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
			],
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["docrefsrcqty"]!="" && lv_dat[i]["docrefsrcqty"]!=undefined) {
						toastr.warning("No se pueden borrar posiciones que estan referenciadas por otros documentos.");
						return false;
					} else if ( lv_dat[i]["stkmanordmatcod"]!="" && lv_dat[i]["stkmanordmatcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			},
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotdoc;
    
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
      var lv_dat = [<?php
				$lv_buffer='';
        if ( is_array($vew_data->stkmanordmat) ) {
				foreach($vew_data->stkmanordmat as $lv_row){
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
													'stkmanordmatcod:`'.$lv_row['stkmanordmatcod'].'`,'.
            							'matcod:`'.$lv_row['matcod'].'`,'.
													'mattxt:`'.$lv_row['mattxt'].'`,'.
													'matsercod:`'.$lv_row['matsercod'].'`,'.
            							'matsercodext:`'.$lv_row['matsercodext'].'`,'.
													'stkmanordmatatr:`'.$lv_row['stkmanordmatatr'].'`,'.
            							'srcobjtxt:`'.$lv_row['srcobjtxt'].'`,'.
													'stkmanreqcod:`'.$lv_row['stkmanreqcod'].'`,'.
													'stkmanreqmatcod:`'.$lv_row['stkmanreqmatcod'].'`,'.
                          'docreftyp:"'.($lv_row['docreftyp']??'').'",'.
                          'docrefcod:"'.($lv_row['docrefcod']??0).'",'.
                          'docrefposcod:"'.($lv_row['docrefposcod']??0).'",'.
													($lv_row['refposqty']!=''?'docrefsrcqty: '.abs($lv_row['refposqty']-1).',':'').
													($lv_row['refposqty']!=''?'docrefminqty: '.$lv_row['refposqty'].',':'').
            							'sysdoctretxt:`'.$lv_row['sysdoctretxt'].'`'.
												'}';
					}
        }
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
  </script>
  <script>
    function <?= $lv_sec; ?>_GridRefresh(){ <?= $lv_sec; ?>_fnc({action: '99'}); }
      
		// SUBMIT. prepara los datos antes de grabar
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      if ( lp_prm["action"]=="00" ) {
        // obtengo datos de handsontable
        var err = 0;
        var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
        
        if(lo_dat.length == 0){
          toastr.warning("Falta agregar alg&uacute;n material a reparar.");
          return false;
        }
        
        var lv_arr = new Array();
				
        for (var i=0; i<lo_dat.length; i++) {
             lv_arr.push({ "stkmanordmatcod":lo_dat[i]["stkmanordmatcod"],
                            "matcod":lo_dat[i]["matcod"],
                            "mattxt":lo_dat[i]["mattxt"],
                            "matsercod":lo_dat[i]["matsercod"],
                            "matsercodext":lo_dat["matsercodext"],
                            "stkmanordmatatr":lo_dat[i]["stkmanordmatatr"],
                            "stkmanreqcod":lo_dat[i]["stkmanreqcod"],
                            "stkmanreqmatcod":lo_dat[i]["stkmanreqmatcod"],
                            "docreftyp":lo_dat[i]["docreftyp"],
                            "docrefcod":lo_dat[i]["docrefcod"],
                            "docrefposcod":lo_dat[i]["docrefposcod"]
                        });
        }

        // agrego las filas eliminadas
        for (var i=0; i < <?= $lv_sec; ?>_hotdocdel.length; i++) {
          lv_arr.push({	"stkmanordmatcod":<?= $lv_sec; ?>_hotdocdel[i]["stkmanordmatcod"],
                        "deleted":"X"
                      });
        }

        if (lv_arr.length==0) {
          $("#<?= $lv_sec; ?> #stkmanordmat").prop("value", "");
        } else {
          $("#<?= $lv_sec; ?> #stkmanordmat").prop("value", JSON.stringify( lv_arr ) );
        }
      }
    }
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
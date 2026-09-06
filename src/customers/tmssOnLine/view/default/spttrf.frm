<?php	
	// url del formulario 
  $lv_lnk = '?prg=spttrf&prm_spttrfcod='.$vew_data->spttrfcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('spttrftxt','docsts', 'spttrfverstrdte', 'spttrfverenddte', 'spttrftyptxt') );

	// clave del documento 
	$lv_dockey = $vew_data->spttrfcod;

	// titulo 
	$lv_title = $vew_lang->tariffs;
	
	// módulo y programa 
	$lv_mdlcod = 'SPT';
	$lv_prgcod = 'TRF';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<!-- Navbar -->
	<?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
		    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapa -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->spttrfcod; ?><?= gethtml('spttrfcod','hidden',$vew_data->spttrfcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="container-fluid">
						<div class="row">
							<div class="col-md-6">
								<div class='card'> <!-- Card1 -->
                	<div class="card-header">
                		<div class="card-title"><?= $lv_title; ?></div>
                  </div>
                  <div class="card-body tmss-card-body-edit">
                    <?php 
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('spttrfcodext', 'doccodext', $vew_data->spttrfcodext, $lv_default) ));
                    	echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('spttrftxt', 'doccmt1x50', $vew_data->spttrftxt, $lv_default) ));
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 
                                                      'input'=>vew_boot(	
                                                        array('style'=>'search', 'readonly'=> $vew_readonly),
                                                        array('input'=>gethtml('spttrftyptxt', 'doccmt1x50', $vew_data->spttrftyptxt, $lv_default)))));
                      echo gethtml('spttrftypcod', 'hidden', $vew_data->spttrftypcod);
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 					'docsts', 		$vew_data->docsts, 					$lv_default) ));	
                    ?>
                  </div>
                </div> <!-- Cierre de la Card1 -->
							</div>

              <!--Nueva card-->
              <div class="col-md-6">
								<!--Nav bar versiones-->
                <div class="card tmss-hot-ttl">
                	<div class="card-header">
                    <div class="card-title">
                      <?= $vew_lang->Version ?>
                      <?php if ($vew_data->spttrfvercod != '') { ?><small class="tmss-desk-btn">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<?= '(#'.$vew_data->spttrfvercod.' - '.( is_string($vew_data->spttrfverstrdte) ? $vew_data->spttrfverstrdte : $vew_data->spttrfverstrdte->format('d/m/Y') ).' - '.( is_string($vew_data->spttrfverenddte) ? $vew_data->spttrfverenddte : $vew_data->spttrfverenddte->format('d/m/Y') ).')'; ?></small><?php } ?>
                   		<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'03')) { ?><a id="btnver" class="card-icon tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->versions; ?>"><i class="far fa-clone" ></i></a><?php } ?>
                      <?= gethtml('spttrfvercod','hidden',$vew_data->spttrfvercod); ?>
                      <br>
                      <?php if ($vew_data->spttrfvercod != '') { ?>
                        <small class="tmss-mob-btn pull-left fs-11"><?='(#'.$vew_data->spttrfvercod.' - '.( is_string($vew_data->spttrfverstrdte) ? $vew_data->spttrfverstrdte : $vew_data->spttrfverstrdte->format('d/m/Y') ).' - '.( is_string($vew_data->spttrfverenddte) ? $vew_data->spttrfverenddte : $vew_data->spttrfverenddte->format('d/m/Y') ).')'; ?></small>
                        <?= gethtml('spttrfverstrdte','hidden', is_string($vew_data->spttrfverstrdte) ? $vew_data->spttrfverstrdte : $vew_data->spttrfverstrdte->format('d/m/Y') ); ?>
                      	<?= gethtml('spttrfverenddte','hidden', is_string($vew_data->spttrfverenddte) ? $vew_data->spttrfverenddte : $vew_data->spttrfverenddte->format('d/m/Y') ); ?>
                      <?php } ?>
                    </div><!-- Cierre card-title -->  
                  </div><!-- Cierre card-header -->  
                  <?php if($vew_data->spttrfvercod == '') { ?>
                  <div class="card-body tmss-card-body-edit">
                    <?php
                      echo vew_boot($lv_col2424, array('label'=>$vew_lang->from,
                                                                            'input1'=>gethtml('spttrfverstrdte', 'docdte', $vew_data->spttrfverstrdte, $lv_default),
                                                                            'label2'=>$vew_lang->to,
                                                                            'input2'=>gethtml('spttrfverenddte', 'docdte', $vew_data->spttrfverenddte, $lv_default) ));
                    ?>
                  </div>
                	<?php } ?>
                </div><!-- Cierre card-tmss -->
                <textarea id="spttrflst" name="spttrflst" class="hidden"></textarea>
                <div id="spttrflsthot" name="spttrflsthot"></div>
                <div id="datqty"></div>	
              </div><!-- Cierre md6 -->
							
						</div> <!-- /row -->
					</div> <!-- /container-fluid -->
				</div> <!-- /tab001 -->

			</div> <!-- /tabcontent -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
    $("#<?= $lv_sec; ?> #spttrftyptxt").next("span").children("a:first").on("click", function(e) { e.preventDefault();
      tmssPopup("<?= $vew_lang->tariffstypes; ?>","?prg=spttrftyp&prm_vewcod=VEW_SPT_TRF_TYP&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[spttrftyptxt:spttrftyptxt],[spttrftypcod:spttrftypcod]");
    });
	
    //CONTROL DE VERSIONES
    $("#<?= $lv_sec; ?> #btnver").on("click", function(e) { e.preventDefault();
			var lv_pstdat = [ {name:"spttrfvercod",value:$("#<?= $lv_sec; ?> #spttrfvercod").prop("value")}	];
			tmssCallProcess("?prg=spttrfver&act=13", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?=$vew_lang->version?>",
					message: $(data),
					type: BootstrapDialog.TYPE_PRIMARY,
					size: BootstrapDialog.SIZE_WIDE,
					buttons: [ { label: 'Cerrar', action: function(e){ e.close();} } ],
					onhide: function(dialog){

						var lv_vercod = dialog.getModalBody().find("#spttrfvercod").val();

						if(lv_vercod != $("#<?= $lv_sec; ?> #spttrfvercod").val()){

							var lv_strdte = dialog.getModalBody().find("#spttrfverstrdte").val();
							var lv_enddte = dialog.getModalBody().find("#spttrfverenddte").val();

							$("#<?= $lv_sec; ?> #spttrfvercod").val(lv_vercod);
							$("#<?= $lv_sec; ?> #trfvercod strong").html("# "+lv_vercod);
							$("#<?= $lv_sec; ?> #spttrfverstrdte").val(lv_strdte);
							$("#<?= $lv_sec; ?> #spttrfverenddte").val(lv_enddte);

							<?= $lv_sec?>_updatePrices();
						}
					}
				});
			});		
    });
	</script>
	<script>
		//REFRESH DE VERSION Y SU LISTA DE PRECIOS
		function <?= $lv_sec ?>_updatePrices(){ 

			var lv_pstdat = [ {name:"spttrfvercod",value:$("#<?= $lv_sec; ?> #spttrfvercod").prop("value")},
												{name:"spttrfcod",value:$("#<?= $lv_sec; ?> #spttrfcod").prop("value")}	];

			tmssCallProcess("?prg=spttrf&act=20", lv_pstdat, function(data){
					var lv_dat = [];
						
							for (var stu in data) {
								lv_dat.push({
														spttrflstcod: data[stu].spttrflstcod, 
														spttrfminval: data[stu].spttrfminval, 
														spttrfmaxval: data[stu].spttrfmaxval, 
														spttrfprc: data[stu].spttrfprc });
							}
						
					<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
					<?= $lv_sec; ?>_hotdoc.render();
			});	
		};
	</script>
	<script>
		//HANDSON TABLE
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if( <?= $lv_sec; ?>_hotdoc != undefined ) {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);			
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		}
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #spttrflsthot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 196,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"], ') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->from; ?>", "<?= $vew_lang->to; ?>", "<?= $vew_lang->amount; ?>" ],
			columns:[	{type: "numeric", data: "spttrfminval", width: "30%", numericFormat:{ pattern: "0", culture: "es-AR" }, 		allowEmpty: false, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
								{type: "numeric", data: "spttrfmaxval", width: "30%", numericFormat:{ pattern: "0", culture: "es-AR" }, 		allowEmpty: false, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
								{type: "numeric", data: "spttrfprc",		width: "40%", numericFormat:{ pattern: "0.00", culture: "es-AR" }, 	allowEmpty: false, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> }
							],
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for(var i=index; i<=index+amount-1; i++){
					if (lv_dat[i]["spttrflstcod"]!="" && lv_dat[i]["spttrflstcod"]!=undefined) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			}
    
		};
		var <?= $lv_sec; ?>_hotdoc;

		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [<?php
				$lv_buffer = '';
				if(is_array($vew_data->spttrflst)){
					foreach( $vew_data->spttrflst as $lv_row) {
						$lv_buffer .= ($lv_buffer==''?'':', ').'{'
												.'spttrflstcod: "'.$lv_row['spttrflstcod'].'", '
												.'spttrfminval: "'.$lv_row['spttrfminval'].'", '
												.'spttrfmaxval: "'.$lv_row['spttrfmaxval'].'", '
												.'spttrfprc: "'.$lv_row['spttrfprc'].'"} ';
					}
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
  <script>
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {

			if ( lp_prm["action"]=="00" ) {
				// obtengo datos de handsontable 
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length -1 ; i++) {
					
					if( !(lo_dat[i].spttrfminval == "" || lo_dat[i].spttrfminval == undefined) && 
					    !(lo_dat[i].spttrfmaxval == "" || lo_dat[i].spttrfmaxval == undefined) &&
							!(lo_dat[i].spttrfprc == "" || lo_dat[i].spttrfprc == undefined) ){         
            if ( 
              	(!isNaN(lo_dat[i].spttrfminval) && lo_dat[i].spttrfminval >= 0) && 
                (!isNaN(lo_dat[i].spttrfmaxval) && lo_dat[i].spttrfmaxval > lo_dat[i].spttrfminval) && 
                (!isNaN(lo_dat[i].spttrfprc) && lo_dat[i].spttrfprc > 0)
              ) {
                lv_arr.push({
                    "spttrflstcod":(lo_dat[i]["spttrflstcod"]),
                    "spttrfminval":(lo_dat[i]["spttrfminval"]),
                    "spttrfmaxval":(lo_dat[i]["spttrfmaxval"]),
                    "spttrfprc":(lo_dat[i]["spttrfprc"])
                  });
              } else {
                // Al menos una de las variables no es un número válido o no es mayor que 0.
                toastr.warning("Existen campos inválidos en la tabla");
                for (var j = 0; j < 3; j++) {
                  <?= $lv_sec; ?>_hotdoc.getCell(i, j).style.background = "#FF4C42";
                }
                return false;
              }

					} else 

							if( (lo_dat[i].spttrfminval == "" || lo_dat[i].spttrfminval == undefined) && 
					        (lo_dat[i].spttrfmaxval == "" || lo_dat[i].spttrfmaxval == undefined) &&
							    (lo_dat[i].spttrfprc == "" || lo_dat[i].spttrfprc == undefined) ){

								return false;

							} else {
								toastr.warning("Existen campos incompletos en la tabla");
                for(var j = 0; j < 3; j++){
                  <?= $lv_sec; ?>_hotdoc.getCell(i,j).style.background = "#FF4C42";
                }
								return false;
							}

				}

				// agrego las filas eliminadas
				for (var i=0; i< <?php echo $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"spttrfcod": $("#<?= $lv_sec; ?> #spttrfcod").prop("value"),
												"spttrflstcod":<?php echo $lv_sec; ?>_hotdocdel[i]["spttrflstcod"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #spttrflst").text("");
				} else {
					$("#<?= $lv_sec; ?> #spttrflst").text( JSON.stringify( lv_arr ) );
				}

			}
		}
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
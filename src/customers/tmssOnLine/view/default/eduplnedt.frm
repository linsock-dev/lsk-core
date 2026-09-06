<?php
	// url del formulario
	$lv_lnk = '?prg=edupln&prm_eduplncod='.$vew_data->eduplncod;

	// campos requeridos
	$vew_input->RequiredFields( array('eduplndtestr','eduplndteend','eduplndte','educurcod','educurtxt','educarcod','educartxt','educoucod','educoutxt','edusubcod','edusubtxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->eduplncod;

	// titulo
	$lv_title = $vew_lang->planning;
	
	// módulo y programa
	$lv_mdlcod = 'EDU';
	$lv_prgcod = 'PLN';
	
	// librería de estilos bootstrap
	include_once('_library.frm');

	$vew_tbl['clsR']['acc'] = "tmssTabSecCls( $('#".$lv_sec."') );";

	$lv_tchntf = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'tchnotification');
	$lv_stuntf = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'stunotification');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
  	<?php
    	echo gethtml('tmss_actcod', 'hidden', '');
    	echo gethtml('docsts', 			'hidden', $vew_data->docsts==''?'A':$vew_data->docsts);
    	echo gethtml('ntftyp', 			'hidden', $vew_data->ntftyp);
    	echo gethtml('ntfurl', 			'hidden', $vew_data->ntfurl);
    	echo gethtml('eduplncod', 	'hidden', $vew_data->eduplncod);
    	echo gethtml('educurcod', 	'hidden', $vew_data->educurcod);
    	echo gethtml('educarcod', 	'hidden', $vew_data->educarcod);
    	echo gethtml('educoucod', 	'hidden', $vew_data->educoucod);
    	echo gethtml('edusubcod', 	'hidden', $vew_data->edusubcod);
    	echo gethtml('stdloccod', 	'hidden', $vew_data->stdloccod);
    	echo gethtml('tchcod', 			'hidden', $vew_data->tchcod);
    ?>
    <textarea id="eduplnins" name="eduplnins" class="hidden"> </textarea>
    <div class="container-fluid" role="tabpanel">
    	<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->eduplncod.'/'.$vew_data->eduplndtecod; ?><?= gethtml('eduplncod','hidden',$vew_data->eduplncod); ?><?= gethtml('eduplndtecod','hidden',$vew_data->eduplndtecod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
							
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->planning;?>
                    <span class="tmss-card-icon">
                      <span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
                    </span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                	<?php        
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->date,			'input1'=>vew_boot(array('style'=>'search','readonly'=>$lv_default),   array('input'=>gethtml('eduplndte', 'docdte', $vew_data->eduplndte, $lv_default)) )));
                  	echo vew_boot($lv_col255, array('label'=>$vew_lang->period, 	'input1'=>gethtml('eduplndtestr',	'docdte',	$vew_data->eduplndtestr,	$lv_default), 
                    	                                														'input2'=>gethtml('eduplndteend', 'docdte',	$vew_data->eduplndteend,	$lv_default) ));
                  
          	        echo vew_boot($lv_col210, array('label'=>$vew_lang->curriculum, 		
                   	  										                            'input1'=>vew_boot( array('style'=>'search','readonly'=>  $vew_data->educurtxt ? $lv_always_disabled : false), 																				
                    	                                                 array('input'=>gethtml('educurtxt', 'typeahead', $vew_data->educurtxt, $vew_data->educurtxt ? $lv_always_disabled : $lv_default) )) ));
                  
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->career, 		
																																			'input1'=>vew_boot( array('style'=>'search','readonly'=>$vew_data->educartxt ? $lv_always_disabled : false), 																				
                                        	                            array('input'=>gethtml('educartxt', 'typeahead', $vew_data->educartxt, $vew_data->educartxt ? $lv_always_disabled : $lv_default) )) ));
                  
                		echo vew_boot($lv_col210, array('label'=>$vew_lang->course, 		
                                                 											'input1'=>vew_boot( array('style'=>'search','readonly'=>$vew_data->educoutxt ? $lv_always_disabled : false), 																				
                                                                     	 array('input'=>gethtml('educoutxt', 'typeahead', $vew_data->educoutxt,$vew_data->educoutxt ? $lv_always_disabled : $lv_default) )) ));		
                  
                		echo vew_boot($lv_col210, array('label'=>$vew_lang->subject, 		
                         											                        'input1'=>vew_boot( array('style'=>'search','readonly'=>$vew_data->edusubtxt ? $lv_always_disabled : false), 																				
                                              	                       array('input'=>gethtml('edusubtxt', 'typeahead', $vew_data->edusubtxt, $vew_data->edusubtxt ? $lv_always_disabled : $lv_default) )) ));		
                  
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->place, 		'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
																																																			array('input'=>gethtml('stdloctxt', 'typeahead', $vew_data->stdloctxt, $lv_default)) )));
                  
										echo vew_boot($lv_col210, array('label'=>$vew_lang->teacher,	'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
																																																			array('input'=>gethtml('tchtxt', 'typeahead', $vew_data->tchtxt, $lv_default)) )));
                  ?>
                  <div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label"><?= 'Horario'; ?></label>
										<div class="col-sm-3"><?= gethtml('eduplninbdte', 'doctme', $vew_data->eduplninbdte, $lv_default); ?></div>
										<div class="col-sm-3"><?= gethtml('eduplnoutdte', 'doctme', $vew_data->eduplnoutdte, $lv_default); ?></div>
										<div class="col-sm-4"><?= gethtml('eduplntme', 'doccmt1x20', '', $lv_always_disabled); ?></div>
									</div>
                </div>
              </div> <!-- /card -->
							
						</div>
						<div class="col-md-6">
						
              <div class="card tmss-hot-ttl">
                <div class="card-header"><div class="card-title"><?= $vew_lang->enrolled ?></div></div>
              </div>
							<div id="eduplninshot"></div>
							
						</div>
					</div> <!-- /row -->
				</div> <!-- /tab-pane -->
			</div> <!-- /tab-content -->    
		</div> <!-- /container-fluid -->    
  </form>

	<script>
    //PLAN DE ESTUDIOS
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"c.docsts":"A"}, "fldasg":{"educurcod":"educurcod", "educurtxt":"educurtxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #educurtxt"), 'educurcur', lo_get);

    //CARRERA -> filtro plan de estudio
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"a.docsts":"A", "c.educurcod": $("#<?= $lv_sec; ?> #educurcod")}, "fldasg":{"educartxt":"educartxt", "educarcod":"educarcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #educartxt"), 'educurcar', lo_get);
    
    //CURSOS -> filtro plan de estudio, carrera
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt":{"c.docsts":"A", "c.educurcod": $("#<?= $lv_sec; ?> #educurcod"),"a.educarcod": $("#<?= $lv_sec; ?> #educarcod")}, "fldasg" : {"educoutxt":"educoutxt", "educoucod" : "educoucod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #educoutxt"), "educurcou", lo_get);
    
    //MATERIA -> filtro plan de estudio, carrera, cursos
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"c.docsts":"A", "c.educurcod": $("#<?= $lv_sec; ?> #educurcod"),"a.educarcod": $("#<?= $lv_sec; ?> #educarcod"),"o.educoucod": $("#<?= $lv_sec; ?> #educoucod")}, "fldasg" : {"edusubtxt":"edusubtxt", "edusubcod" : "edusubcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #edusubtxt"), "educursub", lo_get);
 		
    //PROFESOR
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"t.docsts":"A"}, "fldasg":{"tchcod":"tchcod", "tchtxt":"tchtxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #tchtxt"), 'edutch', lo_get);

    //LUGAR DE ESTUDIO
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"s.docsts":"A"}, "fldasg":{"stdloccod":"stdloccod", "stdloctxt":"stdloctxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #stdloctxt"), 'edustdloc', lo_get);
		
    
    ////////////////////////////////////////////////////////
  	/*							I N S C R I P T O S										*/
    ////////////////////////////////////////////////////////
    
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #eduplninshot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 320,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->student; ?>" ],
			columns: [
				{type: "autocomplete", data: "stutxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "?prg=edustu&act=18", dataType: "json", data: { prm_stutxt: query },
              success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.stutxt);
                process(items);
              },
              error: function () { process([]); <?= $lv_sec; ?>_autocompleteCache = []; }
						});
					},
					strict: true
				}
			],
      afterChange: function(changes, source) {
        if (changes && changes.length > 0) {
          const row = changes[0][0];
          const valueSelected = changes[0][3] || "";
          if( changes[0][1]=="stutxt"){
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "stucod", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.stutxt === valueSelected);
              if (selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "stucod", selectedItem.stucod);
              else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          }
        }
      },
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["eduplninscod"]!="" && lv_dat[i]["eduplninscod"]!=undefined ) {
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
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotdoc;

		// cargo datos en handsontable
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
				$lv_buffer='';
				if ( is_array($vew_data->eduplnins) ) {
					foreach($vew_data->eduplnins as $lv_row){ 
						$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
													(isset($lv_row['eduplninscod'])?'eduplninscod:"'.$lv_row['eduplninscod'].'",':'').
													'eduplnprecod:"'.$lv_row['eduplnprecod'].'",'.
													'stucod:"'.$lv_row['stucod'].'",'.
													'stutxt:"'.$lv_row['stutxt'].'"}'; 
					}
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
		$(function(e){
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab003']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
		});
    
	</script>
	<script>
		// CALCULO DIF HORAS
		function calc_time(){
			var lv_tme="";
			if ($("#<?= $lv_sec; ?> #eduplninbdte").prop("value")!="" && $("#<?= $lv_sec; ?> #eduplnoutdte").prop("value")!="") {
				var lv_str = $("#<?= $lv_sec; ?> #eduplninbdte").prop("value");
				var lv_minstr = parseInt(lv_str.substr(0,2))*60 + parseInt(lv_str.substr(3,2))
				var lv_end = $("#<?= $lv_sec; ?> #eduplnoutdte").prop("value");
				var lv_minend = parseInt(lv_end.substr(0,2))*60 + parseInt(lv_end.substr(3,2))
				var lv_mindif = ( lv_minstr<lv_minend ? lv_minend-lv_minstr : 1440-(lv_minstr-lv_minend) );
				lv_tme = (Math.floor(lv_mindif/60)<10?"0":"") + String(Math.floor(lv_mindif/60)) + ":" + (lv_mindif-(Math.floor(lv_mindif/60)*60)<10?"0":"") + String(lv_mindif-(Math.floor(lv_mindif/60)*60));
			}
			$("#<?= $lv_sec; ?> #eduplntme").prop("value",lv_tme);
		}
		$("#<?= $lv_sec; ?> #eduplninbdte").on("blur",function(e){calc_time();});
		$("#<?= $lv_sec; ?> #eduplnoutdte").on("blur",function(e){calc_time();});
    
		// calcular diferencia de horario
		$(function() { calc_time(); });
	</script>
	<script>
		<?php if ( $lv_tchntf!='' ) { ?>
		// NOTIFICAR A PROFESOR
		$("#<?= $lv_sec; ?> #btnsndtch").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm({
				title: "Notificar planificaci&oacute;n", 
				message:"Desea enviar la notificaci&oacute;n de la planificaci&oacute;n al Profesor ?",
				type: BootstrapDialog.TYPE_PRIMARY,
				callback: function(result){
					if(result){
						$("#<?= $lv_sec; ?> #ntfurl").prop("value","<?= $lv_tchntf; ?>");
						$("#<?= $lv_sec; ?> #ntftyp").prop("value","TCH");
						$("#<?= $lv_sec; ?> #tchntfdte").prop("value", moment().format('DD/MM/YYYY') );
						<?= $lv_sec; ?>_fnc({action: "27"});
					}
				}
			});
		});
		<?php } ?>
		
		<?php if ( $lv_stuntf!='' ) { ?>
		// NOTIFICAR A ALUMNOS
		$("#<?= $lv_sec; ?> #btnsndstu").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm({
				title: "Notificar planificaci&oacute;n", 
				message:"Desea enviar la notificaci&oacute;n de la planificaci&oacute;n a los Alumnos ?", 
				type: BootstrapDialog.TYPE_PRIMARY,
				callback: function(result){
					if(result){
						$("#<?= $lv_sec; ?> #ntfurl").prop("value","<?= $lv_stuntf; ?>");
						$("#<?= $lv_sec; ?> #ntftyp").prop("value","STU");
						$("#<?= $lv_sec; ?> #stuntfdte").prop("value", moment().format('DD/MM/YYYY') );
						<?= $lv_sec; ?>_fnc({action: "27"});
					}
				}
			});
		});
		<?php } ?>
		
		// ACEPTAR PLANIFICACION
		$("#<?= $lv_sec; ?> #btnacp").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm({
				title: "Aceptar planificación", 
				message:"Desea aceptar la planificación ?", 
				type: BootstrapDialog.TYPE_PRIMARY,
				callback: function(result){
					if(result){
						$("#<?= $lv_sec; ?> #plncnfdte").prop("value", moment().format('DD/MM/YYYY') );
						<?= $lv_sec; ?>_fnc({action: "07"});
					} 
				}
			});
		});
		
		// RECHAZAR PLANIFICACION
		$("#<?= $lv_sec; ?> #btnrej").on("click",function(e){ e.preventDefault();
			BootstrapDialog.show({
				title: "Rechazar planificación", 
				message:"Por favor, indique un motivo o fecha probable de replanificación.<br><input class='form-control' id='rejtxt' name='rejtxt'>", 
				type: BootstrapDialog.TYPE_WARNING,
				buttons: [{ label: "Cancelar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
									{	label: "OK", cssClass: "btn-warning",	action: function(dialogItself){
											tmssCallProcess("index.php?prg=hltpln&act=09",{ plnid: $("#<?= $lv_sec; ?> #plnid").prop("value"), plndteid: $("#<?= $lv_sec; ?> #plndteid").prop("value"), rejtxt: dialogItself.getModalBody().find("#rejtxt").val() },
												function( msg ) {
													var lv_errcod = $("<div>"+msg+"</div>").find("errcod").text();
													var lv_errtxt = $("<div>"+msg+"</div>").find("errtxt").text();
													if (lv_errcod=="0") {
														toastr.success("Notificación enviada.");
														$("#<?= $lv_sec; ?> #btnacp").fadeOut();
														$("#<?= $lv_sec; ?> #btnrej").fadeOut();
													} else {
														toastr.warning("Se produjo un error al enviar notificación.<br>" + lv_errcod + ": " + lv_errtxt);
													}
												}
											)
											dialogItself.close();
									}
								}]
			});
		});

	</script>
  <script>
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
				
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
			
				// obtengo datos de HOT
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["stutxt"]!="" && lo_dat[i]["stutxt"]!=undefined ) {
						lv_arr.push({	"eduplninscod":lo_dat[i]["eduplninscod"],
													"eduplnprecod":lo_dat[i]["eduplnprecod"],
													"stucod":lo_dat[i]["stucod"],
													"stutxt":lo_dat[i]["stutxt"]
												});
					}
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"eduplninscod":<?= $lv_sec; ?>_hotdocdel[i]["eduplninscod"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #eduplnins").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #eduplnins").prop("value", JSON.stringify( lv_arr ) );
				}
				
			}
		}		
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>  
</section>
<?php
	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = '';
	
	// modulo y programa 
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'SU1';

	// libreria de estilos bootstrap 
	include_once('_library.frm');
	$lv_prccndcod =""; 
	$lv_sec = ( ($vew_oldSec??'')!='' ? $vew_oldSec : $lv_sec );
	$lv_steevtcod = $vew_data->evtdoc[0]['steevtcod']??'';
  $lv_slsprclstcod=$vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatrusr,'lista_precios');
	$lv_slsprcancvar=1;
	$lv_dattsk=[];
  $lv_datmat=[];
	foreach ($vew_data->cnssteevtdoc as $lv_doc) {
    $lv_row = json_decode(mb_convert_encoding($lv_doc['steevtdocatr']??'','UTF-8','iso-8859-1'),true);
    $lv_row['steevtdoccod']=$lv_doc['steevtdoccod'];
    if ($lv_doc['srcobjtyp'] == 'CNS_TSK_PRD') {
      	$lv_row['cnsprslqdcod']=$lv_doc['cnsprslqdcod']??'';
        $lv_dattsk[] = $lv_row;
    } elseif ($lv_doc['srcobjtyp'] == 'CNS_MAT_PRD') {
        $lv_datmat[] = $lv_row;
    }
}
?> 
<section id="<?= $lv_sec; ?>">     
  <?= gethtml('steevtcod', 'hidden', $lv_steevtcod); ?>
  <?= gethtml('slsprclstcod', 'hidden', $lv_slsprclstcod); ?>
  <?= gethtml('slsprcancvar', 'hidden', $lv_slsprcancvar); ?>
  
  <textarea class="hidden" id="steevtdocdat" name="steevtdocdat">"<?= (count($vew_data->evtdoc)>0 ? $vew_data->evtdoc[0]['steevtdocatr'] : '');?>"</textarea>
  <textarea class="hidden" id="steevtdocdatdel" name="steevtdocdatdel"></textarea>

	<!-- TAREAS -->
	<div class="card tmss-hot-ttl">
		<div class="card-header"><div class="card-title big-card-title">Tareas</div></div>
	</div>
	<div id="hottsk"></div>
  
	<!-- MATERIALES -->
	<div class="card tmss-hot-ttl">
		<div class="card-header"><div class="card-title big-card-title">Materiales</div></div>
	</div>
  <div id="hotmat"></div>
	
	
	<script>
    $(function(e){ tmssHandsontableResize(); });
		var <?= $lv_sec; ?>_hottsk_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			
        // Obtener el valor de la columna 'cnsprslqdcod' de la fila actual
    var lv_cnsprslqdcod = instance.getDataAtRowProp(row, 'cnsprslqdcod');

    	if ( prop=='tskprc' || prop=='tskprcbse' || prop=='tskcof' || prop=='tsktot' || prop=='cnsprslqdcod' ) {
        Handsontable.renderers.NumericRenderer.apply(this, arguments);
				td.style.backgroundColor = "#F1F1F1";
			}else if ( prop=='tskuntcod' ) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = "#F1F1F1";
			} else {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        // Si cnsprslqdcod no está vacío
    		if (lv_cnsprslqdcod != '' && lv_cnsprslqdcod != null && lv_cnsprslqdcod != undefined) {
        // Aplicar el color de fondo #F1F1F1 a toda la fila
        td.style.backgroundColor = "#F1F1F1";
    		} else{
          td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
        }
				
			}
		};
		var <?= $lv_sec; ?>_hottsk_paste = false;
    var <?= $lv_sec; ?>_hottsk_autocomplete = false;
		var <?= $lv_sec; ?>_hottsktmpchg = [];
		var <?= $lv_sec; ?>_hottsktmpdel = [];
		var <?= $lv_sec; ?>_hottskcnt = $("#<?= $lv_sec; ?> #hottsk")[0];
		var <?= $lv_sec; ?>_hottskset = {
			height: 246,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Cuadrilla","Tarea", "Descripcion", "Cant", "UM", "Baremo", "Coef","Unitario", "SubTotal", "Rec","Liq" ],
			columns: [
				{type: "autocomplete", data: "sqdtxt",width: 50, renderer: <?= $lv_sec; ?>_hottsk_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						if ( query.length>1 && <?= $lv_sec; ?>_hottsk_paste==false ) {
							$.ajax({
										url:"?prg=cnstsk&act=17", dataType:"json", data:{prm_cnstsktxt: query},
										complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="//script"){ eval(jqXHR.responseText); }},
										success: function (response) {
											var lv_dat = [];
											<?= $lv_sec; ?>_hottsktmpchg = [];
											for (var i=0; i < response.data.length; i++) {
												<?= $lv_sec; ?>_hottsktmpchg.push( {sqdtxt: response.data[i]["cnstsktxt"], sqdcod: response.data[i]["cnstskcod"] } );
												lv_dat.push( response.data[i]["cnstsktxt"] );
											}
											process( lv_dat );
										}
									});
						}
					},
					strict: true
				},
        {type: "text", data: "tskcodext", width: 20, renderer: <?= $lv_sec; ?>_hottsk_renderer,<?= ($vew_readonly?'readOnly: true ':''); ?> },
				{type: "autocomplete", data: "tsktxt",width: 100, renderer: <?= $lv_sec; ?>_hottsk_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						if ( query.length>1 && <?= $lv_sec; ?>_hottsk_paste==false ) {
							$.ajax({
										url:"?prg=cnstsk&act=17", dataType:"json", data:{prm_cnstsktxt: query},
										complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="//script"){ eval(jqXHR.responseText); }},
										success: function (response) {
											var lv_dat = [];
											<?= $lv_sec; ?>_hottsktmpchg = [];
											for (var i=0; i < response.data.length; i++) {
												<?= $lv_sec; ?>_hottsktmpchg.push( {tsktxt: response.data[i]["cnstsktxt"], slsprcsrctyp: "CNS_TSK", tskcod: response.data[i]["cnstskcod"],tskcodext: response.data[i]["cnstskcodext"] } );
												lv_dat.push( response.data[i]["cnstsktxt"] );
											}
											process( lv_dat );
										}
									});
						}
					},
					strict: true
				},
				{type: "numeric", data: "tskqty", width: 20, renderer: <?= $lv_sec; ?>_hottsk_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "tskuntcod", width: 20, renderer: <?= $lv_sec; ?>_hottsk_renderer, editor: false, readOnly: true },
				{type: "numeric", data: "tskprcbse", width: 30, renderer: <?= $lv_sec; ?>_hottsk_renderer, editor: false, readOnly: true, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "tskcof", width: 20, renderer: <?= $lv_sec; ?>_hottsk_renderer, editor: false, readOnly: true, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "tskprc", width: 30, renderer: <?= $lv_sec; ?>_hottsk_renderer, editor: false, readOnly: true, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
        {type: "numeric", data: "tsktot", width: 30, renderer: <?= $lv_sec; ?>_hottsk_renderer, editor: false, readOnly: true, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
        {type: "numeric", data: "tskrec", width: 20, renderer: <?= $lv_sec; ?>_hottsk_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
        {type: "text", data: "cnsprslqdcod", width: 20, renderer: <?= $lv_sec; ?>_hottsk_renderer,editor: false, readOnly: true }
				
			],
      afterDocumentKeyDown: function(e) {
        if (e.key === "Enter" || e.key === "Tab" ) {
          lv_cell = this.getSelected();
          if (lv_cell) {
            lv_row = lv_cell[0][0];
            lv_col = lv_cell[0][1];
						let lv_nxtrow, lv_nxtcol;
						if (lv_col === 0) {
							lv_nxtcol = 1; // mover a tarea
						} else if (lv_col === 1) {
							lv_nxtcol = 3; // mover a cantidad
						}else if (lv_col === 3) {
							lv_nxtcol = 9; //mover a recargo
						} else if(lv_col==9){
              lv_nxtcol = 0; //mover a cuadrilla
							lv_nxtrow = (lv_row + 1);
            }else {
							lv_nxtcol = lv_col + 1; // mover al siguiente
						}

						if (lv_nxtrow === undefined) {
							lv_nxtrow = lv_row;
						}
						if (lv_nxtrow >= this.countRows()) {
							this.alter('insert_row', this.countRows());
						}

						this.selectCell(lv_nxtrow, lv_nxtcol);
						e.preventDefault();
						e.stopImmediatePropagation();
					}
				}
			},
			beforeChange : function(changes, source) {
		    // si modifico el precio, actualizar el indicador de cambio manual
        if(source=="edit" && changes[0][1]=="tskprc") {
        	var lv_data = JSON.parse(<?= $lv_sec; ?>_hottsk.getDataAtRowProp(changes[0][0],"slsinvmatprc"));
          if(lv_data != undefined){
            for (var i=0; i < lv_data.length; i++){
              if (lv_data[i].prccndcod == "<?= $lv_prccndcod; ?>"){
                lv_data[i].prcchgman = "X";
                <?= $lv_sec; ?>_hottsk.setDataAtRowProp(changes[0][0],"slsinvmatprc", JSON.stringify(lv_data));
              }
            }
          }
        }
        if(changes[0][1]=="sqdtxt" && (source=="edit" || source=="Autofill.fill")) {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hottsktmpchg.length ; i++) {
						if(<?= $lv_sec; ?>_hottsktmpchg[i].sqdtxt == lv_value) {
              <?= $lv_sec; ?>_hottsk.setDataAtRowProp(changes[0][0],"sqdcod",String(<?= $lv_sec; ?>_hottsktmpchg[i].sqdcod), "setting"); 							
						}
					}
				}
				if(changes[0][1]=="tsktxt" && source=="edit") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hottsktmpchg.length ; i++) {
						if(<?= $lv_sec; ?>_hottsktmpchg[i].tsktxt == lv_value) {
              <?= $lv_sec; ?>_hottsk.setDataAtRowProp(changes[0][0],"tskcod",String(<?= $lv_sec; ?>_hottsktmpchg[i].tskcod), "setting");
              <?= $lv_sec; ?>_hottsk.setDataAtRowProp(changes[0][0],"tskcodext",String(<?= $lv_sec; ?>_hottsktmpchg[i].tskcodext), "setting");
							changes.push([ changes[0][0], "tskuntcod", "", String(<?= $lv_sec; ?>_hottsktmpchg[i].tskuntcod) ]);
              changes.push([ changes[0][0], "tskrec", "", 0.00]);
							// si existe lista de precio asignada y no hay precio indicado para el material, obtengo el precio
              var lv_prc = <?= $lv_sec; ?>_hottsk.getDataAtRowProp(changes[0][0],"matprc");
							if ( $("#<?= $lv_sec; ?> #slsprclstcod").prop("value")!="" && (changes[0][2] != lv_value || lv_prc==null || lv_prc=="")){
                
								var lv_pstdat =[{name:"slsprclstcod",value: $("#<?= $lv_sec; ?> #slsprclstcod").prop("value")}, 
																{name:"slsprclstdte",value: $("#<?= $lv_sec; ?> #steevtdte").prop("value")}, 
																{name:"slsprcsrctyp",value: "CNS_TSK"},
																{name:"slsprcsrccod",value: <?= $lv_sec; ?>_hottsktmpchg[i].tskcod},
																{name:"currow",value: changes[0][0]}
																]
								tmssCallProcessNoBackdrop("?prg=slsprclst&act=17", lv_pstdat, function(data){
									if(data.length>0){
										lv_prcvar=$("#<?= $lv_sec; ?> #slsprcancvar").prop("value"); 
                    lv_prcunt=isNaN(data[0]["slsprc"] / data[0]["slsprcqty"]) ? "0" : (data[0]["slsprc"] / data[0]["slsprcqty"]);
                    <?= $lv_sec; ?>_hottsk.setDataAtRowProp(changes[0][0],"tskprcbse", lv_prcunt, "setting");
                    <?= $lv_sec; ?>_hottsk.setDataAtRowProp(changes[0][0],"tskcof", lv_prcvar, "setting"); 
                    <?= $lv_sec; ?>_hottsk.setDataAtRowProp(changes[0][0],"tskprc", lv_prcunt *lv_prcvar, "setting"); 
                    <?= $lv_sec; ?>_hottsk.setDataAtRowProp(changes[0][0],"tskuntcod", data[0]["slsprcuntcod"], "setting"); 


                  }else{
                    toastr.warning( "LA TAREA EN LA FECHA SELECCIONADA NO TIENE PRECIO EN LA VERSION DE LA LISTA DE PRECIOS", "NO SE ENCONTRO PRECIO" );
                  }
								});
							}							
						}
					}
				}
			},
        afterChange: function(changes, source) {
				// agregar referencia
				// -- cuando se asigna el ultimo valor de la fila (flag de actualizacion)
				// -- realizo el calculo de precios
        if (source == "edit"){
          if (<?= $lv_sec; ?>_hottsk!=undefined) {
            if(changes && changes.length && source=="edit" && <?= $lv_sec; ?>_hottsk_paste!=true) {
              var lv_refresh_prices = [];
              for(var i=0; i<changes.length; i++) {
                if( changes[i][1]=="tskqty" || changes[i][1]=="tskrec" ) {
                  if(lv_refresh_prices.indexOf(changes[i][0])!==1){lv_refresh_prices.push(changes[i][0]);}
                  var lv_qty = <?= $lv_sec; ?>_hottsk.getDataAtRowProp(changes[i][0], "tskqty", "setting");
                  var lv_prc = <?= $lv_sec; ?>_hottsk.getDataAtRowProp(changes[i][0], "tskprc", "setting");
                  var lv_rec = <?= $lv_sec; ?>_hottsk.getDataAtRowProp(changes[i][0], "tskrec", "setting");
                  if(lv_qty != null && lv_prc != null){ <?= $lv_sec; ?>_hottsk.setDataAtRowProp( changes[i][0], "tsktot",lv_qty*lv_prc * (1+(lv_rec/100)), "setting" ); }
                }
              }
            }
          }
          if (changes && changes.length && <?= $lv_sec; ?>_hottsk_autocomplete!=true && (source=="edit" || source=="CopyPaste.paste") ) {
            for( var i=0; i<changes.length; i++) {
              if ( changes[i][1]=="tskcodext" ){
                var lv_value = changes[i][3];
                var lv_pstdat =[{name:"row",value:changes[i][0]}];
                tmssCallProcessNoBackdrop("?prg=cnstsk&act=17&prm_cnstskcodext="+lv_value, lv_pstdat, function(data){
                  if (data.post.row!=undefined) {
                    var lv_row = data.post.row;
                    <?= $lv_sec; ?>_hottsk.setDataAtRowProp(lv_row,"tskcod", data.data[0]["cnstskcod"], "setting" );
                    <?= $lv_sec; ?>_hottsk.setDataAtRowProp(lv_row,"tskcodext", data.data[0]["cnstskcodext"], "setting" );
                    <?= $lv_sec; ?>_hottsk.setDataAtRowProp(lv_row,"tsktxt", data.data[0]["cnstsktxt"], "edit" );
                  }
                });
              }
            }
          } else {
            <?= $lv_sec; ?>_hottsk_autocomplete = false;
          }
        }
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hottsk.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]['tskcod']!='' && lv_dat[i]['tskcod']!=undefined ) {
						<?= $lv_sec; ?>_hottsktmpdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hottsk;	

		// cargo datos en handsontable de Especialidades
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hottsk = new Handsontable(<?= $lv_sec; ?>_hottskcnt, <?= $lv_sec; ?>_hottskset);	
			var lv_dat = [<?php
				$lv_buffer='';
        if(count($lv_dattsk)){
        foreach($lv_dattsk as $lv_row){ 
					$lv_buffer .= ($lv_buffer!=''?',':'').
													'{steevtdoccod: "'.($lv_row['steevtdoccod']??'').'",'.
            							'sqdtxt: `'.utf8_decode($lv_row['sqdtxt']??'').'`,'.
													'sqdcod: "'.($lv_row['sqdcod']??'').'",'.
            							'tsktxt: `'.utf8_decode($lv_row['tsktxt']??'').'`,'.
													'tskcod: "'.($lv_row['tskcod']??'').'",'.
            							'tskcodext: "'.($lv_row['tskcodext']??'').'",'.
													'tskqty: "'.($lv_row['tskqty']??'').'",'.
													'tskuntcod: "'.($lv_row['tskuntcod']??'').'",'.
													'tskprcbse: "'.($lv_row['tskprcbse']??'').'",'.
													'tskprc: "'.($lv_row['tskprc']??'').'",'.
													'tskcof: "'.($lv_row['tskcof']??'').'",'.
													'tskrec: "'.($lv_row['tskrec']??'').'",'.
													'tsktot: "'.($lv_row['tsktot']??'').'",'.
            							'cnsprslqdcod: "'.($lv_row['cnsprslqdcod']??'').'",'.
													'}'; }
        }
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hottsk.loadData( lv_dat );
			<?= $lv_sec; ?>_hottsk.render();
		});
	</script>
	<script>
		var <?= $lv_sec; ?>_hotmat_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
		};
		var <?= $lv_sec; ?>_hotmat_paste = false;
		var <?= $lv_sec; ?>_hotmattmpchg = [];
		var <?= $lv_sec; ?>_hotmattmpdel = [];
		var <?= $lv_sec; ?>_hotmatcnt = $("#<?= $lv_sec; ?> #hotmat")[0];
		var <?= $lv_sec; ?>_hotmatset = {
			height: 246,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Material", "Descripcion", "Cantidad", "UM" ],
			columns: [
				{type: "text", data: "matcodext", width: 18, renderer: <?= $lv_sec; ?>_hotmat_renderer, <?= ($vew_readonly?'readOnly: true ':''); ?> },
				{type: "autocomplete", data: "mattxt", renderer: <?= $lv_sec; ?>_hotmat_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						if ( query.length>1 && <?= $lv_sec; ?>_hotmat_paste==false ) {
							$.ajax({
								url: "?prg=stkmat&act=17", dataType: "json", data: {	prm_mattxt: query },
								complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
								success: function (response) {
									var lv_dat = [];
									<?= $lv_sec; ?>_hotmattmpchg = [];
									for (var i=0; i < response.data.length; i++) {
										<?= $lv_sec; ?>_hotmattmpchg.push( {mattxt: response.data[i]["mattxt"], matcod: response.data[i]["matcod"],matcodext: response.data[i]["matcodext"], matuntcod: response.data[i]["matuntcod"]} );
										lv_dat.push( response.data[i]["mattxt"] );
									}
									process( lv_dat );
								}
							});
						}
					},
					strict: true
				},
				{type: "numeric", data: "matqty", width: 50, renderer: <?= $lv_sec; ?>_hotmat_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "matuntcod", width: 18, renderer: <?= $lv_sec; ?>_hotmat_renderer, editor: false, readOnly: true },
			],
			beforeChange : function(changes, source) {
				// asigno los datos adicionales a la fila
				if(source=="edit" && changes[0][1]=="mattxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotmattmpchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotmattmpchg[i].mattxt == lv_value) {
              	changes.push([ changes[0][0], "matcod", "", String(<?= $lv_sec; ?>_hotmattmpchg[i].matcod) ]);
                changes.push([ changes[0][0], "matcodext", "", String(<?= $lv_sec; ?>_hotmattmpchg[i].matcodext) ]);
								changes.push([ changes[0][0], "matuntcod", "", String(<?= $lv_sec; ?>_hotmattmpchg[i].matuntcod) ]);
								<?= $lv_sec; ?>_hot_autocomplete = true;
						}
					}
				}
			},
      afterChange: function(changes, source) {
        if (changes && changes.length && <?= $lv_sec; ?>_hot_autocomplete!=true && (source=="edit" || source=="CopyPaste.paste") ) {
        	for( var i=0; i<changes.length; i++) {
        		if ( changes[i][1]=="matcodext" ){
          		var lv_value = changes[i][3];
              var lv_pstdat =[{name:"row",value:changes[i][0]}];
              tmssCallProcessNoBackdrop("?prg=stkmat&act=17&prm_matcodext="+lv_value, lv_pstdat, function(data){
                if (data.post.row!=undefined) {
                  var lv_row = data.post.row;
                  <?= $lv_sec; ?>_hotmat.setDataAtRowProp(lv_row,"matcod", data.data[0]["matcod"], "setting" );
                  <?= $lv_sec; ?>_hotmat.setDataAtRowProp(lv_row,"matcodext", data.data[0]["matcodext"], "setting" );
                  <?= $lv_sec; ?>_hotmat.setDataAtRowProp(lv_row,"mattxt", data.data[0]["mattxt"], "edit" );
                  <?= $lv_sec; ?>_hotmat.setDataAtRowProp(lv_row,"matqty", (data.data[0]["matqty"]!=undefined?data.data["matqty"]:"1"), "edit.matcod" );
									<?= $lv_sec; ?>_hotmat.setDataAtRowProp(lv_row,"matuntcod", (data.data[0]["matuntcod"]!=undefined?data.data["matuntcod"]:""), "edit.matcod" );
        				}
              });
          	}
        	}
        } else {
					<?= $lv_sec; ?>_hot_autocomplete = false;
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotmat.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]['matcod']!='' && lv_dat[i]['matcod']!=undefined ) {
						<?= $lv_sec; ?>_hotmattmpdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotmat;	

		// cargo datos en handsontable de Especialidades
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotmat = new Handsontable(<?= $lv_sec; ?>_hotmatcnt, <?= $lv_sec; ?>_hotmatset);	
			var lv_dat = [<?php
				$lv_buffer='';
        if(count($lv_datmat)){
        foreach($lv_datmat as $lv_row){ $lv_buffer .= ($lv_buffer!=''?',':'').
                                                              '{steevtdoccod: "'.($lv_row['steevtdoccod']??'').'",'.
                                                              'matcod:"'.($lv_row['matcod']??'').
                                                              '", mattxt:`'.utf8_decode($lv_row['mattxt']??'').
                                                              '`, matcodext:"'.($lv_row['matcodext']??'').
                                                              '", matqty:"'.($lv_row['matqty']??'').
                                                              '", matuntcod:"'.($lv_row['matuntcod']??'').
                                                              '"}'; }
        }
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotmat.loadData( lv_dat );
			<?= $lv_sec; ?>_hotmat.render();
		});
	</script>
  <script>
    function <?= $lv_sec; ?>_sve( lp_sec ){ 
      //agrego las tareas a grabar 
      var lv_dattsk = <?= $lv_sec; ?>_hottsk.getSourceData();
      for (var i=0; i<lv_dattsk.length-1; i++) {
					if ( lv_dattsk[i]["tskqty"]=="" || lv_dattsk[i]["tskqty"]==undefined || !lv_dattsk[i]["sqdtxt"] || !lv_dattsk[i]["sqdcod"] || !lv_dattsk[i]["tskcod"] || !lv_dattsk[i]["tsktxt"]) {
          	toastr.warning("Complete los datos de Cuadrilla, Tarea, Descripci&oacute;n y Cantidad para todas las tareas.");
            return false;
          }
      }
      lv_dattsk = lv_dattsk.map(lp_row => ({
        	steevtdoccod: lp_row.steevtdoccod??"",
          srcobjtyp: 'CNS_TSK_PRD',
          srcobjcod: lp_row.tskcod,
					srcobjtxt: lp_row.tsktxt,
      	  steevtdocatr: JSON.stringify(lp_row)
      }));
    	//agrego los materiales a grabar
      lv_datmat = <?= $lv_sec; ?>_hotmat.getSourceData();
      lv_datmat = lv_datmat.map(lp_row => ({
        	steevtdoccod: lp_row.steevtdoccod??"",
          srcobjtyp: 'CNS_MAT_PRD',
          srcobjcod: lp_row.matcod,
					srcobjtxt: lp_row.mattxt,
      	  steevtdocatr: JSON.stringify(lp_row)
      }));
      
      // agrego las tareas y materiales a borrar 
      lv_dattskdel= <?= $lv_sec; ?>_hottsktmpdel.map(lp_row => (lp_row.steevtdoccod??""));
      lv_datmatdel= <?= $lv_sec; ?>_hotmattmpdel.map(lp_row => (lp_row.steevtdoccod??""));
      
    	//concateno listas 
      lv_evtdocdat = lv_dattsk.concat(lv_datmat);
      lv_evtdocdatdel = lv_dattskdel.concat(lv_datmatdel);

      //filtro las filas vacias
      lv_evtdocdat = lv_evtdocdat.filter(lp_row => lp_row.srcobjcod && lp_row.srcobjcod!='')
      
      //guardo en textarea
    	$("#<?= $lv_sec; ?> #steevtdocdat").text( JSON.stringify(lv_evtdocdat) );   
      $("#<?= $lv_sec; ?> #steevtdocdatdel").text( JSON.stringify(lv_evtdocdatdel) );    

      return true;
    }
  </script>
</section>
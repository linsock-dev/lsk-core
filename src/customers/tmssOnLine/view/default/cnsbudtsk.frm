<?php 
	// titulo
	$lv_title = $vew_lang->document;

	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<style> .htContextMenu.handsontable { z-index: 1100; } </style>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?= gethtml('row','hidden',$vew_data->row); ?>
	<textarea id="budtsk" name="budtsk" class="hidden"><?= $vew_data->budtsk; ?></textarea>
	<textarea id="budtskdel" name="budtskdel" class="hidden"></textarea>	
	<button id="budtskdwn" class="hidden"></button>
  
	<div class="col-md-12" id="prcschcnddiv">
		<div class="card tmss-hot-ttl">
			<div class="card-header">
				<div class="card-title"><a href="#" id="btntskcfg" class="btn btn-default btn-sm navbar-btn disabled" title="Análisis Tarea"><span class="far fa-object-group"></span> <span class="hidden-xs">An&aacute;lisis Tarea</span></a></div>
			</div>
			<div id="budtskhot" name="budtskhot"></div>
		</div>
	</div>
  
	<script>
		// descarga la info de la grilla en campos de texto
		$("#<?= $lv_sec; ?> #budtskdwn").on("click",function(e){ e.preventDefault();
			var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
			$("#<?= $lv_sec; ?> #budtsk").text( JSON.stringify(lv_dat) );
			$("#<?= $lv_sec; ?> #budtskdel").text( JSON.stringify(<?= $lv_sec; ?>_hotdocdel) );
		});
		
		// BOTON. Analisis de Tareas
		$("#<?= $lv_sec; ?> #btntskcfg").on("click",function(e){ e.preventDefault();
			if( <?= $lv_sec; ?>_hotdoc.getSelected() != undefined && <?= $lv_sec; ?>_hotdoc.getSelected().length>0 ){
				<?= $lv_sec; ?>_showTaskDetail( <?= $lv_sec; ?>_hotdoc.getSelected()[0][0] );
			}
		});
		
		// apertura de ventana de analisis de tarea
		function <?= $lv_sec; ?>_showTaskDetail( lp_row ) {
      var lv_row = lp_row;
			var lv_budtsk;
			if( Array.isArray(<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row,"cnstskmat")) ) {
				lv_budtsk = JSON.stringify( <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( lv_row , "cnstskmat") );
			} else {
				lv_budtsk = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( lv_row , "cnstskmat");
			}
        
			var lv_pstdat=[ {name:"budcod",value:"<?= $vew_data->budcod; ?>"},
											{name:"budver",value:"<?= $vew_data->budver; ?>"},
											{name:"srcobjtxt",value: <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( lv_row , "srcobjtxt")},
											{name:"budtsk",value: lv_budtsk },
											{name:"row",value:lv_row},
											{name:"actcod",value:"<?= $vew_actcod; ?>"}
										];
			tmssCallProcess("?prg=cnsbud&act=showTasks",lv_pstdat,function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->tasks; ?>",
					message: $(data),
					type: BootstrapDialog.TYPE_INFO,
					size: BootstrapDialog.SIZE_WIDE,
					closable: false,
					draggable: true,
					buttons: [{ label: "<?= ($vew_readonly?$vew_lang->close:$vew_lang->cancel); ?>", cssClass: "<?= ($vew_readonly?'btn-default':'btn-danger'); ?>", action: function(dialog){ dialog.close(); } }
										,{label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success <?= ($vew_readonly?'hidden':''); ?>",	action: function(dialog){
                      	dialog.$modalBody.find("#budtskdwn").trigger("click");
												var lv_row = dialog.$modalBody.find("#row").prop("value");
												var lv_tsk = dialog.$modalBody.find("#budtsk").text(); 
												var lv_tskdel = dialog.$modalBody.find("#budtskdel").text();
												<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( lv_row, "cnstskmat", lv_tsk);
												<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( lv_row, "cnstskmatdel", lv_tskdel);
                      	dialog.close();
											}}
										]
				});
			});		
		}
	</script>
	<script>
		function <?= $lv_sec; ?>_getObject( lp_txt, query ) {
			var lv_ret = {type:"",url:"",prm:{},id:"",txt:""};
			switch(lp_txt){
				case "<?= $vew_lang->employees; ?>": lv_ret = {type:"HHR_EMP", url:"hhremp", prm:{ prm_hhremptxt: query }, id:"hhrempcod", txt:"hhremptxt", cod:"hhrempcodext"}; break;
				case "Vehiculos":	lv_ret = {type:"LOG_VHC", url:"logvhc", prm:{ prm_vhctxt: query }, id:"vhccod", txt:"vhctxt", cod:"vhccodext"}; break;
				case "<?= $vew_lang->materials; ?>": lv_ret = {type:"STK_MAT", url:"stkmat", prm:{ prm_mattxt: query }, id:"matcod", txt:"mattxt", cod:"matcodext"}; break;
				case "<?= $vew_lang->supplier; ?>": lv_ret = {type:"BUY_SUP", url:"buysup", prm:{ prm_suptxt: query }, id:"supcod", txt:"suptxt", cod:"supcodext"}; break;
				case "<?= $vew_lang->tasks; ?>": lv_ret = {type:"CNS_TSK", url:"cnstsk", prm:{ prm_cnstsktxt: query }, id:"cnstskcod", txt:"cnstsktxt", cod:"cnstskcodext"}; break;
			}
			return lv_ret;
		}

		function <?= $lv_sec; ?>_getObjectByCode( lp_txt, query ) {
			var lv_ret = {type:"",url:"",prm:{},id:"",txt:""};
			switch(lp_txt){
				case "<?= $vew_lang->employees; ?>": lv_ret = {type:"HHR_EMP", url:"hhremp", prm:{ prm_hhrempcodext: query }, id:"hhrempcod", txt:"hhremptxt", cod:"hhrempcodext"}; break;
				case "Vehiculos":	lv_ret = {type:"LOG_VHC", url:"logvhc", prm:{ prm_vhccodext: query }, id:"vhccod", txt:"vhctxt", cod:"vhccodext"}; break;
				case "<?= $vew_lang->materials; ?>": lv_ret = {type:"STK_MAT", url:"stkmat", prm:{ prm_matcodext: query }, id:"matcod", txt:"mattxt", cod:"matcodext"}; break;
				case "<?= $vew_lang->supplier; ?>": lv_ret = {type:"BUY_SUP", url:"buysup", prm:{ prm_supcodext: query }, id:"supcod", txt:"suptxt", cod:"supcodext"}; break;
				case "<?= $vew_lang->tasks; ?>": lv_ret = {type:"CNS_TSK", url:"cnstsk", prm:{ prm_cnstskcodext: query }, id:"cnstskcod", txt:"cnstsktxt", cod:"cnstskcodext"}; break;
			}
			return lv_ret;
		}
	</script>	
  <script>
    // parsea una estructura plana en una jerarquia de arrays basado en el indice (rowkey)
		function <?= $lv_sec; ?>_parseCnsTskMatHot( lp_dat, lp_inx, lp_keyprv ){
      var lv_arr = new Array();
			for(var i=lp_inx[0]; i<lp_dat.length; i++, lp_inx[0]++){
				// verifico que no esté armando más de 5 niveles de elementos
				if(lp_dat[i]["rowkey"].length < 4*5+5){
        	// comparo elemento actual y elemento siguiente
          if(i+1<lp_dat.length){
            // si el elemento siguiente pertenece al elemento actual (comparte mismo inicio de clave) entonces se ejecuta la recursiva
            if( lp_dat[i]["rowkey"]+"."==lp_dat[i+1]["rowkey"].substring(0,(lp_dat[i]["rowkey"]+".").length) &&
                (lp_keyprv=="" || lp_keyprv+"."==lp_dat[i]["rowkey"].substring(0, (lp_keyprv+".").length)) ){
              lp_inx[0]++;
              lp_dat[i]["cnstskmat"] = <?= $lv_sec; ?>_parseCnsTskMatHot(lp_dat, lp_inx, lp_dat[i]["rowkey"]);
              lv_arr.push( lp_dat[i] );
              i = lp_inx[0];
            // el elemento siguiente no pertenece al array actual
            // el elemento actual pertenece a la raiz, se agrega
            } else if(lp_keyprv==""){
              lv_arr.push( lp_dat[i] ); 
            // verifico si el elemento actual sigue perteneciendo al array
            } else if(lp_keyprv+"."==lp_dat[i]["rowkey"].substring(0,(lp_keyprv+".").length) ) {
              lv_arr.push( lp_dat[i] ); 
            // estamos dentro de una recursiva y el elemento actual no es parte del array tratado
            } else {
              lp_inx[0]--;
              return lv_arr;
            }

          // ultimo elemento del array
          // el elemento siguiente no pertenece al array actual
          // el elemento actual pertenece a la raiz, se agrega
          } else if(lp_keyprv==""){
            lv_arr.push( lp_dat[i] ); 
          // verifico si el elemento actual sigue perteneciendo al array
          } else if(lp_keyprv+"."==lp_dat[i]["rowkey"].substring(0,(lp_keyprv+".").length) ) {
            lv_arr.push( lp_dat[i] ); 
          // estamos dentro de una recursiva y el elemento actual no es parte del array tratado
          } else {
            lp_inx[0]--;
            return lv_arr;
          }
        }
			}
    
			return lv_arr;
		}
  </script>
	<script>
		// determina si una fila es un grupo/rubro
		function <?= $lv_sec; ?>_isGroup( lp_row ) {
			var lv_matcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lp_row,"srcobjcod001");
			var lv_mattxt = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lp_row,"srcobjtxt");
			var lv_matqty = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lp_row,"matqty");
			return ( (lv_matcod==null?"":lv_matcod)=="" && (lv_mattxt==null?"":lv_mattxt)!="" && (lv_matqty==null?"":lv_matqty)=="" ? true : false );
		}

		// verifica si la fila seleccionada es una tarea
		function <?= $lv_sec; ?>_checkTask( lp_row ){
			if( <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lp_row,"srcobjtyp")=="CNS_TSK" ){
				$("#<?= $lv_sec; ?> #btntskcfg").removeClass("disabled");
			} else {
				$("#<?= $lv_sec; ?> #btntskcfg").addClass("disabled");
			}
		}
		
		// RENDERER - GENERAL
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if(typeof <?= $lv_sec; ?>_hotdoc=="undefined"){return false;}
			var lv_ro_color = "#F1F1F1";
			var lv_color = "#FFFFFF";
			if( <?= $lv_sec; ?>_isGroup(row)==true ) {
				td.style.backgroundColor = "#e0ffbc";
				td.style.fontWeight = "bold";
				Handsontable.renderers.TextRenderer.apply(this, arguments);
			} else if( prop=="srcobjtyptxt" ){
        Handsontable.renderers.DropdownRenderer.apply(this, arguments);			
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else if ( prop=="srcobjtxt" ) {
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else if ( prop=="matqty" ) {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else if ( prop=="budmatatrtmestr" || prop=="budmatatrtmeend" ) {
				Handsontable.renderers.TimeRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else { // valor por default (UM,importe)
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		
		// COSTOS - HOT
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #budtskhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 370,
			stretchH: "all",
			autoColumnSize: true, 
      <?= $vew_readonly ? '' : 'contextMenu: ["row_above", "row_below", "remove_row"],' ?>
			autoWrapRow: true,
			rowHeaders: true,
			licenseKey: 'non-commercial-and-evaluation',
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			outsideClickDeselects: false,
			colHeaders: [ "<?= $vew_lang->type; ?>","<?= $vew_lang->code; ?>","<?= $vew_lang->description; ?>","Cant","UM","<?= $vew_lang->from; ?>","<?= $vew_lang->to; ?>" ],
			columns: [
				{ type: "dropdown", data: "srcobjtyptxt", width: 70, source: ["<?= $vew_lang->employees; ?>","<?= $vew_lang->Materials; ?>","Vehiculos","<?= $vew_lang->tasks; ?>","<?= $vew_lang->supplier; ?>"], renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?',readOnly: true ':''); ?>},
				{	type: "text",		data: "srcobjcodext", width: 40, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?>},
				{ type: "autocomplete", data: "srcobjtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?>, 
					source: function (query, process) {
            var lv_srcobjtyptxt = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( this.row, "srcobjtyptxt" );						
						if(lv_srcobjtyptxt!=""){
							var lv_dat = <?= $lv_sec; ?>_getObject( lv_srcobjtyptxt, query );
							if(lv_dat.url!=""){
                var lv_url = "?prg="+lv_dat.url+"&act=17&"+Object.keys(lv_dat.prm)[0]+"="+encodeURIComponent(Object.values(lv_dat.prm)[0]);
								tmssCallProcessNoBackdrop(lv_url, [],function(data){
                  var lv_data;
									if(data.data==undefined){ lv_data=data; } else { lv_data=data.data; }
									var lv_ret = [];
									<?= $lv_sec; ?>_hotdocchg = [];
									for (var i=0; i < lv_data.length; i++) { 
										<?= $lv_sec; ?>_hotdocchg.push({srcobjtyp:lv_dat.type,
																										srcobjtxt:lv_data[i][lv_dat.txt],
																										srcobjcod001:lv_data[i][lv_dat.id], 
																										srcobjcodext:(lv_data[i][lv_dat.cod]==null?"":lv_data[i][lv_dat.cod]), 
																										matqty:(lv_data[i]["matqty"]!=undefined?lv_data[i]["matqty"]:"1"),
																										matuntcod:(lv_data[i]["matuntcod"]!=undefined?lv_data[i]["matuntcod"]:"UN") });
										lv_ret.push( lv_data[i][lv_dat.txt] );
									}
									process( lv_ret );							
								});
							}
						}
					}, strict: false },
				{ type: "numeric",data: "matqty", width: 40, numericFormat: {pattern: "0,0.00", culture: "es-AR"}, width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?>},
				{	type: "text",		data: "matuntcod", width: 40, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?>},
				{	type: "time",		data: "budmatatrtmestr", width: 40, timeFormat: "HH:mm", correctFormat: true, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?>},
				{	type: "time",		data: "budmatatrtmeend", width: 40, timeFormat: "HH:mm", correctFormat: true, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?>}
			],
			beforeChange: function(changes, source){
        if(source=="edit"){
					for(var i=0 ; i<changes.length ; i++) {
						switch(changes[i][1]){
							
							// cambio en el tipo de origen
							case "srcobjtyptxt":
								var lv_dat = <?= $lv_sec; ?>_getObjectByCode( changes[i][3], "" );
								<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "srcobjtyp", lv_dat.type, "paste" );
								<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "srcobjtxt", "", "paste" );
								<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "srcobjcod001", "", "paste" );
								<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "srcobjcodext", "", "paste" );
								<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "matqty", "", "paste" );
								<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "matuntcod", "", "paste" );
								<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "cnstskmat", "", "paste" );
								break;
						
							// codigo externo
							case "srcobjcodext":
								var lv_srcobjtyptxt = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( changes[i][0], "srcobjtyptxt" );
								if(lv_srcobjtyptxt!="" && changes[i][3]!="" && changes[i][3]!=undefined ){
									var lv_dat = <?= $lv_sec; ?>_getObjectByCode( lv_srcobjtyptxt, changes[i][3] );
									if(lv_dat.url!=""){
										lv_dat.row = changes[i][0];
										tmssCallProcessNoBackdrop("?prg="+lv_dat.url+"&act=17&"+Object.keys(lv_dat.prm)[0]+"="+Object.values(lv_dat.prm)[0], lv_dat ,function(data){
											if(data.data.length==0){
												toastr.warning("Codigo no encontrado.");
												return false;
											} else {
												<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( data.post.row, "srcobjtxt", data.data[0][data.post.txt], "paste" );
												<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( data.post.row, "srcobjcod001", data.data[0][data.post.id], "paste" );
												<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( data.post.row, "matqty", (data.data[0]["matqty"]!=undefined?data.data[0]["matqty"]:"1"), "paste" );
												<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( data.post.row, "matuntcod", (data.data[0]["matuntcod"]!=undefined?data.data[0]["matuntcod"]:"UN"), "paste" );
											
                      	// antes de quitar los elementos, agrego el registro a los que deben eliminarse
                        var lv_cnstskmat = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(data.post.row,"cnstskmat");
                        for(var z=0; z<lv_cnstskmat.length; z++){
                          if ( lv_cnstskmat[z]["budmatcod"]!="" && lv_cnstskmat[z]["budmatcod"]!=undefined ) {
                            <?= $lv_sec; ?>_hotdocdel.push( lv_cnstskmat[z] );
                          }
                        }
                        <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( data.post.row, "cnstskmat", "", "paste" );
													
                        if( data.post.type=="CNS_TSK" ) {
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( data.post.row, "matuntcod", "UN", "paste" );
                          tmssCallProcessNoBackdrop("?prg=cnstsk&act=getComp",[{name:"row",value:data.post.row},{name:"cnstskcod",value:data.data[0][data.post.id]}],function(data){
                            
                            <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(data.row,"cnstskmat",JSON.stringify(<?= $lv_sec; ?>_parseCnsTskMatHot(data["cnstskmat"],[0], "")), "paste");
                          });
                        } else {
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( data.post.row, "matuntcod", (data.data[0]["matuntcod"]!=undefined?data.data[0]["matuntcod"]:"UN"), "paste" );
                        }
                      }
										});
									}
								}
								break;

							// typeahead del objeto
							case "srcobjtxt":
								//cambia el codigo del objeto de origen y la unidad 
								for(var x=0; x<<?= $lv_sec; ?>_hotdocchg.length; x++){
									if(<?= $lv_sec; ?>_hotdocchg[x].srcobjtxt == changes[i][3]) {
										
										<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "srcobjtyp", String(<?= $lv_sec; ?>_hotdocchg[x].srcobjtyp), "paste" );
										<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "srcobjcod001", String(<?= $lv_sec; ?>_hotdocchg[x].srcobjcod001), "paste" );
										<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "srcobjcodext", String(<?= $lv_sec; ?>_hotdocchg[x].srcobjcodext), "paste" );
										<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "matqty", String(<?= $lv_sec; ?>_hotdocchg[x].matqty), "paste" );
									
										// antes de quitar los elementos, agrego el registro a los que deben eliminarse
										var lv_cnstskmat = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0],"cnstskmat");
										for(var z=0; z<lv_cnstskmat.length; z++){
											if ( lv_cnstskmat[z]["budmatcod"]!="" && lv_cnstskmat[z]["budmatcod"]!=undefined ) {
												<?= $lv_sec; ?>_hotdocdel.push( lv_cnstskmat[z] );
											}
										}
										<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "cnstskmat", "", "paste" );
										
										if( String(<?= $lv_sec; ?>_hotdocchg[x].srcobjtyp)=="CNS_TSK" ) {
											<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "matuntcod", "UN", "paste" );
											tmssCallProcessNoBackdrop("?prg=cnstsk&act=getComp",[{name:"row",value:changes[i][0]},{name:"cnstskcod",value:String(<?= $lv_sec; ?>_hotdocchg[x].srcobjcod001)}],function(data){
       									 <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(data.row,"cnstskmat",JSON.stringify(<?= $lv_sec; ?>_parseCnsTskMatHot(data["cnstskmat"],[0], "")), "paste" );
											});
										} else {
											<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "matuntcod", String(<?= $lv_sec; ?>_hotdocchg[x].matuntcod), "paste" );
										}
										break;
									}
								}         
								break;
						} 
					}
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["budmatcod"]!="" && lv_dat[i]["budmatcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			},
			afterSelection: function(row,col,row2,col2,obj,layer){
        <?= $lv_sec; ?>_checkTask( row );
        
			}
		};
		 
		var <?= $lv_sec; ?>_hotdoc;
		tmssLoadScript("handsontable",function(){
      <?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);			
			var lv_dat = [<?php
				$lv_buffer='';
        $lv_data = json_decode( html_entity_decode($vew_data->budtsk) , true );
				if( is_array($lv_data) ){
					foreach($lv_data as $lv_row){ 
						if( ($lv_row['srcobjtyp']??'')!='' && ($lv_row['srcobjcod001']??'')!='' ){
							$lv_rowkey = ($lv_row['budmatrow']??'');
              $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
													'budmatcod:\''.($lv_row['budmatcod']??'').'\','.
													'srcobjtyp:\''.$lv_row['srcobjtyp'].'\','.
                          'srcobjtyptxt:\''.($lv_row['srcobjtyp']=='HHR_EMP'?$vew_lang->employees:
																					($lv_row['srcobjtyp']=='STK_MAT'?$vew_lang->materials:
																					($lv_row['srcobjtyp']=='LOG_VHC'?"Vehiculos":
																					($lv_row['srcobjtyp']=='BUY_SUP'?$vew_lang->supplier:
																					($lv_row['srcobjtyp']=='CNS_TSK'?$vew_lang->tasks:''))))).'\','.
													'srcobjcod001:\''.$lv_row['srcobjcod001'].'\','.
													'srcobjcodext:\''.($lv_row['srcobjcodext']??'').'\','.
													'srcobjtxt:\''.utf8_decode($lv_row['srcobjtxt']??'').'\','.
													'matqty: '.($lv_row['matqty']??'1').' ,'.
													'matuntcod:\''.($lv_row['matuntcod']??'').'\','.
													'budmatatrtmestr:\''.($lv_row['budmatatrtmestr']??'').'\','.
													'budmatatrtmeend:\''.($lv_row['budmatatrtmeend']??'').'\','.
													'budmatrow:\''.($lv_row['budmatrow']??'').'\','.
													'cnstskmat:'.json_encode($lv_row['cnstskmat']??'[]').' '.
													'}';
						}
					}
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
		
		$(function(){ tmssHandsontableResize(); });
	</script>
</section>
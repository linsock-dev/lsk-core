<!-- COMPONENTES --> 
<?= gethtml('budcstcmplnk','hidden',''); ?>
<textarea id="budcstdatcmpdeltmp" name="budcstdatcmpdeltmp" style="display: none;"></textarea>

<div class="modal fade" id="budcstcmpmdl" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header"><h4 class="modal-title">Análisis de Tarea</h4></div>
			<div class="modal-body">
			
				<nav class="navbar navbar-default tmss-navbar">
					<div class="container-fluid">
						<ul class="nav navbar-nav">
							<p class="navbar-text" id="title" style="color: #ffffff;"></p>
						</ul>
						<ul class="nav navbar-nav navbar-right">
							<a href="#" id="btndel" class="btn btn-default navbar-btn" title="Borrar" onclick="$('#<?= $lv_sec; ?> #budcstcmpmdl').modal('hide');"><i class="fas fa-trash-alt"></i></a>
							<span> | </span>
							<a href="#" id="btnord" class="btn btn-default navbar-btn" title="Reorganizar"><i class="fas fa-sitemap"></i></a>
							<span> | </span>
							<a href="#" id="btnok" class="btn btn-success navbar-btn" title="Aceptar"><i class="fas fa-check"></i> Aceptar</a>
							<a href="#" id="btncnc" class="btn btn-danger navbar-btn" title="Cancelar"><i class="fas fa-times"></i> Cancelar</a>
						</ul>
					</div>
				</nav>

				<div id="budcstcmpsht" name="budcstcmpsht"></div>

				<div class="row">
					<div class="form-group tmss-form-group">
						<label class="col-xs-8 control-label"><div class="pull-right">TOTAL</div></label>
						<div class="col-xs-4"><input type="TEXT" id="budcstcmptot" name="budcstcmptot" value="" maxlength="13" class="form-control tmssAlwaysDisabled" readonly="readonly"></div>
					</div>
				</div>

			</div>
		</div>
	</div>
</div>

<script>
	/**
	 *
	 *	C O M P O N E N T E S
	 *
	 */
	var <?php echo $lv_sec; ?>_hotcmp_renderer = function(instance, td, row, col, prop, value, cellProperties) {
		Handsontable.renderers.TextRenderer.apply(this, arguments);
		if (instance.getDataAtCell(row,'budmatsrctyp')=='TOTAL'){td.style.backgroundColor='#F1F1F1';}
		if ( prop=='budmatsrccod' ) {	// codigo
			td.style.backgroundColor = '#F1F1F1';
		} else if ( prop=='matfctren' || prop=='matqty' || prop=='matprc' ) {	// factor, cantidad, precio
			Handsontable.renderers.NumericRenderer.apply(this, arguments);
		}
	};
	var <?php echo $lv_sec; ?>_hotcmp_totRenderer = function (instance, td, row, col, prop, value, cellProperties) {
		var lv_arr = instance.getSourceData();
		var lv_fctren=0; var lv_prc=0; var lv_qty=0; var lv_tot=0; var lv_sum=0;

		td.style.backgroundColor = '#F1F1F1';
		// total
		if (prop=='mattot') {
			// del rubro
			if ( lv_arr[row]['budmatsrctyp']=='TOTAL' ) {
				// calculo el subtotal
				lv_sum=0;
				for (var i=row-1; i>=0; i-- ) {
					lv_fctren = getNumber(lv_arr[i]['matfctren']);
					lv_prc = getNumber(lv_arr[i]['matprc']);
					lv_qty = getNumber(lv_arr[i]['matqty']);
					if ( i<row && lv_arr[i]['budmatsrctyp']=='TOTAL') { break; } else { lv_sum += (lv_fctren * lv_prc * lv_qty); }
				}
				arguments[5] = lv_sum;
			// de la fila
			} else {
				lv_fctren = getNumber(lv_arr[row]['matfctren']);
				lv_prc = getNumber(lv_arr[row]['matprc']);
				lv_qty = getNumber(lv_arr[row]['matqty']);
				value = lv_fctren * lv_prc * lv_qty;
				arguments[5] = value;
			}

		// porcentaje
		} else if (prop=='mattotprg') {
			// calculo el total general
			lv_tot=0;
			for(var i=0; i<lv_arr.length-1;i++) { 
				lv_fctren = getNumber(lv_arr[i]['matfctren']);
				lv_prc = getNumber(lv_arr[i]['matprc']);
				lv_qty = getNumber(lv_arr[i]['matqty']);
				lv_tot+= (lv_fctren*lv_prc*lv_qty); 
			}
			$('#<?php echo $lv_sec; ?> #budcstcmpcmptot').prop('value',lv_tot.toFixed(2) );
			// del rubro
			if (lv_arr[row]['budmatsrctyp']=='TOTAL') {
				// calculo el subtotal
				lv_sum=0;
				for (var i=row-1; i>=0; i-- ) {
					lv_fctren = getNumber(lv_arr[i]['matfctren']);
					lv_prc = getNumber(lv_arr[i]['matprc']);
					lv_qty = getNumber(lv_arr[i]['matqty']);
					if ( i<row && lv_arr[i]['budmatsrctyp']=='TOTAL') { break; } else { lv_sum += (lv_fctren * lv_prc * lv_qty); }
				}
				value = lv_sum * 100 / (lv_tot==0?1:lv_tot);
				arguments[5] = value;
			// de la fila
			} else {
				lv_fctren = getNumber(lv_arr[row]['matfctren']);
				lv_prc = getNumber(lv_arr[row]['matprc']);
				lv_qty = getNumber(lv_arr[row]['matqty']);
				if ( lv_tot==0 ) {
					value = 0;
					arguments[5] = value;
				} else {
					value = (lv_fctren * lv_prc * lv_qty) * 100 / lv_tot;
					arguments[5] = value;
				}
				$('#<?php echo $lv_sec; ?> #budcstcmptot').prop('value', lv_tot.toFixed(2) );
			}
		}
		Handsontable.renderers.NumericRenderer.apply(this, arguments);
	};
	
	
	// COSTOS - COMPONENTES
	var <?php echo $lv_sec; ?>_hotcmpcnt = $('#<?php echo $lv_sec; ?> #budcstcmpsht')[0];
	var <?php echo $lv_sec; ?>_hotcmpset = {
		height: 200,
		stretchH: 'all',
		autoColumnSize: true,
		contextMenu: ['row_above', 'row_below', 'remove_row'],
		autoWrapRow: true,
		rowHeaders: true,
		minSpareRows: <?php echo ($vew_readonly?'0':'1'); ?>,
		colHeaders: [ 'Typ','Cod','Descripcion','F.Rend.','Cant','UM','PU','Importe','%' ],
		columns: [
			{	type: 'autocomplete', data: 'mattypcod',	  width: 100, renderer: <?php echo $lv_sec; ?>_hotcmp_renderer, source: ['MAN', 'MAT', 'SUB'], strict: true },
			{ type: 'text', 				data: 'budmatsrccod', width: 50, renderer: <?php echo $lv_sec; ?>_hotcmp_renderer, readOnly: true },
			{	type: 'autocomplete', data: 'budmatsrctxt',	width: 250,renderer: <?php echo $lv_sec; ?>_hotcmp_renderer, 
				source: function (query, process) {
					$.ajax({
						url: 'index.php?prg=stkmat&act=17', dataType: 'json', data: {	prm_mattxt: query },
						//url: 'index.php?prg=buysup&act=17', dataType: 'json', data: {	prm_suptxtquery: query },
						complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=='/*script*/'){ eval(jqXHR.responseText); return;}},
						success: function (response) {
							html = '';
							for (var i = 0; i < response.data.length; i++) {
								html += (html==''?'':',') + '"<budmatsrctxt>' + response.data[i]['mattxt'] + '</budmatsrctxt><budmatsrccod style='+String.fromCharCode(39)+'display: none;'+String.fromCharCode(39)+'>'+response.data[i]['matcod']+'</budmatsrccod><matuntcod style='+String.fromCharCode(39)+'display: none;'+String.fromCharCode(39)+'>'+response.data[i]['matuntcod']+'</matuntcod><matprc style='+String.fromCharCode(39)+'display: none;'+String.fromCharCode(39)+'>'+response.data[i]['matcst']+'</matprc><mattypcod style='+String.fromCharCode(39)+'display: none;'+String.fromCharCode(39)+'>'+response.data[i]['mattypcod']+'</mattypcod>"';
								//html += (html==''?'':',') + '"<budmatsrctxt>' + response.data[i]['suptxt'] + '</budmatsrctxt><budmatsrccod style='+String.fromCharCode(39)+'display: none;'+String.fromCharCode(39)+'>'+response.data[i]['supcod']+'</budmatsrccod><matuntcod style='+String.fromCharCode(39)+'display: none;'+String.fromCharCode(39)+'>UN</matuntcod><matprc style='+String.fromCharCode(39)+'display: none;'+String.fromCharCode(39)+'>0</matprc>"';
							}
							process(JSON.parse('['+html+']'));
						}
					});
				}, strict: false },
			{ type: 'numeric', 	data: 'matfctren', numericFormat: {pattern: "0,0.00", culture: "es-AR"}, width: 50, renderer: <?php echo $lv_sec; ?>_hotcmp_renderer }, /* factor de rendimiento */
			{ type: 'numeric', 	data: 'matqty', 	numericFormat: {pattern: "0,0.00", culture: "es-AR"}, width: 50, renderer: <?php echo $lv_sec; ?>_hotcmp_renderer },
			{	type: 'text', 		data: 'matuntcod', 								width: 50, renderer: <?php echo $lv_sec; ?>_hotcmp_renderer },
			{ type: 'numeric', 	data: 'matprc', 	numericFormat: {pattern: "0,0.00", culture: "es-AR"}, width: 50, renderer: <?php echo $lv_sec; ?>_hotcmp_renderer },
			{ type: 'numeric', 	data: 'mattot',		numericFormat: {pattern: "0,0.00", culture: "es-AR"}, width: 70, renderer: <?php echo $lv_sec; ?>_hotcmp_totRenderer, readOnly: true },
			{ type: 'numeric', 	data: 'mattotprg',numericFormat: {pattern: "0,0.00", culture: "es-AR"}, width: 50, renderer: <?php echo $lv_sec; ?>_hotcmp_totRenderer, readOnly: true } /* incidencia */			
		],
		beforeRemoveRow: function (index, amount, logicalRows) {
			// guardo los ID de los elementos que voy borrando
			var lv_dat = <?php echo $lv_sec; ?>_hotcmp.getSourceData();
			lv_strdel = $('#<?php echo $lv_sec; ?> #budcstdatcmpdeltmp').text();
			lv_arrdel = JSON.parse( (lv_strdel==""?"[]":lv_strdel) );
			for ( var i=0; i<logicalRows.length; i++ ) {
				if ( parseInt( lv_dat[logicalRows[i]]['budmatcod'] )>=0 ) {
					lv_arrdel.push({ 'budmatcod': lv_dat[logicalRows[i]]['budmatcod'] });
				}
			}
			$('#<?php echo $lv_sec; ?> #budcstdatcmpdeltmp').text( JSON.stringify(lv_arrdel) );
    },
		beforeChange: function(changes, source){
			if (source=='edit' && changes[0][1]=='budmatsrctxt') {
				var lv_dat = '<div>'+changes[0][3]+'</div>';
				var lv_mattxt = $(lv_dat).find('budmatsrctxt:first').text();
				if (lv_mattxt!='') { changes[0][3] = lv_mattxt; }
				var lv_mattypcod = $(lv_dat).find('mattypcod:first').text();
				changes.push([ changes[0][0], 'mattypcod', '', lv_mattypcod ]);
				var lv_matcod = $(lv_dat).find('budmatsrccod:first').text();
				changes.push([ changes[0][0], 'budmatsrccod', '', lv_matcod ]);
				var lv_matuntcod = $(lv_dat).find('matuntcod:first').text();
				if (lv_matuntcod!='') { changes.push([ changes[0][0], 'matuntcod', '', lv_matuntcod ]); }
				var lv_matprc = $(lv_dat).find('matprc:first').text();
				if (lv_matprc!='') { changes.push([ changes[0][0], 'matprc', '', (lv_matprc=='null'?'0':lv_matprc) ]); }
			}
		}	// fin beforeChange
	};
	var <?php echo $lv_sec; ?>_hotcmp;
	
	tmssLoadScript("handsontable",function(){
		<?php echo $lv_sec; ?>_hotcmp = new Handsontable(<?php echo $lv_sec; ?>_hotcmpcnt, <?php echo $lv_sec; ?>_hotcmpset);
	});
	
	
	// botón ANALISIS DE TAREA --------------------------------------------------------------------------------
	$('#<?php echo $lv_sec; ?> #btncstfldopn').on('click', function(evt) {
		var lv_cnt=0;
		// verifico si hay una fila seleccionada
		var lv_sel = <?php echo $lv_sec; ?>_hotcst.getSelected();
		if ( !(lv_sel===undefined) ) {
			// verifico que la fila no sea un rubro (los rubros no tienen componentes)
			var lv_budmatfld = <?php echo $lv_sec; ?>_hotcst.getDataAtCell(lv_sel[0],'budmatfld');
			if ( lv_budmatfld=='' || lv_budmatfld==null || lv_budmatfld===undefined ) {
				// recupero datos de la fila seleccionada (idmaterial, texto y unidad de medida)
				var lv_link3 = <?php echo $lv_sec; ?>_hotcst.getSourceData()[lv_sel[0]]['budmatcod'];
				var lv_mattxt = <?php echo $lv_sec; ?>_hotcst.getDataAtCell(lv_sel[0],'budmatsrctxt');
				var lv_matuntcod = <?php echo $lv_sec; ?>_hotcst.getDataAtCell(lv_sel[0],'matuntcod');
				// cargo los datos de todos los componentes
				var lv_strarr = $('#<?php echo $lv_sec; ?> #budcstdattmp').text();
				var lv_arr = JSON.parse( lv_strarr );
				// quito aquellos componentes que no corresponden a la fila seleccionada
				for (var i=lv_arr.length-1; i>=0; i--) {
					if ( $('<div>'+lv_arr[i]['budmatcfg']+'</div>').find('budmatcod:first').text()!=lv_link3.toString() ) { lv_arr.splice(i,1); }
				} 
				// mostrar modal con componentes
				$('#<?php echo $lv_sec; ?> #budcstcmpmdl #title').text( lv_mattxt + (lv_matuntcod==''?'':' ('+lv_matuntcod+')') );
				$('#<?php echo $lv_sec; ?> #budcstcmpmdl')
					.modal({backdrop: 'static', keyboard: false})
					.on('shown.bs.modal',function(evt2){
						if ( lv_cnt==0 ) {
							$('#<?php echo $lv_sec; ?> #budcstcmplnk').prop('value',lv_link3);
							$('#<?php echo $lv_sec; ?> #budcstdatcmpdeltmp').text('');
							<?php echo $lv_sec; ?>_hotcmp.loadData(lv_arr);
							<?php echo $lv_sec;?>_reorder();
							lv_cnt++;
						}
					});
			}
		}
	});
	// fin botón ANALISIS DE TAREA ----------------------------------------------------------------------------
	
	
	// botón ACEPTAR ------------------------------------------------------------------------------------------
	$('#<?php echo $lv_sec; ?> #budcstcmpmdl #btnok').on('click', function(evt) {
		// levantar todos los datos de los componentes y quito los que no corresponden a la fila seleccionada
		var lv_link = $('#<?php echo $lv_sec; ?> #budcstcmplnk').prop('value');
		var lv_strarr = $('#<?php echo $lv_sec; ?> #budcstdattmp').text();
		var lv_arr = JSON.parse( lv_strarr );
		for (var i=lv_arr.length-1; i>=0; i--) {
			if (lv_arr[i]['budmatcfg']=='<budmatcod>'+lv_link.toString()+'</budmatcod>') { lv_arr.splice(i,1); }
		}
		// agrego al array los datos de los componentes actuales
		var lv_dat = <?php echo $lv_sec; ?>_hotcmp.getSourceData();
		for (var i=0; i<lv_dat.length; i++) {
			if (lv_dat[i]['budmatsrctyp']!='TOTAL'){
				lv_arr.push({	'budmatcod':lv_dat[i]['budmatcod'], 
											'budmatrow':i.toString(), 
											'budmatcfg':'<budmatcod>'+lv_link.toString()+'</budmatcod>', 
											'budmatfld':'0', 
											'budmatsrctyp':(lv_dat[i]['budmatsrccod']==''?'TEXT':'STK_MAT'), 
											'budmatsrccod':lv_dat[i]['budmatsrccod'], 
											'budmatsrctxt':lv_dat[i]['budmatsrctxt'], 
											'matfctren':lv_dat[i]['matfctren'], 
											'matqty':lv_dat[i]['matqty'], 
											'matuntcod':lv_dat[i]['matuntcod'], 
											'matprc':lv_dat[i]['matprc'], 
											'supcod':lv_dat[i]['matsupcod'], 
											'suptxt':lv_dat[i]['suptxt'], 
											'matcstdte':lv_dat[i]['matcstdte'],
											'mattypcod':lv_dat[i]['mattypcod']
										});
			}
		}
		// actualizo precio en planilla de costos
		var lv_sel = <?php echo $lv_sec; ?>_hotcst.getSelected();
		<?php echo $lv_sec; ?>_hotcst.setDataAtRowProp(lv_sel[0],'matprc', $('#<?php echo $lv_sec; ?> #budcstcmptot').prop('value') );
		// vuelvo a actualizar los componentes
		$('#<?php echo $lv_sec; ?> #budcstdattmp').text( JSON.stringify(lv_arr) );
		// agrego los IDs de los componentes borrados a la lita general de IDs para borrado
		lv_strdelsrc = $('#<?php echo $lv_sec; ?> #budcstdatdeltmp').text();
		lv_arrdelsrc = JSON.parse( (lv_strdelsrc==""?"[]":lv_strdelsrc) );
		lv_strdelcmp = $('#<?php echo $lv_sec; ?> #budcstdatcmpdeltmp').text();
		lv_arrdelcmp = JSON.parse( (lv_strdelcmp==""?"[]":lv_strdelcmp) );
		lv_arrdelsrc.push.apply( lv_arrdelsrc, lv_arrdelcmp );
		$('#<?php echo $lv_sec; ?> #budcstdatdeltmp').text( JSON.stringify(lv_arrdelsrc) );
		// cierro la ventana modal
		$('#<?php echo $lv_sec; ?> #budcstcmpmdl').modal('hide');
	});
	// fin botón ACEPTAR --------------------------------------------------------------------------------------
	
	
	// botón CANCELAR
	$('#<?php echo $lv_sec; ?> #budcstcmpmdl #btncnc').on('click', function(evt) {
		$('#<?php echo $lv_sec; ?> #budcstcmpmdl').modal('hide');
	});
	
	
	// botón REORDENAR
	$('#<?php echo $lv_sec; ?> #budcstcmpmdl #btnord').on('click', function(evt) {
		<?php echo $lv_sec;?>_reorder();
	});
	
	
	// REORDENAR --------------------------------------------------------------------------------------
	function <?php echo $lv_sec;?>_reorder() {
		// obtengo los datos de los componentes actuales
		var lv_dat = <?php echo $lv_sec; ?>_hotcmp.getSourceData();
		// quito la fila de totales
		for (var i=lv_dat.length-1; i>=0; i--) { if(lv_dat[i]['budmatsrctyp']=='TOTAL'){lv_dat.splice(i,1);} }
		// ordeno según tipo de material y denominación
		var lv_dattmp;
		for (var i=0; i<lv_dat.length-1; i++) {
			for (var x=i+1; x<lv_dat.length; x++) {
				if ( lv_dat[x]['mattypcod']<lv_dat[i]['mattypcod'] || (lv_dat[x]['mattypcod']==lv_dat[i]['mattypcod'] && lv_dat[x]['budmatsrctxt']<lv_dat[i]['budmatsrctxt']) ) {
					lv_dattmp = lv_dat[x];
					lv_dat[x] = lv_dat[i];
					lv_dat[i] = lv_dattmp;
				}
			}
		}
		// agrego las filas de totales
		var lv_last='';
		var lv_tmparr;
		for (var i=0; i<lv_dat.length-1; i++) {
			if ( lv_dat[i]['mattypcod']!='' ) {
				if (lv_last==''){lv_last=lv_dat[i]['mattypcod'];}
				if (lv_last!=lv_dat[i]['mattypcod']) {
					lv_tmparr = new Array({'mattypcod':lv_last, 'budmatsrctyp':'TOTAL', 'budmatsrctxt':'TOTAL '+lv_last});
					lv_dat.splice(i,0,lv_tmparr[0]);
					i++;
				}
				lv_last = lv_dat[i]['mattypcod'];
			}
		}
		lv_tmparr = new Array({'mattypcod':lv_last, 'budmatsrctyp':'TOTAL', 'budmatsrctxt':'TOTAL '+lv_last});
		lv_dat.splice(lv_dat.length-1,0,lv_tmparr[0]);
		// actualizo la grilla con los valores ordenados
		<?php echo $lv_sec; ?>_hotcmp.loadData(lv_dat);
		// mostrar mensaje "Datos reorganizados" ?
	}
	// fin REORDENAR --------------------------------------------------------------------------------------

</script>
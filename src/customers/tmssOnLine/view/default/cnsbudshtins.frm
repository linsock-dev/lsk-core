<!-- INSUMOS --> 
<div class="modal fade" id="budcstinsmdl" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header"><h4 class="modal-title">Insumos</h4></div>
			<div class="modal-body">
			
				<nav class="navbar navbar-default tmss-navbar">
					<div class="container-fluid">
						<ul class="nav navbar-nav">
							<p class="navbar-text" id="title" style="color: #ffffff;"></p>
						</ul>
						<ul class="nav navbar-nav navbar-right">
							<a href="#" id="btnok" class="btn btn-success navbar-btn" title="Aceptar" onclick="$('#<?php echo $lv_sec; ?> #budcstcmpmdl').modal('hide');"><span class="fas fa-check"></span> Aceptar</a>
							<a href="#" id="btncnc" class="btn btn-danger navbar-btn" title="Cancelar" onclick="$('#<?php echo $lv_sec; ?> #budcstcmpmdl').modal('hide');"><span class="fas fa-times"></span> Cancelar</a>
						</ul>
					</div>
				</nav>
								
				<div id="budcstinssht" name="budcstinssht"></div>
				
			</div>
		</div>
	</div>
</div>

<script>
	/**
	 *
	 *	I N S U M O S
	 *
	 */
	var <?php echo $lv_sec; ?>_hotins_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
		if ( prop=='matqty' || prop=='matcst' || prop=='mattot' ) {
			Handsontable.renderers.NumericRenderer.apply(this, arguments);
			td.style.backgroundColor = '#F1F1F1';
		} else if ( prop=='suptxt' ) {
			Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
		} else { // valor por default (codigo,UM,importe)
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			td.style.backgroundColor = '#<?php echo ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			td.style.fontWeight = '';
		}
	};
	
	// INSUMOS - HOT
	var <?php echo $lv_sec; ?>_hotinscnt = $('#<?php echo $lv_sec; ?> #budcstinssht')[0];
	var <?php echo $lv_sec; ?>_hotinsset = {
		height: 396,
		stretchH: 'all',
		autoColumnSize: true,
		contextMenu: ['row_above', 'row_below', 'remove_row'],
		autoWrapRow: true,
		rowHeaders: true,
		colHeaders: [ 'Cod','Descripcion','Cant','UM','PU','Total','Proveedor','','Fecha' ],			
		columns: [
			{ type: 'text',         					data: 'budmatsrccod', 	width: 25,  renderer: <?php echo $lv_sec; ?>_hotins_renderer, readOnly: true},
			{ type: 'text',         					data: 'budmatsrctxt',		width: 150, renderer: <?php echo $lv_sec; ?>_hotins_renderer, readOnly: true},
			{ type: 'numeric', numericFormat: {pattern: "0,0.00", culture: "es-AR"},data: 'matqty', 	width: 50, 	renderer: <?php echo $lv_sec; ?>_hotins_renderer, readOnly: true},
			{ type: 'text',										data: 'matuntcod',width: 50, 	renderer: <?php echo $lv_sec; ?>_hotins_renderer, readOnly: true},
			{ type: 'numeric', numericFormat: {pattern: "0,0.00", culture: "es-AR"},data: 'matprc', 	width: 50, 	renderer: <?php echo $lv_sec; ?>_hotins_renderer, readOnly: true},
			{ type: 'numeric', numericFormat: {pattern: "0,0.00", culture: "es-AR"},data: 'mattot', 	width: 50, 	renderer: <?php echo $lv_sec; ?>_hotins_renderer, readOnly: true},	
			{	type: 'autocomplete', 					data: 'suptxt', 	width: 150, renderer: <?php echo $lv_sec; ?>_hotins_renderer, <?php echo ($vew_readonly?'readOnly: true, ':''); ?>
				source: function (query, process) {
					$.ajax({
						url: 'index.php?prg=buysup&act=17', dataType: 'json', data: {	prm_query: query },
						complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=='/ *script* /'){ eval(jqXHR.responseText); exit();}},
						success: function (response) {
							html = '';
							for (var i = 0; i < response.data.length; i++) {
								html += (html==''?'':',') + '"<suptxt>' + response.data[i]['suptxt'] + '</suptxtt><supcod style='+String.fromCharCode(39)+'display: none;'+String.fromCharCode(39)+'>'+response.data[i]['supcod']+'</supcod>"';
							}
							process(JSON.parse('['+html+']'));
						}
					});
				},
				strict: false
			},
			{	type: 'text',    data: 'supcod', 		width: 50, renderer: <?php echo $lv_sec; ?>_hotins_renderer, readOnly: true},
			{	type: 'date',    data: 'supcstdte', width: 50, renderer: <?php echo $lv_sec; ?>_hotins_renderer <?php echo ($vew_readonly?', readOnly: true':''); ?>}
		],
		beforeChange: function(changes, source){
			if (source=='edit' && changes[0][1]=='suptxt') {
				/*
				var lv_budmatsrccod = $('<div>'+changes[0][3]+'</div>').find('budmatsrccod:first').text();
				var lv_budmatsrctxt = $('<div>'+changes[0][3]+'</div>').find('budmatsrctxt:first').text();
				var lv_matuntcod = $('<div>'+changes[0][3]+'</div>').find('matuntcod:first').text();
				var lv_matcst = $('<div>'+changes[0][3]+'</div>').find('matcst:first').text();
				changes.push([ changes[0][0], 'budmatsrccod', '', lv_budmatsrccod ]);
				if (lv_matuntcod!='') { changes.push([ changes[0][0], 'matuntcod', '', lv_matuntcod ]); }
				if (lv_matcst!='') { changes.push([ changes[0][0], 'matprc', '', (lv_matcst=='null'?'0':lv_matcst) ]); }
				if (lv_budmatsrctxt!='') { changes[0][3] = lv_budmatsrctxt; }
				*/
			}
		},
		minSpareRows: 1,
		outsideClickDeselects: false
	};
	var <?php echo $lv_sec; ?>_hotins;	
	
	tmssLoadScript("handsontable",function(){
		<?php echo $lv_sec; ?>_hotins = new Handsontable(<?php echo $lv_sec; ?>_hotinscnt, <?php echo $lv_sec; ?>_hotinsset);	
	});

	// botón INSUMOS
	$('#<?php echo $lv_sec; ?> #btncstins').on('click', function(evt) {
		var lv_cnt=0;
		$('#<?php echo $lv_sec; ?> #budcstinsmdl')
			.modal({backdrop: 'static', keyboard: false})
			.on('shown.bs.modal',function(evt2){
				if ( lv_cnt==0 ) {
					var lv_dat = JSON.parse($('#<?php echo $lv_sec; ?> #budcstdattmp').prop('value'));
					//var lv_dat = <?php echo $lv_sec; ?>_hotcst.getSourceData();
					//var lv_cfg;
					for( var i=lv_dat.length-1; i>=0; i-- ) {
						//lv_cfg = $('<div>'+lv_dat[i]['budmatcfg']+'</div>');
						//if ( $(lv_cfg).find('budmatfld').length!=0 && $(lv_cfg).find('budmatfld').text()!='' ) { lv_dat.splice(i,1); }
						if ( !(lv_dat[i]['budmatfld']===undefined || lv_dat[i]['budmatfld']===null || lv_dat[i]['budmatfld']=='') ) { lv_dat.splice(i,1); }
					}
					<?php echo $lv_sec; ?>_hotins.loadData( lv_dat );
					lv_cnt++;
				}
			});
		evt.preventDefault();
	});
	
	// botón - INSUMOS - ACTUALIZAR COSTOS
	// FALTA
	
	// botón - INSUMOS - ACEPTAR
	$('#<?php echo $lv_sec; ?> #budcstmdl #btnok').on('click', function(evt) {
		var lv_end = [];
		var lv_budmatfld = <?php echo $lv_sec; ?>_hotins.getDataAtProp('budmatfld')
		var lv_budmatsrccod = <?php echo $lv_sec; ?>_hotins.getDataAtProp('budmatsrccod')
		var lv_budmatsrctxt = <?php echo $lv_sec; ?>_hotins.getDataAtProp('budmatsrctxt')
		var lv_matqty = <?php echo $lv_sec; ?>_hotins.getDataAtProp('matqty')
		var lv_matuntcod = <?php echo $lv_sec; ?>_hotins.getDataAtProp('matuntcod')
		var lv_matprc = <?php echo $lv_sec; ?>_hotins.getDataAtProp('matprc')
		for (var i=0; i<lv_budmatsrccod.length; i++) {
			lv_end.push( {'budmatrow':i, 'budmatfld':(lv_budmatfld[i]!=''?lv_budmatfld[i]:''), 'budmatsrctyp':(lv_budmatfld[i]!=''?'TEXT':'STK_MAT'), 'budmatsrccod':lv_budmatsrccod[i], 'budmatsrctxt':lv_budmatsrctxt[i], 'matqty':lv_matqty[i], 'matuntcod':lv_matuntcod[i], 'matprc':lv_matprc[i]} );
		}
		//$('#<?php echo $lv_sec; ?> #budcstdat').text( JSON.stringify(lv_end) );
		$('#<?php echo $lv_sec; ?> #budcstinsmdl').modal('hide');
	});
	
	// botón - INSUMOS - CANCELAR
	$('#<?php echo $lv_sec; ?> #budcstinsmdl #btncnc').on('click', function(evt) {
		$('#<?php echo $lv_sec; ?> #budcstinsmdl').modal('hide');
	});
</script>

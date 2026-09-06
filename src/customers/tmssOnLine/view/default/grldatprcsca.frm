<?php
	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// librería de estilos bootstrap 
	include_once('_library.frm');

	// accion por default 
	if ( !isset($vew_actcod) ) { $vew_actcod = '03'; }
	$vew_readonly = filter_var($vew_data->readonly, FILTER_VALIDATE_BOOLEAN);
?>
<section id="<?= $lv_sec; ?>">
  <?= gethtml('hotdoc','hidden',''); ?>
  <?= gethtml('hotdocdel','hidden',''); ?>
  <?= gethtml('hotdocerr','hidden',''); ?>
	<div class="form-horizontal">
		<div class="container-fluid">
      <?= vew_boot($lv_col210, array('label'=>$vew_lang->condition, 'input'=>gethtml('prccndatr', 'doccmt1x50', $vew_data->prccndatr,	$lv_always_disabled) )); ?>
			<div class="row">
				<div id="grlprccndhot"></div>
			</div>
		</div>
	</div>
  <script>
    function <?= $lv_sec; ?>_getData(){
      let lv_dat = { data:"", del:"", err:true };
      if( $("#<?= $lv_sec; ?> #hotdocerr").val() === "false" || $("#<?= $lv_sec; ?> #hotdocerr").val() === "" ){
        lv_dat.data = <?= $lv_sec; ?>_hotdoc.getSourceData();
        
        //remueve la primer fila y la ultima
        lv_dat.data.splice(0,1);lv_dat.data.splice(lv_dat.data.length-1,1);
        
        //remueve las filas que no esten completas
        for(let i=0; i<lv_dat.data.length; i++){
          if( lv_dat.data[i].prccndqty == "" || lv_dat.data[i].prccndqty == undefined || lv_dat.data[i].prccndtot == "" || lv_dat.data[i].prccndtot == undefined  ){ 
						lv_dat.data.splice(i,1);
            i--;
          }
        }
        
        lv_dat.del = <?= $lv_sec; ?>_hotdocdel;
        lv_dat.err = false;
      }
      
      return lv_dat;
    }
    
    function <?= $lv_sec; ?>_updateValid( ){
      if (<?= $lv_sec; ?>_hotdoc==undefined) { $("#<?= $lv_sec; ?> #hotdocerr").val( false );return false; }
                                          
      var lv_cols = <?= $lv_sec; ?>_hotdoc.getSourceDataAtCol(0);
      lv_cols.splice( lv_cols.length-1, 1 );
      <?= $lv_sec; ?>_hotdoc.validateRows( Array.from( lv_cols.keys() ), (valid) => { $("#<?= $lv_sec; ?> #hotdocerr").val( !valid ) } );
    }
	</script>
  <script>
    var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
        //tabla
        var hot = <?= $lv_sec; ?>_hotdoc;
        
        switch( prop ){
          case "prccndqty":
            if( value != null && ( value === 0 || value != "" ) ){
              let lv_col = <?= $lv_sec; ?>_hotdoc.getDataAtCol(col);
              for (let i = 0; i < lv_col.length-1; i++) { lv_col[i] = ( i == row ? null : parseFloat(lv_col[i]) ); }
							
              if( lv_col.indexOf( parseFloat(value) ) != -1 || value < lv_col[0] ){
                <?= $lv_sec; ?>_hotdoc.setCellMeta( row, col , "valid", false );
              }
            }
          case "prccndtot":
            Handsontable.renderers.NumericRenderer.apply(this, arguments);
            td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
            break;
          case "prccnduntcod":case "curcod":
            Handsontable.renderers.TextRenderer.apply(this, arguments);
          	td.style.backgroundColor = "#F1F1F1";
            break;
        }
        
        if( row == 0 ){ 
          td.style.backgroundColor = "#F1F1F1";
          cellProperties.readOnly = true; 
        }
			}
		};

    var <?= $lv_sec; ?>_hotdocprc = $("#<?= $lv_sec; ?> #grlprccndhot")[0];
    var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			autoWrapRow: false,
      <?= ($vew_readonly?'':'contextMenu: ["remove_row"],'); ?>
			minSpareRows: "<?= ($vew_readonly?'0':'1'); ?>",
			colHeaders: [ "<?= $vew_lang->from; ?>", "UM", "<?= $vew_lang->value; ?>", "<?= $vew_lang->currency; ?>" ],
			columns: [
        { type: "numeric", data: "prccndqty", numericFormat: {pattern: "0,0.00", culture: "es-AR"}, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
        { data: "prccnduntcod", renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true, width: 15},
        { type: "numeric", data: "prccndtot", numericFormat: {pattern: "0,0.00", culture: "es-AR"}, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
        { data: "curcod", 			renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true, width: 15},
			],
      beforeChange : function(changes, source) {
        if(changes && changes.length && ( source=="edit" || source=="paste" )){
          //agrega la unidad de medida y moneda
          if( changes[0][0]>0 && ( changes[0][1] == "prccndqty" || changes[0][1] == "prccndtot" ) ){
            <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[0][0], "prccnduntcod", "<?= (is_string($vew_data->prccnduntcod) ? $vew_data->prccnduntcod : '') ?>" ); 
            <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[0][0], "curcod", "<?= (is_string($vew_data->curcod) ? $vew_data->curcod : '') ?>" ); 
          }
        }
      },
      beforeRemoveRow: function(index, amount, logicalRows) {
        //evita que se pueda remover la primer fila
        if( index == 0 ){ return false; }
        
        var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				
        // me guardo todas las filas eliminadas (solo si tienen ID de registro)
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["prccndrowscacod"]!="" && lv_dat[i]["prccndrowscacod"]!=undefined ) { <?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] ); }
				}
			},
      afterRemoveRow: function(index, amount, physicalRows, source) { <?= $lv_sec; ?>_hotdoc.validateCells((valid) => { <?= $lv_sec; ?>_updateValid( index, 0 ); }); },
      afterChange: function(changes, source){
        if(changes && changes.length && ( source=="edit" || source=="paste" )){ <?= $lv_sec; ?>_updateValid( changes[0][0], 0 ); }
      }
		};
		var <?= $lv_sec; ?>_hotdoc;
    
		// inicializo handsontable
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdocprc, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
				$lv_buffer = '{'.
            					'prccndqty: "'.(is_string($vew_data->prccndqty) ? $vew_data->prccndqty : '').'",'.
              				'prccnduntcod: "'.(is_string($vew_data->prccnduntcod) ? $vew_data->prccnduntcod : '').'",'.
              				'prccndtot: "'.(is_string($vew_data->prccndval) ? $vew_data->prccndval : '').'",'.
                      'curcod: "'.(is_string($vew_data->curcod) ? $vew_data->curcod : '').'"}';
        if( $vew_data->prcsca == '' ){ $vew_data->prcsca = array(); }
				foreach($vew_data->prcsca as $lv_row) {
          if (!isset($lv_row['deleted'])){
          	$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
              				'prccndrowscacod:"'.(isset($lv_row['prccndrowscacod']) ? $lv_row['prccndrowscacod'] : '').'",'.
            					'prccndrowcod:"'.(isset($lv_row['prccndrowcod']) ? $lv_row['prccndrowcod'] : '').'",'.
                      'prccndqty: "'.(isset($lv_row['prccndqty']) ? $lv_row['prccndqty'] : '').'",'.
              				'prccnduntcod: "'.(is_string($vew_data->prccnduntcod) ? $vew_data->prccnduntcod : '').'",'.
              				'prccndtot: "'.(isset($lv_row['prccndtot']) ? $lv_row['prccndtot'] : '').'",'.
                      'curcod: "'.(is_string($vew_data->curcod) ? $vew_data->curcod : '').'"}'; 
          }
        }
        
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
            
      $("#<?= $lv_sec; ?> input.hidden[name=hotdoc]").val(JSON.stringify(<?= $lv_sec; ?>_hotdoc.getSourceData()));
		});
  </script>
</section>
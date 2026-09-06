<?php
	/* librer�a de estilos bootstrap */
	include_once('_library.frm');

	$vew_readonly = filter_var($vew_data->readonly, FILTER_VALIDATE_BOOLEAN);
?>

<section id="<?= $lv_sec; ?>">
	<div class="form-horizontal">
		<div class="container-fluid">
			<div class="row">
				<div id="chrasgatrold"></div>
			</div>
		</div>
	</div>
  <script>
     function <?= $lv_sec; ?>_getData(){
      let lv_dat = { data:"", err:false };
      lv_dat.data = <?= $lv_sec; ?>_hotdoc.getSourceData();

      //remueve las filas que no esten completas
      for(let i=0; i<lv_dat.data.length; i++){
        if( lv_dat.data[i].hhrlqdstrdte == "" || lv_dat.data[i].oldyth == "" || lv_dat.data[i].oldmth == "" ){ 
          lv_dat.err = true;
        }
      }      
      return lv_dat;
    }
  </script>
  <script>
    var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
        //tabla
        var hot = <?= $lv_sec; ?>_hotdoc;
        
        if(prop == "oldyth" || prop == "oldmth"){
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
          td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
        }else if (prop == "hhrlqdstrdte"){
					Handsontable.renderers.DateRenderer.apply(this, arguments);
          td.style.backgroundColor = "#F1F1F1";
        }
			}
		};

    var <?= $lv_sec; ?>_hotdocprc = $("#<?= $lv_sec; ?> #chrasgatrold")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
      <?= ($vew_readonly?'':'contextMenu: ["remove_row"],'); ?>
			minSpareRows: 0,
			colHeaders: [ "<?= $vew_lang->date; ?>", "A&ntilde;os", "Meses" ],
			columns: [
        {	type: "date", data: "hhrlqdstrdte", /*width: 20,*/ dateFormat: 'YYYY-MM', correctFormat: true, renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true},
        { type: "numeric", data: "oldyth", numericFormat: {pattern: "0", culture: "es-AR"}, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
        { type: "numeric", data: "oldmth", numericFormat: {pattern: "0", culture: "es-AR"}, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},        
			],
      beforeChange: function(changes, source){
        if(changes && changes.length && ( source=="edit" || source=="paste" )){ 
          if(changes[0][1] == "oldyth"){
            if (changes[0][3] == "" || changes[0][3] < 0){changes[0][3] = 0}
            if (changes[0][3] > 99){changes[0][3] = 99}
          }
          if(changes[0][1] == "oldmth"){
            if (changes[0][3] == "" || changes[0][3] < 0){changes[0][3] = 0}
            if (changes[0][3] > 11){changes[0][3] = 11}
          }
        }
      },
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotdoc;
    
		// inicializo handsontable
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdocprc, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
				$lv_buffer = '';
        if( $vew_data->atrold == '' ){ $vew_data->atrold = array(); }
				foreach($vew_data->atrold as $lv_row) {
          if (!isset($lv_row['deleted'])){
            $lv_date = (is_array($lv_row['hhrlqdstrdte']) ? substr($lv_row['hhrlqdstrdte']['date'],0,7) : substr($lv_row['hhrlqdstrdte'],0,7));
          	$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
              				'hhrlqdchrasgcod:"'.(isset($lv_row['hhrlqdchrasgcod']) ? $lv_row['hhrlqdchrasgcod'] : '').'",'.
            					'hhrlqdstrdte: "'.$lv_date.'",'.
              				'oldyth: "'.(($vew_doc->getTagValue($lv_row['hhrlqdchrasgatr'],'oldyth')!='') ? $vew_doc->getTagValue($lv_row['hhrlqdchrasgatr'],'oldyth') : '').'",'.
                      'oldmth: "'.(($vew_doc->getTagValue($lv_row['hhrlqdchrasgatr'],'oldmth')!='') ? $vew_doc->getTagValue($lv_row['hhrlqdchrasgatr'],'oldmth') : '').'"}';
          }
        }
        
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
		});
  </script>
</section>
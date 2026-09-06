<?php
	// campos requeridos
	$vew_input->RequiredFields( array() );
	
	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>">
	
	<div class="form-horizontal">
		<div class="container-fluid">
			<div class="row">
        <div class="card tmss-hot-ttl">
          <div class="card-header"><div class="card-title"><?= $vew_lang->mapings ?></div></div>
        </div>
        <div id="fldmaptbl" name="fldmaptbl"></div>
			</div>
		</div>
	</div>
	<script>
		// O B J E T O S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			td.style.backgroundColor = "#<?= ($vew_data->readonly?'F1F1F1':'FFFFFF'); ?>";
			Handsontable.renderers.TextRenderer.apply(this, arguments);
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];		
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #fldmaptbl")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_data->readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false, 
			rowHeaders: true,
			minSpareRows: <?= ($vew_data->readonly?'0':'1'); ?>,
			colHeaders: [ "<?= $vew_lang->ApiField; ?>", <?= $vew_data->showtech ? ' "'.$vew_lang->InternalField.'", ': '' ?> "<?= $vew_lang->Inbound; ?>", "<?= $vew_lang->Outbound; ?>", "<?= $vew_lang->required; ?>", "<?= $vew_lang->comments; ?>" ],
			columns: [
				{type: "text", data: "fldmapapifld", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_data->readonly?'readOnly: true, ':''); ?>},
        <? if($vew_data->showtech){ ?>
				{type: "text", data: "fldmapfldcod", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_data->readonly?'readOnly: true, ':''); ?>},
        <? } ?>
				{type: "dropdown", data: "fldmapin", source: ["", "X"], renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_data->readonly?'readOnly: true, ':''); ?>},
				{type: "dropdown", data: "fldmapout", source: ["", "X"], renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_data->readonly?'readOnly: true, ':''); ?>},
        {type: "dropdown", data: "fldmapreq", source: ["", "X"], renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_data->readonly?'readOnly: true, ':''); ?>},
				{type: "text", data: "fldmapcmt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_data->readonly?'readOnly: true, ':''); ?>}
			]
		};
		var <?= $lv_sec; ?>_hotdoc;
		
    function <?= $lv_sec; ?>_getData(){
      lv_dat = {};
			var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
			var lv_arr = new Array();
			for (var i=0; i<lo_dat.length; i++) {
				if ( lo_dat[i]["fldmapapifld"]!="" && lo_dat[i]["fldmapapifld"]!=undefined && lo_dat[i]["fldmapfldcod"]!="" && lo_dat[i]["fldmapfldcod"]!=undefined ){
					lv_arr.push({	"fldmapapifld":lo_dat[i]["fldmapapifld"],
												"fldmapfldcod":lo_dat[i]["fldmapfldcod"],
												"fldmapin":lo_dat[i]["fldmapin"],
												"fldmapout":lo_dat[i]["fldmapout"],
                       "fldmapreq":lo_dat[i]["fldmapreq"],
												"fldmapcmt":lo_dat[i]["fldmapcmt"]
											});
				}
			}
			lv_dat.data = lv_arr;
      return lv_dat;
    }
		
		$(function(e){ 
      tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_<?= $lv_sec; ?>_dat = [<?php
				$lv_buffer='';
				$lv_apifldmap = ( is_array($vew_data->apifldmap) ? $vew_data->apifldmap : json_decode(html_entity_decode($vew_data->apifldmap) ,true) );
				if($lv_apifldmap != ''){
					foreach($lv_apifldmap as $lv_row){ 
						$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'fldmapapifld: "'.($lv_row['fldmapapifld']??'').'",'.
												'fldmapfldcod: "'.($lv_row['fldmapfldcod']??'').'",'.
												'fldmapin: "'.strtoupper($lv_row['fldmapin']??'').'" ,'.
												'fldmapout: "'.strtoupper($lv_row['fldmapout']??'').'", '.
              					'fldmapreq: "'.strtoupper($lv_row['fldmapreq']??'').'", '.
												'fldmapcmt: "'.utf8_decode($lv_row['fldmapcmt']??'').'" '.
												'}'; 
					}
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_<?= $lv_sec; ?>_dat );
			<?= $lv_sec; ?>_hotdoc.render();
      tmssHandsontableResize();
		}); 
  });		
  </script>
</section>
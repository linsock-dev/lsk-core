<?php	
	// libreria de estilos bootstrap
	include_once('_library.frm');
	$vew_readonly = $vew_data->readonly ? true : false;
?>
<section id="<?= $lv_sec; ?>">
  <input id="apicfg" type="hidden">
  <div id="apicfgtbl" name="apicfgtbl"></div>
	<script>
		// O B J E T O S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
      if (<?= $lv_sec; ?>_hotdoc!=undefined) {
        if(prop == "apicfgalo"){
          cellProperties.readOnly = <?= $vew_readonly ? 'true' : 'false'?>;
          td.style.backgroundColor = "#<?= $vew_readonly?'F1F1F1':'FFF'; ?>";
          Handsontable.renderers.DropdownRenderer.apply(this, arguments);
        } else if ( prop=="icn2" ) {
          var lv_btn = "<a href='#' onclick='<?= $lv_sec; ?>_showMapField("+row+");' class='btn btn-default btn-sm'><span class='fas fa-ellipsis-h'></span></a>";
          $(td).empty().append(lv_btn);
          td.style.backgroundColor = "#F1F1F1";
        } else {
        	td.style.backgroundColor = "#F1F1F1";
        	Handsontable.renderers.TextRenderer.apply(this, arguments);
        }
      }
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];		
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #apicfgtbl")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			autoWrapRow: false, 
			rowHeaders: true,
			minSpareRows: 0,
      colHeaders: [ "<?= $vew_lang->enabled; ?>", "<?= $vew_lang->apimethod; ?>", "<?= $vew_lang->variant; ?>", "<?= $vew_lang->model; ?>", "<?= $vew_lang->modelmethod; ?>", "<?= $vew_lang->fields; ?>" ],
			columns: [
				{type: "dropdown", data: "apicfgalo", source: ["", "Habilitado"], renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_data->readonly?', readOnly: true ':''); ?>},
				{type: "text", data: "sysappapimapmth", renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true},
				{type: "text", data: "sysappapimapvar", renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true},
				{type: "text", data: "sysappapimapmdl", renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true},
				{type: "text", data: "sysappapimapmdlmth", renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true},
				{type: "text", data: "icn2", renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true }
      ]
		};
		var <?= $lv_sec; ?>_hotdoc;
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_<?= $lv_sec; ?>_dat = [<?php
				$lv_buffer='';

        foreach($vew_data->apidef as $lv_rowdef){
          $lv_allow = '0';
          if(is_array($vew_data->apipry)){
            $methodCount = count($vew_data->apidef);
            if ($methodCount == 1) {  $lv_allow='1';  }
            foreach($vew_data->apipry as $lv_rowmap){
              if($lv_rowdef['sysappapimapmth']==$lv_rowmap['sysappapimapmth'] && $lv_rowdef['sysappapimapvar']==$lv_rowmap['sysappapimapvar']){
                $lv_allow = isset($lv_rowmap['apicfgalo']) ? $lv_rowmap['apicfgalo'] : $lv_allow;
                break;
              }
            }
          }
        
          $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                      'apicfgalo: "'.($lv_allow == '1'? $vew_lang->enabled : "").'",'.
                      'sysappapimapcod: "'.$lv_rowdef['sysappapimapcod'].'",'.
                      'sysappapimapmth: "'.$lv_rowdef['sysappapimapmth'].'" ,'.
                      'sysappapimapvar: "'.$lv_rowdef['sysappapimapvar'].'", '.
                      'sysappapimapmdl: "'.$lv_rowdef['sysappapimapmdl'].'", '.
                      'sysappapimapmdlmth: "'.$lv_rowdef['sysappapimapmdlmth'].'" '.
                      (!empty($lv_rowdef['sysappapimapfldmap']) ? ', sysappapimapfldmap: `'.json_encode($lv_rowdef['sysappapimapfldmap']).'`' : '').
                      '}'; 
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_<?= $lv_sec; ?>_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});

    function <?= $lv_sec; ?>_getData(){
      lv_dat = {};
			var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
			var lv_arr = new Array();
			for (var i=0; i<lo_dat.length; i++) {
				lv_arr.push({	"apicfgalo":lo_dat[i]["apicfgalo"] ? "1" : "0",
												"sysappapimapcod":lo_dat[i]["sysappapimapcod"],
												"sysappapimapmth":lo_dat[i]["sysappapimapmth"],
												"sysappapimapvar":lo_dat[i]["sysappapimapvar"],
                       	"sysappapimapmdl":lo_dat[i]["sysappapimapmdl"],
												"sysappapimapmdlmth":lo_dat[i]["sysappapimapmdlmth"]
											});
			}
			lv_dat.data = lv_arr;
      return lv_dat;
    }
		
		$(function(e){ tmssHandsontableResize(); });		 
    
		function <?= $lv_sec; ?>_showMapField( lv_row ) {
      var lv_post = [{name: "sysappapimapfldmap", value: <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row,"sysappapimapfldmap")}
    								, {name: "readonly", value: true}];
      tmssCallProcess("?prg=sysappapi&act=fldmap", lv_post, function(data){
        BootstrapDialog.show({
          title: "Mapeo de campos",
          message: $(data),
          draggable: true,
          closable: true,
          size: BootstrapDialog.SIZE_WIDE
        });
      });
		}
  </script>
</section>
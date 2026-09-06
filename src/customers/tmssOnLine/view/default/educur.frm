<?php		
	// url del formulario 
  $lv_lnk = '?prg=educur&prm_educurcod='.$vew_data->educurcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('educurtxt','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->educurcod;

	// titulo 
	$lv_title = $vew_lang->curriculum;
	
	// módulo y programa 
	$lv_mdlcod = 'EDU';
	$lv_prgcod = 'CUR';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<textarea name="educurpln" id="educurpln" class="hidden"></textarea>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong> <?= $vew_data->educurcod; ?><?= gethtml( 'educurcod' , 'hidden', $vew_data->educurcod ); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
						<div class="col-md-6">
						
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->curriculum; ?></div></div>   
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('educurcodext', 'doccodext',  $vew_data->educurcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('educurtxt', 	 'doccmt1x50', $vew_data->educurtxt, 		$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 			 'docsts',		 $vew_data->docsts, 			$lv_default) ));
                  ?>                  
                </div>
              </div> <!-- card -->
							
            </div>
          </div>
					
					<div id="educurplnhot" name="educurplnhot"></div>

    		</div> <!-- /tab-pane -->        
			</div> <!-- /tab-content -->
		</div> <!-- /container-fluid -->

  </form>
	<script>
		// M A T E R I A S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #educurplnhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Carrera", "Curso", "Materia" ],
			columns: [
				{type: "autocomplete", data: "educartxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "?prg=educar&act=18", dataType: "json", data: { prm_educartxt: query },
							success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.educartxt);
                process(items);
              },
              error: function () { process([]); <?= $lv_sec; ?>_autocompleteCache = []; }
						});
					},
					strict: true
				},
				{type: "autocomplete", data: "educoutxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "?prg=educou&act=18", dataType: "json", data: { prm_educoutxt: query },
							success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.educoutxt);
                process(items);
              },
              error: function () { process([]); <?= $lv_sec; ?>_autocompleteCache = []; }
						});
					},
					strict: true
				},
				{type: "autocomplete", data: "edusubtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "?prg=edusub&act=18", dataType: "json", data: { prm_edusubtxt: query },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="//script"){ eval(jqXHR.responseText); }},
							success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.edusubtxt);
                process(items);
              },
              error: function () { process([]); <?= $lv_sec; ?>_autocompleteCache = []; }
						});
					},
					strict: true
				}
			],
      afterChange: function(changes, source) {
        if (changes && changes.length > 0 && source === 'edit') {
          const row = changes[0][0];
          const valueSelected = changes[0][3] || "";

          if(changes[0][1] === "educartxt") {
            if (valueSelected === "") {
            	<?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "educarcod", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.educartxt === valueSelected);
              if(selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "educarcod", selectedItem.educarcod);
              else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          }
          if(changes[0][1] === "educoutxt") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "educoucod", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.educoutxt === valueSelected);
              if(selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "educoucod", selectedItem.educoucod);
              else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          }
          if(changes[0][1] === "edusubtxt") {
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "edusubcod", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.edusubtxt === valueSelected);
              if(selectedItem) <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "edusubcod", selectedItem.edusubcod);
              else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          }
        }
      },
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["educurplncod"]!="" && lv_dat[i]["educurplncod"]!=undefined ) {
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
				foreach($vew_data->educurpln as $lv_row){ 
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'educurplncod:"'.$lv_row['educurplncod'].'",'.
												'educurcod:"'.$lv_row['educurcod'].'",'.
												'educurtxt:"'.$lv_row['educurtxt'].'",'.
												'educarcod:"'.$lv_row['educarcod'].'",'.
												'educartxt:"'.$lv_row['educartxt'].'",'.
												'educoucod:"'.$lv_row['educoucod'].'",'.
												'educoutxt:"'.$lv_row['educoutxt'].'",'.
												'edusubcod:"'.$lv_row['edusubcod'].'",'.
												'edusubtxt:"'.$lv_row['edusubtxt'].'"}'; 
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
  <script>
    // form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      // al grabar
			if ( lp_prm["action"]=="00" ) {
        if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
        
      	// Obtiene datos de HOT
        var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
        var lv_arr = new Array;
        
        for (var i=0; i<lo_dat.length-1 ; i++) {
          if (lo_dat[i]["educarcod"]!="" && lo_dat[i]["educarcod"]!=undefined && lo_dat[i]["educoucod"]!="" && lo_dat[i]["educoucod"]!=undefined && lo_dat[i]["edusubcod"]!="" && lo_dat[i]["edusubcod"]!=undefined){
            lv_arr.push({"educurplncod":lo_dat[i]["educurplncod"],     					 
                         "educartxt":lo_dat[i]["educartxt"], 
                         "educarcod":lo_dat[i]["educarcod"],
                         "educoutxt":lo_dat[i]["educoutxt"],
                         "edusubtxt":lo_dat[i]["edusubtxt"], 
                         "educoucod":lo_dat[i]["educoucod"],                      
                         "edusubcod":lo_dat[i]["edusubcod"]
                         });
       	 }else{
           toastr.warning("complete los datos de la fila " + (i+1));
					 return false;
         }
        }  
        
        for (var i=0; i< <?= $lv_sec; ?>_hotdocdel.length ; i++){
          lv_arr.push({"educurplncod":<?= $lv_sec; ?>_hotdocdel[i]["educurplncod"],   						 
                       "deleted":"X"
                       });
        }
        
        if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #educurpln").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #educurpln").prop("value", JSON.stringify( lv_arr ) );
				}
      }    
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
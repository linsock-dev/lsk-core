<?php
	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>">
	<div class="form-horizontal">
		<div class="container-fluid">
			<div class="row">
        <?php
        
        	// si no se hace una copia del array, no se puede modificar
          $opnsrv = $vew_data->opnsrv;

          // foreach para identificar y actualizar las filas nuevas y marcar cuáles son las viejas que hay que eliminar
          foreach( $opnsrv as $key => $lv_row ){
            if($lv_row['refobjtyp'] == 'SLS_SVL'){
              $lv_rowid = $lv_row['refobjcod002'];
              foreach ($opnsrv as $key2 => $lv_row2){
                if ($lv_row2['slssvclqddoccod'] == $lv_rowid){
                  $opnsrv[$key]['refobjtyp'] = $lv_row2['refobjtyp'];
                  $opnsrv[$key]['stkobjtyp'] = $lv_row2['stkobjtyp'];
                  $opnsrv[$key]['matcod'] = $lv_row2['matcod'];
                  $opnsrv[$key]['oldrefobjcod'] = $lv_row['slssvclqddoccod'];
                  $opnsrv[$key]['oldrefobjcod'] = $lv_row['slssvclqddoccod'];
                  $opnsrv[$key]['refobjcod001'] = $lv_row2['refobjcod001'];
                  $opnsrv[$key]['daysold'] = $lv_row2['slssvclqddocday'];
                  $opnsrv[$key]['oldrefobjcod002'] = $lv_row['refobjcod002'];
                  $opnsrv[$key]['slssvclqddoccodext'] = $lv_row2['slssvclqddoccodext'];
                  $opnsrv[$key]['aju'] = "X";
                  unset($opnsrv[$key2]);
                  break;
                }
              }
            }
          }
        
          foreach($opnsrv as $lv_row){
            $lv_qty = (isset($lv_row['matqty']) && $lv_row['matqty']!="" && $lv_row['matqty']? $lv_row['matqty'] : (isset($lv_row['slssvclqddocqty']) ? $lv_row['slssvclqddocqty']: 1) );
              echo '<input name="itmlst" class="hidden"'.
                    'data-slssvclqddoccod="'.$lv_row['slssvclqddoccod'].'" '.
                    'data-stkobjtyp="'.$lv_row['stkobjtyp'].'" '.
                    'data-stkobjcod="'.$lv_row['stkobjcod'].'" '.
                    'data-stkcntcod="'.$lv_row['stkcntcod'].'" '.
                    'data-refobjtyp="'.$lv_row['refobjtyp'].'" '.
                    'data-refobjcod001="'.$lv_row['refobjcod001'].'" '.
                    'data-refobjcod002="'.$lv_row['refobjcod002'].'" '.
                    'data-refobjgrpcod="'.$lv_row['stkobjcod'].'" '.
                    'data-stkobjtxt="'.$lv_row['stkobjtxt'].'" '.
                    'data-refobjsubgrpcod="'.$lv_row['stkcntcod'].'" '.
                    'data-refobjsubgrptxt="'.$lv_row['stkcnttxt'].'" '.
                    'data-matcod="'.$lv_row['matcod'].'" '.
                    'data-mattxt="'.$lv_row['mattxt'].'" '.
                    'data-stkmovdocdtecnv="'.$vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'stkmovdocdtecnv').'"'.
                    'data-refobjtyptxt="'.$vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'refobjtyptxt').'"'.
                    'data-matqty="'.$lv_qty.'" '. 
                    'data-matday="'.(isset($lv_row['days']) && $lv_row['days']!=0 ? $lv_row['days'] : (isset($lv_row['slssvclqddocday']) ? $lv_row['slssvclqddocday'] : '')).'" '.
                		'data-matdayold="'.(isset($lv_row['daysold']) ? $lv_row['daysold'] : (isset($lv_row['days']) && $lv_row['days']!=0 ? $lv_row['days'] : (isset($lv_row['slssvclqddocday']) ? $lv_row['slssvclqddocday'] : '') ) ).'" '.
                    'data-matprc="'.(isset($lv_row['slssvclqddocprc']) ? $lv_row['slssvclqddocprc'] : (isset($lv_row['svcmatprc']) ? $lv_row['svcmatprc'] : '') ).'"'.
                		'data-oldrefobjcod="'.(isset($lv_row['oldrefobjcod']) ? $lv_row['oldrefobjcod'] : '').'" '.
                		'data-oldrefobjcod002="'.(isset($lv_row['oldrefobjcod002']) ? $lv_row['oldrefobjcod002'] : '').'" '.
                		'data-aju="'.(isset($lv_row['aju']) ? $lv_row['aju'] : '').'" '.
                		($vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'strdte') != '' ? 'data-matstrdte="'.$vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'strdte').'"' : '' ).
                		($vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'enddte') != '' ? 'data-matenddte="'.$vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'enddte').'"' : '' ).
                		($vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'mtv') != '' ? 'data-matmtv="'.$vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'mtv').'"' : '' ).
                    'data-cteusr="'.(isset($lv_row['cteusr']) ? $lv_row['cteusr'] : '').'" '.
                    'data-ctedte="'.($lv_row['ctedte']!='' ? date_format($lv_row['ctedte'], 'd-m-Y h:i:s') : '').'" '.
                    'data-updusr="'.(isset($lv_row['updusr']) ? $lv_row['updusr'] : '').'" '.
                    'data-upddte="'.($lv_row['upddte']!='' ? date_format($lv_row['upddte'], 'd-m-Y h:i:s') : '').'" '.
                
                    ($lv_row['slssvclqddoccod']!=''?' checked ':'').
                    '>';
          }
        ?>
				<div id="slssvclqdhot"></div>
			</div>
		</div>
	</div>
  <script>
    var lv_readonlyarr = [];
    var lv_chngarr = new Array();
    var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
				if ( prop=="matqty" || prop=="matdays" || prop=="matcod" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);			
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				} else if (prop=="mattxt" || prop=="matref" || prop=="matmtv"){
					Handsontable.renderers.TextRenderer.apply(this, arguments);
          cellProperties.readOnly = true;
          td.style.backgroundColor = "#F1F1F1";
          if (prop=="matmtv" && lv_readonlyarr.includes(row)){
            cellProperties.readOnly = false;
          	td.style.backgroundColor = "#FFFFFF";
          }
        } else if (prop=="matstrdte" || prop=="matenddte"){
					Handsontable.renderers.DateRenderer.apply(this, arguments);
          td.style.backgroundColor = "FFFFFF";
        }else if ( prop=="icn" ) {
					var lv_btn = "<a href='#' onclick='<?= $lv_sec; ?>_showDetails("+row+");' class='btn btn-default btn-sm'><span class='fas fa-ellipsis-h'></span></a>";
					$(td).empty().append(lv_btn);
					td.style.backgroundColor = "#F1F1F1";
				}
			}
		};

    var <?= $lv_sec; ?>_hotdoclqd = $("#<?= $lv_sec; ?> #slssvclqdhot")[0];
    
    function datevalidator(value, callback) {
      if(moment(value, "DD-MM-YYYY").diff(moment("<?= $vew_data->slssvclqdstrdte; ?>", "DD-MM-YYYY"),"days") >= 0  && moment("<?= $vew_data->slssvclqdenddte; ?>", "DD-MM-YYYY").diff(moment(value, "DD-MM-YYYY"),"days") >= 0){
        callback(true); 
      }else{
        callback(false); 
      }
    }
    
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: 0,
			colHeaders: [ "ID","<?= $vew_lang->name; ?>", "<?= $vew_lang->reference; ?>", "<?= $vew_lang->startdate; ?>", "<?= $vew_lang->enddate; ?>", "<?= $vew_lang->quantity; ?>", "<?= $vew_lang->days; ?>", "<?= $vew_lang->motive; ?>", ""],
			columns: [
        { type: "numeric", data: "matcod", numericFormat: {pattern: "0", culture: "es-AR"}, width: 7, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
        { type: "text", data: "mattxt", width: 65, renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true},
        { type: "text", data: "matref", width: 85, renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true },
        {	type: "date", data: "matstrdte", width: 20, dateFormat: 'DD/MM/YYYY', correctFormat: true, renderer: <?= $lv_sec; ?>_hotdoc_renderer, validator: "datevalidator"},
        { type: "date", data: "matenddte", width: 20, dateFormat: 'DD/MM/YYYY', correctFormat: true, renderer: <?= $lv_sec; ?>_hotdoc_renderer, validator: "datevalidator"},
        { type: "numeric", data: "matqty", numericFormat: {pattern: "0", culture: "es-AR"}, width: 10, renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true},
				{ type: "numeric", data: "matdays", numericFormat: {pattern: "0", culture: "es-AR"}, width: 13, renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true},
        { type: "text", data: "matmtv", width: 55, renderer: <?= $lv_sec; ?>_hotdoc_renderer},
        {type: "text", data: "icn", width: 10, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true }
			],
      afterValidate: function( isValid, value, row, prop, source) {
        // Después de validar que la fecha esté dentro del rango, valida que la fecha de inicio no sea posterior a la de fin
        if (isValid){
        	if (prop=="matenddte"){
            if (<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"matstrdte")!=""){
              return (moment(value, "DD-MM-YYYY").diff( moment(<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"matstrdte"), "DD-MM-YYYY"),"days") < 0 ? false : true);
            }
          }else if (prop=="matstrdte"){
						if (<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"matenddte")!=""){
              return (moment(<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"matenddte"), "DD-MM-YYYY").diff( moment(value, "DD-MM-YYYY"),"days") < 0 ? false : true);
            }
          } 
        }
        else if (value==""){
          return true;
        }
			},
      
      afterChange: function(changes, source) {
        if (source == "loadData"){
          if(<?= $lv_sec; ?>_hotdoc!=undefined){
           	for (let i = 0; i < <?= $lv_sec; ?>_hotdoc.countRows()-1; i++) {
              if(<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(i,"matenddte").trim()!=""){
                lv_readonlyarr.push(i);
              }
            } 
          }
        }else if(changes[0][1] == "matstrdte" || changes[0][1] == "matenddte" || changes[0][1] == "matmtv" ){
          var isvalid = true;
          <?= $lv_sec; ?>_hotdoc.getCellMetaAtRow(changes[0][0]).forEach(function(lv_row) {
            if(lv_row.valid == false){
              isvalid = false;
            }
          });
          // deben estar seteadas las dos fechas y todos los campos deben ser válidos
          if (isvalid && <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matstrdte").trim()!="" && <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matenddte").trim()!="" ){
            // se calcula la cantidad de días. se recupera el signo y después los días
            lv_days = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matdays");
            lv_days = Number((lv_days.toString().substring(0,1) == "-" ? "-" : "") + moment(<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matenddte"), "DD-MM-YYYY").diff( moment(<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matstrdte"), "DD-MM-YYYY"),"days").toString());
            <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(changes[0][0],"matdays", lv_days);
            
            // se colocan los datos de la fila en el campo oculto que se va a usar para el grabado
            $("#<?= $lv_sec; ?> input[name=itmlst][data-slssvclqddoccod="+<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matcod")+"]").data("matday",lv_days );
            $("#<?= $lv_sec; ?> input[name=itmlst][data-slssvclqddoccod="+<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matcod")+"]").data("matstrdte",<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matstrdte") );
            $("#<?= $lv_sec; ?> input[name=itmlst][data-slssvclqddoccod="+<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matcod")+"]").data("matenddte",<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matenddte") );
            $("#<?= $lv_sec; ?> input[name=itmlst][data-slssvclqddoccod="+<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matcod")+"]").data("matmtv",<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matmtv") );
            if(!lv_readonlyarr.includes(changes[0][0])){
            	lv_readonlyarr.push(changes[0][0]);
            }
          }else{
            <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(changes[0][0],"matdays", $("#<?= $lv_sec; ?> input[name=itmlst][data-slssvclqddoccod="+<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matcod")+"]").data("matdayold"));
            // si no es válido, se borran los datos para que no se realice el ajuste
            $("#<?= $lv_sec; ?> input[name=itmlst][data-slssvclqddoccod="+<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matcod")+"]").data("matday", $("#<?= $lv_sec; ?> input[name=itmlst][data-slssvclqddoccod="+<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matcod")+"]").data("matdayold") );
            $("#<?= $lv_sec; ?> input[name=itmlst][data-slssvclqddoccod="+<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matcod")+"]").data("matstrdte", "");
            $("#<?= $lv_sec; ?> input[name=itmlst][data-slssvclqddoccod="+<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matcod")+"]").data("matenddte", "");
            $("#<?= $lv_sec; ?> input[name=itmlst][data-slssvclqddoccod="+<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matcod")+"]").data("matmtv", "");
            if(lv_readonlyarr.includes(changes[0][0])){
              lv_readonlyarr.splice(lv_readonlyarr.indexOf(changes[0][0]), 1);
            }
          }
        }
			},
		};
		var <?= $lv_sec; ?>_hotdoc;		
    
		// inicializo handsontable
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoclqd, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($opnsrv as $lv_row) { 
          if ($lv_row['stkcntcod'] == $vew_data->stkcntcod){
            $lv_qty = (isset($lv_row['matqty']) && $lv_row['matqty']!="" && $lv_row['matqty']? $lv_row['matqty'] : (isset($lv_row['slssvclqddocqty']) ? $lv_row['slssvclqddocqty']: 1) );
						$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
              					'matcod:"'.(isset($lv_row['slssvclqddoccod']) ? $lv_row['slssvclqddoccod'] : '').'",'.
												'mattxt:"'.(isset($lv_row['mattxt']) ? $lv_row['mattxt'] : '').'",'.
                        'matref:"'.$vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'stkmovdocdtecnv').' - '.$vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'refobjtyptxt').'" ,'.
                        'matstrdte: "'.($vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'strdte') != null ? $vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'strdte') : '').' ",'.
                        'matenddte: "'.($vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'enddte') != null ? $vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'enddte') : '').' ",'.
                        'matqty: '.$lv_qty.' ,'.
                        'matdays: '.(isset($lv_row['slssvclqddocday']) ? $lv_row['slssvclqddocday'] : '').' ,'.
          							'matmtv: "'.($vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'mtv') != null ? $vew_doc->getTagValue($lv_row['slssvclqddocatr001'], 'mtv') : '').'",}';
          } 
				}
				echo $lv_buffer;
			?>];
      
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
      Handsontable.validators.registerValidator('datevalidator', datevalidator);
		});
    
    //Esperar a que levante el popup y después renderizar
    //Con un solo renderer las columnas desplazadas con respecto a las cabeceras. Con dos funciona bien
    setTimeout(function(){
      <?= $lv_sec; ?>_hotdoc.render();
      <?= $lv_sec; ?>_hotdoc.render();
    },250);
    
    
    function <?= $lv_sec; ?>_showDetails( lv_row ) {
      lv_id = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row,"matcod");
			var lv_dat=[{"infttl":"<?= $vew_lang->createdby;?>","infdat":$("#<?= $lv_sec; ?> input[name=itmlst][data-slssvclqddoccod="+lv_id+"]").data("cteusr")},
									{"infttl":"<?= $vew_lang->createddate; ?>","infdat":$("#<?= $lv_sec; ?> input[name=itmlst][data-slssvclqddoccod="+lv_id+"]").data("ctedte")},
									{"infttl":"<?= $vew_lang->updatedby; ?>","infdat":$("#<?= $lv_sec; ?> input[name=itmlst][data-slssvclqddoccod="+lv_id+"]").data("updusr")},
									{"infttl":"<?= $vew_lang->updateddate; ?>","infdat":$("#<?= $lv_sec; ?> input[name=itmlst][data-slssvclqddoccod="+lv_id+"]").data("upddte")}];
			var lv_pstdat=[{name:"infdat",value:JSON.stringify(lv_dat)}];
			tmssPopup("Info","?prg=grlvew&act=showinfo",function(){},lv_pstdat);
		}
  </script>
</section>
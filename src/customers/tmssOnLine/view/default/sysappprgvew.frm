<?php	
	// url del formulario
  $lv_lnk = '?prg=sysappprgvew&prm_vewid='.$vew_data->vewcod;

	// campos requeridos
	$vew_input->RequiredFields( array('vewcod','vewttl','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->vewcod;

	// titulo
	$lv_title = $vew_lang->views;
	
	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'VEW';
	
	// librería de estilos bootstrap
	include_once('_library.frm');

	$lv_vewselmod = array(''=>'', '0'=>'0', '1'=>'1', 'N'=>'N');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <textarea id="sysvewcol" name="sysvewcol" class="hidden"></textarea>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->vewcod; ?> <?= gethtml('vewcod','hidden',$vew_data->vewcod); ?> </strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">		
          <div class="row">
						<div class="col-md-4">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->CONFIGURATION; ?></div></div>
                <div class="card-body tmss-card-body-edit">  
                  <?php 
                    if($vew_data->vewcod == ''){ echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 		'input'=>gethtml('vewcodnew', 'doccmt1x50', $vew_data->vewcod, $lv_default) )); }
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->title, 'input'=>gethtml('vewttl', 'doccmt1x50', $vew_data->vewttl, $lv_default) ));         			
               			echo vew_boot( array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->system,  'input'=>gethtml('vewsrcsys', 'checkbox', ($vew_data->vewsrcsys==1 ? 'on' : 'off'),  $lv_default)   ));                        
                    echo vew_boot( array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->filter,  'input'=>gethtml('vewalwflt', 'checkbox', ($vew_data->vewalwflt==1 ? 'on' : 'off'),  $lv_default)   ));          
                    echo vew_boot( array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->sort,  	'input'=>gethtml('vewalwsrt', 'checkbox', ($vew_data->vewalwsrt==1 ? 'on' : 'off'),  $lv_default)   ));                       
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->records, 'input'=>gethtml('vewdefmaxrec', 'docnum0600', $vew_data->vewdefmaxrec, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->selection,'input'=>gethtml('vewselmod', $lv_vewselmod, $vew_data->vewselmod, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
              <div class="card">
                <div class="card-header"><div class="card-title">Typeahead</div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('vewatrtypcod', 'doccmt1x50', $vew_doc->gettagvalue($vew_data->vewatr,'typcod'), $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->field, 'input'=>gethtml('vewatrtyptxt', 'doccmt1x50', $vew_doc->gettagvalue($vew_data->vewatr,'typtxt'), $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->program, 'input'=>gethtml('vewatrtypprg', 'doccmt1x250', $vew_doc->gettagvalue($vew_data->vewatr,'typprg'), $lv_default) ));
                  ?>
                </div>
              </div>
            </div>          
						<div class="col-md-8">
              <div class="card tmss-hot-ttl">
                <div class="card-header"><div class="card-title"><?= $vew_lang->columns; ?></div></div>
								<div id="sysappprgvewhot"></div>
							</div>
						</div>          
          </div>
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
				if ( prop=="vewfldord" || prop=="vewfldwth" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);			
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				} else if ( prop=="vewfldalg" ) {
					Handsontable.renderers.DropdownRenderer.apply(this, arguments);			
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
        } else if ( prop=="vewflddatpas" || prop=="vewfldflt" ) {
					Handsontable.renderers.CheckboxRenderer.apply(this, arguments);			
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				} else if (prop=="vewfld"){
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				} else if (prop=="vewfld" || prop=="vewfldttl" || prop=="sysappfld"){
					Handsontable.renderers.TextRenderer.apply(this, arguments);			
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
        }
			}
		};

		var <?= $lv_sec; ?>_hotdocdel = [];
    var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #sysappprgvewhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->name; ?>", "<?= $vew_lang->title; ?>", "<?= $vew_lang->order; ?>", "<?= $vew_lang->width; ?>", "<?= $vew_lang->align; ?>", "<?= $vew_lang->type; ?>", "<?= $vew_lang->pass; ?>", "<?= $vew_lang->filter; ?>"],
			columns: [
        { type: "text", data: "vewfld", width: 50,  renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
        { type: "text", data: "vewfldttl", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
        {	type: "numeric", data: "vewfldord", numericFormat: {pattern: "0", culture: "es-AR"}, width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
        { type: "numeric", data: "vewfldwth", numericFormat: {pattern: "0", culture: "es-AR"}, width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
        { type: "dropdown", data: "vewfldalg", source: ['Izquierda', 'Centrado', 'Derecha'], width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
				{ type: "text", data: "sysappfld", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
        { type: "checkbox", data: "vewflddatpas", width: 30, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
        { type: "checkbox", data: "vewfldflt", width: 30, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':''); ?> }
			],
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["vewfldcod"]!="" && lv_dat[i]["vewfldcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotdoc;		
    
		// cargo datos en handsontable
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->sysvewcol as $lv_row) { 
					$lv_fldalg = '';
					if( isset($lv_row['vewfldalg']) ){
						$lv_fldalg = ( $lv_row['vewfldalg']=='left' ? 'Izquierda' : 
														( $lv_row['vewfldalg']=='right' ? 'Derecha' : 
															( $lv_row['vewfldalg']=='middle' ? 'Centrado' : '' )
														)
													);
					}
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'vewfldcod:"'.($lv_row['vewfldcod'] ?? '').'",'.
												'vewfld:"'.($lv_row['vewfld'] ?? '').'",'.
                        'vewfldttl:"'.($lv_row['vewfldttl'] ?? '').'" ,'.
                        'vewfldord: '.($lv_row['vewfldord'] ?? '').' ,'.
                        'vewfldwth: '.($lv_row['vewfldwth'] ?? '').' ,'.
                        'vewfldalg: "'.$lv_fldalg.' ",'.
                        'sysappfld: "'.($lv_row['sysappfld'] ?? '').' ",'.
          							'vewflddatpas: "'.(isset($lv_row['vewflddatpas']) ? ($lv_row['vewflddatpas'] == 0 ? 'false' : 'true') : '').'",'.
                        'vewfldflt: "'.(isset($lv_row['vewfldflt']) ? ($lv_row['vewfldflt'] == 0 ? 'false' : 'true') : '').'",'.'}';
				}
				echo $lv_buffer;
			?>];
      
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();		
		});
	</script>
  
	<script>	
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
       // al grabar
			if(lp_prm["action"]=="00"){
        
				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();  
				var lv_arr = new Array();
        
        // agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"vewfldcod":<?= $lv_sec; ?>_hotdocdel[i]["vewfldcod"],
												"deleted":"X"
											});
				}
        
        lv_vewfldbuffer = "/";
				for (var i=0; i<lo_dat.length-1; i++) {
          if(lv_vewfldbuffer.indexOf("/"+lo_dat[i]["vewfld"]+"/") !== -1){
            toastr.warning("No puede ingresar nombres duplicados.");
            return false;
          }
          lv_vewfldbuffer += lo_dat[i]["vewfld"]+"/";
          if(lo_dat[i]["vewfld"] == undefined || lo_dat[i]["vewfldttl"] == undefined || lo_dat[i]["vewfldord"] == undefined || lo_dat[i]["vewfldwth"] == undefined || lo_dat[i]["vewfldalg"] == undefined){
          	toastr.warning("Complete todos los campos.");
            return false;
          }
					var vewflddatpas = (lo_dat[i]["vewflddatpas"] == true || lo_dat[i]["vewflddatpas"] == "true") ? 1 : 0;  //Pasar checkbox a número
          var vewfldflt = (lo_dat[i]["vewfldflt"] == true || lo_dat[i]["vewfldflt"] == "true") ? 1 : 0;  //Pasar checkbox a número
					if (lo_dat[i]["vewfld"]!="" && lo_dat[i]["vewfld"]!=undefined ){
						lv_arr.push({	"vewfldcod":lo_dat[i]["vewfldcod"],
													"vewfld":lo_dat[i]["vewfld"],
													"vewfldttl":lo_dat[i]["vewfldttl"],
													"vewfldord":lo_dat[i]["vewfldord"],
													"vewfldwth":lo_dat[i]["vewfldwth"],
													"vewfldalg":(lo_dat[i]["vewfldalg"].trim()=="Izquierda"?"left":(lo_dat[i]["vewfldalg"].trim()=="Derecha"?"right":(lo_dat[i]["vewfldalg"].trim()=="Centrado"?"middle":""))),
                          "sysappfld":lo_dat[i]["sysappfld"],
                          "vewflddatpas":vewflddatpas,
                          "vewfldflt":vewfldflt
												});
					}
				}

				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #sysvewcol").prop("value", "");						
				} else {
					$("#<?= $lv_sec; ?> #sysvewcol").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
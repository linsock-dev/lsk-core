<?php		
	// url del formulario
  $lv_lnk = '?prg=grlprcsch';

	// campos requeridos
	$vew_input->RequiredFields( array('prcschtxt','mdlcod','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->prcschcod; 

	// titulo
	$lv_title = $vew_lang->schema;
	 
	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'PSC';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
		
    <div class="container-fluid" role="tabpanel">    
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->prcschcod; ?><?= gethtml('prcschcod', 'hidden', $vew_data->prcschcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">  
        
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">      
						<div class="col-md-4">
            	<div class="card">
              <div class="card-header"><div class="card-title"><?= $lv_title;?></div></div>
              <div class="card-body">
                <?php
                    echo vew_boot($lv_col39, array('label'=>$vew_lang->code,  			'input'=>gethtml('prcschcodext', 'doccmt1x20', $vew_data->prcschcodext, $lv_default) )); 
                    echo vew_boot($lv_col39, array('label'=>$vew_lang->description,'input'=>gethtml('prcschtxt', 'doccmt1x50', $vew_data->prcschtxt, $lv_default) )); 
                    echo vew_boot($lv_col39, array("label"=>$vew_lang->module,			'input'=>gethtml('mdlcod', 'mdlcod', $vew_data->mdlcod, ($vew_data->mdlcod==''?$lv_default:$lv_always_disabled) ) ));
                    echo vew_boot($lv_col39, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); 
                ?>
              </div>
            </div>  
						</div>          
						<div class="col-md-8" id="prcschcnddiv">
              <div class="card tmss-hot-ttl"><div class="card-header"><div class="card-title"><?= $vew_lang->data; ?></div></div></div>
              <?= gethtml('prcschcnd', 'hidden', ''); ?>		
							<div id="prcschcndhot"></div>
						</div>            
					</div>					
				</div> <!-- /_tab001 -->
				
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		// O P E R A C I O N E S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
				var lv_ro = <?= ($vew_readonly?'true':'false'); ?>;
				var lv_ro2 = lv_ro;
				var lv_col = (lv_ro==true?"#F1F1F1":"FFFFFF");
				var lv_col2 = lv_col;
				if(<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"prccndcod")=="" || <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"prccndcod")=="0"){
					lv_ro2 = true;
					lv_col2 = "#F1F1F1";
				}

				if(prop=="prccndtxt"){
					Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
					td.style.backgroundColor = lv_col;
					cellProperties.readOnly = lv_ro;
				} else if(prop=="prccndfortxt"){
					Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
					td.style.backgroundColor = lv_col;
					cellProperties.readOnly = lv_ro;
				}else if(prop=="prccndcod"){
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
					td.style.backgroundColor = "#F1F1F1";
					cellProperties.readOnly = true;
				}else if(prop=="prcschcndrow" || prop=="prcschcndrowstr" || prop=="prcschcndrowend"){
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
					td.style.backgroundColor = lv_col;
					cellProperties.readOnly = lv_ro;
				}else if(prop=="prcschprcman"){
					Handsontable.renderers.DropdownRenderer.apply(this, arguments);
					td.style.backgroundColor = lv_col2;
					cellProperties.readOnly = lv_ro2;
				}else if(prop=="prcschcndstd"){
					Handsontable.renderers.DropdownRenderer.apply(this, arguments);
					td.style.backgroundColor = lv_col;
					cellProperties.readOnly = lv_ro;
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = lv_col2;
					cellProperties.readOnly = lv_ro2;
				}
			}
		};
		var <?= $lv_sec; ?>_hotdoctmpchg = [];
		var <?= $lv_sec; ?>_hotdoctmpdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #prcschcndhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 296,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["row_above","row_below","remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?0:1); ?>,
			colHeaders: [ "ID", "#", "Condicion", "Dde", "Hta", "Formula", "Manual", "Cuenta", "Stat" ],
			columns: [
				{type: "numeric", data: "prccndcod", renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true},
				{type: "numeric", data: "prcschcndrow", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "autocomplete", data: "prccndtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer,
					source: function (query, process) {
						$.ajax({
							url: "?prg=grlprccnd&act=18", dataType: "json", data: {	prm_mdlcod: $("#<?= $lv_sec; ?> #mdlcod").prop("value"), prm_prccndtxt: query },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
							success: function (response) {
								var lv_dat = [];
								<?= $lv_sec; ?>_hotdocchg = [];
								for (var i=0; i < response.length; i++) {
									<?= $lv_sec; ?>_hotdocchg.push( {prccndtxt: response[i]["prccndtxt"], prccndcod: response[i]["prccndcod"]} );
									lv_dat.push( response[i]["prccndtxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: false
				},
				{type: "numeric", data: "prcschcndrowstr", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "numeric", data: "prcschcndrowend", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "autocomplete", data: "prccndfortxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer,	
					source: function (query, process) {
						$.ajax({
							url: "?prg=grlprccndfor&act=18", dataType: "json", data: {prm_prccndfortxt: query },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
							success: function (response) {
								var lv_dat = [];
								<?= $lv_sec; ?>_hotdocchg = [];
								for (var i=0; i < response.length; i++) {
									<?= $lv_sec; ?>_hotdocchg.push( {prccndfortxt: response[i]["prccndfortxt"], prccndforcod: response[i]["prccndforcod"]} );
									lv_dat.push( response[i]["prccndfortxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				},
				{type: "dropdown", data: "prcschcndman", source: ['','Valor','Cantidad','Total'], renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "autocomplete", data: "finacctxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
         		source: function (query, process) {
                $.ajax({
                    url: "?prg=finacc&act=18", dataType: "json", data: {    prm_finacctxt: query },
                    complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/script/"){ eval(jqXHR.responseText); return;}},
                    success: function (response) {
                        // guardo todos los datos adicionales en una variable temporal
                        var lv_dat = [];
                        <?= $lv_sec; ?>_hotdocchg = [];
                        for (var i=0; i < response.data.length; i++) {
                            <?= $lv_sec; ?>_hotdocchg.push( {finacctxt: response.data[i]["finacctxt"], finacccod: response.data[i]["finacccod"]} );
                            lv_dat.push( response.data[i]["finacctxt"] );
                        }
                        process( lv_dat );
                    }
                });
            },
            strict: true
        },
				{type: "dropdown", data: "prcschcndstd", source: ['','X'], renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>}
			],
			beforeChange : function(changes, source) {
				var lv_value = changes[0][3];
				if(source=="edit" && changes[0][1]=="prccndtxt") {
					var lv_found = false;
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].prccndtxt == lv_value) {
							lv_found = true;
							changes.push([ changes[0][0], "prccndcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].prccndcod) ]);
						}
					}
					if(lv_found==false){
						changes.push([ changes[0][0], "prccndcod", "", "" ]);
						changes.push([ changes[0][0], "prccndforcod", "", "" ]);
						changes.push([ changes[0][0], "prccndfortxt", "", "" ]);
						changes.push([ changes[0][0], "prcschcndman", "", "" ]);
						changes.push([ changes[0][0], "finacccod", "", "" ]);
						changes.push([ changes[0][0], "finacctxt", "", "" ]);
						changes.push([ changes[0][0], "prcschcndstd", "", "" ]);
					}
				} else if(source=="edit" && changes[0][1]=="prccndfortxt") {
					if ( lv_value=="" ) {
						changes.push([ changes[0][0], "prccndforcod", "", "" ]);
					} else {
						for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
							if(<?= $lv_sec; ?>_hotdocchg[i].prccndfortxt == lv_value) {
								changes.push([ changes[0][0], "prccndforcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].prccndforcod) ]);
							}
						}
					}
				}else if(source=="edit" && changes[0][1]=="finacctxt") {
          for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
              if(<?= $lv_sec; ?>_hotdocchg[i].finacctxt == lv_value) {
                  changes.push([ changes[0][0], "finacccod", "", String(<?= $lv_sec; ?>_hotdocchg[i].finacccod) ]);
              }
          }
        }
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["prcschcndcod"]!="" && lv_dat[i]["prcschcndcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdoctmpdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotdoc;
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [<?php
				$lv_buffer = '';
				foreach( $vew_data->prcschcnd as $lv_row) {
					$lv_buffer .= ($lv_buffer==''?'':', ').'{prcschcndcod: "'.$lv_row['prcschcndcod'].'", prccndcod:"'.$lv_row['prccndcod'].'", prccndtxt:"'.($lv_row['prccndcod']=='0'?$lv_row['prccndttl']:$lv_row['prccndtxt']).'", prcschcndrow:"'.$lv_row['prcschcndrow'].'", prcschcndrowstr:"'.$lv_row['prcschcndrowstr'].'", prcschcndrowend:"'.$lv_row['prcschcndrowend'].'", prccndforcod:"'.$lv_row['prccndforcod'].'", prccndfortxt:"'.$lv_row['prccndfortxt'].'", prcschcndman:"'.($lv_row['prcschcndman']=='VAL'?'Valor':($lv_row['prcschcndman']=='TOT'?'Total':($lv_row['prcschcndman']=='CAN'?'Cantidad' : ''))).'", finacccod:"'.$lv_row['finacccod'].'", finacctxt:"'.$lv_row['finacctxt'].'", prcschcndstd:"'.$lv_row['prcschcndstd'].'"}';
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
				
				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdoctmpdel.length; i++) {
					lv_arr.push({	"prcschcndcod":<?= $lv_sec; ?>_hotdoctmpdel[i]["prcschcndcod"],
												"deleted":"X"
											});
				}
				// agrego filas insertadas/actualizadas
				for (var i=0; i<lo_dat.length; i++) {
					if( (lo_dat[i]["prccndcod"]!="" && lo_dat[i]["prccndcod"]!=undefined) ||
							(lo_dat[i]["prccndtxt"]!="" && lo_dat[i]["prccndtxt"]!=undefined) ){
						lv_arr.push({	"prcschcndcod":lo_dat[i]["prcschcndcod"],
													"prccndcod":lo_dat[i]["prccndcod"],
													"prccndtxt":lo_dat[i]["prccndtxt"],
													"prcschcndrow":lo_dat[i]["prcschcndrow"],
													"prcschcndrowstr":lo_dat[i]["prcschcndrowstr"],
													"prcschcndrowend":lo_dat[i]["prcschcndrowend"],
													"prccndforcod":lo_dat[i]["prccndforcod"],
													"prcschcndman":lo_dat[i]["prcschcndman"],
													"finacccod":lo_dat[i]["finacccod"],
													"prcschcndstd":lo_dat[i]["prcschcndstd"],
													"docsts":"A"
												});
					}
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #prcschcnd").val("");						
				} else {
					$("#<?= $lv_sec; ?> #prcschcnd").val( JSON.stringify( lv_arr ) );
				}
			}
		}
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
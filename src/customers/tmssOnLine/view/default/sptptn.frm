<?php
	// url del formulario
  $lv_lnk = '?prg=sptptn&prm_ptncod='.$vew_data->ptncod;

	// campos requeridos
	$vew_input->RequiredFields( array('ptntxt','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->ptncod; 
 
	// titulo
	$lv_title = $vew_lang->partners;
	
	// m�dulo y programa
	$lv_mdlcod = 'SPT';
	$lv_prgcod = 'PTN';

	// librer�a de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
		<textarea class="form-control hidden" id="ptnact" name="ptnact"></textarea>
		
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
				<?php if ($vew_data->ptncod!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','**') ) { ?>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab005" role="tab" data-toggle="tab"><?= $vew_lang->contact; ?></a></li>
				<?php } ?>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab006" role="tab" data-toggle="tab"><?= $vew_lang->profile; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->ptncod; ?><?= gethtml('ptncod','hidden',$vew_data->ptncod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
            <div class="col-md-5">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $lv_title; ?>
                  	<span class="tmss-card-icon">  
                  		<span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                  	</span>
                    <?= gethtml('sysdocclstxt','hidden',$vew_data->sysdoccls->sysdocclstxt); ?>
                    <?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                    <?php
                  		echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('ptncodext', 'doccod', $vew_data->ptncodext, $lv_always_disabled) )); 
                  		echo vew_boot($lv_col210, array('label'=>$vew_lang->firstname, 'input'=>gethtml('ptntxt', 'doccmt1x50', $vew_data->ptntxt, $lv_default) ));
                  		echo vew_boot($lv_col210, array('label'=>$vew_lang->registration,	'input'=>gethtml('ptninbdte', 'docdte', $vew_data->ptninbdte, $lv_default) )); 
                  		echo vew_boot($lv_col210, array('label'=>$vew_lang->category,
                                            'input1'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly),
                                                               array('input'=>gethtml('ptncattxt', 'typeahead', $vew_data->ptncattxt, $lv_default)))
                                                     ));
											echo gethtml('ptncatcod','hidden',$vew_data->ptncatcod);
                  		echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); 
                    ?>
                </div>
              </div>
						</div>
						<div class="col-md-5"><?php include('grldatper.frm');?></div>
						<div class="col-md-2"><?php	include('grldatuplshwpth.frm'); ?></div>
					</div>					
					<!-- DIRECCION / CONTACTO --> 
					<div class="row">
						<div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
						<div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
					</div>
				</div> <!-- fin tab001 -->
				
				<!-- IMPUESTOS / BANCOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
					<div class="row">
						<div class="col-md-6"><?php include('grldattax.frm'); ?></div>
						<div class="col-md-6"><?php include('grldatbnk.frm'); ?></div>
					</div>
				</div>
				
				<!-- CONTACTOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab005">
          <?php include('grldatcntlst.frm'); ?>
				</div>

				<!-- PERFIL -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab006">
          <div class="row">
            <div class="col-md-6">
						
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->activities; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                	<div id="ptnacthot" name="ptnacthot"></div>
                  <textarea class="hidden" id="ptnact" name="ptnact"></textarea>
                </div>
              </div>
							
            </div>
            <div class="col-md-6">
						
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->tariffs; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                	<div id="ptntrfhot" name="ptntrfhot"></div>
                  <textarea class="hidden" id="ptntrf" name="ptntrf"></textarea>
                </div>
              </div>
							
            </div> <!-- /col -->
          </div> <!-- /row -->
        </div> <!-- /tab-pane -->
			</div> <!-- /tab-content -->    
		</div> <!-- /container-fluid -->
  </form>
	<script>
    var lo_get = {"fldsec": "<?= $lv_sec; ?>" ,"fldasg": {"ptncatcod":"ptncatcod", "ptncattxt":"ptncattxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #ptncattxt"), "sptptncat", lo_get);

    //INFO adicional
		$(function(e){
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab006']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
		});
	</script>
	<script>
		/* A C T I V I D A D E S */
		var <?= $lv_sec; ?>_hotact_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if ( prop=='acttxt' ) {
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			} else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			}
		};
		var <?= $lv_sec; ?>_hotacttmpchg = [];
		var <?= $lv_sec; ?>_hotacttmpdel = [];
		var <?= $lv_sec; ?>_hotactcnt = $("#<?= $lv_sec; ?> #ptnacthot")[0];
		var <?= $lv_sec; ?>_hotactset = {
			height: 146,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Actividad", "Cantidad", "Tipo", "Identificacion"],
			columns: [
				{type: "autocomplete", width: 25, data: "acttxt", renderer: <?= $lv_sec; ?>_hotact_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "?prg=sptact&act=17", dataType: "json", data: {	prm_acttxt: query },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); return;}},
							success: function (response) {
								// guardo todos los datos adicionales en una variable temporal
								var lv_dat = [];
								<?= $lv_sec; ?>_hotacttmpchg = [];
								for (var i=0; i < response.data.length; i++) {
									<?= $lv_sec; ?>_hotacttmpchg.push( {acttxt: response.data[i]["acttxt"], actcod: response.data[i]["actcod"]} );
									lv_dat.push( response.data[i]["acttxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				},
        {type: "numeric", data: "actqty", width: 25, numericFormat:{ pattern: "0", culture: "es-AR" }, 		allowEmpty: true, renderer: <?= $lv_sec; ?>_hotact_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
				{type: "text", data: "acttyp", width: 25, renderer: <?= $lv_sec; ?>_hotact_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> }, 
      	{type: "text", data: "actidt", width: 25, renderer: <?= $lv_sec; ?>_hotact_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> }  
      ],
			beforeChange : function(changes, source) {
				// asigno los datos adicionales a la fila
				if(source=="edit" && changes[0][1]=="acttxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotacttmpchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotacttmpchg[i].acttxt == lv_value) {
							changes.push([ changes[0][0], "actcod", "", String(<?= $lv_sec; ?>_hotacttmpchg[i].actcod) ]);
						}
					}
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotact.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]['ptnactcod']!='' && lv_dat[i]['ptnactcod']!=undefined ) {
						<?= $lv_sec; ?>_hotacttmpdel.push( lv_dat[i]['ptnactcod'] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotact;	
		
		// cargo datos en handsontable de áreas
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotact = new Handsontable(<?= $lv_sec; ?>_hotactcnt, <?= $lv_sec; ?>_hotactset);
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->sptptnact as $lv_row){
          $ejemplo = ($vew_doc->getTagValue($lv_row['ptnactatr'],'qty'));
          
          $lv_buffer .= ($lv_buffer!=''?',':'').'{
          						ptnactcod:"'.$lv_row['ptnactcod'].'",
                      ptncod:"'.$lv_row['ptncod'].'",
                      acttxt:"'.$lv_row['acttxt'].'",
                      actqty:"'.( ($vew_doc->getTagValue($lv_row['ptnactatr'],'qty') !== 'UNDEFINED') ? $vew_doc->getTagValue($lv_row['ptnactatr'],'qty'):'').'", 
                      acttyp:"'.( ($vew_doc->getTagValue($lv_row['ptnactatr'],'typ') !== 'UNDEFINED') ? $vew_doc->getTagValue($lv_row['ptnactatr'],'typ'):'').'",
                      actidt:"'.( ($vew_doc->getTagValue($lv_row['ptnactatr'],'idt') !== 'UNDEFINED') ? $vew_doc->getTagValue($lv_row['ptnactatr'],'idt'):'').'",
                      actcod:"'.$lv_row['actcod'].'"}';
        }
        echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotact.loadData( lv_dat );
			<?= $lv_sec; ?>_hotact.render();
		});
	</script>
	<script>    
		/* A R A N C E L E S */
		var <?= $lv_sec; ?>_hottrf_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if ( prop=='spttrftxt' ) {
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			} else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			}
		};
		var <?= $lv_sec; ?>_hottrftmpchg = [];
		var <?= $lv_sec; ?>_hottrftmpdel = [];
		var <?= $lv_sec; ?>_hottrfcnt = $("#<?= $lv_sec; ?> #ptntrfhot")[0];
		var <?= $lv_sec; ?>_hottrfset = {
			height: 146,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Arancel" ],
			columns: [
				{type: "autocomplete", data: "spttrftxt", renderer: <?= $lv_sec; ?>_hottrf_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "?prg=spttrf&act=18", dataType: "json", data: {	prm_spttrftxt: query },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); return;}},
							success: function (response) {
								// guardo todos los datos adicionales en una variable temporal
								var lv_dat = [];
								<?= $lv_sec; ?>_hottrftmpchg = [];
								for (var i=0; i < response.length; i++) {
									<?= $lv_sec; ?>_hottrftmpchg.push( {spttrftxt: response[i]["spttrftxt"], spttrfcod: response[i]["spttrfcod"]} );
									lv_dat.push( response[i]["spttrftxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				}
			],
			beforeChange : function(changes, source) {
				// asigno los datos adicionales a la fila
				if(source=="edit" && changes[0][1]=="spttrftxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hottrftmpchg.length ; i++) {
						if(<?= $lv_sec; ?>_hottrftmpchg[i].spttrftxt == lv_value) {
							changes.push([ changes[0][0], "spttrfcod", "", String(<?= $lv_sec; ?>_hottrftmpchg[i].spttrfcod) ]);
						}
					}
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hottrf.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]['ptntrfcod']!='' && lv_dat[i]['ptntrfcod']!=undefined ) {
						<?= $lv_sec; ?>_hottrftmpdel.push( lv_dat[i]['ptntrfcod'] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hottrf;
    
    // cargo datos en handsontable de áreas
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hottrf = new Handsontable(<?= $lv_sec; ?>_hottrfcnt, <?= $lv_sec; ?>_hottrfset);
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->sptptntrf as $lv_row){
          $lv_buffer .= ($lv_buffer!=''?',':'').'{
          						ptntrfcod:"'.$lv_row['ptntrfcod'].'",
                      spttrfcod:"'.$lv_row['spttrfcod'].'",
                      spttrftxt:"'.$lv_row['spttrftxt'].'"}';
        }
        echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hottrf.loadData( lv_dat );
			<?= $lv_sec; ?>_hottrf.render();
		});
	</script>
	<script>
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adrwebpge")) ) { return false; }
				// obtengo datos de handsontable de Areas-Perfil-Actividades
				var lo_dat_act = <?= $lv_sec; ?>_hotact.getSourceData();
				var lv_arr_act = new Array();
        var lv_arr = new Array();
				for (var i=0; i<lo_dat_act.length; i++) {
					if (lo_dat_act[i]["actcod"]!="" && lo_dat_act[i]["actcod"]!=undefined ){
                                                                                  
          	lv_arr += "<row>"+"<qty>"+lo_dat_act[i]["actqty"]+"</qty>"+"<typ>"+lo_dat_act[i]["acttyp"]+"</typ>"+"<idt>"+lo_dat_act[i]["actidt"]+"</idt><deleted>"+""+"</deleted></row>";
					
						lv_arr_act.push({	"ptnactcod":lo_dat_act[i]["ptnactcod"],
                         	"ptncod":lo_dat_act[i]["ptncod"],
													"actcod":lo_dat_act[i]["actcod"],
													"acttxt":lo_dat_act[i]["acttxt"],
                          "ptnactatr":lv_arr
												});
          }
          lv_arr=[];
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotacttmpdel.length; i++) {
					lv_arr_act.push({	"ptnactcod":<?= $lv_sec; ?>_hotacttmpdel[i], "deleted":"X" });
				}
        
				if (lv_arr_act.length==0) {
					$("#<?= $lv_sec; ?> #ptnact").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #ptnact").prop("value", JSON.stringify( lv_arr_act ) );
				}
        
				
        // obtengo datos de handsontable de Areas-Perfil-Aranceles
				var lo_dat_trf = <?= $lv_sec; ?>_hottrf.getSourceData();
				var lv_arr_trf = new Array();
				for (var i=0; i<lo_dat_trf.length; i++) {
					if (lo_dat_trf[i]["spttrfcod"]!="" && lo_dat_trf[i]["spttrfcod"]!=undefined ){
						lv_arr_trf.push({	"ptntrfcod":lo_dat_trf[i]["ptntrfcod"],
                        "ptncod":lo_dat_trf[i]["ptncod"],
												"spttrfcod":lo_dat_trf[i]["spttrfcod"],
												"spttrftxt":lo_dat_trf[i]["spttrftxt"]
						});
					}

				}

				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hottrftmpdel.length; i++) {
					lv_arr_trf.push({	"ptntrfcod":<?= $lv_sec; ?>_hottrftmpdel[i],  "deleted":"X" });
				}
        
				if (lv_arr_trf.length==0) {
					$("#<?= $lv_sec; ?> #ptntrf").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #ptntrf").prop("value", JSON.stringify( lv_arr_trf ) );
				}
			}
		}
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
<?php
	// url del formulario 
  $lv_lnk = "?prg=hltprs&prm_prscod=".$vew_data->prscod;

	// campos requeridos 
	$vew_input->RequiredFields( array('prstxt','docsts','lndcod') );

	// clave del documento 
	$lv_dockey = $vew_data->prscod; 

	// titulo 
	$lv_title = $vew_lang->provider;
	
	// módulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PRS';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
 
	// Botones por Vista */
	$vew_tbl['tmeL'] = array('pos'=>'L', 'per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'), 'id'=>'btntme', 'ttl'=>$vew_lang->schedule, 'icn'=>'fas fa-clock', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn','acc'=>'');
	$vew_tbl['tmeR'] = array('pos'=>'R', 'per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'), 'id'=>'btntme', 'ttl'=>$vew_lang->schedule, 'icn'=>'fas fa-clock', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn','acc'=>'');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!--navbar-->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
		
		<div class="form-group  tmss-form-group"><textarea class="form-control hidden" id="prsspc" name="prsspc"></textarea></div>

    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
				<?php if ($vew_data->prscod!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','**') ) { ?>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab005" role="tab" data-toggle="tab"><?= $vew_lang->contact; ?></a></li>
				<?php } ?>
        <li role="presentation" class="hidden-xs"><a href="#<?= $lv_sec; ?>_tab006" role="tab" data-toggle="tab"><?= $vew_lang->profile; ?></a></li>
        <li role="presentation" class="hidden-xs"><a href="#<?= $lv_sec; ?>_tab007" role="tab" data-toggle="tab"><?= $vew_lang->categorisation; ?></a></li>
        <li role="presentation" class="dropdown hidden-sm hidden-lg hidden-md">
          <a id="drpprs" href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
          	<span class="fas fa-ellipsis-v"></span>
          </a>
          <ul id="drpmnuprs" class="dropdown-menu dropdown-menu-right" aria-labelledby="dLabel">
            <li role="presentation"><a href="#<?= $lv_sec; ?>_tab006" role="tab" data-toggle="tab"><?= $vew_lang->profile; ?></a></li>
            <li role="presentation"><a href="#<?= $lv_sec; ?>_tab007" role="tab" data-toggle="tab"><?= $vew_lang->categorisation; ?></a></li>
          </ul>
        </li>
        <li class="pull-right"><h4># <strong><?= $vew_data->prscod; echo gethtml('prscod', 'hidden', $vew_data->prscod) ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
            <div class="col-md-10">
              <div class="row">
                <div class="col-md-6"> 
                  <!-- PRESTADOR -->
                  <div class="card"> 
                    <div class="card-header">
                      <div class="card-title">
                        <?= $vew_lang->provider; ?>
                        <span class="tmss-card-icon">
                          <?php if ( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'32') && $vew_readonly){ ?>
                            <a href="#" id="btnsysdocclschg" class="cursor:pointer"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></a>
                          <?php } else { ?>
                            <span><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                          <?php } ?>
                          <i class="fas fa-user"></i>
                        </span>
                        <?php 
                          echo gethtml('sysdocclstxt', 'hidden', $vew_data->sysdoccls->sysdocclstxt);
                          echo gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);
                        ?>
                      </div>
                    </div>    
                    <div class="card-body tmss-card-body-edit">
                      <?php
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->code,					'input'=>gethtml('prscodext', 'doccod', $vew_data->prscodext, $lv_default) ));
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->lastname, 'input'=>gethtml('adrlstnme','adrlstnme',$vew_data->adr->adrlstnme,$lv_default) )); 
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->firstname,'input'=>gethtml('adrfrtnme','adrfrtnme',$vew_data->adr->adrfrtnme,$lv_default) )); 
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->nik,         'input'=>gethtml('prsniknme','doccmt1x50',$vew_data->prsniknme,$lv_default) )); 
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 			'input'=>gethtml('docsts',   'docsts', 	 $vew_data->docsts,$lv_default) )); 
                      ?>
                    </div>
                  </div> <!-- card -->
                </div> <!-- col -->
                <!-- FECHAS -->
                <div class="col-md-6">
                  <div class="card">
                    <div class="card-header">
                      <div class="card-title">
                        <?= $vew_lang->data; ?>
                        <span class="tmss-card-icon">
                          <i class="fas fa-calendar-day"></i>
                        </span>
                      </div>
                    </div>    

                    <div class="card-body tmss-card-body-edit">
                      <?php
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->entrance,	'input'=>gethtml('prsinbdte','docdte', $vew_data->prsinbdte,$lv_default) )); 
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->debit,   	'input'=>gethtml('prsoutdte','docdte', $vew_data->prsoutdte,$lv_default) ));
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->contacthours,'input'=>gethtml('prscnthrs','doccmt1x50',$vew_data->prscnthrs,$lv_default) )); 
                      ?>
                    </div>
                  </div> <!-- card -->
                </div><!-- col -->
              </div><!--1er row-->

              <!-- DIRECCION / CONTACTO --> 
              <div class="row">
                <div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
                <div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
              </div><!--2do row-->

              <div class="row">
                <div class="col-md-6"><?php include('grldatper.frm'); ?></div>
              </div><!--3er row-->
            </div>
            <div class="col-md-2"><?php include('grldatuplshwpth.frm'); ?></div>
          </div>
				</div> <!-- fin tab001 -->
				
				<!-- IMPUESTOS / BANCOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
					<div class="row">
						<div class="col-md-6">
							<?php include('grldattax.frm'); ?>
						</div>
						<div class="col-md-6">
							<?php include('grldatbnk.frm'); ?>
						</div>
					</div>
				</div>
				
				<!-- CONTACTOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab005">
          <?php include('grldatcntlst.frm'); ?>
				</div>

				<!-- PERFIL -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab006">
					<div class="col-md-6">
						<div id="prsspchot" name="prsspchot"></div>
					</div>
					<div class="col-md-6">
            <div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $vew_lang->profile; ?>
										<span class="tmss-card-icon">
                      <i class="fas fa-user-md"></i>
                    </span>
									</div>
								</div>    
                
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array("label"=>$vew_lang->titlegrantedby,'input'=>gethtml('prsttl','doccmt1x40',$vew_data->prsttl,$lv_default) ));
                    echo vew_boot($lv_col210, array("label"=>$vew_lang->otherstudies,  'input'=>gethtml('prsothstd','doccmt80x4',$vew_data->prsothstd,$lv_default) ));
                    echo vew_boot($lv_col210, array("label"=>$vew_lang->jobhistory,    'input'=>gethtml('prsjobhst','doccmt80x4',$vew_data->prsjobhst,$lv_default) ));
                    echo vew_boot(array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->printable,   'input'=>gethtml('prsprn',   'checkbox', 	$vew_data->prsprn,$lv_default) )); 
                  ?>
              </div>
            </div> <!-- card -->
					</div> <!-- col-md-6 -->
				</div>

				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab007">
					<div class="row">
          	<div class="col-md-6">				
        			<!-- CATEGORIZACIÓN -->
            	<div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $vew_lang->categorisation; ?>
										<span class="tmss-card-icon">
                      <i class="fas fa-file-invoice-dollar"></i>
                    </span>
									</div>
								</div>    
                
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->points,   'input'=>gethtml('prscatpts','docnum',$vew_data->prscatpts,$lv_always_disabled) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->seniority,'input'=>gethtml('prsjobpts','docnum',$vew_data->prsjobpts,$lv_always_disabled) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->pricelist,
                                            "input1"=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                array('input'=>gethtml('prccndtxt', 'typeahead', $vew_data->prccndtxt, $lv_default) ))));
                    echo gethtml('prccndcod', 'hidden', $vew_data->prccndcod);
                  ?> 
                </div> 
              </div> <!-- card -->
            </div> <!-- col-md-6 -->
					</div>
					<div class="col-md-6">&nbsp;</div>
          <br>
          <div id="prscathot" name="prscathot"></div>
          <textarea class="hidden" id="prscat" name="prscat"></textarea>
				</div>

			</div> <!-- tabcontent -->    
		</div> <!-- container-fluid -->
  </form>
	<script>
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"pcc.prccndcatcodext":"PRS_VAL_CAT", "pc.docsts":"A"}, "fldasg":{"prccndcod":"prccndcod", "prccndtxt":"prccndtxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #prccndtxt"), "grlprccnd", lo_get)    
  </script>
	<script> 
     // CAMBIAR CLASE DE DOCUMENTO
		$("#<?= $lv_sec; ?> #btnsysdocclschg").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm("¿ Desea cambiar la clase de documento ?", function(result){
         if(result) { 
					var lv_pstdat = [{name:"prscod",value:$("#<?= $lv_sec; ?> #prscod").prop("value")},
													{name:"callback", value:"<?= $lv_sec; ?>_sysdoccls_callback"}];
					tmssLink("?prg=hltprs&act=33", [{target: "_new_section", target_id: "#<?= $lv_sec; ?>", post_data: lv_pstdat}]);
				}
      });
		});
    
    function <?= $lv_sec; ?>_sysdoccls_callback(){
			<?= $lv_sec; ?>_fnc({action: '99'});
		}
  </script>
	<script>    
		//	E S P E C I A L I D A D E S 
		var <?= $lv_sec; ?>_hotspc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if ( prop=='spctxt' ) {
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			} else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			}
		};
		var <?= $lv_sec; ?>_hotspctmpdel = [];
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotspccnt = $("#<?= $lv_sec; ?> #prsspchot")[0];
		var <?= $lv_sec; ?>_hotspcset = {
			height: 146,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Especialidad", "MN", "MP" ],
			columns: [
				{type: "autocomplete", data: "spctxt", renderer: <?= $lv_sec; ?>_hotspc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
						$.ajax({
							url: "index.php?prg=hltspc&act=18", dataType: "json", data: {	prm_spctxt: query },
							success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.spctxt);
                process(items);
              },
              error: function () {
                <?= $lv_sec; ?>_autocompleteCache = [];
                process([]);
              }
						});
					},
					strict: true
				},
				{type: "text", data: "mn", width: 20 , renderer: <?= $lv_sec; ?>_hotspc_renderer <?= ($vew_readonly?', readOnly: true':'');	?> },
				{type: "text", data: "mp", width: 20 , renderer: <?= $lv_sec; ?>_hotspc_renderer <?= ($vew_readonly?', readOnly: true':'');	?> }
			],
      afterChange: function(changes, source) {
        if (changes && changes.length > 0) {
          const row = changes[0][0];
          const valueSelected = changes[0][3] || "";
          if( changes[0][1]=="spctxt"){
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotspc.setDataAtRowProp(row, "spccod", "");
            } else {
            const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.spctxt === valueSelected);
            if (selectedItem) <?= $lv_sec; ?>_hotspc.setDataAtRowProp(row, "spccod", selectedItem.spccod);
          	else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          }
        }
      },
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotspc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]['prsspccod']!='' && lv_dat[i]['prsspccod']!=undefined ) {
						<?= $lv_sec; ?>_hotspctmpdel.push( lv_dat[i] );
					}
				}
			},
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotspc;	

		// cargo datos en handsontable de Especialidades
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotspc = new Handsontable(<?= $lv_sec; ?>_hotspccnt, <?= $lv_sec; ?>_hotspcset);	
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->prsspc as $lv_row){ $lv_buffer .= ($lv_buffer!=''?',':'').'{prsspccod:"'.$lv_row['prsspccod'].'", spccod:"'.$lv_row['spccod'].'", spctxt:"'.$lv_row['spctxt'].'", mn:"'.$vew_doc->getTagValue($lv_row['prsspcatr'],'mn').'", mp:"'.$vew_doc->getTagValue($lv_row['prsspcatr'],'mp').'"}'; }
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotspc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotspc.render();
		});
	</script>
  <script>
  	function <?= $lv_sec; ?>_getValValues( lp_frm, lp_to, lp_ptr ) {
      var valarr = [];
      
      // hay patrón
      if(lp_ptr != ""){
        valarr = lp_ptr.split('-');
      }else{
        // desde y hasta no son 0
        if(lp_to != 0){
          for(var i = lp_frm; i <= lp_to; i++){
            valarr.push(i);
          }
        // desde y hasta son 0
        } else {
          valarr = [0];
        }
      }
      
      return valarr;
    }
  </script>
  <script>
    //	C A T E G O R Í A S 

    var <?= $lv_sec; ?>_hotcat_renderer = function (instance, td, row, col, prop, value, cellProperties) {	
      if (<?= $lv_sec; ?>_hotcat != undefined) {
        var lv_ro = <?=($vew_readonly?'true':'false'); ?>;
        if( prop=="hltcattxt" ){
          Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
          td.style.backgroundColor = "#"+(lv_ro?"F1F1F1":"FFFFFF");
        } else if( prop=="hltcatval" ){
          Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
          td.style.backgroundColor = "#"+(lv_ro?"F1F1F1":(<?= $lv_sec; ?>_hotcat.getDataAtRowProp(row, "hltcattxt")?"FFFFFF":"F1F1F1"));
          cellProperties.readOnly = (lv_ro?true:(<?= $lv_sec; ?>_hotcat.getDataAtRowProp(row, "hltcattxt")?false:true));
        } else {
          td.style.backgroundColor = "#"+(lv_ro?"F1F1F1":(<?= $lv_sec; ?>_hotcat.getDataAtRowProp(row, "hltcatval")?"FFFFFF":"F1F1F1"));
          cellProperties.readOnly = (lv_ro?true:(<?= $lv_sec; ?>_hotcat.getDataAtRowProp(row, "hltcatval")?false:true));
          if ( prop=="hltcatstrdtecnv" || prop=="hltcatenddtecnv") {
            Handsontable.renderers.DateRenderer.apply(this, arguments);
          } else if( prop=="hltcatasgval" ){
            Handsontable.renderers.DropdownRenderer.apply(this, arguments);
          } else if ( prop=="hltcatasgpts" ) {
            td.style.backgroundColor = "#F1F1F1";
            cellProperties.readOnly = true;
            Handsontable.renderers.NumericRenderer.apply(this, arguments);
          }
        }
      }
    };
		
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotvalsource = [];
		var <?= $lv_sec; ?>_hotcatdel = [];
		var <?= $lv_sec; ?>_hotcatcnt = $("#<?= $lv_sec; ?> #prscathot")[0];
		var <?= $lv_sec; ?>_hotcatset = {
			height: 370,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->Group; ?>","<?= $vew_lang->Category; ?>","<?= $vew_lang->From; ?>","<?= $vew_lang->To; ?>","<?= $vew_lang->Value; ?>","<?= $vew_lang->Points; ?>" ],
			columns: [
         {type: "autocomplete", data: "hltcattxt", width: 50 ,renderer: <?= $lv_sec; ?>_hotcat_renderer, <?= ($vew_readonly?' readOnly: true, ':''); ?>
					source (query, process) {
						if(!<?= $lv_sec; ?>_hot_paste){
              $.ajax({
                url: "?prg=hltcat&act=18", dataType: "json", data: {	prm_hltcattxt: query },
                success: function (response) {
                  <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                  
                  var lv_dat = [];
                  var lv_simpleRepeated = [];
                  var lv_srcLength = <?= $lv_sec; ?>_hotcat.getSourceData().length;
                  for (var i=0; i < <?= $lv_sec; ?>_autocompleteCache.length; i++) {
                    for(var j=0; j < lv_srcLength; j++){
											if(<?= $lv_sec; ?>_hotcat.getDataAtRowProp( j, "hltcatcod" ) == <?= $lv_sec; ?>_autocompleteCache[i]["hltcatcod"] && <?= $lv_sec; ?>_hotcat.getDataAtRowProp( j, "hltcattyp" ) == '1' && j != <?= $lv_sec; ?>_hotcat.getSelected()[0][0]){
												lv_simpleRepeated.push(<?= $lv_sec; ?>_autocompleteCache[i]["hltcatcod"]);
                      }
                    }
                    if(!lv_simpleRepeated.includes(<?= $lv_sec; ?>_autocompleteCache[i]["hltcatcod"])){
                      lv_dat.push( <?= $lv_sec; ?>_autocompleteCache[i]["hltcattxt"] );
                    }
                  }
                  process( lv_dat );
                },
                error: function() {
                  <?= $lv_sec; ?>_autocompleteCache = [];
                  process([]);
                }
              });
            } else {
              process( [query] );
              <?= $lv_sec; ?>_hot_paste = false;
            }
					},
					strict: true
				},
        {type: "autocomplete", data: "hltcatval", width: 50 ,renderer: <?= $lv_sec; ?>_hotcat_renderer, <?= ($vew_readonly?' readOnly: true, ':''); ?>
					source (query, process) {
						$.ajax({
              url: "?prg=hltcat&act=28", dataType: "json", data: {	prm_hltcatval: query, prm_hltcatcod: <?= $lv_sec; ?>_hotcat.getDataAtRowProp( this.row, "hltcatcod" ) },
							success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.hltcatval);
                process(items);
              },
              error: function () {
                <?= $lv_sec; ?>_autocompleteCache = [];
                process([]);
              }
						});
					},
					strict: true
				},
        {type: "date", data: "hltcatstrdtecnv", width: 20, renderer: <?= $lv_sec; ?>_hotcat_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, 
					dateFormat: 'DD/MM/YYYY',
					correctFormat: true,
					allowEmpty: false,
					datePickerConfig: {
						firstDay: 0,
						showWeekNumber: false,
						numberOfMonths: 1
					}
				},
				{type: "date", data: "hltcatenddtecnv", width: 20, renderer: <?= $lv_sec; ?>_hotcat_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, 
					dateFormat: 'DD/MM/YYYY',
					correctFormat: true,
					allowEmpty: false,
					datePickerConfig: {
						firstDay: 0,
						showWeekNumber: false,
						numberOfMonths: 1
					}
				},
        {type: "dropdown", data: "hltcatasgval", width: 10, source: <?= $lv_sec; ?>_hotvalsource[this.row], renderer: <?= $lv_sec; ?>_hotcat_renderer <?= ($vew_readonly?', readOnly: true ':''); ?>},
        {type: "numeric", data: "hltcatasgpts", width: 10, renderer: <?= $lv_sec; ?>_hotcat_renderer, <?= ($vew_readonly?' readOnly: true,':'');	?> numericFormat: {pattern: "0", culture: "es-AR"} }
      ],
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotcat.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["hltprscatcod"]!="" && lv_dat[i]["hltprscatcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotcatdel.push( lv_dat[i] );
					}
				}
			},
      afterRemoveRow: function(index, amount, logicalRows) {
        <?= $lv_sec; ?>_calcScore();
      },
      afterChange: function(changes, source){
        if (<?= $lv_sec; ?>_hotcat == undefined) { return; }
        
        if (source == "loadData") {
          for (var i = 0; i < <?= $lv_sec; ?>_hotvalsource.length; i++) {
            <?= $lv_sec; ?>_hotcat.setCellMeta(i, <?= $lv_sec; ?>_hotcat.propToCol("hltcatasgval"), 'source', <?= $lv_sec; ?>_hotvalsource[i]);
					}
        }
        
        if (source === 'autocomplete' || source === 'calc') { 
          var pts_changed = changes.some(change => change[1] === 'hltcatasgpts');
          if (pts_changed) {
            <?= $lv_sec; ?>_calcScore();
          }
          return;
        }
        
        if (source == "edit") {
          const row = changes[0][0];
          const valueSelected = changes[0][3];

          if (changes[0][1] === "hltcattxt") {
            const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.hltcattxt === valueSelected);
            if (selectedItem) {
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatcod", selectedItem.hltcatcod, "autocomplete");
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcattyp", selectedItem.hltcattyp, "autocomplete");
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatval", "", "autocomplete");
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatvalcod", "", "autocomplete");
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatfrm", "", "autocomplete");
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatto", "", "autocomplete");
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatptr", "", "autocomplete");
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatpts", "", "autocomplete");
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatasgval", "", "autocomplete");
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatasgpts", "", "autocomplete");

              <?= $lv_sec; ?>_hot_paste = true;
            }
          }

          else if (changes[0][1] === "hltcatval") {
            const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.hltcatval === valueSelected);
            if (selectedItem) {
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatvalcod", String(selectedItem.hltcatvalcod), "autocomplete");
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatfrm", String(selectedItem.hltcatfrm), "autocomplete");
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatto", String(selectedItem.hltcatto), "autocomplete");
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatptr", String(selectedItem.hltcatptr), "autocomplete");
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatpts", String(selectedItem.hltcatpts), "autocomplete");

              <?= $lv_sec; ?>_hotcat.setCellMeta(row, <?= $lv_sec; ?>_hotcat.propToCol("hltcatasgval"), "source",
                                                <?= $lv_sec; ?>_getValValues( parseInt(selectedItem.hltcatfrm),
                                                                              parseInt(selectedItem.hltcatto),
                                                                              selectedItem.hltcatptr
                                                                            ));
              <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatasgval", "", "autocomplete");
            }
          }

          else if (changes[0][1] === "hltcatasgval") {
            const pts = <?= $lv_sec; ?>_hotcat.getDataAtRowProp(row, "hltcatpts");
            const value = parseFloat(changes[0][3] || 0);
            <?= $lv_sec; ?>_hotcat.setDataAtRowProp(row, "hltcatasgpts", (value === 0 ? 1 : value) * pts, "calc");
            <?= $lv_sec; ?>_calcScore();
          }

          else if (source === "paste" && changes[0][1] === "hltcatasgpts") {
            <?= $lv_sec; ?>_calcScore();
          }
        }
      },
    	licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotcat;
		
    tmssLoadScript("handsontable16",function(){
      <?= $lv_sec; ?>_hotcat = new Handsontable(<?= $lv_sec; ?>_hotcatcnt, <?= $lv_sec; ?>_hotcatset);			
			var sumpts = 0;
      var lv_dat = [<?php
				$lv_buffer = '';
        if($vew_data->prscat != ''){
          foreach( $vew_data->prscat as $lv_row) {
            $lv_buffer .= ($lv_buffer==''?'':', ').'{'.
                          'prscod:\''.$lv_row['prscod'].'\', '.
                          'hltprscatcod:\''.$lv_row['hltprscatcod'].'\','.
                          'hltcatcod:\''.$lv_row['hltcatcod'].'\','.
                          'hltcattxt:\''.$lv_row['hltcattxt'].'\','.
              						'hltcattyp:\''.$lv_row['hltcattyp'].'\','.
                          'hltcatvalcod:\''.$lv_row['hltcatvalcod'].'\','.
                          'hltcatval:\''.$lv_row['hltcatval'].'\','.
                          'hltcatfrm:\''.$lv_row['hltcatfrm'].'\','.
              						'hltcatto:\''.$lv_row['hltcatto'].'\', '.
                          'hltcatptr:\''.$lv_row['hltcatptr'].'\','.
                          'hltcatpts:\''.$lv_row['hltcatpts'].'\','.
                          'hltcatstrdtecnv:\''.$lv_row['hltcatstrdtecnv'].'\','.
                          'hltcatenddtecnv:\''.$lv_row['hltcatenddtecnv'].'\','.
                          'hltcatasgval:\''.$lv_row['hltcatasgval'].'\','.
                          'hltcatasgpts:\''.$lv_row['hltcatasgpts'].'\''.
                      '}';
          }
        }
				echo $lv_buffer;
			?>];
      // calculo valores para valor dropdown
      for(var i = 0; i < lv_dat.length; i++){
      	<?= $lv_sec; ?>_hotvalsource.push(<?= $lv_sec; ?>_getValValues(parseInt(lv_dat[i]["hltcatfrm"] ),
                                                                            parseInt(lv_dat[i]["hltcatto"] ),
                                                                            lv_dat[i]["hltcatptr"] ));
      }
      
			<?= $lv_sec; ?>_hotcat.loadData( lv_dat );
			<?= $lv_sec; ?>_hotcat.render();
		});
  </script>
  <script>
    // CÁLCULO DE PUNTAJE TOTAL
    function <?= $lv_sec; ?>_calcScore(){
      var lv_rowqty = <?= $lv_sec; ?>_hotcat.countRows();
      var lv_tot = 0;
      for(let i=0; i<lv_rowqty; i++){
        if(<?= $lv_sec; ?>_hotcat.getDataAtRowProp(i, "hltcatasgpts") != undefined && <?= $lv_sec; ?>_hotcat.getDataAtRowProp(i, "hltcatasgpts") != ""){
          lv_tot += parseInt(<?= $lv_sec; ?>_hotcat.getDataAtRowProp(i, "hltcatasgpts"));
        }
      }

      $("#<?= $lv_sec; ?> #prscatpts").val(lv_tot);
    }
  </script>
	<script>    
		$("#<?= $lv_sec; ?> #btntme").on("click",function(e){ e.preventDefault();
			var lv_pstdat = [{name:"prscod", value:"<?= $vew_data->prscod; ?>"}];
			tmssCallProcess("?prg=hltspctme&act=03",lv_pstdat,function(data){
				BootstrapDialog.show({
					size: BootstrapDialog.SIZE_WIDE,
					title: "<?= $vew_lang->schedule; ?>",
					closable: false,
					draggable: true,
					message: $(data),
					buttons: [{ label: "Cerrar", cssClass: "btn-default", action: function(dialogRef){ dialogRef.close(); } }]
				});
			});
		});
		
		$(function(e){
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab006'], a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab007']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
		});
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
      // al grabar
			if ( lp_prm["action"]=="00" ) {
				//if ( !tmssFieldValidation($('#<?= $lv_sec; ?> #adreml')) ) { return false; }
				if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adrwebpge")) ) { return false; }

				// obtengo datos de handsontable de Especialidades
				var lo_dat = <?= $lv_sec; ?>_hotspc.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if (lo_dat[i]["spccod"]!="" && lo_dat[i]["spccod"]!=undefined ){
						lv_arr.push({	"prsspccod":lo_dat[i]["prsspccod"],
													"spccod":lo_dat[i]["spccod"],
													"spctxt":lo_dat[i]["spctxt"],
													"mn":lo_dat[i]["mn"],
													"mp":lo_dat[i]["mp"]
												});
					}
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotspctmpdel.length; i++) {
					lv_arr.push({	"prsspccod":<?= $lv_sec; ?>_hotspctmpdel[i]["prsspccod"],
												"spccod": <?= $lv_sec; ?>_hotspctmpdel[i]["spccod"],
												"spctxt":<?= $lv_sec; ?>_hotspctmpdel[i]["spctxt"],
												"mn":<?= $lv_sec; ?>_hotspctmpdel[i]["mn"],
												"mp":<?= $lv_sec; ?>_hotspctmpdel[i]["mp"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #prsspc").prop("value", "");						
				} else {
					$("#<?= $lv_sec; ?> #prsspc").prop("value", JSON.stringify( lv_arr ) );
				}
        
        // obtengo datos de handsontable de Categorías
				lo_dat = <?= $lv_sec; ?>_hotcat.getSourceData();
				lv_arr.length = 0;
				for (var i=0; i<lo_dat.length-1; i++) {
          if(lo_dat[i]["hltcatcod"] == undefined || lo_dat[i]["hltcatvalcod"] == undefined || lo_dat[i]["hltcatstrdtecnv"] == undefined || lo_dat[i]["hltcatenddtecnv"] == undefined || lo_dat[i]["hltcatasgval"] == undefined || lo_dat[i]["hltcatasgpts"] == undefined){
          	toastr.warning("Complete todos los campos.");
            return false;
          }
          
					if (lo_dat[i]["hltcatcod"]!="" && lo_dat[i]["hltcatcod"]!=undefined ){
						lv_arr.push({	"hltprscatcod":lo_dat[i]["hltprscatcod"],
													"hltcatcod":lo_dat[i]["hltcatcod"],
													"hltcatvalcod":lo_dat[i]["hltcatvalcod"],
													"hltcatval":lo_dat[i]["hltcatasgval"],
              						"hltcatstrdte":lo_dat[i]["hltcatstrdtecnv"],
													"hltcatenddte":lo_dat[i]["hltcatenddtecnv"]
												});
					}
				}
        
				// agrego las filas eliminadas
				for (var i=0; i < <?= $lv_sec; ?>_hotcatdel.length; i++) {
					lv_arr.push({	"prscod": $("#<?= $lv_sec; ?> #prscod"),
												"hltprscatcod": <?= $lv_sec; ?>_hotcatdel[i]["hltprscatcod"],
												"deleted":"X"
											});
				}
        
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #prscat").prop("value", "");						
				} else {
					$("#<?= $lv_sec; ?> #prscat").prop("value", JSON.stringify( lv_arr ) );
				}
			}
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
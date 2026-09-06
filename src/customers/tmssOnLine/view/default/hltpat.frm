<?php   
	// url del formulario 
  $lv_lnk = '?prg=hltpat&prm_patcod='.$vew_data->patcod;
 
	// campos requeridos
	//$vew_input->RequiredFields( array('adrlstnme','adrfrtnme','patreqdte','docsts','lndcod','cuscod') );
	$lv_reqflddef = array('adrlstnme','adrfrtnme','docsts','custxt','cuscod');
	$lv_reqfldusrtxt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'sysdocclsreqfld');
	$lv_reqfldusr = ($lv_reqfldusrtxt!=''?explode(';',$lv_reqfldusrtxt):array());
	$vew_input->setReqFields( array_merge($lv_reqflddef,$lv_reqfldusr) );
	
	// clave del documento
	$lv_dockey = $vew_data->patcod; 

	// titulo
	$lv_title = $vew_lang->patient;
	
	// modulo y programa
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PAT';
	
	// libreria de estilos bootstrap
	include_once('_library.frm');
	
	// auto estado (se basa en las fechas)
	$lv_autostatus = (strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'auto_status'))=='X'?true:false);	
	$lv_confirmduplicate = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'confirmDuplicate');
	if ( $vew_data->patcod=='' && $lv_autostatus ) {
		$vew_data->docsts = 'N';
	}
	
	$lv_infbox = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'zcuinfbox');

	// botones por vista
	$vew_tbl['sveR'] = array('id'=>'btnsve', 'acc'=>'');
  $vew_tbl['sveL'] = array('id'=>'btnsve', 'acc'=>'');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
		<?= gethtml('pattxt','hidden',$vew_data->pattxt); ?>
    
    <textarea class="hidden" id="patatrval002" name="patatrval002"><?= html_entity_decode(htmlspecialchars_decode(strtolower($vew_data->patatrval002),ENT_QUOTES)); ?></textarea>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
				<?php if ($vew_data->patcod!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','**') ) { ?>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab005" role="tab" data-toggle="tab"><?= $vew_lang->contact; ?></a></li>
				<?php } ?>
				<li role="presentation" class="hidden-xs"><a href="#<?= $lv_sec; ?>_tab006" role="tab" data-toggle="tab"><?= $vew_lang->evaluation; ?></a></li>
				<li role="presentation" class="hidden-xs"><a href="#<?= $lv_sec; ?>_tab004" role="tab" data-toggle="tab"><?= $vew_lang->planning; ?></a></li>
        <li role="presentation" class="dropdown hidden-sm hidden-lg hidden-md">
          <a id="drpprs" href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
          	<span class="fas fa-ellipsis-v"></span>
          </a>
          <ul id="drpmnuprs" class="dropdown-menu dropdown-menu-right" aria-labelledby="dLabel">
            <li role="presentation"><a href="#<?= $lv_sec; ?>_tab006" role="tab" data-toggle="tab"><?= $vew_lang->evaluation; ?></a></li>
            <li role="presentation"><a href="#<?= $lv_sec; ?>_tab004" role="tab" data-toggle="tab"><?= $vew_lang->planning; ?></a></li>
          </ul>
        </li> 
				<li class="pull-right"><h4># <strong><?= $vew_data->patcod; ?><?= gethtml('patcod', 'hidden', $vew_data->patcod) ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="<?= ( $lv_infbox != '' ? 'col-md-10' : 'col-md-12' ); ?>">
							<div class="row">
								<div class="col-md-6">
                  <div class="card">
                    <div class="card-header">
                      <div class="card-title">
                        <?= $vew_lang->patient; ?>
                        <span class="tmss-card-icon">
                          <?php if ( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'32') && $vew_readonly) { ?>
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
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->code,			'input'=>gethtml('patcodext','doccmt1x20', 	$vew_data->patcodext,	$lv_default) )); 
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->lastname, 'input'=>gethtml('adrlstnme','adrlstnme',$vew_data->adr->adrlstnme,$lv_default) )); 
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->firstname,'input'=>gethtml('adrfrtnme','adrfrtnme',$vew_data->adr->adrfrtnme,$lv_default) )); 
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->protocol, 'input'=>gethtml('patpro',	'doccmt1x20',$vew_data->patpro,		$lv_default) )); 
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->status,   'input'=>gethtml('docsts',   	($lv_autostatus?'hltpatdocsts':'hltpatdocsts'), $vew_data->docsts, $lv_default) ));
                      ?>
                    </div>
                  </div>
								</div>
								<div class="col-md-6">
                  <div class="card">
                    <div class="card-header"><div class="card-title"><?= $vew_lang->data; ?></div></div>
                    <div class="card-body tmss-card-body-edit">
                      <?php 
                      
                      	// INICIO - CAMBIO FINANCIADOR
                      	// EN CREACION (vewdata->patcod=='') USAR TYPEAHEAD y BUSQUEDA de CLIENTES
                      	//             al grabar, buscar un interlocutor destinatario de factura y asociarle el cliente financiador
                      	// EN MODIFICACION/VISUALIZACION (si tiene permisos para modificar), CAMBIAR ICONO POR SYNC Y BUSCAR CONTACTOS DE TIPO DE DESTINATARIO DE FACTURA.
                      	if($vew_data->patcod == ''){
                        	echo vew_boot($lv_col210, array('label'=>$vew_lang->financial, 'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('custxt', 'typeahead', $vew_data->custxt, $lv_default) )) ));
                        }else{
                          echo vew_boot($lv_col210, array('label'=>$vew_lang->financial,
                                                          'input1'=>vew_boot(	array('style'=>'custom', 'readonly'=>$vew_readonly),
                                                                              array('custom'=>'<span class="input-group-btn hidden"><a href="#" class="btn btn-default tmssInputBtn" tabindex="-1"><i class="far fa-rotate"></i></a></span>',
                                                                                    'input'=>gethtml('custxt', 'custxt', $vew_data->custxt, $lv_always_disabled) )) ));                          
                        }
                        // FIN - CAMBIO FINANCIADOR
                      	echo gethtml('cuscod', 'hidden', $vew_data->cuscod);
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->request,  	'input'=>gethtml('patreqdte',	'docdte',	$vew_data->patreqdte,	$lv_default) ));  
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->evaluation,	'input'=>gethtml('patevldte',	'docdte',	$vew_data->patevldte,	$lv_default) ));  
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->inbound,  	'input'=>gethtml('patinbdte',	'docdte',	$vew_data->patinbdte,	$lv_default) ));  
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->outbound, 	'input'=>gethtml('patoutdte',	'docdte',	$vew_data->patoutdte,	$lv_default) ));
                      ?>
                    </div>
                  </div>
								</div>
							</div><!--1er row-->
              
              <!-- DIRECCION / CONTACTO -->
							<div class="row">
                <div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
								<div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
							</div><!--2do row-->
              
              <div class="row"><div class="col-md-6"><?php include('grldatper.frm'); ?></div></div><!--3er row-->
						</div>
            <?php if ($lv_infbox!='') { ?><div class="col-md-2"><div id="zcuinfbox"></div></div><?php } ?>
					</div> <!-- /row -->
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
				
				<!-- EVALUACION -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab006">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->diseaseclassification; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->diseaseclassification, 'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('hltdisclstxt', 'typeahead', $vew_data->hltdisclstxt, $lv_default) )) ));
                    echo gethtml('hltdisclscod', 'hidden', $vew_data->hltdisclscod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->diagnosticcode, 'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('patdiatxt', 'doccmt1x50', $vew_data->patdiatxt, $lv_default) )) ));
                    echo gethtml('patdiacod', 'hidden', $vew_data->patdiacod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->cronicity, 'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('patcrotxt', 'doccmt1x50', $vew_data->patcrotxt, $lv_default) )) ));
                    echo gethtml('patcrocod', 'hidden', $vew_data->patcrocod);
                   	echo vew_boot($lv_col210, array('label'=>$vew_lang->COMPLEXITY, 'input'=>gethtml('patcpx',	array(''=>'', 'A'=>'ALTA', 'M'=>'MEDIA', 'B'=>'BAJA'),	$vew_data->patcpx,	$lv_default) ));
                    echo gethtml('hltpatclscod', 'hidden', $vew_data->hltpatclscod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->PATIENTSCLASSIFICATION, 'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('hltpatclstxt', 'doccmt1x50', $vew_data->hltpatclstxt, $lv_default) )) ));
                  ?>
                </div>
              </div>
						</div>
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->evaluation; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->date,  'input'=>gethtml('evldte', 'docdte', $vew_data->evldte, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->place,  'input'=>gethtml('evlplc', 'evlplc', $vew_data->evlplc, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->diagnostic,  'input'=>gethtml('evldia', 'evldia', $vew_data->evldia, $lv_default) ));
                  	echo '<hr>';
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->weight.' (kg)',  'input'=>gethtml('patwgt', 'docnum0603', $vew_data->patwgt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->height.' (cm)',  'input'=>gethtml('pathgh', 'docnum0603', $vew_data->pathgh, $lv_default) ));
                  ?>
                </div>
              </div>
						</div>
					</div>
				</div>

				<!-- PLANIFICACION -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab004">
					<div class="row">
						<div class="col-md-8">
              <div class="card">
                <div class="card-header"><div class="card-title">Roles</div></div>
                <div class="card-body tmss-card-body-edit">
                  <textarea class="hidden" id="prsrls" name="prsrls"></textarea>
                  <div id="prsrlshot"></div>
                </div>
              </div>
						</div>
					</div>
				</div>
				
			</div> <!-- tabcontent -->    
		</div> <!-- container-fluid -->
  </form>
	<script>
		<?= ($vew_data->userexit_aftersave!=''?'$.ajax({ type: "POST", url: "'.$vew_data->userexit_aftersave.'" });':''); ?>
	</script>
	<script>
		/*
		 *
		 *	R O L E S
		 *
		 */
		var <?= $lv_sec; ?>_hotrls_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      if (prop == "prsrlstxt" || prop == "prstxt") {
        Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
        td.style.backgroundColor = '#<?= ($vew_readonly ? 'F1F1F1' : 'FFFFFF'); ?>';
				var lv_patprsrlscod = instance.getDataAtRowProp(row, "patprsrlscod");
        if (lv_patprsrlscod && lv_patprsrlscod!=="") {
          td.style.backgroundColor = "#F1F1F1";
          cellProperties.readOnly = true;
        } else {
          cellProperties.readOnly = false;
        }
      } else {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = '#<?= ($vew_readonly ? 'F1F1F1' : 'FFFFFF'); ?>';
      }
		};
		var <?= $lv_sec; ?>_hotrlstmpchg = [];
		var <?= $lv_sec; ?>_hotrlstmpdel = [];
		var <?= $lv_sec; ?>_hotrlscnt = $("#<?= $lv_sec; ?> #prsrlshot")[0];
		var <?= $lv_sec; ?>_hotrlsset = {
			height: 196,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Rol", "Prestador", "Texto" ],
			columns: [
				{type: "autocomplete", data: "prsrlstxt", width: 100, renderer: <?= $lv_sec; ?>_hotrls_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "index.php?prg=hltprsrls&act=18", dataType: "json", data: {	prm_prsrlstxt: query },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); exit();}},
							success: function (response) {
								// guardo todos los datos adicionales en una variable temporal
								var lv_dat = [];
								<?= $lv_sec; ?>_hotrlstmpchg = [];
								for (var i=0; i < response.length; i++) {
									<?= $lv_sec; ?>_hotrlstmpchg.push( {prsrlstxt: response[i]["prsrlstxt"], prsrlscod: response[i]["prsrlscod"]} );
									lv_dat.push( response[i]["prsrlstxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				},
				{type: "autocomplete", data: "prstxt", width: 100, renderer: <?= $lv_sec; ?>_hotrls_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "index.php?prg=hltprs&act=18", dataType: "json", data: {	prm_prstxt: query },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); exit();}},
							success: function (response) {
								// guardo todos los datos adicionales en una variable temporal
								var lv_dat = [];
								<?= $lv_sec; ?>_hotrlstmpchg = [];
								for (var i=0; i < response.length; i++) {
									<?= $lv_sec; ?>_hotrlstmpchg.push( {prstxt: response[i]["prstxt"], prscod: response[i]["prscod"]} );
									lv_dat.push( response[i]["prstxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				},
				{type: "text", data: "patprsrlstxt", renderer: <?= $lv_sec; ?>_hotrls_renderer <?= ($vew_readonly?', readOnly: true ':''); ?> }
			],
			beforeChange : function(changes, source) {
				// asigno los datos adicionales a la fila
				if(source=="edit" && changes[0][1]=="prsrlstxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotrlstmpchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotrlstmpchg[i].prsrlstxt == lv_value) {
							changes.push([ changes[0][0], "prsrlscod", "", String(<?= $lv_sec; ?>_hotrlstmpchg[i].prsrlscod) ]);
						}
					}
				} else if (source=="edit" && changes[0][1]=="prstxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotrlstmpchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotrlstmpchg[i].prstxt == lv_value) {
							changes.push([ changes[0][0], "prscod", "", String(<?= $lv_sec; ?>_hotrlstmpchg[i].prscod) ]);
						}
					}
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotrls.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["patprsrlscod"]!="" && lv_dat[i]["patprsrlscod"]!=undefined ) {
						<?= $lv_sec; ?>_hotrlstmpdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotrls;	
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotrls = new Handsontable(<?= $lv_sec; ?>_hotrlscnt, <?= $lv_sec; ?>_hotrlsset);	
			var lv_dat = [<?php
				$lv_buffer = '';
				foreach( $vew_data->prsrls as $lv_row) {
					$lv_buffer .= ($lv_buffer==''?'':', ').'{patprsrlscod: "'.$lv_row['patprsrlscod'].'", prsrlscod: "'.$lv_row['prsrlscod'].'", prsrlstxt: "'. mb_convert_encoding($lv_row['prsrlstxt'] ?? '', 'ISO-8859-1', 'UTF-8').'", prscod: "'.($lv_row['prscod']??'').'", prstxt: "'.($lv_row['prstxt']??'').'", patprsrlstxt: "'.$vew_doc->getTagValue($lv_row['patprsrlsatr001'],'patprsrlstxt').'"}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotrls.loadData( lv_dat );
			<?= $lv_sec; ?>_hotrls.render();
		});
	</script>
	<script>
		// FINANCIADOR
    <?php if( $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02') && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'03') && ($vew_actcod == '03' || $vew_actcod == '02') ) { ?>
      $("#<?= $lv_sec; ?> #custxt").siblings(".input-group-btn").removeClass("hidden");
    	$("#<?= $lv_sec; ?> #custxt").siblings(".input-group-btn").on("click", function(e){ e.preventDefault;                                                                              
      	tmssPopup("<?= $vew_lang->financial; ?>","?prg=grldatcnt&prm_vewcod=VEW_GRL_DAT_CNT_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldflt=[c.cntsrctyp:HLT_PAT , c.cntsrccod:"+$("#<?=$lv_sec;?> #patcod").val()+" , sysdocclsinvadratr:X]&prm_fldasg=[custxt:cnttxt],[cuscod:cntdstcod]");                                                           
      });
    <?php } else { ?>
    	var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"custxt" : "custxt", "cuscod" : "cuscod"}}; 
      tmssTypeahead($("#<?= $lv_sec; ?> #custxt"), "slscus", lo_get);    
    <?php } ?>


    // ENTIDAD DERIVADORA
    lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"cushsptxt" : "custxt", "cushsp" : "cuscod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #cushsptxt"), "slscus", lo_get);

    // CLASIFICACION PACIENTE
    lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"hltpatclstxt" : "hltpatclstxt", "hltpatclscod" : "hltpatclscod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #hltpatclstxt"), "hltpatcls", lo_get);

    // CLASIFICACION DE ENFERMEDAD
    lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"docsts" : "A"}, "fldasg" : {"hltdisclstxt" : "hltdisclstxt", "hltdisclscod" : "hltdisclscod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #hltdisclstxt"), "hltdiscls", lo_get);

    // DIAGNOSTICO
    lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"docsts" : "A"}, "fldasg" : {"patdiatxt" : "patdiatxt", "patdiacod" : "patdiacod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #patdiatxt"), "hltpatdia", lo_get);

    // CRONICIDAD
    lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"docsts" : "A"}, "fldasg" : {"patcrotxt" : "patcrotxt", "patcrocod" : "patcrocod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #patcrotxt"), "hltpatcro", lo_get);
		
		
		
		// GRABAR - DUPLICADOS
		$("#<?= $lv_sec; ?> #btnsve").on("click",function(e){ e.preventDefault();
			<?php if ( $lv_confirmduplicate!='' ) { ?>
			if ( $("#<?= $lv_sec; ?> #patcod").prop("value")=="" ) {
				var lv_pstdat= {<?php
													$lv_fldarr = explode(',',$lv_confirmduplicate);
													for($i=0; $i<count($lv_fldarr);$i++){	echo $lv_fldarr[$i].': $("#'.$lv_sec.' #'.$lv_fldarr[$i].'").prop("value")'.($i==count($lv_fldarr)-1?'':','); }
												?>};				
				tmssCallProcess("?prg=hltpat&act=17", lv_pstdat, function(data){
					if (data.length>0) {
						BootstrapDialog.confirm({
							title: "Crear", 
							message:"Se encontraron "+data.length+" pacientes con datos similares al que est&aacute; creando.<br /><br />Desea continuar de todas maneras ?",
							type: BootstrapDialog.TYPE_WARNING,
							callback: function(result){
								if(result){	<?= $lv_sec; ?>_fnc({action: '00'}); }
							}
						});
					} else {
						<?= $lv_sec; ?>_fnc({action: '00'});
					}
				});
			} else { 
				<?= $lv_sec; ?>_fnc({action: '00'}); 
			}
			<?php } else { ?>
				<?= $lv_sec; ?>_fnc({action: '00'}); 
			<?php } ?>
		});
		
		
		// CAMBIAR CLASE DE DOCUMENTO
		$("#<?= $lv_sec; ?> #btnsysdocclschg").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm("¿ Desea cambiar la clase de documento ?", function(result){
        if(result) { <?= $lv_sec; ?>_fnc({action: '33'}); }
      });
		});
		
		
		
		function <?= $lv_sec; ?>_showCustomerInfoBox() {
			<?php
				if ( $lv_infbox!='' ) {
					$lv_infbox = str_ireplace('[','<',$lv_infbox);
					$lv_infbox = str_ireplace(']','>',$lv_infbox);
					$lv_infurl = '"?prg='.$this->co_reg->document->getTagValue($lv_infbox,'controller').
												'&act='.$this->co_reg->document->getTagValue($lv_infbox,'action').
												'&prm_patcod="+$("#'.$lv_sec.' #patcod").prop("value")';
			?>
			tmssCallProcessNoBackdrop( <?= $lv_infurl; ?>, { frmsec: "<?= $lv_sec; ?>" }, function(data){
				$("#<?= $lv_sec; ?> #zcuinfbox").html( data );
			});
			<?php } ?>			
		}
		
		$(function(e) {
			<?= $lv_sec; ?>_showCustomerInfoBox(); 
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab004']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
		});
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
      // al grabar
			if ( lp_prm["action"]=="00" ) {
				// obtengo datos de handsontable de roles
				var lo_dat = <?= $lv_sec; ?>_hotrls.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( Object.keys(lo_dat[i]).length!=0 ) {
						lv_arr.push({	"patprsrlscod":lo_dat[i]["patprsrlscod"],
													"prsrlscod":lo_dat[i]["prsrlscod"],
													"prsrlstxt":lo_dat[i]["prsrlstxt"],
													"prscod":lo_dat[i]["prscod"],
													"prstxt":lo_dat[i]["prstxt"],
													"patprsrlsatr": "<patprsrlstxt>" + (lo_dat[i]["patprsrlstxt"] ? lo_dat[i]["patprsrlstxt"] : '') + "</patprsrlstxt>"
												});
					}
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotrlstmpdel.length; i++) {
					lv_arr.push({	"patprsrlscod":<?= $lv_sec; ?>_hotrlstmpdel[i]["patprsrlscod"], 
												"prsrlscod":<?= $lv_sec; ?>_hotrlstmpdel[i]["prsrlscod"],
												"prsrlstxt":<?= $lv_sec; ?>_hotrlstmpdel[i]["prsrlstxt"],
												"prscod":<?= $lv_sec; ?>_hotrlstmpdel[i]["prscod"],
												"prstxt":<?= $lv_sec; ?>_hotrlstmpdel[i]["prstxt"],
												"patprsrlsatr": "<patprsrlstxt>" + (<?= $lv_sec; ?>_hotrlstmpdel[i]["patprsrlstxt"] ? <?= $lv_sec; ?>_hotrlstmpdel[i]["patprsrlstxt"] : '') + "</patprsrlstxt>",
												"deleted":"X" });
				}
				$("#<?= $lv_sec; ?> #prsrls").text( (lv_arr.length==0?"":JSON.stringify(lv_arr)) );
			}
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
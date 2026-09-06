<?php
	// url del formulario 
  $lv_lnk = '?prg=zcutp1&prm_evlcod='.$vew_data->evlcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('evlinfprc','patcod','pattxt','prscod','prstxt','spccod','spctxt','docsts','plnid','plndteid') );

	// clave del documento 
	$lv_dockey = $vew_data->evlcod;

	// titulo 
	$lv_title = $vew_lang->document;

	// módulo y programa 
	$lv_mdlcod = 'ZCU';
	$lv_prgcod ='TP1';

	$vew_actcod = ($vew_data->evlcod!=''?'03':'02');

	// librería de estilos bootstrap 
	include_once('_library.frm');

	// valores x default 
	/*
	if ($vew_data->evlcod=='') {
		$vew_data->evlinfprc = '';
	} else if ($vew_data->docsts=='A') {
		$vew_data->evlinfprc = '1';
	} else {
		$vew_data->evlevl = strtoupper($vew_data->evlevl);
		$lv_buf = $vew_doc->getTagValue($vew_data->evlevl,'row');
		if ($lv_buf!='') {
			$vew_data->evlinfprc = '0';
			$vew_data->evlcncmtv = strtoupper($vew_doc->getTagValue($lv_buf,'evlcncmtv'));
			$vew_data->evlcnccmt = $vew_doc->getTagValue($lv_buf,'evlcnccmt');
		}
	}
	// $vew_data->evlevl=utf8_decode($vew_data->evlevl);
	// $vew_data->evlcnccmt=utf8_decode($vew_data->evlcnccmt);
	$vew_data->evlevl=utf8_decode($vew_data->evlsub);
	$vew_data->evlcnccmt=utf8_decode($vew_data->evlsub);
	$vew_data->evlcmt=utf8_decode($vew_data->evlcmt);
	*/
	if ($vew_data->evlcod=='') {
		$vew_data->evlinfprc = '';
	}else{
		$vew_data->evlatrval001 = strtoupper($vew_data->evlatrval001);
	 	$lv_buf = $vew_doc->getTagValue($vew_data->evlatr001,'row');
	 	$vew_data->evlinfprc = strtoupper($vew_doc->getTagValue($lv_buf,'evlinfprc'));
	 	if ($vew_data->evlinfprc ==''){
	 		if ($vew_data->docsts=='A') {
				$vew_data->evlinfprc = '1';
			}	else{
	 			$vew_data->evlinfprc = '0';
	 		}
	 	}
	 	$vew_data->evlcncmtv = strtoupper($vew_doc->getTagValue($lv_buf,'evlcncmtv'));
	 	$vew_data->evlcnccmt=utf8_decode($vew_data->evlsub);
	 	$vew_data->evlevl = utf8_decode($vew_data->evlevl);
	 	$vew_data->evlcmt=utf8_decode($vew_data->evlcmt);
    $vew_data->fvrpt = strtoupper($vew_doc->getTagValue($lv_buf,'fvrpt'));   
    $vew_data->frm = strtoupper($vew_doc->getTagValue($lv_buf,'dvcfrm'));
	}
	$lv_icofrm= '';
	$lv_icofrm= $vew_data->frm==''?'fa-desktop':'fa-mobile-alt';
?>
<section id="<?php echo $lv_sec; ?>" data-model="<?php echo $vew_model; ?>" data-title="<?php echo $lv_title; ?>">
	<div class="container-fluid">	
  <form method="POST" class="form-horizontal" id="<?php echo $lv_sec; ?>_frm" style="padding-top: 0px;">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
    <input type="hidden" id="sysdocclscod" name="sysdocclscod" value="<?= $vew_data->sysdoccls->sysdocclscod; ?>">

		<div class="row">
			<div class="col-md-3">
				<label class="control-label"><?php echo $vew_lang->id; 				?></label><br><?php echo gethtml('evlcod','doccod',$vew_data->evlcod,$lv_always_disabled); ?>
				<label class="control-label"><?php echo $vew_lang->date; 			?></label><br><?php echo gethtml('evldte','docdte',$vew_data->evldte,$lv_default); ?>
				<label class="control-label"><?php echo $vew_lang->specialty; ?></label><br><?php echo gethtml('spctxt','spctxt',$vew_data->spctxt,$lv_always_disabled); ?>
				<label class="control-label"><?php echo $vew_lang->patient; 	?></label><br><?php echo gethtml('pattxt','pattxt',$vew_data->pattxt,$lv_always_disabled); ?>
				<label class="control-label"><?php echo $vew_lang->provider; 	?></label><br><?php echo gethtml('prstxt','prstxt',$vew_data->prstxt,$lv_always_disabled); ?>
				<label class="control-label"><?php echo $vew_lang->status; 		?></label><br><?php echo gethtml('docsts','doccmt1x20',($vew_data->evlcod==''?'P':$vew_data->docsts),$lv_always_disabled); ?>
        <br/>
        <i class="fas <?php echo $lv_icofrm;?>"></i>
        <br/>
			</div>
			<div class="col-md-9">

				<nav class="navbar navbar-default tmss-navbar">
					<div class="container-fluid">
						<ul class="nav navbar-nav tmss-navbar-left">
							<?php if(!$vew_readonly) { ?><a href="#" onclick="<?php echo $lv_sec; ?>_fnc({action: 'evlonc00'});" class="btn btn-default navbar-btn tmssAlwaysEnabled btn-success" title="<?php echo $vew_lang->save;  ?>"><span class="fas fa-save"></span><span class="hidden-xs"> <?php echo $vew_lang->save; ?></span></a><?php } ?>
							<?php if ($vew_sec->hasPermission('HLT','EVL','04') && $vew_data->evlcod!='') { ?><a href="#" onclick="<?php echo $lv_sec; ?>_fnc({action: '	evloncx4'});" class="btn btn-default navbar-btn tmssAlwaysEnabled btn-danger" title="<?php echo $vew_lang->delete; ?>"><span class="fas fa-trash-alt"></span><span class="hidden-xs"> <?php echo $vew_lang->delete; ?></span></a><?php } ?>
							<?php if ($vew_sec->hasPermission('HLT','EVL','05') && $vew_data->docsts=='A') { ?><a href="#" id="btnprn" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?php echo $vew_lang->print; ?>"><span class="fas fa-print"></span><span class="hidden-xs"> <?php echo $vew_lang->print; ?></span></a><?php } ?>
						</ul>
						<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
						<?php include('grldatuplbtn.frm'); ?>
						<?php if($vew_data->hhcc=='X') { ?>
							<a href="#" onclick="tmssTabSecCls( $('#<?php echo $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?php echo $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
						<?php } ?>
					</ul>
					</div>
				</nav>
				<div class="container-fluid" role="tabpanel">
					<ul class="nav nav-tabs" role="tablist">
						<li role="presentation" class="active"><a href="#<?php echo $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?php echo $vew_lang->general; ?></a></li>
						<li role="presentation"><a href="#<?php echo $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?php echo $vew_lang->comments; ?></a></li>
						<li role="presentation"><a href="#<?php echo $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?php echo $vew_lang->history; ?></a></li>
						<li role="presentation"><a href="#<?php echo $lv_sec; ?>_tab999" role="tab" data-toggle="tab"><?php echo $vew_lang->additionalinfo; ?></a></li>
					</ul>
					<div class="tab-content tmss-tab-content">

						<!-- GENERAL -->
						<div role="tabpanel" class="tab-pane active" id="<?php echo $lv_sec; ?>_tab001">
							<?php
								echo vew_boot($lv_col210,array('label'=>'Se infundi&oacute;?', 'input'=>gethtml('evlinfprc','yesno',$vew_data->evlinfprc,$lv_default) ));
							?>
							<div id="evlnoinf_div">
								<div class="form-group tmss-form-group">
									<label class="control-label col-sm-2"><?php echo $vew_lang->motive; ?></label>
									<div class="col-sm-10"><?php gethtml('evlcncmtv', array(''=>'','SV'=>'SIN VIALES','EN'=>'ENFERMEDAD','ND'=>'PACIENTE NO DISPONIBLE','OT'=>'OTROS'), $vew_data->evlcncmtv); ?></div>
								</div>
								<?php
									echo vew_boot($lv_col210,array('label'=>$vew_lang->comments, 'input'=>gethtml('evlcnccmt','doccmt5x50',$vew_data->evlcnccmt,$lv_default) ));
								?>
							</div>
							<div id="evlyesinf_div">
								<textarea id="evlatr" name="evlatr" class="hidden"></textarea>
								<div id="evlatrhot" name="evlatrhot"></div>

								<textarea id="evlmat" name="evlmat" class="hidden"></textarea>
								<div id="evlmathot" name="evlmathot"></div>
								<?php
									echo vew_boot($lv_col210,array('label'=>$vew_lang->evolution, 'input'=>gethtml('evlevl','doccmt5x50',$vew_data->evlevl,$lv_default) ));
								?>
                </div>
              <div id="evlinf_div">
                <div class="form-group">
                  <label class="col-sm-7 control-label">Ud registr&oacute; algo que se deber&iacute;a reportar a FV?</label>
                  <div class="col-sm-5"><input type="checkbox" id="frmclk" name="fvrpt" <?= ($vew_data->fvrpt=='ON'?'checked':''); ?>></div>
                </div>
              </div>
						</div> <!-- /tabpanel -->

						<!-- COMENTARIOS -->
						<div role="tabpanel" class="tab-pane" id="<?php echo $lv_sec; ?>_tab002">
							<?php echo vew_boot($lv_col210, array('label'=>$vew_lang->comments,	'input'=>gethtml('evlcmt', 'doccmt10x50',	$vew_data->evlcmt, $lv_default) )); ?>
						</div>

						<!-- HISTORIAL -->
						<div role="tabpanel" class="tab-pane" id="<?php echo $lv_sec; ?>_tab003">
							<table class="table table-condensed table-striped">
								<theader><tr><th>Fecha</th><th>Evento</th></tr></theader>
								<tbody>
									<?php
										$lv_str = strtoupper($vew_data->evlobj);
										while( $vew_doc->getTagValue($lv_str,'row')!='' ) {
											$lv_buf = $vew_doc->getTagValue($lv_str,'row');
											$lv_dte = $vew_doc->getTagValue($lv_str,'dte');
											$lv_dte = substr($lv_dte,6,2).'/'.substr($lv_dte,4,2).'/'.substr($lv_dte,0,4);
											$lv_txt = '';
											if ( $vew_doc->getTagValue($lv_str,'evlcncmtv')!='' ) {
												/* ejemplo: evlobj
													<row><dte>20170716000000</dte><evlcncmtv>EN</evlcncmtv><evlcnccmt>no se infundio</evlcnccmt></row>
												*/
												$lv_mtv = strtoupper($vew_doc->getTagValue($lv_str,'evlcncmtv'));
												$lv_txt = '<table class="table table-condensed">'.
																	'<tr><td width=50></td><td><strong>No se infundi�</strong></td></tr>'.
																	'<tr><td>Motivo:</td><td>'.($lv_mtv=='SV'?'SIN VIALES':($lv_mtv=='EN'?'ENFERMEDAD':($lv_mtv=='ND'?'PACIENTE NO DISPONIBLE':($lv_mtv=='OT'?'OTROS':'(no identificado)')))).'</td></tr>'.
																	'<tr><td>Comentarios:</td><td>'.$vew_doc->getTagValue($lv_str,'evlcnccmt').'</td></tr>'.
																	'</table>';
												echo '<tr><td>'.$lv_dte.'</td><td>'.$lv_txt.'</td></tr>';
											} else if ( $vew_doc->getTagValue($lv_str,'evlqst')!='' ) {
												/* ejemplo: evlobj
													<row><dte>20170716000000</dte>
														<evlqst>
															<evlqstqst>�Tomo premedicaci�n si fue indicada?</evlqstqst><evlqstanw>na</evlqstanw><evlqstcmt>Hora: 21:00 � Droga: Hidrocortisona - Dosis: 12 � Via: Oral</evlqstcmt>
															<evlqstqst>�Se encuentra en buen estado de salud?</evlqstqst><evlqstanw>SI</evlqstanw><evlqstcmt></evlqstcmt>
															<evlqstqst>�Present� fiebre en las �ltimas 24hs?</evlqstqst><evlqstanw>NO</evlqstanw><evlqstcmt></evlqstcmt>
															<evlqstqst>�Est� recibiendo antib�ticos por una infecci�n activa?</evlqstqst><evlqstanw>NO</evlqstanw><evlqstcmt></evlqstcmt>
															<evlqstqst>�Presenta afecci�n respiratoria aguda?</evlqstqst><evlqstanw>NO</evlqstanw><evlqstcmt></evlqstcmt>
														</evlqst>
													</row>
												*/
												$lv_txt = '<table class="table table-condensed table-bordered">'.
																	'<tr><td colspan="2"><strong>Cuestionario:</strong></td></tr>';
												$lv_strqst = $vew_doc->getTagValue($lv_str,'evlqst');
												while ( $vew_doc->getTagValue($lv_strqst,'evlqstqst')!='' ) {
													$lv_qstqst = $vew_doc->getTagValue($lv_strqst,'evlqstqst');
													$lv_qstanw = $vew_doc->getTagValue($lv_strqst,'evlqstanw');
													$lv_qstcmt = $vew_doc->getTagValue($lv_strqst,'evlqstcmt');
													$lv_txt .= '<tr><td>'.$lv_qstqst.'</td><td><strong>'.$lv_qstanw.($lv_qstcmt!=''?'<br>'.$lv_qstcmt:'').'</strong></td></tr>';
													$lv_strqst = substr( $lv_strqst, strlen($lv_qstqst.$lv_qstanw.$lv_qstcmt)+69, strlen($lv_strqst)-strlen($lv_qstqst.$lv_qstanw.$lv_qstcmt)-69 );
												}
												$lv_txt .= '</table>';
												echo '<tr><td>'.$lv_dte.'</td><td>'.$lv_txt.'</td></tr>';
											}
											$lv_str = substr($lv_str, strlen($lv_buf)+11, strlen($lv_str)-strlen($lv_buf)-11);
										}
									?>
								</tbody>
							</table>
						</div>

						<!-- DATOS ADICIONALES -->
						<div role="tabpanel" class="tab-pane" id="<?php echo $lv_sec; ?>_tab999">
							<?php
								echo vew_boot($lv_col210, array('label'=>$vew_lang->createdby, 	'input'=>gethtml('', 'usrcod', $vew_data->cteusr, $lv_always_disabled) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->createddate,'input'=>gethtml('', 'dtetme', $vew_data->ctedte, $lv_always_disabled) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->updatedby, 	'input'=>gethtml('', 'usrcod', $vew_data->updusr, $lv_always_disabled) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->updateddate,'input'=>gethtml('', 'dtetme', $vew_data->upddte, $lv_always_disabled) ));
							?>
							<hr>
							<?php
								echo vew_boot($lv_col210, array('label'=>$vew_lang->specialty, 	'input'=>gethtml('spccod', 'doccmt1x50', $vew_data->spccod, $lv_always_disabled) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->patient, 		'input'=>gethtml('patcod', 'doccmt1x50', $vew_data->patcod, $lv_always_disabled) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->provider, 	'input'=>gethtml('prscod', 'doccmt1x50', $vew_data->prscod, $lv_always_disabled) ));
								echo vew_boot($lv_col255, array('label'=>$vew_lang->planning, 	'input1'=>gethtml('plnid', 'doccmt1x50', $vew_data->plnid, $lv_always_disabled),
																																								'input2'=>gethtml('plndteid', 'doccmt1x50', $vew_data->plndteid, $lv_always_disabled) ));
							?>
						</div>

					</div> <!-- tabcontent -->
				</div> <!-- container-fluid -->
			</div> <!-- col-sm-9 -->
		</div> <!-- row -->
  </form>
  </div>
  <script>
  	tmssLoadScript("toggle",function(){
			$("#<?php echo $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: "success", offstyle: "default", on: "Si", off: "No", size: "small" });
				$(this).trigger("change");
			});
		});
  </script>
	<script>
		/**
		 *	SIGNOS VITALES
		 */
		var <?php echo $lv_sec; ?>_hotatr_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			td.style.backgroundColor = "#<?php echo ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
		};
		var <?php echo $lv_sec; ?>_hotatrerr = [];
		var <?php echo $lv_sec; ?>_hotatrchg = [];
		var <?php echo $lv_sec; ?>_hotatrdel = [];
		var <?php echo $lv_sec; ?>_hotatrcnt = $("#<?php echo $lv_sec; ?> #evlatrhot")[0];
		var <?php echo $lv_sec; ?>_hotatrset = {
			height: 100,
			stretchH: "all",
			autoColumnSize: true,
			<?php echo ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?php echo ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "ML/H", "Peso", "T", "FC", "FR", "TA" ],
			columns: [
				{type: "numeric", data: "ml", width: 30, renderer: <?php echo $lv_sec; ?>_hotatr_renderer <?php echo ($vew_readonly?', readOnly: true':''); ?> },
				{type: "numeric", data: "p", width: 30, renderer: <?php echo $lv_sec; ?>_hotatr_renderer <?php echo ($vew_readonly?', readOnly: true':''); ?> },
				{type: "numeric", data: "t", width: 30, renderer: <?php echo $lv_sec; ?>_hotatr_renderer <?php echo ($vew_readonly?', readOnly: true':''); ?> },
				{type: "numeric", data: "fc", width: 30, renderer: <?php echo $lv_sec; ?>_hotatr_renderer <?php echo ($vew_readonly?', readOnly: true':''); ?> },
				{type: "numeric", data: "fr", width: 30, renderer: <?php echo $lv_sec; ?>_hotatr_renderer <?php echo ($vew_readonly?', readOnly: true':''); ?> },
				{type: "autocomplete", data: "ta", width: 30, renderer: <?php echo $lv_sec; ?>_hotatr_renderer <?php echo ($vew_readonly?', readOnly: true':''); ?> }
			],
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?php echo $lv_sec; ?>_hotatr.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["evlspccod"]!="" && lv_dat[i]["evlspccod"]!=undefined ) {
						<?php echo $lv_sec; ?>_hotatrdel.push( lv_dat[i] );
					}
				}
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?php echo $lv_sec; ?>_hotatrerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?php echo $lv_sec; ?>_hotatrerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?php echo $lv_sec; ?>_hotatrerr.splice(lv_inx,1); }
				}
			}
		};
		var <?php echo $lv_sec; ?>_hotatr;
		
		tmssLoadScript("handsontable",function(){
			<?php echo $lv_sec; ?>_hotatr = new Handsontable(<?php echo $lv_sec; ?>_hotatrcnt, <?php echo $lv_sec; ?>_hotatrset);
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->evlspc as $lv_row){
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'evlspccod:"'.$lv_row['evlspccod'].'",'.
												'ml:"'.$vew_doc->getTagValue($lv_row['evlatrval001'],'ml').'",'.
												'p:"'.$vew_doc->getTagValue($lv_row['evlatrval001'],'p').'",'.
												't:"'.$vew_doc->getTagValue($lv_row['evlatrval001'],'t').'",'.
												'fc:"'.$vew_doc->getTagValue($lv_row['evlatrval001'],'fc').'",'.
												'fr:"'.$vew_doc->getTagValue($lv_row['evlatrval001'],'fr').'",'.
												'ta:"'.$vew_doc->getTagValue($lv_row['evlatrval001'],'ta').'"}';
				}
				echo $lv_buffer;
			?>];
			<?php echo $lv_sec; ?>_hotatr.loadData( lv_dat );
			<?php echo $lv_sec; ?>_hotatr.render();
		});
	</script>
	<script>
		/**
		 *	MEDICAMENTOS
		 */
		var <?php echo $lv_sec; ?>_hotmat_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if ( prop=="evlmedqty" ) {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?php echo ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else if ( prop=="evlmedbchdue" ) {
				Handsontable.renderers.DateRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?php echo ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else if ( prop=="evlmedadvrea" ) {
				Handsontable.renderers.DropdownRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?php echo ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?php echo ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?php echo $lv_sec; ?>_hotmaterr = [];
		var <?php echo $lv_sec; ?>_hotmatchg = [];
		var <?php echo $lv_sec; ?>_hotmatdel = [];
		var <?php echo $lv_sec; ?>_hotmatcnt = $("#<?php echo $lv_sec; ?> #evlmathot")[0];
		var <?php echo $lv_sec; ?>_hotmatset = {
			height: 100,
			stretchH: "all",
			autoColumnSize: true,
			<?php echo ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?php echo ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Producto", "Hs.Ini", "Hs.Fin", "Qty.Viales", "Lote", "Vto", "Reac.Advers." ],
			columns: [
				{type: "autocomplete", data: "mattxt", renderer: <?php echo $lv_sec; ?>_hotmat_renderer, <?php echo ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
							url: "index.php?prg=stkmat&act=17", dataType: "json", data: {	prm_mattxt: query },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
							success: function (response) {
								// guardo todos los datos adicionales en una variable temporal
								var lv_dat = [];
								<?php echo $lv_sec; ?>_hotmatchg = [];

								for (var i=0; i < response.data.length; i++) {
									<?php echo $lv_sec; ?>_hotmatchg.push( {mattxt: response.data[i]["mattxt"], matcod: response.data[i]["matcod"], matuntcod: response.data[i]["matuntcod"]} );
									lv_dat.push( response.data[i]["mattxt"] );
								}

								process( lv_dat );
							}
						});
					},
					strict: true
				},
				{type: "autocomplete", data: "atrstrtme", width: 30, renderer: <?php echo $lv_sec; ?>_hotatr_renderer <?php echo ($vew_readonly?', readOnly: true':''); ?> },
				{type: "autocomplete", data: "atrendtme", width: 30, renderer: <?php echo $lv_sec; ?>_hotatr_renderer <?php echo ($vew_readonly?', readOnly: true':''); ?> },
				{type: "numeric", data: "matqty", width: 30, renderer: <?php echo $lv_sec; ?>_hotatr_renderer <?php echo ($vew_readonly?', readOnly: true':''); ?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "autocomplete", data: "matbchcodext", width: 30, renderer: <?php echo $lv_sec; ?>_hotatr_renderer <?php echo ($vew_readonly?', readOnly: true':''); ?> },
				{type: "date", data: "matbchduedte", width: 30, renderer: <?php echo $lv_sec; ?>_hotatr_renderer <?php echo ($vew_readonly?', readOnly: true':''); ?>,
					dateFormat: 'DD/MM/YYYY',
					correctFormat: true,
					allowEmpty: false,
					datePickerConfig: {
						firstDay: 0,
						showWeekNumber: false,
						numberOfMonths: 1
					}
				},
				{type: "dropdown", data: "atradvrea", source: ["Si", "No"], width: 30, renderer: <?php echo $lv_sec; ?>_hotatr_renderer <?php echo ($vew_readonly?', readOnly: true':''); ?> }
			],
			beforeChange : function(changes, source) {
				// asigno los datos adicionales a la fila
				if(source=="edit" && changes[0][1]=="mattxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?php echo $lv_sec; ?>_hotmatchg.length ; i++) {
						if(<?php echo $lv_sec; ?>_hotmatchg[i].mattxt == lv_value) {
							changes.push([ changes[0][0], "matcod", "", String(<?php echo $lv_sec; ?>_hotmatchg[i].matcod) ]);
							changes.push([ changes[0][0], "matuntcod", "", String(<?php echo $lv_sec; ?>_hotmatchg[i].matuntcod) ]);
						}
					}
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?php echo $lv_sec; ?>_hotmat.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["evlmatcod"]!="" && lv_dat[i]["evlmatcod"]!=undefined ) {
						<?php echo $lv_sec; ?>_hotmatdel.push( lv_dat[i] );
					}
				}
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?php echo $lv_sec; ?>_hotmaterr.indexOf( lv_key );
				if ( isValid==false ) {
					<?php echo $lv_sec; ?>_hotmaterr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?php echo $lv_sec; ?>_hotmaterr.splice(lv_inx,1); }
				}
			}
		};
		var <?php echo $lv_sec; ?>_hotmat;
		
		tmssLoadScript("handsontable",function(){
			<?php echo $lv_sec; ?>_hotmat = new Handsontable(<?php echo $lv_sec; ?>_hotmatcnt, <?php echo $lv_sec; ?>_hotmatset);
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->evlmat as $lv_row){
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'evlmatcod:"'.$lv_row['evlmatcod'].'",'.
												'mattxt:"'.$lv_row['mattxt'].'",'.
												'matqty: '.$lv_row['matqty'].' ,'.
												'matbchcodext:"'.$lv_row['matbchcodext'].'",'.
												'matbchduedte:"'.date_format($lv_row['matbchduedte'],'d/m/Y').'",'.
												'atrstrtme:"'.$vew_doc->getTagValue($lv_row['matatrval001'],'strtme').'",'.
												'atrendtme:"'.$vew_doc->getTagValue($lv_row['matatrval001'],'endtme').'",'.
												'atradvrea:"'.$vew_doc->getTagValue($lv_row['matatrval001'],'advrea').'"}'; }
				echo $lv_buffer;
			?>];
			<?php echo $lv_sec; ?>_hotmat.loadData( lv_dat );
			<?php echo $lv_sec; ?>_hotmat.render();
		});
	</script>
	<script>
		$("#<?php echo $lv_sec; ?> #evlinfprc").on("change",function(e){
			if ( $(this).prop("value")=="0" ) {
				$("#<?php echo $lv_sec; ?> #evlcncmtv").addClass("tmssInputRequired").prop("placeholder","?");
				$("#<?php echo $lv_sec; ?> #evlcnccmt").addClass("tmssInputRequired").prop("placeholder","?");
				$("#<?php echo $lv_sec; ?> #evlevl").removeClass("tmssInputRequired").prop("placeholder","?");
			} else {
				$("#<?php echo $lv_sec; ?> #evlevl").addClass("tmssInputRequired").prop("placeholder","?");
				$("#<?php echo $lv_sec; ?> #evlcncmtv").removeClass("tmssInputRequired").prop("placeholder","?");
				$("#<?php echo $lv_sec; ?> #evlcnccmt").removeClass("tmssInputRequired").prop("placeholder","?");
			}
		});
	</script>
	<script>
		$(function(e){
			$("#<?php echo $lv_sec; ?> #evlinfprc").trigger("change");
			
			<?php
				$lv_plnpen='';
				foreach( $vew_rsplndte as $lv_row ) { $lv_plnpen .= $lv_row['plndte']->format('d/m/Y').'<br>'; }
				if($lv_plnpen!=''){ echo 'toastr.warning("El paciente <b>'.$vew_data->pattxt.'</b> tiene pendiente de evolucionar las siguientes fechas:<br>'.$lv_plnpen.'","ATENCION!");'; }
			?>
		});
		
		$("#<?php echo $lv_sec; ?> #evlinfprc").on("change",function(e){
			if ( $(this).prop("value")=="1" ) {
				$("#<?php echo $lv_sec; ?> #evlnoinf_div").addClass("hidden");
				$("#<?php echo $lv_sec; ?> #evlyesinf_div").removeClass("hidden");
				tmssHandsontableResize();
			} else if ( $(this).prop("value")=="0") {
				$("#<?php echo $lv_sec; ?> #evlnoinf_div").removeClass("hidden");
				$("#<?php echo $lv_sec; ?> #evlyesinf_div").addClass("hidden");
			} else {
				$("#<?php echo $lv_sec; ?> #evlnoinf_div").addClass("hidden");
				$("#<?php echo $lv_sec; ?> #evlyesinf_div").addClass("hidden");
			}
		})

		<?php if ($vew_sec->hasPermission('HLT','EVL','05') && $vew_data->evlcod!='') { ?>
			// IMPRIMIR
			$("#<?php echo $lv_sec; ?> #btnprn").on("click",function(e){
				window.open("?prg=zcutp1&act=hltpatevlprn&prm_evlcod="+<?php echo $vew_data->evlcod; ?>);
			});
		<?php } ?>
	</script>
  <script>
    var gv_<?php echo $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $("#<?php echo $lv_sec; ?>_frm"), "<?php echo $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?php echo $lv_sec; ?>_last_action, "<?php echo $lv_title; ?>", "<b><?php echo $vew_data->matcod; ?></b>" ) ) {
				if ( gv_<?php echo $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?php echo $lv_sec; ?>") );
				} else {
					$("#<?php echo $lv_sec; ?>").replaceWith( data );
				}
			}
    });

		// form submit
    function <?php echo $lv_sec; ?>_fnc( lp_prm ) {
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {

				if (lp_prm["action"]=="	evloncx4") {
					var lv_ok = 0;
					BootstrapDialog.confirm({
						title: 'Borrar Evoluci�n',
						message: '�Desea borrar el documento ?',
						type: BootstrapDialog.TYPE_WARNING,
						callback: function(result) {
							if(result) { <?php echo $lv_sec; ?>_fnc({action: "evlonc04"}); }
						}
					});
					return false;
				}
				if (lp_prm["action"]=="evlonc00"){if(!tmssCheckRequiredFields($("#<?php echo $lv_sec; ?>_frm"))){return false;}}
				if ( <?php echo $lv_sec; ?>_hotatrerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla de signos vitales."); return false; }
				if ( <?php echo $lv_sec; ?>_hotmaterr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla de medicamentos."); return false; }
				if (lp_prm["action"]=="evlonc00" && $("#<?php echo $lv_sec; ?> #evlinfprc").prop("value")=="1" ) {
					var lv_err = 0;

					// atributos
					var lo_dat = <?php echo $lv_sec; ?>_hotatr.getSourceData();
					var lv_arr = new Array();
					for (var i=0; i<lo_dat.length; i++) {
						if ( Object.keys(lo_dat[i]).length!=0 ) {
							if (	(lo_dat[i]["ml"]===undefined || lo_dat[i]["ml"]==="") &&
										(lo_dat[i]["p"]===undefined || lo_dat[i]["p"]==="") &&
										(lo_dat[i]["t"]===undefined || lo_dat[i]["t"]==="") &&
										(lo_dat[i]["fc"]===undefined || lo_dat[i]["fc"]==="") &&
										(lo_dat[i]["fr"]===undefined || lo_dat[i]["fr"]==="") &&
										(lo_dat[i]["ta"]===undefined || lo_dat[i]["ta"]==="") ) {
								// se agrego una nueva linea y luego se borraron los datos manualmente
								// nada que hacer
							} else {
								lv_err += (	lo_dat[i]["ml"]===undefined || lo_dat[i]["ml"]==="" ||
														lo_dat[i]["p"]===undefined || lo_dat[i]["p"]==="" ||
														lo_dat[i]["t"]===undefined || lo_dat[i]["t"]==="" ||
														lo_dat[i]["fc"]===undefined || lo_dat[i]["fc"]==="" ||
														lo_dat[i]["fr"]===undefined || lo_dat[i]["fr"]==="" ||
														lo_dat[i]["ta"]===undefined || lo_dat[i]["ta"]===""?1:0)
								lv_arr.push({	"ml":lo_dat[i]["ml"],
															"p":lo_dat[i]["p"],
															"t":lo_dat[i]["t"],
															"fc":lo_dat[i]["fc"],
															"fr":lo_dat[i]["fr"],
															"ta":lo_dat[i]["ta"]
														});
							}
						}
					}
					if ( lv_arr.length==0 || lv_err!=0 ) {
						toastr.warning("Complete todas las mediciones.");
						return;
					}
					for (var i=0; i<<?php echo $lv_sec; ?>_hotatrdel.length; i++) {
						lv_arr.push({	"evlspccod":<?php echo $lv_sec; ?>_hotatrdel[i]["evlspccod"], "deleted":"X"});
					}
					$("#<?php echo $lv_sec; ?> #evlatr").text( (lv_arr.length==0?"":JSON.stringify(lv_arr)) );

					var lo_dat = <?php echo $lv_sec; ?>_hotmat.getSourceData();
					var lv_arr = new Array();
					for (var i=0; i<lo_dat.length; i++) {
						if ( Object.keys(lo_dat[i]).length!=0 ) {
							if (	(lo_dat[i]["mattxt"]===undefined || lo_dat[i]["mattxt"]=="") &&
										(lo_dat[i]["atrstrtme"]===undefined || lo_dat[i]["atrstrtme"]=="") &&
										(lo_dat[i]["atrendtme"]===undefined || lo_dat[i]["atrendtme"]=="") &&
										(lo_dat[i]["matqty"]===undefined || lo_dat[i]["matqty"]=="") &&
										(lo_dat[i]["matbchcodext"]===undefined || lo_dat[i]["matbchcodext"]=="") &&
										(lo_dat[i]["matbchduedte"]===undefined || lo_dat[i]["matbchduedte"]=="") &&
										(lo_dat[i]["atradvrea"]===undefined || lo_dat[i]["atradvrea"]=="") ) {
								// se agrego una nueva linea y luego se borraron los datos manualmente
								// nada que hacer
							} else {
								lv_err += (	lo_dat[i]["mattxt"]===undefined || lo_dat[i]["mattxt"]=="" ||
														lo_dat[i]["atrstrtme"]===undefined || lo_dat[i]["atrstrtme"]=="" ||
														lo_dat[i]["atrendtme"]===undefined || lo_dat[i]["atrendtme"]=="" ||
														lo_dat[i]["matqty"]===undefined || lo_dat[i]["matqty"]=="" ||
														lo_dat[i]["matbchcodext"]===undefined || lo_dat[i]["matbchcodext"]=="" ||
														lo_dat[i]["matbchduedte"]===undefined || lo_dat[i]["matbchduedte"]=="" ||
														lo_dat[i]["atradvrea"]===undefined || lo_dat[i]["atradvrea"]==""?1:0)
								lv_arr.push({	"evlmatcod":lo_dat[i]["evlmatcod"],
															"matcod":lo_dat[i]["matcod"],
															"mattxt":lo_dat[i]["mattxt"],
															"matqty":lo_dat[i]["matqty"],
															"matuntcod":lo_dat[i]["matuntcod"],
															"matbchcodext":lo_dat[i]["matbchcodext"],
															"matbchduedte":lo_dat[i]["matbchduedte"],
															"atrstrtme":lo_dat[i]["atrstrtme"],
															"atrendtme":lo_dat[i]["atrendtme"],
															"atradvrea":lo_dat[i]["atradvrea"]
														});
							}
						}
					}
					if ( lv_arr.length==0 || lv_err!=0 ) {
						toastr.warning("Complete todos los datos del medicamento.");
						return;
					}
					for (var i=0; i<<?php echo $lv_sec; ?>_hotmatdel.length; i++) {
						lv_arr.push({	"evlspccod":<?php echo $lv_sec; ?>_hotmatdel[i]["evlmatcod"], "deleted":"X"});
					}
					$("#<?php echo $lv_sec; ?> #evlmat").text( (lv_arr.length==0?"":JSON.stringify(lv_arr)) );

				}

				gv_<?php echo $lv_sec; ?>_last_action = lp_prm["action"];
				var lv_action = (gv_<?php echo $lv_sec; ?>_last_action=="99"?"<?php echo ($vew_actcod=='02'?'02':'03'); ?>":gv_<?php echo $lv_sec; ?>_last_action);
				tmssMessageProcessing( "<?php echo $lv_sec; ?>", lv_action, "<?php echo $lv_title; ?>", "" );
			}
		}

		// edit mode
    tmssFormEdit("<?php echo $lv_sec; ?>",<?php echo ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>
</section>
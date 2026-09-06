<?php
	/* url del formulario */
  $lv_lnk = '?prg=slsprc&prm_slsprclstcod='.$vew_data->slsprclstcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('slsprclsttxt','curcod','docsts','slsprclststrdte','slsprclstenddte','slsprclsttyp') );

	/* clave del documento */
	$lv_dockey = $vew_data->slsprclstcod;

	/* titulo */
	$lv_title = $vew_lang->prices;
	
	/* módulo y programa */
	$lv_mdlcod = 'SLS';
	$lv_prgcod = 'PRC';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01')) { ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '01'});"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->new; ?>"><span class="far fa-file"></span><span class="hidden-xs"> <?= $vew_lang->new; ?></span></a><?php } ?>
				<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01')) { ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '001'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->copy; ?>"><span class="far fa-copy"></span><span class="hidden-xs"> <?= $vew_lang->copy; ?></span></a><?php } ?>
				<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02')) { ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '02'});"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->modify; ?>"><span class="fas fa-pencil-alt"></span><span class="hidden-xs"> <?= $vew_lang->modify; ?></span></a><?php } ?>
				<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04')) { ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '04'});"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->delete; ?>"><span class="fas fa-trash-alt"></span><span class="hidden-xs"> <?= $vew_lang->delete; ?></span></a><?php } ?>
				<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'03')) { ?><a href="#" id="btnver" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->history; ?>"><span class="fas fa-history"></span><span class="hidden-xs"> <?= $vew_lang->versions; ?></span></a><?php } ?>
				<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02') && ($vew_data->slsprclstancsrc=='1' || $vew_data->slsprclstancsrc=='2') ) { ?><a href="#" id="btnupd" class="btn btn-success navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->update;  ?>"><span class="fas fa-bolt"></span><span class="hidden-xs"> <?= $vew_lang->update; ?></span></a><?php } ?>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '00'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success" title="<?= $vew_lang->save;  ?>"><span class="fas fa-save"></span><span class="hidden-xs"> <?= $vew_lang->save; ?></span></a>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '98'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-danger" title="<?= $vew_lang->cancel; ?>"><span class="fas fa-times"></span><span class="hidden-xs"> <?= $vew_lang->cancel; ?></span></a>				
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<?php if ($vew_actcod!='01') { ?>
					<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '99'});" class="btn btn-default navbar-btn" title="<?= $vew_lang->refresh; ?>"><span class="fas fa-sync"></span></a>
					<li class="btn navbar-text tmss-navbar-sep">|</li>
				<?php } ?>
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn btn-default navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
  </nav>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<input type="hidden" id="slsprccod" name="slsprccod" value="<?= $vew_data->slsprccod; ?>">
		<input type="hidden" id="slsprcvercod" name="slsprcvercod" value="<?= $vew_data->slsprcvercod; ?>">
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->source; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab999" role="tab" data-toggle="tab"><?= $vew_lang->additionalinfo; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->slsprclstcod; ?><input type="hidden" id="slsprclstcod" name="slsprclstcod" value="<?= $vew_data->slsprclstcod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
						
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-5">
							<?php
								echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('slsprclstcodext', 'doccmt1x20', $vew_data->slsprclstcodext, $lv_default) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('slsprclstcodext', 'doccmt1x20', $vew_data->slsprclstcodext, $lv_default) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('slsprclstcodext', 'doccmt1x20', $vew_data->slsprclstcodext, $lv_default) ));
							
								echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('slsprclstcodext', 'doccmt1x20', $vew_data->slsprclstcodext, $lv_default) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('slsprclsttxt', 'doccmt1x50', $vew_data->slsprclsttxt, $lv_default) ));
								echo vew_boot($lv_col255, array('label'=>$vew_lang->currency,
																								'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->slsprclstcod==''?$vew_readonly:true) ), 
																																		array('input'=>gethtml('curcod', 'curcod', $vew_data->curcod, ($vew_data->slsprclstcod==''?$lv_default:$lv_always_disabled) ) ))
																							 ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->status,		'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
							?>
						</div>
						<div class="col-md-7">
						</div>
					</div>
				</div> <!-- fin _tab001 -->

				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<textarea id="slsprclst" name="slsprclst" class="hidden"></textarea>
					<div id="slsprclsthot" name="slsprclsthot"></div>
				</div> <!-- fin _tab002 -->

				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab999">
					<?php
						echo vew_boot($lv_col210, array('label'=>$vew_lang->createdby, 	'input'=>gethtml('', 'usrcod', $vew_data->cteusr, $lv_always_disabled) ));
						echo vew_boot($lv_col210, array('label'=>$vew_lang->createddate,'input'=>gethtml('', 'dtetme', $vew_data->ctedte, $lv_always_disabled) ));
						echo vew_boot($lv_col210, array('label'=>$vew_lang->updatedby, 	'input'=>gethtml('', 'usrcod', $vew_data->updusr, $lv_always_disabled) ));
						echo vew_boot($lv_col210, array('label'=>$vew_lang->updateddate,'input'=>gethtml('', 'dtetme', $vew_data->upddte, $lv_always_disabled) ));
					?>
				</div>	<!-- tab999 -->

			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->    
	</form>
	<script>
		// curcod
		$("#<?= $lv_sec; ?> #curcod").next("span").children("a:first").on("click", function(evt) {
			tmssPopup("<?= $vew_lang->currency; ?>","?prg=admcur&prm_vewcod=VEW_ADM_CUR_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[curcod:curcod]");
			evt.preventDefault();
		});
	</script>
	<script>
		/**
		 *
		 *	P R E C I O S
		 *
		 */
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if ( prop=="slsprcsrctxt" ) {
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else if ( prop=="slsprcsrccod" || prop=="slsprcuntcod" ) {
				Handsontable.renderers.TextRenderer.apply(this, arguments);			
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else if ( prop=="slsprcsrcprc" ) {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);			
				td.style.backgroundColor = "#F1F1F1";
			} else {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);			
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #slsprclsthot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 230,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?'0':'1'); ?>,
			colHeaders: [ "ID", "Descripcion", "Origen", "Variacion", "Precio", "Cantidad", "UM" ],
			columns: [				
				{type: "text", data: "slsprcsrccod", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "autocomplete", data: "slsprcsrctxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						if ( <?= $lv_sec; ?>_hot_paste==false ) {
							
							switch ( "<?= $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'srcobjtyp'); ?>" ) {
								case "STK_MAT":
									$.ajax({
										url:"?prg=stkmat&act=17", dataType:"json", data:{prm_mattxt: query},
										complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
										success: function (response) {
											var lv_dat = [];
											<?= $lv_sec; ?>_hotdocchg = [];
											for (var i=0; i < response.data.length; i++) {
												<?= $lv_sec; ?>_hotdocchg.push( {slsprcsrctxt: response.data[i]["mattxt"], slsprcsrctyp: "STK_MAT", slsprcsrccod: response.data[i]["matcod"], slsprcuntcod: response.data[i]["matuntcod"], matcst: response.data[i]["matcst"]} );
												lv_dat.push( response.data[i]["mattxt"] );
											}
											process( lv_dat );
										}
									});
									break;
								case "EDU_MOD":
									$.ajax({
										url:"?prg=edumod&act=17", dataType:"json", data:{prm_edumodtxt: query},
										complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
										success: function (response) {
											var lv_dat = [];
											<?= $lv_sec; ?>_hotdocchg = [];
											for (var i=0; i < response.data.length; i++) {
												<?= $lv_sec; ?>_hotdocchg.push( {slsprcsrctxt: response.data[i]["edumodtxt"], slsprcsrctyp: "EDU_MOD", slsprcsrccod: response.data[i]["edumodcod"], slsprcuntcod: "UN", matcst: 0} );
												lv_dat.push( response.data[i]["edumodtxt"] );
											}
											process( lv_dat );
										}
									});
									break;
							}
							
						}
					},
					strict: true
				},
				{type: "numeric", data: "slsprcsrcprc", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "slsprcvar", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "slsprc", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "slsprcqty", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "slsprcuntcod", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>}
			],
			afterChange: function(changes, source) {
				if (changes!=null && <?= $lv_sec; ?>_hot_paste==false ) {
					for( var i=0; i<changes.length; i++) {
						if ( (source=="edit" || source=="paste") && changes[i][1]=="slsprcsrccod" ) {
							var lv_value = changes[i][3];
							
							switch ( "<?= $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'srcobjtyp'); ?>" ) {
								case "STK_MAT":
									$.ajax({
										url: "?prg=stkmat&act=19", dataType: "json", data: { prm_matcodext: lv_value, prm_row: changes[i][0] },
										complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
										success: function (response) {
											if( response.row!=undefined){
												var lv_row = response.row;
												if ( response.data.length==0 ) { 
													response.data.push([]); 
												}
												<?= $lv_sec; ?>_hot_paste = true;
												<?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"slsprcsrccod", (response.data[0]["matcod"]!=undefined?response.data[0]["matcod"]:"") );
												<?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"slsprcsrctxt", (response.data[0]["mattxt"]!=undefined?response.data[0]["mattxt"]:"") );
												<?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"slsprcsrcprc", (response.data[0]["matcst"]!=undefined?response.data[0]["matcst"]:"") );
												<?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"slsprcuntcod", (response.data[0]["matuntcod"]!=undefined?response.data[0]["matuntcod"]:"") );
												<?= $lv_sec; ?>_hot_paste = false;
											}
										}
									});
									break;
							}
							
						}
					}
				}
			},
			beforeChange : function(changes, source) {
				var lv_value = changes[0][3];
				if (source=="edit" && changes[0][1]=="slsprcsrctxt") {
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].slsprcsrctxt == lv_value) {
							changes.push([ changes[0][0], "slsprcsrctyp", "", String(<?= $lv_sec; ?>_hotdocchg[i].slsprcsrctyp) ]);
							changes.push([ changes[0][0], "slsprcsrccod", "", String(<?= $lv_sec; ?>_hotdocchg[i].slsprcsrccod) ]);
							changes.push([ changes[0][0], "slsprcqty", "", "1" ]);
							changes.push([ changes[0][0], "slsprcuntcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].slsprcuntcod) ]);
						}
					}
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["slsprcsrccod"]!="" && lv_dat[i]["slsprcsrccod"]!=undefined ) {
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
			}
		};
		var <?= $lv_sec; ?>_hotdoc;	
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [<?php
				$lv_buffer = '';
				foreach( $vew_data->slsprclst as $lv_row) {
					$lv_buffer .= ($lv_buffer==''?'':', ').
										'{slsprclstprccod: "'.$lv_row['slsprclstprccod'].'",'.
										'slsprcsrcprc: "'.(isset($lv_row['slsprcsrcprc'])?$lv_row['slsprcsrcprc']:0).'",'.
										'slsprcsrctyp: "'.$lv_row['slsprcsrctyp'].'",'.
										'slsprcsrccod: "'.$lv_row['slsprcsrccod'].'",'.
										'slsprcsrctxt: "'.$lv_row['slsprcsrctxt'].'",'.
										'slsprcvar: '.($lv_row['slsprcvar']==null?0:$lv_row['slsprcvar']).' ,'.
										'slsprc: '.$lv_row['slsprc'].' ,'.
										'slsprcqty: '.$lv_row['slsprcqty'].' ,'.
										'slsprcuntcod: "'.$lv_row['slsprcuntcod'].'"}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
	<script>
		// slsprclsttxt - typeahead
		tmssLoadScript("typeahead",function(){
			$("#<?= $lv_sec; ?> #slsprclstancprctxt").typeahead({
				onSelectAjaxData: function(data) { $("#<?= $lv_sec; ?> #slsprclstancprccod").prop("value", data.data.slsprclstcod); },
				ajax: {
					url: "?prg=slsprc&act=18",
					timeout: 500,
					displayField: "slsprclsttxt",
					valueField: "slsprclsttxt",
					triggerLength: 1,
					method: "get",
					loadingClass: "fa fa-spinner",
					preDispatch: function (query) { return {prm_slsprclsttxt: query}; },
					preProcess: function (data) { return (data.length==0?false:data); }
				}
			}).on("keyup", function(){ if($(this).prop("value")==""){$("<?= $lv_sec; ?> #slsprclstancprccod").prop("value","");} })
				.next().next("span").children("a:first").on("click", function(evt) {
					tmssPopup("<?= $vew_lang->pricelist; ?>","?prg=slsprc&prm_vewcod=VEW_SLS_PRC_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldflt=[docsts:A]&prm_fldasg=[slsprclstancprccod:slsprclstcod],[slsprclstancprctxt:slsprclsttxt]");
					evt.preventDefault();
			});
		});
		
		// versiones
		$("#<?= $lv_sec; ?> #btnver").on("click",function(e){
			tmssPopup("<?= $vew_lang->versions; ?>","?prg=slsprcver&act=08&prm_vewcod=VEW_SLS_PRC_VER_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[slsprcvercod:pv.slsprcvercod]&prm_fldflt=[pv.slsprclstcod:"+$("#<?= $lv_sec; ?> #slsprclstcod").prop("value")+"]");
			e.preventDefault();
			e.stopPropagation();
		});
		
		$("#<?= $lv_sec; ?> #slsprcvercod").on("change",function(e){
			toastr.info("Visualizando documento <strong>"+$("#<?= $lv_sec; ?> #slsprcvercod").prop("value")+"</strong>");
			tmssLink("?prg=slsprc&act=03&prm_slsprclstcod="+$("#<?= $lv_sec; ?> #slsprclstcod").prop("value")+"&prm_slsprcvercod="+$("#<?= $lv_sec; ?> #slsprcvercod").prop("value"), [{ target: "_replace_with", target_id: "<?= $lv_sec; ?>" }] );
		});
		
		$(function(){
			$("#<?= $lv_sec; ?> #slsprclstancsrc").on("change",function(){
				if($(this).find("option:selected").prop("value")=="2"){
					$("#<?= $lv_sec; ?> #slsprclstancdiv").removeClass("hidden");
				} else {
					$("#<?= $lv_sec; ?> #slsprclstancdiv").addClass("hidden");
				}
			});
			$("#<?= $lv_sec; ?> #slsprclstancsrc").trigger("change");
		});
		
	$("#<?= $lv_sec; ?> #btnupd").on("click",function(e){
		BootstrapDialog.confirm({
			title: "Actualizar Precios",
			message: "Desea actualizar la lista de precios?",
			type: BootstrapDialog.TYPE_INFO,
			callback: function(result){
				if(result){
					var lv_pstdat = [{name:"slsprclstcod",value:"<?= $vew_data->slsprclstcod; ?>"}]
					tmssCallProcess("?prg=slsprc&act=<?= ($vew_data->slsprclstancsrc=='1'?'06':'07'); ?>", lv_pstdat, function(data){
						<?= $lv_sec; ?>_fnc({action: '99'});
					});
				}
			}
		});
		e.preventDefault();
		e.stopPropagation();
	});
	</script>
	<script>
    var gv_<?= $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $("#<?= $lv_sec; ?>_frm"), "<?= $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    });

		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			
			if (lp_prm["action"]=="00") {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
				
				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["slsprcsrccod"]!="" && lo_dat[i]["slsprcsrccod"]!=undefined ){
						lv_arr.push({	"slsprclstprccod":lo_dat[i]["slsprclstprccod"],
													"slsprcsrctyp":lo_dat[i]["slsprcsrctyp"],
													"slsprcsrccod":lo_dat[i]["slsprcsrccod"],
													"slsprcsrctxt":lo_dat[i]["slsprcsrctxt"],
													"slsprcsrcprc":lo_dat[i]["slsprcsrcprc"],
													"slsprcvar":lo_dat[i]["slsprcvar"],
													"slsprc":lo_dat[i]["slsprc"],
													"slsprcqty":lo_dat[i]["slsprcqty"],
													"slsprcuntcod":lo_dat[i]["slsprcuntcod"]
												});
					}
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({	"slsprclstprccod":<?= $lv_sec; ?>_hotdocdel[i]["slsprclstprccod"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #slsprclst").text("");
				} else {
					$("#<?= $lv_sec; ?> #slsprclst").text( JSON.stringify( lv_arr ) );
				}
			}
			
			gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
			var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':'03'); ?>":gv_<?= $lv_sec; ?>_last_action);
			tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
		}

		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	</script>
</section>
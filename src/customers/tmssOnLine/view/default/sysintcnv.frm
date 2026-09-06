<?php
	/* url del formulario */
  $lv_lnk = "?prg=sysintcnv&prm_sysintcod=".$vew_data->sysintcod;

	/* campos requeridos */
	$vew_input->RequiredFields( );

	/* clave del documento */
	$lv_dockey = $vew_data->sysintcod;

	/* titulo */
	$lv_title = $vew_lang->conversions;
	
	/* m?dulo y programa */
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'ITV'; 

	/* librer?a de estilos bootstrap */
	include_once('_library.frm');
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02')) { ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '02'});"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->modify; ?>"><span class="fas fa-pencil-alt"></span><span class="hidden-xs"> <?= $vew_lang->modify; ?></span></a><?php } ?>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '00'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success" title="<?= $vew_lang->save;  ?>"><span class="far fa-save"></span><span class="hidden-xs"> <?= $vew_lang->save; ?></span></a>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '98'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-danger" title="<?= $vew_lang->cancel; ?>"><span class="fas fa-times"></span><span class="hidden-xs"> <?= $vew_lang->cancel; ?></span></a>				
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<?php if ($vew_actcod!='01') { ?>
					<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '99'});" class="btn btn-default navbar-btn" title="<?= $vew_lang->refresh; ?>"><span class="fas fa-sync-alt"></span></a>
					<li class="btn navbar-text tmss-navbar-sep">|</li>
				<?php } ?>
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn btn-default navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
  </nav>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<input type="hidden" id="sysintcod" name="sysintcod" value="<?= $vew_data->sysintcod; ?>">
		<textarea class="hidden" id="sysintcnvlst" name="sysintcnvlst"></textarea>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab999" role="tab" data-toggle="tab"><?= $vew_lang->additionalinfo; ?></a></li>
      </ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div id="sysintcnvhot"></div>
				</div> <!-- fin _tab001 -->
				
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
		var <?= $lv_sec; ?>_hotcnv_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if (<?= $lv_sec; ?>_hotcnv!=undefined) {
				var lv_ro_color = "#F1F1F1";
				var lv_color = "#FFFFFF";
				var lv_ro = <?php echo($vew_readonly?'true':'false'); ?>;
				
				Handsontable.renderers.TextRenderer.apply(this, arguments);			
				td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
				cellProperties.readOnly = (lv_ro?true:false);
			}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotcnvchg = [];
		var <?= $lv_sec; ?>_hotcnvdel = [];
		var <?= $lv_sec; ?>_hotcnvcnt = $("#<?= $lv_sec; ?> #sysintcnvhot")[0];
		var <?= $lv_sec; ?>_hotcnvset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Key", "In 1", "In 2", "Out 1", "Out 2"],
			columns: [
				{type: "text", data: "sysintcnvkey",    renderer: <?= $lv_sec; ?>_hotcnv_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "text", data: "sysintcnvinb001", renderer: <?= $lv_sec; ?>_hotcnv_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "text", data: "sysintcnvinb002", renderer: <?= $lv_sec; ?>_hotcnv_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "text", data: "sysintcnvout001", renderer: <?= $lv_sec; ?>_hotcnv_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "text", data: "sysintcnvout002", renderer: <?= $lv_sec; ?>_hotcnv_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> }
			],
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotcnv.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["sysintcnvcod"]!="" && lv_dat[i]["sysintcnvcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotcnvdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotcnv;	

		// cargo datos en handsontable
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotcnv = new Handsontable(<?= $lv_sec; ?>_hotcnvcnt, <?= $lv_sec; ?>_hotcnvset);	
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->sysintcnvlst as $lv_row){ 
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
											'sysintcnvcod:"'.$lv_row['sysintcnvcod'].'",'.
											'sysintcnvkey:"'.$lv_row['sysintcnvkey'].'",'.
											'sysintcnvinb001:"'.$lv_row['sysintcnvinb001'].'",'.
											'sysintcnvinb002:"'.$lv_row['sysintcnvinb002'].'",'.
											'sysintcnvout001:"'.$lv_row['sysintcnvout001'].'",'.
											'sysintcnvout002:"'.$lv_row['sysintcnvout002'].'"'.
											'}'; 
										}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotcnv.loadData( lv_dat );
			<?= $lv_sec; ?>_hotcnv.render();
		});
	</script>

  <script>
    var gv_<?= $lv_sec; ?>_last_action='';

		// server response
    tmssLinkForm( $('#<?= $lv_sec; ?>_frm'), '<?= $lv_lnk; ?>', function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, '<?= $lv_title; ?>', '<b><?= $lv_dockey; ?></b>' ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=='04') {
					tmssTabSecCls( $('#<?= $lv_sec; ?>') );
				} else {
					$('#<?= $lv_sec; ?>').replaceWith( data );
				}
			}
    });
		
		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			if(lp_prm['action']=='00') {
				var lo_dat = <?= $lv_sec; ?>_hotcnv.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["sysintcnvkey"]!="" && lo_dat[i]["sysintcnvkey"]!=undefined ) {
						lv_arr.push({	"sysintcnvcod":lo_dat[i]["sysintcnvcod"],
													"sysintcnvkey":lo_dat[i]["sysintcnvkey"],
													"sysintcnvinb001":lo_dat[i]["sysintcnvinb001"],
													"sysintcnvinb002":lo_dat[i]["sysintcnvinb002"],
													"sysintcnvout001":lo_dat[i]["sysintcnvout001"],
													"sysintcnvout002":lo_dat[i]["sysintcnvout002"]
												});
					}
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotcnvdel.length; i++) {
					lv_arr.push({	"sysintcnvcod":<?= $lv_sec; ?>_hotcnvdel[i]["sysintcnvcod"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #sysintcnvlst").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #sysintcnvlst").prop("value", JSON.stringify( lv_arr ) );
				}
			}
			
			gv_<?= $lv_sec; ?>_last_action = lp_prm['action'];
			var lv_action = (gv_<?= $lv_sec; ?>_last_action=='99'?'<?= ($vew_actcod=='02'?'02':'03'); ?>':gv_<?= $lv_sec; ?>_last_action);
			tmssMessageProcessing( '<?= $lv_sec; ?>', lv_action, '<?= $lv_title; ?>', '<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>' );
		}

		// edit mode
    tmssFormEdit('<?= $lv_sec; ?>',<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>
</section>
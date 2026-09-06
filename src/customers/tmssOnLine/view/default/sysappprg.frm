<?php		
	// url del formulario
  $lv_lnk = '?prg=sysappprg';

	// campos requeridos
	$vew_input->RequiredFields( array('mdlcod2','prgcod2','prgtxt','prgtypcod','prgord','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->prgcod; 

	// titulo
	$lv_title = $vew_lang->program;
	
	// m?dulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'PRG';
	
	// librer?a de estilos bootstrap
	include_once('_library.frm');
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('mdlcod','hidden',$vew_data->mdlcod); ?>
    <?= gethtml('prgcod','hidden',$vew_data->prgcod); ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab004" role="tab" data-toggle="tab"><?= $vew_lang->texts; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->prgcodext; ?><input type="hidden" id="prgcodext" name="prgcodext" value="<?= $vew_data->prgcodext; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->program; ?></div></div>
								<div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col237, array("label"=>$vew_lang->module,
																						"input1"=>vew_boot(	array("style"=>"search", "readonly"=>$vew_readonly ),
																																array("input"=>gethtml("mdlcod2", "mdlcod", $vew_data->mdlcod, ($vew_data->mdlcod==''?$lv_default:$lv_always_disabled) ) )),
																						"input2"=>gethtml("mdltxt", "mdltxt", $vew_data->mdltxt, $lv_always_disabled) ));
										echo vew_boot($lv_col237, array("label"=>$vew_lang->program,
																						"input1"=>gethtml("prgcod2", "prgcod", $vew_data->prgcod, ($vew_data->prgcod==''?$lv_default:$lv_always_disabled) ),
																						"input2"=>gethtml("prgtxt", "prgtxt", $vew_data->prgtxt, $lv_default) ));
									?>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label" for="prgtypcod"><?= $vew_lang->type; ?></label>
										<div class="col-sm-10"><?= gethtml('prgtypcod',array(''=>'','1'=>'Programa','2'=>'Separador','3'=>'Carpeta'), $vew_data->prgtypcod); ?></div>
									</div>
									<?php
										echo vew_boot($lv_col210, array('label'=>$vew_lang->order,  'input'=>gethtml('prgord', 'docnum0500', $vew_data->prgord, $lv_default) )); 
										echo vew_boot($lv_col210, array('label'=>'Nodo Superior', 	'input'=>gethtml('prgmnupar', 'doccmt1x20', $vew_data->prgmnupar, $lv_default) )); 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); 
									?>
								</div>
							</div>
						</div>
						<div class="col-md-6">
							<div class="card" id="fields">
								<div class="card-header"><div class="card-title"><?= $vew_lang->access; ?></div></div>
								<div class="card-body tmss-card-body-edit">
									<?php	
										echo vew_boot($lv_col210, array('label'=>'ID Carpeta',  			'input'=>gethtml('prgmnuchl', 'doccmt1x20', $vew_data->prgmnuchl, $lv_default) )); 
										echo vew_boot($lv_col210, array('label'=>'Vista',  						'input'=>gethtml('vewcod', 		'doccmt1x30', $vew_data->vewcod, 		$lv_default) )); 							
										echo vew_boot($lv_col210, array('label'=>$vew_lang->form,  		'input'=>gethtml('prgfrm', 'doccmt1x250', $vew_data->prgfrm, $lv_default) )); 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->hidden, 	'input'=>gethtml('prghde', 'yesno', $vew_data->prghde, $lv_default) )); 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->language, 'input'=>gethtml('syslngcod', 'doccmt1x20', $vew_data->objlng, $lv_default) )); 
										$vew_data->prgpic = strtolower($vew_data->prgpic);
										echo vew_boot($lv_col291, array('label'=>$vew_lang->image,  	
																							'input1'=>gethtml('prgpic', 'doccmt1x50', $vew_data->prgpic,	$lv_default),
																							'input2'=>($vew_data->prgpic==''?'':(substr($vew_data->prgpic,0,6)=='class:'?'<span class="'.substr($vew_data->prgpic,6,strlen($vew_data->prgpic)-6).'"></span>':'<div class="center-text"><img class="img-responsive" src="/library/images/'.$vew_data->prgpic.'"></div>'))	)); 
									?>
								</div>
							</div>						
							<div class="card tmss-hot-ttl" id="prgoprdiv">
								<div class="card-header"><div class="card-title">Operaciones</div></div>
							</div>
							<textarea class="hidden" id="prgopr" name="prgopr"></textarea>
							<div id="prgoprhot"></div>
						</div>
					</div>
				</div> <!-- fin _tab001 -->

				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab004">
					<div class="row">
						<div class="col-md-2">
							<div class="list-group">
								<?php
									foreach($vew_data->txttyp as $lv_row) {
										echo '<button type="button" class="list-group-item" id="grldattxt_btn" data-txttypcod="'.$lv_row['txttypcod'].'">'.$lv_row['txttyptxt'].'</button>';
									}
								?>
							</div>
						</div>
						<div class="col-md-10">
							<input type="hidden" name="lngcod" id="lngcod" value="ES">
							<?php
								foreach($vew_data->txttyp as $lv_row) {
									$lv_dat = array();
									$lv_dat['txttypcod'] = $lv_row['txttypcod'];
									$lv_dat['txtcod'] = '';
									$lv_dat['txttxt'] = '';
									foreach($vew_data->txt as $lv_rowtxt) {
										if ( $lv_rowtxt['txttypcod']==$lv_row['txttypcod']) {
											$lv_dat['txtcod'] = $lv_rowtxt['txtcod'];
											$lv_dat['txttxt'] = $lv_rowtxt['txttxt'];
											break;
										}
									}
									echo '<input type="hidden" id="grldattxt_cod_'.$lv_dat['txttypcod'].'" name="grldattxt_cod_'.$lv_dat['txttypcod'].'" value="'.$lv_dat['txtcod'].'">';
									echo '<textarea id="'.$lv_sec.'_grldattxt_txt_'.$lv_dat['txttypcod'].'" name="grldattxt_txt_'.$lv_dat['txttypcod'].'" data-txttypcod="'.$lv_dat['txttypcod'].'">'.$lv_dat['txttxt'].'</textarea>';
								}
							?>
						</div>
					</div>
				</div> <!-- fin _tab004 -->
				
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
    
  </form>

	<script>
		$("#<?= $lv_sec; ?> #prgtypcod").on("change",function(e){
			if( $(this).prop("value")=="" ) {
				$("#<?= $lv_sec; ?> #fields").hide();
			} else if( $(this).prop("value")=="2" ) {
				$("#<?= $lv_sec; ?> #fields").show();
				$("#<?= $lv_sec; ?> #prgoprdiv").hide();
				$("#<?= $lv_sec; ?> #prgmnuchl").parent().parent().hide();
				$("#<?= $lv_sec; ?> #vewcod").parent().parent().hide();
				$("#<?= $lv_sec; ?> #prgfrm").parent().parent().hide();
				$("#<?= $lv_sec; ?> #prghde").parent().parent().hide();
				$("#<?= $lv_sec; ?> #syslngcod").parent().parent().hide();
				$("#<?= $lv_sec; ?> #prgpic").parent().parent().hide();
			} else if($(this).prop("value")=="3") {
				$("#<?= $lv_sec; ?> #fields").show();
				$("#<?= $lv_sec; ?> #prgoprdiv").hide();
				$("#<?= $lv_sec; ?> #prgmnuchl").parent().parent().show();
				$("#<?= $lv_sec; ?> #vewcod").parent().parent().hide();
				$("#<?= $lv_sec; ?> #prgfrm").parent().parent().hide();
				$("#<?= $lv_sec; ?> #prghde").parent().parent().hide();
				$("#<?= $lv_sec; ?> #syslngcod").parent().parent().show();
				$("#<?= $lv_sec; ?> #prgpic").parent().parent().show();
			} else {
				$("#<?= $lv_sec; ?> #fields").show();
				$("#<?= $lv_sec; ?> #prgoprdiv").show();
				$("#<?= $lv_sec; ?> #prgmnuchl").parent().parent().hide();
				$("#<?= $lv_sec; ?> #vewcod").parent().parent().show();
				$("#<?= $lv_sec; ?> #prgfrm").parent().parent().show();
				$("#<?= $lv_sec; ?> #prghde").parent().parent().show();
				$("#<?= $lv_sec; ?> #syslngcod").parent().parent().show();
				$("#<?= $lv_sec; ?> #prgpic").parent().parent().show();
			}
		});
		
		tmssLoadScript("tinymce", function(){
			// editores de texto			
			tinyMCE.init({ 
				selector: "#<?= $lv_sec; ?>_tab004 textarea", 
				paste_data_images: true,
				height: 300, 
				menubar: false
				<?= ($vew_readonly?', readonly: 1':''); ?>
			});
			$("#<?= $lv_sec; ?> #grldattxt_btn:first").trigger("click");
			
			// tipo de programa
			$("#<?= $lv_sec; ?> #prgtypcod").trigger("change");
		});
	</script>
	<script>
		/**
		 *
		 *	O P E R A C I O N E S
		 *
		 */
		var <?= $lv_sec; ?>_hotopr_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
		};
		var <?= $lv_sec; ?>_hotoprtmpchg = [];
		var <?= $lv_sec; ?>_hotoprtmpdel = [];
		var <?= $lv_sec; ?>_hotoprcnt = $("#<?= $lv_sec; ?> #prgoprhot")[0];
		var <?= $lv_sec; ?>_hotoprset = {
			height: 196,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: 1,
			colHeaders: [ "Cod", "Nombre", "Imagen", "Grilla" ],
			columns: [
				{type: "text", data: "oprcod", renderer: <?= $lv_sec; ?>_hotopr_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "text", data: "oprtxt", renderer: <?= $lv_sec; ?>_hotopr_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "text", data: "oprpic", renderer: <?= $lv_sec; ?>_hotopr_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "text", data: "oprshwgrd", renderer: <?= $lv_sec; ?>_hotopr_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>}
			],
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotopr.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]['oprcod']!='' && lv_dat[i]['oprcod']!=undefined ) {
						<?= $lv_sec; ?>_hotoprtmpdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotopr;
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotopr = new Handsontable(<?= $lv_sec; ?>_hotoprcnt, <?= $lv_sec; ?>_hotoprset);	
			var lv_dat = [<?php
				$lv_buffer = '';
				foreach( $vew_data->opr as $lv_row) {
					$lv_buffer .= ($lv_buffer==''?'':', ').'{oprcod: "'.$lv_row['oprcod'].'", oprtxt: "'.$lv_row['oprtxt'].'", oprpic: "'.$lv_row['oprpic'].'", oprshwgrd: "'.$lv_row['oprshwgrd'].'"}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotopr.loadData( lv_dat );
			<?= $lv_sec; ?>_hotopr.render();
		});
	</script>
  <script>
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {				
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				// obtengo datos de handsontable de roles
				var lo_dat = <?= $lv_sec; ?>_hotopr.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["oprcod"]!="" && lo_dat[i]["oprcod"]!=undefined ){
						lv_arr.push({	"oprcod":lo_dat[i]["oprcod"],
													"oprtxt":lo_dat[i]["oprtxt"],
													"oprpic":lo_dat[i]["oprpic"],
													"oprshwgrd":lo_dat[i]["oprshwgrd"],
													"docsts":"A"
												});
					}
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotoprtmpdel.length; i++) {
					lv_arr.push({	"oprcod":<?= $lv_sec; ?>_hotoprtmpdel[i]["oprcod"],
												"oprtxt":<?= $lv_sec; ?>_hotoprtmpdel[i]["oprtxt"],
												"oprpic":<?= $lv_sec; ?>_hotoprtmpdel[i]["oprpic"],
												"oprshwgrd":<?= $lv_sec; ?>_hotoprtmpdel[i]["oprshwgrd"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #prgopr").text("");						
				} else {
					$("#<?= $lv_sec; ?> #prgopr").text( JSON.stringify( lv_arr ) );
				}
				
				// actualizo textareas de los editores
				tinyMCE.triggerSave();
				
			}
		}
  </script>
	
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
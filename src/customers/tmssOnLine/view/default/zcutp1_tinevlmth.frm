<?php
	// url del formulario 
  $lv_lnk = '?prg=zcutp1&prm_evlcod='.$vew_data->evlcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('patcod','pattxt','prscod','prstxt','spccod','spctxt','docsts','plnid','plndteid') );

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
	$lv_buf ='';
	/*
	if ($vew_data->evlcod=='') {
		$vew_data->evlmthprc = '';
	} else if ($vew_data->docsts=='A') {
		$vew_data->evlmthprc = '1';
	} else {
		$vew_data->evlevl = strtoupper($vew_data->evlevl);
		$lv_buf = $vew_doc->getTagValue($vew_data->evlevl,'row');
		$vew_data->evlmtv=strtoupper(utf8_decode($lv_buf,'evlmtv'));
		$vew_data->evlmtt=strtoupper(utf8_decode($lv_buf,'evlmtt'));
		$vew_data->evlhhs=strtoupper(utf8_decode($lv_buf,'evlhhs'));
		$vew_data->evltg1=strtoupper(utf8_decode($lv_buf,'evltg1'));
		$vew_data->evltg2=strtoupper(utf8_decode($lv_buf,'evltg2'));
		$vew_data->evltg3=strtoupper(utf8_decode($lv_buf,'evltg3'));
		$vew_data->evltg4=strtoupper(utf8_decode($lv_buf,'evltg4'));
		$vew_data->evltg5=strtoupper(utf8_decode($lv_buf,'evltg5'));
		$vew_data->evltg6=strtoupper(utf8_decode($lv_buf,'evltg6'));
		$vew_data->evltg7=strtoupper(utf8_decode($lv_buf,'evltg7'));
		$vew_data->evltg8=strtoupper(utf8_decode($lv_buf,'evltg8'));
		$vew_data->evltg9=strtoupper(utf8_decode($lv_buf,'evltg9'));
		if ($lv_buf!='') {
			$vew_data->evlmthprc = '0';
			$vew_data->evlcncmtv = strtoupper($vew_doc->getTagValue($lv_buf,'evlcncmtv'));
			$vew_data->evlcnccmt = $vew_doc->getTagValue($lv_buf,'evlcnccmt');
		}
	}
	*/
 	if ($vew_data->evlcod=='') {
		$vew_data->evlinfprc = '';
	}else{
		$vew_data->evlatrval001 = strtoupper($vew_data->evlatrval001);
	 	$lv_buf = $vew_doc->getTagValue($vew_data->evlatr001,'row');
	 	$vew_data->evlmthprc= strtoupper($vew_doc->getTagValue($lv_buf,'evlmthprc'));
	 	$vew_data->evlinfprc = strtoupper($vew_doc->getTagValue($lv_buf,'evlinfprc'));
	 	if ($vew_data->evlinfprc ==''){
	 		if ($vew_data->docsts=='A') {
				$vew_data->evlinfprc = '1';
			}	else{
	 			$vew_data->evlinfprc = '0';
	 		}
	 	}
	 	
	 	$vew_data->evlcncmtv = strtoupper($vew_doc->getTagValue($lv_buf,'evlcncmtv'));

	 	$vew_data->evlmtv=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlmtv')));
	 	$vew_data->evlmtt=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlmtt')));
	 	$vew_data->evlhhs=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlhhs')));
	 	$vew_data->evltg1=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg1')));
		$vew_data->evltg2=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg2')));
	  $vew_data->evltg3=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg3')));
		$vew_data->evltg4=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg4')));
		$vew_data->evltg5=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg5')));
		$vew_data->evltg6=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg6')));
		$vew_data->evltg7=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg7')));
		$vew_data->evltg8=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg8')));
		$vew_data->evltg9=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evltg9')));
	 	$vew_data->evlcnccmt=utf8_decode($vew_data->evlsub);
	 	$vew_data->evlevl = strtoupper($vew_data->evlevl);
	 	$vew_data->evlcnccmt=utf8_decode($vew_data->evlsub);
	 	$vew_data->evlevl = strtoupper($vew_data->evlevl);
	}

	$vew_data->evlevl=strtoupper(utf8_decode($vew_data->evlevl));
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
			</div>
			<div class="col-md-9">

				<nav class="navbar navbar-default tmss-navbar">
					<div class="container-fluid">
						<ul class="nav navbar-nav tmss-navbar-left">
							<?php if(!$vew_readonly) { ?><a href="#" onclick="<?php echo $lv_sec; ?>_fnc({action: 'evlmth00'});" class="btn btn-default navbar-btn tmssAlwaysEnabled btn-success" title="<?php echo $vew_lang->save;  ?>"><span class="fas fa-save"></span><span class="hidden-xs"> <?php echo $vew_lang->save; ?></span></a><?php } ?>
							<?php if ($vew_sec->hasPermission('HLT','EVL','04') && $vew_data->evlcod!='') { ?><a href="#" onclick="<?php echo $lv_sec; ?>_fnc({action: 'evlmthx4'});" class="btn btn-default navbar-btn tmssAlwaysEnabled btn-danger" title="<?php echo $vew_lang->delete; ?>"><span class="fas fa-trash-alt"></span><span class="hidden-xs"> <?php echo $vew_lang->delete; ?></span></a><?php } ?>
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
								echo vew_boot($lv_col210,array('label'=>'Se comunico?', 'input'=>gethtml('evlmthprc','yesno',$vew_data->evlmthprc,$lv_default) ));
							?>
							<div id="evlnoinf_div">
								<?php
									echo vew_boot($lv_col210,array('label'=>$vew_lang->comments, 'input'=>gethtml('evlmtv','doccmt5x50',$vew_data->evlmtv,$lv_default) ));
								?>
							</div>
							<div id="evlyesinf_div">
								<?php
									echo vew_boot($lv_col210,array('label'=>'Horario', 'input'=>gethtml('evlhhs','doccmt1x50',$vew_data->evlhhs,$lv_default) ));
								?>
									<label class="control-label"><?php echo 'Signos y Sintomas de RA'; ?></label>
								<div class="form-group tmss-form-group">
									<label class="col-sm-6 control-label">Locales</label>
									<div class="col-sm-6 "><input type="checkbox" id="frmclk" name="evltg1" <?php echo  $vew_data->evltg1=='ON'?'checked':''; ?>></div>
								</div>
								<div class="form-group tmss-form-group">
									<label class="col-sm-6 control-label">Fiebre / escalofr&iacute;os</label>
									<div class="col-sm-6 "><input type="checkbox" id="frmclk" name="evltg2" <?php echo  $vew_data->evltg2=='ON'?'checked':''; ?>></div>
								</div>								
								<div class="form-group tmss-form-group">
									<label class="col-sm-6 control-label">Sensaci&oacute;n de debilidad, decaimiento <small>(hipotensi&oacute;n)</small></label>
									<div class="col-sm-6 "><input type="checkbox" id="frmclk" name="evltg3" <?php echo  $vew_data->evltg3=='ON'?'checked':''; ?>></div>
								</div>
								<div class="form-group tmss-form-group">
									<label class="col-sm-6 control-label">Mareos</label>
									<div class="col-sm-6 "><input type="checkbox" id="frmclk" name="evltg4" <?php echo  $vew_data->evltg4=='ON'?'checked':''; ?>></div>
								</div>								
								<div class="form-group tmss-form-group">
									<label class="col-sm-6 control-label">Cefalea</label>
									<div class="col-sm-6 "><input type="checkbox" id="frmclk" name="evltg5" <?php echo  $vew_data->evltg5=='ON'?'checked':''; ?>></div>
								</div>
								<div class="form-group tmss-form-group">
									<label class="col-sm-6 control-label">Nauseas o v&oacute;mitos</label>
									<div class="col-sm-6 "><input type="checkbox" id="frmclk" name="evltg6" <?php echo  $vew_data->evltg6=='ON'?'checked':''; ?>></div>
								</div>								
								<div class="form-group tmss-form-group">
									<label class="col-sm-6 control-label">Tos</label>
									<div class="col-sm-6 "><input type="checkbox" id="frmclk" name="evltg7" <?php echo  $vew_data->evltg7=='ON'?'checked':''; ?>></div>
								</div>
								<div class="form-group tmss-form-group">
									<label class="col-sm-6 control-label">Dificultad para respirar</label>
									<div class="col-sm-6 "><input type="checkbox" id="frmclk" name="evltg8" <?php echo  $vew_data->evltg8=='ON'?'checked':''; ?>></div>
								</div>								
								<div class="form-group tmss-form-group">
									<label class="col-sm-6 control-label">Palpitaciones</label>
									<div class="col-sm-6 "><input type="checkbox" id="frmclk" name="evltg9" <?php echo  $vew_data->evltg9=='ON'?'checked':''; ?>></div>
								</div>	
								<br>
								<?php
									echo vew_boot($lv_col210,array('label'=>$vew_lang->evolution, 'input'=>gethtml('evlevl','doccmt5x50',$vew_data->evlevl,$lv_default) ));
								?>
								
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
												$lv_mtv = strtoupper($vew_doc->getTagValue($lv_str,'evlcncmtv'));
												$lv_txt = '<table class="table table-condensed">'.
																	'<tr><td width=50></td><td><strong>No se aplico</strong></td></tr>'.
																	'<tr><td>Motivo:</td><td>'.($lv_mtv=='SV'?'SIN VIALES':($lv_mtv=='EN'?'ENFERMEDAD':($lv_mtv=='ND'?'PACIENTE NO DISPONIBLE':($lv_mtv=='OT'?'OTROS':'(no identificado)')))).'</td></tr>'.
																	'<tr><td>Comentarios:</td><td>'.$vew_doc->getTagValue($lv_str,'evlcnccmt').'</td></tr>'.
																	'</table>';
												echo '<tr><td>'.$lv_dte.'</td><td>'.$lv_txt.'</td></tr>';
											} else if ( $vew_doc->getTagValue($lv_str,'evlqst')!='' ) {
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
			$("#<?php echo $lv_sec; ?> :checkbox[name='estado']").each( function() {
				$(this).bootstrapToggle({ onstyle: "success", offstyle: "danger", on: "Presente", off: "Ausente", size: "small",  });
				$(this).trigger("change");
			});
			$("#<?php echo $lv_sec; ?> :checkbox").each( function() {
					$(this).bootstrapToggle({ onstyle: "success", offstyle: "default", on: "Si", off: "No", size: "small" });
					$(this).trigger("change");
				});
		});

		$(function() {
			$("#<?php echo $lv_sec; ?> :checkbox[id='frmclk']").each( function() {
				 $(this).trigger("change");
			 });
		});

		$("#<?php echo $lv_sec; ?> #evlmthprc").on("change",function(e){
			if ( $(this).prop("value")=="0" ) {
				$("#<?php echo $lv_sec; ?> #evlcncmtv").addClass("tmssInputRequired").prop("placeholder","?");
				$("#<?php echo $lv_sec; ?> #evlcnccmt").addClass("tmssInputRequired").prop("placeholder","?");
				// $("#<?php echo $lv_sec; ?> #evlevl").removeClass("tmssInputRequired").prop("placeholder","?");
			} else {
				// $("#<?php echo $lv_sec; ?> #evlevl").addClass("tmssInputRequired").prop("placeholder","?");
				$("#<?php echo $lv_sec; ?> #evlcncmtv").removeClass("tmssInputRequired").prop("placeholder","?");
				$("#<?php echo $lv_sec; ?> #evlcnccmt").removeClass("tmssInputRequired").prop("placeholder","?");
			}
		});
		
		$(function(e){
			$("#<?php echo $lv_sec; ?> #evlmthprc").trigger("change");
			<?php
				$lv_plnpen='';
				foreach( $vew_rsplndte as $lv_row ) { $lv_plnpen .= $lv_row['plndte']->format('d/m/Y').'<br>'; }
				if($lv_plnpen!=''){ echo 'toastr.warning("El paciente <b>'.$vew_data->pattxt.'</b> tiene pendiente de evolucionar las siguientes fechas:<br>'.$lv_plnpen.'","ATENCION!");'; }
			?>
		});

		
		$("#<?php echo $lv_sec; ?> #evlmthprc").on("change",function(e){
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
				window.open("?prg=zcutp1&act=evlmthprn&prm_evlcod="+<?php echo $vew_data->evlcod; ?>);
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
    	//debugger;
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {

				if (lp_prm["action"]=="evlmthx4") {
					var lv_ok = 0;
					BootstrapDialog.confirm({
						title: 'Borrar Evolucion',
						message: '¿Desea borrar el documento ?',
						type: BootstrapDialog.TYPE_WARNING,
						callback: function(result) {
							if(result) { <?php echo $lv_sec; ?>_fnc({action: "evlmth04"}); }
						}
					});
					return false;
				}
				if (lp_prm["action"]=="evlmth00"){if(!tmssCheckRequiredFields($("#<?php echo $lv_sec; ?>_frm"))){return false;}}
				gv_<?php echo $lv_sec; ?>_last_action = lp_prm["action"];
				var lv_action = (gv_<?php echo $lv_sec; ?>_last_action=="99"?"<?php echo ($vew_actcod=='02'?'02':'03'); ?>":gv_<?php echo $lv_sec; ?>_last_action);
				tmssMessageProcessing( "<?php echo $lv_sec; ?>", lv_action, "<?php echo $lv_title; ?>", "" );
			}
		}

		// edit mode
    tmssFormEdit("<?php echo $lv_sec; ?>",<?php echo ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);

  </script>
</section>
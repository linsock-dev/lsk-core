<?php	
	/* url del formulario */
  $lv_lnk = '?prg=grldocrmd&prm_docrmdcod='.$vew_data->docrmdcod.'&prm_curdte='.$vew_data->curdte;

	/* campos requeridos */
	$vew_input->RequiredFields( array('docrmdtxt','docrmdtyp', 'docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->docrmdcod; 

	/* titulo */
	$lv_title = $vew_lang->reminder;
	
	/* modulo y programa */
	$lv_mdlcod = 'GRL';
	$lv_prgcod = 'RMD';

	/* librer?a de estilos bootstrap */
	include_once('_library.frm');
	
	/* valores X default */
	if( $vew_data->docrmdcod=='' ) {
		$vew_data->docrmdtyp = 'U';
		$vew_data->docsts = 'A';
	}
?>
<section id="<?= $lv_sec; ?>">

  <nav class="navbar navbar-default tmss-navbar">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '01'});"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->new; ?>"><span class="far fa-file"></span></a>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '001'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->copy; ?>"><span class="far fa-copy"></span></a>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '02'});"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->modify; ?>"><span class="fas fa-pencil-alt"></span></a>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '04'});"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->delete; ?>"><span class="fas fa-trash-alt"></span></a>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '00'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success" title="<?= $vew_lang->save;  ?>"><span class="far fa-save"></span><span class="hidden-xs">  <?= $vew_lang->save; ?></span></a>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '98'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-danger" title="<?= $vew_lang->cancel; ?>"><span class="fas fa-times"></span><span class="hidden-xs">  <?= $vew_lang->cancel; ?></span></a>
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<?php if($vew_data->srcobjtyp!=''){ ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: 'xx'});" class="btn btn-success navbar-btn tmssAlwaysEnabled btn-success" title="<?= $vew_lang->document; ?>"><span class="fas fa-link"></span><span class="hidden-xs"> <?= $vew_lang->document; ?></span></a><?php } ?>
				<a href="#" id="btnchk" class="btn <?= ($vew_data->docrmdlogcod==''?'btn-default':'btn-success'); ?> navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" data-docrmdlogcod="<?= $vew_data->docrmdlogcod; ?>"><?= ($vew_data->docrmdlogcod==''?'<span class="fas fa-check"></span>':'<span class="fas fa-check-double"></span>'); ?></a>
			</ul>
		</div>
  </nav>

	<form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
		<input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_docrmdtab01" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_docrmdtab02" role="tab" data-toggle="tab"><?= $vew_lang->additionalinfo; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->docrmdcod; ?><input type="hidden" id="docrmdcod" name="docrmdcod" value="<?= $vew_data->docrmdcod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">											
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_docrmdtab01">
					<?php
						echo vew_boot($lv_col210, array('label'=>$vew_lang->motive, 	 'input'=>gethtml('docrmdtxt','doccmt1x50', $vew_data->docrmdtxt,$lv_default) ));
						echo vew_boot($lv_col210, array('label'=>$vew_lang->comments,  'input'=>gethtml('docrmdlngtxt','doccmt4x50', $vew_data->docrmdlngtxt,$lv_default) ));						
						echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 	 'input'=>gethtml('docsts','docsts', $vew_data->docsts,$lv_default) ));
						echo vew_boot($lv_col210, array('label'=>$vew_lang->frequency, 'input'=>gethtml('docrmdtyp',array('U'=>'Unica Vez','PD'=>'Diario','PS'=>'Semanal','PM'=>'Mensual','PA'=>'Anual'),$vew_data->docrmdtyp,$lv_default) ));
					?>
					<div class="form-group tmss-form-group">
						<div class="col-sm-2"></div>
						<div class="col-sm-10">
							<div class="form-group tmss-form-group">
								<div class="col-sm-7">
									<div class="form-group tmss-form-group">
										<label class="control-label col-sm-2" id="dmcrmdstrdtelbl"> Desde </label>
										<div class="col-sm-10"><?= gethtml('docrmdstrdte','docdte', $vew_data->docrmdstrdte,$lv_default); ?></div>
										<div id="docrmdenddtediv">
										<label class="control-label col-sm-2"> Hasta </label>
										<div class="col-sm-10"><?= gethtml('docrmdenddte','docdte', $vew_data->docrmdenddte,$lv_default); ?></div>
										</div>
									</div>
								</div>
								<div class="col-sm-5">
									<div class="form-group tmss-form-group">
										<label class="control-label col-sm-2"> Hora </label>
										<div class="col-sm-10"><?= gethtml('docrmdstrtme','doctme', $vew_data->docrmdstrtme,$lv_default); ?></div>
									</div>
								</div>
							</div>
						</div>
					</div>
					
					<div id="docrmdtypPD" class="hidden">
						<div class="form-group tmss-form-group">
							<div class="col-sm-2"></div>
							<div class="col-sm-10">
								<div class="form-group tmss-form-group">
									<div class="control-label col-xs-2"><input type="checkbox" id="rmdfrqtypPD" name="rmdfrqtypPD001" <?= ($vew_doc->getTagValue($vew_data->docrmdfrq,'rmdfrqtyp')=='1'?'checked':''); ?> ></div>
									<label class="control-label col-xs-3 col-sm-2" style="text-align: left !important;">Cada</label>
									<div class="col-xs-4 col-sm-6"><?= gethtml('docrmdfrqechPD','docnum0300',$vew_doc->getTagValue($vew_data->docrmdfrq,'rmdech'),$lv_default); ?></div>
									<label class="control-label col-xs-3 col-sm-2" style="text-align: left !important;"> d&iacute;as</label>
								</div><br>
								<div class="form-group tmss-form-group">
									<div class="control-label col-xs-2"><input type="checkbox" id="rmdfrqtypPD" name="rmdfrqtypPD002" <?= ($vew_doc->getTagValue($vew_data->docrmdfrq,'rmdfrqtyp')=='2'?'checked':''); ?> ></div>
									<label class="control-label col-xs-10" style="text-align: left !important;"> Todos los d&iacute;as de la semana</label>
								</div>
							</div>
						</div>
					</div>
					
					<div id="docrmdtypPS" class="hidden">
						<div class="form-group tmss-form-group">
							<div class="col-sm-2"></div>
							<div class="col-sm-10 col-xs-12">
								<div class="form-group tmss-form-group">
									<label class="control-label col-xs-2" style="text-align: left !important;">Cada</label>
									<div class="col-xs-4"><?= gethtml('docrmdfrqechPS','docnum0300',$vew_doc->getTagValue($vew_data->docrmdfrq,'rmdech'),$lv_default); ?></div>
									<label class="control-label col-xs-6" style="text-align: left !important;">semanas el</label>
								</div>
								<div class="form-group tmss-form-group">
									<div class="col-xs-6 col-sm-3"><input type="checkbox" id="docrmdfrqwekdayPS" name="docrmdfrqwekdayPS001" <?= (substr($vew_doc->getTagValue($vew_data->docrmdfrq,'rmdwekday'),1,1)=='1'?'checked':''); ?>> Lun</div>
									<div class="col-xs-6 col-sm-3"><input type="checkbox" id="docrmdfrqwekdayPS" name="docrmdfrqwekdayPS002" <?= (substr($vew_doc->getTagValue($vew_data->docrmdfrq,'rmdwekday'),2,1)=='1'?'checked':''); ?>> Mar</div>
									<div class="col-xs-6 col-sm-3"><input type="checkbox" id="docrmdfrqwekdayPS" name="docrmdfrqwekdayPS003" <?= (substr($vew_doc->getTagValue($vew_data->docrmdfrq,'rmdwekday'),3,1)=='1'?'checked':''); ?>> Mie</div>
									<div class="col-xs-6 col-sm-3"><input type="checkbox" id="docrmdfrqwekdayPS" name="docrmdfrqwekdayPS004" <?= (substr($vew_doc->getTagValue($vew_data->docrmdfrq,'rmdwekday'),4,1)=='1'?'checked':''); ?>> Jue</div>
									<div class="col-xs-6 col-sm-3"><input type="checkbox" id="docrmdfrqwekdayPS" name="docrmdfrqwekdayPS005" <?= (substr($vew_doc->getTagValue($vew_data->docrmdfrq,'rmdwekday'),5,1)=='1'?'checked':''); ?>> Vie</div>
									<div class="col-xs-6 col-sm-3"><input type="checkbox" id="docrmdfrqwekdayPS" name="docrmdfrqwekdayPS006" <?= (substr($vew_doc->getTagValue($vew_data->docrmdfrq,'rmdwekday'),6,1)=='1'?'checked':''); ?>> Sab</div>
									<div class="col-xs-6 col-sm-3"><input type="checkbox" id="docrmdfrqwekdayPS" name="docrmdfrqwekdayPS007" <?= (substr($vew_doc->getTagValue($vew_data->docrmdfrq,'rmdwekday'),0,1)=='1'?'checked':''); ?>> Dom</div>
								</div>
							</div>
						</div>
					</div>
					
					<div id="docrmdtypPM" class="hidden">
						<div class="form-group tmss-form-group">
							<div class="col-sm-2"></div>
							<div class="col-sm-10 col-xs-12">
								<div class="form-group tmss-form-group">
									<div class="col-xs-2"><input type="checkbox" id="docrmdfrqtypPM" name="docrmdfrqtypPM001" <?= ($vew_doc->getTagValue($vew_data->docrmdfrq,'rmdtyp')=='1'?'checked':''); ?> ></div>
									<label class="control-label col-xs-3" style="text-align: left !important;"> El d&iacute;a </label>
									<div class="col-xs-7"><?= gethtml('docrmdfrqdayPM','docnum0300',$vew_doc->getTagValue($vew_data->docrmdfrq,'rmdday'),$lv_default); ?></div>
									<label class="control-label col-xs-5"> de cada </label>
									<div class="col-xs-5"><?= gethtml('docrmdfrqech001PM','docnum0300',$vew_doc->getTagValue($vew_data->docrmdfrq,'rmdech'),$lv_default); ?></div>
									<label class="control-label col-xs-2"  style="text-align: left !important;">meses</label>
								</div><br>
								<div class="form-group tmss-form-group">
									<div class="col-xs-2"><input type="checkbox" id="docrmdfrqtypPM" name="docrmdfrqtypPM002" <?= ($vew_doc->getTagValue($vew_data->docrmdfrq,'rmdtyp')=='2'?'checked':''); ?> ></div>
									<label class="control-label col-xs-2" style="text-align: left !important;"> El </label>
									<div class="col-xs-4"><?= gethtml('docrmdfrqdaytypPM',array('1'=>'Primer','2'=>'Segundo','3'=>'Tercer','4'=>'Cuarto','L'=>'Ultimo'),$vew_doc->getTagValue($vew_data->docrmdfrq,'rmddaytyp'),$lv_default); ?></div>
									<div class="col-xs-4"><?= gethtml('docrmdfrqwekdayPM',array('2'=>'Lunes','3'=>'Martes','4'=>'Miercoles','5'=>'Jueves','6'=>'Viernes','7'=>'Sabado','1'=>'Domingo'),$vew_doc->getTagValue($vew_data->docrmdfrq,'rmdwekday'),$lv_default); ?></div>
									<label class="control-label col-xs-4"> de cada </label>
									<div class="col-xs-6"><?= gethtml('docrmdfrqech002PM','docnum0300',$vew_doc->getTagValue($vew_data->docrmdfrq,'rmdech'),$lv_default); ?></div>
									<label class="control-label col-xs-2"  style="text-align: left !important;">meses</label>
								</div>
							</div>
						</div>
					</div>
					
					<div id="docrmdtypPA" class="hidden">
						<div class="form-group tmss-form-group">
							<div class="col-sm-2"></div>
							<div class="col-sm-10 col-xs-12">
								<div class="form-group tmss-form-group">
									<label class="control-label col-xs-2"> Cada </label>
									<div class="col-xs-6"><?= gethtml('docrmdfrqechPA','docnum0300',$vew_doc->getTagValue($vew_data->docrmdfrq,'rmdech'),$lv_default); ?></div>
									<label class="control-label col-xs-4" style="text-align: left !important;"> a&ntilde;os </label>
								</div>
								<div class="form-group tmss-form-group">
									<div class="col-xs-2"><input type="checkbox" id="docrmdfrqtypPA" name="docrmdfrqtypPA001" <?= ($vew_doc->getTagValue($vew_data->docrmdfrq,'rmdtyp')=='1'?'checked':''); ?>></div>
									<label class="control-label col-xs-1">El </label>
									<div class="col-xs-4"><?= gethtml('docrmdfrqdayPA','docnum0300',$vew_doc->getTagValue($vew_data->docrmdfrq,'rmdday'),$lv_default); ?></div>
									<label class="control-label col-xs-1">de </label>
									<div class="col-xs-4"><?= gethtml('docrmdfrqmth001PA',array('1'=>'Enero','2'=>'Febrero','3'=>'Marzo','4'=>'Abril','5'=>'Mayo','6'=>'Junio','7'=>'Julio','8'=>'Agosto','9'=>'Septiembre','10'=>'Octubre','11'=>'Noviembre','12'=>'Diciembre'),$vew_doc->getTagValue($vew_data->docrmdfrq,'rmdmth'),$lv_default); ?></div>
								</div>
								<div class="form-group tmss-form-group">
									<div class="col-xs-2"><input type="checkbox" id="docrmdfrqtypPA" name="docrmdfrqtypPA002" <?= ($vew_doc->getTagValue($vew_data->docrmdfrq,'rmdtyp')=='2'?'checked':''); ?>></div>
									<label class="control-label col-xs-1">El </label>
									<div class="col-xs-4"><?= gethtml('docrmdfrqdaytypPA',array('1'=>'Primer','2'=>'Segundo','3'=>'Tercer','4'=>'Cuarto','L'=>'Ultimo'),$vew_doc->getTagValue($vew_data->docrmdfrq,'rmddaytyp'),$lv_default); ?></div>
									<div class="col-xs-5"><?= gethtml('docrmdfrqwekdayPA',array('2'=>'Lunes','3'=>'Martes','4'=>'Miercoles','5'=>'Jueves','6'=>'Viernes','7'=>'Sabado','1'=>'Domingo'),$vew_doc->getTagValue($vew_data->docrmdfrq,'rmdwekday'),$lv_default); ?></div>
									<label class="control-label col-xs-3">de </label>
									<div class="col-xs-9"><?= gethtml('docrmdfrqmth002PA',array('1'=>'Enero','2'=>'Febrero','3'=>'Marzo','4'=>'Abril','5'=>'Mayo','6'=>'Junio','7'=>'Julio','8'=>'Agosto','9'=>'Septiembre','10'=>'Octubre','11'=>'Noviembre','12'=>'Diciembre'),$vew_doc->getTagValue($vew_data->docrmdfrq,'rmdmth'),$lv_default); ?></div>
								</div>
							</div>
						</div>
					</div>
				</div> <!-- /docrmdtab01 -->
				
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_docrmdtab02">
					<?php
						echo vew_boot($lv_col210, array('label'=>$vew_lang->createdby, 	'input'=>gethtml('', 'usrcod', $vew_data->cteusr, $lv_always_disabled) ));
						echo vew_boot($lv_col210, array('label'=>$vew_lang->createddate,'input'=>gethtml('', 'dtetme', $vew_data->ctedte, $lv_always_disabled) ));
						echo vew_boot($lv_col210, array('label'=>$vew_lang->updatedby, 	'input'=>gethtml('', 'usrcod', $vew_data->updusr, $lv_always_disabled) ));
						echo vew_boot($lv_col210, array('label'=>$vew_lang->updateddate,'input'=>gethtml('', 'dtetme', $vew_data->upddte, $lv_always_disabled) ));
					?>
				</div>  <!-- /docrmdtab02 -->
				
			</div> <!-- /tab-content -->
		</div> <!-- /tab-panel -->
	</form>
	<script>
		$("#<?= $lv_sec; ?> #docrmdtyp").on("change",function(e){
			$("#<?= $lv_sec; ?> #docrmdtypPD").addClass("hidden");
			$("#<?= $lv_sec; ?> #docrmdtypPS").addClass("hidden");
			$("#<?= $lv_sec; ?> #docrmdtypPM").addClass("hidden");
			$("#<?= $lv_sec; ?> #docrmdtypPA").addClass("hidden");
			if($(this).prop("value")=="U"){
				$("#<?= $lv_sec; ?> #dmcrmdstrdtelbl").text("Dia");
				$("#<?= $lv_sec; ?> #docrmdenddtediv").addClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #dmcrmdstrdtelbl").text("Desde");
				$("#<?= $lv_sec; ?> #docrmdtyp"+$(this).prop("value")).removeClass("hidden");
				$("#<?= $lv_sec; ?> #docrmdenddtediv").removeClass("hidden");
			}
			e.preventDefault();
			e.stopPropagation();
		});

		$("#<?= $lv_sec; ?> #rmdfrqtypPD").on("change",function(e){
			if( $(this).is(":checked") && $(this).prop("name")=="rmdfrqtypPD001" ) {
				$("#<?= $lv_sec; ?> input[name='rmdfrqtypPD002']").prop("checked",false).change();
			} else if( $(this).is(":checked") && $(this).prop("name")=="rmdfrqtypPD002" ) {
				$("#<?= $lv_sec; ?> input[name='rmdfrqtypPD001']").prop("checked",false).change();
			}
		});

		$("#<?= $lv_sec; ?> #docrmdfrqtypPM").on("change",function(e){
			if( $(this).is(":checked") && $(this).prop("name")=="docrmdfrqtypPM001" ) {
				$("#<?= $lv_sec; ?> input[name='docrmdfrqtypPM002']").prop("checked",false).change();
			} else if( $(this).is(":checked") && $(this).prop("name")=="docrmdfrqtypPM002" ) {
				$("#<?= $lv_sec; ?> input[name='docrmdfrqtypPM001']").prop("checked",false).change();
			}
		});

		$("#<?= $lv_sec; ?> #docrmdfrqtypPA").on("change",function(e){
			if( $(this).is(":checked") && $(this).prop("name")=="docrmdfrqtypPA001" ) {
				$("#<?= $lv_sec; ?> input[name='docrmdfrqtypPA002']").prop("checked",false).change();
			} else if( $(this).is(":checked") && $(this).prop("name")=="docrmdfrqtypPA002" ) {
				$("#<?= $lv_sec; ?> input[name='docrmdfrqtypPA001']").prop("checked",false).change();
			}
		});
		
		tmssLoadScript("toggle",function(){
			$("#<?= $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: "success", offstyle: "default", on: "Si", off: "No", size: "small" });
				$(this).trigger("change");
			});
		});
		
		$("#<?= $lv_sec; ?> #btnchk").on("click",function(e){
			var lv_docrmdlogcod = $(this).data("docrmdlogcod");
			var lv_pst = [{name:"docrmdcod",value:"<?= $vew_data->docrmdcod; ?>"},{name:"docrmdlogcod",value:$(this).data("docrmdlogcod")}];
			tmssCallProcess("?prg=grldocrmd&act="+(lv_docrmdlogcod==""?"10":"11")+"&prm_curdte=<?= $vew_data->curdte; ?>", lv_pst, function(data){
				if (lv_docrmdlogcod=="") {
					lv_docrmdlogcod = $("<div>"+data+"</div>").find("docrmdlogcod").text();
					$("#<?= $lv_sec; ?> #btnchk").removeClass("btn-default").addClass("btn-success").data("docrmdlogcod",lv_docrmdlogcod);
					$("#<?= $lv_sec; ?> #btnchk span").removeClass("fas fa-check").addClass("fas fa-check-double");
				} else {
					$("#<?= $lv_sec; ?> #btnchk").addClass("btn-default").removeClass("btn-success").data("docrmdlogcod","");
					$("#<?= $lv_sec; ?> #btnchk span").removeClass("fas fa-check-double").addClass("fas fa-check");
				}
				tmssRemindersRefresh();
			});
			e.preventDefault();
		});

		$("#<?= $lv_sec; ?> #docrmdtyp").trigger("change");
		<?php if ( $vew_data->docrmdcod=='' ) { ?>
		$("#<?= $lv_sec; ?> #docrmdstrdte").prop("value", moment().format('DD/MM/YYYY') );
		$("#<?= $lv_sec; ?> #docrmdenddte").prop("value", moment().format('DD/MM/YYYY') );
		$("#<?= $lv_sec; ?> #docrmdstrtme").prop("value", moment().format('HH:mm') );
		$("#<?= $lv_sec; ?> #docrmdfrqechPD").prop("value", "1" );
		$("#<?= $lv_sec; ?> #docrmdfrqechPS").prop("value", "1" );
		$("#<?= $lv_sec; ?> #docrmdfrqdayPM").prop("value", moment().format('D') );
		$("#<?= $lv_sec; ?> #docrmdfrqech001PM").prop("value", "1" );
		$("#<?= $lv_sec; ?> #docrmdfrqwekdayPM").prop("value", moment().weekday(-1).format('e') );
		$("#<?= $lv_sec; ?> #docrmdfrqech002PM").prop("value", "1" );		
		$("#<?= $lv_sec; ?> #docrmdfrqechPA").prop("value", "1" );
		$("#<?= $lv_sec; ?> #docrmdfrqdayPA").prop("value", moment().format('D') );
		$("#<?= $lv_sec; ?> #docrmdfrqmth001PA").prop("value", moment().format('M') );
		$("#<?= $lv_sec; ?> #docrmdfrqwekdayPA").prop("value", moment().weekday(-1).format('e') );
		$("#<?= $lv_sec; ?> #docrmdfrqmth002PA").prop("value", moment().format('M') );
		<?php } ?>
	</script>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $("#<?= $lv_sec; ?>_frm"), "<?= $lv_lnk; ?>", function (data) {
			try {
				var lv_xml = $.parseXML( "<?xml version='1.0' encoding='utf-8'?><xmldata>" + data + "</xmldata>" );
				var lv_errcod = $(lv_xml).find("errcod").eq(0).text();
				var lv_errrow = $(lv_xml).find("row").eq(0).text();
				if ( lv_errcod!="0" && lv_errrow!="" ) {
					<?= $lv_sec; ?>_hotdoc.setCellMeta( Number(lv_errrow), 2, "valid", false);
				}
				<?= $lv_sec; ?>_hotdoc.render();
			} catch (e) {}
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="00") { tmssRemindersRefresh(); }
				if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssRemindersRefresh();
					$.each(BootstrapDialog.dialogs, function(id, dialog){
						if ( $(dialog.getModalBody()).find("#<?= $lv_sec; ?>").length==1 ) { dialog.close(); }
					});
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    });
		
		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {
				
				<?php if ( $vew_data->docrmdcod=='' ) { ?>
					if (lp_prm["action"]=="98") { BootstrapDialog.closeAll(); return false; }
				<?php } ?>
				
				gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
				var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':'03'); ?>":gv_<?= $lv_sec; ?>_last_action);
				tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
			}
		}
		
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	</script>
</section>
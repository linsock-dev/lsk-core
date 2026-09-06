<?php
	// url del formulario 
  $lv_lnk = '?prg=zcuau1_hpt&act=02&prm_patcod='.$vew_pat->patcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('adrlstnme','lndcod') );

	// clave del documento 
	$lv_dockey = $vew_pat->patcod;

	// titulo 
	$lv_title = $vew_lang->form;
	
	// m&oacute;dulo y programa 
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'AU1';

	// librería de estilos bootstrap 
	include_once('_library.frm');

	$vew_actcod = '02';
	
	// si no tiene ID de prestador, o no tiene especialidad asignada ==> es solo lectura
	if ( $vew_data->prscod=='' || $vew_data->spccod=='' ) { $vew_actcod='03'; $vew_readonly = true; }
	
	if ( $vew_pat->patbrndte!='' ) {
		//date in mm/dd/yyyy format; or it can be in other formats as well
		//explode the date to get month, day and year
		$lv_bthdtearr = explode('/', $vew_pat->patbrndte->format('m/d/Y'));
		//get age from date or birthdate
		$lv_age = (date('md', date('U', mktime(0, 0, 0, $lv_bthdtearr[0], $lv_bthdtearr[1], $lv_bthdtearr[2]))) > date('md')
			? ((date('Y') - $lv_bthdtearr[2]) - 1)
			: (date('Y') - $lv_bthdtearr[2]));
	} else {
		$lv_age = '';
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<link href="/library/css/temasis.bs-docs-sidebar.css" rel="stylesheet">
	<style>#sidebar.affix {top: 121px;}</style>

  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '00'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success" title="<?= $vew_lang->save;  ?>"><span class="far fa-save"></span><span class="hidden-xs">  <?= $vew_lang->save; ?></span></a>
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-danger" title="<?= $vew_lang->cancel; ?>"><span class="fas fa-times"></span><span class="hidden-xs">  <?= $vew_lang->cancel; ?></span></a>
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<!--Dropdown-->
				<div class="btn-group dropdown">
					<a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><span class="fas fa-ellipsis-v"></span></a>
					<form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
						<!--Actualizar-->
						<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '99'});" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
						<!--Imprimir-->
            <li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: 'prn'});" class="tmssLink"><i style="width:20px;" class="fas fa-print"></i><?= $vew_lang->print; ?></a></li>
          </form>
				</div>        
        <!-- Cerrar -->
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
	</nav>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		
    <input type="hidden" id="pattxt" name="pattxt" value="<?= $vew_pat->pattxt; ?>">
    <input type="hidden" id="adrnum" name="adrnum" value="<?= $vew_pat->adr->adrnum; ?>">
    <input type="hidden" id="bnknum" name="bnknum" value="<?= $vew_pat->bnk->bnknum; ?>">
    <input type="hidden" id="taxnum" name="taxnum" value="<?= $vew_pat->tax->taxnum; ?>">

    <input type="hidden" id="sysdocclscod" name="sysdocclscod" value="<?= $vew_data->sysdoccls->sysdocclscod; ?>">
    <input type="hidden" id="spccod" name="spccod" value="<?= $vew_data->spccod; ?>">
		<input type="hidden" id="cuscod" name="cuscod" value="<?= $vew_data->cuscod; ?>">
    <input type="hidden" id="prscod" name="prscod" value="<?= $vew_data->prscod; ?>">
    <input type="hidden" id="evldte" name="evldte" value="<?= ($vew_patevl->evldte!=''?$vew_patevl->evldte->format('d/m/Y'):''); ?>">
    <input type="hidden" id="docsts" name="docsts" value="A">
		
		<input type="hidden" id="evlcod" name="evlcod" value="<?= $vew_data->evlcod; ?>">
    <input type="hidden" id="evlsysdocclscod" name="evlsysdocclscod" value="<?= $vew_data->evlsysdocclscod; ?>">
		<input type="hidden" id="evlspccod" name="evlspccod" value="<?= $vew_data->evlspccod; ?>">
		
		<div class="container bs-docs-container">
			<div class="row">
				<div class="col-md-9">
					<div class="bs-docs-section">



						<h1 id="paciente"><i class="fas fa-caret-right"></i> Paciente</h1><br><!-- pat -->



						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmpatincprohcc">&iquest;Paciente incluido en protocolo HCC-HCV?</label>
										<div class="col-sm-2"><?= gethtml('frmpatincprohcc','yesno',($vew_patevlspc->frmpatincprohcc==''?'1':$vew_patevlspc->frmpatincprohcc),$lv_default); ?></div>
									</div>
								</td></tr>
							</tbody>
						</table>
						
						
						
						<h2 id="paciente-01"><span class="fas fa-angle-right"></span> Datos demogr&aacute;ficos</h2><br><br><!-- dem -->



						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label" for="patcod">ID Paciente</label>
										<div class="col-sm-4"><?= gethtml('patcod','patcod',$vew_pat->patcod,$lv_always_disabled); ?></div>
										<label class="col-sm-2 control-label" for="pattxt"><?= $vew_lang->lastname; ?></label>
										<div class="col-sm-4"><?= gethtml('adrlstnme','adrlstnme',$vew_pat->adr->adrlstnme,$lv_default); ?></div>
										<label class="col-sm-8 control-label" for="pattxt"><?= $vew_lang->firstname; ?></label>
										<div class="col-sm-4"><?= gethtml('adrfrtnme','adrfrtnme',$vew_pat->adr->adrfrtnme,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label" for="patbrndte">Fec Nacimiento</label>
										<div class="col-sm-4"><?= gethtml('patbrndte','docdte',$vew_pat->patbrndte, $lv_default); ?></div>
										<label class="col-sm-1 control-label">Edad</label>
										<div class="col-sm-5"><?= gethtml('patage','doccmt1x20',$lv_age,$lv_always_disabled); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label" for="patsex">Sexo</label>
										<div class="col-sm-4"><?= gethtml('patsex','adrsex',$vew_pat->patsex,$lv_default); ?></div>
										<label class="col-sm-1 control-label" for="patwgt"><?= $vew_lang->weight; ?> <small>(kg)</small></label>
										<div class="col-sm-2"><?= gethtml('patwgt','qty',$vew_patevlspc->patwgt,$lv_default); ?></div>
										<label class="col-sm-1 control-label" for="pathgh">Talla <small>(cm)</small></label>
										<div class="col-sm-2"><?= gethtml('pathgh','qty',$vew_patevlspc->pathgh,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label" for="adrcty">Ciudad de Origen</label>
										<div class="col-sm-4"><?= gethtml('adrcty','adrcty',$vew_pat->adr->adrcty,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<?php
										echo vew_boot($lv_col237, array("label"=>$vew_lang->country, 	
																										"input1"=>vew_boot(	array("style"=>"search", "readonly"=>$vew_readonly), 
																																				array("input"=>gethtml("lndcod", "adrlndcod", $vew_pat->adr->lndcod, $lv_default) )),
																										"input2"=>gethtml("lndtxt", "adrlndtxt", $vew_pat->adr->lndtxt, $lv_always_disabled) )); 
									?>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label" for="patmedcov">Cobertura M&eacute;dica</label>
										<div class="col-sm-4"><?= gethtml('patmedcov',array(''=>'','sin_cobertura'=>'SIN COBERTURA','seguro_social'=>'SEGURO SOCIAL','seguro_privado'=>'SEGURO PRIVADO'),$vew_patevlspc->patmedcov); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label" for="frmpatdemant">Antecedentes<br><small>(marcar o especificar seg&uacute;n corresponda)</small></label>
										<div class="col-sm-4">
											<label><input type="checkbox" id="frmpatdemant" name="frmpatdemant001" <?= ($vew_patevlspc->frmpatdemant001!=''?'checked':''); ?>> Ninguno</label><br>
											<label><input type="checkbox" id="frmpatdemant" name="frmpatdemant002" <?= ($vew_patevlspc->frmpatdemant002!=''?'checked':''); ?>> Hipertensi&oacute;n Arterial</label><br>
											<label><input type="checkbox" id="frmpatdemant" name="frmpatdemant003" <?= ($vew_patevlspc->frmpatdemant003!=''?'checked':''); ?>> Diabetes Mellitus</label><br>
											<label><input type="checkbox" id="frmpatdemant" name="frmpatdemant004" <?= ($vew_patevlspc->frmpatdemant004!=''?'checked':''); ?>> Enfermedad Coronaria</label><br>
											<label><input type="checkbox" id="frmpatdemant" name="frmpatdemant005" <?= ($vew_patevlspc->frmpatdemant005!=''?'checked':''); ?>> EPOC</label><br>
										</div>
										<div class="col-sm-6">
											<label><input type="checkbox" id="frmpatdemant" name="frmpatdemant006" <?= ($vew_patevlspc->frmpatdemant006!=''?'checked':''); ?>> Di&aacute;lisis</label><br>
											<label><input type="checkbox" id="frmpatdemant" name="frmpatdemant007" <?= ($vew_patevlspc->frmpatdemant007!=''?'checked':''); ?>> Enfermedad Renal (Cl Cr <30 ml/min)</label><br>
											<label><input type="checkbox" id="frmpatdemant" name="frmpatdemant008" <?= ($vew_patevlspc->frmpatdemant008!=''?'checked':''); ?>> Enfermedad Renal (Cl Cr 30-45 ml/min)</label><br>
											<label><input type="checkbox" id="frmpatdemant" name="frmpatdemant009" <?= ($vew_patevlspc->frmpatdemant009!=''?'checked':''); ?>> Convulsiones</label><br>
											<label><input type="checkbox" id="frmpatdemant" name="frmpatdemant010" <?= ($vew_patevlspc->frmpatdemant010!=''?'checked':''); ?>> Enfermedad vascular perif&eacute;rica</label><br>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label" for="frmpatdemtra">&iquest;Trasplantado de &oacute;rgano s&oacute;lido?</label>
										<div class="col-sm-4">
											<label><input type="checkbox" id="frmpatdemtra" name="frmpatdemtra001" <?= ($vew_patevlspc->frmpatdemtra001!=''?'checked':''); ?>> Ninguno</label><br>
											<label><input type="checkbox" id="frmpatdemtra" name="frmpatdemtra002" <?= ($vew_patevlspc->frmpatdemtra002!=''?'checked':''); ?>> Hep&aacute;tico</label><br>
										</div>
										<div class="col-sm-6">
											<label><input type="checkbox" id="frmpatdemtra" name="frmpatdemtra003" <?= ($vew_patevlspc->frmpatdemtra003!=''?'checked':''); ?>> Renal</label><br>
											<label><input type="checkbox" id="frmpatdemtra" name="frmpatdemtra004" <?= ($vew_patevlspc->frmpatdemtra004!=''?'checked':''); ?>> Card&iacute;aco/Pulmonar</label><br>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label" for="frmpatdemcoi">Coinfecci&oacute;n</label>
										<div class="col-sm-10"><label><input type="checkbox" id="frmpatdemcoi" name="frmpatdemcoi001" <?= ($vew_patevlspc->frmpatdemcoi001!=''?'checked':''); ?>> No</label></div>
									</div>
									<div class="form-group tmss-form-group">
										<div class="col-sm-2">&nbsp;</div>
										<div class="col-sm-5">
											<label><input type="checkbox" id="frmpatdemcoi" name="frmpatdemcoi002" <?= ($vew_patevlspc->frmpatdemcoi002!=''?'checked':''); ?>> HIV</label>
											<div class="hidden" id="frmpatdemcoihiv">
												<table class="table table-condensed table-bordered">
													<tbody>
														<tr><td>&uacute;ltimo recuento CD4+:</td><td><?= gethtml('frmpatdemcoihivrec','qty',$vew_patevlspc->frmpatdemcoihivrec,$lv_default); ?></td></tr>
														<tr><td>&uacute;ltima carga viral</td><td><?= gethtml('frmpatdemcoihivcar','qty',$vew_patevlspc->frmpatdemcoihivcar,$lv_default); ?></td></tr>
														<tr><td>Fecha</td><td><?= gethtml('frmpatdemcoihivdte','docdte',$vew_patevlspc->frmpatdemcoihivdte, $lv_default); ?></td></tr>
													</tbody>
												</table>
											</div>
										</div>
										<div class="col-sm-5">
											<label><input type="checkbox" id="frmpatdemcoi" name="frmpatdemcoi003" <?= ($vew_patevlspc->frmpatdemcoi003!=''?'checked':''); ?>> HBV</label>
											<div class="hidden" id="frmpatdemcoihbv">
												<table class="table table-condensed table-bordered">
													<tbody>
														<tr><td>&uacute;ltima carga viral</td><td><?= gethtml('frmpatdemcoihbvcar','qty',$vew_patevlspc->frmpatdemcoihbvcar,$lv_default); ?></td></tr>
														<tr><td>Fecha</td><td><?= gethtml('frmpatdemcoihbvdte','docdte',$vew_patevlspc->frmpatdemcoihbvdte, $lv_default); ?></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
								</td></tr>
							</tbody>
						</table>



						<h1 id="patologia"><span class="fas fa-caret-right"></span> Patolog&iacute;a</h1><br><!-- pto -->



						<h2 id="patologia-01"><span class="fas fa-angle-right"></span> Hepatitis C</h2><br><br><!-- hep -->



						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label" for="frmptohepyth">A&ntilde;o de diagn&oacute;stico de HCV</label>
										<div class="col-sm-4"><?= gethtml('frmptohepyth','docnum0600',$vew_patevlspc->frmptohepyth,$lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label" for="frmptohepagu">&iquest;Tuvo Hepatitis aguda?</label>
										<div class="col-sm-4"><?= gethtml('frmptohepagu','yesnounknown',$vew_patevlspc->frmptohepagu,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label" for="frmptohepgen">Genotipo</label>
										<div class="col-sm-4"><?= gethtml('frmptohepgen',array(''=>'','1'=>'1','1a'=>'1a','1b'=>'1b','2'=>'2','3'=>'3','4'=>'4','5'=>'5','6'=>'6','desconocido'=>'DESCONOCIDO'), $vew_patevlspc->frmptohepgen); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label" for="frmptohepvia">V&iacute;a de Infecci&oacute;n</label>
										<div class="col-sm-4">
											<?php gethtml('frmptohepvia',array(''=>'','drogas'=>'DROGAS EV','tatuaje'=>'TATUAJE/PIERCING','transfusion'=>'TRANSFUSION','procedimiento'=>'PROCEDIMIENTO MEDICO INSEGURO','desconocido'=>'DESCONOCIDO','otro'=>'OTRO'), $vew_patevlspc->frmptohepvia ); ?>
											<div id="frmptohepviaotrdiv" class="hidden">
												<label class="control-label" for="frmptohepviaotr">Indique</label>
												<?= gethtml('frmptohepviaotr','doccmt1x20',$vew_patevlspc->frmptohepviaotr,$lv_default); ?>
											</div>
										</div>
										<label class="col-sm-2 control-label" for="frmptohepviayth">&iquest;A&ntilde;o probable Infecci&oacute;n?</label>
										<div class="col-sm-4"><?= gethtml('frmptohepviayth','docnum0600',$vew_patevlspc->frmptohepviayth,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label" for="frmptoheptra">&iquest;Tratamiento previo?</label>
										<div class="col-sm-4"><?= gethtml('frmptoheptra','yesnounknown',$vew_patevlspc->frmptoheptra,$lv_default); ?></div>
									</div>
									<div class="form-group hidden" id="frmptoheptradiv">
										<div class="col-sm-2"></div>
										<div class="col-sm-10">
											<table class="table table-condensed table-bordered">
												<thead>
													<tr><th></th><th></th><th>A&ntilde;o</th></tr>
												</thead>
												<tbody>
													<tr><td><?= gethtml('frmptoheptrachk01','onoff',$vew_patevlspc->frmptoheptrachk01,$lv_default); ?></td><td><label>IFN  RBV								</label></td><td><?= gethtml('frmptoheptrayth01','docnum0600',$vew_patevlspc->frmptoheptrayth01,$lv_default); ?></td></tr>
													<tr><td><?= gethtml('frmptoheptrachk02','onoff',$vew_patevlspc->frmptoheptrachk02,$lv_default); ?></td><td><label>PEGIFN  RBV						 	</label></td><td><?= gethtml('frmptoheptrayth02','docnum0600',$vew_patevlspc->frmptoheptrayth02,$lv_default); ?></td></tr>
													<tr><td><?= gethtml('frmptoheptrachk03','onoff',$vew_patevlspc->frmptoheptrachk03,$lv_default); ?></td><td><label>Boceprevir  PEGIFN  RBV</label></td><td><?= gethtml('frmptoheptrayth03','docnum0600',$vew_patevlspc->frmptoheptrayth03,$lv_default); ?></td></tr>
													<tr><td><?= gethtml('frmptoheptrachk04','onoff',$vew_patevlspc->frmptoheptrachk04,$lv_default); ?></td><td><label>Telaprevir  PEGIFN  RBV</label></td><td><?= gethtml('frmptoheptrayth04','docnum0600',$vew_patevlspc->frmptoheptrayth04,$lv_default); ?></td></tr>
													<tr><td><?= gethtml('frmptoheptrachk05','onoff',$vew_patevlspc->frmptoheptrachk05,$lv_default); ?></td><td><label>Falla AAD (libre de IFN) </label></td><td><?= gethtml('frmptoheptrayth05','docnum0600',$vew_patevlspc->frmptoheptrayth05,$lv_default); ?></td></tr>
													<tr id="frmptoheptrachk05div" class="hidden"><td></td><td colspan="2">
														<div class="form-group tmss-form-group">
															<div class="col-sm-6">
																<label><input type="checkbox" id="frmptoheptraantchk" name="frmptoheptraant001" <?= ($vew_patevlspc->frmptoheptraant001!=''?'checked':''); ?>> Sofosbuvir  SOVALDI</label><br>
																<label><input type="checkbox" id="frmptoheptraantchk" name="frmptoheptraant002" <?= ($vew_patevlspc->frmptoheptraant002!=''?'checked':''); ?>> Sofosbuvir  PROBIRASE u otro gen&eacute;rico</label><br>
																<label><input type="checkbox" id="frmptoheptraantchk" name="frmptoheptraant003" <?= ($vew_patevlspc->frmptoheptraant003!=''?'checked':''); ?>> Sofosbuvir + Ledipasvir</label><br>
																<label><input type="checkbox" id="frmptoheptraantchk" name="frmptoheptraant004" <?= ($vew_patevlspc->frmptoheptraant004!=''?'checked':''); ?>> Sofosbuvir + Velpatasvir</label><br>
																<label><input type="checkbox" id="frmptoheptraantchk" name="frmptoheptraant005" <?= ($vew_patevlspc->frmptoheptraant005!=''?'checked':''); ?>> Daclatasvir - DAKLINZA</label><br>
																<label><input type="checkbox" id="frmptoheptraantchk" name="frmptoheptraant006" <?= ($vew_patevlspc->frmptoheptraant006!=''?'checked':''); ?>> Daclatasvir - GENERICO</label><br>
															</div>
															<div class="col-sm-6">
																<label><input type="checkbox" id="frmptoheptraantchk" name="frmptoheptraant007" <?= ($vew_patevlspc->frmptoheptraant007!=''?'checked':''); ?>> Asunaprevir</label><br>
																<label><input type="checkbox" id="frmptoheptraantchk" name="frmptoheptraant008" <?= ($vew_patevlspc->frmptoheptraant008!=''?'checked':''); ?>> Simeprevir</label><br>
																<label><input type="checkbox" id="frmptoheptraantchk" name="frmptoheptraant009" <?= ($vew_patevlspc->frmptoheptraant009!=''?'checked':''); ?>> Paritaprevir/r + Ombitasvir + Dasabuvir</label><br>
																<label><input type="checkbox" id="frmptoheptraantchk" name="frmptoheptraant010" <?= ($vew_patevlspc->frmptoheptraant010!=''?'checked':''); ?>> Paritaprevir/r + Ombitasvir</label><br>
																<label><input type="checkbox" id="frmptoheptraantchk" name="frmptoheptraant011" <?= ($vew_patevlspc->frmptoheptraant011!=''?'checked':''); ?>> Grazoprevir/Elbasvir</label><br>
																<label><input type="checkbox" id="frmptoheptraantchk" name="frmptoheptraant012" <?= ($vew_patevlspc->frmptoheptraant012!=''?'checked':''); ?>> Glecaprevir + Pibrentasvir</label><br>
																<label><input type="checkbox" id="frmptoheptraantchk" name="frmptoheptraant013" <?= ($vew_patevlspc->frmptoheptraant013!=''?'checked':''); ?>> SOF/VEL/VOX</label><br>
															</div>
														</div>														
													</td></tr>
												</tbody>
											</table>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label" for="frmptohepman">Manifestaciones Extrahep&aacute;ticas Hepatitis C</label>
										<div class="col-sm-4"><?= gethtml("frmptohepman","yesno",$vew_patevlspc->frmptohepman,$lv_default); ?></div>
										<div class="col-sm-6">
											<div id="frmptohepmandiv" class="hidden">
												<label><?= gethtml('frmptohepman001','onoff',$vew_patevlspc->frmptohepman001,$lv_default); ?> Crioglobulinemia</label><br>
												<label><?= gethtml('frmptohepman002','onoff',$vew_patevlspc->frmptohepman002,$lv_default); ?> Glomerulopat&iacute;a</label><br>
												<label><?= gethtml('frmptohepman003','onoff',$vew_patevlspc->frmptohepman003,$lv_default); ?> Linfoma no Hodgkin</label><br>
												<label><?= gethtml('frmptohepman004','onoff',$vew_patevlspc->frmptohepman004,$lv_default); ?> Porfiria cut&aacute;nea tarda</label><br>
												<label><?= gethtml('frmptohepman005','onoff',$vew_patevlspc->frmptohepman005,$lv_default); ?> Liquen plano</label><br>
												<label><?= gethtml('frmptohepman006','onoff',$vew_patevlspc->frmptohepman006,$lv_default); ?> Otras</label><br>
												<div id="frmptohepman006div" class="hidden">
													<label class="control-label" for="frmptohepman006otr">Indique</label>
													<?= gethtml('frmptohepman006otr','doccmt1x20',$vew_patevlspc->frmptohepman006otr,$lv_default); ?>
												</div>
											</div>
										</div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>



						<h2 id="patologia-02"><span class="fas fa-angle-right"></span> Estad&iacute;o</h2>
						<h4>(incluir solo la ultima valoraci&oacute;n de la fibrosis y el m&eacute;todo utilizado)</h4>
						<br><br><!-- est -->



						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label" for="frmptoestbio">Grado de Fibrosis seg&uacute;n &uacute;ltima valoraci&oacute;n</label>
										<div class="col-sm-2"><?= gethtml('frmptoestbiogrd',array(''=>'','0'=>'0','1'=>'1','2'=>'2','3'=>'3','4'=>'4'),$vew_patevlspc->frmptoestbiogrd); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label" for="frmptoestbioyth">A&ntilde;o</label>
										<div class="col-sm-2"><?= gethtml('frmptoestbioyth','docnum0600',$vew_patevlspc->frmptoestbioyth,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label" for="frmptoestbio">Biopsia Hep&aacute;tica</label>
										<div class="col-sm-2"><?= gethtml('frmptoestbio','yesno',$vew_patevlspc->frmptoestbio,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label" for="frmptoestmet">M&eacute;todos F&iacute;sicos no invasivos</label>
										<div class="col-sm-2"><?= gethtml('frmptoestmet','yesno',$vew_patevlspc->frmptoestmet,$lv_default); ?></div>
										<div class="col-sm-7">
											<div class="hidden" id="frmptoestmetdiv">
												<table class="table table-condensed table-bordered">
													<tbody>
														<tr><td>M&eacute;todo</td><td><?= gethtml('frmptoestmetmet',array(''=>'','fibroscan'=>'FIBROSCAN','arfi'=>'ARFI'),$vew_patevlspc->frmptoestmetmet); ?></td></tr>
														<tr><td>Valor kPa o m/seg</td><td><?= gethtml('frmptoestmetval','doccmt1x20',$vew_patevlspc->frmptoestmetval,$lv_default); ?></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label" for="frmptoestser">M&eacute;todos Serol&oacute;gicos</label>
										<div class="col-sm-2"><?= gethtml('frmptoestser','yesno',$vew_patevlspc->frmptoestser,$lv_default); ?></div>
										<div class="col-sm-7">
											<div class="hidden" id="frmptoestserdiv">
												<table class="table table-condensed table-bordered">
													<tbody>
														<tr><td>Fibrotest</td><td><?= gethtml('frmptoestserfib','onoff',$vew_patevlspc->frmptoestserfib,$lv_default); ?></td></tr>
														<tr><td>APRI >= 1.5</td><td><?= gethtml('frmptoestserapr','onoff',$vew_patevlspc->frmptoestserapr,$lv_default); ?></td></tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label" for="frmptoestcrr">Diagn&oacute;stico Cl&iacute;nico de Cirrosis</label>
										<div class="col-sm-2"><?= gethtml('frmptoestcrr','yesno',$vew_patevlspc->frmptoestcrr,$lv_default); ?></div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>



						<h2 id="patologia-03"><span class="fas fa-angle-right"></span> Complicaciones Hep&aacute;ticas Previas al Inicio de AAD</h2><br><br><!-- com -->



						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmptocomhep">&iquest;Ha presentado complicaciones hep&aacute;ticas?</label>
										<div class="col-sm-3"><?= gethtml('frmptocomhep','yesno',$vew_patevlspc->frmptocomhep,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmptocomlst">&iquest;Paciente en lista de trasplante hep&aacute;tico?</label>
										<div class="col-sm-3"><?= gethtml('frmptocomlst','yesno',$vew_patevlspc->frmptocomlst,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmptocomant">&iquest;Antecedentes de Ascitis?</label>
										<div class="col-sm-3"><?= gethtml('frmptocomant','yesnounknown',$vew_patevlspc->frmptocomant,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmptocomenc">&iquest;Antecedentes de Encefalopat&iacute;a?</label>
										<div class="col-sm-3"><?= gethtml('frmptocomenc','yesnounknown',$vew_patevlspc->frmptocomenc,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmptocomvar">&iquest;Antecedentes de v&aacute;rices esof&aacute;gicas?</label>
										<div class="col-sm-3"><?= gethtml('frmptocomvar','yesnounknown',$vew_patevlspc->frmptocomvar,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmptocomhem">&iquest;Antecedentes de Hemorragia variceal?</label>
										<div class="col-sm-6"><?= gethtml('frmptocomhem', array(''=>'','si'=>'SI','no'=>'NO','desconocido'=>'DESCONOCIDO','desarrollada'=>'DESARROLLADA DURANTE EL TRATAMIENTO'), $vew_patevlspc->frmptocomhem ); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmptocomanthpt">&iquest;Antecedentes de Hepatocarcinoma?</label>
										<div class="col-sm-3"><?= gethtml('frmptocomanthpt','yesno',$vew_patevlspc->frmptocomanthpt,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<table class="table table-striped table-condensed hidden" id="frmptocomanthptdiv">
										<tbody>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-4 control-label" for="frmptocomhptdtehcc">Fecha diagn&oacute;stico HCC</label>
													<div class="col-sm-6"><?= gethtml('frmptocomhptdtehcc','docdte', $vew_patevlspc->frmptocomhptdtehcc, $lv_default ); ?></div>
												</div>
											</td></tr>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-4 control-label" for="frmptocomhptecg">ECOG al diagn&oacute;stico del HCC</label>
													<div class="col-sm-6"><?= gethtml('frmptocomhptecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmptocomhptecg); ?><br>
														<ul>
															<li><strong>ECOG 0:</strong> actividad de la vida diaria completa, sin ninguna restricci&oacute;n.</li><br>
															<li><strong>ECOG 1:</strong> Restricci&oacute;n leve f&iacute;sica a las actividades diarias, pero capaz de realizar actividades ambulatorias y en su hogar, capaz de trabajar.</li><br>
															<li><strong>ECOG 2:</strong> Capaz de auto valerse por si mismo, deambula pero restricci&oacute;n f&iacute;sica para realizar cualquier actividad laboral.</li><br>
															<li><strong>ECOG 3:</strong> Confinado a silla de ruedas o cama >50% del tiempo diario.</li><br>
															<li><strong>ECOG 4:</strong> completamente discapacitado y dependiente para las actividades diarias, confinado a silla de ruedas o cama.</li><br>
														</ul>
													</div>
												</div>
											</td></tr>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-4 control-label" for="frmptocomhptnronod">N&uacute;mero de n&oacute;dulos de HCC</label>
													<div class="col-sm-6"><?= gethtml('frmptocomhptnronod','qty',$vew_patevlspc->frmptocomhptnronod,$lv_default); ?></div>
												</div>
											</td></tr>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-4 control-label" for="frmptocomhptnoddmt">Di&aacute;metro del n&oacute;dulo mayor de HCC <small>mm</small></label>
													<div class="col-sm-6"><?= gethtml('frmptocomhptnoddmt','qty',$vew_patevlspc->frmptocomhptnoddmt,$lv_default); ?></div>
												</div>
											</td></tr>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-4 control-label" for="frmptocomhptlocext">Localizaci&oacute;n extrahep&aacute;tica</label>
													<div class="col-sm-4">
														<label><input type="checkbox" id="frmptocomhptlocextchk" name="frmptocomhptlocext001" <?= ($vew_patevlspc->frmptocomhptlocext001!=''?'checked':''); ?>> No</label><br>
														<label><input type="checkbox" id="frmptocomhptlocextchk" name="frmptocomhptlocext002" <?= ($vew_patevlspc->frmptocomhptlocext002!=''?'checked':''); ?>> Invasi&oacute;n Vascular</label><br>
														<label><input type="checkbox" id="frmptocomhptlocextchk" name="frmptocomhptlocext003" <?= ($vew_patevlspc->frmptocomhptlocext003!=''?'checked':''); ?>> Ganglionar</label><br>
													</div>
													<div class="col-sm-4">
														<label><input type="checkbox" id="frmptocomhptlocextchk" name="frmptocomhptlocext004" <?= ($vew_patevlspc->frmptocomhptlocext004!=''?'checked':''); ?>> Pulmonar</label><br>
														<label><input type="checkbox" id="frmptocomhptlocextchk" name="frmptocomhptlocext005" <?= ($vew_patevlspc->frmptocomhptlocext005!=''?'checked':''); ?>> Osea</label><br>
														<label><input type="checkbox" id="frmptocomhptlocextchk" name="frmptocomhptlocext006" <?= ($vew_patevlspc->frmptocomhptlocext006!=''?'checked':''); ?>> Otra</label><br>
													</div>
												</div>
											</td></tr>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-4 control-label" for="frmptocomhpttra">Primer tratamiento realizado para el HCC</label>
													<div class="col-sm-8">
														<label><?= gethtml("frmptocomhpttrachk001","onoff",$vew_patevlspc->frmptocomhpttrachk001,$lv_default); ?> Ablaci&oacute;n por Radiofrecuencia</label><br>
														<label><?= gethtml("frmptocomhpttrachk002","onoff",$vew_patevlspc->frmptocomhpttrachk002,$lv_default); ?> Ablaci&oacute;n percut&aacute;nea/quir&uacute;rgico</label><br>
														<label><?= gethtml("frmptocomhpttrachk003","onoff",$vew_patevlspc->frmptocomhpttrachk003,$lv_default); ?> Resecci&oacute;n Quir&uacute;rgica</label><br>
														<label><?= gethtml("frmptocomhpttrachk004","onoff",$vew_patevlspc->frmptocomhpttrachk004,$lv_default); ?> Evaluado para trasplante / Trasplantado Hep&aacute;tico</label><br>
														<label><?= gethtml("frmptocomhpttrachk005","onoff",$vew_patevlspc->frmptocomhpttrachk005,$lv_default); ?> Quimioembolizaci&oacute;n transarterial con Doxorrubicina/Lipiodol convencional</label><br>
														<label><?= gethtml("frmptocomhpttrachk006","onoff",$vew_patevlspc->frmptocomhpttrachk006,$lv_default); ?> Quimioembolizaci&oacute;n transarterial con micropart&iacute;culas  DC BEADS</label><br>
														<label><?= gethtml("frmptocomhpttrachk007","onoff",$vew_patevlspc->frmptocomhpttrachk007,$lv_default); ?> Radioembolizaci&oacute;n transarterial</label><br>
														<label><?= gethtml("frmptocomhpttrachk008","onoff",$vew_patevlspc->frmptocomhpttrachk008,$lv_default); ?> Quimioterapia sist&eacute;mica</label><br>
														<label><?= gethtml("frmptocomhpttrachk009","onoff",$vew_patevlspc->frmptocomhpttrachk009,$lv_default); ?> Sorafenib</label><br>
														<label><?= gethtml("frmptocomhpttrachk010","onoff",$vew_patevlspc->frmptocomhpttrachk010,$lv_default); ?> Soporte paliativo</label><br>
														<label><?= gethtml("frmptocomhpttrachk011","onoff",$vew_patevlspc->frmptocomhpttrachk011,$lv_default); ?> Ingreso en protocolo Cl&iacute;nico de Investigaci&oacute;n</label><br>
													</div>
												</div>
											</td></tr>								
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-4 control-label" for="frmptocompatcur">&iquest;Paciente curado?</label>
													<div class="col-sm-6"><?= gethtml('frmptocompatcur','yesno',$vew_patevlspc->frmptocompatcur,$lv_default); ?></div>
												</div>
											</td></tr>
										</tbody>
									</table>
								</td></tr>
							</tbody>
						</table>
						<br><br>
						
						
						<h1 id="tratamiento"><span class="fas fa-caret-right"></span> Tratamiento</h1><br><!-- tra -->
				


						<h2 id="tratamiento-01"><span class="fas fa-angle-right"></span> Medicaci&oacute;n Actual anti HCV</h2><br><br><!-- med -->



						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmtramedact">&iquest;Inici&oacute; tratamiento HCV?</label>
										<div class="col-sm-2"><?= gethtml('frmtramedact','yesno',$vew_patevlspc->frmtramedact,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div id="frmtramedactdiv" class="hidden">
										<table class="table table-striped table-condensed table-bordered">
											<tbody>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-2 control-label" for="frmtramedstrdte">Fecha de Inicio</label>
													<div class="col-sm-4"><?= gethtml('frmtramedstrdte','docdte',$vew_patevlspc->frmtramedstrdte, $lv_default); ?></div>
													<label class="col-sm-2 control-label" for="frmtramedenddte">Fecha de Finalizaci&oacute;n</label>
													<div class="col-sm-4"><?= gethtml('frmtramedenddte','docdte',$vew_patevlspc->frmtramedenddte, $lv_default); ?></div>
												</div>
											</td></tr>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-2 control-label" for="frmtramedchlpts">Child-Pugh Score pretratamiento</label>
													<label class="col-sm-2 control-label">Puntaje <small>(detallar)</small></label>
													<div class="col-sm-2"><?= gethtml('frmtramedchlpts','qty',$vew_patevlspc->frmtramedchlpts,$lv_default); ?></div>
													<div class="col-sm-2"><?= gethtml('frmtramedchltyp',array(''=>'','a'=>'A','b'=>'B','c'=>'C'), $vew_patevlspc->frmtramedchltyp ); ?></div>
													<div class="col-sm-2"><label>Paciente cirr&oacute;tico?</label></div>
													<div class="col-sm-2"><?= gethtml('frmtramedchlcrr','yesno',$vew_patevlspc->frmtramedchlcrr,$lv_default); ?></div>
												</div>
											</td></tr>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-2 control-label" for="frmtramedmldpts">MELD pretratamiento</label>
													<label class="col-sm-2 control-label">Puntaje <small>(detallar)</small></label>
													<div class="col-sm-2"><?= gethtml('frmtramedmldpts','qty',$vew_patevlspc->frmtramedmldpts,$lv_default); ?></div>
												</div>
											</td></tr>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-2 control-label" for="frmtramedrib">Ribavirina</label>
													<div class="col-sm-4"><?= gethtml('frmtramedrib','yesno',$vew_patevlspc->frmtramedrib,$lv_default); ?></div>
													<label class="col-sm-2 control-label">Dosis <small>(mg)</small></label>
													<div class="col-sm-4"><?= gethtml('frmtramedribdss','qty',$vew_patevlspc->frmtramedribdss,$lv_default); ?></div>
												</div>
											</td></tr>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-2 control-label">Antivirales de Acci&oacute;n directa</label>
													<div class="col-sm-5">
														<label><input type="checkbox" id="frmtramedactaadchk" name="frmtramedactaad001" <?= ($vew_patevlspc->frmtramedactaad001!=''?'checked':''); ?>> Ninguno</label><br>
														<label><input type="checkbox" id="frmtramedactaadchk" name="frmtramedactaad002" <?= ($vew_patevlspc->frmtramedactaad002!=''?'checked':''); ?>> Sofosbuvir  SOVALDI</label><br>
														<label><input type="checkbox" id="frmtramedactaadchk" name="frmtramedactaad003" <?= ($vew_patevlspc->frmtramedactaad003!=''?'checked':''); ?>> Sofosbuvir  PROBIRASE u otro gen&eacute;rico</label><br>
														<!-- <label><input type="checkbox" id="frmtramedactantchk" name="frmtramedactant004" <?= ($vew_patevlspc->frmtramedactaad004!=''?'checked':''); ?>> Ledipasvir</label><br> -->
														<label><input type="checkbox" id="frmtramedactaadchk" name="frmtramedactaad013" <?= ($vew_patevlspc->frmtramedactaad013!=''?'checked':''); ?>> Sofosbuvir + Ledipasvir</label><br>
														<label><input type="checkbox" id="frmtramedactaadchk" name="frmtramedactaad014" <?= ($vew_patevlspc->frmtramedactaad014!=''?'checked':''); ?>> Sofosbuvir + Velpatasvir</label><br>
														<label><input type="checkbox" id="frmtramedactaadchk" name="frmtramedactaad005" <?= ($vew_patevlspc->frmtramedactaad005!=''?'checked':''); ?>> Daclatasvir - DAKLINZA</label><br>
														<label><input type="checkbox" id="frmtramedactaadchk" name="frmtramedactaad016" <?= ($vew_patevlspc->frmtramedactaad016!=''?'checked':''); ?>> Daclatasvir - GENERICO</label><br>
													</div>
													<div class="col-sm-5">
														<!-- <label><input type="checkbox" id="frmtramedactantchk" name="frmtramedactant006" <?= ($vew_patevlspc->frmtramedactaad006!=''?'checked':''); ?>> Velpatasvir</label><br> -->
														<label><input type="checkbox" id="frmtramedactaadchk" name="frmtramedactaad007" <?= ($vew_patevlspc->frmtramedactaad007!=''?'checked':''); ?>> Asunaprevir</label><br>
														<label><input type="checkbox" id="frmtramedactaadchk" name="frmtramedactaad008" <?= ($vew_patevlspc->frmtramedactaad008!=''?'checked':''); ?>> Simeprevir</label><br>
														<label><input type="checkbox" id="frmtramedactaadchk" name="frmtramedactaad009" <?= ($vew_patevlspc->frmtramedactaad009!=''?'checked':''); ?>> Paritaprevir/r + Ombitasvir + Dasabuvir</label><br>
														<label><input type="checkbox" id="frmtramedactaadchk" name="frmtramedactaad010" <?= ($vew_patevlspc->frmtramedactaad010!=''?'checked':''); ?>> Paritaprevir/r + Ombitasvir</label><br>
														<label><input type="checkbox" id="frmtramedactaadchk" name="frmtramedactaad011" <?= ($vew_patevlspc->frmtramedactaad011!=''?'checked':''); ?>> Grazoprevir/Elbasvir</label><br>
														<label><input type="checkbox" id="frmtramedactaadchk" name="frmtramedactaad012" <?= ($vew_patevlspc->frmtramedactaad012!=''?'checked':''); ?>> Glecaprevir + Pibrentasvir</label><br>
														<label><input type="checkbox" id="frmtramedactaadchk" name="frmtramedactaad013" <?= ($vew_patevlspc->frmtramedactaad013!=''?'checked':''); ?>> SOF/VEL/VOX</label><br>
													</div>
												</div>
											</td></tr>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-2 control-label" for="frmtramedhcv">HCV RNA basal<br><small>(UI/mL)</small></label>
													<div class="col-sm-4"><?= gethtml('frmtramedhcv','qty',$vew_patevlspc->frmtramedhcv,$lv_default); ?></div>
                        </div>
											</td></tr>
											</tbody>
										</table>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>



						<h2 id="tratamiento-02"><span class="fas fa-angle-right"></span> Eventos Adversos</h2><br><br><!-- evt -->



						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmtraevt">&iquest;Present&oacute; EE.AA.?</label>
										<div class="col-sm-2"><?= gethtml('frmtraevt','yesno',$vew_patevlspc->frmtraevt,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div id="frmtraevtdiv" class="hidden">
										<table class="table table-striped table-condensed table-bordered">
											<tbody>
												<tr><td>
													<div class="form-group tmss-form-group">
														<div class="col-sm-6">
															<label><?= gethtml('frmtraevt001','onoff',$vew_patevlspc->frmtraevt001,$lv_default); ?> Depresi&oacute;n</label><br>
															<label><?= gethtml('frmtraevt002','onoff',$vew_patevlspc->frmtraevt002,$lv_default); ?> Insomnio</label><br>
															<label><?= gethtml('frmtraevt003','onoff',$vew_patevlspc->frmtraevt003,$lv_default); ?> Irritabilidad</label><br>
															<label><?= gethtml('frmtraevt004','onoff',$vew_patevlspc->frmtraevt004,$lv_default); ?> Fiebre(>=38°C)</label><br>
															<label><?= gethtml('frmtraevt005','onoff',$vew_patevlspc->frmtraevt005,$lv_default); ?> Artralgias/Mialgias</label><br>
															<label><?= gethtml('frmtraevt006','onoff',$vew_patevlspc->frmtraevt006,$lv_default); ?> Astenia</label><br>
															<label><?= gethtml('frmtraevt007','onoff',$vew_patevlspc->frmtraevt007,$lv_default); ?> Requiri&oacute; disminuir dosis de Ribavirina?</label><br>
														</div>
														<div class="col-sm-6">
															<label><?= gethtml('frmtraevt008','onoff',$vew_patevlspc->frmtraevt008,$lv_default); ?> Cefalea</label><br>
															<label><?= gethtml('frmtraevt009','onoff',$vew_patevlspc->frmtraevt009,$lv_default); ?> Diarrea</label><br>
															<label><?= gethtml('frmtraevt010','onoff',$vew_patevlspc->frmtraevt010,$lv_default); ?> N&aacute;useas/V&oacute;mitos</label><br>
															<label><?= gethtml('frmtraevt011','onoff',$vew_patevlspc->frmtraevt011,$lv_default); ?> &iquest;Aumento Bilirrubina x2 o > del basal?</label><br>
															<label><?= gethtml('frmtraevt012','onoff',$vew_patevlspc->frmtraevt012,$lv_default); ?> Rash</label><br>
															<label><?= gethtml('frmtraevt013','onoff',$vew_patevlspc->frmtraevt013,$lv_default); ?> Prurito</label><br>
															<label><?= gethtml('frmtraevt014','onoff',$vew_patevlspc->frmtraevt014,$lv_default); ?> &iquest;Deterioro de la funci&oacute;n renal?</label><br>
															<div id="frmtraevt014div" class="hidden">
																<label>Severidad</label><br>
																<?= gethtml('frmtraevt014sev',array(''=>'','estadio1'=>'Estadio 1','estadio2'=>'Estadio 2','estadio3'=>'Estadio 3'), $vew_patevlspc->frmtraevt014sev ); ?><br>
																<ul>
																	<li><strong>Estadio 1:</strong> aumento > 0.3 mg/dL dentro de 48hrs o aumento > 1.5 a 1.9 X con respecto al basal</li><br>
																	<li><strong>Estadio 2:</strong> aumento > 2 a 2.9 X con respecto al basal</li><br>
																	<li><strong>Estadio 3:</strong> aumento > 3 X con respecto al basal o aumento > 4 mg/dL o di&aacute;lisis</li><br>
																</ul>
															</div>	
														</div>
													</div>
												</td></tr>
											</tbody>
										</table>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>



						<h1 id="evolucion"><span class="fas fa-caret-right"></span> Evoluci&oacute;n</h1><br><!-- evl -->



						<h2 id="evolucion-01"><span class="fas fa-angle-right"></span> Respuesta al tratamiento</h2><br><br><!-- res -->



						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmevlrestra">Respuesta al tratamiento</label>
										<div class="col-sm-6"><?= gethtml('frmevlrestra', array(''=>'','no_respondedor'=>'NO RESPONDEDOR','respuesta'=>'RESPUESTA VIRAL SOSTENIDA','suspension'=>'SUSPENSION DEL TRATAMIENTO'), $vew_patevlspc->frmevlrestra ); ?></div>
									</div>
									<div id="frmevlrestrasusdiv" class="hidden">
										<br><br>
										<table class="table table-condensed table-bordered">
											<tbody>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">En caso de haber suspendido <u>definitivamente</u> el tratamiento especificar:</label>
														<div class="col-sm-8"><?= gethtml('frmevlrestrasusdef',array(''=>'','intolerancia'=>'INTOLERANCIA - EFECTOS ADVERSOS','perdida_seguimiento'=>'PERDIDA DE SEGUIMIENTO','inconvenientes'=>'INCONVENIENTES CON EL SUMINISTRO DE LA MEDICACIÓN'), $vew_patevlspc->frmevlrestrasusdef ); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">								
														<label class="col-sm-4 control-label">En caso de haber suspendido <u>transitoriamente</u> el tratamiento especificar:</label>
														<div class="col-sm-8"><?= gethtml('frmevlrestrasustra',array(''=>'','intolerancia'=>'INTOLERANCIA - EFECTOS ADVERSOS','perdida_seguimiento'=>'PERDIDA DE SEGUIMIENTO','inconvenientes'=>'INCONVENIENTES CON EL SUMINISTRO DE LA MEDICACIÓN'), $vew_patevlspc->frmevlrestrasustra ); ?></div>
													</div>
												</td></tr>
											</tbody>
										</table>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br><br>
						
						
						
						<h2 id="evolucion-05"><span class="fas fa-angle-right"></span> Laboratorio</h2>
						<h4>Evoluci&oacute;n durante el tratamiento</h4>
						<br><br><!-- lab -->



						<div class="container-fluid" role="tabpanel">
							<table class="table table-striped table-condensed">
								<thead>
									<tr><th></th><th>Basal</th><th>Sem 4</th><th>Fin de Tto.</th><th>Sem 12 post tto</th></tr>
								</thead>
								<tbody>
									<tr><td>ID</td>
										<td><?= gethtml('evlcod1','doccmt1x20',(isset($vew_patpln[1]['evlcod'])?$vew_patpln[1]['evlcod']:''),$lv_always_disabled); ?></td>
										<td><?= gethtml('evlcod2','doccmt1x20',(isset($vew_patpln[2]['evlcod'])?$vew_patpln[2]['evlcod']:''),$lv_always_disabled); ?></td>
										<td><?= gethtml('evlcod3','doccmt1x20',(isset($vew_patpln[3]['evlcod'])?$vew_patpln[3]['evlcod']:''),$lv_always_disabled); ?></td>
										<td><?= gethtml('evlcod4','doccmt1x20',(isset($vew_patpln[4]['evlcod'])?$vew_patpln[4]['evlcod']:''),$lv_always_disabled); ?></td>
									</tr>
									<tr><td>Bilirrubina Total<br><small>(mg/dL)</small></td>
										<td><?= gethtml('frmevllabbil1','docnum0602',(isset($vew_patpln[1]['frmevllabbil'])?$vew_patpln[1]['frmevllabbil']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabbil2','docnum0602',(isset($vew_patpln[2]['frmevllabbil'])?$vew_patpln[2]['frmevllabbil']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabbil3','docnum0602',(isset($vew_patpln[3]['frmevllabbil'])?$vew_patpln[3]['frmevllabbil']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabbil4','docnum0602',(isset($vew_patpln[4]['frmevllabbil'])?$vew_patpln[4]['frmevllabbil']:''),$lv_default); ?></td>
									</tr>
									<tr><td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
										<td><?= gethtml('frmevllabalb1','docnum0501',(isset($vew_patpln[1]['frmevllabalb'])?$vew_patpln[1]['frmevllabalb']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabalb2','docnum0501',(isset($vew_patpln[2]['frmevllabalb'])?$vew_patpln[2]['frmevllabalb']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabalb3','docnum0501',(isset($vew_patpln[3]['frmevllabalb'])?$vew_patpln[3]['frmevllabalb']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabalb4','docnum0501',(isset($vew_patpln[4]['frmevllabalb'])?$vew_patpln[4]['frmevllabalb']:''),$lv_default); ?></td>
									</tr>
									<tr><td>RIN</td>
										<td><?= gethtml('frmevllabrin1','docnum0602',(isset($vew_patpln[1]['frmevllabrin'])?$vew_patpln[1]['frmevllabrin']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabrin2','docnum0602',(isset($vew_patpln[2]['frmevllabrin'])?$vew_patpln[2]['frmevllabrin']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabrin3','docnum0602',(isset($vew_patpln[3]['frmevllabrin'])?$vew_patpln[3]['frmevllabrin']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabrin4','docnum0602',(isset($vew_patpln[4]['frmevllabrin'])?$vew_patpln[4]['frmevllabrin']:''),$lv_default); ?></td>
									</tr>
									<tr><td>Quick<br><small>(%)</small></td>
										<td><?= gethtml('frmevllabqck1','docnum0602',(isset($vew_patpln[1]['frmevllabqck'])?$vew_patpln[1]['frmevllabqck']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabqck2','docnum0602',(isset($vew_patpln[2]['frmevllabqck'])?$vew_patpln[2]['frmevllabqck']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabqck3','docnum0602',(isset($vew_patpln[3]['frmevllabqck'])?$vew_patpln[3]['frmevllabqck']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabqck4','docnum0602',(isset($vew_patpln[4]['frmevllabqck'])?$vew_patpln[4]['frmevllabqck']:''),$lv_default); ?></td>
									</tr>
									<tr><td>Hemoglobina<br><small>(g/dL)</small></td>
										<td><?= gethtml('frmevllabhem1','docnum0501',(isset($vew_patpln[1]['frmevllabhem'])?$vew_patpln[1]['frmevllabhem']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabhem2','docnum0501',(isset($vew_patpln[2]['frmevllabhem'])?$vew_patpln[2]['frmevllabhem']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabhem3','docnum0501',(isset($vew_patpln[3]['frmevllabhem'])?$vew_patpln[3]['frmevllabhem']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabhem4','docnum0501',(isset($vew_patpln[4]['frmevllabhem'])?$vew_patpln[4]['frmevllabhem']:''),$lv_default); ?></td>
									</tr>
									<tr><td>Leucocitos<br><small>(/mm3)</small></td>
										<td><?= gethtml('frmevllableu1','docnum0500',(isset($vew_patpln[1]['frmevllableu'])?$vew_patpln[1]['frmevllableu']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllableu2','docnum0500',(isset($vew_patpln[2]['frmevllableu'])?$vew_patpln[2]['frmevllableu']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllableu3','docnum0500',(isset($vew_patpln[3]['frmevllableu'])?$vew_patpln[3]['frmevllableu']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllableu4','docnum0500',(isset($vew_patpln[4]['frmevllableu'])?$vew_patpln[4]['frmevllableu']:''),$lv_default); ?></td>
									</tr>
									<tr><td>Plaquetas<br><small>(/mm3)</small></td>
										<td><?= gethtml('frmevllabpla1','docnum0600',(isset($vew_patpln[1]['frmevllabpla'])?$vew_patpln[1]['frmevllabpla']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabpla2','docnum0600',(isset($vew_patpln[2]['frmevllabpla'])?$vew_patpln[2]['frmevllabpla']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabpla3','docnum0600',(isset($vew_patpln[3]['frmevllabpla'])?$vew_patpln[3]['frmevllabpla']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabpla4','docnum0600',(isset($vew_patpln[4]['frmevllabpla'])?$vew_patpln[4]['frmevllabpla']:''),$lv_default); ?></td>
									</tr>
									<tr><td>Creatinina<br><small>(mg/dL)</small></td>
										<td><?= gethtml('frmevllabcre1','docnum0602',(isset($vew_patpln[1]['frmevllabcre'])?$vew_patpln[1]['frmevllabcre']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabcre2','docnum0602',(isset($vew_patpln[2]['frmevllabcre'])?$vew_patpln[2]['frmevllabcre']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabcre3','docnum0602',(isset($vew_patpln[3]['frmevllabcre'])?$vew_patpln[3]['frmevllabcre']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabcre4','docnum0602',(isset($vew_patpln[4]['frmevllabcre'])?$vew_patpln[4]['frmevllabcre']:''),$lv_default); ?></td>
									</tr>
									<tr><td>CKD-EPI<br><small></small></td>
										<td><?= gethtml('frmevllabckd1','docnum0602',"",$lv_always_disabled); ?></td>
										<td>&nbsp;</td><td>&nbsp;</td>
										<td><?= gethtml('frmevllabckd4','docnum0602',"",$lv_always_disabled); ?></td>
									</tr>
									<tr><td>AFP<br><small>(UI/mL)</small></td>
										<td><?= gethtml('frmevllabafp1','docnum0602',(isset($vew_patpln[1]['frmevllabafp'])?$vew_patpln[1]['frmevllabafp']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabafp2','docnum0602',(isset($vew_patpln[2]['frmevllabafp'])?$vew_patpln[2]['frmevllabafp']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabafp3','docnum0602',(isset($vew_patpln[3]['frmevllabafp'])?$vew_patpln[3]['frmevllabafp']:''),$lv_default); ?></td>
										<td><?= gethtml('frmevllabafp4','docnum0602',(isset($vew_patpln[4]['frmevllabafp'])?$vew_patpln[4]['frmevllabafp']:''),$lv_default); ?></td>
									</tr>
									<tr><td>HCV RNA<br><small>(UI/mL)</small></td>
										<td><?= gethtml('frmevllabhcv1',array(''=>'','detectable'=>'DETECTABLE','no_detectable'=>'NO DETECTABLE','no_disponible'=>'NO DISPONIBLE'),(isset($vew_patpln[1]['frmevllabhcv'])?$vew_patpln[1]['frmevllabhcv']:'')); ?></td>
										<td><?= gethtml('frmevllabhcv2',array(''=>'','detectable'=>'DETECTABLE','no_detectable'=>'NO DETECTABLE','no_disponible'=>'NO DISPONIBLE'),(isset($vew_patpln[2]['frmevllabhcv'])?$vew_patpln[2]['frmevllabhcv']:'')); ?></td>
										<td><?= gethtml('frmevllabhcv3',array(''=>'','detectable'=>'DETECTABLE','no_detectable'=>'NO DETECTABLE','no_disponible'=>'NO DISPONIBLE'),(isset($vew_patpln[3]['frmevllabhcv'])?$vew_patpln[3]['frmevllabhcv']:'')); ?></td>
										<td><?= gethtml('frmevllabhcv4',array(''=>'','detectable'=>'DETECTABLE','no_detectable'=>'NO DETECTABLE','no_disponible'=>'NO DISPONIBLE'),(isset($vew_patpln[4]['frmevllabhcv'])?$vew_patpln[4]['frmevllabhcv']:'')); ?></td>
									</tr>
								</tbody>
							</table>
						</div> <!-- /container-fluid -->
						<br><br><br>

						

						<h2 id="evolucion-02"><span class="fas fa-angle-right"></span> Evoluci&oacute;n de complicaciones hep&aacute;ticas posterior a la finalizaci&oacute;n del tratamiento</h2><br><br><!-- com012 -->



						<table class="table table-striped table-condensed" id="tblevl">
							<tbody>
								<tr><td>
									<a href="#" id="btnnewseg" class="btn btn-primary"><span class="fas fa-plus"></span> Nuevo Seguimiento</a>
									<a href="#" id="btnmodseg" class="btn <?= ((isset($vew_patpln[0]['evlcod'])?$vew_patpln[0]['evlcod']:'')==''?'btn-default disabled':'btn-primary'); ?>"><span class="fas fa-pencil-alt"></span> Modificar Seguimiento</a>
									<div class="pull-right"><a href="#" id="btnseg" class="btn <?= ((isset($vew_patpln[0]['evlcod'])?$vew_patpln[0]['evlcod']:'')==''?'btn-default disabled':'btn-primary'); ?>"><span class="fas fa-chart-line"></span> Seguimientos</a></div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmevlcom">Fecha de &uacute;ltimo seguimiento</label>
										<div class="col-sm-3"><?= gethtml('frmevlcomdte0','docdte',(isset($vew_patpln[0]['frmevlcomdte'])?$vew_patpln[0]['frmevlcomdte']:''),$lv_always_disabled); ?></div>
										<label class="col-sm-2 control-label" for="frmevlcomcod">ID</label>
										<div class="col-sm-3"><?= gethtml('evlcod0','doccmt1x20',(isset($vew_patpln[0]['evlcod'])?$vew_patpln[0]['evlcod']:''),$lv_always_disabled); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmevlcommue">&iquest;Muerte?</label>
										<div class="col-sm-3"><?= gethtml('frmevlcommue0',array(''=>'','hepatica'=>'SI, causa Hepatica','no_hepatica'=>'SI, causa NO hepatica', 'no'=>'NO'), (isset($vew_patpln[0]['frmevlcommue'])?$vew_patpln[0]['frmevlcommue']:''), $lv_always_disabled); ?></div>
										<div class="hidden" id="frmevlcommue0div">
											<label class="col-sm-2 control-label">Fecha</label>
											<div class="col-sm-3"><?= gethtml('frmevlcommuedte0','docdte',(isset($vew_patpln[0]['frmevlcommuedte'])?$vew_patpln[0]['frmevlcommuedte']:''), $lv_always_disabled); ?></div>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmevlcomtra">&iquest;Trasplante hep&aacute;tico?</label>
										<div class="col-sm-3"><?= gethtml('frmevlcomtra0','yesno',(isset($vew_patpln[0]['frmevlcomtra'])?$vew_patpln[0]['frmevlcomtra']:''), $lv_always_disabled); ?></div>
										<div class="hidden" id="frmevlcomtra0div">
											<label class="col-sm-2 control-label">Fecha</label>
											<div class="col-sm-3"><?= gethtml('frmevlcomtradte0','docdte',(isset($vew_patpln[0]['frmevlcomtradte'])?$vew_patpln[0]['frmevlcomtradte']:''), $lv_always_disabled); ?></div>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmevlcomhpt">&iquest;Hepatocarcinoma?</label>
										<div class="col-sm-3"><?= gethtml('frmevlcomhpt0','yesno',(isset($vew_patpln[0]['frmevlcomhpt'])?$vew_patpln[0]['frmevlcomhpt']:''), $lv_always_disabled); ?></div>
										<!--
										<div class="hidden" id="frmevlcomhpt0div">
											<label class="col-sm-2 control-label">Fecha</label>
											<div class="col-sm-3"><?= gethtml('frmevlcomhptdte0','docdte',(isset($vew_patpln[0]['frmevlcomhptdte'])?$vew_patpln[0]['frmevlcomhptdte']:''), $lv_always_disabled); ?></div>
										</div>
										-->
									</div>
									<div class="form-grooup tmss-form-group" class="hidden" id="frmevlcomhpt0div">
										<div class="col-sm-4"></div>
										<div class="col-sm-8">
										
											<h2 id="evolucion-04"><span class="fas fa-angle-right"></span> Hepatocarcinoma</h2>
											<h4>(Completar SOLO en aquellos pacientes con diagn&oacute;stico de HCC durante o posterior al tratamiento antiviral)</h4>
											<br><!-- hpt -->
											<table class="table table-striped table-condensed">
												<tbody>
													<tr><td>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label" for="frmevlhptdtehcc">Fecha diagn&oacute;stico HCC</label>
															<div class="col-sm-8"><?= gethtml('frmevlhptdtehcc0','docdte', (isset($vew_patpln[0]['frmevlhptdtehcc'])?$vew_patpln[0]['frmevlhptdtehcc']:''), $lv_always_disabled ); ?></div>
														</div>
													</td></tr>
													<tr><td>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label" for="frmevlhptscr">Ecograf&iacute;a de Screening HCC</label>
															<div class="col-sm-8"><?= gethtml('frmevlhptscr0',array(''=>'','sin_nodulos'=>'SIN NODULOS','con_nodulos'=>'CON NODULOS'), (isset($vew_patpln[0]['frmevlhptscr'])?$vew_patpln[0]['frmevlhptscr']:''), $lv_always_disabled ); ?></div>
														</div>
													</td></tr>
													<tr><td>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label" for="frmevlhptecg">ECOG al diagn&oacute;stico del HCC</label>
															<div class="col-sm-8"><?= gethtml('frmevlhptecg0', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), (isset($vew_patpln[0]['frmevlhptecg'])?$vew_patpln[0]['frmevlhptecg']:''), $lv_always_disabled); ?><br>
																<ul>
																	<li><strong>ECOG 0:</strong> actividad de la vida diaria completa, sin ninguna restricci&oacute;n.</li><br>
																	<li><strong>ECOG 1:</strong> Restricci&oacute;n leve f&iacute;sica a las actividades diarias, pero capaz de realizar actividades ambulatorias y en su hogar, capaz de trabajar.</li><br>
																	<li><strong>ECOG 2:</strong> Capaz de auto valerse por si mismo, deambula pero restricci&oacute;n f&iacute;sica para realizar cualquier actividad laboral.</li><br>
																	<li><strong>ECOG 3:</strong> Confinado a silla de ruedas o cama >50% del tiempo diario.</li><br>
																	<li><strong>ECOG 4:</strong> completamente discapacitado y dependiente para las actividades diarias, confinado a silla de ruedas o cama.</li><br>
																</ul>
															</div>
														</div>
													</td></tr>
													<tr><td>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label" for="frmevlhptdia">Diagn&oacute;stico de HCC</label>
															<div class="col-sm-8">
																<label><?= gethtml("frmevlhptdiatom0","onoff",(isset($vew_patpln[0]['frmevlhptdiatom'])?$vew_patpln[0]['frmevlhptdiatom']:''),$lv_always_disabled); ?> Tomograf&iacute;a axial computada</label><br>
																<label><?= gethtml("frmevlhptdiares0","onoff",(isset($vew_patpln[0]['frmevlhptdiares'])?$vew_patpln[0]['frmevlhptdiares']:''),$lv_always_disabled); ?> Resonancia Magn&eacute;tica Nuclear</label><br>
																<label><?= gethtml('frmevlhptdiabio0','onoff',(isset($vew_patpln[0]['frmevlhptdiabio'])?$vew_patpln[0]['frmevlhptdiabio']:''),$lv_always_disabled); ?> Biopsia Hep&aacute;tica</label><br>
															</div>
														</div>
													</td></tr>
													<tr><td>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label" for="frmevlhptnod">N&uacute;mero de n&oacute;dulos de HCC</label>
															<div class="col-sm-8"><?= gethtml('frmevlhptnod0','qty',(isset($vew_patpln[0]['frmevlhptnod'])?$vew_patpln[0]['frmevlhptnod']:''),$lv_always_disabled); ?></div>
														</div>
													</td></tr>
													<tr><td>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label" for="frmevlhptnoddmt">Di&aacute;metro del n&oacute;dulo mayor de HCC <small>mm</small></label>
															<div class="col-sm-8"><?= gethtml('frmevlhptnoddmt0','qty',(isset($vew_patpln[0]['frmevlhptnoddmt'])?$vew_patpln[0]['frmevlhptnoddmt']:''),$lv_always_disabled); ?></div>
														</div>
													</td></tr>
													<tr><td>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label" for="frmevlhptnodsum">Suma de di&aacute;metros de los n&oacute;dulos HCC <small>mm</small></label>
															<div class="col-sm-8"><?= gethtml('frmevlhptnodsum0','qty',(isset($vew_patpln[0]['frmevlhptnodsum'])?$vew_patpln[0]['frmevlhptnodsum']:''),$lv_always_disabled); ?></div>
														</div>
													</td></tr>
													<tr><td>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label" for="frmevlhptlstout">&iquest;Sali&oacute; de lista de trasplante hep&aacute;tico?</label>
															<div class="col-sm-8"><?= gethtml('frmevlhptlstout0',array(''=>'','si'=>'SI','no'=>'NO','inexistente'=>'NO SE ENCONTRABA EN LA LISTA'), (isset($vew_patpln[0]['frmevlhptlstout'])?$vew_patpln[0]['frmevlhptlstout']:''), $lv_always_disabled ); ?></div>
														</div>
													</td></tr>
													<tr><td>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label" for="frmevlhptloc">Localizaci&oacute;n hep&aacute;tica</label>
															<div class="col-sm-8"><?= gethtml('frmevlhptloc0',array(''=>'','unilobar'=>'UNILOBAR','bilobar'=>'BILOBAR'), (isset($vew_patpln[0]['frmevlhptloc'])?$vew_patpln[0]['frmevlhptloc']:''), $lv_always_disabled); ?></div>
														</div>
													</td></tr>
													<tr><td>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label" for="frmevlhptlocext">Localizaci&oacute;n extrahep&aacute;tica</label>
															<div class="col-sm-4">
																<label><input type="checkbox" id="frmevlhptlocextchk" name="frmevlhptlocext0010" <?= ((isset($vew_patpln[0]['frmevlhptlocext001'])?$vew_patpln[0]['frmevlhptlocext001']:'')!=''?'checked':''); ?>> No</label><br>
																<label><input type="checkbox" id="frmevlhptlocextchk" name="frmevlhptlocext0020" <?= ((isset($vew_patpln[0]['frmevlhptlocext002'])?$vew_patpln[0]['frmevlhptlocext002']:'')!=''?'checked':''); ?>> Invasi&oacute;n Vascular</label><br>
																<label><input type="checkbox" id="frmevlhptlocextchk" name="frmevlhptlocext0030" <?= ((isset($vew_patpln[0]['frmevlhptlocext003'])?$vew_patpln[0]['frmevlhptlocext003']:'')!=''?'checked':''); ?>> Ganglionar</label><br>
															</div>
															<div class="col-sm-4">
																<label><input type="checkbox" id="frmevlhptlocextchk" name="frmevlhptlocext0040" <?= ((isset($vew_patpln[0]['frmevlhptlocext004'])?$vew_patpln[0]['frmevlhptlocext004']:'')!=''?'checked':''); ?>> Pulmonar</label><br>
																<label><input type="checkbox" id="frmevlhptlocextchk" name="frmevlhptlocext0050" <?= ((isset($vew_patpln[0]['frmevlhptlocext005'])?$vew_patpln[0]['frmevlhptlocext005']:'')!=''?'checked':''); ?>> Osea</label><br>
																<label><input type="checkbox" id="frmevlhptlocextchk" name="frmevlhptlocext0060" <?= ((isset($vew_patpln[0]['frmevlhptlocext006'])?$vew_patpln[0]['frmevlhptlocext006']:'')!=''?'checked':''); ?>> Otra</label><br>
															</div>										
														</div>
													</td></tr>
													<tr><td>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label" for="frmevlhpttra">Primer tratamiento realizado para el HCC</label>
															<div class="col-sm-8">
																<label><?= gethtml('frmevlhpttrachk0010','onoff',(isset($vew_patpln[0]['frmevlhpttrachk001'])?$vew_patpln[0]['frmevlhpttrachk001']:''),$lv_always_disabled); ?> Ablaci&oacute;n por Radiofrecuencia</label><br>
																<label><?= gethtml('frmevlhpttrachk0020','onoff',(isset($vew_patpln[0]['frmevlhpttrachk002'])?$vew_patpln[0]['frmevlhpttrachk002']:''),$lv_always_disabled); ?> Ablaci&oacute;n percut&aacute;nea/quir&uacute;rgico</label><br>
																<label><?= gethtml('frmevlhpttrachk0030','onoff',(isset($vew_patpln[0]['frmevlhpttrachk003'])?$vew_patpln[0]['frmevlhpttrachk003']:''),$lv_always_disabled); ?> Resecci&oacute;n Quir&uacute;rgica</label><br>
																<label><?= gethtml('frmevlhpttrachk0040','onoff',(isset($vew_patpln[0]['frmevlhpttrachk004'])?$vew_patpln[0]['frmevlhpttrachk004']:''),$lv_always_disabled); ?> Evaluado para trasplante / Trasplantado Hep&aacute;tico</label><br>
																<label><?= gethtml('frmevlhpttrachk0050','onoff',(isset($vew_patpln[0]['frmevlhpttrachk005'])?$vew_patpln[0]['frmevlhpttrachk005']:''),$lv_always_disabled); ?> Quimioembolizaci&oacute;n transarterial con Doxorrubicina/Lipiodol convencional</label><br>
																<label><?= gethtml('frmevlhpttrachk0060','onoff',(isset($vew_patpln[0]['frmevlhpttrachk006'])?$vew_patpln[0]['frmevlhpttrachk006']:''),$lv_always_disabled); ?> Quimioembolizaci&oacute;n transarterial con micropart&iacute;culas  DC BEADS</label><br>
																<label><?= gethtml('frmevlhpttrachk0070','onoff',(isset($vew_patpln[0]['frmevlhpttrachk007'])?$vew_patpln[0]['frmevlhpttrachk007']:''),$lv_always_disabled); ?> Radioembolizaci&oacute;n transarterial</label><br>
																<label><?= gethtml('frmevlhpttrachk0080','onoff',(isset($vew_patpln[0]['frmevlhpttrachk008'])?$vew_patpln[0]['frmevlhpttrachk008']:''),$lv_always_disabled); ?> Quimioterapia sist&eacute;mica</label><br>
																<label><?= gethtml('frmevlhpttrachk0090','onoff',(isset($vew_patpln[0]['frmevlhpttrachk009'])?$vew_patpln[0]['frmevlhpttrachk009']:''),$lv_always_disabled); ?> Sorafenib</label><br>
																<label><?= gethtml('frmevlhpttrachk0100','onoff',(isset($vew_patpln[0]['frmevlhpttrachk010'])?$vew_patpln[0]['frmevlhpttrachk010']:''),$lv_always_disabled); ?> Soporte paliativo</label><br>
																<label><?= gethtml('frmevlhpttrachk0110','onoff',(isset($vew_patpln[0]['frmevlhpttrachk011'])?$vew_patpln[0]['frmevlhpttrachk011']:''),$lv_always_disabled); ?> Ingreso en protocolo Cl&iacute;nico de Investigaci&oacute;n</label><br>
															</div>
														</div>
													</td></tr>
												</tbody>
											</table>
											<br><br>

										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmevlcom">&iquest;Ha presentado complicaciones hep&aacute;ticas?</label>
										<div class="col-sm-3"><?= gethtml('frmevlcom0','yesno',(isset($vew_patpln[0]['frmevlcom'])?$vew_patpln[0]['frmevlcom']:''),$lv_always_disabled); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div id="frmevlcom0div" class="hidden">
										<table class="table table-striped table-condensed table-bordered">
											<tbody>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-4 control-label" for="frmevlcomasc">&iquest;Desarrollo de Ascitis?</label>
													<div class="col-sm-5"><?= gethtml('frmevlcomasc0','yesnounknown',(isset($vew_patpln[0]['frmevlcomasc'])?$vew_patpln[0]['frmevlcomasc']:''), $lv_always_disabled); ?></div>
												</div>
											</td></tr>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-4 control-label" for="frmevlcompbe">&iquest;Desarrollo de  PBE?</label>
													<div class="col-sm-5"><?= gethtml('frmevlcompbe0','yesno',(isset($vew_patpln[0]['frmevlcompbe'])?$vew_patpln[0]['frmevlcompbe']:''), $lv_always_disabled); ?></div>
												</div>
											</td></tr>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-4 control-label" for="frmevlcomenc">&iquest;Desarrollo de Encefalopat&iacute;a?</label>
													<div class="col-sm-5"><?= gethtml('frmevlcomenc0','yesnounknown',(isset($vew_patpln[0]['frmevlcomenc'])?$vew_patpln[0]['frmevlcomenc']:''), $lv_always_disabled); ?></div>
												</div>
											</td></tr>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-4 control-label" for="frmevlcomsan">&iquest;Sangrado variceal?</label>
													<div class="col-sm-5"><?= gethtml('frmevlcomsan0','yesnounknown',(isset($vew_patpln[0]['frmevlcomsan'])?$vew_patpln[0]['frmevlcomsan']:''), $lv_always_disabled); ?></div>
												</div>
											</td></tr>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-4 control-label" for="frmevlcomlstout">&iquest;Sali&oacute; de lista de trasplante hep&aacute;tico?</label>
													<div class="col-sm-5"><?= gethtml('frmevlcomlstout0',array(''=>'','si'=>'SI','no'=>'NO','inexistente'=>'NO SE ENCONTRABA EN LA LISTA'),(isset($vew_patpln[0]['frmevlcomlstout'])?$vew_patpln[0]['frmevlcomlstout']:''), $lv_always_disabled ); ?></div>
												</div>
											</td></tr>
											<tr><td>
												<div class="form-group tmss-form-group">
													<label class="col-sm-4 control-label" for="frmevlcomcex">&iquest;Complicaciones extrahep&aacute;ticas?</label>
													<div class="col-sm-3"><?= gethtml('frmevlcomcex0','yesno',(isset($vew_patpln[0]['frmevlcomcex'])?$vew_patpln[0]['frmevlcomcex']:''), $lv_always_disabled); ?></div>
													<div class="col-sm-5 hidden" id="frmevlcomcex0div">
														<table class="table table-condensed table-bordered">
															<tbody>
																<tr><td>Diabetes</td><td><?= gethtml('frmevlcomcexdia0','docdte',(isset($vew_patpln[0]['frmevlcomcexdia'])?$vew_patpln[0]['frmevlcomcexdia']:''), $lv_always_disabled); ?></td></tr>
																<tr><td>Enfermedad coronaria</td><td><?= gethtml('frmevlcomcexcor0','docdte',(isset($vew_patpln[0]['frmevlcomcexcor'])?$vew_patpln[0]['frmevlcomcexcor']:''), $lv_always_disabled); ?></td></tr>
																<tr><td>Enfermedad cerebrovascular</td><td><?= gethtml('frmevlcomcexcer0','docdte',(isset($vew_patpln[0]['frmevlcomcexcer'])?$vew_patpln[0]['frmevlcomcexcer']:''), $lv_always_disabled); ?></td></tr>
															</tbody>
														</table>
													</div>
												</div>
											</td></tr>
											</tbody>
										</table>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-4 control-label" for="frmevllab">Laboratorio</label>
										<div class="col-sm-8">
											<table class="table table-striped table-condensed">
												<tbody>
													<tr>
														<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
														<td><?= gethtml('frmevllabbil0','docnum0602',(isset($vew_patpln[0]['frmevllabbil'])?$vew_patpln[0]['frmevllabbil']:''),$lv_always_disabled); ?></td>
														<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
														<td><?= gethtml('frmevllabalb0','docnum0501',(isset($vew_patpln[0]['frmevllabalb'])?$vew_patpln[0]['frmevllabalb']:''),$lv_always_disabled); ?></td>
													</tr>
													<tr>
														<td>RIN</td>
														<td><?= gethtml('frmevllabrin0','docnum0602',(isset($vew_patpln[0]['frmevllabrin'])?$vew_patpln[0]['frmevllabrin']:''),$lv_always_disabled); ?></td>
														<td>Quick<br><small>(%)</small></td>
														<td><?= gethtml('frmevllabqck0','docnum0602',(isset($vew_patpln[0]['frmevllabqck'])?$vew_patpln[0]['frmevllabqck']:''),$lv_always_disabled); ?></td>
													</tr>
													<tr>
														<td>Hemoglobina<br><small>(g/dL)</small></td>
														<td><?= gethtml('frmevllabhem0','docnum0501',(isset($vew_patpln[0]['frmevllabhem'])?$vew_patpln[0]['frmevllabhem']:''),$lv_always_disabled); ?></td>
														<td>Leucocitos<br><small>(/mm3)</small></td>
														<td><?= gethtml('frmevllableu0','docnum0500',(isset($vew_patpln[0]['frmevllableu'])?$vew_patpln[0]['frmevllableu']:''),$lv_always_disabled); ?></td>
													</tr>
													<tr>
														<td>Plaquetas<br><small>(/mm3)</small></td>
														<td><?= gethtml('frmevllabpla0','docnum0600',(isset($vew_patpln[0]['frmevllabpla'])?$vew_patpln[0]['frmevllabpla']:''),$lv_always_disabled); ?></td>
														<td>Creatinina<br><small>(mg/dL)</small></td>
														<td><?= gethtml('frmevllabcre0','docnum0602',(isset($vew_patpln[0]['frmevllabcre'])?$vew_patpln[0]['frmevllabcre']:''),$lv_always_disabled); ?></td>
													</tr>
													<tr>
														<td>AFP<br><small>(UI/mL)</small></td>
														<td><?= gethtml('frmevllabafp0','docnum0602',(isset($vew_patpln[0]['frmevllabafp'])?$vew_patpln[0]['frmevllabafp']:''),$lv_always_disabled); ?></td>
														<td>HCV RNA<br><small>(UI/mL)</small></td>
														<td><?= gethtml('frmevllabhcv0',array(''=>'','detectable'=>'DETECTABLE','no_detectable'=>'NO DETECTABLE','no_disponible'=>'NO DISPONIBLE'),(isset($vew_patpln[0]['frmevllabhcv'])?$vew_patpln[0]['frmevllabhcv']:''), $lv_always_disabled); ?></td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br><br>




					</div> <!-- /bs-docs-section -->
				</div> <!-- /col-md-9 -->
				<div class="col-md-3">
					<nav class="bs-docs-sidebar hidden-print hidden-sm hidden-xs">
						<ul class="nav nav-stacked bs-docs-sidenav" id="sidebar">
							<li><a href="#paciente">Paciente</a>
								<ul class="nav bs-docs-sidenav">
									<li><a href="#paciente-01">Datos Demogr&aacute;ficos</a></li>
								</ul>
							</li>
							<li><a href="#patologia">Patolog&iacute;a</a>
								<ul class="nav bs-docs-sidenav">
									<li><a href="#patologia-01">Hepatitis C</a></li>
									<li><a href="#patologia-02">Estad&iacute;o</a></li>
									<li><a href="#patologia-03">Complicaciones hep&aacute;ticas previas</a></li>
								</ul>
							</li>
							<li><a href="#tratamiento">Tratamiento</a>
								<ul class="nav bs-docs-sidenav">
									<li><a href="#tratamiento-01">Medicaci&oacute;n actual anti HCV</a></li>
									<li><a href="#tratamiento-02">Eventos adversos</a></li>
								</ul>
							</li>
							<li><a href="#evolucion">Evoluci&oacute;n</a>
								<ul class="nav bs-docs-sidenav">
									<li><a href="#evolucion-01">Respuesta al tratamiento</a></li>
									<li><a href="#evolucion-05">Laboratorio</a></li>
									<li><a href="#evolucion-02">Complicaciones hep&aacute;ticas post trat</a></li>
								</ul>
							</li>
							<hr>
							<img class="img-responsive" src="https://temasis.com.ar/lalrean-org/library/images/logos/logolalrean.png">
						</ul>
					</nav>
				</div> <!-- /col-md-3 -->
				
			</div> <!-- /row -->
		</div> <!-- /container -->
	</form>
	<script>
		function toggleClass( lp_object, lp_action, lp_class ) {
			if ( lp_action=="add" ) {
				$(lp_object).addClass(lp_class);
			} else {
				$(lp_object).removeClass(lp_class);				
			}
		}
		
		function getAge(dateString) {
			var today = new Date();
			var birthDate = moment(dateString, "DD/MM/YYYY").toDate();
			var age = today.getFullYear() - birthDate.getFullYear();
			var m = today.getMonth() - birthDate.getMonth();
			if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
					age--;
			}
			return age;
		}

		function getCKD( lp_crea ) {
			var lv_age = getAge( $("#<?= $lv_sec; ?> #patbrndte").prop("value") );
			var lv_sex = $("#<?= $lv_sec; ?> #patsex").prop("value");
			lv_sex = lv_sex.toUpperCase();
			var lv_crea = lp_crea;
			var lv_crea_conv = lv_crea * 88.42;
			var lv_val = 0;
			if ( lv_sex!="" && lv_age!=0 && lv_crea_conv!=0 ) {
				lv_val = lv_val + 141;
				lv_val = lv_val * Math.pow( Math.min(lv_crea_conv/(lv_sex=="M"?80:62),1) , (lv_sex=="M"?-0.411:-0.329) );
				lv_val = lv_val * Math.pow( Math.max(lv_crea_conv/(lv_sex=="M"?80:62),1) , -1.209 );
				lv_val = lv_val * Math.pow( 0.993 , lv_age );
				lv_val = lv_val * (lv_sex=="M"?1:1.018);
				lv_val = lv_val * (lv_sex=="M"?1:1.159);
			}
			return lv_val;
		}
	
		toastr.options.timeOut= 5000;
		<?php
			if ( $vew_data->prscod=='' ) { echo 'toastr.error( "No est&aacute; registrado como prestador. Consulte con el administrador del sistema." );'; }
			if ( $vew_data->spccod=='' ) { echo 'toastr.error( "Su registro de prestador NO tiene especialidad asignada. Consulte con el administrador del sistema." );'; }
		?>
		$("#<?= $lv_sec; ?> #patbrndte").on("change",function(e){
			$("#<?= $lv_sec; ?> #patage").prop("value", getAge( $("#<?= $lv_sec; ?> #patbrndte").prop("value")) );
		});
		
		// lndcod
		$("#<?= $lv_sec; ?> #lndcod")
			.on("keyup", function(){ if($(this).prop("value")==""){$("#<?= $lv_sec; ?> #lndtxt").prop("value","");$("#<?= $lv_sec; ?> #lndregcod").prop("value","");$("#<?= $lv_sec; ?> #lndregtxt").prop("value","");} })
			.next("span").children("a:first").on("click", function(evt) {
				tmssPopup('Paises','index.php?prg=grladrlnd&prm_vewcod=VEW_GRL_DAT_LND_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[lndcod:lndcod],[lndtxt:lndtxt],[lndregcod:empty],[lndregtxt:empty]');
				evt.preventDefault();
			});

		$("#<?= $lv_sec; ?> :checkbox[id='frmpatdemant']").on("change",function(e){
			var lv_cur = $(this);
			if ( $(lv_cur).is(":checked") ) {
				$("#<?= $lv_sec; ?> :checkbox[id='frmpatdemant']").each(function(e){
					if ( $(this).prop("name")!=$(lv_cur).prop("name") ) {
						if ( $(lv_cur).prop("name")=="frmpatdemant001" ) { $(this).prop("checked",false).change(); }
						if ( $(this).prop("name")=="frmpatdemant001" ) { $(this).prop("checked",false).change(); }									
					}
				});
			}
		});
		
		$("#<?= $lv_sec; ?> :checkbox[id='frmpatdemtra']").on("change",function(e){
			var lv_cur = $(this);
			if ( $(lv_cur).is(":checked") ) {
				$("#<?= $lv_sec; ?> :checkbox[id='frmpatdemtra']").each(function(e){
					if ( $(this).prop("name")!=$(lv_cur).prop("name") ) {
						if ( $(lv_cur).prop("name")=="frmpatdemtra001" ) { $(this).prop("checked",false).change(); }
						if ( $(this).prop("name")=="frmpatdemtra001" ) { $(this).prop("checked",false).change(); }									
					}
				});
			}
		});
		
		$("#<?= $lv_sec; ?> :checkbox[id='frmpatdemcoi']").on("change",function(e){
			if ($(this).prop("name")=="frmpatdemcoi001" && $(this).is(":checked")) {
				$("#<?= $lv_sec; ?> :checkbox[name='frmpatdemcoi002']").prop("checked",false).change();
				$("#<?= $lv_sec; ?> :checkbox[name='frmpatdemcoi003']").prop("checked",false).change();
			} else if ( $(this).prop("name")=="frmpatdemcoi002" ) {
				if ( $(this).is(":checked") ) {
					$("#<?= $lv_sec; ?> #frmpatdemcoihiv").removeClass("hidden");
					$("#<?= $lv_sec; ?> :checkbox[name='frmpatdemcoi001']").prop("checked",false).change();
				} else {
					$("#<?= $lv_sec; ?> #frmpatdemcoihiv").addClass("hidden");
				}
			} else if ( $(this).prop("name")=="frmpatdemcoi003" ) {
				if ( $(this).is(":checked") ) {
					$("#<?= $lv_sec; ?> #frmpatdemcoihbv").removeClass("hidden");
					$("#<?= $lv_sec; ?> :checkbox[name='frmpatdemcoi001']").prop("checked",false).change();
				} else {
					$("#<?= $lv_sec; ?> #frmpatdemcoihbv").addClass("hidden");						
				}
			}
		});
		
		$("#<?= $lv_sec; ?> :checkbox[id='frmtramedactaadchk']").on("change",function(e){
			var lv_cur = $(this);
			if ( $(lv_cur).is(":checked") ) {
				$("#<?= $lv_sec; ?> :checkbox[id='frmtramedactaadchk']").each(function(e){
					if ( $(this).prop("name")!=$(lv_cur).prop("name") ) {
						if ( $(lv_cur).prop("name")=="frmtramedactaad001" ) { $(this).prop("checked",false).change(); }
						if ( $(this).prop("name")=="frmtramedactaad001" ) { $(this).prop("checked",false).change(); }									
					}
				});
			}
		});
		
		$("#<?= $lv_sec; ?> :checkbox[id='frmptocomhptlocextchk']").on("change",function(e){
			var lv_cur = $(this);
			if ( $(lv_cur).is(":checked") ) {
				$("#<?= $lv_sec; ?> :checkbox[id='frmptocomhptlocextchk']").each(function(e){
					if ( $(this).prop("name")!=$(lv_cur).prop("name") ) {
						if ( $(lv_cur).prop("name")=="frmptocomhptlocext001" ) { $(this).prop("checked",false).change(); }
						if ( $(this).prop("name")=="frmptocomhptlocext001" ) { $(this).prop("checked",false).change(); }									
					}
				});
			}
		});
		
		$("#<?= $lv_sec; ?> :checkbox[id='frmevlhptlocextchk']").on("change",function(e){
			var lv_cur = $(this);
			if ( $(lv_cur).is(":checked") ) {
				$("#<?= $lv_sec; ?> :checkbox[id='frmevlhptlocextchk']").each(function(e){
					if ( $(this).prop("name")!=$(lv_cur).prop("name") ) {
						if ( $(lv_cur).prop("name")=="frmevlhptlocext0010" ) { $(this).prop("checked",false).change(); }
						if ( $(this).prop("name")=="frmevlhptlocext0010" ) { $(this).prop("checked",false).change(); }									
					}
				});
			}
		});
		
		$("#<?= $lv_sec; ?> #frmptohepvia").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmptohepviaotrdiv"),($(this).prop("value")=="otro"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmptoheptra").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmptoheptradiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmptohepman").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmptohepmandiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmptoestmet").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmptoestmetdiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmptoestser").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmptoestserdiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmptocomanthpt").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmptocomanthptdiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmptoheptrachk05").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmptoheptrachk05div"),($(this).is(":checked")?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtramedact").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtramedactdiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraevt"   ).on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraevtdiv"   ),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraevt014").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraevt014div"),($(this).is(":checked")?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmevlrestra").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmevlrestrasusdiv"),($(this).prop("value")=="suspension"?"remove":"add"),"hidden"); });
		
		$("#<?= $lv_sec; ?> #frmevlcom0").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmevlcom0div"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmevlcomtra0").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmevlcomtra0div"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmevlcomhpt0").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmevlcomhpt0div"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmevlcommue0").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmevlcommue0div"),($(this).prop("value")=="hepatica" || $(this).prop("value")=="no_hepatica"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmevlcomcex0").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmevlcomcex0div"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
			
		$("#<?= $lv_sec; ?> #frmptohepman006").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmptohepman006div"),($(this).is(":checked")?"remove":"add"),"hidden"); });

		tmssLoadScript("toggle",function(){
			$("#<?= $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: "success", offstyle: "default", on: "Si", off: "No", size: "small" });
				$(this).trigger("change");
			});
		});
		
		$("#<?= $lv_sec; ?> select").each( function() {
			$(this).trigger("change");
		});
		
		$("#<?= $lv_sec; ?> #patsex, #<?= $lv_sec; ?> #patbrndte").on("change",function(e){
			$("#<?= $lv_sec; ?> #frmevllabcre1").trigger("change");
			$("#<?= $lv_sec; ?> #frmevllabcre4").trigger("change");
		});
		
		$("#<?= $lv_sec; ?> #frmevllabcre1").on("change",function(e){
			var lv_val = getCKD( $(this).prop("value") );
			$("#<?= $lv_sec; ?> #frmevllabckd1").prop("value", parseFloat(lv_val).toFixed(2) );
		});
		$("#<?= $lv_sec; ?> #frmevllabcre4").on("change",function(e){
			var lv_val = getCKD( $(this).prop("value") );
			$("#<?= $lv_sec; ?> #frmevllabckd4").prop("value", parseFloat(lv_val).toFixed(2) );
		});
		
		$("body").scrollspy({ target: ".bs-docs-sidebar", offset: 0 });
		$("#sidebar").affix({ offset: { top: 65 } });
		$("#<?= $lv_sec; ?> #patbrndte").trigger("change");		
	</script>
	<script>
		// nuevo seguimiento
		<?php 
			$lv_mue = (isset($vew_patpln[0]['frmevlcommue'])?$vew_patpln[0]['frmevlcommue']:'');
			$lv_tra = (isset($vew_patpln[0]['frmevlcomtra'])?$vew_patpln[0]['frmevlcomtra']:'');
			$lv_hpt = (isset($vew_patpln[0]['frmevlcomhpt'])?$vew_patpln[0]['frmevlcomhpt']:'');
			if ( strtolower($lv_mue)=='hepatica' || strtolower($lv_mue)=='no_hepatica' || $lv_tra=='1' || $lv_hpt=='1' ) {
		?>
			$("#<?= $lv_sec; ?> #btnnewseg").addClass("disabled");
		<?php } else { ?>
			$("#<?= $lv_sec; ?> #btnnewseg").on("click",function(e){
				var lv_fld = ["frmevlcomdte","frmevlcommue","frmevlcommuedte","frmevlcomtra","frmevlcomtradte","frmevlcomhpt","frmevlcomhptdte","frmevlhptdtehcc","frmevlhptscr","frmevlhptecg","frmevlhptdiatom","frmevlhptdiares","frmevlhptdiabio","frmevlhptnod","frmevlhptnoddmt","frmevlhptnodsum","frmevlhptlstout","frmevlhptloc","frmevlhptlocext001","frmevlhptlocext002","frmevlhptlocext003","frmevlhptlocext004","frmevlhptlocext005","frmevlhptlocext006","frmevlhpttrachk001","frmevlhpttrachk002","frmevlhpttrachk003","frmevlhpttrachk004","frmevlhpttrachk005","frmevlhpttrachk006","frmevlhpttrachk007","frmevlhpttrachk008","frmevlhpttrachk009","frmevlhpttrachk010","frmevlhpttrachk011","frmevlcom","frmevlcomasc","frmevlcompbe","frmevlcomenc","frmevlcomsan","frmevlcomlstout","frmevlcomcex","frmevlcomcexdia","frmevlcomcexcor","frmevlcomcexcer","frmevllabbil","frmevllabalb","frmevllabrin","frmevllabqck","frmevllabhem","frmevllableu","frmevllabpla","frmevllabcre","frmevllabafp","frmevllabhcv"];
				for(var i=0; i<lv_fld.length; i++){
					$("#<?= $lv_sec; ?> [name="+lv_fld[i]+"0]").prop("value","").attr("readonly",false).prop("checked",false).removeClass("tmssAlwaysDisabled").trigger("change");
				}
				$("#<?= $lv_sec; ?> [name=frmevlcomdte0]").addClass("tmsInputRequired");
				$("#<?= $lv_sec; ?> [name=evlcod0]").prop("value","");
				e.preventDefault();
				e.stopPropagation();
			});
		<?php } ?>
		
		// modificar seguimiento
		$("#<?= $lv_sec; ?> #btnmodseg").on("click",function(e){
			var lv_fld = ["_frmevlcomdte","frmevlcommue","frmevlcommuedte","frmevlcomtra","frmevlcomtradte","frmevlcomhpt","frmevlcomhptdte","frmevlhptdtehcc","frmevlhptscr","frmevlhptecg","frmevlhptdiatom","frmevlhptdiares","frmevlhptdiabio","frmevlhptnod","frmevlhptnoddmt","frmevlhptnodsum","frmevlhptlstout","frmevlhptloc","frmevlhptlocext001","frmevlhptlocext002","frmevlhptlocext003","frmevlhptlocext004","frmevlhptlocext005","frmevlhptlocext006","frmevlhpttrachk001","frmevlhpttrachk002","frmevlhpttrachk003","frmevlhpttrachk004","frmevlhpttrachk005","frmevlhpttrachk006","frmevlhpttrachk007","frmevlhpttrachk008","frmevlhpttrachk009","frmevlhpttrachk010","frmevlhpttrachk011","frmevlcom","frmevlcomasc","frmevlcompbe","frmevlcomenc","frmevlcomsan","frmevlcomlstout","frmevlcomcex","frmevlcomcexdia","frmevlcomcexcor","frmevlcomcexcer","frmevllabbil","frmevllabalb","frmevllabrin","frmevllabqck","frmevllabhem","frmevllableu","frmevllabpla","frmevllabcre","frmevllabafp","frmevllabhcv"];
			for(var i=0; i<lv_fld.length; i++){
				$("#<?= $lv_sec; ?> [name="+lv_fld[i]+"0]").removeClass("tmssAlwaysDisabled").attr("readonly",false);
			}
			e.preventDefault();
			e.stopPropagation();
		});

		// seguimientos
		$("#<?= $lv_sec; ?> #btnseg").on("click",function(e) {
			// obtengo las fechas de seguimiento del paciente
			$.ajax({
				url: "?prg=zcuau1_hpt&act=patevl", 
				method: "POST",
				data: [{name: "patcod", value: "<?= $vew_pat->patcod; ?>"}]
			}).done(function(data){
				if (Array.isArray(data)) {
					var lv_row = "";
					for(var i=0; i<data.length; i++){
						lv_row += "<tr name='rowdte' data-evlcod='"+data[i]["evlcod"]+"'><td>"+moment(new Date(data[i]["evldte"]["date"])).format("DD/MM/YYYY")+"</td></tr>"
					}
					BootstrapDialog.show({
						title: "Seguimientos",
						message:"<p>Seleccione la fecha de seguimiento que desea visualizar.</p><table class='table table-hover table-striped table-condensed'><thead><tr><th>Fecha</th></tr><tbody>"+lv_row+"</tbody></table>",
						type: BootstrapDialog.TYPE_PRIMARY,
						onshow: function(dialog) {
							var lv_frm = $(dialog.$modalContent);
							$(lv_frm).find("tr[name=rowdte]").on("click",function(e){
								$.ajax({
									url: "?prg=zcuau1_hpt&act=patevldet",
									method: "POST",
									data: [{name: "evlcod", value: $(this).data("evlcod") }]
								}).done(function(data2){
									if (Array.isArray(data2)) {
										var lv_fld = ["frmevlcomdte","frmevlcommue","frmevlcommuedte","frmevlcomtra","frmevlcomtradte","frmevlcomhpt","frmevlcomhptdte","frmevlhptdtehcc","frmevlhptscr","frmevlhptecg","frmevlhptdiatom","frmevlhptdiares","frmevlhptdiabio","frmevlhptnod","frmevlhptnoddmt","frmevlhptnodsum","frmevlhptlstout","frmevlhptloc","frmevlhptlocext001","frmevlhptlocext002","frmevlhptlocext003","frmevlhptlocext004","frmevlhptlocext005","frmevlhptlocext006","frmevlhpttrachk001","frmevlhpttrachk002","frmevlhpttrachk003","frmevlhpttrachk004","frmevlhpttrachk005","frmevlhpttrachk006","frmevlhpttrachk007","frmevlhpttrachk008","frmevlhpttrachk009","frmevlhpttrachk010","frmevlhpttrachk011","frmevlcom","frmevlcomasc","frmevlcompbe","frmevlcomenc","frmevlcomsan","frmevlcomlstout","frmevlcomcex","frmevlcomcexdia","frmevlcomcexcor","frmevlcomcexcer","frmevllabbil","frmevllabalb","frmevllabrin","frmevllabqck","frmevllabhem","frmevllableu","frmevllabpla","frmevllabcre","frmevllabafp","frmevllabhcv"];
										var lv_val = "";
										$("#<?= $lv_sec; ?> [name=evlcod0]").prop("value",data2[0]["evlcod"]);
										for(var i=0; i<lv_fld.length; i++){
											lv_val = $("<div>"+data2[0]["evlevl"].toLowerCase()+"</div>").find(lv_fld[i]+":first").text();
											$("#<?= $lv_sec; ?> [name="+lv_fld[i]+"0]").addClass("tmssAlwaysDisabled").attr("readonly",true).prop("value",lv_val).trigger("change");
										}
										$.each(BootstrapDialog.dialogs, function(id, dialog){ dialog.close(); });
									} else if (data2.substring(0,10)=="/*script*/") { eval(data2); }
								});
								e.stopPropagation();
								e.preventDefault();
							});
						}
					});
				} else if (data.substring(0,10)=="/*script*/") { eval(data); }
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
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {				
				gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
				var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':'03'); ?>":gv_<?= $lv_sec; ?>_last_action);
				tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
			}
		}
		
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>
</section>
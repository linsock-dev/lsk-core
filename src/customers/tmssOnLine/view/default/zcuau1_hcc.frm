<?php
	// url del formulario
  $lv_lnk = '?prg=zcuau1_hcc&act=02&prm_patcod='.$vew_pat->patcod;

	// campos requeridos
	$vew_input->RequiredFields( array('adrlstnme','lndcod') );

	// clave del documento
	$lv_dockey = $vew_pat->patcod;

	// titulo
	$lv_title = $vew_lang->form;

	// m&oacute;dulo y programa
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'AU2';
	$vew_actcod = '02';

	// librer&iacute;a de estilos bootstrap
	include_once('_library.frm');

	// si no tiene ID de prestador, o no tiene especialidad asignada ==> es solo lectura
	if ( $vew_data->prscod=='' || $vew_data->spccod=='' ) { $vew_actcod='03'; $vew_readonly = true; }
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<link href="library/css/temasis.bs-docs-sidebar.css" rel="stylesheet">
	<style>#sidebar.affix {top: 121px;}</style>
	<?php include('grldocfrmtlb.frm'); ?>
	<!--
  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '00'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success" title="<?= $vew_lang->save;  ?>"><i class="fas fa-save"></i><span class="hidden-xs">  <?= $vew_lang->save; ?></span></a>
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-danger" title="<?= $vew_lang->cancel; ?>"><i class="fas fa-times"></i><span class="hidden-xs">  <?= $vew_lang->cancel; ?></span></a>
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				< !--Dropdown-- >
				<div class="btn-group dropdown">
					<a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><span class="fas fa-ellipsis-v"></span></a>
					<form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
						< !--Actualizar-- >
						<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '99'});" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
						< !--Imprimir-- >
            <li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: 'prn'});" class="tmssLink"><i style="width:20px;" class="fas fa-print"></i><?= $vew_lang->print; ?></a></li>
          </form>
				</div>        
        < !-- Cerrar -- >
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
	</nav>
	-->

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('pattxt','hidden',$vew_pat->pattxt); ?>
    <?= gethtml('adrnum','hidden',$vew_pat->adr->adrnum); ?>
    <?= gethtml('bnknum','hidden',$vew_pat->bnk->bnknum); ?>
    <?= gethtml('taxnum','hidden',$vew_pat->tax->taxnum); ?>
    <?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
    <?= gethtml('spccod','hidden',$vew_data->spccod); ?>
		<?= gethtml('cuscod','hidden',$vew_data->cuscod); ?>
    <?= gethtml('prscod','hidden',$vew_data->prscod); ?>
    <?= gethtml('evldte','hidden',($vew_patevl->evldte!=''?$vew_patevl->evldte->format('d/m/Y'):'')); ?>
    <?= gethtml('docsts','hidden','A'); ?>
		<?= gethtml('evlcod','hidden',$vew_data->evlcod); ?>
    <?= gethtml('evlsysdocclscod','hidden',$vew_data->evlsysdocclscod); ?>
		<?= gethtml('evlspccod','hidden',$vew_data->evlspccod); ?>

		<div class="container bs-docs-container">
			<div class="row">
				<div class="col-md-9">
					<div class="bs-docs-section">



						<h1 id="paciente"><i class="fas fa-caret-right"></i> Paciente</h1><br><!-- pat -->



						<h2 id="paciente-01"><span class="fas fa-angle-right"></span> Datos demogr&aacute;ficos</h2><br><br><!-- dem -->



						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">ID Paciente</label>
										<div class="col-sm-4"><?= gethtml('patcod','patcod',$vew_pat->patcod,$lv_always_disabled); ?></div>
										<label class="col-sm-2 control-label"><?= 'Iniciales'; ?></label>
										<div class="col-sm-4">
											<?= gethtml('adrlstnme','adrlstnme',$vew_pat->adr->adrlstnme,$lv_default); ?>
											<?= gethtml('adrfrtnme','hidden',$vew_pat->adr->adrfrtnme); ?>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Edad</label>
										<div class="col-sm-4"><?= gethtml('patage','docnum0300',$vew_patevlspc->patage,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Sexo</label>
										<div class="col-sm-4"><?= gethtml('patsex','adrsex',$vew_pat->patsex,$lv_default); ?></div>
										<label class="col-sm-1 control-label"><?= $vew_lang->weight; ?> <small>(kg)</small></label>
										<div class="col-sm-2"><?= gethtml('patwgt','qty',$vew_patevlspc->patwgt,$lv_default); ?></div>
										<label class="col-sm-1 control-label">Talla <small>(cm)</small></label>
										<div class="col-sm-2"><?= gethtml('pathgh','qty',$vew_patevlspc->pathgh,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Ciudad de Origen</label>
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
										<label class="col-sm-2 control-label">Situaci&oacute;n del Paciente</label>
										<div class="col-sm-3"><?= gethtml('frmpatdemviv',array(''=>'','vivo'=>'VIVO','fallecido'=>'FALLECIDO'), $vew_patevlspc->frmpatdemviv); ?></div>
										<div class="col-sm-7 hidden" id="frmpatdemvivdiv">
											<table class="table table-condensed table-bordered">
												<tbody>
													<tr><td>Fecha fallecimiento</td><td><?= gethtml('frmpatdemvivdte','docdte',$vew_patevlspc->frmpatdemvivdte, $lv_default); ?></td></tr>
													<tr><td>Causa de muerte</td><td><?= gethtml('frmpatdemvivmtv',array(''=>'','complicacion'=>'COMPLICACION DE LA CIRROSIS: PBE, SANGRADO VARICEAL, ETC','hepatocarcinoma'=>'HEPATOCARCINOMA','sepsis'=>'SEPSIS','cardiovascular'=>'EVENTO CARDIOVASCULAR','otro'=>'OTRO','desconocido'=>'DESCONOCIDO'), $vew_patevlspc->frmpatdemvivmtv); ?></td></tr>
												</tbody>
											</table>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Fec Ultimo Follow Up</label>
										<div class="col-sm-4"><?= gethtml('frmpatdemlstflwdte','docdte',$vew_patevlspc->frmpatdemlstflwdte, $lv_default); ?></div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>



						<h1 id="patologia"><span class="fas fa-caret-right"></span> Patolog&iacute;a</h1><br><!-- pto -->



						<h2 id="patologia-01"><span class="fas fa-angle-right"></span> Datos al Diagn&oacute;stico de Hepatocarcinoma</h2><br><br>



						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Fecha Diagn&oacute;stico HCC</label>
										<div class="col-sm-6"><?= gethtml('frmptohccdte','docdte',$vew_patevlspc->frmptohccdte,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Performance Status ECOG Al diagnostico</label>
										<div class="col-sm-6"><?= gethtml('frmptohccecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmptohccecg); ?><br>
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
										<label class="col-sm-3 control-label">Enfermedad Hep&aacute;tica al diagn&oacute;stico del HCC<br><small>Hallazgo histol&oacute;gico o valoraci&oacute;n de fibrosis por m&eacute;todos no invasivos</small></label>
										<div class="col-sm-6"><?= gethtml('frmptohccenf', array(''=>'','grado1'=>'Fibrosis leve (grado I)','grado2'=>'Fibrosis grado II o portal','grado3'=>'Fibrosis grado III','grado4'=>'Fibrosis IV o cirrosis','ausencia'=>'Ausencia de fibrosis'), $vew_patevlspc->frmptohccenf); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">M&eacute;todo de Valoraci&oacute;n Fibrosis</label>
										<div class="col-sm-6"><?= gethtml('frmptohccmthval', array(''=>'','biopsia'=>'Biopsia Hep&aacute;tica','elastograf&iacute;a'=>'Elastograf&iacute;a por Fibroscan','apri'=>'Score fibrosis no invasivo: APRI u otros','datos'=>'Datos cl&iacute;nicos (ej: v&aacute;rices, ascitis, etc)'), $vew_patevlspc->frmptohccmthval); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Laboratorio</label>
										<div class="col-sm-9">
											<table class="table table-condensed table-bordered">
												<tbody>
													<tr>
														<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
														<td><?= gethtml('frmptohcclabbil','docnum0601',$vew_patevlspc->frmptohcclabbil,$lv_default); ?></td>
														<td>RIN</td>
														<td><?= gethtml('frmptohcclabrin','docnum0601',$vew_patevlspc->frmptohcclabrin,$lv_default); ?></td>
													</tr>
													<tr>
														<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
														<td><?= gethtml('frmptohcclabalb','docnum0601',$vew_patevlspc->frmptohcclabalb,$lv_default); ?></td>
														<td>Encefalopatia Portosistemica</td>
														<td><?= gethtml('frmptohcclabepr',array(''=>'','no'=>'NO','I-II'=>'I-II','III-IV'=>'III-IV'),$vew_patevlspc->frmptohcclabepr,$lv_default); ?></td>
													</tr>
													<tr>
														<td>ASCITIS</td>
														<td><?= gethtml('frmptohcclabasc',array(''=>'','no'=>'NO','leve'=>'LEVE','moderada'=>'MODERADA'),$vew_patevlspc->frmptohcclabasc,$lv_default); ?></td>
														<td>Recuento de Plaquetas<br><small>(en mm3)</small></td>
														<td><input type="NUMBER" id="frmptohcclabrec" name="frmptohcclabrec" value="<?= $vew_patevlspc->frmptohcclabrec; ?>" maxlength="7" min="10000" max="1000000" step="1" class="form-control"></td>
													</tr>
													<tr>
														<td>AFP al diagnostico<br><small>Alfa-fetoproteina (AFP) en ng/ml</small></td>
														<td><?= gethtml('frmptohcclabafp','docnum0601',$vew_patevlspc->frmptohcclabafp,$lv_default); ?></td>
														<td></td>
														<td></td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Endoscop&iacute;a Digestiva alta al diagn&oacute;stico</label>
										<div class="col-sm-6"><?= gethtml('frmptohccenddig',array(''=>'','no'=>'No realizada','norm'=>'Normal','varpeq'=>'V&aacute;rices esof&aacute;gicas peque&ntilde;as','vargde'=>'V&aacute;rices esof&aacute;gicas grandes','vargas'=>'V&aacute;rices g&aacute;stricas','gaship'=>'Gastropat&iacute;a hipertensi&oacute;n portal'), $vew_patevlspc->frmptohccenddig, $lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Comorbilidades</label>
										<div class="col-sm-6"><?= gethtml('frmptohcccom',array(''=>'','epcsev'=>'EPOC severo','otrneo'=>'Otra neoplasia activa','enfcor'=>'Enfermedad coronaria activa','diamel'=>'Diabetes Mellitus','acccer'=>'Accidente Cerebro Vascular','enfvas'=>'Enfermedad Vascular perif&eacute;rica','otrcom'=>'Otra co-morbilidad mayor','insren'=>'Insuficiencia renal (Creatinina >1.5 mg/dl o clearence de creatinina <30 ml/min)'), $vew_patevlspc->frmptohcccom, $lv_default); ?></div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>



						<h2 id="patologia-02"><span class="fas fa-angle-right"></span> Etiolog&iacute;a</h2><br><br>



						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Etiologia de la Cirrosis</label>
										<div class="col-sm-6"><?= gethtml('frmptohcceticrr',array(''=>'','hepatitis_c'=>'Hepatitis C','alcohol'=>'Alcohol','nash'=>'NASH','hepatitis_b'=>'Hepatitis B','cirrosis_prim'=>'Cirrosis Biliar Primaria','colangitis'=>'Colangitis Esclerosante Primaria','currosis_sec'=>'Cirrosis Biliar Secundaria','toxica'=>'Toxica','hepatitis_auto'=>'Hepatitis Autoinmune','hierro'=>'Trastornos del metabolismo del Hierro','cirrosis_cripto'=>'Cirrosis Criptog&eacute;nica','otro'=>'Otro'),$vew_patevlspc->frmptohcceticrr, $lv_default); ?></div>
									</div>

									<div class="form-group tmss-form-group" id="frmptohcceticrrhcvdiv">
										<label class="col-sm-3 control-label">Genotipo de HCV<br><small>En caso de HCV + Especificar Genotipo subtipo</small></label>
										<div class="col-sm-6"><?= gethtml('frmptohccgenhcv',array(''=>'','1a'=>'1a','1b'=>'1b','2'=>'2','3'=>'3','4'=>'4','no_disponible'=>'No Disponible','Otro'=>'Otro'),$vew_patevlspc->frmptohccgenhcv,$lv_default); ?></div>
									</div>

									<div id="frmptohcceticrrhbvdiv">
										<div class="form-group tmss-form-group">
											<label class="col-sm-3 control-label">Hepatitis B al momento del diagn&oacute;stico</label>
											<div class="col-sm-6"><?= gethtml('frmptohcchptbbb',array(''=>'','ags_core+'=>'AgS negativo, Core +','ags_pos'=>'AgS positivo, AgE positivo','ags_neg'=>'AgS positivo, AgE negativo','negativo'=>'Negativo'),$vew_patevlspc->frmptohcchptbbb,$lv_default); ?></div>
										</div>
										<div class="form-group tmss-form-group">
											<label class="col-sm-3 control-label">Hepatitis B Tratamiento</label>
											<div class="col-sm-6"><?= gethtml('frmptohcchptbbbtra','yesno',$vew_patevlspc->frmptohcchptbbbtra,$lv_default); ?></div>
										</div>
										<div class="form-group tmss-form-group">
											<label class="col-sm-3 control-label">Carga viral HBV</label>
											<div class="col-sm-6"><?= gethtml('frmptohcchptbbbcar',array(''=>'','carga_neg'=>'Carga viral negativa', 'carga_menor_2000'=>'Carga viral <2000 UI/ml','carga_mayor_2000'=>'Carga viral >2000 UI/ml','carga_mayor_20000'=>'Carga viral >20000 UI/ml'),$vew_patevlspc->frmptohcchptbbbcar,$lv_default); ?></div>
										</div>
									</div>

									<div class="form-group tmss-form-group" id="frmptohcceticrrotrdiv">
										<label class="col-sm-3 control-label">Indique</label>
										<div class="col-sm-6"><?= gethtml('frmptohcceticrrotr','doccmt1x20',$vew_patevlspc->frmptohcceticrrotr,$lv_default); ?></div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>



						<h2 id="patologia-03"><span class="fas fa-angle-right"></span> Screening y Diagn&oacute;stico HCC</h2><br><br>



						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Estaba Bajo Screening con Ecograf&iacute;a?</label>
										<div class="col-sm-6"><?= gethtml('frmptohccscreco001','yesno',$vew_patevlspc->frmptohccscreco001,$lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmptohccscrecodiv">
										<div class="col-sm-3">&nbsp;</div>
										<div class="col-sm-9">
											<table class="table table-condensed table-bordered">
												<tbody>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">&uacute;ltima Ecograf&iacute;a de Screening</label>
														<!--<div class="col-sm-8"><?php (1==1?'':gethtml('frmptohccscrecoult',array(''=>'','fuera_centro'=>'REALIZADA FUERA DE SU CENTRO ASISTENCIAL','en_centro'=>'REALIZADA EN SU CENTRO ASISTENCIAL'), $vew_patevlspc->frmptohccscrecoult,$lv_default)); ?></div>-->
														<div class="col-sm-8"><?= gethtml('frmptohccscrecoult',array(''=>'','en_centro_experto'=>'EN SU CENTRO POR EXPERTO','en_centro_no_experto'=>'EN SU CENTRO POR NO EXPERTO','fuera_centro'=>'EN OTRO CENTRO DE ATENCION'), $vew_patevlspc->frmptohccscrecoult,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">N&uacute;mero de Nodulos en Ecografia</label>
														<div class="col-sm-8"><?= gethtml('frmptohccscreconro',array(''=>'','0'=>'0','1'=>'1','2'=>'2','3'=>'3','4'=>'4','5'=>'5','6'=>'6','7'=>'7','8'=>'8','9'=>'9','10'=>'10'),$vew_patevlspc->frmptohccscreconro,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Tama&ntilde;o de Nodulo MAYOR en ecograf&iacute;a<br><small>Indicar en mm</small></label>
														<div class="col-sm-8"><?= gethtml('frmptohccscrecotam','docnum0600',$vew_patevlspc->frmptohccscrecotam,$lv_default); ?></div>
													</div>
												</td></tr>
												</tbody>
											</table>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Se realiz&oacute; el Diagn&oacute;stico de HCC en este paciente mediante</label>
										<div class="col-sm-6">
											<label><input type="checkbox" id="frmptohccdiamth" name="frmptohccdiamth001" <?= ($vew_patevlspc->frmptohccdiamth001!=''?'checked':''); ?>> TAC din&aacute;mica</label><br>
											<label><input type="checkbox" id="frmptohccdiamth" name="frmptohccdiamth002" <?= ($vew_patevlspc->frmptohccdiamth002!=''?'checked':''); ?>> RMN din&aacute;mica</label><br>
											<label><input type="checkbox" id="frmptohccdiamth" name="frmptohccdiamth003" <?= ($vew_patevlspc->frmptohccdiamth003!=''?'checked':''); ?>> Biopsia</label><br>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica</label>
										<div class="col-sm-6"><?= gethtml('frmptohcctacnum','docnum0600',$vew_patevlspc->frmptohcctacnum,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN<br><small>Indicar en mm</small></label>
										<div class="col-sm-6"><?= gethtml('frmptohcctactam','docnum0600',$vew_patevlspc->frmptohcctactam,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN<br><small>Indicar en mm</small></label>
										<div class="col-sm-6"><?= gethtml('frmptohcctacsum','docnum0600',$vew_patevlspc->frmptohcctacsum,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes</small></label>
										<div class="col-sm-6"><?= gethtml('frmptohccinvtummac',array(''=>'','no'=>'NO','tronco'=>'Tronco de la Vena Porta','rama_der'=>'Rama derecha Porta','rama_izq'=>'Rama izquierda Porta','cava_inf'=>' Vena Cava inferior','suprahep'=>'Venas suprahep&aacute;ticas','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmptohccinvtummac,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Enfermedad Extrahep&aacute;tica HCC</label>
										<div class="col-sm-6"><?= gethtml('frmptohccenfext',array(''=>'','no'=>'NO','osea'=>'OSEA','pulmon'=>'PULMON','otra'=>'OTRA','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmptohccenfext,$lv_default); ?></div>
									</div>
									<div id="frmptohccenfextdiv">
										<div class="form-group tmss-form-group">
											<label class="col-sm-3 control-label">Cual otra localizaci&oacute;n metast&aacute;sica?</label>
											<div class="col-sm-6"><?= gethtml('frmptohccotrlocmet','doccmt1x20',$vew_patevlspc->frmptohccotrlocmet,$lv_default); ?></div>
										</div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>



						<h2 id="patologia-04"><span class="fas fa-angle-right"></span> Estad&iacute;o BCLC</h2><br><br><!-- tra -->



						<table class="table table-striped table-condensed">
							<tr><td>
								<div class="form-group tmss-form-group">
									<label class="col-sm-4 control-label">Estad&iacute;o BCLC al diagn&oacute;stico<br><small>acorde a juicio cl&iacute;nico subjetivo</small></label>
									<div class="col-sm-8"><?= gethtml('frmptobcl',array(''=>'','0'=>'0','a'=>'A','b'=>'B','c'=>'C','d'=>'D'),$vew_patevlspc->frmptobcl,$lv_default); ?></div>
								</div>
							</td></tr>
						</table>
						<br><br>



						<h1 id="tratamiento"><span class="fas fa-caret-right"></span> Tratamientos del HCC</h1><br>



						<h2 id="tratamiento-01"><span class="fas fa-angle-right"></span> Tratamientos Realizados en este paciente</h2><br><br><!-- tra -->



						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Ablaci&oacute;n Percut&aacute;nea</label>
										<div class="col-sm-6"><?= gethtml('frmtraabl',array(''=>'','no'=>'NO','ablacion_radiofrecuencia'=>'Ablaci&oacute;n por Radiofrecuencia','ablacion_alcohol'=>'Ablaci&oacute;n por Alcoholizaci&oacute;n'),$vew_patevlspc->frmtraabl,$lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtraabldiv">
										<div class="col-sm-3"></div>
										<div class="col-sm-9">
											<table class="table table-striped table-condensed table-bordered">
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Estad&iacute;o BCLC previo al tratamiento<br><small>acorde a juicio cl&iacute;nico subjetivo</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraablbcl',array(''=>'','0'=>'0','a'=>'A','b'=>'B','c'=>'C','d'=>'D'),$vew_patevlspc->frmtraablbcl,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica</label>
														<div class="col-sm-6"><?= gethtml('frmtraablnumnod','docnum0600',$vew_patevlspc->frmtraablnumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">HCC difuso</label>
														<div class="col-sm-6"><?= gethtml('frmtraablhccdif','yesno',$vew_patevlspc->frmtraablhccdif,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraabltamnod','docnum0600',$vew_patevlspc->frmtraabltamnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraablsumnod','docnum0600',$vew_patevlspc->frmtraablsumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraablinvtum',array(''=>'','no'=>'NO','tronco'=>'Tronco de la Vena Porta','rama_der'=>'Rama derecha Porta','rama_izq'=>'Rama izquierda Porta','cava_inf'=>' Vena Cava inferior','suprahep'=>'Venas suprahep&aacute;ticas','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtraablinvtum,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Enfermedad Extrahep&aacute;tica HCC</label>
														<div class="col-sm-6"><?= gethtml('frmtraablenfext',array(''=>'','no'=>'NO','osea'=>'OSEA','pulmon'=>'PULMON','otra'=>'OTRA','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtraablenfext,$lv_default); ?></div>
													</div>
													<div id="frmtraablenfextdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-3 control-label">Cual otra localizaci&oacute;n metast&aacute;sica?</label>
															<div class="col-sm-6"><?= gethtml('frmtraablenfextotr','doccmt1x20',$vew_patevlspc->frmtraablenfextotr,$lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Performance Status ECOG</label>
														<div class="col-sm-6"><?= gethtml('frmtraablecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmtraablecg); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Laboratorio</label>
														<div class="col-sm-9">
															<table class="table table-condensed table-bordered">
																<tbody>
																	<tr>
																		<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtraabllabbil','docnum0601',$vew_patevlspc->frmtraabllabbil,$lv_default); ?></td>
																		<td>RIN</td>
																		<td><?= gethtml('frmtraabllabrin','docnum0601',$vew_patevlspc->frmtraabllabrin,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtraabllabalb','docnum0601',$vew_patevlspc->frmtraabllabalb,$lv_default); ?></td>
																		<td>Encefalopatia Portosistemica</td>
																		<td><?= gethtml('frmtraabllabenc',array(''=>'','no'=>'NO','I-II'=>'I-II','III-IV'=>'III-IV'),$vew_patevlspc->frmtraabllabenc,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>ASCITIS</td>
																		<td><?= gethtml('frmtraabllabasc',array(''=>'','no'=>'NO','leve'=>'LEVE','moderada'=>'MODERADA'),$vew_patevlspc->frmtraabllabasc,$lv_default); ?></td>
																		<td>Recuento de Plaquetas<br><small>(en mm3)</small></td>
																		<td><input type="NUMBER" id="frmtraabllabrec" name="frmtraabllabrec" value="<?= $vew_patevlspc->frmtraabllabrec; ?>" maxlength="7" min="10000" max="1000000" step="1" class="form-control"></td>
																	</tr>
																	<tr>
																		<td>AFP al diagnostico<br><small>Alfa-fetoproteina (AFP) en ng/ml</small></td>
																		<td><?= gethtml('frmtraabllabafp','docnum0601',$vew_patevlspc->frmtraabllabafp,$lv_default); ?></td>
																		<td></td>
																		<td></td>
																	</tr>
																</tbody>
															</table>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">N&uacute;mero de Ablaciones percut&aacute;neas en este paciente</label>
														<div class="col-sm-8"><?= gethtml('frmtraablnum','docnum0300',$vew_patevlspc->frmtraablnum,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">1er Sesi&oacute;n</label>
														<div class="col-sm-9">
															<div class="form-group tmss-form-group">
																<label class="col-sm-4 control-label">Fecha</label>
																<div class="col-sm-8"><?= gethtml('pattraablses001dte','docdte',$vew_patevlspc->pattraablses001dte, $lv_default); ?></div>
															</div>
															<div class="form-group tmss-form-group">
																<label class="col-sm-4 control-label">Evaluaci&oacute;n Radiol&oacute;gica o Respuesta Post Ablaci&oacute;n<br><small>Evaluada por Im&aacute;genes, RECIST 1.1</small></label>
																<div class="col-sm-8"><?= gethtml('pattraablses001evl',array(''=>'','completa'=>'Respuesta Completa','parcial'=>'Respuesta Parcial','estable'=>'Enfermedad estable o sin cambios','progresion'=>'Progresi&oacute;n','no_valorado'=>'No valorado'),$vew_patevlspc->pattraablses001evl,$lv_default); ?><br>
																	<small>
																	<ul>
																		<li><strong>Respuesta Completa:</strong> Desaparici&oacute;n completa del refuerzo arterial t&iacute;pico de todas las lesiones dianas HCC.</li><br>
																		<li><strong>Respuesta Parcial:</strong> Disminuci&oacute;n de al menos 30% en la suma de di&aacute;metros respecto a valores iniciales.</li><br>
																		<li><strong>Enfermedad Estable o Sin Cambios:</strong> Ni reducci&oacute;n de di&aacute;metro que clasifique RP ni suficiente aumento para clasificar progresi&oacute;n.</li><br>
																		<li><strong>Progresi&oacute;n:</strong> Aumento de al menos 20% en la suma de los di&aacute;metros respecto a valores iniciales y con al menos un aumento de 5mm en la suma.</li><br>
																		<li><strong>No valorado:</strong> No valorado.</li><br>
																	</ul>
																	</small>
																</div>
															</div>
															<div class="form-group tmss-form-group">
																<label class="col-sm-4 control-label">Fecha de Evaluaci&oacute;n Radiol&oacute;gica</label>
																<div class="col-sm-8"><?= gethtml('pattraablses001evldte','docdte',$vew_patevlspc->pattraablses001evldte, $lv_default); ?></div>
															</div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">2da Sesi&oacute;n</label>
														<div class="col-sm-9">
															<div class="form-group tmss-form-group">
																<label class="col-sm-4 control-label">Fecha</label>
																<div class="col-sm-8"><?= gethtml('pattraablses002dte','docdte',$vew_patevlspc->pattraablses002dte, $lv_default); ?></div>
															</div>
															<div class="form-group tmss-form-group">
																<label class="col-sm-4 control-label">Evaluaci&oacute;n Radiol&oacute;gica o Respuesta Post Ablaci&oacute;n<br><small>Evaluada por Im&aacute;genes, RECIST 1.1</small></label>
																<div class="col-sm-8"><?= gethtml('pattraablses002evl',array(''=>'','completa'=>'Respuesta Completa','parcial'=>'Respuesta Parcial','estable'=>'Enfermedad estable o sin cambios','progresion'=>'Progresi&oacute;n','no_valorado'=>'No valorado'),$vew_patevlspc->pattraablses002evl,$lv_default); ?><br>
																	<small>
																	<ul>
																		<li><strong>Respuesta Completa:</strong> Desaparici&oacute;n completa del refuerzo arterial t&iacute;pico de todas las lesiones dianas HCC.</li><br>
																		<li><strong>Respuesta Parcial:</strong> Disminuci&oacute;n de al menos 30% en la suma de di&aacute;metros respecto a valores iniciales.</li><br>
																		<li><strong>Enfermedad Estable o Sin Cambios:</strong> Ni reducci&oacute;n de di&aacute;metro que clasifique RP ni suficiente aumento para clasificar progresi&oacute;n.</li><br>
																		<li><strong>Progresi&oacute;n:</strong> Aumento de al menos 20% en la suma de los di&aacute;metros respecto a valores iniciales y con al menos un aumento de 5mm en la suma.</li><br>
																		<li><strong>No valorado:</strong> No valorado.</li><br>
																	</ul>
																	</small>
																</div>
															</div>
															<div class="form-group tmss-form-group">
																<label class="col-sm-4 control-label">Fecha de Evaluaci&oacute;n Radiol&oacute;gica</label>
																<div class="col-sm-8"><?= gethtml('pattraablses002evldte','docdte',$vew_patevlspc->pattraablses002evldte, $lv_default); ?></div>
															</div>
														</div>
													</div>
												</td></tr>
											</table>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Resecci&oacute;n Quir&uacute;rgica</label>
										<div class="col-sm-6"><?= gethtml('frmtraresqui001','yesno',$vew_patevlspc->frmtraresqui001,$lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtraresquidiv">
										<div class="col-sm-3"></div>
										<div class="col-sm-9">
											<table class="table table-striped table-condensed table-bordered">
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Estad&iacute;o BCLC previo al tratamiento<br><small>acorde a juicio cl&iacute;nico subjetivo</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraresquibcl',array(''=>'','0'=>'0','a'=>'A','b'=>'B','c'=>'C','d'=>'D'),$vew_patevlspc->frmtraresquibcl,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica</label>
														<div class="col-sm-6"><?= gethtml('frmtraresquinumnod','docnum0600',$vew_patevlspc->frmtraresquinumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">HCC difuso</label>
														<div class="col-sm-6"><?= gethtml('frmtraresquihccdif','yesno',$vew_patevlspc->frmtraresquihccdif,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraresquitamnod','docnum0600',$vew_patevlspc->frmtraresquitamnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraresquisumnod','docnum0600',$vew_patevlspc->frmtraresquisumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraresquiinvtum',array(''=>'','no'=>'NO','tronco'=>'Tronco de la Vena Porta','rama_der'=>'Rama derecha Porta','rama_izq'=>'Rama izquierda Porta','cava_inf'=>' Vena Cava inferior','suprahep'=>'Venas suprahep&aacute;ticas','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtraresquiinvtum,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Enfermedad Extrahep&aacute;tica HCC</label>
														<div class="col-sm-6"><?= gethtml('frmtraresquienfext',array(''=>'','no'=>'NO','osea'=>'OSEA','pulmon'=>'PULMON','otra'=>'OTRA','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtraresquienfext,$lv_default); ?></div>
													</div>
													<div id="frmtraresquienfextdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-3 control-label">Cual otra localizaci&oacute;n metast&aacute;sica?</label>
															<div class="col-sm-6"><?= gethtml('frmtraresquienfextotr','doccmt1x20',$vew_patevlspc->frmtraresquienfextotr,$lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Performance Status ECOG</label>
														<div class="col-sm-6"><?= gethtml('frmtraresquiecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmtraresquiecg); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Laboratorio</label>
														<div class="col-sm-9">
															<table class="table table-condensed table-bordered">
																<tbody>
																	<tr>
																		<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtraresquilabbil','docnum0601',$vew_patevlspc->frmtraresquilabbil,$lv_default); ?></td>
																		<td>RIN</td>
																		<td><?= gethtml('frmtraresquilabrin','docnum0601',$vew_patevlspc->frmtraresquilabrin,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtraresquilabalb','docnum0601',$vew_patevlspc->frmtraresquilabalb,$lv_default); ?></td>
																		<td>Encefalopatia Portosistemica</td>
																		<td><?= gethtml('frmtraresquilabenc',array(''=>'','no'=>'NO','I-II'=>'I-II','III-IV'=>'III-IV'),$vew_patevlspc->frmtraresquilabenc,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>ASCITIS</td>
																		<td><?= gethtml('frmtraresquilabasc',array(''=>'','no'=>'NO','leve'=>'LEVE','moderada'=>'MODERADA'),$vew_patevlspc->frmtraresquilabasc,$lv_default); ?></td>
																		<td>Recuento de Plaquetas<br><small>(en mm3)</small></td>
																		<td><input type="NUMBER" id="frmtraresquilabrec" name="frmtraresquilabrec" value="<?= $vew_patevlspc->frmtraresquilabrec; ?>" maxlength="7" min="10000" max="1000000" step="1" class="form-control"></td>
																	</tr>
																	<tr>
																		<td>AFP al diagnostico<br><small>Alfa-fetoproteina (AFP) en ng/ml</small></td>
																		<td><?= gethtml('frmtraresquilabafp','docnum0601',$vew_patevlspc->frmtraresquilabafp,$lv_default); ?></td>
																		<td></td>
																		<td></td>
																	</tr>
																</tbody>
															</table>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">N&uacute;mero de resecciones quir&uacute;rgicas realizadas en este paciente.</label>
														<div class="col-sm-8"><?= gethtml('frmtraresquinum','docnum0300',$vew_patevlspc->frmtraresquinum,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Tipo de Resecci&oacute;n Quir&uacute;rgica</label>
														<div class="col-sm-8"><?= gethtml('frmtraresquityp',array(''=>'','Hepatectomia'=>'Hepatectom&iacute;a','Segmentectomia'=>'Segmentectom&iacute;a','Nodulectomia'=>'Nodulectom&iacute;a','otro'=>'Otro','no_disponible'=>'Dato no disponible'), $vew_patevlspc->frmtraresquityp,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha de Cirug&iacute;a</label>
														<div class="col-sm-8"><?= gethtml('frmtraresquidte','docdte',$vew_patevlspc->frmtraresquidte, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Evaluaci&oacute;n Radiol&oacute;gica o Respuesta Post Resecci&oacute;n<br><small>Evaluada por Im&aacute;genes, RECIST 1.1</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraresquievl',array(''=>'','completa'=>'Respuesta Completa','parcial'=>'Respuesta Parcial','estable'=>'Enfermedad estable o sin cambios','progresion'=>'Progresi&oacute;n','no_valorado'=>'No valorado'),$vew_patevlspc->frmtraresquievl,$lv_default); ?><br>
															<small>
															<ul>
																<li><strong>Respuesta Completa:</strong> Desaparici&oacute;n completa del refuerzo arterial t&iacute;pico de todas las lesiones dianas HCC.</li><br>
																<li><strong>Respuesta Parcial:</strong> Disminuci&oacute;n de al menos 30% en la suma de di&aacute;metros respecto a valores iniciales.</li><br>
																<li><strong>Enfermedad Estable o Sin Cambios:</strong> Ni reducci&oacute;n de di&aacute;metro que clasifique RP ni suficiente aumento para clasificar progresi&oacute;n.</li><br>
																<li><strong>Progresi&oacute;n:</strong> Aumento de al menos 20% en la suma de los di&aacute;metros respecto a valores iniciales y con al menos un aumento de 5mm en la suma.</li><br>
																<li><strong>No valorado:</strong> No valorado.</li><br>
															</ul>
															</small>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha de Evaluaci&oacute;n Radiol&oacute;gica</label>
														<div class="col-sm-8"><?= gethtml('frmtraresquievldte','docdte',$vew_patevlspc->frmtraresquievldte, $lv_default); ?></div>
													</div>
												</td></tr>
											</table>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Evaluaci&oacute;n y/o Trasplante Hep&aacute;tico</label>
										<div class="col-sm-6"><?= gethtml('frmtratsphep','yesno',$vew_patevlspc->frmtratsphep,$lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtratsphepdiv">
										<div class="col-sm-3"></div>
										<div class="col-sm-9">
											<table class="table table-condensed table-bordered">
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Evaluaci&oacute;n Trasplante Hep&aacute;tico</label>
														<div class="col-sm-8"><?= gethtml('frmtratsphepevl','yesno',$vew_patevlspc->frmtratsphepevl,$lv_default); ?></div>
													</div>
													<div id="frmtratsphepevldiv">
														<label class="col-sm-4 control-label">Fecha</label>
														<div class="col-sm-8"><?= gethtml('frmtratsphepevldte','docdte',$vew_patevlspc->frmtratsphepevldte,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Trasplante Hep&aacute;tico</label>
														<div class="col-sm-8"><?= gethtml('frmtratspheptyp',array(''=>'','no'=>'NO','derivacion'=>'Derivaci&oacute;n a centro de Trasplante Hep&aacute;tico','si'=>'SI'),$vew_patevlspc->frmtratspheptyp,$lv_default); ?></div>
													</div>
													<table class="table table-striped table-condensed" id="frmtratspheptypdiv">
														<tr><td>
															<div class="form-group tmss-form-group">
																<label class="col-sm-4 control-label">Estad&iacute;o BCLC previo al tratamiento<br><small>acorde a juicio cl&iacute;nico subjetivo</small></label>
																<div class="col-sm-8"><?= gethtml('frmtratsphepbcl',array(''=>'','0'=>'0','a'=>'A','b'=>'B','c'=>'C','d'=>'D'),$vew_patevlspc->frmtratsphepbcl,$lv_default); ?></div>
															</div>
														</td></tr>
														<tr><td>
															<div class="form-group tmss-form-group">
																<label class="col-sm-3 control-label">N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica</label>
																<div class="col-sm-6"><?= gethtml('frmtratsphepnumnod','docnum0600',$vew_patevlspc->frmtratsphepnumnod,$lv_default); ?></div>
															</div>
														</td></tr>
														<tr><td>
															<div class="form-group tmss-form-group">
																<label class="col-sm-3 control-label">HCC difuso</label>
																<div class="col-sm-6"><?= gethtml('frmtratsphephccdif','yesno',$vew_patevlspc->frmtratsphephccdif,$lv_default); ?></div>
															</div>
														</td></tr>
														<tr><td>
															<div class="form-group tmss-form-group">
																<label class="col-sm-3 control-label">Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN<br><small>Indicar en mm</small></label>
																<div class="col-sm-6"><?= gethtml('frmtratspheptamnod','docnum0600',$vew_patevlspc->frmtraresquitamnod,$lv_default); ?></div>
															</div>
														</td></tr>
														<tr><td>
															<div class="form-group tmss-form-group">
																<label class="col-sm-3 control-label">Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN<br><small>Indicar en mm</small></label>
																<div class="col-sm-6"><?= gethtml('frmtratsphepsumnod','docnum0600',$vew_patevlspc->frmtratsphepsumnod,$lv_default); ?></div>
															</div>
														</td></tr>
														<tr><td>
															<div class="form-group tmss-form-group">
																<label class="col-sm-3 control-label">Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes</small></label>
																<div class="col-sm-6"><?= gethtml('frmtratsphepinvtum',array(''=>'','no'=>'NO','tronco'=>'Tronco de la Vena Porta','rama_der'=>'Rama derecha Porta','rama_izq'=>'Rama izquierda Porta','cava_inf'=>' Vena Cava inferior','suprahep'=>'Venas suprahep&aacute;ticas','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtratsphepinvtum,$lv_default); ?></div>
															</div>
														</td></tr>
														<tr><td>
															<div class="form-group tmss-form-group">
																<label class="col-sm-3 control-label">Enfermedad Extrahep&aacute;tica HCC</label>
																<div class="col-sm-6"><?= gethtml('frmtratsphepenfext',array(''=>'','no'=>'NO','osea'=>'OSEA','pulmon'=>'PULMON','otra'=>'OTRA','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtratsphepenfext,$lv_default); ?></div>
															</div>
															<div id="frmtratsphepenfextdiv">
																<div class="form-group tmss-form-group">
																	<label class="col-sm-3 control-label">Cual otra localizaci&oacute;n metast&aacute;sica?</label>
																	<div class="col-sm-6"><?= gethtml('frmtratsphepenfextotr','doccmt1x20',$vew_patevlspc->frmtratsphepenfextotr,$lv_default); ?></div>
																</div>
															</div>
														</td></tr>
														<tr><td>
															<div class="form-group tmss-form-group">
																<label class="col-sm-3 control-label">Performance Status ECOG</label>
																<div class="col-sm-6"><?= gethtml('frmtratsphepecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmtratsphepecg); ?></div>
															</div>
														</td></tr>
														<tr><td>
															<div class="form-group tmss-form-group">
																<label class="col-sm-3 control-label">Laboratorio</label>
																<div class="col-sm-9">
																	<table class="table table-condensed table-bordered">
																		<tbody>
																			<tr>
																				<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
																				<td><?= gethtml('frmtratspheplabbil','docnum0601',$vew_patevlspc->frmtratspheplabbil,$lv_default); ?></td>
																				<td>RIN</td>
																				<td><?= gethtml('frmtratspheplabrin','docnum0601',$vew_patevlspc->frmtratspheplabrin,$lv_default); ?></td>
																			</tr>
																			<tr>
																				<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
																				<td><?= gethtml('frmtratspheplabalb','docnum0601',$vew_patevlspc->frmtratspheplabalb,$lv_default); ?></td>
																				<td>Encefalopatia Portosistemica</td>
																				<td><?= gethtml('frmtratspheplabenc',array(''=>'','no'=>'NO','I-II'=>'I-II','III-IV'=>'III-IV'),$vew_patevlspc->frmtratspheplabenc,$lv_default); ?></td>
																			</tr>
																			<tr>
																				<td>ASCITIS</td>
																				<td><?= gethtml('frmtratspheplabasc',array(''=>'','no'=>'NO','leve'=>'LEVE','moderada'=>'MODERADA'),$vew_patevlspc->frmtratspheplabasc,$lv_default); ?></td>
																				<td>Recuento de Plaquetas<br><small>(en mm3)</small></td>
																				<td><input type="NUMBER" id="frmtratspheplabrec" name="frmtratspheplabrec" value="<?= $vew_patevlspc->frmtratspheplabrec; ?>" maxlength="7" min="10000" max="1000000" step="1" class="form-control"></td>
																			</tr>
																			<tr>
																				<td>AFP al diagnostico<br><small>Alfa-fetoproteina (AFP) en ng/ml</small></td>
																				<td><?= gethtml('frmtratspheplabafp','docnum0601',$vew_patevlspc->frmtratspheplabafp,$lv_default); ?></td>
																				<td></td>
																				<td></td>
																			</tr>
																		</tbody>
																	</table>
																</div>
															</div>
														</td></tr>
														<tr><td>
															<div class="form-group tmss-form-group">
																<label class="col-sm-4 control-label">Fecha</label>
																<div class="col-sm-8"><?= gethtml('frmtratspheptypdte','docdte',$vew_patevlspc->frmtratspheptypdte,$lv_default); ?></div>
															</div>
														</td></tr>
													</table>
												</td></tr>
											</table>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Quimioembolizacion</label>
										<div class="col-sm-6"><?= gethtml('frmtraqui','yesno',$vew_patevlspc->frmtraqui,$lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtraquidiv">
										<div class="col-sm-3"></div>
										<div class="col-sm-9">
											<table class="table table-striped table-condensed table-bordered">
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Estad&iacute;o BCLC previo al tratamiento<br><small>acorde a juicio cl&iacute;nico subjetivo</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraquibcl',array(''=>'','0'=>'0','a'=>'A','b'=>'B','c'=>'C','d'=>'D'),$vew_patevlspc->frmtraquibcl,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica</label>
														<div class="col-sm-6"><?= gethtml('frmtraquinumnod','docnum0600',$vew_patevlspc->frmtraquinumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">HCC difuso</label>
														<div class="col-sm-6"><?= gethtml('frmtraquihccdif','yesno',$vew_patevlspc->frmtraquihccdif,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraquitamnod','docnum0600',$vew_patevlspc->frmtraquitamnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraquisumnod','docnum0600',$vew_patevlspc->frmtraquisumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraquiinvtum',array(''=>'','no'=>'NO','tronco'=>'Tronco de la Vena Porta','rama_der'=>'Rama derecha Porta','rama_izq'=>'Rama izquierda Porta','cava_inf'=>' Vena Cava inferior','suprahep'=>'Venas suprahep&aacute;ticas','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtraquiinvtum,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Enfermedad Extrahep&aacute;tica HCC</label>
														<div class="col-sm-6"><?= gethtml('frmtraquienfext',array(''=>'','no'=>'NO','osea'=>'OSEA','pulmon'=>'PULMON','otra'=>'OTRA','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtraquienfext,$lv_default); ?></div>
													</div>
													<div id="frmtraquienfextdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-3 control-label">Cual otra localizaci&oacute;n metast&aacute;sica?</label>
															<div class="col-sm-6"><?= gethtml('frmtraquienfextotr','doccmt1x20',$vew_patevlspc->frmtraquienfextotr,$lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Performance Status ECOG</label>
														<div class="col-sm-6"><?= gethtml('frmtraquiecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmtraquiecg); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Laboratorio</label>
														<div class="col-sm-9">
															<table class="table table-condensed table-bordered">
																<tbody>
																	<tr>
																		<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtraquilabbil','docnum0601',$vew_patevlspc->frmtraquilabbil,$lv_default); ?></td>
																		<td>RIN</td>
																		<td><?= gethtml('frmtraquilabrin','docnum0601',$vew_patevlspc->frmtraquilabrin,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtraquilabalb','docnum0601',$vew_patevlspc->frmtraquilabalb,$lv_default); ?></td>
																		<td>Encefalopatia Portosistemica</td>
																		<td><?= gethtml('frmtraquilabenc',array(''=>'','no'=>'NO','I-II'=>'I-II','III-IV'=>'III-IV'),$vew_patevlspc->frmtraquilabenc,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>ASCITIS</td>
																		<td><?= gethtml('frmtraquilabasc',array(''=>'','no'=>'NO','leve'=>'LEVE','moderada'=>'MODERADA'),$vew_patevlspc->frmtraquilabasc,$lv_default); ?></td>
																		<td>Recuento de Plaquetas<br><small>(en mm3)</small></td>
																		<td><input type="NUMBER" id="frmtraquilabrec" name="frmtraquilabrec" value="<?= $vew_patevlspc->frmtraquilabrec; ?>" maxlength="7" min="10000" max="1000000" step="1" class="form-control"></td>
																	</tr>
																	<tr>
																		<td>AFP al diagnostico<br><small>Alfa-fetoproteina (AFP) en ng/ml</small></td>
																		<td><?= gethtml('frmtraquilabafp','docnum0601',$vew_patevlspc->frmtraquilabafp,$lv_default); ?></td>
																		<td></td>
																		<td></td>
																	</tr>
																</tbody>
															</table>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Quimioembolizacion transarterial</label>
														<div class="col-sm-8"><?= gethtml('frmtraquitra',array(''=>'','no'=>'NO','tace_convensional'=>'TACE convencional','tace_de_beads'=>'TACE DE Beads','tae'=>'TAE (solo embolizaci&oacute;n, sin quimioinfusi&oacute;n)','quimioinf'=>'Quimioinfusi&oacute;n, sin embolizaci&oacute;n'),$vew_patevlspc->frmtraquitra,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">N&uacute;mero de Quimioembolizaciones realizadas</label>
														<div class="col-sm-8"><?= gethtml('frmtraquitranum','docnum0300',$vew_patevlspc->frmtraquitranum, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="container-fluid" role="tabpanel">
														<ul class="nav nav-tabs nav-justified">
															<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_traprctab01" role="tab" data-toggle="tab">TACE 1</a></li>
															<li role="presentation"><a href="#<?= $lv_sec; ?>_traprctab02" role="tab" data-toggle="tab">&Uacute;ltimo TACE</a></li>
														</ul>
														<div class="tab-content tmss-tab-content">
															<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_traprctab01">
																<div class="form-group tmss-form-group">
																	<label class="col-sm-4 control-label">Fecha</label>
																	<div class="col-sm-8"><?= gethtml('frmtraprc001dte','docdte',$vew_patevlspc->frmtraprc001dte, $lv_default); ?></div>
																</div>
																<div class="form-group tmss-form-group">
																	<label class="col-sm-4 control-label">Evaluaci&oacute;n Radiol&oacute;gica o Respuesta Post Quimioembolizaci&oacute;n <br><small>Evaluada por Im&aacute;genes, RECIST 1.1</small></label>
																	<div class="col-sm-8"><?= gethtml('frmtraprc001evlrad',array(''=>'','completa'=>'Respuesta Completa','parcial'=>'Respuesta Parcial','estable'=>'Enfermedad estable o sin cambios','progresion'=>'Progresi&oacute;n','no_valorado'=>'No valorado'),$vew_patevlspc->frmtraprc001evlrad,$lv_default); ?><br>
																		<small>
																		<ul>
																			<li><strong>Respuesta Completa:</strong> Desaparici&oacute;n completa del refuerzo arterial t&iacute;pico de todas las lesiones dianas HCC.</li><br>
																			<li><strong>Respuesta Parcial:</strong> Disminuci&oacute;n de al menos 30% en la suma de di&aacute;metros respecto a valores iniciales.</li><br>
																			<li><strong>Enfermedad Estable o Sin Cambios:</strong> Ni reducci&oacute;n de di&aacute;metro que clasifique RP ni suficiente aumento para clasificar progresi&oacute;n.</li><br>
																			<li><strong>Progresi&oacute;n:</strong> Aumento de al menos 20% en la suma de los di&aacute;metros respecto a valores iniciales y con al menos un aumento de 5mm en la suma.</li><br>
																			<li><strong>No valorado:</strong> No valorado.</li><br>
																		</ul>
																		</small>
																	</div>
																</div>
																<div class="form-group tmss-form-group">
																	<label class="col-sm-4 control-label">Fecha de Evaluaci&oacute;n Radiol&oacute;gica</label>
																	<div class="col-sm-8"><?= gethtml('frmtraprc001evlraddte','docdte',$vew_patevlspc->frmtraprc001evlraddte, $lv_default); ?></div>
																</div>
															</div>
															<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_traprctab02">
																<div class="form-group tmss-form-group">
																	<label class="col-sm-4 control-label">Fecha</label>
																	<div class="col-sm-8"><?= gethtml('frmtraprc002dte','docdte',$vew_patevlspc->frmtraprc002dte, $lv_default); ?></div>
																</div>
																<div class="form-group tmss-form-group">
																	<label class="col-sm-4 control-label">Evaluaci&oacute;n Radiol&oacute;gica o Respuesta Post Quimioembolizaci&oacute;n <br><small>Evaluada por Im&aacute;genes, RECIST 1.1</small></label>
																	<div class="col-sm-8"><?= gethtml('frmtraprc002evlrad',array(''=>'','completa'=>'Respuesta Completa','parcial'=>'Respuesta Parcial','estable'=>'Enfermedad estable o sin cambios','progresion'=>'Progresi&oacute;n','no_valorado'=>'No valorado'),$vew_patevlspc->frmtraprc002evlrad,$lv_default); ?><br>
																		<small>
																		<ul>
																			<li><strong>Respuesta Completa:</strong> Desaparici&oacute;n completa del refuerzo arterial t&iacute;pico de todas las lesiones dianas HCC.</li><br>
																			<li><strong>Respuesta Parcial:</strong> Disminuci&oacute;n de al menos 30% en la suma de di&aacute;metros respecto a valores iniciales.</li><br>
																			<li><strong>Enfermedad Estable o Sin Cambios:</strong> Ni reducci&oacute;n de di&aacute;metro que clasifique RP ni suficiente aumento para clasificar progresi&oacute;n.</li><br>
																			<li><strong>Progresi&oacute;n:</strong> Aumento de al menos 20% en la suma de los di&aacute;metros respecto a valores iniciales y con al menos un aumento de 5mm en la suma.</li><br>
																			<li><strong>No valorado:</strong> No valorado.</li><br>
																		</ul>
																		</small>
																	</div>
																</div>
																<div class="form-group tmss-form-group">
																	<label class="col-sm-4 control-label">Fecha de Evaluaci&oacute;n Radiol&oacute;gica</label>
																	<div class="col-sm-8"><?= gethtml('frmtraprc002evlraddte','docdte',$vew_patevlspc->frmtraprc002evlraddte, $lv_default); ?></div>
																</div>
															</div>
														</div>
													</div>
												</td></tr>
											</table>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Radioembolizaci&oacute;n Ytrio</label>
										<div class="col-sm-6"><?= gethtml('frmtraradytr','yesno',$vew_patevlspc->frmtraradytr, $lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtraradytrdiv">
										<div class="col-sm-3"></div>
										<div class="col-sm-9">
											<table class="table table-striped table-condensed table-bordered">
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Estad&iacute;o BCLC previo al tratamiento<br><small>acorde a juicio cl&iacute;nico subjetivo</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraradytrbcl',array(''=>'','0'=>'0','a'=>'A','b'=>'B','c'=>'C','d'=>'D'),$vew_patevlspc->frmtraradytrbcl,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica</label>
														<div class="col-sm-6"><?= gethtml('frmtraradnumnod','docnum0600',$vew_patevlspc->frmtraradnumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">HCC difuso</label>
														<div class="col-sm-6"><?= gethtml('frmtraradhccdif','yesno',$vew_patevlspc->frmtraradhccdif,$lv_default); ?></div>
													</div>
												</td></tr>												
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraradtamnod','docnum0600',$vew_patevlspc->frmtraradtamnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraradsumnod','docnum0600',$vew_patevlspc->frmtraradsumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraradinvtum',array(''=>'','no'=>'NO','tronco'=>'Tronco de la Vena Porta','rama_der'=>'Rama derecha Porta','rama_izq'=>'Rama izquierda Porta','cava_inf'=>' Vena Cava inferior','suprahep'=>'Venas suprahep&aacute;ticas','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtraradinvtum,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Enfermedad Extrahep&aacute;tica HCC</label>
														<div class="col-sm-6"><?= gethtml('frmtraradenfext',array(''=>'','no'=>'NO','osea'=>'OSEA','pulmon'=>'PULMON','otra'=>'OTRA','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtraradenfext,$lv_default); ?></div>
													</div>
													<div id="frmtraradenfextdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-3 control-label">Cual otra localizaci&oacute;n metast&aacute;sica?</label>
															<div class="col-sm-6"><?= gethtml('frmtraradenfextotr','doccmt1x20',$vew_patevlspc->frmtraradenfextotr,$lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Performance Status ECOG</label>
														<div class="col-sm-6"><?= gethtml('frmtraradecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmtraradecg); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Laboratorio</label>
														<div class="col-sm-9">
															<table class="table table-condensed table-bordered">
																<tbody>
																	<tr>
																		<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtraradlabbil','docnum0601',$vew_patevlspc->frmtraradlabbil,$lv_default); ?></td>
																		<td>RIN</td>
																		<td><?= gethtml('frmtraradlabrin','docnum0601',$vew_patevlspc->frmtraradlabrin,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtraradlabalb','docnum0601',$vew_patevlspc->frmtraradlabalb,$lv_default); ?></td>
																		<td>Encefalopatia Portosistemica</td>
																		<td><?= gethtml('frmtraradlabenc',array(''=>'','no'=>'NO','I-II'=>'I-II','III-IV'=>'III-IV'),$vew_patevlspc->frmtraradlabenc,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>ASCITIS</td>
																		<td><?= gethtml('frmtraradlabasc',array(''=>'','no'=>'NO','leve'=>'LEVE','moderada'=>'MODERADA'),$vew_patevlspc->frmtraradlabasc,$lv_default); ?></td>
																		<td>Recuento de Plaquetas<br><small>(en mm3)</small></td>
																		<td><input type="NUMBER" id="frmtraradlabrec" name="frmtraradlabrec" value="<?= $vew_patevlspc->frmtraradlabrec; ?>" maxlength="7" min="10000" max="1000000" step="1" class="form-control"></td>
																	</tr>
																	<tr>
																		<td>AFP al diagnostico<br><small>Alfa-fetoproteina (AFP) en ng/ml</small></td>
																		<td><?= gethtml('frmtraradlabafp','docnum0601',$vew_patevlspc->frmtraradlabafp,$lv_default); ?></td>
																		<td></td>
																		<td></td>
																	</tr>
																</tbody>
															</table>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha</label>
														<div class="col-sm-8"><?= gethtml('frmtraradytrdte','docdte',$vew_patevlspc->frmtraradytrdte, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Respuesta Post Radioembolizaci&oacute;n<br><small>Evaluada por Im&aacute;genes, RECIST 1.1</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraradytrrsp',array(''=>'','completa'=>'Respuesta Completa','parcial'=>'Respuesta Parcial','estable'=>'Enfermedad estable o sin cambios','progresion'=>'Progresi&oacute;n','no_valorado'=>'No valorado'),$vew_patevlspc->frmtraradytrrsp,$lv_default); ?><br>
															<small>
															<ul>
																<li><strong>Respuesta Completa:</strong> Desaparici&oacute;n completa del refuerzo arterial t&iacute;pico de todas las lesiones dianas HCC.</li><br>
																<li><strong>Respuesta Parcial:</strong> Disminuci&oacute;n de al menos 30% en la suma de di&aacute;metros respecto a valores iniciales.</li><br>
																<li><strong>Enfermedad Estable o Sin Cambios:</strong> Ni reducci&oacute;n de di&aacute;metro que clasifique RP ni suficiente aumento para clasificar progresi&oacute;n.</li><br>
																<li><strong>Progresi&oacute;n:</strong> Aumento de al menos 20% en la suma de los di&aacute;metros respecto a valores iniciales y con al menos un aumento de 5mm en la suma.</li><br>
																<li><strong>No valorado:</strong> No valorado.</li><br>
															</ul>
															</small>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha de Evaluaci&oacute;n Radiol&oacute;gica post Radioembolizaci&oacute;n</label>
														<div class="col-sm-8"><?= gethtml('frmtraradytrdteevl','docdte',$vew_patevlspc->frmtraradytrdteevl, $lv_default); ?></div>
													</div>
												</td></tr>
											</table>
										</div>
									</div>
								</td></tr>


								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Sorafenib</label>
										<div class="col-sm-6"><?= gethtml('frmtrasor','yesno',$vew_patevlspc->frmtrasor, $lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtrasordiv">
										<div class="col-sm-3"></div>
										<div class="col-sm-9">
											<table class="table table-striped table-condensed table-bordered">
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Estad&iacute;o BCLC previo al tratamiento<br><small>acorde a juicio cl&iacute;nico subjetivo</small></label>
														<div class="col-sm-8"><?= gethtml('frmtrasorbcl',array(''=>'','0'=>'0','a'=>'A','b'=>'B','c'=>'C','d'=>'D'),$vew_patevlspc->frmtrasorbcl,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica</label>
														<div class="col-sm-6"><?= gethtml('frmtrasornumnod','docnum0600',$vew_patevlspc->frmtrasornumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">HCC difuso</label>
														<div class="col-sm-6"><?= gethtml('frmtrasorhccdif','yesno',$vew_patevlspc->frmtrasorhccdif,$lv_default); ?></div>
													</div>
												</td></tr>												
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtrasortamnod','docnum0600',$vew_patevlspc->frmtrasortamnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtrasorsumnod','docnum0600',$vew_patevlspc->frmtrasorsumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes</small></label>
														<div class="col-sm-6"><?= gethtml('frmtrasorinvtum',array(''=>'','no'=>'NO','tronco'=>'Tronco de la Vena Porta','rama_der'=>'Rama derecha Porta','rama_izq'=>'Rama izquierda Porta','cava_inf'=>' Vena Cava inferior','suprahep'=>'Venas suprahep&aacute;ticas','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtrasorinvtum,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Enfermedad Extrahep&aacute;tica HCC</label>
														<div class="col-sm-6"><?= gethtml('frmtrasorenfext',array(''=>'','no'=>'NO','osea'=>'OSEA','pulmon'=>'PULMON','otra'=>'OTRA','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtrasorenfext,$lv_default); ?></div>
													</div>
													<div id="frmtrasorenfextdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-3 control-label">Cual otra localizaci&oacute;n metast&aacute;sica?</label>
															<div class="col-sm-6"><?= gethtml('frmtrasorenfextotr','doccmt1x20',$vew_patevlspc->frmtrasorenfextotr,$lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Performance Status ECOG</label>
														<div class="col-sm-6"><?= gethtml('frmtrasorecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmtrasorecg); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Laboratorio</label>
														<div class="col-sm-9">
															<table class="table table-condensed table-bordered">
																<tbody>
																	<tr>
																		<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtrasorlabbil','docnum0601',$vew_patevlspc->frmtrasorlabbil,$lv_default); ?></td>
																		<td>RIN</td>
																		<td><?= gethtml('frmtrasorlabrin','docnum0601',$vew_patevlspc->frmtrasorlabrin,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtrasorlabalb','docnum0601',$vew_patevlspc->frmtrasorlabalb,$lv_default); ?></td>
																		<td>Encefalopatia Portosistemica</td>
																		<td><?= gethtml('frmtrasorlabenc',array(''=>'','no'=>'NO','I-II'=>'I-II','III-IV'=>'III-IV'),$vew_patevlspc->frmtrasorlabenc,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>ASCITIS</td>
																		<td><?= gethtml('frmtrasorlabasc',array(''=>'','no'=>'NO','leve'=>'LEVE','moderada'=>'MODERADA'),$vew_patevlspc->frmtrasorlabasc,$lv_default); ?></td>
																		<td>Recuento de Plaquetas<br><small>(en mm3)</small></td>
																		<td><input type="NUMBER" id="frmtrasorlabrec" name="frmtrasorlabrec" value="<?= $vew_patevlspc->frmtrasorlabrec; ?>" maxlength="7" min="10000" max="1000000" step="1" class="form-control"></td>
																	</tr>
																	<tr>
																		<td>AFP al diagnostico<br><small>Alfa-fetoproteina (AFP) en ng/ml</small></td>
																		<td><?= gethtml('frmtrasorlabafp','docnum0601',$vew_patevlspc->frmtrasorlabafp,$lv_default); ?></td>
																		<td></td>
																		<td></td>
																	</tr>
																</tbody>
															</table>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha Inicio Sorafenib</label>
														<div class="col-sm-8"><?= gethtml('frmtrasordte','docdte',$vew_patevlspc->frmtrasordte, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Sorafenib: Dosis de Inicio<br><small>en mg</small></label>
														<div class="col-sm-8"><?= gethtml('frmtrasordssini',array(''=>'','200'=>'200 mg dia','400'=>'400 mg dia','600'=>'600 mg dia','800'=>'800 mg dia','no_disponible'=>'Dato no disponible'), $vew_patevlspc->frmtrasordssini, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Sorafenib: Dosis M&aacute;xima<br><small>en mg</small></label>
														<div class="col-sm-8"><?= gethtml('frmtrasordssmax',array(''=>'','200'=>'200 mg dia','400'=>'400 mg dia','600'=>'600 mg dia','800'=>'800 mg dia','no_dispnible'=>'Dato no disponible'), $vew_patevlspc->frmtrasordssmax, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Reducci&oacute;n de Dosis de Sorafenib<br><small>en mg</small></label>
														<div class="col-sm-8"><?= gethtml('frmtrasorreddss',array(''=>'','no'=>'No','600'=>'600 mg dia','400'=>'400 mg dia','200'=>'200 mg dia','otro'=>'Otro','no_disponible'=>'Dato no disponible'), $vew_patevlspc->frmtrasorreddss, $lv_default); ?></div>
													</div>
													<div id="frmtrasorreddssdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Fecha</label>
															<div class="col-sm-8"><?= gethtml('frmtrasorreddssdte','docdte',$vew_patevlspc->frmtrasorreddssdte, $lv_default); ?></div>
														</div>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Motivo de Reducci&oacute;n de Dosis de Sorafenib<br><small>en mg</small></label>
															<div class="col-sm-8"><?= gethtml('frmtrasorreddssmtv',array(''=>'','intolerancia'=>'Intolerancia','enf_hepatica'=>'Presencia de Enfermedad Hepatica','sepsis'=>'Sepsis','otro'=>'Otro'), $vew_patevlspc->frmtrasorreddssmtv, $lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Severidad efectos adversos<br><small>acorde NCTA 4.0</small></label>
														<div class="col-sm-8"><?= gethtml('frmtrasoreftadvsev',array(''=>'','leve'=>'Leve','moderado'=>'Moderado','severo'=>'Severo'), $vew_patevlspc->frmtrasoreftadvsev, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Efectos adversos a Sorafenib</label>
														<div class="col-sm-8">
															<label><input type="checkbox" id="frmtrasoreftadv" name="frmtrasoreftadv001" <?= ($vew_patevlspc->frmtrasoreftadv001!=''?'checked':''); ?>> Fatiga</label><br>
															<label><input type="checkbox" id="frmtrasoreftadv" name="frmtrasoreftadv002" <?= ($vew_patevlspc->frmtrasoreftadv002!=''?'checked':''); ?>> Diarrea</label><br>
															<label><input type="checkbox" id="frmtrasoreftadv" name="frmtrasoreftadv003" <?= ($vew_patevlspc->frmtrasoreftadv003!=''?'checked':''); ?>> Rash</label><br>
															<label><input type="checkbox" id="frmtrasoreftadv" name="frmtrasoreftadv004" <?= ($vew_patevlspc->frmtrasoreftadv004!=''?'checked':''); ?>> Sindrome de Mano-Pie</label><br>
															<label><input type="checkbox" id="frmtrasoreftadv" name="frmtrasoreftadv005" <?= ($vew_patevlspc->frmtrasoreftadv005!=''?'checked':''); ?>> Hipertension Arterial</label><br>
															<label><input type="checkbox" id="frmtrasoreftadv" name="frmtrasoreftadv006" <?= ($vew_patevlspc->frmtrasoreftadv006!=''?'checked':''); ?>> Sangrado</label><br>
															<label><input type="checkbox" id="frmtrasoreftadv" name="frmtrasoreftadv007" <?= ($vew_patevlspc->frmtrasoreftadv007!=''?'checked':''); ?>> Evento Cardiovascular</label><br>
															<label><input type="checkbox" id="frmtrasoreftadv" name="frmtrasoreftadv008" <?= ($vew_patevlspc->frmtrasoreftadv008!=''?'checked':''); ?>> Dato no disponible</label><br>
															<label><input type="checkbox" id="frmtrasoreftadv" name="frmtrasoreftadv009" <?= ($vew_patevlspc->frmtrasoreftadv009!=''?'checked':''); ?>> Otro</label><br>
														</div>
													</div>
													<div id="frmtrasoreftadvdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Indique</label>
															<div class="col-sm-8"><?= gethtml('frmtrasoreftadvotr','doccmt1x50',$vew_patevlspc->frmtrasoreftadvotr, $lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha de Discontinuaci&oacute;n permanente de Sorafenib</label>
														<div class="col-sm-8"><?= gethtml('frmtrasorcncdte','docdte',$vew_patevlspc->frmtrasorcncdte, $lv_default); ?></div>
													</div>
													<div id="frmtrasorcncdtediv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Motivo de Discontinuaci&oacute;n permanente de Sorafenib</label>
															<div class="col-sm-8">
																<label><input type="checkbox" id="frmtrasorcncmtv" name="frmtrasorcncmtv001" <?= ($vew_patevlspc->frmtrasorcncmtv001!=''?'checked':''); ?>> Intolerancia o Efecto Adverso Moderado-Severo</label><br>
																<label><input type="checkbox" id="frmtrasorcncmtv" name="frmtrasorcncmtv002" <?= ($vew_patevlspc->frmtrasorcncmtv002!=''?'checked':''); ?>> Progresion de la Enfermedad Hepatica (>= 2 puntos de score de Child Pugh)</label><br>
																<label><input type="checkbox" id="frmtrasorcncmtv" name="frmtrasorcncmtv003" <?= ($vew_patevlspc->frmtrasorcncmtv003!=''?'checked':''); ?>> Progresion de Enfermedad Tumoral</label><br>
																<div id="frmtrasorcncmtv003div">
																	<label class="col-sm-2 control-label">Indique</label>
																	<div class="col-sm-10"><?= gethtml('frmtrasorcncmtv003typ',array(''=>'','lesion_intra'=>'Nueva lesi&oacute;n intrahep&aacute;tica','aumento_diam_intra'=>'Aumento del di&aacute;metro de lesi&oacute;n intrahep&aacute;tica','lesion_extra'=>'Nueva lesi&oacute;n extrahep&aacute;tica','aumento_diam_extra'=>'Aumento del di&aacute;metro de la lesi&oacute;n extrahep&aacute;tica','invasion'=>'Invasi&oacute;n vascular'), $vew_patevlspc->frmtrasorcncmtv003typ, $lv_default); ?></div>
																</div>
																<label><input type="checkbox" id="frmtrasorcncmtv" name="frmtrasorcncmtv004" <?= ($vew_patevlspc->frmtrasorcncmtv004!=''?'checked':''); ?>> Progresion Sintomatica (ECOG=4)</label><br>
																<label><input type="checkbox" id="frmtrasorcncmtv" name="frmtrasorcncmtv005" <?= ($vew_patevlspc->frmtrasorcncmtv005!=''?'checked':''); ?>> Otro</label><br>
															</div>
														</div>
														<div id="frmtrasorcncmtvdiv">
															<div class="form-group tmss-form-group">
																<label class="col-sm-4 control-label">Indique</label>
																<div class="col-sm-8"><?= gethtml('frmtrasorcncmtvotr','doccmt1x50',$vew_patevlspc->frmtrasorcncmtvotr, $lv_default); ?></div>
															</div>
														</div>
													</div>
												</td></tr>
											</table>
										</div>
									</div>
								</td></tr>

								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Lenvatinib</label>
										<div class="col-sm-6"><?= gethtml('frmtralen','yesno',$vew_patevlspc->frmtralen, $lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtralendiv">
										<div class="col-sm-3"></div>
										<div class="col-sm-9">
											<table class="table table-striped table-condensed table-bordered">
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Estad&iacute;o BCLC previo al tratamiento<br><small>acorde a juicio cl&iacute;nico subjetivo</small></label>
														<div class="col-sm-8"><?= gethtml('frmtralenbcl',array(''=>'','0'=>'0','a'=>'A','b'=>'B','c'=>'C','d'=>'D'),$vew_patevlspc->frmtralenbcl,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica</label>
														<div class="col-sm-6"><?= gethtml('frmtralennumnod','docnum0600',$vew_patevlspc->frmtralennumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">HCC difuso</label>
														<div class="col-sm-6"><?= gethtml('frmtralenhccdif','yesno',$vew_patevlspc->frmtralenhccdif,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtralentamnod','docnum0600',$vew_patevlspc->frmtralentamnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtralensumnod','docnum0600',$vew_patevlspc->frmtralensumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraleninvtum',array(''=>'','no'=>'NO','tronco'=>'Tronco de la Vena Porta','rama_der'=>'Rama derecha Porta','rama_izq'=>'Rama izquierda Porta','cava_inf'=>' Vena Cava inferior','suprahep'=>'Venas suprahep&aacute;ticas','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtraleninvtum,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Enfermedad Extrahep&aacute;tica HCC</label>
														<div class="col-sm-6"><?= gethtml('frmtralenenfext',array(''=>'','no'=>'NO','osea'=>'OSEA','pulmon'=>'PULMON','otra'=>'OTRA','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtralenenfext,$lv_default); ?></div>
													</div>
													<div id="frmtralenenfextdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-3 control-label">Cual otra localizaci&oacute;n metast&aacute;sica?</label>
															<div class="col-sm-6"><?= gethtml('frmtralenenfextotr','doccmt1x20',$vew_patevlspc->frmtralenenfextotr,$lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Performance Status ECOG</label>
														<div class="col-sm-6"><?= gethtml('frmtralenecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmtralenecg); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Laboratorio</label>
														<div class="col-sm-9">
															<table class="table table-condensed table-bordered">
																<tbody>
																	<tr>
																		<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtralenlabbil','docnum0601',$vew_patevlspc->frmtralenlabbil,$lv_default); ?></td>
																		<td>RIN</td>
																		<td><?= gethtml('frmtralenlabrin','docnum0601',$vew_patevlspc->frmtralenlabrin,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtralenlabalb','docnum0601',$vew_patevlspc->frmtralenlabalb,$lv_default); ?></td>
																		<td>Encefalopatia Portosistemica</td>
																		<td><?= gethtml('frmtralenlabenc',array(''=>'','no'=>'NO','I-II'=>'I-II','III-IV'=>'III-IV'),$vew_patevlspc->frmtralenlabenc,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>ASCITIS</td>
																		<td><?= gethtml('frmtralenlabasc',array(''=>'','no'=>'NO','leve'=>'LEVE','moderada'=>'MODERADA'),$vew_patevlspc->frmtralenlabasc,$lv_default); ?></td>
																		<td>Recuento de Plaquetas<br><small>(en mm3)</small></td>
																		<td><input type="NUMBER" id="frmtralenlabrec" name="frmtralenlabrec" value="<?= $vew_patevlspc->frmtralenlabrec; ?>" maxlength="7" min="10000" max="1000000" step="1" class="form-control"></td>
																	</tr>
																	<tr>
																		<td>AFP al diagnostico<br><small>Alfa-fetoproteina (AFP) en ng/ml</small></td>
																		<td><?= gethtml('frmtralenlabafp','docnum0601',$vew_patevlspc->frmtralenlabafp,$lv_default); ?></td>
																		<td></td>
																		<td></td>
																	</tr>
																</tbody>
															</table>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha Inicio Lenvatinib</label>
														<div class="col-sm-8"><?= gethtml('frmtralendte','docdte',$vew_patevlspc->frmtralendte, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Lenvatinib: Dosis de Inicio<br><small>en mg</small></label>
														<div class="col-sm-8"><?= gethtml('frmtralendssini',array(''=>'','4'=>'4 mg dia','6'=>'6 mg dia','8'=>'8 mg dia','12'=>'12 mg dia','no_disponible'=>'Dato no disponible'), $vew_patevlspc->frmtralendssini, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Lenvatinib: Dosis M&aacute;xima<br><small>en mg</small></label>
														<div class="col-sm-8"><?= gethtml('frmtralendssmax',array(''=>'','4'=>'4 mg dia','6'=>'6 mg dia','8'=>'8 mg dia','12'=>'12 mg dia','no_dispnible'=>'Dato no disponible'), $vew_patevlspc->frmtralendssmax, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Reducci&oacute;n de Dosis de Lenvatinib<br><small>en mg</small></label>
														<div class="col-sm-8"><?= gethtml('frmtralenreddss',array(''=>'','no'=>'No','4'=>'4 mg dia','6'=>'6 mg dia','8'=>'8 mg dia','otro'=>'Otro','no_disponible'=>'Dato no disponible'), $vew_patevlspc->frmtralenreddss, $lv_default); ?></div>
													</div>
													<div id="frmtralenreddssdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Fecha</label>
															<div class="col-sm-8"><?= gethtml('frmtralenreddssdte','docdte',$vew_patevlspc->frmtralenreddssdte, $lv_default); ?></div>
														</div>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Motivo de Reducci&oacute;n de Dosis de Lenvatinib<br><small>en mg</small></label>
															<div class="col-sm-8"><?= gethtml('frmtralenreddssmtv',array(''=>'','intolerancia'=>'Intolerancia','enf_hepatica'=>'Presencia de Enfermedad Hepatica','sepsis'=>'Sepsis','otro'=>'Otro'), $vew_patevlspc->frmtralenreddssmtv, $lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Severidad efectos adversos<br><small>acorde NCTA 4.0</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraleneftadvsev',array(''=>'','leve'=>'Leve','moderado'=>'Moderado','severo'=>'Severo'), $vew_patevlspc->frmtraleneftadvsev, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Efectos adversos a Lenvatinib</label>
														<div class="col-sm-8">
															<label><input type="checkbox" id="frmtraleneftadv" name="frmtraleneftadv001" <?= ($vew_patevlspc->frmtraleneftadv001!=''?'checked':''); ?>> Fatiga</label><br>
															<label><input type="checkbox" id="frmtraleneftadv" name="frmtraleneftadv002" <?= ($vew_patevlspc->frmtraleneftadv002!=''?'checked':''); ?>> Diarrea</label><br>
															<label><input type="checkbox" id="frmtraleneftadv" name="frmtraleneftadv003" <?= ($vew_patevlspc->frmtraleneftadv003!=''?'checked':''); ?>> Rash</label><br>
															<label><input type="checkbox" id="frmtraleneftadv" name="frmtraleneftadv004" <?= ($vew_patevlspc->frmtraleneftadv004!=''?'checked':''); ?>> Sindrome de Mano-Pie</label><br>
															<label><input type="checkbox" id="frmtraleneftadv" name="frmtraleneftadv005" <?= ($vew_patevlspc->frmtraleneftadv005!=''?'checked':''); ?>> Hipertension Arterial</label><br>
															<label><input type="checkbox" id="frmtraleneftadv" name="frmtraleneftadv006" <?= ($vew_patevlspc->frmtraleneftadv006!=''?'checked':''); ?>> Sangrado</label><br>
															<label><input type="checkbox" id="frmtraleneftadv" name="frmtraleneftadv007" <?= ($vew_patevlspc->frmtraleneftadv007!=''?'checked':''); ?>> Evento Cardiovascular</label><br>
															<label><input type="checkbox" id="frmtraleneftadv" name="frmtraleneftadv008" <?= ($vew_patevlspc->frmtraleneftadv008!=''?'checked':''); ?>> Hipotiroidismo</label><br>
															<label><input type="checkbox" id="frmtraleneftadv" name="frmtraleneftadv009" <?= ($vew_patevlspc->frmtraleneftadv009!=''?'checked':''); ?>> Otro</label><br>
														</div>
													</div>
													<div id="frmtraleneftadvdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Indique</label>
															<div class="col-sm-8"><?= gethtml('frmtraleneftadvotr','doccmt1x50',$vew_patevlspc->frmtraleneftadvotr, $lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha de Discontinuaci&oacute;n permanente de Lenvatinib</label>
														<div class="col-sm-8"><?= gethtml('frmtralencncdte','docdte',$vew_patevlspc->frmtralencncdte, $lv_default); ?></div>
													</div>
													<div id="frmtralencncdtediv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Motivo de Discontinuaci&oacute;n permanente de Lenvatinib</label>
															<div class="col-sm-8">
																<label><input type="checkbox" id="frmtralencncmtv" name="frmtralencncmtv001" <?= ($vew_patevlspc->frmtralencncmtv001!=''?'checked':''); ?>> Intolerancia o Efecto Adverso Moderado-Severo</label><br>
																<label><input type="checkbox" id="frmtralencncmtv" name="frmtralencncmtv002" <?= ($vew_patevlspc->frmtralencncmtv002!=''?'checked':''); ?>> Progresion de la Enfermedad Hepatica (>= 2 puntos de score de Child Pugh)</label><br>
																<label><input type="checkbox" id="frmtralencncmtv" name="frmtralencncmtv003" <?= ($vew_patevlspc->frmtralencncmtv003!=''?'checked':''); ?>> Progresion de Enfermedad Tumoral</label><br>
																<div id="frmtralencncmtv003div">
																	<label class="col-sm-2 control-label">Indique</label>
																	<div class="col-sm-10"><?= gethtml('frmtralencncmtv003typ',array(''=>'','lesion_intra'=>'Nueva lesi&oacute;n intrahep&aacute;tica','aumento_diam_intra'=>'Aumento del di&aacute;metro de lesi&oacute;n intrahep&aacute;tica','lesion_extra'=>'Nueva lesi&oacute;n extrahep&aacute;tica','aumento_diam_extra'=>'Aumento del di&aacute;metro de la lesi&oacute;n extrahep&aacute;tica','invasion'=>'Invasi&oacute;n vascular'), $vew_patevlspc->frmtralencncmtv003typ, $lv_default); ?></div>
																</div>
																<label><input type="checkbox" id="frmtralencncmtv" name="frmtralencncmtv004" <?= ($vew_patevlspc->frmtralencncmtv004!=''?'checked':''); ?>> Progresion Sintomatica (ECOG=4)</label><br>
																<label><input type="checkbox" id="frmtralencncmtv" name="frmtralencncmtv005" <?= ($vew_patevlspc->frmtralencncmtv005!=''?'checked':''); ?>> Otro</label><br>
															</div>
														</div>
														<div id="frmtralencncmtvdiv">
															<div class="form-group tmss-form-group">
																<label class="col-sm-4 control-label">Indique</label>
																<div class="col-sm-8"><?= gethtml('frmtralencncmtvotr','doccmt1x50',$vew_patevlspc->frmtralencncmtvotr, $lv_default); ?></div>
															</div>
														</div>
													</div>
												</td></tr>
											</table>
										</div>
									</div>
								</td></tr>


								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">ATEZOLIZUMAB + BEVACIZUMAB</label>
										<div class="col-sm-6"><?= gethtml('frmtraate','yesno',$vew_patevlspc->frmtraate, $lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtraatediv">
										<div class="col-sm-3"></div>
										<div class="col-sm-9">
											<table class="table table-striped table-condensed table-bordered">
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Estad&iacute;o BCLC previo al tratamiento<br><small>acorde a juicio cl&iacute;nico subjetivo</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraatebcl',array(''=>'','0'=>'0','a'=>'A','b'=>'B','c'=>'C','d'=>'D'),$vew_patevlspc->frmtraatebcl,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica</label>
														<div class="col-sm-6"><?= gethtml('frmtraatenumnod','docnum0600',$vew_patevlspc->frmtraatenumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">HCC difuso</label>
														<div class="col-sm-6"><?= gethtml('frmtraatehccdif','yesno',$vew_patevlspc->frmtraatehccdif,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraatetamnod','docnum0600',$vew_patevlspc->frmtraatetamnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraatesumnod','docnum0600',$vew_patevlspc->frmtraatesumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraateinvtum',array(''=>'','no'=>'NO','tronco'=>'Tronco de la Vena Porta','rama_der'=>'Rama derecha Porta','rama_izq'=>'Rama izquierda Porta','cava_inf'=>' Vena Cava inferior','suprahep'=>'Venas suprahep&aacute;ticas','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtraateinvtum,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Enfermedad Extrahep&aacute;tica HCC</label>
														<div class="col-sm-6"><?= gethtml('frmtraateenfext',array(''=>'','no'=>'NO','osea'=>'OSEA','pulmon'=>'PULMON','otra'=>'OTRA','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtraateenfext,$lv_default); ?></div>
													</div>
													<div id="frmtraateenfextdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-3 control-label">Cual otra localizaci&oacute;n metast&aacute;sica?</label>
															<div class="col-sm-6"><?= gethtml('frmtraateenfextotr','doccmt1x20',$vew_patevlspc->frmtraateenfextotr,$lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Performance Status ECOG</label>
														<div class="col-sm-6"><?= gethtml('frmtraateecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmtraateecg); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Laboratorio</label>
														<div class="col-sm-9">
															<table class="table table-condensed table-bordered">
																<tbody>
																	<tr>
																		<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtraatelabbil','docnum0601',$vew_patevlspc->frmtraatelabbil,$lv_default); ?></td>
																		<td>RIN</td>
																		<td><?= gethtml('frmtraatelabrin','docnum0601',$vew_patevlspc->frmtraatelabrin,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtraatelabalb','docnum0601',$vew_patevlspc->frmtraatelabalb,$lv_default); ?></td>
																		<td>Encefalopatia Portosistemica</td>
																		<td><?= gethtml('frmtraatelabenc',array(''=>'','no'=>'NO','I-II'=>'I-II','III-IV'=>'III-IV'),$vew_patevlspc->frmtraatelabenc,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>ASCITIS</td>
																		<td><?= gethtml('frmtraatelabasc',array(''=>'','no'=>'NO','leve'=>'LEVE','moderada'=>'MODERADA'),$vew_patevlspc->frmtraatelabasc,$lv_default); ?></td>
																		<td>Recuento de Plaquetas<br><small>(en mm3)</small></td>
																		<td><input type="NUMBER" id="frmtraatelabrec" name="frmtraatelabrec" value="<?= $vew_patevlspc->frmtraatelabrec; ?>" maxlength="7" min="10000" max="1000000" step="1" class="form-control"></td>
																	</tr>
																	<tr>
																		<td>AFP al diagnostico<br><small>Alfa-fetoproteina (AFP) en ng/ml</small></td>
																		<td><?= gethtml('frmtraatelabafp','docnum0601',$vew_patevlspc->frmtraatelabafp,$lv_default); ?></td>
																		<td></td>
																		<td></td>
																	</tr>
																</tbody>
															</table>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha Inicio Atezo + Beva</label>
														<div class="col-sm-8"><?= gethtml('frmtraatedte','docdte',$vew_patevlspc->frmtraatedte, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">N&uacute;mero de ciclos Atezolizumab</label>
														<div class="col-sm-8"><?= gethtml('frmtraatedssiniate','docnum0600', $vew_patevlspc->frmtraatedssiniate, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">N&uacute;mero de ciclos Bevacizumab</label>
														<div class="col-sm-8"><?= gethtml('frmtraatedssinibev','docnum0300', $vew_patevlspc->frmtraatedssinibev, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Reducci&oacute;n de n&uacute;mero de ciclos de Atezo + Beva</label>
														<div class="col-sm-8"><?= gethtml('frmtraatereddss',array(''=>'','no'=>'No','reduccion'=>'Reduccion de Dosis','interrupcion'=>'Interrupciones de Dosis/Infusion','sin_interrupcion'=>'Sin Interrupciones'), $vew_patevlspc->frmtraatereddss, $lv_default); ?></div>
													</div>
													<div id="frmtraatereddssdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Fecha</label>
															<div class="col-sm-8"><?= gethtml('frmtraatereddssdte','docdte',$vew_patevlspc->frmtraatereddssdte, $lv_default); ?></div>
														</div>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Motivo de Reducci&oacute;n de n&uacute;mero de ciclos de Atezo + Beva</label>
															<div class="col-sm-8"><?= gethtml('frmtraatereddssmtv',array(''=>'','intolerancia'=>'Intolerancia','enf_hepatica'=>'Presencia de Enfermedad Hepatica','sepsis'=>'Sepsis','otro'=>'Otro'), $vew_patevlspc->frmtraatereddssmtv, $lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Severidad efectos adversos<br><small>acorde NCTA 4.0</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraateeftadvsev',array(''=>'','leve'=>'Leve','moderado'=>'Moderado','severo'=>'Severo'), $vew_patevlspc->frmtraateeftadvsev, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Efectos adversos a Atezo + Beva</label>
														<div class="col-sm-8">
															<label><input type="checkbox" id="frmtraateeftadv" name="frmtraateeftadv001" <?= ($vew_patevlspc->frmtraateeftadv001!=''?'checked':''); ?>> Fatiga</label><br>
															<label><input type="checkbox" id="frmtraateeftadv" name="frmtraateeftadv002" <?= ($vew_patevlspc->frmtraateeftadv002!=''?'checked':''); ?>> Diarrea</label><br>
															<label><input type="checkbox" id="frmtraateeftadv" name="frmtraateeftadv003" <?= ($vew_patevlspc->frmtraateeftadv003!=''?'checked':''); ?>> Rash</label><br>
															<label><input type="checkbox" id="frmtraateeftadv" name="frmtraateeftadv004" <?= ($vew_patevlspc->frmtraateeftadv004!=''?'checked':''); ?>> Sindrome de Mano-Pie</label><br>
															<label><input type="checkbox" id="frmtraateeftadv" name="frmtraateeftadv005" <?= ($vew_patevlspc->frmtraateeftadv005!=''?'checked':''); ?>> Hipertension Arterial</label><br>
															<label><input type="checkbox" id="frmtraateeftadv" name="frmtraateeftadv006" <?= ($vew_patevlspc->frmtraateeftadv006!=''?'checked':''); ?>> Sangrado</label><br>
															<label><input type="checkbox" id="frmtraateeftadv" name="frmtraateeftadv007" <?= ($vew_patevlspc->frmtraateeftadv007!=''?'checked':''); ?>> Evento Cardiovascular</label><br>
															<label><input type="checkbox" id="frmtraateeftadv" name="frmtraateeftadv008" <?= ($vew_patevlspc->frmtraateeftadv008!=''?'checked':''); ?>> Dato no disponible</label><br>
															<label><input type="checkbox" id="frmtraateeftadv" name="frmtraateeftadv009" <?= ($vew_patevlspc->frmtraateeftadv009!=''?'checked':''); ?>> Otro</label><br>
														</div>
													</div>
													<div id="frmtraateeftadvdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Indique</label>
															<div class="col-sm-8"><?= gethtml('frmtraateeftadvotr','doccmt1x50',$vew_patevlspc->frmtraateeftadvotr, $lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">irAEs<br><small>eventos adversos inmunomediados</small></label>
														<div class="col-sm-8">
															<label><input type="checkbox" id="frmtraateiraeftadv" name="frmtraateiraeftadv001" <?= ($vew_patevlspc->frmtraateiraeftadv001!=''?'checked':''); ?>> Hepatitis</label><br>
															<label><input type="checkbox" id="frmtraateiraeftadv" name="frmtraateiraeftadv002" <?= ($vew_patevlspc->frmtraateiraeftadv002!=''?'checked':''); ?>> Aumento de bilirrubina</label><br>
															<label><input type="checkbox" id="frmtraateiraeftadv" name="frmtraateiraeftadv003" <?= ($vew_patevlspc->frmtraateiraeftadv003!=''?'checked':''); ?>> Hipo/hipertiroidismo</label><br>
															<label><input type="checkbox" id="frmtraateiraeftadv" name="frmtraateiraeftadv004" <?= ($vew_patevlspc->frmtraateiraeftadv004!=''?'checked':''); ?>> Hipofisitis</label><br>
															<label><input type="checkbox" id="frmtraateiraeftadv" name="frmtraateiraeftadv005" <?= ($vew_patevlspc->frmtraateiraeftadv005!=''?'checked':''); ?>> Adrenalitis</label><br>
															<label><input type="checkbox" id="frmtraateiraeftadv" name="frmtraateiraeftadv006" <?= ($vew_patevlspc->frmtraateiraeftadv006!=''?'checked':''); ?>> DBT</label><br>
															<label><input type="checkbox" id="frmtraateiraeftadv" name="frmtraateiraeftadv007" <?= ($vew_patevlspc->frmtraateiraeftadv007!=''?'checked':''); ?>> Neumonitis</label><br>
															<label><input type="checkbox" id="frmtraateiraeftadv" name="frmtraateiraeftadv008" <?= ($vew_patevlspc->frmtraateiraeftadv008!=''?'checked':''); ?>> Diarrea o colitis</label><br>
															<label><input type="checkbox" id="frmtraateiraeftadv" name="frmtraateiraeftadv009" <?= ($vew_patevlspc->frmtraateiraeftadv009!=''?'checked':''); ?>> Nefritis</label><br>
															<label><input type="checkbox" id="frmtraateiraeftadv" name="frmtraateiraeftadv010" <?= ($vew_patevlspc->frmtraateiraeftadv010!=''?'checked':''); ?>> Miositis</label><br>
															<label><input type="checkbox" id="frmtraateiraeftadv" name="frmtraateiraeftadv011" <?= ($vew_patevlspc->frmtraateiraeftadv011!=''?'checked':''); ?>> Miocarditis</label><br>
															<label><input type="checkbox" id="frmtraateiraeftadv" name="frmtraateiraeftadv012" <?= ($vew_patevlspc->frmtraateiraeftadv012!=''?'checked':''); ?>> SNC o perif&eacute;rico</label><br>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha del Primer irAE</label>
														<div class="col-sm-8"><?= gethtml('frmtraateiradte','docdte',$vew_patevlspc->frmtraateiradte, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-2 control-label">Tratamiento del irAE</label>
														<div class="col-sm-10"><?= gethtml('frmtraateiratra',array(''=>'','no'=>'No','esteroides_orales'=>'Esteroides orales','esteroides_endovenosos'=>'Esteroides endovenosos','infliximab'=>'Infliximab','otro'=>'Otro'), $vew_patevlspc->frmtraateiratra, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Resoluci&oacute;n del irAE</label>
														<div class="col-sm-6"><?= gethtml('frmtraateirares','yesno',$vew_patevlspc->frmtraateirares, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha de resoluci&oacute;n irAE</label>
														<div class="col-sm-8"><?= gethtml('frmtraateiraresdte','docdte',$vew_patevlspc->frmtraateiraresdte, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Rechallenge de post irAE</label>
														<div class="col-sm-6"><?= gethtml('frmtraateirapos','yesno',$vew_patevlspc->frmtraateirapos, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha reinicio</label>
														<div class="col-sm-8"><?= gethtml('frmtraateiraposdte','docdte',$vew_patevlspc->frmtraateiraposdte, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Recidiva de irAE post re-inicio</label>
														<div class="col-sm-6"><?= gethtml('frmtraateirarec','yesno',$vew_patevlspc->frmtraateirarec, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha de recidiva</label>
														<div class="col-sm-8"><?= gethtml('frmtraateirarecdte','docdte',$vew_patevlspc->frmtraateirarecdte, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha de Discontinuaci&oacute;n permanente de Atezo + Beva</label>
														<div class="col-sm-8"><?= gethtml('frmtraatecncdte','docdte',$vew_patevlspc->frmtraatecncdte, $lv_default); ?></div>
													</div>
													<div id="frmtraatecncdtediv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Motivo de Discontinuaci&oacute;n permanente de Atezo + Beva</label>
															<div class="col-sm-8">
																<label><input type="checkbox" id="frmtraatecncmtv" name="frmtraatecncmtv001" <?= ($vew_patevlspc->frmtraatecncmtv001!=''?'checked':''); ?>> Intolerancia o Efecto Adverso Moderado-Severo</label><br>
																<label><input type="checkbox" id="frmtraatecncmtv" name="frmtraatecncmtv002" <?= ($vew_patevlspc->frmtraatecncmtv002!=''?'checked':''); ?>> Progresion de la Enfermedad Hepatica (>= 2 puntos de score de Child Pugh)</label><br>
																<label><input type="checkbox" id="frmtraatecncmtv" name="frmtraatecncmtv003" <?= ($vew_patevlspc->frmtraatecncmtv003!=''?'checked':''); ?>> Progresion de Enfermedad Tumoral</label><br>
																<div id="frmtraatecncmtv003div">
																	<label class="col-sm-2 control-label">Indique</label>
																	<div class="col-sm-10"><?= gethtml('frmtraatecncmtv003typ',array(''=>'','lesion_intra'=>'Nueva lesi&oacute;n intrahep&aacute;tica','aumento_diam_intra'=>'Aumento del di&aacute;metro de lesi&oacute;n intrahep&aacute;tica','lesion_extra'=>'Nueva lesi&oacute;n extrahep&aacute;tica','aumento_diam_extra'=>'Aumento del di&aacute;metro de la lesi&oacute;n extrahep&aacute;tica','invasion'=>'Invasi&oacute;n vascular'), $vew_patevlspc->frmtraatecncmtv003typ, $lv_default); ?></div>
																</div>
																<label><input type="checkbox" id="frmtraatecncmtv" name="frmtraatecncmtv004" <?= ($vew_patevlspc->frmtraatecncmtv004!=''?'checked':''); ?>> Progresion Sintomatica (ECOG=4)</label><br>
																<label><input type="checkbox" id="frmtraatecncmtv" name="frmtraatecncmtv005" <?= ($vew_patevlspc->frmtraatecncmtv005!=''?'checked':''); ?>> Otro</label><br>
															</div>
														</div>
														<div id="frmtraatecncmtvdiv">
															<div class="form-group tmss-form-group">
																<label class="col-sm-4 control-label">Indique</label>
																<div class="col-sm-8"><?= gethtml('frmtraatecncmtvotr','doccmt1x50',$vew_patevlspc->frmtraatecncmtvotr, $lv_default); ?></div>
															</div>
														</div>
													</div>
												</td></tr>
											</table>
										</div>
									</div>
								</td></tr>


								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Otros Tratamientos</label>
										<div class="col-sm-6"><?= gethtml('frmtraotrtra','yesno',$vew_patevlspc->frmtraotrtra, $lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtraotrtradiv">
										<div class="col-sm-3"></div>
										<div class="col-sm-9">
											<table class="table table-striped table-condensed table-bordered">
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Otros Tratamientos</label>
														<div class="col-sm-8"><?= gethtml('frmtraotrtratyp',array(''=>'','radioterapia'=>'Radioterapia','quimioterapia'=>'Quimioterapia Sistemica','protocolo'=>'Protocolo Clinico','otro'=>'Otro'),$vew_patevlspc->frmtraotrtratyp,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha</label>
														<div class="col-sm-8"><?= gethtml('frmtraotrtradte','docdte',$vew_patevlspc->frmtraotrtradte, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Estad&iacute;o BCLC previo al tratamiento<br><small>acorde a juicio cl&iacute;nico subjetivo</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraotrtrabcl',array(''=>'','0'=>'0','a'=>'A','b'=>'B','c'=>'C','d'=>'D'),$vew_patevlspc->frmtraotrtrabcl,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica</label>
														<div class="col-sm-8"><?= gethtml('frmtraotrtranumnod','docnum0600',$vew_patevlspc->frmtraotrtranumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">HCC difuso</label>
														<div class="col-sm-8"><?= gethtml('frmtraotrtrahccdif','yesno',$vew_patevlspc->frmtraotrtrahccdif,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraotrtratamnod','docnum0600',$vew_patevlspc->frmtraotrtratamnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraotrtrasumnod','docnum0600',$vew_patevlspc->frmtraotrtrasumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraotrtrainvtum',array(''=>'','no'=>'NO','tronco'=>'Tronco de la Vena Porta','rama_der'=>'Rama derecha Porta','rama_izq'=>'Rama izquierda Porta','cava_inf'=>' Vena Cava inferior','suprahep'=>'Venas suprahep&aacute;ticas','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtraotrtrainvtum,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Enfermedad Extrahep&aacute;tica HCC</label>
														<div class="col-sm-8"><?= gethtml('frmtraotrtraenfext',array(''=>'','no'=>'NO','osea'=>'OSEA','pulmon'=>'PULMON','otra'=>'OTRA','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtraotrtraenfext,$lv_default); ?></div>
													</div>
													<div id="frmtraotrtraenfextdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Cual otra localizaci&oacute;n metast&aacute;sica?</label>
															<div class="col-sm-8"><?= gethtml('frmtraotrtraenfextotr','doccmt1x20',$vew_patevlspc->frmtraotrtraenfextotr,$lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Performance Status ECOG</label>
														<div class="col-sm-8"><?= gethtml('frmtraotrtraecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmtraotrtraecg); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Laboratorio</label>
														<div class="col-sm-9">
															<table class="table table-condensed table-bordered">
																<tbody>
																	<tr>
																		<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtraotrtralabbil','docnum0601',$vew_patevlspc->frmtraotrtralabbil,$lv_default); ?></td>
																		<td>RIN</td>
																		<td><?= gethtml('frmtraotrtralabrin','docnum0601',$vew_patevlspc->frmtraotrtralabrin,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtraotrtralabalb','docnum0601',$vew_patevlspc->frmtraotrtralabalb,$lv_default); ?></td>
																		<td>Encefalopatia Portosistemica</td>
																		<td><?= gethtml('frmtraotrtralabenc',array(''=>'','no'=>'NO','I-II'=>'I-II','III-IV'=>'III-IV'),$vew_patevlspc->frmtraotrtralabenc,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>ASCITIS</td>
																		<td><?= gethtml('frmtraotrtralabasc',array(''=>'','no'=>'NO','leve'=>'LEVE','moderada'=>'MODERADA'),$vew_patevlspc->frmtraotrtralabasc,$lv_default); ?></td>
																		<td>Recuento de Plaquetas<br><small>(en mm3)</small></td>
																		<td><input type="NUMBER" id="frmtraotrtralabrec" name="frmtraotrtralabrec" value="<?= $vew_patevlspc->frmtraotrtralabrec; ?>" maxlength="7" min="10000" max="1000000" step="1" class="form-control"></td>
																	</tr>
																	<tr>
																		<td>AFP al diagnostico<br><small>Alfa-fetoproteina (AFP) en ng/ml</small></td>
																		<td><?= gethtml('frmtraotrtralabafp','docnum0601',$vew_patevlspc->frmtraotrtralabafp,$lv_default); ?></td>
																		<td></td>
																		<td></td>
																	</tr>
																</tbody>
															</table>
														</div>
													</div>
												</td></tr>
											</table>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Soporte Paliativo</label>
										<div class="col-sm-6"><?= gethtml('frmtrasoppal','yesno',$vew_patevlspc->frmtrasoppal,$lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtrasoppaldiv">
										<div class="col-sm-3"></div>
										<div class="col-sm-9">
											<table class="table table-striped table-condensed table-bordered">
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Fecha</label>
														<div class="col-sm-6"><?= gethtml('frmtrasoppaldte','docdte',$vew_patevlspc->frmtrasoppaldte, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Estad&iacute;o BCLC previo al tratamiento<br><small>acorde a juicio cl&iacute;nico subjetivo</small></label>
														<div class="col-sm-8"><?= gethtml('frmtrasoppalbcl',array(''=>'','0'=>'0','a'=>'A','b'=>'B','c'=>'C','d'=>'D'),$vew_patevlspc->frmtrasoppalbcl,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica</label>
														<div class="col-sm-6"><?= gethtml('frmtrasoppalnumnod','docnum0600',$vew_patevlspc->frmtrasoppalnumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">HCC difuso</label>
														<div class="col-sm-6"><?= gethtml('frmtrasoppalhccdif','yesno',$vew_patevlspc->frmtrasoppalhccdif,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtrasoppaltamnod','docnum0600',$vew_patevlspc->frmtrasoppaltamnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtrasoppalsumnod','docnum0600',$vew_patevlspc->frmtrasoppalsumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes</small></label>
														<div class="col-sm-6"><?= gethtml('frmtrasoppalinvtum',array(''=>'','no'=>'NO','tronco'=>'Tronco de la Vena Porta','rama_der'=>'Rama derecha Porta','rama_izq'=>'Rama izquierda Porta','cava_inf'=>' Vena Cava inferior','suprahep'=>'Venas suprahep&aacute;ticas','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtrasoppalinvtum,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Enfermedad Extrahep&aacute;tica HCC</label>
														<div class="col-sm-6"><?= gethtml('frmtrasoppalenfext',array(''=>'','no'=>'NO','osea'=>'OSEA','pulmon'=>'PULMON','otra'=>'OTRA','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtrasoppalenfext,$lv_default); ?></div>
													</div>
													<div id="frmtrasoppalenfextdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-3 control-label">Cual otra localizaci&oacute;n metast&aacute;sica?</label>
															<div class="col-sm-6"><?= gethtml('frmtrasoppalenfextotr','doccmt1x20',$vew_patevlspc->frmtrasoppalenfextotr,$lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Performance Status ECOG</label>
														<div class="col-sm-6"><?= gethtml('frmtrasoppalecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmtrasoppalecg); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Laboratorio</label>
														<div class="col-sm-9">
															<table class="table table-condensed table-bordered">
																<tbody>
																	<tr>
																		<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtrasoppallabbil','docnum0601',$vew_patevlspc->frmtrasoppallabbil,$lv_default); ?></td>
																		<td>RIN</td>
																		<td><?= gethtml('frmtrasoppallabrin','docnum0601',$vew_patevlspc->frmtrasoppallabrin,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtrasoppallabalb','docnum0601',$vew_patevlspc->frmtrasoppallabalb,$lv_default); ?></td>
																		<td>Encefalopatia Portosistemica</td>
																		<td><?= gethtml('frmtrasoppallabenc',array(''=>'','no'=>'NO','I-II'=>'I-II','III-IV'=>'III-IV'),$vew_patevlspc->frmtrasoppallabenc,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>ASCITIS</td>
																		<td><?= gethtml('frmtrasoppallabasc',array(''=>'','no'=>'NO','leve'=>'LEVE','moderada'=>'MODERADA'),$vew_patevlspc->frmtrasoppallabasc,$lv_default); ?></td>
																		<td>Recuento de Plaquetas<br><small>(en mm3)</small></td>
																		<td><input type="NUMBER" id="frmtrasoppallabrec" name="frmtrasoppallabrec" value="<?= $vew_patevlspc->frmtrasoppallabrec; ?>" maxlength="7" min="10000" max="1000000" step="1" class="form-control"></td>
																	</tr>
																	<tr>
																		<td>AFP al diagnostico<br><small>Alfa-fetoproteina (AFP) en ng/ml</small></td>
																		<td><?= gethtml('frmtrasoppallabafp','docnum0601',$vew_patevlspc->frmtrasoppallabafp,$lv_default); ?></td>
																		<td></td>
																		<td></td>
																	</tr>
																</tbody>
															</table>
														</div>
													</div>
												</div>
											</div>
										</td></tr>
									</table>
								</td></tr>
							</tbody>
						</table>
						<br><br>



						<h2 id="tratamiento-02"><span class="fas fa-angle-right"></span> Tratamiento Sist&eacute;mico de Segunda L&iacute;nea</h2><br><br><!-- tra -->



						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Tratamiento Sist&eacute;mico de Segunda L&iacute;nea</label>
										<div class="col-sm-6"><?= gethtml('frmtra2da','yesno',$vew_patevlspc->frmtra2da,$lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtra2dadiv">
										<label class="col-sm-3 control-label">Fecha</label>
										<div class="col-sm-6"><?= gethtml('frmtra2dadte','docdte',$vew_patevlspc->frmtra2dadte,$lv_default); ?></div>
									</div>
								</td></tr>
								
								
								
								
								
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Cabozantinib</label>
										<div class="col-sm-6"><?= gethtml('frmtracab','yesno',$vew_patevlspc->frmtracab, $lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtracabdiv">
										<div class="col-sm-3"></div>
										<div class="col-sm-9">
											<table class="table table-striped table-condensed table-bordered">
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Estad&iacute;o BCLC previo al tratamiento<br><small>acorde a juicio cl&iacute;nico subjetivo</small></label>
														<div class="col-sm-8"><?= gethtml('frmtracabbcl',array(''=>'','0'=>'0','a'=>'A','b'=>'B','c'=>'C','d'=>'D'),$vew_patevlspc->frmtracabbcl,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica</label>
														<div class="col-sm-6"><?= gethtml('frmtracabnumnod','docnum0600',$vew_patevlspc->frmtracabnumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">HCC difuso</label>
														<div class="col-sm-6"><?= gethtml('frmtracabhccdif','yesno',$vew_patevlspc->frmtracabhccdif,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtracabtamnod','docnum0600',$vew_patevlspc->frmtracabtamnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtracabsumnod','docnum0600',$vew_patevlspc->frmtracabsumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes</small></label>
														<div class="col-sm-6"><?= gethtml('frmtracabinvtum',array(''=>'','no'=>'NO','tronco'=>'Tronco de la Vena Porta','rama_der'=>'Rama derecha Porta','rama_izq'=>'Rama izquierda Porta','cava_inf'=>' Vena Cava inferior','suprahep'=>'Venas suprahep&aacute;ticas','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtracabinvtum,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Enfermedad Extrahep&aacute;tica HCC</label>
														<div class="col-sm-6"><?= gethtml('frmtracabenfext',array(''=>'','no'=>'NO','osea'=>'OSEA','pulmon'=>'PULMON','otra'=>'OTRA','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtracabenfext,$lv_default); ?></div>
													</div>
													<div id="frmtracabenfextdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-3 control-label">Cual otra localizaci&oacute;n metast&aacute;sica?</label>
															<div class="col-sm-6"><?= gethtml('frmtracabenfextotr','doccmt1x20',$vew_patevlspc->frmtracabenfextotr,$lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Performance Status ECOG</label>
														<div class="col-sm-6"><?= gethtml('frmtracabecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmtracabecg); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Laboratorio</label>
														<div class="col-sm-9">
															<table class="table table-condensed table-bordered">
																<tbody>
																	<tr>
																		<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtracablabbil','docnum0601',$vew_patevlspc->frmtracablabbil,$lv_default); ?></td>
																		<td>RIN</td>
																		<td><?= gethtml('frmtracablabrin','docnum0601',$vew_patevlspc->frmtracablabrin,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtracablabalb','docnum0601',$vew_patevlspc->frmtracablabalb,$lv_default); ?></td>
																		<td>Encefalopatia Portosistemica</td>
																		<td><?= gethtml('frmtracablabenc',array(''=>'','no'=>'NO','I-II'=>'I-II','III-IV'=>'III-IV'),$vew_patevlspc->frmtracablabenc,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>ASCITIS</td>
																		<td><?= gethtml('frmtracablabasc',array(''=>'','no'=>'NO','leve'=>'LEVE','moderada'=>'MODERADA'),$vew_patevlspc->frmtracablabasc,$lv_default); ?></td>
																		<td>Recuento de Plaquetas<br><small>(en mm3)</small></td>
																		<td><input type="NUMBER" id="frmtracablabrec" name="frmtracablabrec" value="<?= $vew_patevlspc->frmtracablabrec; ?>" maxlength="7" min="10000" max="1000000" step="1" class="form-control"></td>
																	</tr>
																	<tr>
																		<td>AFP al diagnostico<br><small>Alfa-fetoproteina (AFP) en ng/ml</small></td>
																		<td><?= gethtml('frmtracablabafp','docnum0601',$vew_patevlspc->frmtracablabafp,$lv_default); ?></td>
																		<td></td>
																		<td></td>
																	</tr>
																</tbody>
															</table>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha Inicio Cabozantinib</label>
														<div class="col-sm-8"><?= gethtml('frmtracabdte','docdte',$vew_patevlspc->frmtracabdte, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Nombre Comercial</label>
														<div class="col-sm-8"><?= gethtml('frmtracabnomcom',array(''=>'','arkus'=>'ARKUS','otro'=>'Otro'), $vew_patevlspc->frmtracabnomcom, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Cabozantinib: Dosis de Inicio<br><small>en mg</small></label>
														<div class="col-sm-8"><?= gethtml('frmtracabdssini',array(''=>'','20'=>'20 mg dia','40'=>'40 mg dia','60'=>'60 mg dia'), $vew_patevlspc->frmtracabdssini, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Cabozantinib: Dosis M&aacute;xima<br><small>en mg</small></label>
														<div class="col-sm-8"><?= gethtml('frmtracabdssmax',array(''=>'','20'=>'20 mg dia','40'=>'40 mg dia','60'=>'60 mg dia'), $vew_patevlspc->frmtracabdssmax, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Reducci&oacute;n de Dosis de Cabozantinib<br><small>en mg</small></label>
														<div class="col-sm-8"><?= gethtml('frmtracabreddss',array(''=>'','no'=>'No','20'=>'20 mg dia','40'=>'40 mg dia','otro'=>'Otro'), $vew_patevlspc->frmtracabreddss, $lv_default); ?></div>
													</div>
													<div id="frmtracabreddssdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Fecha</label>
															<div class="col-sm-8"><?= gethtml('frmtracabreddssdte','docdte',$vew_patevlspc->frmtracabreddssdte, $lv_default); ?></div>
														</div>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Motivo de Reducci&oacute;n de Dosis de Cabozantinib<br><small>en mg</small></label>
															<div class="col-sm-8"><?= gethtml('frmtracabreddssmtv',array(''=>'','intolerancia'=>'Intolerancia','enf_hepatica'=>'Presencia de Enfermedad Hepatica','sepsis'=>'Sepsis','otro'=>'Otro'), $vew_patevlspc->frmtracabreddssmtv, $lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Severidad efectos adversos<br><small>acorde NCTA 4.0</small></label>
														<div class="col-sm-8"><?= gethtml('frmtracabeftadvsev',array(''=>'','leve'=>'Leve','moderado'=>'Moderado','severo'=>'Severo'), $vew_patevlspc->frmtracabeftadvsev, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Efectos adversos a Cabozantinib</label>
														<div class="col-sm-8">
															<label><input type="checkbox" id="frmtracabeftadv" name="frmtracabeftadv001" <?= ($vew_patevlspc->frmtracabeftadv001!=''?'checked':''); ?>> Fatiga</label><br>
															<label><input type="checkbox" id="frmtracabeftadv" name="frmtracabeftadv002" <?= ($vew_patevlspc->frmtracabeftadv002!=''?'checked':''); ?>> Diarrea</label><br>
															<label><input type="checkbox" id="frmtracabeftadv" name="frmtracabeftadv003" <?= ($vew_patevlspc->frmtracabeftadv003!=''?'checked':''); ?>> Rash</label><br>
															<label><input type="checkbox" id="frmtracabeftadv" name="frmtracabeftadv004" <?= ($vew_patevlspc->frmtracabeftadv004!=''?'checked':''); ?>> Sindrome de Mano-Pie</label><br>
															<label><input type="checkbox" id="frmtracabeftadv" name="frmtracabeftadv005" <?= ($vew_patevlspc->frmtracabeftadv005!=''?'checked':''); ?>> Hipertension Arterial</label><br>
															<label><input type="checkbox" id="frmtracabeftadv" name="frmtracabeftadv006" <?= ($vew_patevlspc->frmtracabeftadv006!=''?'checked':''); ?>> Sangrado</label><br>
															<label><input type="checkbox" id="frmtracabeftadv" name="frmtracabeftadv007" <?= ($vew_patevlspc->frmtracabeftadv007!=''?'checked':''); ?>> Evento Cardiovascular</label><br>
															<label><input type="checkbox" id="frmtracabeftadv" name="frmtracabeftadv008" <?= ($vew_patevlspc->frmtracabeftadv008!=''?'checked':''); ?>> Proteinuria</label><br>
															<label><input type="checkbox" id="frmtracabeftadv" name="frmtracabeftadv009" <?= ($vew_patevlspc->frmtracabeftadv009!=''?'checked':''); ?>> Prolongaci&oacute;n del QTc</label><br>
															<label><input type="checkbox" id="frmtracabeftadv" name="frmtracabeftadv010" <?= ($vew_patevlspc->frmtracabeftadv010!=''?'checked':''); ?>> Hematologico (anemia u otras citopenias)</label><br>
															<label><input type="checkbox" id="frmtracabeftadv" name="frmtracabeftadv011" <?= ($vew_patevlspc->frmtracabeftadv011!=''?'checked':''); ?>> Dato no disponible</label><br>
															<label><input type="checkbox" id="frmtracabeftadv" name="frmtracabeftadv012" <?= ($vew_patevlspc->frmtracabeftadv012!=''?'checked':''); ?>> Otro</label><br>
														</div>
													</div>
													<div id="frmtracabeftadvdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Indique</label>
															<div class="col-sm-8"><?= gethtml('frmtracabeftadvotr','doccmt1x50',$vew_patevlspc->frmtracabeftadvotr, $lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha de Discontinuaci&oacute;n permanente de Cabozantinib</label>
														<div class="col-sm-8"><?= gethtml('frmtracabcncdte','docdte',$vew_patevlspc->frmtracabcncdte, $lv_default); ?></div>
													</div>
													<div id="frmtracabcncdtediv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Motivo de Discontinuaci&oacute;n permanente de Cabozantinib</label>
															<div class="col-sm-8">
																<label><input type="checkbox" id="frmtracabcncmtv" name="frmtracabcncmtv001" <?= ($vew_patevlspc->frmtracabcncmtv001!=''?'checked':''); ?>> Intolerancia o Efecto Adverso Moderado-Severo</label><br>
																<label><input type="checkbox" id="frmtracabcncmtv" name="frmtracabcncmtv002" <?= ($vew_patevlspc->frmtracabcncmtv002!=''?'checked':''); ?>> Progresion de la Enfermedad Hepatica (>= 2 puntos de score de Child Pugh)</label><br>
																<label><input type="checkbox" id="frmtracabcncmtv" name="frmtracabcncmtv003" <?= ($vew_patevlspc->frmtracabcncmtv003!=''?'checked':''); ?>> Progresion de Enfermedad Tumoral</label><br>
																<div id="frmtracabcncmtv003div">
																	<label class="col-sm-2 control-label">Indique</label>
																	<div class="col-sm-10"><?= gethtml('frmtracabcncmtv003typ',array(''=>'','lesion_intra'=>'Nueva lesi&oacute;n intrahep&aacute;tica','aumento_diam_intra'=>'Aumento del di&aacute;metro de lesi&oacute;n intrahep&aacute;tica','lesion_extra'=>'Nueva lesi&oacute;n extrahep&aacute;tica','aumento_diam_extra'=>'Aumento del di&aacute;metro de la lesi&oacute;n extrahep&aacute;tica','invasion'=>'Invasi&oacute;n vascular'), $vew_patevlspc->frmtracabcncmtv003typ, $lv_default); ?></div>
																</div>
																<label><input type="checkbox" id="frmtracabcncmtv" name="frmtracabcncmtv004" <?= ($vew_patevlspc->frmtracabcncmtv004!=''?'checked':''); ?>> Progresion Sintomatica (ECOG=4)</label><br>
																<label><input type="checkbox" id="frmtracabcncmtv" name="frmtracabcncmtv005" <?= ($vew_patevlspc->frmtracabcncmtv005!=''?'checked':''); ?>> Otro</label><br>
															</div>
														</div>
														<div id="frmtracabcncmtvdiv">
															<div class="form-group tmss-form-group">
																<label class="col-sm-4 control-label">Indique</label>
																<div class="col-sm-8"><?= gethtml('frmtracabcncmtvotr','doccmt1x50',$vew_patevlspc->frmtracabcncmtvotr, $lv_default); ?></div>
															</div>
														</div>
													</div>
												</td></tr>
											</table>
										</div>
									</div>
								</td></tr>
								
								
								
								
								
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Regorafenib</label>
										<div class="col-sm-6"><?= gethtml('frmtrareg','yesno',$vew_patevlspc->frmtrareg, $lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtraregdiv">
										<div class="col-sm-3"></div>
										<div class="col-sm-9">
											<table class="table table-striped table-condensed table-bordered">
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Estad&iacute;o BCLC previo al tratamiento<br><small>acorde a juicio cl&iacute;nico subjetivo</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraregbcl',array(''=>'','0'=>'0','a'=>'A','b'=>'B','c'=>'C','d'=>'D'),$vew_patevlspc->frmtraregbcl,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica</label>
														<div class="col-sm-6"><?= gethtml('frmtraregnumnod','docnum0600',$vew_patevlspc->frmtraregnumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">HCC difuso</label>
														<div class="col-sm-6"><?= gethtml('frmtrareghccdif','yesno',$vew_patevlspc->frmtrareghccdif,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraregtamnod','docnum0600',$vew_patevlspc->frmtraregtamnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtraregsumnod','docnum0600',$vew_patevlspc->frmtraregsumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes</small></label>
														<div class="col-sm-6"><?= gethtml('frmtrareginvtum',array(''=>'','no'=>'NO','tronco'=>'Tronco de la Vena Porta','rama_der'=>'Rama derecha Porta','rama_izq'=>'Rama izquierda Porta','cava_inf'=>' Vena Cava inferior','suprahep'=>'Venas suprahep&aacute;ticas','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtrareginvtum,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Enfermedad Extrahep&aacute;tica HCC</label>
														<div class="col-sm-6"><?= gethtml('frmtraregenfext',array(''=>'','no'=>'NO','osea'=>'OSEA','pulmon'=>'PULMON','otra'=>'OTRA','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtraregenfext,$lv_default); ?></div>
													</div>
													<div id="frmtraregenfextdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-3 control-label">Cual otra localizaci&oacute;n metast&aacute;sica?</label>
															<div class="col-sm-6"><?= gethtml('frmtraregenfextotr','doccmt1x20',$vew_patevlspc->frmtraregenfextotr,$lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Performance Status ECOG</label>
														<div class="col-sm-6"><?= gethtml('frmtraregecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmtraregecg); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Laboratorio</label>
														<div class="col-sm-9">
															<table class="table table-condensed table-bordered">
																<tbody>
																	<tr>
																		<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtrareglabbil','docnum0601',$vew_patevlspc->frmtrareglabbil,$lv_default); ?></td>
																		<td>RIN</td>
																		<td><?= gethtml('frmtrareglabrin','docnum0601',$vew_patevlspc->frmtrareglabrin,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtrareglabalb','docnum0601',$vew_patevlspc->frmtrareglabalb,$lv_default); ?></td>
																		<td>Encefalopatia Portosistemica</td>
																		<td><?= gethtml('frmtrareglabenc',array(''=>'','no'=>'NO','I-II'=>'I-II','III-IV'=>'III-IV'),$vew_patevlspc->frmtrareglabenc,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>ASCITIS</td>
																		<td><?= gethtml('frmtrareglabasc',array(''=>'','no'=>'NO','leve'=>'LEVE','moderada'=>'MODERADA'),$vew_patevlspc->frmtrareglabasc,$lv_default); ?></td>
																		<td>Recuento de Plaquetas<br><small>(en mm3)</small></td>
																		<td><input type="NUMBER" id="frmtrareglabrec" name="frmtrareglabrec" value="<?= $vew_patevlspc->frmtrareglabrec; ?>" maxlength="7" min="10000" max="1000000" step="1" class="form-control"></td>
																	</tr>
																	<tr>
																		<td>AFP al diagnostico<br><small>Alfa-fetoproteina (AFP) en ng/ml</small></td>
																		<td><?= gethtml('frmtrareglabafp','docnum0601',$vew_patevlspc->frmtrareglabafp,$lv_default); ?></td>
																		<td></td>
																		<td></td>
																	</tr>
																</tbody>
															</table>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha Inicio Regorafenib</label>
														<div class="col-sm-8"><?= gethtml('frmtraregdte','docdte',$vew_patevlspc->frmtraregdte, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Regorafenib: Dosis de Inicio<br><small>en mg</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraregdssini',array(''=>'','40'=>'40 mg dia','80'=>'80 mg dia','120'=>'120 mg dia','160'=>'160 mg dia','no_disponible'=>'Dato no disponible'), $vew_patevlspc->frmtraregdssini, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Regorafenib: Dosis M&aacute;xima<br><small>en mg</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraregdssmax',array(''=>'','40'=>'40 mg dia','80'=>'80 mg dia','120'=>'120 mg dia','160'=>'160 mg dia','no_dispnible'=>'Dato no disponible'), $vew_patevlspc->frmtraregdssmax, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Reducci&oacute;n de Dosis de Regorafenib<br><small>en mg</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraregreddss',array(''=>'','no'=>'No','120'=>'120 mg dia','80'=>'80 mg dia','60'=>'60 mg dia','otro'=>'Otro','no_disponible'=>'Dato no disponible'), $vew_patevlspc->frmtraregreddss, $lv_default); ?></div>
													</div>
													<div id="frmtraregreddssdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Fecha</label>
															<div class="col-sm-8"><?= gethtml('frmtraregreddssdte','docdte',$vew_patevlspc->frmtraregreddssdte, $lv_default); ?></div>
														</div>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Motivo de Reducci&oacute;n de Dosis de Regorafenib<br><small>en mg</small></label>
															<div class="col-sm-8"><?= gethtml('frmtraregreddssmtv',array(''=>'','intolerancia'=>'Intolerancia','enf_hepatica'=>'Presencia de Enfermedad Hepatica','sepsis'=>'Sepsis','otro'=>'Otro'), $vew_patevlspc->frmtraregreddssmtv, $lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Severidad efectos adversos<br><small>acorde NCTA 4.0</small></label>
														<div class="col-sm-8"><?= gethtml('frmtraregeftadvsev',array(''=>'','leve'=>'Leve','moderado'=>'Moderado','severo'=>'Severo'), $vew_patevlspc->frmtraregeftadvsev, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Efectos adversos a Regorafenib</label>
														<div class="col-sm-8">
															<label><input type="checkbox" id="frmtraregeftadv" name="frmtraregeftadv001" <?= ($vew_patevlspc->frmtraregeftadv001!=''?'checked':''); ?>> Fatiga</label><br>
															<label><input type="checkbox" id="frmtraregeftadv" name="frmtraregeftadv002" <?= ($vew_patevlspc->frmtraregeftadv002!=''?'checked':''); ?>> Diarrea</label><br>
															<label><input type="checkbox" id="frmtraregeftadv" name="frmtraregeftadv003" <?= ($vew_patevlspc->frmtraregeftadv003!=''?'checked':''); ?>> Rash</label><br>
															<label><input type="checkbox" id="frmtraregeftadv" name="frmtraregeftadv004" <?= ($vew_patevlspc->frmtraregeftadv004!=''?'checked':''); ?>> Sindrome de Mano-Pie</label><br>
															<label><input type="checkbox" id="frmtraregeftadv" name="frmtraregeftadv005" <?= ($vew_patevlspc->frmtraregeftadv005!=''?'checked':''); ?>> Hipertension Arterial</label><br>
															<label><input type="checkbox" id="frmtraregeftadv" name="frmtraregeftadv006" <?= ($vew_patevlspc->frmtraregeftadv006!=''?'checked':''); ?>> Sangrado</label><br>
															<label><input type="checkbox" id="frmtraregeftadv" name="frmtraregeftadv007" <?= ($vew_patevlspc->frmtraregeftadv007!=''?'checked':''); ?>> Evento Cardiovascular</label><br>
															<label><input type="checkbox" id="frmtraregeftadv" name="frmtraregeftadv008" <?= ($vew_patevlspc->frmtraregeftadv008!=''?'checked':''); ?>> Dato no disponible</label><br>
															<label><input type="checkbox" id="frmtraregeftadv" name="frmtraregeftadv009" <?= ($vew_patevlspc->frmtraregeftadv009!=''?'checked':''); ?>> Otro</label><br>
														</div>
													</div>
													<div id="frmtraregeftadvdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Indique</label>
															<div class="col-sm-8"><?= gethtml('frmtraregeftadvotr','doccmt1x50',$vew_patevlspc->frmtraregeftadvotr, $lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha de Discontinuaci&oacute;n permanente de Regorafenib</label>
														<div class="col-sm-8"><?= gethtml('frmtraregcncdte','docdte',$vew_patevlspc->frmtraregcncdte, $lv_default); ?></div>
													</div>
													<div id="frmtraregcncdtediv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Motivo de Discontinuaci&oacute;n permanente de Regorafenib</label>
															<div class="col-sm-8">
																<label><input type="checkbox" id="frmtraregcncmtv" name="frmtraregcncmtv001" <?= ($vew_patevlspc->frmtraregcncmtv001!=''?'checked':''); ?>> Intolerancia o Efecto Adverso Moderado-Severo</label><br>
																<label><input type="checkbox" id="frmtraregcncmtv" name="frmtraregcncmtv002" <?= ($vew_patevlspc->frmtraregcncmtv002!=''?'checked':''); ?>> Progresion de la Enfermedad Hepatica (>= 2 puntos de score de Child Pugh)</label><br>
																<label><input type="checkbox" id="frmtraregcncmtv" name="frmtraregcncmtv003" <?= ($vew_patevlspc->frmtraregcncmtv003!=''?'checked':''); ?>> Progresion de Enfermedad Tumoral</label><br>
																<div id="frmtraregcncmtv003div">
																	<label class="col-sm-2 control-label">Indique</label>
																	<div class="col-sm-10"><?= gethtml('frmtraregcncmtv003typ',array(''=>'','lesion_intra'=>'Nueva lesi&oacute;n intrahep&aacute;tica','aumento_diam_intra'=>'Aumento del di&aacute;metro de lesi&oacute;n intrahep&aacute;tica','lesion_extra'=>'Nueva lesi&oacute;n extrahep&aacute;tica','aumento_diam_extra'=>'Aumento del di&aacute;metro de la lesi&oacute;n extrahep&aacute;tica','invasion'=>'Invasi&oacute;n vascular'), $vew_patevlspc->frmtraregcncmtv003typ, $lv_default); ?></div>
																</div>
																<label><input type="checkbox" id="frmtraregcncmtv" name="frmtraregcncmtv004" <?= ($vew_patevlspc->frmtraregcncmtv004!=''?'checked':''); ?>> Progresion Sintomatica (ECOG=4)</label><br>
																<label><input type="checkbox" id="frmtraregcncmtv" name="frmtraregcncmtv005" <?= ($vew_patevlspc->frmtraregcncmtv005!=''?'checked':''); ?>> Otro</label><br>
															</div>
														</div>
														<div id="frmtraregcncmtvdiv">
															<div class="form-group tmss-form-group">
																<label class="col-sm-4 control-label">Indique</label>
																<div class="col-sm-8"><?= gethtml('frmtraregcncmtvotr','doccmt1x50',$vew_patevlspc->frmtraregcncmtvotr, $lv_default); ?></div>
															</div>
														</div>
													</div>
												</td></tr>
											</table>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Inmunoterapia</label>
										<div class="col-sm-6"><?= gethtml('frmtrainm','yesno',$vew_patevlspc->frmtrainm,$lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtrainmdiv">
										<div class="col-sm-3"></div>
										<div class="col-sm-9">
											<table class="table table-striped table-condensed table-bordered">
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Tratamiento</label>
														<div class="col-sm-8"><?= gethtml('frmtrainmtra',array(''=>'','nivolumab'=>'Nivolumab','tremelimumab'=>'Tremelimumab','pembrolizumab'=>'Pembrolizumab'),$vew_patevlspc->frmtrainmtra,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha</label>
														<div class="col-sm-8"><?= gethtml('frmtrainmdte','docdte',$vew_patevlspc->frmtrainmdte,$lv_default); ?></div>
													</div>
												</tr></td>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Estad&iacute;o BCLC previo al tratamiento<br><small>acorde a juicio cl&iacute;nico subjetivo</small></label>
														<div class="col-sm-8"><?= gethtml('frmtrainmbcl',array(''=>'','0'=>'0','a'=>'A','b'=>'B','c'=>'C','d'=>'D'),$vew_patevlspc->frmtrainmbcl,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica</label>
														<div class="col-sm-8"><?= gethtml('frmtrainmnumnod','docnum0600',$vew_patevlspc->frmtrainmnumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">HCC difuso</label>
														<div class="col-sm-8"><?= gethtml('frmtrainmhccdif','yesno',$vew_patevlspc->frmtrainmhccdif,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-8"><?= gethtml('frmtrainmtamnod','docnum0600',$vew_patevlspc->frmtrainmtamnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-8"><?= gethtml('frmtrainmsumnod','docnum0600',$vew_patevlspc->frmtrainmsumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes</small></label>
														<div class="col-sm-8"><?= gethtml('frmtrainminvtum',array(''=>'','no'=>'NO','tronco'=>'Tronco de la Vena Porta','rama_der'=>'Rama derecha Porta','rama_izq'=>'Rama izquierda Porta','cava_inf'=>' Vena Cava inferior','suprahep'=>'Venas suprahep&aacute;ticas','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtrainminvtum,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Enfermedad Extrahep&aacute;tica HCC</label>
														<div class="col-sm-8"><?= gethtml('frmtrainmenfext',array(''=>'','no'=>'NO','osea'=>'OSEA','pulmon'=>'PULMON','otra'=>'OTRA','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtrainmenfext,$lv_default); ?></div>
													</div>
													<div id="frmtrainmenfextdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Cual otra localizaci&oacute;n metast&aacute;sica?</label>
															<div class="col-sm-8"><?= gethtml('frmtrainmenfextotr','doccmt1x20',$vew_patevlspc->frmtrainmenfextotr,$lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Performance Status ECOG</label>
														<div class="col-sm-8"><?= gethtml('frmtrainmecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmtrainmecg); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Laboratorio</label>
														<div class="col-sm-9">
															<table class="table table-condensed table-bordered">
																<tbody>
																	<tr>
																		<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtrainmlabbil','docnum0601',$vew_patevlspc->frmtrainmlabbil,$lv_default); ?></td>
																		<td>RIN</td>
																		<td><?= gethtml('frmtrainmlabrin','docnum0601',$vew_patevlspc->frmtrainmlabrin,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtrainmlabalb','docnum0601',$vew_patevlspc->frmtrainmlabalb,$lv_default); ?></td>
																		<td>Encefalopatia Portosistemica</td>
																		<td><?= gethtml('frmtrainmlabenc',array(''=>'','no'=>'NO','I-II'=>'I-II','III-IV'=>'III-IV'),$vew_patevlspc->frmtrainmlabenc,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>ASCITIS</td>
																		<td><?= gethtml('frmtrainmlabasc',array(''=>'','no'=>'NO','leve'=>'LEVE','moderada'=>'MODERADA'),$vew_patevlspc->frmtrainmlabasc,$lv_default); ?></td>
																		<td>Recuento de Plaquetas<br><small>(en mm3)</small></td>
																		<td><input type="NUMBER" id="frmtrainmlabrec" name="frmtrainmlabrec" value="<?= $vew_patevlspc->frmtrainmlabrec; ?>" maxlength="7" min="10000" max="1000000" step="1" class="form-control"></td>
																	</tr>
																	<tr>
																		<td>AFP al diagnostico<br><small>Alfa-fetoproteina (AFP) en ng/ml</small></td>
																		<td><?= gethtml('frmtrainmlabafp','docnum0601',$vew_patevlspc->frmtrainmlabafp,$lv_default); ?></td>
																		<td></td>
																		<td></td>
																	</tr>
																</tbody>
															</table>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha Inicio</label>
														<div class="col-sm-8"><?= gethtml('frmtrainminidte','docdte',$vew_patevlspc->frmtrainminidte, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">N&uacute;mero de ciclos de Inicio</label>
														<div class="col-sm-8"><?= gethtml('frmtrainmdssini','doccmt1x50', $vew_patevlspc->frmtrainmdssini, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">N&uacute;mero de ciclos M&aacute;xima</label>
														<div class="col-sm-8"><?= gethtml('frmtrainmdssmax','doccmt1x50', $vew_patevlspc->frmtrainmdssmax, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Reducci&oacute;n de n&uacute;mero de ciclos</label>
														<div class="col-sm-8"><?= gethtml('frmtrainmreddss','doccmt1x50', $vew_patevlspc->frmtrainmreddss, $lv_default); ?></div>
													</div>
													<div id="frmtrainmreddssdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Fecha</label>
															<div class="col-sm-8"><?= gethtml('frmtrainmreddssdte','docdte',$vew_patevlspc->frmtrainmreddssdte, $lv_default); ?></div>
														</div>
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Motivo de Reducci&oacute;n de n&uacute;mero de ciclos</label>
															<div class="col-sm-8"><?= gethtml('frmtrainmreddssmtv',array(''=>'','intolerancia'=>'Intolerancia','enf_hepatica'=>'Presencia de Enfermedad Hepatica','sepsis'=>'Sepsis','otro'=>'Otro'), $vew_patevlspc->frmtrainmreddssmtv, $lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Severidad efectos adversos<br><small>acorde NCTA 4.0</small></label>
														<div class="col-sm-8"><?= gethtml('frmtrainmeftadvsev',array(''=>'','leve'=>'Leve','moderado'=>'Moderado','severo'=>'Severo'), $vew_patevlspc->frmtrainmeftadvsev, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Efectos adversos</label>
														<div class="col-sm-8">
															<label><input type="checkbox" id="frmtrainmeftadv" name="frmtrainmeftadv001" <?= ($vew_patevlspc->frmtrainmeftadv001!=''?'checked':''); ?>> Fatiga</label><br>
															<label><input type="checkbox" id="frmtrainmeftadv" name="frmtrainmeftadv002" <?= ($vew_patevlspc->frmtrainmeftadv002!=''?'checked':''); ?>> Colitis autoinmune</label><br>
															<label><input type="checkbox" id="frmtrainmeftadv" name="frmtrainmeftadv003" <?= ($vew_patevlspc->frmtrainmeftadv003!=''?'checked':''); ?>> Dermatitis autoinmune</label><br>
															<label><input type="checkbox" id="frmtrainmeftadv" name="frmtrainmeftadv004" <?= ($vew_patevlspc->frmtrainmeftadv004!=''?'checked':''); ?>> Hepatitis autoinmune</label><br>
															<label><input type="checkbox" id="frmtrainmeftadv" name="frmtrainmeftadv005" <?= ($vew_patevlspc->frmtrainmeftadv005!=''?'checked':''); ?>> Tiroiditis autoinmune</label><br>
															<label><input type="checkbox" id="frmtrainmeftadv" name="frmtrainmeftadv006" <?= ($vew_patevlspc->frmtrainmeftadv006!=''?'checked':''); ?>> Adrenalitis autoinmune</label><br>
															<label><input type="checkbox" id="frmtrainmeftadv" name="frmtrainmeftadv007" <?= ($vew_patevlspc->frmtrainmeftadv007!=''?'checked':''); ?>> Hipofisitis autoinmune</label><br>
															<label><input type="checkbox" id="frmtrainmeftadv" name="frmtrainmeftadv008" <?= ($vew_patevlspc->frmtrainmeftadv008!=''?'checked':''); ?>> Nuemonitis autoinmune</label><br>
															<label><input type="checkbox" id="frmtrainmeftadv" name="frmtrainmeftadv009" <?= ($vew_patevlspc->frmtrainmeftadv009!=''?'checked':''); ?>> Cardiopatia inmunologica</label><br>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Requerimiento de corticoides</label>
														<div class="col-sm-8"><?= gethtml('frmtrainmeftadvcor','yesno', $vew_patevlspc->frmtrainmeftadvcor, $lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Fecha de Discontinuaci&oacute;n permanente</label>
														<div class="col-sm-8"><?= gethtml('frmtrainmcncdte','docdte',$vew_patevlspc->frmtrainmcncdte, $lv_default); ?></div>
													</div>
													<div id="frmtrainmcncdtediv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-4 control-label">Motivo de Discontinuaci&oacute;n permanente</label>
															<div class="col-sm-8">
																<label><input type="checkbox" id="frmtrainmcncmtv" name="frmtrainmcncmtv001" <?= ($vew_patevlspc->frmtrainmcncmtv001!=''?'checked':''); ?>> Intolerancia o Efecto Adverso Moderado-Severo</label><br>
																<label><input type="checkbox" id="frmtrainmcncmtv" name="frmtrainmcncmtv002" <?= ($vew_patevlspc->frmtrainmcncmtv002!=''?'checked':''); ?>> Progresion de la Enfermedad Hepatica (>= 2 puntos de score de Child Pugh)</label><br>
																<label><input type="checkbox" id="frmtrainmcncmtv" name="frmtrainmcncmtv003" <?= ($vew_patevlspc->frmtrainmcncmtv003!=''?'checked':''); ?>> Progresion de Enfermedad Tumoral</label><br>
																<div id="frmtrainmcncmtv003div">
																	<label class="col-sm-2 control-label">Indique</label>
																	<div class="col-sm-10"><?= gethtml('frmtrainmcncmtv003typ',array(''=>'','lesion_intra'=>'Nueva lesi&oacute;n intrahep&aacute;tica','aumento_diam_intra'=>'Aumento del di&aacute;metro de lesi&oacute;n intrahep&aacute;tica','lesion_extra'=>'Nueva lesi&oacute;n extrahep&aacute;tica','aumento_diam_extra'=>'Aumento del di&aacute;metro de la lesi&oacute;n extrahep&aacute;tica','invasion'=>'Invasi&oacute;n vascular'), $vew_patevlspc->frmtrainmcncmtv003typ, $lv_default); ?></div>
																</div>
																<label><input type="checkbox" id="frmtrainmcncmtv" name="frmtrainmcncmtv004" <?= ($vew_patevlspc->frmtrainmcncmtv004!=''?'checked':''); ?>> Progresion Sintomatica (ECOG=4)</label><br>
																<label><input type="checkbox" id="frmtrainmcncmtv" name="frmtrainmcncmtv005" <?= ($vew_patevlspc->frmtrainmcncmtv005!=''?'checked':''); ?>> Otro</label><br>
															</div>
														</div>
														<div id="frmtrainmcncmtvdiv">
															<div class="form-group tmss-form-group">
																<label class="col-sm-4 control-label">Indique</label>
																<div class="col-sm-8"><?= gethtml('frmtrainmcncmtvotr','doccmt1x50',$vew_patevlspc->frmtrainmcncmtvotr, $lv_default); ?></div>
															</div>
														</div>
													</div>
												</td></tr>



											</table>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Otro</label>
										<div class="col-sm-6"><?= gethtml('frmtra2daotr','yesno',$vew_patevlspc->frmtra2daotr,$lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtra2daotrdiv">
										<div class="col-sm-3"></div>
										<div class="col-sm-9">
											<table class="table table-striped table-condensed table-bordered">
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Indique</label>
														<div class="col-sm-6"><?= gethtml('frmtra2daotrmtv','doccmt1x20',$vew_patevlspc->frmtra2daotrmtv,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Fecha</label>
														<div class="col-sm-6"><?= gethtml('frmtra2daotrdte','docdte',$vew_patevlspc->frmtra2daotrdte,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-4 control-label">Estad&iacute;o BCLC previo al tratamiento<br><small>acorde a juicio cl&iacute;nico subjetivo</small></label>
														<div class="col-sm-8"><?= gethtml('frmtra2daotrbcl',array(''=>'','0'=>'0','a'=>'A','b'=>'B','c'=>'C','d'=>'D'),$vew_patevlspc->frmtra2daotrbcl,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">N&uacute;mero de N&oacute;dulos de HCC en TAC o RMN din&aacute;mica</label>
														<div class="col-sm-6"><?= gethtml('frmtra2daotrnumnod','docnum0600',$vew_patevlspc->frmtra2daotrnumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">HCC difuso</label>
														<div class="col-sm-6"><?= gethtml('frmtra2daotrhccdif','yesno',$vew_patevlspc->frmtra2daotrhccdif,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Tama&ntilde;o de Nodulo MAYOR de HCC en TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtra2daotrtamnod','docnum0600',$vew_patevlspc->frmtra2daotrtamnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Suma de diametros de todos los n&oacute;dulos de HCC por TAC o RMN<br><small>Indicar en mm</small></label>
														<div class="col-sm-6"><?= gethtml('frmtra2daotrsumnod','docnum0600',$vew_patevlspc->frmtra2daotrsumnod,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Invasi&oacute;n tumoral macrovascular<br><small>Diagnostico por imagenes</small></label>
														<div class="col-sm-6"><?= gethtml('frmtra2daotrinvtum',array(''=>'','no'=>'NO','tronco'=>'Tronco de la Vena Porta','rama_der'=>'Rama derecha Porta','rama_izq'=>'Rama izquierda Porta','cava_inf'=>' Vena Cava inferior','suprahep'=>'Venas suprahep&aacute;ticas','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtra2daotrinvtum,$lv_default); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Enfermedad Extrahep&aacute;tica HCC</label>
														<div class="col-sm-6"><?= gethtml('frmtra2daotrenfext',array(''=>'','no'=>'NO','osea'=>'OSEA','pulmon'=>'PULMON','otra'=>'OTRA','no_evaluado'=>'No evaluado o conocido'),$vew_patevlspc->frmtra2daotrenfext,$lv_default); ?></div>
													</div>
													<div id="frmtra2daotrenfextdiv">
														<div class="form-group tmss-form-group">
															<label class="col-sm-3 control-label">Cual otra localizaci&oacute;n metast&aacute;sica?</label>
															<div class="col-sm-6"><?= gethtml('frmtra2daotrenfextotr','doccmt1x20',$vew_patevlspc->frmtra2daotrenfextotr,$lv_default); ?></div>
														</div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Performance Status ECOG</label>
														<div class="col-sm-6"><?= gethtml('frmtra2daotrecg', array(''=>'','ecog0'=>'ECOG 0','ecog1'=>'ECOG 1','ecog2'=>'ECOG 2','ecog3'=>'ECOG 3','ecog4'=>'ECOG 4'), $vew_patevlspc->frmtra2daotrecg); ?></div>
													</div>
												</td></tr>
												<tr><td>
													<div class="form-group tmss-form-group">
														<label class="col-sm-3 control-label">Laboratorio</label>
														<div class="col-sm-9">
															<table class="table table-condensed table-bordered">
																<tbody>
																	<tr>
																		<td>Bilirrubina Total<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtra2daotrlabbil','docnum0601',$vew_patevlspc->frmtra2daotrlabbil,$lv_default); ?></td>
																		<td>RIN</td>
																		<td><?= gethtml('frmtra2daotrlabrin','docnum0601',$vew_patevlspc->frmtra2daotrlabrin,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>Alb&uacute;mina<br><small>(mg/dL)</small></td>
																		<td><?= gethtml('frmtra2daotrlabalb','docnum0601',$vew_patevlspc->frmtra2daotrlabalb,$lv_default); ?></td>
																		<td>Encefalopatia Portosistemica</td>
																		<td><?= gethtml('frmtra2daotrlabenc',array(''=>'','no'=>'NO','I-II'=>'I-II','III-IV'=>'III-IV'),$vew_patevlspc->frmtra2daotrlabenc,$lv_default); ?></td>
																	</tr>
																	<tr>
																		<td>ASCITIS</td>
																		<td><?= gethtml('frmtra2daotrlabasc',array(''=>'','no'=>'NO','leve'=>'LEVE','moderada'=>'MODERADA'),$vew_patevlspc->frmtra2daotrlabasc,$lv_default); ?></td>
																		<td>Recuento de Plaquetas<br><small>(en mm3)</small></td>
																		<td><input type="NUMBER" id="frmtra2daotrlabrec" name="frmtra2daotrlabrec" value="<?= $vew_patevlspc->frmtra2daotrlabrec; ?>" maxlength="7" min="10000" max="1000000" step="1" class="form-control"></td>
																	</tr>
																	<tr>
																		<td>AFP al diagnostico<br><small>Alfa-fetoproteina (AFP) en ng/ml</small></td>
																		<td><?= gethtml('frmtra2daotrlabafp','docnum0601',$vew_patevlspc->frmtra2daotrlabafp,$lv_default); ?></td>
																		<td></td>
																		<td></td>
																	</tr>
																</tbody>
															</table>
														</div>
													</div>
												</td></tr>
											</table>
										</div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>



						<h2 id="tratamiento-03"><span class="fas fa-angle-right"></span> Recurrencia HCC</h2><br><br><!-- tra -->



						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Recurrencia de Hepatocarcinoma Luego de Ablaci&oacute;n por Radiofrecuencia y/o Reseccion Quirurgica<br><small>Unicamente completar si fue con intencion curativa.</small></label>
										<div class="col-sm-6"><?= gethtml('frmtrarechep','yesno',$vew_patevlspc->frmtrarechep,$lv_default); ?></div>
									</div>
									<div class="form-group tmss-form-group" id="frmtrarechepdiv">
										<label class="col-sm-3 control-label">Fecha</label>
										<div class="col-sm-6"><?= gethtml('frmtrarechepdte','docdte',$vew_patevlspc->frmtrarechepdte,$lv_default); ?></div>
									</div>
								</td></tr>
							</tbody>
						</table>


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
									<li><a href="#patologia-01">Datos al diagn&oacute;stico</a></li>
									<li><a href="#patologia-02">Etiolog&iacute;a</a></li>
									<li><a href="#patologia-03">Screening y diagn&oacute;stico</a><li>
									<li><a href="#patologia-04">Estad&iacute;o BCLC</a><li>
								</ul>
							</li>
							<li><a href="#tratamiento">Tratamiento</a>
								<ul class="nav bs-docs-sidenav">
									<li><a href="#tratamiento-01">Realizados</a></li>
									<li><a href="#tratamiento-02">Sist&eacute;mico de Segunda L&iacute;nea</a></li>
									<li><a href="#tratamiento-03">Recurrencia HCC</a></li>
								</ul>
							</li>
							<hr>
							<h2>Hepatocarcinoma</h2>
							<hr>
							<img class="img-responsive" src="https://temasis.com.ar/lalrean-org/library/images/logos/logolalrean.png">
						</ul>
					</nav>
				</div> <!-- /col-md-3 -->

			</div> <!-- /row -->
		</div> <!-- /container -->
	</form>
	<script>
		toastr.options.timeOut= 5000;
		<?php
			if ( $vew_data->prscod=='' ) { echo 'toastr.error( "No est&aacute; registrado como prestador. Consulte con el administrador del sistema." );'; }
			if ( $vew_data->spccod=='' ) { echo 'toastr.error( "Su registro de prestador NO tiene especialidad asignada. Consulte con el administrador del sistema." );'; }
		?>

		// lndcod
		$("#<?= $lv_sec; ?> #lndcod")
			.on("keyup", function(){ if($(this).prop("value")==""){$("#<?= $lv_sec; ?> #lndtxt").prop("value","");$("#<?= $lv_sec; ?> #lndregcod").prop("value","");$("#<?= $lv_sec; ?> #lndregtxt").prop("value","");} })
			.next("span").children("a:first").on("click", function(evt) {
				tmssPopup('Paises','index.php?prg=grladrlnd&prm_vewcod=VEW_GRL_DAT_LND_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[lndcod:lndcod],[lndtxt:lndtxt],[lndregcod:empty],[lndregtxt:empty]');
				evt.preventDefault();
			});

		$("#<?= $lv_sec; ?> #frmpatdemviv").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmpatdemvivdiv"),($(this).prop("value")=="fallecido"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmptohcceticrr").on("change",function(e){
			toggleClass($("#<?= $lv_sec; ?> #frmptohcceticrrhcvdiv"),($(this).prop("value")=="hepatitis_c"?"remove":"add"),"hidden");
			toggleClass($("#<?= $lv_sec; ?> #frmptohcceticrrhbvdiv"),($(this).prop("value")=="hepatitis_b"?"remove":"add"),"hidden");
			toggleClass($("#<?= $lv_sec; ?> #frmptohcceticrrotrdiv"),($(this).prop("value")=="otro"?"remove":"add"),"hidden");
		});
		$("#<?= $lv_sec; ?> #frmptohccscreco001").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmptohccscrecodiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraabl").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraabldiv"),($(this).prop("value")=="ablacion_radiofrecuencia" || $(this).prop("value")=="ablacion_alcohol"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraresqui001").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraresquidiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraqui").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraquidiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtratsphep").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtratsphepdiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtratsphepevl").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtratsphepevldiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtratspheptyp").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtratspheptypdiv"),($(this).prop("value")=="derivacion" || $(this).prop("value")=="si"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraradytr").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraradytrdiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });

		$("#<?= $lv_sec; ?> #frmptohccenfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmptohccenfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraablenfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraablenfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraresquienfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraresquienfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtratsphepenfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtratsphepenfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraquienfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraquienfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraradenfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraradenfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraotrtraenfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraotrtraenfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtrasoppalenfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtrasoppalenfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraregenfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraregenfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtracabenfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtracabenfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });


		$("#<?= $lv_sec; ?> #frmtrainm").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtrainmdiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtrainmenfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtrainmenfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });

		$("#<?= $lv_sec; ?> #frmtratre").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtratrediv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtratreenfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtratreenfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });


		$("#<?= $lv_sec; ?> #frmtra2daotrenfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtra2daotrenfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });

		$("#<?= $lv_sec; ?> #frmtrasor").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtrasordiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtrasorenfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtrasorenfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtrasorreddss").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtrasorreddssdiv"),($(this).prop("value")=="400" || $(this).prop("value")=="200" || $(this).prop("value")=="otro"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtrasoreftadv[name=frmtrasoreftadv009]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtrasoreftadvdiv"),($(this).is(":checked")?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtrasorcncdte").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtrasorcncdtediv"),($(this).prop("value")!=""?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtrasorcncmtv[name=frmtrasorcncmtv003]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtrasorcncmtv003div"),($(this).is(":checked")?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtrasorcncmtv[name=frmtrasorcncmtv005]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtrasorcncmtvdiv"),($(this).is(":checked")?"remove":"add"),"hidden"); });

		$("#<?= $lv_sec; ?> #frmtraate").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraatediv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraateenfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraateenfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraatereddss").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraatereddssdiv"),($(this).prop("value")=="400" || $(this).prop("value")=="200" || $(this).prop("value")=="otro"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraateeftadv[name=frmtraateeftadv009]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraateeftadvdiv"),($(this).is(":checked")?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraatecncdte").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraatecncdtediv"),($(this).prop("value")!=""?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraatecncmtv[name=frmtraatecncmtv003]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraatecncmtv003div"),($(this).is(":checked")?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraatecncmtv[name=frmtraatecncmtv005]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraatecncmtvdiv"),($(this).is(":checked")?"remove":"add"),"hidden"); });

		$("#<?= $lv_sec; ?> #frmtraotrtra").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraotrtradiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtrasoppal").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtrasoppaldiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraqsttra001").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraqsttra001div"),($(this).prop("value")=="no" || $(this).prop("value")=="no_seguro"?"remove":"add"),"hidden"); });

		$("#<?= $lv_sec; ?> #frmtrainmcncmtv[name=frmtrainmcncmtv003]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtrainmcncmtv003div"),($(this).is(":checked")?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtrainmcncmtv[name=frmtrainmcncmtv005]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtrainmcncmtvdiv"),($(this).is(":checked")?"remove":"add"),"hidden"); });

		$("#<?= $lv_sec; ?> #frmtralen").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtralendiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtralenreddss").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtralenreddssdiv"),($(this).prop("value")=="400" || $(this).prop("value")=="200" || $(this).prop("value")=="otro"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraleneftadv[name=frmtraleneftadv009]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraleneftadvdiv"),($(this).is(":checked")?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtralencncdte").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtralencncdtediv"),($(this).prop("value")!=""?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtralencncmtv[name=frmtralencncmtv003]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtralencncmtv003div"),($(this).is(":checked")?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtralencncmtv[name=frmtralencncmtv005]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtralencncmtvdiv"),($(this).is(":checked")?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtralenenfext").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtralenenfextdiv"),($(this).prop("value")=="otra"?"remove":"add"),"hidden"); });

		$("#<?= $lv_sec; ?> #frmtra2da").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtra2dadiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtrareg").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraregdiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraregreddss").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraregreddssdiv"),($(this).prop("value")=="400" || $(this).prop("value")=="200" || $(this).prop("value")=="otro"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraregeftadv[name=frmtraregeftadv009]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraregeftadvdiv"),($(this).is(":checked")?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraregcncdte").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraregcncdtediv"),($(this).prop("value")!=""?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraregcncmtv[name=frmtraregcncmtv003]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraregcncmtv003div"),($(this).is(":checked")?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtraregcncmtv[name=frmtraregcncmtv005]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtraregcncmtvdiv"),($(this).is(":checked")?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtra2daotr").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtra2daotrdiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtrarechep").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtrarechepdiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });

		$("#<?= $lv_sec; ?> #frmtracab").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtracabdiv"),($(this).prop("value")=="1"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtracabreddss").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtracabreddssdiv"),($(this).prop("value")=="400" || $(this).prop("value")=="200" || $(this).prop("value")=="otro"?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtracabeftadv[name=frmtracabeftadv012]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtracabeftadvdiv"),($(this).is(":checked")?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtracabcncdte").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtracabcncdtediv"),($(this).prop("value")!=""?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtracabcncmtv[name=frmtracabcncmtv003]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtracabcncmtv003div"),($(this).is(":checked")?"remove":"add"),"hidden"); });
		$("#<?= $lv_sec; ?> #frmtracabcncmtv[name=frmtracabcncmtv005]").on("change",function(e){ toggleClass($("#<?= $lv_sec; ?> #frmtracabcncmtvdiv"),($(this).is(":checked")?"remove":"add"),"hidden"); });

		tmssLoadScript("toggle",function(){
			$("#<?= $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: "success", offstyle: "default", on: "Si", off: "No", size: "small" });
				$(this).trigger("change");
			});
		});

		$("#<?= $lv_sec; ?> select").each( function() {
			$(this).trigger("change");
		});

		$("body").scrollspy({ target: ".bs-docs-sidebar", offset: 0 });
		$("#sidebar").affix({ offset: { top: 65 } });

		function toggleClass( lp_object, lp_action, lp_class ) {
			if ( lp_action=="add" ) {
				$(lp_object).addClass(lp_class);
			} else {
				$(lp_object).removeClass(lp_class);
			}
		}

		// determino edad
		function getAge(dateString) {
			var today = new Date();
			var birthDate = new Date(dateString);
			var age = today.getFullYear() - birthDate.getFullYear();
			var m = today.getMonth() - birthDate.getMonth();
			if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
					age--;
			}
			return age;
		}
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>

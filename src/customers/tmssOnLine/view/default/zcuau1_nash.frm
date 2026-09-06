<?php
	/* url del formulario */
  $lv_lnk = '?prg=zcuau1_nash&act=02&prm_patcod='.$vew_pat->patcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('adrlstnme') );

	/* clave del documento */
	$lv_dockey = $vew_pat->patcod;

	/* titulo */
	$lv_title = $vew_lang->form;
	
	/* m&oacute;dulo y programa */
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'AU3';
	$vew_actcod = '02';
	
	/* librer&iacute;a de estilos bootstrap */
	include_once('_library.frm');
	
	// si no tiene ID de prestador, o no tiene especialidad asignada ==> es solo lectura
	if ( $vew_data->prscod=='' || $vew_data->spccod=='' ) { $vew_actcod='03'; $vew_readonly = true; }
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<link href="library/css/temasis.bs-docs-sidebar.css" rel="stylesheet">
	<style>#sidebar.affix {top: 121px;}</style>

  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '00'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success" title="<?= $vew_lang->save;  ?>"><span class="fas fa-save"></span><span class="hidden-xs">  <?= $vew_lang->save; ?></span></a>
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
						
						
						
						<h2 id="paciente-01"><span class="fas fa-angle-right"></span> Datos Filiatorios</h2><br><br><!-- dem -->
						
						
						
						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">ID Paciente</label>
										<div class="col-sm-4"><?= gethtml('patcod','patcod',$vew_pat->patcod,$lv_always_disabled); ?></div>
										<label class="col-sm-2 control-label"><?= 'Iniciales'; ?></label>
										<div class="col-sm-4">
											<?= gethtml('adrlstnme','adrlstnme',$vew_pat->adr->adrlstnme,$lv_default); ?>
											<input type="hidden" id="adrfrtnme" name="adrfrtnme" value="<?= $vew_pat->adr->adrfrtnme; ?>">
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">G&eacute;nero</label>
										<div class="col-sm-4"><?= gethtml('frmpatgen', array(''=>'','0'=>'Masculino','1'=>'Femenino'), $vew_patevlspc->frmpatgen, $lv_default); ?></div>
										<label class="col-sm-2 control-label">Edad al ingreso</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmpatyth" name="frmpatyth" value="<?= $vew_patevlspc->frmpatyth; ?>" maxlength="2" min="18" max="99" step="1" class="form-control"></div>
									</div>
								</td></tr>
								<tr><td>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Pa&iacute;s</label>
										<div class="col-sm-4"><?= vew_boot(array("style"=>"search", "readonly"=>$vew_readonly), array("input"=>gethtml("lndtxt", "adrlndtxt", $vew_pat->adr->lndtxt, $lv_default) )); ?></div>
										<input type="hidden" id="lndcod" name="lndcod" value="<?= $vew_pat->adr->lndcod; ?>">
										<label class="col-sm-2 control-label">Regi&oacute;n</label>
										<div class="col-sm-4"><?= vew_boot(array("style"=>"search", "readonly"=>$vew_readonly), array("input"=>gethtml("lndregtxt", "adrlndregtxt", $vew_pat->adr->lndregtxt, $lv_default) )); ?></div>
										<input type="hidden" id="lndregcod" name="lndregcod" value="<?= $vew_pat->adr->lndregcod; ?>">
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">M&eacute;dico/Centro tratante</label>
										<div class="col-sm-4"><?= gethtml('frmpatmed','doccmt1x50',$vew_patevlspc->frmpatmed,$lv_default); ?></div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>
						
						
						
						<h2 id="paciente-02"><span class="fas fa-angle-right"></span> Datos Antropometricos</h2><br><br>
						
						
						
						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label"><?= $vew_lang->weight; ?> <small>(kg)</small></label>
										<div class="col-sm-2"><?= gethtml('patbaswgt','qty',$vew_patevlspc->patbaswgt,$lv_default); ?></div>
										<label class="col-sm-2 control-label">Talla <small>(cm)</small></label>
										<div class="col-sm-2"><input type="NUMBER" id="patbashgh" name="patbashgh" value="<?= $vew_patevlspc->patbashgh; ?>" maxlength="3" min="100" max="210" step="1" class="form-control"></div>
										<label class="col-sm-2 control-label">IMC <small>(Kg/m-2)</small></label>
										<div class="col-sm-2"><?= gethtml('patbasimc','qty',$vew_patevlspc->patbasimc,$lv_always_disabled); ?></div>
								</td></tr>
							</tbody>
						</table>
						<br><br>

						
						
						<h2 id="paciente-03"><span class="fas fa-angle-right"></span> H&aacute;bitos</h2><br><br>
						
						
						
						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Ingesta de ETOH</label>
										<div class="col-sm-4"><?= gethtml('frmbasingeto', array(''=>'','0'=>'Niega','1'=>'<20gr/d (Fem) - <30gr/d (Masc)','2'=>'>20<50gr/d (Fem) - >30<50gr/d (Masc)','3'=>'>50gr/d'), $vew_patevlspc->frmbasingeto, $lv_default); ?><small>(volumen [mL] de bebida X % OH de bebida X 0.8 / 100)</small></div>
										<label class="col-sm-2 control-label">A&ntilde;os de Ingesta</label>
										<div class="col-sm-4"><?= gethtml('frmbasanieto', array(''=>'','0'=>'Niega','1'=>'<2 a&ntilde;os','2'=>'>2<5 a&ntilde;os','3'=>'>5 a&ntilde;os'), $vew_patevlspc->frmbasanieto, $lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Tabaco <small>(pack/year)</small></label>
										<div class="col-sm-4"><?= getHtml('frmbastabyth','docnum0601',$vew_patevlspc->frmbastabyth,$lv_default); ?></div>
										<label class="col-sm-2 control-label">Actvidida F&iacute;sica Aer&oacute;bica x semana</label>
										<div class="col-sm-4"><?= gethtml('frmbasactfis', array(''=>'','0'=>'Niega','1'=>'<60 min','2'=>'>60<180 min','3'=>'>180<300 min','4'=>'>300 min'), $vew_patevlspc->frmbasactfis, $lv_default); ?></div>
									</div>
								</td></tr>							
							</tbody>
						</table>
						<br><br>
						
 						
						
						<h1 id="patologia"><span class="fas fa-caret-right"></span> Basal</h1><br>
						
						<h2 id="patologia-01"><span class="fas fa-angle-right"></span> Diabetes </h2><br><br>

            
            
            <table class="table table-striped table-condensed" id="basprmdia_tbl">
              <thead>
                <tr>
                  <th>
                    <div class="form-group tmss-form-group">
                      <label class="col-sm-5 control-label">Diabetes bajo tratamiento o Glucosa >100mg/dL.</label>
                      <div class="col-sm-3"><?= gethtml('frmbasprmdia', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmbasprmdia, $lv_default); ?></div>
                    </div>
                  </th>
                </tr>
              </thead>
              <tbody id="basprmdia_tblbdy">
                <tr>
                  <td>
                    <div class="form-group tmss-form-group">
                      <label class="col-sm-3 control-label">Fecha de Diagnostico</label>
                      <div class="col-sm-3"><?= getHtml('frmbasdiadiagdte','docdte',$vew_patevlspc->frmbasdiadiagdte,$lv_default); ?></div>              
                      <label class="col-sm-3 control-label">Retinopat&iacute;a Diab&eacute;tica</label>
                      <div class="col-sm-3"><?= gethtml('frmbasdiaretdia', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmbasdiaretdia, $lv_default); ?></div>
                    </div>
                  </td> 
                </tr>
                <tr>
                  <td>
                    <div class="form-group tmss-form-group">
                      <label class="col-sm-2 control-label">Microalbuminuria</label>
                      <div class="col-sm-4"><?= gethtml('frmbasdiamcb', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmbasdiamcb, $lv_default); ?></div>
                      <label class="col-sm-3 control-label">Neuropat&iacute;a Perif&eacute;rica</label>
                      <div class="col-sm-3"><?= gethtml('frmbasdianeuprf', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmbasdianeuprf, $lv_default); ?></div>
                    </div>
                  </td> 
                </tr>
                <tr>
                  <td>
                    <div class="form-group tmss-form-group">
                      <label class="col-sm-3 control-label">Anti-diab&eacute;ticos orales</label>
                      <div class="col-sm-3"><?= gethtml('frmbasprmado', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmbasprmado, $lv_default); ?><br>
                        <div id="frmbasprmado_div">
                          <label><input type="checkbox" id="frmbasprmadodrg" name="frmbasprmadodrg001" <?= ($vew_patevlspc->frmbasprmadodrg001!=''?'checked':''); ?>> Pioglitazona</label><br>
                          <label><input type="checkbox" id="frmbasprmadodrg" name="frmbasprmadodrg002" <?= ($vew_patevlspc->frmbasprmadodrg002!=''?'checked':''); ?>> Metformina</label><br>
                          <label><input type="checkbox" id="frmbasprmadodrg" name="frmbasprmadodrg003" <?= ($vew_patevlspc->frmbasprmadodrg003!=''?'checked':''); ?>> Sulfonilureas</label><br>
                          <label><input type="checkbox" id="frmbasprmadodrg" name="frmbasprmadodrg004" <?= ($vew_patevlspc->frmbasprmadodrg004!=''?'checked':''); ?>> Analogo GLP-1</label><br>
                          <label><input type="checkbox" id="frmbasprmadodrg" name="frmbasprmadodrg005" <?= ($vew_patevlspc->frmbasprmadodrg005!=''?'checked':''); ?>> Inhibidor SGLT-2</label><br>
                          <label><input type="checkbox" id="frmbasprmadodrg" name="frmbasprmadodrg006" <?= ($vew_patevlspc->frmbasprmadodrg006!=''?'checked':''); ?>> Inhibidor DPP-4</label><br>
                        </div>
                      </div>
                      <label class="col-sm-3 control-label">Tratamiento con insulina</label>
                      <div class="col-sm-3"><?= gethtml('frmbasprmtin', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmbasprmtin, $lv_default); ?><br>
                        <div id="frmbasprmtin_div">
                          <label class="control-label">Fecha de inicio</label>
                          <div><?= getHtml('frmbasprmtindte','docdte',$vew_patevlspc->frmbasprmtindte,$lv_default); ?></div>  
                        </div>
                      </div>
                    </div>
                  </td> 
                </tr>
              </tbody>
            </table>

            
						<h2 id="patologia-02"><span class="fas fa-angle-right"></span> Par&aacute;metros del Sindrome Metab&oacute;lico</h2><br><br>
						
						
						
						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Hipertension, Recibe tratamiento, Sistolica >130mmHg, Diastolica>85mmHg.</label>
										<div class="col-sm-3"><?= gethtml('frmbasprmhip', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmbasprmhip, $lv_default); ?></div>
                  </div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Trigliceridos >150mg/dL o Recibe Fibratos</label>
										<div class="col-sm-3"><?= gethtml('frmbasprmtri', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmbasprmtri, $lv_default); ?></div>
										<label class="col-sm-3 control-label">HDLcolesterol <50mg/dl en hombres o <40 mg/dL en mujeres</label>
										<div class="col-sm-3"><?= gethtml('frmbasprmhdl', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmbasprmhdl, $lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Enfermedad CV (eventos coronarios o vasculopatia periferica o ACV</label>
										<div class="col-sm-3"><?= gethtml('frmbasprmecv', array(''=>'','0'=>'Niega','1'=>'Si'), $vew_patevlspc->frmbasprmecv, $lv_default); ?></div>
										<label class="col-sm-3 control-label">Enfermedad renal cronica</label>
										<div class="col-sm-3"><?= gethtml('frmbasprmerc', array(''=>'','0'=>'Niega','1'=>'Si no HDL','2'=>'HDL'), $vew_patevlspc->frmbasprmerc, $lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Tratamiento con estatinas</label>
										<div class="col-sm-3"><?= gethtml('frmbasprmtes', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmbasprmtes, $lv_default); ?><br>
                      <div id="frmbasprmtes_div">
                        <label class="control-label">Fecha de inicio</label>
                        <div><?= getHtml('frmbasprmtesdte','docdte',$vew_patevlspc->frmbasprmtesdte,$lv_default); ?></div>  
                      </div>
                    </div>
										<label class="col-sm-3 control-label">Tratamiento antihipertensivo</label>
										<div class="col-sm-3"><?= gethtml('frmbasprmtah', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmbasprmtah, $lv_default); ?><br>
                      <div id="frmbasprmtah_div">
                        <label class="control-label">Fecha de inicio</label>
                        <div><?= getHtml('frmbasprmtahdte','docdte',$vew_patevlspc->frmbasprmtahdte,$lv_default); ?></div>  
                      </div>
                    </div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-3 control-label">Hipotiroidismo</label>
										<div class="col-sm-3"><?= gethtml('frmbasprmhpt', array(''=>'','0'=>'No','1'=>'Subclinico','2'=>'Bajo Tratamiento'), $vew_patevlspc->frmbasprmhpt, $lv_default); ?></div>
										<label class="col-sm-3 control-label">Recibe Vitamina E</label>
										<div class="col-sm-3"><?= gethtml('frmbasprmvit', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmbasprmvit, $lv_default); ?><br>
                      <div id="frmbasprmvit_div">
                        <label class="control-label">Fecha de inicio</label>
                        <div><?= getHtml('frmbasprmvitdte','docdte',$vew_patevlspc->frmbasprmvitdte,$lv_default); ?></div>  
                      </div>
                    </div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>
						
						
						
						<h2 id="patologia-03"><span class="fas fa-angle-right"></span> Par&aacute;metros Bioqu&iacute;micos</h2><br><br>
						
						
						
						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Fecha de Seguimiento</label>
										<div class="col-sm-4"><?= getHtml('frmbasbiodte','docdte',$vew_patevlspc->frmbasbiodte,$lv_default); ?></div>
                   	<label class="col-sm-2 control-label"> Acido Urico (mg/dL)	</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbioacdurc" name="frmbasbioacdurc" value="<?= $vew_patevlspc->frmbasbioacdurc; ?>" min="0" max="15" class="form-control"></div>
                  </div>
								</td></tr>							
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Hematocrito (%)	</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbiohem" name="frmbasbiohem" value="<?= $vew_patevlspc->frmbasbiohem; ?>" maxlength="2" min="20" max="56" step="1" class="form-control"></div>
										<label class="col-sm-2 control-label">Hemoglobina (g/dL)	</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbiohgl" name="frmbasbiohgl" value="<?= $vew_patevlspc->frmbasbiohgl; ?>" maxlength="4" min="7" max="18" step="0.1" class="form-control"></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Leucocitos/mL	</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbioleu" name="frmbasbioleu" value="<?= $vew_patevlspc->frmbasbioleu; ?>" maxlength="5" min="1000" max="20000" step="1" class="form-control"></div>
										<label class="col-sm-2 control-label">Plaquetas(10-9/L)	<br><small>Rango 1-999</small></label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbioplq" name="frmbasbioplq" value="<?= $vew_patevlspc->frmbasbioplq; ?>" maxlength="3" min="10" max="999" step="1" class="form-control"></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Ferritina (ng/dL)	</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbiofer" name="frmbasbiofer" value="<?= $vew_patevlspc->frmbasbiofer; ?>" maxlength="4" min="50" max="2000" step="1" class="form-control"></div>
										<label class="col-sm-2 control-label">% saturacion de transferrina</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbiopst" name="frmbasbiopst" value="<?= $vew_patevlspc->frmbasbiopst; ?>" maxlength="3" min="5" max="100" step="1" class="form-control"></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Colesterol total (mg/dL)</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbioclt" name="frmbasbioclt" value="<?= $vew_patevlspc->frmbasbioclt; ?>" maxlength="4" min="30" max="1200" step="1" class="form-control"></div>
										<label class="col-sm-2 control-label">LDL Colesterol (mg/dL)</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbioldl" name="frmbasbioldl" value="<?= $vew_patevlspc->frmbasbioldl; ?>" maxlength="4" min="30" max="800" step="1" class="form-control"></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">HDL Colesterol (mg/dL)</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbiohdl" name="frmbasbiohdl" value="<?= $vew_patevlspc->frmbasbiohdl; ?>" maxlength="3" min="10" max="150" step="1" class="form-control"></div>
										<label class="col-sm-2 control-label">Trigliceridos (mg/dL)	</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbiotri" name="frmbasbiotri" value="<?= $vew_patevlspc->frmbasbiotri; ?>" maxlength="3" min="50" max="800" step="1" class="form-control"></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Glucosa mg/dL	</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbioglu" name="frmbasbioglu" value="<?= $vew_patevlspc->frmbasbioglu; ?>" maxlength="4" min="40" max="1000" step="1" class="form-control"></div>
										<label class="col-sm-2 control-label">Insulina (mU/mL)</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbioins" name="frmbasbioins" value="<?= $vew_patevlspc->frmbasbioins; ?>" maxlength="2" min="4" max="50" step="1" class="form-control"></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">HOMA (mg/dL x mU/mL/405)</label>
										<div class="col-sm-4"><?= gethtml('frmbasbiohma','docnum0600',$vew_patevlspc->frmbasbiohma,$lv_always_disabled); ?></div>
										<label class="col-sm-2 control-label">HbA1c (%)</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbiohb1" name="frmbasbiohb1" value="<?= $vew_patevlspc->frmbasbiohb1; ?>" maxlength="4" min="3" max="12" step="0.1" class="form-control"></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Bilirrubina total (mg/dL)	</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbiobil" name="frmbasbiobil" value="<?= $vew_patevlspc->frmbasbiobil; ?>" maxlength="4" min="0.2" max="15" step="0.1" class="form-control"></div>
										<label class="col-sm-2 control-label">AST (UI/mL)	</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbioast" name="frmbasbioast" value="<?= $vew_patevlspc->frmbasbioast; ?>" maxlength="4" min="5" max="2000" step="1" class="form-control"><br>
											<table><tr><td>AST Valor Max de Referencia (UI/mL)</td><td><?= gethtml('frmbasbioastmax','docnum0600',($vew_patevlspc->frmbasbioastmax==''?'35':$vew_patevlspc->frmbasbioastmax),$lv_default); ?></td></tr></table>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">ALT (UI/mL)</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbioalt" name="frmbasbioalt" value="<?= $vew_patevlspc->frmbasbioalt; ?>" maxlength="4" min="5" max="2000" step="1" class="form-control"></div>
										<label class="col-sm-2 control-label">FAL (UI/mL)</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbiofal" name="frmbasbiofal" value="<?= $vew_patevlspc->frmbasbiofal; ?>" maxlength="4" min="50" max="1000" step="1" class="form-control"></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">GGT (UI/mL)	</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbioggt" name="frmbasbioggt" value="<?= $vew_patevlspc->frmbasbioggt; ?>" maxlength="4" min="10" max="1000" step="1" class="form-control"></div>
										<label class="col-sm-2 control-label">Tiempo de Protrombina (%)	</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbiotpb" name="frmbasbiotpb" value="<?= $vew_patevlspc->frmbasbiotpb; ?>" maxlength="3" min="10" max="110" step="1" class="form-control"></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Proteinas totales (g/dL)</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbioptt" name="frmbasbioptt" value="<?= $vew_patevlspc->frmbasbioptt; ?>" maxlength="3" min="2.5" max="9.0" step="0.1" class="form-control"></div>
										<label class="col-sm-2 control-label">Albumina (g/dL)	</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbioalb" name="frmbasbioalb" value="<?= $vew_patevlspc->frmbasbioalb; ?>" maxlength="3" min="1" max="6" step="0.1" class="form-control"></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Gamma-Globuliinas (g/dL)	</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbiogam" name="frmbasbiogam" value="<?= $vew_patevlspc->frmbasbiogam; ?>" maxlength="3" min="0.5" max="6" step="0.1" class="form-control"></div>
										<label class="col-sm-2 control-label">FAN</label>
										<div class="col-sm-4"><?= gethtml('frmbasbiofan',array(''=>'','0'=>'Negativo','1'=>'1/80','2'=>'>=1/60'),$vew_patevlspc->frmbasbiofan, $lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">RIN</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbiorin" name="frmbasbiorin" value="<?= $vew_patevlspc->frmbasbiorin; ?>" maxlength="3" min="0.8" max="10" step="0.1" class="form-control"></div>
										<label class="col-sm-2 control-label">Urea</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbioure" name="frmbasbioure" value="<?= $vew_patevlspc->frmbasbioure; ?>" maxlength="3" min="5" max="100" step="1" class="form-control"></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Creatinina</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbiocre" name="frmbasbiocre" value="<?= $vew_patevlspc->frmbasbiocre; ?>" maxlength="3" min="0.2" max="4" step="0.1" class="form-control"></div>
										<label class="col-sm-2 control-label"> Prote&iacute;na C Reactiva (PCR) (mg/dL)	</label>
										<div class="col-sm-4"><input type="NUMBER" id="frmbasbiopcr" name="frmbasbiopcr" value="<?= $vew_patevlspc->frmbasbiopcr; ?>" min="0" max="100" step="0.1" class="form-control"></div>
                  </div>
								</td></tr>
							</tbody>
						</table>
						<br><br>
						
						
						
						<h2 id="patologia-04"><span class="fas fa-angle-right"></span> Scores predictivos</h2><br><br>
						
						
						
						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">AST/ALT	</label>
										<div class="col-sm-4"><?= getHtml('frmbasscrast','docnum0601',$vew_patevlspc->frmbasscrast,$lv_always_disabled); ?></div>
										<label class="col-sm-2 control-label">APRI	</label>
										<div class="col-sm-4"><?= getHtml('frmbasscrapr','docnum0601',$vew_patevlspc->frmbasscrapr,$lv_always_disabled); ?></div>
										<div class="col-sm-6"></div>
										<div class="col-sm-6">
											<small>
												<table class="table table-condensed table-bordered">
													<thead><tr><td>Indice APRI</td><td>Interpretaci&oacute;n</td></tr></thead>
													<tbody>
														<tr><td><0.5</td><td>Ausencia de fibrosis significativa</td></tr>
														<tr><td>0.5-1.5</td><td>Fibrosis probable pero en zona dudosa</td></tr>
														<tr><td>>1. 5</td><td>Con fibrosis signficativa</td>
													</tbody>
												</table>
											</small>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">FIB-4</label>
										<div class="col-sm-4"><?= getHtml('frmbasscrfib','docnum0601',$vew_patevlspc->frmbasscrfib,$lv_always_disabled); ?></div>
										<label class="col-sm-2 control-label">NAFLD Fibrosis Score</label>
										<div class="col-sm-4"><?= getHtml('frmbasscrnaf','docnum0601',$vew_patevlspc->frmbasscrnaf,$lv_always_disabled); ?></div>
										<div class="col-sm-6">
											<small>
												<table class="table table-condensed table-bordered">
													<thead><tr><td>Age, years</td><td>FIB-4 Score</td><td>Diagnosis</td></tr></thead>
													<tbody>
														<tr><td><= 35</td><td>-</td><td>Use alternative fibrosis assessment</td></tr>
														<tr><td rowspan="3">36-64</td><td><1.3</td><td>Advanced fibrosis excluded</td></tr>
														<tr><td>1.3-2.67</td><td>Further investigation needed</td></tr>
														<tr><td>>2.67</td><td>Advanced fibrosis likely</td></tr>
														<tr><td rowspan="3">>=65</td></td><td><2.0</td><td>Advanced fibrosis excluded</td></tr>
														<tr><td>2.0-2.67</td><td>Further investigation needed</td></tr>
														<tr><td>>2.67</td><td>Advanced fibrosis likely</td></tr>
													</tbody>
												</table>
											</small>
										</div>
										<div class="col-sm-6">
											<small>
												<table class="table table-condensed table-bordered">
													<thead><tr><td>NAFLD Score</td><td>Correlated Fibrosis Severity</td></tr></thead>
													<tbody>
														<tr><td>< -1.455</td><td>F0-F2</td></tr>
														<tr><td>-1.455 - 0.675</td><td>Indeterminant score</td></tr>
														<tr><td>> 0.675</td><td>F3-F4</td></tr>
													</tbody>
												</table>
											</small>
										</div>										
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">BARD</label>
										<div class="col-sm-4"><?= getHtml('frmbasscrbrd','docnum0601',$vew_patevlspc->frmbasscrbrd,$lv_always_disabled); ?></div>
										<div class="col-sm-6">&nbsp;</div>
										<div class="col-sm-6">
											<small>
												<table class="table table-condensed table-bordered">
													<thead><tr><td>BARD Score</td><td>Risk of advanced fibrosis</td></tr></thead>
													<tbody>
														<tr><td>0-1</td><td>Low</td></tr>
														<tr><td>2-4</td><td>High</td></tr>
													</tbody>
												</table>
											</small>
										</div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>
						

						
						<h2 id="patologia-05"><span class="fas fa-angle-right"></span> Ecografia</h2><br><br>


						
						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Fecha de Seguimiento</label>
										<div class="col-sm-4"><?= getHtml('frmbasecodte','docdte',$vew_patevlspc->frmbasecodte,$lv_default); ?></div>
										<label class="col-sm-2 control-label">Ecoestructura</label>
										<div class="col-sm-4"><?= gethtml('frmbasecoeco', array(''=>'','0'=>'normal','1'=>'hiperecogenicidad focal','2'=>'Hiperecogenicidad difusa'), $vew_patevlspc->frmbasecoeco, $lv_default); ?></div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>

						
						
						<h2 id="patologia-06"><span class="fas fa-angle-right"></span> Elastografia</h2><br><br>

						
						
						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Fecha de Seguimiento</label>
										<div class="col-sm-4"><?= getHtml('frmbaseladte','docdte',$vew_patevlspc->frmbaseladte,$lv_default); ?></div>
										<label class="col-sm-2 control-label">Fibroscan CAP esteatosis (%)</label>
										<div class="col-sm-4"><?= getHtml('frmbaselafie','docnum0601',$vew_patevlspc->frmbaselafie,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Metodo de elastografia</label>
										<div class="col-sm-4"><?= gethtml('frmbaselamtd', array(''=>'','0'=>'Ninguno','1'=>'Fibroscan','2'=>'ARFI','3'=>'Shear Wave','4'=>'MR-E'), $vew_patevlspc->frmbaselamtd, $lv_default); ?></div>
										<label class="col-sm-2 control-label">Elastogragia (kPa)</label>
										<div class="col-sm-4"><?= getHtml('frmbaselaela','docnum0601',$vew_patevlspc->frmbaselaela,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Elastografia: Estad&iacute;o de Fibrosis</label>
										<div class="col-sm-4"><?= gethtml('frmbaselaefi',array(''=>'','0'=>'0','1'=>'1','2'=>'2','3'=>'3','4'=>'4'),$vew_patevlspc->frmbaselaefi, $lv_default); ?></div>
										<label class="col-sm-2 control-label">Fibroscan CAP (db/m)</label>
										<div class="col-sm-4"><?= getHtml('frmbaselafib','docnum0601',$vew_patevlspc->frmbaselafib,$lv_default); ?></div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>

						
						
						<h2 id="patologia-07"><span class="fas fa-angle-right"></span> Histolog&iacute;a</h2><br><br>

						
						
						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Fecha de Seguimiento</label>
										<div class="col-sm-4"><?= getHtml('frmbashisdte','docdte',$vew_patevlspc->frmbashisdte,$lv_default); ?></div>
										<label class="col-sm-2 control-label">Fibrosis</label>
										<div class="col-sm-4"><?= gethtml('frmbashisfib', array(''=>'','0'=>'0','1a'=>'1a - Perisinusoidal','1b'=>'1b - Periportal','2'=>'2','3'=>'3','4'=>'4'), $vew_patevlspc->frmbashisfib, $lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Esteatosis</label>
										<div class="col-sm-4"><?= gethtml('frmbashisest', array(''=>'','0'=>'<5%','1'=>'>5<33%','2'=>'>33<66%','3'=>'>66%'), $vew_patevlspc->frmbashisest, $lv_default); ?></div>
										<label class="col-sm-2 control-label">Balonamiento</label>
										<div class="col-sm-4"><?= gethtml('frmbashisbal', array(''=>'','0'=>'no se observa','1'=>'pocas/aisladas','2'=>'varias/numerosas'), $vew_patevlspc->frmbashisbal, $lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Inflamacion lobular</label>
										<div class="col-sm-4"><?= gethtml('frmbashisifl', array(''=>'','0'=>'no se observa','1'=>' 1/2 focos','2'=>'>2<4 focos','3'=>'>4 focos'), $vew_patevlspc->frmbashisifl, $lv_default); ?></div>
										<label class="col-sm-2 control-label">Inflamacion portal</label>
										<div class="col-sm-4"><?= gethtml('frmbashisifp', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmbashisifp, $lv_default); ?></div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>
						
						
						
						<?php							
							function getDates( $lp_evl, $lp_edt=false, $lp_inp=null, $lp_class=array() ) {
								$lv_buffer = '';
								foreach($lp_evl as $lv_row) {
									if ($lp_edt==false){
										$lv_buffer .= '<td>'.$lv_row['evldte']->format('d/m/Y').'</td>';
									} else { 
										$lv_dte = $lv_row['evldte']->format('Ymd');
										$lv_buffer .= '<td>'.$lp_inp->gethtml( 'evldte_'.$lv_dte, 'docdte', $lv_row['evldte'], $lp_class).'</td>';
									}
								}
								return ($lv_buffer==''?'<td></td>':$lv_buffer);
							}
							
							function getValues( $lp_sec,  $lp_inp, $lp_doc, $lp_evl, $lp_tag, $lp_fld, $lp_class ) {
								$lv_buffer = '';
								foreach($lp_evl as $lv_row) {
									$lv_dte = $lv_row['evldte']->format('Ymd');
									$lv_val = $lp_doc->getTagValue( $lv_row['evlevl'].$lv_row['evlobj'], $lp_tag );
									$lv_buffer .= '<td>';
									$lv_buffer .= $lp_inp->gethtml($lp_tag.'_'.$lv_dte, $lp_fld, $lv_val, $lp_class);
									if($lp_tag=='patsegwgt' || $lp_tag=='patseghgh'){
										$lv_buffer .= '<script>$(function(){'.$lp_sec.'_attachEvent_imc("'.$lp_tag.'_'.$lv_dte.'"); $("#'.$lp_sec.' #'.$lp_tag.'_'.$lv_dte.'").trigger("change"); });</script>';
									}
									if($lp_tag=='frmsegbioast' || $lp_tag=='frmsegbioalt'){
										$lv_buffer .= '<script>$(function(){'.$lp_sec.'_attachEvent_astalt("'.$lp_tag.'_'.$lv_dte.'"); $("#'.$lp_sec.' #'.$lp_tag.'_'.$lv_dte.'").trigger("change"); });</script>';
									}
									if($lp_tag=='frmsegbioast' || $lp_tag=='frmsegbioalt' || $lp_tag=='frmsegbioplq' || $lp_tag=='frmpatyth' ){
										$lv_buffer .= '<script>$(function(){'.$lp_sec.'_attachEvent_fib4("'.$lp_tag.'_'.$lv_dte.'"); $("#'.$lp_sec.' #'.$lp_tag.'_'.$lv_dte.'").trigger("change"); });</script>';
									}
									if($lp_tag=='frmsegbioast' || $lp_tag=='frmsegbioplq'){
										$lv_buffer .= '<script>$(function(){'.$lp_sec.'_attachEvent_apri("'.$lp_tag.'_'.$lv_dte.'");});</script>';
									}
									if($lp_tag=='frmsegbioast' || $lp_tag=='frmsegbioalt' || $lp_tag=='frmsegbioplq' || $lp_tag=='frmpatyth' || $lp_tag=='frmsegbioalb' || $lp_tag=='patsegimc' ){
										$lv_buffer .= '<script>$(function(){'.$lp_sec.'_attachEvent_nafld("'.$lp_tag.'_'.$lv_dte.'"); $("#'.$lp_sec.' #'.$lp_tag.'_'.$lv_dte.'").trigger("change"); });</script>';
									}
									if($lp_tag=='frmsegbioast' || $lp_tag=='frmsegbioalt' || $lp_tag=='patsegimc' ){
										$lv_buffer .= '<script>$(function(){'.$lp_sec.'_attachEvent_bard("'.$lp_tag.'_'.$lv_dte.'"); $("#'.$lp_sec.' #'.$lp_tag.'_'.$lv_dte.'").trigger("change"); });</script>';
									}
									if($lp_tag=='frmsegbioins' || $lp_tag=='frmsegbioglu' ){
										$lv_buffer .= '<script>$(function(){'.$lp_sec.'_attachEvent_homa("'.$lp_tag.'_'.$lv_dte.'"); $("#'.$lp_sec.' #'.$lp_tag.'_'.$lv_dte.'").trigger("change"); });</script>';
									}
									$lv_buffer .= '</td>';
								}
								return ($lv_buffer==''?'<td></td>':$lv_buffer);
							}
							
							if( $vew_data->patcod!='') {
								echo '<h1 id="seguimiento"><span class="fas fa-caret-right"></span> Seguimiento</h1><br>';
								echo '<a href="#" id="btnaddflw" class="btn btn-primary"><span class="fas fa-plus"></span> Seguimiento</a><br><br>';
								echo '<input type="hidden" id="flwdte" name="flwdte" value="">';
								$lv_buffer = '';
								foreach($vew_data->patevl as $lv_row) {
									$lv_buffer .= '<input type="hidden" id="evlcod_'.$lv_row['evldte']->format('Ymd').'" name="evlcod_'.$lv_row['evldte']->format('Ymd').'" value="'.$lv_row['evlcod'].'"><input type="hidden" id="evldte_'.$lv_row['evldte']->format('Ymd').'" name="evldte_'.$lv_row['evldte']->format('Ymd').'" value="'.$lv_row['evldte']->format('d/m/Y').'">';
								}
								echo $lv_buffer;
						?>		
						<table class="table table-condensed table-bordered table-hover table-striped" style="overflow-x: scroll;">
							<tbody>
								<tr style="background-color: #f1f1f1; font-weight: bold;"><td>Datos antropometricos</td><?= getDates($vew_data->patevl, true, $vew_input, $lv_default); ?></tr>
								<tr><td><?= $vew_lang->weight; ?> <small>(kg)</small></td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'patsegwgt','qty',$lv_default); ?></tr>
								<tr><td>Talla <small>(cm)</small></td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'patseghgh','qty', $lv_default); ?></tr>
								<tr><td>IMC <small>(Kg/m-2)</small></td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'patsegimc','qty', $lv_always_disabled); ?></tr>
								<tr><td>Edad</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmpatyth','qty', $lv_default); ?></tr>
								<tr style="background-color: #f1f1f1; font-weight: bold;"><td>Par&aacute;metros Bioqu&iacute;micos</td><?= getDates($vew_data->patevl); ?></tr>
								<tr><td>Hematocrito (%)	</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbiohem','docnum0601',$lv_default); ?></tr>
								<tr><td>Hemoglobina (g/dL)</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbiohgl','docnum0601',$lv_default); ?></tr>
								<tr><td>Plaquetas(10-9/L)	</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbioplq','docnum0601',$lv_default); ?></tr>
								<tr><td>Ferritina (ng/dL)	</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbiofer','docnum0601',$lv_default); ?></tr>
								<tr><td>% saturacion de transferrina</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbiopst','docnum0601',$lv_default); ?></tr>
								<tr><td>Colesterol total (mg/dL)</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbioclt','docnum0601',$lv_default); ?></tr>
								<tr><td>LDL Colesterol (mg/dL)</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbioldl','docnum0601',$lv_default); ?></tr>
								<tr><td>HDL Colesterol (mg/dL)</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbiohdl','docnum0601',$lv_default); ?></tr>
								<tr><td>Trigliceridos (mg/dL)	</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbiotri','docnum0601',$lv_default); ?></tr>
								<tr><td>Glucosa mg/dL	</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbioglu','docnum0601',$lv_default); ?></tr>
								<tr><td>Insulina (mU/mL)</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbioins','docnum0601',$lv_default); ?></tr>
								<tr><td>HOMA (mg/dL x mU/mL/405)</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbiohma','docnum0601',$lv_always_disabled); ?></tr>
								<tr><td>HbA1c (%)</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbiohb1','docnum0601',$lv_default); ?></tr>
								<tr><td>Bilirrubina total (mg/dL)	</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbiobil','docnum0601',$lv_default); ?></tr>
								<tr><td>AST (UI/mL)	</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbioast','docnum0601',$lv_default); ?></tr>
								<tr><td>AST Valor Max de Referencia (UI/mL)</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbioastmax','docnum0601',$lv_default); ?></tr>
								<tr><td>ALT (UI/mL)</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbioalt','docnum0601',$lv_default); ?></tr>
								<tr><td>FAL (UI/mL)</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbiofal','docnum0601',$lv_default); ?></tr>
								<tr><td>GGT (UI/mL)	</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbioggt','docnum0601',$lv_default); ?></tr>
								<tr><td>Proteinas totales (g/dL)</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbioptt','docnum0601',$lv_default); ?></tr>
								<tr><td>Albumina (g/dL)	</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbioalb','docnum0601',$lv_default); ?></tr>
								<tr><td>Tiempo de Protrombina (%)	</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbiotpb','docnum0601',$lv_default); ?></tr>
								<tr><td>RIN</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbiorin','docnum0601',$lv_default); ?></tr>
								<tr><td>Urea</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbioure','docnum0601',$lv_default); ?></tr>
								<tr><td>Creatinina</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbiocre','docnum0601',$lv_default); ?></tr>
                <tr><td>Acido Urico (mg/dL)</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbioacdurc','docnum0600',$lv_default); ?></tr>
                <tr><td>Prote&iacute;na C Reactiva (PCR) (mg/dL)</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegbiopcr','docnum0600',$lv_default); ?></tr>
								<tr style="background-color: #f1f1f1; font-weight: bold;"><td>Scores predictivos</td><?= getDates($vew_data->patevl); ?></tr>
								<tr><td>AST/ALT	</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegscrast','docnum0601',$lv_always_disabled); ?></tr>
								<tr><td>APRI	</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegscrapr','docnum0601',$lv_always_disabled); ?></tr>
								<tr><td>FIB-4</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegscrfib','docnum0601',$lv_always_disabled); ?></tr>
								<tr><td>NAFLD Fibrosis Score</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegscrnaf','docnum0601',$lv_always_disabled); ?></tr>
								<tr><td>BARD</td><?= getValues($lv_sec,$vew_input,$vew_doc,$vew_data->patevl,'frmsegscrbrd','docnum0601',$lv_always_disabled); ?></tr>
							</tbody>
						</table>
						<br>

						
						<h2 id="seguimiento"><span class="fas fa-angle-right"></span> &Uacute;ltima Ecografia</h2><br><br>						
						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Fecha de Seguimiento</label>
										<div class="col-sm-4"><?= getHtml('frmsegecodte','docdte',$vew_patevlspc->frmsegecodte,$lv_default); ?></div>
										<label class="col-sm-2 control-label">Ecoestructura</label>
										<div class="col-sm-4"><?= gethtml('frmsegecoeco', array(''=>'','0'=>'normal','1'=>'hiperecogenicidad focal','2'=>'Hiperecogenicidad difusa'), $vew_patevlspc->frmsegecoeco, $lv_default); ?></div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br>

						
						<h2 id="seguimiento"><span class="fas fa-angle-right"></span> &Uacute;ltima Elastografia</h2><br><br>
						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Fecha de Seguimiento</label>
										<div class="col-sm-4"><?= getHtml('frmsegeladte','docdte',$vew_patevlspc->frmsegeladte,$lv_default); ?></div>
										<label class="col-sm-2 control-label">Fibroscan CAP esteatosis (%)</label>
										<div class="col-sm-4"><?= getHtml('frmsegelafie','docnum0601',$vew_patevlspc->frmsegelafie,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Metodo de elastografia</label>
										<div class="col-sm-4"><?= gethtml('frmsegelamtd', array(''=>'','0'=>'Ninguno','1'=>'Fibroscan','2'=>'ARFI','3'=>'Shear Wave','4'=>'MR-E'), $vew_patevlspc->frmsegelamtd, $lv_default); ?></div>
										<label class="col-sm-2 control-label">Elastogragia (kPa)</label>
										<div class="col-sm-4"><?= getHtml('frmsegelaela','docnum0601',$vew_patevlspc->frmsegelaela,$lv_default); ?></div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Elastografia: Estad&iacute;o de Fibrosis</label>
										<div class="col-sm-4"><?= gethtml('frmsegelaefi',array(''=>'','0'=>'0','1'=>'1','2'=>'2','3'=>'3','4'=>'4'),$vew_patevlspc->frmsegelaefi, $lv_default); ?></div>
										<label class="col-sm-2 control-label">Fibroscan CAP (db/m)</label>
										<div class="col-sm-4"><?= getHtml('frmsegelafib','docnum0601',$vew_patevlspc->frmsegelafib,$lv_default); ?></div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>

						
						

						
						<h2 id="seguimiento-04"><span class="fas fa-angle-right"></span> Eventos Cl&iacute;nicos Finales</h2><br><br>
						
						
						
						<table class="table table-striped table-condensed">
							<tbody>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Diabetes</label>
										<div class="col-sm-4"><?= gethtml('frmsegevtdbt', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmsegevtdbt, $lv_default); ?><br>
											<div id="frmsegevtdbt_div">
												<table><tr><td>Indique Fecha</td><td><?= gethtml('frmsegevtdbtdte','docdte',$vew_patevlspc->frmsegevtdbtdte,$lv_default); ?></td></tr></table>
											</div>
										</div>
										<label class="col-sm-2 control-label">HTA</label>
										<div class="col-sm-4"><?= gethtml('frmsegevthta', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmsegevthta, $lv_default); ?><br>
											<div id="frmsegevthta_div">
												<table><tr><td>Indique Fecha</td><td><?= gethtml('frmsegevthtadte','docdte',$vew_patevlspc->frmsegevthtadte,$lv_default); ?></td></tr></table>
											</div>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Evento Cardiovascular</label>
										<div class="col-sm-4"><?= gethtml('frmsegevtecv', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmsegevtecv, $lv_default); ?><br>
											<div id="frmsegevtecv_div">
												<table><tr><td>Indique Fecha</td><td><?= gethtml('frmsegevtecvdte','docdte',$vew_patevlspc->frmsegevtecvdte,$lv_default); ?></td></tr></table>
											</div>
										</div>
										<label class="col-sm-2 control-label">Realiz&oacute; alg&uacute;n tipo de cirug&iacute;a Bari&aacute;trica</label>
										<div class="col-sm-4"><?= gethtml('frmsegevtbar', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmsegevtbar, $lv_default); ?><br>
											<div id="frmsegevtbar_div">
												<table><tr><td>Indique Fecha</td><td><?= gethtml('frmsegevtcirdte','docdte',$vew_patevlspc->frmsegevtbardte,$lv_default); ?></td></tr></table>
											</div>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Cirrosis durante el seguimiento</label>
										<div class="col-sm-4"><?= gethtml('frmsegevtcir', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmsegevtcir, $lv_default); ?><br>
											<div id="frmsegevtcir_div">
												<table><tr><td>Indique Fecha</td><td><?= gethtml('frmsegevtcirdte','docdte',$vew_patevlspc->frmsegevtcirdte,$lv_default); ?></td></tr></table>
											</div>
										</div>
										<label class="col-sm-2 control-label">Descompensacion de  cirrosis durante Seguimiento</label>
										<div class="col-sm-4"><?= gethtml('frmsegevtcid', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmsegevtcid, $lv_default); ?><br>
											<div id="frmsegevtcid_div">
												<table>
													<tr><td>Indique Fecha</td><td><?= gethtml('frmsegevtciddte','docdte',$vew_patevlspc->frmsegevtciddte,$lv_default); ?></td></tr>
													<tr><td colspan="2"><br>Tipo de descompensaci&oacute;n<br>
														<label><input type="checkbox" id="frmsegevttpd" name="frmsegevttpd001" <?= ($vew_patevlspc->frmsegevttpd001!=''?'checked':''); ?>> Hemorragia Varicial</label><br>
														<label><input type="checkbox" id="frmsegevttpd" name="frmsegevttpd002" <?= ($vew_patevlspc->frmsegevttpd002!=''?'checked':''); ?>> Ascitis</label><br>
														<label><input type="checkbox" id="frmsegevttpd" name="frmsegevttpd003" <?= ($vew_patevlspc->frmsegevttpd003!=''?'checked':''); ?>> Hepatocarcinoma</label><br>
														<label><input type="checkbox" id="frmsegevttpd" name="frmsegevttpd004" <?= ($vew_patevlspc->frmsegevttpd004!=''?'checked':''); ?>> Encefalopat&iacute;a</label><br>
													</td></tr>
												</table>
											</div>
										</div>
									</div>
								</td></tr>
								<tr><td>
									<div class="form-group tmss-form-group">
										<label class="col-sm-2 control-label">Trasplante Hepatico durante seguimiento</label>
										<div class="col-sm-4"><?= gethtml('frmsegevttph', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmsegevttph, $lv_default); ?><br>
											<div id="frmsegevttph_div" class="hidden">
												<table><tr><td>Indique Fecha</td><td><?= gethtml('frmsegevttphdte','docdte',$vew_patevlspc->frmsegevttphdte,$lv_default); ?></td></tr></table>
											</div>
										</div>
										<label class="col-sm-2 control-label">Obito durante el seguimiento</label>
										<div class="col-sm-4"><?= gethtml('frmsegevtobt', array(''=>'','0'=>'No','1'=>'Si'), $vew_patevlspc->frmsegevtobt, $lv_default); ?>
											<div id="frmsegevtobt_div">
												<table>
													<tr><td>Indique Fecha</td><td><?= gethtml('frmsegevtobtdte','docdte',$vew_patevlspc->frmsegevtobtdte,$lv_default); ?></td></tr>
													<tr><td>Causa de &Oacute;bito</td><td><?= gethtml('frmsegevtobc',array(''=>'','Hepatica'=>'Hep&aacute;tica','Cardiovascular'=>'Cardiovascular','Cancer'=>'Cancer','Otra'=>'Otra'), $vew_patevlspc->frmsegevtobc, $lv_default); ?></td></tr>
													<tr id="frmsegevtobcotr_div"><td>Indique</td><td><?= getHtml('frmsegevtobcotr','doccmt1x50',$vew_patevlspc->frmsegevtobcotr,$lv_default); ?></td></tr>
												</table>
											</div>
										</div>
									</div>
								</td></tr>
							</tbody>
						</table>
						<br><br>
						
						<?php
							}
						?>
						
					</div> <!-- /bs-docs-section -->
				</div> <!-- /col-md-9 -->
				<div class="col-md-3">
					<nav class="bs-docs-sidebar hidden-print hidden-sm hidden-xs">
						<ul class="nav nav-stacked bs-docs-sidenav" id="sidebar">
							<li><a href="#paciente">Paciente</a>
								<ul class="nav bs-docs-sidenav">
									<li><a href="#paciente-01">Datos Filiatorios</a></li>
									<li><a href="#paciente-02">Datos Antropom&eacute;tricos</a></li>
									<li><a href="#paciente-03">H&aacute;bitos</a></li>
								</ul>
							</li>
							<li><a href="#patologia">Basal</a>
								<ul class="nav bs-docs-sidenav">
                  <li><a href="#patologia-01"> Diabetes </a></li>
									<li><a href="#patologia-02">Par&aacute;metros del Sindrome Metab&oacute;lico</a></li>
									<li><a href="#patologia-03">Par&aacute;metros Bioqu&iacute;micos</a></li>
									<li><a href="#patologia-04">Scores Predictivos</a><li>
									<li><a href="#patologia-05">Ecograf&iacute;a</a><li>
									<li><a href="#patologia-06">Elastograf&iacute;a</a><li>
									<li><a href="#patologia-07">Histolog&iacute;a</a><li>
								</ul>
							</li>
							<?php
								if($vew_data->patcod!=''){
							?>
							<li><a href="#seguimiento">Seguimiento</a>
								<ul class="nav bs-docs-sidenav">
									<!--
									<li><a href="#seguimiento-01">Datos Antropom&eacute;tricos</a></li>
									<li><a href="#seguimiento-02">Par&aacute;metros Bioqu&iacute;micos</a></li>
									<li><a href="#segiimiento-03">Scores Predictivos</a></li>
									-->
									<li><a href="#seguimiento-04">Eventos Cl&iacute;nicos Finales</a></li>
								</ul>
							</li>
							<?php
								}
							?>
							<hr>
							<h2>NASH</h2>
							<hr>
							<img class="img-responsive" src="https://temasis.com.ar/lalrean-org/library/images/logos/logolalrean.png">
						</ul>
					</nav>
				</div> <!-- /col-md-3 -->
				
			</div> <!-- /row -->
		</div> <!-- /container -->
	</form>
	<script>
		/* ----------------------------
		   F O R M U L A S
		------------------------------- */
		
		
		// AST / ALT
		function <?= $lv_sec; ?>_calc_astalt( lp_fld, lp_ast, lp_alt ) {
			lp_ast = (lp_ast==undefined || lp_ast==""?"0":lp_ast);
			lp_alt = (lp_alt==undefined || lp_alt==""?"0":lp_alt);
			var lv_astalt = ( Number(lp_alt)==0 || Number(lp_ast)==0 ? '' : (Number(lp_ast) / Number(lp_alt)).toFixed(1) );
			$(lp_fld).prop("value",lv_astalt);
		}
		function <?= $lv_sec; ?>_attachEvent_astalt( lp_fld ) {
			$("#<?= $lv_sec; ?> #"+lp_fld).on("change",function(){
				var lv_dte = "";
				if( $(this).prop("id").split("_").length>1 ){lv_dte = "_"+$(this).prop("id").split("_")[1];}
				<?= $lv_sec; ?>_calc_astalt(
					$("#<?= $lv_sec; ?> #frmsegscrast"+lv_dte),
					$("#<?= $lv_sec; ?> #frmsegbioast"+lv_dte).prop("value"),
					$("#<?= $lv_sec; ?> #frmsegbioalt"+lv_dte).prop("value")
				);
			});
		}
		
		
		// HOMA
		function <?= $lv_sec; ?>_calc_homa( lp_fld, lp_ins, lp_glu ) {
			lp_ins = (lp_ins==undefined || lp_ins==""?"0":lp_ins);
			lp_glu = (lp_glu==undefined || lp_glu==""?"0":lp_glu);
			var lv_homa = ( Number(lp_ins)==0 || Number(lp_glu)==0 ? '' : (Number(lp_ins) * Number(lp_glu) / 405).toFixed(1) );
			$(lp_fld).prop("value",lv_homa);
		}
		function <?= $lv_sec; ?>_attachEvent_homa( lp_fld ) {
			$("#<?= $lv_sec; ?> #"+lp_fld).on("change",function(){
				var lv_dte = "";
				if( $(this).prop("id").split("_").length>1 ){lv_dte = "_"+$(this).prop("id").split("_")[1];}
				<?= $lv_sec; ?>_calc_homa(
					$("#<?= $lv_sec; ?> #frmsegbiohma"+lv_dte),
					$("#<?= $lv_sec; ?> #frmsegbioins"+lv_dte).prop("value"),
					$("#<?= $lv_sec; ?> #frmsegbioglu"+lv_dte).prop("value")
				);
			});
		}
		
		
		// APRI
		function <?= $lv_sec; ?>_calc_apri( lp_fld, lp_ast, lp_astmax, lp_plq ) {
			lp_ast = (lp_ast==undefined || lp_ast==""?"0":lp_ast);
			lp_astmax = (lp_astmax==undefined || lp_ast==""?"0":lp_astmax);
			lp_plq = (lp_plq==undefined || lp_plq==""?"0":lp_plq);
			var lv_apri = ( Number(lp_ast)==0 || Number(lp_plq)==0 ? '' : (Number(lp_ast) / Number(lp_astmax) / Number(lp_plq) * 100).toFixed(1) );
			$(lp_fld).prop("value",lv_apri);
		}
		function <?= $lv_sec; ?>_attachEvent_apri( lp_fld ) {
			$("#<?= $lv_sec; ?> #"+lp_fld).on("change",function(){
				var lv_dte = "";
				if( $(this).prop("id").split("_").length>1 ){lv_dte = "_"+$(this).prop("id").split("_")[1];}
				<?= $lv_sec; ?>_calc_apri(
					$("#<?= $lv_sec; ?> #frmsegscrapr"+lv_dte),
					$("#<?= $lv_sec; ?> #frmsegbioast"+lv_dte).prop("value"),
					$("#<?= $lv_sec; ?> #frmsegbioastmax"+lv_dte).prop("value"),
					$("#<?= $lv_sec; ?> #frmsegbioplq"+lv_dte).prop("value")
				);
			});
		}
		
		
		// FIB-4
		function <?= $lv_sec; ?>_calc_fib4( lp_fld, lp_ast, lp_alt, lp_plq, lp_age ) {
			lp_ast = (lp_ast==undefined || lp_ast==""?"0":lp_ast);
			lp_alt = (lp_alt==undefined || lp_alt==""?"0":lp_alt);
			lp_plq = (lp_plq==undefined || lp_plq==""?"0":lp_plq);
			lp_age = (lp_age==undefined || lp_age==""?"0":lp_age);
			var lv_fib4 = ( Number(lp_ast)==0 || Number(lp_alt)==0 || Number(lp_plq)==0 || Number(lp_age)==0 ? '' : ( (Number(lp_age) * Number(lp_ast))/(Number(lp_plq)*Math.sqrt(Number(lp_alt))) ).toFixed(2) );
			$(lp_fld).prop("value",lv_fib4);
		}
		function <?= $lv_sec; ?>_attachEvent_fib4( lp_fld ) {
			$("#<?= $lv_sec; ?> #"+lp_fld).on("change",function(){
				var lv_dte = "";
				if( $(this).prop("id").split("_").length>1 ){lv_dte = "_"+$(this).prop("id").split("_")[1];}
				<?= $lv_sec; ?>_calc_fib4(
					$("#<?= $lv_sec; ?> #frmsegscrfib"+lv_dte),
					$("#<?= $lv_sec; ?> #frmsegbioast"+lv_dte).prop("value"),
					$("#<?= $lv_sec; ?> #frmsegbioalt"+lv_dte).prop("value"),
					$("#<?= $lv_sec; ?> #frmsegbioplq"+lv_dte).prop("value"),
					$("#<?= $lv_sec; ?> #frmpatyth"+lv_dte).prop("value")
				);
			});
		}
		
		
		// NAFLD
		function <?= $lv_sec; ?>_calc_nafld( lp_fld, lp_ast, lp_alt, lp_plq, lp_age, lp_alb, lp_dia, lp_imc ) {
			lp_ast = (lp_ast==undefined || lp_ast==""?"0":lp_ast);
			lp_alt = (lp_alt==undefined || lp_alt==""?"0":lp_alt);
			lp_plq = (lp_plq==undefined || lp_plq==""?"0":lp_plq);
			lp_age = (lp_age==undefined || lp_age==""?"0":lp_age);
			lp_alb = (lp_alb==undefined || lp_alb==""?"0":lp_alb);
			lp_dia = (lp_dia==undefined || lp_dia==""?"":lp_dia);
			lp_imc = (lp_imc==undefined || lp_imc==""?"0":lp_imc);
			var lv_nafld = (Number(lp_ast)==0 || Number(lp_alt)==0 || Number(lp_plq)==0 || Number(lp_age)==0 || Number(lp_alb)==0 || lp_dia=="" || Number(lp_imc)==0 ? '' : ( -1.675 + 0.037 * Number(lp_age) + 0.094 * Number(lp_imc) + 1.13 * Number(lp_dia) + 0.99 * (Number(lp_ast)/Number(lp_alt)) - 0.013 * Number(lp_plq) - 0.66 * Number(lp_alb)).toFixed(3) );
			$(lp_fld).prop("value",lv_nafld);
		}
		function <?= $lv_sec; ?>_attachEvent_nafld( lp_fld ) {
			$("#<?= $lv_sec; ?> #"+lp_fld).on("change",function(){
				var lv_dte = "";
				if( $(this).prop("id").split("_").length>1 ){lv_dte = "_"+$(this).prop("id").split("_")[1];}
				<?= $lv_sec; ?>_calc_nafld(
					$("#<?= $lv_sec; ?> #frmsegscrnaf"+lv_dte),
					$("#<?= $lv_sec; ?> #frmsegbioast"+lv_dte).prop("value"),
					$("#<?= $lv_sec; ?> #frmsegbioalt"+lv_dte).prop("value"),
					$("#<?= $lv_sec; ?> #frmsegbioplq"+lv_dte).prop("value"),
					$("#<?= $lv_sec; ?> #frmpatyth"+lv_dte).prop("value"),
					$("#<?= $lv_sec; ?> #frmsegbioalb"+lv_dte).prop("value"),
					$("#<?= $lv_sec; ?> #frmbasprmdia").prop("value"),
					$("#<?= $lv_sec; ?> #patsegimc"+lv_dte).prop("value")
				);
			});
		}
		
		
		// I M C
		function <?= $lv_sec; ?>_calc_imc( lp_fld, lp_pes, lp_alt ) {
			lp_pes = (lp_pes==undefined || lp_pes==""?"0":lp_pes);
			lp_alt = (lp_alt==undefined || lp_alt==""?"0":lp_alt);
			var lv_imc = ( Number(lp_pes)==0 || Number(lp_alt)==0? 0 : Number(lp_pes) / Math.pow(Number(lp_alt)/100,2) ).toFixed(2);
			$(lp_fld).prop("value",lv_imc);
		}
		function <?= $lv_sec; ?>_attachEvent_imc( lp_fld ) {
			$("#<?= $lv_sec; ?> #"+lp_fld).on("change",function(){
				var lv_dte = "";
				if( $(this).prop("id").split("_").length>1 ){lv_dte = "_"+$(this).prop("id").split("_")[1];}
				<?= $lv_sec; ?>_calc_imc(
					$("#<?= $lv_sec; ?> #patsegimc"+lv_dte),
					$("#<?= $lv_sec; ?> #patsegwgt"+lv_dte).prop("value"),
					$("#<?= $lv_sec; ?> #patseghgh"+lv_dte).prop("value")
				);
			});
		}


		// BARD
		function <?= $lv_sec; ?>_calc_bard( lp_fld, lp_ast, lp_alt, lp_dia, lp_imc ) {
			lp_ast = (lp_ast==undefined || lp_ast==""?"0":lp_ast);
			lp_alt = (lp_alt==undefined || lp_alt==""?"0":lp_alt);
			lp_dia = (lp_dia==undefined || lp_dia==""?"":lp_dia);
			lp_imc = (lp_imc==undefined || lp_imc==""?"0":lp_imc);
			var lv_astalt = ( Number(lp_alt)==0 || Number(lp_ast)==0 ? 0 : Number(lp_ast) / Number(lp_alt) );
			var lv_bard = (lv_astalt==0 || lp_dia=="" || Number(lp_imc)==0 ? '' : ( (Number(lp_imc)>=28 ?1:0)+(lv_astalt>=0.8?2:0)+Number(lp_dia) ).toFixed(0) );
			$(lp_fld).prop("value",lv_bard);
		}
		function <?= $lv_sec; ?>_attachEvent_bard( lp_fld ) {
			$("#<?= $lv_sec; ?> #"+lp_fld).on("change",function(){
				var lv_dte = "";
				if( $(this).prop("id").split("_").length>1 ){lv_dte = "_"+$(this).prop("id").split("_")[1];}
				<?= $lv_sec; ?>_calc_bard(
					$("#<?= $lv_sec; ?> #frmsegscrbrd"+lv_dte),
					$("#<?= $lv_sec; ?> #frmsegbioast"+lv_dte).prop("value"),
					$("#<?= $lv_sec; ?> #frmsegbioalt"+lv_dte).prop("value"),
					$("#<?= $lv_sec; ?> #frmbasprmdia").prop("value"),
					$("#<?= $lv_sec; ?> #patsegimc"+lv_dte).prop("value")
				);
			});
		}
		
		
		$("#<?= $lv_sec; ?> #frmbasbioast").on("change",function(e){
			<?= $lv_sec; ?>_calc_astalt( $("#<?= $lv_sec; ?> #frmbasscrast"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value") );
			<?= $lv_sec; ?>_calc_apri( $("#<?= $lv_sec; ?> #frmbasscrapr"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioastmax").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioplq").prop("value") );
			<?= $lv_sec; ?>_calc_fib4( $("#<?= $lv_sec; ?> #frmbasscrfib"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioplq").prop("value"), $("#<?= $lv_sec; ?> #frmpatyth").prop("value") );	
			<?= $lv_sec; ?>_calc_nafld( $("#<?= $lv_sec; ?> #frmbasscrnaf"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioplq").prop("value"), $("#<?= $lv_sec; ?> #frmpatyth").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalb").prop("value"), $("#<?= $lv_sec; ?> #frmbasprmdia").prop("value"), $("#<?= $lv_sec; ?> #patbasimc").prop("value") );
			<?= $lv_sec; ?>_calc_bard( $("#<?= $lv_sec; ?> #frmbasscrbrd"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasprmdia").prop("value"), $("#<?= $lv_sec; ?> #patbasimc").prop("value") );
		});
		$("#<?= $lv_sec; ?> #frmbasbioastmax").on("change",function(e){
			<?= $lv_sec; ?>_calc_apri( $("#<?= $lv_sec; ?> #frmbasscrapr"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioastmax").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioplq").prop("value") );
		});
		$("#<?= $lv_sec; ?> #frmbasbioalt").on("change",function(e){
			<?= $lv_sec; ?>_calc_astalt( $("#<?= $lv_sec; ?> #frmbasscrast"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value") );												
			<?= $lv_sec; ?>_calc_fib4( $("#<?= $lv_sec; ?> #frmbasscrfib"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioplq").prop("value"), $("#<?= $lv_sec; ?> #frmpatyth").prop("value") );
			<?= $lv_sec; ?>_calc_nafld( $("#<?= $lv_sec; ?> #frmbasscrnaf"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioplq").prop("value"), $("#<?= $lv_sec; ?> #frmpatyth").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalb").prop("value"), $("#<?= $lv_sec; ?> #frmbasprmdia").prop("value"), $("#<?= $lv_sec; ?> #patbasimc").prop("value") );
			<?= $lv_sec; ?>_calc_bard( $("#<?= $lv_sec; ?> #frmbasscrbrd"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasprmdia").prop("value"), $("#<?= $lv_sec; ?> #patbasimc").prop("value") );
		});
		$("#<?= $lv_sec; ?> #frmbasbioplq").on("change",function(e){
			<?= $lv_sec; ?>_calc_apri( $("#<?= $lv_sec; ?> #frmbasscrapr"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioastmax").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioplq").prop("value") );
			<?= $lv_sec; ?>_calc_fib4( $("#<?= $lv_sec; ?> #frmbasscrfib"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioplq").prop("value"), $("#<?= $lv_sec; ?> #frmpatyth").prop("value") );
			<?= $lv_sec; ?>_calc_nafld( $("#<?= $lv_sec; ?> #frmbasscrnaf"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioplq").prop("value"), $("#<?= $lv_sec; ?> #frmpatyth").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalb").prop("value"), $("#<?= $lv_sec; ?> #frmbasprmdia").prop("value"), $("#<?= $lv_sec; ?> #patbasimc").prop("value") );
		});
		$("#<?= $lv_sec; ?> #frmpatyth").on("change",function(e){
			<?= $lv_sec; ?>_calc_fib4( $("#<?= $lv_sec; ?> #frmbasscrfib"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioplq").prop("value"), $("#<?= $lv_sec; ?> #frmpatyth").prop("value") );
			<?= $lv_sec; ?>_calc_nafld( $("#<?= $lv_sec; ?> #frmbasscrnaf"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioplq").prop("value"), $("#<?= $lv_sec; ?> #frmpatyth").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalb").prop("value"), $("#<?= $lv_sec; ?> #frmbasprmdia").prop("value"), $("#<?= $lv_sec; ?> #patbasimc").prop("value") );
		});
		$("#<?= $lv_sec; ?> #patbaswgt").on("change",function(e){
			<?= $lv_sec; ?>_calc_imc( $("#<?= $lv_sec; ?> #patbasimc"), $("#<?= $lv_sec; ?> #patbaswgt").prop("value"), $("#<?= $lv_sec; ?> #patbashgh").prop("value") );
			<?= $lv_sec; ?>_calc_nafld( $("#<?= $lv_sec; ?> #frmbasscrnaf"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioplq").prop("value"), $("#<?= $lv_sec; ?> #frmpatyth").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalb").prop("value"), $("#<?= $lv_sec; ?> #frmbasprmdia").prop("value"), $("#<?= $lv_sec; ?> #patbasimc").prop("value") );
			<?= $lv_sec; ?>_calc_bard( $("#<?= $lv_sec; ?> #frmbasscrbrd"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasprmdia").prop("value"), $("#<?= $lv_sec; ?> #patbasimc").prop("value") );
		});
		$("#<?= $lv_sec; ?> #patbashgh").on("change",function(e){
			<?= $lv_sec; ?>_calc_imc( $("#<?= $lv_sec; ?> #patbasimc"), $("#<?= $lv_sec; ?> #patbaswgt").prop("value"), $("#<?= $lv_sec; ?> #patbashgh").prop("value") );			
			<?= $lv_sec; ?>_calc_nafld( $("#<?= $lv_sec; ?> #frmbasscrnaf"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioplq").prop("value"), $("#<?= $lv_sec; ?> #frmpatyth").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalb").prop("value"), $("#<?= $lv_sec; ?> #frmbasprmdia").prop("value"), $("#<?= $lv_sec; ?> #patbasimc").prop("value") );
			<?= $lv_sec; ?>_calc_bard( $("#<?= $lv_sec; ?> #frmbasscrbrd"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasprmdia").prop("value"), $("#<?= $lv_sec; ?> #patbasimc").prop("value") );
		});
		$("#<?= $lv_sec; ?> #frmbasprmdia").on("change",function(e){
			<?= $lv_sec; ?>_calc_nafld( $("#<?= $lv_sec; ?> #frmbasscrnaf"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioplq").prop("value"), $("#<?= $lv_sec; ?> #frmpatyth").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalb").prop("value"), $("#<?= $lv_sec; ?> #frmbasprmdia").prop("value"), $("#<?= $lv_sec; ?> #patbasimc").prop("value") );
			<?= $lv_sec; ?>_calc_bard( $("#<?= $lv_sec; ?> #frmbasscrbrd"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasprmdia").prop("value"), $("#<?= $lv_sec; ?> #patbasimc").prop("value") );
		});
		$("#<?= $lv_sec; ?> #frmbasbioalb").on("change",function(e){
			<?= $lv_sec; ?>_calc_nafld( $("#<?= $lv_sec; ?> #frmbasscrnaf"), $("#<?= $lv_sec; ?> #frmbasbioast").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalt").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioplq").prop("value"), $("#<?= $lv_sec; ?> #frmpatyth").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioalb").prop("value"), $("#<?= $lv_sec; ?> #frmbasprmdia").prop("value"), $("#<?= $lv_sec; ?> #patbasimc").prop("value") );
		});
		$("#<?= $lv_sec; ?> #frmbasbioins").on("change",function(e){
			<?= $lv_sec; ?>_calc_homa( $("#<?= $lv_sec; ?> #frmbasbiohma"), $("#<?= $lv_sec; ?> #frmbasbioins").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioglu").prop("value") );
		});
		$("#<?= $lv_sec; ?> #frmbasbioglu").on("change",function(e){
			<?= $lv_sec; ?>_calc_homa( $("#<?= $lv_sec; ?> #frmbasbiohma"), $("#<?= $lv_sec; ?> #frmbasbioins").prop("value"), $("#<?= $lv_sec; ?> #frmbasbioglu").prop("value") );
		});
		

		$("#<?= $lv_sec; ?> #frmbasprmado").on("change",function(e){
			if($(this).prop("value")=="1"){
			$("#<?= $lv_sec; ?> #frmbasprmado_div").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #frmbasprmado_div").addClass("hidden");
			}
		});
		$("#<?= $lv_sec; ?> #frmsegevtdbt").on("change",function(e){
			if($(this).prop("value")=="1"){
			$("#<?= $lv_sec; ?> #frmsegevtdbt_div").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #frmsegevtdbt_div").addClass("hidden");
			}
		});
		$("#<?= $lv_sec; ?> #frmsegevthta").on("change",function(e){
			if($(this).prop("value")=="1"){
			$("#<?= $lv_sec; ?> #frmsegevthta_div").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #frmsegevthta_div").addClass("hidden");
			}
		});
		$("#<?= $lv_sec; ?> #frmsegevtecv").on("change",function(e){
			if($(this).prop("value")=="1"){
			$("#<?= $lv_sec; ?> #frmsegevtecv_div").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #frmsegevtecv_div").addClass("hidden");
			}
		});
		$("#<?= $lv_sec; ?> #frmsegevtbar").on("change",function(e){
			if($(this).prop("value")=="1"){
			$("#<?= $lv_sec; ?> #frmsegevtbar_div").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #frmsegevtbar_div").addClass("hidden");
			}
		});
		$("#<?= $lv_sec; ?> #frmsegevtcir").on("change",function(e){
			if($(this).prop("value")=="1"){
			$("#<?= $lv_sec; ?> #frmsegevtcir_div").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #frmsegevtcir_div").addClass("hidden");
			}
		});
		$("#<?= $lv_sec; ?> #frmsegevtcid").on("change",function(e){
			if($(this).prop("value")=="1"){
			$("#<?= $lv_sec; ?> #frmsegevtcid_div").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #frmsegevtcid_div").addClass("hidden");
			}
		});
		$("#<?= $lv_sec; ?> #frmsegevttph").on("change",function(e){
			if($(this).prop("value")=="1"){
			$("#<?= $lv_sec; ?> #frmsegevttph_div").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #frmsegevttph_div").addClass("hidden");
			}
		});
		$("#<?= $lv_sec; ?> #frmsegevtobt").on("change",function(e){
			if($(this).prop("value")=="1"){
			$("#<?= $lv_sec; ?> #frmsegevtobt_div").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #frmsegevtobt_div").addClass("hidden");
			}
		});
		$("#<?= $lv_sec; ?> #frmsegevtobc").on("change",function(e){
			if($(this).prop("value")=="Otra"){
			$("#<?= $lv_sec; ?> #frmsegevtobcotr_div").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #frmsegevtobcotr_div").addClass("hidden");
			}
		});
    $("#<?= $lv_sec; ?> #frmbasprmdia").on("change", function() {
  		if( $(this).val() == 1 ) {
      	$("#<?= $lv_sec; ?> #basprmdia_tblbdy").removeClass("hidden");
    	} else {
       	$("#<?= $lv_sec; ?> #basprmdia_tblbdy").addClass("hidden"); 
      }                                  
   	});
		$("#<?= $lv_sec; ?> #frmbasprmtin").on("change",function(e){
			if($(this).prop("value")=="1"){
			$("#<?= $lv_sec; ?> #frmbasprmtin_div").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #frmbasprmtin_div").addClass("hidden");
			}
		});
		$("#<?= $lv_sec; ?> #frmbasprmtes").on("change",function(e){
			if($(this).prop("value")=="1"){
			$("#<?= $lv_sec; ?> #frmbasprmtes_div").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #frmbasprmtes_div").addClass("hidden");
			}
		});
    		$("#<?= $lv_sec; ?> #frmbasprmtah").on("change",function(e){
			if($(this).prop("value")=="1"){
			$("#<?= $lv_sec; ?> #frmbasprmtah_div").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #frmbasprmtah_div").addClass("hidden");
			}
		});
    		$("#<?= $lv_sec; ?> #frmbasprmvit").on("change",function(e){
			if($(this).prop("value")=="1"){
			$("#<?= $lv_sec; ?> #frmbasprmvit_div").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #frmbasprmvit_div").addClass("hidden");
			}
		});
    

		
		tmssLoadScript("toggle",function(){
			$("#<?= $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: "success", offstyle: "default", on: "Si", off: "No", size: "small" });
				$(this).trigger("change");
			});
		});

		$(function(){
			$("#<?= $lv_sec; ?> #frmbasbioast").trigger("change");
			$("#<?= $lv_sec; ?> #frmbasbioastmax").trigger("change");
			$("#<?= $lv_sec; ?> #frmbasbioalt").trigger("change");
			$("#<?= $lv_sec; ?> #frmbasbioplq").trigger("change");
			$("#<?= $lv_sec; ?> #frmpatyth").trigger("change");
			$("#<?= $lv_sec; ?> #patbaswgt").trigger("change");
			$("#<?= $lv_sec; ?> #patbashgh").trigger("change");
			$("#<?= $lv_sec; ?> #frmbasprmdia").trigger("change");
			$("#<?= $lv_sec; ?> #frmbasbioalb").trigger("change");
			$("#<?= $lv_sec; ?> #frmbasbioins").trigger("change");
			$("#<?= $lv_sec; ?> #frmbasbioglu").trigger("change");
			$("#<?= $lv_sec; ?> #frmbasprmado").trigger("change");			
			$("#<?= $lv_sec; ?> #frmsegevtdbt").trigger("change");
			$("#<?= $lv_sec; ?> #frmsegevthta").trigger("change");
			$("#<?= $lv_sec; ?> #frmsegevtecv").trigger("change");
			$("#<?= $lv_sec; ?> #frmsegevtbar").trigger("change");
			$("#<?= $lv_sec; ?> #frmsegevtcir").trigger("change");
			$("#<?= $lv_sec; ?> #frmsegevtcid").trigger("change");
			$("#<?= $lv_sec; ?> #frmsegevttph").trigger("change");
			$("#<?= $lv_sec; ?> #frmsegevtobt").trigger("change");
			$("#<?= $lv_sec; ?> #frmsegevtobc").trigger("change");
      $("#<?= $lv_sec; ?> #frmbasprmdia").trigger("change");
      $("#<?= $lv_sec; ?> #frmbasprmtin").trigger("change");
      $("#<?= $lv_sec; ?> #frmbasprmtes").trigger("change");
      $("#<?= $lv_sec; ?> #frmbasprmtah").trigger("change");
      $("#<?= $lv_sec; ?> #frmbasprmvit").trigger("change");
		});
	</script>
	<script>
		toastr.options.timeOut= 5000;
		<?php
			if ( $vew_data->prscod=='' ) { echo 'toastr.error( "No est&aacute; registrado como prestador. Consulte con el administrador del sistema." );'; }
			if ( $vew_data->spccod=='' ) { echo 'toastr.error( "Su registro de prestador NO tiene especialidad asignada. Consulte con el administrador del sistema." );'; }
		?>
		
		$("#<?= $lv_sec; ?> #btnaddflw").on("click",function(e){
			e.preventDefault();
			var lv_data = "<div class='container-fluid'><p>Indique una nueva fecha de seguimiento.</p><br><div class='row'><label class='control-label col-sm-2'>Fecha</label><div class='col-sm-10'>";
			lv_data += "<div class='input-group date' data-date-format='dd/mm/yyyy' data-date-autoclose='true' data-date-today-highlight='true' data-date-today-btn='true' data-date-show-on-focus='false' data-date-language='es' data-date-enable-on-readonly='false' data-date-clear-btn='true' data-provide='datepicker' data-date-week-start='0'><input type='TEXT' id='flwdte' name='flwdte' value='' maxlength='10' class='form-control'><span class='input-group-addon'><i class='fa fa-calendar'></i></span></div>";
			lv_data += "</div></div><br><p>Al indicar una fecha se grabaran todos los datos del formulario actual.</p></div>";
			BootstrapDialog.show({
				title: "Nuevo Seguimiento",
				message: $(lv_data),
				buttons: [{ label: "Cancelar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
									{	label: "Agregar y Grabar", cssClass: "btn-success",	action: function(dialogItself){ 
										var lv_dte = dialogItself.getModalBody().find("#flwdte").prop("value");
										var lv_pstdat = [{name:"patcod",value:"<?= $vew_data->patcod; ?>"},{name:"flwdte",value:lv_dte}];
										tmssCallProcess("?prg=zcuau1_nash&act=chkDate",lv_pstdat,function(data){
											$("#<?= $lv_sec; ?> #flwdte").prop("value",lv_dte);
											<?= $lv_sec; ?>_fnc({action: '00'});
											dialogItself.close();
										});
									}}],
				onshown: function(dialogItself){
					dialogItself.getModalBody().find("#flwdte").on("blur", function(e){ e.preventDefault(); $(this).prop("value",formatdate(this)); }); 
				}
			});
		});
		
		tmssLoadScript("typeahead",function(){		

			// lndtxt
			$("#<?= $lv_sec; ?> #lndtxt").typeahead({
					onSelectAjaxData: function(data) { $("#<?= $lv_sec; ?> #lndcod").prop("value", data.data.lndcod); },
					ajax: {
						url: "?prg=grladrlnd&act=18",
						timeout: 500,
						displayField: "lndtxt",
						valueField: "lndtxt",
						triggerLength: 1,
						method: "get",
						loadingClass: "fa fa-spinner",
						preDispatch: function (query) { return {prm_lndtxt: query}; },
						preProcess: function (data) { return (data.length==0?false:data); }
					}
			}).on("keyup", function(){ if($(this).prop("value")==""){$("#<?= $lv_sec; ?> #lndtxt").prop("value","");$("#<?= $lv_sec; ?> #lndregcod").prop("value","");$("#<?= $lv_sec; ?> #lndregtxt").prop("value","");} })
				.next().next("span").children("a:first").on("click", function(evt) {
					tmssPopup('Paises','index.php?prg=grladrlnd&prm_vewcod=VEW_GRL_DAT_LND_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[lndcod:lndcod],[lndtxt:lndtxt],[lndregcod:empty],[lndregtxt:empty]');
					evt.preventDefault();
			});
			
			// lndregtxt
			$("#<?= $lv_sec; ?> #lndregtxt").typeahead({
					onSelectAjaxData: function(data) { $("#<?= $lv_sec; ?> #lndregcod").prop("value", data.data.lndregcod); },
					ajax: {
						url: "?prg=grladrlndreg&act=18",
						timeout: 500,
						displayField: "lndregtxt",
						valueField: "lndregtxt",
						triggerLength: 1,
						method: "get",
						loadingClass: "fa fa-spinner",
						preDispatch: function (query) { return {prm_lndcod: $("#<?= $lv_sec; ?> #lndcod").prop("value"), prm_lndregtxt: query}; },
						preProcess: function (data) { return (data.length==0?false:data); }
					}
			}).on("keyup", function(){ if($(this).prop("value")==""){$("#<?= $lv_sec; ?> #lndregtxt").prop("value","");} })
			.next().next("span").children("a:first").on("click", function(evt) {
				tmssPopup('Regiones','index.php?prg=grladrlndreg&prm_vewcod=VEW_GRL_DAT_LND_REG_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[lndregcod:lndregcod],[lndregtxt:lndregtxt]&prm_fldflt=[l.lndcod:'+$('#<?= $lv_sec; ?> #lndcod').prop('value')+']');
				evt.preventDefault();
			});
			
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
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
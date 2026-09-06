<?php
	// url del formulario
  $lv_lnk = '?prg=grlrptdsg&prm_rptcod='.$vew_data->rptcod;

	// campos requeridos
	$vew_input->RequiredFields( array('rpttxt','rptsrccod','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->rptcod;
	
	// titulo
	$lv_title = $vew_lang->report;

	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'RPD';
	
	// librería de estilos bootstrap
	include_once('_library.frm');

	// si es un reporte de sistema y no tengo permisos para gestionar reportes de sistema
	// solo se puede visualizar
	if( $vew_data->rptsys==0 && !$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'05')){
		$vew_readonly = true;
	}

	$vew_tbl['leyR'] = array('pos'=>'R', 'per'=>true, 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmss-desk-btn', 'icn'=>'far fa-projector','id'=>'btnshw', 'acc'=>'', 'ttl'=>'');	

	// lista de campos
	$lv_fldarr = array();
	if(is_array($vew_data->rptsrcfld)){
		foreach($vew_data->rptsrcfld as $lv_row){
			$lv_fldarr[] = (array('rptsrccolcod'=>$lv_row['rptsrccolcod'], 'rptsrccolcodext'=>$lv_row['rptsrccolcodext'], 'rptsrccolcodint'=>$lv_row['rptsrccolcodint'], 'rptsrccoltxt'=>$lv_row['rptsrccoltxt'],'sysfldinptyp'=>'TEXT'));
    }
	}
	$lv_rptatr = $vew_doc->getArrayFromJson( $vew_data->rptatr );
	$lv_rptttl = utf8_decode($lv_rptatr['rptttl']??'');
	$lv_subrpt = htmlentities($lv_rptatr['subrpt']??'');

	// Determino que opciones corresponden al tipo de Reporte (Usuario / Sistema)
	$lv_rptsrcsys_arr = array('1'=>$vew_lang->user);
	if( ($vew_data->rptcod=='' & $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'05')) || $vew_data->rptcod!=''){
		$lv_rptsrcsys_arr['0'] = $vew_lang->system;
	}

	// me aseguro de que los atributos del reporte incorporen los IDs de origen de las columnas de sus tablas a sus rows
 	if(isset($lv_rptatr['rows'])){
    foreach ($lv_rptatr['rows'] as $lv_rowidx => $lv_rowgrp) {
      foreach ($lv_rowgrp as $lv_rowkey => $lv_row) {
        if ($lv_row['crdtyp'] == 'tbl'){
          // decodifico los arrays JSON
          $lv_tblcolfld = is_array($lv_row['tblcolfld']) ? $lv_row['tblcolfld'] : (json_decode($lv_row['tblcolfld'], true) ? : []);
          $lv_tblrowfld = is_array($lv_row['tblrowfld']) ? $lv_row['tblrowfld'] : (json_decode($lv_row['tblrowfld'], true) ? : []);
					$lv_tbldatfld = is_array($lv_row['tbldatfld']) ? $lv_row['tbldatfld'] : (json_decode($lv_row['tbldatfld'], true) ? : []);

          // recorro cada campo dentro de tblcolfld
          foreach ($lv_tblcolfld as $lv_i => $lv_colrow) {
            $lv_fldnme = $lv_colrow['fldnme'] ?? null;
            if (!$lv_fldnme) continue;
            // busco match contra rptsrccolcodext
            foreach ($lv_fldarr as $lv_srccol) {
              if ($lv_srccol['rptsrccolcodext'] === $lv_fldnme) {
                  // inserto el código en la posición correspondiente
                  $lv_tblcolfld[$lv_i]['rptsrccolcod'] = $lv_srccol['rptsrccolcod'];
                  break;
              }
            }
          }
          // hago lo mismo con tbldatfld
          foreach ($lv_tbldatfld as $lv_c => $lv_datrow) {
            $lv_fldnme = $lv_datrow['fldnme'] ?? null;
            if (!$lv_fldnme) continue;
            // busco match contra rptsrccolcodext
            foreach ($lv_fldarr as $lv_srcdat) {
              if ($lv_srcdat['rptsrccolcodext'] === $lv_fldnme) {
                  // inserto el código en la posición correspondiente
                  $lv_tbldatfld[$lv_c]['rptsrccolcod'] = $lv_srcdat['rptsrccolcod'];
                  break;
              }
            }
          }

          // hago lo mismo con tblrowfld
          foreach ($lv_tblrowfld as $lv_c => $lv_datrow) {
            $lv_fldnme = $lv_datrow['fldnme'] ?? null;
            if (!$lv_fldnme) continue;
            // busco match contra rptsrccolcodext
            foreach ($lv_fldarr as $lv_srcdat) {
              if ($lv_srcdat['rptsrccolcodext'] === $lv_fldnme) {
                  // inserto el código en la posición correspondiente
                  $lv_tblrowfld[$lv_c]['rptsrccolcod'] = $lv_srcdat['rptsrccolcod'];
                  break;
              }
            }
          }
          // guardo de nuevo los JSON
          $lv_rptatr['rows'][$lv_rowidx][$lv_rowkey]['tblcolfld'] = json_encode($lv_tblcolfld);
          $lv_rptatr['rows'][$lv_rowidx][$lv_rowkey]['tbldatfld'] = json_encode($lv_tbldatfld);
          $lv_rptatr['rows'][$lv_rowidx][$lv_rowkey]['tblrowfld'] = json_encode($lv_tblrowfld);
        }
      }
    }
  }
?>
<script src="https://code.jquery.com/ui/1.13.3/jquery-ui.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.3/themes/base/jquery-ui.css">
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<!-- origen de datos -->
		<?= gethtml('rptsrctxt','hidden',$vew_data->rptsrctxt); ?>
		<?= gethtml('rptsrccod','hidden',$vew_data->rptsrccod); ?>
		<?= gethtml('rptsrcsys','hidden',$vew_data->rptsrcsys); ?>
    <?= gethtml('rptsrcsystyp','hidden',isset($lv_rptatr['rptsrcsystyp']) ? $lv_rptatr['rptsrcsystyp'] : ''); ?>
    
		<?= gethtml('rptsrcfld','hidden',htmlentities(json_encode($lv_fldarr))); ?>
    
		<!-- atributos -->
    <?= gethtml('rptttl','hidden',$lv_rptttl); ?>
    <?= gethtml('subrpt','hidden',$lv_subrpt); ?>
    <?= gethtml('rptatr','hidden',htmlentities($vew_data->rptatr) ); ?>
    <?= gethtml('rptatrflt','hidden', htmlentities(isset($lv_rptatr['rptflt'])?$lv_rptatr['rptflt']:'') ); ?>
    <?= gethtml('rptshwrpm','hidden',$vew_data->rptshwrpm); ?>
    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
        <li class="pull-right"><h4># <strong><?= $vew_data->rptcod; echo gethtml('rptcod', 'hidden', $vew_data->rptcod) ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
    
        <!-- GENERAL -->
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
            <div class="col-md-4 col-sm-3">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->report; ?></div></div>
                <div class="card-body tmss-card-body-edit"> 
                  <?php
                    echo vew_boot($lv_col39,array('label'=>$vew_lang->description,'input'=>gethtml('rpttxt','doccmt1x50',$vew_data->rpttxt,$lv_default)));
										echo vew_boot($lv_col39,array('label'=>$vew_lang->type, 'input'=>gethtml('rptsys', $lv_rptsrcsys_arr ,$vew_data->rptsys, ($vew_data->rptcod==''?$lv_default:$lv_always_disabled) )));
                    echo vew_boot($lv_col39,array('label'=>$vew_lang->status,'input'=>gethtml('docsts','docsts',$vew_data->docsts,$lv_default)));
                  ?>
                </div>
              </div>
            </div>
            <div class="col-md-6 col-sm-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <span class="<?= ($vew_readonly?'':'hidden'); ?>" class="font-size:18;font-weight:bold;"><?= ($lv_rptttl!=''?$lv_rptttl:'&nbsp;'); ?></span>
                    <a href="#" id="lnkttl" class="<?= ($vew_readonly?'hidden':''); ?>"><span style="font-size:18px; font-weight:bold;color:#a6a6a6;"><?= $lv_rptttl; ?></span><h4 style="color:#a6a6a6; display:inline-block;" class="<?= ($lv_rptttl!=''?'hidden':''); ?>">Agregar un t&iacute;tulo..</h4></a>
                    <span class="<?= ($vew_readonly?'hidden':''); ?>">                      
                      <a href="#" class="card-icon tmssToolsDraggable" data-crdtyp="grp" title="<?= $vew_lang->graph; ?>"><i class="far fa-chart-pie"></i></a>
                      <a href="#" class="card-icon tmssToolsDraggable" data-crdtyp="tbl" title="<?= $vew_lang->table; ?>"><i class="far fa-table"></i></a>
                      <a href="#" class="card-icon tmssToolsDraggable" data-crdtyp="zcu" title="<?= $vew_lang->url; ?>"><i class="far fa-code"></i></a>
                    </span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit" id="divlay">
                  <?php
                    $lv_colcnt=0;
                    $lv_rowcnt=0;
                    $lv_buffer='';
                    if(isset($lv_rptatr['rows'])){
                      foreach($lv_rptatr['rows'] as $lv_row){
                        $lv_buffer.='<div class="row">';
                        foreach($lv_row as $lv_col){
                          if($lv_col['crdtyp']=='tbl'){
                            $lv_rowfld = htmlentities(isset($lv_col['tblrowfld'])? (is_array($lv_col['tblrowfld'])?json_encode($lv_col['tblrowfld']):$lv_col['tblrowfld']):'');
                            $lv_colfld = htmlentities(isset($lv_col['tblcolfld'])? (is_array($lv_col['tblcolfld'])?json_encode($lv_col['tblcolfld']):$lv_col['tblcolfld']):'');
                            $lv_datfld = htmlentities(isset($lv_col['tbldatfld'])? (is_array($lv_col['tbldatfld'])?json_encode($lv_col['tbldatfld']):$lv_col['tbldatfld']):'');
                            $lv_tblttl = isset($lv_col['tblttl']) ? htmlentities($lv_col['tblttl']) : ''; $lv_tblttlshw = isset($lv_col['tblttlshw']) ? htmlentities($lv_col['tblttlshw']) : false;
                            $lv_buffer.='<div class="col-sm-'.(12/count($lv_row)).' text-center tmssLayoutDroppable" onclick="'.$lv_sec.'_showConfig($(this));" data-crdtyp="'.$lv_col['crdtyp'].'" data-tblttl="'.(isset($lv_col['tblttl'])?utf8_decode($lv_col['tblttl']):'').'" data-tblttlshw="'.$lv_tblttlshw.'" data-tblrowfld="'.$lv_rowfld.'" data-tblcolfld="'.$lv_colfld.'" data-tbldatfld="'.$lv_datfld.'"><i class="far fa-table fa-5x"></i></div>';
                            $lv_colcnt++;
                          } else if($lv_col['crdtyp']=='zcu'){
                            $lv_buffer.='<div class="col-sm-'.(12/count($lv_row)).' text-center tmssLayoutDroppable" onclick="'.$lv_sec.'_showConfig($(this));" data-crdtyp="'.$lv_col['crdtyp'].'" data-zcuurl="'.htmlentities(isset($lv_col['zcuurl'])?$lv_col['zcuurl']:'').'"><i class="far fa-code fa-5x"></i></div>';
                            $lv_colcnt++;
                          } else if($lv_col['crdtyp']=='grp'){
                            $lv_buffer.='<div class="col-sm-'.(12/count($lv_row)).' text-center tmssLayoutDroppable" onclick="'.$lv_sec.'_showConfig($(this));" data-crdtyp="'.$lv_col['crdtyp'].'" data-grptyp="'.(isset($lv_col['grptyp'])?$lv_col['grptyp']:'chart-pie').'" data-grpttl="'.(isset($lv_col['grpttl'])?utf8_decode($lv_col['grpttl']):'').'" data-grplgnpos="'.(isset($lv_col['grplgnpos'])?$lv_col['grplgnpos']:'').'" data-grpdatrowfld="'.(isset($lv_col['grpdatrowfld'])?$lv_col['grpdatrowfld']:'').'" data-grpdatcolfld="'.(isset($lv_col['grpdatcolfld'])?$lv_col['grpdatcolfld']:'').'" data-grpdatfld="'.(isset($lv_col['grpdatfld'])?$lv_col['grpdatfld']:'').'"><i class="far fa-'.(isset($lv_col['grptyp'])?$lv_col['grptyp']:'chart-pie').' fa-5x"></i></div>';
                            $lv_colcnt++;
                          }
                        }
                        if($lv_colcnt==0 && $lv_rowcnt==0){
                          $lv_buffer.='<div class="col-sm-12 text-center tmssLayoutDroppable" onclick="'.$lv_sec.'_showConfig($(this));"></div>';
                        } else if($lv_colcnt==0){
                          $lv_buffer.='<div class="col-sm-12 text-center tmssLayoutDroppable" onclick="'.$lv_sec.'_showConfig($(this));"></div>';
                        }
                        $lv_buffer.='</div>';
                        $lv_rowcnt++;
                      }
                    }
                    if($lv_buffer=='' || $lv_colcnt==0){
                      $lv_buffer='<div class="row"><div class="col-sm-12 text-center tmssLayoutDroppable" onclick="'.$lv_sec.'_showConfig($(this));">'.($vew_data->rptcod==''?'<h3 style="color:#a6a6a6;">Arrastre aqu&iacute; los elementos del reporte</h3>':'').'</div></div>';
                    }
                    echo $lv_buffer;
                  ?>
                </div>
              </div>
            </div>
            <div class="col-md-2 col-sm-3">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->configuration; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <div class="row">
                    <div class="col-xs-6 col-sm-12">
                      <a href="#" class="card-opt-body text-left" id="lnksrc"><i class="far fa-database"></i> Origen de Datos<small id="rptsrctxtlbl" style="color:#363636;padding-left:17px;display:block;"><?= $vew_data->rptsrctxt.' (#'.$vew_data->rptsrccod.')'; ?></small></a>
                      <a href="#" class="card-opt-body text-left" id="lnkflt"><i class="far fa-filter"></i> <?= $vew_lang->filters; ?></a>
                      <a href="#" class="card-opt-body text-left" id="lnklay"><i class="far fa-table-layout"></i> Layout</a>
                      <a href="#" class="card-opt-body text-left" id="lnkpub"><i class="far fa-projector"></i> <?= $vew_lang->publish; ?></a>
                    </div>
                  </div>
                </div>
              </div>
              <?php if($vew_data->rptcod!=''){?>
                <div class="card">
                  <div class="card-header"><div class="card-title"><?= $vew_lang->options; ?></div></div>
                  <div class="card-body tmss-card-body-edit">
                    <div class="row">
                      <div class="col-xs-6 col-sm-12">
                        <a href="#" class="card-opt-body text-left" id="lnksec"><i class="far fa-key"></i> <?= $vew_lang->security; ?></a>
                        <a href="#" class="card-opt-body text-left" id="lnkmsg"><i class="far fa-paper-plane"></i> <?= $vew_lang->messageclasses; ?></a>
                      </div> 
                    </div>
                  </div>
                </div> <!-- /card -->
              <?php } ?>
            </div> <!-- /col -->
          </div> <!-- /row -->
        </div> <!-- /_tab001 -->
      </div> <!-- /tab-conent -->
    </div> <!-- /container-fluid -->
		
		<!--   R E P O R T E   -->

    <!-- TITULO -->
		<div class="hidden" id="crdrepttl">
      <?= vew_boot($lv_col39,array('label'=>$vew_lang->title,'input'=>gethtml('rptttldat','doccmt1x50','',$lv_default))); ?>
		</div>

		<!-- FILTROS -->
		<div class="hidden" id="crdrepflt">
			<div class="card">
				<div class="card-header"><div class="card-title"><?= $vew_lang->filters; ?></div></div>
				<div class="card-body tmss-card-body-edit">
					<table class="table">
						<thead><tr><th><?= $vew_lang->field; ?></th><th><?= $vew_lang->filter; ?></th><th><?= $vew_lang->default; ?></th><th>Obligatorio</th></tr></thead>
						<tbody></tbody>
					</table>
				</div>
			</div>
		</div>

		<!-- SEGURIDAD -->
    <div class="hidden" id="crdrepsec">
      <div class="card">
        <div class="card-header"><div class="card-title"><?= $vew_lang->security; ?></div></div>
        <div class="card-body tmss-card-body-edit">
					<?= vew_boot($lv_col39,array('label'=>$vew_lang->users,'input'=>gethtml('rptperusr','doccmt4x50','',$lv_default))); ?>
					<?= vew_boot($lv_col39,array('label'=>$vew_lang->roles,'input'=>gethtml('rptperrls','doccmt4x50','',$lv_default))); ?>
					<?= vew_boot($lv_col39,array('label'=>$vew_lang->authorizationcode,'input'=>gethtml('autcod','doccmt1x50','',$lv_default))); ?>
        </div>
      </div>
    </div>
		
		<!-- LAYOUT -->
		<div class="hidden" id="crdreplay">
			<div class="card">
				<div class="card-header"><div class="card-title"><?= $vew_lang->layout; ?>
					<?= ($vew_readonly?'':'<a href="#" class="card-icon" id="btnaddrow"><i class="far fa-plus"></i></a>'); ?>
				</div></div>							
				<div class="card-body tmss-card-body-edit">
					<table class="table" id="tbllay">
						<thead><tr><th width="70"><?= $vew_lang->row; ?></th><th><?= $vew_lang->columns; ?></th></tr></thead>
						<tbody></tbody>
					</table>
				</div>
			</div>
		</div>
		
		<!-- PUBLICACION -->
		<div class="hidden" id="crdreppub">
			<div class="form-horizontal">
        <div class="card">
          <div class="card-header"><div class="card-title"><?= $vew_lang->publication ?></div></div>
          <div class="card-body tmss-card-body-edit">
            <div class="form-group tmss-form-group">
              <label class="col-sm-3 control-label"><?= $vew_lang->show; ?></label>
              <div class="col-sm-9"><label class='toggle-switchy' data-size='xs' data-style='rounded' data-text='false'><input type='checkbox' id='rptshwrpmchk' name='rptshwrpmchk' onchange='' readonly='' <?= ($vew_data->rptshwrpm=='1'?'checked':''); ?> ><span class='toggle'><span class='switch'></span></span></label></div>
            </div>					
            <?= vew_boot($lv_col39,array('label'=>$vew_lang->location,'input'=>gethtml('rpthietxt','doccmt1x50',$vew_data->rpthietxt,$lv_default))); ?>
          </div>
        </div>
        <?php if($vew_data->rptcod!=''){?>
          <div class="card">
            <div class="card-header"><div class="card-title">URL</div></div>
            <div class="card-body tmss-card-body-edit">
              <div style='display:block;'>
                <table class='table'>
                  <tbody>
                    <tr><td colspan='2'><b>EXTERNO: Utilice esta URL para compartir o acceder externamente al reporte:</b></td></tr>
                    <tr><td style='word-break:break-all;'>https:\\temasis.com.ar\sysdev\tmssonline\gorse.php\dev_salud\user=<?= $vew_sec->usrcod; ?>\general-reports\<?= $vew_data->rptcod; ?>?show</td><td><a href='#' class='card-icon' onclick='tmssCopyToClipboard("https:\\\\temasis.com.ar\\sysdev\\tmssonline\\gorse.php\\dev_salud\\user=<?=$vew_sec->usrcod;?>\\general-reports\\<?=$vew_data->rptcod;?>?show");' title='<?= $vew_lang->copy; ?>'><i class='far fa-copy'></i></a></td></tr>
                    <tr><td colspan='2'><b>INTERNO: Utilice esta URL para referenciar a este reporte dentro de otro:</b></td></tr>
                    <tr><td>?prg=grlrptdsg&amp;act=show&amp;prm_rptcod=<?= $vew_data->rptcod; ?></td><td><a href='#' class='card-icon' onclick='tmssCopyToClipboard("?prg=grlrptdsg&act=show&prm_rptcod=<?= $vew_data->rptcod; ?>");' title='<?= $vew_lang->copy; ?>'><i class='far fa-copy'></i></a></td></tr>
                  </tbody>
                </table>
              </div>
            </div>
          <?php } ?>
        </div>
			</div>
    </div>

  </form>
	
	<!--   H E R R A M I E N T A S   -->
	
	<!-- GRAFICO. CONFIGURACION -->
	<div class="hidden" id="crdgrpdat">
		<div class="row">
			<div class="col-sm-4">
				<div class="card">
					<div class="card-header"><div class="card-title"><?= $vew_lang->type; ?></div></div>
					<div class="card-body tmss-card-body-edit" name="grptyp">
						<div class="row">
							<div class="col-xs-6 col-sm-12">
								<a href="#" class="card-opt-body text-left" name="chart-area"><i class="far fa-chart-area fa-2x"></i> &Aacute;rea</a>
								<a href="#" class="card-opt-body text-left" name="chart-bar"><i class="far fa-chart-bar fa-2x"></i> Bar</a>
								<a href="#" class="card-opt-body text-left" name="chart-column"><i class="far fa-chart-column fa-2x"></i> Columnas</a>
							</div>
							<div class="col-xs-6 col-sm-12">
								<a href="#" class="card-opt-body text-left" name="chart-pie"><i class="far fa-chart-pie fa-2x"></i> Torta</a>
								<a href="#" class="card-opt-body text-left" name="chart-line"><i class="far fa-chart-line fa-2x"></i> L&iacute;neas</a>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-sm-8">
				<div class="card">
					<div class="card-header"><div class="card-title"><?= $vew_lang->attributes; ?></div></div>							
					<div class="card-body tmss-card-body-edit">
						<form class="form-horizontal">
							<?= vew_boot($lv_col39,array('label'=>$vew_lang->title,'input'=>gethtml('grpttl','doccmt1x50','',$lv_default))); ?>
							<?= vew_boot($lv_col39,array('label'=>$vew_lang->legend,'input'=>gethtml('grplgnpos',array(''=>'','top'=>'Arriba','right'=>'Derecha','bottom'=>'Abajo','left'=>'Izquierda'),'',$lv_default))); ?>
							<?= vew_boot($lv_col39,array('label'=>$vew_lang->labels,'input'=>gethtml('grpdatrowfld',array(''=>''),'',$lv_default))); ?>
							<div id="divgrponedat">
								<?= vew_boot($lv_col39,array('label'=>$vew_lang->data,'input'=>gethtml('grpdatfld',array(''=>''),'',$lv_default))); ?>
							</div>
							<div id="divgrptwodat">
								<?= vew_boot($lv_col39,array('label'=>$vew_lang->column,'input'=>gethtml('grpdatcolfld',array(''=>''),'',$lv_default))); ?>
							</div>
							<div class="form-group tmss-form-group">
								<label class="col-sm-3 control-label"><?= $vew_lang->calculate; ?></label>
								<div class="col-sm-9"><select id="grpcal" name="grpcal" class="form-control"><option value="count" data-group="text">Contar</option><option value="sum" data-group="number">Sumar</option></select></div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- TABLA. CONFIGURACION -->
	<div class="hidden" id="crdtabdat">
    <style>
      .draggable-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        background-color: #f8f9fa;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        padding: 6px 10px;
        margin-bottom: 4px;
        cursor: move;
        height: 36px; /* altura fija */
        box-sizing: border-box;
      }
      .remove-item {
        color: #dc3545;
        font-weight: bold;
        cursor: pointer;
        margin-left: 6px;
      }
      .remove-item:hover {
        color: #a71d2a;
      }
  	</style>
		<div class="row">
      <div class="col-sm-12">
				<div class="card">
					<div class="card-header"><div class="card-title"><?= $vew_lang->title; ?></div></div>							
					<div class="card-body tmss-card-body-edit">
						<form class="form-horizontal">
							<?= vew_boot($lv_col39, array('label'=>$vew_lang->title,'input'=>gethtml('tblttl','doccmt1x50','',$lv_default))); ?>
              <?= vew_boot($lv_col39, array('label'=>$vew_lang->show,'input'=>gethtml('tblttlshw', 'checkbox', ( $vew_readonly ? $lv_always_disabled : $lv_default ) ))); ?>
						</form>
					</div>
				</div>
			</div>
    </div>
    <div class="row">
			<div class="<?= ($vew_readonly?'col-sm-12':'col-sm-7'); ?>">
				<div class="card">
					<div class="card-header"><div class="card-title"><?= $vew_lang->table; ?></div></div>
					<div class="card-body tmss-card-body-edit">
						<table class="table table-bordered" id="tbllay">
							<thead><tr><th width="100" height="35"></th><th class="tmssTableDroppable tmssReportCol"></th></tr></thead>
							<tbody><tr><td class="tmssTableDroppable tmssReportRow" height="35"></td><td class="tmssTableDroppable tmssReportDat"></td></tr></tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="col-sm-5 <?= ($vew_readonly?'hidden':''); ?>">
				<div class="card" id="fldlst">
					<div class="card-header"><div class="card-title"><?= $vew_lang->fields; ?></div></div>
					<div class="card-body tmss-card-body-edit"></div>
				</div>
				<div class="card hidden" id="flddatcfg">
					<div class="card-header">
						<div class="card-title"><?= $vew_lang->settings; ?>
							<a href="#" class="card-icon text-danger" onclick="<?= $lv_sec; ?>_cancelTableFieldConfig();"><i class="fas fa-times"></i></a>
							<a href="#" class="card-icon text-success" onclick="<?= $lv_sec; ?>_acceptTableFieldConfig();"><i class="fas fa-check"></i></a>
						</div>
					</div>
					<div class="card-body tmss-card-body-edit">
						<select class="form-control">
							<option value="cnt" data-group="">Contar</option>
							<option value="sum" data-group="numbre">Suma</option>
							<option value="avg" data-group="numbre">Promedio</option>
							<option value="max" data-group="numbre">Maximo</option>
							<option value="min" data-group="numbre">Minimo</option>
						</select>
					</div>
				</div>
			</div>			
		</div>
	</div>

	<!-- PERSONALIZADO. CONFIGURACION -->
	<div class="hidden" id="crdzcudat">
		<?= vew_boot($lv_col39,array('label'=>'URL','input'=>gethtml('zcuurl','doccmt1x400','',$lv_default))); ?>
	</div>
  
	<script>
		// REPORTE. CONFIGURACION
    $("#<?= $lv_sec;?> #rptsys").on("change", function() {
      if ($("#<?= $lv_sec;?> #rptcod").val() == "") {
        $("#<?= $lv_sec; ?> #rptsrcfld").val("");
        $("#<?= $lv_sec;?> #rptsrctxt").val("");
        $("#<?= $lv_sec;?> #rptsrccod").val("");
        $("#<?= $lv_sec; ?> #rptsrctxtlbl").html("(#)");
      }
    });
    
    // ORIGEN DE DATOS. abro el dialogo para seleccionar el origen de datos
    $("#<?= $lv_sec; ?> #lnksrc").on("click", function(e){e.preventDefault();
      <?php if( !$vew_readonly ){
  			if ( ($vew_data->rptcod??"")=="" || ($vew_data->rptsrccod??0)==0 ) { ?>
					if ( $("#<?= $lv_sec; ?> #rptsys").val()==0 ) {
          	tmssPopup("<?= $vew_lang->source; ?>","?prg=sysgrlrptsrc&prm_vewcod=VEW_GRL_RPT_SRC&prm_popup=sysdochdr_popup&prm_srcmtd=getReportSystem&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[rptsrcsys:rptsrcsys],[rptsrcsystyp:rptsrcsys],[rptsrctxt:rptsrctxt],[rptsrccod:rptsrccod]&prm_fldflt=[r.docsts:A]");
          }else {
            tmssPopup("<?= $vew_lang->source; ?>","?prg=sysgrlrptsrc&prm_vewcod=VEW_GRL_RPT_SRC&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[rptsrcsys:rptsrcsys],[rptsrcsystyp:rptsrcsys],[rptsrctxt:rptsrctxt],[rptsrccod:rptsrccod]&prm_fldflt=[r.docsts:A]");
          }
			<?php	}else{ ?>
							toastr.warning("No se puede cambiar el origen de un reporte una vez grabado.");
      <?php }
      } ?>
    });

		// origen de datos. attach de evento de refresh de campos
		$("#<?= $lv_sec; ?> #rptsrccod").on("change",function(e){ e.preventDefault();
			if($(this).val()==""){ return; }
			$("#<?= $lv_sec; ?> #rptsrcfld").prop("value","");
			$("#<?= $lv_sec; ?> #rptsrctxtlbl").html( $("#<?= $lv_sec; ?> #rptsrctxt").prop("value") );
			var lv_pstdat = { "rptsrccod": $(this).val(), "rptsrcsys": $("#<?= $lv_sec; ?> #rptsrcsystyp").val() };
			tmssCallProcess("?prg=sysgrlrptsrc&act=18",lv_pstdat,function(data){
				$("#<?= $lv_sec; ?> #rptsrcfld").prop("value",JSON.stringify( data ));
			});
		});
    
		// FILTROS. abro el dialogo para establecer los campos de filtro
		$("#<?= $lv_sec; ?> #lnkflt").on("click",function(e){e.preventDefault();
			BootstrapDialog.show({
				title: "<?= $vew_lang->filters; ?>", 
				message: $("#<?= $lv_sec; ?> #crdrepflt").clone().removeClass("hidden").prop("id","<?= $lv_sec; ?>_fltcfg"),
				type: BootstrapDialog.TYPE_PRIMARY,
        closable: true,
				draggable: true,
				buttons: [<?php if(!$vew_readonly){ ?>
          				{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger <?= ($vew_readonly?'hidden':''); ?>", action: function(dialog){ dialog.close(); } },
									{ label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success <?= ($vew_readonly?'hidden':''); ?>", action: function(dialog){ 
										// asigno valores al formulario
										var lv_fltlst=[];
										dialog.getModalBody().find("input[type=checkbox]:checked.fldflt").each(function(){
											var lv_defval = $(this).parent().parent().parent().find("select");
											lv_fltlst.push( {rptsrccolcod: $(this).data("rptsrccolcod"), fldnme: $(this).data("fldnme"), defval: ($(lv_defval).length==0?"":$(lv_defval).find("option:selected").val()), isoblfld:$(this).parent().parent().parent().find("input[type=checkbox]:checked#isoblfld").length>0?"X":""} );
										});
										$("#<?= $lv_sec; ?> #rptatrflt").prop("value",JSON.stringify( lv_fltlst ) );
										dialog.close();
									}}
          				<?php } ?>],
				onshown: function(dialog){
					if($("#<?= $lv_sec; ?> #rptsrcfld").prop("value")==""){ toastr.warning("Debe indicar primero un Origen de Datos."); }
					// cargo lista de campos al formulario
					var lv_fld = JSON.parse( $("#<?= $lv_sec; ?> #rptsrcfld").prop("value") );
					var lv_dtefld = "<select class='form-control'><option value='D'>Hoy</option><option value='W'>Semana</option><option value='M'>Mes</option><option value='PM'>Mes Anterior</option><option value='30D'>30 Dias</option></select>";
          for(var i=0; i<lv_fld.length; i++){
            let lv_fldnme = (lv_fld[i].rptsrccolcodext??"")!="" ? lv_fld[i].rptsrccolcodext : lv_fld[i].rptsrccolcodint;
						dialog.getModalBody().find("table tbody").append("<tr><td>"+lv_fld[i].rptsrccoltxt+"</td><td><label class='toggle-switchy' data-size='xs' data-style='rounded' data-text='false'><input type='checkbox' class='fldflt' onchange='' readonly='' data-rptsrccolcod='"+lv_fld[i].rptsrccolcod+"' data-fldnme='"+lv_fldnme+"'><span class='toggle'><span class='switch'></span></span></label></td><td>"+(lv_fld[i].sysfldinptyp=="DATE"?lv_dtefld:"")+"</td><td><label class='toggle-switchy' data-size='xs' data-style='rounded' data-text='false'><input type='checkbox' onchange='' readonly='' id='isoblfld'><span class='toggle'><span class='switch'></span></span></label></td></tr>");
					}
					// asigno valores al formulario
					var lv_fltlst = JSON.parse( $("#<?= $lv_sec; ?> #rptatrflt").prop("value")==""?"[]":$("#<?= $lv_sec; ?> #rptatrflt").prop("value") );
					for(var i=0; i<lv_fltlst.length; i++){
            // reviso cuáles de los campos están marcados para filtrar
						var lv_chk = dialog.getModalBody().find("input[type=checkbox][data-rptsrccolcod='"+lv_fltlst[i].rptsrccolcod+"']");
						if( $(lv_chk).length>0){
							$(lv_chk).prop("checked",true);
							$(lv_chk).parent().parent().parent().find("select:first").find("option[value="+lv_fltlst[i].defval+"]").attr("selected",true);
						}
            // hago lo mismo con el toggle de obligatoriedad
            var lv_oblfld = $(lv_chk).parent().parent().parent().find("input[type=checkbox]#isoblfld");
            if( $(lv_oblfld).length>0 && lv_fltlst[i].isoblfld=='X' ){
            	$(lv_oblfld).prop("checked",true);
            }
					}					
				}
			});
		});
		
    
		// SEGURIDAD. abro el dialogo para modificar la seguridad del reporte
		$("#<?= $lv_sec; ?> #lnksec").on("click",function(e){e.preventDefault();
			BootstrapDialog.show({
				title: "<?= $vew_lang->security; ?>", 
				message: $("#<?= $lv_sec; ?> #crdrepsec").clone().removeClass("hidden"),
				type: BootstrapDialog.TYPE_PRIMARY,
        closable: true,
				draggable: true,
        buttons: [{label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialogItself){dialogItself.close();}}
									<?php if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02')){ ?>
									,{label: "<?= $vew_lang->save; ?>", cssClass: "btn-success", action: function(dialogItself){ 
										// asigno valores al formulario
										var lv_frm = dialogItself.getModalBody();
										var lv_pstdat=[ {name:"rptcod", value: "<?= $vew_data->rptcod; ?>"},
																		{name:"rptsys", value: "<?= $vew_data->rptsys; ?>"},
																		{name:"rptperusr", value: $(lv_frm).find("#rptperusr").val()},
																		{name:"rptperrls", value: $(lv_frm).find("#rptperrls").val()},
																		{name:"autcod", value: $(lv_frm).find("#autcod").val()}
																	];
										tmssCallProcess( "?prg=grlrptdsg&act=21",lv_pstdat,function(data){
											toastr.success("Los datos fueron grabados.");
											dialogItself.close();
											<?= $lv_sec; ?>_fnc({action: "99"});
										});
									}}
									<?php } ?>
                	],
				onshown: function(dialogItself){
          <?php if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02')){ ?>
            dialogItself.getModalBody().find(".form-control").prop("readonly","");
          <?php } ?> 
          // Recuperar datos de seguridad
          var lv_pstdat = [
                            { name: "rptcod", value: "<?= $vew_data->rptcod; ?>" },
                            { name: "rptsys", value: "<?= $vew_data->rptsys; ?>" }
                          ];
          tmssCallProcessNoBackdrop("?prg=grlrptdsg&act=22", lv_pstdat, function(data) {
            if (data.errtyp !== "E") {
              dialogItself.getModalBody().find("#rptperusr").val(data.data.rptperusr);
              dialogItself.getModalBody().find("#rptperrls").val(data.data.rptperrls);
              dialogItself.getModalBody().find("#autcod").val(data.data.autcod);
            } else {
             	toastr.error(data.errtxt);
            }
          });
				}
			});
		});
		
    
		// LAYOUT. abro el dialogo para modificar el layout del reporte
		$("#<?= $lv_sec; ?> #lnklay").on("click",function(e){e.preventDefault();
			BootstrapDialog.show({
				title: "<?= $vew_lang->layout; ?>", 
				message: $("#<?= $lv_sec; ?> #crdreplay").clone().removeClass("hidden"),
				type: BootstrapDialog.TYPE_PRIMARY,
				draggable: true,
				buttons: [<?php if(!$vew_readonly){ ?>
          				{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger <?= ($vew_readonly?'hidden':''); ?>", action: function(dialog){ dialog.close(); } },
									{ label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success <?= ($vew_readonly?'hidden':''); ?>", action: function(dialog){ 
										// igualo filas
										var lv_act = $("#<?= $lv_sec; ?> #divlay .row").length;
										var lv_new = dialog.getModalBody().find("#tbllay tbody tr").length;
										if( lv_act < lv_new ){
											for(var i=0; i<lv_new-lv_act; i++){$("#<?= $lv_sec; ?> #divlay").append("<div class='row'></div>");}
										}else if ( lv_act > lv_new ) {
											for(var i=0; i<lv_act-lv_new; i++){$("#<?= $lv_sec; ?> #divlay .row:last").remove();}
										}
										// igualo columnas
										var lv_inparr = dialog.getModalBody().find("#tbllay tbody input");
										for(var i=0;i<lv_inparr.length;i++){
											var lv_act = $("#<?= $lv_sec; ?> #divlay .row:nth-child("+(i+1)+") .tmssLayoutDroppable").length;
											var lv_new = $(lv_inparr[i]).val();
											$("#<?= $lv_sec; ?> #divlay .row:nth-child("+(i+1)+") .tmssLayoutDroppable").removeClass("col-sm-12").removeClass("col-sm-6").removeClass("col-sm-4").removeClass("col-sm-3").addClass("col-sm-"+(12/lv_new));
											if( lv_act < lv_new){
												for(var x=0; x<lv_new-lv_act; x++){$("#<?= $lv_sec; ?> #divlay .row:nth-child("+(i+1)+")").append("<div class='tmssLayoutDroppable text-center ui-droppable col-sm-"+(12/lv_new)+"' onclick='<?= $lv_sec; ?>_showConfig($(this));'></div>");}
											}else if(lv_act > lv_new){
												for(var x=0; x<lv_act-lv_new; x++){$("#<?= $lv_sec; ?> #divlay .row:nth-child("+(i+1)+") .tmssLayoutDroppable:last").remove();}
											}
										}
                    <?= $lv_sec; ?>_setDragDropEvents();
										
										// actualiza titulo
										var lv_ttl = dialog.getModalBody().find("#rptttl").val();
										$("#<?= $lv_sec; ?> #rptttl").prop("value",lv_ttl);
										$("#<?= $lv_sec; ?> #rptttllbl").html(lv_ttl);
										dialog.close();
									}}
        					<?php } ?>],
				onshown: function(dialog){
					// asigna titulo
					dialog.getModalBody().find("#rptttl").prop("value", $("#<?= $lv_sec; ?> #rptttllbl").html() );
					// LISTA. se arma la lista de filas y columnas en el dialogo
					var i=0;
					var lv_buffer="";
					$("#<?= $lv_sec; ?> #divlay .row").each(function(){
						i++;
						var lv_cols = $(this).find(".tmssLayoutDroppable").length;
						lv_buffer += "<tr><td>"+i+(i==1 || 1==<?= ($vew_readonly?1:0); ?>?"":"<a href='#' class='card-icon' onclick='$(this).parent().parent().remove();'><i class='far fa-minus'></i></a>")+"</td><td><input type='number' min='1' max='4' step='1' value='"+lv_cols+"' class='form-control' <?= ($vew_readonly?'readonly':''); ?> ></td></tr>";
					});
					dialog.getModalBody().find("#tbllay tbody").replaceWith("<tbody>"+lv_buffer+"</tbody>");
					
					// AGREGAR. attach de eventos a botones agregar
					dialog.getModalBody().find("#btnaddrow").on("click",function(e){ e.preventDefault();
						var lv_row = dialog.getModalBody().find("#tbllay tbody tr:first").clone();
						$(lv_row).find("td:first").html( (dialog.getModalBody().find("#tbllay tbody tr").length+1) );
						$(lv_row).find("input:first").prop("value",1);
						$(lv_row).find("td:first").html("<a href='#' class='card-icon' onclick='$(this).parent().parent().remove();'><i class='far fa-minus'></i></a>");
						$(lv_row).appendTo( dialog.getModalBody().find("#tbllay tbody") );
					});
				}
			});
		});
    
		// Mensajes. Abro el dialogo para mostrar la tabla de mensajes
    $("#<?= $lv_sec; ?> #lnkmsg").on("click",function(e){e.preventDefault();
      BootstrapDialog.show({
        title: "<?= $vew_lang->messageclasses;?>",
        message:'<div id="sysdocmsghot" name="sysdocmsghot"></div>',
        type: BootstrapDialog.TYPE_PRIMARY,
        closable: true,
        draggable: true,
        buttons:[
                  { label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", id:"btncnc", action: function(dialogItself){ dialogItself.close(); } },
          				<?php if($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02')){ ?>
                  { label: "<?= $vew_lang->save; ?>", cssClass: "btn-success", action: function(dialogItself){                    
                    // Obtengo los valores de la Handsontable
                    var lv_data = <?= $lv_sec; ?>_hotobj.getSourceData();
                    var lv_pstdat = [];

                    for (var i = 0; i < lv_data.length; i++) {
                      if ( lv_data[i]["sysdocmsgcod"]!="" && lv_data[i]["sysdocmsgcod"]!=undefined ){
                        lv_pstdat.push({ srcobjcod: "<?= $vew_data->rptcod; ?>",
                                         srcobjcod002: "<?= $vew_data->rptsys; ?>",
                                         sysdocmsgcod: lv_data[i].sysdocmsgcod,
                                         srcobjtyp: "GRL_RPT",
                                         docsts: "A",
                                         msgnum: lv_data[i]["msgnum"]
                                      });
                      }
                    }
                    
                    // Agrego las filas eliminadas
                    for (var i = 0; i < <?= $lv_sec; ?>_hotdocdel.length; i++) {
                      lv_pstdat.push({ msgnum: <?= $lv_sec; ?>_hotdocdel[i]["msgnum"],
        															 deleted: "X"
                                    });
                    }
                    
                    tmssCallProcess( "?prg=grldatmsg&act=00",{grldatmsgarr: JSON.stringify(lv_pstdat)},function(data){
                      toastr.success("Los datos fueron grabados.");
                      dialogItself.close();
                      <?= $lv_sec; ?>_fnc({action: "99"});
                    });
                  }}
          				<?php } ?>
                ],
        onshown: function(dialogItself) {
          tmssLoadScript("handsontable", function() {
            var container = document.getElementById("sysdocmsghot");
            <?= $lv_sec; ?>_hotobj = new Handsontable(container, <?= $lv_sec; ?>_hotdocset);
            // Recuperar los datos
            var lv_pstdat = [
              							{ name: "srcobjtyp", value: "GRL_RPT"},
                            { name: "srcobjcod", value: "<?= $vew_data->rptcod; ?>" },
                            { name: "srcobjcod002", value: "<?= $vew_data->rptsys; ?>" }
                            ];
            tmssCallProcessNoBackdrop("?prg=grldatmsg&act=29", lv_pstdat, function(data) {
              if (data.errtyp !== "E") {
                <?= $lv_sec; ?>_hotobj.loadData(data);
                <?= $lv_sec; ?>_hotobj.render();
              } else {
                toastr.error(data.errtxt);
              }
            });
          });
        }
      });
    });
    
    
    // Handsontable de Clases de Mensajes
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
    if (prop == "sysdocmsgtxt") {
        Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
        td.style.backgroundColor = "FFFFFF";
        var lv_id = instance.getDataAtRowProp(row, "sysdocmsgtxt");
        if ((lv_id == null ? "" : lv_id) !== "") {
            td.style.backgroundColor = "#F1F1F1"; 
            cellProperties.readOnly = true;
        }
    }
		};
    var <?= $lv_sec; ?>_hotdocerr = [];
    var <?= $lv_sec; ?>_hotdocchg = [];
    var <?= $lv_sec; ?>_hotdocdel = [];		
    var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #sysdocmsghot")[0];
    var <?= $lv_sec; ?>_hotdocset = {
      height: 230,
      stretchH: "all",
      autoColumnSize: true,
      contextMenu: ["remove_row"],
      autoWrapRow: false,
      rowHeaders: true,
      minSpareRows: 1,
      colHeaders: [ "Clase Mensaje" ],
      columns: [
        {type: "autocomplete", data: "sysdocmsgtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: false,			
          source: function (query, process) {
            $.ajax({
              url: "index.php?prg=sysdocmsg&act=18", dataType: "json", data: {	prm_sysdocmsgtxt: query, prm_objtypcod: "<?= $vew_data->objtypcod ?>" },
              complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); exit();}},
              success: function (response) {
                // guardo todos los datos adicionales en una variable temporal
                var lv_dat = [];
                <?= $lv_sec; ?>_hotdocchg = [];
                for (var i=0; i < response.length; i++) {
                  <?= $lv_sec; ?>_hotdocchg.push( {sysdocmsgtxt: response[i]["sysdocmsgtxt"], sysdocmsgcod: response[i]["sysdocmsgcod"]} );
                  lv_dat.push( response[i]["sysdocmsgtxt"] );
                }
                process( lv_dat );
              }
            });
          },
          strict: true
        }
      ],
      beforeChange : function(changes, source) {
        // asigno los datos adicionales a la fila
        if(source=="edit" && changes[0][1]=="sysdocmsgtxt") {
          var lv_value = changes[0][3];
          for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
            if(<?= $lv_sec; ?>_hotdocchg[i].sysdocmsgtxt == lv_value) {
              changes.push([ changes[0][0], "sysdocmsgcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].sysdocmsgcod) ]);
            }
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
      },

      beforeRemoveRow: function(index, amount, logicalRows) {
        var lv_dat = <?= $lv_sec; ?>_hotobj.getSourceData();
        for (var i = index; i <= index + amount - 1; i++) {
          if (lv_dat[i]["msgnum"] != "" && lv_dat[i]["msgnum"] != undefined) {
            <?= $lv_sec; ?>_hotdocdel.push(lv_dat[i]);
          }
        }
      }
    };
    var <?= $lv_sec; ?>_hotobj;
    
  	// TITULO. abre el dialogo de configuración de titulo del reporte
		$("#<?= $lv_sec; ?> #lnkttl").on("click",function(e){ e.preventDefault();
			BootstrapDialog.show({
				title: "<?= $vew_lang->title; ?>", 
				message: $("#<?= $lv_sec; ?> #crdrepttl").clone().removeClass("hidden"),
				type: BootstrapDialog.TYPE_PRIMARY,
        closable: true,
				draggable: true,
				buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialog){ dialog.close(); } },
									{ label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success", action: function(dialog){
                    var lv_ttl = dialog.getModalBody().find("#rptttldat").prop("value");
                    $("#<?= $lv_sec; ?> #rptttl").prop("value", lv_ttl);
                    $("#<?= $lv_sec; ?> #lnkttl span:first").html("");
                    if( lv_ttl=="") {
                      $("#<?= $lv_sec; ?> #lnkttl h4").removeClass("hidden"); 
                  	} else {
                      $("#<?= $lv_sec; ?> #lnkttl span:first").html( lv_ttl );
                    	$("#<?= $lv_sec; ?> #lnkttl h4").addClass("hidden"); 
                    }
										dialog.close();
									} }],
				onshown: function(dialog){ dialog.getModalBody().find("#rptttldat").prop("value", $("#<?= $lv_sec; ?> #rptttl").prop("value")); }
			});
		});
		
    
		// PUBLICACION. Abro el dialogo para publicar el reporte
    $("#<?= $lv_sec; ?> #lnkpub").on("click", function(e) {
      e.preventDefault();

      var lv_crereppub = $("#<?= $lv_sec; ?> #crdreppub").clone().removeClass("hidden").prop("id", "<?= $lv_sec; ?>_pubcfg");
      
      BootstrapDialog.show({
        title: "<?= $vew_lang->publish; ?>",
        message: lv_crereppub,
        type: BootstrapDialog.TYPE_PRIMARY,
        closable: true,
        draggable: true,
        buttons: [<?php if(!$vew_readonly){ ?>
                  { label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", id:"btncnc", action: function(dialog){ dialog.close(); } },
                  { label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success", action: function(dialog){
                      // asigno valores al formulario
                    	var lv_shw =(dialog.getModalBody().find("#rptshwrpmchk").is(":checked")?1:0);
                    if((lv_shw && dialog.getModalBody().find("#rpthietxt").val()!="") || !lv_shw){
                        $("#<?= $lv_sec; ?> #rptshwrpm").prop("value", (lv_shw) );
                        $("#<?= $lv_sec; ?> #rpttxt").prop("value", dialog.getModalBody().find("#rpttxt").val());
                        $("#<?= $lv_sec; ?> #rpthietxt").prop("value", dialog.getModalBody().find("#rpthietxt").val());
                        $("#<?= $lv_sec; ?> #docsts").prop("value", dialog.getModalBody().find("#docsts").val());
                        dialog.close(); 
                    }else{                      
                     	 toastr.warning( "Debe a&ntilde;adir una ubicacion", "Publicacion" );
                    }
                  
                  }}
                  <?php } ?>
                ],
        onshown: function(dialog){
          dialog.getModalBody().find("#rptshwrpmchk").prop("checked", ( $("#<?= $lv_sec; ?> #rptshwrpm").prop("value")=="1"?true:false) );
        }
      });
    });
	</script>
	<script>
		// HERRAMIENTAS. CONFIGURACION
		
		// TABLA. abro el dialogo de configuracion de tablas
    function <?= $lv_sec; ?>_openTableConfig(){
			BootstrapDialog.show({
				title: "<?= $vew_lang->table; ?>", 
				message: $("#<?= $lv_sec; ?> #crdtabdat").clone().removeClass("hidden").prop("id","<?= $lv_sec; ?>_tblcfg"),
				size: BootstrapDialog.SIZE_WIDE,
				type: BootstrapDialog.TYPE_PRIMARY,
        closable: true,
				draggable: true,
				buttons: [<?php if(!$vew_readonly){ ?>
          				{ label: "<?= $vew_lang->delete; ?>", cssClass: "btn-warning pull-left", id:"btndel", action: function(dialog){ <?= $lv_sec; ?>_deleteElement( $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active") ); dialog.close(); }},
									{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", id:"btncnc", action: function(dialog){ dialog.close(); } },
									{ label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success", action: function(dialog){
                    // si no hay título definido devuelvo warning y cancelo la ejecución
                    if ( (dialog.getModalBody().find("input#tblttl").val()??"") == "" ){
                      toastr.warning("Debe asignar un t&iacute;tulo a la tabla."); return;
                    }       
          					
										var lv_coldat=[];
										dialog.getModalBody().find(".tmssReportCol .tmssTableDraggable").each(function(){ lv_coldat.push({"rptsrccolcod":$(this).data("rptsrccolcod")}); });
										var lv_rowdat=[];
										dialog.getModalBody().find(".tmssReportRow .tmssTableDraggable").each(function(){ lv_rowdat.push({"rptsrccolcod":$(this).data("rptsrccolcod")}); });
										var lv_datdat=[];
										dialog.getModalBody().find(".tmssReportDat .tmssTableDraggable").each(function(){ lv_datdat.push({"rptsrccolcod":$(this).data("rptsrccolcod"),"fldcal":$(this).data("fldcal")}); });
										
										// valido formulario
										if( lv_rowdat.length>0 && lv_datdat.length==0 ){
											toastr.warning("Si indic&oacute; agrupamiento debe indicar campos a calcular.");
											return false;
										}
										
										// asigno los valores del formualrio como DATA del div seleccionado
      							var lv_sel = $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active");
										$(lv_sel).data("tblrowfld",JSON.stringify(lv_rowdat))
														 .data("tblcolfld",JSON.stringify(lv_coldat))
														 .data("tbldatfld",JSON.stringify(lv_datdat))
														 .data("tblttl",dialog.getModalBody().find("#tblttl").val())
                    				 .data("tblttlshw", !!dialog.getModalBody().find("#tblttlshw").is(":checked"));
										dialog.close(); 
									}}
        					<?php } ?>],
				onhidden: function(dialog){ $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active").removeClass("active"); },
				onshown: function(dialog){
          // si el elemento había sido borrado previamente, le saco esa clase
          $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active").removeClass("deleted");
          
					var lv_fldlst = $("#<?= $lv_sec; ?> #rptsrcfld").prop("value");
					if( lv_fldlst==""){ 
						toastr.warning("Debe indicar primero un Origen de Datos."); 
					} else {
						// cargo la lista de campos del origen de datos
						var lv_fld = JSON.parse( (lv_fldlst==""?"[]":lv_fldlst) );
						for(var i=0; i<lv_fld.length; i++){
              dialog.getModalBody().find("#fldlst .card-body").append( "<div data-rptsrccolcod='"+lv_fld[i].rptsrccolcod+"' data-fldnme='"+lv_fld[i].rptsrccolcodext+"' data-fldtxt='"+lv_fld[i].rptsrccoltxt+"' data-sysfldinptyp='"+lv_fld[i].sysfldinptyp+"' class='tmssTableDraggable tmssTag'>"+lv_fld[i].rptsrccoltxt+"</div>" );
						}
					}
					
          // asigno el título guardado al input y el valor del toggle para mostrar
          dialog.getModalBody().find("input#tblttl").val( $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active").data("tblttl") );
          dialog.getModalBody().find("#tblttlshw").prop( "checked", $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active").data("tblttlshw")=="1" ? true : false );
          
					// cargo los valores existentes en el objeto
					var lv_fld = "<span class='tmssTableDraggable tmssTag tmssNoDraggable' style='white-space:nowrap; margin:2px; line-height: 45px; padding: 7px; cursor: pointer;' data-rptsrccolcod='' data-fldnme='' onclick='<?= $lv_sec; ?>_showTableFieldConfig($(this));'><span></span><?= ($vew_readonly?'':'<a href='.chr(39).'#'.chr(39).' style='.chr(39).'padding: 5px;'.chr(39).' data-rptsrccolcod='.chr(39).chr(39).' data-fldnme='.chr(39).chr(39).' onclick='.chr(39).$lv_sec.'_deleteTableFieldConfig($(this));'.chr(39).'><small><i class='.chr(39).'fas fa-times'.chr(39).'></i></small></a>'); ?></span>";
					var lv_sel = $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active");
					var lv_dat = $(lv_sel).data("tblrowfld");
          if(typeof lv_dat=="string"){ lv_dat = JSON.parse( (lv_dat==""?"[]":lv_dat) ); }
					if(typeof lv_dat=="object"){
						for(var i=0; i<lv_dat.length; i++){
							// obtengo nombre de campo
							var lv_fldtxt = dialog.getModalBody().find("#fldlst .card-body div[data-rptsrccolcod='"+lv_dat[i].rptsrccolcod+"']").data("fldtxt");
							var lv_fldcpy = $(lv_fld).clone().data("rptsrccolcod",lv_dat[i].rptsrccolcod);
							$(lv_fldcpy).find("a:first").data("rptsrccolcod",lv_dat[i].rptsrccolcod);
							$(lv_fldcpy).find("span:first").html(lv_fldtxt);
							// agrego elemento
							dialog.getModalBody().find(".tmssTableDroppable.tmssReportRow").append( $(lv_fldcpy) );
							// oculto campo el lista de campos
							dialog.getModalBody().find("#fldlst .card-body div[data-rptsrccolcod='"+lv_dat[i].rptsrccolcod+"']").addClass("hidden");
						}
					}
					var lv_dat = $(lv_sel).data("tblcolfld");
          if(typeof lv_dat=="string"){ lv_dat = JSON.parse( (lv_dat==""?"[]":lv_dat) ); }
					if(typeof lv_dat=="object"){
						for(var i=0; i<lv_dat.length; i++){
							// obtengo nombre de campo
							var lv_fldtxt = dialog.getModalBody().find("#fldlst .card-body div[data-rptsrccolcod='"+lv_dat[i].rptsrccolcod+"']").data("fldtxt");
							var lv_fldcpy = $(lv_fld).clone().data("rptsrccolcod",lv_dat[i].rptsrccolcod);              
							$(lv_fldcpy).find("a:first").data("rptsrccolcod",lv_dat[i].rptsrccolcod);
              $(lv_fldcpy).find("span:first").html(lv_fldtxt);
							// agrego elemento
							dialog.getModalBody().find(".tmssTableDroppable.tmssReportCol").append( $(lv_fldcpy) );
							// oculto campo el lista de campos
							dialog.getModalBody().find("#fldlst .card-body div[data-rptsrccolcod='"+lv_dat[i].rptsrccolcod+"']").addClass("hidden");
						}
					}
					var lv_dat = $(lv_sel).data("tbldatfld");
          if(typeof lv_dat=="string"){ lv_dat = JSON.parse(  (lv_dat==""?"[]":lv_dat) ); }
					if(typeof lv_dat=="object"){
						for(var i=0; i<lv_dat.length; i++){
							// obtengo nombre de campo
							var lv_fldtxt = dialog.getModalBody().find("#fldlst .card-body div[data-rptsrccolcod='"+lv_dat[i].rptsrccolcod+"']").data("fldtxt");
							var lv_fldcpy = $(lv_fld).clone().data("rptsrccolcod",lv_dat[i].rptsrccolcod).data("fldcal",lv_dat[i].fldcal);
							$(lv_fldcpy).find("a:first").data("rptsrccolcod",lv_dat[i].rptsrccolcod);
							$(lv_fldcpy).find("span:first").html(lv_fldtxt);
							// agrego elemento
							dialog.getModalBody().find(".tmssTableDroppable.tmssReportDat").append( $(lv_fldcpy) );
							// oculto campo el lista de campos
							dialog.getModalBody().find("#fldlst .card-body div[data-rptsrccolcod='"+lv_dat[i].rptsrccolcod+"']").addClass("hidden");
						}
					}
					
					// activo eventos drag&drop
					const lo_body = dialog.getModalBody();
          // defino función común para aplicar estilo uniforme
          function <?= $lv_sec; ?>_styleItem(lp_element) {
            lp_element.css( {"width": "100%","display": "flex","align-items": "center","justify-content": "space-between","background-color": "#f8f9fa","border": "1px solid #dee2e6","border-radius": "4px","margin": "4px 0","padding": "6px 10px","cursor": "move","height": "36px","box-sizing": "border-box","white-space": "nowrap","overflow": "hidden","text-overflow": "ellipsis"} );
          }
          lo_body.find(".tmssTableDraggable").each(function() { <?= $lv_sec; ?>_styleItem($(this)); });
          // inicializo drag solo dentro de las zonas dropeables y si no estoy en solo lectura
         <?php if(!$vew_readonly){ ?>
            // hago sortable todas las zonas dropeables (filas, columnas, datos)
            lo_body.find(".tmssTableDroppable").sortable({
              connectWith: ".tmssTableDroppable, #fldlst .card-body",
              placeholder: "ui-state-highlight",
              forcePlaceholderSize: true,
              revert: 100,
              tolerance: "pointer",
              items: ".tmssTableDraggable",
              start: function (event, ui) {
                ui.placeholder.height(ui.helper.outerHeight());
              },
             receive: function (event, ui) {
              // item original (en #fldlst)
              var lv_item = $(ui.item);
              var lv_fldnme = lv_item.data("fldnme");
              var lv_rptsrccolcod = lv_item.data("rptsrccolcod");

              // clon recién insertado dentro del droppable destino
              var lv_cln = $(this).find("[data-rptsrccolcod='"+lv_rptsrccolcod+"']").last();
            
              // aplico estilo al clon
              <?= $lv_sec; ?>_styleItem(lv_cln);

              // agrego botón de eliminar si no existe
              if (lv_cln.find("a[data-rptsrccolcod]").length === 0) {
                const lv_btn = $("<a href='#' data-rptsrccolcod style='padding:5px;'><small><i class='fas fa-times'></i></small></a>")
                  .data("rptsrccolcod", lv_rptsrccolcod)
                  .on("click", function (e) {
                    e.preventDefault();
                    <?= $lv_sec; ?>_deleteTableFieldConfig($(this));
                  });
                lv_cln.append(lv_btn);
              }

              // configuro onclick según la zona
              if ($(this).hasClass("tmssReportDat")) {
                lv_cln.attr("onclick", "<?= $lv_sec; ?>_showTableFieldConfig($(this));");
              } else {
                lv_cln.removeAttr("onclick");
              }

              // oculto original en #fldlst
              lv_item.addClass("hidden");
              },
              remove: function (event, ui) {
                // cuando se remueve (arrastrado fuera o eliminado), muestro el original si existe
                var lv_rptsrccolcod = $(ui.item).data("rptsrccolcod") || $(ui.item).find("[data-rptsrccolcod]").data("rptsrccolcod");
                if(lv_rptsrccolcod){
                  lo_body.find("#fldlst .card-body div[data-rptsrccolcod='"+lv_rptsrccolcod+"']").removeClass("d-none");
                }
              }
            }).disableSelection();

            // esto permite arrastrar una copia hacia la tabla dejando el original en #fldlst
            lo_body.find("#fldlst .card-body div.tmssTableDraggable").each(function(){
              $(this).draggable({
                connectToSortable: ".tmssTableDroppable",
                helper: "clone",
                appendTo: "body",
                revert: "invalid",
                zIndex: 100,
                start: function(event, ui){
                  // aseguro ancho y copio data al helper para que el clon lleve la info
                  ui.helper.css("width", $(this).width());
                  // copio atributos/data al helper
                  try {
                    var lv_rptsrccolcod = $(this).data("rptsrccolcod");
                    var lv_fldtxt = $(this).data("fldtxt") || $(this).text();
                    ui.helper.attr("data-rptsrccolcod", lv_rptsrccolcod).attr("data-fldtxt", lv_fldtxt).data("rptsrccolcod", lv_rptsrccolcod).data("fldtxt", lv_fldtxt);
                    // si el elemento tiene children (span, a), copio el HTML visible también:
                    ui.helper.html($(this).html());
                  } catch(e){}
                }
              });
            });
        	<?php } ?>

          // placeholder visual uniforme
          $("<style>").prop("type", "text/css").html(`.ui-state-highlight { height: 36px !important; background: #e9ecef; border: 2px dashed #adb5bd; border-radius: 4px; margin-bottom: 4px; }`).appendTo("head");					
				}
			});
		}

    
		function <?= $lv_sec; ?>_showTableFieldConfig( lp_fld ) {
			$.each(BootstrapDialog.dialogs, function(id, dialog){
        if( dialog.getModalBody().find("#<?= $lv_sec; ?>_tblcfg").length>0){
          if( $(lp_fld).parent().hasClass("tmssReportDat") ){
            dialog.getModalBody().find("#flddatcfg").removeClass("hidden"); 
            dialog.getModalBody().find("#fldlst").addClass("hidden");
            dialog.getModalBody().find("#flddatcfg").data("rptsrccolcod", $(lp_fld).data("rptsrccolcod"));
            dialog.getModalBody().find("#flddatcfg .card-body select:first option[value='"+$(lp_fld).data("fldcal")+"']").prop("selected",true);
						if($(lp_fld).data("sysfldinptyp")!="NUMBER"){
							dialog.getModalBody().find("#flddatcfg .card-body select:first option[data-group='number']").addClass("hidden");
						} else {
							dialog.getModalBody().find("#flddatcfg .card-body select:first option").removeClass("hidden");
						}
          }
				}
      });
		}
		function <?= $lv_sec; ?>_cancelTableFieldConfig(){
			$.each(BootstrapDialog.dialogs, function(id, dialog){
        if( dialog.getModalBody().find("#<?= $lv_sec; ?>_tblcfg").length>0){
					dialog.getModalBody().find("#flddatcfg").addClass("hidden"); 
					dialog.getModalBody().find("#fldlst").removeClass("hidden");
				}
      });
		}
		function <?= $lv_sec; ?>_acceptTableFieldConfig(){
			$.each(BootstrapDialog.dialogs, function(id, dialog){
        if( dialog.getModalBody().find("#<?= $lv_sec; ?>_tblcfg").length>0){
					dialog.getModalBody().find("#flddatcfg").addClass("hidden"); 
					dialog.getModalBody().find("#fldlst").removeClass("hidden");
          var lv_fld = dialog.getModalBody().find(".tmssTableDroppable.tmssReportDat span").filter(function () { return $(this).data("rptsrccolcod") == dialog.getModalBody().find("#flddatcfg").data("rptsrccolcod"); });
          //var lv_fld = dialog.getModalBody().find(".tmssTableDroppable.tmssReportDat span[data-rptsrccolcod='"++"']");
					$(lv_fld).data("fldcal", dialog.getModalBody().find("#flddatcfg .card-body select:first option:selected").val() );
				}
      });
		}
    function <?= $lv_sec; ?>_deleteTableFieldConfig(lp_fld){
      $.each(BootstrapDialog.dialogs, function(id, dialog){
        if( dialog.getModalBody().find("#<?= $lv_sec; ?>_tblcfg").length>0){
          var lv_rptsrccolcod = $(lp_fld).data("rptsrccolcod");
          var lv_org = dialog.getModalBody().find("#fldlst .card-body div[data-rptsrccolcod='"+lv_rptsrccolcod+"']");

          if(lv_org.length){
            // Si existe en el listado, mostrarlo
            lv_org.removeClass("hidden");
          } else {
            // Si no existe (caso raro), recrearlo y agregarlo al listado
            var lv_fldtxt = $(lp_fld).parent().find("span:first").text() || lv_rptsrccolcod;
            var lv_new = $("<div>").addClass("tmssTableDraggable tmssTag").attr("data-rptsrccolcod", lv_rptsrccolcod).attr("data-fldtxt", lv_fldtxt).text(lv_fldtxt);

            // Hacerlo draggable igual que los demás originales
            lv_new.draggable({
              connectToSortable: ".tmssTableDroppable",
              helper: "clone",
              revert: "invalid",
              zIndex: 100,
              start: function(event, ui){
                ui.helper.css("width", $(this).width());
              }
            });

            dialog.getModalBody().find("#fldlst .card-body").append(lv_new);
          }

          // elimino el elemento actual de la tabla
          $(lp_fld).parent().remove();
        }
      });
    }

    
		// GRAFICO. abre el dialogo de configuración de graficos
		function <?= $lv_sec; ?>_openChartConfig(){ 
			BootstrapDialog.show({
				title: "<?= $vew_lang->graph; ?>", 
				message: $("#<?= $lv_sec; ?> #crdgrpdat").clone().removeClass("hidden"),
				type: BootstrapDialog.TYPE_PRIMARY,
        closable: true,
				draggable: true,
				buttons: [<?php if(!$vew_readonly){ ?>
          				{ label: "<?= $vew_lang->delete; ?>", cssClass: "btn-warning pull-left", id:"btndel", action: function(dialog){ <?= $lv_sec; ?>_deleteElement( $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active") ); dialog.close(); }},
									{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialog){ dialog.close(); } },
									{ label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success", action: function(dialog){
										// asigno los valores del formualrio como DATA del div seleccionado
										var lv_sel = $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active");
										var lv_grptyp = dialog.getModalBody().find("div[name=grptyp] a.active").prop("name");
										$(lv_sel).data("grptyp",lv_grptyp)
														.data("grpttl",dialog.getModalBody().find("#grpttl").val())
														.data("grplgnpos",dialog.getModalBody().find("#grplgnpos option:selected").val())
														.data("grpdatfld",dialog.getModalBody().find("#grpdatfld option:selected").val())
														.data("grpdatrowfld",dialog.getModalBody().find("#grpdatrowfld option:selected").val())
														.data("grpdatcolfld",dialog.getModalBody().find("#grpdatcolfld option:selected").val())
														.data("grpcal",dialog.getModalBody().find("#grpcal option:selected").val())
														.find("i").prop("class", "far fa-"+lv_grptyp+" fa-5x");
										dialog.close(); 
									}}
        					<?php } ?>],
				onhidden: function(dialog){ $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active").removeClass("active"); },
				onshown: function(dialog){					
          // si el elemento había sido borrado previamente, le saco esa clase
          $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active").removeClass("deleted");
          
					if($("#<?= $lv_sec; ?> #rptsrcfld").prop("value")==""){ toastr.warning("Debe indicar primero un Origen de Datos."); }
					// attach de evento - tipo de grafico
					dialog.getModalBody().find("div[name=grptyp] a").on("click",function(e){ e.preventDefault();
						dialog.getModalBody().find("div[name=grptyp] a").removeClass("active");
						$(this).addClass("active");
						if($(this).find("i").hasClass("fa-chart-pie")){
							dialog.getModalBody().find("#divgrponedat").removeClass("hidden");
							dialog.getModalBody().find("#divgrptwodat").addClass("hidden");
						}else{
							dialog.getModalBody().find("#divgrponedat").addClass("hidden");
							dialog.getModalBody().find("#divgrptwodat").removeClass("hidden");
						}
					});
					// attach evento - campo
					dialog.getModalBody().find("#grpdatfld").on("change",function(){
						if($(this).find("option:selected").data("sysfldinptyp")=="NUMBER"){
							if(dialog.getModalBody().find("#grpcal option[data-group=number]").length==0){
								dialog.getModalBody().find("#grpcal").append("<option value='sum' data-group='number'>Suma</option>");
							}
						} else {
							dialog.getModalBody().find("#grpcal option[data-group=number]").remove();
						}
					});
					// asigna los valores del elemento seleccionado al formulario
					var lv_sel = $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active");
					var lv_grptyp = $(lv_sel).data("grptyp");
					dialog.getModalBody().find("div[name=grptyp] a[name="+lv_grptyp+"]").addClass("active").trigger("click");
					dialog.getModalBody().find("#grpttl").prop("value", $(lv_sel).data("grpttl"));
					dialog.getModalBody().find("#grplgnpos option[value='"+$(lv_sel).data("grplgnpos")+"']").prop("selected",true);
					dialog.getModalBody().find("#grpcal option[value='"+$(lv_sel).data("grpcal")+"']").prop("selected",true);
					// cargo la lista de campos del origen de datos
					var lv_fld = JSON.parse( $("#<?= $lv_sec; ?> #rptsrcfld").prop("value") );
					for(var i=0; i<lv_fld.length; i++){
						dialog.getModalBody().find("#grpdatfld").append("<option value='"+lv_fld[i].rptsrccolcodext+"' data-sysfldinptyp='"+lv_fld[i].sysfldinptyp+"' "+($(lv_sel).data("grpdatfld")==lv_fld[i].rptsrccolcodext?"SELECTED":"")+">"+lv_fld[i].rptsrccoltxt+"</option>");
						dialog.getModalBody().find("#grpdatcolfld").append("<option value='"+lv_fld[i].rptsrccolcodext+"' data-sysfldinptyp='"+lv_fld[i].sysfldinptyp+"' "+($(lv_sel).data("grpdatcolfld")==lv_fld[i].rptsrccolcodext?"SELECTED":"")+">"+lv_fld[i].rptsrccoltxt+"</option>");
						dialog.getModalBody().find("#grpdatrowfld").append("<option value='"+lv_fld[i].rptsrccolcodext+"' data-sysfldinptyp='"+lv_fld[i].sysfldinptyp+"' "+($(lv_sel).data("grpdatrowfld")==lv_fld[i].rptsrccolcodext?"SELECTED":"")+">"+lv_fld[i].rptsrccoltxt+"</option>");
					}
				}
			});
		}
		
		// PERSONALIZADO. abre el dialogo de configuración de seccion personalizada
		function <?= $lv_sec; ?>_openCustomConfig(){ 
			BootstrapDialog.show({
				title: "<?= $vew_lang->url; ?>", 
				message: $("#<?= $lv_sec; ?> #crdzcudat").clone().removeClass("hidden"),
				type: BootstrapDialog.TYPE_PRIMARY,
        closable: true,
				draggable: true,
				buttons: [<?php if(!$vew_readonly){ ?>
          				{ label: "<?= $vew_lang->delete; ?>", cssClass: "btn-warning pull-left", id:"btndel", action: function(dialog){ <?= $lv_sec; ?>_deleteElement( $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active") ); dialog.close(); }},
									{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialog){ dialog.close(); } },
									{ label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success", action: function(dialog){
										// asigno los valores del formualrio como DATA del div seleccionado
										var lv_sel = $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active");
										$(lv_sel).data("zcuurl",dialog.getModalBody().find("#zcuurl").val());
										dialog.close();
									}}
        					<?php } ?>],
				onhidden: function(dialog){ $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active").removeClass("active"); },
				onshown: function(dialog){
          // si el elemento había sido borrado previamente, le saco esa clase
          $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active").removeClass("deleted");
          
					if($("#<?= $lv_sec; ?> #rptsrcfld").prop("value")==""){ toastr.warning("Debe indicar primero un Origen de Datos."); }
					// asigna los valores del elemento seleccionado al formulario
					var lv_sel = $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active");
					dialog.getModalBody().find("#zcuurl").prop("value", $(lv_sel).data("zcuurl"));
				}
			});
		}		
		
		// BORRAR. borra un elemento de la grilla
		function <?= $lv_sec; ?>_deleteElement( lp_div ){
			var lv_sel = $("#<?= $lv_sec; ?> .tmssLayoutDroppable.active");
			$(lv_sel).find("i").remove();
      $(lv_sel).addClass("deleted");
			if($("#<?= $lv_sec; ?> .tmssLayoutDroppable").find("i")==0){
				$("#<?= $lv_sec; ?> .tmssLayoutDroppable").find("h3").removeClass("hidden");
			}
		}
		
		// CONFIGURACION. al hacer click en un elemento se abre la configuracion de tabla/grafico/codigo
		function <?= $lv_sec; ?>_showConfig( lp_div ){
      switch( $(lp_div).data("crdtyp") ){
        case "grp": $("#<?= $lv_sec; ?> .tmssLayoutDroppable").removeClass("active");	$(lp_div).addClass("active"); <?= $lv_sec; ?>_openChartConfig(); break;
        case "tbl": $("#<?= $lv_sec; ?> .tmssLayoutDroppable").removeClass("active");	$(lp_div).addClass("active"); <?= $lv_sec; ?>_openTableConfig(); break;
        case "zcu": $("#<?= $lv_sec; ?> .tmssLayoutDroppable").removeClass("active");	$(lp_div).addClass("active"); <?= $lv_sec; ?>_openCustomConfig(); break;
      }
		}
	</script>
  <script>	
		// INICIO. al iniciar se cargan librerias drag&drop y se incializan los eventos
		$(function(){ 
			tmssLoadScript("jquery-ui", function(){
        <?php if(!$vew_readonly){ ?>
        	$("#<?= $lv_sec; ?> .tmssToolsDraggable").draggable({ zIndex:100, scroll:false, revert:true, revertDuration:0, helper:"clone" }); 
          <?= $lv_sec; ?>_setDragDropEvents();
        <?php } ?>
			}); 
		});
		
		// inicializan los eventos de drag&drop de los íconos de gráfico, tabla y url
		function <?= $lv_sec; ?>_setDragDropEvents(){
			$("#<?= $lv_sec; ?> .tmssLayoutDroppable").droppable({
				accept: ".tmssToolsDraggable",
				classes: {"ui-droppable-hover": "active"},
				drop: function( event, ui ) {
					if($(ui.draggable).hasClass("tmssToolsDraggable")){
						$(this).data("crdtyp",$(ui.draggable).data("crdtyp")).data("tblcolfld","").data("tblrowfld","").data("tbldatfld","");
						$(this).find("h3").addClass("hidden");
						$(this).find("i").remove();
						$(this).append("<i class='"+$(ui.draggable).find("i").attr("class")+" fa-5x'></i>");
						<?= $lv_sec; ?>_showConfig( $(this) );
					}
				}
			});
    }

		// PREVIEW. abro el dialogo para mostrar el reporte creado
		$("#<?= $lv_sec; ?> #btnshw").on("click",function(e){e.preventDefault();
			<?= $lv_sec; ?>_serializeForm();
			var lv_pstdat = [{name:"rptsrccod",value:$("#<?= $lv_sec ;?> #rptsrccod").val()},{name:"rptsrcsys",value:$("#<?= $lv_sec; ?> #rptsrcsystyp").val()},{name:"rptatr",value:$("#<?= $lv_sec; ?> #rptatr").prop("value")},{name:"popup",value:"X"}];
			tmssCallProcess("?prg=grlrptdsg&act=show",lv_pstdat,function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->preview; ?>", 
					message: $(data),
					size: BootstrapDialog.SIZE_WIDE,
					type: BootstrapDialog.TYPE_PRIMARY,
					draggable: true,
					closable: true
				});
			});
		});	
	
		// SERIALIZE FORM. convierte los datos del formulario en string
		function <?= $lv_sec;?>_serializeForm(){
			// elementos del reporte
			// layout:
			// - rows: se determinan contando los elementos "row" del array "rows"
			// - cols: para cada "row" se determina contando los elementos "card"
			var lv_rptatr ={'rptttl':$("#<?= $lv_sec; ?> #rptttl").prop("value"), 
                      'rptflt': $("#<?= $lv_sec; ?> #rptatrflt").prop("value"), 
                      'subrpt': $("#<?= $lv_sec; ?> #subrpt").prop("value"),
                      'rptsrcsystyp': $("#<?= $lv_sec; ?> #rptsrcsystyp").prop("value"),
                      'rows':[]};
      
      var lv_vldttl = true; // valido que todas las tablas tengan título
			for(var i=0; i<$("#<?= $lv_sec; ?> #divlay .row").length; i++){	
				var lv_crd = [];
				$("#<?= $lv_sec; ?> #divlay .row:nth-child("+(i+1)+") .tmssLayoutDroppable").each( function(){
          if ( !$(this).hasClass("deleted") ){
            switch($(this).data("crdtyp")){
              case "tbl":
                if (!$(this).data("tblttl") || $(this).data("tblttl").trim() === "") {
                  lv_vldttl = false;
                  toastr.warning("Debe asignar un t&iacute;tulo a todas las tablas del reporte."); return false; // rompe el each interno
                }
                lv_crd.push( {"crdtyp":"tbl","tblrowfld":$(this).data("tblrowfld"),"tblcolfld":$(this).data("tblcolfld"),"tbldatfld":$(this).data("tbldatfld"), "tblttl":$(this).data("tblttl"), "tblttlshw":$(this).data("tblttlshw")} );
                break;
              case "zcu":
                lv_crd.push( {"crdtyp":"zcu","zcuurl":$(this).data("zcuurl")} );
                break;
              case "grp":
                lv_crd.push( {"crdtyp":"grp","grptyp":$(this).data("grptyp"),"grpttl":$(this).data("grpttl"),"grplgnpos":$(this).data("grplgnpos"),"grpdatcolfld":$(this).data("grpdatcolfld"),"grpdatrowfld":$(this).data("grpdatrowfld"),"grpdatfld":$(this).data("grpdatfld"),"grpcal":$(this).data("grpcal")} );
                break;
            }
          }  
        });
        
        // si alguna de las tablas no tenía título, corto la ejecución
        if (!lv_vldttl) return false;
				lv_rptatr["rows"].push( lv_crd );
			}			
			$("#<?= $lv_sec; ?> #rptatr").prop("value",JSON.stringify( lv_rptatr ));
      return true;					
		}
  </script>
	<script>
		// SUBMIT. prepara los datos antes de grabar
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// GRABAR
			if ( lp_prm["action"]=="00" ) { if (!<?= $lv_sec;?>_serializeForm()) return false; }
		}
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
<?php
  // url del formulario
  $lv_lnk = '?prg=slsdsh';

  // campos requeridos
  $vew_input->RequiredFields( array() );

  // titulo
	$lv_title = $vew_lang->Contacts;

  // módulo y programa
  $lv_mdlcod = 'SLS';
  $lv_prgcod = '';

  // clave del documento
	$lv_dockey = '';

  // librería de estilos bootstrap
  include_once('_library.frm');

  $lv_crmcntper = array(0=>'Hoy',7=>'Semana',30=>'Mes',365=>'A&ntilde;o');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>" style="background-color: #f6f6f6 !important;">
	<link href="library\css\temasis\2.0.0\tmssStyleDashboard.css" rel="stylesheet">

	<?php include('grldocfrmtlb.frm'); ?>

  <nav class="navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
      <ul class="nav navbar-nav tmss-navbar-left">
        <!-- NUEVO -->
        <?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01')) { ?><a href="#" onclick="tmssLink('?prg=crmcnt&act=01', [{target: '_new_section',target_id: '#<?= $lv_sec; ?>'}]);"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->new; ?>"><span class="far fa-file"></span><span class="hidden-xs"> <?= $vew_lang->new; ?></span></a><?php } ?>
      </ul>
      <ul class="navbar-right btn-toolbar tmss-navbar-right">
        <!-- Canvas -->
        <a href="#" id="btncan" onclick="tmssLink('?prg=crmcnt&act=kan', [{target: '_replace_with',target_id: '#<?= $lv_sec; ?>'}]);" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->kanban; ?>"><i class="fas fa-align-left fa-rotate-90"></i></a>
				<!-- Preferiencias -->
				<a href="#" id="btnpref" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->preferences; ?>"><i style="width:20px" class="fas fa-user-cog"></i></a>
        <!--Filtro-->
        <a href="#" id="btnflt" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->filter; ?>"><span class="fas fa-filter"></span><span id="fltcnt" class="badge"></span></a>
        <!--Dropdown-->
        <div class="btn-group dropdown">
          <a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></a>
          <form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
            <!--Actualizar-->
            <li><a href="#" onclick="<?= $lv_sec; ?>_GridRefresh()" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
            <!--Ayuda-->
            <?php include('sysappprghlpbtn.frm'); ?>
          </form>
        </div>
        <!--Cerrar-->
        <a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->close; ?>"><i class="fas fa-times"></i></a>
      </ul>
    </div>
  </nav>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<input type="hidden" id="usrpref" name="usrpref" value="<?= json_encode($vew_data->cnt['cfg']); ?>">
    <input type="hidden" id="vewflt" name="vewflt" value="">
    <div class="container-fluid">

			<div class="col-sm-6">

				<div class="col-sm-6">
					<!-- Total de contactos -->
					<div class="dashboard-box">
						<div class="dashboard-icon dashboard-icon-green"><i class="fas fa-ticket-alt fa-3x"></i><small><?= $vew_data->cnt['cfg']['usrcod']; ?></small></div>
						<div class="dashboard-info">
							<h4><strong><?= $vew_lang->assigned; ?></strong></h4>
							<h3><strong><?= $vew_data->cnt['qty']; ?></strong></h3>
						</div>
					</div>
				</div>
				<div class="col-sm-6 hidden-xs">&nbsp;</div>

				<!-- Grillas -->
				<!-- contactos cargados(ultimos 5) -->
				<div class="col-md-12 col-xs-12">
					<label class="row">&Uacute;ltimos cargados</label>
					<div class="row">
						<table class="table table-hover table-bordered table-sm grid">
							<thead class="bg-success"><tr>
								<th><p>ID</p></th>
								<th><p><?= $vew_lang->title; ?></p></th>
								<th><p><?= $vew_lang->requester; ?></p></th>
								<th><p><?= $vew_lang->date; ?></p></th>
							</tr></thead>
							<tbody style="background-color:#ffffff;">
								<?php
									$lv_buffer = '';
									foreach ($vew_data->cnt['load'] as $lv_row) {
										$lv_buffer.='<tr><td>'.$lv_row['crmcntcod'].'</td>'
																.'<td>'.ucwords(strtolower($lv_row['crmcnttxt'])).'</td>'
																.'<td>'.$lv_row['crmcntsrctxt'].'</td>'
																.'<td>'.$lv_row['ctedte']->format('d-m-Y').'</td>'
																.'</tr>';
									}
									echo $lv_buffer;
								?>
							</tbody>
						</table>
					</div>
				</div>

				<!-- contactos cerrados(ultimos 5) -->
				<div class="col-md-12 col-xs-12">
					<label class="row">&Uacute;ltimos cerrados</label>
					<div class="row">
						<table class="table table-hover table-bordered table-sm grid">
							<thead class="bg-success"><tr>
								<th><p>ID</p></th>
								<th><p><?= $vew_lang->title; ?></p></th>
								<th><p><?= $vew_lang->requester; ?></p></th>
								<th><p><?= $vew_lang->date; ?></p></th>
							</tr></thead>
							<tbody style="background-color:#ffffff;">
								<?php
									$lv_buffer = '';
									foreach ($vew_data->cnt['cls'] as $lv_row) {
										$lv_buffer.='<tr><td>'.$lv_row['crmcntcod'].'</td>'
																.'<td>'.ucwords(strtolower($lv_row['crmcnttxt'])).'</td>'
																.'<td>'.$lv_row['crmcntsrctxt'].'</td>'
																.'<td>'.$lv_row['ctedte']->format('d-m-Y').'</td>'
																.'</tr>';
									}
									echo $lv_buffer;
								?>
							</tbody>
						</table>
					</div>
				</div>

			</div>
      <div class="col-sm-6">

				<!-- dashboard ESTADO -->
				<div class="col-xs-12 col-sm-12">
					<div class="dashboard-box">
						<div class="dashboard-box-title"><?= $vew_lang->status; ?></div>
						<div class="canvas-holder"><canvas id="sts" width="100%" height="300"></canvas></div>
					</div>
					<script>
						<?php
							$lv_lblsts='';
							$lv_datsts='';
							foreach ($vew_data->cnt['sts'] as $lv_row) {
								$lv_lblsts .= ($lv_lblsts==''?'':', ').'"'.ucwords(strtolower($lv_row['crmcntststxt'])).'"';
								$lv_datsts .= ($lv_datsts==''?'':', ').round($lv_row['crmcntstsqty'],0);
							}
							$lv_datsts .=', 0';//hace que el grafico empiese en 0
						?>
						var <?= $lv_sec; ?>_lv_data_adhesionsts = {
								labels: [<?= $lv_lblsts; ?>],
								datasets: [{
									data: [<?= $lv_datsts; ?>],
									backgroundColor: ["rgba(75,192,192,0.3)", "rgba(192,75,192,0.3)", "rgba(192,192,75,0.3)", "rgba(0,255,0,0.3)","rgba(255,0,0,0.3)","rgba(0,0,255,0.3)"]
								}]
						};
						var <?= $lv_sec; ?>_lv_opt_clasifsts = {
							maintainAspectRatio: false,
							animation: { animateRotate: true, animateScale: true },
							legend: { position: "none" },
							scale: { ticks: { beginAtZero: true }, reverse: false },
							title: { display: false, text: "", fontSize: 14, padding: 15 },
							layout: { padding: 6 }
						};
						var <?= $lv_sec; ?>_lo_chart_adhesionsts;
						tmssLoadScript("chart",function(){
							<?= $lv_sec; ?>_lo_chart_adhesionsts = new Chart( $("#<?= $lv_sec; ?> #sts"), {type: "bar", data: <?= $lv_sec; ?>_lv_data_adhesionsts, options: <?= $lv_sec; ?>_lv_opt_clasifsts});
						});
					</script>
				</div>

				<!-- dashboard TIPO -->
				<div class="col-xs-12 col-sm-6">
					<div class="dashboard-box">
						<div class="dashboard-box-title"><?= $vew_lang->type; ?></div>
						<div class="canvas-holder"><canvas id="tpe" width="100%" height="300"></canvas></div>
					</div>
					<script>
						<?php
							$lv_lbltyp='';
							$lv_dattyp='';
							foreach ($vew_data->cnt['typ'] as $lv_row) {
								$lv_lbltyp .= ($lv_lbltyp==''?'':', ').'"'.ucwords(strtolower($lv_row['crmcnttyptxt'])).'"';
								$lv_dattyp .= ($lv_dattyp==''?'':', ').round($lv_row['crmcnttypqty'],0);
							}
						?>
						var <?= $lv_sec; ?>_lv_data_adhesiontyp = {
								labels: [<?= $lv_lbltyp; ?>],
								datasets: [{
									data: [<?= $lv_dattyp; ?>],
									backgroundColor: ["rgba(75,192,192,0.3)", "rgba(192,75,192,0.3)", "rgba(192,192,75,0.3)", "rgba(75,192,75,0.3)"]
								}]
						};
						var <?= $lv_sec; ?>_lv_opt_adhesiontyp = {
							startAngle: -0.25 * Math.PI,
							maintainAspectRatio: false,
							scale: { ticks: { beginAtZero: true }, reverse: false },
							animation: { animateRotate: false, animateScale: true },
							legend: { position: "bottom" },
							title: { display: false, text: "b", fontSize: 14, padding: 15 },
							layout: { padding: 10 }
						};
						var <?= $lv_sec; ?>_lo_chart_adhesiontyp;
						tmssLoadScript("chart",function(){
							<?= $lv_sec; ?>_lo_chart_adhesiontyp = new Chart( $("#<?= $lv_sec; ?> #tpe"), {type: "doughnut", data: <?= $lv_sec; ?>_lv_data_adhesiontyp, options: <?= $lv_sec; ?>_lv_opt_adhesiontyp });
						});
					</script>
				</div>

				<!-- dashboard SOLICITANTE -->
				<div class="col-xs-12 col-sm-6">
					<div class="dashboard-box">
						<div class="dashboard-box-title"><?= $vew_lang->requester; ?></div>
						<div class="canvas-holder"><canvas id="cus" width="100%" height="300"></canvas></div>
					</div>
					<script>
						<?php
							$lv_lbltyp='';
							$lv_dattyp='';
							foreach ($vew_data->cnt['cus'] as $lv_row) {
								$lv_lbltyp .= ($lv_lbltyp==''?'':', ').'"'.ucwords(strtolower($lv_row['adrnme001'])).'"';
								$lv_dattyp .= ($lv_dattyp==''?'':', ').round($lv_row['adrnme001qty'],0);
							}
						?>
						var <?= $lv_sec; ?>_lv_data_adhesioncus = {
								labels: [<?= $lv_lbltyp; ?>],
								datasets: [{
									data: [<?= $lv_dattyp; ?>],
									backgroundColor: ["rgba(75,192,192,0.3)", "rgba(192,75,192,0.3)", "rgba(192,192,75,0.3)", "rgba(75,192,75,0.3)"]
								}]
						};
						var <?= $lv_sec; ?>_lv_opt_adhesioncus = {
							startAngle: -0.25 * Math.PI,
							maintainAspectRatio: false,
							scale: { ticks: { beginAtZero: true }, reverse: false },
							animation: { animateRotate: false, animateScale: true },
							legend: { position: "bottom" },
							title: { display: false, text: "", fontSize: 14, padding: 15 },
							layout: { padding: 10 }
						};
						var <?= $lv_sec; ?>_lo_chart_adhesioncus;
						tmssLoadScript("chart",function(){
							<?= $lv_sec; ?>_lo_chart_adhesioncus = new Chart( $("#<?= $lv_sec; ?> #cus"), {type: "pie", data: <?= $lv_sec; ?>_lv_data_adhesioncus, options: <?= $lv_sec; ?>_lv_opt_adhesioncus });
						});
					</script>
				</div>
			</div>
    </div>
  </form>
	<div class="hidden">
		<div class="container-fluid" id="frmcfg">
			<?php
				echo vew_boot($lv_col39, array('label'=>$vew_lang->responsible,'input'=>gethtml('usrcod', 'doccmt1x50', $vew_data->cnt['cfg']['usrcod'], $lv_default) ));
				echo vew_boot($lv_col39, array('label'=>$vew_lang->period,'input'=>gethtml('strdte',$lv_crmcntper, $vew_data->cnt['cfg']['strdte'], $lv_default) ));
			?>
		</div>
	</div>
</section>
<script>
  var gv_<?= $lv_sec; ?>_flt=[{'fldttl': '<?= $vew_lang->id; ?>','fldcod': 'c.crmcntcod', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
                              {'fldttl': '<?= $vew_lang->title; ?>','fldcod': 'c.crmcnttxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
                              {'fldttl': '<?= $vew_lang->type; ?>','fldcod': 't.crmcnttyptxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
                              {'fldttl': '<?= $vew_lang->motive; ?>' ,'fldcod': 'm.crmcntmtvtxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
                              {'fldttl': '<?= $vew_lang->priority; ?>' ,'fldcod': 'p.crmcntprttxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
                              {'fldcod': 'vewmaxrec','fldvalstr': '<?= ($vew_data->vewmaxrec!=''?$vew_data->vewmaxrec:'5') ?>'}];

  // filtro - boton
  $("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
    tmssFilterShowDialog(gv_<?= $lv_sec; ?>_flt, <?= $lv_sec; ?>_fltcrm);
    setTimeout(function(){
      $(".modal-dialog #vewmaxrec").attr("disabled", true);
    },200);
  });

  function <?= $lv_sec; ?>_fltcrm(lp_flt) {
    var lv_fltint;
    if(lp_flt!=null){
      lv_fltint = tmssFilterParseToInternal(lp_flt);
      gv_<?= $lv_sec; ?>_flt = lp_flt;
      $("#<?= $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
    } else {
      lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
    }
    if(lv_fltint!=$("#<?= $lv_sec; ?> #vewflt").prop("value")){
      $("#<?= $lv_sec; ?> #vewflt").prop("value",JSON.stringify(lv_fltint));
      tmssLink("?prg=crmcnt&act=dsh", [{target: "_replace_with", post_data: [{name:"vewflt",value:JSON.stringify(lv_fltint)}],target_id: "#<?= $lv_sec; ?>"}]);
    }
    gv_<?= $lv_sec; ?>_flt=tmssFilterParseToExternal( gv_<?= $lv_sec; ?>_flt , "<?= $vew_data->vewflt; ?>" );
    var lv_tmp = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
    $("#<?= $lv_sec; ?> #vewflt").prop("value",JSON.stringify(lv_tmp));
    $("#<?= $lv_sec; ?> #fltcnt").text( (lv_tmp["fltqty"]==0?"":lv_tmp["fltqty"]) );
  }

  $(function(){
    gv_<?= $lv_sec; ?>_flt=tmssFilterParseToExternal( gv_<?= $lv_sec; ?>_flt , "<?= $vew_data->vewflt; ?>" );
    var lv_tmp = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
    $("#<?= $lv_sec; ?> #vewflt").prop("value",JSON.stringify(lv_tmp));
    $("#<?= $lv_sec; ?> #fltcnt").text( (lv_tmp["fltqty"]==0?"":lv_tmp["fltqty"]) );
  });
</script>
<script>

	


  function <?= $lv_sec; ?>_GridRefresh(){
    tmssLink("?prg=crmcnt&act=dsh", [{target: "_replace_with",target_id: "#<?= $lv_sec; ?>"}]);
  }

  $("#<?= $lv_sec; ?> .grid tbody tr").on("click",function(e){e.preventDefault
    tmssLink("?prg=crmcnt&act=03&prm_crmcntcod="+$(this).children()[0].innerHTML, [{target: '_new_section',target_id: '#<?= $lv_sec; ?>'}]);
  });

  $("#<?= $lv_sec; ?> #btnpref").on("click",function(e){e.preventDefault
    BootstrapDialog.show({
      title:"<?= $vew_lang->preferences ?>",
      message:$("#<?= $lv_sec; ?> #frmcfg").clone(),
			draggable: true,
      buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialog){ dialog.close(); } },
                {	label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success",	action: function(dialog){
                  var lv_pref = [];
                  lv_pref.push( {name:"usrcod", value:dialog.$modalBody.find("#usrcod").val()},{name:"strdte", value:dialog.$modalBody.find("#strdte").val()} );
                  tmssLink("?prg=crmcnt&act=dsh&prm_sve=X", [{target: "_replace_with",target_id: "#<?= $lv_sec; ?>",post_data:lv_pref}]);
                  dialog.close();
                }}]
    });
  });
</script>
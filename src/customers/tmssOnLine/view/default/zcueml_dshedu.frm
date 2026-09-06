<?php		
	/* url del formulario */
  $lv_lnk = '?prg=zcueml&act=xxdshedu';

	/* campos requeridos */
	$vew_input->RequiredFields( array('') );

	/* clave del documento */
	$lv_dockey = '';

	/* titulo */
	$lv_title = $vew_lang->dashboard;
	
	/* módulo y programa */
	$lv_mdlcod = '';
	$lv_prgcod = '';
	$vew_actcod = '';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
	
	$lv_colarr = array( 
	'"rgba(235, 162, 54, 1)"', '"rgba(255, 99, 132, 1)"', '"rgba(162, 54, 235, 1)"', '"rgba(54, 162, 235, 1)"', '"rgba(255, 206, 86, 1)"', '"rgba(75, 192, 192, 1)"', '"rgba(153, 102, 255, 1)"', '"rgba(255, 159, 64, 1)"',
	'"rgba(99, 255, 132, 1)"',  '"rgba(206, 255, 86, 1)"', '"rgba(192, 75, 192, 1)"', '"rgba(102, 153, 255, 1)"', '"rgba(159, 255, 64, 1)"',
	'"rgba(132, 99, 255, 1)"', '"rgba(86, 206, 255, 1)"', '"rgba(192, 192, 75, 1)"', '"rgba(255, 102, 153, 1)"', '"rgba(64, 159, 255, 1)"',
	'"rgba(132, 255, 99, 1)"', '"rgba(235, 54, 162, 1)"', '"rgba(86, 255, 206, 1)"', '"rgba(192, 75, 192, 1)"', '"rgba(255, 153, 102, 1)"', '"rgba(64, 255, 159, 1)"'
	);

	$lv_colarr2 = array( 
	'"rgba(64, 159, 255, 1)"', '"rgba(99, 255, 132, 1)"', '"rgba(206, 255, 86, 1)"', '"rgba(132, 255, 99, 1)"', '"rgba(235, 54, 162, 1)"', '"rgba(86, 255, 206, 1)"', '"rgba(192, 75, 192, 1)"', '"rgba(255, 153, 102, 1)"', '"rgba(64, 255, 159, 1)"',
	'"rgba(132, 99, 255, 1)"', '"rgba(235, 162, 54, 1)"', '"rgba(86, 206, 255, 1)"', '"rgba(192, 192, 75, 1)"', '"rgba(255, 102, 153, 1)"', '"rgba(162, 54, 235, 1)"', '"rgba(192, 75, 192, 1)"', '"rgba(102, 153, 255, 1)"', '"rgba(159, 255, 64, 1)"',
	'"rgba(255, 99, 132, 1)"', '"rgba(54, 162, 235, 1)"', '"rgba(255, 206, 86, 1)"', '"rgba(75, 192, 192, 1)"', '"rgba(153, 102, 255, 1)"', '"rgba(255, 159, 64, 1)"'
	);
	
	$lo_chrarr = array();
	foreach($vew_data['hhrchrasg'] as $lv_row){
		if(isset($lo_chrarr[$lv_row['hhrchrclscod']])){
			$lo_chrarr[$lv_row['hhrchrclscod']]['hhrchrclsqty']++; 
		} else {
			$lo_chrarr[$lv_row['hhrchrclscod']] = array('hhrchrclstxt'=>ucwords($lv_row['hhrchrclstxt']),'hhrchrclsqty'=>1);
		}
	}		
	
	$lo_licarr = array();
	foreach($vew_data['hhrlic'] as $lv_row){
		if(isset($lo_licarr[$lv_row['hhrlictypcod']])){
			$lo_licarr[$lv_row['hhrlictypcod']]['hhrlictypqty']++; 
		} else {
			$lo_licarr[$lv_row['hhrlictypcod']] = array('hhrlictyptxt'=>ucwords($lv_row['hhrlictyptxt']),'hhrlictypqty'=>1);
		}
	}	
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>" style="background-color: #fafafa; height: calc(100vH - 105px);">
	<link href="library\css\temasis\2.0.0\tmssStyleDashboard.css" rel="stylesheet">
	<style>
		.dashboard-box{ background-color: #ffffff; cursor: pointer; -moz-osx-font-smoothing: grayscale; -webkit-font-smoothing: antialiased; font-family: Montserrat,sans-serif; }
		.dashboard-box:hover, .dashboard-box:hover h1, .dashboard-box:hover h3 { background-color: #2196f3 !important; color: #ffffff; }
		.dashboard-text { padding-top: 2px; padding-bottom: 2px; height: 100px; vertical-align: middle; text-align: center; }
		.dashboard-text h1 { font-size: 48px; padding: 0px; margin-top: 2px; margin-bottom: 2px; }
		.dashboard-text h3 { font-size: 20px; padding: 0px; margin-top: 2px; margin-bottom: 2px; }
	</style>
	
  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav btn-toolbar">
				<li class="navbar-brand"><i class="fas fa-tachometer-alt"></i> Dashboard</li>
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: 'prn'});" class="btn btn-default navbar-btn" title="<?= $vew_lang->print; ?>"><span class="fas fa-print"></span></a>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '99'});" class="btn btn-default navbar-btn"><span class="fas fa-sync"></span></a>
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn btn-default navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
	</nav>
	
	<form id="<?= $lv_sec; ?>_frm">
	<div class="container-fluid" style="padding-top: 20px; padding-bottom: 20px;">
		<div class="row">
			
			<!-- PERSONAL -->
			<?php if ($vew_sec->hasPermission('EDU', 'TCH','**')) { ?>
			<div class="col-xs-12 col-sm-6 col-md-3">
				<div class="dashboard-box" data-ctr="edutch" data-mdl="EDU" data-prg="TCH" data-vew="VEW_EDU_TCH">
					<div class="dashboard-icon" style="background-color: #009688;"><i class="fas fa-chalkboard-teacher fa-3x"></i></div>
					<div class="dashboard-text">
						<h1><?= count($vew_data['edutch']); ?></h1>
						<h3>Personal</h3>
					</div>
				</div>
			</div>
			<?php } ?>

			<!-- SUPLENCIAS -->
			<?php if ($vew_sec->hasPermission('HHR', 'SUB','**')) { ?>
			<div class="col-xs-12 col-sm-6 col-md-3">
				<div class="dashboard-box" data-ctr="hhrsub" data-mdl="HHR" data-prg="SUB" data-vew="VEW_HHR_SUB">
					<div class="dashboard-icon" style="background-color: #ff9800;"><i class="fas fa-user-friends fa-3x"></i></div>
					<div class="dashboard-text">
						<h1><?= count($vew_data['hhrsub']); ?></h1>
						<h3>Suplencias <small>(activas)</small></h3>
					</div>
				</div>
			</div>
			<?php } ?>

			<!-- INASISTENCIAS -->
			<?php if ($vew_sec->hasPermission('HHR', 'ASS','**')) { ?>
			<div class="col-xs-12 col-sm-6 col-md-3">
				<div class="dashboard-box" data-ctr="hhrass" data-mdl="HHR" data-prg="ASS" data-vew="VEW_HHR_ASS">
					<div class="dashboard-icon" style="background-color: #f44336;"><i class="fas fa-user-clock fa-3x"></i></div>
					<div class="dashboard-text">
						<h1><?= count($vew_data['hhrass']); ?></h1>
						<h3>Inasistencias <small>(ult.30 d&iacute;as)</small></h3>
					</div>
				</div>
			</div>
			<?php } ?>
			
			<!-- NOVEDADES  -->
			<?php if ($vew_sec->hasPermission('CRM', 'CNT','**')) { ?>
			<div class="col-xs-12 col-sm-6 col-md-3">
				<div class="dashboard-box" data-ctr="crmcnt" data-mdl="CRM" data-prg="CNT" data-vew="VEW_CRM_CNT">
					<div class="dashboard-icon" style="background-color: #8bc34a;"><i class="far fa-newspaper fa-3x"></i></div>
					<div class="dashboard-text">
						<h1><?= count($vew_data['crmcnt']); ?></h1>
						<h3>Novedades</h3>
					</div>
				</div>
			</div>
			<?php } ?>
			
			<!-- CARGOS -->
			<?php if ($vew_sec->hasPermission('HHR', 'CHA','**')) { ?>
			<div class="col-xs-12 col-sm-6 col-md-3">
				<div class="dashboard-box" data-ctr="hhrchrasg" data-mdl="HHR" data-prg="CHA" data-vew="VEW_HHR_CHR_ASG">
					<div class="dashboard-icon" style="background-color: #9c27b0;"><i class="fas fa-address-card fa-3x"></i></div>
					<div class="dashboard-text">
						<h1><?= count($vew_data['hhrchrasg']); ?></h1>
						<h3>Cargos</h3>
					</div>
				</div>
			</div>
			<?php } ?>

			<!-- CLASES DE CARGOS - BAR -->
			<?php if ($vew_sec->hasPermission('HHR', 'CHA','**')) { ?>
			<div class="col-xs-12 col-sm-6 col-md-3">
				<div style="background-color: #ffffff; padding: 5px; box-shadow: 0 1px 1px rgba(0,0,0,0.1) !important; border-radius: 2px !important; margin-bottom: 15px !important;">
					<div>Cargos por Clase</div>
					<div class="canvas-holder"><canvas id="hhrchrpie" width="100%" height="187"></canvas></div>
				</div>
			</div>
			<?php } ?>
				
			<!-- LICENCIAS -->
			<?php if ($vew_sec->hasPermission('HHR', 'LIC','**')) { ?>
			<div class="col-xs-12 col-sm-6 col-md-3">
				<div class="dashboard-box" data-ctr="hhrlic" data-mdl="HHR" data-prg="LIC" data-vew="VEW_HHR_LIC">
					<div class="dashboard-icon" style="background-color: #0084b4;"><i class="fas fa-calendar-check fa-3x"></i></div>
					<div class="dashboard-text">
						<h1><?= count($vew_data['hhrlic']); ?></h1>
						<h3>Licencias <small>(activas)</small></h3>
					</div>
				</div>
			</div>
			<?php } ?>
			
			<!-- LICENCIAS - PIE -->
			<?php if ($vew_sec->hasPermission('HHR', 'LIC','**')) { ?>
			<div class="col-xs-12 col-sm-6 col-md-3">
				<div style="background-color: #ffffff; padding: 5px; box-shadow: 0 1px 1px rgba(0,0,0,0.1) !important; border-radius: 2px !important; margin-bottom: 15px !important;">
					<div>Licencias por Tipo</div>
					<div class="canvas-holder"><canvas id="hhrlicpie" width="100%" height="187"></canvas></div>
				</div>
			</div>
			<?php } ?>
			
		</div>
	</div>
	</form>
	<script>
		$("#<?= $lv_sec; ?> .dashboard-box").on("click",function(e){ e.preventDefault();
			tmssLink("?prg="+$(this).data("ctr")+"&prm_mdlcod="+$(this).data("mdl")+"&prm_prgcod="+$(this).data("prg")+"&prm_vewcod="+$(this).data("vew"), [{target: '_new_section', post_data: []}] );			
		});
		function <?php echo $lv_sec; ?>_GridRefresh() {
			<?= $lv_sec; ?>_fnc({action: "99"});
		}
	</script>	
	<script>
		tmssLoadScript("chart",function(){ 
			
			var lv_dat = {
				labels: [ <?php $lv_buf=''; foreach($lo_licarr as $lv_row) {$lv_buf.=($lv_buf==''?'':',').'"'.$lv_row['hhrlictyptxt'].'"';} echo $lv_buf; ?>],
				datasets: [{
					backgroundColor: [ <?php $lv_buf=''; $i=0; foreach($lo_licarr as $lv_row) {$lv_buf.=($lv_buf==''?'':', ').$lv_colarr2[$i]; $i++; } echo $lv_buf; ?>],
					bordercolor: [ <?php $lv_buf=''; $i=0; foreach($lo_licarr as $lv_row) {$lv_buf.=($lv_buf==''?'':', ').$lv_colarr2[$i]; $i++;} echo $lv_buf; ?>],
					data: [ <?php $lv_buf=''; foreach($lo_licarr as $lv_row) {$lv_buf.=($lv_buf==''?'':', ').$lv_row['hhrlictypqty'];} echo $lv_buf; ?> ],
					fill: false,lineTension: 0.3,spanGaps: false,
				}]							
			};
			var lv_opt = { 
				maintainAspectRatio: false,
				animation: { animateRotate: true, animateScale: true }, 
				legend: { display: true,  position: "right" },
				title: { display: false, text: "", fontSize: 14, padding: 15 },
				layout: { padding: 5 }
			};
			var lo_Chart = new Chart($("#hhrlicpie"), { type:"pie", data:lv_dat, options:lv_opt });


			var lv_dat2 = {
				labels: [ <?php $lv_buf=''; foreach($lo_chrarr as $lv_row) {$lv_buf.=($lv_buf==''?'':',').'"'.$lv_row['hhrchrclstxt'].'"';} echo $lv_buf; ?>],
				datasets: [{
					backgroundColor: [ <?php $lv_buf=''; $i=0; foreach($lo_chrarr as $lv_row) {$lv_buf.=($lv_buf==''?'':', ').$lv_colarr[$i]; $i++; } echo $lv_buf; ?>],
					bordercolor: [ <?php $lv_buf=''; $i=0; foreach($lo_chrarr as $lv_row) {$lv_buf.=($lv_buf==''?'':', ').$lv_colarr[$i]; $i++;} echo $lv_buf; ?>],
					data: [ <?php $lv_buf=''; foreach($lo_chrarr as $lv_row) {$lv_buf.=($lv_buf==''?'':', ').$lv_row['hhrchrclsqty'];} echo $lv_buf; ?> ],
					fill: false,lineTension: 0.3,spanGaps: false,
				}]							
			};
			var lv_opt2 = { 
				maintainAspectRatio: false,
				animation: { animateRotate: true, animateScale: true }, 
				legend: { display: true,  position: "bottom" },
				title: { display: false, text: "", fontSize: 14, padding: 15 },
				layout: { padding: 5 }
			};
			var lo_Chart2 = new Chart($("#hhrchrpie"), { type:"doughnut", data:lv_dat2, options:lv_opt2 });
			
		});
	</script>
  <script>
    var gv_<?php echo $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $("#<?php echo $lv_sec; ?>_frm"), "<?php echo $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?php echo $lv_sec; ?>_last_action, "<?php echo $lv_title; ?>", "<b><?php echo $lv_dockey; ?></b>" ) ) {
				if (gv_<?php echo $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?php echo $lv_sec; ?>") );
				} else {
					$("#<?php echo $lv_sec; ?>").replaceWith( data );
				}
			}
    });
		
		// form submit
    function <?php echo $lv_sec; ?>_fnc( lp_prm ) {
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {
				gv_<?php echo $lv_sec; ?>_last_action = lp_prm["action"];
				var lv_action = (gv_<?php echo $lv_sec; ?>_last_action=="99"?"<?php echo ($vew_actcod=='02'?'02':'dshcus'); ?>":gv_<?php echo $lv_sec; ?>_last_action);
				tmssMessageProcessing( "<?php echo $lv_sec; ?>", lv_action, "<?php echo $lv_title; ?>", "<?php echo ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
			}
		}
		
		// edit mode
    tmssFormEdit("<?php echo $lv_sec; ?>",<?php echo ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>
</section>
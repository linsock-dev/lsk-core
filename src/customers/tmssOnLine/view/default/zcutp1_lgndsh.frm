<?php
	// url del formulario 
  $lv_lnk = 'index.php?prg=zcutp1_lgn';

	// campos requeridos 
	$vew_input->RequiredFields( array('dshstrdte','dshenddte') );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->dashboard;
	
	// módulo y programa 
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'TP1_login';

	// librería de estilos bootstrap 
	include_once('_library.frm');
	
	$vew_actcod = '02';
	
	$lv_colarr = array( '"rgba(255, 99, 132, 1)"', '"rgba(54, 162, 235, 1)"', '"rgba(255, 206, 86, 1)"', '"rgba(75, 192, 192, 1)"', '"rgba(153, 102, 255, 1)"', '"rgba(255, 159, 64, 1)"',
	'"rgba(99, 255, 132, 1)"', '"rgba(162, 54, 235, 1)"', '"rgba(206, 255, 86, 1)"', '"rgba(192, 75, 192, 1)"', '"rgba(102, 153, 255, 1)"', '"rgba(159, 255, 64, 1)"',
	'"rgba(132, 99, 255, 1)"', '"rgba(235, 162, 54, 1)"', '"rgba(86, 206, 255, 1)"', '"rgba(192, 192, 75, 1)"', '"rgba(255, 102, 153, 1)"', '"rgba(64, 159, 255, 1)"',
	'"rgba(132, 255, 99, 1)"', '"rgba(235, 54, 162, 1)"', '"rgba(86, 255, 206, 1)"', '"rgba(192, 75, 192, 1)"', '"rgba(255, 153, 102, 1)"', '"rgba(64, 255, 159, 1)"'
	);
	
	/*CHART 1:
		(CANTIDAD DE PEDIDOS POR CLASE / MES)
	*/
	$lv_chart1_arr=array();
	$i=0;
	foreach ($vew_data['pedmth'] as $lv_row=> $value ) {
		$lv_chart1_arr[$i]['label']=$lv_row;
		$lv_chart1_arr[$i]['data']=array();
		foreach ($value as $lv_rowData) {
			$lv_chart1_arr[$i]['data'][]=$lv_rowData;
		}
		$i++;
	}
?>
<section id="<?php echo $lv_sec; ?>" data-model="<?php echo $vew_model; ?>" data-title="<?php echo $lv_title; ?>" style="background-color: #f6f6f6 !important;">
	<link href="view\default\library\css\temasis\2.0.0\tmssStyleDashboard.css" rel="stylesheet">
  <nav class="navbar navbar-default tmss-navbar-fixed">
    <div class="container-fluid">
    	<ul class="nav navbar-nav">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><?php echo $vew_lang->reports; ?> <span class="caret"></span></a>
					<ul class="dropdown-menu">
						<?php if (/*$vew_sec->hasPermission('ZCU', 'TP3', 'R1')*/1==1) { ?><li><a href="#" id="repmovval">Mov. materiales Valorizados</a></li><?php } ?>
						<?php if (/*$vew_sec->hasPermission('ZCU', 'TP3', 'R1')*/1==1) { ?><li><a href="#" id="btnrpt002">Reporte 2</a></li><?php }?>
						<?php if (/*$vew_sec->hasPermission('ZCU', 'TP3', 'R1')*/1==1) { ?><li><a href="#" id="btnrpt003">Facturacion</a></li><?php }?>
            <?php if ($vew_data['matcstupdper']) { ?><li><a href="#" id="matcstupd">Act. de Costos</a></li><?php }?>
					</ul> 
				</li>
				<?php if (/*$vew_sec->hasPermission('ZCU', 'TP3','D1')*/1==1) { ?> 
	    		<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="fas fa-tachometer-alt"></span> Dashboard</a>
					</li>
				<?php }?>
			</ul> 
			
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<a href="#" onclick="<?php echo $lv_sec; ?>_fnc({action: 'prn'});" class="btn btn-default navbar-btn" title="<?php echo $vew_lang->print; ?>"><span class="fas fa-print"></span></a>
				<a href="#" onclick="<?php echo $lv_sec; ?>_fnc({action: '99'});" class="btn btn-default navbar-btn"><span class="fas fa-sync"></span></a>
				<a href="#" onclick="tmssTabSecCls( $('#<?php echo $lv_sec; ?>') );" id="btncls" class="btn btn-default navbar-btn" title="<?php echo $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
	</nav>

	<?php if (/*$vew_sec->hasPermission('ZCU', 'TP3','D1')*/1==1) { ?> 
		<div class="container-fluid">

				<div class="dashboard-title-box">
					<div class="row">
						<div class="col-sm-8 col-md-8">
							<h1 class="dashboard-title"><span class="fas fa-tachometer-alt"></span> Dashboard</h1> 
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-12 col-sm-6 col-md-3">
						<div class="dashboard-box">
							<div class="dashboard-icon dashboard-icon-red"><span class="fas fa-truck fa-3x"></span></div>
							<div class="dashboard-info">
								<label class="dashboard-label">Pedidos</label><br>
								<div class="dashboard-number"><?php echo $vew_data['pedqty']; ?></div>  
							</div>
						</div> 
					</div> <!-- /col-md-3 -->
				</div>	
				<div class="row"> 
					<!-- pedidos x mes -->
					<div class="col-xs-12 col-md-6">
						<div class="dashboard-box ttr-dashboard-box">
							<div class="dashboard-box-title">Ingreso de pedidos por mes<div class="pull-right"><a class="close-link"><i class="fas fa-table"></i></a></div></div>
							<div class="canvas-holder">
								<canvas id="pedmes" width="100%" height="300"></canvas>
							</div>
						</div>
						<script>

							tmssLoadScript("chart",function(){ 
							var ctx = $("#pedmes");
							var data={
								labels: ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"],
								datasets:[
									<?php
									$i=0;
									foreach ($lv_chart1_arr as $lv_row_data) {
									?>
										{
										label:"<?php echo $lv_row_data['label']; ?>",
										data:[<?php echo implode(',',$lv_row_data['data']); ?>],
										fill: false,
										backgroundColor: <?php echo $lv_colarr[$i]; ?>,
										/*backgroundColor: "rgba(255, 99, 132, 0.2)",*/
										lineTension: 0.2,
										spanGaps: false
										},
									<?php	
										$i++;	
									}
									?>
								]
							}
							/*
							var data = {
									labels: ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"],
									datasets: [{
											label: "X1",
											fill: false,
											backgroundColor: ["rgba(255, 99, 132, 1)"],
											lineTension: 0.3,
											data: [20,35,40,50,60,70,55,45,85,23,47,77],
											spanGaps: false,
										},
										{
											label: "X2",
											fill: false,
											backgroundColor: ["rgba(54, 162, 235, 1)"],
											lineTension: 0.3,
											data: [25,34,43,52,61,79,88,71,62,53,44,37],
											spanGaps: false,
										}
									]
							};
							*/
							var options = { 
								maintainAspectRatio: false,
								animation: { animateRotate: true, animateScale: true }, 
								legend: { display: true },
								tooltips: { enabled : true },
								layout: { padding: 10 }
							};
							var Chart1 = new Chart(ctx, { type: "line", data: data, options: options });
						});

					</script>



					</div> <!-- /pedidos x mes -->  
					<!-- pedidos x mes -->
					<div class="col-xs-12 col-md-6">
						<div class="dashboard-box ttr-dashboard-box"> 
							<div class="dashboard-box-title">Movimiento de materiales por mes<div class="pull-right"><a class="close-link"><i class="fas fa-table"></i></a></div></div>
							<div class="canvas-holder"> 
								<canvas id="movmes" width="100%" height="300"></canvas>
							</div>
						</div>
						<script>

							tmssLoadScript("chart",function(){ 
							var ctx = $("#movmes");
							var data={
								labels: ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"],
								datasets:[
								<?php
								$i=6;
								foreach ($vew_data['movmth'] as $lv_row_data=> $value) { 
								?>
									{
									label:"<?php echo $lv_row_data; ?>",
									data:[<?php echo implode(',',$value); ?>],
									fill: false,
									backgroundColor: <?php echo $lv_colarr[$i]; ?>,
									lineTension: 0.2,
									spanGaps: false
									},
								<?php	
									$i++;	
								}
								?>
								]
							}
							var options = { 
								maintainAspectRatio: false,
								animation: { animateRotate: true, animateScale: true }, 
								legend: { display: true },
								tooltips:{enabled:true},
								layout: { padding: 10 }
							};
							var Chart1 = new Chart(ctx, { type: "line", data: data, options: options });
						});

					</script>
					</div> <!-- /pedidos x mes -->
				</div>
			</div>
			</div>
	<?php }?>



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
				var lv_action = (gv_<?php echo $lv_sec; ?>_last_action=="99"?"<?php echo ($vew_actcod=='02'?'02':'03'); ?>":gv_<?php echo $lv_sec; ?>_last_action);
				tmssMessageProcessing( "<?php echo $lv_sec; ?>", lv_action, "<?php echo $lv_title; ?>", "<?php echo ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
			}
		}
		$("#<?php echo $lv_sec; ?> #repmovval").on("click", function(e){
			
			var lv_dat = [{name:'test',value:'test2'}];
			tmssLink('?prg=zcutp1_lgn&act=lgnrptmovval', [{target: '_new_section', post_data: lv_dat}] );
			e.preventDefault();
			e.stopPropagation();
		});
		
		$("#<?php echo $lv_sec; ?> #btnrpt003").on("click", function(e){
			
			var lv_dat = [{name:'test',value:'test2'}];
			tmssLink('?prg=zcutp1_lgn&act=btnrpt003', [{target: '_new_section', post_data: lv_dat}] );
			e.preventDefault();
			e.stopPropagation();
		});
    $("#<?php echo $lv_sec; ?> #matcstupd").on("click", function(e){
			
			var lv_dat = [{name:'test',value:'test2'}];
			tmssLink('?prg=zcutp1_lgn&act=matcstupd', [{target: '_new_section', post_data: lv_dat}] );
			e.preventDefault();
			e.stopPropagation();
		});
		
		// edit mode
    tmssFormEdit("<?php echo $lv_sec; ?>",<?php echo ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>
</section>
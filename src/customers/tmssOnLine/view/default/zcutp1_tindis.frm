<?php
	/* url del formulario */
  $lv_lnk = 'index.php?prg=zcutp1_tin';

	/* campos requeridos */
	$vew_input->RequiredFields( array('dshstrdte','dshenddte') );

	/* clave del documento */
	$lv_dockey = '';

	/* titulo */
	$lv_title = $vew_lang->dashboard;
	
	/* módulo y programa */
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'TP1';
	
	$vew_actcod = '02';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
	
	$lv_colarr = array( 
	'"rgba(255, 99, 132, 1)"', '"rgba(54, 162, 235, 1)"', '"rgba(255, 206, 86, 1)"', '"rgba(75, 192, 192, 1)"', '"rgba(153, 102, 255, 1)"', '"rgba(255, 159, 64, 1)"',
	'"rgba(99, 255, 132, 1)"', '"rgba(162, 54, 235, 1)"', '"rgba(206, 255, 86, 1)"', '"rgba(192, 75, 192, 1)"', '"rgba(102, 153, 255, 1)"', '"rgba(159, 255, 64, 1)"',
	'"rgba(132, 99, 255, 1)"', '"rgba(235, 162, 54, 1)"', '"rgba(86, 206, 255, 1)"', '"rgba(192, 192, 75, 1)"', '"rgba(255, 102, 153, 1)"', '"rgba(64, 159, 255, 1)"',
	'"rgba(132, 255, 99, 1)"', '"rgba(235, 54, 162, 1)"', '"rgba(86, 255, 206, 1)"', '"rgba(192, 75, 192, 1)"', '"rgba(255, 153, 102, 1)"', '"rgba(64, 255, 159, 1)"'
	);
	$lv_fldselyth = array('2018'=>'2018','2019'=>'2019','2020'=>'2020');
?>
<style>
  .fa-stack { font-size: 0.8em; }
  i { vertical-align: middle; }
</style>
<section id="<?php echo $lv_sec; ?>" data-title="<?php echo $lv_title; ?>" style="background-color: #f6f6f6 !important;">
	<link href="library\css\temasis\2.0.0\tmssStyleDashboard.css" rel="stylesheet">
  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><?php echo $vew_lang->reports; ?> <span class="caret"></span></a>
					<ul class="dropdown-menu">
						<?php if ( 1==1) { ?><li><a href="#" id="btnrpt001">Rep. Evoluciones</a></li><?php } ?>
					</ul> 
				</li>
			</ul>
				
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<a href="#" onclick="<?php echo $lv_sec; ?>_fnc({action: 'prn'});" class="btn btn-default navbar-btn" title="<?php echo $vew_lang->print; ?>"><span class="fas fa-print"></span></a>
				<a href="#" onclick="<?php echo $lv_sec; ?>_fnc({action: '99'});" class="btn btn-default navbar-btn"><span class="fas fa-sync"></span></a>
				<a href="#" onclick="tmssTabSecCls( $('#<?php echo $lv_sec; ?>') );" id="btncls" class="btn btn-default navbar-btn" title="<?php echo $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
	</nav>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?php echo $lv_sec; ?>_frm"> 
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">

		<script>
			function ChartSetPercentage( chart ) {
				var width = chart.chart.width,
						height = chart.chart.height,
						ctx = chart.chart.ctx,
						type = chart.config.type;
				if (type == 'doughnut') {
					var percent = Math.round((chart.config.data.datasets[0].data[0] * 100) /
												(chart.config.data.datasets[0].data[0] +
												chart.config.data.datasets[0].data[1]));
					var oldFill = ctx.fillStyle;
					var fontSize = ((height - chart.chartArea.top) / 100).toFixed(2);
					
					ctx.restore();
					ctx.font = fontSize + "em sans-serif";
					ctx.textBaseline = "middle"

					var text = percent + "%",
							textX = Math.round((width - ctx.measureText(text).width) / 2),
							textY = (height + chart.chartArea.top) / 2;
					
					ctx.fillStyle = chart.config.data.datasets[0].backgroundColor[0];
					ctx.fillText(text, textX, textY);
					ctx.fillStyle = oldFill;
					ctx.save();
				}
			}
		</script>
		<div class="container-fluid">
<!-- 
			<div class="dashboard-title-box">
				<div class="row">
					<div class="col-sm-8 col-md-8">
						<h1 class="dashboard-title"><span class="fas fa-tachometer-alt"></span><?php echo $vew_data['ttldsh']; ?></h1> 
					</div>
					<div class="col-sm-4 col-md-4">
						<div class="row">
							
						</div>

					</div>
				</div>
			</div>
			 -->
			<div class="row">
				
				<div class="form-group tmss-form-group col-sm-6">			

					<div class="col-xs-1">
						<label class="control-label">A&ntilde;o</label> 
					</div>
					<div class="col-xs-8">
						<?php gethtml('selyth', $lv_fldselyth, $vew_data['selyth'] ); ?>									
					</div>
					<div class="col-xs-3">
						<a href="#" id="btn_empflt" class="btn btn-default navbar-btn tmssAlwaysEnabled " style="margin-top: 0px" title="Borrar filtros"><span class="fa-stack fa-2x"><i class="fas fa-filter fa-stack-1x"></i><i class="fas fa-ban fa-stack-2x" style="color:Tomato"></i></span></a>
					</div>
				</div>
				<div class="form-group col-md-3">
				</div>

			</div>

			<div class="row">
				
 				</div>
			
				<!-- Cantidad de Pacientes Activos -->
				<div class="col-xs-12 col-sm-4 col-md-3">
					<div class="dashboard-box">
						<div class="dashboard-icon dashboard-icon-red"><span class="fas fa-heart fa-3x"></span></div>
						<div class="dashboard-info">
							<h4><strong>Pacientes</strong></h4>
							<h3><strong><?php echo $vew_data['patqty']; ?></strong></h3>
						</div>
					</div><br>
					<div class="dashboard-box">
						<div class="dashboard-icon dashboard-icon-green"><span class="fas fa-stethoscope fa-3x"></span></div>
						<div class="dashboard-info">
							<h4><strong><?php echo $vew_data['ttlevltxt']; ?></strong></h4>
							<h3><strong><?php echo $vew_data['evlqty']; ?></strong></h3>
						</div>
					</div>
				</div> <!-- /col-md-3 -->

				


				<!-- Infusiones (x año) -->
				<div class="col-xs-12 col-sm-8 col-md-9">
					<div class="dashboard-box">
						<div class="dashboard-box-title"><?php echo $vew_data['ttlbarra2']; ?><div class="pull-right"><a class="close-link"><i class="fas fa-table"></i></a></div></div>
						<div class="canvas-holder"><canvas id="barra2" width="100%" height="300"></canvas></div>
					</div>
					<script>
						var ctx = $("#barra2");
						var data = {
								labels: ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"],
								datasets: [
										{
											label: "Planificaciones",
											data:[<?php echo implode($vew_data['plnlst'],','); ?>],
											backgroundColor: ["rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)"],
											borderColor: ["rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)","rgba(23, 138, 199, 1)"],
											fill: false,lineTension: 0.3,spanGaps: false,
										},
										{
											label: "<?php echo $vew_data['ttlevltxt']; ?>",
											data:[<?php echo implode($vew_data['evllst'],','); ?>],
											backgroundColor: ["rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)"],
											borderColor: ["rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)","rgba(125, 182, 63, 1)"],
											fill: false,lineTension: 0.3,spanGaps: false,
										},
								]
						};
						var options = { 
							maintainAspectRatio: false,
							animation: { animateRotate: true, animateScale: true }, 
							legend: { display: true,  position: 'right' },
							title: { display: false, text: "", fontSize: 14, padding: 15 },
							layout: { padding: 10 }
						};
						tmssLoadScript("chart",function(){
							myLineChart = new Chart(ctx, { type: "bar", data: data, options: options });
						});
					</script>
				</div>

				<!-- Pacientes por Provincia -->
				<div class="col-xs-12 col-sm-12 col-md-12">
					<div class="dashboard-box">
						<div class="dashboard-box-title">Pacientes por Provincia<div class="pull-right"><a class="close-link"><i class="fas fa-table"></i></a></div></div>
						<div class="canvas-holder">
							<canvas id="barraH" height="500"></canvas>
						</div>
					</div>
					<script>
						<?php
							$lv_lbl = '';
							$lv_dat = '';
							$lv_col = '';
							$lv_qty = 0;

							foreach( $vew_data['lndreg'] as $key =>$lv_row) {
								$lv_lbl .= ($lv_lbl==''?'':', ').'"'.($key==''?'(vacio)':$key).'"';
								$lv_dat .= ($lv_dat==''?'':', ').$lv_row;
								$lv_col .= ($lv_col==''?'':', ').$lv_colarr[$lv_qty];
								$lv_qty++;
							}
						?>
						var lv_data_prov = {
								labels: [<?php echo $lv_lbl; ?>],
								datasets: [{
										label: "",
										backgroundColor: [<?php echo $lv_col; ?>],
										data: [<?php echo $lv_dat; ?>],
									}
								]
						};
						var lv_opt_prov = { 
								maintainAspectRatio: false,
								fill: true,
								legend: { display: false },
								title: { display: false, text: "Pacientes por Provincia", fontSize: 14, padding: 15 },
								layout: { padding: 10 }
								};
						var lo_chart_prov;
						tmssLoadScript("chart",function(){
							Chart.scaleService.updateScaleDefaults('linear', { ticks: { min: 0 } });
							lo_chart_prov = new Chart($("#barraH"), { type: "horizontalBar", data: lv_data_prov, options: lv_opt_prov });
						});
					</script>
				</div>		

			</div> <!-- /row -->
		</div> <!-- /container-fluid -->
	</form>
<?php 
	// if()
	// 	echo '<code>';
	// 	print_r($vew_data['data_sqlstm']);
	// 	echo '</code>';
 ?>

	<script>
		$("#<?php echo $lv_sec; ?> #btnrpt001").on("click",function(e){
			var lv_dat = [{name:'test',value:'test2'}];
			tmssLink('?prg=zcutp1_tin&act=tinrptevl', [{target: '_new_section', post_data: lv_dat}] );
			e.preventDefault();
			e.stopPropagation();
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
				var lv_action = (gv_<?php echo $lv_sec; ?>_last_action=="99"?"<?php echo ($vew_actcod=='02'?'dshraq':'03'); ?>":gv_<?php echo $lv_sec; ?>_last_action);
				tmssMessageProcessing( "<?php echo $lv_sec; ?>", lv_action, "<?php echo $lv_title; ?>", "<?php echo ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
			}
		}
		
		// edit mode
    tmssFormEdit("<?php echo $lv_sec; ?>",<?php echo ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>
  <script>
			$( "#btn_empflt" ).click(function() {
				$("#tchtxt").val("");
				$("#tchcod").val("");
				$("#selyth").val("2020");
			});		
	</script>
	<?php
	  if($vew_sec->usrcod =='GRUSSO'){
	  ?>
		  <script>
		  <?php
		  		foreach ($vew_data['data_sqlstm'] as  $lo_row) {
		  			if(!is_array($lo_row)){
		  				echo 'console.log("'.$lo_row.'");';
		  			}
		  		}
		  ?>
			</script>
	  
	  <?php
	  	foreach ($vew_data['data_sqlstm'] as  $lo_row) {
				echo "<code>";
				print_r($lo_row);
				echo "</code>";
			}
		}
  ?>
</section>
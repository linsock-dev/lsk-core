<?php
  // url del formulario
  $lv_lnk = '?prg=grldattsk&act=dsh';

  // campos requeridos
  $vew_input->RequiredFields( array() );

  // titulo
	$lv_title = $vew_lang->Contacts;

  // módulo y programa
  $lv_mdlcod = 'SYS';
  $lv_prgcod = 'TSK';

  // clave del documento
	$lv_dockey = '';

  // librería de estilos bootstrap
  include_once('_library.frm');

	$vew_data = array();
	$vew_tbl['new'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01'), 'acc'=>'tmssLink('.chr(39).'?prg=grldattsk&act=01'.chr(39).', [{target: '.chr(39).'_new_section'.chr(39).',target_id: '.chr(39).'#'.$lv_sec.chr(39).'}]);');	
  $vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['modR'] = array('per'=>false);	
	$vew_tbl['canc'] = array('per'=>false);	
	$vew_tbl['sveL'] = array('per'=>false);
	$vew_tbl['sveR'] = array('per'=>false);
	$vew_tbl['del'] = array('per'=>false);
	$vew_tbl['cpy'] = array('per'=>false);
	$vew_tbl['rfrsh'] = array('per'=>true,'pos'=>'D','ttl'=>$vew_lang->refresh,'id'=>'', 'icn'=>'fas fa-sync-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_refresh();');

	$lv_colarr = array( '"rgba(255, 99, 132, 1)"', '"rgba(54, 162, 235, 1)"', '"rgba(255, 206, 86, 1)"', '"rgba(75, 192, 192, 1)"', '"rgba(153, 102, 255, 1)"', '"rgba(255, 159, 64, 1)"',
	'"rgba(99, 255, 132, 1)"', '"rgba(162, 54, 235, 1)"', '"rgba(206, 255, 86, 1)"', '"rgba(192, 75, 192, 1)"', '"rgba(102, 153, 255, 1)"', '"rgba(159, 255, 64, 1)"',
	'"rgba(132, 99, 255, 1)"', '"rgba(235, 162, 54, 1)"', '"rgba(86, 206, 255, 1)"', '"rgba(192, 192, 75, 1)"', '"rgba(255, 102, 153, 1)"', '"rgba(64, 159, 255, 1)"',
	'"rgba(132, 255, 99, 1)"', '"rgba(235, 54, 162, 1)"', '"rgba(86, 255, 206, 1)"', '"rgba(192, 75, 192, 1)"', '"rgba(255, 153, 102, 1)"', '"rgba(64, 255, 159, 1)"'
	);
	
	$lv_colstr = '';
	foreach($lv_colarr as $lv_row){ $lv_colstr .= ($lv_colstr==''?'':',').$lv_row; }
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
	<style> 
		.dashboard-card{ border-radius: 10px; padding: 10px; margin-bottom: 10px; }
		.dashboard-card p:first-child { font-size:16px; }
		.dashboard-card p:last-child { font-size:32px; font-weight:bold; text-align: center;}
	</style>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('vewflt','hidden',''); ?>

    <div class="container-fluid">
			<div class="row">
			
				<div class="col-sm-3">
					<div class="dashboard-card" style="background-color: var(--tmss-purple); text: var(--tmss-purple-text);">
						<p><?= $vew_lang->active; ?></p><p id="qtyact"></p>
					</div>
				</div>
				<div class="col-sm-3">
					<div class="dashboard-card" style="background-color: var(--tmss-blue); text: var(--tmss-blue-text);">
						<p><?= $vew_lang->success; ?> <small>(<?= $vew_lang->today; ?>)</small></p><p id="qtyown"></p>
					</div>
				</div>
				<div class="col-sm-3">
					<div class="dashboard-card" style="background-color: var(--tmss-orange); text: var(--tmss-orange-text);">
						<p><?= $vew_lang->errors; ?> <small>(<?= $vew_lang->today; ?>)</small></p><p id="qtynon"></p>
					</div>
				</div>
				<div class="col-sm-3">
					<div class="dashboard-card" style="background-color: var(--tmss-green); text: var(--tmss-green-text);">
						<p><?= $vew_lang->efective; ?> <small>(&uacute;ltimos 7 d&iacute;as)</small></p><p id="qtycls"></p>
					</div>
				</div>
				
			</div><!--/row-->
			<div class="row">

				<div class="col-md-7 col-xs-12">

					<div class="card">
						<div class="card-header"><div class="card-title"><?= $vew_lang->tasks; ?></div></div>
						<div class="card-body tmss-card-body-edit">
							<table class="table" id="tbltsk">
								<thead>
                  <th><?= $vew_lang->code; ?></th>
                  <th><?= $vew_lang->title; ?></th>
                  <th><?= $vew_lang->frequency; ?></th>
                  <th width="90"><?= $vew_lang->status; ?></th>
								</thead>
								<tbody></tbody>
							</table>
						</div>
					</div>

					
				</div>
				<div class="col-md-5 col-xs-12">


					<div class="row">
						<div class="col-sm-6">							
							<div class="card">
								<div class="card-header"><div class="card-title">Tipo</div></div>
								<div class="card-body">
									<canvas id="grptyp"><i class="far fa-gear fa-spin"></i></canvas>
								</div>
							</div>
							<div class="card">
								<div class="card-header"><div class="card-title">Estado</div></div>
								<div class="card-body">
									<canvas id="grpsts"><i class="far fa-gear fa-spin"></i></canvas>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="card">
								<div class="card-header"><div class="card-title">Prioridad</div></div>
								<div class="card-body">
									<canvas id="grpprt" height="250"><i class="far fa-gear fa-spin"></i></canvas>
								</div>
							</div>
						</div>
					</div><!-- /row -->

				</div>
			</div> <!--/row -->
		</div> <!-- /container-fluid -->
  </form>
	<script>
		var <?= $lv_sec; ?>_grptyp;
		var <?= $lv_sec; ?>_grpsts;
		var <?= $lv_sec; ?>_grpprt;
    
    function <?= $lv_sec; ?>_GridRefresh(){
      <?= $lv_sec; ?>_refresh();
    }
		
		function <?= $lv_sec; ?>_refresh(){
			
			var lv_spin = "<i class='far fa-gear fa-spin'></i>";
			$("#<?= $lv_sec; ?> #qtyact").html( lv_spin );
			$("#<?= $lv_sec; ?> #qtyown").html( lv_spin );
			$("#<?= $lv_sec; ?> #qtynon").html( lv_spin );
			$("#<?= $lv_sec; ?> #qtycls").html( lv_spin );
			if(<?= $lv_sec; ?>_grptyp!=null){ <?= $lv_sec; ?>_grptyp.destroy(); }
			if(<?= $lv_sec; ?>_grpsts!=null){ <?= $lv_sec; ?>_grpsts.destroy(); }
			if(<?= $lv_sec; ?>_grpprt!=null){ <?= $lv_sec; ?>_grpprt.destroy(); }
			$("#<?= $lv_sec; ?> #grptyp").html( lv_spin );
			$("#<?= $lv_sec; ?> #grpsts").html( lv_spin );
			$("#<?= $lv_sec; ?> #grpprt").html( lv_spin );
			$("#<?= $lv_sec; ?> #avgcls").html( lv_spin );
			$("#<?= $lv_sec; ?> #tbltsk tbody").empty().append("<tr><td colspan=10>"+lv_spin+"</td></tr>");
			
			// GRAFICOS
			tmssLoadScript("chart",function(){ 		
				// por TIPO
				tmssCallProcessNoBackdrop("?prg=grldattsk&act=dsh",[{name:"typ",value:"type"}],function(data){
					var lv_lbl = [];
					var lv_qty = [];
					for(var i=0; i<data.length; i++){
						lv_lbl.push( data[i].tsktxt );
						lv_qty.push( data[i].qty );
					}				
					var ctx = $("#<?= $lv_sec; ?> #grptyp");
					var data={
						labels: lv_lbl,
						datasets:[{ data: lv_qty, backgroundColor: [<?= $lv_colstr; ?>] }]
					}
					var options = { 
						indexAxis: "y",
						responsive: true,
						plugins: { 
							title: { display: false },
							legend: { display: false }
						}
					};
					<?= $lv_sec; ?>_grptyp = new Chart(ctx, { type: "bar", data: data, options: options });
				});

				// por STATUS
				tmssCallProcessNoBackdrop("?prg=grldattsk&act=dsh",[{name:"typ",value:"status"}],function(data){
					var lv_lbl = [];
					var lv_qty = [];
					for(var i=0; i<data.length; i++){
						lv_lbl.push( data[i].tsktxt );
						lv_qty.push( data[i].qty );
					}				
					var ctx = $("#<?= $lv_sec; ?> #grpsts");
					var data={
						labels: lv_lbl,
						datasets:[{ data: lv_qty, backgroundColor: [<?= $lv_colstr; ?>] }]
					}
					var options = { 
						indexAxis: "y",
						responsive: true,
						plugins: {
							title: { display: false },
							legend: { display: false }
						}
						
					};
					<?= $lv_sec; ?>_grpsts = new Chart(ctx, { type: "bar", data: data, options: options });
				});

				// por PRIORIDAD
				tmssCallProcessNoBackdrop("?prg=grldattsk&act=dsh",[{name:"typ",value:"priority"}],function(data){
					var lv_lbl = [];
					var lv_qty = [];
					for(var i=0; i<data.length; i++){
						lv_lbl.push( data[i].tsktxt );
						lv_qty.push( data[i].qty );
					}				
					var ctx = $("#<?= $lv_sec; ?> #grpprt");
					var data={
						labels: lv_lbl,
						datasets:[{ data: lv_qty, backgroundColor: [<?= $lv_colstr; ?>] }]
					}
					var options = { 
						responsive: true,
						plugins: {
							title: { display: false },
							legend: { display: true, position: "bottom" }
						}
						
					};
					<?= $lv_sec; ?>_grpprt = new Chart(ctx, { type: "doughnut", data: data, options: options });
				});
			});

			// INDICADORES
			
			// ACTIVOS - PROPIOS - NO ASIGNADOS
			tmssCallProcessNoBackdrop("?prg=grldattsk&act=dsh",[{name:"typ",value:"active"}],function(data){
				var lv_act = 0;
				var lv_own = 0;
				var lv_non = 0;
				for(var i=0; i<data.length; i++){
					lv_act += data[i].qty;
					if( data[i].usrcod==null || data[i].usrcod=="" ){ lv_non+=data[i].qty; }
					if( data[i].usrcod=="<?= $vew_sec->usrcod; ?>" ){ lv_own+=data[i].qty; }
				}
				$("#<?= $lv_sec; ?> #qtyact").html( lv_act );
				$("#<?= $lv_sec; ?> #qtyown").html( lv_own );
				$("#<?= $lv_sec; ?> #qtynon").html( lv_non );
			});
			
			// GRILLAS
			
			// LISTA
			tmssCallProcessNoBackdrop("?prg=grldattsk&act=dsh",[{name:"typ",value:"task_list"}],function(data){
				$("#<?= $lv_sec; ?> #tbltsk tbody").empty();
				for(var i=0; i<data.length; i++){
					$("#<?= $lv_sec; ?> #tbltsk tbody").append("<tr><td>"+data[i].tskcodext+"</td><td><a href='#' name='tsklnk' data-tskcod='"+data[i].tskcod+"'>"+data[i].tsktxt+"</a></td><td></td><td style='padding-top:3px;padding-bottom:3px;'>"+(data[i].docsts=="A"?"<i class='fas fa-play text-success' style='margin-top:9px;'></i>":"<i class='fas fa-pause text-warning' style='margin-top:9px;'></i>")+"&nbsp;<a href='#' class='card-icon'><i class='far fa-exclamation-triangle'></i></a></td></tr>");
				}
				
				<?php if( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02') || $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'03') ){ ?>
				$("#<?= $lv_sec; ?> #tbltsk tbody a[name=tsklnk]").on("click",function(e){e.preventDefault
					tmssLink("?prg=grldattsk&act=03&prm_tskcod="+$(this).data("tskcod"), [{target: "_new_section",target_id: "#<?= $lv_sec; ?>"}]);
				});
				<?php } ?>
			});
      
		}

		$("#<?= $lv_sec; ?> #btnnew").on("click",function(e){ e.preventDefault();
			tmssLink("?prg=grldattsk&act=01", [{target: "_new_section", target_id: "#<?= $lv_sec; ?>"}]);
		});
		
		$(function(){ <?= $lv_sec; ?>_refresh(); });
	</script>
</section>
<?php
	// url del formulario
  $lv_lnk = '?prg=sysappdsh&act=dsh';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->dashboard;
	
	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'DSH';
	
	$vew_actcod = '02';
	
	// librería de estilos bootstrap
	include_once('_library.frm');

	$vew_data = array();
	$vew_tbl['new'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01'), 'acc'=>'tmssLink('.chr(39).'?prg=crmcnt&act=01'.chr(39).', [{target: '.chr(39).'_new_section'.chr(39).',target_id: '.chr(39).'#'.$lv_sec.chr(39).'}]);');	
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
		
	$lv_curdte = new DateTime();
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>" style="background-color: #f6f6f6 !important;">
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
						<p><?= $vew_lang->tickets; ?></p><p id="qtytkt" style="cursor:pointer;"></p>
					</div>
				</div>
				<div class="col-sm-3">
					<div class="dashboard-card" style="background-color: var(--tmss-blue); text: var(--tmss-blue-text);">
						<p><?= $vew_lang->invoices; ?></p><p id="qtyinv"></p>
					</div>
				</div>
				<div class="col-sm-3">
					<div class="dashboard-card" style="background-color: var(--tmss-orange); text: var(--tmss-orange-text);">
						<p><?= $vew_lang->subscriptions; ?></p><p id="qtysub" style="cursor:pointer;"></p>
					</div>
				</div>
				<div class="col-sm-3">
					<div class="dashboard-card" style="background-color: var(--tmss-green); text: var(--tmss-green-text);">
						<p><?= $vew_lang->changelog; ?> <small>(&uacute;ltimos 30 d&iacute;as)</small></p><p id="qtylog" style="cursor:pointer;"></p>
					</div>
				</div>
				
			</div><!--/row-->
			
			<table class="table hidden" id="tbltkt">
				<thead><tr><th>#</th><th><?= $vew_lang->title; ?></th><th><?= $vew_lang->date; ?></th></tr></thead>
				<tbody></tbody>
			</table>
			<table class="table hidden" id="tbllog">
				<thead><tr><th>#</th><th><?= $vew_lang->title; ?></th><th><?= $vew_lang->date; ?></th></tr></thead>
				<tbody></tbody>
			</table>				

			<div class="row">
				<div class="col-xs-12 col-sm-6">
				
					<div class="row">
						<div class="col-sm-6">
							<div class="card">
								<div class="card-header"><div class="card-title">Horarios</div></div>
								<div class="card-body"><canvas id="grptme"><i class="far fa-gear fa-spin"></i></canvas></div>
							</div>
							<div class="card"> 
								<div class="card-header"><div class="card-title">Dispositivo</div></div>
								<div class="card-body"><canvas id="grpdev"><i class="far fa-gear fa-spin"></i></canvas></div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="card"> 
								<div class="card-header"><div class="card-title">Navegador</div></div>
								<div class="card-body"><canvas id="grpnav"><i class="far fa-gear fa-spin"></i></canvas></div>
							</div>
							<div class="card"> 
								<div class="card-header"><div class="card-title">Sistema Operativo</div></div>
								<div class="card-body"><canvas id="grposs"><i class="far fa-gear fa-spin"></i></canvas></div>
							</div>
						</div>
					</div>
					
				</div>
				<div class="col-xs-12 col-sm-6">
				
					<div class="card">
						<div class="card-header"><div class="card-title"><?= $vew_lang->invoices; ?>
							<span class="tmss-card-icon" style="color: red; font-weight: bold;"></span>
						</div></div>
						<div class="card-body">
							<table class="table" id="tblinv">
								<thead><tr><th><?= $vew_lang->date; ?></th><th><?= $vew_lang->number; ?></th><th><?= $vew_lang->duedate; ?></th><th><?= $vew_lang->amount; ?></th><th></th></tr></thead>
								<tbody></tbody>
							</table>
						</div>
					</div>
					<div class="card">
						<div class="card-header" style="display: flex; justify-content: space-between"><div class="card-title">Mis Datos</div> <span id="usrid"></span></div>
						<div class="card-body" id="tbldat"></div>
					</div>
					
				</div>
			</div><!-- /row -->
		</div> <!-- /container-fluid -->
	</form>
	<script>
		var <?= $lv_sec; ?>_grpdev;
		var <?= $lv_sec; ?>_grpnav;
		var <?= $lv_sec; ?>_grptme;
		var <?= $lv_sec; ?>_grposs;
	
		function <?= $lv_sec; ?>_refresh(){
			var lv_spin = "<i class='far fa-gear fa-spin'></i>";
			$("#<?= $lv_sec; ?> #qtytkt").html( lv_spin );
			$("#<?= $lv_sec; ?> #qtyinv").html( lv_spin );
			$("#<?= $lv_sec; ?> #qtysub").html( lv_spin );
			$("#<?= $lv_sec; ?> #qtylog").html( lv_spin );
			if(<?= $lv_sec; ?>_grpdev!=null){ <?= $lv_sec; ?>_grpdev.destroy(); }
			if(<?= $lv_sec; ?>_grpnav!=null){ <?= $lv_sec; ?>_grpnav.destroy(); }
			if(<?= $lv_sec; ?>_grptme!=null){ <?= $lv_sec; ?>_grptme.destroy(); }
			if(<?= $lv_sec; ?>_grposs!=null){ <?= $lv_sec; ?>_grposs.destroy(); }
			$("#<?= $lv_sec; ?> #grpdev").html( lv_spin );
			$("#<?= $lv_sec; ?> #grpnav").html( lv_spin );
			$("#<?= $lv_sec; ?> #grptme").html( lv_spin );
			$("#<?= $lv_sec; ?> #grposs").html( lv_spin );
			
			$("#<?= $lv_sec; ?> #tbldat").html( lv_spin );
			$("#<?= $lv_sec; ?> #tbltkt tbody").empty();
			$("#<?= $lv_sec; ?> #tbllog tbody").empty();
			$("#<?= $lv_sec; ?> #tblinv tbody").empty().append("<tr><td colspan=10>"+lv_spin+"</td></tr>");
			$("#<?= $lv_sec; ?> #tblmsg tbody").empty().append("<tr><td colspan=10>"+lv_spin+"</td></tr>");
			
			tmssLoadScript("chart",function(){ 			
			
				// por DISPOSITIVO
				tmssCallProcessNoBackdrop("?prg=sysappdsh&act=dsh",[{name:"typ",value:"stddev"}],function(data){
					var lv_lbl = [];
					var lv_qty = [];
					for(var i=0; i<data.length; i++){
						lv_lbl.push( data[i].devnme );
						lv_qty.push( data[i].devqty );
					}				
					var ctx = $("#<?= $lv_sec; ?> #grpdev");
					var data={
						labels: lv_lbl,
						datasets:[{ data: lv_qty, backgroundColor: [<?= $lv_colstr; ?>] }]
						
					}
					var options = { 
						indexAxis: "y",
						responsive: true,
						plugins: {
							title: { display: false },
							legend: { display: true, position: "bottom" },
						},
						layout: { padding: 10 }
					};
					<?= $lv_sec; ?>_grpdev = new Chart(ctx, { type: "doughnut", data: data, options: options });
				});
				
				// por HORARIO
				tmssCallProcessNoBackdrop("?prg=sysappdsh&act=dsh",[{name:"typ",value:"stdtme"}],function(data){
					var lv_lbl = [];
					var lv_qty = [];
					for(var i=0; i<data.length; i++){
						lv_lbl.push( data[i].acctme );
						lv_qty.push( data[i].accqty );
					}				
					var ctx = $("#<?= $lv_sec; ?> #grptme");
					var data={
						labels: lv_lbl,
						datasets:[{ data: lv_qty, backgroundColor: [<?= $lv_colstr; ?>] }]
						
					}
					var options = { 
						//indexAxis: "y",
						responsive: true,
						plugins: {
							title: { display: false },
							legend: { display: false}//, position: "bottom" },
						},
						layout: { padding: 5 }
					};
					<?= $lv_sec; ?>_grpdev = new Chart(ctx, { type: "bar", data: data, options: options });
				});

				// por SISTEMA OPERATIVO
				tmssCallProcessNoBackdrop("?prg=sysappdsh&act=dsh",[{name:"typ",value:"stdoss"}],function(data){
					var lv_lbl = [];
					var lv_qty = [];
					for(var i=0; i<data.length; i++){
						lv_lbl.push( data[i].ossnme );
						lv_qty.push( data[i].ossqty );
					}				
					var ctx = $("#<?= $lv_sec; ?> #grposs");
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
						},
						layout: { padding: 10 }
					};
					<?= $lv_sec; ?>_grposs = new Chart(ctx, { type: "bar", data: data, options: options });
				});

				// por NAVEGADOR
				tmssCallProcessNoBackdrop("?prg=sysappdsh&act=dsh",[{name:"typ",value:"stdnav"}],function(data){
					var lv_lbl = [];
					var lv_qty = [];
					for(var i=0; i<data.length; i++){
						lv_lbl.push( data[i].navnme );
						lv_qty.push( data[i].navqty );
					}				
					var ctx = $("#<?= $lv_sec; ?> #grpnav");
					var data={
						labels: lv_lbl,
						datasets:[{ data: lv_qty, backgroundColor: [<?= $lv_colstr; ?>] }]
					}
					var options = { 
						indexAxis: "y",
						responsive: true,
						plugins: {
							title: { display: false}, //text: "por Navegador" },
							legend: { display: true, position: "bottom" },
						},
						layout: { padding: 10 }
					};
					<?= $lv_sec; ?>_grpnav = new Chart(ctx, { type: "pie", data: data, options: options });
				});
			});
			
			// DATOS
			tmssCallProcessNoBackdrop("?prg=sysappdsh&act=dsh",[{name:"typ",value:"cusdat"}],function(data){
				if(data.data.length>0){
					$("#<?= $lv_sec; ?> #tbldat").html(
						"<span><b>"+data.data[0]["name"]+"</b></span><br>"+
						"<span>"+data.data[0]["address_street"]+" "+data.data[0]["address_number"]+" "+data.data[0]["address_floor"]+" "+data.data[0]["address_unit"]+"</span><br>"+
						"<span>"+data.data[0]["region_name"]+"</span><br>"+
						"<span>"+data.data[0]["country_name"]+"</span>"
					);
          $("#<?= $lv_sec; ?> #usrid").append("#"+data.data[0]["id"]);
				}
			});

			// FACTURAS
			tmssCallProcessNoBackdrop("?prg=sysappdsh&act=dsh",[{name:"typ",value:"invlst"}],function(data){
				// Create our number formatter.
				const lo_formatter = new Intl.NumberFormat("es-AR", { style: "currency", currency: "ARS"});

				$("#<?= $lv_sec; ?> #tblinv tbody").empty();
				for(var i=0; i<data.data.length; i++){
					$("#<?= $lv_sec; ?> #tblinv tbody").append("<tr><td>"+moment(data.data[i]["datestr"].date).format("DD/MM/YYYY")+"</td><td>"+data.data[i]["code"]+"</td><td>"+data.data[i]["duedatestr"]+"</td><td class='text-right'>"+lo_formatter.format(data.data[i]["totalamount"])+"</td><td></td></tr>");
				}
				$("#<?= $lv_sec; ?> #qtyinv").empty();
				$("#<?= $lv_sec; ?> #qtyinv").append( data.data.length );
			});
			
			// TICKETS
			tmssCallProcessNoBackdrop("?prg=sysappdsh&act=dsh",[{name:"typ",value:"tktlst"}],function(data){
				$("#<?= $lv_sec; ?> #qtytkt").html( data.data.length );
				$("#<?= $lv_sec; ?> #tbltkt tbody").empty();
				for(var i=0; i<data.data.length && i<99; i++){
          $("#<?= $lv_sec; ?> #tbltkt tbody").append("<tr><td>"+data.data[i].id+"<br>"+(data.data[i].motive_name=="error"?"FIX":"ADD")+"</td><td>"+data.data[i].description+"<br>"+data.data[i].request.toLowerCase()+"</td><td>"+moment(data.data[i].date.date).format("DD/MM/YYYY")+"</td></tr>");
				}
			});

			// SUSCRIPCIONES
			tmssCallProcessNoBackdrop("?prg=sysappdsh&act=dsh",[{name:"typ",value:"sublst"}],function(data){
				var lv_qty = data.length;
				$("#<?= $lv_sec; ?> #qtysub").html( lv_qty );
				/*
				$("#<?= $lv_sec; ?> #tblcls tbody").empty();
				for(var i=0; i<data.length && i<6; i++){
					$("#<?= $lv_sec; ?> #tblcls tbody").append("<tr data-cntcod='"+data[i].crmcntcod+"'><td>"+data[i].crmcntcod+"</td><td>"+data[i].crmcnttxt.toLowerCase()+"</td><td>"+data[i].crmcntsrctxt+"</td><td>"+moment(data[i].ctedte.date).format("DD.MM")+"</td></tr>");
				}
				
				$("#<?= $lv_sec; ?> #tblcls tbody tr").on("click",function(e){e.preventDefault
					tmssLink("?prg=crmcnt&act=03&prm_crmcntcod="+$(this).data("cntcod"), [{target: "_new_section",target_id: "#<?= $lv_sec; ?>"}]);
				});
				*/
			});
			
			// LOG DE CAMBIOS
			tmssCallProcessNoBackdrop("?prg=sysappdsh&act=dsh",[{name:"typ",value:"loglst"}],function(data){
				$("#<?= $lv_sec; ?> #qtylog").html( data.data.length );
				$("#<?= $lv_sec; ?> #tbllog tbody").empty();
				for(var i=0; i<data.data.length && i<99; i++){
					$("#<?= $lv_sec; ?> #tbllog tbody").append("<tr><td>"+data.data[i].id+"<br>"+(data.data[i].motive_name=="error"?"FIX":"ADD")+"</td><td>"+data.data[i].description+"<br>"+data.data[i].request.toLowerCase()+"</td><td>"+moment(data.data[i].last_update.date).format("DD/MM/YYYY")+"</td></tr>");
				}
			});
			
		}
		
		$("#<?= $lv_sec; ?> #qtysub").on("click",function(e){ e.preventDefault();
			tmssLink("?prg=sysfncsub&act=18", [{target: "_new_section", post_data: []}] );
		});
		
		// tickets
		$("#<?= $lv_sec; ?> #qtytkt").on("click", function(e){ e.preventDefault();
			BootstrapDialog.show({
				size: BootstrapDialog.SIZE_WIDE,
				title: "<?= $vew_lang->tickets; ?>",
				closable: true,
				draggable: true,
				message: $("#<?= $lv_sec; ?> #tbltkt").clone().removeClass("hidden")
			});
		});
		
		// log de cambios
		$("#<?= $lv_sec; ?> #qtylog").on("click", function(e){ e.preventDefault();
			BootstrapDialog.show({
				size: BootstrapDialog.SIZE_WIDE,
				title: "<?= $vew_lang->changelog; ?>",
				closable: true,
				draggable: true,
				message: $("#<?= $lv_sec; ?> #tbllog").clone().removeClass("hidden")
			});
		});
		
		
		$(function(){ <?= $lv_sec; ?>_refresh(); });
	</script>
</section>
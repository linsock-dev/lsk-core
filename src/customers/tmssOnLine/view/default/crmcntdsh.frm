<?php
  // url del formulario
  $lv_lnk = '?prg=crmcnt';

  // campos requeridos
  $vew_input->RequiredFields( array() );

  // titulo
	$lv_title = $vew_lang->Contacts;

  // módulo y programa
  $lv_mdlcod = 'CRM';
  $lv_prgcod = 'CNT';

  // clave del documento
	$lv_dockey = '';

  // librería de estilos bootstrap
  include_once('_library.frm');
	
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
	
	$lv_can03 = $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'03');
	
	$vew_tbl['flt'] = array('pos'=>'R', 'per'=>true, 'ttl'=>'', 'id'=>'btnflt', 'icn'=>'far fa-filter', 'css'=>'btn navbar-btn tmssAlwaysEnabled tmss-navbar-btn', 'acc'=>'');
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
    <?= gethtml('vewfltdef','hidden',($vew_data->vewfldfltdef??'')); ?>

    <div class="container-fluid">
			<div class="row">

				<div id="fltttl"></div>
			
				<div class="col-sm-3">
					<div class="dashboard-card" style="background-color: var(--tmss-purple); text: var(--tmss-purple-text);">
						<p><?= $vew_lang->active; ?></p><p id="qtyact"></p>
					</div>
				</div>
				<div class="col-sm-3">
					<div class="dashboard-card" style="background-color: var(--tmss-blue); text: var(--tmss-blue-text);">
						<p><?= $vew_lang->own; ?></p><p id="qtyown"></p>
					</div>
				</div>
				<div class="col-sm-3">
					<div class="dashboard-card" style="background-color: var(--tmss-orange); text: var(--tmss-orange-text);">
						<p><?= $vew_lang->unassigned; ?></p><p id="qtynon"></p>
					</div>
				</div>
				<div class="col-sm-3">
					<div class="dashboard-card" style="background-color: var(--tmss-green); text: var(--tmss-green-text);">
						<p><?= $vew_lang->closed; ?> <small>(&uacute;ltimos 7 d&iacute;as)</small></p><p id="qtycls"></p>
					</div>
				</div>
				
			</div><!--/row-->
			<div class="row">

				<div class="col-md-6 col-xs-12">
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
							<div class="dashboard-card" style="background-color: var(--tmss-gray); text: var(--tmss-gray-text); margin-top: 10px;">
								<p>Tiempo Medio Resoluci&oacute;n<br><small>&uacute;ltimos 30 d&iacute;as</small></p>
								<p id="avgcls"></p>
							</div>
						</div>
					</div><!-- /row -->

					<?php if($lv_can03){ ?>
          <div class="card">
						<div class="card-header"><div class="card-title"><?= $vew_lang->activities; ?></div></div>
						<div class="card-body tmss-card-body-edit" style="overflow-y:scroll; max-height:400px;">
							<table class="table table-hover table-sm" id="tbllog">
								<thead><tr>
                  <th><?= $vew_lang->id; ?></th>
                  <th><?= $vew_lang->date; ?></th>
                  <th><?= $vew_lang->user; ?></th>
                  <th><?= $vew_lang->comments; ?></th>
                </tr></thead>
								<tbody></tbody>
							</table>
						</div>
					</div>
					<?php } ?>
					
				</div>
				<div class="col-md-6 col-xs-12">

					<div class="card">
						<div class="card-header"><div class="card-title"><?= $vew_lang->new; ?></div></div>
						<div class="card-body tmss-card-body-edit">
							<table class="table table-hover table-sm" id="tblopn">
								<thead><tr><th>ID</th><th><?= $vew_lang->title; ?></th><th><?= $vew_lang->requester; ?></th><th><?= $vew_lang->date; ?></th></tr></thead>
								<tbody></tbody>
							</table>
						</div>
					</div>

					<div class="card">
						<div class="card-header"><div class="card-title"><?= $vew_lang->closed; ?></div></div>
						<div class="card-body tmss-card-body-edit">
							<table class="table table-hover table-sm" id="tblcls">
								<thead><tr><th>ID</th><th><?= $vew_lang->title; ?></th><th><?= $vew_lang->requester; ?></th><th><?= $vew_lang->created; ?></th></tr></thead>
								<tbody></tbody>
							</table>
						</div>
					</div>

				</div>
			</div> <!--/row -->
		</div> <!-- /container-fluid -->
  </form>
	<script>
		var <?= $lv_sec; ?>_grptyp;
		var <?= $lv_sec; ?>_grpsts;
		var <?= $lv_sec; ?>_grpprt;
		
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
			$("#<?= $lv_sec; ?> #tblcls tbody").empty().append("<tr><td colspan=10>"+lv_spin+"</td></tr>");
			$("#<?= $lv_sec; ?> #tblopn tbody").empty().append("<tr><td colspan=10>"+lv_spin+"</td></tr>");
			
			var lv_usrflt = (tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["fltstr"]==""?"":tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["fltstr"]);
			
			// GRAFICOS
			tmssLoadScript("chart",function(){ 		
				// por TIPO
				tmssCallProcessNoBackdrop("?prg=crmcnt&act=dsh",[{name:"typ",value:"type"},{name:"vewfldflt",value:lv_usrflt}],function(data){
					var lv_lbl = [];
					var lv_qty = [];
					for(var i=0; i<data.length; i++){
						lv_lbl.push( data[i].crmcnttyptxt );
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
				tmssCallProcessNoBackdrop("?prg=crmcnt&act=dsh",[{name:"typ",value:"status"},{name:"vewfldflt",value:lv_usrflt}],function(data){
					var lv_lbl = [];
					var lv_qty = [];
					for(var i=0; i<data.length; i++){
						lv_lbl.push( data[i].crmcntststxt );
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
				tmssCallProcessNoBackdrop("?prg=crmcnt&act=dsh",[{name:"typ",value:"priority"},{name:"vewfldflt",value:lv_usrflt}],function(data){
					var lv_lbl = [];
					var lv_qty = [];
					for(var i=0; i<data.length; i++){
						lv_lbl.push( data[i].crmcntprttxt );
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
			tmssCallProcessNoBackdrop("?prg=crmcnt&act=dsh",[{name:"typ",value:"active"},{name:"vewfldflt",value:lv_usrflt}],function(data){
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
			
			// CERRADOS
			tmssCallProcessNoBackdrop("?prg=crmcnt&act=dsh",[{name:"typ",value:"last_closed"},{name:"vewfldflt",value:lv_usrflt}],function(data){
				$("#<?= $lv_sec; ?> #qtycls").html( data.length );
				$("#<?= $lv_sec; ?> #tblcls tbody").empty();
				for(var i=0; i<data.length && i<6; i++){
					$("#<?= $lv_sec; ?> #tblcls tbody").append("<tr data-cntcod='"+data[i].crmcntcod+"'><td>"+data[i].crmcntcod+"</td><td>"+data[i].crmcnttxt.toLowerCase()+"</td><td>"+data[i].crmcntsrctxt+"</td><td>"+moment(data[i].ctedte.date).format("DD/MM/YYYY")+"</td></tr>");
				}
				
				<?php if($lv_can03){ ?>
				$("#<?= $lv_sec; ?> #tblcls tbody tr").on("click",function(e){e.preventDefault
					tmssLink("?prg=crmcnt&act=03&prm_crmcntcod="+$(this).data("cntcod"), [{target: "_new_section",target_id: "#<?= $lv_sec; ?>"}]);
				});
				<?php } ?>
			});
			
			// RECIENTES
			tmssCallProcessNoBackdrop("?prg=crmcnt&act=dsh",[{name:"typ",value:"recents"},{name:"vewfldflt",value:lv_usrflt}],function(data){
				$("#<?= $lv_sec; ?> #tblopn tbody").empty();
				for(var i=0; i<data.length; i++){
					$("#<?= $lv_sec; ?> #tblopn tbody").append("<tr data-cntcod='"+data[i].crmcntcod+"'><td>"+data[i].crmcntcod+"</td><td>"+data[i].crmcnttxt.toLowerCase()+"</td><td>"+data[i].crmcntsrctxt+"</td><td>"+moment(data[i].ctedte.date).format("DD/MM/YYYY")+"</td></tr>");
				}
				
				<?php if($lv_can03){ ?>
				$("#<?= $lv_sec; ?> #tblopn tbody tr").on("click",function(e){e.preventDefault
					tmssLink("?prg=crmcnt&act=03&prm_crmcntcod="+$(this).data("cntcod"), [{target: "_new_section",target_id: "#<?= $lv_sec; ?>"}]);
				});
				<?php } ?>
			});
      
      // COMENTARIOS
			<?php if($lv_can03){ ?>
      tmssCallProcessNoBackdrop("?prg=crmcnt&act=dsh",[{name:"typ",value:"comments"},{name:"vewfldflt",value:lv_usrflt}],function(data){
        $("#<?= $lv_sec; ?> #tbllog tbody").empty();
        for(var i=0; i<data.length; i++){
          $("#<?= $lv_sec; ?> #tbllog tbody").append("<tr data-cntcod='"+data[i].chgdocsrccod	+"'><td>"+data[i].chgdocsrccod+"</td><td>"+moment(data[i].ctedte.date).format("DD/MM/YYYY HH:mm")+"</td><td>"+data[i].cteusr.toLowerCase()+"</td><td>"+data[i].chgdocatrnew+"</td></tr>");
        }

				$("#<?= $lv_sec; ?> #tbllog tbody tr").on("click",function(e){e.preventDefault
					tmssLink("?prg=crmcnt&act=03&prm_crmcntcod="+$(this).data("cntcod"), [{target: "_new_section",target_id: "#<?= $lv_sec; ?>"}]);
				});
      });
			<?php } ?>
      
			// TIEMPO PROMEDIO de CIERRE
			tmssCallProcessNoBackdrop("?prg=crmcnt&act=dsh",[{name:"typ",value:"average_closed"},{name:"vewfldflt",value:lv_usrflt}],function(data){
				var lv_avg = (data.length==0?0:data[0].avgcls);
				var lv_avgstr = "";
				if( lv_avg>=1440){
					lv_day = parseInt(lv_avg / 1440);
					lv_avgstr += lv_day + "d";
					lv_avg = lv_avg - (lv_day * 1440);
				}
				if( lv_avg>=60 ){
					lv_hour = parseInt(lv_avg / 60);
					lv_avgstr += " "+lv_hour + "h";
					lv_avg = lv_avg - (lv_hour * 60);
				}
				if( lv_avg>0 ){
					lv_avgstr += " "+lv_avg + "m";
				}
				$("#<?= $lv_sec; ?> #avgcls").html( (lv_avgstr==""?"---":lv_avgstr) );
			});
			
		}
	</script>
	<script>
		// FILTRO PERSONALIZADO
		var lv_<?= $lv_sec; ?>_grdfltcod = "<?= $vew_data->vewfltcod ?>";
		var gv_<?= $lv_sec; ?>_flt=[{'fldttl': '<?= $vew_lang->responsible; ?>' ,'fldcod': 'c.usrcod', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''}];

		// filtro - boton
		$("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
			tmssFilterShowDialog( gv_<?= $lv_sec; ?>_flt, <?= $lv_sec; ?>_fltcrm, "CRM_CNT_DSH", lv_<?= $lv_sec; ?>_grdfltcod, "<?= $lv_sec; ?>" );
		});
		
		//Filtros
		function <?= $lv_sec; ?>_fltcrm(lp_flt) {
			var lv_fltint;
			if( $("#<?= $lv_sec; ?> #btnflt .badge").length==0 ){
				$("<span class='badge'></span>").appendTo( $("#<?= $lv_sec; ?> #btnflt") );
			}
			if(lp_flt!=null){
				lv_fltint = tmssFilterParseToInternal(lp_flt);
				gv_<?= $lv_sec; ?>_flt = lp_flt;
				$("#<?= $lv_sec; ?> #btnflt .badge").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
			} else {
				lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
			}
			
			if(lv_fltint["fltstr"]!=$("#<?= $lv_sec; ?> #vewflt").prop("value")){
				$("#<?= $lv_sec; ?> #vewflt").prop("value",JSON.stringify(lv_fltint["fltstr"]));
				$("#<?= $lv_sec; ?> #fltttl").html( (gv_<?= $lv_sec; ?>_flt[0].fldvalstr==""?"":"<blockquote>Estadisticas para <b>"+gv_<?= $lv_sec; ?>_flt[0].fldvalstr.toUpperCase()+"</b></blockquote>") );
				<?= $lv_sec; ?>_refresh();
			}
		}

		$(function(){ 
			gv_<?= $lv_sec; ?>_flt=tmssFilterParseToExternal( gv_<?= $lv_sec; ?>_flt , $("#<?= $lv_sec; ?> #vewfltdef").val() );
			<?= $lv_sec; ?>_fltcrm( gv_<?= $lv_sec; ?>_flt );
			lv_fltint = tmssFilterParseToInternal( gv_<?= $lv_sec; ?>_flt );
			if( lv_fltint["fltqty"]==0 ){ <?= $lv_sec; ?>_refresh(); }
		});
	</script>	
</section>
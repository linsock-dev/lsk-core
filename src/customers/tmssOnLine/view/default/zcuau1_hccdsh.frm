<?php
	/* url del formulario */
  $lv_lnk = '?prg=zcuau1_hcc';

	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = '';

	/* titulo */
	$lv_title = $vew_lang->form;

	/* módulo y programa */
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'AU2';
	$vew_actcod = '02';

	/* librería de estilos bootstrap */
	include_once('_library.frm');

	$lv_pattbl = ($vew_data->prscod!=''?true:false);
	$lv_prstbl = ($vew_sec->hasPermission('ZCU','AU2','03')?true:false);

?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<link href="library\css\temasis\2.0.0\tmssStyleDashboard.css" rel="stylesheet">
	<style>
		.sort_table thead tr th:hover {background-color: #f1f1f1; cursor: pointer; }
		.dashboard-box2 {background: #ffffff !important;  width: 100% !important; border-radius: 5px !important; margin-bottom: 15px !important; border: #c1c1c1 1px solid; }
		.dashboard-label2 {overflow: hidden; text-overflow: ellipsis; display: -webkit-box; line-height: 16px; max-height: 30px; min-height: 30px; text-align: center; }
		.dashboard-number2 {font-size: 30px; top: -15px; position: relative; text-align: center; font-weight: bold; }
		.dashboard-icon-blue { background-color: #286090; }
	</style>

  <nav class="navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
        <?php if ($vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'01')) { ?><a href="#" id="btnnew" data-prscod="<?= $vew_data->prscod; ?>" data-spccod="<?= $vew_data->spccod; ?>" class="btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmss-desk-btn" title="<?= $vew_lang->new; ?>"><i class="fas fa-file"></i><span class="d-none d-sm-inline"> <?= $vew_lang->new; ?></span></a><?php } ?>
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<!--Filtrar-->
				<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'03') ) { ?><a href="#" id="btnflt001" class="btn navbar-btn tmssAlwaysEnabled tmss-navbar-btn <?= ($vew_actcod != '02') ? 'tmssHiddeOnEdit':''; ?>" title="<?= $vew_lang->filter; ?>"><span class="fas fa-filter"></span><span id="fltcnt" class="badge"></span></a><?php } ?>
				<!--<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: 'prn'});" class="btn btn-default navbar-btn" title="<?= $vew_lang->print; ?>"><span class="fas fa-print"></span></a>-->
				<!--Dropdown-->
				<div class="btn-group dropdown">
					<a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><span class="fas fa-ellipsis-v"></span></a>
					<form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
						<!--Actualizar-->
						<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '08'});" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
						<!--Ayuda-->
						<?php include('sysappprghlpbtn.frm'); ?>
					</form>
				</div>
				<!--Cerrar-->
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
	</nav>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">

		<div class="container-fluid">
			<div class="row">
				<div class="col-sm-5">

					<img class="img-responsive" src="https://temasis.com.ar/lalrean-org/library/images/logos/logolalrean.png">
					<br>

					<div class="row">
						<?php if ($lv_pattbl) { ?>
						<!-- Cantidad de Pacientes -->
						<div class="col-sm-6">
							<div class="dashboard-box2">
								<div class="dashboard-icon dashboard-icon-red"><span class="fas fa-heart fa-3x"></span></div>
								<div class="dashboard-info">
									<label class="dashboard-label2">Pacientes Tratados</label><br>
									<div class="dashboard-number2" id="patqty">&nbsp;</div>
								</div>
							</div>
						</div>
						<?php } ?>
						<?php if ($lv_prstbl)  { ?>
						<!-- Cantidad TOTAL de Pacientes -->
						<div class="col-sm-6">
							<div class="dashboard-box2">
								<div class="dashboard-icon dashboard-icon-red"><span class="fas fa-users fa-3x"></span></div>
								<div class="dashboard-info">
									<label class="dashboard-label2">Pacientes Totales</label><br>
									<div class="dashboard-number2" id="patqtytot">&nbsp;</div>
								</div>
							</div>
						</div>
						<!-- Profesionales -->
						<div class="col-sm-6">
							<div class="dashboard-box2">
								<div class="dashboard-icon dashboard-icon-green"><span class="fas fa-stethoscope fa-3x"></span></div>
								<div class="dashboard-info">
									<label class="dashboard-label2">Profesionales</label><br>
									<div class="dashboard-number2" id="prsqty">&nbsp;</div>
								</div>
							</div>
						</div>

						<div class="col-sm-6">
							<div class="dashboard-box2">
								<div class="dashboard-icon dashboard-icon-blue"><span class="fas fa-download fa-3x"></span></div>
								<div class="dashboard-info">
									<label class="dashboard-label">Descargas</label><br>
									<a href="#" class="btn btn-default btn-block" id="btndwn001">General</a><br>
								</div>
							</div>
						</div>
						<?php } ?>
					</div>

				</div>
				<div class="col-sm-7">

					<div class="text-center"><h1 style="margin: 10px !important; padding: 10px !important">Hepatocarcinoma</h1></div>

					<?php if ($lv_pattbl) { ?>
					<div class="col-xs-12 col-sm-12 col-md-12">
						<input type="hidden" id="vewfldord001" value="">
						<table class="table table-condensed table-bordered table-striped table-hover sort_table" id="divtblpat">
							<thead>
								<tr>
									<th data-sortid="patcod">Paciente <span class="fas" style="float: right;"></span></th>
									<th data-sortid="pattxt">Iniciales <span class="fas" style="float: right;"></span></th>
									<th data-sortid="maxupddte">Ult.Seg. <span class="fas" style="float: right;"></span></th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
					<?php } ?>

					<?php if ($lv_prstbl)  { ?>
					<div class="col-xs-12 col-sm-12 col-md-12">
						<table class="table table-condensed table-bordered table-striped table-hover" id="divtblprs">
							<thead>
								<tr>
									<th>Profesional</th>
									<th>Pacientes</th>
									<th>Ult.Seg.</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
					<?php } ?>

			</div>
		</div>
	</form>

	<script>
		var gv_<?= $lv_sec; ?>_flt001 = [
									{'fldttl': 'Paciente', 'fldcod': 'a.patcod', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': 'Iniciales', 'fldcod': 'a.pattxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									<?php if($lv_prstbl) { ?>{'fldttl': 'Profesional', 'fldcod': 'pr.prstxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},<?php } ?>
									{'fldttl': 'Ult.Seg.', 'fldcod': 'maxupddte', 'fldtyp': 'DATE', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''}
									];

		$("#<?= $lv_sec; ?> #btnflt001").on("click",function(e){ e.preventDefault();
			tmssFilterShowDialog(gv_<?= $lv_sec; ?>_flt001,<?= $lv_sec; ?>_GridRefresh001);
		});

		function <?= $lv_sec; ?>_GridRefresh001(lp_flt) {
			var lv_fltint;
			if(lp_flt!=null){
				lv_fltint = tmssFilterParseToInternal(lp_flt);
				gv_<?= $lv_sec; ?>_flt001 = lp_flt;
				$("#<?= $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
			} else {
				lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt001);
			}
			if(lv_fltint["maxrec"]==""){lv_fltint["maxrec"]="100";}
			var lv_pstdat = { vewmaxrec: lv_fltint["maxrec"], vewfldord: $("#<?= $lv_sec; ?> #vewfldord001").prop("value"), vewfldflt: lv_fltint["fltstr"] };
			tmssCallProcess("?prg=zcuau1_hcc&act=28", lv_pstdat, function(data){

				<?php if($lv_pattbl){ ?>
				// tabla de pacientes
				var lv_key;
				var lv_buffer = "";
				for(var i=0; i<Object.keys(data.data.patlst).length; i++) {
					lv_key = Object.keys(data.data.patlst)[i];
					lv_buffer += "<tr name='patrow' data-spccod='<?= $vew_data->spccod; ?>' data-prscod='"+data.data.patlst[lv_key]["prscod"]+"' data-patcod='"+data.data.patlst[lv_key]["patcod"]+"'>"+
								"<td>"+data.data.patlst[lv_key]["patcod"]+"</td>"+
								"<td>"+data.data.patlst[lv_key]["pattxt"]+"</td>"+
								"<td style='white-space: nowrap;'>"+ moment(data.data.patlst[lv_key]['maxupddte'].date).format("DD.MM.YYYY")+"</td>"+
								"</tr>";
				}
				$("#<?= $lv_sec; ?> #divtblpat tbody").html( lv_buffer );
				$("#<?= $lv_sec; ?> #patqty").html( Object.keys(data.data.patlst).length );
				$("#<?= $lv_sec; ?> #divtblpat tr[name='patrow']").on("click", function(e){ e.preventDefault();
					var lv_pst_dat = [{name:"spccod",value: $(this).data("spccod")},
														{name:"prscod",value: $(this).data("prscod")},
														{name:"patcod",value: $(this).data("patcod")}
														];
					tmssLink("index.php?prg=zcuau1_hcc&act=02&prm_patcod="+$(this).data("patcod")+"&prm_prscod="+$(this).data("prscod")+"&prm_spccod="+$(this).data("spccod"), [{target: "_new_section",post_data: lv_pst_dat}] );
				});
				<?php } ?>

				<?php if($lv_prstbl){ ?>
				// tabla de prestadores
				var lv_qtytot = 0;
				var lv_key;
				var lv_buffer = "";
				for(var i=0; i<Object.keys(data.data.prslst).length; i++) {
					lv_key = Object.keys(data.data.prslst)[i];
					lv_buffer += "<tr name='prsrow' data-spccod='<?= $vew_data->spccod; ?>' data-prscod='"+data.data.prslst[lv_key]["prscod"]+"'>"+
								"<td>"+data.data.prslst[lv_key]["prstxt"]+"</td>"+
								"<td>"+data.data.prslst[lv_key]["qty"]+"</td>"+
								"<td style='white-space: nowrap;'>"+ moment(data.data.prslst[lv_key]['maxupddte'].date).format("DD.MM.YYYY")+"</td>"+
								"</tr>";
					lv_qtytot += Number(data.data.prslst[lv_key]["qty"]);
				}
				$("#<?= $lv_sec; ?> #divtblprs tbody").html( lv_buffer );
				$("#<?= $lv_sec; ?> #prsqty").html( Object.keys(data.data.prslst).length );
				$("#<?= $lv_sec; ?> #patqtytot").html( lv_qtytot );
				$("#<?= $lv_sec; ?> #divtblprs tr[name='prsrow']").on("click", function(e){
					e.preventDefault();
					var lv_pstdat = { prscod: $(this).data("prscod"), spccod: $(this).data("spccod") };
					tmssCallProcess("?prg=zcuau1_hcc&act=18", lv_pstdat, function(data) {
						BootstrapDialog.show({
							title: "Lista de Pacientes",
							message: $("<div>"+data+"</div>"),
							type: BootstrapDialog.TYPE_INFO,
							onshow: function(dialog) {
								var lv_frm = $(dialog.$modalContent);
								$(lv_frm).find("#patlst tbody tr").on("click", function(e) {
									var lv_pst_dat= [	{name:"patcod",value: $(this).data("patcod")},
																		{name:"prscod",value: $(this).data("prscod")},
																		{name:"spccod",value: $(this).data("spccod")}
																	];
									tmssLink("?prg=zcuau1_hcc&act=02&prm_patcod="+$(this).data("patcod"), [{target: "_new_section",post_data: lv_pst_dat}] );
									e.stopPropagation();
									e.preventDefault();
									dialog.close();
								});
							}
						});
					});
				});
				<?php } ?>

			});
		}

		$("#divtblpat thead tr th").on("click", function(e){ e.preventDefault();
			$("#divtblpat thead tr th").find("span").removeClass("fa-sort-up").removeClass("fa-sort-down");
			if( $(this).data("sort")=="" || $(this).data("sort")==undefined ) {
				$(this).data("sort","up");
				$(this).find("span:first").addClass("fa-sort-up");
			} else if( $(this).data("sort")=="up" ) {
				$(this).data("sort","down");
				$(this).find("span:first").addClass("fa-sort-down");
			} else if( $(this).data("sort")=="down" ) {
				$(this).data("sort","up");
				$(this).find("span:first").addClass("fa-sort-up");
			}
			$("#<?= $lv_sec; ?> #vewfldord001").prop("value", $(this).data("sortid") + ($(this).data("sort")=="down"?" DESC":"") );
			<?= $lv_sec; ?>_GridRefresh001();
		});

		$(function(){
			<?= $lv_sec; ?>_GridRefresh001();
		});
	</script>

	<script>
		$("#<?= $lv_sec; ?> #btnnew").on("click", function(e){ e.preventDefault();
			var lv_pst_dat = [{name:"spccod",value: $(this).data("spccod")},
												{name:"prscod",value: $(this).data("prscod")}
												];
			tmssLink("?prg=zcuau1_hcc&act=01&prm_prscod="+$(this).data("prscod")+"&prm_spccod="+$(this).data("spccod"), [{target: "_new_section",post_data: lv_pst_dat}] );
		});

		function <?= $lv_sec; ?>_GridRefresh(){
			<?= $lv_sec; ?>_GridRefresh001();
		}

		$("#<?= $lv_sec; ?> #btndwn001").on("click", function(e){ e.preventDefault();
			BootstrapDialog.confirm({
				title: "Descargar",
				message:"Desea descargar la planilla de INFORMACI&Oacute;N GENERAL ?",
				type: BootstrapDialog.TYPE_PRIMARY,
				callback: function(result){
					if(result){	window.open("?prg=zcuau1_hcc&act=r1"); }
				}
			});
		});
	</script>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $('#<?= $lv_sec; ?>_frm'), '<?= $lv_lnk; ?>', function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, '<?= $lv_title; ?>', '<b><?= $lv_dockey; ?></b>' ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=='04') {
					tmssTabSecCls( $('#<?= $lv_sec; ?>') );
				} else {
					$('#<?= $lv_sec; ?>').replaceWith( data );
				}
			}
    });

		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {
				gv_<?= $lv_sec; ?>_last_action = lp_prm['action'];
				var lv_action = (gv_<?= $lv_sec; ?>_last_action=='99'?'<?= ($vew_actcod=='02'?'02':'03'); ?>':gv_<?= $lv_sec; ?>_last_action);
				tmssMessageProcessing( '<?= $lv_sec; ?>', lv_action, '<?= $lv_title; ?>', '<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>' );
			}
		}

		// edit mode
    tmssFormEdit('<?= $lv_sec; ?>',<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>
</section>

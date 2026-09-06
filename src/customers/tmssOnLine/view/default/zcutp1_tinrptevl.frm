<?php
	/* url del formulario */
  $lv_lnk = 'index.php?prg=zcutp1_ttr';

	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = '';

	/* titulo */
	$lv_title = $vew_lang->form;

	/* m�dulo y programa */
	$lv_mdlcod = '';
	$lv_prgcod = '';
	$vew_actcod = '09';

	/* librer�a de estilos bootstrap */
	include_once('_library.frm');

	/* filtro de vista pre establecido */
	$lv_vewfldflt='';
	if ( isset($vew_prm['vewfldflt']) ) {
		$lv_vewfldflt = $vew_prm['vewfldflt'];
		unset($vew_prm['vewfldflt']);
	}
?>
<section id="<?php echo $lv_sec; ?>" data-model="<?php echo $vew_model; ?>" data-title="Reporte de liquidaciones">
	<link href="library\css\temasis\2.0.0\tmssStyleDashboard.css" rel="stylesheet">

  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<a class="navbar-brand" href="#">Reporte de evoluciones</a>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<a href="#" onclick="<?php echo $lv_sec; ?>_fnc({action: '11'});" class="btn btn-default navbar-btn"><span class="fas fa-print"></span></a>
				<a href="#" onclick="<?php echo $lv_sec; ?>_fnc({action: '10'});" class="btn btn-default navbar-btn"><span class="fas fa-download"></span></a>
				<a href="#" onclick="<?php echo $lv_sec; ?>_fnc({action: '09'});" class="btn btn-default navbar-btn"><span class="fas fa-sync"></span></a>
				<a href="#" id="btnflt" class="btn btn-default navbar-btn"><span class="fas fa-filter"></span><span id="fltcnt" class="badge"></span></a>
				<a href="#" onclick="tmssTabSecCls( $('#<?php echo $lv_sec; ?>') );" id="btncls" class="btn btn-default navbar-btn" title="<?php echo $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
	</nav>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?php echo $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<input type="hidden" id="vewfldord" value="">
		<textarea style="display: none;" id="vewfldflt"></textarea>
    <textarea style="display: none;" id="vewfldfltpre"><?php echo $lv_vewfldflt; ?></textarea>

		<div class="container-fluid">
			<table class="table table-condensed table-bordered table-striped table-hover" id="tblevl">
				<thead>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
	</form>
	<script>
		function <?php echo $lv_sec; ?>_export(lp_table){
			$(lp_table).table2excel({
					exclude: ".noExl",
					name: "Excel Document Name",
					filename: 'evllst' + new Date().toISOString().replace(/[\-\:\.]/g, ""),
					fileext: ".xls",
					exclude_img: true,
					exclude_links: true,
					exclude_inputs: true
				});
		}

		var gv_<?php echo $lv_sec; ?>_flt = [	{ 'fldttl': 'ID'          , 'fldcod': 'e.evlcod'				,'fldtyp': 'TEXT', 'flttyp': 'LIKE' , 'fldvalstr' : '', 'fldvalend' : '' },
																					{ 'fldttl': 'Fecha'				, 'fldcod': 'e.evldte'				,'fldtyp': 'DATE', 'flttyp': 'LIKE', 'fldvalstr' : '' , 'fldvalend' : '' },
																					{ 'fldttl': 'Paciente'		, 'fldcod': 'e.patcod'				,'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '' , 'fldvalend' : '' },
																					{ 'fldttl': 'Nombre'			, 'fldcod': 'e.pattxt'				,'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '' , 'fldvalend' : '' },
																					{ 'fldttl': 'Provincia' 	, 'fldcod': 'lr.lndregtxt'		,'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '' , 'fldvalend' : '' },
																					{ 'fldttl': 'Patologia'		, 'fldcod': 'pdc.hltdisclstxt','fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '' , 'fldvalend' : '' },
																					{ 'fldttl': 'Prestador'		, 'fldcod': 'e.prscod'				,'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '' , 'fldvalend' : '' },
																					{ 'fldttl': 'Nombre'			, 'fldcod': 'e.prstxt'				,'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '' , 'fldvalend' : '' },
																					{ 'fldttl': 'Especialidad', 'fldcod': 'e.spctxt'				,'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '' , 'fldvalend' : '' },
																					{ 'fldttl': 'Med. Cab'		, 'fldcod': 'm.patprsrlstxt'	,'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '' , 'fldvalend' : '' },
																					{ 'fldttl': 'Coordinador.', 'fldcod': 'c.patprsrlstxt'	,'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '' , 'fldvalend' : '' },
																					{ 'fldttl': 'Motivo'			, 'fldcod': 'evlcncmtv'				,'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '' , 'fldvalend' : '' }
																				];

		$("#<?php echo $lv_sec; ?> #btnflt").on("click",function(e){
			tmssFilterShowDialog(gv_<?php echo $lv_sec; ?>_flt,<?php echo $lv_sec; ?>_GridRefresh);
			e.preventDefault();
		});

		function <?php echo $lv_sec; ?>_GridRefresh(lp_flt) {
			var lv_fltint;
			if(lp_flt!=null){
				lv_fltint = tmssFilterParseToInternal(lp_flt);
				gv_<?php echo $lv_sec; ?>_flt = lp_flt;
				$("#<?php echo $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
			} else {
				lv_fltint = tmssFilterParseToInternal(gv_<?php echo $lv_sec; ?>_flt);
			}
			if(lv_fltint["maxrec"]==""){lv_fltint["maxrec"]="100";}
			tmssCallProcess("?prg=zcutp1_tin&act=tinrptevldat", {vewmaxrec: lv_fltint["maxrec"], vewfldflt: lv_fltint["fltstr"]}, function(data){
				var lv_buffer_h="<tr valign='top' name='lnkstu'>";
				lv_buffer_h += 	"<th>ID</th>"+
												"<th>Fecha</th>"+
												"<th>Paciente</th>"+
												"<th>Nombre</th>"+
												"<th>Provincia</th>"+
												"<th>Patologia</th>"+
												"<th>Prestador</th>"+
												"<th>Nombre</th>"+
												"<th>Especialidad</th>"+
												"<th>Med. Cabecera</</th>"+
												"<th>Coordinador</th>"+
												"<th>Infundido</th>"+
												"<th>Motivo</th>"
				lv_buffer_h += "</tr>";

				var lv_buffer="";
		    for (var i = 0; i < data.datlst.length; i++) {

		    	lv_buffer +="<tr valign='top' name='lnkstu'>";
					lv_buffer += 	"<td>" +data.datlst[i].evlcod + "</td>";
					lv_buffer += 	"<td style='white-space: nowrap;'>" +data.datlst[i].evldtecnv + "</td>";
					lv_buffer += 	"<td>" + data.datlst[i].patcod + "</td>";
					lv_buffer += 	"<td>" + data.datlst[i].pattxt + "</td>";
					lv_buffer += 	"<td>" + (data.datlst[i].lndregtxt==null ? "" :data.datlst[i].lndregtxt ) + "</td>";
					lv_buffer += 	"<td>" + (data.datlst[i].hltdisclstxt==null ? "" : data.datlst[i].hltdisclstxt) + "</td>";
					lv_buffer += 	"<td>" + data.datlst[i].prscod + "</td>";
					lv_buffer += 	"<td>" + data.datlst[i].prstxt + "</td>";
					lv_buffer += 	"<td>" + data.datlst[i].spctxt + "</td>";
					lv_buffer += 	"<td>" + (data.datlst[i].rlstxt==null ? "" : data.datlst[i].rlstxt) + "</td>";
					lv_buffer += 	"<td>" + (data.datlst[i].rlstxt==null ? "" : data.datlst[i].rlstxtcoo) + "</td>";
					lv_buffer += 	"<td>" + (data.datlst[i].docsts=="P" ? "NO" : "SI" ) + "</td>";
					lv_buffer += 	"<td>" + data.datlst[i].evlcncmtvtxt + "</td>";
					//lv_buffer += 	"<td>" + (data.datlst[i].evlcncmtv=="SV" ? "SIN VIALES" : data.datlst[i].evlcncmtv=="EN" ?"ENFERMEDAD":data.datlst[i].evlcncmtv=="ND" ?"NO DISPONIBLE":data.datlst[i].evlcncmtv=="OT" ?"OTROS":"" ) + "</td>";
				  lv_buffer += "</tr>";
		    }
				$("#<?php echo $lv_sec; ?> #tblevl thead").html(lv_buffer_h);
				$("#<?php echo $lv_sec; ?> #tblevl tbody").html(lv_buffer);
			});
		}

		// form submit
    function <?php echo $lv_sec; ?>_fnc( lp_prm ) {
			//debugger;
			if (lp_prm['action']=='prn') {
				window.print();
			} else if (lp_prm['action']== '09') {

				<?php echo $lv_sec; ?>_GridRefresh();
				toastr.success("Actualizado...");
			}
			if(lp_prm['action'] =='10'){
					tmssLoadScript("table2excel",function(){
						<?php echo $lv_sec; ?>_export("#<?php echo $lv_sec; ?> #tblevl");
					});
				}
			if(lp_prm['action']  =='11'){
					window.open("?prg=zcutp1_tin&act=hltpatevlprn&prm_lstevlcod=" + $("#vewlstevl").text());
			}
		}

		<?php echo $lv_sec; ?>_GridRefresh();
  </script>
</section>

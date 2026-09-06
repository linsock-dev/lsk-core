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
<section id="<?php echo $lv_sec; ?>" data-title="Reporte de Factura&iacute;on">
	<link href="library\css\temasis\2.0.0\tmssStyleDashboard.css" rel="stylesheet">

  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<a class="navbar-brand" href="#">Reporte de Facturaci&oacute;n</a>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
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

		<div class="container-fluid" id="rpt">
			<div id="<?php echo $lv_sec;?>_tbl"></div>
			

		</div>
	</form>
	<script>

		function <?php echo $lv_sec; ?>_export(lp_table){
			$(lp_table).table2excel({
					exclude: ".noExl",
					name: "Excel Document Name",
					filename: 'RepCoord' + new Date().toISOString().replace(/[\-\:\.]/g, ""),
					fileext: ".xls",
					exclude_img: true,
					exclude_links: true,
					exclude_inputs: true
				});
		}

		var gv_<?php echo $lv_sec; ?>_flt = [
                  { 'fldttl': 'ID', 												'fldcod': 'd.stkmovdoccod', 		'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
                  { 'fldttl': 'Numero', 										'fldcod': 'd.stkmovdoccodext', 	'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},										
                  { 'fldttl': 'Fecha Movimiento', 					'fldcod': 'stkmovdocdtecnv', 		'fldtyp': 'DATE', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
      						{ 'fldttl': 'Fecha Confirmaci&oacute;n',	'fldcod': 'stkmovdoccnfdte', 		'fldtyp': 'DATE', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
      						{ 'fldttl': 'Entregado',									'fldcod': 'stkmovdoccnftyp', 		'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
                  { 'fldttl': 'Tipo', 											'fldcod': 'dc.sysdocclstxt', 		'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},										
                  { 'fldttl': 'Clase', 											'fldcod': 'mdc.sysdocclstxt', 	'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
                  { 'fldttl': 'Material', 									'fldcod': 'm.matcod', 					'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},										
                  { 'fldttl': 'Descripcion', 								'fldcod': 'dm.mattxt', 					'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
                  { 'fldttl': 'Nro Lote', 									'fldcod': 'mb.matbchcodext', 		'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
                  { 'fldttl': 'Vencimiento', 								'fldcod': 'matbchduedtecnv', 		'fldtyp': 'DATE', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
                  { 'fldttl': 'Nro de serie', 							'fldcod': 'ms.matsercodext', 		'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
                  { 'fldttl': 'Desde', 											'fldcod': 'srcobjtyptxt', 			'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
                  { 'fldttl': 'Origen', 										'fldcod': 'srcobjtxt', 					'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
                  { 'fldttl': 'Contacto', 									'fldcod': 'srccnttxt', 					'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},										
                  { 'fldttl': 'Hasta', 											'fldcod': 'dstobjtyptxt', 			'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
                  { 'fldttl': 'Destino', 										'fldcod': 'dstobjtxt', 					'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
                  { 'fldttl': 'Contacto', 									'fldcod': 'dstcnttxt', 					'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
                  { 'fldttl': 'Cantidad', 									'fldcod': 'dm.matqty', 					'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''}
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
			// "isvew" le indica al controlador que es un llamado desde la vista
			tmssCallProcess("?prg=zcutp1_lgn&act=btnrpt003dat", {vewmaxrec: lv_fltint["maxrec"], vewfldflt: lv_fltint["fltstr"], isvew:"X"}, function(data){
				var lv_buffer="";
				lv_buffer =  "" +
				"<table class='table table-condensed table-bordered table-striped table-hover' id ='<?php echo $lv_sec; ?>_tblmovval'>"+
				"<thead>"+
				"<tr><th>ID</th><th>Numero</th><th>Fecha Movimiento</th><th>Fecha Confirmaci&oacute;n</th><th>Entregado</th><th>Tipo</th><th>Clase</th><th>Material</th><th>Codigo</th><th>Descripcion</th><th>Lote</th><th>Vencimiento</th><th>Nro. Serie</th>"+
				"<th>UM</th><th>Desde</th><th>Origen</th><th>Contacto</th><th>Hasta</th><th>Destino</th><th>Contacto</th><th>Codigo externo</th><th>Costo</th><th>Costo Actual</th><th>Cantidad</th></th><th>Referencia</th></th><th>Precio venta</th></th><th>Precio lista</th>"+
				"</tr>" +
				"</thead>"+
				"</tbody>";
				for (var i= 0;i<data.data.length;i++) {
					var lv_dat = data.data[i];
          
					lv_buffer+= "<tr name='rlstblrow'>" +
					"<td>" +lv_dat.stkmovdoccod + "</td>" +
					"<td>" +lv_dat.stkmovdoccodext + "</td>" +
					"<td style='white-space: nowrap;'>" + lv_dat.stkmovdocdtecnv+"</td>" +
          "<td style='white-space: nowrap;'>" + lv_dat.stkmovdoccnfdte+"</td>" +
          "<td>" + lv_dat.stkmovdoccnftyp + "</td>" +
					"<td>" + lv_dat.sysdocclstxt + "</td>" +
					"<td>" + lv_dat.matdocclstxt +"</td>" +
					"<td>" + lv_dat.matcod +"</td>" +
					"<td>" + lv_dat.matcodext +"</td>" +
					"<td>" + lv_dat.mattxt +"</td>" +
					/*"<td>" + parseFloat((lv_dat.matcstlst==null ? "" : lv_dat.matcstlst)).toFixed(2).replace('.',',') +"</td>" +*/
					"<td style='white-space: nowrap;'>" + lv_dat.matbchcodext + "</td>" +
					"<td style='white-space: nowrap;'>" + (lv_dat.matbchduedtecnv==null?"":lv_dat.matbchduedtecnv) + "</td>" +
					"<td>" + lv_dat.matsercodext + "</td>" +
					"<td>" + lv_dat.matuntcod + "</td>" +
					"<td>" + lv_dat.srcobjtyptxt + "</td>" +
					"<td>" + lv_dat.srcobjtxt + "</td>" +
					"<td>" + (lv_dat.srccnttxt==null ? "" : lv_dat.srccnttxt) + "</td>" +
					"<td>" + lv_dat.dstobjtyptxt + "</td>" +
					"<td>" + lv_dat.dstobjtxt + "</td>" +
					"<td>" + (lv_dat.dstcnttxt==null ? "" : lv_dat.dstcnttxt) + "</td>" +
					"<td>" + (lv_dat.dstcntcodext==null ? "" : lv_dat.dstcntcodext) + "</td>" +
					"<td>" + (lv_dat.matcstlst==null ? "" : lv_dat.matcstlst).toFixed(2).replace('.',',') +"</td>" +
					"<td>" + (lv_dat.matcst==null ? "" : lv_dat.matcst).toFixed(2).replace('.',',') +"</td>" +
					"<td>" + parseFloat(lv_dat.matqty).toFixed(2).replace('.',',') + "</td>" +
					"<td>" + lv_dat.slsordcod + "</td>" +
					"<td>" + parseFloat(lv_dat.prcord).toFixed(2).replace('.',',') + "</td>" +
					"<td>" + parseFloat(lv_dat.prclst).toFixed(2).replace('.',',') + "</td>" +
					"</tr>";
				}
				lv_buffer +=  "</tbody></table>";
				lv_tbl= $("#<?php echo $lv_sec; ?>_tbl");
				//lv_tbl.replaceWith(lv_buffer);
				lv_tbl.html(lv_buffer);
			});
		}
		
		// form submit
    function <?php echo $lv_sec; ?>_fnc( lp_prm ) {
			if (lp_prm['action']=='prn') {
				window.print();
			} else if (lp_prm['action']== '09') {
				<?php echo $lv_sec; ?>_GridRefresh();
				toastr.success("Actualizado...");
			}
			if(lp_prm['action'] =='10'){
					tmssLoadScript("table2excel",function(){
						<?php echo $lv_sec; ?>_export("#<?php echo $lv_sec; ?>_tblmovval");
					});
				}
		}
		
		<?php echo $lv_sec; ?>_GridRefresh();
  </script>
</section>
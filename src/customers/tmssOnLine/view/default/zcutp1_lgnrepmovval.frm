<?php
	/* url del formulario */
  $lv_lnk = 'index.php?prg=zcutp1_lgn';

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
<section id="<?php echo $lv_sec; ?>" data-model="<?php echo $vew_model; ?>" data-title="Movimiento de materiales Valorizado">
	<link href="library\css\temasis\2.0.0\tmssStyleDashboard.css" rel="stylesheet">

  <nav class="navbar navbar-default tmss-navbar">
    <div class="container-fluid">
			<a class="navbar-brand" href="#">Reporte: Movimiento de materiales Valorizado</a>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<a href="#" onclick="<?php echo $lv_sec; ?>_fnc({action: '10'});" class="btn btn-default navbar-btn"><span class="fas fa-download"></span></a>
				<a href="#" onclick="<?php echo $lv_sec; ?>_filter();" class="btn btn-default navbar-btn"><span class="fas fa-filter"></span></a>
				<a href="#" onclick="<?php echo $lv_sec; ?>_fnc({action: '09'});" class="btn btn-default navbar-btn"><span class="fas fa-sync"></span></a>
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
			<div id="<?php echo $lv_sec;?>_tbl"></div>
		</div>

	</form>
	<form method="POST" id="zcuau1expfrm" name="zcuau1expfrm">
		<input type="hidden" id="spccod" name="spccod" value="">
		<input type="hidden" id="rptstrdte" name="rptstrdte" value="">
		<input type="hidden" id="rptenddte" name="rptenddte" value="">
	</form>
	<script>
		$("#exp").on("click",function(e){ Exportar("table2excel"); });
		
		function <?php echo $lv_sec; ?>_export(lp_table){
			$("#"+ lp_table).table2excel({
					exclude: ".noExl",
					name: "Excel Document Name",
					filename: 'MovMatVal' + new Date().toISOString().replace(/[\-\:\.]/g, ""),
					fileext: ".xls",
					exclude_img: true,
					exclude_links: true,
					exclude_inputs: true
				});
		}

		function <?php echo $lv_sec; ?>_sysdocgrd_refresh(lv_flt) {
			if(lv_flt !=null)
				flt = tmssFilterParseToInternal(lv_flt);
			else
				flt = {"maxrec":100};
			$.ajax({
				url: "?prg=zcutp1_lgn&act=lgnrptmovvaldat",
				type: "POST",
				data: {
            vewmaxrec: flt["maxrec"],
						vewfldflt: flt["fltstr"]
				}
			}).done(function(data){
				var lv_buffer="";
				lv_buffer =  "" +
				"<table class='table table-condensed table-bordered table-striped table-hover' id ='<?php echo $lv_sec; ?>_tblmovval'>"+
				"<thead>"+
				"<tr><th>ID</th><th>Numero</th><th>Fecha</th><th>Tipo</th><th>Clase</th><th>Material</th><th>Codigo</th><th>Descripcion</th><th>Lote</th><th>Vencimiento</th><th>Nro. Serie</th>"+
				"<th>UM</th><th>Desde</th><th>Origen</th><th>Contacto</th><th>Hasta</th><th>Destino</th><th>Contacto</th><th>Codigo externo</th><th>Costo</th><th>Costo Actual</th><th>Cantidad</th>"+
				"</tr>" +
				"</thead>"+
				"</tbody>";
				for (var i= 0;i<data.data.length;i++) {
					//debugger;

					lv_buffer+= "<tr name='rlstblrow'>" +
					"<td>" +data.data[i].stkmovdoccod + "</td>" +
					"<td>" +data.data[i].stkmovdoccodext + "</td>" +
					"<td style='white-space: nowrap;'>" + data.data[i].stkmovdocdtecnv+"</td>" +
					"<td>" + data.data[i].sysdocclstxt + "</td>" +
					"<td>" + data.data[i].matdocclstxt +"</td>" +
					"<td>" + data.data[i].matcod +"</td>" +
					"<td>" + data.data[i].matcodext +"</td>" +
					"<td>" + data.data[i].mattxt +"</td>" +
					/*"<td>" + parseFloat((data.data[i].matcstlst==null ? "" : data.data[i].matcstlst)).toFixed(2).replace('.',',') +"</td>" +*/
					"<td style='white-space: nowrap;'>" + data.data[i].matbchcodext + "</td>" +
					"<td style='white-space: nowrap;'>" + (data.data[i].matbchduedtecnv==null?"":data.data[i].matbchduedtecnv) + "</td>" +
					"<td>" + data.data[i].matsercodext + "</td>" +
					"<td>" + data.data[i].matuntcod + "</td>" +
					"<td>" + data.data[i].srcobjtyptxt + "</td>" +
					"<td>" + data.data[i].srcobjtxt + "</td>" +
					"<td>" + (data.data[i].srccnttxt==null ? "" : data.data[i].srccnttxt) + "</td>" +
					"<td>" + data.data[i].dstobjtyptxt + "</td>" +
					"<td>" + data.data[i].dstobjtxt + "</td>" +
					"<td>" + (data.data[i].dstcnttxt==null ? "" : data.data[i].dstcnttxt) + "</td>" +
					"<td>" + (data.data[i].dstcntcodext==null ? "" : data.data[i].dstcntcodext) + "</td>" +
					"<td>" + parseFloat((data.data[i].matcstlst==null ? "" : data.data[i].matcstlst)).toFixed(2).replace('.',',') +"</td>" +
					"<td>" + parseFloat((data.data[i].matcst==null ? "" : data.data[i].matcst)).toFixed(2).replace('.',',') +"</td>" +
					"<td>" + parseFloat(data.data[i].matqty).toFixed(2).replace('.',',') + "</td>" +
					"</tr>";
				}
				lv_buffer +=  "</tbody></table>";
				lv_tbl= $("#<?php echo $lv_sec; ?>_tbl");
				//lv_tbl.replaceWith(lv_buffer);
				lv_tbl.html(lv_buffer);

			});
		}

		$(function() {
			<?php echo $lv_sec; ?>_sysdocgrd_refresh();
		});
	</script>
  <script>
    var gv_<?php echo $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $("#<?php echo $lv_sec; ?>_frm"), "<?php echo $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?php echo $lv_sec; ?>_last_action, '<?php echo $lv_title; ?>', '<b><?php echo $lv_dockey; ?></b>' ) ) {
				if (gv_<?php echo $lv_sec; ?>_last_action=='04') {
					tmssTabSecCls( $('#<?php echo $lv_sec; ?>') );
				} else {
					$('#<?php echo $lv_sec; ?>').replaceWith( data );
				}
			}
    });

		// form submit
    function <?php echo $lv_sec; ?>_fnc( lp_prm ) {
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {

				gv_<?php echo $lv_sec; ?>_last_action = lp_prm['action'];
				var lv_action = (gv_<?php echo $lv_sec; ?>_last_action=='99'?'<?php echo ($vew_actcod=='02'?'02':'03'); ?>':gv_<?php echo $lv_sec; ?>_last_action);
				if(lv_action =='09'){
					<?php echo $lv_sec; ?>_sysdocgrd_refresh();
				}
				if(lv_action =='10'){
					tmssLoadScript("table2excel",function(){
						<?php echo $lv_sec; ?>_export('<?php echo $lv_sec; ?>_tblmovval');
					});
				}
			}
		}

		function <?php echo $lv_sec; ?>_filter() {
			var lv_flt = [
										{ 'fldttl' 			: 'ID'
											, 'fldcod' 		: 'd.stkmovdoccod'
											, 'fldtyp' 		: 'TEXT'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},
										{ 'fldttl' 			: 'Numero'
											, 'fldcod' 		: 'd.stkmovdoccodext'
											, 'fldtyp' 		: 'TEXT'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},										
										{ 'fldttl' 			: 'Fecha'
											, 'fldcod' 		: 'stkmovdocdtecnv'
											, 'fldtyp' 		: 'DATE'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},
										{ 'fldttl' 			: 'Tipo'
											, 'fldcod' 		: 'dc.sysdocclstxt'
											, 'fldtyp' 		: 'TEXT'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},										
										{ 'fldttl' 			: 'Clase'
											, 'fldcod' 		: 'mdc.sysdocclstxt'
											, 'fldtyp' 		: 'TEXT'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},
										{ 'fldttl' 			: 'Material'
											, 'fldcod' 		: 'm.matcod'
											, 'fldtyp' 		: 'TEXT'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},										
										{ 'fldttl' 			: 'Descripcion'
											, 'fldcod' 		: 'dm.mattxt'
											, 'fldtyp' 		: 'TEXT'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},
										{ 'fldttl' 			: 'Nro Lote'
											, 'fldcod' 		: 'mb.matbchcodext'
											, 'fldtyp' 		: 'TEXT'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},
										{ 'fldttl' 			: 'Vencimiento'
											, 'fldcod' 		: 'matbchduedtecnv'
											, 'fldtyp' 		: 'DATE'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},
										{ 'fldttl' 			: 'Nro de serie'
											, 'fldcod' 		: 'ms.matsercodext'
											, 'fldtyp' 		: 'TEXT'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},

										{ 'fldttl' 			: 'Desde'
											, 'fldcod' 		: 'srcobjtyptxt'
											, 'fldtyp' 		: 'TEXT'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},
										{ 'fldttl' 			: 'Origen'
											, 'fldcod' 		: 'srcobjtxt'
											, 'fldtyp' 		: 'TEXT'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},
										{ 'fldttl' 			: 'Contacto'
											, 'fldcod' 		: 'srccnttxt'
											, 'fldtyp' 		: 'TEXT'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},										
										{ 'fldttl' 			: 'Hasta'
											, 'fldcod' 		: 'dstobjtyptxt'
											, 'fldtyp' 		: 'TEXT'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},
										{ 'fldttl' 			: 'Destino'
											, 'fldcod' 		: 'dstobjtxt'
											, 'fldtyp' 		: 'TEXT'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},
										{ 'fldttl' 			: 'Contacto'
											, 'fldcod' 		: 'dstcnttxt'
											, 'fldtyp' 		: 'TEXT'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										},
										{ 'fldttl' 			: 'Cantidad'
											, 'fldcod' 		: 'dm.matqty'
											, 'fldtyp' 		: 'TEXT'
											, 'flttyp' 		: 'LIKE'
											, 'fldvalstr' : ''
											, 'fldvalend' : ''
										}
										];
					tmssFilterShowDialog(lv_flt,<?php echo $lv_sec; ?>_sysdocgrd_refresh);
		}
  </script>
</section>

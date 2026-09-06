 <?php
	/* url del formulario */
  $lv_lnk = 'index.php?prg=zcutp1_lgn';

	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = '';

	/* titulo */
	$lv_title = $vew_lang->form;

	/* modulo y programa */
	$lv_mdlcod = '';
	$lv_prgcod = '';
	$vew_actcod = '09';
	$lo_updcsttyplst=[''=>'','0'=>$vew_lang->amount,'1'=>$vew_lang->percentage];

	/* libreria de estilos bootstrap */
	include_once('_library.frm');

	/* filtro de vista pre establecido */
	$lv_vewfldflt='';
	if ( isset($vew_prm['vewfldflt']) ) {
		$lv_vewfldflt = $vew_prm['vewfldflt'];
		unset($vew_prm['vewfldflt']);
	}
?>
<section id="<?php echo $lv_sec; ?>" data-model="<?php echo $vew_model; ?>" data-title="Reporte de Factura&iacute;on">
	<link href="library\css\temasis\2.0.0\tmssStyleDashboard.css" rel="stylesheet">

  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<a class="navbar-brand" href="#">Reporte Editable de Costos </a>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
        <a href="#" id="btnsim" class="btn btn-default navbar-btn"><span class="fa fa-calculator"></span></a>
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
			<div id="tbl">
        <table class="table table-condensed table-bordered" id="tblmovval">
          <thead>
          <tr>
            <th><input type="checkbox" id="chkcsthdr"></th>
            <th>ID</th>
            <th>Recurso</th>
            <th>Costo</th>
            <th>Moneda</th>
            <th>Cantidad</th>
            <th>Unidad</th>
            <th>Estado</th>
            <th>Proveedor</th>
            <th>Ult. Act. Fecha</th>
          </tr> 
          </thead>
          <tbody id="csttblbdy">
          </tbody>
        </table>
      </div>
		</div>
	</form>
  <!--VISTA DE VARIACION DE PRECIOS-->
	<div class="hidden" id="prcvar">
		<form method="POST" class="form-horizontal tmss-form-horizontal pb-0">
      <div class="card">
      	<div class="card-body">
          <div class="row">
            <div class="col-md-12">
              <?php
              	echo vew_boot($lv_colsm48, array('label'=>$vew_lang->type . ' de actualizacion','input'=>gethtml('updcsttyp',$lo_updcsttyplst, '', $lv_default) ));
                echo vew_boot($lv_colsm48, array('label'=>$vew_lang->value .' a actualizar', 'input'=>gethtml('updcstqty', 'docnum0300', '' , $lv_default) ));
              ?>
            </div>
          </div>
        </div>
      </div><!-- end card -->
		</form>
	</div> 
	<!-- FIN  VISTA DE VARIACION DE PRECIOS-->	
  <script>
		// VARIACION DE PRECIOS
		$("#<?= $lv_sec; ?> #btnsim").on("click",function(e){ e.preventDefault()
			var matsellst= $("#<?php echo $lv_sec; ?> #chkcst:checked");                                                         
			if (matsellst.length<1){
        toastr.error("No se ha seleccionado ningun material al cual actualizar costos" );
        return;
      }                                                         
			BootstrapDialog.show({
				title: "Actualizacion de costos",
				message: $("#<?= $lv_sec; ?> #prcvar").clone().removeClass("hidden"),
        size: BootstrapDialog.SIZE_NORMAL,
				closable: false,
				type: BootstrapDialog.TYPE_PRIMARY,
        draggable: true,
				buttons:[	{label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(e){e.close();} }, 
									{label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success", action: function(dialog){
                    var lv_updcsttyp = dialog.getModalBody().find("#updcsttyp").val();
                    var lv_updcstqty = dialog.getModalBody().find("#updcstqty").val();                    
                    if(lv_updcsttyp==''){
                      toastr.error("Falta selecconar el tipo de actualizacion de costo" );
                      return;
                    }
                    
                    if(lv_updcstqty==''){
                      toastr.error("Falta informar el valor a actualizar" );
                      return;
                    }
                    if(lv_updcsttyp=='0' && lv_updcstqty<=0){
                      toastr.error("En valor no puede ser menor a y1 si el tipo de actualizacion es <strong>Importe</strong>" );
                      return;
                    }
                    BootstrapDialog.confirm({
                      title: "Actualizar",
                      message: "	&iquest;Desea actualizar el costo de los "+ matsellst.length +" materiales seleccionados?",
                      type: BootstrapDialog.TYPE_WARNING,
                      callback: function(result) {
                        if(result) {
                          <?php echo $lv_sec; ?>_fnc( {action: '11',updcsttyp:lv_updcsttyp,updcstqty:lv_updcstqty} );
                          dialog.close();
                        }
                      }
                    });
									}}],  
			});
		});	
	</script>	
	<script>
		function <?php echo $lv_sec; ?>_export(lp_table){
			$(lp_table).table2excel({
					exclude: ".noExl",
					name: "Excel Document Name",
					filename: 'MatCst' + new Date().toISOString().replace(/[\-\:\.]/g, ""),
					fileext: ".xls",
					exclude_img: true,
					exclude_links: true,
					exclude_inputs: true
				});
		}

		var gv_<?php echo $lv_sec; ?>_flt = [
										{ 'fldttl': 'ID', 		 	'fldcod': 'm.matcod', 					'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
										{ 'fldttl': 'Recurso',	'fldcod': 'm.mattxt', 					'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},										
										{ 'fldttl': 'Costo', 		'fldcod': 'matcst', 						'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
										{ 'fldttl': 'Moneda',		'fldcod': 'matcstcurcod', 			'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},										
										{ 'fldttl': 'Cantidad', 'fldcod': 'matcstqty', 					'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
										{ 'fldttl': 'Unidad', 	'fldcod': 'matcstuntcod', 			'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},										
										{ 'fldttl': 'Estado', 	'fldcod': 'm.docsts', 						'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
										{ 'fldttl': 'Proveedor','fldcod': 'suptxt', 						'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''},
										{ 'fldttl': 'Ult. Act. Fecha', 		'fldcod': 'mc.matcstlstupd', 'fldtyp': 'DATE', 'flttyp': 'LIKE', 'fldvalstr' : '', 'fldvalend' : ''}
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
			tmssCallProcess("?prg=zcutp1_lgn&act=matcstupddat", {vewmaxrec: lv_fltint["maxrec"], vewfldflt: lv_fltint["fltstr"]}, function(data){
				var lv_buffer="";
				for (var i= 0;i<data.data.length;i++) {
					lv_buffer+= "<tr name='rlstblrow'>" +
          "<td><input type='checkbox' id='chkcst' data-matcod='"+ data.data[i].matcod  +"'></td>" +
          "<td>" + data.data[i].matcod +"</td>" +
					"<td>" + data.data[i].mattxt +"</td>" +
					"<td>" + parseFloat((data.data[i].matcst==null ? "" : data.data[i].matcst)).toFixed(2).replace('.',',') +"</td>" +
          "<td>" + data.data[i].matcstcurcod +"</td>" +
          "<td>" + data.data[i].matcstqty +"</td>" +
          "<td>" + data.data[i].matcstuntcod +"</td>" +
          "<td>" + data.data[i].docsts +"</td>" +
          "<td>" + (data.data[i].suptxt==null ? "":data.data[i].suptxt ) +"</td>" +
          "<td>" +(data.data[i].stkmatcstlstupddte==null?"":data.data[i].stkmatcstlstupddte) +"</td>" +
					"</tr>";
				}
        $("#<?= $lv_sec; ?> #csttblbdy").html( lv_buffer );
        $("#<?= $lv_sec; ?> #chkcst").on("change",function(e){
          if ( $(this).is(":checked") ) {
            $(this).parent().parent().addClass("bg-info");
          } else {
            $(this).parent().parent().removeClass("bg-info");
          }
        });
			});
		}
    $("#<?= $lv_sec; ?> #chkcsthdr").on("change",function(e){
			$("#<?= $lv_sec; ?> #chkcst").prop("checked",$(this).is(":checked")).trigger("change");
		});
		
		// form submit
    function <?php echo $lv_sec; ?>_fnc( lp_prm ) {
			if (lp_prm['action']=='prn') {
				window.print();
			} else if (lp_prm['action']== '09') {
        <?php echo $lv_sec; ?>_GridRefresh();
			}
			if(lp_prm['action'] =='10'){
        tmssLoadScript("table2excel",function(){
          debugger;
          <?php echo $lv_sec; ?>_export("#<?php echo $lv_sec; ?> #tblmovval");
        });
      }
      if(lp_prm['action'] =='11'){
        var lv_matcodlst = new Array();
        
        $("#<?php echo $lv_sec; ?> #chkcst:checked").each(function(){
          lv_matcodlst.push($(this).data("matcod"));
        });
        
        tmssCallProcess("?prg=zcutp1_lgn&act=matcstupdedt", {matcodlst:lv_matcodlst, updcsttyp: lp_prm["updcsttyp"], updcstqty: lp_prm["updcstqty"]}, function(data){
          <?php echo $lv_sec; ?>_GridRefresh();
					toastr.success("Costos actualizados");
         
        });
      }
		}
		<?php echo $lv_sec; ?>_GridRefresh();
  </script>

</section>
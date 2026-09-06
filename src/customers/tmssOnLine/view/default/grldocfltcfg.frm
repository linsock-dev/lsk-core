<?php
	// url del formulario 
  $lv_lnk = '';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->filter;
	
	// módulo y programa 
	$lv_mdlcod = '';
	$lv_prgcod = '';

	$vew_actcod = '02';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

	<style>.tmss-table-noheader tbody tr:first-child td{ border-top:0px; }</style>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab">Filtro Actual</a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab">Guardados</a></li>
				<?php if(count($vew_defcol)!=0){ ?><li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->layout; ?></a></li><?php } ?>
				<li class="pull-right"><small>#<?= $vew_vewcod; ?><?= gethtml('vewcod', 'hidden', $vew_vewcod); ?></small></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="card">
						<div class="card-header"><div class="card-title"><?= $vew_lang->save; ?>
							<a href="#" class="card-icon btn-success" id="vewfltsve" title="<?= $vew_lang->save; ?>"><i class="far fa-save"></i></a>		
						</div></div>
						<div class="card-body">
							<?= gethtml('vewfltcod','hidden',$vew_data->vewfltcod); ?>
							<?= gethtml('vewmaxrec','hidden',$vew_data->vewmaxrec); ?>
							<textarea id="vewfltdat" name="vewfltdat" class="hidden"><?= htmlentities($vew_data->vewfltdat); ?></textarea>
							<?= vew_boot($lv_colxs39, array('label'=>$vew_lang->name,	'input'=>gethtml('vewflttxt', 'doccmt1x50', $vew_data->vewflttxt, $lv_default) )); ?>
							<?= vew_boot($lv_colxs39, array('label'=>'Abrir por defecto', 'input'=>gethtml('vewfltdef','checkbox',$vew_data->vewfltdef,$lv_default) )); ?>
							<?= vew_boot($lv_colxs39, array('label'=>'Publico?', 'input'=>gethtml('vewfltpub','checkbox',$vew_data->vewfltpub,$lv_default) )); ?>
						</div>
					</div>
				</div>
				
				
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<div class="card">
						<div class="card-header"><div class="card-title"><?= 'Filtros Guardados'; ?>
							<a href="#" class="card-icon" title="<?= $vew_lang->refresh; ?>" onclick="<?= $lv_sec; ?>_refreshList();"><i class="far fa-refresh"></i></a>
							<a href="#" class="card-icon hidden btn-danger" id="vewflttbldel" title="<?= $vew_lang->delete; ?>"><i class="far fa-trash"></i></a>
						</div></div>
						<div class="card-body">
							<?= gethtml('vewfltsel','hidden',''); ?>
							<?= gethtml('vewfltselmaxrec','hidden',''); ?>
							<?= gethtml('vewfltseledt','hidden',''); ?>
							<textarea id="vewfltseldat" name="vewfltseldat" class="hidden"></textarea>
							<table class="table table-condensed tmss-table-noheader" id="vewflttbl">
								<tbody></tbody>
							</table>
						</div>
					</div>
				</div>
				
				
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
					<div class="card">
						<div class="card-header">
							<div class="card-title"><?= $vew_lang->layout; ?>
								<a href="#" class="card-icon <?=($vew_usrprf->usrprfcod!=''?'':'hidden');?>" id="vewlayrst" title="<?= $vew_lang->reset; ?>"><i class="far fa-rotate-left"></i></a>
								<a href="#" class="card-icon btn-success" id="vewlaysve" title="<?= $vew_lang->save; ?>"><i class="far fa-save"></i></a>
							</div>
						</div>
						<div class="card-body">
							<?= gethtml('usrprfcod','hidden',$vew_usrprf->usrprfcod); ?>
							<table class="table table-condensed" id="vewfltlay">
								<thead>
									<tr>
										<th></th>
										<th><?= $vew_lang->column; ?></th>
										<th><?= $vew_lang->visible; ?></th>
										<th><?= $vew_lang->filter; ?></th>
										<!--<th><?= $vew_lang->calculate; ?></th>-->
									</tr>
								</thead>
								<tbody>
									<?php
										foreach($vew_defcol as $lv_row) {
											echo '<tr data-vewfldcod="'.$lv_row['vewfldcod'].'">'
														.'<td><i class="far fa-bars" style="cursor:pointer;"></i></td>'
														.'<td>'.$vew_lang->getTranslation( $lv_row['vewfldttl'] ).'</td>'
														.'<td><input type="checkbox" name="vewfldwth" '.(intval($lv_row['vewfldwth'])!=0?'checked':'').'></td>'
														.'<td><input type="checkbox" name="vewfldflt" '.(intval($lv_row['vewfldflt'])==1?'checked':'').'></td>'
														//.'<td>'.($lv_row['sysfldinptyp']=='NUMBER'?'<select class="form-control"><option value=""></option><option value="sum">SUM</option><option value="avg">AVG</option><option value="min">MIN</option><option value="max">MAX</option></select>':'').'</td>'
													.'</tr>';
										}
									?>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
		
	</form>
	<script>
		// FILTRO ACTUAL. GRABAR
		$("#<?= $lv_sec; ?> #vewfltsve").on("click",function(e){ e.preventDefault();
      var lv_vewflttxt = $("#<?= $lv_sec; ?> #vewflttxt").val();
      if (lv_vewflttxt == "") {
        toastr.warning("El nombre del filtro no puede estar vac&iacute;o.");
        return;
      }
      var lv_vewfltdat = $("#<?= $lv_sec; ?> #vewfltdat").text();
      if (lv_vewfltdat == "") {
        toastr.warning("No se puede grabar el filtro sin datos.");
        return;
      }
			var lv_pstdat = [];
			lv_pstdat.push({ name: "vewcod", value: $("#<?= $lv_sec; ?> #vewcod").val() });
			lv_pstdat.push({ name: "vewfltcod", value: $("#<?= $lv_sec; ?> #vewfltcod").val() });
			lv_pstdat.push({ name: "vewflttxt", value: lv_vewflttxt });
			lv_pstdat.push({ name: "vewfltdef", value: $("#<?= $lv_sec; ?> #vewfltdef").val() });
			lv_pstdat.push({ name: "vewfltpub", value: $("#<?= $lv_sec; ?> #vewfltpub").val() });
			lv_pstdat.push({ name: "vewfltdat", value: lv_vewfltdat });
			lv_pstdat.push({ name: "vewmaxrec", value: $("#<?= $lv_sec; ?> #vewmaxrec").val() });
			lv_pstdat.push({ name: "docsts", value: "A" });
			tmssCallProcess("?prg=grlvew&act=saveFilter",lv_pstdat,function(data){
				if(data.errtyp=="E") {
					toastr.warning( data.errcod+": "+data.errtxt );
				} else {
					toastr.success("Filtro grabado.");
					$("#<?= $lv_sec; ?> #tmss_actcod").prop("value","ACTUAL_SAVE");
					$("#<?= $lv_sec; ?> #vewfltcod").prop("value", data.vewfltcod);
					<?= $lv_sec; ?>_refreshList();
				}
			});
		});
		
		
		// FILTROS GUARDADOS. BORRAR
		$("#<?= $lv_sec; ?> #vewflttbldel").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm({
				title: "Borrar Filtro",
				message: "Desea borrar los filtros seleccionados?",
				type: BootstrapDialog.TYPE_WARNING,
				btnCancelLabel: "No",
				btnOKLabel: "Si",
				btnOKClass: "btn-primary",
				callback: function(result) {
					if(result) {
						$("#<?= $lv_sec; ?> #vewflttbl tbody input[type=checkbox]").each(function(){
							if($(this).is(":checked")){
								var lv_vewfltcod = $(this).parent().parent().data("vewfltcod");
								var lv_pstdat = [{name: "vewfltcod", value: lv_vewfltcod }];
								tmssCallProcess("?prg=grlvew&act=deleteFilter",lv_pstdat,function(data){
									if(data.errtyp=="E"){
										toastr.success("Se produjo un error al borrar el filtro ["+lv_vewfltcod+"]. "+data.errcod+": "+data.errtxt);
									} else {
										$("#<?= $lv_sec; ?> #tmss_actcod").prop("value","ACTUAL_DELETE");
										if(lv_vewfltcod==$("#<?= $lv_sec; ?> #vewfltcod").val()){
											$("#<?= $lv_sec; ?> #vewfltcod").val("");
											$("#<?= $lv_sec; ?> #vewflttxt").val("");
											$("#<?= $lv_sec; ?> #vewfltpub").prop("checked","");
											$("#<?= $lv_sec; ?> #vewfltdef").prop("checked","");
										}
										var lv_vewflttxt = $("#<?= $lv_sec; ?> #vewflttbl tbody tr[data-vewfltcod="+lv_vewfltcod+"]").data("vewflttxt");
										$("#<?= $lv_sec; ?> #vewflttbl tbody tr[data-vewfltcod="+lv_vewfltcod+"]").remove();
										$("#<?= $lv_sec; ?> #vewflttbldel").addClass("hidden");
										toastr.success("Filtro ["+lv_vewflttxt+"] borrado.");
									}
								});
							}
						});
					}
				}
			});
		});
		
		
		// FILTROS GUARDADOS. CARGAR LISTA
		function <?= $lv_sec; ?>_refreshList(){
			var lv_pstdat = [{name: "vewcod", value: $("#<?= $lv_sec; ?> #vewcod").val()}];
			tmssCallProcessNoBackdrop("?prg=grlvew&act=getFilterList",lv_pstdat,function(data){
				var lv_dat = data.data;
				var lv_owner;
				$("#<?= $lv_sec; ?> #vewflttbl tbody tr").remove();
				for(var i=0; i<lv_dat.length; i++){
					lv_owner = (lv_dat[i]["usrcod"]=="<?= $vew_sec->usrcod; ?>"?true:false);
					lv_default = (lv_dat[i]["vewfltdef"]==1 && lv_owner ? true : false );
					lv_buffer = "<tr data-vewfltcod='"+lv_dat[i]["vewfltcod"]+"' data-vewflttxt='"+lv_dat[i]["vewflttxt"]+"' data-vewfltedt='"+(lv_owner?1:0)+"' data-vewmaxrec='"+lv_dat[i]["vewmaxrec"]+"'>"
										+"<td><textarea class='hidden'>"+lv_dat[i]["vewfltdat"]+"</textarea>"+(lv_owner?"<input type='checkbox' data-vewfltcod='"+lv_dat[i]["vewfltcod"]+"'>":"")+"</td>"
										+"<td><a href='#'>"+lv_dat[i]["vewflttxt"]+"</a>"+(lv_default?" <i class='far fa-circle-check' title='Filtro por defecto'></i>":"")+(lv_owner?"":" <small>("+lv_dat[i]["usrcod"].toLowerCase()+")</small>")+"</td>"
										+"</tr>";
					$(lv_buffer).appendTo( $("#<?= $lv_sec; ?> #vewflttbl tbody") );
				}

				// seleccionar filtro
				$("#<?= $lv_sec; ?> #vewflttbl tbody tr a").on("click",function(e){ e.preventDefault();					
					var lv_tr = $(this).parent().parent();
					$("#<?= $lv_sec; ?> #vewfltsel").prop("value",$(lv_tr).data("vewfltcod"));
					$("#<?= $lv_sec; ?> #vewfltseledt").prop("value",$(lv_tr).data("vewfltedt"));
					$("#<?= $lv_sec; ?> #vewfltselmaxrec").prop("value",$(lv_tr).data("vewfltmaxrec"));
					$("#<?= $lv_sec; ?> #vewfltseldat").text( $(lv_tr).find("textarea:first").text() );
					$("#<?= $lv_sec; ?> #tmss_actcod").prop("value","LIST_SELECT");
					$.each(BootstrapDialog.dialogs, function(id, dialog){
            if(dialog.getModalBody().find("#<?= $lv_sec; ?>").length>0){ dialog.close(); }
          });
				});
				
				// muestra/oculta boton de borrado si hay al menos un checkbox seleccionado
				$("#<?= $lv_sec; ?> #vewflttbl tbody input[type=checkbox]").on("change",function(e){
					var lv_qty = 0;
					$("#<?= $lv_sec; ?> #vewflttbl tbody input[type=checkbox]").each(function(){if($(this).is(":checked")){lv_qty++}});
					if(lv_qty==0){
						$("#<?= $lv_sec; ?> #vewflttbldel").addClass("hidden");
					} else {
						$("#<?= $lv_sec; ?> #vewflttbldel").removeClass("hidden");
					}
				});

			});
		}
		
		
		// LAYOUT. GRABAR
		$("#<?= $lv_sec; ?> #vewlaysve").on("click",function(e){ e.preventDefault();
		
			var i = 0;
			var lv_visible = 0;
			var lv_lay = [];
			$("#<?= $lv_sec; ?> #vewfltlay tbody tr").each(function(){
				lv_lay.push({"vewfldcod":$(this).data("vewfldcod"),"vewfldord":i,"vewfldwth":($(this).find("input[name=vewfldwth]").is(":checked")?1:0),"vewfldflt":($(this).find("input[name=vewfldflt]").is(":checked")?1:0),"vewfldcal":$(this).find("select:first").val()});
				lv_visible += ($(this).find("input[name=vewfldwth]").is(":checked")?1:0);
				i++;
			});
			
			if( lv_visible==0 ){
				toastr.warning("Al menos debe tener una columna visible para grabar la disposición.");
				return false;
			}
			
			var lv_pstdat = [];
			lv_pstdat.push({ name: "vewcod", value: $("#<?= $lv_sec; ?> #vewcod").val() });
			lv_pstdat.push({ name: "usrprfval", value: JSON.stringify( lv_lay ) });
			tmssCallProcess("?prg=grlvew&act=saveLayout",lv_pstdat,function(data){
				if(data.errtyp=="E") {
					toastr.warning( "Se produjo un error al grabar la disposici&oacute;n. "+data.errcod+": "+data.errtxt );
				} else {
					toastr.success("Disposici&oacute;n grabada. Cargue la vista nuevamente para aplicar los cambios realizados.");
					$("#<?= $lv_sec; ?> #usrprfcod").prop("value", data.usrprfcod);
					$("#<?= $lv_sec; ?> #vewlayrst").removeClass("hidden");
				}
			});
		});
		
		
		// LAYOUT. RESET
		$("#<?= $lv_sec; ?> #vewlayrst").on("click",function(e){ e.preventDefault();
			var lv_pstdat = [];
			lv_pstdat.push({ name: "usrprfcod", value: $("#<?= $lv_sec; ?> #usrprfcod").val() });
			tmssCallProcess("?prg=grlvew&act=deleteLayout",lv_pstdat,function(data){
				if(data.errtyp=="E") {
					toastr.warning( "Se produjo un error al resetear la disposici&oacute;n. "+data.errcod+": "+data.errtxt );
				} else {
					toastr.success("Disposici&oacute;n reseteada. Cargue nuevamente la vista.");
					$("#<?= $lv_sec; ?> #usrprfcod").val("");
					$("#<?= $lv_sec; ?> #vewlayrst").addClass("hidden");
					$.each(BootstrapDialog.dialogs, function(id, dialog){
            if(dialog.getModalBody().find("#<?= $lv_sec; ?>").length>0){ dialog.close(); }
          });
				}
			});
		});
		
		
		tmssLoadScript("jquery-ui",function(){
			$("#<?= $lv_sec; ?> #vewfltlay tbody").sortable({ placeholder: "ui-state-highlight" });
			$("#<?= $lv_sec; ?> #vewfltlay tbody").disableSelection();
		});

		$(function(){ <?= $lv_sec; ?>_refreshList(); });

	</script>
</section>
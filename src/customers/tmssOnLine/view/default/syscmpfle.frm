<?php
	// url del formulario
  $lv_lnk = '?prg=syscmp&act=38';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->comparission;
	
	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'CMP';
	
	$vew_actcod = '02';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
	
	$vew_tbl['canc']=array('per'=>false);
	$vew_tbl['sveL']=array('per'=>false);
	$vew_tbl['sveR']=array('per'=>false);
	$vew_tbl['btncmp'] = array('pos'=>'L','per'=>true, 'ttl'=>$vew_lang->compare, 'id'=>'btncmp','icn'=>'far fa-sync', 'css'=>'btn btn-success navbar-btn tmss-navbar-btn tmssAlwaysEnabled', 'acc'=>'' );
	$vew_tbl['btndb'] = array('pos'=>'R','per'=>true, 'ttl'=>$vew_lang->database, 'id'=>'btndb','icn'=>'far fa-database', 'css'=>'btn btn-default navbar-btn tmss-navbar-btn tmssAlwaysEnabled', 'acc'=>$lv_sec.'_fnc({action: 28});' );
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
	<div class="container-fluid">
		<div class="row">
			<div class="col-sm-4">
			
				<div class="card">
					<div class="card-header"><div class="card-title">Que vas a comparar?</div></div>
					<div class="card-body">
						<div class="list-group" id="flegrp"> 
							<li class="list-group-item">Archivo
								<?= gethtml('flenme','doccmt1x50','',$lv_default); ?>
							</li>
							<a href="#" class="list-group-item" data-grp="controller">Controller <span class="badge"></span></a>
							<a href="#" class="list-group-item" data-grp="model">Model <span class="badge"></span></a>
							<a href="#" class="list-group-item" data-grp="view">View <span class="badge"></span></a>
							<a href="#" class="list-group-item" data-grp="wwwroot">wwwroot <span class="badge"></span></a>
							<a href="#" class="list-group-item" data-grp="css">Css <span class="badge"></span></a>
							<a href="#" class="list-group-item" data-grp="js">Js <span class="badge"></span></a>
							<a href="#" class="list-group-item" data-grp="engine">Engine <span class="badge"></span></a>
						</div>
					</div>
				</div>
			
			</div>
			<div class="col-sm-8">
			
				<div class="card">
					<div class="card-body">
						<table class="table table-bordered table-condensed" id="tblfle">
							<thead><tr><td></td><td>DEV</td><td></td><td>PRD</td></tr></thead>
							<tbody></tbody>
						</table>
					</div>
				</div>
				
			</div>
		</div><!-- /row -->
	</div>
	</form>
	<script>
		$("#<?= $lv_sec; ?> #flegrp a").on("click",function(e){ e.preventDefault();
			var lv_grp = $(this).data("grp");
			var lv_active = $(this).hasClass("active");
			$("#<?= $lv_sec; ?> #flegrp a").removeClass("active");
			$("#<?= $lv_sec; ?> #tblfle tbody tr").removeClass("hidden");
			if(!lv_active){
				$(this).addClass("active");
				$("#<?= $lv_sec; ?> #tblfle tbody tr").each(function(){
					if($(this).find("td:first").text()==lv_grp){
						$(this).removeClass("hidden");
					} else {
						$(this).addClass("hidden");
					}
				});
			}
		});


		$("#<?= $lv_sec; ?> #btncmp").on("click",function(e){e.preventDefault();
			var lv_pstdat = [];
			if($("#<?= $lv_sec; ?> #flegrp a.active").length>0){
				var lv_flegrp = $("#<?= $lv_sec; ?> #flegrp a.active").data("grp");
				lv_pstdat.push({name:"grp",value:lv_flegrp});
			}
			if($("#<?= $lv_sec; ?> #flenme").val()!=""){
				lv_pstdat.push({name:"flenme",value:$("#<?= $lv_sec; ?> #flenme").val()});
			}
			
			$("#<?= $lv_sec; ?> #flegrp a span.badge").html("");
			$("#<?= $lv_sec; ?> #tblfle tbody").html("");
			
			tmssCallProcess("?prg=syscmp&act=getFileList",lv_pstdat,function(data){
				data=data.data;
				// cargo registros
				for(var i=0; i<data.length; i++){
					var lv_buffer = "<tr data-dif='"+data[i].dif+"' data-grp='"+data[i].grp+"' data-sysobjcod='"+data[i].sysobjcod+"'>"
						+"<td>"+data[i].grp+"</td>"
						+"<td>"+(data[i].dif=="D" || data[i].dif=="X" ? data[i].sysobjtxt.toUpperCase() : "")+"</td>"
						+"<td><a href='#' name='btnflecmp' data-dif='"+data[i].dif+"' data-grp='"+data[i].grp+"' data-sysobjtxt='"+data[i].sysobjtxt+"' class='btn "+(data[i].dif=="X"?"btn-primary":"btn-warning")+"' data-sysobjcod='"+data[i].sysobjcod+"'><i class='far "+(data[i].dif=="D"?"fa-arrow-right":(data[i].dif=="P"?"fa-arrow-left":"fas fa-exchange-alt"))+"'></i></a></td>"
						+"<td>"+(data[i].dif=="P" || data[i].dif=="X" ? data[i].sysobjtxt.toUpperCase() : "")+"</td>"
						+"</tr>";
					$("#<?= $lv_sec; ?> #tblfle tbody").append( lv_buffer );
				}
				// cargo cantidades
				$("#<?= $lv_sec; ?> #flegrp a").each(function(){
					var lv_qty = $("#<?= $lv_sec; ?> #tblfle tbody tr[data-grp="+$(this).data("grp")+"]").length;
					$(this).find("span.badge").html( (lv_qty>0?lv_qty:"") );
				});

				$("#<?= $lv_sec; ?> a[name='btnflecmp']").on("click",function(e){ e.preventDefault();
					var lv_sysobjcod = $(this).data("sysobjcod");
					var lv_grp = $(this).data("grp");
					var lv_fle = $(this).data("sysobjtxt");
					if($(this).data("dif")=="X"){
						var lv_pstdat = {sysobjcod: lv_sysobjcod};
						tmssCallProcess("?prg=sysobj&act=showCompare",lv_pstdat,function(data){
							BootstrapDialog.show({
          			cssClass: "tmss-modal-xl",
								title: lv_grp.toUpperCase()+": "+lv_fle.toUpperCase(),
								closable: true,
								draggable: true,
								message: $(data),
								buttons: [{
														label: "<i class='far fa-chevron-left'></i> <?= $vew_lang->recover; ?>", cssClass: "btn-warning pull-left",
														action: function(dialogRef){ <?= $lv_sec; ?>_sendFile( lv_sysobjcod, "developers" ); dialogRef.close(); }
													},
													{ label: "<?= $vew_lang->send; ?> <i class='far fa-chevron-right'></i>", cssClass: "btn-success",
														action: function(dialogRef){ <?= $lv_sec; ?>_sendFile( lv_sysobjcod, "customers" ); dialogRef.close(); }
													}]
							});
						});
					} else {
						var lv_sendto = ($(this).data("dif")=="D"?"customers":($(this).data("dif")=="P"?"developers":""));
						<?= $lv_sec; ?>_sendFile( lv_sysobjcod, lv_sendto );
					}
					
				});
				
			});
			
		});
		
		function <?= $lv_sec; ?>_sendFile( lp_sysobjcod, lp_sendto ){
			var lv_pstdat = [{name:"sysobjcod",value:lp_sysobjcod},{name:"sendto",value:lp_sendto}];
			tmssCallProcess("?prg=sysobj&act=sendFile",lv_pstdat,function(data){
				if(data.errtyp=="S"){
					toastr.success("Archivo enviado");
					// quitar archivo de la lista
					$("#<?= $lv_sec ;?> #tblfle tbody tr[data-sysobjcod="+lp_sysobjcod+"]").remove();
					// actualiza contador de grupo
					$("#<?= $lv_sec; ?> #flegrp a").each(function(){
						var lv_qty = $("#<?= $lv_sec; ?> #tblfle tbody tr[data-grp="+$(this).data("grp")+"]").length;
						$(this).find("span.badge").html( (lv_qty>0?lv_qty:"") );
					});
				}
			});
		}
	</script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
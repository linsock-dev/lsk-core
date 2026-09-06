<?php
	// url del formulario 
  $lv_lnk = '';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = ''; 

	// titulo 
	$lv_title = $vew_lang->log;
	
	// modulo y programa 
	$lv_mdlcod = 'SLS';
	$lv_prgcod = 'FCE';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<div class="row">
		<div class="col-sm-4 hidden-xs text-center">
			<i class="fas fa-satellite-dish fa-7x" style="color:#f6f6f6;"></i>
			<div class="progress" style="margin-top: 20px;">
				<div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>
			</div>
		</div>
		<div class="col-sm-8 col-xs-12">
			<table class="table table-bordered table-condensed">
				<thead>
					<tr><th>Factura</th><th style="width:70px;">Estado</th></tr>
				</thead>
				<tbody>
					<?php foreach($vew_data->slsinvlst as $lv_key=>$lv_val) { echo '<tr data-slsinvcod="'.$lv_val.'"><td>'.$lv_val.'</td><td class="text-center"><i class="fa fa-ellipsis-h"></i></td></tr>'; } ?>
				</tbody>
			</table>
		</div>
	</div>
	<script>
		var lv_tot = $("#<?= $lv_sec; ?> table tbody tr").length;
		var lv_prc = 0;
		$(function(){
			// recorro todas las facturas a autorizar.
			$("#<?= $lv_sec; ?> table tbody tr").each(function(){
				lv_prc++;
				var lv_len = lv_prc*100/(lv_tot*2);
				$("#<?= $lv_sec; ?> .progress-bar").css("width", lv_len.toFixed(0)+"%");
				$(this).find("i:first").removeClass("fa-ellipsis-h").addClass("fa-spinner fa-spin").parent().addClass("bg-warning");
				var lv_pstdat = [{name:"slsinvcod",value:$(this).data("slsinvcod")}];
				tmssCallProcessNoBackdrop("?prg=slsinvfce&act=procSlsInvFce",lv_pstdat,function(data){
					lv_prc++;
					var lv_len = lv_prc*100/(lv_tot*2);
					$("#<?= $lv_sec; ?> .progress-bar").css("width", lv_len.toFixed(0)+"%");
          
					if(data.data.errtyp=="E"){
            toastr.warning(data.data.errtxt);
						$("#<?= $lv_sec; ?> table tbody tr[data-slsinvcod="+data.data.slsinvcod+"]").find("i:first").removeClass("fa-spinner fa-spin").addClass("fa-times").parent().removeClass("bg-warning").addClass("bg-danger").css("cursor","pointer");
					} else {
						$("#<?= $lv_sec; ?> table tbody tr[data-slsinvcod="+data.data.slsinvcod+"]").find("i:first").removeClass("fa-spinner fa-spin").addClass("fa-check-circle").parent().removeClass("bg-warning").addClass("bg-success").css("cursor","pointer");
					}
          
          if (lv_prc >= lv_tot) {
            setTimeout(function() {
            	$("#<?= $lv_sec; ?> .progress-bar").parent().hide();
            }, 500);
          }
					
					// agrego evento de consulta de log
					$("#<?= $lv_sec; ?> table tbody tr[data-slsinvcod="+data.data.slsinvcod+"]").find("i:first").on("click",function(e){ e.preventDefault();
          	var err = (<?= $vew_data->showlog ?> == 0) ? '0' : ($(this).parent().hasClass("bg-danger") ? '1' : '0');
						tmssCallProcess("?prg=slsinvfce&act=showLog", [{name:"slsinvcod",value: data.data.slsinvcod }, {name: "err", value: err}], function(data){
							BootstrapDialog.show({
								size: BootstrapDialog.SIZE_WIDE,
								title: "<?= $vew_lang->log; ?>",
								message: $(data)
							});
						});
					});
					
				});
			});
		});
	</script>
</section>
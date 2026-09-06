<?php
	// url del formulario
  $lv_lnk = '?prg=grlcal&prm_grlcalcod='.$vew_data->grlcalcod;

	// campos requeridos
	$vew_input->RequiredFields( array('grlcaltxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->grlcalcod;

	// titulo
	$lv_title = $vew_lang->calendar;
	
	// módulo y programa
	$lv_mdlcod = 'ADM';
	$lv_prgcod = 'CAL';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
	
	$lv_daytxt = array(''=>'','L'=>'Lunes','M'=>'Martes','X'=>'Miercoles','J'=>'Jueves','V'=>'Viernes','S'=>'Sabado','D'=>'Domingo')
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('grlcalatr','hidden',$vew_data->grlcalatr); ?>
			<div class="container-fluid" role="tabpanel">
			<!-- Solapas -->
				<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
					<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
					<li class="pull-right"><h4># <strong><?= $vew_data->grlcalcod; ?><input type="hidden" id="grlcalcod" name="grlcalcod" value="<?= $vew_data->grlcalcod; ?>"></strong></h4></li>
				</ul>
				<div class="tab-content tmss-tab-content">				
					<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">		
						<div class="row">
							<div class="col-md-6">
								<div class="card">
									<div class="card-header">
										<div class="card-title">
											<?= $lv_title; ?>
										</div>
          				</div>
         	 				<div class="card-body tmss-card-body-edit">
           					<?php 
					  					echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 		'input'=>gethtml('grlcalcodext', 'doccodext', $vew_data->grlcalcodext, $lv_default) ));
											echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('grlcaltxt', 'doccmt1x50', $vew_data->grlcaltxt, $lv_default) ));
											echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
					 					?>
          				</div>
								</div>
							</div><!-- /col-md-6 -->
							<div class="col-md-6">
								<div class="card">
									<div class="card-header"><div class="card-title"><?= $vew_lang->days; ?></div></div>
									<div class="card-body tmss-card-body-edit">
										<table class="table table-condensed" id="tbltme">
											<thead>
												<tr>
													<?php
														if($vew_readonly){
															echo '<th>'.$vew_lang->day.'</th><th>'.$vew_lang->start.'</th><th>'.$vew_lang->end.'</th></tr>';
														} else {
															echo '<th>'.gethtml('calrngday',$lv_daytxt,'',$lv_default).'</th>';
															echo '<th width="20%">'.gethtml('calrngstr','doctme','',$lv_default).'</th>';
															echo '<th width="20%">'.gethtml('calrngend','doctme','',$lv_default).'</th>';
															echo '<th width="1%"><a href="#" class="card-icon" id="btnadd"><i class="far fa-plus"></i></a></th>';
														}
													?>
												</tr>
											</thead>
											<tbody>
												<?php
													$lv_arr = json_decode($vew_data->grlcalatr,true);
													if(is_array($lv_arr)){
														foreach($lv_arr['calrng'] as $lv_row){
															echo '<tr data-tmeday="'.$lv_row['tmeday'].'" data-tmestr="'.$lv_row['tmestr'].'" data-tmeend="'.$lv_row['tmeend'].'"><td>'.$lv_daytxt[$lv_row['tmeday']].'</td><td>'.$lv_row['tmestr'].'</td><td>'.$lv_row['tmeend'].'</td>'.($vew_readonly?'':'<td><a href="#" class="card-icon text-danger" onclick="'.$lv_sec.'_removeTme($(this).parent().parent());"><i class="far fa-minus"></i></a></td>').'</tr>';
														}
													}
												?>
											</tbody>
										</table>
									</div>
								</div> <!-- /card -->							
							</div><!-- /col-md-6 -->
						</div>
					</div> <!-- fin _tab001 -->
				</div> <!-- tabcontent -->
			</div> <!-- container-fluid -->
  </form>
	<script>
		$("#<?= $lv_sec; ?> #btnadd").on("click",function(e){ e.preventDefault();
			var lv_day = $("#<?= $lv_sec; ?> #calrngday").prop("value");
			var lv_daytxt = $("#<?= $lv_sec; ?> #calrngday option:selected").text();
			var lv_str = $("#<?= $lv_sec; ?> #calrngstr").prop("value");
			var lv_end = $("#<?= $lv_sec; ?> #calrngend").prop("value");
			$("#<?= $lv_sec; ?> #tbltme tbody").append("<tr data-tmeday='"+lv_day+"' data-tmestr='"+lv_str+"' data-tmeend='"+lv_end+"'><td>"+lv_daytxt+"</td><td>"+lv_str+"</td><td>"+lv_end+"</td><td><a href='#' class='card-icon text-danger' onclick='<?= $lv_sec; ?>_removeTme($(this).parent().parent());'><i class='far fa-minus'></i></a></td></tr>");
			$("#<?= $lv_sec; ?> #calrngstr").prop("value","");
			$("#<?= $lv_sec; ?> #calrngend").prop("value","");			
			$("#<?= $lv_sec; ?> #calrngday").prop("value","").focus();
		});
		function <?= $lv_sec; ?>_removeTme( lp_row ){
			$(lp_row).remove();
		}
	</script>
	<script>
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if (lp_prm["action"]=="00") {
				var lv_grlcalatr = {"calrng":[]};
				$("#<?= $lv_sec; ?> #tbltme tbody tr").each(function(){
					lv_grlcalatr["calrng"].push( {"tmeday":$(this).data("tmeday"),"tmestr":$(this).data("tmestr"),"tmeend":$(this).data("tmeend")} );
				});
				$("#<?= $lv_sec; ?> #grlcalatr").prop("value", JSON.stringify( lv_grlcalatr ) );
			}
		}		
	</script>	
	<?php include('grldocfrmscr.frm'); ?>
</section>
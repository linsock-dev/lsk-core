<?php	
	// url del formulario
  $lv_lnk = '';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = ''; 

	// titulo
	$lv_title = '';
	
	// modulo y programa
	$lv_mdlcod = '';
	$lv_prgcod = '';

	// librer?a de estilos bootstrap
	include_once('_library.frm');
	
	// armo nueva estructura con el log de cambios
	$lv_chgarr = array();
	foreach( $vew_data->chglst as $lv_row ) {
		if( !isset($lv_chgarr[$lv_row['chgdoccod']]) ){ 
			$lv_chgarr[$lv_row['chgdoccod']]=array('chgdoccod'=>$lv_row['chgdoccod'],'cteusr'=>$lv_row['cteusr'],'ctedte'=>date_format($lv_row['ctedte'],'d.m.Y H:i'),'chgatr'=>array());
		}
		$lv_row['chgdocatrnme'] = html_entity_decode($lv_row['chgdocatrnme']);
		$lv_row['chgdocatrold'] = html_entity_decode($lv_row['chgdocatrold']);
		$lv_row['chgdocatrnew'] = html_entity_decode($lv_row['chgdocatrnew']);
		if($vew_data->main!=''){
			$lv_str1 = ';'.strtolower(rtrim(ltrim($lv_row['chgdocatrnme']))).';';
			$lv_str2 = strtolower(';'.rtrim(ltrim($vew_data->main)).';');
			if( stripos( $lv_str2 , $lv_str1 )!==false ) {
				$lv_row['main'] = true;
			} else {
				$lv_row['main'] = false;
			}
		} else {
			$lv_row['main'] = true;
		}
		$lv_chgarr[$lv_row['chgdoccod']]['chgatr'][] = $lv_row;
	}
	
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<style>
		ul.timeline {
				list-style-type: none;
				position: relative;
		}
		ul.timeline:before {
				content: ' ';
				background: #d4d9df;
				display: inline-block;
				position: absolute;
				/*left: 29px;*/
				left: 9px;
				width: 2px;
				height: 100%;
				z-index: 400;
		}
		ul.timeline > li {
				margin: 20px 0;
				/*padding-left: 20px;*/
		}
		ul.timeline > li:before {
				content: ' ';
				background: white;
				display: inline-block;
				position: absolute;
				border-radius: 50%;
				border: 3px solid #22c0e8;
				/*left: 20px;*/
				left: 0px;
				width: 20px;
				height: 20px;
				z-index: 400;
		}
	</style>
	<div class="card">
		<div class="card-header">
			<div class="card-title"><?= $vew_lang->history; ?>
				<?= ($vew_data->main!='' && count($lv_chgarr)>0? '<a href="#" id="chgatrdet" class="card-icon"><i class="far fa-circle-info"></i></a>' : '' ); ?>
			</div>
		</div>
		<div class="card-body tmss-card-body-edit" style="overflow-y: auto; max-height: 330px;">		
			<ul class="timeline">
				<?php
					foreach( $lv_chgarr as $lv_row ) {
						$i=0;
						$lv_buffer = '<li><small style="font-weight:600;">'.$lv_row['cteusr'].'</small>'.
												'<small class="float-right pull-right" style="color: #a3a3a3;">'.$lv_row['ctedte'].'</small>';
						foreach($lv_row['chgatr'] as $lv_rowatr){
							if($lv_rowatr['main']==true){
								$i++;
								$lv_buffer .= '<p style="min-height:35px;margin-top:5px;" data-chgdoccod="'.$lv_row['chgdoccod'].'" data-chgdocatrcod="'.$lv_rowatr['chgdocatrcod'].'">'.
																($vew_data->main!=''?'':'<small style="color:#a3a3a3;">'.$lv_rowatr['chgdocatrnme'].'</small><br>').
																(strtolower($vew_sec->usrcod)==strtolower($lv_row['cteusr']) && strtolower($lv_rowatr['chgdocatrnme'])=='comentarios'?'<a href="#" name="btnedt" class="hidden card-icon" style="float:right;position:relative;top:0px;"><i class="far fa-pen"></i></a>':'').
																'<span name="'.$lv_rowatr['chgdocatrnme'].'">'.$lv_rowatr['chgdocatrold'].(trim($lv_rowatr['chgdocatrold'])=='' || trim($lv_rowatr['chgdocatrnew'])=='' ? '' : '&nbsp;<i class="fas fa-angle-right"></i>&nbsp;').($lv_rowatr['chgdocatrnew']).'</span>'.
															'</p>';
							}
						}
						$lv_buffer .= '</li>';
						if($i>0){ echo $lv_buffer; }
					}
				?>
			</ul>
		</div>
	</div> <!-- /card -->
	
	<div class="hidden" id="chgatr">
		<table class="table table-condensed table-bordered">
			<thead>
				<tr><th><?= $vew_lang->when; ?></th><th><?= $vew_lang->who; ?></th><th><?= $vew_lang->what; ?></th><th><?= $vew_lang->change; ?></th></tr>
			</thead>
			<tbody>
				<?php
					$lv_buffer = '';
					foreach( $lv_chgarr as $lv_row ) {
						$i=0;
						$lv_buffer = '<tr class="bg-info"><td>'.$lv_row['ctedte'].'</td><td>'.$lv_row['cteusr'].'</td><td></td><td></td></tr>';
						foreach($lv_row['chgatr'] as $lv_rowatr){
							if($lv_rowatr['main']==false){
								$i++;
								$lv_buffer .= '<tr><td></td><td></td><td>'.$lv_rowatr['chgdocatrnme'].'</td><td>'.$lv_rowatr['chgdocatrold'].(trim($lv_rowatr['chgdocatrold'])=='' || trim($lv_rowatr['chgdocatrnew'])=='' ? '' : '&nbsp;<i class="fas fa-angle-right"></i>&nbsp;').$lv_rowatr['chgdocatrnew'].'</td></tr>';
							}
						}
						if($i>0){ echo $lv_buffer; }
					}
				?>
			</tbody>
		</table>
	</div>
	
	<div class="hidden" id="divcmtedt">
		<?= gethtml('txtcmt','doccmt10x50','',$lv_default); ?>
	</div>
	
	<script>
		$("#<?= $lv_sec; ?> .timeline li").on("mouseenter",function(e){
			$(this).find("a[name=btnedt]").removeClass("hidden");
		});
		$("#<?= $lv_sec; ?> .timeline li").on("mouseleave",function(e){
			$(this).find("a[name=btnedt]").addClass("hidden");
		});
		$("#<?= $lv_sec; ?> #chgatrdet").on("click",function(e){ e.preventDefault();
			BootstrapDialog.show({
				title: "<?= $vew_lang->attributes; ?>", 
				message: $("#<?= $lv_sec; ?> #chgatr").clone().removeClass("hidden"),
				size: BootstrapDialog.SIZE_WIDE,
				type: BootstrapDialog.TYPE_PRIMARY,
				draggable: true,
			});
		});
		$("#<?= $lv_sec; ?> .timeline li a[name=btnedt]").on("click",function(e){ e.preventDefault();
			var lo_btn = $(this);
			BootstrapDialog.show({
				title: "<?= $vew_lang->comments; ?>", 
				message: $("#<?= $lv_sec; ?> #divcmtedt").clone().removeClass("hidden"),
				size: BootstrapDialog.SIZE_WIDE,
				type: BootstrapDialog.TYPE_PRIMARY,
				draggable: true,
				onshown: function(dialog){
										var lv_txt = $(lo_btn).parent().find("span[name=Comentarios]").html().replace(/<br\s*\/?>/gi, '\n');
          					dialog.getModalBody().find("#txtcmt").text( lv_txt ).focus();
									},
				buttons: [{label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialog){dialog.close(); }},
									{label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialog){
										var lv_pstdat =[{name:"chgdocatr",value:dialog.getModalBody().find("#txtcmt").val().replace(/\n/g, '<br>')},
																		{name:"chgdoccod",value:$(lo_btn).parent().data("chgdoccod") },
																		{name:"chgdocatrcod",value:$(lo_btn).parent().data("chgdocatrcod")}];
										tmssCallProcess("?prg=sysdocchg&act=12&prm_main=<?= $vew_data->main; ?>&prm_chgdocsrctyp=<?= $vew_data->chgdocsrctyp; ?>&prm_chgdocsrccod=<?= $vew_data->chgdocsrccod; ?>",lv_pstdat,function(data){
											$("#<?= $lv_sec; ?>").replaceWith(data);
											dialog.close();
										});
									}}]
			});
		});
	</script>
</section>
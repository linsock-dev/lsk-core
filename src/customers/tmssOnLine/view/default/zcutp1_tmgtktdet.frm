 <?php
	/* url del formulario */
  $lv_lnk = "?prg=zcutp1_tmg&prm_cntcod=".$vew_data->crmcntcod; 

	/* campos requeridos */
	$vew_input->RequiredFields(  );

	/* clave del documento */
	$lv_dockey = $vew_data->crmcntcod; 

	/* titulo */
	$lv_title = 'Ticket';
	
	/* m�dulo y programa */
	$lv_mdlcod = 'CRM';
	$lv_prgcod = 'CNT';
	
	/* librer�a de estilos bootstrap */
	include_once('_library.frm');
	$vew_tbl['cpy']['per']=false;
	$vew_tbl['del']['per']=false;
	$vew_tbl['cpy']['per']=false;
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!--navbar-->
	<?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
    <?=$vew_readonly?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->crmcntcod; ?><?= gethtml('spccod', 'hidden', $vew_data->crmcntcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              <?php
              
              echo vew_boot($lv_col210, array("label"=>$vew_lang->date,'input'=>gethtml('civstscod','docdte','',$lv_default) )); 
              echo vew_boot($lv_col210, array("label"=>$vew_lang->title,'input'=>gethtml('civstscod','doccmt1x20','',$lv_default) )); 
              echo vew_boot($lv_col210, array("label"=>$vew_lang->description,'input'=>gethtml('civstscod','doccmt5x20','',$lv_default) )); 
              
              //echo vew_boot($lv_col210, array("label"=>$vew_lang->civilstatus,'input'=>gethtml('civstscod',$lo_percivsts,'',$lv_default) )); 
              ?>
						</div>
						<div class="col-md-6">
              <?php
                
              
                echo vew_boot($lv_col210, array("label"=>$vew_lang->type,'input'=>gethtml('civstscod',$vew_data->crmtyplst,'',$lv_default) )); 
                echo vew_boot($lv_col210, array("label"=>$vew_lang->motive,'input'=>gethtml('civstscod',$vew_data->crmcntmtvlst,'',$lv_default) )); 
                echo vew_boot($lv_col210, array("label"=>$vew_lang->priority,'input'=>gethtml('civstscod',$vew_data->crmcntprtlst,'',$lv_default) )); 
              	echo vew_boot($lv_col210, array("label"=>$vew_lang->requester,'input'=>gethtml('civstscod','doccmt1x20','',$lv_default) )); 
              ?>
						</div>
					</div>
				</div> <!-- fin _tab001 -->				

			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
		$("#<?= $lv_sec; ?> #btntme").on("click",function(e){
			e.preventDefault();
			var lv_pstdat = [{name:"cntcod", value:"<?= $vew_data->crmcntcod; ?>"}];
			tmssCallProcess("?prg=hltspctme&act=03",lv_pstdat,function(data){
				BootstrapDialog.show({
					size: BootstrapDialog.SIZE_WIDE,
					title: "<?= $vew_lang->schedule; ?>",
					closable: false,
					draggable: true,
					message: $(data),
					buttons: [{ label: "Cerrar", cssClass: "btn-default", action: function(dialogRef){ dialogRef.close(); } }]
				});
			});
		});
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
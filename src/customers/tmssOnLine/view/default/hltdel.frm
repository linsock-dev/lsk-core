<?php
	/* url del formulario */
  $lv_lnk = "?prg=hltdel&prm_delcod=".$vew_data->delcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('deltxt','docsts','lndcod','deltyp', 'sysdocclscod') );

	/* clave del documento */
	$lv_dockey = $vew_data->delcod; 

	/* titulo */
	$lv_title = $vew_lang->attentioncenter;
	
	/* modulo y programa */
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'DEL';
	
	/* libreria de estilos bootstrap */
	include_once('_library.frm');

	/* botones por vista */
	$vew_tbl['tmeL'] = array('pos'=>'L', 'per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'), 'id'=>'btntme', 'ttl'=>$vew_lang->schedule, 'icn'=>'fas fa-clock', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn','acc'=>'');
	$vew_tbl['tmeR'] = array('pos'=>'R', 'per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'), 'id'=>'btntme', 'ttl'=>$vew_lang->schedule, 'icn'=>'fas fa-clock', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn','acc'=>'');

	//var_dump($vew_data->adr);
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->delcod; ?><input type="hidden" id="delcod" name="delcod" value="<?= $vew_data->delcod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
            <div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->attentioncenter; ?>
               			<span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                    <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
                	</div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('delcodext', 'doccmt1x20', 	$vew_data->delcodext, $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('deltxt', 		'doccmt1x50', 	$vew_data->deltxt, 		$lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->type,				'input'=>gethtml('deltypcod', 'deltypcod_lst',$vew_data->deltypcod, $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 		'docsts', 			$vew_data->docsts, 		$lv_default) )); 
                  ?>
                </div>
              </div> <!-- card -->
            </div>
            <div class="col-md-6">
              <div class="card"><div class="card-header"><div class="card-title"><?= $vew_lang->comments; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->comments, 'input'=>gethtml('delcmt', 'doccmt40x5', $vew_data->delcmt, $lv_default) )); ?>
                </div>
              </div> <!-- card -->
            </div>
          </div>
          <!-- DIRECCION / CONTACTO -->
          <div class="row">
            <div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
            <div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
          </div>
        </div>
      </div>
		</div>
  </form>
	<script>
		$("#<?= $lv_sec; ?> #btntme").on("click",function(e){ e.preventDefault();
			var lv_pstdat = [{name:"delcod", value:"<?= $vew_data->delcod; ?>"}];
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
<?php
	// url del formulario
  $lv_lnk = "?prg=buysup&prm_supcod=".$vew_data->supcod;

	// campos requeridos
	$vew_input->RequiredFields( array('suptxt','docsts','lndcod') );

	// clave del documento
	$lv_dockey = $vew_data->supcod;

	// titulo
	$lv_title = $vew_lang->supplier;

	// modulo y programa
	$lv_mdlcod = 'BUY';
	$lv_prgcod = 'SUP';

	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>  

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
				<?php if ($vew_data->supcod!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','**') ) { ?>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab005" role="tab" data-toggle="tab"><?= $vew_lang->contact; ?></a></li>
				<?php } ?>
				<li class="pull-right"><h4># <strong><?= $vew_data->supcod; ?><?= gethtml('supcod','hidden',$vew_data->supcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
            <!-- proveedor -->
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->supplier; ?>
                    <span class="tmss-card-icon">
                    	<?php if ( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'32') && $vew_readonly) { ?>
                      	<a href="#" id="btnsysdocclschg" class="cursor:pointer"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></a>
                      <?php } else { ?>
                      	<span><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                      <?php } ?>
                    </span>
                    <?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col210, array("label"=>$vew_lang->code, 	'input'=>gethtml('supcodext', 'doccod', $vew_data->supcodext, $lv_default) ));
										echo vew_boot($lv_col210, array("label"=>$vew_lang->name,		'input'=>gethtml('suptxt', 'doccmt1x50', $vew_data->suptxt, $lv_default) ));
										echo vew_boot($lv_col210, array("label"=>$vew_lang->status,	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
                </div>
              </div>
						</div> <!-- /proveedor -->
            <!-- compras -->
						<div class="col-md-6">
							<div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->buy; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->paymentstermshort, 'input'=>vew_boot(array('style'=>'search','readonly'=>$vew_readonly), array('input'=>gethtml('paytrmtxt', 'doccmt1x50', $vew_data->paytrmtxt, $lv_default) )) ));
                    echo gethtml('paytrmcod','hidden',$vew_data->paytrmcod);
                  	echo vew_boot(array($lv_colsm210, $lv_colxs48), array('label'=>'One-time', 'input'=>gethtml('buysuponetme', 'checkbox', $vew_data->buysuponetme, $lv_default) )); 
                  ?>
                </div>
              </div>
						</div> <!-- /compras -->
					</div> <!-- /row -->

          <!-- DIRECCION / CONTACTO -->
					<div class="row">
						<div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
						<div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
					</div>
				</div> <!-- /_tab001 -->

				<!-- IMPUESTOS / BANCOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
					<div class="row">
						<div class="col-md-6"><?php include('grldattax.frm'); ?></div>
						<div class="col-md-6"><?php include('grldatbnk.frm'); ?></div>
					</div>
					<div class="row">
						<div class="col-md-6">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= 'Contabilidad Acreedora'; ?></div></div>
								<?php include('grldatacc.frm'); ?>
							</div>
						</div>
					</div>
				</div> <!-- /_tab003 -->

				<!-- CONTACTOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab005">
          <?php include('grldatcntlst.frm'); ?>
				</div> <!-- /_tab005 -->

			</div> <!-- /tab-content -->
		</div> <!-- /container-fluid -->
  </form>
	<script>
    // paytrmtxt - typeahead
		var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"docsts":"A", "paytrmgrp":"(in)A;DA"}, "fldasg" : {"paytrmtxt" : "paytrmtxt", "paytrmcod" : "paytrmcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #paytrmtxt"), "finpaytrm", lo_get);
    
    $("#<?= $lv_sec; ?> #btnsysdocclschg").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm("¿ Desea cambiar la clase de documento ?", function(result){
        if(result) { <?= $lv_sec; ?>_fnc({action: '33'}); }
      });
		});
	</script>
 
  <?php include('grldocfrmscr.frm'); ?>
</section>
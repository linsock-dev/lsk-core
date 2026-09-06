<?php
	// url del formulario
  $lv_lnk = '?prg=slscus&prm_cuscod='.$vew_data->cuscod;

	// campos requeridos
	//$vew_input->RequiredFields( array('custxt','docsts','lndcod') );
	$lv_reqflddef = array('custxt','docsts','lndcod');
	$lv_reqfldusrtxt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'sysdocclsreqfld');
	$lv_reqfldusr = ($lv_reqfldusrtxt!=''?explode(';',$lv_reqfldusrtxt):array());
	$vew_input->setReqFields( array_merge($lv_reqflddef,$lv_reqfldusr) );

	// clave del documento
	$lv_dockey = $vew_data->cuscod;

	// titulo
	$lv_title = $vew_lang->customer;

	// modulo y programa
	$lv_mdlcod = 'SLS';
	$lv_prgcod = 'CUS';

	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
				<?php if ($vew_data->cuscod!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','**') ) { ?>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab005" role="tab" data-toggle="tab"><?= $vew_lang->contact; ?></a></li>
				<?php } ?>
				<li class="pull-right"><h4># <strong><?= $vew_data->cuscod; ?><?= gethtml('cuscod', 'hidden', $vew_data->cuscod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <!-- GENERAL -->
					<div class="row">
						<div class="col-md-6">
							<div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $vew_lang->customer; ?>
										<span class="tmss-card-icon">
                      <?php if ( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'32') && $vew_readonly) { ?>
                      	<a href="#" id="btnsysdocclschg" class="cursor:pointer"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></a>
                      <?php } else { ?>
                      	<span><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                      <?php } ?>
										</span>
                    <?php 
                      echo gethtml('sysdocclstxt', 'hidden', $vew_data->sysdoccls->sysdocclstxt);
                      echo gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);
                    ?>
									</div>
								</div>   
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,		'input'=>gethtml('cuscodext','doccmt1x20', $vew_data->cuscodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->name,		'input'=>gethtml('custxt', 'doccmt1x150', $vew_data->custxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div> <!-- card -->
            </div> <!-- col -->
            
            <!-- VENTAS -->
						<div class="col-md-6">
							<div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->sales; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->PriceList, 'input'=>vew_boot(array('style'=>'search','readonly'=>$vew_readonly), array('input'=>gethtml('slsprclsttxt', 'doccmt1x50', $vew_data->slsprclsttxt, $lv_default) )) ));
                    echo gethtml('slsprclstcod', 'hidden', $vew_data->slsprclstcod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->paymentstermshort, 'input'=>vew_boot(array('style'=>'search','readonly'=>$vew_readonly), array('input'=>gethtml('paytrmtxt', 'doccmt1x50', $vew_data->paytrmtxt, $lv_default) )) ));
                    echo gethtml('paytrmcod', 'hidden', $vew_data->paytrmcod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->salesgroup, 'input'=>vew_boot(array('style'=>'search','readonly'=>$vew_readonly), array('input'=>gethtml('slsgrptxt', 'doccmt1x50', $vew_data->slsgrptxt, $lv_default) )) ));
                  	echo gethtml('slsgrpcod', 'hidden', $vew_data->slsgrpcod);
                  ?>
                </div>
              </div> <!-- card -->
            </div> <!-- col -->
          </div> <!-- row -->                 
              
					<!-- DIRECCION / CONTACTO -->
					<div class="row">
						<div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
						<div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
					</div>
				</div>

				<!-- IMPUESTOS / BANCOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
					<div class="row">
						<div class="col-md-6">
              <?php include('grldattax.frm'); ?>
              <!-- CONTABILIDAD DEUDORA -->
              <div class="card"> 
								<div class="card-header"><div class="card-title"><?= 'Contabilidad Deudora'; ?></div></div>
								<?php include('grldatacc.frm'); ?>
              </div>
            </div>
						<div class="col-md-6"><?php include('grldatbnk.frm'); ?></div>
					</div>
        </div>

				<!-- CONTACTOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab005">
					<?php include('grldatcntlst.frm'); ?>
				</div>

			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		// slsprclsttxt - typeahead
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"p.docsts":"A"}, "fldasg":{"slsprclstcod":"slsprclstcod", "slsprclsttxt":"slsprclsttxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #slsprclsttxt"), "slsprc", lo_get)

    // paytrmtxt - typeahead
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"docsts":"A", "paytrmgrp":"(in)D;DA"}, "fldasg":{"paytrmcod":"paytrmcod", "paytrmtxt":"paytrmtxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #paytrmtxt"), "finpaytrm", lo_get) 

    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"sg.docsts":"A"}, "fldasg":{"slsgrpcod":"slsgrpcod", "slsgrptxt":"slsgrptxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #slsgrptxt"), "slsgrp", lo_get)

		$("#<?= $lv_sec; ?> #btnsysdocclschg").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm("Desea cambiar la clase de documento ?", function(result){
        if(result) { 
					var lv_pstdat = [{name:"cuscod",value:$("#<?= $lv_sec; ?> #cuscod").prop("value")},
													{name:"callback", value:"<?= $lv_sec; ?>_sysdoccls_callback"}];
					tmssLink("?prg=slscus&act=33", [{target: "_new_section", target_id: "#<?= $lv_sec; ?>", post_data: lv_pstdat}]);
				}
      });
		});
		
		function <?= $lv_sec; ?>_sysdoccls_callback(){
			<?= $lv_sec; ?>_fnc({action: '99'});
		}
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
      // al grabar
			if ( lp_prm["action"]=="00" ) {
				if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adreml")) ) { return false; }
				if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adrwebpge")) ) { return false; }

				// valido nro de CBU
				var lo_cbu = $("#<?= $lv_sec; ?> #bnkacccbu");
				if ( $(lo_cbu).prop("value").length > 0 && $(lo_cbu).prop("value").length!=22 ) {
					$(lo_cbu).parentsUntil(".tmss-form-group").parent().addClass("has-error");
					toastr.options.timeOut= 2000;
					toastr.warning( "El nro de CBU debe tener 22 d&iacute;gitos." );
					return false;
				} else {
					$(lo_cbu).parentsUntil(".tmss-form-group").parent().removeClass("has-error");
				}
			}
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
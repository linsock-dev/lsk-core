<?php
	/* url del formulario */
  $lv_lnk = '?prg=slsgrp&prm_slsgrpcod='.$vew_data->slsgrpcod;

	/* campos requeridos */
	//$vew_input->RequiredFields( array('slsgrptxt','docsts','lndcod') );
	$lv_reqflddef = array('slsgrptxt','docsts','lndcod');
	$lv_reqfldusrtxt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'sysdocclsreqfld');
	$lv_reqfldusr = ($lv_reqfldusrtxt!=''?explode(';',$lv_reqfldusrtxt):array());
	$vew_input->setReqFields( array_merge($lv_reqflddef,$lv_reqfldusr) );
	
	/* clave del documento */
	$lv_dockey = $vew_data->slsgrpcod; 

	/* titulo */
	$lv_title = $vew_lang->salesgroup;
	
	/* módulo y programa */
	$lv_mdlcod = 'SLS';
	$lv_prgcod = 'GRP';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!--navbar-->
  <?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
        <?php if( $vew_actcod != '01' ){ ?>
        	<li role="presentation"><a href="#<?= $lv_sec; ?>_tab005" role="tab" data-toggle="tab"><?= $vew_lang->contact; ?></a></li>
				<?php } ?>
        <?php if ($vew_data->slsgrpcod!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','**') ) { ?>
					<li role="presentation"><a href="#<?= $lv_sec; ?>_tab005" role="tab" data-toggle="tab"><?= $vew_lang->contact; ?></a></li>
				<?php } ?>
				<li class="pull-right"><h4># <strong><?= $vew_data->slsgrpcod; ?><?= gethtml('slsgrpcod', 'hidden', $vew_data->slsgrpcod) ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
			
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <!-- GENERAL -->
					<div class="row">
						<div class="col-md-6">
              <div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $vew_lang->salesgroup; ?>
										<span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                    <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);?>
									</div>
								</div>
                
                <div class="card-body tmss-card-body-edit">
                <?php 
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('slsgrpcodext','slsgrptxt', $vew_data->slsgrpcodext, $lv_default) )); 
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('slsgrptxt', 'slsgrptxt', $vew_data->slsgrptxt, $lv_default) )); 
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); 
                ?>
                </div>
              </div>
            </div>
          </div>
            
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
						</div>
						<div class="col-md-6">
							<?php include('grldatbnk.frm'); ?>
						</div>
					</div>
				</div>								
				
				<!-- CONTACTOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab005">
          <?php include('grldatcntlst.frm'); ?>
				</div>

			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
    
  </form>
	<script>
		// slsprclsttxt - typeahead
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"docsts" : "A", }, "fldasg" : {"slsprclsttxt" : "slsprclsttxt", "slsprclstcod" : "slsprclstcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #slsprclsttxt"), "slsprc", lo_get);

    // paytrmtxt - typeahead
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"docsts" : "A", "paytrmgrp": "(like)D"}, "fldasg" : {"paytrmtxt" : "paytrmtxt", "paytrmcod" : "paytrmcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #paytrmtxt"), "finpaytrm", lo_get);
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
					toastr.warning( "El nro de CBU debe tener 22 dígitos." );
					return false;						
				} else {
					$(lo_cbu).parentsUntil(".tmss-form-group").parent().removeClass("has-error");
				}
			}
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
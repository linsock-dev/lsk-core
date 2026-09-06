<?php
	// url del formulario
  $lv_lnk = '?prg=hhrlictyp&prm_hhrlictypcod='.$vew_data->hhrlictypcod;

	// campos requeridos
	$vew_input->RequiredFields( array('hhrlictyptxt','hhrlictyprem','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->hhrlictypcod;

	// titulo
	$lv_title = $vew_lang->licencetypes;
	
	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'LIT';
	
	// Libreria de estilos bootstrap
  include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>    
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hhrlictypcod; ?><?= gethtml('hhrlictypcod','hidden',$vew_data->hhrlictypcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 		'input'=>gethtml('hhrlictypcodext', 'doccodext', $vew_data->hhrlictypcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hhrlictyptxt', 'doccmt1x50', $vew_data->hhrlictyptxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
						    </div>
              </div><!-- /card -->
            </div><!-- /col-md-6 -->
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->attributes; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo gethtml('hhrlictypatr','hidden',$vew_data->hhrlictypatr);
                    echo vew_boot( array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->remunerative,	'input'=>gethtml('hhrlictypatrrem', 'checkbox', $vew_doc->getTagValue($vew_data->hhrlictypatr,'rem'), 	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->icon.' <i class="'.strtolower($vew_doc->gettagvalue($vew_data->hhrlictypatr,'icn')).'"></i>','input'=>gethtml('hhrlictypatricn', 'doccmt1x50', $vew_doc->gettagvalue($vew_data->hhrlictypatr,'icn'), $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->selfmanagement,'input'=>gethtml('hhrlictypatrautges', 'checkbox', $vew_doc->gettagvalue($vew_data->hhrlictypatr,'autges'), $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>'Dias Preaviso','input'=>gethtml('hhrlictypatrprv', 'docnum0300', $vew_doc->gettagvalue($vew_data->hhrlictypatr,'prv'), $lv_default) ));
                  ?>								
								</div>
							</div>
						</div><!-- /col-md-6 -->
					</div><!-- /row -->
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm) {
      if (lp_prm["action"] == "00") {

        const hhrlictypatrrem = $("#<?= $lv_sec; ?> #hhrlictypatrrem").val();
        const hhrlictypatrautges = $("#<?= $lv_sec; ?> #hhrlictypatrautges").val();

        $("#<?= $lv_sec; ?> #hhrlictypatr").prop(
          "value",
          '<rem>' + ((hhrlictypatrrem == "on" || hhrlictypatrrem == "1") ? '1' : '0') + '</rem>' +
          '<icn>' + $("#<?= $lv_sec; ?> #hhrlictypatricn").val() + '</icn>' +
          '<autges>' + ((hhrlictypatrautges == "on" || hhrlictypatrautges == "1") ? '1' : '0') + '</autges>' +
          '<prv>' + $("#<?= $lv_sec; ?> #hhrlictypatrprv").val() + '</prv>'
        );
      }
    }
  </script>
 <?php include('grldocfrmscr.frm'); ?>
</section>
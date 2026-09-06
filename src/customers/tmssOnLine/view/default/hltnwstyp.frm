<?php 
	/* url del formulario */
  $lv_lnk = '?prg=hltnwstyp&prm_hltnwstypcod='.$vew_data->hltnwstypcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('hltnwstyptxt','buyexptyptxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->hltnwstypcod; 

	/* titulo */
	$lv_title = $vew_lang->newstype;
	
	/* módulo y programa */
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'NWS';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hltnwstypcod; ?><input type="hidden" id="hltnwstypcod" name="hltnwstypcod" value="<?= $vew_data->hltnwstypcod; ?>"></strong></h4></li>
      </ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->news; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('hltnwstypcodext', 'doccmt1x20', $vew_data->hltnwstypcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hltnwstyptxt', 'doccmt1x50', $vew_data->hltnwstyptxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->type,
                                                    'input1'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                       array('input'=>gethtml('buyexptyptxt', 'typeahead', $vew_data->buyexptyptxt, $lv_default) )) ));
                  	echo gethtml('buyexptypcod', 'hidden', $vew_data->buyexptypcod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div> <!-- /body -->
              </div> <!-- /card -->
            </div>
          </div>
				</div> <!-- /_tab001 -->

			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <script>
    // tipo
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"buyexptypcod":"buyexptypcod", "buyexptyptxt":"buyexptyptxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #buyexptyptxt"), "buyexptyp", lo_get);
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
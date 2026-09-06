<?php
	/* url del formulario */
  $lv_lnk = '?prg=hltpatdia&prm_patdiacod='.$vew_data->patdiacod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('patdiatxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->patdiacod;

	/* titulo */
	$lv_title = $vew_lang->diagnostic;
	
	/* m�dulo y programa */
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'DIA';
	
	/* librer�a de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->patdiacod; ?><input type="hidden" id="patdiacod" name="patdiacod" value="<?= $vew_data->patdiacod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="col-sm-6">
            <div class="card">
              <div class="card-header"><div class="card-title"><?= $vew_lang->DiagnosticCodes; ?></div></div>
              <div class="card-body tmss-card-body-edit">
              	<?php 
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 		'input'=>gethtml('patdiacodext', 'doccodext', $vew_data->patdiacodext, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('patdiatxt', 'patdiatxt', $vew_data->patdiatxt, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                ?>
              </div> <!-- /body -->
          	</div> <!-- /card -->
          </div>
				</div> <!-- /_tab001 -->
			
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
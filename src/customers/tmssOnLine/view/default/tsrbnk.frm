<?php
	/* url del formulario */
  $lv_lnk = "?prg=tsrbnk&prm_bnkcod=".$vew_data->bnkcod;

	/* campos requeridos */
	//$vew_input->RequiredFields( array('custxt','docsts','lndcod') );
	$lv_reqflddef = array('custxt','docsts','lndcod');
	$lv_reqfldusrtxt = $vew_doc->getTagValue($vew_data->sysdoccls,'sysdocclsreqfld');
	$lv_reqfldusr = ($lv_reqfldusrtxt!=''?explode(';',$lv_reqfldusrtxt):array());
	$vew_input->setReqFields( array_merge($lv_reqflddef,$lv_reqfldusr) );	

	/* clave del documento */
	$lv_dockey = $vew_data->bnkcod;

	/* titulo */
	$lv_title = $vew_lang->bank;

	/* m�dulo y programa */
	$lv_mdlcod = 'TSR';
	$lv_prgcod = 'BNK';

	/* librer�a de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  
  <!-- Nav-bar -->
	<?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
        <li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->bnkcod; ?><?= gethtml('bnkcod', 'hidden', $vew_data->bnkcod); ?></strong></h4></li>
			</ul>	
			<div class="tab-content tmss-tab-content">
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
           	<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->bank; ?></div></div>
								<div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('bnkcodext','bnkcod', $vew_data->bnkcodext, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('bnktxt', 'bnktxt', $vew_data->bnktxt, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
          	<div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
          </div>
        </div> <!-- fin_tab001 -->
        <!-- Finanzas -->
        <div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<div class="row">
						<div class="col-md-6">
							<?php include('grldattax.frm'); ?>
            </div>
          </div>  
        </div> <!-- fin _tab002 -->
			</div> <!-- tabcontent -->
  	</div> <!-- container-fluid -->
	</form>
	<?php include('grldocfrmscr.frm'); ?>
</section>
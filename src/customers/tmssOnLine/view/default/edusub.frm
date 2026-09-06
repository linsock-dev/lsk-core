<?php		
	// url del formulario
  $lv_lnk = '?prg=edusub&prm_edusubcod='.$vew_data->edusubcod;

	// campos requeridos
	$vew_input->RequiredFields( array('edusubtxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->edusubcod;

	// titulo
	$lv_title = $vew_lang->subject;
	
	// módulo y programa
	$lv_mdlcod = 'EDU';
	$lv_prgcod = 'SUB';
	
	// librería de estilos
  include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml( 'tmss_actcod' , 'hidden', '' ); ?>
		   
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->edusubcod; ?><?= gethtml( 'edusubcod' , 'hidden', $vew_data->edusubcod ); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">			
          <div class="row">
						<div class="col-md-6">
						
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('edusubcodext', 'doccodext', $vew_data->edusubcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('edusubtxt', 'doccmt1x50', $vew_data->edusubtxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->form,				'input'=>gethtml('eduevlfrm', 'doccmt1x250', $vew_data->eduevlfrm, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->order,			'input'=>gethtml('edusubord', 'docnum0300', $vew_doc->getTagValue($vew_data->edusubatr,'subord'), $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div> 
							
            </div>
          </div>  
				</div> <!-- /tab-panel -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <?php include('grldocfrmscr.frm'); ?>
</section>
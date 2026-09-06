<?php
	/* url del formulario */
  $lv_lnk = '?prg=cnstskcls&prm_cnstskclscod='.$vew_data->cnstskclscod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('cnstskclstxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->cnstskclscod; 

	/* titulo */
	$lv_title = $vew_lang->tasksClass;
	
	/* módulo y programa */
	$lv_mdlcod = 'CNS';
	$lv_prgcod = 'TSC';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <!-- Navbar -->
	 <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->cnstskclscod; ?><input type="hidden" id="cnstskclscod" name="cnstskclscod" value="<?= $vew_data->cnstskclscod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="rows">
						<div class="col-md-6">
             <div class="card">
              <div class="card-header">
                <div class="card-title"><?= $lv_title; ?></div>
              </div>
              <div class="card-body tmss-card-body-edit"> 
                <?php
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 				'input'=>gethtml('cnstskclscodext',		'doccmt1x20',		$vew_data->cnstskclscodext, $lv_default) )); 
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->description,	'input'=>gethtml('cnstskclstxt',			'doccmt1x50',$vew_data->cnstskclstxt, $lv_default) )); 
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->status,				'input'=>gethtml('docsts', 						'docsts', 			$vew_data->docsts, 		$lv_default) )); 
                ?>
              </div>
             </div> 
						</div>
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->registry; ?></div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <div class="form-group tmss-form-group">
                    <?php echo vew_boot( array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->assistance,  'input'=>gethtml('cnstskclsatrregass', 'checkbox', $vew_doc->getTagValue($vew_data->cnstskclsatr, 'regass'),     $lv_default)   )); ?>
                  </div>
                  <div class="form-group tmss-form-group">                    
                    <?php echo vew_boot( array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->progress,  	'input'=>gethtml('cnstskclsatrregprg', 'checkbox', $vew_doc->getTagValue($vew_data->cnstskclsatr, 'regprg'),     $lv_default)   )); ?>
                  </div>
                </div>
						  </div> 
						</div>
					</div>
				</div>
			</div> <!-- tabcontent -->    
		</div> <!-- /container-fluid -->
  </form>
  <!-- Include del script-->
  <?php include('grldocfrmscr.frm');?>
</section>
<?php
	// url del formulario
  $lv_lnk = '?prg=hhrmedcov&prm_hhrmedcovcod='.$vew_data->hhrmedcovcod;

	// campos requeridos
	$vew_input->RequiredFields( array('hhrmedcovtxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->hhrmedcovcod;

	// titulo
	$lv_title = $vew_lang->medicalcoverage;
	
	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'MEC';
   
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

	<!-- Nav-bar -->
	<?php include('grldocfrmtlb.frm'); ?>
	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		    
		<div class="container-fluid" role="tabpanel">
			<!-- Solapas -->
      <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
    		<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li><li class="pull-right"><h4># <strong><?= $vew_data->hhrmedcovcod; ?><?= gethtml('hhrmedcovcod','hidden',$vew_data->hhrmedcovcod); ?></strong></h4></li>
      </ul>
			<div class="tab-content tmss-tab-content">
    		<!-- COB MEDICA / DIRECCION -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
     					<div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                    <span class="tmss-card-icon"><span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span></span>
										<?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod);?>
        					</div>
      				  </div>
      					<div class="card-body tmss-card-body-edit">
			 						<?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 		'input'=>gethtml('hhrmedcovcodext', 'doccodext', $vew_data->hhrmedcovcodext, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hhrmedcovtxt', 'doccmt1x400', $vew_data->hhrmedcovtxt, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->initials,	'input'=>gethtml('hhrmedcovtxtsht', 'doccmt1x20', $vew_data->hhrmedcovtxtsht, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
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
    		</div> <!-- fin_tab001 -->
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
    		</div> <!-- fin_tab003 -->
	 		</div> <!-- tabcontent -->
  	</div> <!-- container-fluid -->
	</form>
	<?php include('grldocfrmscr.frm'); ?>
</section>
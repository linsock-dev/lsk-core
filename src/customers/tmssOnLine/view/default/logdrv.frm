<?php		
	/* url del formulario */
  $lv_lnk = "?prg=logdrv&prm_drvcod=".$vew_data->drvcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('drvtxt','docsts','lndcod') );

	/* clave del documento */
	$lv_dockey = $vew_data->drvcod; 

	/* titulo */
	$lv_title = $vew_lang->driver;
	
	/* m�dulo y programa */
	$lv_mdlcod = 'LOG';
	$lv_prgcod = 'DRV';
	
  /* librer�a de estilos bootstrap */
  include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

   <!-- Navbar -->
	 <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
				<?php
        if ($vew_data->drvcod!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','**') ) { ?>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab005" role="tab" data-toggle="tab"><?= $vew_lang->contact; ?></a></li>
				<?php } ?>
				<li class="pull-right"><h4># <strong><?= $vew_data->drvcod; ?><?= gethtml('drvcod','hidden',$vew_data->drvcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
        
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row"> 
             
            <!-- CHOFER -->
						<div class="col-md-4">       
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                    <span class="tmss-card-icon">
                      <?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?>
                    </span>
                    <input type="hidden" id="sysdocclscod" name="sysdocclscod" value="<?= $vew_data->sysdoccls->sysdocclscod; ?>">
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">                                    
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,	'input'=>gethtml('drvcodext','doccmt1x20', $vew_data->drvcodext,$lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->name, 'input'=>gethtml('drvtxt', 'doccmt1x50', $vew_data->drvtxt,$lv_default) ));              	
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts,$lv_default) )); 
                  ?>
                </div>
              </div>                            
						</div>
            <div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab006">
            <div class="col-md-4">
              <div id="tchprfhot" name="tchprfhot"></div>
                <div class="card">
                    <div class="card-header">
                      <div class="card-title"><?= $vew_lang->profile; ?></div>
                    </div>
                    <div class="card-body tmss-card-body-edit"> 
                      <?php
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->nik, 'input'=>gethtml('drvniknme', 'doccmt1x20', $vew_data->drvniknme,$lv_default) ));    
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->entrance, 'input'=>gethtml('drvinbdte', 'docdte', $vew_data->drvinbdte,$lv_default) ));                                                   
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->debit, 'input'=>gethtml('drvoutdte', 'docdte', $vew_data->drvoutdte,$lv_default) ));                                              
                      ?>
                    </div>
                </div>
            </div>
          </div>       
            
            <!-- DATOS PERSONALES -->
						<div class="col-md-4">
							<?php include('grldatper.frm'); ?>
            </div>          
					</div>	
          
          <!-- DIRECCION / CONTACTO --> 
          <div class="row">
            <div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
            <div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
          </div>
			</div> <!-- fin tab001 -->	
        
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
  <!-- include del script -->
  <?php include('grldocfrmscr.frm'); ?>		
</section>
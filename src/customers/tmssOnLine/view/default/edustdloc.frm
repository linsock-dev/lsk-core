<?php		
	// url del formulario
  $lv_lnk = '?prg=edustdloc&prm_stdloccod='.$vew_data->stdloccod;

	// campos requeridos
	$vew_input->RequiredFields( array('stdloctxt','docsts','lndcod') );

	// clave del documento
	$lv_dockey = $vew_data->stdloccod; 

	// titulo
	$lv_title = $vew_lang->educationcenter;
	
	// módulo y programa
	$lv_mdlcod = 'EDU';
	$lv_prgcod = 'STL';
	
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
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->stdloccod; ?><?= gethtml( 'stdloccod' , 'hidden', $vew_data->stdloccod ); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<!-- Tarjeta -->
          <div class="row">
						<div class="col-md-6">
						
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                    <span class="tmss-card-icon">
                      <?= ucfirst(strtolower($vew_data->sysdocclstxt)); ?>
											<?= gethtml('sysdocclscod','hidden', $vew_data->sysdocclscod); ?>
                    </span>                    
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('stdloccodext','doccmt1x20', $vew_data->stdloccodext, $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('stdloctxt', 	'doccmt1x50', $vew_data->stdloctxt, $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 			'docsts', 		$vew_data->docsts, $lv_default) ));                   	
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
          
				</div> <!-- /tab-panel -->
				
        <!-- IMPUESTOS / BANCOS -->
        <div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
        	<div class="row">
          	<div class="col-md-6"><?php include('grldattax.frm'); ?></div>
            <div class="col-md-6"><?php include('grldatbnk.frm'); ?></div>
          </div>
        </div> <!-- /tab-panel -->
				
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <script>	
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {					
				if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adreml")) ) { return false; }
				if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adrwebpge")) ) { return false; }
			}	
    }
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
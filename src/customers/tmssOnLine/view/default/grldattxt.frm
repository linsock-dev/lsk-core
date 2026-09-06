<?php
	// url del formulario
  $lv_lnk = "?prg=grldattxt&prm_txtcod=".$vew_data->txtcod;

	// campos requeridos
	$vew_input->RequiredFields( array('lngcod','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->txtcod; 

	// titulo
	$lv_title = $vew_lang->texts;
	
	// m?dulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'TXT';
	
	// librer?a de estilos bootstrap
	include_once('_library.frm');

	$lv_sysarr = array('1'=>$vew_lang->user, '0'=>$vew_lang->system);
	if($vew_data->txtcod==''){
  	if( !$vew_sec->hasPermission('SYS','TXT','05') ){
      unset($lv_sysarr['0']);
    }  
  } else {
    unset($lv_sysarr[$vew_data->txtsys=='1'?'0':'1']);
  }

	if( $vew_sec->hasPermission('SYS','TXT','05')  && $vew_data->txtcod!==''){
    
  }
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('txtsrctyp','hidden',($vew_data->txtcod==''?'**':$vew_data->txtsrctyp)); ?>
    <?= gethtml('txtsrccod','hidden',($vew_data->txtcod==''?'**':$vew_data->txtsrccod)); ?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->txtcod; ?><?= gethtml('txtcod','hidden', $vew_data->txtcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
						
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-4">
              <div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->text; ?></div>
								</div>
								<div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('txtcodext', 'doccmt1x20', $vew_data->txtcodext,	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('txtdes', 'doccmt1x50', $vew_data->txtdes,	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->language, 'input'=>gethtml('lngcod', 'lngcod', $vew_data->lngcod, $lv_default) ));
                    echo '<div'.($vew_sec->hasPermission('SYS','TXT','05') ? '' : ' class="hidden"').'>';
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->system, 'input'=>gethtml('txtsys', $lv_sysarr , $vew_data->txtsys, ($vew_data->txtcod==''?$lv_default:$lv_always_disabled) )));
                    echo '</div>';
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
								</div>
							</div>
						</div>
						<div class="col-md-8">                      
							<textarea id="<?= $lv_sec; ?>_txttxt" name="txttxt"><?= utf8_encode($vew_data->txttxt); ?></textarea>
						</div>
					</div>
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->    
  </form>
	<script>
		tmssLoadScript("tinymce",function(){
			tinyMCE.init({
        selector: '#<?= $lv_sec; ?> textarea',
        plugins: 'anchor autolink charmap codesample emoticons image link lists media searchreplace table visualblocks wordcount paste fullpage',
        toolbar: 'undo redo | blocks fontfamily fontsize | bold italic underline strikethrough | link image media table | align lineheight | numlist bullist indent outdent | emoticons charmap | removeformat',
				extended_valid_elements:"style,link[href|rel]",
				custom_elements:"style,~link",
				height: 440,
				paste_data_images: true
				<?= ($vew_readonly?', menubar: false':''); ?>
				<?= ($vew_readonly?', toolbar: false':''); ?>
				<?= ($vew_readonly?', readonly: 1':''); ?>
			});
		});
	</script>
	<script>
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				// actualizo textarea de los editores
        tinyMCE.triggerSave();
			}
    }
	</script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
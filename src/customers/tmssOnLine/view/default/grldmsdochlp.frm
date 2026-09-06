<?php
	// url del formulario
  $lv_lnk = '?prg=grldmsdoc&act=hlp';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = $vew_data->finaccplncod;

	// titulo
	$lv_title = $vew_lang->documents;
	
	// módulo y programa
	$lv_mdlcod = 'GRL';
	$lv_prgcod = 'DMS';
	
	$vew_actcod= '02';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
	
	//$vew_tbl['sveL'] = array('per'=>false);
	//$vew_tbl['sveR'] = array('per'=>false);
	//$vew_tbl['canc'] = array('per'=>false);
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		
    <div class="container-fluid">
					
			<div class="card">
				<div class="card-header">
          <?= gethtml('grldmsdochlptxt', 'doccmt1x250', $vew_data->prgord, $lv_default); ?>
				</div>
				<div class="card-body">
          <div class="input-group">
            <label class="control-label"><?= $vew_lang->content; ?></label>
          	<textarea id="grldmsdochlptxt" class="form-control"></textarea>
          </div>
				</div>
			</div>
			
		</div> <!-- /container-fluid -->
	</form>
	<script>
		tmssLoadScript("tinymce", function(){
			// editores de texto			
			tinyMCE.init({ 
				selector: "#<?= $lv_sec; ?> textarea", 
				paste_data_images: true,
				height: 300, 
				menubar: true
				<?= ($vew_readonly?', readonly: 1':''); ?>
			});
		});
		
		// form submit ext
		function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// actualizo textareas de los editores
			tinyMCE.triggerSave();
			/*
			// Get tree info
			var ref = $("#<?= $lv_sec; ?> #fldtrediv").jstree(true);
			var tree = ref.get_json();
			var lv_arr = new Array();
			<?= $lv_sec; ?>_getaccfromtree( tree[0], '', lv_arr );

			// Add deleted nodes
			for (var i=0; i < <?= $lv_sec; ?>_accdel.length; i++) {
				lv_arr.push(<?= $lv_sec; ?>_accdel[i]);
			}

			if (lv_arr.length==0) {
				$("#<?= $lv_sec; ?> #finaccplnacc").prop("value", "");
			} else {
				$("#<?= $lv_sec; ?> #finaccplnacc").prop("value", JSON.stringify( lv_arr ) );
			}
			*/
		}
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
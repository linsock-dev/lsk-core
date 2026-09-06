<?php
	// url del formulario
  $lv_lnk = '?prg=sysobj';

	// campos requeridos
	$vew_input->RequiredFields( array('systracod','systratxt','srcbuscod','srcobjtyp','srcobjcod001', 'usrcod') );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->objects;

	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'OBJ';

	// librer?a de estilos bootstrap
	include_once('_library.frm');

	// validacion que depende si la vista de OT se visualiza desde el boton mover o desde el grabar
  $lv_hidden = false;
  if( $vew_data->systradat != null ){
    if($vew_data->systradat >= 0  ){
      $lv_hidden = true;
    }
  }else if( $vew_data->systraflg != null ){
    if($vew_data->systraflg == 'mvobj'){
      $lv_hidden = true;
    }
  }
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>" >
	<form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('sysobjcod','hidden',$vew_data->sysobjcod); ?>
    <?= gethtml('systraobjcod','hidden', $vew_data->systraobjcod); ?>

		<div class="container-fluid">
			<div class="row <?= (count($vew_data->systradat)==0?'hidden':'') ?>" id="divsystraobj">
        <div class="row" style="/*padding-left: 40px; margin-right: -15px;*/">
          <div class="col-sm-6">
             <?= vew_boot($lv_colsm48, array('label'=>$vew_lang->order, 'input'=>vew_boot(	array('style'=>'search', 'readonly'=>false), array('input'=>gethtml('systracod', 'doccmt1x50', $vew_data->systracod, $lv_always_disabled) )))); ?>
          </div>
          <div class="col-sm-6">
            <?= vew_boot($lv_colsm48, array('label'=>$vew_lang->user, 'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>false), array('input'=>gethtml('usrcod', 'typeahead', $vew_data->usrcod, $lv_always_disabled) )))); ?>
          </div>
        </div>
				<?php
					echo vew_boot($lv_colsm210, array('label'=>$vew_lang->title, 'input'=>gethtml('systratxt', 'doccmt1x50', $vew_data->systratxt, $lv_always_disabled) ));
					echo vew_boot($lv_colsm2433, array('label'=>$vew_lang->Source,
																						'input1'=>gethtml('srcbuscod', 'doccmt1x50', $vew_data->srcbuscod, $lv_always_disabled),
																						'input2'=>gethtml('srcobjtyp', 'doccmt1x50', $vew_data->srcobjtyp, $lv_always_disabled),
																						'input3'=>gethtml('srcobjcod001', 'doccmt1x50', $vew_data->srcobjcod001, $lv_always_disabled) ));
        ?>
			</div>
			<div class="row <?= (count($vew_data->systradat)>0?'hidden':'') ?>" id="divsystraobjmsg">
				<div class="col-xs-1 col-md-3"></div>
				<div class="col-xs-10 col-md-6">
					<h3>Sin orden</h3>
					<blockquote><p>No existen ordenes de transporte.</p></blockquote>
				</div>
				<div class="col-xs-1 col-md-3"></div>
			</div>
		</div>
	</form>
  <script>
    // pop up usr
		$("#<?= $lv_sec; ?>  #usrcod").next().children("a:first").on("click", function(e) { e.preventDefault();
			tmssPopup("<?= $vew_lang->user; ?>","?prg=syssecusr&act=08&prm_vewcod=VEW_SYS_USR_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldflt=[u.docsts:A]&prm_fldasg=[usrcod:usrcod]");
		});
  </script>
	<script>
		$("#<?= $lv_sec; ?>  #systracod").next().children("a:first").on("click", function(e) { e.preventDefault();
			tmssPopup("<?= $vew_lang->transportorder; ?>","?prg=systra&act=08&prm_vewcod=VEW_SYS_TRA_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldflt=[t.docsts:A]&prm_fldasg=[systracod:systracod],[systratxt:systratxt],[systracodext:systracodext],[srcbuscod:srcbuscod],[srcobjtyp:srcobjtyp],[srcobjcod001:srcobjcod001]");
		});

		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	</script>
</section>

<?php
	// url del formulario 
  $lv_lnk = '';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->documentclass;
	
	// modulo y programa
	$lv_mdlcod = '';
	$lv_prgcod = '';
	$lv_objtyp = '';
	
	// librer?a de estilos bootstrap
	include_once('_library.frm');
	
  $vew_tbl['canc'] = array ('css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled btn-danger', 'acc'=>$lv_sec.'_closeForm()');	
  $vew_tbl['clsR'] = array ('acc'=>$lv_sec.'_closeForm()');	
?>
<section id="<?= $lv_sec; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
  
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('sysdocclscod','hidden',''); ?>
		<?= gethtml('sysdocclstxt','hidden',''); ?>
		<?= gethtml('sysdocclssec','hidden',$lv_sec); ?>
		<?php if(isset($vew_data)){foreach($vew_data as $lv_key=>$lv_val){echo gethtml($lv_key,'hidden',$lv_val);}} ?>
		<div class="row">
			<div class="col-xs-1 col-md-3"></div>
			<div class="col-xs-10 col-md-6">
				<?php if ( count($vew_doccls)>=1 ) { ?>
					<h3>Seleccione la clase de documento:</h3>
					<div class="list-group">
						<?php foreach( $vew_doccls as $lv_row ) { ?>
						<a href="#" class="list-group-item" id="<?= $lv_row['sysdocclscod']; ?>"><?= $lv_row['sysdocclstxt']; ?></a>
						<?php } ?>
					</div>
				<?php } else { ?>
					<h3>Configuraci&oacute;n insuficiente</h3>
					<blockquote>
						<p>No hay definidas clases de documentos para este objeto.</p>
						<p>Consulte con el administrador del sistema.</p>
					</blockquote>
				<?php } ?>
			</div>
			<div class="col-xs-1 col-md-3"></div>
		</div>	
	</form>
  <script>
    function <?= $lv_sec; ?>_closeForm(){
      // al cancelar, si la vista esta sobre un dialog, cierro el dialogo actual
			if ( "<?= (isset($vew_data->lv_sec)?$vew_data->lv_sec:''); ?>"!="" ) {
				$.each(BootstrapDialog.dialogs, function(id, dialog){ 
          if(dialog.$modalBody.find("#<?= $lv_sec; ?>").length>0){
            dialog.close();
            return false;
        	}
        });
      } else {
        tmssTabSecCls( $("#<?= $lv_sec; ?>") ); 
      }
		}
    
    $("#<?= $lv_sec; ?> .list-group-item").click( function() {
			$("#<?= $lv_sec; ?> #sysdocclscod").prop("value",this.id);
			$("#<?= $lv_sec; ?> #sysdocclstxt").prop("value",this.text);
			var lv_dat = $("#<?= $lv_sec; ?>_frm").serializeArray();
			tmssLink('<?= $vew_url; ?>', [{target: '_replace_with', target_id: '#<?= $lv_sec; ?>', post_data: lv_dat}] );
    });
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
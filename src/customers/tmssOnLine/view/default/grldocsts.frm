<?php		
	// url del formulario 
  $lv_lnk = "?prg=grldocsts&act=03";

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->message;
	
	// módulo y programa 
	$lv_mdlcod = 'GRL';
	$lv_prgcod = 'DCS';

	// librería de estilos bootstrap 
	include_once('_library.frm');

	$vew_actcod = '02';
?>
<section id="<?= $lv_sec; ?>" class="table-responsive">

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">

		<div class="container-fluid">
		
			<table class="table table-condensed">
				<thead>
					<tr>
						<th><?= $vew_lang->document; ?></th>
						<th><?= $vew_lang->status; ?></th>
						<th><?= $vew_lang->treatment; ?></th>
						<th><?= $vew_lang->rejection; ?></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><?= $vew_dathdr['srcobjcod']; ?></td>
						<td><?= $vew_dathdr['docststxt']; ?></td>
						<td class="<?= ($vew_dathdr['sysdoctrecod']=='C'?'bg-success':($vew_dathdr['sysdoctrecod']=='P'?'bg-warning':'')); ?>"><?= $vew_dathdr['sysdoctretxt']; ?></td>
						<td class="<?= ($vew_dathdr['sysdocrejcod']!=''?'bg-danger':''); ?>"><?= $vew_dathdr['sysdocrejtxt']; ?></td>
					</tr>
				</tbody>
			</table>
			
			<table class="table table-condensed table-striped table-bordered table-hover">
				<thead>
					<tr>
						<th></th>
						<th><?= $vew_lang->material; ?></th>
						<th class="hidden-xs"><?= $vew_lang->description; ?></th>
						<th><?= $vew_lang->quantity; ?></th>
						<th><?= $vew_lang->treatment; ?></th>
					</tr>
				</thead>
				<tbody>
					<?php foreach($vew_datpos as $lv_row) { ?>
					<tr onclick="$(this).next().toggleClass('hidden');"><td><span class="fas fa-caret-right"></span></td><td><?= $lv_row['matcod']; ?><br><span class="visible-xs"><?= $lv_row['mattxt']; ?></span></td><td class="hidden-xs"><?= $lv_row['mattxt']; ?></td><td align="right"><?= $lv_row['matqty']; ?></td><td class="<?= ($lv_row['sysdoctrecod']=='C'?'bg-success':($lv_row['sysdocrejcod']!=''?'bg-info':($lv_row['sysdoctrecod']=='P'?'bg-warning':''))); ?>"><?= $lv_row['sysdoctretxt'] . ($lv_row['sysdocrejcod']!=''?' / Rechazado':''); ?></td></tr>
					<tr class="hidden"><td colspan="10"><?= ($lv_row['sysdocrejcod']!=''?'Rechazo: <span class="text-danger">'.$lv_row['sysdocrejtxt'].'</span><br>':''); ?>&nbsp;<!--Entrega: 10<br>Factura: 10--></td></tr>
					<?php } ?>					
				</tbody>
			</table>
					
		</div> <!-- /container-fluid -->
	</form>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $("#<?= $lv_sec; ?>_frm"), "<?= $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?> #btncls").eq(0) );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    });
		
		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {
				gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
				var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':'03'); ?>":gv_<?= $lv_sec; ?>_last_action);
				tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
			}
		}
		
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>
</section>
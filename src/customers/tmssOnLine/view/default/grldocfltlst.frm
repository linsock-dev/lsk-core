<?php		
	// url del formulario 
  $lv_lnk = "";

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->filter;
	
	// módulo y programa 
	$lv_mdlcod = '';
	$lv_prgcod = '';

	// librería de estilos bootstrap 
	include_once('_library.frm');

	$vew_actcod = '02';
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

		<table class="table table-condensed table-hover" id="vewflttbl">
			<thead><tr><th>Usuario</th><th>Filtro</th><th>Default</th><th></th></tr></thead>
			<tbody>
				<?php 
					foreach($vew_data as $lv_row) {
						echo '<tr data-vewfltcod="'.$lv_row['vewfltcod'].'" data-usrcod="'.$lv_row['usrcod'].'" data-vewfltedt="'.($lv_row['usrcod']==$vew_sec->usrcod?1:0).'" data-vewmaxrec=""><td><textarea class="hidden">'.$lv_row['vewfltdat'].'</textarea>'.$lv_row['usrcod'].'</td><td>'.$lv_row['vewflttxt'].'</td><td>'.($lv_row['vewfltdef']==1 && $lv_row['usrcod']==$vew_sec->usrcod?'<span class="fas fa-check"></span>':'').'</td><td>'.($lv_row['usrcod']==$vew_sec->usrcod?'<a href="#" name="btndel" data-vewfltcod="'.$lv_row['vewfltcod'].'" class="btn btn-danger"><span class="fas fa-trash"></span></a>':'').'</td></tr>';
					}
				?>
			</tbody>
		</table>

	<script>
		tmssLoadScript("toggle",function(){
			$("#<?= $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: "success", offstyle: "default", on: "Si", off: "No", size: "small" });
				$(this).trigger("change");
			});
		});		
	</script>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";
		
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	</script>
</section>
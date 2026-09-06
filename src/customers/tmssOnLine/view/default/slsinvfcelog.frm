<?php
	// url del formulario 
  $lv_lnk = '';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = ''; 

	// titulo 
	$lv_title = $vew_lang->log;
	
	// modulo y programa 
	$lv_mdlcod = 'SLS';
	$lv_prgcod = 'FCE';

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

	<table class="table table-bordered table-condensed">
		<thead>
			<tr><th>Fecha</th><th>Log</th></tr>
		</thead>
		<tbody>
			<?php
				foreach($vew_data->fcelog as $lv_row){
					$lv_buffer = '';
					if(isset($lv_row['applogtxt'])){
						$lv_logarr = json_decode( $lv_row['applogtxt'] );
						if($lv_logarr!=null){
							foreach( $lv_logarr as $lv_log ) {
								$lv_buffer .= '<div class="bg-'.($lv_log->errtyp=='E'?'danger':($lv_log->errtyp=='S'?'success':'warning')).'" style="padding-left: 10px; padding-right: 10px;">';
								$lv_buffer .= '<i class="fas fa-'.($lv_log->errtyp=='E'?'times':($lv_log->errtyp=='S'?'check text-success':'exclamation')).'"></i> ';
								$lv_buffer .= $lv_log->errcod.': '.$lv_log->errtxt.'<br>';
								$lv_buffer .= (isset($lv_log->errtxt002)?'<div style="padding: 10px;">'.json_encode($lv_log->errtxt002).'</div><br>':'');
								$lv_buffer .= '</div>';
							}
						} else {
							$lv_buffer = '<code>'.$lv_row['applogtxt'].'</code>';
						}
					}
					echo '<tr><td>'.$lv_row['ctedte']->format('d/m/Y H:i:s').'</td><td><small>'.$lv_buffer.'</small></td></tr>';
				}
			?>
		</tbody>
	</table>

</section>
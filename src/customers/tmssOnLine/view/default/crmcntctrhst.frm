<table class="table table-bordered table-hover">
	<thead><tr><th>Fecha</th><th>Tipo</th><th>Motivo</th><th>Titulo</th><th>Estado</th></tr></thead>
	<tbody>
		<?php
			unset( $vew_data['data_sqltxt']);
			unset( $vew_data['data_sqlprm']);
			unset( $vew_data['data_sqlstm']);
			if ( count($vew_data)==0 ) {
				echo '<tr><td colspan="5">No se encontraron entradas.</td></tr>';
			} else {
				$lv_buffer = '';
				foreach( $vew_data as $lv_row ) {
					$lv_buffer .= '<tr name="cnthstlst" data-crmcntcod="'.$lv_row['crmcntcod'].'"><td>'.date_format($lv_row['ctedte'],'d.m.Y').'</td><td>'.$lv_row['crmcnttyptxt'].'</td><td>'.$lv_row['crmcntmtvtxt'].'</td><td>'.$lv_row['crmcnttxt'].'</td><td>'.$lv_row['crmcntststxt'].'</td></tr>';
				}
				echo $lv_buffer;
			}
		?>
	</tbody>
</table>

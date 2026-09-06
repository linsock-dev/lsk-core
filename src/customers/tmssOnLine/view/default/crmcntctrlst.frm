<table class="table table-bordered table-hover">
	<tbody>
		<?php
			if ( count($vew_lst)==0 ) {
				echo '<tr><td>No se encontraron resultados.</td></tr>';
			} else {
				foreach( $vew_lst as $lv_row ) {
					echo '<tr>'.
								'<td name="cntobj" data-cntcod="'.$lv_row['datcod'].
																'" data-cntcodext="'.$lv_row['datcodext'].
																'" data-adrnme001="'.$lv_row['adrnme001'].
																'" data-adrphn001="'.$lv_row['adrphn001'].
																'" data-adrphn002="'.$lv_row['adrphn002'].
																'" data-adrmblphn="'.$lv_row['adrmblphn'].
																'" data-adreml="'.$lv_row['adreml'].
																'" data-taxdocnum="'.$lv_row['taxdocnum'].'">'.
								'<strong>'.$lv_row['adrnme001'].'</strong>'.
								'<small>'.
									'<br>ID: '.$lv_row['datcod'].
									($lv_row['datcodext']!=''?'<br>Código: '.$lv_row['datcodext']:'').
									($lv_row['taxdocnum']!=''?'<br># Identificación: '.$lv_row['taxdocnum']:'').
								'</small>'.
								'</td>'.
								'</tr>';
				}
			}
		?>
	</tbody>
</table>
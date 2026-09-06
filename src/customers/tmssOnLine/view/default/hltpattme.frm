<?php 
	if ($vew_data->msg!='') { 
		echo '<h4>'.$vew_data->msg.'</h4>'; 
	} else {
?>
<table class="table table-condensed">
	<thead>
		<tr>
			<th>Dias</th>
			<th>Horarios</th>
			<th>Comentarios</th>
		</tr>
	</thead>
	<tbody>
		<tr class="<?= $vew_tme['dom']['class']; ?>"><td>Dom</td><td><?= $vew_tme['dom']['str'].' - '.$vew_tme['dom']['end']; ?></td><td><?= $vew_tme['dom']['cmt']; ?></td></tr>
		<tr class="<?= $vew_tme['lun']['class']; ?>"><td>Lun</td><td><?= $vew_tme['lun']['str'].' - '.$vew_tme['lun']['end']; ?></td><td><?= $vew_tme['lun']['cmt']; ?></td></tr>
		<tr class="<?= $vew_tme['mar']['class']; ?>"><td>Mar</td><td><?= $vew_tme['mar']['str'].' - '.$vew_tme['mar']['end']; ?></td><td><?= $vew_tme['mar']['cmt']; ?></td></tr>
		<tr class="<?= $vew_tme['mie']['class']; ?>"><td>Mie</td><td><?= $vew_tme['mie']['str'].' - '.$vew_tme['mie']['end']; ?></td><td><?= $vew_tme['mie']['cmt']; ?></td></tr>
		<tr class="<?= $vew_tme['jue']['class']; ?>"><td>Jue</td><td><?= $vew_tme['jue']['str'].' - '.$vew_tme['jue']['end']; ?></td><td><?= $vew_tme['jue']['cmt']; ?></td></tr>
		<tr class="<?= $vew_tme['vie']['class']; ?>"><td>Vie</td><td><?= $vew_tme['vie']['str'].' - '.$vew_tme['vie']['end']; ?></td><td><?= $vew_tme['vie']['cmt']; ?></td></tr>
		<tr class="<?= $vew_tme['sab']['class']; ?>"><td>Sab</td><td><?= $vew_tme['sab']['str'].' - '.$vew_tme['sab']['end']; ?></td><td><?= $vew_tme['sab']['cmt']; ?></td></tr>
	</tbody>
</table>
<?php
	}
?>
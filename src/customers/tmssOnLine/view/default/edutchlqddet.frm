<?php	
	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// librería de estilos bootstrap 
	include_once('_library.frm');

	// acción por default 
	if ( !isset($vew_actcod) ) { $vew_actcod = '13'; }
	$vew_readonly = ($vew_actcod=='11'||$vew_actcod=='12'?false:true);
?>
<div id="<?= $lv_sec; ?>_opndet">
	<div class="container-fluid" role="tabpanel">
		<ul class="nav nav-pills" role="tablist">
			<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_opnsrv" role="tab" data-toggle="tab">Prestaciones <span class="badge opnsrvbdg"></span></a></li>
			<li role="presentation"><a href="#<?= $lv_sec; ?>_opnexp" role="tab" data-toggle="tab"><?= $vew_lang->expenses; ?> <span class="badge opnexpbdg"></span></a></li>
			<div class="pull-right">
				<h3 style="margin-top: 0px; margin-bottom: 0px;"><small><?= $vew_lang->total; ?></small>&nbsp;&nbsp;&nbsp;<span id="edutchlqdtot"><?= number_format(floatval($vew_data->edutchlqdtot),2,',','.'); ?></span></h3>
			</div>
		</ul>
		<hr style="margin-top: 10px; margin-bottom: 10px;">
		<div class="tab-content tmss-tab-content">
			
			<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_opnsrv">
				<div class="row">
					<!--
					<label class="control-label col-md-2"><?= $vew_lang->hours; ?></label>
					<div class="col-md-2"><?= gethtml('opnsrvtme','docqty','',$lv_always_disabled); ?></div>
					<label class="control-label col-md-2"><?= $vew_lang->sessions; ?></label>
					<div class="col-md-2"><?= gethtml('opnsrvses','docqty','',$lv_always_disabled); ?></div>
					-->
					<div class="col-md-7"></div>
					<label class="control-label col-md-2"><?= $vew_lang->subtotal; ?></label>
					<div class="col-md-3"><?= gethtml('opnsrvtot','docqty','',$lv_always_disabled); ?></div>
				</div>
				<hr>
				<table class="table table-condensed table-striped">
					<thead>
						<tr>
							<th><input type="checkbox" id="opnsrvchkhdr"></th>
							<th>ID</th>
							<th>Fecha</th>
							<th>Concepto</th>
							<th>Tipo</th>
							<th class="text-right">Precio</th>
							<th></th>							
						</tr>
					</thead>
					<tbody>
						<?php	
							foreach ($vew_data->opnsrv as $lv_row) {
								echo '<tr>'.
											'<td>'.($lv_row['prc']!=null?'<input type="checkbox" id="opnsrvchk" data-refobjtyp="'.$lv_row['refobjtyp'].'" data-refobjcod001="'.$lv_row['refobjcod001'].'" data-refobjcod002="'.$lv_row['refobjcod002'].'" data-refobjtot="'.$lv_row['prc'].'" '.(isset($lv_row['edutchlqddoccod'])?'checked="checked"':'').'></td>':'').
											'<td>'.$lv_row['refobjcod001'].'/'.$lv_row['refobjcod002'].'</td>'.
											'<td>'.$lv_row['evldtecnv'].'</td>'.
											'<td><small>'.$lv_row['educurtxt'].' / '.$lv_row['educartxt'].' / '.$lv_row['educoutxt'].' / '.$lv_row['edusubtxt'].'<br>'.$lv_row['stutxt'].'</td>'.
											'<td>'.$lv_row['evltyp'].'</td>'.
											'<td class="text-right">'.(isset($lv_row['prc'])?number_format($lv_row['prc'],2,',','.'):'').'</td>'.
											'<td class="text-left">'.$lv_row['curcod'].'</td>'.
											'</tr>';
							} 
						?>
					</tbody>
				</table>
			</div>

			<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_opnexp">
				<div class="row">
					<div class="col-md-7"></div>
					<label class="control-label col-md-2">Total</label>
					<div class="col-md-3"><?= gethtml('opnexptot','docqty','',$lv_always_disabled); ?></div>
				</div>
				<table class="table table-condensed table-striped">
					<thead>
						<tr>
							<th><input type="checkbox" id="opnexpchkhdr"></th>
							<th>ID</th>
							<th>Fecha</th>
							<th>Concepto</th>
							<th class="text-right">Total</th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<?php	
							foreach ($vew_data->opnexp as $lv_row) {
								if( ($vew_readonly==true && isset($lv_row['edutchlqddoccod'])) || $vew_readonly==false ) {
									echo '<tr>'.
												'<td><input type="checkbox" id="opnexpchk" data-refobjtyp="'.$lv_row['refobjtyp'].'" data-refobjcod001="'.$lv_row['refobjcod001'].'" data-refobjcod002="'.$lv_row['refobjcod002'].'" data-refobjtot="'.$lv_row['edutchlqddoctot'].'" '.(isset($lv_row['edutchlqddoccod'])?'checked="checked"':'').'></td>'.
												'<td>'.$lv_row['refobjcod001'].'/'.$lv_row['refobjcod002'].'</td>'.
												'<td>'.$lv_row['edutchlqddocdtecnv'].'</td>'.
												'<td>'.$lv_row['edutchlqddoctxt'].'</td>'.
												'<td class="text-right">'.number_format($lv_row['edutchlqddoctot'],2,',','.').'</td>'.
												'<td class="text-left">'.$lv_row['refobjcurcod'].'</td>'.
												'</tr>';
								}
							} 
						?>
					</tbody>
				</table>
			</div>
			
		</div>
		
	</div> <!-- /panel-group -->
</div> <!-- /row -->
<script>		
	tmssFormEdit("<?= $lv_sec; ?>_opndet",<?= ($vew_actcod=='11'||$vew_actcod=='12'?'true':'false'); ?>);
</script>
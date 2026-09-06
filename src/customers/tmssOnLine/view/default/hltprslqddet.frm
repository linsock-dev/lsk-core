<?php
	// campos requeridos 
	$vew_input->RequiredFields( array() );
	
	// librería de estilos bootstrap 
	include_once('_library.frm');

	// -- acción por default 
	if ( !isset($vew_actcod) ) { $vew_actcod = '13'; }
	$vew_readonly = ($vew_actcod=='11'?false:true);
?>
<div id="<?= $lv_sec; ?>_opndet">
	<div class="container-fluid" role="tabpanel">
		<ul class="nav nav-pills" role="tablist">
			<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_opnsrv" role="tab" data-toggle="tab">Prestaciones <span class="badge opnsrvbdg"></span></a></li>
			<li role="presentation"><a href="#<?= $lv_sec; ?>_opnexp" role="tab" data-toggle="tab"><?= $vew_lang->expenses; ?> <span class="badge opnexpbdg"></span></a></li>
			<div class="pull-right">
				<h3 style="margin-top: 0px; margin-bottom: 0px;"><small><?= $vew_lang->total; ?></small>&nbsp;&nbsp;&nbsp;<span id="hltprslqdtot"><?= number_format(floatval($vew_data->hltprslqdtot),2,',','.'); ?></span></h3>
			</div>
		</ul>
		<hr style="margin-top: 10px; margin-bottom: 10px;">
		<div class="tab-content tmss-tab-content">
			
			<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_opnsrv">
				<div class="row">
					<label class="control-label col-md-2"><?= $vew_lang->hours; ?></label>
					<div class="col-md-2"><?= gethtml('opnsrvtme','docqty','',$lv_always_disabled); ?></div>
					<label class="control-label col-md-2"><?= $vew_lang->sessions; ?></label>
					<div class="col-md-2"><?= gethtml('opnsrvses','docqty','',$lv_always_disabled); ?></div>
					<label class="control-label col-md-2"><?= $vew_lang->subtotal; ?></label>
					<div class="col-md-2"><?= gethtml('opnsrvtot','docqty','',$lv_always_disabled); ?></div>
				</div>
        <div class="row">
					<label class="control-label col-md-2"><?= $vew_lang->points; ?></label>
					<div class="col-md-2"><?= gethtml('hltlqdcatpts','docnum', ($vew_readonly?'':(count($vew_data->opnsrv)>0?$vew_data->opnsrv[0]['prspts']:0)),$lv_always_disabled); ?></div>
					<label class="control-label col-md-2"><?= $vew_lang->CATEGORYPRICE; ?></label>
					<div class="col-md-2"><?= gethtml('hltlqdcatprc','docqty', ($vew_readonly?'':(count($vew_data->opnsrv)>0?$vew_data->opnsrv[0]['hltlqdcatprc']:0)),$lv_always_disabled); ?></div>
				</div>
				<hr>
				<table class="table table-condensed table-striped">
					<thead>
            <tr>
              <th><?php if(!$vew_readonly){ ?><input type="checkbox" id="opnsrvchkhdr"><?php } ?> </th>
              <th><?= $vew_lang->code; ?></th>
              <th><?= $vew_lang->name; ?></th>
							<th><?= $vew_lang->financial; ?></th>
              <th><?= $vew_lang->date; ?></th>
              <th><?= $vew_lang->specialty; ?></th>
              <th><?= $vew_lang->from; ?></th>
              <th><?= $vew_lang->to; ?></th>
              <th><?= $vew_lang->hours; ?></th>
              <th><?= $vew_lang->sessions; ?></th>
              <th>PrAdi</th>
              <th>PrEsp</th>
              <th><?= $vew_lang->price; ?></th>
            </tr>
          </thead>
					<tbody>
						<?php	
							foreach ($vew_data->opnsrv as $lv_row) {			
                $lv_hltlqdspcprcadd = ($vew_readonly ? (isset($lv_row['hltprslqddocatr001'])?$vew_doc->getTagValue($lv_row['hltprslqddocatr001'], 'hltlqdspcprcadd'):''):(isset($lv_row['hltlqdspcprcadd'])?$lv_row['hltlqdspcprcadd']:''));
                $lv_hltlqdspcprc = ($vew_readonly ? (isset($lv_row['hltprslqddocatr001'])?$vew_doc->getTagValue($lv_row['hltprslqddocatr001'], 'hltlqdspcprc'):''):(isset($lv_row['hltlqdspcprc'])?$lv_row['hltlqdspcprc']:''));
								echo '<tr>'.
											'<td><input type="checkbox" class="'.($vew_readonly?'hidden':'').'" id="opnsrvchk" data-refobjtyp="'.$lv_row['refobjtyp'].'" data-refobjcod001="'.$lv_row['refobjcod001'].'" data-refobjcod002="'.$lv_row['refobjcod002'].'" data-refobjtot="'.$lv_row['hltprslqddoctot'].'"  data-tme="'.(isset($lv_row['hltplnctrtme'])?$lv_row['hltplnctrtme']:'').'" data-qty="'.(isset($lv_row['hltplnctrqty'])?number_format($lv_row['hltplnctrqty'],0,',','.'):'').'" '.(isset($lv_row['hltprslqddoccod'])?'checked="checked"':'').'></td>'.
											'<td>'.$lv_row['hltprslqddoccodext'].'</td>'.
											'<td>'.$lv_row['hltprslqddoctxt'].'</td>'.
											'<td>'.$lv_row['custxt'].'</td>'.
											'<td>'.$lv_row['hltprslqddocdtecnv'].'</td>'.
											'<td>'.(isset($lv_row['spctxt'])?$lv_row['spctxt']:'').'</td>'.
											'<td>'.($vew_readonly ? (isset($lv_row['hltprslqddocatr001'])?$vew_doc->getTagValue($lv_row['hltprslqddocatr001'], 'ctrinbtme'):''):(isset($lv_row['ctrinbtme'])?$lv_row['ctrinbtme']:'')).'</td>'.
											'<td>'.($vew_readonly ? (isset($lv_row['hltprslqddocatr001'])?$vew_doc->getTagValue($lv_row['hltprslqddocatr001'], 'ctrouttme'):''):(isset($lv_row['ctrouttme'])?$lv_row['ctrouttme']:'')).'</td>'.
											'<td>'.(isset($lv_row['hltplnctrtme']) && intval($lv_row['hltplnctrtme'])?$lv_row['hltplnctrtme']:'').'</td>'.
											'<td>'.(isset($lv_row['hltplnctrqty'])?number_format($lv_row['hltplnctrqty'],0,',','.'):'').'</td>'.		
											'<td>'.($lv_hltlqdspcprcadd?number_format($lv_hltlqdspcprcadd,2,',','.'):'').'</td>'.
											'<td>'.($lv_hltlqdspcprc?number_format($lv_hltlqdspcprc,2,',','.'):'').'</td>'.
											'<td>'.$lv_row['hltprslqddoctot'].'</td>'.
											'</tr>';
							} 
						?>
					</tbody>
				</table>
			</div>

			<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_opnexp">
				<div class="row">
					<div class="col-md-7"></div>
					<label class="control-label col-md-2"><?= $vew_lang->subtotal; ?></label>
					<div class="col-md-3"><?= gethtml('opnexptot','docqty','',$lv_always_disabled); ?></div>
				</div>
        <hr>
				<table class="table table-condensed table-striped">
					<thead>
            <tr>
              <th><?php if(!$vew_readonly){ ?><input type="checkbox" id="opnexpchkhdr"><?php } ?> </th>
              <th><?= $vew_lang->ID; ?></th>
              <th><?= $vew_lang->code; ?></th>
              <th><?= $vew_lang->date; ?></th>
              <th><?= $vew_lang->concept; ?></th>
              <th><?= $vew_lang->total; ?></th>
            </tr>
          </thead>
					<tbody>
						<?php	
							foreach ($vew_data->opnexp as $lv_row) {
								echo '<tr>'.
											'<td><input type="checkbox" class="'.($vew_readonly?'hidden':'').'"  id="opnexpchk" data-refobjtyp="'.$lv_row['refobjtyp'].'" data-refobjcod001="'.$lv_row['refobjcod001'].'" data-refobjcod002="'.$lv_row['refobjcod002'].'" data-refobjtot="'.number_format($lv_row['hltprslqddoctot'],2,'.','').'" '.(isset($lv_row['hltprslqddoccod'])?'checked="checked"':'').'></td>'.
											'<td>'.$lv_row['hltprslqddoccodext'].'</td>'.
                  		'<td>'.$lv_row['buyexpcodext'].'</td>'.
											'<td>'.$lv_row['hltprslqddocdtecnv'].'</td>'.
											'<td>'.$lv_row['hltprslqddoctxt'].'</td>'.
											'<td>'.number_format($lv_row['hltprslqddoctot'],2,',','.').'</td>'.
											'</tr>';
							} 
						?>
					</tbody>
				</table>
			</div>
			
		</div>		
	</div> <!-- /panel-group -->
</div> <!-- /row -->
<script>		
	tmssFormEdit("<?= $lv_sec; ?>_opndet",<?= ($vew_actcod=='11'?'true':'false'); ?>);
</script>
<?php		
	// url del formulario
  $lv_lnk = '?prg=gaspln';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = ''; 

	// titulo
	$lv_title = $vew_lang->gastronomy;
	
	// módulo y programa
	$lv_mdlcod = 'GAS';
	$lv_prgcod = 'PLN';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<style>
		.tmss-gas-table { font-size: 24px; font-weight: bold; text-align: center; vertical-align: middle; border: #dcdcdc 1px solid; padding-top: 10px; padding-bottom: 10px; }
		.tmss-gas-table:hover {	background-color: #f1f1f1; cursor: pointer; }
		
		.tmss-table-ordopn { background-color: #FFEB3B !important; }
		.tmss-table-ordpay { background-color: #d9ffb4 !important; }
		.tmss-table-ordinv { background-color: #b4cfff !important; }
		.tmss-table-ordrel { background-color: #ffbfbf !important; }
		.tmss-table-orddsb { background-color: #d4d4d4 !important; color: #a6a6a6; cursor: not-allowed !important; }
		.tmss-slntbl-ord { background-color: #FFEB3B !important; }
		
		.tmss-stkmatcls{ font-size: 24px; font-weight: bold; text-align: center; vertical-align: middle; border: #dcdcdc 1px solid; padding-top: 10px; padding-bottom: 10px; min-height: 120px; }
		.tmss-stkmatcls:hover { background-color: #f1f1f1; cursor: pointer; }
		.tmss-stkmat{	font-size: 16px; border: #dcdcdc 1px solid; padding: 5px; min-height: 60px; }
		.tmss-stkmat:hover { background-color: #f1f1f1; cursor: pointer; }
		.tmss-stkmatlsthdr { background-color: #f1f1f1; font-size: 24px; margin-left: -20px; margin-right: -30px; padding: 5px; margin-bottom: 10px; height: 45px; }
		.tmss-icon-back { padding-left: 15px; padding-right: 15px; }
		
		.tktord { font-size: 12px; }
		.tktord thead tr th{ background-color: #f1f1f1; }
		.tktord tbody tr:hover{ background-color: #3f51b5; color: #ffffff; cursor: pointer; }
		
		.tktordtot {background-color: #3f51b5; color: #ffffff; font-weight: bold; font-size: 24px; margin-bottom: 0px; }
		.tktrowrej { color: #ff0000; } 
		.tktrowsel { border-top: #a6a6a6 1px solid; border-bottom: #a6a6a6 1px solid; background-color: #ffeb3b !important; }
		.tktqty { text-align: center; }
		.tkttme { text-align: right; }
		.tkttot {	text-align: right; font-weight: bold; }
		.tktbtnlg { padding: 5px 10px !important; }
		.tmss-matatrlst option { font-size: 20px; padding-top: 5px; padding-bottom: 5px; }
	</style>
	
  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<a href="#" class="btn btn-default navbar-btn hidden-sm hidden-md hidden-lg" title="Cuenta" id="btnordshw"><span class="fas fa-dollar-sign"></span> Cuenta</a>
				<a href="#" class="btn btn-default navbar-btn hidden" title="Opciones" id="btnordopt"><span class="fas fa-cash-register"></span> Opciones</a>
				<a href="#" class="btn btn-success navbar-btn hidden" title="Enviar" id="btnordsnd"><span class="fas fa-paper-plane"></span> Enviar</a>
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right"></ul>
		</div>
  </nav>
	
	<div class="row" style="margin-right: 0px;">
		<?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
		<?= gethtml('slsordcod','hidden',''); ?>
		<?= gethtml('docsts','hidden',''); ?>
		<?= gethtml('cuscod','hidden',''); ?>
		<?= gethtml('slsprclstcod','hidden',''); ?>
		<?= gethtml('slsorddte','hidden',''); ?>
		<?= gethtml('slntblcod','hidden',''); ?>
		<?= gethtml('slntblqty','hidden',''); ?>
		<?= gethtml('matcod','hidden',''); ?>
		<?= gethtml('matuntcod','hidden',''); ?>
		<?= gethtml('matqty','hidden',''); ?>
		<?= gethtml('matprc','hidden',''); ?>
		<?= gethtml('curcod','hidden',''); ?>
		
		<div class="col-sm-4 col-xs-12 hidden-xs" id="colord" style="height: calc(100vH - 160px); padding-right: 0px; border-right: #a6a6a6 1px solid;">	
			
			<table class="table tktordtot" id="slsordtot">
				<tbody><tr><td><?= $vew_lang->TOTAL; ?></td><td class="tkttot"></td></tr>
			</table>
			<table class="table table-condensed tktord" id="slsordmat">
				<thead><tr><th width="40"><?= $vew_lang->QTY; ?></th><th><?= $vew_lang->DESCRIPTION; ?></th><th width="100" style="text-align:right;"><?= $vew_lang->AMOUNT; ?></th><th width="40"><?= $vew_lang->ORDER; ?></th></tr></thead>
				<tbody></tbody>
			</table>
			
		</div>
		<div class="col-sm-8 col-xs-12" id="colmat">
			
			<!-- MESAS -->
			<div class="row" style="padding-left: 20px; padding-right: 30px;" id="rowslntbl">
				<!-- SALONES -->
				<div class="tmss-stkmatlsthdr">
          <div class="col-xs-10">
            <i class="fas fa-store-alt pull-left" style="padding-left: 15px; padding-right: 15px;"></i>
						<div class="pull-left">
							<select id="slncod" name="slncod">
							<?php	foreach($vew_data->sln as $lv_row){ echo '<option value="'.$lv_row['slncod'].'" data-slntyp="'.$lv_row['slntyp'].'" data-cuscod="'.$lv_row['cuscod'].'" data-strloccod="'.$lv_row['strloccod'].'" data-sysdocclscod_ord="'.$lv_row['sysdocclscod_ord'].'" data-sysdocclscod_stk="'.$lv_row['sysdocclscod_stk'].'">'.$lv_row['slntxt'].'</option>'; } ?>
							</select>
            </div>
          </div>
          <div>
						<div class="pull-right" style="padding-right: 15px;"><a href="#" onclick="<?= $lv_sec; ?>_refreshTables(); toastr.info('Actualizado.');" class="btn btn-default navbar-btn" title="<?= $vew_lang->refresh; ?>" style="margin-top: 0px;"><span class="fas fa-sync-alt"></span></a></div>
          </div>
				</div>
				
				<!-- SELECTOR MESA -->
				<div class="form-group row hidden-xs hidden" style="margin-bottom: 0px;" id="slntblseldiv">
					<label class="control-label col-sm-2 col-xs-4" style="margin-top: 10px; text-align: right;"><?= $vew_lang->SALOONTABLE; ?></label>
					<div class="col-sm-4 col-xs-8"><input type="text" id="slntblcodext" name="slntblcodext" class="form-control" style="font-size: 18px; margin-bottom: 10px; text-align: center;" autocomplete="off"></div>
					<div class="col-sm-6 hidden-xs"></div>
				</div>
				
				<!-- MESAS / PEDIDOS -->
				<div id="rowtbllst"></div>
			
			</div>
			
			
			
			<!-- ABRIR MESA -->
			<div class="row hidden" style="padding-left: 20px; padding-right: 30px;" id="rowtblopn">
				<div id="rowtblopnhdr" class="tmss-stkmatlsthdr">
					<span><i class="fas fa-utensils" style="padding-left: 15px; padding-right: 15px;"></i><?= $vew_lang->OPENTABLE; ?></span>
					<div class="pull-right"><a href="#" onclick="<?= $lv_sec; ?>_tblOpnBack();" id="btncls" class="btn btn-default navbar-btn" title="<?= $vew_lang->close; ?>" style="margin-top: 0px;"><span class="fas fa-times"></span></a></div>
				</div>
				<div style="min-height: 150px; border: #dcdcdc 1px solid; padding: 20px;">
					<div class="form-group row" style="margin-bottom: 0px;">
						<label class="control-label col-sm-4 col-xs-5" style="margin-top: 10px; text-align: right;"><?= $vew_lang->WAITER; ?></label>
						<div class="col-sm-4 col-xs-6"><input type="number" id="slsordmzo" name="slsordmzo" min="1" max="100" step="1" class="form-control" style="font-size: 18px; margin-bottom: 10px;"></div>
						<div class="col-sm-4 hidden-xs"></div>
					</div>
					<div class="form-group row" style="margin-bottom: 0px;">
						<label class="control-label col-sm-4 col-xs-5" style="margin-top: 10px; text-align: right;"><?= $vew_lang->CUTLERY; ?></label>
						<div class="col-sm-4 col-xs-6"><input type="number" id="slsordqty" name="slsordqty" min="1" max="100" step="1" class="form-control" style="font-size: 18px; margin-bottom: 10px;"></div>
						<div class="col-sm-4 hidden-xs"></div>
					</div>
					<div class="form-group row" style="margin-bottom: 0px;">
						<label class="control-label col-sm-4 col-xs-5" style="margin-top: 10px; text-align: right;"> Servicio de Mesa</label>
						<div class="col-sm-4 col-xs-6"><input type="number" id="slsordsrv" name="slsordsrv" min="1" max="100" step="1" class="form-control" style="font-size: 18px; margin-bottom: 10px;"></div>
						<div class="col-sm-4 hidden-xs"></div>
					</div>
					<div class="form-group row" style="margin-bottom: 0px;">
						<div class="col-sm-4 col-xs-6"></div>
						<div class="col-sm-4 col-xs-6"><a href="#" class="btn btn-success btn-lg tktbtnlg" id="btntblopn"><i class="fas fa-user-plus"></i> Abrir Mesa</a></div>
					</div>

				</div>
			</div>
			
			
			
			<!-- MATERIAL -->
			<div class="row hidden" style="padding-left: 20px; padding-right: 30px;" id="rowmat">
				<div id="rowmatclshdr" class="tmss-stkmatlsthdr">
					<span></span>
					<div class="pull-right"><a href="#" onclick="<?= $lv_sec; ?>_tblOpnBack();" id="btncls" class="btn btn-default navbar-btn" title="<?= $vew_lang->close; ?>" style="margin-top: 0px;"><span class="fas fa-times"></span></a></div>
				</div>
				<div class="form-group row" style="margin-bottom: 0px;">
					<label class="control-label col-sm-2 col-xs-4" style="margin-top: 10px; text-align: right;"><?= $vew_lang->ARTICLE; ?></label>
					<div class="col-sm-10 col-xs-8"><input type="text" id="mattxt" name="mattxt" data-matcod="" class="form-control" style="font-size: 18px; margin-bottom: 10px;" autocomplete="off"></div>
				</div>
			</div>
			
			
			
			<!-- ATRIBUTOS -->
			<div class="row hidden" style="padding-left: 20px; padding-right: 30px;" id="rowmatatr">
				<div id="rowmatatrhdr" class="tmss-stkmatlsthdr">
					<span></span>
					<div class="pull-right"><a href="#" onclick="<?= $lv_sec; ?>_matLstBack();" id="btncls" class="btn btn-default navbar-btn" title="<?= $vew_lang->close; ?>" style="margin-top: 0px;"><span class="fas fa-times"></span></a></div>
				</div>
				<div class="form-group row" style="margin-bottom: 0px;">
					<label class="control-label col-sm-2 col-xs-4" style="margin-top: 10px; text-align: right;"><?= $vew_lang->ARTICLE; ?></label>
					<div class="col-sm-10 col-xs-8"><input type="text" id="mattxthde" name="mattxthde" class="form-control" style="font-size: 18px; margin-bottom: 10px; background-color: #f1f1f1;" readonly="readonly"></div>
				</div>
				<div style="min-height: 150px; border: #dcdcdc 1px solid; padding: 20px;">
          <div class="form-group row" style="margin-bottom: 0px;">
            <label class="control-label col-sm-4 col-xs-4" style="margin-top: 10px; text-align: right;"><?= $vew_lang->QUANTITY; ?></label>
            <div class="col-sm-4 col-xs-4">
              <input type="NUMBER" id="matatrqty" name="matatrqty" class="form-control" value="1" style="font-size: 18px; margin-bottom: 10px;">
          	</div>
          	<div class="col-sm-4 col-xs-4"><a href="#" class="btn btn-primary btn-lg tktbtnlg" id="btnmatadd"><?= $vew_lang->ADD; ?></a></div>
          </div>
					<div class="form-group row" id="rowmatatrlst">
						<div class="col-xs-12"><div class="" id="matatrlst"></div></div>
					</div>
					<div class="form-group row" style="margin-bottom: 0px;">
						<label class="control-label col-sm-4 col-xs-4" style="margin-top: 10px; text-align: right;"><?= ($vew_lang->ORDER)." ".($vew_lang->SPECIAL); ?></label>
						<div class="col-sm-6 col-xs-8"><input type="text" id="matatrtxt" name="matatrtxt" class="form-control" style="font-size: 18px; margin-bottom: 10px;"></div>
					</div>
					<div class="form-group row" style="margin-bottom: 0px;">
						<label class="control-label col-sm-4 col-xs-4" style="margin-top: 10px; text-align: right;"></label>
						<div class="col-sm-2 col-xs-2"></div>
					</div>
				</div>
			</div>
			
			
			
			<!-- CLASIFICACION -->
			<div class="row hidden" style="padding-left: 20px; padding-right: 30px;" id="rowmatcls">
				<?php
					foreach($vew_data->stkmatcls as $lv_row) {
						$lv_img = $vew_doc->getTagValue( $lv_row['matclsatr'], 'matclsimg' );
						$lv_img = trim(strtolower($lv_img));
						if(substr($lv_img,0,6)=='class:'){$lv_img = substr($lv_img,6,strlen($lv_img)-6);}
						echo '<div class="col-xs-6 col-sm-4 col-md-3 col-lg-2 tmss-stkmatcls" name="divmatcls" data-matclscod="'.$lv_row['matclscod'].'" data-matclstxt="'.$lv_row['matclstxt'].'" data-matclsimg="'.$lv_img.'">'.($lv_img!=''?'<i class="'.$lv_img.'" style="padding-top: 10px; padding-bottom: 15px;"></i><br>':'').'<span style="font-size: 16px;">'.$lv_row['matclstxt'].'</span></div>';
					}
				?>
			</div>
			
			
			
			<!-- MATERIALES -->
			<div class="row hidden" style="padding-left: 20px; padding-right: 30px;" id="rowmatlst">
				<div id="rowmathdr" class="tmss-stkmatlsthdr">
					<span></span>
					<div class="pull-right"><a href="#" onclick="<?= $lv_sec; ?>_matLstBack();" id="btncls" class="btn btn-default navbar-btn" title="<?= $vew_lang->close; ?>" style="margin-top: 0px;"><span class="fas fa-times"></span></a></div>
				</div>
				<div id="matlst"></div>
			</div>
			
			
			
			<!-- POSICION MATERIAL -->
			<div class="row hidden" style="padding-left: 20px; padding-right: 30px;" id="rowslsordmat">
				<div id="rowslsordmathdr" class="tmss-stkmatlsthdr">
					<span></span>
					<div class="pull-right"><a href="#" onclick="<?= $lv_sec; ?>_matLstBack();" id="btncls" class="btn btn-default navbar-btn" title="<?= $vew_lang->close; ?>" style="margin-top: 0px;"><span class="fas fa-times"></span></a></div>
				</div>
				<div class="form-group row" style="margin-bottom: 0px;">
					<label class="control-label col-sm-2 col-xs-4" style="margin-top: 10px; text-align: right;"><?= $vew_lang->ARTICLE; ?></label>
					<div class="col-sm-10 col-xs-8"><input type="text" id="mattxthde2" name="mattxthde2" class="form-control" style="font-size: 18px; margin-bottom: 10px; background-color: #f1f1f1;" readonly="readonly"></div>
				</div>
				<div style="min-height: 150px; border: #dcdcdc 1px solid; padding: 20px;">
          <div class="form-group row">
            <label id="matatrqtylbl" class="control-label col-sm-4 col-xs-4" style="margin-top: 10px; text-align: right;"><?= $vew_lang->QUANTITY; ?></label>
            <div class="col-sm-4 col-xs-4 pb-6">
              <input type="NUMBER" id="matatrqty" name="matatrqty" class="form-control" value="1" style="font-size: 18px; margin-bottom: 10px;">
          	</div>
          	<div class="col-sm-4 col-xs-3" style="display: flex;">
							<a href="#" class="btn btn-success btn-lg tktbtnlg" id="btnmatupd"><i class="fas fa-pencil-alt"></i> <?= $vew_lang->UPDATE; ?></a>&nbsp;
							<a href="#" class="btn btn-danger btn-lg tktbtnlg" id="btnmatupddel"><i class="fas fa-trash"></i> <?= $vew_lang->DELETE; ?></a>
						</div>
          </div>
					<div class="form-group row" id="rowmatatrlst2">
						<div class="col-xs-12"><div class="" id="matatrlst2"></div></div>
					</div>
					<div class="form-group row" style="margin-bottom: 0px;">
						<label class="control-label col-sm-4 col-xs-4" style="margin-top: 10px; text-align: right;"><?= ($vew_lang->ORDER)." ".($vew_lang->SPECIAL); ?></label>
						<div class="col-sm-6 col-xs-8"><input type="text" id="matatrtxt2" name="matatrtxt2" class="form-control" style="font-size: 18px; margin-bottom: 10px;"></div>
					</div>
          <div class="form-group row" style="margin-bottom: 0px;" id="rowmatrej">
						<label class="control-label col-sm-4 col-xs-4" style="margin-top: 10px; text-align: right;"><?= $vew_lang->REJECT; ?></label>
						<div class="col-sm-6 col-xs-8"><select id="matrejcod" name="matrejcod" class="form-control" style="font-size: 18px; margin-bottom: 10px;"></select></div>
					</div>
				</div>
			</div>
			
			
			
			<!-- OPCIONES CUENTA -->
			<div class="row hidden" style="padding-left: 20px; padding-right: 30px;" id="rowslsordcls">
				<div id="rowslsordclshdr" class="tmss-stkmatlsthdr">
					<span></span>
					<div class="pull-right"><a href="#" onclick="<?= $lv_sec; ?>_slsOptBack();" id="btncls" class="btn btn-default navbar-btn" title="<?= $vew_lang->close; ?>" style="margin-top: 0px;"><span class="fas fa-times"></span></a></div>
				</div>
				<div style="min-height: 150px; border: #dcdcdc 1px solid; padding: 20px; display: flow-root;">
					<div class="col-xs-6 col-sm-4 col-md-3 col-lg-2 tmss-stkmatcls" id="btnslsordpre"><i class="fas fa-print" style="padding-top: 10px; padding-bottom: 15px;"></i><p style="font-size: 16px;">Pre-Cuenta</p></div>
					<div class="col-xs-6 col-sm-4 col-md-3 col-lg-2 tmss-stkmatcls tmss-table-ordinv" id="btnslsordinv"><i class="fas fa-file-invoice-dollar" style="padding-top: 10px; padding-bottom: 15px;"></i><p style="font-size: 16px;"><?= $vew_lang->INVOICE; ?></p></div>
					<div class="col-xs-6 col-sm-4 col-md-3 col-lg-2 tmss-stkmatcls tmss-table-ordinv" id="btnslsordcre"><i class="far fa-file-alt" style="padding-top: 10px; padding-bottom: 15px;"></i><p style="font-size: 16px;"><?= $vew_lang->CREDITNOTE; ?></p></div>
					<div class="col-xs-6 col-sm-4 col-md-3 col-lg-2 tmss-stkmatcls tmss-table-ordpay" id="btnslsordcte"><i class="far fa-id-card" style="padding-top: 10px; padding-bottom: 15px;"></i><p style="font-size: 16px;"><?= $vew_lang->SUMMARY; ?></p></div>
					<div class="col-xs-6 col-sm-4 col-md-3 col-lg-2 tmss-stkmatcls tmss-table-ordpay" id="btnslsordcob"><i class="fas fa-dollar-sign" style="padding-top: 10px; padding-bottom: 15px;"></i><p style="font-size: 16px;"><?= $vew_lang->CHARGEMONEY; ?></p></div>
					<div class="col-xs-6 col-sm-4 col-md-3 col-lg-2 tmss-stkmatcls tmss-table-ordrel" id="btnslsordund"><i class="fas fa-undo" style="padding-top: 10px; padding-bottom: 15px;"></i><p style="font-size: 16px;"><?= $vew_lang->UNDOACCOUNT; ?></p></div>
					<div class="col-xs-6 col-sm-4 col-md-3 col-lg-2 tmss-stkmatcls tmss-table-ordrel" id="btnslsordcls"><i class="fas fa-broom" style="padding-top: 10px; padding-bottom: 15px;"></i><p style="font-size: 16px;"><?= ($vew_lang->RELEASE)." ".($vew_lang->saloontable); ?></p></div>
				</div>
				<!--
				<table class="table table-condensed">
					<tbody>
						<tr><td width="150">Mozo</td><td></td></tr>
						<tr><td>Cubiertos</td><td></td></tr>
						<tr><td>Abierta / Liberada</td><td id="slsordctedte">10:27 / 12:29 (2:02 hs)</td></tr>
						<tr><td>Ticket</td><td id="slsinvcodext"></td></tr>
					</tbody>
				</table>
				-->
			</div>



			<!-- COBRAR -->
			<div class="row hidden" style="padding-left: 20px; padding-right: 30px;" id="rowslsordpay">
				<div id="rowslsordcobhdr" class="tmss-stkmatlsthdr">
					<span></span>
					<div class="pull-right"><a href="#" onclick="<?= $lv_sec; ?>_matLstBack();" id="btncls" class="btn btn-default navbar-btn" title="<?= $vew_lang->close; ?>" style="margin-top: 0px;"><span class="fas fa-times"></span></a></div>
				</div>
				<div style="min-height: 150px; border: #dcdcdc 1px solid; padding: 20px; display: flow-root;">
					<table class="table table-bordered">
						<thead><tr><th>Medio</th><th width="200"><?= $vew_lang->AMOUNT; ?></th></tr></thead>
						<tbody>
							<!-- tr class="bg-primary" style="font-size:24px;"><td>TOTAL A COBRAR</td><td align="right" style="font-weight: bold;" id="txtpayord"></td></tr>
							<tr><td><i class="fas fa-money-bill-wave"></i> Efectivo</td><td align="right"><input type="number" min="0" max="99999" class="form-control" value="" id="txtpayeft" ></td></tr>
							<tr><td><i class="fas fa-credit-card"></i> Tarjeta</td><td align="right"><input type="number" min="0" max="99999" class="form-control" value="" id="txtpaytjt"></td></tr>
							<tr><td><i class="far fa-handshake"></i> Descuento</td><td align="right"><input type="number" min="0" max="99999" class="form-control" value="" id="txtpaydes"></td></tr>
							<tr class="bg-primary" style="font-size: 24px;"><td>VUELTO</td><td align="right" style="font-weight: bold;" id="txtpaytot"></td></tr -->
						</tbody>
					</table>
					<div class="pull-right"><a href="#" class="btn btn-success btn-lg" id="btnpay">Cobrar</a></div>
				</div>
			</div>
			
			
			<!-- CUENTA CORRIENTE -->
			<div class="row hidden" style="padding-left: 20px; padding-right: 30px;" id="rowslsordcta">
				<div id="rowslsordctehdr" class="tmss-stkmatlsthdr"><a href="#" onclick="<?= $lv_sec; ?>_matLstBack();"><i class="fas fa-chevron-circle-left tmss-icon-back"></i></a><i class='fas fa-utensils' style='padding-right: 15px;'></i>MESA x - CERRAR - CUENTA CORRIENTE</div>
					<?php
					/*
						echo vew_boot($lv_col210, array('label'=>$vew_lang->customer, 'input1'=>vew_boot( array('style'=>'custom', 'readonly'=>$vew_readonly),
								array('custom'=>'<span class="input-group-btn"><a href="#" class="btn btn-default">&nbsp;<span class="fas fa-search"></span></a>'.($vew_sec->hasPermission('SLS','CUS','01') ? '<a href="#" id="btnpatadd" class="btn btn-default">&nbsp;<span class="fas fa-plus"></span></a>' : '' ).($vew_sec->hasPermission('SLS','CUS','02') ? '<a href="#" id="btnpatedt" class="btn btn-default '.($vew_data->cuscod!=''?'':'hidden').'">&nbsp;<span class="fas fa-pencil-alt"></span></a>' : '' ).'</span>'),
											'input'=>gethtml('custxt', 'doccmt1x50', '', $lv_default) 
											)) );
											*/
					?>
				</div>
			</div>
			
		</div>
	<script>
		$(function(){	
			$("#<?= $lv_sec; ?> #slncod").trigger("change");
		});
		
		// MESAS. al cambiar el salon se actualizan las mesas
		$("#<?= $lv_sec; ?> #slncod").on("change", function(e){ e.preventDefault();
			var lv_slntyp = $("#<?= $lv_sec; ?> #slncod option:selected").data("slntyp");
			var lv_dat = [{name:"slncod",value:$("#<?= $lv_sec; ?> #slncod").val() },{name:"slntyp",value:lv_slntyp}];
			tmssCallProcess("?prg=gaspln&act="+(lv_slntyp=="S"?"getTables":(lv_slntyp=="D"?"getSalesOrders":"getSalesOrders")), lv_dat, function(data){
				
				// SALON
				if( lv_slntyp=="S" ){
					$("#<?= $lv_sec; ?> #slntblseldiv").removeClass("hidden");
					// armo listado de mesas del salon
					var lv_dat = "";
					for(var i=0; i<data.length; i++){
						lv_dat += "<div class='col-xs-4 col-sm-3 col-md-2 col-lg-2 tmss-gas-table' name='divslntbl' data-slntblcod='"+data[i].slntblcod+"' data-slntblcodext='"+data[i].slntblcodext+"' data-slntblqty='"+data[i].slntblqty+"'>"+data[i].slntblcodext
										+"<span class='pull-right' style='font-size: 12px; font-weight: unset;'>"
											+"<span class='hidden'><i class='fas fa-utensils'></i> "+data[i].slntblqty+"<br></span>"
											+"<i class='fas fa-dollar-sign hidden' name='divslntblpay' title='Cobrado'></i> "
											+"<i class='fas fa-receipt hidden' name='divslntblinv' title='Facturado'></i>"
											+"<i class='fas fa-user hidden' name='divslntblcte' title='Cta.Cte'></i>"
										+"</span>"
									+"</div>";
					}
					$("#<?= $lv_sec; ?> #rowtbllst").html( lv_dat );
					
					// actualizo el status de las mesas
					<?= $lv_sec; ?>_refreshTables();
					
					// foco en el número de mesa (para el uso del teclado)
					$("#<?= $lv_sec; ?> #slntblcodext").focus();
				}
				
				
				// KIOSCO
				if( lv_slntyp=="K" ){
					$("#<?= $lv_sec; ?> #slntblseldiv").addClass("hidden");
					// ingreso directamente al pedido en curso (si no hay se crea uno vacío)					
					var lv_dat = "";
					lv_dat += "<div class='col-xs-4 col-sm-3 col-md-2 col-lg-2 tmss-gas-table' name='divslntbl' data-slntblcod='0' data-slntblcodext='Kiosco' data-slntblqty='1'>Kiosco"
									+"<span class='pull-right' style='font-size: 12px; font-weight: unset;'>"
										+"<span class='hidden'><i class='fas fa-utensils'></i> 1<br></span>"
										+"<i class='fas fa-dollar-sign hidden' name='divslntblpay' title='Cobrado'></i> "
										+"<i class='fas fa-receipt hidden' name='divslntblinv' title='Facturado'></i>"
										+"<i class='fas fa-user hidden' name='divslntblcte' title='Cta.Cte'></i>"
									+"</span>"
								+"</div>";
					$("#<?= $lv_sec; ?> #rowtbllst").html( lv_dat );					
          $("#<?= $lv_sec; ?> #slntblcod").prop("value", "0");
          $("#<?= $lv_sec; ?> #slntblcodext").prop("value", "Kiosco");
          $("#<?= $lv_sec; ?> #slntblqty").prop("value", "1");

					// verifico si hay un pedido abierto
					var lv_pstdat =[{name:"sysdocclscod",value:$("#<?= $lv_sec; ?> #sysdocclscod").prop("value")},
													{name:"slncod",value:$("#<?= $lv_sec; ?> #slncod").prop("value")},
													{name:"slntblcod",value:"0"},
													{name:"slsordcod",value:$("#<?= $lv_sec; ?> #slsordcod").prop("value")}];
					tmssCallProcess("?prg=gaspln&act=showTable",lv_pstdat,function(data){
						// se abre un nuevo pedido
						if(data.slsordcod==0) {
							var lv_pstdat2 =[{name:"sysdocclscod",value:$("#<?= $lv_sec; ?> #sysdocclscod").prop("value")},
															{name:"slncod",value:$("#<?= $lv_sec; ?> #slncod").prop("value")},{name:"slntyp",value:lv_slntyp},
															{name:"slntblcod",value:"0"},{name:"slsordqty",value:"0"},{name:"slsordsrv",value:"0"}];
							tmssCallProcess("?prg=gaspln&act=addOrder",lv_pstdat2,function(data){
								<?= $lv_sec; ?>_showTable();
							});
						// se muestra el pedido existente
						} else {
							<?= $lv_sec; ?>_showTable();
						}
					});
				}
				
				
				// DELIVERY
				if( lv_slntyp=="D" ){
					$("#<?= $lv_sec; ?> #slntblseldiv").addClass("hidden");
					// FALTA: armo listado de pedidos en marcha
				}
				
			});
		});
		
		
		
		// --------------------------------------------------------------
		//  SALON - MESAS
		// --------------------------------------------------------------
		
		
		
		// keydown en nro de mesa
		$("#<?= $lv_sec; ?> #slntblcodext").on("keydown",function(e){
			$("#<?= $lv_sec; ?> #slntblcod").prop("value", "");
			$("#<?= $lv_sec; ?> #slntblqty").prop("value", "");
			if(e.which==13){ <?= $lv_sec; ?>_showTable(); }
		});
		
		// actualizar estado de mesas
		function <?= $lv_sec; ?>_refreshTables(){
			var lv_slncod = $("#<?= $lv_sec; ?> #slncod").prop("value");
			var lv_pstdat = [{name:"slncod",value:lv_slncod}];
			$("#<?= $lv_sec; ?> div[name=divslntbl]").removeClass("tmss-table-ordopn").removeClass("tmss-table-ordpay").removeClass("tmss-table-ordinv");
			$("#<?= $lv_sec; ?> div[name=divslntbl] i[name=divslntblpay]").addClass("hidden");
			$("#<?= $lv_sec; ?> div[name=divslntbl] i[name=divslntblinv]").addClass("hidden");
			$("#<?= $lv_sec; ?> div[name=divslntbl] i[name=divslntblcte]").addClass("hidden");
			tmssCallProcessNoBackdrop("?prg=gaspln&act=getSalesOrders",lv_pstdat,function(data){
				$("#<?= $lv_sec; ?> div[name=divslntbl]").each(function(e){
					var lv_found = false;
					for(var i=0; i<data.length; i++){
						if( lv_slncod+"_"+$(this).data("slntblcod")==data[i].slsordcodext){
							if(data[i].docsts=="A"){
								$(this).addClass("tmss-table-ordopn");
							}
							if(data[i].docsts.indexOf("I")>=0){
								$(this).addClass("tmss-table-ordinv");
								$(this).find("i[name=divslntblinv]").removeClass("hidden");
							}
							if(data[i].docsts.indexOf("P")>=0){
								$(this).addClass("tmss-table-ordpay");
								$(this).find("i[name=divslntblpay]").removeClass("hidden");
							}
							if(data[i].docsts.indexOf("C")>=0){
								$(this).addClass("tmss-table-ordpay");
								$(this).find("i[name=divslntblcte]").removeClass("hidden");
							}
							i=data.length+1;
						}
					}
				});
       // click en mesa (grilla)
        $("div[name=divslntbl]").on("click",function(e){ e.preventDefault();
          $("#<?= $lv_sec; ?> #slntblcod").prop("value", $(this).data("slntblcod"));
          $("#<?= $lv_sec; ?> #slntblcodext").prop("value", $(this).data("slntblcodext"));
          $("#<?= $lv_sec; ?> #slntblqty").prop("value", $(this).data("slntblqty"));
          <?= $lv_sec; ?>_showTable();
        });
			});
		}
		
		// mostrar pedido de mesa
		function <?= $lv_sec; ?>_showTable() {
			var lv_slntyp = $("#<?= $lv_sec; ?> #slncod option:selected").data("slntyp");
			var lv_slntblcodext = $("#<?= $lv_sec; ?> #slntblcodext").prop("value");
			<?= $lv_sec; ?>_hideAll();
			if( lv_slntblcodext=="" ) {
				$("#<?= $lv_sec; ?> #btnordopt").addClass("hidden");
				$("#<?= $lv_sec; ?> #slsordcod").prop("value","");
				$("#<?= $lv_sec; ?> #rowslntbl").removeClass("hidden");
				$("#<?= $lv_sec; ?> #slsordtot .tkttot").text("");
				$("#<?= $lv_sec; ?> #slsordmat tbody").html("");
				<?= $lv_sec; ?>_refreshTables();
				$("#<?= $lv_sec; ?> #slntblcodext").focus();
				return false;
			}
			
			if( $("#<?= $lv_sec; ?> #rowslntbl div[name=divslntbl][data-slntblcodext="+lv_slntblcodext+"]").length==0 ){
				toastr.error("Numero de mesa ["+lv_slntblcodext+"] invalido.");
				$("#<?= $lv_sec; ?> #rowslntbl").removeClass("hidden");
				$("#<?= $lv_sec; ?> #slntblcodext").prop("value","").focus();
				return false;
			} else {
				var lv_slntblcod = $("#<?= $lv_sec; ?> #rowslntbl div[name=divslntbl][data-slntblcodext="+lv_slntblcodext+"]").data("slntblcod");
				var lv_slntblqty = $("#<?= $lv_sec; ?> #rowslntbl div[name=divslntbl][data-slntblcodext="+lv_slntblcodext+"]").data("slntblqty");
				$("#<?= $lv_sec; ?> #slntblcod").prop("value",lv_slntblcod);
				$("#<?= $lv_sec; ?> #slntblqty").prop("value",lv_slntblqty);
			}
			
			var lv_pstdat =[{name:"sysdocclscod",value:$("#<?= $lv_sec; ?> #sysdocclscod").prop("value")},
											{name:"slncod",value:$("#<?= $lv_sec; ?> #slncod").prop("value")},
											{name:"slntblcod",value:$("#<?= $lv_sec; ?> #slntblcod").prop("value")},
											{name:"slsordcod",value:$("#<?= $lv_sec; ?> #slsordcod").prop("value")}];
			tmssCallProcess("?prg=gaspln&act=showTable",lv_pstdat,function(data){
				
				// abrir mesa
				if(data.slsordcod==0) {
					$("#<?= $lv_sec; ?> #rowtblopn").removeClass("hidden");
					$("#<?= $lv_sec; ?> #slsordqty").prop("value",$("#<?= $lv_sec; ?> #slntblqty").prop("value"));
					$("#<?= $lv_sec; ?> #slsordsrv").prop("value",$("#<?= $lv_sec; ?> #slntblqty").prop("value"));
					$("#<?= $lv_sec; ?> #slsordmzo").prop("value","").focus();
					
				// mostrar detalle de mesa
				} else {
					var lv_dte, lv_atr;
					var lv_buffer = "";
					$("#<?= $lv_sec; ?> #btnordopt").removeClass("hidden");
					$("#<?= $lv_sec; ?> #slsordcod").prop("value",data.slsordcod);
					$("#<?= $lv_sec; ?> #docsts").prop("value",data.docsts);
					$("#<?= $lv_sec; ?> #slsprclstcod").prop("value",data.slsprclstcod);
					$("#<?= $lv_sec; ?> #cuscod").prop("value",data.cuscod);
					$("#<?= $lv_sec; ?> #slsordtot .tkttot").text( Number(data.slsordtotamt).toFixed(2) );
					
					lv_dte = new Date(data.ctedte.date);
					$("#<?= $lv_sec; ?> #slsordctedte").html( "<b>"+(lv_dte.getHours()<10?"0":"")+lv_dte.getHours()+":"+(lv_dte.getMinutes()<10?"0":"")+lv_dte.getMinutes()+"</b>" );
					$("#<?= $lv_sec; ?> #slsinvcodext").html(data.docsts.indexOf("I")>=0?"<b>00001B00345567</b>":"");
					
					for(var i=0; i<data.slsordmat.length; i++){
						lv_dte = new Date(data.slsordmat[i].ctedte.date);
						lv_atr = (data.slsordmat[i].slsordmatcmt!=null?data.slsordmat[i].slsordmatcmt:""); //$("<div>"+data.slsordmat[i].slsordmatcmt+"</div>").find("slsordmatslstxt").text();
						lv_rejcod = (data.slsordmat[i].sysdocrejcod!="0" && data.slsordmat[i].sysdocrejcod!=null?data.slsordmat[i].sysdocrejcod:"");
						lv_rejtxt = (data.slsordmat[i].sysdocrejcod!="0" && data.slsordmat[i].sysdocrejcod!=null?data.slsordmat[i].sysdocrejtxt:"");
						lv_buffer = lv_buffer + "<tr class='"+(lv_rejtxt!=""?"tktrowrej":"")+"' data-matcod='"+data.slsordmat[i].matcod+"' data-mattxt='"+data.slsordmat[i].mattxt+"' data-matqty='"+data.slsordmat[i].matqty+"' data-matuntcod='"+data.slsordmat[i].matuntcod+"' data-matprc='"+data.slsordmat[i].matprc+"' data-curcod='"+data.slsordmat[i].curcod+"' data-slsordmatcod='"+data.slsordmat[i].slsordmatcod+"' data-sysdocrejcod='"+data.slsordmat[i].sysdocrejcod+"' data-slsordmatcmt='"+lv_atr+"'><td class='tktqty' data-sysdocrejcod='"+lv_rejcod+"'>"+Number(data.slsordmat[i].matqty).toFixed(0)+"</td><td name='mattxt'>"+data.slsordmat[i].mattxt + <?= $lv_sec; ?>_parseAtributes(lv_atr) + (lv_rejtxt!=""?"<br><small>"+lv_rejtxt+"</small>":"")+"</td><td class='tkttot'>"+Number( (lv_rejtxt==""?data.slsordmat[i].mattot:0) ).toFixed(2)+"</td><td class='tkttme'>"+(lv_dte.getHours()<10?"0":"")+lv_dte.getHours()+":"+(lv_dte.getMinutes()<10?"0":"")+lv_dte.getMinutes()+"</td></tr>";
					}
					$("#<?= $lv_sec; ?> #slsordmat tbody").html( lv_buffer );
					
					// attach eventos - click en fila
					if(data.docsts=="A"){
						$("#<?= $lv_sec; ?> #slsordmat tbody tr").on("click",function(e){ e.preventDefault();
							<?= $lv_sec; ?>_editRow( $(this) );
						});
						
						// actualizo opciones de rechazo
						var lv_rejlst = "<option value=''></option>";
						for(var x=0; x<data.sysdocclsrej.length; x++){
							lv_rejlst += "<option value='"+data.sysdocclsrej[x].sysdocrejcod+"'>"+data.sysdocclsrej[x].sysdocrejtxt+"</option>";
						}
						$("#<?= $lv_sec; ?> #matrejcod").html(lv_rejlst);
						$("#<?= $lv_sec; ?> #rowmat").removeClass("hidden");
						$("#<?= $lv_sec; ?> #rowmatcls").removeClass("hidden");
						$("#<?= $lv_sec; ?> #mattxt").prop("value","").focus();

					// mesa facturada-cuenta corriente-cobrada
					} else {
						$("#<?= $lv_sec; ?> #btnordopt").trigger("click");
						// ocultar botón de regresar
					}
				}
				$("#<?= $lv_sec; ?> #rowmatclshdr span:first").text( (lv_slntyp=="S"?"MESA ":"")+lv_slntblcodext);
				$("#<?= $lv_sec; ?> #rowmatatrhdr span:first").text( (lv_slntyp=="S"?"MESA ":"")+lv_slntblcodext);
				$("#<?= $lv_sec; ?> #rowslsordcobhdr span:first").text( (lv_slntyp=="S"?"MESA ":"")+lv_slntblcodext + " - COBRAR ");
			});
		}
		
		// convierte atributos de tags a texto legible
		function <?= $lv_sec; ?>_parseAtributes( lp_atr ) {
			lp_atr = $("<div>").html(lp_atr).text();
			var lv_txt = "";
			for(var i=0; $("<div>"+lp_atr+"</div>").find("matatr"+i).length>0; i++){
				lv_txt += (lv_txt!=""?"; ":"")+$("<div>"+lp_atr+"</div>").find("matatr"+i).text();
			}
			if($("<div>"+lp_atr+"</div>").find("matatrtxt").length>0){
				lv_txt += (lv_txt!=""?"; ":"")+$("<div>"+lp_atr+"</div>").find("matatrtxt").text();
			}
			return (lv_txt==""?"":"<br><small>"+lv_txt+"</small>");
		}
		
		
		
		// --------------------------------------------------------------
		//  ABRIR MESA
		// --------------------------------------------------------------
		
		// keydown en nro de mozo
		$("#<?= $lv_sec; ?> #slsordmzo").on("keydown",function(e){
			if(e.which==13){ 
				if($(this).prop("value")!=""){ 
					/* FALTA: buscar nombre de mozo */
					$("#<?= $lv_sec; ?> #slsordqty").focus(); 
				}
			}
			if(e.which==27){ $(this).prop("value",""); <?= $lv_sec; ?>_tblOpnBack(); }
		});

		// keydown en cubiertos
		$("#<?= $lv_sec; ?> #slsordqty").on("keydown",function(e){
			if(e.which==13){ if($(this).prop("value")!=""){ $("#<?= $lv_sec; ?> #slsordsrv").focus(); }}
			if(e.which==27){ $(this).prop("value",""); $("#<?= $lv_sec; ?> #slsordmzo").focus(); }
		});

		// keydown en servicio de mesa
		$("#<?= $lv_sec; ?> #slsordsrv").on("keydown",function(e){
			if(e.which==13){
				if($(this).prop("value")!=""){ $("#<?= $lv_sec; ?> #btntblopn").trigger("click"); }
				e.preventDefault(); e.stopPropagation();
			}
			if(e.which==27){ $(this).prop("value",""); $("#<?= $lv_sec; ?> #slsordqty").focus(); }
		});
		
		// click en boton abrir mesa
		$("#<?= $lv_sec; ?> #btntblopn").on("click",function(e){ e.preventDefault();
			// FALTA: blanquear campos x doble proceso
			// FALTA: determinar si solo se indica cubiertos y no servicio de mesa
			// FALTA: asignar material a cubiertos y servicio de mesa
			// FALTA: necesita comentarios adicionales??
			var lv_slntyp = $("#<?= $lv_sec; ?> #slncod option:selected").data("slntyp");
			var lv_slntblcod = $("#<?= $lv_sec; ?> #slsordmzo").data("slntblcod");
			var lv_pstdat =[{name:"sysdocclscod",value:$("#<?= $lv_sec; ?> #sysdocclscod").prop("value")},
											{name:"slncod",value:$("#<?= $lv_sec; ?> #slncod").prop("value")},
											{name:"slntyp",value:lv_slntyp},
											{name:"slntblcod",value:$("#<?= $lv_sec; ?> #slntblcod").prop("value")},
											{name:"slsordqty",value:$("#<?= $lv_sec; ?> #slsordqty").prop("value")},
											{name:"slsordsrv",value:$("#<?= $lv_sec; ?> #slsordsrv").prop("value")}
											];
			tmssCallProcess("?prg=gaspln&act=addOrder",lv_pstdat,function(data){
				<?= $lv_sec; ?>_showTable();
			});
		});
		
		// boton regresar en abrir mesa (lista)
		function <?= $lv_sec; ?>_tblOpnBack(){
			$("#<?= $lv_sec; ?> #slntblcodext").prop("value","");
      $("#<?= $lv_sec; ?> #btnordsnd").addClass("hidden");
			<?= $lv_sec; ?>_showTable();
		}
		
		
		
		// --------------------------------------------------------------
		//  BUSCAR MATERIAL
		// --------------------------------------------------------------
		
		// mattxt
		tmssLoadScript("typeahead",function(){
			$("#<?= $lv_sec; ?> #mattxt").typeahead({
				onSelectAjaxData: function(data){ 
					$("#<?= $lv_sec; ?> #mattxt").data("matcod",data.data.slsprcsrccod).
												data("mattxt",data.data.slsprcsrctxt).
												data("matuntcod",data.data.slsprcuntcod).
												data("matprc",Number(data.data.slsprc).toFixed(2)).
												data("curcod",data.data.curcod).
												data("matqty","1").
												data("matatr",data.data.slsprcsrcatr);
				},
				ajax: {
					url: "?prg=gaspln&act=getMaterialList",
					method: "post",
					displayField: "slsprcsrctxt",
					valueField: "slsprcsrctxt",
					timeout: 500, triggerLength: 1, loadingClass: "fas fa-spinner",
					preDispatch: function(query){ return {slsprclstcod:$("#<?= $lv_sec; ?> #slsprclstcod").prop("value"),
																								mattxt: query}; },
					preProcess: function(data){ return (data.length==0?false:data); }
				}
			});
		});
		
		// keydown en material
		$("#<?= $lv_sec; ?> #mattxt").on("keydown",function(e){
			if ( e.which==13 && $(this).data("matcod")!="" ) {
				var lv_dat=[{"matcod":$(this).data("matcod"),
											"mattxt":$(this).data("mattxt"),
											"matuntcod":$(this).data("matuntcod"),
											"matprc":$(this).data("matprc"),
											"curcod":$(this).data("curcod"),
											"matqty":$(this).data("matqty"),
											"matatr":$(this).data("matatr")
										}];
				<?= $lv_sec; ?>_setMat( lv_dat );
				<?= $lv_sec; ?>_clearMat();
				$("#<?= $lv_sec; ?> #mattxt").focus();
				e.preventDefault(); e.stopPropagation();
			} else if (e.which==27 && $(this).prop("value")==""){
				<?= $lv_sec; ?>_matClsBack(); 
			} else if (e.which==27 && $(this).prop("value")!=""){
				<?= $lv_sec; ?>_clearMat();
			}
		});
		
		// click en clasificacion (grilla)
		$("div[name=divmatcls]").on("click",function(e){ e.preventDefault();
			var lv_matclscod = $(this).data("matclscod");
			var lv_matclstxt = $(this).data("matclstxt");
			var lv_matclsimg = $(this).data("matclsimg");
			var lv_slsprclstcod = $("#<?= $lv_sec; ?> #slsprclstcod").prop("value");
			var lv_pstdat =[{name:"slsprclstcod",value:lv_slsprclstcod},
											{name:"matclscod",value:lv_matclscod}];
			tmssCallProcess("?prg=gaspln&act=getMaterialList",lv_pstdat,function(data){
				var lv_buffer = ""
				for(var i=0; i<data.length; i++) {
					lv_buffer += "<div class='col-sm-4 tmss-stkmat' name='stkmat' data-matcod='"+data[i].slsprcsrccod+"' data-mattxt='"+data[i].slsprcsrctxt+"' data-matqty='1' data-matuntcod='"+data[i].slsprcuntcod+"' data-matprc='"+Number(data[i].slsprc).toFixed(2)+"' data-curcod='"+data[i].curcod+"' data-matatr='"+data[i].slsprcsrcatr+"'>"+data[i].slsprcsrctxt+"<div class='pull-right'><small><strong>"+Number(data[i].slsprc).toFixed(2)+"</strong></small></div></div>"
				}
				$("#<?= $lv_sec; ?> #rowmat").addClass("hidden");
				$("#<?= $lv_sec; ?> #rowmatcls").addClass("hidden");
				$("#<?= $lv_sec; ?> #rowmatlst").removeClass("hidden");
				$("#<?= $lv_sec; ?> #rowmathdr span:first").html( "<i class='"+lv_matclsimg+"' style='padding-right: 10px;'></i> "+lv_matclstxt );
				$("#<?= $lv_sec; ?> #matlst").html( lv_buffer );

				// attach eventos
				$("#<?= $lv_sec; ?> div[name='stkmat']").on("click",function(e){e.preventDefault();
					$("#<?= $lv_sec; ?> #mattxt").
												data("matcod",$(this).data("matcod")).
												data("mattxt",$(this).data("mattxt")).
												data("matqty",$(this).data("matqty")).
												data("matuntcod",$(this).data("matuntcod")).
												data("matprc",$(this).data("matprc")).
												data("curcod",$(this).data("curcod")).
												data("matatr",$(this).data("matatr"));
					var lv_dat=[{"matcod":$(this).data("matcod"),
												"mattxt":$(this).data("mattxt"),
												"matuntcod":$(this).data("matuntcod"),
												"matprc":$(this).data("matprc"),
												"curcod":$(this).data("curcod"),
												"matqty":$(this).data("matqty"),
												"matatr":$(this).data("matatr")
											}];
					<?= $lv_sec; ?>_setMat( lv_dat );
				});
				
			});		
		});
		
		// boton regresar en clasificacion (lista)
		function <?= $lv_sec; ?>_matClsBack(){
			$("#<?= $lv_sec; ?> #slntblcodext").prop("value","");
			<?= $lv_sec; ?>_showTable();
		}
		
		// boton regresar en materiales (lista)
		function <?= $lv_sec; ?>_matLstBack(){
			<?= $lv_sec; ?>_hideAll();
			$("#<?= $lv_sec; ?> #rowmat").removeClass("hidden");
			$("#<?= $lv_sec; ?> #rowmatcls").removeClass("hidden");
			$("#<?= $lv_sec; ?> #mattxt").prop("value","").focus();
      $("#<?= $lv_sec; ?> a.btn-block").removeClass("btn-success");
		}		
		
		
		
		// --------------------------------------------------------------
		//  ATRIBUTOS
		// --------------------------------------------------------------
		
		// keydown en atributos (texto)
		$("#<?= $lv_sec; ?> #matatrtxt").on("keydown",function(e){
			if(e.which==13){ e.preventDefault(); e.stopPropagation(); $("#<?= $lv_sec; ?> #btnmatadd").trigger("click"); }
			if(e.which==27){ 
				<?= $lv_sec; ?>_clearMat();
				<?= $lv_sec; ?>_hideAll();
				$("#<?= $lv_sec; ?> #rowmat").removeClass("hidden"); 
				$("#<?= $lv_sec; ?> #rowmatcls").removeClass("hidden"); 
				$("#<?= $lv_sec; ?> #mattxt").focus(); 
			}
		});
		
		// boton agregar material con atributos
		$("#<?= $lv_sec; ?> #btnmatadd").on("click",function(e){ e.preventDefault();
			var lv_slsordmatcmt = "";
			var i=0;
			$("#<?= $lv_sec; ?> #matatrlst a.btn-success").each(function(e){
        lv_slsordmatcmt += "<matatr"+i+">"+$(this).text()+"</matatr"+i+"> / ";
				i++;
			});
			lv_slsordmatcmt = lv_slsordmatcmt.substring(0, lv_slsordmatcmt.length -2);
      
			if($("#<?= $lv_sec; ?> #matatrtxt").prop("value")!=""){
				lv_slsordmatcmt += "<matatrtxt>"+$("#<?= $lv_sec; ?> #matatrtxt").prop("value")+"</matatrtxt>";
			}
			$("#<?= $lv_sec; ?> #mattxt").data("slsordmatcmt",lv_slsordmatcmt);			
			var lv_dat=[{"matcod":$("#<?= $lv_sec; ?> #mattxt").data("matcod"),
										"mattxt":$("#<?= $lv_sec; ?> #mattxt").data("mattxt"),
										"matqty":$("#<?= $lv_sec; ?> #mattxt").data("matqty"),
										"matuntcod":$("#<?= $lv_sec; ?> #mattxt").data("matuntcod"),
										"matprc":$("#<?= $lv_sec; ?> #mattxt").data("matprc"),
										"curcod":$("#<?= $lv_sec; ?> #mattxt").data("curcod"),
										"matatr":"",
                   	"matatrqty":$("#<?= $lv_sec; ?> #matatrqty").val(),
										"slsordmatcmt":$("#<?= $lv_sec; ?> #mattxt").data("slsordmatcmt")
									}];
			lv_dat = lv_dat[0];
			
      // muestro boton "Enviar"
      if($("#<?= $lv_sec; ?> #btnordsnd").hasClass("hidden")){
        $("#<?= $lv_sec; ?> #btnordsnd").removeClass("hidden");
      }			
			
      if($("#<?= $lv_sec ;?> tr.bg-primary:not(.tktrowrej)[data-matcod="+lv_dat.matcod+"]").length>0){
        if(lv_dat.matatrqty>1){
          $("#<?= $lv_sec ;?> tr.bg-primary:not(.tktrowrej)[data-matcod="+lv_dat.matcod+"]").attr("data-matqty",parseInt($("#<?= $lv_sec ;?> tr.bg-primary:not(.tktrowrej)[data-matcod="+lv_dat.matcod+"]").attr("data-matqty"))+ parseInt(lv_dat.matatrqty));
          $("#<?= $lv_sec ;?> tr.bg-primary:not(.tktrowrej)[data-matcod="+lv_dat.matcod+"] td.tktqty").replaceWith("<td class='tktqty'>"+$("#<?= $lv_sec ;?> tr.bg-primary:not(.tktrowrej)[data-matcod="+lv_dat.matcod+"]").attr("data-matqty")+"</td>");
          $("#<?= $lv_sec ;?> tr.bg-primary:not(.tktrowrej)[data-matcod="+lv_dat.matcod+"] td.tkttot").replaceWith("<td class='tkttot'>"+$("#<?= $lv_sec ;?> tr.bg-primary:not(.tktrowrej)[data-matcod="+lv_dat.matcod+"]").attr("data-matqty")*lv_dat.matprc+"</td>"); 
        }else{
          $("#<?= $lv_sec ;?> tr.bg-primary:not(.tktrowrej)[data-matcod="+lv_dat.matcod+"]").attr("data-matqty",parseInt($("#<?= $lv_sec ;?> tr.bg-primary:not(.tktrowrej)[data-matcod="+lv_dat.matcod+"]").attr("data-matqty"))+1);
          $("#<?= $lv_sec ;?> tr.bg-primary:not(.tktrowrej)[data-matcod="+lv_dat.matcod+"] td.tktqty").replaceWith("<td class='tktqty'>"+$("#<?= $lv_sec ;?> tr.bg-primary:not(.tktrowrej)[data-matcod="+lv_dat.matcod+"]").attr("data-matqty")+"</td>");
          $("#<?= $lv_sec ;?> tr.bg-primary:not(.tktrowrej)[data-matcod="+lv_dat.matcod+"] td.tkttot").replaceWith("<td class='tkttot'>"+$("#<?= $lv_sec ;?> tr.bg-primary:not(.tktrowrej)[data-matcod="+lv_dat.matcod+"]").attr("data-matqty")*lv_dat.matprc+"</td>");
        }
      } else{
        var lv_atr = (lv_dat.slsordmatcmt==null?"":lv_dat.slsordmatcmt);
        if(lv_dat.matatrqty>1){
          $("#<?= $lv_sec; ?> #slsordmat tbody").append("<tr class='bg-primary' data-matcod='"+lv_dat.matcod+"' data-mattxt='"+lv_dat.mattxt+"' data-matqty='"+lv_dat.matatrqty+"' data-matuntcod='"+lv_dat.matuntcod+"' data-matprc='"+lv_dat.matprc+"' data-curcod='"+lv_dat.curcod+"' data-mattot='"+(lv_dat.matqty*lv_dat.matprc)+"' data-slsordmatcmt='"+lv_atr+"'>"+
                                                          "<td class='tktqty'>"+lv_dat.matatrqty+"</td>"+
                                                          "<td name='mattxt'>"+lv_dat.mattxt+(lv_atr!=""?"<br><small>"+lv_atr+"</small>":"")+"</td>"+
                                                          "<td class='tkttot'>"+(lv_dat.matatrqty*lv_dat.matprc)+"</td>"+
                                                          "<td class='tkttme'>&nbsp;</td>"+
                                                          "</tr>");
        }else{
            $("#<?= $lv_sec; ?> #slsordmat tbody").append("<tr class='bg-primary' data-matcod='"+lv_dat.matcod+"' data-mattxt='"+lv_dat.mattxt+"' data-matqty='"+lv_dat.matqty+"' data-matuntcod='"+lv_dat.matuntcod+"' data-matprc='"+lv_dat.matprc+"' data-curcod='"+lv_dat.curcod+"' data-mattot='"+(lv_dat.matqty*lv_dat.matprc)+"' data-slsordmatcmt='"+lv_atr+"'>"+
                                                          "<td class='tktqty'>"+lv_dat.matqty+"</td>"+
                                                          "<td name='mattxt'>"+lv_dat.mattxt+(lv_atr!=""?"<br><small>"+lv_atr+"</small>":"")+"</td>"+
                                                          "<td class='tkttot'>"+(lv_dat.matqty*lv_dat.matprc)+"</td>"+
                                                          "<td class='tkttme'>&nbsp;</td>"+
                                                          "</tr>");
        }
				
        // attach evento (a la última línea agregada)
        $("#<?= $lv_sec ;?> #slsordmat tbody tr:last").on("click",function(e){ e.preventDefault(); <?= $lv_sec; ?>_editRow( $(this) ); });
				
				// inicializo selector de articulos
        <?= $lv_sec; ?>_clearMat();
				
				// recalculo totales
				var lv_tot = 0;
				$("#<?= $lv_sec; ?> #slsordmat .tkttot").each( function(){ lv_tot += Number( $(this).html() ); });
				$("#<?= $lv_sec; ?> #slsordtot .tkttot").html( Number(lv_tot).toFixed(2) );

				
        toastr.success("Material agregado.");
      }
      
			<?= $lv_sec; ?>_clearMat();
			<?= $lv_sec; ?>_hideAll();
			$("#<?= $lv_sec; ?> #rowmat").removeClass("hidden");
			$("#<?= $lv_sec; ?> #rowmatcls").removeClass("hidden");
			$("#<?= $lv_sec; ?> #mattxt").focus();
		});
		
		
		
		// --------------------------------------------------------------
		//  EDITAR POSICION
		// --------------------------------------------------------------
		
		// edita la fila seleccionada
		function <?= $lv_sec; ?>_editRow( lp_row ) {
			<?= $lv_sec; ?>_hideAll();
      $("#<?= $lv_sec; ?> #matatrqty").val($(lp_row).data("matqty"));
			$("#<?= $lv_sec; ?> #slsordmat tbody tr").removeClass("tktrowsel");
			$("#<?= $lv_sec; ?> #btnmatupddel").addClass("hidden");
      $("#<?= $lv_sec; ?> #matatrqty").addClass("hidden"); 
      $("#<?= $lv_sec; ?> #matatrqtylbl").addClass("hidden");
			$( lp_row ).addClass("tktrowsel");
			$("#<?= $lv_sec; ?> #rowslsordmathdr span:first").text( $(lp_row).data("mattxt") );
			$("#<?= $lv_sec; ?> #slsordmatcod").prop("value",$(lp_row).data("slsordmatcod"));
			$("#<?= $lv_sec; ?> #mattxthde2").prop("value",$(lp_row).data("mattxt"));
			var lv_slsordmatcmt = $(lp_row).data("slsordmatcmt");
			$("#<?= $lv_sec; ?> #matatrtxt2").prop("value",$("<div>"+lv_slsordmatcmt+"</div>").find("matatrtxt").text());
			$("#<?= $lv_sec;?> #matrejcod").prop("value","");
			
			// obtengo atributos del material
			var lv_pstdat3 = [{name:"slsprclstcod", value:$("#<?= $lv_sec; ?> #slsprclstcod").prop("value")},
												{name:"matcod",value:$(lp_row).data("matcod")}];
			tmssCallProcess("?prg=gaspln&act=getMaterialList",lv_pstdat3,function(data){
				var lv_matatr = data[0].slsprcsrcatr;
				if( lv_matatr!=null ) {
					lv_matatr = "<div>"+lv_matatr+"</div>";
					var lv_matcmt = "<div>"+$("#<?= $lv_sec; ?> #slsordmat tbody tr.tktrowsel").data("slsordmatcmt")+"</div>";
					var lv_found = false;
          var lv_keys = [];
          var lv_options=[];
          for(var i=0; $(lv_matatr).find("atr"+i).length!=0; i++){
            if(!lv_keys.includes( $(lv_matatr).find("atr"+i).find("matatrnme").text() ) ){
              lv_keys.push( $(lv_matatr).find("atr"+i).find("matatrnme").text() );
            }
          }

          for(var i=0; i < lv_keys.length; i++){
            lv_options += "<div class='col-xs-"+parseInt(12/lv_keys.length)+" text-center'><h5><b>"+lv_keys[i]+"</b></h5>";
            for(var j=0; $(lv_matatr).find("atr"+j).length!=0; j++){
              if( $(lv_matatr).find("atr"+j).find("matatrnme").text() == lv_keys[i] ){
                lv_found = false;
                for(var x=0; $(lv_matcmt).find("matatr"+x).length>0; x++){
                  if( $(lv_matcmt).find("matatr"+x).text()==$(lv_matatr).find("atr"+j).find("matatrval").text() ){ lv_found = true; }
                }
                lv_options += "<a href='#' class='btn "+(lv_found==true?"btn-success":"btn-default")+" btn-block'>"+$(lv_matatr).find("atr"+j).find("matatrval").text()+"</a>";
              }
            }
            lv_options += "</div>";    
          }
           
					$("#<?= $lv_sec; ?> #matatrlst2").html(lv_options);
					$("#<?= $lv_sec; ?> #rowmatatrlst2").removeClass("hidden");
					
					// attach eventos en boton de atributos
					$("#<?= $lv_sec; ?> #matatrlst2 a").on("click",function(e){ e.preventDefault();
						if($(this).hasClass("btn-success")){
							$(this).addClass("btn-default").removeClass("btn-success");
						} else {
							$(this).addClass("btn-success").removeClass("btn-default");
						}
					});
				} else {
					$("#<?= $lv_sec; ?> #rowmatatrlst2").addClass("hidden");
				}								
			});
			if( $(lp_row).data("slsordmatcod")!="" && $(lp_row).data("slsordmatcod")!=undefined ){ 
				if($(lp_row).data("sysdocrejcod")!=""){
					$("#<?= $lv_sec; ?> #matrejcod option[value="+$(lp_row).data("sysdocrejcod")+"]").prop("selected",true);
				}
				$("#<?= $lv_sec; ?> #rowmatrej").removeClass("hidden");
			} else {
				$("#<?= $lv_sec; ?> #btnmatupddel").removeClass("hidden");
        $("#<?= $lv_sec; ?> #matatrqty").removeClass("hidden"); 
      	$("#<?= $lv_sec; ?> #matatrqtylbl").removeClass("hidden");
				$("#<?= $lv_sec; ?> #rowmatrej").addClass("hidden");
			}			
			$("#<?= $lv_sec; ?> #matatrtxt2").prop("value",$(lp_row).data("slsordmatslstxt"));
			$("#<?= $lv_sec; ?> #rowslsordmat").removeClass("hidden");
		}
		
		// boton borrar posicion
		$("#<?= $lv_sec; ?> #btnmatupddel").on("click",function(e){ e.preventDefault();
			$("#<?= $lv_sec; ?> #slsordmat tbody tr.tktrowsel").remove();
			<?= $lv_sec; ?>_matLstBack();
		});
		
		// boton actualizar posicion
		$("#<?= $lv_sec; ?> #btnmatupd").on("click",function(e){ e.preventDefault();
			var lv_slsordmatcmt = "";
			var i=0;
			$("#<?= $lv_sec; ?> #matatrlst2 a.btn-success").each(function(e){
				lv_slsordmatcmt += "<matatr"+i+">"+$(this).text()+"</matatr"+i+"> / ";
				i++;
			});
			lv_slsordmatcmt = lv_slsordmatcmt.substring(0, lv_slsordmatcmt.length -2);
			if($("#<?= $lv_sec; ?> #matatrtxt2").prop("value")!=""){
				lv_slsordmatcmt += "<matatrtxt>"+$("#<?= $lv_sec; ?> #matatrtxt2").prop("value")+"</matatrtxt>";
			}
			
			var lv_slsordmatcod = $("#<?= $lv_sec; ?> #slsordmat tbody tr.tktrowsel").data("slsordmatcod");
			if(lv_slsordmatcod!="" && lv_slsordmatcod!=undefined){
				// actualizar material del pedido
				var lv_pstdat=[ {name:"slsordcod",value:$("#<?= $lv_sec;?> #slsordcod").prop("value")},
												{name:"slsordmatcod",value:lv_slsordmatcod},
												{name:"slsordmatcmt",value:lv_slsordmatcmt},
												{name:"sysdocrejcod",value:$("#<?= $lv_sec;?> #matrejcod").prop("value")}
											];
				tmssCallProcess("?prg=gasPln&act=updMaterial",lv_pstdat,function(data){
					$("#<?= $lv_sec; ?> #btnordsnd").addClass("hidden");
					<?= $lv_sec; ?>_clearMat();
					<?= $lv_sec; ?>_showTable();
          
				});
			} else {
				// actualizar datos de fila
				var lv_mattxt = $("#<?= $lv_sec; ?> #slsordmat tbody tr.tktrowsel").data("mattxt");
				$("#<?= $lv_sec; ?> #slsordmat tbody tr.tktrowsel").data("matatr");        
        $("#<?= $lv_sec ;?> #slsordmat tbody tr.tktrowsel").data("matqty", $("#<?= $lv_sec; ?> #rowslsordmat #matatrqty").prop("value") );
        $("#<?= $lv_sec ;?> #slsordmat tbody tr.tktrowsel").data("mattot", Number($("#<?= $lv_sec; ?> #rowslsordmat #matatrqty").prop("value")) *  Number($("tr.tktrowsel").data("matprc")) );
        $("#<?= $lv_sec ;?> #slsordmat tbody tr.tktrowsel td.tktqty").replaceWith("<td class='tktqty'>"+ $("#<?= $lv_sec; ?> #rowslsordmat #matatrqty").prop("value") +"</td>");
        $("#<?= $lv_sec ;?> #slsordmat tbody tr.tktrowsel td.tkttot").replaceWith("<td class='tkttot'>"+ Number($("#<?= $lv_sec; ?> #rowslsordmat #matatrqty").prop("value")) *  Number($("tr.tktrowsel").data("matprc")) +"</td>");
        $("#<?= $lv_sec ;?> #slsordmat tbody tr.tktrowsel").data("slsordmatcmt",lv_slsordmatcmt);
				$("#<?= $lv_sec ;?> #slsordmat tbody tr.tktrowsel td[name=mattxt]").html(lv_mattxt+(lv_slsordmatcmt!=""?"<br><small>"+lv_slsordmatcmt+"</small>":""));
			}
			<?= $lv_sec; ?>_matLstBack();
		});
		
		
		
		// --------------------------------------------------------------
		//  ENVIAR
		// --------------------------------------------------------------
		
		// fija atributos de material
		function <?= $lv_sec; ?>_setMat( lp_dat ) {
			var lv_dat = lp_dat[0];
      <?= $lv_sec; ?>_hideAll();
      $("#<?= $lv_sec; ?> #rowmatatr").removeClass("hidden");
      var lv_keys = [];
      var lv_options=[];
      for(var i=0; $("<div>"+lv_dat.matatr+"</div>").find("atr"+i).length!=0; i++){
        if(!lv_keys.includes( $("<div>"+lv_dat.matatr+"</div>").find("atr"+i).find("matatrnme").text() ) ){
          lv_keys.push( $("<div>"+lv_dat.matatr+"</div>").find("atr"+i).find("matatrnme").text() );
        }
      }

      for(var i=0; i < lv_keys.length; i++){
        lv_options += "<div class='col-xs-"+parseInt(12/lv_keys.length)+" text-center'><h5><b>"+lv_keys[i]+"</b></h5>";
        for(var j=0; $("<div>"+lv_dat.matatr+"</div>").find("atr"+j).length!=0; j++){
          if( $("<div>"+lv_dat.matatr+"</div>").find("atr"+j).find("matatrnme").text() == lv_keys[i] ){
            lv_options += "<a href='#' class='btn btn-default btn-block'>"+$("<div>"+lv_dat.matatr+"</div>").find("atr"+j).find("matatrval").text()+"</a>";
          }
        }
        lv_options += "</div>";    
      }
      $("#<?= $lv_sec; ?> #matatrlst").html(lv_options);

      // attach eventos
      $("#<?= $lv_sec; ?> #matatrlst a").on("click",function(e){ e.preventDefault();
        if($(this).hasClass("btn-success")){
          $(this).addClass("btn-default").removeClass("btn-success");
        } else {
          $(this).addClass("btn-success").removeClass("btn-default");
        }
      });
      $("#<?= $lv_sec; ?> #mattxthde").prop("value", lv_dat.mattxt);
      $("#<?= $lv_sec; ?> #rowmatatrlst").removeClass("hidden");
      //$("#<?= $lv_sec; ?> #matatrtxt").focus();
      $("#<?= $lv_sec; ?> #matatrqty").focus();
		}
		//}
		$("#<?= $lv_sec; ?> #matatrqty").on("keydown",function(e){if(e.which==13){$("#<?= $lv_sec; ?> #btnmatadd").focus();}});

		// inicializa los campos del material
		function <?= $lv_sec; ?>_clearMat(){
			$("#<?= $lv_sec; ?> #mattxt").data("matcod","").
																					data("mattxt","").
																					data("matuntcod","").
																					data("matprc","").
																					data("curcod","").
																					data("matqty","").
																					data("matatr","").
																					data("slsordmatcmt","").
																					prop("value","");
			$("#<?= $lv_sec; ?> #matatrtxt").prop("value","");
      $("#<?= $lv_sec; ?> #matatrqty").prop("value",1);
      $("#<?= $lv_sec; ?> #matatrqty").removeClass("hidden");
		}
		
		// boton enviar materiales (impresión de comandas)
		$("#<?= $lv_sec; ?> #btnordsnd").on("click",function(e){ e.preventDefault();
			if ( $("#<?= $lv_sec; ?> #slsprclstcod").prop("value")!="" ){
				var lv_pstdat=[];
				$("#<?= $lv_sec; ?> #slsordmat tbody tr.bg-primary").each(function(e){
					lv_pstdat.push({slsordcod:$("#<?= $lv_sec; ?> #slsordcod").prop("value"),
													matcod:$(this).data("matcod"),
													mattxt:$(this).data("mattxt"),
													matqty:$(this).data("matqty"),
													matuntcod:$(this).data("matuntcod"),
													matprc:$(this).data("matprc"),
													mattot:$(this).data("mattot"),
													curcod:$(this).data("curcod"),
													slsordmatcmt:$(this).data("slsordmatcmt")
					});
				});
				var lv_pstdatjsn = [{name:"data",value:JSON.stringify( lv_pstdat )}];
				tmssCallProcess("?prg=gaspln&act=addMaterial",lv_pstdatjsn,function(data){
					// FALTA: definir si imprime comanda (ajustar clasficacion de stocks)
					toastr.success("Pedido enviado.");
					$("#<?= $lv_sec; ?> #btnordsnd").addClass("hidden");
					<?= $lv_sec; ?>_clearMat();
					<?= $lv_sec; ?>_showTable();
				});
			} else {
				toastr.warning("No se determino lista de precios para el pedido.");
			}
		});		
		
		
		
		// --------------------------------------------------------------
		//  OPCIONES PEDIDO
		// --------------------------------------------------------------

		// boton opciones (navbar)
		$("#<?= $lv_sec; ?> #btnordopt").on("click",function(e){
			$("#<?= $lv_sec; ?> #rowslsordclshdr span:first").text(" MESA "+$("#<?= $lv_sec; ?> #slntblcodext").prop("value")+" - OPCIONES");
			<?= $lv_sec; ?>_hideAll();
			$("#<?= $lv_sec; ?> #btnslsordinv").removeClass("tmss-table-orddsb");
			$("#<?= $lv_sec; ?> #btnslsordcre").addClass("tmss-table-orddsb");
			$("#<?= $lv_sec; ?> #btnslsordcob").removeClass("tmss-table-orddsb");
			$("#<?= $lv_sec; ?> #btnslsordcte").removeClass("tmss-table-orddsb");
			$("#<?= $lv_sec; ?> #btnslsordund").removeClass("tmss-table-orddsb");
			$("#<?= $lv_sec; ?> #btnslsordcls").addClass("tmss-table-orddsb");
			if( $("#<?= $lv_sec; ?> #docsts").prop("value").indexOf("P")>=0 || $("#<?= $lv_sec; ?> #docsts").prop("value").indexOf("C")>=0 ){
				$("#<?= $lv_sec; ?> #btnslsordcob").addClass("tmss-table-orddsb");
				$("#<?= $lv_sec; ?> #btnslsordcte").addClass("tmss-table-orddsb");
				$("#<?= $lv_sec; ?> #btnslsordund").addClass("tmss-table-orddsb");
				$("#<?= $lv_sec; ?> #btnslsordcls").removeClass("tmss-table-orddsb");
			}
			if( $("#<?= $lv_sec; ?> #docsts").prop("value").indexOf("I")>=0 ){
				$("#<?= $lv_sec; ?> #btnslsordcre").removeClass("tmss-table-orddsb");
				$("#<?= $lv_sec; ?> #btnslsordinv").addClass("tmss-table-orddsb");
				$("#<?= $lv_sec; ?> #btnslsordund").addClass("tmss-table-orddsb");
				$("#<?= $lv_sec; ?> #btnslsordcls").removeClass("tmss-table-orddsb");
			}			
			$("#<?= $lv_sec; ?> #rowslsordcls").removeClass("hidden");
		});
		
		// boton cerrar opciones
		function <?= $lv_sec ;?>_slsOptBack(){
			if( $("#<?= $lv_sec; ?> #docsts").prop("value")=="A" ) {
				<?= $lv_sec; ?>_matLstBack();
			} else {
				<?= $lv_sec; ?>_matClsBack();
			}
		}
		
		// PRE-CUENTA
		$("#<?= $lv_sec; ?> #btnslsordpre").on("click",function(e){ e.preventDefault();
			if($(this).hasClass("tmss-table-orddsb")){return false;}
			toastr.success("Pre-Cuenta impresa.");
		});
		
		// FACTURA
		$("#<?= $lv_sec; ?> #btnslsordinv").on("click",function(e){ e.preventDefault();		
			if($(this).hasClass("tmss-table-orddsb")){return false;}
			var lv_pstdat = [{name:"slsordcod",value:$("#<?= $lv_sec; ?> #slsordcod").prop("value")}];
			tmssCallProcess("?prg=gaspln&act=invOrder",lv_pstdat,function(data){
				$("#<?= $lv_sec; ?> #slntblcodext").prop("value","");
				<?= $lv_sec; ?>_showTable();
				toastr.success("Pedido Facturado.");
				$("#<?= $lv_sec; ?> #slntblcodext").focus();				
			});
		});
		
		// NOTA DE CREDITO
		$("#<?= $lv_sec; ?> #btnslsordcre").on("click",function(e){ e.preventDefault();		
			if($(this).hasClass("tmss-table-orddsb")){return false;}
			var lv_pstdat = [{name:"slsordcod",value:$("#<?= $lv_sec; ?> #slsordcod").prop("value")}];
			tmssCallProcess("?prg=gaspln&act=creOrder",lv_pstdat,function(data){
				$("#<?= $lv_sec; ?> #slntblcodext").prop("value","");
				<?= $lv_sec; ?>_showTable();
				toastr.success("Nota de Credito emitida.");
				$("#<?= $lv_sec; ?> #slntblcodext").focus();				
			});
		});
		
		// CUENTA CORRIENTE
		$("#<?= $lv_sec; ?> #btnslsordcte").on("click",function(e){ e.preventDefault();		
			if($(this).hasClass("tmss-table-orddsb")){return false;}
			var lv_pstdat = [{name:"slsordcod",value:$("#<?= $lv_sec; ?> #slsordcod").prop("value")}];
			tmssCallProcess("?prg=gaspln&act=cteOrder",lv_pstdat,function(data){
				$("#<?= $lv_sec; ?> #slntblcodext").prop("value","");
				<?= $lv_sec; ?>_showTable();
				toastr.success("Pedido enviado a Cuenta Corriente.");
				$("#<?= $lv_sec; ?> #slntblcodext").focus();				
			});
		});
		
		// COBRAR
		$("#<?= $lv_sec; ?> #btnslsordcob").on("click",function(e){ e.preventDefault();
			if($(this).hasClass("tmss-table-orddsb")){return false;}
			$("#<?= $lv_sec; ?> #rowslsordcls").addClass("hidden");
			$("#<?= $lv_sec; ?> #rowslsordpay").removeClass("hidden");
			
                                                               
			tmssCallProcess("?prg=gaspln&act=getPayMth",[],function(data){
				lv_buffer = "<tr class='bg-primary' style='font-size:24px;'><td>TOTAL A COBRAR</td><td align='right' style='font-weight: bold;' id='txtpayord'></td></tr>";
        for(var i = 0; i < data.data.length; i++){
          lv_buffer += "<tr><td>"+data.data[i].paymthtxt+"</td><td align='right'><input type='number' min='0' max='99999' class='form-control' value='' name='txtpaymth'></td></tr>"
        }
        lv_buffer += "<tr class='bg-primary' style='font-size: 24px;'><td>VUELTO</td><td align='right' style='font-weight: bold;' id='txtpaytot'></td></tr>";
        $("#<?= $lv_sec; ?> #rowslsordpay table tbody").empty().append(lv_buffer);
        
        $("#<?= $lv_sec; ?> #txtpayord").text( $("#<?= $lv_sec; ?> #slsordtot .tkttot").text() );
        $("#<?= $lv_sec; ?> #txtpaytot").text( "" );
        $("#<?= $lv_sec; ?> input[name=txtpaymth]").prop("value","");
        $("#<?= $lv_sec; ?> input[name=txtpaymth]").first().focus();
        
        // efectivo - keyup
        $("#<?= $lv_sec; ?> input[name=txtpaymth]").on("keyup",function(e){
          var lv_ord = Number( $("#<?= $lv_sec; ?> #slsordtot .tkttot").text() );
          var lv_totpay = 0;
          $("#<?= $lv_sec; ?> input[name=txtpaymth]").each(function(){
            lv_totpay += Number( $(this).val() );
          });
          var lv_tot = lv_ord - lv_totpay;
          lv_tot = ( lv_tot < 0 ? lv_tot * -1 : 0 );
          $("#<?= $lv_sec; ?> #txtpaytot").text( lv_tot.toFixed(2) );
        });

        // efectivo - keydown
        $("#<?= $lv_sec; ?> input[name=txtpaymth]").on("keydown",function(e){
          if(e.which==13){
            lv_index = $("#<?= $lv_sec; ?> input[name=txtpaymth]").index(this);
            if( lv_index < $("#<?= $lv_sec; ?> input[name=txtpaymth]").length - 1){
              $($("#<?= $lv_sec; ?> input[name=txtpaymth]")[lv_index+1]).focus();
            }else{
              $("#<?= $lv_sec; ?> #btnpay").focus();
            }
          }
          if(e.which==27){ <?= $lv_sec; ?>_hideAll(); $("#<?= $lv_sec; ?> #rowmat").removeClass("hidden"); $("#<?= $lv_sec; ?> #rowmatcls").removeClass("hidden"); }
        });
			});
      //"<tr><td><i class='fas fa-money-bill-wave'></i> Efectivo</td><td align='right'><input type='number' min='0' max='99999' class='form-control' value='' id='txtpayeft' ></td></tr>"
      //"<tr><td><i class='fas fa-credit-card'></i> Tarjeta</td><td align='right'><input type='number' min='0' max='99999' class='form-control' value='' id='txtpaytjt'></td></tr>"
      //"<tr><td><i class='far fa-handshake'></i> Descuento</td><td align='right'><input type='number' min='0' max='99999' class='form-control' value='' id='txtpaydes'></td></tr>"
                                                               
                                                               
		});
		
		// DESHACER CUENTA
		$("#<?= $lv_sec; ?> #btnslsordund").on("click",function(e){ e.preventDefault();
			if($(this).hasClass("tmss-table-orddsb")){return false;}
			BootstrapDialog.show({
				type: BootstrapDialog.TYPE_WARNING,
				title: "Borrar Pedido",
				message: "Desea borrar el pedido de la mesa?",
				buttons: [{ label: "No", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
									{	label: "Si", cssClass: "btn-success",	action: function(dialogItself){
										var lv_pstdat = [{name:"slsordcod",value:$("#<?= $lv_sec; ?> #slsordcod").prop("value")}];
										tmssCallProcess("?prg=gaspln&act=delOrder",lv_pstdat,function(data){
											$("#<?= $lv_sec; ?> #slntblcodext").prop("value","");
											<?= $lv_sec; ?>_showTable();
											toastr.success("Pedido borrado.");
											dialogItself.close();
											$("#<?= $lv_sec; ?> #slntblcodext").focus();
										});
									}}]
			});
		});
		
		// CERRAR
		$("#<?= $lv_sec; ?> #btnslsordcls").on("click",function(e){ e.preventDefault();		
			if($(this).hasClass("tmss-table-orddsb")){return false;}
			var lv_pstdat = [{name:"slncod",value:$("#<?= $lv_sec; ?> #slncod").val()},{name:"sysdocclscod",value:$("#<?= $lv_sec; ?> #sysdocclscod").val()},{name:"slsordcod",value:$("#<?= $lv_sec; ?> #slsordcod").prop("value")}];
			tmssCallProcess("?prg=gaspln&act=relOrder",lv_pstdat,function(data){
				$("#<?= $lv_sec; ?> #slntblcodext").prop("value","");
				<?= $lv_sec; ?>_showTable();
				toastr.success("Mesa cerrada/liberada.");
				$("#<?= $lv_sec; ?> #slntblcodext").focus();				
			});
		});
		
		
		
		// --------------------------------------------------------------
		//  COBRAR PEDIDO
		// --------------------------------------------------------------
		
		// boton cobrar
		$("#<?= $lv_sec; ?> #btnpay").on("click",function(e){ e.preventDefault();
			var lv_ord = Number( $("#<?= $lv_sec; ?> #slsordtot .tkttot").text() );
			var lv_totpay = 0;
     	$("#<?= $lv_sec; ?> input[name=txtpaymth]").each(function(){
        lv_totpay += Number( $(this).val() );
      });
			/*var lv_eft = Number( $("#<?= $lv_sec; ?> #txtpayeft").prop("value") );
			var lv_tjt = Number( $("#<?= $lv_sec; ?> #txtpaytjt").prop("value") );
			var lv_des = Number( $("#<?= $lv_sec; ?> #txtpaydes").prop("value") );*/
			/*if( lv_ord < lv_des ) { 
				toastr.warning("Descuento excedido."); 
				$("#<?= $lv_sec; ?> #txtpaydes").focus();
				return false; 
			}*/
			if( lv_ord > lv_totpay ) { 
				toastr.warning("Saldo insuficiente."); 
				$("#<?= $lv_sec; ?> input[name=txtpaymth]").first().focus();
				return false; 
			}
			var lv_pstdat = [{name:"slsordcod",value:$("#<?= $lv_sec; ?> #slsordcod").prop("value")}];
			tmssCallProcess("?prg=gaspln&act=payOrder",lv_pstdat,function(data){
				$("#<?= $lv_sec; ?> #slntblcodext").prop("value","");
				<?= $lv_sec; ?>_showTable();
				toastr.success("Pedido cobrado.");
				$("#<?= $lv_sec; ?> #slntblcodext").focus();				
			});
		});
		
		
		
		// --------------------------------------------------------------
		//  
		// --------------------------------------------------------------
		
		// mostrar / ocultar cuenta (xs devices)
		$("#<?= $lv_sec; ?> #btnordshw").on("click",function(e){ e.preventDefault();
			if( $("#<?= $lv_sec; ?> #colord").hasClass("hidden-xs") ) {
				$(this).removeClass("btn-default").addClass("btn-primary");
				$("#<?= $lv_sec; ?> #colord").removeClass("hidden-xs");
				$("#<?= $lv_sec; ?> #colmat").addClass("hidden-xs");
			} else {
				$(this).addClass("btn-default").removeClass("btn-primary");
				$("#<?= $lv_sec; ?> #colord").addClass("hidden-xs");
				$("#<?= $lv_sec; ?> #colmat").removeClass("hidden-xs");
			}
		});
		
		// oculta todos los frames
		function <?= $lv_sec; ?>_hideAll() {
			$("#<?= $lv_sec; ?> #btnordsnd").addClass("tktrowsel");
      $("#<?= $lv_sec; ?> #matatrqty").prop("value",1);
      $("#<?= $lv_sec; ?> #matatrqty").removeClass("hidden"); 
			$("#<?= $lv_sec; ?> #matatrqtylbl").removeClass("hidden"); 
			$("#<?= $lv_sec; ?> #slsordmat tbody tr").removeClass("tktrowsel");
			$("#<?= $lv_sec; ?> #rowslntbl").addClass("hidden");
			$("#<?= $lv_sec; ?> #rowmat").addClass("hidden");
			$("#<?= $lv_sec; ?> #rowmatcls").addClass("hidden");
			$("#<?= $lv_sec; ?> #rowmatlst").addClass("hidden");
			$("#<?= $lv_sec; ?> #rowmatatr").addClass("hidden");
			$("#<?= $lv_sec; ?> #rowtblopn").addClass("hidden");
			$("#<?= $lv_sec; ?> #rowslsordmat").addClass("hidden");
			$("#<?= $lv_sec; ?> #rowslsordcls").addClass("hidden");
			$("#<?= $lv_sec; ?> #rowslsordpay").addClass("hidden");
		}
	</script>
</section>
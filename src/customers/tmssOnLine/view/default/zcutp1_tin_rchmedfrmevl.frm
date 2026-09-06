<?php
	if($vew_data->evl->hhcc==true) {
		// url del formulario 
		$lv_lnk = '?prg=zcutp1_tin&prm_patcod='.$vew_data->patcod.'&prm_evlcod='.$vew_data->evl->evlcod;

		// campos requeridos 
		$vew_input->RequiredFields( array() );

		// clave del documento 
		$lv_dockey = $vew_data->evl->evlcod; 

		// titulo 
		$lv_title = $vew_lang->form;
		
		// módulo y programa 
		$lv_mdlcod = 'HLT';
		$lv_prgcod = 'EVL';
    
    // librería de estilos bootstrap 
		include_once('_library.frm');

		$lv_frm_om = '';
		$lv_frm_hc = '';
		$lv_frm_ci = '';
		if($vew_data->evl->evlcod != ''){
			foreach ($vew_sgndoc as $lv_row) {
				switch( $lv_row['sgndocsrccod002'] ){
					case 'OM': $lv_frm_om = $lv_row['flecod']; break;
					case 'HHCC': $lv_frm_hc = $lv_row['flecod']; break;
					case 'CI': $lv_frm_ci = $lv_row['flecod']; break;
				}
			}
		}
		
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <?php if($vew_data->evl->hhcc==true) { ?>
    <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
      <div class="container-fluid">
        <ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
					<!-- Firmar -->
					<?php if($vew_data->prs->prscod!='' && $vew_data->evl->evlcod!=''){ include('admsgnbtn.frm'); } ?>
          <!--Dropdown-->
          <div class="btn-group dropdown">
            <a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><span class="fas fa-ellipsis-v"></span></a>
            <form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
              <!--Actualizar-->
              <li><a href="#" onclick="<?= $lv_sec; ?>_GridRefresh();" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
							<!--Orden medica-->
							<li><a href="#" name="btnfrm" data-frm="om" class="tmssLink" data-flecod="<?= $lv_frm_om; ?>"><i style="width:20px" class="<?= ($lv_frm_om!=''?'fas fa-file-signature':'fas fa-print'); ?>"></i><?= 'Orden M&eacutedica' ?></a></li>
							<!--Historia clinica-->
							<li><a href="#" name="btnfrm" data-frm="hc" class="tmssLink" data-flecod="<?= $lv_frm_hc; ?>"><i style="width:20px" class="<?= ($lv_frm_hc!=''?'fas fa-file-signature':'fas fa-print'); ?>"></i><?= $vew_lang->medicalHistory ?></a></li>
							<!--Consentimiento informado-->
							<li><a href="#" name="btnfrm" data-frm="ci" class="tmssLink" data-flecod="<?= $lv_frm_ci; ?>"><i style="width:20px" class="<?= ($lv_frm_ci!=''?'fas fa-file-signature':'fas fa-print'); ?>"></i><?= 'Consentimiento' ?></a></li>
            </form>
          </div>
          <!--Cerrar-->
          <a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn tmss-navbar-btn navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
        </ul>
      </div>
    </nav>
  <?php } ?>

  <div class="container-fluid">
		<?= ($vew_data->evl->hhcc==true?'<form method="POST" class="form-horizontal tmss-form-horizontal" id="'.$lv_sec.'_frm"><input type="hidden" id="tmss_actcod" name="tmss_actcod" value=""><input type="hidden" id="hhcc" name="hhcc" value="X">':''); ?>
		<div class="container-fluid" role="tabpanel">
			<?php if($vew_data->evl->hhcc==true) { ?>
				<ul class="nav nav-tabs" role="tablist">
					<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
					<li class="pull-right"><h4># <strong><?= $vew_data->evl->evlcod; ?><input type="hidden" id="evlcod" name="evlcod" value="<?= $vew_data->evl->evlcod; ?>"></strong></h4></li>
				</ul>
			<?php } ?>
			<div class= "tab-content tmss-tab-content" >
				<!-- GENERAL -->
				<div class="row">
					<div class="col-md-6">
						<?php
							echo vew_boot($lv_col210, array('label'=>'Insituci&oacuten de '.$vew_lang->reference,'input'=>gethtml('evlatrref','doccmt1x50', $vew_doc->getTagValue($vew_data->evl->evlatr001,'ref'),$lv_default) ));  
							echo vew_boot($lv_col210, array('label'=>'Indicaci&oacute;n', 'input'=>vew_boot(	array('style'=>'search', 'readonly'=> $vew_readonly), 
																	array('input'=>gethtml('hltdisclstxt', 'typeahead', $vew_doc->getTagValue($vew_data->evl->evlatr001,'hltdisclstxt'), $lv_default) ))));
							echo '<input type="hidden" id="hltdisclscod" name="hltdisclscod" value="'.$vew_data->evl->hltdisclscod.'">';
							echo vew_boot($lv_col210, array('label'=>$vew_lang->tradeName, 
							'input'=>vew_boot(	array('style'=>'search', 'readonly'=> $vew_readonly), 
																	array('input'=>gethtml('mattxt', 'typeahead', $vew_doc->getTagValue($vew_data->evl->evlatr001,'mattxt'), $lv_default) ))));
							echo '<input type="hidden" id="matcodext" name="matcodext" value="'.$vew_doc->getTagValue($vew_data->evl->evlatr001,'matcodext').'">';
							echo '<input type="hidden" id="matcod" name="matcod" value="'.$vew_doc->getTagValue($vew_data->evl->evlatr001,'matcod').'">';
							echo vew_boot($lv_col210, array('label'=>$vew_lang->drug,'input'=>gethtml('evlatrdrg','doccmt1x50', $vew_doc->getTagValue($vew_data->evl->evlatr001,'drg'),$lv_default) ));
							echo vew_boot($lv_col210, array('label'=>'Dosis indicada','input'=>gethtml('evlatrdos','doccmt1x50', $vew_doc->getTagValue($vew_data->evl->evlatr001,'dos'),$lv_default) )); 
							echo vew_boot($lv_col210, array('label'=>'Cant. Viales','input'=>gethtml('evlatrcntv','doccmt1x50', $vew_doc->getTagValue($vew_data->evl->evlatr001,'cntv'),$lv_default) ));
							echo vew_boot($lv_col210, array('label'=>$vew_lang->frequency.' ('.$vew_lang->days.')','input'=>gethtml('evlatrfre','doccmt1x50', $vew_doc->getTagValue($vew_data->evl->evlatr001,'fre'),$lv_default) )); 
							echo vew_boot($lv_col210, array('label'=>'Modo de '.$vew_lang->administration,'input'=>gethtml('evlatrmadm', array('' => '', 'IV' => 'IV', 'IM' => 'IM', 'SC' => 'SC'), $vew_doc->getTagValue($vew_data->evl->evlatr001,'madm'), $lv_default, true) )); 
							echo vew_boot($lv_col210, array('label'=>'Tiempo de '.$vew_lang->administration,'input'=>gethtml('evlatrtadm','doccmt1x50', $vew_doc->getTagValue($vew_data->evl->evlatr001,'tadm'),$lv_default) )); 
							echo vew_boot($lv_col210, array('label'=>'Diluci&oacute;n','input'=>gethtml('evlatrdil','doccmt1x50', $vew_doc->getTagValue($vew_data->evl->evlatr001,'dil'),$lv_default) )); 	 
							echo vew_boot($lv_col210, array('label'=> 'Medicacion Cronica del paciente','input'=>gethtml('evlatrmedcro','doccmt1x50', $vew_doc->getTagValue($vew_data->evl->evlatr001,'medcro'),$lv_default) ));
							echo vew_boot($lv_col210, array('label'=> $vew_lang->subjetive,'input'=>gethtml('evlsub','doccmt5x50', $vew_data->evl->evlsub, $lv_default) ));
						?>              
					</div>
					<div class="col-md-6">
						<?= vew_boot($lv_col210, array('label'=>$vew_lang->weight,'input'=>gethtml('patwgt','docnum0300', $vew_doc->getTagValue($vew_data->evl->evlatr001,'patwgt'),$lv_default) )); ?>
						<div class="row">
							<div class="col-md-6">
								<?php
									echo vew_boot($lv_col84, array('label'=>'HTA','input'=>'<input type="checkbox" id="evlatrhta" name="evlatrhta" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'hta')!=''?'checked':'').'>') );
									echo vew_boot($lv_col84, array('label'=>'CI','input'=>'<input type="checkbox" id="evlatrci" name="evlatrci" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'ci')!=''?'checked':'').'>') );
									echo vew_boot($lv_col84, array('label'=>'Sobrepeso','input'=>'<input type="checkbox" id="evlatrsp" name="evlatrsp" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'sp')!=''?'checked':'').'>') );
									echo vew_boot($lv_col84, array('label'=>'EPOC','input'=>'<input type="checkbox" id="evlatrepc" name="evlatrepc" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'epc')!=''?'checked':'').'>') );
									echo vew_boot($lv_col84, array('label'=>'IRC','input'=>'<input type="checkbox" id="evlatrirc" name="evlatrirc" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'irc')!=''?'checked':'').'>') );
									echo vew_boot($lv_col84, array('label'=>'Epilepsia','input'=>'<input type="checkbox" id="evlatrepi" name="evlatrepi" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'epi')!=''?'checked':'').'>') );
								?>
							</div>
							<div class="col-md-6">
								<?php
									echo vew_boot($lv_col84, array('label'=>'ICC','input'=>'<input type="checkbox" id="evlatricc" name="evlatricc" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'icc')!=''?'checked':'').'>') );
									echo vew_boot($lv_col84, array('label'=>'Arritmias','input'=>'<input type="checkbox" id="evlatrarrtms" name="evlatrarrtms" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'arrtms')!=''?'checked':'').'>') );
									echo vew_boot($lv_col84, array('label'=>'ASMA','input'=>'<input type="checkbox" id="evlatrasm" name="evlatrasm" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'asm')!=''?'checked':'').'>') );
									echo vew_boot($lv_col84, array('label'=>'TBQ','input'=>'<input type="checkbox" id="evlatrtbq" name="evlatrtbq" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'tbq')!=''?'checked':'').'>') );
									echo vew_boot($lv_col84, array('label'=>'ACV','input'=>'<input type="checkbox" id="evlatracv" name="evlatracv" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'acv')!=''?'checked':'').'>') );
									echo vew_boot($lv_col84, array('label'=>'Alergias','input'=>'<input type="checkbox" id="evlatralg" name="evlatralg" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'alg')!=''?'checked':'').'>') );
								?>
							</div>
						</div>
						<hr>
						<table id="tblver" class="table table-bordered table-condensed table-stripped hidden">
							<thead><tr><th>Vigencia de los estudios realizados</th><th>Si/No</th><th>Mes/A&ntilde;o</th></tr></thead>
							<tbody>
								<tr>
									<td>1- Evaluaci&oacute;n card&iacute;aca con determinaci&oacute;n de FEVI mayor al 55% vigente (menor a 3 meses)</td>
									<td><?= vew_boot($lv_col84, array('label'=>'','input'=>'<input type="checkbox" id="evlher001" name="evlher001" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'her001')!=''?'checked':'').'>') ); ?></td>
									<td><?= vew_boot($lv_col210, array('label'=>'','input'=>gethtml('evlher001dte','doccmt1x50', $vew_doc->getTagValue($vew_data->evl->evlatr001,'her001dte'),$lv_always_disabled) ));?></td>
								</tr>
								<tr>
									<td>2- Laboratorio basal con hemograma, recuento de plaquetas, funci&oacute;n renal y hep&aacute;tica dentro de par&aacute;metros normales</td>
									<td><?= vew_boot($lv_col84, array('label'=>'','input'=>'<input type="checkbox" id="evlher002" name="evlher002" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'her002')!=''?'checked':'').'>') ); ?></td>
									<td><?= vew_boot($lv_col210, array('label'=>'','input'=>gethtml('evlher002dte','doccmt1x50', $vew_doc->getTagValue($vew_data->evl->evlatr001,'her002dte'),$lv_always_disabled) ));?></td>
								</tr>
								<tr>
									<td>3- Ecocardiograma de control normal cada 3 meses</td>
									<td><?= vew_boot($lv_col84, array('label'=>'','input'=>'<input type="checkbox" id="evlher003" name="evlher003" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'her003')!=''?'checked':'').'>') ); ?></td>
									<td><?= vew_boot($lv_col210, array('label'=>'','input'=>gethtml('evlher003dte','doccmt1x50', $vew_doc->getTagValue($vew_data->evl->evlatr001,'her003dte'),$lv_always_disabled) ));?></td>									
								</tr>		
							</tbody>
						</table>
						<table id="tblapt" class="table table-bordered table-condensed table-stripped hidden">
							<thead><tr><th>Aptitud del paciente para recibir Herceptin SC en domicilio</th><th>Si/No</th></tr></thead>
							<tbody>
								<tr>
									<td>1- El paciente ha recibido al menos 2 administraciones con Herceptin 600mg en instituci&oacute;n m&eacute;dica y no ha presentado reacciones adversas a la infusi&oacute;n.</td>
									<td><?= vew_boot($lv_col84, array('label'=>'','input'=>'<input type="checkbox" id="evlapt" name="evlapt" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'apt')!=''?'checked':'').'>') ); ?></td>
								</tr>
							</tbody>
						</table>
						<table id="tblapt2" class="table table-bordered table-condensed table-stripped hidden">
							<thead><tr><th>Aptitud del paciente para recibir Actemra IV en domicilio</th><th>Si/No</th></tr></thead>
							<tbody>
								<tr>
									<td>1- El paciente ha recibido al menos 1 administraci&oacute;n de Actemra IV en instituci&oacute;n m&eacute;dica y no ha presentado reacciones adversas a la infusi&oacute;n.</td>
									<td><?= vew_boot($lv_col84, array('label'=>'','input'=>'<input type="checkbox" id="evlapt" name="evlapt" '.($vew_doc->getTagValue($vew_data->evl->evlatr001,'apt')!=''?'checked':'').'>') ); ?></td>
								</tr>
							</tbody>
						</table>						
						<legend> <?= 'Premedicaci&oacuten' ?></legend>
						<table class="table table-bordered table-condensed table-stripped">
							<thead><tr><th><?= $vew_lang->drug; ?></th><th><?= $vew_lang->dose; ?> (mg)</th><th>Min.Antes Aplicaci&oacute;n</th></tr></thead>
							<tbody>
								<tr>
									<td>Paracetamol</td>
									<td><?= gethtml('evlatrdrgpardss','docnum0600', $vew_doc->getTagValue($vew_data->evl->evlatr001,'drgpardss'),$lv_default); ?></td>
									<td><?= gethtml('evlatrdrgparfrq','docnum0600', $vew_doc->getTagValue($vew_data->evl->evlatr001,'drgparfrq'),$lv_default); ?></td>
								</tr>
								<tr>
									<td>Difenhidranima</td>
									<td><?= gethtml('evlatrdrgdifdss','docnum0600', $vew_doc->getTagValue($vew_data->evl->evlatr001,'drgdifdss'),$lv_default); ?></td>
									<td><?= gethtml('evlatrdrgdiffrq','docnum0600', $vew_doc->getTagValue($vew_data->evl->evlatr001,'drgdiffrq'),$lv_default); ?></td>
								</tr>
								<tr>
									<td><?= gethtml('evlatrdrgotr001','doccmt1x20', $vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr001'),$lv_default); ?></td>
									<td><?= gethtml('evlatrdrgotr001dss','docnum0600', $vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr001dss'),$lv_default); ?></td>
									<td><?= gethtml('evlatrdrgotr001frq','docnum0600', $vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr001frq'),$lv_default); ?></td>									
								</tr>
								<tr>
									<td><?= gethtml('evlatrdrgotr002','doccmt1x20', $vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr002'),$lv_default); ?></td>
									<td><?= gethtml('evlatrdrgotr002dss','docnum0600', $vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr002dss'),$lv_default); ?></td>
									<td><?= gethtml('evlatrdrgotr002frq','docnum0600', $vew_doc->getTagValue($vew_data->evl->evlatr001,'drgotr002frq'),$lv_default); ?></td>
								</tr>			
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		<?= ($vew_data->evl->hhcc==true?'</form>':''); ?>
  </div>
  <script>
		//Firma de documentos
		function <?= $lv_sec; ?>_getSingingDocuments(){
			var $lv_flelst=[{"flenme":"Orden Medica","sgndocsrctyp":"HLT_EVL","sgndocsrccod001":"<?= $vew_data->evl->evlcod ?>","sgndocsrccod002":"OM","fleurl":"?prg=zcutp1_tin&act=rchpatevlpnt&prm_evlcod=<?= $vew_data->evl->evlcod ?>","flepst":""},
											{"flenme":"Historia Clinica","sgndocsrctyp":"HLT_EVL","sgndocsrccod001":"<?= $vew_data->evl->evlcod ?>","sgndocsrccod002":"HHCC","fleurl":"?prg=zcutp1_tin&act=rchpathcpnt&prm_evlcod=<?= $vew_data->evl->evlcod ?>","flepst":""},
											{"flenme":"Consentimiento Informado","sgndocsrctyp":"HLT_EVL","sgndocsrccod001":"<?= $vew_data->evl->evlcod ?>","sgndocsrccod002":"CI","fleurl":"?prg=zcutp1_tin&act=rchpatcinpnt&prm_evlcod=<?= $vew_data->evl->evlcod ?>","flepst":""}];
			return $lv_flelst;
		}

    //Toggle
		tmssLoadScript("toggle",function(){
			$("#<?= $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: 'success', offstyle: 'default', on: 'Si', off: 'No', size: 'small' });
				<?= ($vew_readonly?'$(this).prop("disabled","disabled");':''); ?>
			});
		});
		
    // IMPRIMIR.
		// Orden Medica / Historia Clinica / Consentimiento Informado
    $("#<?= $lv_sec; ?> a[name=btnfrm]").on("click",function(e){ e.preventDefault();
			if( $(this).data("flecod")!="" ){
				var lv_pstdat =[{name:"flesrctyp",value:"HLT_EVL"},{name:"flesrccod",value:"<?= $vew_data->evl->evlcod; ?>"},{name:"flecod",value:$(this).data("flecod")},{name:"fletypcod",value:""}];
				tmssCallProcess("?prg=grldatupl&act=showUpload", lv_pstdat, function(data){
					BootstrapDialog.show({
						title: "<?= $vew_lang->attachment; ?>",
						message: $(data),
						type: BootstrapDialog.TYPE_PRIMARY,
						size: BootstrapDialog.SIZE_WIDE,
						buttons: [{ icon: "fas fa-download", label: "<?= $vew_lang->download; ?>", cssClass: "btn-default",
												action: function(dialog){ $(dialog.$modalBody).find("#btndwn").trigger("click"); }
											}]
					});
				});
			} else {
				window.open("?prg=zcutp1_tin&act="+($(this).data("frm")=="om"?"rchpatevlpnt":($(this).data("frm")=="hc"?"rchpathcpnt":"rchpatcinpnt"))+"&prm_evlcod=<?= $vew_data->evl->evlcod; ?>");
			}
    });
		
		// DIAGNOSTICO
		tmssLoadScript("typeahead",function(){
			$("#<?= $lv_sec; ?> #hltdisclstxt").typeahead({
				onSelectAjaxData: function(data){ $("#<?= $lv_sec; ?> #hltdisclscod").prop("value", data.data.hltdisclscod); },
				ajax: {
					url: "index.php?prg=hltdiscls&act=18",
					displayField: "hltdisclstxt",
					valueField: "hltdisclstxt",
					timeout: 500, triggerLength: 1, method: "get", loadingClass: "fas fa-spinner",
					preDispatch: function(query){ return {prm_hltdisclstxt: query}; },
					preProcess: function(data){ return (data.length==0?false:data); }
				}
			}).next().next("span").children("a:first").on("click", function(evt) { evt.preventDefault();
				tmssPopup("Diagnostico","?prg=hltdiscls&prm_vewcod=VEW_HLT_DIS_CLS_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[hltdisclscod:hltdisclscod],[hltdisclstxt:hltdisclstxt]");
			});
		});

		// NOMBRE COMERCIAL
		tmssLoadScript("typeahead",function(){
			$("#<?= $lv_sec; ?> #mattxt").typeahead({
				onSelectAjaxData: function(data){ $("#<?= $lv_sec; ?> #matcod").prop("value", data.data.matcod); $("#<?= $lv_sec; ?> #matcodext").prop("value", data.data.matcodext).trigger("change"); },
				ajax: {
					url: "index.php?prg=stkmat&act=17",
					displayField: "mattxt",
					valueField: "mattxt",
					timeout: 500, triggerLength: 1, method: "get", loadingClass: "fas fa-spinner",
					preDispatch: function(query){ return {prm_mattxt: query}; },
					preProcess: function(data){ return (data.data.length==0?false:data.data); }
				}
			}).on("keyup", function(){ if($(this).prop("value")==""){$("#<?= $lv_sec; ?> #matcod").prop("value",""); $("#<?= $lv_sec; ?> #matcodext").prop("value","").trigger("change"); } })
				.next().next("span").children("a:first").on("click", function(e) { e.preventDefault();
					tmssPopup("Producto","?prg=stkmat&prm_vewcod=VEW_STK_MAT_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[matcod:matcod],[matcodext:matcodext],[mattxt:mattxt]",function(data){
						$("#<?= $lv_sec; ?> #matcodext").trigger("change");
					});
			});
		});

		// ACTUALIZAR FORMULARIO
		function <?= $lv_sec; ?>_GridRefresh(){
			<?= $lv_sec; ?>_fnc({action: "<?= ($vew_actcod=='01'?'rchmedfrm01':($vew_actcod=='03'?'rchmedfrm03':'rchmedfrm02')); ?>"});
		}

		$("#<?= $lv_sec; ?> #matcodext").on("change", function(e){
			$("#<?= $lv_sec; ?> #evlatrdos").val("");
				$("#<?= $lv_sec; ?> #evlatrdos").attr('readonly', false);	
				$("#<?= $lv_sec; ?> #evlatrdrgpardss").val("");
				$("#<?= $lv_sec; ?> #evlatrdrgparfrq").val("");
				$("#<?= $lv_sec; ?> #evlatrdrgdifdss").val("");
				$("#<?= $lv_sec; ?> #evlatrdrgdiffrq").val("");
				$("#<?= $lv_sec; ?> #evlatrdrg").val("");
				$("#<?= $lv_sec; ?> #evlatrdrg").attr('readonly', false);				
				$("#<?= $lv_sec; ?> #evlatrcntv").val("");
				$("#<?= $lv_sec; ?> #evlatrmadm").val("");
				$("#<?= $lv_sec; ?> #tblver").addClass("hidden");
				$("#<?= $lv_sec; ?> #tblapt").addClass("hidden");
				$("#<?= $lv_sec; ?> #tblapt2").addClass("hidden");
				$("#<?= $lv_sec; ?> #evlatrdrgpardss").attr('readonly', false);
				$("#<?= $lv_sec; ?> #evlatrdrgparfrq").attr('readonly', false);
				$("#<?= $lv_sec; ?> #evlatrdrgdifdss").attr('readonly', false);
				$("#<?= $lv_sec; ?> #evlatrdrgdiffrq").attr('readonly', false);	
				$("#<?= $lv_sec; ?> #evlatrtadm").val("");
				$("#<?= $lv_sec; ?> #evlatrtadm").attr('readonly', false);				
			if( $(this).prop("value") == "MABTHERA" ){
				$("#<?= $lv_sec; ?> #evlatrdrgpardss").val("1000");
				$("#<?= $lv_sec; ?> #evlatrdrgparfrq").val("30");
				$("#<?= $lv_sec; ?> #evlatrdrgdifdss").val("50");
				$("#<?= $lv_sec; ?> #evlatrdrgdiffrq").val("30");
				$("#<?= $lv_sec; ?> #evlatrdrgpardss").attr('readonly', true);
				$("#<?= $lv_sec; ?> #evlatrdrgparfrq").attr('readonly', true);
				$("#<?= $lv_sec; ?> #evlatrdrgdifdss").attr('readonly', true);
				$("#<?= $lv_sec; ?> #evlatrdrgdiffrq").attr('readonly', true);
				$("#<?= $lv_sec; ?> #evlatrdos").val("1400 mg");
				$("#<?= $lv_sec; ?> #evlatrdos").attr('readonly', true);				
				$("#<?= $lv_sec; ?> #evlatrdos").attr('readonly', true);				
				$("#<?= $lv_sec; ?> #evlatrdrg").val("RITUXIMAB");
				$("#<?= $lv_sec; ?> #evlatrdrg").attr('readonly', true);				
				$("#<?= $lv_sec; ?> #evlatrcntv").val("1");
				$("#<?= $lv_sec; ?> #evlatrmadm").val("SC");
				$("#<?= $lv_sec; ?> #evlatrtadm").val("8 min.");
				$("#<?= $lv_sec; ?> #evlatrtadm").attr('readonly', true);
			} else if( $(this).prop("value") == "ACTEMRA" ){
				$("#<?= $lv_sec; ?> #evlatrdrg").val("TOCILIZUMAB");
				$("#<?= $lv_sec; ?> #evlatrdrg").attr('readonly', true);				
				$("#<?= $lv_sec; ?> #evlatrmadm").val("IV");
				$("#<?= $lv_sec; ?> #tblapt2").removeClass("hidden");				
			} else if( $(this).prop("value") == "HERCEPTIN" ){
				$("#<?= $lv_sec; ?> #evlatrdos").val("600 mg");
				$("#<?= $lv_sec; ?> #evlatrdos").attr('readonly', true);
				$("#<?= $lv_sec; ?> #tblver").removeClass("hidden");
				$("#<?= $lv_sec; ?> #tblapt").removeClass("hidden");
				$("#<?= $lv_sec; ?> #evlatrdrg").val("TRASTUZUMAB");
				$("#<?= $lv_sec; ?> #evlatrdrg").attr('readonly', true);				
				$("#<?= $lv_sec; ?> #evlatrmadm").val("SC");
				$("#<?= $lv_sec; ?> #evlatrtadm").val("5 min.");
				$("#<?= $lv_sec; ?> #evlatrtadm").attr('readonly', true);
			}
		});
		
		function <?= $lv_sec; ?>_showdivs(){ 
			$("#<?= $lv_sec; ?> #tblver").addClass("hidden");
			$("#<?= $lv_sec; ?> #tblapt").addClass("hidden");
			$("#<?= $lv_sec; ?> #tblapt2").addClass("hidden");
			if( $("#<?= $lv_sec; ?> #matcodext").prop("value") == "ACTEMRA" ){
				$("#<?= $lv_sec; ?> #tblapt2").removeClass("hidden");				
			} else if( $("#<?= $lv_sec; ?> #matcodext").prop("value") == "HERCEPTIN" ){
				$("#<?= $lv_sec; ?> #tblver").removeClass("hidden");
				$("#<?= $lv_sec; ?> #tblapt").removeClass("hidden");
			}
		}	

		$("#<?= $lv_sec; ?> #evlher001").change(function(e){
			$("#<?= $lv_sec; ?> #evlher001dte").attr("readonly", !$(this).prop("checked"));
		});
		$("#<?= $lv_sec; ?> #evlher002").change(function(e){
			$("#<?= $lv_sec; ?> #evlher002dte").attr("readonly", !$(this).prop("checked"));
		});
		$("#<?= $lv_sec; ?> #evlher003").change(function(e){
			$("#<?= $lv_sec; ?> #evlher003dte").attr("readonly", !$(this).prop("checked"));
		});
		
		$(function(){ <?= $lv_sec; ?>_showdivs(); });
		
  </script>
	
	<?php if($vew_data->evl->hhcc==true) { ?> 
		<script>
			var gv_<?= $lv_sec; ?>_last_action="";

			// server response
			tmssLinkForm( $("#<?= $lv_sec; ?>_frm"), "<?= $lv_lnk; ?>", function (data) {
				if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
					if (gv_<?= $lv_sec; ?>_last_action=="04") {
						tmssTabSecCls( $("#<?= $lv_sec; ?>") );
					} else {
						$("#<?= $lv_sec; ?>").replaceWith( data );
					}
				}
			});
			
			// form submit
			function <?= $lv_sec; ?>_fnc( lp_prm ) {
				gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
				var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':($vew_actcod=='01'?'01':'03')); ?>":gv_<?= $lv_sec; ?>_last_action);
				tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
			}

			// edit mode
			tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
			
		</script>
	<?php } ?>
	
</section>
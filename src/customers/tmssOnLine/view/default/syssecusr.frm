<?php	
	// url del formulario
  $lv_lnk = '?prg=syssecusr&prm_usrcod='.$vew_data->usrcod;

	// campos requeridos
	$vew_input->RequiredFields( array('usrcod','usrtxt','docsts','adreml') );

	// clave del documento
	$lv_dockey = $vew_data->usrcod; 

	// titulo
	$lv_title = $vew_lang->user;
	
	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'USR';
		
	// mi cuenta. determino si el ingreso es a traves de "Mi Cuenta"
	$lv_my_account = false;
	if($vew_actcod=='25'){
		$lv_my_account = true;
		$vew_actcod='02';
	}
		
	// librería de estilos bootstrap
	include_once('_library.frm');

	//if ($vew_actcod=='25'){$vew_readonly=false;}
	$vew_data->wndsty = $vew_doc->getTagValue( $vew_data->usratr001, 'wndsty' );

	$lv_optedt = ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02')?'02':'03');

	/* Botones por Vista */
	$vew_tbl['new'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01') && !$lv_my_account );
	$vew_tbl['cpy'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01') && !$lv_my_account );
	$vew_tbl['modL'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02') && !$lv_my_account );
	$vew_tbl['modR'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02') && !$lv_my_account );
	$vew_tbl['canc'] = array('per'=>!$lv_my_account);
	$vew_tbl['sndL'] = array('pos'=>'L', 'per'=>!$lv_my_account, 'id'=>'btnsnd', 'ttl'=>$vew_lang->send, 'icn'=>'fas fa-envelope', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn','acc'=>'');
	$vew_tbl['sndR'] = array('pos'=>'R', 'per'=>!$lv_my_account, 'id'=>'btnsnd', 'ttl'=>$vew_lang->send, 'icn'=>'fas fa-envelope', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn','acc'=>'');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('tmss_actcodacc','hidden', ($lv_my_account?'25':'03')); ?>
    <?= gethtml('objtypcod','hidden',$vew_objtyp); ?>
		
    <div class="container-fluid" role="tabpanel"> 
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<?php if($vew_actcod!='01'){ ?><li class="pull-right"><h4># <strong><?= $vew_data->usrcod; ?><?= gethtml('usrcod','hidden',$vew_data->usrcod); ?></strong></h4></li><?php } ?>
			</ul>
			<div class="tab-content tmss-tab-content">
        
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="<?= ($vew_data->usrcod=='' || $lv_my_account?'col-md-12':'col-md-10'); ?>">							
							<div class="row">

								<div class="col-md-6">
                  <div class="card">
                    <div class="card-header"><div class="card-title"><?= $vew_lang->user; ?></div></div>
                    <div class="card-body tmss-card-body-edit">
                      <?php
                        if($vew_actcod=='01'){ echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('usrcod', 'usrcod', $vew_data->usrcod, ($vew_data->usrcod!=''?$lv_always_disabled:$lv_default) ) )); }
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->name, 'input'=>gethtml('usrtxt', 'doccmt1x250',$vew_data->usrtxt, $lv_default) ));								
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, ($vew_actcod=='25'?$lv_always_disabled:$lv_default)) ));
                      ?>
                    </div>
                  </div>
								</div><!-- /col-md-6 -->
								<div class="col-md-6">
                  <div class="card">
                    <div class="card-header"><div class="card-title"><?= $vew_lang->details; ?></div></div>
                    <div class="card-body tmss-card-body-edit">
                      <?php
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->appearance,	'input'=>gethtml('wndsty', 'wndsty', $vew_data->wndsty,	$lv_default) ));
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->language,		'input'=>gethtml('lngcod', 'lngcod', $vew_data->lngcod, $lv_always_disabled) ));
                        if(!$lv_my_account){
                          echo vew_boot($lv_col210, array('label'=>'Depuracion', 'input'=>gethtml('debmod', 'yesno', $vew_doc->getTagValue($vew_data->usratr001,'debmod'), $lv_default) ));
                          echo vew_boot($lv_col210, array('label'=>$vew_lang->access, 'input'=>gethtml('strpge', 'doccmt1x50', $vew_doc->getTagValue($vew_data->usratr001,'strpge'), $lv_default) ));
                        } else {
                          echo gethtml('debmod', 'hidden', $vew_doc->getTagValue($vew_data->usratr001,'debmod'), $lv_default);
                          echo gethtml('strpge', 'hidden', $vew_doc->getTagValue($vew_data->usratr001,'strpge'), $lv_default);
												}
												echo vew_boot( array($lv_colsm210, $lv_colxs48), array('label'=>$vew_lang->system, 'input'=>gethtml('usrsysacc', 'checkbox', $vew_data->usrsysacc, 	$lv_default) ));
												echo vew_boot( array($lv_colsm210, $lv_colxs48), array('label'=>'', 'input'=>'<span class="text-danger" id="usrsysacctxt" style="display:none;"><b>IMPORTANTE:</b> Los usuarios de Sistema aceptan la Pol&iacute;tica del Servicio y los T&eacute;rminos y Condiciones a traves del/los usuarios que los crean o actualizan.</span>' ));
                      ?>
												
                    </div>
                  </div>
								</div> <!-- /col-md-6 -->
							</div> <!-- /rows -->
              
							<!-- DIRECCION / CONTACTO -->
							<div class="row">
								<div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
								<div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
							</div>						
						
						</div> <!-- col-md-10 -->
						<?php if(!$lv_my_account && $vew_data->usrcod!='') { ?>
						<div class="col-md-2 text-center">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->operations; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <a href="#" id="btnpwd" class="card-opt-body text-left <?= (($vew_sec->hasPermission($lv_mdlcod, $lv_prgcod, '02') && $vew_actcod!='25') ? '': 'disabled'); ?>"><i class="far fa-pencil"></i> <?= $vew_lang->password; ?></a>
                  <?php if ( $vew_data->usracclck=='X' ) { ?>
                    <a href="#" id="btnlck" class="card-opt-body text-left"><i class="fas fa-unlock"></i> <?= $vew_lang->unlock; ?></a>
                  <?php } ?>
                  <a href="#" id="btnbus" class="card-opt-body text-left"><i class="far fa-industry"></i> <?= $vew_lang->companies; ?></a>
                  <a href="#" id="btnrls" class="card-opt-body text-left"><i class="far fa-users"></i> <?= $vew_lang->roles; ?></a>
                  <a href="#" id="btnper" class="card-opt-body text-left"><i class="far fa-key"></i> <?= $vew_lang->permissions; ?></a>
                  <a href="#" id="btnprm" class="card-opt-body text-left"><i class="far fa-code"></i> <?= $vew_lang->parameters; ?></a>
                  <a href="#" id="btnaut" class="card-opt-body text-left"><i class="far fa-user-secret"></i> <?= $vew_lang->authorizations; ?></a>
                  <a href="#" id="btnasg" class="card-opt-body text-left"><i class="far fa-user-shield"></i> <?= $vew_lang->directive; ?></a>
                </div>
              </div>
						</div> <!-- /col-md-2 -->
						<?php } ?>

					</div> <!-- /row -->
				</div> <!-- /tab-pane 001 -->
			</div> <!-- /tab-content -->
		</div> <!-- /container-fluid -->
  </form>
	<?php if($lv_my_account){ ?>
		<script>$(function(){ $("#<?= $lv_sec; ?> #adreml").prop("readonly","readonly"); });</script>
	<?php } else if($vew_data->usrcod!='') { ?>
		<script> 
			//  E N V I A R
			$("#<?= $lv_sec; ?> #btnsnd").on("click",function(e){ e.preventDefault();
				BootstrapDialog.confirm({
					title: "Enviar inforamcion",
					message: "¿Desea enviar información de acceso?",
					type: BootstrapDialog.TYPE_WARNING,
					callback: function(result) {
						if(result) {
							tmssCallProcess("?prg=syssecusr&act=35", {usrcod:$("#<?= $lv_sec; ?> #usrcod").prop("value")}, function(data){
								var lv_errcod = $("<div>"+data+"</div>").find("errcod").text();
								var lv_errtxt = $("<div>"+data+"</div>").find("errtxt").text();
								if ( Number(lv_errcod)!=0 ) {
									toastr.warning("No se pudo enviar la información de acceso.<br>"+lv_errcod+": "+lv_errtxt);
								} else {
									toastr.info("Información de acceso enviada.");
								}
							});
						}
					}
				});
			});
			
			//  E M P R E S A S
			$("#<?= $lv_sec; ?> #btnbus").on("click",function(e){ e.preventDefault();
				tmssCallProcess("?prg=syssecusrbus&act=<?= $lv_optedt; ?>", {usrcod: $("#<?= $lv_sec; ?> #usrcod").prop("value")}, function(data){
					BootstrapDialog.show({
						title: "<?= $vew_lang->companies; ?>",
						message: $(data),
						draggable: true,
						size: BootstrapDialog.SIZE_WIDE
						<?php if($lv_optedt=='02'){ ?>
            ,buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
											{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){ $(dialogItself.$modalBody).find("#btnsubmit").trigger("click"); }}]
						<?php } ?>
					});
				});
			});
			
			//  R O L E S
			$("#<?= $lv_sec; ?> #btnrls").on("click",function(e){ e.preventDefault(); 
				tmssCallProcess("?prg=syssecusrgrp&act=<?= $lv_optedt; ?>",{usrcod: $("#<?= $lv_sec; ?> #usrcod").prop("value")}, function(data){
					BootstrapDialog.show({
						title: "<?= $vew_lang->roles; ?>",
						message: $(data),
						draggable: true,
						size: BootstrapDialog.SIZE_WIDE
						<?php if($lv_optedt=='02'){ ?>
            ,buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
											{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){ $(dialogItself.$modalBody).find("#btnsubmit").trigger("click"); }}]
						<?php } ?>
					});
				});
			});
			
			
			<?php if($vew_sec->hasPermission($lv_mdlcod, $lv_prgcod, '02') && $vew_actcod!='25'){ ?>
			//  C O N T R A S E Ñ A
			$("#<?= $lv_sec; ?> #btnpwd").on("click", function(e){ 
				e.preventDefault;
				var lv_cs = false;
				tmssCallProcess("?prg=syssecusrpwd&act=getPwdDirectives", [{name: "usrcod", value: $("#<?= $lv_sec; ?> #usrcod").prop("value")}], function(data){
					var lv_cs_drt = data.filter(function(lp_drt){ return lp_drt["syssecdrttypcodext"].toLowerCase() == "pwdlgncasesensitive";});
					lv_cs = (lv_cs_drt[0]["syssecdrttypdef"] ? (lv_cs_drt[0]["syssecdrttypdef"] == "1" ? true : false ) : lv_cs);
				});
				
				var lv_pstdat = [{name: "usrcod", value: $("#<?= $lv_sec; ?> #usrcod").prop("value")},
											 {name: "readonly", value: "<?= $vew_readonly; ?>"}
											];

				tmssCallProcess("?prg=syssecusrpwd&act=15", lv_pstdat, function(data){
					var lv_dat = data.replace("hidden", "");
					BootstrapDialog.show({
						title: "Contrase&ntilde;a",
						message: $(lv_dat),
						onshow: function(dialog){
							$(dialog.$modalBody).find(".progress").addClass("hidden");
							$(dialog.$modalFooter).find("#btn-chg").prop("disabled","disabled");
						},
						onshown: function(dialog){
							$(dialog.$modalBody).find("#usrpwd001").focus();

							//handler del evento keyup de los campos de contraseña
							//------------------------------------------------------
							$(dialog.$modalBody).find("#usrpwd001, #usrpwd002").keyup(function(e){e.preventDefault;
								var lp_psw = $(dialog.$modalBody).find("#usrpwd001").val();
								// Corrije el valor de la contraseña si es undefined
								lp_psw = lp_psw ?? "";
								// Escapa caracter '
								lp_psw = lp_psw.replace("'", "\\\'"); 

								if( $(dialog.$modalBody).find("#usrpwd001").val() == $(dialog.$modalBody).find("#usrpwd002").val() ) {
										$(dialog.$modalFooter).find("#btn-chg").prop("disabled","");
								} else {
									$(dialog.$modalFooter).find("#btn-chg").prop("disabled","disabled");
								}
							});
						},
						buttons: [ 
							{id: "btn-chg", label: "<?= $vew_lang->change; ?>", cssClass: "btn-success", action: function(dialog){
								var lv_pstdat;
								var hash = sha256.create();
								var lv_pwd = $(dialog.$modalBody).find("#usrpwd001").prop("value");
								lv_pwd = lv_cs ? lv_pwd : lv_pwd.toUpperCase();
								hash.update( lv_pwd );
								$(dialog.$modalBody).find("#usrpwd001").prop("value",hash.hex());
								$(dialog.$modalBody).find("#usrpwd002").prop("value",hash.hex());

								lv_pstdat = $(dialog.$modalBody).find("form").serializeArray();

								tmssCallProcess("?prg=syssecusrpwd&act=16", lv_pstdat, function(data){
									toastr.success("Contrase&ntilde;a actualizada.");
								});

							}}
							],
					});
				});
			});
			<?php } ?>
			
			//  P E R M I S O S
			$("#<?= $lv_sec; ?> #btnper").on("click", function(e) { e.preventDefault(); 
				tmssCallProcess("?prg=syssecper&act=<?= $lv_optedt; ?>",{usrcod: $("#<?= $lv_sec; ?> #usrcod").prop("value")}, function(data){
					BootstrapDialog.show({
						title: "<?= $vew_lang->permissions; ?>",
						message: $(data),
						draggable: true,
						size: BootstrapDialog.SIZE_WIDE
						<?php if($lv_optedt=='02'){ ?>
            ,buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
											{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){ $(dialogItself.$modalBody).find("#btnsubmit").trigger("click"); }}]
						<?php } ?>
					});
				});
			});
			
			//  P E R M I S O S  -  O B J E T O S   D E   A U T O R I Z A C I O N
			$("#<?= $lv_sec; ?> #btnaut").on("click", function(e) { e.preventDefault(); 
				tmssCallProcess("?prg=syssecperaut&act=<?= $lv_optedt; ?>",{usrcod: $("#<?= $lv_sec; ?> #usrcod").prop("value")}, function(data){
					BootstrapDialog.show({
						title: "<?= $vew_lang->authorizationobjects; ?>",
						message: $(data),
						draggable: true,
						size: BootstrapDialog.SIZE_WIDE
						<?php if($lv_optedt=='02'){ ?>
            ,buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
											{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){ $(dialogItself.$modalBody).find("#btnsubmit").trigger("click"); }}]
						<?php } ?>
					});
				});
			});
			
			//  P A R A M E T R O S
			$("#<?= $lv_sec; ?> #btnprm").on("click", function(e) { e.preventDefault(); 
				tmssCallProcess("?prg=syssecusrprm&act=<?= $lv_optedt; ?>", {usrcod: $("#<?= $lv_sec; ?> #usrcod").prop("value")}, function(data){ 
					BootstrapDialog.show({
						title: "<?= $vew_lang->parameters; ?>",
						message: $(data),
						size: BootstrapDialog.SIZE_WIDE
						<?php if($lv_optedt=='02'){ ?>
            ,buttons:[{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); }},
											{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){ $(dialogItself.$modalBody).find("#btnsubmit").trigger("click"); }}]
						<?php } ?>
					});
				});
			});
			
			//  D E S B L O Q U E A R
			$("#<?= $lv_sec; ?> #btnlck").on("click",function(e){ e.preventDefault();  
				BootstrapDialog.confirm({
					title: "Desbloquear",
					message: "¿Desea desbloquear el acceso del usuario?",
					type: BootstrapDialog.TYPE_WARNING,
					callback: function(result) {
						if(result) {
							tmssCallProcess("?prg=syssecusr&act=17", {usrcod: $("#<?= $lv_sec; ?> #usrcod").prop("value")}, function(data){ 
								toastr.success("Usuario desbloqueado");
								<?= $lv_sec; ?>_fnc({action: '99'});
							});
						}
					}
				});
			});
			
			// A S I G N A C I Ó N   D E   G R U P O S   D E   D I R E C T I V A S
			$("#<?= $lv_sec; ?> #btnasg").on("click", function(e) { e.preventDefault();
				var lv_pstdat =[{name:"srcobjcod001", value: $("#<?= $lv_sec; ?> #usrcod").prop("value")},
												{name:"srcobjtyp", value: $("#<?= $lv_sec; ?> #objtypcod").prop("value")}];
				tmssCallProcess("?prg=syssecdrtgrpasg&act=<?= $lv_optedt; ?>", lv_pstdat, function(data){
					BootstrapDialog.show({
						title: "<?= $vew_lang->directive; ?>",
						message: $(data),
						size: BootstrapDialog.SIZE_WIDE
						<?php if($lv_optedt=='02'){ ?>
            ,buttons:[{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); }},
											{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){ $(dialogItself.$modalBody).find("#btnsubmit").trigger("click"); }}]
						<?php } ?>
					});
				});
			});
		</script>

	<?php } ?>
	<script>
		function <?= $lv_sec; ?>_usrsysacctxt(){
			if( $("#<?= $lv_sec; ?> #usrsysacc").val()==1){
				$("#<?= $lv_sec; ?> #usrsysacctxt").show();
			} else {
				$("#<?= $lv_sec; ?> #usrsysacctxt").hide();
			}
		}
		$(function(){ <?= $lv_sec; ?>_usrsysacctxt(); });
		$("#<?= $lv_sec; ?> #usrsysacc").on("change",function(){ <?= $lv_sec; ?>_usrsysacctxt(); });
		
		$("#<?= $lv_sec; ?> #usrcod").on("keyup", function (e) {
			const specialChars = /[`!@#$%^&*()+\-=\[\]{};':"\\|,.<>\/?~]/;
			//const specialChars = /[`!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~]/;
			e.target.setCustomValidity( specialChars.test($(this).val())?"Caracteres invalidos.":"" );
		});
	
		$("#<?= $lv_sec; ?> #wndsty").on("change",function(e){
			$("head link#theme").prop("href", $("head link#theme").data("path")+$(this).prop("value")+"-2.1.3.css");
		});
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adreml")) ) { return false; }
				if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adrwebpge")) ) { return false; }
			}
			var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($lv_my_account?'25':($vew_actcod=='02'?'02':'03')); ?>":gv_<?= $lv_sec; ?>_last_action);
		}
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
<?php
	session_start();
	
	$lv_method = $_SERVER['REQUEST_METHOD'];
	$lv_paths = $_SERVER['REQUEST_URI'];
	$lv_env = 'sysprd';
	$lv_ttl = '';
	$lv_subttl = '';
	$lv_key = '';
	$lv_pic = '';	
  $lv_ttl = 'Linsock';
	$lv_key = 'X000080192';
	// datos generales
	$lv_surl = 'http://localhost:8080/clientes';
	$lv_btnlgn = 'http://localhost:8080/?prg=syssecusr&act=98';
	$lv_btnpwd = 'http://localhost:8080/?prg=syssecusrpwd&act=11';
	$lv_btneml = 'https://webmail.gorse.ar';	
?>
<!DOCTYPE html>
<html>
  <head>
    <title><?= $lv_ttl; ?></title>
    <meta name="robots" content="noindex">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="shortcut icon" href="http://localhost:8080/library/images/TemasisArgentina_icon.png">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="http://localhost:8080/library/plugins/jquery/jquery/3.6.0/jquery.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="http://localhost:8080/library/plugins/bootstrap/bootstrap/4.6.0/css/bootstrap.min.css">
    <script src="http://localhost:8080/library/plugins/bootstrap/bootstrap/4.6.0/js/bootstrap.min.js" type="text/javascript"></script>
		<link rel="stylesheet" href="http://localhost:8080/library/fonts/font-awesome/6.4.0pro/css/all.min.css">
    <script src="http://localhost:8080/library/plugins/javascript/js-sha256/0.9.0/sha256.min.js" type="text/javascript"></script>		
  </head>
  <body style="background-color: #b538a4; background-size: cover; background-attachment: fixed;" id="colimg">
		<form method="POST" action="<?= $lv_btnpwd; ?>" id="pwdfrm" class="hidden-lg hidden-md hidden-xs">
			<input type="hidden" id="sysenv" name="sysenv" value="<?= $lv_env; ?>">
			<input type="hidden" id="bseurl" name="bseurl" value="<?= $lv_surl; ?>">
			<input type="hidden" id="bsecnx" name="bsecnx" value="<?= $lv_key; ?>">
		</form>
		<form method="POST" action="<?= $lv_btnlgn; ?>" id="lgnfrm">
			<input type="hidden" id="bseurl" name="bseurl" value="<?= $lv_surl; ?>">
			<input type="hidden" id="bsecnx" name="bsecnx" value="<?= $lv_key; ?>">
			<input type="hidden" id="logon"  name="logon"  value="1">
			<div class="row" style="margin: 0px; height: 100vH;">
				<div class="col-sm-7 col-md-5 col-lg-5 offset-sm-5 offset-md-7 offset-lg-7 bg-white" style="padding: 30px;">
					<div class="app-title text-center">
						<img class="img-fluid customer-logo" src="<?= $lv_pic; ?>" title="<?= $lv_ttl; ?>" style="padding: 20px; max-width: 380px; max-height: 140px;">
						<p><span style="font-size: 18px; color: #2c73c4;">&nbsp;<?= $lv_envtxt; ?></span></p>
					</div>
					<?php if( ($lv_servicio_suspendido??'')!='' ) { ?>
						<hr><h3 class="text-center text-danger">Servicio suspendido por falta de pago.</h3>
						<p class="text-center">Por favor, regularice su situación.</p><hr><br>
					<?php } else { ?>
						<div class="form-group">
							<label>Usuario o Email</label>
							<input type="text" id="usrcod" name="usrcod" value="" class="form-control" required maxlength="250">
						</div>
						<div class="form-group">
							<label>Contrase&ntilde;a</label>
							<input type="password" id="usrpwd" name="usrpwd" value="" class="form-control" required maxlength="50">
						</div>
						<button type="submit" class="btn btn-success btn-lg btn-block">Ingresar</button><br>
						<div class="text-center">
							<a href="#" onclick="$('#pwdfrm').submit();" id="pwdreclnk" class="password-recovery-link">Olvidaste tu contrase&ntilde;a?</a>
						</div>
					<?php } ?>
					<br>
					<div class="row">
						<div class="col-3 offset-4 text-center">
							<a href="<?= $lv_btneml; ?>" target="_blank" title="WebMail"><span class="far fa-envelope fa-2x"></span></a>
						</div>
					</div>
					<br>
					<div class="text-center" style="font-size: 80%;">
						<a href="https://temasis.ar" target="_blank"><img src="/library/images/logos/temasis2.jpg" title="Temasis Argentina SRL" style="max-width:25px; max-height:25px;"></a> | 
						<a href="https://gorse.ar/documents/politicaprivacidad.html" target="_blank">Politica de Privacidad</a> | 
						<a href="https://gorse.ar/documents/terminosservicio.html" target="_blank">Térmios del Servicio</a>
					</div>
				</div>
			</div>
		</form>
		<script>
			$(function(){
				// set main image
				var lv_imgnum = Math.floor(Math.random() * 27);
				lv_imgnum++;
				var lv_img = "http://localhost:8080/library/images/login/"+lv_imgnum+".jpg";
				$("#colimg").css("background-image","url("+lv_img+")");
				
				// usr focus
				$("#usrcod").focus();
				
				// hash pwd
				$("#lgnfrm").submit(function(){
					var hash = sha256.create();
					hash.update( $("#lgnfrm #usrpwd").prop("value").toUpperCase() );
					$("#lgnfrm #usrpwd").prop("value",hash.hex());
				});
			});
		</script>		
  </body>
</html>

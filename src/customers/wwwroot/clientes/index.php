<?php
	session_start();
	
	$lv_method = $_SERVER['REQUEST_METHOD'];
	$lv_paths = $_SERVER['REQUEST_URI'];
	$lv_env = 'sysprd';
	$lv_ttl = '';
	$lv_subttl = '';
	$lv_key = '';
	$lv_pic = '';	
	
	$lv_path = explode('/',str_ireplace( '\\' , '/' , strtolower($lv_paths)));
	if(count($lv_path)<1){
		header($_SERVER["SERVER_PROTOCOL"].' 404 Not Found', true, 404);
		exit;
	} else if($lv_path[1]!='clientes') {
		header($_SERVER["SERVER_PROTOCOL"].' 404 Not Found', true, 404);
		exit;
	} else {
		switch( $lv_path[2] ) {
			case 'temasis':
				$lv_ttl = 'Temasis Argentina SRL';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/temasisargentina.png';
				$lv_key = 'X000021470';
				break;
			case 'teaminfusionar':
				$lv_ttl = 'TEAM INFUSION';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/teaminfusionar.jpg';
				$lv_key = 'X000050647';
				break;			
			case 'teaminfusioncl':
				$lv_ttl = 'TEAM INFUSION';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/teaminfusioncl.jpg';
				$lv_key = 'X000050186';
				break;			
			case 'teaminfusionuy':
				$lv_ttl = 'TEAM INFUSION';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/teaminfusionuy.jpg';
				$lv_key = 'X000053413';
				break;
			case 'teamtrainingar':
				$lv_ttl = 'TEAM TRAINING';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/teamtrainingar.jpg';
				$lv_key = 'X000049172';
				break;
			case 'logindoor':
				$lv_ttl = 'LOGINDOOR';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/logindoor.jpg';
				$lv_key = 'X000011295';
				break;
			case 'teampediatrico':
				$lv_ttl = 'TEAM PEDIATRICO';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/teampediatrico.jpg';
				$lv_key = 'X000049183';
				break;
			case 'dpiballester':
				$lv_ttl = 'DIAGNOSTICO BALLESTER';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/dpiballester.jpg';
				$lv_key = 'X000059069';
				break;
			case 'osiadsalud':
				$lv_ttl = 'OSIAD SALUD';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/osiad.gif';
				$lv_key = 'X000040707';
				break;				
			case 'supplysouth':
				$lv_ttl = 'SUPPLY SOUTH';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/supplysouth.jpg';
				$lv_key = 'X000017277';
				$lv_servicio_suspendido = '';
				break;
			case 'supplynorth':
				$lv_ttl = 'SUPPLY NORTH';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/supplynorth.png';
				$lv_key = 'X000017277';
				$lv_servicio_suspendido = '';
				break;
			case 'tigrejoven':
				$lv_ttl = 'TIGRE JOVEN';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/tigrejoven.png';
				$lv_key = 'X000042028';
				$lv_servicio_suspendido = '';
				break;
			case 'emaservicios':
				$lv_ttl = 'EMASERVICIOS';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/emaservicios.png';
				$lv_key = 'X000059715';
				$lv_servicio_suspendido = '';
				break;				
			case 'coordlinehealth':
				$lv_ttl = 'Coordline Health';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/coordlinehealth.jpeg';
				$lv_key = 'X000033429';
				$lv_servicio_suspendido = '';
				break;				
			case 'selfingenieria':
				$lv_ttl = 'Coordline Health';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/selfingenieria.png';
				$lv_key = 'X000076457';
				$lv_servicio_suspendido = '';
				break;				
			case 'hecaglobal':
				$lv_ttl = 'Heca Global';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/dana_diabecare2.jpeg';
				$lv_key = 'X000039087';
				$lv_servicio_suspendido = '';
				break;				
			case 'cuidadovital':
				$lv_ttl = 'Cuidado Vital';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/cuidadovital1.png';
				$lv_key = 'X000058261';
				$lv_servicio_suspendido = '';
				break;
			default:
				$lv_ttl = 'Temasis Argentina SRL';
				$lv_pic = 'https://customers.gorse.ar/library/images/logos/temasisargentina.png';
				$lv_key = 'X000058261';
				break;
			
				//header($_SERVER["SERVER_PROTOCOL"].' 404 Not Found', true, 404);
				//exit;
		}
	}
	// datos generales
  $lv_surl = 'https://customers.gorse.ar/clientes/'.$lv_path[2].'';
	$lv_btnlgn = 'https://customers.gorse.ar/?prg=syssecusr&act=98';
	$lv_btnpwd = 'https://customers.gorse.ar/?prg=syssecusrpwd&act=11';
	$lv_btneml = 'https://webmail.gorse.ar';	
?>
<!DOCTYPE html>
<html>
  <head>
    <title><?= $lv_sttl; ?></title>
    <meta name="robots" content="noindex">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="shortcut icon" href="https://customers.gorse.ar/library\images\TemasisArgentina_icon.png">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="https://customers.gorse.ar/library\plugins\jquery\jquery\3.6.0\jquery.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="https://customers.gorse.ar/library\plugins\bootstrap\bootstrap\4.6.0\css\bootstrap.min.css">
    <script src="https://customers.gorse.ar/library\plugins\bootstrap\bootstrap\4.6.0\js\bootstrap.min.js" type="text/javascript"></script>
		<link rel="stylesheet" href="https://customers.gorse.ar/library\fonts\font-awesome\6.4.0pro\css\all.min.css">
    <script src="https://customers.gorse.ar/library\plugins\javascript\js-sha256\0.9.0\sha256.min.js" type="text/javascript"></script>		
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
						<img class="img-fluid customer-logo" src="<?= $lv_pic; ?>" title="<?= $lv_sttl; ?>" style="padding: 20px; max-width: 380px; max-height: 140px;">
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
				var lv_img = "https://customers.gorse.ar/library/images/login/"+lv_imgnum+".jpg";
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
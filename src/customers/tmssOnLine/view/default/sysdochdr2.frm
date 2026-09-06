<!DOCTYPE html> 
<?php 
	$lv_url = '';
  //if($this->co_reg->config->get('environmet') == 'dev'){
  //  $lv_url = 'https://temasis.com.ar/sysdev';
  //}else{
  //  $lv_url = 'https://temasis.com.ar/sysprd';
  //}
?>
<html lang="es">
  <head> 
    <title><?= (isset($this->data["title"])?$this->data["title"]:"Temasis"); ?></title>
    <link rel="shortcut icon" href="<?= $lv_url; ?>\library\images\TemasisArgentina_favicon_32x32.png">
    <meta name="author" content="Temasis">
		<meta name="theme-color" content="#317EFB"/>
		<meta name="Description" content="Sistema de Gestión On-Line.">		
    <meta http-equiv="content-type" content="text/html; charset=iso-8859-1">
    <meta name="robots" content="noindex">
		<meta name="googlebot" content="noindex">

		<!-- PWA settings -->
		<meta	name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
		<!-- /PWA settings -->

    
    <!-- jquery -->
    <script src="<?= $lv_url; ?>\library\plugins\jquery\jquery\3.6.0\jquery.min.js"></script>
		
    <!-- bootstrap -->
    <link href="<?= $lv_url; ?>\library\plugins\bootstrap\bootstrap\3.4.1\css\bootstrap.min.css" rel="stylesheet">
    <script src="<?= $lv_url; ?>\library\plugins\bootstrap\bootstrap\3.4.1\js\bootstrap.min.js"></script>
		
		<!-- font-awesome -->
    <link href="<?= $lv_url; ?>\library\fonts\font-awesome\6.4.0pro\css\all.min.css" rel="stylesheet">
    <link href="\library\css\toggle-switchy-1.14.css" rel="stylesheet">
    
		<!-- bootstrap dialog -->
    <link href="<?= $lv_url; ?>\library\plugins\bootstrap\bootstrap-dialog\1.35.4\dist\css\bootstrap-dialog.min.css" rel="stylesheet">
    <script src="<?= $lv_url; ?>\library\plugins\bootstrap\bootstrap-dialog\1.35.4\dist\js\bootstrap-dialog.min.js"></script>
		
		<!-- toastr 01.12.2017 -->
    <link href="<?= $lv_url; ?>\library\plugins\jquery\toastr\2.1.3\build\toastr.min.css" rel="stylesheet">
    <script src="<?= $lv_url; ?>\library\plugins\jquery\toastr\2.1.3\build\toastr.min.js"></script>
		
		<script src="<?= $lv_url; ?>\library\plugins\javascript\momentjs\2.24.0\min\moment.min.js"></script>
		<script src="<?= $lv_url; ?>\library\plugins\javascript\momentjs\2.24.0\locale\es.js"></script>
		<script>
			moment.locale("es");
		</script>
		
		<!-- CERULEAN bootstrap theme (bootswatch.com) -->
		<!--<link href="<?= $lv_url; ?>\tmssOnLine\library\css\bootstrap.min.cerulean.css" rel="stylesheet">-->
		<?php 
    	$lv_wndsty = ''; 
    	if( isset($vew_doc) && isset($vew_usr) ) { 
        $lv_wndsty = $vew_doc->getTagValue( $vew_usr->usratr001, 'wndsty' ); 
      } 
    	$lv_wndsty = ($lv_wndsty==''?'tmssThemeDefault':$lv_wndsty); 
    	echo '<link id="theme" href="/library/css/temasis/'.$lv_wndsty.'-2.1.3.css" rel="stylesheet" media="screen" data-path="/library/css/temasis/" />'; 
    ?>    
		<link href="\library\css\temasis\tmssGorse-3.2.6.css" rel="stylesheet" media="screen" />
    <link href="\library\css\temasis\tmssStyle-2.1.2.css" rel="stylesheet" media="screen" />

		<script>
			function checkFullScreenSuppoort() {
				return (!document.fullscreenElement && !document.mozFullScreenElement && !document.webkitFullscreenElement);				
			}
			
			// toggle full screen
			function toggleFullScreen() {
				var a = $(window).height() - 10;

				if (!document.fullscreenElement && // alternative standard method
						!document.mozFullScreenElement && !document.webkitFullscreenElement) { // current working methods
					if (document.documentElement.requestFullscreen) {
						document.documentElement.requestFullscreen();
					} else if (document.documentElement.mozRequestFullScreen) {
						document.documentElement.mozRequestFullScreen();
					} else if (document.documentElement.webkitRequestFullscreen) {
						document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
					}
				} else {
					if (document.cancelFullScreen) {
						document.cancelFullScreen();
					} else if (document.mozCancelFullScreen) {
						document.mozCancelFullScreen();
					} else if (document.webkitCancelFullScreen) {
						document.webkitCancelFullScreen();
					}
				}
				$(".full-screen").toggleClass("fas fa-expand");
				$(".full-screen").toggleClass("fas fa-compress");
			}
			
			$(function(){
				if(!checkFullScreenSuppoort()){ $(".full-screen").addClass("hidden"); }
			});
		</script>
    <script>
			var go_tmssScriptList = [
        											{name:"toggle",				file:"<?= $lv_url; ?>/library/plugins/bootstrap/bootstrap-toggle/2.2.2/css/bootstrap-toggle.min.css", type:"css"},
															{name:"toggle",				file:"<?= $lv_url; ?>/library/plugins/bootstrap/bootstrap-toggle/2.2.2/js/bootstrap-toggle.min.js", type:"js"},
															
        											{name:"sha256",				file:"<?= $lv_url; ?>/library/plugins/javascript/js-sha256/0.9.0/sha256.min.js", type:"js"},
															
        											{name:"complexify",		file:"<?= $lv_url; ?>/library/plugins/jquery/jquery.complexify/0.5.1/jquery.complexify.banlist.js", type:"js"},
															{name:"complexify",		file:"<?= $lv_url; ?>/library/plugins/jquery/jquery.complexify/0.5.1/jquery.complexify.min.js", type:"js"}
															];
			var go_tmssScriptLoaded = [];			
			function tmssLoadScript( lp_nme, lp_callback ) {
				
				// el script esta cargado o en proceso de carga
				if( go_tmssScriptLoaded[lp_nme]!=undefined ) {
					// todos los archivos estan cargados?
					if (go_tmssScriptLoaded[lp_nme]["total"]!=go_tmssScriptLoaded[lp_nme]["loaded"]){
						// falta cargar archivos...esperar 10ms y preguntar de nuevo
						var lv_wait = setInterval(function(){
							if(go_tmssScriptLoaded[lp_nme]["total"]==go_tmssScriptLoaded[lp_nme]["loaded"]){
								clearInterval(lv_wait);
								lp_callback();
							}
						}, 10);
					// todos los archivos cargados
					} else {
						lp_callback();
					}
					return;
					
				// script no cargado
				} else {
					go_tmssScriptLoaded[lp_nme] = [];
					go_tmssScriptLoaded[lp_nme]["loaded"] = 0;
					go_tmssScriptLoaded[lp_nme]["files"] = [];
					go_tmssScriptLoaded[lp_nme]["callback"] = lp_callback;
				
					// cuento la cantidad de archivos con ese nombre clave
					for(var x=0; x<go_tmssScriptList.length; x++){
						if(go_tmssScriptList[x]["name"]==lp_nme){
							go_tmssScriptLoaded[lp_nme]["files"].push( go_tmssScriptList[x] );
						}
					}
					go_tmssScriptLoaded[lp_nme]["total"] = go_tmssScriptLoaded[lp_nme]["files"].length;
					
					// inicio proceso de carga
					tmssAddScript( lp_nme, 0 );
				}
			}
			
			// funcion recursiva de carga de objetos
			// se cargan los archivos de forma secuencial
			function tmssAddScript( lp_nme, lp_inx ){
				lv_fle = go_tmssScriptLoaded[lp_nme]["files"][lp_inx];
        if( typeof lv_fle == "undefined"){ return; }
				if( lv_fle["type"]=="js" || lv_fle["type"]=="module" ){
					var lo_script = document.createElement("script");
					lo_script.type = (lv_fle["type"]=="js"?"text/javascript":"module");
					lo_script.src = lv_fle["file"];
							
				} else if(lv_fle["type"]=="css") {
					var lo_script = document.createElement("link");
					lo_script.setAttribute("rel", "stylesheet");
					lo_script.setAttribute("type", "text/css");
					if(typeof lv_fle["media"]!="undefined"){
						lo_script.setAttribute("media", lv_fle["media"]);
					} else {
						lo_script.setAttribute("media", "screen");
					}
					lo_script.setAttribute("href", lv_fle["file"]);
				}
				if(typeof lo_script!="undefined") {
					lo_script.onload = function() { 
						go_tmssScriptLoaded[lp_nme]["loaded"]++;
						if(go_tmssScriptLoaded[lp_nme]["total"]==go_tmssScriptLoaded[lp_nme]["loaded"]){	
							go_tmssScriptLoaded[lp_nme]["callback"]();
						} else {
							tmssAddScript( lp_nme, go_tmssScriptLoaded[lp_nme]["loaded"] );
						}
					}
					document.head.appendChild(lo_script);
				}
			}
		</script>
  </head>
  <body>
    <?php 
      $lv_plugins = array(
                "logon"=>"sysdochdr_lgn.frm",
                "message"=>"sysdochdr_msg.frm",
                "chat"=>"sysdochdr_cht.frm",
                "popup"=>"sysdochdr_pop.frm",
                "recent"=>"sysdochdr_rec.frm",
                "favorites"=>"sysdochdr_fav.frm"
                );
			if (isset($vew_plugins)) {
				foreach( $vew_plugins as $lv_val ) {
					if (isset($lv_plugins[$lv_val])) {
						$lv_fle = "/".$lv_plugins[$lv_val];
						if (file_exists($lv_fle)) {
							include($lv_fle);
						}
					}
				}
			}
    ?>
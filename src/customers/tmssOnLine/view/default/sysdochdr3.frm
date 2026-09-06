<!DOCTYPE html> 
<html lang="es">
  <head>
    <title><?= (isset($this->data["title"])?$this->data["title"]:"Temasis"); ?></title>
    <link rel="shortcut icon" href="..\library\images\TemasisArgentina_favicon_32x32.png">
    <meta name="author" content="Temasis">
    <!--<meta name="viewport" content="width=device-width, initial-scale=1">-->
		<meta name="theme-color" content="#317EFB"/>
		<meta name="Description" content="Sistema de Gestión On-Line.">		
<!--    <meta http-equiv="X-UA-Compatible" content="IE=edge"> -->
<!--    <meta charset="utf-8"> -->
    <meta http-equiv="content-type" content="text/html; charset=iso-8859-1">
    <meta name="robots" content="noindex">
		<meta name="googlebot" content="noindex">


		<!-- PWA settings -->
		<meta	name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
		<!--
		<meta name="msapplication-starturl" content="/index.php" />
		<meta name="mobile-web-app-capable" content="yes" />
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<meta name="application-name" content="Temasis Gorse" />
		<meta name="apple-mobile-web-app-title" content="Temasis Gorse" />
		<link rel="apple-touch-icon" href="/library/pwa/library/images/icons/gorse80.png">
		<link rel="apple-touch-icon" sizes="152x152" href="/library/pwa/library/images/icons/gorse152.png">
		<link rel="apple-touch-icon" sizes="180x180" href="/library/pwa/library/images/icons/gorse180.png">
		<link rel="apple-touch-icon" sizes="167x167" href="/library/pwa/library/images/icons/gorse167.png">
		<link rel="manifest" href="manifest.json" />
		-->
		<!-- /PWA settings -->


    <!-- jquery -->
    <script src="..\library\plugins\jquery\jquery\3.6.0\jquery.min.js"></script>
		
		<!-- jQuery UI -->
		<script src="../library/plugins/jquery/jquery-ui/1.13.0/jquery-ui.min.js"></script>
		<script src="../library/plugins/jquery/jquery-ui-touch-punch/0.2.3/jquery.ui.touch-punch.min.js"></script>

		<!-- jQuery Scrollbar -->
		<script src="../library/plugins/jquery/jquery-scrollbar/0.2.10/jquery.scrollbar.min.js"></script>
		
    <!-- bootstrap -->
    <link href="..\library\plugins\bootstrap\bootstrap\3.4.1\css\bootstrap.min.css" rel="stylesheet">
    <script src="..\library\plugins\bootstrap\bootstrap\3.4.1\js\bootstrap.min.js"></script>
		
		<!-- font-awesome -->
    <link href="..\library\fonts\font-awesome\6.4.0pro\css\all.min.css" rel="stylesheet">
    <link href="view\default\library\css\toggle-switchy-1.14.css" rel="stylesheet">
    
		<!-- bootstrap dialog -->
    <link href="..\library\plugins\bootstrap\bootstrap-dialog\1.35.4\dist\css\bootstrap-dialog.min.css" rel="stylesheet">
    <script src="..\library\plugins\bootstrap\bootstrap-dialog\1.35.4\dist\js\bootstrap-dialog.min.js"></script>
		
		<!-- toastr 01.12.2017 -->
    <link href="..\library\plugins\jquery\toastr\2.1.3\build\toastr.min.css" rel="stylesheet">
    <script src="..\library\plugins\jquery\toastr\2.1.3\build\toastr.min.js"></script>
		
		<script src="..\library\plugins\javascript\momentjs\2.24.0\min\moment.min.js"></script>
		<script src="..\library\plugins\javascript\momentjs\2.24.0\locale\es.js"></script>
		<script>moment.locale("es");</script>
		<style>.datepicker.datepicker-dropdown.dropdown-menu { z-index: 6060 !important; }</style>
		
		<!-- Ready Pro -->
		<link rel="stylesheet" href="/library/css/ready.min.css">
		<script src="/library/js/ready.min.js"></script>
		
		<link href="view\default\library\css\temasis\tmssGorse-3.1.5.css" rel="stylesheet" media="screen" />
    <script src="..\library\js\temasis\tmssForm-2.2.0.js"></script>
    <script src="..\library\js\temasis\tmssFormFilter-2.0.4.js"></script>
    <script src="..\library\js\temasis\tmssTable-1.0.1.js"></script>
    <script src="..\library\js\temasis\tmssFormExport-2.0.1.js"></script>

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
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/3024-day.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/3024-night.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/abcdef.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/ambiance.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/ayu-dark.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/ayu-mirage.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/base16-dark.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/bespin.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/base16-light.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/blackboard.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/cobalt.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/colorforth.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/dracula.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/duotone-dark.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/duotone-light.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/eclipse.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/elegant.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/erlang-dark.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/gruvbox-dark.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/hopscotch.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/icecoder.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/isotope.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/lesser-dark.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/liquibyte.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/lucario.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/material.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/material-darker.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/material-palenight.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/material-ocean.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/mbo.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/mdn-like.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/midnight.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/monokai.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/moxer.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/neat.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/neo.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/night.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/nord.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/oceanic-next.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/panda-syntax.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/paraiso-dark.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/paraiso-light.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/pastel-on-dark.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/railscasts.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/rubyblue.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/seti.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/shadowfox.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/solarized.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/the-matrix.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/tomorrow-night-bright.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/tomorrow-night-eighties.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/ttcn.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/twilight.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/vibrant-ink.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/xq-dark.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/xq-light.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/yeti.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/idea.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/darcula.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/yonce.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/theme/zenburn.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/lib/codemirror.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/lib/codemirror.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/mode/xml/xml.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/mode/javascript/javascript.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/mode/css/css.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/mode/htmlmixed/htmlmixed.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/mode/clike/clike.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/mode/php/php.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/mode/sql/sql.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/addon/selection/active-line.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/addon/edit/matchbrackets.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/addon/edit/closebrackets.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/keymap/sublime.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/addon/dialog/dialog.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/addon/dialog/dialog.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/addon/search/search.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/addon/search/searchcursor	.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/addon/scroll/annotatescrollbar.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/addon/search/matchesonscrollbar.js", type:"js"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/addon/search/jump-to-line.js", type:"js"},
        											{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/addon/display/fullscreen.css", type:"css"},
															{name:"codemirror", file:"../library/plugins/javascript/codemirror/5.57.0/addon/display/fullscreen.js", type:"js"},
															
        											{name:"jsQR", file:"../library/plugins/javascript/jsqr/1.3.1/dist/jsQR.js", type:"js"},
        
															{name:"handsontable", file:"../library/plugins/jquery/handsontable/6.0.1/dist/handsontable.full.min.css", type:"css"},
															{name:"handsontable", file:"../library/plugins/jquery/handsontable/6.0.1/dist/handsontable.full.min.js", type:"js"},
															{name:"handsontable", file:"../library/plugins/jquery/handsontable/6.0.1/dist/numbro/numbro.js", type:"js"},
															{name:"handsontable", file:"../library/plugins/jquery/handsontable/6.0.1/dist/numbro/languages.min.js", type:"js"},
															{name:"handsontable", file:"../library/plugins/jquery/handsontable/6.0.1/dist/pikaday/pikaday.css", type:"css"},
															{name:"handsontable", file:"../library/plugins/jquery/handsontable/6.0.1/dist/pikaday/pikaday.js", type:"js"},
													
															{name:"table",				file:"../library/plugins/bootstrap/bootstrap-table/1.17.1/dist/bootstrap-table.min.css", type:"css"},
															{name:"table",				file:"../library/plugins/bootstrap/bootstrap-table/1.17.1/dist/bootstrap-table.min.js", type:"js"},
															
        											{name:"datepicker",		file:"../library/plugins/bootstrap/bootstrap-datepicker/1.7.0/dist/css/bootstrap-datepicker3.min.css", type:"css"},
															{name:"datepicker",		file:"../library/plugins/bootstrap/bootstrap-datepicker/1.7.0/dist/js/bootstrap-datepicker.min.js", type:"js"},
															{name:"datepicker",		file:"../library/plugins/bootstrap/bootstrap-datepicker/1.7.0/dist/locales/bootstrap-datepicker.es.min.js", type:"js"},
															
        											{name:"toggle",				file:"../library/plugins/bootstrap/bootstrap-toggle/2.2.2/css/bootstrap-toggle.min.css", type:"css"},
															{name:"toggle",				file:"../library/plugins/bootstrap/bootstrap-toggle/2.2.2/js/bootstrap-toggle.min.js", type:"js"},
															
        											{name:"typeahead",		file:"../library/plugins/bootstrap/bootstrap-typeahead/0.0.5/js/bootstrap-typeahead.js", type:"js"},
															
        											{name:"fullcalendar", file:"../library/plugins/jquery/fullcalendar/3.9.0/fullcalendar.min.css", type:"css"},
															{name:"fullcalendar", file:"../library/plugins/jquery/fullcalendar/3.9.0/fullcalendar.print.min.css", type:"css", media:"print"},
															{name:"fullcalendar", file:"../library/plugins/jquery/fullcalendar/3.9.0/fullcalendar.min.js", type:"js"},
															{name:"fullcalendar", file:"../library/plugins/jquery/fullcalendar/3.9.0/locale-all.js", type:"js"},
															
        											{name:"fullcalendar54", file:"../library/plugins/jquery/fullcalendar/5.4.0/lib/main.min.css", type:"css"},
                              {name:"fullcalendar54", file:"../library/plugins/jquery/fullcalendar/5.4.0/lib/main.min.js", type:"js"},
															{name:"fullcalendar54", file:"../library/plugins/jquery/fullcalendar/5.4.0/lib/locales-all.min.js", type:"js"},
															
        											{name:"tinymce",			file:"../library/plugins/jquery/tinymce/4.9.1/js/tinymce/tinymce.min.js", type:"js"},
															{name:"tinymce",			file:"../library/plugins/jquery/tinymce/4.9.1/js/tinymce/jquery.tinymce.min.js", type:"js"},
															
        											{name:"fileinput",		file:"../library/plugins/bootstrap/bootstrap-fileinput/5.0.9/css/fileinput.min.css", type:"css", media:"all"},
															{name:"fileinput",		file:"../library/plugins/bootstrap/bootstrap-fileinput/5.0.9/js/fileinput.min.js", type:"js"},
															{name:"fileinput",		file:"../library/plugins/bootstrap/bootstrap-fileinput/5.0.9/js/locales/es.js", type:"js"},
															{name:"video2image",	file:"../library/plugins/jquery/video2image/1.0.3/video2image.js", type:"js"},
															
        											{name:"chart",				file:"../library/plugins/javascript/chartjs/3.5.0/dist/chart.min.js", type:"js"},
															
        											{name:"jstree",				file:"../library/plugins/jquery/jstree/3.3.8/dist/themes/default/style.min.css", type:"css"},
															{name:"jstree",				file:"../library/plugins/jquery/jstree/3.3.8/dist/jstree.min.js", type:"js"},
															
        											{name:"jquery-ui",		file:"../library/plugins/jquery/jquery-ui/1.12.1/jquery-ui.min.css", type:"css"},
															{name:"jquery-ui",		file:"../library/plugins/jquery/jquery-ui/1.12.1/jquery-ui.min.js", type:"js"},
        											//{name:"jquery-ui",		file:"../library/plugins/jquery/jquery-ui-touch-punch/0.2.3/jquery-ui-touch-punch.min.js", type:"js"},
															
        											{name:"table2excel",	file:"../library/plugins/jquery/table2excel/1.1.1/dist/jquery.table2excel.min.js", type:"js"},
        											
        											{name:"excellentexport",	file:"../library/plugins/javascript/excellentexport/3.5.0/dist/excellentexport.js", type:"js"},
        											{name:"excellentexport2",	file:"../library/plugins/javascript/excellentexport/3.5.0/dist/excellentexport2.js", type:"js"},
															
        											{name:"minicolors",		file:"../library/plugins/jquery/jquery-minicolors/2.2.4/jquery.minicolors.css", type:"css"},
															{name:"minicolors",		file:"../library/plugins/jquery/jquery-minicolors/2.2.4/jquery.minicolors.min.js", type:"js"},
															
        											{name:"picadiff",			file:"../library/plugins/javascript/picadiff/0.7.1/google_diff_match_patch.js", type:"js"},
															{name:"picadiff",			file:"../library/plugins/javascript/jsdiff/jsdiff.js", type:"js"},
															
        											{name:"sha256",				file:"../library/plugins/javascript/npmjs/js-sha256/0.9.0/sha256.min.js", type:"js"},
															
        											{name:"signature_pad",file:"../library/plugins/javascript/signature_pad/3.0.0/dist/signature_pad.min.js", type:"js"},
															
        											{name:"complexify",		file:"../library/plugins/jquery/jquery.complexify/0.5.1/jquery.complexify.banlist.js", type:"js"},
															{name:"complexify",		file:"../library/plugins/jquery/jquery.complexify/0.5.1/jquery.complexify.min.js", type:"js"}
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
						},10);
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
		<script>
      var gv_tmssTabNum=0;
      var gv_tmssTabFrmNum=0;
			
      $(document).ready( function() {
        /* button add new tab */
        $("#btnAddPage").on("click", function() {
          tmssAddTab( true );
        });
				
        $("#pageTab > li > a[role='tab']").on("shown.bs.tab", function (e) {
          $("#pageTabContent > .active > div[role='tabframe']:last").toggleClass("active");
        });
      });
	</script>  
	<script>
		var lv_tmss_main_timer;
		function tmssShowTimeout() { tmssCallProcessNoBackdrop("?prg=syssecusr&act=timeout",[],function(data){}); }
		$(function(){ lv_tmss_main_timer = setInterval(tmssShowTimeout, 60000); });
	</script>
  </head>
  <body>
		<!-- PWA && NOTIFICATION
		<button id="buttonInstall" hidden style="float:left;top:0px;left:0px;z-index:9999;">Install</button>
		<button id="pushButton">Push</button>
		<input class="js-subscription-json">
		<input class="js-subscription-details">
		<script src="tmssServiceWorkerApp.js"></script>
		<style>
		.tmssPWAmsg {
			visibility: visible;
			opacity: 1;
			transition: left 0ms 1400ms, opacity 1400ms 0ms;
			position: fixed; z-index: 99999; height: 120px; width: 340px; background-color: white; border-radius: 5px; border: #a6a6a6 1px solid; top: calc( 100vH - 130px ); left: calc( 100vW - 360px ); box-shadow: 4px 4px 4px #cacaca;
		}
		.tmssPWAmsg tmssHidden {
				visibility: hidden;
				opacity: 0;
		}
		</style>
		<div id="tmssPWAinstallMsg" class="tmssPWAmsg tmssHidden">
			<i class="fas fa-download" style="padding: 10px; background-color: blue; color: white; border-radius: 50%; margin-top: 10px; margin-left: 10px; float: left;"></i>
			<span style="font-weight: bold; font-size: large; float: left; position: relative; margin-left: 10px; margin-top: 10px;">
				Temasis Gorse
			</span>
			<a href="#" onclick="$(this).parent().addClass('hidde');" style="float: right; margin-top: 15px; margin-right: 15px;"><i class="fas fa-times"></i></a>
			<span style="left: 10px; position: relative; display: block; float: left; max-width: 270px;">
				Ahora podes instalar la App de Temasis en tu dispositivo.
			</span>
			<a id="tmssPWAinstallBtn" href="#" style="text-decoration: none; background-color: blue; color: white; text-align: center; padding-top: 5px; padding-bottom: 5px; width: 100px; display: block; float: right; font-size: 16px; position: relative; left: -10px;">
				Instalar
			</a>
		</div>
		-->
		
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
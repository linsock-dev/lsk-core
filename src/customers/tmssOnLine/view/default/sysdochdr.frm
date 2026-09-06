<!DOCTYPE html> 
<html lang="es">
  <head>
    <title><?= ($vew_data["title"]??'Temasis'); ?></title>
    <link rel="shortcut icon" href="\library\images\TemasisArgentina_favicon_32x32.png">
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
		<link rel="apple-touch-icon" href="view/default/library/pwa/library/images/icons/gorse80.png">
		<link rel="apple-touch-icon" sizes="152x152" href="view/default/library/pwa/library/images/icons/gorse152.png">
		<link rel="apple-touch-icon" sizes="180x180" href="view/default/library/pwa/library/images/icons/gorse180.png">
		<link rel="apple-touch-icon" sizes="167x167" href="view/default/library/pwa/library/images/icons/gorse167.png">
		<link rel="manifest" href="manifest.json" />
		-->
		<!-- /PWA settings -->


    <!-- jquery -->
    <script src="\library\plugins\jquery\jquery\3.6.0\jquery.min.js"></script>
		
    <!-- bootstrap -->
    <link href="\library\plugins\bootstrap\bootstrap\3.4.1\css\bootstrap.min.css" rel="stylesheet">
    <script src="\library\plugins\bootstrap\bootstrap\3.4.1\js\bootstrap.min.js"></script>
		
		<!-- fonts -->
    <link href="\library\fonts\font-awesome\6.4.0pro\css\all.min.css" rel="stylesheet">
		<link href="\library\fonts\roboto\roboto.css" rel="stylesheet" type="text/css">
    
		<link href="\library\css\toggle-switchy-1.14.css" rel="stylesheet">
		
		<!-- bootstrap dialog -->
    <link href="\library\plugins\bootstrap\bootstrap-dialog\1.35.4\dist\css\bootstrap-dialog.min.css" rel="stylesheet">
    <script src="\library\plugins\bootstrap\bootstrap-dialog\1.35.4\dist\js\bootstrap-dialog.min.js"></script>
		<!--
    <link href="\library\plugins\bootstrap\bootstrap-dialog\4.3.4\dist\css\bootstrap-dialog.min.css" rel="stylesheet">
    <script src="\library\plugins\bootstrap\bootstrap-dialog\4.3.4\dist\js\bootstrap-dialog.min.js"></script>
		-->
		
		<!-- toastr 01.12.2017 -->
    <link href="\library\plugins\jquery\toastr\2.1.3\build\toastr.min.css" rel="stylesheet">
    <script src="\library\plugins\jquery\toastr\2.1.3\build\toastr.min.js"></script>
		
		<script src="\library\plugins\javascript\momentjs\2.24.0\min\moment.min.js"></script>
		<script src="\library\plugins\javascript\momentjs\2.24.0\locale\es.js"></script>
		<script>
			//if(moment.locale()!="es") {	moment.locale("es"); }
			/*
			moment.locale("es", {
					week: {
							dow: 6
					}
			});
			*/
			moment.locale("es");
		</script>
		
		<!--
		<link href="\library\plugins\jquery\select2\4.0.7\dist\css\select2.min.css" rel="stylesheet" />
		<script src="\library\plugins\jquery\select2\4.0.7\dist\js\select2.min.js"></script>
		-->
		
		<!-- dragscroll - botones desplazamiento horizontal de menu -->
		<!--<script src="\library\plugins\javascript\dragscroll\0.0.8\dragscroll.js"></script>-->
		
		<!-- CANDIDATOS AL VOLEO -->
			<!-- smartmenus 28.11.2016 -->
			<script type="text/javascript" src="\library\plugins\bootstrap\smartmenus\1.1.0\dist\jquery.smartmenus.min.js"></script>
			<link href="\library\plugins\bootstrap\smartmenus\1.1.0\dist\addons\bootstrap\jquery.smartmenus.bootstrap.css" rel="stylesheet">
			<script src="\library\plugins\bootstrap\smartmenus\1.1.0\dist\addons\bootstrap\jquery.smartmenus.bootstrap.min.js"></script>
			<script src="\library\plugins\bootstrap\smartmenus\1.1.0\dist\addons\keyboard\jquery.smartmenus.keyboard.min.js"></script>
			<!-- jasny 01.12.2017 -->
			<link href="\library\plugins\bootstrap\jasny\3.1.3\css\jasny-bootstrap.min.css" rel="stylesheet">
			<script src="\library\plugins\bootstrap\jasny\3.1.3\js\jasny-bootstrap.min.js"></script>
			<!-- DATEPICKER -->
			<link href="/library/plugins/bootstrap/bootstrap-datepicker/1.9.0/dist/css/bootstrap-datepicker3.min.css" rel="stylesheet">
			<script src="/library/plugins/bootstrap/bootstrap-datepicker/1.9.0/dist/js/bootstrap-datepicker.min.js"></script>
			<script src="/library/plugins/bootstrap/bootstrap-datepicker/1.9.0/dist/locales/bootstrap-datepicker.es.min.js"></script>
		<!-- / CANDIDATOS -->

		<style>
			.datepicker.datepicker-dropdown.dropdown-menu { z-index: 6060 !important;  }
			body{ font-family: Roboto, "Helvetica Neue",Helvetica,Arial,sans-serif; }
		</style>
		
		<?php 
    	$lv_wndsty = ''; 
    	if( isset($vew_doc) && isset($vew_usr) ) { 
        $lv_wndsty = $vew_doc->getTagValue( $vew_usr->usratr001, 'wndsty' ); 
      } 
    	$lv_wndsty = ($lv_wndsty==''?'tmssThemeDefault':$lv_wndsty); 
    	echo '<link id="theme" href="\library/css/temasis/'.$lv_wndsty.'-2.1.3.css" rel="stylesheet" media="screen" data-path="/library/css/temasis/" />'; 
    ?>    
		<link href="\library\css\temasis\tmssGorse.css?v=3.4.2" rel="stylesheet" media="screen" />
    <?php if(strpos($_SERVER['REQUEST_URI'], 'gorse.php') !== false || strpos($_SERVER['REQUEST_URI'], 'gorse2.php') !== false){ ?>
    <script src="\library\js\temasis\tmssGorse.js?v=3.5.4"></script>
    <?php } else { ?>
    <script src="\library\js\temasis\tmssForm.js?v=2.4.1"></script>
    <?php } ?>
    <script src="\library\js\temasis\tmssFormFilter.js?v=2.0.9"></script>
    <script src="\library\js\temasis\tmssTable.js?v=1.0.8"></script>
    <script src="\library\js\temasis\tmssFormExport.js?v=2.0.1"></script>

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
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/3024-day.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/3024-night.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/abcdef.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/ambiance.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/ayu-dark.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/ayu-mirage.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/base16-dark.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/bespin.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/base16-light.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/blackboard.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/cobalt.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/colorforth.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/dracula.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/duotone-dark.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/duotone-light.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/eclipse.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/elegant.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/erlang-dark.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/gruvbox-dark.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/hopscotch.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/icecoder.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/isotope.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/lesser-dark.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/liquibyte.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/lucario.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/material.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/material-darker.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/material-palenight.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/material-ocean.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/mbo.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/mdn-like.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/midnight.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/monokai.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/moxer.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/neat.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/neo.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/night.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/nord.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/oceanic-next.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/panda-syntax.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/paraiso-dark.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/paraiso-light.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/pastel-on-dark.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/railscasts.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/rubyblue.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/seti.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/shadowfox.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/solarized.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/the-matrix.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/tomorrow-night-bright.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/tomorrow-night-eighties.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/ttcn.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/twilight.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/vibrant-ink.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/xq-dark.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/xq-light.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/yeti.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/idea.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/darcula.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/yonce.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/theme/zenburn.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/lib/codemirror.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/lib/codemirror.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/mode/xml/xml.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/mode/javascript/javascript.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/mode/css/css.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/mode/htmlmixed/htmlmixed.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/mode/clike/clike.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/mode/php/php.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/mode/sql/sql.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/selection/active-line.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/edit/matchbrackets.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/edit/closebrackets.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/keymap/sublime.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/merge/merge.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/merge/merge.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/merge/merge.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/merge/google_diff_match_patch.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/dialog/dialog.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/dialog/dialog.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/search/search.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/search/searchcursor	.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/scroll/annotatescrollbar.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/search/matchesonscrollbar.js", type:"js"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/search/jump-to-line.js", type:"js"},
        											{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/display/fullscreen.css", type:"css"},
															{name:"codemirror", file:"/library/plugins/javascript/codemirror/5.57.0/addon/display/fullscreen.js", type:"js"},
															
        											{name:"jsQR", file:"/library/plugins/javascript/jsqr/1.3.1/dist/jsQR.js", type:"js"},
        
															{name:"handsontable", file:"/library/plugins/jquery/handsontable/6.0.1/dist/handsontable.full.min.css", type:"css"},
															{name:"handsontable", file:"/library/plugins/jquery/handsontable/6.0.1/dist/handsontable.full.min.js", type:"js"},
															{name:"handsontable", file:"/library/plugins/jquery/handsontable/6.0.1/dist/numbro/numbro.js", type:"js"},
															{name:"handsontable", file:"/library/plugins/jquery/handsontable/6.0.1/dist/numbro/languages.min.js", type:"js"},
															{name:"handsontable", file:"/library/plugins/jquery/handsontable/6.0.1/dist/pikaday/pikaday.css", type:"css"},
															{name:"handsontable", file:"/library/plugins/jquery/handsontable/6.0.1/dist/pikaday/pikaday.js", type:"js"},
																													
                             {name:"handsontable16", file:"/library/plugins/jquery/handsontable/16.0.0/dist/dompurify/purify.js", type:"js"},
															{name:"handsontable16", file:"/library/plugins/jquery/handsontable/16.0.0/dist/numbro/numbro.js", type:"js"},
															{name:"handsontable16", file:"/library/plugins/jquery/handsontable/16.0.0/dist/numbro/languages.min.js", type:"js"},
															{name:"handsontable16", file:"/library/plugins/jquery/handsontable/16.0.0/dist/pikaday/pikaday.css", type:"css"},
															{name:"handsontable16", file:"/library/plugins/jquery/handsontable/16.0.0/dist/pikaday/pikaday.js", type:"js"},
                              {name:"handsontable16", file:"/library/plugins/jquery/handsontable/16.0.0/dist/handsontable.min.js", type:"js"},
															{name:"handsontable16", file:"/library/plugins/jquery/handsontable/16.0.0/dist/handsontable.min.css", type:"css"},
                          
												
															{name:"table",				file:"/library/plugins/bootstrap/bootstrap-table/1.17.1/dist/bootstrap-table.min.css", type:"css"},
															{name:"table",				file:"/library/plugins/bootstrap/bootstrap-table/1.17.1/dist/bootstrap-table.min.js", type:"js"},
															/*
															{name:"table",				file:"/library/plugins/bootstrap/bootstrap-table/1.17.1/dist/extensions/fixed-columns/bootstrap-table-fixed-columns.min.css", type:"css"},
															{name:"table",				file:"/library/plugins/bootstrap/bootstrap-table/1.17.1/dist/extensions/fixed-columns/bootstrap-table-fixed-columns.min.js", type:"js"},
															{name:"table",				file:"/library/plugins/bootstrap/bootstrap-table/1.17.1/dist/extensions/sticky-header/bootstrap-table-sticky-header.min.css", type:"css"},
															{name:"table",				file:"/library/plugins/bootstrap/bootstrap-table/1.17.1/dist/extensions/sticky-header/bootstrap-table-sticky-header.min.js", type:"js"},
															*/
        											{name:"datepicker",		file:"/library/plugins/bootstrap/bootstrap-datepicker/1.7.0/dist/css/bootstrap-datepicker3.min.css", type:"css"},
															{name:"datepicker",		file:"/library/plugins/bootstrap/bootstrap-datepicker/1.7.0/dist/js/bootstrap-datepicker.min.js", type:"js"},
															{name:"datepicker",		file:"/library/plugins/bootstrap/bootstrap-datepicker/1.7.0/dist/locales/bootstrap-datepicker.es.min.js", type:"js"},
															
        											{name:"toggle",				file:"/library/plugins/bootstrap/bootstrap-toggle/2.2.2/css/bootstrap-toggle.min.css", type:"css"},
															{name:"toggle",				file:"/library/plugins/bootstrap/bootstrap-toggle/2.2.2/js/bootstrap-toggle.min.js", type:"js"},
															// typeahead 0.0.6: ADD. configuración de headers al ajax
        											{name:"typeahead",		file:"/library/plugins/bootstrap/bootstrap-typeahead/0.0.6/js/bootstrap-typeahead.js", type:"js"},
															
															/*
        											{name:"fullcalendar", file:"/library/plugins/jquery/fullcalendar/3.9.0/fullcalendar.min.css", type:"css"},
															{name:"fullcalendar", file:"/library/plugins/jquery/fullcalendar/3.9.0/fullcalendar.print.min.css", type:"css", media:"print"},
															{name:"fullcalendar", file:"/library/plugins/jquery/fullcalendar/3.9.0/fullcalendar.min.js", type:"js"},
															{name:"fullcalendar", file:"/library/plugins/jquery/fullcalendar/3.9.0/locale-all.js", type:"js"},
															*/
        											{name:"fullcalendar", file:"/library/plugins/jquery/fullcalendar/6.1.8/dist/index.global.min.js", type:"js"},
															
        											{name:"fullcalendar54", file:"/library/plugins/jquery/fullcalendar/5.4.0/lib/main.min.css", type:"css"},
                              {name:"fullcalendar54", file:"/library/plugins/jquery/fullcalendar/5.4.0/lib/main.min.js", type:"js"},
															{name:"fullcalendar54", file:"/library/plugins/jquery/fullcalendar/5.4.0/lib/locales-all.min.js", type:"js"},
															
        											{name:"tinymce",			file:"/library/plugins/jquery/tinymce/4.9.1/js/tinymce/tinymce.min.js", type:"js"},
															{name:"tinymce",			file:"/library/plugins/jquery/tinymce/4.9.1/js/tinymce/jquery.tinymce.min.js", type:"js"},
        											//{name:"tinymce",			file:"/library/plugins/jquery/tinymce/7.9.1/tinymce.min.js", type:"js"},
															
        											{name:"fileinput",		file:"/library/plugins/bootstrap/bootstrap-fileinput/5.0.9/css/fileinput.min.css", type:"css", media:"all"},
															{name:"fileinput",		file:"/library/plugins/bootstrap/bootstrap-fileinput/5.0.9/js/fileinput.min.js", type:"js"},
															{name:"fileinput",		file:"/library/plugins/bootstrap/bootstrap-fileinput/5.0.9/js/locales/es.js", type:"js"},
															{name:"video2image",	file:"/library/plugins/jquery/video2image/1.0.3/video2image.js", type:"js"},
															
        											{name:"chart",				file:"/library/plugins/javascript/chartjs/3.5.0/dist/chart.min.js", type:"js"},
															
        											{name:"jstree",				file:"/library/plugins/jquery/jstree/3.3.8/dist/themes/default/style.min.css", type:"css"},
															{name:"jstree",				file:"/library/plugins/jquery/jstree/3.3.8/dist/jstree.min.js", type:"js"},
															
        											{name:"jquery-ui",		file:"/library/plugins/jquery/jquery-ui/1.12.1/jquery-ui.min.css", type:"css"},
															{name:"jquery-ui",		file:"/library/plugins/jquery/jquery-ui/1.12.1/jquery-ui.min.js", type:"js"},
        											//{name:"jquery-ui",		file:"/library/plugins/jquery/jquery-ui-touch-punch/0.2.3/jquery-ui-touch-punch.min.js", type:"js"},
															
        											{name:"table2excel",	file:"/library/plugins/jquery/table2excel/1.1.1/dist/jquery.table2excel.min.js", type:"js"},
        											
        											{name:"excellentexport",	file:"/library/plugins/javascript/excellentexport/3.5.0/dist/excellentexport.js", type:"js"},
        											{name:"excellentexport2",	file:"/library/plugins/javascript/excellentexport/3.5.0/dist/excellentexport2.js", type:"js"},
															
        											{name:"minicolors",		file:"/library/plugins/jquery/jquery-minicolors/2.2.4/jquery.minicolors.css", type:"css"},
															{name:"minicolors",		file:"/library/plugins/jquery/jquery-minicolors/2.2.4/jquery.minicolors.min.js", type:"js"},
															
        											{name:"picadiff",			file:"/library/plugins/javascript/picadiff/0.7.1/css/jquery.picadiff.css", type:"css"},
        											{name:"picadiff",			file:"/library/plugins/javascript/picadiff/0.7.1/google_diff_match_patch.js", type:"js"},
        											//{name:"picadiff",			file:"/library/plugins/javascript/picadiff/0.7.1/src/diff_match_patch_extended.js", type:"js"},
        											{name:"picadiff",			file:"/library/plugins/javascript/picadiff/0.7.1/src/picadiff.js", type:"js"},
															//{name:"picadiff",			file:"/library/plugins/javascript/jsdiff/jsdiff.js", type:"js"},
															
        											{name:"orgchart",			file:"/library/plugins/jquery/orgchart/3.6.0/dist/css/jquery.orgchart.min.css", type:"css"},
															{name:"orgchart",			file:"/library/plugins/jquery/orgchart/3.6.0/dist/js/jquery.orgchart.min.js", type:"js"},
        										// NO BORRAR	{name:"orgchart",			file:"/library/plugins/jquery/orgchart/5.0.0/dist/css/jquery.orgchart.min.css", type:"css"},
														// NO BORRAR	{name:"orgchart",			file:"/library/plugins/jquery/orgchart/5.0.0/dist/js/jquery.orgchart.min.js", type:"js"},
        
        											{name:"jsondigger",			file:"/library/plugins/javascript/json-digger/2.0.1/dist/json-digger.js", type:"js"},
															
        											{name:"sha256",				file:"/library/plugins/javascript/js-sha256/0.9.0/sha256.min.js", type:"js"},
															
        											{name:"sheetjs",			file:"/library/plugins/javascript/sheetjs/0.19.2/dist/xlsx.full.min.js", type:"js"},
        											{name:"sheetjs",			file:"/library/plugins/javascript/sheetjs/js-codepage/1.15.0/dist/cpexcel.full.js", type:"js"},

        											{name:"signature_pad",file:"/library/plugins/javascript/signature_pad/3.0.0/dist/signature_pad.min.js", type:"js"},
															
        											{name:"complexify",		file:"/library/plugins/jquery/jquery.complexify/0.5.1/jquery.complexify.banlist.js", type:"js"},
															{name:"complexify",		file:"/library/plugins/jquery/jquery.complexify/0.5.1/jquery.complexify.min.js", type:"js"},
        
															{name:"cryptojs",		file:"/library/plugins/javascript/cryptojs/4.2.0/src/core.js", type:"js"},
        											{name:"cryptojs",		file:"/library/plugins/javascript/cryptojs/4.2.0/src/enc-base64.js", type:"js"},
															{name:"cryptojs",		file:"/library/plugins/javascript/cryptojs/4.2.0/src/cipher-core.js", type:"js"},
        											{name:"cryptojs",		file:"/library/plugins/javascript/cryptojs/4.2.0/src/aes.js", type:"js"},
        											{name:"cryptojs",		file:"/library/plugins/javascript/cryptojs/4.2.0/src/sha256.js", type:"js"},
        											
        											{name:"dropzone",	file:"/library/plugins/javascript/dropzone/5.9.3/dropzone.min.js", type:"js"},
        											{name:"dropzone",	file:"/library/plugins/javascript/dropzone/5.9.3/dropzone.min.css", type:"css"}
															
															];
			var go_tmssScriptLoaded = [];			
			function tmssLoadScript( lp_nme, lp_callback ) {
				
				// el script esta cargado o en proceso de carga
        //BORRAR LUEGO DE MIGRACION LA CONDICION DERECHA DEL IF
				if( go_tmssScriptLoaded[lp_nme]!=undefined && ( !lp_nme.startsWith("handsontable") || (go_tmssScriptLoaded[lp_nme]["pending"] ?? false) ||(window.Handsontable?.version == "16.0.0" && lp_nme == "handsontable16") ||
    (window.Handsontable?.version == "6.0.1"  && lp_nme == "handsontable"))) {
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
          //BORRAR LUEGO DE MIGRACION
					if(lp_nme.startsWith("handsontable")){go_tmssScriptLoaded[lp_nme]["pending"] = true;}
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
              //BORRAR LUEGO DE MIGRACION
              if(lp_nme.startsWith("handsontable")){go_tmssScriptLoaded[lp_nme]["pending"] = false;}
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
			var gv_handsontable_lc = "f9ee1-b0498-8afe5-7292d-7c51f";
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
		$(function(){ lv_tmss_main_timer = setInterval(tmssShowTimeout, 1000*60*5); });
	</script>
    <script>
      $(function(){
        <?php if(isset($vew_data['usrtkn']['data'])){ ?>
        localStorage.setItem("gorse-token", "<?= $vew_data['usrtkn']['data']; ?>" );
        <?php } ?>
      });
    </script>
  <script>
    <?php 
    			$lv_url = $_SERVER['SCRIPT_NAME'] . '/' . $vew_sec->buscodcus;
          $lv_path = explode('/',str_ireplace( '\\' , '/' , strtolower($lv_url)));
          if(isset($lv_path[1]) && ($lv_path[1] == 'gorse.php' || $lv_path[1] == 'gorse2.php')){?>
    
    $(function(){
        // Initialize history state on page load (replaceState)
        // This ensures that hitting "Back" to the landing page works correctly.
        var lv_ajax = location.search;
        var lv_url = location.pathname + location.search;
        var lv_ttl = document.title.replace('Gorse - ', ''); // Extract title if possible
        
        // We assume the current page content matches this URL/Ajax.
        if (typeof tmssSetUrl === "function") {
             tmssSetUrl(lv_url, lv_ttl, lv_ajax, true);
        }
    });

    document.addEventListener("click", (e) => {
      const enlace = e.target.closest("a"); // Capturamos el enlace
      
      // Si el enlace existe
      if (enlace) {          
          const hrefVal = (enlace.getAttribute('href') || '').trim();

          if (hrefVal === '#' || hrefVal === '' || hrefVal.startsWith('javascript:')) {
              e.preventDefault();
              return;
          }

          // Si es un link real que queremos interceptar (SPA)
          if (enlace.href) {
             // Por ahora prevenimos todos para mantener comportamiento SPA si se desea
             // o podemos dejar pasar los externos. 
             // La lógica original prevenía todo. Mantenemos eso para evitar recargas accidentales.
             e.preventDefault();
          }
      }
	});
    <? } ?>
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
	<?php if(strpos($_SERVER['REQUEST_URI'], 'gorse2.php') === false ){ include_once('..\tmssOnLine\view\default\sysdochdr_lgn.frm'); }?>
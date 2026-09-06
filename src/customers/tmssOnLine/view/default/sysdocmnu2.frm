<?php
	// recursiva para mostrar menú
	function armar_menu( $lp_mnu, &$vew_lang, $lp_mdltxt ) {
		$lv_buffer='';
		$lv_count=0;
		foreach( $lp_mnu as $lv_row ) {
			$lv_buffer_sub='';
			$lv_row['prgpic'] = trim(strtolower($lv_row['prgpic']));
			$lv_pic=($lv_row['prgpic']==''?'':(substr($lv_row['prgpic'],0,6)=='class:'?'<i class="'.substr($lv_row['prgpic'],6,strlen($lv_row['prgpic'])-6).'"></i>':'<img src="/library/images/'.$lv_row['prgpic'].'" class="tmss-icon">'));
			// módulo
			if ( $lv_row['prgtypcod']==0 ) {
				if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub = armar_menu( $lv_row['mnulst'], $vew_lang, $vew_lang->get($lv_row['mdltxt']) ); }
				if ( $lv_buffer_sub!='' ) {
					$lv_row['mdlpic'] = trim(strtolower($lv_row['mdlpic']));
					$lv_pic=($lv_row['mdlpic']==''?'':(substr($lv_row['mdlpic'],0,6)=='class:'?'<i class="'.substr($lv_row['mdlpic'],6,strlen($lv_row['mdlpic'])-6).'"></i>':'<img src="/library/images/'.$lv_row['mdlpic'].'" class="tmss-icon">'));

					$lv_buffer.='<li class="nav-item">'.
												'<a data-toggle="collapse" href="#'.$lv_row['mdlcod'].'">'.
													$lv_pic.
													'<p>'.$vew_lang->get($lv_row['mdltxt']).'</p>'.
													'<span class="caret"></span>'.
												'</a>'.
												'<div class="collapse" id="'.$lv_row['mdlcod'].'">'.
													'<ul class="nav nav-collapse subnav">'.
														$lv_buffer_sub.
													'</ul>'.
												'</div>'.
											'</li>';
				}
			// carpeta
			} else if ( $lv_row['prgtypcod']==3 ) {
				if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub=armar_menu( $lv_row['mnulst'], $vew_lang, $lp_mdltxt ); }
				if ( $lv_buffer_sub!='' ) {
					$lv_buffer.='<li class="nav-item">'.
												'<a data-toggle="collapse" href="#'.$lv_row['mdlcod'].'_'.$lv_row['prgcod'].'">'.
													$lv_pic.
													'<p>'.$vew_lang->get($lv_row['prgtxt']).'</p>'.
													'<span class="caret"></span>'.
												'</a>'.
												'<div class="collapse" id="'.$lv_row['mdlcod'].'_'.$lv_row['prgcod'].'">'.
													'<ul class="nav nav-collapse subnav">'.
														$lv_buffer_sub.
													'</ul>'.
												'</div>'.
											'</li>';
				}
			// programa
			} else if ( $lv_row['prgtypcod']==1 ) {
				// $lv_pic.' '.$vew_lang->get($lv_row['prgtxt']).
				$lv_link = 'tmssLink('.chr(39).$lv_row['prgfrm'].(stripos($lv_row['prgfrm'],'?')===false?'?':'&').'prm_mdlcod='.$lv_row['mdlcod'].'&prm_prgcod='.$lv_row['prgcod'].chr(39).', [{tab_title:'.chr(39).$vew_lang->get($lv_row['prgtxt']).chr(39).', url_data: [{vewcod: '.chr(39).$lv_row['vewcod'].chr(39).'}] }] );';
				$lv_buffer.='<li>'.
											'<a href="#" onclick="'.$lv_link.'" data-prgkey="'.$lv_row['mdlcod'].'_'.$lv_row['prgcod'].'" data-prgtxt="'.$vew_lang->get($lv_row['prgtxt']).'" data-mdltxt="'.$lp_mdltxt.'">'.
												'<span class="sub-item">'.$lv_pic.' '.$vew_lang->get($lv_row['prgtxt']).'</span>'.
											'</a>'.
										'</li>';
			}
			$lv_count++;
		}
		return $lv_buffer;
	}
?>
	<script>
		"use strict";

		function layoutsColors() {
				$(".sidebar").is("[data-background-color]") ? $("html").addClass("sidebar-color") : $("html").removeClass("sidebar-color"), $(".sidebar").is("[data-image]") ? ($(".sidebar").append("<div class='sidebar-background'></div>"), $(".sidebar-background").css("background-image", 'url("' + $(".sidebar").attr("data-image") + '")')) : ($(this).remove(".sidebar-background"), $(".sidebar-background").css("background-image", ""))
		}

		function legendClickCallback(a) {
				for (var e = (a = a || window.event).target || a.srcElement;
						"LI" !== e.nodeName;) e = e.parentElement;
				var s = e.parentElement,
						i = parseInt(s.classList[0].split("-")[0], 10),
						n = Chart.instances[i],
						o = Array.prototype.slice.call(s.children).indexOf(e);
				n.legend.options.onClick.call(n, a, n.legend.legendItems[o]), n.isDatasetVisible(o) ? e.classList.remove("hidden") : e.classList.add("hidden")
		}
		
		function showPassword(a) {
				var e = $(a).parent().find("input");
				"password" === e.attr("type") ? e.attr("type", "text") : e.attr("type", "password")
		}
		//$(function() {
				//$('[data-toggle="tooltip"]').tooltip(), $('[data-toggle="popover"]').popover(), layoutsColors()
		//}), 

		$(function(){
			var h = $(".btn-minimize");
			if( $("html").hasClass("sidebar_minimize") && h.addClass("toggled") ){ 
				h.html('<i class="la la-ellipsis-v"></i>'); 
			}
			h.on("click", function() {
				if($("html").hasClass("sidebar_minimize")){
					$("html").removeClass("sidebar_minimize");
					$(this).removeClass("toggled").html('<i class="la la-navicon"></i>');
				} else {
					$("html").addClass("sidebar_minimize");
					$(this).addClass("toggled").html('<i class="la la-ellipsis-v"></i>')
				}
				$(window).resize();
			});
		});

		$(function() {
		/*
				$(".sidebar").on("data-attribute-changed", function() {
						layoutsColors();
				});
				var a = $(".sidebar .scrollbar-inner");
				a.length > 0 && a.scrollbar();
				
				var e = $(".messages-scroll.scrollbar-outer");
				e.length > 0 && e.scrollbar();
				
				var s = $(".tasks-scroll.scrollbar-outer");
				s.length > 0 && s.scrollbar();
				
				var i = $(".quick-scroll");
				i.length > 0 && i.scrollbar(), $(".scroll-bar").draggable();
				
				var n, o = !1,
						t = !1,
						l = !1,
						r = 0,
						c = 0,
						d = 0,
						g = 0;
				o || ((n = $(".sidenav-toggler")).click(function() {
						1 == r ? ($("html").removeClass("nav_open"), n.removeClass("toggled"), r = 0) : ($("html").addClass("nav_open"), n.addClass("toggled"), r = 1)
				}), o = !0);
				c || ((n = $(".quick-sidebar-toggler")).click(function() {
						1 == r ? ($("html").removeClass("quick_sidebar_open"), $(".quick-sidebar-overlay").remove(), n.removeClass("toggled"), c = 0) : ($("html").addClass("quick_sidebar_open"), n.addClass("toggled"), $('<div class="quick-sidebar-overlay"></div>').insertAfter(".quick-sidebar"), c = 1)
				}), $(".wrapper").mouseup(function(a) {
						var e = $(".quick-sidebar");
						a.target.className == e.attr("class") || e.has(a.target).length || ($("html").removeClass("quick_sidebar_open"), $(".quick-sidebar-toggler").removeClass("toggled"), $(".quick-sidebar-overlay").remove(), c = 0)
				}), $(".close-quick-sidebar").on("click", function() {
						$("html").removeClass("quick_sidebar_open"), $(".quick-sidebar-toggler").removeClass("toggled"), $(".quick-sidebar-overlay").remove(), c = 0
				}), c = !0);
				
				if (!t) {
						var m = $(".topbar-toggler");
						m.on("click", function() {
								1 == d ? ($("html").removeClass("topbar_open"), m.removeClass("toggled"), d = 0) : ($("html").addClass("topbar_open"), m.addClass("toggled"), d = 1)
						}), t = !0
				}
				
				*/
				$(".sidebar").hover(function() {
						$("html").hasClass("sidebar_minimize") && $("html").addClass("sidebar_minimize_hover")
				}, function() {
						$("html").hasClass("sidebar_minimize") && $("html").removeClass("sidebar_minimize_hover")
				}), $(".nav-item a").on("click", function() {
						$(this).parent().find(".collapse").hasClass("show") ? $(this).parent().removeClass("submenu") : $(this).parent().addClass("submenu")
				}), $(".messages-contact .user a").on("click", function() {
						$(".tab-chat").addClass("show-chat")
				}), $(".messages-wrapper .return").on("click", function() {
						$(".tab-chat").removeClass("show-chat")
				}), $('[data-select="checkbox"]').change(function() {
						var target = $(this).attr("data-target");
						$(target).prop("checked", $(this).prop("checked"))
				}), $(".form-group-default .form-control").focus(function() {
						$(this).parent().addClass("active")
				}).blur(function() {
						$(this).parent().removeClass("active")
				})
				
		});
		/*
		, $(".show-password").on("click", function() {
				showPassword(this)
		});
		var containerSignIn = $(".container-login"),
				containerSignUp = $(".container-signup"),
				showSignIn = !0,
				showSignUp = !1;

		function changeContainer() {
				1 == showSignIn ? containerSignIn.css("display", "block") : containerSignIn.css("display", "none"), 1 == showSignUp ? containerSignUp.css("display", "block") : containerSignUp.css("display", "none")
		}
		$("#show-signup").on("click", function() {
				showSignUp = !0, showSignIn = !1, changeContainer()
		}), $("#show-signin").on("click", function() {
				showSignUp = !1, showSignIn = !0, changeContainer()
		}), changeContainer(), $(".form-floating-label .form-control").keyup(function() {
				"" !== $(this).val() ? $(this).addClass("filled") : $(this).removeClass("filled")
		});
		*/
	</script>
	<script>
		jQuery(document).ready(function(){
			
			$(".nav-item a").on("click",function(){
				if( $(this).parent().find(".collapse").hasClass("in") ) {	/* en BS4 cambiar "in" por "show" */
					$(this).parent().removeClass("submenu");
				} else {
					$(this).parent().addClass("submenu");
				}
			});
			
			jQuery('.scrollbar-dynamic').scrollbar();
			
			tmssLoadScript("typeahead",function(){
				var lv_arr = Array();
				$(".sidebar li a").each(function(){
					if($(this).data("prgkey")!="" && $(this).data("prgkey")!=undefined){
						lv_arr.push( {mdltxt:$(this).data("mdltxt"), prgtxt: $(this).data("prgtxt"), prgkey:$(this).data("prgkey"), prgpic:$(this).find("i:first").prop("class")} );
					}
				});
				$(".main-header #search-input").typeahead({
					source: lv_arr,
					displayField: "prgtxt",
					valueField: "prgkey",
					onSelect: function(item) {
						tmssShowItem( item.value );
					},
					render: function(data){
						this.shown = true;
						$(".main-header .typeahead.dropdown-menu").addClass("search-results").addClass("animated").addClass("fadeIn");
						var lv_ret = "";
						for(var i=0; i<data.length; i++){
							lv_ret += "<li class='' data-value='"+data[i].prgkey+"'><a href='#'><i class='"+data[i]["prgpic"]+"'></i><p>"+data[i]["prgtxt"]+"<br><small>"+data[i]["mdltxt"]+"</small></p></a></li>";
						}
						$(".search-results").html( lv_ret );
						return $(".main-header .typeahead.dropdown-menu");
					}
				});
			});
				
		});

		function tmssShowItem( lp_itm ) {
			$(".sidebar li a[data-prgkey="+lp_itm+"]").trigger("click");
			$("#search-input").prop("value","");
			$(".search-results").hide();
		}
		
		function tmssAddTab2( lp_act ) {
			gv_tmssTabNum++;
			$("#pageTab").append( "<li role='presentation'><a href='#tmssTab"+gv_tmssTabNum+"' aria-controls='tmssTab"+gv_tmssTabNum+"' role='tab' data-toggle='tab'>(vacio)</a></li>" );
			$("#pageTabContent").append( "<div role='tabpanel' class='tab-pane scroll-dynamic' id='tmssTab"+gv_tmssTabNum+"'></div>" );
			tmssAddTabFrame2( gv_tmssTabNum );
			if ( lp_act==true ) { $("#pageTab a[href='#tmssTab"+gv_tmssTabNum+"']").tab("show"); }
			//$("#tmssTab"+gv_tmssTabNum).scrollbar();
		}
    
		/**
		 * add new frame
		 * lp_tab: integer - tab index who include this new frame             
		 */
		function tmssAddTabFrame2( lp_tab ) {
			gv_tmssTabFrmNum++;
			// desactivo el panel activo anterior
			$("#pageTabContent > #tmssTab"+lp_tab+" > .tab-frame:last").removeClass("active");
			// agrego un nuevo panel
			$("#pageTabContent > #tmssTab"+lp_tab).append("<div role='tabframe' class='tab-frame tmss-tab-frame active'><nav class='navbar navbar-default'><div class='container-fluid'><ul class='nav navbar-nav navbar-right'><li><a href='#' onclick='tmssTabFrmCls(this);' title='Cerrar'><span class='fas fa-times'></span></a></li></ul></div></nav></div>");
		}
	</script>
	<div class="wrapper">
	
		<div class="main-header">
			
			<!-- Logo Header -->
			<div class="logo-header">
				<a href="#" class="big-logo">
					<img src="view/bs42/library/img/logoresponsive.png" alt="logo img" class="logo-img">
				</a>
				<a href="#" class="logo">
					<span alt="navbar brand" class="navbar-brand">Temasis</span><!--TEMASIS - LOGISTICA</span>-->
					<!--<img src="view/bs42/library/img/logoheader.png" alt="navbar brand" class="navbar-brand">-->
				</a>
				<button class="navbar-toggler sidenav-toggler ml-auto" type="button" data-toggle="collapse" data-target="collapse" aria-expanded="false" aria-label="Toggle navigation">
					<span class="navbar-toggler-icon">
						<i class="la la-bars"></i>
					</span>
				</button>
				<button class="topbar-toggler more"><i class="la la-ellipsis-v"></i></button>
			</div>
			<!-- End Logo Header -->

			<!-- Navbar Header -->
			<nav class="navbar navbar-header navbar-expand-lg" data-background-color="blue">
				<div class="container-fluid">
					<div class="navbar-minimize">
						<button class="btn btn-minimize btn-rounded">
							<i class="la la-navicon"></i>
						</button>
					</div>
					<div class="collapse" id="search-nav">
						<form class="navbar-left navbar-form nav-search ml-md-3 mr-md-3">
							<div class="input-group">
								<div class="input-group-addon"><i class="la la-search search-icon"></i></div>
								<input type="text" id="search-input" placeholder="Buscar ..." class="form-control search-input">
							</div>
						</form>
					</div>
					<ul class="navbar-nav topbar-nav ml-md-auto align-items-center">
						<li class="nav-item toggle-nav-search hidden-caret">
							<a class="nav-link" data-toggle="collapse" href="#search-nav" role="button" aria-expanded="false" aria-controls="search-nav">
								<i class="flaticon-search-1"></i>
							</a>
						</li>
						<li class="nav-item dropdown hidden-caret">
							<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								<!--<i class="flaticon-envelope-1"></i>-->
								<i class="far fa-envelope"></i>
							</a>
							<div class="dropdown-menu" aria-labelledby="navbarDropdown">
								<a class="dropdown-item" href="#">Action</a>
								<a class="dropdown-item" href="#">Another action</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item" href="#">Something else here</a>
							</div>
						</li>
						<li class="nav-item dropdown hidden-caret">
							<a class="nav-link dropdown-toggle" href="#" id="notifDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								<!--<i class="flaticon-alarm"></i>-->
								<i class="far fa-bell"></i>
								<span class="notification">3</span>
							</a>
							<ul class="dropdown-menu notif-box animated fadeIn" aria-labelledby="notifDropdown">
								<li><div class="dropdown-title">You have 4 new notification</div></li>
								<li>
									<div class="notif-center">
										<a href="#">
											<div class="notif-icon notif-primary"> <i class="la la-user-plus"></i> </div>
											<div class="notif-content">
												<span class="block">
													New user registered
												</span>
												<span class="time">5 minutes ago</span> 
											</div>
										</a>
										<a href="#">
											<div class="notif-icon notif-success"> <i class="la la-comment"></i> </div>
											<div class="notif-content">
												<span class="block">
													Rahmad commented on Admin
												</span>
												<span class="time">12 minutes ago</span> 
											</div>
										</a>
										<a href="#">
											<div class="notif-img"> 
												<img src="view/bs42/library/img/profile2.jpg" alt="Img Profile">
											</div>
											<div class="notif-content">
												<span class="block">
													Reza send messages to you
												</span>
												<span class="time">12 minutes ago</span> 
											</div>
										</a>
										<a href="#">
											<div class="notif-icon notif-danger"> <i class="la la-heart"></i> </div>
											<div class="notif-content">
												<span class="block">
													Farrah liked Admin
												</span>
												<span class="time">17 minutes ago</span> 
											</div>
										</a>
									</div>
								</li>
								<li>
									<a class="see-all" href="javascript:void(0);">See all notifications<i class="la la-angle-right"></i> </a>
								</li>
							</ul>
						</li>
						<li class="nav-item dropdown hidden-caret">
							<a class="dropdown-toggle profile-pic" data-toggle="dropdown" href="#" aria-expanded="false"> <img src="view/bs42/library/img/profile.jpg" alt="image profile" width="36" class="img-circle"></a>
							<ul class="dropdown-menu dropdown-user animated fadeIn">
								<li>
									<div class="user-box">
										<div class="u-img"><img src="view/bs42/library/img/profile.jpg" alt="image profile"></div>
										<div class="u-text">
											<h4>DOMINGUEZ, IGNACIO</h4>
											<p class="text-muted">mdominguez2@temasis.com.ar</p>
											<a href="#" onclick="tmssLink('?prg=syssecusr&amp;act=25',[{tab_title:'Mi cuenta'}]);" class="btn btn-rounded btn-danger btn-sm">Mi cuenta</a>
										</div>
									</div>
								</li>
								<li>
									<!--
									<div class="dropdown-divider"></div>
									<a class="dropdown-item" href="#">My Profile</a>
									<a class="dropdown-item" href="#">My Balance</a>
									<a class="dropdown-item" href="#">Inbox</a>
									<div class="dropdown-divider"></div>
									-->
																			</li><li class="dropdown-divider"></li>
										<!--<li class="dropdown-header">TEMASIS - LOGISTICA</li>-->
										<li class="dropdown-item" id="btnnavbus">Empresas</li>
																		<div class="dropdown-divider"></div>
									<a class="dropdown-item" href="?prg=syssecusr&amp;act=99">Salir</a>									
								
							</ul>
						</li>
						<li class="nav-item">
							<a href="#" class="nav-link quick-sidebar-toggler">
								<!--<i class="flaticon-shapes-1"></i>-->
								<i class="fas fa-th"></i>
							</a>
						</li>
					</ul>
				</div>
			</nav>
			<!-- End Navbar -->
			
		</div>
		
		<div class="sidebar">
			<div class="sidebar-background"></div>
			<div class="sidebar-content">
				<div class="sidebar-wrapper scrollbar-dynamic">
					<ul class="nav">
						<?= armar_menu( $vew_mnu, $vew_lang, '' ); ?>
					</ul>
					<br><br><br><br><br>
				</div>
			</div>
		</div>
		
		<div class="main-panel">
			<div class="content" style="margin-top: 35px; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;">
				<div class="container-fluid">
					<nav class="navbar tmss-tabs">
						<ul class="nav nav-tabs hidden-print" role="tablist" id="pageTab">
							<li class="nav-item"><a href="#" onclick="tmssAddTab(true);" id="btnAddPage2" class="btn"><i class="fas fa-plus-circle"></i></a></li>
						</ul>
						<div class="tab-content" id="pageTabContent"></div>
					</nav>
					<script>
						$(function(){
							tmssAddTab2( true );
							var lv_redirect = '/*script*/tmssLink("index.php?prg=grlstr", [{tab_title:"Inicio"}] );';
							if (lv_redirect!='' && lv_redirect.substring(0,10)=='/*script*/') { eval( lv_redirect ); }
						});
					</script>
				</div>
			</div>
		</div>
		
		<div class="quick-sidebar">
			<a href="#" class="close-quick-sidebar">
				<i class="flaticon-cross"></i>
			</a>
			<div class="quick-sidebar-wrapper">
				<ul class="nav nav-tabs nav-line nav-color-primary" role="tablist">
					<li class="nav-item"> <a class="nav-link active show" data-toggle="tab" href="#messages" role="tab" aria-selected="true">Messages</a> </li>
					<li class="nav-item"> <a class="nav-link" data-toggle="tab" href="#tasks" role="tab" aria-selected="false">Tasks</a> </li>
					<li class="nav-item"> <a class="nav-link" data-toggle="tab" href="#settings" role="tab" aria-selected="false">Settings</a> </li>
				</ul>
				<div class="tab-content mt-3">
					<div class="tab-chat tab-pane fade show active" id="messages" role="tabpanel">
						<div class="messages-contact">
							<div class="quick-wrapper">
								<div class="scroll-wrapper quick-scroll scrollbar-outer" style="position: relative;"><div class="quick-scroll scrollbar-outer scroll-content scroll-scrolly_visible" style="height: auto; margin-bottom: 0px; margin-right: 0px; max-height: 510px;">
									<div class="quick-content contact-content">
										<span class="category-title mt-0">Recent</span>
										<div class="contact-list contact-list-recent">
											<div class="user">
												<a href="#">
													<div class="user-image">
														<img src="view/bs42/library/img/jm_denis.jpg" alt="denis">
														<span class="status online"></span>
													</div>
													<div class="user-data">
														<span class="name">Jimmy Denis</span>
														<span class="message">How are you ?</span>
													</div>
												</a>
											</div>
											<div class="user">
												<a href="#">
													<div class="user-image">
														<img src="view/bs42/library/img/chadengle.jpg" alt="chad">
														<span class="status away"></span>
													</div>
													<div class="user-data">
														<span class="name">Chad</span>
														<span class="message">Ok, Thanks !</span>
													</div>
												</a>
											</div>
											<div class="user">
												<a href="#">
													<div class="user-image">
														<img src="view/bs42/library/img/mlane.jpg" alt="john doe">
														<span class="status offline"></span>
													</div>
													<div class="user-data">
														<span class="name">John Doe</span>
														<span class="message">Ready for the meeting today with...</span>
													</div>
												</a>
											</div>
										</div>
										<span class="category-title">Contacts</span>
										<div class="contact-list">
											<div class="user">
												<a href="#">
													<div class="user-image">
														<img src="view/bs42/library/img/jm_denis.jpg" alt="denis">
														<span class="status"></span>
													</div>
													<div class="user-data2">
														<span class="name">Jimmy Denis</span>
													</div>
												</a>
											</div>
											<div class="user">
												<a href="#">
													<div class="user-image">
														<img src="view/bs42/library/img/chadengle.jpg" alt="chad">
														<span class="status away"></span>
													</div>
													<div class="user-data2">
														<span class="name">Chad</span>
													</div>
												</a>
											</div>
											<div class="user">
												<a href="#">
													<div class="user-image">
														<img src="view/bs42/library/img/talha.jpg" alt="talha">
														<span class="status offline"></span>
													</div>
													<div class="user-data2">
														<span class="name">Talha</span>
													</div>
												</a>
											</div>
										</div>
									</div>
								</div><div class="scroll-element scroll-x scroll-scrolly_visible"><div class="scroll-element_outer"><div class="scroll-element_size"></div><div class="scroll-element_track"></div><div class="scroll-bar ui-draggable ui-draggable-handle" style="width: 0px;"></div></div></div><div class="scroll-element scroll-y scroll-scrolly_visible"><div class="scroll-element_outer"><div class="scroll-element_size"></div><div class="scroll-element_track"></div><div class="scroll-bar ui-draggable ui-draggable-handle" style="height: 479px; top: 0px;"></div></div></div></div>
							</div>
						</div>
						<div class="messages-wrapper">
							<div class="messages-title">
								<div class="user">
									<img src="view/bs42/library/img/chadengle.jpg" alt="chad">
									<span class="name">Chad</span>
									<span class="last-active">Active 2h ago</span>
								</div>
								<button class="return">
									<i class="flaticon-left-arrow-3"></i>
								</button>
							</div>
							<div class="scroll-wrapper messages-body messages-scroll scrollbar-outer" style="position: relative;"><div class="messages-body messages-scroll scrollbar-outer scroll-content scroll-scrolly_visible" style="height: auto; margin-bottom: 0px; margin-right: 0px; max-height: 315px;">
								<div class="message-content-wrapper">
									<div class="message message-in">
										<div class="message-pic">
											<img src="view/bs42/library/img/chadengle.jpg" alt="chad">
										</div>
										<div class="message-body">
											<div class="message-content">
												<div class="name">Chad</div>
												<div class="content">Hello, Rian</div>
											</div>
										</div>
									</div>
								</div>
								<div class="message-content-wrapper">
									<div class="message message-out">
										<div class="message-body">
											<div class="message-content">
												<div class="content">
													Hello, Chad
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="message-content-wrapper">
									<div class="message message-in">
										<div class="message-pic">
											<img src="view/bs42/library/img/chadengle.jpg" alt="chad">
										</div>
										<div class="message-body">
											<div class="message-content">
												<div class="name">Chad</div>
												<div class="content">
													When is the deadline of the project we are working on ?
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="message-content-wrapper">
									<div class="message message-out">
										<div class="message-body">
											<div class="message-content">
												<div class="content">
													The deadline is about 2 months away
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="message-content-wrapper">
									<div class="message message-in">
										<div class="message-pic">
											<img src="view/bs42/library/img/chadengle.jpg" alt="chad">
										</div>
										<div class="message-body">
											<div class="message-content">
												<div class="name">Chad</div>
												<div class="content">
													Ok, Thanks !
												</div>
											</div>
										</div>
									</div>
								</div>
							</div><div class="scroll-element scroll-x scroll-scrolly_visible"><div class="scroll-element_outer"><div class="scroll-element_size"></div><div class="scroll-element_track"></div><div class="scroll-bar ui-draggable ui-draggable-handle" style="width: 0px;"></div></div></div><div class="scroll-element scroll-y scroll-scrolly_visible"><div class="scroll-element_outer"><div class="scroll-element_size"></div><div class="scroll-element_track"></div><div class="scroll-bar ui-draggable ui-draggable-handle" style="height: 148px; top: 0px;"></div></div></div></div>
							<div class="messages-form">
								<div class="messages-form-control">
									<input type="text" placeholder="Type here" class="form-control input-pill input-solid message-input">
								</div>
								<div class="messages-form-tool">
									<a href="#" class="attachment">
										<i class="flaticon-file"></i>
									</a>
								</div>
							</div>
						</div>
					</div>
					<div class="tab-pane fade" id="tasks" role="tabpanel">
						<div class="tasks-wrapper">
							<div class="scroll-wrapper tasks-scroll scrollbar-outer" style="position: relative;">
								<div class="tasks-content">
									<span class="category-title mt-0">Today</span>
									<ul class="tasks-list">
										<li>
											<label class="custom-checkbox custom-control checkbox-secondary">
												<input type="checkbox" checked="" class="custom-control-input"><span class="custom-control-label">Planning new project structure</span>
												<span class="task-action">
													<a href="#" class="link text-danger">
														<i class="flaticon-interface-5"></i>
													</a>
												</span>
											</label>
										</li>
										<li>
											<label class="custom-checkbox custom-control checkbox-secondary">
												<input type="checkbox" class="custom-control-input"><span class="custom-control-label">Create the main structure							</span>
												<span class="task-action">
													<a href="#" class="link text-danger">
														<i class="flaticon-interface-5"></i>
													</a>
												</span>
											</label>
										</li>
										<li>
											<label class="custom-checkbox custom-control checkbox-secondary">
												<input type="checkbox" class="custom-control-input"><span class="custom-control-label">Add new Post</span>
												<span class="task-action">
													<a href="#" class="link text-danger">
														<i class="flaticon-interface-5"></i>
													</a>
												</span>
											</label>
										</li>
										<li>
											<label class="custom-checkbox custom-control checkbox-secondary">
												<input type="checkbox" class="custom-control-input"><span class="custom-control-label">Finalise the design proposal</span>
												<span class="task-action">
													<a href="#" class="link text-danger">
														<i class="flaticon-interface-5"></i>
													</a>
												</span>
											</label>
										</li>
									</ul>

									<span class="category-title">Tomorrow</span>
									<ul class="tasks-list">
										<li>
											<label class="custom-checkbox custom-control checkbox-secondary">
												<input type="checkbox" class="custom-control-input"><span class="custom-control-label">Initialize the project							</span>
												<span class="task-action">
													<a href="#" class="link text-danger">
														<i class="flaticon-interface-5"></i>
													</a>
												</span>
											</label>
										</li>
										<li>
											<label class="custom-checkbox custom-control checkbox-secondary">
												<input type="checkbox" class="custom-control-input"><span class="custom-control-label">Create the main structure							</span>
												<span class="task-action">
													<a href="#" class="link text-danger">
														<i class="flaticon-interface-5"></i>
													</a>
												</span>
											</label>
										</li>
										<li>
											<label class="custom-checkbox custom-control checkbox-secondary">
												<input type="checkbox" class="custom-control-input"><span class="custom-control-label">Updates changes to GitHub							</span>
												<span class="task-action">
													<a href="#" class="link text-danger">
														<i class="flaticon-interface-5"></i>
													</a>
												</span>
											</label>
										</li>
										<li>
											<label class="custom-checkbox custom-control checkbox-secondary">
												<input type="checkbox" class="custom-control-input"><span title="This task is too long to be displayed in a normal space!" class="custom-control-label">This task is too long to be displayed in a normal space!				</span>
												<span class="task-action">
													<a href="#" class="link text-danger">
														<i class="flaticon-interface-5"></i>
													</a>
												</span>
											</label>
										</li>
									</ul>

									<div class="mt-3">
										<div class="btn btn-primary btn-rounded btn-sm">
											<span class="btn-label">
												<i class="la la-plus"></i>
											</span>
											Add Task
										</div>
									</div>
								</div>

							</div>

						</div>
					</div>
					<div class="tab-pane fade" id="settings" role="tabpanel">
						<div class="quick-wrapper settings-wrapper">
							<div class="scroll-wrapper quick-scroll scrollbar-outer" style="position: relative;"><div class="quick-scroll scrollbar-outer scroll-content" style="height: 510px; margin-bottom: 0px; margin-right: 0px; max-height: none;">
								<div class="quick-content settings-content">

									<span class="category-title mt-0">General Settings</span>
									<ul class="settings-list">
										<li>
											<span class="item-label">Enable Notifications</span>
											<div class="item-control">
												<input type="checkbox" checked="" data-toggle="toggle" data-onstyle="primary" data-style="btn-round">
											</div>
										</li>
										<li>
											<span class="item-label">Signin with social media</span>
											<div class="item-control">
												<input type="checkbox" data-toggle="toggle" data-onstyle="primary" data-style="btn-round">
											</div>
										</li>
										<li>
											<span class="item-label">Backup storage</span>
											<div class="item-control">
												<input type="checkbox" data-toggle="toggle" data-onstyle="primary" data-style="btn-round">
											</div>
										</li>
										<li>
											<span class="item-label">SMS Alert</span>
											<div class="item-control">
												<input type="checkbox" checked="" data-toggle="toggle" data-onstyle="primary" data-style="btn-round">
											</div>
										</li>
									</ul>

									<span class="category-title mt-0">Notifications</span>
									<ul class="settings-list">
										<li>
											<span class="item-label">Email Notifications</span>
											<div class="item-control">
												<input type="checkbox" checked="" data-toggle="toggle" data-onstyle="primary" data-style="btn-round">
											</div>
										</li>
										<li>
											<span class="item-label">New Comments</span>
											<div class="item-control">
												<input type="checkbox" checked="" data-toggle="toggle" data-onstyle="primary" data-style="btn-round">
											</div>
										</li>
										<li>
											<span class="item-label">Chat Messages</span>
											<div class="item-control">
												<input type="checkbox" checked="" data-toggle="toggle" data-onstyle="primary" data-style="btn-round">
											</div>
										</li>
										<li>
											<span class="item-label">Project Updates</span>
											<div class="item-control">
												<input type="checkbox" data-toggle="toggle" data-onstyle="primary" data-style="btn-round">
											</div>
										</li>
										<li>
											<span class="item-label">New Tasks</span>
											<div class="item-control">
												<input type="checkbox" checked="" data-toggle="toggle" data-onstyle="primary" data-style="btn-round">
											</div>
										</li>
									</ul>
								</div>
							</div><div class="scroll-element scroll-x"><div class="scroll-element_outer"><div class="scroll-element_size"></div><div class="scroll-element_track"></div><div class="scroll-bar ui-draggable ui-draggable-handle"></div></div></div><div class="scroll-element scroll-y"><div class="scroll-element_outer"><div class="scroll-element_size"></div><div class="scroll-element_track"></div><div class="scroll-bar ui-draggable ui-draggable-handle"></div></div></div></div>
						</div>
					</div>
				</div>
			</div>
		</div>

	</div>
</body>
</html>
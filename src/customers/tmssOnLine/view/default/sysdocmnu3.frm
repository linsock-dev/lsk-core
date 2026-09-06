<?php
	$lv_stynavclr = $vew_doc->getTagValue($vew_usr->usratr001,'stynavclr');
	$lv_stybrdclr = $vew_doc->getTagValue($vew_usr->usratr001,'stybrdclr');
	$lv_stymnuclr = $vew_doc->getTagValue($vew_usr->usratr001,'stymnuclr');
	$lv_stybdyclr = $vew_doc->getTagValue($vew_usr->usratr001,'stybdyclr');
	$lv_stymnupif = $vew_doc->getTagValue($vew_usr->usratr001,'stymnupif');
	$lv_stymnupic = $vew_doc->getTagValue($vew_usr->usratr001,'stymnupic');
	/*
	<strpge></strpge>
	<stynavclr></stynavclr>	-- black | dark | blue | purple | light-blue | green | orange | red
	<stybrdclr></stybrdclr>	-- black | dark | blue | purple | light-blue | green | orange | red
	<stymnuclr></stymnuclr>	-- black | dark | blue | purple | light-blue | green | orange | red
	<stybdyclr></stybdyclr> -- bg1 | bg2 | bg3
	<stymnupif></stymnupif> -- on/off
	<stymnupic></stymnupic> -- 1 | 2 | 3 | 4 | 5 | 6 | 7
	*/
?>

<section id="sysdocmnu">

	<div class="wrapper">
		<div class="main-header">
			
			<!-- Logo Header -->
			<div class="logo-header" <?php ($lv_stybrdclr!=''?'data-background-color="'.$lv_stybrdclr.'"':''); ?> >
				<a href="index-2.html" class="big-logo">
					<img src="view/bs4/library/img/logoresponsive.png" alt="logo img" class="logo-img">
				</a>
				<a href="index-2.html" class="logo">
					<span alt="navbar brand" class="navbar-brand">Temasis</span><!--<?php echo $vew_sec->bustxt; ?></span>-->
					<!--<img src="view/bs4/library/img/logoheader.png" alt="navbar brand" class="navbar-brand">-->
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
			<nav class="navbar navbar-header navbar-expand-lg" data-background-color="<?php echo ($lv_stynavclr!=''?$lv_stynavclr:'blue'); ?>" >
				<div class="container-fluid">
					<div class="navbar-minimize">
						<button class="btn btn-minimize btn-rounded">
							<i class="la la-navicon"></i>
						</button>
					</div>
					<div class="collapse" id="search-nav">
						<form class="navbar-left navbar-form nav-search ml-md-3 mr-md-3 p-0">
							<div class="input-group">
								<input type="text" placeholder="Buscar ..." class="form-control">
								<div class="input-group-append">
									<button type="submit" class="btn btn-search">
										<i class="la la-search search-icon"></i>
									</button>
								</div>
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
								<li>
									<div class="dropdown-title">You have 4 new notification</div>
								</li>
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
												<img src="view/bs4/library/img/profile2.jpg" alt="Img Profile">
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
							<a class="dropdown-toggle profile-pic" data-toggle="dropdown" href="#" aria-expanded="false"> <img src="view/bs4/library/img/profile.jpg" alt="image profile" width="36" class="img-circle"></a>
							<ul class="dropdown-menu dropdown-user animated fadeIn">
								<li>
									<div class="user-box">
										<div class="u-img"><img src="view/bs4/library/img/profile.jpg" alt="image profile"></div>
										<div class="u-text">
											<h4><?php echo $vew_usr->usrtxt; ?></h4>
											<p class="text-muted"><?php echo strtolower($vew_usr->adr->adreml); ?></p>
											<a href="#" onclick="tmssLink('?prg=syssecusr&act=25',[{tab_title:'<?php echo $vew_lang->myaccount; ?>'}]);" class="btn btn-rounded btn-danger btn-sm"><?php echo $vew_lang->myaccount; ?></a>
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
									<?php if ( sizeof($vew_bus)>1 ) { ?>
										<li class="dropdown-divider"></li>
										<!--<li class="dropdown-header"><?php echo $vew_sec->bustxt; ?></li>-->
										<li class="dropdown-item" id="btnnavbus"><?php echo $vew_lang->companies; ?></li>
									<?php } ?>
									<div class="dropdown-divider"></div>
									<a class="dropdown-item" href="?prg=syssecusr&act=99"><?php echo $vew_lang->exit; ?></a>									
								</li>
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

		<!-- Sidebar -->
		<div class="sidebar" <?php echo ($lv_stymnuclr!=''?'data-background-color="'.$lv_stymnuclr.'"':''); ?> <?php echo ($lv_stymnupif=='ON' && $lv_stymnupic!=''?'data-image="'.$lv_stymnupic.'"':''); ?> >
			<div class="sidebar-background"></div>
			<div class="sidebar-wrapper scrollbar-inner">
				<div class="sidebar-content">
					<ul class="nav">
<?php
              // recursiva para mostrar men�
              function armar_menu( $lp_mnu, &$vew_lang ) {
								
	$lv_picarr = array( 'ZCU'=>'la la-home',
											'CNS'=>'la la-building',
											'GRL'=>'la la-home',
											'LOG'=>'la la-truck',
											'SLS'=>'la la-money',
											'BUY'=>'la la-shopping-cart',
											'STK'=>'la la-cubes',
											'FIN'=>'la la-balance-scale',
											'TSR'=>'la la-bank',
											'ADM'=>'la la-building',
											'HHR'=>'la la-users',
											'CRM'=>'la la-thumbs-o-up',
											'SYS'=>'la la-cogs');
								
                $lv_buffer='';
                $lv_count=0;
                $lv_lstdiv=false;
                foreach( $lp_mnu as $lv_row ) {
									$lv_buffer_sub='';
									$lv_row['prgpic'] = strtolower($lv_row['prgpic']);
									$lv_pic=($lv_row['prgpic']==''?'':(substr($lv_row['prgpic'],0,6)=='class:'?'<i class="'.substr($lv_row['prgpic'],6,strlen($lv_row['prgpic'])-6).'"></i>':'<img src="/library/images/'.$lv_row['prgpic'].'" class="tmss-icon">'));
									// m�dulo
									if ( $lv_row['prgtypcod']==0 ) {
                    if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub = armar_menu( $lv_row['mnulst'], $vew_lang ); }
                    if ( $lv_buffer_sub!='' ) {
											
											$lv_buffer .= '<li class="nav-item">'.
																		'  <a data-toggle="collapse" href="#'.$lv_row['mdlcod'].'">'.
																		'    <i class="'.$lv_picarr[$lv_row['mdlcod']].'"></i>'.
																		'    <p>'.$vew_lang->get($lv_row['mdltxt']).'</p>'.
																		'    <span class="caret"></span>'.
																		'  </a>'.
																		'  <div class="collapse" id="'.$lv_row['mdlcod'].'">'.
																		'    <ul class="nav nav-collapse">'.
																						$lv_buffer_sub.
																		'    </ul>'.
																		'  </div>'.
																		'</li>';
											
                    }
                    $lv_lstdiv = false;
									// carpeta
									} else if ( $lv_row['prgtypcod']==3 ) {
										if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub=armar_menu( $lv_row['mnulst'], $vew_lang ); }
                    if ( $lv_buffer_sub!='' ) {
											
											$lv_buffer .= '<li>'.
																		'  <a data-toggle="collapse" href="#'.$lv_row['mdlcod'].'_'.$lv_row['prgcod'].'">'.
																		'    <span class="sub-item">'.$lv_pic.' '.$vew_lang->get($lv_row['prgtxt']).'</span>'.
																		'    <span class="caret"></span>'.
																		'  </a>'.
																		'  <div class="collapse" id="'.$lv_row['mdlcod'].'_'.$lv_row['prgcod'].'">'.
																		'    <ul class="nav nav-collapse subnav">'.
																						$lv_buffer_sub.
																		'    </ul>'.
																		'  </div>'.
																		'</li>';
											
                    }
                    $lv_lstdiv = false;
                  // separador
                  } else if ( $lv_row['prgtypcod']==2 ) {
                    if ( $lv_count==0 || ($lv_count+1)==count($lp_mnu) || $lv_lstdiv==true ) {
                      // un divider al principio no se debe mostrar
                      // un divider al final del menu no se debe mostrar
                      // si hay dos o mas divider juntos, se debe mostrar solo uno
                    } else {
                      //$lv_buffer .= '<li class="divider" id="'.$lv_row['prgcod'].'"></li>';
                      $lv_lstdiv = true;
                    }
                  // programa
                  } else if ( $lv_row['prgtypcod']==1 ) {
									
										$lv_buffer .= '<li>'.
																	'  <a href="#" onclick="tmssLink('.chr(39).$lv_row['prgfrm'].(stripos($lv_row['prgfrm'],'?')===false?'?':'&').'prm_mdlcod='.$lv_row['mdlcod'].'&prm_prgcod='.$lv_row['prgcod'].chr(39).', [{tab_title:'.chr(39).$vew_lang->get($lv_row['prgtxt']).chr(39).', url_data: [{vewcod: '.chr(39).$lv_row['vewcod'].chr(39).'}] }] );">'.
																	'    <span class="sub-item">'.$lv_pic.' '.$vew_lang->get($lv_row['prgtxt']).'</span>'.
																	'  </a>'.
																	'</li>';
																	
                    $lv_lstdiv = false;
                  }
                  $lv_count++;
                }
                return $lv_buffer;
              }
              echo armar_menu( $vew_mnu, $vew_lang );
?>
					</ul>
				</div>
			</div>
		</div>
		<!-- End Sidebar -->

		<div class="main-panel">
			<div class="content" style="margin-top: 25px; margin-left: 0px; margin-right: 0px; padding-left: 0px; padding-right: 0px;">
				<!--<div class="container-fluid">-->
			
				<nav class="navbar" style="padding: 15px 0px 0px 15px;">
					<ul class="nav nav-tabs d-print-none" role="tablist" id="pageTab">
						<li class="nav-item" role="presentation"><a href="#" class="nav-link" role="tab" id="btnAddPage" style="padding-bottom: 12px;"><span class="fas fa-plus-circle" style="color:black;"></span></a></li>
					</ul>
				</nav>
				<div class="tab-content" id="pageTabContent"></div>
				<script>
					tmssAddTab( true );
					var lv_redirect = '<?php echo (isset($vew_data['redirect'])?$vew_data['redirect']:''); ?>';
					if (lv_redirect!='' && lv_redirect.substring(0,10)=='/*script*/') { eval( lv_redirect ); }
				</script>
				
<!--				
					<div class="page-header">
						<h4 class="page-title">Dashboard</h4>
						<div class="btn-group btn-group-page-header ml-auto">
							<button type="button" class="btn btn-light btn-round btn-page-header-dropdown dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								<i class="la la-ellipsis-h"></i>
							</button>
							<div class="dropdown-menu">
								<div class="arrow"></div>
								<a class="dropdown-item" href="#">Action</a>
								<a class="dropdown-item" href="#">Another action</a>
								<a class="dropdown-item" href="#">Something else here</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item" href="#">Separated link</a>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-sm-6 col-md-3">
							<div class="card card-stats card-primary card-round">
								<div class="card-body ">
									<div class="row">
										<div class="col-5">
											<div class="icon-big text-center">
												<i class="flaticon-users"></i>
											</div>
										</div>
										<div class="col-7 col-stats">
											<div class="numbers">
												<p class="card-category">Visitors</p>
												<h4 class="card-title">1,294</h4>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-6 col-md-3">
							<div class="card card-stats card-info card-round">
								<div class="card-body">
									<div class="row">
										<div class="col-5">
											<div class="icon-big text-center">
												<i class="flaticon-interface-6"></i>
											</div>
										</div>
										<div class="col-7 col-stats">
											<div class="numbers">
												<p class="card-category">Subscribers</p>
												<h4 class="card-title">1303</h4>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-6 col-md-3">
							<div class="card card-stats card-success card-round">
								<div class="card-body ">
									<div class="row">
										<div class="col-5">
											<div class="icon-big text-center">
												<i class="flaticon-graph"></i>
											</div>
										</div>
										<div class="col-7 col-stats">
											<div class="numbers">
												<p class="card-category">Sales</p>
												<h4 class="card-title">$ 1,345</h4>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-6 col-md-3">
							<div class="card card-stats card-secondary card-round">
								<div class="card-body ">
									<div class="row">
										<div class="col-5">
											<div class="icon-big text-center">
												<i class="flaticon-success"></i>
											</div>
										</div>
										<div class="col-7 col-stats">
											<div class="numbers">
												<p class="card-category">Order</p>
												<h4 class="card-title">576</h4>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-8">
							<div class="card">
								<div class="card-header">
									<div class="card-head-row">
										<div class="card-title">Users Statistics</div>
										<div class="card-tools">
											<a href="#" class="btn btn-info btn-border btn-round btn-sm mr-2">
												<span class="btn-label">
													<i class="la la-pencil"></i>
												</span>
												Export
											</a>
											<a href="#" class="btn btn-info btn-border btn-round btn-sm">
												<span class="btn-label">
													<i class="la la-print"></i>
												</span>
												Print
											</a>
										</div>
									</div>
								</div>
								<div class="card-body">
									<div class="chart-container">
										<canvas id="statisticsChart"></canvas>
									</div>
									<div id="myChartLegend"></div>
								</div>
							</div>
						</div>
						<div class="col-md-4">
							<div class="card">
								<div class="card-header">
									<h4 class="card-title">Users Percentage</h4>
									<p class="card-category">
									Users percentage this month</p>
								</div>
								<div class="card-body">
									<div class="chart-container">
										<canvas id="usersChart"></canvas>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row row-card-no-pd">
						<div class="col-md-12">
							<div class="card">
								<div class="card-header">
									<div class="card-head-row">
										<h4 class="card-title">Users Geolocation</h4>
										<div class="card-tools">
											<a href="#" class="btn btn-primary btn-icon-only"><span class="icon flaticon-down-arrow"></span></a>
											<a href="#" class="btn btn-primary btn-icon-only"><span class="icon flaticon-repeat"></span></a>
											<a href="#" class="btn btn-primary btn-icon-only"><span class="icon flaticon-cross"></span></a>
										</div>
									</div>
									<p class="card-category">
									Map of the distribution of users around the world</p>
								</div>
								<div class="card-body">
									<div class="row">
										<div class="col-md-6">
											<div class="table-responsive table-hover table-sales">
												<table class="table">
													<tbody>
														<tr>
															<td>
																<div class="flag">
																	<img src="view/bs4/library/img/flags/id.png" alt="indonesia">
																</div>
															</td>
															<td>Indonesia</td>
															<td class="text-right">
																2.320
															</td>
															<td class="text-right">
																42.18%
															</td>
														</tr>
														<tr>
															<td>
																<div class="flag">
																	<img src="view/bs4/library/img/flags/us.png" alt="united states">
																</div>
															</td>
															<td>USA</td>
															<td class="text-right">
																240
															</td>
															<td class="text-right">
																4.36%
															</td>
														</tr>
														<tr>
															<td>
																<div class="flag">
																	<img src="view/bs4/library/img/flags/au.png" alt="australia">
																</div>
															</td>
															<td>Australia</td>
															<td class="text-right">
																119
															</td>
															<td class="text-right">
																2.16%
															</td>
														</tr>
														<tr>
															<td>
																<div class="flag">
																	<img src="view/bs4/library/img/flags/ru.png" alt="russia">
																</div>
															</td>
															<td>Russia</td>
															<td class="text-right">
																1.081
															</td>
															<td class="text-right">
																19.65%
															</td>
														</tr>
														<tr>
															<td>
																<div class="flag">
																	<img src="view/bs4/library/img/flags/cn.png" alt="china">
																</div>
															</td>
															<td>China</td>
															<td class="text-right">
																1.100
															</td>
															<td class="text-right">
																20%
															</td>
														</tr>
														<tr>
															<td>
																<div class="flag">
																	<img src="view/bs4/library/img/flags/br.png" alt="brazil">
																</div>
															</td>
															<td>Brasil</td>
															<td class="text-right">
																640
															</td>
															<td class="text-right">
																11.63%
															</td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
										<div class="col-md-6">
											<div class="mapcontainer">
												<div id="map-example" class="vmap"></div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row row-card-no-pd">
						<div class="col-md-4 mt-3 mb-3">
							<div class="card">
								<div class="card-body">
									<p class="fw-mediumbold mt-1">My Balance</p>
									<h4 class="text-primary"><b>$ 3,018</b></h4>
									<a href="#" class="btn btn-primary btn-full text-left mt-3 mb-3"><i class="la la-plus"></i> Add Balance</a>
								</div>
								<div class="card-footer mt-auto">
									<ul class="nav">
										<li class="nav-item"><a class="btn btn-default btn-link" href="#"><i class="la la-history"></i> History</a></li>
										<li class="nav-item ml-auto"><a class="btn btn-default btn-link" href="#"><i class="la la-refresh"></i> Refresh</a></li>
									</ul>
								</div>
							</div>
						</div>
						<div class="col-md-5 mt-3 mb-3">
							<div class="card">
								<div class="card-body">
									<div class="progress-card">
										<div class="d-flex justify-content-between mb-1">
											<span class="text-muted">Profit</span>
											<span class="text-muted fw-bold"> $3K</span>
										</div>
										<div class="progress mb-2" style="height: 7px;">
											<div class="progress-bar bg-success" role="progressbar" style="width: 78%" aria-valuenow="78" aria-valuemin="0" aria-valuemax="100" data-toggle="tooltip" data-placement="top" title="78%"></div>
										</div>
									</div>
									<div class="progress-card">
										<div class="d-flex justify-content-between mb-1">
											<span class="text-muted">Orders</span>
											<span class="text-muted fw-bold"> 576</span>
										</div>
										<div class="progress mb-2" style="height: 7px;">
											<div class="progress-bar bg-info" role="progressbar" style="width: 65%" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" data-toggle="tooltip" data-placement="top" title="65%"></div>
										</div>
									</div>
									<div class="progress-card">
										<div class="d-flex justify-content-between mb-1">
											<span class="text-muted">Tasks Complete</span>
											<span class="text-muted fw-bold"> 70%</span>
										</div>
										<div class="progress mb-2" style="height: 7px;">
											<div class="progress-bar bg-primary" role="progressbar" style="width: 70%" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100" data-toggle="tooltip" data-placement="top" title="70%"></div>
										</div>
									</div>
									<div class="progress-card">
										<div class="d-flex justify-content-between mb-1">
											<span class="text-muted">Open Rate</span>
											<span class="text-muted fw-bold"> 60%</span>
										</div>
										<div class="progress mb-2" style="height: 7px;">
											<div class="progress-bar bg-warning" role="progressbar" style="width: 60%" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" data-toggle="tooltip" data-placement="top" title="60%"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-md-3 mt-3 mb-3">
							<div class="card card-stats">
								<div class="card-body">
									<p class="fw-mediumbold mt-1">Statistic</p>
									<div class="row">
										<div class="col-5">
											<div class="icon-big text-center icon-warning">
												<i class="la la-pie-chart text-warning"></i>
											</div>
										</div>
										<div class="col-7 col-stats">
											<div class="numbers">
												<p class="card-category">Number</p>
												<h4 class="card-title">150GB</h4>
											</div>
										</div>
									</div>
									<hr/>
									<div class="row">
										<div class="col-5">
											<div class="icon-big text-center">
												<i class="la la-heart-o text-primary"></i>
											</div>
										</div>
										<div class="col-7 col-stats">
											<div class="numbers">
												<p class="card-category">Followers</p>
												<h4 class="card-title">+45K</h4>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-5">
							<div class="card card-tasks">
								<div class="card-header ">
									<div class="card-head-row">
										<h4 class="card-title">Tasks</h4>
										<div class="card-tools">
											<ul class="nav nav-pills nav-secondary nav-pills-no-bd nav-sm" id="pills-tab" role="tablist">
												<li class="nav-item">
													<a class="nav-link active" id="pills-home" data-toggle="pill" href="#pills-home" role="tab" aria-selected="true">Today</a>
												</li>
												<li class="nav-item">
													<a class="nav-link" id="pills-profile" data-toggle="pill" href="#pills-profile" role="tab" aria-selected="false">Week</a>
												</li>
												<li class="nav-item">
													<a class="nav-link" id="pills-contact" data-toggle="pill" href="#pills-contact" role="tab" aria-selected="false">Month</a>
												</li>
											</ul>
										</div>
									</div>
								</div>
								<div class="card-body ">
									<div class="table-full-width">
										<table class="table">
											<thead>
												<tr>
													<th>
														<div class="form-check">
															<label class="form-check-label">
																<input class="form-check-input  select-all-checkbox" type="checkbox" data-select="checkbox" data-target=".task-select">
																<span class="form-check-sign"></span>
															</label>
														</div>
													</th>
													<th>Task</th>
													<th class="text-center">Action</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td>
														<div class="form-check">
															<label class="form-check-label">
																<input class="form-check-input task-select" type="checkbox">
																<span class="form-check-sign"></span>
															</label>
														</div>
													</td>
													<td>Planning new project structure</td>
													<td class="td-actions text-center">
														<div class="form-button-action">
															<button type="button" data-toggle="tooltip" title="Edit Task" class="btn btn-link btn-primary">
																<i class="la la-edit"></i>
															</button>
															<button type="button" data-toggle="tooltip" title="Remove" class="btn btn-link btn-danger">
																<i class="la la-times"></i>
															</button>
														</div>
													</td>
												</tr>
												<tr>
													<td>
														<div class="form-check">
															<label class="form-check-label">
																<input class="form-check-input task-select" type="checkbox">
																<span class="form-check-sign"></span>
															</label>
														</div>
													</td>
													<td>Update Fonts</td>
													<td class="td-actions text-center">
														<div class="form-button-action">
															<button type="button" data-toggle="tooltip" title="Edit Task" class="btn btn-link btn-primary">
																<i class="la la-edit"></i>
															</button>
															<button type="button" data-toggle="tooltip" title="Remove" class="btn btn-link btn-danger">
																<i class="la la-times"></i>
															</button>
														</div>
													</td>
												</tr>
												<tr>
													<td>
														<div class="form-check">
															<label class="form-check-label">
																<input class="form-check-input task-select" type="checkbox">
																<span class="form-check-sign"></span>
															</label>
														</div>
													</td>
													<td>Add new Post
													</td>
													<td class="td-actions text-center">
														<div class="form-button-action">
															<button type="button" data-toggle="tooltip" title="Edit Task" class="btn btn-link btn-primary">
																<i class="la la-edit"></i>
															</button>
															<button type="button" data-toggle="tooltip" title="Remove" class="btn btn-link btn-danger">
																<i class="la la-times"></i>
															</button>
														</div>
													</td>
												</tr>
												<tr>
													<td>
														<div class="form-check">
															<label class="form-check-label">
																<input class="form-check-input task-select" type="checkbox">
																<span class="form-check-sign"></span>
															</label>
														</div>
													</td>
													<td>Finalise the design proposal</td>
													<td class="td-actions text-center">
														<div class="form-button-action">
															<button type="button" data-toggle="tooltip" title="Edit Task" class="btn btn-link btn-primary">
																<i class="la la-edit"></i>
															</button>
															<button type="button" data-toggle="tooltip" title="Remove" class="btn btn-link btn-danger">
																<i class="la la-times"></i>
															</button>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
								<div class="card-footer ">
									<div class="stats">
										<i class="now-ui-icons loader_refresh spin"></i> Updated 3 minutes ago
									</div>
								</div>
							</div>
						</div>

						<div class="col-md-3">
							<div class="card">
								<div class="card-header">
									<h4 class="card-title">Task Progress</h4>
								</div>
								<div class="card-body">
									<div id="task-complete" class="chart-circle mt-4 mb-3"></div>
								</div>
								<div class="card-footer">
									<div class="legend"><i class="la la-circle text-primary"></i> Completed</div>
								</div>
							</div>
						</div>

						<div class="col-md-4">
							<div class="card card-round">
								<div class="card-body">
									<div class="card-title">Suggested People</div>
									<div class="card-list">
										<div class="item-list">
											<img src="view/bs4/library/img/jm_denis.jpg" alt="denis" class="small-pic">
											<div class="info-user ml-3">
												<div class="username">Jimmy Denis</div>
												<div class="status">Graphic Designer</div>
											</div>
											<a href="#" class="btn btn-add">
												<i class="la la-plus"></i>
											</a>
										</div>
										<div class="item-list">
											<img src="view/bs4/library/img/chadengle.jpg" alt="chad" class="small-pic">
											<div class="info-user ml-3">
												<div class="username">Chad</div>
												<div class="status">CEO Zeleaf</div>
											</div>
											<a href="#" class="btn btn-add">
												<i class="la la-plus"></i>
											</a>
										</div>
										<div class="item-list">
											<img src="view/bs4/library/img/mlane.jpg" alt="john doe" class="small-pic">
											<div class="info-user ml-3">
												<div class="username">Jhon doe</div>
												<div class="status">Content Writer</div>
											</div>
											<a href="#" class="btn btn-add">
												<i class="la la-plus"></i>
											</a>
										</div>
										<div class="item-list">
											<img src="view/bs4/library/img/talha.jpg" alt="talha" class="small-pic">
											<div class="info-user ml-3">
												<div class="username">Talha</div>
												<div class="status">Front End Designer</div>
											</div>
											<a href="#" class="btn btn-add">
												<i class="la la-plus"></i>
											</a>
										</div>
										<div class="item-list">
											<img src="view/bs4/library/img/sauro.jpg" alt="sauro" class="small-pic">
											<div class="info-user ml-3">
												<div class="username">Sauro</div>
												<div class="status">Back End Developer</div>
											</div>
											<a href="#" class="btn btn-add">
												<i class="la la-plus"></i>
											</a>
										</div>
										<div class="item-list">
											<img src="view/bs4/library/img/arashmil.jpg" alt="arash mil" class="small-pic">
											<div class="info-user ml-3">
												<div class="username">Arash Mil</div>
												<div class="status">Content Writer</div>
											</div>
											<a href="#" class="btn btn-add">
												<i class="la la-plus"></i>
											</a>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					-->
				<!--</div>-->
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
								<div class="quick-scroll scrollbar-outer">
									<div class="quick-content contact-content">
										<span class="category-title mt-0">Recent</span>
										<div class="contact-list contact-list-recent">
											<div class="user">
												<a href="#">
													<div class="user-image">
														<img src="view/bs4/library/img/jm_denis.jpg" alt="denis">
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
														<img src="view/bs4/library/img/chadengle.jpg" alt="chad">
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
														<img src="view/bs4/library/img/mlane.jpg" alt="john doe">
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
														<img src="view/bs4/library/img/jm_denis.jpg" alt="denis">
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
														<img src="view/bs4/library/img/chadengle.jpg" alt="chad">
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
														<img src="view/bs4/library/img/talha.jpg" alt="talha">
														<span class="status offline"></span>
													</div>
													<div class="user-data2">
														<span class="name">Talha</span>
													</div>
												</a>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="messages-wrapper">
							<div class="messages-title">
								<div class="user">
									<img src="view/bs4/library/img/chadengle.jpg" alt="chad">
									<span class="name">Chad</span>
									<span class="last-active">Active 2h ago</span>
								</div>
								<button class="return">
									<i class="flaticon-left-arrow-3"></i>
								</button>
							</div>
							<div class="messages-body messages-scroll scrollbar-outer">
								<div class="message-content-wrapper">
									<div class="message message-in">
										<div class="message-pic">
											<img src="view/bs4/library/img/chadengle.jpg" alt="chad">
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
											<img src="view/bs4/library/img/chadengle.jpg" alt="chad">
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
											<img src="view/bs4/library/img/chadengle.jpg" alt="chad">
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
							</div>
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
							<div class="tasks-scroll scrollbar-outer">
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
							<div class="quick-scroll scrollbar-outer">
								<div class="quick-content settings-content">

									<span class="category-title mt-0">General Settings</span>
									<ul class="settings-list">
										<li>
											<span class="item-label">Enable Notifications</span>
											<div class="item-control">
												<input type="checkbox" checked data-toggle="toggle" data-onstyle="primary" data-style="btn-round">
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
												<input type="checkbox" checked data-toggle="toggle" data-onstyle="primary" data-style="btn-round">
											</div>
										</li>
									</ul>

									<span class="category-title mt-0">Notifications</span>
									<ul class="settings-list">
										<li>
											<span class="item-label">Email Notifications</span>
											<div class="item-control">
												<input type="checkbox" checked data-toggle="toggle" data-onstyle="primary" data-style="btn-round">
											</div>
										</li>
										<li>
											<span class="item-label">New Comments</span>
											<div class="item-control">
												<input type="checkbox" checked data-toggle="toggle" data-onstyle="primary" data-style="btn-round">
											</div>
										</li>
										<li>
											<span class="item-label">Chat Messages</span>
											<div class="item-control">
												<input type="checkbox" checked data-toggle="toggle" data-onstyle="primary" data-style="btn-round">
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
												<input type="checkbox" checked data-toggle="toggle" data-onstyle="primary" data-style="btn-round">
											</div>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>


<!--

  <div class="container-fluid">
    <nav class="navbar navbar-default navbar-fixed-top tmss-shadow">
      <div class="containter-fluid">

        <div class="navbar-header">
          <a class="navbar-brand" href="#" data-toggle="offcanvas" data-target="#tmss-sysmnu-left" data-canvas="body"><span class="fas fa-bars"></span></a>
          <a class="navbar-brand visible-xs" href="#"><?php echo $vew_sec->bustxt; ?></a>
					
					<span class="navbar-brand pull-right tmssBrandMnuUsr visible-xs">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><span class="far fa-user-circle"></span><span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li class="dropdown-header"><?php echo $vew_sec->usrcod; ?></li>
							<li><a href="#" onclick="tmssLink('?prg=syssecusr&act=25',[{tab_title:'<?php echo $vew_lang->myaccount; ?>'}]);" class="tmssLink"><span class="fas fa-user"></span> <?php echo $vew_lang->myaccount; ?></a></li>
							<?php if ( sizeof($vew_bus)>1 ) { ?>
								<li class="divider"></li>
								<li class="dropdown-header"><?php echo $vew_sec->bustxt; ?></li>
								<li><a href="#" id="btnnavbus"><span class="fas fa-exchange-alt"></span> <?php echo $vew_lang->companies; ?></a></li>
							<?php } ?>
							<li class="divider"></li>
							<li><a href="?prg=syssecusr&act=99"><span class="fas fa-power-off"></span> <?php echo $vew_lang->exit; ?></a></li>
						</ul>
					</span>

					<!--
					<span id="tmssRemindersNavLi" class="tmssNavNtfBtn navbar-brand pull-right tmssBrandMnuUsr visible-xs">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><span class="far fa-bell"></span><span class="badge text-danger" id="tmssRemindersBadQty"></span></a>
						<ul class="dropdown-menu" id="tmssRemindersNavLiUl"></ul>
					</span>
					-- >
					
        </div>

        <!-- left side menu -- >        
        <nav id="tmss-sysmnu-left" class="navmenu navmenu-default navmenu-fixed-left offcanvas" role="navigation" style="width: 270px !important; background-color: #ffffff !important;">
					<div class="panel panel-default tmss-noborder">
						<div class="panel-heading">
							<h3 class="panel-title"><?php echo $vew_sec->usrcod; ?></h3>
							<?php echo $vew_sec->buscod; ?>
						</div>
						<div class="panel-body">
							<div class="list-group">
														
								<!-- favoritos -- >
								<a href="#" class="list-group-item active" onclick="$('#tmss-menu-favorites').toggle(300);"><h5 class="list-group-item-heading"><span class="fas fa-star"></span> Favoritos</h5></a>
								<div id="tmss-menu-favorites">
								</div>
								-->
								
								<!-- reciente -- >
								<a href="#" class="list-group-item active" onclick="$('#tmss-menu-recenzabalasa.com.art').toggle(300);"><h5 class="list-group-item-heading"><span class="fas fa-history"></span> Recientes</h5></a>
								<div id="tmss-menu-recent">
								</div>
								-->
								
								<!--
								<a href="#" onclick="$('#tmss-sysmnu-left').offcanvas('hide'); document.location.href='?prg=syssecusr&act=99';" class="list-group-item tmss-noborder"><span class="fas fa-power-off"></span> <?php echo $vew_lang->exit; ?></a>
								-- >
								
							</div> <!-- /list-group -- >
						</div> <!-- /panel-body -- >
					</div> <!-- /panel -- >
        </nav>

          <ul class="nav navbar-nav navbar-right">
						
						<li id="tmssMessagesNavLi" class="tmssNavNtfBtn">
							<a href="#" onclick="javascript:toggleFullScreen()"><i class="full-screen fas fa-expand"></i></a>
						</li>
						
						<li id="tmssRemindersNavLi" class="tmssNavNtfBtn">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><span class="far fa-bell"></span><span class="badge text-danger" id="tmssRemindersBadQty"></span></a>
              <ul class="dropdown-menu" id="tmssRemindersNavLiUl"></ul>
						</li>
						
						<!--
						<li id="tmssMessagesNavLi" class="tmssNavNtfBtn">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><span class="far fa-envelope"></span><span class="badge" id="tmssMessagesBadQty"></span></a>
              <ul class="dropdown-menu" id="tmssMessagesNavLiUl"></ul>
						</li>
						-- >
						
            <li class="tmssNavNtfBtn">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><span class="far fa-user-circle"></span><span class="caret"></span></a>
              <ul class="dropdown-menu">
                <li class="dropdown-header"><?php echo $vew_sec->usrcod; ?></li>
                <li><a href="#" onclick="tmssLink('?prg=syssecusr&act=25',[{tab_title:'<?php echo $vew_lang->myaccount; ?>'}]);" class="tmssLink"><span class="fas fa-user"></span> <?php echo $vew_lang->myaccount; ?></a></li>
								<?php if ( sizeof($vew_bus)>1 ) { ?>
									<li class="divider"></li>
									<li class="dropdown-header"><?php echo $vew_sec->bustxt; ?></li>
									<li><a href="#" id="btnnavbus"><span class="fas fa-exchange-alt"></span> <?php echo $vew_lang->companies; ?></a></li>
								<?php } ?>
                <li class="divider"></li>
                <li><a href="?prg=syssecusr&act=99"><span class="fas fa-power-off"></span> <?php echo $vew_lang->exit; ?></a></li>
              </ul>
            </li>

					</ul>
          
        </div> <!-- menu -- >
      </div> <!-- containter-fluid -- >
    </nav>
  </div> <!-- /.container -- >
  <script>	
		$("#sysdocmnu #btnnavbus, #sysdocmnu #btnmblbus").on("click",function(e){
			if ( $(this).prop("id")=="btnmblbus" ) {
				$("#tmss-sysmnu-left").offcanvas("hide");
			}
			$.ajax({url: "?prg=syssecusr&act=25"}).done(function(msg) {
				if (msg.substring(0,10)=="/*script*/" ) { eval(msg); } else { 
					document.location.href = "?prg=syssecusr&act=97";
				}
			});
		});
		
		function tmssReminderShow( lp_docrmdcod ) {
			$.ajax({url: "?prg=grldocrmd&act="+(lp_docrmdcod==0?"01":(lp_docrmdcod==-1?"19":"03"))+"&prm_docrmdcod="+lp_docrmdcod+"&prm_curdte="+moment().format("DD/MM/YYYY")}).done(function(data) {
				if (data.substring(0,10)=="/*script*/" ) { eval(data); } else { 
					BootstrapDialog.show({
						title: "<?php echo $vew_lang->reminder; ?> - "+moment().format("DD/MM/YYYY"), 
						message: $(data), 
						type: BootstrapDialog.TYPE_PRIMARY
						//size: BootstrapDialog.SIZE_WIDE
					});
				}
			});
		}
		
		function tmssRemindersRefresh() {
			var lv_pst = [{name:"start", value:moment().format("YYYY-MM-DD")},{name:"end", value:moment().format("YYYY-MM-DD")}];
			$.ajax({url: "?prg=grldocrmd&act=18", method: "POST", data: lv_pst}).done(function(data) {
				var lv_buffer = "";
				if (data.substring(0,10)=="/*script*/") { eval(data); return false; } else {
					var lo_data = JSON.parse(data);
					var lv_list = "";
					var lv_list_qty = 0;
					for( var i=0; i<lo_data.length; i++ ) {
						lv_list+= "<li><a href='#' onclick='tmssReminderShow("+lo_data[i]["docrmdcod"]+");' "+(lo_data[i]["docrmdlogcod"]==null?"":"style='color: #969696 !important; text-decoration: line-through !important;'")+"><b>"+lo_data[i]["docrmdstrtme"]+"</b>&nbsp;<small>"+lo_data[i]["docrmdtxt"]+"</small></a></li>";
						lv_list_qty += (lo_data[i]["docrmdlogcod"]==null?1:0);
					}					
					if( lv_list_qty>0 ){ $("#tmssRemindersBadQty").removeClass("hidden"); } else { $("#tmssRemindersBadQty").addClass("hidden"); }
					$("#tmssRemindersBadQty").text( lo_data.length );
					if( lo_data.length>0 ){ lv_buffer += "<li class='dropdown-header'><?php echo $vew_lang->today; ?></li>"; }
					lv_buffer += lv_list;
					if(lo_data.length>0){ lv_buffer += "<li class='divider'></li>"; }
				}
				lv_buffer += "<li><a href='#' onclick='tmssReminderShow(0);'><span class='far fa-bell'></span>&nbsp;&nbsp;<em><small>Nuevo recordatorio</small></em></a></li>";
				lv_buffer += "<li><a href='#' onclick='tmssReminderShow(-1);'><span class='far fa-calendar'></span>&nbsp;&nbsp;<em><small>Ver todos</small></em></a></li>";
				$("#tmssRemindersNavLiUl").html( lv_buffer ); 
			});
			$.each(BootstrapDialog.dialogs, function(id, dialog){
				var lo_cal = $(dialog.getModalBody()).find("#tmssRemindersCalendar");
				try { $(lo_cal).fullCalendar( "refetchEvents" ); } catch(e) {}
			});
		}

		/*
		function tmssMessageRefresh() {
			var lv_pst = [{name:"start", value:moment().format("YYYY-MM-DD")},{name:"end", value:moment().format("YYYY-MM-DD")}];
			$.ajax({url: "?prg=grldocmsg&act=18", method: "POST", data: lv_pst}).done(function(data) {
				var lv_buffer = "";
				if (data.substring(0,10)=="/ * script * /") { eval(data); return false; } else {
					var lo_data = JSON.parse(data);
					var lv_list = "";
					var lv_list_qty = 0;
					for( var i=0; i<lo_data.length; i++ ) {
						lv_list+= "<li><a href='#' onclick='tmssMessageShow("+lo_data[i]["docmsgcod"]+");' "+(lo_data[i]["docrmdlogcod"]==null?"":"style='color: #969696 !important; text-decoration: line-through !important;'")+"><b>"+lo_data[i]["docrmdstrtme"]+"</b>&nbsp;<small>"+lo_data[i]["docrmdtxt"]+"</small></a></li>";
						lv_list_qty += (lo_data[i]["docrmdlogcod"]==null?1:0);
					}					
					if( lv_list_qty>0 ){ $("#tmssRemindersBadQty").removeClass("hidden"); } else { $("#tmssRemindersBadQty").addClass("hidden"); }
					$("#tmssMessageBadQty").text( lo_data.length );
					//if( lo_data.length>0 ){ lv_buffer += "<li class='dropdown-header'><?php echo $vew_lang->today; ?></li>"; }
					lv_buffer += lv_list;
					if(lo_data.length>0){ lv_buffer += "<li class='divider'></li>"; }
				}
				lv_buffer += "<li><a href='#' onclick='tmssMessageShow(0);'><span class='far fa-envelope'></span>&nbsp;&nbsp;<em><small>Nuevo mensaje</small></em></a></li>";
				lv_buffer += "<li><a href='#' onclick='tmssMessageShow(-1);'><span class='fas fa-inbox'></span>&nbsp;&nbsp;<em><small>Ver todos</small></em></a></li>";
				$("#tmssMessagesNavLiUl").html( lv_buffer ); 
			});
			/ *
			$.each(BootstrapDialog.dialogs, function(id, dialog){
				var lo_cal = $(dialog.getModalBody()).find("#tmssMessagesCalendar");
				try { $(lo_cal).fullCalendar( "refetchEvents" ); } catch(e) {}
			});
			* /
		}
		*/
		$( document ).ready(function() {
			tmssRemindersRefresh();
			/*tmssMessageRefresh();*/
		});
	</script>
	<script>
		/*
		function notifyMe() {
			debugger;
			// Let's check if the browser supports notifications
			if (!("Notification" in window)) {
				alert("This browser does not support desktop notification");
			}
			
			// Let's check whether notification permissions have already been granted
			else if (Notification.permission === "granted") {
				// If it's okay let's create a notification
				var notification = new Notification("Hi there!");
			}

			// Otherwise, we need to ask the user for permission
			else if (Notification.permission !== "denied") {
				Notification.requestPermission(function (permission) {
					// If the user accepts, let's create a notification
					if (permission === "granted") {
						var notification = new Notification("Hi there!");
					}
				});
			}

			// At last, if the user has denied notifications, and you 
			// want to be respectful there is no need to bother them any more.
		}
		
		function spawnNotification(theBody,theIcon,theTitle) {
			var options = {
				body: theBody,
				icon: theIcon
			}
			var n = new Notification(theTitle,options);
		}
		*/
	</script>
	
	-->
	<script>
		$("#sysdocmnu #btnnavbus, #sysdocmnu #btnmblbus").on("click",function(e){ e.preventDefault();
			tmssCallProcess("?prg=syssecusr&act=25",[],function(data) {
				document.location.href = "?prg=syssecusr&act=97";
			});
		});
	</script>
</section>
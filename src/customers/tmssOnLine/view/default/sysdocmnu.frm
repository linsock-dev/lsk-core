<? $lv_bseurl = (isset($vew_sec) && $vew_sec->bseurl ? $vew_sec->bseurl : ''); ?>
<section id="sysdocmnu">

  <div class="container-fluid">
    <nav class="navbar navbar-default navbar-fixed-top tmss-shadow">
      <div class="containter-fluid">

        <div class="navbar-header">
          <a class="navbar-brand" href="#" data-toggle="offcanvas" data-target="#tmss-sysmnu-left" data-canvas="body"><span class="fas fa-bars"></span></a>
          <a class="navbar-brand visible-xs" href="#"><?= $vew_sec->bustxt; ?></a>
					
					<span class="navbar-brand pull-right tmssBrandMnuUsr visible-xs">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><span class="far fa-user-circle"></span><span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li class="dropdown-header"><?= $vew_sec->usrcod; ?></li>
							<li><a href="#" onclick="tmssLink('?prg=syssecusr&act=25',[{tab_title:'<?= $vew_lang->myaccount; ?>'}]);" class="tmssLink"><span class="fas fa-user"></span> <?= $vew_lang->myaccount; ?></a></li>
							<?php if ( sizeof($vew_bus)>1 ) { ?>
								<li class="divider"></li>
								<li class="dropdown-header"><?= $vew_sec->bustxt; ?></li>
								<li><a href="#" id="btnnavbus"><span class="fas fa-exchange-alt"></span> <?= $vew_lang->companies; ?></a></li>
							<?php } ?>
							<li class="divider"></li>
							<li><a href="?prg=syssecusr&act=99<?=$lv_bseurl?'&bseurl='.$lv_bseurl:'';?>" id="btnend"><span class="fas fa-power-off"></span> <?= $vew_lang->exit; ?></a></li>
						</ul>
					</span>

					<!--
					<span id="tmssRemindersNavLi" class="tmssNavNtfBtn navbar-brand pull-right tmssBrandMnuUsr visible-xs">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><span class="far fa-bell"></span><span class="badge text-danger" id="tmssRemindersBadQty"></span></a>
						<ul class="dropdown-menu" id="tmssRemindersNavLiUl"></ul>
					</span>
					-->
					
        </div>

        <!-- left side menu -->        
        <nav id="tmss-sysmnu-left" class="navmenu navmenu-default navmenu-fixed-left offcanvas" role="navigation" style="width: 270px !important; background-color: #ffffff !important;">
					<div class="panel panel-default tmss-noborder">
						<div class="panel-heading">
							<h3 class="panel-title"><?= $vew_sec->usrcod; ?></h3>
							<?= $vew_sec->buscod; ?>
						</div>
						<div class="panel-body">
							<div class="list-group">
							
								<!-- modulos -->
								<a href="#" class="list-group-item active" onclick="$('#tmss-menu-modules').toggle(300);"><h5 class="list-group-item-heading"><span class="fas fa-home"></span> M&oacute;dulos</h5></a>
								<div id="tmss-menu-modules">
								<?php
                $lv_buffer='';
                foreach($vew_mnu as $lv_row) {
                  if ( $lv_row['prgtypcod']==0 ) {
                      $lv_row['mdlpic'] = strtolower($lv_row['mdlpic']);
                      $lv_buffer .= '<a href="#" class="list-group-item" onclick="$('.chr(39).'#tmss-sysmnu-left'.chr(39).').offcanvas('.chr(39).'hide'.chr(39).'); tmssLink('.chr(39).'?prg=grlstr&act=18&prm_mdlcod='.$lv_row['mdlcod'].chr(39).', [{tab_title:'.chr(39).$vew_lang->get($lv_row['mdltxt']).chr(39).'}] );">'.(substr($lv_row['mdlpic'],0,6)=='class:'?'<span class="'.trim(substr($lv_row['mdlpic'],6)).'"></span>':'').' '.$vew_lang->get($lv_row['mdltxt']).'</a>';
                    }
                }
                echo $lv_buffer;
								?>							
								</div>
								
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
								<a href="#" onclick="$('#tmss-sysmnu-left').offcanvas('hide'); document.location.href='?prg=syssecusr&act=99';" class="list-group-item tmss-noborder"><span class="fas fa-power-off"></span> <?= $vew_lang->exit; ?></a>
								-->
								
							</div> <!-- /list-group -->
						</div> <!-- /panel-body -->
					</div> <!-- /panel -->
        </nav>

        <div class="collapse navbar-collapse" id="tmss-sysmnu" role="navigation" style="padding-right: 15px; padding-left: 16px;">
          <ul class="nav navbar-nav">
            <?php
              // recursiva para mostrar menú
              function armar_menu( $lp_mnu, &$vew_lang, &$vew_sec ) {
                $lv_buffer='';
                $lv_count=0;
                $lv_lstdiv=false;
                foreach( $lp_mnu as $lv_row ) {
									$lv_buffer_sub='';
									$lv_row['prgpic'] = strtolower($lv_row['prgpic']);
									$lv_pic=($lv_row['prgpic']==''?'':(substr($lv_row['prgpic'],0,6)=='class:'?'<span class="'.substr($lv_row['prgpic'],6,strlen($lv_row['prgpic'])-6).'"></span>':'<img src="/library/images/'.$lv_row['prgpic'].'" class="tmss-icon">'));
									// módulo
									if ( $lv_row['prgtypcod']==0 ) {
                    if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub = armar_menu( $lv_row['mnulst'], $vew_lang, $vew_sec ); }
                    if ( $lv_buffer_sub!='' ) {
											$lv_click = '';
											//if($lv_row['mdlcod']=='SLS' && $vew_sec->hasPermission('SLS','DSH','**')){ $lv_click='tmssLink('.chr(39).'?prg=slsdsh&act=dsh'.chr(39).', [{tab_title:'.chr(39).$vew_lang->get($lv_row['mdltxt']).chr(39).'}] );'; }
											//if($lv_row['mdlcod']=='CRM' && $vew_sec->hasPermission('CRM','DSH','**')){ $lv_click='tmssLink('.chr(39).'?prg=crmcnt&act=dsh'.chr(39).', [{tab_title:'.chr(39).$vew_lang->get($lv_row['mdltxt']).chr(39).'}] );'; }
											//if($lv_row['mdlcod']=='HHR' && $vew_sec->hasPermission('HHR','DSH','**')){ $lv_click='tmssLink('.chr(39).'?prg=hhremp&act=dshemp'.chr(39).', [{tab_title:'.chr(39).$vew_lang->get($lv_row['mdltxt']).chr(39).'}] );'; }
                      $lv_buffer .= '<li class="dropdown" id="'.$lv_row['prgcod'].'">'.
																			'<a href="#" onclick="'.$lv_click.'">'.$lv_pic.' '.$vew_lang->get($lv_row['mdltxt']).'<span class="caret"></span></a>'.
																			'<ul class="dropdown-menu tmss-zindex-1030">';
                      $lv_buffer .= $lv_buffer_sub;
                      $lv_buffer .= '</ul></li>';
                    }
                    $lv_lstdiv = false;
									// carpeta
									} else if ( $lv_row['prgtypcod']==3 ) {
										if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub=armar_menu( $lv_row['mnulst'], $vew_lang, $vew_sec ); }
                    if ( $lv_buffer_sub!='' ) {
                      $lv_buffer .= '<li class="dropdown" id="'.$lv_row['prgcod'].'"><a href="#">'.$lv_pic.' '.$vew_lang->get($lv_row['prgtxt']).'<span class="caret"></span></a><ul class="dropdown-menu">';
                      $lv_buffer .= $lv_buffer_sub;
                      $lv_buffer .= '</ul></li>';
                    }
                    $lv_lstdiv = false;
                  // separador
                  } else if ( $lv_row['prgtypcod']==2 ) {
                    if ( $lv_count==0 || ($lv_count+1)==count($lp_mnu) || $lv_lstdiv==true ) {
                      // un divider al principio no se debe mostrar
                      // un divider al final del menu no se debe mostrar
                      // si hay dos o mas divider juntos, se debe mostrar solo uno
                    } else {
                      $lv_buffer .= '<li class="divider" id="'.$lv_row['prgcod'].'"></li>';
                      $lv_lstdiv = true;
                    }
                  // programa
                  } else if ( $lv_row['prgtypcod']==1 ) {
										$lv_buffer .= '<li><a href="#" onclick="tmssLink('.chr(39).$lv_row['prgfrm'].(stripos($lv_row['prgfrm'],'?')===false?'?':'&').'prm_mdlcod='.$lv_row['mdlcod'].'&prm_prgcod='.$lv_row['prgcod'].chr(39).', [{tab_title:'.chr(39).$vew_lang->get($lv_row['prgtxt']).chr(39).', url_data: [{vewcod: '.chr(39).$lv_row['vewcod'].chr(39).'}] }] );">'.$lv_pic.' '.$vew_lang->get($lv_row['prgtxt']).'</a></li>';
                    $lv_lstdiv = false;
                  }
                  $lv_count++;
                }
                return $lv_buffer;
              }
              echo armar_menu( $vew_mnu, $vew_lang, $vew_sec );
            ?>
          </ul>
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
						-->
						
            <li class="tmssNavNtfBtn">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><span class="far fa-user-circle"></span><span class="caret"></span></a>
              <ul class="dropdown-menu">
                <li class="dropdown-header"><?= $vew_sec->usrcod; ?></li>
                <li><a href="#" onclick="tmssLink('?prg=syssecusr&act=25',[{tab_title:'<?= $vew_lang->myaccount; ?>'}]);" class="tmssLink"><span class="fas fa-user"></span> <?= $vew_lang->myaccount; ?></a></li>
								<?php if ( sizeof($vew_bus)>1 ) { ?>
									<li class="divider"></li>
									<li class="dropdown-header"><?= $vew_sec->bustxt; ?></li>
									<li><a href="#" id="btnnavbus"><span class="fas fa-exchange-alt"></span> <?= $vew_lang->companies; ?></a></li>
								<?php } ?>
                <li class="divider"></li>
                <li><a href="?prg=syssecusr&act=99<?=$lv_bseurl?'&bseurl='.$lv_bseurl:'';?>" id="btnend"><span class="fas fa-power-off"></span> <?= $vew_lang->exit; ?></a></li>
              </ul>
            </li>

					</ul>
          
        </div> <!-- menu -->
      </div> <!-- containter-fluid -->
    </nav>
  </div> <!-- /.container -->
  <script>
    $("#sysdocmnu #btnend").on("click",function(e){
			var lv_svnme = location.host.split(".").map((e) => e.charAt(0).toUpperCase() + e.slice(1)).join(".");
      localStorage.removeItem(lv_svnme+".Usrtkn");
      localStorage.removeItem(lv_svnme+".Usrcod");
    });
  </script>
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
						title: "<?= $vew_lang->reminder; ?> - "+moment().format("DD/MM/YYYY"), 
						message: $(data), 
						type: BootstrapDialog.TYPE_PRIMARY
						//size: BootstrapDialog.SIZE_WIDE
					});
				}
			});
		}
		
		function tmssRemindersRefresh() {
			var lv_pst = [{name:"start", value:moment().format("YYYY-MM-DD")},{name:"end", value:moment().format("YYYY-MM-DD")}];
      tmssCallProcess("?prg=grldocrmd&act=18", lv_pst, function(data){

				var lv_buffer = "";
				//if (data.substring(0,10)=="/*script*/") { eval(data); return false; } else {
        var lo_data = data;
        var lv_list = "";
        var lv_list_qty = 0;
        for( var i=0; i<lo_data.length; i++ ) {
          lv_list+= "<li><a href='#' onclick='tmssReminderShow("+lo_data[i]["docrmdcod"]+");' "+(lo_data[i]["docrmdlogcod"]==null?"":"style='color: #969696 !important; text-decoration: line-through !important;'")+"><b>"+lo_data[i]["docrmdstrtme"]+"</b>&nbsp;<small>"+lo_data[i]["docrmdtxt"]+"</small></a></li>";
          lv_list_qty += (lo_data[i]["docrmdlogcod"]==null?1:0);
        }					
        if( lv_list_qty>0 ){ $("#tmssRemindersBadQty").removeClass("hidden"); } else { $("#tmssRemindersBadQty").addClass("hidden"); }
        $("#tmssRemindersBadQty").text( lo_data.length );
        if( lo_data.length>0 ){ lv_buffer += "<li class='dropdown-header'><?= $vew_lang->today; ?></li>"; }
        lv_buffer += lv_list;
        if(lo_data.length>0){ lv_buffer += "<li class='divider'></li>"; }
				//}
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
					//if( lo_data.length>0 ){ lv_buffer += "<li class='dropdown-header'><?= $vew_lang->today; ?></li>"; }
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
</section>
<div role="tabpanel" class="tmssPageTop">
	<ul class="nav nav-tabs hidden-print" role="tablist" id="pageTab">
		<li role="presentation" class="tmss-btn-add"><a href="#" id="btnAddPage"><span class="fas fa-plus-circle"></span></a></li>
	</ul>
	<div class="tab-content" id="pageTabContent"></div>
</div>
<script>
  tmssAddTab( true );
	var lv_redirect = '<?= (isset($vew_data['redirect'])?$vew_data['redirect']:''); ?>';
	if (lv_redirect!='' && lv_redirect.substring(0,10)=='/*script*/') { eval( lv_redirect ); }
</script>
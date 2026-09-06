<?php		
	// url del formulario 
  $lv_lnk = '?prg=edupln';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = $vew_data->plnid; 

	// titulo 
	$lv_title = $vew_lang->planning;
	
	// módulo y programa 
	$lv_mdlcod = 'EDU';
	$lv_prgcod = 'PLN';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<style>
  	/* Estilos de CALENDARIO */
  .tmss-cal-vewdrpdwn {display: none; position: absolute; border-radius: 15px;background-color: #177dff; z-index: 10;}
  .tmss-cal-item {color: #FFFFFF; padding: 12px 16px; display: block; margin:0px;}
  .tmss-cal-item:hover {cursor:pointer; background-color: #1876e6;}
  .tmss-cal-btneduplnpre {border-radius: 15px; outline:none !important ;height: 40px; background-color: #177dff !important ;border-color: #177dff;}
  .tmss-cal-btneduplnpre:active, .tmss-cal-btneduplnpre:hover, .tmss-cal-btneduplnpre:focus {background-color: #1876e6 !important; box-shadow: none !important;}
  .tmss-cal-ordday:hover {border-top-left-radius: inherit; border-top-right-radius: inherit;}
  .tmss-cal-ordagenda:hover {border-bottom-left-radius: inherit; border-bottom-right-radius: inherit;}
  .tmss-cal-btneduplncal{color: #177dff; border: none; border-radius: 15px;}
  @media (min-width: 960px) { .tmss-edupln-pre { width: 25% !important;} }
  @media (max-width: 960px) { .tmss-hide-on-mobile { visibility:hidden; width: 0px; margin-right:0px; padding-left: 0px; padding-right: 0px; } }
  
  
  	/* Scrollbar */
  .tmss-table-body::-webkit-scrollbar { width: 7px; border-radius: 10px; background-color: #F5F5F5;} 
  .tmss-table-body::-webkit-scrollbar-thumb {border-radius: 10px; -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.1); background-color: #4285F4; } 
  
    /* Barra de búsqueda */
  .tmss-cal-frmfnd {display:inline; font-size:15px; border-radius:15px; padding:0.3em;}
  .tmss-cal-frmfnd:focus {background-color: white;}
  .tmss-cal-fndtxt {transition:all 0.2s ease-out; width:1px; border-radius:0; box-shadow:none; outline: none; padding:0; margin:0; border:0; background-color: transparent; opacity:0;}
  .tmss-cal-fndtxt:focus {width:45%; opacity:1; color:white;}
  
  /* Botón de preinscriptos */
  .btneduplnpre:focus{color:white;}
  
  	/* Estilos sobrescritos de FULLCALENDAR */
  .fc .fc-button {border-radius: 15px; outline:none !important ;height: 40px; background-color: #177dff !important ;border-color: #177dff;}
  .fc-prev-button {border-top-right-radius: 0px; border-bottom-right-radius: 0px;}
  .fc-next-button {border-top-left-radius: 0px; border-bottom-left-radius: 0px;}
  .fc-today-button {border: 0px !important;}
  .fc button:hover, .fc button:focus, .fc button:active {background-color: #1876e6 !important; box-shadow: none !important;}
  .fc-header-toolbar {margin-right:30px;}
  .fc-changeviewbutton-button {width:150%; margin-right: 5px !important;}
  
</style>

<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>" style="overflow:hidden;">
	<nav class="navbar-default tmss-navbar">
		<div class="container-fluid">
      <ul class="nav navbar-nav tmss-navbar-left">
        <a href="#" id="btneduplnpre" class="btn navbar-btn tmss-navbar-btn btneduplnpre" style="height: 28px; padding-top: 3px;"><span class="fas fa-users"></span><span id="selectedamnt" style="margin-left:5px" class="badge"></span><span style="margin-left:5px;">Preinscriptos</span></a>
			</ul>
			<ul class="nav navbar-right btn-toolbar tmss-navbar-right">
				<!--Dropdown-->
				<div class="btn-group dropdown">
					<a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><span class="fas fa-ellipsis-v"></span></a>
					<form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
						<!--Actualizar-->
						<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '13'});" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
            <!--Imprimir-->
						<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: 'prn'});" class="tmssLink"><i style="width:20px;" class="fas fa-print"></i><?= $vew_lang->print; ?></a></li>
							<li class="divider"></li>
							<li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '04'});"  class="tmssLink" title="<?= $vew_lang->delete; ?>"><span style="width:20px" class="fas fa-trash-alt"></span><?= $vew_lang->delete; ?></a></li>
						<!--Ayuda-->
						<?php include('sysappprghlpbtn.frm'); ?>
					</form>
				</div>
        <?php if ($vew_actcod!='01') { ?>
					<a href="#" id="btnflt" class="btn navbar-btn tmss-navbar-btn"><span class="fas fa-filter"></span><span id="fltcnt" class="badge"></span></a>
				<?php } ?>
				<!--Cerrar-->
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>			
      </ul>			
		</div>
	</nav>
	<div class="row">
    <!-- DIV DE SELECCIÓN DE PREINSCRIPTOS -->
    <div id="diveduplnpre" class="tmss-edupln-pre container-fluid" style="padding-left: 10px; position: absolute; z-index: 10; left:-100%; width:100%; background-color: #ffffff; border: 1px solid #ddd; transition: 0.7s;">
      <div class="row">
        <div class="col-sm-2 col-xs-2">
          <div class="form-check form-check-inline">
            <input class="form-check-input" style="margin: 16px;" type="checkbox" id="btnsel">
          </div>
        </div>
        <div class="col-sm-10 col-xs-10" style="text-align: right; margin-top: 5px;">
          <form role="search" method="get" id="frmfnd" class="tmss-cal-frmfnd" action="">
            <label for="fndtxt" style="padding-left: 10px;">
              <i class="fas fa-search" style="font-size:15px; color:#177dff;"></i>
            </label>
            <input class="nav-link tmss-cal-fndtxt" type="text" value="" placeholder="Buscar" id="fndtxt" style="padding-left:5px; color:black; border-bottom: 1px solid #177dff;" autocomplete="off">
          </form>
          <a href="#" id="btnpin" class="btn btn-default navbar-btn tmss-cal-btneduplncal tmss-hide-on-mobile" title="Fijar" style="color: gray; margin-right: 10px;"><i class="fas fa-thumbtack"></i></a>
        </div>
      </div>
      <div class="tmss-table-body" style="max-height: calc(100vh - 199px); overflow-y: auto; overflow-x: hidden;">
        <table class="table table-condensed table-bordered" id="tbleduplnpre" style="margin-bottom: 0px;">
          <tbody>
            <tr><td class="text-center">Busqueda de preinscriptos...</td></tr>
          </tbody>
        </table>
      </div>
      <div style="margin:10px;"></div>
    </div>	
    <div id="spacerdiv" class="col-1 col-md-1 text-center tmss-cal-btneduplnpre-div"style="padding-top:10px;"></div>
		<div id="calendardiv" class="col-12 col-md-10">
			<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm" style="padding-top: 10px;">
				<div class="container-fluid" role="tabpanel">
					<input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
					<input type="hidden" id="calvew" name="calvew" value="<?= $vew_data->calvew; ?>">
					<input type="hidden" id="caldte" name="caldte" value="<?= ($vew_data->caldte==''?date('Y-m-d'):$vew_data->caldte); ?>">
					<div id="calendar" style="height: calc(100vh - 90px);"></div>
          <div id="calendarviewdropdown" class="tmss-cal-vewdrpdwn"> <!--dropdown de selección de vista de calendario-->
            <p class="tmss-cal-item tmss-cal-ordday" id="ordday">Por d&iacute;a</p>
            <p class="tmss-cal-item" id="ordweek">Por semana</p>
            <p class="tmss-cal-item" id="ordmonth">Por mes</p>
            <p class="tmss-cal-item tmss-cal-ordagenda" id="ordagenda" style="margin-bottom:0px;">Agenda</p>
          </div>
				</div>
			</form>
		</div>
	</div>
	<script>
    $(function(){
      if (1 == <?= ($vew_data->cfg['usrpin'] == 'X' ? '1' : '0') ?>){
        $("#<?= $lv_sec; ?> #btneduplnpre").click();
        $("#<?= $lv_sec; ?> #btnpin").click();
      }
    });
    
		$("#<?= $lv_sec; ?> #fndtxt").on("keyup",function(e){
			var lv_txt = $(this).prop("value");
			$("#<?= $lv_sec; ?> #tbleduplnpre > tbody > tr").each(function(x){
				if ($(this).text().toLowerCase().indexOf( lv_txt.toLowerCase() )!=-1) {
					$(this).removeClass("hidden");
				} else {
					$(this).addClass("hidden");
				}
			});
		});
		
		$("#<?= $lv_sec; ?> #frmfnd").on("submit",function(e){
			var lv_pstdat = [];
			tmssCallProcess("?prg=edupln&act=calpre",lv_pstdat,function(data){
				if(Array.isArray(data)){
					var lv_buffer = "";
					for(var i=0; i<data.length; i++){
						lv_buffer += "<tr data-eduplnprecod='"+data[i].eduplnprecod+"' data-educurcod='"+data[i].educurcod+"' data-educurtxt='"+data[i].educurtxt+"' data-educarcod='"+data[i].educarcod+"' data-educartxt='"+data[i].educartxt+"' data-educoucod='"+data[i].educoucod+"' data-educoutxt='"+data[i].educoutxt+"' data-edusubcod='"+data[i].edusubcod+"' data-edusubtxt='"+data[i].edusubtxt+"' data-stucod='"+data[i].stucod+"' data-stutxt='"+data[i].stutxt+"'>"+
              "<td style='padding-left: 15px;'>"+
                "<div class='row'>"+
                  "<div class='col-xs-1'>"+
              			"<input class='form-check-input' type='checkbox' value=''>"+
                  "</div>"+
              		"<div class='col-xs-7'>"+
              			"<span style='font-size:90%;'>"+data[i].stutxt+"</span><br><span style='font-size:80%';>"+data[i].edusubtxt+"</span>"+
                  "</div>"+
              		"<div class='col-xs-3'>"+
              			moment(data[i].eduplnpredte.date).format("DD.MM.YYYY")+
                  "</div>"+
                "</div>"+
            	"</td></tr>";
					}
					$("#<?= $lv_sec; ?> #tbleduplnpre tbody").html(lv_buffer);
					<?= $lv_sec; ?>_attachEventPlnPre();
				}
			});
			e.preventDefault();
			e.stopPropagation();
			return false;
		});
		    
		function <?= $lv_sec; ?>_attachEventPlnPre() {
			$("#<?= $lv_sec; ?> #tbleduplnpre tbody tr").on("click",function(e){
				$(this).toggleClass("bg-info");
        if (e.target.nodeName != "INPUT"){
          if($(this).find("td input").prop("checked")==true){
            $(this).find("td input").prop("checked", false);
          }else{
            $(this).find("td input").prop("checked", true);
          } 
        }
        //Si todos están checkeados
        if($("#<?= $lv_sec; ?> #tbleduplnpre tbody tr td input:checked").length == $("#<?= $lv_sec; ?> #tbleduplnpre tbody tr td input").length){
        	$("#<?= $lv_sec; ?> #btnsel").prop( "checked", true );
        }else{
          $("#<?= $lv_sec; ?> #btnsel").prop( "checked", false );
        }
			});
		}

    
    //Botón de seleccionar/deseleccionar todos
		$("#<?= $lv_sec; ?> #btnsel").on("click",function(e){
      if($(this).is(":checked")){
      	$("#<?= $lv_sec; ?> #tbleduplnpre tbody tr").addClass("bg-info"); 
        $("#<?= $lv_sec; ?> #tbleduplnpre tbody tr td input").prop( "checked", true );
      }else{
        $("#<?= $lv_sec; ?> #tbleduplnpre tbody tr").removeClass("bg-info");
        $("#<?= $lv_sec; ?> #tbleduplnpre tbody tr td input").prop( "checked", false );
      }
		});
    
    
    //Botón de fijar sidebar
    $("#<?= $lv_sec; ?> #btnpin").on("click",function(e){
      if($(this).css("color")=="rgb(128, 128, 128)"){
        $(this).css("color", "#177dff");
        lv_ispinned = true;
        $("#<?= $lv_sec; ?> #btneduplnpre").css("color", "lightgray");
        $("#<?= $lv_sec; ?> #spacerdiv").removeClass("col-md-1");
        $("#<?= $lv_sec; ?> #spacerdiv").addClass("col-md-3");
        $("#<?= $lv_sec; ?> #calendardiv").removeClass("col-md-10");
        $("#<?= $lv_sec; ?> #calendardiv").addClass("col-md-9");
      	<?= $lv_sec; ?>_calendar.render();
      }else{
        $(this).css("color", "gray");
        lv_ispinned = false;
        $("#<?= $lv_sec; ?> #btneduplnpre").css("color", "");
        $("#<?= $lv_sec; ?> #spacerdiv").removeClass("col-md-3");
        $("#<?= $lv_sec; ?> #spacerdiv").addClass("col-md-1");
        $("#<?= $lv_sec; ?> #calendardiv").removeClass("col-md-9");
        $("#<?= $lv_sec; ?> #calendardiv").addClass("col-md-10");
      	<?= $lv_sec; ?>_calendar.render();
      }
      // se graba la preferencia de usuario del pin
      tmssCallProcessNoBackdrop("?prg=edupln&act=sveprfcal",[{name:"usrpin",value:(lv_ispinned==true ? "X":"")}],function(data){});
		});

    
		function <?= $lv_sec; ?>_proccessEvent( lp_act, lp_eduplncod, lp_eduplndtecod, lp_strdte, lp_enddte ) {
			if( lp_act=="12" ){
				var lv_dat = [{name:"eduplncod", value: lp_eduplncod}, {name:"eduplndtecod", value: lp_eduplndtecod}, {name:"eduplndtestr", value: lp_strdte}, {name:"eduplndteend", value: lp_enddte}];
				tmssCallProcess("?prg=edupln&act="+lp_act, lv_dat, function(data){
					if ( data.errcod != 0 ) {
						toastr.warning( data.errtxt );
						return false;
					} else {
						toastr.success("Planificaci&oacute;n actualizada.","Planificacion");
						return true;
					}
				});
			} else {
				var lv_datpst = [ {name:"eduplncod", value: lp_eduplncod}, 
													{name:"eduplndtecod", value: lp_eduplndtecod},
													{name:"strdte", value:lp_strdte}, 
													{name:"enddte", value:lp_enddte} ];
				if (lp_act=="01") {
					var lv_stuarr = $("#<?= $lv_sec; ?> #tbleduplnpre tbody tr.bg-info");
					var lv_stubuf = [];
					if( $(lv_stuarr).length>0 ) {
						$(lv_stuarr).each(function(index){
							if(index==0){
								lv_datpst.push( {name:"educurcod", value:$(this).data("educurcod")},{name:"educurtxt", value:$(this).data("educurtxt")},
																{name:"educarcod", value:$(this).data("educarcod")},{name:"educartxt", value:$(this).data("educartxt")},
																{name:"educoucod", value:$(this).data("educoucod")},{name:"educoutxt", value:$(this).data("educoutxt")},
																{name:"edusubcod", value:$(this).data("edusubcod")},{name:"edusubtxt", value:$(this).data("edusubtxt")}
															);
							}
							lv_stubuf.push({stucod: $(this).data("stucod"), stutxt:$(this).data("stutxt"), eduplnprecod:$(this).data("eduplnprecod")});
						});
						lv_datpst.push( {name:"stuarr", value:JSON.stringify(lv_stubuf) } )
					}
				}
				tmssLink("?prg=edupln&act="+lp_act, [{target: "_new_section", post_data: lv_datpst}]);
			}
		}

		var gv_<?= $lv_sec; ?>_flt = [
									{'fldttl': '<?= $vew_lang->ID; ?>', 'fldcod': 'pd.eduplndtecod', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->place; ?>', 'fldcod': 's.stdloctxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->curriculum; ?>', 'fldcod': 'ec.educurtxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->career; ?>', 'fldcod': 'ea.educartxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->course; ?>', 'fldcod': 'eo.educoutxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->subject; ?>', 'fldcod': 'es.edusubtxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->teacher; ?>', 'fldcod': 't.tchtxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->student; ?>', 'fldcod': '[stutxt]', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->status; ?>', 'fldcod': '[status]', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''}
									];
		
		$("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
			tmssFilterShowDialog(gv_<?= $lv_sec; ?>_flt,<?= $lv_sec; ?>_GridRefresh);
		});
		
		function <?= $lv_sec; ?>_GridRefresh(lp_flt) {
			var lv_fltint;
			if(lp_flt!=null){
				lv_fltint = tmssFilterParseToInternal(lp_flt);
				gv_<?= $lv_sec; ?>_flt = lp_flt;
				$("#<?= $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
			}
      if (<?= $lv_sec; ?>_calendar != undefined){
				<?= $lv_sec; ?>_calendar.refetchEvents();
        <?= $lv_sec; ?>_calendar.render();
      }
			$("#<?= $lv_sec; ?> #frmfnd").trigger("submit");
		}
		
		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {			
			if (lp_prm["action"]=="prn") {
				window.print();
			} else if (lp_prm["action"]=="13") {
				<?= $lv_sec; ?>_GridRefresh();
			}			
		}
    
    var <?= $lv_sec; ?>_calendar;
		$(function() {
			var date = new Date();
			var d = date.getDate();
			var m = date.getMonth();
			var y = date.getFullYear();
			tmssLoadScript("fullcalendar54",function(){
        var calendarEl = $("#<?= $lv_sec; ?> #calendar").get(0);
        <?= $lv_sec; ?>_calendar = new FullCalendar.Calendar(calendarEl, {
          //themeSystem:"bootstrap", BOOTSTRAP 4
          
          initialView: "dayGridMonth",        
          views: {
            dayGridMonth: { titleFormat: { year: "numeric", month: "long" } },
            listMonth: { titleFormat: { year: "numeric", month: "long" } },
            timeGridDay: { titleFormat: { year: "numeric", day:"2-digit", month: "short" } },
          },
          moreLinkContent: function(arg) {
            return  arg.text.substr(0,arg.text.indexOf(" "))+" eventos";
          },
          viewClassNames: function(arg) {
            $("#<?= $lv_sec; ?> .fc-changeviewbutton-button").empty();
            $("#<?= $lv_sec; ?> .fc-changeviewbutton-button").append("<i class='fas fa-calendar-alt'></i>");
          },
					titleRangeSeparator:" - ",
					defaultRangeSeparator: " - ",
          customButtons: {
            changeviewbutton: {
              icon: "fc-icon-calendar",
              click: function() {
                if($("#<?= $lv_sec; ?> #calendarviewdropdown").css("display")==="none"){
                   $("#<?= $lv_sec; ?> #calendarviewdropdown").css({"display":"block"});
                } else {
                   $("#<?= $lv_sec; ?> #calendarviewdropdown").css({"display":"none"});
                }
                var offset = $("#<?= $lv_sec; ?> #calendar").offset();
                var offset2 = $("#<?= $lv_sec; ?> .fc-changeviewbutton-button").offset();
                var height = offset2.top + $("#<?= $lv_sec; ?> .fc-changeviewbutton-button").height();
                y = height - offset.top*.8;

                $("#<?= $lv_sec; ?> #calendarviewdropdown").css( {
                   "right": "15px",
                    "top": y
                });
              }
            }
          },
          headerToolbar: {
            left: "prev,next today",
            center: "title",
            right: "changeviewbutton"
          },
          buttonIcons: true, // show the prev/next text
					navLinks: true, // can click day/week names to navigate views
					editable: false,
					eventStartEditable: false,
					eventDurationEditable: false,
          dayMaxEventRows: true, // for all non-TimeGrid views
					firstDay: 7,
          events: function(info, callback, failureCallback) {
						var lv_pstdat = { start: moment(info.start).format("YYYY-MM-DD"),
															end: moment(info.end).format("YYYY-MM-DD"),
															fltqty: gv_<?= $lv_sec; ?>_flt.length,
															vewfldflt: (tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["fltstr"]==""?"":tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["fltstr"]), 
															vewmaxrec: (tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["maxrec"]==""?"100":tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["maxrec"]) 
														};
            tmssCallProcess("?prg=edupln&act=18", lv_pstdat, function(data){
              callback(data);
              if(<?= $lv_sec; ?>_calendar!=undefined){
                <?= $lv_sec; ?>_calendar.render();
                <?= $lv_sec; ?>_calendar.render();
              }
						});
					},
          businessHours: {
						dow: [ 1, 2, 3, 4, 5 ], // Monday - Friday
						start: "09:00", // a start time (09am in this example)
						end: "18:00", // an end time (6pm in this example)
					},
          <?php if ( $vew_sec->hasPermission('EDU','PLN','01') ) { ?>
						navLinkWeekClick: function(weekStart, jsEvent) { 
							var lv_weekEnd = moment(weekStart).add(6,"days");
							<?= $lv_sec; ?>_proccessEvent( "01", 0, 0, weekStart.format("YYYYMMDDHHmm"), lv_weekEnd.format("YYYYMMDDHHmm") ); 
						},
						dateClick: function(info) {
							<?= $lv_sec; ?>_proccessEvent( "01", 0, 0, moment(info.date).format("YYYYMMDDHHmm"), moment(info.date).format("YYYYMMDDHHmm") );
              $("#<?= $lv_sec; ?> #selectedamnt").css({"display":"none"});
						},
					<?php } ?>
          <?php if ( $vew_sec->hasPermission('EDU','PLN','02') ) { ?>
						eventResize: function(info) {
							BootstrapDialog.confirm({
								title: "Actualizar Planificaci&oacute;n", 
								message:"Desea actualizar la hora del evento de "+moment(info.event.start).format("HH:mm")+" a "+moment(info.event.end).format("HH:mm")+" ?", 
								type: BootstrapDialog.TYPE_WARNING, 
								callback: function(result){
										if (result){
											if( <?= $lv_sec; ?>_proccessEvent("12", info.event.extendedProps.eduplncod, info.event.extendedProps.eduplndtecod, moment(info.event.start).format("YYYYMMDDHHmm"),  moment(info.event.end).format("YYYYMMDDHHmm") ) ) {
												info.revert();
											}
										} else {
											info.revert();
										}
									} 
							});
						},
						eventDrop: function(info) {
             
							BootstrapDialog.confirm({
								title: "Mover planificaci&oacute;n", 
								message: <?= $lv_sec; ?>_dropMsg(info.event, info.oldEvent), 
								type: BootstrapDialog.TYPE_WARNING, 
								callback: function(result){
									if(result){
                   	// Segun el movimiento de planificacion el valor de la fecha final va a variar
                    lv_end_dte = (info.event.end == null ) ? ( (info.event.allDay == false) ? moment(info.event.start).add(1, "h").format("YYYYMMDDHHmm") : moment(info.event.start).format("YYYYMMDDHHmm") ) : moment(info.event.end).format("YYYYMMDDHHmm");
										if( <?= $lv_sec; ?>_proccessEvent("12", info.event.extendedProps.eduplncod, info.event.extendedProps.eduplndtecod, moment(info.event.start).format("YYYYMMDDHHmm"), lv_end_dte ) ) {
                      info.revert();
										}
                   	<?= $lv_sec; ?>_fnc({action: '13'});
									} else {
										info.revert();
									}
								} 
							});
						},
					<?php } ?>
          eventClick: function(info) {
            $("#<?= $lv_sec; ?> #selectedamnt").css({"display":"none"});
						<?= $lv_sec; ?>_proccessEvent( "<?= ($vew_sec->hasPermission('EDU','PLN','02')?'02':'03'); ?>", info.event.extendedProps.eduplncod, info.event.extendedProps.eduplndtecod, "", "" ); 
					},
					<?= ($vew_data->calvew!=''?'defaultView: "'.$vew_data->calvew.'",':''); ?>
					<?= ($vew_data->caldte!=''?'defaultDate: moment("'.$vew_data->caldte.'"),':''); ?>
        });
        <?= $lv_sec; ?>_calendar.setOption("locale", "es");
			});
    <?= $lv_sec; ?>_GridRefresh();
		});
    
    //Espera a que se cree el calendario
    setTimeout(function(){
      if ($(window).width() < 900){
  			mobileToolbar(); 
    	}
    },750);
    
    
    // Elimina los botones de la toolbar y crea otra toolbar que coloca debajo del título para vista mobile
    function mobileToolbar() {
      $("#<?= $lv_sec; ?> .fc-prev-button").remove();
      $("#<?= $lv_sec; ?> .fc-next-button").remove();
      $("#<?= $lv_sec; ?> .fc-today-button").remove();
      $("#<?= $lv_sec; ?> .fc-changeviewbutton-button").remove();
      <?= $lv_sec; ?>_calendar.setOption("headerToolbar", {left: "", center: 'title', right:""});
      var events = $("#fc-prev-button").data('events');
      // create buttons
      var toolbar = "<div style='zoom: 0.85;' class='fc-header-toolbar fc-toolbar fc-toolbar-ltr'>"+
                        "<div class='fc-button-group'>"+
                          "<button onclick='<?= $lv_sec; ?>_calendar.prev();' class='fc-prev-button fc-button fc-button-primary' type='button' aria-label='prev'><span class='fc-icon fc-icon-chevron-left'></span></button>"+
                          "<button onclick='<?= $lv_sec; ?>_calendar.next();' class='fc-next-button fc-button fc-button-primary' type='button' aria-label='next'><span class='fc-icon fc-icon-chevron-right'></span></button>"+
                        "</div>"+
                        "<button onclick='<?= $lv_sec; ?>_calendar.today();' class='fc-today-button fc-button fc-button-primary' type='button'>Hoy</button>"+
                        "<button onclick='mobileDropdown();' class='fc-changeviewbutton-button fc-button fc-button-primary' style='max-width:50px;' type='button' aria-label='changeviewbutton'><i class='fas fa-calendar-alt'></i></button>"+
                    "</div>";
      
      // insert row before title.
      $("#<?= $lv_sec; ?> .fc-header-toolbar").after(toolbar);
  	}
    
    
    function mobileDropdown() {
      if($("#<?= $lv_sec; ?> #calendarviewdropdown").css("display")==="none"){
         $("#<?= $lv_sec; ?> #calendarviewdropdown").css({"display":"block"});
      } else {
         $("#<?= $lv_sec; ?> #calendarviewdropdown").css({"display":"none"});
      }
      var offset = $("#<?= $lv_sec; ?> #calendar").offset();
      var offset2 = $("#<?= $lv_sec; ?> .fc-changeviewbutton-button").offset();
      var height = offset2.top + $("#<?= $lv_sec; ?> .fc-changeviewbutton-button").height();
      y = height - offset.top*.8;

      $("#<?= $lv_sec; ?> #calendarviewdropdown").css( {
         "right": "15px",
          "top": y
      });
    }
    
    
	
    
    // FUNCION dropMsg. Devuelve un mensaje segun el caso del drop
    function <?= $lv_sec; ?>_dropMsg(event, oldEvent){
      
    	var lv_msg = "";
       
      if( event.allDay ){
        // Si el evento anteriormente era con rango de horario y paso a todo el dia
        if( oldEvent.allDay ){
          var lv_end_dte = '';
          lv_end_dte = event.start;
          lv_msg = "Desea actualizar la fecha del evento actual del "+moment(oldEvent.start).format("DD/MM/YY")+" al "+moment(lv_end_dte).format("DD/MM/YY")+" ?";
        } else {  
          // Si tambien se movio de fecha se figurara la fecha nueva en el mensaje
          if( moment(event.start).format("DD/MM/YY") != moment(oldEvent.start).format("DD/MM/YY") ){
            lv_msg = "Desea actualizar la hora del evento actual de '"+moment(oldEvent.start).format("HH:mm")+" a "+moment(oldEvent.end).format("HH:mm")+"' a 'Todo el d&iacute;a' para la fecha: "+moment(event.start).format("DD/MM/YY")+" ?";
          } else {
           	lv_msg = "Desea actualizar la hora del evento actual de '"+moment(oldEvent.start).format("HH:mm")+" a "+moment(oldEvent.end).format("HH:mm")+"' a 'Todo el d&iacute;a'?"; 
          } 
        }     
      } else {
       	// Si el evento anteriormente era para todo el dia se cambia a rango de horario 
        if( oldEvent.allDay ){
          var lv_end_dte = '';
       		lv_end_dte = moment(event.start).add(1, "h").format("HH:mm");
          
          // Si tambien se movio de fecha se figurara la fecha nueva en el mensaje
          if( moment(event.start).format("DD/MM/YY") != moment(oldEvent.start).format("DD/MM/YY") ){
            lv_msg = "Desea actualizar la hora del evento actual de 'Todo el d&iacute;a' a '"+moment(event.start).format("HH:mm")+" a "+lv_end_dte+"' para la fecha: "+moment(event.start).format("DD/MM/YY")+" ?";
          } else {
           	lv_msg = "Desea actualizar la hora del evento actual de 'Todo el d&iacute;a' a '"+moment(event.start).format("HH:mm")+" a "+lv_end_dte+"' ?"; 
          }          
        } else {
          
          // Si tambien se movio de fecha se figurara la fecha nueva en el mensaje
          if( moment(event.start).format("DD/MM/YY") != moment(oldEvent.start).format("DD/MM/YY") ){
            lv_msg = "Desea actualizar la fecha del evento actual del "+moment(oldEvent.start).format("DD/MM/YY")+" al "+moment(event.start).format("DD/MM/YY")+" ?";
          } else {
           	lv_msg = "Desea actualizar la hora del evento de "+moment(event.start).format("HH:mm")+" a "+moment(event.end).format("HH:mm")+" ?";
          }   
        }
      } 
    	
      return lv_msg;
    };
    
    
    var lv_ispinned = false;
    // REVISAR AL MIGRAR A BOOTSTRAP 4
    $("#<?= $lv_sec ?>").click(function(e){
      // Cerrar dropdown de vista
      if(e.target !== $("#<?= $lv_sec; ?> .fc-changeviewbutton-button")[0] && e.target !== $("#<?= $lv_sec; ?> .fa-calendar-alt")[0]) {
          $("#<?= $lv_sec; ?> #calendarviewdropdown").css({"display":"none"});
      }
      // Colocar ícono de calendario en el botón de cambiar de vista
      if($(e.target).closest(".fc-next-button").length || $(e.target).closest(".fc-prev-button").length || $(e.target).closest(".fc-today-button").length) {
        $("#<?= $lv_sec; ?> .fc-changeviewbutton-button").empty();
    		$("#<?= $lv_sec; ?> .fc-changeviewbutton-button").append("<i class='fas fa-calendar-alt'></i>");
      }
      // Cerrar sidebar de selección de preinscriptos
      if (!lv_ispinned){
        if(!$(e.target).closest("#btneduplnpre").length && !$(e.target).closest("#diveduplnpre").length) {
          if($("#<?= $lv_sec; ?> #diveduplnpre").css("left")>"0"){$("#<?= $lv_sec; ?> #diveduplnpre").css({"left":"-100%"})};
        }
      }
      // Actualizar número en badge con cantidad de preinscriptos seleccionados
      if ($("#<?= $lv_sec; ?> #diveduplnpre").find(".bg-info").length == 0){
        $("#<?= $lv_sec; ?> #selectedamnt").css({"display":"none"});
      }else{
        $("#<?= $lv_sec; ?> #selectedamnt").css({"display":"inherit"});
      	$("#<?= $lv_sec; ?> #selectedamnt").text($("#<?= $lv_sec; ?> #diveduplnpre").find(".bg-info").length);
      }
		});

    //Cambiar vista de calendario
    $("#<?= $lv_sec; ?> #ordday").click(function() { <?= $lv_sec; ?>_calendar.changeView("timeGridDay"); });
    $("#<?= $lv_sec; ?> #ordweek").click(function() { <?= $lv_sec; ?>_calendar.changeView("timeGridWeek"); });
    $("#<?= $lv_sec; ?> #ordmonth").click(function() { <?= $lv_sec; ?>_calendar.changeView("dayGridMonth"); });
    $("#<?= $lv_sec; ?> #ordagenda").click(function() { <?= $lv_sec; ?>_calendar.changeView("listMonth"); });
    
    //Botón de preinscriptos
    $("#<?= $lv_sec; ?> #btneduplnpre").click(function() {
      if(!lv_ispinned){
      	if($("#<?= $lv_sec; ?> #diveduplnpre").css("left")<"0"){
					$("#<?= $lv_sec; ?> #diveduplnpre").css({"left":"0%"});
        } else {
           $("#<?= $lv_sec; ?> #diveduplnpre").css({"left":"-100%"});
        }      
        var offset = $(this).offset();
        var height = offset.top + $(this).height();
        y = height + 20;
        $("#<?= $lv_sec; ?> #diveduplnpre").css({"top": y}); 
      }
    });
  </script>
</section>
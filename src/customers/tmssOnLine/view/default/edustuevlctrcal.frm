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
	$lv_prgcod = 'EVL';

	// librería de estilos bootstrap
	include_once('_library.frm');
			
	$vew_actcod = '02';
?>
<style>
  	/* Estilos de CALENDARIO */
  .tmss-cal-vewdrpdwn {display: none; position: absolute; border-radius: 15px;background-color: #177dff; z-index: 10;}
  .tmss-cal-item {color: #FFFFFF; padding: 12px 16px; display: block; margin:0px;}
  .tmss-cal-item:hover {cursor:pointer; background-color: #1876e6;}
  .tmss-cal-ordday:hover {border-top-left-radius: inherit; border-top-right-radius: inherit;}
  .tmss-cal-ordagenda:hover {border-bottom-left-radius: inherit; border-bottom-right-radius: inherit;}

  	/* Estilos sobrescritos de FULLCALENDAR */
  .fc .fc-button {border-radius: 15px; outline:none !important ;height: 40px; background-color: #177dff !important ;border-color: #177dff;}
  .fc-prev-button {border-top-right-radius: 0px; border-bottom-right-radius: 0px;}
  .fc-next-button {border-top-left-radius: 0px; border-bottom-left-radius: 0px;}
  .fc button:hover, .fc button:focus, .fc button:active {background-color: #1876e6 !important; box-shadow: none !important;}
  .fc-header-toolbar {margin-right:30px;}
  .fc-changeviewbutton-button {width:150%; margin-right: 5px !important;}
</style>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<nav class="navbar-default tmss-navbar">
		<div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<a href="#" id="btnlst" class="btn navbar-btn tmss-navbar-btn"><span class="fas fa-list"></span></a>
			</ul>
			<ul class="nav navbar-right btn-toolbar tmss-navbar-right">
				<?php if ($vew_actcod!='01') { ?>
					<a href="#" id="btnflt" class="btn navbar-btn tmss-navbar-btn"><span class="fas fa-filter"></span><span id="fltcnt" class="badge"></span></a>
				<?php } ?>
        <div class="btn-group dropdown">
					<a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><span class="fas fa-ellipsis-v"></span></a>
					<form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
						<!--Imprimir-->
            <li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: 'prn'});" class="tmssLink"><i style="width:20px" class="fas fa-print"></i><?= $vew_lang->print; ?></a></li>
						<!--Actualizar-->
            <li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '13'});" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
						<!--Ayuda-->
						<?php include('sysappprghlpbtn.frm'); ?>
					</form>
				</div>
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
	</nav>
	
	<div class="container-fluid">
    <div class="row"> 
			<div class="col-12 col-md-10 col-md-offset-1">
				<div style="padding-top: 10px;">
					<div id="calendar"></div>
          <div id="calendarviewdropdown" class="tmss-cal-vewdrpdwn"> <!--dropdown de selección de vista de calendario-->
            <p class="tmss-cal-item tmss-cal-ordday" id="ordday">Por d&iacute;a</p>
            <p class="tmss-cal-item" id="ordweek">Por semana</p>
            <p class="tmss-cal-item" id="ordmonth">Por mes</p>
            <p class="tmss-cal-item tmss-cal-ordagenda" id="ordagenda" style="margin-bottom:0px;">Agenda</p>
          </div>
				</div>
			</div>
		</div>
	</div>

	<script>
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
            dayGridMonth: { titleFormat: { year: "numeric", month: "short" } },
            listMonth: { titleFormat: { year: "numeric", month: "short" } },
            timeGridDay: { titleFormat: { year: "numeric", day:"2-digit", month: "short" } },
          },
          moreLinkContent: function(arg) {
            return  arg.text.substr(0,arg.text.indexOf(" "))+" eventos";
          },
          viewClassNames: function(arg) {
            $("#<?= $lv_sec; ?> .fc-changeviewbutton-button").empty();
            $("#<?= $lv_sec; ?> .fc-changeviewbutton-button").append("<i class='fas fa-calendar-alt'></i>");
          },
					dayHeaderFormat: { weekday: "short", month: "numeric", day: "numeric", omitCommas: true },
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
          events: {
						url: "?prg=edustuevl&act=ctrlstcal",
            method: "POST",
						failure: function() {
							alert("Se produjo un error al intentar obtener los eventos del calendario.");
						},
						textColor: "black" // a non-ajax option
					},
          businessHours: {
						// days of week. an array of zero-based day of week integers (0=Sunday)
						dow: [ 1, 2, 3, 4, 5 ], // Monday - Friday
						start: "09:00", // a start time (09am in this example)
						end: "18:00", // an end time (6pm in this example)
					},
          eventClick: function(info) {
						if( info.event.extendedProps.eduevlfrm!="" ) {
							var lv_pstdat= [{name:"evlcod", value: info.event.extendedProps.evlcod },
															{name:"eduplncod", value: info.event.extendedProps.eduplncod },
															{name:"eduplndtecod", value: info.event.extendedProps.eduplndtecod },
															{name:"stucod", value: info.event.extendedProps.stucod }];
							tmssLink( jQuery('<div></div>').html(info.event.extendedProps.eduevlfrm).text(), [{target: "_new_section", post_data: lv_pstdat}] );
						}
					}
        });
      <?= $lv_sec; ?>_calendar.setOption("locale", "es");
      <?= $lv_sec; ?>_calendar.render();
      })
    <?= $lv_sec; ?>_GridRefresh();
    });

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
    });

    //Cambiar vista de calendario
    $("#<?= $lv_sec; ?> #ordday").click(function() { <?= $lv_sec; ?>_calendar.changeView("timeGridDay"); });
    $("#<?= $lv_sec; ?> #ordweek").click(function() { <?= $lv_sec; ?>_calendar.changeView("timeGridWeek"); });
    $("#<?= $lv_sec; ?> #ordmonth").click(function() { <?= $lv_sec; ?>_calendar.changeView("dayGridMonth"); });
    $("#<?= $lv_sec; ?> #ordagenda").click(function() { <?= $lv_sec; ?>_calendar.changeView("listMonth"); });
    
    
		$("#<?= $lv_sec; ?> #btnlst").on("click",function(e){
			tmssLink("?prg=edustuevl&act=ctr&prm_vew=lst", [{target: "_replace_with", target_id: "#<?= $lv_sec; ?>"}]);
			e.preventDefault();
		});
		
		function <?= $lv_sec; ?>_GridRefresh(lp_flt) {
      setTimeout(function(){
        if (<?= $lv_sec; ?>_calendar != undefined){
          <?= $lv_sec; ?>_calendar.refetchEvents();
          <?= $lv_sec; ?>_calendar.render();
      	}
      },100);
		}

		var gv_<?= $lv_sec; ?>_flt = [
									{'fldttl': '<?= $vew_lang->ID; ?>', 'fldcod': 'e.evlcod', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->place; ?>', 'fldcod': 'el.stdloctxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->curriculum; ?>', 'fldcod': 'ec.educurtxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->career; ?>', 'fldcod': 'ea.educartxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->course; ?>', 'fldcod': 'eo.educoutxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->subject; ?>', 'fldcod': 'es.edusubtxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->teacher; ?>', 'fldcod': 'et.tchtxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->student; ?>', 'fldcod': 'eu.stutxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''},
									{'fldttl': '<?= $vew_lang->status; ?>', 'fldcod': 'status', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''}
									];
		
		$("#<?= $lv_sec; ?> #btnflt").on("click",function(e){
			tmssFilterShowDialog(gv_<?= $lv_sec; ?>_flt,<?= $lv_sec; ?>_GridRefresh);
			e.preventDefault();
		});
		
		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {			
			if (lp_prm["action"]=="prn") {
				window.print();
			} else if (lp_prm["action"]=="13") {
				<?= $lv_sec; ?>_GridRefresh();
        toastr.info( "Calendario actualizado" );
			}			
		}
  </script>
</section>
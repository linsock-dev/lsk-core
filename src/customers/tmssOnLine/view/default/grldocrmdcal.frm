<?php
	// url del formulario 
  $lv_lnk = '?prg=grldocrmd&act=28';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = ''; 

	// titulo 
	$lv_title = $vew_lang->calendar;
	
	// módulo y programa 
	$lv_mdlcod = '';
	$lv_prgcod = '';

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
  <form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm" style="padding-top: 0px;">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<input type="hidden" id="caldte" name="caldte" value="<?= $vew_data->caldte; ?>">
		<input type="hidden" id="calvew" name="calvew" value="<?= $vew_data->calvew; ?>">
    <div class="row"> 
			<div class="col-12">
				<div style="padding-top: 10px; padding-left: 10px; padding-right: 10px;">
					<div id="tmssRemindersCalendar"></div>
          <div id="calendarviewdropdown" class="tmss-cal-vewdrpdwn"> <!--dropdown de selección de vista de calendario-->
            <p class="tmss-cal-item tmss-cal-ordday" id="ordday">Por d&iacute;a</p>
            <p class="tmss-cal-item" id="ordweek">Por semana</p>
            <p class="tmss-cal-item" id="ordmonth">Por mes</p>
            <p class="tmss-cal-item tmss-cal-ordagenda" id="ordagenda" style="margin-bottom:0px;">Agenda</p>
          </div>
				</div>
			</div>
		</div>
	</form>
	<script>
    var <?= $lv_sec; ?>_calendar;
		$(function() {
			var date = new Date();
			var d = date.getDate();
			var m = date.getMonth();
			var y = date.getFullYear();
			tmssLoadScript("fullcalendar54",function(){
        var calendarEl = $("#<?= $lv_sec; ?> #tmssRemindersCalendar").get(0);
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
          events: function(info, callback, failureCallback) {
						var lv_pstdat = { 
                              //caldte: $("#<?= $lv_sec; ?> #caldte").prop("value"),
                              start: moment(info.start).format("YYYY-MM-DD"),
                              end: moment(info.end).format("YYYY-MM-DD")
														};
						//$.ajax({ url:"?prg=grldocrmd&act=18", method: "POST", data: lv_pstdat}).done( function(data) {
            tmssCallProcess("?prg=grldocrmd&act=18", lv_pstdat, function(data){
              debugger;
              callback(data);
						});
					},
          businessHours: {
						// days of week. an array of zero-based day of week integers (0=Sunday)
						dow: [ 1, 2, 3, 4, 5 ], // Monday - Friday
						start: "09:00", // a start time (09am in this example)
						end: "18:00", // an end time (6pm in this example)
					},
					eventClick: function(info) {
            info.jsEvent.preventDefault();
						if (info.event.url) {
							$.ajax({ 
								url: info.event.url,
								complete: function(jqXHR,textStatus){ 
                            if(jqXHR.responseText.substr(0,10)=="/*script*/"){ 
                              eval(jqXHR.responseText); 
                            } else { 
                              BootstrapDialog.show({
                                title: "<?= $vew_lang->reminder; ?> - "+moment(info.start).format("YYYY/MM/DD"),
                                size: BootstrapDialog.SIZE_WIDE, 
                                message: $("<div></div>").html(jqXHR.responseText)
                              });
                            } 
													}
							});
						}
						return false;
					}
        });
        <?= $lv_sec; ?>_calendar.setOption("locale", "es");
        <?= $lv_sec; ?>_calendar.render();
			});
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
	</script>
</section>
<?php
	/* url del formulario */
  $lv_lnk = '?prg=stkmovdoc&act=28';

	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = '';

	/* titulo */
	$lv_title = $vew_lang->calendar;

	/* módulo y programa */
	$lv_mdlcod = '';
	$lv_prgcod = '';

	$vew_actcod = '02';

	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>" style="overflow-y:auto; overflow-x:hidden;">
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
  <nav class="navbar-default tmss-navbar">
    <div class="container-fluid">
			<ul class="nav navbar-right btn-toolbar tmss-navbar-right">
        <a href="#" id="btnflt" class="btn navbar-btn tmss-navbar-btn"><i style="width:20px" class="fas fa-filter"></i></a>
				<!--Dropdown-->
				<div class="btn-group dropdown">
					<a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><span class="fas fa-ellipsis-v"></span></a>
					<form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
          <?php if ($vew_actcod!='01') { ?>
            <li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: 'prn'});" class="tmssLink"><i style="width:20px" class="fas fa-print"></i><?= $vew_lang->print; ?></a></li>
          <!--Actualizar-->
            <li><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '28'});" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
          <?php } ?>
					</form>
				</div>
				<!--Cerrar-->
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
    </div>
  </nav>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm" style="padding-top: 0px;">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<input type="hidden" id="caldte" name="caldte" value="<?= $vew_data->caldte; ?>">
		<input type="hidden" id="calvew" name="calvew" value="<?= $vew_data->calvew; ?>">

		<div class="row"> 
			<div class="col-12 col-md-10 col-md-offset-1">
				<div style="padding-top: 10px; padding-left: 10px; padding-right: 10px;">
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

    <div id="fltpopup" class="hidden">  <!--popup de filtro-->
      <div class="container-fluid">
        <div class="row" style="padding-top: 10px; padding-left: 10px; padding-right: 10px;">
          <div class="col-md-6">
            <?php
              echo '<legend>'.$vew_lang->source.'</legend>';
              echo vew_boot($lv_col210, array("label"=>$vew_lang->type,	"input"=>gethtml("srcobjtyp", "objtyplst", 	$vew_data->srcobjtyp, $lv_default) ));
              echo vew_boot($lv_col210, array("label"=>$vew_lang->id,		"input"=>gethtml("srcobjcod", "doccmt1x20", $vew_data->srcobjcod, $lv_default) ));
              echo vew_boot($lv_col210, array("label"=>$vew_lang->name,	"input"=>gethtml("srcobjtxt", "doccmt1x50", $vew_data->srcobjtxt, $lv_default) ));
            ?>
          </div>
          <div class="col-md-6">
            <?php
              echo '<legend>'.$vew_lang->destination.'</legend>';
              echo vew_boot($lv_col210, array("label"=>$vew_lang->type,	"input"=>gethtml("dstobjtyp", "objtyplst", 	$vew_data->dstobjtyp, $lv_default) ));
              echo vew_boot($lv_col210, array("label"=>$vew_lang->id,		"input"=>gethtml("dstobjcod", "doccmt1x20", $vew_data->dstobjcod, $lv_default) ));
              echo vew_boot($lv_col210, array("label"=>$vew_lang->name,	"input"=>gethtml("dstobjtxt", "doccmt1x50", $vew_data->dstobjtxt, $lv_default) ));
            ?>
          </div>
				</div>
      </div>
      <script>
      	$("#<?= $lv_sec; ?> select").on("change",function(e){
          $(this).data("selected", $(this).prop("value"));
        });
      </script>
    </div>

	</form>
	<script>
    $("#<?= $lv_sec; ?> #btnflt").on("click",function(e){
      var lv_<?= $lv_sec; ?>_cloneddiv =  $("#<?= $lv_sec; ?> #fltpopup").clone(true).removeClass("hidden");
      var lv_<?= $lv_sec; ?>_cloneddivtemp = $("#<?= $lv_sec; ?> #fltpopup").clone(true);
      $("#<?= $lv_sec; ?> #fltpopup").empty();

      BootstrapDialog.show({
              title: "<?= $vew_lang->filter; ?>",
              message: $(lv_<?= $lv_sec; ?>_cloneddiv),
              type: BootstrapDialog.TYPE_PRIMARY,
              size: BootstrapDialog.SIZE_WIDE,
              closable: false,
        			onshown: function(){
                				$("#fltpopup #srcobjtyp").val($("#fltpopup #srcobjtyp").data("selected"));
                				$("#fltpopup #dstobjtyp").val($("#fltpopup #dstobjtyp").data("selected"));
              				},
              buttons: [{ label: "<?= $vew_lang->cancel ?>", cssClass: "btn-danger", action: function(dialog){
                            $("#<?= $lv_sec; ?> #fltpopup").replaceWith(lv_<?= $lv_sec; ?>_cloneddivtemp);
                						$("#<?= $lv_sec; ?> #srcobjtyp").val($(lv_<?= $lv_sec; ?>_cloneddivtemp).find("#srcobjtyp").data("selected"));
                            $("#<?= $lv_sec; ?> #dstobjtyp").val($(lv_<?= $lv_sec; ?>_cloneddivtemp).find("#dstobjtyp").data("selected"));
                						dialog.close();
                            <?= $lv_sec; ?>_calendar.refetchEvents();
              					} },
                        {	label: "<?= $vew_lang->accept ?>", cssClass: "btn-success",	action: function(dialog){
                						$("#<?= $lv_sec; ?> #fltpopup").append(dialog.getModalBody().find(".container-fluid"));
                						dialog.close();
                        		<?= $lv_sec; ?>_calendar.refetchEvents();
                        } }]
      });
    });


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
          events: function(info, callback, failureCallback) {
            var lv_pstdat = {
                              caldte: $("#<?= $lv_sec; ?> #caldte").prop("value"),
                              srcobjtyp: $("#<?= $lv_sec; ?> #srcobjtyp").prop("value"),
                              srcobjcod: $("#<?= $lv_sec; ?> #srcobjcod").prop("value"),
                              srcobjtxt: $("#<?= $lv_sec; ?> #srcobjtxt").prop("value"),
                              dstobjtyp: $("#<?= $lv_sec; ?> #dstobjtyp").prop("value"),
                              dstobjcod: $("#<?= $lv_sec; ?> #dstobjcod").prop("value"),
                              dstobjtxt: $("#<?= $lv_sec; ?> #dstobjtxt").prop("value"),
                              start: moment(info.start).format("YYYY-MM-DD"),
                              end: moment(info.end).format("YYYY-MM-DD")
														};
						tmssCallProcess("?prg=stkmovdoc&act=29",lv_pstdat,function(data){
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
						tmssLink("?prg=stkmovdoc&act=03&prm_mdlcod=STK&prm_prgcod=SIV&prm_objtyp=stk_siv&prm_stkmovdoccod="+info.event.id, [{target: "_new_section"}] );
          },
        });
        <?= $lv_sec; ?>_calendar.setOption("locale", "es");
        <?= $lv_sec; ?>_calendar.render();
        $("#<?= $lv_sec; ?> .fc-icon-calendar").replaceWith("<i class='fas fa-calendar-alt'></i>");
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
  <script>
    var gv_last_action="";

		// server response
    tmssLinkForm( $("#<?= $lv_sec; ?>_frm"), "<?= $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_last_action, "<?= $lv_title; ?>", "<b><?= $vew_data->matcod; ?></b>" ) ) {
				if ( gv_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    });

		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			if (lp_prm["action"]=="prn") {
				window.print();
			} else if (lp_prm["action"]=="28") {
        <?= $lv_sec; ?>_calendar.refetchEvents();
				<?= $lv_sec; ?>_calendar.render();
				toastr.info( "Calendario actualizado" );
			} else {

				gv_last_action = lp_prm["action"];
				var lv_action = (gv_last_action=="99"?"<?= ($vew_actcod=='02'?'02':'03'); ?>":gv_last_action);
				tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "" );
			}
		}

		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>
</section>
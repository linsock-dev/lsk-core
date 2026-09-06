<?php
	// url del formulario 
  $lv_lnk = '?prg=hltpln&prm_patcod='.$vew_data->patcod.'&prm_plnvew='.$vew_data->plnvew;

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = $vew_data->plnid; 

	// titulo 
	$lv_title = $vew_lang->planning;
	
	// modulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PLP';
			
	$vew_actcod = '02';
			
	// librería de estilos bootstrap 
	include_once('_library.frm');

	$lv_evlplndte = $vew_doc->getTagValue($vew_mdlprm->mdlatrval001, 'STS_EVL_PLN_DTE');

	// Botones de vista 
	$vew_tbl['new'] = array('per'=>false);
  $vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['modR'] = array('per'=>false);	
	$vew_tbl['canc'] = array('per'=>false);	
	$vew_tbl['sveL'] = array('per'=>false);
	$vew_tbl['sveR'] = array('per'=>false);
	$vew_tbl['del'] = array('per'=>false);
	$vew_tbl['calprv'] = array('pos'=>'L', 'per'=>true, 'ttl'=>'', 'id'=>'calprv', 'icn'=>'far fa-chevron-left', 'css'=>'btn navbar-btn tmssAlwaysEnabled tmss-navbar-btn', 'acc'=>$lv_sec.'_calendar.prev(); '.$lv_sec.'_refreshTitle();');
	$vew_tbl['calnxt'] = array('pos'=>'L', 'per'=>true, 'ttl'=>'', 'id'=>'calnxt', 'icn'=>'far fa-chevron-right', 'css'=>'btn navbar-btn tmssAlwaysEnabled tmss-navbar-btn', 'acc'=>$lv_sec.'_calendar.next(); '.$lv_sec.'_refreshTitle();');
	$vew_tbl['caltdy'] = array('pos'=>'L', 'per'=>true, 'ttl'=>$vew_lang->today, 'id'=>'caltdy', 'icn'=>'', 'css'=>'btn navbar-btn tmssAlwaysEnabled tmss-navbar-btn', 'acc'=>$lv_sec.'_calendar.today(); '.$lv_sec.'_refreshTitle();');
	$vew_tbl['flt'] = array('pos'=>'R', 'per'=>true, 'ttl'=>'', 'id'=>'btnflt', 'icn'=>'far fa-filter', 'css'=>'btn navbar-btn tmssAlwaysEnabled tmss-navbar-btn', 'acc'=>'');
	$vew_tbl['rfrsh'] = array('pos'=>'D', 'per'=>true, 'ttl'=>$vew_lang->refresh, 'id'=>'', 'icn'=>'fas fa-sync-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_calendar.refetchEvents();');	
	$vew_tbl['sp1'] = array('pos'=>'D', 'per'=>true, 'css'=>'divider');	
	$vew_tbl['vewday'] = array('pos'=>'D', 'per'=>true, 'ttl'=>$vew_lang->day, 'id'=>'', 'icn'=>'far fa-calendar-day', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_calendar.changeView(`timeGridDay`); '.$lv_sec.'_refreshTitle();');	
	$vew_tbl['vewwek'] = array('pos'=>'D', 'per'=>true, 'ttl'=>$vew_lang->week, 'id'=>'', 'icn'=>'far fa-calendar-week', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_calendar.changeView(`dayGridWeek`); '.$lv_sec.'_refreshTitle();');	
	$vew_tbl['vewmth'] = array('pos'=>'D', 'per'=>true, 'ttl'=>$vew_lang->month, 'id'=>'', 'icn'=>'far fa-calendar', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_calendar.changeView(`dayGridMonth`); '.$lv_sec.'_refreshTitle();');	
	$vew_tbl['vewlst'] = array('pos'=>'D', 'per'=>true, 'ttl'=>$vew_lang->list, 'id'=>'', 'icn'=>'fas fa-sync-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_calendar.changeView(`listWeek`); '.$lv_sec.'_refreshTitle();');	
	$vew_tbl['vewpat'] = array('pos'=>'D', 'per'=>true, 'ttl'=>$vew_lang->patient, 'id'=>'', 'icn'=>'far fa-user', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_changeView(`pat`);');	
	$vew_tbl['vewprs'] = array('pos'=>'D', 'per'=>true, 'ttl'=>$vew_lang->provider, 'id'=>'', 'icn'=>'far fa-user-doctor', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_changeView(`prs`);');	
	$vew_tbl['sp2'] = array('pos'=>'D', 'per'=>true, 'css'=>'divider');	
	$vew_tbl['prn']    = array('pos'=>'D', 'per'=>true, 'ttl'=>$vew_lang->print, 'id'=>'', 'icn'=>'far fa-print', 'css'=>'tmss-Opt', 'acc'=>'window.print();');
	$vew_tlb['clsR'] = array('per'=>false);
	$vew_tlb['clsL'] = array('per'=>false);
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
    <?= gethtml('view', 'hidden', 'pat'); ?>
		<?= gethtml('vewflt', 'hidden', ''); ?>
    <?= gethtml('vewfltdat','hidden',$vew_data->vewfldfltdef); ?>
		<div class="container-fluid" style="padding-top:10px;">
			<div class="text-center" style="text-transform:capitalize;" id="calttl"></div>
			<div id="calendar" class="tmss-cal-hght"></div> 
		</div>
	</form>
  <script>
    var <?= $lv_sec; ?>_calendar;
    var lv_<?= $lv_sec; ?>_evlplndte;
		$(function() {
      var lv_<?= $lv_sec; ?>_evlplndte = "<?= ($lv_evlplndte!=''?'X':''); ?>";
			tmssLoadScript("fullcalendar",function(){
        
        var <?= $lv_sec; ?>_cal = $("#<?= $lv_sec; ?> #calendar").get(0);
        <?= $lv_sec; ?>_calendar = new FullCalendar.Calendar(<?= $lv_sec; ?>_cal, {
          initialView: "dayGridMonth",
					headerToolbar: false,
          titleRangeSeparator:" - ",
					defaultRangeSeparator: " - ",
          buttonIcons: true, // show the prev/next text
					navLinks: true, // can click day/week names to navigate views
					editable: false,
					//eventStartEditable: false,
					//eventDurationEditable: false, 
          dayMaxEventRows: true, // for all non-TimeGrid views
					firstDay: 7,
          events: function(info, callback, failureCallback) { 
						var lv_pstdat={ hltplnstrdte: moment(info.start).subtract(1, 'day').format("YYYY-MM-DD"),
														hltplnenddte: moment(info.end).format("YYYY-MM-DD"),
                           	evlplndte: lv_<?= $lv_sec; ?>_evlplndte,
														fltqty: gv_<?= $lv_sec; ?>_flt.length,
														vewfldflt: (tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["fltstr"]==""?"":tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["fltstr"]), 
														vewmaxrec: (tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["maxrec"]==""?"100":tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["maxrec"]) 
													};
            tmssCallProcess("?prg=hltpln&act=18", lv_pstdat, function(data){
							var lv_dat = [];
          		var lv_str, lv_end;
							for(var i=0; i<data.length; i++){
                if(lv_<?= $lv_sec; ?>_evlplndte == "X" && data[i]["evlcod"]!="" && data[i]["evlcod"]!=undefined){
                  lv_str = data[i]["evldte"];
                  lv_end = lv_str;
                }else{
                  lv_str = data[i]["plninbdte"];
                  lv_end = data[i]["plnoutdte"];
                }
                lv_str = moment(lv_str.date);
                lv_end = moment(lv_end.date);
                
                if (lv_end.isBefore(lv_str)) {
                    // Ajustar la fecha de finalización para que sea el día siguiente
                    lv_end.add(1, 'day');
                }
                lv_dat.push({
                              title: ($("#<?= $lv_sec; ?> #view").val()=="pat"?data[i]["pattxt"]:data[i]["prstxt"]), //($lv_plnvew=='plnpat'?data[i]["prstxt"]:data[i]["pattxt"]),
                              start: lv_str.toISOString(),
                              end: lv_end.toISOString(),
                              backgroundColor: (data[i]["spcclr"] === "" ? "#FFFFFF" : data[i]["spcclr"]),
                              textColor: "black",
                              editable: (data[i]["hltplnctrdte"] === "" ? true : false),
                              plnid: data[i]["plnid"],
                              plndteid: data[i]["plndteid"],
                              allDay: false
                });
								/*lv_dat.push({
									title: ($("#<?= $lv_sec; ?> #view").val()=="pat"?data[i]["pattxt"]:data[i]["prstxt"]), //($lv_plnvew=='plnpat'?data[i]["prstxt"]:data[i]["pattxt"]),
									start: moment(data[i]["plninbdte"].date).toISOString(),
									end: moment(data[i]["plnoutdte"].date).toISOString(),
									backgroundColor: (data[i]["spcclr"]==""?"#FFFFFF":data[i]["spcclr"]),	// si la especialidad no tiene color asumo el blanco como fondo
									textColor: "black", //$this->color_inverse( (data[i]['spcclr']==''?'#FFFFFF':data[i]['spcclr']) ),
									editable: (data[i]["hltplnctrdte"]==""?true:false),	// la fecha se puede mover solo si no tiene control de prestaci n
									plnid: data[i]["plnid"],
									plndteid: data[i]["plndteid"],
									allDay: ( moment(data[i]["plninbdte"].date).format("HH:mm")=="00:00" && moment(data[i]["plnoutdte"].date).format("HH:mm")=="00:00"? true : false )
								});*/
							}
              callback(lv_dat);
              if(<?= $lv_sec; ?>_calendar!=undefined){
                <?= $lv_sec; ?>_calendar.render();
              }
						});
					},
          businessHours: {
						// days of week. an array of zero-based day of week integers (0=Sunday)
						dow: [ 1, 2, 3, 4, 5 ], // Monday - Friday
						start: "09:00", // a start time (09am in this example)
						end: "18:00", // an end time (6pm in this example) 
					},
					<?php if ( $vew_sec->hasPermission('HLT','PLN','01') ) { ?>
						navLinkWeekClick: function(weekStart, jsEvent) { 
							var lv_weekEnd = moment(weekStart).add(6,"days");
							<?= $lv_sec; ?>_proccessEvent( "01", weekStart.format("YYYYMMDDHHmm"), lv_weekEnd.format("YYYYMMDDHHmm") );
						},
						dateClick: function(info) {  <?= $lv_sec; ?>_proccessEvent( "01", moment(info.date).format("YYYYMMDDHHmm"), moment(info.date).format("YYYYMMDDHHmm") ); },
					<?php } ?>
          <?php if ( 1==2 && $vew_sec->hasPermission('HLT','PLN','02') ) { ?>
					eventResize: function(info) {
						BootstrapDialog.confirm({
							title: "Actualizar Planificaci&oacute;n", 
							message:"Desea actualizar la hora del evento de "+moment(info.event.start).format("HH:mm")+" a "+moment(info.event.end).format("HH:mm")+" ?", 
							type: BootstrapDialog.TYPE_WARNING, 
							callback: function(result){
									if(result){
										<?= $lv_sec; ?>_proccessEvent( "12", moment(info.event.start).format("YYYYMMDDHHmm"), moment(info.event.end).format("YYYYMMDDHHmm"), info.event );
									}else{
										revertFunc();
									}
								} 
						});
					},
					eventDrop: function(info) {
						BootstrapDialog.confirm({
							title: "Mover planificaci&oacute;n", 
							message:"Desea mover el evento a la fecha "+moment(info.event.start).format("DD-MM-YYYY"+(info.event.allDay==true?"":" HH:mm"))+" ?", 
							type: BootstrapDialog.TYPE_WARNING, 
							callback: function(result){
								if(result){
									<?= $lv_sec; ?>_proccessEvent( "12", moment(info.event.start).format("YYYYMMDDHHmm"), (info.event.end==null? moment(info.event.start).format("YYYYMMDDHHmm"):moment(info.event.end).format("YYYYMMDDHHmm")), info.event );
								} else {
									revertFunc();
								}
							} 
						});
					},
					<?php } ?>
          eventClick: function(info) { <?= $lv_sec; ?>_proccessEvent( "<?= ($vew_sec->hasPermission('HLT','PLN','02')?'02':'03'); ?>", "", "", info.event ); },
          moreLinkContent: function(arg) {
            return  arg.text.substr(0,arg.text.indexOf(" "))+" <?= $vew_lang->events; ?>";
          },
        });
        <?= $lv_sec; ?>_calendar.setOption("locale", "es");
        <?= $lv_sec; ?>_calendar.render();
        <?= $lv_sec; ?>_refreshTitle();
			});
		});    

		function <?= $lv_sec; ?>_proccessEvent( lp_act, lp_strdte, lp_enddte, lp_event ) {
			// datos del evento: los recupero del objeto Event (si viene)
			var lp_plnid    = lp_event ? lp_event.extendedProps.plnid    : '';
			var lp_plndteid = lp_event ? lp_event.extendedProps.plndteid : '';
			var lv_pstdat = {patcod:$("#<?= $lv_sec; ?> #patcod").val(),
                       prscod:$("#<?= $lv_sec; ?> #prscod").val(),
                       spccod:$("#<?= $lv_sec; ?> #spccod").val(),
                       delcod:$("#<?= $lv_sec; ?> #delcod").val(),
                       plnid: lp_plnid,
                       plndteid: lp_plndteid,
                       plnstrdte: lp_strdte,
                       plnenddte: lp_enddte,
											 onetimevar: "X"};
      tmssCallProcess( "?prg=hltpln&act="+lp_act, lv_pstdat, function(data){
				if( lp_act=="12" ) {
					toastr.success("Planificaci&oacute;n actualizada.","Planificacion");
				} else if ( lp_act=="01" || lp_act=="02" || lp_act=="03" ) {
          BootstrapDialog.show({
            title: "<?= $vew_lang->planning; ?>",
            message: $(data),
            size: BootstrapDialog.SIZE_WIDE,
            onhidden: function(dialog){
							// al cerrar el popup refresco los eventos. refetchEvents() respeta la vista actual (día/semana/mes) y la fecha.
							<?= $lv_sec; ?>_GridRefresh();
						}
          });
        }
			});
		}
		function <?= $lv_sec; ?>_refreshTitle(){
			$("#<?=$lv_sec;?> #calttl").text( 
				<?= $lv_sec; ?>_calendar.currentData.viewTitle.toLowerCase().replace(" de "," ") + " - " + ($("#<?= $lv_sec; ?> #view").val()=="pat"?"<?= $vew_lang->patients; ?>":"<?= $vew_lang->providers; ?>")
			); 
		}
		function <?= $lv_sec; ?>_GridRefresh(){ <?= $lv_sec; ?>_calendar.refetchEvents(); }
		function <?= $lv_sec; ?>_refresh(){ if(<?= $lv_sec; ?>_calendar==undefined){ return false; } <?= $lv_sec; ?>_calendar.refetchEvents();	
    }		
		function <?= $lv_sec; ?>_changeView(lp_vew){ $("#<?= $lv_sec; ?> #view").prop("value",lp_vew); <?= $lv_sec; ?>_calendar.refetchEvents(); <?= $lv_sec; ?>_refreshTitle(); }
  </script>
	<script>
    //FILTRO PERSONALIZADO
		var lv_<?= $lv_sec; ?>_grdfltcod = "<?= $vew_data->vewfltcod; ?>";
		var gv_<?= $lv_sec; ?>_flt=[{'fldttl': '<?= $vew_lang->place; ?>'     ,'fldcod': 'del.deltxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->patient; ?>'   ,'fldcod': 'p.pattxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->Financial; ?>'	,'fldcod': 'c.custxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																//{'fldttl': '<?= $vew_lang->role; ?>' ,'fldcod': 'r.prsrlstxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																//{'fldttl': '<?= $vew_lang->Responsible; ?>' ,'fldcod': 'p.patprsrlstxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->provider; ?>'  ,'fldcod': 'e.prstxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->specialty; ?>' ,'fldcod': 's.spctxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->Classification; ?>','fldcod': 'pdc.hltdisclstxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldcod': 'vewmaxrec','fldvalstr': '<?= ($vew_data->vewmaxrec!=''?$vew_data->vewmaxrec:'100') ?>'}];

		// filtro - boton
		$("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
			tmssFilterShowDialog(gv_<?= $lv_sec; ?>_flt,<?= $lv_sec; ?>_filtWeek,"HLT_PLN_CAL",lv_<?= $lv_sec; ?>_grdfltcod,"<?= $lv_sec; ?>");
		});
		
		//Filtros
		function <?= $lv_sec; ?>_filtWeek(lp_flt) {
			var lv_fltint;
			if( $("#<?= $lv_sec; ?> #btnflt .badge").length==0 ){
				$("<span class='badge'></span>").appendTo( $("#<?= $lv_sec; ?> #btnflt") );
			}			
			if(lp_flt!=null){
				lv_fltint = tmssFilterParseToInternal(lp_flt);
				gv_<?= $lv_sec; ?>_flt = lp_flt;
				$("#<?= $lv_sec; ?> #btnflt .badge").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
			} else {
				lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
			}
			if(lv_fltint!=$("#<?= $lv_sec; ?> #vewflt").prop("value")){
				$("#<?= $lv_sec; ?> #vewflt").prop("value",JSON.stringify(lv_fltint));
				<?= $lv_sec; ?>_refresh();
			}
		}
    $(function(){
      gv_<?= $lv_sec; ?>_flt=tmssFilterParseToExternal( gv_<?= $lv_sec; ?>_flt , $("#<?= $lv_sec; ?> #vewfltdat").val() );
			<?= $lv_sec; ?>_filtWeek(gv_<?= $lv_sec; ?>_flt);
		});
	</script>
  <script>
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {		
			if (lp_prm["action"]=="prn") { window.print(); return; }
      if(lp_prm["action"]=="13"){ <?= $lv_sec; ?>_calendar.refetchEvents(); return; }
			gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
			var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':($vew_actcod=='01'?'01':'03')); ?>":gv_<?= $lv_sec; ?>_last_action);
			tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "" );
		}
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
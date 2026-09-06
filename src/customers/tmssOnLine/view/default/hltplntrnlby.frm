<?php
	/* url del formulario */
  $lv_lnk = '?prg=hltplntrn&act=23';

	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = '';

	/* titulo */
	$lv_title = $vew_lang->turn;
	
	/* módulo y programa */
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PLT';
			
	$vew_actcod = '18';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');

	/* Botones de vista */
	$vew_dropdown = false;
	$vew_tbl['new']  = array('per'=>false);
  $vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['modR'] = array('per'=>false);	
	$vew_tbl['canc'] = array('per'=>false);	
	$vew_tbl['sveL'] = array('per'=>false);
	$vew_tbl['sveR'] = array('per'=>false);
	$vew_tbl['del']  = array('per'=>false);
	$vew_tbl['prnR'] = array('pos'=>'R', 'per'=>$vew_actcod!='01', 'ttl'=>'', 'id'=>'', 'icn'=>'fas fa-print', 'css'=>'btn navbar-btn tmss-navbar-btn tmss-desk-btn', 'acc'=>'window.print();');
	$vew_tbl['rfrshR'] = array('pos'=>'R', 'per'=>$vew_actcod!='01', 'ttl'=>'', 'id'=>'', 'icn'=>'fas fa-sync-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmss-desk-btn', 'acc'=>$lv_sec.'_refreshCalendar();');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?php
    	echo gethtml('tmss_actcod', 'hidden', '');
    	echo gethtml('calvew', 'hidden', $vew_data->calvew);
      echo gethtml('caldte', 'hidden', ($vew_data->caldte==''?date('Y-m-d'):$vew_data->caldte));
      echo gethtml('delcod', 'hidden', $vew_data->del->delcod);
      echo gethtml('spccod', 'hidden', $vew_data->spc->spccod);
      echo gethtml('prscod', 'hidden', $vew_data->prs->prscod);
      echo gethtml('patcod', 'hidden', $vew_data->pat->patcod);
    ?>
    <div class="row">
      <div class="col-md-4 hidden-print">
        <!--navbar-->
        <?php include('grldocfrmtlb.frm'); ?>
        <div class="container-fluid">
          <div class="tmss-tab-content">
            <!-- Sala de Espera -->
            <div class="card">
              <div class="card-header"><div class="card-title"><?= $vew_lang->lobby ?></div></div>
              <div class="card-body">
                <?php
                  echo vew_boot($lv_col39, array('label'=>$vew_lang->place, 	 
                                                 'input1'=>vew_boot( array('style'=>'search','readonly'=>false), 
                                                                     array('input'=>gethtml('deltxt', 'typeahead', $vew_data->del->deltxt, $lv_default) )) ));
                  echo vew_boot($lv_col39, array('label'=>$vew_lang->specialty,
                                                 'input1'=>vew_boot( array('style'=>'search','readonly'=>false), 
                                                                     array('input'=>gethtml('spctxt', 'typeahead', $vew_data->spc->spctxt, $lv_default) )) ));
                  echo vew_boot($lv_col39, array('label'=>$vew_lang->provider, 
                                                 'input1'=>vew_boot( array('style'=>'search','readonly'=>false), 
                                                                     array('input'=>gethtml('prstxt', 'typeahead', $vew_data->prs->prstxt, $lv_default) )) ));
                ?>
              </div>
            </div>
            <div id="btnstrn" class="row text-center tmssCalendarbtnstrn">
              <a href="#" class="btn btn-default tmssCalendarbtntrn" id="btntrnall" data-selected="X"></a>
              <a href="#" class="btn btn-warning tmssCalendarbtntrn" id="btntrnpnd" data-selected="" ></a>
              <a href="#" class="btn btn-success tmssCalendarbtntrn" id="btntrnatn" data-selected="" ></a>
            </div>
          </div>
        </div>
        <div class="container-fluid tmssCalendarDiv">
          <div>
            <div class="col-xs-2 tmssCalendarBtn" id="calbtnprvmth"><span class="fas fa-angle-double-left"></span>&nbsp;</div>
            <div class="col-xs-8"><center><strong id="calmthnme"></strong></center></div>
            <div class="col-xs-2 tmssCalendarBtn" id="calbtnnxtmth">&nbsp;<span class="fas fa-angle-double-right"></span></div>
          </div>
          <table class="table table-condensed tmssCalendar">
            <thead><tr><th>Lun</th><th>Mar</th><th>Mie</th><th>Jue</th><th>Vie</th><th>Sab</th><th>Dom</th></tr></thead>
            <tbody>
              <tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
              <tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
              <tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
              <tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
              <tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td></tr>						
              <tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td></tr>						
            </tbody>
          </table>
        </div>
      </div>
      <div class="col-md-8 tmssCalendarLstDiv">
        <div class="container-fluid">
          <div class="tmss-tab-content">
            <div>
              <div class="col-xs-2 tmssCalendarBtn" id="calbtnprvday"><span class="fas fa-angle-double-left"></span>&nbsp;</div>
              <div class="col-xs-8"><center><strong id="calmthnmelst"></strong></center></div>
              <div class="col-xs-2 tmssCalendarBtn" id="calbtnnxtday">&nbsp;<span class="fas fa-angle-double-right"></span></div>
            </div>	
            <div class="container-fluid" id="hltplntrnlst"></div>
          </div>
        </div>
      </div>
    </div>
  </form>
  <script>
    var lo_afterAssign = function() {
      <?= $lv_sec; ?>_refreshCalendar();
    };
    
		// LUGAR DE ATENCION
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"d.docsts":"A"}, "fldasg":{"delcod":"delcod", "deltxt":"deltxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #deltxt"), "hltdel", lo_get,{"afterAssign" : lo_afterAssign});
		
		// ESPECIALIDAD
    var lv_fldflt = ( $("#<?= $lv_sec; ?> #prscod").prop("value")!="" ? {"docsts":"A", "p.prscod":$("#<?= $lv_sec; ?> #prscod").prop("value")} : {"docsts":"A"} );
    var lv_mdl = ( $("#<?= $lv_sec; ?> #prscod").prop("value")!="" ? "hltprsspc" : "hltspc" );
    
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": lv_fldflt, "fldasg":{"spccod":"spccod", "spctxt":"spctxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #spctxt"), lv_mdl, lo_get,{"afterAssign" : lo_afterAssign});

		//PRESTADOR
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"p.docsts":"A", "ps.spccod": $("#<?= $lv_sec; ?> #spccod")}, "fldasg":{"prscod":"prscod", "prstxt":"prstxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #prstxt"), "hltspcprs", lo_get,{"afterAssign" : lo_afterAssign});
	</script>
	<script>
		$(function() {
			tmssLoadScript("toggle",function(){
				$("#<?= $lv_sec; ?> :checkbox").each( function() {
					$(this).bootstrapToggle({ onstyle: 'success', offstyle: 'default', on: 'Si', off: 'No', size: 'small' });
				});
			});
		});
	</script>
	<script>
		var lv_<?= $lv_sec; ?>_curdte;
		moment.defineLocale('es-ar', {
			parentLocale: 'en',
			months : 'Enero_Febrero_Marzo_Abril_Mayo_Junio_Julio_Agosto_Septiembre_Octubre_Noviembre_Diciembre'.split('_'),
			weekdays : 'Domingo_Lunes_Martes_Miercoles_Jueves_Viernes_Sabado'.split('_'),
			week : {
        dow : 1, // Monday is the first day of the week.
			}
		});
		moment.locale('es-ar');
		
		// al inicializar refresca el calendario
		$(function(){
			lv_<?= $lv_sec; ?>_curdte = moment();
			<?= $lv_sec; ?>_refreshCalendar();
		});

		
		// dia anterior
		$("#<?= $lv_sec; ?> #calbtnprvday").on("click",function(e){
			e.preventDefault();
			lv_<?= $lv_sec; ?>_curdte.add(-1, "day");
			<?= $lv_sec; ?>_refreshCalendar();
		});


		// dia siguiente
		$("#<?= $lv_sec; ?> #calbtnnxtday").on("click",function(e){
			e.preventDefault();
			lv_<?= $lv_sec; ?>_curdte.add(1, "day");
			<?= $lv_sec; ?>_refreshCalendar();
		});
		
		
		// mes anterior
		$("#<?= $lv_sec; ?> #calbtnprvmth").on("click",function(e){
			e.preventDefault();
			lv_<?= $lv_sec; ?>_curdte.add(-1, "month");
			<?= $lv_sec; ?>_refreshCalendar();
		});


		// mes siguiente
		$("#<?= $lv_sec; ?> #calbtnnxtmth").on("click",function(e){
			e.preventDefault();
			lv_<?= $lv_sec; ?>_curdte.add(1, "month");
			<?= $lv_sec; ?>_refreshCalendar();
		});
		
		// cambios en delegacion / especialidad / prestador
		$("#<?= $lv_sec; ?> #patcod").on("change",function(e){
      e.preventDefault();
			<?= $lv_sec; ?>_refreshCalendar();
		});
		

		// actualiza calendario
		function <?= $lv_sec; ?>_GridRefresh() {
			$("#<?= $lv_sec; ?> .tmssCalendarDayTdy").trigger("click");
		}

		$("#<?= $lv_sec; ?> #btntrnall").on("click",function(e){
			e.preventDefault();
			$(this).data("selected","X");
			$("#<?= $lv_sec; ?> #btntrnpnd").data("selected","");
			$("#<?= $lv_sec; ?> #btntrnatn").data("selected","");
			<?= $lv_sec; ?>_refreshCalendar();
		});

		$("#<?= $lv_sec; ?> #btntrnpnd").on("click",function(e){
			e.preventDefault();
			$(this).data("selected","X");
			$("#<?= $lv_sec; ?> #btntrnall").data("selected","");
			$("#<?= $lv_sec; ?> #btntrnatn").data("selected","");
			<?= $lv_sec; ?>_refreshCalendar();
		});

		$("#<?= $lv_sec; ?> #btntrnatn").on("click",function(e){
			e.preventDefault();
			$(this).data("selected","X");
			$("#<?= $lv_sec; ?> #btntrnall").data("selected","");
			$("#<?= $lv_sec; ?> #btntrnpnd").data("selected","");
			<?= $lv_sec; ?>_refreshCalendar();
		});
		
		
		// actualizar calendario
		function <?= $lv_sec; ?>_refreshCalendar() {
			
			// determino la fecha seleccionada, primer dia y ultimo dia del calendario
			//var lv_dur, lv_durmin, lv_frq, lv_qty, lv_ovr;
			var index;
			if (lv_<?= $lv_sec; ?>_curdte==null){ lv_<?= $lv_sec; ?>_curdte = moment(); }
			var lv_strdte = moment(lv_<?= $lv_sec; ?>_curdte).startOf("month");
			var lv_enddte = moment(lv_<?= $lv_sec; ?>_curdte).endOf("month");
			
			// obtengo datos del calendario
			var lv_pstdat=[	{name:"curdte",value: lv_<?= $lv_sec; ?>_curdte.format("DD/MM/Y") },
											{name:"strdte",value: lv_strdte.format("DD/MM/Y") },
											{name:"enddte",value: lv_enddte.format("DD/MM/Y") },
											{name:"delcod",value: $("#<?= $lv_sec; ?> #delcod").prop("value") },
											{name:"spccod",value: $("#<?= $lv_sec; ?> #spccod").prop("value") },
											{name:"prscod",value: $("#<?= $lv_sec; ?> #prscod").prop("value") },
											{name:"patcod",value: $("#<?= $lv_sec; ?> #patcod").prop("value") },
                      {name:"prgcod",value:"LBY"}
										];
			tmssCallProcess("?prg=hltplntrn&act=18",lv_pstdat,function(data){
				// status de días de atención (disponibles vs. programados)
				var lv_plnqty, lv_totqty;
				var lv_buffer = "";
				var lv_calrow = "";
				var lv_day_enable, lv_day_class, lv_day_tooltip, lv_found;
				
				// actualizo cada uno de los 42 días del calendario (7 dias x 6 semanas)
				var lv_calstr = moment(lv_strdte).startOf("week");
				for(var i=moment(lv_calstr); i.diff(lv_calstr,"days")<=42; i.add(1,"day")) {
					lv_plnqty = 0;
					lv_totqty = 0;
					lv_day_enabled = true;
					lv_day_class = ""
					lv_day_tooltip = "";
					
					// días de otros meses (los desabilito)
					if( i.format("MM/Y")!=lv_<?= $lv_sec; ?>_curdte.format("MM/Y") ) {
						lv_day_enabled = false;
						lv_day_class = "tmssCalendarDayDsb";
					}
					
					// día seleccionado, marco el borde
					if( lv_day_enabled==true ) {
						if( i.format("DD/MM/Y")==lv_<?= $lv_sec; ?>_curdte.format("DD/MM/Y") ) {
							lv_day_class = "tmssCalendarDayTdy";
						}
					}
					
					// feriados (deshabilito y agrego tooltip)
					if( lv_day_enabled==true ) {
						for(var x=0; x<data.hld.length; x++) {
							if( i.format("DD/MM/Y")==moment(data.hld[x]["hldcurdaycnv"],"D/M/Y").format("DD/MM/Y") ) {
								lv_day_enabled = false;
								lv_day_class += " tmssCalendarDayNoW";
								lv_day_tooltip += data.hld[x]["hldtxt"] + "\n";
							}
						}
					}
				
					// dias de no atención (deshabilito)
					if( lv_day_enabled==true ) {
						lv_found = false;
						for(var x=0; x<data.deltme.length; x++) {	
							if(data.deltme[x]["tmeday"]==i.format("d")) { lv_found=true; break; } 
						}
						if( lv_found==false ) {	
							lv_day_enabled = false; 
							lv_day_class = "tmssCalendarDayNoW"; 
						}
					}
					
					// determino la cantidad de turnos asignados en el día
					for(var x=0; x<data.pln.length; x++) {
						if( i.format("DD/MM/Y")==moment(data.pln[x]["plndte"].date).format("DD/MM/Y") ) {
							lv_plnqty += data.pln[x].plnqty;
						}
					}					
					
					// determino capacidad del días
					if( lv_day_enabled==true ) {

						// capacidad por prestador
						if(data.prstme.length>0 && $("#<?= $lv_sec; ?> #prscod").prop("value")!=""){
							for(var x=0; x<data.prstme.length; x++){
								if( data.prstme[x]["tmeday"]==i.format("d") ){
									lv_dur = moment.duration( moment(data.prstme[x]["tmeend"].date ).diff( moment(data.prstme[x]["tmestr"].date) ));
									lv_durmin = ( lv_dur.days()*24*60 ) + ( lv_dur.hours()*60) + lv_dur.minutes();
									lv_frq = data.prstme[x]["tmefrq"];
									lv_qty = data.prstme[x]["tmeqty"];
									lv_ovr = data.prstme[x]["tmeovr"];
									if( lv_durmin<=0 || lv_frq==0 || lv_qty==0 ) {
										lv_totqty = 0;
									} else {
										lv_totqty = ( ( lv_durmin / lv_frq ) * lv_qty );
									}
									lv_day_class += " tmssCalendarDaySel "+(lv_plnqty>0?" tmssCalendarDayPat ":"")+(lv_totqty==0 || lv_plnqty<lv_totqty?"tmssCalendarDayDsp":(lv_totqty!=0 && lv_plnqty>=lv_totqty && lv_plnqty<(lv_totqty+lv_ovr)?"tmssCalendarDayFul":(lv_totqty!=0 && lv_plnqty>=(lv_totqty+lv_ovr)?"tmssCalendarDayOvr":"")));
									lv_day_tooltip = lv_plnqty+" / "+lv_totqty;
									break;
								}
							}
						
						// capacidad por especialidad
						} else if( data.spctme.length>0 && $("#<?= $lv_sec; ?> #spccod").prop("value")!="") {
							for(var x=0; x<data.spctme.length; x++){
								if( data.spctme[x]["tmeday"]==i.format("d") ){
									lv_dur = moment.duration( moment(data.spctme[x]["tmeend"].date ).diff( moment(data.spctme[x]["tmestr"].date) ));
									lv_durmin = ( lv_dur.days()*24*60 ) + ( lv_dur.hours()*60) + lv_dur.minutes();
									lv_frq = data.spctme[x]["tmefrq"];
									lv_qty = data.spctme[x]["tmeqty"];
									lv_ovr = data.spctme[x]["tmeovr"];
									if( lv_durmin<=0 || lv_frq==0 || lv_qty==0 ) {
										lv_totqty = 0;
									} else {
										lv_totqty = ( ( lv_durmin / lv_frq ) * lv_qty );
									}
									lv_day_class += " tmssCalendarDaySel "+(lv_plnqty>0?" tmssCalendarDayPat ":"")+(lv_totqty==0 || lv_plnqty<lv_totqty?"tmssCalendarDayDsp":(lv_totqty!=0 && lv_plnqty>=lv_totqty && lv_plnqty<(lv_totqty+lv_ovr)?"tmssCalendarDayFul":(lv_totqty!=0 && lv_plnqty>=(lv_totqty+lv_ovr)?"tmssCalendarDayOvr":"")));
									lv_day_tooltip = lv_plnqty+" / "+lv_totqty;
									break;
								}
							}
						}
						
					}
					
					// armo las filas del calendario
					if( i.diff(lv_calstr,"days") % 7==0 && i.format("DD/MM/Y")!=lv_calstr.format("DD/MM/Y") ) {
						lv_buffer += "<tr>"+lv_calrow+"</tr>";
						lv_calrow = "";
					}
					lv_calrow += "<td class='"+(i.format("YMMDD")==moment().format("YMMDD")?"tmssCurrentDay ":"")+lv_day_class+"' title='"+lv_day_tooltip+"' data-day='"+i.format("DD")+"' data-month='"+i.format("MM")+"' data-year='"+i.format("Y")+"' "+(lv_day_enabled==false?"disabled='disabled'":"")+">"+i.format("D")+"</td>";
				}
				
				// actualizo calendario (render)
				$("#<?= $lv_sec; ?> .tmssCalendar tbody").html( lv_buffer );
				$("#<?= $lv_sec; ?> #calmthnme").text( lv_<?= $lv_sec; ?>_curdte.format("MMMM Y") );
				
				// actualizo grilla de turnos del dia
				//<?= $lv_sec; ?>_refreshList( data );
				
				// click en fecha (attach de evento)
				$("#<?= $lv_sec; ?> .tmssCalendarDaySel").on("click",function(e){
					e.preventDefault();
					lv_<?= $lv_sec; ?>_curdte = moment( $(this).data("day")+"/"+$(this).data("month")+"/"+$(this).data("year"), "D/M/Y" );
					$("#<?= $lv_sec; ?> .tmssCalendarDayTdy").removeClass("tmssCalendarDayTdy");
					$(this).addClass("tmssCalendarDayTdy");
					// obtengo turnos del día
					var lv_pstdat=[	{name:"curdte",value: lv_<?= $lv_sec; ?>_curdte.format("DD/MM/Y") },
													{name:"strdte",value: lv_strdte.format("DD/MM/Y") },
													{name:"enddte",value: lv_enddte.format("DD/MM/Y") },
													{name:"seldte",value: lv_<?= $lv_sec; ?>_curdte.format("DD/MM/Y") },
													{name:"delcod",value: $("#<?= $lv_sec; ?> #delcod").prop("value") },
													{name:"spccod",value: $("#<?= $lv_sec; ?> #spccod").prop("value") },
													{name:"prscod",value: $("#<?= $lv_sec; ?> #prscod").prop("value") },
													{name:"patcod",value: $("#<?= $lv_sec; ?> #patcod").prop("value") }
												];
					tmssCallProcess("?prg=hltplntrn&act=21",lv_pstdat,function(data){						
						// actualizo grilla de turnos del dia
						<?= $lv_sec; ?>_refreshList( data );
					});
				});

				// actualiza el dia seleccionado
				$("#<?= $lv_sec; ?> .tmssCalendarDayTdy").trigger("click");
				
			});
		}
		
		// actualiza la grilla del día seleccionado
		function <?= $lv_sec; ?>_refreshList( data ){
			var lv_minhrs=0, lv_maxhrs=0, lv_tmefrq, lv_tmeqty, lv_qtyqty, lv_tmeovr;
			var lv_patlst="", lv_patall=0, lv_patatn=0, lv_patpnd=0;
			$("#<?= $lv_sec; ?> #calmthnmelst").text( lv_<?= $lv_sec; ?>_curdte.format("dddd D, MMMM Y") );
			var lv_buffer = "";
			lv_buffer += "<table class='table table-bordered table-hover'>";
			lv_buffer += "<thead><th width='80'>Turno</th><th width='80'>Hs.Llegada</th><th width='80'>Espera</th><th>Paciente</th><th></th></thead>";
			lv_buffer += "<tbody>";
			
			// actualizo grilla del día (pacientes)
			if(data.prstme.length>0) {
				for(var x=0; x<data.prstme.length; x++){
					if( data.prstme[x]["tmeday"]==lv_<?= $lv_sec; ?>_curdte.format("d") ){
						lv_minhrs = moment(data.prstme[x]["tmestr"].date );
						lv_maxhrs = moment(data.prstme[x]["tmeend"].date );
						lv_tmefrq = data.prstme[x]["tmefrq"];
						lv_tmeqty = data.prstme[x]["tmeqty"];
						lv_tmeovr = data.prstme[x]["tmeovr"];
						break;
					}
				}
			} else if(data.spctme.length>0) { 
				for(var x=0; x<data.spctme.length; x++){
					if( data.spctme[x]["tmeday"]==lv_<?= $lv_sec; ?>_curdte.format("d") ){
						lv_minhrs = moment(data.spctme[x]["tmestr"].date );
						lv_maxhrs = moment(data.spctme[x]["tmeend"].date );
						lv_tmefrq = data.spctme[x]["tmefrq"];
						lv_tmeqty = data.spctme[x]["tmeqty"];
						lv_tmeovr = data.spctme[x]["tmeovr"];
						break;
					}
				}
			}
			
			if( lv_minhrs!=0 && lv_maxhrs!=0 ) {
				var lv_dur = moment.duration( lv_maxhrs.diff(lv_minhrs) );
				var lv_durmin = ( lv_dur.days()*24*60 ) + ( lv_dur.hours()*60) + lv_dur.minutes();
				var lv_min = moment(lv_minhrs);
				var lv_minnxt = moment(lv_minhrs);
				var lv_dayful, lv_trnsts, lv_trnrec, lv_trncal, lv_trnatn;
				var lv_now, lv_inb, lv_dif, lv_difdur;
				lv_tmefrq = (lv_tmefrq==0?lv_durmin:lv_tmefrq);
				for(var x=0; x<(lv_durmin/lv_tmefrq); x++){
					lv_minnxt.add(lv_tmefrq, "minutes");
					lv_patall++;
					lv_patlst="";
					for(var y=0; y<data.pln.length; y++){
						if( moment(data.pln[y]["plndte"].date,"Y-M-D H:m:s").format("DD/MM/Y")==lv_<?= $lv_sec; ?>_curdte.format("DD/MM/Y") ){
							var lv_plnmin = moment(data.pln[y]["plninbdte"].date,"Y-M-D H:m:s").hours()*60 + moment(data.pln[y]["plninbdte"].date,"Y-M-D H:m:s").minutes();
							if( lv_plnmin>=(lv_min.hours()*60+lv_min.minutes()) && lv_plnmin<(lv_minnxt.hours()*60+lv_minnxt.minutes()) ){
								lv_evlcod = (data.pln[y]["evlcod"]==null?"":data.pln[y]["evlcod"]);
								
								lv_trnsts = "";
								lv_trnrec = $("<div>"+data.pln[y]["plndteatr"]+"</div>").find("plntrnrec").text();
								lv_trncal = $("<div>"+data.pln[y]["plndteatr"]+"</div>").find("plntrncal").text();
								lv_trnatn = $("<div>"+data.pln[y]["plndteatr"]+"</div>").find("plntrnatn").text();
								if( lv_trnrec!="" && lv_evlcod=="") { lv_trnsts = "<span class='far fa-hospital push-right'></span>"; }
								if( lv_trncal!="" && lv_evlcod=="") { lv_trnsts = "<span class='fas fa-sign-in-alt push-right'></span>"; }
								if( lv_trnatn!="" && lv_evlcod=="") { lv_trnsts = "<span class='far fa-handshake push-right'></span>"; }

								lv_difdur = "";
								lv_inb = moment("X","H");	// genero una hora inválida
								if(lv_trnrec!=""){ lv_inb = moment(lv_trnrec,"H:m"); }
								if(lv_trnatn!=""){ lv_inb = moment(lv_trnatn,"H:m"); }
								if(lv_trnrec!=""){ lv_inb = moment(lv_trnrec,"H:m"); }
								if( lv_inb.isValid() ) {
									lv_now = moment(moment().format("H:m"),"H:m");
									lv_dif = moment.duration(lv_now.diff(lv_inb));
									lv_difdur = lv_dif.hours()+":"+(lv_dif.minutes()<10?"0":"")+lv_dif.minutes();
								}

								if( (lv_trnatn!="" || lv_evlcod!="") && ( $("#<?= $lv_sec; ?> #btntrnatn").data("selected")=="X" || $("#<?= $lv_sec; ?> #btntrnall").data("selected")=="X") ) {
									lv_buffer += "<tr class='"+(data.pln[y]["evlcod"]!=null?"tmssCalendarDayNoW":"")+"' data-plnid='"+data.pln[y]["plnid"]+"' data-plndteid='"+data.pln[y]["plndteid"]+"'><td>"+lv_min.format("HH:mm")+"</td><td>"+lv_trnrec+"</td><td>"+lv_difdur+"</td><td>"+data.pln[y]["pattxt"]+"</td><td>"+lv_trnsts+"</td></tr>";
								} else if ( lv_trnatn=="" && lv_evlcod=="" && ( $("#<?= $lv_sec; ?> #btntrnpnd").data("selected")=="X" || $("#<?= $lv_sec; ?> #btntrnall").data("selected")=="X" ) ) {
									lv_buffer += "<tr class='"+(data.pln[y]["evlcod"]!=null?"tmssCalendarDayNoW":"")+"' data-plnid='"+data.pln[y]["plnid"]+"' data-plndteid='"+data.pln[y]["plndteid"]+"'><td>"+lv_min.format("HH:mm")+"</td><td>"+lv_trnrec+"</td><td>"+lv_difdur+"</td><td>"+data.pln[y]["pattxt"]+"</td><td>"+lv_trnsts+"</td></tr>";
								}
								
								if( lv_trnatn!="" || lv_evlcod!="") {
									lv_patatn++;
								} else {
									lv_patpnd++;
								}
								lv_patlst="X";
							}
						}
					}
					
					// cargo el horario vacío
					if( lv_patlst=="" && $("#<?= $lv_sec; ?> #btntrnall").data("selected")=="X" ){
						lv_buffer += "<tr class='tmssCalendarDayNoW'><td>"+lv_min.format("HH:mm")+"</td><td></td><td></td><td></td><td></td></tr>";
					}
					lv_min.add(lv_tmefrq, "minutes");
				}
			}
			
			lv_buffer += "</tbody>";
			lv_buffer += "</table>";
			$("#<?= $lv_sec; ?> #hltplntrnlst").html( lv_buffer );			

			$("#<?= $lv_sec; ?> #btntrnall").html("<b>"+lv_patall+"</b><br>Turnos");
			$("#<?= $lv_sec; ?> #btntrnpnd").html("<b>"+lv_patpnd+"</b><br>Pendientes");
			$("#<?= $lv_sec; ?> #btntrnatn").html("<b>"+lv_patatn+"</b><br>Atendidos");
			
			// modificar turno (attach evento)
			$("#<?= $lv_sec; ?> #hltplntrnlst table tbody tr").not(".tmssCalendarDayNoW").on("click",function(e){
				e.preventDefault();
				var lv_pstdat=[ {name:"plnid",value:$(this).data("plnid")},
												{name:"plndteid",value:$(this).data("plndteid")}
											];
				tmssLink("?prg=hltplntrn&act=02", [{target: "_new_section", post_data: lv_pstdat}]);
			});			
		}
	</script>
	<script>
		// form submit ext
    function <?= $lv_sec; ?>_formeditext() {
    	tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod==''||$vew_actcod=='18'?'true':'false'); ?>);
		}	
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
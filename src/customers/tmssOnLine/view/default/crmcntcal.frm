<?php
	// url del formulario 
  $lv_lnk = '?prg=crmcnt&prm_plnvew=cal';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = $vew_data->plnid; 

	// titulo 
	$lv_title = $vew_lang->planning;
	
	// modulo y programa 
	$lv_mdlcod = 'CRM';
	$lv_prgcod = 'CNT';
			
	$vew_actcod = '02';
			
	// librería de estilos bootstrap 
	include_once('_library.frm');

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
	$vew_tbl['sp2'] = array('pos'=>'D', 'per'=>true, 'css'=>'divider');	
	$vew_tbl['prn']    = array('pos'=>'D', 'per'=>true, 'ttl'=>$vew_lang->print, 'id'=>'', 'icn'=>'far fa-print', 'css'=>'tmss-Opt', 'acc'=>'window.print();');
	$vew_tlb['clsR'] = array('per'=>false);
	$vew_tlb['clsL'] = array('per'=>false);
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
	<style>
		/* #<?= $lv_sec; ?> .fc .fc-daygrid-event { white-space: normal; } */
	</style>
	<script>
/*
 Copyright (C) Federico Zivolo 2019
 Distributed under the MIT License (license terms are at http://opensource.org/licenses/MIT).
 */(function(a,b){'object'==typeof exports&&'undefined'!=typeof module?module.exports=b(require('popper.js')):'function'==typeof define&&define.amd?define(['popper.js'],b):a.Tooltip=b(a.Popper)})(this,function(a){'use strict';function b(a){return a&&'[object Function]'==={}.toString.call(a)}a=a&&a.hasOwnProperty('default')?a['default']:a;var c=function(a,b){if(!(a instanceof b))throw new TypeError('Cannot call a class as a function')},d=function(){function a(a,b){for(var c,d=0;d<b.length;d++)c=b[d],c.enumerable=c.enumerable||!1,c.configurable=!0,'value'in c&&(c.writable=!0),Object.defineProperty(a,c.key,c)}return function(b,c,d){return c&&a(b.prototype,c),d&&a(b,d),b}}(),e=Object.assign||function(a){for(var b,c=1;c<arguments.length;c++)for(var d in b=arguments[c],b)Object.prototype.hasOwnProperty.call(b,d)&&(a[d]=b[d]);return a},f={container:!1,delay:0,html:!1,placement:'top',title:'',template:'<div class="tooltip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>',trigger:'hover focus',offset:0,arrowSelector:'.tooltip-arrow, .tooltip__arrow',innerSelector:'.tooltip-inner, .tooltip__inner'},g=function(){function g(a,b){c(this,g),h.call(this),b=e({},f,b),a.jquery&&(a=a[0]),this.reference=a,this.options=b;var d='string'==typeof b.trigger?b.trigger.split(' ').filter(function(a){return-1!==['click','hover','focus'].indexOf(a)}):[];this._isOpen=!1,this._popperOptions={},this._setEventListeners(a,d,b)}return d(g,[{key:'_create',value:function(a,b,c,d){var e=window.document.createElement('div');e.innerHTML=b.trim();var f=e.childNodes[0];f.id='tooltip_'+Math.random().toString(36).substr(2,10),f.setAttribute('aria-hidden','false');var g=e.querySelector(this.options.innerSelector);return this._addTitleContent(a,c,d,g),f}},{key:'_addTitleContent',value:function(a,c,d,e){1===c.nodeType||11===c.nodeType?d&&e.appendChild(c):b(c)?this._addTitleContent(a,c.call(a),d,e):d?e.innerHTML=c:e.textContent=c}},{key:'_show',value:function(b,c){if(this._isOpen&&!this._isOpening)return this;if(this._isOpen=!0,this._tooltipNode)return this._tooltipNode.style.visibility='visible',this._tooltipNode.setAttribute('aria-hidden','false'),this.popperInstance.update(),this;var d=b.getAttribute('title')||c.title;if(!d)return this;var f=this._create(b,c.template,d,c.html);b.setAttribute('aria-describedby',f.id);var g=this._findContainer(c.container,b);return this._append(f,g),this._popperOptions=e({},c.popperOptions,{placement:c.placement}),this._popperOptions.modifiers=e({},this._popperOptions.modifiers,{arrow:e({},this._popperOptions.modifiers&&this._popperOptions.modifiers.arrow,{element:c.arrowSelector}),offset:e({},this._popperOptions.modifiers&&this._popperOptions.modifiers.offset,{offset:c.offset||this._popperOptions.modifiers&&this._popperOptions.modifiers.offset&&this._popperOptions.modifiers.offset.offset||c.offset})}),c.boundariesElement&&(this._popperOptions.modifiers.preventOverflow={boundariesElement:c.boundariesElement}),this.popperInstance=new a(b,f,this._popperOptions),this._tooltipNode=f,this}},{key:'_hide',value:function(){return this._isOpen?(this._isOpen=!1,this._tooltipNode.style.visibility='hidden',this._tooltipNode.setAttribute('aria-hidden','true'),this):this}},{key:'_dispose',value:function(){var a=this;return this._events.forEach(function(b){var c=b.func,d=b.event;a.reference.removeEventListener(d,c)}),this._events=[],this._tooltipNode&&(this._hide(),this.popperInstance.destroy(),!this.popperInstance.options.removeOnDestroy&&(this._tooltipNode.parentNode.removeChild(this._tooltipNode),this._tooltipNode=null)),this}},{key:'_findContainer',value:function(a,b){return'string'==typeof a?a=window.document.querySelector(a):!1===a&&(a=b.parentNode),a}},{key:'_append',value:function(a,b){b.appendChild(a)}},{key:'_setEventListeners',value:function(a,b,c){var d=this,e=[],f=[];b.forEach(function(a){'hover'===a?(e.push('mouseenter'),f.push('mouseleave')):'focus'===a?(e.push('focus'),f.push('blur')):'click'===a?(e.push('click'),f.push('click')):void 0}),e.forEach(function(b){var e=function(b){!0===d._isOpening||(b.usedByTooltip=!0,d._scheduleShow(a,c.delay,c,b))};d._events.push({event:b,func:e}),a.addEventListener(b,e)}),f.forEach(function(b){var f=function(b){!0===b.usedByTooltip||d._scheduleHide(a,c.delay,c,b)};d._events.push({event:b,func:f}),a.addEventListener(b,f),'click'===b&&c.closeOnClickOutside&&document.addEventListener('mousedown',function(b){if(d._isOpening){var c=d.popperInstance.popper;a.contains(b.target)||c.contains(b.target)||f(b)}},!0)})}},{key:'_scheduleShow',value:function(a,b,c){var d=this;this._isOpening=!0;var e=b&&b.show||b||0;this._showTimeout=window.setTimeout(function(){return d._show(a,c)},e)}},{key:'_scheduleHide',value:function(a,b,c,d){var e=this;this._isOpening=!1;var f=b&&b.hide||b||0;window.clearTimeout(this._showTimeout),window.setTimeout(function(){if(!1!==e._isOpen&&document.body.contains(e._tooltipNode)){if('mouseleave'===d.type){var f=e._setTooltipNodeEvent(d,a,b,c);if(f)return}e._hide(a,c)}},f)}},{key:'_updateTitleContent',value:function(a){if('undefined'==typeof this._tooltipNode)return void('undefined'!=typeof this.options.title&&(this.options.title=a));var b=this._tooltipNode.querySelector(this.options.innerSelector);this._clearTitleContent(b,this.options.html,this.reference.getAttribute('title')||this.options.title),this._addTitleContent(this.reference,a,this.options.html,b),this.options.title=a,this.popperInstance.update()}},{key:'_clearTitleContent',value:function(a,b,c){1===c.nodeType||11===c.nodeType?b&&a.removeChild(c):b?a.innerHTML='':a.textContent=''}}]),g}(),h=function(){var a=this;this.show=function(){return a._show(a.reference,a.options)},this.hide=function(){return a._hide()},this.dispose=function(){return a._dispose()},this.toggle=function(){return a._isOpen?a.hide():a.show()},this.updateTitleContent=function(b){return a._updateTitleContent(b)},this._events=[],this._setTooltipNodeEvent=function(b,c,d,e){var f=b.relatedreference||b.toElement||b.relatedTarget;return!!a._tooltipNode.contains(f)&&(a._tooltipNode.addEventListener(b.type,function d(f){var g=f.relatedreference||f.toElement||f.relatedTarget;a._tooltipNode.removeEventListener(b.type,d),c.contains(g)||a._scheduleHide(c,e.delay,e,f)}),!0)}};return g});
//# sourceMappingURL=tooltip.min.js.map	
	</script>
  <form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
		<?= gethtml('vewflt', 'hidden', ''); ?>
		<?= gethtml('vewfltdef','hidden',$vew_data->vewfldfltdef); ?>
		<div class="container-fluid" style="padding-top:10px;">
			<div class="text-center" style="text-transform:capitalize;" id="calttl"></div>
			<div id="calendar" class="tmss-cal-hght"></div> 
		</div>
	</form>
  <script>
    var <?= $lv_sec; ?>_calendar;
		$(function() {
			tmssLoadScript("fullcalendar",function(){
        
        var <?= $lv_sec; ?>_cal = $("#<?= $lv_sec; ?> #calendar").get(0);
        <?= $lv_sec; ?>_calendar = new FullCalendar.Calendar(<?= $lv_sec; ?>_cal, {
          initialView: "dayGridMonth",
					headerToolbar: false,
          titleRangeSeparator:" - ",
					defaultRangeSeparator: " - ",
          buttonIcons: true, // show the prev/next text
					navLinks: true, // can click day/week names to navigate views
					editable: true,
					eventStartEditable: true,
					eventDurationEditable: false, 
          dayMaxEventRows: true, // for all non-TimeGrid views
					firstDay: 7,
          events: function(info, callback, failureCallback) {
						var lv_pstdat={ crmcntstrdte: moment(info.start).format("YYYY-MM-DD"),
														crmcntenddte: moment(info.end).format("YYYY-MM-DD"),
														fltqty: gv_<?= $lv_sec; ?>_flt.length,
														vewfldflt: (tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["fltstr"]==""?"":tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["fltstr"]), 
														vewmaxrec: (tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["maxrec"]==""?"100":tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt)["maxrec"]) 
													};
            tmssCallProcess("?prg=crmcnt&act=18", lv_pstdat, function(data){
							var lv_dat = [];
							for(var i=0; i<data.length; i++){
								// determino colores de tarjetas
								lv_clrsts = $("<div>"+data[i]["crmcntstsatr"]+"</div>").find("clr").text();
								lv_clrtyp = $("<div>"+data[i]["crmcnttypatr"]+"</div>").find("clr").text();
								lv_clrprt = $("<div>"+data[i]["crmcntprtatr"]+"</div>").find("clr").text();
								lv_clr = ( lv_clrprt=="" ? lv_clrtyp : lv_clrprt );
								lv_clrbck = (lv_clr==""?"--tmss-white":lv_clr);
								
								var lv_tme = $("<div>"+data[i]["crmcntatr"]+"</div>").find("TMEDUEDTE").text();
								lv_dat.push({
									title:data[i]["crmcntsrctxt"],
									start:moment(data[i]["crmcntduedte"].date).format("YYYY-MM-DD")+"T"+(lv_tme==""?"00:00":lv_tme)+":00", 
									end: moment(data[i]["crmcntduedte"].date).format("YYYY-MM-DD")+"T"+$(lv_tme==""?"00:00":lv_tme)+":00", 
									allDay: (lv_tme=="" ? true : false ),
									crmcntcod:data[i]["crmcntcod"].toString(),
									srcobjtxt:data[i]["crmcntsrctxt"],
									crmcnttxt:data[i]["crmcnttxt"],
									backgroundColor: getComputedStyle(document.body).getPropertyValue(lv_clrbck),
									borderColor: getComputedStyle(document.body).getPropertyValue(lv_clrbck),
									textColor: getComputedStyle(document.body).getPropertyValue(lv_clrbck+"-text")
								});
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
					/*
					eventRender: function(info) {
						var tooltip = new Tooltip(info.el, {
							title: info.event.extendedProps.srcobjtxt+"\n\r"+info.event.extendedProps.crmcnttxt,//you can give data for tooltip
							placement: 'top',
							trigger: 'hover',
							container: 'body'
						});
					},
					*/
					<?php if ( $vew_sec->hasPermission('CRM','CNT','01') ) { ?>
						navLinkWeekClick: function(weekStart, jsEvent){ <?= $lv_sec; ?>_proccessEvent( "01", 0, 0, weekStart.format("DD/MM/YYYY") ); },
						dateClick: function(info){ <?= $lv_sec; ?>_proccessEvent( "01", 0, moment(info.date).format("DD/MM/YYYY") ); },
					<?php } ?>
          <?php if ( 1==2 && $vew_sec->hasPermission('CRM','CNT','02') ) { ?>
					eventResize: function(info){	<?= $lv_sec; ?>_proccessEvent( "12", info.event.extendedProps.crmcntcod, moment(info.event.start).format("YYYYMMDDHHmm"), moment(info.event.end).format("YYYYMMDDHHmm") ); },
          <?php } ?>
          <?php if ( $vew_sec->hasPermission('CRM','CNT','02') ) { ?>
					eventDrop: function(info){ <?= $lv_sec; ?>_proccessEvent( "12", info.event.extendedProps.crmcntcod, moment(info.event.start).format( "YYYYMMDD"+(info.event.allDay==true?"":"HHmm") )); },
					<?php } ?>
          <?php if ( $vew_sec->hasPermission('CRM','CNT','03') ) { ?>
          eventClick: function(info){ <?= $lv_sec; ?>_proccessEvent( "03", info.event.extendedProps.crmcntcod, "" ); },
					<?php } ?>
          moreLinkContent: function(arg){ return  arg.text.substr(0,arg.text.indexOf(" "))+" <?= $vew_lang->events; ?>"; },
        });
        <?= $lv_sec; ?>_calendar.setOption("locale", "es");
        <?= $lv_sec; ?>_calendar.render();
        <?= $lv_sec; ?>_refreshTitle();
			});
		});    

		function <?= $lv_sec; ?>_proccessEvent( lp_act, lp_crmcntcod, lp_strdte ) {
			var lv_pstdat =[{name:"crmcntcod", value:lp_crmcntcod}, {name:"crmcntduedte", value: moment(lp_strdte,"YYYYMMDD"+(lp_strdte.length==8?"":"HHmm")).format("DD/MM/YYYY") }];
			if( lp_strdte.length==12 ){	lv_pstdat.push({name:"crmcntatrtmeduedte", value: moment(lp_strdte,"YYYYMMDDHHmm").format("HH:mm")}); }
			if( lp_act=="12"){
				tmssCallProcess("?prg=crmcnt&act="+lp_act,lv_pstdat,function(data){
					//info.revert();
				});
			} else {
				tmssLink("?prg=crmcnt&act="+lp_act, [{target: "_new_section", post_data: lv_pstdat }] );
			}
		}
		function <?= $lv_sec; ?>_refreshTitle(){ $("#<?=$lv_sec;?> #calttl").text( <?= $lv_sec; ?>_calendar.currentData.viewTitle.toLowerCase().replace(" de "," ") ); }
		function <?= $lv_sec; ?>_GridRefresh(){ <?= $lv_sec; ?>_calendar.refetchEvents(); }
		function <?= $lv_sec; ?>_refresh(){	<?= $lv_sec; ?>_calendar.refetchEvents();	}
  </script>
	<script>
    // FILTRO PERSONALIZADO
		var lv_<?= $lv_sec; ?>_grdfltcod = "<?= $vew_data->vewfltcod; ?>";
		var gv_<?= $lv_sec; ?>_flt=[{'fldttl': '<?= $vew_lang->id; ?>', 'fldcod': 'c.crmcntcod', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->customer; ?>', 'fldcod': 'a.adrnme001', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->title; ?>', 'fldcod': 'c.crmcnttxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->type; ?>', 'fldcod': 't.crmcnttyptxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->motive; ?>', 'fldcod': 'm.crmcntmtvtxtt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->status; ?>', 'fldcod': 's.crmcntststxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->responsible; ?>', 'fldcod': 'c.usrcod', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->priority; ?>', 'fldcod': 'p.crmcntprttxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''}];
		
		// filtro - boton
		$("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
			tmssFilterShowDialog( gv_<?= $lv_sec; ?>_flt, <?= $lv_sec; ?>_filtWeek, "CRM_CNT_CAL", lv_<?= $lv_sec; ?>_grdfltcod, "<?= $lv_sec; ?>");
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
			gv_<?= $lv_sec; ?>_flt=tmssFilterParseToExternal( gv_<?= $lv_sec; ?>_flt , $("#<?= $lv_sec; ?> #vewfltdef").val() );
			<?= $lv_sec; ?>_filtWeek( gv_<?= $lv_sec; ?>_flt );
			lv_fltint = tmssFilterParseToInternal( gv_<?= $lv_sec; ?>_flt );
			if( lv_fltint["fltqty"]==0 ){ <?= $lv_sec; ?>_refresh(); }
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
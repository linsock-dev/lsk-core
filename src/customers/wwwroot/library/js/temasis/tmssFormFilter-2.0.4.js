/* ***********************************************************************************

	Funciones para la la visualización del filtro de grillas.
	
	Change Log
	----------

	version: 2.0.3
		* new. botones para:
				seleccion y borrado de variantes grabadas
				grabado de variantes de seleccion
		* upd. botón limpiar a la izquierda del formulario con nueva estetica.
		* new. se agrega parametro opcional vewcod en funcion para mostrar filtro (si no se indica, las variantes no se pueden gestionar)
		* new. funcion tmssFilterSetFormData para actualizar la pantalla de filtro según el string.
		* new. function tmssFilterParseToExternal para convertir un string interno en un array
		* new. dialogo draggable.
		* fix. se arregla issue que no borraba el filtro cuando se limpiaba el campo manualmente.
	
  version: 2.0.1 v1
		* se encapsularon las rutinas:
				tmssFilterGetScreen
				tmssFilterGetScreenAdvanced	
				tmssFilterGetData
				tmssFilterAttachEvents
		* se agregó una nueva función para mostrar el filtro en línea
				tmssFilterShowInline
		* se agregó una nueva funcion para convertir el filtro de usuario a filtro interno
				tmssFilterParseToInternal
		* se renombró la función
				tmssShowFilterDialog => tmssFilterShowDialog
	
	version: 2.0.1
		* version inicial.
	
*********************************************************************************** */





/**
 * tmssShowFilterDialog
 * Muestra la pantalla de filtro en una ventana modal
 *
 * parámetros:
 *	- lp_flt: campos del filtro [fldttl=titulo, fldcod=campo, fldtyp=tipo filtro, fldflttyp=tipo campo, fldvalstr=valor desde, fldvalend=valor hasta]
 *	- lp_callback: funcion de respuesta
 *  - lp_vewcod: id de la vista (opcional)
 */
function tmssFilterShowDialog( lp_flt, lp_callback, lp_vewcod, lp_vewfltcod, lp_sec ) {	
	lp_vewcod = lp_vewcod || "";
	lp_vewfltcod = lp_vewfltcod || 0;
	var lv_buffer = tmssFilterGetScreen( lp_flt );

	var lv_bufferadv = tmssFilterGetScreenAdvanced();
		
		// muestro el cuadro de dialogo
		BootstrapDialog.show({
			title: "Filtro",
			message: $(lv_buffer),
			draggable: true,
			onshow: function(dialog) {
								var lv_frm = dialog.getModalBody();
								tmssFilterAttachEvents( lv_frm );
								if( lp_vewcod=="" ) {
									dialog.getModalFooter().find("#btnfltlst").addClass( "hidden" );
									dialog.getModalFooter().find("#btnfltsve").addClass( "hidden" );
								} else if(lp_vewfltcod!=0) {
									dialog.getModalFooter().find("#btnfltsve").data( "vewfltcod", lp_vewfltcod );
								}
							},
			buttons: [{ id: "btnfltlst", title: "Filtros", icon: "fas fa-folder-open", cssClass: "btn-default pull-left", action: function(dialog){
									var lv_pstdat = [{name: "vewcod", value: lp_vewcod}];
									tmssCallProcess("?prg=grlvew&act=getFilterList",lv_pstdat,function(data){
										BootstrapDialog.show({
											title: "Galeria de Filtros",
											message: $(data),
											onshown: function(dialog2){
												
												var lv_frm2 = dialog2.getModalBody();
												$(lv_frm2).find("#vewflttbl tbody tr").on("click",function(e){
													e.preventDefault();
													var lv_vewfltcod = $(this).data("vewfltcod");
													var lv_vewfltedt = $(this).data("vewfltedt");
													var lv_flttxt = $(this).find("textarea:first").text();
													var lv_frm = dialog.getModalBody();
													dialog.getModalContent().find("#btnfltclr").trigger("click");
													tmssFilterSetFormData( lv_frm, lv_flttxt );
													dialog.getModalContent().find("#btnfltsve").data("vewfltcod",lv_vewfltcod).prop("disabled",(lv_vewfltedt==1?"":"disabled"));
													dialog2.close();
												});
												
												$(lv_frm2).find("a[name='btndel']").on("click",function(e){
													e.preventDefault();
													var lv_vewfltcod = $(this).data("vewfltcod");
													BootstrapDialog.confirm({
														title: "Borrar Filtro",
														message: "Desea borrar el filtro seleccionado?",
														type: BootstrapDialog.TYPE_WARNING,
														btnCancelLabel: "No",
														btnOKLabel: "Si",
														btnOKClass: "btn-primary",
														callback: function(result) {
															if(result) {
																var lv_pstdat = [{name: "vewfltcod", value: lv_vewfltcod}];
																tmssCallProcess("?prg=grlvew&act=deleteFilter",lv_pstdat,function(data){
																	if( lv_vewfltcod==dialog.getModalContent().find("#btnfltsve").data("vewfltcod") ) {
																		dialog.getModalContent().find("#btnfltclr").trigger("click");
																		dialog.getModalContent().find("#btnfltapl").trigger("click");
																	}
																});
															}
														}
													});
												});

												
											},
											buttons:[{ label: "Cerrar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close();} }]
										});
									});
								}},
								{ id: "btnfltsve", title: "Grabar", icon: "far fa-save", cssClass: "btn-default pull-left", action: function(dialog){
									var lv_frm = dialog.getModalBody();
									var lv_fltarr = tmssFilterParseToInternal( tmssFilterGetData( lv_frm ) );
									if( lv_fltarr["fltqty"]==0 ) {
										toastr.warning("Debe indicar al menos un valor de filtro para grabar.");
										return false;
									}
									var lv_pstdat = [{name: "vewcod", value: lp_vewcod},{name: "vewfltcod", value: dialog.getModalContent().find("#btnfltsve").data("vewfltcod") }];
									tmssCallProcess("?prg=grlvew&act=getFilterForm",lv_pstdat,function(data){
										BootstrapDialog.show({
											title: "Grabar Filtro",
											message: $(data),
											buttons:[{ label: "Cancelar", cssClass: "btn-default", action: function(dialog2){ dialog2.close();} },
																{ label: "Grabar", cssClass: "btn-primary", action: function(dialog2){
																	var lv_frm2 = dialog2.getModalBody();
																	var lv_pstdat = $(lv_frm2).find("form:first").serializeArray();
																	lv_pstdat.push({ name: "vewcod", value: lp_vewcod });
																	lv_pstdat.push({ name: "vewfltdat", value: lv_fltarr["fltstr"] });
																	lv_pstdat.push({ name: "vewmaxrec", value: lv_fltarr["maxrec"] });
																	tmssCallProcess("?prg=grlvew&act=saveFilter",lv_pstdat,function(data2){
																		var lv_errtyp = $("<div>"+data+"</div>").find("errtyp").html();
																		var lv_errcod = $("<div>"+data+"</div>").find("errcod").html();
																		var lv_errtxt = $("<div>"+data+"</div>").find("errtxt").html();
																		var lv_vewfltcod = $("<div>"+data+"</div>").find("vewfltcod").html();
																		if( lv_errtyp=="E" ) {
																			toastr.warning( lv_errcod+": "+lv_errtxt );
																		} else {
																			dialog.getModalContent().find("#btnfltsve").data("vewfltcod",lv_vewfltcod);
																			dialog2.close();
																			toastr.success("Filtro grabado.");
																		}
																	});
																}}
															]
										});
									});
								}},
								{ id: "btnfltclr", title: "Limpiar", icon: "fas fa-eraser", cssClass: "btn-default pull-left", action: function(dialog){ 
									var lv_frm = dialog.getModalBody();
									$(lv_frm).find("textarea").each(function() { $(this).text(""); });
									$(lv_frm).find("input").each( function() {
										if ( $(this).prop("name")!="vewmaxrec" ) { 
											$(this).prop("value","").prop("disabled",false);
											$(this).prev().find("a:first").data("flttyp","LIKE").trigger("change"); 
										}
									});
									dialog.getModalContent().find("#btnfltsve").data("vewfltcod", "").prop("disabled");
									eval("window.lv_"+lp_sec+"_grdfltcod=0");
								}},
								{ label: "Cancelar", cssClass: "btn-default", action: function(dialog){ dialog.close();} },
								{ id: "btnfltapl", label: "Aplicar", cssClass: "btn-primary", action: function(dialog){ 
										var lv_frm = dialog.getModalBody();
										var lv_data = tmssFilterGetData( lv_frm );
										if(typeof lp_callback=="function"){ lp_callback( lv_data ); }
										dialog.close();
								}}
								]
		});
}





/**
 * tmssFilterSetFormData
 * Establecer los valores en la pantalla de filtro según un string interno
 
 * parámetros:
 * - lp_frm: formulario de filtro
 * - lp_data: string de filtro interno
*/
function tmssFilterSetFormData( lp_frm, lp_data ){
	var lv_ret = [];
	var lv_dat = lp_data.toLowerCase().split( "[~fltrow~]" );
	var lv_row, lv_fldcod, lv_flttyp, lv_fltlke, lv_fltstr, lv_fltend, lv_a;
	for( var i=1; i<lv_dat.length; i++ ) {
		lv_row = lv_dat[i].split( String.fromCharCode(9) );
		lv_fldcod = lv_row[0].toLowerCase();
		lv_flttyp = lv_row[1].toUpperCase();
		lv_fltlke = lv_row[2].toUpperCase();
		lv_fltstr = (lv_row.length>3?lv_row[3]:"").toUpperCase();
		lv_fltend = (lv_row.length>4?lv_row[4]:"").toUpperCase();
		lv_a = $(lp_frm).find("a[name='advfltbtn'][data-fldcod='"+lv_fldcod+"']");
		if( lv_a.length>0 ) {
			$(lv_a).data("flttyp",lv_flttyp);
			$(lv_a).parent().next().prop("value", lv_fltlke );
			$(lv_a).parent().next().next().text( lv_fltstr );
			$(lv_a).parent().next().next().next().text( lv_fltend );			
			if(lv_flttyp=="LIKE"){
				$(lv_a).removeClass("btn-primary").addClass("btn-default");
				$(lv_a).parent().next().prop("disabled",false);
			}	else {
				$(lv_a).addClass("btn-primary").removeClass("btn-default");
				$(lv_a).parent().next().prop("disabled",true);
			}
		}
	}
}





/**
 * tmssFilterParseToExternal
 * Establecer los valores del string interno de filtro en el array interno de filtro
 
 * parámetros:
 * - lp_array: array interno de filtro
 * - lp_data: string interno de filtro
*/
function tmssFilterParseToExternal( lp_array, lp_data ){
	var lv_ret = [];
	var lv_dat = lp_data.toLowerCase().split( "[~fltrow~]" );
	var lv_row, lv_fldcod, lv_flttyp, lv_fltlke, lv_fltstr, lv_fltend, lv_a;
	for( var x=1; x<lv_dat.length; x++ ) {
		lv_row = lv_dat[x].split( String.fromCharCode(9) );
		lv_fldcod = lv_row[0].toLowerCase();
		lv_flttyp = lv_row[1].toUpperCase();
		lv_fltlke = lv_row[2].toUpperCase();
		lv_fltstr = (lv_row.length>3?lv_row[3]:"").toUpperCase();
		lv_fltend = (lv_row.length>4?lv_row[4]:"").toUpperCase();
		for( var i=0; i<lp_array.length; i++ ){
			if( lp_array[i]["fldcod"]==lv_fldcod ) {

				// si es un campo tipo fecha, se convierte desde YYYY-MM-DD a DD/MM/YYYY
				if(lp_array[i]["fldtyp"]=="DATE"){
					lv_fltstr = (lv_fltstr.indexOf("-")==-1 ? "" : lv_fltstr.split("-")[2]+"/"+lv_fltstr.split("-")[1]+"/"+lv_fltstr.split("-")[0] );
					lv_fltend = (lv_fltend.indexOf("-")==-1 ? "" : lv_fltend.split("-")[2]+"/"+lv_fltend.split("-")[1]+"/"+lv_fltend.split("-")[0] );
				}

				lp_array[i]["flttyp"] = lv_flttyp;
				lp_array[i]["fldvalstr"] = (lv_fltlke!=""?lv_fltlke:lv_fltstr);
				lp_array[i]["fldvalend"] = lv_fltend;
			}
		}
	}
	return lp_array;
}





/**
 * tmssShowFilterInline
 * Muestra la pantalla de filtro en línea
 
 * parámetros:
 * - lp_div: div sobre el que se mostrará el filtro
 * - lp_flt: campos del filtro [fldttl=titulo, fldcod=campo, fldtyp=tipo filtro, fldflttyp=tipo campo, fldvalstr=valor desde, fldvalend=valor hasta]
*/
function tmssFilterShowInline( lp_div, lp_flt ) {	
	var lv_buffer = tmssFilterGetScreen( lp_flt );
	$(lp_div).html( lv_buffer );
  tmssFilterAttachEvents( lp_div );
}





/**
 * tmssFilterGetScreen
 * Devuelve la pantalla de filtro
 */
function tmssFilterGetScreen( lp_flt ) {

	var lv_fldcod; var lv_fldttl; var lv_flttyp; var lv_fldtyp; var lv_fldvalstr; var lv_fldvalend; var lv_vewmaxrec=100;
	var lv_chr39 = String.fromCharCode(39);
	var lv_buffer = "<div class='container-fluid'><form class='form-horizontal'>";
	
	// armo la pantalla de filtro
	for(var i=0; i<lp_flt.length; i++ ){
		lv_fldttl = lp_flt[i]["fldttl"];
		lv_fldcod = lp_flt[i]["fldcod"];
		lv_fldtyp = lp_flt[i]["fldtyp"];
		lv_fldtyp = (lv_fldtyp=="DATE" || lv_fldtyp=="NUMBER" || lv_fldtyp=="TEXT"?lv_fldtyp:"TEXT");
		lv_fldvalstr = lp_flt[i]["fldvalstr"];
		lv_fldvalend = lp_flt[i]["fldvalend"];
		lv_flttyp = (lp_flt[i]["flttyp"]==""?"LIKE":lp_flt[i]["flttyp"]);
		if(lv_fldcod=="vewmaxrec") {
			lv_vewmaxrec = lv_fldvalstr;
		} else {
			lv_buffer += "<div class='form-group tmss-form-group'>"
										+"<label class='control-label col-xs-3'>"+lv_fldttl+"</label>"
										+"<div class='col-xs-9'>"

										+(lv_fldtyp=="DATE"?
												"<div class='input-group'>"
													+"<span class='input-group-btn'>"
														+"<a href='#' name='advfltbtn' class='btn btn-default' data-fldcod='"+lv_fldcod+"' data-fldttl='"+lv_fldttl+"' data-fldtyp='"+lv_fldtyp+"' data-flttyp='"+lv_flttyp+"'><span class='fas fa-caret-right'></span></a>"
													+"</span>"
													+"<input type='TEXT' class='form-control input-sm' maxlength='10' onblur='formatdate(this);' data-date-format='dd/mm/yyyy' data-date-autoclose='true' data-date-today-highlight='true' data-date-today-btn='true' data-date-show-on-focus='false' data-date-language='es' data-date-enable-on-readonly='false' data-date-clear-btn='true' data-provide='datepicker' data-date-week-start='0' value=''>"
													+"<textarea class='hidden'>"+lv_fldvalstr+"</textarea>"
													+"<textarea class='hidden'>"+lv_fldvalend+"</textarea>"
													+"<span class='input-group-btn'>"
														+"<a href='#' name='dtecalbtn' class='btn btn-default'><i class='fas fa-calendar-alt'></i></a>"
													+"</span>"
												+"</div>"
											:
												"<div class='input-group'>"
													+"<span class='input-group-btn'>"
														+"<a href='#' name='advfltbtn' class='btn btn-default' data-fldcod='"+lv_fldcod+"' data-fldttl='"+lv_fldttl+"' data-fldtyp='"+lv_fldtyp+"' data-flttyp='"+lv_flttyp+"'><span class='fas fa-caret-right'></span></a>"
													+"</span>"
													+"<input type='"+lv_fldtyp+"' class='form-control input-sm' value='"+(lv_flttyp=="LIKE"?lv_fldvalstr:"")+"'>"
													+"<textarea class='hidden'>"+lv_fldvalstr+"</textarea>"
													+"<textarea class='hidden'>"+lv_fldvalend+"</textarea>"
												+"</div>"
											)
											
										+"</div>"
									+"</div>";
		}
	}
	
	lv_buffer += "<div class='form-group'>"
								+"<label for='vewmaxrec' class='col-xs-3 control-label'>Registros Max.</label>"
								+"<div class='col-xs-9'><input type='NUMBER' class='form-control input-sm' id='vewmaxrec' name='vewmaxrec' value='"+(lv_vewmaxrec==""?"100":lv_vewmaxrec)+"' min='1' max='9999' step='1'></div>"
							+"</div>";
	lv_buffer += "</form></div>";
	
	return lv_buffer;
	
}





/**
 * tmssFilterGetScreenAdvanced
 * Devuelve la pantalla de filtro avanzada
 */
function tmssFilterGetScreenAdvanced() {
	
	// armo la pantalla de filtro avanzado
	var lv_bufferadv = "<div class='container-fluid'>"
											+"<div class='form-group'>"
											+"<label for='fldtyp' class='col-xs-4 control-label'>Tipo</label>"
											+"<div class='col-xs-8'>"
												+"<select class='form-control' id='flttyp'>"
												+"<option value='LIKE'>QUE CONTENGA</option>"
												+"<option value='=' >IGUAL</option>"
												+"<option value='>' >MAYOR</option>"
												+"<option value='>='>MAYOR O IGUAL</option>"
												+"<option value='<' >MENOR</option>"
												+"<option value='<='>MENOR O IGUAL</option>"
												+"<option value='<>'>DISTINTO</option>"
												+"<option value='IN'>EN LA LISTA</option>"
												+"<option value='NI'>TODOS MENOS</option>"
												+"<option value='BT'>ENTRE</option>"
												+"<option value='NB'>NO ENTRE</option>"
												+"<option value='EE'>VACIO</option>"
												+"<option value='NE'>NO VACIO</option>"
												+"<option value='SW'>COMIENZA CON</option>"
												+"<option value='EW'>TERMINA CON</option>"
												+"</select>"
											+"</div>"
										+"</div>"
										+"<div class='form-group' id='divstr'>"
											+"<label for='fldstr' class='col-xs-4 control-label'>Valor</label>"
											+"<div class='col-xs-8'><textarea class='form-control' id='fldstr' rows='1'></textarea></div>"
										+"</div>"
										+"<div class='form-group' id='divend' class='hidden'>"
											+"<label for='fldend' class='col-xs-4 control-label'>Y</label>"
											+"<div class='col-xs-8'><textarea class='form-control' id='fldend' rows='1'></textarea></div>"
										+"</div>"
										+"</div>";
	
	return lv_bufferadv;

}





/**
 * tmssFilterGetData
 * Devuelve los valores del filtro como array
 *
 * parámetros:
 * - formulario de filtro
 */
function tmssFilterGetData( lp_frm ) {
	var lv_str; var lv_end;
	var lv_data = [];
	$(lp_frm).find("a[name='advfltbtn']").each(function(){
		if( $(this).parent().next().prop("disabled") ) {
			lv_str = ($(this).parent().next().prop("value")!=""?$(this).parent().next().prop("value"):$(this).parent().next().next().text());
			lv_end = ($(this).parent().next().prop("value")!=""?"":$(this).parent().next().next().next().text());
		} else {
			lv_str = $(this).parent().next().prop("value");
			lv_end = "";
		}
		lv_data.push( {fldttl:$(this).data("fldttl"), fldcod:$(this).data("fldcod"), flttyp:$(this).data("flttyp"), fldtyp:$(this).data("fldtyp"), fldvalstr: lv_str, fldvalend: lv_end} );
	});
	lv_data.push( {fldttl:"", fldcod:"vewmaxrec", flttyp:"=", fldtyp:"NUMBER", fldvalstr:$(lp_frm).find("#vewmaxrec").prop("value"), fldvalend:""} );
	return lv_data;
}





/**
 * tmssFilterAttachEvents
 * Agrega los eventos a los botones y campos del formulario de filtro
 *
 * parámetros:
 * - div con el formulario de filtros
 */
function tmssFilterAttachEvents( lp_div ) {
	
	// cambio en algun atributo del filtro
	$(lp_div).find("a[name='advfltbtn']").on("change",function(){
		if($(this).data("flttyp")=="LIKE"){
			$(this).removeClass("btn-primary").addClass("btn-default");
			$(this).parent().next().prop("value", $(this).parent().next().next().text() ).prop("disabled",false);
		}	else {
			$(this).addClass("btn-primary").removeClass("btn-default");
			$(this).parent().next().prop("value", "").prop("disabled",true);
		}
	});
	
	// click - boton calendario
	$(lp_div).find("a[name='dtecalbtn']").on("click",function(e){
		$(this).parent().prev().prev().prev().datepicker("show");
		e.preventDefault();
		e.stopPropagation();
	});
		
	// click - boton filtro avanzado
	$(lp_div).find("a[name='advfltbtn']").on("click",function(e){
		var lv_fld = $(this); 
		var lv_fldttl = $(this).data("fldttl");
		var lv_fldcod = $(this).data("fldcod");
		var lv_flttyp = $(this).data("flttyp");
		var lv_fldstr = ( lv_flttyp=="LIKE" ? $(this).parent().next().prop("value") : $(this).parent().next().next().text() );
		var lv_fldend = $(this).parent().next().next().next().text();
		var lv_bufferadv = tmssFilterGetScreenAdvanced();
		BootstrapDialog.show({
			title: "Filtro Avanzado ["+lv_fldttl+"]",
			message: $(lv_bufferadv),
			onshow: function(dialog) {
									var lv_frmadv = dialog.getModalBody();
									$(lv_frmadv).find("#flttyp").on("change",function(e){
										switch ( $(this).val() ) {
											case "IN": case "NI":
												$(lv_frmadv).find("#fldstr").attr("rows","5");
												$(lv_frmadv).find("#divstr").removeClass("hidden");
												$(lv_frmadv).find("#divend").addClass("hidden");
												break;
											case "BT": case "NB":
												$(lv_frmadv).find("#fldstr").attr("rows","1");
												$(lv_frmadv).find("#divstr").removeClass("hidden");
												$(lv_frmadv).find("#divend").removeClass("hidden");
												break;
											case "EE": case "NE":
												$(lv_frmadv).find("#divstr").addClass("hidden");
												$(lv_frmadv).find("#divend").addClass("hidden");
												break;
											default:
												$(lv_frmadv).find("#fldstr").attr("rows","1");
												$(lv_frmadv).find("#fldend").attr("rows","1");
												$(lv_frmadv).find("#divstr").removeClass("hidden");
												$(lv_frmadv).find("#divend").addClass("hidden");
												break;
											}
									});
									$(lv_frmadv).find("#flttyp option[value='"+lv_flttyp+"']").prop("selected",true).trigger("change");
									$(lv_frmadv).find("#fldstr").prop("value",lv_fldstr);
									$(lv_frmadv).find("#fldend").prop("value",lv_fldend);
								},
			buttons: [{ label: "Aplicar", cssClass: "btn-primary", 
									action: function(dialogItself){
														var lv_frmadv = dialogItself.getModalBody();
														var lv_flttypadv = $(lv_frmadv).find("#flttyp").prop("value");
														var lv_fldstr = $(lv_frmadv).find("#fldstr").prop("value");
														var lv_fldend = $(lv_frmadv).find("#fldend").prop("value");
														
														var lv_str; var lv_end;
														
														// validaciones rango de FECHA
														if( $(lv_fld).data("fldtyp")=="DATE" && lv_flttypadv!="IN" && lv_flttypadv!="NI" && lv_flttypadv!="EE" && lv_flttypadv!="NE" && lv_flttypadv!="SW" && lv_flttypadv!="EW" ){
															lv_str = moment(lv_fldstr,"DD/MM/YYYY",true);
															if(!lv_str.isValid()){ toastr.warning("Formato de fecha desde inválido."); $(lv_frmadv).find("#fldstr").focus(); return false; }
														}
														if( $(lv_fld).data("fldtyp")=="DATE" && (lv_flttypadv=="BT" || lv_flttypadv=="NB") ){
															lv_end = moment(lv_fldend,"DD/MM/YYYY",true);
															if(!lv_end.isValid()){ toastr.warning("Formato de fecha hasta inválido."); $(lv_frmadv).find("#fldend").focus(); return false; }
														}
														
														// validaciones rango de NUMERO
														if( $(lv_fld).data("fldtyp")=="NUMBER" && lv_flttypadv!="IN" && lv_flttypadv!="NI" && lv_flttypadv!="EE" && lv_flttypadv!="NE" && lv_flttypadv!="SW" && lv_flttypadv!="EW" ){
															if(!$.isNumeric(lv_fldstr)){ toastr.warning("Formato de número desde inválido."); $(lv_frmadv).find("#fldstr").focus(); return false; }
														}
														if( $(lv_fld).data("fldtyp")=="NUMBER" && (lv_flttypadv=="BT" || lv_flttypadv=="NB") ){
															lv_end = moment(lv_fldend,"DD/MM/YYYY",true);
															if(!$.isNumeric(lv_fldend)){ toastr.warning("Formato de número hasta inválido."); $(lv_frmadv).find("#fldend").focus(); return false; }
														}
														
														$(lv_fld).parent().next().next().text(lv_fldstr);
														$(lv_fld).parent().next().next().next().text(lv_fldend);
														$(lv_fld).data("flttyp", lv_flttypadv).trigger("change");
														dialogItself.close();
													}
								},
								{ label: "Cancelar", cssClass: "btn-default", 
									action: function(dialogItself){
														dialogItself.close(); 
													}
								}]
		});
		
		e.preventDefault();
		e.stopPropagation();
	});
		
	// inicializo todos los filtros
	$(lp_div).find("a[name='advfltbtn']").trigger("change");
	
}



/**
 * tmssFilterParseToInternal
 * Convierte un array de filtros en un string interno y devuelve además la cantidad de filtros aplicados
 * return Array( 'fltstr' , 'fltqty', 'maxrec' )
 *
 * parámetros:
 * - array de datos del filtro
 */
function tmssFilterParseToInternal( lp_data ) {
	var lv_ret = {fltstr:"", fltqty: "", maxrec: ""};
	var lv_cnt = 0;
	var lv_flt = "";
	var lv_typ; var lv_str; var lv_end;
	for(var i=0; i<lp_data.length; i++) {
		lv_flttyp = lp_data[i]["flttyp"];
		lv_fltstr = lp_data[i]["fldvalstr"];
		lv_fltend = lp_data[i]["fldvalend"];
		if(lp_data[i]["fldcod"]!="vewmaxrec"){
			//if( lv_fltstr!="" ) {																						// DEL #CRM-177
			if( lv_fltstr!="" || (lv_flttyp=="NE" || lv_flttyp=="EE") ) {			// ADD #CRM-177
				// convierto las fechas para el filtro
				if (lp_data[i]["fldtyp"]=="DATE"){
					if(lv_flttyp=="LIKE"){lv_flttyp="=";}
					lv_fltstr = (lv_fltstr.indexOf("/")==-1 ? "" : moment(lv_fltstr,"DD/MM/YYYY",true).format("YYYY-MM-DD") );
					lv_fltend = (lv_fltend.indexOf("/")==-1 ? "" : moment(lv_fltend,"DD/MM/YYYY",true).format("YYYY-MM-DD") );
				}
				lv_cnt++; 
				lv_flt += "[~fltrow~]" + lp_data[i]["fldcod"] + String.fromCharCode(9) + lv_flttyp
																											+ String.fromCharCode(9) + (lv_flttyp=="LIKE"?lv_fltstr:"") 
																											+ String.fromCharCode(9) + (lv_flttyp!="LIKE"?lv_fltstr:"") 
																											+ String.fromCharCode(9) + (lv_flttyp!="LIKE"?lv_fltend:"")
																											+ String.fromCharCode(9);
			}
		} else {
			lv_ret['maxrec'] = lp_data[i]["fldvalstr"];
		}
	};
	lv_ret['fltstr'] = lv_flt;
	lv_ret['fltqty'] = lv_cnt;
	return lv_ret;	
}
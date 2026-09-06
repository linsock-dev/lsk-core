/* *********************************************************************************** 
	
	Funciones para la gestion personalizada de funciones en formularios de Temasis.
	
	Change Log
	----------
  	2.4.0
      * tmssTypeahead: se mandan parámetros adicionales al post del popup. En caso de typeahead, estos datos se mandan por parámetros get.
    2.3.9
      * ADD. se agrega parametro de respuesta errjva en tmssBackMessageProcessing para procesar javascript en respuesta de mensajes con error
      * Se agregó una configuración para elegir qué headers devolver al callback de tmssCallProcessBlob
  	2.3.8
    	* ADD. Se agrega la carga de recursos y la función tmssGetUrl, tmssSetUrl.
      * FIX. Se corrige cómo muestra otra tab tmssTabCls.
		2.3.7
			* FIX. se cargan los typeahead luego de cargar la definicion.
    2.3.6
    	* ADD. todas las funciones del tipo tmssCall, con llamado ajax, mandan headers usrcod y usrtkn
		2.3.5
			* ADD. tmssCallProcessBlob
		2.3.4
			* ADD. se ejecutan eventos CHANGE al asignar valores de typeahead o borrar el texto del campo
		2.3.3
			* FIX. se corrige asignacion de valores cuando se recibe data.data o data. solamente
		2.3.2
			* FIX. se corrige la asignacion de valores en un typeahead cuando se utilizan objetos jquery
  	2.3.1
    	* definiciones de typeahead obtenidas desde base de datos al cargar .js
    2.3.0
			* nueva definición para tmssTypeahead: grlprccndcat / grlprccndacc  
			* modificación de vista de: fintaxtyp 
  	2.2.9
			* nueva definición para tmssTypeahead: cnstsk
    2.2.8
			* nueva definición para tmssTypeahead: cnsbudmat
			* nuevas funciones para colores: tmssColorGetRandomMaterialDesign / tmssColorGetRandom / tmssHex2Rgba
			* nuevas funciones para clipboard: tmssCopyToClipboard / tmssPasteFromClipboard
			* nuevas funciones varias: tmssJsonGetRandomProperty
    2.2.4
			* nueva definición para tmssTypeahead: tsrcsh / sptact
    2.2.3
			* nueva definición para tmssTypeahead: spttrf / sysdocfrm
    2.2.2
			* nueva definición para tmssTypeahead: crmcntmtv
		2.2.1
			* nueva definición para tmssTypeahead: sysappapi / finacc / fintaxtyp / fintaxind / stkmatcls
*********************************************************************************** */

// -------------------------------------------
//
//				T Y P E A H E A D
//
// -------------------------------------------



// TYPEAHEAD. Inicializacion
// cargo todas las definiciones de los typeahead
// (con esto se evita que haya múltiples llamadas a base de datos)
var gv_tmssTypAhdDef = [];
var gv_tmssTypAhdDef_load = false;
var gv_tmssTypAhdDef_queue = [];

var gv_tmssResources = [];
var lv_loadResources;

$(function(){
	tmssCallProcessNoBackdropErr("?prg=sysappprgvew&act=getTypeaheadDefinitions",[],function(data){		
		// inicializo
		gv_tmssTypAhdDef = [];
		// cargo definiciones
		for( var i=0; i<data.length; i++ ){
			gv_tmssTypAhdDef[ data[i].typcod ]={url: data[i].typprg, 
																					vew: data[i].vewcod,
																					prm: [],
																					ttl: data[i].vewttl,
																					txt: data[i].typtxt};
			gv_tmssTypAhdDef[ data[i].typcod ].prm["prm_"+data[i].typtxt] = "";
		}
		gv_tmssTypAhdDef_load = true;
		for(var i=0; i<gv_tmssTypAhdDef_queue.length; i++){
			tmssTypeahead(gv_tmssTypAhdDef_queue[i].obj, gv_tmssTypAhdDef_queue[i].def, gv_tmssTypAhdDef_queue[i].data, gv_tmssTypAhdDef_queue[i].callback);
		}
		gv_tmssTypAhdDef_queue = [];
	},function(dataerr){
		toastr.warning("No se pudieron obtener las definiciones de typeahead. Consulte con el administrador del sistema.");
	});
  
	lv_loadResources =
    $.ajax({url:"?prg=sysappapi&act=getApis",method:"POST", headers: getHeaders()}).done(function(data){ 
      // intento convertir a JSON
      try{ data = JSON.parse(data); } catch (error) { }
      // interpreo respuesta tipo string
      if ( (data.errtyp==undefined?"":data.errtyp)=="E" ) {
        toastr.warning(data.errcod+": "+data.errtxt);
      } else {
        for(let i=0; i<data.length; i++){
          gv_tmssResources[ data[i].sysappapiurl ] = data[i].sysappapicodext;
        }
        return gv_tmssResources;
      }
    }).fail(function (request, textStatus, error) {
      toastr.warning("Error de conexion. "+textStatus);
      return [];
    });
});

// recibe:
//   lp_obj: objeto JQuery sobre el que se aplica el typeahead/popup
//   lp_def: string con la definición del typeahead/popup
//   lp_data: estructura JSON con configuracion de asignacion y filtros
//            fldsec (token) y asignacion (fldasg) son parametros requeridos
//            ejemplo = { "fldsec" : security token, "fldflt":{"key 1" : "value 1"......"key n" : "value n"},  "fldasg" : {"key 1" : "value 1"......"key n" : "value n"} } 
//   lp_callback: funciones callback
//            ejemplo = { "beforeAssign" : function(){} , "afterAssign" : function(){}}
function tmssTypeahead(lp_obj, lp_def, lp_data, lp_callback = {}){
	
	if( gv_tmssTypAhdDef_load==false){
		gv_tmssTypAhdDef_queue.push( {obj:lp_obj, def:lp_def, data:lp_data, callback:lp_callback} );
		return;
	}
	
	if( typeof gv_tmssTypAhdDef[ lp_def ]=="undefined" ){
		toastr.warning("No se encontro la definicion de typeahead ["+lp_def+"]. Consulte con el administrador del sistema.");
		return false;
	}

	// Preparacion. preparo datos para typeahead y popup
	var lv_url = gv_tmssTypAhdDef[lp_def]["url"];
	var lv_vew = gv_tmssTypAhdDef[lp_def]["vew"];
	var lv_prm = gv_tmssTypAhdDef[lp_def]["prm"];
	var lv_ttl = gv_tmssTypAhdDef[lp_def]["ttl"];
	var lv_txt = gv_tmssTypAhdDef[lp_def]["txt"];
	
	// Asignacion. Armo las estructuras de asignacion y preDispatch      
	var lv_json_asg = Object.keys(lp_data.fldasg);  
	var lv_asg = "";
	for(var lv_key in lv_json_asg){    
		lv_asg += (lv_asg == "" ? "":",")+"["+lv_json_asg[lv_key]+":"+lp_data.fldasg[ lv_json_asg[lv_key] ]+"]";
	}
	if( lp_data.fldflt !== undefined ){ 
		var lv_json_fltkey = Object.keys(lp_data.fldflt); 
	}else{ lp_data.fldflt = ""; }
	if( lp_data.extraprm == undefined ){ lp_data.extraprm = {}; }

	// preDispatch. Agrego a los parametros del preDistpatch los filtrs que se le definen a la funcion
	for(var lv_key in lv_json_fltkey){
		var lv_keystr = lv_json_fltkey[lv_key];
		if(lv_prm[lv_keystr] == undefined || lv_prm[lv_keystr] == "" ){
			
			//if( lp_data.fldflt[lv_keystr] instanceof jQuery ) {
				// no hacer nada. se asigna directamente
			//} else if( lp_data.fldflt[lv_keystr].substring(0,6)=="(like)" ){
			//	lp_data.fldflt[lv_keystr]=lp_data.fldflt[lv_keystr].substring(6);
			//} else if( lp_data.fldflt[lv_keystr].substring(0,4)=="(in)" ){
			//	lp_data.fldflt[lv_keystr]=lp_data.fldflt[lv_keystr].substring(4);
			//}
		
			// Para casos donde se pase por filtro un valor tipo tagvalue
			if( lv_keystr.toLowerCase().substr(0, 15) == "dbo.gettagvalue"){
				lv_keytmp_arr = lv_keystr.split("^");	
				lv_keystr_tag = lv_keytmp_arr[1];
				lv_prm[lv_keystr_tag] = lp_data.fldflt[lv_keystr];
			}else {
				lv_prm[lv_keystr] = lp_data.fldflt[lv_keystr];
			}			
		}
	}

	// Si no tiene el autocomplete definido, se lo defino
	if( lp_obj.attr("autocomplete") != "off" ){ lp_obj.attr("autocomplete", "off"); }

	// Si no se definio el uso de typeahead o popup, los defino como true a ambos
	if( lp_data.popup == undefined){ lp_data.popup = true };
	if( lp_data.typeahead == undefined){ lp_data.typeahead = true };

	if(lp_data.typeahead){
		tmssLoadScript("typeahead",function() {
			lp_obj.typeahead({
				onSelectAjaxData: function(data) {
					if( typeof lp_callback.beforeAssign != "undefined" ){ lp_callback.beforeAssign( typeof data.data=="undefined" ? data : data.data ); }
					for(var lv_key in lv_json_asg) {
						// Verifico si esta definido data.data o data unicamente
						var lv_data_val = (eval( "data.data."+lp_data.fldasg[lv_json_asg[lv_key]] ) == undefined ? eval( "data."+lp_data.fldasg[lv_json_asg[lv_key]] ) : eval( "data.data."+lp_data.fldasg[lv_json_asg[lv_key]] ) );
						$("#"+lp_data.fldsec+" #"+lv_json_asg[lv_key]).prop("value", lv_data_val );
					}
					if( typeof lp_callback.afterAssign != "undefined" ){ lp_callback.afterAssign( typeof data.data=="undefined" ? data : data.data ); }
				},
				ajax: {
					url: lv_url,
					timeout: 500,
					displayField: lv_txt,
					valueField: lv_txt,
					triggerLength: 1,
          headers:  getHeaders(),
					method: "get",
					LoadingClass: "fas fa-spinner",
					preDispatch: function(query){ 
						var lv_pre = [{name:"prm_"+lv_txt,value:query}];
						var lv_keys = Object.keys(lp_data.fldflt); 
						for(var key in lv_keys){
							var lv_fldnme = lv_keys[key];
							var lv_fldnme_no_alias = (lv_fldnme.indexOf(".")!=-1 ? lv_fldnme.split(".")[1] : lv_fldnme);
							if( lv_fldnme == "prm_"+lv_txt ){
								lv_pre.push( {name:lv_fldnme,value:query} );
							} else if( lp_data.fldflt[ lv_keys[key] ] instanceof jQuery ) {
								lv_pre.push( {name:"prm_"+lv_fldnme_no_alias, value:$(lp_data.fldflt[lv_fldnme]).val()} );
							} else {
								lv_pre.push( {name:"prm_"+lv_fldnme_no_alias, value:lp_data.fldflt[lv_fldnme]} );
							}
						}
            for(var key in lp_data.extraprm){
              lv_pre.push({name:"prm_"+key, value:lp_data.extraprm[key]});
            }
						return lv_pre;
					},
					preProcess: function (data) { return ( typeof data.data=="undefined" ? (data.length==0?false:data) : (data.data.length==0?false:data.data) ); }
				}
			}).on("keyup", function(){
				if( $(this).prop("value")=="" ){  
					// Vacio los campos de cada clave definida en la asignacion
					for(var lv_key in lv_json_asg) {
						$("#"+lp_data.fldsec+" #"+lv_json_asg[lv_key]).prop("value", "").trigger("change");
					}
				}
			})
		});
	}
	
 // pop up case
	var lv_span = (lp_obj.next("span").children("a:first").length != 0) ? lp_obj.next("span").children("a:first") : lp_obj.next().next("span").children("a:first")
	if(lp_data.popup){
		lv_span.off("click"); // quito eventos anteriores
		lv_span.on("click", function(e) { e.preventDefault();
			var lv_flt = "";
			//var lv_keys = Object.keys(lv_prm); 
			for(var lv_key in lv_json_fltkey){
				var lv_keystr = lv_json_fltkey[lv_key];
				if(lp_data.fldflt[lv_keystr] instanceof jQuery ) {
					lv_flt+=(lv_flt!=""?",":"")+"["+lv_keystr+":"+$(lp_data.fldflt[ lv_keystr ]).val()+"]";
				} else {
					var lv_value = lp_data.fldflt[ lv_keystr ];
					lv_flt+=(lv_flt!=""?",":"")+"["+lv_keystr+ ( lv_value.substring(0,6)=="(like)" || lv_value.substring(0,4)=="(in)"?"":":" )+lv_value+ "]";
				}
			}				
			tmssPopup(lv_ttl, lv_url.substr(0, lv_url.indexOf("&") )+"&prm_vewcod="+lv_vew+"&prm_popup=sysdochdr_popup&prm_fldsec="+lp_data.fldsec+"&prm_fldflt="+lv_flt+"&prm_fldasg="+lv_asg, ( typeof lp_callback.afterAssign != "undefined" ? lp_callback.afterAssign : function(){} ), lp_data.extraprm );
		});
	}else{
		lv_span.addClass("hidden");
	}
}

// ---------------------------------
//
//   B A C K D R O P
//
// ---------------------------------
function checkBackdrop(){
	if($(".tmss-backdrop").length==0){
		$(document.body).append("<div class='tmss-backdrop hidden'><span class='tmssWaitSpin'></span>&nbsp;</div>");
	}
}
function showBackdrop(){
	checkBackdrop(); 
	$(".tmss-backdrop").removeClass("hidden");
}
function hideBackdrop(){
	checkBackdrop(); 
	$(".tmss-backdrop").addClass("hidden");
}



// ---------------------------------
//
//   C A L L    P R O C E S S
//
// ---------------------------------
function tmssCallProcess( lp_url, lp_dat, lp_callback ) {
	showBackdrop();
	$.ajax({url:lp_url,method:"POST",data:lp_dat, headers: getHeaders()}).done(function(data){
		hideBackdrop();
		// intento convertir a JSON
		try{ data = JSON.parse(data); } catch (error) { }
		// interpreo respuesta tipo string
		if (typeof(data)==="string") {
			if (data.substring(0,10)=="/*script*/") {
				eval(data);
			} else {
				var lv_errtyp = $("<div>"+data+"</div>").find("errtyp:first").text();
				var lv_errcod = $("<div>"+data+"</div>").find("errcod:first").text();
				var lv_errtxt = $("<div>"+data+"</div>").find("errtxt:first").text();
				if ( lv_errtyp=="E" ) {
					toastr.warning(lv_errcod+": "+lv_errtxt);
				} else {
					lp_callback( data );
				}
			}
		} else if ( (data.errtyp==undefined?"":data.errtyp)=="E" ) {
			toastr.warning(data.errcod+": "+data.errtxt);
		} else {
			lp_callback( data );
		}
	}).fail(function (request, textStatus, error) {
		hideBackdrop();
		toastr.warning("Error de conexion."+textStatus);
	});
}



// ---------------------------------
//
//   C A L L    P R O C E S S    E R R
//
//  llama a un proceso con AJAX y
//  devuelve el control a funcion de proceso OK o ERROR
//
//	parametros:
//		- url
//		- datos post
//		- funcion callback OK
//		- funcion callback Error
// ---------------------------------
function tmssCallProcessErr( lp_url, lp_dat, lp_callback, lp_callbackerr ) {
	var lv_errtyp;
	var lv_errcod;
	var lv_errtxt;
	showBackdrop();
	$.ajax({url:lp_url,method:"POST",data:lp_dat, headers: getHeaders()}).done(function(data){
		hideBackdrop();
		// intento convertir a JSON
		try{ data = JSON.parse(data); } catch (error) { }	
		// interpreto respuesta tipo string		
		if (typeof(data)==="string") {
			if (data.substring(0,10)=="/*script*/") {
				eval(data);
			} else {
				lv_errtyp = $("<div>"+data+"</div>").find("errtyp:first").text();
				lv_errcod = $("<div>"+data+"</div>").find("errcod:first").text();
				lv_errtxt = $("<div>"+data+"</div>").find("errtxt:first").text();
				if ( lv_errtyp=="E" ) {
					lp_callbackerr( {"errtyp":lv_errtyp,"errcod":lv_errcod,"errtxt":lv_errtxt} );
				} else {
					lp_callback( data );
				}
			}
		} else if ( (data.errtyp==undefined?"":data.errtyp)=="E" ) {
			lp_callbackerr( data );
		} else {
			lp_callback( data );
		}
	}).fail(function (request, textStatus, error) {
		hideBackdrop();
		lv_errtyp = "E";
		lv_errcod = "-1";
		lv_errtxt = "Error de conexion."+textStatus;
		lp_callbackerr( {"errtyp":lv_errtyp,"errcod":lv_errcod,"errtxt":lv_errtxt} );
	});
}



// ---------------------------------
//
//  C A L L    P R O C E S S    NO    B A C K D R O P    E R R
//
//  llama a un proceso con AJAX sin visualizar el backdrop y
//  devuelve el control a funcion de proceso OK o ERROR
//
//	parametros:
//		- url
//		- datos post
//		- funcion callback OK
//		- funcion callback Error
// ---------------------------------
function tmssCallProcessNoBackdropErr( lp_url, lp_dat, lp_callback, lp_callbackerr ) {
	var lv_errtyp;
	var lv_errcod;
	var lv_errtxt;
	$.ajax({url:lp_url,method:"POST",data:lp_dat, headers: getHeaders()}).done(function(data){
		// intento convertir a JSON
		try{ data = JSON.parse(data); } catch (error) { }
		// verifico formato
		if (typeof(data)==="string") {
			if (data.substring(0,10)=="/*script*/") {	eval(data); } else {
				lv_errtyp = $("<div>"+data+"</div>").find("errtyp:first").text();
				lv_errcod = $("<div>"+data+"</div>").find("errcod:first").text();
				lv_errtxt = $("<div>"+data+"</div>").find("errtxt:first").text();
				if ( lv_errtyp=="E" ) {
					lp_callbackerr( {"errtyp":lv_errtyp,"errcod":lv_errcod,"errtxt":lv_errtxt} );
				} else {
					lp_callback( data );
				}
			}
		} else if ( (data.errtyp==undefined?"":data.errtyp)=="E" ) {
			lp_callbackerr( data );
		} else {
			lp_callback( data );
		}
	}).fail(function (request, textStatus, error) {
		lv_errtyp = "E";
		lv_errcod = "-1";
		lv_errtxt = "Error de conexion."+textStatus;
		lp_callbackerr( {"errtyp":lv_errtyp,"errcod":lv_errcod,"errtxt":lv_errtxt} );
	});
}


function tmssCallProcessNoBackdrop( lp_url, lp_dat, lp_callback ) {
	$.ajax({url:lp_url,method:"POST",data:lp_dat, headers: getHeaders()}).done(function(data){
		// intento convertir a JSON
		try{ data = JSON.parse(data); } catch (error) { }
		// interpreto respuesta tipo string
		if (typeof(data)==="string") {
			if (data.substring(0,10)=="/*script*/") {
				eval(data);
			} else {
				var lv_errtyp = $("<div>"+data+"</div>").find("errtyp:first").text();
				var lv_errcod = $("<div>"+data+"</div>").find("errcod:first").text();
				var lv_errtxt = $("<div>"+data+"</div>").find("errtxt:first").text();
				if ( lv_errtyp=="E" ) {
					toastr.warning(lv_errcod+": "+lv_errtxt);
				} else {
					lp_callback( data );
				}
			}
		} else {
			if ( (data.errtyp==undefined?"":data.errtyp)=="E" ) {
				toastr.warning(data.errcod+": "+data.errtxt);
			} else {
				lp_callback( data );
			}
		}
	}).fail(function (request, textStatus, error) {
		toastr.warning("Error de conexion."+textStatus);
	});
}


function tmssCallProcessFile( lp_url, lp_dat, lp_callback ) {
	showBackdrop();
	$.ajax({url:lp_url,method:"POST",data:lp_dat, headers: getHeaders(),contentType:false,processData:false,cache:false}).done(function(data){
		hideBackdrop();
		if (typeof(data)==="string") {
			if (data.substring(0,10)=="/*script*/") {
				eval(data);
			} else {
				var lv_errtyp = $("<div>"+data+"</div>").find("errtyp:first").text();
				var lv_errcod = $("<div>"+data+"</div>").find("errcod:first").text();
				var lv_errtxt = $("<div>"+data+"</div>").find("errtxt:first").text();
				if ( lv_errtyp=="E" ) {
					toastr.warning(lv_errcod+": "+lv_errtxt);
				} else {
					lp_callback( data );
				}
			}
		} else {
			lp_callback( data );
		}
	}).fail(function (request, textStatus, error) {
		hideBackdrop();
		toastr.warning("Error de conexion."+textStatus);
	});
}



// ---------------------------------
//
//   C A L L    P R O C E S S   B L O B
//
// ---------------------------------
function tmssCallProcessBlob( lp_url, lp_dat, lp_callback, lp_options ) {
	showBackdrop();
	
	try {
    var lv_svnme = location.host.split(".").map((e) => e.charAt(0).toUpperCase() + e.slice(1)).join(".");
		// Tuve que usar XMLHttpRequest en lugar de $.ajax
		var req = new XMLHttpRequest
		// Url del endpoint, metodo get 
		req.open("POST", lp_url, true);
		req.setRequestHeader(lv_svnme+".Usrcod", localStorage.getItem(lv_svnme+".Usrcod"));
		req.setRequestHeader(lv_svnme+".Usrtkn", localStorage.getItem(lv_svnme+".Usrtkn"));
		req.responseType = "blob";
		req.onload = function (res) {
			hideBackdrop();
      var lv_responseHeaders = {};
      if (lp_options && lp_options.desiredHeaders && Array.isArray(lp_options.desiredHeaders)) {
        lp_options.desiredHeaders.forEach(headerName => {
          const lv_val = req.getResponseHeader(headerName);
          if (lv_val !== null) { // getResponseHeader devuelve null si el header no existe
            lv_responseHeaders[headerName.toLowerCase()] = lv_val; // Guardar en minúsculas para consistencia
          }
        });
      }
			lp_callback( req.response, lv_responseHeaders );
		}
		// prepara datos POST
		var lv_dat = new FormData();
		for(var key in lp_dat){
			lv_dat.append(lp_dat[key].name, lp_dat[key].value);
		}
		// Enviar peticion
		req.send( lv_dat );
	} catch (err) {
		hideBackdrop();
		toastr.warning("Ocurrio un error al solicitar la impresion."+err);
	}
	
	/*
	$.ajax({url:lp_url,method:"POST",data:lp_dat, xhrFields:{responseType:"blob"}}).done(function(data){
		hideBackdrop();
		// intento convertir a JSON
		try{ data = JSON.parse(data); } catch (error) { }
		// interpreo respuesta tipo string
		if (typeof(data)==="string") {
			if (data.substring(0,10)=="/ *script* /") {
				eval(data);
			} else {
				var lv_errtyp = $("<div>"+data+"</div>").find("errtyp:first").text();
				var lv_errcod = $("<div>"+data+"</div>").find("errcod:first").text();
				var lv_errtxt = $("<div>"+data+"</div>").find("errtxt:first").text();
				if ( lv_errtyp=="E" ) {
					toastr.warning(lv_errcod+": "+lv_errtxt);
				} else {
					lp_callback( data );
				}
			}
		} else if ( (data.errtyp==undefined?"":data.errtyp)=="E" ) {
			toastr.warning(data.errcod+": "+data.errtxt);
		} else {
			lp_callback( data );
		}
	}).fail(function (request, textStatus, error) {
		hideBackdrop();
		toastr.warning("Error de conexion."+textStatus);
	});
	*/
}


/**
 * devuelve el valor de una variable como número
 */
function getNumber( lp_num ) {
	return ( lp_num===null || lp_num=='' || lp_num===undefined ? 0 : parseFloat(lp_num) );
}


function tmssHandsontableResize() {
	if(typeof(Event) === "function") {
		// modern browsers
		window.dispatchEvent(new Event("resize"));
	}else{
		// for IE and other old browsers
		// causes deprecation warning on modern browsers
		var evt = window.document.createEvent("UIEvents"); 
		evt.initUIEvent("resize", true, false, window, 0); 
		window.dispatchEvent(evt);
	}
}

/**
 * ejecuta las validaciones HTML5 del formulario
 */
function tmssFormValidation( lp_frm ) {
	if ($(lp_frm)[0].checkValidity()==false) {
		$(lp_frm).find("input, select, textarea").each( function(e) {
			tmssFieldValidation( $(this) );
		});
		return false;
	} else {
		return true;
	}
}

/**
 * se obtiene la validación HTML5 y se muestra como mensaje de error
 */
function tmssFieldValidation( lp_fld ) {
	if ( !$(lp_fld)[0].validity.valid ) {
		$(lp_fld).parentsUntil(".tmss-form-group").parent().addClass("has-error");
		toastr.options.timeOut= 2000;
		toastr.warning( $(lp_fld)[0].validationMessage );
		return false;						
	} else {
		$(lp_fld).parentsUntil(".tmss-form-group").parent().removeClass("has-error");
		return true;
	}
}

/**
 * check if all required fields has values
 */
function tmssCheckRequiredFields( lp_frm ) {
	var lv_req_qty = 0;
	$( lp_frm ).find("input.tmssInputRequired, select.tmssInputRequired, textarea.tmssInputRequired").each( function() {
		if ( $(this).val()=="" ) {
			$(this).parentsUntil(".tmss-form-group").parent().addClass("has-error");
			lv_req_qty++;
		} else {
			$(this).parentsUntil(".tmss-form-group").parent().removeClass("has-error");
		}
	});
	if ( lv_req_qty!=0 ) {
		toastr.options.timeOut= 2000;
		toastr.warning( "Complete los campos obligatorios.<br>Incompletos ("+lv_req_qty+")." );
		return false;
	}
	return true;
}


function tmssMessageProcessing( lp_section, lp_action, lp_title, lp_document ) {
	// save
	if (lp_action=="00") {
		if ( !tmssCheckRequiredFields( $("#"+lp_section+"_frm") ) ) { return false; }
	
	// delete
	} else if (lp_action=="04") { 
		BootstrapDialog.confirm({
			title: 'Borrar '+lp_title,
			message: '¿Desea borrar el documento '+lp_document+' ?',
			type: BootstrapDialog.TYPE_WARNING,
			callback: function(result) {
				if(result) {
					$("#"+lp_section+"_frm > #tmss_actcod").attr("value",lp_action);
					$("#"+lp_section+"_frm").submit();
				}
			}
		});
		return false;

	// cancel
	} else if (lp_action=="98") { 
		if ( lp_document=="" ) {
			tmssTabSecCls( $("#"+lp_section) );
			return true;
		} else {
			lp_action = "03";
		}
	}
	
	// form submit
	if( $("#"+lp_section+"_frm #ajax").length==0){$("#"+lp_section+"_frm").append("<input type='hidden' id='ajax' name='ajax' value='1'>"); }
	$("#"+lp_section+"_frm > #tmss_actcod").attr("value",lp_action);
	$("#"+lp_section+"_frm").submit();	
	return true;
}


function tmssBackMessageProcessing( data, lp_action, lp_title, lp_document ) {
	toastr.options.closeButton = true;
	toastr.options.timeOut= 2000;
	toastr.options.progressBar=true;
	var lv_errtyp = "";
	var lv_errcod = "";
	var lv_errtxt = "";
  var lv_errjva = "";

	if( typeof data=="object" ) {
		lv_errtyp = data.errtyp || "";
		lv_errcod = data.errcod || 0;
		lv_errtxt = data.errtxt || "";
		lv_errjva = data.errjva || "";
    
	// process script (i.e. session timeout)
	} else if ( data.substr(0,10)=="/*script*/" ) {
		eval( data.substr(10) );
		return false;
		
	// get proccessing error (i.e. required fields)
	} else if ( data.substr(0,8)=="<errcod>" ) {
		var lv_xml = $.parseXML( "<?xml version='1.0' encoding='utf-8'?><xmldata>" + data + "</xmldata>" );
		lv_errtyp = $(lv_xml).find("errtyp").eq(0).text();
		lv_errcod = $(lv_xml).find("errcod").eq(0).text();
		lv_errtxt = $(lv_xml).find("errtxt").eq(0).text();
	}
	
	// WARNING. mensaje de error
	if ( lv_errcod!="" || lv_errtyp=="E" ) {
    if( lv_errjva!="" ){ eval( lv_errjva ); }
		toastr.options.timeOut= 4000;
		toastr.warning( "Documento "+lp_document+"<br>" + lv_errcod + ": " + lv_errtxt, lp_title );
		return false;

	// SUCCESS. mensaje de grabado
	} else if ( lp_action=="00" ) {
		toastr.success( "Documento "+lp_document+" grabado.", lp_title );
		return true;

	// WARNING. mensaje de borrado
	} else if ( lp_action=="04") {
		toastr.warning( "Documento "+lp_document+" borrado.", lp_title );
		return true;
		
	// INFO. mensaje de actualizado.
	} else if ( lp_action=="99" ) {
		toastr.info( "Documento "+lp_document+" actualizado.", lp_title );
		return true;
	}
	return true;
	
}


/**
 * show message on screen 
 */
function tmssMessage( lp_msgtyp, lp_msgtxt, lp_msgttl ) {
    toastr.options.closeButton = true;
    toastr.options.timeOut= 2000;
    toastr.options.progressBar=true;
    //msgttl = msgttl || "";
    if ( lp_msgtyp=="e" ) {
      toastr.error( lp_msgtxt );
    } else if ( lp_msgtyp=="w" ) {
      toastr.warning( lp_msgtxt );      
    } else if ( lp_msgtyp=="s" ) {
      toastr.success( lp_msgtxt );
    } else {
      toastr.info( lp_msgtxt );
    }
}



/** //////////////////////////////////////////////////////////////////////
 *
 *  T A B S
 *  
 *  //////////////////////////////////////////////////////////////////////
 */
 
/**
 * add new tab
 * lp_act: true - active new tab       
 */             
function tmssAddTab( lp_act ) {
  gv_tmssTabNum++;
  lv_tmssTab = "<li role='presentation' class='nav-item tmss-nav-tab'><a href='#tmssTab"+gv_tmssTabNum+"' aria-controls='tmssTab"+gv_tmssTabNum+"' role='tab' data-toggle='tab' class='nav-link tmss-navbar-title-nav'>(Vac&iacute;o)<span class='fas fa-times tmss-tabs-main-close' onClick='tmssTabFrmClsBtn(this);'></span></a></li>"  
  $(lv_tmssTab).insertBefore( $("#btnAddPage").parent() );
  $("#pageTabContent").append( "<div role='tabpanel' class='tab-pane' id='tmssTab"+gv_tmssTabNum+"'></div>" );
// $("#pageTab").append( "<li role='presentation'><a href='#tmssTab"+gv_tmssTabNum+"' aria-controls='tmssTab"+gv_tmssTabNum+"' role='tab' data-toggle='tab'>(vacio)</a></li>" );
// $("#pageTabContent").append( "<div role='tabpanel' class='tab-pane' id='tmssTab"+gv_tmssTabNum+"'></div>" );
  tmssAddTabFrame( gv_tmssTabNum );
  if ( lp_act==true ) { $("#pageTab a[href='#tmssTab"+gv_tmssTabNum+"']").tab("show"); }
}
    
/**
 * add new frame
 * lp_tab: integer - tab index who include this new frame             
 */
function tmssAddTabFrame( lp_tab ) {
  gv_tmssTabFrmNum++;
  // desactivo el panel activo anterior
  $("#pageTabContent > #tmssTab"+lp_tab+" > .tab-frame:last").removeClass("active");
  // agrego un nuevo panel
//  $("#pageTabContent > #tmssTab"+lp_tab).append("<div role='tabframe' class='tab-frame active'><nav class='navbar navbar-expand-lg bg-primary'><div class='container-fluid p-0 d-flex justify-content-end'><ul class='nav navbar-nav flex-row'><li class='nav-item'><a href='#' onclick='tmssTabFrmCls(this);' title='Cerrar' class='nav-link'><span class='fas fa-times'></span></a></li></ul></div></nav></div>");
$("#pageTabContent > #tmssTab"+lp_tab).append("<div role='tabframe' class='tab-frame active'><nav class='navbar navbar-default'><div class='container-fluid'><ul class='nav navbar-nav navbar-right'></ul></div></nav></div>");
}

      
/**
 * TAB - section close
 */             
function tmssTabSecCls( lp_prm ) {
  var lv_sec = $(lp_prm).prop("id");
	var lv_data = Object.fromEntries(
    $("#"+lv_sec+"_frm").serializeArray().map(i => [i.name, i.value])
  );
  
	// quito la seccion actual
	$(lp_prm).remove();
	// verifico si hay mas secciones en la misma solapa
	if ( $("#pageTabContent > div.tab-pane.active > div.tab-frame:last > section:last").length>=1 ) {
		// obtengo el id de seccion
		var lv_sec_id = $("#pageTabContent > div.tab-pane.active > div.tab-frame:last > section:last").prop("id");
    
    if(location.pathname.search("gorse.php")!=-1 && $("#"+lv_sec_id).attr("url")){ 
      tmssLink($("#"+lv_sec_id).attr("url"), [{tab_title: $("#"+lv_sec_id).attr("title")}]);
    }else{
      // hago el refresh de grilla de la seccion a mostrar (solor grillas)
      if ( typeof window[ lv_sec_id + "_GridRefresh" ] != "undefined" ) {
        eval( lv_sec_id + "_GridRefresh("+JSON.stringify(lv_data)+");" );
      }
      // muestro la seccion
      $("#"+lv_sec_id).show();
    }
		
	} else {
		// cierro la solapa (no hay mas secciones en la solapa)
    tmssTabCls( $("#pageTabContent > div.tab-pane.active") );    
	}
}


/**
 * close frame
 */             
function tmssTabFrmCls( lp_btncls ) {
  var lv_id;
  // get current tab
  var lv_tab = $(lp_btncls).parents(".tab-pane.active");

  // show next/last frame
  if ( $("#pageTabContent > #"+$(lv_tab).attr("id")+" > .tab-frame:last").next().length==0 && $("#pageTabContent > #"+$(lv_tab).attr("id")+" > .tab-frame:last").prev().length==0 ) {
    tmssTabCls( $(lv_tab) );
  } else if ( $("#pageTabContent > #"+$(lv_tab).attr("id")+" > .tab-frame:last").next().length!=0 ) {
    lv_id = $("#pageTabContent > #"+$(lv_tab).attr("id")+" > .tab-frame:last").next().attr("id");
    $("#pageTab a[href='#"+lv_id+"']").tab("show");
  } else {
    lv_id = $("#pageTabContent > #"+$(lv_tab).attr("id")+" > .tab-frame:last").prev().attr("id");
    $("#pageTab a[href='#"+lv_id+"']").tab("show");
  }
  
  // remove current frame
  $(lp_btncls).parents(".tab-frame").remove();
}


/**
 * tmssTabCls
 * cierra la solapa activa
 */
function tmssTabCls( lp_tab ) {
  if($("#pageTab li.tmss-nav-tab").length > 1){
    // obtengo el nro de indice de la solapa a cerrar
    var lv_inx = $("#pageTab li.active").closest('li').index();
    // No se permite cerrar la última tab
    // quito el <div> de contenido
    $("#pageTabContent > div.tab-pane.active").remove();
    // quito el <li> de solapa
    $("#pageTab > li.active").remove();
    // siempre voy a la solapa anterior a menos que sea la solapa 0 (agregar solapa) y haya mas solapas que cerrar
    if(lv_inx != 0){
      lv_inx--;
    }
    //if( lv_inx==0 && $("#pageTab > li").length>1 ) { lv_inx=1; }
    // establezco el foco en la nueva solapa
    $( $("#pageTab > li")[lv_inx] ).find("a:first").not("#btnAddPage").tab("show");
  }
}
    
    
function tmssTabFrmClsBtn( lp_btncls ) {
  var lv_id;
  // get current tab
  var lv_tab = $(lp_btncls).parents(".nav-item");

  // show next/last frame
  if ( $("#pageTabContent > #"+$(lv_tab).attr("id")+" > .tab-frame:last").next().length==0 && $("#pageTabContent > #"+$(lv_tab).attr("id")+" > .tab-frame:last").prev().length==0 ) {
    tmssTabClsBtn( $(lv_tab) );
  } else if ( $("#pageTabContent > #"+$(lv_tab).attr("id")+" > .tab-frame:last").next().length!=0 ) {
    lv_id = $("#pageTabContent > #"+$(lv_tab).attr("id")+" > .tab-frame:last").next().attr("id");
    $("#pageTab a[href='#"+lv_id+"']").tab("show");
  } else {
    lv_id = $("#pageTabContent > #"+$(lv_tab).attr("id")+" > .tab-frame:last").prev().attr("id");
    $("#pageTab a[href='#"+lv_id+"']").tab("show");
  }
  
  // remove current frame
  $(lp_btncls).parents(".tab-frame").remove();
}


/**
 * tmssTabClsBtn
 * cierra la solapa activa
 */
function tmssTabClsBtn( lp_tab ) {
	// obtengo el nro de indice de la solapa a cerrar
  var lv_inx = lp_tab.index();
    
  // No se permite cerrar la última tab
  if (lp_tab.siblings().length > 1){
  	// quito el <div> de contenido
    $($("#pageTabContent > .tab-pane")[lv_inx]).remove();
    // quito el <li> de solapa
    lp_tab.remove();
    // si la solapa cerrada era la primera, establezo foco en la solapa que se le redujo un indice, sino, me muevo a la izquierda
    (lv_inx === 0) ? lv_inx : lv_inx--;
    // establezco el foco en la nueva solapa
    $( $("#pageTab > li")[lv_inx] ).find("a:first").not("#btnAddPage").tab("show"); 
  }
}



function tmssPopup( lp_ttl, lp_src, lp_callback, lp_pstdat ) {
	var lv_pstdat = (typeof(lp_pstdat)!="undefined" ? lp_pstdat : [] );
	tmssCallProcess( lp_src, lv_pstdat, function(data){
		BootstrapDialog.show({
			title: lp_ttl,
			message: $(data),
			type: BootstrapDialog.TYPE_PRIMARY,
			onhide: function(dialog) {
				if (typeof(lp_callback)!="undefined") {
					lp_callback(dialog);
				}
			}
		});
	});
}



function tmssFormEdit( lp_frm, lp_edt, lp_exclude ) {
	
	lp_exclude = lp_exclude || "NULL";
	
  $("#"+lp_frm+" :input").not(lp_exclude).each( function() {
		if ( $(this).attr("type")!="hidden") {
			if ( $(this).hasClass("tmssAlwaysDisabled") ) {
				$(this).attr("readonly","true");
			} else {
				if (lp_edt) {
					$(this).removeAttr("readonly");
					if ( $(this).hasClass("tmssInputRequired") ) {
						if ( $(this).prop("placeholder")=="" ) {
							$(this).prop("placeholder","?");
						}
					}
				} else if ( !$(this).hasClass("tmssAlwaysEnabled") ) {
					$(this).attr("readonly","true");
				}
			}
		}
  });
	
	// hide-show elements with specific class 
  $("#"+lp_frm).find(".tmssHiddeOnRead").not(lp_exclude).each( function() {
    if (lp_edt) {
      $(this).removeClass("tmssHidden");
    } else {
      $(this).addClass("tmssHidden");
    }
  });
  $("#"+lp_frm).find(".tmssHiddeOnEdit").not(lp_exclude).each( function() {
    if (!lp_edt) {
      $(this).removeClass("tmssHidden");
    } else {
      $(this).addClass("tmssHidden");
    }
  });
    
  // se quitan los botones de los campos de fecha si es solo lectura
  $("#"+lp_frm).find(".input-group.date > .input-group-addon").each(function(){
    if(lp_edt){
    	$(this).removeClass("hidden");
    }else if ( !$(this).siblings("input").hasClass("tmssAlwaysEnabled") ){
    	$(this).addClass("hidden");
    }
  });
  // fin agregar-quitar boton de fechas
    
}


/**
 * característica:  url. link
 * acción:          diferentes formas de abrir un link de url o función del sistema.
 * parámetros:			lp_lnk: string. URL
 * 									lp_prm: array. parameters
 *   									- tab_title: string. titulo de la solapa
 *										- target: 
 *										- url_data: array.
 *   									- post_data: array.
 *   									- tab_new: boolean. abrir link en una solapa nueva
 *   									- tab_ovr: boolean. abrir link reemplazando el contenido de la solapa actual
 *   									- oncomplete: js. callback function
 */            
function tmssLink( lp_lnk, lp_prm ) {
  
  var lv_ttl = "";          		/* tab title                    */
  var lv_tgt = "";              /* target key          					*/
  var lv_tgt_id = "";           /* target id          					*/
  var lv_urldat = [];           /* url data                     */
  var lv_pstdat = [];           /* post data                    */
  var lv_newtab = false;        /* open in new tab              */
  //var lv_ovrtab = true;       /* open replacing current tab   */
  var lv_oncomplete = "";  /* oncomplete callback function */
  
  // get data from parameters
  if (typeof lp_prm[0]!="undefined") {
    if (typeof lp_prm[0]["tab_title"]!="undefined") { lv_ttl       = lp_prm[0]["tab_title"]; }
    if (typeof lp_prm[0]["target"]!="undefined")    { lv_tgt       = lp_prm[0]["target"]; }
    if (typeof lp_prm[0]["target_id"]!="undefined")    { lv_tgt_id    = lp_prm[0]["target_id"]; }
    if (typeof lp_prm[0]["url_data"]!="undefined")  { lv_urldat    = lp_prm[0]["url_data"]; }
    if (typeof lp_prm[0]["post_data"]!="undefined") { lv_pstdat    = lp_prm[0]["post_data"]; }
    if (typeof lp_prm[0]["tab_new"]!="undefined")   { lv_newtab    = lp_prm[0]["tab_new"]; }
    //if (typeof lp_prm[0]["tab_ovr"]!="undefined")   { lv_ovrtab    = lp_prm[0]["tab_ovr"]; }
    if (typeof lp_prm[0]["oncomplete"]!="undefined"){ lv_oncomplete= lp_prm[0]["oncomplete"]; }
  }
  
	// armo el parámetro de la vista
	lp_lnk = lp_lnk.toLowerCase();
	if (typeof lv_urldat[0]!="undefined") {
		if (typeof lv_urldat[0]["vewcod"]!="undefined") {
			lp_lnk += (typeof lv_urldat[0]["vewcod"]=="undefined"?"":"&prm_vewcod="+lv_urldat[0]["vewcod"]);
		}
	}
  
  var lv_ajx = [{name: "ajax", value: "1"}];
  lv_pstdat.push( lv_ajx[0] );

  // call to URL
	tmssCallProcess( lp_lnk, lv_pstdat, function(data) {	
		// tab title
		if (lv_ttl!="") { 
  		$("#pageTab > .active > :first").text( lv_ttl );
  		$("#pageTab > .active > :first").append( "<span class='fas fa-times tmss-tabs-main-close' onClick='tmssTabFrmClsBtn(this);'></span>" );
    }
		if (lv_tgt) {
			if (lv_tgt=="_new_section") {
				var lv_tmptab = $("#pageTabContent > .tab-pane.active > .tab-frame:last");
				$(lv_tmptab).find("> section").each( function() {
						$(this).hide();
				});
				$(lv_tmptab).append(data);
			} else if (lv_tgt=="_new_window") {
				window.open( data );
			} else if (lv_tgt=="_replace_with") {
				$(lv_tgt_id).replaceWith(data)
			} else {
				$(lv_tgt_id).html(data);
			}
		} else {
			$("#pageTabContent > .tab-pane.active > .tab-frame:last").html(data);
		}	
    
    if(lv_oncomplete){
      lv_oncomplete();
    }
	});
	
	// new tab is required
	if(lv_newtab==true) {tmssAddTab();}
}



/**
 * característica:  form. submit
 * acción:          captura el evento submit de un formulario y lo convierte en una llamada AJAX
 */
function tmssLinkForm( lp_obj, lp_lnk, lp_calbck ) {
	
  $(lp_obj).on( "submit", function(event) { event.preventDefault();
	
		// validacion HTML5 estándard del formulario
		if ( tmssFormValidation( $(this) )==false ) {
			event.preventDefault();
			event.stopPropagation();
			//$(this).data("running","");
			return false;
		}
	
    // action code determination
    var lv_act = ( $(this).find("#tmss_actcod:first").length==1?$(this).find("#tmss_actcod:first").attr("value") : "" );
    var lv_lnk = "";
    var lv_inx = lp_lnk.indexOf("act=");
    if (lv_inx==-1) {
      lv_lnk = lp_lnk + (lp_lnk.indexOf("?")==-1?"?":"&") + "act=" + lv_act;
    } else {
      lv_lnk = lp_lnk.substring(0,lv_inx) + "act=" + lv_act + lp_lnk.substring( lv_inx+6 );
    }
		lv_lnk = encodeURI(lv_lnk);
		
    // serializacion de formulario
    var lv_ser_arr = $(this).serializeArray();
    
    // incluyo los checkbox no checkeados al formulario
    $(this).find(".toggle-switchy > input[type=checkbox]:not(:checked)").each(function(e){
      lv_ser_arr.push( {"name": $(this).prop("name"), value: $(this).prop("value")} );
    });
    
		// llamada AJAX al formulario y control de errores
		tmssCallProcessErr( lv_lnk, lv_ser_arr, 
			function(data){ lp_calbck( data ); }, 
			function(dataerr){ lp_calbck( dataerr ); }
		);
		
		event.stopPropagation();
  });
}





// -----------------------------------------------------------------------------
// F O R M A T D A T E
// Recibe     : Cadena de texto a formatear
// Devuelve   : cadena de texto con formato dd/mm/yyyy
// Descripción: Esta funcion acepta dos formatos de fecha ( ddmmyy  ó  dd mm yyyy )
//              y lo convierte al formato dd/mm/yyyy
// -----------------------------------------------------------------------------
function formatdate(myobject) {
	var strsep = '/';
	var strday = '';
	var strmth = '';
	var stryth = '';
	var myvalue = myobject.value;

	if (myvalue.length == 0) return '';

	if (myvalue.length != 6 && myvalue.length != 10) {
		alert('La fecha ingresada (' + myvalue + ') no es válida.\n Ingrese la fecha con formato ddmmyy ó dd mm yyyy');
		return '';
	}

	strday = myvalue.substr(0,2);
	if (myvalue.length == 6) {
		strmth = myvalue.substr(2,2);
		stryth = myvalue.substr(4,2);
	} else {
		strmth = myvalue.substr(3,2);
		stryth = myvalue.substr(6,4);
	}

	if ( !isNumeric(strday) || !isNumeric(strmth) || !isNumeric(stryth) ) {
		alert('La fecha ingresada (' + myvalue + ') no es válida.\n Ingrese la fecha con formato ddmmyy ó dd mm yyyy');
		return '';
	}

	if (parseInt(stryth,10) < 1000) {
		if (parseInt(stryth,10) < 50) {
			stryth = 2000 + parseInt(stryth,10);
		} else {
			stryth = 1900 + parseInt(stryth,10);
		}
	}

	// valido que el valor ingresado sea una fecha válida
	try{
		var x = new Date(stryth, parseInt(strmth)-1, strday);
		if ( x.getFullYear()!=parseInt(stryth) || (x.getMonth()+1)!=parseInt(strmth) || x.getDate()!=parseInt(strday) ) {
				throw 'NaN';
		}
	} catch(e) {
		alert('La fecha ingresada (' + myvalue + ') no es válida.');
		return '';		
	}
	
	return strday + strsep + strmth + strsep + stryth;
}
// -----------------------------------------------------------------------------





// -----------------------------------------------------------------------------
// F O R M A T T I M E
// Recibe     : Cadena de texto a formatear
// Devuelve   : cadena de texto con formato hh:mm
// Descripción: Esta funcion acepta dos formatos de fecha ( h  ó  h.m ) y lo
//              convierte al formato hh:mm
// -----------------------------------------------------------------------------
function formattime(myobject) {
	var strsep = ':';
	var strhrs = '';
	var strmin = '';
	var myvalue = myobject.value;
	var myvaluesep;

	if (myvalue.length == 0) return '';

	if (myvalue.indexOf('.')==-1 && myvalue.indexOf(':')==-1) {
		strhrs = myvalue;
		strmin = '0';
	} else {
		if ( myvalue.indexOf('.')!=-1) {
			myvalue_sep = myvalue.split('.');
		} else {
			myvalue_sep = myvalue.split(':');
		}
		strhrs = myvalue_sep[0];
		strmin = myvalue_sep[1];
	}

	if ( !isNumeric(strhrs) || !isNumeric(strmin) ) {
		alert('La hora ingresada (' + myvalue + ') no es válida.\n Ingrese la hora con formato [h], [hh.mm] ó [hh:mm]');
		return '';
	}

	if ( parseInt(strhrs,10) < 0 || parseInt(strhrs,10) > 23 ) {
		alert('La hora ingresada (' + myvalue + ') no es válida.\n El valor ingresado debe ser entre 0 y 23');
		return '';
	}

	if ( parseInt(strmin,10) < 0 || parseInt(strmin,10) > 59 ) {
		alert('Los minutos ingresados (' + myvalue + ') no son válidos.\n El valor ingresado debe ser entre 0 y 59');
		return '';
	}

	if (parseInt(strhrs,10) < 10) strhrs = '0' + parseInt(strhrs,10);
	if (parseInt(strmin,10) < 10) strmin = '0' + parseInt(strmin,10);

	return strhrs + strsep + strmin;

}
// -----------------------------------------------------------------------------



// -----------------------------------------------------------------------------
// I S N U M E R I C
// Recibe     : Cadena de texto a validar
// Devuelve   : true - si la cadena solo contiene números
// Descripción: Dada una cadena de texto, valida que solamente contenga números
// -----------------------------------------------------------------------------
function isNumeric(strString) {
	var strValidChars = '0123456789';
	var strChar;
	if (strString.length == 0) return false;
	for (var i=0; i < strString.length; i++) {
		strChar = strString.charAt(i);
		if (strValidChars.indexOf(strChar) == -1) return false;
	}
	return true;
}
// -----------------------------------------------------------------------------





// -----------------------------------------------------------------------------
//
//   C O L O R E S
//
// -----------------------------------------------------------------------------

// COLOR GET RANDOM MATERIAL DESIGN. devuelve un color HEX de la paleta de Material Design (sin contemplar blanco ni negro)
function tmssColorGetRandomMaterialDesign() {
	// colors from https://github.com/egoist/color-lib/blob/master/color.json
	var lv_colors = {"red":{"50":"#ffebee","100":"#ffcdd2","200":"#ef9a9a","300":"#e57373","400":"#ef5350","500":"#f44336","600":"#e53935","700":"#d32f2f","800":"#c62828","900":"#b71c1c","hex":"#f44336","a100":"#ff8a80","a200":"#ff5252","a400":"#ff1744","a700":"#d50000"},"pink":{"50":"#fce4ec","100":"#f8bbd0","200":"#f48fb1","300":"#f06292","400":"#ec407a","500":"#e91e63","600":"#d81b60","700":"#c2185b","800":"#ad1457","900":"#880e4f","hex":"#e91e63","a100":"#ff80ab","a200":"#ff4081","a400":"#f50057","a700":"#c51162"},"purple":{"50":"#f3e5f5","100":"#e1bee7","200":"#ce93d8","300":"#ba68c8","400":"#ab47bc","500":"#9c27b0","600":"#8e24aa","700":"#7b1fa2","800":"#6a1b9a","900":"#4a148c","hex":"#9c27b0","a100":"#ea80fc","a200":"#e040fb","a400":"#d500f9","a700":"#aa00ff"},"deepPurple":{"50":"#ede7f6","100":"#d1c4e9","200":"#b39ddb","300":"#9575cd","400":"#7e57c2","500":"#673ab7","600":"#5e35b1","700":"#512da8","800":"#4527a0","900":"#311b92","hex":"#673ab7","a100":"#b388ff","a200":"#7c4dff","a400":"#651fff","a700":"#6200ea"},"indigo":{"50":"#e8eaf6","100":"#c5cae9","200":"#9fa8da","300":"#7986cb","400":"#5c6bc0","500":"#3f51b5","600":"#3949ab","700":"#303f9f","800":"#283593","900":"#1a237e","hex":"#3f51b5","a100":"#8c9eff","a200":"#536dfe","a400":"#3d5afe","a700":"#304ffe"},"blue":{"50":"#e3f2fd","100":"#bbdefb","200":"#90caf9","300":"#64b5f6","400":"#42a5f5","500":"#2196f3","600":"#1e88e5","700":"#1976d2","800":"#1565c0","900":"#0d47a1","hex":"#2196f3","a100":"#82b1ff","a200":"#448aff","a400":"#2979ff","a700":"#2962ff"},"lightBlue":{"50":"#e1f5fe","100":"#b3e5fc","200":"#81d4fa","300":"#4fc3f7","400":"#29b6f6","500":"#03a9f4","600":"#039be5","700":"#0288d1","800":"#0277bd","900":"#01579b","hex":"#03a9f4","a100":"#80d8ff","a200":"#40c4ff","a400":"#00b0ff","a700":"#0091ea"},"cyan":{"50":"#e0f7fa","100":"#b2ebf2","200":"#80deea","300":"#4dd0e1","400":"#26c6da","500":"#00bcd4","600":"#00acc1","700":"#0097a7","800":"#00838f","900":"#006064","hex":"#00bcd4","a100":"#84ffff","a200":"#18ffff","a400":"#00e5ff","a700":"#00b8d4"},"teal":{"50":"#e0f2f1","100":"#b2dfdb","200":"#80cbc4","300":"#4db6ac","400":"#26a69a","500":"#009688","600":"#00897b","700":"#00796b","800":"#00695c","900":"#004d40","hex":"#009688","a100":"#a7ffeb","a200":"#64ffda","a400":"#1de9b6","a700":"#00bfa5"},"green":{"50":"#e8f5e9","100":"#c8e6c9","200":"#a5d6a7","300":"#81c784","400":"#66bb6a","500":"#4caf50","600":"#43a047","700":"#388e3c","800":"#2e7d32","900":"#1b5e20","hex":"#4caf50","a100":"#b9f6ca","a200":"#69f0ae","a400":"#00e676","a700":"#00c853"},"lightGreen":{"50":"#f1f8e9","100":"#dcedc8","200":"#c5e1a5","300":"#aed581","400":"#9ccc65","500":"#8bc34a","600":"#7cb342","700":"#689f38","800":"#558b2f","900":"#33691e","hex":"#8bc34a","a100":"#ccff90","a200":"#b2ff59","a400":"#76ff03","a700":"#64dd17"},"lime":{"50":"#f9fbe7","100":"#f0f4c3","200":"#e6ee9c","300":"#dce775","400":"#d4e157","500":"#cddc39","600":"#c0ca33","700":"#afb42b","800":"#9e9d24","900":"#827717","hex":"#cddc39","a100":"#f4ff81","a200":"#eeff41","a400":"#c6ff00","a700":"#aeea00"},"yellow":{"50":"#fffde7","100":"#fff9c4","200":"#fff59d","300":"#fff176","400":"#ffee58","500":"#ffeb3b","600":"#fdd835","700":"#fbc02d","800":"#f9a825","900":"#f57f17","hex":"#ffeb3b","a100":"#ffff8d","a200":"#ffff00","a400":"#ffea00","a700":"#ffd600"},"amber":{"50":"#fff8e1","100":"#ffecb3","200":"#ffe082","300":"#ffd54f","400":"#ffca28","500":"#ffc107","600":"#ffb300","700":"#ffa000","800":"#ff8f00","900":"#ff6f00","hex":"#ffc107","a100":"#ffe57f","a200":"#ffd740","a400":"#ffc400","a700":"#ffab00"},"orange":{"50":"#fff3e0","100":"#ffe0b2","200":"#ffcc80","300":"#ffb74d","400":"#ffa726","500":"#ff9800","600":"#fb8c00","700":"#f57c00","800":"#ef6c00","900":"#e65100","hex":"#ff9800","a100":"#ffd180","a200":"#ffab40","a400":"#ff9100","a700":"#ff6d00"},"deepOrange":{"50":"#fbe9e7","100":"#ffccbc","200":"#ffab91","300":"#ff8a65","400":"#ff7043","500":"#ff5722","600":"#f4511e","700":"#e64a19","800":"#d84315","900":"#bf360c","hex":"#ff5722","a100":"#ff9e80","a200":"#ff6e40","a400":"#ff3d00","a700":"#dd2c00"},"brown":{"50":"#efebe9","100":"#d7ccc8","200":"#bcaaa4","300":"#a1887f","400":"#8d6e63","500":"#795548","600":"#6d4c41","700":"#5d4037","800":"#4e342e","900":"#3e2723","hex":"#795548"},"grey":{"50":"#fafafa","100":"#f5f5f5","200":"#eeeeee","300":"#e0e0e0","400":"#bdbdbd","500":"#9e9e9e","600":"#757575","700":"#616161","800":"#424242","900":"#212121","hex":"#9e9e9e"},"blueGrey":{"50":"#eceff1","100":"#cfd8dc","200":"#b0bec5","300":"#90a4ae","400":"#78909c","500":"#607d8b","600":"#546e7a","700":"#455a64","800":"#37474f","900":"#263238","hex":"#607d8b"}}; // ,"black":{"hex":"#000000"},"white":{"hex":"#ffffff"}};
	// pick random property
	var lv_colorList = lv_colors[tmssJsonGetRandomProperty(lv_colors)];
	var lv_newColorKey = tmssJsonGetRandomProperty(lv_colorList);
	var lv_newColor = lv_colorList[lv_newColorKey];
	return lv_newColor;
}

// COLOR GET RANDOM. devuelve un color HEX de forma aleatoria
function tmssColorGetRandom() {
	return "#" + // start with a leading hash
		Math.random() // generates random number
		.toString(16) // changes that number to base 16 as a string
		.substr(2, 6); // gets 6 characters and excludes the leading "0."
}

// HEX 2 RGBA. convierte una expresion HEX a RGBA
// si se indica transparencia tambien se agrega a la salida RGBA
function tmssHex2Rgba(hex, alpha=1){
	const [r, g, b] = hex.match(/\w\w/g).map(x => parseInt(x, 16));
	return `rgba(${r},${g},${b},${alpha})`;
}





// -----------------------------------------------------------------------------
//
//   C L I P B O A R D
//
// -----------------------------------------------------------------------------

// COPY TO CLIPBOARD. copia un texto al portapapeles
async function tmssCopyToClipboard( lp_text ) {
	await navigator.clipboard.writeText( lp_text ).then(() => {
		toastr.info("Copied to clipboard");
	});
}

// PASTE FROM CLIPBOARD. devuelve el texto que esta copiado en el clipboard
function tmssPasteFromClipboard() {
	return navigator.clipboard.readText();
}	





// -----------------------------------------------------------------------------
//
//   V A R I O S
//
// -----------------------------------------------------------------------------

// IS MOBILE. devuelve true/false si el dispositivo utiliza un navegador mobile (se presume que es mobile)
function tmssIsMobile(){
	return (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent));
}

// JSON GET RANDOM PROPERTY. dado un objeto en formato JSON recupera un elemento de forma aleatoria
function tmssJsonGetRandomProperty(obj) {
	var result;
	var count = 0;
	for (var prop in obj)
		if (Math.random() < 1 / ++count)
			result = prop;
	return result;
} 

/**
 * TMSS GET URL
 * acción:          arma la url
 * parámetros:			lp_prm: objeto. parameters
 *										- mdlcod: string. Módulo 
 *										- prgcod: string. Programa
 *   									- method: string. Método http
 *   									- id: string. Id del documento
 *   									- readonly: boolean. Modo en el que se abrió el documento
 *   									- qryprm: boolean. Modo en el que se abrió el documento
 */            
async function tmssGetUrl(lp_prm){
  // valido datos
  if(lp_prm["mdlcod"] === undefined || lp_prm["prgcod"] === undefined){
    return '';
  }
  if (lp_prm["method"] === undefined && lp_prm["readonly"] === undefined) { 
    return ''; 
  }
  
  // determino recurso
  const lv_objtyp = lp_prm["mdlcod"] + "_" + lp_prm["prgcod"];
  const lv_resource = await lv_loadResources.then(() => gv_tmssResources[lv_objtyp]);
  if(!lv_resource){
    return '';
  }
  
  // determino método
  var lv_method = "";
  if(lp_prm["method"]){
    lv_method = lp_prm["method"];
  }else if(!lp_prm["readonly"]){
    lv_method = lp_prm["id"] ? "edit" : "new"; 
  } // else: puede ser visualizar o listar
  
  // armo url
  var lv_url = location.protocol + "//" + location.host;
  lv_url += location.pathname ? "/" + location.pathname.split("/").slice(1, 2).join("/") + "/" + lp_prm["buscodcus"] : "";
  lv_url += "/" + lv_resource.toLowerCase();
  lv_url += lp_prm["id"] ? "/" + lp_prm["id"] : "";
  lv_url += lv_method ? "?" + lv_method : "";
  
  // agrego parámetros extra
  if(lp_prm["qryprm"] != undefined){
  	var lv_qryprm = new URLSearchParams(lp_prm["qryprm"]).toString();
    lv_url += (lv_method ? '' : '?')+lv_qryprm;
  }
    
  return lv_url;
}

function tmssSetUrl(lp_url){
  var lv_calc_url = lp_url;
  if(!lv_calc_url){ return; }
  var lv_prev_url = location.href;

  var lo_calc_url = new URL(lv_calc_url);
  var lo_actual_url = new URL(lv_prev_url);

  // compara pathname y query params de la nueva url con la actual 
  var lv_state = {prev_url: lv_prev_url, current_url: lv_calc_url, current_title: $("#pageTab > .active > :first").text()};
  if(lo_actual_url.pathname != lo_calc_url.pathname || lo_actual_url.href.slice(lo_actual_url.href.indexOf("?")) != lo_calc_url.href.slice(lo_calc_url.href.indexOf("?"))){
    if(lv_prev_url[lv_prev_url.length-1] == "#"){
      lv_prev_url = lv_prev_url.substring(0, lv_prev_url.length-1);
      lv_state["prev_url"] = lv_prev_url;
      history.replaceState(lv_state, "", lo_calc_url);
    }else{
      history.pushState(lv_state, "", lo_calc_url);
    }
  }
}


function getHeaders(){
  var lv_svnme = location.host.split(".").map((e) => e.charAt(0).toUpperCase() + e.slice(1)).join(".");
  return {[lv_svnme+".Usrcod"]: localStorage.getItem(lv_svnme+".Usrcod"),
           [lv_svnme+".Usrtkn"]: localStorage.getItem(lv_svnme+".Usrtkn"),
           "Tmss-From-Menu": "X"};
}

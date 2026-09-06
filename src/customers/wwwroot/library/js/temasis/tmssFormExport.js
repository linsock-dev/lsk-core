/* ***********************************************************************************
	
	Funciones para la visualización de una pantalla para indicar el formato de exportación
	
	Change Log
	----------
	
	version: 2.0.1
	* version inicial.
	
*********************************************************************************** */

/*
	parámetros:
		lp_expfmt: formatos de exportación habilitados [expttl=titulo, expcod=codigo, expclsicn=icono (clase) ]
		lp_callback: funcion de respuesta
*/
function tmssShowExportDialog( lp_expfmt, lp_expcmt, lp_callback ) {

		var lv_expcod; var lv_expttl; var lv_expicn;
		var lv_chr39 = String.fromCharCode(39);
		var lv_buffer = "<div class='container-fluid'><div class='list-group'>";
		
		// armo la pantalla de opciones de exportacion
		for(var i=0; i<lp_expfmt.length; i++ ){
			lv_expttl = lp_expfmt[i]["expttl"];
			lv_expcod = lp_expfmt[i]["expcod"];
			lv_expicn = lp_expfmt[i]["expicn"];
			lv_buffer += "<a href='#' class='list-group-item' name='expoptbtn' data-expcod='"+lv_expcod+"'><span class='"+lv_expicn+"'></span> "+lv_expttl+"</a>";
		}
		lv_buffer += "</div>";
		lv_buffer += lp_expcmt;
		lv_buffer += "</div>";
		
		// muestro el cuadro de dialogo
		BootstrapDialog.show({
			title: "Exportar",
			message: $(lv_buffer),
			onshow: function(dialog) {
								var lv_frm = dialog.getModalBody();
								
								// cambio en algun atributo del filtro
								$(lv_frm).find("a[name='expoptbtn']").on("click",function(){
									var lv_data = $(this).data("expcod");
									if(typeof lp_callback=="function"){ lp_callback( lv_data ); }
									dialog.close();
								});
								
							},
			buttons: [{ label: "Cancelar", cssClass: "btn-default", 
									action: function(dialogItself){
														dialogItself.close(); 
													}
								}]
		});
}
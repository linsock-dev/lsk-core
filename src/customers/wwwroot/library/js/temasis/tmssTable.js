/*
	Change Log -
  --------- 
  Versión 1.0.9:
   - se creó la función getValuesAtRowProp() para obtener el valor de una columna específica de una fila.
   - se modificó getValuesAtRow() para:
     -- manejar correctamente la fila de creación (-1),
     -- devolver los datos de filas en edición (#datedt) y filas guardadas (#dat).
   - se agregó el valor por defecto -1 en #visualIndexToId() si el índice no existe.
  
  versión 1.0.8: 
   - se corrigió la obtención del valor de cada celda al añadir una nueva fila.
   - ahora los toggles vuelven a estar desactivados luego de añadir una nueva fila.
   
  versión 1.0.7: 
   - se modifica grabado de cambios al editar para grabar los valores de toggles.
   - se modifica el añadir datos a la tabla manualmente para recuperan correctamente el valor de toggles.
   - se revierte getData() gracias a lo anterior.
   - se modifica el seteo de los valores para toggles en su checkbox, en displayData() y refreshRowData()
   
  versión 1.0.6: 
   - se modifica setEditValues() para:
   	-- mostrar únicamente los valores cambiados
    -- añadir registros al datedt si no existen
   - se modifica constructCell() para añadir la clase tmss-no-editable a los inputs no editables
  
  versión 1.0.5: 
   - se permite definir individualmente la edición por columnas. Afecta tanto para la edición como adición de filas nuevas.
   
  versión 1.0.4: 
   - se agrega la posibilidad de definir el evento onRowClick.
   - - se define de la misma manera que readonly o allowadd pero como una función que tiene como parámetro el índice de la fila
  
  versión 1.0.3: 
   - se arregla un error en getData().
  
  versión 1.0.2: 
   - se agrega la posibilidad de crear campos de tipo TOGGLE
   - se modifica la función getData() para permitir modificar el valor de salida
   - - Se modifican los valores de los toggles para devolver 1 o 0 en función de si está checkead o no
  
  versión 1.0.1: 
   - se agrega la posibilidad de crear campos de tipo BUTTON
*/

class tmssTable {
	#obj;
	#cfg;
 	#colarr;
  #btn;
  #rowfrm;
  #dat;
	#datedt;
  #rowind;
  #addval;

  constructor( lp_obj, lp_cfg ) {
    this.#obj = lp_obj;
    this.#cfg = lp_cfg;
    this.#dat = new Map();
    this.#datedt = new Map();
    this.#rowind = [];
    
		this.#setDefaultConfiguration();

    this.#rowfrm = "";
    this.#colarr = new Array(this.#cfg.columnsData.length);
    this.#cfg.columnsData.forEach((col, i)=>{ 
      // Almacenar ids
      this.#colarr[i] = col.id;
      
      // Armar estructura de fila para el cuerpo
      this.#rowfrm += this.#constructCell(col, "td");
    });
     
    // Determinar la necesidad de una botonera
    this.#btn = this.#cfg.allowAdd || 
        this.#cfg.columnsData.some(function(col){return col.editable==true}) ||
        this.#cfg.rowAction.some(function(action){return action.enabled==true;});
    
    // Añadir la tabla al objeto
    var lv_clickevt = this.#cfg.onRowClick;
    this.#obj.append("<table id='tmss-table-" + this.#obj.attr("id")+ "' class='table tmss-table "+(lv_clickevt !== undefined && lv_clickevt !== "" ? "table-hover" : "")+"'>" + this.#constructHeader() + "<tbody></tbody></table>");
		this.#loadAddRowEvent();
    this.#loadChkEvent();
    this.#loadEditEvent();
		this.#loadShowOnSelectAction();
    
    // Delegar eventos para clickear los iconos con la tecla enter
		this.#obj.on("keypress", ".tmss-table-icon", function(e){e.preventDefault;  
      if (e.which == 13) {
        $(this).click();
      }
    });
    
    // Delegar eventos para pasar al siguiente input con la tecla enter
		this.#obj.on("keypress", "input", function(e){e.preventDefault;  
      if (e.which == 13) { 
        $(this).parents("th, td").next().find("input").focus();
      }
    });
  }
  
  
  // M É T O D O S
  
  // Establece valores por defecto para cada opción de la configuración que es null o undefined.
	#setDefaultConfiguration(){ 
    // this.#cfg.readOnly == null || this.#cfg.readOnly == undefined ? false : this.#cfg.readOnly
		this.#cfg.readOnly = this.#cfg.readOnly ?? false; 
    this.#cfg.allowAdd =  this.#cfg.allowAdd ?? !this.#cfg.readOnly;
    this.#cfg.select = this.#cfg.select ?? !this.#cfg.readOnly;
    this.#cfg.headerData = this.#cfg.headerData ?? [];
    
    this.#cfg.rowAction = this.#cfg.rowAction ?? [];
    this.#cfg.rowAction.forEach(function(action, i){
      action.enabled = action?.disabled ?? true;
    });
      
    this.#cfg.columnsData = this.#cfg.columnsData ?? [];
    this.#cfg.columnsData.forEach((col, i)=>{
      // Se les asigna un número a las columnas sin id.
      col.id = col?.id ?? i.toString();
      col.type = col?.type ?? "TEXT";
      col.editable = col?.editable ?? !this.#cfg.readOnly;
      col.addable = col?.addable ?? true;
    });

    this.#cfg.showOnSelect = this.#cfg.showOnSelect ?? [];  
    this.#cfg.showOnSelect.forEach(function(elem, i){
      elem.object = elem?.object ?? "";
      elem.actionType = elem?.actionType ?? "";
    });
      
    // Validar que al showOnSelect se le haya pasado objetos jQuery.
  	this.#cfg.showOnSelect = this.#cfg.showOnSelect.filter(function(e){ return e.object instanceof jQuery && e.object.length>0 });
	}
      
      
      
	// Devuelve la estructura de la cabecera. Incluye la fila para añadir registros.
	// Devuelve: string.
  //	 Cabecera de la tabla. 
	#constructHeader(){
			var lv_thead = "<tr>";
    
      lv_thead += (this.#cfg.select ? "<th width='5%' class='text-center'><input type='checkbox'></th>" : "");

      // añadir columnas 
      this.#cfg.headerData.forEach(function(col){lv_thead+="<th style='"+(col.width ? "width: "+col.width+"; " : "") +"'>"+col.title+"</th>"})
			
      // añadir columna para botones
      lv_thead += (this.#btn ? "<th></th>" : "");
        
    	return "<thead>" + lv_thead + "</tr>" + this.#constructAddRow() + "</thead>";
	}
      
      
      
  // Devuelve la estructura de la fila con la que se añaden registros a la tabla.
  // El armado de la estructura se realiza si la configuración lo especifica.
	// Devuelve: string.
  //	 Fila para añadir o string vacío. 
  #constructAddRow(){ 
    var lv_tradd = "";
    
    if(this.#cfg.allowAdd){
    	var lv_indfrm = "";
      lv_tradd += "<tr class='tmss-tr-add'>";

      lv_tradd += (this.#cfg.select ? "<th></th>" : "");
      this.#cfg.columnsData.forEach((col, i)=>{ 
        // Armar estructura de fila para el thead
        lv_indfrm += this.#constructCell(col, "th");
      });
     	lv_tradd += lv_indfrm;
      
      // Añadir columna para botones 
      lv_tradd += '<th class="tmss-table-buttons ">'+
                      '<span class="tmss-table-add-row-btn tmss-table-icon" tabindex="0" ><i class="fas fa-check text-success"></i></span>'+
                      '<span class="tmss-table-clear-row-btn tmss-table-icon" tabindex="0" ><i class="fas fa-times tmss-table-text-danger tmss-table-text-danger"></i></span>'+
                    "</th>";
      lv_tradd += "</tr>";
    }
    
    return lv_tradd;
  }
	
      
      
  // Devuelve un tipo de celda con los datos de una columna y la envuelve en un tag.
  // Recibe:
	//	lp_col: objeto. Columna.
	// 	lp_tag: string. Tag.
	// Devuelve: string.
  //	 Elemento de celda armado.
  #constructCell = function(lp_col, lp_tag){ 
    var lv_cell = "<" + lp_tag;
    lp_col.type = lp_col.type.toUpperCase();

    switch(lp_col.type){
      case "TEXT":
        lv_cell += "><div><input type='TEXT' autocomplete='off'> ";
        break;

      case "NUMBER":
        lv_cell += "><div><input type='NUMBER' "+
                          ( lp_col.numberFormat?.min ? " min='" + lp_col.numberFormat.min + "' " : "" ) +
                          ( lp_col.numberFormat?.max ? " max='" + lp_col.numberFormat.max + "' " : "" ) +
                          ( lp_col.numberFormat?.step ? " step='" + lp_col.numberFormat.step + "' " : "" ) +
                  "> ";
        break;
 
      case "TYPEAHEAD":
        lv_cell += " class='tmss-table-input-with-icon'><div> " +
                  " <input type='TEXT' autocomplete='off'> " +
                  " <span class='hidden tmss-table-icon' tabindex='0'><a><i class='fas fa-search'></i></a></span> ";
        break;
        
      case "BUTTON":
        lv_cell += " class='text-center'> <a  href='#' onclick='' class='tmss-table-custom-button tmss-table-icon'><i class='"+lp_col.buttonFormat.icon+"'></i></a> ";
        break;
        
      case "TOGGLE":
        lv_cell += "><label class='toggle-switchy' data-size='xs' data-style='rounded' data-text='false'>"
                      +"<input type='checkbox' onchange='' >"
                      +"<span class='toggle'><span class='switch'></span></span>"
                    +"</label>";
        break;

      default:
        lv_cell += "><div>";
        break;
    }
    
		lv_cell = lv_cell + "</div></" + lp_tag + ">";
    
    // añado clase a input no editables
    if( !lp_col.editable && $(lv_cell).find("input").length > 0 ){
      lv_cell = $(lv_cell).find("input").addClass("tmss-no-editable").parents(lp_tag)[0].outerHTML;
    }
    
    return lv_cell;
  }
  
      
     
  // Devuelve el esqueleto de una fila para la tabla.
	// Devuelve: string.
  //	 Elemento de fila armada (tr).   
  #constructRow(){
    var lv_inddata = this.#rowfrm;

    // Añadir checkbox de selección
    lv_inddata = (this.#cfg.select ? "<td class='text-center'><input type='checkbox'></td>" + lv_inddata: lv_inddata);

    // Añadir botones
    lv_inddata += (this.#btn ? "<td class='tmss-table-buttons'>"+
                                "<span class='tmss-table-save-btn tmss-table-icon hidden' tabindex='0' ><i class='fas fa-check text-success'></i></span>"+
                                "<span class='tmss-table-cancel-btn tmss-table-icon invisible' tabindex='0' ><i class='fas fa-times tmss-table-text-danger'></i></span>"+
                                "<span class='tmss-table-edit-btn tmss-table-icon' tabindex='0' ><i class='fas fa-pen'></i></td></span>"+
                              "</td>" : "");

    
    
    
    lv_inddata = "<tr>"+lv_inddata+"</tr>";
    
		return lv_inddata;
  }    
      
      
      
	// Carga los eventos de la fila con la que se añaden registros a la tabla.
  // Los eventos se cargan si la configuración solicitó esta fila.
  #loadAddRowEvent(){
    if(this.#cfg.allowAdd){
			// Trigger click para añadir registro al presionar enter en el último input de la fila
      this.#obj.find(".tmss-tr-add input:last-child").keypress(function(e){
        if (e.which == 13) {
          $(this).parents("tr").find(".tmss-table-add-row-btn").click();
        }
      });

      
      // Click añadir
      this.#obj.find(".tmss-tr-add .tmss-table-add-row-btn").click((e)=>{
        var lv_addrow = $(e.currentTarget).parents("tr"); 
				var lv_newdat = {};
        
				lv_addrow.find("th").slice((this.#cfg.select ? 1 : 0), lv_addrow.find("th").length + (this.#btn ? -1 : 0)).each((j, th)=>{ 
          var lv_val;

          if($(th).find("input").is(":checkbox")){
            lv_val = $(th).find("input").is(":checked")? 1 : 0;
          }else if($(th).find("input").val() != undefined && $(th).find("input").val().trim().length){
            lv_val = $(th).find("input").val().trim();
          }

          lv_newdat[this.#colarr[j]] = lv_val;
        });
        
        if(!jQuery.isEmptyObject(lv_newdat)){
          this.#setValuesToAdd( lv_newdat );
          this.addData( this.#addval );
        }
        lv_addrow.find("input").val("");
        lv_addrow.find(":checkbox").val("0").prop("checked", false);
        lv_addrow.find("input:first").focus();
      });

      
      // Click cancelar
      this.#obj.find(".tmss-tr-add .tmss-table-clear-row-btn").click((e)=>{
        $(e.currentTarget).parents(".tmss-tr-add").find("input").val("");
        // Vaciar para el próximo añadir
        for(let prop in this.#addval){
          this.#addval[prop] = "";
        }
      });
    }
  }
  
      
      
	// Carga los eventos de checkbox.
  // Los eventos se cargan si la configuración lo solicita.
  #loadChkEvent(){
    if( this.#cfg.select || this.#cfg.columnsData.some(function(col){return col.type.toUpperCase()=="CHECKBOX"}) ){
      // Click checkbox de cabecera
      this.#obj.find("thead").on("click", "tr:first-of-type input[type='checkbox']", (e)=>{e.preventDefault; 
        var lv_chkcol = 0;

        // Obtener la columna del check
        lv_chkcol = this.#obj.find("thead tr:first-of-type input[type='checkbox']").index($(e.currentTarget));

        // Cambiar el valor de los checks de esa columna
        this.#obj.find("tbody tr").each(function(i, elem){
          $(elem).find("input[type='checkbox']").eq(lv_chkcol).prop("checked", $(e.currentTarget).prop("checked")).change();
        });
      });

      
      // Click checkboxs del cuerpo
      this.#obj.find("tbody").on("click","tr input[type='checkbox']", (e)=>{e.preventDefault;
        var lv_chkcol = 0;

        // Obtener la columna del check
        lv_chkcol = $(e.currentTarget).parents("tr").find("input[type='checkbox']").index($(e.currentTarget));

        // Cambiar valor de check de cabecera (verifica el valor de todos los checks de esa columna)
        this.#obj.find("thead tr:first-of-type input[type='checkbox']").eq(lv_chkcol).prop("checked", 
          !this.#obj.find("tbody tr").toArray().some(function(tr){ return !$(tr).find("input[type='checkbox']").eq(lv_chkcol).prop("checked") })
        );
      });
    }
  }
  
      

  // Carga los eventos de edición.
  // Los eventos se cargan si la configuración lo solicita.    
	#loadEditEvent(){
    if(this.#cfg.columnsData.some(function(col){return col.editable==true})){
      // Trigger click para guardar cambios al presionar enter en el último input de la fila
      this.#obj.on("keypress", ".tmss-tr-edit div input:last-child", function(e){
        if (e.which == 13) { 
          $(this).parents("tr").find(".tmss-table-save-btn").click();
        }
      });
      
      // Click activar editar
      this.#obj.find("tbody").on("click", ".tmss-table-edit-btn", (e)=>{e.preventDefault;  
        var lv_visualind = this.#obj.find("tbody tr").index($(e.currentTarget).parents("tr"));                                                       
				this.#toggleEdit($(e.currentTarget).parents("tr")); 
        // Cargar los valores actuales de la fila                                                        
        this.#setEditValues(this.#visualIndexToId(lv_visualind), this.getValuesAtRow(lv_visualind)); 
      });
      
      
      // Click grabar cambios 
      this.#obj.find("tbody").on("click", ".tmss-table-save-btn", (e)=>{
        e.preventDefault;  
        
        var lv_currow = $(e.currentTarget).parents("tr"); 
        var lv_visualind = this.#obj.find("tbody tr").index(lv_currow); 
				var lv_newdat = {};
        
        // obtiene todos los valores de las columnas (visuales) de la fila
				lv_currow.find("td").slice((this.#cfg.select ? 1 : 0), (this.#btn ? lv_currow.find("td").length-1 : lv_currow.find("td").length)).each((j, td)=>{
          var lv_val;
          
          if($(td).find("input").is(":checkbox")){
            lv_val = $(td).find("input").is(":checked")? 1 : 0;
          }else{
            lv_val = $(td).find("input").val();
          }
          
          lv_newdat[this.#colarr[j]] = lv_val;
        });
				
        this.#setEditValues( this.#visualIndexToId(lv_visualind), lv_newdat );
        this.setValuesAtRow(lv_visualind, this.#datedt.get(this.#visualIndexToId(lv_visualind)));
				this.#datedt.delete(this.#visualIndexToId(lv_visualind));
                                                               
				this.#toggleEdit(lv_currow);                                                           
      });

      
      // Click cancelar
      this.#obj.find("tbody").on("click", ".tmss-table-cancel-btn", (e)=>{e.preventDefault;  
        var lv_visualind = this.#obj.find("tbody tr").index($(e.currentTarget).parents("tr"));   
				this.#toggleEdit($(e.currentTarget).parents("tr")); 
      	this.refreshRowData(lv_visualind);
        this.#datedt.delete(this.#visualIndexToId(lv_visualind));
      });
    }
  }
    
      
      
  // Carga los objetos (y sus acciones) que se mostrarán cuando haya, mínimamente, una fila seleccionada.  
  // Las acciones se cargan como la configuración lo solicita.    
  #loadShowOnSelectAction(){
    if(this.#cfg.select && this.#cfg.showOnSelect.length > 0){
      // Change checkbox para mostrar u ocultar
      this.#obj.find("tbody").on("change", "td:first-child input[type='checkbox']", (e)=>{e.preventDefault;
        if(this.#obj.find("tbody td:first-child input[type='checkbox']:checked").length > 0){
          this.#cfg.showOnSelect.forEach((elem)=>{elem.object.removeClass("invisible")});
        } else {
          this.#cfg.showOnSelect.forEach((elem)=>{elem.object.addClass("invisible")});
        }	
      });
      
      // Establecer acción
      this.#cfg.showOnSelect.forEach((elem)=>{
        elem.object.addClass("invisible");
        switch(elem.actionType.toUpperCase()){
          case "DELETE":
            this.setDeleteAction(elem.object);
            
            break;
            
          default:
            break;
        }
    	});
    }else{
    	if(this.#cfg.showOnSelect.length > 0){
      	this.#cfg.showOnSelect.forEach(function(elem){
        	elem.object.addClass("invisible");
        });
      }
    }
  }
    
   
      
  // Carga las funciones para una celda según la configuración.
  // Carga datos por default
  // Recibe:
	//	lp_ind: int. Índice visual.
  //	lp_col: string. Número de columna.
  //  lp_cell: objeto jQuery. Celda.  
	#loadCellFunctions(lp_ind, lp_col, lp_cell){
    var lv_clickevt = this.#cfg.onRowClick;
    if(lp_col === 0 && lv_clickevt !== undefined && lv_clickevt !== ""){
      $(lp_cell).parent("tr").click( () => {lv_clickevt(lp_ind)} );
    }
    
  	var lv_typ = this.#cfg.columnsData[lp_col].type.toUpperCase();
    switch(lv_typ){
      case "TYPEAHEAD":
        this.#setTypeahead(lp_ind, this.#colarr[lp_col], lp_cell, this.#cfg.columnsData.find(col => col.id == this.#colarr[lp_col]).typeahead);
        break;
        
      case "BUTTON":
        this.#setButtonAction(lp_ind, this.#colarr[lp_col], lp_cell, this.#cfg.columnsData.find(col => col.id == this.#colarr[lp_col]).onClick);
        break;
        
      case "TOGGLE":
        this.#setToggleAction(lp_ind, this.#colarr[lp_col], lp_cell, this.#cfg.columnsData.find(col => col.id == this.#colarr[lp_col]).onChange);
        break;
        
      default:
        break;
    }
  }   
  
      
   
  // Actualiza la fila para añadir datos.
  #refreshAddData(){ 
    var lv_tharr = this.#obj.find("thead tr").eq(1).children("th"); 

    lv_tharr.slice((this.#cfg.select ? 1 : 0), (this.#btn ? lv_tharr.length-1 : lv_tharr.length)).each((j, th)=>{
      $(th).children().first().val(this.#addval[this.#colarr[j]]);
    });
  }     
      
      
      
  // Carga los valores en un array de datos a añadir.   
  // Recibe:
	//	lp_obj: objeto. Objeto con valores para añadir. 
  #setValuesToAdd(lp_obj){ 
    for(let prop in lp_obj){
      this.#addval[prop] = lp_obj[prop] ?? this.#addval[prop];
    }
      
		// Muestra los valores en la fila    
    var lv_cellarr = this.#obj.find("thead tr:nth-child(2)").children("th");
    lv_cellarr = lv_cellarr.slice((this.#cfg.select ? 1 : 0), (this.#btn ? lv_cellarr.length-1 : lv_cellarr.length));
    for(let i=0; i < lv_cellarr.length; i++){
      if(lp_obj[this.#colarr[i]] != undefined){
        $(lv_cellarr.get(i)).find("input").val(lp_obj[this.#colarr[i]]);
      }
    }
      
    /*
    lv_cellarr.slice((this.#cfg.select ? 1 : 0), (this.#btn ? lv_cellarr.length-1 : lv_cellarr.length)).each((j, th)=>{
      $(th).find("input").val(this.#addval[this.#colarr[j]]);
    });
    */
  }  

    
  
  // Carga los valores que se introducen al editar una fila.   
  // Recibe: 
  //	lp_ind: int. Id de fila. 
	//	lp_obj: objeto. Objeto con valores para modificar.
  #setEditValues(lp_ind, lp_obj){  
    var lv_row = [];
    for(let prop in lp_obj){
      lv_row[prop] = lp_obj[prop] ?? this.#datedt.get(lp_ind)[prop];
    }
      
    // Añade registro por si no existe en el id especificado
    if(this.#datedt.get(lp_ind) == undefined){
      this.#datedt.set(lp_ind, {});
    }
      
   	this.#datedt.set(lp_ind, 	Object.assign(this.#datedt.get(lp_ind), lv_row));
    
		// Muestra los valores en la fila    
    var lv_cellarr = this.#obj.find("tbody tr").eq(this.#rowind.indexOf(lp_ind)).children("td"); 
    lv_cellarr = lv_cellarr.slice((this.#cfg.select ? 1 : 0), (this.#btn ? lv_cellarr.length-1 : lv_cellarr.length));
    for(let i=0; i < lv_cellarr.length; i++){
      if(lp_obj[this.#colarr[i]] != undefined){
        $(lv_cellarr.get(i)).find("input").val(lp_obj[this.#colarr[i]]);
      }
    }
      
    /*
    lv_cellarr.slice((this.#cfg.select ? 1 : 0), (this.#btn ? lv_cellarr.length-1 : lv_cellarr.length)).each((j, td)=>{
      $(td).find("input").val(this.#datedt.get(lp_ind)[this.#colarr[j]]);
    });*/
  }    
      
    
    
  // Carga la configuración de typeahead para una celda.
  // Recibe:
	//	lp_ind: int. Índice visual.
  //	lp_prop: string. Propiedad.
  //  lp_cell: objeto jQuery. Celda.
  //  lp_cfg: función. Función opción del typeahead.
  #setTypeahead(lp_ind, lp_prop, lp_cell, lp_cfg){ 
    var lv_asgarr = [];
    var lv_cfg = lp_cfg.apply({row: lp_ind, prop: lp_prop, cell: lp_cell, id:this.#visualIndexToId(lp_ind)}, [lp_cell.is("td")?this.getValuesAtRow(lp_ind):this.#addval]);
		var lv_asg = lv_cfg.data.fldasg;
    var lo_dat = lv_cfg.data;
    var lo_clb = {"afterAssign": data=>{ 
																			var lv_data = data.data != undefined ? data.data : data;
                                      for(let key in lv_asg) { 
                                        var lv_data_val = lv_data[lv_asg[key]];
                                        lv_asgarr[key] = lv_data_val;
                                      }
      																if(lp_cell.is("td")){
                                      	this.#setEditValues(this.#visualIndexToId(lp_ind), lv_asgarr);
                                      }else{
                                        this.#setValuesToAdd(lv_asgarr);
                                        this.#refreshAddData();
                                      }
                                    }
                };
    lo_dat.fldasg = {};
		lo_dat.popup = false; 	// Deshabilitar lupa
    tmssTypeahead(lp_cell.find("input"), lv_cfg.definition, lo_dat, lo_clb);	
  }
    
    
  // Carga la acción de un botón para una celda.
  // Recibe:
	//	lp_ind: int. Índice visual.
  //	lp_prop: string. Propiedad.
  //  lp_cell: objeto jQuery. Celda.
  //  lp_cfg: función. Función que se ejecuta en el onClick.
  #setButtonAction(lp_ind, lp_prop, lp_cell, lp_cfg){ 
    var lv_asgarr = [];
    $(lp_cell).find("a").unbind();
    $(lp_cell).find("a").click(function(){
      // reemplaza @@ROW por el número de fila y @@COL por el prop de la columna
      eval("("+lp_cfg.toString().replace(new RegExp("@@ROW", "g"), lp_ind).replace(new RegExp("@@COL", "g"), lp_prop)+")()");
    })
  }
    
  
  // Carga la acción de un toggle para una celda.
  // Recibe:
	//	lp_ind: int. Índice visual.
  //	lp_prop: string. Propiedad.
  //  lp_cell: objeto jQuery. Celda.
  //  lp_cfg: función. Función que se ejecuta en el onChange.
  #setToggleAction(lp_ind, lp_prop, lp_cell, lp_cfg){ 
    var lv_asgarr = [];
    var lv_readonly = this.#cfg.readOnly;
    $(lp_cell).find("input").unbind();
    $(lp_cell).find("input").on("click", function(e){ 
      if(lp_cfg == "" || lp_cfg == undefined){
          //if(this.readOnly){ this.checked=!this.checked; } (this.checked ? this.value=1 : this.value=0);"
        if( lv_readonly ){ this.checked=!this.checked; }
      }else{
        // reemplaza @@ROW por el número de fila y @@COL por el prop de la columna
        // esto se debería hacer en su lugar
        lp_cfg.apply({row: lp_ind, prop: lp_prop, cell: lp_cell});
      }
    })
  }
    
    
    
 	// Convierte un índice visual al id de la fila almacenada.
  // Recibe:
	//	lp_ind: int. Índice visual.
	// Devuelve: int.
  //		Id.     
  #visualIndexToId(lp_ind){
    return this.#rowind[lp_ind] ?? -1;
  }    
      
    
    
  // Toggle entre activar y desactivar la edición de una fila.
  // Recibe:
	//	lp_tr: objeto jQuery. Tr de la fila.
  #toggleEdit(lp_tr){ 
    // Cambia el readonly solo de las columnas con editable true.
    lp_tr.find("td").slice((this.#cfg.select ? 1 : 0), (this.#btn ? lp_tr.find("td").length-1 : lp_tr.find("td").length)).each((i, td)=>{ 
      if(this.#cfg.columnsData[i].editable){
        $(td).find("input").prop("readonly", !$(td).find("input").prop("readonly"));
      }
    });
    lp_tr.find(".tmss-table-save-btn, .tmss-table-edit-btn").toggleClass("hidden");
    lp_tr.find(".tmss-table-cancel-btn").toggleClass("invisible");   
    lp_tr.toggleClass("tmss-tr-edit"); 
    lp_tr.find("input:not(.tmss-no-editable):first").focus();
  }
    
    
    
  // Inserta una fila en un índice visual.
  // Recibe:
  // 	lp_ind: int. Índice visual.
  #addVisualRow( lp_ind ){ 
    var lv_inddata = this.#constructRow();
    var lv_currow; 

    // Añadir la fila
    if(this.#obj.find("tbody tr").length > 0){
      if(lp_ind == this.#obj.find("tbody tr").length){
        lv_currow = $(lv_inddata).insertAfter(this.#obj.find("tbody tr").last());
      }else{
        lv_currow = $(lv_inddata).insertBefore(this.#obj.find("tbody tr").eq(lp_ind));
      }
  	}else{
    	lv_currow = $(lv_inddata).appendTo(this.#obj.find("tbody"));   
    }
    
    // Agregar los datos y funciones 
    lv_currow.find("td").slice((this.#cfg.select ? 1 : 0), (this.#btn ? lv_currow.find("td").length-1 : lv_currow.find("td").length)).each((j, td)=>{
      var lv_val = this.#dat.get(this.#rowind[lp_ind])[this.#colarr[j]];
      if($(td).find("input").is(":checkbox")){
        $(td).find("input").prop("checked", lv_val);
      }else{
      	$(td).find("input").val(lv_val); 
      }
      this.#loadCellFunctions(lp_ind, j, $(td));
    });
    
    // Poner readonly a todos los inputs porque solo pueden ser editados al presionar el lápiz
    lv_currow.find("input").prop("readonly", true);
    
    this.#updateRowEvents(this.#obj.find("tbody"));
  }  
    
  
  // Actualiza los eventos de cada fila de la tabla, incluida la fila addrow
  // Recibe:
  // 		lp_ele. Elemento con el body de la tabla
  #updateRowEvents(lp_ele){
    self = this;
    var lp_index = 0;
    
    // recorre todas las filas del body y les reasigna eventos
		$(lp_ele).find("tr").each(function(index){
      $(this).find("td").slice((self.#cfg.select ? 1 : 0), (self.#btn ? $(this).find("td").length-1 : $(this).find("td").length)).each((j, td)=>{
        $(td).find("input").val(self.#dat.get(self.#rowind[index])[self.#colarr[j]]);
        self.#loadCellFunctions(index, j, $(td));
      });
      lp_index = index;
    });
    
    // le reasigna eventos a la fila de cabecera que se utiliza para añadir nuevas filas
    $(lp_ele).parent().find("thead>tr.tmss-tr-add").find("th").slice((self.#cfg.select ? 1 : 0), (self.#btn ? $(lp_ele).parent().find("thead>tr.tmss-tr-add").find("th").length-1 : $(lp_ele).parent().find("thead>tr.tmss-tr-add").find("th").length)).each((j, th)=>{
      //$(th).find("input").val(self.#dat.get(self.#rowind[lp_index + 1])[self.#colarr[j]]);
      self.#loadCellFunctions(lp_index + 1, j, $(th));
    });
  }
      
  // Muestra en la tabla los datos almacenados.
  // No son mostrados aquellos datos con la propiedad "deleted".
  displayData(){  
  	var lv_inddata = this.#constructRow();
    var lv_currow; 
    
		// Vaciar tabla
		this.#obj.find("tbody tr").remove();

    for(var i = 0; i < this.#rowind.length; i++){
    	if(this.#dat.get(this.#rowind[i]).deleted != "X"){
        // Añadir fila
        this.#obj.find("tbody").append(lv_inddata);
        lv_currow = this.#obj.find("tbody tr:last-child");
        // Agregar datos
        lv_currow.find("td").slice((this.#cfg.select ? 1 : 0), (this.#btn ? lv_currow.find("td").length-1 : lv_currow.find("td").length)).each((j, td)=>{
          if(this.#cfg.columnsData[j].type == "TOGGLE"){
            if(this.#dat.get(this.#rowind[i])[this.#colarr[j]] == "1"){ $(td).find("input[type=checkbox]").prop("checked", true); }
          }else{
          	$(td).find("input").val(this.#dat.get(this.#rowind[i])[this.#colarr[j]]);
          }
          this.#loadCellFunctions(i, j, $(td));
        });
      }
    }
      
    // Cargar funciones para celdas de la fila para añadir
    if(this.#obj.find("thead tr").eq(1)){
      var lv_addrow = this.#obj.find("thead tr").eq(1);
      lv_addrow.find("th").slice((this.#cfg.select ? 1 : 0), (this.#btn ? lv_addrow.find("td").length-1 : lv_addrow.find("td").length)).each((j, th)=>{
        this.#loadCellFunctions(i, j, $(th));
      });
    }
    
    // Poner readonly a todos los inputs porque solo pueden ser editados al presionar el lápiz
    this.#obj.find("tbody input").prop("readonly", true);    
    // Pone readonly a las celdas de columnas con editable false en la fila para agregar registros.
    this.#obj.find(".tmss-tr-add th").slice((this.#cfg.select ? 1 : 0), (this.#btn ? this.#obj.find(".tmss-tr-add th").length-1 : this.#obj.find(".tmss-tr-add th").length)).each((i, th)=>{ 
      $(th).find("input").prop("readonly", !this.#cfg.columnsData[i].editable);
    });
  }
      
      
      
  // Actualiza una fila según los datos almacenados.
  // Recibe:
  // 	lp_ind: int. Índice visual.  
  refreshRowData(lp_ind){ 
    if(lp_ind >= 0 && lp_ind < this.#rowind.length){
      var lv_tdarr = this.#obj.find("tbody tr").eq(lp_ind).children("td"); 

      lv_tdarr.slice((this.#cfg.select ? 1 : 0), (this.#btn ? lv_tdarr.length-1 : lv_tdarr.length)).each((j, td)=>{
        var lv_val = this.#dat.get(this.#rowind[lp_ind])[this.#colarr[j]]; 
        if($(td).find("input").is(":checkbox")){
          $(td).find("input").prop("checked", lv_val);
        }else{
          $(td).find("input").val(lv_val); 
        }
      });
    }  
  } 
    
      
      
  // Inserta una o más filas desde un índice visual.
  // Recibe:
	//	lp_dat: array de objetos o un objeto. Datos.
  // 	lp_ind: int. Índice visual.
  addData( lp_dat, lp_ind = 0 ){    
    var lv_len = this.#dat.size;
    var lv_dat = ( Array.isArray(lp_dat) ? lp_dat : [lp_dat] );
		lp_ind = ( lp_ind < 0 ? 0 : ( lp_ind >= lv_len ? lv_len : lp_ind ) );
    
    // Guardar cada elemento como fila y asignar un id
    lv_dat.forEach((row)=>{
      this.#dat.set(lv_len, Object.assign({}, row));
      // Insertar los id de las nuevas filas desde el índice visual
      this.#rowind.splice(lp_ind, 0, lv_len);
      this.#addVisualRow(lp_ind);
      lp_ind++;
      lv_len++;
    });
    
    // Vaciar para el próximo añadir
    for(let prop in this.#addval){
      this.#addval[prop] = "";
    }
  }  
      
    
    
 	// Carga los datos reemplazando los valores existentes de la tabla.
  // Recibe:
	//	lp_dat: array de objetos. Datos.
  loadData( lp_dat ){   
    this.#rowind = new Array(lp_dat.length);

    // Guardar cada elemento como fila y asignar un id
    lp_dat.forEach((row, i)=>{
    	this.#dat.set(i, row);
      this.#rowind[i] = i;
    });
    
    // Grabar propiedades a tener en cuenta al añadir una fila
    this.#addval = Object.assign({}, this.#dat.get(this.#rowind[0]));
    for(let prop in this.#addval){
      this.#addval[prop] = "";
    }
    
    this.displayData();
  }
      
      
      
  // Cambia el valor de la celda de una fila.
  // Recibe:
	//	lp_ind: int. Índice visual.  
  //	lp_prop: string. Propiedad (celda).    
	//	lp_val: valor.    
  setValueAtRowProp( lp_ind, lp_prop, lp_val ){
    if(lp_ind >= 0 && lp_ind < this.#rowind.length){
      this.#dat.get(this.#rowind[lp_ind])[lp_prop] = lp_val;
    	this.refreshRowData(lp_ind);
    }
  }
  
      
      
  // Cambia múltiples valores de una fila.
  // Recibe:
	//	lp_ind: int. Índice visual.  
  //	lp_dat: objeto. Propiedades de la fila junto a sus valores.   
  setValuesAtRow( lp_ind, lp_dat ){ 
    if(lp_ind >= 0 && lp_ind < this.#rowind.length){
      for(let prop in lp_dat){
        this.#dat.get(this.#rowind[lp_ind])[prop] = lp_dat[prop];
      }
                                                    
    	this.refreshRowData(lp_ind);
    }
  }
      
      
      
  // Borra una o más filas de la tabla, dados sus índices visuales.
  // Recibe:
	//	lp_inds: array de ints. Índices visuales.
  deleteData( lp_inds ){    
    lp_inds.forEach((i)=>{
      if(i >= 0 && i < this.#rowind.length){
        this.#dat.get(this.#rowind[i]).deleted = "X";
        this.#rowind[i] = -1;
      }
    });
    
		// Quitar índice
		this.#rowind = this.#rowind.filter(function(e){ return e!=-1; });
    
    this.removeVisualRow(lp_inds);
  }
  
  
    
	// Quita una o más filas de la tabla, dados sus índices visuales.
  // No borra los datos almacenados en la instancia.
  // Recibe:
	//	lp_inds: array de ints. Índices visuales.  
  removeVisualRow( lp_inds ){
    this.#obj.find("tbody tr").filter(function(i){
      return lp_inds.indexOf(i) > -1;
    }).remove();
  } 
    
      
      
  // Establece la acción de eliminar sobre un objeto jQuery. 
  // Son eliminadas las filas seleccionadas.
  // Recibe:
	//	lp_obj: objeto jQuery. Elemento sobre el que se añadirá el evento click.    
	setDeleteAction( lp_obj ){ 
    lp_obj.click((e)=>{e.preventDefault; 
      var lv_delarr = this.#obj.find("tbody td:first-child input[type='checkbox']:checked").click().closest("tr");
      var lv_indarr = new Array(lv_delarr.length);
			
			lv_delarr.each((i, row)=>{
        lv_indarr[i] = this.#obj.find("tbody tr").index(lv_delarr[i]);
      })
                       
			this.deleteData(lv_indarr);
    });
  }    

      
      
  // G E T T E R S
      
  
  
  // Devuelve las filas eliminadas.
	// Devuelve: array.
  //		Filas eliminadas.    
  getDeleted(){               
    var lv_deldat = [];
    
    this.#dat.forEach((row)=>{
    	if(row.deleted == "X"){
      	lv_deldat.push(row);
      }
    });
    
    return lv_deldat;
  }
  
      
      
  // Devuelve todas las filas, excluyendo las eliminadas.
	// Devuelve: array.
  //		Filas.    
  getData(){  
    var lv_dat = [];
    
    this.#dat.forEach((row, index)=>{
    	if(!row.deleted){
      	lv_dat.push(row);
      }
    });
    
    return lv_dat;
  }
  
      
      
  // Devuelve los datos almacenados de una fila.
  // Recibe:
	//		lp_ind: int. Índice visual.
	// Devuelve: objeto.
  //		Datos de la fila.    
  getValuesAtRow( lp_ind ){  
    // En caso de la fila de creación
		if (lp_ind == -1) {
    	return Object.assign({}, this.#addval);
  	}
    
    if (lp_ind < 0 || lp_ind >= this.#rowind.length) return {};
    
    var row_id = this.#rowind[lp_ind];
    
    // Si el registro está en edición, lo devuelve
    if (this.#datedt.has(lp_ind)) {
      return Object.assign({}, this.#datedt.get(lp_ind));
    }	
    // Si no, busca en los datos guardados
    if (this.#dat.has(row_id)) {
      return Object.assign({}, this.#dat.get(row_id));
    }
  }
    
    
  	
  // Devuelve el valor de una propiedad específica de una fila.
  // Recibe:
  //    lp_ind: int. Índice visual de la fila o -1 para la fila de añadir.
  //    lp_prop: string. Nombre de la propiedad (columna).
  // Devuelve:
  //    Valor de la propiedad o undefined.
  getValuesAtRowProp( lp_ind, lp_prop ){
    return this.getValuesAtRow(lp_ind)[lp_prop];
  }
      
      
      
  // Devuelve todas las filas en formato JSON.
	// Devuelve: JSON.
  //		Filas.    
  getAllJsonData(){    
    return JSON.stringify(this.getData().concat(this.getDeleted()));
  }
 
}
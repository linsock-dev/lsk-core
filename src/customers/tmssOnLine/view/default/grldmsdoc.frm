<?php
	// url del formulario
  $lv_lnk = '?prg=grldmsdoc';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = $vew_data->grldmsdoccod;

	// titulo
	$lv_title = $vew_lang->documents;
	
	// módulo y programa
	$lv_mdlcod = 'GRL';
	$lv_prgcod = 'DMS';
	
	$vew_actcod= '08';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
	
	$vew_tbl['canc'] = array('per'=>false);
	$vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['new'] = array('per'=>false);
	$vew_tbl['sveL'] = array('per'=>false);
	$vew_tbl['sveR'] = array('per'=>false);
	$vew_tbl['rfrsh'] = array('acc'=>$lv_sec.'_fnc({action: '.chr(39).'08'.chr(39).'});');


//	<a href="#" class="card-icon d-none" id="btnaddfle" title="Subir archivo"><i class="far fa-plus"></i></a>
	
	$lv_htm = '<li class="dropdown">'
          .'<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><i class="far fa-plus"></i> '.$vew_lang->new.' <span class="caret"></span></a>'
          .'<ul class="dropdown-menu">'
            .'<li><a href="#" id="btnaddfld"><i class="far fa-folder"></i> '.$vew_lang->folder.'</a></li>'
            .'<li><a href="#" id="btnaddfle"><i class="far fa-file"></i> '.$vew_lang->attachment.'</a></li>'
    			.'</ul>'
        .'</li>';
	$vew_tbl[] = array('pos'=>'L', 'per'=>true, 'htm'=>$lv_htm);	

	$vew_tbl[] = array('pos'=>'R', 'per'=>true, 'ttl'=>'', 'id'=>'btnflt', 'icn'=>'far fa-filter', 'css'=>'btn navbar-btn tmssAlwaysEnabled tmss-navbar-btn', 'acc'=>'');	

	$vew_tbl[] = array('pos'=>'D', 'per'=>true, 'ttl'=>'', 'id'=>'btndelfld', 'icn'=>'far fa-trash', 'css'=>'btn navbar-btn tmssAlwaysEnabled tmss-navbar-btn', 'acc'=>'', 'ttl'=>'Borrar Carpeta');	
	$vew_tbl[] = array('pos'=>'D', 'per'=>true, 'css'=>'divider');	
	$vew_tbl[] = array('pos'=>'D', 'per'=>true, 'ttl'=>'', 'id'=>'btndwnfld', 'icn'=>'far fa-download', 'css'=>'btn navbar-btn tmssAlwaysEnabled tmss-navbar-btn', 'acc'=>'', 'ttl'=>'Descargar todo');	
	$vew_tbl[] = array('pos'=>'D', 'per'=>true, 'css'=>'divider');	
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm');  ?>    
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		
    <div class="container-fluid" role="tabpanel">
			<div class="row">
				<div class="col-md-4">
				
          <textarea class="d-none" id="grldmsdoc" name="grldmsdoc"></textarea>
					<div class="card">
						<div class="card-header"><div class="card-title">
							<a href="#" class="card-icon d-none" id="btndelfld" title="Borrar"><i class="far fa-trash"></i></a>
							<a href="#" class="card-icon d-none" id="btnedt" title="Renombrar"><i class="far fa-pencil"></i></a>
							<a href="#" class="card-icon" id="btnaddfld" title="Nueva carpeta"><i class="far fa-plus"></i></a>
						</div></div>
						<div class="card-body" id="fldtrecnt">
							<div id="fldtrediv" style="height:calc(100vH - 270px);">
								<?php
									$lv_trearr = $vew_dathdr['trearr'];
									if (isset($lv_trearr['errcod']) && $lv_trearr['errcod'] != 0){
										echo "<script>
														toastr.warning('El documento seleccionado no existe o fue eliminado.', 'Error');
													</script>";
									}else{
										//echo '<ul>'.treeLoop(json_decode($lv_trearr, true)['CenDoc'], 0, $vew_sec).'</ul>';;
										echo '<ul>'.treeLoop(json_decode($lv_trearr, true)['BusDoc'], 0, $vew_sec).'</ul>';
									}
									// recursiva para el armado de arbol de documentos
									function treeLoop(&$lp_object, $lp_srckey, $vew_sec){
										$lv_out = '';
										// recorro todos los nodos
										foreach ($lp_object as &$lv_row){
											$lv_docatr = json_decode(html_entity_decode($lv_row['grldmsdocatr']), true);
											$lv_doctyp = isset($lv_docatr['srcobjtyp']) ? $lv_docatr['srcobjtyp'] : '';
											$lv_per = $lv_doctyp != '' ? ( $vew_sec->hasPermission(explode('_',$lv_doctyp)[0],explode('_',$lv_doctyp)[1],'03') ? 'Y' : 'N' ) : '';
											// reviso si el nodo todavía no fue procesado y si su carpeta de origen coincide con el SrcKey enviado
											if( $lv_row['verificado']!=1 && $lp_srckey==$lv_row['GrlDmsFldCod'] ){
                        $lv_row['GrlDmsDocTxt'] = htmlspecialchars($lv_row['GrlDmsDocTxt'], ENT_QUOTES, 'UTF-8');
												$lv_out .= '<li><a href="#" data-nodtyp="'.$lv_row['GrlDmsDocSrc'].'" data-srcobjtyp="'.$lv_doctyp.'" data-grldmsdoccod="'.$lv_row['GrlDmsDocCod'].'" data-srcobjcod="'.$lv_row['SrcObjCod'].'" data-srcobjact="'.(isset($lv_docatr['srcclscod'])??'').'" data-permission='.$lv_per.'>'.$lv_row['GrlDmsDocTxt'].'</a>';
												$lv_row['verificado'] = 1;
												// busco si hay nodos dependientes
												$lv_list = treeLoop($lp_object, $lv_row['GrlDmsDocCod'], $vew_sec);
												// si hay nodos dependientes, los agrego como lista
												if ($lv_list!=''){ $lv_out.='<ul>'.$lv_list.'</ul>'; }
												$lv_out .= '</li>';
											}
										}
										unset($lv_row);
										return $lv_out;
									}
								?>
							</div>
										
						</div>
					</div>
				</div><!-- /col -->
        <div class="col-md-8">
          <div class="card" id="tmss-folder-content">
            <div class="card-header row"><div id="fldfulrut" class="col-md-6 card-title" style="display: flex"></div>
              <div class="col-md-6">
              </div>
            </div>
            <div class="card-body">
              <table id="docgrd" data-classes="table table-condensed table-hover">
              </table>
            </div>
          </div>
        </div> <!-- /col -->
			</div> <!-- /row -->
		</div> <!-- /container-fluid -->
	</form>
	<script>
		// INIT TREE VIEW
		tmssLoadScript("jstree", function () {
      $("#<?= $lv_sec; ?> #fldtrediv").jstree({
        "core": {
          "expand_selected_onload": true,
          "themes": { "responsive": true, "stripes": false },
          "animation": 0,
          "check_callback": true
        },
        "plugins": ["dnd", "contextmenu"],
        "dnd": {
          "is_draggable": true,
          "check_while_dragging": true,
          "inside_pos": 'last',
          "use_html5": false, // importante
          "always_copy": false
        }
      })
      .on('ready.jstree', function (e, data) {
        const lc_doctre = data.instance;
        // Obtener todos los nodos
        const lc_allnod = lc_doctre.get_json(null, { flat: true });
				// Si hay al menos un nodo
        if (lc_allnod.length > 0) {
          // Seleccionar y abrir el primer nodo
          lc_doctre.select_node(lc_allnod[0].id);
        }
      });
    });

		
		// REFRESH RUTA DE LA CARPETA.
    function <?= $lv_sec; ?>_refreshFolderRoute() {
      const lv_pth = [];
      const lo_ref = $("#<?= $lv_sec; ?> #fldtrediv").jstree(true);
      let lo_sel = lo_ref.get_node(lo_ref.get_selected()[0]); // CORREGIDO
			
			// obtengo nombres de carpetas e ids
			let lv_folders_name = lo_ref.get_path( lo_sel, "", false );
			let lv_folders_id = lo_ref.get_path( lo_sel, "", true );
			// preparo ruta
			$("#<?= $lv_sec; ?> #fldfulrut").empty();
			for(var i=0; i<lv_folders_id.length; i++){
				$("#<?= $lv_sec; ?> #fldfulrut").append((i==0?"":"&nbsp;\\&nbsp;")+"<a href='#' data-folder_id='"+lv_folders_id[i]+"'>"+lv_folders_name[i]+"</a>");
			}
			// attach de eventos de seleccion de carpetas
			$("#<?= $lv_sec; ?> #fldfulrut a").on("click",function(e){ e.preventDefault();
				const lo_ref = $("#<?= $lv_sec; ?> #fldtrediv").jstree(true);
				lo_ref.deselect_all();
				lo_ref.select_node( $(this).data("folder_id") );
			});
    }
	
    
		// REFRESH LISTA ARCHIVOS.
    function <?= $lv_sec; ?>_GridRefresh() {
      // Refresca la ruta actual en la cabecera
      <?= $lv_sec; ?>_refreshFolderRoute();

      // Obtiene la instancia actual del jsTree y el nodo seleccionado
      var lo_ref = $("#<?= $lv_sec; ?> #fldtrediv").jstree(true);
      var lo_sel = lo_ref.get_selected();
      var lo_seldat = lo_ref._model.data[lo_sel[0]];
      
      // Abre el nodo seleccionado
      if (lo_ref.is_open(lo_sel)) {lo_ref.close_node(lo_sel)} else {lo_ref.open_node(lo_sel)}

      // Muestra botones de acción ocultos
      $("#<?= $lv_sec; ?> #btnedt, #<?= $lv_sec; ?> #btndelfld, #<?= $lv_sec; ?> #btndwnfld, #<?= $lv_sec; ?> #btnaddfle, #<?= $lv_sec; ?> #btnflt").removeClass("d-none");

      // Verifica si el nodo seleccionado tiene código de documento válido
      if (lo_seldat?.a_attr?.['data-grldmsdoccod']) {
        // Prepara los datos para enviar al controlador
        var lv_pstdat = [
          { name: "grldmsfldcod", value: lo_seldat.a_attr['data-grldmsdoccod'] },
          { name: "docsts", value: true }
        ];

        // Llama al controlador para obtener los documentos de la carpeta seleccionada
        tmssCallProcessNoBackdrop("?prg=grldmsdoc&act=18", lv_pstdat, function(data){
          let lv_grpdat = {};

          // Agrupa todas las versiones de un mismo documento por su código
          data.data.forEach(item => {
            const key = item.grldmsdoccod;
            if (!lv_grpdat[key]) lv_grpdat[key] = [];
            lv_grpdat[key].push(item);
          });

          const lv_rows = [];
          
          // Para cada documento, recorre sus versiones y selecciona la última activa o editable
          for (const grldmsdoccod in lv_grpdat) {
            lv_grpdat[grldmsdoccod].some(item => {
              if (item.versts == 'A' || item.versts == 'E') {
                // Fecha como objeto Date
                const dteobj = new Date(item.ctedte.date);
                // Fecha para mostrar (formato argentino ya usado)
                var lv_docdte = dteobj.toLocaleDateString('es-AR', {
                  timeZone: data.timezone,
                  day: '2-digit',
                  month: '2-digit',
                  year: 'numeric'
                });
                // timestamp para ordenar correctamente
                const lv_docts = dteobj.getTime();

                // Arma el objeto de fila para la tabla BS Table
                lv_rows.push({
                  srcobjcod: item.srcobjcod,
                  grldmsdoccod: item.grldmsdoccod,
                  grldmsdoctxt: item.grldmsdoctxt,
                  ctedte: lv_docdte,        // cadena para mostrar
                  ctedte_ts: lv_docts,     // ¡timestamp usado para ordenar!
                  grldmsdocsrc: item.grldmsdocsrc == 'F' ? "Documento" : "Texto",
                  flesze: item.flesze
                });

                return true;
              }
            });
          }

          // Carga todos los documentos procesados directamente en la BS Table
          $("#<?= $lv_sec; ?> #docgrd").bootstrapTable("load", lv_rows);
          
          // agrega la cantidad de registros encontrados al pie de página
          var lv_fndreg="<span class='pagination-info'>Registros encontrados <span class='badge'>"+(data.data == null ? 0 : Object.keys(lv_grpdat).length)+"</span></span>";
        	$("#<?= $lv_sec; ?> .pagination-info").html(lv_fndreg);
        });

      } else {
        // Si no hay carpeta/documento seleccionado, limpia la tabla
        $("#<?= $lv_sec; ?> #docgrd").bootstrapTable("removeAll");
      }
    }
		
    // DELETE. Borra todo el documento desde la grilla
    function <?= $lv_sec; ?>_deleteDoc (lp_grldmsdoccod){
      var lv_pstdat=[{name:"grldmsdoccod",value:lp_grldmsdoccod},
                     {name:"grldmsdocdelall",value:true}];

      tmssCallProcess("?prg=grldmsdoc&act=04",lv_pstdat,function(data){ 
        if(data.errtyp="S"){
          <?= $lv_sec; ?>_GridRefresh();
          toastr.success(data.errtxt,"Documento eliminado.");
        }else{ toastr.warning(data.errtxt,"Ocurrió un error al intentar eliminar el documento."); }
      });
    }
    
    // BOOTSTRAP TABLE. transformo la grilla en una BS Table
    tmssLoadScript("table", function(){
      $("#<?= $lv_sec; ?> #docgrd").bootstrapTable({
        data: [], // Inicialmente vacío
        pagination: false,
        sortName: 'ctedte_ts',
  			sortOrder: 'desc',
        columns: [
                  { field: 'grldmsdoctxt', title: 'Nombre', sortable: true },
                  { field: 'ctedte_ts', title: 'Fecha', sortable: true, formatter: function(value, row) { return row.ctedte || ''; } },
                  { field: 'grldmsdocsrc', title: 'Tipo', sortable: true },
                  { field: 'flesze', title: 'Tama&ntilde;o', sortable: true },
          				{ field: 'btndel', title: '', align: 'center', width: 50,
                   	formatter: function(value, row) {
                      return `<button class="btn btn-sm btn-danger ${'<?= $lv_sec; ?>_btnDel'}" 
                                data-id="${row.grldmsdoccod}" 
                                title="Borrar documento">
                          			<i class="fas fa-trash"></i>
                        			</button>`;
                    },
                    events: { 'click .<?= $lv_sec; ?>_btnDel': function (e, value, row) { 
                      e.stopPropagation(); e.preventDefault();
                      BootstrapDialog.show({
                        title: "Confirmaci&oacute;n",
                        message: "¿Desea borrar el documento?",
                        type: BootstrapDialog.TYPE_WARNING,
                        buttons: [ {label: "No", cssClass: "btn-secondary", action: function(dialogRef) { dialogRef.close(); return; } },
                                   {label: "Si", cssClass: "btn-danger",  action: function(dialogRef) { <?= $lv_sec; ?>_deleteDoc(row.grldmsdoccod); dialogRef.close(); } } ]
                      });
                    }}
                  }
        				]
      }).on("click-row.bs.table", function (e, row, $element) {
        var lv_pstdat = [ { name: "grldmsdoccod", value: row.grldmsdoccod },{ name: "oldsec", value: "<?= $lv_sec; ?>" } ];
        // redirige al visor del documento en una nueva sección
        tmssLink('?prg=grldmsdoc&act=vwdoc&prm_mdlcod=GRL&prm_prgcod=DMS', [ { target: '_new_section', post_data: lv_pstdat } ]);
      }).on("sort.bs.table", function (e, name, order) {
        $("#<?= $lv_sec; ?> #docgrd").bootstrapTable("refresh");
      });
    });
    
    
		// AGREGAR CARPETA.
    $("#<?= $lv_sec; ?> #btnaddfld").on("click", function(e) {
        e.preventDefault();
        if (this.hasAttribute("disabled")) { return; }
        var lo_ref = $("#<?= $lv_sec; ?> #fldtrediv").jstree(true);
        var lo_sel = lo_ref.get_selected();
      	lo_ref.deselect_node(lo_sel[0]);
        var lo_new = lo_ref.create_node((!lo_sel.length ? null : lo_sel[0]), {"type": "folder", "text": "Nueva Carpeta"});
        if (lo_new) {
          lo_ref.edit(lo_new);
          lo_ref.select_node(lo_new);
          // ejecuta tmssCallProcess en cuanto se renombre el nodo
          $("#<?= $lv_sec; ?> #fldtrediv").off("rename_node.jstree").on("rename_node.jstree", function(event, data) {
            var lv_prnnod = $("#<?= $lv_sec; ?> #fldtrediv").jstree(true)._model.data[data.node.parent];
            var lv_pstdat = [{name:"grldmsdoctxt", value:data.node.text}, // Nombre
                             {name:"grldmsfldcod", value:(lv_prnnod.a_attr?.['data-grldmsdoccod'] ?? 0)}, // Carpeta de origen
                             {name:"grldmsdocsrc", value:"FD" }]; // Tipo de nodo (Carpeta por default)                 
            // se llama a la función directamente
            tmssCallProcessNoBackdrop("?prg=grldmsdoc&act=00", lv_pstdat, function(data){
              // si no hubo error en la creación del nodo en la BD actualizo el nodo con los datos cargados
              if (data.errcod == 0){
              	var lo_ref = $("#<?= $lv_sec; ?> #fldtrediv").jstree(true);
								var lo_sel = lo_ref.get_selected();
                var lo_nod = lo_ref.get_node(lo_sel);
                var lv_dte = new Date();
                lv_dte = lv_dte.getDate().toString().padStart(2, '0')+"/"+(lv_dte.getMonth() + 1).toString().padStart(2, '0')+"/"+lv_dte.getFullYear();
                
                lo_nod.a_attr["data-grldmsdoccod"] = data.data.grldmsdoccod;
                lo_nod.a_attr["data-nodtyp"] = "FD";
                lo_nod.a_attr["data-docdte"] = lv_dte;
              }
              <?= $lv_sec; ?>_GridRefresh();
            });
          });
        }
    });
		
		
		// EDITAR NOMBRE DE LA CARPETA.
		$("#<?= $lv_sec; ?> #btnedt").on("click",function(e){ e.preventDefault();
			if (this.hasAttribute("disabled")){return;}
			var lo_ref = $("#<?= $lv_sec; ?> #fldtrediv").jstree(true);
			var lo_sel = lo_ref.get_selected();
			lo_ref.edit(lo_sel[0]);
			$("#<?= $lv_sec; ?> #fldtrediv").on("rename_node.jstree", function(event, data) {
        var lv_prnnod = $("#<?= $lv_sec; ?> #fldtrediv").jstree(true)._model.data[data.node.parent];
        var lv_pstdat = [{name:"grldmsdoccod", value:(data.node.a_attr['data-grldmsdoccod'] ?? '')},
          							 {name:"grldmsdoctxt", value:data.node.text}, // Nombre
                         {name:"grldmsfldcod", value:(lv_prnnod.a_attr?.['data-grldmsdoccod'] ?? 0)}, // Carpeta de origen
                         {name:"grldmsdocsrc", value:"FD" }]; // Tipo de nodo (Carpeta por default)                 
        // se llama a la función directamente
        tmssCallProcessNoBackdrop("?prg=grldmsdoc&act=00", lv_pstdat, function(data){
          if (data.errcod == 0){
            toastr.success("Nodo editado correctamente.");
          }
        });
      });
		});
		
		
    // SELECCIONAR CARPETA.
    $("#<?= $lv_sec; ?> #fldtrediv").on("select_node.jstree", function (e, data) {
			<?= $lv_sec; ?>_GridRefresh();
    });


		// DESELECCIONAR CARPETA. Al hacer click dentro del contenedor del árbol pero
		// por fuera de cualquier carpeta, se deselecciona todo para que la próxima
		// carpeta que se cree quede en el root.
		$("#<?= $lv_sec; ?> #fldtrediv").on("click", function (e) {
			// si el click fue sobre un nodo del árbol, lo maneja select_node
			if ($(e.target).closest(".jstree-anchor").length > 0) { return; }
			var lo_ref = $("#<?= $lv_sec; ?> #fldtrediv").jstree(true);
			if (!lo_ref || !lo_ref.get_selected().length) { return; }
			lo_ref.deselect_all();
			// oculta acciones que requieren una carpeta seleccionada
			$("#<?= $lv_sec; ?> #btnedt, #<?= $lv_sec; ?> #btndelfld, #<?= $lv_sec; ?> #btndwnfld, #<?= $lv_sec; ?> #btnaddfle").addClass("d-none");
			// limpia la ruta y la grilla de documentos
			$("#<?= $lv_sec; ?> #fldfulrut").empty();
			$("#<?= $lv_sec; ?> #docgrd").bootstrapTable("removeAll");
		});

		
		// BORRAR CARPETA.
		$("#<?= $lv_sec; ?> #btndelfld").on("click",function(e){ e.preventDefault();
			var lo_ref = $("#<?= $lv_sec; ?> #fldtrediv").jstree(true);
			var lo_sel = lo_ref.get_selected();
			var lo_seldat = lo_ref._model.data[lo_sel[0]];
			// verifico que haya una carpeta seleccionada
			if (!lo_sel.length) {
      	toastr.warning("Se debe seleccionar una carpeta para borrar");
        return false
      }                     
      // reviso si tiene nodos hijos
      if ((lo_seldat.children && lo_seldat.children.length>0) || $("#<?= $lv_sec; ?> #docgrd").bootstrapTable("getData").length > 0){
        BootstrapDialog.confirm({
        	title: "<?= $vew_lang->delete; ?>",
          message: "La carpeta tiene documentos dentro ¿Desea borrarla igualmente?",
          type: BootstrapDialog.TYPE_WARNING,
          callback: function(result) {
            if(result) {
              tmssCallProcessNoBackdrop("?prg=grldmsdoc&act=04", {grldmsdoccod:lo_seldat.a_attr['data-grldmsdoccod'], grldmsdocsrc:'FD'}, function(data){
                if (data.data.errcod == 0){
                  lo_ref.delete_node(lo_sel);
                }
                toastr.warning("Carpeta borrada", "<?= $vew_lang->attachments; ?>");
                <?= $lv_sec; ?>_GridRefresh();
              });
            }
          }
				});
      }else {
        tmssCallProcessNoBackdrop("?prg=grldmsdoc&act=04", {grldmsdoccod:lo_seldat.a_attr['data-grldmsdoccod'], grldmsdocsrc:'FD'}, function(data){
          if (data.data.errcod == 0){
            lo_ref.delete_node(lo_sel);
            toastr.warning("Carpeta borrada", "<?= $vew_lang->attachments; ?>");
            <?= $lv_sec; ?>_GridRefresh();
          }
        });
      }
		});
    
    
    // MOVER CARPETA
    $('#<?= $lv_sec; ?> #fldtrediv').on('drag_start.jstree', function (e, data) {
      let lv_mvdnodid = data.data.nodes[0];
    });
    
    $('#<?= $lv_sec; ?> #fldtrediv').on('dragover', function (e) {
      e.preventDefault(); // Necesario para permitir drop
    });
    
    $('#<?= $lv_sec; ?> #fldtrediv').on('dnd_stop.vakata', function (e) {
      e.preventDefault();
      const lo_ref = $('#<?= $lv_sec; ?> #fldtrediv').jstree(true); // instancia del árbol
      const lv_mvdnod_domid = e.originalEvent.dataTransfer.getData('text'); // el nodo que fue movido
      $('#'+lv_mvdnod_domid).a_attr['data-grldmsdoccod'];
      //const lv_prtnod = lo_ref.get_node(data.parent); // el nodo padre (nuevo)
      
      // verifica si fue soltado sobre otro nodo (evita mover si fue un drop válido)
      if ($(e.target).closest('.jstree-anchor').length > 0) return;

      // si no es un nodo válido, lo mueve al nodo raíz
      lo_ref.move_node(lv_mvdnod.a_attr['data-grldmsdoccod'], '#');
    });
    
    $('#<?= $lv_sec; ?> #fldtrediv').on('move_node.jstree', function (e, data) {
      const lo_ref = $('#<?= $lv_sec; ?> #fldtrediv').jstree(true); // instancia del árbol
      const lv_mvdnod = data.node;                   // el nodo que fue movido
      const lv_prtnod = lo_ref.get_node(data.parent); // el nodo padre (nuevo)

      var lv_pstdat=[{name:"grldmsdoccod",value:lv_mvdnod.a_attr['data-grldmsdoccod']},
                     {name:"grldmsfldcod",value:lv_prtnod.a_attr?.['data-grldmsdoccod'] ?? 0},
                     {name:"grldmsdocsrc",value:'FD'}];
			tmssCallProcess("?prg=grldmsdoc&act=00",lv_pstdat,function(data){
      	if (data.errcod == 0){
          <?= $lv_sec; ?>_refreshFolderRoute();
          toastr.success("El nodo fue movido correctamente.");
        }else{
          toastr.warning("Ocurri&oacute; un error al mover el nodo.")
        }
      });
    });
    
    
    // DESCARGAR CONTENIDO DE LA CARPETA
    $("#<?= $lv_sec; ?> #btndwnfld").on("click", function (e) {
      e.preventDefault();

      const lo_ref = $("#<?= $lv_sec; ?> #fldtrediv").jstree(true);
      const lo_sel = lo_ref.get_selected();
      const lo_seldat = lo_ref._model.data[lo_sel[0]];

      const lv_fldcod = lo_seldat?.a_attr?.['data-grldmsdoccod'];

      if (!lv_fldcod) {
        toastr.warning("Debe seleccionar una carpeta para descargar.", "Atención");
        return;
      }
			// solicita confirmación para descargar
			BootstrapDialog.confirm({
        title: "<?= $vew_lang->download; ?>",
        message: "¿Desea descargar la carpeta completa, con sus documentos y subcarpetas?",
        type: BootstrapDialog.TYPE_WARNING,
        callback: function(result) {
          if(result) {
            var lv_pstdat = [{name:"grldmsdoccod",value:lv_fldcod}];
            tmssCallProcess("?prg=grldmsdoc&act=downloadfolder", lv_pstdat, function (data) {
              if (data.data?.errcod == 0) {
                const lv_zipcnt = data.data.zipcnt; // contenido base64
                const lv_zipnme = data.data.zipnme || "carpeta.zip"; // nombre del archivo

                // Decodificar base64 a binario
                const lv_binstr = atob(lv_zipcnt);
                const lv_binarr = new Uint8Array(lv_binstr.length);
                for (let lv_idx = 0; lv_idx < lv_binstr.length; lv_idx++) {
                  lv_binarr[lv_idx] = lv_binstr.charCodeAt(lv_idx);
                }

                // Crear blob y simular descarga
                const lv_blb = new Blob([lv_binarr], { type: 'application/zip' });
                const lv_url = URL.createObjectURL(lv_blb);
                const lv_lnk = document.createElement("a");
                lv_lnk.href = lv_url;
                lv_lnk.download = lv_zipnme;
                document.body.appendChild(lv_lnk);
                lv_lnk.click();
                document.body.removeChild(lv_lnk);
                URL.revokeObjectURL(lv_url);
              } else {
                const lv_errmsg = data?.data?.errtxt || "Ocurrió un error al generar el ZIP.";
                toastr.warning(lv_errmsg);
              }
            });
          }
        }
      });
    });

		
		// SUBIR ARCHIVO
    $("#<?= $lv_sec; ?> #btnaddfle").on("click",function(e){ e.preventDefault();
			var lo_sel = $("#<?= $lv_sec; ?> #fldtrediv").jstree("get_selected", true);
			if (!lo_sel.length) { toastr.warning("Seleccione una carpeta de origen para el archivo."); return; }
      var lo_ref = $("#<?= $lv_sec; ?> #fldtrediv").jstree(true);
      var lo_seldat = lo_ref._model.data[lo_sel[0].id];
        
			var lv_pstdat = [{name:"grldmsfldcod", value:lo_seldat.a_attr['data-grldmsdoccod']}];
			tmssCallProcess("?prg=grldmsdoc&act=uploadnewdocument",lv_pstdat,function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->upload; ?>",
					message: $(data),
					type: BootstrapDialog.TYPE_PRIMARY,
					size: BootstrapDialog.SIZE_WIDE,
					buttons: [{ id:"btncam", icon: "fas fa-camera", label: "<?= $vew_lang->camera; ?>",	cssClass: "btn-default pull-left hidden",
											action: function(dialog){ $(dialog.$modalBody).find("#btncam").trigger("click"); }
										},
										{	id:"btnfle", icon: "far fa-file", label: "<span class='hidden-xs'><?= $vew_lang->upload; ?> </span><?= $vew_lang->file; ?>", cssClass: "btn-default pull-left hidden",
											action: function(dialog){ $(dialog.$modalBody).find("#btnfle").trigger("click"); }
										},
                    {	id:"btntxt", icon: "far fa-text", label: "<span class='hidden-xs'><?= $vew_lang->create; ?> </span><?= $vew_lang->text; ?>", cssClass: "btn-default pull-left hidden",
											action: function(dialog){ $(dialog.$modalBody).find("#btntxt").trigger("click"); }
										},
                   	{ id:"btnsve", icon: "far fa-save", label: "<?= $vew_lang->save; ?>", cssClass: "btn-success hidden",
											action: function(dialog){ $(dialog.$modalBody).find("#btnsve").trigger("click"); }
										}],        
        	onhidden: function(dialogRef) { <?= $lv_sec; ?>_GridRefresh(); }
        });
			});
		});    
    // FILTRAR ARCHIVOS
	</script>
	<script>
    // FILTROS PERSONALIZADOS
    var gv_<?= $lv_sec; ?>_flt=[{'fldttl': '<?= $vew_lang->name; ?>' ,'fldcod': 'd.grldmsdoctxt', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''}//,
                               	//{'fldttl': '<?= $vew_lang->date; ?>' ,'fldcod': 'd.ctedte', 'fldtyp': 'DATE', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
                               	//{'fldttl': '<?= $vew_lang->type; ?>' ,'fldcod': 'd.grldmsdocsrc', 'fldtyp': 'TEXT', 'flttyp': 'LIKE', 'fldvalstr': '','fldvalend': ''}//,
                                //{'fldttl': '<?= $vew_lang->size; ?>' ,'fldcod': 'dv.flesze', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
                               ];
    
    $("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
			tmssFilterShowDialog( gv_<?= $lv_sec; ?>_flt, <?= $lv_sec; ?>_filtDocs );
		});
    
    function <?= $lv_sec; ?>_filtDocs(lp_flt) {
      // recupero el nodo seleccionado para utilizar su atributo data-grldmsdoccod
    	var lo_sel = $("#<?= $lv_sec; ?> #fldtrediv").jstree("get_selected", true);
      var lo_ref = $("#<?= $lv_sec; ?> #fldtrediv").jstree(true);
      var lo_seldat = lo_ref._model.data[lo_sel[0].id];
      
      // Condiciones del filtro
      $("#<?= $lv_sec; ?> #grldmsflt").val(JSON.stringify(lp_flt));

      var lv_fltint;
      if (lp_flt != null) {
        lv_fltint = tmssFilterParseToInternal(lp_flt);
        gv_<?= $lv_sec; ?>_flt = lp_flt;
        $("#<?= $lv_sec; ?> #fltcnt").text(
          (lv_fltint["fltqty"] == "0" ? "" : lv_fltint["fltqty"])
        );
      } else {
        lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
      }

      if (lv_fltint["maxrec"] == "") { lv_fltint["maxrec"] = "100"; }

      // mando filtros por post para tomarlos cuando se efectúe una copia y mantener el filtro
      $("#<?= $lv_sec; ?> #vewmaxrec001").val(lv_fltint["maxrec"]);
      $("#<?= $lv_sec; ?> #vewfldflt001").val(lv_fltint["fltstr"]);
      
      var lv_pstdat = [ {"name": "grldmsfldcod", "value": lo_seldat.a_attr['data-grldmsdoccod']},{"name": "vewmaxrec", "value": lv_fltint["maxrec"]},{"name": "vewfldflt", "value": lv_fltint["fltstr"]} ];
			tmssCallProcess("?prg=grldmsdoc&act=18", lv_pstdat, function(data){
        // Repite el mismo proceso que el getList sin filtros
      	let lv_grpdat = {};
        
        // Agrupa todas las versiones de un mismo documento por su código
        data.data.forEach(item => {
          const key = item.grldmsdoccod;
          if (!lv_grpdat[key]) lv_grpdat[key] = [];
          lv_grpdat[key].push(item);
        });

        const lv_rows = [];

        // Para cada documento, recorre sus versiones y selecciona la última activa o editable
        for (const grldmsdoccod in lv_grpdat) {
          lv_grpdat[grldmsdoccod].some(item => {
            if (item.versts == 'A' || item.versts == 'E') {
              // Fecha como objeto Date
              const dteobj = new Date(item.ctedte.date);
              // Fecha para mostrar (formato argentino ya usado)
              var lv_docdte = dteobj.toLocaleDateString('es-AR', {
                timeZone: data.timezone,
                day: '2-digit',
                month: '2-digit',
                year: 'numeric'
              });
              // timestamp para ordenar correctamente
              const lv_docts = dteobj.getTime();

              // Arma el objeto de fila para la tabla BS Table
              lv_rows.push({
                srcobjcod: item.srcobjcod,
                grldmsdoccod: item.grldmsdoccod,
                grldmsdoctxt: item.grldmsdoctxt,
                ctedte: lv_docdte,        // cadena para mostrar
                ctedte_ts: lv_docts,     // ¡timestamp usado para ordenar!
                grldmsdocsrc: item.grldmsdocsrc == 'F' ? "Documento" : "Texto",
                flesze: item.flesze
              });

              return true;
            }
          });
        }
        
        // Carga todos los documentos procesados directamente en la BS Table
        $("#<?= $lv_sec; ?> #docgrd").bootstrapTable("load", lv_rows);

        // agrega la cantidad de registros encontrados al pie de página
        var lv_fndreg="<span class='pagination-info'>Registros encontrados <span class='badge'>"+(data.data == null ? 0 : data.data.length)+"</span></span>";
        $("#<?= $lv_sec; ?> .pagination-info").html(lv_fndreg);
    	});
    }
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
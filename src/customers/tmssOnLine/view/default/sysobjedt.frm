<?php
	// url del formulario
  $lv_lnk = '?prg=sysobj';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->editor;

	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'EDT';

	$vew_actcod = '02';

	// libreria de estilos bootstrap
	include_once('_library.frm');
	
	$vew_tbl['canc'] = array('per'=>false);	
	$vew_tbl['sveL'] = array('per'=>false);	
	$vew_tbl['sveR'] = array('per'=>false);	
	$vew_tbl['new'] = array('per'=>false);	
	$vew_tbl['modL'] = array('per'=>false);	
	$vew_tbl['modR'] = array('per'=>false);	
	$vew_tbl['del'] = array('per'=>false);	
	$vew_tbl['delsep'] = array('per'=>false);	
	$vew_tbl['cpy'] = array('per'=>false);	
	$vew_tbl['btnwrkL'] = array('pos'=>'L', 'per'=>true, 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmss-desk-btn', 'icn'=>'far fa-folder-open','id'=>'btnwrk', 'acc'=>'', 'ttl'=>$vew_lang->myfiles);	
	$vew_tbl['btsve'] = array('pos'=>'L', 'per'=>true, 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmss-desk-btn btn-success hidden', 'icn'=>'far fa-save','id'=>'btnsve', 'acc'=>'', 'ttl'=>$vew_lang->save);	

	$vew_tbl['div000'] = array('pos'=>'D', 'per'=>true, 'css'=>'divider');
	$vew_tbl['btncmp'] = array('pos'=>'D', 'per'=>true, 'css'=>'tmss-Opt', 'icn'=>'far fa-code-compare','id'=>'btncmp', 'acc'=>'', 'ttl'=>$vew_lang->compare);
	$vew_tbl['btnmov'] = array('pos'=>'D', 'per'=>true, 'css'=>'tmss-Opt', 'icn'=>'far fa-share','id'=>'btnmov', 'acc'=>'', 'ttl'=>$vew_lang->move);	
	$vew_tbl['btnprf'] = array('pos'=>'D', 'per'=>true, 'css'=>'tmss-Opt', 'icn'=>'far fa-user-cog','id'=>'btnpref', 'acc'=>'', 'ttl'=>$vew_lang->preferences);
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>" >
	<?php include('grldocfrmtlb.frm'); ?>
	<?= gethtml('usrthm','hidden',$vew_data->usrprf['usrthm']); ?>
	<?= gethtml('autcls','hidden',$vew_data->usrprf['autcls']); ?>

	<!-- BUSCADOR -->
	<div id="divedtsch" class="col-md-2" style="height:calc(100vH - 152px);padding:0px;background-color: #f1f1f1;">
		<input type="TEXT" id="sysobjsrchtxt" autocomplete="off" value="" placeholder="Buscar..." style="margin: 5px; width:50%;">
		<select id="sysobjclscod" name="sysobjclscod" style="margin: 0px; width:40%; height: 25px;">
			<option value=""></option>
			<option value="2">Controller</option>
			<option value="3">Model</option>
			<option value="4">View</option>
			<option value="14">CSS</option>
			<option value="17">JS</option>
			<option value="20">TABLE</option>
			<option value="19">SP</option>
		</select>
		<div id="sysobjlst" style="overflow-y: auto; height: calc(100vh - 188px);"></div>
	</div>


	<!-- EDITOR -->
	<div id="divedt" class="col-md-10" style="padding:0px;height:calc(100vH - 152px);">
		<form id="<?= $lv_sec; ?>_frm" style="height:100%;">
			<input type="hidden" id="tmss_actcod" name="tmss_actcod">
			<div class="container-fluid" role="tabpanel" name="divobjedt" style="padding:0px !important;height:100%;">
				<ul class="nav nav-tabs" role="tablist"></ul>
				<div class="tab-content tmss-tab-content" style="padding:0px !important; height:90%;"></div>
			</div>
		</form>
	</div>


	<!-- PREFERENCIAS DE USUARIO -->
	<div class="hidden" id="divusrprf">
		<div class="row">
			<div class="col-sm-5">
			<?php
      $lo_themes = array('default'=>'default','3024-day'=>'3024-day','3024-night'=>'3024-night','abcdef'=>'abcdef','ambiance'=>'ambiance','ayu-dark'=>'ayu-dark','ayu-mirage'=>'ayu-mirage','base16-dark'=>'base16-dark','base16-light'=>'base16-light','bespin'=>'bespin','blackboard'=>'blackboard','cobalt'=>'cobalt','colorforth'=>'colorforth','darcula'=>'darcula','dracula'=>'dracula','duotone-dark'=>'duotone-dark','duotone-light'=>'duotone-light','eclipse'=>'eclipse','elegant'=>'elegant','erlang-dark'=>'erlang-dark','gruvbox-dark'=>'gruvbox-dark','hopscotch'=>'hopscotch','icecoder'=>'icecoder','idea'=>'idea','isotope'=>'isotope','lesser-dark'=>'lesser-dark','liquibyte'=>'liquibyte','lucario'=>'lucario','material'=>'material','material-darker'=>'material-darker','material-palenight'=>'material-palenight','material-ocean'=>'material-ocean','mbo'=>'mbo','mdn-like'=>'mdn-like','midnight'=>'midnight','monokai'=>'monokai','moxer'=>'moxer','neat'=>'neat','neo'=>'neo','night'=>'night','nord'=>'nord','oceanic-next'=>'oceanic-next','panda-syntax'=>'panda-syntax','paraiso-dark'=>'paraiso-dark','paraiso-light'=>'paraiso-light','pastel-on-dark'=>'pastel-on-dark','railscasts'=>'railscasts','rubyblue'=>'rubyblue','seti'=>'seti','shadowfox'=>'shadowfox','solarized dark'=>'solarized dark','solarized light'=>'solarized light','the-matrix'=>'the-matrix','tomorrow-night-bright'=>'tomorrow-night-bright','tomorrow-night-eighties'=>'tomorrow-night-eighties','ttcn'=>'ttcn','twilight'=>'twilight','vibrant-ink'=>'vibrant-ink','xq-dark'=>'xq-dark','xq-light'=>'xq-light','yeti'=>'yeti','yonce'=>'yonce','zenburn'=>'zenburn');
      echo vew_boot($lv_col48, array('label'=>'Theme','input'=>gethtml('usrthm',$lo_themes,'',$lv_default) ));
      echo vew_boot($lv_col48, array('label'=>'AutoClose','input'=>gethtml('autcls','yesno', '', $lv_default) ));
			?>
			</div>
			<div class="col-sm-7">
        <textarea id="SampleCode" name="SampleCode">
        function find(start, history) {
          if (start == goal)
            return history;
          else if (start > goal)
            return null;
          else
            return find(start + 5, "(" + history + " + 5)") ||
                   find(start * 3, "(" + history + " * 3)");
        }
        </textarea>
			</div>
		</div>
	</div>
	<script>
		// VARIABLES GENERALES. variable utilizadas por multiples funciones
		var <?= $lv_sec; ?>_lg_editors = [];	// Array de editores
		var <?= $lv_sec; ?>_modified = [];		// Array de archivos que estan siendo modificados
		
		
		// INICIALIZACION. inicializo codemirror y fijo foco en campo de busqueda
		$(function(){
			tmssLoadScript("codemirror",function(){});
			$("#<?= $lv_sec; ?> #sysobjsrchtxt").focus();
		});
		
		
		// COMPARAR. compara versiones del objeto activo
		$("#<?= $lv_sec; ?> #btncmp").on("click",function(e){ e.preventDefault();
			var lv_link = $("#<?= $lv_sec; ?> #divedt li.active a:first");
			if( $("#<?= $lv_sec; ?> #divedt li.active").length==0 ){
				toastr.warning("Debe seleccionar un archivo."); return;
			}
			if($(lv_link).data("sysobjclstyp")=="SP" || $(lv_link).data("sysobjclstyp")=="TABLE"){
				toastr.warning("No se pueden comparar objetos de base de datos."); return;
			}
			var lv_sysobjcod = $("#<?= $lv_sec; ?> #divedt li.active a:first").data("sysobjcod");
      var lv_pstdat = {sysobjcod:lv_sysobjcod};
      tmssCallProcess("?prg=sysobj&act=showCompare",lv_pstdat,function(data){
        BootstrapDialog.show({
          type: BootstrapDialog.TYPE_PRIMARY,
          cssClass: "tmss-modal-xl",
          closable:true,
					draggable: true,
        	title: "<?= $vew_lang->compare; ?>",
          message: $(data) 
        });
      });
		});
		
		
		// PREFERENCIAS. cuadro de dialogo para mostrar/establecer preferencias de usuario
		$("#<?= $lv_sec; ?> #btnpref").on("click",function(e){e.preventDefault
			BootstrapDialog.show({
				title:"<?= $vew_lang->preferences ?>",
				message:$("#<?= $lv_sec; ?> #divusrprf > div").clone(),
				dragable: true,
				size: BootstrapDialog.SIZE_WIDE,
				buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialog){ dialog.close(); } },
									{	label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success",	action: function(dialog){
										// graba preferencias de usuario
										var lv_usrthm = dialog.$modalBody.find("#usrthm").prop("value");
										var lv_autcls = dialog.$modalBody.find("#autcls").prop("value");
										var lv_pstdat = [ {name:"usrthm", value:lv_usrthm},{name:"autcls",value:lv_autcls} ];
										tmssCallProcess("?prg=sysobj&act=sveusrfrf", lv_pstdat, function(data){
											// aplico los cambios en todos los editores abiertos
											for(var i=0; i<<?= $lv_sec; ?>_lg_editors.length; i++){
												<?= $lv_sec; ?>_lg_editors[i]["editor"].setOption("theme", lv_usrthm);
												<?= $lv_sec; ?>_lg_editors[i]["editor"].setOption("autoCloseBrackets", lv_autcls);
											}
											// fijo los cambios para proximas apertura de editores
											$("#<?= $lv_sec; ?> #usrthm").prop("value", lv_usrthm );
											$("#<?= $lv_sec; ?> #autcls").prop("value", lv_autcls );
											toastr.success("Datos grabados");
											dialog.close();
										});
									}}],
				onshown: function(dialog){
					// inicializo editor de ejemplo
					var editor = CodeMirror.fromTextArea( dialog.$modalBody.find("#SampleCode").get(0), {
							lineNumbers: true,
							styleActiveLine: true,
							matchBrackets: true,
							tabSize:2,
							mode: "javascript",
            	keyMap: "sublime",
							autoCloseBrackets: ($("#<?= $lv_sec; ?> #autcls").prop("value")=="1"?true:false),
							theme: $("#<?= $lv_sec; ?> #usrthm").prop("value")
						});
					// establezco eventos para mostrarlas en el editor de ejemplos
					dialog.$modalBody.find("#usrthm").prop("value",$("#<?= $lv_sec; ?> #usrthm").prop("value")).on("change",function(e){editor.setOption("theme", $(this).prop("value"));});
					dialog.$modalBody.find("#autcls").prop("value",$("#<?= $lv_sec; ?> #autcls").prop("value")).on("change",function(e){editor.setOption("autoCloseBrackets", ($(this).prop("value")=="1"?true:false) );});
				}
			});
		});
		
		
		// MOVE OBJ. Mover OT y/o cambio de usuario
		$("#<?= $lv_sec; ?> #btnmov").on("click",function(e){ e.preventDefault();
			var lp_sysobjcod = $("#<?= $lv_sec; ?> div[name=divobjedt] ul li.active").children(0).data("sysobjcod");
			// obtiene indice del editor
			var i = <?= $lv_sec; ?>_lg_editors.findIndex(function(el){return el.sysobjcod==lp_sysobjcod;});
			if(i==-1){ toastr.warning("Debe seleccionar un archivo de una orden para mover."); return false; }

      // muestra dialogo de selección de OT
      var lv_post = [{name:"sysobjcod", value:lp_sysobjcod}];
      tmssCallProcess("?prg=systraobj&act=moveobj",lv_post,function(data){
        if(data["errtyp"] == "W"){
          toastr.warning(data["errtxt"]);
        }else{
          BootstrapDialog.show({
            title:"Mover Orden de transporte",
            message:$(data),
            size: BootstrapDialog.SIZE_MEDIUM,
            closable:true,
            draggable:true,
            buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialog){dialog.close(); } },
                      {	label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success",	action: function(dialog){
                        if(!tmssCheckRequiredFields( dialog.$modalBody.find("form:first") )){ return false; }
                        //obtiene datos
                        var lv_usrcod = dialog.$modalBody.find("#usrcod").val();
                        var lv_systracod = dialog.$modalBody.find("#systracod").val();
                        var lv_sysobjcod = dialog.$modalBody.find("#sysobjcod").val().replace( ";","" );
                        var lv_systraobjcod = dialog.$modalBody.find("#systraobjcod").val().replace( ";","" );
                        // asigna el objeto al ot
                        var lv_post = [{name:"systracod",value:lv_systracod}
                                      ,{name:"usrcod",value:lv_usrcod}
                                      ,{name:"systraobjcod",value:lv_systraobjcod}
                                      ,{name:"sysobjcod",value:lv_sysobjcod}
                                      ,{name:"sysobjcnt",value:<?= $lv_sec; ?>_lg_editors[i].editor.getValue()}
                                      ,{name:"docsts",value:"A"}];
                        tmssCallProcess("?prg=systraobj&act=00",lv_post,function(data){
                          if(data["errtyp"] == "S"){
                            //revisa que exista el editor y guarda el valor actual
                            if(typeof <?= $lv_sec; ?>_lg_editors[i].editor !== "undefined"){
                              <?= $lv_sec; ?>_lg_editors[i].source = <?= $lv_sec; ?>_lg_editors[i].editor.getValue();
                              <?= $lv_sec; ?>_chgCheck(<?= $lv_sec; ?>_lg_editors[i].editor.getValue(), <?= $lv_sec; ?>_lg_editors[i].source,lp_sysobjcod);
                            }
                            toastr.success("Movimiento realizado");
                            <?= $lv_sec; ?>_findFile( "", "");
                          } else if(data['errtyp'] == "W"){
                            toastr.warning("Error al mover archivo");
                          }
                        });
                        dialog.close();
                      }}]
          });
        }
      });
		});		
		
		
		// CERRAR ARCHIVO. pregunta si se desea guardar un archivo modificado
		function <?= $lv_sec; ?>_ask_save( lp_sysobjcod ){
			// si hay cambios, graba el archivo
			if(<?= $lv_sec; ?>_modified.findIndex(function(el){return el==lp_sysobjcod;})!=-1){
				BootstrapDialog.show({
					title:"<?= $vew_lang->save ?>",
					message:"Desea grabar el objeto?",
					type: BootstrapDialog.TYPE_WARNING,
					draggable: true,
					closable: true,
					buttons: [{	label: "<?= $vew_lang->yes; ?>", cssClass: "btn-danger",	action: function(dialog){
												<?= $lv_sec; ?>_sveFile(lp_sysobjcod);
												<?= $lv_sec; ?>_tab_sysobjcod_cls(lp_sysobjcod);
												dialog.close();
											}},
										{	label: "<?= $vew_lang->no; ?>", cssClass: "btn-default",	action: function(dialog){
												<?= $lv_sec; ?>_tab_sysobjcod_cls(lp_sysobjcod);
												dialog.close();
											}},
										{	label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default",	action: function(dialog){
												dialog.close();
											}}
										]
				});
			// si no hay cambios, cierra solapa
			}else(
				<?= $lv_sec; ?>_tab_sysobjcod_cls( lp_sysobjcod )
			)
		}
		
		
		// MOSTAR BOTONES. muestar/oculta boton de grabado según si el archivo esta siendo modificado
		function <?= $lv_sec; ?>_chgShowControls( lp_sysobjcod ){
			if(<?= $lv_sec; ?>_modified.findIndex(function(el){return el==lp_sysobjcod;})!=-1){
				$("#<?= $lv_sec; ?> #btnsve").removeClass("hidden");
			}else{
				$("#<?= $lv_sec; ?> #btnsve").addClass("hidden");
			}
		}		
	</script>
	<script>
		// BUSQUEDA. realiza la busqueda de archivos
		let <?= $lv_sec; ?>_sysobjedt_timeout;
		$("#<?= $lv_sec; ?> #sysobjsrchtxt").keyup(function(){
		    clearTimeout(<?= $lv_sec; ?>_sysobjedt_timeout); // Limpia el temporizador anterior
        let lv_<?= $lv_sec; ?>_sysobjedt_busqueda = $(this).val();
        <?= $lv_sec; ?>_sysobjedt_timeout = setTimeout(function() {
            if (lv_<?= $lv_sec; ?>_sysobjedt_busqueda.length > 2) { // mínimo de caracteres
              <?= $lv_sec; ?>_findFile( lv_<?= $lv_sec; ?>_sysobjedt_busqueda, "" );
            }
        }, 500); // Espera 500ms después de la última tecla      
			
		});
		$("#<?= $lv_sec; ?> #sysobjclscod").on("change",function(e){ e.preventDefault();
			 <?= $lv_sec; ?>_findFile( $("#<?= $lv_sec; ?> #sysobjsrchtxt").val(), "" );
		});
		
		// boton mis archivos
		$("#<?= $lv_sec; ?> #btnwrk").on("click",function(e){ e.preventDefault();
			<?= $lv_sec; ?>_findFile( "", "<?= $vew_sec->usrcod; ?>" ); 
		});
		 
		// funcion de busqueda
		function <?= $lv_sec; ?>_findFile( lp_txt, lp_usrcod ){
      $("#<?= $lv_sec; ?> #sysobjlst").html( "<div class='text-center'><i class='far fa-gear fa-spin'></i></div>" );
			var lv_post = [{name:"sysobjsrchtxt",value:lp_txt},{name:"sysobjclscod",value:$("#<?= $lv_sec; ?> #sysobjclscod").prop("value")}];
			if(lp_usrcod!=""){lv_post.push({name:"usrcod",value:lp_usrcod});}
			tmssCallProcessNoBackdrop("?prg=sysobj&act=edtsrch",lv_post,function(data){
				lv_usrdevgrp = <?= json_encode($vew_usrdevgrp); ?>;
        
				// arma la lista de objetos encontardos
				var lv_ul = $("#<?= $lv_sec; ?> #sysobjlst");
				lv_ul.empty();
				for(i = 0; i < data.length; i++){
					lv_usrcod = data[i]["usrcod"].toLowerCase();
					lv_readonly = (lv_usrcod==""?"false":(lv_usrcod!="<?= strtolower($vew_sec->usrcod); ?>"?"true":"false"));
          
          let lv_sysdevgrp = JSON.parse( data[i]["sysdevgrp"]==""?"[]":data[i]["sysdevgrp"] );
          
					// el objeto NO tiene grupo de desarrolo, ninguno puede editarlo?
					if( lv_sysdevgrp=="" || lv_sysdevgrp==null ){
						lv_edit = false;
						lv_view = true;
						lv_readonly = true; 
          // si el grupo de desarrollo NO coincide => solo lectura / no visualizacion
         	} else if( !lv_sysdevgrp.some(valor => lv_usrdevgrp.includes(valor.toString()) )){
            lv_edit = false;
            lv_view = ( data[i]["sysobjsys"]=="1" ? true : false );
            lv_readonly = true;
          // si el grupo de desarrollo coincide => edicion
          } else {
            lv_edit = true;
            lv_view = true;
          }          
          
          if( lv_view==true ){
            lv_ul.append("<div name='sysobj' data-sysobjcod='"+data[i]["sysobjcod"]+"' data-sysobjclstyp='"+data[i]["sysobjclstyp"]+"' data-usrcod='"+lv_usrcod+"' data-readonly='"+lv_readonly+"' class='tmssSysObjEdtObjLst'>"
                          +"<div>"+data[i]["sysobjtxt"].toUpperCase()
														+(lv_edit==false?"<i class='far fa-eye pull-right pl-15'></i>":"")
														+"<i class='"+(lv_usrcod==""?"":(lv_usrcod!="<?= strtolower($vew_sec->usrcod); ?>"?"far fa-lock":"far fa-pencil-alt"))+" pull-right' title='"+(data[i]["lckttl"]!=undefined?data[i]["lckttl"]:data[i]["usrcod"])+"'></i>"
													+"</div>"
                          +"<div style='font-size:8px;'>"+data[i]["sysobjclstxt"]+"</div>"
                          +"</div>");
          }
				}

				// revisa si algun archivo fue modificado para fijar marca de edicion
				for(i = 0; i < <?= $lv_sec; ?>_modified.length; i++){
					$("#<?= $lv_sec; ?> #sysobjlst div[data-sysobjcod="+<?= $lv_sec; ?>_modified[i]+"]").addClass("tmssSysObjEdtObjMod");
				}

				// attach eventos
				$("#<?= $lv_sec; ?> #sysobjlst div[name=sysobj]").on("click",function(e){e.preventDefault();
					<?= $lv_sec; ?>_openFile( $(this).data("sysobjcod") );
				});

			});
		}
	</script>
	<script>
		// APERTURA ARCHIVOS. abre el contenido de un archivo
		function <?= $lv_sec; ?>_openFile( lp_sysobjcod ) {
			if( $("#<?= $lv_sec; ?> div[name=divobjedt] ul li a[data-sysobjcod="+lp_sysobjcod+"]").length>0 ){
				// FALTA: preguntar si hay que recargar el archivo o no
				// se realiza la visualización del tab
				$("#<?= $lv_sec; ?> div[name=divobjedt] ul li a[data-sysobjcod="+lp_sysobjcod+"]").trigger("click");
			} else {
				var lv_post = [{name:"sysobjcod",value:lp_sysobjcod}]
				tmssCallProcess("?prg=sysobj&act=flecont",lv_post,function(data){
					if(data["errtyp"]!="S"){
						toastr.warning(data["errcod"]+":"+data["errtxt"]);
						return false;
					}
					
					// obtiene datos del objeto
					var lv_sysobjcod = data["sysobjcod"];
					var lv_obj = $("#<?= $lv_sec; ?> #sysobjlst div[data-sysobjcod="+lv_sysobjcod+"]");
					var lv_sysobjtxt = data.fleobj.sysobjtxt;
					var lv_sysobjclstxt = data.fleobj.sysobjclstxt;
					var lv_sysobjclstyp = data.fleobj.sysobjclstyp;
					
					// boton de cerrado
					var lv_cls = "<span onclick='<?= $lv_sec; ?>_ask_save("+lv_sysobjcod+");' style='cursor:pointer;font-size:8px;padding-top:5px;' class='pull-right'><i class='fa fa-times'></i></span>";

					// solapa
					var lv_tab = "<li role='presentation' class='active'>"
												+"<a href='#<?= $lv_sec; ?>_tab_sysobjcod"+lv_sysobjcod+"' role='tab' data-toggle='tab' data-sysobjcod='"+lv_sysobjcod+"' data-sysobjclstyp='"+lv_sysobjclstyp+"' class='tmss-tab-edt'>"
													+"<div>"+lv_sysobjtxt+" "+lv_cls+"</div>"
													+"<div style='font-size:8px;'>"+lv_sysobjclstxt+"</div>"
												+"</a>"
											+"</li>";
					$("#<?= $lv_sec; ?> div[name=divobjedt] ul li").removeClass("active");
					$("#<?= $lv_sec; ?> div[name=divobjedt] ul").append( lv_tab );

					// añade evento a la solapa
					// al hacer click verifica si el contenido de la solapa se modifico para mostrar el boton de garbado
					$("#<?= $lv_sec; ?> div[name=divobjedt] ul li a[data-sysobjcod="+lv_sysobjcod+"]").on("click",function(e){ e.preventDefault();
						<?= $lv_sec; ?>_chgShowControls($(this).data("sysobjcod"));
						for(i=0; i < <?= $lv_sec; ?>_lg_editors.length; i++){
							if(<?= $lv_sec; ?>_lg_editors[i].sysobjcod == $(this).data("sysobjcod")){
								<?= $lv_sec; ?>_lg_editors[i].editor.focus();
								break;
							}
						}
					});

					// contenido de la solapa
					var lv_flecont = data["flecnt"];
					
					var lv_table = "";
					if(lv_sysobjclstyp=="TABLE"){
						lv_table = "<div class='container-fluid'><table class='table table-condensed'><thead><tr><th>Key</th><th>Name</th><th>Type</th><th>Atr</th></thead><tbody>";
						for(var i=0; i<lv_flecont.length; i++){
							lv_table += "<tr>"
												+"<td></td>"
												+"<td>"+lv_flecont[i]["name"]+"</td>"
												+"<td>"+lv_flecont[i]["xtypename"]+(lv_flecont[i]["xtype"]=="231"?"("+(lv_flecont[i]["prec"]==-1?"MAX":lv_flecont[i]["prec"])+")":"")+"</td>"
												+"<td>"+(lv_flecont[i]["isnullable"]=="1"?"":"NOT NULL ")+(lv_flecont[i]["colstat"]==1?"Auto ":"")+"</td>"
												+"</tr>";
						}
						lv_table += "</tbody></table></div>";
					}
					
					var lv_txt = "<div role='tabpanel' class='tab-pane active' id='<?= $lv_sec; ?>_tab_sysobjcod"+lv_sysobjcod+"' style='height:100%;'>"
											+(lv_sysobjclstyp=="TABLE"?lv_table:"<textarea id='sysobjsrc"+lv_sysobjcod+"' data-sysobjcod='"+lv_sysobjcod+"'></textarea>")
											+"</div>";
					$("#<?= $lv_sec; ?> div[name=divobjedt] div.tab-content div.tab-pane.active").removeClass("active");
					$("#<?= $lv_sec; ?> div[name=divobjedt] div.tab-content").append( lv_txt );

					var lv_mode;
					lv_mode = "application/x-httpd-php";
					if(lv_sysobjclstyp=="SP"){ lv_mode = "text/x-mssql"; }
					if(lv_sysobjclstyp=="FN"){ lv_mode = "text/x-mssql"; }
					if(lv_sysobjclstyp=="JS"){ lv_mode = "text/javascript"; }
					if(lv_sysobjclstyp=="CSS"){ lv_mode = "text/css"; }
					if(lv_sysobjclstyp=="PHP"){ lv_mode = "application/x-httpd-php"; }

					var lv_readonly = (lv_sysobjclstyp=="FN" || lv_sysobjclstyp=="SP" || lv_sysobjclstyp=="JS" || lv_sysobjclstyp=="CSS" || lv_sysobjclstyp=="PHP" ? lv_obj.data("readonly") : true );
					
					//declara el editor
					tmssLoadScript("codemirror",function(){
						var lv_editor = CodeMirror.fromTextArea($("#<?= $lv_sec; ?> #sysobjsrc"+lv_sysobjcod).get(0), {
							lineNumbers: true,
							styleActiveLine: true,
							matchBrackets: true,
							tabSize:2,
							readOnly: lv_readonly,
							mode: lv_mode,
							keyMap: "sublime",
							autoCloseBrackets: ($("#<?= $lv_sec; ?> #autcls").prop("value")=="1"?true:false),
							theme: $("#<?= $lv_sec; ?> #usrthm").prop("value"),
							extraKeys: {
								"F11": function(cm) { cm.setOption("fullScreen", !cm.getOption("fullScreen")); },
								"Esc": function(cm) { if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false); }
							}
						});
						lv_editor.setValue( lv_flecont );
						lv_editor.clearHistory();
						lv_editor.setSize("100%", "100%");
						lv_editor.refresh();
						if(lv_obj.data("readonly")==true && lv_obj.data("usrcod")!=""){
							toastr.warning("El objeto esta siendo bloqueado por ["+lv_obj.data("usrcod").toUpperCase()+"]");
						}

						// añade el editor a la lista de editores
						<?= $lv_sec; ?>_lg_editors.push( {sysobjcod:lv_sysobjcod,editor: lv_editor,source: lv_flecont} );

						// evento de modificacion
						// al modificar datos en el editor se verifica si cambio respecto del archivo original y se muestra el boton de grabado.
						if(!lv_readonly){
							lv_editor.on("keyup",function(lp_editor){
								//obtiene el codigo de origen
								var lv_source = "";
								for(var i = 0; i <= <?= $lv_sec; ?>_lg_editors.length - 1; i++){
									if(<?= $lv_sec; ?>_lg_editors[i].sysobjcod == lv_sysobjcod){
										lv_source = <?= $lv_sec; ?>_lg_editors[i].source;
										break;
									}
								}
								//verifica si el archivo fue modificado
								<?= $lv_sec; ?>_chgCheck( lp_editor.getValue(), lv_source, lv_sysobjcod );
							});
						}
						
					});

					//muestra la solapa
					$("#<?= $lv_sec; ?> div[name=divobjedt] ul li a[data-sysobjcod="+lv_sysobjcod+"]").trigger("click");

				});
			}
		}
	</script>
	<script>
		// CIERRA SOLAPA
	
		function <?= $lv_sec; ?>_tab_sysobjcod_cls( lp_sysobjcod ){
			// codigo de la solapa a la cual se va a mover luego de cerrar la solapa actual, si no hay mas de una solapa abierta, mantiene por default de la solapa actual
      var lv_next_tabcod = "";
			//encuentra el editor de la solapa
			for(i=0; i < <?= $lv_sec; ?>_lg_editors.length; i++){
				if(<?= $lv_sec; ?>_lg_editors[i].sysobjcod == lp_sysobjcod){
					//selecciona otra tab abierta si la tab a cerrar esta seleccionada
					if(<?= $lv_sec; ?>_lg_editors.length>1){
						if($("#<?= $lv_sec; ?> div[name=divobjedt] ul li a[data-sysobjcod="+<?= $lv_sec; ?>_lg_editors[i].sysobjcod+"]").parent().hasClass("active")){
              lv_next_tabcod = (i == 0) ? <?= $lv_sec; ?>_lg_editors[i+1].sysobjcod : <?= $lv_sec; ?>_lg_editors[i-1].sysobjcod;
              // segun el codigo, se desplaza para la izquierda o para la derecha
							$("#<?= $lv_sec; ?> div[name=divobjedt] ul li a[data-sysobjcod="+lv_next_tabcod+"]").trigger("click");
						}
					}
          //remueve el editor de la lista
					<?= $lv_sec; ?>_lg_editors.splice(i,1);
					break;
				}
			}
			
			//cierra solapa
      var lv_current_index = <?= $lv_sec; ?>_modified.findIndex(function(el){return el==lp_sysobjcod;});
      if(lv_current_index != -1){
        <?= $lv_sec; ?>_modified.splice(lv_current_index,1);
        <?= $lv_sec; ?>_chgShowControls( lp_sysobjcod );
        $("#<?= $lv_sec; ?> #sysobjlst div[data-sysobjcod="+lp_sysobjcod+"]").removeClass("tmssSysObjEdtObjMod");
      }
			$("#<?= $lv_sec; ?> div[name=divobjedt] div.tab-content #<?= $lv_sec; ?>_tab_sysobjcod"+lp_sysobjcod).remove();
			$("#<?= $lv_sec; ?> div[name=divobjedt] ul li a[data-sysobjcod="+lp_sysobjcod+"]").remove();
		}
	</script>
	<script>
		// GRABAR ARCHIVO. graba un archivo modificado
	
		// GRABAR. evento para graba el archivo actual
		$("#<?= $lv_sec; ?> #btnsve").on("click",function(e){ e.preventDefault();
			<?= $lv_sec; ?>_sveFile( $("#<?= $lv_sec; ?> div[name=divobjedt] ul li.active").children(0).data("sysobjcod") );
		});


		// funcion de grabado
		function <?= $lv_sec; ?>_sveFile( lp_sysobjcod ){
			// obtiene indice del editor
			var i = <?= $lv_sec; ?>_lg_editors.findIndex(function(el){return el.sysobjcod==lp_sysobjcod;});
			if(i==-1){ toastr.warning("Editor ["+lp_sysobjcod+"] no encontrado."); return false; }

			// graba el objeto
			var lv_post = [{name:"sysobjcod",value:lp_sysobjcod},{name:"flecont",value:<?= $lv_sec; ?>_lg_editors[i].editor.getValue()}];
			tmssCallProcess( "?prg=systraobj&act=11", lv_post, function(data){
				if(data["errtyp"] == "S"){
					//revisa que exista el editor y guarda el valor actual
					if(typeof <?= $lv_sec; ?>_lg_editors[i].editor !== "undefined"){
						<?= $lv_sec; ?>_lg_editors[i].source = <?= $lv_sec; ?>_lg_editors[i].editor.getValue();
						<?= $lv_sec; ?>_chgCheck(<?= $lv_sec; ?>_lg_editors[i].editor.getValue(), <?= $lv_sec; ?>_lg_editors[i].source,lp_sysobjcod);
					}
					toastr.success("Archivo grabado");

				// objeto no asociado a OT
				} else if(data['errtyp'] == "W"){

					// muestra dialogo de selección de OT
					var lv_post = [{name:"sysobjcod",value:$("#<?= $lv_sec; ?> div[name=divobjedt] ul a[data-sysobjcod="+lp_sysobjcod+"]").data("sysobjcod")}];
					tmssCallProcess("?prg=systraobj&act=01",lv_post,function(data){
						BootstrapDialog.show({
							title:"Orden de transporte",
							message:$(data),
							type: BootstrapDialog.TYPE_INFO,
							size: BootstrapDialog.SIZE_MEDIUM,
							closable:true,
							draggable:true,
							buttons: [{	label: "<?= $vew_lang->create; ?>", cssClass: "btn-default pull-left",	action: function(dialog){                
													tmssCallProcess("?prg=systra&act=edt",[],function(data){
														BootstrapDialog.show({
															title:"Orden de transporte",
															message:$(data),
															type: BootstrapDialog.TYPE_INFO,
															size: BootstrapDialog.SIZE_MEDIUM,
															closable:false,
															buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialog){dialog.close();}},
																				{ label: "<?= $vew_lang->save; ?>", cssClass: "btn-success", action: function(dialog2){
																						if(!tmssCheckRequiredFields( dialog2.$modalBody.find("form:first") )){ return false; }

																						// obtiene datos ingresados
																						var lv_sysdevgrpcod = dialog2.$modalBody.find("#sysdevgrpcod").val();
																						var lv_systratxt = dialog2.$modalBody.find("#systratxt").val();
																						var lv_srcbuscod = dialog2.$modalBody.find("#srcbuscod").val();
																						var lv_srcobjtyp = dialog2.$modalBody.find("#srcobjtyp").val();
                                          	var lv_sysobjcod = dialog.$modalBody.find("#sysobjcod").val();
																						var lv_srcobjcod001 = dialog2.$modalBody.find("#srcobjcod001").val();
																						var lv_srcobjcod002 = dialog2.$modalBody.find("#srcobjcod002").val();
                                          	var lv_usrcod = dialog.$modalBody.find("#usrcod").val();

																						// graba ot
																						var lv_post = [{name:"systratxt",value:lv_systratxt}
                                                          ,{name:"sysdevgrpcod",value:lv_sysdevgrpcod}
																													,{name:"srcbuscod",value:lv_srcbuscod}
																													,{name:"srcobjtyp",value:lv_srcobjtyp}
																													,{name:"srcobjcod001",value:lv_srcobjcod001}
																													,{name:"srcobjcod002",value:lv_srcobjcod002}
																													,{name:"docsts",value:"A"}
                                                          ,{name:"usrcod",value:lv_usrcod}
                                                          ,{name:"sysobjcod",value:lv_sysobjcod}
                                                          ,{name:"systraflg", value:"X"}];
																						tmssCallProcess("?prg=systra&act=00",lv_post,function(data){
                                              if(data.systracod == ""){
                                                toastr.warning("No se pudo crear la orden de transporte")
                                              }else{
                                                // si se creo la orden, la asigno a mi objeto post
                                                lv_post.push( { name:"systracod",value:data.systracod } )
                                                tmssCallProcess("?prg=systraobj&act=00",lv_post,function(data){ <?= $lv_sec; ?>_sveFile(data["sysobjcod"]); });
                                              }
																						});
																						// cierra el popup
																						dialog2.close();
																				 }},]
														});
													});
                					// Cierro el dialog de asignacion de orden/usuario
                					dialog.close();
												}},
												{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialog){dialog.close(); } },
												{	label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success accept hidden",	action: function(dialog){
													if(!tmssCheckRequiredFields( dialog.$modalBody.find("form:first") )){ return false; }

													//obtiene datos
													var lv_systracod = dialog.$modalBody.find("#systracod").val();
													var lv_usrcod = dialog.$modalBody.find("#usrcod").val();
													var lv_systratxt = dialog.$modalBody.find("#systratxt").val();
													var lv_sysobjcod = dialog.$modalBody.find("#sysobjcod").val();
													var lv_srcbuscod = dialog.$modalBody.find("#srcbuscod").val();
													var lv_srcobjtyp = dialog.$modalBody.find("#srcobjtyp").val();

													// asigna el objeto al ot
													var lv_post = [{name:"systracod",value:lv_systracod}
																				,{name:"systratxt",value:lv_systratxt}
																				,{name:"usrcod",value:lv_usrcod}
																				,{name:"srcbuscod",value:lv_srcbuscod}
																				,{name:"srcobjtyp",value:lv_srcobjtyp}
																				,{name:"sysobjcod",value:lv_sysobjcod}
																				,{name:"sysobjcnt",value:<?= $lv_sec; ?>_lg_editors[i].editor.getValue()}
																				,{name:"docsts",value:"A"}];
													tmssCallProcess("?prg=systraobj&act=00",lv_post,function(data){
														<?= $lv_sec; ?>_sveFile(data["sysobjcod"]);
													});
													dialog.close();
												}}],
							onshown: function(dialog){
								dialog.$modalBody.find("#systracod").on("change",function(){
									dialog.$modalFooter.find(".accept").removeClass("hidden");
								});
							}
						});
					});
				}else{
					toastr.warning(data["errcod"]+":"+data["errtxt"]);
				}
			});
		}
	</script>
	<script>
		// VERIFICA MODIFICACION. verifica si el contenido fue modificado y cambia el estado de un archivo
		function <?= $lv_sec; ?>_chgCheck( lp_current, lp_source, lp_sysobjcod ){
			//revisa si el contenido del editor es igual al original y remueve el codigo al array de archivos modificados
			if(lp_current == lp_source){
				<?= $lv_sec; ?>_modified.splice( <?= $lv_sec; ?>_modified.findIndex(function(el){return el==lp_sysobjcod;}) , 1 );
				$("#<?= $lv_sec; ?> div[name=divobjedt] ul li a[data-sysobjcod="+lp_sysobjcod+"]").attr("style", "");
				$("#<?= $lv_sec; ?> #sysobjlst div[data-sysobjcod="+lp_sysobjcod+"]").removeClass("tmssSysObjEdtObjMod");
				<?= $lv_sec; ?>_chgShowControls(lp_sysobjcod);

			// si no fue modificado previamente, añade el codigo al array de archivos modificados
			}else	if(<?= $lv_sec; ?>_modified.findIndex(function(el){return el==lp_sysobjcod;})==-1){
				<?= $lv_sec; ?>_modified.push(lp_sysobjcod);
				$("#<?= $lv_sec; ?> div[name=divobjedt] ul li a[data-sysobjcod="+lp_sysobjcod+"]").attr("style","color:red!important;");
				$("#<?= $lv_sec; ?> #sysobjlst div[data-sysobjcod="+lp_sysobjcod+"]").addClass("tmssSysObjEdtObjMod");
				<?= $lv_sec; ?>_chgShowControls(lp_sysobjcod);
			}
		}
	</script>
	<script>
		function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if(lp_prm["action"]=="99"){ lp_prm["action"]="edt";}
		}
	</script>
  <script>
    // ATAJO TECLADO. grabar archivo (Ctrl + S)
    $(document).on("keydown", function(e) {
        if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === "s") {
            e.preventDefault(); // evita guardado del navegador
            var $btnGuardar = $("#<?= $lv_sec; ?> #btnsve");
            // solo guarda si el botón está visible
            if ($btnGuardar.length && $btnGuardar.is(":visible")) {
                $btnGuardar.click();
            }
        }
    });
</script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
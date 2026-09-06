<?php
	// url del formulario
  $lv_lnk = '?prg=grldmsdoc';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';
	//$lv_dockey = $vew_data->grldmsdoccod;

	// titulo
	$lv_title = $vew_data->grldmsdoctxt;
	
	// módulo y programa
	$lv_mdlcod = 'GRL';
	$lv_prgcod = 'DMS';

	$vew_actcod = '02';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
	
	$vew_tbl['toggle'] = array('pos'=>'L', 'per'=>true, 'id'=>'sdebartog', 'ttl'=>'', 'icn'=>'far fa-bars', 'css'=>'btn navbar-btn tmss-navbar-btn');
	$vew_tbl['sveL'] = array('per'=>false);
	$vew_tbl['svecus'] = $vew_data->grldmsdocsrc=='T' ? array('pos'=>'L','per'=>true, 'ttl'=>$vew_lang->save, 'id'=>'btnsve','icn'=>'fas fa-save', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success tmss-desk-btn' ) : array('per'=>false);
	$vew_tbl['pbl'] = $vew_data->versts=='E' ? array('pos'=>'L','per'=>true, 'ttl'=>$vew_lang->publish, 'id'=>'btnpbl','icn'=>'fas fa-send', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-warning tmss-desk-btn', 'acc'=>'' ) : array('per'=>false);
	$vew_tbl['newVer'] = $vew_data->grldmsdocsrc!='T' ? array('pos'=>'L','per'=>true, 'ttl'=>'Nueva Versi&oacute;n', 'id'=>'btnnewver','icn'=>'fas fa-file-circle-plus', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success tmss-desk-btn', 'acc'=>'' ) : array('per'=>false);
	$vew_tbl['sveR'] = array('per'=>false);
	$vew_tbl['canc'] = array('per'=>false);
	$vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['new'] = array('per'=>false);
	$vew_tbl['del'] = array('id'=>'btndel', 'per'=>true, 'acc'=>strtoupper($vew_doc->getTagValue($vew_data->sysdocclsatr, 'use_version'))=='X' || $vew_data->versts=='E' ? '' : $lv_sec.'_fnc({action: '.chr(39).'04'.chr(39).'});');
	
	if ( $vew_data->grldmsdocsrc=='T' ){
    $vew_tbl['model'] = array('per'=>true, 'pos'=>'D', 'id'=>'btnmdl', 'ttl'=>'Modelos', 'icn'=>'far fa-book', 'acc'=>'', 'css'=>'tmss-Opt tmssAlwaysEnabled tmssHiddeOnRead');
  }
	$vew_readonly = false;

?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>	

	<style>
  	#<?= $lv_sec; ?> .grldmsdocvew-sidebar {
      position: fixed;
      top: 154px;
      bottom: 0;
      left: -670px; /* ahora sale desde la izquierda */
      width: 400px;
      overflow-y: auto;
      overflow-x: hidden;
      background: #fff;
      box-shadow: 2px 0 20px rgba(69,65,78,.07);
      transition: all 0.5s ease;
      z-index: 1000;
      padding: 20px;
    }
    #<?= $lv_sec; ?> .grldmsdocvew-sidebar-visible { left: 0; }
    #<?= $lv_sec; ?> .tmss-navbar-container { position: relative; }
    #<?= $lv_sec; ?> .main-content { transition: all 0.5s ease;  margin-left: 0; }
    #<?= $lv_sec; ?> .sidebar-open .main-content { margin-left: 400px; }
    
    #<?= $lv_sec; ?>_tab002 { overflow-x: hidden; }
    #<?= $lv_sec; ?> .jstree-anchor { white-space: nowrap; }
    #<?= $lv_sec; ?> .jstree { overflow-x: hidden; }

    /* el editor de texto se inyecta dentro de un <form>; le quito márgenes y
       padding para que el espacio sobrante al final no genere scroll de página */
    #<?= $lv_sec; ?> #docvewcnt { padding-bottom: 0; margin-bottom: 0; }
    #<?= $lv_sec; ?> #docvewcnt > form { margin: 0; }
    #<?= $lv_sec; ?> #docvewcnt .tox-tinymce,
    #<?= $lv_sec; ?> #docvewcnt .mce-tinymce { margin-bottom: 0; }
    
    /* Título del Documento */
    #<?= $lv_sec; ?> .tmss-navbar-title {
      overflow: visible;
      font-weight: bold;
      font-size: 16px;
      position: absolute;
      left: 50%;
      transform: translateX(-50%);
      white-space: nowrap;
      font-weight: bold;
      font-size: 16px;
      line-height: 50px;
      pointer-events: none;
      flex-grow: 1 !important;
      min-width: 0 !important;
    }
    
  </style>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('grldmsdocvercod','hidden',$vew_data->grldmsdocvercod ?? ''); ?>
    <?= gethtml('txtcod', 'hidden', '') ?>
    <?= gethtml('iaachthst', 'hidden', '') ?>
    <div class="grldmsdocvew-sidebar" id="sidebar">
      <div class="container-fluid" role="tabpanel"> 
        <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
          <li role="presentation" <?= $vew_data->grldmsdocsrc !== 'T' ? 'class="active"' : '' ?>><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
          <?php if($vew_data->grldmsdocsrc=='T'){ ?>
          	<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->navigation; ?></a></li>
          	<?php if($vew_data->iaaactlst){ ?>
          		<li><a href="#" id="btnai" class="card-icon"><i class="far fa-wand-magic-sparkles"></i></a></li>
          <?php } } ?>
        </ul>
        <div class="tab-content tmss-tab-content">
          <div role="tabpanel" <?= $vew_data->grldmsdocsrc !== 'T' ? 'class="tab-pane active"' : 'class="tab-pane"' ?> id="<?= $lv_sec; ?>_tab001">
            <?php $lv_btngrp = '<span class="input-group-btn">'.
                                 '<a href="#" id="btnttlsve" class="btn btn-success tmssInputBtn">&nbsp;<i class="fas fa-save"></i></a>'.
                               '</span>';
                  echo vew_boot($lv_col210,	array('label'=>$vew_lang->title,
                                                  'input'=>vew_boot(array('style'=>'custom', 'readonly'=>false),
                                                                    array('custom'=>$lv_btngrp, 'input'=>gethtml('grldmsdoctxt', 'doccmt1x50', $vew_data->grldmsdoctxt, $lv_default))),
                                                 )
                               );
            ?>
            <?php 
              $lv_alldocver = array_reverse(explode(",", $vew_data->alldocver));
              $lv_alldocver = array_combine($lv_alldocver, $lv_alldocver);
              $lv_defvalkey = array_search($vew_data->grldmsdocvercodext.' - '.$vew_data->ctedte->format('d/m/Y'), $lv_alldocver) ?? 0;
              echo vew_boot($lv_col48, array('label'=>'No. de Versi&oacuten','input'=>gethtml('grldmsdocvernum',$lv_alldocver,$lv_alldocver[$lv_defvalkey]/*$vew_data->grldmsdocvercodext.' - '.$vew_data->ctedte->format('d-m-Y')*/,$lv_default))); ?>
            <?= vew_boot($lv_col57, array('label'=>'Clase de Doc.','input'=>gethtml('sysdocclstxt','doccmt1x50',$vew_data->sysdocclstxt,$lv_always_disabled))); ?>
          </div>
          <div role="tabpanel" class="tab-pane <?= $vew_data->grldmsdocsrc === 'T' ? 'active' : '' ?>" id="<?= $lv_sec; ?>_tab002"></div>
        </div>
      </div>
		</div>
    <div class="main-content">
      <div class="container-fluid" role="tabpanel">
        <div class="row">
          <div class="col-md-12" id="docvewcnt">
            <iframe name="docvew" width="100%" height="1000px" frameborder="0"></iframe>
          </div>
        </div> 
      </div> <!-- /container-fluid -->
    </div>
    
	</form>
  <form id="docvewfrm" method="POST" action="/index.php?prg=grldmsdoc&act=getfilecontents" target="docvew">
    <input type="hidden" name="grldmsdocvercod" value="<?= $vew_data->grldmsdocvercod ?>"><input type="hidden" name="grldmsdoctxt" value="<?= $vew_data->grldmsdoctxt ?>"><input type="hidden" name="fletyp" value="<?= $vew_data->fletyp ?>"><input type="hidden" name="fleext" value="<?= $vew_data->fleext ?>">
  </form>
	<script>
		// agrego datos adicionales al popup de Info
		let lv_<?= $lv_sec; ?>_infusrdat = [{"infttl":"<?= $vew_lang->size; ?>","infdat":"<?= $vew_data->flesze; ?>"},
																				{"infttl":"<?= $vew_lang->type; ?>","infdat":"<?= $vew_data->fleext; ?>"},
                                       	{"infttl":"<?= $vew_lang->status; ?>","infdat":"<?= $vew_data->docsts; ?>"}];

    // estado vigente de la versión en edición. Se mantiene en memoria para poder
    // grabar SIN recargar la vista (así no se pierde el scroll ni el contexto). Sólo
    // cuando el grabado crea una versión nueva (documento que no estaba en edición)
    // se recarga la vista una vez, para reflejar el nuevo estado.
    let <?= $lv_sec; ?>_vercod = <?= json_encode($vew_data->grldmsdocvercod); ?>;
    let <?= $lv_sec; ?>_versts = <?= json_encode($vew_data->versts); ?>;
    
    // recarga de la vista
    function <?= $lv_sec; ?>_ViewRefresh( lp_pstdat ){
      tmssLink( '?prg=grldmsdoc&act=vwdoc&prm_mdlcod=GRL&prm_prgcod=DMS', [{target:'_replace_with', post_data:lp_pstdat, target_id:<?= $lv_sec; ?>}] );
    }
		
		// apertura y cerrado de la sidebar
    $('#<?= $lv_sec; ?> #sdebartog').on("click", function(e) { 
      e.preventDefault(); 

      $('#<?= $lv_sec; ?> #sidebar').toggleClass('grldmsdocvew-sidebar-visible');
      $('#<?= $lv_sec; ?>_frm').toggleClass('sidebar-open');

			//tmssLogin("La sesión caducó. Por favor, ingrese la contraseña nuevamente.")
    });
               
		// selección de modelos de texto
		$("#<?= $lv_sec; ?> #btnmdl").on("click", function(e) { e.preventDefault();
			$("#<?= $lv_sec; ?> #txtcod").prop("value","");
			tmssPopup("Modelos","?prg=grldattxt&act=08&prm_vewcod=VEW_GRL_DAT_TXT&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[txtcod:txtcod],[dstcnttxt:cnttxt]&prm_fldflt=[txtsrccod:**]",function(){
        var lv_txtcod = $("#<?= $lv_sec; ?> #txtcod").prop("value");
				if(lv_txtcod!=""){
					tmssCallProcess("?prg=grldattxt&act=05", {txtcod: lv_txtcod}, function(data) {
            // le pasa el modelo de novedad a la preview
            tinyMCE.activeEditor.setContent(data);
            tinyMCE.triggerSave();
					});
				}
			});
		});
    
    // guardado del título 
    $("#<?= $lv_sec; ?> #btnttlsve").on("click",function(e){e.preventDefault();
			var lv_pstdat=[{name:"grldmsdoccod",value:<?= $vew_data->grldmsdoccod; ?>},
                     {name:"grldmsfldcod",value:<?= $vew_data->grldmsfldcod; ?>},
                     {name:"grldmsdoctxt",value:$("#<?= $lv_sec; ?> input#grldmsdoctxt").val()}];
			tmssCallProcess("?prg=grldmsdoc&act=00",lv_pstdat,function(data){
      	if (data.errcod == 0){
          $(".tmss-navbar-title").html($("#<?= $lv_sec; ?> input#grldmsdoctxt").val());
          toastr.success("T&iacute;tulo actualizado");
        }else{
          toastr.warning("No se pudo cambiar el nombre")
        }
      });
		});
      
    // PopUp de la IA
    $("#<?= $lv_sec; ?> #btnai").on("click",function(e){e.preventDefault();
			// le envío el lv_sec para que pueda recuperar el texto y otro contenido relevante del editor desde el PopUp
			const lv_pstdat = [{name:"docvwrsec", value:"<?= $lv_sec; ?>"},
                         {name: "sysappiaaactcodext", value: "GRL_DMS_ASS" }];
			tmssLink( "?prg=sysappiaa&act=openaiassistant", [{target:"_new_section",post_data:lv_pstdat}] );
		});
    
    // guardado del documento (texto)
    $("#<?= $lv_sec; ?> #btnsve").on("click",function(e){e.preventDefault();
      // si el documento NO está en edición, grabar crea una versión nueva (fork);
      // si ya está en edición, se sobrescribe la misma versión en el lugar.
      var lv_wasfork = (<?= $lv_sec; ?>_versts != 'E');
      var lv_pstdat=[{name:"grldmsdoccod",value:<?= $vew_data->grldmsdoccod; ?>},
                     {name:"grldmsdocvercod",value:<?= $lv_sec; ?>_vercod},
                     {name:"grldmsdocsrc",value:"<?= $vew_data->grldmsdocsrc; ?>"},
                     {name:"fletyp",value: "<?= $vew_data->fletyp; ?>"},
                     {name:"docsts",value:<?= $lv_sec; ?>_versts},
                     {name:"grldmsdoctxt",value:$("#<?= $lv_sec; ?> input#grldmsdoctxt").val()},
                     {name:"flecnt",value:tinymce.get('<?= $lv_sec; ?>_docvewmce').getContent()}];
      tmssCallProcess("?prg=grldmsdoc&act=uploadFile",lv_pstdat,function(data){
        if (data.errcod == 0){
          if (lv_wasfork){
            // se creó una nueva versión (borrador): recargo la vista una sola vez para
            // reflejar el nuevo estado (n° de versión, botón de publicar, etc.).
            var lv_refdat = [{name:"grldmsdocvercod",value:data.data.grldmsdocvercod}];
            <?= $lv_sec; ?>_ViewRefresh( lv_refdat );
          }else{
            // grabado en el lugar (misma versión): NO recargo la vista para no perder
            // el scroll ni el contexto. Actualizo el estado vigente, los campos ocultos
            // y limpio el flag "dirty" del editor (los cambios ya están guardados y
            // visibles, porque el usuario los acaba de hacer).
            <?= $lv_sec; ?>_vercod = data.data.grldmsdocvercod;
            $("#<?= $lv_sec; ?> #docvewfrm [name='grldmsdocvercod']").val(<?= $lv_sec; ?>_vercod);
            $("#<?= $lv_sec; ?>_frm [name='grldmsdocvercod']").val(<?= $lv_sec; ?>_vercod);
            if (<?= $lv_sec; ?>_editor) <?= $lv_sec; ?>_editor.setDirty(false);
          }
          toastr.success("Cambios guardados.");
        }else{
          toastr.warning("No se pudieron procesar los cambios.")
        }
      });
		});
    
    // publicación del documento
    $("#<?= $lv_sec; ?> #btnpbl").on("click",function(e){e.preventDefault();
			var lv_pstdat=[{name:"grldmsdoccod",value:<?= $vew_data->grldmsdoccod; ?>},
                     {name:"grldmsdocvercod",value:<?= $vew_data->grldmsdocvercod; ?>},
                     {name:"sysdocclscod",value:<?= $vew_data->srcobjdocclscod; ?>}];
                      
			BootstrapDialog.confirm({
        title: 'Publicar versi&oacute;n',
        message: '¿Desea publicar una nueva versi&oacute;n?',
        type: BootstrapDialog.TYPE_WARNING,
        callback: function(result) {
          if(result) {
           	tmssCallProcess("?prg=grldmsdoc&act=processfile",lv_pstdat,function(data){
              if (data.errcod == 0){
                var lv_pstdat = [{name:"grldmsdocvercod",value:data.data.grldmsdocvercod}];
                <?= $lv_sec; ?>_ViewRefresh( lv_pstdat );
                toastr.success("Documento publicado.");
              }else{
                toastr.warning("No se pudo publicar el documento.")
              }
      			});
          }
        }
      });
		});
    
    // subir una nueva versión del documento
    $("#<?= $lv_sec; ?> #btnnewver").on("click",function(e){ e.preventDefault();
        
			var lv_pstdat = [{name:"grldmsdoccod",value:<?= $vew_data->grldmsdoccod; ?>},
                       {name:"grldmsdocvercod",value:<?= $vew_data->grldmsdocvercod; ?>},
                       {name:"fletypcod",value:<?= $vew_data->fletypcod ?? null; ?>},
                       {name:"sysdocclscod",value:<?= $vew_data->srcobjdocclscod; ?>},
                       {name:"docsts",value:"<?= $vew_data->docsts; ?>"}];
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
                   	{ id:"btnsve", icon: "far fa-save", label: "<?= $vew_lang->save; ?>", cssClass: "btn-success hidden",
											action: function(dialog){ $(dialog.$modalBody).find("#btnsve").trigger("click"); }
										}],
          onhidden: function(dialogRef) { 
																					// recupero el ID de la nueva versión desde el modal y cargo dicha versión
            															if ( $(dialogRef.getModal()).data("newvercod") ){
                                            lv_pstdat = [{name:"grldmsdocvercod",value:$(dialogRef.getModal()).data("newvercod")}];
                                          }
            															<?= $lv_sec; ?>_ViewRefresh( lv_pstdat ); 
          															}
        });
			});
		});
    
    // seleccionar versiones
    $("#<?= $lv_sec; ?> #grldmsdocvernum").on("change",function(e){e.preventDefault();
			let lv_selvernum = $(this).val().split(' - ')[0];//$(this).find(":selected").text();
			var lv_pstdat=[{name:"grldmsdoccod",value:<?= $vew_data->grldmsdoccod; ?>}];
			// listo todas las versiones del documento
			tmssCallProcess("?prg=grldmsdoc&act=18",lv_pstdat,function(data){
      	if (data.errcod == 0){
          // recorro todas las versiones hasta encontrar la que corresponda al número de versión seleccionado
          for (let i = 0; i < data.data.length; i++) {
            if (data.data[i].grldmsdocvercodext == lv_selvernum) {
              	// cuando encuentro la versión seleccionada, tomo su ID y actualizo la vista con dicha versión
                var lv_pstdat = [{name:"grldmsdocvercod",value:data.data[i].grldmsdocvercod}];
          			<?= $lv_sec; ?>_ViewRefresh( lv_pstdat );
                break;
            }
        	}
        }else{
          toastr.warning("No se pudo cambiar la versi&oacute;n")
        }
      });
		});
    
    
   	$(document).ready(function() {
      // reviso si el contenido es un texto.
      var lv_istxt = <?= json_encode(str_starts_with($vew_data->fletyp, 'text')); ?>;
      
      // muestro el título
      $("#<?= $lv_sec ?> .tmss-navbar-title").show();
      
      if (lv_istxt){
        // elimino el iframe.
        $('#<?= $lv_sec; ?> [name="docvew"]').remove();
  
        // recupero los parámetros desde el form.
        let lv_pstdat = $('#<?= $lv_sec; ?> #docvewfrm').serializeArray().reduce(function(lp_obj, lp_fld) {
                        	lp_obj[lp_fld.name] = lp_fld.value;
                          return lp_obj;
                      	}, {});
        
        // recupero el texto utilizando getFileContents.
        tmssCallProcess("?prg=grldmsdoc&act=getfilecontents", lv_pstdat, function(data){
          // inserto la card con el contenido en el DOM.
          $('#<?= $lv_sec; ?> #docvewcnt').html(data);
          $('#<?= $lv_sec; ?> #docvewmce').attr('id', '<?= $lv_sec; ?>_docvewmce');

          // inicializo el tinyMCE en el textarea que tiene el contenido.
          tmssLoadScript("tinymce",function(){
            // remuevo cualquier instancia previa
            tinyMCE.remove('#<?= $lv_sec; ?>_docvewmce');

            // altura disponible exacta: desde el tope real del contenedor del editor
            // hasta el fondo del viewport, para que entre justo sin scroll de página.
            const lv_edtcnt = document.querySelector('#<?= $lv_sec; ?> #docvewcnt');
            const lv_edttop = lv_edtcnt ? lv_edtcnt.getBoundingClientRect().top : 160;
            const lv_edth = Math.max(300, Math.floor(window.innerHeight - lv_edttop - 10));

            tinyMCE.init({
              selector: "#<?= $lv_sec; ?>_docvewmce",
              height: lv_edth,
              max_height: lv_edth,
              resize: false,
              setup: function(lp_edt) {
                <?= $lv_sec; ?>_editor = lp_edt; // guardo la instancia
                let lv_edloaded = false;         // ¿ya restauré el scroll en esta instancia?

                lp_edt.on('init', function () {
                  // ajusto el alto del editor al espacio disponible exacto.
                  // difiero un frame para que las barras ya estén medidas.
                  requestAnimationFrame(() => <?= $lv_sec; ?>_fitEditor());

                  // observo la visibilidad para restaurar el scroll al volver de otra solapa
                  <?= $lv_sec; ?>_watchEdVisibility(lp_edt);

                  // guardo la posición de scroll ante cada desplazamiento del usuario
                  const lv_win = lp_edt.getWin();
                  if (lv_win) lv_win.addEventListener('scroll', () => <?= $lv_sec; ?>_saveEdScroll(lp_edt), { passive: true });
                });

                lp_edt.on('LoadContent', function () {
                  requestAnimationFrame(() => {
                  	<?= $lv_sec; ?>_ensureHeadingIds(lp_edt);
                    <?= $lv_sec; ?>_generateIndex(lp_edt);

                    // sólo en la primera carga de esta instancia restauro el scroll que
                    // tenía antes de grabar (la recarga de la vista recrea el editor).
                    if (!lv_edloaded) {
                      lv_edloaded = true;
                      <?= $lv_sec; ?>_restoreEdScroll(lp_edt);
                    }
                  });
                });

                let lv_idxtmr = null;
                lp_edt.on('SetContent'/*'SetContent change input undo redo'*/, function () {
                  if (!lp_edt.initialized) return;
                  clearTimeout(lv_idxtmr);
                  lv_idxtmr = setTimeout(() => {
                    <?= $lv_sec; ?>_generateIndex(lp_edt);
                  }, 300);
                });

                lp_edt.on('keydown', function (e) {
                  if (e.keyCode === 9) {                    // Tecla Tab
                    if (e.shiftKey) {
                      lp_edt.execCommand('Outdent');    // Shift + Tab
                    } else {
                      lp_edt.execCommand('Indent');     // Tab
                    }
                    e.preventDefault();
                    return false;
                  }
                });
              },
              language: 'es',
              menubar: false,
              toolbar: false,
              <?= $vew_readonly ? 'readonly: 1' : '' ?>
              <?php if(!$vew_readonly){ ?>
                  plugins: ['print paste preview fullpage importcss searchreplace autolink autosave save directionality visualblocks visualchars fullscreen image link media template codesample textcolor charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists wordcount imagetools textpattern noneditable help charmap emoticons table'],
                  menubar: 'file edit view insert format table tc',
                  toolbar: 'undo redo | bold italic underline strikethrough | fontselect fontsizeselect formatselect | alignleft aligncenter alignright alignjustify | outdent indent | numlist bullist checklist | forecolor backcolor casechange permanentpen removeformat | charmap emoticons | table tabledelete | tableprops tablerowprops tablecellprops | tableinsertrowbefore tableinsertrowafter tabledeleterow | tableinsertcolbefore tableinsertcolafter tabledeletecol | fullscreen preview print | insertfile image media link codesample | showcomments addcomment',
                  indentation: '25px',           // tamaño de la sangría
                  indent_use_margin: false,      // false = usa padding
                  content_style: `body { font-family: Helvetica, Arial, sans-serif; font-size: 14px; } 
                                  table { border-collapse: collapse; width: 100%; } 
                                  table, th, td { border: 1px solid #ccc; } 
                                  th, td { padding: 4px 8px; }`,
                  table_default_attributes: { border: '1' },
                  table_default_styles: { width: '100%', borderCollapse: 'collapse' },
              		paste_preprocess: function(plugin, args) {
                    // eliminar imágenes con blob
                    args.content = args.content.replace(/<img[^>]+src="blob:[^"]+"[^>]*>/gi, '');
                  },
                  buttons: [{ label: "<?= $vew_readonly ? $vew_lang->close : $vew_lang->cancel ?>", cssClass: "btn-danger", action: function(dialog){ 
                              tinyMCE.remove()
                              dialog.close(); 
                              } },
                            <?php if(!$vew_readonly){ ?>
                            {	label: "<?= $vew_lang->accept ?>", cssClass: "btn-success",	action: function(dialog){
                                tinyMCE.triggerSave();
                                var lv_sec = dialog.getModalBody().find("section:first").prop("id");
                                tinyMCE.remove()
                                dialog.close();
                            }
                            }<?php } ?>]
              <?php } ?>,
              error: function() {
                $('#<?= $lv_sec; ?> #docvewcnt').html('<div class="alert alert-danger">Error al cargar el documento.</div>');
              }
          	});
          });
        });
        
        
        function <?= $lv_sec; ?>_ensureHeadingIds(lp_edt) {
          const lv_doc = lp_edt.getDoc();
          if (!lv_doc) return;			

          const lv_hds = Array.from(lv_doc.querySelectorAll('h1,h2,h3,h4,h5,h6'));
          const lv_use = new Set();

          lv_hds.forEach((h, i) => {
            let lv_bse = h.id || `hdr-${i}`;
            let lv_id = lv_bse;
            let c = 1;

            // sólo de-duplico contra los ids ya asignados en esta pasada (no contra
            // getElementById, que devolvería el propio encabezado y haría crecer el id
            // en cada llamada). Así es idempotente: un id ya único se mantiene estable.
            while (lv_use.has(lv_id)) {
              lv_id = `${lv_bse}-${c++}`;
            }

            lv_use.add(lv_id);
            if (h.id !== lv_id) h.id = lv_id;
          });
        }
                      
        function <?= $lv_sec; ?>_buildTitleTree(headings) {
          const lv_rot = [];
          const lv_stk = [{ level: 0, children: lv_rot }];

          headings.forEach(h => {
            const lv_lvl = Number(h.tagName.substring(1)); // h1->1
            const lv_nod = {
              id: h.getAttribute('id'),
              text: (h.textContent || '').trim(),
              //icon: "",//"data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='14' height='14'><text x='2' y='12' font-size='12'>T</text></svg>",
              children: []
            };

            // mantener el stack según nivel
            while (lv_stk.length > 0 && lv_lvl <= lv_stk[lv_stk.length - 1].level) {
              lv_stk.pop();
            }

          	lv_stk[lv_stk.length - 1].children.push(lv_nod);
          	lv_stk.push({ level: lv_lvl, children: lv_nod.children });
        	});

          return lv_rot;
      	}
        
        // ==================== VARIABLES PERSISTENTES ====================
        let <?= $lv_sec; ?>_idxScrollTop = 0;
        let <?= $lv_sec; ?>_idxScrollLeft = 0;

        // ==================== PERSISTENCIA DEL SCROLL DEL EDITOR ====================
        // Mantiene la posición de scroll del editor al cambiar de solapa del sistema
        // (el iframe pierde su scroll al ocultarse/mostrarse) y cuando el grabado crea
        // una versión nueva y debe recargar la vista una vez. El grabado en el lugar
        // ya no recarga, así que ahí el scroll no se toca. Sólo se restaura la última
        // posición elegida por el usuario (scroll con el mouse o navegación por el
        // índice); nunca se fuerza al tope salvo que el usuario lo lleve allí.
        // La clave usa el código de documento (estable entre versiones).
        const <?= $lv_sec; ?>_sclkey = 'grldmsdoc_edscl_<?= $vew_data->grldmsdoccod; ?>';
        let <?= $lv_sec; ?>_edvisible = true;    // ¿el editor está visible (solapa activa)?
        let <?= $lv_sec; ?>_edrestoring = false; // ¿estoy aplicando una restauración?
        let <?= $lv_sec; ?>_edfrozen = false;    // bloquea el guardado durante la transición de solapa
        let <?= $lv_sec; ?>_edlastgood = 0;      // última posición válida elegida por el usuario (en memoria)

        // ¿el editor está realmente visible en el DOM? (offsetParent es null si algún
        // ancestro está display:none, p.ej. al estar en otra solapa del sistema)
        function <?= $lv_sec; ?>_edIsVisible() {
          const lv_cnt = document.querySelector('#<?= $lv_sec; ?> #docvewcnt');
          return !!(lv_cnt && lv_cnt.offsetParent !== null);
        }

        // guardo la posición actual. NO guardo si estoy restaurando, si la transición
        // de solapa está congelada (evita pisar el valor con el reset a 0 del iframe al
        // reaparecer), ni si el editor está oculto.
        function <?= $lv_sec; ?>_saveEdScroll(lp_edt) {
          try {
            if (<?= $lv_sec; ?>_edrestoring || <?= $lv_sec; ?>_edfrozen) return;
            if (!<?= $lv_sec; ?>_edvisible || !<?= $lv_sec; ?>_edIsVisible()) return;
            const lv_doc = lp_edt.getDoc();
            if (!lv_doc) return;
            const lv_sclelm = lv_doc.scrollingElement || lv_doc.documentElement;
            <?= $lv_sec; ?>_edlastgood = lv_sclelm.scrollTop;
            sessionStorage.setItem(<?= $lv_sec; ?>_sclkey, String(<?= $lv_sec; ?>_edlastgood));
          } catch (e) {}
        }

        // restauro la última posición. Uso primero el valor en memoria (fiable entre
        // solapas) y, si no hay, el de sessionStorage (sirve tras recargar la vista).
        // Reaplico en varios frames porque el iframe asienta su layout (y puede
        // resetearse a 0) después de reaparecer.
        function <?= $lv_sec; ?>_restoreEdScroll(lp_edt) {
          try {
            let lv_top = <?= $lv_sec; ?>_edlastgood;
            if (!(lv_top > 0)) {
              const lv_raw = sessionStorage.getItem(<?= $lv_sec; ?>_sclkey);
              lv_top = lv_raw === null ? 0 : (parseFloat(lv_raw) || 0);
            }
            if (lv_top <= 0) return;
            <?= $lv_sec; ?>_edlastgood = lv_top;
            const lv_doc = lp_edt.getDoc();
            if (!lv_doc) return;
            const lv_sclelm = lv_doc.scrollingElement || lv_doc.documentElement;
            <?= $lv_sec; ?>_edrestoring = true;
            const lv_apply = () => { lv_sclelm.scrollTop = lv_top; };
            requestAnimationFrame(() => {
              lv_apply();
              requestAnimationFrame(() => {
                lv_apply();
                setTimeout(() => { lv_apply(); <?= $lv_sec; ?>_edrestoring = false; }, 120);
              });
            });
          } catch (e) { <?= $lv_sec; ?>_edrestoring = false; }
        }

        // marco que el editor sale de vista: congelo el guardado para que el reset del
        // iframe no pise la última posición buena. La posición ya quedó capturada por
        // el guardado continuo en cada scroll (_edlastgood); este saveEdScroll es un
        // último intento por si el editor todavía estuviera visible (no-op si ya se ocultó).
        function <?= $lv_sec; ?>_edOnHide(lp_edt) {
          <?= $lv_sec; ?>_saveEdScroll(lp_edt);
          <?= $lv_sec; ?>_edvisible = false;
          <?= $lv_sec; ?>_edfrozen = true;
        }

        // marco que el editor vuelve a vista: restauro y mantengo congelado hasta que
        // el layout del iframe se asiente, para que el reset a 0 no gane la carrera.
        function <?= $lv_sec; ?>_edOnShow(lp_edt) {
          <?= $lv_sec; ?>_edvisible = true;
          <?= $lv_sec; ?>_restoreEdScroll(lp_edt);
          setTimeout(() => { <?= $lv_sec; ?>_edfrozen = false; }, 300);
        }

        // detecto los cambios de visibilidad del editor (cambios de solapa del sistema)
        // con un IntersectionObserver, que es el ÚNICO mecanismo: cubre cualquier forma
        // de ocultar/mostrar el editor, venga o no de Bootstrap. La condición de carrera
        // contra el reset a 0 del iframe no la resuelve este observer en sí, sino el
        // guardado continuo en _edlastgood + el congelado (_edfrozen) que aplican
        // _edOnHide / _edOnShow; por eso no hacen falta listeners síncronos extra.
        function <?= $lv_sec; ?>_watchEdVisibility(lp_edt) {
          const lv_cnt = document.querySelector('#<?= $lv_sec; ?> #docvewcnt');
          if (!lv_cnt) return;

          // Un IntersectionObserver avisa cuando un elemento entra o sale del área
          // visible (el "viewport"). Lo usamos para saber cuándo el editor pasó de
          // visible a oculto (o viceversa). Si un ancestro está display:none (otra
          // solapa activa), el editor no tiene caja y el observer lo reporta como no
          // visible; al reaparecer, lo reporta visible de nuevo.

          // Si ya había un observer de una inicialización anterior del editor (p. ej.
          // tras grabar y recrearse), lo desconecto para no acumular observers vivos
          // apuntando a nodos viejos.
          if (window['<?= $lv_sec; ?>_edio']) window['<?= $lv_sec; ?>_edio'].disconnect();

          const lv_io = new IntersectionObserver(function (entries) {
            entries.forEach(function (en) {
              const lv_vis = en.isIntersecting && en.intersectionRatio > 0;

              if (lv_vis && !<?= $lv_sec; ?>_edvisible) {
                // estaba oculto y ahora se ve => volvimos a la solapa: restauro scroll
                <?= $lv_sec; ?>_edOnShow(lp_edt);
              } else if (!lv_vis && <?= $lv_sec; ?>_edvisible) {
                // estaba visible y ahora no => nos fuimos de la solapa: guardo y congelo
                <?= $lv_sec; ?>_edOnHide(lp_edt);
              }
              // (si no cambió respecto de _edvisible, no hago nada)
            });
          }, { threshold: 0 });

          lv_io.observe(lv_cnt);

          window['<?= $lv_sec; ?>_edio'] = lv_io;
        }

        // ==================== GENERATE INDEX ====================
        let lv_ignscl = false;
        function <?= $lv_sec; ?>_generateIndex(lp_edt) {
            const lv_doc = lp_edt.getDoc();
            if (!lv_doc || !lv_doc.body) return;

            // garantizo ids únicos en los encabezados antes de construir el árbol, así
            // jstree no colisiona nodos (dos nodos con el mismo id se abren juntos).
            <?= $lv_sec; ?>_ensureHeadingIds(lp_edt);

            const lv_hds = Array.from(lv_doc.querySelectorAll('h1,h2,h3,h4,h5,h6'))
                .filter(h => (h.textContent || '').replace(/\u00A0/g, ' ').trim().length > 0);

            if (lv_hds.length === 0) return;

            const lv_idxcnt = document.getElementById('<?= $lv_sec; ?>_tab002');
            if (!lv_idxcnt) return;

            const lv_idx = $(lv_idxcnt);

            // Guardar scroll del índice ANTES de destruir
            <?= $lv_sec; ?>_idxScrollTop = lv_idxcnt.scrollTop;
            <?= $lv_sec; ?>_idxScrollLeft = lv_idxcnt.scrollLeft;

            // Destruir y reconstruir
            if (lv_idx.data('jstree')) lv_idx.jstree(true).destroy();
            lv_idxcnt.innerHTML = '';

            const lv_tredat = <?= $lv_sec; ?>_buildTitleTree(lv_hds);

            lv_idx.off('ready.jstree').on('ready.jstree', function () {
                $(this).jstree('open_all');
            }).jstree({
                core: { data: lv_tredat, themes: { stripes: false, icons: false } },
                plugins: ["wholerow"],
                multiple: false
            });

            // Click handler
            $(lv_idxcnt).off("activate_node.jstree").on("activate_node.jstree", function (e, data) {
                const tree = $(this).jstree(true);
                if (!tree.is_open(data.node)) {
                    tree.open_node(data.node, null, 0);
                }

                const lc_scllft = lv_idxcnt.scrollLeft;
                <?= $lv_sec; ?>_goToTitle(lp_edt, data.node.id);

                requestAnimationFrame(() => {
                    const lc_selnod = lv_idxcnt.querySelector('.jstree-clicked');
                    if (lc_selnod) lc_selnod.scrollIntoView({ block: 'nearest', inline: 'nearest' });
                    lv_idxcnt.scrollLeft = lc_scllft;
                });
            });

            // Restaurar scroll del índice con más frames
            requestAnimationFrame(() => {
                requestAnimationFrame(() => {
                    lv_idxcnt.scrollTop = <?= $lv_sec; ?>_idxScrollTop;
                    lv_idxcnt.scrollLeft = <?= $lv_sec; ?>_idxScrollLeft;

                    // Tercer intento por si el jstree modifica el layout
                    setTimeout(() => {
                        lv_idxcnt.scrollTop = <?= $lv_sec; ?>_idxScrollTop;
                        lv_idxcnt.scrollLeft = <?= $lv_sec; ?>_idxScrollLeft;
                    }, 50);
                });
            });

            // ==================== SCROLL LISTENER DEL EDITOR ====================
            let lv_lstid = null;
            function <?= $lv_sec; ?>_onEditorScroll() {
                if (lv_ignscl) return;
                const lv_sclelm = lv_doc.scrollingElement || lv_doc.documentElement;
                const lv_scltop = lv_sclelm.scrollTop;
                const lv_hds = Array.from(lv_doc.querySelectorAll('h1,h2,h3,h4,h5,h6'));
                let lv_cur = null;
                for (const h of lv_hds) {
                    if (h.offsetTop <= lv_scltop + 40) lv_cur = h;
                    else break;
                }
                if (!lv_cur || lv_cur.id === lv_lstid) return;

                lv_lstid = lv_cur.id;
                const lc_prvscllft = lv_idxcnt.scrollLeft;

                $(lv_idxcnt).jstree("deselect_all").jstree("select_node", lv_cur.id);
                $(lv_idxcnt).jstree("open_node", lv_cur.id);

                requestAnimationFrame(() => {
                    const lc_selnod = lv_idxcnt.querySelector('.jstree-clicked');
                    if (lc_selnod) lc_selnod.scrollIntoView({ block: 'nearest', inline: 'nearest' });
                    lv_idxcnt.scrollLeft = lc_prvscllft;
                });
            }

            const lv_win = lp_edt.getWin();
            if (lv_win) {
                if (window.lv_sclhnd) lv_win.removeEventListener("scroll", window.lv_sclhnd);
                window.lv_sclhnd = <?= $lv_sec; ?>_onEditorScroll;
                lv_win.addEventListener("scroll", window.lv_sclhnd, { passive: true });
            }
        }
        
        function <?= $lv_sec; ?>_goToTitle(lp_edt, lp_tgtid) {
          const lv_doc = lp_edt.getDoc();
          if (!lv_doc) return;

          let lv_tgt = lv_doc.getElementById(lp_tgtid);
          if (!lv_tgt && window.CSS?.escape) {
            try {
              lv_tgt = lv_doc.querySelector('#' + CSS.escape(lp_tgtid));
            } catch {}
          }
          if (!lv_tgt) return;

          // ignoro scrolls automáticos mientras dura el scroll suave, para que la
          // sincronización con el editor no vaya abriendo cada título del camino.
          lv_ignscl = true;
          const lv_navwin = lp_edt.getWin();
          let lv_navtmr = null;
          const lv_navrel = () => {
            clearTimeout(lv_navtmr);
            if (lv_navwin) lv_navwin.removeEventListener('scroll', lv_navonscl);
            lv_ignscl = false;
          };
          const lv_navonscl = () => {
            // cada vez que llega un scroll automático, pospongo la liberación;
            // cuando dejan de llegar (scroll asentado), recién reactivo la sync.
            clearTimeout(lv_navtmr);
            lv_navtmr = setTimeout(lv_navrel, 150);
          };
          if (lv_navwin) lv_navwin.addEventListener('scroll', lv_navonscl, { passive: true });
          // fallback: si el destino ya está visible no habrá scroll, libero igual.
          lv_navtmr = setTimeout(lv_navrel, 250);

          // FUERZO foco real ANTES del scroll (sin que el foco mueva la página)
          try {
            lp_edt.focus();
            lp_edt.getBody().focus({ preventScroll: true });
          } catch {}

          // siguiente frame = iframe ya es el contexto activo
          requestAnimationFrame(() => {
            // scroll SÓLO dentro del iframe del editor: muevo su scrollingElement
            // directamente. No uso scrollIntoView porque propaga el scroll a los
            // contenedores padre y termina scrolleando toda la página.
            const lv_sclelm = lv_doc.scrollingElement || lv_doc.documentElement;
            try {
              lv_sclelm.scrollTo({ top: lv_tgt.offsetTop, behavior: "smooth" });
            } catch {
              lv_sclelm.scrollTop = lv_tgt.offsetTop;
            }

            // siguiente frame: colocar cursor
            requestAnimationFrame(() => {
              try {
                const lc_rng = lv_doc.createRange();
                lc_rng.setStart(lv_tgt, 0);
                lc_rng.collapse(true);
                lp_edt.selection.setRng(lc_rng);
              } catch {
                try { lp_edt.selection.select(lv_tgt, true); } catch {}
              }
              // la reactivación de la sync la maneja lv_navrel cuando el scroll
              // suave termina (ver detector de scroll asentado más arriba).
            });
          });
        }

        // busca el ancestro que realmente scrollea (la "página"), para medir el desborde
        function <?= $lv_sec; ?>_getScrollParent(lp_el) {
          let lv_p = lp_el ? lp_el.parentElement : null;
          while (lv_p) {
            const lv_st = getComputedStyle(lv_p);
            if (/(auto|scroll)/.test(lv_st.overflowY) && lv_p.scrollHeight > lv_p.clientHeight + 1) {
              return lv_p;
            }
            lv_p = lv_p.parentElement;
          }
          return document.scrollingElement || document.documentElement;
        }

        // ajusta el alto del editor al espacio disponible exacto (init y resize),
        // para que entre justo en la vista sin generar scroll en la página.
        function <?= $lv_sec; ?>_fitEditor() {
          try {
            const lv_ed = <?= $lv_sec; ?>_editor;
            if (!lv_ed || !lv_ed.getContainer) return;
            const lv_cnt = document.querySelector('#<?= $lv_sec; ?> #docvewcnt');
            if (!lv_cnt) return;
            const lv_cont = lv_ed.getContainer();
            if (!lv_cont) return;
            // mido el alto de las barras (menú/herramientas/estado), constante
            const lv_ifr = lv_cont.querySelector('iframe');
            const lv_chrome = lv_ifr
              ? (lv_cont.getBoundingClientRect().height - lv_ifr.getBoundingClientRect().height)
              : 0;

            const lv_apply = (lp_h) => {
              lv_cont.style.height = lp_h + 'px';
              if (lv_ifr) lv_ifr.style.height = Math.max(120, lp_h - lv_chrome) + 'px';
            };

            // 1) altura tentativa: desde el tope del editor hasta el fondo del viewport
            const lv_top = lv_cnt.getBoundingClientRect().top;
            const lv_h = Math.max(300, Math.floor(window.innerHeight - lv_top - 6));
            lv_apply(lv_h);

            // 2) auto-corrección: si el contenedor scrolleable real sigue desbordando
            //    (por paddings/márgenes que no controlo), recorto el sobrante exacto.
            requestAnimationFrame(() => {
              const lv_scp = <?= $lv_sec; ?>_getScrollParent(lv_cnt);
              const lv_over = lv_scp.scrollHeight - lv_scp.clientHeight;
              if (lv_over > 1) lv_apply(Math.max(150, lv_h - lv_over - 1));
            });
          } catch (e) {}
        }

        // re-ajusto el editor al cambiar el tamaño de la ventana (con debounce)
        let lv_fittmr = null;
        function <?= $lv_sec; ?>_onWinResize() {
          clearTimeout(lv_fittmr);
          lv_fittmr = setTimeout(<?= $lv_sec; ?>_fitEditor, 120);
        }
        if (window.lv_dmsfithnd) window.removeEventListener('resize', window.lv_dmsfithnd);
        window.lv_dmsfithnd = <?= $lv_sec; ?>_onWinResize;
        window.addEventListener('resize', window.lv_dmsfithnd);

      // si no es un texto, ejecuto el form directamente.
      }else{
        $("#<?= $lv_sec; ?> #btnmdl").addClass('d-none');
        $('#<?= $lv_sec; ?> #docvewfrm').submit();
      }
  	});
    
    $("#<?= $lv_sec; ?> [name=docvew]").on('load', function () {
      let lv_ifr = this;
      let lv_ifrdoc = lv_ifr.contentDocument || lv_ifr.contentWindow.document;
      
      $(lv_ifrdoc).on("click", "#btndwn", function(e){e.preventDefault();
        var lv_vercod = $("#<?= $lv_sec; ?> #docvewfrm [name='grldmsdocvercod']").val();
				window.open( "?prg=grldmsdoc&act=downloadfile&prm_grldmsdocvercod="+lv_vercod );
    	});
    });
    
    function <?= $lv_sec; ?>_delete (lp_deleteall=false){
    	// Determino el tipo de borrado según el parámetro pasado.
      var lv_pstdat=[{name:"grldmsdocvercod",value:$("#<?= $lv_sec; ?> #docvewfrm [name='grldmsdocvercod']").val()},
                     {name:"grldmsdocdelall",value:lp_deleteall}];
      
      tmssCallProcess("?prg=grldmsdoc&act=04",lv_pstdat,function(data){ 
        if(data.errtyp="S"){
          if ( !lp_deleteall && data.data.grldmsdocvercod){
            lv_pstdat = [{name:"grldmsdocvercod",value:data.data.grldmsdocvercod}];
            <?= $lv_sec; ?>_ViewRefresh( lv_pstdat );
          }else{
            tmssTabSecCls( $("#<?= $lv_sec; ?>") );
          }
          toastr.success(data.errtxt,"Archivo eliminado");
    		}
      });
    }
    
    $("#<?= $lv_sec; ?> #btndel").click(function(e){e.preventDefault();
			var lv_hasver = <?= $vew_tbl['del']['acc'] == '' ? 'true' : 'false'; ?>;
			if (!lv_hasver){ return; }
      BootstrapDialog.show({
        title: "Seleccione el m&eacute;todo de Borrado",
        message:"<div class='list-group' id='lstdel'>"
                +"<a href='#' class='list-group-item' value=1><h4 class='list-group-item-heading'>Borrar Versi&oacute;n</h4><p class='list-group-item-text'>Se borra la versi&oacute;n actual del documento</p></a>"
                +"<a href='#' class='list-group-item' value=2><h4 class='list-group-item-heading'>Borrar Documento</h4><p class='list-group-item-text'>Se borra todo el documento junto con todas sus versiones</p></a>"
                +"<div>",
        type: BootstrapDialog.TYPE_PRIMARY,
        buttons:[{label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default'", action: function(dialog){dialog.close();} },
                 {label: "<?= $vew_lang->delete; ?>", cssClass: "btn-danger",	action: function(dialog){
                  lv_val=dialog.$modalBody.find("#lstdel a.active").attr("value");
                  if(lv_val==1)<?= $lv_sec; ?>_delete(false);
                  else if(lv_val==2) <?= $lv_sec; ?>_delete(true);                                                                                         
                  dialog.close();}}],
        onshown: function(dialog){
          dialog.$modalBody.find(".list-group-item").click(function(){
            //valida que si cambie el formato y no se selecione el mismo
            dialog.$modalBody.find(".list-group-item").removeClass("active");
            $(this).addClass("active");
          });
        }
    	});      	
    });
    
    $("#<?= $lv_sec; ?> #btncls").removeAttr("onclick").off("click");
    $("#<?= $lv_sec; ?> #btncls").on("click", function(e) {
      e.stopImmediatePropagation();
      e.preventDefault();
      
      var lv_istxt = <?= json_encode(str_starts_with($vew_data->fletyp, 'text')); ?>;
			
      if ( lv_istxt && <?= $lv_sec; ?>_editor && <?= $lv_sec; ?>_editor.isDirty() ) {
        // abrir diálogo de confirmación
        BootstrapDialog.show({
          title: "Confirmaci&oacute;n",
          message: "¿Desea salir sin grabar?",
          type: BootstrapDialog.TYPE_WARNING,
          buttons: [ {label: "No", cssClass: "btn-secondary", action: function(dialogRef) { dialogRef.close(); return; } },
                     {label: "<?= $vew_lang->yes; ?>", cssClass: "btn-danger",  action: function(dialogRef) { tmssTabSecCls( $("#<?= $lv_sec; ?>") ); dialogRef.close(); } } ]
        });
      }else if ( lv_istxt && <?= $lv_sec; ?>_editor && <?= $lv_sec; ?>_editor.getBody().textContent.trim() === "") {
         BootstrapDialog.show({
          title: "Confirmaci&oacute;n",
          message: "¿Desea guardar el documento en blanco?",
          type: BootstrapDialog.TYPE_WARNING,
          buttons: [ {label: "No", cssClass: "btn-secondary", action: function(dialogRef) { dialogRef.close(); return; } },
                     {label: "<?= $vew_lang->yes; ?>", cssClass: "btn-danger",  action: function(dialogRef) { tmssTabSecCls( $("#<?= $lv_sec; ?>") ); dialogRef.close(); } } ]
        });
      }else{
        // cerrar directamente si no hay cambios sin grabar y no está en blanco
        tmssTabSecCls( $("#<?= $lv_sec; ?>") );
      }
    });

  </script>
  <style>
    /* Estilos simples para el índice */
    #<?= $lv_sec; ?>_tab002 { padding: 10px; }
  </style>

  <script>
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {		
			if(lp_prm["action"]=="99"){
        var lv_pstdat = [{name:"grldmsdoccod",value:"<?= $vew_data->grldmsdoccod; ?>"}, {name:"oldsec",value:"<?= $lv_sec; ?>"}];
        tmssCallProcess("?prg=grldmsdoc&act=downloadfile", lv_pstdat, function(data){
          if(data.errtyp="S"){
            toastr.success("Documento actualizado");
          }
        });
      }
		}
  </script>	
	<?php include('grldocfrmscr.frm'); ?>
</section>
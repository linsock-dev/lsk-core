<?php
	// url del formulario
  $lv_lnk = '?prg=sysappiaa';
	
	// campos requeridos
	$vew_input->RequiredFields( array() );

	// modulo y programa
	$lv_mdlcod = 'SYS'; $lv_prgcod = 'IAA';

	// título
	$lv_title = $vew_lang->artificialintelligence;
 	// clave del documento
	$lv_dockey = '';
	
	// fuerzo la actividad a un 02 para que todos los elementos de la vista sean manipulables
	$vew_actcod = '02';

	$vew_tbl['canc'] = array('per'=>false);
	$vew_tbl['sveL'] = array('per'=>false);
		
	// librer?a de estilos bootstrap
	include_once('_library.frm');
	
	$vew_tbl['rfrsh'] = array( 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'?prg=sysappiaa&act=openaiassistant'.chr(39).'});' );

?>
<style>
  #<?= $lv_sec; ?> .card {
    height: calc(100vh - 250px);
  }

  /* =========================
     CARD IZQUIERDA
  ========================= */
  #<?= $lv_sec; ?> #qrycrd {
    display: flex;
    flex-direction: column;
  }

  #<?= $lv_sec; ?> #qrycrd .card-body {
    display: flex;
    flex-direction: column;
    height: 100%;
  }

  #<?= $lv_sec; ?> #qrycrd .content {
    flex: 1;
  }

  #<?= $lv_sec; ?> #qrycrd .button-container {
    margin-top: auto;
  }

  /* =========================
     CARD DERECHA
  ========================= */
  #<?= $lv_sec; ?> #rescrd {
    display: flex;
    flex-direction: column;
  }

  #<?= $lv_sec; ?> #rescrd .card-body {
    display: flex;
    flex-direction: column;
    flex: 1;
    min-height: 0;
  }

  #<?= $lv_sec; ?> .editor-container {
    flex: 1;
    display: flex;
    flex-direction: column;
    min-height: 0;
  }

  /* =========================
     TINYMCE v4 (mce-*)
  ========================= */

  #<?= $lv_sec; ?> .mce-container-body.mce-stack-layout {
    display: flex !important;
    flex-direction: column !important;
    height: 100% !important;
  }

  #<?= $lv_sec; ?> .mce-top-part {
      flex: 0 0 auto !important;
  }

  #<?= $lv_sec; ?> .mce-edit-area {
      flex: 1 1 auto !important;
      display: flex !important;
  }

  #<?= $lv_sec; ?> .mce-edit-area iframe {
      flex: 1 1 auto !important;
      height: 100% !important;
      width: 100% !important;
  }
</style>
<section id="<?= $lv_sec; ?>">
	<?php include('grldocfrmtlb.frm'); ?> 
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml( 'tmss_actcod', 'hidden', '' ); ?>
    <?= gethtml( 'sysappiaakey', 'hidden', $vew_data["mdllst"][0]["sysappiaakey"] ); ?>
    <?= gethtml( 'sysappiaaactcodext', 'hidden', $vew_data["sysappiaaactcodext"] ); ?>
    <?=	gethtml( 'docvwrsec', 'hidden', $vew_data["docvwrsec"] ); ?>
		<div class="container-fluid" role="tabpanel">
      <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->query; ?></a></li>
			</ul>
      <div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
						<div class="col-md-6">
              <div class="card" id="qrycrd">
                <div class="card-header" >
                  <div class="card-title"><?= $vew_lang->query; ?></div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <div class='content'>
                    <label class='control-label col-sm-2'><?= $vew_lang->insert.' '.$vew_lang->query; ?></label>
                    <textarea id='usrpmt' rows="5" class="form-control"></textarea>
                    <hr>
                    <div class="alert alert-warning" role="alert">Atenci&oacute;n: si el documento es muy extenso, la consulta puede demorar varios segundos en procesarse.</div>
                    <hr>
                  </div>
                  <div class="button-container"><button href="#" class="btn btn-success pull-right" id="btnexe"><i class="fas fa-send"></i> <?= $vew_lang->execute; ?></button></div>
                </div>
              </div> <!-- /card -->
						</div> <!-- /col -->
            <div class="col-md-6">
              <div class="card" id="rescrd">
                <div class="card-header row">
                  <div class="col-md-11 card-title"><?= $vew_lang->result; ?></div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <div class='row'>
                    <label class='control-label col-sm-2'><?= $vew_lang->result; ?></label>
                  </div>
                  <div class='row editor-container'>
                    <textarea id='iaares' rows="10" class="form-control"></textarea>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
		</div>
	</form>
  <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script> <!-- libreria para interpretar estilos de texto a partir de caracteres (**, ##, etc.) -->
  <script src="https://cdn.jsdelivr.net/npm/dompurify/dist/purify.min.js"></script> <!-- libreria para sanitizar la respuesta de la IA -->
	<script>
    
    $(document).ready(function () {
      if (tinymce.get('iaares')) { tinymce.get('iaares').remove(); }

      tinymce.init({
        selector: "#iaares",
        height: "100%",
        resize: false,
        menubar: false,
        statusbar: false,
        plugins: 'lists link image table code',
        toolbar: 'undo redo | bold italic underline | alignleft aligncenter alignright | bullist numlist | indent outdent | code',
        forced_root_block: "p",
        indentation: '30px',        // tamaño de la sangría
        indent_use_margin: false,   // padding-left
        content_style: `
            body { margin: 10px; }
            span { display: inline; }
            p { width: 100%; margin-top: 0; margin-bottom: 1em; }
        `,
        setup: function (editor) {
          editor.on('init', function () {
            // contenedor principal
            editor.getContainer().style.height = "100%";
            // iframe
            let lv_ifr = editor.getContainer().querySelector("iframe");
            if (lv_ifr) { 
               lv_ifr.style.height = "100%"; 
            }
          });

          // === soporte para tecla TAB ===
          editor.on('keydown', function (e) {
            if (e.keyCode === 9) {           // Tecla Tab
              if (e.shiftKey) {
                editor.execCommand('Outdent');   // Shift + Tab = reducir sangría
              }else {
                editor.execCommand('Indent');    // Tab = aumentar sangría
              }
              e.preventDefault();
              return false;
            }
          });
        }
      });
    });
    
    //  E J E C U T A R
 		$("#<?= $lv_sec; ?> #btnexe").on("click", function (e) {	e.preventDefault();		
      let lv_txtcnt = $("#<?= $vew_data["docvwrsec"]; ?> #docvewcnt").find("#<?= $vew_data["docvwrsec"]; ?>_docvewmce").html();

      let lv_usrmsg = $("#<?= $lv_sec; ?>").find("#usrpmt").val();
      let lv_prompt = [ lv_usrmsg ];

      // siempre adjunta documento si existe
      if (lv_txtcnt && lv_txtcnt.trim() !== "") { lv_prompt.push("DOCUMENTO:\n" + lv_txtcnt); }

      // =========================
      // HISTORIAL (solo 1 turno)
      // =========================
      let lv_iaachthst = [];
      let lv_prvhstraw = $("#<?= $vew_data["docvwrsec"]; ?>").find("#iaachthst").val();

      if (lv_prvhstraw) {
        try { lv_iaachthst = JSON.parse(lv_prvhstraw); } catch(e){ lv_iaachthst = []; }
      }

      if (!Array.isArray(lv_iaachthst)) { lv_iaachthst = []; }

      // =========================
      // PAYLOAD
      // =========================
      let lv_pstdat = [
        { name: "sysappiaacod", value: "<?= $vew_data["mdllst"][0]["sysappiaacod"]; ?>" },
        { name: "sysappiaaactcodext", value: "<?= $vew_data["sysappiaaactcodext"]; ?>" },
        { name: "key", value: "<?= $vew_data["mdllst"][0]["sysappiaakey"]; ?>" },
        { name: "prompt", value: JSON.stringify(lv_prompt) },
        { name: "iaachthst", value: JSON.stringify(lv_iaachthst) }
      ];

      const lv_spn = $("<div class='col-md-1 ms-auto text-end'><i class='fas fa-spinner fa-spin'></i></div>");
      $("#rescrd .card-header").append(lv_spn);
			$("#<?= $lv_sec; ?> #btnexe").prop("disabled", true);

      tmssCallProcessNoBackdrop("?prg=sysappiaa&act=execute", lv_pstdat, function (data) {
        try {
          lv_spn.remove();
          $("#<?= $lv_sec; ?> #btnexe").prop("disabled", false);

          let lv_prscnt = JSON.parse(data.data.content);
          let lv_content = lv_prscnt.content || "";

          // corregir escapes tipo \n
          if (typeof lv_content === "string") {
            try {
              lv_content = JSON.parse(`"${lv_content}"`);
            } catch (e) {}
          }

          // convertir a HTML para TinyMCE
          lv_content = lv_content.replace(/\n/g, "<br>").replace(/\t/g, "&nbsp;&nbsp;&nbsp;&nbsp;");

          // =========================
          // HISTORIAL
          // =========================
          let lv_newhst = [ { role: "user", content: lv_usrmsg }, { role: "assistant", content: lv_content } ];

          // =========================
          // OUTPUT → TinyMCE
          // =========================
          let lo_editor = tinymce.get("iaares");
          if (lo_editor) {
            if (lv_prscnt.intent === "rewrite") {
              let lv_html = "";
              if (lv_content) {
                lv_html += `<p><em>${lv_content}</em></p><hr>`;
              }
              lv_prscnt.changes.forEach(change => {
                if (change.action === "replace" && change.content) {
                  lv_html += change.content;
                  lv_newhst[1].content = lv_html;
                }
              });
              lo_editor.setContent(`<div class="ia-rewrite-result">${lv_html}</div>`);
            }else {   
              // 1. LIMPIAR RESPUESTA
              lv_content = lv_content.trim();
              // 1.1 limpiar bloques de código tipo ```html ... ```
              lv_content = lv_content.replace(/```[a-z]*\n([\s\S]*?)```/gi, '$1');
              // 1.2 limpiar posibles backticks sueltos
              lv_content = lv_content.replace(/`([^`]*)`/g, '$1');
              // 1.3 normalizar saltos
              lv_content = lv_content.replace(/\r\n/g, '\n');
              // 1.4 forzar salto antes de headers (###, ##, etc.)
              lv_content = lv_content.replace(/([^\n])\n?(#{1,6}\s)/g, '$1\n\n$2');
              // 1.5 forzar salto antes de listas
              lv_content = lv_content.replace(/([^\n])\n?(-\s)/g, '$1\n$2');
              // 1.6 limpiar bloques de código
              lv_content = lv_content.replace(/```[a-z]*\n([\s\S]*?)```/gi, '$1');

              // 2. convertir Markdown → HTML usando marked.js
              if (typeof marked !== 'undefined') {
                marked.setOptions({
                	breaks: true,   // clave para que respete saltos
                  gfm: true
                });

                lv_content = marked.parse(lv_content);
              } else {
                console.warn('marked.js no está cargado, se insertará texto plano');
              }

              // 3. sanitizar respuesta
              if (typeof DOMPurify !== 'undefined') {
                lv_content = DOMPurify.sanitize(lv_content);
              }

              if (lo_editor) {
                lo_editor.setContent(lv_content);
              } else {
                console.error('No se encontró el editor TinyMCE');
              }
            }
          }else {
            $("#iaares").val(lv_content);
          }

          // modifico el historial
          $("#<?= $vew_data["docvwrsec"]; ?>").find("#iaachthst").val(JSON.stringify(lv_newhst));
        }
        catch (e) {
          lv_spn.remove();
          console.error("Error procesando respuesta de IA:", e);
          toastr.warning("Hubo un error al procesar la respuesta de la IA. Por favor, intenta nuevamente.", "Procesamiento");
        }
      });
  	});
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
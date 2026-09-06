<?php
	// url del formulario
  $lv_lnk = '';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = '';

	// modulo y programa
	$lv_mdlcod = '';
	$lv_prgcod = '';

	// libreria de estilos bootstrap
	include_once('_library.frm');

	// id de sección
	$lv_sec = $vew_data->vew_sec;
?>
<section id="<?= $lv_sec; ?>">	
  <style> #<?= $lv_sec; ?> table tbody tr:first-child td{ border-top: 0px; } </style>
  <div class="card">
    <div class="card-header">
      <div class="card-title"><?= $vew_lang->messages; ?>
      	<a href="#" class="card-icon hidden" id="btnsnd" title="<?= $vew_lang->send; ?>"><i class="far fa-envelope"></i></a>
      </div>
    </div>
    <div class="card-body">
			<table class="table" id="msgtbl">
				<tbody>
	          <?php
							// recorremos todas las clases de mensaje
            foreach( $vew_data->msglst as $lo_msg ) {
              $lo_msglog = [];
							// buscamos si existen mensajes emitidos para la clase de mensaje
							$lv_msglog = '';             
              $lo_msg['msgnum'] = '';
              $lv_c = 0;
              foreach( $vew_data->docmsg as $lo_docmsg ) {
                if ( $lo_docmsg['sysdocmsgcod']==$lo_msg['sysdocmsgcod'] ) {
                  if (isset($lo_docmsg['msglog'])) {
                    $lv_msglog = '';
                    $lv_msglog = $lo_docmsg['msglog'];
                  } else {
                    $lv_msglog = '';
                  }
                  $lo_msg['msgnum'] = isset($lo_docmsg['msgnum']) ? $lo_docmsg['msgnum'] : '';
                  break;
								}
              }
							// si hay log de ejecución, se arma tabla de logs
              if( $lv_msglog!='' ){
                $lo_msglog = json_decode( $lv_msglog, true );
                $lv_tbllog = '<div><b>Copias: '.count($lo_msglog).'</b></div><table class="table table-bordered table-condensed"><thead><tr><td>'.$vew_lang->created.'</td><td>'.$vew_lang->createdby.'</td></tr></thead><tbody>';
                foreach($lo_msglog as $lv_rowlog){ $lv_tbllog .= '<tr><td>'.$lv_rowlog['logctedte'].'</td><td>'.$lv_rowlog['logcteusr'].'</td></tr>'; }
                $lv_tbllog .= '</tbody></table>';
              }

							// se arma la fila con la clase de mensaje
              $lv_msgtyp = $vew_doc->getTagValue($lo_msg['sysdocmsgatr'],'msgtyp');
              $lv_msgfrm = $vew_doc->getTagValue($lo_msg['sysdocmsgatr'],'msgfrm');
              $lv_msgfrm = str_ireplace('[srcobjtyp]',$vew_data->srcobjtyp,$lv_msgfrm);
              $lv_msgfrm = str_ireplace('[srcobjcod]',$vew_data->srcobjcod,$lv_msgfrm);
              $lv_msgfrm = str_ireplace('[srcobjcod002]',$vew_data->srcobjcod002,$lv_msgfrm);
              echo 	'<tr data-msgnum="'.$lo_msg['msgnum'].'" data-sysdocmsgcod="'.$lo_msg['sysdocmsgcod'].'" data-msgfrm="'.$lv_msgfrm.'" data-msgtyp="'.$lv_msgtyp.'" style="cursor:pointer;" data-sysdocmsgcodext="'.($lo_msg['sysdocmsgcodext']??'').'">'.
                    '<td class="text-center">'.($lv_msgtyp=='pdf'?'<input type="checkbox" data-filename="'.$lo_msg['sysdocmsgtxt'].'_'.$vew_data->srcobjcod.'.pdf" class="hidden">':'').'</td>'.
                    '<td name="message"><i class="'.($lv_msgtyp=='pdf'?'far fa-file-pdf':($lv_msgtyp=='scr'?'far fa-code':($lv_msgtyp=='ajx'?'far fa-sync':'far fa-triangle-exclamation text-danger'))).'" style="padding-right:5px;"></i> <a href="#">'.$lo_msg['sysdocmsgtxt'].'</a></td>'.
                    '<td><a href="#" class="'.(count($lo_msglog)>0?'':($lv_msglog!=''?'':'invisible')).' card-icon" data-sysdocmsgcod="'.$lo_msg['sysdocmsgcod'].'" name="lnklog"><i class="far fa-circle-info"></i></a><a href="#" class="'.($lv_msgtyp=='pdf'?'':'invisible').' card-icon btndwn"><i class="far fa-download"></i></a></td>'.
                		'</tr>';
							// si hay tabla de logs se agrega como una fila a la tabla
            	if($lv_msglog!=''){
								echo '<tr data-sysdocmsgcod_log="'.$lo_msg['sysdocmsgcod'].'" class="hidden"><td colspan=10>'.$lv_tbllog.'</td></tr>';
							}
            }
          ?>
				</tbody>
  		</table>
    </div>
  </div>

  <div class="card hidden">
    <div class="card-header"><div clasw="card-title">Compartir V&iacute;nculo</div></div>
  	<div class="card-body">
			<a href="mailto:?subjet=Perfil.com | Streaming+exclusivo%3A+Santiago+Siri+analiza+el+futuro+y+los+riesgos+de+la+inteligencia+artificial+con+Agustino+Fontevecchia&amp;body=Hola, vi este artículo que publicó Perfil.com y creo que te puede interesar. https://www.perfil.com/noticias/actualidad/streaming-exclusivo-santiago-siri-inteligencia-artificial-agustino-fontevecchia.phtml" aria-label="Enviar por Email" title="Copiar" rel="noreferrer" class="card-icon pull-left"><i class="far fa-copy"></i></a>
			<a href="whatsapp://send?text=Streaming+exclusivo%3A+Santiago+Siri+analiza+el+futuro+y+los+riesgos+de+la+inteligencia+artificial+con+Agustino+Fontevecchia https://www.perfil.com/noticias/actualidad/streaming-exclusivo-santiago-siri-inteligencia-artificial-agustino-fontevecchia.phtml" data-action="share/whatsapp/share" target="_blank" aria-label="Enviar enlace por Whatsapp" title="Compartir por Whatsapp" rel="noreferrer" class="card-icon pull-left"><i class="fab fa-whatsapp"></i></a>
			<a href="mailto:?subjet=Perfil.com | Streaming+exclusivo%3A+Santiago+Siri+analiza+el+futuro+y+los+riesgos+de+la+inteligencia+artificial+con+Agustino+Fontevecchia&amp;body=Hola, vi este artículo que publicó Perfil.com y creo que te puede interesar. https://www.perfil.com/noticias/actualidad/streaming-exclusivo-santiago-siri-inteligencia-artificial-agustino-fontevecchia.phtml" aria-label="Enviar por Email" title="Compartir por email" rel="noreferrer" class="card-icon pull-left"><i class="far fa-envelope"></i></a>
    </div>
  </div>    
      
  <div class="hidden" id="frmsnd">
    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-8">
          <form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
            <?= vew_boot($lv_col210, array('label'=>$vew_lang->destination, 'input1'=>gethtml("snddst","doccmt1x400","",$lv_default) )); ?>
            <?= vew_boot($lv_col210, array('label'=>$vew_lang->title, 'input1'=>gethtml("sndttl","doccmt1x400","",$lv_default) )); ?>
            <?= vew_boot($lv_col210, array('label'=>$vew_lang->message, 'input1'=>gethtml("sndmsg","doccmt4x50","",$lv_default) )); ?>
          </form>
        </div>
        <div class="col-sm-4" id="flelst"></div>
      </div>
    </div>
  </div>
      
	  <script>
			// INFO. muestra dialogo con info de impresiones
		$("#<?= $lv_sec; ?> table tbody tr td a[name=lnklog]").on("click",function(e){ e.preventDefault();
    // Obtén el ID de la tabla
    let lv_msgtbl = $("#<?= $lv_sec; ?> table#msgtbl");
    // Busca el <tr> correspondiente con data-sysdocmsgcod_log igual a sysdocMsgCod
    let lv_info = lv_msgtbl.find("tbody tr[data-sysdocmsgcod_log='" + $(this).data("sysdocmsgcod") + "'] td");                                                                           
    BootstrapDialog.show({
				title: "<?= $vew_lang->log; ?>",
				message:	lv_info.html(),
				closable: true,
				draggable: true, 
				type: BootstrapDialog.TYPE_INFO,
				size: BootstrapDialog.SIZE_SMALL
			});
		});
		
    // ENVIAR
    $("#<?= $lv_sec; ?> #btnsnd").on("click",function(e){e.preventDefault();
      var lv_frm = $("#<?= $lv_sec; ?> #frmsnd").clone().removeClass("hidden");
      var lv_flelst = "";
      $("#<?= $lv_sec; ?> table tbody input:checked").each(function(){lv_flelst+="<span style='display:block;margin-top:7px;'><i class='far fa-paperclip'></i> "+$(this).data("filename")+"</span>";});
      $(lv_frm).find("#flelst").html( lv_flelst );
			BootstrapDialog.show({
				title: "<?= $vew_lang->send; ?>",
				message: $(lv_frm),
				closable: true,
				draggable: true, 
				type: BootstrapDialog.TYPE_INFO,
				size: BootstrapDialog.SIZE_WIDE,
        buttons: [
          { label: "<?= $vew_lang->close; ?>", cssClass: "btn-default", action: function(dialogRef){ dialogRef.close(); }},
          { label: "<?= $vew_lang->send; ?>", cssClass: "btn-success", action: function(dialogRef){
          	var lv_pstdat2 = [];
          	tmssCallProccess("",lv_pstdat2,function(data){
              dialogRef.close();
            });
        	}}
        ],
        onshown: function(dialogRef){
          tinyMCE.init({
            plugins: ["fullpage"],
            selector: dialogRef.$modalBody().find("#<?= $lv_sec; ?> #sndmsg"), 
            height: 440, 
            menubar: false
          });
        }
			});
    });
    
    // DESCARGAR
    $("#<?= $lv_sec; ?> .btndwn").on("click", function(e){ e.preventDefault();
      $(this).parent().parent().find("td[name=message]").trigger("click", [true]);
  	});
    
    // CHECKBOX
    $("#<?= $lv_sec; ?> table tbody input[type=checkbox]").on("change",function(){
      if( $("#<?= $lv_sec; ?> table tbody input:checked").length>0 ){
        $("#<?= $lv_sec; ?> #btnsnd").removeClass("hidden");
      } else {
        $("#<?= $lv_sec; ?> #btnsnd").addClass("hidden");     
      }
    });
    
    
    // ENVIAR MENSAJE
    function <?= $lv_sec; ?>_sendMessage( lp_pstdat, lp_download ){      
      // datos adicionales
      var lv_msgdat = ''; 
      if(typeof <?= $lv_sec; ?>_getMessageData === "function"){
        lv_msgdat = <?= $lv_sec; ?>_getMessageData(lp_pstdat);
      }
      lp_pstdat.push({name:"msgdat",value:lv_msgdat});
			// imprimir/ejecutar. ejecuta el mensaje
      tmssCallProcessBlob("?prg=grldatmsg&act=07", lp_pstdat, function(data, lp_responseHeaders){
				if(data.type=="application/json" || data.type=="text/html"){
					data.text().then(function(result) {
						var lv_err = JSON.parse(result);
						toastr.warning("No se puede descargar el archivo.<br>"+lv_err.errcod+": "+lv_err.errtxt);
					});
          return false;
				}
        var lv_msgtyp = "";
        for(var i=0; i<lp_pstdat.length; i++){ if(lp_pstdat[i].name=="msgtyp"){ lv_msgtyp=lp_pstdat[i].value; } }
        if( lv_msgtyp=="pdf" ){
          // Crear una URL para el Blob y lo abre en una nueva pestaña
          var url = window.URL.createObjectURL(data);
          if( !lp_download ){
            window.open(url, "_blank");
            return true;
          } else {
            const link = document.createElement("a");
            link.href = url;
            if (lp_responseHeaders && lp_responseHeaders['content-disposition']) {
              const lv_contentDisposition = lp_responseHeaders['content-disposition'];
              const lv_filenameMatch = lv_contentDisposition.match(/filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/);
              if (lv_filenameMatch && lv_filenameMatch[1]) {
                let lv_encodedFilename = lv_filenameMatch[1].replace(/['"]/g, '');
                try{
                  link.download = decodeURIComponent(lv_encodedFilename);
                } catch (e) {
                  link.download = lv_encodedFilename;
                }
              }
            }
            // this is necessary as link.click() does not work on the latest firefox
            link.dispatchEvent( new MouseEvent("click", { bubbles: true, cancelable: true, view: window }) );
            // For Firefox it is necessary to delay revoking the ObjectURL
            setTimeout(() => { window.URL.revokeObjectURL(url); link.remove(); }, 100);
            return true;
          }
        } else if( lv_msgtyp=="scr" ){
          eval( data.msg );
          return true;
        } else if( lv_msgtyp=="ajx" ){
          $.ajax({ type: "POST", url: data.msg });
          return true;
        } else {
          toastr.warning("No se reconoce el tipo de mensaje ["+lv_msgtyp+"].");
          return false;
        }
      }, {desiredHeaders: ["content-disposition"] });
    }

    // MENSAJE. ejecuta mensaje
    $("#<?= $lv_sec; ?> table tbody tr td[name=message]").on("click",function(e, lp_download){ e.preventDefault();
			var lv_tr = $(this).parent(); // esto se hace para que el callback pueda acceder a la fila actual
			// prepara datos post
      var lv_pstdat =[{name:"sysdocclscod", value: "<?= $vew_data->sysdocclscod; ?>"},
                      {name:"srcobjtyp", value: "<?= $vew_data->srcobjtyp; ?>"},
                      {name:"srcobjcod", value: "<?= $vew_data->srcobjcod; ?>"},
                      {name:"srcobjcod002", value: "<?= $vew_data->srcobjcod002; ?>"},
                      {name:"msgnum", value: $(lv_tr).data("msgnum")},
                      {name:"sysdocmsgcod", value: $(lv_tr).data("sysdocmsgcod")},
                      {name:"msgfrm", value: $(lv_tr).data("msgfrm")},
                      {name:"msgtyp", value: $(lv_tr).data("msgtyp")},
                      {name:"msgqty", value: 1},
                      {name:"docsts", value: "A"}];
      <?= $lv_sec; ?>_sendMessage( lv_pstdat, lp_download );
      $('.close').click();
    	$("#<?= $lv_sec; ?> #btnmsg").click();
		});

	</script>
</section>

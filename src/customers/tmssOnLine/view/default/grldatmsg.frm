<?php
	// url del formulario
  $lv_lnk = '?prg=grldatmsg&act=20&prm_mdlcod='.$vew_data->mdlcod.'&prm_mdlcod='.$vew_data->mdlcod.'&prm_prgcod='.$vew_data->prgcod.'&prm_vewcod='.$vew_data->vewcod;
	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->message;
	
	// módulo y programa
	$lv_mdlcod = $vew_data->mdlcod;
	$lv_prgcod = $vew_data->prgcod;
	
	// librería de estilos bootstrap
	include_once('_library.frm');

	$lv_strdte = new DateTime(date('Y-m-d'));
	$lv_strdte->modify('-2 months');
	$lv_enddte = new DateTime(date('Y-m-d'));

	$lv_msglst = array(''=>'');
	foreach ( $vew_data->docmsglst as $lv_row ) {
		$lv_msglst[ $lv_row['sysdocmsgcod'] ] = $lv_row['sysdocmsgtxt'];
	}

	$vew_tbl['canc'] = array('per'=>false);
  $vew_tbl['sveL'] = array('per'=>false);
  $vew_tbl['rfrsh']=array('per'=>true,'pos'=>'','ttl'=>$vew_lang->refresh,'icn'=>'fas fa-sync-alt','css'=>'tmss-Opt','acc'=>$lv_sec.'_fnc({action: 20});');
?>
<section id="<?= $lv_sec; ?>" class="table-responsive">
	<?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>

		<div class="container-fluid">		
			<div class="row">
				<div class="col-md-3" id="divfndsec">
          
          <div class="card">
            <div class="card-header"><div class="card-title"><?= $vew_lang->find; ?><a href="#" class="card-icon" id="btnfnd"><i class="far fa-search"></i></a></div></div>
            <div class="card-body">
              <?php $lv_enddte->setTime(23, 59, 59); ?>
              <?= vew_boot($lv_col12, array('label'=>$vew_lang->message,'input'=>gethtml('msgfndobj', $lv_msglst, '', $lv_always_enabled)) ); ?>
              <?= vew_boot($lv_col12, array('label'=>$vew_lang->processed,'input'=>gethtml('msgfndexe', 'yesno', '', $lv_always_enabled)) ); ?>
              <?= vew_boot($lv_col12, array('label'=>$vew_lang->id,'input'=>gethtml('msgfndcod', 'doccmt1x50', '', $lv_always_enabled)) ); ?>
              <?= vew_boot($lv_col12, array('label'=>$vew_lang->attributes,'input'=>gethtml('msgfndatr', 'doccmt1x50', '', $lv_always_enabled)) ); ?>
              <?= vew_boot($lv_col12, array('label'=>$vew_lang->fromdate, 'input'=>gethtml('msgfndstrdte','docdte',$lv_strdte->format('d/m/Y'),$lv_always_enabled) )); ?>
              <?= vew_boot($lv_col12, array('label'=>$vew_lang->todate, 'input'=>gethtml('msgfndenddte','docdte',$lv_enddte->format('d/m/Y'),$lv_always_enabled) )); ?>
              <?= vew_boot($lv_col12, array('label'=>$vew_lang->maxrecords,'input'=>gethtml('msgfndmax', 'docnum0600', '100', $lv_always_enabled)) ); ?>
            </div>
          </div>
                    
				</div> <!-- /col-md-3 -->
				<div class="col-md-9" id="divfndres">
          <div class="card">
            <div class="card-header"><div class="card-title"><?= $vew_lang->messages; ?><a href="#" class="card-icon btn-success" id="btnexe"><i class="far fa-cogs"></i></a></div></div>
            <div class="card-body">
			       <table id="doctbl" class="table table-condensed table-bordered">
                <thead>
                  <tr>
                    <th><input type="checkbox" id="hdrchk"></th>
                    <th>Proc</th>
                    <th class="col-sm-1"><?= $vew_lang->date; ?></th>
                    <th><?= $vew_lang->id; ?></th>
                    <th class="col-sm-3"><?= $vew_lang->attributes; ?></th>
                    <th><?= $vew_lang->log; ?></th>
                  </tr>
                </thead>
                <tbody id="msgtblbdy"></tbody>
              </table>              
            </div>
          </div>
				</div> <!-- /col-md-9 -->
			</div> <!-- /row -->	
		</div> <!-- /container-fluid -->
	</form>
	<script>		
		function <?= $lv_sec; ?>_runMsg( lp_pstdat ) {
      if ( JSON.parse(lp_pstdat[0].value).length == 0 ) { return; }
      tmssCallProcess("?prg=grldatmsg&act=17", lp_pstdat, function(data) {
        $("#<?= $lv_sec; ?> #rowchk:checked").each(function () {
          // si ya tiene bg-danger, no hago nada
          if ( $(this).parent().parent().hasClass("bg-danger") ) return;

          for (let i = 0; i < data.data.length; i++) {
            if (data.data[i].srcobjcod == $(this).attr("data-srcobjcod")) {
              // decodifico el objeto de error
              var lv_errcod = JSON.parse(data.data[i].errobj).errcod;
              if (lv_errcod != 0) {
                $(this).parent().parent().removeClass("bg-info").addClass("bg-danger");
              }else {
                $(this).parent().parent().removeClass("bg-info").addClass("bg-success");
              }
              break; // ya encontré el match, corto el for
            }
          }
        });

        const lv_zipcnt = data.zipbin.zipcnt; // contenido base64
        const lv_zipnme = data.zipbin.zipnme || "carpeta.zip"; // nombre del archivo

        // decodificar base64 a binario
        const lv_binstr = atob(lv_zipcnt);
        const lv_binarr = new Uint8Array(lv_binstr.length);
        for (let lv_idx = 0; lv_idx < lv_binstr.length; lv_idx++) {
          lv_binarr[lv_idx] = lv_binstr.charCodeAt(lv_idx);
        }

        // crear blob y simular descarga
        const lv_blb = new Blob([lv_binarr], { type: 'application/zip' });
        const lv_url = URL.createObjectURL(lv_blb);
        const lv_lnk = document.createElement("a");
        lv_lnk.href = lv_url;
        lv_lnk.download = lv_zipnme;
        document.body.appendChild(lv_lnk);
        lv_lnk.click();
        document.body.removeChild(lv_lnk);
        URL.revokeObjectURL(lv_url);
      });
  	}
	
    
    // EJECUTAR. realiza la impresion/ejecución de todos los mensajes seleccionados
		$("#<?= $lv_sec; ?> #btnexe").on("click", function(e) {
      e.preventDefault();

      if ($("#<?= $lv_sec; ?> #rowchk:checked").length == 0) {
        toastr.warning("Debe seleccionar al menos un elemento de la lista a procesar.");
        return false;
      }

      var lv_pstdat = [];
      var lv_promises = [];

      BootstrapDialog.show({
      	title: "Confirmaci&oacute;n",
        message: "Desea procesar los mensajes seleccionados?",
        type: BootstrapDialog.TYPE_INFO,
        buttons: [ {label: "Cancelar", cssClass: "btn-default", action: function(dialogItself) { dialogItself.close(); } },
          {
            label: "OK",
            cssClass: "btn-primary",
            action: function(dialogItself) {
              $("#<?= $lv_sec; ?> #rowchk:checked").each(function() {
                var lv_chk = $(this);
                var lv_rowdat = [
                  {name: "sysdocclscod", value: lv_chk.data("sysdocclscod")},
                  {name: "srcobjtyp",    value: lv_chk.data("srcobjtyp")},
                  {name: "srcobjcod",    value: lv_chk.data("srcobjcod")},
                  {name: "msgtyp",       value: lv_chk.data("msgtyp")},
                  {name: "msgfrm",       value: lv_chk.data("msgfrm")},
                  {name: "sysdocmsgcod", value: $("#<?= $lv_sec; ?> #msgfndobj").val()},
                  {name: "docsts",       value: "A"}
                ];

                if (lv_chk.data("msgfrmcnd") !== "") {
                  // creo el ajax y lo guardo en el array de promesas
                  var lv_ajx = $.ajax({ type: "POST", url: lv_chk.data("msgfrmcnd"), data: lv_rowdat, dataType: "text" }).done(function(msg) {
                    if (msg.substring(0, 10) == "/*script*/") { eval(msg); } 
                    else {
                      try { msg = JSON.parse(msg); } catch(e) {}
                      
                      if (msg.errcod != null && msg.errcod != "0") {
                        lv_chk.closest("tr")
                          .removeClass("bg-info")
                          .addClass("bg-danger")
                          .find("td[name=errlog]").text(msg.errtxt);
                        toastr.warning("No se puede procesar el mensaje.<br>" + msg.errcod + ": " + msg.errtxt);
                        return
                      } else {
                        lv_pstdat.push(lv_rowdat);
                      }
                    }
                  }).fail(function() {
                    lv_chk.closest("tr")
                      .removeClass("bg-info")
                      .addClass("bg-danger")
                      .find("td[name=errlog]").text("Error de validación");
                    toastr.error("Error al validar el mensaje.");
                  });

                  lv_promises.push(lv_ajx);
                } else {
                  lv_pstdat.push(lv_rowdat);
                }
              });

              // espero todas las validaciones antes de ejecutar
              $.when.apply($, lv_promises).done(function() {
                // convierto el array del POST a un formato por filas
                lv_pstdat = [{
                  name:'grldatmsg', 
                  value:JSON.stringify(lv_pstdat.map(function(row) {
                    var lv_obj = {};
                    row.forEach(function(field) {
                      lv_obj[field.name] = field.value;
                    });
                    return lv_obj;
                  })
                )}];

                <?= $lv_sec; ?>_runMsg( lv_pstdat );
                dialogItself.close();
              });
            }
          }
        ]
      });
    });
		
    
    // BUSCAR. busca los mensajes para el criterio de seleccion indicado
    $("#<?= $lv_sec; ?> #btnfnd").on("click",function(e){ e.preventDefault();

			if ( $("#<?= $lv_sec; ?> #msgfndobj").prop("value")=="" ) {
				toastr.warning("Debe indicar el tipo de mensaje.");
				$("#<?= $lv_sec; ?> #msgfndobj").focus();
        return false;
      }
			
			if ( $("#<?= $lv_sec; ?> #msgfndexe").prop("value")=="" ) {
				toastr.warning("Debe indicar si se debe buscar en los mensajes realizados o los pendientes.");
				$("#<?= $lv_sec; ?> #msgfndexe").focus();
        return false;
      }
			
      $("#<?= $lv_sec; ?> #msgtblbdy").empty()
      var lv_pstdat =[{name: "msgfndexe", 	value: $("#<?= $lv_sec; ?> #msgfndexe").prop("value")},
											{name: "sysdocmsgcod",value: $("#<?= $lv_sec; ?> #msgfndobj").prop("value")},
                      {name: "srcobjcod", 	value: $("#<?= $lv_sec; ?> #msgfndcod").prop("value")},
                      {name: "msgatr", 			value: $("#<?= $lv_sec; ?> #msgfndatr").prop("value")},
                      {name: "msgfndstrdte", value: $("#<?= $lv_sec; ?> #msgfndstrdte").prop("value")},
											{name: "msgfndenddte", value: $("#<?= $lv_sec; ?> #msgfndenddte").prop("value")},
                      {name: "vewmaxrec", 	value: $("#<?= $lv_sec; ?> #msgfndmax").prop("value")} ];
      tmssCallProcess("?prg=grldatmsg&act=28", lv_pstdat, function(data){
        if ( data.length==0 ) { return false; }
        var lv_tbl = "";
        var lv_msgfrmcnd = "";
        var lv_msgfrm = "";
        var lv_msgtyp = "";
        for(var i=0; i<data.length; i++) {
          lv_msgfrmcnd = data[i]?.["sysdocmsgatr"].match(/<msgfrmcnd>(.*?)<\/msgfrmcnd>/)[1];
          lv_msgfrmcnd = lv_msgfrmcnd.replace('[srcobjtyp]',data[i]["srcobjtyp"]);
          lv_msgfrmcnd = lv_msgfrmcnd.replace('[srcobjcod]',data[i]["srcobjcod"]);
          lv_msgtyp = data[i]?.["sysdocmsgatr"].match(/<msgtyp>(.*?)<\/msgtyp>/)[1];
          lv_msgfrm = data[i]?.["sysdocmsgatr"].match(/<msgfrm>(.*?)<\/msgfrm>/)[1].replace('[srcobjcod]',data[i]["srcobjcod"]);
          lv_tbl += "<tr><td><input type='checkbox' id='rowchk' data-srcobjtyp='"+data[i]["srcobjtyp"]+"' data-srcobjcod='"+data[i]["srcobjcod"]+"' data-sysdocclscod='"+data[i]["sysdocclscod"]+"' data-msgfrmcnd='"+lv_msgfrmcnd+"' data-msgtyp='"+lv_msgtyp+"' data-msgfrm='"+lv_msgfrm+"'></td>"
                +"<td class='text-center'>"+(data[i]["msglog"]!=""?"<i class='fa fa-check'></i>":"")+"</td>"
                +"<td>"+data[i]["ctedte"].date.substring(0,10)+"</td>"
                +"<td>"+data[i]["srcobjcod"]+"</td>"
                +"<td><small>"+(data[i]["msgatr"] ?? '')+"</small></td>"
                +"<td name='errlog'>"+(data[i]["msglog"] ?? '')+"</td>"
                +"</tr>";
        }
        $("#<?= $lv_sec; ?> #msgtblbdy").html( lv_tbl );
        
        // agrego eventos check de cada fila
        $("#<?= $lv_sec; ?> #rowchk").on("change",function(e){
          if ( $(this).is(":checked") ) {
            $(this).parent().parent().addClass("bg-info");
          } else {
            $(this).parent().parent().removeClass("bg-info");
          }
        });
        
      });
		});	

    // CHECKBOX - HEADER. al checkear la cabecera se checkean todos los mensajes de la tabla
    $("#<?= $lv_sec; ?> #hdrchk").on("change",function(e){
			$("#<?= $lv_sec; ?> #rowchk").prop("checked",$(this).is(":checked")).trigger("change");
		});
    
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
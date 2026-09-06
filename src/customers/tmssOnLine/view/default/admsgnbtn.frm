<a href="#" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->sign; ?>" id="btnsgn"><i class="fas fa-pen-nib"></i></a>
<script>
  $("#<?= $lv_sec; ?> #btnsgn").on("click",function(e){e.preventDefault
    var lv_flelst = [];
    if(typeof(<?= $lv_sec; ?>_getSingingDocuments)==="function"){
      lv_flelst = <?= $lv_sec; ?>_getSingingDocuments();
    } else {
      toastr.warning("No se pueden determinar los documentos a firmar.");
      return false;
    }

    var lv_pstdat = [{name:"flelst",value:JSON.stringify(lv_flelst)}];
    tmssCallProcess("?prg=admsgn&act=sign",lv_pstdat,function(data){
      BootstrapDialog.show({
        title: "<?= $vew_lang->documentsigning; ?>",
        message: $(data),
        type: BootstrapDialog.TYPE_PRIMARY,
        size: BootstrapDialog.SIZE_WIDE,
        buttons:[{label: "<?= $vew_lang->close; ?>", id:"btncnc", cssClass: "btn-danger", action: function(dialog){dialog.close();} }
                ,{label: "<?= $vew_lang->sign; ?>", id:"btnsgn", cssClass: "btn-success", action: function(dialog){

									// Revisa que se seleccione un documento para firmar
                  if( dialog.getModalBody().find("table tbody input[type=checkbox]:checked").length==0){
										toastr.warning("Por favor seleccione un documento para firmar");
										return false;
									}

									// clave obtiene la clave y la hasea para pasarsela a la funcion de firmado
									var lv_dia = "<div class='container-fluid'><p> Indique su clave.</p><br>"
									lv_dia += "<div class='row'><label class='col-xs-2 control-label'>Clave</label><div class='col-xs-10'><input type='password' class='form-control' id='sgnpwd' name='sgnpwd' maxlength=''></div></div><br><br>";
									BootstrapDialog.show({
										title: "<?= $vew_lang->signature; ?>",
										message:$(lv_dia),
										closable: false,
										type: BootstrapDialog.TYPE_PRIMARY,
										size: BootstrapDialog.SIZE_MEDIUM,
										buttons:[	{label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialog2){dialog2.close();}},
															{label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success", action: function(dialog2){
																if( $.trim( dialog2.getModalBody().find("#sgnpwd").prop("value") )=="" ){
																	toastr.warning("La clave es requerida para firmar");
																	return false;
																}
																tmssLoadScript("sha256", function(){

																	// Hash de contraseña
																	var hash = sha256.create();
																	hash.update( dialog2.getModalBody().find("#sgnpwd").prop("value") );
																	var lv_pwd = hash.hex();

																	// Cierra dialogo
																	dialog2.close();

																	// Llama a la funcion de firmar
																	<?= $lv_sec; ?>_sign(lv_pwd,dialog);
																});
															}}],
										onshown: function(dialog2){ dialog2.getModalBody().find("#sgnpwd").focus(); }
									});
                }}],
        onshown: function(dialog){
          var lv_sgncod = dialog.$modalBody.find("#sgncod").prop("value");
          if(lv_sgncod==""){
            dialog.$modalFooter.find("#btncnc").prop("value","<?= $vew_lang->close; ?>");
            dialog.$modalFooter.find("#btnsgn").addClass("hidden");
          }
        },
				onhidden: function(dialog){
					if(typeof <?= $lv_sec; ?>_GridRefresh != "undefined" ) {
						<?= $lv_sec; ?>_GridRefresh();
					}
				}
      });
    })
  });



  // Firmado obtiene los datos de la vista,los envia al servidor para procesar la firma y da fedback al usuario
  function <?= $lv_sec; ?>_sign(lp_pwd,lp_dialog){
		lp_dialog.getModalFooter().find("#btnsgn").addClass("hidden");
    var lv_sgncod=lp_dialog.getModalBody().find("#sgncod").prop("value");
    lp_dialog.getModalBody().find("table tbody input[type=checkbox]:checked").each(function(){
			var lv_tr = $(this).parent().parent();
			//DATOS obtiene datos de la firma
			var lv_dat=[{name:"sgndocsrctyp",value:$(lv_tr).data("sgndocsrctyp")}
								 ,{name:"sgndocsrccod001",value:$(lv_tr).data("sgndocsrccod001")}
								 ,{name:"sgndocsrccod002",value:$(lv_tr).data("sgndocsrccod002")}
								 ,{name:"flesrcurl",value:$(lv_tr).data("fleurl")}
								 ,{name:"flesrcpst",value:$(lv_tr).data("flepst")}
								 ,{name:"flenme",value:$(lv_tr).data("flenme")}
								 ,{name:"sgncod",value:lv_sgncod}
								 ,{name:"sgnpwd",value:lp_pwd}];

			$(lv_tr).find("i").addClass("fa-spinner");
			tmssCallProcessNoBackdropErr("?prg=admsgn&act=sgndoc", lv_dat,
				function(data){ //FIRMADO se ejecuta si se pudo firmar el documento
					var lv_tr2 = lp_dialog.getModalBody().find("table tbody tr[data-sgndocsrctyp="+data.sgndocsrctyp+"][data-sgndocsrccod001="+data.sgndocsrccod001+"][data-sgndocsrccod002="+data.sgndocsrccod002+"]");
					$(lv_tr2).find("i").removeClass("fa-spinner").addClass("fas fa-check");
					$(lv_tr2).removeClass("bg-warning").addClass("bg-success");
					$(lv_tr2).find("input[type=checkbox]").remove();
				}, function(data){//ERROR se ejecuta si hay error en el proceso de firma
					var lv_tr2 = lp_dialog.getModalBody().find("table tbody tr[data-sgndocsrctyp="+data.sgndocsrctyp+"][data-sgndocsrccod001="+data.sgndocsrccod001+"][data-sgndocsrccod002="+data.sgndocsrccod002+"]");
					toastr.warning(data.errtxt);
					$(lv_tr2).find("i").removeClass("fa-spinner").addClass("fas fa-times-circle").prop("title",data.errtxt);
					$(lv_tr2).removeClass("bg-warning").addClass("bg-danger");
				}
			);
    });
  }
</script>

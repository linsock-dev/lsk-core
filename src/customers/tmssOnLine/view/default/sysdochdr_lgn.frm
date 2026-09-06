<?php
	/* librería de estilos bootstrap */
	//include_once('_library.frm');
  $lv_always_disabled = array( 'atrval'=>array('class'=>'form-control tmssAlwaysDisabled') );
  $lv_default = array( 'atrval'=>array('class'=>'form-control') );	
  $lv_dat = array();
  $lv_dat = $vew_sec->getUrlToken();
	$lv_sec = $vew_token;

  //REST
  if($lv_dat['errcod'] == -1){
    $lv_dat['usrcod'] = $_SESSION['tmss_usrcod'];
    $lv_dat['buscod'] = $_SESSION['tmss_buscod'];
    $lv_dat['bseurl'] = $_SESSION['tmss_bseurl'];
    $lv_dat['bsecnx'] = $_SESSION['tmss_bsecnx'];
    $lv_dat['usrtxt'] = $_SESSION['tmss_usrtxt'];
    $lv_dat['bustxt'] = $_SESSION['tmss_bustxt'];  
  }
  
	$lv_msg = '<form method="POST" class="form-horizontal" id="tmssLgnFrmSesTmeOut">'.
						'<input type="hidden" id="usrcod" name="usrcod" value="'.$lv_dat['usrcod'].'">'.
						'<input type="hidden" id="buscod" name="buscod" value="'.$lv_dat['buscod'].'">'.
						'<input type="hidden" id="bseurl" name="bseurl" value="'.$lv_dat['bseurl'].'">'.
						'<input type="hidden" id="bsecnx" name="bsecnx" value="'.$lv_dat['bsecnx'].'">'.
						'<input type="hidden" id="lngcod" name="lngcod" value="ES">'.
						'<div class="container-fluid">'.
						'<p id="msgtxt">'.$vew_lang->session_timeout.'</p>'.
    				'<div class="form-group tmss-form-group">'.
            	'<label class="col-md-2 control-label text-nowrap">'.$vew_lang->user.'</label>'.
    					'<div class=" col-md-10"><input type="text" id="usrtxt" name="usrtxt" class="form-control" value="'.$lv_dat['usrtxt'].'" readonly=""></div>'.
    				'</div>'.
    				'<div class="form-group tmss-form-group">'.
            	'<label class="col-md-2 control-label text-nowrap">'.$vew_lang->company.'</label>'.
    					'<div class=" col-md-10"><input type="text" id="usrtxt" name="usrtxt" class="form-control" value="'.$lv_dat['bustxt'].'" readonly=""></div>'.
    				'</div>'.
    				'<div class="form-group tmss-form-group">'.
            	'<label class="col-md-2 control-label text-nowrap">'.$vew_lang->password.'</label>'.
    					'<div class=" col-md-10"><input type="password" id="usrpwd" name="usrpwd" class="form-control" value="" required autofocus></div>'.
    				'</div>'.
    				'</div></form>';
?>
<section>
  <script>
		var gv_<?= $lv_sec; ?>_cs = false;
    
    tmssCallProcess("?prg=syssecusrpwd&act=getPwdDirectives", [{name: "usrcod", value: "<?= $lv_dat['usrcod']; ?>"}], function(data){
      var lv_cs_drt = data.filter(function(lp_drt){ return lp_drt["syssecdrttypcodext"].toLowerCase() == "pwdlgncasesensitive";});
      gv_<?= $lv_sec; ?>_cs = (lv_cs_drt[0]["syssecdrttypdef"] ? (lv_cs_drt[0]["syssecdrttypdef"] == "1" ? true : false ) : gv_<?= $lv_sec; ?>_cs);
    });
                
		tmssLoadScript("sha256",function(){});

    function tmssLogin( lp_msg ) {
			var lv_found = false;
			$.each(BootstrapDialog.dialogs, function(id, dialog){
				if(dialog.$modalBody.find("#tmssLgnFrmSesTmeOut").length!=0){ lv_found=true; }
      });
			if( lv_found==false){
        var lv_svnme = location.host.split(".").map((e) => e.charAt(0).toUpperCase() + e.slice(1)).join(".");
				BootstrapDialog.show({
					title: "<?= $vew_lang->access; ?>",
					type: BootstrapDialog.TYPE_PRIMARY,
					closable: false,
					message: "<?= str_ireplace(chr(34),chr(39),$lv_msg); ?>",
					onshown: function(dialog) { dialog.getModalBody().find('#usrpwd').focus(); },
					buttons: [{label: "<?= $vew_lang->exit; ?>",action: function(dialog){
                      localStorage.removeItem(lv_svnme+".Usrtkn");
                      localStorage.removeItem(lv_svnme+".Usrcod");
            					document.location.href="?prg=syssecusr&act=99";
          					}},
										{label: "<?= $vew_lang->continue; ?>",cssClass: "btn-success",hotkey: 13,
											action: function(dialog) {
												if($(dialog.$modalBody).find("#usrpwd").prop("value")==""){
													dialog.getModalBody().find("#msgtxt").html( "<span class='alert alert-warning'>Debe ingrear una contrase&ntilde;a.</span>");
												} else {
													var hash = sha256.create();
                          var lv_pwd = $(dialog.$modalBody).find("#usrpwd").prop("value");
                          lv_pwd = gv_<?= $lv_sec; ?>_cs ? lv_pwd : lv_pwd.toUpperCase();
													hash.update( lv_pwd );
													$(dialog.$modalBody).find("#usrpwd").prop("value", hash.hex());
													var lv_dat = $(dialog.$modalBody).find("form").serializeArray();
													$(dialog.$modalBody).find("#usrpwd").prop("value","");
													var lv_ajx = [{name: "ajax", value: "1"},{name: "ajax_login", value: "1"}];
													lv_dat.push( lv_ajx[0] );
													lv_dat.push( lv_ajx[1] );
                                      
                          showBackdrop();
                          var lv_headers = {
                            [lv_svnme+".Usrcod"]: $(dialog.$modalBody).find("#usrcod").val(),
                            "Tmss-Usrpwd": hash.hex(),
                            "Tmss-Usrpwdupr": hash.hex(),
                            "Tmss-From-Menu": "X"
                          };
                          $.ajax({url:"?prg=syssecusr&act=98&token=<?= $vew_sec->getToken(); ?>",method:"POST",data:lv_dat, headers: lv_headers}).done(function(data){
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
                                  if(data.errtyp=="S"){
                                    if(data.localStorage != undefined){
                                      for (const [key, value] of Object.entries(data.localStorage)) {
                                        localStorage.setItem(key, value);
                                      }
                                    }
                                    dialog.close();
                                  } else {
                                    dialog.getModalBody().find("#msgtxt").html( "<span class='alert alert-warning'>"+data.errtxt+" (#"+data.errcod+")</span>");
                                  }
                                }
                              }
                            } else if ( (data.errtyp==undefined?"":data.errtyp)=="E" ) {
                              toastr.warning(data.errcod+": "+data.errtxt);
                            } else {
                              if(data.errtyp=="S"){
                                if(data.localStorage != undefined){
                                  for (const [key, value] of Object.entries(data.localStorage)) {
                                    localStorage.setItem(key, value);
                                  }
                                }
                                dialog.close();
                              } else {
                                dialog.getModalBody().find("#msgtxt").html( "<span class='alert alert-warning'>"+data.errtxt+" (#"+data.errcod+")</span>");
                              }
                            }
                          }).fail(function (request, textStatus, error) {
                            hideBackdrop();
                            toastr.warning("Error de conexion."+textStatus);
                          });
												}
											}
										}]
				});
			}
    }		
  </script>
</section>
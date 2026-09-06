<?php
  $frm = "hltargtrzagtasg_" + $vew_token; 
  $lv_prm = array( "atrval"=>array("class"=>"form-control"), "atr"=>array("readonly") );
  $lv_prm2 = array( "atrval"=>array("class"=>"form-control tmssDisabled"), "atr"=>array("readonly") );
?>
<section id="<?= $frm; ?>">

  <nav class="navbar navbar-default tmssNavBar">
    <div class="container-fluid">
      <ul class="nav navbar-nav">
        <a href="#" onclick="syssecusr_fnc({action: '02'});" id="btnchg" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->modify;          ?>"><img src="/library/images/icon_change.gif"><span class="hidden-xs"> <?= $vew_lang->modify; ?></span></a>
        <a href="#" onclick="syssecusr_fnc({action: '10'});" id="btnpwd" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->change_password; ?>"><img src="/library/images/icon_change_password.gif"><span class="hidden-xs"> <?= $vew_lang->change_password; ?></span></a>
        <a href="#" onclick="syssecusr_fnc({action: '00'});" id="btnsve" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead" title="<?= $vew_lang->save;            ?>"><img src="/library/images/icon_save.gif"><span class="hidden-xs">  <?= $vew_lang->save; ?></span></a>
        <a href="#" onclick="syssecusr_fnc({action: '98'});" id="btncnc" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead" title="<?= $vew_lang->cancel;          ?>"><img src="/library/images/icon_cancel.gif"><span class="hidden-xs">  <?= $vew_lang->cancel; ?></span></a>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <li><a href="#"><span class="glyphicon glyphicon-refresh"></span></a></li>
        <li class="navbar-text tmssNavbarSep">|</li>
        <li><a href="#" onclick="tmssTabSecCls(this);" title="<?= $vew_lang->close; ?>"><span class="glyphicon glyphicon-remove"></span></a></li>
      </ul>
    </div>
  </nav>

  <form method="POST" class="form-horizontal">

    <div role="tabpanel">
      <div class="rows">
        <div class="col-md-2">
          <ul class="nav nav-pills nav-stacked">
            <li role="presentation" class="active"><a href="#<?= $lv_frm."_1"; ?>" role="tab" data-toggle="tab"><?= $vew_lang->agent_assignment; ?></a></li>
            <li role="presentation"><a href="#<?= $lv_frm."_9"; ?>" role="tab" data-toggle="tab"><?= $vew_lang->additional_data; ?></a></li>
          </ul>
        </div>
        <div class="col-md-10">
          <div class="tab-content">
                              
            <div role="tabpanel" class="tab-pane active" id="<?= $lv_frm."_1"; ?>">              
              <div class="rows">
                <div class="col-md-6">
                  <legend><?= $vew_lang->personal_data; ?></legend>
                
                  <div class="form-group">
                    <label for="usrcod" class="col-sm-2 control-label"><?= $vew_lang->object; ?></label>
                    <div class="col-sm-10"><?= gethtml("AgtSrcTyp", "AgtSrcTyp", $vew_data["AgtSrcTyp"], $lv_prm2); ?><?= gethtml("AgtSrcCod", "AgtSrcCod", $vew_data["AgtSrcCod"], $lv_prm2); ?></div>
                  </div>
                  <div class="form-group">
                    <label for="adrlstnme" class="col-sm-2 control-label"><?= $vew_lang->agent_type; ?></label>
                    <div class="col-sm-10"><?= gethtml("AgtTypCod", "AgtTypCod_lst", $vew_data["AgtTypCod"], $lv_prm); ?></div>
                  </div>
                  <div class="form-group">
                    <label for="adrfrtnme" class="col-sm-2 control-label"><?= $vew_lang->gln; ?></label>
                    <div class="col-sm-10"><?= gethtml( "adrfrtnme", "adrfrtnme", $vew_data["usrfrtnme"], $lv_prm); ?></div>
                  </div>
                
                </div> <!-- col-md-6 -->
                <div class="col-md-6">
                
                  <div class="form-group">
                    <label for="agtasgcod" class="col-sm-2 control-label"><?= $vew_lang->id; ?></label>
                    <div class="col-sm-10"><?= gethtml( "agtasgcod", "doccod", $vew_data["usrprfwndrfh"], $lv_prm2 ); ?></div>
                  </div>
                  <div class="form-group">
                    <label for="docsts" class="col-sm-2 control-label"><?= $vew_lang->style; ?></label>
                    <div class="col-sm-10"><?= gethtml( "docsts", "docsts", $vew_data["docsts"], $lv_prm ); ?></div>
                  </div>
                  
                </div> <!-- col-md-6 -->
              </div> <!-- rows -->


              <div class="rows">
                <div class="col-md-6">
                  <legend><?= $vew_lang->address; ?></legend>
                  <div class="form-group">
                    <label for="test" class="col-sm-2 control-label"><?= $vew_lang->street; ?></label>
                    <div class="col-sm-10"><div class="input-group date">
                                              <input type="text" class="form-control" id="test" name="test" value="">
                                              <span class="input-group-addon"><i class="far fa-calendaralt"></i></span>
                                            </div>
                                            <script>setDatepicker($("#test"));</script>
                    </div>                          
                  </div>

                  <div class="form-group">
                    <label for="adrstr" class="col-sm-2 control-label"><?= $vew_lang->street; ?></label>
                    <div class="col-sm-10"><input type="text" class="form-control" id="adrstr" name="adrstr" value="<?= $vew_data['usrdir']; ?>" disabled></div>
                  </div>                  
                  <div class="form-group">
                    <label for="adrcty" class="col-sm-2 control-label"><?= $vew_lang->city; ?></label>
                    <div class="col-sm-10"><input type="text" class="form-control" id="adrcty" name="adrcty" value="<?= $vew_data['adrcty']; ?>" disabled></div>
                  </div>                  
                  <div class="form-group">
                    <label for="adrpstcod" class="col-sm-2 control-label"><?= $vew_lang->postal_code; ?></label>
                    <div class="col-sm-10"><input type="text" class="form-control" id="adrpstcod" name="adrpstcod" value="<?= $vew_data['adrpstcod']; ?>" disabled></div>
                  </div>
                  <div class="form-group">
                    <label for="adrpstcod" class="col-sm-2 control-label"><?= $vew_lang->postal_code; ?></label>
                    <div class="col-sm-10"><input type="text" class="form-control" id="adrpstcod" name="adrpstcod" value="<?= $vew_data['adrpstcod']; ?>" disabled></div>
                  </div>
                  <div class="form-group">
                    <label for="lndregcod" class="col-sm-2 control-label"><?= $vew_lang->region; ?></label>
                    <div class="col-sm-10"><input type="text" class="form-control" id="lndregcod" name="lndregcod" value="<?= $vew_data['lndregcod']; ?>" disabled>
                                           <input type="text" class="form-control" id="lndregtxt" name="lndregtxt" value="<?= $vew_data['lndregtxt']; ?>" disabled></div>
                  </div>
                  <div class="form-group">
                    <label for="lndcod" class="col-sm-2 control-label"><?= $vew_lang->country; ?></label>
                    <div class="col-sm-10"><input type="text" class="form-control" id="lndcod" name="lndcod" value="<?= $vew_data['lndcod']; ?>" disabled>
                                           <input type="text" class="form-control" id="lndtxt" name="lndtxt" value="<?= $vew_data['lndtxt']; ?>" disabled></div>
                  </div>
                </div>                
                <div class="col-md-6">
                  <legend><?= $vew_lang->contact; ?></legend>
                  <div class="form-group">
                    <label for="adrphn001" class="col-sm-2 control-label"><?= $vew_lang->phone; ?></label>
                    <div class="col-sm-10"><?= gethtml("adrphn001", "adrphn", $vew_data["adrphn001"], $lv_prm); ?></div>

                  </div>
                  <div class="form-group">
                    <label for="adrphn002" class="col-sm-2 control-label"><?= $vew_lang->phone; ?></label>
                    <div class="col-sm-10"><?= gethtml("adrphn002", "adrphn", $vew_data["adrphn002"], $lv_prm); ?></div>
                  </div>
                  <div class="form-group">
                    <label for="adrphnmbl" class="col-sm-2 control-label"><?= $vew_lang->mobile; ?></label>
                    <div class="col-sm-10"><?= gethtml("adrphnmbl", "adrphn", $vew_data["adrphnmbl"], $lv_prm); ?></div>
                  </div>
                  <div class="form-group">
                    <label for="adrfax" class="col-sm-2 control-label"><?= $vew_lang->fax; ?></label>
                    <div class="col-sm-10"><input type="text" class="form-control" id="adrfax" name="adrfax" value="<?= $vew_data['adrfax']; ?>" disabled></div>
                  </div>
                  <div class="form-group">
                    <label for="adreml" class="col-sm-2 control-label"><?= $vew_lang->email; ?></label>
                    <div class="col-sm-10"><input type="mail" class="form-control" id="adreml" name="adreml" value="<?= $vew_data['adreml']; ?>" disabled></div>
                  </div>
                  <div class="form-group">
                    <label for="adrphn001" class="col-sm-2 control-label"><?= $vew_lang->phone; ?></label>
                    <div class="col-sm-10"><input type="text" class="form-control" id="adrphn001" name="adrphn001" value="<?= $vew_data['usrphn']; ?>" disabled></div>
                  </div>
                </div> <!-- col-md-6 -->
              </div> <!-- rows -->
              
            </div> <!-- tabpanel - myaccount -->
                
            <div role="tabpanel" class="tab-pane" id="<?= $lv_frm."_9"; ?>">
              <div class="form-group">
                <label class="col-sm-2 control-label"><?= $vew_lang->created_by; ?></label>
                <div class="col-sm-10"><?= gethtml("", "usrcod", $vew_data["cteusr"], $lv_prm2); ?></div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label"><?= $vew_lang->created_date; ?></label>
                <div class="col-sm-10"><?= gethtml("", "docdte", $vew_data["ctedte"], $lv_prm2); ?></div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label"><?= $vew_lang->updated_by; ?></label>
                <div class="col-sm-10"><?= gethtml("", "usrcod", $vew_data["updusr"], $lv_prm2); ?></div>
              </div>
              <div class="form-group">
                <label class="col-sm-2 control-label"><?= $vew_lang->updated_date; ?></label>
                <div class="col-sm-10"><?= gethtml("", "docdte", $vew_data["upddte"], $lv_prm2); ?></div>
              </div>
            </div>  <!-- tabpanel - additionalinfo -->
            
          </div> <!-- tabcontent -->
        </div> <!-- col-md-10 -->
      </div> <!-- rows -->
    </div> <!-- tabpanel -->
    
  </form>
  <script>
  
    // lp_frm, lp_lnk, lp_callback
    tmssLinkForm( $("#syssecusr_frm"), "?prg=syssecusr&act=00" );
    
    function tmssLinkForm( lp_obj, lp_lnk ) {
      $(lp_obj).on( "submit", function(event) {
        event.preventDefault();
        var jqxhr = $.ajax({
            type: "POST",
            url: lp_lnk,
            data: $(this).serializeArray()
          });
        
        //jqXHR.done(function( data, textStatus, jqXHR ) {});
        jqxhr.done( function( data ) {
                alert("termino1: " + data);
          });
          
        //jqXHR.fail(function( jqXHR, textStatus, errorThrown ) {});
        jqxhr.fail( function( jqXHR, textStatus, errorThrown ) {
                alert("Request failed: " + textStatus);
          });
      });
    }
  
    function syssecusr_fnc( lp_prm ) {
      var lv_action = lp_prm["action"];
      if (lv_action=="00") {
        $("#syssecusr_frm").submit();
      } else if (lv_action=="02") {
        // validar
        // grabar
        // verificar resultado
        // si error ==> mantener modo modificación
        // si ok    ==> obtener datos completos
        //              rellenar formulario
        //              modo visualización
        tmssFormEdit("syssecusr_frm",true);
      // cambiar contraseña
      } else if (lv_action=="10") {
        tmssLink( "?prg=syssecusr&act=10", { target: $("#syssecusr_frm > #syssecusr_pwdchg"), oncomplete: function(e) { alert("termino"); } });
      // modificar
      } else if (lv_action=="02") {
        tmssFormEdit("syssecusr_frm",true); 
      // cancelar
      } else if (lv_action=="98") {
        // restaurar valores anteriores o actualizar los datos desde la base de datos
        tmssFormEdit("syssecusr_frm",false);
      }
    }
    tmssFormEdit("syssecusr_frm",false);
  </script>

</section>
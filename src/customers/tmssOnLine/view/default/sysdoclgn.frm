<form method="POST" action="<?= $vew_data['cnx']['bseurl'] ?>?prg=syssecusrpwd&act=11" id="pwdfrm" class="hidden-lg hidden-md hidden-xs">
  <input type="hidden" id="sysenv" name="sysenv" value="<?= $vew_data['cnx']['environmet'] ?>">
  <input type="hidden" id="bseurl" name="bseurl" value="<?= $vew_data['cnx']['bseurl'] ?>">
  <input type="hidden" id="bsecnx" name="bsecnx" value="<?= $vew_data['cnx']['bsecnx'] ?>">
</form>
<form id="lgnfrm">
  <input type="hidden" id="bsecnx" name="bsecnx" value="<?= $vew_data['cnx']['bsecnx']?>" wfd-id="id4"> 
  <input type="hidden" id="buscod" name="buscod" value="<?= $vew_data['cnx']['buscod'] ?>">
  <input type="hidden" id="logon" name="logon" value="1" wfd-id="id5">
  <div class="row" style="margin: 0px; height: 100vH;">
    <div class="col-sm-5 offset-sm-7 bg-white" style="padding: 30px;">
      <div class="app-title text-center">
        <img class="img-responsive customer-logo" src="<?= $vew_data['cnx']['picture']?>" title="<?= $vew_data['cnx']['title'] ?>" style="padding-left: 20px; padding-right:20px; padding-bottom:20px; max-height: 150px; max-width: 250px;">
        <p><span style="font-size: 18px; color: #2c73c4;"><?= $vew_data['cnx']['subtitle'] ?></span></p>
      </div>  
      <div class="form-group">
        <label>Usuario o Email</label>
        <input type="text" id="usrcod" name="usrcod" value="" class="form-control" required="" maxlength="250" wfd-id="id6">
      </div>
      <div class="form-group">
        <label>Contraseña</label>
        <input type="password" id="usrpwd" name="usrpwd" value="" class="form-control" required="" maxlength="50" wfd-id="id7">
      </div>
      <button type="submit" class="btn btn-success btn-lg btn-block">Ingresar</button><br>
      <div class="text-center">
        <a href="#" onclick="$('#pwdfrm').submit();" id="pwdreclnk" class="password-recovery-link">Olvidaste tu contraseña?</a>
      </div>
      <br>
      <div class="row">
        <div class="col-3 offset-4 text-center">
          <a href="https://webmail.gorse.ar" target="_blank" title="WebMail"><span class="far fa-envelope fa-2x"></span></a>
        </div>
      </div>
      <br>
      <div class="text-center" style="font-size: 80%;">
        <a href="https://temasis.ar" target="_blank"><img src="/library/images/logos/temasis2.jpg" title="Temasis Argentina SRL" style="max-width:25px; max-height:25px;"></a> | 
        <a href="https://gorse.ar/documents/politicaprivacidad.html" target="_blank">Politica de Privacidad</a> | 
        <a href="https://gorse.ar/documents/terminosservicio.html" target="_blank">Térmios del Servicio</a>
      </div>
    </div>
  </div>
</form>
<script>
$(function(){
  // set main image
  var lv_imgnum = Math.floor(Math.random() * 27);
  lv_imgnum++;
  var lv_img = "../library/images/login/"+lv_imgnum+".jpg";
  $("#colimg").css("background-image","url("+lv_img+")");

  // usr focus
  $("#usrcod").focus();

  // verificar si hay token
  const lv_svnme = location.host.split(".").map((e) => e.charAt(0).toUpperCase() + e.slice(1)).join(".");
  const lv_token = localStorage.getItem(lv_svnme+".Usrtkn");

  if(lv_token != null){
    const lv_headers = {};
    lv_headers[lv_svnme+".Usrtkn"] = lv_token;
    login(lv_headers);
    return;
  }

  // hash pwd
  $("#lgnfrm").on("submit", function(e){
    e.preventDefault();

    const lv_pwd = $("#usrpwd").val();
    if(lv_pwd.trim() == ""){
      $("#usrpwd").focus();
      return;
    }

    const lv_headers = {};

    // hash pwd
    var hash = sha256.create();
    hash.update( lv_pwd );
    lv_headers["Tmss-Usrpwd"] = hash.hex();

    hash = sha256.create();
    hash.update( lv_pwd.toUpperCase() );
    lv_headers["Tmss-Usrpwdupr"] = hash.hex();

    $("#lgnfrm #usrpwd").val("");
    login(lv_headers);
  });
});

function login(lp_headers){ 
  var lv_svnme = location.host.split(".").map((e) => e.charAt(0).toUpperCase() + e.slice(1)).join(".");
  lp_headers[lv_svnme+".Usrcod"] = $("#usrcod").val() ? $("#usrcod").val() : localStorage.getItem(lv_svnme+".Usrcod");
  $.ajax({headers: lp_headers, data:{"nxturl": location.href}}).done(function(data){ 
    try{ data = JSON.parse(data); } catch (error) { }

    if (typeof(data)==="string"){
      if(data.substring(0,10)=="/*script*/") {
        eval(data);
      }else{
        var lv_newdoc = document.open("text/html", "replace");
        lv_newdoc.write(data);
        lv_newdoc.close();
      } 
    }else{
      if ( (data.errtyp==undefined?"":data.errtyp)=="E" ) {
        toastr.warning(data.errcod+": "+data.errtxt);
        localStorage.removeItem(lv_svnme+".Usrtkn");
        localStorage.removeItem(lv_svnme+".Usrcod");
      } 
    }

  }).fail(function (request, textStatus, error) {
    toastr.warning("Error de conexion."+textStatus);
  });
}
</script>	
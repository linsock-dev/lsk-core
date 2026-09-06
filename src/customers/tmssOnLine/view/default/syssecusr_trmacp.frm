<?php
	$lv_sec = $vew_token;
	$lv_usrcod = isset($vew_data['usrcod']) ? $vew_data['usrcod'] : $vew_sec->usrcod;
	$lv_bseurl = isset($vew_data['bseurl']) ? $vew_data['bseurl'] : $vew_sec->bseurl;
	$lv_bsecnx = isset($vew_data['bsecnx']) ? $vew_data['bsecnx'] : $vew_sec->bsecnx;
	$lv_environmet = isset($vew_sec->environmet)?$vew_sec->environmet:'';

	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>">
	<div class="hidden">
    <form id="<?= $lv_sec; ?>_frm">
    	<?= gethtml('usrcod' , 'hidden', $lv_usrcod ); ?>
    	<?= gethtml('bseurl' , 'hidden', $lv_bseurl ); ?>
    	<?= gethtml('bsecnx' , 'hidden', $lv_bsecnx ); ?>
    	<?= gethtml('buscod' , 'hidden',  $vew_data['buscod'] ); ?>
    	<?= gethtml('bustxt' , 'hidden',  $vew_data['bustxt'] ); ?>
    	<?= gethtml('usrtrmacp' , 'hidden', '' ); ?>
      
      <div class="container-fluid">
				<p>Al ingresar a este sitio web, usted acepta atenerse a los <a href="https://gorse.ar/documents/terminosservicio.html" target="_blank">T&eacute;rminos de Servicio</a> y <a href="https://gorse.ar/documents/politicaprivacidad.html" target="_blank">Pol&iacute;tica de Privacidad</a> de Temasis, y a todas las leyes y disposiciones correspondientes, y admite que es responsable de cumplir con las leyes locales que correspondan.</p>
        <br>
        <?= gethtml('usrtrmacp', 'checkbox', 'off',  $lv_default); ?> Estoy de acuerdo con los Terminos de Servicio y Pol&iacute;tica de Privacidad del presente sitio web.
        
      </div><!-- /.container-fluid -->
    </form><!-- -->
  </div><!-- .hidden -->
  <script>
  	function <?= $lv_sec; ?>_redirect(lp_frm){
      document.location.href = lp_frm.find("#bseurl").val();
    }
  </script>
  <script>
		$(function(){
			var lv_svnme = location.host.split(".").map((e) => e.charAt(0).toUpperCase() + e.slice(1)).join(".");
      BootstrapDialog.show({
        title: "Aceptaci&oacute;n del Servicio",
        message: $("#<?= $lv_sec; ?>_frm"),
        closable: false,
        buttons: [ 
          {id: "btn-cnc", label: "<?= $vew_lang->exit; ?>", cssClass: "btn-danger", action: function(dialog){ 
                      localStorage.removeItem(lv_svnme+".Usrtkn");
                      localStorage.removeItem(lv_svnme+".Usrcod");
            <?= $lv_sec; ?>_redirect($(dialog.$modalBody)); 
          }},
          {id: "btn-chg", label: "<?= $vew_lang->continue; ?>", cssClass: "btn-success", action: function(dialog){
          	var lo_frm = $(dialog.$modalBody).find("#<?= $lv_sec; ?>_frm:first");
            var lv_pstdat = $(lo_frm).serializeArray();
            const lv_url = "<?= isset($vew_data['rest']) ? '?prg=syssecusrbus&act=96' : 'index.php' ?>";
            
            const lv_headers = {[lv_svnme+".Usrcod"]: localStorage.getItem(lv_svnme+".Usrcod"),
                              [lv_svnme+".Usrtkn"]: localStorage.getItem(lv_svnme+".Usrtkn")};
            $.ajax({url: lv_url, method:"POST", data: lv_pstdat, headers: lv_headers}).done(function(data){
              try{ data = JSON.parse(data); } catch (error) { }
              
              if (typeof(data)==="string"){
                var lv_newdoc = document.open("text/html", "replace");
                lv_newdoc.write(data);
                lv_newdoc.close();
              } else{
                if ( (data.errtyp==undefined?"":data.errtyp)=="E" ) {
                  toastr.warning(data.errcod+": "+data.errtxt);
                  localStorage.removeItem("Tmss-Usrtkn-<?= $lv_environmet; ?>");
                  localStorage.removeItem("Tmss-Usrcod-<?= $lv_environmet; ?>");
                } else {
                  <?= $lv_sec; ?>_redirect($(dialog.$modalBody));
                }
              }
            }).fail(function(jqXHR, textStatus, errorThrown){
              toastr.warning("Error al actualizar los TyC.<br>"+textStatus);
            });
          }}],
        onhidden: function(dialogItself){ <?= $lv_sec; ?>_redirect();  },
        onshown: function(dialog){ 
          var lo_ftr = $(dialog.$modalFooter);
          var lo_frm = $(dialog.$modalBody).find("#<?= $lv_sec; ?>_frm:first");
					
          $(lo_ftr).find("#btn-chg").prop("disabled", true);
          
          $(lo_frm).on("change", "#usrtrmacp", function(e){
            e.preventDefault();
            $(lo_ftr).find("#btn-chg").prop("disabled", $(this).prop("checked") !== true);
          });
        }
      });
		});
  </script>
</section>
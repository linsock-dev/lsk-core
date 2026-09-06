<?php
	$lv_sec = $vew_token;
	$lv_environmet = isset($vew_sec->environmet)?$vew_sec->environmet:'';
?>
<section id="<?= $lv_sec; ?>">
	<div class="hidden">
	<form id="<?= $lv_sec; ?>_frm">
		<input type="submit" class="hidden">
		<input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<input type="hidden" id="lnktkn" name="lnktkn" value="<?= (isset($vew_data['lnktkn'])?$vew_data['lnktkn']:''); ?>">
		<input type="hidden" id="bsecnx" name="bsecnx" value="<?= (isset($vew_data['bsecnx'])?$vew_data['bsecnx']:''); ?>">
		<input type="hidden" id="bseurl" name="bseurl" value="<?= (isset($vew_data['bseurl'])?$vew_data['bseurl']:''); ?>">
		<input type="hidden" id="usrcod" name="usrcod" value="<?= (isset($vew_data['usrcod'])?$vew_data['usrcod']:''); ?>">
		<div class="container-fluid">
			<p><?= (isset($vew_data['msgtxt'])?$vew_data['msgtxt']:$vew_lang->password_change_message); ?></p> <!-- Por favor, ingrese la contraseña anterior y a continuación ingrese la nueva contraseña. -->
			<?php if ( !isset($vew_data['recovery']) ) { ?>
			<div class="form-group">
				<label for="usrpwd000" class="control-label"><?= $vew_lang->old_password; ?>:</label>
				<input type="password" id="usrpwd000" name="usrpwd000" class="form-control" value="" required autofocus>
			</div>
			<?php } ?>
			<div class="form-group">
				<label for="usrpwd001" class="control-label"><?= $vew_lang->password; ?>:</label>
				
        <div class="row">
          <div class="tmss-wrap pl-15 pr-15">
            <input type="password" required maxlength="50" id="usrpwd001" name="usrpwd001" class="form-control pr-35" value="">
            <i class="far fa-eye-slash fa-lg pwdeye" data-toggle="popover" title="<?= $vew_lang->directives ?>"></i>
          </div>
        </div>
				<div class="progress mb-1">
          <div id="complexity-bar" class="progress-bar" role="progressbar">
						<div id="complexity" class="tmss-a-false" ></div>
					</div>
        </div>
        <ul id="drtLst" class="hidden list-unstyled tmss-list-scroll"></ul>
			</div>
			<div class="form-group">
				<label for="usrpwd002" class="control-label"><?= $vew_lang->confirmpassword; ?>:</label>
        <div class="row">
          <div class="tmss-wrap pl-15 pr-15">
            <input type="password" required maxlength="50" id="usrpwd002" name="usrpwd002" class="form-control pr-35" value="">
            <i class="far fa-eye-slash fa-lg  pwdeye" data-toggle="popover" title="<?= $vew_lang->directives ?>"></i>
          </div>
        </div>
				<span class="help-block"></span>
			</div>
		</div>
	</form>
	</div>
  <script>
  	function <?= $lv_sec; ?>_showDirectives(lp_psw){
      var lv_msg = "";
      var lv_cnt = 0;
      for( let i=0; i < gv_<?= $lv_sec; ?>_pwdDrt.length; i++ ){
        if(!gv_<?= $lv_sec; ?>_pwdDrt[i].fulfilled){
          //si la directiva no se cumple se muestra el mensaje al usuario
          
          //VARIABLES///////////////////////////////////////////////////////////////////////////////////////////////
          ////@@PATTERN/////////////////////////////////////////////////////////////////////////////////////////////
          //////Coincidencias en la contraseña//////////////////////////////////////////////////////////////////////
          //////////////////////////////////////////////////////////////////////////////////////////////////////////    
          
          // armar mensaje con las variables remplazadas
          let lv_drtmsg = gv_<?= $lv_sec; ?>_pwdDrt[i].message;
          // remplaza variables
          if(lv_drtmsg.search("@@PATTERN") != -1 ){ 
            // remplazar saltos de linea
            var lv_ptr = (gv_<?= $lv_sec; ?>_caseSensitive ? gv_<?= $lv_sec; ?>_pwdDrt[i].value : gv_<?= $lv_sec; ?>_pwdDrt[i].value.toLowerCase() ).replace(new RegExp("[\r\n]+","g"), "|");
            
            // crea regexp y compara caracteres
            var lv_mtc_arr = lp_psw.match(new RegExp("("+lv_ptr+")", "gi"));
            
						if(lv_mtc_arr != null){
							// quita coincidencias duplicadas
              lv_mtc_arr = lv_mtc_arr.filter(function(match, i){  
                return lv_mtc_arr.indexOf(match) == i;  
             	});  
            	
              // reemplaza variable pattern
              lv_drtmsg = lv_drtmsg.replaceAll( "@@PATTERN", lv_mtc_arr.join(", ") );
            }
          }
          lv_msg += "<li title='" + lv_drtmsg + "'><i class='fas fa-times-circle text-danger'></i>&nbsp;" + lv_drtmsg + "</li>";
          lv_cnt++;
        }   
      }
      
      //muestra el div de mensaje si hay mensajes para mostrar
      if( lv_msg != "" ){
        $("#<?= $lv_sec; ?>_frm #drtLst").height( lv_cnt < 6 ? 23*lv_cnt : 115 ).removeClass("hidden");
      }else{
        $("#<?= $lv_sec; ?>_frm #drtLst").addClass("hidden");
      }             
      
      // adjunta el mensaje
      $("#<?= $lv_sec; ?>_frm #drtLst").empty().append( lv_msg );
    }
	</script>
  <script>
  	function <?= $lv_sec; ?>_showProgress(lp_tot, lp_qty){
      var lv_complexity = lp_qty*100/lp_tot;
      var lo_progressBar = $("#<?= $lv_sec; ?>_frm #complexity-bar");
      lo_progressBar.toggleClass("progress-bar-danger", (Math.round(lv_complexity)<=50) );
      lo_progressBar.toggleClass("progress-bar-warning", (Math.round(lv_complexity)>50 && Math.round(lv_complexity)<100) );
      lo_progressBar.toggleClass("progress-bar-success", (Math.round(lv_complexity)>=100) );
      lo_progressBar.css({"width": lv_complexity + "%"});
      lo_progressBar.data("complexity", Math.round(lv_complexity));
    }
	</script>
  <script>
    // Revisa si se están cumpliendo las directivas
    function <?= $lv_sec; ?>_checkDirectives( lp_psw ){       
      // Recorre las directivas y comprueba que se cumplan
      for( let i=0; i < gv_<?= $lv_sec; ?>_pwdDrt.length; i++ ){
                                              
        //revisa si la condición de la directiva se cumple
        let lv_newcnd = "password = '" + lp_psw + "';" + gv_<?= $lv_sec; ?>_pwdDrt[i].condition;
                                             
      	//ejecuta la codicion
        if( !eval( lv_newcnd ) ){
          gv_<?= $lv_sec; ?>_pwdDrt[i].fulfilled = false;
        }else{
          gv_<?= $lv_sec; ?>_pwdDrt[i].fulfilled = true;
        }
      }
      
      // verifica que todas las directivas estén siendo cumplidas
      return !gv_<?= $lv_sec; ?>_pwdDrt.some(function(drt){ return !drt.fulfilled; });
    }
  </script>
	<script>
		$(function(){
			tmssLoadScript("sha256",function(){});
      
			<?php if(!isset($vew_data["admpwdchg"])){ ?>
      
        BootstrapDialog.show({
          title: "<?= $vew_lang->changepassword; ?>",
          message: $("#<?= $lv_sec; ?>_frm"),
          closable:false,
          buttons: [ 
            {id: "btn-cnc", label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialog){ 
              document.location.href="<?= $vew_data['bseurl']; ?>";
            }},
            {id: "btn-chg", label: "<?= $vew_lang->change; ?>", cssClass: "btn-success", action: function(dialog){
              $(dialog.$modalBody).find("#<?= $lv_sec; ?>_frm input:first").trigger("click");
            }}
            ],
          onshown: function(dialog){ 
            //pone el foco en el campo de contraseña
            $(dialog.$modalBody).find("#<?= $lv_sec; ?>_frm #usrpwd001").focus();

            //declara variables
            //------------------------------------------------------
            var lo_ftr = $(dialog.$modalFooter);
            $(lo_ftr).find("#btn-chg").prop("disabled","disabled");
            var lo_frm = $(dialog.$modalBody).find("#<?= $lv_sec; ?>_frm:first");
            <?= $lv_sec; ?>_drtInit();
            //------------------------------------------------------

            //submit del formulario
            //------------------------------------------------------
            $(lo_frm).submit(function(e){
              var hash = sha256.create();
              var lv_pwd = $(lo_frm).find("#usrpwd001").prop("value");
              var lv_pwd = gv_<?= $lv_sec; ?>_caseSensitive ? lv_pwd : lv_pwd.toUpperCase();
              
              hash.update( lv_pwd );
              $(lo_frm).find("#usrpwd001").prop("value",hash.hex());
              $(lo_frm).find("#usrpwd002").prop("value",hash.hex());
              e.preventDefault();
              
              var lv_pstdat = $(lo_frm).serializeArray();
              lv_pstdat.push({name: "usratr003", value: go_<?= $lv_sec; ?>_PwdNoRepeatQty.value});
              
              $.ajax({url:"?prg=syssecusrpwd&act=14",method:"POST",data:lv_pstdat}).done(function(data){
                <?php if ( isset($vew_data["recovery"]) ) { ?>
                  $("body").html(data);
                <?php } ?>
              }).fail(function(jqXHR, textStatus, errorThrown){
                toastr.warning("Error al cambiar la contraseña.<br>"+textStatus);
              });
            });
            //------------------------------------------------------

            //handler del evento keyup de los campos de contraseña
            //------------------------------------------------------
            $(lo_frm).find("#usrpwd001, #usrpwd002").keyup(function(e){e.preventDefault;
              var lp_psw = $(lo_frm).find("#usrpwd001").val();        
              var lv_rdy = false;
              // Corrije el valor de la contraseña si es undefined
              lp_psw = lp_psw ?? "";
              // Escapa caracter '
              lp_psw = lp_psw.replace("'", "\\\'"); 

              //revisa las directivas
              lv_rdy = <?= $lv_sec; ?>_checkDirectives(lp_psw);
              <?= $lv_sec; ?>_showDirectives(lp_psw);
              <?= $lv_sec; ?>_showProgress(gv_<?= $lv_sec; ?>_pwdDrt.length, gv_<?= $lv_sec; ?>_pwdDrt.filter(function(drt){ return drt.fulfilled; }).length);

              if(lv_rdy){ 
                if( $(lo_frm).find("#usrpwd001").val() == $(lo_frm).find("#usrpwd002").val() ) {
                    $(lo_ftr).find("#btn-chg").prop("disabled","");
                  } else {
                    $(lo_ftr).find("#btn-chg").prop("disabled","disabled");
                  }
              }
            });
            //------------------------------------------------------
          }
        });
      
      <?php } ?>
      
		});
  </script>
  <script>
    var gv_<?= $lv_sec; ?>_pwdDrt = [];
    var gv_<?= $lv_sec; ?>_caseSensitive = false;
    var go_<?= $lv_sec; ?>_PwdNoRepeatQty = {id: "", message:"", value:""};
    
    function <?= $lv_sec; ?>_checkBackdrop(){
      if($(".tmss-backdrop").length==0){
        $(document.body).append("<div class='tmss-backdrop hidden'><span class='tmssWaitSpin'></span>&nbsp;</div>");
      }
    }
    function <?= $lv_sec; ?>_showBackdrop(){
      <?= $lv_sec; ?>_checkBackdrop(); 
      $(".tmss-backdrop").removeClass("hidden");
    }
    function <?= $lv_sec; ?>_hideBackdrop(){
      <?= $lv_sec; ?>_checkBackdrop(); 
      $(".tmss-backdrop").addClass("hidden");
    }
    
    function <?= $lv_sec; ?>_tmssCallProcess( lp_url, lp_dat, lp_callback ) {
      <?= $lv_sec; ?>_showBackdrop();
      const lv_headers = {"Tmss-Usrcod-<?= $lv_environmet; ?>": localStorage.getItem("Tmss-Usrcod-<?= $lv_environmet; ?>"),
                         "Tmss-Usrtkn-<?= $lv_environmet; ?>": localStorage.getItem("Tmss-Usrtkn-<?= $lv_environmet; ?>")};
      $.ajax({url:lp_url,method:"POST",data:lp_dat, headers: lv_headers}).done(function(data){
        <?= $lv_sec; ?>_hideBackdrop();
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
              lp_callback( data );
            }
          }
        } else if ( (data.errtyp==undefined?"":data.errtyp)=="E" ) {
          toastr.warning(data.errcod+": "+data.errtxt);
        } else {
          lp_callback( data );
        }
      }).fail(function (request, textStatus, error) {
        <?= $lv_sec; ?>_hideBackdrop();
        toastr.warning("Error de conexion."+textStatus);
      });
    }
    
    function <?= $lv_sec; ?>_drtInit(){ 
      <?= $lv_sec; ?>_tmssCallProcess("?prg=syssecusrpwd&act=getPwdDirectives", [{name: "usrcod", value: "<?= $vew_data['usrcod'] ?>"}], function(data){ 
        var lo_regexp = { 
          "w": new RegExp("\\p{L}", "gu"), 
          "wu": new RegExp("\\p{Lu}", "gu"), 
          "wl": new RegExp("\\p{Ll}", "gu"), 
          "n": new RegExp("\\d", "g"), 
          "s": new RegExp("[\\p{S}\\p{P}]","gu")
        };
        
        for( let i=0; i < data.length; i++ ){
					let lv_condition = "false";
          
          //acomoda el valor para el mensaje
          if( data[i].syssecdrttyptyp == 'string' ){ 
            data[i].syssecdrttypdef = data[i].syssecdrttypdef.replaceAll("|", "\r\n").replaceAll("&amp;", "&").replaceAll("&gt;", ">").replaceAll("&lt;", "<").replaceAll("&quot;", '"').replaceAll("&#039;", "'");
         	}
                                             
          //atributos---------------------------------------------------------------------------------------------------------------------
          let lv_atr = data[i]['syssecdrttypatr'];
          let lv_visible = ( $( "<div>" + lv_atr + "</div>" ).find("usrshw").text() == "1" ? true : false ); 
         	let lv_drtmsg = "";
          
          // verifica que haya mensaje por defecto
          if($( "<div>" + lv_atr + "</div>" ).find("usrmsg").text() != ""){
            let lv_rplval = data[i].syssecdrttypdef.replaceAll("\r\n", "&ZeroWidthSpace;").replace(/[\s]/g, "");
            if(data[i].syssecdrttypcodext.toLowerCase() == "pwdstartwith"){
              lv_rplval = (data[i].syssecdrttypdef == "S" ? "s&iacute;mbolos" : (data[i].syssecdrttypdef == "N" ? "n&uacute;meros" : "letras" )); 
            }
            lv_drtmsg = "&ZeroWidthSpace;" + $( "<div>" + lv_atr + "</div>" ).find("usrmsg").text().replace( '@@DEFAULT', lv_rplval );
          }else{
            lv_drtmsg = "Directiva " + data[i].syssecdrttyptxt + " no cumplida";
          }
          //------------------------------------------------------------------------------------------------------------------------------
            
    			//escapa algunos caracteres para la condicion
          if( data[i].syssecdrttyptyp == 'string' ){ 
            data[i].syssecdrttypdef = data[i].syssecdrttypdef.replace(/[\/.*+?^${}()|[\]\\]/g, '\\$&');
         	}
          
          //construye json con los datos de la directiva
          let lv_drt = { code:data[i].syssecdrttypcodext, 
                        text:data[i].syssecdrttyptxt, 
                        value:data[i].syssecdrttypdef, 
                        message: lv_drtmsg, 
                        tipo:data[i].syssecdrttyptyp,
                       fulfilled: false};

          //declara la condicion de la directiva------------------------------------------------------------------------------------------
          switch( lv_drt.code.toLowerCase() ){
            case "pwdnorepeatqty":
              go_<?= $lv_sec; ?>_PwdNoRepeatQty.id = data[i].syssecdrttypcod;
              go_<?= $lv_sec; ?>_PwdNoRepeatQty.value = lv_drt.value;
              go_<?= $lv_sec; ?>_PwdNoRepeatQty.message = lv_drt.message;
              break;
            case "pwdlgncasesensitive": 
            	gv_<?= $lv_sec; ?>_caseSensitive = ( lv_drt.value == "1" ? true : false );
              break;
            case "pwdbannedwords": 
              lv_drt.fulfilled = true;
              lv_drt.value = lv_drt.value.replaceAll("\r\n", "|").replace(/[\s]/g, "");
              lv_condition = "if( password.match( /(" + lv_drt.value + ")/gi ) == null ){ true; }else{ false; }";
              lv_drt.value = "(" + lv_drt.value + ")";
              break;
            case "pwdallowcharset":
              lv_drt.fulfilled = true;
              lv_drt.value = lv_drt.value.replace(/[\s]/g, "");
              lv_condition = "( password.length == 0 ) || ( password.match( /[" + lv_drt.value + "]/g ) != null && password.match( /[" + lv_drt.value + "]/g ).length == password.length ) ";
              break;
            case "pwdstartwith": 
              lv_condition = lo_regexp[lv_drt.value.toLowerCase()] + ".test(password.charAt(0))";
            	break;
            case "pwdlettersrequired": 
            	lv_condition = "password.match(" + lo_regexp["w"] + ") != null && password.match(" + lo_regexp["w"] + ").length >= " + lv_drt.value;
              break;
            case "pwdlowerlettersrequired":
            	lv_condition = "password.match(" + lo_regexp["wl"] + ") != null && password.match(" + lo_regexp["wl"] + ").length >= " + lv_drt.value;
              break;
            case "pwdupperlettersrequired":
              lv_condition = "password.match(" + lo_regexp["wu"] + ") != null && password.match(" + lo_regexp["wu"] + ").length >= " + lv_drt.value;
              break;
            case "pwdnumbersrequired":
              lv_condition = "password.match(" + lo_regexp["n"] + ") != null && password.match(" + lo_regexp["n"] + ").length >= " + lv_drt.value;
              break;
            case "pwdsymbolsrequired":
              lv_condition = "password.match(" + lo_regexp["s"] + ") != null && password.match(" + lo_regexp["s"] + ").length >= " + lv_drt.value;
              break;
            case "pwdminlength":
              lv_condition = "password.length >= " + lv_drt.value;
              break;
          }
                                             
          lv_drt.condition = lv_condition;
          //------------------------------------------------------------------------------------------------------------------------------
                                                                                                                                     
          if( !lv_visible ){ continue; }
          
          //agrega la directiva al array de directivas
          gv_<?= $lv_sec; ?>_pwdDrt.push( lv_drt );
          
          <?= $lv_sec; ?>_showDirectives("");
          <?= $lv_sec; ?>_showProgress(gv_<?= $lv_sec; ?>_pwdDrt.length, gv_<?= $lv_sec; ?>_pwdDrt.filter(function(drt){ return drt.fulfilled; }).length);
        }
      });
    }
  </script>
  <script>
    $("#<?= $lv_sec; ?>_frm .pwdeye").click(function(){
      $(this).parent().find("input").get(0).type = ( $(this).parent().find("input").get(0).type == "password" ? "text" : "password" );
      $(this).toggleClass("fa-eye").toggleClass("fa-eye-slash");    
    })
  </script>
</section>
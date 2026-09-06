<script>
  $(function(){
    //revisa si estan las opciones de frecuencia
    if(typeof gv_<?= $lv_sec; ?>_dteopt!=undefined){
      //recorre la variable
      var lv_dteopt = gv_<?= $lv_sec; ?>_dteopt;
      for(var i=0;i<lv_dteopt.length;i++){
				//revisa que este declarado un origen
        if(typeof lv_dteopt[i].src!=undefined){
          //recorre todos los elementos contenedores
          var lv_subid = 1;
          lv_dteopt[i].src.each(function(){
            var lv_buffer = "";
            //revisa el texto para la label
            var lv_lbltxt = (typeof lv_dteopt[i].lbltxt!="undefined"?lv_dteopt[i].lbltxt:"");
            //revisa si mostra el resumen de lo seleccionado
            var lv_shwres = (typeof lv_dteopt[i].res!="undefined"?lv_dteopt[i].res:true);
            //guarda las opciones de frecuencia
            var lv_opt = (typeof lv_dteopt[i].opt!="undefined"?lv_dteopt[i].opt:(lv_dteopt[i].opt==[]?["U","PD","PS","PM","PA","C"]:lv_dteopt[i].opt ) );
            
            //crea el seleccion 
            lv_buffer = lv_buffer + "<div id='grldattsktgrp"+i+lv_subid+"'><label id='lbl'>"+lv_lbltxt+"</label>";
            lv_buffer = lv_buffer + "<button id='btn' data-opt='"+JSON.stringify(lv_opt)+"' class='btn' style='margin:0px 5px 0px 5px;'><i class='fas fa-calendar-day'></i></button>";
            lv_buffer = lv_buffer + "<label id='res' class='"+(lv_shwres?"":"hidden")+"'></label>";
            lv_buffer = lv_buffer + "<div id='dat'></div></div>";
            $(this).append(lv_buffer);
            //aumeta el sub contador
            lv_subid++;
            //añado el evento on click
            $(this).find("#btn").on("click",function(){
              <?= $lv_sec; ?>_openDteSelect($(this));
    				});
          });
        }else{
          //mensaje de error
      		toastr.warning("seleccion de fecha:La configuracion esta incompleta.");
        }
      }
  	}else{
    	//mensaje de error
      toastr.warning("seleccion de fecha:Faltan las opciones de configuracion.");
    }
  });
  
  function <?= $lv_sec; ?>_getPrevData(lp_button){
    var lv_prevdatarr = [];
    lp_button.parent().find("#dat input").each(function(){
      lv_prevdatarr.push($(this).attr("id"),$(this).val());
    });
    
    return lv_prevdatarr
  }
  
  function <?= $lv_sec; ?>_openDteSelect(lp_button){
    var lv_post = [{name:"freq",value:lp_button.data("opt")}
    							,{name:"srcid",value:lp_button.parent().attr("id")}];
    
    lv_post.push({name:"prevdat",value:<?= $lv_sec; ?>_getPrevData(lp_button)});
    
    tmssCallProcess('?prg=grlnws&act=sch',lv_post,function(data){
      BootstrapDialog.show({
              title: "<?= $vew_lang->date; ?>",
              message: $(data),
              type: BootstrapDialog.TYPE_INFO,
              size: BootstrapDialog.SIZE_MEDIUM,
        			closable: false,
              buttons: [{ label: "<?= $vew_lang->cancel ?>", cssClass: "btn", action: function(dialog){ dialog.close(); } },
                        {	label: "<?= $vew_lang->select ?>", cssClass: "btn-info",	action: function(dialog){
                          //obtiene el cuerpo del dialogo
                          var lv_body = dialog.$modalBody;
                          //obtiene el div del selector
                          var lv_secdiv = $("#<?= $lv_sec; ?> #"+lv_body.find("#srcid").val());
                          //obteine el contenedor de los datos
                          var lv_dat = lv_secdiv.find("#dat");
                          //obtiene el label del resumen
                          var lv_lblres = lv_secdiv.find("#res");
                          //obtiene la fecha de hoy
                          var lv_today = new Date();
                          var lv_dd = String(lv_today.getDate()).padStart(2, '0');
                          var lv_mm = String(lv_today.getMonth() + 1).padStart(2, '0');
                          var lv_yyyy = lv_today.getFullYear();

                          lv_today = lv_dd + '/' + lv_mm + '/' + lv_yyyy;
                          
                          //activa el guardado
                          debugger;
                          
                          dialog.close();
                        } }]
      });
    });
  }
</script>
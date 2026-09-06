<?php
	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>">
	<div class="container-fluid">
    <div class="col-sm-6">
      <label><?= $vew_lang->where; ?>:</label>
      <?php
        //tabla de medios
        $lv_buffer = '<br>
                          <table class="table table-sm table-hover table-bordered table-condensed"><thead><tr>
                          <th style="width:30px;" class="hidden"><input type="checkbox" id="allmda" class="hidden"></th>
                          <th class="hidden"></th>
                          <th class="text-center hidden" style="width:30px;"><i class="fas fa-calendar-day"></i></th>
                          <th style="width:50px;" class="hidden">'.$vew_lang->status.'</th>
                    </tr></thead><tbody>';
        foreach($vew_data->grlnwsmda as $lv_row){
         if($vew_doc->getTagValue($lv_row['sysintatr'],'social_media')=='X'){
          $lv_mailbtn = ($lv_row['sysintcod']=="24" ? '<button id="btnmail" class="btn pull-right btn-sm">'.$vew_lang->email.'</button>' : '');
          $lv_buffer .= '<tr>
                            <td class="hidden"><input type="checkbox" id="'.$lv_row['sysintcod'].'" class="hidden"></td>
                            <td class="hover">'.$lv_row['sysinttxt'].$lv_mailbtn.'</td>
                            <td class="text-center hidden"><div id="grldattsk"></div></td>
                            <td class="hidden"></td>
                          </tr>';
         }
        }
        $lv_buffer .= '</tbody></table>';
        echo $lv_buffer;

        //programacion general
        include('grldattskschbtn.frm');
      ?>
    </div>
    <div class="col-sm-6">
      <label><?= $vew_lang->when; ?>:</label>
      <div id="grldattskgrl"></div>
    </div>
  </div>
  <div id="mailpopup" class="hidden">

		<div class="container-fluid">
			<label class="control-label">Ingresar un correo electr&oacute;nico</label><br><br>
			<small>Presione enter</small><br><br>
			<input id="<?= $lv_sec ?>_mailinput">
	    <div id="<?= $lv_sec ?>_maildiv"><br></div>
	  </div>
		<script>

			var gv_<?= $lv_sec; ?>_mails = [];
      var gv_<?= $lv_sec; ?>_tempmails = [];

			$("#<?= $lv_sec ?>_mailinput").keypress(function( event ) {
			  if ( event.which == 13 ) {
					var lv_<?= $lv_sec; ?>_mail = $("#<?= $lv_sec ?>_mailinput").val();
					if(/\S+@\S+\.\S+/.test(lv_<?= $lv_sec; ?>_mail)){
						gv_<?= $lv_sec; ?>_tempmails.push(lv_<?= $lv_sec; ?>_mail);
						$("#<?= $lv_sec ?>_maildiv").append("<span class='badge' style='background-color:gray; margin:1px;'>"+lv_<?= $lv_sec; ?>_mail+"<a style='color:#444242;color: #444242; padding-left: 3px;' class='deletemail fas fa-times'></a></span>");
            
            $( document ).on( "click", ".deletemail" , function() {
              var lv_<?= $lv_sec; ?>_oldmail = $(this).parent().text();
              $(this).parent().remove();
              gv_<?= $lv_sec; ?>_tempmails.forEach(function(lv_<?= $lv_sec; ?>_item, lv_<?= $lv_sec; ?>_index, lv_<?= $lv_sec; ?>_object) {
                if (lv_<?= $lv_sec; ?>_item == lv_<?= $lv_sec; ?>_oldmail) { lv_<?= $lv_sec; ?>_object.splice(lv_<?= $lv_sec; ?>_index, 1); }
              });
            });
          	$(this).val("");	
					} else {
						toastr.warning("El mail introducido es inv&aacute;lido");
					}
				}
			});

	  </script>
  </div>
  <script>
    //opciones de los botones de seleccion de fecha
    var gv_<?= $lv_sec; ?>_dteopt = [{src:$("#<?= $lv_sec ?> #grldattskgrl"),opt:[["U","<?= $vew_lang->oneTime; ?>"],["PD","<?= $vew_lang->daily; ?>"],["PS","<?= $vew_lang->weekly; ?>"],["PM","<?= $vew_lang->monthly; ?>"],["PA","<?= $vew_lang->yearly; ?>"]]}];
    
    //oculta el boton de programar y muestra ahora como tiempo de publicacion
		$(function(){
      //boton programar
      $("#<?= $lv_sec; ?> #grldattskgrl #btn").addClass("hidden");
      //tiempo de publicacion
      $("#<?= $lv_sec; ?> #grldattskgrl #res").text("Ahora");
    });
  </script>
  <script>
    //boton de mails
    $("#<?= $lv_sec; ?> #btnmail").on('click',function(e){
      <?= $lv_sec; ?>_changeMdaStatus($(this).parent(), !$(this).parent().parent().find(":checkbox").prop("checked"))
      
      gv_<?= $lv_sec; ?>_tempmails.splice(0,gv_<?= $lv_sec; ?>_tempmails.length);
      
      gv_<?= $lv_sec; ?>_mails.forEach(function(lv_<?= $lv_sec; ?>_item, lv_<?= $lv_sec; ?>_index, lv_<?= $lv_sec; ?>_object) {
        gv_<?= $lv_sec; ?>_tempmails.push(lv_<?= $lv_sec; ?>_item);
      });  
      var lv_<?= $lv_sec; ?>_cloneddiv =  $("#<?= $lv_sec; ?> #mailpopup").clone(true).removeClass("hidden");
      $("#<?= $lv_sec; ?> #mailpopup").empty();
      
      BootstrapDialog.show({
              title: "<?= $vew_lang->email; ?>",
              message: $(lv_<?= $lv_sec; ?>_cloneddiv),
              type: BootstrapDialog.TYPE_PRIMARY,
              size: BootstrapDialog.SIZE_MEDIUM,
              closable: false,
              buttons: [{ label: "<?= $vew_lang->cancel ?>", cssClass: "btn-danger", action: function(dialog){ 
                						$("#<?= $lv_sec; ?> #mailpopup").append(dialog.getModalBody().find(".container-fluid"));
              							$("#<?= $lv_sec ?>_maildiv").empty();
                            $("#<?= $lv_sec ?>_maildiv").append("<br>");
                						gv_<?= $lv_sec; ?>_mails.forEach(function(lv_<?= $lv_sec; ?>_item, lv_<?= $lv_sec; ?>_index, lv_<?= $lv_sec; ?>_object) {
                             $("#<?= $lv_sec ?>_maildiv").append("<span class='badge' style='background-color:gray; margin:1px;'>"+lv_<?= $lv_sec; ?>_item+"<a style='color:#444242;color: #444242; padding-left: 3px;' class='deletemail fas fa-times'></a></span>"); 
                            });
                						dialog.close();
              					} },
                        {	label: "<?= $vew_lang->save ?>", cssClass: "btn-success",	action: function(dialog){
                						$("#<?= $lv_sec; ?> #mailpopup").append(dialog.getModalBody().find(".container-fluid"));
                          	gv_<?= $lv_sec; ?>_mails.splice(0,gv_<?= $lv_sec; ?>_mails.length);
                          	gv_<?= $lv_sec; ?>_tempmails.forEach(function(lv_<?= $lv_sec; ?>_item, lv_<?= $lv_sec; ?>_index, lv_<?= $lv_sec; ?>_object) {
                            	if(lv_<?= $lv_sec; ?>_item.length != 0){
      													gv_<?= $lv_sec; ?>_mails.push(lv_<?= $lv_sec; ?>_item);
                              }
                            });                           
                          	$("#<?= $lv_sec ?>_maildiv").empty();
                          	$("#<?= $lv_sec ?>_maildiv").append("<br>");
                            gv_<?= $lv_sec; ?>_mails.forEach(function(lv_<?= $lv_sec; ?>_item, lv_<?= $lv_sec; ?>_index, lv_<?= $lv_sec; ?>_object) {
                             $("#<?= $lv_sec ?>_maildiv").append("<span class='badge' style='background-color:gray; margin:1px;'>"+lv_<?= $lv_sec; ?>_item+"<a style='color:#444242;color: #444242; padding-left: 3px;' class='deletemail fas fa-times'></a></span>"); 
                            });
                						dialog.close(); 
                        } }]
      });
    });

    //evento para seleccion de medio
    $("#<?= $lv_sec; ?> .hover").on("click",function(){
      <?= $lv_sec; ?>_changeMdaStatus($(this), !$(this).parent().find(":checkbox").prop("checked"))
    });
    
    function <?= $lv_sec; ?>_changeMdaStatus(lp_mda, lp_status){
      //cambia estado de la checkbox
      lp_mda.parent().find(":checkbox").prop('checked',lp_status);
      //cambia el feedback visual
      lp_mda.removeClass(lp_status?"":"bg-success").addClass(lp_status?"bg-success":"");
    }

    // edit mode
  //  tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>
</section>
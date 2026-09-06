<nav class="navbar navbar-default tmss-navbar"> 
  <div class="container-fluid">
    <ul class="nav navbar-nav tmss-navbar-left">
      <?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01')) { ?><a href="#" id="grldoccntbtnnew" class="btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmss-desk-btn"><span class="far fa-file"></span><span class="hidden-xs"> Nuevo</span></a><?php } ?>
    </ul>
    <ul class="nav navbar-nav navbar-right tmss-navbar-right">
      <input type="text"  class="form-control tmssAlwaysEnabled" id="grldoccntfndtxt" placeholder="Buscar..." style="margin-top: 6px !important">
    </ul>
  </div>
</nav>
<div class="table-responsive">
  <table id="grldoccnttbl" class="table table-striped table-condensed">
    <tbody>
    </tbody>
  </table>
</div>
<input type="hidden" id="grldoccntonetme" name="grldoccntonetme">
<script>  
  // REFRESH
  function <?= $lv_sec; ?>_CntRefresh() {
    var lv_buffer = "";
    tmssCallProcess("?prg=grldoccnt&act=08&prm_srcobjtyp=<?= $lv_mdlcod."_".$lv_prgcod; ?>&prm_srcobjcod=<?= $lv_dockey; ?>&prm_grldoccntobjtyp="+$("#<?= $lv_sec; ?> #srcobjtyp").val()+"&prm_grldoccntobjcod="+$("#<?= $lv_sec; ?> #srcobjcod").val()+"&prm_bcksec=<?= $lv_sec; ?>&prm_fndtxt="+$("#<?= $lv_sec; ?> #grldoccntfndtxt").prop("value"), [], function(data) {
      for( var i=0; i<data.list.length; i++){
        if(data.list[i].taxcatstr !== undefined){ data.list[0].taxactstr = moment(data.list[0].taxactstr.date).format("D/MM/Y"); }
        lv_buffer += "<tr data-id="+data.list[i].grldoccntcod+">";
        lv_buffer += "<td width='60' style='vertical-align: middle;'><img src='/library/images/icon_profile.png' class='img-responsive img-circle img-thumbnail'></td>";
        lv_buffer += "<td style='vertical-align: middle;' data-cntcod='"+data.list[i].grldoccntcod+"'><a href='#' name='grldoccnttxt' data-id="+data.list[i].grldoccntcod+"><h5><strong class='grldoccntobjtxt'>"+data.list[i].grldoccntobjtxt+"</strong><br><small>"+data.list[i].sysdocclstxtcnt+"</small></h5></a></td>";
        lv_buffer += "<td style='vertical-align: middle;' class='hidden-xs'><a href='#'>"+data.list[i].adreml+"</a></td>";
        lv_buffer += "<td style='vertical-align: middle;' class='hidden-xs hidden-sm'><a href='#''>"+data.list[i].adrphn001+"</a></td>";
        lv_buffer += "<td style='vertical-align: middle;' class='hidden-xs hidden-sm hidden-md'><a href='#'>"+data.list[i].adrmblphn+"</a></td>";
        lv_buffer += "<td class='hidden'><input type='hidden' class='grldoccntfrm' name='grldoccntfrm' value='"+JSON.stringify(data.list[i])+"'></td>";
                  
        <?php if( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04')) { ?> 
          lv_buffer += "<td width='60' style='vertical-align: middle;' class='text-center'><a href='#' id='grldoccntdellnk' class='btn btn-danger' title='<?= $vew_lang->delete; ?>' data-grldoccntcod="+data.list[i].grldoccntcod+" data-grldoccntobjtxt="+data.list[i].grldoccntobjtxt+"><span class='fas fa-trash-alt'></span></a></td>";
        <?php } ?>
        lv_buffer += "</tr>";
      }
      $("#<?= $lv_sec; ?> #grldoccnttbl tbody").html( lv_buffer );
      <?= $lv_sec ?>_attachEvents();
    });
  }
  
  function <?= $lv_sec ?>_attachEvents(){
    <?php if ( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'03') ) { ?>
      // VISUALIZAR
      $("#<?= $lv_sec; ?> a[name='grldoccnttxt']").on("click",function(e){
        lv_grldoccntfrm = $(this).closest("tr").find(".grldoccntfrm").val();
        lv_pos = $(this).closest("tr").index();
        tmssLink("?prg=grldoccnt&act=03&prm_grldoccntcod="+$(this).data("id")+"&prm_grldoccntobjtyp="+$("#<?= $lv_sec; ?> #srcobjtyp").val()+"&prm_srcobjtyp=<?= $lv_mdlcod."_".$lv_prgcod; ?>&prm_srcdocclscod="+$("#<?= $lv_sec; ?> #sysdocclscod").val()+"&prm_srcobjcod=<?= $lv_dockey; ?>&prm_bcksec=<?= $lv_sec; ?>"+"&prm_readonly=<?= ($vew_readonly ? 'true' : 'false'); ?>", [{target: "_new_section", post_data:[{name:"grldoccntfrm",value:lv_grldoccntfrm},{name:"pos",value:lv_pos},{name:"srcobjtxt", value:$("#<?= $lv_sec; ?> #srcobjtxt").val() }]}]);
      });
    <?php } ?>

    <?php if ( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') ) { ?>
      // BORRAR
      $("#<?= $lv_sec; ?> #grldoccntdellnk").on("click",function(e){
        var lv_grldoccntcod = $(this).data("grldoccntcod");
        var grldoccntdellnk = $(this);
        BootstrapDialog.confirm({
          title: "Borrar",
          message: "&iquest;Desea borrar el documento <strong>"+$(this).closest("tr").find(".grldoccntobjtxt").text()+"</strong>?",
          type: BootstrapDialog.TYPE_WARNING,
          callback: function(result) {
            if(result) {
              if(lv_grldoccntcod != ""){
                tmssCallProcess("?prg=grldoccnt&act=04&prm_bcksec=<?= $lv_sec; ?>", [{name:"grldoccntcod",value:lv_grldoccntcod}], function(data){
                  toastr.success("Documento borrado", "<?= $vew_lang->contact; ?>");
                  $(grldoccntdellnk).closest("tr").remove();
                });
              }else{
                $(grldoccntdellnk).closest("tr").addClass("hidden");
                $(grldoccntdellnk).closest("tr").find(".grldoccntfrm").append("<input type='hidden' name='borrar' value='X'>");
              }
            }
          }
        });
      });
    <?php } ?>		  
  }

  // BUSCAR
  $("#<?= $lv_sec; ?> #grldoccntfndtxt").on("keyup",function(e){e.preventDefault();e.stopPropagation();
    var lv_txt = $(this).prop("value");
    $("#<?= $lv_sec; ?> #grldoccnttbl > tbody > tr").each(function(x){
      if ($(this).text().toLowerCase().indexOf( lv_txt.toLowerCase() )!=-1) {
        $(this).removeClass("hidden");
      } else {
        $(this).addClass("hidden");
      }
    });
  });

  //evita que el formulario se entere del evento submit
  $("#<?= $lv_sec; ?> #grldoccntfndtxt").keydown(function(e){
    if(e.keyCode == 13) {
      e.preventDefault();
      return false;
    }
  });

  <?php if ( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01') ) { ?>
    // CREAR
    $("#<?= $lv_sec; ?> #grldoccntbtnnew").on("click",function(e){
      if( $("#<?= $lv_sec; ?> #grldoccntonetme").val() == "1" && $("#<?= $lv_sec; ?> .grldoccntfrm").length == 0 ){
      	tmssLink("?prg=grldoccnt&act=01&prm_srcobjtyp=<?= $lv_mdlcod."_".$lv_prgcod; ?>&prm_srcdocclscod="+$("#<?= $lv_sec; ?> #sysdocclscod").val()+"&prm_readonly=<?= ($vew_readonly ? 'true' : 'false'); ?>"+"&prm_grldoccntobjtyp="+$("#<?= $lv_sec; ?> #srcobjtyp").val()+"&prm_grldoccntobjcod="+$("#<?= $lv_sec; ?> #srcobjcod").val()+"&prm_srcobjtxt="+$("#<?= $lv_sec; ?> #srcobjtxt").val()+"&prm_srcobjcod=<?= $lv_dockey; ?>&prm_bcksec=<?= $lv_sec; ?>&prm_onetme="+$("#<?= $lv_sec; ?> #grldoccntonetme").val(), [{target: "_new_section", post_data:[{name:"sysdocclscod",value:"-1"}]}]);
      }else{
      	tmssLink("?prg=grldoccnt&act=01&prm_srcobjtyp=<?= $lv_mdlcod."_".$lv_prgcod; ?>&prm_srcdocclscod="+$("#<?= $lv_sec; ?> #sysdocclscod").val()+"&prm_readonly=<?= ($vew_readonly ? 'true' : 'false'); ?>"+"&prm_grldoccntobjtyp="+$("#<?= $lv_sec; ?> #srcobjtyp").val()+"&prm_grldoccntobjcod="+$("#<?= $lv_sec; ?> #srcobjcod").val()+"&prm_srcobjtxt="+$("#<?= $lv_sec; ?> #srcobjtxt").val()+"&prm_srcobjcod=<?= $lv_dockey; ?>&prm_bcksec=<?= $lv_sec; ?>&prm_onetme="+$("#<?= $lv_sec; ?> #grldoccntonetme").val(), [{target: "_new_section"}]);
      }
    });
  <?php } ?>


  $(function(){
    $("#<?= $lv_sec; ?> #grldoccntfndtxt").focus();
    <?= $lv_sec; ?>_CntRefresh();     // Carga de lista de contactos
  });
</script>
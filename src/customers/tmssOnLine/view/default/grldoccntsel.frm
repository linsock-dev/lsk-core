<?php
	// librer�a de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>">
  <div class="row">
    <div class="col-xs-1"></div>
    <div class="col-xs-10">
      <?php if ( count($vew_data->int)>=1 && count($vew_data->cnt)>=1 ) { ?>
        <h3>Seleccione los usuarios para cada interlocutor</h3>
        <div class="list-group">
          <?php foreach($vew_data->int as $lv_row){ ?>
          	<div class="cnttyp-holder">
          	<a href="#" class="list-group-item cnttyp" 
               data-cntcod="" 
               data-sysdocclscodcnt="<?= $lv_row['sysdocclscodcnt']; ?>" 
               data-sysdocclstxtcnt="<?= $lv_row['sysdocclstxtcnt']; ?>" 
               id="<?= $lv_row['sysdocclscodcnt']; ?>"><b><?= $lv_row['sysdocclstxtcnt']; ?>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b><span class="cnttxthdr"></span></a>
            <?php foreach($vew_data->cnt as $lv_row2){
  						// convierte todos los caracteres UTF-8 para poder hacerles un json_encode.
  						foreach($lv_row2 as &$lv_row3){
                if(is_string($lv_row3)){
                	$lv_row3 = utf8_encode($lv_row3); 
                }
              }
              $lv_row2['srcobjtyp'] = $vew_data->post['srcobjtyp'];
              $lv_row2['srcobjcod'] = $vew_data->post['srcobjcod'];
              $lv_row2['grldoccntobjtyp'] = $lv_row2['cntsrctyp'];
              $lv_row2['grldoccntobjcod'] = $lv_row2['cntsrccod'];
              $lv_row2['grldoccntobjtxt'] = $lv_row2['cnttxt'];
  						unset($lv_row3);
  						//$lv_row2['cnttxt'] = utf8_encode($lv_row2['cnttxt']); ?>
              <a href="#" class="list-group-item cntopt hidden" 
                data-cntcod="<?= $lv_row2['cntcod']; ?>" 
                data-cnttxt="<?= utf8_decode($lv_row2['cnttxt']); ?>" 
                data-adreml="<?= utf8_decode($lv_row2['adreml']); ?>" 
                data-adrphn001="<?= $lv_row2['adrphn001']; ?>" 
                data-adrmblphn="<?= $lv_row2['adrmblphn']; ?>" 
                data-grldoccntfrm='<?= json_encode($lv_row2); ?>'
                id="<?= $lv_row2['cntcod']; ?>">#<?= $lv_row2['cntcod']; ?> - <?= utf8_decode($lv_row2['cnttxt']); ?></a>								
            <?php } ?>
            <div>
					<?php } ?>
        </div>
      <?php } else { ?>
        <h3>Configuraci&oacute;n insuficiente</h3>
        <blockquote>
          <p>No hay interlocutores definidos.</p>
        </blockquote>
      <?php } ?>
    </div>
    <div class="col-xs-1 col-md-3"></div>
  </div>
</section>
<script>
  $("#<?= $lv_sec; ?> .cnttyp").click( function() {
    if($(this).parent().children(".cntopt").hasClass("hidden")){
      $("#<?= $lv_sec; ?> .cntopt").addClass("hidden");
    	$(this).parent().children(".cntopt").removeClass("hidden");
    }else{
      $("#<?= $lv_sec; ?> .cntopt").addClass("hidden");
      $(this).parent().children(".cntopt").addClass("hidden");
    }
  });
  
  $("#<?= $lv_sec; ?> .cntopt").click( function() {
    $(this).parent().children(".cnttyp").data("cntcod", $(this).data("cntcod"));
    $(this).parent().children(".cnttyp").data("cnttxt", $(this).data("cnttxt"));
    $(this).parent().children(".cnttyp").data("adreml", $(this).data("adreml"));
    $(this).parent().children(".cnttyp").data("adrphn001", $(this).data("adrphn001"));
    $(this).parent().children(".cnttyp").data("adrmblphn", $(this).data("adrmblphn"));
    $(this).parent().children(".cnttyp").data("grldoccntfrm", JSON.stringify($(this).data("grldoccntfrm")));
    $(this).parent().children(".cnttyp").find(".cnttxthdr").text("("+$(this).text()+")");
    $("#<?= $lv_sec; ?> .cntopt").addClass("hidden");
  });
</script>
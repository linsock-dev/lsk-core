<section id="syssecusr_bussel">
  <div class="modal fade">
    <div class="modal-dialog">
      <div class="modal-content">
        
        <div class="modal-header">
          <button type="button" id="btncls" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title">Seleccionar empresa</h4>
        </div>
        
        <div class="modal-body">
          <form method="POST" action="index.php">
            <input type="hidden" id="usrcod" name="usrcod" value="<?= $vew_sec->usrcod; ?>">
            <input type="hidden" id="usrtxt" name="usrtxt" value="<?= $vew_sec->usrtxt; ?>">
            <input type="hidden" id="bseurl" name="bseurl" value="<?= $vew_sec->bseurl; ?>">
            <input type="hidden" id="bsecnx" name="bsecnx" value="<?= $vew_sec->bsecnx; ?>">
            <input type="hidden" id="buscod" name="buscod" value="">
            <input type="hidden" id="bustxt" name="bustxt" value="">
            <input type="hidden" id="buschg" name="buschg" value="1">
            <p>Seleccione la empresa a utilizar:</p>
            <div class="list-group">
              <?php foreach( $vew_co_bus as $lv_row ) { ?>
              <a href="#" class="list-group-item" id="<?= $lv_row['buscod']; ?>" data-resturl="<?= ($lv_row['resturl']??''); ?>"><?= utf8_encode($lv_row['bustxt']); ?></a>
              <?php } ?>
            </div>
          </form>
        </div>
      
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div><!-- /.modal -->
  <script>
    <?php 
    	$lv_path = explode('/',str_ireplace( '\\' , '/' , strtolower($vew_sec->bseurl)));
    
    	if(isset($lv_path[3]) && $lv_path[3] == 'gorse.php'){ ?>
    		// R E S T
    		$("#syssecusr_bussel #btncls").click( function() { document.location.href="<?= $vew_sec->bseurl; ?>"; });
    
        $("#syssecusr_bussel .list-group-item").click( function() { 
          $("#syssecusr_bussel form").attr("action", `../../gorse.php/${$(this).data("resturl")}`);
          var lv_bseurl = $("#bseurl").val().split("/");
          lv_bseurl[lv_bseurl.length-1] = $(this).data("resturl");
          $("#bseurl").val(lv_bseurl.join("/"));
          $("#syssecusr_bussel #buscod").prop("value",this.id); 
          $("#syssecusr_bussel #bustxt").prop("value",this.text);
          $("#syssecusr_bussel form").submit(); 
        });
      <?php }else{ ?>
    		$("#syssecusr_bussel #btncls").click( function() { document.location.href="<?= $vew_sec->bseurl; ?>"; });
        $("#syssecusr_bussel .list-group-item").click( function() { 
          $("#syssecusr_bussel #buscod").prop("value",this.id); 
          $("#syssecusr_bussel #bustxt").prop("value",this.text);
          $("#syssecusr_bussel form").submit(); 
        });
        
    <?php } ?>
    $("#syssecusr_bussel > div:first").modal({backdrop: 'static'});
  </script>
</section>
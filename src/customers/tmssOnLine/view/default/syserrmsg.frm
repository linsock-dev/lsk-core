<section id="syserrmsg">
  <div class="modal fade">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title"><span class="fa fa-exclamation-triangle"></span> <?= (isset($vew_msgttl)?$vew_msgttl:''); ?></h4>
        </div>
        <div class="modal-body">
          <div class="container-fluid">
            <p><?= (isset($vew_msgtxt)?$vew_msgtxt:''); ?></p>						
          </div>
        </div>
        <div class="modal-footer">
					<?php
						foreach( $vew_msgbtn as $lv_btn ) {
							echo '<a href="#" onclick="'.$lv_btn['action'].'" class="btn btn-primary">'.$lv_btn['text'].'</a>';
						}
					?>
        </div>
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div><!-- /.modal -->
  <script>
    $("#syserrmsg .modal").modal({backdrop: 'static'});
  </script>
</section>
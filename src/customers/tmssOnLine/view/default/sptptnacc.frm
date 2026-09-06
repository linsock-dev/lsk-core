<?php
	// url del formulario
  $lv_lnk = '?prg=sptptnacc&prm_ptnacccod='.$vew_data->ptnacccod;

	// campos requeridos
	$vew_input->RequiredFields( array('ptnacccodext') );

	// clave del documento
	$lv_dockey = $vew_data->ptnacccod;

	// titulo
	$lv_title = $vew_lang->control;
	
	// módulo y programa
	$lv_mdlcod = 'SPT';
	$lv_prgcod = 'ACC';
	$vew_actcod = '01';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">


  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<div class="navbar-brand"><strong><?=($vew_data->acctyp == 's'?'Boleteria':'Acceso');?></strong></div>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">		
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
  </nav>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod', 'hidden', '') ?>
  
    <div class="container-fluid">  
			<div class="row">
				<div class="col-md-6">
          <div class="card">
            <div class="card-header"><div class="card-title"><?= $vew_lang->partners; ?></div></div>
              <div class="card-body tmss-card-body-edit">
					<?php
						echo vew_boot($lv_col210, array('label'=>$vew_lang->partner, 
																						'input'=>vew_boot(	
																								array('style'=>'search', 'readonly'=>($vew_readonly) ),
																								array('input'=>gethtml('ptnbarcod', 'doccmt1x50', $vew_data->ptnbarcod, $lv_default)))
																							));
					?>
              </div>
				</div>

			<div class="col-md-6">
        <div class="card">
          <div class="card-header">
            <div class="card-title"><?= $vew_lang->data; ?>
              <span class="tmss-card-icon"><i class="fas fa-file-invoice"></i></span>
          	</div>
          </div>
          <div class="card-body tmss-card-body-edit">
          	<div id="ptnaccsts" class="text-center">
            	<img src="https://temasis.com.ar/library/images/TemasisArgentina_Isotipo_280gray.png" id="ptnimg" class=".grldatupl_divpic .grldatupl_container img-circle img-responsive">
                <?php
                echo vew_boot($lv_col210, array('label'=>$vew_lang->firstname, 'input'=>gethtml('ptntxt', 'doccmt1x50', $vew_data->ptntxt,$lv_always_disabled) ));
                echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts',   'docsts',      $vew_data->docsts,$lv_always_disabled) ));
                echo vew_boot($lv_col210, array('label'=>$vew_lang->phone, 'input'=>gethtml("adrphn001", "doccmt1x50", $vew_data->adrphn001, $lv_always_disabled)));
                ?>
            </div>
          		</div>
            </div>
          </div>
        </div>
			</div>
    </div> <!-- container-fluid -->
  </form>
  <script>
    $("#<?= $lv_sec; ?> #ptnbarcod").on("keydown",function(e){
      var code = e.keyCode || e.which;
      if(code == 13) {
				e.preventDefault();
				var lv_pstdat = [{name:"ptnbarcod", value:$("#<?= $lv_sec; ?> #ptnbarcod").prop("value")},{name:"acctyp", value:"<?= $vew_data->acctyp ?>"}];
        tmssCallProcess("?prg=sptptnacc&act=13",lv_pstdat,function(data){
					$("#<?= $lv_sec; ?> #ptntxt").val( data.ptntxt );
          $("#<?= $lv_sec; ?> #docsts").val( data.docsts.toLowerCase() );
					$("#<?= $lv_sec; ?> #ptncattxt").val( data.ptncattxt );
					$("#<?= $lv_sec; ?> #ptnaccststxt").val( data.ptnaccststxt );
          $("#<?= $lv_sec; ?> #lv_cnt").val( data.lv_cnt );
          $("#<?= $lv_sec; ?> #adrphn001").val( data.adrphn001 );
				});			
      }
    });

		//Popup
		$("#<?= $lv_sec; ?> #ptnbarcod").next("span").children("a:first").on("click", function(e) { e.preventDefault();
			tmssPopup("<?= $vew_lang->partner; ?>","?prg=sptptn&prm_vewcod=VEW_SPT_PTN_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[ptnbarcod:ptncodext]", function(dialog){
          var lv_pstdat = [{name:"ptnbarcod", value:$("#<?= $lv_sec; ?> #ptnbarcod").prop("value")},{name:"acctyp", value:"<?= $vew_data->acctyp ?>"}];
          tmssCallProcess("?prg=sptptnacc&act=13",lv_pstdat,function(data){
            $("#<?= $lv_sec; ?> #ptntxt").val( data.ptntxt );
            $("#<?= $lv_sec; ?> #docsts").val( data.docsts.toLowerCase() );
            $("#<?= $lv_sec; ?> #ptncattxt").val( data.ptncattxt );
            $("#<?= $lv_sec; ?> #ptnaccststxt").val( data.ptnaccststxt );
            $("#<?= $lv_sec; ?> #lv_cnt").val( data.lv_cnt );
            $("#<?= $lv_sec; ?> #adrphn001").val( data.adrphn001 );
          });
        });
      });                                                                                 
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
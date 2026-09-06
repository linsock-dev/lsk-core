<?php
	// url del formulario 
  $lv_lnk = '?prg=sysappiaamdl&prm_sysappiaamdlcod='.$vew_data->sysappiaamdlcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('sysappiaamdltxt', 'docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->sysappiaamdlcod;

	// titulo 
	$lv_title = $vew_lang->artificialintelligence;
	
	// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'IAM';
	
	// librería de estilos bootstrap  
	include_once('_library.frm');

	$lv_sysappiaamdlatr = json_decode( ($vew_data->sysappiaamdlatr==''?'[]':$vew_data->sysappiaamdlatr), true );
	$vew_data->sysappiaamdlatrhdr = $lv_sysappiaamdlatr['hdr']??'';
	$vew_data->sysappiaamdlatrpst = json_encode($lv_sysappiaamdlatr['pst']??array());
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod', 'hidden', ''); ?>
		<?= gethtml('sysappiaamdlmap', 'hidden', ''); ?>
    <?= '<textarea id="sysappiaamdlatr" name="sysappiaamdlatr" class="hidden"></textarea>'; ?>
     		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->sysappiaamdlcod; ?><?= gethtml('sysappiaamdlcod', 'hidden', $vew_data->sysappiaamdlcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,			'input'=>gethtml('sysappiaamdlcodext','doccmt1x30', 	$vew_data->sysappiaamdlcodext, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->supplier,	'input'=>gethtml('sysappiaamdltxt', 	'doccmt1x50', 	$vew_data->sysappiaamdltxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->model, 		'input'=>gethtml('sysappiaamdlver', 	'doccmt1x250',	$vew_data->sysappiaamdlver, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 	'input'=>gethtml('docsts', 						'docsts', 			$vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>

						</div>
            <div class="col-md-6">
              
              <div class="card">
              	<div class="card-header">
                  <div class="card-title"><?= $vew_lang->configuration; ?>
                  	<a href="#" class="card-icon" id="testBtn"><i class="far fa-bolt"></i></a>
                	</div>
              	</div>
								<div class="card-body tmss-card-body-edit">
                  <?php 
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->url, 	'input'=>gethtml('sysappiaamdlurl', 'doccmt1x250',	$vew_data->sysappiaamdlurl, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>'Header', 				'input'=>gethtml('sysappiaamdlatrhdr','doccmt5x50', $vew_data->sysappiaamdlatrhdr, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>'Post', 					'input'=>gethtml('sysappiaamdlatrpst','doccmt5x50', $vew_data->sysappiaamdlatrpst, $lv_default) ));
                  ?>
                </div>
              </div>

            </div>
					</div>
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <script>
    $("#<?= $lv_sec; ?> #testBtn").on("click",function(e){e.preventDefault();
      var lv_msg = "<div class='container-fluid'>"
      						+"<div class='row form-group'><label class='control-label col-sm-2'>Key</label><div class='col-sm-10'><input type='text' id='key' class='form-control'></div></div>"
      						+"<div class='row form-group'><label class='control-label col-sm-2'>Prompt</label><div class='col-sm-10'><textarea id='prompt' class='form-control'></textarea></div></div>"
                	+"<hr>"
      						+"<div class='row form-group'><label class='control-label col-sm-2'>Status</label><div class='col-sm-10' id='prompt_status'></div></div>"
                  +"<div class='row form-group'><label class='control-label col-sm-2'>Result</label><div class='col-sm-10' id='prompt_result'></div></div>"
      						+"</div>";
      BootstrapDialog.show({
        size: BootstrapDialog.SIZE_WIDE,
        draggable: true,
        closable: true,
        title: "Test",
        message: $(lv_msg),
        buttons: [{ label: "Test", cssClass: "btn-success", action: function(dialogItself){
          dialogItself.$modalBody.find("#prompt_status").html("");
          dialogItself.$modalBody.find("#prompt_result").html("");
          lv_pstdat =[{name:"sysappiaamdlcod",value:"<?= $vew_data->sysappiaamdlcod; ?>"},
                      {name:"key",value:dialogItself.$modalBody.find("#key").val()},
                      {name:"prompt",value:dialogItself.$modalBody.find("#prompt").val()}];
          tmssCallProcessErr("?prg=sysappiaamdl&act=execute",lv_pstdat,
            function(data){
            	dialogItself.$modalBody.find("#prompt_status").html( data.errtyp+" "+data.errcod ); 
            	dialogItself.$modalBody.find("#prompt_result").html( data.data );
          	}, 
            function(data){
            	dialogItself.$modalBody.find("#prompt_status").html( data.errtyp+" "+data.errcod ); 
            	dialogItself.$modalBody.find("#prompt_result").html( data.errtxt );
          	}
          );
          
        }}]
      });
		});
  </script>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
			// al grabar
			if ( lp_prm["action"]=="00" ) {
        var lv_pst;
        var lv_hdr = $("#<?= $lv_sec; ?> #sysappiaamdlatrhdr").val(); 
        // Intenta parsear los JSONs para validar su formato
				try {
          lv_pst = JSON.parse( $("#<?= $lv_sec; ?> #sysappiaamdlatrpst").val()==''?'[]':$("#<?= $lv_sec; ?> #sysappiaamdlatrpst").val() );
        } catch (error) {
          
          toastr.warning("Error: JSON invalido. Por favor, verifica el formato de Post.");
          return false;
        } 
        // Si ambos JSONs son válidos, crea el objeto combinado
        let lv_atr = { hdr: lv_hdr, pst: lv_pst	};
				$("#<?= $lv_sec; ?> #sysappiaamdlatr").prop( "value", JSON.stringify(lv_atr,null,2) );
			}
    }
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
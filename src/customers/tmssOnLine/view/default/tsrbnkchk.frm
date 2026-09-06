<?php
	/* url del formulario */
  $lv_lnk = '?prg=tsrbnkchk&prm_bnkchkcod='.$vew_data->bnkchkcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('docsts','bnkacctxt','bnkchkfrtnum','bnkchkqty') );

	/* clave del documento */
	$lv_dockey = $vew_data->bnkchkcod;

	/* titulo */
	$lv_title = $vew_lang->checkbooks;
	
	/* módulo y programa */
	$lv_mdlcod = 'TSR';
	$lv_prgcod = 'BNC';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');

 	$lv_rmdnum = ($vew_data->bnkchklstnum == '' ? 0 : $vew_data->bnkchklstnum) - ($vew_data->bnkchkusdnum == '' ? 0 : $vew_data->bnkchkusdnum);
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <!-- Nav-bar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->bnkchkcod; ?><?= gethtml('bnkchkcod', 'hidden', $vew_data->bnkchkcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">	
        <!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->accountnumber,
                         	                          'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                       	                                                array('input'=>gethtml('bnkacctxt', 'typeahead', $vew_data->bnkacctxt, $lv_default ))
                    	                            										))
                                  									);
                    echo gethtml('bnkacccod', 'hidden', $vew_data->bnkacccod, $lv_default);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->firstnumber,'input'=>gethtml('bnkchkfrtnum', 'docnum0800', $vew_data->bnkchkfrtnum, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->lastnumber,'input'=>gethtml('bnkchklstnum', 'docnum0800', $vew_data->bnkchklstnum, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->quantity,'input'=>gethtml('bnkchkqty', 'docnum0800', $vew_data->bnkchkqty, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->usedlastnumber,'input'=>gethtml('bnkchkusdnum', 'docnum0800', $vew_data->bnkchkusdnum, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->remainingnumbers,'input'=>gethtml('bnkchkrmdnum', 'docnum0800', ($lv_rmdnum == 0 ? "0" : $lv_rmdnum), $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
                </div>
             	</div>
          	</div>
					</div>
				</div> <!-- fin _tab001 -->
		  </div> <!-- tabcontent -->
  	</div> <!-- container-fluid -->
  </form>
  <script>
    $("#<?= $lv_sec; ?> #bnkchkqty").change(function(){
      $("#<?= $lv_sec; ?> #bnkchklstnum").val( parseInt($("#<?= $lv_sec; ?> #bnkchkfrtnum").val()) + parseInt($("#<?= $lv_sec; ?> #bnkchkqty").val()) -1 );
    });

    $("#<?= $lv_sec; ?> #bnkchklstnum").change(function(){
      $("#<?= $lv_sec; ?> #bnkchkqty").val( parseInt($("#<?= $lv_sec; ?> #bnkchklstnum").val()) - parseInt($("#<?= $lv_sec; ?> #bnkchkfrtnum").val()) + 1 );
    });

    $("#<?= $lv_sec; ?> #bnkchkusdnum").change(function(){
      $("#<?= $lv_sec; ?> #bnkchkrmdnum").val( parseInt($("#<?= $lv_sec; ?> #bnkchklstnum").val()) - parseInt($("#<?= $lv_sec; ?> #bnkchkusdnum").val()) );
    });
    
    $("#<?= $lv_sec; ?> #bnkchkfrtnum").change(function(){
      $("#<?= $lv_sec; ?> #bnkchkqty").val( parseInt($("#<?= $lv_sec; ?> #bnkchklstnum").val()) - parseInt($("#<?= $lv_sec; ?> #bnkchkfrtnum").val()) +1 );
    });
    
    $("#<?= $lv_sec; ?> #bnkchkrmdnum").change(function(){
      $("#<?= $lv_sec; ?> #bnkchkusdnum").val( parseInt($("#<?= $lv_sec; ?> #bnkchklstnum").val()) - parseInt($("#<?= $lv_sec; ?> #bnkchkrmdnum").val()) );
    });
  </script>
  <script>
    // bnkacccod
    var lo_get = {"fldsec": "<?= $lv_sec; ?>" ,"fldasg": {"bnkacctxt":"bnkacctxt","bnkacccod":"bnkacccod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #bnkacctxt"), "tsrbnkacc", lo_get);
  </script>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
      if ( lp_prm["action"]=="00" ) {
				if ( parseInt( $("#<?= $lv_sec; ?> #bnkchkusdnum").val() ) < parseInt( $("#<?= $lv_sec; ?> #bnkchkfrtnum").val() ) || parseInt( $("#<?= $lv_sec; ?> #bnkchkusdnum").val() ) > parseInt( $("#<?= $lv_sec; ?> #bnkchklstnum").val() ) ) {
					$("#<?= $lv_sec; ?> #bnkchkusdnum").parentsUntil(".tmss-form-group").parent().addClass("has-error");
					toastr.warning( "Error en Ultimo Numero Utilizado: Numero no valido." );
          return false; 
        } else {
					$("#<?= $lv_sec; ?> #bnkchkusdnum").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
				}
    	}
    }
  </script>  
	<?php include('grldocfrmscr.frm'); ?>
</section>
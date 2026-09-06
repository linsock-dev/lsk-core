<?php
	/* url del formulario */
  $lv_lnk = '?prg=hhrchrtyp&prm_hhrchrtypcod='.$vew_data->hhrchrtypcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('hhrchrtyptxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->hhrchrtypcod;

	/* titulo */
	$lv_title = $vew_lang->chargestypes;
	
	/* módulo y programa */
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'CHT';
	
  /* libreria de estilos bootstrap*/
  include_once('_library.frm');
?>
	<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
   
  <!-- Nav-Bar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		    
      <div class="container-fluid" role="tabpanel">
       <!-- Solapa -->
		    <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				 <li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				 <li class="pull-right"><h4># <strong><?= $vew_data->hhrchrtypcod; ?><input type="hidden" id="hhrchrtypcod" name="hhrchrtypcod" value="<?= $vew_data->hhrchrtypcod; ?>"></strong></h4></li>
			  </ul>
				<!-- Tablas -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
				 <div class="row">
					<div class="col-md-6">
           <div class="card">
            <div class="card-header">
             <div class="card-title">
              <?= $lv_title; ?>
             </div>
            </div>
            <div class="card-body tmss-card-body-edit">
						 <?php 
							echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('hhrchrtypcodext', 'doccodext', $vew_data->hhrchrtypcodext, $lv_default) ));
							echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('hhrchrtyptxt', 'doccmt1x50', $vew_data->hhrchrtyptxt, $lv_default) ));
							echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 					'docsts', 		$vew_data->docsts, 					$lv_default) ));
						 ?>
            </div>
					 </div>
          </div>
		 			 <div class="col-md-6">
            <div class="card">
             <div class="card-header">
              <div class="card-title">
                <?= $vew_lang->data; ?>
              </div>
             </div>
             <div class="card-body tmss-card-body-edit">
              <?php
                echo vew_boot($lv_col210, array('label'=>$vew_lang->class,'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly ),array('input'=>gethtml('hhrchrclstxt', 'typeahead', $vew_data->hhrchrclstxt, $lv_default)))) );
                echo gethtml('hhrchrclscod','hidden',$vew_data->hhrchrclscod);
                echo vew_boot($lv_col210, array('label'=>$vew_lang->salary, 'input'=>gethtml('hhrchrtypatrslrasg', array(''=>'','C'=>'POR CONVENIO','M'=>'MANUAL'), $vew_doc->getTagValue($vew_data->hhrchrtypatr,'slrasg'), $lv_default) )); 
                echo vew_boot($lv_col210, array('label'=>'Asig.Horas', 'input'=>gethtml('hhrchrtypatrtmeasg',array(''=>'','M'=>'MANUAL','C'=>'CONTROL HORAS','S'=>'SIN ASIGNACION'), $vew_doc->getTagValue($vew_data->hhrchrtypatr,'tmeasg'), $lv_default) ));
                 echo vew_boot($lv_col210, array('label'=>$vew_lang->comments, 'input'=>gethtml('hhrchrtypcmt', 'doccmt5x50', $vew_data->hhrchrtypcmt, $lv_default) ));
              ?>
             </div>
            </div>
					 </div>
				  </div> <!-- fin _tab001 -->
		    </div> <!-- tabcontent -->
      </div> <!-- container-fluid -->
  </form>
  <script>
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"hhrchrclscod":"hhrchrclscod", "hhrchrclstxt":"hhrchrclstxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #hhrchrclstxt"), "hhrchrcls", lo_get)
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
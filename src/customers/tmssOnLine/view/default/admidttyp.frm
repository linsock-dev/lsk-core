<?php
  // url del formulario
  $lv_lnk = "?prg=admidttyp&prm_idttypcod=".$vew_data->idttypcod;

  // campos requeridos
  $vew_input->RequiredFields( array('lndcod','idttypcod','idttyptxt','docsts') );

  // clave del documento
  $lv_dockey = $vew_data->idttypcod;

  // título
  $lv_title = $vew_lang->IDENTIFICATIONS;
    
  // módulo y programa
  $lv_mdlcod = 'SYS';
  $lv_prgcod = 'LNI';
    
  // librería de estilos
  include_once('_library.frm');
?>

<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
  
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
  	<?= gethtml('tmss_actcod', 'hidden', '') ?>
  	<?= gethtml('idttypcodsve', 'hidden', $vew_data->idttypcod) ?>
    <!-- Solapas -->
    <div class="container-fluid" role="tabpanel">
      <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
        <li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
        <li class="pull-right"><h4># <strong><?= $vew_data->idttypcod; ?></strong></h4></li>
      </ul>
      <div class="tab-content tmss-tab-content">
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
          	<div class="col-md-6">
          		<div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $lv_title; ?></div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <div class="<?= ($vew_data->idttypcod == '' ? '': 'hidden'); ?>">
                  	<?= vew_boot($lv_col210, array('label'=>$vew_lang->code,	'input'=>gethtml('idttypcod', 'doccmt1x50', $vew_data->idttypcod, $lv_default) )); ?>
                  </div>
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->country, 	'input'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_data->lndtxt,$vew_data->idttypcod==""?$lv_default:$lv_always_disabled),
                                                                                                   	 array("input"=>gethtml('lndtxt', 'doccmt1x50', $vew_data->lndtxt,$vew_data->idttypcod==""?$lv_default:$lv_always_disabled) )) ));
                  	echo  gethtml('lndcod', 'hidden', $vew_data->lndcod);
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('idttyptxt','doccmt1x20', $vew_data->idttyptxt, $lv_default) ));               
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
          	</div>
          </div> <!-- cierre row -->
        </div> <!-- /_tab001 -->
      </div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
    // Typeahead for lndcod
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"lndcod":"lndcod" , "lndtxt":"lndtxt"}} ;
    tmssTypeahead($("#<?= $lv_sec; ?> #lndtxt"), "grladrlnd", lo_get);
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
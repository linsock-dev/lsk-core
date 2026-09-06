<?php		
	// url del formulario
  $lv_lnk = '?prg=sysobjcls&prm_sysobjclscod='.$vew_data->sysobjclscod;

	// campos requeridos 
	$vew_input->RequiredFields( array('sysobjclstxt','sysobjclstyp','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->sysobjclscod; 

	// titulo
	$lv_title = $vew_lang->objectclass;
	
	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'OBC';
	
	// librería de estilos
  include_once('_library.frm');

	$lv_typarr = array(''=>'','CSS'=>'CSS','FN'=>'SQL Function','JS'=>'Javascript','PHP'=>'PHP','REC'=>'Record','SP'=>'Stored Procedure','TABLE'=>'Table');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->sysobjclscod; ?><?= gethtml('sysobjclscod','hidden',$vew_data->sysobjclscod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">	
          <div class="col-md-6">
            <div class="card">
              <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
              <div class="card-body tmss-card-body-edit">
                <?php 
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('sysobjclscodext','doccmt1x20', $vew_data->sysobjclscodext, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('sysobjclstxt', 	'doccmt1x50', $vew_data->sysobjclstxt, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 				'docsts', 		$vew_data->docsts, $lv_default) ));
                ?>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="card">
              <div class="card-header"><div class="card-title"><?= $vew_lang->data; ?></div></div>
              <div class="card-body tmss-card-body-edit">
                <?php 
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 		'input'=>gethtml('sysobjclstyp', $lv_typarr, 	 $vew_data->sysobjclstyp, $lv_default) )); 
                	echo '<div id="sysobjclssysdiv">';
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->system, 	'input'=>gethtml('sysobjclssys', 'checkbox', 	 $vew_data->sysobjclssys, $lv_default) )); 
                	echo '</div>';
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->path, 		'input'=>gethtml('sysobjclspth', 'doccmt1x50', $vew_data->sysobjclspth, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->extension,'input'=>gethtml('sysobjclsfleext', 'doccmt1x20', $vew_data->sysobjclsfleext, $lv_default) ));
                ?>
              </div>
            </div>
          </div>
				</div> <!-- /_tab001 -->
				
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
		
  </form>
  <script>
    $("#<?= $lv_sec; ?> #sysobjclstyp").on("change",function(){
      if($(this).val()=="SP" || $(this).val()=="TABLE" || $(this).val()=="FN" ){
        $("#<?= $lv_sec; ?> #sysobjclssysdiv").show();
      } else {
      	$("#<?= $lv_sec; ?> #sysobjclssysdiv").hide();
      }
    });
    $("#<?= $lv_sec; ?> #sysobjclstyp").trigger("change");
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
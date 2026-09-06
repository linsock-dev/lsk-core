<?php 
	/* url del formulario */
  $lv_lnk = '?prg=stkmatunt&prm_matuntcod='.$vew_data->matuntcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('matuntcod','matunttxt','matunttypcod','matuntqty','matuntbse','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->matuntcod; 

	/* titulo */
	$lv_title = $vew_lang->measureunit;

	/* módulo y programa */
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'MUN';

	/* librer�a de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<input type="hidden" id="matuntcodsrc" name="matuntcodsrc" value="<?= $vew_data->matuntcod; ?>">

    <div class="container-fluid">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->matuntcod; ?><?php if($vew_data->matuntcod!=''){ ?><input type="hidden" id="matuntcod" name="matuntcod" value="<?= $vew_data->matuntcod; ?>"><?php } ?></strong></h4></li>
			</ul>
      
      <div class="tab-content tmss-tab-content">
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
						
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->units; ?></div></div>
								<div class="card-body tmss-card-body-edit">
									<?php
										if($vew_data->matuntcod==''){ echo vew_boot($lv_col210, array('label'=>$vew_lang->id, 				'input'=>gethtml('matuntcod',	'matuntcod',$vew_data->matuntcod, ($vew_data->matuntcod==''?$lv_default:$lv_always_disabled) ) )); }
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('matunttxt',	'matunttxt',$vew_data->matunttxt,	$lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->type,  			'input'=>gethtml('matunttypcod', 'matunttypcod',$vew_data->matunttypcod, ($vew_data->matuntcod==''?$lv_default:$lv_always_disabled) ) ));
                    echo vew_boot(array($lv_col237, $lv_colxs1244), array('label'=>$vew_lang->quantity,
                                                       'input1'=>gethtml('matuntqty',	'docqty',		 $vew_data->matuntqty,	$lv_default),
                                                       'input2'=>gethtml('matuntbse', 'matuntcod', $vew_data->matuntbse, $lv_default) )
                                                      );
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
								</div>
							</div>
						</div>
					</div>
				</div> <!-- container-fluid -->
			</div>
		</div>
  </form>
  <?php include('grldocfrmscr.frm'); ?>
</section>
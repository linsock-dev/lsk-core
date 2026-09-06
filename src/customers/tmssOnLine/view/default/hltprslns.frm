<?php
	// url del formulario 
  $lv_lnk = '?prg=hltprslns&prm_hltlnscod='.$vew_data->hltlnscod;

	// campos requeridos 
	$vew_input->RequiredFields( array('hltlnsdte', 'prstxt', 'buyexptyptxt', 'hltlnsqta', 'hltlnsqtaint', 'hltlnsqtaintunt','hltlnsqtafrtdte','hltlnstot', 'docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->hltlnscod;

	// titulo 
	$lv_title = $vew_lang->LoansAndAdvances;

	// m�dulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'LNS';

	// librer�a de estilos bootstrap 
	include_once('_library.frm');

	// valores x default
	if( $vew_data->hltlnscod==''){
		$vew_data->hltlnsdte = date('d/m/Y');
		$vew_data->docsts='A';
	}

	$vew_tbl['modR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
  $vew_tbl['modL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
  $vew_tbl['accL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'09'), 'id'=>'btnacc', 'acc'=>'');
  $vew_tbl['accR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'09'), 'id'=>'btnacc', 'acc'=>'');
	$vew_tbl['del'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'04') && ($vew_data->docsts!='C' || ($vew_data->docsts=='C' && count($vew_data->hltprslnsqta)==0)) );
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hltlnscod; ?><?= gethtml('hltlnscod', 'hidden', $vew_data->hltlnscod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <!-- NOVEDADES -->
              <div class="card">
								<div class="card-header">
									<div class="card-title"><?= $vew_lang->news; ?><span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?><i class="fas fa-newspaper"></i></span>
                    <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);?>
									</div>
								</div>    
                
                <div class="card-body tmss-card-body-edit">
                  <?php
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->date,		'input'=>gethtml('hltlnsdte', 'docdte', $vew_data->hltlnsdte, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('hltlnscodext', 'doccmt1x20', $vew_data->hltlnscodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->provider, 
                                                							'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                      						array('input'=>gethtml('prstxt', 'typeahead', $vew_data->prstxt, $lv_default)) )) );
                    echo gethtml('prscod', 'hidden', $vew_data->prscod);         
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 
                                                      'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                          array('input'=>gethtml('buyexptyptxt', 'typeahead', $vew_data->buyexptyptxt, $lv_default)) )) );
                    echo gethtml('buyexptypcod', 'hidden', $vew_data->buyexptypcod);     
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hltlnstxt', 'doccmt1x50', $vew_data->hltlnstxt, $lv_default) ));  
        						echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', ($vew_data->docsts=='C'?'docstsacc':'docsts'), $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div> <!-- card -->
						</div> <!-- col --> 
            
            <div class="col-md-6">
              <div class="row">
                <div class="col-md-12">
                  <!-- CUOTAS -->
                  <div class="card">
                    <div class="card-header">
                      <div class="card-title">
                        <?= $vew_lang->quotas; ?>
                        <span class="tmss-card-icon"><i class="fas fa-file-invoice-dollar"></i></span>
                      </div>
                    </div>  

                    <div class="card-body tmss-card-body-edit">
                      <?php
                        echo vew_boot($lv_col264, array('label'=>$vew_lang->total,
                                                        'input1'=>gethtml('hltlnstot', 'docprctot', $vew_data->hltlnstot, $lv_default),
                                                        'input2'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                            array('input'=>gethtml('curcod', 'curcod', $vew_data->curcod, $lv_always_disabled) ))
                                                        ));

                        echo vew_boot($lv_col210, array('label'=>$vew_lang->quotas,	'input'=>gethtml('hltlnsqta', 'docrngnum', $vew_data->hltlnsqta, $lv_default) ));
                        echo vew_boot($lv_col264, array('label'=>$vew_lang->interval,
                                                                    'input1'=>gethtml('hltlnsqtaint', 'docrngnum', $vew_data->hltlnsqtaint, $lv_default),
                                                                    'input2'=>vew_boot(	array('style'=>'search', 'readonly'=>true),
                                                                                        array('input'=>gethtml('hltlnsqtaintunt', 'nwsqtaint', $vew_data->hltlnsqtaintunt, $lv_default) ))
                                                        ));
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->StartDate,'input'=>gethtml('hltlnsqtafrtdte', 'docdte', $vew_data->hltlnsqtafrtdte, $lv_default) ));
                      ?>
                    </div> 
                  </div> <!-- card -->
                </div> 
              </div> 
              <div class="row">
                <div class="col-sm-12 <?= ( $vew_data->hltlnscod!='' && $vew_data->docsts=='C' ? "" : "hidden" ) ?>">
                  <div class="card">
                    <div class="card-header">
                      <div class="card-title">
                        <?= $vew_lang->DETAIL; ?>
                      </div>           
                    </div>
                    <div class="card-body tmss-card-body-edit">
                      <table class="table table-condensed table-striped">
                        <thead>
                          <th><?= $vew_lang->expenses; ?></th>
                          <th><?= $vew_lang->date; ?></th>
                          <th><?= $vew_lang->total; ?></th>
                          <th><?= $vew_lang->liquidation; ?></th>
                        </thead>
                        <tbody>
                          <?php 
                          $lv_buffer = '';
                          if($vew_data->hltprslnsqta){
                          	foreach($vew_data->hltprslnsqta as $lv_row){
                              $lv_buffer .= '<tr>'.
                                            '<td><a href="#" name="explnk" data-buyexpcod="'.$lv_row['buyexpcod'].'">'.$lv_row['buyexpcod'].'</a></td>'.
                                						'<td>'.date_format($lv_row['buyexpdocdte'],'d/m/Y').'</td>'.
                                						'<td>'.$lv_row['buyexpdoctot'].'</td>'.	
                                            '<td><a href="#" name="lqdlnk" data-hltprslqdcod="'.$lv_row['hltprslqdcod'].'">'.$lv_row['hltprslqdcod'].'</a></td>'.
                                						'</tr>';
                            }
                          }
                          echo $lv_buffer;
                          ?>
                        </tbody>
                      </table>
                    </div>
                	</div>
             	 </div>
             </div>
						</div> <!-- col --> 
					</div> <!-- row -->
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form> 
  <script>
  	// prstxt
    var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldasg" : {"prstxt" : "prstxt", "prscod" : "prscod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #prstxt"), "hltprs", lo_get);

    // TIPO DE NOVEDAD
    var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldasg" : {"buyexptyptxt" : "buyexptyptxt", "buyexptypcod" : "buyexptypcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #buyexptyptxt"), "buyexptyp", lo_get);
    
    // MONEDA
    var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldasg" : {"curcod" : "curcod"}, "typeahead" : false }; 
    tmssTypeahead($("#<?= $lv_sec; ?> #curcod"), "admcur", lo_get);
  </script>
  <script>
  	$("#<?= $lv_sec; ?> a[name='explnk']").on("click",function(e){ e.preventDefault();
			tmssLink("?prg=buyexp&act=03&prm_buyexpcod="+$(this).data("buyexpcod"), [{target: "_new_section"}] );
		});
    
  	$("#<?= $lv_sec; ?> a[name='lqdlnk']").on("click",function(e){ e.preventDefault();
			tmssLink("?prg=hltprslqd&act=03&prm_hltprslqdcod="+$(this).data("hltprslqdcod"), [{target: "_new_section"}] );
		});
  </script>
  <script>
    // CONTABILIZAR
		$("#<?= $lv_sec; ?> #btnacc").on("click",function(e){
			BootstrapDialog.confirm({
				title: "Contabilizar",
				message:"Desea contabilizar el documento?",
				type: BootstrapDialog.TYPE_PRIMARY,
				callback: function(result){
					if(result){<?= $lv_sec; ?>_fnc({action: "09"});}
				}
			});
		});
  </script>
  <script> 
    // server response ext
    function <?= $lv_sec; ?>_fncbckext( data ) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="09") {
					toastr.info("Documento contabilizado.");
					<?= $lv_sec; ?>_fnc({action: "99"});
				} else if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
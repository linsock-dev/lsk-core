<?php
	/* url del formulario */
  $lv_lnk = '?prg=hltagr&prm_hltagrcod='.$vew_data->hltagrcod; 

	/* campos requeridos */
	$vew_input->RequiredFields(array('hltagrtxt','docsts', 'hltagrstrdte', 'hltagrenddte'));

	/* clave del documento */
	$lv_dockey = $vew_data->hltagrcod; 

	/* titulo */
	$lv_title = $vew_lang->agreement;
	
	/* m�dulo y programa */
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'AGR';

	/* librer�a de estilos bootstrap */
	include_once('_library.frm');
?>

<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!--navbar-->
	<?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
		 
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hltagrcod; ?><?= gethtml('hltagrcod', 'hidden', $vew_data->hltagrcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
									<div class="card-title"><?= $vew_lang->agreement; ?> 
									 <span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
										<?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
									</div>
                </div>
								<div class="card-body tmss-card-body-edit">
                	<?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('hltagrcodext', 'doccmt1x20',$vew_data->hltagrcodext, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->name,	'input'=>gethtml('hltagrtxt', 'doccmt1x50', 	$vew_data->hltagrtxt, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->start,'input'=>gethtml('hltagrstrdte', 'docdte', 		$vew_data->hltagrstrdte, $lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->End,	'input'=>gethtml('hltagrenddte', 'docdte', 		$vew_data->hltagrenddte, $lv_default) ));               		
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status,'input'=>gethtml('docsts', 'docsts', 					$vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
						</div>
            <!--Prestadores -->
						<div class="col-md-6">
							<div class="card">
								<div class="card-header">
									<div class="card-title">
										<?= $vew_lang->providers; ?>
										<a class="card-icon" id="btnDelRow"><i class="fas fa-trash"></i></a>
									</div>
								</div><!--header-->
								<div class="card-body">
									<div id="drttyptbl"></div>
									<?= gethtml('hltagratrprs', 'hidden', ''); ?>
								</div>
							</div><!-- /card -->
						</div><!-- /col-md-6 -->
					</div><!-- /row -->
				</div> <!-- /_tab001 -->				
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <script>
		var go_<?= $lv_sec; ?>_tbltyp;
    var go_<?= $lv_sec; ?>_tblcfg;
    var gv_<?= $lv_sec; ?>_tbldat; 
    go_<?= $lv_sec; ?>_tblcfg = {
                readOnly: <?= ($vew_readonly?'true':'false'); ?>,
                allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
                headerData: [{title:"<?= $vew_lang->providers; ?>", width:"100%"}],
                columnsData: [
                              {id: "hltagratrprs", type: "typeahead", 
                               typeahead: function(values){ 
                                 return {definition: "hltprs",
                                         data: {
                                           fldsec: "<?= $lv_sec ;?>",
                                           fldasg: {"hltagratrprs": "prstxt", 
                                                    "prscod": "prscod",
                                                   	}
                                           }
                                         };
                               }
                              },
                            ],
                showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}]
                };
                    
    gv_<?= $lv_sec; ?>_tbldat = [<?php
          $lv_buffer='';
      	
          if($vew_data->hltagratrprs != ''){
            foreach($vew_data->hltagratrprs as $lv_row){ 
              $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                
                'prscod:"'.$lv_row['prscod'].'",'.
                'hltagratrprs:"'.$lv_row['prstxt'].'"'.
                
                '}'; 
            }
          }	
          echo $lv_buffer;
			?>];
    
    go_<?= $lv_sec; ?>_tbltyp = new tmssTable($("#<?= $lv_sec; ?> #drttyptbl"), go_<?= $lv_sec; ?>_tblcfg);

    
    $(function(){
    	go_<?= $lv_sec; ?>_tbltyp.loadData(gv_<?= $lv_sec; ?>_tbldat);
    });
	</script>
  
  <script>
      function <?= $lv_sec; ?>_fncext(lp_prm){
      // al grabar
			if ( lp_prm["action"]=="00" ) {
				var lv_dat = go_<?= $lv_sec; ?>_tbltyp.getData();
        var lv_buffer = "";
        
        for (var i=0; i < lv_dat.length; i++) {
         	lv_buffer += (lv_buffer==""?"":",") + lv_dat[i].prscod;
        }
        
				$("#<?=$lv_sec;?> #hltagratrprs").prop("value", lv_buffer);
        
			}
    }
	</script>

  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
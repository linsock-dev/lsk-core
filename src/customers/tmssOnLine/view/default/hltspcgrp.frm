<?php
	// url del formulario
  $lv_lnk = '?prg=hltspcgrp&prm_spcgrpcod='.$vew_data->spcgrpcod; 

	// campos requeridos
	$vew_input->RequiredFields( array('spcgrptxt','spcgrpcodext','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->spcgrpcod; 

	// titulo
	$lv_title = $vew_lang->specialty;
	
	// modulo y programa
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'SPG';

	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
     <?= gethtml('tmss_actcod', 'hidden', ''); ?>
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->spcgrpcod; ?><?= gethtml('spcgrpcod', 'hidden', $vew_data->spcgrpcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->specialtiesclassification; ?></div></div>
								<div class="card-body tmss-card-body-edit">
                	<?php 
                  		echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 				'input'=>gethtml('spcgrpcodext', 'doccmt1x20', $vew_data->spcgrpcodext, $lv_default) ));
                 		 	echo vew_boot($lv_col210, array('label'=>$vew_lang->description,	'input'=>gethtml('spcgrptxt', 'doccmt1x50', $vew_data->spcgrptxt, $lv_default) ));
                  		echo vew_boot($lv_col210, array('label'=>$vew_lang->sortorder,		'input'=>gethtml('spcgrpatrord','doccmt1x50',$vew_doc->getTagValue($vew_data->spcgrpatr,'ord'), $lv_default) ));
                  		echo vew_boot($lv_col210, array('label'=>$vew_lang->image,				'input'=>gethtml('spcgrpatrimg','doccmt1x50',$vew_doc->getTagValue($vew_data->spcgrpatr,'img'), $lv_default) ));
                  		echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
						</div>
             <!--Especialidades-->
          <div class="col-md-6">
            <div class="card tmss-hot-ttl">
              <div class="card-header">
                <div class="card-title">
                  <?= $vew_lang->specialties; ?>
                  <a class="card-icon" id="btnDelRow"><i class="fas fa-trash"></i></a>
                </div>
              </div><!--header-->
              <div class="card-body">
                <div id="drttyptbl"></div>
                <?= gethtml('spcgrpatrspc', 'hidden', ''); ?>
              </div><!--body-->
            </div><!-- card -->
          </div><!--col-->
					</div>
				</div> <!-- fin _tab001 -->				
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
		var go_<?= $lv_sec; ?>_tbltyp;
    var go_<?= $lv_sec; ?>_tblcfg;
    var gv_<?= $lv_sec; ?>_tbldat; 
    go_<?= $lv_sec; ?>_tblcfg = {
                readOnly: <?= ($vew_readonly?'true':'false'); ?>,
                allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
                headerData: [{title:"<?= $vew_lang->specialties; ?>", width:"100%"}],
                columnsData: [
                              {id: "spcgrpatrspc", type: "typeahead", 
                               typeahead: function(values){ 
                                 return {definition: "hltspc",
                                         data: {
                                           fldsec: "<?= $lv_sec ;?>",
                                           fldasg: {"spcgrpatrspc": "spctxt", 
                                                    "spccod": "spccod",
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
      	
          if($vew_data->spcgrpatrspc != ''){
            foreach($vew_data->spcgrpatrspc as $lv_row){ 
              $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                
                'spccod:"'.$lv_row['spccod'].'",'.
                'spcgrpatrspc:"'.$lv_row['spctxt'].'"'.
                
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
         	lv_buffer += (lv_buffer==""?"":",") + lv_dat[i].spccod;
        }
        
				$("#<?=$lv_sec;?> #spcgrpatrspc").prop("value", lv_buffer);
        
			}
    }
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
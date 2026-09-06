<?php
  // url del formulario 
  $lv_lnk = '?prg=cnsste&prm_stecod='.$vew_data->stecod;

	// campos requeridos 
	$vew_input->RequiredFields( array('stetxt','docsts','lndcod','custxt','cuscod') );

	// clave del documento 
	$lv_dockey = $vew_data->stecod; 

	// titulo 
	$lv_title = $vew_lang->constructionsite;
	
	// módulo y programa 
	$lv_mdlcod = 'CNS';
	$lv_prgcod = 'STE';
	
  // librería de estilos bootstrap 
	include_once('_library.frm');
	
	// Variable atributos para la tmsstable 
	$lv_atr = array();
	$lv_atr[] = array('atrcod'=>'PRY','atrtxt'=>$vew_lang->Project);
	$lv_atr[] = array('atrcod'=>'NCT','atrtxt'=>'Contrato');
	$lv_atr[] = array('atrcod'=>'GRF','atrtxt'=>$vew_lang->Grafo);
	$lv_atr[] = array('atrcod'=>'PEP','atrtxt'=>'PEP');
	$lv_atr[] = array('atrcod'=>'ZNA','atrtxt'=>'Zona');
	$lv_atr[] = array('atrcod'=>'SCT','atrtxt'=>'Sector');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <textarea class="hidden" id="cnssteatratr" name="cnssteatratr"></textarea>
		
    <div class="container-fluid" role="tabpanel">
      <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
          <li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->constructionsite; ?></a></li>
          <li role="presentation"><a href="#<?= $lv_sec; ?>_tab005" role="tab" data-toggle="tab"><?= $vew_lang->contact; ?></a></li>
        	<li class="pull-right"><h4># <strong><?= $vew_data->stecod; ?><?= gethtml('stecod', 'hidden', $vew_data->stecod); ?></strong></h4></li>
      </ul>
      <div class="tab-content tmss-tab-content">
        
        <!-- Obras -->
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row"> 
            <!-- Tarjeta Obras -->
          	<div class="col-md-6">
              <div class="card">
              	<div class="card-header"><div class="card-title"><?= $lv_title ?></div></div>
              	<div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->customer,
                                      'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly),
                                                          array('input'=>gethtml('custxt', 'typeahead', $vew_data->custxt, $lv_default) )) )); 
                    echo gethtml('cuscod', 'hidden', $vew_data->cuscod);
                    echo gethtml('stecodext', 'hidden', $vew_data->stecodext); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('stecodext', 'doccmt1x20', $vew_data->stecodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('stetxt', 'doccmt1x50', $vew_data->stetxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->class,'input'=>gethtml('sysdocclstxt', 'doccmt1x50', $vew_data->sysdoccls->sysdocclstxt, $lv_always_disabled) ));
                    echo gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); 
                  ?>
                </div>
              </div>
            </div>
            
            <!-- Segunda Tarjeta -->
            <div class="col-md-6">
            	<div class="card">
                <div class="card-header">
                  <div class="card-title">
                  	<?= $vew_lang->ATTRIBUTES; ?>
                  </div>
                </div>
                <div class="card-body">
                  <div id="cnssteatratrhot"></div>  
                </div>
              </div>
            </div>
          </div>
          
          <!-- DIRECCION / CONTACTO -->
          <div class="row">
            <div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
            <div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
          </div>
 				</div> 
         
        <!-- CONTACTOS -->
        <div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab005">
          <?php include('grldatcntlst.frm'); ?>
        </div>
    	
      </div> <!-- tabcontent -->
    </div> <!-- container-fluid -->   
  </form>
	<script>
    
   //Typeahead 
    var lo_get = { "fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"c.docsts":"A"}, "fldasg" : {"cuscod":"cuscod", "custxt" : "custxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #custxt"), "slscus", lo_get)  
		
		
	</script>
	<script>
    var go_<?= $lv_sec; ?>_tblctr;
    var go_<?= $lv_sec; ?>_tblcfgctr;
    var gv_<?= $lv_sec ?>_ctrdte; 
    go_<?= $lv_sec; ?>_tblcfgctr = {
      					select: false,
                readOnly: <?= ($vew_readonly?'true':'false'); ?>,
                allowAdd: false,
                headerData: [{title:"<?= $vew_lang->ATTRIBUTE; ?>", width:"50%"}, {title:"<?= $vew_lang->VALUE; ?>", width:"50%"}],
                columnsData: [
                              { id: "cnssteatratrtxt", type:"TEXT", editable: false  },{ id: "cnssteatratrval", type:"TEXT"} 
                            ]
                
    };

    gv_<?= $lv_sec ?>_ctrdte = [<?php
        $lv_buffer='';
				foreach($lv_atr as $lv_row) {
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'cnssteatratrtxt:"'.$lv_row['atrtxt'].'",'.
            						'cnssteatratrval:"'.$vew_doc->getTagValue($vew_data->cnssteatr, 'ATR_'.$lv_row['atrcod']).'",'.
            						'cnssteatratrcod:"'.$lv_row['atrcod'].
            						'"}';
				}
				echo $lv_buffer;
			?>];		
    go_<?= $lv_sec; ?>_tblctr = new tmssTable($("#<?= $lv_sec; ?> #cnssteatratrhot"), go_<?= $lv_sec; ?>_tblcfgctr);

    $(function(){
    	go_<?= $lv_sec; ?>_tblctr.loadData(gv_<?= $lv_sec; ?>_ctrdte);
    });

	</script>
  <script>
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				var lo_dat = go_<?= $lv_sec; ?>_tblctr.getData();
				var lv_dat = "";
				for (var i=0; i<lo_dat.length; i++) {
					lv_dat += "<atr_"+lo_dat[i]["cnssteatratrcod"].toLowerCase()+">"+lo_dat[i]["cnssteatratrval"]+"</atr_"+lo_dat[i]["cnssteatratrcod"].toLowerCase()+">";
				}
				$("#<?= $lv_sec; ?> #cnssteatratr").prop("value", lv_dat );
			}
		}
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
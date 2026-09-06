<?php		
	// url del formulario
  $lv_lnk = "?prg=edustu&prm_stucod=".$vew_data->stucod;

	// campos requeridos
	$lv_reqflddef = array('adrlstnme','adrfrtnme','docsts','lndcod');
	$lv_reqfldusrtxt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'sysdocclsreqfld');
	$lv_reqfldusr = ($lv_reqfldusrtxt!=''?explode(';',$lv_reqfldusrtxt):array());
	$vew_input->setReqFields( array_merge($lv_reqflddef,$lv_reqfldusr) );
	
	// clave del documento
	$lv_dockey = $vew_data->stucod; 

	// titulo
	$lv_title = $vew_lang->student;
	
	// modulo y programa
	$lv_mdlcod = 'EDU';
	$lv_prgcod = 'STU';
	
	// auto estado (se basa en las fechas)
	$lv_autostatus = (strtoupper($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'auto_status'))=='X'?true:false);	
	$lv_confirmduplicate = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'confirmDuplicate');
	if ( $vew_data->stucod=='' && $lv_autostatus ) {
		$vew_data->docsts = 'N';
	}
	
	// valores por default
	if ( $vew_data->stucod=='') {
		$lv_defvalstr = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'defval');
		eval( str_ireplace('^',chr(39),$lv_defvalstr) );
	}
	
	$lv_infbox = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'zcuinfbox');
	// librer a de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <textarea class="hidden" id="stuatrval001" name="stuatrval001"><?= html_entity_decode(htmlspecialchars_decode(strtolower($vew_data->stuatrval001),ENT_QUOTES)); ?></textarea>
    <textarea class="hidden" id="stuatrval002" name="stuatrval002"><?= html_entity_decode(htmlspecialchars_decode(strtolower($vew_data->stuatrval002),ENT_QUOTES)); ?></textarea>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
				<?php if ($vew_data->stucod!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','**') ) { ?>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab005" role="tab" data-toggle="tab"><?= $vew_lang->contact; ?></a></li>
				<?php } ?>        
				<li class="pull-right"><h4># <strong><?= $vew_data->stucod; ?><?= gethtml('stucod','hidden',$vew_data->stucod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						
            <div class="col-md-10">
							<div class="row">
								
                <div class="col-md-6">
                  <div class="card">
                    <div class="card-header">
                      <div class="card-title">
                        <?= $vew_lang->student; ?>
                        <span class="tmss-card-icon"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                        <?php 
                          echo gethtml('sysdocclstxt', 'hidden', $vew_data->sysdoccls->sysdocclstxt);
                          echo gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);
                        ?>
                      </div>
                    </div>   
                    <div class="card-body tmss-card-body-edit">
                    <?php 
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->code,			'input'=>gethtml('stucodext','doccmt1x20',$vew_data->stucodext,$lv_default) ));
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->lastname, 'input'=>gethtml('adrlstnme','adrlstnme',	$vew_data->adr->adrlstnme,$lv_default) ));
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->firstname,'input'=>gethtml('adrfrtnme','adrfrtnme',	$vew_data->adr->adrfrtnme,$lv_default) ));
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->status,   'input'=>gethtml('docsts',   'docsts',		$vew_data->docsts, $lv_default) ));
                    ?>
                    </div>
                  </div>
                </div>
                
                <div class="col-md-6">
                  <div class="card">
                    <div class="card-header">
                      <div class="card-title">
                        <?= $vew_lang->data; ?>
                        <span class="tmss-card-icon">
                          <i class="fas fa-user"></i>
                        </span>
                      </div>
                    </div>   
                    <div class="card-body tmss-card-body-edit">
                    <?php 
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->financial,
                                          'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_actcod=='01'?$vew_readonly:true)),
                                                              array('input'=>gethtml('custxt', 'custxt', $vew_data->custxt, ($vew_actcod=='01'?$lv_default:$lv_always_disabled)) )) ));
                  		echo gethtml('cuscod', 'hidden', $vew_data->cuscod);                      
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->request,  	'input'=>gethtml('stureqdte',	'docdte',	$vew_data->stureqdte,	$lv_default) ));  
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->evaluation,	'input'=>gethtml('stuevldte',	'docdte',	$vew_data->stuevldte,	$lv_default) ));  
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->inbound,  	'input'=>gethtml('stuinbdte',	'docdte',	$vew_data->stuinbdte,	$lv_default) ));  
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->outbound, 	'input'=>gethtml('stuoutdte',	'docdte',	$vew_data->stuoutdte,	$lv_default) ));  
                    ?>
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
            
            <!-- Foto y Actividades -->
						<div class="col-md-2">
							<div class="form-group tmss-form-group">
								<div class="col-md-12"><?php include('grldatuplshwpth.frm'); ?></div>
							</div>
              <?php if($lv_infbox!='') { ?>
								<hr><div class="col-md-12"><div id="zcuinfbox"></div></div>
							<?php } ?>
            </div>
                   
            <!-- Datos personales -->
            <div class="col-md-5">
              <?php include('grldatper.frm'); ?>
            </div>
												
					</div> <!-- /row -->				
				</div> <!-- tab-pane - tab001 -->
				
				<!-- IMPUESTOS / BANCOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
					<div class="row">
						<div class="col-md-6">
							<?php include('grldattax.frm'); ?>
						</div>
						<div class="col-md-6">
							<?php include('grldatbnk.frm'); ?>
						</div>
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
    // FINANCIADOR
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"cuscod":"cuscod", "custxt":"custxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #custxt"), "slscus", lo_get);
	</script>	
  <script>
    function <?= $lv_sec; ?>_showCustomerInfoBox() {
    	var lv_url = <?= ($lv_infbox==''?'':'"'.$lv_infbox.'&prm_stucod="+$("#'.$lv_sec.' #stucod").val()');?>
          
      tmssCallProcess( lv_url ,{ frmsec: "<?= $lv_sec; ?>" },
        function( data ) {
				if ( data.substring(0,10)=="/*script*/" ) { eval( data ); } else {
					$("#<?= $lv_sec; ?> #zcuinfbox").html(data);
				}
			});
    } 
		$(function(e) { <?= $lv_sec; ?>_showCustomerInfoBox(); });  
	</script>
  <!-- include del script -->
  <?php include('grldocfrmscr.frm'); ?>	
</section>
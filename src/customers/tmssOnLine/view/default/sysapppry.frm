<?php 
	// url del formulario
  $lv_lnk = '?prg=sysapppry&prm_sysappprycod='.$vew_data->sysappprycod;

	// campos requeridos
	$vew_input->RequiredFields( array('sysappprytxt', 'docsts') );

	// clave del documento
	$lv_dockey = $vew_data->sysappprycod;

	// titulo
	$lv_title = $vew_lang->projects;
	
	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'PRY';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
     <?= gethtml('tmss_actcod', 'hidden', ''); ?>
     <?= gethtml('sysappapi', 'hidden', ''); ?>
		
    <div class="container-fluid" role="tabpanel">
      
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->sysappprycod; ?><?= gethtml('sysappprycod','hidden',$vew_data->sysappprycod); ?></strong></h4></li>
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
                  <?php 
                  	  echo vew_boot($lv_col210, array('label'=>$vew_lang->code,					'input'=>gethtml('sysappprycodext', 'doccmt1x20', 	$vew_data->sysappprycodext, $lv_default) ));
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->description,	'input'=>gethtml('sysappprytxt', 		'doccmt1x50', 	$vew_data->sysappprytxt, 		$lv_default) ));
                      echo vew_boot($lv_colsm282, array('label'=>$vew_lang->Token,
                                                      'input1'=>gethtml('sysappprytkn', 'doccmt1x50', $vew_data->sysappprytkn, $lv_default),
                                                      'input2'=>vew_boot(
                                                            array('style'=>'custom', 'custom'=>'<a id="sysappprytknbtn" class="card-icon tmssHiddeOnRead "><i class="fas fa-history"></i></a>'),
                                                            array('custom'=>'<a id="sysappprytknbtn" class="card-icon tmssHiddeOnRead "><i class="fas fa-history"></i></a>'))
                                                    ));
                     	echo vew_boot($lv_col210, array('label'=>$vew_lang->source, 			'input'=>gethtml('sysappprysrctyp', 'doccmt1x50',		$vew_data->sysappprysrctyp, $lv_default) ));
                   		echo vew_boot($lv_col210, array('label'=>$vew_lang->Data, 				'input'=>gethtml('sysappprysrcdat', 'doccmt1x50',		$vew_data->sysappprysrcdat, $lv_default) ));
                  		echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 			'input'=>gethtml('docsts', 					'docsts', 			$vew_data->docsts, 					$lv_default) ));
                  ?>
                </div>
              </div>
						</div>  
            
            <!-- Apis habilitadas -->
            <div class="col-md-6">
              <div class="card tmss-hot-ttl">
                <div class="card-header">
                  <div class="card-title">
                    Apis habilitadas 
                    <a class="card-icon" id="btnDelRow"><i class="fas fa-trash-can"></i></a>
                  </div>
                </div>
                <div class="card-body">
                  <div id="sysappapitbl" name="sysappapitbl"></div>
                </div><!--body-->
              </div> <!-- /card -->
            </div> <!-- /col-md-6 -->
          </div>     
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
	</form> 
  <script>
    $("#<?= $lv_sec; ?> #sysappprytknbtn").click(function(){
      $("#<?= $lv_sec; ?> #sysappprytkn").val( ([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g, c => (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)).toUpperCase() );
    });
  </script>
  <script>
    var go_<?= $lv_sec; ?>_tblapi;
    var go_<?= $lv_sec; ?>_tblcfgapi;
    var gv_<?= $lv_sec; ?>_tbldatapi; 
    go_<?= $lv_sec; ?>_tblcfgapi = {
                readOnly: <?= ($vew_readonly?'true':'false'); ?>,
                allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
                headerData: [{title:"<?= $vew_lang->Description; ?>", width:"80%"}, {title:"<?= $vew_lang->configuration; ?>", width:"20%"}],
                columnsData: [
                              {id: "sysappapitxt", type: "typeahead", 
                               typeahead: function(values){ 
                                 return {definition: "sysappapi",
                                         data: {
                                           fldsec: "<?= $lv_sec ;?>",
                                           fldasg: {"sysappapitxt": "sysappapitxt", 
                                                    "sysappapicod": "sysappapicod"}
                                           }
                                         };
                               }
                              },
                              { id: "icn", type:"BUTTON", buttonFormat:{icon:"fas fa-layer-group"},
                                 onClick: function(){ 
                                   <?= $lv_sec; ?>_showApiConfig("@@ROW");
                                 }
                              }
                            ],
                showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}]
                };
                    
    gv_<?= $lv_sec; ?>_tbldatapi = [<?php
      $lv_buffer='';
      if($vew_data->sysapppryapi != ''){
        foreach($vew_data->sysapppryapi as $lv_row){ 
          $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                      'sysapppryapicod:"'.(isset($lv_row['sysapppryapicod']) ? $lv_row['sysapppryapicod'] : '').'",'.
                      'sysappapicod:"'.(isset($lv_row['sysappapicod']) ? $lv_row['sysappapicod'] : '').'",'.
            					'sysappapitxt: "'.(isset($lv_row['sysappapitxt']) ? $lv_row['sysappapitxt'] : '').'"'.
                			(!empty($lv_row['sysapppryapicfg']) ? ', sysapppryapicfg: '.$lv_row['sysapppryapicfg'] : '').
                      '}'; 
        }
      }
      echo $lv_buffer;
    ?>];
    
    go_<?= $lv_sec; ?>_tblapi = new tmssTable($("#<?= $lv_sec; ?> #sysappapitbl"), go_<?= $lv_sec; ?>_tblcfgapi);
    
    $(function(){
    	go_<?= $lv_sec; ?>_tblapi.loadData(gv_<?= $lv_sec; ?>_tbldatapi);
    });
    
    function <?= $lv_sec; ?>_showApiConfig(lp_row){
      var lv_rowdat = go_<?= $lv_sec; ?>_tblapi.getValuesAtRow(lp_row);
      lv_rowdat["sysapppryapicfg"] = JSON.stringify(lv_rowdat["sysapppryapicfg"]);
    	lv_rowdat["readonly"] = "<?= $vew_readonly; ?>";
      tmssCallProcess("?prg=sysapppry&act=apicfg", lv_rowdat, function(data){
        BootstrapDialog.show({
          title: "Configuraci&oacute;n de la API (" + lv_rowdat['sysappapitxt']+")",
          message: $(data),
          draggable: true,
          closable: <?= ($vew_readonly ? 'true' : 'false') ?>,
          size: BootstrapDialog.SIZE_WIDE,
          buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialogItself){ dialogItself.close(); } }
                    <?php if(!$vew_readonly){ ?>  
                      ,
                      {	id:"btn-accept", label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success",	action: function(dialog){
                        let lv_ret = eval( dialog.$modalBody.find("section").attr("id") + "_getData()" );
                                                                              
                        var lv_dat = lv_ret.data;

                        go_<?= $lv_sec; ?>_tblapi.setValueAtRowProp(lp_row, "sysapppryapicfg", lv_dat);
                        dialog.close();
                      }
                    } 
                  <?php } ?>
                      ],
        	onshown: function(dialog){
        		let secID = dialog.$modalBody.find("section").attr("id"); 
      		},
        });
      }); 
    }
  </script>
  <script>
    // form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      // al grabar
      if ( lp_prm["action"]=="00" ) {
        
        var lv_dat = go_<?= $lv_sec; ?>_tblapi.getData();
        var lv_del = go_<?= $lv_sec; ?>_tblapi.getDeleted();

        // agrega filas eliminadas
        for (var i=0; i < lv_del.length; i++) {
          lv_dat.push({"sysapppryapicod":lv_del[i]["sysapppryapicod"],
                        "deleted":"X"
                      });
        }

        // verifico que no haya configuraciones repetidas
        for (var i=0; i < lv_dat.length - 1; i++) { 
          for (var j=1; j < lv_dat.length; j++) {
            if(lv_dat[i]["sysappapicod"] == lv_dat[j]["sysappapicod"] && i!=j){
              toastr.warning("Revise que no haya APIs repetidas en su proyecto.");
              return false;
            }
          }
        }
        
        if (lv_dat.length==0) {
          $("#<?= $lv_sec; ?> #sysappapi").prop("value", "");
        } else {
          $("#<?= $lv_sec; ?> #sysappapi").prop("value", JSON.stringify( lv_dat ) );
        } 
      }
    } 
  </script>
  <!-- Form Submit -->
	<?php include('grldocfrmscr.frm'); ?>
</section>
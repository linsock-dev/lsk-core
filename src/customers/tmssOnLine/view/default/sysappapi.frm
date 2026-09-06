<?php
	// url del formulario 
  $lv_lnk = '?prg=sysappapi&prm_sysappapicod='.$vew_data->sysappapicod;

	// campos requeridos 
	$vew_input->RequiredFields( array('sysappapitxt', 'docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->sysappapicod;

	// titulo 
	$lv_title = $vew_lang->APIS;
	
	// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'API';
	
	// librería de estilos bootstrap  
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?php echo gethtml('tmss_actcod', 'hidden', ''); ?>
		<?php echo gethtml('sysappapimap', 'hidden', ''); ?>
     		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->sysappapicod; ?><?= gethtml('sysappapicod', 'hidden', $vew_data->sysappapicod); ?></strong></h4></li>
			</ul>
      
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-5">
              <div class="card">
              	<div class="card-header">
                	<div class="card-title"><?= $lv_title; ?></div>
								</div>
								<div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('sysappapicodext', 'doccmt1x30', 	$vew_data->sysappapicodext, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('sysappapitxt', 		'doccmt1x50', 	$vew_data->sysappapitxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->version, 		'input'=>gethtml('sysappapiver', 		'docnum0600', 	$vew_data->sysappapiver, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 			'input'=>gethtml('sysappapiurl','doccmt1x20', $vew_data->sysappapiurl, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->comments, 	'input'=>gethtml('sysappapicmt', 		'doccmt5x50',		$vew_data->sysappapicmt, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 					'docsts', 			$vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>

						</div>
            <div class="col-md-7">

              <div class="card tmss-hot-ttl">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->parameters ?>
                    <a class="card-icon" id="btnDelRow"><i class="fas fa-trash-can"></i></a>
                  </div>
                </div>
                <div class="card-body">
                  <div id="appapitbl" name="appapitbl"></div>
                </div>
              </div>
							
          	</div>
					</div>
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <script>
    var go_<?= $lv_sec; ?>_tblmap;
    var go_<?= $lv_sec; ?>_tblcfgmap;
    var gv_<?= $lv_sec; ?>_tbldatmap; 
    go_<?= $lv_sec; ?>_tblcfgmap = {
                readOnly: <?= ($vew_readonly?'true':'false'); ?>,
                allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
                headerData: [{title:"<?= $vew_lang->ApiMethod; ?>", width:"15%"}, {title:"<?= $vew_lang->Variant; ?>", width:"20%"},  {title:"ID", width:"20%"}, {title:"<?= $vew_lang->Model; ?>", width:"20%"}, {title:"<?= $vew_lang->ModelMethod; ?>", width:"15%"}, {title:"<?= $vew_lang->Mapings; ?>", width:"10%"}],
                columnsData: [
                              { id: "sysappapimapmth", type:"TEXT" },
                              { id: "sysappapimapvar", type:"TEXT" },
                              { id: "sysappapimapfldcod", type:"TEXT" },
                              { id: "sysappapimapmdl", type:"TEXT" },
                              { id: "sysappapimapmdlmth", type:"TEXT" },
                              { id: "icn", type:"BUTTON", buttonFormat:{icon:"fas fa-layer-group"},
                                 onClick: function(){ 
                                   <?= $lv_sec; ?>_showFldMap("@@ROW");
                                 }
                              }
                            ],
                showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}],
    };
                    
    gv_<?= $lv_sec; ?>_tbldatmap = [<?php
          $lv_buffer='';
          if($vew_data->apimap != ''){
            foreach($vew_data->apimap as $lv_row){ 
              $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                          'sysappapimapcod:"'.(isset($lv_row['sysappapimapcod']) ? $lv_row['sysappapimapcod'] : '').'",'.
                          'sysappapimapmth:"'.(isset($lv_row['sysappapimapmth']) ? $lv_row['sysappapimapmth'] : '').'" ,'.
                          'sysappapimapvar: "'.(isset($lv_row['sysappapimapvar']) ? $lv_row['sysappapimapvar'] : '').'" ,'.
                          'sysappapimapfldcod: "'.(isset($lv_row['sysappapimapfldcod']) ? $lv_row['sysappapimapfldcod'] : '').'" ,'.
                          'sysappapimapmdl: "'.(isset($lv_row['sysappapimapmdl']) ? $lv_row['sysappapimapmdl'] : '').'" ,'.
                          'sysappapimapmdlmth: "'.(isset($lv_row['sysappapimapmdlmth']) ? $lv_row['sysappapimapmdlmth'] : '').'"'.
                					(!empty($lv_row['sysappapimapfldmap']) ? ', sysappapimapfldmap: `'.json_encode($lv_row['sysappapimapfldmap']).'`' : '').
                          '}'; 
            }
          }
          echo $lv_buffer;
			?>];
    
    go_<?= $lv_sec; ?>_tblmap = new tmssTable($("#<?= $lv_sec; ?> #appapitbl"), go_<?= $lv_sec; ?>_tblcfgmap);
    
    
    function <?= $lv_sec; ?>_showFldMap(lp_row){
      var lv_rowdat = go_<?= $lv_sec; ?>_tblmap.getValuesAtRow(lp_row);

    	lv_rowdat['readonly'] = <?= ($vew_readonly ? 'true' : 'false') ?>;
      lv_rowdat['sysappapimapfldmap'] = lv_rowdat['sysappapimapfldmap'];
      lv_rowdat['showtech'] = true;
      tmssCallProcess("?prg=sysappapi&act=fldmap", lv_rowdat, function(data){
        BootstrapDialog.show({
          title: "Mapeo de campos",
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

                        go_<?= $lv_sec; ?>_tblmap.setValueAtRowProp(lp_row, "sysappapimapfldmap", lv_dat);
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
    
    $(function(){
    	go_<?= $lv_sec; ?>_tblmap.loadData(gv_<?= $lv_sec; ?>_tbldatmap);
    });
  </script>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
      // al grabar
			if ( lp_prm["action"]=="00" ) {
				var lv_dat = go_<?= $lv_sec; ?>_tblmap.getData();
        var lv_del = go_<?= $lv_sec; ?>_tblmap.getDeleted();
        
        // agrega filas eliminadas
        for (var i=0; i < lv_del.length; i++) {
          lv_dat.push({"sysappapimapcod":lv_del[i]["sysappapimapcod"],
												"deleted":"X"
											});
        }
        
        if (lv_dat.length==0) {
					$("#<?= $lv_sec; ?> #sysappapimap").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #sysappapimap").prop("value", JSON.stringify( lv_dat ) );
				}
        
			}
    }
  </script>
   <!-- Form Submit -->
	<?php include('grldocfrmscr.frm'); ?>
</section>
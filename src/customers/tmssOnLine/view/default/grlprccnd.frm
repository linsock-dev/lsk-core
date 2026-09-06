<?php
	// url del formulario
  $lv_lnk = '?prg=grlprccnd';

	// campos requeridos
	$vew_input->RequiredFields( array('prccndtxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->prccndcod; 

	// titulo
	$lv_title = $vew_lang->conditions;
	
	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'PCD';

	// libreria de estilos bootstrap
	include_once('_library.frm');	

	//config. botones
	$vew_tbl['modL'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
	$vew_tbl['modR'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
	$vew_tbl['del'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
	$vew_tbl['delsep'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
    <?= gethtml('prccndaccseq', 'hidden', ''); ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->prccndcod; ?><?= gethtml('prccndcod', 'hidden', $vew_data->prccndcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
			
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->condition; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,  			'input'=>gethtml('prccndcodext', 'doccmt1x20', $vew_data->prccndcodext, $lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('prccndtxt', 'doccmt1x50', $vew_data->prccndtxt, $lv_default) )); 
                    echo vew_boot($lv_col210, array("label"=>$vew_lang->category, 	'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly,$lv_default), array('input'=>gethtml('prccndcattxt', 'typeahead', $vew_data->prccndcattxt,$lv_default)))));
                    echo gethtml('prccndcatcod','hidden',$vew_data->prccndcatcod);
                    echo vew_boot($lv_col210, array("label"=>$vew_lang->type, 			'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('fintaxtyptxt', 'typeahead', $vew_data->fintaxtyptxt,$vew_data->fintaxtyptxt==''?$lv_default:$lv_always_disabled) )) ));
                    echo gethtml('fintaxtypcod','hidden',$vew_data->fintaxtypcod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); 
                  ?>
                </div>
              </div>
						</div>
						<div class="col-md-6">
              <div class="card tmss-card-hot">
                <div class="card-header"><div class="card-title"><?= $vew_lang->access; ?><a class="card-icon" id="btnDelRow"><i class="fas fa-trash-can"></i></a></div></div>
                <div class="card-body">
                  <div id="prccndacchot"></div>
                </div>
              </div>
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->modules; ?></div></div>
                <div class="card-body tmss-card-body-edt" id="mdldiv" style="max-height: 150px; overflow-y: scroll;">
									<?php
										$lv_mdlstr = ';'.$vew_doc->gettagvalue($vew_data->prccndatr,'mdlcod').';';
										foreach($vew_data->mdl as $lv_row){
											if( ($vew_readonly && stripos($lv_mdlstr,';'.$lv_row['mdlcod'].';')!==false ) || !$vew_readonly ){ 
												echo vew_boot($lv_col66, array('label'=>$vew_lang->get( $lv_row['mdltxt'] ).' ('.$lv_row['mdlcod'].')','input'=>gethtml('prccndatrmdl_'.$lv_row['mdlcod'],'checkbox', (stripos($lv_mdlstr,';'.$lv_row['mdlcod'].';')!==false ? true : false ),$lv_default) ));
											}
										}
									?>
									<?= gethtml('prccndatrmdlcod','hidden',$vew_doc->gettagvalue($vew_data->prccndatr,'mdlcod')); ?>
                </div>
              </div>
						</div><!-- /col-md-6 -->
					</div><!-- /row -->
				</div> <!-- /_tab001 -->
				
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
    
  </form>
	<script>
    var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldflt": {"t.docsts":"A"}, "fldasg":{"fintaxtyptxt":"fintaxtyptxt", "fintaxtypcod":"fintaxtypcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #fintaxtyptxt"), "fintaxtyp", lo_get);
    
    var lo_get = {"fldsec": "<?= $lv_sec; ?>", "fldflt": {"docsts":"A"}, "fldasg":{"prccndcatcod":"prccndcatcod", "prccndcattxt":"prccndcattxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #prccndcattxt"), "grlprccndcat", lo_get);
      
		$("#fintaxtyptxt").prop( "disabled", true );
		$( "#prccndcat" ).change(function() {
			if ($("#prccndcat").val() == "T") {
				$("#fintaxtyptxt").prop( "disabled", false );
			} else {
				$("#fintaxtyptxt").prop( "disabled", true );
			}
		});
	</script>
	<script>
    /**
		 *
		 *	A C C E S O S
		 *
		 */
    
    var gv_<?= $lv_sec; ?>_acccfg = {
      readOnly: "<?= $vew_readonly?>",
      headerData: [{title: "Orden", width: "10%"}, {title: "<?= $vew_lang->access; ?>", width:"70%"}],
      columnsData: [{id: "prccndaccseqord", type: "number"},
                   {id: "prccndacctxt", type: "typeahead", 
                    typeahead: function(values){
                      return {definition: "grlprccndacc",
                              data: {fldsec:"<?= $lv_sec; ?>",
                                    fldasg: {"prccndacctxt":"prccndacctxt",
                                            "prccndacccod":"prccndacccod"}
                                    }
                             };
                    }
                   }],
      showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}]
    };
    
    var gv_<?= $lv_sec; ?>_accdat = [<?php
      $lv_buffer='';
      
      if($vew_data->prccndaccseq != ''){
        foreach($vew_data->prccndaccseq as $lv_row){ 
          $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
            'prccndaccseqcod:"'.$lv_row['prccndaccseqcod'].'",'.
            'prccndaccseqord:"'.$lv_row['prccndaccseqord'].'",'.
            'prccndacccod:"'.$lv_row['prccndacccod'].'",'.
            'prccndacctxt:"'.$lv_row['prccndacctxt'].'",'.
            '}'; 
        }
      }
      echo $lv_buffer;
    ?>];
    
    // instancio tabla
    var go_<?= $lv_sec; ?>_acctbl = new tmssTable($("#<?= $lv_sec; ?> #prccndacchot"), gv_<?= $lv_sec; ?>_acccfg);
    // cargo datos
    go_<?= $lv_sec; ?>_acctbl.loadData(gv_<?= $lv_sec; ?>_accdat);
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if(lp_prm["action"]=="00"){ 
        
        var lv_dat = go_<?= $lv_sec; ?>_acctbl.getData();
				var lv_arr = new Array();
        var lv_del = go_<?= $lv_sec; ?>_acctbl.getDeleted();
        for(let i=0; i < lv_dat.length; i++){
        	if(lv_dat[i]["prccndacccod"] != ""){
            lv_arr.push(lv_dat[i]);
          }
        }
        
        for(let i=0; i < lv_del.length; i++){
          if(lv_del[i]["prccndaccseqcod"]){
            lv_arr.push({"prccndaccseqcod": lv_del[i]["prccndaccseqcod"],
                        "prccndacccod": lv_del[i]["prccndacccod"],
                        "deleted": "X"});
        	}
        }
        
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #prccndaccseq").val("");						
				} else {
					$("#<?= $lv_sec; ?> #prccndaccseq").val( JSON.stringify( lv_arr ) );
				}
        
				// modulos habilitados
				var lv_mdlstr = "";
				$("#<?= $lv_sec; ?> #mdldiv input").each(function(){
					lv_mdlstr += ( $(this).is(":checked") ? (lv_mdlstr==""?"":";") + $(this).prop("id").substr(-3)  : "" );
				});
				$("#<?= $lv_sec; ?> #prccndatrmdlcod").val( lv_mdlstr );
      }
      return true;
    }
    
    function <?= $lv_sec; ?>_formeditext( lp_prm ) { 
      tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>, $("#<?= $lv_sec; ?> #prccndacchot input"));
    }
  </script>
  
  <?php include('grldocfrmscr.frm'); ?>
</section>
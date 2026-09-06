<?php
	/* url del formulario */
  $lv_lnk = '?prg=syssecdrtgrp&prm_syssecdrtgrpcod='.$vew_data->syssecdrtgrpcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('syssecdrtgrptxt','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->syssecdrtgrpcod;

	/* titulo */
	$lv_title = $vew_lang->directiveGroup;

	/* m�dulo y programa */
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'DRG';

	/* librer�a de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!--navbar-->
  <?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
    <?= gethtml('syssecdrtgrptyp', 'hidden', ''); ?>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->syssecdrtgrpcod; ?><?= gethtml('syssecdrtgrpcod', 'hidden', $vew_data->syssecdrtgrpcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
        <div class="row">
          <!--Grupo-->
          <div class="col-md-6">
            <div class="card">
              <div class="card-header">
                <div class="card-title">
                  <?= $vew_lang->directiveGroup; ?>
									<span class="tmss-card-icon"><i class="fas fa-layer-group"></i></span>
                </div>
              </div><!--header-->
              
              <!-- Modo lectura -->
              <div class="card-body tmss-card-body-edit">
                <?php
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('syssecdrtgrpcodext','doccmt1x20', $vew_data->syssecdrtgrpcodext, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('syssecdrtgrptxt', 'doccmt1x50', $vew_data->syssecdrtgrptxt, $lv_default) ));
							    echo vew_boot($lv_col210, array('label'=>$vew_lang->system, 		'input'=>gethtml('syssecdrtgrpsys', 'checkbox', ($vew_data->syssecdrtgrpsys== 1 ? 'on' : 'off'), $lv_default) ));
                 	echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                ?>
              </div><!--body-->
            </div><!-- card -->
          </div><!--col-->

          <!--Directivas-->
          <div class="col-md-6">
            <div class="card tmss-hot-ttl">
              <div class="card-header">
                <div class="card-title">
                  <?= $vew_lang->directives; ?>
                  <a class="card-icon" id="btnDrtDct" title="<?= $vew_lang->directives; ?>"><i class="fas fa-book"></i></a>
                  <a class="card-icon" id="btnDelRow"><i class="fas fa-trash"></i></a>
                </div>
              </div><!--header-->
              <div class="card-body">
                <div id="drttyptbl"></div>
              </div><!--body-->
            </div><!-- card -->
          </div><!--col-->
        </div>
      </div>
    </div>
  </form>
  <script>
    // diccionario de directivas
    $("#<?= $lv_sec; ?> #btnDrtDct").click(function(){
      tmssPopup("<?= $vew_lang->directives; ?>", "?prg=syssecdrttyp&prm_vewcod=VEW_SYS_SEC_DRT_TYP_LST&prm_popup=sysdochdr_popup&prm_fldsec="+<?= $lv_sec ?>+"&prm_fldflt=[dt.docsts:A]");
    })
  </script>
  <script>
    var go_<?= $lv_sec; ?>_tbltyp;
    var go_<?= $lv_sec; ?>_tblcfg;
    var gv_<?= $lv_sec; ?>_tbldat; 
    go_<?= $lv_sec; ?>_tblcfg = {
                readOnly: <?= ($vew_readonly?'true':'false'); ?>,
                allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
                headerData: [{title:"<?= $vew_lang->directive; ?>", width:"60%"}, {title:"<?= $vew_lang->value; ?>", width:"35%"}],
                columnsData: [
                              {id: "syssecdrttyptxt", type: "typeahead", 
                               typeahead: function(values){ 
                                 return {definition: "syssecdrttyp",
                                         data: {
                                           fldsec: "<?= $lv_sec ;?>",
                                           fldasg: {"syssecdrttyptxt": "syssecdrttyptxt", 
                                                    "syssecdrttypcod": "syssecdrttypcod",
                                                   	"syssecdrttyptyp": "syssecdrttyptyp",
                                                   	"syssecdrtgrptypdefval": "syssecdrttypdef"}
                                           }
                                         };
                               }
                              },
                              {id: "syssecdrtgrptypdefval", type: "text"}
                            ],
                showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}]
                };
                    
    gv_<?= $lv_sec; ?>_tbldat = [<?php
          $lv_buffer='';
          if($vew_data->syssecdrtgrptyp != ''){
            foreach($vew_data->syssecdrtgrptyp as $lv_row){ 
              $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                          'syssecdrtgrptypcod:"'.$lv_row['syssecdrtgrptypcod'].'",'.
                          'syssecdrttypcod:"'.$lv_row['syssecdrttypcod'].'",'.
                          'syssecdrttyptxt:"'.$lv_row['syssecdrttyptxt'].'",'.
                          'syssecdrttyptyp:"'.$lv_row['syssecdrttyptyp'].'",'.
                          'syssecdrtgrptypdefval:"'.$lv_row['syssecdrtgrptypdefval'].'",'.
                          '}'; 
            }
          }
          echo $lv_buffer;
			?>];
    
    go_<?= $lv_sec; ?>_tbltyp = new tmssTable($("#<?= $lv_sec; ?> #drttyptbl"), go_<?= $lv_sec; ?>_tblcfg);
    go_<?= $lv_sec; ?>_tbltyp.loadData(gv_<?= $lv_sec; ?>_tbldat);
  </script>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
      // al grabar
			if ( lp_prm["action"]=="00" ) {
				var lv_dat = go_<?= $lv_sec; ?>_tbltyp.getData();
        var lv_del = go_<?= $lv_sec; ?>_tbltyp.getDeleted();
        
        // Verifica que no haya directivas repetidas en la tabla
        for (var i=0; i < lv_dat.length; i++) {
          for (var j=0; j < lv_dat.length; j++) {
						if(lv_dat[i]["syssecdrttypcod"] == lv_dat[j]["syssecdrttypcod"] && i!=j){
              toastr.warning("Existen directivas repetidas.");
              return false;
            }
          }
        }
        
        // agrega filas eliminadas
        for (var i=0; i < lv_del.length; i++) {
          lv_dat.push({"syssecdrtgrptypcod":lv_del[i]["syssecdrtgrptypcod"],
												"deleted":"X"
											});
        }
        
        $("#<?= $lv_sec; ?> #syssecdrtgrptyp").prop("value", JSON.stringify( lv_dat ) );
			}
      
      $("#<?= $lv_sec; ?> #syssecdrtgrpsys").prop("value", $("#<?= $lv_sec; ?> #syssecdrtgrpsys").prop("value").toLowerCase() == "on" ? 1 : 0 );
    }
    
    
    function <?= $lv_sec; ?>_formeditext( lp_prm ) { 
      tmssFormEdit("<?= $lv_sec; ?>", <?= ($vew_actcod=='01'|| $vew_actcod=='02'?'true':'false'); ?>, $("#<?= $lv_sec; ?> #drttyptbl input"));
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
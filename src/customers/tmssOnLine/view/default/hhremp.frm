<?php
	// url del formulario
  $lv_lnk = "?prg=hhremp&prm_hhrempcod=".$vew_data->hhrempcod; 

	/* campos requeridos */
	$lv_reqflddef = array('hhremptxt','docsts','lndcod');
	$lv_reqfldusrtxt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'sysdocclsreqfld');
	$lv_reqfldusr = ($lv_reqfldusrtxt!=''?explode(';',$lv_reqfldusrtxt):array());
	$vew_input->setReqFields( array_merge($lv_reqflddef,$lv_reqfldusr) );

	// clave del documento
	$lv_dockey = $vew_data->hhrempcod; 

	// titulo
	$lv_title = $vew_lang->employee;
	
	// modulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'EMP';

	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
				<?php if ($vew_data->hhrempcod!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','**') ) { ?>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab005" role="tab" data-toggle="tab"><?= $vew_lang->contact; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab006" role="tab" data-toggle="tab"><?= $vew_lang->profile; ?></a></li>
				<?php } ?>
				<li class="pull-right"><h4># <strong><?= $vew_data->hhrempcod; ?><input type="hidden" id="hhrempcod" name="hhrempcod" value="<?= $vew_data->hhrempcod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-5">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $lv_title; ?>
                    <span class="tmss-card-icon">
                      <?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?>
                      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
                    </span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,		'input'=>gethtml('hhrempcodext','doccod', $vew_data->hhrempcodext,$lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->name,   'input'=>gethtml('hhremptxt',   'doccmt1x50',    $vew_data->hhremptxt,$lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->inbound,'input'=>gethtml('hhrempinbdte','docdte', $vew_data->hhrempinbdte,$lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->outbound,'input'=>gethtml('hhrempoutdte','docdte', $vew_data->hhrempoutdte,$lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts',   'docsts', 	 $vew_data->docsts,$lv_default) )); 
                  ?>
                </div>
              </div>
						</div>
						<div class="col-md-5">
							<?php include('grldatper.frm'); ?>
						</div>
						<div class="col-md-2">
              <?php if($vew_actcod != '01'){?>
                <div class="card">
                  <div class="card-header">
                      <div class="form-group tmss-form-group">
                      <div class="col-xs-12"><?php include('grldatuplshwpth.frm'); ?></div> 
                    </div>
                  </div>
                  <div class="card-body tmss-card-body-edit">
                    <a href="#" id="btntme" class="card-opt-body text-left <?= ($vew_sec->hasPermission($lv_mdlcod, $lv_prgcod, '02')?'':'disabled'); ?>"><i class="far fa-clock"></i> <?= $vew_lang->schedule; ?></a>
                  </div>
                </div>
              <?php } ?>						
						</div>						 
					</div>					
					<!-- DIRECCION / CONTACTO --> 
					<div class="row">
						<div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
						<div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
					</div>
				</div> <!-- fin tab001 -->
				
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

				<!-- PERFIL -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab006">
          <div class="row">
            <div class="col-md-6">
              <div class="card">
                <div class="card-header"> 
                  <div class="card-title">
                    <?= $vew_lang->data; ?> 
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <div id="hhrempprfhot" name="hhrempprfhot"></div>
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->contacthours,'input'=>gethtml('hhrempcnthrs','doccmt1x50',$vew_data->hhrempcnthrs,$lv_default) )); 						
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->nik,         'input'=>gethtml('hhrempniknme','doccmt1x50',$vew_data->hhrempniknme,$lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->borndate,    'input'=>gethtml('hhrempbrndte','docdte', 	 $vew_data->hhrempbrndte,$lv_default) ));  
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->nationality, 'input'=>gethtml('hhrempnat',   'adrnat', 	 $vew_data->hhrempnat,$lv_default) )); 
                  ?>	
                </div>
              </div>
            </div>
            <div class="col-md-6">
              <div class="card">
                <div class="card-header"> 
                  <div class="card-title">
                    <?= $vew_lang->profile; ?> 
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                      echo vew_boot($lv_col210, array("label"=>$vew_lang->titlegrantedby,"input"=>gethtml("hhrempttl","doccmt1x40",$vew_data->hhrempttl,$lv_default) ));
                      echo vew_boot($lv_col210, array("label"=>$vew_lang->otherstudies,  "input"=>gethtml("hhrempothstd","doccmt80x4",$vew_data->hhrempothstd,$lv_default) ));
                      echo vew_boot($lv_col210, array("label"=>$vew_lang->jobhistory,    "input"=>gethtml("hhrempjobhst","doccmt80x4",$vew_data->hhrempjobhst,$lv_default) ));
                      echo vew_boot($lv_col210, array("label"=>$vew_lang->comments,      "input"=>gethtml("hhrempcmt","doccmt80x4",$vew_data->hhrempcmt,$lv_default) ));
                  ?>
                </div>
              </div>
            </div>
          </div>
				</div>

			</div> <!-- tabcontent -->    
		</div> <!-- container-fluid -->
  </form>
  <script>
		$(function(e){
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab006']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
		});
		
		// HORARIOS
		$("#<?= $lv_sec; ?> #btntme").on("click",function(e){ e.preventDefault();
			var lv_pstdat = [{name:"hhrempcod", value:"<?= $vew_data->hhrempcod; ?>"}];
			tmssCallProcess("?prg=hhremptme&act=03",lv_pstdat,function(data){
				BootstrapDialog.show({
					size: BootstrapDialog.SIZE_WIDE,
					title: "<?= $vew_lang->schedule; ?>",
					closable: false,
					draggable: true,
					message: $(data),
					buttons: [{ label: "Cerrar", cssClass: "btn-default", action: function(dialogRef){ dialogRef.close(); } }]
				});
			});
		});		
	</script>
  <script>
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adrwebpge")) ) { return false; }
			}
		}		
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
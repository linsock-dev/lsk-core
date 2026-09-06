<?php
	// url del formulario 
  $lv_lnk = "?prg=spttch&prm_tchcod=".$vew_data->tchcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('tchtxt','docsts', 'adrstr', 'adrstrnum', 'adrzon', 'adrcty', 'adrtwntxt', 'adrpstcod', 'lndtxt', 'lndregtxt') );

	// clave del documento 
	$lv_dockey = $vew_data->tchcod; 

	// titulo 
	$lv_title = $vew_lang->teacher;
	
	// módulo y programa 
	$lv_mdlcod = 'SPT';
	$lv_prgcod = 'TCH';

	// libreria de estilos bootstrap
  include_once('_library.frm');
?>
	<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!-- Nav-Bar -->
  <?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
    <div class="container-fluid" role="tabpanel">
       <!-- Solapa -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
				<?php if ($vew_data->tchcod!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','**') ) { ?>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab005" role="tab" data-toggle="tab"><?= $vew_lang->contact; ?></a></li>
				<?php } ?>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab006" role="tab" data-toggle="tab"><?= $vew_lang->profile; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->tchcod; ?><?= gethtml('tchcod','hidden',$vew_data->tchcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
            	<div class="card">
            		<div class="card-header">
            		 <div class="card-title">
             			 <?= $vew_lang->teachers; ?>
                    <span class="tmss-card-icon">  
                  		<span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                  	</span>
                   	<?= gethtml('sysdocclstxt','hidden',$vew_data->sysdoccls->sysdocclstxt); ?>
                   	<?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
            		 </div>
           			</div>
								<div class="card-body tmss-card-body-edit">
									<?php
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code,'input'=>gethtml('tchcodext','doccod', $vew_data->tchcodext,$lv_default) )); 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->name,'input'=>gethtml('tchtxt','doccmt1x50',$vew_data->tchtxt,$lv_default) )); 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->status,'input'=>gethtml('docsts','docsts',$vew_data->docsts,$lv_default) )); 
									?>
								</div>
              </div>
            </div>
						<div class="col-md-6">
              <div class="card">
            		<div class="card-header">
            		 <div class="card-title">
             			 <?= $vew_lang->days; ?>
            		 </div>
           			</div>
								<div class="card-body tmss-card-body-edit">
									<?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->dateentrance,'input'=>gethtml('tchinbdte','docdte', $vew_data->tchinbdte,$lv_default) )); 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->datedebit,'input'=>gethtml('tchoutdte','docdte', $vew_data->tchoutdte,$lv_default) )); 
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
          <!--Actividades-->
          <div class="col-md-6">
            <div class="card tmss-hot-ttl">
              <div class="card-header">
                <div class="card-title">
                  <?= $vew_lang->activities; ?>
                  <a class="card-icon" id="btnDelRow"><i class="fas fa-trash"></i></a>
                </div>
              </div>
              <div class="card-body">
                <textarea class="hidden" id="spttchact" name="spttchact"></textarea>
                <div id="tchacttbl"></div>
              </div>
            </div>
          </div><!--col-->
         
					<div class="col-md-6">
            <div class="card">
            	<div class="card-header">
            		 <div class="card-title">
             			 <?= $vew_lang->comments; ?>
            		 </div>
           		</div>
							<div class="card-body tmss-card-body-edit">
                <?php
                  echo vew_boot($lv_col210, array("label"=>$vew_lang->comments,"input"=>gethtml("tchcmt","doccmt80x4",$vew_data->tchcmt,$lv_default) ));
                ?>
              </div>
            </div>
          </div>
        </div>
			</div> <!-- tabcontent -->    
		</div> <!-- container-fluid -->
  </form>
  <script> 
  	//ACTIVIDADES TMSSTABLE
  	var go_<?= $lv_sec; ?>_tbltyp;
    var go_<?= $lv_sec; ?>_tblcfg;
    var gv_<?= $lv_sec; ?>_tbldat;
    go_<?= $lv_sec; ?>_tblcfg = {
                readOnly: <?= ($vew_readonly?'true':'false'); ?>,
                allowAdd: <?= ($vew_readonly?'false':'true'); ?>,
                headerData: [{title:"<?= $vew_lang->activities; ?>", width:"95%"}],
                columnsData: [
                              {id: "acttxt", type: "typeahead", 
                               typeahead: function(values){ 
                                 return {definition: "sptact", //modelo que queremos acceder los datos
                                         data: {
                                           fldsec: "<?= $lv_sec ;?>", // token de seguridad
                                           fldasg: {"acttxt": "acttxt", //filtro
                                                    "actcod": "actcod"}
                                           }
                                         };
                               }
                              }
                            ],
                showOnSelect: [{object: $("#<?= $lv_sec; ?> #btnDelRow"), actionType: "delete"}]
              };
    
    gv_<?= $lv_sec; ?>_tbldat = [<?php
          $lv_buffer='';
          if($vew_data->spttchact != ''){
            foreach($vew_data->spttchact as $lv_row){ 
              $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                          'tchactcod:"'.$lv_row['tchactcod'].'",'.
                          'actcod:"'.$lv_row['actcod'].'",'.
                          'acttxt:"'.$lv_row['acttxt'].'",'.
                          '}'; 
            }
          }
          echo $lv_buffer;
			?>];
    
    go_<?= $lv_sec; ?>_tbltyp = new tmssTable($("#<?= $lv_sec; ?> #tchacttbl"), go_<?= $lv_sec; ?>_tblcfg);
    $(function(){
    	go_<?= $lv_sec; ?>_tbltyp.loadData(gv_<?= $lv_sec; ?>_tbldat);
    });
	</script>
    <script>
		$(function(e){
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab006']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
		});
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
      // al grabar
			if ( lp_prm["action"]=="00" ) {
        var lv_dat = go_<?= $lv_sec; ?>_tbltyp.getData();
        var lv_del = go_<?= $lv_sec; ?>_tbltyp.getDeleted();
        
        for (var i=0; i < lv_dat.length; i++) {
          for (var j=0; j < lv_dat.length; j++) {
						if(lv_dat[i]["acttxt"] == lv_dat[j]["acttxt"] && i!=j){
              toastr.warning("Existen directivas repetidas.");
              return false;
            }
          }
          if(lv_dat[i]["acttxt"]=="" || lv_dat[i]["acttxt"]==undefined){
              toastr.warning("Existen directivas vacias.");
              return false;
          }
        }
        
        // agrega filas eliminadas
        for (var i=0; i < lv_del.length; i++) {
          lv_dat.push({"tchactcod":lv_del[i]["tchactcod"],
												"deleted":"X"
											});
        }
        if (lv_dat.length==0) {
					$("#<?= $lv_sec; ?> #spttchact").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #spttchact").prop("value", JSON.stringify( lv_dat ) );
				}
			}
    }
    
  </script>  
  <?php include('grldocfrmscr.frm'); ?>
</section>
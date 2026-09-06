<?php		
	// url del formulario
  $lv_lnk = '?prg=edutch&prm_tchcod='.$vew_data->tchcod;

	// campos requeridos
	$vew_input->RequiredFields( array('tchtxt','docsts','tchprf') );

	// clave del documento
	$lv_dockey = $vew_data->tchcod; 

	// titulo 
	$lv_title = $vew_lang->teacher;
	
	// modulo y programa
	$lv_mdlcod = 'EDU';
	$lv_prgcod = 'TCH';
	
	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>  
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
		<textarea class="hidden" id="tchprf" name="tchprf"></textarea> 

    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
				<?php if ($vew_data->tchcod!='' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod.'C','**') ) { ?>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab005" role="tab" data-toggle="tab"><?= $vew_lang->contact; ?></a></li>
				<?php } ?>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab006" role="tab" data-toggle="tab"><?= $vew_lang->profile; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->tchcod; ?><?= gethtml('tchcod', 'hidden', $vew_data->tchcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<!-- Profesores -->
						<div class="col-md-5"> 
						
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->teacher; ?>
                    <span class="tmss-card-icon">
                      <span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
										</span>
                    <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,			'input'=>gethtml('tchcodext','doccmt1x20', $vew_data->tchcodext,$lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->name,   	'input'=>gethtml('tchtxt',   'doccmt1x50',    $vew_data->tchtxt,$lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->inbound,	'input'=>gethtml('tchinbdte','docdte', $vew_data->tchinbdte,$lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->outbound,	'input'=>gethtml('tchoutdte','docdte', $vew_data->tchoutdte,$lv_default) )); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 	'input'=>gethtml('docsts',   'docsts', 	 $vew_data->docsts,$lv_default) )); 
                  ?>
                </div>
							</div> <!-- /card -->
						
						</div>
            
            <!-- DATOS PERSONALES --> 
						<div class="col-md-5"><?php include('grldatper.frm'); ?></div>
						
						<!-- Foto -->
						<div class="col-md-2">
							<div class="form-group tmss-form-group">
								<div class="col-xs-12"><?php include('grldatuplshwpth.frm'); ?></div>
							</div>
						</div>
						
					</div><!-- /row -->			
					
					<!-- DIRECCION / CONTACTO --> 
					<div class="row">
						<div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
						<div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
					</div>
				</div> <!-- /tab001 -->
				
				<!-- IMPUESTOS / BANCOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
					<div class="row">
						<div class="col-md-6"><?php include('grldattax.frm'); ?></div>
						<div class="col-md-6"><?php include('grldatbnk.frm'); ?></div>
					</div>
				</div>
				
				<!-- CONTACTOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab005">
          <?php include('grldatcntlst.frm'); ?>
				</div>

				<!-- PERFIL -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab006">
					<div class="col-md-6">
					
            <div class="card">
              <div class="card-header"><div class="card-title"><?= $vew_lang->PROFILE; ?></div></div>
              <div class="card-body tmss-card-body-edit">
            		<div id="tchprfhot" name="tchprfhot"></div>
                <?php
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->contacthours,'input'=>gethtml('tchcnthrs','doccmt1x50',$vew_data->tchcnthrs,$lv_default) )); 						
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->nik,         'input'=>gethtml('tchniknme','doccmt1x50',$vew_data->tchniknme,$lv_default) )); 
                ?>		
            	</div>
            </div>
						
					</div>
					<div class="col-md-6">
						
            <div class="card">
              <div class="card-header"><div class="card-title"><?= $vew_lang->ANTECEDENT; ?></div></div>
              <div class="card-body tmss-card-body-edit">
				    		<?php
                  echo vew_boot($lv_col210, array("label"=>$vew_lang->titlegrantedby,'input'=>gethtml("tchttl","doccmt1x40",$vew_data->tchttl,$lv_default) ));
                  echo vew_boot($lv_col210, array("label"=>$vew_lang->otherstudies,  'input'=>gethtml("tchothstd","doccmt80x4",$vew_data->tchothstd,$lv_default) ));
                  echo vew_boot($lv_col210, array("label"=>$vew_lang->jobhistory,    'input'=>gethtml("tchjobhst","doccmt80x4",$vew_data->tchjobhst,$lv_default) ));
                  echo vew_boot($lv_col210, array("label"=>$vew_lang->comments,      'input'=>gethtml("tchcmt","doccmt80x4",$vew_data->tchcmt,$lv_default) ));
              	?>
              </div>
            </div>
						
					</div>
				</div> <!-- /tab-panel -->
			</div> <!-- /tab-content -->    
		</div> <!-- /container-fluid -->
  </form>
	<script>
		//	A R E A S (PERFIL)
		var <?= $lv_sec; ?>_hotprf_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if ( prop=='prftxt' ) {
				Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			} else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
			}
		};
		var <?= $lv_sec; ?>_hotprftmpdel = [];
    var <?= $lv_sec; ?>_autocompleteCache = [];
		var <?= $lv_sec; ?>_hotprfcnt = $("#<?= $lv_sec; ?> #tchprfhot")[0];
		var <?= $lv_sec; ?>_hotprfset = {
			height: 146,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "Area" ],
			columns: [
				{type: "autocomplete", data: "eduprftxt", renderer: <?= $lv_sec; ?>_hotprf_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source (query, process) {
						$.ajax({
							url: "?prg=eduprf&act=18", dataType: "json", data: {	prm_eduprftxt: query },
              success: function (response) {
                <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.eduprftxt);
                process(items);
              },
              error: function () {
                <?= $lv_sec; ?>_autocompleteCache = [];
                process([]);
              }
						});
					},
					strict: true
				}
			],
      afterChange: function(changes, source) {
        if (changes && changes.length > 0) {
          const row = changes[0][0];
          const valueSelected = changes[0][3] || "";
          if( changes[0][1]=="eduprftxt"){
            if (valueSelected === "") {
              <?= $lv_sec; ?>_hotprf.setDataAtRowProp(row, "eduprfcod", "");
            } else {
              const selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.eduprftxt === valueSelected);
              if (selectedItem) <?= $lv_sec; ?>_hotprf.setDataAtRowProp(row, "eduprfcod", selectedItem.eduprfcod);
              else toastr.warning("Para el texto ingresado [" + valueSelected + "] no se encontr&oacute; ninguna coincidencia.");
            }
          }
        }
      },
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotprf.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]['tchprfcod']!='' && lv_dat[i]['tchprfcod']!=undefined ) {
						<?= $lv_sec; ?>_hotprftmpdel.push( lv_dat[i] );
					}
				}
			},
      licenseKey: gv_handsontable_lc
		};
    
		var <?= $lv_sec; ?>_hotprf;	

		// cargo datos en handsontable de Area
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotprf = new Handsontable(<?= $lv_sec; ?>_hotprfcnt, <?= $lv_sec; ?>_hotprfset);	
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->tchprf as $lv_row){ $lv_buffer .= ($lv_buffer!=''?',':'').'{tchprfcod:"'.$lv_row['tchprfcod'].'", eduprfcod:"'.$lv_row['eduprfcod'].'", eduprftxt:"'.$lv_row['eduprftxt'].'"}'; }
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotprf.loadData( lv_dat );
			<?= $lv_sec; ?>_hotprf.render();
		});
	</script>
  <script>
		$(function(e){
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab006']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
		});
	</script>
	<script>		
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
    	if( lp_prm["action"]=="00" ){
      	var lv_dat = <?= $lv_sec; ?>_hotprf.getSourceData();
        var lv_del = <?= $lv_sec; ?>_hotprftmpdel;
         
        for (var i=0; i < lv_del.length; i++) {
          lv_dat.push({	"tchprfcod":lv_del[i]["tchprfcod"],
												"eduprfcod":lv_del[i]["eduprfcod"],
												"eduprftxt":lv_del[i]["eduprftxt"],
												"deleted":"X"
											});
        }
        if (lv_dat.length==0) {
					$("#<?= $lv_sec; ?> #tchprf").prop("value", "");						
				} else {
					$("#<?= $lv_sec; ?> #tchprf").prop("value", JSON.stringify( lv_dat ) );
				}
      }
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
<?php		 
	// url del formulario 
  $lv_lnk = "?prg=sptact&prm_actcod=".$vew_data->actcod;

	// campos requeridos
	$vew_input->RequiredFields( array('acttxt','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->actcod; 

	// titulo 
	$lv_title = $vew_lang->activities;
	
	// módulo y programa 
	$lv_mdlcod = 'SPT';
	$lv_prgcod = 'ACT';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->actcod; ?><?= gethtml('actcod','hidden',$vew_data->actcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class='row'>
            <div class='col-md-6'>
              <div class='card'> <!-- Card1 -->
                <div class="card-header">
                	<div class="card-title"><?= $lv_title; ?></div>
								</div>
                <div class="card-body tmss-card-body-edit">
                	<?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('actcodext', 'doccmt1x20', 		$vew_data->actcodext, $lv_default) ));
        
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('acttxt', 		'doccmt1x50', $vew_data->acttxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->group,			'input'=>gethtml('actgrptxt', 'doccmt1x50', $vew_data->actgrptxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>'Profesor', 	
                                                    'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                       array('input'=>gethtml('tchtxt', 'doccmt1x50', $vew_data->tchtxt, $lv_default))
                                                                      ))
                                 );
										echo gethtml('tchcod','hidden',$vew_data->tchcod);
										
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->location,		'input'=>gethtml('actloctxt', 'doccmt1x50', $vew_data->actloctxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->sex,				'input'=>gethtml('actsex', 'adrsex', $vew_data->actsex, $lv_default) ));
                	?>
                  <div class="form-group tmss-form-group">
                    <label class="col-xs-2 control-label"><?= $vew_lang->age; ?></label>
                    <div class="col-xs-4"><?= gethtml('actagestr', 'docnum0300', $vew_data->actagestr , $lv_default);?></div>
                    <label class="col-xs-2 control-label"><?= $vew_lang->to; ?></label>
                    <div class="col-xs-4"><?= gethtml('actageend', 'docnum0300', $vew_data->actageend , $lv_default);?></div>
                  </div>
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 		'docsts', 		$vew_data->docsts, $lv_default) ));
                  ?>
                </div>
            	</div> <!-- Cierre de la Card1 -->
          	</div> 
            <div class='col-md-6'>
            	<div class='card tmss-hot-ttl'> <!-- Card2 -->
              	<div class="card-header">
                	<div class="card-title"><?= $vew_lang->days; ?></div>
								</div>
                <div class="card-body tmss-card-body-edit">
                	<?php
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->tariff,	
                                                        'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                          array('input'=>gethtml('spttrftxt', 'typeahead', $vew_data->spttrftxt, $lv_default))
                                                                         ))
                                      );
                    echo vew_boot( array($lv_colsm210, $lv_colxs48), array('label'=>"Gestiona cantidades", 'input'=>gethtml('qtymngvar', 'checkbox', $vew_doc->getTagValue($vew_data->actatr,'qtymng'), $lv_default) ));?><br><?php

                    echo vew_boot($lv_col210, array('label'=>gethtml('spttrfcod', 'hidden', $vew_data->spttrfcod) )); //HIDDEN
                	?>
                  <div class="form-group tmss-form-group">
                    <label class="col-xs-2 control-label"><?= $vew_lang->schedule; ?></label>
                    <div class='col-xs-10'>
                      <textarea id="actatr" name="actatr" class="hidden"></textarea>
                      <div id="actdaytmesht" name="actdaytmesht"></div>
                    </div>
                  </div>
                </div>
              </div> <!-- Cierre de la Card2 -->
            </div><!-- cierre del col-md6 -->
          </div> <!-- fin del row -->
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
  <script>
	  var lo_get = {"fldsec": "<?= $lv_sec; ?>" ,"fldasg": {"spttrftxt":"spttrftxt", "spttrfcod":"spttrfcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #spttrftxt"), "spttrf", lo_get);
  </script>
  <script>
    var lo_get = {"fldsec": "<?= $lv_sec; ?>" ,"fldasg": {"tchtxt":"tchtxt", "tchcod":"tchcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #tchtxt"), "spttch", lo_get);
  </script>
	<script>
		var <?= $lv_sec; ?>_hotactdaytme_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if ( prop=="actdaytmename" ) {
				Handsontable.renderers.TextRenderer.apply(this, arguments);			
				td.style.backgroundColor = "#F1F1F1";
			} else if ( prop=="actdaytmeval" ) {
				Handsontable.renderers.NumericRenderer.apply(this, arguments);			
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			} else {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_hotactdaytmecnt = $("#<?= $lv_sec; ?> #actdaytmesht")[0];
		var <?= $lv_sec; ?>_hotactdaytmeset = {
			height: 235,
			formulas: false,
			stretchH: "all",
			autoWrapRow: true,
			rowHeaders: false,
			colHeaders: [ "Dia","Desde", "Hasta" ],
			columns: [
				{ type: "text", data: "actdaytmename", width: 40,renderer: <?= $lv_sec; ?>_hotactdaytme_renderer, readOnly: true },
				{	type: "time", data: "actdesdeval", timeFormat: 'HH:mm', correctFormat: true, renderer: <?= $lv_sec; ?>_hotactdaytme_renderer <?= ($vew_readonly?', readOnly: true':''); ?> },
        {	type: "time", data: "acthastaval", timeFormat: 'HH:mm', correctFormat: true, renderer: <?= $lv_sec; ?>_hotactdaytme_renderer <?= ($vew_readonly?', readOnly: true':''); ?> }
			],
			minSpareRows: 0,
			startRows: 1,
			startCols: 2
		};
		var <?= $lv_sec; ?>_hotactdaytme;

		// cargo datos en handsontable
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotactdaytme = new Handsontable(<?= $lv_sec; ?>_hotactdaytmecnt, <?= $lv_sec; ?>_hotactdaytmeset);
			var lv_dat = [<?php
				$lv_cols = array(
													'actdaytme001'=>$vew_lang->Sunday,
													'actdaytme002'=>$vew_lang->Monday,
													'actdaytme003'=>$vew_lang->Tuesday,
													'actdaytme004'=>"Miercoles",
													'actdaytme005'=>$vew_lang->Thursday,
													'actdaytme006'=>$vew_lang->Friday,
													'actdaytme007'=>$vew_lang->Saturday
				);
				$lv_buffer='';
				foreach($lv_cols as $lv_key=>$lv_val) { 
          $lv_desdehasta = $vew_doc->getTagValue($vew_data->actatr,$lv_key);
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'actdaytmekey:"'.$lv_key.'",'.
												'actdaytmename:"'.$lv_val.'",'.
            						'actdesdeval:"'.$vew_doc->getTagValue($lv_desdehasta, 'DESDE').'",'.
          							'acthastaval:"'.$vew_doc->getTagValue($lv_desdehasta, 'HASTA').'"}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotactdaytme.loadData( lv_dat );
			<?= $lv_sec; ?>_hotactdaytme.render();
		});
	</script>
  <script>
  	// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      if(lp_prm.action=="00"){
        // get times from handsontable
        var lo_dat = <?= $lv_sec; ?>_hotactdaytme.getSourceData();
        var lv_buf = "";
        for (var i=0; i<lo_dat.length; i++) {
          if(lo_dat[i]["actdesdeval"] != undefined && lo_dat[i]["acthastaval"] != undefined && lo_dat[i]["actdesdeval"] < lo_dat[i]["acthastaval"]){
            lv_buf += "<"+lo_dat[i]["actdaytmekey"]+">"+"<desde>"+lo_dat[i]["actdesdeval"]+"</desde>"+"<hasta>"+ lo_dat[i]["acthastaval"]+"</hasta>"+"</"+lo_dat[i]["actdaytmekey"]+">";
          }else if(lo_dat[i]["actdesdeval"] > lo_dat[i]["acthastaval"]){
            toastr.warning("CORREGIR VALORES DE GRILLA: Desde debe de ser menor a Hasta");
            for(var j = 1; j < 3; j++){
              <?= $lv_sec; ?>_hotactdaytme.getCell(i,j).style.background = "#FF4C42";
            } 
            return false;
          }  
        }
      }
			$("#<?= $lv_sec; ?> #actatr").text(lv_buf);
			}
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
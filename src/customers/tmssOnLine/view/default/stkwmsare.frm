<?php
	// url del formulario
  $lv_lnk = '?prg=stkwmsare&prm_wmsarecod='.$vew_data->wmsarecod;

	// campos requeridos
	$vew_input->RequiredFields( array('wmsaretxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->wmsarecod;

	// titulo
	$lv_title = $vew_lang->area;
	
	// módulo y programa
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'WAR';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->wmsarecod; ?><?= gethtml('wmsarecod', 'hidden', $vew_data->wmsarecod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">	
			
        <!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code,'input'=>gethtml('wmsarecodext', 'doccmt1x50', $vew_data->wmsarecodext, $lv_default) ));
										echo vew_boot($lv_col210,	array('label'=>$vew_lang->type, 
																										'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
																																				array('input'=>gethtml('wmstyptxt', 'typeahead', $vew_data->wmstyptxt, $lv_default) ))
																										 ));
										echo gethtml('wmstypcod','hidden',$vew_data->wmstypcod);
										echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('wmsaretxt', 'doccmt1x50', $vew_data->wmsaretxt, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->status,'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
                </div>
             	</div> <!-- /card -->
          	</div> <!-- /col -->
						<div class="col-md-6">
              <div class="card tmss-hot-ttl">
                <div class="card-header"><div class="card-title"><?= $vew_lang->locations; ?></div></div>
             	</div> <!-- /card -->
              <div id = "stkwmsarehot" name="stkwmsarehot"></div>
              <textarea class = "hidden" id = "stkwmsareloc" name = "stkwmsareloc"></textarea>
          	</div> <!-- /col -->
					</div> <!-- /row -->
				</div> <!-- /_tab001 -->
				
		  </div> <!-- /tab-content -->
  	</div> <!-- /container-fluid -->
  </form>
  <script>
    var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = '#F1F1F1';
		};
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #stkwmsarehot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
    height: 396,
    stretchH: "all",
    minSpareRows: 0,
    colHeaders: ["<?= $vew_lang->Code; ?>", "<?= $vew_lang->Description	; ?>", "<?= $vew_lang->Status	; ?>"],
    columns: [
      {type: "text", data: "stkwmsloccodext", renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true, width: 18},
      {type: "text", data: "stkwmsloctxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true},
      {type: "text", data: "docsts", renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true, width: 7}
      ],
    licenseKey: gv_handsontable_lc
  };
  var <?= $lv_sec; ?>_hotdoc;

  tmssLoadScript("handsontable16",function(){
    <?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
    var lv_dat = [<?php
        $lv_buffer='';
		
        foreach($vew_data->stkwmsloc as $lv_row){
          $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                      'stkwmsloccodext:"'.$lv_row['wmsloccodext'].'",'.
                      'stkwmsloctxt:"'.$lv_row['wmsloctxt'].'",'.
                      'docsts:"'.($lv_row['docsts']).'"'.
                      '}'; 
                    }
        echo $lv_buffer;
    ?>];
    <?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
    <?= $lv_sec; ?>_hotdoc.render();
  });
  
  </script>
	<script>
	    // tipo
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"wmstypcod":"wmstypcod", "wmstyptxt":"wmstyptxt"}};
  	tmssTypeahead($("#<?= $lv_sec; ?> #wmstyptxt"), "stkwmstyp", lo_get);
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
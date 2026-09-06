<?php
	// url del formulario
  $lv_lnk = '?prg=hhrevlski&prm_hhrevlskicod='.$vew_data->hhrevlskicod;

	// campos requeridos
	$vew_input->RequiredFields( array('hhrevlskitxt', 'hhrevlskigrp', 'docsts') );

	// clave del documento
	$lv_dockey = $vew_data->hhrevlskicod;

	// titulo
	$lv_title = $vew_lang->skills;
	
	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'SKI';
	
	// Libreria de estilos bootstrap
  include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>    
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hhrevlskicod; ?><?= gethtml('hhrevlskicod','hidden',$vew_data->hhrevlskicod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('hhrevlskicodext', 'doccodext', $vew_data->hhrevlskicodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hhrevlskitxt', 'doccmt1x50', $vew_data->hhrevlskitxt, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->group,			'input'=>gethtml('hhrevlskigrp', array(''=>'','T'=>'T&eacute;cnicas','BI'=>'Blanda Interpersonal','BA'=>'Blanda Intrapersonal'), $vew_data->hhrevlskigrp, $lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>'',										'input'=>'<span id="hhrevlskigrpcmt" class="text-danger"></span>'));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->comments,		'input'=>gethtml('hhrevlskicmt', 'doccmt5x50', $vew_data->hhrevlskicmt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
						    </div>
              </div><!-- /card -->
              
            </div><!-- /col-md-6 -->
						<div class="col-md-6">
              
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->evaluation; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?= gethtml('hhrevlskiatr','hidden',$vew_data->hhrevlskiatr); ?>
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->question,'input'=>gethtml('hhrevlskiatrqst', 'doccmt5x50', $vew_doc->getTagValue($vew_data->hhrevlskiatr,'qst'), $lv_default) )); ?>
                  <div id="hhrevlskievlhot"></div>
                  <textarea id="hhrevlskievl" name="hhrevlskievl" class="hidden"><?= $vew_data->hhrevlskievl; ?></textarea>
								</div>
							</div>
              
						</div><!-- /col-md-6 -->
					</div><!-- /row -->
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <script>
    $("#<?= $lv_sec; ?> #hhrevlskigrp").on("change",function(){
      var lv_txt = "";
      switch($(this).val()){
        case "BI": lv_txt = "C&oacute;mo te comunicas y te relacionas con los dem&aacute;s (ej. comunicaci&oacute;n efectiva, trabajo en equipo, liderazgo, empat&iacute;a, negociaci&oacute;n, resoluci&oacute;n de conflictos)."; break;
        case "BA": lv_txt = "C&oacute;mo te gestionas a ti mismo (ej. autogesti&oacute;n, gesti&oacute;n del tiempo, organizaci&oacute;n, adaptabilidad, pensamiento cr&iacute;tico, resoluci&oacute;n de problemas, creatividad, &eacute;tica profesional)."; break;
        case "T":  lv_txt = "Conjunto de conocimientos, destrezas y capacidades espec&iacute;ficas que un empleado necesita para desempe&ntilde;ar eficazmente las tareas y responsabilidades de su puesto de trabajo. Son habilidades que se pueden aprender, medir y evaluar de forma objetiva (ej. desarrollador de software, dise&ntilde;ador gr&aacute;fico, contador, ingeniero civil, especialista en marketing digital)."; break;
      }
      $("#<?= $lv_sec; ?> #hhrevlskigrpcmt").html( lv_txt );
    });    
    $(function(){$("#<?= $lv_sec; ?> #hhrevlskigrp").trigger("change");});
  </script>
	<script>
		// O B J E T O S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if (prop=="evlsub") { 
				Handsontable.renderers.TextRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
			if (prop=="evlobj") { 
				Handsontable.renderers.NumericRenderer.apply(this, arguments);
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #hhrevlskievlhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 300,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->subjetive; ?>", "<?= $vew_lang->objetive; ?>" ],
			columns: [
				{type: "text", data: "evlsub", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
        {type: "numeric", data: "evlobj", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> numericFormat: {pattern: "0", culture: "es-AR"}},
			],
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotobj;
		
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotobj = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [<?php
        $lv_evltbl = ($vew_data->hhrevlskievl==''?array(): $vew_doc->getArrayFromJson( $vew_data->hhrevlskievl));
				$lv_buffer = '';
				foreach( $lv_evltbl as $lv_row) {
					$lv_buffer .= ($lv_buffer==''?'':', ').'{evlsub: "'.utf8_decode($lv_row['evlsub']).'", evlobj: "'.$lv_row['evlobj'].'"}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotobj.loadData( lv_dat );
			<?= $lv_sec; ?>_hotobj.render();
		});
	</script>
	<script>
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      if (lp_prm["action"]=="00") {

        // obtengo datos de handsontable de roles
        var lo_dat = <?= $lv_sec; ?>_hotobj.getSourceData();
        var lv_arr = lo_dat.filter( e => e["evlsub"]!="" && e["evlobj"] != undefined);
        
        if (lv_arr.length==0) {
          $("#<?= $lv_sec; ?> #hhrevlskievl").text("");
        } else {
          $("#<?= $lv_sec; ?> #hhrevlskievl").prop("value", JSON.stringify( lv_arr ) );
        }
				
      	$("#<?= $lv_sec; ?> #hhrevlskiatr").prop("value", '<qst>' + $("#<?= $lv_sec; ?> #hhrevlskiatrqst").val() + '</qst>');
			}
		}
	</script>  
	<?php include('grldocfrmscr.frm'); ?>
</section>
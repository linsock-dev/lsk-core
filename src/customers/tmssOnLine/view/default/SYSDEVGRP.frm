<?php 
	// url del formulario
  $lv_lnk = '?prg=sysdevgrp&prm_sysdevgrpcod='.$vew_data->sysdevgrpcod;

	// campos requeridos
	$vew_input->RequiredFields( array('sysdevgrptxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->sysdevgrpcod;

	// titulo
	$lv_title = $vew_lang->developergroup;
	
	// módulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'DVG';
	
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('sysdevgrpusr','hidden',$vew_data->sysdevgrpusr); ?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->sysdevgrpcod; ?><?= gethtml('sysdevgrpcod','hidden',$vew_data->sysdevgrpcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
        
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">		
          <div class="row">
						<div class="col-md-6">
              
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code,	'input'=>gethtml('sysdevgrpcodext', 'doccmt1x20', $vew_data->sysdevgrpcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('sysdevgrptxt', 'doccmt1x50', $vew_data->sysdevgrptxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
              
            </div><!-- /col -->
            <div class="col-md-6">
              
              <div class="card tmss-hot-ttl">
                <div class="card-header"><div class="card-title"><?= $vew_lang->users; ?></div></div>
              </div>
              <div id="sysdevgrpusrhot"></div>              
              
            </div>
          </div><!-- /row -->
				</div> <!-- /_tab001 -->
        
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		// GRUPOS DE DESARROLLO
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
		};
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #sysdevgrpusrhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 350,
			stretchH: "all",
			//autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			//autoWrapRow: false,
			//rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->user; ?>" ],
			columns: [{type: "text", data: "usrcod", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>}],
			licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotdoc;	

		// cargo datos en handsontable
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
        $lv_sysdevgrpusr = ($vew_data->sysdevgrpusr==''?array():json_decode($vew_data->sysdevgrpusr,true));
				$lv_buffer='';
				foreach($lv_sysdevgrpusr as $lv_val){
          if( $lv_val!='' ){ $lv_buffer .= ($lv_buffer!=''?',':'').'{usrcod:"'.$lv_val.'"}'; }
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
  <script>
    // form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      // al grabar
			if ( lp_prm["action"]=="00" ) {
      	// crea string de usuarios de grupos de desarrollo
        var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
        var lv_sysdevgrpusr = Array();
        for (var i=0; i<lo_dat.length-1 ; i++) {
          if (lo_dat[i]["usrcod"]!="" && lo_dat[i]["usrcod"]!=undefined){
            lv_sysdevgrpusr.push( lo_dat[i]["usrcod"] );
         }
        }        
        $("#<?= $lv_sec; ?> #sysdevgrpusr").prop("value", (lv_sysdevgrpusr.length==0?"[]":JSON.stringify(lv_sysdevgrpusr)) );
      }    
    }
  </script>  
  <?php include('grldocfrmscr.frm'); ?>
</section>
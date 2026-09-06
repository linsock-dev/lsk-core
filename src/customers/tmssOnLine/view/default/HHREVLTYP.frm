<?php
	// url del formulario
  $lv_lnk = '?prg=hhrevltyp&prm_hhrevltypcod='.$vew_data->hhrevltypcod;

	// campos requeridos
	$vew_input->RequiredFields( array('hhrevltyptxt', 'docsts') );

	// clave del documento
	$lv_dockey = $vew_data->hhrevltypcod;

	// titulo
	$lv_title = $vew_lang->type;
	
	// módulo y programa
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'EVT';
	
	// Libreria de estilos bootstrap
  include_once('_library.frm');
	$lv_atrevl = $vew_doc->getArrayFromJson($vew_data->hhrevltypatr);
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>    
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->hhrevltypcod; ?><?= gethtml('hhrevltypcod','hidden',$vew_data->hhrevltypcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('hhrevltypcodext', 'doccodext', $vew_data->hhrevltypcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hhrevltyptxt', 'doccmt1x50', $vew_data->hhrevltyptxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->comments,		'input'=>gethtml('hhrevltypcmt', 'doccmt5x50', $vew_data->hhrevltypcmt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
						    </div>
              </div><!-- /card -->
              
            </div><!-- /col-md-6 -->
						<div class="col-md-6">
              
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->scope; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                  	echo vew_boot($lv_col210,array('label'=>$vew_lang->type, 'input'=>gethtml('hhrevltypatrevl',array(1=>$vew_lang->targets,2=>$vew_lang->skills, ''=>''),(($lv_atrevl['evlobj']??''!='')?'1':($lv_atrevl['evlski']??''!=''?'2':'')),$lv_default)));
                    echo vew_boot($lv_col210,array('label'=>$vew_lang->ClosingTalk, 'input'=>gethtml('hhrevltyptlk', 'checkbox', ( ($lv_atrevl['typtlk']??'') == 'X'),$lv_default)));
                  //	echo vew_boot($lv_col66, array('label'=>$vew_lang->targets, 'input'=>gethtml('hhrevltypatrevlobj','checkbox', ($lv_atrevl['evlobj']??''!=''?true:false), $lv_default) ));
                  //	echo vew_boot($lv_col66, array('label'=>$vew_lang->skills, 	'input'=>gethtml('hhrevltypatrevlski','checkbox', ($lv_atrevl['evlski']??''!=''?true:false), $lv_default) ));
                  	echo '<hr>';
                  ?>
                  <div id="hhrevltypatrstphot"></div>
                  <textarea id="hhrevltypatr" name="hhrevltypatr" class="hidden"><?= $vew_data->hhrevltypatr; ?></textarea>
								</div>
							</div>
              
						</div><!-- /col-md-6 -->
					</div><!-- /row -->
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
		// P A S O S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
      if( prop=="evlstp"){
        Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
	      td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
      } else {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";        
      }
		};
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #hhrevltypatrstphot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 300,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->step; ?>", "<?= $vew_lang->description; ?>" ],
			columns: [
        {type: 'autocomplete', data: 'evlstp', width: 100, renderer: <?= $lv_sec; ?>_hotdoc_renderer, source: [ 'Supervisor', 'Colaborador', 'Subalterno', 'Cliente'], strict: true },
				{type: "text", data: "evlttl", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>}
			],
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotobj;
		
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotobj = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [<?php
				$lv_buffer = '';
        if(!empty($lv_atrevl['evlstp'])){
          foreach( $lv_atrevl['evlstp'] as $lv_row) {
            $lv_buffer .= ($lv_buffer==''?'':', ').'{evlstp: "'.$lv_row['evlstp'].'", evlttl: "'.(utf8_decode($lv_row['evlttl']??'')).'"}';
          }
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

        var lv_arr={"evlstp":[],
                    "evlobj":($("#<?= $lv_sec; ?> #hhrevltypatrevl").prop("value")==1?'X':''),
                    "evlski":($("#<?= $lv_sec; ?> #hhrevltypatrevl").prop("value")==2?'X':'')};
				
        // obtengo datos de handsontable de roles
        var lo_dat = <?= $lv_sec; ?>_hotobj.getSourceData();
        lv_arr["evlstp"] = lo_dat.filter( e => e["evlstp"]!= undefined );
        lv_arr["typtlk"] = ($("#<?= $lv_sec?> #hhrevltyptlk").prop("checked"))? "X": "";
        $("#<?= $lv_sec; ?> #hhrevltypatr").prop("value", JSON.stringify( lv_arr ) );
      }
		}
	</script>  
	<?php include('grldocfrmscr.frm'); ?>
</section>
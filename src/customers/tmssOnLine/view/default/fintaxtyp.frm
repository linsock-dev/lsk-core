<?php
	// url del formulario 
  $lv_lnk = '?prg=fintaxtyp&prm_fintaxtypcod='.$vew_data->fintaxtypcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('fintaxtyptxt','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->fintaxtypcod;

	// titulo 
	$lv_title = $vew_lang->taxtypes;
	
	// módulo y programa 
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'TTP';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');

	$lv_rejarr = array(''=>'', 'IVA'=>'IVA', 'IMU'=>'Impuestos Municipales', 'IPR'=>'Impuestos Provinciales', 'IIB'=>'Ingresos Brutos');
	$lv_typarr = array(''=>'', 'C'=>'Compra', 'V'=>'Venta');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?> 	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <textarea id="finacc" name="finacc" class="hidden"></textarea>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->fintaxtypcod; ?><?= gethtml('fintaxtypcod','hidden',$vew_data->fintaxtypcod)?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="col-md-6">
            
            <div class="card">
              <div class="card-header">
                <div class="card-title"><?= $lv_title; ?>
                </div>
              </div>
              <div class="card-body tmss-card-body-edit">  
                <?php 
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->code,		'input'=>gethtml('fintaxtypcodext','doccmt1x20',$vew_data->fintaxtypcodext, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('fintaxtyptxt','doccmt1x50', $vew_data->fintaxtyptxt, $lv_default) ));
                	echo vew_boot($lv_col210, array('label'=>$vew_lang->type,		'input'=>gethtml('fintaxtyptyp', $lv_typarr, $vew_data->fintaxtyptyp, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->category,	'input'=>gethtml('fintaxtypcat', $lv_rejarr, $vew_data->fintaxtypcat, $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 	'input'=>gethtml('docsts', 			'docsts', 		$vew_data->docsts, $lv_default) ));
                ?>
              </div>
            </div>
            
					</div>
					<div class="col-md-6">
            
            <div class="card">
              <div class="card-header"><div class="card-title"><?= $vew_lang->liquidation; ?></div></div>
              <div class="card-body tmss-card-body-edit">
                <p>Mapeo de cuentas a liquidar:</p>
                <div id="finacchot"></div>
              </div>
            </div>            
            
					</div>
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form><!-- Form Submit -->
	<script>
		// L I Q U I D A C I O N   -   C U E N T A S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
        Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
        td.style.backgroundColor = "<?= ($vew_readonly?'#F1F1F1':'#FFFFFF'); ?>";
        cellProperties.readOnly = <?= ($vew_readonly?'true':'false'); ?>;
			}
		};
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #finacchot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 296,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["row_above","row_below","remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?0:1); ?>,
      licenseKey: gv_handsontable_lc,
			colHeaders: [ "Cuenta" ],
			columns: [
				{type: "autocomplete", data: "finacctxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
         		source: function (query, process) {              
              if ( query.length>1) {
                tmssCallProcessNoBackdrop("?prg=finacc&act=18&prm_finacctxt="+query,[],function(data){
                  let lv_dat = data.data;
                  <?= $lv_sec; ?>_hotdocchg = lv_dat;
                  process( $.map(lv_dat, function(value, index){ return value.finacctxt; }) );
                });
              } else { process( [query] ); }
            },
            strict: true
        }
			],
			beforeChange : function(changes, source) {
				var lv_value = changes[0][3];
				if(source=="edit" && changes[0][1]=="finacctxt") {
          for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
              if(<?= $lv_sec; ?>_hotdocchg[i].finacctxt == lv_value) {
                  changes.push([ changes[0][0], "finacccod", "", String(<?= $lv_sec; ?>_hotdocchg[i].finacccod) ]);
              }
          }
        }
			}
		};
		var <?= $lv_sec; ?>_hotdoc;
		
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [<?php
				$lv_buffer = '';
        if( is_array($vew_data->finacc) ){
          foreach( $vew_data->finacc as $lv_row) {
            $lv_buffer .= ($lv_buffer==''?'':', ').'{finacccod:"'.$lv_row['finacccod'].'", finacctxt:"'.$lv_row['finacctxt'].'"}';
          }
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
				let lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
        let lv_dat = lo_dat.filter(c => c.finacccod!==0 && c.finacccod!=null);
				$("#<?= $lv_sec; ?> #finacc").val( (lv_dat.length>0?JSON.stringify(lv_dat):"[]") );
			}
		}
  </script>  
	<?php include('grldocfrmscr.frm'); ?>
</section>
<?php	
	// url del formulario 
  $lv_lnk = '?prg=finmovmdl&prm_finmovmdlcod='.$vew_data->finmovmdlcod;

	// campos requeridos
	$vew_input->RequiredFields( array('finmovmdltxt','curcod','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->finmovmdlcod; 

	// titulo
	$lv_title = $vew_lang->document;
	
	// modulo y programa
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'MDL';
	$lv_objtyp = $vew_data->mdlcod.'_'.$vew_data->prgcod;

	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<textarea class="hidden" id="finmovmdlacc" name="finmovmdlacc"></textarea>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->finmovmdlcod; ?><?= gethtml('finmovmdlcod','hidden',$vew_data->finmovmdlcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-4">
              
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->general; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                  echo vew_boot($lv_col39, array('label'=>$vew_lang->code, 'input'=>gethtml('finmovmdlcodext', 'doccmt1x50',$vew_data->finmovmdlcodext, $lv_default) )); 
                  echo vew_boot($lv_col39, array('label'=>$vew_lang->description, 'input'=>gethtml('finmovmdltxt', 'doccmt1x50',$vew_data->finmovmdltxt, $lv_default) )); 
                  echo vew_boot($lv_col39, array('label'=>$vew_lang->currency, 'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('curcod', 'doccmt1x2', $vew_data->curcod, $lv_always_disabled) )) ));
                  echo vew_boot($lv_col39, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); 
                	?>
                </div>
              </div>
              
						</div>
            <div class="col-md-8">
              
              <div class="card tmss-hot-ttl">
                <div class="card-header"><div class="card-title"><?= $vew_lang->accounts; ?></div></div>
              </div>
              <div id="finmovmdlacchot" name="finmovmdlacchot"></div>
              
            </div>
					</div>	
				</div> <!-- /_tab001 -->
			</div> <!-- /tab-content -->    
		</div> <!-- /container-fluid -->
  </form>
	<script>
    // curcod
    var lo_get = {"fldsec": "<?= $lv_sec; ?>" ,"fldasg": {"curcod":"curcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #curcod"), "admcur", lo_get);
	</script>
	<script>
		//C U E N T A S
		var <?= $lv_sec; ?>_hotacc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      var lv_ro_color = "#F1F1F1";
      var lv_color = "#FFFFFF";
      var lv_ro = <?php echo($vew_readonly?'true':'false'); ?>;
      if ( prop=="finacccod" ) {
        Handsontable.renderers.TextRenderer.apply(this, arguments);			
        td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
        cellProperties.readOnly = (lv_ro?true:false);
      } else if ( prop=="finacctxt" ) {
        Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);			
        td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
        cellProperties.readOnly = (lv_ro?true:false);
      } else if ( prop=="finmovdocacctotD" || prop=="finmovdocacctotH" ) {
        Handsontable.renderers.NumericRenderer.apply(this, arguments);			
        td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
        cellProperties.readOnly = (lv_ro?true:false);					
      } else {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
      }
		};
		var <?= $lv_sec; ?>_hotaccchg = [];
		var <?= $lv_sec; ?>_hotacccnt = $("#<?= $lv_sec; ?> #finmovmdlacchot")[0];
		var <?= $lv_sec; ?>_hotaccset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
      licenseKey: gv_handsontable_lc,
      colHeaders: [ "Cuenta", "Debe", "Haber" ],
			columns: [
				{type: "autocomplete", data: "finacctxt", renderer: <?= $lv_sec; ?>_hotacc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
         source: function (query, process) {
            if (query === '') { return; }
            if (query.length > 1) {
                $.ajax({
                    url: "?prg=finacc&act=18",
                    dataType: "json",
                    data: { prm_finacctxt: query },
                    complete: function(jqXHR, textStatus) {
                        if (jqXHR.responseText.substr(0,10) == "/*script*/") { eval(jqXHR.responseText); }
                    },
                    success: function(response) {
                        var lv_dat = [];
                        <?= $lv_sec; ?>_hotaccchg = [];
                        for (var i = 0; i < response.data.length; i++) {
                            <?= $lv_sec; ?>_hotaccchg.push({
                                finacctxt: response.data[i]["finacctxt"],
                                finacccod: response.data[i]["finacccod"]
                            });
                            lv_dat.push(response.data[i]["finacctxt"]);
                        }
                        process(lv_dat);
                    }
                });
            }
        },strict: true
				},
				{type: "numeric", data: "finmovdocacctotD", width: 50, renderer: <?= $lv_sec; ?>_hotacc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "finmovdocacctotH", width: 50, renderer: <?= $lv_sec; ?>_hotacc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} }
			],
			beforeChange : function(changes, source) {
				if(changes && changes.length && source=="edit" && source!="CopyPaste.paste"){
          if(changes[0][1]=="finacctxt") {
            var lv_value = changes[0][3];
            for(var i=0 ; i < <?= $lv_sec; ?>_hotaccchg.length ; i++) {
              if(<?= $lv_sec; ?>_hotaccchg[i].finacctxt == lv_value) {
                changes.push([ changes[0][0], "finacccod", "", String(<?= $lv_sec; ?>_hotaccchg[i].finacccod) ]);
              }
            }
          }
				}
			}
		};
		var <?= $lv_sec; ?>_hotacc;	

		// cargo datos en handsontable
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotacc = new Handsontable(<?= $lv_sec; ?>_hotacccnt, <?= $lv_sec; ?>_hotaccset);	
			var lv_dat = [<?php
				$lv_buffer='';
					foreach ((is_array($vew_data->finmovmdlacc ?? null) ? $vew_data->finmovmdlacc : []) as $lv_row) {
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
											'finmovmdlacccod:"'.$lv_row['finmovmdlacccod'].'",'.
											'finacccod:"'.$lv_row['finacccod'].'",'.
											'finacctxt:"'.$lv_row['finacctxt'].'",'.
											'finmovdocacctotD: '.($lv_row['finmovmdlaccblc']=='D'?$lv_row['finmovmdlacctot']:0).','.
											'finmovdocacctotH: '.($lv_row['finmovmdlaccblc']=='H'?$lv_row['finmovmdlacctot']:0).','.
											'}'; 
										}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotacc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotacc.render();
		});
	</script>
  <script>
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      
			// al grabar
			if ( lp_prm["action"]=="00" ) {

        
				// obtengo datos de handsontable de Especialidades
				var lo_dat = <?= $lv_sec; ?>_hotacc.getSourceData();
        //valida que no haya importe en debe y haber al mismo tiempo
        for (var i=0; i<lo_dat.length; i++) {
          if (lo_dat[i]["finacccod"] && lo_dat[i]["finmovdocacctotD"] > 0 && lo_dat[i]["finmovdocacctotH"] > 0) {
            toastr.warning("No puede indicar valores en DEBE y HABER al mismo tiempo.");
            return false;
          }
        }
        
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["finacccod"]!="" && lo_dat[i]["finacccod"]!=undefined ) {
            var lv_debe = Number( (lo_dat[i]["finmovdocacctotD"]!=undefined && lo_dat[i]["finmovdocacctotD"] != 0 ? lo_dat[i]["finmovdocacctotD"] : -1 ) );
            var lv_haber = Number( (lo_dat[i]["finmovdocacctotH"] != undefined && lo_dat[i]["finmovdocacctotH"]!= 0 ? lo_dat[i]["finmovdocacctotH"] : -1) );
            lo_dat[i]["finmovmdlacctot"] = (lv_debe>-1?lv_debe:(lv_haber>-1?lv_haber:0));
            lo_dat[i]["finmovmdlaccblc"] = (lv_debe>-1?"D":(lv_haber>-1?"H":""));
            lo_dat[i]["finmovmdlaccord"] = i;
            lv_arr.push( lo_dat[i] );
          }
        }
        
        $("#<?= $lv_sec; ?> #finmovmdlacc").prop("value", JSON.stringify(lv_arr));
			}			
		}		
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>

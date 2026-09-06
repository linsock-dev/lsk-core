<?php
	// url del formulario
  $lv_lnk = "?prg=cnslqd&prm_cnslqdcod=".$vew_data->cnslqdcod;

	// campos requeridos
	$vew_input->RequiredFields( array('cnslqdtxt','custxt', 'cuscod', 'cnslqdstrdte','cnslqdenddte', 'docsts') );

	// clave del documento
	$lv_dockey = $vew_data->cnslqdcod;

	// titulo
	$lv_title = $vew_lang->liquidation;
	
	// módulo y programa
	$lv_mdlcod = 'CNS';
	$lv_prgcod = 'LQC';

	// librería de estilos bootstrap
	include_once('_library.frm');
	
	/* valores x default */
	if ( $vew_data->cnslqdcod=='' && $vew_readonly==false ) {
		$vew_data->cnslqddte = date('d/m/Y');
		$vew_data->docsts = 'A';
		
		$lv_curdte = new DateTime( date('Y-m-d') );
		if ( $lv_curdte->format('d')>10 ) {
			$lv_strdte = new DateTime(date('Y-m-d'));
			$lv_enddte = new DateTime(date('Y-m-d'));
			$lv_strdte->modify('first day of this month');
			$lv_enddte->modify('last day of this month');
		} else {
			$lv_strdte = new DateTime(date('Y-m-d'));
			$lv_enddte = new DateTime(date('Y-m-d'));
			$lv_strdte->modify('first day of last month');
			$lv_enddte->modify('last day of last month');
		}

		$vew_data->cnslqdstrdte = $lv_strdte->format('d/m/Y');
		$vew_data->cnslqdenddte = $lv_enddte->format('d/m/Y');		
	}else{
    $vew_data->cnslqddte = $vew_data->ctedte;
  }

	$lv_evtlqd = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'cnsevt_lqd');
?>

<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('slsprclstcod','hidden', $vew_data->slsprclstcod); ?>
    <?= gethtml('cnslqddoc','hidden', ''); ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->cnslqdcod; ?><?= gethtml('cnslqdcod','hidden',$vew_data->cnslqdcod); ?></strong></h4></li>
			</ul>
      
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->LIQUIDATION; ?>
                    <span class="tmss-card-icon">
                      <span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod);?> 
                    </span> 
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
										echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('cnslqdcodext', 'doccmt1x20', $vew_data->cnslqdcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('cnslqdtxt', 'doccmt1x50', $vew_data->cnslqdtxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->customer , 'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($vew_data->cnslqdcod==''?$vew_readonly:true) ), array('input'=>gethtml('custxt', 'doccmt1x50', $vew_data->custxt, ($vew_data->cnslqdcod==''?$lv_default:$lv_always_disabled) ) )) ));
                    echo gethtml('cuscod', 'hidden',	$vew_data->cuscod);
                  	echo vew_boot($lv_col210, array("label"=>$vew_lang->status,	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
									?>
                </div>
              </div>
						</div>
            <div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->data; ?></div>
                </div>
                <div class="card-body tmss-card-body-edit">  
                  <?php
                    echo vew_boot($lv_col244, array('label'=>$vew_lang->date, 'input'=>gethtml('cnslqddte', 'docdte', $vew_data->cnslqddte, $lv_always_disabled) ) );
                		echo vew_boot($lv_col255, array('label'=>$vew_lang->period, 'input'=>gethtml('cnslqdstrdte',	'docdte',	$vew_data->cnslqdstrdte,	$vew_data->cnslqdcod='' ? $lv_default : $lv_always_disabled), 'input2'=>gethtml('cnslqdenddte',	'docdte',	$vew_data->cnslqdenddte,	$vew_data->cnslqdcod='' ? $lv_default : $lv_always_disabled) ));
                  ?>
                </div>
              </div>
            </div> <!-- /col-6 -->
					</div>
          <div class="card tmss-hot-ttl">
            <div class="card-header">
              <div class="card-title">
                <?= $lv_title; ?>
                <a id="btnupd" class="card-icon tmssAlwaysEnabled tmssHiddeOnRead" title="<?= $vew_lang->update; ?>"><i class="far fa-sync" ></i></a> 
                <a id="btnflt" class="card-icon tmssAlwaysEnabled tmssHiddeOnRead" title="<?= $vew_lang->filter; ?>"><i class="far fa-filter" ></i></a> 
                <span class="tmss-card-icon font-weight-bold" id="cnslqdtot">
                  <strong><?= number_format(floatval($vew_data->cnslqdtot),2,'.',','); ?></strong>
                </span>
              </div>
            </div>
          </div> <!-- /card -->
          <div id="hotcnslqddoc"></div>
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
  <script>
    var <?= $lv_sec; ?>_lqddoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {	
      if ( prop=='cnslqddocbar' || prop=='cnslqddocprc' || prop=='cnslqddocqty' || prop=='cnslqddoctot' ) {
        Handsontable.renderers.NumericRenderer.apply(this, arguments);
        td.style.backgroundColor = "#F1F1F1";
      }else if ( prop=='cnslqddocrec' || prop=='cnslqddoccof') {
        Handsontable.renderers.NumericRenderer.apply(this, arguments);
        td.style.backgroundColor = '#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>';
      } else {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = "#F1F1F1";
      }
    };
    var <?= $lv_sec; ?>_lqddoc_autocomplete = false;
    var <?= $lv_sec; ?>_lqddoctmpchg = [];
    var <?= $lv_sec; ?>_lqddoctmpdel = [];
    var <?= $lv_sec; ?>_lqddoccnt = $("#<?= $lv_sec; ?> #hotcnslqddoc")[0];
    var <?= $lv_sec; ?>_lqddocset = {
      height: 246,
      stretchH: "all",
      autoColumnSize: true,
      <?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
      autoWrapRow: false,
      rowHeaders: false,
      colHeaders: [ "<?= $vew_lang->constructionsite ?>", "<?= $vew_lang->task ?>", "<?= $vew_lang->description ?>", "Cant", "<?= $vew_lang->um ?>", "<?= $vew_lang->feescale ?>", "Coef", "<?= $vew_lang->unitary ?>", "<?= $vew_lang->surcharge ?>", "<?= $vew_lang->subtotal ?>" ],
      columns: [
        {type: "text", data: "stecodtxt", width: 100, renderer: <?= $lv_sec; ?>_lqddoc_renderer, readOnly: true },
        {type: "text", data: "tskcodext", width: 20, renderer: <?= $lv_sec; ?>_lqddoc_renderer, readOnly: true },
        {type: "text", data: "tsktxt",width: 100, renderer: <?= $lv_sec; ?>_lqddoc_renderer, readOnly: true },
        {type: "numeric", data: "cnslqddocqty", width: 20, renderer: <?= $lv_sec; ?>_lqddoc_renderer, readOnly: true, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
        {type: "text", data: "cnslqddocuntcod", width: 20, renderer: <?= $lv_sec; ?>_lqddoc_renderer, readOnly: true },
        {type: "numeric", data: "cnslqddocbar", width: 20, renderer: <?= $lv_sec; ?>_lqddoc_renderer, readOnly: true, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
        {type: "numeric", data: "cnslqddoccof", width: 20, renderer: <?= $lv_sec; ?>_lqddoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
        {type: "numeric", data: "cnslqddocprc", width: 30, renderer: <?= $lv_sec; ?>_lqddoc_renderer, readOnly: true, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
        {type: "numeric", data: "cnslqddocrec", width: 20, renderer: <?= $lv_sec; ?>_lqddoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
        {type: "numeric", data: "cnslqddoctot", width: 30, renderer: <?= $lv_sec; ?>_lqddoc_renderer, readOnly: true, numericFormat: {pattern: "0,0.00", culture: "es-AR"} }
      ],
      afterChange: function(changes, source) {
        // realizo el calculo de precios
        if(<?= $lv_sec; ?>_lqddoc!=undefined){
          if(changes && changes.length) {
            for(var i=0; i < changes.length; i++) {
              if (changes[i][1]=="cnslqddoccof") {
                var lv_bar = parseFloat(<?= $lv_sec; ?>_lqddoc.getDataAtRowProp(changes[i][0], "cnslqddocbar"));
                var lv_cof = parseFloat(<?= $lv_sec; ?>_lqddoc.getDataAtRowProp(changes[i][0], "cnslqddoccof"));
                var lv_qty = parseFloat(<?= $lv_sec; ?>_lqddoc.getDataAtRowProp(changes[i][0], "cnslqddocqty"));
                var lv_rec = parseFloat(<?= $lv_sec; ?>_lqddoc.getDataAtRowProp(changes[i][0], "cnslqddocrec"));
                
                var lv_prc = lv_bar * lv_cof; // Unitario
                var lv_subtot = (lv_qty * lv_prc) + lv_rec; // Subtotal
                
                <?= $lv_sec; ?>_lqddoc.setDataAtRowProp(changes[i][0], "cnslqddocprc", lv_prc, "setting");
                <?= $lv_sec; ?>_lqddoc.setDataAtRowProp(changes[i][0], "cnslqddoctot", lv_subtot, "setting");
              }
              if(changes[i][1]=="cnslqddocrec"){
                var lv_qty = <?= $lv_sec; ?>_lqddoc.getDataAtRowProp(changes[i][0], "cnslqddocqty");
                var lv_prc = <?= $lv_sec; ?>_lqddoc.getDataAtRowProp(changes[i][0], "cnslqddocprc");
                var lv_rec = <?= $lv_sec; ?>_lqddoc.getDataAtRowProp(changes[i][0], "cnslqddocrec");
                if(lv_qty != null && lv_prc != null){ <?= $lv_sec; ?>_lqddoc.setDataAtRowProp( changes[i][0], "cnslqddoctot", lv_qty*lv_prc + lv_rec, "setting"); }
              }
            }
          	<?= $lv_sec; ?>_calcTotal();
          }
        }
      },  
      beforeRemoveRow: function(index, amount, logicalRows) {
        // me guardo todas las filas eliminadas (solo si tienen ID de registro)
        var lv_dat = <?= $lv_sec; ?>_lqddoc.getSourceData();
        for( var i=index; i<=index+amount-1; i++){
          if ( lv_dat[i]['cnslqddoccod']!='' && lv_dat[i]['cnslqddoccod']!=undefined ) {
            <?= $lv_sec; ?>_lqddoctmpdel.push( lv_dat[i] );
          }
        }
      },
      afterRemoveRow: function(index, amount){
        if (<?= $lv_sec; ?>_lqddoc!=undefined) {
          <?= $lv_sec; ?>_calcTotal();
        }
      }
    };
    var <?= $lv_sec; ?>_lqddoc;	

    // cargo datos en handsontable de Especialidades
    tmssLoadScript("handsontable",function(){
      <?= $lv_sec; ?>_lqddoc = new Handsontable(<?= $lv_sec; ?>_lqddoccnt, <?= $lv_sec; ?>_lqddocset);	
      var lv_dat = [<?php
        $lv_buffer='';
        $lv_dat = is_array($vew_data->cnslqddoc ?? null) ? $vew_data->cnslqddoc : [];
        if( count($lv_dat) ){
          foreach($lv_dat as $lv_row){
            $lv_obr = ($lv_row['stetxt'] ?? '') . ' (#' . ($lv_row['stecod'] ?? '') . ')';
            $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                          'cnslqddoccod: "'.($lv_row['cnslqddoccod']??'').'",'.
              						'stecodtxt: "'.$lv_obr.'",'.
            							'stecod: "'.($lv_row['stecod']??'').'",'.
              						'cnstskcod: "'.($lv_row['cnstskcod']??'').'",'.
                          'refobjtyp: "'.($lv_row['refobjtyp']??'').'",'.
                          'refobjcod001: "'.($lv_row['refobjcod001']??'').'",'.
                          'refobjcod002: "'.($lv_row['refobjcod002']??'').'",'.
                          'cnslqddocqty: "'.$lv_row['cnslqddocqty'].'",'.
                          'cnslqddocprc: "'.$lv_row['cnslqddocprc'].'",'.
                          'cnslqddocrec: "'.$lv_row['cnslqddocrec'].'",'.
                          'cnslqddoctot: "'.($lv_row['cnslqddoctot']??'').'",'.
                          'cnslqddocuntcod: "'.($lv_row['cnslqddocuntcod']??'').'",'.
              						'cnslqddocbar: "'.($lv_row['cnslqddocbar']??'').'",'.
              						'cnslqddoccof: "'.($lv_row['cnslqddoccof']??'').'",'.
                          'cnslqddocatr: "'.($lv_row['cnslqddocatr']??'').'",'.
                          'tskcodext: "'.($lv_row['cnstskcodext']??'').'",'.
                          'tsktxt: `'.utf8_decode($lv_row['cnstsktxt']??'').'`'.
                          '}'; 
          }
        }
        echo $lv_buffer;
      ?>];
      <?= $lv_sec; ?>_lqddoc.loadData( lv_dat );
      <?= $lv_sec; ?>_lqddoc.render();
    });

    function <?= $lv_sec; ?>_calcTotal() { 
      var lo_dat = <?= $lv_sec; ?>_lqddoc.getSourceData();
      var lv_tot = 0;
      for(let i=0; i<lo_dat.length; i++){
        lv_tot += Number(lo_dat[i].cnslqddoctot);
      }
      $("#<?= $lv_sec; ?> #cnslqdtot strong").text(numbro(lv_tot).format("0,0.00") );
    }
  </script>
	<script>		
		// slscus
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"custxt" : "custxt", "cuscod" : "cuscod", "slsprclstcod" : "slsprclstcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #custxt"), "slscus", lo_get );
	</script>
  <script>
    $("#<?= $lv_sec; ?> #btnupd").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm({
				title: "Actualizar Precios",
				message: "Desea actualizar los precios?",
				type: BootstrapDialog.TYPE_INFO,
				callback: function(result){
					if(result){	
						<?= $lv_sec; ?>_refreshPrices(0);
					}
				}
			});
		});
    
    function <?= $lv_sec; ?>_refreshPrices(lv_row) {
      if(<?= $lv_sec; ?>_lqddoc==undefined){ return false; }
      
      var lv_data = <?= $lv_sec; ?>_lqddoc.getSourceData();
      
      if (lv_row >= lv_data.length) {
        <?= $lv_sec; ?>_lqddoc.render();
        <?= $lv_sec; ?>_calcTotal();
        return;
      }
      
    	var rowData = lv_data[lv_row];
      var lv_pstdat = [ { name: "slsprclstcod", value: $("#<?= $lv_sec; ?> #slsprclstcod").val() },
                        { name: "slsprcsrctyp", value: "CNS_TSK" },
                        { name: "slsprclstdte", value: $("#<?= $lv_sec; ?> #cnslqddte").val() },
                        { name: "slsprcsrccod", value: rowData.cnstskcod},
                        { name: "currow", value: lv_row }
                    	];
      tmssCallProcessNoBackdrop("?prg=slsprclst&act=17", lv_pstdat, function(data){
        if (data.length > 0) {
          var slsprc = parseFloat(data[0].slsprc || 0);
          var prcqty = parseFloat(data[0].slsprcqty || 1);
          
          var newBar = slsprc / prcqty;
          var baremo = parseFloat(rowData.cnslqddocbar || 0);
          
          if (newBar !== baremo) {
            var cof = parseFloat(rowData.cnslqddoccof || 1);
            var rec = parseFloat(rowData.cnslqddocrec || 0);
            var cant = parseFloat(rowData.cnslqddocqty || 0); 

            var newPrc = newBar * cof;

            var newTot = (cant * newPrc) + rec;

            // Inyectamos valores
            <?= $lv_sec; ?>_lqddoc.setDataAtRowProp(lv_row, 'cnslqddocbar', newBar, "setting"); 
            <?= $lv_sec; ?>_lqddoc.setDataAtRowProp(lv_row, 'cnslqddocprc', newPrc, "setting");
            <?= $lv_sec; ?>_lqddoc.setDataAtRowProp(lv_row, 'cnslqddoctot', newTot, "setting");
          }
        }
        <?= $lv_sec; ?>_refreshPrices(lv_row + 1);
      });
    }
  </script>
  <script>
    // FILTRO PERSONALIZADO
		var lv_<?= $lv_sec; ?>_grdfltcod = "<?= $vew_data->vewfltcod; ?>";
		var gv_<?= $lv_sec; ?>_flt=[{'fldttl': '<?= $vew_lang->city; ?>','fldcod': 'a.adrtwn', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''}];

		// filtro - boton
		$("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
			tmssFilterShowDialog( gv_<?= $lv_sec; ?>_flt, <?= $lv_sec; ?>_fltcnslqd);
		});
    
    //Filtros
		function <?= $lv_sec; ?>_fltcnslqd(lp_flt) {
      var lv_fltint;
      
			if(lp_flt!=null){
				lv_fltint = tmssFilterParseToInternal(lp_flt);
				gv_<?= $lv_sec; ?>_flt = lp_flt;
				$("#<?= $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
			} else {
				lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
			}
			if(lv_fltint["maxrec"]==""){lv_fltint["maxrec"]="9999";}
      
			var lv_pstdat=[ {"name":"vewfldflt", "value": lv_fltint["fltstr"] },
                     	{"name":"cuscod", "value": $("#<?= $lv_sec; ?> #cuscod").prop("value")},
                      {"name":"cnslqdstrdte", "value":$("#<?= $lv_sec; ?> #cnslqdstrdte").prop("value") },
                      {"name":"cnslqdenddte", "value":$("#<?= $lv_sec; ?> #cnslqdenddte").prop("value") },
                      {"name":"sysdocclscod", "value":$("#<?= $lv_sec; ?> #sysdocclscod").prop("value") },
                      {"name":"cnslqdcod", "value":$("#<?= $lv_sec; ?> #cnslqdcod").prop("value") },
                      {"name":"evtlqd", "value": "<?= $lv_evtlqd; ?>" }
                    ];
			tmssCallProcess("?prg=cnslqd&act=23", lv_pstdat, function(data){
				var lv_dat = [];
				for (var stu in data["data"]) {
          var row = data["data"][stu];
          
          var lv_qty = row.cnslqddocqty || row.steevtdocqty || 0;
          var lv_bar = row.cnslqddocbar || row.slsprc / row.slsprcqty || 0;
          var lv_unt = row.cnslqddocuntcod || row.matuntcod || '';
          var lv_cof = row.cnslqddoccof || 1;
          var lv_rec = row.cnslqddocrec || 0;
          var lv_prc = row.cndlqddocprc || (lv_bar * lv_cof);
          var lv_tot = row.cnslqddoctot ? (row.cnslqddoctot) : (lv_qty * lv_prc + lv_rec);
          var lv_obr = (row.stetxt || '') + ' (#' + (row.stecod || '') + ')';
          
					lv_dat.push({	cnslqddoccod: row.cnslqddoccod || "",
                        stecodtxt: lv_obr,
                        stecod: row.stecod,
                       	cnstskcod: row.cnstskcod,
                        refobjtyp: row.refobjtyp || 'CNS_EVT_DOC',
                        refobjcod001: row.refobjcod001 || row.steevtdoccod,
                        refobjcod002: row.refobjcod002 || row.steevtcod,
												tskcodext: row.cnstskcodext,
												tsktxt: row.cnstsktxt,
												cnslqddocqty: lv_qty, 
												cnslqddocuntcod: lv_unt,
                        cnslqddocbar: lv_bar,
                        cnslqddoccof: lv_cof,
												cnslqddocrec: lv_rec,
												cnslqddocprc: lv_prc,
												cnslqddoctot: lv_tot   						
											});
				}
				<?= $lv_sec; ?>_lqddoc.loadData( lv_dat );
				<?= $lv_sec; ?>_lqddoc.render();
        
        <?= $lv_sec; ?>_calcTotal();
			});
		}
  </script>
  <script>
		$(function(e){ tmssHandsontableResize(); });

		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if (lp_prm["action"]=="00") {
				
				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_lqddoc.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
          if ( lo_dat[i]["tsktxt"]!="" && lo_dat[i]["tsktxt"]!=undefined ) {
            lv_arr.push({	"cnslqddoccod": lo_dat[i]["cnslqddoccod"],
                         	"stecod": lo_dat[i]["stecod"],
                          "refobjtyp": lo_dat[i]["refobjtyp"],
                          "refobjcod001": lo_dat[i]["refobjcod001"],
                          "refobjcod002": lo_dat[i]["refobjcod002"],
                          "cnslqddocqty": lo_dat[i]["cnslqddocqty"],
                          "cnslqddocuntcod": lo_dat[i]["cnslqddocuntcod"],
                          "cnslqddocbar": lo_dat[i]["cnslqddocbar"],
                          "cnslqddoccof": lo_dat[i]["cnslqddoccof"],
                          "cnslqddocprc": lo_dat[i]["cnslqddocprc"],
                          "cnslqddocrec": lo_dat[i]["cnslqddocrec"],
                          "cnslqddoctot": lo_dat[i]["cnslqddoctot"],
            						});
          }
        }
        
        // agrego las filas eliminadas
				for (var i=0; i< <?= $lv_sec; ?>_lqddoctmpdel.length; i++) {
          lv_arr.push({ "cnslqddoccod": <?= $lv_sec; ?>_lqddoctmpdel[i]["cnslqddoccod"],
                  			"deleted":"X"
              				});
        }
				
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #cnslqddoc").text("");
				} else {
					$("#<?= $lv_sec; ?> #cnslqddoc").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
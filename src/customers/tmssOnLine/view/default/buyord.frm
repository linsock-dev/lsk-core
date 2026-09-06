<?php
	// url del formulario 
  $lv_lnk = '?prg=buyord&prm_buyordcod='.$vew_data->buyordcod.'&prm_mdlcod='.$vew_data->mdlcod.'&prm_prgcod='.$vew_data->prgcod;
    
	// campos requeridos 
	$lv_reqfld = array('buyordtxt','buyorddte', 'curcod', 'curexcrte', 'docsts');
	if($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'srcobjtyp')!='') { array_push( $lv_reqfld, 'srcobjtyp','srcobjcod','srcobjtxt'); }
	if($vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'dstobjtyp')!='') { array_push( $lv_reqfld, 'dstobjtyp','dstobjcod','dstobjtxt'); }
	$vew_input->RequiredFields( $lv_reqfld );

	// clave del documento
	$lv_dockey = $vew_data->buyordcod;

	// titulo
	$lv_title = $vew_lang->document;

	// modulo y programa
	$lv_mdlcod = $vew_data->mdlcod;
	$lv_prgcod = $vew_data->prgcod;
	$lv_objtyp = $vew_data->mdlcod.'_'.$vew_data->prgcod;

	// libreria de estilos bootstrap
	include_once('_library.frm');

  // valores x default
	if ( $lv_dockey=='' && $vew_readonly==false ) {
		$vew_data->buyorddte = date('d/m/Y');
		$vew_data->docsts = 'A';
	}

	$lv_refdoccls = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'refdoccls');
	$lv_refdocmdt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'refdocmdt');
	$lv_matcodtxt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matcod_txt');
	$lv_docref = false;	// documento referencia a otro documento
	$lv_docrefsrc = false; // documento es referenciado por otro documento
	foreach($vew_data->buyordmat as $lv_row){
		if ($lv_row['docreftyp']!=''){ $lv_docref=true; }
		if ($lv_row['refposqty']!=''){ $lv_docrefsrc=true; }
	}

	$lv_rejarr = array(''=>'');
	foreach($vew_data->sysdoccls->sysdocclsrej as $lv_row) {
    $lv_rejarr[ $lv_row['sysdocrejcod'] ] = $lv_row['sysdocrejtxt'];
	}
	$lv_mat_sysdocclscod = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'stkmat_sysdocclscod');

	$lv_matcodfndseq =  $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matcodfndseq');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('lngcod','hidden','ES'); ?>
		<textarea class="hidden" id="buyordmat" name="buyordmat"></textarea>
    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->data; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->buyordcod; ?><?= gethtml('buyordcod','hidden',$vew_data->buyordcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= (strtoupper($lv_prgcod)=='REQ'?$vew_lang->requisition:(strtoupper($lv_prgcod)=='ORD'?$vew_lang->order:$lv_prgcod)); ?>
                    <span class="tmss-card-icon">
                      <span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
                    </span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    $lv_srcobjtyp = strtoupper($vew_doc->getTagValue( $vew_data->sysdoccls->sysdocclsatr, 'srcobjtyp' ));
                    if ($lv_srcobjtyp=='BUY_SUP'){
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->supplier,
                                                      'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>(($lv_docref || $lv_docrefsrc) && $vew_data->srcobjcod!=''?true:$vew_readonly) ),
                                                                          array('input'=>gethtml('srcobjtxt', 'typeahead', $vew_data->srcobjtxt,(($lv_docref || $lv_docrefsrc) && $vew_data->srcobjcod!=''?$lv_always_disabled:$lv_default) ) ))
                                                      ));
                    }
                    echo gethtml('srcobjtyp','hidden',($vew_data->buyexpcod!=''?$vew_data->srcobjtyp:$vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'srcobjtyp')) );  
                  	echo gethtml('srcobjcod','hidden',$vew_data->srcobjcod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('buyordtxt', 'doccmt1x50', $vew_data->buyordtxt, $lv_default) ));
                  ?>
                </div>
              </div> <!-- /card -->
						</div> <!-- /col -->
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?php if($vew_data->sysdoctrecod=='N'){ ?><span><i class="far fa-circle"></i> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod=='P'){ ?><span class="text-warning"><i class="far fa-circle-half-stroke"></i> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod=='C'){ ?><span class="text-success"><i class="fas fa-circle"></i> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod==''){ echo '&nbsp;'; } ?>
                  	<span class="tmss-card-icon">
                      <?= '<b><span id="buyordtotlbl">'.number_format(floatval($vew_data->buyordtotamt),2).'</span></b>'?>
                      <!-- VISUALIZAR. solo se puede modificar la moneda si la actividad es 01-02 -->
                      <?php if (($vew_actcod=='02' || $vew_actcod=='01') && $lv_prgcod=='ord'){ ?>
                      	<a href="#" id="btncurchg" class="cursor:pointer"><?=strtolower($vew_data->curcod); ?></a>
                      <?php } else { ?>
                        <span><?= strtolower($vew_data->curcod); ?></span>
                      <?php } ?>
                      <?= gethtml('curcod', 'hidden', $vew_data->curcod); ?>
                      <?= gethtml('buyordtot','hidden',floatval($vew_data->buyordtotamt)); ?>
											<?= gethtml('curexcrte','hidden',''); ?>
                    </span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">                
									<?= vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('buyorddte',	'docdte',	$vew_data->buyorddte,	$lv_default) )); ?>
									<?= vew_boot($lv_col210, array('label'=>$vew_lang->number, 'input'=>gethtml('buyordcodext', 'doccmt1x50', $vew_data->buyordcodext, $lv_default) )); ?>
									<?= vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) )); ?>
                </div>
              </div> <!-- /card -->
						</div> <!-- /col -->
					</div> <!-- /row -->

          <div class="col-md-12">
            <div class="row">         
              <div class="card tmss-hot-ttl">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->materials ?>
                    <?php if ($lv_refdoccls!='') { ?><a href="#" id="btndocref" class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" title="<?= $vew_lang->reference; ?>"><i class="fas fa-plus"></i></a><?php } ?>
                  </div>
                </div>
								<div id="buyordmathot" name="buyordmathot"></div>
              </div>      
            </div> <!-- /row -->
          </div> <!-- /col -->
				</div> <!-- fin tab001 -->

				<!-- DATOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->conditions ; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->paymentstermshort, 'input'=>vew_boot(array('style'=>'search','readonly'=>$vew_readonly), array('input'=>gethtml('paytrmtxt', 'typeahead', $vew_data->paytrmtxt, $lv_default) )) ));
                    echo gethtml('paytrmcod', 'hidden', $vew_data->paytrmcod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->costcenter, 'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly ), array('input'=>gethtml('fincectxt', 'typeahead', $vew_data->fincectxt,$lv_default ) )) ));
                    echo gethtml('finceccod','hidden',$vew_data->finceccod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->exchangerate,	'input'=>gethtml('curexcrte', 'docnum0905', $vew_data->curexcrte, $lv_always_disabled) ));
                  ?>
                </div>
              </div> <!-- /card -->
						</div> <!-- /col -->
						<div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->validity; ?></div></div>
                <div class="card-body tmss-card-body-edit">
									<?php
                    echo vew_boot($lv_col2424, array('label'=>$vew_lang->from, 'input1'=>gethtml('buyordstrdte',	'docdte',	$vew_data->buyordstrdte,	$lv_default), 'label2'=>$vew_lang->to, 'input2'=>gethtml('buyordenddte',	'docdte',	$vew_data->buyordenddte,	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->rejection, 'input'=>gethtml('sysdocrejcod', $lv_rejarr, $vew_data->sysdocrejcod, $lv_default, true) ));
                  ?>
                </div>
              </div> <!-- /card -->
            </div> <!-- /col -->
					</div> <!-- /row -->
				</div> <!-- /tab002 -->
        
			</div> <!--tabcontent -->
		</div> <!-- container-fluid -->
  </form>
  <!-- DATOS ADICIONALES -->
  <div id="rowfrm" class="hidden">
		<form class="form-horizontal tmss-form-horizontal pt-0 pb-0">
      <?php
        echo vew_boot($lv_col210, array('label'=>$vew_lang->purchasetext,	'input'=>gethtml('rowbuyordmatbuytxt',	'doccmt1x50', '', $lv_default) ));
        echo vew_boot($lv_col210, array('label'=>$vew_lang->rejection,	'input'=>gethtml('rowbuyordmatrejcod', $lv_rejarr, '', $lv_default) ));
      ?>
		</form>
	</div>
  <script>
    // Funcionaliadad al modificar una moneda
    $("#<?= $lv_sec; ?> #btncurchg").on("click", function(e) { e.preventDefault();
      tmssPopup("Monedas","?prg=admcur&prm_vewcod=VEW_ADM_CUR_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[curcod:curcod]&prm_fldflt=[c.docsts:a]",function(){
        // Se guarda el valor de la moneda
        $("#<?= $lv_sec; ?> #btncurchg").text($("#<?= $lv_sec; ?> #curcod").val());
        <?= $lv_sec; ?>_actualizarTipoCambio();
      });
    });
    // Se actualiza automaticamente el tipo de cambio si se cambia la fecha
		$("#<?= $lv_sec; ?> #buyorddte").on("change", function() {
  		<?= $lv_sec; ?>_actualizarTipoCambio();
		});
    
    // Acutalizar el tipo de cambio
    function <?= $lv_sec; ?>_actualizarTipoCambio() {
    	var lv_pstdat = [
      					{ name: "curcodsrc", value: $("#<?= $lv_sec; ?> #curcod").val() }, // Moneda
      					{ name: "excrtedtefrm", value: $("#<?= $lv_sec; ?> #buyorddte").val() }, // Fecha
      					{ name: "excrteclscod", value: "<?= $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr, 'excrteclscod'); ?>" },
      					{ name: "excrteclscodext", value: "CPA" } // Código externo por default
    	];
      //obtiene el tipo de cambio segun la moneda y la fecha de cabecera
      tmssCallProcess("?prg=finexcrte&act=19", lv_pstdat, function(data){
        var lv_curexcrte= (data.finexcrte != null ? data.finexcrte : "");
        $("#<?= $lv_sec; ?> #curexcrte").prop("value",lv_curexcrte);
        if(data.finexcrte == null){
          toastr.warning("No se puede determinar el tipo de cambio a " + lv_pstdat[0]["value"]);
        }
      });
    }
  </script>
	<script>
		// calcula totales de grilla
		function <?= $lv_sec; ?>_calcTotal(lp_hot) {
			var lst_buyordmattot = lp_hot.getDataAtProp("mattot");
			var lv_buyordmattot = 0;
			lst_buyordmattot.forEach(function(element) {
				lv_buyordmattot+=Number(element);
			});
			$("#<?= $lv_sec; ?> #buyordtotlbl").text( numbro(lv_buyordmattot).format("0,0.00") );
			$("#<?= $lv_sec; ?> #buyordtot").prop("value",lv_buyordmattot);
		}

		/**
		 *
		 *	M A T E R I A L E S
		 *
		 */
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
				var lv_ro_color = "#F1F1F1";
				var lv_color = "#FFFFFF";

				// esta linea referencia a otro documento
				var lv_docref = false;
				var lv_docreftyp = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"docreftyp");

				// esta linea es referenciada por otro documento
				var lv_docrefqty = false;
				var lv_docrefminqty = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"docrefminqty");
				if ( (lv_docrefminqty==null?"":lv_docrefminqty.toString())!="" ) { lv_docrefqty = true; }

				var lv_ro = <?=($vew_readonly?'true':'false'); ?>;
				var lv_sysdocrejcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"sysdocrejcod");
				lv_sysdocrejcod = (lv_sysdocrejcod==null || lv_sysdocrejcod==""?"0":lv_sysdocrejcod);

				if ( prop=="matqty" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro || lv_docref ?lv_ro_color:lv_color);
					cellProperties.readOnly = (lv_ro || lv_docref ?true:false);
				} else if ( prop=="matprc" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro || lv_docref || lv_docrefqty?lv_ro_color:lv_color);
					cellProperties.readOnly = (lv_ro || lv_docref || lv_docrefqty?true:false);
				} else if ( prop=="mattot" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
					td.style.backgroundColor = lv_ro_color;
					cellProperties.readOnly = true;
				} else if ( prop=="icn" ) {
					var lv_btn = "<a href='#' onclick='<?= $lv_sec; ?>_showDetails("+row+");' class='btn "+(lv_sysdocrejcod!="0"?"btn-danger":"btn-default")+" btn-sm'><span class='fa fa-ellipsis-h'></span></a>";
					$(td).empty().append(lv_btn);
					td.style.backgroundColor = lv_ro;
				} else if ( prop=="matcodext" ) {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = lv_ro_color
					cellProperties.readOnly = true;
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro || lv_docref || lv_docrefqty?lv_ro_color:lv_color);
					cellProperties.readOnly = (lv_ro || lv_docref || lv_docrefqty?true:false);
				}
			}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #buyordmathot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly || $lv_refdocmdt!=''?'0':'1') ?>,
			colHeaders: [ "<?= $vew_lang->material ?>", "<?= $vew_lang->code ?>", "<?= $vew_lang->description ?>", "<?= $vew_lang->quantity ?>", "<?= $vew_lang->um ?>", "<?= $vew_lang->import ?>", "<?= $vew_lang->subtotal ?>", "" ],
			columns: [
				{type: "text", data: "matcod", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
        {type: "text", data: "matcodext", renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true },
				{type: "autocomplete", data: "mattxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						if ( query.length>1 && <?= $lv_sec; ?>_hot_paste!=true ) {
							$.ajax({ 
								url: "?prg=stkmat&act=17", dataType: "json", data: { prm_mattxt: query <?=($lv_mat_sysdocclscod!=''?', prm_sysdocclscod: "'.$lv_mat_sysdocclscod.'"':''); ?>},
                success: function (response) {
                  <?= $lv_sec; ?>_autocompleteCache = response.data || [];
                  const items = <?= $lv_sec; ?>_autocompleteCache.map(item => item.mattxt);
                  process(items);
                },
                error: function () {
                  <?= $lv_sec; ?>_autocompleteCache = [];
                  process([]);
                }
							});
						} else {
              process( [query] );
							<?= $lv_sec; ?>_hot_paste = false;
						}
					},
					strict: true
				},
				{type: "numeric", data: "matqty", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "matuntcod", width: 20, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
				{type: "numeric", data: "matprc", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "mattot", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "icn", width: 18, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true }
			],
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["docrefsrcqty"]!="" && lv_dat[i]["docrefsrcqty"]!=undefined ) {
						toastr.warning("No se pueden borrar posiciones que estan referenciadas por otros documentos.");
						return false;
					} else if ( lv_dat[i]["buyordmatcod"]!="" && lv_dat[i]["buyordmatcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
					var lv_found=0;
					var lv_newinx;
					for( var x=<?= $lv_sec; ?>_hotdocerr.length-1; x>=0; x-- ) {
						if( <?= $lv_sec; ?>_hotdocerr[x].endsWith("_"+i.toString()) ){
							<?= $lv_sec; ?>_hotdocerr.splice(x,1);
							lv_found=1;
						} else if(lv_found==0) {
							lv_newinx = <?= $lv_sec; ?>_hotdocerr[x].split("_");
							lv_newinx[1] = Number(lv_newinx[1])-1;
							<?= $lv_sec; ?>_hotdocerr[x] = lv_newinx[0]+"_"+lv_newinx[1].toString();
						}
					}
				}
			},
			afterChange: function(changes, source) {
        if (!<?= $lv_sec; ?>_hotdoc) return;
        
        if (source === 'loadData') {
					<?= $lv_sec; ?>_calcTotal(<?= $lv_sec; ?>_hotdoc);
					return;
				}
        
        if (source === 'autocomplete' || source === 'calc' || <?= $lv_sec; ?>_hot_autocomplete === true) {
          <?= $lv_sec; ?>_calcTotal(<?= $lv_sec; ?>_hotdoc);
          return;
        }
        
        if (source === 'edit' || source === 'CopyPaste.paste') {
          for (var i = 0; i < changes.length; i++) {
            var row = changes[i][0];
            var valueSelected = changes[i][3] || "";
            
            if (source == "CopyPaste.paste" && typeof valueSelected === 'string') {
              valueSelected = valueSelected.replace('\r', "");
            }

            if (changes[i][1] === "mattxt") {
              if (valueSelected === "") {
                <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matcod", "");
              } else {
                var selectedItem = <?= $lv_sec; ?>_autocompleteCache.find(item => item.mattxt === valueSelected);
                if (selectedItem) {
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matcod", String(selectedItem.matcod), 'autocomplete');
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matcodext", String(selectedItem.matcodext || ""), 'autocomplete');
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matuntcod", String(selectedItem.matuntcod), 'autocomplete');
                  if(!<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"matqty")){
                    changes.push([ row, "matqty", "", 1]);
                  }
                  <?= $lv_sec; ?>_hot_autocomplete = true;
                  } else {
                  if ("<?= $lv_matcodtxt; ?>" != "") {
                    <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matcod", "<?= $lv_matcodtxt ?>", 'autocomplete');
                    <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "matuntcod", "UN", 'autocomplete');
                    <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(row, "buyordmatbuytxt", valueSelected, 'autocomplete');
                  }
                }
              }
            } else if (changes[i][1] === "matcod" && <?= $lv_sec; ?>_hot_autocomplete != true) {
          
              var lv_pstdat =[{name:"matcodfndseq",value:"<?= $lv_matcodfndseq; ?>"}, {name:"row",value:row}];
              lv_pstdat.push( {name:"matcodext",value:valueSelected} );
              tmssCallProcessNoBackdrop("?prg=stkmat&act=19", lv_pstdat, function(data){
                if (data.row!=undefined) {
                  <?= $lv_sec; ?>_hot_paste = true;
                  var lv_row = data.row;
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"matcod", data.data["matcod"], "edit.matcod" );
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"matcodext", (data.data["matcodext"]!=undefined?data.data["matcodext"]:""), "autocomplete" );
                  if("<?=$lv_matcodtxt?>"!=data.data["matcod"])<?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"mattxt", data.data["mattxt"], "autocomplete" );
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"matqty", (data.data["matqty"]!=undefined?data.data["matqty"]:"1"), "autocomplete" );
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"matuntcod", (data.data["matuntcod"]!=undefined?data.data["matuntcod"]:""), "autocomplete" );
                }
              });
          	}
          
            if (changes[i][1] === "matqty" || changes[i][1] === "matprc") {
              var lv_qty = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row, "matqty");
              var lv_prc = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row, "matprc");
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( row, "mattot", lv_qty*lv_prc );
            }
          }
        }
        <?= $lv_sec; ?>_hot_autocomplete = false;
        <?= $lv_sec; ?>_calcTotal(<?= $lv_sec; ?>_hotdoc);
      },
      afterValidate: function( isValid, value, row, prop, source) {
        if(!isValid && "<?= $lv_matcodtxt ?>" != "" && prop == "mattxt"){
          return true;
        } 
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotdocerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotdocerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotdocerr.splice(lv_inx,1); }
				} 
			},
			afterRemoveRow: function(index, amount){
				if (<?= $lv_sec; ?>_hotdoc!=undefined) {
					<?= $lv_sec; ?>_calcTotal(<?= $lv_sec; ?>_hotdoc);
        }
			},
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotdoc;

		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->buyordmat as $lv_row){
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'buyordmatcod:"'.$lv_row['buyordmatcod'].'",'.
												'matcod:"'.$lv_row['matcod'].'",'.
												'matcodext:"'.$lv_row['matcodext'].'",'.
												'mattxt:`'.$lv_row['mattxt'].'`,'.
												'matqty: '.$lv_row['matqty'].' ,'.
												'matuntcod:"'.$lv_row['matuntcod'].'",'.
												'matprc: '.$lv_row['matprc'].' ,'.
												'mattot: '.($lv_row['matqty']*$lv_row['matprc']).' ,'.
												'buyordmatbuytxt:`'.(utf8_decode(html_entity_decode($vew_doc->getTagValue($lv_row['buyordmatatr'],'buyordmatbuytxt')))).'`,'.
												'docreftyp:"'.$lv_row['docreftyp'].'",'.
												'docrefcod:"'.$lv_row['docrefcod'].'",'.
												'docrefposcod:"'.$lv_row['docrefposcod'].'",'.
												'sysdocrejcod:"'.$lv_row['sysdocrejcod'].'",'.
												($lv_row['refposqty']!=''?'docrefsrcqty: '.abs($lv_row['refposqty']-$lv_row['matqty']).',':'').
												($lv_row['refposqty']!=''?'docrefminqty: '.$lv_row['refposqty'].',':'').
												($lv_row['refposqty']!=''?'docrefminqtysrc: '.$lv_row['matqty']:'').
												'}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
			<?= $lv_sec; ?>_calcTotal(<?= $lv_sec; ?>_hotdoc);
		});
	</script>
	<script>
    // paytrmtxt - typeahead
		var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"docsts" : "A", "paytrmgrp" : "(like)A"}, "fldasg" : {"paytrmtxt" : "paytrmtxt", "paytrmcod" : "paytrmcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #paytrmtxt"), "finpaytrm", lo_get);
		
    // srcobjtxt
    <?php if ($lv_srcobjtyp=='BUY_SUP'){ ?>
    	var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"s.docsts" : "A"}, "fldasg" : {"srcobjtxt":"suptxt", "srcobjcod":"supcod", "paytrmcod":"paytrmcod", "paytrmtxt":"paytrmtxt"}};
    	tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "buysup", lo_get );
    <?php } ?>

		// fincectxt
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"c.docsts" : "A"}, "fldasg" : {"fincectxt":"fincectxt", "finceccod":"finceccod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #fincectxt"), "fincec", lo_get );
  </script>
	<script>
		// AGREGAR REFERENCIA
		$("#<?= $lv_sec; ?> #btndocref").on("click",function(e){ e.preventDefault(); 
			if ( $("#<?= $lv_sec; ?> #srcobjcod").prop("value")=="" ) {
				toastr.warning("Debe indicar el origen.");
				$("#<?= $lv_sec; ?> #srcobjtxt").focus();
			} else {
				// obtengo los IDs de los documentos referenciados previamente y que no hayan sido grabados
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_refarr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( (lo_dat[i]["slsordmatcod"]==undefined?"":lo_dat[i]["slsordmatcod"])=="" && (lo_dat[i]["docreftyp"]==undefined?"":lo_dat[i]["docreftyp"])!="" ) {
						lv_refarr.push({"srcobjtyp":lo_dat[i]["docreftyp"],
													"srcobjcod":lo_dat[i]["docrefcod"],
													"srcposcod":lo_dat[i]["docrefposcod"],
													"refposqty":lo_dat[i]["matqty"]
												});
					}
				}
				// cargo la pantalla de referencia
				var lv_dat = "";
				tmssCallProcess("?prg=grldocflw&act=01",{sysdocclscod: "<?= $vew_data->sysdoccls->sysdocclscod; ?>",refobjtyp: "<?= $lv_objtyp; ?>",refobjcod: "<?= $vew_data->srcobjcod; ?>",fndobjtyp: $("#<?= $lv_sec; ?> #srcobjtyp").prop("value"),fndobjcod: $("#<?= $lv_sec; ?> #srcobjcod").prop("value"),fndobjtxt: $("#<?= $lv_sec; ?> #srcobjtxt").prop("value"),fndcntcod: $("#<?= $lv_sec; ?> #srccntcod").prop("value"),fndcnttxt: $("#<?= $lv_sec; ?> #srccnttxt").prop("value"),refarr: JSON.stringify(lv_refarr)},function(data){
					var lv_objtxt = $("#<?= $lv_sec; ?> #srcobjtxt").prop("value");
					var lv_cnttxt = $("#<?= $lv_sec; ?> #srccnttxt").prop("value");
					BootstrapDialog.show({
						size: BootstrapDialog.SIZE_WIDE,
						title: "Agregar Referencia - <?= $vew_data->sysdoccls->sysdocclstxt; ?> ("+lv_objtxt+(lv_cnttxt==""?"":" / "+lv_cnttxt)+") ",
						message: $(data),
						buttons: [{ label: "Cancelar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
											{	label: "Agregar", cssClass: "btn-success",	action: function(dialogItself){
												if ( dialogItself.getModalBody().find("#rowchk:checked").length==0 ) {
													toastr.warning("Debe indicar al menos una posción de referencia.");
												} else if ( dialogItself.getModalBody().find("form")[0].checkValidity()==false ) {
													toastr.warning("Las cantidades a referenciar no pueden ser cero ni exceder el saldo a referenciar.");
													dialogItself.getModalBody().find("input").each( function(e) {
														if ( !$(this)[0].validity.valid ) { $(this).parent().addClass("has-error"); }
													});
												} else {
													var lv_data = <?= $lv_sec; ?>_hotdoc.getSourceData();
                          if(lv_data.length != 0){
                            if(lv_data[lv_data.length-1].mattxt == undefined){
                              lv_data.splice( lv_data.length-1, 1 );
                            }else{
                              lv_data.splice( lv_data.length, 1 );
                            } 
                          }													
													dialogItself.getModalBody().find("#rowchk:checked").each(function(e){
														var lv_doccod = $(this).data("doccod");
														var lv_poscod = $(this).data("docposcod");
														var lv_qty = dialogItself.getModalBody().find("#"+lv_doccod+ "_"+lv_poscod+"_qty").prop("value");
														var lv_dat = dialogItself.getModalBody().find("#"+lv_doccod+ "_"+lv_poscod+"_data").text();
														var lo_dat = JSON.parse( lv_dat );
														lv_data.push({"docreftyp":lo_dat["doctyp"],
																				"docrefcod":lo_dat["doccod"],
																				"docrefposcod":lo_dat["docposcod"],
																				"matcod":lo_dat["matcod"],
																				"matcodext":lo_dat["matcodext"],
																				"mattxt":lo_dat["mattxt"],
																				"matqty":Number(lv_qty),
																				"matuntcod":lo_dat["matuntcod"],
																				"matprc":Number(lo_dat["matprc"]),
																				"mattot":Number(lo_dat["matprc"]*lv_qty),
																				"matprcref":Number(lo_dat["matprc"])
																			});
													});
													<?= $lv_sec; ?>_hotdoc.loadData( lv_data );
													<?= $lv_sec; ?>_refreshAllPrices();
													<?= $lv_sec; ?>_calcTotal( <?= $lv_sec; ?>_hotdoc );
                          
													dialogItself.close();
												}
											}
										}]
					});	
				});
			}
		});
	</script>
	<script>
		function <?= $lv_sec; ?>_showDetails( lv_row ) {
			var lv_id = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row,"buyordmatcod");
			BootstrapDialog.show({
				title: "Datos Adicionales <small>#"+lv_id+"</small>",
				message: $("#<?= $lv_sec; ?> #rowfrm > form").clone(),
				type: BootstrapDialog.TYPE_INFO,
				buttons: [{ label: "Cancelar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
									{	label: "OK", cssClass: "btn-primary",	action: function(dialogItself){
										<?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"buyordmatbuytxt",dialogItself.getModalBody().find("#rowbuyordmatbuytxt").val());
										<?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"sysdocrejcod",dialogItself.getModalBody().find("#rowbuyordmatrejcod").val());
										dialogItself.close();
									}
								}],
				onshow: function(dialog) {
					// asigno valores de la grilla
					var lv_frm = $(dialog.$modalContent);
					$(lv_frm).find("#rowbuyordmatbuytxt").prop("value", <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row,"buyordmatbuytxt") );
					$(lv_frm).find("#rowbuyordmatrejcod").prop("value", <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row,"sysdocrejcod") );
				}
			});
		}
	</script>
  <script>
    // server response
    function <?= $lv_sec; ?>_fncextbck( data ) {
			try {
				//var lv_xml = $.parseXML( "< ?xml version='1.0' encoding='utf-8'? ><xmldata>" + data + "</xmldata>" );
				var lv_errcod = data.errcod; //$(lv_xml).find("errcod").eq(0).text();
				var lv_errrow = data.errrow; //$(lv_xml).find("row").eq(0).text();
				if ( lv_errcod!="0" && lv_errrow!="" ) {
					<?= $lv_sec; ?>_hotdoc.setCellMeta( Number(lv_errrow), 2, "valid", false);
				}
				<?= $lv_sec; ?>_hotdoc.render();
			} catch (e) {}
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    }

		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al borrar
			<?php if ($lv_docrefsrc==true) { ?>
			if ( lp_prm["action"]=="04" ) {
				toastr.warning("No se puede borrar el documento. Una o mas posiciones han sido referenciadas por otros documentos.");
				return false;
			}
			<?php } ?>

			// al grabar
			if ( lp_prm["action"]=="00" ) {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }

				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
        var lv_arr_error = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["matcod"]!="" && lo_dat[i]["matcod"]!=undefined ) {
            // Que el total referenciado debe ser menor o igual a la cantidad que estoy queriando grabar del material 
            if(lo_dat[i]["docrefsrcqty"]==undefined || lo_dat[i]["matqty"] >= lo_dat[i]["docrefsrcqty"]){
							lv_arr.push({	"buyordmatcod":lo_dat[i]["buyordmatcod"],
													"matcod":lo_dat[i]["matcod"],
													"mattxt":lo_dat[i]["mattxt"],
													"matqty":lo_dat[i]["matqty"],
													"matuntcod":lo_dat[i]["matuntcod"],
													"matprc":lo_dat[i]["matprc"],
													"curcod":lo_dat[i]["curcod"],
													"mattot":lo_dat[i]["mattot"],
													"buyordmatbuytxt":lo_dat[i]["buyordmatbuytxt"],
													"docreftyp":lo_dat[i]["docreftyp"],
													"docrefcod":lo_dat[i]["docrefcod"],
													"docrefposcod":lo_dat[i]["docrefposcod"],
													"sysdocrejcod":lo_dat[i]["sysdocrejcod"]
												});
          	}
            else{
              lv_arr_error.push(i);
              //pintar las celdas de color rojo que esten dentro del array
              <?= $lv_sec; ?>_hotdoc.setCellMeta(i, <?= $lv_sec; ?>_hotdoc.propToCol("matqty"), "valid", false); 
            }
					}
				}
        
        // verifico error
        if(lv_arr_error.length > 0){
          <?= $lv_sec; ?>_hotdoc.render();
          // mensaje
          toastr.warning("No puede indicar una cantidad menor a lo ya referenciado");
          return false;
        }
        
				// agrego las filas eliminadas
				for (var i=0; i< <?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({ "buyordcod": $("#<?= $lv_sec; ?> #buyordcod").prop("value"),
												"buyordmatcod": <?= $lv_sec; ?>_hotdocdel[i]["buyordmatcod"],
												"docreftyp":<?= $lv_sec; ?>_hotdocdel[i]["docreftyp"],
												"docrefcod":<?= $lv_sec; ?>_hotdocdel[i]["docrefcod"],
												"docrefposcod":<?= $lv_sec; ?>_hotdocdel[i]["docrefposcod"],
												"matqty":<?= $lv_sec; ?>_hotdocdel[i]["matqty"],
												"matuntcod":<?= $lv_sec; ?>_hotdocdel[i]["matuntcod"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #buyordmat").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #buyordmat").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
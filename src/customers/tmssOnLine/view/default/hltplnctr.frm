<?php
	// url del formulario
  $lv_lnk = '?prg=hltplnctr'.($vew_data->hltplnctrcod? '&prm_hltplnctrcod='.$vew_data->hltplnctrcod:'').($vew_data->plnid? '&prm_plnid='.$vew_data->plnid:'');

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = $vew_data->hltplnctrcod.$vew_data->plnid; 

	// titulo
	$lv_title = $vew_lang->control;
	
	// modulo y programa
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PCR'; 

	// libreria de estilos bootstrap
	include_once('_library.frm');
	
	if( $vew_data->docsts=='C' ) {
		$lv_default2 = $lv_always_disabled;
		$vew_readonly2 = true;
	} else {
		$lv_default2 = $lv_default;
		$vew_readonly2 = $vew_readonly;
	}
	
	// tipo de especialidad
	$lv_spcctrtyp = $vew_data->spcctrtyp;

	// fecha de planificación: deriva año/mes desde plndte (DateTime), null-safe
	$lv_plndteobj = ($vew_data->plndte instanceof DateTimeInterface) ? $vew_data->plndte : null;
	$lv_plnyth = $lv_plndteobj ? $lv_plndteobj->format('Y') : '';
	$lv_plnmth = $lv_plndteobj ? $lv_plndteobj->format('n') : '';

	// botones por vista
  $vew_tbl['new'] = array('per'=>false);
  $vew_tbl['cpy'] = array('per'=>false);
	$vew_tbl['btnaccdelL'] = array ('id'=>'btnaccdelL', 'pos'=>'L', 'per'=>$vew_data->docsts=='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'29'), 'acc'=>'', 'ttl'=>$vew_lang->cancel, 'icn'=>'far fa-file-circle-xmark', 'css'=>'btn btn-danger navbar-btn tmss-navbar-btn tmss-desk-btn tmssAlwaysEnabled tmssHiddeOnEdit');
  $vew_tbl['btnaccdelR'] = array ('id'=>'btnaccdelR', 'pos'=>'R', 'per'=>$vew_data->docsts=='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'29'), 'acc'=>'', 'ttl'=>$vew_lang->cancel, 'icn'=>'far fa-file-circle-xmark', 'css'=>'btn btn-danger navbar-btn tmss-navbar-btn tmss-mob-btn tmssAlwaysEnabled tmssHiddeOnEdit');
	$vew_tbl['accL'] = array('per'=> ($vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'09') && $vew_data->hltplnctrcod!='' && $vew_data->docsts!='C'), 'acc'=>'');
	$vew_tbl['accR'] = array('per'=> ($vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'09') && $vew_data->hltplnctrcod!='' && $vew_data->docsts!='C'), 'acc'=>'');
  $vew_tbl['modL'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02') && $vew_data->docsts!='C');
  $vew_tbl['modR'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02') && $vew_data->docsts!='C');
  $vew_tbl['del'] = array('per'=>($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly && $vew_data->hltplnctrcod && $vew_data->docsts!='C'));
  $vew_tbl['delsep'] = array('per'=>($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly && $vew_data->hltplnctrcod && $vew_data->docsts!='C'));
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?php
    	echo gethtml('tmss_actcod', 'hidden', '');
    	echo gethtml('hltplnctrcod', 'hidden', $vew_data->hltplnctrcod);
    	echo gethtml('plnyth', 'hidden', $lv_plnyth);
    	echo gethtml('plnmth', 'hidden', $lv_plnmth);
    	echo gethtml('docsts', 'hidden', $vew_data->docsts);
    	echo gethtml('plnflt', 'hidden', '');
    	echo gethtml('vewmaxrec', 'hidden', '');
    	echo gethtml('vewfldflt', 'hidden', '');
    ?>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<?php if($vew_data->hltplnctrcod){ ?> <li class="pull-right"><h4># <strong><?= $vew_data->hltplnctrcod; ?></strong></h4></li> <?php } ?>
			</ul>
      
			<div class="tab-content tmss-tab-content">
        
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">

					<div class="card">
						<div class="card-header"><div class="card-title"><?= $vew_lang->Control; ?></div></div>
						<div class="card-body tmss-card-body-edit">
							<div class="col-md-5">
								<?php
									echo vew_boot($lv_col210, array('label'=>$vew_lang->period, 'input'=>gethtml('', 'doccod', ($lv_plndteobj ? $lv_plndteobj->format('m.Y') : ''), $lv_always_disabled) ));
									echo vew_boot($lv_col210, array('label'=>$vew_lang->specialty, 'input'=>gethtml('spctxt', 'spctxt', $vew_data->spctxt, $lv_always_disabled) ));
									echo gethtml('spccod', 'hidden', $vew_data->spccod);
								?>
							</div>
							<div class="col-md-4">
								<?php
									echo vew_boot($lv_col210, array('label'=>$vew_lang->customer, 'input'=>gethtml('custxt', 'doccmt1x50', $vew_data->custxt, $lv_always_disabled) ));
									echo gethtml('cuscod', 'hidden', $vew_data->cuscod);	
									echo vew_boot($lv_col210, array('label'=>$vew_lang->patient, 'input1'=>gethtml('pattxt', 'pattxt', $vew_data->pattxt, $lv_always_disabled) ));
									echo gethtml('patcod', 'hidden', $vew_data->patcod);
								?>
							</div>
							<div class="col-md-3">
								<?php
									echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docstsacc', $vew_data->docsts, $lv_always_disabled) )); 
								?>
							</div>
						</div>
					</div> <!-- /card -->

					<div class="card tmss-hot-ttl">
					 <div class="card-header">
						 <div class="card-title"><?= $vew_lang->Sessions; ?>                   	
							 <!--Filtro-->
							 <a id="btnflt" class="card-icon" title="<?= $vew_lang->filter; ?>"><i class="fas fa-filter"></i><span id="fltcnt" class="badge"></span></a>
							 <?php if($vew_actcod=='02'){ ?>
								 <a id="btnctrall" class="card-icon" title="<?= $vew_lang->control; ?>" data-act="confirm"><i class="fas fa-check"></i></a> 
								 <a id="btncncall" class="card-icon" title="<?= $vew_lang->cancel; ?>" data-act="cancel"><i class="fas fa-ban"></i></a>
							 <?php } ?>
							</div>
						</div>
					</div>
					<textarea class="hidden" id="hltplncrtdte" name="hltplncrtdte"></textarea>
					<div id="hltplncrthot" name="hltplncrthot"></div>		
					<div id="datqty"></div>
					
				</div> <!-- /_tab001 -->
	
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
  <?php if($vew_actcod=='02'){ ?>
  <script>
    $("#<?= $lv_sec; ?> #btncncall, #<?= $lv_sec; ?> #btnctrall").on("click", function(e){ e.preventDefault();
      var lv_length = <?= $lv_sec; ?>_hotplnctr.countRows()-1;
      for(var i = 0 ; i < lv_length ; i++){
        <?= $lv_sec; ?>_hotplnctr.setDataAtRowProp(i, <?= $lv_sec; ?>_hotplnctr.propToCol($(this).data("act")), "X", "");
        <?= $lv_sec; ?>_hotplnctr.setDataAtRowProp(i, <?= $lv_sec; ?>_hotplnctr.propToCol($(this).data("act") == "cancel"?"confirm":"cancel"), "", "");
      }
    });
  </script>
  <?php } ?>
	<script>
		//C O N T R O L
		var <?= $lv_sec; ?>_hotplnctr_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      var lv_ro = <?php echo($vew_readonly?'true':'false'); ?>;
      cellProperties.readOnly = (lv_ro?true:false);
      td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
      if ( prop=="hltplnctrtme" || prop=="hltplnctrqty") {
        Handsontable.renderers.NumericRenderer.apply(this, arguments);
        if(prop=="hltplnctrtme"){
          td.style.backgroundColor = "#F1F1F1";
          cellProperties.readOnly = true;
        }
      } else if( prop == "hltplnctrdte"){
        if(lv_ro == true ){
          $(td).empty().append("<a href='#' name='plnlnk' data-row= "+row+">"+value+"</a>");
        }else{
          Handsontable.renderers.DateRenderer.apply(this, arguments);
        }
        
        if(<?= $lv_sec; ?>_hotplnctr != undefined){ 
					cellProperties.readOnly = <?= $lv_sec; ?>_hotplnctr.getDataAtRowProp(row, "evldte") && "<?= $vew_data->dteprm; ?>" == "EVLDTE"?true:lv_ro;
      		td.style.backgroundColor = "#"+(<?= $lv_sec; ?>_hotplnctr.getDataAtRowProp(row, "evldte") && "<?= $vew_data->dteprm; ?>" == "EVLDTE"?"F1F1F1":"<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>");
        }
      } else if (prop == "hltplnctrinbdte" || prop == "hltplnctroutdte"){
        Handsontable.renderers.TimeRenderer.apply(this, arguments);
        cellProperties.readOnly = lv_ro;
      } else if (prop == "evldte"){ 
        Handsontable.renderers.DateRenderer.apply(this, arguments);
        cellProperties.readOnly = true;
        td.style.backgroundColor = "#F1F1F1";
      } else if (prop == "hltprslqdcod"){
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        td.style.backgroundColor = "#F1F1F1";
        cellProperties.readOnly = true;
      } else if (prop == "ctrcnl" || prop == "ctrcnf"){
       	cellProperties.readOnly = true;
        td.style.backgroundColor = "#F1F1F1";
        $(td).empty();
        if(<?= $lv_sec; ?>_hotplnctr != undefined){
          var lv_rowdat = <?= $lv_sec; ?>_hotplnctr.getSourceDataAtRow(row);
          var lv_valid = lv_rowdat.hltplnctrdte && lv_rowdat.prstxt && ((lv_rowdat.hltplnctrinbdte && lv_rowdat.hltplnctroutdte) || lv_rowdat.hltplnctrqty);
          
          if(lv_valid){
            $(td).append("<div class='text-center "+(lv_ro?"":" cursor-pointer ")+(prop=="ctrcnl"?" btncnl ":" btncnf ")+"' onclick='<?= $lv_sec; ?>_controlPlanning("+row+","+(prop=="ctrcnl"?0:1)+");'><i class='"+(prop=="ctrcnl"?"fas fa-ban":"fas fa-check")+"'></i></div>");
          }
        }
      } else if (prop == "ctrsts"){
        td.style.backgroundColor = "#F1F1F1";
        if(<?= $lv_sec; ?>_hotplnctr != undefined){
          // determinar icono
          var lv_rowdat = <?= $lv_sec; ?>_hotplnctr.getSourceDataAtRow(row);
          var lv_icn = "?";
          
          if(lv_rowdat.cancel){
            lv_icn = "<i class='fas fa-ban'></i>";
          }else if(lv_rowdat.hltplnctrdtecod){
            lv_icn = "<i class='fas fa-check'></i>";
          }
          
        	$(td).empty().append("<div class='text-center'>"+lv_icn+"</div>"); 
        }
      } else {
        Handsontable.renderers.TextRenderer.apply(this, arguments);
        
        if(prop=="prstxt" && <?= $lv_sec; ?>_hotplnctr != undefined){ 
					cellProperties.readOnly = <?= $lv_sec; ?>_hotplnctr.getDataAtRowProp(row, "evldte") && "<?= $vew_data->dteprm; ?>" == "EVLDTE"?true:lv_ro;
      		td.style.backgroundColor = "#"+(<?= $lv_sec; ?>_hotplnctr.getDataAtRowProp(row, "evldte") && "<?= $vew_data->dteprm; ?>" == "EVLDTE"?"F1F1F1":"<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>");
        }
      }
      
      // marca una fila entera como controlada o anulada, según corresponda
      if(<?= $lv_sec; ?>_hotplnctr!=undefined){ 
        if(<?= $lv_sec; ?>_hotplnctr.getDataAtRowProp(row, "cancel")){ 
          td.style.backgroundColor = "#B8B8B5";
          var tr = $("#<?= $lv_sec; ?> #hltplncrthot").find('table').first().find('tbody').first().find('tr').eq(row);
          td.style.textDecoration = "line-through";
        }else{
          value = "";
        }
        if(<?= $lv_sec; ?>_hotplnctr.getDataAtRowProp(row, "confirm")){ 
          td.style.backgroundColor = "#98FB98";
        }
      }
		};
    var <?= $lv_sec; ?>_hotplnctrdel = [];
 		var <?= $lv_sec; ?>_hotplnctrcnt = $("#<?= $lv_sec; ?> #hltplncrthot")[0];
		var <?= $lv_sec; ?>_hotplnctrset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: true,
			colHeaders: [<?= $vew_readonly ? '"'.$vew_lang->status.'"' : '"Controlar", "Anular"'?>, "<?= $vew_lang->date ?>", <?= ($lv_spcctrtyp==1?'"'.$vew_lang->Inbound.'","'.$vew_lang->Outbound.'","'.$vew_lang->difference.'",':''); ?> <?= ($lv_spcctrtyp==2?'"'.$vew_lang->sessions.'",':''); ?>"<?= $vew_lang->Lender ?>", "<?= $vew_lang->Comments ?>", "<?= $vew_lang->liquidation ?>", "<?= $vew_lang->Evolution; ?>"],
			columns: [
        <?php if($vew_readonly){ ?>
        {type: "text", data: "ctrsts", width: 7, renderer: <?= $lv_sec; ?>_hotplnctr_renderer, readOnly: true},
        <?php }else{ ?>
        {type: "text", data: "ctrcnf", width: 8, renderer: <?= $lv_sec; ?>_hotplnctr_renderer, readOnly: true},
				{type: "text", data: "ctrcnl", width: 7, renderer: <?= $lv_sec; ?>_hotplnctr_renderer, readOnly: true},
        <?php } ?>
				{type: "date", data: "hltplnctrdte", width: 12, renderer: <?= $lv_sec; ?>_hotplnctr_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
         	dateFormat: "DD/MM/YYYY",
					correctFormat: true,
					allowEmpty: false,
					datePickerConfig: {
            firstDay: 0,
            showWeekNumber: false<?php if($lv_plndteobj){ ?>,
            minDate: new Date(<?= $lv_plnyth ?>, <?= $lv_plnmth ?> - 1, 1),
            maxDate: new Date(<?= $lv_plnyth ?>, <?= $lv_plnmth ?>, 0)<?php } ?>
          }
				},
        <?php if($lv_spcctrtyp == 1){ ?>
				{type: "time", data: "hltplnctrinbdte", width: 10, timeFormat: "HH:mm", correctFormat: true, renderer: <?= $lv_sec; ?>_hotplnctr_renderer <?= ($vew_readonly?', readOnly: true':'');	?> },
				{type: "time", data: "hltplnctroutdte", width: 10, timeFormat: "HH:mm", correctFormat: true, renderer: <?= $lv_sec; ?>_hotplnctr_renderer <?= ($vew_readonly?', readOnly: true':'');	?> },
				{type: "numeric", data: "hltplnctrtme", width: 10, renderer: <?= $lv_sec; ?>_hotplnctr_renderer, readOnly: true , numericFormat: {pattern: "0.#", culture: "es-AR"} },
				<?php } ?>
        <?php if($lv_spcctrtyp == 2){ ?>
        {type: "numeric", data: "hltplnctrqty", width: 10, renderer: <?= $lv_sec; ?>_hotplnctr_renderer, numericFormat: {pattern: "0", culture: "es-AR"}  <?= ($vew_readonly?', readOnly: true':'');	?> },
        <?php } ?>
        {type: "autocomplete", data: "prstxt", width: 30 ,renderer: <?= $lv_sec; ?>_hotplnctr_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						$.ajax({
              url: "?prg=hltprsspc&act=18", dataType: "json", data: {	prm_prstxt: query, prm_spccod: <?= $vew_data->spccod ?> },
							complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); exit();}},
							success: function (response) {
								// guardo todos los datos adicionales en una variable temporal
								var lv_dat = [];
								<?= $lv_sec; ?>_hotplnctrtmpchg = [];
								for (var i=0; i < response.length; i++) {
									<?= $lv_sec; ?>_hotplnctrtmpchg.push( {prstxt: response[i]["prstxt"], prscod: response[i]["prscod"]} );
									lv_dat.push( response[i]["prstxt"] );
								}
								process( lv_dat );
							}
						});
					},
					strict: true
				},
        {type: "text", data: "hltplnctrcmt", width: 40, renderer: <?= $lv_sec; ?>_hotplnctr_renderer <?= ($vew_readonly?', readOnly: true':'');	?>},
        {type: "text", data: "hltprslqdcod", width: 12, renderer: <?= $lv_sec; ?>_hotplnctr_renderer, readOnly: true},
        {type: "date", data: "evldte", width: 12, renderer: <?= $lv_sec; ?>_hotplnctr_renderer, readOnly: true,
         	dateFormat: "DD/MM/YYYY",
					correctFormat: true
				}
			],     
      afterOnCellMouseOver: function(e, coords, td){
        if($(td).has("i").length && !<?= $lv_sec; ?>_hotplnctr.getDataAtRowProp(coords.row, "cancel") && !<?= $lv_sec; ?>_hotplnctr.getDataAtRowProp(coords.row, "confirm")){
          if(coords.col == <?= $lv_sec; ?>_hotplnctr.propToCol("ctrcnf")){ 
            $(td).addClass("text-success");
            $(td).css("background-color", "#98FB98");
          }else if(coords.col == <?= $lv_sec; ?>_hotplnctr.propToCol("ctrcnl")){
            $(td).addClass("text-danger");
            $(td).css("background-color", "#B8B8B5");
          }
        }
      },     
      afterOnCellMouseOut: function(e, coords, td){
        if(($(td).hasClass("text-success") || $(td).hasClass("text-danger")) && !<?= $lv_sec; ?>_hotplnctr.getDataAtRowProp(coords.row, "cancel") && !<?= $lv_sec; ?>_hotplnctr.getDataAtRowProp(coords.row, "confirm")){
          $(td).removeClass("text-success text-danger");
          $(td).css("background-color", "#F1F1F1");
        }
      },
      beforeChange: function(changes, source) {
      	if(source == "edit" && changes[0][1] == "prstxt"){
          for(var i=0 ; i < <?= $lv_sec; ?>_hotplnctrtmpchg.length ; i++) {
            if (<?= $lv_sec; ?>_hotplnctrtmpchg[i].prstxt == changes[0][3]) {
            	changes.push([ changes[0][0], "prscod", "", String(<?= $lv_sec; ?>_hotplnctrtmpchg[i].prscod) ]);
              break;
            }
          }
        } 
    	},
      afterChange: function(changes, source) { 
        if(source != "loadData" && (changes[0][1] == "hltplnctrinbdte" || changes[0][1] == "hltplnctroutdte" || changes[0][1] == "hltplnctrdte")){
          if(changes[0][3] == ""){
          	<?= $lv_sec; ?>_hotplnctr.setDataAtRowProp(changes[0][0], "hltplnctrtme", "", 'paste');
          }else{
          	var lv_inbdte = <?= $lv_sec; ?>_hotplnctr.getDataAtRowProp(changes[0][0], "hltplnctrinbdte");
						var lv_outdte = <?= $lv_sec; ?>_hotplnctr.getDataAtRowProp(changes[0][0], "hltplnctroutdte"); 
          	if(lv_inbdte && lv_outdte && <?= $lv_sec; ?>_hotplnctr.getDataAtRowProp(changes[0][0], "hltplnctrdte")){
            	<?= $lv_sec; ?>_hotplnctr.setDataAtRowProp(changes[0][0], "hltplnctrtme", <?= $lv_sec; ?>_calcTimeDiff(lv_inbdte, lv_outdte), 'paste');
        		}
          }
        }
        if(source == "chknoctr" ){
          <?= $lv_sec; ?>_hotplnctr.setDataAtRowProp(0,"chkctr",false);     
        }else if(source == "chkctr"){
          <?= $lv_sec; ?>_hotplnctr.setDataAtRowProp(0,"chknoctr",false);
        }
      },
			minSpareRows: <?= ($vew_readonly?'0':'1'); ?>,
			outsideClickDeselects: false,
			beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotplnctr.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
						<?= $lv_sec; ?>_hotplnctrdel.push( lv_dat[i] );
				}
			}
		};
		var <?= $lv_sec; ?>_hotplnctr;	
	</script>
  
  <?php if(!$vew_readonly){ ?>
  <script>
    // identifica a una fila como controlada o anulada
    function <?= $lv_sec; ?>_controlPlanning(lp_row, lp_prop){ 
      var lv_prop = lp_prop ? "confirm":"cancel";
      var lv_rowsts = <?= $lv_sec; ?>_hotplnctr.getDataAtRowProp(lp_row, lv_prop);
      
      if(lv_rowsts=="X"){
      	// quita el controlado/anulado si ya estaba con ese estado
        <?= $lv_sec; ?>_hotplnctr.setDataAtRowProp(lp_row, lv_prop, "", "");
        
        if($("#<?= $lv_sec; ?> #hltplnctrcod").val()){
          <?= $lv_sec; ?>_hotplnctr.setDataAtRowProp(lp_row, "confirm", "X", "");
        }
      }else{
        <?= $lv_sec; ?>_hotplnctr.setDataAtRowProp(lp_row, lp_prop?"cancel":"confirm", "", "");
        <?= $lv_sec; ?>_hotplnctr.setDataAtRowProp(lp_row, lv_prop, "X", "");
      }
      
      <?= $lv_sec; ?>_hotplnctr.render();
    }
  </script>
  <?php } ?>
  
  <script>
    //link a planificación
    $("#<?= $lv_sec; ?> ").on("click", "a[name='plnlnk']", function(e){ e.preventDefault();
			var lv_plnid = <?= $lv_sec; ?>_hotplnctr.getDataAtRowProp($(this).data('row'), 'plnid');
   		var lv_plndteid = <?= $lv_sec; ?>_hotplnctr.getDataAtRowProp($(this).data('row'), 'plndteid');                                                             
			tmssCallProcess("?prg=hltpln&act=03&prm_plnvew=plnpat&prm_plndteid="+lv_plndteid+"&prm_plnid="+lv_plnid, [], function(data){
      	BootstrapDialog.show({
        	title: "<?= $vew_lang->Planning ?>",
        	message: $(data),
        	size: BootstrapDialog.SIZE_WIDE,
      	 })
    	 	}
     	)
    });                                                                
  </script>
  <script>
		// cargo handsontable de controles de prestación
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotplnctr = new Handsontable(<?= $lv_sec; ?>_hotplnctrcnt, <?= $lv_sec; ?>_hotplnctrset);
			var lv_dat = [<?php
				$lv_buffer='';
				foreach((is_iterable($vew_data->hltplnctrdtelst) ? $vew_data->hltplnctrdtelst : array()) as $lv_row){
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'plnid:\''.$lv_row['plnid'].'\','.
												'plndteid:\''.$lv_row['plndteid'].'\','.
												'hltplnctrcod:\''.(isset($lv_row['hltplnctrcod']) ? $lv_row['hltplnctrcod']:'').'\','.
												'hltplnctrdtecod:\''.(isset($lv_row['hltplnctrcod']) ? $lv_row['hltplnctrdtecod']:'').'\','.
												'hltplnctrdte:\''.$lv_row['dtecnv'].'\','.
												'hltplnctrinbdte:\''.$lv_row['inbdtecnv'].'\','.
												'hltplnctroutdte:\''.$lv_row['outdtecnv'].'\','.
												'hltplnctrqty:\''.$lv_row['qty'].'\','.
												'hltplnctrtme: \''. (float)$lv_row['tme'].'\' ,'.
												'spccod:\''.$lv_row['spccod'].'\','.
												'spctxt:\''.$lv_row['spctxt'].'\','.
												'prscod:\''.$lv_row['prscod'].'\','.
												'prstxt:\''.$lv_row['prstxt'].'\','.
												'hltplnctrcmt:\''.$lv_row['cmt'].'\','.
												'hltprslqdcod:\''.(isset($lv_row['hltprslqdcod'])?$lv_row['hltprslqdcod']:'').'\','.
												'confirm:\''.(isset($lv_row['hltplnctrdtecod']) && !isset($lv_row['deldte'])?'X':'').'\','.
            						'cancel:\''.(isset($lv_row['deldte'])?'X':'').'\','.
            						'evldte:\''.$lv_row['evldtecnv'].'\'}'; }
  
				echo $lv_buffer;
			?>];
      <?= $lv_sec; ?>_hotplnctr.loadData( lv_dat );
			<?= $lv_sec; ?>_hotplnctr.render();
		});
	</script>
  <script>
    //F I L T E R
    var lv_<?= $lv_sec; ?>_grdfltqty = 0;
    var lv_<?= $lv_sec; ?>_grdfltcod = 0;
    var gv_<?= $lv_sec; ?>_plnfltdat = [
      {fldttl: "<?= $vew_lang->Lender ?>", fldcod: "pr.prstxt", fldtyp: "TEXT", flttyp: "", fldvalstr: "", fldvalend: ""}
    ];
    
    $("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
      tmssFilterShowDialog( gv_<?= $lv_sec; ?>_plnfltdat, <?= $lv_sec; ?>_filterPln );
    });

    function <?= $lv_sec; ?>_filterPln( lp_flt ) {
            
      //Condiciones del filtro
			$("#<?= $lv_sec; ?> #plnflt").val(JSON.stringify(lp_flt));
      
      var lv_fltint;
      if(lp_flt!=null){
        lv_fltint = tmssFilterParseToInternal(lp_flt);
        gv_<?= $lv_sec; ?>_plnfltdat = lp_flt;
        $("#<?= $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
      } else {
        lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
      }
      if( lv_fltint["maxrec"]=="" ){ lv_fltint["maxrec"]="100"; }
       
      var lv_dat = [];
      var lv_pstdat = [
				{name:"hltplnctrcod", value:"<?= $vew_data->hltplnctrcod ?>"},
				{name:"plnyth", value:"<?= $lv_plnyth ?>"},
				{name:"plnmth", value:"<?= $lv_plnmth ?>"},
				{name:"patcod", value:"<?= $vew_data->patcod ?>"},
				{name:"spccod", value:"<?= $vew_data->spccod ?>"},
				{name:"vewmaxrec", value: lv_fltint["maxrec"] }, 
				{name:"vewfldflt", value: lv_fltint["fltstr"] }
			];
			
      tmssCallProcess("?prg=hltplnctr&act=plnflt", lv_pstdat, function(data){
        var lv_buffer="";
        lv_buffer="<span class='pagination-info'>Registros encontrados <span class='badge'>"+(data.length)+"</span></span>";
        $("#<?= $lv_sec; ?> #datqty").html(lv_buffer)     
        for (var i = 0; i < data.length; i++) {
					lv_dat.push({	plnid: data[i].plnid,
												plndteid: data[i].plndteid,
              					hltplnctrcod: data[i].hltplnctrcod,
              					hltplnctrdtecod: data[i].hltplnctrdtecod,
              					hltplnctrdte: data[i].dtecnv,
												hltplnctrinbdte: data[i].inbdtecnv,
              					hltplnctroutdte: data[i].outdtecnv,
              					hltplnctrqty: data[i].qty,
												hltplnctrtme: parseFloat(data[i].tme),
              					spccod: data[i].spccod,
												spctxt: data[i].spctxt,
												prscod: data[i].prscod,
												prstxt: data[i].prstxt,
												hltplnctrcmt: data[i].cmt,
              					hltprslqdcod: data[i].hltprslqdcod,
              					confirm: data[i].hltplnctrdtecod && !data[i].deldte?"X":"",
            						cancel: data[i].deldte?"X":"",
            						evldte: data[i].evldtecnv
            });
				}
        <?= $lv_sec; ?>_hotplnctr.loadData( lv_dat );
      });
    }
	</script>
  <script>
    function <?= $lv_sec; ?>_calcTimeDiff(lp_inbtme, lp_outtme){
      var lv_diff = 0;
      var lv_inbtme = lp_inbtme.split(':');
      var lv_outtme = lp_outtme.split(':');
      if(lv_inbtme.length == 2 && lv_outtme.length == 2){
        for(var i = 0; i < lv_inbtme.length; i++){
          lv_inbtme[i] = parseInt(lv_inbtme[i], 10);
          lv_outtme[i] = parseInt(lv_outtme[i], 10);
        }
        if (lv_inbtme[0] > lv_outtme[0]){
          lv_diff = 24 - lv_inbtme[0] + lv_outtme[0];
        } else if (lv_inbtme[0] < lv_outtme[0]){
          lv_diff = lv_outtme[0] - lv_inbtme[0];
        } else {
          if(lv_outtme[1] <= lv_inbtme[1]){
            lv_diff = 24;
          }
        }
        lv_diff += (lv_outtme[1] - lv_inbtme[1])/60;
        
        lv_diff = Math.round(lv_diff*100)/100
      }
      return isNaN(lv_diff)?"":lv_diff;
    }
  </script>
	<script>
		// CONTABILIZAR
		$("#<?= $lv_sec; ?> #btnacc").on("click", function() {
      BootstrapDialog.confirm({
				title: "Contabilizar",
				message:"Desea contabilizar el documento ?",
				type: BootstrapDialog.TYPE_PRIMARY,
				callback: function(result){
					if(result){
						<?= $lv_sec; ?>_fnc({action: "09"});
					}
				}
			});
		});

    // ANULAR CONTABILIZACION
    $("#<?= $lv_sec; ?> #btnaccdelL, #<?= $lv_sec; ?> #btnaccdelR").on("click", function() {
      BootstrapDialog.confirm({
				title: "Anular Contabilizacion",
				message:"Desea anular la contabilizacion del documento ?",
				type: BootstrapDialog.TYPE_WARNING,
				callback: function(result){
					if(result){
						<?= $lv_sec; ?>_fnc({action: "29"});
					}
				}
			});
		});
  </script>
  <script> 
    var gv_<?= $lv_sec; ?>_last_action="";
    // server response ext
    function <?= $lv_sec; ?>_fncbckext( data ) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="09") {
					toastr.info("Documento contabilizado.");
					<?= $lv_sec; ?>_fnc({action: "99"});
        } else if (gv_<?= $lv_sec; ?>_last_action=="29") {
					toastr.info("Documento Anulado.");
					<?= $lv_sec; ?>_fnc({action: "99"});
				} else if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    }
		
    function <?= $lv_sec; ?>_fncext( lp_prm ) {	
      if(lp_prm["action"]=="00"){
        // obtengo datos de handsontable
        var lo_dat = <?= $lv_sec; ?>_hotplnctr.getSourceData();
        var lv_arr = new Array();
        for (var i=0; i<lo_dat.length; i++) {
          if($("#<?= $lv_sec;?> #hltplnctrcod").val()!="" || ($("#<?= $lv_sec;?> #hltplnctrcod").val()=="" && (lo_dat[i]["confirm"]!="" || lo_dat[i]["cancel"]!=""))){
            if ( lo_dat[i]["hltplnctrdte"]!='' && lo_dat[i]["hltplnctrdte"]!=undefined ) {
              lv_arr.push({	"hltplnctrcod":lo_dat[i]["hltplnctrcod"],
                            "hltplnctrdtecod":lo_dat[i]["hltplnctrdtecod"],
                            "plnid":lo_dat[i]["plnid"],
                            "plndteid":lo_dat[i]["plndteid"],
                            "hltplnctrdte":lo_dat[i]["hltplnctrdte"],
                            "hltplnctrinbdte":lo_dat[i]["hltplnctrinbdte"],
                            "hltplnctroutdte":lo_dat[i]["hltplnctroutdte"],
                            "hltplnctrqty":lo_dat[i]["hltplnctrqty"],
                            "hltplnctrtme":lo_dat[i]["hltplnctrtme"],
                            "prscod":lo_dat[i]["prscod"],
                            "hltplnctrcmt":lo_dat[i]["hltplnctrcmt"],
                            "docsts":lo_dat[i]["docsts"],
                            "cancel":lo_dat[i]["cancel"]
                          });
            }
          }
        }
        // agrego las filas eliminadas
        for (var i=0; i<<?= $lv_sec; ?>_hotplnctrdel.length; i++) {
          if($("#<?= $lv_sec;?> #hltplnctrcod").val()!="" || ($("#<?= $lv_sec;?> #hltplnctrcod").val()=="" && (lo_dat[i]["confirm"]!="" || lo_dat[i]["cancel"]!=""))){
            lv_arr.push({	"hltplnctrcod":<?= $lv_sec; ?>_hotplnctrdel[i]["hltplnctrcod"],
                          "hltplnctrdtecod": <?= $lv_sec; ?>_hotplnctrdel[i]["hltplnctrdtecod"],
                          "plnid":<?= $lv_sec; ?>_hotplnctrdel[i]["plnid"],
                          "plndteid":<?= $lv_sec; ?>_hotplnctrdel[i]["plndteid"],
                          "hltplnctrdte":<?= $lv_sec; ?>_hotplnctrdel[i]["hltplnctrdte"],
                          "hltplnctrinbdte":<?= $lv_sec; ?>_hotplnctrdel[i]["hltplnctrinbdte"],
                          "hltplnctroutdte":<?= $lv_sec; ?>_hotplnctrdel[i]["hltplnctroutdte"],
                          "hltplnctrqty":<?= $lv_sec; ?>_hotplnctrdel[i]["hltplnctrqty"],
                          "hltplnctrtme":<?= $lv_sec; ?>_hotplnctrdel[i]["hltplnctrtme"],
                          "prscod":<?= $lv_sec; ?>_hotplnctrdel[i]["prscod"],
                          "hltplnctrcmt":<?= $lv_sec; ?>_hotplnctrdel[i]["hltplnctrcmt"],
                          "docsts":<?= $lv_sec; ?>_hotplnctrdel[i]["docsts"],
                          "cancel":lo_dat[i]["cancel"],
                          "deleted":"X"
                        });
          }
        }
        
        if (lv_arr.length==0) {
          $("#<?= $lv_sec; ?> #hltplncrtdte").prop("value", "");						
        } else {
          $("#<?= $lv_sec; ?> #hltplncrtdte").prop("value", JSON.stringify( lv_arr ) );
        }
      }
		}
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>   
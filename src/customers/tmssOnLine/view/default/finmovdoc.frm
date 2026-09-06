<?php	
	// url del formulario 
  $lv_lnk = '?prg=finmovdoc&prm_finmovdoccod='.$vew_data->finmovdoccod;

	// campos requeridos
	$vew_input->RequiredFields( array('finmovdoctxt', 'finmovdocdte', 'finmovdocaccdte', 'docsts', 'curcod', 'curexcrte') );

	// clave del documento
	$lv_dockey = $vew_data->finmovdoccod; 
 
	// titulo
	$lv_title = $vew_lang->document;
	
	// modulo y programa
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'MOV';
	$lv_objtyp = $vew_data->mdlcod.'_'.$vew_data->prgcod;

	// valores x default
	if($vew_data->finmovdoccod==''){
		$vew_data->finmovdocdte = date('d/m/Y');
		$vew_data->excrte = 1;
		$vew_data->docsts = 'A';
	}

	// libreria de estilos bootstrap
	include_once('_library.frm');

	if( $vew_data->docsts=='C' ) {
		$lv_default = $lv_always_disabled;
		$vew_readonly = true;
	}
		
	// Botones por vista
  $vew_tbl['accL'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09'), 'acc'=>'');
	$vew_tbl['accR'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09'), 'acc'=>'');
	$vew_tbl['modL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl['modR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02'));
	$vew_tbl['delsep'] = array('per'=> $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly && $vew_data->docsts!='C' );
	$vew_tbl['del'] = array('per'=> $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && $vew_readonly && $vew_data->docsts!='C' );
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
  <!-- Nav-bar -->
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('finmovmdlcod','hidden',''); ?>
		<textarea class="hidden" id="finmovdocacc" name="finmovdocacc"></textarea>
		
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->finmovdoccod; ?><?= gethtml('finmovdoccod','hidden',$vew_data->finmovdoccod) ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-4">          
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->general; ?>
                    <span class="tmss-card-icon">
                      <span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                      <?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
                    </span>
                  </div>
              	</div>
                <div class="card-body tmss-card-body-edit">
                  <?= vew_boot($lv_col39, array('label'=>$vew_lang->description, 'input'=>gethtml('finmovdoctxt', 'doccmt1x50',$vew_data->finmovdoctxt, $lv_default) )); ?>
									<?= vew_boot($lv_col345, array('label'=>$vew_lang->currency,
											'input1'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly),
																				array('input'=>gethtml('curcod', 'curcod', $vew_data->curcod, $lv_always_disabled))),
											'input2'=>gethtml('curexcrte','docnum0905',$vew_data->curexcrte,$lv_default)
											)); ?>
                  <?= vew_boot($lv_col39, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', ($vew_readonly?'docstsacc':'docsts'), $vew_data->docsts, $lv_default) )); ?>
                </div>
              </div>
              
						</div>
            <div class="col-md-4">
              
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->dates; ?></div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?= vew_boot($lv_col39, array('label'=>$vew_lang->date, 'input'=>gethtml('finmovdocdte', 'docdte', $vew_data->finmovdocdte, $lv_default) )); ?>
                  <?= vew_boot($lv_col39, array('label'=>$vew_lang->accounting, 'input'=>gethtml('finmovdocaccdte', 'docdte', $vew_data->finmovdocaccdte, ($vew_data->finmovdoccod==''?$lv_default:$lv_always_disabled) ) )); ?>
                </div> 
              </div>
              
						</div>
						
						<div class="col-md-4">
							<div class="card">
								<div class="card-header"><div class="card-title"><?= $vew_lang->reference; ?></div></div>
								<div class="card-body tmss-card-body-edit">
									<?= vew_boot($lv_col39, array('label'=>$vew_lang->reference,'input'=>gethtml('','doccmt1x50',$vew_data->accobjtyp.' '.$vew_data->accobjcod,$lv_always_disabled) )); ?>
									<?= vew_boot($lv_col39, array('label'=>$vew_lang->source, 	'input'=>gethtml('','doccmt1x50',$vew_data->srcobjtyp.' '.$vew_data->srcobjcod,$lv_always_disabled) )); ?>
									<?= vew_boot($lv_col39, array('label'=>$vew_lang->number, 	'input'=>gethtml('finmovdoccodext', ($vew_data->sysdoccls->docrngcodint!=0 || $vew_data->sysdoccls->docrngcodext!=0?'docrngnum':'doccmt1x20'),$vew_data->finmovdoccodext,$vew_data->sysdoccls->docrngcodint!=0?$lv_always_disabled:$lv_default ) )); ?>
								</div> <!-- /card-body -->
							</div> <!-- /card -->
						</div> <!-- /col -->
					</div>
          
          <div class="card tmss-hot-ttl">
            <div class="card-header">
            	<div class="card-title"><?= $vew_lang->accounts; ?><a href="#" id="btnadd" class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" title="Modelos"><i class="fas fa-plus"></i></a></div>
            </div>
          </div>
					<div id="finmovdocacchot" name="finmovdocacchot"></div>          
				</div> <!-- fin tab001 -->

			</div> <!-- tabcontent -->    
		</div> <!-- container-fluid -->
  </form>
	<script>
    // curcod
    var lo_get = {"fldsec": "<?= $lv_sec; ?>" ,"fldasg": {"curcod":"curcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #curcod"), "admcur", lo_get);

		// CONTABILIZAR
		$("#<?= $lv_sec; ?> #btnacc").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm({
				title: "Contabilizar", 
				message:"Desea contabilizar el documento ?",
				type: BootstrapDialog.TYPE_PRIMARY,
				callback: function(result){ if(result){	 <?= $lv_sec; ?>_fnc({action: "09"}); }
					<?= $lv_sec; ?>_fnc({action: "03"}); 
        }
			});
		});
	</script>
  <script>
    // SELECCIONAR MODELO
    $("#<?= $lv_sec; ?> #btnadd").on("click",function(e){ e.preventDefault();                                                   
      tmssPopup("Buscar modelo","?prg=finmovmdl&act=08&prm_vewcod=VEW_FIN_MOV_MDL&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[finmovmdlcod:d.finmovmdlcod]&prm_fldflt=[d.docsts:A]", function(dialog){
        var lv_dat = <?= $lv_sec; ?>_hotacc.getSourceData();
				for( var i=0; i < lv_dat.length; i++){
					if ( lv_dat[i]["finmovdocacccod"] != "" && lv_dat[i]["finmovdocacccod"] != undefined ) {
						<?= $lv_sec; ?>_hotaccdel.push( lv_dat[i]["finmovdocacccod"]);
					}
				}
        var lv_finmovmdlcod = $("#<?= $lv_sec; ?> #finmovmdlcod").prop("value");
        tmssCallProcess("?prg=finmovmdl&act=23", {finmovmdlcod:lv_finmovmdlcod}, function(data) {
          var lv_accdata = new Array();
          for(var i=0; i < data.data.length; i++){
            var lv_buffer = '';
            lv_buffer += '{'+
                          '"finacccod":"'+data.data[i].finacccod+'",'+
                          '"finacctxt":"'+data.data[i].finacctxt+'",'+
                          '"finmovdocacctotD":'+ (data.data[i].finmovdocaccblc == 'D'?data.data[i].finmovdocacctot:0) +','+
                          '"finmovdocacctotH":'+ (data.data[i].finmovdocaccblc == 'H'?data.data[i].finmovdocacctot:0) +
                        '}';
            lv_accdata.push(JSON.parse(lv_buffer));
          }
          <?= $lv_sec; ?>_hotacc.loadData( lv_accdata );
        	<?= $lv_sec; ?>_hotacc.render();
        });
      });
		});
  </script>  
	<script>
		//CUENTAS
		var <?= $lv_sec; ?>_hotacc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      if (<?= $lv_sec; ?>_hotacc!=undefined) {
        if(<?= $lv_sec; ?>_hot_paste_array.length == 0 && <?= $lv_sec; ?>_hot_paste != true){         
          var lv_ro_color = "#F1F1F1";
          var lv_color = "#FFFFFF";

          // documento controla stock o crea lote/serie
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
				}
      }
		};
		var <?= $lv_sec; ?>_hot_paste = false;
    var <?= $lv_sec; ?>_hot_paste_array = [];
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotaccchg = [];
		var <?= $lv_sec; ?>_hotaccdel = [];
		var <?= $lv_sec; ?>_hotacccnt = $("#<?= $lv_sec; ?> #finmovdocacchot")[0];
		var <?= $lv_sec; ?>_hotaccset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
			colHeaders: [ "ID", "Cuenta", "Debe", "Haber"],
			columns: [
				{type: "text", data: "finacccod", renderer: <?= $lv_sec; ?>_hotacc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "autocomplete", data: "finacctxt", renderer: <?= $lv_sec; ?>_hotacc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						if ( query.length>1 && <?= $lv_sec; ?>_hot_paste != true) { 
							$.ajax({
								url: "?prg=finacc&act=17", dataType: "json", data: {	prm_finacctxt: query }, minLength: 2,
								complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
								success: function (response) {
									var lv_dat = [];
									<?= $lv_sec; ?>_hotaccchg = [];
									for (var i=0; i < response.data.length; i++) {
										<?= $lv_sec; ?>_hotaccchg.push({
                                                    finacctxt: response.data[i]["finacctxt"], 
                                                    finacccod: response.data[i]["finacccod"]
                                                  });
										lv_dat.push( response.data[i]["finacctxt"] );
									}
									process( lv_dat );
								}
							});
						} else {
              for(var i=0; i< <?= $lv_sec; ?>_hot_paste_array.length; i++){
                if(query == <?= $lv_sec; ?>_hot_paste_array[i]){ 
                  <?= $lv_sec; ?>_hot_paste_array.splice(i, 1);;
                  break;
                }
              }
              if(<?= $lv_sec; ?>_hot_paste_array.length == 0){ <?= $lv_sec; ?>_hot_paste = false; }
							
              process( [query] );
						}
					},
					strict: true
				},
				{type: "numeric", data: "finmovdocacctotD", width: 50, renderer: <?= $lv_sec; ?>_hotacc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "finmovdocacctotH", width: 50, renderer: <?= $lv_sec; ?>_hotacc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
			],
			beforeChange : function(changes, source) {
				// AUTOCOMPLETE: asigno los datos adicionales a la fila
        if (changes && changes.length && source=="edit" && <?= $lv_sec; ?>_hot_paste!=true) {<?= $lv_sec; ?>_hotacc.render();
					if (changes[0][1]=="finacctxt") { 
						var lv_value = changes[0][3];
						for(var i=0 ; i < <?= $lv_sec; ?>_hotaccchg.length ; i++) {
							if (<?= $lv_sec; ?>_hotaccchg[i].finacctxt == lv_value) {
								changes.push([ changes[0][0], "finacccod", "", String(<?= $lv_sec; ?>_hotaccchg[i].finacccod) ]);
								<?= $lv_sec; ?>_hot_autocomplete = true;
							}
						}
					}
				}
			},
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotacc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["finmovdocacccod"]!="" && lv_dat[i]["finmovdocacccod"]!=undefined ) {
						<?= $lv_sec; ?>_hotaccdel.push( lv_dat[i]["finmovdocacccod"]);
					}
				}
			},
			afterChange: function(changes, source) {
				if (changes && changes.length && <?= $lv_sec; ?>_hot_autocomplete!=true && <?= $lv_sec; ?>_hot_paste!=true) {
					for( var i=0; i<changes.length; i++) {
						if ((source=="edit" || source=="CopyPaste.paste") && changes[i][1]=="acccod") {
							var lv_value = changes[i][3];
							tmssCallProcessNoBackdrop("?prg=finacc&act=19", {sysdocclscod:"<?= $vew_data->sysdoccls->sysdocclscod; ?>", row:changes[i][0]}, function(data){ ;
								if (data.row!=undefined) {
									var lv_row = data.row;
									<?= $lv_sec; ?>_hot_paste = true;
                  if (<?= $lv_sec; ?>_hotacc.getDataAtRowProp(lv_row,"finacctxt")!=data.data["finacctxt"]){
                  	<?= $lv_sec; ?>_hotacc.setDataAtRowProp(lv_row,"finacctxt", data.data["finacctxt"], "edit.acccod" );
                  }
									<?= $lv_sec; ?>_hot_paste = false;
								}
							});
						}
					}
				} else {
					<?= $lv_sec; ?>_hot_autocomplete = false;
				}
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotdocerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotdocerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotdocerr.splice(lv_inx,1); }	
				}
			}
		};
		var <?= $lv_sec; ?>_hotacc;	

		// cargo datos en handsontable
		tmssLoadScript("handsontable", instanceTable); 
      function instanceTable(){
        <?= $lv_sec; ?>_hotacc = new Handsontable(<?= $lv_sec; ?>_hotacccnt, <?= $lv_sec; ?>_hotaccset);	
        var lv_dat = [<?php
          $lv_buffer='';

          foreach($vew_data->finmovdocacc as $lv_row){
            $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                        'finmovdocacccod:"'.$lv_row['finmovdocacccod'].'",'.
                        'finacccod:"'.$lv_row['finacccod'].'",'.
                        'finacctxt:"'.($lv_row['finacctxt']).'",'.
                        'finmovdocacctotD: '.($lv_row['finmovdocaccblc']=='D'?$lv_row['finmovdocacctot']:0).','.
                        'finmovdocacctotH: '.($lv_row['finmovdocaccblc']=='H'?$lv_row['finmovdocacctot']:0).','.
                        'docsts:"'.$lv_row['docsts'].'"'.
                        '}'; 
                      }
          echo $lv_buffer;
        ?>];
        <?= $lv_sec; ?>_hotacc.loadData( lv_dat );
        <?= $lv_sec; ?>_hotacc.render();
      }
	</script>
	<div id="rowfrm" class="hidden">
		<form class="form-horizontal tmss-form-horizontal" style="padding-top: 0px; padding-bottom: 0px;">
		</form>
	</div>
  <script>			
		// server response ext
    function <?= $lv_sec; ?>_fncbckext(data) {  
			// accounting
			if ( gv_<?= $lv_sec; ?>_last_action=="09" ) {
				if(data.errtyp=="S" || data.errtyp=="W"){
					toastr.info("Documento <b>"+$("#<?= $lv_sec; ?> #finmovdoccod").prop("value")+"</b> contabilizado.", "<?= $lv_title; ?>");
					<?= $lv_sec; ?>_fnc({action: "99"});
					return;
				}
			// others
			} else if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    }
		
		// form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if ( lp_prm["action"]=="01" ) {
				var lv_pstdat = [{name: "mdlcod", value:"<?= $lv_mdlcod; ?>"},{name:"prgcod",value:"<?= $lv_prgcod; ?>"},{name:"sysdocclscod",value:"<?= $vew_data->sysdocclscod; ?>"}];
				tmssLink("?prg=finmovdoc&act=01", [{target: "_replace_with", target_id: "#<?= $lv_sec; ?>", post_data: lv_pstdat}]);
				return false;
			}
					
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
				//
				// obtengo datos de handsontable de Cuentas
				var lo_dat = <?= $lv_sec; ?>_hotacc.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["finacctxt"]!="" && lo_dat[i]["finacctxt"]!=undefined ) {
            if(lo_dat[i]["finmovdocacccod"] == undefined){
              	lo_dat[i]["finmovdocacccod"] = "";
            }
            var lv_debe = Number( (lo_dat[i]["finmovdocacctotD"]!=undefined && lo_dat[i]["finmovdocacctotD"] != 0 ? lo_dat[i]["finmovdocacctotD"] : (lo_dat[i]["finmovdocacctotH"] != undefined && lo_dat[i]["finmovdocacctotH"]!= 0 ? lo_dat[i]["finmovdocacctotH"] : 0)) );
      			var lv_debe_D_H = (lo_dat[i]["finmovdocacctotD"]!=undefined && lo_dat[i]["finmovdocacctotD"] != 0 ? 'D'  : (lo_dat[i]["finmovdocacctotH"] != undefined && lo_dat[i]["finmovdocacctotH"] != 0 ? 'H' : ''));
            lv_arr += "<row>"+"<finmovdocacccod>"+lo_dat[i]["finmovdocacccod"]+"</finmovdocacccod>"+"<finacccod>"+lo_dat[i]["finacccod"]+"</finacccod>"+"<finacctxt>"+lo_dat[i]["finacctxt"]+"</finacctxt><finmovdocacctot>"+lv_debe+"</finmovdocacctot><finmovdocaccblc>"+lv_debe_D_H+"</finmovdocaccblc>"+"<docsts>"+"A"+"</docsts>"+"<deleted>"+""+"</deleted></row>";	          
          }
				}
				// agrego las filas eliminadas
				for (var i=0; i< <?= $lv_sec; ?>_hotaccdel.length; i++) {
					lv_arr += "<row>"+"<finmovdocacccod>"+<?= $lv_sec; ?>_hotaccdel[i]+"</finmovdocacccod>"+"<finacccod>"+"0"+"</finacccod>"+"<finacctxt>"+""+"</finacctxt><finmovdocacctot>"+"0"+"</finmovdocacctot><finmovdocaccblc>"+""+"</finmovdocaccblc><deleted>"+"X"+"</deleted></row>";
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #finmovdocacc").prop("value", "");
				} else {
					$("#<?= $lv_sec; ?> #finmovdocacc").prop("value", lv_arr );
				}
			}			
		}		
	</script>
  <!-- submit -->
  <?php include('grldocfrmscr.frm'); ?>
</section>
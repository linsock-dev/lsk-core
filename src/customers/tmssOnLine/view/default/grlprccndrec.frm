<?php 
	// url del formulario
  $lv_lnk = '?prg=grlprccndrec';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = $vew_data->prccndcod; 

	// titulo
	$lv_title = $vew_lang->records;
	
	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'PCR';
	
	// libreria de estilos bootstrap
	include_once('_library.frm');

	// botones
	$vew_tbl['new'] = array('per'=>false);
	$vew_tbl['modL'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02') && $vew_data->prccndacccod!='');
	$vew_tbl['modR'] = array('per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02') && $vew_data->prccndacccod!='');
	$vew_tbl['canc'] = array('per'=>$vew_data->prccndacccod!='');
	$vew_tbl['sveL'] = array('per'=>$vew_data->prccndacccod!='');
	$vew_tbl['sveR'] = array('per'=>$vew_data->prccndacccod!='');
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', ''); ?>
		
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_data->prccndtxt; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->prccndcod; ?><?= gethtml('prccndcod', 'hidden', $vew_data->prccndcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<?php
							if($vew_data->prccndacccod=='' && count($vew_data->prccndaccseq)==0){                  
								echo '<div class="col-md-12">';
								echo '<div class="row"><div class="col-xs-1 col-md-3"></div><div class="col-xs-10 col-md-6"><h3>Configuraci&oacute;n insuficiente</h3>';
								echo '<blockquote><p>No hay definidas ninguna secuencia de acceso para la condici&oacute;n.</p></blockquote></div><div class="col-xs-1 col-md-3"></div></div>';
								echo '</div>';
							} else {
								$lv_curdte = new Datetime();
								$lv_acc = array(''=>'');
								foreach($vew_data->prccndaccseq as $lv_row){ 
                  $lv_acc[ $lv_row['prccndacccod'] ] = $lv_row['prccndacctxt'].($lv_row['prccndaccseqsynprc']==1 && $vew_prcsync?' (centralizado)':''); 
                }
								echo '<div class="col-md-12">
												<div class="card '.($vew_data->prccndacccod!=''?'tmss-hot-ttl':'').'">
													<div class="card-header">
														<div class="card-title">
															'.$vew_lang->record.'
															<span class="tmss-card-icon"><i class="fas fa-clipboard"></i></span>
														</div>
													</div><!--header-->
													<!-- Modo lectura -->
													<div class="card-body tmss-card-body-edit">';
								echo vew_boot($lv_colsm13143, 
															array('label1'=>$vew_lang->date, 
																		'input1'=>gethtml('prccndrecdte', 'docdte', ($vew_data->prccndrecdte != '' ? $vew_data->prccndrecdte : $lv_curdte->format('d/m/Y')), $lv_always_enabled),
																		'label2'=>$vew_lang->access,
																		'input2'=>gethtml('prccndacccod', $lv_acc, $vew_data->prccndacccod, $lv_always_enabled),
																		'input3'=>'<div class="text-center">
																								<a href="#" id="btnshw" class="btn btn-info" title="Mostrar">
																									<i class="fas fa-cogs"></i>
																									<span class="hidden-xs"> '.$vew_lang->show.'</span>
																								</a>'.
																							'</div>'));
								echo ' 		</div><!--body-->
												</div><!-- card -->';
								echo '</div>';

								if($vew_data->prccndacccod!='') {
									$lv_fldstr = $vew_doc->getTagValue($vew_data->prccndacc->prccndaccatr,'fld');
									$lv_fld = json_decode( html_entity_decode($lv_fldstr), true);
									echo '<div class="col-md-12">';
									echo gethtml('prccndrecdte', 'hidden', $vew_data->prccndrecdte);
									echo gethtml('prccndacccod', 'hidden', $vew_data->prccndacccod);
									echo gethtml('prccndrec', 'hidden', $vew_data->prccndrec);
									echo gethtml('prcschcnd', 'hidden', $vew_data->prcschcnd);
									echo '<div id="prcschcndhot"></div>';
									echo '</div>';
								}
							}
						?>
					</div><!-- /row -->
				</div> <!-- /_tab001 -->
				
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
    
  </form>
	<script>
		// MOSTRAR
		$("#<?= $lv_sec; ?> #btnshw").on("click",function(e){ e.preventDefault();
			var lv_dte = $("#<?= $lv_sec; ?> #prccndrecdte").prop("value");
			if( lv_dte=="" ){ 
				$("#<?= $lv_sec; ?> #prccndrecdte").parent().parent().parent().addClass("has-error"); toastr.warning("Debe inidicar la fecha."); $("#<?= $lv_sec; ?> #prccndrecdte").focus(); return; 
			} else { 
				$("#<?= $lv_sec; ?> #prccndrecdte").parent().parent().parent().removeClass("has-error"); 
			}
			var lv_acc = $("#<?= $lv_sec; ?> #prccndacccod option:selected").prop("value");
			if( lv_acc=="" ){ 
				$("#<?= $lv_sec; ?> #prccndacccod").parent().parent().addClass("has-error"); 
				toastr.warning("Debe seleccionar una tabla."); $("#<?= $lv_sec; ?> #prccndacccod").focus(); return; 
			} else {
				$("#<?= $lv_sec; ?> #prccndacccod").parent().parent().removeClass("has-error"); 
			}
			tmssLink("?prg=grlprccndrec&act=03", [{target: "_replace_with", target_id: "#<?= $lv_sec; ?>", post_data: [{name:"prccndcod", value:$("#<?= $lv_sec; ?> #prccndcod").prop("value")}, {name:"prccndrecdte", value:lv_dte}, {name:"prccndacccod", value:lv_acc}] }] );
		});
		
		
		$(function(e){
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab001']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
		});
	</script>
	<?php if($vew_data->prccndacccod!=''){ ?>
	<script>
		/**
		 *
		 *	R E G I S T R O S
		 *
		 */
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      var lv_ro = <?= ($vew_readonly?'true':'false'); ?>;
      var lv_ro_color = "#F1F1F1";
      var lv_color = "#FFFFFF";
      
      var lv_sca = typeof <?= $lv_sec; ?>_hotdoc != "undefined" && <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( row, "grldatprcsca" ) != null;
      if(lv_sca){
        var lv_scahot = JSON.parse( <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( row, "grldatprcsca" ) );

        //si no hay ninguna columna no eliminada cuenta que no hay escala
        if( lv_scahot.length==0 || typeof lv_scahot[0]["deleted"] != "undefined" ){ lv_sca = false; }
      }
      
      td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
      
			switch(prop){
        case "prccndstrdte":case "prccndenddte":
          Handsontable.renderers.DateRenderer.apply(this, arguments);
          break;
      	case "prccndval":case "prccndqty":
          Handsontable.renderers.NumericRenderer.apply(this, arguments);
          break;
        case "icn":
          td.style.backgroundColor = "#F1F1F1";

          if( typeof <?= $lv_sec; ?>_hotdoc != "undefined" ){
            var lv_rowdat = <?= $lv_sec; ?>_hotdoc.getSourceDataAtRow(row); 
            var lv_valid = typeof lv_rowdat.prccndqty != "undefined" && typeof lv_rowdat.prccnduntcod != "undefined" && typeof lv_rowdat.prccndval != "undefined" && typeof lv_rowdat.curcod != "undefined";

            if( lv_valid && <?= ( $vew_actcod != '00' && $vew_actcod != '03' ? true : "lv_sca" ); ?> ){
              $(td).empty().append("<div class='text-center cursor-pointer' onclick='<?= $lv_sec; ?>_priceScale("+row+");'><a href='#' style='color: " + (lv_sca?"#2fa4e7;":"#000000;") + "'><span class='fas fa-chart-line'></span></a></div>");
            }
          }
          break;
        case "prccnduntcod":case "curcod":
          Handsontable.renderers.TextRenderer.apply(this, arguments);
        	td.style.backgroundColor = (lv_ro || lv_sca?lv_ro_color:lv_color);
          break;
        default:
          Handsontable.renderers.TextRenderer.apply(this, arguments);
      }
		};
		var <?= $lv_sec; ?>_hotdoctmpchg = [];
		var <?= $lv_sec; ?>_hotdoctmpdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #prcschcndhot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 296,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["row_above","row_below","remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: <?= ($vew_readonly?0:1); ?>,
			colHeaders: [ "Desde", "Hasta", <?php foreach($lv_fld as $lv_row){echo '"'.strtoupper($lv_row['prccndaccfldtxt']).'",';} ?> "Valor", "Moneda", "Cantidad", "UM", "Escala"],
			columns: [
				{type: "date", data: "prccndstrdte", width: 75, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					dateFormat: 'DD/MM/YYYY',
					correctFormat: true,
					allowEmpty: false,
					datePickerConfig: { firstDay: 0, showWeekNumber: false, numberOfMonths: 1 }
				},
				{type: "date", data: "prccndenddte", width: 75, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					dateFormat: 'DD/MM/YYYY',
					correctFormat: true,
					allowEmpty: false,
					datePickerConfig: {	firstDay: 0, showWeekNumber: false, numberOfMonths: 1 }
				},
				<?php $lv_cnt=0; foreach($lv_fld as $lv_row){ $lv_cnt++; ?>
					{type: "text", 		data: "key<?= $lv_cnt; ?>", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				<?php } ?>
				{type: "numeric", data: "prccndval", 		renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "text", 		data: "curcod", width:25, 			renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "numeric", data: "prccndqty", 		renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "text", 		data: "prccnduntcod", width:25, renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
        {type: "text", 		data: "icn", width:25,renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true }
			],cells: function(row, col, prop){ 
        var cellProperties = {}

        var lv_sca = typeof <?= $lv_sec; ?>_hotdoc != "undefined" && <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( row, "grldatprcsca" ) != null;
        if(lv_sca){
          var lv_scahot = JSON.parse( <?= $lv_sec; ?>_hotdoc.getDataAtRowProp( row, "grldatprcsca" ) );          
          //si no hay ninguna columna no eliminada cuenta que no hay escala
          if( lv_scahot.length > 0 && typeof lv_scahot[0]["deleted"] != "undefined" ){ lv_sca = false; }
        }
        if ( ( prop == "prccnduntcod" || prop == "curcod" ) && lv_sca ) { cellProperties.readOnly = true; }

        return cellProperties;
      },
      beforeRemoveRow: function(index, amount, logicalRows) {
        //convierte a toda la nueva fila en valida
        var lv_cells = <?= $lv_sec; ?>_hotdoc.getCellMetaAtRow( index );
        for( let i=0; i<lv_cells.length; i++ ){ <?= $lv_sec; ?>_hotdoc.setCellMeta( lv_cells[i].row, lv_cells[i].col, "valid", true ); }
        
        // me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["prccndrowcod"]!='' && lv_dat[i]["prccndrowcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdoctmpdel.push( lv_dat[i] );
					}
				}
			},
      afterRemoveRow: function(index, amount, physicalRows, source) {
				let lv_tblLength = Array.from( <?= $lv_sec; ?>_hotdoc.getSourceDataAtCol( 0 ).keys() ).length;
        let lv_rows = Array.from( <?= $lv_sec; ?>_hotdoc.getSourceDataAtCol( 0 ).keys() );
                                                                     
        //se remueve la ulltima fila
      	lv_rows.splice( lv_rows.length-1, 1 );
                                                                     
        //se validan cada una de las filas                                                             
        <?= $lv_sec; ?>_hotdoc.validateRows( lv_rows, (valid) => {} );
        
        let lv_cols = Array.from( <?= $lv_sec; ?>_hotdoc.getCellMetaAtRow( lv_tblLength - 1 ).keys() );
        
        //se validan todas las columnas de la fila
        for(let i=0; i < lv_cols.length; i++){ <?= $lv_sec; ?>_hotdoc.setCellMeta( lv_tblLength -1, i , "valid", true ); }
      },
      beforeChange: function(changes, source){
        if(source=="CopyPaste.paste"){
          for(let i=0; i < changes.length; i++){
            changes[i][3] = changes[i][3].toString().replace(/[\r]/g, '');
          }
        }
      }
		};
    
		var <?= $lv_sec; ?>_hotdoc;
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [<?php
				$lv_buffer = '';
				foreach( $vew_data->prcrec as $lv_row) {
					$lv_key = $lv_row['srcobjcod001'];
					$lv_keyarr = explode(';',$lv_key);
					$lv_keystr = '';
					$lv_cnt=1;
					foreach($lv_keyarr as $lv_rowkey){
						if(isset($lv_fld[$lv_cnt-1])){ $lv_keystr .= 'key'.$lv_cnt.':"'.$lv_rowkey.'", '; }
						$lv_cnt++;
					}
          $lv_prcsca = array();
          foreach($vew_data->prcsca as $lv_scarow){
            if ($lv_scarow['prccndrowcod'] == $lv_row['prccndrowcod']){
              $lv_prcsca[] = $lv_scarow;
            }            
          }
          
					$lv_buffer .= ($lv_buffer==''?'':', ').
            '{prccndrowcod:"'.$lv_row['prccndrowcod'].'", '.
            $lv_keystr.
            'prccndcod: "'.$lv_row['prccndcod'].'", '.
            'prccndval: "'.($lv_row['curcod']!=''?( $lv_row['prccndval'] != '0' ? $lv_row['prccndval'] : '0' ):'').'", '.
            'curcod: "'.$lv_row['curcod'].'", '.
            'prccndqty: "'.($lv_row['prccnduntcod']!=''?( $lv_row['prccndqty'] != '0' ? $lv_row['prccndqty'] : '0' ):'').'", '.
            'prccnduntcod: "'.$lv_row['prccnduntcod'].'", '.
            'prccndstrdte: "'.date_format($lv_row['prccndstrdte'],'d/m/Y').'", '.
            'prccndenddte: "'.date_format($lv_row['prccndenddte'],'d/m/Y').'"'.
            (!empty($lv_prcsca) ? ', grldatprcsca: "'.addslashes(json_encode($lv_prcsca)).'"}' : '}');
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
    
    
    function <?= $lv_sec; ?>_priceScale( lp_row ) {
      var lv_rowdat = <?= $lv_sec; ?>_hotdoc.getSourceDataAtRow(lp_row);
      
      var lv_valid = typeof lv_rowdat.prccndqty != "undefined" && typeof lv_rowdat.prccnduntcod != "undefined" && typeof lv_rowdat.prccndval != "undefined" && typeof lv_rowdat.curcod != "undefined";
      if( !lv_valid ){ return false; }
      
    	lv_rowdat['readonly'] = <?= ($vew_readonly ? 'true' : 'false') ?>;
      tmssCallProcess("?prg=grlprccndrec&act=prcsca", lv_rowdat, function(data){
        BootstrapDialog.show({
          title: "Escala de precios",
          message: $(data),
          draggable: true,
          closable: <?= ($vew_readonly ? 'true' : 'false') ?>,
          size: BootstrapDialog.SIZE_WIDE,
          buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialogItself){ dialogItself.close(); } }
                    <?php if(!$vew_readonly){ ?>  
                      ,
                      {	id:"btn-accept", label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success",	action: function(dialog){ 
                        let lv_ret = eval( dialog.$modalBody.find("section").attr("id") + "_getData()" );
                        
												//si hay errores se le avisa al usuario que los corrija
                    		if( lv_ret.err ){ toastr.warning("Corrija los errores en la tabla"); return false; }
                                                                                                                               
                        var lv_dat = lv_ret.data;
                        var lv_del = lv_ret.del;
                        var lv_finaldata = [];
                        for (var i=0; i<lv_dat.length; i++){ lv_finaldata.push(lv_dat[i]); }
                        
                        for (var i=0; i<lv_del.length; i++){
                          lv_del[i]['deleted'] = 'X';
                          lv_finaldata.push(lv_del[i]);
                        }
                        
                        <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lp_row, "grldatprcsca", JSON.stringify(lv_finaldata));
                        dialog.close();
                      }
                    } 
                  <?php } ?>
          ],
          onshown: function(dialog){
        		let secID = dialog.$modalBody.find("section").attr("id"); 
        		eval( "if( typeof " + secID + "_hotdoc  != 'undefined' ){ " + secID + "_hotdoc.render();" + secID + "_hotdoc.render(); }" )
      		}
        });
      });
    }
    
	</script>
	<?php } ?>
  <script>
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {

				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
				var lv_key="";
				var lv_cnt;
				for (var i=0; i<lo_dat.length; i++) {
					lv_key = "";
					lv_cnt=1;
					while(lo_dat[i]["key"+lv_cnt]!=undefined){
						lv_key += (lv_key==""?"":";")+lo_dat[i]["key"+lv_cnt];
						lv_cnt++;
					}
					if ( lv_key!="" && lv_key!=undefined ){
						lv_arr.push({	"prccndrowcod":lo_dat[i]["prccndrowcod"],
													"srcobjtyp":"SYS_PCN",
													"srcobjcod001":lv_key,
													"prccndval":lo_dat[i]["prccndval"],
													"prccndcurcod":lo_dat[i]["curcod"],
													"curcod":lo_dat[i]["curcod"],
													"prccndqty":lo_dat[i]["prccndqty"],
													"prccnduntcod":lo_dat[i]["prccnduntcod"],
													"prccndstrdte":lo_dat[i]["prccndstrdte"],
													"prccndenddte":lo_dat[i]["prccndenddte"],
                         	"grldatprcsca":(lo_dat[i]["grldatprcsca"] == undefined ? "" : lo_dat[i]["grldatprcsca"]),
													"docsts":"A"
												});
					}
				}
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdoctmpdel.length; i++) {
					lv_arr.push({	"prccndrowcod":<?= $lv_sec; ?>_hotdoctmpdel[i]["prccndrowcod"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #prccndrec").val("");						
				} else {
					$("#<?= $lv_sec; ?> #prccndrec").val( JSON.stringify( lv_arr ) );
				}
			}
		}
			
    // edit mode ext
    function <?= $lv_sec; ?>_formeditext( lp_prm ) {
    	tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02' || $vew_data->prccndacccod==''?'true':'false'); ?>);
    }
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section> 
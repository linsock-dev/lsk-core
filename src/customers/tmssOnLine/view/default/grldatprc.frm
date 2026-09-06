<?php		
	// url del formulario
  $lv_lnk = '?prg=grlprcsch';

	// campos requeridos
	$vew_input->RequiredFields( array('prcschtxt','mdlcod','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->prcschcod; 

	// titulo
	$lv_title = $vew_lang->prices;
	
	// módulo y programa
	$lv_mdlcod = '';
	$lv_prgcod = '';
		
	// librería de estilos bootstrap
	include_once('_library.frm');	
	
	$vew_actcod = ($vew_data->readonly=='false'?'02':'03');
	$vew_data->totalonly = ($vew_data->totalonly == "true" ? true : false);
	$lv_secdoc = ($vew_data->sec!=''?$vew_data->sec:$lv_sec);	
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<textarea id="doc" name="doc" class="hidden"><?= $vew_data->doc; ?></textarea>
	<textarea id="grldatprc" name="grldatprc" class="hidden"></textarea>
	<div id="prcschcndhot"></div>
	<script>
		//	C O N D I C I O N E S
		var <?= $lv_secdoc; ?>_hot_grldatprc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if( <?= $lv_secdoc; ?>_hot_grldatprc!=undefined) {
				var lv_prccod = parseInt(<?= $lv_secdoc; ?>_hot_grldatprc.getDataAtRowProp(row,"prccndcod"));
				var lv_prcchg = <?= $lv_secdoc; ?>_hot_grldatprc.getDataAtRowProp(row,"prcchgman");
				var lv_prcrow = <?= $lv_secdoc; ?>_hot_grldatprc.getDataAtRowProp(row,"prccndrowcod");
				var lv_prcman = <?= $lv_secdoc; ?>_hot_grldatprc.getDataAtRowProp(row,"prcschcndman");
				var lv_prcstd = <?= $lv_secdoc; ?>_hot_grldatprc.getDataAtRowProp(row,"prcschcndstd");
				lv_prcman = (lv_prcman==null?"":lv_prcman.toLowerCase());
				var lv_rowstr = parseInt(<?= $lv_secdoc; ?>_hot_grldatprc.getDataAtRowProp(row,'prcschcndrowstr'));
				var lv_ro = (lv_prcstd!=""?"#E3E3E3":(lv_prccod==0?"#E3E3E3":"#F1F1F1"));
				var lv_no_ro = "#FFFFFF";
				if (prop=="prccndtxt" ){
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					cellProperties.readOnly = true;
					td.style.backgroundColor = lv_ro;
					if(lv_prccod==0){td.style.fontWeight = 'bold';}
				} else if (prop=="prccndsts") {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					cellProperties.readOnly = true;
					td.style.backgroundColor = lv_ro;
					var lv_icn;
					if(lv_prcchg!="") { lv_icn="<span class='far fa-hand-paper' title='Actualizado manualmente'></span>"; }
					$(td).empty().append(lv_icn);
				} else if(prop=="prccndval" ){
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
					cellProperties.readOnly = (lv_prcman=="val"?<?= ($vew_readonly?'true':'false'); ?>:true);
					td.style.backgroundColor = (lv_prcman=="val"?<?= ($vew_readonly?'lv_ro':'lv_no_ro'); ?>:lv_ro);
				} else if( prop=="prccndcurcod" ){
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					cellProperties.readOnly = true;
					td.style.backgroundColor = lv_ro;
				} else if( prop=="prccndqty" ){
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
          cellProperties.readOnly = (lv_prcman=="can"?<?= ($vew_readonly?'true':'false'); ?>:true);
					td.style.backgroundColor = (lv_prcman=="can"?<?= ($vew_readonly?'lv_ro':'lv_no_ro'); ?>:lv_ro);
				} else if( prop=="prccnduntcod" ){
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					cellProperties.readOnly = true;
					td.style.backgroundColor = lv_ro;
				}else if(prop=="prccndtot"){
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
					cellProperties.readOnly = (lv_prcman=="tot"?<?= ($vew_readonly?'true':'false'); ?>:true);
					td.style.backgroundColor = (lv_prcman=="tot"?<?= ($vew_readonly?'lv_ro':'lv_no_ro'); ?>:lv_ro);
					if(lv_rowstr!=0){td.style.fontWeight = "bold";}
				} else if( prop=="curcod" ) {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					cellProperties.readOnly = true;
					td.style.backgroundColor = lv_ro;
				} else if( prop=="prccndacccod" ) {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					cellProperties.readOnly = true;
					td.style.backgroundColor = lv_ro;
        }else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				}
			}
		};
		var <?= $lv_secdoc; ?>_hot_grldatprc_tmpchg = [];
		var <?= $lv_secdoc; ?>_hot_grldatprc_tmpdel = [];
		var <?= $lv_secdoc; ?>_hot_grldatprc_calc = false;
		var <?= $lv_secdoc; ?>_hot_grldatprc_cnt = $("#<?= $lv_sec; ?> #prcschcndhot")[0];
		var <?= $lv_secdoc; ?>_hot_grldatprc_set = {
			height: 320,
			stretchH: "all",
			autoColumnSize: true,
			autoWrapRow: false,
			rowHeaders: false,
			minSpareRows: 0,
			colHeaders: [ "", "Condicion", <?= !$vew_data->totalonly ? '"Valor", "Moneda", "Cantidad", "Unidad",' : '' ?> "Total", "Moneda","Cuenta" ],
			columns: [
				{type: "text", data: "prccndsts", width: 15, renderer: <?= $lv_secdoc; ?>_hot_grldatprc_renderer, readOnly: true},
				{type: "text", data: "prccndtxt", renderer: <?= $lv_secdoc; ?>_hot_grldatprc_renderer,	<?= ($vew_readonly?'readOnly: true, ':''); ?>},
        <?= !$vew_data->totalonly ? 
          '{type: "numeric", data: "prccndval", width: 50, renderer: '. $lv_secdoc.'_hot_grldatprc_renderer, numericFormat: {pattern: "0,0.00", culture: "es-AR"}, '. ($vew_readonly?'readOnly: true, ':'').'},
          {type: "text", data: "prccndcurcod", width: 25, renderer: '. $lv_secdoc.'_hot_grldatprc_renderer, numericFormat: {pattern: "0,0.00", culture: "es-AR"}, '. ($vew_readonly?'readOnly: true, ':'').'},
          {type: "numeric", data: "prccndqty", width: 50, renderer: '. $lv_secdoc.'_hot_grldatprc_renderer, numericFormat: {pattern: "0,0.00", culture: "es-AR"}, '. ($vew_readonly?'readOnly: true, ':'').'},
          {type: "text", data: "prccnduntcod", width: 25, renderer: '. $lv_secdoc.'_hot_grldatprc_renderer, numericFormat: {pattern: "0,0.00", culture: "es-AR"}, '. ($vew_readonly?'readOnly: true, ':'').'},'
        : ''
        ?>
				{type: "numeric", data: "prccndtot", width: 50, renderer: <?= $lv_secdoc; ?>_hot_grldatprc_renderer, numericFormat: {pattern: "0,0.00", culture: "es-AR"}, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
				{type: "text", data: "curcod", width: 25, renderer: <?= $lv_secdoc; ?>_hot_grldatprc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>},
			],
      beforeChange : function(changes, source){
      	<?php if(!$vew_readonly){ ?>
          if( changes!=null && <?= $lv_secdoc; ?>_hot_grldatprc!=undefined ) {
            if( <?= $lv_secdoc; ?>_hot_grldatprc_calc==false && (source=="edit" || source=="update") ) {
              if(source=="edit"){	<?= $lv_secdoc; ?>_hot_grldatprc.setDataAtRowProp(changes[0][0],"prcchgman","X","setting"); }
              if(changes[0][1] == "prccndtot" || changes[0][1] == "prccndval" || changes[0][1] == "prccndqty"){
                if(changes[0][3] == ""){
                  changes[0][3]=0;
                }
              }
              if (changes[0][1] == "prccndtot"){
                if (<?= $lv_secdoc; ?>_hot_grldatprc.getDataAtRowProp(changes[0][0], "prccndqty") == 0){
                  <?= $lv_secdoc; ?>_hot_grldatprc.setDataAtRowProp(changes[0][0],"prccndqty",1,"setting");  
                  <?= $lv_secdoc; ?>_hot_grldatprc.setDataAtRowProp(changes[0][0],"prccndval",changes[0][3],"manchg");  
                }else{
                	<?= $lv_secdoc; ?>_hot_grldatprc.setDataAtRowProp(changes[0][0],"prccndval",changes[0][3] / <?= $lv_secdoc; ?>_hot_grldatprc.getDataAtRowProp(changes[0][0], "prccndqty"),"manchg");  
                }
              }
            }
          }
    		<?php } ?>
    	},
			afterChange : function( changes, source ) {
				<?php if(!$vew_readonly){ ?>
				if( changes!=null && <?= $lv_secdoc; ?>_hot_grldatprc!=undefined ) {
          // Si hay cambio en el total, se cambiará el valor y posiblemente la cantidad. Se espera a hacer esto para realizar el llamado
					if( <?= $lv_secdoc; ?>_hot_grldatprc_calc==false && (source=="manchg") ) {
            <?= $lv_sec; ?>_refreshPrices();
					}
          // Si el cambio no es en el total, se llama de inmediato a actualizar precios
          if( <?= $lv_secdoc; ?>_hot_grldatprc_calc==false && (source=="edit" || source=="update") ) {
            if (changes[0][1] != "prccndtot"){
            	<?= $lv_sec; ?>_refreshPrices();
            }
					}
				}
				<?php } ?>
			}
		};
		var <?= $lv_secdoc; ?>_hot_grldatprc;
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_secdoc; ?>_hot_grldatprc = new Handsontable(<?= $lv_secdoc; ?>_hot_grldatprc_cnt, <?= $lv_secdoc; ?>_hot_grldatprc_set);
			var lv_dat = [<?php
				$lv_buffer='';
								
				// preparo datos provenientes del documento (a nivel de posicion)
				$lv_docprc=array(array());
				if(is_array($vew_data->docprc)){ $lv_docprc = $vew_data->docprc; }
				
				// se cargan las condiciones como estan grabadas (sin modificaciones ni calculos)
				if($vew_readonly){
					foreach($lv_docprc as $lv_tmp){
						$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
													'prccndsts:"",'.
													'prccndrowcod:"'.($lv_tmp['prccndrowcod']??'').'",'.
													'prcschcndrow:"'.$lv_tmp['prcschcndrow'].'",'.
													'prccndcod:"'.$lv_tmp['prccndcod'].'",'.
													'prccndtxt:"'.utf8_decode( (($lv_tmp['prccndtxt']??'')==null?'':$lv_tmp['prccndtxt']) ).'",'.
              						'prccndval:"'.( $lv_tmp['prccndcod']==0 ? '' :  number_format($lv_tmp['prccndval'], 2, '.', '') ).'",'.
													'prccndcurcod:"'.$lv_tmp['prccndcurcod'].'",'.
              						'prccndqty:"'.( $lv_tmp['prccndcod']==0 ? '' :  number_format($lv_tmp['prccndqty'], 2, '.', '') ).'",'.
													'prccnduntcod:"'.$lv_tmp['prccnduntcod'].'",'.
													'prccndtot:"'.($lv_tmp['prccndtot']==0?'0': number_format($lv_tmp['prccndtot'], 2, '.', '') ).'",'.
													'curcod:"'.$lv_tmp['curcod'].'",'.
													'prcschcndman:"'.$lv_tmp['prcschcndman'].'",'.
													'prcchgman:"'.$lv_tmp['prcchgman'].'",'.
              						'prccndacccod:"'.($lv_tmp['prccndacccod']??'').'"'.
              						'finacccod:"'.($lv_tmp['finacccod']??'').'"'.
													'}'; 
					}
					
				// se carga el esquema actual y sus correspondientes valores del documento
				} else {
					foreach($vew_data->sch->prcschcnd as $lv_row){ 
						// fijo los valores por default
						$lv_tmp = $lv_row;
						$lv_tmp['prccndtxt'] = utf8_decode($lv_row['prccndtxt']==null?'':$lv_row['prccndtxt']);
						$lv_tmp['prccndval'] = '0';
						$lv_tmp['prccndcurcod'] = '';
						$lv_tmp['prccndqty'] = '0';
						$lv_tmp['prccnduntcod'] = '';
						$lv_tmp['prccndtot'] = '0';
						$lv_tmp['curcod'] = '';
						$lv_tmp['prcchgman'] = '';
            //$lv_tmp['prccndacccod'] = '';
            //$lv_tmp['finacccod'] = '';
						
						// busco si la fila tiene un valor proveniente del documento
						foreach($lv_docprc as $lv_rowprc){
							if(isset($lv_rowprc['prcschcndrow'])){
								if($lv_rowprc['prcschcndrow']==$lv_row['prcschcndrow']){
									$lv_tmp = $lv_rowprc;
									//$lv_tmp['prccndtxt'] = utf8_decode($lv_row['prccndtxt']);
                  $lv_tmp['prcschcndman'] = ($lv_row['prcschcndman']??'');
                  $lv_tmp['prccndacccod'] = ($lv_row['prccndacccod']??'');
                  $lv_tmp['finacccod'] = ($lv_row['finacccod']??'');
                  $lv_tmp['prcschcndstd'] = ($lv_row['prcschcndstd']??'');
								}
							}
						}
						// armo string JSON de datos para HOT
						$lv_cnt = 0;
						$lv_buffer .= ($lv_buffer!=''?',':'').'{';
						foreach($lv_tmp as $lv_key=>$lv_val){
							if(is_array($lv_val)){
								
							} else if(is_object($lv_val)) {
								$lv_buffer .= ($lv_cnt==0?'':',').$lv_key.':"'.$lv_val->format('Y.m.d').'"';
							} else {
                if($lv_key == 'prccndqty' || $lv_key == 'prccndval' || $lv_key == 'prccndtot'){
                	$lv_val = ($lv_val == 0 ? '0' : number_format(floatval($lv_val), 2, '.', '') );
                }
								$lv_buffer .= ($lv_cnt==0?'':',').$lv_key.':"'.$lv_val.'"';
							}
							$lv_cnt++;
						}
						$lv_buffer .= '}';
					}
				}
				echo $lv_buffer;
			?>];
			<?= $lv_secdoc; ?>_hot_grldatprc.loadData( lv_dat );
			<?= $lv_secdoc; ?>_hot_grldatprc.render();
		});
	</script>
	<script>
		// actualización de precios del esquema (calculo de formulas)
		function <?= $lv_sec; ?>_refreshPrices() {
			<?php if( ($vew_data->dochdr['prcschcalctr']??'')!='' && ($vew_data->dochdr['prcschcalact']??'')!='' ){ ?>
				<?= $lv_secdoc; ?>_hot_grldatprc_calc = true;
				if( <?= $lv_secdoc; ?>_hot_grldatprc!=undefined) {
					var lv_dochdr = '<?= str_replace('\\','\\\\',json_encode($vew_data->dochdr)); ?>';
					var lv_docpos = '<?= json_encode($vew_data->docpos); ?>';
					var lv_docprc = JSON.stringify(<?= $lv_secdoc; ?>_hot_grldatprc.getSourceData());
					var lv_pstdat=[ {name:"dochdr",value: lv_dochdr},
													{name:"docpos",value: lv_docpos }, // lv_docpos
													{name:"docprc",value: lv_docprc },
													{name:"readonly",value:<?= ($vew_readonly?'true':'false');?>}
												];
					tmssCallProcessNoBackdrop("?prg=<?= ($vew_data->dochdr['prcschcalctr']??''); ?>&act=<?= ($vew_data->dochdr['prcschcalact']??''); ?>", lv_pstdat, function(data){
						var lv_dat = data.docprc;
						<?= $lv_secdoc; ?>_hot_grldatprc.loadData( lv_dat );
						<?= $lv_secdoc; ?>_hot_grldatprc.render();
						$("#<?= $lv_sec; ?> #grldatprc").val( JSON.stringify(lv_dat) );
					});
				}
				<?= $lv_secdoc; ?>_hot_grldatprc_calc = false;
			<?php } ?>
		}
		
		$(function(){
			tmssHandsontableResize(); 
			if( typeof <?= $lv_secdoc; ?>_hot_grldatprc != "undefined" ){
				$("#<?= $lv_sec; ?> #grldatprc").val( JSON.stringify(<?= $lv_secdoc; ?>_hot_grldatprc.getSourceData()) );
			}
		});
	</script>
  <script>		
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>
</section>
<?php
	// url del formulario
  $lv_lnk = "?prg=buyexp&prm_buyexpcod=".$vew_data->buyexpcod;

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = $vew_data->buyexpcod; 

	// titulo
	$lv_title = $vew_lang->expenses;
	
	// modulo y programa
	$lv_mdlcod = 'BUY';
	$lv_prgcod = 'EXP';

	$vew_actcod = ($vew_data->readonly=='1'?'03':'02');

	// librería de estilos bootstrap
	include_once('_library.frm');
	$lv_hidden = array( 'atrval'=>array('class'=>'hidden') );
		
	$lv_impobjtyp = strtoupper($vew_doc->getTagValue( $vew_data->sysdoccls->sysdocclsatr, 'impobjtyp' ));
	$lv_impobjreq = strtoupper($vew_doc->getTagValue( $vew_data->sysdoccls->sysdocclsatr, 'impobjreq' ));
	$lv_cusurl = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr, 'frmcusurl');
	$lv_cusurlchk = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr, 'frmcusurlchk');

	$lv_rejarr = array(''=>'');
	foreach($vew_data->sysdoccls->sysdocclsrej as $lv_row) {
		if (strtoupper($vew_doc->getTagValue($lv_row['sysdocclsrejatr'],'rejman'))=='X'){
			$lv_rejarr[ $lv_row['sysdocrejcod'] ] = $lv_row['sysdocrejtxt'];
		}
	}
	$lv_impobjlst = (is_array($vew_data->impobjlst)?$vew_data->impobjlst:json_decode(html_entity_decode($vew_data->impobjlst), true) );

	$col_name = ($lv_impobjtyp == 'HLT_PAT')?'cntobjtxt':'srcobjtxt';
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <div class="hidden"><?= gethtml('impobjtmp','objtyplst', ''); ?></div>
  <?= gethtml('impbojtyp','hidden', $lv_impobjtyp); ?>
	<textarea id="buyexpdocatr" name="buyexpdocatr" class="hidden"><?= $vew_data->buyexpdocatr; ?></textarea>
	<textarea name="impobjlst" id="impobjlst" class="hidden"></textarea>
	
	<form class="form-horizontal tmss-form-horizontal" style="padding-top: 0px; padding-bottom: 0px;">
		<div class="row">
      
      <div class="col-md-9">

        <?php if($lv_impobjtyp!=''){ ?>
          <!-- imputaciones -->
          <div class="card tmss-hot-ttl">
            <div class="card-header"><div class="card-title table-card-title"><span id="cardimpttl">Imputaci&oacute;n</span></div></div>
          </div>
          <div id="buyexpdocimphot" name="buyexpdocimphot"></div>
        <?php } ?>
        				
        <?php if( $lv_cusurl!='' ){ ?>
          <!-- custom -->
          <div class="card">
            <div class="card-body tmss-card-body-edit">            
              <div id="buyexpdoccus"></div>
            </div>
          </div>
      	<?php } ?>
				
				<div class="card">
          <div class="card-body tmss-card-body-edit">            
            <?php
              echo vew_boot($lv_col39, array('label'=>$vew_lang->comments,	'input'=>gethtml('buyexpdoccmt',	'doccmt1x50', $vew_data->buyexpdoccmt, $lv_default) ));
              echo vew_boot($lv_col39, array('label'=>$vew_lang->rejection,'input'=>gethtml('sysdocrejcod', $lv_rejarr, $vew_data->sysdocrejcod, $lv_default) ));
            ?>
          </div>
        </div>
        
      </div> <!-- /col-md-9 -->
      <div class="col-md-3">
        <img src="/library/images/cargarComprobante2.png" class="img-responsive">
      </div>
      
    </div> <!-- /row -->
	</form>	
  
	<script>
    <?php switch($lv_impobjtyp){
      case 'SLS_CUS':	$lv_url='?prg=slscus&act=18&prm_custxt='; $lv_srccod='cuscod'; $lv_srctxt='custxt'; $lv_srccol= $vew_lang->customer; break;
      case 'EDU_STU':	$lv_url='?prg=edustu&act=18&prm_stutxt='; $lv_srccod='stucod'; $lv_srctxt='stutxt'; $lv_srccol= $vew_lang->student; break;
      case 'BUY_SUP':	$lv_url='?prg=buysup&act=18&prm_suptxt='; $lv_srccod='supcod'; $lv_srctxt='suptxt'; $lv_srccol= $vew_lang->SUPPLIER; break;
      case 'HLT_PAT':	$lv_url='?prg=hltpat&act=18&prm_pattxt='; $lv_srccod='patcod'; $lv_srctxt='pattxt'; $lv_srccol= $vew_lang->patient; break;
      default: $lv_url=''; $lv_srccod=''; $lv_srctxt=''; break;
    } ?>
  	// I M P U T A C I O N E S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {
			if( <?= $lv_sec; ?>_hotdoc != undefined ) {
				if ( prop=="buyexpdocimpqty" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				} else {
					Handsontable.renderers.AutocompleteRenderer.apply(this, arguments);
					td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
				}
			}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #buyexpdocimphot")[0];
    var <?= $lv_sec; ?>_hotdoc_pndcnt = {};
		var <?= $lv_sec; ?>_hotdocset = {
			height: 150,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],'); ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly?'0':'1') ?>,
      licenseKey: gv_handsontable_lc,
			colHeaders: [ "<?= $lv_srccol ?>", <?= ($lv_impobjtyp=='HLT_PAT'?'"'.$vew_lang->financial.'", ':''); ?> "<?= $vew_lang->percentage; ?>"],
			columns: [
				{type: "autocomplete", data: "srcobjtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						if ( query.length>1 ) {
               tmssCallProcessNoBackdrop("<?= $lv_url; ?>" + query, [], function(data) {
                 	<?= $lv_sec; ?>_hotdocchg = [];
                  var lv_dat = [];
                  for (var i = 0; i < data.length; i++) {
                      <?= $lv_sec; ?>_hotdocchg.push({
                          <?= $lv_srctxt; ?>: data[i]["<?= $lv_srctxt; ?>"],
                          <?= $lv_srccod; ?>: data[i]["<?= $lv_srccod; ?>"],
                        	cuscod: data[i]["cuscod"],
                        	custxt: data[i]["custxt"]
                      });
                      lv_dat.push( data[i]["<?= $lv_srctxt; ?>"] );
                  }
                  process( lv_dat );
              });
						} else { process( [] ); }
					},
					strict: true
				},
        <?php if($lv_impobjtyp=='HLT_PAT'){ ?>
				{type: "autocomplete", data: "cntobjtxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
					source: function (query, process) {
						if ( query.length>1 && <?= $lv_sec; ?>_hot_paste != true) { 
              var lv_row = this.row; 
              if(lv_row != -1){
                var lv_cntsrccod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row, "srcobjcod001");
                tmssCallProcessNoBackdrop("?prg=grldatcnt&act=18&prm_invadr=X&prm_cntsrctyp=HLT_PAT&prm_cntsrccod="+lv_cntsrccod+"&prm_cnttxt="+query,[],function(data){
                    <?= $lv_sec; ?>_hotdocchg = [];
                  	var lv_dat = [];
                    for (var i = 0; i < data.length; i++) {
                        <?= $lv_sec; ?>_hotdocchg.push({
                            custxt: data[i]["cnttxt"],
                            cuscod: data[i]["cntdstcod"]
                        });
                        lv_dat.push( data[i]["cnttxt"] );
                    }
                    process( lv_dat );
                });
              }
						} else { process( [query] ); }
          },
					strict: true
				},
        <?php } ?>
				{type: "numeric", data: "buyexpdocimpqty", renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {min:"0.00", max:"100.00", pattern: "0.00", culture: "es-AR"} }
			],
			beforeChange : function(changes, source) {
        <?= $lv_sec; ?>_hot_paste = true;
				if(source=="edit" && changes[0][1]=="srcobjtxt") {
          var lv_row = changes[0][0];
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].<?= $lv_srctxt; ?> == lv_value ) {
							changes.push([ changes[0][0], "srcobjcod001", "", String(<?= $lv_sec; ?>_hotdocchg[i].<?= $lv_srccod; ?>) ]);
              <?php if($lv_impobjtyp=='HLT_PAT'){ ?>
            	changes.push([ changes[0][0], "srcobjcod002", "", String(<?= $lv_sec; ?>_hotdocchg[i].cuscod) ]);
              <?= $lv_sec; ?>_hotdoc_pndcnt[lv_row] = <?= $lv_sec; ?>_hotdocchg[i].custxt;
              <?php } ?>
              break;
						}
					}
				}
				if(source=="edit" && changes[0][1]=="cntobjtxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].custxt == lv_value) {
							changes.push([ changes[0][0], "srcobjcod002", "", String(<?= $lv_sec; ?>_hotdocchg[i].cuscod) ]);
              break;
						}
					}
          <?= $lv_sec; ?>_hot_paste = false;
				}
			},
        afterChange: function(changes, source) {
          if (!changes) return;
          for (var i=0; i<changes.length; i++) {
              var lv_row = changes[i][0];
              var lv_prop = changes[i][1];
              if (lv_prop=="srcobjcod001" && <?= $lv_sec; ?>_hotdoc_pndcnt.hasOwnProperty(lv_row)) {
                  var lv_cnttxt = <?= $lv_sec; ?>_hotdoc_pndcnt[lv_row];
                  delete <?= $lv_sec; ?>_hotdoc_pndcnt[lv_row];
                  <?= $lv_sec; ?>_hot_paste = true;
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row, "cntobjtxt", lv_cnttxt);
                  <?= $lv_sec; ?>_hot_paste = false;
              }
          }
      },
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["buyexpdocimpcod"]!="" && lv_dat[i]["buyexpdocimpcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
				}
			}
		};
		var <?= $lv_sec; ?>_hotdoc;

		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);
			var lv_dat = [<?php
				$lv_buffer='';
        foreach($vew_data->impobjlst as $lv_row){
          $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                        'buyexpdocimpcod:"'.($lv_row['buyexpdocimpcod']??'').'",'.
                        'srcobjtyp:"'.($lv_row['srcobjtyp']??'').'",'.
                        'srcobjcod001:"'.($lv_row['srcobjcod001']??'').'",'.
                        'srcobjtxt:\''.$lv_row['srcobjtxt'].'\','.
                        'srcobjcod001:"'.($lv_row['srcobjcod001']??'').'",'.
                        'cntobjtxt:\''.($lv_row['cntobjtxt']??'').'\','.
                        'buyexpdocimpqty: '.($lv_row['buyexpdocimpqty']??'').' }';
        }
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
		});
	</script>
	<script>
    function <?= $lv_sec; ?>_getData(){
      var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData().slice(0, -1);
			for (var i=0; i < <?= $lv_sec; ?>_hotdocdel.length; i++) {
          <?= $lv_sec; ?>_hotdocdel[i]["deleted"] = "X";
					lv_dat.push(<?= $lv_sec; ?>_hotdocdel[i]);
			}
      return lv_dat
    }
  </script>
	<script>
    $(function(){
			// CUSTOM. recupero pantalla de usuario
			<?php if($lv_cusurl!=''){ ?>
				var lv_pstdat = [{name:"lv_sec",value:"<?= $lv_sec; ?>"},{name:"buyexpdocatr",value:$("#<?= $lv_sec; ?> #buyexpdocatr").text()}];
				tmssCallProcessNoBackdrop("<?= $lv_cusurl; ?>",lv_pstdat,function(data){
					$("#<?= $lv_sec; ?> #buyexpdoccus").html(data);
				});
			<?php } ?>
		});
    
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	</script>
</section>
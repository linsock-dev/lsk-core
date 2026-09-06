<?php	
	/* url del formulario */
  $lv_lnk = '?prg=stkmovelb&prm_stkmovelbcod='.$vew_data->stkmovelbcod;

	/* campos requeridos */
	$lv_reqfld = array('stkmovelbdte', 'srcobjcod', 'srcobjtxt', 'matcod', 'mattxt', 'matqty', 'matuntcod', 'docsts', 'matbchcodext', 'matbchduedte');
	$vew_input->RequiredFields( $lv_reqfld );

	/* clave del documento */
	$lv_dockey = $vew_data->stkmovelbcod; 

	/* titulo */
	$lv_title = $vew_lang->elaboration;

	/* modulo y programa */
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'ELB';

	/* librer?a de estilos bootstrap */
	include_once('_library.frm');

	//$vew_readonly = (intval($vew_data->stkmovdoccod)!=0?true:false);
	$vew_readonly = ($vew_data->docsts=='C' || $vew_invdoc->docsts=='C'?true:false);
	
	$lv_bchduedteedt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'bchduedteedt');
	$lv_bchduedtebse = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'bchduedtebse');
	$lv_bchduedtemov = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'bchduedtemov');

	/* Determinacion de la fecha de vencimiento de la elaboracion */
	if(!$vew_readonly && strtoupper($lv_bchduedteedt) == 'X' && $lv_bchduedtebse != '' && $vew_data->matstkrel!='' && $vew_data->matusebch==1){
    $lv_dte = '';
    
    for($i = 0; $i < count($vew_data->stkmovelbmat); $i++){
      if(!empty($vew_data->stkmovelbmat[$i]['matbchduedte'])){
      	if($lv_dte === ''){ 
          $lv_dte = $vew_data->stkmovelbmat[$i]['matbchduedte']; 
        }
      
        if(strtoupper($lv_bchduedtebse) == 'FIRST'){
          if($vew_data->stkmovelbmat[$i]['matbchduedte']->getTimestamp() < $lv_dte->getTimestamp()){
          	$lv_dte = $vew_data->stkmovelbmat[$i]['matbchduedte'];
        	}
        }else if(strtoupper($lv_bchduedtebse) == 'LAST'){
          if($vew_data->stkmovelbmat[$i]['matbchduedte']->getTimestamp() > $lv_dte->getTimestamp()){
            $lv_dte = $vew_data->stkmovelbmat[$i]['matbchduedte'];
          }
        }
      }
    }  
    $lv_dte = ($lv_dte != '') ? $lv_dte->modify($lv_bchduedtemov .' days') : $vew_data->matbchduedte;   
  }else{
    $lv_dte = $vew_data->matbchduedte;
  }
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

	<form id="stkmovelbntffrm" name="stkmovelbntffrm" method="POST">
		<input type="submit" class="hidden">
		<textarea id="matsercodextlst" name="matsercodextlst" class="hidden"><?= (isset($vew_data->matsercodextlst)?$vew_data->matsercodextlst:''); ?></textarea>
    <input type="hidden" id="stkmovelbcod" name="stkmovelbcod" value="<?= $vew_data->stkmovelbcod; ?>">
		<div class="row">
			<div class="col-sm-6">
        
        <?php if(intval($vew_data->stkmovdoccod)!=0) { ?>
          <div class="card">
            <div class="card-header">
              <div class="card-title">
                <?= $vew_lang->inventory; ?>
                <a href="#" id="stkmovdoccodttl" class="pull-right"><strong><?= $vew_data->stkmovdoccod; ?></strong></a>
                <input type="hidden" id="stkmovdoccod" name="stkmovdoccod" value="<?= $vew_data->stkmovdoccod; ?>">
              </div>
            </div>
          </div>
         <?php } ?>
        
        <div class="card">
          <div class="card-header">
            <div class="card-title">
              <?= $vew_lang->batch; ?>
              <?php if($vew_data->matstkrel!='' && $vew_data->matusebch==1) { ?>
              	<strong class="card-icon"><?= ($vew_data->matbchcod!=''?'# '.$vew_data->matbchcod : '# '.$vew_data->stkmatbchcod); ?></strong>
              	<input type="hidden" id="matbchcod" name="matbchcod" value="<?= $vew_data->matbchcod; ?>">
              <?php } ?>
            </div>
          </div>
          <div class="card-body tmss-card-body-edt">
            <?php
              if($vew_data->matstkrel!='' && $vew_data->matusebch==1) {
                echo '<div class="toggle hidden">
                        <div class="form-group  tmss-form-group">
                          <label class="col-xs-5 control-label text-nowrap">Crea automaticamente</label>
                          <div class="col-xs-7"><input type="checkbox" id="matbchcre" name="matbchcre" disabled></div>
                        </div>
                      </div>';
                echo vew_boot($lv_col39, array('label'=>$vew_lang->batch, 	'input'=>gethtml('matbchcodext', 'doccmt1x20', $vew_data->matbchcodext, $lv_default )));
                echo vew_boot($lv_col39, array('label'=>$vew_lang->duedate, 'input'=>gethtml('matbchduedte', 'docdte', $lv_dte, (strtoupper($lv_bchduedteedt) == 'X' ? $lv_default : $lv_always_disabled)  )));
              } else {
                echo "(Material no sujeto a Lote)";
              }
            ?>
          </div>
        </div>
			</div>
			<div class="col-sm-6">
        <div class="card tmss-hot-ttl">
          <div class="card-header">
            <div class="card-title">
            	<?= $vew_lang->serialnumbers; ?>
            </div>
          </div>
          <?php if($vew_data->matstkrel!='' && $vew_data->matuseser==1) { ?>
            <div class="card-body tmss-card-body-edt">
              <label class="control-label"><input type="checkbox" id="matsercre" name="matsercre" disabled> Crea automaticamente</label><br>
            </div>
          <?php } else {?>
          	<div class="card-body tmss-card-body-edt">(Material no sujeto a Nro. de Serie)</div>
          <?php } ?>
        </div>
				<?php if($vew_data->matstkrel!='' && $vew_data->matuseser==1) { ?> <div id="stkmovelbserhot"></div> <?php } ?>
			</div>
		</div>
	</form>
	<script>
		/**
		 *
		 *	S E R I E S
		 *
		 */
		var <?= $lv_sec; ?>_hotser_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if (<?= $lv_sec; ?>_hotser!=undefined) {
				var lv_ro_color = "#F1F1F1";
				var lv_color = "#FFFFFF";
				var lv_ro = ($("#<?= $lv_sec; ?> #matsercre").is(":checked")?true:<?= ($vew_readonly?'true':'false'); ?>);
				if ( prop=="matsercod" ) {
					Handsontable.renderers.TextRenderer.apply(this, arguments);			
					td.style.backgroundColor = lv_ro_color;
					cellProperties.readOnly = true;
				} else if ( prop=="matsercodext" ) {
					Handsontable.renderers.TextRenderer.apply(this, arguments);			
					td.style.backgroundColor = (lv_ro?lv_ro_color:lv_color);
					cellProperties.readOnly = lv_ro;
				}
			}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotserchg = [];
		var <?= $lv_sec; ?>_hotserdel = [];
		var <?= $lv_sec; ?>_hotsercnt = $("#<?= $lv_sec; ?> #stkmovelbserhot")[0];
		var <?= $lv_sec; ?>_hotserset = {
			height: 255,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: 0,
			colHeaders: [ "ID", "Nro Serie",""],
			columns: [
				{type: "text", data: "matsercod", renderer: <?= $lv_sec; ?>_hotser_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> },
				{type: "text", data: "matsercodext", renderer: <?= $lv_sec; ?>_hotser_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?> }
			]
		};
		var <?= $lv_sec; ?>_hotser;
		
   	<?php if($vew_data->matstkrel!='' && $vew_data->matuseser==1) { ?>
      tmssLoadScript("handsontable",function(){			
        <?= $lv_sec; ?>_hotser = new Handsontable(<?= $lv_sec; ?>_hotsercnt, <?= $lv_sec; ?>_hotserset);	
        var lv_dat = [<?php
          $lv_buffer='';
          for($i=0; $i<$vew_data->matqty && ($vew_data->matstkrel!='' && $vew_data->matuseser==1); $i++) {
            $lv_row = (isset($vew_data->matsercodextlst[$i])?$vew_data->matsercodextlst[$i]:array('matsercod'=>'','matsercodext'=>''));
            $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                          'matsercod:"'.$lv_row['matsercod'].'",'.
                          'matsercodext:"'.$lv_row['matsercodext'].'"'.
                        '}'; 
          }
          echo $lv_buffer;
        ?>];
        <?= $lv_sec; ?>_hotser.loadData( lv_dat );
        <?= $lv_sec; ?>_hotser.render();
      });		
    <?php } ?>
	</script>
	<script>
		
		$("#<?= $lv_sec; ?> #stkmovdoccodttl").on("click", function(e) {
			e.preventDefault();
			tmssLink("?prg=stkmovdoc&act=03&prm_mdlcod=STK&prm_prgcod=SIV&prm_objtyp=stk_siv&prm_stkmovdoccod=<?= $vew_data->stkmovdoccod; ?>", [{target: "_new_section"}] );
			$.each(BootstrapDialog.dialogs, function(id, dialog){ dialog.close(); });
		});
		
		tmssLoadScript("toggle",function(){
			$("#<?= $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: 'success', offstyle: 'default', on: 'Si', off: 'No', size: 'small' });
			});
		});
		
		$("#<?= $lv_sec; ?> #matbchcre").on("change",function(e){
			if(!$(this).is(":checked")){
				$("#<?= $lv_sec; ?> #matbchcodext").prop("readonly","");
			} else {
				$("#<?= $lv_sec; ?> #matbchcodext").prop("value","").prop("readonly","readonly");		
			}
		})
		
		$("#<?= $lv_sec; ?> #matsercre").on("change",function(e){
			if(!$(this).is(":checked")){
				$("#<?= $lv_sec; ?> input[name^='matsercodext']").prop("readonly","");
			} else {
				$("#<?= $lv_sec; ?> input[name^='matsercodext']").prop("value","").prop("readonly","readonly");		
			}
			<?= $lv_sec; ?>_hotser.render();
		})

		$("#stkmovelbntffrm").on("submit",function(e){ e.preventDefault(); e.stopPropagation();
			<?php if($vew_data->matstkrel!='' && $vew_data->matusebch==1) { ?>
			if( !$("#<?= $lv_sec; ?> #matbchcre").is(":checked") ) {
				if ( $("#<?= $lv_sec; ?> #matbchcodext").prop("value").trim()=="" ) {
					toastr.warning("Si indic&oacute; numeraci&oacute;n manual, debe completar el N&uacute;mero de Lote.");
					return false;
				}
				if ( $("#<?= $lv_sec; ?> #matbchduedte").prop("value").trim()=="" ) {
					toastr.warning("Debe indicar fecha de vencimiento.");
					return false;
				}
			}
			<?php } ?>
			
			<?php if($vew_data->matstkrel!='' && $vew_data->matuseser==1) { ?>
			if( !$("#<?= $lv_sec; ?> #matsercre").is(":checked") ) {
				var lo_dat = <?= $lv_sec; ?>_hotser.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["matsercodext"]!="" && lo_dat[i]["matsercodext"]!=undefined ) {
						lv_arr.push({	"matsercod": lo_dat[i]["matsercod"], "matsercodext":lo_dat[i]["matsercodext"] });
					}
				}
				if (lv_arr.length!=<?= $vew_data->matqty; ?>) {
					toastr.warning("Si indic&oacute; numeraci&oacute;n manual, debe completar todos los N&uacute;meros de Serie.");
					return false;
				} else {
					$("#<?= $lv_sec; ?> #matsercodextlst").text( JSON.stringify( lv_arr ) );
				}
			}
			<?php } ?>
    	});
				
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'||$vew_actcod=='10'?'true':'false'); ?>);
	</script>
</section>
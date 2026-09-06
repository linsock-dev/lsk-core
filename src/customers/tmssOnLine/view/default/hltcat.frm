<?php
	/* url del formulario */
  $lv_lnk = '?prg=hltcat&prm_hltcatcod='.$vew_data->hltcatcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('hltcattxt','hltcattyp','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->hltcatcod; 

	/* titulo */
	$lv_title = $vew_lang->category;
	
	/* módulo y programa */
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'CAT';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!--navbar-->
	<?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
        <li class="pull-right"><h4># <strong><?= $vew_data->hltcatcod; ?><input type="hidden" id="hltcatcod" name="hltcatcod" value="<?= $vew_data->hltcatcod; ?>"></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">		
          <div class="row">
            <div class="col-md-5">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->category; ?></div>
                </div><!--header-->

                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('hltcattxt', 'hltcatcod', $vew_data->hltcattxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 			'input'=>gethtml('hltcattyp', 'hltcattyp', $vew_data->hltcattyp, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div><!--body-->
              </div><!--card-->
          	</div>
            <div class="col-md-7">
            	<input type="text" id="hltcatval" name="hltcatval" class="hidden" value="">
							<div id="hltcathot"></div>
            </div>
          </div>
				</div> <!-- fin _tab001 -->

			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
  <script>
		/**
		 *
		 *	V A L O R E S  D E  C A T E G O R Í A S
		 *
		 */
		var <?= $lv_sec; ?>_hotcat_renderer = function (instance, td, row, col, prop, value, cellProperties) {
      if( prop == "hltcatfrm" || prop == "hltcatto" || prop == "hltcatpts"){
        Handsontable.renderers.NumericRenderer.apply(this, arguments);
      }else{
				Handsontable.renderers.TextRenderer.apply(this, arguments);
      }
      if(prop == "hltcatptr" && <?= $lv_sec; ?>_hotcat){
        var lv_ro = <?php echo($vew_readonly?'true':'false'); ?>;
        var lv_roptr = <?= $lv_sec; ?>_hotcat.getDataAtRowProp(row, "hltcatfrm") == 0 && <?= $lv_sec; ?>_hotcat.getDataAtRowProp(row, "hltcatto") == 0;
        cellProperties.readOnly = lv_ro?true:lv_roptr;
        td.style.backgroundColor = "#"+(lv_ro?"F1F1F1":(lv_roptr?"F1F1F1":"FFFFFF"));
      }else{
      	td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>"; 
      }
		};
		var <?= $lv_sec; ?>_hotcatdel = [];
    var <?= $lv_sec; ?>_hotcaterr = [];
		var <?= $lv_sec; ?>_hotcatcnt = $("#<?= $lv_sec; ?> #hltcathot")[0];
		var <?= $lv_sec; ?>_hotcatset = {
			height: 196,
			stretchH: "all",
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			minSpareRows: <?= ($vew_readonly?'0':'1'); ?>,
			colHeaders: [ "<?= $vew_lang->value ?>", "<?= $vew_lang->from ?>", "<?= $vew_lang->to ?>", "<?= $vew_lang->pattern ?>", "<?= $vew_lang->points ?>"],
			columns: [
        {type: "text", data: "hltcatval", width: 60, renderer: <?= $lv_sec; ?>_hotcat_renderer <?= ($vew_readonly?', readOnly: true':'');	?>},
        {type: "numeric", data: "hltcatfrm", width: 20, numericFormat: {pattern: "0", culture: "es-AR"}, renderer: <?= $lv_sec; ?>_hotcat_renderer <?= ($vew_readonly?', readOnly: true':'');	?>},
        {type: "numeric", data: "hltcatto", width: 20, numericFormat: {pattern: "0", culture: "es-AR"}, renderer: <?= $lv_sec; ?>_hotcat_renderer <?= ($vew_readonly?', readOnly: true':'');	?>},
        {type: "text", data: "hltcatptr", width: 40, 
        	validator: function(value, callback) {
            if (/^(\d|\-)*$/.test(value)) { 
              callback(true);
            } else {
              callback(false);
            }
    			},
         renderer: <?= $lv_sec; ?>_hotcat_renderer <?= ($vew_readonly?', readOnly: true':'');	?>
      },
        {type: "numeric", data: "hltcatpts", width: 20, numericFormat: {pattern: "0", culture: "es-AR"}, renderer: <?= $lv_sec; ?>_hotcat_renderer <?= ($vew_readonly?', readOnly: true':'');	?>}
			],
      afterValidate:function( isValid, value, row, prop, source) {
        var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotcaterr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotcaterr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotcaterr.splice(lv_inx,1); }	
				}
      },
      beforeChange: function(changes, source){
        if(changes[0][1] == "hltcatfrm" || changes[0][1] == "hltcatto" || changes[0][1] == "hltcatpts"){
          changes[0][3]	= (isNaN(parseInt(changes[0][3]))?(changes[0][3]=="-"?"":changes[0][3]):Math.abs(parseInt(changes[0][3])));
          
        }else if(changes[0][1] == "hltcatptr" ){
          if(changes[0][3].length > 0){
            changes[0][3] = changes[0][3].substring(changes[0][3].length - 1) == "-"?changes[0][3].substring(0, changes[0][3].length - 1):changes[0][3];
            changes[0][3] = changes[0][3].substring(0, 1) == "-"?changes[0][3].substring(1, changes[0][3].length):changes[0][3];
          }
        }
      },
      beforeRemoveRow: function(index, amount, logicalRows) {
				// me guardo todas las filas eliminadas (solo si tienen ID de registro)
				var lv_dat = <?= $lv_sec; ?>_hotcat.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]['hltcatvalcod']!='' && lv_dat[i]['hltcatvalcod']!=undefined ) {
						<?= $lv_sec; ?>_hotcatdel.push( lv_dat[i] );
					}
				}
			},
      licenseKey: gv_handsontable_lc
		};
		var <?= $lv_sec; ?>_hotcat;	
		
		tmssLoadScript("handsontable16",function(){
			<?= $lv_sec; ?>_hotcat = new Handsontable(<?= $lv_sec; ?>_hotcatcnt, <?= $lv_sec; ?>_hotcatset);	
			var lv_dat = [<?php
				$lv_buffer = '';
        if($vew_data->hltcatval != ''){
          foreach( $vew_data->hltcatval as $lv_row) {
            $lv_buffer .= ($lv_buffer==''?'':', ').'{'.
                          'hltcatvalcod:\''.$lv_row['hltcatvalcod'].'\', '.
                          'hltcatcod:\''.$lv_row['hltcatcod'].'\','.
                          'hltcatval:\''.$lv_row['hltcatval'].'\','.
                          'hltcatfrm:\''.$lv_row['hltcatfrm'].'\','.
                          'hltcatto:\''.$lv_row['hltcatto'].'\','.
                          'hltcatptr:\''.$lv_row['hltcatptr'].'\','.
                          'hltcatpts:\''.$lv_row['hltcatpts'].'\','.
                          'docsts:\''.$lv_row['docsts'].'\''.
                      '}';
          }
        }
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotcat.loadData( lv_dat );
			<?= $lv_sec; ?>_hotcat.render();
		});
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
      if ( lp_prm["action"]=="00" ) {
        if ( <?= $lv_sec; ?>_hotcaterr.length!=0 ) { toastr.warning("Corrija los valores incorrectos de la grilla."); return false; }
      
        // obtengo datos de handsontable
        var lo_dat = <?= $lv_sec; ?>_hotcat.getSourceData();
        var lv_arr = new Array();
        for (var i=0; i<lo_dat.length-1; i++) {
          if(lo_dat[i]["hltcatval"] && lo_dat[i]["hltcatpts"]!=undefined?lo_dat[i]["hltcatpts"].toString():false){
            lv_arr.push({	"hltcatvalcod":lo_dat[i]["hltcatvalcod"],
                            "hltcatcod":lo_dat[i]["hltcatcod"],
                            "hltcatval":lo_dat[i]["hltcatval"],
                            "hltcatfrm":lo_dat[i]["hltcatfrm"],
                            "hltcatto":lo_dat[i]["hltcatto"],
                            "hltcatptr":lo_dat[i]["hltcatptr"],
                            "hltcatpts":lo_dat[i]["hltcatpts"],
                            "docsts":lo_dat[i]["docsts"]
                          });
          }else{
            toastr.warning("Complete todos los campos de valor y puntos.");
            return false;
          }
        }
      
        // agrego las filas eliminadas
        for (var i=0; i<<?= $lv_sec; ?>_hotcatdel.length; i++) {
          lv_arr.push({	"hltcatvalcod":<?= $lv_sec; ?>_hotcatdel[i]["hltcatvalcod"],
                        "hltcatcod": <?= $lv_sec; ?>_hotcatdel[i]["hltcatcod"],
                        "deleted":"X"
                      });
        }
      
        if (lv_arr.length==0) {
          $("#<?= $lv_sec; ?> #hltcatval").prop("value", "");						
        } else {
          $("#<?= $lv_sec; ?> #hltcatval").prop("value", JSON.stringify( lv_arr ) );
        }
      }
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
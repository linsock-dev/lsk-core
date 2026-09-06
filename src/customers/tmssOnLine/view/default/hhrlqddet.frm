<?php		
	// url del formulario 
  $lv_lnk = '?prg=hhrlqd&prm_hhrlqdcod='.$vew_data->hhrlqdcod;

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = $vew_data->hhrlqdcod; 
	$lv_docposkey = '1';

	// titulo 
	$lv_title = $vew_lang->liquidation;
	
	// modulo y programa 
	$lv_mdlcod = 'HHR';
	$lv_prgcod = 'LQD';

	// librería de estilos bootstrap 
	include_once('_library.frm');
	
	$vew_actcod = ($vew_data->readonly=='false'?'02':'03');

	// id de sección 
	$lv_sec = ($vew_data->sec!='')?$vew_data->sec : $vew_token;
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<div class="tab-content tmss-tab-content">
			<!-- PRECIOS -->
			<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
				<div id="divprcgrd" name="divprcgrd"></div> 
			</div>
		</div> <!-- tabcontent -->     
  </form>
	<script>
		$(function(){
			<?= $lv_sec; ?>_loadPrices();
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab002']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
		});
	
		// carga grilla de precios
		function <?= $lv_sec; ?>_loadPrices() {
			var lv_dochdr = <?= (count($vew_data->dochdr)==0?'[]':json_encode($vew_data->dochdr)); ?>;
			var lv_docpos = <?= (count($vew_data->docpos)==0?'[]':json_encode($vew_data->docpos)); ?>;
			var lv_docprc = JSON.parse(<?= json_encode(html_entity_decode($vew_data->docprc)); ?>);
			var lv_pstdat=[ {name:"dochdr",value: JSON.stringify(lv_dochdr) },
											{name:"docpos",value: JSON.stringify(lv_docpos) },
											{name:"docprc",value: JSON.stringify(lv_docprc) },
											{name:"readonly",value:<?= ($vew_actcod=='02'?'false':'true'); ?>},
                      {name:"sec",value:"<?= $lv_sec;?>"}
										];
			tmssCallProcessNoBackdrop("?prg=grldatprc&act=02",lv_pstdat,function(data){
				$("#<?= $lv_sec; ?> #divprcgrd").html( data );
			});
		}
	</script>
	<script>
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	</script>
</section>
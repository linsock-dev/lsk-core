<?php
	/* url del formulario */
  $lv_lnk = "?prg=buyinv&prm_buyinvcod=".$vew_data->buyinvcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('srcobjtyp','srcobjcod','srcobjtxt','buyexpdte','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->buyinvcod; 
	$lv_docposkey = '1';

	/* titulo */
	$lv_title = $vew_lang->invoice;
	
	/* modulo y programa */
	$lv_mdlcod = 'BUY';
	$lv_prgcod = 'INV';
	$lv_objtyp = $lv_mdlcod.'_'.$lv_prgcod;

	//if($vew_data->readonly=='1'){ $vew_actcod='03'; }
	$vew_actcod = ($vew_data->readonly=='false'?'02':'03');
	
	/* librer?a de estilos bootstrap */
	include_once('_library.frm');
	
	$lv_rejarr = array(''=>'');
	foreach($vew_data->sysdoccls->sysdocclsrej as $lv_row) {
		if (strtoupper($vew_doc->getTagValue($lv_row['sysdocclsrejatr'],'rejman'))=='X'){
			$lv_rejarr[ $lv_row['sysdocrejcod'] ] = $lv_row['sysdocrejtxt'];
		}
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    
    <div class="container-fluid" role="tabpanel"> 
			<ul class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->prices; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->buyinvcod.'/'.$vew_data->buyinvmatcod; ?><?= gethtml('buyinvcod','hidden',$vew_data->buyinvcod); ?><?= gethtml('buyinvmatcod','hidden',$vew_data->buyinvmatcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<?php
						echo vew_boot($lv_col210, array('label'=>$vew_lang->purchasetext,	'input'=>gethtml('buyinvmatbuytxt',	'doccmt1x250', $vew_data->buyinvmatbuytxt, $lv_default) ));
						echo vew_boot($lv_col210, array('label'=>$vew_lang->rejection,	'input'=>gethtml('sysdocrejcod', $lv_rejarr, $vew_data->sysdocrejcod, $lv_default) ));
					?>
				</div>
				
				
				<!-- PRECIOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<div id="divprcgrd" name="divprcgrd"></div> 
				</div>

			</div> <!-- tabcontent -->     
		</div> <!-- container-fluid --> 
  </form>
	<script>
		$(function(){
			<?= $lv_sec; ?>_loadPrices();
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab002']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
		});
	
		// carga grilla de precios
		function <?= $lv_sec; ?>_loadPrices() {
			var lv_dochdr = JSON.parse(<?= json_encode(html_entity_decode($vew_data->dochdr)); ?>);
			var lv_docpos = JSON.parse(<?= json_encode(html_entity_decode($vew_data->docpos)); ?>);
			var lv_docprc = JSON.parse(<?= json_encode(html_entity_decode($vew_data->docprc)); ?>);
			var lv_pstdat=[ {name:"dochdr",value: JSON.stringify(lv_dochdr) },
											{name:"docpos",value: JSON.stringify(lv_docpos) },
											{name:"docprc",value: JSON.stringify(lv_docprc) },
											{name:"readonly",value:<?= ($vew_readonly?'true':'false'); ?>}
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
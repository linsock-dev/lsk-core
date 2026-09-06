<?php
	/* url del formulario */
  $lv_lnk = "?prg=grldatcnttyp&prm_cnttypcod=".$vew_data->cnttypcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('cnttyptxt','objtyp','docsts') );

	/* clave del documento */
	$lv_dockey = $vew_data->cnttypcod; 

	/* titulo */
	$lv_title = $vew_lang->interlocutortypes;
	
	/* módulo y programa */
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'DCN';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>  
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<textarea style="display: none;" id="cnttypatr_dat" name="cnttypatr_dat"></textarea>
		    
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->cnttypcod; ?><?= gethtml('cnttypcod','hidden', $vew_data->cnttypcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">

				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
							<?php 
								echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('cnttypcodext','doccod', $vew_data->cnttypcodext, $lv_default) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('cnttyptxt', 'doccmt1x50', $vew_data->cnttyptxt, $lv_default) ));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
							?>
						</div>
						<div class="col-md-6">
							<?php 
								echo vew_boot($lv_col210, array('label'=>$vew_lang->type, 'input'=>gethtml('objtyp','objtypcod_lst', $vew_data->objtyp, ($vew_actcod=='01'?$lv_default:$lv_always_disabled) ) ));
								echo vew_boot($lv_col273, array('label'=>$vew_lang->source, 
									'input1'=>gethtml('srcobjtyp','objtypcod_lst', $vew_data->srcobjtyp, $lv_default ),
									'input2'=>gethtml('srcobjdocclscod','doccmt1x50', $vew_data->srcobjdocclscod, $lv_default ) 
								));
								echo vew_boot($lv_col210, array('label'=>$vew_lang->authorizationcode, 'input'=>gethtml('autcod','autcod', $vew_data->autcod, $lv_default ) ));
							?>
							<div id="cnttypatr_hot" name="cnttypatr_hot"></div>
						</div>
					</div>
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
		/**
		 *
		 *	A T R I B U T O S
		 *
		 */
		var <?= $lv_sec; ?>_hotatr_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			Handsontable.renderers.TextRenderer.apply(this, arguments);
			if (prop=="cnttypatrtxt") {
				td.style.backgroundColor = "#F1F1F1";				
			} else {
				td.style.backgroundColor = "#<?= ($vew_readonly?'F1F1F1':'FFFFFF'); ?>";
			}
		};
		var <?= $lv_sec; ?>_hotatrchg = [];
		var <?= $lv_sec; ?>_hotatrcnt = $("#<?= $lv_sec; ?> #cnttypatr_hot")[0];
		var <?= $lv_sec; ?>_hotatrset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			autoWrapRow: true,
			rowHeaders: false,
			minSpareRows: 0,
			colHeaders: [ "Atributo", "Valor" ],
			columns: [
				{type: "text", data: "cnttypatrtxt", renderer: <?= $lv_sec; ?>_hotatr_renderer, readOnly: true },
				{type: "text", data: "cnttypatrval", renderer: <?= $lv_sec; ?>_hotatr_renderer <?php ($vew_readonly?', readOnly: true':''); ?> }
			]
		};
		var <?= $lv_sec; ?>_hotatr;

		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotatr = new Handsontable(<?= $lv_sec; ?>_hotatrcnt, <?= $lv_sec; ?>_hotatrset);	
			var lv_dat = [<?php
				$lv_buffer='';
				$lv_buffer.='{cnttypatr:"dlvadr", cnttypatrtxt:"Destinatario Mercancias", cnttypatrval:"'.($vew_doc->getTagValue($vew_data->cnttypatr,'dlvadr')!=''?'X':'').'"}';
				$lv_buffer.=',{cnttypatr:"invadr", cnttypatrtxt:"Destinatario Factura", cnttypatrval:"'.($vew_doc->getTagValue($vew_data->cnttypatr,'invadr')!=''?'X':'').'"}';
        $lv_buffer.=',{cnttypatr:"stkmgm", cnttypatrtxt:"Gestiona Stock", cnttypatrval:"'.($vew_doc->getTagValue($vew_data->cnttypatr,'stkmgm')!=''?'X':'').'"}';
        $lv_buffer.=',{cnttypatr:"uexit_beforesave", cnttypatrtxt:"UserExit BeforeSave", cnttypatrval:"'.($vew_doc->getTagValue($vew_data->cnttypatr,'uexit_beforesave')!=''?$vew_doc->getTagValue($vew_data->cnttypatr,'uexit_beforesave'):'').'"}';
        $lv_buffer.=',{cnttypatr:"uexit_aftersave", cnttypatrtxt:"UserExit AfterSave", cnttypatrval:"'.($vew_doc->getTagValue($vew_data->cnttypatr,'uexit_aftersave')!=''?$vew_doc->getTagValue($vew_data->cnttypatr,'uexit_aftersave'):'').'"}';
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotatr.loadData( lv_dat );
			<?= $lv_sec; ?>_hotatr.render();
		});
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext( lp_prm ) {

			// al grabar
			if ( lp_prm["action"]=="00" ) {
				// obtengo datos de handsontable de Especialidades
				var lo_dat = <?= $lv_sec; ?>_hotatr.getSourceData();
				var lv_arr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if (lo_dat[i]["cnttypatrval"]!=undefined ){
						lv_arr.push({	"cnttypatr":lo_dat[i]["cnttypatr"],
													"cnttypatrval":lo_dat[i]["cnttypatrval"]
												});
					}
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #cnttypatr_dat").prop("value", "");						
				} else {
					$("#<?= $lv_sec; ?> #cnttypatr_dat").prop("value", JSON.stringify( lv_arr ) );
				}
			}
		}
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
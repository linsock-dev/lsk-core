<?php
	/* url del formulario */
  $lv_lnk = '?prg=hltpatevl&prm_evlcod='.$vew_data->evlcod;

	/* campos requeridos */
	$vew_input->RequiredFields( array('evldte','patcod','pattxt','prscod','prstxt','spccod','spctxt','evlevl') );

	/* clave del documento */
	$lv_dockey = $vew_data->evlcod;

	/* titulo */
	$lv_title = $vew_lang->document;
	
	/* módulo y programa */
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'EVL';

	$vew_actcod = ($vew_data->evlcod!=''?'03':'02');
		
	// datos provenientes de los registros actuales
	if($vew_data->evlcod==''){
		$vew_data->docsts = 'A';
		$lv_dte = new DateTime(date('Y-m-d'));
		$vew_data->evldte = $lv_dte;
		$vew_data->delcod = $vew_data->del->delcod;
		$vew_data->deltxt = $vew_data->del->deltxt;
		$vew_data->spccod = $vew_data->spc->spccod;
		$vew_data->spctxt = $vew_data->spc->spctxt;
		$vew_data->prscod = $vew_data->prs->prscod;
		$vew_data->prstxt = $vew_data->prs->prstxt;
		$vew_data->patcod = $vew_data->pat->patcod;
		$vew_data->pattxt = $vew_data->pat->pattxt;
		$vew_data->patsex = $vew_data->pat->patsex;
		$vew_data->pathgh = $vew_doc->getTagValue($vew_data->pat->patatrval001,'pathgh');
		$vew_data->patwgt = $vew_doc->getTagValue($vew_data->pat->patatrval001,'patwgt');
		$vew_data->cushsptxt = $vew_data->pat->custxthsp;
		$vew_data->pataflnum = $vew_data->pat->pataflnum;
		$vew_data->pataflpln = $vew_data->pat->pataflpln;
		$vew_data->patbrndte = ($vew_data->pat->patbrndte==''?'':date_format($vew_data->pat->patbrndte,'d/m/Y'));
		
	// datos grabados en la evolución
	} else {		
		$vew_data->pathgh = $vew_doc->getTagValue($vew_data->evlatr001,'pathgh');
		$vew_data->patwgt = $vew_doc->getTagValue($vew_data->evlatr001,'patwgt');
		$vew_data->patsex = $vew_doc->getTagValue($vew_data->evlatr001,'patsex');
		$vew_data->patbrndte = $vew_doc->getTagValue($vew_data->evlatr001,'patbrndte');
		$vew_data->cushspcod = $vew_doc->getTagValue($vew_data->evlatr001,'cushspcod');
		$vew_data->cushsptxt = $vew_doc->getTagValue($vew_data->evlatr001,'cushsptxt');
		$vew_data->pataflnum = $vew_doc->getTagValue($vew_data->evlatr001,'pataflnum');
		$vew_data->pataflpln = $vew_doc->getTagValue($vew_data->evlatr001,'pataflpln');
		$vew_data->evlevl=utf8_decode($vew_data->evlevl);
		$vew_data->evlsub=utf8_decode($vew_data->evlsub);
		$vew_data->evlobj=utf8_decode($vew_data->evlobj);
		$vew_data->evlcmt=utf8_decode($vew_data->evlcmt);
	}
	
  /* librería de estilos bootstrap */
	include_once('_library.frm');
?>
<style>
  .tmss-stdEvl-header{ 
    background-color: #f9f9f9; 
    padding-top: 5px;  
    margin-bottom: 10px; 
    border-bottom: #a6a6a6 1px solid; 
  }
</style>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

	<nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
		<div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<?php if(!$vew_readonly) { ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '00'});" class="btn btn-default navbar-btn tmssAlwaysEnabled btn-success" title="<?= $vew_lang->save;  ?>"><span class="fas fa-save"></span><span class="hidden-xs"> <?= $vew_lang->save; ?></span></a><?php } ?>
				<?php if ($vew_sec->hasPermission('HLT','EVL','04') && $vew_data->evlcod!='') { ?><a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '04'});" class="btn btn-default navbar-btn tmssAlwaysEnabled btn-danger" title="<?= $vew_lang->delete; ?>"><span class="fas fa-trash-alt"></span><span class="hidden-xs"> <?= $vew_lang->delete; ?></span></a><?php } ?>
				<?php if ($vew_sec->hasPermission('HLT','EVL','05') && $vew_data->docsts=='A') { ?><!--<a href="#" id="btnprn" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->print; ?>"><span class="fas fa-print"></span><span class="hidden-xs"> <?= $vew_lang->print; ?></span></a>--> <?php } ?>
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<?php if ($vew_actcod!='02') { ?>
					<span id="grldatupl_divbtn"></span>
				<?php }  ?>
			</ul>
		</div>
	</nav>

  <form method="POST" class="form-horizontal tmss-form-horizontal pt-0" id="<?= $lv_sec; ?>_frm">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		
		<input type="hidden" id="delcod" name="delcod" value="<?= $vew_data->delcod; ?>">
		<input type="hidden" id="spccod" name="spccod" value="<?= $vew_data->spccod; ?>">
		<input type="hidden" id="prscod" name="prscod" value="<?= $vew_data->prscod; ?>">
		<input type="hidden" id="patcod" name="patcod" value="<?= $vew_data->patcod; ?>">
		<input type="hidden" id="plnid"  name="plnid"  value="<?= $vew_data->plnid; ?>">
		<input type="hidden" id="plndteid" name="plndteid" value="<?= $vew_data->plndteid; ?>">
		<input type="hidden" id="docsts" name="docsts" value="<?= $vew_data->docsts; ?>">
		<input type="hidden" id="cushspcod" name="cushspcod" value="<?= $vew_data->cushspcod; ?>">
		<input type="hidden" id="cushsptxt" name="cushsptxt" value="<?= $vew_data->cushsptxt; ?>">
		<input type="hidden" id="pataflnum" name="pataflnum" value="<?= $vew_data->pataflnum; ?>">
		<input type="hidden" id="pataflpln" name="pataflpln" value="<?= $vew_data->pataflpln; ?>">
		<input type="hidden" id="patsex" name="patsex" value="<?= $vew_data->patsex; ?>">
		<input type="hidden" id="patbrndte" name="patbrndte" value="<?= $vew_data->patbrndte; ?>">
    <input type="hidden" id="sysdocclscod" name="sysdocclscod" value="<?= $vew_data->sysdoccls->sysdocclscod; ?>">

		<div class="container-fluid pb-0 tmss-stdEvl-header">
			<div class="row">
				<div class="col-sm-7">
          <div class="card">
            <div class="form-group"> 
              <div class="col-xs-12">Nombre <small>(ID: <?= $vew_data->patcod; ?> - <?= $vew_data->patcodext; ?>)</small><br><strong><?= $vew_data->pattxt; ?></strong></div>
              <div class="col-xs-3">Sexo<br><strong><?= $vew_data->patsex; ?></strong></div>
              <div class="col-xs-3">Altura<br><input type="number" class="<?= ($vew_readonly?'hidden':''); ?>" min="10" max="300" step="1" id="pathgh" name="pathgh" value="<?= $vew_data->pathgh; ?>"><span class="<?= (!$vew_readonly?'hidden':''); ?>"><?= $vew_data->pathgh; ?></span><strong> CM</strong></div>
              <div class="col-xs-3">Peso<br><input type="number" class="<?= ($vew_readonly?'hidden':''); ?>" min="1" max="700" step="0.01" id="patwgt" name="patwgt" value="<?= $vew_data->patwgt; ?>"><span class="<?= (!$vew_readonly?'hidden':''); ?>"><?= $vew_data->patwgt; ?></span><strong> KG</strong></div>
              <div class="col-xs-3">IMC<br><strong><span id="patimc"></span> (Kg/m-2)</strong></div>
            </div>
          </div> 
				</div>
				<div class="col-sm-5">
					<div class="form-group">
						<div class="col-xs-12">Cobertura<br><strong><?= $vew_data->cushsptxt; ?> - <?= $vew_data->pataflpln; ?> - <?= $vew_data->pataflpln; ?></strong></div>
					</div>
					<div class="form-group">
						<div class="col-xs-5">Nacimiento<br><strong><?= $vew_data->patbrndte; ?></strong></div>
						<div class="col-xs-7">Edad<br><strong>
							<?php
								if($vew_data->patbrndte!=''){
									$lv_brn = date_create_from_format('d/m/Y',$vew_data->patbrndte);
									$now = new DateTime();
									$interval = $now->diff($lv_brn);
									echo ($interval->y<=0?'':$interval->y.' a&ntilde;os ').($interval->m<=0?'':$interval->m.' meses');
								}
							?>
						</strong></div>
					</div>
				</div>
			</div>
		</div>			

		<div class="container-fluid">
			<div class="row">
				<div class="col-md-4">
					<?php
							echo vew_boot($lv_col210,array('label'=>$vew_lang->id, 				'input'=>gethtml('evlcod','doccod',$vew_data->evlcod,$lv_always_disabled) ));
							echo vew_boot($lv_col210,array('label'=>$vew_lang->date,			'input'=>gethtml('evldte','docdte',$vew_data->evldte,$lv_default) ));
							echo vew_boot($lv_col210,array('label'=>$vew_lang->place,			'input'=>gethtml('deltxt','doccmt1x50',$vew_data->deltxt,$lv_always_disabled) ));
							echo vew_boot($lv_col210,array('label'=>$vew_lang->specialty,	'input'=>gethtml('spctxt','doccmt1x50',$vew_data->spctxt,$lv_always_disabled) ));
							echo vew_boot($lv_col210,array('label'=>$vew_lang->provider,	'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('prstxt', 'prstxt', $vew_data->prstxt,$lv_default) )) ));
							if($vew_data->evlcod!=''){
								echo '<hr>';
								echo '<small>'.$vew_lang->createdby.'</small>: '.$vew_data->cteusr.'<br>';
								echo '<small>'.$vew_lang->createddate.'</small>: '.$vew_data->ctedte->format('d/m/Y H:i');
							}
					?>					
				</div>
				<div class="col-md-8">
					<?php
						echo vew_boot($lv_col210,array('label'=>$vew_lang->evolution, 'input'=>gethtml('evlevl','doccmt5x50',$vew_data->evlevl,$lv_default) ));
						echo vew_boot($lv_col210,array('label'=>$vew_lang->subjetive, 'input'=>gethtml('evlsub','doccmt5x50',$vew_data->evlsub,$lv_default) ));
						echo vew_boot($lv_col210,array('label'=>$vew_lang->objetive, 	'input'=>gethtml('evlobj','doccmt5x50',$vew_data->evlobj,$lv_default) ));
						echo vew_boot($lv_col210,array('label'=>$vew_lang->comments, 	'input'=>gethtml('evlcmt','doccmt5x50',$vew_data->evlcmt,$lv_default) ));
					?>
				</div>
			</div> <!-- col-sm-9 -->
		</div> <!-- row -->
  </form>
  <?php if ($vew_actcod!='02') { ?>
  	<script>
      //load grldatupl_divbtn
      lv_flesrctyp='HLT_EVL';
      lv_flesrccod='<?= $vew_data->evlcod; ?>';
      function <?= $lv_sec; ?>_grldatupl_btnupl() {
        tmssCallProcess('?prg=grldatupl&act=07&prm_flesrctyp=' + lv_flesrctyp +'&prm_flesrccod=' + lv_flesrccod + '&prm_lv_sec=<?= $lv_sec; ?>',[],function(data) {
              $('#<?= $lv_sec; ?> #grldatupl_divbtn').html(data);
        });
      }
      <?= $lv_sec; ?>_grldatupl_btnupl();
    </script>
	<?php }?>
	<script>
		// IMC
		$(function(){ <?= $lv_sec; ?>_calcIMC(); });
		$("#<?= $lv_sec; ?> #pathgh, #<?= $lv_sec; ?> #patwgt").on("keyup",function(e) { <?= $lv_sec; ?>_calcIMC(); });
		$("#<?= $lv_sec; ?> #pathgh, #<?= $lv_sec; ?> #patwgt").on("change",function(e) { <?= $lv_sec; ?>_calcIMC(); });
		function <?= $lv_sec; ?>_calcIMC(){
			var lv_alt = $("#<?= $lv_sec; ?> #pathgh").prop("value");
			var lv_pes = $("#<?= $lv_sec; ?> #patwgt").prop("value");
			lv_pes = (lv_pes==undefined || lv_pes==""?"0":lv_pes);
			lv_alt = (lv_alt==undefined || lv_alt==""?"0":lv_alt);
			var lv_imc = ( Number(lv_pes)==0 || Number(lv_alt)==0? 0 : Number(lv_pes) / Math.pow(Number(lv_alt)/100,2) ).toFixed(2);
			$("#<?= $lv_sec; ?> #patimc").text(lv_imc);
		}
		
		// PRESTADOR
		tmssLoadScript("typeahead",function(){
			$("#<?= $lv_sec; ?> #prstxt").typeahead({
				onSelectAjaxData: function(data){ $("#<?= $lv_sec; ?> #prscod").prop("value", data.data.prscod); },
				ajax: {
					url: "index.php?prg=hltprs&act=18",
					displayField: "prstxt",
					valueField: "prstxt",
					timeout: 500,	triggerLength: 1,	method: "get", loadingClass: "fas fa-spinner",
					preDispatch: function(query){ return {prm_prstxt: query}; },
					preProcess: function(data){ return (data.length==0?false:data); }
				}
			}).next().next("span").children("a:first").on("click", function(evt) {
				tmssPopup("Prestadores","index.php?prg=hltprs&prm_vewcod=VEW_HLT_PRS_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldflt=[p.docsts:A]&prm_fldasg=[prscod:prscod],[prstxt:prstxt]");
				evt.preventDefault();
			});
		});
	</script>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";
		
		// server response
    tmssLinkForm( $("#<?= $lv_sec; ?>_frm"), "<?= $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $vew_data->matcod; ?></b>" ) ) {
				if ( gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    });
		
		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {      
			gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
			var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':'03'); ?>":gv_<?= $lv_sec; ?>_last_action);
			tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "" );
		}
		
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
  </script>
</section>
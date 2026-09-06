<?php
	// url del formulario 
  $lv_lnk = '';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->operations;
	
	// módulo y programa 
	$lv_mdlcod = '';
	$lv_prgcod = '';

	// librería de estilos bootstrap 
	include_once('_library.frm');

	// recursiva para mostrar menú
	function armar_menu( $lp_mnu, $lp_fncopr, &$vew_lang, &$lp_qty ) {
		$lv_buffer='';
		$lv_count=0;
		foreach( $lp_mnu as $lv_row ) {
			$lv_buffer_sub='';
			$lv_row['prgpic'] = strtolower($lv_row['prgpic']);
			$lv_pic=($lv_row['prgpic']==''?'':(substr($lv_row['prgpic'],0,6)=='class:'?substr($lv_row['prgpic'],6,strlen($lv_row['prgpic'])-6):'fas fa-ban'));
			// módulo
			if ( $lv_row['prgtypcod']==0 ) {
				$lv_qty = 0;
				$lv_row['mdlpic'] = strtolower($lv_row['mdlpic']);
				$lv_pic=($lv_row['mdlpic']==''?'':(substr($lv_row['mdlpic'],0,6)=='class:'?substr($lv_row['mdlpic'],6,strlen($lv_row['mdlpic'])-6):'fas fa-ban'));
				if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub = armar_menu( $lv_row['mnulst'], $lp_fncopr, $vew_lang, $lv_qty ); }
				if( $lv_qty>0 ) {
					//$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'far fa-folder-open').'", "opened":true}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="**">'.$vew_lang->get($lv_row['mdltxt']).' ('.$lv_row['mdlcod'].')'.'<ul>'.$lv_buffer_sub.'</ul></li>';
					$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'far fa-folder-open').'", "opened":true}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="**">'.$vew_lang->get($lv_row['mdltxt']).'<ul>'.$lv_buffer_sub.'</ul></li>';
				}
			// carpeta
			} else if ( $lv_row['prgtypcod']==3 ) {
				$lv_qty = 0;
				if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub=armar_menu( $lv_row['mnulst'], $lp_fncopr, $vew_lang, $lv_qty ); }
				if( $lv_qty>0 ) {
					//$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'far fa-folder').'", "opened":true}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'">'.$vew_lang->get($lv_row['prgtxt']).' ('.$lv_row['prgcod'].')'.'<ul>'.$lv_buffer_sub.'</ul></li>';
					$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'far fa-folder').'", "opened":true}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'">'.$vew_lang->get($lv_row['prgtxt']).'<ul>'.$lv_buffer_sub.'</ul></li>';
					$lp_qty += $lv_qty;
				}
			// programa
			} else if ( $lv_row['prgtypcod']==1 ) {
				$lv_qty = 0;
				if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub = armar_menu( $lv_row['mnulst'], $lp_fncopr, $vew_lang, $lv_qty ); }
				if( $lv_qty>0 ) {
					//$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'fas fa-cog').'"}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'">'.$vew_lang->get($lv_row['prgtxt']).' ('.$lv_row['prgcod'].')'.'<ul>'.$lv_buffer_sub.'</ul></li>';
					$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'fas fa-cog').'"}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'">'.$vew_lang->get($lv_row['prgtxt']).'<ul>'.$lv_buffer_sub.'</ul></li>';
					$lp_qty += $lv_qty;
				}
			// operaciones
			} else if ( $lv_row['prgtypcod']==4 ) {
				$lv_id = $lv_row['mdlcod'].'_'.$lv_row['prgcod'].'_'.$lv_row['oprcod'];
				$lv_alw=false;
				foreach($lp_fncopr as $lv_opr){if($lv_id==$lv_opr['mdlcod'].'_'.$lv_opr['prgcod'].'_'.$lv_opr['oprcod']){$lv_alw=true;break;}}
				if($lv_alw==true){
					$lp_qty++;
					//$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"fas fa-angle-right","selected":'.($lv_alw?'true':'false').'}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'" data-oprcod="'.$lv_row['oprcod'].'">'.$vew_lang->get($lv_row['oprtxt']).' ('.$lv_row['oprcod'].')</li>';
					$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"fas fa-angle-right","selected":'.($lv_alw?'true':'false').'}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'" data-oprcod="'.$lv_row['oprcod'].'">'.$vew_lang->get($lv_row['oprtxt']).'</li>';
				}
			}
			$lv_count++;
		}
		return $lv_buffer;
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		
		<div class="row">
			<div class="col-sm-4">
				<span class="fa <?= ($vew_data->sysfnc->sysfncpic!=''?$vew_data->sysfnc->sysfncpic:'fa-cogs'); ?> fa-4x" style="color:#696969; width: 100%; text-align: center; background-color: #f1f1f1; padding: 20px;"></span>
				<button class="btn btn-success btn-block" style="margin-top: 10px; margin-bottom: 10px;">Suscribirme</button>
				<!--<button class="btn btn-danger btn-block" style="margin-top: 10px; margin-bottom: 10px;">Cancelar Suscripcion</button>-->
				<small>M&oacute;dulo: <b><?= $vew_data->sysfnc->mdlcod; ?></b> - ID: <b><?= $vew_data->sysfnc->sysfnccod; ?></b></small>
				<hr>
				<h4>Operaciones</h4>
				<div id="loading">
					<h2><i class="fas fa-spinner fa-spin fa-fw"></i>&nbsp;&nbsp;Cargando...</h2>
				</div>
				<div id="loaded" style="display: none;">
				<?php $lp_qty=0; echo '<div id="syssecperlst"><ul>'.armar_menu( $vew_data->sysopr, $vew_data->fncopr, $vew_lang, $lp_qty ).'</ul></div>'; ?>
				</div>
			</div>
			<div class="col-sm-8">
				<h2><?= $vew_data->sysfnc->sysfnctxt; ?></h2>
				<p><strong><?= $vew_data->sysfnc->sysfncttl; ?></strong></p>
				<p><?= html_entity_decode($vew_data->sysfnc->sysfncdes); ?></p>
			</div>
		</div>
	</form>
	<script>
		$(function(){
			$("#loading").fadeIn("slow",function(e){
				tmssLoadScript("jstree",function(){
					$("#syssecperlst").jstree({
						"core": { "expand_selected_onload" : false, "themes": {	"responsive": true } }
					});
				});
			});
			$("#<?= $lv_sec; ?> #buscod").on("change",function(e){
				$("#loaded").fadeOut("fast",function(e){$("#loading").fadeIn()});
				<?= $lv_sec; ?>_fnc({action: '<?= $vew_actcod; ?>'});
			});
			$("#loading").fadeOut( "slow", function(e){$("#loaded").fadeIn();});
		});
	</script>
	<script>
    var gv_<?= $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $("#<?= $lv_sec; ?>_frm"), "<?= $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="04") {
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
			tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
		}

		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>,"#buscod");
	</script>
</section>
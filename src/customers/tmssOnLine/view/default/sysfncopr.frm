<?php
	/* url del formulario */
  $lv_lnk = '?prg=sysfncopr';

	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = '';

	/* titulo */
	$lv_title = $vew_lang->permissions;
	
	/* módulo y programa */
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'FCP';
	
	/* librería de estilos bootstrap */
	include_once('_library.frm');

	// recursiva para mostrar menú
	function armar_menu( $lp_mnu, $lp_fncopr, &$vew_lang ) {
		$lv_buffer='';
		$lv_count=0;
		foreach( $lp_mnu as $lv_row ) {
			$lv_buffer_sub='';
			$lv_row['prgpic'] = strtolower($lv_row['prgpic']);
			$lv_pic=($lv_row['prgpic']==''?'':(substr($lv_row['prgpic'],0,6)=='class:'?substr($lv_row['prgpic'],6,strlen($lv_row['prgpic'])-6):'fas fa-ban'));
			// módulo
			if ( $lv_row['prgtypcod']==0 ) {
				$lv_row['mdlpic'] = strtolower($lv_row['mdlpic']);
				$lv_pic=($lv_row['mdlpic']==''?'':(substr($lv_row['mdlpic'],0,6)=='class:'?substr($lv_row['mdlpic'],6,strlen($lv_row['mdlpic'])-6):'fas fa-ban'));
				if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub = armar_menu( $lv_row['mnulst'], $lp_fncopr, $vew_lang ); }
				$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'far fa-folder-open').'"}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="**">'.$vew_lang->get($lv_row['mdltxt']).' ('.$lv_row['mdlcod'].')'.'<ul>'.$lv_buffer_sub.'</ul></li>';
			// carpeta
			} else if ( $lv_row['prgtypcod']==3 ) {
				if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub=armar_menu( $lv_row['mnulst'], $lp_fncopr, $vew_lang ); }
				$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'far fa-folder').'"}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'">'.$vew_lang->get($lv_row['prgtxt']).' ('.$lv_row['prgcod'].')'.'<ul>'.$lv_buffer_sub.'</ul></li>';
			// programa
			} else if ( $lv_row['prgtypcod']==1 ) {
				if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub = armar_menu( $lv_row['mnulst'], $lp_fncopr, $vew_lang ); }
				$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'fas fa-cog').'"}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'">'.$vew_lang->get($lv_row['prgtxt']).' ('.$lv_row['prgcod'].')'.'<ul>'.$lv_buffer_sub.'</ul></li>';
			// operaciones
			} else if ( $lv_row['prgtypcod']==4 ) {
				$lv_id = $lv_row['mdlcod'].'_'.$lv_row['prgcod'].'_'.$lv_row['oprcod'];
				$lv_alw=false;
				foreach($lp_fncopr as $lv_opr){if($lv_id==$lv_opr['mdlcod'].'_'.$lv_opr['prgcod'].'_'.$lv_opr['oprcod']){$lv_alw=true;break;}}
				$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"fas fa-angle-right","selected":'.($lv_alw?'true':'false').'}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'" data-oprcod="'.$lv_row['oprcod'].'">'.$vew_lang->get($lv_row['oprtxt']).' ('.$lv_row['oprcod'].')</li>';
			}
			$lv_count++;
		}
		return $lv_buffer;
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<textarea class="hidden" id="sysfncprgatr001" name="sysfncprgatr001"></textarea>
		
		<div class="row">
			<div class="col-sm-6">
				<nav class="navbar navbar-default tmss-navbar <?= ($vew_readonly?'hidden':''); ?>">
					<div class="container-fluid">
						<ul class="nav navbar-nav tmss-navbar-left">
							<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: '00'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success" title="<?= $vew_lang->save;  ?>"><span class="far fa-save"></span><span class="hidden-xs"> <?= $vew_lang->save; ?></span></a>
						</ul>
					</div>
				</nav><br>
				<?php
					echo vew_boot($lv_col210, array('label'=>$vew_lang->id, 'input'=>gethtml('sysfnccod', 'doccmt1x50', $vew_data->sysfnc->sysfnccod, $lv_always_disabled) ));
					echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('sysfnctxt', 'doccmt1x50', $vew_data->sysfnc->sysfnctxt, $lv_always_disabled) ));
					echo vew_boot($lv_col210, array('label'=>$vew_lang->module, 'input'=>gethtml('mdlcod', 'doccmt1x50', $vew_data->sysfnc->mdlcod, $lv_always_disabled) ));
				?>
			</div>
			<div class="col-sm-6">
				<div id="loading">
					<h2><i class="fas fa-spinner fa-spin fa-fw"></i>&nbsp;&nbsp;Cargando...</h2>
				</div>
				<div id="loaded" style="display: none;">
				<?= '<div id="syssecperlst"><ul>'.armar_menu( $vew_data->sysopr, $vew_data->fncopr, $vew_lang ).'</ul></div>'; ?>
				</div>
			</div>
		</div>
	</form>
	<script>
		$(function(){
			$("#loading").fadeIn("slow",function(e){
				tmssLoadScript("jstree",function(){
					$("#syssecperlst").jstree({
						"checkbox" : { "keep_selected_style" : false },
						"core": { "expand_selected_onload" : false, "themes": {	"responsive": true } },
						"plugins" : [ "checkbox" ]
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
			if (lp_prm["action"]=="00") {
				var lv_sel = "";
				var lv_itm = $("#syssecperlst").jstree().get_selected(true);
				for(var i=0; i<lv_itm.length; i++) {
					if ( lv_itm[i].children.length==0 ) {
						lv_sel += (lv_sel==""?"":String.fromCharCode(9)) + lv_itm[i].data["mdlcod"]+"_"+lv_itm[i].data["prgcod"]+"_"+lv_itm[i].data["oprcod"];
					}
				}
				$("#<?= $lv_sec; ?> #sysfncprgatr001").text( lv_sel );
			}
			
			gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
			var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':'03'); ?>":gv_<?= $lv_sec; ?>_last_action);
			tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
		}

		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>,"#buscod");
	</script>
</section>
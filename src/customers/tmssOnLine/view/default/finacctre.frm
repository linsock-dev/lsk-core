<?php		
	// url del formulario
  $lv_lnk = '?prg=finacc';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->accounts;
	
	// módulo y programa
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'ACC';

	// librería de estilos bootstrap
	include_once('_library.frm');

	// recursiva para mostrar menú
	function armar_menu( $lp_mnu, &$vew_lang ) {
		$lv_buffer='';
		$lv_count=0;
		foreach( $lp_mnu as $lv_row ) {
			$lv_buffer_sub='';
			$lv_pic='class:fas fa-ban';
			// módulo
			if ( $lv_row['prgtypcod']==0 ) {
				$lv_row['mdlpic'] = strtolower($lv_row['mdlpic']);
				$lv_pic=($lv_row['mdlpic']==''?'':(substr($lv_row['mdlpic'],0,6)=='class:'?substr($lv_row['mdlpic'],6,strlen($lv_row['mdlpic'])-6):'fas fa-ban'));
				if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub = armar_menu( $lv_row['mnulst'], $vew_lang ); }
				$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'far fa-folder-open').'"}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="**">'.$vew_lang->get($lv_row['mdltxt']).' ('.$lv_row['mdlcod'].')'.'<ul>'.$lv_buffer_sub.'</ul></li>';
			// carpeta
			} else if ( $lv_row['prgtypcod']==3 ) {
				if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub=armar_menu( $lv_row['mnulst'], $vew_lang ); }
				$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'far fa-folder-open').'"}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'">'.$vew_lang->get($lv_row['prgtxt']).' ('.$lv_row['prgcod'].')'.'<ul>'.$lv_buffer_sub.'</ul></li>';
			// separador
			} else if ( $lv_row['prgtypcod']==2 ) {
				$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'fas fa-minus').'"}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'">------------------------------ ('.$lv_row['prgcod'].')</li>';
			// programa
			} else if ( $lv_row['prgtypcod']==1 ) {
				$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'fas fa-cogs').'"}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'">'.$vew_lang->get($lv_row['prgtxt']).' ('.$lv_row['prgcod'].')</li>';
			}
			$lv_count++;
		}
		return $lv_buffer;
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01')) { ?><a href="#" id="btnnew" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->new; ?>"><span class="far fa-file"></span><span class="hidden-xs"> <?= $vew_lang->new; ?></span></a><?php } ?>
				<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'03')) { ?><a href="#" id="btnchg" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->view; ?>"><span class="far fa-eye"></span><span class="hidden-xs"> <?= $vew_lang->view; ?></span></a><?php } ?>
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<a href="#" onclick="<?= $lv_sec; ?>_GridRefresh();" class="btn btn-default navbar-btn"><span class="fas fa-sync-alt"></span></a>
				<li class="btn navbar-text tmss-navbar-sep">|</li>
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn btn-default navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
  </nav>

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<input type="hidden" id="mdlcod" name="mdlcod" value="">
		<input type="hidden" id="prgcod" name="prgcod" value="">
		<div class="container-fluid">
		<?= '<div id="finacclst"><ul>'.armar_menu( $vew_data->sysprg, $vew_lang ).'</ul></div>'; ?>
		</div>
	</form>
	<script>
		function <?= $lv_sec; ?>_GridRefresh(){
			<?= $lv_sec; ?>_fnc({action: ""});
		}
		
		tmssLoadScript("jstree",function(){
			$("#<?= $lv_sec; ?> #finacclst").jstree({
				"core": { "expand_selected_onload" : false, "themes": {	"responsive": true } }
			});
		});
		
		$("#<?= $lv_sec; ?> #btnnew").on("click",function(e){
			var lv_itm = $("#<?= $lv_sec; ?> #finacclst").jstree().get_selected(true);
			var lv_selmdl = (lv_itm.length!=0?lv_itm[0].data["mdlcod"]:"");
			$("#<?= $lv_sec; ?> #mdlcod").prop("value",lv_selmdl);			
			var lv_selprg = (lv_itm.length!=0?lv_itm[0].data["prgcod"]:"");
			if (lv_selmdl!="") {
				$("#<?= $lv_sec; ?> #prgcod").prop("value",lv_selprg);			
				<?= $lv_sec; ?>_fnc({action: "01"});
			}
		});
		
		$("#<?= $lv_sec; ?> #btnchg").on("click",function(e){
			var lv_itm = $("#<?= $lv_sec; ?> #finacclst").jstree().get_selected(true);
			var lv_selmdl = (lv_itm.length!=0?lv_itm[0].data["mdlcod"]:"");
			$("#<?= $lv_sec; ?> #mdlcod").prop("value",lv_selmdl);			
			var lv_selprg = (lv_itm.length!=0?lv_itm[0].data["prgcod"]:"");
			if (lv_selprg!="**") {
				$("#<?= $lv_sec; ?> #prgcod").prop("value",lv_selprg);			
				<?= $lv_sec; ?>_fnc({action: "03"});
			}
		});
	</script>
	<script>
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {
				tmssLink("index.php?prg=sysappprg&act="+lp_prm["action"], [{target: "_new_section",post_data: $("#<?= $lv_sec; ?>_frm").serializeArray() }] );
			}
		}
	</script>
</section>
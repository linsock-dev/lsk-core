<?php
  $lv_sec = $vew_token;
	
	// recursiva para mostrar menú
	function armar_menu( $lp_mnu, &$vew_lang ) {
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
				if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub = armar_menu( $lv_row['mnulst'], $vew_lang ); }
				$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'far fa-folder-open').'"}'.chr(39).' data-prgtypcod="'.$lv_row['prgtypcod'].'">'.$vew_lang->get($lv_row['mdltxt']).'<ul>'.$lv_buffer_sub.'</ul></li>';
			// carpeta
			} else if ( $lv_row['prgtypcod']==3 ) {
				if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub=armar_menu( $lv_row['mnulst'], $vew_lang ); }
				$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'far fa-folder-open').'"}'.chr(39).' data-prgtypcod="'.$lv_row['prgtypcod'].'">'.$vew_lang->get($lv_row['prgtxt']).'<ul>'.$lv_buffer_sub.'</ul></li>';
			// programa
			} else if ( $lv_row['prgtypcod']==1 ) {
				$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'fas fa-cogs').'"}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'" data-vewcod="'.$lv_row['vewcod'].'" data-prgtxt="'.$vew_lang->get($lv_row['prgtxt']).'" data-prgfrm="'.$lv_row['prgfrm'].'" data-prgtypcod="'.$lv_row['prgtypcod'].'">'.$vew_lang->get($lv_row['prgtxt']).'</li>';
			}
			$lv_count++;
		}
		return $lv_buffer;
	}
?>
<section id="<?= $lv_sec; ?>">
  <nav class="navbar navbar-default tmss-navbar">
    <div class="container-fluid">
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn btn-default navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
  </nav>
	<div class="container-fluid">
	<?= '<div id="sysappprglst"><ul>'.armar_menu( $vew_mnu, $vew_lang ).'</ul></div>'; ?>
	</div>
	<script>
		tmssLoadScript("jstree",function(){
			$("#<?= $lv_sec; ?> #sysappprglst").jstree({
				"core": { "expand_selected_onload" : false, "themes": {	"responsive": true } }
			}).on('changed.jstree', function (e, data) {
				if (data.node.data["prgtypcod"]=="1") {
					tmssLink(data.node.data["prgfrm"]+"&prm_mdlcod="+data.node.data["mdlcod"]+"&prm_prgcod="+data.node.data["prgcod"], [{target: "_new_section", tab_title: data.node.data["prgtxt"], url_data: [{vewcod: data.node.data["vewcod"] }] }] );
				}
			});
		});
	</script>
</section>
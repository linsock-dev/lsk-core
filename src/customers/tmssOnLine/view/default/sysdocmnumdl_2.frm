<?php
  $lv_sec = $vew_token;
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
	<?php
		// recursiva para mostrar menú
		function armar_menu( $lp_mnu, &$vew_lang ) {
			$lv_buffer = '';
			$lv_count = 0;
			$lv_lstdiv = false;
			foreach( $lp_mnu as $lv_row ) {              
				// carpeta
				if ( $lv_row['prgtypcod']==0 || $lv_row['prgtypcod']==3 ) {
					$lv_buffer_sub = armar_menu( $lv_row['mnulst'], $vew_lang );
					if ( $lv_buffer_sub!='' ) {
						$lv_buffer .= '<div class="list-group">';
						$lv_buffer .= '<a href="#" class="list-group-item tmss-noborder" onclick="$(this).next().toggle(300); $(this).children('.chr(39).'span'.chr(39).').toggleClass('.chr(39).'fa-plus-circle'.chr(39).').toggleClass('.chr(39).'fa-minus-circle'.chr(39).'); " id="'.$lv_row['prgcod'].'">'.'<span class="fas fa-minus-circle"></span><strong> '.$vew_lang->get($lv_row['prgtxt']).'</strong></a>';
						$lv_buffer .= '<div style="padding-left: 15px !important">';
						$lv_buffer .= $lv_buffer_sub;
						$lv_buffer .= '</div>';
						$lv_buffer .= '</div>';
					}
					$lv_lstdiv = false;
				// separador
				} else if ( $lv_row['prgtypcod']==2 ) {
					if ( $lv_count==0 || ($lv_count+1)==count($lp_mnu) || $lv_lstdiv==true ) {
						// un divider al principio no se debe mostrar
						// un divider al final del menu no se debe mostrar
						// si hay dos o mas divider juntos, se debe mostrar solo uno
					} else {
						$lv_buffer .= '<hr>'; //<li class="divider" id="'.$lv_row['prgcod'].'"></li>';
						$lv_lstdiv = true;
					}
				// programa
				} else if ( $lv_row['prgtypcod']==1 ) {
					// compatibilidad con sistema anterior
					if ( strpos($lv_row['prgfrm'],'.asp')!=false ) {
						$lv_buffer .= '<a href="#" class="list-group-item tmss-noborder" onclick="tmssLink('.chr(39).$lv_row['prgfrm'].(stripos($lv_row['prgfrm'],'?')===false?'?':'&').'mdlcod='.$lv_row['mdlcod'].'&prgcod='.$lv_row['prgcod'].chr(39).', [{target: '.chr(39).'_new_section'.chr(39).', tab_title:'.chr(39).$vew_lang->get($lv_row['prgtxt']).chr(39).', url_data: [{vewcod: '.chr(39).$lv_row['vewcod'].chr(39).'}] }] );">'.($lv_row['prgpic']==''?'':(substr($lv_row['prgpic'],0,6)=='class:'?'<span class="tmss-icon '.substr($lv_row['prgpic'],6).'"></span>':'<img src="/library/images/'.$lv_row['prgpic'].'" class="tmss-icon">')).' '.$vew_lang->get($lv_row['prgtxt']).'</a>';
					} else {
						$lv_buffer .= '<a href="#" class="list-group-item tmss-noborder" onclick="tmssLink('.chr(39).$lv_row['prgfrm'].(stripos($lv_row['prgfrm'],'?')===false?'?':'&').'prm_mdlcod='.$lv_row['mdlcod'].'&prm_prgcod='.$lv_row['prgcod'].chr(39).', [{target: '.chr(39).'_new_section'.chr(39).', tab_title:'.chr(39).$vew_lang->get($lv_row['prgtxt']).chr(39).', url_data: [{vewcod: '.chr(39).$lv_row['vewcod'].chr(39).'}] }] );">'.($lv_row['prgpic']==''?'':(substr($lv_row['prgpic'],0,6)=='class:'?'<span class="tmss-icon '.substr($lv_row['prgpic'],6).'"></span>':'<img src="/library/images/'.$lv_row['prgpic'].'" class="tmss-icon">')).' '.$vew_lang->get($lv_row['prgtxt']).'</a>';
					}
					$lv_lstdiv = false;
				}
				$lv_count++;
			}
			return $lv_buffer;
		}
		echo '<ul class="list-group">';
		echo armar_menu( $vew_mnu, $vew_lang );
		echo '</ul>';
	?>
	</div>
</section>
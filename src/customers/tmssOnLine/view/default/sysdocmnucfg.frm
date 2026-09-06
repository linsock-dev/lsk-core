<?php
	/* id de sección */
	$lv_sec = $vew_token;

	/* titulo */
	$lv_title = '';
?>
<section id="<?= $lv_sec; ?>" data-model="" data-title="<?= $lv_title; ?>">
	<div class="container">
		<div class="row">
			<div class="well" style="width:300px; padding: 8px 0;">
				<div style="overflow-y: scroll; overflow-x: hidden; height: 500px;">
					<ul class="nav nav-list">
						<?php
							// recursiva para mostrar menú
							function armar_menu( $lp_mnu, &$vew_lang ) {
								$lv_buffer = "";
								$lv_count = 0;
								$lv_lstdiv = false;
								foreach( $lp_mnu as $lv_row ) {              
									// carpeta
									if ( $lv_row["prgtypcod"]==0 || $lv_row["prgtypcod"]==3 ) {
										$lv_buffer_sub = armar_menu( $lv_row["mnulst"], $vew_lang );
										if ( $lv_buffer_sub!="" ) {
											$lv_buffer .= "<li><label class='tree-toggler nav-header'>".$vew_lang->get($lv_row["prgtxt"])."</label><ul class='nav nav-list tree'>"
											$lv_buffer .= $lv_buffer_sub;
											$lv_buffer .= "</ul></li>";																		
											//$lv_buffer .= "<li class='dropdown' id='".$lv_row["prgcod"]."'><a href='#'>".($lv_row["prgpic"]==""?"":"<img src='/library/images/".$lv_row["prgpic"]."' class='tmss-icon'>")." ".$vew_lang->get($lv_row["prgtxt"])."</a><ul class='dropdown-menu'>";
											//$lv_buffer .= $lv_buffer_sub;
											//$lv_buffer .= "</ul></li>";
										}
										$lv_lstdiv = false;
									// separador
									} else if ( $lv_row["prgtypcod"]==2 ) {
										if ( $lv_count==0 || ($lv_count+1)==count($lp_mnu) || $lv_lstdiv==true ) {
											// un divider al principio no se debe mostrar
											// un divider al final del menu no se debe mostrar
											// si hay dos o mas divider juntos, se debe mostrar solo uno
										} else {
											$lv_buffer .= "<li class='divider' id='".$lv_row["prgcod"]."'></li>";
											$lv_lstdiv = true;
										}
									// programa
									} else if ( $lv_row["prgtypcod"]==1 ) {
										$lv_buffer .= "<li><a href='#'>Link</a></li>";
										//$lv_buffer .= "<li><a href='#' onclick='tmssLink(".chr(34).$lv_row["prgfrm"].(stripos($lv_row["prgfrm"],"?")===false?"?":"&")."mdlcod=".$lv_row["mdlcod"]."&prgcod=".$lv_row["prgcod"].chr(34).", [{tab_title:".chr(34).$lv_row["prgtxt"].chr(34).", url_data: [{vewcod: ".chr(34).$lv_row["vewcod"].chr(34)."}] }] );'>".($lv_row["prgpic"]==""?"":"<img src='/library/images/".$lv_row["prgpic"]."' class='tmss-icon'>")." ".$vew_lang->get($lv_row["prgtxt"])."</a></li>";
										$lv_lstdiv = false;
									}
									$lv_count++;
								}
								return $lv_buffer;
							}
							echo armar_menu( $vew_mnu, $vew_lang );
						?>
					</ul>
				</div>
			</div>
		</div>
	</div>
</section>

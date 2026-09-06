<?php
	// url del formulario 
  $lv_lnk = '?prg=stkmathie';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->permissions;
	
	// módulo y programa 
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'HIE';

	// librería de estilos bootstrap 
	include_once('_library.frm');

	// recursiva para mostrar jerarquía
	function armar_menu( $lp_mathietre, $lp_mathiepar ) {
		$lv_buffer='';
		$lv_count=0;
    foreach( $lp_mathietre as $lv_row ) {
			$lv_buffer_sub='';
			if ( $lv_row['mathiepar'] == $lp_mathiepar ) {
				// carpeta
				if ( $lv_row['mathiechlqty']!=0 ) {
					$lv_buffer_sub = armar_menu( $lp_mathietre, $lv_row['mathiecod'] );
					$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"fa fa-folder-open-o"}'.chr(39).' data-mathiecod='.chr(39).$lv_row['mathiecod'].chr(39).' data-mathietxt='.chr(39).$lv_row['mathietxt'].chr(39).'>'.$lv_row['mathietxt'].'<ul>'.$lv_buffer_sub.'</ul></li>';
          // jerarquía
				} else {
					$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"fa fa-cogs"}'.chr(39).' data-mathiecod='.chr(39).$lv_row['mathiecod'].chr(39).' data-mathietxt='.chr(39).$lv_row['mathietxt'].chr(39).'>'.$lv_row['mathietxt'].'</li>';
				}
				$lv_count++;
			}
		}
  	return $lv_buffer;
}

?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

	<?php if( !isset($vew_prm['popup']) ) { ?>
  <nav class="navbar navbar-default tmss-navbar">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01')) { ?><a href="#" id="btnnew" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->new; ?>"><span class="fa fa-file-o"></span><span class="hidden-xs"> <?= $vew_lang->new; ?></span></a><?php } ?>
				<?php if ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'03')) { ?><a href="#" id="btnchg" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->view; ?>"><span class="fa fa-eye"></span><span class="hidden-xs"> <?= $vew_lang->view; ?></span></a><?php } ?>
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<a href="#" onclick="<?= $lv_sec; ?>_GridRefresh();" class="btn btn-default navbar-btn"><span class="fa fa-refresh"></span></a>
				<li class="btn navbar-text tmss-navbar-sep">|</li>
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn btn-default navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fa fa-close"></span></a>
			</ul>
		</div>
  </nav>
	<?php } ?>

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<input type="hidden" id="mathiecod" name="mathiecod" value="">
		<input type="hidden" id="mathiepar" name="mathiepar" value="">
		<input type="hidden" id="mathiepartxt" name="mathiepartxt" value="">
		<div class="container-fluid">
		<?= '<div id="stkmathielst"><ul>' . armar_menu( $vew_data, '0' ) . '</ul></div>'; ?>
		</div>
	</form>
	<script>
		function <?= $lv_sec; ?>_GridRefresh(){
			<?= $lv_sec; ?>_fnc({action: ""});
		}
		
		$("#<?= $lv_sec; ?> #btnnew").on("click",function(e){
			var lv_itm = $("#<?= $lv_sec; ?> #stkmathielst").jstree().get_selected(true);
			var lv_selcod = (lv_itm.length!=0?lv_itm[0].data["mathiecod"]:"");
			$("#<?= $lv_sec; ?> #mathiecod").prop("value","");
			$("#<?= $lv_sec; ?> #mathiepar").prop("value",lv_selcod);
			$("#<?= $lv_sec; ?> #mathiepartxt").prop("value",(lv_itm.length!=0?lv_itm[0]["text"]:""));
			<?= $lv_sec; ?>_fnc({action: "01"});
		});
		
		$("#<?= $lv_sec; ?> #btnchg").on("click",function(e){
			var lv_itm = $("#<?= $lv_sec; ?> #stkmathielst").jstree().get_selected(true);
			var lv_selcod = (lv_itm.length!=0?lv_itm[0].data["mathiecod"]:"");
			$("#<?= $lv_sec; ?> #mathiecod").prop("value",lv_selcod);
			$("#<?= $lv_sec; ?> #mathiepar").prop("value","");
			$("#<?= $lv_sec; ?> #mathiepartxt").prop("value","");
			<?= $lv_sec; ?>_fnc({action: "03"});
		});
		
		tmssLoadScript("jstree",function(){
			$("#<?= $lv_sec; ?> #stkmathielst").jstree({
				"core": { "expand_selected_onload" : false, "themes": {	"responsive": true } }
			}).on("select_node.jstree",function(evt, data){
				<?php 
					if ( isset($vew_prm['popup']) ) {
						$lv_fldasg = explode(',',$vew_prm['fldasg']);
						foreach( $lv_fldasg as $lv_row ) {
							$lv_fldidt = explode(':',$lv_row);
							echo '$("#'.$vew_prm['fldsec'].' #'.substr($lv_fldidt[0],1,strlen($lv_fldidt[0])-1).'").prop("value", data.node.data["'.substr($lv_fldidt[1],0,strlen($lv_fldidt[1])-1).'"] ).trigger("change");';
						}
						echo '$("#'.$vew_prm['popup'].'").modal("hide");';
					}
				?>				
			});
		});
	</script>
	<script>
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {
				tmssLink("index.php?prg=stkmathie&act="+lp_prm["action"], [{target: "_new_section",post_data: $("#<?= $lv_sec; ?>_frm").serializeArray() }] );
			}
		}
	</script>
</section>
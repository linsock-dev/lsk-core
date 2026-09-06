<?php
	// url del formulario 
  $lv_lnk = '?prg=syssecper';

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->permissions;
	
	// m�dulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'PER';
	
	// librer�a de estilos bootstrap 
	include_once('_library.frm');

	// recursiva para mostrar men�
	function armar_menu( $lp_mnu, $lp_usrper, &$vew_lang ) {
		$lv_buffer='';
		$lv_count=0;
		foreach( $lp_mnu as $lv_row ) {
			$lv_buffer_sub='';
			$lv_row['prgpic'] = strtolower($lv_row['prgpic']);
			$lv_pic=($lv_row['prgpic']==''?'':(substr($lv_row['prgpic'],0,6)=='class:'?substr($lv_row['prgpic'],6,strlen($lv_row['prgpic'])-6):'fas fa-ban'));
			// modulo
			if ( $lv_row['prgtypcod']==0 ) {
				$lv_row['mdlpic'] = strtolower($lv_row['mdlpic']);
				$lv_pic=($lv_row['mdlpic']==''?'':(substr($lv_row['mdlpic'],0,6)=='class:'?substr($lv_row['mdlpic'],6,strlen($lv_row['mdlpic'])-6):'fas fa-ban'));
				if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub = armar_menu( $lv_row['mnulst'], $lp_usrper, $vew_lang ); }
				$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'far fa-folder-open').'"}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="**">'.$vew_lang->get($lv_row['mdltxt']).' ('.$lv_row['mdlcod'].')'.'<ul>'.$lv_buffer_sub.'</ul></li>';
			// carpeta
			} else if ( $lv_row['prgtypcod']==3 ) {
				if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub=armar_menu( $lv_row['mnulst'], $lp_usrper, $vew_lang ); }
				$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'far fa-folder').'"}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'">'.$vew_lang->get($lv_row['prgtxt']).' ('.$lv_row['prgcod'].')'.'<ul>'.$lv_buffer_sub.'</ul></li>';
			// programa
			} else if ( $lv_row['prgtypcod']==1 ) {
				if (count($lv_row['mnulst'])!=0){ $lv_buffer_sub = armar_menu( $lv_row['mnulst'], $lp_usrper, $vew_lang ); }
				$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"'.($lv_pic!=''?$lv_pic:'fas fa-cog').'"}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'">'.$vew_lang->get($lv_row['prgtxt']).' ('.$lv_row['prgcod'].')'.'<ul>'.$lv_buffer_sub.'</ul></li>';
			// operaciones
			} else if ( $lv_row['prgtypcod']==4 ) {
				$lv_id = $lv_row['mdlcod'].'_'.$lv_row['prgcod'].'_'.$lv_row['oprcod'];
				$lv_alw=false;
				foreach($lp_usrper as $lv_per){if($lv_id==$lv_per['mdlcod'].'_'.$lv_per['prgcod'].'_'.$lv_per['oprcod']){$lv_alw=true;break;}}
				$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"fas fa-angle-right","selected":'.($lv_alw?'true':'false').'}'.chr(39).' data-mdlcod="'.$lv_row['mdlcod'].'" data-prgcod="'.$lv_row['prgcod'].'" data-oprcod="'.$lv_row['oprcod'].'">'.$vew_lang->get($lv_row['oprtxt']).' ('.$lv_row['oprcod'].')</li>';
			}
			$lv_count++;
		}
		return $lv_buffer;
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<a href="#" class="hidden" id="btnsubmit" onclick="<?= $lv_sec; ?>_fnc({action: '00'});"></a>

	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('buscod','hidden',$vew_data->buscod); ?>
    <?= gethtml('usrcod','hidden',($vew_data->usrcod!=''?$vew_data->usrcod:'**')); ?>
    <?= gethtml('usrgrpcod','hidden',($vew_data->usrgrpcod!=''?$vew_data->usrgrpcod:'**')); ?>
		<textarea class="hidden" id="usrperatr001" name="usrperatr001"></textarea>
		
		<div id="loading">
			<h2><i class="fas fa-spinner fa-spin fa-fw"></i>&nbsp;&nbsp;Cargando...</h2>
		</div>
		<div id="loaded" style="display: none;">
			<div id="syssecperlst">
				<ul>
				<?= armar_menu( $vew_data->sysopr, $vew_data->usrper, $vew_lang ); ?>
				</ul>
			</div>
		</div>
	</form>
	<script>
		$(function(){
			$("#loading").fadeIn("slow",function(e){
				tmssLoadScript("jstree",function(){
					$("#syssecperlst")
					.on("ready.jstree", function(e, data) {
						$('.jstree a').off('click').on('click',function() {return <?= $vew_readonly?'false':'true';?>;});
					})
			  	.on("after_open.jstree", function(e, data) {
						$('.jstree a').off('click').on('click',function() {return <?= $vew_readonly?'false':'true';?>;});
					})
					.jstree({
						"checkbox" : { "keep_selected_style" : false },
						"core": { "expand_selected_onload" : false, "themes": {	"responsive": true } },
						"plugins" : [ "checkbox" ]
					});
				});
			});
			$("#loading").fadeOut( "slow", function(e){$("#loaded").fadeIn();});
		});
	</script>
	<script>
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if (lp_prm["action"]=="00") {
				var lv_sel = "";
				var lv_itm = $("#syssecperlst").jstree().get_selected(true);
				for(var i=0; i<lv_itm.length; i++) {
					if ( lv_itm[i].children.length==0 ) {
						lv_sel += (lv_sel==""?"":String.fromCharCode(9)) + lv_itm[i].data["mdlcod"]+"_"+lv_itm[i].data["prgcod"]+"_"+lv_itm[i].data["oprcod"];
					}
				}
				$("#<?= $lv_sec; ?> #usrperatr001").text( lv_sel );
			}
		}
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
<?php
	// url del formulario 
  $lv_lnk = '?prg=syssecusrbus&prm_usrcod='.$vew_data->usrcod;

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = $vew_data->usrcod; 

	// titulo 
	$lv_title = $vew_lang->user;
	
	// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'USR';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<a href="#" class="hidden" id="btnsubmit" onclick="<?= $lv_sec; ?>_fnc({action: '00'});"></a>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('usrcod','hidden',$vew_data->usrcod); ?>
		<textarea class="hidden" id="syssecusrbus" name="syssecusrbus"></textarea>
		
		<div id="syssecusrbuslst">
			<ul>
				<?php
					$lv_buffer='';
					foreach($vew_sysbus as $lv_row) {
						$lv_alw = ($lv_row['usrcod']!=''?true:false);
						$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"fas fa-angle-right","selected":'.($lv_alw?'true':'false').'}'.chr(39).' data-buscod="'.$lv_row['buscod'].'">'.$lv_row['bustxt'].' ('.$lv_row['buscod'].')</li>';
					}
					echo $lv_buffer;
				?>
			</ul>
		</div>
		
	</form>
	<script>
		tmssLoadScript("jstree",function(){
			$("#syssecusrbuslst").jstree({
				"checkbox" : { "keep_selected_style" : false },
				"core": { "expand_selected_onload" : false, "themes": {	"responsive": true } },
				"plugins" : [ "checkbox" ]
			});
		});
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext( lp_prm ) {			
			// al grabar
			if (lp_prm["action"]=="00") {
				var lv_sel = "";
				var lv_itm = $("#syssecusrbuslst").jstree().get_selected(true);
				for(var i=0; i<lv_itm.length; i++) {
					if ( lv_itm[i].children.length==0 ) {
						lv_sel += (lv_sel==""?"":String.fromCharCode(9)) + lv_itm[i].data["buscod"];
					}
				}
				$("#<?= $lv_sec; ?> #syssecusrbus").text( lv_sel );
			}
		}
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
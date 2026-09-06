<?php
	// url del formulario 
  $lv_lnk = '?prg=syssecusrgrp&prm_usrgrpcod='.$vew_data->usrgrpcod;

	// campos requeridos 
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = $vew_data->usrgrpcod;

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
    <?= gethtml('usrgrpcod','hidden',$vew_data->usrgrpcod); ?>
		<textarea class="hidden" id="syssecusrgrp" name="syssecusrgrp"></textarea>
		
		<div id="syssecusrgrplst">
			<ul>
				<?php
					$lv_buffer='';
					foreach($vew_sysusr as $lv_row) {
						$lv_alw=false;
						foreach($vew_usrgrp as $lv_row2){if($lv_row['usrcod']==$lv_row2['usrcod']){$lv_alw=true;}}
						$lv_buffer .= '<li data-jstree='.chr(39).'{"icon":"fas fa-angle-right","selected":'.($lv_alw?'true':'false').'}'.chr(39).' data-usrcod="'.$lv_row['usrcod'].'">'.$lv_row['usrtxt'].' ('.$lv_row['usrcod'].')</li>';
					}
					echo $lv_buffer;
				?>
			</ul>
		</div>
	</form>
	<script>
		tmssLoadScript("jstree",function(){
			$("#syssecusrgrplst")
			.on("ready.jstree", function(e, data) {
				// Bind click event to simulate disable checkbox on readonly mode (it works only on vissible checkboxes)
				$('.jstree a').off('click').on('click',function() {return <?= $vew_readonly?'false':'true';?>;});
			})
	  	.on("after_open.jstree", function(e, data) {
				// Bind click event to simulate disable checkbox on readonly mode for previously hidden checkboxes
				$('.jstree a').off('click').on('click',function() {return <?= $vew_readonly?'false':'true';?>;});
			})
			.jstree({
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
				var lv_itm = $("#syssecusrgrplst").jstree().get_selected(true);
				for(var i=0; i<lv_itm.length; i++) {
					if ( lv_itm[i].children.length==0 ) {
						lv_sel += (lv_sel==""?"":String.fromCharCode(9)) + lv_itm[i].data["usrcod"];
					}
				}
				$("#<?= $lv_sec; ?> #syssecusrgrp").text( lv_sel );
			}
		}
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
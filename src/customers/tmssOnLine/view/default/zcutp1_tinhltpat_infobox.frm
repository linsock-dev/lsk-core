<?php
	// url del formulario
  $lv_lnk = '';

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// clave del documento
	$lv_dockey = '';

	// titulo
	$lv_title = $vew_lang->information;
	
	// módulo y programa
	$lv_mdlcod = '';
	$lv_prgcod = '';
		
	// librería de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<label>Actividades</label><br>
	<div class="list-group small">
		<?php
			if($vew_data->crmdocclscod!=''){
				echo '<a href="#" class="list-group-item'.($vew_data->patcod==''?' disabled':'').'" id="btncnt"><span class="far fa-square"></span> Contactos</a>';
			}
			if($vew_data->crmdocclscod!=''){
				echo '<a href="#" class="list-group-item'.($vew_data->patcod==''?' disabled':'').'" id="btnhst"><span class="far fa-square"></span> Historia Clinica</a>';
			}
		?>
	</div>
  <div class="list-group small">

	</div>
	<br>
	<script>
		$("#<?= $lv_sec; ?> #btncnt").on("click",function(e){ e.preventDefault();
			var lv_dat = [{name:"sysdocclscod",value:"<?= $vew_data->crmdocclscod; ?>"},{name:"crmcntsrctyp",value:"HLT_PAT"},{name:"crmcntsrccod",value:"<?= $vew_data->patcod; ?>"}];
			tmssLink("?prg=crmcnt&act=ctr", [{target: "_new_section", post_data: lv_dat}] );
		});
		function <?= $vew_data->frmsec; ?>_GridRefresh() {
			//<?= $vew_data->frmsec; ?>_showCustomerInfoBox();
		}
    		$("#<?= $lv_sec; ?> #btnhst").on("click",function(e){ e.preventDefault();
			var lv_dat = [{name:"patcod",value:"<?= $vew_data->patcod; ?>"}];
			tmssLink("?prg=hltpathst&act=03", [{target: "_new_section", post_data: lv_dat}] );
		});
		function <?= $vew_data->frmsec; ?>_GridRefresh() {
			//<?= $vew_data->frmsec; ?>_showCustomerInfoBox();
		}
	</script>	
</section>
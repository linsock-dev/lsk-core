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
				echo '<a href="#" class="list-group-item'.($vew_data->patcod==''?' disabled':'').'" id="btnhst"><span class="far fa-square"></span> Historia Clinica</a>';
				echo '<a href="#" class="list-group-item'.($vew_data->patcod==''?' disabled':'').'" id="btnstk"><span class="far fa-square"></span> Stock</a>';
			}
		?>
	</div>
  <script>
    <?php if($vew_data->crmdocclscod!='' && $vew_data->patcod!=''){ ?>
      $("#<?= $lv_sec; ?> #btncnt").on("click",function(e){ e.preventDefault();
        var lv_dat = [{name:"sysdocclscod",value:"<?= $vew_data->crmdocclscod; ?>"},{name:"crmcntsrctyp",value:"HLT_PAT"},{name:"crmcntsrccod",value:"<?= $vew_data->patcod; ?>"}];
        tmssLink("?prg=crmcnt&act=ctr&prm_mdlcod=crm&prm_prgcod=ctr", [{target: "_new_section", post_data: lv_dat}] );
      });
      $("#<?= $lv_sec; ?> #btnhst").on("click",function(e){ e.preventDefault();
        var lv_dat = [{name:"patcod",value:"<?= $vew_data->patcod; ?>"}];
        tmssLink("?prg=hltpathst&act=03&prm_mdlcod=hlt&prm_prgcod=hst", [{target: "_new_section", post_data: lv_dat}] );
      });
      $("#<?= $lv_sec; ?> #btnstk").on("click",function(e){ e.preventDefault();
        var lv_dat = [{name:"adrnme001",value:"<?= $vew_data->adr->adrnme001; ?>"}];
        tmssLink("?prg=zcuhga&act=38", [{target: "_new_section", post_data: lv_dat}] );
      });
  <?php } ?>
	</script>	
</section>
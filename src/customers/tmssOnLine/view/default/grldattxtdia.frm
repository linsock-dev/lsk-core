<?php 
  // campos requeridos 
  $vew_input->RequiredFields( array() );

  // clave del documento 
  $lv_dockey = $vew_data->txtcod;

  // titulo 
  $lv_title = $vew_lang->text;

  // módulo y programa 
  $lv_mdlcod = 'GRL';
  $lv_prgcod = 'TXT';

	// libreria de estilos bootstrap
	include_once('_library.frm');	
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('txtcod', 'hidden', $vew_data->txtcod); ?>
		<?= gethtml('txtsrctyp', 'hidden', $vew_data->txtsrctyp); ?>
		<?= gethtml('txtsrccod', 'hidden', $vew_data->txtsrccod); ?>
		<?= gethtml('txttypcod', 'hidden', $vew_data->txttypcod); ?>
		<?= gethtml('txttyptxt', 'hidden', $vew_data->txttyptxt); ?>
    <?= gethtml('lngcod', 'hidden', 'ES'); ?>  
    <?= gethtml('docsts', 'hidden', 'A'); ?>  
    <textarea><?= $vew_data->txttxt; ?></textarea>
	  <a href="#" class="hidden" id="btnsve"></a>
    <a href="#" class="hidden" id="btndel"></a>
  </form>
  <script>
		tmssLoadScript("tinymce",function(){
			// editores de texto
			tinyMCE.init({ 
        selector: '#<?= $lv_sec; ?> textarea',
        plugins: 'anchor autolink charmap codesample emoticons image link lists media searchreplace table visualblocks wordcount paste fullpage',
        toolbar: 'undo redo | blocks fontfamily fontsize | bold italic underline strikethrough | link image media table | align lineheight | numlist bullist indent outdent | emoticons charmap | removeformat',
				extended_valid_elements:"style,link[href|rel]",
				custom_elements:"style,~link",
				height: 300,
				paste_data_images: true
				<?= ($vew_data->readonly=='true'?', menubar: false':''); ?>
				<?= ($vew_data->readonly=='true'?', toolbar: false':''); ?>
				<?= ($vew_data->readonly=='true'?', readonly: 1':''); ?>
			});				
		});
    
		// GRABAR. proceso grabado de formulario
    $("#<?= $lv_sec; ?> #btnsve").on("click", function(e){ e.preventDefault();
			
			// recupera datos del formulario
			var lo_dat = $("#<?= $lv_sec; ?>_frm").serializeArray();
      lo_dat.push( {name:"txttxt", value:tinyMCE.get( $("#<?= $lv_sec; ?> textarea:first").prop("id") ).getContent()} );
      
      // graba texto
      tmssCallProcess("?prg=grldattxt&act=dialogsave", lo_dat, function(data){
        toastr.success("El texto ha sido grabado.");
				// llamada a callback
        if($("#<?= $lv_sec; ?> #btnsve").data("btn_callback") != undefined){
          $( $("#<?= $lv_sec; ?> #btnsve").data("btn_callback") ).trigger("click");
        }
        $("#<?= $lv_sec; ?> #btnsve").data("txtcod",data["txtcod"]);
      });
    });
    
		// BORRAR. proceso grabado de formulario
    $("#<?= $lv_sec; ?> #btndel").on("click", function(e){ e.preventDefault();
			
			// recupera datos del formulario
			var lo_dat = $("#<?= $lv_sec; ?>_frm").serializeArray();
      
      // graba texto
      tmssCallProcess("?prg=grldattxt&act=04", lo_dat, function(data){
      	toastr.info("El texto ha sido borrado.");
				// llamada a callback
        if($("#<?= $lv_sec; ?> #btndel").data("btn_callback") != undefined){
          $( $("#<?= $lv_sec; ?> #btndel").data("btn_callback") ).trigger("click");
        }
        $("#<?= $lv_sec; ?> #btndel").data("txtcod",data["txtcod"]);
      });
    });
  </script>
</section>
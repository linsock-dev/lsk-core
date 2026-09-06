<?php $lv_sec = $vew_token; ?>
<section id="<?= $lv_sec; ?>">
	<div class="container-fluid">
    <textarea id="<?= $lv_sec ?>_txt" >
      <div><?= utf8_decode($vew_data->grlnwsbdy); ?></div>
    </textarea>
  </div>
	<script>
    $(function(){
    tmssLoadScript("tinymce",function(){
				tinyMCE.init({ 
					selector: "#<?= $lv_sec ?>_txt",
					height: 270, 
					menubar: false,
          toolbar: false,
          readonly: "<?= $vew_data->readonly; ?>",
          <?php if(!$vew_data->readonly){?>
            plugins: ['print preview fullpage importcss searchreplace autolink autosave save directionality visualblocks visualchars fullscreen image link media template codesample table charmap hr pagebreak nonbreaking anchor toc insertdatetime advlist lists wordcount  imagetools textpattern noneditable help  charmap emoticons code'],
						menubar: 'file edit view insert format tools table tc',
						toolbar: 'undo redo | bold italic underline strikethrough | fontselect fontsizeselect formatselect | alignleft aligncenter alignright alignjustify | outdent indent |  numlist bullist checklist | forecolor backcolor casechange permanentpen  removeformat | charmap emoticons | fullscreen  preview print | insertfile image media  link codesample | showcomments addcomment'
          <?php } ?>
				});
			});  
    })
  </script>
</section>
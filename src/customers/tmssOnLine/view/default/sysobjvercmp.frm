<?php
	// url del formulario 
  $lv_lnk = '?prg=sysobjvercmp';

	// campos requeridos 
	$vew_input->RequiredFields( ); 

	// clave del documento   
	$lv_dockey = '';  

	// titulo 
	$lv_title = $vew_lang->compare;
	
	// módulo y programa  
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'CMP';
	
	// librería de estilos bootstrap 
	include_once('_library.frm');
	
	$lv_lst = array();
	$lv_lst['DEV'] = 'DEV';
	foreach($vew_data->objver as $lv_row){
		$lv_lst[ $lv_row['sysobjver'] ] = $lv_row['sysobjver'];
	}
	$lv_lst['PRD'] = 'PRD';
?> 
<section id="<?= $lv_sec; ?>" data-title="<?= $vew_lang->compare; ?>" >
	<?= gethtml('tmss_actcod','hidden','')?>
	<div class="row">
		<div class="col-md-6">
			<?= vew_boot($lv_col210, array('label'=>'Version', 'input'=>gethtml('vercod1', $lv_lst, 'DEV', $lv_default) )); ?>
		</div>
		<div class="col-md-6">
			<?= vew_boot($lv_col210, array('label'=>'Version', 'input'=>gethtml('vercod2', $lv_lst, 'PRD', $lv_default) )); ?>
		</div>
	</div>
	<div id='view'></div>
  <? if($vew_data->btn){ ?>
	<style>
    .CodeMirror-merge, .CodeMirror-merge .CodeMirror{
      height: 75vh;
    }
   <? }else{ ?>
	<style>
    .CodeMirror-merge, .CodeMirror-merge .CodeMirror{
      height: 75vh;
    }
  <? } ?>
	</style>
	<script>
		var gv_<?= $lv_sec; ?>_codeMirror;
		var gv_<?= $lv_sec; ?>_file1 = "";
		var gv_<?= $lv_sec; ?>_file2 = "";
		var gv_<?= $lv_sec; ?>_mode = "text/html";
		switch( "<?= strtolower($vew_data->sysobjclstyp); ?>" ){
			case "php": gv_<?= $lv_sec; ?>_mode = "application/x-httpd-php"; break;
			case "css":	gv_<?= $lv_sec; ?>_mode = "text/css";	break;
			case "js":	gv_<?= $lv_sec; ?>_mode = "text/javascript"; break;
		}
		
		tmssLoadScript("codemirror",function(){
			<?= $lv_sec; ?>_getCode( "vercod1", $("#<?= $lv_sec; ?> #vercod1").val() );
			<?= $lv_sec; ?>_getCode( "vercod2", $("#<?= $lv_sec; ?> #vercod2").val() );
			<?= $lv_sec; ?>_compareFiles();
		});
		
		function <?= $lv_sec; ?>_compareFiles(){
			var target = $("#<?= $lv_sec; ?> #view")[0];
			target.innerHTML = "";
			if( gv_<?= $lv_sec; ?>_file1=="" || gv_<?= $lv_sec; ?>_file2==""){ return false; }
			gv_<?= $lv_sec; ?>_codeMirror = CodeMirror.MergeView(target, {
				value: gv_<?= $lv_sec; ?>_file1,
				//origLeft: null,
				orig: gv_<?= $lv_sec; ?>_file2,
				lineNumbers: true,
				mode: gv_<?= $lv_sec; ?>_mode,
				highlightDifferences: true,
				connect: null, //"align",
				collapseIdentical: true
			});			
		}
		
    function <?= $lv_sec; ?>_getCode( lp_fld, lp_ver ){
      var lv_dat = {sysobjcod: "<?= $vew_data->sysobjcod ?>", vercod: lp_ver};
      tmssCallProcess("?prg=sysobj&act=flecont",lv_dat,function(data){
				if(data.errtyp=="S"){
					if(lp_fld=="vercod1"){
						gv_<?= $lv_sec; ?>_file1 = data.flecnt;
					} else {
						gv_<?= $lv_sec; ?>_file2 = data.flecnt;
					}

					<?= $lv_sec; ?>_compareFiles();
				}
			});
    }
		
  	$("#<?= $lv_sec; ?> #vercod1, #<?= $lv_sec; ?> #vercod2").on("change", function(){
			<?= $lv_sec; ?>_getCode( $(this).attr("id"), $(this).val() );
    });
	</script>			
</section>
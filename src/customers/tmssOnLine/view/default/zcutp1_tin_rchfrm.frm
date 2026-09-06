<?php
	// url del formulario 
  $lv_lnk = "?prg=zcutp1_tin";

	// campos requeridos 
	$vew_input->RequiredFields( array('patpro', 'adrphn001', 'adreml') );

	// clave del documento 
	$lv_dockey = $vew_data->patcod; 

	// titulo 
	$lv_title = $vew_lang->form;
	
	// módulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PAT';

	// librería de estilos bootstrap 
	include_once('_library.frm');
		
	// valores por default
/* 	if ( $vew_data->patcod=='') {
		$lv_defvalstr = $vew_doc->getTagValue($vew_doccls->sysdocclsatr,'defval');
		eval( str_ireplace('^',chr(39),$lv_defvalstr) );
	} */
?>
<section id="<?php echo $lv_sec; ?>" data-title="<?php echo $lv_title; ?>">

  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<a href="#" onclick="<?php echo $lv_sec; ?>_fnc({action: 'rchfrmsve'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success" title="<?php echo $vew_lang->save;  ?>"><span class="fas fa-save"></span><span class="hidden-xs">  <?php echo $vew_lang->save; ?></span></a>
				<a href="#" onclick="<?php echo $lv_sec; ?>_fnc({action: '98'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-danger" title="<?php echo $vew_lang->cancel; ?>"><span class="fas fa-times"></span><span class="hidden-xs">  <?php echo $vew_lang->cancel; ?></span></a>				
			</ul>
			<ul class="navbar-right btn-toolbar tmss-navbar-right">
				<!--Cerrar-->
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn navbar-btn tmss-navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
			</ul>
		</div>
  </nav>

	<div class="container-fluid">
    <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?php echo $lv_sec; ?>_frm">
      <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
      
      <input type="hidden" id="docsts" name="docsts" value="<?= $vew_data->docsts; ?>">
      <input type="hidden" id="patcod" name="patcod" value="<?= $vew_data->patcod; ?>">
      <input type="hidden" id="pattxt" name="pattxt" value="<?= $vew_data->pattxt; ?>">
      
      <div class="row">
        <div class="container-fluid">
          <?php 
              echo vew_boot($lv_col210, array('label'=>$vew_lang->protocol, 'input'=>gethtml('patpro',	'doccmt1x20',$vew_data->patpro,		$lv_default) ));
							include('grldatadrcntsml.frm');
							echo'<hr>';
							echo vew_boot($lv_col210, array('label'=>$vew_lang->doctor, 'input'=>gethtml('patprsrlstxt','doccmt1x50', $vew_doc->getTagValue($vew_data->patprsrlsatr001,'patprsrlstxt'),		$lv_default) ));
							echo vew_boot($lv_col210, array('label'=>$vew_lang->phone, 'input'=>gethtml('patprsrlsphn','doccmt1x50', $vew_doc->getTagValue($vew_data->patprsrlsatr001,'patprsrlsphn'),		$lv_default) ));
            ?>
        </div>		
      </div>
    </form>
	</div>
  <script>
    var gv_<?php echo $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $("#<?php echo $lv_sec; ?>_frm"), "<?php echo $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?php echo $lv_sec; ?>_last_action, "<?php echo $lv_title; ?>", "<b><?php echo $lv_dockey; ?></b>" ) ) {
				if (gv_<?php echo $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?php echo $lv_sec; ?>") );
				} else {
					var lv_errtyp = $("<div>"+data+"</div>").find("errtyp:first").text();
					if( lv_errtyp=="" ) {
						toastr.success("Los datos han sido grabados.");
						tmssTabSecCls( $("#<?php echo $lv_sec; ?>") );
					} else {
						$("#<?php echo $lv_sec; ?>").replaceWith( data );
					}
				}
			}
    });
		
		// form submit
    function <?php echo $lv_sec; ?>_fnc( lp_prm ) {
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {
				
				if(lp_prm["action"]=="rchfrmsve"){
					if($("#<?php echo $lv_sec; ?> #patcod").val()==""){
						$("#<?php echo $lv_sec; ?> #pattxt").val("");
						$("#<?php echo $lv_sec; ?> #docsts").val("A");
					}
					if (!tmssCheckRequiredFields( $("#<?php echo $lv_sec; ?>_frm") )){return false;}
				}
				
				gv_<?php echo $lv_sec; ?>_last_action = lp_prm["action"];
				var lv_action = (gv_<?php echo $lv_sec; ?>_last_action=="99"?"<?php echo ($vew_actcod=='02'?'02':'03'); ?>":gv_<?php echo $lv_sec; ?>_last_action);
				tmssMessageProcessing( "<?php echo $lv_sec; ?>", lv_action, "<?php echo $lv_title; ?>", "<?php echo ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
			}
		}
		
		// edit mode
    tmssFormEdit("<?php echo $lv_sec; ?>",<?php echo ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	</script>
</section>
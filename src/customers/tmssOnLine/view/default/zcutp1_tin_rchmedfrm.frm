<?php
	// url del formulario 
  $lv_lnk = "?prg=zcutp1_tin&prm_patcod=".$vew_data->patcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('adrfrtnme', 'adrlstnme', 'taxcod001', 'perbrndte', 'evlatrdrg', 'mattxt', 'matcod', 'evlatrdos','hltdisclstxt','hltdisclscod') );

	// clave del documento 
	$lv_dockey = $vew_data->patcod; 

	// titulo 
	$lv_title = $vew_lang->form;
	
	// módulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PAT';

	// librería de estilos bootstrap 
	include_once('_library.frm');
	
	// determino que documentos fueron firmados
	$lv_frm_om = '';
	$lv_frm_hc = '';
	$lv_frm_ci = '';
	if($vew_data->evl->evlcod != ''){
		foreach ($vew_sgndoc as $lv_row) {
			switch( $lv_row['sgndocsrccod002'] ){
				case 'OM': $lv_frm_om = $lv_row['flecod']; break;
				case 'HHCC': $lv_frm_hc = $lv_row['flecod']; break;
				case 'CI': $lv_frm_ci = $lv_row['flecod']; break;
			}
		}
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <nav class="navbar navbar-default tmss-navbar tmss-navbar-fixed">
    <div class="container-fluid">
			<ul class="nav navbar-nav tmss-navbar-left">
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: 'rchmedfrm02'});"  class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit" title="<?= $vew_lang->evolution; ?>"><i class="fas fa-pencil-alt"></i><span class="hidden-xs"> <?= $vew_lang->evolution; ?></span></a>
				<a href="#" onclick="<?= $lv_sec; ?>_fnc({action: 'rchmedfrmsve'});" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-success" title="<?= $vew_lang->save;  ?>"><span class="fas fa-save"></span><span class="hidden-xs">  <?= $vew_lang->save; ?></span></a>
				<a href="#" onclick="<?= ($vew_actcod!='01'?$lv_sec.'_fnc({action: '.chr(39).'rchmedfrm03'.chr(39).'});':'tmssTabSecCls( $('.chr(39).'#'.$lv_sec.chr(39).') );' ); ?>" class="btn btn-default navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-danger" title="<?= $vew_lang->cancel; ?>"><span class="fas fa-times"></span><span class="hidden-xs">  <?= $vew_lang->cancel; ?></span></a>
			</ul>
			<ul class="nav navbar-nav navbar-right btn-toolbar tmss-navbar-right">
				<!-- Firmar -->
				<span class="tmssHiddeOnEdit"><?php if($vew_data->evl->evlcod!='') { include('admsgnbtn.frm'); } ?></span>
				<!--Dropdown-->
				<div class="btn-group dropdown">
					<a href="#" class="btn navbar-btn tmss-navbar-btn dropdown-toggle" data-toggle="dropdown"><span class="fas fa-ellipsis-v"></span></a>
					<form class="dropdown-menu dropdown-menu-right tmssBrandMnuUsr" style="position:absolute;background-color:white;clear:both;"  aria-labelledby="dLabel">
						<!--Actualizar-->
						<li><a href="#" onclick="<?= $lv_sec; ?>_GridRefresh();" class="tmssLink"><i style="width:20px" class="fas fa-sync-alt"></i><?= $vew_lang->refresh; ?></a></li>
						<?php if($vew_data->evl->evlcod != '') { ?>
							<!--Orden medica-->
							<li><a href="#" name="btnfrm" data-frm="om" class="tmssLink tmssHiddeOnEdit" data-flecod="<?= $lv_frm_om; ?>"><i style="width:20px" class="<?= ($lv_frm_om!=''?'fas fa-file-signature':'fas fa-print'); ?>"></i><?= 'Orden M&eacutedica' ?></a></li>
							<!--Historia clinica-->
							<li><a href="#" name="btnfrm" data-frm="hc" class="tmssLink tmssHiddeOnEdit" data-flecod="<?= $lv_frm_hc; ?>"><i style="width:20px" class="<?= ($lv_frm_hc!=''?'fas fa-file-signature':'fas fa-print'); ?>"></i><?= $vew_lang->medicalHistory ?></a></li>
							<!--Consentimiento informado-->
							<li><a href="#" name="btnfrm" data-frm="ci" class="tmssLink tmssHiddeOnEdit" data-flecod="<?= $lv_frm_ci; ?>"><i style="width:20px" class="<?= ($lv_frm_ci!=''?'fas fa-file-signature':'fas fa-print'); ?>"></i><?= 'Consentimiento' ?></a></li>
						<?php } ?>
					</form>
				</div>
				<!--Cerrar-->
				<a href="#" onclick="tmssTabSecCls( $('#<?= $lv_sec; ?>') );" id="btncls" class="btn tmss-navbar-btn navbar-btn" title="<?= $vew_lang->close; ?>"><span class="fas fa-times"></span></a>
        </ul>				
		</div>
  </nav>

	<div class="container-fluid">
    <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
      <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">

      <div class="container-fluid" role="tabpanel">
        <ul class="nav nav-tabs" role="tablist">
          <li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
          <li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->clinicalhistory; ?></a></li>
        </ul>

        <div class="tab-content tmss-tab-content">
          <!-- GENERAL -->
          <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
            <input type="hidden" id="docsts" name="docsts" value="<?= $vew_data->docsts; ?>">
            <input type="hidden" id="patcod" name="patcod" value="<?= $vew_data->patcod; ?>">
            <input type="hidden" id="pattxt" name="pattxt" value="<?= $vew_data->pattxt; ?>">
						<input type="hidden" id="evlcod" name="evlcod" value="<?= $vew_data->evl->evlcod; ?>">
            
            <div class="row">
              <div class="col-md-6">
                <?php 
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->firstname,'input'=>gethtml('adrfrtnme','adrfrtnme',$vew_data->adr->adrfrtnme,$lv_default) )); 
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->lastname, 'input'=>gethtml('adrlstnme','adrlstnme',$vew_data->adr->adrlstnme,$lv_default) )); 
									echo vew_boot($lv_col210, array('label'=>$vew_lang->dni, 'input'=>gethtml('taxcod001','doccmt1x20',$vew_data->tax->taxcod, $lv_default) ));
									echo vew_boot($lv_col210, array('label'=>$vew_lang->borndate, 	'input'=>gethtml('perbrndte','docdte',$vew_data->per->perbrndte,$lv_default) )); 
                  include('grldatadrsml.frm');
                ?>
              </div>
              <div class="col-md-6">
                <?php
									echo vew_boot($lv_col210, array('label'=>$vew_lang->coverage,'input'=>gethtml('hhrmedcovtxt','doccmt1x50', $vew_data->per->hhrmedcovtxt,$lv_default) ));
									echo '<input type="hidden" id="hhrmedcovcod" name="hhrmedcovcod" value="'.$vew_data->per->hhrmedcovcod.'">'; 
									echo vew_boot($lv_col255, array('label'=>$vew_lang->plan.'/'.$vew_lang->affiliatednumber, 'input1'=>gethtml('hhrmedcovaflpln','doccmt1x50',$vew_data->per->hhrmedcovaflpln,$lv_default), 'input2'=>gethtml('hhrmedcovaflnum','doccmt1x50',$vew_data->per->hhrmedcovaflnum,$lv_default) )); 									
									echo vew_boot($lv_col210, array('label'=>$vew_lang->sourcedoctor,'input'=>gethtml('prstxt','doccmt1x50', $vew_data->prs->prstxt, $lv_always_disabled) ));
									echo '<input type="hidden" name="prscod" value="'.$vew_data->prs->prscod.'">'; 
									include('grldatadrcntsml.frm');
                ?>
              </div>
            </div>
          </div> <!-- fin tab001 -->

          <!-- HISTORIA CLINICA -->
          <div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
            <?php include('zcutp1_tin_rchmedfrmevl.frm'); ?>  
          </div> <!-- fin tab002 -->

        </div> <!-- Tab-content -->
      </div> <!-- Container-fluid -->
    </form>
	</div>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";

		// server response
    tmssLinkForm( $("#<?= $lv_sec; ?>_frm"), "<?= $lv_lnk; ?>", function (data) {
			if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    });
		
		// form submit
    function <?= $lv_sec; ?>_fnc( lp_prm ) {
			if(lp_prm["action"]=="rchmedfrmsve"){
				if($("#<?= $lv_sec; ?> #patcod").val()==""){
					$("#<?= $lv_sec; ?> #docsts").val("A");
				}
				if($("#<?php echo $lv_sec; ?> #matcod").val()==''){
						$("#<?php echo $lv_sec; ?> #mattxt").val('');
				}
				if($("#<?php echo $lv_sec; ?> #hltdisclscod").val()==''){
						$("#<?php echo $lv_sec; ?> #hltdisclstxt").val('');
				}	
				if (!tmssCheckRequiredFields( $("#<?= $lv_sec; ?>_frm") )){return false;}
			}
			gv_<?= $lv_sec; ?>_last_action = lp_prm["action"];
			var lv_action = (gv_<?= $lv_sec; ?>_last_action=="99"?"<?= ($vew_actcod=='02'?'02':($vew_actcod=='01'?'01':'03')); ?>":gv_<?= $lv_sec; ?>_last_action);
			tmssMessageProcessing( "<?= $lv_sec; ?>", lv_action, "<?= $lv_title; ?>", "<?= ($lv_dockey==''?'':'<b>'.$lv_dockey.'</b>'); ?>" );
		}
		
		// edit mode
    tmssFormEdit("<?= $lv_sec; ?>",<?= ($vew_actcod=='01'||$vew_actcod=='02'?'true':'false'); ?>);
	</script>
</section>
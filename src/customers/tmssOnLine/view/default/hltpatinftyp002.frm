<?php
	// url del formulario
  $lv_lnk = "?prg=hltpat&prm_patcod=".$vew_data->patcod;

	// campos requeridos
	//$vew_input->RequiredFields( array('adrlstnme','adrfrtnme','idttypcod','taxcod001') );
	$lv_reqflddef = array('adrlstnme','adrfrtnme','idttypcod','taxcod001','custxt','cuscod','lndcod','lndtxt');
	$lv_reqfldusrtxt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'sysdocclsreqfld');
	$lv_reqfldusr = ($lv_reqfldusrtxt!=''?explode(';',$lv_reqfldusrtxt):array());
	$vew_input->setReqFields( array_merge($lv_reqflddef,$lv_reqfldusr) );

	// clave del documento
	$lv_dockey = $vew_data->patcod; 

	// titulo
	$lv_title = $vew_lang->patient;
	
	// modulo y programa
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PAT';
		
	$lv_confirmduplicate = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'confirmDuplicate');
	if ( $vew_data->patcod=='') {
		$lv_defvalstr = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'defval');
		eval( str_ireplace('^',chr(39),$lv_defvalstr) );
	}

	// valores por default
	if ( $vew_data->patcod=='') {
		$lv_defvalstr = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'defval');
		eval( str_ireplace('^',chr(39),$lv_defvalstr) );
	}

	// libreria de estilos bootstrap
	include_once('_library.frm');
	
	// Botones por vista
	$vew_tbl['clsR'] = array('per'=>false);
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal pb-0" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<?= gethtml('hltpatvew','hidden','hltpatinftyp002'); ?>
		<?= gethtml('patcod','hidden',$vew_data->patcod); ?>
		<?= gethtml('pattxt','hidden',$vew_data->pattxt); ?>
		<?= gethtml('sysdocclscod','hidden',$vew_data->sysdoccls->sysdocclscod); ?>
		<?= gethtml('cushsp','hidden',$vew_data->cushsp); ?>
		<?= gethtml('docsts','hidden',($vew_data->docsts==''?'A':$vew_data->docsts)); ?>
		<textarea class="hidden" id="patatrval001" name="patatrval001"><?= $vew_data->patatrval001; ?></textarea>
		<textarea class="hidden" id="patatrval002" name="patatrval002"><?= $vew_data->patatrval002; ?></textarea>
		
		<div class="container-fluid">
			<div class="row">
        <div class="col-md-6">
          <div class="card">
            <div class="card-header"><div class="card-title"><?= $lv_title; ?></div></div>
            <div class="card-body">
              <?php 
                echo vew_boot($lv_col39, array('label'=>$vew_lang->lastname, 'input'=>gethtml('adrlstnme','adrlstnme',$vew_data->adr->adrlstnme,$lv_default) )); 
                echo vew_boot($lv_col39, array('label'=>$vew_lang->firstname,'input'=>gethtml('adrfrtnme','adrfrtnme',$vew_data->adr->adrfrtnme,$lv_default) )); 
                echo vew_boot($lv_col345, array('label'=>$vew_lang->taxcode.' 1',
                                                'input1'=>gethtml('idttypcod',array(),$vew_data->tax->taxdoctyp, $lv_default),
                                                'input2'=>gethtml('taxcod001','doccmt1x20',$vew_data->tax->taxcod, $lv_default) ));
                echo '<hr>';
                echo vew_boot($lv_col39, array('label'=>$vew_lang->borndate, 'input'=>gethtml('patbrndte', 'docdte', $vew_data->patbrndte,	$lv_default) ));
                echo vew_boot($lv_col39, array('label'=>$vew_lang->sex, 'input'=>gethtml('patsex', 'adrsex',	$vew_data->patsex,		$lv_default) ));
                echo '<hr>';
                echo vew_boot($lv_col39, array('label'=>$vew_lang->medicalcoverage,
                                                'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                    array('input'=>gethtml('hhrmedcovtxt', 'typeahead', $vew_data->per->hhrmedcovtxt, $lv_default) )) ));
                echo gethtml('hhrmedcovcod', 'hidden', $vew_data->per->hhrmedcovcod);
                echo vew_boot($lv_col39, array("label"=>$vew_lang->affiliated, 'input'=>gethtml('pataflnum', 'pataflnum',	$vew_data->pataflnum,	$lv_default) ));
                echo vew_boot($lv_col39, array("label"=>$vew_lang->plan, 'input'=>gethtml('pataflpln', 'pataflpln',	$vew_data->pataflpln,	$lv_default) ));
                echo vew_boot($lv_col39, array('label'=>$vew_lang->financial,
                                                'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                    array('input'=>gethtml('custxt', 'typeahead', $vew_data->custxt, $lv_default) )) ));
              	echo gethtml('cuscod', 'hidden', $vew_data->cuscod);
                echo '<hr>';
              	echo vew_boot($lv_col48, array('label'=>$vew_lang->diseaseclassification, 'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('hltdisclstxt', 'typeahead', $vew_data->hltdisclstxt, $lv_default) )) ));
                echo gethtml('hltdisclscod', 'hidden', $vew_data->hltdisclscod);
              ?>            
            </div>
          </div>
        </div>
				<div class="col-md-6">
          <div class="card">
            <div class="card-header"><div class="card-title"><?= $vew_lang->address.' / '.$vew_lang->contact; ?></div></div>
            <div class="card-body">
              <?php include('grldatadrsml.frm'); ?>
              <hr>
              <?php include('grldatadrcntsml.frm'); ?>              
            </div>
          </div>
				</div>
			</div>
		</div>
  </form>
	<script>
    // medcov
    var lo_get = { "fldsec":"<?= $lv_sec; ?>", "fldflt":{"c.docsts":"A"}, "fldasg": {"hhrmedcovcod":"hhrmedcovcod","hhrmedcovtxt":"hhrmedcovtxtful"} };
    tmssTypeahead($("#<?= $lv_sec; ?> #hhrmedcovtxt"), "hhrmedcov", lo_get);
    
    // FINANCIADOR
    var lo_get = { "fldsec": "<?= $lv_sec;?>", "fldasg": {"cuscod":"cuscod", "custxt":"custxt"} };
    tmssTypeahead($("#<?= $lv_sec; ?> #custxt"), "slscus", lo_get);
    
    // Clasificacion de enfermedad
    var lo_get = {"fldsec": "<?= $lv_sec;?>", "fldasg": {"hltdisclscod":"hltdisclscod", "hltdisclstxt":"hltdisclstxt"} };
    tmssTypeahead($("#<?= $lv_sec; ?> #hltdisclstxt"), "hltdiscls", lo_get);

		function <?= $lv_sec; ?>_grdattax_updIdttypcod( lp_callback ){
			var lv_lndcod = $("#<?= $lv_sec; ?> #lndcod").prop("value");
			$("#<?= $lv_sec; ?> #idttypcod option").remove();
			$("#<?= $lv_sec; ?> #idttypcod").append("<option value=''></option>");
			tmssCallProcessNoBackdrop("?prg=admidttyp&act=19",[{name:"lndcod",value:lv_lndcod}],function(data){
				for(var i=0; i<data.length; i++){
					$("#<?= $lv_sec; ?> #idttypcod").append("<option value='"+data[i].idttypcod+"'>"+data[i].idttyptxt+"</option>");
				}
				if(typeof lp_callback!="undefined"){ lp_callback(); }
			});
		}
	
		$(function(){
			// si cambia el país, cambio las opciones de los identificadores fiscales
			$("#<?= $lv_sec; ?> #lndcod").on("change",function(e){ e.preventDefault();
				<?= $lv_sec; ?>_grdattax_updIdttypcod();
			});
			<?= $lv_sec; ?>_grdattax_updIdttypcod( function(){
				$("#<?= $lv_sec; ?> #idttypcod").prop("value", "<?= $vew_data->tax->taxdoctyp; ?>");
			});
		});
  </script>
  <script>
		// GRABAR - DUPLICADOS
		$("#<?= $lv_sec; ?> #btnsve").on("click",function(e){ e.preventDefault();
			<?php if ( $lv_confirmduplicate!='' ) { ?>
			if ( $("#<?= $lv_sec; ?> #patcod").prop("value")=="" ) {
				var lv_pstdat= {<?php
													$lv_fldarr = explode(',',$lv_confirmduplicate);
													for($i=0; $i<count($lv_fldarr);$i++){	echo $lv_fldarr[$i].': $("#'.$lv_sec.' #'.$lv_fldarr[$i].'").prop("value")'.($i==count($lv_fldarr)-1?'':','); }
												?>};				
				tmssCallProcess("?prg=hltpat&act=17", lv_pstdat, function(data){
					if (data.length>0) {
						BootstrapDialog.confirm({
							title: "Crear", 
							message:"Se encontraron "+data.length+" pacientes con datos similares al que est&aacute; creando.<br /><br />Desea continuar de todas maneras ?",
							type: BootstrapDialog.TYPE_WARNING,
							callback: function(result){
								if(result){	<?= $lv_sec; ?>_fnc({action: '00'}); }
							}
						});
					} else {
						<?= $lv_sec; ?>_fnc({action: '00'});
					}
				});
			} else { 
				<?= $lv_sec; ?>_fnc({action: '00'}); 
			}
			<?php } else { ?>
				<?= $lv_sec; ?>_fnc({action: '00'}); 
			<?php } ?>
		});
	</script>
  <script>
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
      // al cancelar, si la vista esta sobre un dialog, cierro el dialogo actual
			if ( lp_prm["action"]=="98" && "<?= $vew_data->lv_sec; ?>"!="" ) {
				$.each(BootstrapDialog.dialogs, function(id, dialog){ 
          if(dialog.$modalBody.find("#<?= $lv_sec; ?>").length>0){
            dialog.close();
            return false;
        	}
        });
      }
    }
	</script>
  <?php include("grldocfrmscr.frm"); ?>
</section>
<?php
	// url del formulario 
  $lv_lnk = '?prg=grldatfletyp&prm_fletypcod='.$vew_data->fletypcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('fletyptxt','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->fletypcod; 

	// titulo 
	$lv_title = $vew_lang->type;
	
	// módulo y programa 
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'FLT';

	//tipos de arhivos
	$lv_typarr = array(	'' => '',
                      'img' => 'Imagen',
                      'pdf' => 'PDF',
                      'wrd' => 'Word',
                      'ppt' => 'PowerPoint',
                      'exl' => 'Excel',
                      'txt' => 'Texto',
                      'otr' => 'Cualquiera'
                  );

	// librería de estilos bootstrap 
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
  	<?= gethtml('tmss_actcod',	'hidden', ''); ?>
    <textarea class="hidden" id="fletypatr" name="fletypatr"></textarea>
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->fletypcod; ?><?=gethtml('fletypcod',	'hidden', $vew_data->fletypcod);?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
            <div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->general; ?></div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 			'input'=>gethtml('fletypcodext','doccmt1x20', 	$vew_data->fletypcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('fletyptxt', 	'doccmt1x50', 	$vew_data->fletyptxt, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 			'docsts', 			$vew_data->docsts, $lv_default) ));
                  ?>
                </div>
            	</div>
            </div>
            <div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->configuration;?></div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->duedate, 'input'=>gethtml('fletypatrdue','checkbox', $vew_doc->getTagValue($vew_data->fletypatr,'fletypatrdue'), $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>'User Exit', 'input'=>gethtml('user_exit','doccmt1x250',$vew_doc->getTagValue($vew_data->fletypatr,'user_exit'),$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->authorizationcode, 'input'=>gethtml('autcod', 'autcod', $vew_data->autcod, $lv_default) ));
                  ?>
              	</div>
            	</div>
            </div>
          </div><!--fin row 1-->
          <div class="row">
            <div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->RESTRICTIONS;?></div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->allowed, 'input'=>gethtml('fletypatrtyp',$lv_typarr, $vew_doc->getTagValue($vew_data->fletypatr,'fletypatrtyp'), $lv_default) ));
                   	echo vew_boot($lv_colsm2415, array('label'=>$vew_lang->size, 'input'=>gethtml('fletypatrsze','docnum0300',$vew_doc->getTagValue($vew_data->fletypatr,'fletypatrsze'),$lv_default),
                                                     'label2'=>'MB','input2'=>''));
                  ?>
              	</div>
            	</div>
            </div>
            <div class="col-md-6 hidden" id="imgcol">
              <div class="card">
                <div class="card-header">
                  <div class="card-title"><?= $vew_lang->image;?></div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                  	echo vew_boot($lv_col210, array('label'=>'Sel. Principal', 'input'=>gethtml('fletypatrsel','checkbox', $vew_doc->getTagValue($vew_data->fletypatr,'fletypatrsel'), $lv_default) ));
                    echo vew_boot($lv_col2424, array('label'=>$vew_lang->height, 'input'=>gethtml('fletypatrhth','docnum0300',$vew_doc->getTagValue($vew_data->fletypatr,'fletypatrhth'),$lv_default),
                                 										'label2'=>$vew_lang->width, 'input2'=>gethtml('fletypatrwth','docnum0300',$vew_doc->getTagValue($vew_data->fletypatr,'fletypatrwth'),$lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>'Mantener Aspecto', 'input'=>gethtml('fletypatrkepasp','checkbox', $vew_doc->getTagValue($vew_data->fletypatr,'fletypatrkepasp'), $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>'Marco', 'input'=>gethtml('fletypatrfrm',array('cuadrado'=>'cuadrado','redondo'=>'redondo'), $vew_doc->getTagValue($vew_data->fletypatr,'fletypatrfrm'), $lv_default) ));
										echo vew_boot($lv_col2424, array('label'=>'Alto de Marco', 'input'=>gethtml('fletypatrhthfrm','docnum0300',$vew_doc->getTagValue($vew_data->fletypatr,'fletypatrhthfrm'),$lv_default),
                                 										'label2'=>'Ancho de marco', 'input2'=>gethtml('fletypatrwthfrm','docnum0300',$vew_doc->getTagValue($vew_data->fletypatr,'fletypatrwthfrm'),$lv_default) ));
                  	
                  ?>
              	</div>
            	</div>
            </div>
          </div><!--fin row 2-->
				</div><!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form>
	<script>
    $(function(){
      	if($("#<?= $lv_sec; ?> #fletypatrtyp").val()=="img"){$("#<?= $lv_sec; ?> #imgcol").removeClass("hidden");
        }else{ $("#<?= $lv_sec; ?> #imgcol").addClass("hidden");}
    });
    $("#<?= $lv_sec; ?> #fletypatrtyp").change(function(){
      if(this.value=="img"){$("#<?= $lv_sec; ?> #imgcol").removeClass("hidden");
      }else{
        $("#<?= $lv_sec; ?> #imgcol").addClass("hidden");
        $("#<?= $lv_sec; ?> #imgcol input").val("");
        $("#<?= $lv_sec; ?> #imgcol input[type='checkbox']").val("").bootstrapToggle("off");


      }
    });
		tmssLoadScript("toggle",function(){
    	$("#<?= $lv_sec; ?> input[type='checkbox']").bootstrapToggle({ onstyle: 'success', offstyle: 'default', on: 'Si', off: 'No', size: 'small' });
    });
    
	</script>
  <script>  
    // form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00"  ) {              
        let lv_fletypatr = "";
        let lv_atrids="#fletypatrsze,#user_exit,#fletypatrtyp,#fletypatrkepasp,#fletypatrhth,#fletypatrwth,#fletypatrfrm,#fletypatrhthfrm,#fletypatrwthfrm";
				$("#<?= $lv_sec; ?> :checkbox").each( function() {lv_fletypatr += "<" + this.id + ">" + (this.checked ? "1" : "0") + "</" + this.id+ ">";});
        $("#<?= $lv_sec; ?>").find(lv_atrids).each( function() {
          lv_fletypatr += "<" + this.id + ">" + this.value + "</" + this.id+ ">";
        });
        $("#<?= $lv_sec; ?> #fletypatr").text(lv_fletypatr);
      }
    }
  </script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
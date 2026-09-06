<?php		
	// url del formulario 
  $lv_lnk = '?prg=finlocargpos';

	// campos requeridos 
	$vew_input->RequiredFields( array('slspostxt','sysdocclstxt','argltrcodext','argpostyp','docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->argposcod; 

	// titulo 
	$lv_title = $vew_lang->PointOfSales;
	
	// modulo y programa 
	$lv_mdlcod = 'FIN';
	$lv_prgcod = 'ARPOS';
	
	// libreria de estilos bootstrap 
	include_once('_library.frm');
?>	
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<textarea class="hidden" id="argltrrules"></textarea>
		
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>		
				<li class="pull-right"><h4># <strong><?= $vew_data->argposcod; ?><?= gethtml('argposcod','hidden',$vew_data->argposcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
              	<div class="card-header">
                	<div class="card-title"><?= $lv_title; ?>
                  </div>
								</div>
								<div class="card-body tmss-card-body-edit">
                  <?php
                  	echo vew_boot($lv_col39, array('label'=>$vew_lang->code, 	'input'=>gethtml('slsposcodext', 'doccmt1x20', $vew_data->slsposcodext, $lv_always_disabled) ));
                  	
                    echo vew_boot($lv_col39, array('label'=>$vew_lang->PointOfSales, 	'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('slspostxt', 'doccmt1x20', $vew_data->slspostxt, $lv_default) )) ));
                  	echo gethtml('slsposcod', 'hidden', $vew_data->slsposcod);

                    echo vew_boot($lv_col39, array('label'=>$vew_lang->documentclass, 	'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('sysdocclstxt', 'doccmt1x20', $vew_data->sysdocclstxt, $lv_default) )) ));
                  	echo gethtml('sysdocclscod', 'hidden', $vew_data->sysdocclscod);    

                    echo vew_boot($lv_col39, array('label'=>$vew_lang->letter, 	'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly), array('input'=>gethtml('argltrcodext', 'doccmt1x2', $vew_data->argltrcodext, $lv_always_disabled) )) ));
                  	echo gethtml('argltrcod', 'hidden', $vew_data->argltrcodext);

                    echo vew_boot($lv_col39, array('label'=>$vew_lang->status, 		'input'=>gethtml('docsts', 		'docsts', 		$vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div>
						</div>
						<div class="col-md-6">
              <div class="card">
              	<div class="card-header">
                	<div class="card-title"><?= $vew_lang->data; ?>
                  </div>
								</div>
								<div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col39, array('label'=>$vew_lang->type,			'input'=>gethtml('argpostyp', array('LN'=>'Facturacion en Linea','WO'=>'Webservice OnLine','WD'=>'Webservice Diferido','M'=>'Manual', 'A'=>'Autoimpresor'), $vew_data->argpostyp, $lv_default) )); 

                    echo vew_boot($lv_col39, array('label'=>'Cod.Afip', 'input'=>gethtml('argposcodext', 'doccmt1x20', $vew_data->argposcodext, $lv_default) ));
                    echo vew_boot($lv_col39, array('label'=>'Nombre Afip', 'input'=>gethtml('argpostxt', 'doccmt1x50', $vew_data->argpostxt, $lv_default) ));

										echo vew_boot($lv_col39, array('label'=>$vew_lang->numerationrange, 	
                                                   'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                      array('input'=>gethtml('docrngcod', 'rngcod_btn', $vew_data->docrngcod, $lv_always_disabled) ))
                                                  	));                    	  
                    
                    echo vew_boot($lv_col39, array('label'=>$vew_lang->type.' WSFE', 'input'=>gethtml('argposregcod', array(''=>'', '4291'=>'RG 4291 - WSFE sin detalle','2094'=>'RG 2904 - WSFE con detalle','2758'=>'RG 2758 - WSFE exportaci&oacute;n'), $vew_data->argposregcod, $lv_default) )); 
                  ?>
                </div>
              </div>
						</div>
					</div>
				</div> <!-- fin _tab001 -->
			</div> <!-- tabcontent -->
    </div> <!-- container-fluid -->
  </form><!-- Form Submit -->
  
  <script>		
    // slspostxt
    var lo_get = {"fldsec":"<?=$lv_sec;?>", "fldasg": {"slsposcod":"slsposcod", "slsposcodext":"slsposcodext", "slspostxt":"slspostxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #slspostxt"), "slspos", lo_get);
    
    // sysdocclstxt
    var lo_get = {"fldsec":"<?=$lv_sec;?>", "fldasg": {"sysdocclstxt":"sysdocclstxt", "sysdocclscod":"sysdocclscod"}/*, "fldflt": {"fldflt":"[objtyp(in)STK_SOU;STK_SIN;SLS_INV;SLS_DEB;SLS_CRE]"}*/};
    tmssTypeahead($("#<?= $lv_sec; ?> #sysdocclstxt"), "sysdoccls", lo_get);

		// argltrcod
    var lo_get = {"fldsec":"<?=$lv_sec;?>", "fldasg": {"argltrcod":"argltrcodext", "argltrcodext":"argltrcodext"}, "typeahead":true};
    tmssTypeahead($("#<?= $lv_sec; ?> #argltrcodext"), "finlocargltr", lo_get);

		// docrngcod
    var lo_get = {"fldsec":"<?=$lv_sec;?>", "fldasg": {"docrngcod":"docrngcod"}, "typeahead":false};
    tmssTypeahead($("#<?= $lv_sec; ?> #docrngcod"), "grldatdocrng", lo_get);
    
    $(document).ready(function() {
      // evento al cambiar el select
      $('#<?= $lv_sec ?> #argpostyp').on('change', function() {
        const lv_hidbol = $(this).val() === 'M';

        $('#<?= $lv_sec ?> #docrngcod').closest('#<?= $lv_sec ?> .form-group.tmss-form-group').toggleClass('hidden', lv_hidbol);
				
        if (lv_hidbol) {
          $('#<?= $lv_sec ?> #docrngcod').val('0');
        } else {
          $('#<?= $lv_sec ?> #docrngcod').val('<?= $vew_data->docrngcod ?>');
        }
      });
      // ejecutar al cargar
      $('#<?= $lv_sec ?> #argpostyp').trigger('change');
    });

    
	</script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
<?php	
	// url del formulario 
  $lv_lnk = '?prg=admbus&prm_buscod='.$vew_data->buscod;

	// campos requeridos 
	$vew_input->RequiredFields( array('bustxt','docsts','lndcod','curcod') );

	// clave del documento 
	$lv_dockey = $vew_data->buscod; 

	// titulo 
	$lv_title = $vew_lang->business;
	
	// módulo y programa 
	$lv_mdlcod = 'ADM';
	$lv_prgcod = 'BUS';
	
	// librería de estilos
  include_once('_library.frm');
	$lv_optedt = ($vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02')?'02':'03');
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('objtypcod','hidden',$vew_objtyp); ?>
    
    <div class="container-fluid" role="tabpanel">
      <!-- Solapas -->
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->finance; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab004" role="tab" data-toggle="tab"><?= $vew_lang->settings; ?></a></li>
        <li class="pull-right"><h4># <strong><?= $vew_data->buscod; ?><input type="hidden" id="buscod" name="buscod" value="<?= $vew_data->buscod; ?>"></strong></h4></li>
      </ul>
			<div class="tab-content tmss-tab-content">
			
        <!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
			
          <div class="row">
						<div class="<?= ($vew_data->buscod==''?'col-md-12':'col-md-10'); ?>">
              <div class="row">
                <div class="col-md-6">
                  <!-- EMPRESA -->
                  <div class="card">
                  	<div class="card-header"><div class="card-title"><?= $vew_lang->company; ?></div></div>
                    <div class="card-body tmss-card-body-edit">
                    	<?php
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->code,				'input'=>gethtml('buscodext','doccmt1x20', $vew_data->buscodext, $lv_default) )); 
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->description,'input'=>gethtml('bustxt', 'bustxt', $vew_data->bustxt, $lv_default) )); 
                      	echo vew_boot($lv_col210, array('label'=>$vew_lang->status,			'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                      ?>
                    </div>
                  </div> <!-- card -->
                </div> <!-- col-md-6 -->
								<div class="col-md-6">
									<div class="card">
										<div class="card-header"><div class="card-title">Logo</div></div>
										<div class="card-body tmss-card-body-edit"><?php include('grldatuplshwpth.frm'); ?></div> 
									</div>
								</div>
              </div> <!-- row -->                 

              <!-- CONTACTO / DIRECCION -->
              <div class="row">
                <div class="col-md-6"><?php include('grldatadr.frm'); ?></div>
                <div class="col-md-6"><?php include('grldatadrcnt.frm'); ?></div>
              </div>                         
						</div> <!-- col-md-10 -->
                   
            <div class="col-md-2">
							<div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->operations; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <a href="#" id="btnasg" class="tmssAlwaysEnabled card-opt-body" ><i class="far fa-user-shield"></i> <?= $vew_lang->directive; ?></a>
                </div> 
              </div> <!-- card -->
            </div> <!-- col -->
               
          </div> <!-- row -->
        </div> <!-- GENERAL -->
        
        <!-- IMPUESTOS / BANCOS -->
        <div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
        	<div class="row">
          	<div class="col-md-6"><?php include('grldattax.frm'); ?></div>
            <div class="col-md-6"><?php include('grldatbnk.frm'); ?></div>
          </div>
        </div>         

        <!-- CONFIGURACION -->
        <div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab004">
        	<div class="row">
						<div class="col-md-6">
              
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->company; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->language, 'input'=>gethtml('lngcod', 'lngcod', $vew_data->lngcod, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->currency, 'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                                                    array('input'=>gethtml('curcod', 'curcod', $vew_data->curcod, $lv_always_disabled) )) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->organizationchart, 'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                                                  	array('input'=>gethtml('hhrorgchttxt', 'typeahead', $vew_data->hhrorgchttxt, $lv_default) )) ));
                		echo gethtml('hhrorgchtcod','hidden',$vew_data->hhrorgchtcod);
                  ?>
                </div>
              </div>
              
            </div>
            <div class="col-md-6">
              
            </div>
          
          </div>
        </div>
        
			</div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
  </form>
	<script>
    // typeahead. moneda
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"curcod":"curcod"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #curcod"), "admcur", lo_get)
    
		// typeahead. organigrama
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"hhrorgchttxt":"hhrorgchttxt","hhrorgchtcod":"hhrorgchtcod"}, "extraprm":{"altbuscod":"<?=$vew_data->buscod; ?>"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #hhrorgchttxt"), "hhrorgcht", lo_get)

		// A S I G N A C I Ó N   D E   G R U P O S   D E   D I R E C T I V A S
    $("#<?= $lv_sec; ?> #btnasg").on("click", function(e) { e.preventDefault();
			var lv_pstdat = [	{name:"srcobjcod001", value: $("#<?= $lv_sec; ?> #buscod").prop("value")},
                      	{name:"srcobjtyp", value: $("#<?= $lv_sec; ?> #objtypcod").prop("value")}];
			tmssCallProcess("?prg=syssecdrtgrpasg&act=<?= $lv_optedt; ?>", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->directive; ?>",
					message: $(data),
					draggable: true,
					size: BootstrapDialog.SIZE_WIDE
					<?php if($lv_optedt=='02'){ ?>
					,buttons:[{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); }},
										{	label: "<?= $vew_lang->save; ?>", cssClass: "btn-success",	action: function(dialogItself){ $(dialogItself.$modalBody).find("#btnsubmit").trigger("click"); }}]
					<?php } ?>					
				});
			});
		});  
	</script>
  <script>		
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			// al grabar
			if ( lp_prm["action"]=="00" ) {					
				if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adreml")) ) { return false; }
				if ( !tmssFieldValidation($("#<?= $lv_sec; ?> #adrwebpge")) ) { return false; }
				
				// valido nro de CBU
				var lo_cbu = $("#<?= $lv_sec; ?> #bnkacccbu");
				if ( $(lo_cbu).prop("value").length > 0 && $(lo_cbu).prop("value").length!=22 ) {
					$(lo_cbu).parentsUntil(".tmss-form-group").parent().addClass("has-error");
					toastr.options.timeOut= 2000;
					toastr.warning( "El nro de CBU debe tener 22 dígitos." );
					return false;						
				} else {
					$(lo_cbu).parentsUntil(".tmss-form-group").parent().removeClass("has-error");
				}
			}		
		}	
	</script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
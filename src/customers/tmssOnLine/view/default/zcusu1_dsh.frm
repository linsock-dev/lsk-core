<?php
	// url del formulario
  $lv_lnk = '?prg=zcusu1_sup&act=dsh';

	// campos requeridos
	$vew_input->RequiredFields( array('cnstsktyp', 'docdte', 'custxt') );

	// clave del documento
	$lv_dockey = "";

	// titulo
	$lv_title = $vew_lang->dashboard;

	// modulo y programa
	$lv_mdlcod = '';
	$lv_prgcod = '';

	$vew_actcod = '02';

	// librer?a de estilos bootstrap
	include_once('_library.frm');

	$vew_tbl['canc']=array('per'=>false);
	$vew_tbl['sveL']=array('per'=>false);
	$vew_tbl['sveR']=array('per'=>false);
  $vew_tbl_int['clsR'] = array('per'=>false);
  $vew_tbl_int['rfrsh'] = array('pos'=>'D','per'=>true, 'ttl'=>$vew_lang->update, 'id'=>'','icn'=>'fas fa-syncalt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'sup'.chr(39).'});' );
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	<?php include('grldocfrmtlb.frm'); ?>
	
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm" action="">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <div class="container-fluid">
      <div class="row">
        <div class="col-md-6">
				
          <div class="card">
            <div class="card-header">
              <div class="card-title">Supply South
                <a href="#" class="card-icon" id="printbtn" title="<?= $vew_lang->download; ?>"><i class="fas fa-download "></i></a>
              </div>
            </div>
            <div class="card-body">
              <form id='<?= $lv_sec; ?>_dayprt' method='POST' class='form-horizontal tmss-form-horizontal' target='_blank' action='?prg=zcusu1_sup&act=cnsdayprt'>
                <input type='hidden' id='tmss_actcod' name='tmss_actcod' value=''>
                <?php
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->type,
																									'input1'=>gethtml('cnstsktyp',array(''=>'','aceras'=>'REPARACION DE ACERAS','inspeccion'=>'INSPECCION DE SEGURIDAD','edenor'=>'PARTE EDENOR'),'',$lv_default,true)));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('docdte', 'docdte', date('d/m/Y'), $lv_default) ));
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->customer,
																									'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly),
																																			array('input'=>gethtml('custxt', 'typeahead', '', $lv_default) )) ));
                  echo gethtml('cuscod','hidden','');
                  echo vew_boot($lv_col210, array('label'=>$vew_lang->unit,
																									'input1'=>vew_boot( array('style'=>'search', 'readonly'=>$vew_readonly),
																																			array('input'=>gethtml('untcustxt', 'typeahead', '', $lv_default) )) ));
									echo gethtml('cuscod','hidden','');
									echo gethtml('untcuscod','hidden','');
									echo gethtml('cnstsktyp','hidden','edenor');
                ?>
              </form>
            </div>
          </div>
					
        </div><!-- /col -->
   		</div><!-- /row -->
		</div><!-- /container-fluid -->
	</form>	
  <script>
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"cuscod" : "cuscod", "custxt" : "custxt"}}; 
  	tmssTypeahead($("#<?= $lv_sec; ?> #custxt"), "slscus", lo_get);
		
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt":{ "c.cntsrctyp":"SLS_CUS", "c.cntsrccod": $("#<?= $lv_sec; ?> #cuscod")}, "fldasg" : {"untcuscod" : "cntcod", "untcustxt" : "cnttxt"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #untcustxt"), "grldatcnt", lo_get);
    
    $(function(){
      $("#<?= $lv_sec; ?> #untcustxt").parent().parent().parent().addClass('hidden');
    });
    $("#cnstsktyp").change(function(){
      if($("#<?= $lv_sec; ?> #cnstsktyp").val() == 'edenor'){
				$("#<?= $lv_sec; ?> #untcustxt").parent().parent().parent().removeClass('hidden');
				$("#<?= $lv_sec; ?> #untcustxt").parent().parent().parent().addClass('tmssInputRequired');
      } else {
        $(function(){
          $("#<?= $lv_sec; ?> #untcustxt").parent().parent().parent().addClass('hidden');
        });
      }
    });
    
    $("#<?= $lv_sec; ?> #printbtn").on("click", function(e){ e.preventDefault();
			var lv_pstdat =[{name:"cnstsktyp", value: $("#<?= $lv_sec; ?> #cnstsktyp").val()},
											{name:"docdte", value: $("#<?= $lv_sec; ?> #docdte").val()},
											{name:"cuscod", value: $("#<?= $lv_sec; ?> #cuscod").val()},
											{name:"untcuscod", value: $("#<?= $lv_sec; ?> #untcuscod").val()}];
			tmssCallProcessBlob("?prg=zcusu1_sup&act=cnsdayprt", lv_pstdat, function(data){
				if(data.type=="application/json"){
					data.text().then(function(result) {
						var lv_err = JSON.parse(result);
						toastr.warning("No se puede descargar el archivo.<br>"+lv_err.errcod+": "+lv_err.errtxt);
					});
				} else {
					// Crear una URL para el Blob y lo abre en una nueva pestaña
					var url = window.URL.createObjectURL(data);
					window.open(url, "_blank");
				}
			});
    });
  </script>
<?php include('grldocfrmscr.frm'); ?>
</section>
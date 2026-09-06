<?php
	// url del formulario 
  $lv_lnk = '?prg=zcuclh&prm_evlcod='.$vew_data->evlcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('patcod','pattxt','prscod','prstxt','spccod','spctxt','docsts','plnid','plndteid','evlgetsmpprc') );

	// clave del documento 
	$lv_dockey = $vew_data->evlcod;

	// titulo 
	$lv_title = $vew_lang->document;

	// modulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod ='EVL';

	$vew_actcod = ($vew_data->evlcod!=''?'03':'02');

	

	$lv_fldmodeinf = array( ''=>''
												,'1'=>'ExtracciOn de sangre'
												,'2'=>'Hisopado'
												,'3'=>'Orina'
												,'4'=>'Centocard'
												,'5'=>'Papel filtro'
												,'6'=>'Otras');

	// valores x default 
	$lv_buf ='';
 	if ($vew_data->evlcod=='') {
		$vew_data->evlgetsmpprc = '';
	}else{
		$vew_data->evlatrval001 = strtoupper($vew_data->evlatrval001);
	 	$lv_buf = $vew_doc->getTagValue($vew_data->evlatr001,'row');
	 	$vew_data->evlgetsmpprc= strtoupper($vew_doc->getTagValue($lv_buf,'evlgetsmpprc'));
	 	$vew_data->evlgetsmpprc = strtoupper($vew_doc->getTagValue($lv_buf,'evlgetsmpprc'));	 	
	 	if ($vew_data->evlgetsmpprc ==''){
	 		if ($vew_data->docsts=='A') {
				$vew_data->evlgetsmpprc = '1';
			}	else{
	 			$vew_data->evlgetsmpprc = '0';
	 		}
	 	}
	 	
	 	//$vew_data->evlcncmtv = strtoupper($vew_doc->getTagValue($lv_buf,'evlcncmtv'));
	 	$vew_data->evlmtv=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlmtv')));
	 	$vew_data->evlgethhs=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlgethhs')));
	 	$vew_data->evlgedte=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlgedte')));
	 	$vew_data->evlgetsmp=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlgetsmp')));

	 	$vew_data->evlcnccmt=utf8_decode($vew_data->evlsub);
	 	$vew_data->evlevl = strtoupper($vew_data->evlevl);
	 	$vew_data->evlcnccmt=utf8_decode($vew_data->evlsub);
	 	$vew_data->evlevl = strtoupper($vew_data->evlevl);

	}
	
	$vew_data->evlevl=strtoupper(utf8_decode($vew_data->evlevl));

// librería de estilos bootstrap 
include_once('_library.frm');
// Configuracion de botones 
// Configuracion de botones 
$vew_tbl['clsL'] = array('pos'=>'L','per'=>($vew_data->hhcc=='X'), 'ttl'=>$vew_lang->close, 'id'=>'btncls','icn'=>'fas fa-arrow-left', 'css'=>'btn navbar-btn tmss-navbar-btn arrow-left', 'acc'=>$lv_sec.'_fncbckext();');
//$vew_tbl['clsL'] = array('pos'=>'L','per'=>true, 'ttl'=>$vew_lang->close, 'id'=>'btncls','icn'=>'fas fa-arrow-left', 'css'=>'btn navbar-btn tmss-navbar-btn arrow-left', 'acc'=>'tmssTabSecCls($('.chr(39).'#'.$lv_sec.chr(39).'));');
$vew_tbl['prnR'] =array('per'=>$vew_sec->hasPermission('HLT','EVL','05') && $vew_data->docsts=='A','id'=>'btnprn');
$vew_tbl['sveL'] =array('per'=>!$vew_readonly,'acc'=>$lv_sec.'_fncext({action: '.chr(39).'zcuclh_frmact05_00'.chr(39).'});'); 
$vew_tbl['sveR'] =array('per'=>!$vew_readonly,'acc'=>$lv_sec.'_fncext({action: '.chr(39).'zcuclh_frmact05_00'.chr(39).'});'); 
$vew_tbl['del']  =array('per'=>$vew_sec->hasPermission('HLT','EVL','04') && $vew_data->evlcod!='','acc'=>$lv_sec.'_fncext({action: '.chr(39).'zcuclh_frmact05_x4'.chr(39).'});');
?>
<section id="<?php echo $lv_sec; ?>" data-title="<?php echo $lv_title; ?>">
  <?php include('zcutp_docfrmtlb.frm'); ?>
	<div class="container-fluid">	
  <form method="POST" class="form-horizontal" id="<?php echo $lv_sec; ?>_frm" style="padding-top: 0px;">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
    
    <input type="hidden" id="spccod" name="spccod" value="<?=$vew_data->spccod;?>">
    <input type="hidden" id="spccod" name="spccod" value="<?=$vew_data->spccod;?>">
    <input type="hidden" id="patcod" name="patcod" value="<?=$vew_data->patcod;?>">
    <input type="hidden" id="prscod" name="prscod" value="<?=$vew_data->prscod;?>">
    <input type="hidden" id="plnid" name="plnid" value="<?=$vew_data->plnid;?>">
    <input type="hidden" id="plndteid" name="plndteid" value="<?=$vew_data->plndteid;?>">
    
    <input type="hidden" id="evlcod" name="evlcod" value="<?=$vew_data->evlcod;?>">
		<div class="row">
			<div class="col-md-12">
				<div class="container-fluid" role="tabpanel">
					<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
            <li role="presentation" class="active"><a href="#<?php echo $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?=$vew_lang->general; ?></a></li>
            <li class="pull-right"><h4># <strong><?=$vew_data->evlcod;?></strong></h4></li>
          </ul>
					<div class="tab-content tmss-tab-content">
						<!-- GENERAL -->
						<div role="tabpanel" class="tab-pane active" id="<?php echo $lv_sec; ?>_tab001">
              <div class="row">
                <div class="card">
                  <div class="card-header">
                    <div class="card-title">
                      Datos de evolucion
                    </div>
                  </div><!-- /Card header -->
                  <div class="card-body tmss-card-body-edit">
                     <?php
                    		echo vew_boot($lv_col210,array('label'=>$vew_lang->date, 'input'=>gethtml('evlgedte','docdte',$vew_data->evldte,$lv_default) ));
                        echo vew_boot($lv_col210,array('label'=>'Se realiz&oacute;?', 'input'=>gethtml('evlgetsmpprc','yesno',$vew_data->evlgetsmpprc,$lv_default) ));
                      ?>
                      <div id="evlnoinf_div">
                        <?php
                          echo vew_boot($lv_col210,array('label'=>'Motivo', 'input'=>gethtml('evlmtv','doccmt5x50',$vew_data->evlmtv,$lv_default) ));
                        ?>
                      </div>
                      <div id="evlyesinf_div">
                        <?php
                          
                          echo vew_boot($lv_col210,array('label'=>'Hora', 'input'=>gethtml('evlgethhs','doccmt1x50',$vew_data->evlgethhs,$lv_default) ));
                        ?>
                        <div id ="usainfusorgrp" class="form-group">
                          <label class="col-sm-2 control-label" >Tipo de muestra</label>
                          <div class="col-sm-10">
                            <?php
                              echo gethtml('evlgetsmp',$lv_fldmodeinf,$vew_data->evlgetsmp,$lv_default);
                            ?></div>
                        </div>
                        <?php
                          echo vew_boot($lv_col210,array('label'=>'Comentarios', 'input'=>gethtml('evlevl','doccmt5x50',$vew_data->evlevl,$lv_default) ));
                        ?>
                        <br>

                      </div>
                  </div> <!-- /Card Boby -->
                </div><!-- /Card -->
              </div>
              
              
              
						</div> <!-- /tabpanel -->

					</div> <!-- tabcontent -->
				</div> <!-- container-fluid -->
			</div> <!-- col-sm-9 -->
		</div> <!-- row -->
  </form>
	</div>
  <script>
  $("#<?php echo $lv_sec; ?> #evlgetsmpprc").on("change",function(e){
    if ( $(this).prop("value")=="1" ) {
      $("#<?php echo $lv_sec; ?> #evlnoinf_div").addClass("hidden");
      $("#<?php echo $lv_sec; ?> #evlyesinf_div").removeClass("hidden");
    } else if ( $(this).prop("value")=="0") {
      $("#<?php echo $lv_sec; ?> #evlnoinf_div").removeClass("hidden");
      $("#<?php echo $lv_sec; ?> #evlyesinf_div").addClass("hidden");
    } else {
      $("#<?php echo $lv_sec; ?> #evlnoinf_div").addClass("hidden");
      $("#<?php echo $lv_sec; ?> #evlyesinf_div").addClass("hidden");
    }
  })
  </script>
	<script>
		$(function(e){
			$("#<?php echo $lv_sec; ?> #evlgetsmpprc").trigger("change");
			<?php
				$lv_plnpen='';
				foreach( $vew_rsplndte as $lv_row ) { $lv_plnpen .= $lv_row['plndte']->format('d/m/Y').'<br>'; }
				if($lv_plnpen!=''){ echo 'toastr.warning("El paciente <b>'.$vew_data->pattxt.'</b> tiene pendiente de evolucionar las siguientes fechas:<br>'.$lv_plnpen.'","ATENCION!");'; }
			?>
		});
		


		<?php if ($vew_sec->hasPermission('HLT','EVL','05') && $vew_data->evlcod!='') { ?>
			// IMPRIMIR
			$("#<?php echo $lv_sec; ?> #btnprn").on("click",function(e){
				window.open("?prg=zcutp1&act=zcuclh_frmact05_00prn&prm_evlcod="+<?php echo $vew_data->evlcod; ?>);
			});
		<?php } ?>
    
	</script>
  <script>
  function <?= $lv_sec; ?>_fncbckext(lp_prm){
    // cierra el dialogo actual
    $.each(BootstrapDialog.dialogs, function(id, dialog){
      if(dialog.getModalBody().find("section:first").prop("id")=="<?= $lv_sec; ?>"){
        dialog.close(); 
      }
    });
    tmssTabSecCls( $("#<?= $lv_sec; ?>") );
  }
  // form submit
  function <?php echo $lv_sec; ?>_fncext( lp_prm ) {
    if (lp_prm["action"]=="prn") {
      window.print();
    } else {
      if (lp_prm["action"]=="zcuclh_frmact05_x4") {
        var lv_ok = 0;
        BootstrapDialog.confirm({
          title: 'Borrar Evolucion',
          message: '¿Desea borrar el documento ?',
          type: BootstrapDialog.TYPE_WARNING,
          callback: function(result) {
            if(result) { 
            var lo_dat = new FormData();
            var lv_frmarr = $("#<?= $lv_sec; ?>_frm").serializeArray();
            for(var i=0; i<lv_frmarr.length; i++){ lo_dat.append(lv_frmarr[i].name,lv_frmarr[i].value); }
            
            /* Llamada al controlaor */
            tmssCallProcessFile("?prg=zcuclh&act=zcuclh_frmact05_04", lo_dat, <?= $lv_sec; ?>_fncbckext);
            }
          }
        });
        return false;
      }
      if (lp_prm["action"]=="zcuclh_frmact05_00"){
        if(!tmssCheckRequiredFields($("#<?php echo $lv_sec; ?>_frm"))){return false;}
        if ($("#<?php echo $lv_sec; ?> #evlgetsmp").prop("value")=="" && $("#<?php echo $lv_sec; ?> #evlgetsmpprc").prop("value")=="1" ) {
          toastr.warning("Falta completar campo obligatorio Tipo de muestra."); 
          return false; 
        }else{
          var lo_dat = new FormData();
          var lv_frmarr = $("#<?= $lv_sec; ?>_frm").serializeArray();
          for(var i=0; i<lv_frmarr.length; i++){ lo_dat.append(lv_frmarr[i].name,lv_frmarr[i].value); }
          lo_dat.append('evldte',lo_dat.get('evlgedte'))
          lo_dat.append('evlcmt','')
          debugger
          /* Llamada al controlaor */
          tmssCallProcessFile("?prg=zcuclh&act=zcuclh_frmact05_00", lo_dat, <?= $lv_sec; ?>_fncbckext);
          return false;
        }
      }

    }

  }

  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
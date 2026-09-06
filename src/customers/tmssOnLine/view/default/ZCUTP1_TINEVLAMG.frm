<?php	
	// url del formulario
 	$lv_lnk = '?prg='.($vew_data->endpoint??'').'&prm_evlcod='.$vew_data->evlcod;  
	// campos requeridos 
	$lv_reqflddef = array('fvrpt');  
	$lv_reqfldusrtxt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'sysdocclsreqfld');
	$lv_reqfldusr = ($lv_reqfldusrtxt!=''?explode(';',$lv_reqfldusrtxt):array());
	$vew_input->setReqFields( array_merge($lv_reqflddef,$lv_reqfldusr) );


	$vew_data->evlinfprc = '0';
    
	// clave del documento 
	$lv_dockey = $vew_data->evlcod??''; 

	// titulo 
	$lv_title = $vew_lang->evolution;

	// módulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod ='EVL';
	$vew_actcod =$vew_actcod=='evlamg02'?'02':$vew_actcod;
	$aux= $vew_actcod;
	if($vew_actcod=='evlamg'){
  	$vew_actcod = $vew_data->evlcod!=''?'03':'01';
  }
	// Librería de estilos bootstrap 
  include_once('_library.frm'); 
	$lvDisableOnModify=[];
	if($vew_actcod =='02'){
  	$lvDisableOnModify = $lv_always_disabled;
  }else{
    $lvDisableOnModify=$lv_default;
  }
	
	// valores x default 
	if ($vew_data->evlcod=='') {
		$vew_data->evlinfprc = '';
	}else{
    $lv_evlatrval001=strtoupper($vew_data->evlatr001);
	 	$lv_buf = $vew_doc->getTagValue($lv_evlatrval001,'row');
	 	$vew_data->evlinfprc = strtoupper($vew_doc->getTagValue($lv_buf,'evlinfprc'));

	 	$vew_data->evlcncmtv = $vew_doc->getTagValue($lv_buf,'evlcncmtv');
    
    $vew_data->fvrpt = strtoupper($vew_doc->getTagValue($lv_buf,'fvrpt'));   
    $vew_data->frm = strtoupper($vew_doc->getTagValue($lv_buf,'dvcfrm'));
    $vew_data->evllon=strtoupper($vew_doc->getTagValue($lv_buf,'evllon'));
    $vew_data->evllat=strtoupper($vew_doc->getTagValue($lv_buf,'evllat'));
    $vew_data->evlcnccmt=strtoupper($vew_doc->getTagValue($lv_buf,'evlcnccmt'));
    $vew_data->patwgt=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'patwgt')));
    $vew_data->matdos=strtoupper($vew_doc->getTagValue($lv_buf,'matdos'));
    $vew_data->matuntcod=strtoupper($vew_doc->getTagValue($lv_buf,'matuntcod'));
	}
	$lv_icofrm= '';

	$lv_icofrm= $vew_data->frm==''?'fa-desktop':'fa-mobile-alt';
  
	// Configuracion de botones
  $vew_tbl['clsL'] = array('pos'=>'L','per'=>($vew_data->hhcc=='X'), 'ttl'=>$vew_lang->close, 'id'=>'btncls','icn'=>'fas fa-arrow-left', 'css'=>'btn navbar-btn tmss-navbar-btn arrow-left', 'acc'=>$lv_sec.'_fncbckext();');
  //$vew_tbl['clsL'] = array('pos'=>'L','per'=>true, 'ttl'=>$vew_lang->close, 'id'=>'btncls','icn'=>'fas fa-arrow-left', 'css'=>'btn navbar-btn tmss-navbar-btn arrow-left', 'acc'=>'tmssTabSecCls($('.chr(39).'#'.$lv_sec.chr(39).'));');

  $vew_tbl['prnR'] =array('per'=>false);
	//$vew_tbl['canc'] = array('pos'=>'L','per'=>true, 'ttl'=>$vew_lang->cancel, 'id'=>'','icn'=>'fas fa-times', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-danger tmss-desk-btn', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'98'.chr(39).'});' );
  $vew_tbl['sveL'] =array('per'=>!$vew_readonly,'acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlamg00'.chr(39).'});'); 
  $vew_tbl['sveR'] =array('per'=>!$vew_readonly,'acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlamg00'.chr(39).'});');
	//$vew_tbl['modL'] = array('pos'=>'L','per'=>($vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02') && $vew_actcod =='03' && $vew_data->evlinfprc =='1'), 'ttl'=>$vew_lang->modify, 'id'=>'','icn'=>'fas fa-pencil-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlamg02'.chr(39).'});' );
  $vew_tbl['del']  =array('per'=>$vew_sec->hasPermission('HLT','EVL','04') && $vew_data->evlcod!='','acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlamgX4'.chr(39).'});');
  
?>
<section id="<?php echo $lv_sec; ?>" data-title="<?php echo $lv_title; ?>">
  <?php include('zcutp_docfrmtlb.frm'); ?>


  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?php echo $lv_sec; ?>_frm" enctype="multipart/form-data">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
		<input type="hidden" id="sysdocclscod" name="sysdocclscod" value="<?= $vew_data->sysdoccls->sysdocclscod; ?>">
    <input type="hidden" id="spccod" name="spccod" value="<?= $vew_data->spccod; ?>">
    <input type="hidden" id="spctxt" name="spctxt" value="<?= $vew_data->spctxt; ?>">
    <input type="hidden" id="patcod" name="patcod" value="<?= $vew_data->patcod; ?>">
    <input type="hidden" id="prscod" name="prscod" value="<?= $vew_data->prscod; ?>">
    <input type="hidden" id="prstxt" name="prstxt" value="<?= $vew_data->prstxt; ?>">
    <input type="hidden" id="plnid" name="plnid" value="<?= $vew_data->plnid; ?>">
    <input type="hidden" id="plndteid" name="plndteid" value="<?= $vew_data->plndteid; ?>">
    <input type="hidden" id="evlcmt" name="evlcmt" value="<?= $vew_data->evlcmt; ?>">
    <input type="hidden" id="evlcod" name="evlcod" value="<?= $vew_data->evlcod; ?>">
    <input type="hidden" id="evlmatdel" name="evlmatdel" value="">
    
    <input type="hidden" id="flesrctyp" name="flesrctyp" value="<?= 'HLT_EVL'; ?>">
    <input type="hidden" id="patchgdte" name="patchgdte" value="<?= $vew_data->patchgdte; ?>">
    <div class="container-fluid" role="tabpanel">
      <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
        <li role="presentation" class="active"><a href="#<?php echo $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?=$vew_lang->general; ?></a></li>
        <li class="pull-right"><h4># <strong><?=$vew_data->evlcod;?></strong></h4></li>
      </ul>
      <div class="tab-content tmss-tab-content">
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
                	echo vew_boot($lv_col210,array('label'=>$vew_lang->date, 'input'=>gethtml('evldte','docdte',$vew_data->evldte,$lvDisableOnModify) ));
                	if($vew_actcod == '01' ){
                  	echo vew_boot(array($lv_colsm210, $lv_colxs48),array('label'=>'Se retira equipo?', 'input'=>gethtml('evlinfprc','checkbox',$vew_data->evlinfprc,$lv_default) ));
                  }
                ?>
                <?php
                if($vew_actcod != '01'){
                ?>
                <div class="form-group tmss-form-group ">
                  <input type="hidden" id="evlinfprc" name="evlinfprc" value="<?= $vew_data->evlinfprc; ?>">
                  <label class=" col-sm-2 col-xs-4 control-label text-nowrap">Se retira equipo ?</label>
                  <div class=" col-sm-10 col-xs-8">
                    <?=($vew_data->evlinfprc=='1'?'<h3 style="align-content: center;font-size: 16px;width: 50px;height: 30px;border-radius: 7px;text-align: center;color:#ffffff;background-color:#5dba3d;margin-top: 5px;">Si</h3>':'<h3 style="align-content: center;font-size: 16px;width: 50px;height: 30px;border-radius: 7px;text-align: center;color:#ffffff;background-color: #21A2F2;margin-top: 5px;">No</h3>')?>
                	</div>
                </div>
                <?php }?>
                                     
              </div> <!-- /Card Boby -->
            </div><!-- /Card -->
            <div class="card" id="evlnoinf_div">
              <div class="card-body tmss-card-body-edit">
                 <?php
                    echo vew_boot($lv_col210,array('label'=>$vew_lang->comments, 'input'=>gethtml('evlsub','doccmt5x50',$vew_data->evlsub,$lv_default) ));              
                  ?>                
              </div>              
            </div>             
          </div><!-- /Row -->
         
        </div> <!-- /_tab001 -->
      </div> <!-- /tab-content --> 
    </div> <!-- /container-fluid -->

  </form>
  <script>
  	tmssLoadScript("toggle",function(){
			$("#<?php echo $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: "success", offstyle: "default", on: "Si", off: "No", size: "small" });
        <?php 
        if($vew_actcod =='03' || $vew_actcod =='02'){
        ?>
        $(this).bootstrapToggle('disable')
        <?php
				}
        ?>
				$(this).trigger("change");
			});
		});
  </script>	
    <script>
    $(function(e){
      $("#<?php echo $lv_sec; ?> #evlinfprc").trigger("change");

      <?php
        $lv_plnpen='';
        foreach( $vew_rsplndte as $lv_row ) { $lv_plnpen .= $lv_row['plndte']->format('d/m/Y').'<br>'; }
        if($lv_plnpen!=''){ echo 'toastr.warning("El paciente <b>'.$vew_data->pattxt.'</b> tiene pendiente de evolucionar las siguientes fechas:<br>'.$lv_plnpen.'","ATENCION!");'; }
      ?>
    });

    $("#<?php echo $lv_sec; ?> :checkbox[id='evlinfprc']").on("change",function(e){
        if ($(this).is(":checked")) {
          $("#<?php echo $lv_sec; ?> #evlnoinf_div").removeClass("hidden");
        }else {
          $("#<?php echo $lv_sec; ?> #evlnoinf_div").addClass("hidden");
        }
    });
  </script>
  <script>
    function <?= $lv_sec; ?>_fncbckext(lp_prm){
      lp_prm = lp_prm || {errtyp:'', errcod:0, errtxt:''};
      if(lp_prm['errtyp']=='E' && lp_prm['errtxt']!='' ){
          toastr.warning(lp_prm['errtxt']); 
          return false;
        }
      
      if(gv_<?php echo $lv_sec; ?>_last_action=="evlamg00"){
        
        if(lp_prm['errtyp']=='E'){
          toastr.warning(lp_prm['errtxt']); 
          return false;
        }
        
      }
      if ( gv_<?php echo $lv_sec; ?>_last_action=="evlamg04") {
        //toastr.warning(lp_prm['errtxt']); 
        if(lp_prm['errtyp']=='E'){
          toastr.warning(lp_prm['errtxt']); 
          return false;
        }
        
      }
      if ( gv_<?php echo $lv_sec; ?>_last_action=="evlamg02") {
        $("#<?= $lv_sec; ?>").replaceWith( lp_prm );
        return false
      }
      //se agrega funcion para mostrar toastr en caso de error
      //tmssBackMessageProcessing( lp_prm, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?=$vew_data->matcod; ?></b>" ); 
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
				if (lp_prm["action"]=="evlamgX4") {
					BootstrapDialog.confirm({
						title: 'Borrar Evolucion',
						message: '¿Desea borrar el documento?',
						type: BootstrapDialog.TYPE_WARNING,
						callback: function(result) {
							if(result) { <?php echo $lv_sec; ?>_fnc({action: "evlamg04"}); }
						}
					});
					return false;
				}
        
				if (lp_prm["action"]=="evlamg00" ) {
          if ($("#<?php echo $lv_sec; ?> #evlinfprc").prop("value")=="1"){
            var lv_err = 0;
            var lo_trid = $("#<?= $lv_sec; ?> #tbldat tr[name='dlvrow']").length;
            var lo_datarr = $("#<?= $lv_sec; ?> #tbldat tr[name='dlvrow']");
            var lv_arr = new Array();
            var lv_evlcnccmt = $("#<?=$lv_sec; ?> #evlsub").val();
            var lo_dat = new FormData();
            var lv_frmarr = $("#<?= $lv_sec; ?>_frm").serializeArray();
            for(var i=0; i<lv_frmarr.length; i++){ lo_dat.append(lv_frmarr[i].name,lv_frmarr[i].value); }
            
            // VALIDO DOSIS
            $("#<?=$lv_sec; ?> #evlsub").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if (lv_evlcnccmt=="") {
              //toastr.warning( "Complete el campo Evolucion" ); 
              $("#<?=$lv_sec; ?> #evlsub").parentsUntil(".tmss-form-group").parent().addClass("has-error");
              lv_err++;
						}
            if(lv_err>0){
              toastr.warning( "Complete los campos obligatorios.<br>Incompletos ("+lv_err+")." );
              return false; 
            }
            
            if(!tmssFormValidation($("#<?php echo $lv_sec; ?>_frm"))){return false;}
             /* Llamada al controlaor */
            //tmssCallProcessFile("?prg=zcutp1_ttr&act=evlamg00", lo_dat, <?= $lv_sec; ?>_fncbckext);
            tmssCallProcessFile("?prg=<?= $vew_data->endpoint; ?>&act=evlamg00", lo_dat, <?= $lv_sec; ?>_fncbckext);
            //toastr.warning( "Guardar evolucion" ); 
            return true
            // update file data
          }else{
            if(!tmssCheckRequiredFields($("#<?php echo $lv_sec; ?>_frm"))){return false;}
            //toastr.warning( "Guardar evolucion" ); 
            return true
          }
				}
			}
		}
  </script>
 
  <?php include('grldocfrmscr.frm'); ?>
</section>
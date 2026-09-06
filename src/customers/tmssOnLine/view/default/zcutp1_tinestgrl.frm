<?php	
	// url del formulario 
  $lv_lnk = '?prg=zcutp1_tin&prm_evlcod='.$vew_data->evlcod;

	// campos requeridos 
	//$lv_reqflddef = array('evlcncmtv','evlcnccmt');
	//$lv_reqflddef = array('evlcncmtv','evlcnccmt','reqcc','dtesrv','evlmd','ath','patprsrlscod','patprsrlstxt');
		$lv_reqflddef = array('evlcncmtv','evlcnccmt','dtesrv','evlmd','ath','reqcc'); // si no se realizo son estos
    if ($vew_data->evlinfprc == '1') {
      // Segmento por si se realizo
      $lv_reqflddef = array_merge($lv_reqflddef, array('reqcc','dtesrv','evlmd','ath','patprsrlscod','patprsrlstxt'));
    }

	$lv_reqfldusrtxt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'sysdocclsreqfld');
	$lv_reqfldusr = ($lv_reqfldusrtxt!=''?explode(';',$lv_reqfldusrtxt):array());
	$vew_input->setReqFields( array_merge($lv_reqflddef,$lv_reqfldusr) );

	// clave del documento 
	$lv_dockey = $vew_data->evlcod; 

	// titulo 
	$lv_title = $vew_lang->evolution;

	// módulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod ='EVL';

	$vew_actcod = ($vew_data->evlcod!=''?'03':'02');
	// Librería de estilos bootstrap 
  include_once('_library.frm');


	// valores x default 
	if ($vew_data->evlcod=='') {
		$vew_data->evlinfprc = '';
	}else{
    $lv_evlatrval001=strtoupper($vew_data->evlatr001);
	 	$lv_buf = $vew_doc->getTagValue($lv_evlatrval001,'row');
	 	$vew_data->evlinfprc = strtoupper($vew_doc->getTagValue($lv_buf,'evlinfprc'));
    
	 	if ($vew_data->evlinfprc ==''){ 
	 		if ($vew_data->docsts=='A') {
				$vew_data->evlinfprc = '1';
			}	else{
	 			$vew_data->evlinfprc = '0';
	 		}
	 	}
    
	 	$vew_data->evlcncmtv = utf8_decode($vew_doc->getTagValue($lv_buf,'evlcncmtv'));
	 	$vew_data->evlcnccmt=utf8_decode($vew_data->evlsub);
	 	$vew_data->evlevl = utf8_decode($vew_data->evlevl);
    
    $vew_data->fvrpt = strtoupper($vew_doc->getTagValue($lv_buf,'fvrpt'));   
    $vew_data->frm = strtoupper($vew_doc->getTagValue($lv_buf,'dvcfrm'));
    $vew_data->evllon=strtoupper($vew_doc->getTagValue($lv_buf,'evllon'));
    $vew_data->evllat=strtoupper($vew_doc->getTagValue($lv_buf,'evllat'));
    $vew_data->patwgt=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'patwgt')));
    
    $vew_data->reqcc=strtoupper($vew_doc->getTagValue($lv_buf,'reqcc'));
    $vew_data->dtesrv=strtoupper($vew_doc->getTagValue($lv_buf,'dtesrv'));
    $vew_data->mevlmd=strtoupper($vew_doc->getTagValue($lv_buf,'mevlmd'));
    $vew_data->evlmd=strtoupper($vew_doc->getTagValue($lv_buf,'evlmd'));
    $vew_data->ath=strtoupper($vew_doc->getTagValue($lv_buf,'ath'));
    $vew_data->patprsrlscod=strtoupper($vew_doc->getTagValue($lv_buf,'patprsrlscod'));
    $vew_data->patprsrlstxt=strtoupper($vew_doc->getTagValue($lv_buf,'patprsrlstxt'));
    
	}
	$lv_icofrm= '';

	$lv_icofrm= $vew_data->frm==''?'fa-desktop':'fa-mobile-alt'; 

	// Configuracion de botones 
  $vew_tbl['clsL'] = array('pos'=>'L','per'=>($vew_data->hhcc=='X'), 'ttl'=>$vew_lang->close, 'id'=>'btncls','icn'=>'fas fa-arrow-left', 'css'=>'btn navbar-btn tmss-navbar-btn arrow-left', 'acc'=>$lv_sec.'_fncbckext();');
  //$vew_tbl['clsL'] = array('pos'=>'L','per'=>true, 'ttl'=>$vew_lang->close, 'id'=>'btncls','icn'=>'fas fa-arrow-left', 'css'=>'btn navbar-btn tmss-navbar-btn arrow-left', 'acc'=>'tmssTabSecCls($('.chr(39).'#'.$lv_sec.chr(39).'));');
  $vew_tbl['prnR'] =array('per'=>$vew_sec->hasPermission('HLT','EVL','05') && $vew_data->docsts=='A','id'=>'btnprn');
  $vew_tbl['sveL'] =array('per'=>!$vew_readonly,'acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlest00'.chr(39).'});'); 
  $vew_tbl['sveR'] =array('per'=>!$vew_readonly,'acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlest00'.chr(39).'});'); 
  $vew_tbl['del']  =array('per'=>$vew_sec->hasPermission('HLT','EVL','04') && $vew_data->evlcod!='','acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlestx4'.chr(39).'});');
  if($vew_data->evllon!=''){
    $vew_tbl['goe']  =array('per'=>$vew_readonly,'pos'=>'D', 'ttl'=>'Localizacion', 'id'=>'','icn'=>'fa-solid fa-location-dot', 'css'=>'tmss-Opt', 'acc'=>'window.open('.chr(39).'http://www.google.com/maps/search/?api=1&query='.$vew_data->evllat.','.$vew_data->evllon.chr(39).');' );
  }
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
    <input type="hidden" id="evllat" name="evllat" value="<?= $vew_data->evllat; ?>">
    <input type="hidden" id="evllon" name="evllon" value="<?= $vew_data->evllon; ?>">
    <input type="hidden" id="flesrctyp" name="flesrctyp" value="<?= 'HLT_EVL'; ?>">
    <input type="hidden" id="flesrccod" name="flesrccod" value="">
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
                    echo vew_boot($lv_col39,array('label'=>$vew_lang->date, 'input'=>gethtml('evldte','docdte',$vew_data->evldte,$lv_default) ));
                  	echo vew_boot(array($lv_colsm39, $lv_colxs48),array('label'=>'Se realiz&oacute;', 'input'=>gethtml('evlinfprc','checkbox',$vew_data->evlinfprc,$lv_default) ));
                  ?>                    
              </div> <!-- /Card Boby -->
            </div><!-- /Card -->
            <div class="card">
              <!-- ECG RIESGO QUIRURGICO-->
              <div class="card-body tmss-card-body-edit">
              	<?= vew_boot(array($lv_colsm39, $lv_colxs48),array('label'=>'Inf. Farmacovigilancia?', 'input'=>gethtml('fvrpt','checkbox',$vew_data->fvrpt,$lv_default) ));?>
                <hr/>
                <?= vew_boot($lv_col39,array('label'=>'Solicitud ingresada por CC?',
                                                   'input'=>gethtml('reqcc',array(''=>'','S'=>'SI','N'=>'NO'),
                                	$vew_data->reqcc,$lv_default) ));?>
                <?= vew_boot($lv_col39,array('label'=>'Fecha de solicitud de servicio', 'input'=>gethtml('dtesrv','docdte',$vew_data->dtesrv,$lv_default) ));?>
                <div id="grp_patprsrlstxt">
                    <?
                  // Prestador --------------------------------
                  echo vew_boot($lv_col39, array('label'=>'Medico solicitante del sevicio', 
                                                  'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                      array('input'=>gethtml('patprsrlstxt', 'typeahead', $vew_data->patprsrlstxt,$lv_always_disabled) )) ));
                  echo gethtml('patprsrlscod', 'hidden', $vew_data->patprsrlscod);
                ?>
                  </div>
                <div id="grp_mevlmd">
                <?= vew_boot($lv_col39,array('label'=>'Medico evaluador', 'input'=>gethtml('mevlmd','doccmt1x20',$vew_data->mevlmd,$lv_default) ));?>
                </div>
                <?//= vew_boot($lv_col39,array('label'=>'Medico evaluador', 'input'=>gethtml('evlmd','doccmt1x20',$vew_data->evlmd,$lv_default) ));?>
    
                <!--
                <code>
                	<?=$vew_data->patprsrlscod;?>
                </code>
								-->
                <?= vew_boot($lv_col39,array('label'=>'Quien autoriza', 'input'=>gethtml('ath','doccmt1x20',$vew_data->ath,$lv_default) ));?>
              </div><!-- /Card Boby -->
            </div><!-- /Card -->
            <div class="card" id="evlnoinf_div">
              <div class="card-body tmss-card-body-edit">
                 <?php
                    echo vew_boot($lv_col39,array('label'=>$vew_lang->motive, 
                                                   'input'=>gethtml('evlcncmtv',array(''=>'',
                                                                                      'SV'=>'SIN VIALES',
                                                                                      'EN'=>'ENFERMEDAD',
                                                                                      'ND'=>'PACIENTE NO DISPONIBLE',
                                                                                      'OT'=>'OTROS'),
                                   $vew_data->evlcncmtv,$lv_default) ));

                    echo vew_boot($lv_col39,array('label'=>$vew_lang->comments, 'input'=>gethtml('evlcnccmt','doccmt5x50',$vew_data->evlcnccmt,$lv_default) ));              
                  ?>         
              </div>              
            </div>             
            <div class="card" id="evlyesinf_div">
              <div class="card-header">
                <div class="card-title">Datos de tratamiento
                </div>
              </div><!-- /Card header -->
              <div class="card-body tmss-card-body-edit">
              <?php            
                if( count($vew_data->evlspc)>0){
                  echo '<table id="tbldatspc" class="table">';
                  echo '<thead><tr>';
                  echo '<th scope="col">Signos vitales</th>';
                  echo '</tr></thead>';
                  foreach($vew_data->evlspc as $lo_spcrow){
                    echo '<tr>';
                    echo '<td scope="row">ML/H: <strong>'.$vew_doc->getTagValue($lo_spcrow['evlatrval001'],'ml').'</strong> Peso: <strong>'.$vew_doc->getTagValue($lo_spcrow['evlatrval001'],'p').'</strong> Temperatura: <strong>'.$vew_doc->getTagValue($lo_spcrow['evlatrval001'],'t').'</strong>';
                    echo '<br>Frec. cardiaca: <strong>'.$vew_doc->getTagValue($lo_spcrow['evlatrval001'],'fc').'</strong> Frec. respiratoria: <strong>'.$vew_doc->getTagValue($lo_spcrow['evlatrval001'],'fr').'</strong> Tensi&oacute;n arterial: <strong>'.$vew_doc->getTagValue($lo_spcrow['evlatrval001'],'ta').'</strong></td>';
                    echo '</tr>';
                  }
                  echo '</table>'; 
                }
                
              ?>
                <table id= "tbldat" class="table">
                  <thead>
                    <tr>
                      <th scope="col">Documentos Asociados</th>
                      <th scope="col"></th>
                    </tr>
                  </thead>
                </table>
                <div class ="row">
                  <div class="col-sm-12 tmssHiddeOnRead">
                    <div class="text-center">
                      <div class="btn btn-primary btn-lg" id="btnupload"><i class="fa-solid fa-paperclip fa-2x"></i><br/><span class="small"> <?= $vew_lang->file; ?></span></div>
                    </div>
                      <br/>
                    <div id='tblfle'>
                    </div>
                  </div>
                </div>
                <div class="hidden"><input type="file" id="uplfle" name="uplfle" multiple ></div>
                <?= vew_boot($lv_col39,array('label'=>$vew_lang->evolution, 'input'=>gethtml('evlevl','doccmt5x50',$vew_data->evlevl,$lv_default) ));?>
                  
              </div><!-- /Card Boby -->
            </div><!-- /Card -->           
          </div><!-- /Row -->
         
        </div> <!-- /_tab001 -->
      </div> <!-- /tab-content -->
    </div> <!-- /container-fluid -->
    <div class="tmss-mob-btn">
    		<br/><br/><br/>
     		<br/><br/><br/>
    </div>
  </form>
  <script>
    lv_fldrec = <?=strtolower(json_encode($vew_data->fldrec));?>;
    // PRESTADOR
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt": {"p.docsts":"A", "dc.sysdocclscodext" :"MED"}, "fldasg": {"patprsrlscod":"p.prscod", "patprsrlstxt":"p.prstxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #patprsrlstxt"), "hltprs", lo_get);
    // Cargar
    $("#<?= $lv_sec; ?> #btnupload").on("click",function(e){ e.preventDefault();
      $("#<?= $lv_sec; ?> #uplfle").trigger("click");
    });
  </script>
  <script>
    function <?= $lv_sec; ?>_removeRow(e) {
			$(e).parent().parent().remove();
		}
  </script>
  <script>
  	tmssLoadScript("toggle",function(){
			$("#<?php echo $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: "success", offstyle: "default", on: "Si", off: "No", size: "small" });
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
          $("#<?php echo $lv_sec; ?> #evlnoinf_div").addClass("hidden");
          $("#<?php echo $lv_sec; ?> #evlyesinf_div").removeClass("hidden");
        }else {
          $("#<?php echo $lv_sec; ?> #evlnoinf_div").removeClass("hidden");
          $("#<?php echo $lv_sec; ?> #evlyesinf_div").addClass("hidden");
        }
      if ($(this).is(":checked")) {
        // Sí se realizó
        $("#<?php echo $lv_sec; ?> #evlnoinf_div").addClass("hidden");
        $("#<?php echo $lv_sec; ?> #evlyesinf_div").removeClass("hidden");
        $("#<?php echo $lv_sec; ?> #grp_mevlmd").show();  // mostrar grupo
        $("#<?php echo $lv_sec; ?> #grp_patprsrlstxt").show();
      } else {
        // No se realizó
        $("#<?php echo $lv_sec; ?> #evlnoinf_div").removeClass("hidden");
        $("#<?php echo $lv_sec; ?> #evlyesinf_div").addClass("hidden");
        $("#<?php echo $lv_sec; ?> #grp_mevlmd").hide();  // ocultar grupo
        $("#<?php echo $lv_sec; ?> #grp_patprsrlstxt").hide();
      }
    });
  </script>
  <script>
    // IMPRIMIR
			$("#<?php echo $lv_sec; ?> #btnprn").on("click",function(e){
				window.open("?prg=zcutp1&act=hltpatevlprn&prm_evlcod=<?php echo $vew_data->evlcod; ?>");
			});
  </script>
  <script>
    // agregar archivos
      var lo_datflelst = new Array();
			$("#<?php echo $lv_sec; ?> #uplfle").on("change",function(e){
				var lv_fleqty=$("#<?= $lv_sec; ?> #uplfle").prop("files").length;
        for (var i = 0; i <= lv_fleqty; i++) {
        //$("#<?= $lv_sec; ?> #uplfle").prop("files").each( function(e) {
          var lo_fle = $("#<?= $lv_sec; ?> #uplfle").prop("files")[i];
          if(lo_fle!=undefined){
          	lo_datflelst.push(lo_fle);
          }
        }
        <?= $lv_sec; ?>_tableFile();
        
        $("#<?= $lv_sec; ?> #uplfle").value = '';
			});
  </script>
  <script>
    function <?= $lv_sec; ?>_tableFile(){
      $("#<?= $lv_sec; ?> #tblfle").empty();
      lv_fleqty= lo_datflelst.length;
      if(lv_fleqty>0){
        var lv_tblfle ="<table id= 'tbldatfle' class='table'>";
        lv_tblfle +="<thead>";
        lv_tblfle +="<tr>";
        lv_tblfle +="<th scope='col'>Archivos adjuntos</th>";
        lv_tblfle +="<th scope='col'></th>";
        lv_tblfle +="</tr>";
        lv_tblfle +="</thead>";
        lv_tblfle +="<tbody>";

        for (var i = 0; i < lv_fleqty; i++) {
            var lv_flenme =lo_datflelst[i].name;
            var lv_fletxt= lv_flenme.length >=30?(lv_flenme.substring(0, 30) + "..." + lv_flenme.substring(lv_flenme.length-4)):lv_flenme;
            var lv_row = "<tr name='dlvrow' data-flenme= '" + lv_flenme + "'>"
                          +"<td>Archivo "+ (i+1) +" : </br><strong>"+lv_fletxt +"</strong></td>"
                          +"<td><a  class='card-icon' onclick='<?= $lv_sec; ?>_removeFile($(this));'><i class='fas fa-trash-alt'></i></a></td>"
                        +"</tr>";
          lv_tblfle +=lv_row;
          }

        lv_tblfle +="</tbody>";
        lv_tblfle +="</Table>";
        
        //$("#<?= $lv_sec; ?> #tblfle").innerHTML= lv_tblfle;
        $("#<?= $lv_sec; ?> #tblfle").append( lv_tblfle);
      }
    }
  
  </script>
  
  <script>
    function <?= $lv_sec; ?>_removeFile(e) {
      var lv_delfletxt= $(e).parent().parent()[0].attributes[1].value;
    	var lv_fleqty=lo_datflelst.length;
      for (var i = 0; i < lv_fleqty; i++) {
        if(lo_datflelst[i].name == lv_delfletxt){
          lo_datflelst.splice(i);
        }
      }
      
			<?= $lv_sec; ?>_tableFile();
		}
  </script>
  
  <script>
    function <?= $lv_sec; ?>_fncbckext(lp_prm){
			/*
      if ( gv_<?php echo $lv_sec; ?>_last_action=="evlest00") {
        	tmssTabSecCls( $("#<?php echo $lv_sec; ?>") );
				}else{
          tmssTabSecCls( $("#<?php echo $lv_sec; ?>") );
        }
			*/
      if ( tmssBackMessageProcessing( lp_prm, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
        if (gv_<?= $lv_sec; ?>_last_action=="04") {
           if(lp_prm['errtyp']=='E'){
            	return false;
           }
        }
      }
      if(lp_prm['errtyp']!='E'){
        // cierra el dialogo actual
        $.each(BootstrapDialog.dialogs, function(id, dialog){
          if(dialog.getModalBody().find("section:first").prop("id")=="<?= $lv_sec; ?>"){
            dialog.close(); 
          }
        });
      	tmssTabSecCls( $("#<?= $lv_sec; ?>") );
      }
    }

		// form submit
    function <?php echo $lv_sec; ?>_fncext( lp_prm ) {
      
			if (lp_prm["action"]=="prn") {
				window.print();
			} else {
				if (lp_prm["action"]=="evlestx4") {
					BootstrapDialog.confirm({
						title: 'Borrar Evolucion',
						message: '¿Desea borrar el documento?',
						type: BootstrapDialog.TYPE_WARNING,
						callback: function(result) {
							if(result) { <?php echo $lv_sec; ?>_fnc({action: "evlest04"}); }
						}
					});
					return false;
				}
        debugger;
				if (lp_prm["action"]=="evlest00" ) {
          if ($("#<?php echo $lv_sec; ?> #evlinfprc").prop("value")=="1"){
            var lv_err = 0;
            var lo_trid = $("#<?= $lv_sec; ?> #tbldat tr[name='dlvrow']").length;
            var lo_datarr = $("#<?= $lv_sec; ?> #tbldat tr[name='dlvrow']");
            var lv_arr = new Array();            
            
            /*
            var lv_evlevl = $("#<?=$lv_sec; ?> #evlevl").val();
            $("#<?=$lv_sec; ?> #evlevl").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if ( lv_evlevl=="" ) {
              //toastr.warning( "Complete el campo Evolucion" ); 
              $("#<?=$lv_sec; ?> #evlevl").parentsUntil(".tmss-form-group").parent().addClass("has-error");
              lv_err++;
            }
            */
            
            /* Subida de archivo */          
            var lo_dat = new FormData();
            var lv_frmarr = $("#<?= $lv_sec; ?>_frm").serializeArray();
            for(var i=0; i<lv_frmarr.length; i++){ lo_dat.append(lv_frmarr[i].name,lv_frmarr[i].value); }
            var lv_fleqty=lo_datflelst.length;
            $("#<?=$lv_sec; ?> #btnupload").css("border-radius", "");
            $("#<?=$lv_sec; ?> #btnupload").css("border-color", "");
            $("#<?=$lv_sec; ?> #btnupload").css("background-color", "");
            //if ( lv_fleqty==0 ) { 
              //$("#<?=$lv_sec; ?> #btnupload").css("border-radius", "6px");
              //$("#<?=$lv_sec; ?> #btnupload").css("border-color", "red");
              //$("#<?=$lv_sec; ?> #btnupload").css("background-color", "#ff000026");
              //toastr.warning("No existen archivos cargados"); 
              //return false; 
              //lv_err++;
            //}
            for (var i = 0; i < lv_fleqty; i++) {
              lo_dat.append("archivo_" + i,lo_datflelst[i]);
            }
            //reqcc,dtesrv,mevlmd,patprsrlscod,patprsrlstxt,ath
            var reqcc = $("#<?=$lv_sec; ?> #reqcc").val();
            $("#<?=$lv_sec; ?> #reqcc").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if ( reqcc=="") {
              $("#<?=$lv_sec; ?> #reqcc").parentsUntil(".tmss-form-group").parent().addClass("has-error");
              lv_err++;
						}
            var dtesrv = $("#<?=$lv_sec; ?> #dtesrv").val();
            $("#<?=$lv_sec; ?> #dtesrv").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if ( dtesrv=="") {
              $("#<?=$lv_sec; ?> #dtesrv").parentsUntil(".tmss-form-group").parent().addClass("has-error");
              lv_err++;
						}
            var mevlmd = $("#<?=$lv_sec; ?> #mevlmd").val();
            $("#<?=$lv_sec; ?> #mevlmd").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if ( mevlmd=="") {
              $("#<?=$lv_sec; ?> #mevlmd").parentsUntil(".tmss-form-group").parent().addClass("has-error");
              lv_err++;
						}
            var patprsrlstxt = $("#<?=$lv_sec; ?> #patprsrlstxt").val();
            $("#<?=$lv_sec; ?> #patprsrlstxt").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if ( patprsrlstxt=="") {
              $("#<?=$lv_sec; ?> #patprsrlstxt").parentsUntil(".tmss-form-group").parent().addClass("has-error");
              lv_err++;
						}
            var ath = $("#<?=$lv_sec; ?> #ath").val();
            $("#<?=$lv_sec; ?> #ath").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if ( ath=="") {
              $("#<?=$lv_sec; ?> #ath").parentsUntil(".tmss-form-group").parent().addClass("has-error");
              lv_err++;
						}
            
            if(lv_err>0){
              toastr.warning( "Complete los campos obligatorios.<br>Incompletos ("+lv_err+")." );
              return false; 
            }
             /* Llamada al controlaor */
            tmssCallProcessFile("?prg=zcutp1_tin&act=evlest00", lo_dat, <?= $lv_sec; ?>_fncbckext);
            // update file data
            return false;
          }else{
            if(!tmssCheckRequiredFields($("#<?php echo $lv_sec; ?>_frm"))){return false;}
            return true
          }
				}
			}
		}
  </script>
  <script>
    //Geo
    $(function(){
      // https://developer.mozilla.org/es/docs/Web/API/Geolocation_API
      var lv_evlinfprc="<?=$vew_data->evlinfprc?>";
      if (lv_evlinfprc == "1") {
          $("#<?php echo $lv_sec; ?> #evlnoinf_div").addClass("hidden");
          $("#<?php echo $lv_sec; ?> #evlyesinf_div").removeClass("hidden");
        }else {
          $("#<?php echo $lv_sec; ?> #evlnoinf_div").removeClass("hidden");
          $("#<?php echo $lv_sec; ?> #evlyesinf_div").addClass("hidden");
        }
            if (lv_evlinfprc == "1") {
        $("#<?php echo $lv_sec; ?> #grp_mevlmd").show();
        $("#<?php echo $lv_sec; ?> #grp_patprsrlstxt").show();
      } else {
        $("#<?php echo $lv_sec; ?> #grp_mevlmd").hide();
        $("#<?php echo $lv_sec; ?> #grp_patprsrlstxt").hide();
      }
      
      /* se ejecuta si los permisos son concedidos y se encuentra una ubicación */
      function onSucccess(position) {
        var output = document.getElementById("geomap");
        console.log(position.coords.latitude, position.coords.longitude);
        console.log(<?php echo $lv_sec; ?>);
        lv_lat=position.coords.latitude;
        lv_lon= position.coords.longitude;
        $("#<?php echo $lv_sec; ?> #evllat").attr("value",lv_lat);
        $("#<?php echo $lv_sec; ?> #evllon").attr("value",lv_lon);
      }

      /* Se ejecuta si el permiso fue denegado o no se puede encontrar una ubicación*/
      function onError() {
        console.log("ocurrio un error o no hay permisos para ver la ubicación");
      }

      var config = {
        enableHighAccuracy: true, 
        maximumAge        : 30000, 
        timeout           : 27000
      };
      if ("geolocation" in navigator) {
        /*así llamamos la función getCurrentPosition*/
        navigator.geolocation.getCurrentPosition(onSucccess, onError, config );
      } else {
          alert("el navegador no soporta la geolocalización");
      }
      
    });
  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
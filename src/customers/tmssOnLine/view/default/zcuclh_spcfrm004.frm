 <?php	
	// url del formulario 
  $lv_lnk = '?prg=zcutp1&prm_evlcod='.$vew_data->evlcod;

	// campos requeridos 
	$lv_reqflddef = array('evlcncmtv','evlcnccmt','fvrpt');
	//$lv_reqfldusrtxt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'sysdocclsreqfld');
	//$lv_reqfldusr = ($lv_reqfldusrtxt!=''?explode(';',$lv_reqfldusrtxt):array());
	$vew_input->setReqFields( $lv_reqflddef);//$vew_input->setReqFields( array_merge($lv_reqflddef,$lv_reqfldusr) );
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
	} else {
    $lv_evlatrval001=strtoupper($vew_data->evlatr001);
	 	$lv_buf = $vew_doc->getTagValue($lv_evlatrval001,'row');
	 	$vew_data->evlinfprc = strtoupper($vew_doc->getTagValue($lv_buf,'evlinfprc'));
    
	 	if ($vew_data->evlinfprc ==''){
	 		if ($vew_data->docsts=='A') {
				$vew_data->evlinfprc = '1';
			}	else {
	 			$vew_data->evlinfprc = '0';
	 		}
	 	}
	 	$vew_data->evlcncmtv = utf8_decode($vew_doc->getTagValue($lv_buf,'evlcncmtv'));
	 	$vew_data->evlcnccmt=utf8_decode($vew_data->evlsub);
	 	$vew_data->evlevl = utf8_decode($vew_data->evlevl);
    
    $vew_data->evlcnccmt=utf8_decode($vew_data->evlsub);
		$vew_data->evlcmt=utf8_decode($vew_data->evlcmt);
	 	$vew_data->evlmtv=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlmtv')));
		$vew_data->evlmtt=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlmtt')));
		$vew_data->evllug=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evllug')));
		$vew_data->evlmd1=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlmd1')));
		$vew_data->evlmd2=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlmd2')));
		$vew_data->evlpa1=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlpa1')));
		$vew_data->evlpa2=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'evlpa2')));
    $vew_data->aplenf=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'aplenf')));
    $vew_data->patwgt=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'patwgt')));
    $vew_data->matbch=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'matbch')));
    $vew_data->matduedte=strtoupper(utf8_decode($vew_doc->getTagValue($lv_buf,'matduedte')));
		$vew_data->evlevl=strtoupper(utf8_decode($vew_data->evlevl));
    $vew_data->fvrpt = strtoupper($vew_doc->getTagValue($lv_buf,'fvrpt'));   
    $vew_data->frm = strtoupper($vew_doc->getTagValue($lv_buf,'dvcfrm'));    
	}
	$lv_icofrm= '';

	$lv_icofrm= $vew_data->frm==''?'fa-desktop':'fa-mobile-alt';
  
	// Configuracion de botones 
	$vew_tbl['clsL'] = array('pos'=>'L','per'=>($vew_data->hhcc=='X'), 'ttl'=>$vew_lang->close, 'id'=>'btncls','icn'=>'fas fa-arrow-left', 'css'=>'btn navbar-btn tmss-navbar-btn arrow-left', 'acc'=>$lv_sec.'_fncbckext();');
  $vew_tbl['prnR'] =array('per'=>$vew_sec->hasPermission('HLT','EVL','05') && $vew_data->docsts=='A','id'=>'btnprn');
  $vew_tbl['sveL'] =array('per'=>!$vew_readonly,'acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlcoa00'.chr(39).'});'); 
  $vew_tbl['sveR'] =array('per'=>!$vew_readonly,'acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlcoa00'.chr(39).'});'); 
  $vew_tbl['del']  =array('per'=>$vew_sec->hasPermission('HLT','EVL','04') && $vew_data->evlcod!='','acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlcoax4'.chr(39).'});');
  if($vew_data->evllon!=''){
    $vew_tbl['goe']  =array('per'=>$vew_readonly,'pos'=>'D', 'ttl'=>'Localizacion', 'id'=>'','icn'=>'fa-solid fa-location-dot', 'css'=>'tmss-Opt', 'acc'=>'window.open('.chr(39).'http://www.google.com/maps/search/?api=1&query='.$vew_data->evllat.','.$vew_data->evllon.chr(39).');' );
  }
?>
<section id="<?php echo $lv_sec; ?>" data-title="<?php echo $lv_title; ?>">
  <?php
  	//var_dump($vew_data->fldrec);
  ?>
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
                    echo vew_boot($lv_col210,array('label'=>$vew_lang->date, 'input'=>gethtml('evldte','docdte',$vew_data->evldte,$lv_default) ));
                  	echo vew_boot(array($lv_colsm210, $lv_colxs48),array('label'=>'Se realiz&oacute;', 'input'=>gethtml('evlinfprc','checkbox',$vew_data->evlinfprc,$lv_default) ));
                  ?>                    
              </div> <!-- /Card Boby -->
            </div><!-- /Card -->
            <div class="card">
              <div class="card-body tmss-card-body-edit">
                <?php 
                	echo vew_boot($lv_col210,array('label'=>'Inf. Farmacovigilancia',
                                                 'input'=>gethtml('fvrpt',array(''=>'','0'=>'No','1'=>'Si'),$vew_data->fvrpt,$lv_default) 
                                                  ));
                ?>
              	
              </div><!-- /Card Boby -->
            </div><!-- /Card -->
            <div class="card" id="evlnoinf_div">
              <div class="card-body tmss-card-body-edit">
                 <?php
                    /*
                    echo vew_boot($lv_col210,array('label'=>$vew_lang->motive, 
                                                   'input'=>gethtml('evlcncmtv',array(''=>'','SV'=>'SIN VIALES','EN'=>'ENFERMEDAD','ND'=>'PACIENTE NO DISPONIBLE','OT'=>'OTROS'),
                                   $vew_data->evlcncmtv,$lv_default) ));
                    */
                		echo vew_boot($lv_col210,array('label'=>$vew_lang->motive, 
                                                   'input'=>gethtml('evlcncmtv',$vew_data->evlcncmtvlst,
                                   $vew_data->evlcncmtv,$lv_default) ));

                    echo vew_boot($lv_col210,array('label'=>$vew_lang->comments, 'input'=>gethtml('evlcnccmt','doccmt5x50',$vew_data->evlcnccmt,$lv_default) ));              
                  ?>                
              </div>              
            </div>             
            <div class="card" id="evlyesinf_div">
              <div class="card-header">
                <div class="card-title">Datos del entrenamiento
                  <a class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" id="btnaddmat" title="agregar"><i class="fas fa-plus"></i></a>
                </div>
              </div><!-- /Card header -->
              <div class="card-body tmss-card-body-edit">
                <?php
                  if(!$vew_readonly){
                    echo vew_boot($lv_col210, array('label'=>'Medicamento', 
                                                    'input1'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                      array('input'=>gethtml('mattxt', 'typeahead', $vew_data->mattxt, $lv_default) ))
                                  ));
                    echo gethtml('matcod', 'hidden', $vew_data->matcod);
                  }                
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
                      <th scope="col">Datos de Medicamentos</th>
                      <th scope="col"></th>
                    </tr>
                  </thead>
                  <tbody id="tbldatbdy">
                    
                    <?php
                    foreach($vew_data->evlmat as $lo_matrow){
											//var_dump($lo_matrow['mattxt']);											
                      echo '<tr>';
                      $lv_matrow='';
                      $lv_matrow.='<td><strong>'.$lo_matrow['mattxt'].'</strong> ';
                      $lv_matrow.=($lo_matrow['matqty']==''|| $lo_matrow['matqty']<=0)?'':('Cant. Viales: <strong>'.$lo_matrow['matqty'].'</strong><br>');
                      $lv_matrow.=$lo_matrow['matbchcodext']==''?'':('Lote: <strong>'.$lo_matrow['matbchcodext'].'</strong>&nbsp; ');
                      $lv_matrow.=$lo_matrow['matbchduedte']==''?'':('vto:<strong>'.date_format($lo_matrow['matbchduedte'],'d/m/Y').'</strong>');
                      echo $lv_matrow;
                      echo '</td>';
                      echo '<td scope="row"><a  class="card-icon tmssHiddeOnRead"><i class="fas fa-trash-alt"></i></a></td>';
                      echo '</tr>';
                    } 
                    ?>
                  </tbody>
                </table>
                <textarea id="evlmat" name="evlmat" class="hidden"></textarea>
                <!--<div class ="row"> -->
                  <?php
                    echo vew_boot($lv_col210,array('label'=>'M&eacute;dico tratante', 'input'=>gethtml('evlmtt','doccmt1x50',$vew_data->evlmtt,$lv_default) ));
                    echo vew_boot($lv_col210,array('label'=>'Lugar Atenci&oacute;n', 'input'=>gethtml('evllug','doccmt1x50',$vew_data->evllug,$lv_default) ));
                  ?>
                  <!--<div class="form-group tmss-form-group">
                    <label class="col-sm-2 control-label"><?php echo 'Medicaci&oacute;n'; ?></label>
                    <div class="col-sm-4"><?php 
                      echo gethtml('evlmd1','doccmt1x50',$vew_data->evlmd1,$lv_default); 
                      //gethtml('evlmd1', $vew_matlst , $vew_data->evlmd1 );
                      ?></div>
                    <label class="col-sm-2 control-label">Otros</label>
                    <div class="col-sm-4"><?php echo gethtml('evlmd2','doccmt1x50',$vew_data->evlmd2,$lv_default) ; ?></div>
                  </div>
									-->
                  <div class="form-group tmss-form-group">
                    <label class="col-sm-2 control-label"><?php echo 'Patolog&iacute;a'; ?></label>
                    <div class="col-sm-4"><?php echo gethtml('evlpa1','doccmt1x50',$vew_data->evlpa1,$lv_default); ?></div>
                    <label class="col-sm-2 control-label">Otras</label>
                    <div class="col-sm-4"><?php echo gethtml('evlpa2','doccmt1x50',$vew_data->evlpa2,$lv_default) ; ?></div>
                  </div>
                  <?php
                  echo vew_boot($lv_col210,array('label'=>'Apl. enfermero?', 'input'=>gethtml('aplenf','yesno',$vew_data->aplenf,$lv_default) ));
                  ?>
                <!--</div>-->
                <div class ="row">
                  <br/>
                  <div class="col-sm-12 tmssHiddeOnRead">
                    <div class="text-center">
                      <div class="btn btn-primary btn-lg" id="btnupload"><i class="fa-solid fa-paperclip fa-2x"></i><br/><span class="small"> <?= $vew_lang->file; ?></span></div>
                    </div> <!-- text-center -->
                      <br/>
                    <div id='tblfle'>
                    </div><!-- tblfle-->
                  </div><!-- -col_sm-12 -->
                </div><!-- row -->
                <div class="hidden"><input type="file" id="uplfle" name="uplfle" multiple ></div>
                <?= vew_boot($lv_col233,array('label'=>$vew_lang->weight.'</br><small>(Indicar solo si se actualiza)</small>', 'input'=>gethtml('patwgt','docnum0603',$vew_data->patwgt,$lv_default) ,''));?>          
                <?= vew_boot($lv_col210,array('label'=>$vew_lang->evolution, 'input'=>gethtml('evlevl','doccmt5x50',$vew_data->evlevl,$lv_default) ));?>          
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
    <div id ="addmat"class=" card hidden">
      <div class="card-body tmss-card-body-edit">
        <?= vew_boot($lv_col210,array('label'=>'Lote', 'input'=>gethtml('lot','doccmt1x20','',$lv_default) ));?>
        <?= vew_boot($lv_col210,array('label'=>'Viales', 'input'=>gethtml('vi','qty','',$lv_default) ));?>
        <?= vew_boot($lv_col210,array('label'=>'Vto', 'input'=>gethtml('vto','docdte','',$lv_default) ));?>
      </div>
    </div>
  </form>
  <script>
    lv_fldrec = <?=strtolower(json_encode($vew_data->fldrec));?>;
    // MATTXT
		// FALTA: Deberían mostrar solo los materiales que sean de la clase de documento materiales
		var lo_get = {"fldsec" : "<?=$lv_sec;?>", "fldasg":{ "matcod":"matcod", "mattxt":"mattxt" }, "fldflt":{"m.docsts":"A"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #mattxt"), "stkmat", lo_get);
  </script>
  <script>
    // Cargar
    $("#<?= $lv_sec; ?> #btnupload").on("click",function(e){ e.preventDefault();
      $("#<?= $lv_sec; ?> #uplfle").trigger("click");
    });
  </script>
  <script>
    // IMPRIMIR
			$("#<?php echo $lv_sec; ?> #btnaddmat").on("click",function(e){
        var lv_addmat = document.getElementById("addmat");
        var lo_dat = $("#<?= $lv_sec; ?> #tbldat tr[name='dlvrow']");
        
        var lv_product = $("#<?=$lv_sec; ?> #mattxt").val();
        var lo_trid = $("#<?= $lv_sec; ?> #tbldat tr[name='dlvrow']").length;
        //$("#<?=$lv_sec; ?> #mattxt").removeClass("has-error");
        //$("#<?=$lv_sec; ?> #mattxt").classList.remove("has-error");
        $("#<?=$lv_sec; ?> #mattxt").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
        if (lv_product ==""){
          $("#<?=$lv_sec; ?> #mattxt").parentsUntil(".tmss-form-group").parent().addClass("has-error");
          toastr.warning("No se ha seleccionado un medicamento");
          //$("#<?=$lv_sec; ?> #mattxt").classList.add("has-error");
        	return; 
        }
        var lo_clon = lv_addmat.cloneNode(true);
        lo_clon.classList.remove('hidden');
        BootstrapDialog.show({
							title: 'Registrar Medicamentos ( ' + lv_product + ' )',
          		size: BootstrapDialog.SIZE_NORMAL,
							message: lo_clon,
							type: BootstrapDialog.TYPE_PRIMARY,
							closable:false,
							buttons: [{
	                	label: 'Agregar',
	                	cssClass: 'btn-success',
	                	action:function(dialogItself){
                      var lv_matbchcodext = $(dialogItself.$modalBody).find("#lot")[0].value;
                      var lv_matqty = $(dialogItself.$modalBody).find("#vi")[0].value;
                      var lv_matbchduedte = $(dialogItself.$modalBody).find("#vto")[0].value;
                      
                      /*Validaion de datos*/
                      /*
                      if(lv_matbchcodext=='' || lv_matqty =='' || lv_matbchduedte==''){
                        toastr.warning("Falta especificar algun dato del medicamento");
                        return;
                      }
                      */
                      
                      if(isNaN(lv_matqty)){
                      	toastr.warning("El campo VIALES no es un numero");
                        return;
                      }
                      var lv_row = "<tr name='dlvrow' data-matqty= '" + lv_matqty + "' data-matbchcodext= '" + lv_matbchcodext + "' data-matbchduedte= '" + lv_matbchduedte + "'>";
                      lv_row +="<td><strong>"+lv_product+"</strong>";
                      lv_row +=lv_matqty==""?"":(" Cant. Viales: <strong>"+lv_matqty+"</strong><br>");
                      lv_row +=lv_matbchcodext==""?"":("Lote: <strong>"+lv_matbchcodext+"</strong>&nbsp;");
                      lv_row +=lv_matbchduedte==""?"":(" vto:<strong>"+lv_matbchduedte+"</strong></td>");
                      lv_row +="<td><a  class='card-icon' onclick='<?= $lv_sec; ?>_removeRow($(this));'><i class='fas fa-trash-alt'></i></a></td>"
                      lv_row +="</tr>";
                      //document.getElementById("tbldatbdy").insertRow(-1).innerHTML =lv_row;
                      $("#<?= $lv_sec; ?> #tbldat").append( lv_row );
                      dialogItself.close();
	                	}
	            		},
                  {
                    label: 'Close',
                    action: function(dialogItself){
                        dialogItself.close();
                    }
                  }
                       ],
							callback: function(result) {
								tmssTabSecCls( $("#<?php echo $lv_sec; ?>") );
							}
						});
			});
  </script>

  <script>
    // Cargar
    /*
    $("#<?= $lv_sec; ?> #btnupload").on("click",function(e){ e.preventDefault();
      $("#<?= $lv_sec; ?> #uplfle").trigger("click");
    });
    */
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
      if(!lp_prm){tmssTabSecCls( $("#<?= $lv_sec; ?>") );}
			// cierra el dialogo actual
      tmssBackMessageProcessing( lp_prm, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?=$vew_data->evlcod; ?></b>" ); 
			$.each(BootstrapDialog.dialogs, function(id, dialog){
				if(dialog.getModalBody().find("section:first").prop("id")=="<?= $lv_sec; ?>"){ dialog.close(); }
			});
      */
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
				if (lp_prm["action"]=="evlcoax4") {
					BootstrapDialog.confirm({
						title: 'Borrar Evolucion',
						message: '¿Desea borrar el documento?',
						type: BootstrapDialog.TYPE_WARNING,
						callback: function(result) {
							if(result) { <?php echo $lv_sec; ?>_fnc({action: "evlcoa04"}); }
						}
					});
					return false;
				}
				if (lp_prm["action"]=="evlcoa00" ) {
          if ($("#<?php echo $lv_sec; ?> #evlinfprc").prop("value")=="1"){
           	
            var lv_err = 0;
            var lo_trid = $("#<?= $lv_sec; ?> #tbldat tr[name='dlvrow']").length;
            var lv_arr = new Array();
						var lo_datarr = $("#<?= $lv_sec; ?> #tbldat tr[name='dlvrow']");						
						var lv_mattxt = $("#<?=$lv_sec; ?> #mattxt").val();
            var lv_matcod = $("#<?=$lv_sec; ?> #matcod").val();						
            var lv_evlevl = $("#<?=$lv_sec; ?> #evlevl").val();
            $("#<?=$lv_sec; ?> #evlevl" ).parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if ( lv_evlevl=="" && lv_fldrec.includes("evlevl")) {
              $("#<?=$lv_sec; ?> #evlevl").parentsUntil(".tmss-form-group").parent().addClass("has-error");
              lv_err++; 
            }
            
            var lv_fvrpt = $("#<?=$lv_sec; ?> #fvrpt").val();
            $("#<?=$lv_sec; ?> #fvrpt").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if ( lv_fvrpt==""  && lv_fldrec.includes("fvrpt") ) {
              //toastr.warning( "Complete el campo Evolucion" ); 
              $("#<?=$lv_sec; ?> #fvrpt").parentsUntil(".tmss-form-group").parent().addClass("has-error");
              lv_err++;
						}
            
            
            
            for (var i=0; i<lo_datarr.length; i++) {
              lv_arr.push({	"evlmatcod":"",
                            "matcod":lv_matcod,
                            "mattxt":lv_mattxt,
                            "matqty":$(lo_datarr[i]).data("matqty"),
                            "matuntcod":"UN",
                            "matbchcodext":$(lo_datarr[i]).data("matbchcodext"),
                            "matbchduedte":$(lo_datarr[i]).data("matbchduedte"),
                            "atrstrtme":"",
                            "atrendtme":"",
                            "atradvrea":""
                          });
            }           
            $("#<?=$lv_sec; ?> #btnaddmat").css("border-radius", "");
              $("#<?=$lv_sec; ?> #btnaddmat").css("background-color", "");
              $("#<?=$lv_sec; ?> #btnaddmat").css("color", "");
            
            if ( lv_arr.length==0 && lv_fldrec.includes("btnaddmat")) { 
              $("#<?=$lv_sec; ?> #btnaddmat").css("border-radius", "50px");
              $("#<?=$lv_sec; ?> #btnaddmat").css("background-color", "#ff000026");
              $("#<?=$lv_sec; ?> #btnaddmat").css("color", "red");
              lv_err++;
            }
            
            $("#<?php echo $lv_sec; ?> #evlmat").text( (lv_arr.length==0?"":JSON.stringify(lv_arr)) );
            
            /* Subida de archivo */          
            var lo_dat = new FormData();
            var lv_frmarr = $("#<?= $lv_sec; ?>_frm").serializeArray();
            for(var i=0; i<lv_frmarr.length; i++){ lo_dat.append(lv_frmarr[i].name,lv_frmarr[i].value); }
            var lv_fleqty=lo_datflelst.length;
            $("#<?=$lv_sec; ?> #btnupload").css("border-radius", "");
            $("#<?=$lv_sec; ?> #btnupload").css("border-color", "");
            $("#<?=$lv_sec; ?> #btnupload").css("background-color", "");
            
            if("<?=$vew_data->custxt; ?>"!="ULTRAGENYX"&&"<?=$vew_data->custxt; ?>"!="AXA - NOVARTIS"){//???
              if ( lv_fleqty==0 && lv_fldrec.includes("evlfle")) { 
                $("#<?=$lv_sec; ?> #btnupload").css("border-radius", "6px");
                $("#<?=$lv_sec; ?> #btnupload").css("border-color", "red");
                $("#<?=$lv_sec; ?> #btnupload").css("background-color", "#ff000026");
                lv_err++;
              }
            }
            for (var i = 0; i < lv_fleqty; i++) {
              lo_dat.append("archivo_" + i,lo_datflelst[i]);
            }
            //OBTENGO TODOS LOS DATOS DEL FROMULARIO
            <?= $lv_sec; ?>_form= document.querySelector("#<?= $lv_sec; ?>_frm")
            <?= $lv_sec; ?>_formdata= Object.fromEntries(new FormData(<?= $lv_sec; ?>_form))
            console.log(<?= $lv_sec; ?>_formdata)
            
            $("#<?=$lv_sec; ?> #evlmtt" ).parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if(lv_fldrec.includes("evlmtt")  && <?= $lv_sec; ?>_formdata.evlmtt == ''){
              lv_err++; 
              $("#<?=$lv_sec; ?> #evlmtt").parentsUntil(".tmss-form-group").parent().addClass("has-error");
            }
            
            $("#<?=$lv_sec; ?> #evllug" ).parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if(lv_fldrec.includes("evllug")  && <?= $lv_sec; ?>_formdata.evllug == ''){
              lv_err++; 
              $("#<?=$lv_sec; ?> #evllug").parentsUntil(".tmss-form-group").parent().addClass("has-error");
            }
            
            $("#<?=$lv_sec; ?> #evlpa2" ).parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if(lv_fldrec.includes("evlpa1")  && <?= $lv_sec; ?>_formdata.evlpa1 == ''){
              lv_err++; 
              $("#<?=$lv_sec; ?> #evlpa2").parentsUntil(".tmss-form-group").parent().addClass("has-error");
            }
            
            $("#<?=$lv_sec; ?> #evlpa2" ).parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if(lv_fldrec.includes("evlpa2")  && <?= $lv_sec; ?>_formdata.evlpa2 == ''){
              lv_err++; 
              $("#<?=$lv_sec; ?> #evlpa2").parentsUntil(".tmss-form-group").parent().addClass("has-error");
            }
            $("#<?=$lv_sec; ?> #aplenf" ).parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if(lv_fldrec.includes("aplenf")  && <?= $lv_sec; ?>_formdata.aplenf == ''){
              lv_err++; 
              $("#<?=$lv_sec; ?> #aplenf").parentsUntil(".tmss-form-group").parent().addClass("has-error");
            }
            if(lv_err>0){
              toastr.warning( "Complete los campos obligatorios.<br>Incompletos ("+lv_err+")." );
              return false; 
            }
            if(!tmssFormValidation($("#<?php echo $lv_sec; ?>_frm"))){return false;}
             /* Llamada al controlaor */
            tmssCallProcessFile("?prg=zcutp1&act=evlcoa00", lo_dat, <?= $lv_sec; ?>_fncbckext);
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

      /*se ejecuta si el permiso fue denegado o no se puede encontrar una ubicación*/
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
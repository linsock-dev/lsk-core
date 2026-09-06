<?php	
	// url del formulario
	/*
  if(isset($vew_data->endpoint)){
  $lv_lnk = '?prg='.$vew_data->endpoint.'&prm_evlcod='.$vew_data->evlcod;  
  }else{
    $lv_lnk = '?prg=zcutp1_ttr&prm_evlcod='.$vew_data->evlcod; 
  }
  */
	 	$lv_lnk = '?prg='.$vew_data->endpoint.'&prm_evlcod='.$vew_data->evlcod;  

	// La clase documental puede llegar como modelo o como codigo, segun el origen del formulario.
	$lv_sysdoccls = $vew_data->sysdoccls??null;
	$lv_sysdocclsobj = is_object($lv_sysdoccls)?$lv_sysdoccls:null;
	$lv_sysdocclsatr = $lv_sysdocclsobj?($lv_sysdocclsobj->sysdocclsatr??''):($vew_data->sysdocclsatr??'');
	$lv_sysdocclscod = $lv_sysdocclsobj
		? ($lv_sysdocclsobj->sysdocclscod??($vew_data->sysdocclscod??''))
		: ($vew_data->sysdocclscod??(is_string($lv_sysdoccls)?$lv_sysdoccls:''));

		// campos requeridos 
		$lv_reqflddef = array('evlcncmtv','evlcnccmt','fvrpt');  
	  //$lv_reqflddef = $vew_data->fldrec;
		//$lv_reqflddef=[];
		$lv_reqfldusrtxt = $vew_doc->getTagValue($lv_sysdocclsatr,'sysdocclsreqfld');
	$lv_reqfldusr = ($lv_reqfldusrtxt!=''?explode(';',$lv_reqfldusrtxt):array());
	$vew_input->setReqFields( array_merge($lv_reqflddef,$lv_reqfldusr) );

	// clave del documento 
	$lv_dockey = $vew_data->evlcod; 

	// titulo 
	$lv_title = $vew_lang->evolution;

	// módulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod ='EVL';
	if($vew_actcod=='evlinf'){
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
    
	 	if ($vew_data->evlinfprc ==''){
	 		if ($vew_data->docsts=='A') {
				$vew_data->evlinfprc = '1';
			}	else{
	 			$vew_data->evlinfprc = '0';
	 		}
	 	}
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

  $lv_canprint = $vew_sec->hasPermission('HLT','EVL','05')
    && $vew_data->evlcod!=''
    && in_array(strtoupper((string)$vew_data->docsts), array('A', 'P'), true);
  $vew_tbl['prnR'] = array('per'=>$lv_canprint, 'id'=>'btnprn');
	//$vew_tbl['canc'] = array('pos'=>'L','per'=>true, 'ttl'=>$vew_lang->cancel, 'id'=>'','icn'=>'fas fa-times', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnRead btn-danger tmss-desk-btn', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'98'.chr(39).'});' );
  $vew_tbl['sveL'] =array('per'=>!$vew_readonly,'acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlinf00'.chr(39).'});'); 
  $vew_tbl['sveR'] =array('per'=>!$vew_readonly,'acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlinf00'.chr(39).'});');
	$vew_tbl['modL'] = array('pos'=>'L','per'=>($vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02') && $vew_actcod =='03' && $vew_data->evlinfprc =='1'), 'ttl'=>$vew_lang->modify, 'id'=>'','icn'=>'fas fa-pencil-alt', 'css'=>'btn navbar-btn tmss-navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'acc'=>$lv_sec.'_fnc({action: '.chr(39).'02'.chr(39).'});' );
  $vew_tbl['del']  =array('per'=>$vew_sec->hasPermission('HLT','EVL','04') && $vew_data->evlcod!='','acc'=>$lv_sec.'_fnc({action: '.chr(39).'evlinfx4'.chr(39).'});');
  if($vew_data->evllon!=''){
    $vew_tbl['goe']  =array('per'=>$vew_readonly,'pos'=>'D', 'ttl'=>'Localizacion', 'id'=>'','icn'=>'fa-solid fa-location-dot', 'css'=>'tmss-Opt', 'acc'=>'window.open('.chr(39).'http://www.google.com/maps/search/?api=1&query='.$vew_data->evllat.','.$vew_data->evllon.chr(39).');' );
  }
?>
<section id="<?php echo $lv_sec; ?>" data-title="<?php echo $lv_title; ?>">
  <?php include('zcutp_docfrmtlb.frm'); ?>


  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?php echo $lv_sec; ?>_frm" enctype="multipart/form-data">
    <input type="hidden" id="tmss_actcod" name="tmss_actcod" value="">
			<input type="hidden" id="sysdocclscod" name="sysdocclscod" value="<?= $lv_sysdocclscod; ?>">
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
                	if($vew_actcod == '01'){
                  	echo vew_boot(array($lv_colsm210, $lv_colxs48),array('label'=>'Se realiz&oacute;', 'input'=>gethtml('evlinfprc','checkbox',$vew_data->evlinfprc,$lvDisableOnModify) ));
                  }
                ?>
                <?php
                if($vew_actcod != '01'){
                ?>
                <div class="form-group tmss-form-group ">
                  <input type="hidden" id="evlinfprc" name="evlinfprc" value="<?= $vew_data->evlinfprc; ?>">
                  <label class=" col-sm-2 col-xs-4 control-label text-nowrap">Se realiz&oacute;</label>
                  <div class=" col-sm-10 col-xs-8">
                    <?=($vew_data->evlinfprc=='1'?'<h3 style="align-content: center;font-size: 16px;width: 50px;height: 30px;border-radius: 7px;text-align: center;color:#ffffff;background-color:#5dba3d;margin-top: 5px;">Si</h3>':'<h3 style="align-content: center;font-size: 16px;width: 50px;height: 30px;border-radius: 7px;text-align: center;color:#ffffff;background-color: #21A2F2;margin-top: 5px;">No</h3>')?>
                	</div>
                </div>
                <?php }?>
                                     
              </div> <!-- /Card Boby -->
            </div><!-- /Card -->
            <div class="card">
              <div class="card-body tmss-card-body-edit">
                <?php 
                if($vew_actcod == '01'){
                	echo vew_boot($lv_col210,array('label'=>'Inf. Farmacovigilancia',
                                                 'input'=>gethtml('fvrpt',array(''=>'','0'=>'No','1'=>'Si'),$vew_data->fvrpt,$lvDisableOnModify) 
                                                  ));
                }else{
                  ?>
                	<div class="form-group tmss-form-group ">
                    <input type="hidden" id="fvrpt" name="fvrpt" value="<?= $vew_data->fvrpt; ?>">
                    <label class=" col-sm-2 col-xs-4 control-label text-nowrap;" style="font-size: 13px;">Inf. Farmacovigilancia</label>
                    <div class=" col-sm-10 col-xs-8">
                      <?=($vew_data->fvrpt=='1'?'<h3 style="align-content: center;font-size: 16px;width: 50px;height: 30px;border-radius: 7px;text-align: center;color:#808186;background-color: #fff;margin-top: 5px;">Si <i class="fa-solid fa-triangle-exclamation" style="font-size: large;color: #ff9200;"></i></h3>':'<h3 style="align-content: center;font-size: 16px;width: 50px;height: 30px;border-radius: 7px;text-align: center;color:#808186;background-color: #fff;margin-top: 5px;">No </h3>')?>
                    </div>
                  </div>
                <?php
                  
                }
                ?>
              	
              </div><!-- /Card Boby -->
            </div><!-- /Card -->
            <div class="card" id="evlnoinf_div">
              <div class="card-body tmss-card-body-edit">
                 <?php

                		 echo vew_boot($lv_col210,array('label'=>$vew_lang->motive, 
                                                   'input'=>gethtml('evlcncmtv',$vew_data->evlcncmtvlst,
                                   $vew_data->evlcncmtv,$lvDisableOnModify) ));

                    echo vew_boot($lv_col210,array('label'=>$vew_lang->comments, 'input'=>gethtml('evlcnccmt','doccmt5x50',$vew_data->evlcnccmt,$lvDisableOnModify) ));              
                  ?>                
              </div>              
            </div>             
            <div class="card" id="evlyesinf_div">
              <div class="card-header">
                <div class="card-title">Datos de tratamiento
                  <a class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" id="btnaddmat" title="agregar"><i class="fas fa-plus"></i></a>
                  <!--<a href='#' id='btnupload' class='card-icon ' title="Cargar"><i class='fas fa-upload'></i></a>-->
                </div>
              </div><!-- /Card header -->
              <div class="card-body tmss-card-body-edit">
                <?php
                	$lv_untimp='';
                	$lv_untimp= gethtml('matuntcod', 'doccmt1x20', $vew_data->matuntcod,$lv_always_disabled);
                ?>
              	<?= vew_boot($lv_col233,array('label1'=>'Dosis total', 'input1'=>gethtml('matdos','docnum0802',$vew_data->matdos,$lv_default) ,'input2'=>$lv_untimp));?>
              	<?php
                if(!$vew_readonly){
                  echo gethtml('matcod', 'hidden', $vew_data->matcod);
                  echo vew_boot($lv_col210, array('label'=>'Medicamento', 
                                                  'input1'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                    array('input'=>gethtml('mattxt', 'doccmt1x50', $vew_data->mattxt, $lv_always_disabled) ))
                                ));
                  //echo vew_boot($lv_col233,array('label'=>'Medida ' . $vew_data->matuntcod, 'input'=>gethtml('matuntcod','doccmt1x10',$vew_data->matuntcod,$lv_always_disabled) ,''));
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
                      $lv_matbchduedte=date('d/m/Y', strtotime($lo_matrow['matbchduedte']));
                      echo '<tr name="dlvrow" data-evlmatcod="'.$lo_matrow['evlmatcod'].'" data-matcod="'.$lo_matrow['matcod'].'" data-mattxt="'.$lo_matrow['mattxt'].'" data-matqty="'.$lo_matrow['matqty'].'" data-matbchcodext="'.$lo_matrow['matbchcodext'].'" data-matbchduedte="'.$lv_matbchduedte.'">';
                      echo '<td><strong>'.$lo_matrow['mattxt'].'</strong> Cant. Viales: <strong>'.$lo_matrow['matqty'].' '.$lo_matrow['matuntcod'].'</strong><br>Lote: <strong>'.$lo_matrow['matbchcodext'].'</strong>&nbsp; vto:<strong>'.$lv_matbchduedte.'</strong></td>';
                      echo '<td scope="row"><a class="card-icon tmssHiddeOnRead"  onclick="'. $lv_sec .'_removeRowEdit($(this),'.$lo_matrow['evlmatcod'].');"><i class="fas fa-trash-alt"></i></a></td>';
                      echo '</tr>';
                    } 
                    ?>
                  </tbody>
                </table>
                <div class ="row">
                  <div class="col-sm-12 tmssHiddeOnRead <? echo ($vew_actcod =="02"?"hidden":"") ?>" >
                    <div class="text-center">
                      <div class="btn btn-primary btn-lg" id="btnupload"><i class="fa-solid fa-paperclip fa-2x"></i><br/><span class="small"> <?= $vew_lang->file; ?></span></div>
                    </div>
                      <br/>
                    <div id='tblfle'>
                    </div>
                  </div>
                </div>
                <textarea id="evlmat" name="evlmat" class="hidden"></textarea>
                <div class="hidden"><input type="file" id="uplfle" name="uplfle" multiple ></div>
                <?= vew_boot($lv_col233,array('label'=>$vew_lang->weight.'</br><small>(Indicar solo si se actualiza)</small>', 'input'=>gethtml('patwgt','docnum0603',$vew_data->patwgt,$lvDisableOnModify) ,''));?>
                <?= vew_boot($lv_col210,array('label'=>$vew_lang->evolution, 'input'=>gethtml('evlevl','doccmt2x50',$vew_data->evlevl,$lvDisableOnModify) ));?>          
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
    $("#<?= $lv_sec; ?> #matdos").attr("step", 0.1).attr("min", 1).attr("max", 8000);
    
    lv_fldrec = <?=strtolower(json_encode($vew_data->fldrec));?>;
    
    // MATTXT
		// FALTA: Deberían mostrar solo los materiales que sean de la clase de documento materiales
		var lo_get = {"fldsec" : "<?=$lv_sec;?>", "fldasg":{ "matcod":"matcod", "mattxt":"mattxt" , "matuntcod":"m.matuntcod" }, "fldflt":{"m.docsts":"A"}};
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
        var lv_productcod = $("#<?=$lv_sec; ?> #matcod").val();
        var lv_addmat = document.getElementById("addmat");
        var lo_dat = $("#<?= $lv_sec; ?> #tbldat tr[name='dlvrow']");
        
        var lv_product = $("#<?=$lv_sec; ?> #mattxt").val();
        var lo_trid = $("#<?= $lv_sec; ?> #tbldat tr[name='dlvrow']").length;
        //$("#<?=$lv_sec; ?> #mattxt").removeClass("has-error");
        //$("#<?=$lv_sec; ?> #mattxt").classList.remove("has-error");
        $("#<?=$lv_sec; ?> #mattxt").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
        if (lv_productcod ==""){
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
                      var lv_mattxt = $("#<?=$lv_sec; ?> #mattxt").val();
            					var lv_matcod = $("#<?=$lv_sec; ?> #matcod").val();
                      /*Validaion de datos*/
                      if(lv_matbchcodext=='' || lv_matqty =='' || lv_matbchduedte==''){
                        toastr.warning("Falta especificar algun dato del medicamento");
                        return;
                      }
                      if(isNaN(lv_matqty)){
                      	toastr.warning("El campo VIALES no es un numero");
                        return;
                      }
                      var lv_row = "<tr name='dlvrow' data-evlmatcod='0' data-matcod= '" + lv_matcod + "' data-mattxt= '" + lv_mattxt + "' data-matqty= '" + lv_matqty + "' data-matbchcodext= '" + lv_matbchcodext + "' data-matbchduedte= '" + lv_matbchduedte + "'>"
                                   +"<td><strong>"+lv_mattxt+"</strong> Cant. Viales: <strong>"+lv_matqty+"</strong><br>Lote: <strong>"+lv_matbchcodext+"</strong>&nbsp; vto:<strong>"+lv_matbchduedte+"</strong></td>"
                                   +"<td><a  class='card-icon' onclick='<?= $lv_sec; ?>_removeRow($(this));'><i class='fas fa-trash-alt'></i></a></td>"
                                   +"</tr>";
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
    lvEvlMatDelLst=[];
    function <?= $lv_sec; ?>_removeRow(e) {
			$(e).parent().parent().remove();
		}
    function <?= $lv_sec; ?>_removeRowEdit(e,id) {
      var lvEvlMatDel = $("#<?=$lv_sec; ?> #evlmatdel").val();
      if(lvEvlMatDel===""){
        lvEvlMatDelLst=[];
      }else{
      	lvEvlMatDelLst = lvEvlMatDel.split(';');
      }
      lvEvlMatDelLst.push(id);
      
      $("#<?=$lv_sec; ?> #evlmatdel").val(lvEvlMatDelLst.join(';'))
    	//toastr.warning('Eliminar id: ' + id); 
      console.log( $("#<?=$lv_sec; ?> #evlmatdel").val());
			$(e).parent().parent().remove();
		}
  </script>
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
    function <?= $lv_sec; ?>_formatFileSize(lp_size){
      if (lp_size < 1024) {
        return lp_size + " B";
      }
      var lv_kb = lp_size / 1024;
      if (lv_kb < 1024) {
        return lv_kb.toFixed(1) + " KB";
      }
      var lv_mb = lv_kb / 1024;
      return lv_mb.toFixed(1) + " MB";
    }

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
            var lv_flesiz = <?= $lv_sec; ?>_formatFileSize(lo_datflelst[i].size);
            var lv_row = "<tr name='dlvrow' data-flenme= '" + lv_flenme + "'>"
                          +"<td>Archivo "+ (i+1) +" : </br><strong>"+lv_fletxt +"</strong> (" + lv_flesiz + ")</td>"
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
      if(lp_prm['errtyp']=='E' && lp_prm['errtxt']!='' ){
          toastr.warning(lp_prm['errtxt']); 
          return false;
        }
      
      if(gv_<?php echo $lv_sec; ?>_last_action=="evlinf00"){
        
        if(lp_prm['errtyp']=='E'){
          toastr.warning(lp_prm['errtxt']); 
          return false;
        }
        
      }
      if ( gv_<?php echo $lv_sec; ?>_last_action=="evlinf04") {
        //toastr.warning(lp_prm['errtxt']); 
        if(lp_prm['errtyp']=='E'){
          toastr.warning(lp_prm['errtxt']); 
          return false;
        }
        
      }
      if ( gv_<?php echo $lv_sec; ?>_last_action=="02") {
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
				if (lp_prm["action"]=="evlinfx4") {
					BootstrapDialog.confirm({
						title: 'Borrar Evolucion',
						message: '¿Desea borrar el documento?',
						type: BootstrapDialog.TYPE_WARNING,
						callback: function(result) {
							if(result) { <?php echo $lv_sec; ?>_fnc({action: "evlinf04"}); }
						}
					});
					return false;
				}
				if (lp_prm["action"]=="evlinf00" ) {
          if ($("#<?php echo $lv_sec; ?> #evlinfprc").prop("value")=="1"){
            var lv_err = 0;
            var lo_trid = $("#<?= $lv_sec; ?> #tbldat tr[name='dlvrow']").length;
            var lo_datarr = $("#<?= $lv_sec; ?> #tbldat tr[name='dlvrow']");
            var lv_arr = new Array();
            var lv_mattxt = $("#<?=$lv_sec; ?> #mattxt").val();
            var lv_matcod = $("#<?=$lv_sec; ?> #matcod").val();
            var lv_evlevl = $("#<?=$lv_sec; ?> #evlevl").val();
            var lv_matdos = $("#<?=$lv_sec; ?> #matdos").val();
            
            // VALIDO DOSIS
            $("#<?=$lv_sec; ?> #matdos").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if ( (lv_matdos=="" || lv_matdos =="0") && lv_fldrec.includes("matdos") ) {
              //toastr.warning( "Complete el campo Evolucion" ); 
              $("#<?=$lv_sec; ?> #matdos").parentsUntil(".tmss-form-group").parent().addClass("has-error");
              lv_err++;
						}
            $("#<?=$lv_sec; ?> #evlevl").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if ( lv_evlevl==""  && lv_fldrec.includes("evlevl") ) {
              //toastr.warning( "Complete el campo Evolucion" ); 
              $("#<?=$lv_sec; ?> #evlevl").parentsUntil(".tmss-form-group").parent().addClass("has-error");
              lv_err++;
						}
						$("#<?=$lv_sec; ?> #patwgt").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
						if($("#<?=$lv_sec; ?> #patwgt").val()=="" && lv_fldrec.includes("patwgt")){
              $("#<?=$lv_sec; ?> #patwgt").parentsUntil(".tmss-form-group").parent().addClass("has-error");
              lv_err++;
            }
            
            var lv_fvrpt = $("#<?=$lv_sec; ?> #fvrpt").val();
            $("#<?=$lv_sec; ?> #fvrpt").parentsUntil(".tmss-form-group").parent().removeClass("has-error");
            if ( lv_fvrpt==""  && lv_fldrec.includes("fvrpt") ) {
              $("#<?=$lv_sec; ?> #fvrpt").parentsUntil(".tmss-form-group").parent().addClass("has-error");
              lv_err++;
						}
            //Agrego los materiales
            for (var i=0; i<lo_datarr.length; i++) {
              var lv_evlmatcod=$(lo_datarr[i]).data("evlmatcod")??0;
              lv_arr.push({	"evlmatcod":lv_evlmatcod,
                            "matcod":$(lo_datarr[i]).data("matcod"),
                            "mattxt":$(lo_datarr[i]).data("mattxt"),
                            "matqty":$(lo_datarr[i]).data("matqty"),
                            "matuntcod":"UN",
                            "matbchcodext":$(lo_datarr[i]).data("matbchcodext"),
                            "matbchduedte":$(lo_datarr[i]).data("matbchduedte"),
                            "atrstrtme":"",
                            "atrendtme":"",
                            "deleted":"",
                            "atradvrea":""
                          });
            }
            $("#<?=$lv_sec; ?> #btnaddmat").css("border-radius", "");
            $("#<?=$lv_sec; ?> #btnaddmat").css("background-color", "");
            $("#<?=$lv_sec; ?> #btnaddmat").css("color", "");
            if ( lv_arr.length==0 && lv_fldrec.includes("tbldat") ) { 
              $("#<?=$lv_sec; ?> #btnaddmat").css("border-radius", "50px");
              $("#<?=$lv_sec; ?> #btnaddmat").css("background-color", "#ff000026");
              $("#<?=$lv_sec; ?> #btnaddmat").css("color", "red");
              //toastr.warning("Debe indicar al menos un madicamento con lote y vencimiento"); 
              //return false; 
              lv_err++;
            }
            for (var i=0; i<lvEvlMatDelLst.length; i++) {
              lv_arr.push({	"evlmatcod":lvEvlMatDelLst[i],
                            "deleted":1
                          });
            }
            
            $("#<?php echo $lv_sec; ?> #evlmat").text( (lv_arr.length==0?"":JSON.stringify(lv_arr)) );
            $("#<?php echo $lv_sec; ?> #evlcnccmt").text( (lv_arr.length==0?"":JSON.stringify(lv_arr)) );

            /* Subida de archivo */ 
          
            var lo_dat = new FormData();
            var lv_frmarr = $("#<?= $lv_sec; ?>_frm").serializeArray();
            for(var i=0; i<lv_frmarr.length; i++){ lo_dat.append(lv_frmarr[i].name,lv_frmarr[i].value); }
            var lv_fleqty=lo_datflelst.length;
            $("#<?=$lv_sec; ?> #btnupload").css("border-radius", "");
            $("#<?=$lv_sec; ?> #btnupload").css("border-color", "");
            $("#<?=$lv_sec; ?> #btnupload").css("background-color", "");
            var lv_filemax = 20 * 1024 * 1024;
            var lv_totalmax = 40 * 1024 * 1024;
            var lv_totalsize = 0;
            for (var i = 0; i < lv_fleqty; i++) {
              lv_totalsize += lo_datflelst[i].size;
              if (lo_datflelst[i].size > lv_filemax) {
                $("#<?=$lv_sec; ?> #btnupload").css("border-radius", "6px");
                $("#<?=$lv_sec; ?> #btnupload").css("border-color", "red");
                $("#<?=$lv_sec; ?> #btnupload").css("background-color", "#ff000026");
                toastr.warning("Un archivo supera los 20 MB. Elimine o reduzca el tamaño.");
                return false;
              }
            }
            if (lv_totalsize > lv_totalmax) {
              $("#<?=$lv_sec; ?> #btnupload").css("border-radius", "6px");
              $("#<?=$lv_sec; ?> #btnupload").css("border-color", "red");
              $("#<?=$lv_sec; ?> #btnupload").css("background-color", "#ff000026");
              toastr.warning("El total de archivos supera los 40 MB. Elimine o reduzca el tamaño.");
              return false;
            }
            if ( lv_fleqty==0  && lv_fldrec.includes("uplfle") && "<?=$vew_actcod;?>" != "02") { 
              $("#<?=$lv_sec; ?> #btnupload").css("border-radius", "6px");
              $("#<?=$lv_sec; ?> #btnupload").css("border-color", "red");
              $("#<?=$lv_sec; ?> #btnupload").css("background-color", "#ff000026");
              //toastr.warning("No existen archivos cargados"); 
              //return false; 
              lv_err++;
            }
            for (var i = 0; i < lv_fleqty; i++) {
              lo_dat.append("archivo_" + i,lo_datflelst[i]);
            }  
            if(lv_err>0){
              toastr.warning( "Complete los campos obligatorios.<br>Incompletos ("+lv_err+")." );
              return false; 
            }
            if(!tmssFormValidation($("#<?php echo $lv_sec; ?>_frm"))){return false;}
             /* Llamada al controlaor */
            //tmssCallProcessFile("?prg=zcutp1_ttr&act=evlinf00", lo_dat, <?= $lv_sec; ?>_fncbckext);
            tmssCallProcessFile("?prg=<?= $vew_data->endpoint; ?>&act=evlinf00", lo_dat, <?= $lv_sec; ?>_fncbckext);
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
        //console.log(position.coords.latitude, position.coords.longitude);
        //console.log(<?php echo $lv_sec; ?>);
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

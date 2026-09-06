<?php
	// url del formulario
  $lv_lnk = "?prg=buyinv&prm_buyinvcod=".$vew_data->buyinvcod.'&prm_mdlcod='.$vew_data->mdlcod.'&prm_prgcod='.$vew_data->prgcod;

	// campos requeridos 
	$vew_input->RequiredFields( array('srcobjtyp','srcobjcod','srcobjtxt','buyinvdte', 'curcod', 'docsts') );

	// clave del documento
	$lv_dockey = $vew_data->buyinvcod; 

	// titulo
	$lv_title = $vew_lang->document;
	
	// modulo y programa
	$lv_mdlcod = $vew_data->mdlcod;
	$lv_prgcod = $vew_data->prgcod;
	
	// librería de estilos bootstrap
	include_once('_library.frm');
	
	$lv_objtyp = $vew_data->mdlcod.'_'.$vew_data->prgcod;
	$lv_prcschcod = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prcschcod');
	$lv_prccndcod = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prccndcod');
	$lv_prcschcndrow = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prccndcodctr');
	if($lv_prcschcod==''){$lv_prccndcod='';}
	$lv_refdoccls = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'refdoccls');
	$lv_refdocmdt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'refdocmdt');
	$lv_matcodtxt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'matcod_txt');
	$lv_docref = false;	// documento referencia a otro documento
	$lv_docrefsrc = false; // documento es referenciado por otro documento
	foreach($vew_data->buyinvmat as $lv_row){ 
		if ($lv_row['docreftyp']!=''){ $lv_docref=true; }
		if ($lv_row['refposqty']!=''){ $lv_docrefsrc=true; }
	}	
	
	$lv_rejarr = array(''=>'');
	foreach($vew_data->sysdoccls->sysdocclsrej as $lv_row) {
		if (strtoupper($vew_doc->getTagValue($lv_row['sysdocclsrejatr'],'rejman'))=='X'){
			$lv_rejarr[ $lv_row['sysdocrejcod'] ] = $lv_row['sysdocrejtxt'];
		}
	}
	$lv_mat_sysdocclscod = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'stkmat_sysdocclscod');

	$vew_tbl['accL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09'), 'acc'=>false, 'id'=>'btnacc');
	$vew_tbl['accR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09'), 'acc'=>false, 'id'=>'btnacc');
	$vew_tbl['modL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02') );
	$vew_tbl['modR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02') );
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">

  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		<?= gethtml('tmss_actcod', 'hidden', '') ?>
		<textarea class="hidden" id="buyinvprc" name="buyinvprc"><?= json_encode($vew_data->buyinvprc,true); ?></textarea>
		<textarea class="hidden" id="buyinvmat" name="buyinvmat"></textarea>
    
    <?= gethtml('prcschcod', 'hidden', $lv_prcschcod) ?>
    <?= gethtml('buysuponetme', 'hidden', $vew_data->buysuponetme) ?>
    <?= gethtml('doccntjson', 'hidden', '') ?>
    
    <div class="container-fluid" role="tabpanel"> 
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>				
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->data; ?></a></li>
				<?php if($lv_prcschcod!=''){ ?><li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->prices; ?></a></li><?php } ?>
        <li role="presentation"><a href="#<?= $lv_sec; ?>_tab004" role="tab" data-toggle="tab"><?= $vew_lang->interlocutors; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->buyinvcod; ?><?= gethtml('buyinvcod','hidden',$vew_data->buyinvcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
          
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
            <div class="col-md-6">
              
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= (strtoupper($lv_prgcod)=='INV'?$vew_lang->invoice:(strtoupper($lv_prgcod)=='CRE'?$vew_lang->creditnote:(strtoupper($lv_prgcod)=='DEB'?$vew_lang->debitnote:$lv_prgcod))); ?>
                    <span class="tmss-card-icon">
                      <span><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
                      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
                    </span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                    <?php
                      echo gethtml('srcobjtyp','hidden', ($vew_data->buyexpcod!=''?$vew_data->srcobjtyp:$vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'srcobjtyp')) );
                      $lv_srcobjtyp = strtoupper($vew_doc->getTagValue( $vew_data->sysdoccls->sysdocclsatr, 'srcobjtyp' ));
                      if ($lv_srcobjtyp=='BUY_SUP'){
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->supplier, 
                                                        'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($lv_docref || $lv_docrefsrc?true:$vew_readonly) ),
                                                                            array('input'=>gethtml('srcobjtxt', 'typeahead', $vew_data->srcobjtxt,($lv_docref || $lv_docrefsrc?$lv_always_disabled:$lv_default) ) )),
                                                        ));
                      }
                      echo gethtml('srcobjcod','hidden',$vew_data->srcobjcod);
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('buyinvtxt', 'doccmt1x50', $vew_data->buyinvtxt, $lv_default) ));
                    ?>
                </div>
              </div> <!-- card -->
            </div>
            <div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?php if($vew_data->sysdoctrecod=='N'){ ?><span><span class="far fa-circle"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod=='P'){ ?><span class="text-warning"><span class="far fa-circle-half-stroke"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod=='C'){ ?><span class="text-success"><span class="fas fa-circle"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod==''){ echo '&nbsp;'; } ?>
                  	<span class="tmss-card-icon">
                    	<?= '<b><span id="buyinvtotlbl">'.number_format(floatval($vew_data->buyinvtotamt),2).'</span></b> '.strtolower($vew_data->curcod); ?>
                      <?= gethtml('curcod', 'hidden', $vew_data->curcod); ?>
											<?= gethtml('buyinvtot', 'hidden', $vew_data->buyinvtotamt); ?>
                    </span>
                  </div>
                </div>

                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('buyinvdte',	'docdte',	$vew_data->buyinvdte,	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 'input'=>gethtml('buyinvcodext','doccmt1x20',$vew_data->buyinvcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', ($vew_readonly?'docstsacc':'docsts'),	$vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div> <!-- /card -->
            </div> <!-- /col -->
					</div> <!-- /row -->
          
          <div class="card tmss-hot-ttl">
            <div class="card-header">
              <div class="card-title">
                <?= $vew_lang->materials ?>
                <?php if ($lv_refdoccls!='') { ?><a href="#" id="btndocref" class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" title="<?= $vew_lang->reference; ?>"><i class="fas fa-plus"></i></a><?php } ?>
              </div>
            </div>
          </div> <!-- /card -->
          <div  id="buyinvmathot" name="buyinvmathot"></div> 
				</div> <!-- /tab001 -->
        
        
        <!-- PRECIOS -->
        <div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
					<div class="row">
						<div class="col-sm-12">
              <div class="card tmss-hot-ttl">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->prices; ?>
                    <small class="tmss-desk-btn pull-right"><?= $vew_lang->exchangerate.': <strong>'.(is_string($vew_data->curexcrte)?$vew_data->curexcrte:number_format($vew_data->curexcrte, 5)).'</strong>'; ?></small>
                    <small class="tmss-mob-btn pull-left fs-11"><?= $vew_lang->exchangerate.': <strong>'.(is_string($vew_data->curexcrte)?$vew_data->curexcrte:number_format($vew_data->curexcrte, 5)).'</strong>'; ?></small>
                  </div>
                </div>
              </div> <!-- /card -->
              <div id="divprcgrd"></div>
            </div> <!-- /col -->
					</div> <!-- /row -->
				</div> <!-- /tab003 -->
        
				
				<!-- DATOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<div class="row">
						<div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->conditions; ?>
                    <span class="tmss-card-icon">
                      <i class="fas fa-coins"></i>
                    </span>
                  </div>
                </div>

                <div class="card-body tmss-card-body-edit">
                  <?php
                   	echo vew_boot($lv_col210, array('label'=>$vew_lang->paymentstermshort,
                    	                               'input'=>vew_boot(array('style'=>'search','readonly'=>$vew_readonly),
                      	                                               array('input'=>gethtml('paytrmtxt', 'doccmt1x50', $vew_data->paytrmtxt, $lv_default) )),
                        	                          ));
                		echo vew_boot($lv_col210, array('label'=>$vew_lang->exchangerate,'input'=>gethtml('curexcrte', 'docnum0905', $vew_data->curexcrte, $lv_always_disabled) ));
                  	echo gethtml('paytrmcod','hidden',$vew_data->paytrmcod);
                  ?>
                </div>
              </div> <!-- card -->
						</div>
            <div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->validity; ?>
                    <span class="tmss-card-icon">
                      <i class="fas fa-calendar"></i>
                    </span>
                  </div>
                </div>

                <div class="card-body tmss-card-body-edit">
                  <?php
                  	echo vew_boot($lv_col2424, array('label'=>$vew_lang->from, 'input1'=>gethtml('buyinvstrdte',	'docdte',	$vew_data->buyinvstrdte,	$lv_default), 'label2'=>$vew_lang->to, 'input2'=>gethtml('buyinvenddte',	'docdte',	$vew_data->buyinvenddte,	$lv_default) ));
										echo vew_boot($lv_col210, array('label'=>$vew_lang->fiscalcategory, 'input'=>gethtml('taxcattxt', 'taxcattxt', '', $lv_always_disabled) )); 
                  	echo gethtml('taxcatcod', 'hidden','');
                   	echo vew_boot($lv_col210, array('label'=>$vew_lang->rejection,	'input'=>gethtml('sysdocrejcod', $lv_rejarr, $vew_data->sysdocrejcod, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->accountingDate, 'input'=>gethtml('buyinvaccdte',	'docdte',	$vew_data->buyinvaccdte, $lv_default) ));
                  ?>
                </div>
              </div> <!-- card -->
						</div>
					</div>
				</div>
        
        <!-- INTERLOCUTORES -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab004">
					<?php include('grldoccntlst.frm'); ?>
				</div>
				
			</div> <!-- tabcontent -->     
		</div> <!-- container-fluid --> 
  </form>
	<script>		
		var <?= $lv_sec; ?>_paste = false;
		
		// cargo precios de cabecera del documento
		$(function(){
			var lv_dochdr = {};
			var lv_tmparr = $("#<?= $lv_sec; ?>_frm").serializeArray();
			for(var i=0; i<lv_tmparr.length; i++){ if(lv_tmparr[i]["name"] != "buyinvprc") lv_dochdr[ lv_tmparr[i]["name"] ] = lv_tmparr[i]["value"]; }
      
      for(var i=0; i<lv_tmparr.length; i++){ if(lv_tmparr[i]["name"] == "buyinvprc") var lv_docprc = lv_tmparr[i]["value"]; }

			var lv_pstdat=[ {name:"dochdr",value:JSON.stringify(lv_dochdr)}, 
											{name:"docpos",value:JSON.stringify("{}")}, 
											{name:"docprc",value:lv_docprc.replaceAll("\\", "")},
											{name:"sec",value:"<?= $lv_sec; ?>"},
											{name:"readonly",value:"true"}
										];
      <?php if( $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prcschcod') != '' )  { ?>
        tmssCallProcess("?prg=grldatprc&act=02",lv_pstdat,function(data){
          $("#<?= $lv_sec; ?> #divprcgrd").html( data );
        });
      <?php } ?>
		});
		

    // REFRESH HEADER PRICES
		// actualiza precios de la cabecera del documento
		function <?= $lv_sec; ?>_refreshHeaderPrices() {
			if(<?= $lv_sec; ?>_hotdoc==undefined){return false;}
			if(typeof(<?= $lv_sec; ?>_hot_grldatprc) === "undefined"){return false;}
			if(<?= $lv_sec; ?>_paste!=false){return false;}
			
			// obtengo datos
			var lv_docprc = [];
			var lv_tmp = <?= $lv_sec; ?>_hotdoc.getSourceData();
			for(var i=0; i<lv_tmp.length; i++){
				if(typeof lv_tmp[i]["buyinvmatprc"]!="undefined"){
					lv_docprc.push( JSON.parse( lv_tmp[i]["buyinvmatprc"] ) );
				}
			}
			
			// proceso totales
			var lv_out = [];
      var lv_prcntout = [];
			for(var i=0; i<lv_docprc.length; i++){
				if(lv_out.length==0){
					for(var x=0; x<lv_docprc[i].length; x++){
            lv_docprc[i][x]["prccndrowcod"] = null;
            // se guarda en un array que tiene como clave el valor del porcentaje los datos de esa fila
            if(lv_docprc[i][x]["prccnduntcod"] == "%"){
            	lv_prcntout[lv_docprc[i][x]["prccndqty"]] = lv_docprc[i][x];
            }
            lv_docprc[i][x]["prccndqty"] = Number(lv_docprc[i][x]["prccndqty"]);
            lv_docprc[i][x]["prccndval"] = Number(lv_docprc[i][x]["prccndval"]);
            lv_out.push( lv_docprc[i][x] );
          }
				} else {
					for(var x=0; x<lv_out.length; x++){
            if(lv_docprc[i] != null){
            	for(var y=0; y<lv_docprc[i].length; y++){
                if(lv_out[x]["prcschcndrow"]==lv_docprc[i][y]["prcschcndrow"]){
                  // si se está guardando un porcentaje, busca si ya existe en el array de porcentajes y lo suma
                  // si no existe, crea una fila en el array de porcentajes con el valor del porcentaje como clave
                  if (lv_docprc[i][y]["prccnduntcod"] == "%"){
                    if(lv_prcntout[lv_docprc[i][y]["prccndqty"]] == undefined){
                      lv_prcntout[lv_docprc[i][y]["prccndqty"]] = lv_docprc[i][y];
                    }else{
                      lv_prcntout[lv_docprc[i][y]["prccndqty"]]["prccndtot"] = Number(lv_prcntout[lv_docprc[i][y]["prccndqty"]]["prccndtot"]) + Number(lv_docprc[i][y]["prccndtot"]);
                    }
                  }else{
                    lv_out[x]["prccndtot"] = Number(lv_out[x]["prccndtot"]) + Number(lv_docprc[i][y]["prccndtot"]); 
                  }
                }
              } 
            }
					}
				}
			}
      
      // se eliminan las filas de porcentaje que se crean por defecto en el primer material 
      // (deben mantenerse hasta este momento para que funcione el resto del programa)
      for(var x=0; x<lv_out.length; x++){
        if (lv_out[x]["prccnduntcod"] == "%"){
          lv_out.splice(x,1);
        }
      }

      for (var key in lv_prcntout) {
        lv_out.push(lv_prcntout[key]);
      }
      
      // se ordena el array con los nuevos datos de porcentaje
      lv_out.sort((a, b) => (a.prcschcndrow > b.prcschcndrow) ? 1 : -1)
			
			// determino salida
			var lv_tot = 0;
			for(x=0;x<lv_out.length;x++){
				if(lv_out[x]["prcschcndrow"]=="<?= $lv_prcschcndrow; ?>"){ lv_tot += lv_out[x]["prccndtot"]; }
			}
			$("#<?= $lv_sec; ?> #buyinvtotlbl").text( lv_tot.toLocaleString('en-US', {minimumFractionDigits: 2}) );
			<?= $lv_sec; ?>_hot_grldatprc.loadData( lv_out );
      $("#<?= $lv_sec; ?> #buyinvtot").val( lv_tot );
		}
		
		
		
		// REFRESH ALL PRICES
		// actualiza todas las posiciones
		function <?= $lv_sec; ?>_refreshAllPrices(){
			for(var i=0; i < <?= $lv_sec; ?>_hotdoc.getSourceData().length; i++){
				<?= $lv_sec; ?>_refreshPrices( i );
			}
      // Si se eliminan todas las filas
      if (<?= $lv_sec; ?>_hotdoc.getSourceData().length == 0){
        <?= $lv_sec; ?>_refreshHeaderPrices();
      }
		}
		
		
		
		// REFRESH PRICES
		// actualiza precios de la posición del documento
		function <?= $lv_sec; ?>_refreshPrices( lv_row ) {
			if(<?= $lv_sec; ?>_hotdoc==undefined){ return false; }
			if(lv_row==undefined){ <?= $lv_sec; ?>_refreshAllPrices(); }
			if(<?= $lv_sec; ?>_paste!=false){return false;}
			var lv_dochdr = {};
			var lv_docpos = [];
			var lv_docprc = [];
			
			// determino si la fila puede ser actualizada
			var lv_data = <?= $lv_sec; ?>_hotdoc.getSourceData();
			if( !(lv_row<lv_data.length) ){ return false; }
			
			// completo datos de cabecera con los datos del formulario
			var lv_tmparr = $("#<?= $lv_sec; ?>_frm").serializeArray();
			for(var i=0; i<lv_tmparr.length; i++){ lv_dochdr[ lv_tmparr[i]["name"] ] = lv_tmparr[i]["value"]; }
			
			// cargo la posicion actual y el precio actual para el calculo
			lv_docprc = JSON.parse( (typeof lv_data[lv_row]["buyinvmatprc"]!="undefined"?lv_data[lv_row]["buyinvmatprc"]:"[]") );
			if(typeof lv_data[lv_row]["buyinvmatprc"]!="undefined"){ delete lv_data[lv_row]["buyinvmatprc"]; }
			lv_docpos = lv_data[lv_row];
			
			// llamada a funcion para calcular precios
      var lv_pstdat=[ {name:"dochdr",value:JSON.stringify(lv_dochdr)}, 
                      {name:"docpos",value:JSON.stringify(lv_docpos)}, 
                      {name:"docprc",value:JSON.stringify(lv_docprc)},
                      {name:"readonly",value:<?= ($vew_readonly?'true':'false'); ?>}
                    ];
      <?php if( $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prcschcod') != '' )  { ?>
        tmssCallProcess("?prg=buyinv&act=calc",lv_pstdat,function(data){
          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row, "buyinvmatprc", JSON.stringify(data["docprc"]) );
          <?= $lv_sec; ?>_refreshHeaderPrices();
        });
    	<?php } else { ?>
    		var lv_grltot = 0;
    		for(var i = 0; i < lv_data.length; i++) {
          if( (lv_data[i]["matqty"] != "" && lv_data[i]["matqty"] != null) && (lv_data[i]["matprc"] != "" && lv_data[i]["matprc"] != null)){
          	lv_grltot += lv_data[i]["matqty"] * lv_data[i]["matprc"];  
          }
        }
        $("#<?= $lv_sec; ?> #buyinvtotlbl").text( lv_grltot.toLocaleString('en-US', {minimumFractionDigits: 2}) );
    	//	$("#<?= $lv_sec; ?> #buyinvtot").val( lv_tot );
    	<?php } ?>
		}
		
		// actualiza precios - control de cambios del documento
		$("#<?= $lv_sec; ?> #srcobjcod, #<?= $lv_sec; ?> #paytrmcod, #<?= $lv_sec; ?> #curcod, #<?= $lv_sec; ?> #buyinvdte").on("change",function(e){
			if (<?= $lv_sec; ?>_paste==false){ <?= $lv_sec; ?>_refreshPrices(); }
		});
	</script>
	<script>
		// CONTABILIZAR
		$("#<?= $lv_sec; ?> #btnacc").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm({
				title: "<?= $vew_lang->accounting; ?>",
				message: "&iquest;Desea contabilizar el documento?",
				type: BootstrapDialog.TYPE_WARNING,
				callback: function(result) { if(result) { <?= $lv_sec; ?>_fnc({action: "09"}); } }
			});
		});
		
		// paytrmtxt - typeahead
		var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"docsts" : "A", "paytrmgrp" : "(like)A"}, "fldasg" : {"paytrmtxt" : "paytrmtxt", "paytrmcod" : "paytrmcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #paytrmtxt"), "finpaytrm", lo_get);
		
    function <?= $lv_sec; ?>_srcobjtxtAfterAssign(data){
      if(data.$modal === undefined){
        // levantar popup
      	$("#<?= $lv_sec; ?> #buysuponetme").change();
      }
      // limpiar contactos viejos
      $("#<?= $lv_sec; ?> #grldoccnttbl > tbody > tr").empty();
    }
    
		<?php if ($lv_srcobjtyp=='BUY_SUP'){ ?>
			// srcobjtxt
    	var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"srcobjcod":"supcod", "srcobjtxt":"suptxt", "paytrmcod":"paytrmcod","paytrmtxt":"paytrmtxt", "taxcatcod":"taxcatcod", "buysuponetme":"buysuponetme"}};
      tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "buysup", lo_get, {"afterAssign": <?= $lv_sec; ?>_srcobjtxtAfterAssign });
		<?php } ?>
    
   
    //MOSTRAR POPUP DE SELECCIÓN DE CONTACTO
    $("#<?= $lv_sec; ?> #buysuponetme").change(function(){
      if ($(this).val() == 1){
        // si es un proveedor one time
        $("#<?= $lv_sec; ?> #grldoccntonetme").val("1");
        $("#<?= $lv_sec; ?> #grldoccntbtnnew").trigger("click");
      }else{
        if($("#<?= $lv_sec; ?> #srcobjcod").val()==""){
          return;
        }
        var lv_pstdat=[ {name:"srcobjtyp",	value: "<?= $lv_mdlcod."_".$lv_prgcod; ?>" },
                        {name:"srcobjcod",	value: "<?= $lv_dockey; ?>" },
                        {name:"mdlcod",	value: "buysup" },
                        {name:"mdlid",	value: "supcod" },
                        {name:"sysdocclscod",	value: $("#<?= $lv_sec; ?> #sysdocclscod").val() },
                        {name:"grldoccntobjtyp",	value: $("#<?= $lv_sec; ?> #srcobjtyp").val() },
                        {name:"grldoccntobjcod",value:$("#<?= $lv_sec; ?> #srcobjcod").val()}
                      ];
        tmssCallProcess("?prg=grldoccnt&act=choosecnt", lv_pstdat, function(data){ 
          if (data.errcod) {
            return;
          }
          if(Array.isArray(data)){
            // tiene un único contacto. Creación automática de pares interlocutor-contacto
            lv_buffer = "";
            for( var i=0; i<data.length; i++){
              data[i][0].srcobjtyp = "<?= $lv_mdlcod."_".$lv_prgcod; ?>";
              data[i][0].srcobjcod = "<?= $lv_dockey; ?>";
              data[i][0].grldoccntobjtyp = data[i][0].cntsrctyp;
              data[i][0].grldoccntobjcod = data[i][0].cntsrccod;
              data[i][0].grldoccntobjtxt = data[i][0].cnttxt;
              lv_buffer += "<tr data-id=''>";
              lv_buffer += "<td width='60' style='vertical-align: middle;'><img src='/library/images/icon_profile.png' class='img-responsive img-circle img-thumbnail'></td>";
              lv_buffer += "<td style='vertical-align: middle;' data-cntcod='"+data[i][0].cntcod+"'><a href='#' name='grldoccnttxt' data-id=''><h5><strong class='grldoccntobjtxt'>"+data[i][0].cnttxt+"</strong><br><small>"+data[i][0].sysdocclstxtcnt+"</small></h5></a></td>";
              lv_buffer += "<td style='vertical-align: middle;' class='hidden-xs'><a href='#'>"+data[i][0].adreml+"</a></td>";
              lv_buffer += "<td style='vertical-align: middle;' class='hidden-xs hidden-sm'><a href='#''>"+data[i][0].adrphn001+"</a></td>";
              lv_buffer += "<td style='vertical-align: middle;' class='hidden-xs hidden-sm hidden-md'><a href='#'>"+data[i][0].adrmblphn+"</a></td>";
              lv_buffer += "<td class='hidden'><input type='hidden' class='grldoccntfrm' name='grldoccntfrm' value='"+JSON.stringify(data[i][0])+"'></td>";

              <?php if( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && !$vew_readonly) { ?> 
                lv_buffer += "<td width='60' style='vertical-align: middle;' class='text-center'><a href='#' id='grldoccntdellnk' class='btn btn-danger' title='<?= $vew_lang->delete; ?>'><span class='fas fa-trash-alt'></span></a></td>";
              <?php } ?>
              lv_buffer += "</tr>";
            }
            $("#<?= $lv_sec; ?> #grldoccnttbl tbody").html( lv_buffer );
            <?= $lv_sec ?>_attachEvents();
          }else{
            // tiene múltiples contactos. Selección de pares contacto-interlocutor
            BootstrapDialog.show({
              size: BootstrapDialog.SIZE_WIDE,
              title: "Elegir contacto",
              message: $(data),
              closable: false,
              buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
                        {	label: "<?= $vew_lang->add; ?>", cssClass: "btn-success",	action: function(dialogItself){
                          $(dialogItself.$modalBody).find(".cnttyp").length;

                          lv_buffer = "";
                          for( var i=0; i<$(dialogItself.$modalBody).find(".cnttyp").length; i++){
                            lv_element = $(dialogItself.$modalBody).find(".cnttyp")[i];
                            lv_buffer += "<tr data-id=''>";
                            lv_buffer += "<td width='60' style='vertical-align: middle;'><img src='/library/images/icon_profile.png' class='img-responsive img-circle img-thumbnail'></td>";
                            lv_buffer += "<td style='vertical-align: middle;' data-cntcod='"+$(lv_element).data("cntcod")+"'><a href='#' name='grldoccnttxt' data-id=''><h5><strong class='grldoccntobjtxt'>"+$(lv_element).data("cnttxt")+"</strong><br><small>"+$(lv_element).data("sysdocclstxtcnt")+"</small></h5></a></td>";
                            lv_buffer += "<td style='vertical-align: middle;' class='hidden-xs'><a href='#'>"+$(lv_element).data("adreml")+"</a></td>";
                            lv_buffer += "<td style='vertical-align: middle;' class='hidden-xs hidden-sm'><a href='#''>"+$(lv_element).data("adrphn001")+"</a></td>";
                            lv_buffer += "<td style='vertical-align: middle;' class='hidden-xs hidden-sm hidden-md'><a href='#'>"+$(lv_element).data("adrmblphn")+"</a></td>";
                            lv_buffer += "<td class='hidden'><input type='hidden' class='grldoccntfrm' name='grldoccntfrm' value='"+$(lv_element).data("grldoccntfrm")+"'></td>";

                            <?php if( $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04') && !$vew_readonly) { ?> 
                              lv_buffer += "<td width='60' style='vertical-align: middle;' class='text-center'><a href='#' id='grldoccntdellnk' class='btn btn-danger' title='<?= $vew_lang->delete; ?>'><span class='fas fa-trash-alt'></span></a></td>";
                            <?php } ?>
                            lv_buffer += "</tr>";
                          }
                          $("#<?= $lv_sec; ?> #grldoccnttbl tbody").html( lv_buffer );
                          <?= $lv_sec ?>_attachEvents();

                          dialogItself.close();
                        }}]
            });
          }
        });
      }
    });
    

		// AGREGAR REFERENCIA
		$("#<?= $lv_sec; ?> #btndocref").on("click",function(e){ e.preventDefault(); 
			if ( $("#<?= $lv_sec; ?> #srcobjcod").prop("value")=="" ) {
				toastr.warning("Debe indicar el origen.");
				$("#<?= $lv_sec; ?> #srcobjtxt").focus();
			} else {
				// obtengo los IDs de los documentos referenciados previamente y que no hayan sido grabados
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_refarr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( (lo_dat[i]["buyordmatcod"]==undefined?"":lo_dat[i]["buyordmatcod"])=="" && (lo_dat[i]["docreftyp"]==undefined?"":lo_dat[i]["docreftyp"])!="" ) {
						lv_refarr.push({"srcobjtyp":lo_dat[i]["docreftyp"],
													"srcobjcod":lo_dat[i]["docrefcod"],
													"srcposcod":lo_dat[i]["docrefposcod"],
													"refposqty":lo_dat[i]["matqty"]
												});
					}
				}
				// cargo la pantalla de referencia
				var lv_dat = "";
				tmssCallProcess("?prg=grldocflw&act=01", 
					{	sysdocclscod: "<?= $vew_data->sysdoccls->sysdocclscod; ?>",
						refobjtyp: "<?= $lv_objtyp; ?>",
						refobjcod: "<?= $vew_data->buyinvcod; ?>",
						fndobjtyp: $("#<?= $lv_sec; ?> #srcobjtyp").prop("value"),
						fndobjcod: $("#<?= $lv_sec; ?> #srcobjcod").prop("value"),
						fndobjtxt: $("#<?= $lv_sec; ?> #srcobjtxt").prop("value"),
						fndcntcod: $("#<?= $lv_sec; ?> #srccntcod").prop("value"),
						fndcnttxt: $("#<?= $lv_sec; ?> #srccnttxt").prop("value"),
						refarr: JSON.stringify(lv_refarr)	},
					function(data){
						lv_dat = data;
						var lv_objtxt = $("#<?= $lv_sec; ?> #srcobjtxt").prop("value");
						var lv_cnttxt = $("#<?= $lv_sec; ?> #srccnttxt").prop("value");
						BootstrapDialog.show({
							size: BootstrapDialog.SIZE_WIDE,
							title: "Agregar Referencia - <?= $vew_data->sysdoccls->sysdocclstxt; ?> ("+lv_objtxt+(lv_cnttxt==""?"":" / "+lv_cnttxt)+") ",
							message: $(lv_dat),
							buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
												{	label: "<?= $vew_lang->add; ?>", cssClass: "btn-success",	action: function(dialogItself){
													if ( dialogItself.getModalBody().find("#rowchk:checked").length==0 ) {
														toastr.warning("Debe indicar al menos una posción de referencia.");
													} else if ( dialogItself.getModalBody().find("form")[0].checkValidity()==false ) {
														toastr.warning("Las cantidades a referenciar no pueden ser cero ni exceder el saldo a referenciar.");
														dialogItself.getModalBody().find("input").each( function(e) {
															if ( !$(this)[0].validity.valid ) { $(this).parent().addClass("has-error"); }
														});
													} else {
														var lv_data = <?= $lv_sec; ?>_hotdoc.getSourceData();
                            if(lv_data.length != 0){
                              if(lv_data[lv_data.length-1].mattxt == undefined){
                                lv_data.splice( lv_data.length-1, 1 );
                              }else{
                                lv_data.splice( lv_data.length, 1 );
                              } 
                            }
														dialogItself.getModalBody().find("#rowchk:checked").each(function(e){
															var lv_doccod = $(this).data("doccod");
															var lv_poscod = $(this).data("docposcod");
															var lv_qty = dialogItself.getModalBody().find("#"+lv_doccod+ "_"+lv_poscod+"_qty").prop("value");
															var lv_dat = dialogItself.getModalBody().find("#"+lv_doccod+ "_"+lv_poscod+"_data").text();
															var lo_dat = JSON.parse( lv_dat );
															lv_data.push({"docreftyp":lo_dat["doctyp"],
																					"docrefcod":lo_dat["doccod"],
																					"docrefposcod":lo_dat["docposcod"],
																					"matcod":lo_dat["matcod"],
																					"matcodext":lo_dat["matcodext"],
																					"mattxt":lo_dat["mattxt"],
																					"matqty":Number(lv_qty),
																					"matuntcod":lo_dat["matuntcod"],
																					"matprc":lo_dat['matprc'],
																					"mattot":Number(lo_dat['matprc']*lv_qty).toFixed(2),
																					"matprcref":Number(lo_dat["matprc"])
																				});
														});
													<?= $lv_sec; ?>_hotdoc.loadData( lv_data );
													<?= $lv_sec; ?>_refreshAllPrices();
													dialogItself.close();
												}
											}
										}]
					});
				});
			}
		});
		
		$(function(){
			<?= $lv_sec; ?>_refreshPrices();
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab001']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab003']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
      if ( $("#<?= $lv_sec; ?> #buysuponetme").val() == 1){
        $("#<?= $lv_sec; ?> #grldoccntonetme").val("1");
      }
		});
	</script>
	<script>
		/**
		 *
		 *	M A T E R I A L E S
		 *
		 */
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
				<?php if ( $vew_readonly ) { ?>
					var lv_ro = "#F1F1F1";
				<?php } else { ?>
					var lv_ro = "#FFFFFF";					
					var lv_docreftyp = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"docreftyp");
					if ( (lv_docreftyp==null?"":lv_docreftyp)!="" ) {
						cellProperties.readOnly = true;
						lv_ro = "#F1F1F1";
					} else if ( prop!="matqty" ) {
						var lv_docrefqty = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"docrefminqty");
						if ( (lv_docrefqty==null?"":lv_docrefqty.toString())!="" ) {
							cellProperties.readOnly = true;
							lv_ro = "#F1F1F1";
						}
					}
				<?php } ?>
				if ( prop=="matprc" || prop=="matqty" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);			
					td.style.backgroundColor = lv_ro;
				} else if ( prop=="mattot" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);			
					td.style.backgroundColor = "#F1F1F1";
				} else if ( prop=="icn" ) {
					var lv_btn = "<a href='#' onclick='<?= $lv_sec; ?>_showDetails("+row+");' class='btn btn-default btn-sm'><span class='fa fa-ellipsis-h'></span></a>";
					$(td).empty().append(lv_btn);
					td.style.backgroundColor = lv_ro;
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = lv_ro;
				}
			}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #buyinvmathot")[0];
		var <?= $lv_sec; ?>_hotdocset = {
			height: 396,
			stretchH: "all",
			autoColumnSize: true,
			<?= ($vew_readonly?'':'contextMenu: ["remove_row"],') ?>
			autoWrapRow: false,
			rowHeaders: true,
			minSpareRows: <?= ($vew_readonly || $lv_refdocmdt!=''?'0':'1') ?>,
			colHeaders: [ "Material", "Descripcion", "Cantidad", "UM", "Importe", "SubTotal", "" ],
			columns: [
				{type: "text", data: "matcod", width: 18, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
				{type: "autocomplete", data: "mattxt", renderer: <?= $lv_sec; ?>_hotdoc_renderer, <?= ($vew_readonly?'readOnly: true, ':''); ?>
/*
         source: function (query, process) {
						if ( query.length>1 && <?= $lv_sec; ?>_hot_paste!=true ) {
							$.ajax({
								url: "index.php?prg=stkmat&act=17", dataType: "json", data: {	prm_mattxt: query },
								complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/ *script* /"){ eval(jqXHR.responseText); }},
								success: function (response) {
									var lv_dat = [];
									<?= $lv_sec; ?>_hotdocchg = [];
									for (var i=0; i < response.data.length; i++) {
										<?= $lv_sec; ?>_hotdocchg.push( {mattxt: response.data[i]["mattxt"], 
                    																matcod: response.data[i]["matcod"], 
                                                    matuntcod: response.data[i]["matuntcod"]} );
										lv_dat.push( response.data[i]["mattxt"] );
									}
									process( lv_dat );
								}
							});
						} else {
							<?= $lv_sec; ?>_hot_paste = false;
						}
					},
*/
					source: function (query, process) {
						if ( query.length>1 && <?= $lv_sec; ?>_hot_paste!=true ) {
							$.ajax({ 
								url: "?prg=stkmat&act=17", dataType: "json", data: { prm_mattxt: query <?=($lv_mat_sysdocclscod!=''?', prm_sysdocclscod: "'.$lv_mat_sysdocclscod.'"':''); ?>},
								complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/ *script* /"){ eval(jqXHR.responseText); }},
								success: function (response) {
									var lv_dat = [];
									<?= $lv_sec; ?>_hotdocchg = [];
									for (var i=0; i < response.data.length; i++) {
										<?= $lv_sec; ?>_hotdocchg.push( {mattxt: response.data[i]["mattxt"], 
                                                     matcod: response.data[i]["matcod"], 
                                                     matcodext: (response.data[i]["matcodext"] ? response.data[i]["matcodext"] : ""), 
                                                     matuntcod: response.data[i]["matuntcod"]} );
										lv_dat.push( response.data[i]["mattxt"] );
									}
									process( lv_dat );
								}
							});
						} else {
              process( [query] );
							<?= $lv_sec; ?>_hot_paste = false;
						}
					},         
         
         
         strict: true
				},
				{type: "numeric", data: "matqty", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "matuntcod", width: 18, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true },
				{type: "numeric", data: "matprc", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer <?= ($vew_readonly?', readOnly: true':'');	?>, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "numeric", data: "mattot", width: 50, renderer: <?= $lv_sec; ?>_hotdoc_renderer, readOnly: true, numericFormat: {pattern: "0,0.00", culture: "es-AR"} },
				{type: "text", data: "icn", width: 18, renderer: <?= $lv_sec; ?>_hotdoc_renderer, editor: false, readOnly: true }
			],
        /*
			beforeChange : function(changes, source) {
				if(source=="edit" && changes[0][1]=="mattxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].mattxt == lv_value) {
							changes.push([ changes[0][0], "matcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].matcod) ]);
							changes.push([ changes[0][0], "matuntcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].matuntcod) ]);
						}
					}
          if( "<?= $lv_matcodtxt; ?>" != "" ){
            changes.push([ changes[0][0], "matcod", "", "<?= $lv_matcodtxt ?>" ]);
            changes.push([ changes[0][0], "matuntcod", "", "UN" ]);
            changes.push([ changes[0][0], "buyinvmatbuytxt", "", changes[0][3] ]);
          }
				}
			},
        */
			beforeChange : function(changes, source) {
        if(changes && changes.length && source=="CopyPaste.paste"){
          for(var i=0 ; i < changes.length ; i++) {
          	changes[i][3] = changes[i][3].replace('\r', "");
          }
        }
				if(changes && changes.length && source=="edit" && <?= $lv_sec; ?>_hot_paste!=true){
          <?= $lv_sec; ?>_hotdoc.render();
          if(changes[0][1]=="mattxt") {
            var lv_value = changes[0][3];
            for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
              if(<?= $lv_sec; ?>_hotdocchg[i].mattxt == lv_value) {
                changes.push([ changes[i][0], "matcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].matcod) ]);
                changes.push([ changes[i][0], "matcodext", "", String(<?= $lv_sec; ?>_hotdocchg[i].matcodext) ]);
                changes.push([ changes[i][0], "matuntcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].matuntcod) ]);
                if(!<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0],"matqty")){
                  changes.push([ changes[i][0], "matqty", "", 1]);
                }
           		 	<?= $lv_sec; ?>_hot_autocomplete = true;
              }
            }
            if(<?= $lv_sec; ?>_hotdocchg.length < 1){
              if( "<?= $lv_matcodtxt; ?>" != "" ){
                changes.push([ changes[0][0], "matcod", "", "<?= $lv_matcodtxt ?>" ]);
                changes.push([ changes[0][0], "matuntcod", "", "UN" ]);
                changes.push([ changes[0][0], "buyinvmatbuytxt", "", changes[0][3] ]);
              }
            }
          }
        }
			},
        
			beforeRemoveRow: function(index, amount, logicalRows) {
				var lv_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for( var i=index; i<=index+amount-1; i++){
					if ( lv_dat[i]["docrefsrcqty"]!="" && lv_dat[i]["docrefsrcqty"]!=undefined ) {
						toastr.warning("No se pueden borrar posiciones que estan referenciadas por otros documentos.");
						return false;
					} else if ( lv_dat[i]["buyinvmatcod"]!="" && lv_dat[i]["buyinvmatcod"]!=undefined ) {
						<?= $lv_sec; ?>_hotdocdel.push( lv_dat[i] );
					}
					var lv_found=0;
					var lv_newinx;
					for( var x=<?= $lv_sec; ?>_hotdocerr.length-1; x>=0; x-- ) {
						if( <?= $lv_sec; ?>_hotdocerr[x].endsWith("_"+i.toString()) ){
							<?= $lv_sec; ?>_hotdocerr.splice(x,1);
							lv_found=1;
						} else if(lv_found==0) { 
							lv_newinx = <?= $lv_sec; ?>_hotdocerr[x].split("_");
							lv_newinx[1] = Number(lv_newinx[1])-1;
							<?= $lv_sec; ?>_hotdocerr[x] = lv_newinx[0]+"_"+lv_newinx[1].toString();
						}
					}
				}
			},
			afterValidate: function( isValid, value, row, prop, source) {
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotdocerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotdocerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotdocerr.splice(lv_inx,1); }	
				}
			},
			afterChange: function(changes, source) {
				// agregar referencia
				// -- cuando se asigna el ultimo valor de la fila (flag de actualizacion)
				// -- realizo el calculo de precios
				if (<?= $lv_sec; ?>_hotdoc!=undefined) {
					if(changes && changes.length && source=="edit" && <?= $lv_sec; ?>_hot_paste!=true) {
						var lv_refresh_prices = [];
						for(var i=0; i<changes.length; i++) {
							if( changes[i][1]=="matqty" || changes[i][1]=="matprc") {
								if(lv_refresh_prices.indexOf(changes[i][0])!==1){lv_refresh_prices.push(changes[i][0]);}
								var lv_qty = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0], "matqty");
								var lv_prc = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0], "matprc");
								<?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "mattot", lv_qty*lv_prc );
								
								<?php if($lv_prccndcod!=''){ ?>
									// actualizo la condición de precio con el valor indicado
									var lv_matprcjsn = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0], "buyinvmatprc");
									if(lv_matprcjsn!=null && lv_matprcjsn!=undefined) {
										var lv_matprcarr = JSON.parse( lv_matprcjsn );
										for(var x=0; x<lv_matprcarr.length;x++){
											if(lv_matprcarr[x].prccndcod=="<?= $lv_prccndcod; ?>"){
												lv_matprcarr[x].prccndqty = lv_qty;
												lv_matprcarr[x].prccnduntcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0], "matuntcod");
												lv_matprcarr[x].prccndval = lv_prc;
												lv_matprcarr[x].prccndcurcod = $("#<?= $lv_sec; ?> #curcod").prop("value");
												x=lv_matprcarr.length+1;
											}
										}
										<?= $lv_sec; ?>_hotdoc.setDataAtRowProp(changes[i][0], "buyinvmatprc", JSON.stringify( lv_matprcarr ));
									}
								<?php } ?>
								
							}
						}
						// actualizo precios de todas las posiciones modificadas
						for(var i=0; i<lv_refresh_prices.length; i++){
							<?= $lv_sec; ?>_refreshPrices( lv_refresh_prices[i] );
						}	
					}
				}
			},
      afterValidate: function( isValid, value, row, prop, source) {
        if(!isValid && "<?= $lv_matcodtxt ?>" != "" && prop == "mattxt"){
          return true;
        } 
				var lv_key = prop + "_" + row.toString();
				var lv_inx = <?= $lv_sec; ?>_hotdocerr.indexOf( lv_key );
				if ( isValid==false ) {
					<?= $lv_sec; ?>_hotdocerr.push( lv_key );
				} else {
					if (lv_inx > -1) { <?= $lv_sec; ?>_hotdocerr.splice(lv_inx,1); }
				} 
			},
			afterRemoveRow: function(index, amount){
				if (<?= $lv_sec; ?>_hotdoc!=undefined) { <?= $lv_sec; ?>_refreshPrices(); }
			} 
		};
		var <?= $lv_sec; ?>_hotdoc;	
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->buyinvmat as $lv_row){
          $lv_buyinvmatprc = array();
					foreach($vew_data->buyinvprc as $lv_rowprc){
						unset($lv_rowprc['ctedte']); unset($lv_rowprc['upddte']);
						if($lv_rowprc['srcobjcod002']==($lv_row['buyinvmatcod']==''?$lv_row['buyinvmattmpcod']:$lv_row['buyinvmatcod']  ) ){ 
							$lv_buyinvmatprc[]=$lv_rowprc;
						}
					}
          
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'buyinvmatcod:"'.(isset($lv_row['buyinvmatcod'])?$lv_row['buyinvmatcod']:'').'",'.
												'matcod:"'.$lv_row['matcod'].'",'.
												'mattxt:`'.$lv_row['mattxt'].'`,'.
												'matqty: '.$lv_row['matqty'].' ,'.
												'matuntcod:"'.$lv_row['matuntcod'].'",'.
												'matprc: '.$lv_row['matprc'].' ,'.
												'mattot: '.($lv_row['matqty']*$lv_row['matprc']).' ,'.
            						'buyinvmatprc: "'.str_ireplace('"','\"',json_encode( $this->co_reg->document->array_utf8_converter($lv_buyinvmatprc) )).'" ,'.
												'buyinvmatbuytxt:`'.utf8_decode(html_entity_decode($vew_doc->getTagValue( ($lv_row['buyinvmatatr']??'') ,'buyinvmatbuytxt'))).'`,'.
												'docreftyp:"'.$lv_row['docreftyp'].'",'.
												'docrefcod:"'.$lv_row['docrefcod'].'",'.
												'docrefposcod:"'.$lv_row['docrefposcod'].'",'.
												($lv_row['refposqty']!=''?'docrefsrcqty: '.abs($lv_row['refposqty']-$lv_row['matqty']).',':'').
												($lv_row['refposqty']!=''?'docrefminqty: '.$lv_row['refposqty'].',':'').
												($lv_row['refposqty']!=''?'docrefminqtysrc: '.$lv_row['matqty']:'').
												'}';
				}
				echo $lv_buffer;
			?>];
			<?= $lv_sec; ?>_hotdoc.loadData( lv_dat );
			<?= $lv_sec; ?>_hotdoc.render();
		});
	</script>
	<script>
		// showDetails
		// muestra el detalle de la posición de factura
		function <?= $lv_sec; ?>_showDetails( lv_row ) {
			if(typeof <?= $lv_sec; ?>_hotdoc=="undefined"){ return false; }
			
			var lv_dochdr = {};
			var lv_docpos = JSON.parse(JSON.stringify(<?= $lv_sec; ?>_hotdoc.getSourceData()[lv_row]));
			var lv_docprc = [];
			
			// completo datos de cabecera con los datos del formulario
			var lv_tmparr = $("#<?= $lv_sec; ?>_frm").serializeArray();
			for(var i=0; i<lv_tmparr.length; i++){ lv_dochdr[ lv_tmparr[i]["name"] ] = lv_tmparr[i]["value"]; }
      lv_dochdr["prcschcalctr"] = "buyinv";
      lv_dochdr["prcschcalact"] = "calc";
			
			// quito el detalle de precios de la posición
			if(typeof lv_docpos["buyinvmatprc"]!=="undefined"){ 
				lv_docprc = JSON.parse(lv_docpos["buyinvmatprc"]);
				delete lv_docpos["buyinvmatprc"];
			}
			
			var lv_pstdat=[ {name:"dochdr",	value: JSON.stringify(lv_dochdr) },
											{name:"docpos",	value: JSON.stringify(lv_docpos) },
											{name:"docprc",	value: JSON.stringify(lv_docprc) },
											{name:"readonly",value:<?= ($vew_readonly?'true':'false'); ?>}
										];
			tmssCallProcess("?prg=buyinv&act=13", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "Datos Adicionales", 
					message: $(data),
					type: BootstrapDialog.TYPE_INFO,
					size: BootstrapDialog.SIZE_WIDE,
					buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
										{	label: "<?= $vew_lang->accept; ?>", cssClass: "btn-primary",	action: function(dialogItself){
                        // asigno texto de ventas a posicion
                        <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"buyinvmatbuytxt",dialogItself.getModalBody().find("#buyinvmatbuytxt").val(),"popup");
                      	<?php if( $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prcschcod') != '' )  { ?>
                          // asigno esquema de precios a posición
                          var lv_prc = Number(JSON.parse(dialogItself.$modalBody.find("#grldatprc").val())[0].prccndval);
                          var lv_qty = Number(JSON.parse(dialogItself.$modalBody.find("#grldatprc").val())[0].prccndqty);
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"buyinvmatprc",dialogItself.$modalBody.find("#grldatprc").val(),"popup");
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"matprc",lv_prc,"popup");
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"matqty",lv_qty,"popup");
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row, "mattot", lv_qty*lv_prc);

                          <?= $lv_sec; ?>_refreshPrices();
                      	<?php } ?>
                     		dialogItself.close();
											}
										}]
				});
			});
			return false;
		}	
	</script>
  <script>
    var gv_<?= $lv_sec; ?>_last_action="";
    
    // server response
    function <?= $lv_sec; ?>_fncbckext(data){
      if(data.errtyp=="E"){
				<?= $lv_sec; ?>_hotdoc.setCellMeta( Number(data.row), 2, "valid", false);
				<?= $lv_sec; ?>_hotdoc.render();
        toastr.warning(data.errcod+": "+data.errtxt);
			} else if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="09") {
					toastr.info("Documento contabilizado.");
					<?= $lv_sec; ?>_fnc({action: '99'});
        }else if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    }

		// form submit
    function <?= $lv_sec; ?>_fncext(lp_prm){
			// al borrar
			<?php if ($lv_docrefsrc) { ?>
			if ( lp_prm["action"]=="04" ) {
				toastr.warning("No se puede borrar el documento. Una o mas posiciones han sido referenciadas por otros documentos.");
				return false;
			}
			<?php } ?>

			// al grabar
			if ( lp_prm["action"]=="00" ) {
				if ( <?= $lv_sec; ?>_hotdocerr.length!=0 ) { toastr.warning("Corrija los valores incorrectos en la grilla."); return false; }
			
				<?php if($lv_prcschcod!=''){ ?>
					// proceso y descargo precios
					$("#<?= $lv_sec; ?> #btnprcdwn").trigger("click");
					$("#<?= $lv_sec; ?> #buyinvprc").text( JSON.stringify( <?= $lv_sec; ?>_hot_grldatprc.getSourceData() ) );
				<?php } ?>

				var lv_arr = new Array();

				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({ "buyinvcod": $("#<?= $lv_sec; ?> #buyinvcod").prop("value"),
												"buyinvmatcod": <?= $lv_sec; ?>_hotdocdel[i]["buyinvmatcod"],
												"docreftyp":<?= $lv_sec; ?>_hotdocdel[i]["docreftyp"],
												"docrefcod":<?= $lv_sec; ?>_hotdocdel[i]["docrefcod"],
												"docrefposcod":<?= $lv_sec; ?>_hotdocdel[i]["docrefposcod"],
												"matqty":<?= $lv_sec; ?>_hotdocdel[i]["matqty"],
												"matuntcod":<?= $lv_sec; ?>_hotdocdel[i]["matuntcod"],
												"deleted":"X"
											});
				}
				
				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["matcod"]!="" && lo_dat[i]["matcod"]!=undefined ) {
						lv_arr.push({	"buyinvmatcod":lo_dat[i]["buyinvmatcod"],
													"matcod":lo_dat[i]["matcod"],
													"mattxt":lo_dat[i]["mattxt"],
													"matqty":lo_dat[i]["matqty"],
													"matuntcod":lo_dat[i]["matuntcod"],
													"matprc":lo_dat[i]["matprc"],
													"curcod":lo_dat[i]["curcod"],
													"mattot":lo_dat[i]["mattot"],
													"buyinvmatbuytxt":lo_dat[i]["buyinvmatbuytxt"],
													"docreftyp":lo_dat[i]["docreftyp"],
													"docrefcod":lo_dat[i]["docrefcod"],
													"docrefposcod":lo_dat[i]["docrefposcod"],
                          "buyinvmatprc":lo_dat[i]["buyinvmatprc"]
												});
					}
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #buyinvmat").prop("value", "");						
				} else {
					$("#<?= $lv_sec; ?> #buyinvmat").prop("value", JSON.stringify( lv_arr ) );
				}
        
        var lv_cntdat = [];
        // Recupero y coloco en variables los interlocutores requeridos y la cantidad mácima de interlocutores
        <?php
          foreach($vew_data->sysdocclscnt as $lv_row){
            ?>
              lv_cntdat.push({ 
                "sysdocclscodcnt": "<?= $lv_row['sysdocclscodcnt'] ?>", 
                "sysdocclstxtcnt": "<?= $lv_row['sysdocclstxtcnt'] ?>", 
                "cntamt": "<?= $vew_doc->getTagValue($lv_row['sysdocclscntatr'], 'sysdocclscntqty') == '' ? '999' :  $vew_doc->getTagValue($lv_row['sysdocclscntatr'], 'sysdocclscntqty') ?>",
                "cntreq": "<?= $vew_doc->getTagValue($lv_row['sysdocclscntatr'], 'sysdocclscntreq') != '' ? "true" : "false" ?>"
              });
            <?php 
          }
        ?>

				var lv_doccnt = [];
        $("#<?= $lv_sec; ?> .grldoccntfrm").each(function(){
          var lv_cnt = JSON.parse($(this).val());
          
          if($(this).find("input[name='borrar']").length > 0){
            lv_cnt["delete"]="X"; 
          }else{
            // en caso de ser un contacto requerido, marco que el contacto está en el documento
            // resto uno a la cantidad máxima de interlocutores permitidos
            for(var i = 0; i < lv_cntdat.length; i++){
              if(lv_cntdat[i].sysdocclscodcnt == lv_cnt.sysdocclscodcnt){
                lv_cntdat[i].cntreq = false; 
                lv_cntdat[i].cntamt = lv_cntdat[i].cntamt - 1;
              }
            }
          }

          lv_doccnt.push(lv_cnt)
        });

        var lv_error = "";
        for(var i = 0; i < lv_cntdat.length; i++){
          if(lv_cntdat[i].cntreq == true || lv_cntdat[i].cntreq == "true"){
            lv_error = lv_error != "" ? lv_error += "<br>" : lv_error;
            lv_error += "Se debe indicar un interlocutor de tipo ["+ lv_cntdat[i].sysdocclstxtcnt +"]<br>";
          }
          if(lv_cntdat[i].cntamt < 0){
            lv_error = lv_error != "" ? lv_error += "<br>" : lv_error;
            lv_error += "Se super&oacute; la cantidad m&aacute;xima de interlocutores de tipo ["+ lv_cntdat[i].sysdocclstxtcnt +"]<br>";
          }
        }
        
        if(lv_error != ""){
          toastr.warning(lv_error);
          return false;
        }
        $("#<?= $lv_sec; ?> #doccntjson").prop("value", JSON.stringify(lv_doccnt) );
			}
		}
	</script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
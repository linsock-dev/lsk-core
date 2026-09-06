<?php
	// url del formulario
  $lv_lnk = '?prg=slsinv&prm_slsinvcod='.$vew_data->slsinvcod.'&prm_mdlcod='.$vew_data->mdlcod.'&prm_prgcod='.$vew_data->prgcod;

	// campos requeridos
	$vew_input->RequiredFields( array('dstobjtyp','dstobjcod','dstobjtxt','slsinvdte', 'curcod', 'docsts', 'paytrmtxt', 'paytrmcod') );

	// clave del documento
	$lv_dockey = $vew_data->slsinvcod; 

	// titulo
	$lv_title = $vew_lang->document;
	
	// modulo y programa
	$lv_mdlcod = $vew_data->mdlcod;
	$lv_prgcod = $vew_data->prgcod;

	// libreria de estilos bootstrap
	include_once('_library.frm');
	
	$lv_dstobjtyp = strtoupper($vew_doc->getTagValue( $vew_data->sysdoccls->sysdocclsatr, 'dstobjtyp' ));
	$lv_prcschcod = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prcschcod');
	$lv_prccndcod = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prccndcod');
	$lv_prcschcndrow = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prcschcndrow');
	if($lv_prcschcod==''){$lv_prccndcod='';}
	$lv_refdoccls = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'refdoccls');
	$lv_refdocmdt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'refdocmdt');
	$lv_docref = false;	// documento referencia a otro documento
	$lv_docrefsrc = false; // documento es referenciado por otro documento
	foreach($vew_data->slsinvmat as $lv_row){ 
		if ($lv_row['docreftyp']!=''){ $lv_docref=true; }
		if ($lv_row['refposqty']!=''){ $lv_docrefsrc=true; }
	}	
	
	// cargo motivos de rechazo de selección manual
	$lv_rejarr = array(''=>'');
	foreach($vew_data->sysdoccls->sysdocclsrej as $lv_row) {
		if (strtoupper($vew_doc->getTagValue($lv_row['sysdocclsrejatr'],'rejman'))=='X'){
			$lv_rejarr[ $lv_row['sysdocrejcod'] ] = $lv_row['sysdocrejtxt'];
		}
	}

	$vew_tbl['accL'] = array('per'=>$vew_data->docsts=='A' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09'), 'acc'=>false, 'id'=>'btnacc');
	$vew_tbl['accR'] = array('per'=>$vew_data->docsts=='A' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09'), 'acc'=>false, 'id'=>'btnacc');
	$vew_tbl['modL'] = array('per'=>$vew_data->docsts=='A' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
	$vew_tbl['modR'] = array('per'=>$vew_data->docsts=='A' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
	
  $lv_posarr = array();
  foreach($vew_data->slspos as $lv_row){
    $lv_posarr[ $lv_row['slsposcod'] ] = $lv_row['slsposcodext'].'-'.$lv_row['slspostxt'];
    if ($lv_row['slsposcod'] == $vew_data->slsposcod){
      $vew_data->argpostyp = $lv_row['argpostyp'];
    }
  }
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  
	<?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod', 'hidden', '') ?>
		<textarea class="hidden" id="slsinvprc" name="slsinvprc"><?= json_encode($vew_data->slsinvprc,true); ?></textarea>
		<textarea class="hidden" id="slsinvmat" name="slsinvmat"></textarea>		
		<?= gethtml('prcschcod', 'hidden', $lv_prcschcod); ?>
    
    <div class="container-fluid" role="tabpanel"> 
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->data; ?></a></li>
				<?php if($lv_prcschcod!=''){ ?><li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->prices; ?></a></li><?php } ?>
				<li class="pull-right"><h4># <strong><?= $vew_data->slsinvcod; ?><?= gethtml('slsinvcod', 'hidden', $vew_data->slsinvcod); ?></strong></h4></li>
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
                    echo gethtml('dstobjtyp', 'hidden', ($vew_data->buyexpcod!=''?$vew_data->dstobjtyp:$vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'dstobjtyp')));
                    echo vew_boot($lv_col210, array('label'=>($lv_dstobjtyp=='SLS_CUS'?$vew_lang->customer:($lv_dstobjtyp=='EDU_STU'?$vew_lang->student:'')), 
                                                    'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                        array('input'=>gethtml('dstobjtxt', 'typeahead', $vew_data->dstobjtxt,$lv_default) ))
                                                    ));
                    echo gethtml('dstobjcod', 'hidden', $vew_data->dstobjcod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('slsinvtxt', 'doccmt1x50', $vew_data->slsinvtxt, $lv_default) ));
                  ?>
                </div>
              </div> <!-- /card -->
              
						</div> <!-- /col -->
            <div class="col-md-6">
              
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?php if($vew_data->sysdoctrecod=='N'){ ?><span><span class="far fa-circle"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod=='P'){ ?><span class="text-warning"><span class="far fa-circle-half-stroke"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod=='C'){ ?><span class="text-success"><span class="fas fa-circle"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod==''){ echo '&nbsp;'; } ?>
                  	<span class="tmss-card-icon">
                    	<?= '<b><span id="slsinvtotlbl">'.number_format(floatval($vew_data->slsinvtotamt),2).'</span></b> '.strtolower($vew_data->curcod); ?>
                      <?= gethtml('curcod', 'hidden', $vew_data->curcod); ?>
											<?= gethtml('curcoddef', 'hidden', $vew_data->curcod); ?>
											<?= gethtml('argpostyp', 'hidden', $vew_data->argpostyp); ?>
                      <?= gethtml('slsinvtot', 'hidden', $vew_data->slsinvtotamt); ?>
                    </span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?= vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('slsinvdte', 'docdte',	$vew_data->slsinvdte,	$lv_default) )); ?>
                    <?php if(count($vew_data->slspos)>0){
                    	echo vew_boot($lv_col255, array('label'=>$vew_lang->code,  
                                                      'input1'=>gethtml('slsposcod',$lv_posarr,$vew_data->slsposcod, $lv_default),
                                                      'input2'=>gethtml('slsinvcodext','doccmt1x20',$vew_data->slsinvcodext, $lv_always_disabled)
                                                      ));
										
                      // ARGENTINA - localizacion (puntos de venta definidos)
                      if($vew_data->bus->adr->lndcod=='AR') { ?>
                        <script>
                          $("#<?= $lv_sec; ?> #dstobjcod").on("change",function(e){
                            if($("#<?= $lv_sec; ?> #dstobjcod").prop("value") != ""){
                              // obtengo categoria fiscal de destinatario de factura
                              var lv_pstdat =[{name:"dstobjtyp",value:$("#<?= $lv_sec; ?> #dstobjtyp").prop("value")},
                                              {name:"dstobjcod",value:$("#<?= $lv_sec; ?> #dstobjcod").prop("value")}];
                              tmssCallProcessNoBackdrop("?prg=slsinv&act=getDestinationTax",lv_pstdat,function(data){
                                $("#<?= $lv_sec; ?> #taxcatcod").prop("value",data.taxcatcod);
                                $("#<?= $lv_sec; ?> #taxcattxt").prop("value",data.taxcattxt);
                                // obtengo letra
                                var lv_pstdat2 =[{name:"taxcatcodsrc",value:"<?= $vew_data->bus->tax->taxcatcod; ?>"},
                                                {name:"taxcatcoddst",value:data.taxcatcod},
                                                {name:"argltroprtyp",value:"L"}];
                                tmssCallProcessNoBackdrop("?prg=finlocargltr&act=getLetter",lv_pstdat2,function(data){
                                  $("#<?= $lv_sec; ?> #slsinvcodext").prop("value", (data.length>=1 ? data[0].argltrcodext : "") );
                                });
                              });
                            }
                          });
                        </script>
                        <?php
                      }
                    } else {
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->number, 'input'=>gethtml('slsinvcodext','doccmt1x20',$vew_data->slsinvcodext, $lv_default) ));
                    }
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
          <div id="slsinvmathot" name="slsinvmathot"></div>
				</div> <!-- /tab001 -->
        
        
        <!-- PRECIOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
					<div class="row">
						<div class="col-sm-12">
              <div class="card tmss-hot-ttl">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->prices; ?>
                    <small class="tmss-desk-btn">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<?php if($vew_data->slsinvprcdte != ''){ echo is_string($vew_data->slsinvprcdte) ? '('.$vew_data->slsinvprcdte.')' : '('.$vew_data->slsinvprcdte->format('d/m/Y').')'; } ?></small>
                    <small class="tmss-mob-btn fs-11">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<?php if($vew_data->slsinvprcdte != ''){ echo is_string($vew_data->slsinvprcdte) ? '('.$vew_data->slsinvprcdte.')' : '('.$vew_data->slsinvprcdte->format('d/m/Y').')'; } ?></small>
                    <small class="tmss-desk-btn pull-right"><?= $vew_lang->PriceList.': <strong>'.ucfirst(strtolower($vew_data->slsprclsttxt)).'</strong>&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;'.$vew_lang->exchangerate.': <strong>'.(is_string($vew_data->curexcrte)?$vew_data->curexcrte:number_format($vew_data->curexcrte, 5)).'</strong>'; ?></small>
                    <small class="tmss-mob-btn pull-left fs-11"><?= $vew_lang->PriceList.': <strong>'.ucfirst(strtolower($vew_data->slsprclsttxt)).'</strong>&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;'.$vew_lang->exchangerate.': <strong>'.(is_string($vew_data->curexcrte)?$vew_data->curexcrte:number_format($vew_data->curexcrte, 5)).'</strong>'; ?></small>
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
              	<div class="card-header"><div class="card-title"><?= $vew_lang->conditions; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->paymentstermshort, 'input'=>vew_boot(array('style'=>'search','readonly'=>$vew_readonly), array('input'=>gethtml('paytrmtxt', 'typeahead', $vew_data->paytrmtxt, $lv_default) )) ));
                    echo gethtml('paytrmcod', 'hidden', $vew_data->paytrmcod);
                   	echo vew_boot($lv_col210, array('label'=>$vew_lang->PriceList, 'input'=>vew_boot( array('style'=>'search','readonly'=>$vew_readonly), array('input'=>gethtml('slsprclsttxt', 'typeahead', $vew_data->slsprclsttxt, $lv_default) )) ));
                    echo gethtml('slsprclstcod', 'hidden', $vew_data->slsprclstcod); 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->datePrice, 'input'=>gethtml('slsinvprcdte',	'docdte',	$vew_data->slsinvprcdte,	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->exchangerate,'input'=>gethtml('curexcrte', 'docnum0905', $vew_data->curexcrte, $lv_always_disabled) ));
                  ?>
                </div>
              </div> <!-- /card -->
          	</div> <!-- /col -->
            <div class="col-md-6">
            	<div class="card">
              	<div class="card-header"><div class="card-title"><?= $vew_lang->validity; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col2424, array('label'=>$vew_lang->from, 'input1'=>gethtml('slsinvstrdte',	'docdte',	$vew_data->slsinvstrdte,	$lv_default), 'label2'=>$vew_lang->to, 'input2'=>gethtml('slsinvenddte',	'docdte',	$vew_data->slsinvenddte,	$lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->duedate, 'input'=>gethtml('slsinvduedte',	'docdte',	$vew_data->slsinvduedte, $lv_default) ));  
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->fiscalcategory, 'input'=>gethtml('taxcattxt', 'taxcattxt', '', $lv_always_disabled) )); 
                  	echo gethtml('taxcatcod', 'hidden','');
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->accountingDate, 'input'=>gethtml('slsinvaccdte',	'docdte',	$vew_data->slsinvaccdte, $lv_default) ));
                  ?>
                </div>
              </div> <!-- /card -->
          	</div> <!-- /col -->
					</div> <!-- /row -->
				</div> <!-- /tab002 -->
			
			</div> <!-- tabcontent -->     
		</div> <!-- container-fluid --> 
  </form>
  <script>
    function <?= $lv_sec; ?>_GridRefresh(){ <?= $lv_sec; ?>_fnc({action: '99'}); }
    
    // CONDICION DE VENTA. paytrmtxt - typeahead
		var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"docsts" : "A", "paytrmgrp" : "(like)D"}, "fldasg" : {"paytrmtxt" : "paytrmtxt", "paytrmcod" : "paytrmcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #paytrmtxt"), "finpaytrm", lo_get, {'afterAssign' : function(){ $("#<?= $lv_sec; ?> #paytrmcod").change(); } });
    
		// LISTA DE PRECIOS. slsprclsttxt - typeahead
		var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"p.docsts" : "A", }, "fldasg" : {"slsprclsttxt" : "slsprclsttxt", "slsprclstcod" : "slsprclstcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #slsprclsttxt"), "slsprc", lo_get);
    
		// DESTINO. CLIENTE. dstobjtxt
			var lo_beforeAssign = function(){ <?= $lv_sec; ?>_paste = true; }
      var lo_afterAssign = function(){ 
        <?= $lv_sec; ?>_paste = false;
        <?= $lv_sec; ?>_refreshPrices();
        $("#<?= $lv_sec; ?> #dstobjcod").change();
        $("#<?= $lv_sec; ?> #paytrmcod").change();
      }
		<?php if ($lv_dstobjtyp=='SLS_CUS'){ ?>
      var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"dstobjtxt" : "custxt", "dstobjcod" : "cuscod", "slsprclstcod" : "slsprclstcod", "slsprclsttxt" : "slsprclsttxt", "curcod" : "curcod", "paytrmcod" : "paytrmcod", "paytrmtxt" : "paytrmtxt", "taxcatcod" : "taxcatcod", "taxcattxt" : "taxcattxt"}}; 
			tmssTypeahead($("#<?= $lv_sec; ?> #dstobjtxt"), "slscus", lo_get, {"beforeAssign" : lo_beforeAssign, "afterAssign" : lo_afterAssign}  );
		<?php } ?>
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"dstobjtxt" : "stutxt", "dstobjcod" : "stucod", "slsprclstcod" : "slsprclstcod", "slsprclsttxt" : "slsprclsttxt", "curcod" : "curcod", "paytrmcod" : "paytrmcod", "paytrmtxt" : "paytrmtxt", "taxcatcod" : "taxcatcod"}}; 
		<?php if ($lv_dstobjtyp=='EDU_STU'){ ?>
      tmssTypeahead($("#<?= $lv_sec; ?> #dstobjtxt"), "edustu", lo_get, {"beforeAssign" : lo_beforeAssign, "afterAssign" : lo_afterAssign});
		<?php } ?>
  </script>
	<script>		
		var <?= $lv_sec; ?>_paste = false;
		
    // obtengo categoria fiscal de destinatario de factura
    if ($("#<?= $lv_sec; ?> #dstobjcod").prop("value") != ""){
    	var lv_pstdat =[{name:"dstobjtyp",value:$("#<?= $lv_sec; ?> #dstobjtyp").prop("value")},
                      {name:"dstobjcod",value:$("#<?= $lv_sec; ?> #dstobjcod").prop("value")}];
      tmssCallProcessNoBackdrop("?prg=slsinv&act=getDestinationTax",lv_pstdat,function(data){
        $("#<?= $lv_sec; ?> #taxcatcod").prop("value",data.taxcatcod);
        $("#<?= $lv_sec; ?> #taxcattxt").prop("value",data.taxcattxt);
        <?= $lv_sec; ?>_refreshAllPrices();
      }); 
    }
    
		
		// cargo precios de cabecera del documento
		$(function(){
			var lv_dochdr = {};
			var lv_tmparr = $("#<?= $lv_sec; ?>_frm").serializeArray();
			for(var i=0; i<lv_tmparr.length; i++){ lv_dochdr[ lv_tmparr[i]["name"] ] = lv_tmparr[i]["value"]; }
			<?php
				$lv_slsinvmatprc = array();
				foreach($vew_data->slsinvprc as $lv_rowprc){
					unset($lv_rowprc['ctedte']); unset($lv_rowprc['upddte']);
					if($lv_rowprc['srcobjcod002']==''){ $lv_slsinvmatprc[]=$lv_rowprc; }
				}
				echo 'var lv_docprc = "'.str_ireplace('"','\"',json_encode( $this->co_reg->document->array_utf8_converter($lv_slsinvmatprc) )).'";';
			?>
			
			var lv_pstdat=[ {name:"dochdr",value:JSON.stringify(lv_dochdr)}, 
											{name:"docpos",value:JSON.stringify("{}")}, 
											{name:"docprc",value:lv_docprc},
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
			if(typeof <?= $lv_sec; ?>_hot_grldatprc=="undefined"){return false;}
			if(<?= $lv_sec; ?>_paste!=false){return false;}
			
			// obtengo datos
			var lv_docprc = [];
			var lv_tmp = <?= $lv_sec; ?>_hotdoc.getSourceData();
			for(var i=0; i<lv_tmp.length; i++){
				if(typeof lv_tmp[i]["slsinvmatprc"]!="undefined"){
					lv_docprc.push( JSON.parse( lv_tmp[i]["slsinvmatprc"] ) );
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
			$("#<?= $lv_sec; ?> #slsinvtotlbl").text( lv_tot.toLocaleString('en-US', {minimumFractionDigits: 2}) );
      $("#<?= $lv_sec; ?> #slsinvtot").val(lv_tot);
			<?= $lv_sec; ?>_hot_grldatprc.loadData( lv_out );
		}
		
		
		
		// REFRESH ALL PRICES
		// actualiza todas las posiciones
		function <?= $lv_sec; ?>_refreshAllPrices(){
      if (<?= $lv_sec; ?>_hotdoc==undefined) { return false; }
			for(var i=0; i < <?= $lv_sec; ?>_hotdoc.getSourceData().length; i++){
				<?= $lv_sec; ?>_refreshPrices( i , true);
			}	
		}
		
		
		
		// REFRESH PRICES
		// actualiza precios de la posición del documento
		function <?= $lv_sec; ?>_refreshPrices( lv_row, lv_refreshAllPrices=false) {
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
			lv_docprc = JSON.parse( (typeof lv_data[lv_row]["slsinvmatprc"]!="undefined" && lv_data[lv_row]["slsinvmatprc"]!="" ? lv_data[lv_row]["slsinvmatprc"] : "[]") );
			if(typeof lv_data[lv_row]["slsinvmatprc"]!="undefined" && lv_data[lv_row]["slsinvmatprc"]!="" ){ delete lv_data[lv_row]["slsinvmatprc"]; }
      
      // si no se hizo un cambio de precio manual y se está en modo modificación, se recuperan los datos de precios de la lista de precios asociada          
      if("<?= !$vew_readonly ?>" == "1"){
        for (var i = 0; i < lv_docprc.length; i++){
          if (lv_docprc[i].prccndcod == "<?= $lv_prccndcod; ?>"){
            if(lv_docprc[i].prcchgman != "X"){
              var lv_pstdat =[{name:"slsprclstcod",value: $("#<?= $lv_sec; ?> #slsprclstcod").prop("value")}, 
                                  {name:"slsprclstdte",value: $("#<?= $lv_sec; ?> #slsinvdte").prop("value")}, 
                                  {name:"slsprcsrctyp",value: "STK_MAT"},
                                  {name:"slsprcsrccod",value: <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row, "matcod")},
                                  {name:"currow",value: lv_row}
                                  ]
              tmssCallProcessNoBackdrop("?prg=slsprclst&act=17", lv_pstdat, function(data){
                if(data.length>0){ 
                  var lv_prc = isNaN(data[0]["slsprc"] / data[0]["slsprcqty"]) ? "0" : data[0]["slsprc"] / data[0]["slsprcqty"];
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"matprc", lv_prc, "setting"); 
                  <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( lv_row, "mattot", lv_prc * <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row, "matqty"), "setting" );
                }
              }); 
            }
            break;
          }
        }
      }
      
			lv_docpos = lv_data[lv_row];
			// llamada a funcion para calcular precios
			var lv_pstdat=[ {name:"dochdr",value:JSON.stringify(lv_dochdr)}, 
											{name:"docpos",value:JSON.stringify(lv_docpos)}, 
											{name:"docprc",value:JSON.stringify(lv_docprc)},
											{name:"readonly",value:<?= ($vew_readonly?'true':'false'); ?>}
										];
      <?php if( $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prcschcod') != '' )  { ?>                 
        tmssCallProcessNoBackdrop("?prg=slsinv&act=calc",lv_pstdat,function(data){
          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row, "slsinvmatprc", JSON.stringify(data["docprc"]) );
      		//Si se está haciendo un refreshAllPrices() se llama de vuelta a calc
      		//La primera vez es para obtener el esquema de precios, luego se modifica y se llama de vuelta a calc para hacer el cálculo
					if(lv_refreshAllPrices){
          	// actualizo la condición de precio con el valor indicado
            var lv_matprcjsn = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row, "slsinvmatprc");
            if(lv_matprcjsn!=null && lv_matprcjsn!=undefined) {
              var lv_matprcarr = JSON.parse( lv_matprcjsn );
              for(var x=0; x<lv_matprcarr.length;x++){
                if(lv_matprcarr[x].prccndcod=="<?= $lv_prccndcod; ?>"){
                  lv_matprcarr[x].prccndqty = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row, "matqty");
                  lv_matprcarr[x].prccnduntcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row, "matuntcod");
                  lv_matprcarr[x].prccndval = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row, "matprc");;
                  lv_matprcarr[x].prccndcurcod = $("#<?= $lv_sec; ?> #curcod").prop("value");
                  x=lv_matprcarr.length+1;
                }
              }
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row, "slsinvmatprc", JSON.stringify( lv_matprcarr ));
            }
            //vuelvo a llamar a la función para calcular con el esquema modificado
            lv_docprc = JSON.parse( (typeof lv_data[lv_row]["slsinvmatprc"]!="undefined"?lv_data[lv_row]["slsinvmatprc"]:"[]") );
              var lv_pstdat=[ {name:"dochdr",value:JSON.stringify(lv_dochdr)}, 
                              {name:"docpos",value:JSON.stringify(lv_docpos)}, 
                              {name:"docprc",value:JSON.stringify(lv_docprc)},
                              {name:"readonly",value:<?= ($vew_readonly?'true':'false'); ?>}
                            ];
            tmssCallProcessNoBackdrop("?prg=slsinv&act=calc",lv_pstdat,function(data){
          		<?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row, "slsinvmatprc", JSON.stringify(data["docprc"]) );
          		<?= $lv_sec; ?>_refreshHeaderPrices();
            }); 
          }else{
            <?= $lv_sec; ?>_refreshHeaderPrices();
          }
        });
      <?php } else { ?>
    		var lv_grltot = 0;
    		for(var i = 0; i < lv_data.length; i++) {
          if( (lv_data[i]["matqty"] != "" && lv_data[i]["matqty"] != null) && (lv_data[i]["matprc"] != "" && lv_data[i]["matprc"] != null)){
          	lv_grltot += lv_data[i]["matqty"] * lv_data[i]["matprc"];  
          }
        }
        $("#<?= $lv_sec; ?> #slsinvtotlbl").text( lv_grltot.toLocaleString('en-US', {minimumFractionDigits: 2}) );
    		$("#<?= $lv_sec; ?> #slsinvtot").val(lv_grltot);
    	<?php } ?>
		}
		
		
		
		// actualiza precios - control de cambios del documento
		$("#<?= $lv_sec; ?> #srcobjcod, #<?= $lv_sec; ?> #paytrmcod, #<?= $lv_sec; ?> #slsprclstcod, #<?= $lv_sec; ?> #curcod, #<?= $lv_sec; ?> #slsinvdte").on("change",function(e){
			if (<?= $lv_sec; ?>_paste==false){ <?= $lv_sec; ?>_refreshAllPrices(); }
		});
	</script>
	<script>
		// CONTABILIZAR
		$("#<?= $lv_sec; ?> #btnacc").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm({
				title: "Contabilizar", 
				message:"Desea contabilizar el documento ?",
				type: BootstrapDialog.TYPE_PRIMARY,
				callback: function(result){
					if(result){
						var lv_pstdat = [{name:"slsinvcod",value:"<?= $vew_data->slsinvcod; ?>"}];
						tmssCallProcess("?prg=slsinv&act=09",lv_pstdat,function(data){
							if(data.errtyp=="E"){
								toastr.warning(data.errcod+": "+data.errtxt);
								return false;
							}
							// localizacion ARGENTINA
							if( data.lndcod=="AR"){
								if(data.slspos.length>0){
									// WebService OnLine
									if( data.slspos[0].argpostyp == "WO" ) {
										var lv_proc = ["<?= $vew_data->slsinvcod; ?>"];
										tmssCallProcess("?prg=slsinvfce&act=showSlsInvFce", [{name:"slsinvcod",value:JSON.stringify(lv_proc)}], function(data){
											BootstrapDialog.show({
												title: "<?= $vew_lang->electronicinvoice; ?>", 
												message: $(data),
												type: BootstrapDialog.TYPE_PRIMARY,
												onhidden: function(dialog){ <?= $lv_sec; ?>_fnc({action: '99'}); }
											});
										});
									} else {
										// falta Factura en Linea (solicitar CAE y VTO) / Manual / Autoimpresor
										toastr.info("Documento contabilizado.");
										<?= $lv_sec; ?>_fnc({action: '99'});
									}
								} else {
									toastr.info("Documento contabilizado.");
									<?= $lv_sec; ?>_fnc({action: '99'});
								}
							} else {
								toastr.info("Documento contabilizado.");
								<?= $lv_sec; ?>_fnc({action: '99'});
							}
						});
					}
				}
			});
		});
    
		$("#<?= $lv_sec; ?> #paytrmcod, #<?= $lv_sec; ?> #slsinvdte, #<?= $lv_sec; ?> #slsinvaccdte").on("change",function(e){
			if($(this).prop("value")=="" || $(this).prop("value")=="0"){
				$(this).prop("value","");
				$("#<?= $lv_sec; ?> #slsinvduedte").prop("value","");
			} else {
          if($("#<?= $lv_sec; ?> #paytrmcod").prop("value")!=""){
            var lv_pstdat = [{name:"paytrmcod",value:$("#<?= $lv_sec; ?> #paytrmcod").prop("value")},
                             {name:"docdte",value:$("#<?= $lv_sec; ?> #slsinvdte").prop("value")},
                             {name:"ctedte",value:"<?= ($vew_data->ctedte!=''?date_format($vew_data->ctedte,'d/m/Y'):date_format(new DateTime(),'d/m/Y')); ?>"},
                             {name:"docaccdte",value:$("#<?= $lv_sec; ?> #slsinvaccdte").prop("value")}];
            tmssCallProcessNoBackdrop("?prg=finpaytrm&act=getDueDate",lv_pstdat,function(data){
              if(data.paytrmduedte.length>0){
                $("#<?= $lv_sec; ?> #slsinvduedte").prop("value",data.paytrmduedte[0].paytrmduedte);
              }
            });
      	}
			}
		});
		
    
		// REFERENCIA. agregar referencia
		$("#<?= $lv_sec; ?> #btndocref").on("click",function(e){ e.preventDefault();
			if ( $("#<?= $lv_sec; ?> #dstobjcod").prop("value")=="" ) {
				toastr.warning("Debe indicar el destino.");
				$("#<?= $lv_sec; ?> #dstobjtxt").focus();
			} else {
				// obtengo los IDs de los documentos referenciados previamente y que no hayan sido grabados
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_refarr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( (lo_dat[i]["slsinvmatcod"]==undefined?"":lo_dat[i]["slsinvmatcod"])=="" && (lo_dat[i]["docreftyp"]==undefined?"":lo_dat[i]["docreftyp"])!="" ) {
						lv_refarr.push({"srcobjtyp":lo_dat[i]["docreftyp"],
													"srcobjcod":lo_dat[i]["docrefcod"],
													"srcposcod":lo_dat[i]["docrefposcod"],
													"refposqty":lo_dat[i]["matqty"]
												});
					}
				}
				// cargo la pantalla de referencia
				var lv_dat = "";
				var lv_pstdat = {	sysdocclscod: "<?= $vew_data->sysdoccls->sysdocclscod; ?>",
													refobjtyp: "<?= $lv_mdlcod.'_'.$lv_prgcod; ?>",
													refobjcod: "<?= $vew_data->slsinvcod; ?>",
													fndobjtyp: $("#<?= $lv_sec; ?> #dstobjtyp").prop("value"),
													fndobjcod: $("#<?= $lv_sec; ?> #dstobjcod").prop("value"),
													fndobjtxt: $("#<?= $lv_sec; ?> #dstobjtxt").prop("value"),
													refarr: JSON.stringify(lv_refarr)
												};
				tmssCallProcess("?prg=grldocflw&act=01",lv_pstdat,function(data){
					var lv_objtxt = $("#<?= $lv_sec; ?> #dstobjtxt").prop("value");
					BootstrapDialog.show({
						size: BootstrapDialog.SIZE_WIDE,
						title: "Agregar Referencia - <?= $vew_data->sysdoccls->sysdocclstxt; ?> ("+lv_objtxt+") ",
						message: $(data),
						buttons: [{ label: "Cancelar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
											{	label: "Agregar", cssClass: "btn-success",	action: function(dialogItself){
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
																				"matprc":Number(lo_dat["matprc"]),
																				"mattot":Number(lo_dat["matprc"]*lv_qty),
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
      lv_dochdr["prcschcalctr"] = "slsinv";
      lv_dochdr["prcschcalact"] = "calc";
			
			// quito el detalle de precios de la posición
			if(typeof lv_docpos["slsinvmatprc"]!=="undefined"){ 
				lv_docprc = JSON.parse(lv_docpos["slsinvmatprc"]);
				delete lv_docpos["slsinvmatprc"];
			}
			var lv_pstdat=[ {name:"dochdr",	value: JSON.stringify(lv_dochdr) },
											{name:"docpos",	value: JSON.stringify(lv_docpos) },
											{name:"docprc",	value: JSON.stringify(lv_docprc) },
											{name:"readonly",value:<?= ($vew_readonly?'true':'false'); ?>}
										];
			tmssCallProcess("?prg=slsinv&act=13", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "Datos Adicionales", 
					message: $(data),
					type: BootstrapDialog.TYPE_INFO,
					size: BootstrapDialog.SIZE_WIDE,
					buttons: [{ label: "<?= ($vew_readonly?$vew_lang->close:$vew_lang->cancel); ?>", cssClass: "<?= ($vew_readonly?'btn-default':'btn-danger'); ?>", action: function(dialogItself){ dialogItself.close(); } },
										{	label: "<?= $vew_lang->accept; ?>", cssClass: "<?= ($vew_readonly?'hidden':'btn-success'); ?>",	action: function(dialogItself){
                        // asigno texto de ventas a posicion
                        <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"slsinvmatslstxt",dialogItself.$modalBody.find("#slsinvmatslstxt").val(), "popup");
                      	<?php if( $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prcschcod') != '' )  { ?>
                          // asigno esquema de precios a posición
                      		var lv_prc = Number(JSON.parse(dialogItself.$modalBody.find("#grldatprc").val())[0].prccndval);
                      		var lv_qty = Number(JSON.parse(dialogItself.$modalBody.find("#grldatprc").val())[0].prccndqty);
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"slsinvmatprc",dialogItself.$modalBody.find("#grldatprc").val(), "popup");
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"matprc", lv_prc, "popup");
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"matqty", lv_qty, "popup");
                      		<?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"mattot", lv_prc * lv_qty, "popup");
                          <?= $lv_sec; ?>_refreshPrices(lv_row);
                      	<?php } ?>
                      	dialogItself.close();
											}
										}]
				});
			});
			return false;
		}
		
		$(function(){
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab001']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab003']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
      <?php if($vew_actcod == '01') { ?> <?= $lv_sec; ?>_refreshPrices(); <?php } ?>
		});
    
    $("#<?= $lv_sec; ?> #slsinvdte").on("change",function(e){
			var lv_pstdat = [{name:"excrteclscodext", value:"vta"},
											 {name:"curcodsrc",value:$("#<?= $lv_sec; ?> #curcod").prop("value")},
											 {name:"excrtedtefrm",value:$("#<?= $lv_sec; ?> #slsinvdte").prop("value")}
											];
			tmssCallProcess("?prg=finexcrte&act=19", lv_pstdat, function(data){
				$("#<?= $lv_sec; ?> #curexcrte").prop("value",(data.length>=1?(data[0]["finexcrte"]!=null?data[0]["finexcrte"]:""):""));
        $("#<?= $lv_sec; ?> #exCrteTxt").html($("#<?= $lv_sec; ?> #curexcrte").prop("value")); 
				<?= $lv_sec; ?>_refreshPrices();
			});
		});
	</script>
	<script>
		// M A T E R I A L E S
		var <?= $lv_sec; ?>_hotdoc_renderer = function (instance, td, row, col, prop, value, cellProperties) {			
			if (<?= $lv_sec; ?>_hotdoc!=undefined) {
				<?php if ( $vew_readonly ) { ?>
					var lv_ro = "#F1F1F1";
				<?php } else { ?>
					var lv_ro = "#FFFFFF";
					var lv_docreftyp = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"docreftyp");
					if ( (lv_docreftyp==null?"":lv_docreftyp)!="" ) {
            if(prop!="matprc"){
            	cellProperties.readOnly = true;
							lv_ro = "#F1F1F1"; 
            }
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
					var lv_btn = "<a href='#' onclick='<?= $lv_sec; ?>_showDetails("+row+");' class='btn btn-default btn-sm'><i class='fa fa-ellipsis-h'></i></a>";
					$(td).empty().append(lv_btn);
					td.style.backgroundColor = lv_ro;
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = lv_ro;
				}
			}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #slsinvmathot")[0];
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
					source: function (query, process) {
						if ( query.length>1 && <?= $lv_sec; ?>_hot_paste!=true ) {
							$.ajax({
								url: "?prg=stkmat&act=17", dataType: "json", data: {	prm_mattxt: query },
								complete: function(jqXHR,textStatus){if (jqXHR.responseText.substr(0,10)=="/*script*/"){ eval(jqXHR.responseText); }},
								success: function (response) {
									var lv_dat = [];
									<?= $lv_sec; ?>_hotdocchg = [];
									for (var i=0; i < response.data.length; i++) {
										<?= $lv_sec; ?>_hotdocchg.push( {mattxt: response.data[i]["mattxt"], matcod: response.data[i]["matcod"], matuntcod: response.data[i]["matuntcod"]} );
										lv_dat.push( response.data[i]["mattxt"] );
									}
									process( lv_dat );
								}
							});
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
			beforeChange : function(changes, source) {
        // si modifico el precio, actualizar el indicador de cambio manual
        if(source=="edit" && changes[0][1]=="matprc") {
        	var lv_data = JSON.parse(<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"slsinvmatprc"));
          if(lv_data != undefined){
            for (var i=0; i < lv_data.length; i++){
              if (lv_data[i].prccndcod == "<?= $lv_prccndcod; ?>"){
                lv_data[i].prcchgman = "X";
                <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(changes[0][0],"slsinvmatprc", JSON.stringify(lv_data));
              }
            }
          }
        }
        
				if(changes[0][1]=="mattxt" && source=="edit") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].mattxt == lv_value) {
							changes.push([ changes[0][0], "matcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].matcod) ]);
							changes.push([ changes[0][0], "matuntcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].matuntcod) ]);
							// si existe lista de precio asignada y no hay precio indicado para el material, obtengo el precio
              var lv_prc = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matprc");
							if ( $("#<?= $lv_sec; ?> #slsprclstcod").prop("value")!="" && (changes[0][2] != lv_value || lv_prc==null || lv_prc=="")){
								var lv_pstdat =[{name:"slsprclstcod",value: $("#<?= $lv_sec; ?> #slsprclstcod").prop("value")}, 
																{name:"slsprclstdte",value: $("#<?= $lv_sec; ?> #slsinvdte").prop("value")}, 
																{name:"slsprcsrctyp",value: "STK_MAT"},
																{name:"slsprcsrccod",value: <?= $lv_sec; ?>_hotdocchg[i].matcod},
																{name:"currow",value: changes[0][0]}
																]
								tmssCallProcessNoBackdrop("?prg=slsprclst&act=17", lv_pstdat, function(data){
									if(data.length>0){ 
                    
                    <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(changes[0][0],"matprc", isNaN(data[0]["slsprc"] / data[0]["slsprcqty"]) ? "0" : data[0]["slsprc"] / data[0]["slsprcqty"], "setting"); 

                    lv_data = JSON.parse(<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"slsinvmatprc"));
                    if(lv_data != undefined){
                      for (var i=0; i < lv_data.length; i++){
                        if (lv_data[i].prccndcod == "<?= $lv_prccndcod; ?>"){
                          lv_data[i].prcchgman = "";
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(changes[0][0],"slsinvmatprc", JSON.stringify(lv_data),"setting");
                          break;
                        }
                      }
                    }
                    <?= $lv_sec; ?>_refreshPrices(changes[0][0]);
                  }
								});
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
					} else if ( lv_dat[i]["slsinvmatcod"]!="" && lv_dat[i]["slsinvmatcod"]!=undefined ) {
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
        if (source == "edit"){
          if (<?= $lv_sec; ?>_hotdoc!=undefined) {
            if(changes && changes.length && source=="edit" && <?= $lv_sec; ?>_hot_paste!=true) {
              var lv_refresh_prices = [];
              for(var i=0; i<changes.length; i++) {
                if( changes[i][1]=="matqty" || changes[i][1]=="matprc") {
                  if(lv_refresh_prices.indexOf(changes[i][0])!==1){lv_refresh_prices.push(changes[i][0]);}
                  var lv_qty = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0], "matqty", "setting");
                  var lv_prc = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0], "matprc", "setting");
                  if(lv_qty != null && lv_prc != null){ <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "mattot", lv_qty*lv_prc, "setting" ); }

                  <?php if($lv_prccndcod!=''){ ?>
                    // actualizo la condición de precio con el valor indicado
                    var lv_matprcjsn = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0], "slsinvmatprc");
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
                      <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(changes[i][0], "slsinvmatprc", JSON.stringify( lv_matprcarr ), "setting");
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
        }
			},
			afterRemoveRow: function(index, amount){
				if (<?= $lv_sec; ?>_hotdoc!=undefined) {
          for(var i = index; i < index+amount; i++){
          	<?= $lv_sec; ?>_refreshPrices(i); 
          }
        }
			}
		};
		var <?= $lv_sec; ?>_hotdoc;	
		
		tmssLoadScript("handsontable",function(){
			<?= $lv_sec; ?>_hotdoc = new Handsontable(<?= $lv_sec; ?>_hotdoccnt, <?= $lv_sec; ?>_hotdocset);	
			var lv_dat = [<?php
				$lv_buffer='';
				foreach($vew_data->slsinvmat as $lv_row){
					$lv_slsinvmatprc = array();
					foreach($vew_data->slsinvprc as $lv_rowprc){
						unset($lv_rowprc['ctedte']); unset($lv_rowprc['upddte']);
						if($lv_rowprc['srcobjcod002']==$lv_row['slsinvmatcod']){ 
							$lv_slsinvmatprc[]=$lv_rowprc;
						}
					}
          if($vew_actcod == '001'){$lv_row['slsinvmatcod'] = '';}
					
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'slsinvmatcod:"'.$lv_row['slsinvmatcod'].'",'.
												'matcod:"'.$lv_row['matcod'].'",'.
												'mattxt:"'.$lv_row['mattxt'].'",'.
												'matqty: '.$lv_row['matqty'].' ,'.
												'matuntcod:"'.$lv_row['matuntcod'].'",'.
												'matprc: '.(isset($lv_row['matprc'])?$lv_row['matprc']:"0").' ,'.
												'mattot: '.(isset($lv_row['matprc'])?($lv_row['matqty']*$lv_row['matprc']):"0").' ,'.
												'slsinvmatprc: "'.str_ireplace('"','\"',json_encode( $this->co_reg->document->array_utf8_converter($lv_slsinvmatprc) )).'" ,'.
												'slsinvmatslstxt:`'.(utf8_decode(html_entity_decode($vew_doc->getTagValue($lv_row['slsinvmatatr'],'slsinvmatslstxt')))).'`,'.
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
				// actualizo campo de cabecera con datos de grilla de precios
				<?php if($lv_prcschcod!=''){ ?>
					$("#<?= $lv_sec; ?> #slsinvprc").text( JSON.stringify( <?= $lv_sec; ?>_hot_grldatprc.getSourceData() ) );
				<?php } ?>
				
				var lv_arr = new Array();
				// agrego las filas eliminadas
				for (var i=0; i< <?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({ "slsinvcod": $("#<?= $lv_sec; ?> #slsinvcod").prop("value"),
												"slsinvmatcod": <?= $lv_sec; ?>_hotdocdel[i]["slsinvmatcod"],
												"docreftyp":<?= $lv_sec; ?>_hotdocdel[i]["docreftyp"],
												"docrefcod":<?= $lv_sec; ?>_hotdocdel[i]["docrefcod"],
												"docrefposcod":<?= $lv_sec; ?>_hotdocdel[i]["docrefposcod"],
												"matqty":<?= $lv_sec; ?>_hotdocdel[i]["matqty"],
												"matuntcod":<?= $lv_sec; ?>_hotdocdel[i]["matuntcod"],
												"deleted":"X"
											});
				}
				// agrego filas no eliminadas
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["matcod"]!="" && lo_dat[i]["matcod"]!=undefined ) {
						lv_arr.push({	"slsinvmatcod":lo_dat[i]["slsinvmatcod"],
													"matcod":lo_dat[i]["matcod"],
													"mattxt":lo_dat[i]["mattxt"],
													"matqty":lo_dat[i]["matqty"],
													"matuntcod":lo_dat[i]["matuntcod"],
													"matprc":lo_dat[i]["matprc"],
													"curcod":lo_dat[i]["curcod"],
													"mattot":lo_dat[i]["mattot"],
													"slsinvmatslstxt":lo_dat[i]["slsinvmatslstxt"],
													"docreftyp":(typeof lo_dat[i]["docreftyp"]!=="undefined"?lo_dat[i]["docreftyp"]:""),
													"docrefcod":(typeof lo_dat[i]["docrefcod"]!=="undefined"?lo_dat[i]["docrefcod"]:""),
													"docrefposcod":(typeof lo_dat[i]["docrefposcod"]!=="undefined"?lo_dat[i]["docrefposcod"]:""),
													"slsinvmatprc":lo_dat[i]["slsinvmatprc"]
												});
					}
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #slsinvmat").prop("value", "");						
				} else {
					$("#<?= $lv_sec; ?> #slsinvmat").prop("value", JSON.stringify( lv_arr ) );
				}

			}
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
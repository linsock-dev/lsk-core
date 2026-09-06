<?php
	// url del formulario /
  $lv_lnk = "?prg=slsord&prm_slsordcod=".$vew_data->slsordcod.'&prm_mdlcod='.$vew_data->mdlcod.'&prm_prgcod='.$vew_data->prgcod;

	// campos requeridos
	$vew_input->RequiredFields( array('dstobjtyp','dstobjcod','dstobjtxt','slsorddte', 'curcod', 'docsts') );

	// clave del documento 
	$lv_dockey = $vew_data->slsordcod; 

	// titulo
	$lv_title = $vew_lang->document;
	
	// modulo y programa
	$lv_mdlcod = $vew_data->mdlcod;
	$lv_prgcod = $vew_data->prgcod;

	// libreria de estilos bootstrap
	include_once('_library.frm');
	
	$lv_prcschcod = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prcschcod');
	$lv_prccndcod = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prccndcod');
	$lv_prcschcndrow = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prcschcndrow');
	if($lv_prcschcod==''){$lv_prccndcod='';}
	$lv_refdoccls = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'refdoccls');
	$lv_refdocmdt = $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'refdocmdt');

	$lv_docref = false;	// documento referencia a otro documento
	$lv_docrefsrc = false; // documento es referenciado por otro documento
	foreach($vew_data->slsordmat as $lv_row){ 
		if ($lv_row['docreftyp']!=''){ $lv_docref=true; }
		if ($lv_row['refposqty']!=''){ $lv_docrefsrc=true; }
	}	
	$lv_dstobjtyp = strtoupper($vew_doc->getTagValue( $vew_data->sysdoccls->sysdocclsatr, 'dstobjtyp' ));
	
	$lv_rejarr = array(''=>'');
	foreach($vew_data->sysdoccls->sysdocclsrej as $lv_row) {
		if (strtoupper($vew_doc->getTagValue($lv_row['sysdocclsrejatr'],'rejman'))=='X'){
			$lv_rejarr[ $lv_row['sysdocrejcod'] ] = $lv_row['sysdocrejtxt'];
		}
	}
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
	
  <?php include('grldocfrmtlb.frm'); ?>
  
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
		<textarea id="slsordmat" name="slsordmat" class="hidden"></textarea>
    <textarea class="hidden" id="slsordprc" name="slsordprc"></textarea>
    
    <?= gethtml('prcschcod', 'hidden', $lv_prcschcod); ?>
    
		<input type="hidden" id="sec" name="sec" value="<?= $lv_sec; ?>">
    
    <div class="container-fluid" role="tabpanel"> 
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li role="presentation"><a href="#<?= $lv_sec; ?>_tab003" role="tab" data-toggle="tab"><?= $vew_lang->data; ?></a></li>
        <?php if($lv_prcschcod!=''){ ?><li role="presentation"><a href="#<?= $lv_sec; ?>_tab002" role="tab" data-toggle="tab"><?= $vew_lang->prices; ?></a></li><?php } ?>
				<li class="pull-right"><h4># <strong><?= $vew_data->slsordcod; ?><?= gethtml('slsordcod','hidden',$vew_data->slsordcod); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">        
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-6">
              <div class="card">
								<div class="card-header">
									<div class="card-title">
                    <?= ($lv_prgcod=='ord'?$vew_lang->order:($lv_prgcod=='qta'?$vew_lang->quotation:$lv_prgcod)); ?>
										<span class="tmss-card-icon">
                      <span class="tmss-card-span-cls"><?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?></span>
										</span>
                    <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
									</div>
								</div>                
                <div class="card-body tmss-card-body-edit">
                	<?php 
                    echo gethtml('dstobjtyp', 'hidden', $lv_dstobjtyp);
                    switch( $lv_dstobjtyp ) {
                      case 'SLS_CUS': case 'HLT_PAT':
                        echo vew_boot($lv_col210, array('label'=>($lv_dstobjtyp=='SLS_CUS'?$vew_lang->customer:$vew_lang->patient), 
                                                        'input1'=>vew_boot(	array('style'=>'search', 'readonly'=>($lv_docref || $lv_docrefsrc?true:$vew_readonly) ),
                                                                            array('input'=>gethtml('dstobjtxt', 'typeahead', $vew_data->dstobjtxt,($lv_docref || $lv_docrefsrc?$lv_always_disabled:$lv_default) ) ))
                                                        ));
                      break;
                    }
                    echo gethtml('dstobjcod', 'hidden', $vew_data->dstobjcod);
                    switch( $lv_dstobjtyp ) {
                      case 'SLS_CUS':  
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->contact,
                                                'input'=>vew_boot(	array('style'=>'search', 'readonly'=>($lv_docref?true:$vew_readonly) ),
                                                                    array('input'=>gethtml('dstcnttxt', 'typeahead', $vew_data->dstcnttxt,($lv_docref?$lv_always_disabled:$lv_default) ) ))
                                              ));
                        break;
                    }
                  	echo gethtml('dstcntcod', 'hidden', $vew_data->dstcntcod);
                  
                    // ARGENTINA - localizacion (puntos de venta definidos)
                    if($vew_data->bus->adr->lndcod=='AR') { ?>
                      <script>
                        $("#<?= $lv_sec; ?> #dstobjcod").on("change",function(e){
                          if($("#<?= $lv_sec; ?> #dstobjcod").prop("value") != ""){
                          	// obtengo categoria fiscal de destinatario de factura
                            var lv_pstdat =[{name:"dstobjtyp",value:$("#<?= $lv_sec; ?> #dstobjtyp").prop("value")},
                                            {name:"dstobjcod",value:$("#<?= $lv_sec; ?> #dstobjcod").prop("value")}];
                            tmssCallProcessNoBackdrop("?prg=slsord&act=getDestinationTax",lv_pstdat,function(data){
                              $("#<?= $lv_sec; ?> #taxcatcod").prop("value",data.taxcatcod);
                              $("#<?= $lv_sec; ?> #taxcattxt").prop("value",data.taxcattxt);
                              // obtengo letra
                              var lv_pstdat2 =[{name:"taxcatcodsrc",value:"<?= $vew_data->bus->tax->taxcatcod; ?>"},
                                              {name:"taxcatcoddst",value:data.taxcatcod},
                                              {name:"argltroprtyp",value:"L"}];
                              tmssCallProcessNoBackdrop("?prg=finlocargltr&act=getLetter",lv_pstdat2,function(data){
                                $("#<?= $lv_sec; ?> #slsordcodext").prop("value", (data.length>=1 ? data[0].argltrcodext : "") );
                              });
                            }); 
                          }
                        });
                      </script>
                  	<?php }                  
                    echo vew_boot($lv_col210, array("label"=>$vew_lang->description, "input"=>gethtml('slsordtxt', 'doccmt1x50', $vew_data->slsordtxt, $lv_default) ));
                	?>
                </div>
              </div>
            </div>
            
            <!-- PEDIDO -->
            <div class="col-md-6">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <?php if($vew_data->sysdoctrecod=='N'){ ?><span><span class="far fa-circle"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod=='P'){ ?><span class="text-warning"><span class="far fa-circle-half-stroke"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod=='C'){ ?><span class="text-success"><span class="fas fa-circle"></span> <?= ucfirst($vew_data->sysdoctretxt); ?></span><?php } ?>
                    <?php if($vew_data->sysdoctrecod==''){ echo '&nbsp;'; } ?>
                  	<span class="tmss-card-icon">
                    	<?= '<b><span id="slsordtotlbl">'.number_format(floatval($vew_data->slsordtotamt),2).'</span></b> '.strtolower($vew_data->curcod); ?>
                      <?= gethtml('curcod', 'hidden', $vew_data->curcod); ?>
                      <?= gethtml('slsordtot','hidden',$vew_data->slsordtotamt); ?>
                    </span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">  
                  <?php 								 
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('slsorddte', 'docdte',	$vew_data->slsorddte,	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->number, 'input'=>gethtml('slsordcodext', 'doccmt1x50', $vew_data->slsordcodext, $lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default) ));
                  ?>
                </div>
              </div> <!-- /card -->
            </div> <!-- /col -->
          </div> <!-- /row -->
          <div class="col-md-12">
            <div class="row">
              <div class="card tmss-hot-ttl">
                <div class="card-header">
                  <div class="card-title">
                    <?= $vew_lang->materials ?>
                    <?php if ($lv_refdoccls!='') { ?><a href="#" id="btndocref" class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" title="<?= $vew_lang->reference; ?>"><i class="fas fa-plus"></i></a><?php } ?>
                  </div>
                </div>
              </div> <!-- /card -->
              <div id="slsordmathot" name="slsordmathot"></div>
            </div> <!-- /col -->
          </div> <!-- /row -->
    		</div> <!-- /tab001 -->
        
        <!-- PRECIOS -->
        <div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab002">
					<div class="row">
						<div class="col-sm-12">
              <div class="card tmss-hot-ttl">
                <div class="card-header">
                  <div class="card-title">
                  	<?= $vew_lang->prices; ?>
                    <small class="tmss-desk-btn pull-right"><?= $vew_lang->PriceList.': <strong id="prcLstTxt">'.ucfirst(strtolower($vew_data->slsprclsttxt)).'</strong>&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;'.$vew_lang->exchangerate.': <strong id="exCrteTxt">'.(is_string($vew_data->curexcrte)?$vew_data->curexcrte:number_format($vew_data->curexcrte, 5)).'</strong>'; ?></small>
                    <small class="tmss-mob-btn pull-left fs-11"><?= $vew_lang->PriceList.': <strong id="prcLstTxt">'.ucfirst(strtolower($vew_data->slsprclsttxt)).'</strong>&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;'.$vew_lang->exchangerate.': <strong id="exCrteTxt">'.(is_string($vew_data->curexcrte)?$vew_data->curexcrte:number_format($vew_data->curexcrte, 5)).'</strong>'; ?></small>
                  </div>
                </div>
              </div> <!-- card -->
              <div id="divprcgrd"></div>
            </div> <!-- /col -->
					</div> <!-- /row -->
				</div> <!-- /tab002 -->
        
        <!-- DATOS -->
				<div role="tabpanel" class="tab-pane" id="<?= $lv_sec; ?>_tab003">
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
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->exchangerate,'input'=>gethtml('curexcrte', 'docnum0905', $vew_data->curexcrte, $lv_always_disabled) ));
                  ?>
                </div>
            	</div>
          	</div>   
            <div class="col-md-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->validity; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_col2424, array('label'=>$vew_lang->from, 'input1'=>gethtml('slsordstrdte',	'docdte',	$vew_data->slsordstrdte,	$lv_default), 'label2'=> $vew_lang->to,'input2'=>gethtml('slsordenddte',	'docdte',	$vew_data->slsordenddte,	$lv_default) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->rejection, 'input'=>gethtml('sysdocrejcod', $lv_rejarr, $vew_data->sysdocrejcod, $lv_default, true) ));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->fiscalcategory, 'input'=>gethtml('taxcattxt', 'taxcattxt', '', $lv_always_disabled) ));
                  	echo gethtml('taxcatcod', 'hidden', '');
                  ?>
                </div>
              </div> <!-- /card -->
            </div> <!-- /col -->
          </div> <!-- /row -->
        </div> <!-- /tab003 -->  
    	</div> <!-- tabcontent -->     
  	</div> <!-- container-fluid --> 
	</form>
  <script>
    function <?= $lv_sec; ?>_GridRefresh(){ <?= $lv_sec; ?>_fnc({action: '99'}); }
  	// paytrmtxt - typeahead
		var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"docsts" : "A", "paytrmgrp" : "(like)D"}, "fldasg" : {"paytrmtxt" : "paytrmtxt", "paytrmcod" : "paytrmcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #paytrmtxt"), "finpaytrm", lo_get);
		
    var lo_beforeAssign = function(){ <?= $lv_sec; ?>_paste = true; }
    var lo_afterAssign = function(){ <?= $lv_sec; ?>_paste = false; /*<?= $lv_sec; ?>_refreshPrices();*/ $("#<?= $lv_sec; ?> #dstobjcod").change(); $("#<?= $lv_sec; ?> #slsorddte").change(); $("#<?= $lv_sec; ?> #prcLstTxt").html( $("#<?= $lv_sec; ?> #slsprclsttxt").val().substr(0,1).toUpperCase()+$("#<?= $lv_sec; ?> #slsprclsttxt").val().substr(1).toLowerCase() );}
    
    <?php if ($lv_dstobjtyp=='SLS_CUS'){ ?>
      // dstobjtxt
      var lo_get = {"fldsec" : "<?= $lv_sec; ?>","fldflt":{"c.docsts":"A"},  "fldasg" : {"dstobjtxt" : "custxt", "dstobjcod" : "cuscod", "slsprclstcod" : "slsprclstcod", "slsprclsttxt" : "slsprclsttxt", "curcod" : "curcod", "paytrmcod" : "paytrmcod", "paytrmtxt" : "paytrmtxt", "taxcatcod" : "taxcatcod", "taxcattxt":"taxcattxt"}}; 
      tmssTypeahead($("#<?= $lv_sec; ?> #dstobjtxt"), "slscus", lo_get, {"beforeAssign" : lo_beforeAssign, "afterAssign" : lo_afterAssign}  );
    <?php } else if ($lv_dstobjtyp=='HLT_PAT'){ ?>
      // dstobjtxt
      var lo_get = {"fldsec" : "<?= $lv_sec; ?>","fldflt":{"p.docsts":"A"},  "fldasg" : {"dstobjtxt" : "pattxt", "dstobjcod" : "patcod"}}; 
      tmssTypeahead($("#<?= $lv_sec; ?> #dstobjtxt"), "hltpat", lo_get, {"beforeAssign" : lo_beforeAssign, "afterAssign" : lo_afterAssign}  );
    <?php } ?>

    <?php
      switch( $lv_dstobjtyp ) {
        case 'STK_STL': 
          break;
        case 'SLS_CUS': case 'BUY_SUP': case 'HLT_PAT': ?>
          // source contact
          var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"dstcntcod" : "cntcod", "dstcnttxt" : "cnttxt"}, "fldflt" : {"c.cntsrctyp" : "<?= $lv_dstobjtyp; ?>", "c.cntsrccod":$("#<?= $lv_sec; ?> #dstobjcod"), "c.docsts":"A"} }; 
          tmssTypeahead($("#<?= $lv_sec; ?> #dstcnttxt"), "grldatcnt", lo_get);
    <?php	break; } ?>

    // slsprclsttxt - typeahead
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldflt" : {"p.docsts" : "A"}, "fldasg" : {"slsprclsttxt" : "slsprclsttxt", "slsprclsttxtlbl" : "slsprclsttxt", "slsprclstcod" : "slsprclstcod"}}; 
    tmssTypeahead($("#<?= $lv_sec; ?> #slsprclsttxt"), "slsprc", lo_get);
    
    $(function(){
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab001']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
			$("a[data-toggle='tab'][href='#<?= $lv_sec; ?>_tab002']").on("shown.bs.tab",function(e){tmssHandsontableResize();});
      <?php if($vew_actcod == '01') { ?> <?= $lv_sec; ?>_refreshPrices(); <?php } ?>
		});
  </script>
  <script>		
		var <?= $lv_sec; ?>_paste = false;
    
    // obtengo categoria fiscal de destinatario de factura
    if ($("#<?= $lv_sec; ?> #dstobjcod").prop("value") != ""){
    	var lv_pstdat =[{name:"dstobjtyp",value:$("#<?= $lv_sec; ?> #dstobjtyp").prop("value")},
                      {name:"dstobjcod",value:$("#<?= $lv_sec; ?> #dstobjcod").prop("value")}];
      tmssCallProcessNoBackdrop("?prg=slsord&act=getDestinationTax", lv_pstdat, function(data){
        $("#<?= $lv_sec; ?> #taxcatcod").prop("value",data.taxcatcod);
        $("#<?= $lv_sec; ?> #taxcattxt").prop("value",data.taxcattxt);
      }); 
    }

		// cargo precios de cabecera del documento
		$(function(){
			var lv_dochdr = {};
			var lv_tmparr = $("#<?= $lv_sec; ?>_frm").serializeArray();
			for(var i=0; i<lv_tmparr.length; i++){ lv_dochdr[ lv_tmparr[i]["name"] ] = lv_tmparr[i]["value"]; }
			<?php
				$lv_slsordmatprc = array();
				foreach($vew_data->slsordprc as $lv_rowprc){
					unset($lv_rowprc['ctedte']); unset($lv_rowprc['upddte']);
					if($lv_rowprc['srcobjcod002']==''){ $lv_slsordmatprc[]=$lv_rowprc; }
				}
				echo 'var lv_docprc = "'.str_ireplace('"','\"',json_encode( $this->co_reg->document->array_utf8_converter($lv_slsordmatprc) )).'";';
			?>
			
			var lv_pstdat=[ {name:"dochdr",value:JSON.stringify(lv_dochdr)}, 
											{name:"docpos",value:JSON.stringify("{}")}, 
											{name:"docprc",value:lv_docprc},
											{name:"sec",value:"<?= $lv_sec; ?>"},
											{name:"readonly",value:"true"},
											{name:"totalonly",value:"true"}
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
        if (lv_tmp[i]["sysdocrejcod"] == undefined || lv_tmp[i]["sysdocrejcod"] == "" || lv_tmp[i]["sysdocrejcod"] == "0"){
          if(typeof lv_tmp[i]["slsordmatprc"]!="undefined"){
            lv_docprc.push( JSON.parse( lv_tmp[i]["slsordmatprc"] ) );
          }
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
			$("#<?= $lv_sec; ?> #slsordtotlbl").text( lv_tot.toLocaleString('en-US', {minimumFractionDigits: 2}) );
      $("#<?= $lv_sec; ?> #slsordtot").val(lv_tot);

      <?= $lv_sec; ?>_hot_grldatprc.loadData( lv_out );
		}
		
		
		
		// REFRESH ALL PRICES
		// actualiza todas las posiciones
		function <?= $lv_sec; ?>_refreshAllPrices(){
			for(var i=0; i < <?= $lv_sec; ?>_hotdoc.getSourceData().length; i++){

        if(<?= $lv_sec; ?>_hotdoc.getSourceDataAtRow(i).matcod != undefined){
					<?= $lv_sec; ?>_refreshPrices( i , true);
        }
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
			lv_docprc = JSON.parse( (typeof lv_data[lv_row]["slsordmatprc"]!="undefined" && lv_data[lv_row]["slsordmatprc"]!="" ? lv_data[lv_row]["slsordmatprc"] : "[]") );
			if(typeof lv_data[lv_row]["slsordmatprc"]!="undefined" && lv_data[lv_row]["slsordmatprc"]!="" ){ delete lv_data[lv_row]["slsordmatprc"]; }
      
      // si no se hizo un cambio de precio manual y se está en modo modificación, se recuperan los datos de precios de la lista de precios asociada          
      if("<?= !$vew_readonly ?>" == "1"){
        for (var i = 0; i < lv_docprc.length; i++){
          if (lv_docprc[i].prccndcod == "<?= $lv_prccndcod; ?>"){
            if(lv_docprc[i].prcchgman != "X"){
              var lv_pstdat =[{name:"slsprclstcod",value: $("#<?= $lv_sec; ?> #slsprclstcod").prop("value")}, 
                                  {name:"slsprclstdte",value: $("#<?= $lv_sec; ?> #slsorddte").prop("value")}, 
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
        tmssCallProcessNoBackdrop("?prg=slsord&act=calc",lv_pstdat,function(data){
          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row, "slsordmatprc", JSON.stringify(data["docprc"]) );
      		//Si se está haciendo un refreshAllPrices() se llama de vuelta a calc
      		//La primera vez es para obtener el esquema de precios, luego se modifica y se llama de vuelta a calc para hacer el cálculo
					if(lv_refreshAllPrices){
          	// actualizo la condición de precio con el valor indicado
            var lv_matprcjsn = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(lv_row, "slsordmatprc");
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
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row, "slsordmatprc", JSON.stringify( lv_matprcarr ), "setting");
            }
            //vuelvo a llamar a la función para calcular con el esquema modificado
            lv_docprc = JSON.parse( (typeof lv_data[lv_row]["slsordmatprc"]!="undefined"?lv_data[lv_row]["slsordmatprc"]:"[]") );
              var lv_pstdat=[ {name:"dochdr",value:JSON.stringify(lv_dochdr)}, 
                              {name:"docpos",value:JSON.stringify(lv_docpos)}, 
                              {name:"docprc",value:JSON.stringify(lv_docprc)},
                              {name:"readonly",value:<?= ($vew_readonly?'true':'false'); ?>}
                            ];
            tmssCallProcessNoBackdrop("?prg=slsord&act=calc",lv_pstdat,function(data){
              <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row, "slsordmatprc", JSON.stringify(data["docprc"]), "setting" );
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
        $("#<?= $lv_sec; ?> #slsordtotlbl").text( lv_grltot.toLocaleString('en-US', {minimumFractionDigits: 2}) );
    		$("#<?= $lv_sec; ?> #slsordtot").val(lv_grltot);
    	<?php } ?>
		}
		
		
		
		// actualiza precios - control de cambios del documento
		$("#<?= $lv_sec; ?> #srcobjcod, #<?= $lv_sec; ?> #paytrmcod, #<?= $lv_sec; ?> #slsprclstcod, #<?= $lv_sec; ?> #curcod, #<?= $lv_sec; ?> #slsinvdte").on("change",function(e){
			if (<?= $lv_sec; ?>_paste==false){ <?= $lv_sec; ?>_refreshAllPrices(); }
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
				var lv_ro_color = "#F1F1F1";
				var lv_color = "#FFFFFF";

				// esta linea referencia a otro documento
				var lv_docref = false;
				var lv_docreftyp = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"docreftyp");
				if ( (lv_docreftyp==null?"":lv_docreftyp)!="" ) { lv_docref=true; }

				// esta linea es referenciada por otro documento
				var lv_docrefqty = false;
				var lv_docrefminqty = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"docrefminqty");
				if ( (lv_docrefminqty==null?"":lv_docrefminqty.toString())!="" ) { lv_docrefqty = true; }

				var lv_ro = <?php echo($vew_readonly?'true':'false'); ?>;
				var lv_sysdocrejcod = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(row,"sysdocrejcod");
				lv_sysdocrejcod = (lv_sysdocrejcod==null || lv_sysdocrejcod==""?"0":lv_sysdocrejcod);
				
				if ( prop=="matqty" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);			
					td.style.backgroundColor = (lv_ro || lv_docref || lv_sysdocrejcod!="0" ?lv_ro_color:lv_color);
					cellProperties.readOnly = (lv_ro || lv_docref || lv_sysdocrejcod!="0" ?true:false);
				} else if ( prop=="matprc" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);			
					td.style.backgroundColor = (lv_ro || lv_docref || lv_docrefqty || lv_sysdocrejcod!="0" ? lv_ro_color:lv_color);
					cellProperties.readOnly = (lv_ro || lv_docref || lv_docrefqty || lv_sysdocrejcod!="0" ?true:false);
				} else if ( prop=="mattot" ) {
					Handsontable.renderers.NumericRenderer.apply(this, arguments);			
					td.style.backgroundColor = lv_ro_color;
					cellProperties.readOnly = true;
				} else if ( prop=="icn" ) {
					var lv_btn = "<a href='#' onclick='<?= $lv_sec; ?>_showDetails("+row+");' class='btn "+(lv_sysdocrejcod!="0"?"btn-danger":"btn-default")+" btn-sm'><span class='fa fa-ellipsis-h'></span></a>";
					$(td).empty().append(lv_btn);
					td.style.backgroundColor = lv_ro;
				} else {
					Handsontable.renderers.TextRenderer.apply(this, arguments);
					td.style.backgroundColor = (lv_ro || lv_docref || lv_docrefqty || lv_sysdocrejcod!="0" ?lv_ro_color:lv_color);
					cellProperties.readOnly = (lv_ro || lv_docref || lv_docrefqty || lv_sysdocrejcod!="0" ?true:false);
				}
			}
		};
		var <?= $lv_sec; ?>_hot_paste = false;
		var <?= $lv_sec; ?>_hot_autocomplete = false;
		var <?= $lv_sec; ?>_hotdocerr = [];
		var <?= $lv_sec; ?>_hotdocchg = [];
		var <?= $lv_sec; ?>_hotdocdel = [];
		var <?= $lv_sec; ?>_hotdoccnt = $("#<?= $lv_sec; ?> #slsordmathot")[0];
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
						if ( query.length>1 && <?= $lv_sec; ?>_hot_paste==false ) {
							$.ajax({
								url: "index.php?prg=stkmat&act=17", dataType: "json", data: {	prm_mattxt: query },
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
        	lv_data = JSON.parse(<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"slsordmatprc"));
          if(lv_data != undefined){
            for (var i=0; i < lv_data.length; i++){
              if (lv_data[i].prccndcod == "<?= $lv_prccndcod; ?>"){
                lv_data[i].prcchgman = "X";
                <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(changes[0][0],"slsordmatprc", JSON.stringify(lv_data),"setting");
                break;
              }
            }
          }
        }
        
        
				if(source=="edit" && changes[0][1]=="mattxt") {
					var lv_value = changes[0][3];
					for(var i=0 ; i < <?= $lv_sec; ?>_hotdocchg.length ; i++) {
						if(<?= $lv_sec; ?>_hotdocchg[i].mattxt == lv_value) {
							changes.push([ changes[0][0], "matcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].matcod) ]);
							changes.push([ changes[0][0], "matuntcod", "", String(<?= $lv_sec; ?>_hotdocchg[i].matuntcod) ]);
							// si existe lista de precio asignada y no hay precio indicado para el material, obtengo el precio
              var lv_prc = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"matprc");
							if ( $("#<?= $lv_sec; ?> #slsprclstcod").prop("value")!="" && (changes[0][2] != lv_value || lv_prc==null || lv_prc=="")){
                var lv_pstdat =[{name:"slsprclstcod",value: $("#<?= $lv_sec; ?> #slsprclstcod").prop("value")}, 
                                {name:"slsprclstdte",value: $("#<?= $lv_sec; ?> #slsorddte").prop("value")}, 
                                {name:"slsprcsrctyp",value: "STK_MAT"},
                                {name:"slsprcsrccod",value: <?= $lv_sec; ?>_hotdocchg[i].matcod},
                                {name:"currow",value: changes[0][0]}
                                ]
                tmssCallProcessNoBackdrop("?prg=slsprclst&act=17", lv_pstdat, function(data){
                  if(data.length>0){ 
                    <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(changes[0][0],"matprc", isNaN(data[0]["slsprc"] / data[0]["slsprcqty"]) ? "0" : data[0]["slsprc"] / data[0]["slsprcqty"], "setting"); 

                    lv_data = JSON.parse(<?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[0][0],"slsordmatprc"));
                    if(lv_data != undefined){
                      for (var i=0; i < lv_data.length; i++){
                        if (lv_data[i].prccndcod == "<?= $lv_prccndcod; ?>"){
                          lv_data[i].prcchgman = "";
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(changes[0][0],"slsordmatprc", JSON.stringify(lv_data),"setting");
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
					} else if ( lv_dat[i]["slsordmatcod"]!="" && lv_dat[i]["slsordmatcod"]!=undefined ) {
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
        if (source == "edit"){
          if (changes && changes.length && <?= $lv_sec; ?>_hot_autocomplete!=true) {
            if (<?= $lv_sec; ?>_hotdoc!=undefined) {
              var lv_refresh_prices = [];
              for(var i=0; i<changes.length; i++) {
                if( changes[i][1]=="matqty" || changes[i][1]=="matprc") {
                  if(lv_refresh_prices.indexOf(changes[i][0])!==1){lv_refresh_prices.push(changes[i][0]);}
                  var lv_qty = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0], "matqty");
                  var lv_prc = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0], "matprc");
                  if(lv_qty != null && lv_prc != null){ <?= $lv_sec; ?>_hotdoc.setDataAtRowProp( changes[i][0], "mattot", lv_qty*lv_prc, "setting" ); }

                  <?php if($lv_prccndcod!=''){ ?>
                    // actualizo la condición de precio con el valor indicado
                    var lv_matprcjsn = <?= $lv_sec; ?>_hotdoc.getDataAtRowProp(changes[i][0], "slsordmatprc");
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
                      <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(changes[i][0], "slsordmatprc", JSON.stringify( lv_matprcarr ), "setting");
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
				foreach($vew_data->slsordmat as $lv_row){ 
          
        	$lv_slsordmatprc = array();
          foreach($vew_data->slsordprc as $lv_rowprc){
            unset($lv_rowprc['ctedte']); unset($lv_rowprc['upddte']);
            if($lv_rowprc['srcobjcod002']==$lv_row['slsordmatcod']){ 
              $lv_slsordmatprc[]=$lv_rowprc;
            }
          }
          if($vew_actcod == '001'){$lv_row['slsordmatcod'] = '';}
          
					$lv_buffer .= ($lv_buffer!=''?',':'').'{'.
												'slsordmatcod:"'.$lv_row['slsordmatcod'].'",'.
												'matcod:"'.$lv_row['matcod'].'",'.
												'mattxt:`'.$lv_row['mattxt'].'`,'.
												'matqty: '.$lv_row['matqty'].' ,'.
												'matuntcod:"'.$lv_row['matuntcod'].'",'.
												'matprc: '.$lv_row['matprc'].' ,'.
												'mattot: '.($lv_row['matqty']*$lv_row['matprc']).' ,'.
            						'slsordmatprc: "'.str_ireplace('"','\"',json_encode( $this->co_reg->document->array_utf8_converter($lv_slsordmatprc) )).'" ,'.
												'slsordmatslstxt:`'.(utf8_decode(html_entity_decode($vew_doc->getTagValue($lv_row['slsordmatatr'],'slsordmatslstxt')))).'`,'.
												'docreftyp:"'.$lv_row['docreftyp'].'",'.
												'docrefcod:"'.$lv_row['docrefcod'].'",'.
												'docrefposcod:"'.$lv_row['docrefposcod'].'",'.
												'sysdocrejcod:"'.$lv_row['sysdocrejcod'].'",'.
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
		$("#<?= $lv_sec; ?> #slsorddte").on("change",function(e){
			var lv_pstdat = [{name:"excrteclscodext", value:"vta"},
											 {name:"curcodsrc",value:$("#<?= $lv_sec; ?> #curcod").prop("value")},
											 {name:"excrtedtefrm",value:$("#<?= $lv_sec; ?> #slsorddte").prop("value")}
											];
			tmssCallProcess("?prg=finexcrte&act=19", lv_pstdat, function(data){
				$("#<?= $lv_sec; ?> #curexcrte").prop("value",(data.length>=1?(data[0]["finexcrte"]!=null?data[0]["finexcrte"]:""):""));
        $("#<?= $lv_sec; ?> #exCrteTxt").html($("#<?= $lv_sec; ?> #curexcrte").prop("value")); 
				<?= $lv_sec; ?>_refreshPrices();
			});
		});
		
		// curcod
		$("#<?= $lv_sec; ?> #curcod").on("change",function(e){
			var lv_pstdat = [{name:"excrteclscodext", value:"vta"},
											 {name:"curcodsrc",value:$(this).prop("value")},
											 {name:"excrtedtefrm",value:$("#<?= $lv_sec; ?> #slsorddte").prop("value")}
											];
			tmssCallProcess("?prg=finexcrte&act=19", lv_pstdat, function(data){
				$("#<?= $lv_sec; ?> #curexcrte").prop("value",(data.length>=1?(data[0]["finexcrte"]!=null?data[0]["finexcrte"]:""):""));
			});
		}).next("span").children("a:first").on("click", function(e) { e.preventDefault();
			tmssPopup("<?= $vew_lang->currency; ?>","?prg=admcur&prm_vewcod=VEW_ADM_CUR_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[curcod:curcod]");
		});
		
		// AGREGAR REFERENCIA
		$("#<?= $lv_sec; ?> #btndocref").on("click",function(e){ e.preventDefault(); 
			if ( $("#<?= $lv_sec; ?> #dstobjcod").prop("value")=="" ) {
				toastr.warning("Debe indicar el origen.");
				$("#<?= $lv_sec; ?> #dstobjtxt").focus();
			} else {
				// obtengo los IDs de los documentos referenciados previamente y que no hayan sido grabados
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_refarr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( (lo_dat[i]["slsordmatcod"]==undefined?"":lo_dat[i]["slsordmatcod"])=="" && (lo_dat[i]["docreftyp"]==undefined?"":lo_dat[i]["docreftyp"])!="" ) {
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
													refobjcod: "<?= $vew_data->slsordcod; ?>",
													fndobjtyp: $("#<?= $lv_sec; ?> #dstobjtyp").prop("value"),
													fndobjcod: $("#<?= $lv_sec; ?> #dstobjcod").prop("value"),
													fndobjtxt: $("#<?= $lv_sec; ?> #dstobjtxt").prop("value"),
													fndcntcod: $("#<?= $lv_sec; ?> #dstcntcod").prop("value"),
													fndcnttxt: $("#<?= $lv_sec; ?> #dstcnttxt").prop("value"),
													refarr: JSON.stringify(lv_refarr)
												};
				tmssCallProcess("?prg=grldocflw&act=01", lv_pstdat, function( data ){
					var lv_objtxt = $("#<?= $lv_sec; ?> #dstobjtxt").prop("value");
					var lv_cnttxt = $("#<?= $lv_sec; ?> #dstcnttxt").prop("value");
					BootstrapDialog.show({
						size: BootstrapDialog.SIZE_WIDE,
						title: "Agregar Referencia - <?= $vew_data->sysdoccls->sysdocclstxt; ?> ("+lv_objtxt+(lv_cnttxt==""?"":" / "+lv_cnttxt)+") ",
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
	</script>
	<script>
		function <?= $lv_sec; ?>_showDetails( lv_row ) {
      if(typeof <?= $lv_sec; ?>_hotdoc=="undefined"){ return false; }
			
			var lv_dochdr = {};
			var lv_docpos = JSON.parse(JSON.stringify(<?= $lv_sec; ?>_hotdoc.getSourceData()[lv_row]));
			var lv_docprc = [];
			
			// completo datos de cabecera con los datos del formulario
			var lv_tmparr = $("#<?= $lv_sec; ?>_frm").serializeArray();
			for(var i=0; i<lv_tmparr.length; i++){ lv_dochdr[ lv_tmparr[i]["name"] ] = lv_tmparr[i]["value"]; }
      lv_dochdr["prcschcalctr"] = "slsord";
      lv_dochdr["prcschcalact"] = "calc";
			
			// quito el detalle de precios de la posición
			if(typeof lv_docpos["slsordmatprc"]!=="undefined"){ 
				lv_docprc = JSON.parse(lv_docpos["slsordmatprc"]);
				delete lv_docpos["slsordmatprc"];
			}
			var lv_pstdat=[ {name:"dochdr",	value: JSON.stringify(lv_dochdr) },
											{name:"docpos",	value: JSON.stringify(lv_docpos) },
											{name:"docprc",	value: JSON.stringify(lv_docprc) },
											{name:"readonly",value:<?= ($vew_readonly?'true':'false'); ?>}
										];
                       
      tmssCallProcess("?prg=slsord&act=13", lv_pstdat, function(data){
      	BootstrapDialog.show({
					title: "Datos Adicionales", 
					message: $(data),
					type: BootstrapDialog.TYPE_INFO,
					size: BootstrapDialog.SIZE_WIDE,
					buttons: [{ label: "<?= ($vew_readonly?$vew_lang->close:$vew_lang->cancel); ?>", cssClass: "<?= ($vew_readonly?'btn-default':'btn-danger'); ?>", action: function(dialogItself){ dialogItself.close(); } },
										{	label: "<?= $vew_lang->accept; ?>", cssClass: "<?= ($vew_readonly?'hidden':'btn-success'); ?>",	action: function(dialogItself){
                        // asigno texto de ventas a posicion
                        <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"slsordmatslstxt",dialogItself.$modalBody.find("#slsordmatslstxt").val(), "popup");
                        <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"sysdocrejcod",dialogItself.$modalBody.find("#sysdocrejcod").val(), "popup");
                      	<?php if( $vew_doc->getTagValue($vew_data->sysdoccls->sysdocclsatr,'prcschcod') != '' )  { ?>
                          // asigno esquema de precios a posición
                      		var lv_prc = Number(JSON.parse(dialogItself.$modalBody.find("#grldatprc").val())[0].prccndval);
                      		var lv_qty = Number(JSON.parse(dialogItself.$modalBody.find("#grldatprc").val())[0].prccndqty);
                          <?= $lv_sec; ?>_hotdoc.setDataAtRowProp(lv_row,"slsordmatprc",dialogItself.$modalBody.find("#grldatprc").val(), "popup");
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
	</script>
  <script>
    function <?= $lv_sec; ?>_fncext(lp_prm){
      if ( lp_prm["action"]=="01" ) {
				tmssLink("?prg=slsord&act=01&prm_mdlcod=<?= $vew_data->mdlcod; ?>&prm_prgcod=<?= $vew_data->prgcod; ?>", [{target: "_replace_with", target_id: "#<?= $lv_sec; ?>"}]);
				return false;
			}
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
					$("#<?= $lv_sec; ?> #slsordprc").text( JSON.stringify( <?= $lv_sec; ?>_hot_grldatprc.getSourceData() ) );
				<?php } ?>
				
				// obtengo datos de handsontable
				var lo_dat = <?= $lv_sec; ?>_hotdoc.getSourceData();
				var lv_arr = new Array();
        var lv_arr_error = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					if ( lo_dat[i]["matcod"]!="" && lo_dat[i]["matcod"]!=undefined ) {
            // Que el total referenciado debe ser menor o igual a la cantidad que estoy queriando grabar del material 
            if(lo_dat[i]["docrefsrcqty"]==undefined || lo_dat[i]["matqty"] >= lo_dat[i]["docrefsrcqty"]){
              lv_arr.push({	"slsordmatcod":lo_dat[i]["slsordmatcod"],
                            "matcod":lo_dat[i]["matcod"],
                            "mattxt":lo_dat[i]["mattxt"],
                            "matqty":lo_dat[i]["matqty"],
                            "matuntcod":lo_dat[i]["matuntcod"],
                            "matprc":lo_dat[i]["matprc"],
                            "curcod":lo_dat[i]["curcod"],
                            "mattot":lo_dat[i]["mattot"],
                            "slsordmatprc":lo_dat[i]["slsordmatprc"],
                            "slsordmatslstxt":lo_dat[i]["slsordmatslstxt"],
                            "docreftyp":lo_dat[i]["docreftyp"],
                            "docrefcod":lo_dat[i]["docrefcod"],
                            "docrefposcod":lo_dat[i]["docrefposcod"],
                            "sysdocrejcod":lo_dat[i]["sysdocrejcod"]
                          });
            }
            else{
              lv_arr_error.push(i);
              //pintar las celdas de color rojo que esten dentro del array
              <?= $lv_sec; ?>_hotdoc.setCellMeta(i, <?= $lv_sec; ?>_hotdoc.propToCol("matqty"), "valid", false);
            }
					}
				}
        
        // verifico error
        if(lv_arr_error.length > 0){
          <?= $lv_sec; ?>_hotdoc.render();
          // mensaje
          toastr.warning("No puede indicar una cantidad menor a lo ya referenciado");
          return false;
        }
        
        
        
				// agrego las filas eliminadas
				for (var i=0; i<<?= $lv_sec; ?>_hotdocdel.length; i++) {
					lv_arr.push({ "slsordcod": $("#<?= $lv_sec; ?> #slsordcod").prop("value"),
												"slsordmatcod": <?= $lv_sec; ?>_hotdocdel[i]["slsordmatcod"],
												"docreftyp":<?= $lv_sec; ?>_hotdocdel[i]["docreftyp"],
												"docrefcod":<?= $lv_sec; ?>_hotdocdel[i]["docrefcod"],
												"docrefposcod":<?= $lv_sec; ?>_hotdocdel[i]["docrefposcod"],
												"matqty":<?= $lv_sec; ?>_hotdocdel[i]["matqty"],
												"matuntcod":<?= $lv_sec; ?>_hotdocdel[i]["matuntcod"],
												"deleted":"X"
											});
				}
				if (lv_arr.length==0) {
					$("#<?= $lv_sec; ?> #slsordmat").prop("value", "");						
				} else {
					$("#<?= $lv_sec; ?> #slsordmat").prop("value", JSON.stringify( lv_arr ) );
				}

			}
    }
  </script>
  <?php include( 'grldocfrmscr.frm' ); ?>
</section>
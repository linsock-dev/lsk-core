<?php
	// campos requeridos
	$vew_input->RequiredFields( array() );

	// librería de estilos bootstrap
	include_once('_library.frm');

	// valores x default
	$lv_paymth_select = '<select id="paymth" name="paymth" class="form-control">';
	$lv_paymth_select .= '<option value="" data-paymthtyp=""></option>';
	if($vew_data->paymth!=""){
    foreach($vew_data->paymth as $lv_row){
      if($vew_data->paymthdat['objtyp']=='TSR_TIN' && ($vew_doc->getTagValue($lv_row['tsrpaymthatr'],'tsrtin')==1?'ON':'OFF' )=='ON'){
      	$lv_paymth_select .= '<option value="'.$lv_row['paymthcod'].'" data-paymthtyp="'.strtolower($lv_row['paymthtyp']).'">'.$lv_row['paymthtxt'].'</option>';
      } else if($vew_data->paymthdat['objtyp']=='TSR_TOU' && ($vew_doc->getTagValue($lv_row['tsrpaymthatr'],'tsrtou')==1?'ON':'OFF' )=='ON'){
      	$lv_paymth_select .= '<option value="'.$lv_row['paymthcod'].'" data-paymthtyp="'.strtolower($lv_row['paymthtyp']).'">'.$lv_row['paymthtxt'].'</option>';
      } else if($vew_data->paymthdat['objtyp']=='TSR_TID' && ($vew_doc->getTagValue($lv_row['tsrpaymthatr'],'tsrtid')==1?'ON':'OFF' )=='ON'){
      	$lv_paymth_select .= '<option value="'.$lv_row['paymthcod'].'" data-paymthtyp="'.strtolower($lv_row['paymthtyp']).'">'.$lv_row['paymthtxt'].'</option>';
      }
    }
  }
	$lv_paymth_select .= '</select>';
	$tsrmovdocdte=$vew_data->paymthdat["tsrmovdocdte"];
?>
<section id="<?= $lv_sec; ?>">
	<div class="form-horizontal">
		<div class="container-fluid">
			<div class="row">
				<?php
        	//codigo de caja, codigo de via de pago, curcod
        	echo gethtml('tsrmovdoccshcod', 'hidden', $vew_data->paymthdat['tsrmovdoccshcod']);
        	echo gethtml('tsrmovdocvalcod', 'hidden', $vew_data->paymthdat['tsrmovdocvalcod']);
         	echo gethtml('tsrmovdoccurcod', 'hidden', $vew_data->paymthdat['tsrmovdoccurcod']);
					echo vew_boot($lv_col210, array('label'=>$vew_lang->type,'input'=>$lv_paymth_select));
  				echo '<div id="paymthdat">';
        
        	//cheque en cartera -pagos
        	//numero de cheque typeahead y id
         	echo vew_boot($lv_col210, array('label'=>$vew_lang->checkbooknumber,
                                       	  'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                          		array('input'=>gethtml('bnkchknum', 'typeahead', $vew_data->paymthdat['tsrmovdocvalcodext'], $lv_always_disabled )))));
        	echo gethtml('cshvalcod', 'hidden', $vew_data->paymthdat['cshvalcod']);
        
          //cheque/chequera -pagos
        	//cuenta de chequera y codigo de chequera
        	echo vew_boot($lv_col210, array('label'=>$vew_lang->checkbooks,
                                      	  'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                          		array('input'=>gethtml('bnkchktxt', 'typeahead', $vew_data->paymthdat['bnkchktxt'], $lv_default )))));
         	echo gethtml('bnkchkcod',	'hidden', $vew_data->paymthdat['bnkchkcod']);	
        	//cheque -cobranza 
        	//numero de cheque txt, banco, codigo de banco, fecha de cobro
        	echo vew_boot($lv_col210, array('label'=>$vew_lang->number,'input'=>gethtml('tsrmovdocvalcodext', 'docnum0800',$vew_data->paymthdat['tsrmovdocvalcodext'], $lv_default) ));
          echo vew_boot($lv_col210, array('label'=>$vew_lang->bank, 'input'=>vew_boot( array('style'=>'search','readonly'=>$vew_readonly), 
                                    array('input'=>gethtml('bnktxt', 'typeahead', $vew_data->paymthdat['bnktxt'], $lv_default) )) ));
          echo gethtml('bnkcod',	'hidden', $vew_data->paymthdat['bnkcod']);
        	echo vew_boot($lv_col210, array('label'=> $vew_lang->date,'input'=>gethtml('tsrmovdocvaldte',	'docdte',	$vew_data->paymthdat['tsrmovdocvaldte'],	$lv_default) ));
          
        	
        	//tranferencia -pago
        	//cuenta, codigo de cuenta
          echo gethtml('bnkacccod', 'hidden', $vew_data->paymthdat['bnkacccod']);
          echo vew_boot($lv_col210, array('label'=>$vew_lang->account,
                                          	'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                                array('input'=>gethtml('bnkacctxt', 'typeahead', $vew_data->paymthdat['bnkacctxt'], $lv_default )))));
          //tarjeta -cobranza
        	//numero de tarjeta, titular,fecha de vencimiento
        	echo vew_boot($lv_col210, array('label'=>$vew_lang->number,'input'=>gethtml('bnktjtnum', 'docnum1600', $vew_data->paymthdat['tsrmovdocvalcodext'], $lv_default) ));	
          echo vew_boot($lv_col210, array('label'=>$vew_lang->owner,'input'=>gethtml('bnktjtowr', 'doccmt1x50', $vew_data->paymthdat['tsrmovdocvaltxt'], $lv_default) ));
      		echo vew_boot($lv_col210, array('label'=> $vew_lang->duedate,'input'=>gethtml('bnktjtenddte',	'typeahead',	($vew_data->paymthdat['tsrmovdocvaldte']!=''?date('d/Y',strtotime($vew_data->paymthdat['tsrmovdocvaldte'])):''),	$lv_default) ));
        	//tarjeta -pago
        	//numero de tarjeta y codigo/id de tarjeta 
        	echo vew_boot($lv_col210, array('label'=>$vew_lang->treasurycards,
                                          'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                              array('input'=>gethtml('bnktjttxt', 'typeahead',$vew_data->paymthdat['bnktjttxt'], $lv_default )))));
  				echo gethtml('bnktjtcod',	'hidden', $vew_data->paymthdat['bnktjtcod']);
        	//importe, moneda y tipo de cambio
        	echo '</div><div id="paymthgrldat">';
   				echo vew_boot($lv_col2424, array('label1'=>$vew_lang->amount, 
                                           'input1'=>gethtml('tsrmovdocvalamt', 'docnum0802', $vew_data->paymthdat['tsrmovdocvalamt'], $lv_default), 
                                           'label2'=>$vew_lang->currency, 
                                           'input2'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly), 
                                                              	array('input'=>gethtml('curcod', 'curcod', $vew_data->paymthdat['curcod'], $lv_always_disabled) )) ));
        	echo vew_boot($lv_col210, array('label'=>$vew_lang->exchangerate,	'input'=>gethtml('excrte', 'docnum0905', $vew_data->paymthdat['excrte'], $lv_always_disabled) )); 
  				echo '</div>';
				?>
			</div>
		</div>
	</div>
  <script>    
    // popup tsrmovdoccurcod   
    $("#<?= $lv_sec; ?> #curcod").next("span").children("a:first").on("click", function(e) { e.preventDefault();
    	tmssPopup("Monedas","index.php?prg=admcur&prm_vewcod=VEW_ADM_CUR_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[curcod:curcod]",function(){
      	//si las monedas son diferentes muestra el tipo de cambio
        if($("#<?= $lv_sec; ?> #curcod").val()!=$("#<?= $lv_sec; ?> #tsrmovdoccurcod").val()){
          $("#<?= $lv_sec; ?> #excrte").parent().parent().removeClass("hidden");
          var lv_pstdat = [{name:"excrteclscodext", value:"vta"},
                         	 {name:"curcodsrc",value:$("#<?= $lv_sec; ?> #curcod").val()},
                         	 {name:"excrtedtefrm",value:"<?=$tsrmovdocdte?>"}
                        	];
          //obtiene el tipo de cambio segun la moneda y la fecha de cabecera
          tmssCallProcess("?prg=finexcrte&act=19", lv_pstdat, function(data){
          	var lv_excrte = data.finexcrte ? data.finexcrte : "";
						$("#<?= $lv_sec; ?> #excrte").prop("value", lv_excrte);
          });
        }else{
        	$("#<?= $lv_sec; ?> #excrte").parent().parent().addClass("hidden");
        }
    	});                                                       
		});
    
    
    //FECHA DE VENCIMIENTO DE TARJETA.
     $("#<?= $lv_sec; ?> #bnktjtenddte").datepicker({
        format: "mm/yyyy",
        startView: "years", 
        minViewMode: "months"
    }).on("change",function(e){
       //guarda la fecha en el campo fecha tambien
       $("#<?= $lv_sec; ?> #tsrmovdocvaldte").val('01/'+$("#<?= $lv_sec; ?> #bnktjtenddte").val());
      //cierra el datepicker cuando se selecciona un mes
      $(".datepicker").hide();
    });
    
    
    //BANCO typeahead.
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{ "docsts" : "A"}, "fldasg":{ "bnkcod" : "bnkcod", "bnktxt" : "bnktxt"}};
  	tmssTypeahead($('#<?= $lv_sec; ?> #bnktxt'), "tsrbnk", lo_get);
    
    
    //CUENTA popup.
    $("#<?= $lv_sec; ?> #bnkacctxt").next("span").children("a:first").on("click", function(e) { e.preventDefault(); 
    tmssPopup("Cuentas","?prg=tsrbnkacc&prm_vewcod=VEW_TSR_BNK_ACC_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[bnkacccod:bnkacccod , bnkacctxt:bnkacctxt]");
    });
    
    
    //CHEQUERA popup. 
    $("#<?= $lv_sec; ?> #bnkchktxt").next("span").children("a:first").on("click", function(e) { e.preventDefault(); 
    tmssPopup("Chequeras","?prg=tsrbnkchk&prm_vewcod=VEW_TSR_BNK_CHK_LST&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[bnkchktxt:bnkacctxt , bnkacccod:bnkacccod , bnkchkcod:bnkchkcod , bnktxt:bnktxt , bnkcod:bnkcod , tsrmovdocvalcodext:bnkchkusdnum]");
    });
    
    //CHEQUES DE TERCEROS popup. 
    $("#<?= $lv_sec; ?> #bnkchknum").next("span").children("a:first").on("click", function(e) { e.preventDefault(); 
    tmssPopup("cheques en cartera","?prg=tsrcshval&prm_vewcod=VEW_TSR_CSH_VAL&prm_cshcod=<?=$vew_data->paymthdat['tsrmovdoccshcod']?>&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&"+
              "prm_fldasg=[cshvalcod:cshvalcod , bnkchknum:bnkaccchknum , tsrmovdocvalcodext:bnkaccchknum , tsrmovdocvaldte:bnkaccchkdtecnv , bnkcod:bnkcod , bnktxt:bnktxt , tsrmovdocvalamt:cshvaltot , curcod:curcod] ");
    });
    
		//TARJETAS popup. 
    $("#<?= $lv_sec; ?> #bnktjttxt").next("span").children("a:first").on("click", function(e) { e.preventDefault(); 
    tmssPopup("tarjetas","?prg=tsrbnktjt&prm_vewcod=VEW_TSR_BNK_TJT&prm_popup=sysdochdr_popup&prm_fldsec=<?= $lv_sec; ?>&prm_fldasg=[bnktjtcod:bnknum , bnktjttxt:bnktjtnum]");
    });

    //al cambiar el selector de metodo de pago cambia los inputs que se muestran
  	$(" #<?= $lv_sec; ?> #paymth").on("change", function(e){ e.preventDefault();                                                           
      var lv_mth={};
			lv_mth["TSR_TIN"]={"ch3":[""], "eft":[""], "trf":["#bnkcod, #bnktxt, #tsrmovdocvaldte"],"chq":["#tsrmovdocvalcodext, #tsrmovdocvaldte, #bnkcod, #bnktxt "],"otr":["#tsrmovdocvalcodext, #tsrmovdocvaldte"],"tjt":["#bnktjtnum, #bnktjtowr, #bnktjtenddte"]};
			lv_mth["TSR_TOU"]={"eft":[""], "ch3":["#bnkchknum, #tsrmovdocvaldte, #bnkcod, #bnktxt"], "trf":["#bnkacccod, #bnkacctxt"],"chq":["#bnkchktxt, #bnkacccod, #bnkchkcod, #bnkcod, #bnktxt, #tsrmovdocvalcodext"],"otr":["#tsrmovdocvalcodext, #tsrmovdocvaldte"],"tjt":["#bnktjtcod, #bnktjttxt"]};
			lv_mth["TSR_TID"]={"eft":[""], "ch3":["#bnkchknum, #tsrmovdocvaldte, #bnkcod, #bnktxt"], "trf":["#bnkacccod, #bnkacctxt"],"chq":["#bnkchktxt, #bnkacccod, #bnkchkcod, #bnkcod, #bnktxt, #tsrmovdocvalcodext"],"otr":["#tsrmovdocvalcodext, #tsrmovdocvaldte"],"dep":["#bnkacccod, #bnkacctxt"]};
      if($(this).find("option:selected").data("paymthtyp")!=""){
					$("#<?= $lv_sec; ?> #paymthdat "+lv_mth["<?= $vew_data->paymthdat['objtyp']; ?>"][ $(this).find("option:selected").data("paymthtyp")]).closest(".form-group.tmss-form-group").removeClass("hidden");
					$("#<?= $lv_sec; ?> #paymthdat input:not(" + lv_mth["<?= $vew_data->paymthdat['objtyp']; ?>"][ $(this).find("option:selected").data("paymthtyp") ] +")").prop("value","").parent().closest(".form-group.tmss-form-group").addClass("hidden");
   		}else{
				$("#<?= $lv_sec; ?> #paymthdat input").prop("value","").parent().closest(".form-group.tmss-form-group").addClass("hidden");
      }	 
                                                            
                                                            
      if(<?=$vew_data->paymthdat["actcod"]?>!="03"){
        if($(this).find("option:selected").data("paymthtyp")=="ch3" ){
          //si es cheque de terceros pone en readonly banco,fecha,importe, moneda 
        	$("#<?= $lv_sec; ?> #tsrmovdocvaldte, #bnktxt, #tsrmovdocvalamt ").attr("readonly",true);
          $("#<?= $lv_sec; ?> #tsrmovdocvaldte, #curcod").next("span").addClass("hidden");
          $("#<?= $lv_sec; ?>  #bnktxt").next().next().addClass("hidden");
        }else if($(this).find("option:selected").data("paymthtyp")=="chq" && "<?= $vew_data->paymthdat["sysdocclstxt"]; ?>"=="pagos"){
          //si es cheque de pagos  pone en readonly banco, numero  
          $("#<?= $lv_sec; ?> #bnktxt, #tsrmovdocvalcodext ").attr("readonly",true);
          $("#<?= $lv_sec; ?>  #bnktxt").next().next().addClass("hidden");
          $("#<?= $lv_sec; ?> #tsrmovdocvalamt").removeAttr("readonly");
        }else{
          //sino los vuelve a mostrar
          $("#<?= $lv_sec; ?> #tsrmovdocvaldte, #bnktxt, #tsrmovdocvalamt, #tsrmovdocvalcodext").removeAttr("readonly");
          $("#<?= $lv_sec; ?> #tsrmovdocvaldte, #curcod").next("span").removeClass("hidden");
          $("#<?= $lv_sec; ?>  #bnktxt").next().next().removeClass("hidden");
        }
      }
    });
  
    
    $(function(){
      //llama el evento change del selector al cargar la vista para mostrar los campos
      if(<?=($vew_data->paymthdat['paymthcod']!=''?'true':'false');?>){
        $(" #<?= $lv_sec; ?> #paymth").val('<?=$vew_data->paymthdat['paymthcod'];?>').trigger("change");
      }else{
        $(" #<?= $lv_sec; ?> #paymth").val($(" #<?= $lv_sec; ?> #paymth").find("option[data-paymthtyp='eft']").val()).trigger("change");
      }
      //si la via de pago tiene una moneda diferente a la de moneda de la empresa, calcula el valor 
      if($("#<?= $lv_sec; ?> #curcod").val()!=$("#<?= $lv_sec; ?> #tsrmovdoccurcod").val()){
      	$("#<?= $lv_sec; ?> #tsrmovdocvalamt").val(($("#<?= $lv_sec; ?> #tsrmovdocvalamt").val()/ $("#<?= $lv_sec; ?> #excrte").val()).toFixed(2));
      }else{
      	//sino oculta el campo de tipo de cambio al cargar la vista
    		$("#<?= $lv_sec; ?> #excrte").parent().parent().addClass("hidden"); 
      }
    });
  </script>
	<?php include('grldocfrmscr.frm'); ?>
</section>
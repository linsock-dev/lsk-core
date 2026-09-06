<?php	
	/* url del formulario */
  $lv_lnk = "?prg=stkmovdoc&act=28";

	/* campos requeridos */
	$vew_input->RequiredFields( array() );

	/* clave del documento */
	$lv_dockey = '';

	/* titulo */
	$lv_title = $vew_lang->confirmation;
	
	/* módulo y programa */
	$lv_mdlcod = 'STK';
	$lv_prgcod = 'SCF';

	$vew_actcod = '02';
	
	/* librería de estilos bootstrap */
  include_once('_library.frm');
	
	$lv_doclst = array(''=>'');
	foreach( $vew_doclst as $lv_row ) { 
		if ( ($lv_row['objtyp']=='STK_SOU' || $lv_row['objtyp']=='STK_SIN') && $vew_doc->getTagValue($lv_row['sysdocclsatr'],'stkmovrelcnf')=='X' ) {
			$lv_doclst[ $lv_row['sysdocclscod'] ] = $lv_row['sysdocclstxt'];			
		}
	}

 	//Botones de vista
	$vew_tbl['sveL'] = array('per'=>false );
  $vew_tbl['sveR'] = array('per'=>false );
	$vew_tbl['canc'] = array('per'=>false );
	$vew_dropdown = (isset($vew_dropdown) && $vew_dropdown !== '') ? $vew_dropdown : false ;
?>
<section id="<?= $lv_sec; ?>">

	<!-- Navbar -->
 	<?php include('grldocfrmtlb.frm'); ?>

  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
		
    <?= gethtml('tmss_actcod', 'hidden',''); ?>
    <?= gethtml('stkmovdoccnftyp','hidden',''); ?>
    <?= gethtml('stkmovdoccnfdte','hidden',''); ?>
    <?= gethtml('stkmovdoccnfcmt','hidden',''); ?>
    
    <div class="container-fluid">
			<div class="row">
				<div class="col-md-3">
					<div class="card">
            <div class="card-header">   
              <div class="card-title">
                <?= $lv_title; ?>
                <!--Buscar-->
                <a href="#" id="btnfnd" class="card-icon" title="<?= $vew_lang->find; ?>"><i class="fas fa-search"></i></a> 
              </div>
            </div>
            <div class="card-body tmss-card-body-edit">   
              <?= vew_boot($lv_col1212,array('label'=>$vew_lang->document,'input'=>gethtml('fnddoccls',$lv_doclst,  '', 	$lv_default))); ?>       
              <?= vew_boot($lv_col1212,array('label'=>$vew_lang->CONFIRM,	'input'=>gethtml('fnddoccnf','yesno',     '',		$lv_default))); ?>						
							<?= vew_boot($lv_col1212,array('label'=>$vew_lang->id,			'input'=>gethtml('fnddoccod','doccmt1x50','',		$lv_default))); ?>         
							<?= vew_boot($lv_col1212,array('label'=>$vew_lang->code,		'input'=>gethtml('fndcodext','doccmt1x50','',$lv_default))); ?>
              <?= vew_boot($lv_col1212,array('label'=>$vew_lang->max,			'input'=>gethtml('fnddocmax','doccmt1x50','100',$lv_default))); ?>       
            </div>
          </div> 
        </div> <!-- /col-md-3 -->
          
        <div class="col-md-9">
         <div class="card">
          <div class="card-header">
          	<div class="card-title">
              <?= $vew_lang->DOCUMENTS ?>
              <a href="#" id="btnexe" class="btn btn-default  tmssAlwaysEnabled tmssHiddeOnRead btn-success pull-right" title="<?= $vew_lang->proccess;  ?>"><span class="fas fa-cogs"></span><span class="hidden-xs">  <?= $vew_lang->confirm; ?></span></a>
            </div>
          </div>
         	<div class="card-body">
            <table class="table table-condensed table-bordered" id="cnftbl">
              <thead>
                <tr>    
                  <th><input type="checkbox" id="hdrchk"></th>
                  <th>Confirmaci&oacute;n</th>					
                  <th>ID</th>
                  <th>C&oacute;digo</th>
                  <th>Fecha</th>
                  <th>Log</th>
                </tr>
              </thead>
              <tbody id="cnftblbdy"></tbody>
            </table>
          </div> <!-- /card body --> 
         </div>   <!-- /card -->                          
      	</div> <!-- /col-md-9 -->
        
			</div> <!-- /row -->	
		</div> <!-- /container-fluid -->
	</form>
	<div id="rowfrm" class="hidden">
    <form class="form-horizontal tmss-form-horizontal pt-0 pb-0">
      <?php
        echo vew_boot($lv_col210, array('label'=>$vew_lang->confirmation,	'input'=>gethtml('rowcnftyp', array(''=>'','SI'=>'ENTREGADO','NO'=>'NO ENTREGADO'), '', $lv_default) ));
        echo vew_boot($lv_col210, array('label'=>$vew_lang->date,		 			'input'=>gethtml('rowcnfdte', 'docdte', '', $lv_default) ));
        echo vew_boot($lv_col210, array('label'=>$vew_lang->comments,			'input'=>gethtml('rowcnfcmt',	'doccmt1x50', '', $lv_default) ));
      ?>
    </form>
  </div>
	<script>
		$("#<?= $lv_sec; ?> #btnexe").on("click",function(e){
			if( $("#<?= $lv_sec; ?> #rowchk:checked").length==0 ) {
				toastr.warning("Debe seleccionar al menos un elemento de la lista a confirmar.");
        return;
			} 
				
      BootstrapDialog.show({
        title: "<?= $vew_lang->confirmation; ?>", 
        message: $("#<?= $lv_sec; ?> #rowfrm > form").clone(), 
        type: BootstrapDialog.TYPE_INFO,
        buttons: [{ label: "Cancelar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
                  {	label: "OK", cssClass: "btn-primary",	action: function(dialogItself){
                    $("#<?= $lv_sec; ?> #stkmovdoccnftyp").prop("value",dialogItself.getModalBody().find("#rowcnftyp").val());
                    $("#<?= $lv_sec; ?> #stkmovdoccnfdte").prop("value",dialogItself.getModalBody().find("#rowcnfdte").val());
                    $("#<?= $lv_sec; ?> #stkmovdoccnfcmt").prop("value",dialogItself.getModalBody().find("#rowcnfcmt").val());
                    if( $("#<?= $lv_sec; ?> #stkmovdoccnftyp").prop("value")=="" ) {
                      toastr.warning("Debe seleccionar la confirmación.");
											return;
										}
                    if ( $("#<?= $lv_sec; ?> #stkmovdoccnfdte").prop("value")=="" ) {
                      toastr.warning("Debe indicar la fecha.");
											return;
                    }
										$("#<?= $lv_sec; ?> #rowchk:checked").each( function(e) {
											toastr.info("Documento confirmado.");
											var lv_stkmovdoccod = $(this).data("stkmovdoccod");
											var lv_pstdat =[{name: "stkmovdoccod", value: lv_stkmovdoccod},
																			{name: "stkmovdoccnftyp", value: $("#<?= $lv_sec; ?> #stkmovdoccnftyp").prop("value")},
																			{name: "stkmovdoccnfdte", value: $("#<?= $lv_sec; ?> #stkmovdoccnfdte").prop("value")},
																			{name: "stkmovdoccnfcmt", value: $("#<?= $lv_sec; ?> #stkmovdoccnfcmt").prop("value")}
																			];											
											tmssCallProcess( "?prg=stkmovdoc&act=47", lv_pstdat, function(data){
												var lv_chk = $("#<?= $lv_sec; ?> #rowchk[data-stkmovdoccod="+lv_stkmovdoccod+"]"); 
												if ( data.errtyp=="S" ) {
													$(lv_chk).parent().parent().removeClass("bg-info").addClass("bg-success");
												} else {
													$(lv_chk).parent().parent().removeClass("bg-info").addClass("bg-danger");
													$(lv_chk).parent().parent().find("td[name=errlog]").text(data.errtxt);  
												}
											});                         
                    }); 
                    dialogItself.close();
                  } 
                }] 
				}); 
		});
    
    //boton buscar
		$("#<?= $lv_sec; ?> #btnfnd").on("click",function(e){ e.preventDefault();
			if ( $("#<?= $lv_sec; ?> #fnddoccls").prop("value")=="" ) {
				toastr.warning("Debe indicar la clase de documento.");
				$("#<?= $lv_sec; ?> #fnddoccls").focus();
        return false;
			} 
       var lv_pstdat = [{name: "fnddoccls", value: $("#<?= $lv_sec; ?> #fnddoccls").prop("value")},
                        {name: "fnddoccnf", value: $("#<?= $lv_sec; ?> #fnddoccnf").prop("value")},
                        {name: "fnddoccod", value: $("#<?= $lv_sec; ?> #fnddoccod").prop("value")},
                        {name: "fndcodext", value: $("#<?= $lv_sec; ?> #fndcodext").prop("value")},
                        {name: "fndatr", 		value: $("#<?= $lv_sec; ?> #msgfndatr").prop("value")},
                        ];                                             
			if ( $("#<?= $lv_sec; ?> #fnddocmax").prop("value")!=""){
				lv_pstdat.push( {name: "fnddocmax", value: $("#<?= $lv_sec; ?> #fnddocmax").prop("value")} );
			}
      tmssCallProcess( "?prg=stkmovdoc&act=49", lv_pstdat, function(data){
        if ( Array.isArray(data) ) {
          var lv_cnftyp;
          var lv_cnfdte;
          var lv_cnfcmt;
          var lv_tbl = "";
          var lv_canmencer = (data.length > ( $("#<?= $lv_sec; ?> #fnddocmax").prop("value") != "" ?  $("#<?= $lv_sec; ?> #fnddocmax").prop("value") : 100 ) ? data.length-1 : data.length);         
          for(var i=0; i<lv_canmencer; i++) {
            if (data[i]["stkmovdoccnf"]!=null){
              lv_cnftyp = $("<div>"+data[i]["stkmovdoccnf"]+"</div>").find("cnftyp").text();   
              lv_cnfdte = $("<div>"+data[i]["stkmovdoccnf"]+"</div>").find("cnfdte").text();	 
              lv_cnfcmt = $("<div>"+data[i]["stkmovdoccnf"]+"</div>").find("cnfcmt").text(); 	 
            }
            lv_tbl += "<tr>"        
                      +"<td><input type='checkbox' id='rowchk' data-stkmovdoccod='"+data[i]["stkmovdoccod"]+"'></td>"
                      +"<td>"+(data[i]["stkmovdoccnf"]==null?"":"X")+"</td>"
                      +"<td><a name='rowdoclnk' href='#' data-stkmovdoccod='"+data[i]["stkmovdoccod"]+"'>"+data[i]["stkmovdoccod"]+"</a></td>"
                      +"<td>"+data[i]["fndcodext"]+"</td>"						
                      +"<td>"+data[i]["stkmovdocdtecnv"]+"</td>"
                      +"<td>"+(data[i]["stkmovdoccnf"]==null?"&nbsp;":(lv_cnftyp=="SI"?"ENTREGADO":"NO ENTREGADO")+" - "+lv_cnfdte+"<br>"+lv_cnfcmt)+"</small></td>"             
                      +"</tr>";
          }
          
          var lv_nmewnt = "";
          if( $("#<?= $lv_sec; ?> #fnddocmax").prop("value") != "" ){
            if( data.length > $("#<?= $lv_sec; ?> #fnddocmax").prop("value") ){ 
             	var lv_nmewnt = "<span class='pagination-info'>Hay m&aacute;s de <span class='badge'>"+(data.length-1)+"</span> registros encontrados.</span>";
        		} else {
              var lv_nmewnt = "<span class='pagination-info'>Hay <span class='badge'>"+(data.length)+"</span> registros encontrados.</span>";
            }
          } else if( data.length > 100 ) {
            	var lv_nmewnt = "<span class='pagination-info'>Hay m&aacute;s de <span class='badge'>100</span> registros encontrados.</span>";
          } else {
            	var lv_nmewnt = "<span class='pagination-info'>Hay <span class='badge'>"+(data.length)+"</span> registros encontrados.</span>";
          }        
          
          $("#<?= $lv_sec; ?> #cnftblbdy").html(lv_tbl);  
          
          if($("#<?= $lv_sec; ?> span.pagination-info").length > 0){
            $("#<?= $lv_sec; ?> span.pagination-info").html(lv_nmewnt);
          }else{
            $("#<?= $lv_sec; ?> #cnftbl").after(lv_nmewnt);
          }    
          
          $("#<?= $lv_sec; ?> a[name='rowdoclnk']").on("click",function(e){e.preventDefault();
          tmssLink("?prg=stkmovdoc&act=03&prm_mdlcod=STK&prm_prgcod=SOU&prm_stkmovdoccod="+$(this).data("stkmovdoccod"), [{target: "_new_section"}] );
          });
          $("#<?= $lv_sec; ?> #rowchk").on("change",function(e){
            if ( $(this).is(":checked") ) {
              $(this).parent().parent().addClass("bg-info");
            } else {
              $(this).parent().parent().removeClass("bg-info");
            }
          });
        }
      });
		});	
		$("#<?= $lv_sec; ?> #hdrchk").on("change",function(e){
			$("#<?= $lv_sec; ?> #rowchk").prop("checked",$(this).is(":checked")).trigger("change");
		});
	</script>
    <?php include('grldocfrmscr.frm'); ?>
</section>
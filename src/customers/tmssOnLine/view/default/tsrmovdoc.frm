<?php 
	// url del formulario
  $lv_lnk = '?prg=tsrmovdoc&prm_tsrmovdoccod='.$vew_data->tsrmovdoccod.'&prm_mdlcod='.$vew_data->mdlcod.'&prm_prgcod='.$vew_data->prgcod;

	// campos requeridos
	$vew_input->RequiredFields( array('tsrmovdocdte','cshtxt','srcobjtxt','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->tsrmovdoccod; 

	// titulo
	$lv_title = $vew_lang->General;
	
	// modulo y programa
	$lv_mdlcod = $vew_data->mdlcod;
	$lv_prgcod = $vew_data->prgcod;
	$lv_objtyp = strtoupper($vew_data->mdlcod.'_'.$vew_data->prgcod);
	$lv_srcobjtyp = strtoupper($vew_doc->getTagValue( $vew_data->sysdoccls->sysdocclsatr, 'srcobjtyp' ));


	// librer?a de estilos bootstrap
	include_once('_library.frm');

	// valores x default
	if ( $vew_data->tsrmovdoccod=='' ) {
		$vew_data->tsrmovdocdte = date('d/m/Y');
		$vew_data->docsts = 'A';
	}
  //si esta contablizado no permitir ninguna edicion
	if( $vew_data->docsts=='C' ) {
  	$vew_actcod='03';
	}
	
	// Botones por vista
  $vew_tbl['accL'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09') && $vew_data->sysdoctrecod!='C', 'acc'=>'');
	$vew_tbl['accR'] = array ('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'09') && $vew_data->sysdoctrecod!='C', 'acc'=>'');
	$vew_tbl['modL'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
	$vew_tbl['modR'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'02'));
	$vew_tbl['delsep'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'04'));
	$vew_tbl['del'] = array('per'=>$vew_data->docsts!='C' && $vew_sec->hasPermission($lv_mdlcod, $lv_prgcod,'04'));
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
 		<?= gethtml('tmss_actcod',	'hidden', ''); ?>
		<textarea class="hidden" id="tsrmovdoccmp" name="tsrmovdoccmp"><?=json_encode( $vew_data->tsrmovdoccmp); ?></textarea>
    <textarea class="hidden" id="tsrmovdocval" name="tsrmovdocval"><?=json_encode( $vew_data->tsrmovdocval); ?></textarea>
		
    <div class="container-fluid" role="tabpanel"> 
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->tsrmovdoccod; ?><?= gethtml('tsrmovdoccod',	'hidden', $vew_data->tsrmovdoccod ); ?></strong></h4></li>
			</ul>
			<div class="tab-content tmss-tab-content">
			
				<!-- GENERAL -->
				<div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">						
					<div class="row">
						<div class="col-md-7">
            	<div class="card">
              	<div class="card-header">
                  <div class="card-title"><?= $lv_title; ?>
                    <span class="tmss-card-icon">
                      <?= ucfirst(strtolower($vew_data->sysdoccls->sysdocclstxt)); ?>
                      <?= gethtml('sysdocclscod', 'hidden', $vew_data->sysdoccls->sysdocclscod); ?>
                    </span>
                  </div>
                </div>
                <div class="card-body tmss-card-body-edit">
                  <?php 
                    $lv_ttl='<objeto de origen>';
                    switch( $lv_srcobjtyp ) {
                      case 'SLS_CUS': $lv_ttl = $vew_lang->customer; break;
                      case 'EDU_STU': $lv_ttl = $vew_lang->student; break;
                    	case 'BUY_SUP': $lv_ttl = $vew_lang->supplier; break; 
                      case 'HLT_PAT': $lv_ttl = $vew_lang->patient; break;
                      case 'HLT_DEL': $lv_ttl = $vew_lang->delegation; break;
                      case 'SPT_PTN': $lv_ttl = $vew_lang->partner; break;
											default: $lv_ttl = '';
                    }
										
										// origen
                    echo gethtml('srcobjtyp',	'hidden',$lv_srcobjtyp);
                    echo gethtml('srcobjcod',	'hidden',$vew_data->srcobjcod);
										echo vew_boot($lv_col210, array('label'=>$lv_ttl, 
																										'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_data->tsrmovdoccod!=''?true:$vew_readonly),
																																			array('input'=>gethtml('srcobjtxt', 'typeahead', $vew_data->srcobjtxt, $vew_data->tsrmovdoccod!=''?$lv_always_disabled:$lv_default) ))));
										
										// cuenta
										echo gethtml('bnkacccod',	'hidden',$vew_data->bnkacccod);
										if( $lv_objtyp=='TSR_TID'){
											echo vew_boot($lv_col210, array('label'=>$vew_lang->account, 
																											'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly),
																																				array('input'=>gethtml('bnkacctxt', 'typeahead', $vew_data->bnkacctxt,$lv_default ) ))));
										} else {
											echo gethtml('bnkacctxt',	'hidden',$vew_data->bnkacctxt);											
										}
										
										// concepto
                    echo gethtml('tsrmovtypcod', 'hidden',$vew_data->tsrmovtypcod);																																		
										echo vew_boot($lv_col210, array('label'=>$vew_lang->concept, 
																										'input'=>vew_boot(array('style'=>'search', 'readonly'=>$vew_readonly),
																																			array('input'=>gethtml('tsrmovtyptxt', 'typeahead', $vew_data->tsrmovtyptxt, $lv_default) ))));
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->description, 'input'=>gethtml('tsrmovdoctxt', 'doccmt1x50', $vew_data->tsrmovdoctxt, $lv_default) ));
                  ?>
            		</div><!--/body-->
           		</div><!-- /card -->
						</div><!-- /col-md-7 -->
						<div class="col-md-5">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= ucfirst($vew_lang->data); ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php 								 
                   	echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 'input'=>gethtml('tsrmovdocdte',	'docdte',	$vew_data->tsrmovdocdte,	$lv_default) ));
                   	echo vew_boot($lv_col210, array('label'=>$vew_lang->number, 'input'=>gethtml('tsrmovdoccodext',	'doccmt1x20',	$vew_data->tsrmovdoccodext,	$lv_default) ));
                  	echo vew_boot($lv_col210, array('label'=>$vew_lang->cash,   
                                                  	'input'=>vew_boot( array('style'=>'search', 'readonly'=>( count($vew_data->tsrmovdocval)!=0?true:$vew_readonly)),
                                                                     	 array('input'=>gethtml('cshtxt', 'typeahead', $vew_data->cshtxt, ( count($vew_data->tsrmovdocval)!=0?$lv_always_disabled:$lv_default)) ))));                   
                  	echo gethtml('cshcod', 'hidden', $vew_data->cshcod);
                    echo gethtml('curcod', 'hidden', $vew_data->curcod);
                    echo vew_boot($lv_col210, array('label'=>$vew_lang->status, 'input'=>gethtml('docsts', 'docstsacc', $vew_data->docsts, $lv_default) ));
                  ?>
								</div>
              </div> <!-- /card -->
            </div> <!-- /col-md-5 -->
					</div> <!-- /row -->
          <div class="row">
            <div class="col-md-7 <?= ($lv_objtyp=='TSR_TID'?'hidden':''); ?>">
              <div class="card">
                <div class="card-header">
									<div class="card-title">
                    <div class="row">
            					<div class="col-md-10">
												<?= $vew_lang->documents; ?><span class="tmss-card-icon"><b><span id="finsumtotlbl">0.00</span></b> <?=strtolower($vew_data->curcod); ?></span>
                      </div>
                      <div class="col-md-2">
                        <a href="#" id="btndocref" class="card-icon text-center tmssAlwaysEnabled tmssHiddeOnRead" <?= ($vew_actcod=='01'||$vew_actcod=='02'?'':'hidden'); ?> title="<?= $vew_lang->reference; ?>"><i class="fas fa-plus"></i></a>
                      </div>
                    </div>    
									</div>
								</div>
      					<div class="card-body">
									<table class="table" id="finsumdoctbl">
          					<thead>
											<tr>
												<th class="<?= ($vew_actcod=='01'||$vew_actcod=='02'?'':'hidden'); ?>"><input type="checkbox" id="allchk"></th>
												<th><?= $vew_lang->customer; ?></th>
												<th><?= $vew_lang->document; ?></th>
												<th><?= $vew_lang->duedate; ?></th>
												<th><?= $vew_lang->total; ?></th>
											</tr>
										</thead>
                    <tbody>
                    <?php
                      $lv_readonly = !empty($lv_row['tsrmovdoccmpcod']);
  										$lv_buffer='';
  										foreach($vew_data->tsrmovdoccmp as $lv_row){
                      	switch( $lv_row['docobjtyp'] ) {
                          case 'SLS_INV': $lv_vou='FC'; $lv_ttl='FACTURA'; break;
                          case 'SLS_CRE': $lv_vou='NC'; $lv_ttl='NOTA DE CREDITO'; break;
                          case 'SLS_DEB': $lv_vou='ND'; $lv_ttl='NOTA DE DEBITO'; break;
                          case 'BUY_INV': $lv_vou='FC'; $lv_ttl='FACTURA'; break;
                          case 'BUY_CRE': $lv_vou='NC'; $lv_ttl='NOTA DE CREDITO'; break;
                          case 'BUY_DEB': $lv_vou='ND'; $lv_ttl='NOTA DE DEBITO'; break;
													default: $lv_vou=$lv_row['docobjtyp']; $lv_ttl='Undefined'; break;
        								}
                        $lv_buffer .='<tr>'.
                                    '<td class="'.($vew_actcod=='01'||$vew_actcod=='02'?'':'hidden').'"><input type=checkbox checked=true data-tsrmovdoccmpcod="'.$lv_row['tsrmovdoccmpcod'].'" data-srcobjtyp="'.$lv_row['docobjtyp'].'" data-srcobjcod="'.$lv_row['docobjcod'].'"></td>'.	
                                    '<td>'.$lv_row['refobjtxt'].'</td>'.
                                    '<td><a href="#" data-toggle="tooltip" data-placement="right" title="'.$lv_ttl.'" name="lnkdoc"  data-srcobjtyp="'.$lv_row['docobjtyp'].'" data-srcobjcod="'.$lv_row['docobjcod'].'">'.$lv_vou.' '.$lv_row['docobjcodext'].'</a></td>'.
                                    '<td>'.($lv_row['docobjduedte']??'').'</td>'.
                                    //'<td>'.(isset($lv_row['docobjduedte'])?$lv_row['docobjduedte']->format('d.m'):'').'</td>'.
                                    '<td><input type="number" class="form-control" name="finsumamt" min="0" max="'.$lv_row['finsumdoctot'].'" step="0.01" value="'. ($lv_row['tsrmovdoccmpamt']!=".00"? number_format(floatval($lv_row['tsrmovdoccmpamt']),2,'.',''):'0.00').'" '.(!empty($lv_row['tsrmovdoccmpcod'])?'disabled':'').'></td>'.	
                                    '</tr>';
                        }
                      	echo $lv_buffer;
  										?>
										</tbody>
									</table>
                  <span class="pagination-info">Registros encontrados <span class="badge"><?=count($vew_data->tsrmovdoccmp);?></span></span>
								</div>
  						</div> <!-- /card -->
            </div>
            <div class="<?= ($lv_objtyp=='TSR_TID'?'col-md-12':'col-md-5'); ?>">
              <div class="card">
                <div class="card-header">
                  <div class="card-title">
                    <div class="row">
            					<div class="col-md-8">
                        <?= ($lv_objtyp=='TSR_TID'?$vew_lang->values:$vew_lang->PAYMENTWAYS); ?>
                      </div>
                      <div class="col-md-2">
                        <span class="tmss-card-icon">
                            <?= '<b><span id="tsrmovdoctotlbl">'.number_format(floatval($vew_data->tsrmovdoctot),2).'</span></b> '.strtolower($vew_data->curcod); ?>
                            <?= gethtml('curcod', 'hidden', $vew_data->curcod); ?>
                            <?= gethtml('tsrmovdoctot','hidden',$vew_data->tsrmovdoctot); ?>
                        </span>
                      </div> 
                      <div class="col-md-2">
                    		<a href="#" class="far fa-plus card-btn pull-right <?= ($vew_actcod=='01'||$vew_actcod=='02'?'':'hidden'); ?>" id="addpaymth"></a>
                      </div>
                    </div>    
                	</div>
              	</div>
      					<div class="card-body">
									<table class="table">
          					<thead><tr><th><?= $vew_lang->paymenttype ?></th><th><?= $vew_lang->amount ?></th></tr></thead>
										<tbody id="tsrmovdoctbl">
                    	<?php
  											//carga tabla de metodos de pago
  											$i=0;
                        foreach($vew_data->tsrmovdocval as $lv_row){
                          $i++;
                          $lv_trdat='data-tsrmovdocvalcod="'.(isset($lv_row['tsrmovdocvalcod'])?$lv_row['tsrmovdocvalcod']:'').'" '.
                                    'data-tsrmovdocvalcodext="'.(isset($lv_row['tsrmovdocvalcodext'])?$lv_row['tsrmovdocvalcodext']:'').'" '.
                            				'data-tsrmovdocvaltxt="'.(isset($lv_row['tsrmovdocvaltxt'])?$lv_row['tsrmovdocvaltxt']:'').'" '.
                                    'data-tsrmovdocvaldte="'.(isset($lv_row['tsrmovdocvaldte'])? $lv_row['tsrmovdocvaldte']->format('d/m/Y'):'').'" '.
                          					'data-cshvalcod="'.(isset($lv_row['cshvalcod'])?$lv_row['cshvalcod']:'').'" '.          
                            				'data-bnktxt="'.(isset($lv_row['bnktxt'])?$lv_row['bnktxt']:'').'" '.
                                    'data-bnkcod="'.(isset($lv_row['bnkcod'])?$lv_row['bnkcod']:'').'" '.
                                    'data-bnkacccod="'.(isset($lv_row['bnkacccod'])?$lv_row['bnkacccod']:'').'" '.
                                    'data-bnkacctxt="'.(isset($lv_row['bnkacctxt']) ?$lv_row['bnkacctxt']:'').'" '.
                                    'data-bnktjtcod="'.(isset($lv_row['bnktjtcod'])?$lv_row['bnktjtcod']:'').'" '.
                                    'data-bnktjttxt="'.(isset($lv_row['bnktjttxt'])?$lv_row['bnktjttxt']:'').'" '.
                                    'data-bnkchktxt="'.(isset($lv_row['bnkchktxt'])?$lv_row['bnkchktxt']:'').'" '.
                            				'data-bnkchkcod="'.(isset($lv_row['bnkchkcod'])?$lv_row['bnkchkcod']:'').'" '.
                                    'data-paymthcod="'.(isset($lv_row['paymthcod'])?$lv_row['paymthcod']:'').'" '.
                                    'data-curcod="'.(isset($lv_row['curcod'])?$lv_row['curcod']:'').'" '.
                                    'data-excrte="'.(isset($lv_row['excrte'])?$lv_row['excrte']:'').'" ';
                          $lv_tr='<tr id="'.$i.'" '.$lv_trdat.'" >'.
                                 '<td><a href="#" name="paymth"> '. $lv_row['paymthtxt'].'</a></td>'.
                                 '<td><input type=number class="form-control" name="tsrmovamt" id="tsrmovamt" value="'. number_format(floatval($lv_row['tsrmovdocvalamt']),2,'.','').'"></td>'.
                                 '</tr>';
                          echo $lv_tr;
                        }
                      ?>
										</tbody>
									</table>
								</div>
  						</div> <!-- /card -->
            </div><!-- /col-md-5 -->
        	</div><!-- /row -->
				</div> <!-- /tab001 -->
			</div> <!-- /tab-content -->     
		</div> <!-- /container-fluid --> 
  </form>
  <script>
		var go_comp = []
		go_comp["SLS_INV"] = {vou:"FC",ttl:"FACTURA"};
		go_comp["SLS_CRE"] = {vou:"NC",ttl:"NOTA DE CREDITO"};
		go_comp["SLS_DEB"] = {vou:"ND",ttl:"NOTA DE DEBITO"};
		go_comp["BUY_INV"] = {vou:"FC",ttl:"FACTURA"};
		go_comp["BUY_CRE"] = {vou:"NC",ttl:"NOTA DE CREDITO"};
		go_comp["BUY_DEB"] = {vou:"ND",ttl:"NOTA DE DEBITO"};
		
		
    //al cargar la pagina
    $(function(){
      //linkear acciones de comprobantes al cargar
    	<?= $lv_sec; ?>_linkDocuments();    
      
    	//calcular total tabla comprobantes al cargar         
    	<?= $lv_sec; ?>_calcTotalComp();
      
    	//calcular total tabla metodos de pago al cargar
    	<?= $lv_sec; ?>_calcTotalval();    

      //añadir metodo de pago
    	$("#<?= $lv_sec; ?>	#addpaymth").on("click", function(e){ e.preventDefault();
        //verifica si hay caja seleccionada si no avisa                                                       
    		if($("#<?= $lv_sec; ?>	#cshcod").val()!=""){
          <?= $lv_sec; ?>_OpenDialog();  
        }else{
  				BootstrapDialog.alert("debe ingresar una caja primero");
        }
			});

    	//onclick de link de via de pago
    	$("#<?= $lv_sec; ?>	#tsrmovdoctbl tr a").on("click", function(e){ e.preventDefault();                                                                                                            
      	<?= $lv_sec; ?>_OpenDialog(this);                                                   
    	});
       
    	//onchange de input importe de via de pago
      $("#<?= $lv_sec; ?>	#tsrmovdoctbl [name='tsrmovamt']").on("change", function(e){ e.preventDefault();
        if($(this).val()==0){$(this).val("0.00");}
        	<?= $lv_sec; ?>_calcTotalval();
      });
    });		
		
    
		// Pupup para agregar comprobante
		$("#<?= $lv_sec; ?> #btndocref").on("click", function(){
      BootstrapDialog.show({
        title: "Agregar comprobantes",
        size: BootstrapDialog.SIZE_WIDE,
        message: $('<table class="table" id="docreftbl">'+
                        '<thead>'+
                            '<tr>'+
                                '<th><input type="checkbox" id="allchkcmp"></th>'+
                   							'<th><?= $vew_lang->customer; ?></th>'+
                                '<th><?= $vew_lang->document; ?></th>'+
                                '<th><?= $vew_lang->duedate; ?></th>'+
                                '<th><?= $vew_lang->total; ?></th>'+
                            '</tr>'+
                        '</thead>'+
                        '<tbody></tbody>'+
                    '</table>'),
        buttons: [{	label: "Agregar", cssClass: "btn-success",	action: function(dialogItself){
                    // mover comprobantes seleccionados a la tabla principal
                    $("#docreftbl tbody input[type=checkbox]:checked").each(function(){
                        var $row = $(this).closest("tr");
                        $row.appendTo("#<?= $lv_sec; ?> #finsumdoctbl tbody");
                    });
                    var docreftot = $("#<?= $lv_sec; ?> #finsumdoctbl tbody tr").length;
                    $("#<?= $lv_sec; ?> span.pagination-info span.badge").text(docreftot);
          					<?= $lv_sec; ?>_linkDocuments();
          					<?= $lv_sec; ?>_calcTotalComp();
                    dialogItself.close();
                    }
                  },
                  { label: "Cancelar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } }],
        onshown: function(){
          <?= $lv_sec; ?>_getDocuments();
          
          //marcar/desmarcar todos los checkbox del popup
          $("#allchkcmp").on("change", function(){
            $("#docreftbl tbody input[type=checkbox]").prop("checked", $(this).prop("checked"));
          });
        }
      });
  	});
    
		
    // LINK DOCUMENTS. activa links de documentos de la tabla
    function <?= $lv_sec; ?>_linkDocuments(){
      // link de la descripcion del comprobante para ver detalles de comprobante 
      $("#<?= $lv_sec; ?> a[name=lnkdoc], #docreftbl a[name=lnkdoc]").off("click").on("click", function(e){ e.preventDefault(); 
        // Cierra el dialog si existe
        $.each(BootstrapDialog.dialogs, function(id, dialog){
          dialog.close();
        });
    		
        var lv_docprm = $(this).data("srcobjtyp").replace("_","").toLowerCase()+"cod";
        var lv_doccod = $(this).data("srcobjcod");
        var lv_ctr = $(this).data("srcobjtyp").replace("_","").toLowerCase();
        var lv_mdlcod = $(this).data("srcobjtyp").split("_")[0];
        var lv_prgcod = $(this).data("srcobjtyp").split("_")[1];
        tmssLink("?prg="+lv_ctr+"&act=03&prm_mdlcod="+lv_mdlcod+"&prm_prgcod="+lv_prgcod+"&prm_"+lv_docprm+"="+lv_doccod,[{target: "_new_section"}]);
      });

      //accion del campo importe de comprobante y check de comprobante para atualizar el total
    	$("#<?= $lv_sec; ?>	input[name=finsumamt], #<?= $lv_sec; ?> input[type=checkbox]").on("change", function(e){ e.preventDefault();
        if( ($(this).val()==0 || $(this).val()=="") && $(this).prop("name")=="finsumamt" ){$(this).val("0.00");}
        <?= $lv_sec; ?>_calcTotalComp();
      });
    }
    
		// GET DOCUMENTS. carga tabla de comprobantes al modal
    function <?= $lv_sec; ?>_getDocuments(){
			<?php if($lv_objtyp!='TSR_TID'){ ?>
			$("#docreftbl tbody").html("");
      var lv_pstdat = [{name:"srcobjcod", value:$("#<?= $lv_sec; ?> #srcobjcod").val()},
                       {name:"srcobjtyp", value:"<?= $lv_srcobjtyp ?>"}];
      var lv_finsumcod="";
      tmssCallProcess("?prg=finsum&act=19", lv_pstdat, function(data){				
        if(data.data[0]==undefined){
          toastr.warning( "no se encontro cuenta corriente");
					return;
				}
        lv_finsumcod=data.data[0].finsumcod;  
        //llama finsumdoc para obtener los comprobantes para dicho finsumcod
        var lv_pstdat2 = [{name:"finsumcod", value:lv_finsumcod},
                          {name:"vewfldflt", value: "[~fltrow~]finsumdoctotrst	>		0		"}];
        tmssCallProcess("?prg=finsum&act=18", lv_pstdat2, function(data){
          if(data.data.length==0){
            toastr.warning("No se encontraron comprobantes");
            return;
					}
          
          // guarda los comprobantes que están en la tabla principal
          var finsumdoctbl = {};
          $("#<?= $lv_sec; ?> #finsumdoctbl tbody tr").each(function(){
            var srcobjtyp = $(this).find("input[type=checkbox]").data("srcobjtyp");
            var srcobjcod = $(this).find("input[type=checkbox]").data("srcobjcod");
            if(srcobjtyp && srcobjcod){
              finsumdoctbl[srcobjtyp+"_"+srcobjcod] = true;
            }
          });
          
					// carga tabla de comprobantes
					var lv_buffer="";
          var count=0;
					for (var i = 0; i < data.data.length; i++) {
						var lv_row = data.data[i];
            
            // si el comprobante está en la tabla principal, entonces continua
            var key = lv_row.docobjtyp+"_"+lv_row.docobjcod;
            if(finsumdoctbl[key]) continue;
            
						// determino comprobante
						var lv_vou = lv_row.docobjtyp;
						var lv_ttl = "Undefined";
						if(go_comp[ lv_row.docobjtyp ]!=undefined ){
							lv_vou = go_comp[ lv_row.docobjtyp ].vou;
							lv_ttl = go_comp[ lv_row.docobjtyp ].ttl;						
						}
						// calculo fechas
            lv_days = 1
            if (lv_row.docobjduedte !== null){
            	var lv_duedte = moment( lv_row.docobjduedte.date );
              var lv_nowdte = moment();
              var lv_days = lv_duedte.diff(lv_nowdte, "days");					
            }
						// agrego comprobante a la tabla
						$("<tr>"
              +"<td><input type='checkbox' data-tsrmovdoccmpcod='' data-srcobjtyp='"+lv_row.docobjtyp+"' data-srcobjcod='"+lv_row.docobjcod+"'></td>"
              +"<td>"+lv_row.refobjtxt+"</td>"
              +"<td><a href='#' name='lnkdoc' data-srcobjtyp='"+lv_row.docobjtyp+"' data-srcobjcod='"+lv_row.docobjcod+"' >"+lv_vou+" "+lv_row.docobjcodext+"</a></td>"
              +"<td "+(lv_days<0?"class='text-danger'":"")+">"+(lv_duedte? lv_duedte.format("DD-MMM"):'')+(lv_days<0?" ("+lv_days.toString()+")":"")+"</td>"
              +"<td><input type='number' class='form-control' min='0' max='"+parseFloat(lv_row.finsumdoctotrst)+"' step='0.01' value='"+lv_row.finsumdoctotrst.toLocaleString()+"' name='finsumamt'></td>"
            +"</tr>").appendTo("#docreftbl tbody");
            delete(lv_duedte); delete(lv_nowdte); delete(lv_days);
            count++;
					}
          // Mensaje de la cantidad de comprobantes encontrados
          toastr.info( count+" documentos encontrados.");
					//linkear acciones de comprobantes
					<?= $lv_sec; ?>_linkDocuments();
        });
      });
			<?php } ?>
  	} 
    
    
    // CALC TOTAL COMP. calcula total de comprobantes seleccionados
		function <?= $lv_sec; ?>_calcTotalComp() {
      var lv_finsumtot=0;
      // suma el el importe de los comprobantes marcados y lo muestra
      $("#<?= $lv_sec; ?>	#finsumdoctbl tbody tr input[type='checkbox']:checked ").each(function(){
      	lv_finsumtot+=parseInt($(this).closest("tr").find("input[name=finsumamt]").val());
      });
      $("#<?= $lv_sec; ?> #finsumtotlbl").text(parseFloat(lv_finsumtot).toFixed(2));
			
      <?= $lv_sec; ?>_validarTotales();
			
      // valida si todos son los check estan marcados y marca el allchk
			var lv_qty = $("#<?= $lv_sec; ?> #finsumdoctbl tbody tr input[type='checkbox']").length;
			if(lv_qty!=0){
				$("#<?= $lv_sec; ?>	#allchk").prop("checked", ($("#<?= $lv_sec; ?> #finsumdoctbl tbody tr input[type='checkbox']:checked").length==lv_qty) );
			}
		}

    
    //calcula total de tabla vias de pago
		function <?= $lv_sec; ?>_calcTotalval() {
      var lv_tsrmovdoctot= 0;
      $("#<?= $lv_sec; ?>	#tsrmovdoctbl tr:not('.hidden')").each(function(){
      	lv_tsrmovdoctot+=parseFloat($(this).find("#tsrmovamt").val());
      });  
      $("#<?= $lv_sec; ?> #tsrmovdoctot").val(lv_tsrmovdoctot.toFixed(2));
      $("#<?= $lv_sec; ?> #tsrmovdoctotlbl").text(lv_tsrmovdoctot.toFixed(2));
      <?= $lv_sec; ?>_validarTotales();
		}  
    
    
    //valida que coincidan los totales de las tablas
    function <?= $lv_sec; ?>_validarTotales() {
      //marca en verde el total de metodos de pago si coinciden los totales de las tablas
      if($("#<?= $lv_sec; ?> #tsrmovdoctotlbl").text()==$("#<?= $lv_sec; ?> #finsumtotlbl").text() && $("#<?= $lv_sec; ?> #tsrmovdoctotlbl").text()!="0.00"){
      	$("#<?= $lv_sec; ?> #tsrmovdoctotlbl").parent().parent().addClass("text-success");
      }else{
        $("#<?= $lv_sec; ?> #tsrmovdoctotlbl").parent().parent().removeClass("text-success");
      }
    }
    
		
    //marcar/desmarcar todos los checkbox
    $("#<?= $lv_sec; ?>	#allchk").on("change", function(e){ e.preventDefault();
    	$("#<?= $lv_sec; ?>	#finsumdoctbl tbody tr input[type='checkbox']").prop("checked", $(this).is(":checked") );
  		<?= $lv_sec; ?>_calcTotalComp();                                          
    });
		
		
  	function <?= $lv_sec; ?>_OpenDialog(paymth){
    	var lv_id=$(paymth).closest("tr").attr("id");      
      var lv_pstdat=[]; 
      var lv_dat=[];
      //toma los datos si se le paso paymth
      if(paymth!=undefined){ lv_dat=$(paymth).closest("tr").data();}
      //define datos post
    	lv_pstdat =[{"name":"actcod","value":("<?=$vew_actcod;?>"!="00"?"<?=$vew_actcod;?>":"03")},
									{"name":"objtyp","value":"<?= $lv_objtyp; ?>"},
                  {"name":"sysdocclstxt","value":"<?=strtolower($vew_data->sysdoccls->sysdocclstxt); ?>"},
                  {"name":"tsrmovdocvalcod","value":(lv_dat.tsrmovdocvalcod!=undefined?lv_dat.tsrmovdocvalcod:"")},
                  {"name":"tsrmovdoccshcod","value":$("#<?= $lv_sec; ?> #cshcod").val()},
                  {"name":"cshvalcod", "value":(lv_dat.cshvalcod!=undefined?lv_dat.cshvalcod:"")},
          				{"name":"paymthcod","value":(lv_dat.paymthcod!=undefined?lv_dat.paymthcod:"")},
									{"name":"tsrmovdocvalcodext","value":(lv_dat.tsrmovdocvalcodext!=undefined?lv_dat.tsrmovdocvalcodext:"")},
                  {"name":"tsrmovdocvaltxt","value":(lv_dat.tsrmovdocvaltxt!=undefined?lv_dat.tsrmovdocvaltxt:"")},
                  {"name":"tsrmovdocdte","value":$("#<?= $lv_sec; ?> #tsrmovdocdte").val()},
                  {"name":"tsrmovdocvaldte","value":(lv_dat.tsrmovdocvaldte!=undefined?lv_dat.tsrmovdocvaldte:"")},
									{"name":"curcod","value":(lv_dat.curcod!=undefined?lv_dat.curcod:"<?=$vew_data->curcod;?>")},
                  {"name":"tsrmovdoccurcod","value":"<?=$vew_data->curcod;?>"},
									{"name":"excrte", "value":(lv_dat.excrte!=undefined?lv_dat.excrte:"")},
                  {"name":"bnktxt", "value":(lv_dat.bnktxt!=undefined?lv_dat.bnktxt:"")},
									{"name":"bnkcod", "value":(lv_dat.bnkcod!=undefined?lv_dat.bnkcod:"")},
                  {"name":"bnkchktxt", "value":(lv_dat.bnkchktxt!=undefined?lv_dat.bnkchktxt:"")},
                  {"name":"bnkchkcod", "value":(lv_dat.bnkchkcod!=undefined?lv_dat.bnkchkcod:"")},
                  {"name":"bnkacctxt", "value":(lv_dat.bnkacctxt!=undefined?lv_dat.bnkacctxt:"")},
    	            {"name":"bnkacccod", "value":(lv_dat.bnkacccod!=undefined?lv_dat.bnkacccod:"")},
                  {"name":"bnktjttxt","value":(lv_dat.bnktjttxt!=undefined?lv_dat.bnktjttxt:"")},
    	            {"name":"bnktjtcod", "value":(lv_dat.bnktjtcod!=undefined?lv_dat.bnktjtcod:"")},
    	            {"name":"tsrmovdocvalamt", "value":(paymth!=undefined?$(paymth).closest("tr").find("#tsrmovamt").val():$("#<?= $lv_sec; ?> #finsumtotlbl").text())}
								];  
      // se obtiene la vista de tsrmovdocval
			tmssCallProcess("?prg=tsrmovdoc&act=tsrmovdocval", lv_pstdat, function(data){     
      	//dialog para visualizar/modificar/crear via de pago
				BootstrapDialog.show({
					title: "<?= $vew_lang->PAYMENTMODE; ?>",
					message: $(data),
					closable: <?= ($vew_readonly?'true':'false'); ?>,
					draggable: true,
					size: BootstrapDialog.SIZE_NORMAL,
            onshown: function(dialog){if(lv_id!=undefined){$(dialog.$modalFooter).find("#btndel").removeClass("hidden");}},
          <?php if ( !$vew_readonly ) { ?>
						buttons: [{ id:"btndel", icon: "fas fa-trash-alt", cssClass: "btn-danger pull-left	hidden", action: function(dialogItself){ 
          							$("#<?= $lv_sec; ?> #"+lv_id).addClass("hidden"); 
          								dialogItself.close(); 
        								}
      								},
          						{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialogItself){ dialogItself.close(); } },
											{	label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success",	action: function(dialog){
                      //obtiene el cuerpo del dialogo y toma todos los datos para guardar el metodo de pago
											var lv_frm = dialog.$modalBody;
											var lv_paymthtyp = $(lv_frm).find("#paymth option:selected").text();
                    	var lv_datpaymthtyp = $(lv_frm).find("#paymth option:selected").data("paymthtyp");
                      var lv_paymthcod = $(lv_frm).find("#paymth option:selected").val();
                      var lv_trdat="";
                    	var lv_tsrmovamt = $(lv_frm).find("#tsrmovdocvalamt").val();
                      var lv_paymtherr=false;  
                      //valida si el importe es mayor a 0
                      if(lv_tsrmovamt<=0){$(lv_frm).find("#tsrmovdocvalamt").parent().addClass("has-error"); lv_paymtherr= true;}
                      //valida si la longitud de numero de tarjeta es igual a 16
                      if("<?=$vew_data->sysdoccls->sysdocclstxt;?>"=="COBRANZA" && lv_datpaymthtyp=="tjt" && 
                          ($(lv_frm).find("#bnktjtnum").val().toString().length!=16 && $(lv_frm).find("#bnktjtnum").val().toString().length!=0) ){$(lv_frm).find("#bnktjtnum").parent().addClass("has-error"); lv_paymtherr= true; toastr.warning("El n&uacute;mero de tarjeta debe tener 16 d&iacute;gitos.")}
                      //valida si la longitud de cheque es menor igual a 20
                      if("<?=$vew_data->sysdoccls->sysdocclstxt;?>"=="COBRANZA" && lv_datpaymthtyp=="chq" && 
                          ($(lv_frm).find("#tsrmovdocvalcodext").val().toString().length>20 || $(lv_frm).find("#tsrmovdocvalcodext").val().toString().length==0)  ){$(lv_frm).find("#tsrmovdocvalcodext").parent().addClass("has-error"); lv_paymtherr= true;}
                      //valida que este completo banco en cobranza cheque
                      if("<?=$vew_data->sysdoccls->sysdocclstxt;?>"=="COBRANZA" && lv_datpaymthtyp=="chq" && $(lv_frm).find("#bnktxt").val()==""){$(lv_frm).find("#bnktxt").parent().addClass("has-error"); lv_paymtherr= true;}
                      //valida fecha en cobranza cheque
                      if("<?=$vew_data->sysdoccls->sysdocclstxt;?>"=="COBRANZA" && lv_datpaymthtyp=="chq" && $(lv_frm).find("#tsrmovdocvaldte").val()==""){$(lv_frm).find("#tsrmovdocvaldte").parent().addClass("has-error"); lv_paymtherr= true;}
                      if(lv_paymtherr){return true;}
                      lv_trdat="data-tsrmovdocvalcod='"+$(lv_frm).find("#tsrmovdocvalcod").val()+"' "+
                        			 "data-paymthcod='"+lv_paymthcod+"' "+
                        			 "data-tsrmovdocvalcodext='"+($(lv_frm).find("#tsrmovdocvalcodext").val()!=""?$(lv_frm).find("#tsrmovdocvalcodext").val():$(lv_frm).find("#bnktjtnum").val())+"' "+
                               "data-tsrmovdocvaldte='"+$(lv_frm).find("#tsrmovdocvaldte").val()+"' "+
                        			 "data-curcod='"+$(lv_frm).find("#curcod").val()+"' "+
                        			 "data-tsrmovdocvaltxt='"+$(lv_frm).find("#bnktjtowr").val()+"' "+
                               "data-bnktxt='"+$(lv_frm).find("#bnktxt").val()+"' "+
                        			 "data-cshvalcod='"+$(lv_frm).find("#cshvalcod").val()+"' "+
                               "data-bnkcod='"+$(lv_frm).find("#bnkcod").val()+"' "+
                        			 "data-bnkchktxt='"+$(lv_frm).find("#bnkchktxt").val()+"' "+
                        			 "data-bnkchkcod='"+$(lv_frm).find("#bnkchkcod").val()+"' "+
                               "data-bnkacccod='"+$(lv_frm).find("#bnkacccod").val()+"' "+
                               "data-bnkacctxt='"+$(lv_frm).find("#bnkacctxt").val()+"' "+
                        			 "data-bnktjtcod='"+$(lv_frm).find("#bnktjtcod").val()+"' "+
                        			 "data-bnktjttxt='"+$(lv_frm).find("#bnktjttxt").val()+"' "+
                      	 			 "data-tsrmovamt='"+$(lv_frm).find("#tsrmovdocvalamt").val()+"' ";
                      //si las moneda de via de pago es diferente a la esperada hace el cambio de moneda. y guarda la moneda
                      if($(lv_frm).find("#curcod").val()!= $("#<?= $lv_sec; ?> #curcod").val()){
                         lv_trdat+="data-excrte='"+$(lv_frm).find("#excrte").val()+"' ";
                      	lv_tsrmovamt=lv_tsrmovamt*$(lv_frm).find("#excrte").val();
                      }else{
                        lv_trdat+="data-excrte='1' ";
                      }
                      //inserta fila  
                      var lv_tr="<tr id='"+(lv_id!=undefined?lv_id:($("#<?= $lv_sec; ?> #tsrmovdoctbl ").find('tr').length) + 1)+"'"+lv_trdat+">"+
                                "<td><a href='#' name='paymth'> "+lv_paymthtyp+"</a></td>"+
                                "<td><input type=number class='form-control' name='tsrmovamt' id='tsrmovamt' value='"+lv_tsrmovamt+"'></td>"+
                                "</tr>";
                      if(lv_id!=undefined){$("#<?= $lv_sec; ?> #"+lv_id).replaceWith(lv_tr);}
                      else{$("#<?= $lv_sec; ?> #tsrmovdoctbl ").append(lv_tr);}
											<?= $lv_sec; ?>_calcTotalval();
                      //link para modificar
                        lv_tr= $("#<?= $lv_sec; ?> #"+(lv_id!=undefined?lv_id:$("#<?= $lv_sec; ?> #tsrmovdoctbl ").find('tr').length));
                      $(lv_tr).find("a").on("click", function(e){ e.preventDefault();                                
    									  <?= $lv_sec; ?>_OpenDialog(this);                                                   
											});
                      //atualizar total al cambiar importe
                      $(lv_tr).find('#tsrmovamt').on("change", function(e){ e.preventDefault();
                        <?= $lv_sec; ?>_calcTotalval();
                      });
                      $("#<?= $lv_sec; ?> #cshtxt").attr("readonly",true).next().next().addClass("hidden"); 
											dialog.close();
										}
									}]
					<?php } ?>
				});
      });
    }
    
		
    // TIPO DE CAMBIO. actualizar tipo de cambio al cambiar el campo fecha de la cabecera
    $("#<?= $lv_sec; ?> #tsrmovdocdte").on("change",function(e){
      var lv_excrte="";
			// para cada valor
			$("#<?= $lv_sec; ?>	#tsrmovdoctbl tr").each(function(){
				// si la moneda del valor es distinto de la moneda del a sociedad
        if($(this).data("curcod")!=$("#<?= $lv_sec; ?> #curcod").val()){
          var lv_row=this;
          var lv_rowval=$(this).find("td");
          var lv_pstdat = [{name:"excrteclscodext", value:"vta"},
                         	 {name:"curcodsrc",value:$(this).data("curcod")},
                         	 {name:"excrtedtefrm",value:$("#<?= $lv_sec; ?> #tsrmovdocdte").prop("value")}
                        	];
        	tmssCallProcess("?prg=finexcrte&act=19", lv_pstdat, function(data){
          	lv_excrte= (data.length>=1?(data[0]["finexcrte"]!=null?data[0]["finexcrte"]:""):"");
           	$(lv_row).data("excrte", (lv_excrte!="" ? lv_excrte : $(lv_row).data("excrte")) );
            $(lv_row).find("#tsrmovamt").val(lv_excrte*	$(lv_row).data("tsrmovamt"))
          }); 
        }
      });
			// totaliza nuevamente
    	<?= $lv_sec; ?>_calcTotalval(); 
  	}); 
		
		
	  // CONTABILIZAR
		$("#<?= $lv_sec; ?> #btnacc").on("click",function(e){ e.preventDefault();
			BootstrapDialog.confirm({
				title: "Contabilizar", 
				message:"Desea contabilizar el documento ?",
				type: BootstrapDialog.TYPE_PRIMARY,
				callback: function(result){
          if(parseInt($("#<?= $lv_sec; ?> #tsrmovdoctotlbl").text())<=0) { toastr.warning("el total de vias de pago debe ser mayor a 0.00 "); return true; }
					if(result){	 <?= $lv_sec; ?>_fnc({action: "09"}); }
				}
			});
		});
	</script>
	<script>
    // origen
    <?php 
			switch ($lv_srcobjtyp) { 
        case 'SLS_CUS': ?>
          var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"srcobjcod":"cuscod", "srcobjtxt":"custxt"}};
          tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "slscus", lo_get);
          <?php break;  
      	case 'EDU_STU': ?>
    			var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"srcobjcod" : "stucod", "srcobjtxt" : "stutxt"}}; 
  				tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "edustu", lo_get);
					<?php break;
        case 'BUY_SUP': ?>
          var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"srcobjcod":"supcod", "srcobjtxt":"suptxt"}};
          tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "buysup", lo_get);
          <?php break;
        case 'HLT_PAT': ?>
          var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"srcobjcod":"patcod", "srcobjtxt":"pattxt"}};
          tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "hltpat", lo_get);
					<?php break;
        case 'HLT_DEL': ?>
          var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"srcobjcod":"delcod", "srcobjtxt":"deltxt"}};
          tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "hltdel", lo_get);
				<?php break;
        case 'SPT_PTN': ?>
          var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"srcobjcod":"ptncod", "srcobjtxt":"ptntxt"}};
          tmssTypeahead($("#<?= $lv_sec; ?> #srcobjtxt"), "sptptn", lo_get);
				<?php break;
			}
		?>
    
		// concepto
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"tsrmovtypcod":"tsrmovtypcod", "tsrmovtyptxt":"tsrmovtyptxt"}, "popup":false};
		tmssTypeahead($("#<?= $lv_sec; ?> #tsrmovtyptxt"), "tsrmovtyp", lo_get);
    
		// cuenta
		var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"bnkacccod":"bnkacccod", "bnkacctxt":"bnkacctxt"}};
		tmssTypeahead($("#<?= $lv_sec; ?> #bnkacctxt"), "tsrbnkacc", lo_get);
    
    // caja
    var lo_get = {"fldsec" : "<?= $lv_sec; ?>", "fldasg" : {"cshcod" : "cshcod", "cshtxt" : "cshtxt"}}; 
  	tmssTypeahead($("#<?= $lv_sec; ?> #cshtxt"), "tsrcsh", lo_get);	    
	</script>
  <script>
    function <?= $lv_sec; ?>_fncbckext(data) {
      if ( tmssBackMessageProcessing( data, gv_<?= $lv_sec; ?>_last_action, "<?= $lv_title; ?>", "<b><?= $lv_dockey; ?></b>" ) ) {
				if (gv_<?= $lv_sec; ?>_last_action=="09") {
					toastr.info("Documento contabilizado.");
					<?= $lv_sec; ?>_fnc({action: "99"});
				} else if (gv_<?= $lv_sec; ?>_last_action=="04") {
					tmssTabSecCls( $("#<?= $lv_sec; ?>") );
				} else {
					$("#<?= $lv_sec; ?>").replaceWith( data );
				}
			}
    }
		
    // form submit
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			
			// al grabar
			if ( lp_prm["action"]=="00" ) {
				// preparo comprobantes
				var lv_arr_cmp = new Array();				
				$("#<?= $lv_sec; ?>	#finsumdoctbl tbody tr").each(function(){
					var lv_chk = $(this).find("input[type=checkbox]");
					if ($(lv_chk).is(":checked") ) {
						lv_arr_cmp.push({	"tsrmovdoccmpcod":$(lv_chk).data("tsrmovdoccmpcod"),
													"srcobjtyp":$(lv_chk).data("srcobjtyp"),
													"srcobjcod":$(lv_chk).data("srcobjcod"),
													"tsrmovdoccmpamt":$(this).find("input[name=finsumamt]").val()
												});
					}
				});
        $("#<?= $lv_sec; ?> #tsrmovdoccmp").val( (lv_arr_cmp.length==0?"[]":JSON.stringify( lv_arr_cmp )) );
        
        // obtengo datos de la tabla metodos de pago
				var lv_arr_val = new Array();
				$("#<?= $lv_sec; ?>	#tsrmovdoctbl").find("tr").each(function(){
          lv_trdat=$(this).data();
          //si el metodo de pago no esta oculto lo guarda
					if (!$(this).hasClass("hidden") ) {
						lv_arr_val.push({	"tsrmovdocvalcod":(lv_trdat.tsrmovdocvalcod!=undefined?lv_trdat.tsrmovdocvalcod:""),
													"paymthcod":lv_trdat.paymthcod,
              						"tsrmovdocvalcodext":lv_trdat.tsrmovdocvalcodext,
                          "tsrmovdocvaltxt":lv_trdat.tsrmovdocvaltxt,
                          "tsrmovdocvaldte":lv_trdat.tsrmovdocvaldte,
              						"curcod":lv_trdat.curcod,
                          "excrte":lv_trdat.excrte,  
                          "bnkcod":lv_trdat.bnkcod,
                          "bnkchkcod":lv_trdat.bnkchkcod,
                          "bnkacccod":lv_trdat.bnkacccod,
                          "bnktjtcod":lv_trdat.bnktjtcod,
                          "cshvalcod":lv_trdat.cshvalcod,
													"tsrmovdocvalamt":$(this).find("#tsrmovamt").val()
												});          
					}
				});
        $("#<?= $lv_sec; ?> #tsrmovdocval").val( (lv_arr_val.length==0?"[]":JSON.stringify( lv_arr_val )) );
			}
		}
  </script>  
	<?php include('grldocfrmscr.frm'); ?>
</section>
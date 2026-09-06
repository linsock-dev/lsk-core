<?php 
	// url del formulario
  $lv_lnk = '?prg=logtratrk&prm_tracod='.$vew_data->tracod.'&prm_mdlcod='.$vew_data->mdlcod.'&prm_prgcod='.$vew_data->prgcod;

	// campos requeridos
	$vew_input->RequiredFields( array('tradte','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->tracod;

	// titulo
	$lv_title = $vew_lang->transport;
	
	// modulo y programa
	$lv_mdlcod = 'LOG';
	$lv_prgcod = 'TRA';
	$lv_objtyp = $vew_data->mdlcod.'_'.$vew_data->prgcod;
	$vew_tbl['new'] = array('per'=>false);
	$vew_tbl['modR'] = array('per'=>false);
	$vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['del'] = array('per'=>false);
	$vew_tbl['delsep'] = array('per'=>false);
	$vew_tbl['cpy'] = array('per'=>false);

 	// librería de estilos bootstrap
	include_once('_library.frm'); 
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <!-- Navbar -->
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('sysdocclscod','hidden',$vew_data->sysdocclscod); ?>

		<textarea id="tradlv" name="tradlv" class="hidden"></textarea>
  
    <div class="container-fluid" role="tabpanel">
			<ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->transport; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->tracod; ?><?= gethtml('tracod','hidden',$vew_data->tracod); ?></strong></h4></li>
			</ul>
        <div class="tab-content tmss-tab-content">       
          <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
						<div class="row">
              <div class="col-md-8">
                <div class="card">
                  <div class="card-header">
                    <div class="card-title"><?= $vew_lang->DELIVERIESTAKE; ?>             </div>
                  </div>
                  <div class="card-body tmss-card-body-edit">
                    <table class="table table-striped table-condensed" id="logtradlvtbl">
                      <thead><tr><th>ID</th><th>Destino</th><th>Confirmado</th><th>Adjunto</th><th>Ubicacion</th></tr></thead>
                        <?php
                          if( $vew_data->dlv != '' && count($vew_data->dlv) > 0 ){
                            foreach($vew_data->dlv as $lv_row) {

                              $lv_dstobjtxt = ($lv_row['stkmovobjtyp']=='STK_SOU'?$lv_row['dstobjtxt']:$lv_row['srcobjtxt']);
                              $lv_dstcnttxt = ($lv_row['stkmovobjtyp']=='STK_SOU'?$lv_row['dstcnttxt']:$lv_row['srccnttxt']);

                              $lv_dstvalue = ($lv_dstcnttxt == '' ? $lv_dstobjtxt : $lv_dstcnttxt);
                              $lv_dstbool = 	($lv_dstcnttxt == '' ? false : true);
                              $lv_dstcod =  ($lv_dstcnttxt == '' ? $lv_row['dstobjcod'] : $lv_row['dstcntcod']);

                              $lv_dsttxt = '<strong><a href="#" onclick="'.$lv_sec.'_openCnt($(this), \''.$lv_dstbool.'\', \''.$lv_dstcod.'\');">'.$lv_dstvalue.'</a></strong>'
                                         . ($lv_dstobjtxt == '' ? '' : '<br><small>'.$lv_dstobjtxt.'</small>');

                              $lv_adrmapgeo = ($lv_row['stkmovobjtyp']=='STK_SOU'?($lv_row['dstcnttxt']!=''?$lv_row['dstcntmapgeo']:$lv_row['dstobjmapgeo'])
                                              :($lv_row['stkmovobjtyp']=='STK_SIN'?($lv_row['srccnttxt']!=''?$lv_row['srccntmapgeo']:$lv_row['srcobjmapgeo'])
                                              :''));

                              $lv_val = $vew_doc->getTagValue($lv_row['dlvdocclsatr'], 'stkmovrelcnf');
                              $lv_dlvdocclsatr = is_array($lv_val) ? trim($lv_val[0] ?? '') : trim($lv_val);

                              $lv_adj_count = $lv_row['adjcount'] ?? 0;

                              echo '<tr name="dlvrow" data-stkmovdoccod="'.$lv_row['stkmovdoccod'].'" data-dlvdocsts="'.$lv_row['dlvdocsts'].'" data-stkmovobjtyp="'.$lv_row['stkmovobjtyp'].'">'.
                                '<td width ="150">'.$lv_row['stkmovdoccodext'].'<br><a href="#" onclick="'.$lv_sec.'_openDoc($(this));">'.$lv_row['stkmovdoccod'].'</a></td>'.
                                '<td>'.$lv_dsttxt.'</td>'.

                                // Nueva implementación del botón check
                                '<td width="60" class="text-center">'.($lv_dlvdocclsatr==''?''
                                        : ($vew_readonly && $vew_data->trastrdte!='' && $vew_data->traenddte==''?
                                          ($lv_row['dlvcnfsts']==''?'  <a href="#" id="btnexe" data-stkmovdoccod="'.$lv_row['stkmovdoccod'].'" name="tradlvcnf" data-dlvcnfsts="" class="far fa-circle fa-2x text-primary"></a>':
                                          ($lv_row['dlvcnfsts']=='NO'?'<a href="#" id="btnexe" data-stkmovdoccod="'.$lv_row['stkmovdoccod'].'" name="tradlvcnf" data-dlvcnfsts="'.$lv_row['dlvcnfsts'].'" class="fas fa-circle-xmark fa-2x text-danger"></a>':
                                          ($lv_row['dlvcnfsts']=='SI'?'<a href="#" id="btnexe" data-stkmovdoccod="'.$lv_row['stkmovdoccod'].'" name="tradlvcnf" data-dlvcnfsts="'.$lv_row['dlvcnfsts'].'" class="fas fa-circle-check fa-2x text-success"></a>':'')))
                                        :	($lv_row['dlvcnfsts']==''?'':
                                          ($lv_row['dlvcnfsts']=='NO'?'<a href="#" id="btnshowcmt" data-sysdocclscod="'.$lv_row['sysdocclscod'].'" data-stkmovdoccod="'.$lv_row['stkmovdoccod'].'" name="tradlvcnf" data-dlvcnfsts="'.$lv_row['dlvcnfsts'].'" class="fas fa-circle-xmark fa-2x text-danger"></a>':
                                          ($lv_row['dlvcnfsts']=='SI'?'<a href="#" id="btnshowcmt" data-sysdocclscod="'.$lv_row['sysdocclscod'].'" data-stkmovdoccod="'.$lv_row['stkmovdoccod'].'" name="tradlvcnf" data-dlvcnfsts="'.$lv_row['dlvcnfsts'].'" class="fas fa-circle-check fa-2x text-success"></a>':'')))
                                        ).'&nbsp;<br>'.(is_a($lv_row['dlvcnfdte'], 'DateTime') ? $lv_row['dlvcnfdte']->format('d/m H:i') : ''))
                                .'</td>'.
                                '<td width="60" class="text-center">'.
                                  '<a href="#" class="btnadj" data-stkmovdoccod="'.$lv_row['stkmovdoccod'].'"><i class="far fa-paperclip fa-2x"></i></a>'.
                                    ($lv_adj_count > 0 
                                            ? '<span class="badge" style="left: -10px; position:relative;">'.$lv_adj_count.'</span>' 
                                            : '').

                                '</td>'.
                                '<td width="60" class="text-center">'.
                                       (($lv_adrmapgeo!='')?'<a href="#" onclick="window.open('.chr(39).'http://www.google.com/maps/search/?api=1&query='.$lv_adrmapgeo.chr(39).', '.chr(39).'_blank'.chr(39).' );"><span class="far fa-map-marked fa-2x"></span></a>':'').'</td>'.
                                '</tr>';
                            }
                          }
                        ?>
                    </table>
                  </div>
								</div>
            	</div>
							<div class="col-md-4">
                <div class="card">
                  <div class="card-header">
                    <div class="card-title">
                       <?= $lv_title; ?>
                    </div>
                  </div>
                  <div class="card-body tmss-card-body-edit">                   
                    <?php
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->code, 	'input'=>gethtml('tracodext', 'doccmt1x20',		$vew_data->tracodext, $lv_default) )); 
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->date, 	'input'=>gethtml('tradte', 		'docdte',		$vew_data->tradte, $lv_default) )); 
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->route,
                                              				'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                 					array('input'=>gethtml('traroutxt', 'doccmt1x50', $vew_data->traroutxt,$lv_default) ))
                                            					));
                      echo gethtml( 'traroucod', 'hidden', $vew_data->traroucod);
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->vehicle,
                                              				'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                  				array('input'=>gethtml('vhccodext', 'doccmt1x20', $vew_data->vhccodext,$lv_default) ))
                                            ));
                      echo gethtml( 'vhccod', 'hidden', $vew_data->vhccod); 
                      echo vew_boot($lv_col210, array('label'=>$vew_lang->driver,
                                              				'input'=>vew_boot(	array('style'=>'search', 'readonly'=>$vew_readonly),
                                                                  				array('input'=>gethtml('drvtxt', 'doccmt1x50', $vew_data->drvtxt,$lv_default) ))
                                            ));
                      echo gethtml( 'drvcod', 'hidden', $vew_data->drvcod);
                      if( $vew_readonly ) {
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', 'doccmt1x20', $vew_data->trasts, $lv_always_disabled) ));
                      } else {
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', 'docsts', 		$vew_data->docsts, 		$lv_default) ));
                      }
                      echo '<hr>';
                      if( !$vew_readonly ) {
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->start, 'input'=>gethtml('trastrdte', 'doccmt1x50', $vew_data->trastrdte, $lv_always_disabled)) ); 
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->end, 'input'=>gethtml('traenddte', 'doccmt1x50', $vew_data->traenddte, $lv_always_disabled)) ); 
                      
                      } else {
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->start, 
                                                        'input'=>vew_boot(array('style'=>'custom'),
                                                                          array('custom'=>'<span class="input-group-btn"><a href="#" class="btn btn-default disabled" id="btntrastrdtechg">&nbsp;<span class="fas fa-flag"></span></a></span>',
                                                                                'input'=>gethtml('trastrdte', 'doccmt1x50', ($vew_data->trastrdte!=''?$vew_data->trastrdte->format("d/m/Y H:i:s"):''), $lv_always_disabled)) ) )); 
                        echo vew_boot($lv_col210, array('label'=>$vew_lang->end, 
                                                        'input'=>vew_boot(array('style'=>'custom'),
                                                                          array('custom'=>'<span class="input-group-btn"><a href="#" class="btn btn-default" id="btntraenddtechg">&nbsp;<span class="fas fa-flag-checkered"></span></a></span>',
                                                                                'input'=>gethtml('traenddte', 'doccmt1x50', ($vew_data->traenddte!=''?$vew_data->traenddte->format("d/m/Y H:i:s"):''), $lv_always_disabled)) ) )); 
                      }
                    ?>
                  </div>
                </div>                
							</div>
           </div> <!-- tabcontent -->
         </div> <!-- col-md-12 -->
    	</div> <!-- rows -->
    </div>
  </form>
<div id="rowfrm_cmt" class="hidden">
    <form class="form-horizontal tmss-form-horizontal pt-0 pb-0">
        <?php
      		echo vew_boot($lv_col210, array('label'=>$vew_lang->confirmation, 		'input'=>gethtml('rowcnftyp', array(''=>'','SI'=>'ENTREGADO','NO'=>'NO ENTREGADO'), '', $lv_always_disabled) ));
       	 	echo vew_boot($lv_col210, array('label'=>$vew_lang->date,             'input'=>gethtml('rowcnfdte', 'docdte', '', $lv_always_disabled) ));
          echo vew_boot($lv_col210, array('label'=>$vew_lang->comments, 'input'=>gethtml('rowcnfcmt', 'doccmt1x50', '', $lv_always_disabled) ));
        ?>
    </form>
</div>    

<div id="rowfrm" class="hidden">
    <form class="form-horizontal tmss-form-horizontal pt-0 pb-0">
      <?php
        echo vew_boot($lv_col210, array('label'=>$vew_lang->confirmation, 'input'=>gethtml('rowcnftyp', array(''=>'','SI'=>'ENTREGADO','NO'=>'NO ENTREGADO'), '', $lv_always_enabled) ));
        echo vew_boot($lv_col210, array('label'=>$vew_lang->date,             'input'=>gethtml('rowcnfdte', 'docdte', '', $lv_always_enabled) ));
        echo vew_boot($lv_col210, array('label'=>$vew_lang->comments,         'input'=>gethtml('rowcnfcmt', 'doccmt1x50', '', $lv_always_enabled) ));
      ?>
    </form>
</div>
<script>   
		$("#<?= $lv_sec; ?> #btnshowcmt").on("click", function(e){
        e.preventDefault();

        // Datos desde el botón
        var sysdocclscod = $(this).data("sysdocclscod");
        var stkmovdoccod = $(this).data("stkmovdoccod");

        // Armar datos
        var lv_pstdat = [
            {name: "fnddoccls", value: sysdocclscod},
            {name: "fnddoccod", value: stkmovdoccod},
          	{name: "fnddoccnf", value: $("#<?= $lv_sec; ?> #fnddoccnf").prop("value")},
            {name: "fndcodext", value: $("#<?= $lv_sec; ?> #fndcodext").prop("value")},
            {name: "fndatr", 		value: $("#<?= $lv_sec; ?> #msgfndatr").prop("value")},
        ];

        // Llamada
        tmssCallProcess("?prg=stkmovdoc&act=49", lv_pstdat, function(data){
            if (Array.isArray(data) && data.length > 0) {
                var lv_cnftyp = "";
                var lv_cnfdte = "";
                var lv_cnfcmt = "";

                if (data[0]["stkmovdoccnf"] != null) {
                    var $xml = $("<div>" + data[0]["stkmovdoccnf"] + "</div>");
                    lv_cnftyp = $xml.find("cnftyp").text();
                    lv_cnfdte = $xml.find("cnfdte").text();
                    lv_cnfcmt = $xml.find("cnfcmt").text();
                }

                // Clonar el formulario oculto
                var $formClone = $("#<?= $lv_sec; ?> #rowfrm_cmt > form").clone();

                // Rellenar campos en el clone
                $formClone.find("[name='rowcnftyp']").val(lv_cnftyp);
                $formClone.find("[name='rowcnfdte']").val(lv_cnfdte);
                $formClone.find("[name='rowcnfcmt']").val(lv_cnfcmt);

                // Mostrar popup con el formulario relleno
                BootstrapDialog.show({
                    title: "<?= $vew_lang->comments; ?>",
                    message: $formClone,
                    type: BootstrapDialog.TYPE_PRIMARY,
                    buttons: [
                        {
                            label: "Cerrar",
                            cssClass: "btn-default",
                            action: function(dialogItself){ dialogItself.close(); }
                        }
                    ]
                });
            } else {
                toastr.warning("No se encontró el comentario.");
            }
        });
    });  
  
    $("#<?= $lv_sec; ?>").on("click", ".btnadj", function(e) {
        e.preventDefault();
        var lv_stkmovdoccod = $(this).data("stkmovdoccod");
				var lv_srcadj =	$(this).next("span.badge");

        var lv_pstdat = [
            {name: "flesrctyp", value: "stk_sou"},
            {name: "flesrccod", value: lv_stkmovdoccod}
        ];
        tmssCallProcess("?prg=grldatupl&act=showUploadGrid", lv_pstdat, function(data){
            BootstrapDialog.show({
                title: "Adjuntos",
                size: BootstrapDialog.SIZE_WIDE,
                message: $(data),
                onhide: function(dialogItself) {
                        // contar filas al cerrar
                        var lv_sec = dialogItself.getModalBody().find("section").attr("id");
                        var lv_adjcant = dialogItself.getModalBody().find("#"+lv_sec+" #tblfle tbody tr").length;
                        var lv_srcadjcant = lv_srcadj.length ? parseInt(lv_srcadj.text(), 10) : 0;

                        if (lv_adjcant !== lv_srcadjcant) {
                            <?= $lv_sec; ?>_fnc({action: '03'});
                        }
                      }
            });
        });
    });
  
    $("#<?= $lv_sec; ?> #btnexe").on("click",function(e){
        var lv_stkmovdoccod_from_btn = $(this).data("stkmovdoccod");
        
        BootstrapDialog.show({
            title: "<?= $vew_lang->confirmation; ?>", 
            message: $("#<?= $lv_sec; ?> #rowfrm > form").clone(), 
            type: BootstrapDialog.TYPE_INFO,
            buttons: [{ label: "Cancelar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
                      {    label: "OK", cssClass: "btn-primary",    action: function(dialogItself){
                        
												var lv_doccod = $(e).parent().parent().data("stkmovdoccod");
                        var val_cnftyp = dialogItself.getModalBody().find("#rowcnftyp").val();
                        var val_cnfdte = dialogItself.getModalBody().find("#rowcnfdte").val();
                        var val_cnfcmt = dialogItself.getModalBody().find("#rowcnfcmt").val();

                        if ( val_cnfdte == "" ) { 
                            toastr.warning("Debe indicar la fecha.");
                            return;
                        }
                        
                        var lv_pstdat =[{name: "stkmovdoccod", value: lv_stkmovdoccod_from_btn},
                                        {name: "stkmovdoccnftyp", value: val_cnftyp},
                                        {name: "stkmovdoccnfdte", value: val_cnfdte},
                                        {name: "stkmovdoccnfcmt", value: val_cnfcmt}
                                        ];
                           
                        tmssCallProcess( "?prg=stkmovdoc&act=47", lv_pstdat, function(data){
                            var lv_chk = $("#<?= $lv_sec; ?> #rowchk[data-stkmovdoccod="+lv_stkmovdoccod_from_btn+"]"); 
                            if ( data.errtyp=="S" ) {
                                $(lv_chk).parent().parent().removeClass("bg-info").addClass("bg-success");
                                toastr.success("Confirmaci&oacute;n actualizada.");
                                <?= $lv_sec; ?>_fnc({action: '03'});
                            } else {
                                <?= $lv_sec; ?>_fnc({action: '03'});
                                $(lv_chk).parent().parent().removeClass("bg-info").addClass("bg-danger");
                                $(lv_chk).parent().parent().find("td[name=errlog]").text(data.errtxt);   
                            }
                        }); 
                        dialogItself.close();
                    }
                }]
            });
    });
    
		function <?= $lv_sec; ?>_removeRow(e) {
			$(e).parent().parent().remove();
		}
		function <?= $lv_sec; ?>_openDoc(e) {
			var lv_doccod = $(e).parent().parent().data("stkmovdoccod");
			var lv_objtyp = $(e).parent().parent().data("stkmovobjtyp").split("_");			
			tmssLink("?prg=stkmovdoc&act=03&prm_mdlcod="+lv_objtyp[0]+"&prm_prgcod="+lv_objtyp[1]+"&prm_stkmovdoccod="+lv_doccod, [{target: "_new_section"}] );
		}
    
    function <?= $lv_sec; ?>_openCnt(e, dstbool, dstvalue) {
      //verifico tipo de cliente 
      if (dstbool) {
          // Es un cliente_contacto
          tmssLink("?prg=grldatcnt&act=03&prm_cntsrctyp=sls_cus&prm_cntcod=" + dstvalue, [{ target: "_new_section" }]);
      } else {
          // Es un cliente sin contacto
          tmssLink("?prg=slscus&act=03&prm_mdlcod=sls&prm_prgcod=cus&prm_cuscod=" + dstvalue, [{ target: "_new_section" }]);
      }
  	}
		
		// INICIAR TRANSPORTE
		$("#<?= $lv_sec; ?> #btntrastrdtechg").on("click",function(e){				
			e.preventDefault();
			if( $("#<?= $lv_sec; ?> #logtradlvtbl tr[name='dlvrow'][data-dlvdocsts='C'][data-stkmovobjtyp='STK_SOU']").length != $("#<?= $lv_sec; ?> #logtradlvtbl tr[name='dlvrow'][data-stkmovobjtyp='STK_SOU']").length ) {
				toastr.warning("No se han contabilizado todas las entregas de Salida. No se puede Iniciar Transporte.");
				return false;
			}
			if( $("#<?= $lv_sec; ?> #traenddte").prop("value")!="" ) { toastr.warning("Transporte Finalizado. No se puede modificar el inicio."); return false; }
			var lv_strdte = ($("#<?= $lv_sec; ?> #trastrdte").prop("value")==""?moment().format("DD/MM/YYYY HH:mm:ss"):"");
			tmssCallProcess("?prg=logtra&act=25",[{name:"tracod",value:"<?= $vew_data->tracod; ?>"},{name:"trastrdte",value:lv_strdte},{name:"traenddte",value:$("#<?= $lv_sec; ?> #traenddte").prop("value")}],function(data){ 
				toastr.success("Transporte Iniciado."); 
				<?= $lv_sec; ?>_fnc({action: '03'});
			});
		});

		// FINALIZAR TRANSPORTE
		$("#<?= $lv_sec; ?> #btntraenddtechg").on("click",function(e){
			e.preventDefault();
			if( $("#<?= $lv_sec; ?> #trastrdte").prop("value")=="" ) { toastr.warning("Transporte No Iniciado. No se puede modificar el fin."); return false; }
			var lv_enddte = ($("#<?= $lv_sec; ?> #traenddte").prop("value")==""?moment().format("DD/MM/YYYY HH:mm:ss"):"");
			tmssCallProcess("?prg=logtra&act=25",[{name:"tracod",value:"<?= $vew_data->tracod; ?>"},{name:"trastrdte",value:$("#<?= $lv_sec; ?> #trastrdte").prop("value")},{name:"traenddte",value:lv_enddte}],function(data){ 
				toastr.success("Transporte Finalizado."); 
				<?= $lv_sec; ?>_fnc({action: '03'});
			});
		});
  </script>
	<script>
    // RUTA
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"traroucod":"traroucod", "traroutxt":"traroutxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #traroutxt"), "logtrarou", lo_get);
    
    // VEHICULO
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"vhccod":"vhccod", "vhccodext":"vhccodext"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #vhccodext"), "logvhc", lo_get);
    
    // CHOFER
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldasg":{"drvcod":"drvcod", "drvtxt":"drvtxt"}};
  	tmssTypeahead($("#<?= $lv_sec; ?> #drvtxt"), "logdrv", lo_get);
  </script>
  <script>
		// AGREGAR ENTREGAS
		$("#<?= $lv_sec; ?> #btndlvadd").on("click",function(e){
			e.preventDefault();
			
			// obtengo los IDs de los documentos referenciados previamente para no duplicar en la busqueda
			var lo_dat = $("#<?= $lv_sec; ?> #logtradlvtbl tr[name='dlvrow']");
			var lv_refarr = new Array();
			for (var i=0; i<lo_dat.length; i++) {
				lv_refarr.push($(lo_dat[i]).data("stkmovdoccod"));
			}
			
			// cargo la pantalla de referencia
			var lv_datpst = {sysdocclscod: "<?= $vew_data->sysdoccls->sysdocclscod; ?>",
											traroucod: $("#<?= $lv_sec; ?> #traroucod").prop("value"),
											refarr: JSON.stringify(lv_refarr) };
			tmssCallProcess("?prg=logtra&act=21", lv_datpst, function(data){
					BootstrapDialog.show({
						size: BootstrapDialog.SIZE_WIDE,
						title: "Agregar Entregas",																		
						message: $(data),
						buttons: [{ label: "Cancelar", cssClass: "btn-default", action: function(dialogItself){ dialogItself.close(); } },
											{	label: "Agregar", cssClass: "btn-success",	action: function(dialogItself){
												if ( dialogItself.getModalBody().find("input[name='dlvchk']:checked").length==0 ) {
													toastr.warning("Debe indicar al menos una entrega.");
												} else {
													dialogItself.getModalBody().find("input[name='dlvchk']:checked").each(function(e){
														var lv_dlvdocsts = $(this).data("docsts");
														var lv_stkmovdoccod = $(this).data("stkmovdoccod");
														var lv_dsttxt = $(this).data("dsttxt");
														var lv_dlvcnfsts = "";
                            var lv_ctedte = $(this).data("ctedte");
                            var lv_stkmovdoccodext = $(this).data("stkmovdoccodext");
														var lv_row = "<tr name='dlvrow' data-stkmovdoccod='"+lv_stkmovdoccod+"' data-dlvdocsts='"+lv_dlvdocsts+"'>"
                            		+"<td><i class=fas fa-bars style=cursor:pointer;></i></td>"
																+"<td>"+lv_stkmovdoccodext+"<br><a href='#' onclick='<?= $lv_sec; ?>_openDoc($(this));'>"+lv_stkmovdoccod+"</a></td>"
																+"<td>"+lv_dsttxt+"</td>"
                            		+"<td>"+lv_ctedte+"</td>"
																+"<td>"+(lv_dlvdocsts=="C"?
																		"<span class='fs-24' title='Preparado'><span class='fas fa-clipboard-check'></span></span>"
																	:	"<span class='fs-24' title='En preparacion'><span class='fas fa-clipboard-list'></span></span>"
																	)+"</td>"
																+"<td><a href='#' id='btnexe' class='btn btn-default' title=Entrega><span class='far fa-square'></span></a></td>"
																+"<td><a href='#' class='btn btn-danger' onclick='<?= $lv_sec; ?>_removeRow($(this));'><span class='fa fa-trash'></span></a></td>"
																+"</tr>";
														$("#<?= $lv_sec; ?> #logtradlvtbl").append( lv_row );
													});
													dialogItself.close();
												}
											}
										}]
					});
			});
		});
	</script>
  <script>		
		// form submit ext
    function <?= $lv_sec; ?>_fncext( lp_prm ) {
			if( lp_prm["action"]=="02" ) {
				if( $("#<?= $lv_sec; ?> #traenddte").prop("value")!="" ) {
					toastr.warning("Transporte finalizado. No se puede modificar.");
					return false;
				} else if( $("#<?= $lv_sec; ?> #trastrdte").prop("value")!="" ) {
					toastr.warning("Transporte iniciado. No se puede modificar.");
					return false;
				}
			} else if ( lp_prm["action"]=="00" ) {
				var lo_dat = $("#<?= $lv_sec; ?> #logtradlvtbl tr[name='dlvrow']");
				var lv_refarr = new Array();
				for (var i=0; i<lo_dat.length; i++) {
					lv_refarr.push($(lo_dat[i]).data("stkmovdoccod"));
				}
				$("#<?= $lv_sec; ?> #tradlv").text( JSON.stringify(lv_refarr) );
			}
		}

  </script>
  <?php include('grldocfrmscr.frm'); ?>
</section>
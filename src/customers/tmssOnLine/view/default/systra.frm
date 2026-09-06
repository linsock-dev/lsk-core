<?php
	// url del formulario
  $lv_lnk = '?prg=systra';

	// campos requeridos
	$vew_input->RequiredFields( array('systratxt','sysdevgrptxt','sysdevgrpcod','srcbuscod','srcobjtyp','srcobjcod001','docsts') );

	// clave del documento
	$lv_dockey = $vew_data->systracod;

	// titulo
	$lv_title = $vew_lang->transportorder;

	// modulo y programa
	$lv_mdlcod = 'SYS';
	$lv_prgcod = 'TRA';

	// libreria de estilos bootstrap
	include_once('_library.frm'); 

	$lv_allow_edit = $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'02');
	$lv_allow_delete = $vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'04');

	// determino si tiene permisos para ver un objeto
	$lv_hasObjectPermission = $vew_sec->haspermission('SYS', 'OBJ', '03');

	// determino si se require permiso para liberacion estandard
	$lv_release_action = '05';
	foreach($vew_data->traobj as $lv_row){ if($lv_row['sysobjsys']==1){ $lv_release_action = '10'; break; } }
	$lv_hasReleasePermission = $vew_sec->haspermission($lv_mdlcod, $lv_prgcod, $lv_release_action);
	
	// botones de liberacion
	$vew_tbl['del'] = array('per'=>( count($vew_data->traobj)>0 ? false : $lv_allow_delete )); // solo se permite borrado de OT si no tiene objetos
	$vew_tbl['delsep'] = array('per'=>( count($vew_data->traobj)>0 ? false : $lv_allow_delete )); // solo se permite borrado de OT si no tiene objetos
	$vew_tbl['cpy'] = array('per'=>false); // no se permiten copias de OT
	$vew_tbl['modL'] = array('per'=>( $vew_data->docsts=='R'?false:$lv_allow_edit ));
	$vew_tbl['modL'] = array('per'=>( $vew_data->docsts=='R'?false:$lv_allow_edit ));
	$vew_tbl['relL'] = array ('id'=>'btnrelL', 'pos'=>'L', 'ttl'=>$vew_lang->release, 'per'=>($vew_data->docsts!='R') && $lv_hasReleasePermission && $vew_readonly, 'icn'=>'far fa-flag', 'css'=>'btn btn-success navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-desk-btn', 'acc'=>'');
	$vew_tbl['relR'] = array ('id'=>'btnrelR', 'pos'=>'R', 'ttl'=>$vew_lang->release, 'per'=>($vew_data->docsts!='R') && $lv_hasReleasePermission && $vew_readonly, 'icn'=>'far fa-flag', 'css'=>'btn btn-success navbar-btn tmssAlwaysEnabled tmssHiddeOnEdit tmss-mob-btn', 'acc'=>'');

	// decide si restringir o no el grupo de usuarios
	$lv_limitdevgrp = false;
	if(!$vew_readonly){ 
    if ( count(array_filter($vew_data->devgrp, function($lp_val){ return $lp_val['sysdevgrpcodext'] == 'TMS';})) == 0){
      $vew_data->devgrp = array_column($vew_data->devgrp, 'sysdevgrptxt', 'sysdevgrpcod');
      $lv_limitdevgrp = true;
    }
  }
?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>" >
	<?php include('grldocfrmtlb.frm'); ?>
  
	<form method="POST" class="form-horizontal tmss-form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('tmp_qty','hidden',''); ?>
    <?= gethtml('tmp_max','hidden',''); ?>

		<div class="container-fluid" role="tabpanel">
      <ul class="nav nav-pills nav-secondary nav-pills-no-bd" role="tablist">
				<li role="presentation" class="active"><a href="#<?= $lv_sec; ?>_tab001" role="tab" data-toggle="tab"><?= $vew_lang->general; ?></a></li>
				<li class="pull-right"><h4># <strong><?= $vew_data->systracod; ?><?= gethtml('systracod','hidden',$vew_data->systracod); ?></strong></h4></li>
			</ul>

			<div class="tab-content tmss-tab-content">
        <div role="tabpanel" class="tab-pane active" id="<?= $lv_sec; ?>_tab001">
          <div class="row">
            <div class="col-sm-6">
              
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->transportorder; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                    echo vew_boot($lv_colsm210, array('label'=>$vew_lang->title, 'input'=>gethtml('systratxt', 'doccmt1x50', $vew_data->systratxt, $lv_default) ));
              			echo vew_boot($lv_colsm210, array('label'=>$vew_lang->status,	'input'=>gethtml('docsts', 'docsts', $vew_data->docsts, $lv_default ) )); 
                  ?>
                </div>
              </div><!-- /card -->
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->source; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <?php
                  	if($lv_limitdevgrp){
                      echo vew_boot($lv_colsm210, array('label'=>$vew_lang->developergroup, 'input'=>gethtml('sysdevgrpcod', $vew_data->devgrp, $vew_data->sysdevgrpcod??'', $lv_default)));
                    }else{
                      echo vew_boot($lv_colsm210, array('label'=>$vew_lang->developergroup, 'input'=>vew_boot(array('style'=>'search','readonly'=>$vew_readonly), array('input'=>gethtml('sysdevgrptxt', 'doccmt1x50', $vew_data->sysdevgrptxt, $lv_default) )) ));
                      echo gethtml('sysdevgrpcod', 'hidden', $vew_data->sysdevgrpcod);
                  	}
                  	echo vew_boot($lv_colsm210, array('label'=>$vew_lang->company, 'input'=>gethtml('srcbuscod', 'doccmt1x50',$vew_data->srcbuscod, $lv_default) ));
                    echo vew_boot($lv_colsm210, array('label'=>$vew_lang->object, 'input'=>gethtml('srcobjtyp', 'doccmt1x50',$vew_data->srcobjtyp, $lv_default) ));
                    echo vew_boot($lv_colsm210, array('label'=>$vew_lang->code.'1', 'input'=>gethtml('srcobjcod001', 'doccmt1x50',$vew_data->srcobjcod001, $lv_default) ));
                    echo vew_boot($lv_colsm210, array('label'=>$vew_lang->code.'2', 'input'=>gethtml('srcobjcod002', 'doccmt1x50',$vew_data->srcobjcod002, $lv_default) ));
                  ?>
                </div>
              </div><!-- /card -->
            </div><!-- /col -->
            <div class="col-sm-6">
              <div class="card">
                <div class="card-header"><div class="card-title"><?= $vew_lang->objects; ?></div></div>
                <div class="card-body tmss-card-body-edit">
                  <table class="table table-condensed" id="tblobj">
                    <thead><tr><th><?= $vew_lang->Group; ?></th><th><?= $vew_lang->object; ?></th><th><?= $vew_lang->User; ?></th><th><?= $vew_lang->Actions; ?></th></tr></thead>
                    <tbody>
                      <?php
                        foreach($vew_data->traobj as $lv_row){
													
													$lv_grp = 'Database';
													switch( strtolower($lv_row['sysobjclspth']==null?'':$lv_row['sysobjclspth']) ){
														case 'tmssonline\controller': $lv_grp='Controller'; break;
														case 'tmssonline\model': $lv_grp='Model'; break;
														case 'tmssonline\view\default': $lv_grp='View'; break;
														case 'system\engine': $lv_grp='Engine'; break;
														case 'wwwroot\library\js\temasis': $lv_grp='Js'; break;
														case 'wwwroot\library\css\temasis': $lv_grp='Css'; break;
														case 'wwwroot': $lv_grp='wwroot'; break;
													}
													
                          echo '<tr data-sysobjcod="'.$lv_row['sysobjcod'].'" data-systraobjcod="'.$lv_row['systraobjcod'].'" data-grp="'.strtolower($lv_grp).'" data-sysobjsys="'.$lv_row['sysobjsys'].'" data-status="'.strtolower($lv_row['docsts']).'" data-sysobjtxt="'.strtoupper($lv_row['sysobjtxt']).'">'
                              .'<td>'.($lv_grp!=''?$lv_grp:$lv_row['sysobjclstxt']).'</td>'
                              .'<td>'.($lv_hasObjectPermission ? '<a href="#" name="sysobjlnk" data-sysobjcod="'.$lv_row['sysobjcod'].'">'.strtoupper($lv_row['sysobjtxt']).'</a>' : strtoupper($lv_row['sysobjtxt']) ).'</td>'
                              .'<td>'.$lv_row['usrcod'].'</td>'
						                  .'<td style="display:flex;">'
																.($lv_row['docsts']=='R'?'<span class="card-icon"><i class="far fa-check text-success"></i></span>':
																	//.'<a id="releaseObject" href="#" class="card-icon text-success '.($vew_actcod == '02' || $vew_actcod == '01'?'hidden':'').'" title="'.$vew_lang->release.'"><i class="fas fa-flag"></i></a>'
																	($vew_data->docsts=='A' ? '<a name="objcmp" href="#" class="card-icon" title="'.$vew_lang->compare.'" data-systraobjcod="'.$lv_row['systraobjcod'].'" data-sysobjcod="'.$lv_row['sysobjcod'].'"><i class="far fa-code-compare"></i></a>':'')
																	.($vew_data->docsts=='A' && $lv_allow_edit ? '<a name="objmov" href="#" class="card-icon" title="'.$vew_lang->move.'" data-systraobjcod="'.$lv_row['systraobjcod'].'" data-sysobjcod="'.$lv_row['sysobjcod'].'"><i class="far fa-share"></i></a>':'')
																	.($lv_row['docsts']!='R' && $lv_hasReleasePermission ? '<a name="objrel" href="#" class="card-icon" title="'.$vew_lang->release.'" data-systraobjcod="'.$lv_row['systraobjcod'].'" data-sysobjcod="'.$lv_row['sysobjcod'].'"><i class="far fa-flag"></i></a>':'')
																	//.($vew_data->docsts=='A' && $lv_allow_edit ? '<a name="objdel" href="#" class="card-icon" title="'.$vew_lang->remove.'" data-sysobjcod="'.$lv_row['sysobjcod'].'"><i class="far fa-trash"></i></a>': '')
																 )
															.'</td>'
                            .'</tr>';
                        }
                  		?>
                		</tbody>
              		</table>
                </div>
              </div><!-- /card -->
            </div><!-- /col -->
          </div><!-- /row -->
        </div><!-- /tab001 -->
        
      </div><!-- /tabContent -->
		</div><!-- /container-fluid -->
    
    <div class="hidden" id="progress_div"> 
			Liberando objetos...<br><br>
      <div class='progress'>
        <div class='progress-bar progress-bar-success' role='progressbar' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100' style='width: 0%'>
          <span class='sr-only'></span>
        </div>
      </div><br><br>
    </div>
    
	</form>
  <script>
		// sysdevgrptxt - typeahead
    <?php if(!$lv_limitdevgrp){ ?>
    
    var lo_get = {"fldsec":"<?= $lv_sec; ?>", "fldflt":{"d.docsts":"A"}, "fldasg":{"sysdevgrpcod":"sysdevgrpcod", "sysdevgrptxt":"sysdevgrptxt"}};
    tmssTypeahead($("#<?= $lv_sec; ?> #sysdevgrptxt"), "sysdevgrp", lo_get)    
    
    <?php } ?>
    
    <?php if($lv_hasObjectPermission){ ?>
    // VER OBJETO. accede al detalle del objeto
    $("#<?= $lv_sec; ?> a[name=sysobjlnk]").on("click",function(e){e.preventDefault
      tmssLink("?prg=sysobj&act=03&prm_sysobjcod="+$(this).data("sysobjcod"), [{target: "_new_section",target_id: "#<?= $lv_sec; ?>"}]);
    });
    <?php } ?>
    
    
    // MOVER. mueve el objeto acutal a otra OT/usuario
    $("#<?= $lv_sec; ?> a[name=objmov]").click(function(e){ e.preventDefault();
      // muestra dialogo de selección de OT
      var lv_pstdat = [{name:"sysobjcod", value:$(this).data("sysobjcod")}];
      tmssCallProcess("?prg=systraobj&act=moveobj",lv_pstdat,function(data){
        if(data["errtyp"] == "W"){ toastr.warning(data["errtxt"]); return false; }
        BootstrapDialog.show({
          title: "<?= $vew_lang->move; ?>",
          message:$(data),
          size: BootstrapDialog.SIZE_MEDIUM,
          closable:true,
          draggable:true,
          buttons: [{ label: "<?= $vew_lang->cancel; ?>", cssClass: "btn-danger", action: function(dialog){dialog.close(); } },
                    {	label: "<?= $vew_lang->accept; ?>", cssClass: "btn-success",	action: function(dialog){
                      if(!tmssCheckRequiredFields( dialog.$modalBody.find("form:first") )){ return false; }
                      //obtiene datos del dialog
                      var lv_usrcod = dialog.$modalBody.find("#usrcod").val();
                      var lv_systracod = dialog.$modalBody.find("#systracod").val();
                      var lv_sysobjcod = dialog.$modalBody.find("#sysobjcod").val().split(";");
                      var lv_systraobjcod = dialog.$modalBody.find("#systraobjcod").val().split(";");
                      //variable de erros
                      var lv_errs = 0;
                      for( var i = 0; i < lv_systraobjcod.length; i++ ){
                        //si es el ultimo indice lo salta porque siempre esta vacio
                        if( i == lv_systraobjcod.length - 1 ){ break; }

                        // asigna el objeto seleccionado al ot o usuario nuevo
                        var lv_post = [{name:"systracod",value:lv_systracod}
                                      ,{name:"usrcod",value:lv_usrcod}
                                      ,{name:"systraobjcod",value:lv_systraobjcod[i]}
                                      ,{name:"sysobjcod",value:lv_sysobjcod[i]}
                                      ,{name:"docsts",value:"A"}];
                        tmssCallProcess("?prg=systraobj&act=00",lv_post,function(data){
                          if(data['errtyp'] == "W"){
                            toastr.warning("Error al mover archivo");
                            lv_errs++;
                          }
                        });
                      }
                      if( lv_errs == 0 ){ toastr.success("Movimiento realizado"); }
                      <?= $lv_sec; ?>_fnc({action: '99'});
                      //cierra el dialog
                      dialog.close();
                    }}]
        });
      });
    });
		
    
    // QUITAR. quita el objeto actual de la orden
    /*
    $("#<?= $lv_sec; ?> a[name=objdel]").click(function(e){ e.preventDefault();
			var lv_sysobjcod = $(this).data("sysobjcod");
			BootstrapDialog.show({
				title: "Quitar Objeto",
				message:"Desea quitar el objeto de la orden ?",
				type: BootstrapDialog.TYPE_WARNING,
				buttons: [{id:"btncnc", label: "<?= $vew_lang->cancel; ?>", action: function(dialogRef){
										dialogRef.close();
									}},
									{id: "btnrls", label: "<?= $vew_lang->remove; ?>", cssClass: "btn-warning", action: function(dialogRef){

										var lv_pstdat = {systracod:"<?= $vew_data->systracod; ?>",sysobjcod:lv_sysobjcod};
										tmssCallProcess("?prg=systraobj&act=04",lv_pstdat,function(data){
											$("#<?= $lv_sec; ?> #tblobj tbody tr[data-sysobjcod="+lv_sysobjcod+"]").remove();
											toastr.success("Objeto quitado de la orden.");
											dialogRef.close();
										});
				
									}}]
			});
    });
    */
		
        
    // COMPARAR. compara el codigo actual con otra version/entorno
    $("#<?= $lv_sec; ?> a[name=objcmp]").click(function(e){ e.preventDefault();
      var lv_pstdat = {sysobjcod:$(this).data("sysobjcod")};
      tmssCallProcess("?prg=sysobj&act=showCompare",lv_pstdat,function(data){
        BootstrapDialog.show({
          cssClass: "tmss-modal-xl",
          type: BootstrapDialog.TYPE_PRIMARY,
          closable:true,
					draggable: true,
        	title: "<?= $vew_lang->compare; ?>",
          message: $(data)
        });
      });
    });
		
    
    // LIBERAR TODO. libera todos los objetos de la orden
		$("#<?= $lv_sec; ?> #btnrelL, #<?= $lv_sec; ?> #btnrelR").click(function(e){ e.preventDefault();
			BootstrapDialog.show({
				title: "Liberar Orden",
				message:"Desea liberar la orden ?",
				type: BootstrapDialog.TYPE_WARNING,
				buttons: [{id: "btnrls", icon: "fas fa-cog", label: "<?= $vew_lang->release; ?>",
										cssClass: "btn-success",autospin: true, action: function(dialogRef){
											dialogRef.$modalBody.html( $("#<?= $lv_sec; ?> #progress_div").clone().removeClass("hidden").html() );
											// recorro todos los objetos y por cada archivo realizo el envio a produccion
											$("#<?= $lv_sec; ?> #tblobj tbody tr[data-status!=r]").each(function(){
												var lv_systraobjcod = $(this).data("systraobjcod");
												var lv_sysobjcod = $(this).data("sysobjcod");
                        <?= $lv_sec; ?>_releaseObject(lv_systraobjcod, lv_sysobjcod);
											});
										}
									},
									{id:"btncnc", label: "<?= $vew_lang->cancel; ?>", autospin: false, action: function(dialogRef){ dialogRef.close(); }}]
			});
    });
		
    
    // LIBERAR INDIVIDUAL. libera un objeto de la orden
    $("#<?= $lv_sec; ?> a[name=objrel]").click(function(e){ e.preventDefault();
      var lv_pstdat = {sysobjcod:$(this).data("sysobjcod")};
      var lv_systraobjcod = $(this).data("systraobjcod");
      var lv_sysobjcod = $(this).data("sysobjcod");
      var lv_msg = "Desea liberar el objeto ["+$("#<?= $lv_sec; ?> #tblobj tbody tr[data-systraobjcod="+lv_systraobjcod+"]").data("sysobjtxt")+"] ?";
			BootstrapDialog.show({
				title: "Liberar Objeto",
				message:lv_msg,
				type: BootstrapDialog.TYPE_WARNING,
				buttons: [{id: "btnrls", icon: "fas fa-cog", label: "<?= $vew_lang->release; ?>",
										cssClass: "btn-success",autospin: true, action: function(dialogRef){
											dialogRef.$modalBody.html( $("#<?= $lv_sec; ?> #progress_div").clone().removeClass("hidden").html() );											
                      <?= $lv_sec; ?>_releaseObject(lv_systraobjcod, lv_sysobjcod);
                      // cierra el dialogo actual
                      $.each(BootstrapDialog.dialogs, function(id, dialog){ dialog.close(); });
										}
									},
									{id:"btncnc", label: "<?= $vew_lang->cancel; ?>", autospin: false, action: function(dialogRef){ dialogRef.close(); }}]
			});                                                        
  	});
    
    
    // RELEASE OBJECT. libera un objeto individual a productivo
		function <?= $lv_sec; ?>_releaseObject(lp_systraobjcod, lp_sysobjcod){
      // para las bases de datos, la liberacion debe ser manual (FALTA proceso automático)
      var lv_objtyp = $("#<?= $lv_sec; ?> #tblobj tbody tr[data-sysobjcod="+lp_sysobjcod+"]").data("grp");
      if( lv_objtyp=="database" ){
      	<?= $lv_sec; ?>_releaseOrderObject(lp_systraobjcod, lp_sysobjcod);
      } else {
        // envia objeto a productivo
        var lv_pstdat = [{name:"sysobjcod",value:lp_sysobjcod},{name:"sendto",value:"customers"}];
        tmssCallProcessNoBackdrop("?prg=sysobj&act=sendFile",lv_pstdat,function(data){
          if(data.errtyp=="S"){
						<?= $lv_sec; ?>_releaseOrderObject(lp_systraobjcod, lp_sysobjcod);
          } else {
            $("#<?= $lv_sec; ?> #tblobj tbody tr[data-sysobjcod="+lp_sysobjcod+"]").find("td:last").html("<i class='fas fa-exclamation-triangle text-danger' title='"+data.errcod+": "+data.errtxt+"'></i>");
          }
        });
      }  
		}
		
    
    // RELEASE ORDER OBJECT. actualiza status de liberacion del objeto en la OT
    function <?= $lv_sec; ?>_releaseOrderObject(lp_systraobjcod, lp_sysobjcod){
      var lv_pstdat = [{name:"systracod",value:$("#<?= $lv_sec; ?> #systracod").val()},{name:"systraobjcod",value:lp_systraobjcod},{name:"sysobjcod",value:lp_sysobjcod}];
      tmssCallProcessNoBackdrop("?prg=systraobj&act=release",lv_pstdat,function(data){

        // actualizo mensajes
        if(data.errtyp=="S"){
          $("#<?= $lv_sec; ?> #tblobj tbody tr[data-sysobjcod="+lp_sysobjcod+"]").data("status","r");
          $("#<?= $lv_sec; ?> #tblobj tbody tr[data-sysobjcod="+lp_sysobjcod+"]").find("td:last").html("<i class='far fa-check text-success card-icon'></i>");
        } else {
          $("#<?= $lv_sec; ?> #tblobj tbody tr[data-sysobjcod="+lp_sysobjcod+"]").find("td:last").html("<i class='fas fa-exclamation-triangle text-danger card-icon' title='"+data.errcod+": "+data.errtxt+"'></i>");
        }

        // actualiza progreso
        var lv_max = $("#<?= $lv_sec; ?> #tblobj tbody tr").length;
      	var lv_qty = 0;
      	$("#<?= $lv_sec; ?> #tblobj tbody tr").each(function(){if($(this).data("status")=="r"){lv_qty++;}})
        $.each(BootstrapDialog.dialogs, function(id, dialog){
          dialog.$modalBody.find(".progress-bar").css("width",Number(lv_qty*100/lv_max).toFixed(0)+"%");
        });

				// verfica si la ot se puede liberar
        <?= $lv_sec; ?>_checkOrderStatus();
      });
    }
    
    
    // CHECK ORDER STATUS. verifica si estan todos los objetos liberados y libera la OT
    function <?= $lv_sec; ?>_checkOrderStatus(){
      var lv_max = $("#<?= $lv_sec; ?> #tblobj tbody tr").length;
      var lv_qty = 0;
      $("#<?= $lv_sec; ?> #tblobj tbody tr").each(function(){if($(this).data("status")=="r"){lv_qty++;}})
      // si estan todos los objetos liberados se puede hacer la liberacion de cabecera
      if(lv_max==lv_qty){ <?= $lv_sec; ?>_releaseOrder(); }
    }
    
    
    // RELEASE ORDER. actualiza el status de liberacion de cabecera de la OT
    function <?= $lv_sec; ?>_releaseOrder(){
      var lv_pstdat2 = [{name:"systracod",value:$("#<?= $lv_sec; ?> #systracod").val()}];
      tmssCallProcess("?prg=systra&act=05",lv_pstdat2,function(data2){
        toastr.success("Orden liberada.");
        // cierra el dialogo actual
        $.each(BootstrapDialog.dialogs, function(id, dialog){
          dialog.close();
        });
        // oculta botones de modificación y liberacion
        $("#<?= $lv_sec; ?> #btnrelL").addClass("hidden"); 
        $("#<?= $lv_sec; ?> #btnrelR").addClass("hidden");
        $("#<?= $lv_sec; ?> #btnmodL").addClass("hidden");
        $("#<?= $lv_sec; ?> #btnmodR").addClass("hidden");
        //tmssTabSecCls( $("#<?= $lv_sec; ?>") );
      });
    }
  </script>
	<?php include( 'grldocfrmscr.frm' ); ?>
</section>
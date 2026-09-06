<?php
  // campos requeridos 
  $vew_input->RequiredFields( array() );

  // clave del documento 
  $lv_dockey = $vew_data->wrkflwdatcod;

  // titulo 
  $lv_title = $vew_lang->workflow;

  // módulo y programa 
  $lv_mdlcod = 'GRL';
  $lv_prgcod = 'WRK';

	// libreria de estilos bootstrap
	include_once('_library.frm');
?>
<section id="<?= $lv_sec; ?>">
	<style>
		.tmss-workflow-step{ margin-top: 35px; }
		.tmss-workflow-step .card { background-color: var(--tmss-white); border-radius: 10px; border: var(--tmss-gray) 1px solid; min-height: 60px; }
		.tmss-workflow-step .card .icon { color: white; border-radius: 50%; border: var(--tmss-gray) 2px solid; float: left; position: relative; text-align: center; padding: 10px; width: 50px; height: 50px; top: -25px; left: calc(50% - 25px); }
		.tmss-workflow-step .card.released .icon { background-color: var(--tmss-green-500); }
		.tmss-workflow-step .card.released { border: var(--tmss-green-500) 3px solid; }
		.tmss-workflow-step .card.rejected .icon { background-color: var(--tmss-red-500); }
		.tmss-workflow-step .card.rejected { border: var(--tmss-red-500) 3px solid; }
		.tmss-workflow-step .card.pending .icon { background-color: var(--tmss-blue-500); }
		.tmss-workflow-step .card.pending { border: var(--tmss-blue-500) 3px solid; }
		.tmss-workflow-step .text{ text-align: center; padding-bottom: 10px; }
		.tmss-workflow-step .buttons a{ padding: 10px; }
	</style>
  <form method="POST" class="form-horizontal tmss-form-horizontal pb-0" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('wrkflwdatcod','hidden',$vew_data->wrkflwdatcod);?>
    <?= gethtml('srcobjtyp', 'hidden', $vew_data->srcobjtyp); ?>
    <?= gethtml('srcobjcod001', 'hidden', $vew_data->srcobjcod001); ?>
    <?= gethtml('srcobjcod002', 'hidden', $vew_data->srcobjcod002); ?>
		
    <div class="container-fluid" style="display: flex; justify-content: space-evenly;">
			<?php
				$lv_buffer = '';
				$lv_step_pending = 0;
				foreach($vew_data->grldatwrkstp as $lv_rowstp){
					$lv_status_class = (($lv_rowstp['relsts']??'')=='A'?'released':(($lv_rowstp['relsts']??'')=='R'?'rejected':'pending'));
					$lv_status_icon = (($lv_rowstp['relsts']??'')=='A'?'far fa-check':(($lv_rowstp['relsts']??'')=='R'?'far fa-times':'far fa-circle'));
					$lv_status_footer = '';
          
          //Obtengo si el usuario actual tiene permisos o no
          $i=0;
          $lv_wrkflwstpatr = strtolower($lv_rowstp['wrkflwstpatr']??'');
          // recorro todos los aprobadores del paso
          $lv_res = $vew_doc->getTagValue( $lv_wrkflwstpatr, 'res'.$i );
          $lv_found = false;
          while( $lv_res!=''  && !$lv_found){
            $lv_typ = $vew_doc->getTagValue( $lv_res, 'typ' );
            $lv_val = $vew_doc->getTagValue( $lv_res, 'val' );
            $lv_status_footer .= ($lv_typ=='usr'?'<i class="far fa-user"></i>':($lv_typ=='rol'?'<i class="far fa-users"></i>':'')).' '.$lv_val.'<br>';
            // es un usuario aprobador de este paso?
              if( $lv_typ=='usr' && $lv_val==strtolower($vew_sec->usrcod) ){
                $lv_found = true;
              // el usuario tiene el rol que puede aprobar este paso?
              } else if( $lv_typ=='rol' ){
                foreach( $vew_data->usrgrp as $lv_rowusrgrp ){
                  if( $lv_val==strtolower($lv_rowusrgrp['usrgrpcod']) ){ $lv_found=true; break; }
                }
              }
            $i++;
            $lv_res = $vew_doc->getTagValue( $lv_wrkflwstpatr, 'res'.$i);
          }						
					if( $lv_status_class=='pending'){
            // muestro botones de aprobacion si el usuario tiene rol y es el primer paso
            if($lv_found && $lv_step_pending==0){
                $lv_status_footer ='<a href="#" name="btnapprove" data-status="S" class="btn btn-sm btn-success">'.$vew_lang->approve.'</a>'
                .' <a href="#" name="btnreject" data-status="R" class="btn btn-sm btn-danger">'.$vew_lang->reject.'</a>';
                $lv_wrkflwstpatr = ''; 
            }   
            $lv_step_pending++;
          } else {
						$lv_status_footer = (is_object($lv_rowstp['reldte'])?$lv_rowstp['reldte']->format('d/m/Y H:m:s'):'').'<br>'.($lv_rowstp['relusr']??'');
					}
					// agrega tarjeta de paso de workflow
					$lv_buffer .='<div class="col-sm-4 tmss-workflow-step" data-wrkflwstpdatcod="'.($lv_rowstp['wrkflwstpdatcod']??'').'" data-wrkflwstpcod="'.($lv_rowstp['wrkflwstpcod']??'').'">'
											.'<div class="card '.$lv_status_class.'">'
												.'<span class="icon"><i class="'.$lv_status_icon.' fa-2x"></i></span>'
												.'<div class="text">'
													.((($lv_rowstp['wrkflwstpfrmcod']!='' && $lv_rowstp['wrkflwstpfrmcod']!='0') && $lv_found && $lv_step_pending <= 1)?'<a href="#" name="grldatfrm" '
													.' data-wrkflwstpdatcod="'.($lv_rowstp['wrkflwstpdatcod']??'').'"'
                          .' data-wrkflwstptxt="'.$lv_rowstp['wrkflwstptxt'].'"'
                          .' data-sysdocfrmcod="'.$lv_rowstp['wrkflwstpfrmcod'].'"'
                          .'>'.$lv_rowstp['wrkflwstptxt']
                          .'</a>'
                          :$lv_rowstp['wrkflwstptxt'])
													.'<hr>'
													.$lv_status_footer
												.'</div>'
											.'</div>'
										.'</div>';
        }
				echo $lv_buffer;
			?>
    </div>
  </form>
  <script>
    //updateSTATUS
		//Carga los formularios asociados ya guardados.
    <?=$lv_sec; ?>_updateStatus();
        function <?=$lv_sec; ?>_updateStatus(){
  		// STATUS. actualizo status de formularios
				var lv_pstdat2=[{name:"srcobjtyp", value:"WRK_STP"},
												{name:"srcobjcod001", value:"<?= $lv_dockey; ?>"}];
				tmssCallProcessNoBackdrop("?prg=grldatfrm&act=18", lv_pstdat2,  function(data2){ 
					for(var i=0; i<data2.length; i++){
						//$("#<?= $lv_sec; ?> a[name='grldatfrm'][data-sysdocfrmcod=" + data2[i]["sysdocfrmcod"] + "]").attr("data-frmdatcod", String(data2[i]["frmdatcod"]));            
						//$("#<?= $lv_sec; ?> a[name='grldatfrm'][data-sysdocfrmcod=" + data2[i]["sysdocfrmcod"] + "] i").prop("class", "far fa-check");
						$("#<?= $lv_sec; ?> a[name='grldatfrm'][data-wrkflwstpdatcod=" + data2[i]["srcobjcod002"] + "]").attr("data-frmdatcod", String(data2[i]["frmdatcod"]));
						$("#<?= $lv_sec; ?> a[name='grldatfrm'][data-wrkflwstpdatcod=" + data2[i]["srcobjcod002"] + "] i").prop("class", "far fa-check");
					}
				});
  }
  </script>
  <script>
		// FORMULARIO. muestra el formulario asignado al paso
    $("#<?= $lv_sec; ?> a[name=grldatfrm]").on("click",function(e){ e.preventDefault();
      if($(this).data("sysdocfrmcod")){
        var lv_frmtxt = $(this).data("wrkflwstptxt");                                                    
        var lv_pstdat2=[{name:"frmdatcod", value:$(this).data("frmdatcod")},
                        {name:"srcobjtyp", value:"WRK_STP"},
                        {name:"srcobjcod001", value:"<?= $lv_dockey; ?>"},
                        {name:"srcobjcod002",value: $(this).data("wrkflwstpdatcod")},
                        {name:"sysdocfrmcod", value:$(this).data("sysdocfrmcod")},
                        {name:"readonly", value:"false"}];
      	var $lv_elm = $(this);
        //Si no existe el card.pending devuelve false entonces no muestra los botones al momento de revisar el formulario post aprobacion/rechazo
        var lv_shwbtn =  $(this).closest('.card.pending').length > 0;
        var lv_sve = false;
        var lo_body ;
        tmssCallProcess("?prg=grldatfrm&act=03", lv_pstdat2,  function(data2){ 
          BootstrapDialog.show({
						title: lv_frmtxt,
						type: BootstrapDialog.TYPE_PRIMARY,
						size: BootstrapDialog.SIZE_WIDE,
						draggable:true,
						closable:false,
						message: $(data2),
						buttons: [{ label: "<?= $vew_lang->cancel; ?>", id:"btncls", cssClass: "btn-danger", action: function(dialog){ dialog.close(); } },
											{	label: "<?= $vew_lang->save; ?>", 
																	 cssClass: "btn-success " + (lv_shwbtn? "" : "hidden"), 
																	 action:function(dialog){
																														lo_body = dialog.getModalBody();
																														$(lo_body).find("#btnsve").data("btn_callback", "#btngetfrmdat").trigger("click");
																														lv_sve = true;
																													}
											} ],
						onhidden: function(dialog){
							//Si el elemento fue guardado, entonces le asigno el codigo del formulario creado al DOM.
							if(lv_sve){	$lv_elm.attr("data-frmdatcod",  $(lo_body).find("#btnsve").data("frmdatcod")); } 
						}
          });
        });
      }
		});
		
		
		// APROBACION / RECHAZO. confirma aprobacion o rechazo del paso
		$("#<?= $lv_sec; ?> a[name=btnreject],#<?= $lv_sec; ?> a[name=btnapprove]").on("click",function(e){ e.preventDefault();
		
			// si tiene un formulario, debe grabarlo primero antes de hacer la aprobacion
			if( $(this).prop("name")!="btnreject" ){
				var lv_frmqty=0, lv_frmfil=0;
				$(this).parent().find("a[name=grldatfrm]").each(function(){
					lv_frmqty++;
					lv_frmfil += ($(this).data("frmdatcod")!="" && $(this).data("frmdatcod")!=undefined ? 1 : 0);
				});
				if( lv_frmqty!=lv_frmfil ){
					toastr.warning("Para aprobar debe grabar primero el/los formularios asociados.");
					return false;
				}
			}
		
			var lv_ttl = ($(this).prop("name")=="btnreject" ? "<?= $vew_lang->reject; ?>" : "<?= $vew_lang->approve; ?>" );
			var lv_typ = ($(this).prop("name")=="btnreject" ? BootstrapDialog.TYPE_DANGER : BootstrapDialog.TYPE_SUCCESS );
			var lv_msg = ($(this).prop("name")=="btnreject" ? "Desea RECHAZAR el documento ?" : "Desea APROBAR el documento ?" );
      var lv_relsts = ($(this).prop("name")=="btnreject" ? "R" : "A");
			var lv_wrkflwstpdatcod = $(this).closest('.tmss-workflow-step').data("wrkflwstpdatcod");          
      var lv_wrkflwstpcod = $(this).closest('.tmss-workflow-step').data("wrkflwstpcod");                                                                                                     
			var dialogItself = BootstrapDialog.confirm({
				title: lv_ttl,
				message: lv_msg, 
				type: lv_typ,
				callback: function(result){
					if(result){
						var lv_pstdat =[{name: "stprelsts", value: lv_relsts},
                            {name:"wrkflwdatcod", value: "<?= $vew_data->wrkflwdatcod ?>"},
                            {name:"wrkflwstpdatcod",value: lv_wrkflwstpdatcod},
                            {name:"wrkflwstpcod", value:lv_wrkflwstpcod},
														{name:"srcobjtyp", value:"<?=$vew_data->srcobjtyp?>"},
                        		{name:"srcobjcod001", value:"<?=$vew_data->srcobjcod001?>"},
                            {name:"srcobjcod002",value:"<?=$vew_data->srcobjcod002?>"}];
						tmssCallProcess("?prg=grldatwrk&act=changeStatus", lv_pstdat, function(data){              
              $('button.close').trigger('click');
            	$("a[data-wrkflwdatcod=<?=$vew_data->wrkflwdatcod?>]").trigger("click");
            });
					}
				}
			});
    });
  </script>
  <script>
  	tmssFormEdit("<?= $lv_sec; ?>", false);
  </script>
</section>
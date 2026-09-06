<?php
	/* id de sección */
	$lv_sec = $vew_token;

	// campos requeridos
	$vew_input->RequiredFields( array() );

	// libreria de estilos bootstrap
	include_once('_library.frm');
  
	// array de estados
	$lv_sts_arr = array('S' => array('ststxt' => $vew_lang->started, 'stscls' => 'text-warning far fa-circle'),
                     'A' => array('ststxt' => $vew_lang->approved, 'stscls' => 'text-success fas fa-circle-check'),
                     'R' => array('ststxt' => $vew_lang->rejected, 'stscls' => 'text-danger fas fa-circle-xmark'),
                     'I' => array('ststxt' => $vew_lang->inactive, 'stscls' => 'far fa-circle'));

	// añado key a los registros del log
	$lv_log_arr = array();
	$lv_chglog = $vew_data->chglog;

	foreach($vew_data->docwrk as $lv_row){
    foreach($lv_chglog as $lv_key=>$lv_row2){
    	foreach($lv_row['wrkflwstp'] as $lv_row3){
        if(($lv_row2['chgdocsrctyp'] == 'DAT_WRK' && $lv_row2['chgdocsrccod'] == $lv_row['wrkflwdatcod']) ||
           ($lv_row2['chgdocsrctyp'] == 'DAT_WRK_STP' && $lv_row2['chgdocsrccod'] == $lv_row3['wrkflwstpdatcod'])){
          
          if(!isset($lv_log_arr[$lv_row['wrkflwdatcod']])){
            $lv_log_arr[$lv_row['wrkflwdatcod']]= array();
          }
          
          array_push($lv_log_arr[$lv_row['wrkflwdatcod']], array('cteusr' => $lv_row2['cteusr'],
                                                                 'ctedte' => date_format($lv_row2['ctedte'],'d.m.Y H:i'),
                                                                  'chgdocatrold' => $lv_sts_arr[$lv_row2['chgdocatrold']]['ststxt'],
                                                                  'chgdocatrnew' => $lv_sts_arr[$lv_row2['chgdocatrnew']]['ststxt'],
                                                                  'chgdocsrctyp' => $lv_row2['chgdocsrctyp'],
                                                                  'chgdocsrccod' => $lv_row2['chgdocsrccod']));
          unset($lv_chglog[$lv_key]);
          break;
        }
  		}
    }
  }

	$vew_readonly = false;
?>
<section id="<?= $lv_sec; ?>">
	<style>
	.tmss-step-line{height: 5px; position: relative; overflow: hidden;
    /*background-color: #d5d5d5;
    border-radius: 10px;*/
	}
	.tmss-step-line-start{ background-color: #eaeaea; width: 50%; top: 22px; }
	.tmss-step-line-end{ background-color: #eaeaea; width: 50%; top: 17px; left: 50%;}
	table tbody tr td:hover{ background-color: #d5eff4; border-radius: 10px; cursor: pointer; }	
	</style>
  <form method="POST" class="form-horizontal tmss-form-horizontal pb-0" id="<?= $lv_sec; ?>_frm">
    <div class="container-fluid">
      <?php
        echo gethtml('srcobjtyp', 'hidden', $vew_data->srcobjtyp);
        echo gethtml('srcobjcod001', 'hidden', $vew_data->srcobjcod001);
        echo gethtml('srcobjcod002', 'hidden', $vew_data->srcobjcod002);
				
      	$lv_docwrk = $vew_data->docwrk;
        foreach( $lv_docwrk as $lv_row ) {
          $lv_wrk = '';
          //$lv_rowicn = '';
          //$lv_rowtxt = '';
          //$lv_stpdatcod = '';
					
          // si hay error, solo muestra el error
          if(isset($lv_row['errtxt'])){
            $lv_wrk = '<div class="text-center tmss-bold">'.$lv_row['errtxt'].'</div>';
						continue;
          }

          // muestra el workflow junto al log
          $lv_wrk='<table data-wrkcod='.$lv_row['wrkflwcod'].' data-wrkdatcod='.$lv_row['wrkflwdatcod'].' class="tmss-w-100-pct tmss-mw-100-pct" name="wrkstp">'.
									'<thead><tr>'.str_repeat('<th style="width:'.(100/(count($lv_row['wrkflwstp'])>0 ? count($lv_row['wrkflwstp']) : 1 ) ).'%"></th>', (count($lv_row['wrkflwstp'])>0 ? count($lv_row['wrkflwstp']) : 1 )).'</tr></thead>'.
									'<tbody>';
            
          //$lv_stpdatcod_str = '';
          //$lv_stepstarted = false;
					$i=0;
          foreach($lv_row['wrkflwstp'] as $lv_key=>$lv_row2){
            //$lv_row2['relsts'] = ($lv_row2['relsts']=='S' ? ($lv_stepstarted?'I':'S') : $lv_row2['relsts']);
            $lv_wrk.='<td class="text-center" data-stpcod='.$lv_row2['wrkflwstpcod'].' data-stpdatcod='.$lv_row2['wrkflwstpdatcod'].' style="padding-bottom: 10px;">'
										.'<div class="tmss-step-line '.($i>0 && count($lv_row['wrkflwstp'])>1?'tmss-step-line-start':'').'"></div>'
										.'<div class="tmss-step-line '.($i+1<count($lv_row['wrkflwstp'])?'tmss-step-line-end':'').'"></div>'
										.'<i class="'.(isset($lv_row2['relsts']) ? $lv_sts_arr[$lv_row2['relsts']]['stscls'] : $lv_sts_arr['I']['stscls']).' fa-2x" style="position:relative;"></i>'
										.'<div>'.$lv_row2['wrkflwstptxt'].'</div>'
										.'</td>';
						$i++;
						//$lv_rowtxt .=	'<td class="tmss-pt-10 tmss-va-top" data-stpcod='.$lv_row2['wrkflwstpcod'].' data-stpdatcod='.$lv_row2['wrkflwstpdatcod'].'><div class="tmss-bold text-center"><span>'.$lv_row2['wrkflwstptxt'].'</span>';
						
						//$lv_stepstarted = ($lv_stepstarted ? $lv_stepstarted : ($lv_row2['relsts'] == 'S' ? true : false));
						
						// verificar si hay formulario
						//if(isset($lv_row2['wrkflwstpfrmcod']) && $lv_row2['wrkflwstpfrmcod']!=0){
							//$lv_rowtxt .= '&nbsp;<i class="far fa-table-layout"></i>';
							//$lv_wrk .= '<textarea class="hidden" data-stpdatcod='.$lv_row2['wrkflwstpdatcod'].'></textarea>';
						//}
						
						/*
						// nombrar responsables
						if((isset($lv_row2['relsts']) && $lv_row2['relsts']=='S') && $lv_row2['wrkflwstpatr'] !== ""){
							$lv_rowtxt .= '<br>'.($vew_lang->responsible);
							$lv_res = array('ROL' => '', 'USR' => '');
							$lv_roles = '';
							$lv_users = '';
							$j = 0;
							
							// responsables
							while( $vew_doc->getTagValue($lv_row2['wrkflwstpatr'], 'res'.$j) != '' ){
								$lv_actres = $vew_doc->getTagValue($lv_row2['wrkflwstpatr'], 'res'.$j);
								$lv_res[$vew_doc->getTagValue($lv_actres, 'typ')] .= ($lv_res[$vew_doc->getTagValue($lv_actres, 'typ')] == '' ? '' : ', ').($vew_doc->getTagValue($lv_actres, 'val'));
								
								$j++;
							}
							
							$lv_rowtxt .= ($lv_res['ROL'] != '' ? '<br>'.($vew_lang->roles).': '.$lv_res['ROL'] : '');
							$lv_rowtxt .= ($lv_res['USR'] != '' ? '<br>'.($vew_lang->users).': '.$lv_res['USR'] : '');
						}
						
						$lv_rowtxt .= '</div></td>';
						*/
						// guarda código del paso-documento
						//$lv_stpdatcod_str .= '_'.$lv_row2['wrkflwstpdatcod'];
          }
					//unset($lv_row2);
					
					//$lv_wrk .= '<tr>'.$lv_rowicn.'</tr>';
					//<tr>'.$lv_rowtxt.'</tr>
					$lv_wrk .= '</tbody></table>';
					//$lv_stpdatcod_str .= '_';
            
					// crea log del workflow
					$lv_log = 
						'<div class="hidden" id="chgatr_'.$lv_row['wrkflwcod'].'">'.
							'<table class="table table-condensed table-bordered">'.
								'<thead><tr><th>'.($vew_lang->when).'</th><th>'.($vew_lang->who).'</th><th>'.($vew_lang->what).'</th><th>'.($vew_lang->change).'</th></tr></thead>'.
								'<tbody>';
            
					if(isset($lv_log_arr[$lv_row['wrkflwdatcod']])){
						foreach($lv_log_arr[$lv_row['wrkflwdatcod']] as $lv_key=>$lv_row2){
							$lv_log .= 
								'<tr class="bg-info">'.
									'<td>'.$lv_row2['ctedte'].'</td>'.
									'<td>'.$lv_row2['cteusr'].'</td>'.
									'<td>'.($lv_row2['chgdocsrctyp'] == 'DAT_WRK' ? $vew_lang->workflow : ($vew_lang->step).': '.$lv_row['wrkflwstp'][$lv_row2['chgdocsrccod']]['wrkflwstptxt']).'</td>'.
									'<td>'.$lv_row2['chgdocatrold'].(trim($lv_row2['chgdocatrold'])=='' || trim($lv_row2['chgdocatrnew'])=='' ? '' : '&nbsp;<i class="fas fa-angle-right"></i>&nbsp;').$lv_row2['chgdocatrnew'].'</td>'.
								'</tr>';
							unset($lv_log_arr[$lv_key]);
						}
						//unset($lv_row2);
					}
					$lv_log .= '</tbody></table></div>';
					$lv_wrk .= $lv_log;
					
					
        //}
          
          echo '<div class="card">'.
									'<div class="card-header">'.
										'<div class="card-title">#'.$lv_row['wrkflwcod'].' - '.ucfirst(strtolower($lv_row['wrkflwtxt'])).
										'<a href="#" id="chgatrdet" title="'.$vew_lang->history.'" class="card-icon" data-wrkflwcod='.$lv_row['wrkflwcod'].'><i class="far fa-circle-info"></i></a>'.
										'</div>'.
									'</div>'.
									'<div class="card-body tmss-card-body-edit">'.$lv_wrk.'</div>'.
								'</div>';
        }
      	//unset($lv_row);
      ?>
    </div>
  </form>
  <script>
    <?= $lv_sec; ?>_docwrk_arr = [<?php 
          $lv_buffer='';
          foreach($lv_docwrk as $lv_row){ 
            $lv_buffer .= ($lv_buffer!=''?',':'').'{'.
                        'wrkflwcod:"'.$lv_row['wrkflwcod'].'",'.
                        'wrkflwtxt:"'.$lv_row['wrkflwtxt'].'",'.
                        'wrkflwcndtyp:"'.$this->co_reg->document->getTagValue($lv_row['wrkflwcnd'], 'typ').'",'.
                        'wrkflwcndval:"'.$this->co_reg->document->getTagValue($lv_row['wrkflwcnd'], 'val').'",'.
              					'wrkflwstp:'.json_encode($lv_row['wrkflwstp']).','.
                        'relsts:"'.(isset($lv_row['relsts']) ? $lv_row['relsts'].'",' : '"').
                        (isset($lv_row['relsts']) ? 'relusr:"'.$lv_row['relusr'].'",' : '').
                        (isset($lv_row['relsts']) ? 'reldte:"'.($lv_row['reldte']!=null?(is_array($lv_row['reldte'])?date('d/m/Y', strtotime($lv_row['reldte']['date'])):$lv_row['reldte']->format('d/m/Y')):'').'"' : '').
                        '}'; 
          }
          echo $lv_buffer;
    	?>];
    
    <?= $lv_sec; ?>_actstpdatcod = 0;
    <?= $lv_sec; ?>_actsysdocfrmcod = 0;
  </script>
  <script>
    $("#<?= $lv_sec; ?> #chgatrdet").on("click",function(e){ e.preventDefault();
			BootstrapDialog.show({
				title: "<?= $vew_lang->attributes; ?>", 
				message: $("#<?= $lv_sec; ?> #chgatr_"+$(this).data('wrkflwcod')).clone().removeClass("hidden"),
				size: BootstrapDialog.SIZE_WIDE,
				type: BootstrapDialog.TYPE_PRIMARY,
				draggable: true,
			});
		});
  </script>
  <script>
  	$(function(){
      var lv_frmdat = <?= json_encode($vew_data->frmdat); ?>;
      var lv_input = "";
      for (let stpdatcod in lv_frmdat) {
        lv_input = $("<input class='hidden'></input>");
        lv_input = $(lv_input).attr("id", "grldatfrm_frm_"+lv_frmdat[stpdatcod]["sysdocfrmcod"]+ "_" + stpdatcod).attr("name", "grldatfrm_frm_"+lv_frmdat[stpdatcod]["sysdocfrmcod"]+ "_" + stpdatcod).data("sysdocfrmcod", lv_frmdat[stpdatcod]["sysdocfrmcod"]);
        lv_input.val(JSON.stringify({[lv_frmdat[stpdatcod]["sysdocfrmcod"]]:lv_frmdat[stpdatcod]})); 
        $("#<?= $lv_sec; ?>_frm").append( lv_input );
    	}
    });
  </script>
  <script>
    $("#<?= $lv_sec; ?> tbody tr td").on("click", function(e){ e.preventDefault();
      var lv_stpdatcod = $(this).data("stpdatcod");
      var lv_wrk = <?= $lv_sec; ?>_docwrk_arr.find((wrk)=>{ return wrk.wrkflwcod == $(this).parents("table").data("wrkcod"); });
      var lv_frmcod = lv_wrk['wrkflwstp'][$(this).data("stpdatcod")]['wrkflwstpfrmcod'];
      <?= $lv_sec; ?>_actstpsts = lv_wrk['wrkflwstp'][$(this).data("stpdatcod")]['relsts'];
      <?= $lv_sec; ?>_actstpdatcod = $(this).data("stpdatcod");
      
      // verificar si el paso tiene un formulario
      if(lv_frmcod > 0){
        //recupera los campos ocultos
        var lv_frmval = $("#<?= $lv_sec; ?> #grldatfrm_frm_" + lv_frmcod + "_" + <?= $lv_sec; ?>_actstpdatcod).val();
        lv_frmval = (lv_frmval != "" && lv_frmval != undefined ? lv_frmval : "");
        
        //recupera datos grabados
        var lv_pstdat = [{name:"readonly", value: (<?= $lv_sec; ?>_actstpsts == "S" ? "" : 1)},
                         {name:"sysdocfrmcod", value: lv_wrk['wrkflwstp'][$(this).data("stpdatcod")]['wrkflwstpfrmcod']},
                         {name:"frmdatfldvals", value: lv_frmval},
                         {name: "srcobjtyp", value: "WRK_STP"},
                         {name: "srcobjcod001", value: <?= $lv_sec; ?>_actstpdatcod},
                         {name: "srcobjcod002", value: $("#<?= $lv_sec; ?> #srcobjcod001").val()}];
        
        tmssCallProcess("?prg=grldatfrm&act=05", lv_pstdat, function(data){   
          BootstrapDialog.show({
            title: $("#<?= $lv_sec; ?> #btnfrm").text(),
            message: $(data),
            size: BootstrapDialog.SIZE_WIDE,
            buttons: [{ label: "<?= $vew_lang->close; ?>", cssClass: "btn-default", id:"btncls", action: function(dialogItself){ dialogItself.close(); } },
                      {	label: "<?= $vew_lang->save; ?>", id: "btnsve", cssClass: "btn-success hidden",	action: function(dialogItself){
                        // busca index de la sección que contiene el formulario
                        var lv_section_idx = -1;                                                                     
                        $("section:has(form[id]:has(input#sysdocfrmcod))").each(function(i, e){ 
                          lv_section_idx = $.inArray(e, $(dialogItself.options.message));
                          if(lv_section_idx != -1){ return false; }
                        });
                        
                        // guardar código del formulario
                        var lv_frm = $(dialogItself.options.message[lv_section_idx]).find("form[id]")[0];
                        <?= $lv_sec; ?>_actsysdocfrmcod = $(lv_frm).find("#sysdocfrmcod").val();
                        
                        var lv_pstdat = [{name: "srcobjcod001", value: <?= $lv_sec; ?>_actstpdatcod},
                                        {name: "srcobjcod002", value: $("#<?= $lv_sec; ?> #srcobjcod001").val()}];
                        
                        // verificar que el usuario pueda grabar cambios en el formulario
                        tmssCallProcess("?prg=grldatwrk&act=checkRes", lv_pstdat, function(data){
                        	$(dialogItself.options.message[lv_section_idx]).find("#btnsve").data("btn_callback", "#btngetfrmdat").trigger("click");
                        });
                      }
                    },
                    { id: "btngetfrmdat", cssClass:"hidden", action: function(dialogItself){
                      // obtener los datos del formulario que fueron grabados 
                      var lv_pstdat = [{name: "srcobjtyp", value: "WRK_STP"},
                                      {name: "srcobjcod001", value: <?= $lv_sec; ?>_actstpdatcod},
                                      {name: "srcobjcod002", value: $("#<?= $lv_sec; ?> #srcobjcod001").val()}];
                     	tmssCallProcess("?prg=grldatfrm&act=06", lv_pstdat, function(data){
                        //$( "#<?= $lv_sec; ?> #grldatfrm_frm_" + <?= $lv_sec; ?>_actsysdocfrmcod + "_" + <?= $lv_sec; ?>_actstpdatcod).val( JSON.stringify(data) );
                        //si no existe el input para grabar los datos ya que no tenia datos lo crea                                                                  
                      	if($("#<?= $lv_sec; ?> #grldatfrm_frm_" + lv_frmcod + "_" + <?= $lv_sec; ?>_actstpdatcod).length==0){
                            lv_input = $("<input class='hidden'></input>");
                            lv_input = $(lv_input).attr("id", "grldatfrm_frm_"+lv_frmcod+ "_" + <?= $lv_sec; ?>_actstpdatcod).attr("name", "grldatfrm_frm_"+lv_frmcod+ "_" + <?= $lv_sec; ?>_actstpdatcod).data("sysdocfrmcod",lv_frmcod);
                            $("#<?= $lv_sec; ?>_frm").append( lv_input );
                          } 
                         $("#<?= $lv_sec; ?> #grldatfrm_frm_" + lv_frmcod + "_" + <?= $lv_sec; ?>_actstpdatcod).val(JSON.stringify(data));

                       	toastr.success("<?= $vew_lang->DOCUMENTSAVED;?>");
                        var lv_btncbk = $("#" + dialogItself.options.id + " #btngetfrmdat").data("btn_callback"); 
                        if( lv_btncbk != undefined){
                        	$("#" + dialogItself.options.id + " " + lv_btncbk).trigger("click");
                        }else{
                          dialogItself.close();
                        }
                      });
                     } 
                    },
                    { label: "<?= $vew_lang->reject; ?>", id:"btnrej", cssClass: "btn btn-danger pull-left "+(<?= $lv_sec; ?>_actstpsts != "S" ? "hidden":"") },
                    { label: "<?= $vew_lang->release; ?>", id:"btnrel", cssClass: "btn btn-success pull-left "+(<?= $lv_sec; ?>_actstpsts != "S" ? "hidden":"")},
                    { id:"btnchgsts", cssClass: "hidden", action: function(dialogItself){ 
                      // cambiar estado del paso
                      var lv_pstdat = [{name: "wrkflwstpdatcod", value: <?= $lv_sec; ?>_actstpdatcod},
                                       {name: "relsts", value: $(this).data("sts")},
                                       {name: "lv_sec", value:"<?= $vew_data->vew_sec; ?>"},
                                       {name: "srcobjtyp", value: $("#<?= $lv_sec; ?> #srcobjtyp").val()},
                                       {name: "srcobjcod001", value: $("#<?= $lv_sec; ?> #srcobjcod001").val()},
                                       {name: "srcobjcod002", value: $("#<?= $lv_sec; ?> #srcobjcod002").val()},
                                       {name: "sysdocclscod", value: "<?= $vew_data->sysdocclscod; ?>"},
                                       {name: "data", value: JSON.stringify($("#<?= $vew_data->vew_sec; ?>_frm").serializeArray())},
                                       {name: "cteusr", value: "<?= $vew_data->doccteusr; ?>"},
                                       {name: "ctedte", value: "<?= $vew_data->docctedte; ?>"}];
                      tmssCallProcess("?prg=grldatwrk&act=changeStatus", lv_pstdat, function(data){
                        $("#<?= $lv_sec; ?>").replaceWith( data );
                        dialogItself.close();
                      });
                    }}],
            onshown: function(dialogItself){
              // mostrar botón de grabado de formulario si la etapa no está aprobada ni rechazada
              if(<?= $lv_sec; ?>_actstpsts == "S" ){
                $("#" + dialogItself.options.id + " #btnsve").removeClass("hidden");
                
                $("#" + dialogItself.options.id + " #btnrej, #" + dialogItself.options.id + " #btnrel").removeClass("hidden");
                $("#" + dialogItself.options.id + " #btnrej").data("sts", "R");
                $("#" + dialogItself.options.id + " #btnrel").data("sts", "A");
                $("#" + dialogItself.options.id + " #btnrej, #" + dialogItself.options.id + " #btnrel").on("click", function(e){
                  e.preventDefault();
                
                	// grabar formulario
                  $("#" + dialogItself.options.id + " #btnchgsts").data("sts", $(this).data("sts"));
                  $("#" + dialogItself.options.id + " #btngetfrmdat").data("btn_callback", "#btnchgsts");
                 	$("#" + dialogItself.options.id + " .bootstrap-dialog-footer #btnsve").click();
                });
              }else{
              	$("#" + dialogItself.options.id + " #btnsve").remove();
                $("#" + dialogItself.options.id + " #btnrej, #" + dialogItself.options.id + " #btnrel").remove();
              }
            }		
          });
        });
      }else{
        if(<?= $lv_sec; ?>_actstpsts == "S"){
          BootstrapDialog.show({
            title: "<?= $vew_lang->step; ?>: " + lv_wrk['wrkflwstp'][$(this).data("stpdatcod")]['wrkflwstptxt'],
            message: "Desea liberar el paso?",
            buttons: [{ label: "<?= $vew_lang->reject; ?>", id:"btnrej", cssClass: "btn btn-danger pull-left"},
                      { label: "<?= $vew_lang->release; ?>", id:"btnrel", cssClass: "btn btn-success pull-left"}],
            onshown: function(dialogItself){
                $("#" + dialogItself.options.id + " #btnrej").data("sts", "R");
                $("#" + dialogItself.options.id + " #btnrel").data("sts", "A");
                $("#" + dialogItself.options.id + " #btnrej, #" + dialogItself.options.id + " #btnrel").on("click", function(e){
                  e.preventDefault();
                  // cambiar estado del paso
                  var lv_pstdat = [{name: "wrkflwstpdatcod", value: <?= $lv_sec; ?>_actstpdatcod},
                                   {name: "relsts", value: $(this).data("sts")}, 
                                   {name: "lv_sec", value:"<?= $vew_data->vew_sec; ?>"},
                                   {name: "srcobjtyp", value: $("#<?= $lv_sec; ?> #srcobjtyp").val()},
                                   {name: "srcobjcod001", value: $("#<?= $lv_sec; ?> #srcobjcod001").val()},
                                   {name: "srcobjcod002", value: $("#<?= $lv_sec; ?> #srcobjcod002").val()},
                                   {name: "sysdocclscod", value: "<?= $vew_data->sysdocclscod; ?>"},
                                   {name: "data", value: JSON.stringify($("#<?= $vew_data->vew_sec; ?>_frm").serializeArray())},
                                   {name: "cteusr", value: "<?= $vew_data->doccteusr; ?>"},
                                   {name: "ctedte", value: "<?= $vew_data->docctedte; ?>"}];
                  tmssCallProcess("?prg=grldatwrk&act=changeStatus", lv_pstdat, function(data){
                    $("#<?= $lv_sec; ?>").replaceWith( data );
                  });
                  
                  dialogItself.close();
                });
            }
          });
        }
      }
    });
  </script>
  <script>
  	tmssFormEdit("<?= $lv_sec; ?>", false);
  </script>
</section>
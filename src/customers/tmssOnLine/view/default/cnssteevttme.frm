<?php
	// campos requeridos  
	$vew_input->RequiredFields( array() );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = '';
	
	// modulo y programa 
	$lv_mdlcod = 'ZCU';
	$lv_prgcod = 'SU1';

	// libreria de estilos bootstrap 
	include_once('_library.frm');
	
	$lv_sec = ( ($vew_oldSec??'')!='' ? $vew_oldSec : $lv_sec );
	$lv_steevtcod = $vew_data->evtdoc[0]['steevtcod']??'';
	$lv_steevtdoccod = $vew_data->evtdoc[0]['steevtdoccod']??'';
	$lv_assdel = array();
?>
<section id="<?= $lv_sec; ?>">	
	<?= gethtml('steevtcod', 'hidden', $lv_steevtcod); ?>
	<?= gethtml('steevtdoccod', 'hidden', $lv_steevtdoccod); ?>
	<textarea class="hidden" id="steevtdocdat" name="steevtdocdat">"<?= ($vew_data->evtdoc[0]['steevtdocatr']??''); ?>"</textarea>

  <?php if( $vew_actcod != '03' && $vew_actcod != '0' ){ ?>
  <div id="qrdiv" class="panel panel-default hidden">
    <div class="panel-body" style="padding:0px">
      <!-- QR -->
      <div class="col-sm-4" style="padding:0px;"><?php include('grlsyscamqr.frm') ?></div>

      <div class="col-sm-8" style="padding:0px;">
        <div class="col-sm-8">
          <h3 id="hhrempcodextscan"></h3>
          <h3 id="hhremptxtscan" style="margin-top:0px"></h3>
          <h3 id="hhremptaxcod" style="margin-top:0px"></h3>
        </div>
        <div class="col-xs-3"></div>
        <div class="col-sm-4 col-xs-6">
          <div id="hhremppct" style="width:150px;height:150px;border: #a6a6a6 1px solid;background-repeat: no-repeat; background-position: center;background-size: cover;border-radius:90px;" ></div>
        </div>
      </div>
    </div>
  </div>
  <?php } ?>
  
  <table id="evttmetble" class="table table-stripped table-bordered table-hover">
		<thead><tr>
      <th width="50">ID</th><th>Asistente</th>
      <th class="hidden-xs" width="100">Horario</th>
      <th class="text-center" width="100">Asisti&oacute;?</th>
    </tr></thead>
		<tbody>
			<?php
				if($vew_readonly){
					
					foreach($vew_data->evtdoc as $lv_row){
						if($vew_doc->getTagValue($lv_row['steevtdocatr'],'assflg')=='1'){	// solo muestro asistencias en solo lectura
							echo '<tr data-srcobjcod="'.$lv_row['srcobjcod'].'" data-steevtdoccod="'.$lv_row['steevtdoccod'].'">'.
											'<td>'.$vew_doc->getTagValue($lv_row['steevtdocatr'],'srcobjcodext').'</td>'.
											'<td>'.$lv_row['srcobjtxt'].'<small class="visible-xs">'.$vew_doc->getTagValue($lv_row['steevtdocatr'],'tmestr').' - '.$vew_doc->getTagValue($lv_row['steevtdocatr'],'tmeend').'</small></td>'.
											'<td class="hidden-xs"><small>'.$vew_doc->getTagValue($lv_row['steevtdocatr'],'tmestr').' - '.$vew_doc->getTagValue($lv_row['steevtdocatr'],'tmeend').'</small></td>'.
											'<td><input type="checkbox" checked></td>'.
										'</tr>';
						}
					}
				
				} else {
					
					//obtiene loas registros de asistencia del evento y los guarda en un array temporal
					$lv_emp = array();
         	foreach($vew_data->cnsbudmat as $lv_row){
						if(($lv_row['srcobjtyp']=='HHR_EMP' || $lv_row['srcobjtyp']=='BUY_SUP') && !isset($lv_emp[$lv_row['srcobjcod001']])){
							$lv_emp[$lv_row['srcobjcod001']] = array('srcobjtyp'=>$lv_row['srcobjtyp'],
                                                       'srcobjcodext'=>$lv_row['srcobjcodext'],
                                                       'srcobjcod001'=>$lv_row['srcobjcod001'],
                                                       'srcobjtxt'=>$lv_row['srcobjtxt'],
                                                       'assflg'=>0,
                                                       'budmatrow'=>$lv_row['budmatrow'],
                                                       'tmestr'=>$vew_doc->getTagValue($lv_row['budmatatr'],'tmestr'),
                                                       'tmeend'=>$vew_doc->getTagValue($lv_row['budmatatr'],'tmeend'));
              foreach($vew_data->evtdoc as $lv_rowass){
								if($lv_rowass['srcobjtyp']==$lv_row['srcobjtyp'] && $lv_rowass['srcobjcod']==$lv_row['srcobjcod001']){
									$lv_emp[$lv_row['srcobjcod001']]['steevtdoccod'] = $lv_rowass['steevtdoccod'];
									$lv_emp[$lv_row['srcobjcod001']]['assflg'] = $vew_doc->getTagValue($lv_rowass['steevtdocatr'],'assflg');
									break;
								}
							}
						}
					}

					// armo lista de asistencias que no estan incluidas en ningun presupuesto.
					foreach($vew_data->evtdoc as $lv_row){
						if( !isset($lv_emp[$lv_row['srcobjcod']]) ){
							$lv_assdel[] = $lv_row['steevtdoccod'];
						}
					}
					
					// TIEMPOS. actualizo tiempos faltantes de la tarea superior
					foreach($lv_emp as &$lv_rowemp){
						if($lv_rowemp['tmestr']=='' && $lv_rowemp['tmeend']==''){
							foreach( $vew_data->cnsbudmat as $lv_rowbud ){
								if($lv_rowbud['srcobjtyp']=='CNS_TSK' && $lv_rowbud['budmatrow'].'.'==substr($lv_rowemp['budmatrow'],0,strlen($lv_rowbud['budmatrow'].'.'))){
									$lv_rowemp['tmestr'] = $vew_doc->getTagValue($lv_rowbud['budmatatr'],'tmestr');
									$lv_rowemp['tmeend'] = $vew_doc->getTagValue($lv_rowbud['budmatatr'],'tmeend');
									break;
								}
							}
						}
					}
					unset($lv_rowemp);

					foreach($lv_emp as $lv_row){
						echo '<tr data-srcobjtyp="'.$lv_row['srcobjtyp'].'" data-srcobjcod="'.$lv_row['srcobjcod001'].'" data-srcobjcodext="'.$lv_row['srcobjcodext'].'" data-steevtdoccod="'.($lv_row['steevtdoccod']??'').'" data-tmestr="'.$lv_row['tmestr'].'" data-tmeend="'.$lv_row['tmeend'].'">'.
										'<td>'.$lv_row['srcobjcodext'].'</td>'.
										'<td><span name="srcobjtxt">'.$lv_row['srcobjtxt'].'</span><small class="visible-xs">'.($lv_row['tmestr']??'').' - '.($lv_row['tmeend']??'').'</small></td>'.
										'<td class="hidden-xs"><small>'.($lv_row['tmestr']??'').' - '.($lv_row['tmeend']??'').'</small></td>'.
										'<td><input type="checkbox" '.($lv_row['assflg']==1?'checked':'').'></td>'.
									'</tr>';
					}
					
				}
			?>
		</tbody>
	</table>
  <?php if( $vew_actcod != '03' && $vew_actcod != '0' ){ ?>
  	<script>
      //funcion de inicio
      $(function(){
				// revisa que exista una camara
        navigator.mediaDevices.enumerateDevices().then(function(stream){
          //recorre todos los streams para encontrar un input de video
          var lv_videoInput = false;
          for(var i = 0; i < stream.length; i++){ if( stream[i].kind == "videoinput" ){ lv_videoInput = true;break; } }
          
          //revisa si se encontro un input de video y que no exista el boton                                                              
          if( $("#<?= $lv_sec; ?> #qrbtn").length == 0 && lv_videoInput ){
						//añade el boton de qr
            $("#<?= $lv_sec; ?> .tmss-navbar-right").prepend( $("<a href='qrbtn' id='qrbtn' class='btn navbar-btn tmss-navbar-btn' title='<?= $vew_lang->qrCam; ?>'><i style='width:20px' class='fas fa-qrcode'></i></a>").click(function(e){e.preventDefault();
              //revisa que el buffer no este activo
              if( !gv_<?= $lv_sec; ?>_buffer ){ 
                //enciende y apaga el qr
                if( typeof <?= $lv_sec; ?>_toggleVideo=="function" ){
									if ( <?= $lv_sec; ?>_toggleVideo() === true ){
                    //muestra el div del qr
                    $("#<?= $lv_sec; ?> #qrdiv").toggleClass("hidden");
                    //invierte la tabla cuando se abre el escaner si se esta en mobile
                    if( tmssIsMobile() && !$("#<?= $lv_sec; ?> #qrdiv").hasClass("hidden") ){
                      $("#<?= $lv_sec; ?> #cnsstefrm").parent().prependTo( $("#<?= $lv_sec; ?> #cnsstefrm").parents().eq(1) );
                    }else if( tmssIsMobile() ){
                      $("#<?= $lv_sec; ?> #cnsstefrm").parent().appendTo( $("#<?= $lv_sec; ?> #cnsstefrm").parents().eq(1) );
                    }

                  }							
                }
              }
            }) );
          }                                                                                                
        }).catch(function(){  });
      });
      
      //quita los event handlers del boton cerrar
      $("#<?= $lv_sec; ?> #btncls").off("click");
      //añade evento al boton cerrar para cerrar la camara
      $("#<?= $lv_sec; ?> #btncls").click(function(){
        if( typeof gv_<?= $lv_sec; ?>_track != "undefined" ){ gv_<?= $lv_sec; ?>_track.stop(); }
        tmssTabSecCls( $('#<?= $lv_sec; ?>') );
      });
      
      //evento para cerrara la camara al salir
      $("#<?= $lv_sec; ?> .tmss-navbar .tmss-navbar-right .dropdown form li:first, #<?= $lv_sec; ?> .tmss-navbar .tmss-navbar-left .btn-danger, #<?= $lv_sec; ?> .tmss-navbar .tmss-navbar-left .btn-success").click(function(e){e.preventDefault;
        if( typeof gv_<?= $lv_sec; ?>_track != "undefined" ){ gv_<?= $lv_sec; ?>_track.stop(); }
      });
      
      //evento para cerrar camara desde el menu
      //$("#<?= $lv_sec; ?> #tmss-sysmnu")
      
      //configuracion del lector qr
      var gv_<?= $lv_sec; ?>_camData = {scan:"multiple"};
      function <?= $lv_sec; ?>_camAccion( lp_code ){
        try{
          //indice de busqueda
          var lv_searchIndex = lp_code.search("Legajo: ") + 8;
          
          //indice final
          var lv_finalIndex = ( lp_code.length ) - lv_searchIndex;
          
          //revisa si hay que mover el indice final
          for( var i = 0; i < lp_code.substr( lv_searchIndex, lv_finalIndex ).length - 1; i++ ){
            if( isNaN( parseInt( lp_code.substr( lv_searchIndex, lv_finalIndex )[i] ) ) ){
              lv_finalIndex = i;
              break;
            }
          }
          
          //obtiene el codigo del texto plano
          var lv_legajo = lp_code.substr( lv_searchIndex, lv_finalIndex );
          
          //intenta convertir el codigo en numero
          if( lv_legajo == "" ){
            $("#<?= $lv_sec; ?> #hhrempcodextscan").text("");
            $("#<?= $lv_sec; ?> #hhremptxtscan").text("Legajo invalido:" + lv_legajo);
            $("#<?= $lv_sec; ?> #hhremptaxcod").text("");
            $("#<?= $lv_sec; ?> #hhremppct").css("background-image" , "url(https://temasis.com.ar/library/images/TemasisArgentina_Isotipo_280gray.png)" );
            return false; 
          }
        }catch(error){
          $("#<?= $lv_sec; ?> #hhrempcodextscan").text("");
          $("#<?= $lv_sec; ?> #hhremptxtscan").text("Legajo invalido:" + lv_legajo);
          $("#<?= $lv_sec; ?> #hhremptaxcod").text("");
          $("#<?= $lv_sec; ?> #hhremppct").css("background-image" , "url(https://temasis.com.ar/library/images/TemasisArgentina_Isotipo_280gray.png)" );
          return false; 
        }
        
        //obtiene al empleado
        tmssCallProcessErr("?prg=hhremp&act=18", [{name:"hhrempcodext",value:lv_legajo}], function(data){
          //si el empleado existe
          if( data != "" && data.data != "" && data.data != [] ){
          	//obtiene los datos del empleado
            tmssCallProcessNoBackdrop("?prg=hhremp&act=getEmp", [{name:"hhrempcod",value:data.data[0].hhrempcod}],function(data){
              //revisa que el emplado este en la planilla
              if( $("#<?= $lv_sec; ?> #evttmetble tbody tr[data-srcobjcod='"+data.data.hhrempcod+"']").length > 0 ){
                //marca al empleado como que asistio
                $("#<?= $lv_sec; ?> #evttmetble tbody tr[data-srcobjcod='"+data.data.hhrempcod+"']").find(".toggle").each(function(){ if( $(this).hasClass("off")){ $(this).click() }  });

                //muestra los datos del emplpeado
                $("#<?= $lv_sec; ?> #hhrempcodextscan").text( "#" + data.data.hhrempcodext );
                $("#<?= $lv_sec; ?> #hhremptxtscan").text( data.data.hhremptxt );
                $("#<?= $lv_sec; ?> #hhremptaxcod").text( "DNI: " + data.data.tax.taxcod );
                
                //obtiene la foto del empleado
                var lv_pstdat =[{name:"flesrctyp",value:"HHR_EMP"},
                                {name:"flesrccod",value:data.data["hhrempcod"]}];
                tmssCallProcessNoBackdropErr("?prg=grldatupl&act=getFile&prm_main=x&prm_content=x", lv_pstdat, function(data){
                  $("#<?= $lv_sec; ?> #hhremppct").css("background-image" , "url("+(data["flecnt"]!="" && typeof data["flecnt"] != "undefined"? "data:image/jpeg;base64," + data["flecnt"]:"https://temasis.com.ar/library/images/TemasisArgentina_Isotipo_280gray.png")+")" );
                },function(){
                  $("#<?= $lv_sec; ?> #hhremppct").css("background-image" , "url(https://temasis.com.ar/library/images/TemasisArgentina_Isotipo_280gray.png)" );
                })
              }else{ 
                $("#<?= $lv_sec; ?> #hhrempcodextscan").text("");
            		$("#<?= $lv_sec; ?> #hhremptxtscan").text("Legajo invalido:" + data.data.hhrempcod);
            		$("#<?= $lv_sec; ?> #hhremptaxcod").text("");
                $("#<?= $lv_sec; ?> #hhremppct").css("background-image" , "url(https://temasis.com.ar/library/images/TemasisArgentina_Isotipo_280gray.png)" );
              }
            })
          }else{
            $("#<?= $lv_sec; ?> #hhrempcodextscan").text("");
            $("#<?= $lv_sec; ?> #hhremptxtscan").text("Legajo invalido");
            $("#<?= $lv_sec; ?> #hhremptaxcod").text("");
            $("#<?= $lv_sec; ?> #hhremppct").css("background-image" , "url(https://temasis.com.ar/library/images/TemasisArgentina_Isotipo_280gray.png)" );
          }
        },function(){
          //error obteniendo el empleado
          $("#<?= $lv_sec; ?> #hhrempcodextscan").text("");
          $("#<?= $lv_sec; ?> #hhremptxtscan").text("Legajo invalido");
          $("#<?= $lv_sec; ?> #hhremptaxcod").text("");
          $("#<?= $lv_sec; ?> #hhremppct").css("background-image" , "url(https://temasis.com.ar/library/images/TemasisArgentina_Isotipo_280gray.png)" );
        });
      }
    </script>
  <?php } ?>
	<script>
    //añade stylos a los toggles
		tmssLoadScript("toggle",function(){
			$("#<?= $lv_sec; ?> :checkbox").each( function() {
				$(this).bootstrapToggle({ onstyle: "success", offstyle: "default", on: "Si", off: "No", size: "small" });
        //verifica si los toggle deberian estar desabilitados
        <?= ($vew_readonly?'$(this).prop("disabled","disable")':''); ?>
			});
		});
    
    // fija los datos del formulario en los campos como JSON
    function <?= $lv_sec; ?>_sve( lp_sec ){
      //recorre las filas de la tabla de asistencia y guarda los datos
			var lv_assdat = [];
      $("#<?= $lv_sec; ?> table tbody tr").each(function(){
        //obtiene el dato del toggle
        lv_toggle = ($(this).find(".toggle").hasClass("off")?"0":"1");
        // arma el array post
        lv_assdat.push({"steevtdoccod":$(this).data("steevtdoccod"),
												"srcobjtyp":$(this).data("srcobjtyp"),
												"srcobjcod":$(this).data("srcobjcod"),
                        "srcobjtxt":$(this).find("span[name=srcobjtxt]").text(),
												"steevtdocatr": "<tmestr>"+$(this).data("tmestr")+"</tmestr><tmeend>"+$(this).data("tmeend")+"</tmeend><assflg>"+lv_toggle+"</assflg><srcobjcodext>"+$(this).data("srcobjcodext")+"</srcobjcodext>"
											});
			});
			// fija los valores en los campos
			$("#<?= $lv_sec; ?> #steevtdocdat").text( JSON.stringify(lv_assdat) );
			$("#<?= $lv_sec; ?> #steevtdocdatdel").text( "<?= (count($lv_assdel)==0?'[]':json_encode($lv_assdel)); ?>" );
    }
	</script>
</section>
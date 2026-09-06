<?php
	// url del formulario 
  $lv_lnk = '?prg=hltpln&prm_plnvew=plnwek&prm_mdlcod=HLT&prm_prgcod=PLS';

	// campos requeridos 
	$vew_input->RequiredFields( array('') );

	// clave del documento 
	$lv_dockey = '';

	// titulo 
	$lv_title = $vew_lang->planning;

	// módulo y programa 
	$lv_mdlcod = 'HLT';
	$lv_prgcod = 'PLN';

	$vew_actcod='02';

	// librería de estilos bootstrap 
	include_once('_library.frm');

	$lv_color = (strtoupper($vew_doc->getTagValue($vew_mdlprm->mdlatrval001, 'REFERENCE_COLORS_IN_PLANNING'))=='X'?true:false);
	$lv_clrpln = $vew_doc->getTagValue($vew_mdlprm->mdlatrval001, 'STS_PLN_PLN_COLOR');
	$lv_clrevly = $vew_doc->getTagValue($vew_mdlprm->mdlatrval001, 'STS_PLN_EVL_YES_COLOR');
	$lv_clrevln = $vew_doc->getTagValue($vew_mdlprm->mdlatrval001, 'STS_PLN_EVL_NO_COLOR'); 

	$lv_evlplndte = $vew_doc->getTagValue($vew_mdlprm->mdlatrval001, 'STS_EVL_PLN_DTE');

	// Botones por Vista
	$vew_tbl['sveL'] = array('per'=>false);
	$vew_tbl['sveR'] = array('per'=>false);
	$vew_tbl['clsL'] = array('per'=>false);
	$vew_tbl['clsR'] = array('per'=>false);
	$vew_tbl['modL'] = array('per'=>false);
	$vew_tbl['modR'] = array('per'=>false);
	$vew_tbl['new'] = array('per'=>false);
	$vew_tbl['cpy'] = array('per'=>false);
	$vew_tbl['canc'] = array('per'=>false);
	$vew_tbl['dwn'] = array('pos'=>'D', 'per'=>true, 'ttl'=>$vew_lang->download, 'id'=>'tbltoexcel', 'icn'=>'fas fa-download', 'css'=>'tmsslink', 'acc'=>'');
	$vew_tbl['rfrsh'] = array('pos'=>'D', 'per'=>true, 'ttl'=>$vew_lang->refresh, 'id'=>'', 'icn'=>'fas fa-sync-alt', 'css'=>'tmss-Opt', 'acc'=>$lv_sec.'_refresh();');

	$vew_tbl['dteBL'] = array('pos'=>'L', 'per'=>true, 'ttl'=>'','id'=>'btnplnbck', 'icn'=>'fas fa-chevron-left', 'css'=>'btn tmss-navbar-btn tmss-date-back tmss-desk-btn', 'acc'=>$lv_sec.'_prevMonth();');
	$vew_tbl['dteDL'] = array('pos'=>'L', 'per'=>true, 'htm'=>'<div id="plnmthythinp" class="tmss-bold tmss-desk-btn" style="display:inline-block"><input type="text" class="form-control text-center" style="max-width:100px;" value="" id="dtemthyth"></div>');
	$vew_tbl['dteFL'] = array('pos'=>'L', 'per'=>true, 'ttl'=>'', 'id'=>'btnplnfrw', 'icn'=>'fas fa-chevron-right', 'css'=>'btn tmss-navbar-btn tmss-date-forward tmss-desk-btn', 'acc'=>$lv_sec.'_nextMonth();');
	$vew_tbl['plnL'] = array('pos'=>'L', 'per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01'), 'ttl'=>$vew_lang->planning, 'id'=>'btnnewasg', 'icn'=>'far fa-plus', 'css'=>'btn navbar-btn tmssAlwaysEnabled tmss-navbar-btn tmss-desk-btn btn-success', 'acc'=>'');
	$vew_tbl['plnR'] = array('pos'=>'R', 'per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'01'), 'tooltip'=>$vew_lang->planning, 'id'=>'btnnewasgR', 'icn'=>'far fa-plus', 'css'=>'btn navbar-btn tmssAlwaysEnabled tmss-navbar-btn tmss-mob-btn btn-success', 'acc'=>'');
	$vew_tbl['flt'] = array('pos'=>'R', 'per'=>$vew_sec->hasPermission($lv_mdlcod,$lv_prgcod,'03'), 'ttl'=>'', 'id'=>'btnflt', 'icn'=>'fas fa-filter', 'css'=>'btn navbar-btn tmssAlwaysEnabled tmss-navbar-btn '.($vew_actcod != '02' ? ' tmssHiddeOnEdit':''), 'acc'=>'');

?>
<section id="<?= $lv_sec; ?>" data-title="<?= $lv_title; ?>">
  <?php include('grldocfrmtlb.frm'); ?>
	
  <form method="POST" class="form-horizontal" id="<?= $lv_sec; ?>_frm">
    <?= gethtml('tmss_actcod','hidden',''); ?>
    <?= gethtml('vewflt','hidden',''); ?>
		<?= gethtml('vewfltdat','hidden',$vew_data->vewfldfltdat); ?>
    
		<div class="container-fluid">
      <div class="tmss-hltplnwek-mob text-center" style="padding-top:15px;">
  			<ul class="d-flex justify-content-center" style="justify-content: center;">
          <button type="button" id="btnplnbck" onclick="<?= $lv_sec ?>_prevMonth();" class="btn tmss-date-back tmss-mob-btn"><i class="fas fa-chevron-left"></i></button>
          <div id="plnmthythinp" class="tmss-bold tmss-mob-btn" style="display:inline-block">
            <input type="text" class="form-control text-center" style="max-width:100px;" value="" id="dtemthyth">
          </div>
          <button type="button" id="btnplnfrw" onclick="<?= $lv_sec ?>_nextMonth();" class="btn tmss-date-forward tmss-mob-btn"><i class="fas fa-chevron-right"></i></button>
				</ul>
      </div>   
      <div class="tmss-hltplnwek-table" style="overflow:auto;">
        <table class="table table-condensed" id="tblplnwek">
          <thead>
            <tr class="active">
              <th class="" width="200"><?= $vew_lang->patient; ?></th>
              <th class="" width="200"><?= $vew_lang->provider; ?></th>
              <th class="hidden" width="500"><?= $vew_lang->diseaseclassification; ?></th>
              <th class="hidden" width="500"><?= $vew_lang->specialty; ?></th>
              <th class="hidden" width="500"><?= $vew_lang->provider; ?></th>
              <th id="sem001" class="text-center text-nowrap" width="200"></th>
              <th id="sem002" class="text-center text-nowrap" width="200"></th>
              <th id="sem003" class="text-center text-nowrap" width="200"></th>
              <th id="sem004" class="text-center text-nowrap" width="200"></th>
              <th id="sem005" class="text-center text-nowrap" width="200"></th>
              <th id="sem006" class="text-center text-nowrap" width="200"></th>
            </tr>
          </thead>
          <tbody>
          </tbody>
        </table>
      </div>
		</div>
	</form>
	<script>
  	$("#<?= $lv_sec; ?> #dtemthyth").val("<?= $vew_data->plnmth; ?>/<?= $vew_data->plnyth; ?>");
		var <?= $lv_sec; ?>_mth = <?= $vew_data->plnmth; ?>;
		var <?= $lv_sec; ?>_yth = <?= $vew_data->plnyth; ?>;
		<?= $lv_sec; ?>_setWeek();
    
    function <?= $lv_sec; ?>_setWeek(){
        let lv_bufdtehdr = [];
        // Ultimo dia de la primer semana
        let lv_bufwek = (moment($("#<?= $lv_sec; ?> #dtemthyth").val(),"MM/YYYY")).day(6).date();
        // Ultimo dia del mes
        let lv_buflstday = moment($("#<?= $lv_sec; ?> #dtemthyth").val(),"MM/YYYY").endOf("month").date();
        // Semanas
        lv_bufdtehdr[1] = "01 - 0"+lv_bufwek;
        lv_bufdtehdr[2] = "0"+(lv_bufwek+1)+" - "+(lv_bufwek+7<10?"0":"")+(lv_bufwek+7);
        lv_bufdtehdr[3] = (lv_bufwek+8<10?"0":"")+(lv_bufwek+8)+" - "+(lv_bufwek+14);
        lv_bufdtehdr[4] = (lv_bufwek+15)+" - "+(lv_bufwek+21);
        lv_bufdtehdr[5] = (lv_bufwek+22)+" - "+(lv_buflstday>=lv_bufwek+28?lv_bufwek+28:lv_buflstday);
        lv_bufdtehdr[6] = (lv_buflstday>=lv_bufwek+29?(lv_bufwek+29)+" - "+(lv_buflstday>=lv_bufwek+35?lv_bufwek+35:lv_buflstday):"");
      	$("#<?= $lv_sec; ?> #sem001").text(lv_bufdtehdr[1]);
        $("#<?= $lv_sec; ?> #sem002").text(lv_bufdtehdr[2]);
        $("#<?= $lv_sec; ?> #sem003").text(lv_bufdtehdr[3]);
        $("#<?= $lv_sec; ?> #sem004").text(lv_bufdtehdr[4]);
        $("#<?= $lv_sec; ?> #sem005").text(lv_bufdtehdr[5]);
        $("#<?= $lv_sec; ?> #sem006").text(lv_bufdtehdr[6]);
    } 
    
		// Mes Siguiente. Desplaza los datos al mes siguiente
		function <?= $lv_sec; ?>_nextMonth(){
			<?= $lv_sec; ?>_mth = (<?= $lv_sec; ?>_mth==12?1:<?= $lv_sec; ?>_mth+1);
			<?= $lv_sec; ?>_yth += (<?= $lv_sec; ?>_mth==1?1:0);
  		$("#<?= $lv_sec; ?> #dtemthyth").val(<?= $lv_sec; ?>_mth+"/"+<?= $lv_sec; ?>_yth);
			<?= $lv_sec; ?>_refresh();
		}
    
		// Mes Anterior. Desplaza los datos al mes anterior
		function <?= $lv_sec;?>_prevMonth(){
			<?= $lv_sec; ?>_mth = (<?= $lv_sec; ?>_mth==1?12:<?= $lv_sec; ?>_mth-1);
			<?= $lv_sec; ?>_yth -= (<?= $lv_sec; ?>_mth==12?1:0);
      $("#<?= $lv_sec; ?> #dtemthyth").val(<?= $lv_sec; ?>_mth+"/"+<?= $lv_sec; ?>_yth);
			<?= $lv_sec; ?>_refresh();
		}

		// Nro de Semana. Dada una fecha devuelve el nro de semana del mes en la que cae (1,2,3,4 o 5)
		function <?= $lv_sec; ?>_getWeekOfMonth(lp_date) {
			const lv_dte = moment(lp_date.date, "YYYY-MM-DD HH:mm:ss.SSSSSS");
			const lv_firstDayOfMonth = lv_dte.clone().startOf("month");
			const lv_dayOfMonth = lv_dte.date();
			const lv_firstDayOfWeek = lv_firstDayOfMonth.day();
			return Math.ceil((lv_dayOfMonth + lv_firstDayOfWeek) / 7);
		}		
    
		// Refresh. Obtiene y actualiza toda la tabla
		function <?= $lv_sec; ?>_refresh(){
      <?= $lv_sec; ?>_setWeek();
			var lv_flt = $("#<?= $lv_sec; ?> #vewflt").val();
      var lv_tmp =  ((lv_flt)?JSON.parse(lv_flt):[]);
      
			$("#<?= $lv_sec; ?> #tblplnwek tbody").html("<tr><td colspan='10'><i class='far fa-gear fa-spin'></i> Cargando datos...</td></tr>");
			// capturar mes y anio y estructura de filtro actual
			var lv_pstdat =[{name:"plnmth",value:<?= $lv_sec; ?>_mth},
											{name:"plnyth",value:<?= $lv_sec; ?>_yth},
											{name:"getjson",value:"X"},
											{name:"evlplndte", value:"<?= ($lv_evlplndte!=''?'X':''); ?>"},
                      {name:"vewfldflt",value: lv_tmp["fltstr"]},
                      {name:"vewmaxrec",value: lv_tmp["maxrec"]}   ];
      
			// obtiene los datos
			tmssCallProcessNoBackdrop('?prg=hltpln&prm_plnvew=plnwek&prm_mdlcod=HLT&prm_prgcod=PLS',lv_pstdat,function(data){
				// ante un fallo de SQL (p.ej. filtro invalido) el SP devuelve una fila {errtyp:'E',errcod,errtxt} en lugar de datos.
				// sin esta guarda se renderiza una fila con todos los campos "undefined".
				let lv_err = ( Array.isArray(data) && data[0] && (data[0].errtyp=='E' || (data[0].patcod===undefined && data[0].errtxt!=undefined)) );
				if( lv_err ){
					// detalle tecnico para el dev, sin bloquear al usuario
					toastr.warning( (data[0].errtxt || 'Error desconocido') + (data[0].errcod!=undefined ? ' ['+data[0].errcod+']' : ''), "Error al obtener las planificaciones" );
				}
				if( lv_err || !Array.isArray(data) || data.length==0 || data[0].patcod===undefined ){
					$("#<?= $lv_sec; ?> #tblplnwek tbody").html("<tr><td colspan='10'>No se encontraron datos.</td></tr>");
				} else {
					lv_buffer=""; lv_wek=["","","","","",""];
          let lv_key=data[0].patcod+"_"+data[0].prscod+"_"+data[0].spccod;
					for(var i=0; i<data.length; i++) {
						let lv_key_next = "";
						if( i!=data.length && data[i+1]!=undefined ){ lv_key_next = data[i+1].patcod+"_"+data[i+1].prscod+"_"+data[i+1].spccod; }
						
					 // determino en que semana cae la planificacion, si tiene fecha de evaluacion le doy esa fecha
						let lv_plndte = <?= ($lv_evlplndte!=''?'(data[i].evlcod && data[i].evldte)?data[i].evldte:data[i].plndte':'data[i].plndte')?>;
           	let lv_dteformat = (lv_plndte && lv_plndte.date) ? moment(lv_plndte.date, "YYYY-MM-DD HH:mm:ss.SSSSSS").format("DD/MM/YYYY") : "";
            let lv_dtenow = moment({ year: <?= $lv_sec; ?>_yth, month: <?= $lv_sec; ?>_mth - 1 });

            // Verifico si el mes de la planificacion coincide con el mes actual, por si se cambio por la evaluacion y pertenece a otro mes.
            if(lv_dteformat!="" && moment(lv_dteformat,"DD/MM/YYYY").isSame(lv_dtenow,'month')){
              let lv_stsclr = getStatusColor( {"pln": "<?=$lv_clrpln;?>","evly": "<?=$lv_clrevly;?>","evln": "<?=$lv_clrevln;?>"},{"prsntfdte":data[i].prsntfdte, "evlcod":data[i].evlcod,"evlsts":data[i].evlsts, "hltlqdid":"", "slslqdid":""} , <?=$lv_color;?> );
              let lv_num = <?= $lv_sec; ?>_getWeekOfMonth( lv_plndte ) - 1;

							//obtiene el color para la fecha
              let  lv_dteclr = (lv_stsclr.stsclr!=""?"background-color:"+lv_stsclr.stsclr:"");

							//creo los datos del elemento
              lv_wek[lv_num] += "<div name='pln' data-plnid='"+data[i].plnid+"' data-plndteid='"+data[i].plndteid+"' title='"+lv_stsclr.ststxt+"' style='"+lv_dteclr+"'>";
              const lv_parser = new DOMParser();
							const lv_doc = lv_parser.parseFromString(data[i].plndteatr || '<usricn></usricn>', 'text/html');
							const lv_icn = lv_doc.querySelector('usricn')?.textContent || '';

             //booleano para mostrar los iconos
              let lv_dteShw = ( data[i].hltplnctrdte!= null || data[i].plncnfdte!=null || data[i].patntfdte!=null || lv_icn!='' ? true : false );

              //obtengo los iconos del elemento
              let lv_dteIcnsL = "<div class='dteicnrgt text-center'><i class= 'fas fa-"+((data[i].hltplnctrdte!='' && data[i].hltplnctrdte != null)?((typeof(data[i].deldte) !== 'undefined' && data[i].deldte !== null)?'times':'check') : "" )+"' ></i><i class= 'fas fa-"+((data[i].patntfdte!='' && (data[i].patntfdte) !== null) ?'envelope':'')+"' ></i></div>";
              let lv_dteIcnsR = "<div class='dteicnlft text-center'><i class= 'fas fa-thumbs-"+((data[i].plncnfdte!='' && (data[i].plncnfdte) !== null) ?'up':'')+"' ></i><i class='fas "+(lv_icn!='' ? lv_icn.toLowerCase() : '' )+"'></i></div>";

							//obtengo la fecha a mostrar
              lv_dte = "<a href=# class='tmss-hltplnwek-date text-center"+( !lv_dteShw ? 'icnles' : '' )+"'>"+ lv_dteformat + "</a>";

              lv_wek[lv_num] +=( lv_dteShw ? lv_dteIcnsL : "" )+lv_dte+( lv_dteShw ? lv_dteIcnsR : "" )+"</div>";
            }
						
						// corte de control por paciente/prestador o fin de registros
						if(lv_key!=lv_key_next){
							lv_buffer +="<tr " +(data[i].spcclr ? ('style="background-color: ' + data[i].spcclr + ';"') : "") + ">"         
												+"<td><a href='#' name='patlnk' data-patcod='"+data[i].patcod+"'>"+data[i].pattxt+"</a><br> <small>"+(data[i].hltdisclstxt??"")+"</small> </td>"
												+"<td><a href='#' name='prslnk' data-prscod='"+data[i].prscod+"'>"+data[i].prstxt+"</a><br><small>"+data[i].spctxt+"</small></td>"
												+"<td>"+lv_wek[0]+"</td><td>"+lv_wek[1]+"</td><td>"+lv_wek[2]+"</td><td>"+lv_wek[3]+"</td><td>"+lv_wek[4]+"</td><td>"+lv_wek[5]+"</td>";
							lv_key="";
							if( i!=data.length && data[i+1]!=undefined ){ lv_key = data[i+1].patcod+"_"+data[i+1].prscod+"_"+data[i+1].spccod; }
							lv_wek=["","","","","",""];
						}
					}
					$("#<?= $lv_sec; ?> #tblplnwek tbody").html(lv_buffer);

					// attach eventos
					<?php if($vew_sec->hasPermission("HLT","PAT","03")){ ?>
					$("#<?= $lv_sec; ?> a[name='patlnk']").on("click",function(e){ e.preventDefault();
						tmssLink("?prg=hltpat&act=03&prm_patcod="+$(this).data("patcod"), [{target: "_new_section",target_id: "#<?= $lv_sec; ?>"}]);
					});
					<?php } ?>					
					<?php if($vew_sec->hasPermission("HLT","PRS","03")){ ?>
					$("#<?= $lv_sec; ?> a[name='prslnk']").on("click",function(e){ e.preventDefault();
						tmssLink("?prg=hltprs&act=03&prm_prscod="+$(this).data("prscod"), [{target: "_new_section",target_id: "#<?= $lv_sec; ?>"}]);
					});
					<?php } ?>	
        	// editar planificación
        	<?php if($vew_sec->hasPermission('HLT','PLN','03') || $vew_sec->hasPermission('HLT','PLN','02')){ ?>
            $("#<?= $lv_sec; ?> div[name=pln]").on("click",function(e){ e.preventDefault(); 
            var lv_pstdat = { plnid: $(this).data("plnid"),  plndteid: $(this).data("plndteid"), plnvew: "plnwek" };
          	tmssCallProcess("?prg=hltpln&act=<?= ($vew_sec->hasPermission('HLT','PLN','02')?'02':'03'); ?>&prm_plnvew=plnwek&prm_popup=<?= $lv_sec; ?>", lv_pstdat, function(data){
              BootstrapDialog.show({
                title: "<?= $vew_lang->planning; ?>",
                message: $(data),
                size: BootstrapDialog.SIZE_WIDE,
                onshown: function(dialog) {
                  dialog.getModalBody().find("#noupdate").val("X");
                },
                onhidden: function(dialog) {
                  var noupdate = dialog.getModalBody().find("#noupdate").val(); 
                  if (noupdate !== "X") { <?= $lv_sec; ?>_refresh(); }
                }
              });
            });
          });		
        <?php } ?>
				}
			});
		}
	
    tmssLoadScript("table2excel",function(){
			$("#<?= $lv_sec; ?> #tbltoexcel").on("click",function(e){ e.preventDefault();
				//crea una copia de la tabla
        var lo_tbl = $("#<?= $lv_sec; ?> .tmss-hltplnwek-table").clone();
        
        //acomoda la tabla para la descarga
        lo_tbl.find("div[name='pln']").find(".dteicnrgt, .dteicnlft").remove();
        lo_tbl.find("#sem001, #sem002, #sem003, #sem004, #sem005, #sem006").each(function(){ 
          $(this).text( $(this).text().replace(" - ", "_") );
          $(this).width(100);
        });
        lo_tbl.find("div[name='pln']").each(function(e){ $(this).css("background-color", "") });
				
				//convierte la tabla a excel
        lo_tbl.table2excel({
					exclude: ".hidden-print",
					name: "Planificacion semanal",
					filename: 'evllst' + new Date().toISOString().replace(/[\-\:\.]/g, ""),
					fileext: ".xlsx",
					exclude_img: true,
					exclude_links: true,
					exclude_inputs: true
				});
			});
		}); 
	</script>
  <script>
  	$(function(){
      //si se desplazo la vista se agregan clases al navbar para que sea visible
      if ($(window).scrollTop() > 50) {
        $("#<?= $lv_sec; ?> .navbar-fixed-top").removeClass("tmss-shadow");
        $("#<?= $lv_sec; ?> .tmss-navbar-fixed").addClass("tmss-navbar-fixed-hold").parent().css("padding-top","50px");
      } else {
        $("#<?= $lv_sec; ?> .navbar-fixed-top").addClass("tmss-shadow");
        $("#<?= $lv_sec; ?> .tmss-navbar-fixed").removeClass("tmss-navbar-fixed-hold").parent().css("padding-top","");
      }
    })
  </script>
	<script>
    //agrega un badge al filtro
    $(function(){ $("#<?= $lv_sec; ?> #btnflt").append("<span id='fltcnt' class='badge'></span>"); })

    //añade el datepicer a la barra de desplazamiento
    $("#<?= $lv_sec; ?> #plnmthythinp input").datepicker({
        format: "mm/yyyy",
        startView: "months", 
        minViewMode: "months"
    }).on("change",function(e){
      //cierra el datepicker cuando se selecciona un mes
      $("#<?= $lv_sec; ?> .datepicker").hide();
      //cambia el valor del campo fecha
      let lv_dte = $(this).val().split("/");
			
   		<?= $lv_sec; ?>_mth =+lv_dte[0];
  		<?= $lv_sec; ?>_yth =+lv_dte[1];
      
      //recarga la vista
     <?= $lv_sec; ?>_refresh();
    });
	
		// Planificacion
    $("#<?= $lv_sec; ?> #btnnewasg, #<?= $lv_sec; ?> #btnnewasgR").on("click",function(e){ e.preventDefault();
			var lv_pstdat = { plnvew: "plnwek" };
			tmssCallProcess("?prg=hltpln&act=01&prm_plnvew=plnwek&prm_popup=<?= $lv_sec; ?>", lv_pstdat, function(data){
				BootstrapDialog.show({
					title: "<?= $vew_lang->planning; ?>",
					message: $(data),
					size: BootstrapDialog.SIZE_WIDE,
          onshown: function(dialog) {
            dialog.getModalBody().find("#noupdate").val("X");
          },
          onhidden: function(dialog) {
            var noupdate = dialog.getModalBody().find("#noupdate").val();
            if (noupdate !== "X") { <?= $lv_sec; ?>_refresh(); }
          }
				});
			});
		});
	</script>
	<script> 
    //FILTRO PERSONALIZADO
		var gv_<?= $lv_sec; ?>_flt=[ 
      													{'fldttl': '<?= $vew_lang->ID; ?>' ,'fldcod': 'p.patcod', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
      													{'fldttl': '<?= $vew_lang->patient; ?>'   ,'fldcod': 'p.pattxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
                                {'fldttl': '<?= $vew_lang->region; ?>' ,'fldcod': 'pal.lndregtxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
                                {'fldttl': '<?= $vew_lang->EXTERNALCODE; ?>' ,'fldcod': 'p.PatCodExt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
                                {'fldttl': '<?= $vew_lang->PATIENTSCLASSIFICATION; ?>' ,'fldcod': 'pc.hltpatclstxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},                                
																{'fldttl': '<?= $vew_lang->specialty; ?>' ,'fldcod': 's.spctxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->provider; ?>'  ,'fldcod': 'r.prstxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->Financial; ?>'	,'fldcod': 'c.custxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->status; ?>'	 	,'fldcod': 'pld.evldocsts', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->DISEASECLASSIFICATION; ?>','fldcod': 'dc.hltdisclstxt', 'fldtyp': 'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldttl': '<?= $vew_lang->date; ?>'	 		,'fldcod': 'pld.plndte','fldtyp':'DATE', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
      													{'fldttl': '<?= $vew_lang->CONTROLDATE; ?>'	,'fldcod': 'pld.hltplnctrdte','fldtyp':'DATE', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
            										{'fldttl': '<?= $vew_lang->ATTENTIONCENTER; ?>'	,'fldcod': 'd.deltxt','fldtyp':'TEXT', 'flttyp': '', 'fldvalstr': '','fldvalend': ''},
																{'fldcod': 'vewmaxrec','fldvalstr': '<?= ($vew_data->vewmaxrec!=''?$vew_data->vewmaxrec:'1000') ?>'}];

		// filtro - boton
		$("#<?= $lv_sec; ?> #btnflt").on("click",function(e){ e.preventDefault();
			tmssFilterShowDialog(gv_<?= $lv_sec; ?>_flt,<?= $lv_sec; ?>_filtWeek,"VEW_HLT_PLN_WEK");
		});

		//Filtros
		function <?= $lv_sec; ?>_filtWeek(lp_flt) {
			var lv_fltint;
			if(lp_flt!=null){
				lv_fltint = tmssFilterParseToInternal(lp_flt);
				gv_<?= $lv_sec; ?>_flt = lp_flt;
				$("#<?= $lv_sec; ?> #fltcnt").text( (lv_fltint["fltqty"]==0?"":lv_fltint["fltqty"]) );
			} else {
				lv_fltint = tmssFilterParseToInternal(gv_<?= $lv_sec; ?>_flt);
			}
			if(lv_fltint["maxrec"]==""){lv_fltint["maxrec"]="1000";}

			if(lv_fltint!=$("#<?= $lv_sec; ?> #vewflt").prop("value")){
				$("#<?= $lv_sec; ?> #vewflt").prop("value",JSON.stringify(lv_fltint));
				<?= $lv_sec; ?>_refresh();
			}
		}
    function getStatusColor(lp_colors, lp_prm = {}, lp_color = false) {
      let lv_plnsts = { ststxt: "Planificado", stsclr: lp_color ? lp_colors.pln : "", stschk: true };

      if (lp_prm.evlcod) { lv_plnsts = { ststxt: "Evolucionado" + (lp_prm.evlsts === "P" ? " Prestación no realizada [Sin Srv]" : ""),stsclr: lp_color ? (lp_prm.evlsts === "P" ? lp_colors.evln : lp_colors.evly) : "", stschk: true }; }
      if (lp_prm.hltlqdid) {  lv_plnsts = { ststxt: "Liquidación Prestador", stsclr: "", stschk: true }; }
      if (lp_prm.slslqdid) {  lv_plnsts = { ststxt: "Liquidación Cliente", stsclr: "", stschk: true }; }
      return lv_plnsts;
    }
		$(function(){
      gv_<?= $lv_sec; ?>_flt=tmssFilterParseToExternal( gv_<?= $lv_sec; ?>_flt , $("#<?= $lv_sec; ?> #vewfltdat").val() );
			<?= $lv_sec; ?>_filtWeek(gv_<?= $lv_sec; ?>_flt);
		});
	</script>
	
	<?php include('grldocfrmscr.frm'); ?>
</section>